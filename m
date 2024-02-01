Return-Path: <kvm+bounces-7724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16960845BCD
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:42:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C97EB1F2C835
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5149626B6;
	Thu,  1 Feb 2024 15:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KOObtpBW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7BC626A3;
	Thu,  1 Feb 2024 15:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802117; cv=none; b=hOkIdpBMHpJd2VLL1TiDty4Bjes5xygamZVH43G4CUvbTKZzjxzjzDTg74HJBRILaH/c/R+zW6p0midnlcZMHnGhJDhAQ58nemqk5VBYuzVKa51IBIIEZeb/wp8faJpyDNI1ulvglyuHRM35xrSHrmAj27qiN8BvpOrFZ1ysELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802117; c=relaxed/simple;
	bh=QLnvS8j18ZeV9R4NGP4vGO19qQdFmrkixtj8FpeKh6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=LqGCpb7kgY+rBSomF6gKwbSzCOcFEdeDt1JuI07jbePjgybhiWemfq64LH/A7iTbd5ji3pOkLV2B+sw7eXg+JYnQoDU8raj4jGds9Ho8qoCMP/nRqsIJ6OyT/944bC3OH2NFZ/V7Q7kUfhSCrq96tE7r7/pNfjxthKEg3s6d910=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KOObtpBW; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706802116; x=1738338116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=QLnvS8j18ZeV9R4NGP4vGO19qQdFmrkixtj8FpeKh6g=;
  b=KOObtpBWZsKJQnO5HUnM+oo3PzaYaQD5t/YqS04m+TJ5ByGD5NoHKjJC
   ncuSWXZxJVZEX7Hr0F6Lcv4oo0r5jE4FmIMrDrxTF37e+cE/iVgkFV2JM
   o+PdX/VjGJMk0KfW4pM3mEwHlFZbNIqZI8v3lhZIeGWWvN9tDfGIvDjFI
   pqiBTXwxIpJkPZOoflsKV0hvnXl6W8gS3I0Jhpc9LYlkViCJhPjrGS8F6
   jDIycpxQgJ0yLiCV63cRzEVElG6s8XK+XRkx2Pybf22kFuN5S0D/qYNA2
   1fqCP5FXUrWYMx1B0whZuZB8z7zVOkGMYNHZ9mzjb0gCGn0NclpUtgWwc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="401052863"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="401052863"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 07:41:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="133277"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 01 Feb 2024 07:41:53 -0800
From: Xin Zeng <xin.zeng@intel.com>
To: herbert@gondor.apana.org.au,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com
Cc: linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH 01/10] crypto: qat - adf_get_etr_base() helper
Date: Thu,  1 Feb 2024 23:33:28 +0800
Message-Id: <20240201153337.4033490-2-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240201153337.4033490-1-xin.zeng@intel.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Add and use the new helper function adf_get_etr_base() which retrieves
the virtual address of the ring bar.

This will be used extensively when adding support for Live Migration.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h   | 10 ++++++++++
 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c |  4 +---
 drivers/crypto/intel/qat/qat_common/adf_transport.c    |  4 +---
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index f06188033a93..cf1164a27f6f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -238,6 +238,16 @@ static inline void __iomem *adf_get_pmisc_base(struct adf_accel_dev *accel_dev)
 	return pmisc->virt_addr;
 }
 
+static inline void __iomem *adf_get_etr_base(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *etr;
+
+	etr = &GET_BARS(accel_dev)[hw_data->get_etr_bar_id(hw_data)];
+
+	return etr->virt_addr;
+}
+
 static inline void __iomem *adf_get_aram_base(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index f752653ccb47..a0d1326ac73d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -320,8 +320,7 @@ static int reset_ring_pair(void __iomem *csr, u32 bank_number)
 int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	u32 etr_bar_id = hw_data->get_etr_bar_id(hw_data);
-	void __iomem *csr;
+	void __iomem *csr = adf_get_etr_base(accel_dev);
 	int ret;
 
 	if (bank_number >= hw_data->num_banks)
@@ -330,7 +329,6 @@ int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number)
 	dev_dbg(&GET_DEV(accel_dev),
 		"ring pair reset for bank:%d\n", bank_number);
 
-	csr = (&GET_BARS(accel_dev)[etr_bar_id])->virt_addr;
 	ret = reset_ring_pair(csr, bank_number);
 	if (ret)
 		dev_err(&GET_DEV(accel_dev),
diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport.c b/drivers/crypto/intel/qat/qat_common/adf_transport.c
index 630d0483c4e0..1efdf46490f1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_transport.c
@@ -474,7 +474,6 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 int adf_init_etr_data(struct adf_accel_dev *accel_dev)
 {
 	struct adf_etr_data *etr_data;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	void __iomem *csr_addr;
 	u32 size;
 	u32 num_banks = 0;
@@ -495,8 +494,7 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev)
 	}
 
 	accel_dev->transport = etr_data;
-	i = hw_data->get_etr_bar_id(hw_data);
-	csr_addr = accel_dev->accel_pci_dev.pci_bars[i].virt_addr;
+	csr_addr = adf_get_etr_base(accel_dev);
 
 	/* accel_dev->debugfs_dir should always be non-NULL here */
 	etr_data->debug = debugfs_create_dir("transport",
-- 
2.18.2


