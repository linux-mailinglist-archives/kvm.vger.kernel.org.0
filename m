Return-Path: <kvm+bounces-7418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB09E841A15
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 04:09:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 453591F289D1
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC77C5475D;
	Tue, 30 Jan 2024 03:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="t6R9NffG"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAE33F9E3;
	Tue, 30 Jan 2024 03:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706583987; cv=none; b=G1nyKVEhMTnmgg1Smx0BZCPinU4auJrpeiKqmyB+wm7y9LkGPGQ3wt411VbN51Bnv8vQfJ2lBT/AzWqsBn7FkdtoITZy+U8xZvSmKFI8PPRXT75K0IvxeEHggOpPCqCxDWOlX1KVm8E9330QBqnA9eOB+KV7WFyH2wfi2Vpfw+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706583987; c=relaxed/simple;
	bh=dXd2NP/xdM6sjyjiS36mOci044QBHI4Od1zyfs3Vm+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O+NTdEqAD4YqhAeguGxKmbjs95k1PGUWkPq7HEnhAGzVYq0k1mvNSc3ajAFFLfWeFrftznVzrRFI/xvdMO4B5jjLaAd4+sCV0x6rj48o3sKMQpaYOVF8rhtAgZ5ie7FYFOfNtmvLuv23o4O6tzgvGsuLEz/M8so9TNYSyG6Imsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=t6R9NffG; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706583981; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=6VIRaVPIabk7E1XlRduLJQgjTOkxYWFJWN/eQZeIAbw=;
	b=t6R9NffG5vLcorb9LMTZMX5NU4HTetAvCPRc3PVMrFcmPLOeEwvZECGfwtvRoDXOFcqm2gWJmA6sacu2aIBBq27rdlotMRUIYP9fAdJ2kGt8Zr2FiCzyKvOi6xqxphdKmR0dQjovKEnQMuliaQRR/C5SAj/Y5D17gV9dWAsFpEY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.eeCCy_1706583978;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.eeCCy_1706583978)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 11:06:19 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	linux-um@lists.infradead.org,
	netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH 08/14] virtio: find_vqs introduce premapped parameter
Date: Tue, 30 Jan 2024 11:05:58 +0800
Message-Id: <20240130030604.108463-9-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240130030604.108463-1-xuanzhuo@linux.alibaba.com>
References: <20240130030604.108463-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: ce068f9b825d
Content-Transfer-Encoding: 8bit

If the premapped mode is enabled, the dma array(struct vring_desc_dma) of
virtio core will not be allocated. That is judged when find_vqs() is called.
To avoid allocating dma array in find_vqs() and releasing it immediately by
virtqueue_set_dma_premapped(). This patch introduces a new parameter to
find_vqs(). Then we can judge should we allocate the dma array(struct
vring_desc_dma) or not inside find_vqs().

The driver must check the premapped mode of every vq after find_vqs().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 arch/um/drivers/virtio_uml.c             |  5 ++--
 drivers/platform/mellanox/mlxbf-tmfifo.c |  3 ++-
 drivers/remoteproc/remoteproc_virtio.c   |  9 ++++---
 drivers/s390/virtio/virtio_ccw.c         |  8 ++++--
 drivers/virtio/virtio_mmio.c             |  8 +++---
 drivers/virtio/virtio_pci_common.c       | 15 ++++++++----
 drivers/virtio/virtio_pci_common.h       |  2 ++
 drivers/virtio/virtio_pci_legacy.c       |  3 ++-
 drivers/virtio/virtio_pci_modern.c       |  6 +++--
 drivers/virtio/virtio_ring.c             | 31 ++++++++++++++++++------
 drivers/virtio/virtio_vdpa.c             |  6 +++--
 include/linux/virtio_config.h            | 11 ++++++---
 include/linux/virtio_ring.h              |  3 +++
 tools/virtio/linux/virtio.h              |  1 +
 tools/virtio/virtio_test.c               |  2 +-
 tools/virtio/vringh_test.c               | 10 ++++----
 16 files changed, 85 insertions(+), 38 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 8adca2000e51..171214c06411 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1016,7 +1016,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
 static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct virtqueue *vqs[], vq_callback_t *callbacks[],
 		       const char * const names[], const bool *ctx,
-		       struct irq_affinity *desc)
+		       const bool *premapped, struct irq_affinity *desc)
 {
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
 	int i, queue_idx = 0, rc;
@@ -1037,7 +1037,8 @@ static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		}
 
 		vqs[i] = vu_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     ctx ? ctx[i] : false);
+				     ctx ? ctx[i] : false,
+				     premapped ? premapped[i] : false);
 		if (IS_ERR(vqs[i])) {
 			rc = PTR_ERR(vqs[i]);
 			goto error_setup;
diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 5c683b4eaf10..a7b477c80c16 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -994,6 +994,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
 					vq_callback_t *callbacks[],
 					const char * const names[],
 					const bool *ctx,
+					const bool *premapped,
 					struct irq_affinity *desc)
 {
 	struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
@@ -1015,7 +1016,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
 		size = vring_size(vring->num, vring->align);
 		memset(vring->va, 0, size);
 		vq = vring_new_virtqueue(i, vring->num, vring->align, vdev,
-					 false, false, vring->va,
+					 false, false, premapped, vring->va,
 					 mlxbf_tmfifo_virtio_notify,
 					 callbacks[i], names[i]);
 		if (!vq) {
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 83d76915a6ad..774f1325524b 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -103,7 +103,7 @@ EXPORT_SYMBOL(rproc_vq_interrupt);
 static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 				    unsigned int id,
 				    void (*callback)(struct virtqueue *vq),
-				    const char *name, bool ctx)
+				    const char *name, bool ctx, bool premapped)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct rproc *rproc = vdev_to_rproc(vdev);
@@ -144,7 +144,8 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	 * the 'weak' smp barriers, since we're talking with a real device.
 	 */
 	vq = vring_new_virtqueue(id, num, rvring->align, vdev, false, ctx,
-				 addr, rproc_virtio_notify, callback, name);
+				 premapped, addr, rproc_virtio_notify, callback,
+				 name);
 	if (!vq) {
 		dev_err(dev, "vring_new_virtqueue %s failed\n", name);
 		rproc_free_vring(rvring);
@@ -185,6 +186,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 				 vq_callback_t *callbacks[],
 				 const char * const names[],
 				 const bool * ctx,
+				 const bool * premapped,
 				 struct irq_affinity *desc)
 {
 	int i, ret, queue_idx = 0;
@@ -196,7 +198,8 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		}
 
 		vqs[i] = rp_find_vq(vdev, queue_idx++, callbacks[i], names[i],
-				    ctx ? ctx[i] : false);
+				    ctx ? ctx[i] : false,
+				    premapped ? premapped[i] : false);
 		if (IS_ERR(vqs[i])) {
 			ret = PTR_ERR(vqs[i]);
 			goto error;
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index ac67576301bf..b27132994dc9 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -501,6 +501,7 @@ static void virtio_ccw_del_vqs(struct virtio_device *vdev)
 static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 					     int i, vq_callback_t *callback,
 					     const char *name, bool ctx,
+					     bool premapped,
 					     struct ccw1 *ccw)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
@@ -539,7 +540,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	may_reduce = vcdev->revision > 0;
 	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
 				    vdev, true, may_reduce, ctx,
-				    notify, callback, name);
+				    premapped, notify, callback, name);
 
 	if (!vq) {
 		/* For now, we fail if we can't get the requested size. */
@@ -655,6 +656,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			       vq_callback_t *callbacks[],
 			       const char * const names[],
 			       const bool *ctx,
+			       const bool *premapped,
 			       struct irq_affinity *desc)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
@@ -673,7 +675,9 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		}
 
 		vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, callbacks[i],
-					     names[i], ctx ? ctx[i] : false,
+					     names[i],
+					     ctx ? ctx[i] : false,
+					     premapped ? premapped[i] : false,
 					     ccw);
 		if (IS_ERR(vqs[i])) {
 			ret = PTR_ERR(vqs[i]);
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 59892a31cf76..1df38cceafd3 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -371,7 +371,7 @@ static void vm_synchronize_cbs(struct virtio_device *vdev)
 
 static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int index,
 				  void (*callback)(struct virtqueue *vq),
-				  const char *name, bool ctx)
+				  const char *name, bool ctx, bool premapped)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	bool (*notify)(struct virtqueue *vq);
@@ -414,7 +414,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 
 	/* Create the vring */
 	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
-				 true, true, ctx, notify, callback, name);
+				 true, true, ctx, premapped, notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
@@ -492,6 +492,7 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		       vq_callback_t *callbacks[],
 		       const char * const names[],
 		       const bool *ctx,
+		       const bool *premapped,
 		       struct irq_affinity *desc)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
@@ -516,7 +517,8 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		}
 
 		vqs[i] = vm_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     ctx ? ctx[i] : false);
+				     ctx ? ctx[i] : false,
+				     premapped ? premapped[i] : false);
 		if (IS_ERR(vqs[i])) {
 			vm_del_vqs(vdev);
 			return PTR_ERR(vqs[i]);
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 1d21d1a1b3f5..9787b880e658 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -175,6 +175,7 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int in
 				     void (*callback)(struct virtqueue *vq),
 				     const char *name,
 				     bool ctx,
+				     bool premapped,
 				     u16 msix_vec)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -187,7 +188,7 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int in
 		return ERR_PTR(-ENOMEM);
 
 	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
-			      msix_vec);
+			      premapped, msix_vec);
 	if (IS_ERR(vq))
 		goto out_info;
 
@@ -285,6 +286,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
 		const char * const names[], bool per_vq_vectors,
 		const bool *ctx,
+		const bool *premapped,
 		struct irq_affinity *desc)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -327,6 +329,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 			msix_vec = VP_MSIX_VQ_VECTOR;
 		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
 				     ctx ? ctx[i] : false,
+				     premapped ? premapped[i] : false,
 				     msix_vec);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
@@ -357,7 +360,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 
 static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], const bool *ctx)
+		const char * const names[], const bool *ctx, const bool *premapped)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	int i, err, queue_idx = 0;
@@ -380,6 +383,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 		}
 		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
 				     ctx ? ctx[i] : false,
+				     premapped ? premapped[i] : false,
 				     VIRTIO_MSI_NO_VECTOR);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
@@ -397,23 +401,24 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
 		const char * const names[], const bool *ctx,
+		const bool *premapped,
 		struct irq_affinity *desc)
 {
 	int err;
 
 	/* Try MSI-X with one vector per queue. */
-	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, true, ctx, desc);
+	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, true, ctx, premapped, desc);
 	if (!err)
 		return 0;
 	/* Fallback: MSI-X with one vector for config, one shared for queues. */
-	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, false, ctx, desc);
+	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, false, ctx, premapped, desc);
 	if (!err)
 		return 0;
 	/* Is there an interrupt? If not give up. */
 	if (!(to_vp_device(vdev)->pci_dev->irq))
 		return err;
 	/* Finally fall back to regular interrupts. */
-	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, ctx);
+	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, ctx, premapped);
 }
 
 const char *vp_bus_name(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 4b773bd7c58c..3270bfcaa2ce 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -82,6 +82,7 @@ struct virtio_pci_device {
 				      void (*callback)(struct virtqueue *vq),
 				      const char *name,
 				      bool ctx,
+				      bool premapped,
 				      u16 msix_vec);
 	void (*del_vq)(struct virtio_pci_vq_info *info);
 
@@ -112,6 +113,7 @@ void vp_del_vqs(struct virtio_device *vdev);
 int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
 		const char * const names[], const bool *ctx,
+		const bool *premapped,
 		struct irq_affinity *desc);
 const char *vp_bus_name(struct virtio_device *vdev);
 
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index d9cbb02b35a1..3582fc1f61e2 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -113,6 +113,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  void (*callback)(struct virtqueue *vq),
 				  const char *name,
 				  bool ctx,
+				  bool premapped,
 				  u16 msix_vec)
 {
 	struct virtqueue *vq;
@@ -130,7 +131,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	/* create the vring */
 	vq = vring_create_virtqueue(index, num,
 				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
-				    true, false, ctx,
+				    true, false, ctx, premapped,
 				    vp_notify, callback, name);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index ee6a386d250b..f410ba3d531f 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -339,6 +339,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  void (*callback)(struct virtqueue *vq),
 				  const char *name,
 				  bool ctx,
+				  bool premapped,
 				  u16 msix_vec)
 {
 
@@ -366,7 +367,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	/* create the vring */
 	vq = vring_create_virtqueue(index, num,
 				    SMP_CACHE_BYTES, &vp_dev->vdev,
-				    true, true, ctx,
+				    true, true, ctx, premapped,
 				    notify, callback, name);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
@@ -394,11 +395,12 @@ static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 			      struct virtqueue *vqs[],
 			      vq_callback_t *callbacks[],
 			      const char * const names[], const bool *ctx,
+			      const bool *premapped,
 			      struct irq_affinity *desc)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtqueue *vq;
-	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc);
+	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, premapped, desc);
 
 	if (rc)
 		return rc;
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 05aa5ae4f932..11a131c22f7e 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -242,6 +242,7 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 					       struct virtio_device *vdev,
 					       bool weak_barriers,
 					       bool context,
+					       bool premapped,
 					       bool (*notify)(struct virtqueue *),
 					       void (*callback)(struct virtqueue *),
 					       const char *name,
@@ -1192,6 +1193,7 @@ static struct virtqueue *vring_create_virtqueue_split(
 	bool weak_barriers,
 	bool may_reduce_num,
 	bool context,
+	bool premapped,
 	bool (*notify)(struct virtqueue *),
 	void (*callback)(struct virtqueue *),
 	const char *name,
@@ -1207,7 +1209,7 @@ static struct virtqueue *vring_create_virtqueue_split(
 		return NULL;
 
 	vq = __vring_new_virtqueue(index, &vring_split, vdev, weak_barriers,
-				   context, notify, callback, name, dma_dev);
+				   context, premapped, notify, callback, name, dma_dev);
 	if (!vq) {
 		vring_free_split(&vring_split, vdev, dma_dev);
 		return NULL;
@@ -2121,6 +2123,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	bool weak_barriers,
 	bool may_reduce_num,
 	bool context,
+	bool premapped,
 	bool (*notify)(struct virtqueue *),
 	void (*callback)(struct virtqueue *),
 	const char *name,
@@ -2153,7 +2156,11 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->packed_ring = true;
 	vq->dma_dev = dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
-	vq->premapped = false;
+
+	if (premapped && vq->use_dma_api)
+		vq->premapped = true;
+	else
+		vq->premapped = false;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2668,6 +2675,7 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 					       struct virtio_device *vdev,
 					       bool weak_barriers,
 					       bool context,
+					       bool premapped,
 					       bool (*notify)(struct virtqueue *),
 					       void (*callback)(struct virtqueue *),
 					       const char *name,
@@ -2699,7 +2707,11 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 #endif
 	vq->dma_dev = dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
-	vq->premapped = false;
+
+	if (premapped && vq->use_dma_api)
+		vq->premapped = true;
+	else
+		vq->premapped = false;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2734,6 +2746,7 @@ struct virtqueue *vring_create_virtqueue(
 	bool weak_barriers,
 	bool may_reduce_num,
 	bool context,
+	bool premapped,
 	bool (*notify)(struct virtqueue *),
 	void (*callback)(struct virtqueue *),
 	const char *name)
@@ -2742,11 +2755,11 @@ struct virtqueue *vring_create_virtqueue(
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
 		return vring_create_virtqueue_packed(index, num, vring_align,
 				vdev, weak_barriers, may_reduce_num,
-				context, notify, callback, name, vdev->dev.parent);
+				context, premapped, notify, callback, name, vdev->dev.parent);
 
 	return vring_create_virtqueue_split(index, num, vring_align,
 			vdev, weak_barriers, may_reduce_num,
-			context, notify, callback, name, vdev->dev.parent);
+			context, premapped, notify, callback, name, vdev->dev.parent);
 }
 EXPORT_SYMBOL_GPL(vring_create_virtqueue);
 
@@ -2758,6 +2771,7 @@ struct virtqueue *vring_create_virtqueue_dma(
 	bool weak_barriers,
 	bool may_reduce_num,
 	bool context,
+	bool premapped,
 	bool (*notify)(struct virtqueue *),
 	void (*callback)(struct virtqueue *),
 	const char *name,
@@ -2767,11 +2781,11 @@ struct virtqueue *vring_create_virtqueue_dma(
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
 		return vring_create_virtqueue_packed(index, num, vring_align,
 				vdev, weak_barriers, may_reduce_num,
-				context, notify, callback, name, dma_dev);
+				context, premapped, notify, callback, name, dma_dev);
 
 	return vring_create_virtqueue_split(index, num, vring_align,
 			vdev, weak_barriers, may_reduce_num,
-			context, notify, callback, name, dma_dev);
+			context, premapped, notify, callback, name, dma_dev);
 }
 EXPORT_SYMBOL_GPL(vring_create_virtqueue_dma);
 
@@ -2923,6 +2937,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
 				      struct virtio_device *vdev,
 				      bool weak_barriers,
 				      bool context,
+				      bool premapped,
 				      void *pages,
 				      bool (*notify)(struct virtqueue *vq),
 				      void (*callback)(struct virtqueue *vq),
@@ -2935,7 +2950,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
 
 	vring_init(&vring_split.vring, num, pages, vring_align);
 	return __vring_new_virtqueue(index, &vring_split, vdev, weak_barriers,
-				     context, notify, callback, name,
+				     context, premapped, notify, callback, name,
 				     vdev->dev.parent);
 }
 EXPORT_SYMBOL_GPL(vring_new_virtqueue);
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 8d63e5923d24..87296dc5c8c4 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -358,6 +358,7 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 				vq_callback_t *callbacks[],
 				const char * const names[],
 				const bool *ctx,
+				const bool *premapped,
 				struct irq_affinity *desc)
 {
 	struct virtio_vdpa_device *vd_dev = to_virtio_vdpa_device(vdev);
@@ -382,8 +383,9 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		}
 
 		vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++,
-					      callbacks[i], names[i], ctx ?
-					      ctx[i] : false);
+					      callbacks[i], names[i],
+					      ctx ?  ctx[i] : false,
+					      premapped ?  premapped[i] : false);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto err_setup_vq;
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 2b3438de2c4d..45b5a980561e 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -57,6 +57,9 @@ typedef void vq_callback_t(struct virtqueue *);
  *		include a NULL entry for vqs that do not need a callback
  *	names: array of virtqueue names (mainly for debugging)
  *		include a NULL entry for vqs unused by driver
+ *	premapped: array of virtqueue premapped mode
+ *		virtio core will try to set the vq to premapped mode
+ *		The driver must check the premapped mode after find_vqs().
  *	Returns 0 on success or error status
  * @del_vqs: free virtqueues found by find_vqs().
  * @synchronize_cbs: synchronize with the virtqueue callbacks (optional)
@@ -106,6 +109,7 @@ struct virtio_config_ops {
 	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
 			struct virtqueue *vqs[], vq_callback_t *callbacks[],
 			const char * const names[], const bool *ctx,
+			const bool *premapped,
 			struct irq_affinity *desc);
 	void (*del_vqs)(struct virtio_device *);
 	void (*synchronize_cbs)(struct virtio_device *);
@@ -214,7 +218,7 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
 	const char *names[] = { n };
 	struct virtqueue *vq;
 	int err = vdev->config->find_vqs(vdev, 1, &vq, callbacks, names, NULL,
-					 NULL);
+					 NULL, NULL);
 	if (err < 0)
 		return ERR_PTR(err);
 	return vq;
@@ -226,7 +230,8 @@ int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			const char * const names[],
 			struct irq_affinity *desc)
 {
-	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
+	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL,
+				      NULL, desc);
 }
 
 static inline
@@ -236,7 +241,7 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
 			struct irq_affinity *desc)
 {
 	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
-				      desc);
+				      NULL, desc);
 }
 
 /**
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 9b33df741b63..91a6608d7001 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -73,6 +73,7 @@ struct virtqueue *vring_create_virtqueue(unsigned int index,
 					 bool weak_barriers,
 					 bool may_reduce_num,
 					 bool ctx,
+					 bool premapped,
 					 bool (*notify)(struct virtqueue *vq),
 					 void (*callback)(struct virtqueue *vq),
 					 const char *name);
@@ -88,6 +89,7 @@ struct virtqueue *vring_create_virtqueue_dma(unsigned int index,
 					     bool weak_barriers,
 					     bool may_reduce_num,
 					     bool ctx,
+					     bool premapped,
 					     bool (*notify)(struct virtqueue *vq),
 					     void (*callback)(struct virtqueue *vq),
 					     const char *name,
@@ -103,6 +105,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
 				      struct virtio_device *vdev,
 				      bool weak_barriers,
 				      bool ctx,
+				      bool premapped,
 				      void *pages,
 				      bool (*notify)(struct virtqueue *vq),
 				      void (*callback)(struct virtqueue *vq),
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index 5d3440f474dd..dbbb426ed44d 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -63,6 +63,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
 				      struct virtio_device *vdev,
 				      bool weak_barriers,
 				      bool ctx,
+				      bool premapped,
 				      void *pages,
 				      bool (*notify)(struct virtqueue *vq),
 				      void (*callback)(struct virtqueue *vq),
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 028f54e6854a..f7bbf5bf580a 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -102,7 +102,7 @@ static void vq_reset(struct vq_info *info, int num, struct virtio_device *vdev)
 
 	memset(info->ring, 0, vring_size(num, 4096));
 	vring_init(&info->vring, num, info->ring, 4096);
-	info->vq = vring_new_virtqueue(info->idx, num, 4096, vdev, true, false,
+	info->vq = vring_new_virtqueue(info->idx, num, 4096, vdev, true, false, false,
 				       info->ring, vq_notify, vq_callback, "test");
 	assert(info->vq);
 	info->vq->priv = info;
diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index 98ff808d6f0c..84f50bd115e0 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -317,7 +317,7 @@ static int parallel_test(u64 features,
 			err(1, "Could not set affinity to cpu %u", first_cpu);
 
 		vq = vring_new_virtqueue(0, RINGSIZE, ALIGN, &gvdev.vdev, true,
-					 false, guest_map,
+					 false, false, guest_map,
 					 fast_vringh ? no_notify_host
 					 : parallel_notify_host,
 					 never_callback_guest, "guest vq");
@@ -391,7 +391,7 @@ static int parallel_test(u64 features,
 				/* Swallow all notifies at once. */
 				if (read(to_guest[0], buf, sizeof(buf)) < 1)
 					break;
-				
+
 				receives++;
 				virtqueue_disable_cb(vq);
 				continue;
@@ -424,7 +424,7 @@ static int parallel_test(u64 features,
 				continue;
 			if (read(to_guest[0], buf, sizeof(buf)) < 1)
 				break;
-				
+
 			receives++;
 			virtqueue_disable_cb(vq);
 		}
@@ -485,7 +485,7 @@ int main(int argc, char *argv[])
 	memset(__user_addr_min, 0, vring_size(RINGSIZE, ALIGN));
 
 	/* Set up guest side. */
-	vq = vring_new_virtqueue(0, RINGSIZE, ALIGN, &vdev, true, false,
+	vq = vring_new_virtqueue(0, RINGSIZE, ALIGN, &vdev, true, false, false,
 				 __user_addr_min,
 				 never_notify_host, never_callback_guest,
 				 "guest vq");
@@ -669,7 +669,7 @@ int main(int argc, char *argv[])
 		/* Force creation of direct, which we modify. */
 		__virtio_clear_bit(&vdev, VIRTIO_RING_F_INDIRECT_DESC);
 		vq = vring_new_virtqueue(0, RINGSIZE, ALIGN, &vdev, true,
-					 false, __user_addr_min,
+					 false, false, __user_addr_min,
 					 never_notify_host,
 					 never_callback_guest,
 					 "guest vq");
-- 
2.32.0.3.g01195cf9f


