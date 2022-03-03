Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141164CB7C8
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiCCH3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiCCH2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:41 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F443881
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292458; x=1677828458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=689/bs1uE2tAQyNb7+lRjwYDAJMMQs0xZFnTOExqe3Q=;
  b=ByIvMriD+BPKuqHsUoKa3SwWG1H9oZ03Gu81SVK+G8CojGxsl43xXgX4
   z5vq/cATs+cP0E4ribxCQDbq5uAL2CajDztPARrnjMoDtnGUEqSau1c7C
   HO/C9LLEhpiKFoLFmhK2JFf/Uuu4zKL6tM9mNsM0L3Sl0cQZLiDOqN9Q4
   UW0a94ttd5g/1MpeqpLgp/Cpfv/JIT2dEq1pA0Q66e7guA/UFZRni9/0U
   H76mgVvthbVvmdQHo8JudE4+E9RQBsjgb/P5s3gbg0kwGsEdEscLyroF/
   ijLLPS78ZuLiVfd0XpredhXApBnXaVzhr9ltY2+MEFjPObzgCn/nTfnLJ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="252427542"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="252427542"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:33 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631592"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:30 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 06/17] x86 TDX: Simulate single step on #VE handled instruction
Date:   Thu,  3 Mar 2022 15:18:56 +0800
Message-Id: <20220303071907.650203-7-zhenzhong.duan@intel.com>
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

According to TDX spec, specific instructions are simulated in #VE
handler, such as cpuid(0xb) and wrmsr(0x1a0).

To avoid missing single step on these instructions, we have to
simulate #DB processing in #VE handler.

Move declaration of do_handle_exception() in header file, so it can
be used in #VE handler for #DB processing.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/desc.c | 5 -----
 lib/x86/desc.h | 4 ++++
 lib/x86/tdx.c  | 9 ++++++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 52eb4152385a..78f4b6576888 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -51,11 +51,6 @@ struct descriptor_table_ptr gdt_descr = {
 	.base = (unsigned long)gdt,
 };
 
-#ifndef __x86_64__
-__attribute__((regparm(1)))
-#endif
-void do_handle_exception(struct ex_regs *regs);
-
 void set_idt_entry(int vec, void *addr, int dpl)
 {
     idt_entry_t *e = &boot_idt[vec];
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 068ec2394df9..2cd819574374 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -222,6 +222,10 @@ unsigned exception_vector(void);
 int write_cr4_checking(unsigned long val);
 unsigned exception_error_code(void);
 bool exception_rflags_rf(void);
+#ifndef __x86_64__
+__attribute__((regparm(1)))
+#endif
+void do_handle_exception(struct ex_regs *regs);
 void set_idt_entry(int vec, void *addr, int dpl);
 void set_idt_sel(int vec, u16 sel);
 void set_idt_dpl(int vec, u16 dpl);
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index 1fc8030c34fa..2b2e3164be33 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -365,8 +365,15 @@ static bool tdx_handle_virtualization_exception(struct ex_regs *regs,
 	}
 
 	/* After successful #VE handling, move the IP */
-	if (ret)
+	if (ret) {
 		regs->rip += ve->instr_len;
+		/* Simulate single step on simulated instruction */
+		if (regs->rflags & X86_EFLAGS_TF) {
+			regs->vector = DB_VECTOR;
+			write_dr6(read_dr6() | (1 << 14));
+			do_handle_exception(regs);
+		}
+	}
 	else
 		ret = tdx_check_exception_table(regs);
 
-- 
2.25.1

