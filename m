Return-Path: <kvm+bounces-9322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DAFB85E24D
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FA6A1C22D21
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605693A1A2;
	Wed, 21 Feb 2024 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N+LVUi2+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40C681749;
	Wed, 21 Feb 2024 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708531162; cv=none; b=KrJb7m6rfH33DMl5fKonV6ZMiQM3cAPurzB7aMJXoFD3jCtDSaNrGn1GjfdjaZPVw9xn7xCJBealbDkJ6cySg23f81gYRrtjaEZ4J9gu81P/ckNVvdUVLdUO/lOgBcPTGVjfYgSUWLI0v8qlwvq4jPIBBkITkZ11jQ2a/kkOwIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708531162; c=relaxed/simple;
	bh=Uzkx+1GFaKGG2VdEZSzqcW3PJpKBfT/EL0LZs2G+ETM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=G0AnTu/rrSyKkAFQylEVJjK9GGdYcaOkPWrYt8JWQ4n7Sjdub0nlOAWiKui2cyFFK6bAiQdI3ahKDJ1caDXINiIXWCRoReHoBjRfDwqDRnc/S+VY278lBxQMbPqMyvuX/4X4kmdidgUjTxsmM0FACPl2PQrPqEPX6BqPvW+Vo0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N+LVUi2+; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708531161; x=1740067161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Uzkx+1GFaKGG2VdEZSzqcW3PJpKBfT/EL0LZs2G+ETM=;
  b=N+LVUi2+rSTR3HJNewHIk5PJJdTByLwxy1khds+v7xH3/9rfo96xA5F+
   mz8gwjln+mYMrK6jlhz07Fl/Ml5NDXIQmsm3yFtnNHs/fvYMlb3mEYyyL
   /giFsyeVNUWsbvMKdQmYai+CR9HKWPxkkYyjozrLoMziliJL/0cugzBrO
   8zRXZRU0IzBmNa0uDUzbmKjIZ/gkGcTWoyRA19319QCT4SB83jdr1hjvY
   oi0luubrTpiZwy7WFSReCeOZkgI53636JBPnaHNCqUWj0EH5xXJ6ftXGl
   gUxkAkPcxwrKOWLLTL3y25znkRqFk+p/OpV3poOGip3JeWaKwgMNRSaZq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="2568752"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="2568752"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 07:58:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="9760846"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa004.fm.intel.com with ESMTP; 21 Feb 2024 07:58:49 -0800
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
Subject: [PATCH v3 03/10] crypto: qat - move PFVF compat checker to a function
Date: Wed, 21 Feb 2024 23:50:01 +0800
Message-Id: <20240221155008.960369-4-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240221155008.960369-1-xin.zeng@intel.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
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


