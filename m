Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4334CF314
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 08:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbiCGIA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiCGIA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:00:26 -0500
Received: from mx423.baidu.com (mx405.baidu.com [124.64.200.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D3CA1BE85
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 23:59:32 -0800 (PST)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx423.baidu.com (Postfix) with ESMTP id DFC8A16E001A0;
        Mon,  7 Mar 2022 15:59:29 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id D4976D9932;
        Mon,  7 Mar 2022 15:59:29 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, x86@kernel.org, kvm@vger.kernel.org,
        lirongqing@baidu.com, peterz@infradead.org
Subject: [PATCH][v2] KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
Date:   Mon,  7 Mar 2022 15:59:29 +0800
Message-Id: <1646639969-44226-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If guest kernel is configured with nopvspin, or guest find its has
dedicated pCPUs from realtime hint feature, the pvspinlock will be
disabled, and vCPU preemption check is disabled too.

but KVM still can emulating HLT for vCPU for both cases, and check
if vCPU is preempted or not, and can boost performance

Like unixbench, single copy, guest kernel with nopvspin:

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
diff v1: move the vcpu_is_preempted setting into kvm_guest_init,
to reduce a check of kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)

 arch/x86/kernel/kvm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d77481ec..3da39da 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -764,6 +764,9 @@ static void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
 		has_steal_clock = 1;
 		static_call_update(pv_steal_clock, kvm_steal_clock);
+
+		pv_ops.lock.vcpu_is_preempted =
+			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
@@ -1081,10 +1084,6 @@ void __init kvm_spinlock_init(void)
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

