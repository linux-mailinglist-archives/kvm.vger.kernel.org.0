Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4001F1943
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgFHMxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:53:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44767 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729735AbgFHMxa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 08:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=KFDAnuso/ftTJvrswGRpM0qlY5W4HtzGEPrOgm4yKUy0y3+QeDur/jLx/c6QUjKqFAsYUC
        HIorg6HcR2RmrkAY0k6UlF1ny2mvMZYpQ6suwX6LfC9BlajH67Y5SzMB8v5UKpepMQ8lVo
        +k2QevCXXTc2XHTYiVGI2UHnvdxmQNs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-PffVT3cxPDSNLIVLi3zkKA-1; Mon, 08 Jun 2020 08:53:17 -0400
X-MC-Unique: PffVT3cxPDSNLIVLi3zkKA-1
Received: by mail-wm1-f71.google.com with SMTP id v24so1736272wmh.3
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 05:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=eN93f5FpwsCFyh6qyHArXiQD/R1JQ+6dl/H5uyL77mtdLbZi5zpVe5rGSvDlkUFvGL
         F3KkPGe1woiZazofXsnTdbGOlwDv/KEF6exIykRRgHAHh7yDBlRQIxkaUCCYZEfc/1jm
         iI1WB4ArA2n3+a40d5mlSMOYLh/GXnI5IP0oRijYCfpuAgaVncyhJVEZlGkwKN+anquE
         cRxr1fmJ18pW5vNPBFyHh4kCwWxkzV9rNPlu9El51KBRDAIP4D8ZqbQiroxuXYQGBjU+
         lZ9hL/5OfkBZKJgj/uwgUi5x4w/QOGwbfYyw4dpw6QPP+RSyrUbAObDgcKIFSPhLD0Om
         2Lyw==
X-Gm-Message-State: AOAM532ZjF/mVT+d7GLVd595rPEytwIHm3+5ZZMqmKC8uklkswl5NGCA
        n7NuMgh+OMayBGcTUlknbnJZnJ1TN1yov18j2PVe5oBs9d+V1doAWYJvTIlC3xaIipav9NvfbWr
        0tvs3JTlW4DCL
X-Received: by 2002:adf:9d8e:: with SMTP id p14mr22776191wre.236.1591620795491;
        Mon, 08 Jun 2020 05:53:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzojN0Rni5a/KRQQtayEgafAMQjL2u7TFZEVEHmdO1lnxFxUgOcYrWuJF226hamluzbsGThDA==
X-Received: by 2002:adf:9d8e:: with SMTP id p14mr22776176wre.236.1591620795249;
        Mon, 08 Jun 2020 05:53:15 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id i10sm22891380wrw.51.2020.06.08.05.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:53:14 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:53:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH RFC v6 10/11] vhost/vsock: switch to the buf API
Message-ID: <20200608125238.728563-11-mst@redhat.com>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A straight-forward conversion.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vsock.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index a483cec31d5c..61c6d3dd2ae3 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -103,7 +103,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		unsigned out, in;
 		size_t nbytes;
 		size_t iov_len, payload_len;
-		int head;
+		struct vhost_buf buf;
+		int ret;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
@@ -117,16 +118,17 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		list_del_init(&pkt->list);
 		spin_unlock_bh(&vsock->send_pkt_list_lock);
 
-		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
-					 &out, &in, NULL, NULL);
-		if (head < 0) {
+		ret = vhost_get_avail_buf(vq, &buf,
+					  vq->iov, ARRAY_SIZE(vq->iov),
+					  &out, &in, NULL, NULL);
+		if (ret < 0) {
 			spin_lock_bh(&vsock->send_pkt_list_lock);
 			list_add(&pkt->list, &vsock->send_pkt_list);
 			spin_unlock_bh(&vsock->send_pkt_list_lock);
 			break;
 		}
 
-		if (head == vq->num) {
+		if (!ret) {
 			spin_lock_bh(&vsock->send_pkt_list_lock);
 			list_add(&pkt->list, &vsock->send_pkt_list);
 			spin_unlock_bh(&vsock->send_pkt_list_lock);
@@ -186,7 +188,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 */
 		virtio_transport_deliver_tap_pkt(pkt);
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
+		buf.in_len = sizeof(pkt->hdr) + payload_len;
+		vhost_put_used_buf(vq, &buf);
 		added = true;
 
 		pkt->off += payload_len;
@@ -440,7 +443,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
 						 dev);
 	struct virtio_vsock_pkt *pkt;
-	int head, pkts = 0, total_len = 0;
+	int ret, pkts = 0, total_len = 0;
+	struct vhost_buf buf;
 	unsigned int out, in;
 	bool added = false;
 
@@ -461,12 +465,13 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			goto no_more_replies;
 		}
 
-		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
-					 &out, &in, NULL, NULL);
-		if (head < 0)
+		ret = vhost_get_avail_buf(vq, &buf,
+					  vq->iov, ARRAY_SIZE(vq->iov),
+					  &out, &in, NULL, NULL);
+		if (ret < 0)
 			break;
 
-		if (head == vq->num) {
+		if (!ret) {
 			if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
 				vhost_disable_notify(&vsock->dev, vq);
 				continue;
@@ -494,7 +499,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			virtio_transport_free_pkt(pkt);
 
 		len += sizeof(pkt->hdr);
-		vhost_add_used(vq, head, len);
+		buf.in_len = len;
+		vhost_put_used_buf(vq, &buf);
 		total_len += len;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
-- 
MST

