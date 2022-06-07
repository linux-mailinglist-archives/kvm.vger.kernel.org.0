Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD8540446
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345356AbiFGRDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345358AbiFGRD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7002FF588
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0A47143D;
        Tue,  7 Jun 2022 10:03:27 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 67D963F66F;
        Tue,  7 Jun 2022 10:03:26 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 09/24] virtio: Remove set_guest_features() device op
Date:   Tue,  7 Jun 2022 18:02:24 +0100
Message-Id: <20220607170239.120084-10-jean-philippe.brucker@arm.com>
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

Now that devices have a status callback, they don't use
set_guest_features() anymore. The negotiated feature set is available in
struct virtio_device. Remove the callback from all devices.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio-9p.h |  1 -
 include/kvm/virtio.h    |  1 -
 virtio/9p.c             |  8 --------
 virtio/balloon.c        | 10 ----------
 virtio/blk.c            |  9 ---------
 virtio/console.c        |  6 ------
 virtio/core.c           |  1 -
 virtio/net.c            | 12 ++----------
 virtio/rng.c            |  6 ------
 virtio/scsi.c           |  9 ---------
 virtio/vsock.c          |  8 --------
 11 files changed, 2 insertions(+), 69 deletions(-)

diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
index 46922781..1dffc955 100644
--- a/include/kvm/virtio-9p.h
+++ b/include/kvm/virtio-9p.h
@@ -46,7 +46,6 @@ struct p9_dev {
 
 	size_t config_size;
 	struct virtio_9p_config	*config;
-	u32			features;
 	u16			tag_len;
 
 	/* virtio queue */
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 9913ba92..2da5e4f6 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -210,7 +210,6 @@ struct virtio_ops {
 	u8 *(*get_config)(struct kvm *kvm, void *dev);
 	size_t (*get_config_size)(struct kvm *kvm, void *dev);
 	u32 (*get_host_features)(struct kvm *kvm, void *dev);
-	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
 	unsigned int (*get_vq_count)(struct kvm *kvm, void *dev);
 	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq);
 	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
diff --git a/virtio/9p.c b/virtio/9p.c
index e16c1edd..cb3a42a4 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1387,13 +1387,6 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 	return 1 << VIRTIO_9P_MOUNT_TAG;
 }
 
-static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
-{
-	struct p9_dev *p9dev = dev;
-
-	p9dev->features = features;
-}
-
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
 	struct p9_dev *p9dev = dev;
@@ -1475,7 +1468,6 @@ struct virtio_ops p9_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
-	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
 	.exit_vq		= exit_vq,
 	.notify_status		= notify_status,
diff --git a/virtio/balloon.c b/virtio/balloon.c
index f06955d2..6f10219e 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -33,8 +33,6 @@ struct bln_dev {
 	struct list_head	list;
 	struct virtio_device	vdev;
 
-	u32			features;
-
 	/* virtio queue */
 	struct virt_queue	vqs[NUM_VIRT_QUEUES];
 	struct thread_pool__job	jobs[NUM_VIRT_QUEUES];
@@ -207,13 +205,6 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 	return 1 << VIRTIO_BALLOON_F_STATS_VQ;
 }
 
-static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
-{
-	struct bln_dev *bdev = dev;
-
-	bdev->features = features;
-}
-
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct bln_dev *bdev = dev;
@@ -266,7 +257,6 @@ struct virtio_ops bln_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
-	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
 	.notify_vq		= notify_vq,
 	.get_vq			= get_vq,
diff --git a/virtio/blk.c b/virtio/blk.c
index b07234ff..b56d45bd 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -45,7 +45,6 @@ struct blk_dev {
 	struct virtio_blk_config	blk_config;
 	u64				capacity;
 	struct disk_image		*disk;
-	u32				features;
 
 	struct virt_queue		vqs[NUM_VIRT_QUEUES];
 	struct blk_dev_req		reqs[VIRTIO_BLK_QUEUE_SIZE];
@@ -165,13 +164,6 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 		| (bdev->disk->readonly ? 1UL << VIRTIO_BLK_F_RO : 0);
 }
 
-static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
-{
-	struct blk_dev *bdev = dev;
-
-	bdev->features = features;
-}
-
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
 	struct blk_dev *bdev = dev;
@@ -289,7 +281,6 @@ static struct virtio_ops blk_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
-	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
 	.exit_vq		= exit_vq,
diff --git a/virtio/console.c b/virtio/console.c
index 7ba948d3..610995de 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -34,7 +34,6 @@ struct con_dev {
 	struct virtio_device		vdev;
 	struct virt_queue		vqs[VIRTIO_CONSOLE_NUM_QUEUES];
 	struct virtio_console_config	config;
-	u32				features;
 	int				vq_ready;
 
 	struct thread_pool__job		jobs[VIRTIO_CONSOLE_NUM_QUEUES];
@@ -126,10 +125,6 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 	return 0;
 }
 
-static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
-{
-}
-
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
 	struct con_dev *cdev = dev;
@@ -216,7 +211,6 @@ static struct virtio_ops con_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
-	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
 	.exit_vq		= exit_vq,
diff --git a/virtio/core.c b/virtio/core.c
index fbf4b139..568667f2 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -250,7 +250,6 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 	/* TODO: fail negotiation if features & ~host_features */
 
 	vdev->features = features;
-	vdev->ops->set_guest_features(kvm, dev, features);
 }
 
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
diff --git a/virtio/net.c b/virtio/net.c
index 29b33e08..844612ac 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -55,7 +55,7 @@ struct net_dev {
 
 	struct net_dev_queue		queues[VIRTIO_NET_NUM_QUEUES * 2 + 1];
 	struct virtio_net_config	config;
-	u32				features, queue_pairs;
+	u32				queue_pairs;
 
 	int				vhost_fd;
 	int				tap_fd;
@@ -78,7 +78,7 @@ static int compat_id = -1;
 
 static bool has_virtio_feature(struct net_dev *ndev, u32 feature)
 {
-	return ndev->features & (1 << feature);
+	return ndev->vdev.features & (1 << feature);
 }
 
 static void virtio_net_fix_tx_hdr(struct virtio_net_hdr *hdr, struct net_dev *ndev)
@@ -531,13 +531,6 @@ static int virtio_net__vhost_set_features(struct net_dev *ndev)
 	return ioctl(ndev->vhost_fd, VHOST_SET_FEATURES, &features);
 }
 
-static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
-{
-	struct net_dev *ndev = dev;
-
-	ndev->features = features;
-}
-
 static void virtio_net_start(struct net_dev *ndev)
 {
 	if (ndev->mode == NET_MODE_TAP) {
@@ -770,7 +763,6 @@ static struct virtio_ops net_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
-	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
 	.exit_vq		= exit_vq,
diff --git a/virtio/rng.c b/virtio/rng.c
index 840da0ee..8fda9dd6 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -58,11 +58,6 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 	return 0;
 }
 
-static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
-{
-	/* Unused */
-}
-
 static bool virtio_rng_do_io_request(struct kvm *kvm, struct rng_dev *rdev, struct virt_queue *queue)
 {
 	struct iovec iov[VIRTIO_RNG_QUEUE_SIZE];
@@ -151,7 +146,6 @@ static struct virtio_ops rng_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
-	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
 	.notify_vq		= notify_vq,
 	.get_vq			= get_vq,
diff --git a/virtio/scsi.c b/virtio/scsi.c
index ef75ef79..d69183b7 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -24,7 +24,6 @@ struct scsi_dev {
 	struct virt_queue		vqs[NUM_VIRT_QUEUES];
 	struct virtio_scsi_config	config;
 	struct vhost_scsi_target	target;
-	u32				features;
 	int				vhost_fd;
 	struct virtio_device		vdev;
 	struct list_head		list;
@@ -51,13 +50,6 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 		1UL << VIRTIO_RING_F_INDIRECT_DESC;
 }
 
-static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
-{
-	struct scsi_dev *sdev = dev;
-
-	sdev->features = features;
-}
-
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
 	struct scsi_dev *sdev = dev;
@@ -198,7 +190,6 @@ static struct virtio_ops scsi_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
-	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
 	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 594bab7a..02cee683 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -55,13 +55,6 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 		| 1UL << VIRTIO_RING_F_INDIRECT_DESC;
 }
 
-static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
-{
-	struct vsock_dev *vdev = dev;
-
-	vdev->features = features;
-}
-
 static bool is_event_vq(u32 vq)
 {
 	return vq == VSOCK_VQ_EVENT;
@@ -212,7 +205,6 @@ static struct virtio_ops vsock_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
-	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
 	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
-- 
2.36.1

