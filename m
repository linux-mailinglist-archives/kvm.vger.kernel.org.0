Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E371F0BBC
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 16:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgFGOL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jun 2020 10:11:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27961 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726833AbgFGOLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jun 2020 10:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LkIC7lu04RjihR3CHtt6ay4K/Xfv1eAdqmqMBhW1nUc=;
        b=KClBS+4StlfbF/xhh1Xsa+8ZofIAwN4Csgy1OuU5MWFcVXP+KiBoc/D+7Ulm4LldWcpHyK
        OpAxpKZLXq1gtj/ZKUmnyAqTqllcGajFqTqwZ0GuusxWvjZM3y67PvidQnJostOo389zYR
        4gjtd/sWcQSLjg3I0SS4CnixbPPLs9o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-uGktBmcAPA-IYriwlRn1pQ-1; Sun, 07 Jun 2020 10:11:48 -0400
X-MC-Unique: uGktBmcAPA-IYriwlRn1pQ-1
Received: by mail-wr1-f69.google.com with SMTP id c14so6035170wrm.15
        for <kvm@vger.kernel.org>; Sun, 07 Jun 2020 07:11:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LkIC7lu04RjihR3CHtt6ay4K/Xfv1eAdqmqMBhW1nUc=;
        b=VC7bfMON46+XfJ3YMtMuoFEZ4YpPDEvD1b3aJMhwTyrm/iJrHN2PPMQGZIEYqJc/44
         +5CvGx6tP/JbUOkRlgX7QxJf6zi1k/cYx21VFxVM/DSPkVwR2LmO/EeM8XHYaRtP3scG
         O6y+fQHkERWBpRQIJyg0bnSINwE9DtVzjpif68lkR4z0EG2NA5MLJKwW1oWZ7p/nK0mG
         r6bvEDi9eZAQBe3fynDR8Q5ga7U/U41SZxc5d+VBLIDhTNHAkh8J+0BUTxrQxq+B6zX9
         FYoXEc+V4hsVw4JtEjPiWYb6OW0R62hcSiqsNNWEAkJ1GZks08W/nGUy58Tji/Dpi0db
         xsxw==
X-Gm-Message-State: AOAM532Sqd8gapwcohYHcFQaIHzKhfA2mr5LNxXctF4csbKBdbiW9p9T
        90XREB0bN4O63olmYcWhMpZJrOMHE3fE/dGycX8I1rGeCvln6nLl7CPLgT1r8XTdogEHB5fHtzH
        R+hRSc86QMds0
X-Received: by 2002:a1c:7215:: with SMTP id n21mr10409312wmc.10.1591539106885;
        Sun, 07 Jun 2020 07:11:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCfLPmb9+BZnCuC5u2jfWuqmXeqMS8Ihho5hEhJLUW08ori7QKr5nyQ1D2eMu4yFMhmwKabg==
X-Received: by 2002:a1c:7215:: with SMTP id n21mr10409289wmc.10.1591539106521;
        Sun, 07 Jun 2020 07:11:46 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id a81sm20684853wmd.25.2020.06.07.07.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:46 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 10/13] vhost/test: convert to the buf API
Message-ID: <20200607141057.704085-11-mst@redhat.com>
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 02806d6f84ef..251fd2bf74a3 100644
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
+		ret = vhost_get_avail_buf(vq, vq->iov, &buf,
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

