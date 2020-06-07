Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7642D1F0BC1
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 16:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgFGOMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jun 2020 10:12:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24575 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726923AbgFGOL4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 7 Jun 2020 10:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=eusb5MSkzrORkdydXEDg4qxqfPYCydhbcUAKqCBKFCSzhuE7W3BSPonFwGdd6Btrv+0glc
        z4O2vkSDehnC6DY4mP4U2uHWqQCroiIyv0SQi8xOWyu4+PO5NAylG30cdLYrgvi7omdHiW
        BcDKeW8Ie9GwD3IRj6yKQvX6Dc4sbtw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-_6zMxdgmN5KFfc48YUeJMQ-1; Sun, 07 Jun 2020 10:11:52 -0400
X-MC-Unique: _6zMxdgmN5KFfc48YUeJMQ-1
Received: by mail-wr1-f69.google.com with SMTP id o1so6011524wrm.17
        for <kvm@vger.kernel.org>; Sun, 07 Jun 2020 07:11:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=QJ7LH6cqUqZL/Zb3JXLVVvobisjssPjrHoqfc5X527nr9gDNjpu/7ajXyFg/GJwmPD
         0tsvy52sWFN+9z764BOPagQClqV+j7do1/6dqVk0vAIbiT0D2w+l+ryF2jaM1UAW85ZH
         rw49nZn0xBexIie39HrmVrYceGE2gib7tcqF90HwLUKWpK59mAYooPTCJBRwX2P7T1Lz
         gQtooKk0U8c5qDitDq/co5uXhDG8JfZTypH61gqXLU9ZGVtZNfQEbqaE4j8FtCGyJ4NR
         NlettUXddCbXfM8wBRQIAoEUcyR+nwz4ScXHNntTU4WL6SEjE8pJmf0wvCj3gLRjp985
         Y5Uw==
X-Gm-Message-State: AOAM531y9zbStk52kwI1FkRYsVg3oy8q98WtnGpDgh3JbIRvtzoUUENC
        Iovz7//kBB8YvHCETHQwt2KYdlXzK67YTir4j2d+dXl/Fg6jcUsbzBGkovGFvBTqrr/74+1Eveh
        g4A+7/vwGYQII
X-Received: by 2002:a5d:500c:: with SMTP id e12mr19107223wrt.359.1591539111401;
        Sun, 07 Jun 2020 07:11:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWm7fzH3GrdTvffSzx7586DHu5PzZq1QUCLkQIW8gnb+63gz4UqKFoDHZvxyrR4qeM53Cywg==
X-Received: by 2002:a5d:500c:: with SMTP id e12mr19107213wrt.359.1591539111193;
        Sun, 07 Jun 2020 07:11:51 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id i10sm19790175wrw.51.2020.06.07.07.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:50 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH RFC v5 12/13] vhost/vsock: switch to the buf API
Message-ID: <20200607141057.704085-13-mst@redhat.com>
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

