Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13090540441
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345355AbiFGRDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345346AbiFGRDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:21 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A3CAFF588
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A4F51576;
        Tue,  7 Jun 2022 10:03:19 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C78653F66F;
        Tue,  7 Jun 2022 10:03:17 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 04/24] virtio: Factor virtqueue initialization
Date:   Tue,  7 Jun 2022 18:02:19 +0100
Message-Id: <20220607170239.120084-5-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All virtio devices perform the same set of operations when initializing
their virtqueues. Move it to virtio core.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio.h | 17 +++--------------
 virtio/9p.c          |  7 ++-----
 virtio/balloon.c     |  8 +++-----
 virtio/blk.c         | 10 ++--------
 virtio/console.c     |  7 ++-----
 virtio/core.c        | 14 ++++++++++++++
 virtio/net.c         |  8 ++------
 virtio/rng.c         |  7 ++-----
 virtio/scsi.c        |  7 ++-----
 virtio/vsock.c       |  8 ++------
 10 files changed, 34 insertions(+), 59 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 8a363632..f0b79334 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -212,20 +212,9 @@ int __must_check virtio_init(struct kvm *kvm, void *dev, struct virtio_device *v
 			     int device_id, int subsys_id, int class);
 int virtio_compat_add_message(const char *device, const char *config);
 const char* virtio_trans_name(enum virtio_trans trans);
-
-static inline void *virtio_get_vq(struct kvm *kvm, u32 pfn, u32 page_size)
-{
-	return guest_flat_to_host(kvm, (u64)pfn * page_size);
-}
-
-static inline void virtio_init_device_vq(struct virtio_device *vdev,
-					 struct virt_queue *vq)
-{
-	vq->endian = vdev->endian;
-	vq->use_event_idx = (vdev->features & VIRTIO_RING_F_EVENT_IDX);
-	vq->enabled = true;
-}
-
+void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
+			   struct virt_queue *vq, size_t nr_descs,
+			   u32 page_size, u32 align, u32 pfn);
 void virtio_exit_vq(struct kvm *kvm, struct virtio_device *vdev, void *dev,
 		    int num);
 void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
diff --git a/virtio/9p.c b/virtio/9p.c
index 7c9d7925..d9a77377 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1414,17 +1414,14 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	struct p9_dev *p9dev = dev;
 	struct p9_dev_job *job;
 	struct virt_queue *queue;
-	void *p;
 
 	compat__remove_message(compat_id);
 
 	queue		= &p9dev->vqs[vq];
-	queue->pfn	= pfn;
-	p		= virtio_get_vq(kvm, queue->pfn, page_size);
 	job		= &p9dev->jobs[vq];
 
-	vring_init(&queue->vring, VIRTQUEUE_NUM, p, align);
-	virtio_init_device_vq(&p9dev->vdev, queue);
+	virtio_init_device_vq(kvm, &p9dev->vdev, queue, VIRTQUEUE_NUM,
+			      page_size, align, pfn);
 
 	*job		= (struct p9_dev_job) {
 		.vq		= queue,
diff --git a/virtio/balloon.c b/virtio/balloon.c
index f398ce47..720073dc 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -214,17 +214,15 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 {
 	struct bln_dev *bdev = dev;
 	struct virt_queue *queue;
-	void *p;
 
 	compat__remove_message(compat_id);
 
 	queue		= &bdev->vqs[vq];
-	queue->pfn	= pfn;
-	p		= virtio_get_vq(kvm, queue->pfn, page_size);
+
+	virtio_init_device_vq(kvm, &bdev->vdev, queue, VIRTIO_BLN_QUEUE_SIZE,
+			      page_size, align, pfn);
 
 	thread_pool__init_job(&bdev->jobs[vq], kvm, virtio_bln_do_io, queue);
-	vring_init(&queue->vring, VIRTIO_BLN_QUEUE_SIZE, p, align);
-	virtio_init_device_vq(&bdev->vdev, queue);
 
 	return 0;
 }
diff --git a/virtio/blk.c b/virtio/blk.c
index 46ee0281..af8c62f6 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -212,17 +212,11 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 {
 	unsigned int i;
 	struct blk_dev *bdev = dev;
-	struct virt_queue *queue;
-	void *p;
 
 	compat__remove_message(compat_id);
 
-	queue		= &bdev->vqs[vq];
-	queue->pfn	= pfn;
-	p		= virtio_get_vq(kvm, queue->pfn, page_size);
-
-	vring_init(&queue->vring, VIRTIO_BLK_QUEUE_SIZE, p, align);
-	virtio_init_device_vq(&bdev->vdev, queue);
+	virtio_init_device_vq(kvm, &bdev->vdev, &bdev->vqs[vq],
+			      VIRTIO_BLK_QUEUE_SIZE, page_size, align, pfn);
 
 	if (vq != 0)
 		return 0;
diff --git a/virtio/console.c b/virtio/console.c
index 83158082..9fbd1016 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -151,18 +151,15 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 		   u32 pfn)
 {
 	struct virt_queue *queue;
-	void *p;
 
 	BUG_ON(vq >= VIRTIO_CONSOLE_NUM_QUEUES);
 
 	compat__remove_message(compat_id);
 
 	queue		= &cdev.vqs[vq];
-	queue->pfn	= pfn;
-	p		= virtio_get_vq(kvm, queue->pfn, page_size);
 
-	vring_init(&queue->vring, VIRTIO_CONSOLE_QUEUE_SIZE, p, align);
-	virtio_init_device_vq(&cdev.vdev, queue);
+	virtio_init_device_vq(kvm, &cdev.vdev, queue, VIRTIO_CONSOLE_QUEUE_SIZE,
+			      page_size, align, pfn);
 
 	if (vq == VIRTIO_CONSOLE_TX_QUEUE) {
 		thread_pool__init_job(&cdev.jobs[vq], kvm, virtio_console_handle_callback, queue);
diff --git a/virtio/core.c b/virtio/core.c
index 40532664..a5125fe1 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -159,6 +159,20 @@ u16 virt_queue__get_inout_iov(struct kvm *kvm, struct virt_queue *queue,
 	return head;
 }
 
+void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
+			   struct virt_queue *vq, size_t nr_descs,
+			   u32 page_size, u32 align, u32 pfn)
+{
+	void *p = guest_flat_to_host(kvm, (u64)pfn * page_size);
+
+	vq->endian		= vdev->endian;
+	vq->pfn			= pfn;
+	vq->use_event_idx	= (vdev->features & VIRTIO_RING_F_EVENT_IDX);
+	vq->enabled		= true;
+
+	vring_init(&vq->vring, nr_descs, p, align);
+}
+
 void virtio_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
 			   void *dev, int num)
 {
diff --git a/virtio/net.c b/virtio/net.c
index 67070d65..de5ae7b4 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -590,7 +590,6 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	struct vhost_vring_addr addr;
 	struct net_dev *ndev = dev;
 	struct virt_queue *queue;
-	void *p;
 	int r;
 
 	compat__remove_message(compat_id);
@@ -599,11 +598,8 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	net_queue->id	= vq;
 	net_queue->ndev	= ndev;
 	queue		= &net_queue->vq;
-	queue->pfn	= pfn;
-	p		= virtio_get_vq(kvm, queue->pfn, page_size);
-
-	vring_init(&queue->vring, VIRTIO_NET_QUEUE_SIZE, p, align);
-	virtio_init_device_vq(&ndev->vdev, queue);
+	virtio_init_device_vq(kvm, &ndev->vdev, queue, VIRTIO_NET_QUEUE_SIZE,
+			      page_size, align, pfn);
 
 	mutex_init(&net_queue->lock);
 	pthread_cond_init(&net_queue->cond, NULL);
diff --git a/virtio/rng.c b/virtio/rng.c
index 75b682e3..5bcd05a2 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -97,18 +97,15 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	struct rng_dev *rdev = dev;
 	struct virt_queue *queue;
 	struct rng_dev_job *job;
-	void *p;
 
 	compat__remove_message(compat_id);
 
 	queue		= &rdev->vqs[vq];
-	queue->pfn	= pfn;
-	p		= virtio_get_vq(kvm, queue->pfn, page_size);
 
 	job = &rdev->jobs[vq];
 
-	vring_init(&queue->vring, VIRTIO_RNG_QUEUE_SIZE, p, align);
-	virtio_init_device_vq(&rdev->vdev, queue);
+	virtio_init_device_vq(kvm, &rdev->vdev, queue, VIRTIO_RNG_QUEUE_SIZE,
+			      page_size, align, pfn);
 
 	*job = (struct rng_dev_job) {
 		.vq	= queue,
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 60432cc8..9dd9e9ac 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -69,17 +69,14 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	struct vhost_vring_addr addr;
 	struct scsi_dev *sdev = dev;
 	struct virt_queue *queue;
-	void *p;
 	int r;
 
 	compat__remove_message(compat_id);
 
 	queue		= &sdev->vqs[vq];
-	queue->pfn	= pfn;
-	p		= virtio_get_vq(kvm, queue->pfn, page_size);
 
-	vring_init(&queue->vring, VIRTIO_SCSI_QUEUE_SIZE, p, align);
-	virtio_init_device_vq(&sdev->vdev, queue);
+	virtio_init_device_vq(kvm, &sdev->vdev, queue, VIRTIO_SCSI_QUEUE_SIZE,
+			      page_size, align, pfn);
 
 	if (sdev->vhost_fd == 0)
 		return 0;
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 780169b1..79a672fe 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -72,17 +72,13 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	struct vhost_vring_addr addr;
 	struct vsock_dev *vdev = dev;
 	struct virt_queue *queue;
-	void *p;
 	int r;
 
 	compat__remove_message(compat_id);
 
 	queue		= &vdev->vqs[vq];
-	queue->pfn	= pfn;
-	p		= virtio_get_vq(kvm, queue->pfn, page_size);
-
-	vring_init(&queue->vring, VIRTIO_VSOCK_QUEUE_SIZE, p, align);
-	virtio_init_device_vq(&vdev->vdev, queue);
+	virtio_init_device_vq(kvm, &vdev->vdev, queue, VIRTIO_VSOCK_QUEUE_SIZE,
+			      page_size, align, pfn);
 
 	if (vdev->vhost_fd == -1)
 		return 0;
-- 
2.36.1

