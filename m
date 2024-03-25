Return-Path: <kvm+bounces-12574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3F4388A301
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:50:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E719D1C39991
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B19F16D32B;
	Mon, 25 Mar 2024 10:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="APSgykyD"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B8913D8B1;
	Mon, 25 Mar 2024 09:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711357469; cv=none; b=vGfLV0xIqGtCfW7rIxn/mOCwP+ROHtvSWGccgj5v5V4v4J0fwkj1GtJ6MR6fKePhtHt+efNJpklK1K1Gna34xh3KmYD5G1v6LrNRdDyvaDcfwrtMeHOFzufp7hb/azDZuXKKUzJ1V8uzL8qKwUVU+lb99M29C80KEHXCCBA8H+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711357469; c=relaxed/simple;
	bh=AnL7A7hGubvxOfx0CIISEw1xAUL+j29/ID30DhDtmPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KU0La6sP9MyMZrVwaSZOVr9JtdSFR1Ml83BijxecXn0jWNi2E7b81gwE5C0ME8zhndD3WcBpMul2cH8Fl6SRq396WssBZpVSFaYLvaspNHYiUFgpHe6utP+7GtIycZQitk1CrbNmXGdVONIlyQADTI3Ua9JXNNgoSQSA9KeqFTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=APSgykyD; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711357465; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=JG20w7ybJ7RY38XLEtP4gguf6EE2tsVwqebAHrWoXys=;
	b=APSgykyD3duMLkL8o10CXv3WY0EN+t1uaJirJggaCLW1ZFUJbQn1Fdpj7OneDfZNZMX2eRIfHoqIebhY/vxGhlmFc130DOJnxMPPYuPYSwycoSieNgKgp8qFQswRpW6Eeb5vGvOzkgGxld+XtPDyytXdc2ywzEdU8MJpDFtcAyc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0W3DYllR_1711357462;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W3DYllR_1711357462)
          by smtp.aliyun-inc.com;
          Mon, 25 Mar 2024 17:04:23 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
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
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH vhost v5 2/6] virtio: remove support for names array entries being null.
Date: Mon, 25 Mar 2024 17:04:15 +0800
Message-Id: <20240325090419.33677-3-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240325090419.33677-1-xuanzhuo@linux.alibaba.com>
References: <20240325090419.33677-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: f38b33f54e32
Content-Transfer-Encoding: 8bit

commit 6457f126c888 ("virtio: support reserved vqs") introduced this
support. Multiqueue virtio-net use 2N as ctrl vq finally, so the logic
doesn't apply. And not one uses this.

On the other side, that makes some trouble for us to refactor the
find_vqs() params.

So I remove this support.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 arch/um/drivers/virtio_uml.c             | 5 -----
 drivers/platform/mellanox/mlxbf-tmfifo.c | 4 ----
 drivers/remoteproc/remoteproc_virtio.c   | 5 -----
 drivers/s390/virtio/virtio_ccw.c         | 5 -----
 drivers/virtio/virtio_mmio.c             | 5 -----
 drivers/virtio/virtio_pci_common.c       | 9 ---------
 drivers/virtio/virtio_vdpa.c             | 5 -----
 include/linux/virtio_config.h            | 1 -
 8 files changed, 39 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 8adca2000e51..1d1e8654b7fc 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1031,11 +1031,6 @@ static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		return rc;
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
-			vqs[i] = NULL;
-			continue;
-		}
-
 		vqs[i] = vu_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
 				     ctx ? ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index b8d1e32e97eb..f4639331f32e 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -1072,10 +1072,6 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
 		return -EINVAL;
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
-			ret = -EINVAL;
-			goto error;
-		}
 		vring = &tm_vdev->vrings[i];
 
 		/* zero vring */
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 83d76915a6ad..cd71827d67af 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -190,11 +190,6 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 	int i, ret, queue_idx = 0;
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
-			vqs[i] = NULL;
-			continue;
-		}
-
 		vqs[i] = rp_find_vq(vdev, queue_idx++, callbacks[i], names[i],
 				    ctx ? ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index ac67576301bf..773f16c294d9 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -667,11 +667,6 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		return -ENOMEM;
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
-			vqs[i] = NULL;
-			continue;
-		}
-
 		vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, callbacks[i],
 					     names[i], ctx ? ctx[i] : false,
 					     ccw);
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 59892a31cf76..a95c98cca63e 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -510,11 +510,6 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		enable_irq_wake(irq);
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
-			vqs[i] = NULL;
-			continue;
-		}
-
 		vqs[i] = vm_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
 				     ctx ? ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index b655fccaf773..783758672ef9 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -317,11 +317,6 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 	vp_dev->per_vq_vectors = per_vq_vectors;
 	allocated_vectors = vp_dev->msix_used_vectors;
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
-			vqs[i] = NULL;
-			continue;
-		}
-
 		if (!callbacks[i])
 			msix_vec = VIRTIO_MSI_NO_VECTOR;
 		else if (vp_dev->per_vq_vectors)
@@ -377,10 +372,6 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 	vp_dev->intx_enabled = 1;
 	vp_dev->per_vq_vectors = false;
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
-			vqs[i] = NULL;
-			continue;
-		}
 		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
 				     ctx ? ctx[i] : false,
 				     VIRTIO_MSI_NO_VECTOR);
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index e803db0da307..c1a3fbacd463 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -379,11 +379,6 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 	}
 
 	for (i = 0; i < nvqs; ++i) {
-		if (!names[i]) {
-			vqs[i] = NULL;
-			continue;
-		}
-
 		vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++,
 					      callbacks[i], names[i], ctx ?
 					      ctx[i] : false);
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index da9b271b54db..d362a29550fa 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -56,7 +56,6 @@ typedef void vq_callback_t(struct virtqueue *);
  *	callbacks: array of callbacks, for each virtqueue
  *		include a NULL entry for vqs that do not need a callback
  *	names: array of virtqueue names (mainly for debugging)
- *		include a NULL entry for vqs unused by driver
  *	Returns 0 on success or error status
  * @del_vqs: free virtqueues found by find_vqs().
  * @synchronize_cbs: synchronize with the virtqueue callbacks (optional)
-- 
2.32.0.3.g01195cf9f


