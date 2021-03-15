Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6708033B0CA
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 12:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhCOLQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 07:16:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229807AbhCOLPn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 07:15:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615806942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zTCAicjVpAPdaMgz3Js6yfA0Br4haFpS8XvtL+22h/g=;
        b=WFK7olXteowD2JqylAI5LRpqhDzzL4U25LuA0NJTT4/4Fzj4BAhLWTyEpFxmLtzk1cz/1l
        LYHeo4JKBE5SYPoKcT+exibYtKDOSh7kfWIafhizR8zuOoSUqP9t7zhzzikaePv6kPVIbT
        nf2tyRPtKs5F5qcJkOhXDqsKGh7gwBM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-QteNoi40M7C6wOzDtpPBdQ-1; Mon, 15 Mar 2021 07:15:41 -0400
X-MC-Unique: QteNoi40M7C6wOzDtpPBdQ-1
Received: by mail-wr1-f69.google.com with SMTP id m9so14965176wrx.6
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 04:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zTCAicjVpAPdaMgz3Js6yfA0Br4haFpS8XvtL+22h/g=;
        b=V9YgTIPly+L7kf4/qImn164XmfSPQ+2kWisEC6wPvHcicCAjBUR8BbyZXLaGDAH64P
         A4+2g3eHpJdea1qmN8dEyl0ZBuyc1CNJ6HlReJsODwleuDjKIk+sYXLlTc/R9UD6TOda
         AHxYQENKWv/zp15lz+4wICE9xmcQSoxAMG6Ck54ckHJQCp+kRnJwUVMuZrTlH6flvFXJ
         3z7QG9U4ZD26xB1X2Jo5g/URzwU4ZhCn9534LBJBLajVDExfmMntOXP0ibPjIOiSYTn4
         PBhYo18Hrj7dk1cDBvklXS51QVIHEXjM58XmfFkW2Lu4fCCu1NXAIk3RRqZd+K5u6TKt
         dLeA==
X-Gm-Message-State: AOAM5303M3CG64wmlMaUthO7SboDA0MYLNcCie8tEY11qbRUKpL3FB60
        giLXmqcbBkHCBqeuosRBliHBBhJAI3PuQH6hNC9h44vp0LSvElpkrOT3IcGMcayyDJzqyr/SQ6p
        8Kbyd2CY5QLLU
X-Received: by 2002:a5d:6a86:: with SMTP id s6mr27930967wru.307.1615806938611;
        Mon, 15 Mar 2021 04:15:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrXQ6HXQSOKtfo2XLAhaJtEOgAIv8MsWedRGd0O6PHJ2FIe7vMb6i/B9IXA4kIhs96rnRsqA==
X-Received: by 2002:a5d:6a86:: with SMTP id s6mr27930940wru.307.1615806938386;
        Mon, 15 Mar 2021 04:15:38 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id s11sm12731700wme.22.2021.03.15.04.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:15:38 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:15:35 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 13/22] virtio/vsock: add SEQPACKET receive logic
Message-ID: <20210315111535.eujoemvhqxcjag2e@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180253.3466110-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307180253.3466110-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 07, 2021 at 09:02:50PM +0300, Arseny Krasnov wrote:
>This modifies current receive logic for SEQPACKET support:
>1) Inserts 'SEQ_BEGIN' packet to socket's rx queue.
>2) Inserts 'RW' packet to socket's rx queue, but without merging with
>   buffer of last packet in queue.
>3) Performs check for packet and socket types on receive(if mismatch,
>   then reset connection).
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 63 +++++++++++++++++--------
> 1 file changed, 44 insertions(+), 19 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 6fc78fec41c0..9d86375935ce 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -165,6 +165,14 @@ void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
>
>+static u16 virtio_transport_get_type(struct sock *sk)
>+{
>+	if (sk->sk_type == SOCK_STREAM)
>+		return VIRTIO_VSOCK_TYPE_STREAM;
>+	else
>+		return VIRTIO_VSOCK_TYPE_SEQPACKET;
>+}
>+
> /* This function can only be used on connecting/connected sockets,
>  * since a socket assigned to a transport is required.
>  *
>@@ -1062,25 +1070,27 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 		goto out;
> 	}
>
>-	/* Try to copy small packets into the buffer of last packet queued,
>-	 * to avoid wasting memory queueing the entire buffer with a small
>-	 * payload.
>-	 */
>-	if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
>-		struct virtio_vsock_pkt *last_pkt;
>+	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM) {
>+		/* Try to copy small packets into the buffer of last packet queued,
>+		 * to avoid wasting memory queueing the entire buffer with a small
>+		 * payload.
>+		 */
>+		if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
>+			struct virtio_vsock_pkt *last_pkt;
>
>-		last_pkt = list_last_entry(&vvs->rx_queue,
>-					   struct virtio_vsock_pkt, list);
>+			last_pkt = list_last_entry(&vvs->rx_queue,
>+						   struct virtio_vsock_pkt, list);
>
>-		/* If there is space in the last packet queued, we copy the
>-		 * new packet in its buffer.
>-		 */
>-		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
>-			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
>-			       pkt->len);
>-			last_pkt->len += pkt->len;
>-			free_pkt = true;
>-			goto out;
>+			/* If there is space in the last packet queued, we copy the
>+			 * new packet in its buffer.
>+			 */
>+			if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
>+				memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
>+				       pkt->len);
>+				last_pkt->len += pkt->len;
>+				free_pkt = true;
>+				goto out;
>+			}
> 		}
> 	}
>
>@@ -1100,9 +1110,13 @@ virtio_transport_recv_connected(struct sock *sk,
> 	int err = 0;
>
> 	switch (le16_to_cpu(pkt->hdr.op)) {
>+	case VIRTIO_VSOCK_OP_SEQ_BEGIN:
>+	case VIRTIO_VSOCK_OP_SEQ_END:
> 	case VIRTIO_VSOCK_OP_RW:
> 		virtio_transport_recv_enqueue(vsk, pkt);
>-		sk->sk_data_ready(sk);
>+
>+		if (le16_to_cpu(pkt->hdr.op) != VIRTIO_VSOCK_OP_SEQ_BEGIN)
>+			sk->sk_data_ready(sk);
> 		return err;
> 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
> 		sk->sk_write_space(sk);
>@@ -1245,6 +1259,12 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
> 	return 0;
> }
>
>+static bool virtio_transport_valid_type(u16 type)
>+{
>+	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
>+	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
>+}
>+
> /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
>  * lock.
>  */
>@@ -1270,7 +1290,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 					le32_to_cpu(pkt->hdr.buf_alloc),
> 					le32_to_cpu(pkt->hdr.fwd_cnt));
>
>-	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
>+	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
> 		(void)virtio_transport_reset_no_sock(t, pkt);
> 		goto free_pkt;
> 	}
>@@ -1287,6 +1307,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 		}
> 	}
>
>+	if (virtio_transport_get_type(sk) != le16_to_cpu(pkt->hdr.type)) {
>+		(void)virtio_transport_reset_no_sock(t, pkt);

We must release the refcnt acquired by vsock_find_connected_socket() or 
vsock_find_bound_socket(), so we need to add:

                 sock_put(sk);


>+		goto free_pkt;
>+	}
>+
> 	vsk = vsock_sk(sk);
>
> 	lock_sock(sk);
>-- 
>2.25.1
>

