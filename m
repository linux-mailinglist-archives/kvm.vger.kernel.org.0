Return-Path: <kvm+bounces-56635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 252C9B40F48
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 23:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0C8D5634CF
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 21:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B70E32254B;
	Tue,  2 Sep 2025 21:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lK1JraAy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9AB25A352;
	Tue,  2 Sep 2025 21:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756848062; cv=none; b=MQOuSNHY55AW6Qj9mW8AlxbpmvTQXaQxBma6fKtgYpQSvw7NRryB60p93iJNUq/qKqhX/ZWHq+MD3DYqsm7onp3Qd3hj58Bmr9doFv+pPSnfUNx4J/Srd3cV+U39RPMyVKAS1BFspvE9a6C18g/AYEme+X7bfy+nbrdlHiccWZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756848062; c=relaxed/simple;
	bh=QBs0BxXPPYnVgn9eUCRqkoZcgllTusHsEqOy4VqsvVE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=K7v1n/MB2xtt0Mdg7Ao7qH5TXLUuuTPGRzrfPg/qFoBm69MVet99zTyMvjOKyjC/NqswI/MZJBDumRb/nNS4kplG4M2JTZ6A3b9riKGXdfcN9HGfZPqTnr+0J53KcenuTSkQ3KBDzAbwmOy2JdlgTZEbczpcfmXYB//aWJ+nQzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lK1JraAy; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-544a2cf582dso2247053e0c.3;
        Tue, 02 Sep 2025 14:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756848060; x=1757452860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53hIoQImPlGDst5vzPSofTSU41eeRvNanKRKYwKta0M=;
        b=lK1JraAyXXvvJSP0Pr2reiDb+R3Ew3ZmQGfwzZNstDBnBG/iA2RC+wJJ4SjtMzF6GH
         ci2LJJqQoUIb0yYnnGcFvd589DSJt8kVIsW2CNRnYN+NfEqh7VnV+gwKr80dbQKA+C4b
         8pfhrgxHhEZ6u8ceVkNRER/ivKm0XG+UVhav5oKnNkZ7ACEAzrZQB6PV2Tr189gH81Xb
         k/lnq/G6vY2KDq0KEUfI2n6zCLoTRaLrnmbSEnriscYOB7h8/ZxFtTJ4gwpqqt16/bm3
         vH835GDKvngtf+omkpE1of3pW7Lw7Gt3NY7KYDOUo/WYwMV1x54GcFuv9I72a3FE8WTt
         w6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756848060; x=1757452860;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=53hIoQImPlGDst5vzPSofTSU41eeRvNanKRKYwKta0M=;
        b=d3ibrXZOPswmQrSvkkfiw7njNEQoalZONJfKWttSb+rWvVC0F8nkOLR9UMEU4u7YT6
         tSWcZXi9BS+WjykV2BbeEbT+AnWdOBMSxBkQU9GVF19rTgIyarG3R9xciu7Huz7ZPZJJ
         oDli7fEIt+FqnslmlZgZ6y6mCvTHVVB9RZKWiiDHaWrUsn4FtEJkXYmPWNDZ2hKSnv9f
         nYEve35AdPEe2z1Zy0sJAF39337wP1kGfVys58CPJO6Jfmb/fanARQnHwCj6kgPgcQJS
         bmI3bl304kxq2aPzpXT+qRruZi4x6gwVZAVeClPUmk5Ed9LRO9D0IZ3M0apNHtOu6M3v
         WphQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrcJrwFt48/I/RKtipGsqi8AV/HUiRMGoQdO05BBoPCaPlaqG8G01/GKyYR/lEPaB/d9XZ9/sB@vger.kernel.org, AJvYcCVGN5VtaS19ZbigDevPuJHfpmjQ+CN46uB9kRU/GwGpAfFIDSd7fBf6V/q9CJDUyBsfGgM=@vger.kernel.org, AJvYcCVcHRUxhhhSEGetc95EnSiIFAj7OIjQo63AUbfq1/nktrYaJ7QDnQoj+FE9DN8jhJkN7fEh1wzAJSavERC6@vger.kernel.org
X-Gm-Message-State: AOJu0YwW5EBwXHztBKVsJ6F0DOALKo+BTqOkNOETXRzi89eq49YUjwGm
	MLWVrvQH6GwITm/+CFb5E9xxOHG9WHVdE517rYArtg2Xs2nsUf+eEEM0
X-Gm-Gg: ASbGncuPCbAGMEyKoPxqCkLU58+c1z48SDhnQrUeBTUoCQBeRrnM1oS/ul4VhsxtNgH
	OvygZrotIHNXsouEglnrm1bHteF2kD4ipfRedSLi/qupjzGEd8sYeySitOWifnYEUk5IVkFPx/7
	//2w1vUTEuW/c8s9RIk7FPu983KUMbhyAhziYZyEJkvDb0X5FW6ueQ+aIR0MNQUgRHanga/gIvp
	Cg1srQ47oKeGVidHudAUiTKdBH9DM0UPNNeutyOZsQwKJIZTiqE3+C9SQXEoOY7ogxWM/oKkQ/K
	mrhF4rnHghxrM1B0hyDSEiT3Y/keBNatIZXcuB0APv3W/qazb+cQgHtFuNSncpZOOrqrwL9qVd3
	+g/XAEvAH6E+bMqY7NjlaHhab38X1Fb+5gv5ewBURsu7B8mEzCy7xJ5326xSEVHAlbmDvgh0WBo
	AUOw==
X-Google-Smtp-Source: AGHT+IHyzqCUmnLp9Lx9HtQ8SB7WTRMOJVAnPBxQrEsa8zeDDc6Qfs4QckcRDY3laJFJYg93fmf1Jg==
X-Received: by 2002:a05:6122:179e:b0:544:98a0:4869 with SMTP id 71dfb90a1353d-544a01328b7mr4149923e0c.3.1756848059787;
        Tue, 02 Sep 2025 14:20:59 -0700 (PDT)
Received: from gmail.com (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 71dfb90a1353d-544912eef59sm6135401e0c.8.2025.09.02.14.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 14:20:59 -0700 (PDT)
Date: Tue, 02 Sep 2025 17:20:58 -0400
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
Message-ID: <willemdebruijn.kernel.243baccfedc16@gmail.com>
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
> the SKB is dropped. However, this never happened in my testing.

Indeed, since the last successful insertion will always pause the
queue before this can happen. Since this cannot be reached, no need
to add the code defensively. If in doubt, maybe add a
NET_DEBUG_WARN_ON_ONCE.

> To ensure
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
> +
>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>  {
>  	DECLARE_WAITQUEUE(wait, current);
> @@ -2139,7 +2165,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>  			error = -EFAULT;
>  			break;
>  		}
> -
> +		wake_netdev_queue(tfile);

Why wake when no entry was consumed?

Also keep the empty line.

>  		schedule();
>  	}
>  
> @@ -2147,6 +2173,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>  	remove_wait_queue(&tfile->socket.wq.wait, &wait);
>  
>  out:
> +	wake_netdev_queue(tfile);
>  	*err = error;
>  	return ptr;
>  }
> -- 
> 2.43.0
> 



