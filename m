Return-Path: <kvm+bounces-10260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5F386B20D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 308751F22E77
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3163215B964;
	Wed, 28 Feb 2024 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q2c1QgtS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FAA15B104;
	Wed, 28 Feb 2024 14:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709131373; cv=none; b=mus4svQMQ/ajedoE5o/AVT18SGmamJg4rB693IingtF2hmzmAZo5UJfSDnDdNJVK3URJEvCpaP7Qkhiexa3+AhydkaIhezUpfdoVnbGNDwwMMGe/iXmKLj9ucPS9tNJS8ig5dDOtg3zXS9ec4q/ADIVpFg8iuCQWhqYdw8ROC3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709131373; c=relaxed/simple;
	bh=R0p2dI+gzr1mErcVQt0AeWNtUnYR36vkXQ6gWLSef6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=DMy3oBAexQ+rN/KF6jNR4jd1R/3XtQe0FpvCATWzNPQcrTbPpMpYDK1PEz++gNWedXyGQmyu57fhfiX1xN9dtmgxHGH26usL+ibwDANIIcJ2hcV5KDTVEmg+G6FJ92KD234de+ntbA9PGolsVjfXc9MF3aH84P2/glzH7xf7RbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q2c1QgtS; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709131372; x=1740667372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=R0p2dI+gzr1mErcVQt0AeWNtUnYR36vkXQ6gWLSef6g=;
  b=Q2c1QgtSX7Qea88gxCj6EwXmF/VAXmPWaO26/4foDZCwTThteYEgEMEl
   WkoO5iM1hEbI/+eRU/wNfEi7IUIfvFwk5wmmUxHjLYmWH0U9MnmkzEi5I
   xpeecjHRDEOhgOqAl8HAoAFblEuRA9qt2UcMg3B+WflFfuL/eBp1QIpbV
   cVrHaBhj7xz6ZI5rLN4xVkb5YNUJDxIrXewJEQnL6+7oSpy/U93Ek8ozB
   Bp0ek1rh3sAG/4Sw8/ePH9sSiB8231m7GJjYfFSqWcGxBtRaeOljAx061
   UZHM/o9yiH0FRrAiKY6GJv+pVtqfFaMyiATFBoYIJDWR9M6eF3D0KDrHO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="14950964"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="14950964"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 06:42:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="11994637"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa005.fm.intel.com with ESMTP; 28 Feb 2024 06:42:49 -0800
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
Subject: [PATCH v4 02/10] crypto: qat - relocate and rename 4xxx PF2VM definitions
Date: Wed, 28 Feb 2024 22:33:54 +0800
Message-Id: <20240228143402.89219-3-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240228143402.89219-1-xin.zeng@intel.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
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


