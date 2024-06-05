Return-Path: <kvm+bounces-18893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C3238FCC9A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 14:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C7081F22C40
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD1D1BE227;
	Wed,  5 Jun 2024 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVM57fu2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F12419AD6D;
	Wed,  5 Jun 2024 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588588; cv=none; b=u4FgeLBw9Wtx9j4DAq2WlbQovH+IvdzQIKJhp3CfrAhqSDdyzh8VAkzedANALhRDe3Acb/+LRV1iXHsl15mAZr5ZTHO3xLrzlzzeYdMQ2R3KjcZfkEOUHfzY5mAZvCJw2bxp/nkj+3fGIm9KQ8EGxFGZkANkbFhS4yb/Qn5Y+Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588588; c=relaxed/simple;
	bh=SjwhFhT8i8cJyN+LotTWnGQb2FKVkJ8FhSqvcrbVnVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYiJc1K5cC1X75PjAx54l+rXsdsX80rPmEa+C1UwJYqbsUMiOfkOjSqql9SUnczl2FeQ3GuRXOvEkgiZoaqB2gorRx6iG8i3DzWc5nDEu2x5KcGVj3zzp2t5uV6Xt89Si9jAwU6/NJi4zSFtYMYo6aouSSJI0oeVD8rVFxB597o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVM57fu2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7E6C4AF08;
	Wed,  5 Jun 2024 11:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717588587;
	bh=SjwhFhT8i8cJyN+LotTWnGQb2FKVkJ8FhSqvcrbVnVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVM57fu2/NiNtxLzW9gEfkyruNTGrQd9YE5cWwGLXvBQ6eXiLsMTkXcTSw+gmPBl5
	 UqkAMIDoLAwu7ceUEbqmH9x/qp8r9dQPiT0xkHgEq4F7I2Hbn1dJ/IvrALBRiGwr6w
	 sC+BhV9gM2ZXArw5PhQ/6EcVq0mrr1FqDQc8k0Kvhr3Uq4LYxxKZeETBr4bQEg7hJ6
	 1Q9H/sIA/u/sQRQdXx/ygWsr2K+Bxel7ICV6WA23hsSAjWYqFWSWvcOeU6FCnwk8dT
	 LIDsDsgO0exSGQ64L+e6eBc8NG0hXXGyI1PzjBYSbIuF7rCNYTfOTf04gCOk/f59m0
	 Y5cCoxlLZt2sA==
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
Subject: [PATCH AUTOSEL 6.6 4/4] vhost-scsi: Handle vhost_vq_work_queue failures for events
Date: Wed,  5 Jun 2024 07:56:16 -0400
Message-ID: <20240605115619.2965224-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605115619.2965224-1-sashal@kernel.org>
References: <20240605115619.2965224-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.32
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
index abef0619c7901..8f17d29ab7e9c 100644
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


