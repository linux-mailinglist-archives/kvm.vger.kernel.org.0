Return-Path: <kvm+bounces-4464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E752F812CDA
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 11:25:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0409D1C21550
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB223C060;
	Thu, 14 Dec 2023 10:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijj2xQtW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CBCAF
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702549488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DSSH8LtzM2s/nHi8p5P1p50CtgKbNQDA/Xelk2DiA14=;
	b=ijj2xQtW7klWiHpC6Jyf3UNxDJ4Sy1cUiY+fyHG/gVFPdD7IpKRUvHCxuGc4vjgOKKvd99
	Ed9n0xcKPFzygb67uhIPjZYWXbmZ+GtPpJtccw1kpt5Vs8XDW054J9InhOqUp5oIb6nX64
	PmgWevn2VnePlFQtGGEhTDF8aoqCA9s=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-DcyZwwt5NDWfMXOZQffTMw-1; Thu, 14 Dec 2023 05:24:46 -0500
X-MC-Unique: DcyZwwt5NDWfMXOZQffTMw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a1d03a03bc9so440498366b.0
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702549485; x=1703154285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSSH8LtzM2s/nHi8p5P1p50CtgKbNQDA/Xelk2DiA14=;
        b=M/m4i72wy6aIrVnbQIF6qlq1WHObL1u1ZE6S3UXJ2Jcow1Cphnmbh7b8LwZQm/iWap
         9hL2jcrIEvaYNlRdfuhSAX8QcaIrxZtf+rxowksPJApUPXkG8JPS20Zt1siu1Z49omym
         pwEh35g+E/59jULb+d4KUGmK+imFtB2ydVZN28WQcxwwGu6+zRHYpwSzyX8uIVM1ytyU
         yg4KfDarNV4VDD45PrlfY21ceYvaGooS35fIVbVY6xoceLp4kiifLKgOQAuX/ipEIXzq
         YUpHWGvfWhE002ytYA2thAMPR1WwK+0c54UvLeWvBGQ+GgDODc1ZDJbUdquD7706Hucb
         W7sg==
X-Gm-Message-State: AOJu0Yz+zbcQD8/MXz6PRGYnQT1rWLd7virXh5uQkYpRviErXcczd5sy
	PsGcvJF3fi9sdZWzJPNGMBhQzn3fUR3LV/X4B6kyC9fPmkfG7JdNPxkc/OybvvneGLtaZJFhgp0
	+0ckg5R1R2+Hg
X-Received: by 2002:a17:907:3a97:b0:a1f:7352:3c0 with SMTP id fh23-20020a1709073a9700b00a1f735203c0mr4111130ejc.59.1702549485723;
        Thu, 14 Dec 2023 02:24:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJ4mtbeRMe02kWwF6Hh+xBcu1mR/wHuPokTQ+4Rni40u2pBzA16VxW6ly8OowEf1SbmDDVig==
X-Received: by 2002:a17:907:3a97:b0:a1f:7352:3c0 with SMTP id fh23-20020a1709073a9700b00a1f735203c0mr4111122ejc.59.1702549485320;
        Thu, 14 Dec 2023 02:24:45 -0800 (PST)
Received: from redhat.com ([2.52.132.243])
        by smtp.gmail.com with ESMTPSA id vv6-20020a170907a68600b00a1dff479037sm9103575ejc.127.2023.12.14.02.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 02:24:44 -0800 (PST)
Date: Thu, 14 Dec 2023 05:24:40 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v9 2/4] virtio/vsock: send credit update during
 setting SO_RCVLOWAT
Message-ID: <20231214052234-mutt-send-email-mst@kernel.org>
References: <20231214091947.395892-1-avkrasnov@salutedevices.com>
 <20231214091947.395892-3-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214091947.395892-3-avkrasnov@salutedevices.com>

On Thu, Dec 14, 2023 at 12:19:45PM +0300, Arseniy Krasnov wrote:
> Send credit update message when SO_RCVLOWAT is updated and it is bigger
> than number of bytes in rx queue. It is needed, because 'poll()' will
> wait until number of bytes in rx queue will be not smaller than
> SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
> for tx/rx is possible: sender waits for free space and receiver is
> waiting data in 'poll()'.
> 
> Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  Changelog:
>  v1 -> v2:
>   * Update commit message by removing 'This patch adds XXX' manner.
>   * Do not initialize 'send_update' variable - set it directly during
>     first usage.
>  v3 -> v4:
>   * Fit comment in 'virtio_transport_notify_set_rcvlowat()' to 80 chars.
>  v4 -> v5:
>   * Do not change callbacks order in transport structures.
>  v5 -> v6:
>   * Reorder callbacks in transport structures.
>   * Do to send credit update when 'fwd_cnt' == 'last_fwd_cnt'.
>  v8 -> v9:
>   * Add 'Fixes' tag.
> 
>  drivers/vhost/vsock.c                   |  1 +
>  include/linux/virtio_vsock.h            |  1 +
>  net/vmw_vsock/virtio_transport.c        |  1 +
>  net/vmw_vsock/virtio_transport_common.c | 30 +++++++++++++++++++++++++
>  net/vmw_vsock/vsock_loopback.c          |  1 +
>  5 files changed, 34 insertions(+)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index f75731396b7e..ec20ecff85c7 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -449,6 +449,7 @@ static struct virtio_transport vhost_transport = {
>  		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
>  		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>  

This needs to be set_rcvlowat.

>  		.read_skb = virtio_transport_read_skb,
>  	},
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index ebb3ce63d64d..c82089dee0c8 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>  void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
>  int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>  int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val);
>  #endif /* _LINUX_VIRTIO_VSOCK_H */
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index af5bab1acee1..f495b9e5186b 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -537,6 +537,7 @@ static struct virtio_transport virtio_transport = {
>  		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
>  		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>  
>  		.read_skb = virtio_transport_read_skb,
>  	},


This, too.

> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 7eabe5219ef7..9d2305fdc65c 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1690,6 +1690,36 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>  
> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
> +{
> +	struct virtio_vsock_sock *vvs = vsk->trans;
> +	bool send_update;
> +
> +	spin_lock_bh(&vvs->rx_lock);
> +
> +	/* If number of available bytes is less than new SO_RCVLOWAT value,
> +	 * kick sender to send more data, because sender may sleep in its
> +	 * 'send()' syscall waiting for enough space at our side. Also
> +	 * don't send credit update when peer already knows actual value -
> +	 * such transmission will be useless.
> +	 */
> +	send_update = (vvs->rx_bytes < val) &&
> +		      (vvs->fwd_cnt != vvs->last_fwd_cnt);
> +
> +	spin_unlock_bh(&vvs->rx_lock);
> +
> +	if (send_update) {
> +		int err;
> +
> +		err = virtio_transport_send_credit_update(vsk);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(virtio_transport_notify_set_rcvlowat);
> +
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Asias He");
>  MODULE_DESCRIPTION("common code for virtio vsock");

I think you need to set sk->sk_rcvlowat here, no?
Follow up patch will move it to transport independent code.


> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> index 048640167411..6dea6119f5b2 100644
> --- a/net/vmw_vsock/vsock_loopback.c
> +++ b/net/vmw_vsock/vsock_loopback.c
> @@ -96,6 +96,7 @@ static struct virtio_transport loopback_transport = {
>  		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
>  		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>  
>  		.read_skb = virtio_transport_read_skb,
>  	},
> -- 
> 2.25.1


