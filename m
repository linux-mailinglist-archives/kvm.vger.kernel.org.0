Return-Path: <kvm+bounces-56636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A540B40F66
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 23:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3632F5E5AE3
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 21:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652A835A2B5;
	Tue,  2 Sep 2025 21:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ceeF8MPe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AF126E704;
	Tue,  2 Sep 2025 21:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756848668; cv=none; b=efvtXiz8zuXJlQIx5fMIxWV8zav+oZbHCBwzhzve68q0YxuLNKm3DUWgNjCvJfAvnmaWSES3DC80QYUpEcGIgzKbyxHghQ2sIDJ48jkhpJVic1w+8bA+lAvj1cvvH832fTkyO5QvIp/nr6cqfiKgA+C/1JeszHkVh9hOctO8ZS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756848668; c=relaxed/simple;
	bh=ehRCK06hQBQS1EJ8tAoqHs1vIhIJ+AvMT4WxbAEfCaI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=LjKHnNRf1O6RScLqp763/hJb18h4f3L7bLrBybkDQ4ylMya0LDoMrlad10d9UWKMy+OSIl2j+B1bfaK/9xkq+ZWk6ngtJYn+qwEl2Uxo9CBDj6L8tHdi616BxfZeXcu8mLQFjoBxbqFuInH261xYTB1Alu3YnooatL0YrsElVOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ceeF8MPe; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b109c4af9eso51057841cf.3;
        Tue, 02 Sep 2025 14:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756848666; x=1757453466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrmfAL77oCr2lyI+ImgSTfu5UDVysM82HoeUlv+ch0k=;
        b=ceeF8MPe+owQ2PD6sbcmBBlllFplNl7Zni5vticnX6uL1iM3Nc8WgD9Q6bybbw+Ooy
         7m/27JEYVZUw1UnQDZgIHQfBIaLDT/aTquFzNSG0rxu84HDhOOna34XDSoqp3omcjd48
         kmcjlU4AjrgSWdMXoRmVp4tzZU4TNjuiAhnqYiszqeqqwD8mhxEDzh3CGWFsz4KuTR84
         p6h0qri7/HKV0QZrLGtrf8lk502zTFkA4pT+Nds9Pvib9Lujscbrk2KSTdaXhhVWOjmv
         jVW1C/RSEj44jeU6+xu3RPlBT6ix8/smlWE+vBOlArVs0G0EootDHf5okw5lkmDU5W5K
         JhbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756848666; x=1757453466;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZrmfAL77oCr2lyI+ImgSTfu5UDVysM82HoeUlv+ch0k=;
        b=ZeOcrtcMXsOmP9FvnUBmYjgUABWoSjlUbBazw7JHXWIoiB/4xxJ1bEJnjrNi1VOY/Y
         dJGhgwn0NNsJ29rySzxgIew8RO8l1gGZbdmiWsXUJk3k3qVhD1t+qpb+BvvNrqWBPygE
         oP/qoUtGA4Wp9yX3swdhoPoDK37CdO2h0rfIJgS/IlH1GchPFiAJ/zHh1aZYx30ecxYl
         hq0QFTfmbZ0iW1/dpMFWalNbLw4gRIR8j6Ps5XoI76kQBVmAkf70l7Dira7BHVEwqOZM
         E+5FuFGX6y7DREpM9bqhyJaaA48B566O8SxnNFcHW3Z4+K03rP+8hwK/ewF7utGqENQF
         ABOg==
X-Forwarded-Encrypted: i=1; AJvYcCUxNFLDeYSvJWWL3j/c0y5oFOLVlsfNFveIb5u1iymN/yvu85p1VqVyxry0iBqtdu3Ljb07MhPF@vger.kernel.org, AJvYcCXLFYXHo+YbZFXjngl06jYqRgPieeaT8TW2FBcEjc86WjYYX79YhfjukQNzdByATFTGdUM=@vger.kernel.org, AJvYcCXxpk+j1/2AxkzUE4FYLocSljNrMY1iOvWXiQn9vUfv5cWpQY5mzYAdGblRG7wTWmI6rLIOeo13N0H91klV@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/MfHbxNo7ZZOR9Wtu6hhh8ZSuzUgA/snBwowGAeWfwtv8KUDy
	LEdFYft4YHNYAIKlgCDNjKWsjsxlKszAeESAFQGh4AAfJVFZmucoKak4
X-Gm-Gg: ASbGncth2YIu15+NIjKcuv8zVD/y1mYD0zVQSae54DBBlQzguSG2v20EwlG8rDLRQ4c
	oy+eafXB1LlipuRDN8sZYDemfupy3Wmne0lSqbOJxUtBd1vb/jBWzFXaQSy1TrG2YsI3DyrdHZh
	K+o0x6EKOY8SjOC3bH/6bB4AQVL5HNGJXMtE4fHB11L3FzQzi/AdOEDgGBxENf/1H76836hsRf4
	UwbFnjeYkwajmVQiQuWGcL1UznofLsyRIuINKfZ2UnpxLqATfU/sj89UsK8AKprnkBqP+G3e7Ks
	NWjTxDE8tP1TPCj52EAaPekhn1LFa2IbDn4T1ujYP6zQV56Z/JUjSOOhaB5/hXMWeWr0DGKFFlq
	dii8md9maP4fJ2nyGxyXvDxOTvfXdRU+RuEpSSoMclxSCe861w7PRKymaAsvk59OXcu2dw5wnMv
	F4aA==
X-Google-Smtp-Source: AGHT+IF7iJ3n8Ilr2HLnvwXXtRnIaBo6KUz7SGLPQzYvQZNV3FrYUDrLl/ZnyDGI7QVYJ6DoiIS0gQ==
X-Received: by 2002:ac8:57d2:0:b0:4b3:214:1eb2 with SMTP id d75a77b69052e-4b31da18d25mr183076721cf.47.1756848665582;
        Tue, 02 Sep 2025 14:31:05 -0700 (PDT)
Received: from gmail.com (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4b48f635cbesm1378441cf.5.2025.09.02.14.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 14:31:05 -0700 (PDT)
Date: Tue, 02 Sep 2025 17:31:04 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>, 
 willemdebruijn.kernel@gmail.com, 
 jasowang@redhat.com, 
 mst@redhat.com, 
 eperezma@redhat.com, 
 stephen@networkplumber.org, 
 netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>, 
 Tim Gebauer <tim.gebauer@tu-dortmund.de>
Message-ID: <willemdebruijn.kernel.251eacee11eca@gmail.com>
In-Reply-To: <20250902080957.47265-5-simon.schippers@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-5-simon.schippers@tu-dortmund.de>
Subject: Re: [PATCH 4/4] netdev queue flow control for vhost_net
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Simon Schippers wrote:
> Stopping the queue is done in tun_net_xmit.
> 
> Waking the queue is done by calling one of the helpers,
> tun_wake_netdev_queue and tap_wake_netdev_queue. For that, in
> get_wake_netdev_queue, the correct method is determined and saved in the
> function pointer wake_netdev_queue of the vhost_net_virtqueue. Then, each
> time after consuming a batch in vhost_net_buf_produce, wake_netdev_queue
> is called.
> 
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  drivers/net/tap.c      |  6 ++++++
>  drivers/net/tun.c      |  6 ++++++
>  drivers/vhost/net.c    | 34 ++++++++++++++++++++++++++++------
>  include/linux/if_tap.h |  2 ++
>  include/linux/if_tun.h |  3 +++
>  5 files changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 4d874672bcd7..0bad9e3d59af 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -1198,6 +1198,12 @@ struct socket *tap_get_socket(struct file *file)
>  }
>  EXPORT_SYMBOL_GPL(tap_get_socket);
>  
> +void tap_wake_netdev_queue(struct file *file)
> +{
> +	wake_netdev_queue(file->private_data);
> +}
> +EXPORT_SYMBOL_GPL(tap_wake_netdev_queue);
> +
>  struct ptr_ring *tap_get_ptr_ring(struct file *file)
>  {
>  	struct tap_queue *q;
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 735498e221d8..e85589b596ac 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -3739,6 +3739,12 @@ struct socket *tun_get_socket(struct file *file)
>  }
>  EXPORT_SYMBOL_GPL(tun_get_socket);
>  
> +void tun_wake_netdev_queue(struct file *file)
> +{
> +	wake_netdev_queue(file->private_data);
> +}
> +EXPORT_SYMBOL_GPL(tun_wake_netdev_queue);

Having multiple functions with the same name is tad annoying from a 
cscape PoV, better to call the internal functions
__tun_wake_netdev_queue, etc.

> +
>  struct ptr_ring *tun_get_tx_ring(struct file *file)
>  {
>  	struct tun_file *tfile;
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 6edac0c1ba9b..e837d3a334f1 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -130,6 +130,7 @@ struct vhost_net_virtqueue {
>  	struct vhost_net_buf rxq;
>  	/* Batched XDP buffs */
>  	struct xdp_buff *xdp;
> +	void (*wake_netdev_queue)(struct file *f);

Indirect function calls are expensive post spectre. Probably
preferable to just have a branch.

A branch in `file->f_op != &tun_fops` would be expensive still as it
may touch a cold cacheline.

How about adding a bit in struct ptr_ring itself. Pahole shows plenty
of holes. Jason, WDYT?

>  };
>  
>  struct vhost_net {
> @@ -175,13 +176,16 @@ static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
>  	return ret;
>  }
>  
> -static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
> +static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq,
> +								 struct sock *sk)
>  {
> +	struct file *file = sk->sk_socket->file;
>  	struct vhost_net_buf *rxq = &nvq->rxq;
>  
>  	rxq->head = 0;
>  	rxq->tail = ptr_ring_consume_batched(nvq->rx_ring, rxq->queue,
>  					      VHOST_NET_BATCH);
> +	nvq->wake_netdev_queue(file);
>  	return rxq->tail;
>  }
>  
> @@ -208,14 +212,15 @@ static int vhost_net_buf_peek_len(void *ptr)
>  	return __skb_array_len_with_tag(ptr);
>  }
>  
> -static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq)
> +static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq,
> +							  struct sock *sk)

odd indentation

>  {
>  	struct vhost_net_buf *rxq = &nvq->rxq;
>  
>  	if (!vhost_net_buf_is_empty(rxq))
>  		goto out;
>  
> -	if (!vhost_net_buf_produce(nvq))
> +	if (!vhost_net_buf_produce(nvq, sk))
>  		return 0;
>  
>  out:
> @@ -994,7 +999,7 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
>  	unsigned long flags;
>  
>  	if (rvq->rx_ring)
> -		return vhost_net_buf_peek(rvq);
> +		return vhost_net_buf_peek(rvq, sk);
>  
>  	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
>  	head = skb_peek(&sk->sk_receive_queue);
> @@ -1499,6 +1504,19 @@ static struct socket *get_tap_socket(int fd)
>  	return sock;
>  }
>  
> +static void (*get_wake_netdev_queue(struct file *file))(struct file *file)
> +{
> +	struct ptr_ring *ring;
> +
> +	ring = tun_get_tx_ring(file);
> +	if (!IS_ERR(ring))
> +		return tun_wake_netdev_queue;
> +	ring = tap_get_ptr_ring(file);
> +	if (!IS_ERR(ring))
> +		return tap_wake_netdev_queue;
> +	return NULL;
> +}
> +
>  static struct socket *get_socket(int fd)
>  {
>  	struct socket *sock;
> @@ -1570,10 +1588,14 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  		if (r)
>  			goto err_used;
>  		if (index == VHOST_NET_VQ_RX) {
> -			if (sock)
> +			if (sock) {
>  				nvq->rx_ring = get_tap_ptr_ring(sock->file);
> -			else
> +				nvq->wake_netdev_queue =
> +					get_wake_netdev_queue(sock->file);
> +			} else {
>  				nvq->rx_ring = NULL;
> +				nvq->wake_netdev_queue = NULL;
> +			}
>  		}
>  
>  		oldubufs = nvq->ubufs;
> diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
> index 553552fa635c..02b2809784b5 100644
> --- a/include/linux/if_tap.h
> +++ b/include/linux/if_tap.h
> @@ -10,6 +10,7 @@ struct socket;
>  
>  #if IS_ENABLED(CONFIG_TAP)
>  struct socket *tap_get_socket(struct file *);
> +void tap_wake_netdev_queue(struct file *file);
>  struct ptr_ring *tap_get_ptr_ring(struct file *file);
>  #else
>  #include <linux/err.h>
> @@ -18,6 +19,7 @@ static inline struct socket *tap_get_socket(struct file *f)
>  {
>  	return ERR_PTR(-EINVAL);
>  }
> +static inline void tap_wake_netdev_queue(struct file *f) {}
>  static inline struct ptr_ring *tap_get_ptr_ring(struct file *f)
>  {
>  	return ERR_PTR(-EINVAL);
> diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
> index 80166eb62f41..04c504bb1954 100644
> --- a/include/linux/if_tun.h
> +++ b/include/linux/if_tun.h
> @@ -21,6 +21,7 @@ struct tun_msg_ctl {
>  
>  #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
>  struct socket *tun_get_socket(struct file *);
> +void tun_wake_netdev_queue(struct file *file);
>  struct ptr_ring *tun_get_tx_ring(struct file *file);
>  
>  static inline bool tun_is_xdp_frame(void *ptr)
> @@ -50,6 +51,8 @@ static inline struct socket *tun_get_socket(struct file *f)
>  	return ERR_PTR(-EINVAL);
>  }
>  
> +static inline void tun_wake_netdev_queue(struct file *f) {}
> +
>  static inline struct ptr_ring *tun_get_tx_ring(struct file *f)
>  {
>  	return ERR_PTR(-EINVAL);
> -- 
> 2.43.0
> 



