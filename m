Return-Path: <kvm+bounces-4465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10EFF812CE9
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 11:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 179F31C214B0
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A5C73C461;
	Thu, 14 Dec 2023 10:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bo7FbkhB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B314118
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702549788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mNaidnArOatG5DPMZgGUNeTPrppTOu1ght+u2+9nPgo=;
	b=Bo7FbkhBee1ZsvFqeKV7xlwzV5nF0IJGhAJx6U2JV8Z+ctcFplytgVYwjJX4sN88q9f9sZ
	cC4huT7To850WW0hMa+JESjiJSw+r4Pb9KOIHxEMIZmDf2vmrTQrqZfhd8tGsX69bUN0rz
	wS0wp8XDJQ+CwYqVBd6rbncnzCrFeao=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-10PMUlKmMG-yLMOPzDb7aA-1; Thu, 14 Dec 2023 05:29:47 -0500
X-MC-Unique: 10PMUlKmMG-yLMOPzDb7aA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ca29454857so73217371fa.0
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:29:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702549785; x=1703154585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNaidnArOatG5DPMZgGUNeTPrppTOu1ght+u2+9nPgo=;
        b=q3P+egTM4HQna7Umr62nrnoC3EXRKuiK+IDVExcYA4KG52f/zLNDF/zmFfN80vOFxi
         d4h8IqdqXxm5CikddRRFj7zWd6potqr9gdaRheaHprghlv5okSHCvGao79zkuCs2M1AC
         ZDMsEi9zTdTqZjWSIY82hD8jNg2rEvaTOzFvN3uSKyz3x60uOi+rJmUQV02T6vYRVoPG
         DvIyWwezplAXvTTV6rQF7bfKtuAN89c8UuoMNd3wVnkUioIyJSjb22cjBkHAZ8zIUXx6
         X3BD/boFG5fcTmEbx0HuPLicoip1LxzFBucitQyPmGoasbmQ94YTgRAQZsO9axSk7iMZ
         B7DQ==
X-Gm-Message-State: AOJu0Yz3oZ0BEM1rtiJK8+WORUO1EOGltY8Kl2e6THo2YTaenEzP2W3t
	dVHulH1BZo4FK9Sv4Y3zru6GF1L5OuyyfFLmyC6zvHAY17CXkE203MSf7cz3VZGpmxkH0qSs+hG
	QGWjXqcVbPTkq
X-Received: by 2002:a2e:b88a:0:b0:2cc:1c21:f729 with SMTP id r10-20020a2eb88a000000b002cc1c21f729mr3199476ljp.60.1702549785335;
        Thu, 14 Dec 2023 02:29:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjkT5w/kdScbgQ5jnlJ/iNq1v76LhwoQiz85pVMwCHKmLvFjAg9HfOnqm6pisPjZpcYg0XYw==
X-Received: by 2002:a2e:b88a:0:b0:2cc:1c21:f729 with SMTP id r10-20020a2eb88a000000b002cc1c21f729mr3199467ljp.60.1702549784912;
        Thu, 14 Dec 2023 02:29:44 -0800 (PST)
Received: from redhat.com ([2.52.132.243])
        by smtp.gmail.com with ESMTPSA id v21-20020a2e9615000000b002c9f1316121sm2098658ljh.36.2023.12.14.02.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 02:29:43 -0800 (PST)
Date: Thu, 14 Dec 2023 05:29:38 -0500
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
Subject: Re: [PATCH net-next v9 3/4] vsock: update SO_RCVLOWAT setting
 callback
Message-ID: <20231214052502-mutt-send-email-mst@kernel.org>
References: <20231214091947.395892-1-avkrasnov@salutedevices.com>
 <20231214091947.395892-4-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214091947.395892-4-avkrasnov@salutedevices.com>

On Thu, Dec 14, 2023 at 12:19:46PM +0300, Arseniy Krasnov wrote:
> Do not return if transport callback for SO_RCVLOWAT is set (only in
> error case). In this case we don't need to set 'sk_rcvlowat' field in
> each transport - only in 'vsock_set_rcvlowat()'. Also, if 'sk_rcvlowat'
> is now set only in af_vsock.c, change callback name from 'set_rcvlowat'
> to 'notify_set_rcvlowat'.
> 
> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Maybe squash this with patch 2/4?

> ---
>  Changelog:
>  v3 -> v4:
>   * Rename 'set_rcvlowat' to 'notify_set_rcvlowat'.
>   * Commit message updated.
> 
>  include/net/af_vsock.h           | 2 +-
>  net/vmw_vsock/af_vsock.c         | 9 +++++++--
>  net/vmw_vsock/hyperv_transport.c | 4 ++--
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> index e302c0e804d0..535701efc1e5 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -137,7 +137,6 @@ struct vsock_transport {
>  	u64 (*stream_rcvhiwat)(struct vsock_sock *);
>  	bool (*stream_is_active)(struct vsock_sock *);
>  	bool (*stream_allow)(u32 cid, u32 port);
> -	int (*set_rcvlowat)(struct vsock_sock *vsk, int val);
>  
>  	/* SEQ_PACKET. */
>  	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> @@ -168,6 +167,7 @@ struct vsock_transport {
>  		struct vsock_transport_send_notify_data *);
>  	/* sk_lock held by the caller */
>  	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
> +	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
>  
>  	/* Shutdown. */
>  	int (*shutdown)(struct vsock_sock *, int);
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 816725af281f..54ba7316f808 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -2264,8 +2264,13 @@ static int vsock_set_rcvlowat(struct sock *sk, int val)
>  
>  	transport = vsk->transport;
>  
> -	if (transport && transport->set_rcvlowat)
> -		return transport->set_rcvlowat(vsk, val);
> +	if (transport && transport->notify_set_rcvlowat) {
> +		int err;
> +
> +		err = transport->notify_set_rcvlowat(vsk, val);
> +		if (err)
> +			return err;
> +	}
>  
>  	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
>  	return 0;



I would s

> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> index 7cb1a9d2cdb4..e2157e387217 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -816,7 +816,7 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vsk, ssize_t written,
>  }
>  
>  static
> -int hvs_set_rcvlowat(struct vsock_sock *vsk, int val)
> +int hvs_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
>  {
>  	return -EOPNOTSUPP;
>  }
> @@ -856,7 +856,7 @@ static struct vsock_transport hvs_transport = {
>  	.notify_send_pre_enqueue  = hvs_notify_send_pre_enqueue,
>  	.notify_send_post_enqueue = hvs_notify_send_post_enqueue,
>  
> -	.set_rcvlowat             = hvs_set_rcvlowat
> +	.notify_set_rcvlowat      = hvs_notify_set_rcvlowat
>  };
>  
>  static bool hvs_check_transport(struct vsock_sock *vsk)
> -- 
> 2.25.1


