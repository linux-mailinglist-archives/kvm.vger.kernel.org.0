Return-Path: <kvm+bounces-23605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB3F94B8E6
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 10:21:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B39CB21AFB
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB0E1898E2;
	Thu,  8 Aug 2024 08:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vj63zg45"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FE1145B0C
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 08:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723105259; cv=none; b=MSZFYM8WW5aw4nOk3HRiDICum3Ti5B5tAcuZGX/oWZ4FkHu/yHqEGkdSRIjcC2bOZYP8b+ilLvlKnQOequ+cMeHMm/FkHBlhbs5aJZqMnO0eToVum93V0RWdZ12/I4PUDQpI3F7kbhf9sUrIA8RtnvDWfPBiI5E2ygcgjdbvBlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723105259; c=relaxed/simple;
	bh=L4QVc0wP7198xEmpO0X7efWPkh+oSVw5VC1I4eAC4Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=opYx//CR1vnSp7DNyf1SaRiniYFNOYBowE6nUzrwagRDbPPH8D2UMC3uAUBLAAdwp5IJ1pkbXXM8nQLG2Bs/8xIDh5xLvhnDgC+8B0Ux4eJzMhAs5gdyvImjl72qlrgSWz0a3PpWGB6RBLBytiz4dqWjJF2m9+XKJVd28IK0dOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vj63zg45; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723105257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gG94da4yH+PQWtMlfckLeFlS4xJDYul1j2UMjM7QZ6w=;
	b=Vj63zg45ks+/VS64BlkkVnkv8HVBF/NylI0IEdQzMhGbhIqe0lCgrjnW9WCY/6O0a0vJA7
	zlabyoClBbwQdydPsuyWf1qSIyCYZBk06J7KXwiv3vwZvlRty3/L0zEXbCE6KORFkuylpJ
	g1HIcYarllvHw8reCu2ZEB2w11IRPN4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-201-L2LIPp_9N2-E-uRSXdAEgg-1; Thu,
 08 Aug 2024 04:20:53 -0400
X-MC-Unique: L2LIPp_9N2-E-uRSXdAEgg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1749F1955F43;
	Thu,  8 Aug 2024 08:20:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.113.0])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7BD3519560A3;
	Thu,  8 Aug 2024 08:20:46 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	dtatulea@nvidia.com
Cc: lingshan.zhu@intel.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] vhost_vdpa: assign irq bypass producer token correctly
Date: Thu,  8 Aug 2024 16:20:44 +0800
Message-ID: <20240808082044.11356-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

We used to call irq_bypass_unregister_producer() in
vhost_vdpa_setup_vq_irq() which is problematic as we don't know if the
token pointer is still valid or not.

Actually, we use the eventfd_ctx as the token so the life cycle of the
token should be bound to the VHOST_SET_VRING_CALL instead of
vhost_vdpa_setup_vq_irq() which could be called by set_status().

Fixing this by setting up  irq bypass producer's token when handling
VHOST_SET_VRING_CALL and un-registering the producer before calling
vhost_vring_ioctl() to prevent a possible use after free as eventfd
could have been released in vhost_vring_ioctl().

Fixes: 2cf1ba9a4d15 ("vhost_vdpa: implement IRQ offloading in vhost_vdpa")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Note for Dragos: Please check whether this fixes your issue. I
slightly test it with vp_vdpa in L2.
---
 drivers/vhost/vdpa.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index e31ec9ebc4ce..388226a48bcc 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -209,11 +209,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	if (irq < 0)
 		return;
 
-	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 	if (!vq->call_ctx.ctx)
 		return;
 
-	vq->call_ctx.producer.token = vq->call_ctx.ctx;
 	vq->call_ctx.producer.irq = irq;
 	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
 	if (unlikely(ret))
@@ -709,6 +707,12 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			vq->last_avail_idx = vq_state.split.avail_index;
 		}
 		break;
+	case VHOST_SET_VRING_CALL:
+		if (vq->call_ctx.ctx) {
+			vhost_vdpa_unsetup_vq_irq(v, idx);
+			vq->call_ctx.producer.token = NULL;
+		}
+		break;
 	}
 
 	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
@@ -747,13 +751,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			cb.callback = vhost_vdpa_virtqueue_cb;
 			cb.private = vq;
 			cb.trigger = vq->call_ctx.ctx;
+			vq->call_ctx.producer.token = vq->call_ctx.ctx;
+			vhost_vdpa_setup_vq_irq(v, idx);
 		} else {
 			cb.callback = NULL;
 			cb.private = NULL;
 			cb.trigger = NULL;
 		}
 		ops->set_vq_cb(vdpa, idx, &cb);
-		vhost_vdpa_setup_vq_irq(v, idx);
 		break;
 
 	case VHOST_SET_VRING_NUM:
@@ -1419,6 +1424,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	for (i = 0; i < nvqs; i++) {
 		vqs[i] = &v->vqs[i];
 		vqs[i]->handle_kick = handle_vq_kick;
+		vqs[i]->call_ctx.ctx = NULL;
 	}
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
-- 
2.31.1


