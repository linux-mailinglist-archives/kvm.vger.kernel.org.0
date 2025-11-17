Return-Path: <kvm+bounces-63319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BA020C621EE
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 53EEC4E6045
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C42263C8F;
	Mon, 17 Nov 2025 02:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ACAEfR//"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90410262D27;
	Mon, 17 Nov 2025 02:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347145; cv=none; b=h6EylOlX9hRSZ9Oaxz3tuGeJ8NTMmUZGXjpLte0pTYMlzfVSljUyC6XY2SKfxkMvRvoE62c8jXmFpYsgV23A8CkKardiBh7a9cFtIgHebCbJ7+u/SdlDV4aNpU5agdFfneGklSBtVTqVlOwuiQAvXiZILYEUybqBF1On2sVz3O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347145; c=relaxed/simple;
	bh=JB/3HGjul33CthZt+KNgO9pBuJ24i8vcRNY77ORswB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uvV4KBb7B0dUKQgY7QuXWskbl2lRK5LSwumPWhmo3iQ6L4l3xrQbEV6fiGCKyZy//HMdBV3+m7g8sn3YMbFocvCmU6+FK5JVRXmZHqQHnp9CBQR+HYPWAs53p+wl4ZKD36YNy1NwocD44rnEq1z7Tei1SAaOcUUl3KQiIMyUGwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ACAEfR//; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347144; x=1794883144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JB/3HGjul33CthZt+KNgO9pBuJ24i8vcRNY77ORswB0=;
  b=ACAEfR//+v3zI/LPhfznd889RngCKgLDpZ9v2U+8NfoC+hmvRGSCV2Na
   Qbe0wLtMCdkcnx4T6EfWpt/QEuE+wXrp3GXRQGzU9Y4jBcZ4Z0rFOB9R1
   z9Xkl5kwuII6G5A96QAHM75tYk2VD637LFtPhocQKSctCAc1HFT5ZyKRW
   rzV4+BvR15LBwtO/d3KWa1kcEmY8oKEqGSKH9V+/HJZiefhbkJp6DPEN3
   Gtwi5t0i01GTOhjTsS+d7e3tIeJtRne1auVpi5/Mff3/FzsOd8z4s9T26
   K78D6RDDih5kHKtt9R2L87iw8AIoYTcWFvtoT/DXu7Jnr8zsvshxpez1n
   g==;
X-CSE-ConnectionGUID: mSZ2Bs7kRoG28eV7g2UxxQ==
X-CSE-MsgGUID: WZJKiAyORlW8FAdTbfI89A==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729592"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729592"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:39:04 -0800
X-CSE-ConnectionGUID: p0Fu15xyTwq1Jpx/tUVlmg==
X-CSE-MsgGUID: k356ZpA5Rpq/u4iJzvRfiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658435"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:39:00 -0800
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
Subject: [PATCH v1 19/26] coco/tdx-host: Setup all trusted IOMMUs on TDX Connect init
Date: Mon, 17 Nov 2025 10:23:03 +0800
Message-Id: <20251117022311.2443900-20-yilun.xu@linux.intel.com>
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

Setup all trusted IOMMUs on TDX Connect initialization and clear all on
TDX Connect removal.

Trusted IOMMU setup is the pre-condition for all following TDX Connect
operations such as SPDM/IDE setup. It is more of a platform
configuration than a standalone IOMMU configuration, so put the
implementation in tdx-host driver.

There is no dedicated way to enumerate which IOMMU devices support
trusted operations. The host has to call TDH.IOMMU.SETUP on all IOMMU
devices and tell their trusted capability by the return value.

Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/virt/coco/tdx-host/tdx-host.c | 85 +++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index 982c928fae86..3cd19966a61b 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2025 Intel Corporation
  */
 
+#include <linux/dmar.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/pci.h>
@@ -122,6 +123,82 @@ static void unregister_link_tsm(void *link)
 	tsm_unregister(link);
 }
 
+static DEFINE_XARRAY(tlink_iommu_xa);
+
+static void tdx_iommu_clear(u64 iommu_id, struct tdx_page_array *iommu_mt)
+{
+	u64 r;
+
+	r = tdh_iommu_clear(iommu_id, iommu_mt);
+	if (r) {
+		pr_err("%s fail to clear tdx iommu\n", __func__);
+		goto leak;
+	}
+
+	if (tdx_page_array_ctrl_release(iommu_mt, iommu_mt->nr_pages,
+					page_to_phys(iommu_mt->root))) {
+		pr_err("%s fail to release metadata pages\n", __func__);
+		goto leak;
+	}
+
+	return;
+
+leak:
+	tdx_page_array_ctrl_leak(iommu_mt);
+}
+
+static int tdx_iommu_enable_one(struct dmar_drhd_unit *drhd)
+{
+	unsigned int nr_pages = tdx_sysinfo->connect.iommu_mt_page_count;
+	u64 r, iommu_id;
+	int ret;
+
+	struct tdx_page_array *iommu_mt __free(tdx_page_array_free) =
+		tdx_page_array_create_iommu_mt(1, nr_pages);
+	if (!iommu_mt)
+		return -ENOMEM;
+
+	r = tdh_iommu_setup(drhd->reg_base_addr, iommu_mt, &iommu_id);
+	/* This drhd doesn't support tdx mode, skip. */
+	if ((r & TDX_SEAMCALL_STATUS_MASK)  == TDX_OPERAND_INVALID)
+		return 0;
+
+	if (r) {
+		pr_err("fail to enable tdx mode for DRHD[0x%llx]\n",
+		       drhd->reg_base_addr);
+		return -EFAULT;
+	}
+
+	ret = xa_insert(&tlink_iommu_xa, (unsigned long)iommu_id,
+			no_free_ptr(iommu_mt), GFP_KERNEL);
+	if (ret) {
+		tdx_iommu_clear(iommu_id, iommu_mt);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void tdx_iommu_disable_all(void *data)
+{
+	struct tdx_page_array *iommu_mt;
+	unsigned long iommu_id;
+
+	xa_for_each(&tlink_iommu_xa, iommu_id, iommu_mt)
+		tdx_iommu_clear(iommu_id, iommu_mt);
+}
+
+static int tdx_iommu_enable_all(void)
+{
+	int ret;
+
+	ret = do_for_each_drhd_unit(tdx_iommu_enable_one);
+	if (ret)
+		tdx_iommu_disable_all(NULL);
+
+	return ret;
+}
+
 static int __maybe_unused tdx_connect_init(struct device *dev)
 {
 	struct tsm_dev *link;
@@ -151,6 +228,14 @@ static int __maybe_unused tdx_connect_init(struct device *dev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Enable extension failed\n");
 
+	ret = tdx_iommu_enable_all();
+	if (ret)
+		return dev_err_probe(dev, ret, "Enable tdx iommu failed\n");
+
+	ret = devm_add_action_or_reset(dev, tdx_iommu_disable_all, NULL);
+	if (ret)
+		return ret;
+
 	link = tsm_register(dev, &tdx_link_ops);
 	if (IS_ERR(link))
 		return dev_err_probe(dev, PTR_ERR(link),
-- 
2.25.1


