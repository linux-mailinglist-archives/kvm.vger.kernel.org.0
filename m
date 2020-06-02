Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE441EBCA4
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 15:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgFBNIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 09:08:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54919 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728129AbgFBNGM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 09:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LMo2drqoQTmF0s7z53vtXvrX6v2dv44a7nAUfjbkZzI=;
        b=MJhJV/pY/dJhw05zgn/ytpVYZuqbJqeGnOAWBWLMDJ54HTSIMO9H5EDLtJE+s8w6mIYYgG
        HPgfd8OBeI0ie3CTpmZhEWnsmHa/ZVtRg/+7W6AxeEt187eJNlp1pUqT2nKqtLgYNNzsa2
        2neHmpElHuqh8J25UdWNqFLXrXsR6Ug=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-exBjtfJTNUOIRPRGbbdPcA-1; Tue, 02 Jun 2020 09:06:09 -0400
X-MC-Unique: exBjtfJTNUOIRPRGbbdPcA-1
Received: by mail-wr1-f70.google.com with SMTP id s17so1370446wrt.7
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 06:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LMo2drqoQTmF0s7z53vtXvrX6v2dv44a7nAUfjbkZzI=;
        b=fffla00GGSk3nO9XKc36PMUNR26Gk+Z9IT2gnlbzYvbXsFFdk0YmXgjH4H8P/QOfPz
         xmCp0eVMF7bMhUydwojIvryrtzMthAXIiakOMx/R2ssHtQFEzumMazyZZf45MMTLwbzZ
         ZWS8/zKPIKp/L5h9e9uBOSDN61Xk/BTxiVnshuoE0EBrY3oKn8alGn10YQZYeAKqgKnh
         mbLrO82u8Yp3p5RRL2IEcmCEDupCUx+tMXZWJthxArM72OrQJjpln6WfCcKr+qaCQCBz
         Mva4INt5UsNmFu9hBT0h4f3/nxJFXzKrj6CDr8SXagpmJfJb2amdg02u59Sahyj1sy/j
         wx9A==
X-Gm-Message-State: AOAM531L0HPFYjl2s9JuHvsKzsLQvLdRyVKa2PJNGAz1B9/m9fkMScQh
        xZmbQmmBTUlEFKs1YyvmBe2Cr3U0CRChzZkRJbiij2QusApPJ5paMnrG2qOOO2ASUVEabeR9rYH
        o66P5cgG1foli
X-Received: by 2002:adf:f988:: with SMTP id f8mr28409411wrr.81.1591103168347;
        Tue, 02 Jun 2020 06:06:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG9bw3Ul7VoJ7lrSM6JnY068u1IXNEEmqvhm6cdNr9QfAcz0IRu5Ie8ZlB9aURJhAs2bO3EA==
X-Received: by 2002:adf:f988:: with SMTP id f8mr28409395wrr.81.1591103168152;
        Tue, 02 Jun 2020 06:06:08 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id t129sm3890953wmf.41.2020.06.02.06.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:06:07 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:06:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 05/13] vhost/net: pass net specific struct pointer
Message-ID: <20200602130543.578420-6-mst@redhat.com>
References: <20200602130543.578420-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602130543.578420-1-mst@redhat.com>
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
index 2927f02cc7e1..749a9cf51a59 100644
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

