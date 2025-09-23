Return-Path: <kvm+bounces-58545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC66CB9674A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26B68166FA0
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5DD248F59;
	Tue, 23 Sep 2025 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FLUus4Ph"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DF41DF994
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 14:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639284; cv=none; b=mvrid/8mSnHpfR7aO6jDMAU1+0tbNtJ7qQ3Oq11GbJhNofYTy04SmMYHeeRnxX4ZX6vAVpUZ7rhASSm6SIuzwHMO9hyX4m18aYMpDLt4shhvdM9wD2P5xfzTrJOv1EnWYPxJG9/X5pBmvy7jLdih1zfIHIbMXbqJJp8BC1iudvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639284; c=relaxed/simple;
	bh=yLJ8trcIeN87cTM37Qp7/z/or3KwICs4V/zFq2dp/xY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6I5BuQXi35HTpuQy50LenXNVrRHDIKsIikluwc1FJf4zGO8ZC19rvx9n/YJo4Jl02nzhC/0Ll4KNoo2ca6F28H/dniv6qoMpldx3pKe/XbYe+pA2ZVp51ntFYunJ1+6dYieoQCTeLuKcHI9l5gAUsdSrkBSy453WML5IJSlBvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FLUus4Ph; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758639281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GlTGS/oUq6qr4tFK7p920ZEocw8mB7yDznWqUIeSU/0=;
	b=FLUus4PhA1JD+T3k8ndtD0IW63i7t8c0OvuYjykz66fRKReLtKf+ehlMkyl8cbxQbqOhkV
	cysZsWu6EjZDNl9v0/ZWfbcU3svKmQhr8SUVvnk4RLFfgujMsiWKOTwHPmsPDUJHiS1cRE
	4ZlxkyjQSxWQ/cOU3vBnX+Ybz6JCCNM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-DUJIFkbaMsOSFc8Z6Ex9rA-1; Tue, 23 Sep 2025 10:54:39 -0400
X-MC-Unique: DUJIFkbaMsOSFc8Z6Ex9rA-1
X-Mimecast-MFC-AGG-ID: DUJIFkbaMsOSFc8Z6Ex9rA_1758639279
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b2e6b2bb443so176686266b.2
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 07:54:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758639278; x=1759244078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GlTGS/oUq6qr4tFK7p920ZEocw8mB7yDznWqUIeSU/0=;
        b=eyy3ET685XwCUqFGuRTbdmTitrssPHhw4Kjw8pkyfXArvpcl96mBj+bbfcl2Wvtgbw
         JwZFU/5SpyH5QDsGHQCPrpBhPWS7+I0QX57TTOguLsyZvb32CjV0olLxDJHcuEi1xC7y
         B4sQkG8Hy7IZV+Ql8dj7o69Bap8roC92IRlMD0chJtWn/TidXrpOPBydIYLz2sQL4NUr
         RS1MmP32HvC8GVaIUfBB8t//I6mPMZ53hTB8BYPS1a0psS0CxYlHrw8DLp1xc1TdwTFi
         i/Xf17dOxd+e9Rx3w56be2bq2KAsnRtUs9l1+TnXRrTJhxMa6iSP/DpgaFfs6/EdVO+E
         Mq/g==
X-Forwarded-Encrypted: i=1; AJvYcCXzCjIwXUEag4wRndOxSZTY31HCwY4kwo/h/QCd/3HT2CbIQ1qXEQjCMf9yVureYZF7Dv0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzscx9fbvBTIopQusRVRStDYnFcNrPXboz5bw8EasFpiwvBLk2z
	accA6qvS6h60Og0YIrESzCgKPD/fKzrvo8AKYTkOmWcs9Ev3UOFmjHLOtlvVNyu5FqFwsZtyCWw
	ILiuEUjpnuCBXRxi5TVAm2s4mZtJF7maqisPfwxxZjk8/NF6AltYBWw==
X-Gm-Gg: ASbGncvsvhI9WLJhS5+0T4+PGT0ynk7R3FoHnH1+ZHLWGtFglNSAgagLEsSr/oC+rLz
	vQpRgvzAX/60c7rwwmAT2qFZrqxtjvUuWi5w3KxAJGntMjUMHXChCPl/WxfrZ3dVpdKW55qIh9F
	zv8DfB8tDv5I8rVwvC+KNZx+ACCmrv81jpbqVJavpuLlknhgLaVCAzXpND+BFeY5i1m/t2n6Is7
	O0qjlMiGpFLaycUTz9ISP93Kh9k7bJU80FYOoFqQVkjQc5TpcilyqMsGgCr6Kq8Myh0O30BgPYY
	z2C8vidxd0eljl9iNekY31EPF/qb5q9L7RY=
X-Received: by 2002:a17:906:4fca:b0:ae3:b2b7:7f2f with SMTP id a640c23a62f3a-b302a36d276mr320841966b.40.1758639278594;
        Tue, 23 Sep 2025 07:54:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0UY1L8jdF7RbmRM0SmnKrV7GJclLjE5bXJYDHMS+tHgb236lYdm0fYPTKRoEBIL9oZfqX0g==
X-Received: by 2002:a17:906:4fca:b0:ae3:b2b7:7f2f with SMTP id a640c23a62f3a-b302a36d276mr320838666b.40.1758639278088;
        Tue, 23 Sep 2025 07:54:38 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b2dd7bab2e6sm392363866b.41.2025.09.23.07.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 07:54:37 -0700 (PDT)
Date: Tue, 23 Sep 2025 10:54:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: Re: [PATCH net-next v5 4/8] TUN & TAP: Wake netdev queue after
 consuming an entry
Message-ID: <20250923104818-mutt-send-email-mst@kernel.org>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250922221553.47802-5-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922221553.47802-5-simon.schippers@tu-dortmund.de>

On Tue, Sep 23, 2025 at 12:15:49AM +0200, Simon Schippers wrote:
> The new wrappers tun_ring_consume/tap_ring_consume deal with consuming an
> entry of the ptr_ring and then waking the netdev queue when entries got
> invalidated to be used again by the producer.
> To avoid waking the netdev queue when the ptr_ring is full, it is checked
> if the netdev queue is stopped before invalidating entries. Like that the
> netdev queue can be safely woken after invalidating entries.
> 
> The READ_ONCE in __ptr_ring_peek, paired with the smp_wmb() in
> __ptr_ring_produce within tun_net_xmit guarantees that the information
> about the netdev queue being stopped is visible after __ptr_ring_peek is
> called.
> 
> The netdev queue is also woken after resizing the ptr_ring.
> 
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>


Sounds like there is subtle interplay here between queue stopped bit and
ring full status, all lockless with fancy ordering tricks.  I have to
say this is fragile. I'd like to see much more documentation.


Or alternatively, I ask myself if, after detecting flow control
issues, it is possible to just use a spinlock to synchronize,
somehow.


> ---
>  drivers/net/tap.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/net/tun.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 88 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 1197f245e873..f8292721a9d6 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -753,6 +753,46 @@ static ssize_t tap_put_user(struct tap_queue *q,
>  	return ret ? ret : total;
>  }
>  
> +static struct sk_buff *tap_ring_consume(struct tap_queue *q)
> +{
> +	struct netdev_queue *txq;
> +	struct net_device *dev;
> +	bool will_invalidate;
> +	bool stopped;
> +	void *ptr;
> +
> +	spin_lock(&q->ring.consumer_lock);
> +	ptr = __ptr_ring_peek(&q->ring);
> +	if (!ptr) {
> +		spin_unlock(&q->ring.consumer_lock);
> +		return ptr;
> +	}
> +
> +	/* Check if the queue stopped before zeroing out, so no ptr get
> +	 * produced in the meantime, because this could result in waking
> +	 * even though the ptr_ring is full. The order of the operations

which operations, I don't get it? it's unusual for barrier()
to be effective. are you trying to order the read in netif_tx_queue_stopped
versus the read in __ptr_ring_discard_one?
Then that would seem to need smp_rmb and accordingly smp_wmb in the
producing side.


> +	 * is ensured by barrier().
> +	 */
> +	will_invalidate = __ptr_ring_will_invalidate(&q->ring);
> +	if (unlikely(will_invalidate)) {
> +		rcu_read_lock();
> +		dev = rcu_dereference(q->tap)->dev;
> +		txq = netdev_get_tx_queue(dev, q->queue_index);
> +		stopped = netif_tx_queue_stopped(txq);
> +	}
> +	barrier();
> +	__ptr_ring_discard_one(&q->ring, will_invalidate);
> +
> +	if (unlikely(will_invalidate)) {
> +		if (stopped)
> +			netif_tx_wake_queue(txq);
> +		rcu_read_unlock();
> +	}
> +	spin_unlock(&q->ring.consumer_lock);
> +
> +	return ptr;
> +}
> +
>  static ssize_t tap_do_read(struct tap_queue *q,
>  			   struct iov_iter *to,
>  			   int noblock, struct sk_buff *skb)
> @@ -774,7 +814,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>  					TASK_INTERRUPTIBLE);
>  
>  		/* Read frames from the queue */
> -		skb = ptr_ring_consume(&q->ring);
> +		skb = tap_ring_consume(q);
>  		if (skb)
>  			break;
>  		if (noblock) {
> @@ -1207,6 +1247,8 @@ int tap_queue_resize(struct tap_dev *tap)
>  	ret = ptr_ring_resize_multiple_bh(rings, n,
>  					  dev->tx_queue_len, GFP_KERNEL,
>  					  __skb_array_destroy_skb);
> +	if (netif_running(dev))
> +		netif_tx_wake_all_queues(dev);
>  
>  	kfree(rings);
>  	return ret;
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index c6b22af9bae8..682df8157b55 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2114,13 +2114,53 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>  	return total;
>  }
>  
> +static void *tun_ring_consume(struct tun_file *tfile)
> +{
> +	struct netdev_queue *txq;
> +	struct net_device *dev;
> +	bool will_invalidate;
> +	bool stopped;
> +	void *ptr;
> +
> +	spin_lock(&tfile->tx_ring.consumer_lock);
> +	ptr = __ptr_ring_peek(&tfile->tx_ring);
> +	if (!ptr) {
> +		spin_unlock(&tfile->tx_ring.consumer_lock);
> +		return ptr;
> +	}
> +
> +	/* Check if the queue stopped before zeroing out, so no ptr get
> +	 * produced in the meantime, because this could result in waking
> +	 * even though the ptr_ring is full. The order of the operations
> +	 * is ensured by barrier().
> +	 */
> +	will_invalidate = __ptr_ring_will_invalidate(&tfile->tx_ring);
> +	if (unlikely(will_invalidate)) {
> +		rcu_read_lock();
> +		dev = rcu_dereference(tfile->tun)->dev;
> +		txq = netdev_get_tx_queue(dev, tfile->queue_index);
> +		stopped = netif_tx_queue_stopped(txq);
> +	}
> +	barrier();
> +	__ptr_ring_discard_one(&tfile->tx_ring, will_invalidate);
> +
> +	if (unlikely(will_invalidate)) {
> +		if (stopped)
> +			netif_tx_wake_queue(txq);
> +		rcu_read_unlock();
> +	}
> +	spin_unlock(&tfile->tx_ring.consumer_lock);
> +
> +	return ptr;
> +}
> +
>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>  {
>  	DECLARE_WAITQUEUE(wait, current);
>  	void *ptr = NULL;
>  	int error = 0;
>  
> -	ptr = ptr_ring_consume(&tfile->tx_ring);
> +	ptr = tun_ring_consume(tfile);
>  	if (ptr)
>  		goto out;
>  	if (noblock) {
> @@ -2132,7 +2172,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>  
>  	while (1) {
>  		set_current_state(TASK_INTERRUPTIBLE);
> -		ptr = ptr_ring_consume(&tfile->tx_ring);
> +		ptr = tun_ring_consume(tfile);
>  		if (ptr)
>  			break;
>  		if (signal_pending(current)) {
> @@ -3621,6 +3661,9 @@ static int tun_queue_resize(struct tun_struct *tun)
>  					  dev->tx_queue_len, GFP_KERNEL,
>  					  tun_ptr_free);
>  
> +	if (netif_running(dev))
> +		netif_tx_wake_all_queues(dev);
> +
>  	kfree(rings);
>  	return ret;
>  }
> -- 
> 2.43.0


