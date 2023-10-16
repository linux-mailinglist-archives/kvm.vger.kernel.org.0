Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBD07CAFF5
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbjJPQkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343571AbjJPQjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:39:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB1F8256;
        Mon, 16 Oct 2023 09:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473396; x=1729009396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o5ZqZe5kh4rI7M8fMrhNtQT9rpjdbgf6u1T422GjqRE=;
  b=kPlrJBct9DpxhGfWuoHNfzvtlvvltu7tAa9isS9SLjJo+6Uhi0rjzEGx
   OBD6+Ta9EZ2PcoxbBhcQTBFpht4sGzD8ZUvbpogRvzrHLdWpaJl5IXsgt
   ysoBD8Pz7WZLNBSgexKjqiOqL9QdRhL9XViYkM80AsMCisPAA9TeMLmvD
   iKDbcUSezDabMoXd6dJ0UfucW0pZg875gVF9v2tqK0ld8dsjzead9v9vO
   tMAv9zDCUwpap2Bo46wWIIoADSF/ZbKLzN6+/7olqNuJ8sDRQMQfohOCd
   Xa7bXe+gKdf/WRqWuTk/0tfMyLNvL2HuT3ADMvOVoaHZ95aM5N3JdDCmE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793140"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793140"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569226"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569226"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v5 05/16] KVM: TDX: Pass size to reclaim_page()
Date:   Mon, 16 Oct 2023 09:20:56 -0700
Message-Id: <12cd734126366ea7d9b4334002a88be838f31afb.1697473009.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697473009.git.isaku.yamahata@intel.com>
References: <cover.1697473009.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index bda2c8fa895c..72672b2c30a1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -205,12 +205,13 @@ static void tdx_disassociate_vp_on_cpu(struct kvm_vcpu *vcpu)
 	smp_call_function_single(cpu, tdx_disassociate_vp_arg, vcpu, 1);
 }
 
-static void tdx_clear_page(unsigned long page_pa)
+static void tdx_clear_page(unsigned long page_pa, int size)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
 	void *page = __va(page_pa);
 	unsigned long i;
 
+	WARN_ON_ONCE(size % PAGE_SIZE);
 	/*
 	 * When re-assign one page from old keyid to a new keyid, MOVDIR64B is
 	 * required to clear/write the page with new keyid to prevent integrity
@@ -219,7 +220,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	 * clflush doesn't flush cache with HKID set.  The cache line could be
 	 * poisoned (even without MKTME-i), clear the poison bit.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
+	for (i = 0; i < size; i += 64)
 		movdir64b(page + i, zero_page);
 	/*
 	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
@@ -228,7 +229,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	__mb();
 }
 
-static int __tdx_reclaim_page(hpa_t pa)
+static int __tdx_reclaim_page(hpa_t pa, enum pg_level level)
 {
 	struct tdx_module_args out;
 	u64 err;
@@ -246,17 +247,19 @@ static int __tdx_reclaim_page(hpa_t pa)
 		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
 		return -EIO;
 	}
+	/* out.r8 == tdx sept page level */
+	WARN_ON_ONCE(out.r8 != pg_level_to_tdx_sept_level(level));
 
 	return 0;
 }
 
-static int tdx_reclaim_page(hpa_t pa)
+static int tdx_reclaim_page(hpa_t pa, enum pg_level level)
 {
 	int r;
 
-	r = __tdx_reclaim_page(pa);
+	r = __tdx_reclaim_page(pa, level);
 	if (!r)
-		tdx_clear_page(pa);
+		tdx_clear_page(pa, KVM_HPAGE_SIZE(level));
 	return r;
 }
 
@@ -270,7 +273,7 @@ static void tdx_reclaim_td_page(unsigned long td_page_pa)
 	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
 	 * cache doesn't need to be flushed again.
 	 */
-	if (tdx_reclaim_page(td_page_pa))
+	if (tdx_reclaim_page(td_page_pa, PG_LEVEL_4K))
 		/*
 		 * Leak the page on failure:
 		 * tdx_reclaim_page() returns an error if and only if there's an
@@ -502,7 +505,7 @@ void tdx_vm_free(struct kvm *kvm)
 
 	if (!kvm_tdx->tdr_pa)
 		return;
-	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
+	if (__tdx_reclaim_page(kvm_tdx->tdr_pa, PG_LEVEL_4K))
 		return;
 	/*
 	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
@@ -515,7 +518,7 @@ void tdx_vm_free(struct kvm *kvm)
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 		return;
 	}
-	tdx_clear_page(kvm_tdx->tdr_pa);
+	tdx_clear_page(kvm_tdx->tdr_pa, PAGE_SIZE);
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
 	kvm_tdx->tdr_pa = 0;
@@ -1596,7 +1599,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		 * The HKID assigned to this TD was already freed and cache
 		 * was already flushed. We don't have to flush again.
 		 */
-		err = tdx_reclaim_page(hpa);
+		err = tdx_reclaim_page(hpa, level);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
 		tdx_unpin(kvm, pfn);
@@ -1629,7 +1632,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 		return -EIO;
 	}
-	tdx_clear_page(hpa);
+	tdx_clear_page(hpa, PAGE_SIZE);
 	tdx_unpin(kvm, pfn);
 	return 0;
 }
@@ -1741,7 +1744,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * already flushed. We don't have to flush again.
 	 */
 	if (!is_hkid_assigned(kvm_tdx))
-		return tdx_reclaim_page(__pa(private_spt));
+		return tdx_reclaim_page(__pa(private_spt), PG_LEVEL_4K);
 
 	/*
 	 * free_private_spt() is (obviously) called when a shadow page is being
-- 
2.25.1

