Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15DA667C45
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbjALRML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbjALRLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:11:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EEF7CBC8;
        Thu, 12 Jan 2023 08:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542108; x=1705078108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KQ1XXWMbHl0MYIHVHrHXAlrv8TLu2HVtsjPVNJosGr4=;
  b=DyMXvunT/OLYrUiV63qk4rmlccFCeEiFeUb586hMO5JCo9351FlWdf4e
   fpq4X9M1Rb4QzFncFts4DZWe5dmtpnLa18xwiJyZeMLd8mUwU7CnGcd5q
   sKqUx6CuA9WueqGxRfPdwdFvR8EL1TrPFaTsK+qoM0RgY/B/PGEAEDm1c
   iTmO86ipF0jILI85HHtxIHb7av84Z0dBfFt90SOJUdCG+Y+CMOASxzVcd
   4olVKbKkrGBf9u360GSaOfzQ/adql/eVjPgzY6+SoxEycCdXF08z6XROr
   tjXWjYG7zgtXGDxtmz9WymcyX+APM+JRz/YDmgqWqhwnj4IpJN9JRus/l
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816295"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816295"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658335"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658335"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:16 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 05/16] KVM: TDX: Pass size to reclaim_page()
Date:   Thu, 12 Jan 2023 08:43:57 -0800
Message-Id: <ffbfe8f9f548e0f3ab5fec18395697eac54cdc03.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673541292.git.isaku.yamahata@intel.com>
References: <cover.1673541292.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

A 2MB large page can be tdh_mem_page_aug()'ed to TD directly. In this case,
it needs to reclaim and clear the page as 2MB size.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1bc07dfe765a..8bc8fd7f28eb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -184,14 +184,17 @@ void tdx_hardware_disable(void)
 		tdx_disassociate_vp(&tdx->vcpu);
 }
 
-static void tdx_clear_page(unsigned long page_pa)
+static void tdx_clear_page(unsigned long page_pa, int size)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
 	void *page = __va(page_pa);
 	unsigned long i;
 
+	WARN_ON_ONCE(size % PAGE_SIZE);
+
 	if (!static_cpu_has(X86_FEATURE_MOVDIR64B)) {
-		clear_page(page);
+		for (i = 0; i < size; i += PAGE_SIZE)
+			clear_page(page + i);
 		return;
 	}
 
@@ -205,7 +208,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	 * The cache line could be poisoned (even without MKTME-i), clear the
 	 * poison bit.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
+	for (i = 0; i < size; i += 64)
 		movdir64b(page + i, zero_page);
 	/*
 	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
@@ -214,7 +217,8 @@ static void tdx_clear_page(unsigned long page_pa)
 	__mb();
 }
 
-static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
+static int tdx_reclaim_page(hpa_t pa, enum pg_level level,
+			    bool do_wb, u16 hkid)
 {
 	struct tdx_module_output out;
 	u64 err;
@@ -232,8 +236,10 @@ static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
 		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
 		return -EIO;
 	}
+	/* out.r8 == tdx sept page level */
+	WARN_ON_ONCE(out.r8 != pg_level_to_tdx_sept_level(level));
 
-	if (do_wb) {
+	if (do_wb && level == PG_LEVEL_4K) {
 		/*
 		 * Only TDR page gets into this path.  No contention is expected
 		 * because of the last page of TD.
@@ -245,7 +251,7 @@ static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
 		}
 	}
 
-	tdx_clear_page(pa);
+	tdx_clear_page(pa, KVM_HPAGE_SIZE(level));
 	return 0;
 }
 
@@ -259,7 +265,7 @@ static void tdx_reclaim_td_page(unsigned long td_page_pa)
 	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
 	 * cache doesn't need to be flushed again.
 	 */
-	if (WARN_ON(tdx_reclaim_page(td_page_pa, false, 0)))
+	if (WARN_ON(tdx_reclaim_page(td_page_pa, PG_LEVEL_4K, false, 0)))
 		/* If reclaim failed, leak the page. */
 		return;
 	free_page((unsigned long)__va(td_page_pa));
@@ -436,7 +442,7 @@ void tdx_vm_free(struct kvm *kvm)
 	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with
 	 * TDX global HKID is needed.
 	 */
-	if (tdx_reclaim_page(kvm_tdx->tdr_pa, true, tdx_global_keyid))
+	if (tdx_reclaim_page(kvm_tdx->tdr_pa, PG_LEVEL_4K, true, tdx_global_keyid))
 		return;
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
@@ -1427,7 +1433,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		 * The HKID assigned to this TD was already freed and cache
 		 * was already flushed. We don't have to flush again.
 		 */
-		err = tdx_reclaim_page(hpa, false, 0);
+		err = tdx_reclaim_page(hpa, level, false, 0);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
 		tdx_unpin(kvm, pfn);
@@ -1566,7 +1572,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * already flushed. We don't have to flush again.
 	 */
 	if (!is_hkid_assigned(kvm_tdx))
-		return tdx_reclaim_page(__pa(private_spt), false, 0);
+		return tdx_reclaim_page(__pa(private_spt), PG_LEVEL_4K, false, 0);
 
 	/*
 	 * free_private_spt() is (obviously) called when a shadow page is being
-- 
2.25.1

