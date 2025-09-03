Return-Path: <kvm+bounces-56687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 679EAB420B3
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 15:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D370D5659DA
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 13:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBCF0302CB7;
	Wed,  3 Sep 2025 13:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VF/+0vZn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E6A2FE56E
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 13:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756905202; cv=none; b=ChxiWiQqY/b+Gd8BfPYdn/JTv+XnXJPcWtRDWX3pxD2KPgOuDYnX+e9jTieu/XNz6RZwMn3Sv+V6zbUvBJvku8oE3lDV8Q3YEnaKBW7Wyma0VxgiKWWeY2cvMpyFDTYxLWmExd+0GH+WWipEdctGNV/mM5kOyBSawIdsFiTJg0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756905202; c=relaxed/simple;
	bh=mBGx6bKd//U8D94s4t2SoXU3lLXnSajCr2AAkuXi1ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kCa/6SXfgfhivnEIIoDNcwMSP3JkUSqBeuGgW1lorELFXw2mrpBkRNWXB3PqavMq9m3ojKgDfCsIjuN5sw7FUKYKiDP7SeDZL/LvtiDA/bdwA6n/5fvceKNFSeIis97JLzs9L+0gzH7CHOAI5Diz+TE4lRvhWxhR69GNwU2u5UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VF/+0vZn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756905199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yc++Bk4gHq8rVQO2rd4UcrQ6O5BuxTUofo1WcPNdozc=;
	b=VF/+0vZnTxPQvsb0kKvZKoyveDOm5MKg8ToadYjjrJRpW2yyUABL8ifQShp+0960zS8+e7
	yMxeK6/7uRgmBBvFigrePzuTgxu/PpLIs7Z11ZvV6MZPIoDm8qGLI6NiS7ChKsZtzTLMFM
	XKbWC2zkEtAvS9JusgiO4Vpirv6xgNA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-wE_j6YsEO0CsMLiLFIwI4Q-1; Wed, 03 Sep 2025 09:13:16 -0400
X-MC-Unique: wE_j6YsEO0CsMLiLFIwI4Q-1
X-Mimecast-MFC-AGG-ID: wE_j6YsEO0CsMLiLFIwI4Q_1756905195
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3cf48ec9fc1so3295383f8f.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 06:13:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756905195; x=1757509995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yc++Bk4gHq8rVQO2rd4UcrQ6O5BuxTUofo1WcPNdozc=;
        b=fTD0mrn7Gz9HYKyUsoeyYsCi3Z/e0XDHcmmMgIOxlxpAcetwakIgVyUHtZTJfEGVTb
         msM/ZDTC+dVD2EGekHqulgXaaROd/rGFURVVaS2DBOA4h/LYKF544vn+NTNsJfyYZTb2
         H7CwTgaMK7O9soJ3r/R72AU8Onuen8ynN74tZ1s8ox7KkhtQx1rpXYqo5V7fQazQVEk5
         AWxS0EX1p70QJaFrnyda6hERvIl8vzHJ/ElDWpFz3ui8X9s7puWJ/G4kC40zGH0Juzqz
         e995ksqDx1kT+WHnWQY8XaC/5NXtw/aJlHvGmnYy0JP0VPn+Ja+RSNRiVN6jSRWDGAZl
         PENg==
X-Forwarded-Encrypted: i=1; AJvYcCU3N6UiZWHo7ROKvtpwe6wSYnKIx6raG8C+VDEd+xxTdbcjbCS0BdFCnHsUSmZPkfyWvpI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD0skSCPrFpz4ZZuXD82P7vTZ776wsUug8T50oFLfDPb47kN8c
	DMFXxecLD0huH3GuhsTQqghN5OljFVhMwTlu02ab34Gs2eruQkaldzyTKY4TUnkNJ7iyqluVafu
	8pMdCcgCt8FubE65gWWWR1inpGOeE3GIMirPDVp3UAhASvxmzhjZx/A==
X-Gm-Gg: ASbGncs7hWPIDOEr0OyZ6BzH3aotBai2KLzxHCcIwbobp3FgmRuR6cCp+Q4+WEEkxzY
	tGSccyRpg56VfftgZ71KDOuWCbIrJkixmYqmTLP6xwMcI6wHf9ZaY4vRMacZdcWFAiP/vICQPwf
	OEqKyKE3N3qjbVOeX8lsunkbCS1Ivm4IAKni63Y5EjlZtWSwySUtnFCKIbwfl+Z3ttqsRqV+Za3
	20y2f4gNAfIUFLqWerwEGCmjJa+Tbr1ZUTFOfQWMXqwjYC1v9hiq6c3xtXW6vkLfy0KUZnYeedT
	f5o53EK6Q/yCxOwPKu7C9EuHpM1nwg==
X-Received: by 2002:a05:6000:25ee:b0:3d6:92ed:cae8 with SMTP id ffacd0b85a97d-3d692edce86mr10643417f8f.34.1756905195271;
        Wed, 03 Sep 2025 06:13:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5Rd9SrgoaV2dgKrR38B9EwqokmCVv2zYCp6Unv9lrkeF9C49ix2kdTmzDinE3j4u/W7oa3Q==
X-Received: by 2002:a05:6000:25ee:b0:3d6:92ed:cae8 with SMTP id ffacd0b85a97d-3d692edce86mr10643375f8f.34.1756905194800;
        Wed, 03 Sep 2025 06:13:14 -0700 (PDT)
Received: from redhat.com ([2a0e:41b:f000:0:c4d3:2073:6af0:f91d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d2250115fdsm18102932f8f.40.2025.09.03.06.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 06:13:14 -0700 (PDT)
Date: Wed, 3 Sep 2025 09:13:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	eperezma@redhat.com, stephen@networkplumber.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: Re: [PATCH 2/4] netdev queue flow control for TUN
Message-ID: <20250903091235-mutt-send-email-mst@kernel.org>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-3-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902080957.47265-3-simon.schippers@tu-dortmund.de>

On Tue, Sep 02, 2025 at 10:09:55AM +0200, Simon Schippers wrote:
> The netdev queue is stopped in tun_net_xmit after inserting an SKB into
> the ring buffer if the ring buffer became full because of that. If the
> insertion into the ptr_ring fails, the netdev queue is also stopped and
> the SKB is dropped. However, this never happened in my testing. To ensure
> that the ptr_ring change is available to the consumer before the netdev
> queue stop, an smp_wmb() is used.

I think the stop -> wake bounce involves enough barriers already,
no need for us to get cute.


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


