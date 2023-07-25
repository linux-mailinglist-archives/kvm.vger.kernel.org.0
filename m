Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC825761D84
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjGYPkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjGYPkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:40:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEFA1FD2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690299589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hl7TlGBY8KC9fCz4U38u+w32QQOwR9hjmIKn/+TtjDc=;
        b=UH4cFT/Fb5phvLgICtHnYIQCKwD5TArGvAnlD51gOq6rnMAoOKqS2FvBxA2l9S+q5HT7pO
        J+FTTT9cR+lGaFzA6T91nFJFKFv3A7urp+lYUvfgIqRP7LBxEcO86ncIa3kLB54e5l39EU
        z8erdL2SDI9ZYo9O0O46UYZHFCfRwTc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-WumnfkwONV2AlK1csc4ICw-1; Tue, 25 Jul 2023 11:39:36 -0400
X-MC-Unique: WumnfkwONV2AlK1csc4ICw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-403ae7d56baso71163991cf.3
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690299576; x=1690904376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hl7TlGBY8KC9fCz4U38u+w32QQOwR9hjmIKn/+TtjDc=;
        b=GeZT3CpPwhhNumQVB8FkZtzbDaEOhOs0KSpuRlj01y+6/iUSVYKzsFy0i7fyfcdPfn
         nBIkGZWMoTiBEEiCCplUP2PuN6xDGWKUljAftYSqsk+tMSBVpbwKg4OLNHIAaSPoS3XY
         bE/iSIPWbP95MHWcVO5BR634Tlf5x2MoRUpL5kBwitsznFAreGCIea4GQEsnPL0HKKNO
         b20fb5tvyUwWMnjR0IuFVXcKy156Nr5BDeFgVzyJtwlntMsQqYayHTEx+o+65YNKcmHt
         gfy2TzRX7FGXiWp3g5ECNjQWSjsZXo7Oaf8+Aox2xtteOwgB8GfgJfOkTBQwUVtY+95U
         LMGQ==
X-Gm-Message-State: ABy/qLb/3qksbAM2rOIezFNRCYeuRme0o/4w9CWuyIom/cP3aG6mow31
        Phwx2WwbHcruMmTgPGsy8CSKUg+RJFK5fbITNHThb0+LNN0aoXb7YItwc+lIqWUcD/DsR9o7Ilw
        CZ7P4SyVxJQ4E
X-Received: by 2002:a05:622a:1013:b0:402:76e3:59f6 with SMTP id d19-20020a05622a101300b0040276e359f6mr3746330qte.9.1690299576273;
        Tue, 25 Jul 2023 08:39:36 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFPTRjdLNSLA8c7aE0osG3x1L3hWBx5nQgehQrRb2Vj3GyGN/3UVxsy9bokM2ED6bC9iQzVnw==
X-Received: by 2002:a05:622a:1013:b0:402:76e3:59f6 with SMTP id d19-20020a05622a101300b0040276e359f6mr3746308qte.9.1690299576067;
        Tue, 25 Jul 2023 08:39:36 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.153.113])
        by smtp.gmail.com with ESMTPSA id s21-20020ac85ed5000000b00403b44bc230sm4085933qtx.95.2023.07.25.08.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 08:39:35 -0700 (PDT)
Date:   Tue, 25 Jul 2023 17:39:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 2/4] virtio/vsock: support MSG_PEEK for
 SOCK_SEQPACKET
Message-ID: <hwdcuy3wwlrirpgphlex6omdnrztz7hqhu4447nmqml5sjqx5x@7y45zuyto7yq>
References: <20230719192708.1775162-1-AVKrasnov@sberdevices.ru>
 <20230719192708.1775162-3-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230719192708.1775162-3-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 10:27:06PM +0300, Arseniy Krasnov wrote:
>This adds support of MSG_PEEK flag for SOCK_SEQPACKET type of socket.
>Difference with SOCK_STREAM is that this callback returns either length
>of the message or error.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 63 +++++++++++++++++++++++--
> 1 file changed, 60 insertions(+), 3 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 2ee40574c339..352d042b130b 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -460,6 +460,63 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static ssize_t
>+virtio_transport_seqpacket_do_peek(struct vsock_sock *vsk,
>+				   struct msghdr *msg)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct sk_buff *skb;
>+	size_t total, len;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	if (!vvs->msg_count) {
>+		spin_unlock_bh(&vvs->rx_lock);
>+		return 0;
>+	}
>+
>+	total = 0;
>+	len = msg_data_left(msg);
>+
>+	skb_queue_walk(&vvs->rx_queue, skb) {
>+		struct virtio_vsock_hdr *hdr;
>+
>+		if (total < len) {
>+			size_t bytes;
>+			int err;
>+
>+			bytes = len - total;
>+			if (bytes > skb->len)
>+				bytes = skb->len;
>+
>+			spin_unlock_bh(&vvs->rx_lock);
>+
>+			/* sk_lock is held by caller so no one else can dequeue.
>+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>+			 */
>+			err = memcpy_to_msg(msg, skb->data, bytes);
>+			if (err)
>+				return err;
>+
>+			spin_lock_bh(&vvs->rx_lock);
>+		}
>+
>+		total += skb->len;
>+		hdr = virtio_vsock_hdr(skb);
>+
>+		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) {
>+			if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOR)
>+				msg->msg_flags |= MSG_EOR;
>+
>+			break;
>+		}
>+	}
>+
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	return total;
>+}
>+
> static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 						 struct msghdr *msg,
> 						 int flags)
>@@ -554,9 +611,9 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> 				   int flags)
> {
> 	if (flags & MSG_PEEK)
>-		return -EOPNOTSUPP;
>-
>-	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
>+		return virtio_transport_seqpacket_do_peek(vsk, msg);
>+	else
>+		return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>
>-- 
>2.25.1
>

