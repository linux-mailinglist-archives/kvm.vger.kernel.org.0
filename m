Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8E448E8A3
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 11:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiANKyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 05:54:31 -0500
Received: from mx316.baidu.com ([180.101.52.236]:45696 "EHLO
        njjs-sys-mailin01.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232895AbiANKya (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 05:54:30 -0500
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 451447F00063;
        Fri, 14 Jan 2022 18:54:28 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id EFB88D9932;
        Fri, 14 Jan 2022 18:54:27 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        peterz@infradead.org
Subject: [PATCH] KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
Date:   Fri, 14 Jan 2022 18:54:27 +0800
Message-Id: <1642157667-18350-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If guest kernel is configured with nopvspin, or guest find its has
dedicated pCPUs from realtime hint feature, the pvspinlock will be
disabled, and vCPU preemption check is disabled too.

but KVM still can emulating HLT for vCPU for both cases, and check
if vCPU is preempted or not, and can boost performance, so move the
setting pv_ops.lock.vcpu_is_preempted before check nopvspin and
REALTIME hint

Like unixbench, single copy test result, and guest kernel is configured
with nopvspinlock

Testcase                                  Base    with patch
System Benchmarks Index Values            INDEX     INDEX
Dhrystone 2 using register variables     3278.4    3277.7
Double-Precision Whetstone                822.8     825.8
Execl Throughput                         1296.5     941.1
File Copy 1024 bufsize 2000 maxblocks    2124.2    2142.7
File Copy 256 bufsize 500 maxblocks      1335.9    1353.6
File Copy 4096 bufsize 8000 maxblocks    4256.3    4760.3
Pipe Throughput                          1050.1    1054.0
Pipe-based Context Switching              243.3     352.0
Process Creation                          820.1     814.4
Shell Scripts (1 concurrent)             2169.0    2086.0
Shell Scripts (8 concurrent)             7710.3    7576.3
System Call Overhead                      672.4     673.9
                                      ========    =======
System Benchmarks Index Score             1467.2   1483.0

Co-developed-by: Wang GuangJu <wangguangju@baidu.com>
Signed-off-by: Wang GuangJu <wangguangju@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 59abbda..b061d17 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1048,6 +1048,11 @@ void __init kvm_spinlock_init(void)
 		return;
 	}
 
+	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+		pv_ops.lock.vcpu_is_preempted =
+			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
+	}
+
 	/*
 	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
 	 * are available.
@@ -1076,10 +1081,6 @@ void __init kvm_spinlock_init(void)
 	pv_ops.lock.wait = kvm_wait;
 	pv_ops.lock.kick = kvm_kick_cpu;
 
-	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
-		pv_ops.lock.vcpu_is_preempted =
-			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
-	}
 	/*
 	 * When PV spinlock is enabled which is preferred over
 	 * virt_spin_lock(), virt_spin_lock_key's value is meaningless.
-- 
2.9.4

