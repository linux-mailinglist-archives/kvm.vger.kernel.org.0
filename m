Return-Path: <kvm+bounces-64507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB7C2C8595D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFBA73B3F2B
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 14:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A28732720E;
	Tue, 25 Nov 2025 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHioTsMB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cfcFu2mT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A423271ED
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764082475; cv=none; b=jRglwNmSHSb31wfc4P1JBWjGiUQlVrNxLfyTiwKuFp2wR7L62rJtuACPaccsQ3Ju8XzrxVFB1WGa8Lq3qBmrhOUWhoamGqeMzey8fN1282cjLEGRsAf2R2UTZwS++yspfdQJL8r7df4JhM8foXrM2VHjZsMibB7hPBJZ3Z7Qtx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764082475; c=relaxed/simple;
	bh=8xC7HaADQYW3D+KtCunFe74uUCqkHpl2Q0DkBJIPChA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J9D4y3jLyZFyRljZWbDdgKBlxD04lJrOnfqDlNfSIz8UwfQQ+st64b94ujLi4AzE4h2kh2/OUSIXTNDREPo0/Aipk29ITOwhGGvPXqKvQ1LEH8JBRDl21xkKj7fmJn3ideflKH9cB2GU9hxHZiJEN/2q8okBEgkFYjEmzL/1SKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PHioTsMB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cfcFu2mT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764082472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vUrStbCWzacPZeRn/CeAW92WYQYkVd+P3AlUH3cXvno=;
	b=PHioTsMBbNlpMlR+CPJ7BTh5VCry/K/TzhYKwdPiKJKzuGAU1Xz4N3C6pATV6E3wvHGYRa
	o9HPyPCMUPelKD+au+OPQOqpNwiVRVP9cwcb/PX56gZpVytily0KadEF5RbG3TU87SdMiO
	Ch+M12ojVPdEURkpJVxLZKcPvKeAvss=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-r86qbf3HNB-yBB9ZkMnZZA-1; Tue, 25 Nov 2025 09:54:30 -0500
X-MC-Unique: r86qbf3HNB-yBB9ZkMnZZA-1
X-Mimecast-MFC-AGG-ID: r86qbf3HNB-yBB9ZkMnZZA_1764082470
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b3086a055so4849572f8f.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764082469; x=1764687269; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vUrStbCWzacPZeRn/CeAW92WYQYkVd+P3AlUH3cXvno=;
        b=cfcFu2mT/kKAEmorPEqCPxak8/pldhwbINDn/xrL4io3ji1L4N4klw8sgrqUATvU1f
         HNN2w2V2bh9KiKb/yJj3csEINNzl+zAvXZF7vTPLzkmzVGygrT6biiEbATDCfXDSsRU3
         qqz0wtqaSQoasNM+ScGRDNjv/jUB3Y9Ax8NhlSXiuo9eqIgwqkjrc+wGj+Tfkgf/bz4b
         h7pRuAi+/cJE44PPQQNaBvDFOayQURYMhD2v9gR4vck0gj9yG7H+P6DJwuuF415S4n/S
         yMbWSDwaDkK2xid8MWiFlSdlV8rbLrYOnK7cDKzFg53BcdYiB2Vt113w4wIEJ7WxzSF7
         +jMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764082469; x=1764687269;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vUrStbCWzacPZeRn/CeAW92WYQYkVd+P3AlUH3cXvno=;
        b=wIsQlNDSP/h06tuENzCJFeI+jYQfuYx+6CzQ5rBFSIbWEUkjQrmj3CTS9Ttpl2/DVw
         F+08oRgAyZQHwsuP1UoKsvvZVIAxWXqVDHRz5i48kUiUEeiVNidUJBc985Gmi6EdcCPl
         ntURv3dr+UZUn+yftispfVlSfQi9w5ZjiYyAN2Qb9HiKcO9uZBR07AdBvNtFVDQBoIVt
         hRSTLYorJN07JcPy1FuaqXqOtatbXinJr6cbXO9eEXAeG/mJShJvyM0Qfun84v719lfO
         r/8oxNpJcYdFKWTy1+FJTMQf08oaFBOM0myp4iVVteAnHz7Ks+X81F7G98Do0WTBYpax
         yj6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU4ooKdBArwVRhYvPRWVXw/VS6v93cn1jn7ds9VE1ZTb9vJMsgSqhMC21wEy3Kg3sq1DZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8SL3zH4CP1vFWRXDzTHpYvY+mv8dF6yUwKQMB6h3Epr6fb3R0
	tP8oIUX45BMctZBqhpe91JLVKVS6IWhnBW5rNHkuVIjnISw1JH8GGG/0ErGy9oGnjnafnaYaUSc
	Q07MRMRJ1PL7KZHQwZ3jayG2m9pFSdYCzz2Mw4Tl+FYSqKrki0d4DVQ==
X-Gm-Gg: ASbGncsMGI/1mE32C5/KUGgcRT7F7w7z350GM7p3RysmJ3HDI+FZZcpavNOOaQPnyb/
	o+qu76ir2eSAVif+tZxL3ChBv0RzpTQBGIRkC2rFJeZFOCwsEj5nskWbZF8b24tFyONj4mZGqzG
	uCMGTGwUa/8ZRaR9uG2Y8uIw5B5Em6Pj6MI5ZsJsfm1VGwb1rjxRtPfdyamj8Gr68otnxrTnsk+
	eZAk7sfr4pj5E9SHoHMFi2q+9hwqGQd1F0Rn9Pe9xX7da4wwqTKs+U8jcpdTuV2qDY3XWrFZK+u
	vC+UmZ/fpw8bMzOQjiN3xr5O/0z86VQKEuLL4Ete08y+HKK5XXFVsSk52aZ7l8zrpspMylh591t
	PksBL5Ai/YOG/rwY=
X-Received: by 2002:a05:6000:1841:b0:429:b525:6df5 with SMTP id ffacd0b85a97d-42e0f1fc3f8mr3305587f8f.3.1764082469380;
        Tue, 25 Nov 2025 06:54:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7rvJRNZU8Dcdx4PHJxDxhuM/oczmqfkFeajyK44cHiOkIrlaShhTGgJMJROx6QVQcGeq/5w==
X-Received: by 2002:a05:6000:1841:b0:429:b525:6df5 with SMTP id ffacd0b85a97d-42e0f1fc3f8mr3305550f8f.3.1764082468871;
        Tue, 25 Nov 2025 06:54:28 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f3635bsm35190453f8f.17.2025.11.25.06.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 06:54:28 -0800 (PST)
Date: Tue, 25 Nov 2025 09:54:25 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	jon@nutanix.com, tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v6 1/8] ptr_ring: add __ptr_ring_full_next() to
 predict imminent fullness
Message-ID: <20251125092904-mutt-send-email-mst@kernel.org>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <20251120152914.1127975-2-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120152914.1127975-2-simon.schippers@tu-dortmund.de>

On Thu, Nov 20, 2025 at 04:29:06PM +0100, Simon Schippers wrote:
> Introduce the __ptr_ring_full_next() helper, which lets callers check
> if the ptr_ring will become full after the next insertion. This is useful
> for proactively managing capacity before the ring is actually full.
> Callers must ensure the ring is not already full before using this
> helper. This is because __ptr_ring_discard_one() may zero entries in
> reverse order, the slot after the current producer position may be
> cleared before the current one. This must be considered when using this
> check.
> 
> Note: This function is especially relevant when paired with the memory
> ordering guarantees of __ptr_ring_produce() (smp_wmb()), allowing for
> safe producer/consumer coordination.
> 
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Co-developed-by: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  include/linux/ptr_ring.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index 534531807d95..da141cc8b075 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -96,6 +96,31 @@ static inline bool ptr_ring_full_bh(struct ptr_ring *r)
>  	return ret;
>  }
>  
> +/*
> + * Checks if the ptr_ring will become full after the next insertion.

Is this for the producer or the consumer? A better name would
reflect that.

> + *
> + * Note: Callers must ensure that the ptr_ring is not full before calling
> + * this function,

how?

> as __ptr_ring_discard_one invalidates entries in
> + * reverse order. Because the next entry (rather than the current one)
> + * may be zeroed after an insertion, failing to account for this can
> + * cause false negatives when checking whether the ring will become full
> + * on the next insertion.

this part confuses more than it clarifies.

> + */
> +static inline bool __ptr_ring_full_next(struct ptr_ring *r)
> +{
> +	int p;
> +
> +	if (unlikely(r->size <= 1))
> +		return true;
> +
> +	p = r->producer + 1;
> +
> +	if (unlikely(p >= r->size))
> +		p = 0;
> +
> +	return r->queue[p];
> +}
> +
>  /* Note: callers invoking this in a loop must use a compiler barrier,
>   * for example cpu_relax(). Callers must hold producer_lock.
>   * Callers are responsible for making sure pointer that is being queued
> -- 
> 2.43.0


