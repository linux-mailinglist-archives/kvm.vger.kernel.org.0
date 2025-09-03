Return-Path: <kvm+bounces-56696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C3BB428F6
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 20:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 717C71BA07C7
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 18:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67FAF36932A;
	Wed,  3 Sep 2025 18:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="i0qq2+0t"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456513629B3;
	Wed,  3 Sep 2025 18:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756925126; cv=none; b=XSs5vI2dBd5G8CouHwP/IaRjStuysC7UxZBRllhEppiNHv2JPdiJ/wGs2AOIli4aMQ0T8G4Zu5tMDephB0w9mkOpqVSfGjAjNBmyiuUj3FvcryvREbN9Zzm2Y3cW2ZafN+hwr7KoTmGDhqZPpR4gD+1GLDvMH6lkUx8GDUPALxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756925126; c=relaxed/simple;
	bh=yy8dNluZEt1F3hOJQ5JWTdfKQiHarz/++Lo+f/eAcgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SteAeT3nLIYSmTnAeBDx4/xx4EJC2yXzmMR6eocALCrVyiqN9zZsZthJTbeR+ARScUQzm0Yb0C3cB4QdMY5rhbI3/uJZ0mQWnMqlyXmP7PbiTZ9oLXsPvDyXn9gbQToU+nwbj4HgC2+8bnRkXk4sjhAw1ZH7a5skIHZ6IzImc0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=i0qq2+0t; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (pd9eaae6b.dip0.t-ipconnect.de [217.234.174.107])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 583IjK8r020038
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Sep 2025 20:45:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756925121;
	bh=yy8dNluZEt1F3hOJQ5JWTdfKQiHarz/++Lo+f/eAcgE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i0qq2+0tvBdwa+QzPIEJbCMy5KEaX0T7nvssbjLUdhCV6PUJ4sh+0vkaI5ZNk4gjO
	 i03wSSXFHB6tZuiMHczngkA6eQ9Q9Xe22uKWhAr7+rVMyxPtKA7VfSbWMQMpudm+Sq
	 di/p8HWVRO7DHsEVT3hIczuIyoIwfl/o3hgDxcHg=
Message-ID: <62ab3029-3089-430a-b80d-85d87ad7daae@tu-dortmund.de>
Date: Wed, 3 Sep 2025 20:45:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] netdev queue flow control for TUN
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, eperezma@redhat.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-3-simon.schippers@tu-dortmund.de>
 <20250903090723-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20250903090723-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Michael S. Tsirkin wrote:
> On Tue, Sep 02, 2025 at 10:09:55AM +0200, Simon Schippers wrote:
>> The netdev queue is stopped in tun_net_xmit after inserting an SKB into
>> the ring buffer if the ring buffer became full because of that. If the
>> insertion into the ptr_ring fails, the netdev queue is also stopped and
>> the SKB is dropped. However, this never happened in my testing. To ensure
>> that the ptr_ring change is available to the consumer before the netdev
>> queue stop, an smp_wmb() is used.
>>
>> Then in tun_ring_recv, the new helper wake_netdev_queue is called in the
>> blocking wait queue and after consuming an SKB from the ptr_ring. This
>> helper first checks if the netdev queue has stopped. Then with the paired
>> smp_rmb() it is known that tun_net_xmit will not produce SKBs anymore.
>> With that knowledge, the helper can then wake the netdev queue if there is
>> at least a single spare slot in the ptr_ring by calling ptr_ring_spare
>> with cnt=1.
>>
>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> 
> 
> Oh you just want to know if produce will succeed?
> Kind of a version of peek but for producer?
> 
> So all this cuteness of looking at the consumer is actually not necessary,
> and bad for cache.
> 
> You just want this:
> 
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index 551329220e4f..de25fe81dd4e 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -96,6 +96,14 @@ static inline bool ptr_ring_full_bh(struct ptr_ring *r)
>  	return ret;
>  }
>  
> +static inline int __ptr_ring_produce_peek(struct ptr_ring *r)
> +{
> +	if (unlikely(!r->size) || r->queue[r->producer])
> +		return -ENOSPC;
> +
> +	return 0;
> +}
> +
>  /* Note: callers invoking this in a loop must use a compiler barrier,
>   * for example cpu_relax(). Callers must hold producer_lock.
>   * Callers are responsible for making sure pointer that is being queued
> @@ -103,8 +111,10 @@ static inline bool ptr_ring_full_bh(struct ptr_ring *r)
>   */
>  static inline int __ptr_ring_produce(struct ptr_ring *r, void *ptr)
>  {
> -	if (unlikely(!r->size) || r->queue[r->producer])
> -		return -ENOSPC;
> +	int r = __ptr_ring_produce_peek(r);
> +
> +	if (r)
> +		return r;
>  
>  	/* Make sure the pointer we are storing points to a valid data. */
>  	/* Pairs with the dependency ordering in __ptr_ring_consume. */
> 
> 
> 
> Add some docs, and call this, then wake.  No?
>

Yes, this looks great! I like that it does not need any further logic :)
I will just call this method instead of my approach in wake_netdev_queue
without taking any locks. It should be just fine since at this moment it
is known that the producer stopped due to the stopped netdev queue.

