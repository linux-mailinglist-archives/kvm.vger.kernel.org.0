Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D232D39A3C0
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 16:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhFCO6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 10:58:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231713AbhFCO6Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 10:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622732191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=goc0S/3BnSXgINaDm4Ycz9KOeQAXHuNP6jsSEIzAQsg=;
        b=VuI2UnpciToZjwiw9QLX14fQ8WDoTnhgKu3aFB4jD5fw2Cgz9SuYpAbkRF5HsZRF+wR5U/
        Xdg3Lpu3irfQWUlMag8ObI6zg1CH3DcWzP+/NoHLwqsU8ohp0WzO2o0459isggAkCORGT/
        ywCO4QgyDxKt1z6ScD0HTqIwDKqMSZk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-kJ91P1XpMoie-wDtTVgzzQ-1; Thu, 03 Jun 2021 10:56:29 -0400
X-MC-Unique: kJ91P1XpMoie-wDtTVgzzQ-1
Received: by mail-ej1-f70.google.com with SMTP id jy19-20020a1709077633b02903eb7acdb38cso2035989ejc.14
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 07:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=goc0S/3BnSXgINaDm4Ycz9KOeQAXHuNP6jsSEIzAQsg=;
        b=G5KBwKn90KCJkC1TXrhBzWR0SngRQ+YUYAjoAtgf+5c89VBRD8JMidKRhTh7XzO3SV
         eM8dF/mjyKlOq28yToldZa5fybK3DYKjrpz2jnOm7dTE7RKE/sdwi5/Ko9hlboSOBYAj
         4bsQY8ygIW+ng9hIDpqQ+Mux00w7idmIPxWpv05jsq5E+PxHLFBe5atX+Oq3qeJE0Kbe
         jtKhUiCR5KzabceqIU/Q8Tp0xMJNAgbX3OJWs6JGb4loDr3k7QYnWSiT3UfLWzxqrJXd
         lKlt07shGT863dErpMSjVnn+AclsdyZ6O9L8RlehcAz6Yc0lu5JRWmzSnbGyUX4R6upj
         YYyg==
X-Gm-Message-State: AOAM531fOD8QRZBjNi3HrwNrMcSo+q0KQa1kwsm3PJFHOyM9lvSw3i4a
        FCeyTTCopwScH5Qa5/9J4Bl5BXLj/2v8unqe5GQyIaXm9C/MN87dUEhTLdQ0NrkG0rS0geOmqsO
        vaulAS2CPQ7F2
X-Received: by 2002:aa7:c594:: with SMTP id g20mr171117edq.193.1622732188105;
        Thu, 03 Jun 2021 07:56:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNs8fBb3HJWsNPx4vbS0w6t0xdKecgcrrzazaCK6WjM8HGlFblxyZ501bs6But06wi3tedQQ==
X-Received: by 2002:aa7:c594:: with SMTP id g20mr171099edq.193.1622732187957;
        Thu, 03 Jun 2021 07:56:27 -0700 (PDT)
Received: from steredhat ([5.170.129.82])
        by smtp.gmail.com with ESMTPSA id h2sm1391024edr.50.2021.06.03.07.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 07:56:27 -0700 (PDT)
Date:   Thu, 3 Jun 2021 16:56:23 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 12/18] virtio/vsock: add SEQPACKET receive logic
Message-ID: <20210603145623.cv7cmf2zfjsx4w2t@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191824.1272172-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191824.1272172-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 10:18:21PM +0300, Arseny Krasnov wrote:
>Update current receive logic for SEQPACKET support: performs
>check for packet and socket types on receive(if mismatch, then
>reset connection).

We also copy the flags. Please check better your commit messages.

>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v9 -> v10:
> 1) Commit message updated.
> 2) Comment updated.
> 3) Updated way to to set 'last_pkt' flags.
>
> net/vmw_vsock/virtio_transport_common.c | 30 ++++++++++++++++++++++---
> 1 file changed, 27 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 61349b2ea7fe..a6f8b0f39775 100644
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
>@@ -979,13 +987,17 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 					   struct virtio_vsock_pkt, list);
>
> 		/* If there is space in the last packet queued, we copy the
>-		 * new packet in its buffer.
>+		 * new packet in its buffer(except SEQPACKET case, when we
>+		 * also check that last packet is not last packet of previous
>+		 * record).

Is better to explain why we don't do this for SEQPACKET, something like this:

		/* If there is space in the last packet queued, we copy the
		 * new packet in its buffer.
		 * We avoid this if the last packet queued has
		 * VIRTIO_VSOCK_SEQ_EOR set, because it is the delimiter
		 * of SEQPACKET record, so `pkt` is the first packet
		 * of a new record.
		 */

> 		 */
>-		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
>+		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
>+		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)) {
> 			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
> 			       pkt->len);
> 			last_pkt->len += pkt->len;
> 			free_pkt = true;
>+			last_pkt->hdr.flags |= pkt->hdr.flags;
> 			goto out;
> 		}
> 	}
>@@ -1151,6 +1163,12 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
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
>@@ -1176,7 +1194,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 					le32_to_cpu(pkt->hdr.buf_alloc),
> 					le32_to_cpu(pkt->hdr.fwd_cnt));
>
>-	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
>+	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
> 		(void)virtio_transport_reset_no_sock(t, pkt);
> 		goto free_pkt;
> 	}
>@@ -1193,6 +1211,12 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 		}
> 	}
>
>+	if (virtio_transport_get_type(sk) != le16_to_cpu(pkt->hdr.type)) {
>+		(void)virtio_transport_reset_no_sock(t, pkt);
>+		sock_put(sk);
>+		goto free_pkt;
>+	}
>+
> 	vsk = vsock_sk(sk);
>
> 	lock_sock(sk);
>-- 
>2.25.1
>

The rest LGTM.

Stefano

