Return-Path: <kvm+bounces-4670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A47DC81670E
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40102B218DE
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE0CD289;
	Mon, 18 Dec 2023 07:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B5mK5fVY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9071DC8F1
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883418; x=1734419418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5b1GcYeGnuCESEJc3dmG0FfJ6Ey6g+4s3+jMlBQpt0U=;
  b=B5mK5fVYT7WO9KukpXkZAmk4c88eDeFtYU3xPU50jtQWhLO5sMmV9Q5Y
   kHd49uNbaVHZnDTbfVKLFlNcYi9uhFgiQ37FZEChY/aR6thrPRhUjkzgL
   Vi+E3eQr4bo7x5iuIOYbchJ3TDNgCJMN9y6QaL9VLhdn2lZHmF9DryUpj
   h5Adafe2Jq7sZ8LPdYqDu7Z/V9/2nsSZUN/YWUQ4mc8C/mArnbMdAuvwg
   QMGyNbzalAynYtiidLRG/6KjvQvN8CCv4QKezCmgQ3TeKrjqYO35+kxYK
   9mi22z+oBQ4UK9avBY18nf9C+mZIRRTEbZuiK1d3JUAhJRFjzv04YmmR8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667837"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667837"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824661"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824661"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:15 -0800
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
Subject: [kvm-unit-tests RFC v2 04/18] x86 TDX: Bypass APIC and enable x2APIC directly
Date: Mon, 18 Dec 2023 15:22:33 +0800
Message-Id: <20231218072247.2573516-5-qian.wen@intel.com>
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

According to TDX Module 1.5 Base Sepc, 11.9 Interrupt Handling and
APIC Virtualization:
1. Guest TDs must use virtualized x2APIC mode. xAPIC mode(using memory
mapped APIC access) is not allowed.
2. Guest TDs attempts to RDMSR or WRMSR the IA32_APIC_BASE MSR cause a
VE to the guest TD. The guest TD cannot disable the APIC.

Bypass xAPIC initialization and enable x2APIC directly. Set software
enable bit in x2APIC initializaion.

Use uid/apicid mapping to get apicid in setup_tss(). Initially I enabled
x2APIC early so apic_id() could be used. But that brings issue for
multiprocessor support as reading APIC_ID in AP triggers #VE and require
gdt/tss/idt to be initialized early, so setup_gdt_tss() early.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-4-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/apic.c  |  4 ++++
 lib/x86/setup.c | 13 ++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 0d151476..a74edf53 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -153,6 +153,10 @@ int enable_x2apic(void)
 		asm ("rdmsr" : "=a"(a), "=d"(d) : "c"(MSR_IA32_APICBASE));
 		a |= 1 << 10;
 		asm ("wrmsr" : : "a"(a), "d"(d), "c"(MSR_IA32_APICBASE));
+
+		/* software APIC enabled bit is cleared after reset in TD-guest */
+		x2apic_write(APIC_SPIV, 0x1ff);
+
 		this_cpu_write_apic_ops((void *)&x2apic_ops);
 		return 1;
 	} else {
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 97d9e896..8ff8ce4f 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -112,8 +112,9 @@ unsigned long setup_tss(u8 *stacktop)
 {
 	u32 id;
 	tss64_t *tss_entry;
+	static u32 cpus = 0;
 
-	id = pre_boot_apic_id();
+	id = is_tdx_guest() ? id_map[cpus++] : pre_boot_apic_id();
 
 	/* Runtime address of current TSS */
 	tss_entry = &tss[id];
@@ -362,11 +363,13 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	 * Resetting the APIC sets the per-vCPU APIC ops and so must be
 	 * done after loading GS.base with the per-vCPU data.
 	 */
-	reset_apic();
-	mask_pic_interrupts();
+	if (!is_tdx_guest()) {
+		reset_apic();
+		mask_pic_interrupts();
+		enable_apic();
+		save_id();
+	}
 	setup_page_table();
-	enable_apic();
-	save_id();
 	bsp_rest_init();
 
 	return EFI_SUCCESS;
-- 
2.25.1


