Return-Path: <kvm+bounces-56685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38AECB42063
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 15:07:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C5FE1BA82F8
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 13:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66BF302779;
	Wed,  3 Sep 2025 13:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhqrJBpm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464713009F8
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756904723; cv=none; b=nmOJ+xfBsXef42GoQ61wpULaU+51lsjlMBX4YtykqOJR2BhFGv2ab7pVXFN9Iaek/Ome837SqkYzDI44O0+a1ej3uglfvbgVj1KCk6UW2a2RbB67ID+4hanGBwzyMTwTY2GM5Wve01PWenDNrp7AETRoGDVqumSThJQbOjahZh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756904723; c=relaxed/simple;
	bh=wx8Tfq9Xifa0zuCHejFIDyBweEYkpVa68tCxnuiy/sM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nnZMgUJqtr/tNttZJgfuwS86den79nmWsu6uJTH3PEvFmg/Q5WH/doF9rEkGcMgB0lW4C643OWGPgK2cSzIJAY9swO4ra49/i1IgnOSj22k8OFr/5kDuouSa7w8aNdfng/GeALHy4G2B2c8f4eUgEcbW5KkMDSUpxgBXSU/bovU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BhqrJBpm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756904720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HrgPdVi1Tq/sUmSfRfVNUoce7RWoUa2jBaIiUDjya2s=;
	b=BhqrJBpmSzvZnCVW5+oIsvKSVmOFrDzcrG2XM+JwkIaYIRNnz/Ch9LlyDLupZlo0H9ynht
	AqG1V37J6xJ9L8esVfsmk0VTTLqmzwqNZt8r/HZRwSpo8ki9edpV5PgOV9mFjNMlsiY4qP
	uopOdNtVjkjAfQ3jnWwEmk5lS2gq5kQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-i9-5PXriMFCoHf4CmrsH-Q-1; Wed, 03 Sep 2025 09:05:19 -0400
X-MC-Unique: i9-5PXriMFCoHf4CmrsH-Q-1
X-Mimecast-MFC-AGG-ID: i9-5PXriMFCoHf4CmrsH-Q_1756904718
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb5dbda9cso4298755e9.2
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 06:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756904718; x=1757509518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HrgPdVi1Tq/sUmSfRfVNUoce7RWoUa2jBaIiUDjya2s=;
        b=UB0Fw+JoJ+AKw3VvHFmH6pd1QcMZGzN3anDvcbGfACNhbeTNxyd73rN66hQjmLN1kT
         w53/N2jxazvhOzMbkYV9A0bi/yc+gVVibqrLFAUWF20qQm6WibeweOrDgx5eXUk55X25
         ecXf7UUgrWcCDKIAH/ACkEWQ+Y4iMHDMh20pnivJbbVJxYmGcJ4U31tgCMMRWufYnGgp
         uYYrEyrEXEGyf/XcTFGXh3qGk1AagwjqCHSJgRkpWgChBgIUeUMOjwJc73Wc4EOGhn4O
         ObdXxmVq/RSPYkz08VvoZwJVacCg/OPNFMTU9NqXUl3id8O2kn7h412tc041wdQ6W03h
         Sn7g==
X-Forwarded-Encrypted: i=1; AJvYcCUHygmWKglvJtvLnO1a2Zl/5PzLZ1YMSiahXlq+r7ae+IeL12to5P7QRPOKR42E+Pt5/QA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzj7IlPukcS453DNdtJIpQbM9BkD3RPBRn+iiYvw8mgGghxrsi
	R01vqA1/V8UC9Qi+/L8SCaoT01DtM/RtqaSPEbtXD/f/k5wUQ2XJSFQEkb9fmKQk4q8m4lmqbTh
	zUun7MuXR6jJLli8co/T04CfWUQTpNuN/Ww+jwJNMTuAYFTQ+eIv5bQ==
X-Gm-Gg: ASbGncvkwpe4czAOTBBQ3YHlCbGP3K9P7G6VewKScXCtsUKKkjXbX/xy6tYIDeZ3Q2h
	VEJueu+iro9vViKJf4/cZ0W8bbJfTdimb6EGWbUnESFo99NexkrrXzCDN+xjnlDyWcyXJDZpgeH
	nZVcK6GZ+CQgbQ/bTgoJ5C6f7zo1c4+ZhxDdsUcuGMGKibWuYr+jISmPIraCICKAAAE/IbuHrZ0
	cCco3n1xPsXzc8lqnV4no4vvnFzsfozR7a8uS3vWTYCKOeMBdAIHvegAogu4Mt2RFzZCB3e43M4
	p+Rg88RR3YtryuBGJu32ITfolycZAQ==
X-Received: by 2002:a05:600c:3ba9:b0:456:1a41:f932 with SMTP id 5b1f17b1804b1-45c6fa9a71amr30616535e9.22.1756904717711;
        Wed, 03 Sep 2025 06:05:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtX1RsxlJvS5LBnQ6eZx2sJEwHto6VMfJqc79cmA6A9vHdfuL33yrAr/RXggLaExbbjXQUzA==
X-Received: by 2002:a05:600c:3ba9:b0:456:1a41:f932 with SMTP id 5b1f17b1804b1-45c6fa9a71amr30616165e9.22.1756904717260;
        Wed, 03 Sep 2025 06:05:17 -0700 (PDT)
Received: from redhat.com ([2a0e:41b:f000:0:c4d3:2073:6af0:f91d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b88007a60sm98473065e9.8.2025.09.03.06.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 06:05:16 -0700 (PDT)
Date: Wed, 3 Sep 2025 09:05:14 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	eperezma@redhat.com, stephen@networkplumber.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: Re: [PATCH 1/4] ptr_ring_spare: Helper to check if spare capacity of
 size cnt is available
Message-ID: <20250903085610-mutt-send-email-mst@kernel.org>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-2-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902080957.47265-2-simon.schippers@tu-dortmund.de>

On Tue, Sep 02, 2025 at 10:09:54AM +0200, Simon Schippers wrote:
> The implementation is inspired by ptr_ring_empty.
> 
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  include/linux/ptr_ring.h | 71 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index 551329220e4f..6b8cfaecf478 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -243,6 +243,77 @@ static inline bool ptr_ring_empty_bh(struct ptr_ring *r)
>  	return ret;
>  }
>  
> +/*
> + * Check if a spare capacity of cnt is available without taking any locks.

Not sure what "spare" means here. I think you mean

Check if the ring has enough space to produce a given
number of entries.

> + *
> + * If cnt==0 or cnt > r->size it acts the same as __ptr_ring_empty.

Logically, cnt = 0 should always be true, cnt > size should always be
false then?

Why do you want it to act as __ptr_ring_empty?


> + *
> + * The same requirements apply as described for __ptr_ring_empty.


Which is:

 * However, if some other CPU consumes ring entries at the same time, the value
 * returned is not guaranteed to be correct.


but it's not right here yes? consuming entries will just add more
space ...

Also:
 * In this case - to avoid incorrectly detecting the ring
 * as empty - the CPU consuming the ring entries is responsible
 * for either consuming all ring entries until the ring is empty,
 * or synchronizing with some other CPU and causing it to
 * re-test __ptr_ring_empty and/or consume the ring enteries
 * after the synchronization point.

how would you apply this here?


> + */
> +static inline bool __ptr_ring_spare(struct ptr_ring *r, int cnt)
> +{
> +	int size = r->size;
> +	int to_check;
> +
> +	if (unlikely(!size || cnt < 0))
> +		return true;
> +
> +	if (cnt > size)
> +		cnt = 0;
> +
> +	to_check = READ_ONCE(r->consumer_head) - cnt;
> +
> +	if (to_check < 0)
> +		to_check += size;
> +
> +	return !r->queue[to_check];
> +}
> +

I will have to look at how this is used to understand if it's
correct. But I think we need better documentation.


> +static inline bool ptr_ring_spare(struct ptr_ring *r, int cnt)
> +{
> +	bool ret;
> +
> +	spin_lock(&r->consumer_lock);
> +	ret = __ptr_ring_spare(r, cnt);
> +	spin_unlock(&r->consumer_lock);
> +
> +	return ret;


I don't understand why you take the consumer lock here.
If a producer is running it will make the value wrong,
if consumer is running it will just create more space.


> +}
> +
> +static inline bool ptr_ring_spare_irq(struct ptr_ring *r, int cnt)
> +{
> +	bool ret;
> +
> +	spin_lock_irq(&r->consumer_lock);
> +	ret = __ptr_ring_spare(r, cnt);
> +	spin_unlock_irq(&r->consumer_lock);
> +
> +	return ret;
> +}
> +
> +static inline bool ptr_ring_spare_any(struct ptr_ring *r, int cnt)
> +{
> +	unsigned long flags;
> +	bool ret;
> +
> +	spin_lock_irqsave(&r->consumer_lock, flags);
> +	ret = __ptr_ring_spare(r, cnt);
> +	spin_unlock_irqrestore(&r->consumer_lock, flags);
> +
> +	return ret;
> +}
> +
> +static inline bool ptr_ring_spare_bh(struct ptr_ring *r, int cnt)
> +{
> +	bool ret;
> +
> +	spin_lock_bh(&r->consumer_lock);
> +	ret = __ptr_ring_spare(r, cnt);
> +	spin_unlock_bh(&r->consumer_lock);
> +
> +	return ret;
> +}
> +
>  /* Must only be called after __ptr_ring_peek returned !NULL */
>  static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>  {
> -- 
> 2.43.0


