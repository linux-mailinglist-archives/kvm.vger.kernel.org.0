Return-Path: <kvm+bounces-983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D727E42B9
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0FE71C211C4
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF9638F82;
	Tue,  7 Nov 2023 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9Oi4YP/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37113717B
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:02 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431335FEA;
	Tue,  7 Nov 2023 07:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369320; x=1730905320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=icTrF8o6LyxIxovBNl655YH6mhHs5TgjhfZ3qg2BIJY=;
  b=O9Oi4YP/FIX4GPa5/unaa5NbdgIJg1Y/XmriFoU/gQD5A76FrhEvXTVQ
   Dza7xMV5CMmCy5BvmNa0/OHeJjAJxvoaEhetExuTC5tv2d/OXgdxyaMXB
   KBBz3/MIBjK5KR9CWXM8hZDGLKoNnpNIL4jxX9ZO+JxrUNnzBE9L4ZtAW
   Gfp2XTvnX83rOe6n4qQxBoXRRBZLjnx12Snch1inw5ecsY0574E9G1aiI
   e8sgKv2JmMROloZlp/4Vd/I5dFkoSKSBDkARgzxssQzoKJ873YQu7rWOT
   XoxUvdk8PM27ppGbuOhoNawhuvxW5dH6th7LJItOpfHGNet9/qKTysM4o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="388397539"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="388397539"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10446560"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:54 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 05/16] KVM: TDX: Pass size to reclaim_page()
Date: Tue,  7 Nov 2023 07:00:32 -0800
Message-Id: <31552f714f2fd8178f9467e9afaaf28ba3de3c7b.1699368363.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368363.git.isaku.yamahata@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

A 2MB large page can be tdh_mem_page_aug()'ed to TD directly. In this case,
it needs to reclaim and clear the page as 2MB size.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a728175c4a6d..0fca863faeee 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -200,12 +200,13 @@ static void tdx_disassociate_vp_on_cpu(struct kvm_vcpu *vcpu)
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
@@ -214,7 +215,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	 * clflush doesn't flush cache with HKID set.  The cache line could be
 	 * poisoned (even without MKTME-i), clear the poison bit.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
+	for (i = 0; i < size; i += 64)
 		movdir64b(page + i, zero_page);
 	/*
 	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
@@ -223,7 +224,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	__mb();
 }
 
-static int __tdx_reclaim_page(hpa_t pa)
+static int __tdx_reclaim_page(hpa_t pa, enum pg_level level)
 {
 	struct tdx_module_args out;
 	u64 err;
@@ -241,17 +242,19 @@ static int __tdx_reclaim_page(hpa_t pa)
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
 
@@ -265,7 +268,7 @@ static void tdx_reclaim_td_page(unsigned long td_page_pa)
 	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
 	 * cache doesn't need to be flushed again.
 	 */
-	if (tdx_reclaim_page(td_page_pa))
+	if (tdx_reclaim_page(td_page_pa, PG_LEVEL_4K))
 		/*
 		 * Leak the page on failure:
 		 * tdx_reclaim_page() returns an error if and only if there's an
@@ -497,7 +500,7 @@ void tdx_vm_free(struct kvm *kvm)
 
 	if (!kvm_tdx->tdr_pa)
 		return;
-	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
+	if (__tdx_reclaim_page(kvm_tdx->tdr_pa, PG_LEVEL_4K))
 		return;
 	/*
 	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
@@ -510,7 +513,7 @@ void tdx_vm_free(struct kvm *kvm)
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 		return;
 	}
-	tdx_clear_page(kvm_tdx->tdr_pa);
+	tdx_clear_page(kvm_tdx->tdr_pa, PAGE_SIZE);
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
 	kvm_tdx->tdr_pa = 0;
@@ -1597,7 +1600,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		 * The HKID assigned to this TD was already freed and cache
 		 * was already flushed. We don't have to flush again.
 		 */
-		err = tdx_reclaim_page(hpa);
+		err = tdx_reclaim_page(hpa, level);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
 		tdx_unpin(kvm, pfn);
@@ -1630,7 +1633,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 		return -EIO;
 	}
-	tdx_clear_page(hpa);
+	tdx_clear_page(hpa, PAGE_SIZE);
 	tdx_unpin(kvm, pfn);
 	return 0;
 }
@@ -1742,7 +1745,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * already flushed. We don't have to flush again.
 	 */
 	if (!is_hkid_assigned(kvm_tdx))
-		return tdx_reclaim_page(__pa(private_spt));
+		return tdx_reclaim_page(__pa(private_spt), PG_LEVEL_4K);
 
 	/*
 	 * free_private_spt() is (obviously) called when a shadow page is being
-- 
2.25.1


