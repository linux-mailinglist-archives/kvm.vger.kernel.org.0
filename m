Return-Path: <kvm+bounces-56637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC529B40F6F
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 23:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14A6D1B60535
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 21:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5AD335CEA5;
	Tue,  2 Sep 2025 21:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KPYsZK97"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8686735AABF;
	Tue,  2 Sep 2025 21:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756848707; cv=none; b=VX50WOPv8adyRd5myUwfPZfdstzKRvUhY6hjI75bEJRMF+/W2QnXOK/mxL1CeJKcbcx/jYVPiwRd8aXA0LEY4r0+Iir/zp4F1YqLk9l2x6n7yG0INj5Zkq4mzM3RjOWN9UcJkRLs0tTGxIPPPb5NXCLyAi4Ul+k5SQ/I1uw+lDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756848707; c=relaxed/simple;
	bh=Fhr1X2s81mKv666A5gstY8vVQTMahtF+o9XOsgjlsEU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=HpQ7xZdgUTDCbzqBTISI/Ea0Z7qPkVdO2KtUI78txDtDg8dcDwnN0VoWRsGeuUOq0l5in0I/nCHv/ErJ2p2yFEUcl7RItAevnLlVlJfwgxtl6wYW3Y8n6cmrj3Nmu4b9jcVGranxuYwSlhJKwXElcsyo0BhiaQn8qqI33z+cF3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KPYsZK97; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-71a2d730d03so19907116d6.3;
        Tue, 02 Sep 2025 14:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756848704; x=1757453504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ccBuzbs+BrHDDKe4TyRzIoAM5cAJ6pCAgSin1bdA9A=;
        b=KPYsZK97I8jOg3W85iMy8Ymt5wGRK3JZnEJ6S+N2sml+pFxW4ze7N7mb2OTm69P5S2
         MHmCDRaIK/NOGcOit4xceh5u+FNHBYrw4IlYAKHm3mwl+kiDZpM+1Lx7efZ5+oYr9dao
         X2TYiokd+jbMvUXG5dpSXM2tPeS1aGBOuIlX8KjxahsoMUnpqTDkwzqUGvHbez/3XFtd
         XfOyQYLkeVV1tFTTLTiZK8+encTuFI+TDJ4nKv+xkrzS/OxPY+N0e7l37+MY7Y8YOEF1
         HIgcU7l4qjwWtFGnEhTTfYF0go7/ZvTZmnSpLxsBXdwk7njpfrJDk0T3uTR8R5RBKF5m
         tZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756848704; x=1757453504;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5ccBuzbs+BrHDDKe4TyRzIoAM5cAJ6pCAgSin1bdA9A=;
        b=CDq+FrqQR/xiLDTajmuEF+mVezjtlJIAmi316HeKDGGTWut8ra7FYgfj+wBG0YlofE
         kBUEjzavUZGyCr+5WHQjwlluVxTTEGTyIh5YO2EiKjMQFqzDepbw7Gw+85KWhNOfsiDJ
         Zlnt3eB1qbe6EdV3Du9wDxdd3MoE1tBSLGdLKvHke3LmquyQCmhNZDFmnKtowlTEUroK
         D90ohjLJ6qSlvPIRE8wxYNJAknsfIb6R6DtzORgkB9oA9odXz9SfulTYbWVxeOIVx1nR
         xFa5PwDKUnUZLRAF/kfiA6+cAsiYHnYKUCU3klMh6vtK4khwwZTu4S2o3E8v1VsezKKT
         2lgA==
X-Forwarded-Encrypted: i=1; AJvYcCUQge+GyLXf6OAwNKzJExB1cOiHVw1NExRKKJcbBJlEa/7qEFP44nLlNHDYRWQhDv5m9XK+k+I5@vger.kernel.org, AJvYcCVx/4c3C6pOPM+YMtTF0pmxrTlqBZ5hLX6tAAZdWkuK6KUrU3yqjqlELD+JK7gNf6XikxRSQ8UqWsNjJgMp@vger.kernel.org, AJvYcCXaewxdzdY/44Z6OzDVhHp4sCYjPiarzh2mWklGJ3pgGaqdOXTvNb4Ras63A6BW+y6wlu0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwAuGdF/prYnrcAQeNZMHjYKEVzBljGgSyS6ClQmJa0QkjkJm9
	Qufwst6cDMLXE9ouPo4i7UnVlD8ppY8xTbWrVSDaEsVOpWKyAtwDJvvlSWQbWg==
X-Gm-Gg: ASbGncutBoknJ4MaOA+uy1RNBq5yMPHDcy1YqXRRbeYjll3zSdsmLUquWhYyJd7QtLd
	T6RCkgxMY2+2iENwJq+VAToJCxoNuBM9qX/ZYDBubkYlkg+8xJT1gdL1E5rbimjKVH7ZZ0TkCx3
	eFv5YSzRjzzL0inNkC1t06guRoG5WmrfMoi9RDri7f/lMWTJtmy8Y+kzQa5aSb/6tE+MIkf9Nd1
	M2wejpTdjC97UVV+VT+YCISGqiNd7ngL2j+Am2RFmnHzc+GzfmmeEaeE+B1Fp+ExuBlsatAZfOi
	Zyxg+wSaA2nUbS4PRE4cZRmRse5utChC3T3u5Gm8G9/IZiLuFRhVC4HCF1aXgrULvGnAocB0Ja5
	/lOnMngHD73zvtcJZZSBRjXCF7O4YDKT9wQBpoFqzo7nPLDcUurLeQiUZoeM0L+Bn9r8RKR307Y
	6k+A==
X-Google-Smtp-Source: AGHT+IHuSLao98z09CKcRFnRmWQxJ8TrKeoPQyY4lPLQgQdvitTmSna4yO9Wv7pVlwi66WpRyj7GFg==
X-Received: by 2002:a05:6214:1925:b0:721:7a6a:b703 with SMTP id 6a1803df08f44-7217a6ac7ffmr26477986d6.53.1756848704343;
        Tue, 02 Sep 2025 14:31:44 -0700 (PDT)
Received: from gmail.com (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-720b644f2c9sm18578666d6.63.2025.09.02.14.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 14:31:43 -0700 (PDT)
Date: Tue, 02 Sep 2025 17:31:43 -0400
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
Message-ID: <willemdebruijn.kernel.1b33a2385592@gmail.com>
In-Reply-To: <20250902080957.47265-3-simon.schippers@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-3-simon.schippers@tu-dortmund.de>
Subject: Re: [PATCH 2/4] netdev queue flow control for TUN
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
> The netdev queue is stopped in tun_net_xmit after inserting an SKB into
> the ring buffer if the ring buffer became full because of that. If the
> insertion into the ptr_ring fails, the netdev queue is also stopped and
> the SKB is dropped. However, this never happened in my testing. To ensure
> that the ptr_ring change is available to the consumer before the netdev
> queue stop, an smp_wmb() is used.
> 
> Then in tun_ring_recv, the new helper wake_netdev_queue is called in the
> blocking wait queue and after consuming an SKB from the ptr_ring. This
> helper first checks if the netdev queue has stopped. Then with the paired
> smp_rmb() it is known that tun_net_xmit will not produce SKBs anymore.
> With that knowledge, the helper can then wake the netdev queue if there is
> at least a single spare slot in the ptr_ring by calling ptr_ring_spare
> with cnt=1.
> 
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  drivers/net/tun.c | 33 ++++++++++++++++++++++++++++++---
>  1 file changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index cc6c50180663..735498e221d8 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1060,13 +1060,21 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	nf_reset_ct(skb);
>  
> -	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
> +	queue = netdev_get_tx_queue(dev, txq);
> +	if (unlikely(ptr_ring_produce(&tfile->tx_ring, skb))) {
> +		/* Paired with smp_rmb() in wake_netdev_queue. */
> +		smp_wmb();
> +		netif_tx_stop_queue(queue);
>  		drop_reason = SKB_DROP_REASON_FULL_RING;
>  		goto drop;
>  	}
> +	if (ptr_ring_full(&tfile->tx_ring)) {
> +		/* Paired with smp_rmb() in wake_netdev_queue. */
> +		smp_wmb();
> +		netif_tx_stop_queue(queue);
> +	}
>  
>  	/* dev->lltx requires to do our own update of trans_start */
> -	queue = netdev_get_tx_queue(dev, txq);
>  	txq_trans_cond_update(queue);
>  
>  	/* Notify and wake up reader process */
> @@ -2110,6 +2118,24 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>  	return total;
>  }
>  
> +static inline void wake_netdev_queue(struct tun_file *tfile)

no inline keyword in .c files, let the compiler decide.

> +{
> +	struct netdev_queue *txq;
> +	struct net_device *dev;
> +
> +	rcu_read_lock();
> +	dev = rcu_dereference(tfile->tun)->dev;
> +	txq = netdev_get_tx_queue(dev, tfile->queue_index);
> +
> +	if (netif_tx_queue_stopped(txq)) {
> +		/* Paired with smp_wmb() in tun_net_xmit. */
> +		smp_rmb();
> +		if (ptr_ring_spare(&tfile->tx_ring, 1))
> +			netif_tx_wake_queue(txq);
> +	}
> +	rcu_read_unlock();
> +}

