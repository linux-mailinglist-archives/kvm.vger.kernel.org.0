Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207F154044C
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345422AbiFGRDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345384AbiFGRDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:41 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B6D2FD38
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:37 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84A3614BF;
        Tue,  7 Jun 2022 10:03:37 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 22F0A3F66F;
        Tue,  7 Jun 2022 10:03:35 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 15/24] virtio/blk: Implement VIRTIO_F_ANY_LAYOUT feature
Date:   Tue,  7 Jun 2022 18:02:30 +0100
Message-Id: <20220607170239.120084-16-jean-philippe.brucker@arm.com>
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

The current virtio-block implementation assumes that buffers have a
specific layout (5.2.6.4 "Legacy Interface: Framing Requirements").
Modern virtio removes this layout constraint, so we have to be careful
when reading buffers. Note that since the Linux driver uses the same
layout as the legacy transport, arbitrary layouts were not actually
tested.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/disk-image.h |  3 +-
 disk/core.c              | 26 ++++++++++++++----
 virtio/blk.c             | 59 ++++++++++++++++++++++++++--------------
 3 files changed, 60 insertions(+), 28 deletions(-)

diff --git a/include/kvm/disk-image.h b/include/kvm/disk-image.h
index 27d4f7da..b2123838 100644
--- a/include/kvm/disk-image.h
+++ b/include/kvm/disk-image.h
@@ -88,7 +88,8 @@ ssize_t disk_image__read(struct disk_image *disk, u64 sector, const struct iovec
 				int iovcount, void *param);
 ssize_t disk_image__write(struct disk_image *disk, u64 sector, const struct iovec *iov,
 				int iovcount, void *param);
-ssize_t disk_image__get_serial(struct disk_image *disk, void *buffer, ssize_t *len);
+ssize_t disk_image__get_serial(struct disk_image *disk, struct iovec *iov,
+			       int iovcount, ssize_t len);
 
 struct disk_image *raw_image__probe(int fd, struct stat *st, bool readonly);
 struct disk_image *blkdev__probe(const char *filename, int flags, struct stat *st);
diff --git a/disk/core.c b/disk/core.c
index d8d04cb0..f69095d9 100644
--- a/disk/core.c
+++ b/disk/core.c
@@ -2,6 +2,7 @@
 #include "kvm/qcow.h"
 #include "kvm/virtio-blk.h"
 #include "kvm/kvm.h"
+#include "kvm/iovec.h"
 
 #include <linux/err.h>
 #include <poll.h>
@@ -304,20 +305,33 @@ ssize_t disk_image__write(struct disk_image *disk, u64 sector,
 	return total;
 }
 
-ssize_t disk_image__get_serial(struct disk_image *disk, void *buffer, ssize_t *len)
+ssize_t disk_image__get_serial(struct disk_image *disk, struct iovec *iov,
+			       int iovcount, ssize_t len)
 {
 	struct stat st;
+	void *buf;
 	int r;
 
 	r = fstat(disk->fd, &st);
 	if (r)
 		return r;
 
-	*len = snprintf(buffer, *len, "%llu%llu%llu",
-			(unsigned long long)st.st_dev,
-			(unsigned long long)st.st_rdev,
-			(unsigned long long)st.st_ino);
-	return *len;
+	buf = malloc(len);
+	if (!buf)
+		return -ENOMEM;
+
+	len = snprintf(buf, len, "%llu%llu%llu",
+		       (unsigned long long)st.st_dev,
+		       (unsigned long long)st.st_rdev,
+		       (unsigned long long)st.st_ino);
+	if (len < 0 || (size_t)len > iov_size(iov, iovcount)) {
+		free(buf);
+		return -ENOMEM;
+	}
+
+	memcpy_toiovec(iov, buf, len);
+	free(buf);
+	return len;
 }
 
 void disk_image__set_callback(struct disk_image *disk,
diff --git a/virtio/blk.c b/virtio/blk.c
index b56d45bd..54035af4 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -2,6 +2,7 @@
 
 #include "kvm/virtio-pci-dev.h"
 #include "kvm/disk-image.h"
+#include "kvm/iovec.h"
 #include "kvm/mutex.h"
 #include "kvm/util.h"
 #include "kvm/kvm.h"
@@ -33,6 +34,7 @@ struct blk_dev_req {
 	struct blk_dev			*bdev;
 	struct iovec			iov[VIRTIO_BLK_QUEUE_SIZE];
 	u16				out, in, head;
+	u8				*status;
 	struct kvm			*kvm;
 };
 
@@ -66,7 +68,7 @@ void virtio_blk_complete(void *param, long len)
 	u8 *status;
 
 	/* status */
-	status	= req->iov[req->out + req->in - 1].iov_base;
+	status = req->status;
 	*status	= (len < 0) ? VIRTIO_BLK_S_IOERR : VIRTIO_BLK_S_OK;
 
 	mutex_lock(&bdev->mutex);
@@ -79,46 +81,60 @@ void virtio_blk_complete(void *param, long len)
 
 static void virtio_blk_do_io_request(struct kvm *kvm, struct virt_queue *vq, struct blk_dev_req *req)
 {
-	struct virtio_blk_outhdr *req_hdr;
-	ssize_t block_cnt;
+	struct virtio_blk_outhdr req_hdr;
+	size_t iovcount, last_iov;
 	struct blk_dev *bdev;
 	struct iovec *iov;
-	u16 out, in;
+	ssize_t len;
 	u32 type;
 	u64 sector;
 
-	block_cnt	= -1;
 	bdev		= req->bdev;
 	iov		= req->iov;
-	out		= req->out;
-	in		= req->in;
-	req_hdr		= iov[0].iov_base;
 
-	type = virtio_guest_to_host_u32(vq, req_hdr->type);
-	sector = virtio_guest_to_host_u64(vq, req_hdr->sector);
+	iovcount = req->out;
+	len = memcpy_fromiovec_safe(&req_hdr, &iov, sizeof(req_hdr), &iovcount);
+	if (len) {
+		pr_warning("Failed to get header");
+		return;
+	}
+
+	type = virtio_guest_to_host_u32(vq, req_hdr.type);
+	sector = virtio_guest_to_host_u64(vq, req_hdr.sector);
+
+	iovcount += req->in;
+	if (!iov_size(iov, iovcount)) {
+		pr_warning("Invalid IOV");
+		return;
+	}
+
+	/* Extract status byte from iovec */
+	last_iov = iovcount - 1;
+	while (!iov[last_iov].iov_len)
+		last_iov--;
+	iov[last_iov].iov_len--;
+	req->status = iov[last_iov].iov_base + iov[last_iov].iov_len;
+	if (!iov[last_iov].iov_len)
+		iovcount--;
 
 	switch (type) {
 	case VIRTIO_BLK_T_IN:
-		block_cnt = disk_image__read(bdev->disk, sector,
-				iov + 1, in + out - 2, req);
+		disk_image__read(bdev->disk, sector, iov, iovcount, req);
 		break;
 	case VIRTIO_BLK_T_OUT:
-		block_cnt = disk_image__write(bdev->disk, sector,
-				iov + 1, in + out - 2, req);
+		disk_image__write(bdev->disk, sector, iov, iovcount, req);
 		break;
 	case VIRTIO_BLK_T_FLUSH:
-		block_cnt = disk_image__flush(bdev->disk);
-		virtio_blk_complete(req, block_cnt);
+		len = disk_image__flush(bdev->disk);
+		virtio_blk_complete(req, len);
 		break;
 	case VIRTIO_BLK_T_GET_ID:
-		block_cnt = VIRTIO_BLK_ID_BYTES;
-		disk_image__get_serial(bdev->disk,
-				(iov + 1)->iov_base, &block_cnt);
-		virtio_blk_complete(req, block_cnt);
+		len = disk_image__get_serial(bdev->disk, iov, iovcount,
+					     VIRTIO_BLK_ID_BYTES);
+		virtio_blk_complete(req, len);
 		break;
 	default:
 		pr_warning("request type %d", type);
-		block_cnt	= -1;
 		break;
 	}
 }
@@ -161,6 +177,7 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 		| 1UL << VIRTIO_BLK_F_FLUSH
 		| 1UL << VIRTIO_RING_F_EVENT_IDX
 		| 1UL << VIRTIO_RING_F_INDIRECT_DESC
+		| 1UL << VIRTIO_F_ANY_LAYOUT
 		| (bdev->disk->readonly ? 1UL << VIRTIO_BLK_F_RO : 0);
 }
 
-- 
2.36.1

