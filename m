Return-Path: <kvm+bounces-9119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C26485B160
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EB401C21294
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DAD256B99;
	Tue, 20 Feb 2024 03:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fZVJct32"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B7B56B78;
	Tue, 20 Feb 2024 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708399771; cv=none; b=mt22jWyLmMpZ4Eu4jz5l871NY1f3zShAjAExm88LECOoDMYV1mWTj9L9xcVxbCy/zHBJELVGI31/4wXBHsnUpFBDccYR0KhuKbsgzJroop3MXMsQ88C+kw/KEHWP+vcvR/vIaFnL3D9HtZDFrYuJyfSd/pl7iprrFnsNIJ87mrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708399771; c=relaxed/simple;
	bh=1fwiIQI3dQ8ibBmhmYK31NfhCwSYTtk6PsHOviUYBZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=iNv7DdouivHZLDmy7eG6VuqJOlU1Y5x1iCspcp2mtiBCR/OLGn/bSCE3YHfnvogTg9JRkyi1VerXs9KpylhfCImN1jcpl/RLO46ZKg55vDY/ng4yNTNsLeWw0AnAdd2vXV+33a/juAvx6sIeM/L2VE/1qRGPrNMhc2p0oqwXc1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fZVJct32; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708399770; x=1739935770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=1fwiIQI3dQ8ibBmhmYK31NfhCwSYTtk6PsHOviUYBZs=;
  b=fZVJct325+yVLDRhihRT9jgTGL8w8CfaXNO/9kxkun1yna5hvOfFlXT5
   TqKQyTfzzZgiZja3jWhQnid1tooknR/JRJ8ETiXCtF+4MJGgUDoyhskcZ
   g4ZF+t8VK+fLCLtIuQMSslzDu+Z8tKc6WtGcbfjRS3sB2ItMbhJjAoH9j
   RRdllVmdrnb7MCDbfvrTDVDvettv6fYn7oNJW54oUR0BqU2T7TS+LiXBD
   kD+OP/Ih7Ch54CUGWLd0A4SujgtKjJNybXh3E14y6LNkmPnKP/fa7h6Ee
   0U1Z165uPrqsaC24XYbubwcRnbrG3cfFXFGux+AXx8vm+vbQ7UXH3Ru8R
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2354071"
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="2354071"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 19:29:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="9302071"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa003.jf.intel.com with ESMTP; 19 Feb 2024 19:29:27 -0800
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
Subject: [PATCH v2 01/10] crypto: qat - adf_get_etr_base() helper
Date: Tue, 20 Feb 2024 11:20:43 +0800
Message-Id: <20240220032052.66834-2-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240220032052.66834-1-xin.zeng@intel.com>
References: <20240220032052.66834-1-xin.zeng@intel.com>
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


