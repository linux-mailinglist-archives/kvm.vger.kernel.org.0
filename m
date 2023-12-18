Return-Path: <kvm+bounces-4679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A445816717
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:11:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E925A284592
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F901097F;
	Mon, 18 Dec 2023 07:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="naCYG5YG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BD310944
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883451; x=1734419451;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=APhA9UsP5n4dhozn6zcpy56kYwamDIUBgEOzyd9mzp4=;
  b=naCYG5YGzepe9fMsqFllzRN347j27OU1iyNzx+i9PXQTAt1iSb08o71+
   HhOlgs/e+45uMvCEKyCAIra9mjQxk/81aOS+/al4kDVgwjJd25sXfvFCM
   wcoCXhlUOF3dC7633BOWpdvoFiHm8SKFwEkzLEuxAWOlocxHM1nQ6wD7K
   ODxbZ3LfHeeic7IfeQ0jv/yqMGiSZ61wSprZ8uqa6AYKm9F+KAaWzbwjc
   hkBdoR8jPnwXGmIYKfMxrtyiRUWaZBqa3ZJ1UoYMYfTVGQHPI2gpafWBf
   UgDdTbvJ3hav9haEAF33k97smIiEPan7s8vm5SWaiY43TJTHKEqcTLLut
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667962"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667962"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824758"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824758"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:47 -0800
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
Subject: [kvm-unit-tests RFC v2 13/18] x86 TDX: Enable lvl5 boot page table
Date: Mon, 18 Dec 2023 15:22:42 +0800
Message-Id: <20231218072247.2573516-14-qian.wen@intel.com>
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

TDVF enables lvl5 page table before pass to OS/bootloader while OVMF
enables lvl4 page table.

Check CR4.X86_CR4_LA57 to decide which page table level to use and
initialize our own lvl5 page table if TDX.

Refactor the common part of setting cr3 in a wrapper function
load_page_table().

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-13-zhenzhong.duan@intel.com
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/setup.c      | 19 +++++++++++++++++--
 x86/efi/efistart64.S |  5 +++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 82a563a3..de2dee38 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -265,10 +265,23 @@ static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
 }
 
 /* Defined in cstart64.S or efistart64.S */
+extern u8 ptl5;
 extern u8 ptl4;
 extern u8 ptl3;
 extern u8 ptl2;
 
+static void load_page_table(void)
+{
+	/*
+	 * Load new page table based on the level of firmware provided page
+	 * table.
+	 */
+	if (read_cr4() & X86_CR4_LA57)
+		write_cr3((ulong)&ptl5);
+	else
+		write_cr3((ulong)&ptl4);
+}
+
 static void setup_page_table(void)
 {
 	pgd_t *curr_pt;
@@ -281,6 +294,9 @@ static void setup_page_table(void)
 	/* Set AMD SEV C-Bit for page table entries */
 	flags |= get_amd_sev_c_bit_mask();
 
+	/* Level 5 */
+	curr_pt = (pgd_t *)&ptl5;
+	curr_pt[0] = ((phys_addr_t)&ptl4) | flags;
 	/* Level 4 */
 	curr_pt = (pgd_t *)&ptl4;
 	curr_pt[0] = ((phys_addr_t)&ptl3) | flags;
@@ -300,8 +316,7 @@ static void setup_page_table(void)
 		setup_ghcb_pte((pgd_t *)&ptl4);
 	}
 
-	/* Load 4-level page table */
-	write_cr3((ulong)&ptl4);
+	load_page_table();
 }
 
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index e3add79a..1146f83e 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -31,6 +31,11 @@ ptl4:
 	. = . + PAGE_SIZE
 .align PAGE_SIZE
 
+.globl ptl5
+ptl5:
+	. = . + PAGE_SIZE
+.align PAGE_SIZE
+
 .section .init
 .code64
 .text
-- 
2.25.1


