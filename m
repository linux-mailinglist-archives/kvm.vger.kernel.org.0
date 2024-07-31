Return-Path: <kvm+bounces-22796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2F89433B4
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 651CF284AD4
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 796E31BBBD9;
	Wed, 31 Jul 2024 15:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Q0zkzF8p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66251799F
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 15:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722441241; cv=none; b=qafjDrVAEVxYkCan6Y6+k5CYFoP5rfvfECIr/EPjJlX+p8GlLZz+mernNT9mrN1oNNKjvfu84dzjml8S1vCwpc83qkoiFYxVWxynsOta0QOMxaZdjcDWuIaam+Gpdi/EYiF0GPGre3kun4L/abU2hNWLDJNd1kRLRIOIm9poD0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722441241; c=relaxed/simple;
	bh=jIWkQpZO3PpIcSipj6oP0IBHKsjZ8w7SKBDBZcf99PA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kMpcqCaP9zqV0PUNrDa0c0vqtpwDe1MzMHm/ANYESMrgZCtriOf1/YxKZVL4Fd606agIf51HiDL164NCDEPPyEdrYzR3RD//2ZTw1Ezu5tJxmOQdDs5CKvGSNAu2n2ItHftdMZcBASeUdEKCRQvc2s7M3g7Qc3JzaExghgGG6Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Q0zkzF8p; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46VE2rqL014230
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 08:53:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=s2048-2021-q4; bh=Zy6
	VJrOVj8mJa4n6l6Htv/n8eRtnqnR9X3Re5ahdMCk=; b=Q0zkzF8pVzgb5WT1Hi6
	Ww3hTJ2+9U0UNvv32ZzSaXYMKyhaqXpBH6fqhlyubXgGHjL+M6mOjI9Y0/YIF2Q1
	SzEGqSu363/13O9pU73y4NNxOI3/h2ZFiCmCyH/XeBgbRM++T4TA67IQ+ayWNXX9
	OQY787/dTR4vpr87EpMLJ1FJGtwuqTqFWGGSFPwLurEQYnNtKpTd5e7SVK0awgTZ
	y03miib5g/Gf/DdSDBL9WABo3/PgMncMLYGyqkxLFsvp+OcEiRf2Ki5/rQzJYxKN
	zDfWU+TKLzDF6FM3bkFaYibWjMdggprg2pcRNVWpGvmIjMrkKLFOV/xPl2I5joJp
	1AQ==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40qa6g5acm-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 08:53:58 -0700 (PDT)
Received: from twshared19013.17.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 31 Jul 2024 15:53:55 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 2CBEB11394BA3; Wed, 31 Jul 2024 08:53:53 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCH rfc] vfio-pci: Allow write combining
Date: Wed, 31 Jul 2024 08:53:52 -0700
Message-ID: <20240731155352.3973857-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 8G1ENu2f0BrTCT2qYtm5zkC5WpeapTlM
X-Proofpoint-GUID: 8G1ENu2f0BrTCT2qYtm5zkC5WpeapTlM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-31_10,2024-07-31_01,2024-05-17_01

From: Keith Busch <kbusch@kernel.org>

Write combining can be provide performance improvement for places that
can safely use this capability.

Previous discussions on the topic suggest a vfio user needs to
explicitly request such a mapping, and it sounds like a new vfio
specific ioctl to request this is one way recommended way to do that.
This patch implements a new ioctl to achieve that so a user can request
write combining on prefetchable memory. A new ioctl seems a bit much for
just this purpose, so the implementation here provides a "flags" field
with only the write combine option defined. The rest of the bits are
reserved for future use.

Link: https://lore.kernel.org/all/20171009025000.39435-1-aik@ozlabs.ru/
Link: https://lore.kernel.org/lkml/ZLFBnACjoTbDmKuU@nvidia.com/
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 39 +++++++++++++++++++++++++++++++-
 include/linux/vfio_pci_core.h    |  1 +
 include/uapi/linux/vfio.h        | 17 ++++++++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
index ba0ce0075b2fb..c275c95eafe32 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1042,12 +1042,18 @@ static int vfio_pci_ioctl_get_region_info(struct =
vfio_pci_core_device *vdev,
 		info.flags =3D VFIO_REGION_INFO_FLAG_READ |
 			     VFIO_REGION_INFO_FLAG_WRITE;
 		if (vdev->bar_mmap_supported[info.index]) {
+			struct resource *res;
+
 			info.flags |=3D VFIO_REGION_INFO_FLAG_MMAP;
 			if (info.index =3D=3D vdev->msix_bar) {
 				ret =3D msix_mmappable_cap(vdev, &caps);
 				if (ret)
 					return ret;
 			}
+
+			res =3D &vdev->pdev->resource[index];
+			if (res->flags & IORESOURCE_PREFETCH)
+				info.flags |=3D VFIO_REGION_INFO_FLAG_PREFETCH;
 		}
=20
 		break;
@@ -1223,6 +1229,32 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci=
_core_device *vdev,
 	return ret;
 }
=20
+static int vfio_pci_ioctl_set_region_flags(struct vfio_pci_core_device *=
vdev,
+				   struct vfio_region_flags __user *arg)
+{
+	struct vfio_region_flags region_flags;
+	struct resource *res;
+	u32 index;
+
+	if (copy_from_user(&region_flags, arg, sizeof(region_flags)))
+		return -EFAULT;
+
+	index =3D region_flags.index;
+	if (index >=3D PCI_STD_NUM_BARS)
+		return -EINVAL;
+
+	if (region_flags.flags & VFIO_REGION_FLAG_WRITE_COMBINE) {
+		res =3D &vdev->pdev->resource[index];
+		if (!(res->flags & IORESOURCE_MEM) ||
+		    !(res->flags & IORESOURCE_PREFETCH))
+			return -EINVAL;
+		vdev->bar_write_combine[index] =3D true;
+	} else
+		vdev->bar_write_combine[index] =3D false;
+
+	return 0;
+}
+
 static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 				void __user *arg)
 {
@@ -1484,6 +1516,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_v=
dev, unsigned int cmd,
 		return vfio_pci_ioctl_reset(vdev, uarg);
 	case VFIO_DEVICE_SET_IRQS:
 		return vfio_pci_ioctl_set_irqs(vdev, uarg);
+	case VFIO_DEVICE_SET_REGION_FLAGS:
+		return vfio_pci_ioctl_set_region_flags(vdev, uarg);
 	default:
 		return -ENOTTY;
 	}
@@ -1756,7 +1790,10 @@ int vfio_pci_core_mmap(struct vfio_device *core_vd=
ev, struct vm_area_struct *vma
 	}
=20
 	vma->vm_private_data =3D vdev;
-	vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
+	if (vdev->bar_write_combine[index])
+		vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);
+	else
+		vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
 	vma->vm_page_prot =3D pgprot_decrypted(vma->vm_page_prot);
=20
 	/*
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.=
h
index fbb472dd99b36..0e0122ce4196a 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -54,6 +54,7 @@ struct vfio_pci_core_device {
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
+	bool			bar_write_combine[PCI_STD_NUM_BARS];
 	u8			*pci_config_map;
 	u8			*vconfig;
 	struct perm_bits	*msi_perm;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf1902..5537b20b23541 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -275,6 +275,7 @@ struct vfio_region_info {
 #define VFIO_REGION_INFO_FLAG_WRITE	(1 << 1) /* Region supports write */
 #define VFIO_REGION_INFO_FLAG_MMAP	(1 << 2) /* Region supports mmap */
 #define VFIO_REGION_INFO_FLAG_CAPS	(1 << 3) /* Info supports caps */
+#define VFIO_REGION_INFO_FLAG_PREFETCH	(1 << 4) /* Region is prefetchabl=
e */
 	__u32	index;		/* Region index */
 	__u32	cap_offset;	/* Offset within info struct of first cap */
 	__aligned_u64	size;	/* Region size (bytes) */
@@ -1821,6 +1822,22 @@ struct vfio_iommu_spapr_tce_remove {
 };
 #define VFIO_IOMMU_SPAPR_TCE_REMOVE	_IO(VFIO_TYPE, VFIO_BASE + 20)
=20
+/**
+ * VFIO_DEVICE_SET_REGION_FLAGS	 - _IOW(VFIO_TYPE, VFIO_BASE + 21, struc=
t vfio_region_flags)
+ *
+ * Set mapping options for the region
+ *
+ * Flags supported:
+ * - VFIO_REGION_FLAG_WRITE_COMBINE: use write-combine when requested to=
 map
+ *   this region. Supported only if the region is prefetchable.
+ */
+struct vfio_region_flags {
+	__u32	index;		/* Region index */
+	__u32	flags;		/* Region flags */
+#define VFIO_REGION_FLAG_WRITE_COMBINE	(1 << 0)
+};
+#define VFIO_DEVICE_SET_REGION_FLAGS	_IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /* ***************************************************************** */
=20
 #endif /* _UAPIVFIO_H */
--=20
2.43.5


