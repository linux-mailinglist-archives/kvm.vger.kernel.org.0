Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694F4366805
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 11:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbhDUJc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 05:32:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238084AbhDUJcY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 05:32:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618997511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U7X4vCyOCjQHI1jpddaKwHHtP8FwpBjh+EKBeCw5TnU=;
        b=KlS7Q8vdX9CH3HkNBY9x5xTKpfQjtV41qS1RS5HIN+4TE4ym0tnliE6QWYTNIHkLZnAnzh
        oXQmMtIhZH1+WblehPpO2U7t/ClC1mf/CwV4i+IdRLJGwEZpaTCqtANbirkJXjlgaEL7yD
        I7dXjvkIuDhuf2q21uF6yJBYPekfXuA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-KBrGtZ_eNiuo6fn9VXPFyw-1; Wed, 21 Apr 2021 05:31:49 -0400
X-MC-Unique: KBrGtZ_eNiuo6fn9VXPFyw-1
Received: by mail-ed1-f70.google.com with SMTP id i18-20020aa7c7120000b02903853032ef71so5772080edq.22
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 02:31:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U7X4vCyOCjQHI1jpddaKwHHtP8FwpBjh+EKBeCw5TnU=;
        b=jZN63GRylpp8dn+Yq0nV1u2DZgdUhFggzhuZbZcSHKZclfDcQnF7uzDEMtC9iqZBAV
         qybuyqhsEy73nR0nfMlZmFGYnImlGgGiYGrAMqzPvX0DhrJ10sO4eANgbU/4i4iEzk6d
         Rlfs2qy3mkFAYqYyKghUOkpXtLBr4ffOZ5xdBLeG/c7qkGp8VILULNBC6W/Uo93ZjhdW
         PgvaVfp7V3yV2eyF5h3i9CDcTKKFWN5w4DBvZh80TUz9iy6UQwnF75LpGgxxpoX8z7Ar
         KDqodLkh0ry8f6IsbOxC0/+YsDkqGRsSNYySKt5+eNLMkXCMRxHdmzsveo81qUC388fB
         A+YQ==
X-Gm-Message-State: AOAM530DyN5UwU3oEYWbvlBaEJuccREWKm4M4v4ktcmJJIVLxCOvv1qy
        Vv6H5kQjSY1QWaTy001UcimU+C+J2lMok1OCPwsFoqocCy3/6uwSkXvk2mVxZUDHMF9Bmk0QZm0
        kzGZPlJz7ZWzA
X-Received: by 2002:a17:906:cc8e:: with SMTP id oq14mr31701033ejb.15.1618997508455;
        Wed, 21 Apr 2021 02:31:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxN/DH6KxnWUcPdJgeufxW/nKNOm0u9lF15XFa52b8iP6VK1HSTTtkVWzaEX8ZgOYphJXxEGA==
X-Received: by 2002:a17:906:cc8e:: with SMTP id oq14mr31701007ejb.15.1618997508240;
        Wed, 21 Apr 2021 02:31:48 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id k5sm2856590edk.46.2021.04.21.02.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:31:47 -0700 (PDT)
Date:   Wed, 21 Apr 2021 11:31:45 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        David Brazdil <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v8 15/19] vhost/vsock: enable SEQPACKET for transport
Message-ID: <20210421093145.ev375dexrxr4jrod@steredhat>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124620.3405764-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210413124620.3405764-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 03:46:18PM +0300, Arseny Krasnov wrote:
>This removes:
>1) Ignore of non-stream type of packets.
>This adds:
>1) Handling of SEQPACKET bit: if guest sets features with this bit cleared,
>   then SOCK_SEQPACKET support will be disabled.
>2) 'seqpacket_allow()' callback.
>3) Handling of SEQ_EOR bit: when vhost places data in buffers of guest's
>   rx queue, keep this bit set only when last piece of data is copied.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
>v7 -> v8:
> - This patch merged with patch which adds SEQPACKET feature bit to
>   virtio transport.
> - It now handles VIRTIO_VSOCK_SEQ_EOR bit(see commit msg).
>
> drivers/vhost/vsock.c | 31 ++++++++++++++++++++++++++++---
> 1 file changed, 28 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5e78fb719602..0969cdc87830 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -31,7 +31,8 @@
>
> enum {
> 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>-			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
>+			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> };
>
> enum {
>@@ -112,6 +113,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		size_t nbytes;
> 		size_t iov_len, payload_len;
> 		int head;
>+		bool restore_flag = false;
>
> 		spin_lock_bh(&vsock->send_pkt_list_lock);
> 		if (list_empty(&vsock->send_pkt_list)) {
>@@ -174,6 +176,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		/* Set the correct length in the header */
> 		pkt->hdr.len = cpu_to_le32(payload_len);
>
>+		if (pkt->off + payload_len < pkt->len &&
>+		    pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR) {
                              ^
                             (1)
>+			pkt->hdr.flags &= ~VIRTIO_VSOCK_SEQ_EOR;
                                  ^
                                 (2)
>+			restore_flag = true;
>+		}
>+
> 		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
> 		if (nbytes != sizeof(pkt->hdr)) {
> 			virtio_transport_free_pkt(pkt);
>@@ -181,6 +189,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 			break;
> 		}
>
>+		if (restore_flag)
>+			pkt->hdr.flags |= VIRTIO_VSOCK_SEQ_EOR;
                                  ^
                                 (3)
In these 3 points we should use cpu_to_le32()/le32_to_cpu().

>+
> 		nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
> 				      &iov_iter);
> 		if (nbytes != payload_len) {
>@@ -354,8 +365,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> 		return NULL;
> 	}
>
>-	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
>-		pkt->len = le32_to_cpu(pkt->hdr.len);
>+	pkt->len = le32_to_cpu(pkt->hdr.len);
>
> 	/* No payload */
> 	if (!pkt->len)
>@@ -398,6 +408,8 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
> 	return val < vq->num;
> }
>
>+static bool vhost_transport_seqpacket_allow(void);
>+
> static struct virtio_transport vhost_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -424,6 +436,10 @@ static struct virtio_transport vhost_transport = {
> 		.stream_is_active         = virtio_transport_stream_is_active,
> 		.stream_allow             = 
> 		virtio_transport_stream_allow,
>
>+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>+		.seqpacket_allow          = vhost_transport_seqpacket_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>@@ -439,8 +455,14 @@ static struct virtio_transport vhost_transport = {
> 	},
>
> 	.send_pkt = vhost_transport_send_pkt,
>+	.seqpacket_allow = false
> };
>
>+static bool vhost_transport_seqpacket_allow(void)
>+{
>+	return vhost_transport.seqpacket_allow;
>+}

I think here it's even worse then virtio_transport.c, because there may 
be more instances with different guests and some may require the feature 
and some may not, we can't definitely save this information in struct 
virtio_transport, we should put it in `struct vhost_vsock`.

>+
> static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> {
> 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
>@@ -785,6 +807,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
> 			goto err;
> 	}
>
>+	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>+		vhost_transport.seqpacket_allow = true;
>+
> 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
> 		vq = &vsock->vqs[i];
> 		mutex_lock(&vq->mutex);
>-- 
>2.25.1
>

