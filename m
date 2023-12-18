Return-Path: <kvm+bounces-4671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0F681670F
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:10:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 992D8282736
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33BCDDDBF;
	Mon, 18 Dec 2023 07:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GCwBz6dM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1ACD519
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883422; x=1734419422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PZiETFIfbSE66fiyjGuSaOoOi7NEnt2vB+FJVnTOa6I=;
  b=GCwBz6dMIORUmqncm4z4bur1okBBDWnkDqz01jJWe4BHnVTsL2jMLzXb
   10dlE4wYGi07vWeToCQ9WEquhQ++WVGBVMbj2TD49WjFqleXnW2xjgUBL
   x6D6AeLon4rs4hO/RQ8SxcA9OCkHRbFT/1gay5iXj29kTz9b1befoIwXP
   f5QeKEvHXhR7/LRfsLBv9nyEHTNpeTnvLkbAQLdQWIzBPhFoGwfxqZNCW
   azyEYt7dGzhQHFgF7LBcQhKSRvR8k1wewW6j1ARdeY1yHIC7ppRqeME6m
   DgMW7RfH9tAAWluEInVnwEQFBtzZtscQae0mg72ukE47dSjt3hLTnULSz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667853"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667853"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824679"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824679"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:18 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 05/18] x86 TDX: Add exception table support
Date: Mon, 18 Dec 2023 15:22:34 +0800
Message-Id: <20231218072247.2573516-6-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Exception table is used to fixup from a faulty instruction execution.

In TDX scenario, some instructions trigger #VE and are simulated through
tdvmcall. If the simulation fails, the instruction is treated as faulty
and should be checked with the exception table to fixup.

Move struct ex_record, exception_table_[start|end] to lib/x86/desc.h as
it's a general declaration and will be used in TDX.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-5-zhenzhong.duan@intel.com
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/desc.c |  7 -------
 lib/x86/desc.h |  6 ++++++
 lib/x86/tdx.c  | 23 ++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 5b41549e..14edac0c 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -100,13 +100,6 @@ void set_idt_sel(int vec, u16 sel)
 	e->selector = sel;
 }
 
-struct ex_record {
-	unsigned long rip;
-	unsigned long handler;
-};
-
-extern struct ex_record exception_table_start, exception_table_end;
-
 const char* exception_mnemonic(int vector)
 {
 	switch(vector) {
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 7778a0f8..54b3166f 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -237,6 +237,12 @@ extern tss64_t tss[];
 #endif
 extern gdt_entry_t gdt[];
 
+struct ex_record {
+	unsigned long rip;
+	unsigned long handler;
+};
+extern struct ex_record exception_table_start, exception_table_end;
+
 unsigned exception_vector(void);
 unsigned exception_error_code(void);
 bool exception_rflags_rf(void);
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index d10e02b9..4f8bbad7 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -303,6 +303,22 @@ done:
 	return !!tdx_guest;
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
 	struct tdx_module_args args = {};
@@ -334,8 +350,13 @@ static bool tdx_get_ve_info(struct ve_info *ve)
 static bool tdx_handle_virt_exception(struct ex_regs *regs,
 		struct ve_info *ve)
 {
+	unsigned int ex_val;
 	int insn_len = -EIO;
 
+	/* #VE exit_reason in bit16-32 */
+	ex_val = regs->vector | (ve->exit_reason << 16);
+	asm("mov %0, %%gs:4" : : "r"(ex_val));
+
 	switch (ve->exit_reason) {
 	case EXIT_REASON_HLT:
 		insn_len = handle_halt(regs, ve);
@@ -357,7 +378,7 @@ static bool tdx_handle_virt_exception(struct ex_regs *regs,
 		return false;
 	}
 	if (insn_len < 0)
-		return false;
+		return tdx_check_exception_table(regs);
 
 	/* After successful #VE handling, move the IP */
 	regs->rip += insn_len;
-- 
2.25.1


