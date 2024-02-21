Return-Path: <kvm+bounces-9321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D788385E247
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 943C4283C38
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B418173C;
	Wed, 21 Feb 2024 15:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OAl7gfWh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6FE82C9B;
	Wed, 21 Feb 2024 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708531142; cv=none; b=Kt9CZyucO0HkV5T3ycX6X7PgEFd+f7gM9KRRyvwmh1jtUscrQYiRtKzhixqd7NdOjoYEYo+pi2S6rM5vNsm+dr8dZzFSskasW7lfMQXj1IfN8etbQMQFujAONz+2t3WFLylcC5kjriqA7D79tKfX9OpnITRABfiQmJT4n160yfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708531142; c=relaxed/simple;
	bh=R0p2dI+gzr1mErcVQt0AeWNtUnYR36vkXQ6gWLSef6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=uiL8Lmk4SubLDWh0knEQciXPAF7tzKb8u81qT/TOE9E6p0Ti+qr4ZlFUMLoHih6hT5xCzTz52IzcTPvJuGCY6MfeTkVIpaMduKqJQJFqXWrqaLbUQ9z8WDvwIf0mbtFWDjbEo7TVTcgecWiBQp38SlMG9JqyuYHGV8K4RQja/6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OAl7gfWh; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708531140; x=1740067140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=R0p2dI+gzr1mErcVQt0AeWNtUnYR36vkXQ6gWLSef6g=;
  b=OAl7gfWh3m+Y1D6t7HOAcfBEN9Eq0I38FQInewaf+w33yVsDdRdD+e8n
   OpQato/COlkXfxXns2UJPZcnyvppBJIOqKmT/XsbC0vH0DkHEnNWcHRRs
   h2kO+qvW6XittOXSjXzuI2eEKbitYV9dbL44XzOIS01+A5EgmLlUd/SJn
   58SoTRj61bP4aMoxax2OeRDbEzeJAh8l7d7n0nAhw6UQNe4NbSRbKCyea
   DlikzRH1DgbVOxntzDWOjB9lwHDi+3vVFmMFXAQjFvsXV6pK/ew8X+zf5
   1mg4kBLf62TccccFNKgLcJ11MoTDD+OSb+LHW8X3PHwVhz9gYxgaCKWAT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="2568724"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="2568724"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 07:58:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="9760824"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa004.fm.intel.com with ESMTP; 21 Feb 2024 07:58:47 -0800
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
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH v3 02/10] crypto: qat - relocate and rename 4xxx PF2VM definitions
Date: Wed, 21 Feb 2024 23:50:00 +0800
Message-Id: <20240221155008.960369-3-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240221155008.960369-1-xin.zeng@intel.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Move and rename ADF_4XXX_PF2VM_OFFSET and ADF_4XXX_VM2PF_OFFSET to
ADF_GEN4_PF2VM_OFFSET and ADF_GEN4_VM2PF_OFFSET respectively.
These definitions are moved from adf_gen4_pfvf.c to adf_gen4_hw_data.h
as they are specific to GEN4 and not just to qat_4xxx.

This change is made in anticipation of their use in live migration.

This does not introduce any functional change.

Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h | 4 ++++
 drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.c    | 8 +++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index c6e80df5a85a..c153f41162ec 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -197,6 +197,10 @@ do { \
 /* Arbiter threads mask with error value */
 #define ADF_GEN4_ENA_THD_MASK_ERROR	GENMASK(ADF_NUM_THREADS_PER_AE, 0)
 
+/* PF2VM communication channel */
+#define ADF_GEN4_PF2VM_OFFSET(i)	(0x40B010 + (i) * 0x20)
+#define ADF_GEN4_VM2PF_OFFSET(i)	(0x40B014 + (i) * 0x20)
+
 void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
 
 enum icp_qat_gen4_slice_mask {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.c
index 8e8efe93f3ee..21474d402d09 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.c
@@ -6,12 +6,10 @@
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_pfvf.h"
+#include "adf_gen4_hw_data.h"
 #include "adf_pfvf_pf_proto.h"
 #include "adf_pfvf_utils.h"
 
-#define ADF_4XXX_PF2VM_OFFSET(i)	(0x40B010 + ((i) * 0x20))
-#define ADF_4XXX_VM2PF_OFFSET(i)	(0x40B014 + ((i) * 0x20))
-
 /* VF2PF interrupt source registers */
 #define ADF_4XXX_VM2PF_SOU		0x41A180
 #define ADF_4XXX_VM2PF_MSK		0x41A1C0
@@ -29,12 +27,12 @@ static const struct pfvf_csr_format csr_gen4_fmt = {
 
 static u32 adf_gen4_pf_get_pf2vf_offset(u32 i)
 {
-	return ADF_4XXX_PF2VM_OFFSET(i);
+	return ADF_GEN4_PF2VM_OFFSET(i);
 }
 
 static u32 adf_gen4_pf_get_vf2pf_offset(u32 i)
 {
-	return ADF_4XXX_VM2PF_OFFSET(i);
+	return ADF_GEN4_VM2PF_OFFSET(i);
 }
 
 static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
-- 
2.18.2


