Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B551F66DF
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 13:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgFKLef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 07:34:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46068 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728023AbgFKLe3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jun 2020 07:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=eb7YR6MOmKlA9LpQJbN0S24wLZqG5yVHs4ubB21IGieH5P1HT3W1PQn5gsJ5VjEwyewv5P
        UWGhK8ObBI5LvbozaN4zXyeJMCmoO3+zFgFy0/mMnvAVT79a7GGgjWTz1dAXaQKjZwJu1U
        XhPzBQlYyHUr387Eu9VrEELgyO6a8LY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-mFkhQfzcOC6JU1jmzzDW9g-1; Thu, 11 Jun 2020 07:34:25 -0400
X-MC-Unique: mFkhQfzcOC6JU1jmzzDW9g-1
Received: by mail-wr1-f72.google.com with SMTP id z10so2471113wrs.2
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 04:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=IVWT75VkMrWCmoottnBxwzKyQSWe5R1BO583f6m+UqWXD01LrxdHGvLmU4G6XdsXhj
         naJUMvLJdKCNuaNsrWRQiXrqU96UYUgHFTxPSFdSWGaKKOzQbPoSqYQUuuJ+B7KW0ne5
         XULwcUFnl6JwrtEjtEMK/xNIIknESo4banhR86+XqJvE0umA5qvI4ZGY/N17YQvl3y45
         Ux6r113y8glrTC9hoq0cBnFOua4zoxq6rjjG/V+N3QltYcQsSPZtFfHG6rljMu6OnRVJ
         4tdXRqcuwFdXts17WfIe8NGoKNnJhNRd1r8cpjKGBDtq4RUv8DpjE/yBm1H9/n3UXOCT
         eASA==
X-Gm-Message-State: AOAM531pcMLj/04IZIx96+WvX1TjJFUrU7A2XPYdsERAZTvqcfm4hAIV
        ac4eXtCLe/DRKCurSixPBWQGb4LHCwo/ZFTmq2WLJg7VO90Q+r0x+C9m42lCwQQaN8L69gjiSOV
        LvmowYDW7qDff
X-Received: by 2002:adf:e588:: with SMTP id l8mr9647061wrm.255.1591875264178;
        Thu, 11 Jun 2020 04:34:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp9renAKj8PmTNv1Sajxcl0ecOrev7nVeaEQM7VXOPARpXWTORRf8SSFeo90xhKgf6tYSZBQ==
X-Received: by 2002:adf:e588:: with SMTP id l8mr9647034wrm.255.1591875263907;
        Thu, 11 Jun 2020 04:34:23 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id e12sm4620751wro.52.2020.06.11.04.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:34:23 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:34:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v8 03/11] vhost/net: pass net specific struct pointer
Message-ID: <20200611113404.17810-4-mst@redhat.com>
References: <20200611113404.17810-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611113404.17810-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
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

