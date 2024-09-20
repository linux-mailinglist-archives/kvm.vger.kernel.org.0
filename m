Return-Path: <kvm+bounces-27210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 00BCC97D6A0
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 16:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80234B23A13
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 14:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA9517C22A;
	Fri, 20 Sep 2024 14:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NlWKRn8x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6BC1779B1
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 14:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726841151; cv=none; b=MDqU6yNiMBy7SF+1ucmkn2+NAZh70OlBmbt+bYg8PgvnYaMlafaSf9u/zpTI/hJyzcljk1X6wqgU8wTqotQ53TCvqk4DMb9V/sha38p+Hq7gHtjtBw7OUO+tHD8yyEwmcNboPT3W0Mj2OPDkmRIT2gDmDRY+MZokYbQPZkqvnvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726841151; c=relaxed/simple;
	bh=4+E1VuFkoiCsIXTY88NHqDldr0fCtc65PJx2FIx1i6M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GHar5VICMexs6Z+xnzUtBwoiHGD10zPOXOT31tl/w53QDDbU7CQTCurOn4cfd3QLGRdypzxH/E0nt7zHBiigrhozhFrnZeuyGfnXlLhivpz47VXcVFoWwSH+5t0rSSeFb8YpBVACvobzNeB8Kuc4vxkRAktS1RIHy70PiBATEgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=NlWKRn8x; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48KANW2F015713;
	Fri, 20 Sep 2024 07:05:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=B
	C4fCybLAxsF/XLh6Is56nPzu854yyyiZLqtyuTD28E=; b=NlWKRn8xs4ZftHPSe
	vDoJNh73IqwGv9gCuSAMLt50PJ4XRdKWq4Kh6+CYyFslu/7V251hiFgVFA2LD1Si
	qrS6TVu6PM1215iqm8+g/uZNhmtCCtgQbehuWyvZTE8QUHbv+TCvU3UiF12VQQv5
	Sqkkt9sw/fDn8Cw1r6Rgx9+JUNOrbO8aVa/DnvVMhxe9VcdIGWVbBV5eU4cLd8mj
	jJ8yJpewSUPqw5AdGLDjcGxSdCD+oY1YMXZfxGEhe9TO//0pko10OQjFVUgjiH/g
	SlTfRBFEkMDBNGNG3edGmZi+yvlbNJgja/2yGgqpg37wlGCcL8lxc33X0/8U3DBT
	yf1gw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 41s78rgtgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Sep 2024 07:05:40 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 20 Sep 2024 07:05:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 07:05:39 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 579A65B6923;
	Fri, 20 Sep 2024 07:05:37 -0700 (PDT)
From: Srujana Challa <schalla@marvell.com>
To: <virtualization@lists.linux.dev>, <kvm@vger.kernel.org>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <eperezma@redhat.com>,
        <ndabilpuram@marvell.com>, <jerinj@marvell.com>
Subject: [PATCH v2 2/2] vhost-vdpa: introduce NO-IOMMU backend feature bit
Date: Fri, 20 Sep 2024 19:35:30 +0530
Message-ID: <20240920140530.775307-3-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240920140530.775307-1-schalla@marvell.com>
References: <20240920140530.775307-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6n2MzqUhxoHiS0hiy9Uo1tgVasAW9M7C
X-Proofpoint-GUID: 6n2MzqUhxoHiS0hiy9Uo1tgVasAW9M7C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

This patch introduces the VHOST_BACKEND_F_NOIOMMU feature flag.
This flag allows userspace to identify if the driver can operate
without an IOMMU, providing more flexibility in environments where
IOMMU is not available or desired.

Key changes include:
    - Addition of the VHOST_BACKEND_F_NOIOMMU feature flag.
    - Updates to vhost_vdpa_unlocked_ioctl to handle the NO-IOMMU
      feature.
The NO-IOMMU mode is enabled if:
    - The vdpa device lacks an IOMMU domain.
    - The system has the required RAWIO permissions.
    - The vdpa device explicitly supports NO-IOMMU mode.

This feature flag indicates to userspace that the driver can safely
operate in NO-IOMMU mode. If the flag is absent, userspace should
assume NO-IOMMU mode is unsupported and take appropriate actions.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/vhost/vdpa.c             | 11 ++++++++++-
 include/uapi/linux/vhost_types.h |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index b3085189ea4a..de47349eceff 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -797,7 +797,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 				 BIT_ULL(VHOST_BACKEND_F_IOTLB_PERSIST) |
 				 BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
 				 BIT_ULL(VHOST_BACKEND_F_RESUME) |
-				 BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
+				 BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK) |
+				 BIT_ULL(VHOST_BACKEND_F_NOIOMMU)))
 			return -EOPNOTSUPP;
 		if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
 		     !vhost_vdpa_can_suspend(v))
@@ -814,6 +815,12 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		if ((features & BIT_ULL(VHOST_BACKEND_F_IOTLB_PERSIST)) &&
 		     !vhost_vdpa_has_persistent_map(v))
 			return -EOPNOTSUPP;
+		if ((features & BIT_ULL(VHOST_BACKEND_F_NOIOMMU)) &&
+		    !v->noiommu_en)
+			return -EOPNOTSUPP;
+		if (!(features & BIT_ULL(VHOST_BACKEND_F_NOIOMMU)) &&
+		    v->noiommu_en)
+			return -EOPNOTSUPP;
 		vhost_set_backend_features(&v->vdev, features);
 		return 0;
 	}
@@ -871,6 +878,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 			features |= BIT_ULL(VHOST_BACKEND_F_DESC_ASID);
 		if (vhost_vdpa_has_persistent_map(v))
 			features |= BIT_ULL(VHOST_BACKEND_F_IOTLB_PERSIST);
+		if (v->noiommu_en)
+			features |= BIT_ULL(VHOST_BACKEND_F_NOIOMMU);
 		features |= vhost_vdpa_get_backend_features(v);
 		if (copy_to_user(featurep, &features, sizeof(features)))
 			r = -EFAULT;
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index d7656908f730..dda673c3456a 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -192,5 +192,7 @@ struct vhost_vdpa_iova_range {
 #define VHOST_BACKEND_F_DESC_ASID    0x7
 /* IOTLB don't flush memory mapping across device reset */
 #define VHOST_BACKEND_F_IOTLB_PERSIST  0x8
+/* Enables the device to operate in NO-IOMMU mode as well */
+#define VHOST_BACKEND_F_NOIOMMU  0x9
 
 #endif
-- 
2.25.1


