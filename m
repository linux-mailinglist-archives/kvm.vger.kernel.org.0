Return-Path: <kvm+bounces-9120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C436785B163
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 723BB1F21DD8
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201635786D;
	Tue, 20 Feb 2024 03:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m+gCKxX7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C858956B9E;
	Tue, 20 Feb 2024 03:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708399777; cv=none; b=OehNGGljYWkH/jTzPORf3RNmZvSazmt9tH9Q4TEh6RUhrIkvgMHmGeJ1XxOJ0yRSew5frjc4fMZ8c/1UYqxtbTbFhbBUyA880k+bV35Q8uQ2SgQzVvx2qngBxeVvfi0/Oc8rYeBtgwp8dtIOupf+fDzEiLGIG8oa9OvxV1PZUjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708399777; c=relaxed/simple;
	bh=R0p2dI+gzr1mErcVQt0AeWNtUnYR36vkXQ6gWLSef6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=VuRj/+QlM1k13GIeM7fxI5quyKLfeKZITsM7u5JHvBrta699MyCixO9BXUNC4MuEcWWbUpuzBSaXY5dMWE77L6BOnZLeN0CJHq42HVgHWicB3hPgrW9juJ2MTXB2WRg3mJZ6lKv4n1s+o0JDcVT1YJN6TloAwfYoiA8M2He6gEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m+gCKxX7; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708399773; x=1739935773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=R0p2dI+gzr1mErcVQt0AeWNtUnYR36vkXQ6gWLSef6g=;
  b=m+gCKxX7f5ZHvYlWV3RLDg+EWDoGyb8J5c3IdwpLe5Ov7zRPhIx+zG9D
   TYUe8xYzbvpnnOoPQG3v+Jj7UmGzNbNJmg8CGgVBKdYqrJYl5KCIyIZny
   B/AyD9E4Cb5Ucih/+HvY831NVZ7VVY58YvC2R4gQtuHRSOeowpQZPI5Yv
   RTgYPoIqedquTcHi2DlHozOk7b3UiLbGjm+aQeTdRUq/7YbtdbKKRHY8J
   iMKhza8VfjABeGo7r54JJKl06PKhBj27hCNfDps1fqm5mTzgu6kXXWdHi
   LmIepRRdar98/WVFJBJbT+DlrI/ZP6wd0p6yar8ROji6ahoj98/NchvFe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2354076"
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="2354076"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 19:29:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="9302076"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa003.jf.intel.com with ESMTP; 19 Feb 2024 19:29:30 -0800
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
Subject: [PATCH v2 02/10] crypto: qat - relocate and rename 4xxx PF2VM definitions
Date: Tue, 20 Feb 2024 11:20:44 +0800
Message-Id: <20240220032052.66834-3-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240220032052.66834-1-xin.zeng@intel.com>
References: <20240220032052.66834-1-xin.zeng@intel.com>
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


