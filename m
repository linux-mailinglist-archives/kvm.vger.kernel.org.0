Return-Path: <kvm+bounces-2916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D00A57FF06E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:43:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85FFA28206D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3D7482D9;
	Thu, 30 Nov 2023 13:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gSQpTb+H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D484E1708
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701351778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uy3DbGLAD6/MqJDeL8rt+rWlvOEmyAT8Ng7w858TURY=;
	b=gSQpTb+Hq9E6l4d2OiRyYygDtq969nscznqhyhbuprcGgQzEusidEEfZLH04qeaXuxPRP4
	Sbmk6Qw+ukjlnH1jBNPmNLKY9ZZ5Bt6etKqbz8ySrbIIvDCbpYnTM/sT2mdCHkZjo39Pr1
	qBpim6ht0qjxX8BZcT9H1vlyruOAFBY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-GNF50myBP8ORCmDf0rv68A-1; Thu, 30 Nov 2023 08:42:56 -0500
X-MC-Unique: GNF50myBP8ORCmDf0rv68A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40b32faeb7eso7599025e9.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:42:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701351775; x=1701956575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uy3DbGLAD6/MqJDeL8rt+rWlvOEmyAT8Ng7w858TURY=;
        b=CP+dAiX0A/3EUsENfmsWDL4K+KS6IBgpKq0vEmHl6y9KpX86YFlX6cIZAoYJEoYZDD
         miKLCYUx9cQurAqfpQw0j8I1561dVurnfDtCJelVPngRDQGXRYRJnlZQJGqv6H+jJDZI
         BbGr4GJm6VjvuEPrhQvfuSvOF6ix9YaZL6D7qdFLb+IYH6oOZZW93MP0xtxiS0OQJjcC
         zU5xzi270FOEIw9zwi33UhdTAkRZNU7mEQs0kY0mLxUtkhSqeq/X1VkvTZy0NM9uKTSN
         3/2UU94AxqnvVv7wIcXSwsY3pqYPSWBTnJtuAoEKUW8IUl0LZD9xwEyML8q7aYE1iV7A
         Wtog==
X-Gm-Message-State: AOJu0YwvbZU2kSoI5IgmlWULNzMfPLI6pb5Sy9PLWuI6e1ZwDLGBw4qJ
	EYYbGuCXOZ3nFK0rHc/c1IfH1gll0CHaXXbm0GEGaLc1jmXCom2kG9Omj2Imxea6JOCqaD4Ggoo
	gRX7u3bypq/W2
X-Received: by 2002:a05:600c:3c93:b0:409:6e0e:e948 with SMTP id bg19-20020a05600c3c9300b004096e0ee948mr15037442wmb.1.1701351775678;
        Thu, 30 Nov 2023 05:42:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEM/gy08YFSforqNM+D8EaAMPSjzZfnQ8ZpsK233LcwLbEQqvchhKz7NIu/y4LteP2ZPySqeg==
X-Received: by 2002:a05:600c:3c93:b0:409:6e0e:e948 with SMTP id bg19-20020a05600c3c9300b004096e0ee948mr15037419wmb.1.1701351775237;
        Thu, 30 Nov 2023 05:42:55 -0800 (PST)
Received: from redhat.com ([2.55.57.48])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b0040b4fca8620sm5775206wmo.37.2023.11.30.05.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 05:42:53 -0800 (PST)
Date: Thu, 30 Nov 2023 08:42:49 -0500
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
Subject: Re: [PATCH net-next v5 2/3] virtio/vsock: send credit update during
 setting SO_RCVLOWAT
Message-ID: <20231130084044-mutt-send-email-mst@kernel.org>
References: <20231130130840.253733-1-avkrasnov@salutedevices.com>
 <20231130130840.253733-3-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130130840.253733-3-avkrasnov@salutedevices.com>

On Thu, Nov 30, 2023 at 04:08:39PM +0300, Arseniy Krasnov wrote:
> Send credit update message when SO_RCVLOWAT is updated and it is bigger
> than number of bytes in rx queue. It is needed, because 'poll()' will
> wait until number of bytes in rx queue will be not smaller than
> SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
> for tx/rx is possible: sender waits for free space and receiver is
> waiting data in 'poll()'.
> 
> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
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
> 
>  drivers/vhost/vsock.c                   |  1 +
>  include/linux/virtio_vsock.h            |  1 +
>  net/vmw_vsock/virtio_transport.c        |  1 +
>  net/vmw_vsock/virtio_transport_common.c | 27 +++++++++++++++++++++++++
>  net/vmw_vsock/vsock_loopback.c          |  1 +
>  5 files changed, 31 insertions(+)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index f75731396b7e..4146f80db8ac 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -451,6 +451,7 @@ static struct virtio_transport vhost_transport = {
>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>  
>  		.read_skb = virtio_transport_read_skb,
> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>  	},
>  
>  	.send_pkt = vhost_transport_send_pkt,
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
> index af5bab1acee1..8007593a3a93 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -539,6 +539,7 @@ static struct virtio_transport virtio_transport = {
>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>  
>  		.read_skb = virtio_transport_read_skb,
> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>  	},
>  
>  	.send_pkt = virtio_transport_send_pkt,
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index f6dc896bf44c..1cb556ad4597 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1684,6 +1684,33 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
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
> +	 * 'send()' syscall waiting for enough space at our side.
> +	 */
> +	send_update = vvs->rx_bytes < val;
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


I find it strange that this will send a credit update
even if nothing changed since this was called previously.
I'm not sure whether this is a problem protocol-wise,
but it certainly was not envisioned when the protocol was
built. WDYT?


> +EXPORT_SYMBOL_GPL(virtio_transport_notify_set_rcvlowat);
> +
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Asias He");
>  MODULE_DESCRIPTION("common code for virtio vsock");
> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> index 048640167411..9f4b814fbbc7 100644
> --- a/net/vmw_vsock/vsock_loopback.c
> +++ b/net/vmw_vsock/vsock_loopback.c
> @@ -98,6 +98,7 @@ static struct virtio_transport loopback_transport = {
>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>  
>  		.read_skb = virtio_transport_read_skb,
> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>  	},
>  
>  	.send_pkt = vsock_loopback_send_pkt,
> -- 
> 2.25.1


