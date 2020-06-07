Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841021F0BC9
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 16:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgFGOMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jun 2020 10:12:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726841AbgFGOLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jun 2020 10:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=Y18W4etLZxOVWK+oWzASjub4NeNEz8mfo8eA7e9mry5dbniwuL1UPdX3jyRaanvuvSajHy
        HtvYQXjRjXH6GA5h1iRyA6tjsWbIFmxmB5jlpERngWyA/cRHn/idwq/pVG3Odm8PXig3XO
        35KktU+HVeAv2BTUnBKCEJAv2jf19Do=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-c-l2E5C3PuKr8_43e3rCzQ-1; Sun, 07 Jun 2020 10:11:45 -0400
X-MC-Unique: c-l2E5C3PuKr8_43e3rCzQ-1
Received: by mail-wr1-f69.google.com with SMTP id p9so6063349wrx.10
        for <kvm@vger.kernel.org>; Sun, 07 Jun 2020 07:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=YPzDCwf6ee0qXRzOr7FgnIgZ+Dm4O5F2f6kRS1p1FdW5wEMZRgtfUmLm6NT5wzHLDG
         3sqGalGyZRZRwHkBRDtyOBNzkvj8rhGRW7Cdpw+snOXHY5bulCuI/olLBZNjt+XMZCRi
         +/7mbG4YlzLrgS4c473WoxrtSJaBMiGbtLS1h7odeaNGuqIYFnAMRnrJJ7QEB7kFQCba
         o18IiQojmf1jeGcoDQZ7D32FbFExmEbL/XmbUYwnQuBj3oHO5ouQl+gbH6ZKPQECLj3T
         2OjJ18Bfp9LYRWjY65ovv21FhySMgvpS2VLLICKjT8GPpuGPcgEnwspMuL9zkGmRThOH
         GjNA==
X-Gm-Message-State: AOAM531alRp1kva3I9PSQDnFSyq8SHHPWiDueYSyCTEQm94zWyZn+6n5
        4vwLThZxlP4A5VpIdMERm7JtiU4y3CC7xPO1j6UQwZoUxuZanEeeYgFLH/84dyB9EjEi+Xd117z
        LiOmBNIOE5bdb
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr12417402wmi.165.1591539104515;
        Sun, 07 Jun 2020 07:11:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw57J09cTKbeRmJVX90+N+R46OyNEvndsO7VwU1Ip6tS22b7zKgKAjdQddCV5K1/YT0vuS/Pg==
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr12417393wmi.165.1591539104370;
        Sun, 07 Jun 2020 07:11:44 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id h5sm20290400wrw.85.2020.06.07.07.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:44 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 09/13] vhost/net: avoid iov length math
Message-ID: <20200607141057.704085-10-mst@redhat.com>
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

