Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A345D3373E3
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 14:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbhCKN3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 08:29:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233610AbhCKN2y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 08:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615469333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZKrgnsUmWJ3UzHyrpBLpzaQDnaWIoZ/zFnog8cM5uQs=;
        b=YUVSvCxPdlGE7VmaJGiJtHidklgeNqwzFEezTe2B1UmOTF0RYA17+WFKBSWFO8c3OpSea9
        6sVOFt/Aj5JudRUr8apVRbjG2TU+Z7VjtSBLG3pMnQryPRZUcV5ImUGH6kPMVHoDEqZAxb
        7lVVew/zEP+x5MYBC0glE4y0uHadEMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-GNCw1OkIOT6OqIp_gq2aJg-1; Thu, 11 Mar 2021 08:28:52 -0500
X-MC-Unique: GNCw1OkIOT6OqIp_gq2aJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 832421934100;
        Thu, 11 Mar 2021 13:28:50 +0000 (UTC)
Received: from lszubowi.redhat.com (ovpn-0-2.rdu2.redhat.com [10.22.0.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 417FA1001B2C;
        Thu, 11 Mar 2021 13:28:48 +0000 (UTC)
From:   Lenny Szubowicz <lszubowi@redhat.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/kvmclock: Stop kvmclocks for hibernate restore
Date:   Thu, 11 Mar 2021 08:28:47 -0500
Message-Id: <20210311132847.224406-1-lszubowi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Turn off host updates to the registered kvmclock memory
locations when transitioning to a hibernated kernel in
resume_target_kernel().

This is accomplished for secondary vcpus by disabling host
clock updates for that vcpu when it is put offline. For the
primary vcpu, it's accomplished by using the existing call back
from save_processor_state() to kvm_save_sched_clock_state().

The registered kvmclock memory locations may differ between
the currently running kernel and the hibernated kernel, which
is being restored and resumed. Kernel memory corruption is thus
possible if the host clock updates are allowed to run while the
hibernated kernel is relocated to its original physical memory
locations.

This is similar to the problem solved for kexec by
commit 1e977aa12dd4 ("x86: KVM guest: disable clock before rebooting.")

Commit 95a3d4454bb1 ("x86/kvmclock: Switch kvmclock data to a
PER_CPU variable") innocently increased the exposure for this
problem by dynamically allocating the physical pages that are
used for host clock updates when the vcpu count exceeds 64.
This increases the likelihood that the registered kvmclock
locations will differ for vcpus above 64.

Reported-by: Xiaoyi Chen <cxiaoyi@amazon.com>
Tested-by: Mohamed Aboubakr <mabouba@amazon.com>
Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
---
 arch/x86/kernel/kvmclock.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa593743acf6..291ffca41afb 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -187,8 +187,18 @@ static void kvm_register_clock(char *txt)
 	pr_info("kvm-clock: cpu %d, msr %llx, %s", smp_processor_id(), pa, txt);
 }
 
+/*
+ * Turn off host clock updates to the registered memory location when the
+ * cpu clock context is saved via save_processor_state(). Enables correct
+ * handling of the primary cpu clock when transitioning to a hibernated
+ * kernel in resume_target_kernel(), where the old and new registered
+ * memory locations may differ.
+ */
 static void kvm_save_sched_clock_state(void)
 {
+	native_write_msr(msr_kvm_system_time, 0, 0);
+	kvm_disable_steal_time();
+	pr_info("kvm-clock: cpu %d, clock stopped", smp_processor_id());
 }
 
 static void kvm_restore_sched_clock_state(void)
@@ -311,9 +321,23 @@ static int kvmclock_setup_percpu(unsigned int cpu)
 	return p ? 0 : -ENOMEM;
 }
 
+/*
+ * Turn off host clock updates to the registered memory location when a
+ * cpu is placed offline. Enables correct handling of secondary cpu clocks
+ * when transitioning to a hibernated kernel in resume_target_kernel(),
+ * where the old and new registered memory locations may differ.
+ */
+static int kvmclock_cpu_offline(unsigned int cpu)
+{
+	native_write_msr(msr_kvm_system_time, 0, 0);
+	pr_info("kvm-clock: cpu %d, clock stopped", cpu);
+	return 0;
+}
+
 void __init kvmclock_init(void)
 {
 	u8 flags;
+	int cpuhp_prepare;
 
 	if (!kvm_para_available() || !kvmclock)
 		return;
@@ -325,8 +349,14 @@ void __init kvmclock_init(void)
 		return;
 	}
 
-	if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
-			      kvmclock_setup_percpu, NULL) < 0) {
+	cpuhp_prepare = cpuhp_setup_state(CPUHP_BP_PREPARE_DYN,
+					  "kvmclock:setup_percpu",
+					  kvmclock_setup_percpu, NULL);
+	if (cpuhp_prepare < 0)
+		return;
+	if (cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvmclock:cpu_offline",
+			      NULL, kvmclock_cpu_offline) < 0) {
+		cpuhp_remove_state(cpuhp_prepare);
 		return;
 	}
 
-- 
2.27.0

