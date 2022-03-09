Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F084D2AD4
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 09:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiCIIry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 03:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiCIIry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 03:47:54 -0500
Received: from njjs-sys-mailin01.njjs.baidu.com (mx315.baidu.com [180.101.52.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22A991617F2
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 00:46:54 -0800 (PST)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id A10547F00053;
        Wed,  9 Mar 2022 16:46:52 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 8A9B7D9932;
        Wed,  9 Mar 2022 16:46:52 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, x86@kernel.org, kvm@vger.kernel.org,
        lirongqing@baidu.com, wanpengli@tencent.com
Subject: [PATCH][v3] KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
Date:   Wed,  9 Mar 2022 16:46:50 +0800
Message-Id: <1646815610-43315-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If guest kernel is configured with nopvspin, or CONFIG_PARAVIRT_SPINLOCK
is disabled, or guest find its has dedicated pCPUs from realtime hint
feature, the pvspinlock will be disabled, and vCPU preemption check
is disabled too.

but KVM still can emulating HLT for vCPU for both cases, and check if vCPU
is preempted or not, and can boost performance

so move the setting of pv_ops.lock.vcpu_is_preempted to kvm_guest_init, make
it not depend on pvspinlock

Like unixbench, single copy, vcpu with dedicated pCPU and guest kernel with
nopvspin, but emulating HLT for vCPU`:

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

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff v3: fix building failure when CONFIG_PARAVIRT_SPINLOCK is disable
         and setting preemption check only when unhalt
diff v2: move setting preemption check to kvm_guest_init

 arch/x86/kernel/kvm.c | 74 +++++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d77481ec..959f919 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -752,6 +752,39 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
+#ifdef CONFIG_X86_32
+__visible bool __kvm_vcpu_is_preempted(long cpu)
+{
+	struct kvm_steal_time *src = &per_cpu(steal_time, cpu);
+
+	return !!(src->preempted & KVM_VCPU_PREEMPTED);
+}
+PV_CALLEE_SAVE_REGS_THUNK(__kvm_vcpu_is_preempted);
+
+#else
+
+#include <asm/asm-offsets.h>
+
+extern bool __raw_callee_save___kvm_vcpu_is_preempted(long);
+
+/*
+ * Hand-optimize version for x86-64 to avoid 8 64-bit register saving and
+ * restoring to/from the stack.
+ */
+asm(
+".pushsection .text;"
+".global __raw_callee_save___kvm_vcpu_is_preempted;"
+".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
+"__raw_callee_save___kvm_vcpu_is_preempted:"
+"movq	__per_cpu_offset(,%rdi,8), %rax;"
+"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
+"setne	%al;"
+"ret;"
+".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
+".popsection");
+
+#endif
+
 static void __init kvm_guest_init(void)
 {
 	int i;
@@ -764,6 +797,10 @@ static void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
 		has_steal_clock = 1;
 		static_call_update(pv_steal_clock, kvm_steal_clock);
+
+		if (kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
+			pv_ops.lock.vcpu_is_preempted =
+				PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
@@ -1005,39 +1042,6 @@ static void kvm_wait(u8 *ptr, u8 val)
 	}
 }
 
-#ifdef CONFIG_X86_32
-__visible bool __kvm_vcpu_is_preempted(long cpu)
-{
-	struct kvm_steal_time *src = &per_cpu(steal_time, cpu);
-
-	return !!(src->preempted & KVM_VCPU_PREEMPTED);
-}
-PV_CALLEE_SAVE_REGS_THUNK(__kvm_vcpu_is_preempted);
-
-#else
-
-#include <asm/asm-offsets.h>
-
-extern bool __raw_callee_save___kvm_vcpu_is_preempted(long);
-
-/*
- * Hand-optimize version for x86-64 to avoid 8 64-bit register saving and
- * restoring to/from the stack.
- */
-asm(
-".pushsection .text;"
-".global __raw_callee_save___kvm_vcpu_is_preempted;"
-".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
-"__raw_callee_save___kvm_vcpu_is_preempted:"
-"movq	__per_cpu_offset(,%rdi,8), %rax;"
-"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
-"setne	%al;"
-"ret;"
-".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
-".popsection");
-
-#endif
-
 /*
  * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
  */
@@ -1081,10 +1085,6 @@ void __init kvm_spinlock_init(void)
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

