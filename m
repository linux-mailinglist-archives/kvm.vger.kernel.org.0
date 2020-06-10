Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1401F5397
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgFJLiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:38:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33950 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728615AbgFJLgO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 07:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=DdnfpOGfMI9Mk7zj+hxaSg133NvbcnQoOYGJnfbONsN52dVukJIBclB96XsF1d77qErqn+
        Swt99TWmrqujYNJxv6GWhjpy10rkkBSlwJ5Ngnc8IXQwlI23P+1XlGzNsqzbo1fc/JJstT
        h3pDsERbQdaNr+VAdgiNu6DAR96xZPQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-lEA32kgNPwSpn_Wq6X8ozA-1; Wed, 10 Jun 2020 07:36:09 -0400
X-MC-Unique: lEA32kgNPwSpn_Wq6X8ozA-1
Received: by mail-wm1-f72.google.com with SMTP id p24so332766wma.4
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 04:36:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=PMdjsPlC5ggyxdCq6z1sZaf96idMhTR4rdOrvhZ61BlUrlfWCpUMs2gDjr48n3vF7F
         VzoUQwe19clQGf7wfmIm/Fxa+aMslcqShKVWuOhX6AQQBxdXixUBo16iiDs8sWo43ITO
         5WkAZh52weg9gHpgLCXVTQAynGgEFn1z14ABWQA+JhCOWViheeyJd9wzEhTj3f1hto4b
         aTAQyfhMi+Eodmjmj4HsNCF7FUWpBqUvuObHJ231UvUEjVgwxsTDDbTk/sCSTp3/P06+
         IkFr1TqxOOkQKp4lzR9Qh8Yqyb+nZY/8I53PyNHRfm+arIdNKMasRVu705mw+kqjeww4
         yJZw==
X-Gm-Message-State: AOAM531VDDm+uErz3clFB7L3w1BtzJ+TIUIJn5nR8U5upxPyF8fgZR0k
        k5o7wjkt7wMUbNMesEprkaaF5ZSnHFlZ1OBBGS9Y4o2XD92i1RTzWYY/m9F//RZJhTYs+z27Fxk
        ADSNgbrwJ3uH0
X-Received: by 2002:adf:ea11:: with SMTP id q17mr3146826wrm.75.1591788968132;
        Wed, 10 Jun 2020 04:36:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+0YhjkTKfGeypFjYmQw4xelfruV1Ntm2M/rNlskwCxXmVD04EuumSwnMG+QPQp8710QWBNA==
X-Received: by 2002:adf:ea11:: with SMTP id q17mr3146806wrm.75.1591788967929;
        Wed, 10 Jun 2020 04:36:07 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id a16sm7674114wrx.8.2020.06.10.04.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:07 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 04/14] vhost/net: pass net specific struct pointer
Message-ID: <20200610113515.1497099-5-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610113515.1497099-1-mst@redhat.com>
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

