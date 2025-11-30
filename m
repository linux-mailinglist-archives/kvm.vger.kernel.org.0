Return-Path: <kvm+bounces-64970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EA36AC9533C
	for <lists+kvm@lfdr.de>; Sun, 30 Nov 2025 19:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A5E924E03AD
	for <lists+kvm@lfdr.de>; Sun, 30 Nov 2025 18:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4802C11C6;
	Sun, 30 Nov 2025 18:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KkkABKgO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089942BEC2C
	for <kvm@vger.kernel.org>; Sun, 30 Nov 2025 18:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764526611; cv=none; b=ahloD+jSv5GfcvV704+ZOP4rEUE66yEHyLnVJuzI2BYGuQfL3fWr5F21KFOZ6/QdD7YnSfT2DZTDOjDF4IeaQqY6QDfehCVENwUAzDSaaL3x9QtQweNMrx4bXNFvZ3jDYbChkVcep2b8iXlp5nH6unyku1ZW2DJq1xd2rElbn/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764526611; c=relaxed/simple;
	bh=KvguCsz4pFutF0DfQ4yn73w4b9PB3j46YC5jFCOIPbI=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=fNNW0W5HqbneIgrWc/AqGXuihQuGIb5fcCleJvolf4NBO/JR+ZIragiXV+Ugno/Pqrsano+2yc2gko8MVoofQXieygKAW6zOOwq4VHbWN5LnLVnCfsogNv8qQN44geE2rZR6xPkv8GB+RtrZ2fH9sV1y+3O9maRXzKltaixAgYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KkkABKgO; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-640daf41b19so4256362d50.0
        for <kvm@vger.kernel.org>; Sun, 30 Nov 2025 10:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764526608; x=1765131408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JyAdI2hiDQd5HiIOsukC026FiEA0dW/JcjYmFaMww+Q=;
        b=KkkABKgO3i88qTaPEM8l4qF0qVQb2Oc83BM9rlYPGe6aEwWoQk123eSP/qOL5VkvoT
         E4dmxtIWk/0xbe+d+bzyYeGwnhpcpHZsoEGPmH5hySMmmJzY2Bgnp7D7BRW5mClEBjOT
         sRLDyOA0f+VmAPmyWKsCLRMXNOvjWG00sZIJHX5/XTu1EfDgvx7CbpXsOsHXUdu83Zaq
         bdwvnjyz9ZW6ZBEg6GC3ThYkdExYlDGb4aqnNL8olod4IdW8CDxGT+0eMdzGBduAvJMN
         1dlUee4gJ7YdZ9jtpFDb/pxtjAaQIO+Z27wL4RZSrsedGsly/OeAqaR0cKNjMQ+qVfL0
         Jw9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764526608; x=1765131408;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JyAdI2hiDQd5HiIOsukC026FiEA0dW/JcjYmFaMww+Q=;
        b=rO7PC2RZ+fSoal50xv3fGJS8WKNgVRfzaKv6aNWsXbLLSF2tpHvkmPMQCSSALIKVrU
         Ik8CaUtx9gejQPugdmuny9hWewngflHaAD2Q0fFvdV1biOi+70BE7DOGN3TcPDjcA9yV
         UojhbqJFZHXG1vjC+qk4D8o7x4xXrxl7LPNOk6bz0sZzH68P0o5/g/AUs/1D3IO5wZSN
         ZN3j0SlE3w15AG1c2PAsjPFi+W+KlsygKsVeefkftUd6EXNzfZmdC9zFRPoyg8G3IMdf
         ei5FGmlBLFPxw+npxhjuHxklTTQeLnYNg+306LDExgw/r8xHptCl+QlMcQ46fT62ilD8
         jBKA==
X-Forwarded-Encrypted: i=1; AJvYcCUM7eR5LeLeiwIh5vBoK0Mui5Kuf4idN0QIWty1bYJX1m87GyGx1GEosQOvxlo6RGe/po8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0gWuOmtV+KgyArM6hJEeaQCwBO86sRLk5C+1oAIM+ylFIk5gs
	FYwHLj4mMlvVZcobF5qsMonwnSwZr1FCN6OOs7BwqRuWAvl1pu9Hmuo8
X-Gm-Gg: ASbGncugNHx3nliyrfePVzlvFTKxyTP+OxabYGbbkWL99zAxHY5qdj9LHImT5yOt1Ov
	shyNU9eekRd9c59P0nOtDfRBavoFvJP9wPekXdGBPTbrALwlosFPJsa9Bwi2pxYCFr49WSlamL4
	H1IjPN7YwTzaYx31wBBNFdgDx1tqBqs9vJA8jNsI/X2l19UefUyu7GCjaTUcx0j/BzpV30S0XOy
	0zy+QBjdx/2CH3bC5eDAdGYpf+C9ZAbkP3nsa9UGWaeHzMbiRiLLjU7JnByCzucDzJOUeKpF4Ap
	bKFuGWV38q1pnf1gjqeG2V4rMY/fKkOGIWfXg4YVRAjNH7EndcnoL4o7aIgCc3qrrnnJIdcKGvn
	XiEHH/AaX5cIwf4Galh6Q2xdH9OJKmiyj1/coYl+siF56779JRs8Pc9+aqi9gT5D/1fcKjTjM6U
	CJBRnuymjaMnYKrDIZG/5gs34NnDpqglK5iuqINLLHuv+lmDrrf8enfjWvOXsAUv5aNQM=
X-Google-Smtp-Source: AGHT+IGjUNSaNMlSY1qlNbQudRZSgfRbmbbf/B0rphetUkGqwnK/CkPwKVh/ASYpHjSaXoMyaE9Zng==
X-Received: by 2002:a05:690e:1489:b0:63f:b1fd:3850 with SMTP id 956f58d0204a3-64302631797mr26472073d50.33.1764526607842;
        Sun, 30 Nov 2025 10:16:47 -0800 (PST)
Received: from gmail.com (116.235.236.35.bc.googleusercontent.com. [35.236.235.116])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-78ad1045723sm39215937b3.55.2025.11.30.10.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 10:16:47 -0800 (PST)
Date: Sun, 30 Nov 2025 13:16:46 -0500
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>, 
 willemdebruijn.kernel@gmail.com, 
 jasowang@redhat.com, 
 andrew+netdev@lunn.ch, 
 davem@davemloft.net, 
 edumazet@google.com, 
 kuba@kernel.org, 
 pabeni@redhat.com, 
 mst@redhat.com, 
 eperezma@redhat.com, 
 jon@nutanix.com, 
 tim.gebauer@tu-dortmund.de, 
 simon.schippers@tu-dortmund.de, 
 netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, 
 virtualization@lists.linux.dev
Message-ID: <willemdebruijn.kernel.2ef79a77ca3ec@gmail.com>
In-Reply-To: <20251120152914.1127975-3-simon.schippers@tu-dortmund.de>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <20251120152914.1127975-3-simon.schippers@tu-dortmund.de>
Subject: Re: [PATCH net-next v6 2/8] ptr_ring: add helper to check if consume
 created space
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
> Add __ptr_ring_consume_created_space() to check whether the previous
> __ptr_ring_consume() call successfully consumed an element and created
> space in the ring buffer. This enables callers to conditionally notify
> producers when space becomes available.
> 
> The function is only valid immediately after a single consume operation
> and should not be used after calling __ptr_ring_consume_batched().

Please explain why it is only valid in that case.
 
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
> + *
> + * Returns true if the last call to __ptr_ring_consume() has created
> + * space in the ring buffer (i.e., an element was consumed).
> + *
> + * Note: This function is only valid immediately after a single call to
> + * __ptr_ring_consume(). If multiple calls to ptr_ring_consume*() have
> + * been made, this check must be performed after each call individually.
> + * Likewise, do not use this function after calling
> + * __ptr_ring_consume_batched().
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
> 



