Return-Path: <kvm+bounces-10947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE657871C66
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:58:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C9142853FE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96625C60F;
	Tue,  5 Mar 2024 10:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9QGpAMk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718625C5E6
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709635964; cv=none; b=ROMHP2SvMLq/0j+4k3HefUyng9hu38xz+Gj1hLshnU2oTI/NadoeJ+GPovugR5eFYDKuqCuJG8bQmreA5LmEm2Kp0bljClmwyHK3pBALWQM4WW9NgyNByTcfXd0qqtZJe6IGqUeTiLBuppH1z+r3yS4m2WHkCRIbrx25JPRnQ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709635964; c=relaxed/simple;
	bh=Wnzp5lQJxs+jQRinDLQGLFZFekcKJbKOp4sA2sFpFFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFFWFoJM3G+4q4bu+0JvpMTZFTjByTxaBq2rANKyhYReweEHZVQCKmS5WQQoOfL+CSSxnZuM83sWOOnN9VkNuD0oO1Ohavlx3/bgHlVppF+RVh8MrsllCjwLOA7b8Fq5CO7X9psWrQ+T7kGYJ8ZeKA5uq/Tt8tYeDFwHKuxLsy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T9QGpAMk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709635961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KoDAdVvAtqnayVlE8EtKosf5mdOj9vF/AiWcYKGpwEk=;
	b=T9QGpAMkKgVkBroUqycXC67WJohW4B/6xzZFDjqAx0HWOi9nmYbJfLXbZ2+v7kEChCvDqx
	jSGn+BG15xqxhgTB/urU0TvTueuM0FgXCDmIHm0FmADF4s4e/q1fLwlZf98a9V70Jtvfqz
	/xjd1aI2mIfv7t9XDiV2CwL2hyh923Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-E3Ms1lVLM1GzvuYO1LxXVw-1; Tue, 05 Mar 2024 05:52:37 -0500
X-MC-Unique: E3Ms1lVLM1GzvuYO1LxXVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D25F3851784;
	Tue,  5 Mar 2024 10:52:36 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.36])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E34CF8173;
	Tue,  5 Mar 2024 10:52:35 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 530091800D5B; Tue,  5 Mar 2024 11:52:33 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v2 2/2] kvm: add support for guest physical bits
Date: Tue,  5 Mar 2024 11:52:33 +0100
Message-ID: <20240305105233.617131-3-kraxel@redhat.com>
In-Reply-To: <20240305105233.617131-1-kraxel@redhat.com>
References: <20240305105233.617131-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Query kvm for supported guest physical address bits, in cpuid
function 80000008, eax[23:16].  Usually this is identical to host
physical address bits.  With NPT or EPT being used this might be
restricted to 48 (max 4-level paging address space size) even if
the host cpu supports more physical address bits.

When set pass this to the guest, using cpuid too.  Guest firmware
can use this to figure how big the usable guest physical address
space is, so PCI bar mapping are actually reachable.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/cpu.h     |  1 +
 target/i386/cpu.c     |  1 +
 target/i386/kvm/kvm.c | 17 +++++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 952174bb6f52..d427218827f6 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2026,6 +2026,7 @@ struct ArchCPU {
 
     /* Number of physical address bits supported */
     uint32_t phys_bits;
+    uint32_t guest_phys_bits;
 
     /* in order to simplify APIC support, we leave this pointer to the
        user */
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2666ef380891..1a6cfc75951e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
             /* 64 bit processor */
              *eax |= (cpu_x86_virtual_addr_width(env) << 8);
+             *eax |= (cpu->guest_phys_bits << 16);
         }
         *ebx = env->features[FEAT_8000_0008_EBX];
         if (cs->nr_cores * cs->nr_threads > 1) {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7298822cb511..ce22dfcaa661 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -238,6 +238,15 @@ static int kvm_get_tsc(CPUState *cs)
     return 0;
 }
 
+/* return cpuid fn 8000_0008 eax[23:16] aka GuestPhysBits */
+static int kvm_get_guest_phys_bits(KVMState *s)
+{
+    uint32_t eax;
+
+    eax = kvm_arch_get_supported_cpuid(s, 0x80000008, 0, R_EAX);
+    return (eax >> 16) & 0xff;
+}
+
 static inline void do_kvm_synchronize_tsc(CPUState *cpu, run_on_cpu_data arg)
 {
     kvm_get_tsc(cpu);
@@ -1730,6 +1739,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
     uint32_t limit, i, j, cpuid_i;
+    uint32_t guest_phys_bits;
     uint32_t unused;
     struct kvm_cpuid_entry2 *c;
     uint32_t signature[3];
@@ -1765,6 +1775,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
 
+    guest_phys_bits = kvm_get_guest_phys_bits(cs->kvm_state);
+    if (guest_phys_bits &&
+        (cpu->guest_phys_bits == 0 ||
+         cpu->guest_phys_bits > guest_phys_bits)) {
+        cpu->guest_phys_bits = guest_phys_bits;
+    }
+
     /*
      * kvm_hyperv_expand_features() is called here for the second time in case
      * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibly handle
-- 
2.44.0


