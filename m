Return-Path: <kvm+bounces-67540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B675D07D8D
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A676E3064AAF
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9A6346772;
	Fri,  9 Jan 2026 08:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CZ/QHQtD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kBwOuAmw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C232E346782
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767947529; cv=none; b=ffyDlJALXDgZa6vswWeknkX11mElJYcslzJwyp+h3ZRT1hyJB0MIKiMKrYv6s1euF3dWQ48f2RRFQ5s+UBHYcD6GvgY1W8zBVD764BewL+mFo9CxBzp6Q61iBaVcqLcq/bfcTJS12hnRIx3nsMTN1cs5Yqvb9BEL6vIzfiGZTns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767947529; c=relaxed/simple;
	bh=TA0YXI5tFPQHixouJ2j1bQdmu7BczvrlyG+W06NZVPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AmIbKc+Zwm/+YNKjbsvNIMQQv1QuMcj5MbyaAMZxAUrrcGMhBZo9UIRMDclhYdUtJSL/RiL4tyudB3CbL6lYbJteKja2TVm0HtAxNpqg77V9/SCcYrlgE67LIfGHpNNIIU+9xIgjc84Kk8ktQrBomOcMrSl+u5doi1r4bKN1wEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CZ/QHQtD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kBwOuAmw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767947526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V1ke4ac4E32fG4lShAnBll4if/X5IbvvKQ7SqmHrrYc=;
	b=CZ/QHQtDlQmDFGnCwUkQ9ZQP0CSi7NywZ6SV9uZgu/9gYlLGnUZ0Hr5noSKNZ0oDaaPN1e
	TLtlAdpOHCJU/J46M6i0McxuE1sy0XSN6VFtfaXpK9ScjwfV7oX2p7YUSuRXjA2cA+Xc0y
	z0JuBeWZoZ38kol64MyzD13J5aNVP0Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-endOJuGMMZKpXzVu02yM0w-1; Fri, 09 Jan 2026 03:32:04 -0500
X-MC-Unique: endOJuGMMZKpXzVu02yM0w-1
X-Mimecast-MFC-AGG-ID: endOJuGMMZKpXzVu02yM0w_1767947523
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47d3ba3a49cso34909715e9.2
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 00:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767947523; x=1768552323; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V1ke4ac4E32fG4lShAnBll4if/X5IbvvKQ7SqmHrrYc=;
        b=kBwOuAmwqnVyelsO2aq9N9g399P6GY9KD9+0VUtzygLegwd4gRl1EQssPy+YdQ744w
         rA3vuBgunfaktozfUv6egM1bRkK8RmIOruesAN6oLaUV58TTDXDw+MkV5SldNbvtfzFz
         KXdmejtGwOiGfScKDRQX5Tnf1zI7mX7VOGR9voxb9+4p0WlwDxmSYQXSRzjruFn1kJef
         R5CE84qprdTcLInfIr023BxK/YCYkxicOuz1BbPI8x0n8S+lRc7jF7p/IKMmpiQ15GsR
         nRTkxPNPsZ3aZMm8sCvtUGnWsCngqR3/uZmln83VQ5aIt0wUpBN+QY9APRN8jbvvsfZo
         bSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767947523; x=1768552323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1ke4ac4E32fG4lShAnBll4if/X5IbvvKQ7SqmHrrYc=;
        b=nC/JsLnQXSsolmyu5Hq59KTOmbHby0glwAxgR7cM4IiV7dhjeM+Qn63ahJS31oyzu6
         ENpGmap/yLQuc3Xo4wB561jze2LdtpMe5TjaiYDJyifU6eyBOzGpsdGe4UZLscJl9G47
         Bvdmm/iZUMRAa4+g6PXdp36wpN/f8J49MeOjSnNHbvJzIVDnvfNfgtt/DIbAw5nLMD9V
         qYddQ5/0AYXZv0vWbstHJJZ3R9t894lMORP7TFMgQ+kVPODWZPmtT4V+35qksoaH78n6
         s4XhVLuJk2d9IryuDqU5RWLZopHzGAuke0L0/jHON6REvZvlePCPa5fUFbo9LFFUSCqz
         ZvUg==
X-Forwarded-Encrypted: i=1; AJvYcCWwKQSh8AV5Q1W2csyssOU93A0SE94mzihaopSSMfMUqyjyrafJN+7d+1Z4c4p9EAyoUdU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn6ahJ98n0xYiNlecjQULGWeqGLM+Glx0ri9cw2tHJkd9KN+GC
	HYO0/5YlEXlhptNAQuW4rKCMy7OoeYgGO1HuTVgRt7EgXw+wGDYtOJ2/bgJwoi43pgm71yFMJUX
	aX28nd8I7SCdPNu+WVvnmTD2rwct8OFKnYrAx512hLSfp0820akwhJg==
X-Gm-Gg: AY/fxX4OzHm5Xq0HQZ+ByrZccuCVgjp1NrK5Hj/sRlMfCw+/0XfluuA5KT/j8001WaG
	yzQQFHqBVvIawsdd2piX/BnArGNOHBm0VFV2FkaL3y2oZ59MWDPvi1G4Ji3imeovFXRVY23rYA9
	6Jg8VPc6CO7l37DZbGGCAc9elW+feU6tD3pETH4PF5yzoMAganWu2aG1QAPZKThSQsp2otx1mAL
	kfVt8/C1C+TIXWFQ3mTaDOqd2Ftp402rNGzPuQMl1dNO1vgarxiqLij5rY1hLYdLc0PKyHJqK2L
	1O30kHaztP7HfWmmUSQvj+GLDz9gGfMXQcIE/gb54bZolvwSjh60wuZ3U3vXxcNTbpJFmbHDNBN
	lq+WZ7JZCGeEecqMNFxaJTIpdEHvM3vZVjA==
X-Received: by 2002:a05:600c:6306:b0:471:131f:85b7 with SMTP id 5b1f17b1804b1-47d84b1a03fmr89448105e9.15.1767947523221;
        Fri, 09 Jan 2026 00:32:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6UfdcL14TZ2jcr19i9LHxmaSNAQniiujlbEAgU47kWYFzOBfa9T43hpeYeByL2mFARRYigA==
X-Received: by 2002:a05:600c:6306:b0:471:131f:85b7 with SMTP id 5b1f17b1804b1-47d84b1a03fmr89447825e9.15.1767947522743;
        Fri, 09 Jan 2026 00:32:02 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f68f69dsm196961275e9.1.2026.01.09.00.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 00:32:02 -0800 (PST)
Date: Fri, 9 Jan 2026 03:31:59 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
	tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v7 2/9] ptr_ring: add helper to detect newly
 freed space on consume
Message-ID: <20260109033028-mutt-send-email-mst@kernel.org>
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-3-simon.schippers@tu-dortmund.de>
 <20260109021023-mutt-send-email-mst@kernel.org>
 <a0d5d875-9a9c-4bfe-8943-c7b28185c083@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0d5d875-9a9c-4bfe-8943-c7b28185c083@tu-dortmund.de>

On Fri, Jan 09, 2026 at 08:35:31AM +0100, Simon Schippers wrote:
> On 1/9/26 08:22, Michael S. Tsirkin wrote:
> > On Wed, Jan 07, 2026 at 10:04:41PM +0100, Simon Schippers wrote:
> >> This proposed function checks whether __ptr_ring_zero_tail() was invoked
> >> within the last n calls to __ptr_ring_consume(), which indicates that new
> >> free space was created. Since __ptr_ring_zero_tail() moves the tail to
> >> the head - and no other function modifies either the head or the tail,
> >> aside from the wrap-around case described below - detecting such a
> >> movement is sufficient to detect the invocation of
> >> __ptr_ring_zero_tail().
> >>
> >> The implementation detects this movement by checking whether the tail is
> >> at most n positions behind the head. If this condition holds, the shift
> >> of the tail to its current position must have occurred within the last n
> >> calls to __ptr_ring_consume(), indicating that __ptr_ring_zero_tail() was
> >> invoked and that new free space was created.
> >>
> >> This logic also correctly handles the wrap-around case in which
> >> __ptr_ring_zero_tail() is invoked and the head and the tail are reset
> >> to 0. Since this reset likewise moves the tail to the head, the same
> >> detection logic applies.
> >>
> >> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >> ---
> >>  include/linux/ptr_ring.h | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> >> index a5a3fa4916d3..7cdae6d1d400 100644
> >> --- a/include/linux/ptr_ring.h
> >> +++ b/include/linux/ptr_ring.h
> >> @@ -438,6 +438,19 @@ static inline int ptr_ring_consume_batched_bh(struct ptr_ring *r,
> >>  	return ret;
> >>  }
> >>  
> >> +/* Returns true if the consume of the last n elements has created space
> >> + * in the ring buffer (i.e., a new element can be produced).
> >> + *
> >> + * Note: Because of batching, a successful call to __ptr_ring_consume() /
> >> + * __ptr_ring_consume_batched() does not guarantee that the next call to
> >> + * __ptr_ring_produce() will succeed.
> > 
> > 
> > I think the issue is it does not say what is the actual guarantee.
> > 
> > Another issue is that the "Note" really should be more prominent,
> > it really is part of explaining what the functions does.
> > 
> > Hmm. Maybe we should tell it how many entries have been consumed and
> > get back an indication of how much space this created?
> > 
> > fundamentally
> > 	 n - (r->consumer_head - r->consumer_tail)?
> 
> No, that is wrong from my POV.
> 
> It always creates the same amount of space which is the batch size or
> multiple batch sizes (or something less in the wrap-around case). That is
> of course only if __ptr_ring_zero_tail() was executed at least once,
> else it creates zero space.

exactly, and caller does not know, and now he wants to know so
we add an API for him to find out?

I feel the fact it's a binary (batch or 0) is an implementation
detail better hidden from user.



> > 
> > 
> > does the below sound good maybe?
> > 
> > /* Returns the amound of space (number of new elements that can be
> >  * produced) that calls to ptr_ring_consume created.
> >  *
> >  * Getting n entries from calls to ptr_ring_consume() /
> >  * ptr_ring_consume_batched() does *not* guarantee that the next n calls to
> >  * ptr_ring_produce() will succeed.
> >  *
> >  * Use this function after consuming n entries to get a hint about
> >  * how much space was actually created.
> > 
> > 
> > 
> > 
> > 
> >> + */
> >> +static inline bool __ptr_ring_consume_created_space(struct ptr_ring *r,
> >> +						    int n)
> >> +{
> >> +	return r->consumer_head - r->consumer_tail < n;
> >> +}
> >> +
> >>  /* Cast to structure type and call a function without discarding from FIFO.
> >>   * Function must return a value.
> >>   * Callers must take consumer_lock.
> >> -- 
> >> 2.43.0
> > 


