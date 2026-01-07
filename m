Return-Path: <kvm+bounces-67207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4058FCFCD2C
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 10:21:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4C9A830C38E4
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 09:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61892F9984;
	Wed,  7 Jan 2026 09:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDhzIVAA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2E0235358;
	Wed,  7 Jan 2026 09:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767777287; cv=none; b=WjrkVeFNgoiHVk4GcusOZMOWTF7LoYyWOn5dKemprjsOEagsRoK+VfMJAjIbQTuKUo+lFmt8tkCebqGOgv7vFzsP7QXugr4UF2hD0A7EwC0BbYLVBA2TRPHfjlZoACs/11/Mb+kmHAOpnghmmaLEICc2GyRtI+dR70GstI6rDK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767777287; c=relaxed/simple;
	bh=HsPlCCX1CEyta2DFKeO1SH/8Utd6OpTbt/o6QeMxdoI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ugAudALv/ki+cb3L7qbd0MuN8seOYMjIsV5C76PTsZ9yPGNAOLqxgzSzgibASj3czxfNqdtdw7srt0FAxD32gnFqs4aYPGaqLfOUPk1X1EZtGkVfzXWGYO5pY6TcMF/o6XTpBlAhGR2tyFrCcsHhlZPuME+9gNx7ZrxjbT8i7xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDhzIVAA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C37C4CEF7;
	Wed,  7 Jan 2026 09:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767777286;
	bh=HsPlCCX1CEyta2DFKeO1SH/8Utd6OpTbt/o6QeMxdoI=;
	h=From:To:Subject:Date:From;
	b=hDhzIVAAC19+cgnPI09bILtCRfXF3p6nxY6+6cBYuiKEvDub7R6ZCbU/tl4v0qTEr
	 mUKbxTG5qvLxlvcetNxlxnQJAkShZu0jNxBXACh1u8tNEbrKRcZ5PgHNLoPRfAMKYZ
	 ooXXOC/5JlIKE/fxcP3+oZU9YLfYjU14dikwHIonIlqUWZU4w9NqJbTsi2Cu9PlW/6
	 JrSkw/Pt6j1+NSZipD4DN2rXk3uvpmx70q0ZmHfa7gIOLW7b9BCpfyEVgorJJHamMT
	 Heh8v7vInmPCzP1tmE6/Vs+aBlJNT5Bro+LIOxE8TpH+sQvpqBc7JKv8WAGNQNEDNz
	 zDLX6pBD3yhrA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex@shazbot.org>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: types: reuse common phys_vec type instead of DMABUF open‑coded variant
Date: Wed,  7 Jan 2026 11:14:14 +0200
Message-ID: <20260107-convert-to-pvec-v1-1-6e3ab8079708@nvidia.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260107-convert-to-pvec-bf04dfcf3d12
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: quoted-printable

From: Leon Romanovsky <leonro@nvidia.com>=0D
=0D
After commit fcf463b92a08 ("types: move phys_vec definition to common heade=
r"),=0D
we can use the shared phys_vec type instead of the DMABUF=E2=80=91specific=
=0D
dma_buf_phys_vec, which duplicated the same structure and semantics.=0D
=0D
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>=0D
---=0D
Alex,=0D
=0D
According to diffstat, VFIO is the subsystem with the largest set of change=
s,=0D
so it would be great if you could take it through your tree.=0D
=0D
The series is based on the for-7.0/blk-pvec shared branch from Jens:=0D
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=3Dfo=
r-7.0/blk-pvec=0D
=0D
Thanks=0D
---=0D
Cc: linux-media@vger.kernel.org=0D
Cc: dri-devel@lists.freedesktop.org=0D
Cc: linaro-mm-sig@lists.linaro.org=0D
Cc: linux-kernel@vger.kernel.org=0D
Cc: iommu@lists.linux.dev=0D
Cc: kvm@vger.kernel.org=0D
To: Sumit Semwal <sumit.semwal@linaro.org>=0D
To: Christian K=C3=B6nig <christian.koenig@amd.com>=0D
To: Jason Gunthorpe <jgg@ziepe.ca>=0D
To: Kevin Tian <kevin.tian@intel.com>=0D
To: Joerg Roedel <joro@8bytes.org>=0D
To: Will Deacon <will@kernel.org>=0D
To: Robin Murphy <robin.murphy@arm.com>=0D
To: Yishai Hadas <yishaih@nvidia.com>=0D
To: Shameer Kolothum <skolothumtho@nvidia.com>=0D
To: Ankit Agrawal <ankita@nvidia.com>=0D
To: Alex Williamson <alex@shazbot.org>=0D
Cc: Matthew Wilcox <willy@infradead.org>=0D
Cc: Jens Axboe <axboe@kernel.dk>=0D
---=0D
 drivers/dma-buf/dma-buf-mapping.c       |  6 +++---=0D
 drivers/iommu/iommufd/io_pagetable.h    |  2 +-=0D
 drivers/iommu/iommufd/iommufd_private.h |  5 ++---=0D
 drivers/iommu/iommufd/pages.c           |  4 ++--=0D
 drivers/iommu/iommufd/selftest.c        |  2 +-=0D
 drivers/vfio/pci/nvgrace-gpu/main.c     |  2 +-=0D
 drivers/vfio/pci/vfio_pci_dmabuf.c      |  8 ++++----=0D
 include/linux/dma-buf-mapping.h         |  2 +-=0D
 include/linux/dma-buf.h                 | 10 ----------=0D
 include/linux/vfio_pci_core.h           | 13 ++++++-------=0D
 10 files changed, 21 insertions(+), 33 deletions(-)=0D
=0D
diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-ma=
pping.c=0D
index b7352e609fbd..174677faa577 100644=0D
--- a/drivers/dma-buf/dma-buf-mapping.c=0D
+++ b/drivers/dma-buf/dma-buf-mapping.c=0D
@@ -33,8 +33,8 @@ static struct scatterlist *fill_sg_entry(struct scatterli=
st *sgl, size_t length,=0D
 }=0D
 =0D
 static unsigned int calc_sg_nents(struct dma_iova_state *state,=0D
-				  struct dma_buf_phys_vec *phys_vec,=0D
-				  size_t nr_ranges, size_t size)=0D
+				  struct phys_vec *phys_vec, size_t nr_ranges,=0D
+				  size_t size)=0D
 {=0D
 	unsigned int nents =3D 0;=0D
 	size_t i;=0D
@@ -91,7 +91,7 @@ struct dma_buf_dma {=0D
  */=0D
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach=
,=0D
 					 struct p2pdma_provider *provider,=0D
-					 struct dma_buf_phys_vec *phys_vec,=0D
+					 struct phys_vec *phys_vec,=0D
 					 size_t nr_ranges, size_t size,=0D
 					 enum dma_data_direction dir)=0D
 {=0D
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/i=
o_pagetable.h=0D
index 14cd052fd320..27e3e311d395 100644=0D
--- a/drivers/iommu/iommufd/io_pagetable.h=0D
+++ b/drivers/iommu/iommufd/io_pagetable.h=0D
@@ -202,7 +202,7 @@ struct iopt_pages_dmabuf_track {=0D
 =0D
 struct iopt_pages_dmabuf {=0D
 	struct dma_buf_attachment *attach;=0D
-	struct dma_buf_phys_vec phys;=0D
+	struct phys_vec phys;=0D
 	/* Always PAGE_SIZE aligned */=0D
 	unsigned long start;=0D
 	struct list_head tracker;=0D
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommuf=
d/iommufd_private.h=0D
index eb6d1a70f673..6ac1965199e9 100644=0D
--- a/drivers/iommu/iommufd/iommufd_private.h=0D
+++ b/drivers/iommu/iommufd/iommufd_private.h=0D
@@ -20,7 +20,6 @@ struct iommu_group;=0D
 struct iommu_option;=0D
 struct iommufd_device;=0D
 struct dma_buf_attachment;=0D
-struct dma_buf_phys_vec;=0D
 =0D
 struct iommufd_sw_msi_map {=0D
 	struct list_head sw_msi_item;=0D
@@ -718,7 +717,7 @@ int __init iommufd_test_init(void);=0D
 void iommufd_test_exit(void);=0D
 bool iommufd_selftest_is_mock_dev(struct device *dev);=0D
 int iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment=
,=0D
-				     struct dma_buf_phys_vec *phys);=0D
+				     struct phys_vec *phys);=0D
 #else=0D
 static inline void iommufd_test_syz_conv_iova_id(struct iommufd_ucmd *ucmd=
,=0D
 						 unsigned int ioas_id,=0D
@@ -742,7 +741,7 @@ static inline bool iommufd_selftest_is_mock_dev(struct =
device *dev)=0D
 }=0D
 static inline int=0D
 iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,=0D
-				 struct dma_buf_phys_vec *phys)=0D
+				 struct phys_vec *phys)=0D
 {=0D
 	return -EOPNOTSUPP;=0D
 }=0D
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c=
=0D
index dbe51ecb9a20..bababd564cf9 100644=0D
--- a/drivers/iommu/iommufd/pages.c=0D
+++ b/drivers/iommu/iommufd/pages.c=0D
@@ -1077,7 +1077,7 @@ static int pfn_reader_user_update_pinned(struct pfn_r=
eader_user *user,=0D
 }=0D
 =0D
 struct pfn_reader_dmabuf {=0D
-	struct dma_buf_phys_vec phys;=0D
+	struct phys_vec phys;=0D
 	unsigned long start_offset;=0D
 };=0D
 =0D
@@ -1460,7 +1460,7 @@ static struct dma_buf_attach_ops iopt_dmabuf_attach_r=
evoke_ops =3D {=0D
  */=0D
 static int=0D
 sym_vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,=0D
-				 struct dma_buf_phys_vec *phys)=0D
+				 struct phys_vec *phys)=0D
 {=0D
 	typeof(&vfio_pci_dma_buf_iommufd_map) fn;=0D
 	int rc;=0D
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selft=
est.c=0D
index 550ff36dec3a..989d8c4c60a7 100644=0D
--- a/drivers/iommu/iommufd/selftest.c=0D
+++ b/drivers/iommu/iommufd/selftest.c=0D
@@ -2002,7 +2002,7 @@ static const struct dma_buf_ops iommufd_test_dmabuf_o=
ps =3D {=0D
 };=0D
 =0D
 int iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment=
,=0D
-				     struct dma_buf_phys_vec *phys)=0D
+				     struct phys_vec *phys)=0D
 {=0D
 	struct iommufd_test_dma_buf *priv =3D attachment->dmabuf->priv;=0D
 =0D
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace=
-gpu/main.c=0D
index 84d142a47ec6..a0f4edd6a30b 100644=0D
--- a/drivers/vfio/pci/nvgrace-gpu/main.c=0D
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c=0D
@@ -784,7 +784,7 @@ nvgrace_gpu_write(struct vfio_device *core_vdev,=0D
 static int nvgrace_get_dmabuf_phys(struct vfio_pci_core_device *core_vdev,=
=0D
 				   struct p2pdma_provider **provider,=0D
 				   unsigned int region_index,=0D
-				   struct dma_buf_phys_vec *phys_vec,=0D
+				   struct phys_vec *phys_vec,=0D
 				   struct vfio_region_dma_range *dma_ranges,=0D
 				   size_t nr_ranges)=0D
 {=0D
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci=
_dmabuf.c=0D
index d4d0f7d08c53..9a84c238c013 100644=0D
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c=0D
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c=0D
@@ -14,7 +14,7 @@ struct vfio_pci_dma_buf {=0D
 	struct vfio_pci_core_device *vdev;=0D
 	struct list_head dmabufs_elm;=0D
 	size_t size;=0D
-	struct dma_buf_phys_vec *phys_vec;=0D
+	struct phys_vec *phys_vec;=0D
 	struct p2pdma_provider *provider;=0D
 	u32 nr_ranges;=0D
 	u8 revoked : 1;=0D
@@ -94,7 +94,7 @@ static const struct dma_buf_ops vfio_pci_dmabuf_ops =3D {=
=0D
  *    will fail if it is currently revoked=0D
  */=0D
 int vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,=0D
-				 struct dma_buf_phys_vec *phys)=0D
+				 struct phys_vec *phys)=0D
 {=0D
 	struct vfio_pci_dma_buf *priv;=0D
 =0D
@@ -116,7 +116,7 @@ int vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachm=
ent *attachment,=0D
 }=0D
 EXPORT_SYMBOL_FOR_MODULES(vfio_pci_dma_buf_iommufd_map, "iommufd");=0D
 =0D
-int vfio_pci_core_fill_phys_vec(struct dma_buf_phys_vec *phys_vec,=0D
+int vfio_pci_core_fill_phys_vec(struct phys_vec *phys_vec,=0D
 				struct vfio_region_dma_range *dma_ranges,=0D
 				size_t nr_ranges, phys_addr_t start,=0D
 				phys_addr_t len)=0D
@@ -148,7 +148,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_fill_phys_vec);=0D
 int vfio_pci_core_get_dmabuf_phys(struct vfio_pci_core_device *vdev,=0D
 				  struct p2pdma_provider **provider,=0D
 				  unsigned int region_index,=0D
-				  struct dma_buf_phys_vec *phys_vec,=0D
+				  struct phys_vec *phys_vec,=0D
 				  struct vfio_region_dma_range *dma_ranges,=0D
 				  size_t nr_ranges)=0D
 {=0D
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mappin=
g.h=0D
index a3c0ce2d3a42..09bde3f748e4 100644=0D
--- a/include/linux/dma-buf-mapping.h=0D
+++ b/include/linux/dma-buf-mapping.h=0D
@@ -9,7 +9,7 @@=0D
 =0D
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach=
,=0D
 					 struct p2pdma_provider *provider,=0D
-					 struct dma_buf_phys_vec *phys_vec,=0D
+					 struct phys_vec *phys_vec,=0D
 					 size_t nr_ranges, size_t size,=0D
 					 enum dma_data_direction dir);=0D
 void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *=
sgt,=0D
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h=0D
index 0bc492090237..400a5311368e 100644=0D
--- a/include/linux/dma-buf.h=0D
+++ b/include/linux/dma-buf.h=0D
@@ -531,16 +531,6 @@ struct dma_buf_export_info {=0D
 	void *priv;=0D
 };=0D
 =0D
-/**=0D
- * struct dma_buf_phys_vec - describe continuous chunk of memory=0D
- * @paddr:   physical address of that chunk=0D
- * @len:     Length of this chunk=0D
- */=0D
-struct dma_buf_phys_vec {=0D
-	phys_addr_t paddr;=0D
-	size_t len;=0D
-};=0D
-=0D
 /**=0D
  * DEFINE_DMA_BUF_EXPORT_INFO - helper macro for exporters=0D
  * @name: export-info name=0D
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h=
=0D
index 706877f998ff..2ac288bb2c60 100644=0D
--- a/include/linux/vfio_pci_core.h=0D
+++ b/include/linux/vfio_pci_core.h=0D
@@ -28,7 +28,6 @@=0D
 struct vfio_pci_core_device;=0D
 struct vfio_pci_region;=0D
 struct p2pdma_provider;=0D
-struct dma_buf_phys_vec;=0D
 struct dma_buf_attachment;=0D
 =0D
 struct vfio_pci_eventfd {=0D
@@ -62,25 +61,25 @@ struct vfio_pci_device_ops {=0D
 	int (*get_dmabuf_phys)(struct vfio_pci_core_device *vdev,=0D
 			       struct p2pdma_provider **provider,=0D
 			       unsigned int region_index,=0D
-			       struct dma_buf_phys_vec *phys_vec,=0D
+			       struct phys_vec *phys_vec,=0D
 			       struct vfio_region_dma_range *dma_ranges,=0D
 			       size_t nr_ranges);=0D
 };=0D
 =0D
 #if IS_ENABLED(CONFIG_VFIO_PCI_DMABUF)=0D
-int vfio_pci_core_fill_phys_vec(struct dma_buf_phys_vec *phys_vec,=0D
+int vfio_pci_core_fill_phys_vec(struct phys_vec *phys_vec,=0D
 				struct vfio_region_dma_range *dma_ranges,=0D
 				size_t nr_ranges, phys_addr_t start,=0D
 				phys_addr_t len);=0D
 int vfio_pci_core_get_dmabuf_phys(struct vfio_pci_core_device *vdev,=0D
 				  struct p2pdma_provider **provider,=0D
 				  unsigned int region_index,=0D
-				  struct dma_buf_phys_vec *phys_vec,=0D
+				  struct phys_vec *phys_vec,=0D
 				  struct vfio_region_dma_range *dma_ranges,=0D
 				  size_t nr_ranges);=0D
 #else=0D
 static inline int=0D
-vfio_pci_core_fill_phys_vec(struct dma_buf_phys_vec *phys_vec,=0D
+vfio_pci_core_fill_phys_vec(struct phys_vec *phys_vec,=0D
 			    struct vfio_region_dma_range *dma_ranges,=0D
 			    size_t nr_ranges, phys_addr_t start,=0D
 			    phys_addr_t len)=0D
@@ -89,7 +88,7 @@ vfio_pci_core_fill_phys_vec(struct dma_buf_phys_vec *phys=
_vec,=0D
 }=0D
 static inline int vfio_pci_core_get_dmabuf_phys(=0D
 	struct vfio_pci_core_device *vdev, struct p2pdma_provider **provider,=0D
-	unsigned int region_index, struct dma_buf_phys_vec *phys_vec,=0D
+	unsigned int region_index, struct phys_vec *phys_vec,=0D
 	struct vfio_region_dma_range *dma_ranges, size_t nr_ranges)=0D
 {=0D
 	return -EOPNOTSUPP;=0D
@@ -228,6 +227,6 @@ static inline bool is_aligned_for_order(struct vm_area_=
struct *vma,=0D
 }=0D
 =0D
 int vfio_pci_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,=0D
-				 struct dma_buf_phys_vec *phys);=0D
+				 struct phys_vec *phys);=0D
 =0D
 #endif /* VFIO_PCI_CORE_H */=0D
=0D
---=0D
base-commit: fcf463b92a08686d1aeb1e66674a72eb7a8bfb9b=0D
change-id: 20260107-convert-to-pvec-bf04dfcf3d12=0D
=0D
Best regards,=0D
--  =0D
Leon Romanovsky <leonro@nvidia.com>=0D
=0D

