Return-Path: <kvm+bounces-42138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F80A73E78
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3890B189D06E
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67DC21C5D63;
	Thu, 27 Mar 2025 19:21:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0B674BE1
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743103286; cv=none; b=HGzJyX6Cn9zaT88WDIA5NGUlBwiH7jBUCLDC4ukOZMDKOo/dS6ttvApiJqzX2+D7qL/806C5CH/mVUiIyq+EPT0lr/XPzhuBwOadxSZzSOy/L5X73IPuYeNuKR4PnGRNbsNvB3zX0D1vyC466b982RrNSLAOGkyjoKXw0yGz84Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743103286; c=relaxed/simple;
	bh=9+BGXhXNf2GFR4HdmtXyoEsvPZs5fln/5ulxo/IohnU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dOVoRybpmzGyhx7ns+L2wV4Vh1FQVS2lB0FIW1V5mFrYmhSFyVAt2s1zayXPOgUcIqRxOcYctvW5KI587fx/WffjTn4JTcksksRHKnNPx9zqmU6JvdoC4N5CNarC/KLZ8k9FXM9ba0A3T6Ny+G6PPe+SPoaP2F3ctdI+ZprZyvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.1)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1txrtw-00000000T8V-1ZU8;
	Thu, 27 Mar 2025 19:24:24 +0100
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH] target/i386: Reset parked vCPUs together with the online ones
Date: Thu, 27 Mar 2025 19:24:16 +0100
Message-ID: <e8b85a5915f79aa177ca49eccf0e9b534470c1cd.1743099810.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: mhej@vps-ovh.mhejs.net

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Commit 3f2a05b31ee9 ("target/i386: Reset TSCs of parked vCPUs too on VM
reset") introduced a way to reset TSCs of parked vCPUs during VM reset to
prevent them getting desynchronized with the online vCPUs and therefore
causing the KVM PV clock to lose PVCLOCK_TSC_STABLE_BIT.

The way this was done was by registering a parked vCPU-specific QEMU reset
callback via qemu_register_reset().

However, it turns out that on particularly device-rich VMs QEMU reset
callbacks can take a long time to execute (which isn't surprising,
considering that they involve resetting all of VM devices).

In particular, their total runtime can exceed the 1-second TSC
synchronization window introduced in KVM commit 5d3cb0f6a8e3 ("KVM:
Improve TSC offset matching").
Since the TSCs of online vCPUs are only reset from "synchronize_post_reset"
AccelOps handler (which runs after all qemu_register_reset() handlers) this
essentially makes that fix ineffective on these VMs.

The easiest way to guarantee that these parked vCPUs are reset at the same
time as the online ones (regardless how long it takes for VM devices to
reset) is to piggyback on post-reset vCPU synchronization handler for one
of online vCPUs - as there is no generic post-reset AccelOps handler that
isn't per-vCPU.

The first online vCPU was selected for that since it is easily available
under "first_cpu" define.
This does not create an ordering issue since the order of vCPU TSC resets
does not matter.

Fixes: 3f2a05b31ee9 ("target/i386: Reset TSCs of parked vCPUs too on VM reset")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 accel/kvm/kvm-all.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f89568bfa397..951e8214e079 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -437,9 +437,8 @@ int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
     return kvm_fd;
 }
 
-static void kvm_reset_parked_vcpus(void *param)
+static void kvm_reset_parked_vcpus(KVMState *s)
 {
-    KVMState *s = param;
     struct KVMParkedVcpu *cpu;
 
     QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
@@ -2738,7 +2737,6 @@ static int kvm_init(MachineState *ms)
     }
 
     qemu_register_reset(kvm_unpoison_all, NULL);
-    qemu_register_reset(kvm_reset_parked_vcpus, s);
 
     if (s->kernel_irqchip_allowed) {
         kvm_irqchip_create(s);
@@ -2908,6 +2906,10 @@ static void do_kvm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg
 void kvm_cpu_synchronize_post_reset(CPUState *cpu)
 {
     run_on_cpu(cpu, do_kvm_cpu_synchronize_post_reset, RUN_ON_CPU_NULL);
+
+    if (cpu == first_cpu) {
+        kvm_reset_parked_vcpus(kvm_state);
+    }
 }
 
 static void do_kvm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)

