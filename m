Return-Path: <kvm+bounces-35129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B75B3A09E56
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C48A516AA3E
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1AB21D5A6;
	Fri, 10 Jan 2025 22:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b="ZfofuTOQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E165A21CA0E
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 22:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549325; cv=none; b=S6Yyt2Y7DdeLt74VL6aI5FyV4p/BKOfOZ/BjBu3XoupwpBSBtOKCBImo5R6edkXzHDt5gsUSOpOMimQ93L0kN1pZPqkKWG2mfqIy58UBDDsfIsATINqiFPeE23iTKQDUWqZlsI0nGiqoZgrQrwP+Hhhnf7BkNv76vwbU1Ep8mz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549325; c=relaxed/simple;
	bh=AWn3AuB7yHOLd4iesrrxgcRSmxPBHT0ef3tOlCuWqWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqohlw+BPqJCKlmiSoaq4InVy06v9suKNGIdUznLVH55Q3rUELQT3tdvKm28JXaQHX3EGwMXm1q14lvLeN9S1TT8B60di5+2zR0jF/7xuWdf6ejHJdOy2yhV6k2vKSFCFLwr+nkVVklFrfXvD/j+X4NB76E2kYahiAsb+wpR1OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io; spf=pass smtp.mailfrom=theori.io; dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b=ZfofuTOQ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theori.io
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-216426b0865so43564215ad.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1736549323; x=1737154123; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LzXivbWavWl+dN7CMkxVZypF4oLVVAvtUtJdUE5p7A0=;
        b=ZfofuTOQaH+V2FRiaPv/56FlYOSSqGW34iuKAPEAMGYGj0a9hjKWh6uXQ86MxCjVK7
         XzT/7DT3Z4Qt8nHTi79/FUlHg2Gg1aZj9YBkMZkQt4w50YwBfH8Nr+sXOwM99PCGqif1
         5e0tE2gy9BpOID+Mk4F/+vJM+gJjiuZGgjjrs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736549323; x=1737154123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzXivbWavWl+dN7CMkxVZypF4oLVVAvtUtJdUE5p7A0=;
        b=CHjN0/+w1/wT+N2M+nArNQG1U7FXMq/HOxsfFkOVTsR+35CnIaSRCZzXOg1Lgm+Hov
         fDvc6K0RYc5oZ7YBZNq7CnQo4CA/bTw/NmSOy/rhgkHsFQNmNGPRDTJTO8aQUbAvbXfo
         NC8I0rwkjjzPxvTdCtZAe7MnX1N9hu+QInWQalcjjzCSzQ/Rh0GcTonplei4xLmH6bU5
         y9BVkr0gX8BZ3461ZT3HwnMv4LfU6SCoUsBEqu7N8cNefXujzbtLvJSTsL6szP2cP002
         r32iy1vQzyb72aw0Zra6ao3JovV8RZI1Mom0yZGFAgUbBisbNuqgKDqyGcMD+Im5lQ7V
         xQ/w==
X-Forwarded-Encrypted: i=1; AJvYcCWGP1aHBOJhx5K+t+P9pbOXguuaHgM3PYkV6PVVYFvCGBf3DskiYu4ww2mnTlvxTLjHuyk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvDbOOUxOZZwkr6AbqRJJLCTPUxDYl61U4WbZU54rJDKGrxjrE
	tNtk/M9k/jsPbnBKVmEDhHCfxSbiQ6CjjfarQL1KXtzHu1wJJ/nK1Rrz01E3/PU=
X-Gm-Gg: ASbGncut+wwZ9uUM7mszItzA2Ol5/JDpq9ZMSDmcAWAyLDs/Luxvt+nP3DzAMzpzhkj
	CuG8RJ1Lf5RlD7WHcCB/63pwggtcwkzJozO2vM0twAkUbadLmXOjUFK6aphPtmf7iwmxwZFvjrA
	z/Duxb/XVg4MmZp0Q5/lSauR1t4vopLJ02adUyBjLxerp7dV1y7npj735ZGjNr2Zu05ieJB50ti
	91F85i/pN27Ujaj3VpN/+4K4SY3/vzPPqjgh1Hi6o/znFr0T1pcqXOV+mKtCI35e64Jbg==
X-Google-Smtp-Source: AGHT+IFL3U05bezNqg95x2HmYQVnB18znOwGddscITDSjOdMEJTGA2bZLmFShcBBgvVENgRqTIzeYw==
X-Received: by 2002:a05:6a20:a10c:b0:1db:ec0f:5cf4 with SMTP id adf61e73a8af0-1e88d0d9c40mr20159487637.39.1736549323168;
        Fri, 10 Jan 2025 14:48:43 -0800 (PST)
Received: from v4bel-B760M-AORUS-ELITE-AX ([211.219.71.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d4068178csm2065630b3a.148.2025.01.10.14.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 14:48:42 -0800 (PST)
Date: Fri, 10 Jan 2025 17:48:35 -0500
From: Hyunwoo Kim <v4bel@theori.io>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
	Luigi Leonardi <leonardi@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wongi Lee <qwerty@theori.io>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Dumazet <edumazet@google.com>, kvm@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Michal Luczaj <mhal@rbox.co>,
	virtualization@lists.linux.dev,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	stable@vger.kernel.org, imv4bel@gmail.com, v4bel@theori.io
Subject: Re: [PATCH net v2 3/5] vsock/virtio: cancel close work in the
 destructor
Message-ID: <Z4Gjw6QMqnUsQUIw@v4bel-B760M-AORUS-ELITE-AX>
References: <20250110083511.30419-1-sgarzare@redhat.com>
 <20250110083511.30419-4-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110083511.30419-4-sgarzare@redhat.com>

On Fri, Jan 10, 2025 at 09:35:09AM +0100, Stefano Garzarella wrote:
> During virtio_transport_release() we can schedule a delayed work to
> perform the closing of the socket before destruction.
> 
> The destructor is called either when the socket is really destroyed
> (reference counter to zero), or it can also be called when we are
> de-assigning the transport.
> 
> In the former case, we are sure the delayed work has completed, because
> it holds a reference until it completes, so the destructor will
> definitely be called after the delayed work is finished.
> But in the latter case, the destructor is called by AF_VSOCK core, just
> after the release(), so there may still be delayed work scheduled.
> 
> Refactor the code, moving the code to delete the close work already in
> the do_close() to a new function. Invoke it during destruction to make
> sure we don't leave any pending work.
> 
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Cc: stable@vger.kernel.org
> Reported-by: Hyunwoo Kim <v4bel@theori.io>
> Closes: https://lore.kernel.org/netdev/Z37Sh+utS+iV3+eb@v4bel-B760M-AORUS-ELITE-AX/
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 29 ++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 51a494b69be8..7f7de6d88096 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -26,6 +26,9 @@
>  /* Threshold for detecting small packets to copy */
>  #define GOOD_COPY_LEN  128
>  
> +static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
> +					       bool cancel_timeout);
> +
>  static const struct virtio_transport *
>  virtio_transport_get_ops(struct vsock_sock *vsk)
>  {
> @@ -1109,6 +1112,8 @@ void virtio_transport_destruct(struct vsock_sock *vsk)
>  {
>  	struct virtio_vsock_sock *vvs = vsk->trans;
>  
> +	virtio_transport_cancel_close_work(vsk, true);
> +
>  	kfree(vvs);
>  	vsk->trans = NULL;
>  }
> @@ -1204,17 +1209,11 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
>  	}
>  }
>  
> -static void virtio_transport_do_close(struct vsock_sock *vsk,
> -				      bool cancel_timeout)
> +static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
> +					       bool cancel_timeout)
>  {
>  	struct sock *sk = sk_vsock(vsk);
>  
> -	sock_set_flag(sk, SOCK_DONE);
> -	vsk->peer_shutdown = SHUTDOWN_MASK;
> -	if (vsock_stream_has_data(vsk) <= 0)
> -		sk->sk_state = TCP_CLOSING;
> -	sk->sk_state_change(sk);
> -
>  	if (vsk->close_work_scheduled &&
>  	    (!cancel_timeout || cancel_delayed_work(&vsk->close_work))) {
>  		vsk->close_work_scheduled = false;
> @@ -1226,6 +1225,20 @@ static void virtio_transport_do_close(struct vsock_sock *vsk,
>  	}
>  }
>  
> +static void virtio_transport_do_close(struct vsock_sock *vsk,
> +				      bool cancel_timeout)
> +{
> +	struct sock *sk = sk_vsock(vsk);
> +
> +	sock_set_flag(sk, SOCK_DONE);
> +	vsk->peer_shutdown = SHUTDOWN_MASK;
> +	if (vsock_stream_has_data(vsk) <= 0)
> +		sk->sk_state = TCP_CLOSING;
> +	sk->sk_state_change(sk);
> +
> +	virtio_transport_cancel_close_work(vsk, cancel_timeout);
> +}
> +
>  static void virtio_transport_close_timeout(struct work_struct *work)
>  {
>  	struct vsock_sock *vsk =
> -- 
> 2.47.1
> 

The two scenarios I presented have been resolved.

Tested-by: Hyunwoo Kim <v4bel@theori.io>


Regards,
Hyunwoo Kim

