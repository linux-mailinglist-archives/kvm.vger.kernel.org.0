Return-Path: <kvm+bounces-4673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BADDD816711
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:10:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 024C71C22302
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE0CF9C6;
	Mon, 18 Dec 2023 07:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZM2qGfTP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB81BE57C
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883428; x=1734419428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PrkPX9R43CZvrlbthoyvWKTywaleOBY6guij5/4O+V4=;
  b=ZM2qGfTPFUYkLrnIzAk29YzuDSP8sOeQEUaOjidkN0IbVTdic4YVk2T9
   Ix4z4E0ouUKAcPr5r7X3X30ztPUUSkN1luYZUhc/bK9Cg79/wNjtaSnaP
   84oqgPJUpDtuA8wuC9zeWeCaL1EcYogJ+vQ7CafpVX2KFAyeaoDzml47C
   /DMNrjAUj7LkpKh3vEcEP49xv5A3DaX9OAlPUdpxJfBJwMBGAwptK9QtD
   AfP+lbA0VKcuhhC2crOHSjs4wk4GPOjBLPFaHya30S2/7dCfy9+7P2yvZ
   R9ViNKBauuGs2vr0W7yKPS5XGyX4OdK/ygFlC1648iac0Gvac4a5mHgl9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667879"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667879"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824696"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824696"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:24 -0800
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
Subject: [kvm-unit-tests RFC v2 07/18] x86 TDX: Simulate single step on #VE handled instruction
Date: Mon, 18 Dec 2023 15:22:36 +0800
Message-Id: <20231218072247.2573516-8-qian.wen@intel.com>
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

According to TDX spec, specific instructions are simulated in #VE
handler.

To avoid missing single step on these instructions, such as cpuid(0xb)
and wrmsr(0x1a0), we have to simulate #DB processing in #VE handler.

Move declaration of do_handle_exception() in header file, so it can be
used in #VE handler for #DB processing.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-7-zhenzhong.duan@intel.com
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/desc.c | 5 -----
 lib/x86/desc.h | 5 +++++
 lib/x86/tdx.c  | 6 ++++++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 14edac0c..d8a7f8ef 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -52,11 +52,6 @@ struct descriptor_table_ptr gdt_descr = {
 	.base = (unsigned long)gdt,
 };
 
-#ifndef __x86_64__
-__attribute__((regparm(1)))
-#endif
-void do_handle_exception(struct ex_regs *regs);
-
 /*
  * Fill an idt_entry_t or call gate entry, clearing e_sz bytes first.
  *
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 54b3166f..8d6ea824 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -255,6 +255,11 @@ void set_gdt_entry(int sel, unsigned long base, u32 limit, u8 access, u8 gran);
 void load_gdt_tss(size_t tss_offset);
 void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
+
+#ifndef __x86_64__
+__attribute__((regparm(1)))
+#endif
+void do_handle_exception(struct ex_regs *regs);
 handler handle_exception(u8 v, handler fn);
 void unhandled_exception(struct ex_regs *regs, bool cpu);
 const char* exception_mnemonic(int vector);
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
index 3909e283..dc722653 100644
--- a/lib/x86/tdx.c
+++ b/lib/x86/tdx.c
@@ -398,6 +398,12 @@ static bool tdx_handle_virt_exception(struct ex_regs *regs,
 
 	/* After successful #VE handling, move the IP */
 	regs->rip += insn_len;
+	/* Simulate single step on simulated instruction */
+	if (regs->rflags & X86_EFLAGS_TF) {
+		regs->vector = DB_VECTOR;
+		write_dr6(read_dr6() | (1 << 14));
+		do_handle_exception(regs);
+	}
 
 	return true;
 }
-- 
2.25.1


