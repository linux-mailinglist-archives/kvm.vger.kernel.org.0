Return-Path: <kvm+bounces-7836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C639F846C8E
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 10:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CB46286FF4
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 09:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4637F48C;
	Fri,  2 Feb 2024 09:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Ue7FoB3V"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D198E79DCE;
	Fri,  2 Feb 2024 09:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706866819; cv=none; b=tAIVLj7imuUurEm+uBcwxginfH8I9ACxfs82KnRJc3s+1pUzikc5KzAuhTlDX1kttraH5g7r2uwmDUvzAQMg0TIVNwvT5fKIdKKJHz9xA6tx+vpmgs74e8BLgK1rcY75sQg41nHCYFTUcJ+3OU0v5W5nNS+YmlxcCBkqLC+aYEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706866819; c=relaxed/simple;
	bh=q/6d3RC4sJxkQMxwUJlcLUJhzjvCLEvWDKtBhGX9u0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aMKodVtvsmMF9p7EQ9ifEfSBbZoYS8+S/Df/ZpiYQ+xn+HW075oer1Gls+R8us2aZsOI79Tw0tOp52PRM05OgkiTNmr9HhWOczeuy9dp6yF0p74nuzav5dntO7FRPOwLpnh52m9mM9yUVWHR7q7XH/HnEo9brOkQxsMzEGN6dt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Ue7FoB3V; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706866808; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=whbQg9Hj72zpDvqZeylc7jKFj78AxwcTEDHqvHIwr+w=;
	b=Ue7FoB3V5O0W+s6VmBUJo9WXB5Bg8P4sUSJ06VO9svaR4qC48mwAdlPpPBDvcmASIQRL1dExByCIZHzZQ/EZtzR02Mc3XfQr4EgCvbuDd3LoNgJCZ8/WEXQzx7DKSm4uzp50xeNVOroz+kGK3VHFx0CES0R72p/YQb7CzdOQKPI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.wbNCH_1706866803;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.wbNCH_1706866803)
          by smtp.aliyun-inc.com;
          Fri, 02 Feb 2024 17:40:04 +0800
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
	linux-um@lists.infradead.org,
	netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH vhost v1 07/19] virtio: find_vqs: pass struct instead of multi parameters
Date: Fri,  2 Feb 2024 17:39:39 +0800
Message-Id: <20240202093951.120283-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240202093951.120283-1-xuanzhuo@linux.alibaba.com>
References: <20240202093951.120283-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 4c7bacd05cb8
Content-Transfer-Encoding: 8bit

Now, we pass multi parameters to find_vqs. These parameters
may work for transport or work for vring.

And find_vqs has multi implements in many places:

But every time,
 arch/um/drivers/virtio_uml.c
 drivers/platform/mellanox/mlxbf-tmfifo.c
 drivers/remoteproc/remoteproc_virtio.c
 drivers/s390/virtio/virtio_ccw.c
 drivers/virtio/virtio_mmio.c
 drivers/virtio/virtio_pci_legacy.c
 drivers/virtio/virtio_pci_modern.c
 drivers/virtio/virtio_vdpa.c

Every time, we try to add a new parameter, that is difficult.
We must change every find_vqs implement.

One the other side, if we want to pass a parameter to vring,
we must change the call path from transport to vring.
Too many functions need to be changed.

So it is time to refactor the find_vqs. We pass a structure
cfg to find_vqs(), that will be passed to vring by transport.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 arch/um/drivers/virtio_uml.c             | 23 ++++-----
 drivers/platform/mellanox/mlxbf-tmfifo.c | 13 ++----
 drivers/remoteproc/remoteproc_virtio.c   | 28 ++++++-----
 drivers/s390/virtio/virtio_ccw.c         | 29 ++++++------
 drivers/virtio/virtio_mmio.c             | 26 +++++------
 drivers/virtio/virtio_pci_common.c       | 59 +++++++++++-------------
 drivers/virtio/virtio_pci_common.h       |  9 +---
 drivers/virtio/virtio_pci_legacy.c       | 11 +++--
 drivers/virtio/virtio_pci_modern.c       | 19 ++++----
 drivers/virtio/virtio_vdpa.c             | 36 +++++++--------
 include/linux/virtio_config.h            | 51 ++++++++++++++++----
 11 files changed, 160 insertions(+), 144 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 8adca2000e51..c13dfeeb90c4 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -937,8 +937,8 @@ static int vu_setup_vq_call_fd(struct virtio_uml_device *vu_dev,
 }
 
 static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
-				     unsigned index, vq_callback_t *callback,
-				     const char *name, bool ctx)
+				     unsigned index,
+				     struct virtio_vq_config *cfg)
 {
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
 	struct platform_device *pdev = vu_dev->pdev;
@@ -953,10 +953,12 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
 		goto error_kzalloc;
 	}
 	snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
-		 pdev->id, name);
+		 pdev->id, cfg->names[cfg->cfg_idx]);
 
 	vq = vring_create_virtqueue(index, num, PAGE_SIZE, vdev, true, true,
-				    ctx, vu_notify, callback, info->name);
+				    cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false,
+				    vu_notify,
+				    cfg->callbacks[cfg->cfg_idx], info->name);
 	if (!vq) {
 		rc = -ENOMEM;
 		goto error_create;
@@ -1013,12 +1015,11 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
 	return ERR_PTR(rc);
 }
 
-static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
-		       struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		       const char * const names[], const bool *ctx,
-		       struct irq_affinity *desc)
+static int vu_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *cfg)
 {
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
+	struct virtqueue **vqs = cfg->vqs;
+	unsigned int nvqs = cfg->nvqs;
 	int i, queue_idx = 0, rc;
 	struct virtqueue *vq;
 
@@ -1031,13 +1032,13 @@ static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		return rc;
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
+		if (!cfg->names[i]) {
 			vqs[i] = NULL;
 			continue;
 		}
 
-		vqs[i] = vu_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     ctx ? ctx[i] : false);
+		cfg->cfg_idx = i;
+		vqs[i] = vu_setup_vq(vdev, queue_idx++, cfg);
 		if (IS_ERR(vqs[i])) {
 			rc = PTR_ERR(vqs[i]);
 			goto error_setup;
diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 5c683b4eaf10..a90d5da6200a 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -989,15 +989,12 @@ static void mlxbf_tmfifo_virtio_del_vqs(struct virtio_device *vdev)
 
 /* Create and initialize the virtual queues. */
 static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
-					unsigned int nvqs,
-					struct virtqueue *vqs[],
-					vq_callback_t *callbacks[],
-					const char * const names[],
-					const bool *ctx,
-					struct irq_affinity *desc)
+					struct virtio_vq_config *cfg)
 {
 	struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
+	struct virtqueue **vqs = cfg->vqs;
 	struct mlxbf_tmfifo_vring *vring;
+	unsigned int nvqs = cfg->nvqs;
 	struct virtqueue *vq;
 	int i, ret, size;
 
@@ -1005,7 +1002,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
 		return -EINVAL;
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
+		if (!cfg->names[i]) {
 			ret = -EINVAL;
 			goto error;
 		}
@@ -1017,7 +1014,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
 		vq = vring_new_virtqueue(i, vring->num, vring->align, vdev,
 					 false, false, vring->va,
 					 mlxbf_tmfifo_virtio_notify,
-					 callbacks[i], names[i]);
+					 cfg->callbacks[i], cfg->names[i]);
 		if (!vq) {
 			dev_err(&vdev->dev, "vring_new_virtqueue failed\n");
 			ret = -ENOMEM;
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 83d76915a6ad..57d51c9c7b63 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -102,8 +102,7 @@ EXPORT_SYMBOL(rproc_vq_interrupt);
 
 static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 				    unsigned int id,
-				    void (*callback)(struct virtqueue *vq),
-				    const char *name, bool ctx)
+				    struct virtio_vq_config *cfg)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct rproc *rproc = vdev_to_rproc(vdev);
@@ -119,7 +118,7 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	if (id >= ARRAY_SIZE(rvdev->vring))
 		return ERR_PTR(-EINVAL);
 
-	if (!name)
+	if (!cfg->names[cfg->cfg_idx])
 		return NULL;
 
 	/* Search allocated memory region by name */
@@ -143,10 +142,12 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	 * Create the new vq, and tell virtio we're not interested in
 	 * the 'weak' smp barriers, since we're talking with a real device.
 	 */
-	vq = vring_new_virtqueue(id, num, rvring->align, vdev, false, ctx,
-				 addr, rproc_virtio_notify, callback, name);
+	vq = vring_new_virtqueue(id, num, rvring->align, vdev, false,
+				 cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false,
+				 addr, rproc_virtio_notify, cfg->callbacks[cfg->cfg_idx],
+				 cfg->names[cfg->cfg_idx]);
 	if (!vq) {
-		dev_err(dev, "vring_new_virtqueue %s failed\n", name);
+		dev_err(dev, "vring_new_virtqueue %s failed\n", cfg->names[cfg->cfg_idx]);
 		rproc_free_vring(rvring);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -180,23 +181,20 @@ static void rproc_virtio_del_vqs(struct virtio_device *vdev)
 	__rproc_virtio_del_vqs(vdev);
 }
 
-static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
-				 struct virtqueue *vqs[],
-				 vq_callback_t *callbacks[],
-				 const char * const names[],
-				 const bool * ctx,
-				 struct irq_affinity *desc)
+static int rproc_virtio_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *cfg)
 {
+	struct virtqueue **vqs = cfg->vqs;
+	unsigned int nvqs = cfg->nvqs;
 	int i, ret, queue_idx = 0;
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
+		if (!cfg->names[i]) {
 			vqs[i] = NULL;
 			continue;
 		}
 
-		vqs[i] = rp_find_vq(vdev, queue_idx++, callbacks[i], names[i],
-				    ctx ? ctx[i] : false);
+		cfg->cfg_idx = i;
+		vqs[i] = rp_find_vq(vdev, queue_idx++, cfg);
 		if (IS_ERR(vqs[i])) {
 			ret = PTR_ERR(vqs[i]);
 			goto error;
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index ac67576301bf..11eea5086cff 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -499,9 +499,8 @@ static void virtio_ccw_del_vqs(struct virtio_device *vdev)
 }
 
 static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
-					     int i, vq_callback_t *callback,
-					     const char *name, bool ctx,
-					     struct ccw1 *ccw)
+					     int i, struct ccw1 *ccw,
+					     struct virtio_vq_config *cfg)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	bool (*notify)(struct virtqueue *vq);
@@ -538,8 +537,11 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	}
 	may_reduce = vcdev->revision > 0;
 	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
-				    vdev, true, may_reduce, ctx,
-				    notify, callback, name);
+				    vdev, true, may_reduce,
+				    cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false,
+				    notify,
+				    cfg->callbacks[cfg->cfg_idx],
+				    cfg->names[cfg->cfg_idx]);
 
 	if (!vq) {
 		/* For now, we fail if we can't get the requested size. */
@@ -650,15 +652,13 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 	return ret;
 }
 
-static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
-			       struct virtqueue *vqs[],
-			       vq_callback_t *callbacks[],
-			       const char * const names[],
-			       const bool *ctx,
-			       struct irq_affinity *desc)
+static int virtio_ccw_find_vqs(struct virtio_device *vdev,
+			       struct virtio_vq_config *cfg)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+	struct virtqueue **vqs = cfg->vqs;
 	unsigned long *indicatorp = NULL;
+	unsigned int nvqs = cfg->nvqs;
 	int ret, i, queue_idx = 0;
 	struct ccw1 *ccw;
 
@@ -667,14 +667,13 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		return -ENOMEM;
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
+		if (!cfg->names[i]) {
 			vqs[i] = NULL;
 			continue;
 		}
 
-		vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, callbacks[i],
-					     names[i], ctx ? ctx[i] : false,
-					     ccw);
+		cfg->cfg_idx = i;
+		vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, ccw, cfg);
 		if (IS_ERR(vqs[i])) {
 			ret = PTR_ERR(vqs[i]);
 			vqs[i] = NULL;
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 59892a31cf76..feb823d279d2 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -370,8 +370,7 @@ static void vm_synchronize_cbs(struct virtio_device *vdev)
 }
 
 static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int index,
-				  void (*callback)(struct virtqueue *vq),
-				  const char *name, bool ctx)
+				     struct virtio_vq_config *cfg)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	bool (*notify)(struct virtqueue *vq);
@@ -386,7 +385,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 	else
 		notify = vm_notify;
 
-	if (!name)
+	if (!cfg->names[index])
 		return NULL;
 
 	/* Select the queue we're interested in */
@@ -414,7 +413,11 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 
 	/* Create the vring */
 	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
-				 true, true, ctx, notify, callback, name);
+				 true, true,
+				 cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false,
+				 notify,
+				 cfg->callbacks[cfg->cfg_idx],
+				 cfg->names[cfg->cfg_idx]);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
@@ -487,15 +490,12 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 	return ERR_PTR(err);
 }
 
-static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
-		       struct virtqueue *vqs[],
-		       vq_callback_t *callbacks[],
-		       const char * const names[],
-		       const bool *ctx,
-		       struct irq_affinity *desc)
+static int vm_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *cfg)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	int irq = platform_get_irq(vm_dev->pdev, 0);
+	struct virtqueue **vqs = cfg->vqs;
+	unsigned int nvqs = cfg->nvqs;
 	int i, err, queue_idx = 0;
 
 	if (irq < 0)
@@ -510,13 +510,13 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		enable_irq_wake(irq);
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
+		if (!cfg->names[i]) {
 			vqs[i] = NULL;
 			continue;
 		}
 
-		vqs[i] = vm_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     ctx ? ctx[i] : false);
+		cfg->cfg_idx = i;
+		vqs[i] = vm_setup_vq(vdev, queue_idx++, cfg);
 		if (IS_ERR(vqs[i])) {
 			vm_del_vqs(vdev);
 			return PTR_ERR(vqs[i]);
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 1d21d1a1b3f5..0ebee2b53eed 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -172,9 +172,7 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 }
 
 static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int index,
-				     void (*callback)(struct virtqueue *vq),
-				     const char *name,
-				     bool ctx,
+				     struct virtio_vq_config *cfg,
 				     u16 msix_vec)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -186,13 +184,13 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int in
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
-	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
+	vq = vp_dev->setup_vq(vp_dev, info, index, cfg,
 			      msix_vec);
 	if (IS_ERR(vq))
 		goto out_info;
 
 	info->vq = vq;
-	if (callback) {
+	if (cfg->callbacks[cfg->cfg_idx]) {
 		spin_lock_irqsave(&vp_dev->lock, flags);
 		list_add(&info->node, &vp_dev->virtqueues);
 		spin_unlock_irqrestore(&vp_dev->lock, flags);
@@ -281,15 +279,15 @@ void vp_del_vqs(struct virtio_device *vdev)
 	vp_dev->vqs = NULL;
 }
 
-static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
-		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], bool per_vq_vectors,
-		const bool *ctx,
-		struct irq_affinity *desc)
+static int vp_find_vqs_msix(struct virtio_device *vdev,
+			    struct virtio_vq_config *cfg,
+			    bool per_vq_vectors)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	u16 msix_vec;
 	int i, err, nvectors, allocated_vectors, queue_idx = 0;
+	struct virtqueue **vqs = cfg->vqs;
+	unsigned int nvqs = cfg->nvqs;
 
 	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
 	if (!vp_dev->vqs)
@@ -299,7 +297,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 		/* Best option: one for change interrupt, one per vq. */
 		nvectors = 1;
 		for (i = 0; i < nvqs; ++i)
-			if (names[i] && callbacks[i])
+			if (cfg->names[i] && cfg->callbacks[i])
 				++nvectors;
 	} else {
 		/* Second best: one for change, shared for all vqs. */
@@ -307,27 +305,27 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 	}
 
 	err = vp_request_msix_vectors(vdev, nvectors, per_vq_vectors,
-				      per_vq_vectors ? desc : NULL);
+				      per_vq_vectors ? cfg->desc : NULL);
 	if (err)
 		goto error_find;
 
 	vp_dev->per_vq_vectors = per_vq_vectors;
 	allocated_vectors = vp_dev->msix_used_vectors;
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
+		if (!cfg->names[i]) {
 			vqs[i] = NULL;
 			continue;
 		}
 
-		if (!callbacks[i])
+		if (!cfg->callbacks[i])
 			msix_vec = VIRTIO_MSI_NO_VECTOR;
 		else if (vp_dev->per_vq_vectors)
 			msix_vec = allocated_vectors++;
 		else
 			msix_vec = VP_MSIX_VQ_VECTOR;
-		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     ctx ? ctx[i] : false,
-				     msix_vec);
+
+		cfg->cfg_idx = i;
+		vqs[i] = vp_setup_vq(vdev, queue_idx++, cfg, msix_vec);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto error_find;
@@ -340,7 +338,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 		snprintf(vp_dev->msix_names[msix_vec],
 			 sizeof *vp_dev->msix_names,
 			 "%s-%s",
-			 dev_name(&vp_dev->vdev.dev), names[i]);
+			 dev_name(&vp_dev->vdev.dev), cfg->names[i]);
 		err = request_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec),
 				  vring_interrupt, 0,
 				  vp_dev->msix_names[msix_vec],
@@ -355,11 +353,11 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 	return err;
 }
 
-static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
-		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], const bool *ctx)
+static int vp_find_vqs_intx(struct virtio_device *vdev, struct virtio_vq_config *cfg)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtqueue **vqs = cfg->vqs;
+	unsigned int nvqs = cfg->nvqs;
 	int i, err, queue_idx = 0;
 
 	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
@@ -374,13 +372,13 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 	vp_dev->intx_enabled = 1;
 	vp_dev->per_vq_vectors = false;
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
+		if (!cfg->names[i]) {
 			vqs[i] = NULL;
 			continue;
 		}
-		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     ctx ? ctx[i] : false,
-				     VIRTIO_MSI_NO_VECTOR);
+
+		cfg->cfg_idx = i;
+		vqs[i] = vp_setup_vq(vdev, queue_idx++, cfg, VIRTIO_MSI_NO_VECTOR);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto out_del_vqs;
@@ -394,26 +392,23 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 }
 
 /* the config->find_vqs() implementation */
-int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
-		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], const bool *ctx,
-		struct irq_affinity *desc)
+int vp_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *cfg)
 {
 	int err;
 
 	/* Try MSI-X with one vector per queue. */
-	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, true, ctx, desc);
+	err = vp_find_vqs_msix(vdev, cfg, true);
 	if (!err)
 		return 0;
 	/* Fallback: MSI-X with one vector for config, one shared for queues. */
-	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, false, ctx, desc);
+	err = vp_find_vqs_msix(vdev, cfg, false);
 	if (!err)
 		return 0;
 	/* Is there an interrupt? If not give up. */
 	if (!(to_vp_device(vdev)->pci_dev->irq))
 		return err;
 	/* Finally fall back to regular interrupts. */
-	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, ctx);
+	return vp_find_vqs_intx(vdev, cfg);
 }
 
 const char *vp_bus_name(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 4b773bd7c58c..12b171364e54 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -79,9 +79,7 @@ struct virtio_pci_device {
 	struct virtqueue *(*setup_vq)(struct virtio_pci_device *vp_dev,
 				      struct virtio_pci_vq_info *info,
 				      unsigned int idx,
-				      void (*callback)(struct virtqueue *vq),
-				      const char *name,
-				      bool ctx,
+				      struct virtio_vq_config *vq_cfg,
 				      u16 msix_vec);
 	void (*del_vq)(struct virtio_pci_vq_info *info);
 
@@ -109,10 +107,7 @@ bool vp_notify(struct virtqueue *vq);
 /* the config->del_vqs() implementation */
 void vp_del_vqs(struct virtio_device *vdev);
 /* the config->find_vqs() implementation */
-int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
-		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], const bool *ctx,
-		struct irq_affinity *desc);
+int vp_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *cfg);
 const char *vp_bus_name(struct virtio_device *vdev);
 
 /* Setup the affinity for a virtqueue:
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index d9cbb02b35a1..e8d22fce32f5 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -110,9 +110,7 @@ static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
 static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  struct virtio_pci_vq_info *info,
 				  unsigned int index,
-				  void (*callback)(struct virtqueue *vq),
-				  const char *name,
-				  bool ctx,
+				  struct virtio_vq_config *cfg,
 				  u16 msix_vec)
 {
 	struct virtqueue *vq;
@@ -130,8 +128,11 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	/* create the vring */
 	vq = vring_create_virtqueue(index, num,
 				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
-				    true, false, ctx,
-				    vp_notify, callback, name);
+				    true, false,
+				    cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false,
+				    vp_notify,
+				    cfg->callbacks[cfg->cfg_idx],
+				    cfg->names[cfg->cfg_idx]);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index ee6a386d250b..b23792a26584 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -336,9 +336,7 @@ static bool vp_notify_with_data(struct virtqueue *vq)
 static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  struct virtio_pci_vq_info *info,
 				  unsigned int index,
-				  void (*callback)(struct virtqueue *vq),
-				  const char *name,
-				  bool ctx,
+				  struct virtio_vq_config *cfg,
 				  u16 msix_vec)
 {
 
@@ -366,8 +364,11 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	/* create the vring */
 	vq = vring_create_virtqueue(index, num,
 				    SMP_CACHE_BYTES, &vp_dev->vdev,
-				    true, true, ctx,
-				    notify, callback, name);
+				    true, true,
+				    cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false,
+				    notify,
+				    cfg->callbacks[cfg->cfg_idx],
+				    cfg->names[cfg->cfg_idx]);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
@@ -390,15 +391,11 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	return ERR_PTR(err);
 }
 
-static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
-			      struct virtqueue *vqs[],
-			      vq_callback_t *callbacks[],
-			      const char * const names[], const bool *ctx,
-			      struct irq_affinity *desc)
+static int vp_modern_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *cfg)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtqueue *vq;
-	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc);
+	int rc = vp_find_vqs(vdev, cfg);
 
 	if (rc)
 		return rc;
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 8d63e5923d24..4f26b0422797 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -142,8 +142,7 @@ static irqreturn_t virtio_vdpa_virtqueue_cb(void *private)
 
 static struct virtqueue *
 virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
-		     void (*callback)(struct virtqueue *vq),
-		     const char *name, bool ctx)
+		     struct virtio_vq_config *cfg)
 {
 	struct virtio_vdpa_device *vd_dev = to_virtio_vdpa_device(vdev);
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
@@ -161,7 +160,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	bool may_reduce_num = true;
 	int err;
 
-	if (!name)
+	if (!cfg->names[cfg->cfg_idx])
 		return NULL;
 
 	if (index >= vdpa->nvqs)
@@ -203,8 +202,12 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	else
 		dma_dev = vdpa_get_dma_dev(vdpa);
 	vq = vring_create_virtqueue_dma(index, max_num, align, vdev,
-					true, may_reduce_num, ctx,
-					notify, callback, name, dma_dev);
+					true, may_reduce_num,
+					cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false,
+					notify,
+					cfg->callbacks[cfg->cfg_idx],
+					cfg->names[cfg->cfg_idx],
+					dma_dev);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
@@ -213,7 +216,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	vq->num_max = max_num;
 
 	/* Setup virtqueue callback */
-	cb.callback = callback ? virtio_vdpa_virtqueue_cb : NULL;
+	cb.callback = cfg->callbacks[cfg->cfg_idx] ? virtio_vdpa_virtqueue_cb : NULL;
 	cb.private = info;
 	cb.trigger = NULL;
 	ops->set_vq_cb(vdpa, index, &cb);
@@ -353,12 +356,8 @@ create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 	return masks;
 }
 
-static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
-				struct virtqueue *vqs[],
-				vq_callback_t *callbacks[],
-				const char * const names[],
-				const bool *ctx,
-				struct irq_affinity *desc)
+static int virtio_vdpa_find_vqs(struct virtio_device *vdev,
+				struct virtio_vq_config *cfg)
 {
 	struct virtio_vdpa_device *vd_dev = to_virtio_vdpa_device(vdev);
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
@@ -366,24 +365,25 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 	struct irq_affinity default_affd = { 0 };
 	struct cpumask *masks;
 	struct vdpa_callback cb;
-	bool has_affinity = desc && ops->set_vq_affinity;
+	bool has_affinity = cfg->desc && ops->set_vq_affinity;
+	struct virtqueue **vqs = cfg->vqs;
+	unsigned int nvqs = cfg->nvqs;
 	int i, err, queue_idx = 0;
 
 	if (has_affinity) {
-		masks = create_affinity_masks(nvqs, desc ? desc : &default_affd);
+		masks = create_affinity_masks(nvqs, cfg->desc ? cfg->desc : &default_affd);
 		if (!masks)
 			return -ENOMEM;
 	}
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
+		if (!cfg->names[i]) {
 			vqs[i] = NULL;
 			continue;
 		}
 
-		vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++,
-					      callbacks[i], names[i], ctx ?
-					      ctx[i] : false);
+		cfg->cfg_idx = i;
+		vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++, cfg);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto err_setup_vq;
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 2b3438de2c4d..e2c72e125dae 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -94,6 +94,20 @@ typedef void vq_callback_t(struct virtqueue *);
  *	If disable_vq_and_reset is set, then enable_vq_after_reset must also be
  *	set.
  */
+
+struct virtio_vq_config {
+	unsigned int nvqs;
+
+	/* the vq index may not eq to the cfg index of the other array items */
+	unsigned int cfg_idx;
+
+	struct virtqueue **vqs;
+	vq_callback_t **callbacks;
+	const char *const *names;
+	const bool *ctx;
+	struct irq_affinity *desc;
+};
+
 struct virtio_config_ops {
 	void (*get)(struct virtio_device *vdev, unsigned offset,
 		    void *buf, unsigned len);
@@ -103,10 +117,7 @@ struct virtio_config_ops {
 	u8 (*get_status)(struct virtio_device *vdev);
 	void (*set_status)(struct virtio_device *vdev, u8 status);
 	void (*reset)(struct virtio_device *vdev);
-	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
-			struct virtqueue *vqs[], vq_callback_t *callbacks[],
-			const char * const names[], const bool *ctx,
-			struct irq_affinity *desc);
+	int (*find_vqs)(struct virtio_device *vdev, struct virtio_vq_config *cfg);
 	void (*del_vqs)(struct virtio_device *);
 	void (*synchronize_cbs)(struct virtio_device *);
 	u64 (*get_features)(struct virtio_device *vdev);
@@ -213,8 +224,14 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
 	vq_callback_t *callbacks[] = { c };
 	const char *names[] = { n };
 	struct virtqueue *vq;
-	int err = vdev->config->find_vqs(vdev, 1, &vq, callbacks, names, NULL,
-					 NULL);
+	struct virtio_vq_config cfg = {};
+
+	cfg.nvqs = 1;
+	cfg.vqs = &vq;
+	cfg.callbacks = callbacks;
+	cfg.names = names;
+
+	int err = vdev->config->find_vqs(vdev, &cfg);
 	if (err < 0)
 		return ERR_PTR(err);
 	return vq;
@@ -226,7 +243,15 @@ int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			const char * const names[],
 			struct irq_affinity *desc)
 {
-	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
+	struct virtio_vq_config cfg = {};
+
+	cfg.nvqs = nvqs;
+	cfg.vqs = vqs;
+	cfg.callbacks = callbacks;
+	cfg.names = names;
+	cfg.desc = desc;
+
+	return vdev->config->find_vqs(vdev, &cfg);
 }
 
 static inline
@@ -235,8 +260,16 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
 			const char * const names[], const bool *ctx,
 			struct irq_affinity *desc)
 {
-	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
-				      desc);
+	struct virtio_vq_config cfg = {};
+
+	cfg.nvqs = nvqs;
+	cfg.vqs = vqs;
+	cfg.callbacks = callbacks;
+	cfg.names = names;
+	cfg.ctx = ctx;
+	cfg.desc = desc;
+
+	return vdev->config->find_vqs(vdev, &cfg);
 }
 
 /**
-- 
2.32.0.3.g01195cf9f


