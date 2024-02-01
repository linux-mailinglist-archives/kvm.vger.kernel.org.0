Return-Path: <kvm+bounces-7726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C00845BD2
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:42:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D0C9285AAC
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74DCC779EF;
	Thu,  1 Feb 2024 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HBREZIHm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300D8626B1;
	Thu,  1 Feb 2024 15:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802123; cv=none; b=V6g6tf7Mp+OQ1mPzCxCRP2JTroF5sJi+5mA0CHcAe2mMjEcUwTr/zmkuBe7fRKt0fZUWCcmnXHWBwRvzHX2vi+pukK7EeB26TuBnZEXgGRkBXOcBG1m2kVmRQqdBISKZgdktlBjOggC5WWUdjZ223WOJgsNZXuyTke08ltnxYbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802123; c=relaxed/simple;
	bh=Md0x3vmxW2CGQH9ZER2xfVXG+OX36BetMc7bOm7qZHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=XwPvqUgXHw2ssy5l3vbWi1I2wpUDWp8xrlP+37NZf2j5P46JYaxksmSKEDARNJV83VKGseupPy6JZ7CQ4pt5mkuYEGIKyzzNcAOuYMm7lcxwGRAZRGaeHkcx5Td0LX2TV7lJq8QpUVGstVYfXilgBBm1maAd/+y5v1QhaoRqw/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HBREZIHm; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706802122; x=1738338122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Md0x3vmxW2CGQH9ZER2xfVXG+OX36BetMc7bOm7qZHg=;
  b=HBREZIHm6JEDoJcC+y5i1kulPOwW39sev834DIzNr8c4EtyLqzYKvUrj
   aqrBdiJyR5KFpxXM0YGJSPMi+Q84pLPT28SbqDzFz3+zFk7xqkah9FCBo
   C3O7p22ombEm+GB0ljlbcSJcHYdnH4VawVh5FHVbrMaqinT5S9EcwAmTU
   ERMDWd9ujoyPcV80nF75LWpI6+JJYZu0hOwHdhgY9jJGjkIsRKJ7NrCuo
   6v7KHHMEE6bQt8kuwOxRKkhEe4PjGou42XP4NLAB/IOyB+U29fyEAnHQc
   z/U0F3S5wLxpgvV8FHDUjCZcE8TY9L6EURAb2JQeyxda5F+xYDXmIrtr0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="401052897"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="401052897"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 07:42:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="133300"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 01 Feb 2024 07:41:59 -0800
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
Subject: [PATCH 03/10] crypto: qat - move PFVF compat checker to a function
Date: Thu,  1 Feb 2024 23:33:30 +0800
Message-Id: <20240201153337.4033490-4-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240201153337.4033490-1-xin.zeng@intel.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Move the code that implements VF version compatibility on the PF side to
a separate function so that it can be reused when doing VM live
migration.

This does not introduce any functional change.

Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c   |  8 +-------
 drivers/crypto/intel/qat/qat_common/adf_pfvf_utils.h  | 11 +++++++++++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
index 388e58bcbcaf..d737d07937c7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
@@ -242,13 +242,7 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr,
 			"VersionRequest received from VF%d (vers %d) to PF (vers %d)\n",
 			vf_nr, vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
 
-		if (vf_compat_ver == 0)
-			compat = ADF_PF2VF_VF_INCOMPATIBLE;
-		else if (vf_compat_ver <= ADF_PFVF_COMPAT_THIS_VERSION)
-			compat = ADF_PF2VF_VF_COMPATIBLE;
-		else
-			compat = ADF_PF2VF_VF_COMPAT_UNKNOWN;
-
+		compat = adf_vf_compat_checker(vf_compat_ver);
 		vf_info->vf_compat_ver = vf_compat_ver;
 
 		resp->type = ADF_PF2VF_MSGTYPE_VERSION_RESP;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_utils.h b/drivers/crypto/intel/qat/qat_common/adf_pfvf_utils.h
index 2be048e2287b..1a044297d873 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_utils.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_utils.h
@@ -28,4 +28,15 @@ u32 adf_pfvf_csr_msg_of(struct adf_accel_dev *accel_dev, struct pfvf_message msg
 struct pfvf_message adf_pfvf_message_of(struct adf_accel_dev *accel_dev, u32 raw_msg,
 					const struct pfvf_csr_format *fmt);
 
+static inline u8 adf_vf_compat_checker(u8 vf_compat_ver)
+{
+	if (vf_compat_ver == 0)
+		return ADF_PF2VF_VF_INCOMPATIBLE;
+
+	if (vf_compat_ver <= ADF_PFVF_COMPAT_THIS_VERSION)
+		return ADF_PF2VF_VF_COMPATIBLE;
+
+	return ADF_PF2VF_VF_COMPAT_UNKNOWN;
+}
+
 #endif /* ADF_PFVF_UTILS_H */
-- 
2.18.2


