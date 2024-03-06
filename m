Return-Path: <kvm+bounces-11136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 14B5187386D
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A960DB20B72
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE0D133284;
	Wed,  6 Mar 2024 14:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KgveWA78"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA3F132C16;
	Wed,  6 Mar 2024 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709734066; cv=none; b=KgCTRIsu41sAxG2axkPOOHT8kFNL620OdjCGy1UMaFW6pZyQo6Y+vHzw3yLxWri4w7V7pVKss2Va2Tf0rYmrE2aCFGKBy0+RMPTZSAgLBSlZGL/O5eoNZZKLQQSuG9D/18QVEqPn57DLYXnSByzovWlfSDVLT/pge/hdDGRVQUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709734066; c=relaxed/simple;
	bh=R0p2dI+gzr1mErcVQt0AeWNtUnYR36vkXQ6gWLSef6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=ZzFumeq+WeTyMFIW3+U+yWq0Cx6jZsHapo2GlFo/J37H9KfJqV6CFWOUt2fBOotMzAKA526jQelraj/txyo3k2LTAZKXB9TcwFF/8Kd8k33XzOaEQ0dW0SOfFfoWBtobB9LFOHg1gcgOk5Pub2aqHpUahH7eUR2dxRiFIYarPfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KgveWA78; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709734065; x=1741270065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=R0p2dI+gzr1mErcVQt0AeWNtUnYR36vkXQ6gWLSef6g=;
  b=KgveWA78JAVsP77KGNZ5L2nrAmY7EOwkBZWyb5rJAQ0u3Vh6q8sX6uey
   aUGYStT1MCI3ovS/BllYjJ0BIcX/tTiPpx3uKPBgssf7I6gslZyyXPmtW
   wKU97xQy1j+mGaFUN0BnvSyZIONAwZuEaRNt8fHofPyGyiwUqVjPvg7Z/
   4UmXWv2ASBYQSph86gImJQ78nAwYXludAMt+PjwKbjAt9m/VCFdHy8SuG
   flHBUma6iijU4SUtaQMpbiDu7idnzNJgEuauzDFnrBNgYUCNyq5GJV6xu
   IOljp+x3z5kTgYNFlpD5M6Ymae5MEpwAE9H+xAJAvnHqpAzn+RpK/h5WN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="15490314"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="15490314"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 06:07:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="10192162"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 06 Mar 2024 06:07:41 -0800
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
Subject: [PATCH v5 02/10] crypto: qat - relocate and rename 4xxx PF2VM definitions
Date: Wed,  6 Mar 2024 21:58:47 +0800
Message-Id: <20240306135855.4123535-3-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240306135855.4123535-1-xin.zeng@intel.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
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


