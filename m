Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20541F66D5
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 13:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgFKLel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 07:34:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42069 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727869AbgFKLei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 07:34:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=GdF1UaXpd2XFc7NACGwxjeT3PZg6r6tCu+MG/rvcZOEEhb4Dkec9p0s7HicXcuYC/WZu2V
        IkM5EtJdm9di5Q7zBEfa8ot5UW1TKFL1w7Ixau1SXt37phwB8gucmDFUKjyatcWz0kfsfZ
        sMkzI7uWAA2HJl+ydzoyPrW1q2mT3XA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-t8IQk2AaPaCUJelq9Ln2Nw-1; Thu, 11 Jun 2020 07:34:35 -0400
X-MC-Unique: t8IQk2AaPaCUJelq9Ln2Nw-1
Received: by mail-wr1-f69.google.com with SMTP id a4so2452024wrp.5
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 04:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=jaIt+kg8gi4j5mbYKkKd+mEfmaTNS9Dv+YCJPzjipMCCNFL3Gdq9wARMUspDY8q//2
         Z7UsJC4eslyehqN4A1wi+TQviRFG+AABNYQblhQNHsJSfyPuNap+sOe8/l7QawC4KHyj
         u7I6FHUXDLnagefV2y0jv0jQH4PKHIO2PbHDO2+u3P19sO3ctx6Al3illW6DuYvdXCrx
         Be3chqu4I/ais05OyOvpE5cvi90X+dHYUwwdF0ZI4AorFCmpwgtfAlIiq9DvvIHl2t0b
         bzwmO4gD4uQRyihNfCtsxRHNW/G/VTcFnP1AEzP2Xq1pjozOEB6REN3WTUdnMVY0wO34
         3mEg==
X-Gm-Message-State: AOAM530jo9EuBgDvL0DXT4dZFzq9IweN5VaGGaru/ZJ1F0ODTMUtjPQB
        9PDeJbRxfluYL5FKUwkW87p2yhBj3h7AxZ0k0QdkaSsa2PSu2cU7m3DUR8jCQ9DUQ7hSfn1/FpF
        plLqSvr2eFqP7
X-Received: by 2002:adf:e381:: with SMTP id e1mr8683445wrm.320.1591875274096;
        Thu, 11 Jun 2020 04:34:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwP1H7ZA1p3aDr58BVHo1lTwD6nnLZ5xDw5t6ge7P3fJgEClZF0S1h1hQVZzkshTgxNN4ZDtw==
X-Received: by 2002:adf:e381:: with SMTP id e1mr8683426wrm.320.1591875273921;
        Thu, 11 Jun 2020 04:34:33 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id o6sm3634582wmc.39.2020.06.11.04.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:34:32 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:34:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v8 07/11] vhost/net: avoid iov length math
Message-ID: <20200611113404.17810-8-mst@redhat.com>
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

Now that API exposes buffer length, we no longer need to
scan IOVs to figure it out.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 830fe84912a5..0b509be8d7b1 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -607,11 +607,9 @@ static bool vhost_exceeds_maxpend(struct vhost_net *net)
 }
 
 static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
-			    size_t hdr_size, int out)
+			    size_t len, size_t hdr_size, int out)
 {
 	/* Skip header. TODO: support TSO. */
-	size_t len = iov_length(vq->iov, out);
-
 	iov_iter_init(iter, WRITE, vq->iov, out, len);
 	iov_iter_advance(iter, hdr_size);
 
@@ -640,7 +638,7 @@ static int get_tx_bufs(struct vhost_net *net,
 	}
 
 	/* Sanity check */
-	*len = init_iov_iter(vq, &msg->msg_iter, nvq->vhost_hlen, *out);
+	*len = init_iov_iter(vq, &msg->msg_iter, buf->out_len, nvq->vhost_hlen, *out);
 	if (*len == 0) {
 		vq_err(vq, "Unexpected header len for TX: %zd expected %zd\n",
 			*len, nvq->vhost_hlen);
@@ -1080,7 +1078,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 			nlogs += *log_num;
 			log += *log_num;
 		}
-		len = iov_length(vq->iov + seg, in);
+		len = bufs[bufcount].in_len;
 		datalen -= len;
 		++bufcount;
 		seg += in;
-- 
MST

