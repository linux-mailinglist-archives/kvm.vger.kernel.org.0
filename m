Return-Path: <kvm+bounces-9121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C467285B164
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:30:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CC971F22191
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33F458104;
	Tue, 20 Feb 2024 03:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QumtAiRd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AA957307;
	Tue, 20 Feb 2024 03:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708399777; cv=none; b=b5iTUtUpWFUC8bbnwFCGeijsbu4J2botWfDclbcnUwf+Fil98RM2s4spzC4df0RiLc0MZgWfkUCVip+SfRmAxcFFgsGhOp7paIujD2PaRM/S5VLMPFLhl/aftA5lHf2iLx5aPp5vyGsUhxbQnV28Il7bYHrQr+qJn1mfP0loQZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708399777; c=relaxed/simple;
	bh=Uzkx+1GFaKGG2VdEZSzqcW3PJpKBfT/EL0LZs2G+ETM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=dhErNG6ChVkAxctb7aeLC9jDxbGxQ06inHeuLQgsFpbWaj2FirTICywqkxFE7yIEl2XpbRlZ+h4NrgaR06od9H6HDeMHjhcXJKppNivA5lk3mekGGeZDiDJZoZc6V2Xqc17G+vnmWQaKncoLGO2kqtxrqE0y31MUqy5DBouTlnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QumtAiRd; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708399776; x=1739935776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Uzkx+1GFaKGG2VdEZSzqcW3PJpKBfT/EL0LZs2G+ETM=;
  b=QumtAiRdqk3G/VviDRY69AULnttlRym2QiiTv6BRw+E0p5fPCKua4x5C
   t0VI1CdVSJQZ0JFpJ14bC6gume1pLAIr706WnIu0M8tKZEvPhLC6+NMU3
   ZI2/IzohZusFDQRBNqeYzWi8IqHRuD0GpEIHSYY4Dh79Vb7HMUlkEvgZ9
   h/szVouBbEdTey2Dcl4jmL9Pdy58PZIW5KvcX4dOaA2YVJqdbMlrVVtnJ
   Gf3lXy6sPVZiCHKATfyvpIuJaf6LZmS45Cu+xmE4hYky5yacr1CHGd1a/
   W6p5I5pbeOJ0cXKrCdl8RI7c8fbi1wZH2oQmMkwHVgt+Rk/iumBTaVSk5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2354081"
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="2354081"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 19:29:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="9302080"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa003.jf.intel.com with ESMTP; 19 Feb 2024 19:29:33 -0800
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
Subject: [PATCH v2 03/10] crypto: qat - move PFVF compat checker to a function
Date: Tue, 20 Feb 2024 11:20:45 +0800
Message-Id: <20240220032052.66834-4-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240220032052.66834-1-xin.zeng@intel.com>
References: <20240220032052.66834-1-xin.zeng@intel.com>
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


