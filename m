Return-Path: <kvm+bounces-63315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 19AFDC621CA
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C3CD74E6599
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1811827281D;
	Mon, 17 Nov 2025 02:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WIdklyap"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B31270545;
	Mon, 17 Nov 2025 02:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347131; cv=none; b=ZvlcKkO7JJTodqcjbkXyGKgz529S4mbSfjVdQ3VBOPvAQRGBRqZzZspHwGsR0jQSQJIwN4FW7kBYlAid0kfdwRRFuo78ChbYyhubxwVBdMUNDl4HsOeIdQBCmiL4FoJKj4bhTzALgkdlJv0sUSi2sR9Api3Jc8G2RiW7Rog1uR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347131; c=relaxed/simple;
	bh=e1N/oz54KsX8rzzLfw7QmIC+ow8haaYBuL0AK+PKTYc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e/2REC20N5UdRqlJ1MyCau0WEk5tBO8mbq9Kav4Zvw2dAucjOp6ve5puXSqOszPGBdr2xgtx57CCrl5bZFyMTIXIyVF101rvn20yPqASGYsuECJlgKLTgm4Tpq+4ZslnIbqiE7oFrLA1HGNfZgJbWkzrZmkRUxfmOICN0V+V9HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WIdklyap; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347130; x=1794883130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e1N/oz54KsX8rzzLfw7QmIC+ow8haaYBuL0AK+PKTYc=;
  b=WIdklyapRdJ7xV74j/iM6f1DQSZvr/KkXIl5g+hsSC1DkZPwGKA4137N
   csyTmvteOg5z1pDo1vt2QB5Ykz8BCA52ytP8MHk7lbeaZha3IdpqBVIfp
   m7uvmDimk6zV8Qs/csH8QnX9cBtAb5An/Pk/4eMMaRc2BTHuQPCw+tUMd
   6hKLlj6+DcIPphDe17Pqvk4v/6lFSTjRBFdbrwyAhvL8tbAke5TV930/C
   qaNeP9gjLP5/Yj9itzh4AvLAnF4nnptAUriUjf6+VfGmfz/WUeJoFP324
   5DNS50yPxCEVMbd6UBSk+78ykR/XqeL4W1Z6LjakoEEyeH3otfbX8CgGw
   A==;
X-CSE-ConnectionGUID: OEVhza+lTjyZUMmH4p6d5w==
X-CSE-MsgGUID: J8JI07jITnK8zp5+n3b2EQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729565"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729565"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:50 -0800
X-CSE-ConnectionGUID: yHJXaTFlSyWV6F/0PHRXvw==
X-CSE-MsgGUID: 6w2YP3YlRkmDpLZr9w9JXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658337"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:46 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 15/26] x86/virt/tdx: Extend tdx_page_array to support IOMMU_MT
Date: Mon, 17 Nov 2025 10:22:59 +0800
Message-Id: <20251117022311.2443900-16-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IOMMU_MT is another TDX Module defined structure similar to HPA_ARRAY_T
and HPA_LIST_INFO. The difference is it supports multi-order contiguous
pages. It adds an additional NUM_PAGES field for every multi-order page
entry.

Add an dedicated allocation helper for IOMMU_MT. Maybe a general
allocation helper for multi-order is better but could postponed until
another user appears.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 71 +++++++++++++++++++++++++++++++++++--
 2 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 1eeb77a6790a..4078fc497779 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -157,6 +157,8 @@ void tdx_page_array_ctrl_leak(struct tdx_page_array *array);
 int tdx_page_array_ctrl_release(struct tdx_page_array *array,
 				unsigned int nr_released,
 				u64 released_hpa);
+struct tdx_page_array *
+tdx_page_array_create_iommu_mt(unsigned int iq_order, unsigned int nr_mt_pages);
 
 struct tdx_td {
 	/* TD root structure: */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index bbf93cad5bf2..46cdb5aaaf68 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -316,8 +316,15 @@ static int tdx_page_array_fill_root(struct tdx_page_array *array,
 			    TDX_PAGE_ARRAY_MAX_NENTS);
 
 	entries = (u64 *)page_address(array->root);
-	for (i = 0; i < array->nents; i++)
-		entries[i] = page_to_phys(array->pages[offset + i]);
+	for (i = 0; i < array->nents; i++) {
+		struct page *page = array->pages[offset + i];
+
+		entries[i] = page_to_phys(page);
+
+		/* Now only for iommu_mt */
+		if (compound_nr(page) > 1)
+			entries[i] |= compound_nr(page);
+	}
 
 	return array->nents;
 }
@@ -327,7 +334,7 @@ static void tdx_free_pages_bulk(unsigned int nr_pages, struct page **pages)
 	unsigned long i;
 
 	for (i = 0; i < nr_pages; i++)
-		__free_page(pages[i]);
+		put_page(pages[i]);
 }
 
 static int tdx_alloc_pages_bulk(unsigned int nr_pages, struct page **pages)
@@ -466,6 +473,10 @@ static bool tdx_page_array_validate_release(struct tdx_page_array *array,
 			struct page *page = array->pages[offset + i];
 			u64 val = page_to_phys(page);
 
+			/* Now only for iommu_mt */
+			if (compound_nr(page) > 1)
+				val |= compound_nr(page);
+
 			if (val != entries[i]) {
 				pr_err("%s entry[%d] [0x%llx] doesn't match page hpa [0x%llx]\n",
 				       __func__, i, entries[i], val);
@@ -516,6 +527,60 @@ int tdx_page_array_ctrl_release(struct tdx_page_array *array,
 }
 EXPORT_SYMBOL_GPL(tdx_page_array_ctrl_release);
 
+struct tdx_page_array *
+tdx_page_array_create_iommu_mt(unsigned int iq_order, unsigned int nr_mt_pages)
+{
+	unsigned int nr_entries = 2 + nr_mt_pages;
+	int ret;
+
+	if (nr_entries > TDX_PAGE_ARRAY_MAX_NENTS)
+		return NULL;
+
+	struct tdx_page_array *array __free(kfree) = kzalloc(sizeof(*array),
+							     GFP_KERNEL);
+	if (!array)
+		return NULL;
+
+	struct page *root __free(__free_page) = alloc_page(GFP_KERNEL |
+							   __GFP_ZERO);
+	if (!root)
+		return NULL;
+
+	struct page **pages __free(kfree) = kcalloc(nr_entries, sizeof(*pages),
+						    GFP_KERNEL);
+	if (!pages)
+		return NULL;
+
+	/* TODO: folio_alloc_node() is preferred, but need numa info */
+	struct folio *t_iq __free(folio_put) = folio_alloc(GFP_KERNEL |
+							   __GFP_ZERO,
+							   iq_order);
+	if (!t_iq)
+		return NULL;
+
+	struct folio *t_ctxiq __free(folio_put) = folio_alloc(GFP_KERNEL |
+							      __GFP_ZERO,
+							      iq_order);
+	if (!t_ctxiq)
+		return NULL;
+
+	ret = tdx_alloc_pages_bulk(nr_mt_pages, pages + 2);
+	if (ret)
+		return NULL;
+
+	pages[0] = folio_page(no_free_ptr(t_iq), 0);
+	pages[1] = folio_page(no_free_ptr(t_ctxiq), 0);
+
+	array->nr_pages = nr_entries;
+	array->pages = no_free_ptr(pages);
+	array->root = no_free_ptr(root);
+
+	tdx_page_array_fill_root(array, 0);
+
+	return no_free_ptr(array);
+}
+EXPORT_SYMBOL_GPL(tdx_page_array_create_iommu_mt);
+
 #define HPA_LIST_INFO_FIRST_ENTRY	GENMASK_U64(11, 3)
 #define HPA_LIST_INFO_PFN		GENMASK_U64(51, 12)
 #define HPA_LIST_INFO_LAST_ENTRY	GENMASK_U64(63, 55)
-- 
2.25.1


