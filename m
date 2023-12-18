Return-Path: <kvm+bounces-4669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F63B81670D
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9730B21875
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB96C8C6;
	Mon, 18 Dec 2023 07:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JsRG2zCr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6420847F
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883415; x=1734419415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U+8iOVthzYdReZheZKtjZcb6nb24eBKPqGWDPFjge/8=;
  b=JsRG2zCro32kXEAJB96TKvoYZO0NTgXyneYVj1yHO5PTXVnCruvIvL/D
   IzNwJM2weRxKC6X4fP451Crmbf0etG5TXxRLzqBIAkW9EzVLsHShgVQf8
   NlQWqVg0TuDr1+uVwmNs6K61svGcVZNqaMvYfAlOW60OUEWVFVrb0t2z4
   F/5pFe/9bpROOnmuNJSU4noAv20uN9eEFrWg6rFcCEPvPItqw6PbAa3Fb
   uSvJCzkS7CJlvs5CPm/M9GsMjT+PG6Xo2pl212aKsxDmEJ8lsSdZC80uP
   +zfLVjLkBtzeu1LGUVBXBhaWTHvkjqWjaCb416QgwAsIYS6Jkw1eEAjhl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667828"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667828"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824651"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824651"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:12 -0800
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
Subject: [kvm-unit-tests RFC v2 03/18] x86 TDX: Add #VE handler
Date: Mon, 18 Dec 2023 15:22:32 +0800
Message-Id: <20231218072247.2573516-4-qian.wen@intel.com>
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

Some instructions execution trigger #VE and are simulated in #VE
handler.

Add such a handler, currently support simulation of IO and MSR
read/write, cpuid and hlt instructions.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-3-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/desc.c |  6 +++-
 lib/x86/tdx.c  | 80 +++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/x86/tdx.h  |  1 +
 3 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index d054899c..5b41549e 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -249,6 +249,7 @@ EX(mf, 16);
 EX_E(ac, 17);
 EX(mc, 18);
 EX(xm, 19);
+EX(ve, 20);
 EX_E(cp, 21);
 
 asm (".pushsection .text \n\t"
@@ -295,6 +296,7 @@ static void *idt_handlers[32] = {
 	[17] = &ac_fault,
 	[18] = &mc_fault,
 	[19] = &xm_fault,
+	[20] = &ve_fault,
 	[21] = &cp_fault,
 };
 
@@ -312,7 +314,9 @@ void setup_idt(void)
 			continue;
 
                 set_idt_entry(i, idt_handlers[i], 0);
-                handle_exception(i, check_exception_table);
+
+		if (!exception_handlers[i])
+			handle_exception(i, check_exception_table);
 	}
 }
 
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index a01bfcbb..d10e02b9 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -117,7 +117,8 @@ static int handle_halt(struct ex_regs *regs, struct ve_info *ve)
 	 * pending, without hanging/breaking the guest.
 	 */
 	if (__tdx_hypercall(&args))
-		return -EIO;
+		/* Bypass failed hlt is better than hang */
+		printf("WARNING: HLT instruction emulation failed\n");
 
 	return ve_instr_len(ve);
 }
@@ -302,11 +303,88 @@ done:
 	return !!tdx_guest;
 }
 
+static bool tdx_get_ve_info(struct ve_info *ve)
+{
+	struct tdx_module_args args = {};
+	u64 ret;
+
+	if (!ve)
+		return false;
+
+	/*
+	 * NMIs and machine checks are suppressed. Before this point any
+	 * #VE is fatal. After this point (TDGETVEINFO call), NMIs and
+	 * additional #VEs are permitted (but it is expected not to
+	 * happen unless kernel panics).
+	 */
+	ret = __tdcall_ret(TDG_VP_VEINFO_GET, &args);
+	if (ret)
+		return false;
+
+	ve->exit_reason = args.rcx;
+	ve->exit_qual	= args.rdx;
+	ve->gla		= args.r8;
+	ve->gpa		= args.r9;
+	ve->instr_len	= args.r10 & UINT_MAX;
+	ve->instr_info	= args.r10 >> 32;
+
+	return true;
+}
+
+static bool tdx_handle_virt_exception(struct ex_regs *regs,
+		struct ve_info *ve)
+{
+	int insn_len = -EIO;
+
+	switch (ve->exit_reason) {
+	case EXIT_REASON_HLT:
+		insn_len = handle_halt(regs, ve);
+		break;
+	case EXIT_REASON_MSR_READ:
+		insn_len = read_msr(regs, ve);
+		break;
+	case EXIT_REASON_MSR_WRITE:
+		insn_len = write_msr(regs, ve);
+		break;
+	case EXIT_REASON_CPUID:
+		insn_len = handle_cpuid(regs, ve);
+		break;
+	case EXIT_REASON_IO_INSTRUCTION:
+		insn_len = handle_io(regs, ve);
+		break;
+	default:
+		printf("WARNING: Unexpected #VE: %ld\n", ve->exit_reason);
+		return false;
+	}
+	if (insn_len < 0)
+		return false;
+
+	/* After successful #VE handling, move the IP */
+	regs->rip += insn_len;
+
+	return true;
+}
+
+/* #VE exception handler. */
+static void tdx_handle_ve(struct ex_regs *regs)
+{
+	struct ve_info ve;
+
+	if (!tdx_get_ve_info(&ve)) {
+		printf("tdx_get_ve_info failed\n");
+		return;
+	}
+
+	tdx_handle_virt_exception(regs, &ve);
+}
+
 efi_status_t setup_tdx(void)
 {
 	if (!is_tdx_guest())
 		return EFI_UNSUPPORTED;
 
+	handle_exception(20, tdx_handle_ve);
+
 	/* The printf can work here. Since TDVF default exception handler
 	 * can handle the #VE caused by IO read/write during printf() before
 	 * finalizing configuration of the unit test's #VE handler.
diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
index 45350b70..fe0a4d81 100644
--- a/lib/x86/tdx.h
+++ b/lib/x86/tdx.h
@@ -26,6 +26,7 @@
 
 /* TDX module Call Leaf IDs */
 #define TDG_VP_VMCALL			0
+#define TDG_VP_VEINFO_GET		3
 
 /*
  * Bitmasks of exposed registers (with VMM).
-- 
2.25.1


