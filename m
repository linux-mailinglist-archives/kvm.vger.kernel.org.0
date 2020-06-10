Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6121F5374
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgFJLgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:36:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40160 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728705AbgFJLge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:36:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nNh1TL7xZUtXOusVSg8tIG35kTb/6beDbMDeGMbkL8c=;
        b=LLISva7riDzlkHbtZ3J/AB6Z/EPZCawO7XpVz/8M7yy7YATyMWbQrFjREhHyYzyVHwkLQs
        GXmA0+Fd5bQpqNlix7kDVssp2lwYNZY6Mxsv5QC4nO4F1wlM2qN2ReRvIiLcV3PYMLcOpe
        P7AfWTiHOsnuVGo+ZV2JT+NMDn2fxg8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-mw6nZ3CTNfCBI3XCloJjrw-1; Wed, 10 Jun 2020 07:36:31 -0400
X-MC-Unique: mw6nZ3CTNfCBI3XCloJjrw-1
Received: by mail-wr1-f69.google.com with SMTP id i6so952291wrr.23
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 04:36:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nNh1TL7xZUtXOusVSg8tIG35kTb/6beDbMDeGMbkL8c=;
        b=Ki+ppk+OnOhCraujkdXq4qtC/XXw157jBp4D00r9p1eJjtC7zRVdRHFiUPhAmubKD/
         a+BhLNEvXb+2Gl+FpipVwkI1HjZ5QrpVVa4UmGSV+iUsy/04gv0DD4dLGjZEfZW/RFqr
         mQLnZI0Jq2JIqrxHZ4W6jl3N8J0Qgy30JZKKmTXNDG9LKxPMu1C98+Yhdhj2e2+ewzQQ
         h6wYhEv/MT9rCKHYBjp0ooa2aFtLQcpQyvVAI9CrNv+i7UYQWL84vU4x4p2ugGPHqfmU
         TAE8gaSKgwpYNBwyUSDi5fToqyqxTlQOel67UB2IPsVGnOFr6QydXTeCsMiz4qZdk/w4
         JW4Q==
X-Gm-Message-State: AOAM530k/PnXHw7PeYoYNd3w3HJRqYNRP7D/Fy7OdEea7CRFrr3DhKZU
        I2elSKv+tBlbuAZJLitcvqc7ntgwAnco94oJf8txp3c8D5YZyU8Q4CiHR4vsYbPYnStziLgM3Hx
        535VbWnm47l8Q
X-Received: by 2002:adf:e9cb:: with SMTP id l11mr3131431wrn.86.1591788987304;
        Wed, 10 Jun 2020 04:36:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+fpU0gApAo9WdU2/MAJH8DR4JAaeeYujgzZhmzjJ0R2CYxZQQqTFJTYVCM7So04QnKQlLdw==
X-Received: by 2002:adf:e9cb:: with SMTP id l11mr3131407wrn.86.1591788987053;
        Wed, 10 Jun 2020 04:36:27 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id a16sm7675327wrx.8.2020.06.10.04.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:26 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 11/14] vhost/test: convert to the buf API
Message-ID: <20200610113515.1497099-12-mst@redhat.com>
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 7d69778aaa26..12304eb8da15 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -44,9 +44,10 @@ static void handle_vq(struct vhost_test *n)
 {
 	struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
 	unsigned out, in;
-	int head;
+	int ret;
 	size_t len, total_len = 0;
 	void *private;
+	struct vhost_buf buf;
 
 	mutex_lock(&vq->mutex);
 	private = vhost_vq_get_backend(vq);
@@ -58,15 +59,15 @@ static void handle_vq(struct vhost_test *n)
 	vhost_disable_notify(&n->dev, vq);
 
 	for (;;) {
-		head = vhost_get_vq_desc(vq, vq->iov,
-					 ARRAY_SIZE(vq->iov),
-					 &out, &in,
-					 NULL, NULL);
+		ret = vhost_get_avail_buf(vq, &buf, vq->iov,
+					  ARRAY_SIZE(vq->iov),
+					  &out, &in,
+					  NULL, NULL);
 		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
+		if (unlikely(ret < 0))
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
+		if (!ret) {
 			if (unlikely(vhost_enable_notify(&n->dev, vq))) {
 				vhost_disable_notify(&n->dev, vq);
 				continue;
@@ -78,13 +79,14 @@ static void handle_vq(struct vhost_test *n)
 			       "out %d, int %d\n", out, in);
 			break;
 		}
-		len = iov_length(vq->iov, out);
+		len = buf.out_len;
 		/* Sanity check */
 		if (!len) {
 			vq_err(vq, "Unexpected 0 len for TX\n");
 			break;
 		}
-		vhost_add_used_and_signal(&n->dev, vq, head, 0);
+		vhost_put_used_buf(vq, &buf);
+		vhost_signal(&n->dev, vq);
 		total_len += len;
 		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
 			break;
-- 
MST

