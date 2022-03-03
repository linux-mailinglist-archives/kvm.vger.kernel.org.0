Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29564CB7BA
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiCCH2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiCCH2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:13 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C20410DC
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292448; x=1677828448;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q6Bijq9RqPmvXm9peANhjkv/SEQQ8PvTpgmj+xKkNM4=;
  b=goreraHv35Sw0GHWgMxokH2dcG/75Q4/kRex1K0xlFE/TffAAuMIP9fF
   /3wIbBoZY+6A+49YLYSkxHcHSRrd3S0HfWE6ynvLM8SU0Rl0V/IHlHT2m
   FXJSsyp5hXQvzqOiQWH9kjDnIsu/08kF7Uot/dzFfrqxHN7Wd7DStcVcy
   5ua77q93I2j9DMgjN4T3TzDbF14bF0Umi1/oakgr9TEqybZEsUKUcjyR3
   9pOEFS2Ej7GSAFScP/n+y1IRjchuemazaRxcb23zbE6gZagIxHPAFY3ZU
   dBg4Z7jQ9a5eMN0kiG4rhRG5Q5DwXp/iEeWgfqRLKkK3igx3re/3N7JC4
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="234214653"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="234214653"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:27 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631532"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:25 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 04/17] x86 TDX: Add exception table support
Date:   Thu,  3 Mar 2022 15:18:54 +0800
Message-Id: <20220303071907.650203-5-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exception table is used to fixup from a faulty instruction
execution.

In TDX scenario, some instructions trigger #VE and simulated
through tdvmcall. If the simulation fail, the instruction is
treated as faulty and should be checked with the exception
table to fixup.

Move struct ex_record, exception_table_[start|end] in lib/x86/desc.h
as it's a general declaration and will be used in TDX.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/desc.c |  7 -------
 lib/x86/desc.h |  6 ++++++
 lib/x86/tdx.c  | 23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index b35274e44a8d..52eb4152385a 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -84,13 +84,6 @@ void set_idt_sel(int vec, u16 sel)
     e->selector = sel;
 }
 
-struct ex_record {
-    unsigned long rip;
-    unsigned long handler;
-};
-
-extern struct ex_record exception_table_start, exception_table_end;
-
 const char* exception_mnemonic(int vector)
 {
 	switch(vector) {
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index ad6277ba600a..068ec2394df9 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -212,6 +212,12 @@ extern tss64_t tss[];
 #endif
 extern gdt_entry_t gdt[];
 
+struct ex_record {
+	unsigned long rip;
+	unsigned long handler;
+};
+extern struct ex_record exception_table_start, exception_table_end;
+
 unsigned exception_vector(void);
 int write_cr4_checking(unsigned long val);
 unsigned exception_error_code(void);
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index 42ab25f47e57..62e0e2842822 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -267,6 +267,22 @@ static bool tdx_handle_io(struct ex_regs *regs, u32 exit_qual)
 	return ret ? false : true;
 }
 
+static bool tdx_check_exception_table(struct ex_regs *regs)
+{
+	struct ex_record *ex;
+
+	for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
+		if (ex->rip == regs->rip) {
+			regs->rip = ex->handler;
+			return true;
+		}
+	}
+	unhandled_exception(regs, false);
+
+	/* never reached */
+	return false;
+}
+
 static bool tdx_get_ve_info(struct ve_info *ve)
 {
 	struct tdx_module_output out;
@@ -298,10 +314,15 @@ static bool tdx_get_ve_info(struct ve_info *ve)
 static bool tdx_handle_virtualization_exception(struct ex_regs *regs,
 		struct ve_info *ve)
 {
+	unsigned int ex_val;
 	bool ret = true;
 	u64 val = ~0ULL;
 	bool do_sti;
 
+	/* #VE exit_reason in bit16-32 */
+	ex_val = regs->vector | (ve->exit_reason << 16);
+	asm("mov %0, %%gs:4" : : "r"(ex_val));
+
 	switch (ve->exit_reason) {
 	case EXIT_REASON_HLT:
 		do_sti = !!(regs->rflags & X86_EFLAGS_IF);
@@ -333,6 +354,8 @@ static bool tdx_handle_virtualization_exception(struct ex_regs *regs,
 	/* After successful #VE handling, move the IP */
 	if (ret)
 		regs->rip += ve->instr_len;
+	else
+		ret = tdx_check_exception_table(regs);
 
 	return ret;
 }
-- 
2.25.1

