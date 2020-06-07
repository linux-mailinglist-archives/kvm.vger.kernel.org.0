Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E4D1F0BD6
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 16:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgFGONK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jun 2020 10:13:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45080 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726651AbgFGOLk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 7 Jun 2020 10:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=c7TGTvlL5iyX/Bb5VExoye9iEGG5jYYo48RZAbtMb5Y1AqJ9+XDUaPP2RxXzgf+ECDfhB5
        ot54XbTxXJr4rurbtUaJgdkxfCk+KXYB4iQ2p7N+LPn+HUOIJxRwQN+WzhaxT2an6z+vRo
        yjpVUrAZVRt2SAGnIaq4U54sz8xOSzY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-61qSXlvqPC2ADdLX0VuO9Q-1; Sun, 07 Jun 2020 10:11:37 -0400
X-MC-Unique: 61qSXlvqPC2ADdLX0VuO9Q-1
Received: by mail-wr1-f69.google.com with SMTP id c14so6035120wrm.15
        for <kvm@vger.kernel.org>; Sun, 07 Jun 2020 07:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=IxdIcGL19CZuKKo5YcE0SFAdUSvhnvhgOcc3wtcsmesJtSnoo+1BBjWbKE00F/2n5b
         xQyq77u0ZhCouOmocQFNxUdQa+zCOahfVAYIcqFgDkM2SCZLZntYC8OVcrol6zAparGr
         DLhh3XVfDAFcprINgPkYRiOyyc7a6F7FlaVkWwmlBpBzSbQ7w4MEw8mkIVZ4dwdly6lR
         bmP0cK9m5nrnJk69X3pNfTgWQFOWttVi5wUq+sMy+YPuOdlScThizn08wM2Klu77P27J
         vdsuQcll8304eb/YNLXFln85iY8dnerA2pVnILtBk5r3gGAJNl6392PYzPplLFOL9fGo
         5RIg==
X-Gm-Message-State: AOAM531rzpOWIqdIvwOScD28Pz6obBtA9iIa51nWdaOiQ6bq7DB30c9s
        nd5oBiWbDLg6wnB339WScO25rqcReYO9qJOudBYSuU//KaayiA2GHfQ3R8/jj0V38liu/l5Xv9U
        IJButFql4ARDZ
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr18631303wrx.215.1591539096209;
        Sun, 07 Jun 2020 07:11:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsDPwjtzJkhZbEN5e2/BnYi49yW0667WAP6g+jfWClMBgHDrBFyPNt/+F7HwozzDjFjLGjTw==
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr18631293wrx.215.1591539096029;
        Sun, 07 Jun 2020 07:11:36 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id d2sm20296210wrs.95.2020.06.07.07.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:35 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 05/13] vhost/net: pass net specific struct pointer
Message-ID: <20200607141057.704085-6-mst@redhat.com>
References: <20200607141057.704085-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607141057.704085-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for further cleanup, pass net specific pointer
to ubuf callbacks so we can move net specific fields
out to net structures.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index bf5e1d81ae25..ff594eec8ae3 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -94,7 +94,7 @@ struct vhost_net_ubuf_ref {
 	 */
 	atomic_t refcount;
 	wait_queue_head_t wait;
-	struct vhost_virtqueue *vq;
+	struct vhost_net_virtqueue *nvq;
 };
 
 #define VHOST_NET_BATCH 64
@@ -231,7 +231,7 @@ static void vhost_net_enable_zcopy(int vq)
 }
 
 static struct vhost_net_ubuf_ref *
-vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
+vhost_net_ubuf_alloc(struct vhost_net_virtqueue *nvq, bool zcopy)
 {
 	struct vhost_net_ubuf_ref *ubufs;
 	/* No zero copy backend? Nothing to count. */
@@ -242,7 +242,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&ubufs->refcount, 1);
 	init_waitqueue_head(&ubufs->wait);
-	ubufs->vq = vq;
+	ubufs->nvq = nvq;
 	return ubufs;
 }
 
@@ -384,13 +384,13 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 {
 	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
-	struct vhost_virtqueue *vq = ubufs->vq;
+	struct vhost_net_virtqueue *nvq = ubufs->nvq;
 	int cnt;
 
 	rcu_read_lock_bh();
 
 	/* set len to mark this desc buffers done DMA */
-	vq->heads[ubuf->desc].len = success ?
+	nvq->vq.heads[ubuf->desc].in_len = success ?
 		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
 	cnt = vhost_net_ubuf_put(ubufs);
 
@@ -402,7 +402,7 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	 * less than 10% of times).
 	 */
 	if (cnt <= 1 || !(cnt % 16))
-		vhost_poll_queue(&vq->poll);
+		vhost_poll_queue(&nvq->vq.poll);
 
 	rcu_read_unlock_bh();
 }
@@ -1525,7 +1525,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	/* start polling new socket */
 	oldsock = vhost_vq_get_backend(vq);
 	if (sock != oldsock) {
-		ubufs = vhost_net_ubuf_alloc(vq,
+		ubufs = vhost_net_ubuf_alloc(nvq,
 					     sock && vhost_sock_zcopy(sock));
 		if (IS_ERR(ubufs)) {
 			r = PTR_ERR(ubufs);
-- 
MST

