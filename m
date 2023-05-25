Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A620E710E8D
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 16:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbjEYOsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 10:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbjEYOsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 10:48:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 249ED187
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 07:48:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C84C15BF;
        Thu, 25 May 2023 07:49:21 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDE103F67D;
        Thu, 25 May 2023 07:48:34 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org
Subject: [PATCH kvmtool 2/2] virtio: sanitise virtio endian wrappers
Date:   Thu, 25 May 2023 15:48:27 +0100
Message-Id: <20230525144827.679651-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230525144827.679651-1-andre.przywara@arm.com>
References: <20230525144827.679651-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In virtio/scsi.c we had a small hack to avoid compiler warnings when not
using cross-endian support: we were assigning a variable to itself.
This upsets clang:
virtio/scsi.c:63:7: error: explicitly assigning value of variable of type
	'struct virtio_device *' to itself [-Werror,-Wself-assign]
This hack was needed because we use *macros* to do the endianess
conversion, and for architectures like x86 the "dev" argument was removed
from the code.

Provide the endianess conversion functions as inline functions, which do
not suffer from the unused problem.
This requires to isolate the "endian" parameter, because there were
*two* different structures used as the first argument(virtio_device and
virt_queue), *both* with an identically defined "endian" member.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/virtio.h | 53 ++++++++++++++++++++++++++------------------
 virtio/9p.c          |  2 +-
 virtio/blk.c         |  8 +++----
 virtio/console.c     |  6 ++---
 virtio/core.c        | 37 ++++++++++++++++---------------
 virtio/net.c         |  6 ++---
 virtio/scsi.c        | 20 ++++++++---------
 7 files changed, 71 insertions(+), 61 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 0e8c7a672..a8bbaf214 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -90,51 +90,62 @@ struct virt_queue {
 
 #if VIRTIO_RING_ENDIAN != VIRTIO_ENDIAN_HOST
 
-static inline __u16 __virtio_g2h_u16(u16 endian, __u16 val)
+static inline u16 virtio_guest_to_host_u16(u16 endian, u16 val)
 {
 	return (endian == VIRTIO_ENDIAN_LE) ? le16toh(val) : be16toh(val);
 }
 
-static inline __u16 __virtio_h2g_u16(u16 endian, __u16 val)
+static inline u16 virtio_host_to_guest_u16(u16 endian, u16 val)
 {
 	return (endian == VIRTIO_ENDIAN_LE) ? htole16(val) : htobe16(val);
 }
 
-static inline __u32 __virtio_g2h_u32(u16 endian, __u32 val)
+static inline u32 virtio_guest_to_host_u32(u16 endian, u32 val)
 {
 	return (endian == VIRTIO_ENDIAN_LE) ? le32toh(val) : be32toh(val);
 }
 
-static inline __u32 __virtio_h2g_u32(u16 endian, __u32 val)
+static inline u32 virtio_host_to_guest_u32(u16 endian, u32 val)
 {
 	return (endian == VIRTIO_ENDIAN_LE) ? htole32(val) : htobe32(val);
 }
 
-static inline __u64 __virtio_g2h_u64(u16 endian, __u64 val)
+static inline u64 virtio_guest_to_host_u64(u16 endian, u64 val)
 {
 	return (endian == VIRTIO_ENDIAN_LE) ? le64toh(val) : be64toh(val);
 }
 
-static inline __u64 __virtio_h2g_u64(u16 endian, __u64 val)
+static inline u64 virtio_host_to_guest_u64(u16 endian, u64 val)
 {
 	return (endian == VIRTIO_ENDIAN_LE) ? htole64(val) : htobe64(val);
 }
 
-#define virtio_guest_to_host_u16(x, v)	__virtio_g2h_u16((x)->endian, (v))
-#define virtio_host_to_guest_u16(x, v)	__virtio_h2g_u16((x)->endian, (v))
-#define virtio_guest_to_host_u32(x, v)	__virtio_g2h_u32((x)->endian, (v))
-#define virtio_host_to_guest_u32(x, v)	__virtio_h2g_u32((x)->endian, (v))
-#define virtio_guest_to_host_u64(x, v)	__virtio_g2h_u64((x)->endian, (v))
-#define virtio_host_to_guest_u64(x, v)	__virtio_h2g_u64((x)->endian, (v))
-
 #else
 
-#define virtio_guest_to_host_u16(x, v)	(v)
-#define virtio_host_to_guest_u16(x, v)	(v)
-#define virtio_guest_to_host_u32(x, v)	(v)
-#define virtio_host_to_guest_u32(x, v)	(v)
-#define virtio_guest_to_host_u64(x, v)	(v)
-#define virtio_host_to_guest_u64(x, v)	(v)
+static inline u16 virtio_guest_to_host_u16(u16 endian, u16 value)
+{
+	return value;
+}
+static inline u16 virtio_host_to_guest_u16(u16 endian, u16 value)
+{
+	return value;
+}
+static inline u32 virtio_guest_to_host_u32(u16 endian, u32 value)
+{
+	return value;
+}
+static inline u32 virtio_host_to_guest_u32(u16 endian, u32 value)
+{
+	return value;
+}
+static inline u64 virtio_guest_to_host_u64(u16 endian, u64 value)
+{
+	return value;
+}
+static inline u64 virtio_host_to_guest_u64(u16 endian, u64 value)
+{
+	return value;
+}
 
 #endif
 
@@ -150,7 +161,7 @@ static inline u16 virt_queue__pop(struct virt_queue *queue)
 	rmb();
 
 	guest_idx = queue->vring.avail->ring[queue->last_avail_idx++ % queue->vring.num];
-	return virtio_guest_to_host_u16(queue, guest_idx);
+	return virtio_guest_to_host_u16(queue->endian, guest_idx);
 }
 
 static inline struct vring_desc *virt_queue__get_desc(struct virt_queue *queue, u16 desc_ndx)
@@ -160,7 +171,7 @@ static inline struct vring_desc *virt_queue__get_desc(struct virt_queue *queue,
 
 static inline bool virt_queue__available(struct virt_queue *vq)
 {
-	u16 last_avail_idx = virtio_host_to_guest_u16(vq, vq->last_avail_idx);
+	u16 last_avail_idx = virtio_host_to_guest_u16(vq->endian, vq->last_avail_idx);
 
 	if (!vq->vring.avail)
 		return 0;
diff --git a/virtio/9p.c b/virtio/9p.c
index b809bcd7f..513164eed 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1393,7 +1393,7 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	struct p9_fid *pfid, *next;
 
 	if (status & VIRTIO__STATUS_CONFIG)
-		p9dev->config->tag_len = virtio_host_to_guest_u16(&p9dev->vdev,
+		p9dev->config->tag_len = virtio_host_to_guest_u16(p9dev->vdev.endian,
 								  p9dev->tag_len);
 
 	if (!(status & VIRTIO__STATUS_STOP))
diff --git a/virtio/blk.c b/virtio/blk.c
index f3c34f318..a58c7452f 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -99,8 +99,8 @@ static void virtio_blk_do_io_request(struct kvm *kvm, struct virt_queue *vq, str
 		return;
 	}
 
-	type = virtio_guest_to_host_u32(vq, req_hdr.type);
-	sector = virtio_guest_to_host_u64(vq, req_hdr.sector);
+	type = virtio_guest_to_host_u32(vq->endian, req_hdr.type);
+	sector = virtio_guest_to_host_u64(vq->endian, req_hdr.sector);
 
 	iovcount += req->in;
 	if (!iov_size(iov, iovcount)) {
@@ -189,8 +189,8 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	if (!(status & VIRTIO__STATUS_CONFIG))
 		return;
 
-	conf->capacity = virtio_host_to_guest_u64(&bdev->vdev, bdev->capacity);
-	conf->seg_max = virtio_host_to_guest_u32(&bdev->vdev, DISK_SEG_MAX);
+	conf->capacity = virtio_host_to_guest_u64(bdev->vdev.endian, bdev->capacity);
+	conf->seg_max = virtio_host_to_guest_u32(bdev->vdev.endian, DISK_SEG_MAX);
 }
 
 static void *virtio_blk_thread(void *dev)
diff --git a/virtio/console.c b/virtio/console.c
index 11a22a983..ebfbaf06d 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -133,9 +133,9 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	if (!(status & VIRTIO__STATUS_CONFIG))
 		return;
 
-	conf->cols = virtio_host_to_guest_u16(&cdev->vdev, 80);
-	conf->rows = virtio_host_to_guest_u16(&cdev->vdev, 24);
-	conf->max_nr_ports = virtio_host_to_guest_u32(&cdev->vdev, 1);
+	conf->cols = virtio_host_to_guest_u16(cdev->vdev.endian, 80);
+	conf->rows = virtio_host_to_guest_u16(cdev->vdev.endian, 24);
+	conf->max_nr_ports = virtio_host_to_guest_u32(cdev->vdev.endian, 1);
 }
 
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
diff --git a/virtio/core.c b/virtio/core.c
index 568243abd..63735fae6 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -53,7 +53,8 @@ int virtio_transport_parser(const struct option *opt, const char *arg, int unset
 
 void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
 {
-	u16 idx = virtio_guest_to_host_u16(queue, queue->vring.used->idx);
+	u16 idx = virtio_guest_to_host_u16(queue->endian,
+					   queue->vring.used->idx);
 
 	/*
 	 * Use wmb to assure that used elem was updated with head and len.
@@ -62,7 +63,7 @@ void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
 	 */
 	wmb();
 	idx += jump;
-	queue->vring.used->idx = virtio_host_to_guest_u16(queue, idx);
+	queue->vring.used->idx = virtio_host_to_guest_u16(queue->endian, idx);
 }
 
 struct vring_used_elem *
@@ -70,12 +71,12 @@ virt_queue__set_used_elem_no_update(struct virt_queue *queue, u32 head,
 				    u32 len, u16 offset)
 {
 	struct vring_used_elem *used_elem;
-	u16 idx = virtio_guest_to_host_u16(queue, queue->vring.used->idx);
+	u16 idx = virtio_guest_to_host_u16(queue->endian, queue->vring.used->idx);
 
 	idx += offset;
 	used_elem	= &queue->vring.used->ring[idx % queue->vring.num];
-	used_elem->id	= virtio_host_to_guest_u32(queue, head);
-	used_elem->len	= virtio_host_to_guest_u32(queue, len);
+	used_elem->id	= virtio_host_to_guest_u32(queue->endian, head);
+	used_elem->len	= virtio_host_to_guest_u32(queue->endian, len);
 
 	return used_elem;
 }
@@ -93,7 +94,7 @@ struct vring_used_elem *virt_queue__set_used_elem(struct virt_queue *queue, u32
 static inline bool virt_desc__test_flag(struct virt_queue *vq,
 					struct vring_desc *desc, u16 flag)
 {
-	return !!(virtio_guest_to_host_u16(vq, desc->flags) & flag);
+	return !!(virtio_guest_to_host_u16(vq->endian, desc->flags) & flag);
 }
 
 /*
@@ -110,7 +111,7 @@ static unsigned next_desc(struct virt_queue *vq, struct vring_desc *desc,
 	if (!virt_desc__test_flag(vq, &desc[i], VRING_DESC_F_NEXT))
 		return max;
 
-	next = virtio_guest_to_host_u16(vq, desc[i].next);
+	next = virtio_guest_to_host_u16(vq->endian, desc[i].next);
 
 	/* Ensure they're not leading us off end of descriptors. */
 	return min(next, max);
@@ -128,16 +129,16 @@ u16 virt_queue__get_head_iov(struct virt_queue *vq, struct iovec iov[], u16 *out
 	desc = vq->vring.desc;
 
 	if (virt_desc__test_flag(vq, &desc[idx], VRING_DESC_F_INDIRECT)) {
-		max = virtio_guest_to_host_u32(vq, desc[idx].len) / sizeof(struct vring_desc);
-		desc = guest_flat_to_host(kvm, virtio_guest_to_host_u64(vq, desc[idx].addr));
+		max = virtio_guest_to_host_u32(vq->endian, desc[idx].len) / sizeof(struct vring_desc);
+		desc = guest_flat_to_host(kvm, virtio_guest_to_host_u64(vq->endian, desc[idx].addr));
 		idx = 0;
 	}
 
 	do {
 		/* Grab the first descriptor, and check it's OK. */
-		iov[*out + *in].iov_len = virtio_guest_to_host_u32(vq, desc[idx].len);
+		iov[*out + *in].iov_len = virtio_guest_to_host_u32(vq->endian, desc[idx].len);
 		iov[*out + *in].iov_base = guest_flat_to_host(kvm,
-							      virtio_guest_to_host_u64(vq, desc[idx].addr));
+							      virtio_guest_to_host_u64(vq->endian, desc[idx].addr));
 		/* If this is an input descriptor, increment that count. */
 		if (virt_desc__test_flag(vq, &desc[idx], VRING_DESC_F_WRITE))
 			(*in)++;
@@ -170,18 +171,18 @@ u16 virt_queue__get_inout_iov(struct kvm *kvm, struct virt_queue *queue,
 	do {
 		u64 addr;
 		desc = virt_queue__get_desc(queue, idx);
-		addr = virtio_guest_to_host_u64(queue, desc->addr);
+		addr = virtio_guest_to_host_u64(queue->endian, desc->addr);
 		if (virt_desc__test_flag(queue, desc, VRING_DESC_F_WRITE)) {
 			in_iov[*in].iov_base = guest_flat_to_host(kvm, addr);
-			in_iov[*in].iov_len = virtio_guest_to_host_u32(queue, desc->len);
+			in_iov[*in].iov_len = virtio_guest_to_host_u32(queue->endian, desc->len);
 			(*in)++;
 		} else {
 			out_iov[*out].iov_base = guest_flat_to_host(kvm, addr);
-			out_iov[*out].iov_len = virtio_guest_to_host_u32(queue, desc->len);
+			out_iov[*out].iov_len = virtio_guest_to_host_u32(queue->endian, desc->len);
 			(*out)++;
 		}
 		if (virt_desc__test_flag(queue, desc, VRING_DESC_F_NEXT))
-			idx = virtio_guest_to_host_u16(queue, desc->next);
+			idx = virtio_guest_to_host_u16(queue->endian, desc->next);
 		else
 			break;
 	} while (1);
@@ -258,13 +259,13 @@ bool virtio_queue__should_signal(struct virt_queue *vq)
 		 * When VIRTIO_RING_F_EVENT_IDX isn't negotiated, interrupt the
 		 * guest if it didn't explicitly request to be left alone.
 		 */
-		return !(virtio_guest_to_host_u16(vq, vq->vring.avail->flags) &
+		return !(virtio_guest_to_host_u16(vq->endian, vq->vring.avail->flags) &
 			 VRING_AVAIL_F_NO_INTERRUPT);
 	}
 
 	old_idx		= vq->last_used_signalled;
-	new_idx		= virtio_guest_to_host_u16(vq, vq->vring.used->idx);
-	event_idx	= virtio_guest_to_host_u16(vq, vring_used_event(&vq->vring));
+	new_idx		= virtio_guest_to_host_u16(vq->endian, vq->vring.used->idx);
+	event_idx	= virtio_guest_to_host_u16(vq->endian, vring_used_event(&vq->vring));
 
 	if (vring_need_event(event_idx, new_idx, old_idx)) {
 		vq->last_used_signalled = new_idx;
diff --git a/virtio/net.c b/virtio/net.c
index 8749ebfea..bc20ce091 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -149,7 +149,7 @@ static void *virtio_net_rx_thread(void *p)
 			 */
 			if (has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF) ||
 			    !ndev->vdev.legacy)
-				hdr->num_buffers = virtio_host_to_guest_u16(vq, num_buffers);
+				hdr->num_buffers = virtio_host_to_guest_u16(vq->endian, num_buffers);
 
 			virt_queue__used_idx_advance(vq, num_buffers);
 
@@ -555,9 +555,9 @@ static void virtio_net_update_endian(struct net_dev *ndev)
 {
 	struct virtio_net_config *conf = &ndev->config;
 
-	conf->status = virtio_host_to_guest_u16(&ndev->vdev,
+	conf->status = virtio_host_to_guest_u16(ndev->vdev.endian,
 						VIRTIO_NET_S_LINK_UP);
-	conf->max_virtqueue_pairs = virtio_host_to_guest_u16(&ndev->vdev,
+	conf->max_virtqueue_pairs = virtio_host_to_guest_u16(ndev->vdev.endian,
 							     ndev->queue_pairs);
 
 	/* Let TAP know about vnet header endianness */
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 893dfe602..9af8a65cc 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -55,21 +55,19 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	struct scsi_dev *sdev = dev;
 	struct virtio_device *vdev = &sdev->vdev;
 	struct virtio_scsi_config *conf = &sdev->config;
+	u16 endian = vdev->endian;
 
 	if (!(status & VIRTIO__STATUS_CONFIG))
 		return;
 
-	/* Avoid warning when endianness helpers are compiled out */
-	vdev = vdev;
-
-	conf->num_queues = virtio_host_to_guest_u32(vdev, NUM_VIRT_QUEUES - 2);
-	conf->seg_max = virtio_host_to_guest_u32(vdev, VIRTIO_SCSI_CDB_SIZE - 2);
-	conf->max_sectors = virtio_host_to_guest_u32(vdev, 65535);
-	conf->cmd_per_lun = virtio_host_to_guest_u32(vdev, 128);
-	conf->sense_size = virtio_host_to_guest_u32(vdev, VIRTIO_SCSI_SENSE_SIZE);
-	conf->cdb_size = virtio_host_to_guest_u32(vdev, VIRTIO_SCSI_CDB_SIZE);
-	conf->max_lun = virtio_host_to_guest_u32(vdev, 16383);
-	conf->event_info_size = virtio_host_to_guest_u32(vdev, sizeof(struct virtio_scsi_event));
+	conf->num_queues = virtio_host_to_guest_u32(endian, NUM_VIRT_QUEUES - 2);
+	conf->seg_max = virtio_host_to_guest_u32(endian, VIRTIO_SCSI_CDB_SIZE - 2);
+	conf->max_sectors = virtio_host_to_guest_u32(endian, 65535);
+	conf->cmd_per_lun = virtio_host_to_guest_u32(endian, 128);
+	conf->sense_size = virtio_host_to_guest_u32(endian, VIRTIO_SCSI_SENSE_SIZE);
+	conf->cdb_size = virtio_host_to_guest_u32(endian, VIRTIO_SCSI_CDB_SIZE);
+	conf->max_lun = virtio_host_to_guest_u32(endian, 16383);
+	conf->event_info_size = virtio_host_to_guest_u32(endian, sizeof(struct virtio_scsi_event));
 }
 
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
-- 
2.25.1

