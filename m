Return-Path: <kvm+bounces-18892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6228FCC8A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 14:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 304D9B213D0
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4DAB1BD029;
	Wed,  5 Jun 2024 11:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRyZuxtJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C300C1BD004;
	Wed,  5 Jun 2024 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588575; cv=none; b=t6wPDKE8rBTPbVVDisKlRy8r22iO5pD8lahVI7BIqY/ZJDqKdpWHSUKxgkOXS69KqpQzHc8gH50ZRXvSevJW+nb6J//33XMJRAbnm1J6rVEVPYZi+F04zEbWvjZcy9uUbkBp5xv6lGwr/zYU0IsuQ1JSbbu6IlYG6jSxpZ3mUpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588575; c=relaxed/simple;
	bh=WTisGYSNvp17ebvku7IcULq8g4QnWshJd8J02Zl6YKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/S8+mEqlO5B0/eTu6jZYpIDj9b2Ucb4GWWjvbIDhx2DWqINjVHI65/Uri5DEoyVGHn1LEOjAzP0c89xBwtPrahuZrwz3i8SFPmSuB5pzgQlJ+0GJBWtjxsdWoZElwO8Ic9sWxcF9VTq3XW8wRaab5pKN1LvopnYOVvjGW0bzXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRyZuxtJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48025C32781;
	Wed,  5 Jun 2024 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717588575;
	bh=WTisGYSNvp17ebvku7IcULq8g4QnWshJd8J02Zl6YKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRyZuxtJH69pJLiu1RgaF0Ebgmf9B2Dz3+Aj2j3jgr38pX30fmgJPEHGKjcO7IHOm
	 pU9HlLYWDTQpop4WqXzBlndjb1vT7+3gO3dk3N/wrvxVbIZk3Ep0f0d+laovXiuaav
	 sdDFT3x+Xxfr79U5qBlanjnjqILpbqqVSEn3aYUXwWT1Yqr8wLEcDuYQ7AOhrC2/G/
	 LObvLPgFYhLflyz+jY9Onczu8OjfXT0gGcii00WVxaS8I6qykVGQhihxc5Lj0/qsdb
	 0jcqYI5QfTBLRRYeQaGuGzXqXATqckiL7xoyIctRHQcv5uIRcmBIfShbvlLAECEV5B
	 MJJnnXr4luJbw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowang@redhat.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.8 6/6] vhost-scsi: Handle vhost_vq_work_queue failures for events
Date: Wed,  5 Jun 2024 07:55:58 -0400
Message-ID: <20240605115602.2964993-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605115602.2964993-1-sashal@kernel.org>
References: <20240605115602.2964993-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.8.12
Content-Transfer-Encoding: 8bit

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit b1b2ce58ed23c5d56e0ab299a5271ac01f95b75c ]

Currently, we can try to queue an event's work before the vhost_task is
created. When this happens we just drop it in vhost_scsi_do_plug before
even calling vhost_vq_work_queue. During a device shutdown we do the
same thing after vhost_scsi_clear_endpoint has cleared the backends.

In the next patches we will be able to kill the vhost_task before we
have cleared the endpoint. In that case, vhost_vq_work_queue can fail
and we will leak the event's memory. This has handle the failure by
just freeing the event. This is safe to do, because
vhost_vq_work_queue will only return failure for us when the vhost_task
is killed and so userspace will not be able to handle events if we
sent them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20240316004707.45557-2-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 282aac45c6909..f34f9895b8984 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -497,10 +497,8 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		vq_err(vq, "Faulted on vhost_scsi_send_event\n");
 }
 
-static void vhost_scsi_evt_work(struct vhost_work *work)
+static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
 {
-	struct vhost_scsi *vs = container_of(work, struct vhost_scsi,
-					vs_event_work);
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct vhost_scsi_evt *evt, *t;
 	struct llist_node *llnode;
@@ -508,12 +506,20 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
 	mutex_lock(&vq->mutex);
 	llnode = llist_del_all(&vs->vs_event_list);
 	llist_for_each_entry_safe(evt, t, llnode, list) {
-		vhost_scsi_do_evt_work(vs, evt);
+		if (!drop)
+			vhost_scsi_do_evt_work(vs, evt);
 		vhost_scsi_free_evt(vs, evt);
 	}
 	mutex_unlock(&vq->mutex);
 }
 
+static void vhost_scsi_evt_work(struct vhost_work *work)
+{
+	struct vhost_scsi *vs = container_of(work, struct vhost_scsi,
+					     vs_event_work);
+	vhost_scsi_complete_events(vs, false);
+}
+
 static int vhost_scsi_copy_sgl_to_iov(struct vhost_scsi_cmd *cmd)
 {
 	struct iov_iter *iter = &cmd->saved_iter;
@@ -1509,7 +1515,8 @@ vhost_scsi_send_evt(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 	}
 
 	llist_add(&evt->list, &vs->vs_event_list);
-	vhost_vq_work_queue(vq, &vs->vs_event_work);
+	if (!vhost_vq_work_queue(vq, &vs->vs_event_work))
+		vhost_scsi_complete_events(vs, true);
 }
 
 static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
-- 
2.43.0


