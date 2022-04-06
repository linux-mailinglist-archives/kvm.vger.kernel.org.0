Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E7A4F7387
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 05:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240310AbiDGD2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 23:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240601AbiDGD2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 23:28:09 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A529F112
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 20:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649301970; x=1680837970;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0KLacdHcpDEza+nuhOv+ETwE7ZobSa2RvKDkPLy7FdA=;
  b=OvmpCzZOdZt9LAFVp/wULVW+81fzSmatuiZd4NiIHN8gC4FOBIZyDTur
   iV2TN/TE+WygLwke/G5lfajD2v9aTsy+M8VULMSOg++buhOtmPNXkF36O
   UIDh+/HMsS94rO+Iyw+D/TIUE968n7oYMuxOrBf1FrjzU5vAfmfmhOX3W
   cHTVd66JSlSlhu+FWLoHj0EFjeScgLIQhStSstP4Uzqk+vAb/JfRO5zak
   v2+H8HUt4jETqphC5MpRYE56cSwFqRQMhdy/NlF6tE3XNLV+LCdHYZrdX
   VzEAJTQ3fI9Vg9eV86ymJy8HXes8FOIwa7UrFK5is0IbEtVEkQMzrHn6Q
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="321911060"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="321911060"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 20:26:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="524749020"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 20:26:10 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH] x86: cet: Fix #DF exception triggered by the application
Date:   Wed,  6 Apr 2022 09:24:46 -0400
Message-Id: <20220406132446.32679-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit: 8cd86535fb(x86: get rid of ring0stacktop) makes old test
application trigger #DF. To fix the issue, refactored the code
using run_in_user() which is adapted to the change well.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/cet.c | 94 +++++--------------------------------------------------
 1 file changed, 7 insertions(+), 87 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index a4b79cb..8c09c79 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -8,16 +8,8 @@
 #include "alloc_page.h"
 #include "fault_test.h"
 
-
-static unsigned char user_stack[0x400];
-static unsigned long rbx, rsi, rdi, rsp, rbp, r8, r9,
-		     r10, r11, r12, r13, r14, r15;
-
-static unsigned long expected_rip;
 static int cp_count;
-typedef u64 (*cet_test_func)(void);
-
-cet_test_func func;
+static unsigned long invalid_offset = 0xffffffffffffff;
 
 static u64 cet_shstk_func(void)
 {
@@ -59,77 +51,6 @@ static u64 cet_ibt_func(void)
 	return 0;
 }
 
-void test_func(void);
-void test_func(void) {
-	asm volatile (
-			/* IRET into user mode */
-			"pushq %[user_ds]\n\t"
-			"pushq %[user_stack_top]\n\t"
-			"pushfq\n\t"
-			"pushq %[user_cs]\n\t"
-			"lea user_mode(%%rip), %%rax\n\t"
-			"pushq %%rax\n\t"
-			"iretq\n"
-
-			"user_mode:\n\t"
-			"call *%[func]\n\t"
-			::
-			[func]"m"(func),
-			[user_ds]"i"(USER_DS),
-			[user_cs]"i"(USER_CS),
-			[user_stack_top]"r"(user_stack +
-					sizeof(user_stack))
-			: "rax");
-}
-
-#define SAVE_REGS() \
-	asm ("movq %%rbx, %0\t\n"  \
-	     "movq %%rsi, %1\t\n"  \
-	     "movq %%rdi, %2\t\n"  \
-	     "movq %%rsp, %3\t\n"  \
-	     "movq %%rbp, %4\t\n"  \
-	     "movq %%r8, %5\t\n"   \
-	     "movq %%r9, %6\t\n"   \
-	     "movq %%r10, %7\t\n"  \
-	     "movq %%r11, %8\t\n"  \
-	     "movq %%r12, %9\t\n"  \
-	     "movq %%r13, %10\t\n" \
-	     "movq %%r14, %11\t\n" \
-	     "movq %%r15, %12\t\n" :: \
-	     "m"(rbx), "m"(rsi), "m"(rdi), "m"(rsp), "m"(rbp), \
-	     "m"(r8), "m"(r9), "m"(r10),  "m"(r11), "m"(r12),  \
-	     "m"(r13), "m"(r14), "m"(r15));
-
-#define RESTOR_REGS() \
-	asm ("movq %0, %%rbx\t\n"  \
-	     "movq %1, %%rsi\t\n"  \
-	     "movq %2, %%rdi\t\n"  \
-	     "movq %3, %%rsp\t\n"  \
-	     "movq %4, %%rbp\t\n"  \
-	     "movq %5, %%r8\t\n"   \
-	     "movq %6, %%r9\t\n"   \
-	     "movq %7, %%r10\t\n"  \
-	     "movq %8, %%r11\t\n"  \
-	     "movq %9, %%r12\t\n"  \
-	     "movq %10, %%r13\t\n" \
-	     "movq %11, %%r14\t\n" \
-	     "movq %12, %%r15\t\n" ::\
-	     "m"(rbx), "m"(rsi), "m"(rdi), "m"(rsp), "m"(rbp), \
-	     "m"(r8), "m"(r9), "m"(r10), "m"(r11), "m"(r12),   \
-	     "m"(r13), "m"(r14), "m"(r15));
-
-#define RUN_TEST() \
-	do {		\
-		SAVE_REGS();    \
-		asm volatile ("pushq %%rax\t\n"           \
-			      "leaq 1f(%%rip), %%rax\t\n" \
-			      "movq %%rax, %0\t\n"        \
-			      "popq %%rax\t\n"            \
-			      "call test_func\t\n"         \
-			      "1:" ::"m"(expected_rip) : "rax", "rdi"); \
-		RESTOR_REGS(); \
-	} while (0)
-
 #define ENABLE_SHSTK_BIT 0x1
 #define ENABLE_IBT_BIT   0x4
 
@@ -138,7 +59,8 @@ static void handle_cp(struct ex_regs *regs)
 	cp_count++;
 	printf("In #CP exception handler, error_code = 0x%lx\n",
 		regs->error_code);
-	asm("jmp *%0" :: "m"(expected_rip));
+	/* Below jmp is expected to trigger #GP */
+	asm("jmp %0": :"m"(invalid_offset));
 }
 
 int main(int ac, char **av)
@@ -147,6 +69,7 @@ int main(int ac, char **av)
 	unsigned long shstk_phys;
 	unsigned long *ptep;
 	pteval_t pte = 0;
+	bool rvc;
 
 	cp_count = 0;
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
@@ -160,7 +83,6 @@ int main(int ac, char **av)
 	}
 
 	setup_vm();
-	setup_idt();
 	handle_exception(21, handle_cp);
 
 	/* Allocate one page for shadow-stack. */
@@ -189,17 +111,15 @@ int main(int ac, char **av)
 	/* Enable CET master control bit in CR4. */
 	write_cr4(read_cr4() | X86_CR4_CET);
 
-	func = cet_shstk_func;
-	RUN_TEST();
+	printf("Unit test for CET user mode...\n");
+	run_in_user((usermode_func)cet_shstk_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(cp_count == 1, "Completed shadow-stack protection test successfully.");
 	cp_count = 0;
 
-	/* Do user-mode indirect-branch-tracking test.*/
-	func = cet_ibt_func;
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-	RUN_TEST();
+	run_in_user((usermode_func)cet_ibt_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(cp_count == 1, "Completed Indirect-branch tracking test successfully.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
-- 
2.27.0

