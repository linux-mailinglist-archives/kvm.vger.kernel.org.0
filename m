Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7A81F1940
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgFHMxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:53:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42771 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729680AbgFHMxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 08:53:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dyvL3TJdoghmFE7taHXWfXC0TleKg1Dbjs9VDE83TZ8=;
        b=BYvmr1UQHFs06SSSmg1gsc0PmwtfGWrLpg88SoV5YPqB95RPfjApgFxfK5PAXtUmFndvvc
        fOnRmmHZofbqm4voWNi8GDGBUOoroMzPyqRpddj5tlEFNJPCIPLLJlCmOCICGGPjRxWyln
        KmmptyKz81LkrBC72Z0SSd5xpitIUbg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-KYxnFtmANsyAOyy3jyXzaA-1; Mon, 08 Jun 2020 08:53:14 -0400
X-MC-Unique: KYxnFtmANsyAOyy3jyXzaA-1
Received: by mail-wr1-f71.google.com with SMTP id t5so7100452wro.20
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 05:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dyvL3TJdoghmFE7taHXWfXC0TleKg1Dbjs9VDE83TZ8=;
        b=hhOyQEq21qDyoXt5zl7+jqq/BUpTm4VG8b6qxXknHPo4z6JOnB2vSmFNpWg6bHGEXR
         lfbhAWEeBKEJVuwi7LY4IdSoDvHV9bG5TINbto+n76fjsYjd8qzvhIOX57ZY9F+qTaS1
         IfIcIJPoTpaageUfxChBqOAMqNM32A3VCAeJYdfsItaZuVpo72ZcHQpqqDzDfqIEivLW
         byhiE399GAZLYSF1It9BSF2lSj1xZy2lRDzqAwSYGXglg9zyx55s8pdYgX+XnNXFC+nf
         3q1cfpFvNE8KVOCEWc71RnzlYWJnhMUFttirAlzFru7ehDk/QlHj0895xDWkzzTFobhr
         H1vw==
X-Gm-Message-State: AOAM533XGTPfx6cO2wYgL6c1lEwIsTPR+5Ls/lQZHKf7QaySQ24jl8kk
        jYkXFcvHf5Kof/9dGqw7O+sSGkJLrf7oC9we26SyunUgv2za5sy+fu+3HS2rtey4gyq08QEXh3J
        qBfHjVyTh7abV
X-Received: by 2002:a1c:e057:: with SMTP id x84mr11558971wmg.160.1591620793223;
        Mon, 08 Jun 2020 05:53:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqwMNkCKTETN7JGC4nwscfaMZU/pGcpvDzTqjt0cctLuLGHFIzQ7M89IPA0fnMBjuzyXlRPQ==
X-Received: by 2002:a1c:e057:: with SMTP id x84mr11558941wmg.160.1591620792903;
        Mon, 08 Jun 2020 05:53:12 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id o6sm2030284wmc.39.2020.06.08.05.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:53:12 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:53:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH RFC v6 09/11] vhost/scsi: switch to buf APIs
Message-ID: <20200608125238.728563-10-mst@redhat.com>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Switch to buf APIs. Doing this exposes a spec violation in vhost scsi:
all used bufs are marked with length 0.
Fix that is left for another day.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/scsi.c | 73 ++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 29 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0cbaa0b3893d..a5cdd4c01a3a 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -71,8 +71,8 @@ struct vhost_scsi_inflight {
 };
 
 struct vhost_scsi_cmd {
-	/* Descriptor from vhost_get_vq_desc() for virt_queue segment */
-	int tvc_vq_desc;
+	/* Descriptor from vhost_get_avail_buf() for virt_queue segment */
+	struct vhost_buf tvc_vq_desc;
 	/* virtio-scsi initiator task attribute */
 	int tvc_task_attr;
 	/* virtio-scsi response incoming iovecs */
@@ -213,7 +213,7 @@ struct vhost_scsi {
  * Context for processing request and control queue operations.
  */
 struct vhost_scsi_ctx {
-	int head;
+	struct vhost_buf buf;
 	unsigned int out, in;
 	size_t req_size, rsp_size;
 	size_t out_size, in_size;
@@ -443,6 +443,20 @@ static int vhost_scsi_check_stop_free(struct se_cmd *se_cmd)
 	return target_put_sess_cmd(se_cmd);
 }
 
+/* Signal to guest that request finished with no input buffer. */
+/* TODO calling this when writing into buffer and most likely a bug */
+static void vhost_scsi_signal_noinput(struct vhost_dev *vdev,
+				      struct vhost_virtqueue *vq,
+				      struct vhost_buf *bufp)
+{
+	struct vhost_buf buf = *bufp;
+
+	buf.in_len = 0;
+	vhost_put_used_buf(vq, &buf);
+	vhost_signal(vdev, vq);
+}
+
+
 static void
 vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 {
@@ -450,7 +464,8 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	struct virtio_scsi_event *event = &evt->event;
 	struct virtio_scsi_event __user *eventp;
 	unsigned out, in;
-	int head, ret;
+	struct vhost_buf buf;
+	int ret;
 
 	if (!vhost_vq_get_backend(vq)) {
 		vs->vs_events_missed = true;
@@ -459,14 +474,14 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 
 again:
 	vhost_disable_notify(&vs->dev, vq);
-	head = vhost_get_vq_desc(vq, vq->iov,
-			ARRAY_SIZE(vq->iov), &out, &in,
-			NULL, NULL);
-	if (head < 0) {
+	ret = vhost_get_avail_buf(vq, &buf,
+				  vq->iov, ARRAY_SIZE(vq->iov), &out, &in,
+				  NULL, NULL);
+	if (ret < 0) {
 		vs->vs_events_missed = true;
 		return;
 	}
-	if (head == vq->num) {
+	if (!ret) {
 		if (vhost_enable_notify(&vs->dev, vq))
 			goto again;
 		vs->vs_events_missed = true;
@@ -488,7 +503,7 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	eventp = vq->iov[out].iov_base;
 	ret = __copy_to_user(eventp, event, sizeof(*event));
 	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+		vhost_scsi_signal_noinput(&vs->dev, vq, &buf);
 	else
 		vq_err(vq, "Faulted on vhost_scsi_send_event\n");
 }
@@ -549,7 +564,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
 			struct vhost_scsi_virtqueue *q;
-			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
+			vhost_put_used_buf(cmd->tvc_vq, &cmd->tvc_vq_desc);
 			q = container_of(cmd->tvc_vq, struct vhost_scsi_virtqueue, vq);
 			vq = q - vs->vqs;
 			__set_bit(vq, signal);
@@ -793,7 +808,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 static void
 vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 			   struct vhost_virtqueue *vq,
-			   int head, unsigned out)
+			   struct vhost_buf *buf, unsigned out)
 {
 	struct virtio_scsi_cmd_resp __user *resp;
 	struct virtio_scsi_cmd_resp rsp;
@@ -804,7 +819,7 @@ vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 	resp = vq->iov[out].iov_base;
 	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
 	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+		vhost_scsi_signal_noinput(&vs->dev, vq, buf);
 	else
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
@@ -813,21 +828,21 @@ static int
 vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 		    struct vhost_scsi_ctx *vc)
 {
-	int ret = -ENXIO;
+	int r, ret = -ENXIO;
 
-	vc->head = vhost_get_vq_desc(vq, vq->iov,
-				     ARRAY_SIZE(vq->iov), &vc->out, &vc->in,
-				     NULL, NULL);
+	r = vhost_get_avail_buf(vq, &vc->buf,
+				vq->iov, ARRAY_SIZE(vq->iov), &vc->out, &vc->in,
+				NULL, NULL);
 
-	pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
-		 vc->head, vc->out, vc->in);
+	pr_debug("vhost_get_avail_buf: buf: %d, out: %u in: %u\n",
+		 vc->buf.id, vc->out, vc->in);
 
 	/* On error, stop handling until the next kick. */
-	if (unlikely(vc->head < 0))
+	if (unlikely(r < 0))
 		goto done;
 
 	/* Nothing new?  Wait for eventfd to tell us they refilled. */
-	if (vc->head == vq->num) {
+	if (!r) {
 		if (unlikely(vhost_enable_notify(&vs->dev, vq))) {
 			vhost_disable_notify(&vs->dev, vq);
 			ret = -EAGAIN;
@@ -1093,11 +1108,11 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			}
 		}
 		/*
-		 * Save the descriptor from vhost_get_vq_desc() to be used to
+		 * Save the descriptor from vhost_get_avail_buf() to be used to
 		 * complete the virtio-scsi request in TCM callback context via
 		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
 		 */
-		cmd->tvc_vq_desc = vc.head;
+		cmd->tvc_vq_desc = vc.buf;
 		/*
 		 * Dispatch cmd descriptor for cmwq execution in process
 		 * context provided by vhost_scsi_workqueue.  This also ensures
@@ -1117,7 +1132,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc.buf, vc.out);
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
@@ -1139,9 +1154,9 @@ vhost_scsi_send_tmf_reject(struct vhost_scsi *vs,
 	iov_iter_init(&iov_iter, READ, &vq->iov[vc->out], vc->in, sizeof(rsp));
 
 	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
-	if (likely(ret == sizeof(rsp)))
-		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
-	else
+	if (likely(ret == sizeof(rsp))) {
+		vhost_scsi_signal_noinput(&vs->dev, vq, &vc->buf);
+	} else
 		pr_err("Faulted on virtio_scsi_ctrl_tmf_resp\n");
 }
 
@@ -1162,7 +1177,7 @@ vhost_scsi_send_an_resp(struct vhost_scsi *vs,
 
 	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
 	if (likely(ret == sizeof(rsp)))
-		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
+		vhost_scsi_signal_noinput(&vs->dev, vq, &vc->buf);
 	else
 		pr_err("Faulted on virtio_scsi_ctrl_an_resp\n");
 }
@@ -1269,7 +1284,7 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc.buf, vc.out);
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
-- 
MST

