Return-Path: <kvm+bounces-63306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB40C62197
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 483263AD839
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BCD824EF76;
	Mon, 17 Nov 2025 02:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O1yQMtMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B1E24EF8C;
	Mon, 17 Nov 2025 02:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347099; cv=none; b=Vxliw6x6JI2WHzlAXvaWHXNQuN1q6+Epdji6R5Er4qYm2YKkLxPJY3CM2cXWRTZdv1cp3u7xV0eDk6rHF9Ycz30AoeS9XDB9bf/VFLNPrcHPNtdI2Tz7MlOoaXCP7Aht7kiV6oUz69h4RRRSx/6heYFziehso8Vs1jf8oEs/1U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347099; c=relaxed/simple;
	bh=D8fnQ6Zn2eGA3dVtz4LRNlU94dIm8mQ4lhCQNFBudQk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hpb3jh6yiqZTo+uMxQqyn8Y3XAL9qeVw4K0uwHHxbfA/oqvwx9OEvpiwRF/DyJjW2t/DiCZpnUQsWbDejnpWE6fuDvSI+WvOlBpTicLyLMIDdCpse9S1PQ6P6y0itvl4pnlzM4r5UDXO1/mv+YriWweqHQSfr1oaMBXDYy8YYlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O1yQMtMQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347098; x=1794883098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D8fnQ6Zn2eGA3dVtz4LRNlU94dIm8mQ4lhCQNFBudQk=;
  b=O1yQMtMQ3PpmlOfNkKTdIYgEuJjRkda07EQlVXNyfHGLdY1by2w0P0uF
   VGUKT9+eU4yawqANOXkxtps9qa9TS+Y8arfXuUu0iUi1vXaSflBPTJ7kx
   zY3HPeyhbey5CSJH3WD3vrNfLz56syvD1AhH2eCHFmNQ/MXOsPSs/E/g0
   bryOIgyrTedH83b8eUYGUQcO1voZNZQVFYnCbhtNQl3zFKTgofRoLnCyQ
   eLpHvvP4x3rfXOv6YT+wh1LMoJq/ojqP8NRkv7q4YvKEOMx5M6QFFCDe8
   +t3bah2qZU0hpVS42L+kUF/kJ63pKiESvQuaUKCP8juY/cUqsCOBAyhF8
   g==;
X-CSE-ConnectionGUID: 3mH15WFuRCe6C+pv7hEhPA==
X-CSE-MsgGUID: xB+woRsbRu6XqGG/HAyIHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729515"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729515"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:18 -0800
X-CSE-ConnectionGUID: zRH07tI9T+Gm8vYZCwnQAA==
X-CSE-MsgGUID: 5yg7QacaQK2FZNze6dEopQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658212"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:13 -0800
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
Subject: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for new TDX Module objects
Date: Mon, 17 Nov 2025 10:22:50 +0800
Message-Id: <20251117022311.2443900-7-yilun.xu@linux.intel.com>
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

Add struct tdx_page_array definition for new TDX Module object
types - HPA_ARRAY_T and HPA_LIST_INFO. They are used as input/output
parameters in newly defined SEAMCALLs. Also define some helpers to
allocate, setup and free tdx_page_array.

HPA_ARRAY_T and HPA_LIST_INFO are similar in most aspects. They both
represent a list of pages for TDX Module accessing. There are several
use cases for these 2 structures:

 - As SEAMCALL inputs. They are claimed by TDX Module as control pages.
 - As SEAMCALL outputs. They were TDX Module control pages and now are
   released.
 - As SEAMCALL inputs. They are just temporary buffers for exchanging
   data blobs in one SEAMCALL. TDX Module will not hold them as control
   pages.

The 2 structures both need a 'root page' which contains a list of HPAs.
They collapse the HPA of the root page and the number of valid HPAs
into a 64 bit raw value for SEAMCALL parameters. The root page is
always a medium for passing data pages, TDX Module never keeps the root
page.

A main difference is HPA_ARRAY_T requires singleton mode when
containing just 1 functional page (page0). In this mode the root page is
not needed and the HPA field of the raw value directly points to the
page0. But in this patch, root page is always allocated for user
friendly kAPIs.

Another small difference is HPA_LIST_INFO contains a 'first entry' field
which could be filled by TDX Module. This simplifies host by providing
the same structure when re-invoke the interrupted SEAMCALL. No need for
host to touch this field.

Typical usages of the tdx_page_array:

1. Add control pages:
 - struct tdx_page_array *array = tdx_page_array_create(nr_pages);
 - seamcall(TDH_XXX_CREATE, array, ...);

2. Release control pages:
 - seamcall(TDX_XXX_DELETE, array, &nr_released, &released_hpa);
 - tdx_page_array_ctrl_release(array, nr_released, released_hpa);

3. Exchange data blobs:
 - struct tdx_page_array *array = tdx_page_array_create(nr_pages);
 - seamcall(TDX_XXX, array, ...);
 - Read data from array.
 - tdx_page_array_free(array);

4. Note the root page contains 512 HPAs at most, if more pages are
   required, refilling the tdx_page_array is needed.

 - struct tdx_page_array *array = tdx_page_array_alloc(nr_pages);
 - for each 512-page bulk
   - tdx_page_array_fill_root(array, offset);
   - seamcall(TDH_XXX_ADD, array, ...);

In case 2, SEAMCALLs output the released page array in the form of
HPA_ARRAY_T or PAGE_LIST_INFO. tdx_page_array_ctrl_release() is
responsible for checking if the output pages match the original input
pages. If failed to match, the safer way is to leak the control pages,
tdx_page_array_ctrl_leak() should be called.

The usage of tdx_page_array will be in following patches.

Co-developed-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/tdx.h  |  17 +++
 arch/x86/virt/vmx/tdx/tdx.c | 252 ++++++++++++++++++++++++++++++++++++
 2 files changed, 269 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index ad27b746522f..3a3ea3fa04f2 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -139,6 +139,23 @@ void tdx_guest_keyid_free(unsigned int keyid);
 
 void tdx_quirk_reset_page(struct page *page);
 
+struct tdx_page_array {
+	unsigned int nr_pages;
+	struct page **pages;
+
+	unsigned int offset;
+	unsigned int nents;
+	struct page *root;
+};
+
+void tdx_page_array_free(struct tdx_page_array *array);
+DEFINE_FREE(tdx_page_array_free, struct tdx_page_array *, if (_T) tdx_page_array_free(_T))
+struct tdx_page_array *tdx_page_array_create(unsigned int nr_pages);
+void tdx_page_array_ctrl_leak(struct tdx_page_array *array);
+int tdx_page_array_ctrl_release(struct tdx_page_array *array,
+				unsigned int nr_released,
+				u64 released_hpa);
+
 struct tdx_td {
 	/* TD root structure: */
 	struct page *tdr_page;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 09c766e60962..9a5c32dc1767 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -30,6 +30,7 @@
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/idr.h>
+#include <linux/bitfield.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
 #include <asm/msr-index.h>
@@ -296,6 +297,257 @@ static __init int build_tdx_memlist(struct list_head *tmb_list)
 	return ret;
 }
 
+#define TDX_PAGE_ARRAY_MAX_NENTS	(PAGE_SIZE / sizeof(u64))
+
+static int tdx_page_array_fill_root(struct tdx_page_array *array,
+				    unsigned int offset)
+{
+	unsigned int i;
+	u64 *entries;
+
+	if (offset >= array->nr_pages)
+		return 0;
+
+	array->offset = offset;
+	array->nents = umin(array->nr_pages - offset,
+			    TDX_PAGE_ARRAY_MAX_NENTS);
+
+	entries = (u64 *)page_address(array->root);
+	for (i = 0; i < array->nents; i++)
+		entries[i] = page_to_phys(array->pages[offset + i]);
+
+	return array->nents;
+}
+
+static void tdx_free_pages_bulk(unsigned int nr_pages, struct page **pages)
+{
+	unsigned long i;
+
+	for (i = 0; i < nr_pages; i++)
+		__free_page(pages[i]);
+}
+
+static int tdx_alloc_pages_bulk(unsigned int nr_pages, struct page **pages)
+{
+	unsigned int filled, done = 0;
+
+	do {
+		filled = alloc_pages_bulk(GFP_KERNEL, nr_pages - done,
+					  pages + done);
+		if (!filled) {
+			tdx_free_pages_bulk(done, pages);
+			return -ENOMEM;
+		}
+
+		done += filled;
+	} while (done != nr_pages);
+
+	return 0;
+}
+
+void tdx_page_array_free(struct tdx_page_array *array)
+{
+	if (!array)
+		return;
+
+	__free_page(array->root);
+	tdx_free_pages_bulk(array->nr_pages, array->pages);
+	kfree(array->pages);
+	kfree(array);
+}
+EXPORT_SYMBOL_GPL(tdx_page_array_free);
+
+static struct tdx_page_array *tdx_page_array_alloc(unsigned int nr_pages)
+{
+	int ret;
+
+	if (!nr_pages)
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
+	struct page **pages __free(kfree) = kcalloc(nr_pages, sizeof(*pages),
+						    GFP_KERNEL);
+	if (!pages)
+		return NULL;
+
+	ret = tdx_alloc_pages_bulk(nr_pages, pages);
+	if (ret)
+		return NULL;
+
+	array->nr_pages = nr_pages;
+	array->pages = no_free_ptr(pages);
+	array->root = no_free_ptr(root);
+
+	return no_free_ptr(array);
+}
+
+/*
+ * For holding less than TDX_PAGE_ARRAY_MAX_NENTS (512) pages.
+ *
+ * If more pages are required, use tdx_page_array_alloc() and
+ * tdx_page_array_fill_root() to build tdx_page_array chunk by chunk.
+ */
+struct tdx_page_array *tdx_page_array_create(unsigned int nr_pages)
+{
+	int filled;
+
+	if (nr_pages > TDX_PAGE_ARRAY_MAX_NENTS)
+		return NULL;
+
+	struct tdx_page_array *array __free(tdx_page_array_free) =
+		tdx_page_array_alloc(nr_pages);
+	if (!array)
+		return NULL;
+
+	filled = tdx_page_array_fill_root(array, 0);
+	if (filled != nr_pages)
+		return NULL;
+
+	return no_free_ptr(array);
+}
+EXPORT_SYMBOL_GPL(tdx_page_array_create);
+
+/*
+ * Call this function when failed to reclaim the control pages. The root page
+ * and the holding structures can still be freed.
+ */
+void tdx_page_array_ctrl_leak(struct tdx_page_array *array)
+{
+	__free_page(array->root);
+	kfree(array->pages);
+	kfree(array);
+}
+EXPORT_SYMBOL_GPL(tdx_page_array_ctrl_leak);
+
+static bool tdx_page_array_validate_release(struct tdx_page_array *array,
+					    unsigned int offset,
+					    unsigned int nr_released,
+					    u64 released_hpa)
+{
+	unsigned int nents;
+	u64 *entries;
+	int i;
+
+	if (offset >= array->nr_pages)
+		return false;
+
+	nents = umin(array->nr_pages - offset, TDX_PAGE_ARRAY_MAX_NENTS);
+
+	if (nents != nr_released) {
+		pr_err("%s nr_released [%d] doesn't match page array nents [%d]\n",
+		       __func__, nr_released, nents);
+		return false;
+	}
+
+	/*
+	 * Unfortunately TDX has multiple page allocation protocols, check the
+	 * "singleton" case required for HPA_ARRAY_T.
+	 */
+	if (page_to_phys(array->pages[0]) == released_hpa &&
+	    array->nr_pages == 1)
+		return true;
+
+	/* Then check the "non-singleton" case */
+	if (page_to_phys(array->root) == released_hpa) {
+		entries = (u64 *)page_address(array->root);
+		for (i = 0; i < nents; i++) {
+			struct page *page = array->pages[offset + i];
+			u64 val = page_to_phys(page);
+
+			if (val != entries[i]) {
+				pr_err("%s entry[%d] [0x%llx] doesn't match page hpa [0x%llx]\n",
+				       __func__, i, entries[i], val);
+				return false;
+			}
+		}
+
+		return true;
+	}
+
+	pr_err("%s failed to validate, released_hpa [0x%llx], root page hpa [0x%llx], page0 hpa [%#llx], number pages %u\n",
+	       __func__, released_hpa, page_to_phys(array->root),
+	       page_to_phys(array->pages[0]), array->nr_pages);
+
+	return false;
+}
+
+/* For releasing control pages which are created by tdx_page_array_create() */
+int tdx_page_array_ctrl_release(struct tdx_page_array *array,
+				unsigned int nr_released,
+				u64 released_hpa)
+{
+	int i;
+	u64 r;
+
+	/*
+	 * The only case where ->nr_pages is allowed to be >
+	 * TDX_PAGE_ARRAY_MAX_NENTS is a case where those pages are never
+	 * expected to be released by this function.
+	 */
+	if (WARN_ON(array->nr_pages > TDX_PAGE_ARRAY_MAX_NENTS))
+		return -EINVAL;
+
+	if (WARN_ONCE(!tdx_page_array_validate_release(array, 0, nr_released,
+						       released_hpa),
+		      "page release protocol error, TDX Module needs replacement.\n"))
+		return -EFAULT;
+
+	for (i = 0; i < array->nr_pages; i++) {
+		r = tdh_phymem_page_wbinvd_hkid(tdx_global_keyid,
+						array->pages[i]);
+		if (WARN_ON(r))
+			return -EFAULT;
+	}
+
+	tdx_page_array_free(array);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tdx_page_array_ctrl_release);
+
+#define HPA_LIST_INFO_FIRST_ENTRY	GENMASK_U64(11, 3)
+#define HPA_LIST_INFO_PFN		GENMASK_U64(51, 12)
+#define HPA_LIST_INFO_LAST_ENTRY	GENMASK_U64(63, 55)
+
+static u64 __maybe_unused hpa_list_info_assign_raw(struct tdx_page_array *array)
+{
+	return FIELD_PREP(HPA_LIST_INFO_FIRST_ENTRY, 0) |
+	       FIELD_PREP(HPA_LIST_INFO_PFN, page_to_pfn(array->root)) |
+	       FIELD_PREP(HPA_LIST_INFO_LAST_ENTRY, array->nents - 1);
+}
+
+#define HPA_ARRAY_T_PFN		GENMASK_U64(51, 12)
+#define HPA_ARRAY_T_SIZE	GENMASK_U64(63, 55)
+
+static u64 __maybe_unused hpa_array_t_assign_raw(struct tdx_page_array *array)
+{
+	struct page *page;
+
+	if (array->nents == 1)
+		page = array->pages[0];
+	else
+		page = array->root;
+
+	return FIELD_PREP(HPA_ARRAY_T_PFN, page_to_pfn(page)) |
+	       FIELD_PREP(HPA_ARRAY_T_SIZE, array->nents - 1);
+}
+
+static u64 __maybe_unused hpa_array_t_release_raw(struct tdx_page_array *array)
+{
+	if (array->nents == 1)
+		return 0;
+
+	return page_to_phys(array->root);
+}
+
 static __init int read_sys_metadata_field(u64 field_id, u64 *data)
 {
 	struct tdx_module_args args = {};
-- 
2.25.1


