Return-Path: <kvm+bounces-9320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 886A885E245
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9ADE1C21868
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D93C811F9;
	Wed, 21 Feb 2024 15:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hClAXwO6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA2381730;
	Wed, 21 Feb 2024 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708531141; cv=none; b=LuDgu+5zanVuld+Ag1um/xamwWRMu/qqWpQVvzCFQm2VqEzAG/FOqXV7agcE0ePRvI/URAPhWb3V9ZHf9JQUOfgYObifLOp54lkmC+JJq8OGLSe3x15gJYnsr1oi/NNsk2ti6pNVc50Uiw8Rx5i5mQJowzVERUCAgzVm0JIF8/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708531141; c=relaxed/simple;
	bh=1fwiIQI3dQ8ibBmhmYK31NfhCwSYTtk6PsHOviUYBZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=AEgRb13y1kHpneUUjc3GoCGqsO6YBBASt4UnAkkXF4GN4imrkMwGLYfOzqwY/6P5bsiLbcJ6HB78HEoDF8xE3ADvntk9I0CLcVXq1+Pgm48cG1AX+JtakicEio1BmH6Ts1h12stUsIH5oKF2WRqp7z4B1zDFRXzioMBFTaQeiDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hClAXwO6; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708531140; x=1740067140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=1fwiIQI3dQ8ibBmhmYK31NfhCwSYTtk6PsHOviUYBZs=;
  b=hClAXwO6OUX9BycTmvj05NdYwM5+pb+r9j3W41ynV2SBg8eRi6BnsHYF
   kRjZRvwUI2L3ZIurLnyTzKFreb4sniev6/fiEBShwDnQCjjn9UkKLawWh
   qXrJzSaD1QPGz155aCzSPZvB/SzC/y25Yu0gAyyTf1x0B6kqRav06DkJU
   bhwAVyJv759K12PDYHxugdEgCDnzitDeaO0RF3qFQ52z566B86YzHWM8G
   MROCIgHBYsye0TaAIoMmD8CNeLEDAVsg8WOkNT3uh4eM3cz/r0GslV8GJ
   DcRSLD52l0uPRdU0Ima8ooa46qIG+ye6ZOx77Q1rN/nkgOiN3qEqNDXoP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="2568696"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="2568696"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 07:58:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="9760802"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa004.fm.intel.com with ESMTP; 21 Feb 2024 07:58:44 -0800
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
Subject: [PATCH v3 01/10] crypto: qat - adf_get_etr_base() helper
Date: Wed, 21 Feb 2024 23:49:59 +0800
Message-Id: <20240221155008.960369-2-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240221155008.960369-1-xin.zeng@intel.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
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


