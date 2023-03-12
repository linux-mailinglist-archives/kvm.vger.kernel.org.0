Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918A36B64A7
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjCLKBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCLKAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD9722C8A
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615181; x=1710151181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fJ89UYJqQF7xwrI7dLth+9gEQfqrrb2IM6at1k7Bt6Q=;
  b=BVC4VvGkMPeL7kg0tQc3iXWNKX7rfXhkqGFa3Ea3Hl3rQ7bM6aFPDmAR
   jXYcGRgOQQdjqdMmOya3+tNY/4AM463/ycOz05Mmiawpan/35tJtC+be0
   vEtW4hmUvBOVbPNor8kTvBnjPESLN/gMO18Ul30QvqGiDtESK1UQp6/xD
   5V4SviD1JDKjtYdCz+iIJ7ksWdqNCxz21STZp6BxOdC2ekvvgx3eF20Y9
   tgnnZ78yn/qC/9VFvnLO5xpj/X7ciJIxWX4DH2Q39wfoqcG7H3EGZl1fp
   nmLjlF/WRfU66/Ng/KS7RPz7si/BT/2J7d0L6s4jBgJxaPL1+xoRef5eb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344752"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344752"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627499"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627499"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:23 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>
Subject: [RFC PATCH part-7 03/12] pkvm: x86: Use SW bits to track page state
Date:   Mon, 13 Mar 2023 02:04:06 +0800
Message-Id: <20230312180415.1778669-4-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180415.1778669-1-jason.cj.chen@intel.com>
References: <20230312180415.1778669-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shaoqin.huang@intel.com>

pKVM already had a mechnism to record page ownership in host EPT, it
still needs a place to record page state based on the ownership; the page
state is used to identify the exact state of corresponding page:

- PKVM_NOPAGE: the page has no mapping in page table (also invalid pte).
               And under this page state, host EPT is using the pte
	       ignored bits to record owner_id.
- PKVM_PAGE_OWNED: the page is owned exclusively by the page-table owner.
- PKVM_PAGE_SHARED_OWNED: the page is owned by the page-table owner, but
			  is shared with another entity.
- PKVM_PAGE_SHARED_BORROWED: the page is shared with, but not owned by
			     the page-table owner.

The bit[56,57] of a EPT page table are ignored in the PTE, so use these
two bits as SW bits to record the page state.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c | 13 ++++++++-
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h | 39 +++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
index a6554a039468..625c138addfb 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
@@ -10,7 +10,9 @@
 
 static u64 pkvm_init_invalid_leaf_owner(pkvm_id owner_id)
 {
-	return FIELD_PREP(PKVM_INVALID_PTE_OWNER_MASK, owner_id);
+	/* the page owned by others also means NOPAGE in page state */
+	return FIELD_PREP(PKVM_INVALID_PTE_OWNER_MASK, owner_id) |
+		FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, PKVM_NOPAGE);
 }
 
 static int host_ept_set_owner_locked(phys_addr_t addr, u64 size, pkvm_id owner_id)
@@ -18,6 +20,15 @@ static int host_ept_set_owner_locked(phys_addr_t addr, u64 size, pkvm_id owner_i
 	u64 annotation = pkvm_init_invalid_leaf_owner(owner_id);
 	int ret;
 
+
+	/*
+	 * The memory [addr, addr + size) will be unmapped from host ept. At the
+	 * same time, the annotation with a NOPAGE flag will be put in the
+	 * invalid pte that has been unmapped. And the information shows that
+	 * the page has been used by some guest and its id can be read from
+	 * annotation. Also when later these pages are back to host, the annotation
+	 * will be helpful to check the right page transition.
+	 */
 	ret = pkvm_pgtable_annotate(pkvm_hyp->host_vm.ept, addr, size, annotation);
 
 	return ret;
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
index 728de3ac62dd..6b5e0fcbdda0 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h
@@ -5,9 +5,48 @@
 #ifndef __PKVM_MEM_PROTECT_H__
 #define __PKVM_MEM_PROTECT_H__
 
+/*
+ * enum pkvm_pgtable_prot - The ignored bits in page-table.
+ * pkvm will use these ignored bits as software bits to
+ * identify the page status.
+ */
+enum pkvm_pgtable_prot {
+	PKVM_PGTABLE_PROT_SW0		= BIT(56),
+	PKVM_PGTABLE_PROT_SW1		= BIT(57),
+};
+
+/*
+ * Using the ignored bits in page-table as SW bits.
+ * SW bits 0-1 are used to track the memory ownership state of each page:
+ *   00: The page has no mapping in page table (also invalid pte). And under
+ *   this page state, host ept is using the pte ignored bits to record owner_id.
+ *   01: The page is owned exclusively by the page-table owner.
+ *   10: The page is owned by the page-table owner, but is shared
+ *   	with another entity.
+ *   11: The page is shared with, but not owned by the page-table owner.
+ */
+enum pkvm_page_state {
+	PKVM_NOPAGE			= 0ULL,
+	PKVM_PAGE_OWNED			= PKVM_PGTABLE_PROT_SW0,
+	PKVM_PAGE_SHARED_OWNED		= PKVM_PGTABLE_PROT_SW1,
+	PKVM_PAGE_SHARED_BORROWED	= PKVM_PGTABLE_PROT_SW0 |
+					  PKVM_PGTABLE_PROT_SW1,
+};
+
+#define PKVM_PAGE_STATE_PROT_MASK	(PKVM_PGTABLE_PROT_SW0 | PKVM_PGTABLE_PROT_SW1)
 /* use 20 bits[12~31] - not conflict w/ low 12 bits pte prot */
 #define PKVM_INVALID_PTE_OWNER_MASK	GENMASK(31, 12)
 
+static inline u64 pkvm_mkstate(u64 prot, enum pkvm_page_state state)
+{
+	return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
+}
+
+static inline enum pkvm_page_state pkvm_getstate(u64 pte)
+{
+	return pte & PKVM_PAGE_STATE_PROT_MASK;
+}
+
 typedef u32 pkvm_id;
 
 #define OWNER_ID_HYP	0UL
-- 
2.25.1

