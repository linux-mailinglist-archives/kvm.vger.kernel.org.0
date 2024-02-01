Return-Path: <kvm+bounces-7725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7FBE845BCF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C5401F2C974
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72DEF779E5;
	Thu,  1 Feb 2024 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O0SL2YDD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BB7626DE;
	Thu,  1 Feb 2024 15:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802120; cv=none; b=JCNz2mIJXU4R4hFGsm3y1ve0aulox9HfGAhPSzjYbU/RMRrMIW5I0hVhkM8NC+1P6Wjh1yREy2AYOXwDGyeLX2NFMU5x79IZKBGEMMH2PZ73gzRuV8FusWsQcZDKANiLS9+2+PetBxRwnw4eSPX223cehjQ16SRH+efYQkPNY3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802120; c=relaxed/simple;
	bh=Rt9MKBvpI4q3qgP+7Cxr0ZR27vDhEiu//K4HLtSzAdk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=uEDGmaKqt1HCN0DISJLI4PMd9O8aIXfosw4KV1hW/HjrFLnBLhstGyy53ml9QaO5JNBhYZk1+EeNwnYLNZV1CejYMcJslxPsWiPKBkaD24ijDMEWd0Z1EIMzadS+XJ6LB7fgG7ntBAGPwuyucrpqfiyJtCt4GgpsH735Qy87JvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O0SL2YDD; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706802118; x=1738338118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Rt9MKBvpI4q3qgP+7Cxr0ZR27vDhEiu//K4HLtSzAdk=;
  b=O0SL2YDDejRHrdL3uuSFlmGQbuY+wRyTTd4r2po00QcJ0SDU3xckFbOZ
   OqLCeAuFLimRN6tuDPX48NUF4kbEhXz4FgSgvxaYq2ABKa95ceXXnK8wU
   /T4z52g1t9H+ZjwPeKepfxixiXl7tUDbH1Dp9d2Z/jqbwBRlbHpPzs/aU
   lEuHaMonRl0dXCy3GImHJ8OHzX3uS/ii/WgRvCU10topABQHxT1JUwy6B
   92wvcTJ+j5k/K1eZc5VluZy38hbGQIcmEgSKM6KYWfGylINBAdiX+qL+2
   pPC3F01yBZJZuFx8PZftRGWhVR90SrC3sZiM7Q6+fFX8lVAa1DGfaIQ9D
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="401052875"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="401052875"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 07:41:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="133290"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 01 Feb 2024 07:41:56 -0800
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
Subject: [PATCH 02/10] crypto: qat - relocate and rename 4xxx PF2VM definitions
Date: Thu,  1 Feb 2024 23:33:29 +0800
Message-Id: <20240201153337.4033490-3-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240201153337.4033490-1-xin.zeng@intel.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
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
index 7d8a774cadc8..9cabbb5ce96b 100644
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


