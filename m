Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243BE349FE5
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCZCmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:42:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230336AbhCZClw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 22:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616726512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1ehJFMh/kOfU+I9OXEtjP+uM7fVA5wEAWFQ39c7YsNY=;
        b=Fdm8ubvqun7UM/9Jwa+6YRFFsDDd2bzK9RdGuT7xAXWZlGSSUw4jJDg8acpXvAixLNmpIp
        +081e+L7oyTQRh+LBhmK91tUgvXkKfTZrZs2jMF/V3WnOJZ/a8qKCu19wl20otr2+FFF4m
        YHuS6dSFfwHwUdzmkXjkY5+ddMrLo0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-VcP3UqUaPwy-MRVEZIqA8Q-1; Thu, 25 Mar 2021 22:41:48 -0400
X-MC-Unique: VcP3UqUaPwy-MRVEZIqA8Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5258A107ACCD;
        Fri, 26 Mar 2021 02:41:46 +0000 (UTC)
Received: from lszubowi.redhat.com (unknown [10.10.110.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7FF66EF55;
        Fri, 26 Mar 2021 02:41:43 +0000 (UTC)
From:   Lenny Szubowicz <lszubowi@redhat.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] x86/kvmclock: Stop kvmclocks for hibernate restore
Date:   Thu, 25 Mar 2021 22:41:43 -0400
Message-Id: <20210326024143.279941-1-lszubowi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 arch/x86/kernel/kvmclock.c | 40 ++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 1fc0962c89c0..0d39906b9df0 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -187,8 +187,17 @@ static void kvm_register_clock(char *txt)
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
 }
 
 static void kvm_restore_sched_clock_state(void)
@@ -310,9 +319,22 @@ static int kvmclock_setup_percpu(unsigned int cpu)
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
+	return 0;
+}
+
 void __init kvmclock_init(void)
 {
 	u8 flags;
+	int cpuhp_prepare;
 
 	if (!kvm_para_available() || !kvmclock)
 		return;
@@ -324,10 +346,14 @@ void __init kvmclock_init(void)
 		return;
 	}
 
-	if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
-			      kvmclock_setup_percpu, NULL) < 0) {
-		return;
-	}
+	cpuhp_prepare = cpuhp_setup_state(CPUHP_BP_PREPARE_DYN,
+					  "kvmclock:setup_percpu",
+					  kvmclock_setup_percpu, NULL);
+	if (cpuhp_prepare < 0)
+		goto cpuhp_setup_err1;
+	if (cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvmclock:cpu_offline",
+			      NULL, kvmclock_cpu_offline) < 0)
+		goto cpuhp_setup_err2;
 
 	pr_info("kvm-clock: Using msrs %x and %x",
 		msr_kvm_system_time, msr_kvm_wall_clock);
@@ -372,4 +398,10 @@ void __init kvmclock_init(void)
 
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
 	pv_info.name = "KVM";
+	return;
+
+cpuhp_setup_err2:
+	cpuhp_remove_state(cpuhp_prepare);
+cpuhp_setup_err1:
+	pr_err("kvmclock: Init failed; error from cpu state notifier registration\n");
 }
-- 
2.27.0

