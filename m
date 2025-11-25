Return-Path: <kvm+bounces-64509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BFE2C85A64
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 684424EEB1D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA353271E9;
	Tue, 25 Nov 2025 15:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EqIroag1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gAPBjKNp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9F732142E
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 15:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764082932; cv=none; b=Y0e+HAnoyENZT/naz8tWEeE8bZew08G3TyzFiSo5HZzYCs3Be9OEk7aO+BJ+acqh4FoZ1l3NAgc4E3EwU7IvbJ6W8Coy3T5TRwBSHPbJm2CdlhjKFLsSkT1pIrYNt09whI7VgYHmTn98gbpfomr/1j44r0TbFBaD0Gl1mg3zhxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764082932; c=relaxed/simple;
	bh=MA9QsTVtWgsvfIublM08n8V07qfNyZI6ksmu7VUM+Z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ggtx2Ous7Wew35TfyhVqih8XZ3FrHDCZlq8dO5Z3b2WyKJqSLK2dauvBrX/5medI7IOxXCxemLd929qO/Ae27w1nJe+82Ug11RblLXsi0Zg6I4/qtLG56rLSQyYf/HFHf0hcuuCyCmVlhjyBcIpQVWdbngBVunbXAt3+Qxcd3qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EqIroag1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gAPBjKNp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764082929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=09KqEaOP5fl8HujAjQhdvyXU7ffK0wmWeHz1wD48GE4=;
	b=EqIroag19rralZILbIkUISF84q4xBnzJVdAbjiSRNV6g0JY3eNKSe44cCokVZD62gsmckW
	JqhJ0gqXclSzr2pkdOg1msmFmhAGuRxJF/+/1w6UCP7DSxhyetruwE7DeNKJpQFG942t/X
	/VZPqux2wVPhz714iXYg/WFha3xwvoY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-6wdqkYomPGaI8yay7wCQMg-1; Tue, 25 Nov 2025 10:02:08 -0500
X-MC-Unique: 6wdqkYomPGaI8yay7wCQMg-1
X-Mimecast-MFC-AGG-ID: 6wdqkYomPGaI8yay7wCQMg_1764082927
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477cf25ceccso18013345e9.0
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 07:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764082927; x=1764687727; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=09KqEaOP5fl8HujAjQhdvyXU7ffK0wmWeHz1wD48GE4=;
        b=gAPBjKNpy7ino4c/Qxv2oLhUbYzZTgDZ0kW7PxQrabvya+4dD845YV8f1tfJAzgWkv
         Cf52/Ivd1G9BTa4xk1IWXi7XFOkJanbvGJTOina7KOFGkEsLcpsLmjIWreULwpP/QFhK
         ufpPxJChTNplaztbGcF7pEgrn9FhkUBkkyT1yQBe6ji2DHcBWVsc1Faqqi2bXuk8U8sN
         wwjk2SNfgI218bdr9Y1h9WrqDcqD3OAJmCHeH/s6Wzl2b4A+lhtohEEHvJkDBYyWm3h8
         eBkkXo2Cla7JZpI2VbTdwBVvEwhZFs/E+C6wZE45L6bC4LZDqLZUfXxX3zVfHy1yoVuo
         bFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764082927; x=1764687727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=09KqEaOP5fl8HujAjQhdvyXU7ffK0wmWeHz1wD48GE4=;
        b=Q3DS9QARBglPQRrSxh7XDSnIQ7fItSUA06IN4f/PAy4TFjMc0kggAt14HSifZMtHYL
         l6qApqyYV7nH2B5n/fVyLAge9hktFU9zJ6sSxZPSDaxEiNJ8Tu4ShswoVDDYxq+y5QFt
         vKxr68DHZYt70UcRO2JqVBe+KQF83UpqEold05hfMSU3P+RjpEO9JN46xGbL1SedS+hR
         x0Y5ugFAI/WwstzktwWiOLNGxi5RQg+9Uwu376Oww+GxOf/jfziEAMkuue8s30egg/Ni
         GJAu2gd9l+36G7r5Dyuo9WSOWBQ7YWAI18nUIIRNw3VM4rmLbQERL5l0Ey0uWhju9Em6
         EI8g==
X-Forwarded-Encrypted: i=1; AJvYcCU8yFdCzWvI6gnz1WIFCL9je3t2j6WSauZqDEhm7AK4ptnMBafLq/5gHmTLHkMUYQR+Nrs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFDargM3HWv+hgrIn5A+KfwqAVtoCYES7xzBPhEvWsBNMcm8ia
	yfTRwqG+uQa6iYZcwMnGYNkeZkHlippg/3nfIHRiXoLDuYrzTMZOjxkrpR7CZvFw5oHRa8HayQA
	MaKA3JAYtDRSTaGwj07VaPXEICuDTn/4E7aMLxh7ZELXpcByxL+ZxSQ==
X-Gm-Gg: ASbGnctCZGvkYKjgFnsu1AYi0egAQp6rr92eWZKZpW81irAjD81Lar5FiNIQTQKqpSc
	L6SbTnjrdjMdsLoKiF57CEZAOrd9N3JFZWCw39DvttmeAJSH37eP/ewzAHjyqSL/Sy9HYkUU+K5
	LQB6pfD4D8Yw0UQSpr8/kfOcotVb5V6lDRaHpGBzatbKnxmj4m0DiUqlFA0jol90P2/v4FyZDoZ
	Kr66B787PMFcdYaUK4oGKgFaBWtulCt9Gp3kHu3aylJcMtR+hU5RtLvV4GiEqZPAfsbWCKpGrn2
	ATg8V4DjfWhJYN18ocipadtW9pu7pCzjM6durfmsLKTBy2Q68x5EVaVo6a91n/LHXfAbJUt5Zoo
	MNvIuKmLydqERIAdZu4Yy+DGz4ZE1rA==
X-Received: by 2002:a05:600c:4fce:b0:477:9aeb:6a8f with SMTP id 5b1f17b1804b1-47904ad9438mr24886245e9.9.1764082926360;
        Tue, 25 Nov 2025 07:02:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnxhF4yC89mPigrHkbVw1gVjo8TuRM3hL5MAajbA1OA7AnNYZFSuV4PRGzcMPXZxxaMN4l+A==
X-Received: by 2002:a05:600c:4fce:b0:477:9aeb:6a8f with SMTP id 5b1f17b1804b1-47904ad9438mr24884925e9.9.1764082924414;
        Tue, 25 Nov 2025 07:02:04 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf226bf7sm273353425e9.11.2025.11.25.07.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 07:02:03 -0800 (PST)
Date: Tue, 25 Nov 2025 10:01:58 -0500
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
Message-ID: <20251125095650-mutt-send-email-mst@kernel.org>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <20251120152914.1127975-3-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120152914.1127975-3-simon.schippers@tu-dortmund.de>

On Thu, Nov 20, 2025 at 04:29:07PM +0100, Simon Schippers wrote:
> Add __ptr_ring_consume_created_space() to check whether the previous
> __ptr_ring_consume() call successfully consumed an element and created
> space in the ring buffer. This enables callers to conditionally notify
> producers when space becomes available.
> 
> The function is only valid immediately after a single consume operation
> and should not be used after calling __ptr_ring_consume_batched().
> 
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Co-developed by: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  include/linux/ptr_ring.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index da141cc8b075..76d6840b45a3 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -453,6 +453,23 @@ static inline int ptr_ring_consume_batched_bh(struct ptr_ring *r,
>  	return ret;
>  }
>  
> +/*
> + * Check if the previous consume operation created space

space?

what does this mean?

> + *
> + * Returns true if the last call to __ptr_ring_consume() has created
> + * space in the ring buffer (i.e., an element was consumed).
> + *
> + * Note: This function is only valid immediately after a single call to
> + * __ptr_ring_consume(). If multiple calls to ptr_ring_consume*() have
> + * been made, this check must be performed after each call individually.
> + * Likewise, do not use this function after calling
> + * __ptr_ring_consume_batched().

API-wise, it is a really weird function.  So is 

{
	p = __ptr_ring_consume

	return !!p
}

guaranteed to be equivalent to 

{
	p = __ptr_ring_consume

	return !!__ptr_ring_consume_created_space
}



> + */
> +static inline bool __ptr_ring_consume_created_space(struct ptr_ring *r)
> +{
> +	return r->consumer_tail >= r->consumer_head;
> +}
> +
>  /* Cast to structure type and call a function without discarding from FIFO.
>   * Function must return a value.
>   * Callers must take consumer_lock.
> -- 
> 2.43.0


