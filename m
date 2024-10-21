Return-Path: <kvm+bounces-29282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B73769A67A3
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76C45283A97
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 12:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505C01EF088;
	Mon, 21 Oct 2024 12:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Tf3GhymB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70E21EF082
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 12:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729512539; cv=none; b=GVghXXa66LiQh4cdqersSVTlA/rgHO1n6dFQhYdHI7G97S6dpq9lJSEz9lzGTF81Hgq9EgZJ9BCLtv/5GeQM1zaaLgxMTnAa+NDL+WM1jQjm5peJ+dOjOwaMqoDcm0+iVLchg0HkuM9uoULPHm1dxhgsfZX32pFfVyvp12au5Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729512539; c=relaxed/simple;
	bh=1MsCKRlQpRqcAV+Ym1q6F7N57bnxFPzjbWMnWZ1PfrI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EH2aB2IPZ1ukvhhpQndTmYoMq1JhyhYZ+KD7pYQUaJMvriG8gfRsaDfpL7THNAsgRLPkbKR+i9dsWHraIdMa7O5BE1l57wOkotpKG3bOidD/YwlTP3MwIlQYzdVKGtVaD457T09CuqrpoKv63H0MdljL0uXQ9z0iZ3OeXGpUu9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Tf3GhymB; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L9QaZW008385;
	Mon, 21 Oct 2024 05:08:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=R
	Zmiy4Vbw49Ml5cNO5E7GnvY/OYaPsiB+WypP02EBto=; b=Tf3GhymB7ItzY1FaT
	UD3b9N7gUnUx86Zhk1cj487Bcx3XUtpdhfohcbW/1x9FnHGSsQo1a+t1ahHc4CvO
	F2x46G+ss5XAyoESXpzt6S63uKPvqUcihN9hDh+iSdxch77OB1HXKbUSiZ7n9gkm
	LZcCeXnBP57tnuqP/gK52GfI8oFqfU1LFEU0p3/VSsdPuEO5Ux7iGe6RR3JzZfI7
	RDXMjVbrUInJ3sRuOBB2dUtl9FXci9PBf/rBHXU7wwG2jKkE+Yeq/odN32xOkk5n
	VNDriAoGUX20IbokMKS0QpaHbYJz7/uZXPeon/IeAdJgFrT6yQQazun6zMBwcuxm
	XletQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 42dmay89gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 05:08:46 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 21 Oct 2024 05:08:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 21 Oct 2024 05:08:45 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 9BE4C3F7052;
	Mon, 21 Oct 2024 05:08:43 -0700 (PDT)
From: Srujana Challa <schalla@marvell.com>
To: <virtualization@lists.linux.dev>, <kvm@vger.kernel.org>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <eperezma@redhat.com>,
        <ndabilpuram@marvell.com>, <jerinj@marvell.com>
Subject: [PATCH v3 2/2] vhost-vdpa: introduce NO-IOMMU backend feature bit
Date: Mon, 21 Oct 2024 17:38:37 +0530
Message-ID: <20241021120837.1438628-3-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241021120837.1438628-1-schalla@marvell.com>
References: <20241021120837.1438628-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: t-A0dTSPI0zmV-OOJfZHG5lN9ii0nARe
X-Proofpoint-ORIG-GUID: t-A0dTSPI0zmV-OOJfZHG5lN9ii0nARe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01

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

This feature flag indicates to userspace that the driver can
operate in NO-IOMMU mode. If the flag is absent, userspace should
treat NO-IOMMU mode as unsupported and refrain from proceeding when
IOMMU is not present.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/vhost/vdpa.c             | 11 ++++++++++-
 include/uapi/linux/vhost_types.h |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 81dd8bfb152b..7ac6966fc825 100644
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


