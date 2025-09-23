Return-Path: <kvm+bounces-58578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF91B96D94
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57C471701BF
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A7E328596;
	Tue, 23 Sep 2025 16:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NBEcD5Qi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ABF2E7F39
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758645399; cv=none; b=YHXSFUdGvnFMI03Jtf4mbRjCIBLUdwV3grt7zsgBWyDm8lK3p7le58ASTpayawLpfCpJMZH9paSh26CF/nBRxhGzeOClXmY+AstVpXSRS5EidyRQq0QWf9JBWL/RhpLkXSXcOEJjXN7O2lx59yts5/+/PFAxrm5UdUzRGF9G1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758645399; c=relaxed/simple;
	bh=WRbvQlH5wzDRTJnGfw2q29Hf/ZHyrfDOIIYTdpuj9BM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b842JnQVjJQhbwzBKOOErpR19KW0tay9h3p8QTRmwNWl7MkNqCCdKhGmhtsW3bPpCNbEZwGSzUdhxUFAv7X67qFWPqGFNcG1PggV3H2l0fwpCW3lXm+MT5HO2pjQRq82GINEnBZKzJ/swue7DqxQLwapU0DMogIzXelwpOhv9LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NBEcD5Qi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758645396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4zPpYQN6ZewmJa/VE3YRRkMpzAS6jQaLK0K7KotGZpQ=;
	b=NBEcD5Qiv2gX0T753SGheBABSh8/ttSYFCmv1qWl/Fnx92Gwx+QC+gu4qg9iY7ONhdO9vu
	awR7mU70XecMqFcCAp5QaqCC0jyNlOGrgM3u6avZOsijgGYhKF7dwSsNMDa3F6yaiX6Zc3
	/b9J6z8PF8MUihh2N5/r4zsjF4DxjPI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-muuNFjxQPrmlRbJc6_bArg-1; Tue, 23 Sep 2025 12:36:35 -0400
X-MC-Unique: muuNFjxQPrmlRbJc6_bArg-1
X-Mimecast-MFC-AGG-ID: muuNFjxQPrmlRbJc6_bArg_1758645394
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so2410989f8f.2
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 09:36:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758645394; x=1759250194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4zPpYQN6ZewmJa/VE3YRRkMpzAS6jQaLK0K7KotGZpQ=;
        b=hdH/S2diWDhzyMHvNjY1fl1yVoRfe+xheGkoRtp01LP42g1aoAFmBQotZdu6bXqWO3
         8o5qpZ0vr7bLg4jbLeWq1JplWPxfNfNnj6bLO43cPg2qZLSvfU9qhaAM0raklg7CObz0
         X9J38l+JoXc+v3LdEpIBtLy2YVrwekERTad5dlMTKcFnzkcGRix0uMF5ZuX/lR8mMW6x
         QMu4cpwRKYJi9t+ZihgMuFMrF3FgKq2dEAw+slejvyGeuqq9wEUStpx+TQdEaordGsyU
         aa/K6NWhBEGXSzJ1QUtTtZUWgCwCSqE8J/FQ0by4jBg2OOZVDK428pkcjEsdte/XT6ph
         czfg==
X-Forwarded-Encrypted: i=1; AJvYcCV/P+Ussi8dYjjDzO+f1gqp/aiyFMkMqU3RphOeTva27PqjrnBxXECFbAs1JjQWp6o4dvY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmsko8DBCc8eJ0/3ceMygwxUD7dWmaH2ToLZF3pfnEf1z1H6R6
	DSWl+qkHbKHBN4D90SCvd038re+g8/0ssU2Vq1P5hmA2BwTOiz72DCGLTz5PU+4lLFJPxKswEQR
	7cNmm6OI2QX2jw0k4X93FySyGHpXpP+szy4U9tmUgMSXKOlqSeJtUAw==
X-Gm-Gg: ASbGncstNjf5nliSip1ZktH1FLHfjihFxymVOGmOuSddEp50d+FbVCd6swa/hRWqrXx
	vr/QvaM0bVRQKyXcP62Oc1O4YDMiOKkWsbsQGNNCttUV2M70u9vF27pjTH//RIdnANRrpYb39Je
	N0ogflXLGVbhHn//M97jwBx1a6JAZNJT7qz0AyogJweqoPFzP1V3MkWUCe++fCxdDQbciHFJxAX
	LW8JB207EmV8S6TVGw2z4sytvRjneokbA8AP4aJ77yfdSXS2WQaXr2Qa1WhlW5uiJ9JxscV6yZ6
	UeT7ox6th4TD/pdhLjtBvPcA7SrlgXV5IGo=
X-Received: by 2002:a05:6000:1a87:b0:3ff:f55b:274a with SMTP id ffacd0b85a97d-405cb6c6b56mr2974004f8f.43.1758645393685;
        Tue, 23 Sep 2025 09:36:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOZ04vpd4BJvD9C2hR3DHmCmGT6e5v2KZ+8ep2PmkrMv09043lQZ0v8NtS5c34X1dkjLA54g==
X-Received: by 2002:a05:6000:1a87:b0:3ff:f55b:274a with SMTP id ffacd0b85a97d-405cb6c6b56mr2973978f8f.43.1758645393257;
        Tue, 23 Sep 2025 09:36:33 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f64ad359sm288273635e9.22.2025.09.23.09.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 09:36:32 -0700 (PDT)
Date: Tue, 23 Sep 2025 12:36:30 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: Re: [PATCH net-next v5 4/8] TUN & TAP: Wake netdev queue after
 consuming an entry
Message-ID: <20250923123101-mutt-send-email-mst@kernel.org>
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
> +	 * even though the ptr_ring is full.

So what? Maybe it would be a bit suboptimal? But with your design, I do
not get what prevents this:


	stopped? -> No
		ring is stopped
	discard

and queue stays stopped forever


> The order of the operations
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


After an entry is consumed, you can detect this by checking

	                r->consumer_head >= r->consumer_tail


so it seems you could keep calling regular ptr_ring_consume
and check afterwards?




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


