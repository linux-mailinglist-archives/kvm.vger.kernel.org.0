Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185F91187B
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 13:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfEBLtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 07:49:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbfEBLts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 07:49:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5158B3086215;
        Thu,  2 May 2019 11:49:48 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F04F17DDF;
        Thu,  2 May 2019 11:49:38 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-nvme@lists.infradead.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Paul E . McKenney " <paulmck@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liang Cunming <cunming.liang@intel.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        Fam Zheng <fam@euphon.net>, Amnon Ilan <ailan@redhat.com>,
        John Ferlan <jferlan@redhat.com>
Subject: [PATCH v2 10/10] nvme/mdev - generic block IO code
Date:   Thu,  2 May 2019 14:48:01 +0300
Message-Id: <20190502114801.23116-11-mlevitsk@redhat.com>
In-Reply-To: <20190502114801.23116-1-mlevitsk@redhat.com>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 02 May 2019 11:49:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the block layer (bio_submit) to pass through the IO to the nvme driver
instead of the direct IO submission hooks.

Currently that code supports only read/write, and it still assumes that
we talk to an nvme driver.


Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/nvme/mdev/Kconfig |   8 ++
 drivers/nvme/mdev/host.c  | 239 +++++++++++++++++++++++++++++++++++++-
 drivers/nvme/mdev/io.c    |   7 ++
 drivers/nvme/mdev/priv.h  |  61 ++++++++++
 4 files changed, 313 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/mdev/Kconfig b/drivers/nvme/mdev/Kconfig
index 7ebc66cdeac0..1ace298a364d 100644
--- a/drivers/nvme/mdev/Kconfig
+++ b/drivers/nvme/mdev/Kconfig
@@ -14,3 +14,11 @@ config NVME_MDEV_VFIO
 	  guest, also as a NVME namespace, attached to a virtual NVME
 	  controller
 	  If unsure, say N.
+
+config NVME_MDEV_VFIO_GENERIC_IO
+	bool "Use generic block layer IO"
+	depends on NVME_MDEV_VFIO
+	help
+	  Send the IO through the block layer using polled IO queues,
+	  instead of dedicated mdev queues
+	  If unsure, say N.
diff --git a/drivers/nvme/mdev/host.c b/drivers/nvme/mdev/host.c
index 6590946b86c2..a2ba69dcf4f2 100644
--- a/drivers/nvme/mdev/host.c
+++ b/drivers/nvme/mdev/host.c
@@ -53,6 +53,7 @@ static struct nvme_mdev_hctrl *nvme_mdev_hctrl_create(struct nvme_ctrl *ctrl)
 	if (!hctrl)
 		return NULL;
 
+#ifndef CONFIG_NVME_MDEV_VFIO_GENERIC_IO
 	nr_host_queues = ctrl->ops->ext_queues_available(ctrl);
 	max_lba_transfer = ctrl->max_hw_sectors >> (PAGE_SHIFT - 9);
 
@@ -63,6 +64,15 @@ static struct nvme_mdev_hctrl *nvme_mdev_hctrl_create(struct nvme_ctrl *ctrl)
 		return NULL;
 	}
 
+	hctrl->oncs = ctrl->oncs &
+		(NVME_CTRL_ONCS_DSM | NVME_CTRL_ONCS_WRITE_ZEROES);
+#else
+	/* for now don't deal with bio chaining */
+	max_lba_transfer = BIO_MAX_PAGES;
+	nr_host_queues = MDEV_NVME_NUM_BIO_QUEUES;
+	/* for now no support for write zeros and discard*/
+	hctrl->oncs = 0;
+#endif
 
 	kref_init(&hctrl->ref);
 	mutex_init(&hctrl->lock);
@@ -70,8 +80,6 @@ static struct nvme_mdev_hctrl *nvme_mdev_hctrl_create(struct nvme_ctrl *ctrl)
 	hctrl->nvme_ctrl = ctrl;
 	nvme_get_ctrl(ctrl);
 
-	hctrl->oncs = ctrl->oncs &
-		(NVME_CTRL_ONCS_DSM | NVME_CTRL_ONCS_WRITE_ZEROES);
 
 	hctrl->id = ctrl->instance;
 	hctrl->node = dev_to_node(ctrl->dev);
@@ -200,6 +208,8 @@ bool nvme_mdev_hctrl_hq_check_op(struct nvme_mdev_hctrl *hctrl, u8 optcode)
 	}
 }
 
+#ifndef CONFIG_NVME_MDEV_VFIO_GENERIC_IO
+
 /* Allocate a host IO queue */
 int nvme_mdev_hctrl_hq_alloc(struct nvme_mdev_hctrl *hctrl)
 {
@@ -228,6 +238,7 @@ bool nvme_mdev_hctrl_hq_can_submit(struct nvme_mdev_hctrl *hctrl, u16 qid)
 
 /* Submit a IO passthrough command */
 int nvme_mdev_hctrl_hq_submit(struct nvme_mdev_hctrl *hctrl,
+			      struct nvme_mdev_vns *vns,
 			      u16 qid, u32 tag,
 			      struct nvme_command *cmd,
 			      struct nvme_ext_data_iter *datait)
@@ -248,6 +259,226 @@ int nvme_mdev_hctrl_hq_poll(struct nvme_mdev_hctrl *hctrl,
 	return ctrl->ops->ext_queue_poll(ctrl, qid, results, max_len);
 }
 
+#else
+
+/* Allocate a 'host' queue - here the queues are virtual*/
+int nvme_mdev_hctrl_hq_alloc(struct nvme_mdev_hctrl *hctrl)
+{
+	int qid, ret;
+	struct hw_mbio_queue *hwq;
+
+	for (qid = 0 ; qid < MDEV_NVME_NUM_BIO_QUEUES ; qid++)
+		if (!hctrl->hw_queues[qid])
+			break;
+
+	if (qid == MDEV_NVME_NUM_BIO_QUEUES)
+		return -ENOSPC;
+
+	hwq = kzalloc_node(sizeof(*hwq), GFP_KERNEL, hctrl->node);
+	if (!hwq)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&hwq->bios_in_flight);
+
+	ret = bioset_init(&hwq->bioset, MDEV_NVME_BIO_QUEUE_SIZE,
+			  offsetof(struct mbio, bio), BIOSET_NEED_BVECS);
+
+	if (ret < 0) {
+		kfree(hwq);
+		return ret;
+	}
+
+	hctrl->hw_queues[qid] = hwq;
+	return qid + 1;
+}
+
+/* Free a 'host' queue - here the queues are virtual*/
+void nvme_mdev_hctrl_hq_free(struct nvme_mdev_hctrl *hctrl, u16 qid)
+{
+	struct hw_mbio_queue *hwq = hctrl->hw_queues[qid - 1];
+
+	if (WARN_ON(!hwq))
+		return;
+
+	WARN_ON(!list_empty(&hwq->bios_in_flight));
+	WARN_ON(hwq->inflight);
+
+	hctrl->hw_queues[qid - 1] = NULL;
+	bioset_exit(&hwq->bioset);
+	kfree(hwq);
+}
+
+/*
+ * Check if the host queue has space for submission - also our limit
+ * not related to the block layer
+ */
+bool nvme_mdev_hctrl_hq_can_submit(struct nvme_mdev_hctrl *hctrl, u16 qid)
+{
+	struct hw_mbio_queue *hwq = hctrl->hw_queues[qid - 1];
+
+	if (WARN_ON(!hwq))
+		return false;
+	return hwq->inflight < MDEV_NVME_BIO_QUEUE_SIZE;
+}
+
+/*
+ * Callback we get from the block layer
+ * Note that despite polling, this can be run from IRQ context
+ */
+static void nvme_mdev_hctrl_bio_done(struct bio *bio)
+{
+	struct mbio *mbio = container_of(bio, struct mbio, bio);
+
+	/* this will mark this bio as done, and allow the polling thread
+	 * to return it to the user
+	 */
+	mbio->status = nvme_mdev_translate_error_block(bio->bi_status);
+}
+
+/* Submit a IO passthrough command */
+int nvme_mdev_hctrl_hq_submit(struct nvme_mdev_hctrl *hctrl,
+			      struct nvme_mdev_vns *vns,
+			      u16 qid, u32 tag,
+			      struct nvme_command *cmd,
+			      struct nvme_ext_data_iter *datait)
+{
+	struct hw_mbio_queue *hwq = hctrl->hw_queues[qid - 1];
+	struct bio *bio = NULL;
+	struct mbio *mbio;
+	struct page *page;
+	u8 opcode = cmd->common.opcode;
+	int retval, op, op_flags = 0;
+	int offset;
+
+	if (WARN_ON(!hwq))
+		return -EINVAL;
+	if (WARN_ON(hwq->inflight >= MDEV_NVME_BIO_QUEUE_SIZE))
+		return -EBUSY;
+
+	/* read/write buffer processing */
+	if (opcode == nvme_cmd_read || opcode == nvme_cmd_write) {
+		unsigned long datalength =
+			(le16_to_cpu(cmd->rw.length) + 1) << vns->blksize_shift;
+
+		if (opcode == nvme_cmd_read) {
+			op = REQ_OP_READ;
+		} else {
+			op = REQ_OP_WRITE;
+			op_flags = REQ_SYNC | REQ_IDLE;
+			if (cmd->rw.control & cpu_to_le16(NVME_RW_FUA))
+				op_flags |= REQ_FUA;
+		}
+
+		if (WARN_ON(datait->count > BIO_MAX_PAGES))
+			return -EINVAL;
+
+		bio = bio_alloc_bioset(GFP_KERNEL, datait->count, &hwq->bioset);
+		if (WARN_ON(!bio))
+			return -ENOMEM;
+
+		mbio = container_of(bio, struct mbio, bio);
+
+		/* starting sector */
+		bio->bi_iter.bi_sector = le64_to_cpu(cmd->rw.slba) <<
+				(vns->blksize_shift - 9);
+
+		/* Data. Last page might be partial size*/
+		while (datait->count) {
+			int chunk = min(PAGE_SIZE, datalength);
+
+			if (WARN_ON(datalength == 0))
+				break;
+
+			page = pfn_to_page(PHYS_PFN(datait->physical));
+			offset = OFFSET_IN_PAGE(datait->physical);
+
+			if (bio_add_page(&mbio->bio, page,
+					 chunk, offset) != chunk) {
+				WARN_ON(1);
+				retval = -ENOMEM;
+				goto error;
+			}
+
+			retval = datait->next(datait);
+			if (WARN_ON(retval))
+				goto error;
+			datalength -= chunk;
+		}
+
+	/* flush request */
+	} else if (opcode == nvme_cmd_flush) {
+		op = REQ_OP_WRITE;
+		op_flags = REQ_PREFLUSH;
+		bio = bio_alloc_bioset(GFP_KERNEL, 0, &hwq->bioset);
+		if (WARN_ON(!bio))
+			return -ENOMEM;
+		mbio = container_of(bio, struct mbio, bio);
+	} else {
+		retval =  -EINVAL;
+		goto error;
+	}
+
+	/* set polling */
+	op_flags |= REQ_HIPRI | REQ_NOWAIT;
+
+	/* setup the bio */
+	bio_set_dev(bio, vns->host_part);
+	bio->bi_end_io = nvme_mdev_hctrl_bio_done;
+	bio_set_op_attrs(bio, op, op_flags);
+
+	/* setup our portion of the bio*/
+	mbio = container_of(bio, struct mbio, bio);
+	mbio->tag = tag;
+	mbio->status = NVME_STATUS_PENDING;
+	mbio->blk_queue = bdev_get_queue(vns->host_part);
+
+	/* submit the bio*/
+	mbio->cookie = submit_bio(bio);
+
+	list_add_tail(&mbio->link, &hwq->bios_in_flight);
+	hwq->inflight++;
+	return 0;
+error:
+	if (bio)
+		bio_put(bio);
+	return retval;
+}
+
+/* Poll for completion of IO passthrough commands */
+int nvme_mdev_hctrl_hq_poll(struct nvme_mdev_hctrl *hctrl,
+			    u32 qid,
+			    struct nvme_ext_cmd_result *results,
+			    unsigned int max_len)
+{
+	struct hw_mbio_queue *hwq = hctrl->hw_queues[qid - 1];
+	struct mbio *mbio, *tmp;
+
+	int i = 0;
+
+	if (!hwq->inflight)
+		return -1;
+
+	list_for_each_entry_safe(mbio, tmp, &hwq->bios_in_flight, link) {
+		if (mbio->status == NVME_STATUS_PENDING)
+			blk_poll(mbio->blk_queue, mbio->cookie, false);
+
+		if (mbio->status == NVME_STATUS_PENDING)
+			continue;
+
+		results[i].tag = mbio->tag;
+		results[i].status = mbio->status;
+
+		hwq->inflight--;
+		list_del(&mbio->link);
+		bio_put(&mbio->bio);
+
+		if (++i == max_len)
+			break;
+	}
+	return i;
+}
+#endif
+
 /* Destroy all host controllers */
 void nvme_mdev_hctrl_destroy_all(void)
 {
@@ -486,6 +717,10 @@ static int __init nvme_mdev_init(void)
 	}
 
 	pr_info("nvme_mdev " NVME_MDEV_FIRMWARE_VERSION " loaded\n");
+
+#ifdef CONFIG_NVME_MDEV_VFIO_GENERIC_IO
+	pr_info("nvme_mdev: using block layer polled IO\b");
+#endif
 	return 0;
 }
 
diff --git a/drivers/nvme/mdev/io.c b/drivers/nvme/mdev/io.c
index 39550d0e3649..d3c46de33b01 100644
--- a/drivers/nvme/mdev/io.c
+++ b/drivers/nvme/mdev/io.c
@@ -70,7 +70,11 @@ static int nvme_mdev_io_translate_rw(struct io_ctx *ctx)
 	if (!check_range(slba, length, ctx->ns->ns_size))
 		return DNR(NVME_SC_LBA_RANGE);
 
+#ifndef CONFIG_NVME_MDEV_VFIO_GENERIC_IO
 	ctx->out.rw.slba = cpu_to_le64(slba + ctx->ns->host_lba_offset);
+#else
+	ctx->out.rw.slba = in->slba;
+#endif
 	ctx->out.rw.length = in->length;
 
 	ret = nvme_mdev_udata_iter_set_dptr(&ctx->udatait, &in->dptr,
@@ -195,7 +199,9 @@ static int nvme_mdev_io_translate_dsm(struct io_ctx *ctx)
 		_DBG(ctx->vctrl, "IOQ: DSM_MANAGEMENT: RANGE 0x%llx-0x%x\n",
 		     slba, nlb);
 
+#ifndef CONFIG_NVME_MDEV_VFIO_GENERIC_IO
 		data_ptr[i].slba = cpu_to_le64(slba + ctx->ns->host_lba_offset);
+#endif
 	}
 
 	ctx->out.dsm.attributes = in->attributes;
@@ -280,6 +286,7 @@ static bool nvme_mdev_io_process_sq(struct io_ctx *ctx, u16 sqid)
 
 	/*passthrough*/
 	ret = nvme_mdev_hctrl_hq_submit(ctx->hctrl,
+					ctx->ns,
 					vsq->hsq,
 					(((u32)vsq->qid) << 16) | ((u32)ucid),
 					&ctx->out,
diff --git a/drivers/nvme/mdev/priv.h b/drivers/nvme/mdev/priv.h
index a11a1842957d..1dd5fce0bfa6 100644
--- a/drivers/nvme/mdev/priv.h
+++ b/drivers/nvme/mdev/priv.h
@@ -34,7 +34,12 @@
 #define MAX_VIRTUAL_NAMESPACES 16 /* NSID = 1..16*/
 #define MAX_VIRTUAL_IRQS 16
 
+#ifndef CONFIG_NVME_MDEV_VFIO_GENERIC_IO
 #define MAX_HOST_QUEUES 4
+#else
+#define MAX_HOST_QUEUES 1
+#endif
+
 #define MAX_AER_COMMANDS 16
 #define MAX_LOG_PAGES 16
 
@@ -323,6 +328,39 @@ struct nvme_mdev_inst_type {
 	struct attribute_group *attrgroup;
 };
 
+#ifdef CONFIG_NVME_MDEV_VFIO_GENERIC_IO
+
+#define MDEV_NVME_BIO_QUEUE_SIZE 128
+#define NVME_STATUS_PENDING 0xFFFF
+#define MDEV_NVME_NUM_BIO_QUEUES 16
+
+struct mbio {
+	/* link in a list of pending bios*/
+	struct list_head link;
+
+	struct request_queue *blk_queue;
+
+	/*GDPR compliant*/
+	unsigned int cookie;
+
+	/* tag from the translation (user cid + user qid) */
+	u32 tag;
+
+	/* result NVME status */
+	u16 status;
+
+	/* must be last for bioset allocation*/
+	struct bio bio;
+};
+
+struct hw_mbio_queue {
+	int inflight;
+	struct list_head bios_in_flight;
+	struct bio_set bioset;
+};
+
+#endif
+
 /*Abstraction of the host controller that we are connected to */
 struct nvme_mdev_hctrl {
 	struct mutex lock;
@@ -344,6 +382,10 @@ struct nvme_mdev_hctrl {
 
 	/* book-keeping for number of host queues we can allocate*/
 	unsigned int nr_host_queues;
+
+#ifdef CONFIG_NVME_MDEV_VFIO_GENERIC_IO
+	struct hw_mbio_queue *hw_queues[MDEV_NVME_NUM_BIO_QUEUES];
+#endif
 };
 
 /* vctrl.c*/
@@ -415,6 +457,7 @@ bool nvme_mdev_hctrl_hq_can_submit(struct nvme_mdev_hctrl *hctrl, u16 qid);
 bool nvme_mdev_hctrl_hq_check_op(struct nvme_mdev_hctrl *hctrl, u8 optcode);
 
 int nvme_mdev_hctrl_hq_submit(struct nvme_mdev_hctrl *hctrl,
+			      struct nvme_mdev_vns *vns,
 			      u16 qid, u32 tag,
 			      struct nvme_command *cmd,
 			      struct nvme_ext_data_iter *datait);
@@ -701,6 +744,24 @@ static inline int nvme_mdev_translate_error(int error)
 	}
 }
 
+static inline int nvme_mdev_translate_error_block(blk_status_t blk_sts)
+{
+	switch (blk_sts) {
+	case BLK_STS_OK:
+		return NVME_SC_SUCCESS;
+	case BLK_STS_NOSPC:
+		return DNR(NVME_SC_CAP_EXCEEDED);
+	case BLK_STS_TARGET:
+		return DNR(NVME_SC_LBA_RANGE);
+	case BLK_STS_NOTSUPP:
+		return DNR(NVME_SC_INVALID_OPCODE);
+	case BLK_STS_MEDIUM:
+		return DNR(NVME_SC_ACCESS_DENIED);
+	default:
+		return DNR(NVME_SC_INTERNAL);
+	}
+}
+
 static inline bool timeout(ktime_t event, ktime_t now, unsigned long timeout_ms)
 {
 	return ktime_ms_delta(now, event) > (long)timeout_ms;
-- 
2.17.2

