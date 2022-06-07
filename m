Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2AD540442
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345345AbiFGRD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345349AbiFGRDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23799FF590
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:21 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 044781516;
        Tue,  7 Jun 2022 10:03:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6AD213F66F;
        Tue,  7 Jun 2022 10:03:19 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 05/24] virtio: Support modern virtqueue addresses
Date:   Tue,  7 Jun 2022 18:02:20 +0100
Message-Id: <20220607170239.120084-6-jean-philippe.brucker@arm.com>
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

Modern virtio devices can use separate buffer for descriptors, available
and used rings. They can also use 64-bit addresses instead of 44-bit.
Rework the virtqueue initialization function to support modern virtio.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio.h | 29 ++++++++++++++++++++++++-----
 virtio/9p.c          |  6 ++----
 virtio/balloon.c     |  8 +++-----
 virtio/blk.c         |  5 ++---
 virtio/console.c     |  6 ++----
 virtio/core.c        | 24 +++++++++++++++++++-----
 virtio/mmio.c        | 21 ++++++++++++++-------
 virtio/net.c         |  6 ++----
 virtio/pci.c         | 16 ++++++++++++----
 virtio/rng.c         |  6 ++----
 virtio/scsi.c        |  6 ++----
 virtio/vsock.c       |  6 ++----
 12 files changed, 86 insertions(+), 53 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index f0b79334..24179ecc 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -44,9 +44,30 @@
 /* Stop the device */
 #define VIRTIO__STATUS_STOP		(1 << 9)
 
+struct vring_addr {
+	bool			legacy;
+	union {
+		/* Legacy description */
+		struct {
+			u32	pfn;
+			u32	align;
+			u32	pgsize;
+		};
+		/* Modern description */
+		struct {
+			u32	desc_lo;
+			u32	desc_hi;
+			u32	avail_lo;
+			u32	avail_hi;
+			u32	used_lo;
+			u32	used_hi;
+		};
+	};
+};
+
 struct virt_queue {
 	struct vring	vring;
-	u32		pfn;
+	struct vring_addr vring_addr;
 	/* The last_avail_idx field is an index to ->ring of struct vring_avail.
 	   It's where we assume the next request index is at.  */
 	u16		last_avail_idx;
@@ -189,8 +210,7 @@ struct virtio_ops {
 	u32 (*get_host_features)(struct kvm *kvm, void *dev);
 	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
 	unsigned int (*get_vq_count)(struct kvm *kvm, void *dev);
-	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
-		       u32 align, u32 pfn);
+	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq);
 	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
 	int (*notify_vq)(struct kvm *kvm, void *dev, u32 vq);
 	struct virt_queue *(*get_vq)(struct kvm *kvm, void *dev, u32 vq);
@@ -213,8 +233,7 @@ int __must_check virtio_init(struct kvm *kvm, void *dev, struct virtio_device *v
 int virtio_compat_add_message(const char *device, const char *config);
 const char* virtio_trans_name(enum virtio_trans trans);
 void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
-			   struct virt_queue *vq, size_t nr_descs,
-			   u32 page_size, u32 align, u32 pfn);
+			   struct virt_queue *vq, size_t nr_descs);
 void virtio_exit_vq(struct kvm *kvm, struct virtio_device *vdev, void *dev,
 		    int num);
 void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
diff --git a/virtio/9p.c b/virtio/9p.c
index d9a77377..a3f96669 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1408,8 +1408,7 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 		close_fid(p9dev, pfid->fid);
 }
 
-static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
-		   u32 pfn)
+static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct p9_dev *p9dev = dev;
 	struct p9_dev_job *job;
@@ -1420,8 +1419,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	queue		= &p9dev->vqs[vq];
 	job		= &p9dev->jobs[vq];
 
-	virtio_init_device_vq(kvm, &p9dev->vdev, queue, VIRTQUEUE_NUM,
-			      page_size, align, pfn);
+	virtio_init_device_vq(kvm, &p9dev->vdev, queue, VIRTQUEUE_NUM);
 
 	*job		= (struct p9_dev_job) {
 		.vq		= queue,
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 720073dc..ffeeb293 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -130,7 +130,7 @@ static int virtio_bln__collect_stats(struct kvm *kvm)
 	u64 tmp;
 
 	/* Exit if the queue is not set up. */
-	if (!vq->pfn)
+	if (!vq->enabled)
 		return -ENODEV;
 
 	virt_queue__set_used_elem(vq, bdev.cur_stat_head,
@@ -209,8 +209,7 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
 }
 
-static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
-		   u32 pfn)
+static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct bln_dev *bdev = dev;
 	struct virt_queue *queue;
@@ -219,8 +218,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 
 	queue		= &bdev->vqs[vq];
 
-	virtio_init_device_vq(kvm, &bdev->vdev, queue, VIRTIO_BLN_QUEUE_SIZE,
-			      page_size, align, pfn);
+	virtio_init_device_vq(kvm, &bdev->vdev, queue, VIRTIO_BLN_QUEUE_SIZE);
 
 	thread_pool__init_job(&bdev->jobs[vq], kvm, virtio_bln_do_io, queue);
 
diff --git a/virtio/blk.c b/virtio/blk.c
index af8c62f6..2479e006 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -207,8 +207,7 @@ static void *virtio_blk_thread(void *dev)
 	return NULL;
 }
 
-static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
-		   u32 pfn)
+static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	unsigned int i;
 	struct blk_dev *bdev = dev;
@@ -216,7 +215,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	compat__remove_message(compat_id);
 
 	virtio_init_device_vq(kvm, &bdev->vdev, &bdev->vqs[vq],
-			      VIRTIO_BLK_QUEUE_SIZE, page_size, align, pfn);
+			      VIRTIO_BLK_QUEUE_SIZE);
 
 	if (vq != 0)
 		return 0;
diff --git a/virtio/console.c b/virtio/console.c
index 9fbd1016..5263b8e7 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -147,8 +147,7 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
 }
 
-static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
-		   u32 pfn)
+static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct virt_queue *queue;
 
@@ -158,8 +157,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 
 	queue		= &cdev.vqs[vq];
 
-	virtio_init_device_vq(kvm, &cdev.vdev, queue, VIRTIO_CONSOLE_QUEUE_SIZE,
-			      page_size, align, pfn);
+	virtio_init_device_vq(kvm, &cdev.vdev, queue, VIRTIO_CONSOLE_QUEUE_SIZE);
 
 	if (vq == VIRTIO_CONSOLE_TX_QUEUE) {
 		thread_pool__init_job(&cdev.jobs[vq], kvm, virtio_console_handle_callback, queue);
diff --git a/virtio/core.c b/virtio/core.c
index a5125fe1..d6f2c689 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -160,17 +160,31 @@ u16 virt_queue__get_inout_iov(struct kvm *kvm, struct virt_queue *queue,
 }
 
 void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
-			   struct virt_queue *vq, size_t nr_descs,
-			   u32 page_size, u32 align, u32 pfn)
+			   struct virt_queue *vq, size_t nr_descs)
 {
-	void *p = guest_flat_to_host(kvm, (u64)pfn * page_size);
+	struct vring_addr *addr = &vq->vring_addr;
 
 	vq->endian		= vdev->endian;
-	vq->pfn			= pfn;
 	vq->use_event_idx	= (vdev->features & VIRTIO_RING_F_EVENT_IDX);
 	vq->enabled		= true;
 
-	vring_init(&vq->vring, nr_descs, p, align);
+	if (addr->legacy) {
+		unsigned long base = (u64)addr->pfn * addr->pgsize;
+		void *p = guest_flat_to_host(kvm, base);
+
+		vring_init(&vq->vring, nr_descs, p, addr->align);
+	} else {
+		u64 desc = (u64)addr->desc_hi << 32 | addr->desc_lo;
+		u64 avail = (u64)addr->avail_hi << 32 | addr->avail_lo;
+		u64 used = (u64)addr->used_hi << 32 | addr->used_lo;
+
+		vq->vring = (struct vring) {
+			.desc	= guest_flat_to_host(kvm, desc),
+			.used	= guest_flat_to_host(kvm, used),
+			.avail	= guest_flat_to_host(kvm, avail),
+			.num	= nr_descs,
+		};
+	}
 }
 
 void virtio_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 3782d55a..77289e2b 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -125,6 +125,9 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
 	}
 }
 
+#define vmmio_selected_vq(vdev, vmmio) \
+	(vdev)->ops->get_vq((vmmio)->kvm, (vmmio)->dev, (vmmio)->hdr.queue_sel)
+
 static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 				  u64 addr, void *data, u32 len,
 				  struct virtio_device *vdev)
@@ -149,9 +152,8 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 		ioport__write32(data, val);
 		break;
 	case VIRTIO_MMIO_QUEUE_PFN:
-		vq = vdev->ops->get_vq(vmmio->kvm, vmmio->dev,
-				       vmmio->hdr.queue_sel);
-		ioport__write32(data, vq->pfn);
+		vq = vmmio_selected_vq(vdev, vmmio);
+		ioport__write32(data, vq->vring_addr.pfn);
 		break;
 	case VIRTIO_MMIO_QUEUE_NUM_MAX:
 		val = vdev->ops->get_size_vq(vmmio->kvm, vmmio->dev,
@@ -170,6 +172,7 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 	struct virtio_mmio *vmmio = vdev->virtio;
 	struct kvm *kvm = vmmio->kvm;
 	unsigned int vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
+	struct virt_queue *vq;
 	u32 val = 0;
 
 	switch (addr) {
@@ -217,13 +220,17 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 	case VIRTIO_MMIO_QUEUE_PFN:
 		val = ioport__read32(data);
 		if (val) {
+			vq = vmmio_selected_vq(vdev, vmmio);
+			vq->vring_addr = (struct vring_addr) {
+				.legacy	= true,
+				.pfn	= val,
+				.align	= vmmio->hdr.queue_align,
+				.pgsize	= vmmio->hdr.guest_page_size,
+			};
 			virtio_mmio_init_ioeventfd(vmmio->kvm, vdev,
 						   vmmio->hdr.queue_sel);
 			vdev->ops->init_vq(vmmio->kvm, vmmio->dev,
-					   vmmio->hdr.queue_sel,
-					   vmmio->hdr.guest_page_size,
-					   vmmio->hdr.queue_align,
-					   val);
+					   vmmio->hdr.queue_sel);
 		} else {
 			virtio_mmio_exit_vq(kvm, vdev, vmmio->hdr.queue_sel);
 		}
diff --git a/virtio/net.c b/virtio/net.c
index de5ae7b4..7c7970a7 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -582,8 +582,7 @@ static bool is_ctrl_vq(struct net_dev *ndev, u32 vq)
 	return vq == (u32)(ndev->queue_pairs * 2);
 }
 
-static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
-		   u32 pfn)
+static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct vhost_vring_state state = { .index = vq };
 	struct net_dev_queue *net_queue;
@@ -598,8 +597,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	net_queue->id	= vq;
 	net_queue->ndev	= ndev;
 	queue		= &net_queue->vq;
-	virtio_init_device_vq(kvm, &ndev->vdev, queue, VIRTIO_NET_QUEUE_SIZE,
-			      page_size, align, pfn);
+	virtio_init_device_vq(kvm, &ndev->vdev, queue, VIRTIO_NET_QUEUE_SIZE);
 
 	mutex_init(&net_queue->lock);
 	pthread_cond_init(&net_queue->cond, NULL);
diff --git a/virtio/pci.c b/virtio/pci.c
index 23831d5a..20b16228 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -178,7 +178,7 @@ static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev
 		break;
 	case VIRTIO_PCI_QUEUE_PFN:
 		vq = vdev->ops->get_vq(kvm, vpci->dev, vpci->queue_selector);
-		ioport__write32(data, vq->pfn);
+		ioport__write32(data, vq->vring_addr.pfn);
 		break;
 	case VIRTIO_PCI_QUEUE_NUM:
 		val = vdev->ops->get_size_vq(kvm, vpci->dev, vpci->queue_selector);
@@ -318,6 +318,7 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 {
 	bool ret = true;
 	struct virtio_pci *vpci;
+	struct virt_queue *vq;
 	struct kvm *kvm;
 	u32 val;
 	unsigned int vq_count;
@@ -334,11 +335,18 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 	case VIRTIO_PCI_QUEUE_PFN:
 		val = ioport__read32(data);
 		if (val) {
+			vq = vdev->ops->get_vq(kvm, vpci->dev,
+					       vpci->queue_selector);
+			vq->vring_addr = (struct vring_addr) {
+				.legacy	= true,
+				.pfn	= val,
+				.align	= VIRTIO_PCI_VRING_ALIGN,
+				.pgsize	= 1 << VIRTIO_PCI_QUEUE_ADDR_SHIFT,
+			};
 			virtio_pci__init_ioeventfd(kvm, vdev,
 						   vpci->queue_selector);
-			vdev->ops->init_vq(kvm, vpci->dev, vpci->queue_selector,
-					   1 << VIRTIO_PCI_QUEUE_ADDR_SHIFT,
-					   VIRTIO_PCI_VRING_ALIGN, val);
+			vdev->ops->init_vq(kvm, vpci->dev,
+					   vpci->queue_selector);
 		} else {
 			virtio_pci_exit_vq(kvm, vdev, vpci->queue_selector);
 		}
diff --git a/virtio/rng.c b/virtio/rng.c
index 5bcd05a2..840da0ee 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -91,8 +91,7 @@ static void virtio_rng_do_io(struct kvm *kvm, void *param)
 	rdev->vdev.ops->signal_vq(kvm, &rdev->vdev, vq - rdev->vqs);
 }
 
-static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
-		   u32 pfn)
+static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct rng_dev *rdev = dev;
 	struct virt_queue *queue;
@@ -104,8 +103,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 
 	job = &rdev->jobs[vq];
 
-	virtio_init_device_vq(kvm, &rdev->vdev, queue, VIRTIO_RNG_QUEUE_SIZE,
-			      page_size, align, pfn);
+	virtio_init_device_vq(kvm, &rdev->vdev, queue, VIRTIO_RNG_QUEUE_SIZE);
 
 	*job = (struct rng_dev_job) {
 		.vq	= queue,
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 9dd9e9ac..507cf3f1 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -62,8 +62,7 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
 }
 
-static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
-		   u32 pfn)
+static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct vhost_vring_state state = { .index = vq };
 	struct vhost_vring_addr addr;
@@ -75,8 +74,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 
 	queue		= &sdev->vqs[vq];
 
-	virtio_init_device_vq(kvm, &sdev->vdev, queue, VIRTIO_SCSI_QUEUE_SIZE,
-			      page_size, align, pfn);
+	virtio_init_device_vq(kvm, &sdev->vdev, queue, VIRTIO_SCSI_QUEUE_SIZE);
 
 	if (sdev->vhost_fd == 0)
 		return 0;
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 79a672fe..dfd62112 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -65,8 +65,7 @@ static bool is_event_vq(u32 vq)
 	return vq == VSOCK_VQ_EVENT;
 }
 
-static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
-		   u32 pfn)
+static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct vhost_vring_state state = { .index = vq };
 	struct vhost_vring_addr addr;
@@ -77,8 +76,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	compat__remove_message(compat_id);
 
 	queue		= &vdev->vqs[vq];
-	virtio_init_device_vq(kvm, &vdev->vdev, queue, VIRTIO_VSOCK_QUEUE_SIZE,
-			      page_size, align, pfn);
+	virtio_init_device_vq(kvm, &vdev->vdev, queue, VIRTIO_VSOCK_QUEUE_SIZE);
 
 	if (vdev->vhost_fd == -1)
 		return 0;
-- 
2.36.1

