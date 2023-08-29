Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68ED878C582
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 15:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbjH2NdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 09:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbjH2NdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 09:33:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21275CF2;
        Tue, 29 Aug 2023 06:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B57461ADB;
        Tue, 29 Aug 2023 13:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6108C433CB;
        Tue, 29 Aug 2023 13:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693315940;
        bh=0Az+LHCJPGUEfjJPi+qmEsRi96zOqUkJJKO1g8HYero=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7UG0EGiTeXArXsarW+8BQr/q4Sy/T6QaqLS2lYWZbXq9S5QLSAp2TTMQTG60MK57
         Y5fAimY5EZhSavAK2700Urcw2yQ09b9zEvp+RKiJ6/ep5dKC3GQWUHVgZMP+Pr2R3D
         /ERCrvGqypKn0YhryIHd8/cTloLd/srs7R5vhyCUHPD0Vbiw1gc8BrwVigzIXD0tzS
         Yke03suLtYQ9rWA4WKldJoVi6YxkaEU5J1sw2r9RiAkSiuTTBcqZCav6o3pkynGx/B
         8VTieQGMBuV7OeYZrjjNOu/ryS0wtnJuQz3tc2zTWPUrP77G9LjIKQZynC/wJXQekK
         5hFwbEWb1ctSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.4 04/17] vhost-scsi: Fix alignment handling with windows
Date:   Tue, 29 Aug 2023 09:31:51 -0400
Message-Id: <20230829133211.519957-4-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230829133211.519957-1-sashal@kernel.org>
References: <20230829133211.519957-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.4.12
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 5ced58bfa132c8ba0f9c893eb621595a84cfee12 ]

The linux block layer requires bios/requests to have lengths with a 512
byte alignment. Some drivers/layers like dm-crypt and the directi IO code
will test for it and just fail. Other drivers like SCSI just assume the
requirement is met and will end up in infinte retry loops. The problem
for drivers like SCSI is that it uses functions like blk_rq_cur_sectors
and blk_rq_sectors which divide the request's length by 512. If there's
lefovers then it just gets dropped. But other code in the block/scsi
layer may use blk_rq_bytes/blk_rq_cur_bytes and end up thinking there is
still data left and try to retry the cmd. We can then end up getting
stuck in retry loops where part of the block/scsi thinks there is data
left, but other parts think we want to do IOs of zero length.

Linux will always check for alignment, but windows will not. When
vhost-scsi then translates the iovec it gets from a windows guest to a
scatterlist, we can end up with sg items where the sg->length is not
divisible by 512 due to the misaligned offset:

sg[0].offset = 255;
sg[0].length = 3841;
sg...
sg[N].offset = 0;
sg[N].length = 255;

When the lio backends then convert the SG to bios or other iovecs, we
end up sending them with the same misaligned values and can hit the
issues above.

This just has us drop down to allocating a temp page and copying the data
when we detect a misaligned buffer and the IO is large enough that it
will get split into multiple bad IOs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20230709202859.138387-2-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 186 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 161 insertions(+), 25 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index bb10fa4bb4f6e..fa19c3f043b12 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -25,6 +25,8 @@
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/miscdevice.h>
+#include <linux/blk_types.h>
+#include <linux/bio.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
@@ -75,6 +77,9 @@ struct vhost_scsi_cmd {
 	u32 tvc_prot_sgl_count;
 	/* Saved unpacked SCSI LUN for vhost_scsi_target_queue_cmd() */
 	u32 tvc_lun;
+	u32 copied_iov:1;
+	const void *saved_iter_addr;
+	struct iov_iter saved_iter;
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
 	struct scatterlist *tvc_prot_sgl;
@@ -328,8 +333,13 @@ static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 	int i;
 
 	if (tv_cmd->tvc_sgl_count) {
-		for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
-			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+		for (i = 0; i < tv_cmd->tvc_sgl_count; i++) {
+			if (tv_cmd->copied_iov)
+				__free_page(sg_page(&tv_cmd->tvc_sgl[i]));
+			else
+				put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+		}
+		kfree(tv_cmd->saved_iter_addr);
 	}
 	if (tv_cmd->tvc_prot_sgl_count) {
 		for (i = 0; i < tv_cmd->tvc_prot_sgl_count; i++)
@@ -502,6 +512,28 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
 	mutex_unlock(&vq->mutex);
 }
 
+static int vhost_scsi_copy_sgl_to_iov(struct vhost_scsi_cmd *cmd)
+{
+	struct iov_iter *iter = &cmd->saved_iter;
+	struct scatterlist *sg = cmd->tvc_sgl;
+	struct page *page;
+	size_t len;
+	int i;
+
+	for (i = 0; i < cmd->tvc_sgl_count; i++) {
+		page = sg_page(&sg[i]);
+		len = sg[i].length;
+
+		if (copy_page_to_iter(page, 0, len, iter) != len) {
+			pr_err("Could not copy data while handling misaligned cmd. Error %zu\n",
+			       len);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 /* Fill in status and signal that we are done processing this command
  *
  * This is scheduled in the vhost work queue so we are called with the owner
@@ -525,15 +557,20 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 
 		pr_debug("%s tv_cmd %p resid %u status %#02x\n", __func__,
 			cmd, se_cmd->residual_count, se_cmd->scsi_status);
-
 		memset(&v_rsp, 0, sizeof(v_rsp));
-		v_rsp.resid = cpu_to_vhost32(cmd->tvc_vq, se_cmd->residual_count);
-		/* TODO is status_qualifier field needed? */
-		v_rsp.status = se_cmd->scsi_status;
-		v_rsp.sense_len = cpu_to_vhost32(cmd->tvc_vq,
-						 se_cmd->scsi_sense_length);
-		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
-		       se_cmd->scsi_sense_length);
+
+		if (cmd->saved_iter_addr && vhost_scsi_copy_sgl_to_iov(cmd)) {
+			v_rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
+		} else {
+			v_rsp.resid = cpu_to_vhost32(cmd->tvc_vq,
+						     se_cmd->residual_count);
+			/* TODO is status_qualifier field needed? */
+			v_rsp.status = se_cmd->scsi_status;
+			v_rsp.sense_len = cpu_to_vhost32(cmd->tvc_vq,
+							 se_cmd->scsi_sense_length);
+			memcpy(v_rsp.sense, cmd->tvc_sense_buf,
+			       se_cmd->scsi_sense_length);
+		}
 
 		iov_iter_init(&iov_iter, ITER_DEST, cmd->tvc_resp_iov,
 			      cmd->tvc_in_iovs, sizeof(v_rsp));
@@ -615,12 +652,12 @@ static int
 vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 		      struct iov_iter *iter,
 		      struct scatterlist *sgl,
-		      bool write)
+		      bool is_prot)
 {
 	struct page **pages = cmd->tvc_upages;
 	struct scatterlist *sg = sgl;
-	ssize_t bytes;
-	size_t offset;
+	ssize_t bytes, mapped_bytes;
+	size_t offset, mapped_offset;
 	unsigned int npages = 0;
 
 	bytes = iov_iter_get_pages2(iter, pages, LONG_MAX,
@@ -629,13 +666,53 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 	if (bytes <= 0)
 		return bytes < 0 ? bytes : -EFAULT;
 
+	mapped_bytes = bytes;
+	mapped_offset = offset;
+
 	while (bytes) {
 		unsigned n = min_t(unsigned, PAGE_SIZE - offset, bytes);
+		/*
+		 * The block layer requires bios/requests to be a multiple of
+		 * 512 bytes, but Windows can send us vecs that are misaligned.
+		 * This can result in bios and later requests with misaligned
+		 * sizes if we have to break up a cmd/scatterlist into multiple
+		 * bios.
+		 *
+		 * We currently only break up a command into multiple bios if
+		 * we hit the vec/seg limit, so check if our sgl_count is
+		 * greater than the max and if a vec in the cmd has a
+		 * misaligned offset/size.
+		 */
+		if (!is_prot &&
+		    (offset & (SECTOR_SIZE - 1) || n & (SECTOR_SIZE - 1)) &&
+		    cmd->tvc_sgl_count > BIO_MAX_VECS) {
+			WARN_ONCE(true,
+				  "vhost-scsi detected misaligned IO. Performance may be degraded.");
+			goto revert_iter_get_pages;
+		}
+
 		sg_set_page(sg++, pages[npages++], n, offset);
 		bytes -= n;
 		offset = 0;
 	}
+
 	return npages;
+
+revert_iter_get_pages:
+	iov_iter_revert(iter, mapped_bytes);
+
+	npages = 0;
+	while (mapped_bytes) {
+		unsigned int n = min_t(unsigned int, PAGE_SIZE - mapped_offset,
+				       mapped_bytes);
+
+		put_page(pages[npages++]);
+
+		mapped_bytes -= n;
+		mapped_offset = 0;
+	}
+
+	return -EINVAL;
 }
 
 static int
@@ -659,25 +736,80 @@ vhost_scsi_calc_sgls(struct iov_iter *iter, size_t bytes, int max_sgls)
 }
 
 static int
-vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, bool write,
-		      struct iov_iter *iter,
-		      struct scatterlist *sg, int sg_count)
+vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
+			   struct scatterlist *sg, int sg_count)
+{
+	size_t len = iov_iter_count(iter);
+	unsigned int nbytes = 0;
+	struct page *page;
+	int i;
+
+	if (cmd->tvc_data_direction == DMA_FROM_DEVICE) {
+		cmd->saved_iter_addr = dup_iter(&cmd->saved_iter, iter,
+						GFP_KERNEL);
+		if (!cmd->saved_iter_addr)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < sg_count; i++) {
+		page = alloc_page(GFP_KERNEL);
+		if (!page) {
+			i--;
+			goto err;
+		}
+
+		nbytes = min_t(unsigned int, PAGE_SIZE, len);
+		sg_set_page(&sg[i], page, nbytes, 0);
+
+		if (cmd->tvc_data_direction == DMA_TO_DEVICE &&
+		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes)
+			goto err;
+
+		len -= nbytes;
+	}
+
+	cmd->copied_iov = 1;
+	return 0;
+
+err:
+	pr_err("Could not read %u bytes while handling misaligned cmd\n",
+	       nbytes);
+
+	for (; i >= 0; i--)
+		__free_page(sg_page(&sg[i]));
+	kfree(cmd->saved_iter_addr);
+	return -ENOMEM;
+}
+
+static int
+vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
+		      struct scatterlist *sg, int sg_count, bool is_prot)
 {
 	struct scatterlist *p = sg;
+	size_t revert_bytes;
 	int ret;
 
 	while (iov_iter_count(iter)) {
-		ret = vhost_scsi_map_to_sgl(cmd, iter, sg, write);
+		ret = vhost_scsi_map_to_sgl(cmd, iter, sg, is_prot);
 		if (ret < 0) {
+			revert_bytes = 0;
+
 			while (p < sg) {
-				struct page *page = sg_page(p++);
-				if (page)
+				struct page *page = sg_page(p);
+
+				if (page) {
 					put_page(page);
+					revert_bytes += p->length;
+				}
+				p++;
 			}
+
+			iov_iter_revert(iter, revert_bytes);
 			return ret;
 		}
 		sg += ret;
 	}
+
 	return 0;
 }
 
@@ -687,7 +819,6 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 		 size_t data_bytes, struct iov_iter *data_iter)
 {
 	int sgl_count, ret;
-	bool write = (cmd->tvc_data_direction == DMA_FROM_DEVICE);
 
 	if (prot_bytes) {
 		sgl_count = vhost_scsi_calc_sgls(prot_iter, prot_bytes,
@@ -700,9 +831,8 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 		pr_debug("%s prot_sg %p prot_sgl_count %u\n", __func__,
 			 cmd->tvc_prot_sgl, cmd->tvc_prot_sgl_count);
 
-		ret = vhost_scsi_iov_to_sgl(cmd, write, prot_iter,
-					    cmd->tvc_prot_sgl,
-					    cmd->tvc_prot_sgl_count);
+		ret = vhost_scsi_iov_to_sgl(cmd, prot_iter, cmd->tvc_prot_sgl,
+					    cmd->tvc_prot_sgl_count, true);
 		if (ret < 0) {
 			cmd->tvc_prot_sgl_count = 0;
 			return ret;
@@ -718,8 +848,14 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 	pr_debug("%s data_sg %p data_sgl_count %u\n", __func__,
 		  cmd->tvc_sgl, cmd->tvc_sgl_count);
 
-	ret = vhost_scsi_iov_to_sgl(cmd, write, data_iter,
-				    cmd->tvc_sgl, cmd->tvc_sgl_count);
+	ret = vhost_scsi_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+				    cmd->tvc_sgl_count, false);
+	if (ret == -EINVAL) {
+		sg_init_table(cmd->tvc_sgl, cmd->tvc_sgl_count);
+		ret = vhost_scsi_copy_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+						 cmd->tvc_sgl_count);
+	}
+
 	if (ret < 0) {
 		cmd->tvc_sgl_count = 0;
 		return ret;
-- 
2.40.1

