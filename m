Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D5D4CB7C1
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiCCH2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiCCH2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:45 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD113E5FC
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292470; x=1677828470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8woeIU/iix6qyra7P6vahSx8k+pr4gm0x9nMEUBjbcQ=;
  b=AR0NJxYfayn2qfwiXvm9r6dhnH7t83O11nV2NfK40rA/MLEQ5Mi28nUf
   njtg6Vbbu1Dqusu37dBOYp9A/VTDL9/LKnCGhMNffXvKetniLrYPp2+G8
   NumNObU+6T5+ljGHnFH9vyTfmxwKfNNlbbypWVxLqauL3FnRvXKVMhW6s
   NmFXnoM6ORKEj75AKtKRC1ZRWz/NTRiKxQiPef2y9BJZBYkeHYxXIdBgA
   +4hTtFALuLIuE32o4t2ERnIc3+re4b4oUdhHkxaio/KTcY/FmKFYthidv
   HE6cpx8eUryrmlKDr+dmjzbDMwZRiBXf769XJAY5zkTXWjjmOHDDcYK9l
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251177017"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251177017"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:50 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631745"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:47 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 12/17] x86 TDX: Enable lvl5 boot page table
Date:   Thu,  3 Mar 2022 15:19:02 +0800
Message-Id: <20220303071907.650203-13-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDVF enables lvl5 page table before pass to OS/bootloader
while OVMF enables lvl4 page table.

Check CR4.X86_CR4_LA57 to decide which page table level to use
and initialize our own lvl5 page table if TDX.

Move setup_page_table() before APs startup so that lvl5 page
table is ready for APs. Refactor the common part of setting
cr3 in a wrapper function load_page_table().

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/setup.c      | 22 +++++++++++++++++++---
 x86/efi/efistart64.S |  5 +++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7bf5d431f2a8..3a60762494d6 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -231,10 +231,23 @@ static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
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
@@ -247,6 +260,9 @@ static void setup_page_table(void)
 	/* Set AMD SEV C-Bit for page table entries */
 	flags |= get_amd_sev_c_bit_mask();
 
+	/* Level 5 */
+	curr_pt = (pgd_t *)&ptl5;
+	curr_pt[0] = ((phys_addr_t)&ptl4) | flags;
 	/* Level 4 */
 	curr_pt = (pgd_t *)&ptl4;
 	curr_pt[0] = ((phys_addr_t)&ptl3) | flags;
@@ -266,8 +282,7 @@ static void setup_page_table(void)
 		setup_ghcb_pte((pgd_t *)&ptl4);
 	}
 
-	/* Load 4-level page table */
-	write_cr3((ulong)&ptl4);
+	load_page_table();
 }
 
 static void setup_gdt_tss(void)
@@ -297,6 +312,7 @@ void secondary_startup_64(void)
 	setup_percpu_area();
 	enable_x2apic();
 	tdx_ap_init();
+	load_page_table();
 
 	while (1)
 		safe_halt();
@@ -372,9 +388,9 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	if (!is_tdx_guest())
 		enable_apic();
 	enable_x2apic();
+	setup_page_table();
 	aps_init();
 	smp_init();
-	setup_page_table();
 
 	return EFI_SUCCESS;
 }
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 648d047febb5..ef3db0110c3c 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -22,6 +22,11 @@ ptl4:
 	. = . + PAGE_SIZE
 .align PAGE_SIZE
 
+.globl ptl5
+ptl5:
+	. = . + PAGE_SIZE
+.align PAGE_SIZE
+
 .globl stacktop
 	. = . + PAGE_SIZE * MAX_TEST_CPUS
 stacktop:
-- 
2.25.1

