Return-Path: <kvm+bounces-11135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D5C87386B
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:08:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A0751C208A2
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E4D132C1A;
	Wed,  6 Mar 2024 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gbz2OaKF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F9D131742;
	Wed,  6 Mar 2024 14:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709734064; cv=none; b=o46LU6SbkZDaGe07eU5hu3NaqAuL/bsM/SZhSBF31TZ+ByXIdxsxJU3MnznZZBHihkjUMJroyLuvT256dpARxPXT25bb9MwLiK9FNGNb+qje7x6CnSpL1jufzMMTRYf1xKhnjx8Qij/wWsawmZhKDbTFsfyjvrgTQy0D2N2/qz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709734064; c=relaxed/simple;
	bh=Hv4Y70Yvz3IT9r8CkFaVwnIIDG3O/1TTFWYDc08LLIU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=iVfO6lRac8HfQ7ymAbXZLO8yfyKISkLXedenBmw8a1R7yQYv/E8u5DXA5Xt8w/FJ5XH8+CJs6D80HbDHo4CEypkmSbh+Yd74o3T2ekGgNN/FYEMW6vvR7nk11W3y5dmf2VrhaG6e+sfovXqy3OumQDdCyLuE6RrartZ41YXSCTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gbz2OaKF; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709734062; x=1741270062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Hv4Y70Yvz3IT9r8CkFaVwnIIDG3O/1TTFWYDc08LLIU=;
  b=gbz2OaKF64sox59jkZniWWX2aGclMFPWEFjOcvQ3Sr6BorSVftMyt739
   WT9r8EyNi3s9hlUE/2SHZJA7JCwlcL7QmvXfHfxtvqcn9DZwjpft+xBPB
   4QU5eqgx/+FAo9CS3JRS2pH/w1yoLS4+blQoRfVeunKHI581iiWzLPaSO
   8dnth3OaLYB+u4sy7gXB44q52bHyU+t1wbCx6blYj6nPFI7JeaqgULVxP
   BIK/H+i5jQjbn5jme4bx0InVPJ4yZWVEoeCJ7Owj2zrgw81G5iox5i4FA
   zN2voEZxX6+Jzbzb3gKXUeHXnoYprz8bfy8prulLZ+JxdqCL3E/haei/y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="15490300"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="15490300"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 06:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="10192158"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 06 Mar 2024 06:07:38 -0800
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
Subject: [PATCH v5 01/10] crypto: qat - adf_get_etr_base() helper
Date: Wed,  6 Mar 2024 21:58:46 +0800
Message-Id: <20240306135855.4123535-2-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240306135855.4123535-1-xin.zeng@intel.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
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
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h   | 10 ++++++++++
 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c |  4 +---
 drivers/crypto/intel/qat/qat_common/adf_transport.c    |  4 +---
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 57328249c89e..3bec9e20bad0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -248,6 +248,16 @@ static inline void __iomem *adf_get_pmisc_base(struct adf_accel_dev *accel_dev)
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
index d28e1921940a..b8a6d24f791f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -321,8 +321,7 @@ static int reset_ring_pair(void __iomem *csr, u32 bank_number)
 int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	u32 etr_bar_id = hw_data->get_etr_bar_id(hw_data);
-	void __iomem *csr;
+	void __iomem *csr = adf_get_etr_base(accel_dev);
 	int ret;
 
 	if (bank_number >= hw_data->num_banks)
@@ -331,7 +330,6 @@ int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number)
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


