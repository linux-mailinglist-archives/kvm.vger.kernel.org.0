Return-Path: <kvm+bounces-33851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F197E9F2D83
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 10:57:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAFED18872CA
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 09:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76E32040B7;
	Mon, 16 Dec 2024 09:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="AfP4AYg4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F313D201026
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734342971; cv=none; b=dFHPQu6DZZ+Jw1jUgdDbuxl/oSD9/yCrXAEPAmXINc5IC87YtQxzV4pmR1XbfnLePzZpCWx+N59/qPKeoPngxVZ3a6IcS4N0ti+ZHzIhvcBb6L6L/A70pnBTycqDLVODw+8Peuzx4ceybwel/mupjzVNO4+9MFte4abOvkX9YP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734342971; c=relaxed/simple;
	bh=uz4wHCSnWJTNPll4b5euHgZgBe9SVb4ShU51S6mnk5I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PEON7QBF3xYHHKGVOQwFXVzyWqsiYV70oGFzXv6Cfzt2+qp+WETZlZAac0/3iRjsH5couU9dpPXEhRieSGssuNn77YpN59oWZflEB+uIv8b/Eq/fFU2jPLp0oPkKIubIhUh7iwgB03VS6FZdiYSpqcuMqQsWinhfJVXgeRUZVxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=AfP4AYg4; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BG6pq1s019847
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 01:56:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=F
	ViO/GG+RK+U6PNdQVar6FXzIzCS7v+deFT5xR57T6M=; b=AfP4AYg4Sz3/7aA6u
	+hzjsWTqthnJ0udiHqECM3aYSJgleIxzZ8ngJPjAxFafOAoRbfl8v7dzruGeJIiB
	akiwC1K/uL4dC46wsewb8woI4FLjseEawWEZxnKNXzOMsVJqrQNIbt6SZmNukbL6
	5sOX5VZm4Quj5P9WQQG4DiRQNc=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43jfa28tch-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 01:56:06 -0800 (PST)
Received: from twshared11082.06.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Mon, 16 Dec 2024 09:56:05 +0000
Received: by devvm12370.nha0.facebook.com (Postfix, from userid 624418)
	id D8AB610A1F00A; Mon, 16 Dec 2024 01:55:55 -0800 (PST)
From: Wei Lin Guay <wguay@fb.com>
To: <alex.williamson@redhat.com>, <dri-devel@lists.freedesktop.org>,
        <kvm@vger.kernel.org>, <linux-rdma@vger.kernel.org>
CC: <jgg@nvidia.com>, <vivek.kasireddy@intel.com>, <dagmoxnes@meta.com>,
        <kbusch@kernel.org>, <nviljoen@meta.com>,
        Wei Lin Guay <wguay@meta.com>
Subject: [PATCH 4/4] vfio/pci: Allow export dmabuf without move_notify from importer
Date: Mon, 16 Dec 2024 01:54:18 -0800
Message-ID: <20241216095429.210792-5-wguay@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241216095429.210792-1-wguay@fb.com>
References: <20241216095429.210792-1-wguay@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 2Q1YTevjopUf1cR-4vUg7xPnMOU0EhhU
X-Proofpoint-ORIG-GUID: 2Q1YTevjopUf1cR-4vUg7xPnMOU0EhhU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Wei Lin Guay <wguay@meta.com>

Summary:
Support vfio to export dmabuf to importer such as RDMA NIC that does
not support move_notify callback, since not all RDMA driver support
on-demand-paging (ODP).

There are some use-cases such as bind accelerator that always pinned
the device memory via vfio and export it to RDMA NIC such as EFA, BNXT_RE
or IRDMA that does not support ODP.

Signed-off-by: Wei Lin Guay <wguay@meta.com>
Reviewed-by: Dag Moxnes <dagmoxnes@meta.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Nic Viljoen <nviljoen@meta.com>
---
 drivers/vfio/pci/dma_buf.c       | 32 +++++++++++++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_core.c | 16 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h |  7 +++++++
 3 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/dma_buf.c b/drivers/vfio/pci/dma_buf.c
index fd772b520cd7..8017f48296cb 100644
--- a/drivers/vfio/pci/dma_buf.c
+++ b/drivers/vfio/pci/dma_buf.c
@@ -17,6 +17,7 @@ struct vfio_pci_dma_buf {
 	unsigned int orig_nents;
 	size_t offset;
 	bool revoked;
+	bool pinned;
 };

 static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
@@ -32,17 +33,38 @@ static int vfio_pci_dma_buf_attach(struct dma_buf *dm=
abuf,
 	return 0;
 }

+bool vfio_pci_dma_buf_pinned(struct vfio_pci_core_device *vdev)
+{
+	struct vfio_pci_dma_buf *priv;
+	struct vfio_pci_dma_buf *tmp;
+	bool pinned =3D false;
+
+	down_write(&vdev->memory_lock);
+	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm) {
+		if (!dma_buf_try_get(priv->dmabuf))
+			continue;
+		if (priv->pinned) {
+			pinned =3D true;
+			break;
+		}
+	}
+	up_write(&vdev->memory_lock);
+	return pinned;
+}
+
 static void vfio_pci_dma_buf_unpin(struct dma_buf_attachment *attachment=
)
 {
+	struct vfio_pci_dma_buf *priv =3D attachment->dmabuf->priv;
+
+	priv->pinned =3D false;
 }

 static int vfio_pci_dma_buf_pin(struct dma_buf_attachment *attachment)
 {
-	/*
-	 * Uses the dynamic interface but must always allow for
-	 * dma_buf_move_notify() to do revoke
-	 */
-	return -EINVAL;
+	struct vfio_pci_dma_buf *priv =3D attachment->dmabuf->priv;
+
+	priv->pinned =3D true;
+	return 0;
 }

 static struct sg_table *
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
index bb97b4d94eb7..db28fa2cc9a8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1246,6 +1246,13 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_co=
re_device *vdev,
 	 */
 	vfio_pci_set_power_state(vdev, PCI_D0);

+	/*
+	 * prevent reset if dma_buf is pinned to avoid stale pinned
+	 * expose to the dmabuf exporter.
+	 */
+	if (vfio_pci_dma_buf_pinned(vdev))
+		return -EINVAL;
+
 	vfio_pci_dma_buf_move(vdev, true);
 	ret =3D pci_try_reset_function(vdev->pdev);
 	if (__vfio_pci_memory_enabled(vdev))
@@ -2444,6 +2451,15 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_=
device_set *dev_set,
 			break;
 		}

+		/*
+		 * prevent reset if dma_buf is pinned to avoid stale pinned
+		 * expose to the dmabuf exporter.
+		 */
+		if (vfio_pci_dma_buf_pinned(vdev)) {
+			ret =3D -EINVAL;
+			break;
+		}
+
 		/*
 		 * Take the memory write lock for each device and zap BAR
 		 * mappings to prevent the user accessing the device while in
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci=
_priv.h
index 09d3c300918c..43c40dc4751c 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -107,6 +107,7 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_cor=
e_device *vdev, u32 flags,
 				  size_t argsz);
 void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev);
 void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revok=
ed);
+bool vfio_pci_dma_buf_pinned(struct vfio_pci_core_device *vdev);
 #else
 static int
 vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 fla=
gs,
@@ -115,6 +116,12 @@ vfio_pci_core_feature_dma_buf(struct vfio_pci_core_d=
evice *vdev, u32 flags,
 {
 	return -ENOTTY;
 }
+
+static inline bool vfio_pci_dma_buf_pinned(struct vfio_pci_core_device *=
vdev)
+{
+	return false;
+}
+
 static inline void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device =
*vdev)
 {
 }
--
2.43.5

