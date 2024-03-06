Return-Path: <kvm+bounces-11137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5663887386F
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E646DB20CB0
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEEAC130E4A;
	Wed,  6 Mar 2024 14:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fj6Y+ERW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DBA133283;
	Wed,  6 Mar 2024 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709734068; cv=none; b=DDVyrZSQcIa1IeXw75mfIkRD+cheMgXB7q3uu7mrihBtn63E1kYlWwFmRsswRA7y+R9zs2VaH2DyZ9xmVjrwatu5FjwDc9H8TJRYWEe0OAWxyvlyJNha8oWHKLOXRO4YAkr6DtlL7AQc/0gCJTSgLV3QeqP98HjvVYF7dSj7nTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709734068; c=relaxed/simple;
	bh=Uzkx+1GFaKGG2VdEZSzqcW3PJpKBfT/EL0LZs2G+ETM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=HGYuKvnsKTO2kTnVCN9Jny7JIFoOy43gyvH4cl6sePiAzlNP15+nN4GKeceiZM57x98JkeFO8nM+v8Wu1de05i8N3aG14iTCBtWoxqIwq353CbFsxKsCoo0yR4GhGBC53MtZewWMYngG1z/x/V2167czulvlkYZwhyu+p88TdSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fj6Y+ERW; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709734067; x=1741270067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Uzkx+1GFaKGG2VdEZSzqcW3PJpKBfT/EL0LZs2G+ETM=;
  b=Fj6Y+ERWBv1ArlX7EXc65zU1T+WxoXXEUsMdigKWwI2fO9cRwuSGPg3N
   ra05XCvY7E5Xrx0lX9Inl84hNJH3faDR/QjQMM+KIH2v9VOH+cy2VBy/v
   F/3Fi76ZgTUxE64wHkvdBSLSMybu8aaKnogqd6mTh2bIfi4VBA9dDiInc
   fhQ+oozq/uFdARb9qOb2xZaS7qnPVy3JMhR1r8RH6yG4Old+Ay+1x/Yy0
   1gNJ4WV/IdSa/Ez9nQT/Ei7aQx7wS1F1yfZKuS9MiMALyUV9fpizyoJtu
   hddkDrljmyMZq10QwYQvkypTzb7KWMJNRMOlEIs7MNMfEuyKcInZ0aMT1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="15490321"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="15490321"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 06:07:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="10192166"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 06 Mar 2024 06:07:44 -0800
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
Subject: [PATCH v5 03/10] crypto: qat - move PFVF compat checker to a function
Date: Wed,  6 Mar 2024 21:58:48 +0800
Message-Id: <20240306135855.4123535-4-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240306135855.4123535-1-xin.zeng@intel.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
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


