Return-Path: <kvm+bounces-10261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E81A86B20F
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF27BB279C3
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43CE15B97B;
	Wed, 28 Feb 2024 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pq0/skVe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D68615B967;
	Wed, 28 Feb 2024 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709131376; cv=none; b=qkqSAD9r0YHdxyKF5Lu3GNUCukJDO8Mc6ZGMi1GXsxPIPu0URENwV3CSOusS4Pt9F89IS7V9JY2uiDHprvrW6RISNFDK+8wbND0jy89dR6o7Ui6oXEIYuxUsXvCrOfEjORDwA6bjpOlQQBKf+TVWIHdh6LiWq52taDkOfBu0Gf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709131376; c=relaxed/simple;
	bh=Uzkx+1GFaKGG2VdEZSzqcW3PJpKBfT/EL0LZs2G+ETM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=c1qLt4FS/zcTCY3rKfpB87TzKY7G7FtCKxPnmrcdp9gBfiG99EZLq9aOuswUTTmmXijLxQ+crIJy1Rypa4Z9lIH6XVQekyP/RpGaGY+rOnQJkaBqUtipB/nD0BtnJznbvAqVNOnT5/EOZ2KDgBlknR8snHusksr40w7g4cC5wtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pq0/skVe; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709131374; x=1740667374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Uzkx+1GFaKGG2VdEZSzqcW3PJpKBfT/EL0LZs2G+ETM=;
  b=Pq0/skVejUJZ66/CFDm3XnVaLHFmzQYB2dpLhdoJQNWwUVbkyZCqih2g
   BZl3Ipz7tfIFOQ1ePs9Z/I8Ia/N9Nmvm2a6b5C3vTCwjpp0zZQRU2ABfQ
   p4KSYabRPwTqLa1w4mVJfXncWLwNFCika9aJakNfLjdm6wRvI//3mpXdt
   yFt59Ivq3gS8f1GwauAf3ybxAJisx1seep8lmP3auk2lJy0T34P3O2f4D
   HGZCOKgU3JP8aqIpA+xb/9nqgO+od80IfUmsDZHxVXf6L27yGEA3m3vkI
   9TOGJNiGYXBGL48O06a+RmFlP2r0WBRTIRWAVmPYXhlC8B+K7TMfisY5P
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="14950970"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="14950970"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 06:42:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="11994649"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa005.fm.intel.com with ESMTP; 28 Feb 2024 06:42:51 -0800
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
Subject: [PATCH v4 03/10] crypto: qat - move PFVF compat checker to a function
Date: Wed, 28 Feb 2024 22:33:55 +0800
Message-Id: <20240228143402.89219-4-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240228143402.89219-1-xin.zeng@intel.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
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
index 9ab93fbfefde..b9b5e744a3f1 100644
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


