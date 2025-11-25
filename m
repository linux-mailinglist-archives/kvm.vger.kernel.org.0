Return-Path: <kvm+bounces-64522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5185C862ED
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:19:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A26D3B5D00
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E05632ABCF;
	Tue, 25 Nov 2025 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LQQy0ZMY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="esSiQknh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ED932AAAC
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764091146; cv=none; b=OzPCY4XCeyso9ossrb4lwuV25kyN3FJ+TEYy+B0K2HkgZIpRHH6SfI59m0Z/M8d4BTnfgwLhR8HDLMVpEESnKZr1NuH3GgSj/+qehPtayif+2melxg1evGrVW6n/MzWswxhd+0dOz/LP9aCof5+vcsyXh7elYgBDOxuOibIb1tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764091146; c=relaxed/simple;
	bh=ZPhuaik0VAApbpX38pTQnqYDsCZCeVuWDwCiA5Naac0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUsDgVKV1R1vygK3eb5Nj0AeEP0+NZ2SiBE0AtgjN6eRlwCa6ratidnT1eNO/3ehBz1aAFhc/46jpWxSPG86NuZPx06DGTwESqwILNEy6uesoYgJO2s865cMHT0l5YAszYGYrkYgxTRW0NpIm2KPZpSbdr7F/eeefEIFSvcTgxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LQQy0ZMY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=esSiQknh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764091142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QTDXgrG1WH/0PGWngFbUewy7r2hDyrl7ob2LIaTylyw=;
	b=LQQy0ZMYHvT/ZbenPjcmtU9iJHml6lPCz7u4cJlXPG942lNf4kRAf8eQmUswFYVhgToWii
	YolQWKLppjQJMcTRpF/fqtt32nMkqZAajIPrE8ozG7ahrtdQkhqa7N+KkvXI64asSgrDCh
	U9uXsqlwAIG6a0mq9eZs3N3a479Wm60=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-5K8gNOZSMJK79kuBFPTCLQ-1; Tue, 25 Nov 2025 12:18:59 -0500
X-MC-Unique: 5K8gNOZSMJK79kuBFPTCLQ-1
X-Mimecast-MFC-AGG-ID: 5K8gNOZSMJK79kuBFPTCLQ_1764091137
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-429ca3e7245so2839168f8f.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 09:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764091135; x=1764695935; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QTDXgrG1WH/0PGWngFbUewy7r2hDyrl7ob2LIaTylyw=;
        b=esSiQknhwwgSIxH9h576nP+e3IdyPqKvNk6TgDZ3TruRZLZAnBpjaedxhfIEn2EJRU
         ykeM4nzQQMjsPI+Uwb2Hb3gwJ+lLOfl67oXdL4sIhag4xwJiqBr/4XA+7zCeGUH7Lq4w
         utYileQ9cYRnvOsksG5PcTIi2EAIrRI8OE0xTYTWNGNFcyq+tuLD7eX4rg47qboDNEEz
         DA8ca9igTMgz0gyfDukrHjz/w8HU+pUugX10d+MqScE6JeFyz5BJbC1Vdkw2QPzP1ddc
         LzoiVS9JoVrFqgz4CVW6wM4PhwJo90uA09sW4RooldqP2vjzFce8Pdf3Gq0cyqdT8huh
         qdMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764091135; x=1764695935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTDXgrG1WH/0PGWngFbUewy7r2hDyrl7ob2LIaTylyw=;
        b=YbuwsunqG4I/WklWhkVyPsxgGOL9bY2sDZu1jdlUweC8SFTvVNONaW0sazreVFsnYe
         JhdA1GKkGwPGtkWCKCvtTaxyomhxDos4UwtNqNrZcO+B6jNM9Aumm0VPfvusnoFrmvY1
         rga6sL+5TXxQUP8P84XLFnppPUKnv4Evc0hxTUP7SPkCUi0swv2a+JNHUijGoFJbjCKN
         r/dhaG0nLnehCXbmV+qMWiRQUBEDdlBegi2hLcVta7JO/QtV819riVKrmawuC1WqV9QN
         F+5pzAUE0vHtxCXbHL4SPShZHqo5VH1RZBheDKb378zh+Ps9HLq0r663zICDhyCUxoOk
         DQQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpqnBaUEnNJ4wHxE78yYxXMAca9PUFW4hGS50fJXxZ1Ckb1BR3zlurkM394bHy4upsjN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAKR7X2n0TPC8aXEQhMHO4jZbheaddAAFgqu/3EnMLnoOTbVMA
	AsIPcr0l1qxmsyUSIb6otf9M9vtEa/BOFIVmhuKMcDC0WOvhHGYpjUQvZ9O0Ga6WnJGK98o28xO
	EkBUONbqNuPbColfDYW2DJRHNVRa2DjLZlxekwuAvt60T0NkJdnUDyg==
X-Gm-Gg: ASbGncvPaz0jkpD0UvnDpa9rXLaYpTnAL6NbT5ujM3mh4V/BWjlN7S5uHseckaWdWem
	UUtJ/IWrP8vPsHNoWIZbH0XFpXgoUlVcJ/5xGXo/qGadU8UZ03P/7luQuL1H/DJLe+WBOH26JN+
	128Fx4HaKjPrxczo7u295fJEsZsc5kCB9gzN20rhkxqmDbQzMvPfzv9DuxVj74yZa2GYV6yKXff
	DCUSCjsBbMmUBT6ZbnMsCAAkaSZQFEJbyeYUH0OBKyjtEPnFbw6dw/SibWhh8kmgZIxKbY+1ABC
	nRvtaHoo+fM0V3NDq1SpgKrMUg9kVZl9hDAFKLIwPScHAa9Lfq0H5OdjY6lJlGFRiYrE2TB374X
	N41zllyYpciJhNpY=
X-Received: by 2002:a05:6000:1863:b0:42b:4267:83c2 with SMTP id ffacd0b85a97d-42cc1cbd18dmr16972095f8f.16.1764091135224;
        Tue, 25 Nov 2025 09:18:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGDwBcpmQPbHfHTQwxxY5Q+qsOpgYiD3CvZ3WNNO7Ii75RTIrUMAIH9/jzA1J2eiQuQn7dHrw==
X-Received: by 2002:a05:6000:1863:b0:42b:4267:83c2 with SMTP id ffacd0b85a97d-42cc1cbd18dmr16972058f8f.16.1764091134693;
        Tue, 25 Nov 2025 09:18:54 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3592sm34039004f8f.21.2025.11.25.09.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 09:18:54 -0800 (PST)
Date: Tue, 25 Nov 2025 12:18:51 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	jon@nutanix.com, tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v6 2/8] ptr_ring: add helper to check if consume
 created space
Message-ID: <20251125120122-mutt-send-email-mst@kernel.org>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <20251120152914.1127975-3-simon.schippers@tu-dortmund.de>
 <20251125095650-mutt-send-email-mst@kernel.org>
 <ce371d19-e69a-4d8e-a9a0-f3e20439a094@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce371d19-e69a-4d8e-a9a0-f3e20439a094@tu-dortmund.de>

On Tue, Nov 25, 2025 at 05:12:35PM +0100, Simon Schippers wrote:
> On 11/25/25 16:01, Michael S. Tsirkin wrote:
> > On Thu, Nov 20, 2025 at 04:29:07PM +0100, Simon Schippers wrote:
> >> Add __ptr_ring_consume_created_space() to check whether the previous
> >> __ptr_ring_consume() call successfully consumed an element and created
> >> space in the ring buffer. This enables callers to conditionally notify
> >> producers when space becomes available.
> >>
> >> The function is only valid immediately after a single consume operation
> >> and should not be used after calling __ptr_ring_consume_batched().
> >>
> >> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Co-developed by: Jon Kohler <jon@nutanix.com>
> >> Signed-off-by: Jon Kohler <jon@nutanix.com>
> >> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >> ---
> >>  include/linux/ptr_ring.h | 17 +++++++++++++++++
> >>  1 file changed, 17 insertions(+)
> >>
> >> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> >> index da141cc8b075..76d6840b45a3 100644
> >> --- a/include/linux/ptr_ring.h
> >> +++ b/include/linux/ptr_ring.h
> >> @@ -453,6 +453,23 @@ static inline int ptr_ring_consume_batched_bh(struct ptr_ring *r,
> >>  	return ret;
> >>  }
> >>  
> >> +/*
> >> + * Check if the previous consume operation created space
> > 
> > space?
> > 
> > what does this mean?
> > 
> >> + *
> >> + * Returns true if the last call to __ptr_ring_consume() has created
> >> + * space in the ring buffer (i.e., an element was consumed).
> >> + *
> >> + * Note: This function is only valid immediately after a single call to
> >> + * __ptr_ring_consume(). If multiple calls to ptr_ring_consume*() have
> >> + * been made, this check must be performed after each call individually.
> >> + * Likewise, do not use this function after calling
> >> + * __ptr_ring_consume_batched().
> > 
> > API-wise, it is a really weird function.  So is 
> > 
> > {
> > 	p = __ptr_ring_consume
> > 
> > 	return !!p
> > }
> > 
> > guaranteed to be equivalent to 
> > 
> > {
> > 	p = __ptr_ring_consume
> > 
> > 	return !!__ptr_ring_consume_created_space
> > }
> 
> I am a bit confused. You were the one recommending this function to me,
> see [1].
> 
> Maybe the comments need rework here, but the function should be fine.
> 
> Thanks
> 
> [1] Link: https://lore.kernel.org/netdev/20250922221553.47802-1-simon.schippers@tu-dortmund.de/T/#mb722e8ae4ceb5df24f74305c6145561883d4e987


I see, (an element was consumed) part confused, instead of clarifying.
That is not the question - it was consumed.



Let me try:

Returns true if the last call to __ptr_ring_consume() has created
space in the ring buffer (i.e., a new element can be produced).


Note: Because of batching, a successful call to __ptr_ring_consume
does not guarantee that the next call to __ptr_ring_produce
will succeed.

Note2: This function is only valid immediately after a single call to
__ptr_ring_consume(). If multiple calls to ptr_ring_consume*() have
been made, and you want to know whether any of them created space,
it is not enough to call this after the last __ptr_ring_consume -
instead, this check must be performed after each call individually.
Likewise, do not use this function after calling
__ptr_ring_consume_batched().




> > 
> > 
> > 
> >> + */
> >> +static inline bool __ptr_ring_consume_created_space(struct ptr_ring *r)
> >> +{
> >> +	return r->consumer_tail >= r->consumer_head;
> >> +}
> >> +
> >>  /* Cast to structure type and call a function without discarding from FIFO.
> >>   * Function must return a value.
> >>   * Callers must take consumer_lock.
> >> -- 
> >> 2.43.0
> > 


