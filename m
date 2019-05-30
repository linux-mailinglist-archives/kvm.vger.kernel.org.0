Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD042FAEC
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 13:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfE3L2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 07:28:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41562 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfE3L2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 07:28:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so3963693wrm.8;
        Thu, 30 May 2019 04:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0zslCchXkU9/iE2gw3QRd9dcZ6RTFcWD2DAc5YM+PJU=;
        b=l/k58YGHILVSQ3nCQBqu7l0MU9SYbdSF3ri5oKMWxBw/9EO1UR+Zs57slpEHC4BfJw
         ZLELcw/QSBiSq7Jh0wbnj3uynynmL864AH/3COtA/u5hTMo3m0lNJWdhlXUhUlzsYoyy
         fkjjmovfRx2HZJ8Xk3Ouek+ofPuCSXcHfIb1ox3iCCO087iziUEHTXX2t1y/bSb2MFha
         dmUSImR2uxEoiI/vokVk9xaQIPx8ZMP4uYPpd11XhIDf5MoTREoTv9ZPRiHKk2cbyPBx
         EkyUW3hAwsXthKIxjPmtJ8VbMilnfy4XcH6/yRs3m5V2pPOgf663vx7HlIPJOvDRqPHs
         GeCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=0zslCchXkU9/iE2gw3QRd9dcZ6RTFcWD2DAc5YM+PJU=;
        b=Dw8e0whjCLHOSxVSyZ3k84OgOjBv8eb9hvPxODmos0CU1FFeobzASrQk0UzZ3fVHOA
         H4q1uFMc++GrA8ANElCIGzOB2bpjCI6vTdNwj5VJPGgWBvDh4J2aEaYdAecBabMA/Qew
         bT32jXZubQyjBzKxs6oZZHwpZuIUERI8xOJdARN4Xa3MCZpNPQKRM31COE021/fB0+42
         KHXgJuqt8AO84dXNQxnInEmL4tsViX9u0AP3i3V22PpINUYy4h+PdpQdOQLgiS64VjwI
         jI+Z7gjV85atAw2wlxcu1zXt2ib8qodT7BsaLEG8a7OTUdIbN+kwzA9ZL6n7aREmy5kY
         TVLQ==
X-Gm-Message-State: APjAAAWi+wKfNj6IQI0xzLtZF8kZuQpz5MArUSLRmIngElkwn0fgb024
        4794iMGZNsC3mzEGYv1kLp+0wweV
X-Google-Smtp-Source: APXvYqwQ1ZolElu//tR8q8fWIFyB08c1e/wWz3z13PLYJQojuLdZFVZt1KGebgNtncrsD4/yItIvJQ==
X-Received: by 2002:a5d:6389:: with SMTP id p9mr2330104wru.297.1559215695004;
        Thu, 30 May 2019 04:28:15 -0700 (PDT)
Received: from donizetti.redhat.com ([2001:b07:6468:f312:f91e:ffe0:9205:3b26])
        by smtp.gmail.com with ESMTPSA id o14sm2601855wrp.77.2019.05.30.04.28.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 04:28:14 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
Subject: [PATCH 2/2] virtio_scsi: implement request batching
Date:   Thu, 30 May 2019 13:28:11 +0200
Message-Id: <20190530112811.3066-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530112811.3066-1-pbonzini@redhat.com>
References: <20190530112811.3066-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding the command and kicking the virtqueue so far was done one after
another.  Make the kick optional, so that we can take into account SCMD_LAST.
We also need a commit_rqs callback to kick the device if blk-mq aborts
the submission before the last request is reached.

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 8af01777d09c..918c811cea95 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -375,14 +375,7 @@ static void virtscsi_event_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, &vscsi->event_vq, virtscsi_complete_event);
 };
 
-/**
- * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue
- * @vq		: the struct virtqueue we're talking about
- * @cmd		: command structure
- * @req_size	: size of the request buffer
- * @resp_size	: size of the response buffer
- */
-static int virtscsi_add_cmd(struct virtqueue *vq,
+static int __virtscsi_add_cmd(struct virtqueue *vq,
 			    struct virtio_scsi_cmd *cmd,
 			    size_t req_size, size_t resp_size)
 {
@@ -427,17 +420,39 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
 	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, GFP_ATOMIC);
 }
 
-static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
+static void virtscsi_kick_vq(struct virtio_scsi_vq *vq)
+{
+	bool needs_kick;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vq->vq_lock, flags);
+	needs_kick = virtqueue_kick_prepare(vq->vq);
+	spin_unlock_irqrestore(&vq->vq_lock, flags);
+
+	if (needs_kick)
+		virtqueue_notify(vq->vq);
+}
+
+/**
+ * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue, optionally kick it
+ * @vq		: the struct virtqueue we're talking about
+ * @cmd		: command structure
+ * @req_size	: size of the request buffer
+ * @resp_size	: size of the response buffer
+ * @kick	: whether to kick the virtqueue immediately
+ */
+static int virtscsi_add_cmd(struct virtio_scsi_vq *vq,
 			     struct virtio_scsi_cmd *cmd,
-			     size_t req_size, size_t resp_size)
+			     size_t req_size, size_t resp_size,
+			     bool kick)
 {
 	unsigned long flags;
 	int err;
 	bool needs_kick = false;
 
 	spin_lock_irqsave(&vq->vq_lock, flags);
-	err = virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size);
-	if (!err)
+	err = __virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size);
+	if (!err && kick)
 		needs_kick = virtqueue_kick_prepare(vq->vq);
 
 	spin_unlock_irqrestore(&vq->vq_lock, flags);
@@ -502,6 +517,7 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
 	struct virtio_scsi *vscsi = shost_priv(shost);
 	struct virtio_scsi_vq *req_vq = virtscsi_pick_vq_mq(vscsi, sc);
 	struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
+	bool kick;
 	unsigned long flags;
 	int req_size;
 	int ret;
@@ -531,7 +547,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
 		req_size = sizeof(cmd->req.cmd);
 	}
 
-	ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
+	kick = (sc->flags & SCMD_LAST) != 0;
+	ret = virtscsi_add_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd), kick);
 	if (ret == -EIO) {
 		cmd->resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
 		spin_lock_irqsave(&req_vq->vq_lock, flags);
@@ -549,8 +566,8 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 	int ret = FAILED;
 
 	cmd->comp = &comp;
-	if (virtscsi_kick_cmd(&vscsi->ctrl_vq, cmd,
-			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf) < 0)
+	if (virtscsi_add_cmd(&vscsi->ctrl_vq, cmd,
+			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf, true) < 0)
 		goto out;
 
 	wait_for_completion(&comp);
@@ -664,6 +681,13 @@ static int virtscsi_map_queues(struct Scsi_Host *shost)
 	return blk_mq_virtio_map_queues(qmap, vscsi->vdev, 2);
 }
 
+static void virtscsi_commit_rqs(struct Scsi_Host *shost, u16 hwq)
+{
+	struct virtio_scsi *vscsi = shost_priv(shost);
+
+	virtscsi_kick_vq(&vscsi->req_vqs[hwq]);
+}
+
 /*
  * The host guarantees to respond to each command, although I/O
  * latencies might be higher than on bare metal.  Reset the timer
@@ -681,6 +705,7 @@ static struct scsi_host_template virtscsi_host_template = {
 	.this_id = -1,
 	.cmd_size = sizeof(struct virtio_scsi_cmd),
 	.queuecommand = virtscsi_queuecommand,
+	.commit_rqs = virtscsi_commit_rqs,
 	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
-- 
2.21.0

