Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB47540445
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345370AbiFGRDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345356AbiFGRD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:26 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5982FF590
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AE96143D;
        Tue,  7 Jun 2022 10:03:24 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CD95E3F66F;
        Tue,  7 Jun 2022 10:03:22 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 07/24] virtio: Fix device-specific config endianness
Date:   Tue,  7 Jun 2022 18:02:22 +0100
Message-Id: <20220607170239.120084-8-jean-philippe.brucker@arm.com>
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

Some legacy virtio drivers expect to read the device-specific config in
guest endianness (2.5.3 "Legacy Interface: A Note on Device
Configuration Space endian-ness").

Kvmtool doesn't know the guest endianness until it can probe a VCPU. So
the config fields start in host endianness, and are swapped once the
guest is running. Currently this is done in set_guest_features(), but
that is too late because the driver is allowed to read config fields
before setting feature bits (2.5.2 "Device Requirements: Device
Configuration Space"). In addition some devices don't swap the fields,
and those that do swap the fields do it every time the guest writes the
feature register, which can't work if a device gets reset more than
once.

Initialize the config on device reset. Do it on every reset because in
theory multiple guests could run with different endianness during the
lifetime of the device.

Notes:

* the balloon device uses little-endian (5.5.4.0.0.1 "Legacy Interface:
  Device configuration layout").

* the vsock device was introduced after virtio 0.9.5, hence doesn't
  describe a legacy interface, but the Linux driver allows to use the
  legacy transport, and always reads the 64-bit guest_cid field as
  little-endian.

* the specification does not describe the 9p device, but the Linux
  driver uses guest-endian helpers.

* the specification does not explicitly forbid a driver from reading the
  configuration at any time, but a driver must follow the sequence from
  3.1.1 "Driver Requirements: Device Initialization", where the driver
  is allowed to read the config after setting the DRIVER status bit. It
  should therefore be safe to keep dealing with guest endianness only on
  device reset, and not on the first config access.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio-9p.h |  1 +
 include/kvm/virtio.h    |  2 ++
 virtio/9p.c             | 10 ++++++----
 virtio/balloon.c        | 19 ++++++++++++++-----
 virtio/blk.c            | 27 ++++++++++-----------------
 virtio/console.c        | 22 +++++++++-------------
 virtio/core.c           |  2 ++
 virtio/net.c            | 23 +++++++++++++++--------
 virtio/scsi.c           | 30 ++++++++++++++++++------------
 virtio/vsock.c          | 11 +++++++----
 10 files changed, 84 insertions(+), 63 deletions(-)

diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
index 77c5062a..46922781 100644
--- a/include/kvm/virtio-9p.h
+++ b/include/kvm/virtio-9p.h
@@ -47,6 +47,7 @@ struct p9_dev {
 	size_t config_size;
 	struct virtio_9p_config	*config;
 	u32			features;
+	u16			tag_len;
 
 	/* virtio queue */
 	struct virt_queue	vqs[NUM_VIRT_QUEUES];
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index cc4ba1d6..9913ba92 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -43,6 +43,8 @@
 #define VIRTIO__STATUS_START		(1 << 8)
 /* Stop the device */
 #define VIRTIO__STATUS_STOP		(1 << 9)
+/* Initialize the config */
+#define VIRTIO__STATUS_CONFIG		(1 << 10)
 
 struct vring_addr {
 	bool			legacy;
diff --git a/virtio/9p.c b/virtio/9p.c
index a3f96669..e16c1edd 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1390,10 +1390,8 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 {
 	struct p9_dev *p9dev = dev;
-	struct virtio_9p_config *conf = p9dev->config;
 
 	p9dev->features = features;
-	conf->tag_len = virtio_host_to_guest_u16(&p9dev->vdev, conf->tag_len);
 }
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
@@ -1401,6 +1399,10 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	struct p9_dev *p9dev = dev;
 	struct p9_fid *pfid, *next;
 
+	if (status & VIRTIO__STATUS_CONFIG)
+		p9dev->config->tag_len = virtio_host_to_guest_u16(&p9dev->vdev,
+								  p9dev->tag_len);
+
 	if (!(status & VIRTIO__STATUS_STOP))
 		return;
 
@@ -1596,8 +1598,8 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
 	strncpy(p9dev->root_dir, root, sizeof(p9dev->root_dir));
 	p9dev->root_dir[sizeof(p9dev->root_dir)-1] = '\x00';
 
-	p9dev->config->tag_len = tag_length;
-	if (p9dev->config->tag_len > MAX_TAG_LEN) {
+	p9dev->tag_len = tag_length;
+	if (p9dev->tag_len > MAX_TAG_LEN) {
 		err = -EINVAL;
 		goto free_p9dev_config;
 	}
diff --git a/virtio/balloon.c b/virtio/balloon.c
index ffeeb293..753171d1 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -13,6 +13,7 @@
 #include <linux/virtio_ring.h>
 #include <linux/virtio_balloon.h>
 
+#include <linux/byteorder.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <fcntl.h>
@@ -56,22 +57,25 @@ static bool virtio_bln_do_io_request(struct kvm *kvm, struct bln_dev *bdev, stru
 	unsigned int len = 0;
 	u16 out, in, head;
 	u32 *ptrs, i;
+	u32 actual;
 
 	head	= virt_queue__get_iov(queue, iov, &out, &in, kvm);
 	ptrs	= iov[0].iov_base;
 	len	= iov[0].iov_len / sizeof(u32);
 
+	actual = le32_to_cpu(bdev->config.actual);
 	for (i = 0 ; i < len ; i++) {
 		void *guest_ptr;
 
 		guest_ptr = guest_flat_to_host(kvm, (u64)ptrs[i] << VIRTIO_BALLOON_PFN_SHIFT);
 		if (queue == &bdev->vqs[VIRTIO_BLN_INFLATE]) {
 			madvise(guest_ptr, 1 << VIRTIO_BALLOON_PFN_SHIFT, MADV_DONTNEED);
-			bdev->config.actual++;
+			actual++;
 		} else if (queue == &bdev->vqs[VIRTIO_BLN_DEFLATE]) {
-			bdev->config.actual--;
+			actual--;
 		}
 	}
+	bdev->config.actual = cpu_to_le32(actual);
 
 	virt_queue__set_used_elem(queue, head, len);
 
@@ -161,20 +165,25 @@ static void virtio_bln__print_stats(struct kvm *kvm, int fd, u32 type, u32 len,
 static void handle_mem(struct kvm *kvm, int fd, u32 type, u32 len, u8 *msg)
 {
 	int mem;
+	u32 num_pages;
 
 	if (WARN_ON(type != KVM_IPC_BALLOON || len != sizeof(int)))
 		return;
 
 	mem = *(int *)msg;
+	num_pages = le32_to_cpu(bdev.config.num_pages);
+
 	if (mem > 0) {
-		bdev.config.num_pages += 256 * mem;
+		num_pages += 256 * mem;
 	} else if (mem < 0) {
-		if (bdev.config.num_pages < (u32)(256 * (-mem)))
+		if (num_pages < (u32)(256 * (-mem)))
 			return;
 
-		bdev.config.num_pages += 256 * mem;
+		num_pages += 256 * mem;
 	}
 
+	bdev.config.num_pages = cpu_to_le32(num_pages);
+
 	/* Notify that the configuration space has changed */
 	bdev.vdev.ops->signal_config(kvm, &bdev.vdev);
 }
diff --git a/virtio/blk.c b/virtio/blk.c
index 2479e006..b07234ff 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -43,6 +43,7 @@ struct blk_dev {
 
 	struct virtio_device		vdev;
 	struct virtio_blk_config	blk_config;
+	u64				capacity;
 	struct disk_image		*disk;
 	u32				features;
 
@@ -167,25 +168,20 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 {
 	struct blk_dev *bdev = dev;
-	struct virtio_blk_config *conf = &bdev->blk_config;
 
 	bdev->features = features;
-
-	conf->capacity = virtio_host_to_guest_u64(&bdev->vdev, conf->capacity);
-	conf->size_max = virtio_host_to_guest_u32(&bdev->vdev, conf->size_max);
-	conf->seg_max = virtio_host_to_guest_u32(&bdev->vdev, conf->seg_max);
-
-	/* Geometry */
-	conf->geometry.cylinders = virtio_host_to_guest_u16(&bdev->vdev,
-						conf->geometry.cylinders);
-
-	conf->blk_size = virtio_host_to_guest_u32(&bdev->vdev, conf->blk_size);
-	conf->min_io_size = virtio_host_to_guest_u16(&bdev->vdev, conf->min_io_size);
-	conf->opt_io_size = virtio_host_to_guest_u32(&bdev->vdev, conf->opt_io_size);
 }
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
+	struct blk_dev *bdev = dev;
+	struct virtio_blk_config *conf = &bdev->blk_config;
+
+	if (!(status & VIRTIO__STATUS_CONFIG))
+		return;
+
+	conf->capacity = virtio_host_to_guest_u64(&bdev->vdev, bdev->capacity);
+	conf->seg_max = virtio_host_to_guest_u32(&bdev->vdev, DISK_SEG_MAX);
 }
 
 static void *virtio_blk_thread(void *dev)
@@ -318,10 +314,7 @@ static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
 
 	*bdev = (struct blk_dev) {
 		.disk			= disk,
-		.blk_config		= (struct virtio_blk_config) {
-			.capacity	= disk->size / SECTOR_SIZE,
-			.seg_max	= DISK_SEG_MAX,
-		},
+		.capacity		= disk->size / SECTOR_SIZE,
 		.kvm			= kvm,
 	};
 
diff --git a/virtio/console.c b/virtio/console.c
index 5263b8e7..7ba948d3 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -42,14 +42,7 @@ struct con_dev {
 
 static struct con_dev cdev = {
 	.mutex				= MUTEX_INITIALIZER,
-
 	.vq_ready			= 0,
-
-	.config = {
-		.cols			= 80,
-		.rows			= 24,
-		.max_nr_ports		= 1,
-	},
 };
 
 static int compat_id = -1;
@@ -135,16 +128,19 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 
 static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 {
-	struct con_dev *cdev = dev;
-	struct virtio_console_config *conf = &cdev->config;
-
-	conf->cols = virtio_host_to_guest_u16(&cdev->vdev, conf->cols);
-	conf->rows = virtio_host_to_guest_u16(&cdev->vdev, conf->rows);
-	conf->max_nr_ports = virtio_host_to_guest_u32(&cdev->vdev, conf->max_nr_ports);
 }
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
+	struct con_dev *cdev = dev;
+	struct virtio_console_config *conf = &cdev->config;
+
+	if (!(status & VIRTIO__STATUS_CONFIG))
+		return;
+
+	conf->cols = virtio_host_to_guest_u16(&cdev->vdev, 80);
+	conf->rows = virtio_host_to_guest_u16(&cdev->vdev, 24);
+	conf->max_nr_ports = virtio_host_to_guest_u32(&cdev->vdev, 1);
 }
 
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
diff --git a/virtio/core.c b/virtio/core.c
index be0f6f8d..fbf4b139 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -277,6 +277,8 @@ void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 		 */
 		vdev->ops->reset(kvm, vdev);
 	}
+	if (!status)
+		ext_status |= VIRTIO__STATUS_CONFIG;
 
 	if (vdev->ops->notify_status)
 		vdev->ops->notify_status(kvm, dev, ext_status);
diff --git a/virtio/net.c b/virtio/net.c
index 7c7970a7..29b33e08 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -534,13 +534,8 @@ static int virtio_net__vhost_set_features(struct net_dev *ndev)
 static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 {
 	struct net_dev *ndev = dev;
-	struct virtio_net_config *conf = &ndev->config;
 
 	ndev->features = features;
-
-	conf->status = virtio_host_to_guest_u16(&ndev->vdev, conf->status);
-	conf->max_virtqueue_pairs = virtio_host_to_guest_u16(&ndev->vdev,
-							     conf->max_virtqueue_pairs);
 }
 
 static void virtio_net_start(struct net_dev *ndev)
@@ -569,8 +564,23 @@ static void virtio_net_stop(struct net_dev *ndev)
 		uip_exit(&ndev->info);
 }
 
+static void virtio_net_update_endian(struct net_dev *ndev)
+{
+	struct virtio_net_config *conf = &ndev->config;
+
+	conf->status = virtio_host_to_guest_u16(&ndev->vdev,
+						VIRTIO_NET_S_LINK_UP);
+	conf->max_virtqueue_pairs = virtio_host_to_guest_u16(&ndev->vdev,
+							     ndev->queue_pairs);
+}
+
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
+	struct net_dev *ndev = dev;
+
+	if (status & VIRTIO__STATUS_CONFIG)
+		virtio_net_update_endian(ndev);
+
 	if (status & VIRTIO__STATUS_START)
 		virtio_net_start(dev);
 	else if (status & VIRTIO__STATUS_STOP)
@@ -932,9 +942,6 @@ static int virtio_net__init_one(struct virtio_net_params *params)
 
 	mutex_init(&ndev->mutex);
 	ndev->queue_pairs = max(1, min(VIRTIO_NET_NUM_QUEUES, params->mq));
-	ndev->config.status = VIRTIO_NET_S_LINK_UP;
-	if (ndev->queue_pairs > 1)
-		ndev->config.max_virtqueue_pairs = ndev->queue_pairs;
 
 	for (i = 0 ; i < 6 ; i++) {
 		ndev->config.mac[i]		= params->guest_mac[i];
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 507cf3f1..ef75ef79 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -60,6 +60,24 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
+	struct scsi_dev *sdev = dev;
+	struct virtio_device *vdev = &sdev->vdev;
+	struct virtio_scsi_config *conf = &sdev->config;
+
+	if (!(status & VIRTIO__STATUS_CONFIG))
+		return;
+
+	/* Avoid warning when endianness helpers are compiled out */
+	vdev = vdev;
+
+	conf->num_queues = virtio_host_to_guest_u32(vdev, NUM_VIRT_QUEUES - 2);
+	conf->seg_max = virtio_host_to_guest_u32(vdev, VIRTIO_SCSI_CDB_SIZE - 2);
+	conf->max_sectors = virtio_host_to_guest_u32(vdev, 65535);
+	conf->cmd_per_lun = virtio_host_to_guest_u32(vdev, 128);
+	conf->sense_size = virtio_host_to_guest_u32(vdev, VIRTIO_SCSI_SENSE_SIZE);
+	conf->cdb_size = virtio_host_to_guest_u32(vdev, VIRTIO_SCSI_CDB_SIZE);
+	conf->max_lun = virtio_host_to_guest_u32(vdev, 16383);
+	conf->event_info_size = virtio_host_to_guest_u32(vdev, sizeof(struct virtio_scsi_event));
 }
 
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
@@ -247,18 +265,6 @@ static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
 		return -ENOMEM;
 
 	*sdev = (struct scsi_dev) {
-		.config	= (struct virtio_scsi_config) {
-			.num_queues	= NUM_VIRT_QUEUES - 2,
-			.seg_max	= VIRTIO_SCSI_CDB_SIZE - 2,
-			.max_sectors	= 65535,
-			.cmd_per_lun	= 128,
-			.sense_size	= VIRTIO_SCSI_SENSE_SIZE,
-			.cdb_size	= VIRTIO_SCSI_CDB_SIZE,
-			.max_channel	= 0,
-			.max_target	= 0,
-			.max_lun	= 16383,
-			.event_info_size = sizeof(struct virtio_scsi_event),
-		},
 		.kvm			= kvm,
 	};
 	strlcpy((char *)&sdev->target.vhost_wwpn, disk->wwpn, sizeof(sdev->target.vhost_wwpn));
diff --git a/virtio/vsock.c b/virtio/vsock.c
index dfd62112..594bab7a 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -7,6 +7,7 @@
 #include "kvm/virtio-pci.h"
 #include "kvm/virtio.h"
 
+#include <linux/byteorder.h>
 #include <linux/kernel.h>
 #include <linux/virtio_vsock.h>
 #include <linux/vhost.h>
@@ -26,6 +27,7 @@ enum {
 struct vsock_dev {
 	struct virt_queue		vqs[VSOCK_VQ_MAX];
 	struct virtio_vsock_config	config;
+	u64				guest_cid;
 	u32				features;
 	int				vhost_fd;
 	struct virtio_device		vdev;
@@ -133,6 +135,9 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	struct vsock_dev *vdev = dev;
 	int r, start;
 
+	if (status & VIRTIO__STATUS_CONFIG)
+		vdev->config.guest_cid = cpu_to_le64(vdev->guest_cid);
+
 	if (status & VIRTIO__STATUS_START)
 		start = 1;
 	else if (status & VIRTIO__STATUS_STOP)
@@ -261,7 +266,7 @@ static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
 	if (r != 0)
 		die_perror("VHOST_SET_FEATURES failed");
 
-	r = ioctl(vdev->vhost_fd, VHOST_VSOCK_SET_GUEST_CID, &vdev->config.guest_cid);
+	r = ioctl(vdev->vhost_fd, VHOST_VSOCK_SET_GUEST_CID, &vdev->guest_cid);
 	if (r != 0)
 		die_perror("VHOST_VSOCK_SET_GUEST_CID failed");
 
@@ -280,9 +285,7 @@ static int virtio_vsock_init_one(struct kvm *kvm, u64 guest_cid)
 		return -ENOMEM;
 
 	*vdev = (struct vsock_dev) {
-		.config	= (struct virtio_vsock_config) {
-			.guest_cid	= guest_cid,
-		},
+		.guest_cid		= guest_cid,
 		.vhost_fd		= -1,
 		.kvm			= kvm,
 	};
-- 
2.36.1

