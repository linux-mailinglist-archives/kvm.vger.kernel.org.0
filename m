Return-Path: <kvm+bounces-55621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC925B34491
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:51:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DCCD3BFDC1
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 14:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4662FB983;
	Mon, 25 Aug 2025 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XrjoAd4w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34882222A0
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756133482; cv=none; b=j5sRlUEk5cNB6zped+5/8rKhV3KYoEfCPCY8GRBpCO4lpLvta2bbpQr6z2r8CvzzhSCPwWjkvABNRefV8B7JqMOD75LNd094771aL7rdjLxmyn0i1H+3cRRFggFTrtkHfi2VAtljT5n6N7XwpnMidT5S+UepT7W75JzAA+87/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756133482; c=relaxed/simple;
	bh=oOSJGLCaW8V7KVRsbfS3RhvJdm1vkbZf5LZ3nUtQzq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IXMHYfi+5nXYf4tjbWu5CsmrnkLCAxwgrx+hKz/aBhz+Wf6fu++kIIF6YXZypB1PAEpMOzpFXTOYkWneuithW6UtMzeKWbn7MQzlUsGVa8nnsOY3Gv2WGaQfG4xnpSJ9BtdIDb4ozkNakGdKSlKd6ObNofWwmTZ7Rv56q2Airgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XrjoAd4w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756133479;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4AkxrvBIB2UgDH4sPvjPCIhDWeQ8GQfYbkHQCnf6NMk=;
	b=XrjoAd4wcjXwVzLUX9KHaywQGHTek4gYNISToPR4vrttnX03p//outsBw3OGXZCFsHW8wR
	sDvRv8DWQRlMTbD49akEz4Yik7pVwjDKttbsmrWg552KIxQtyWXB5Rw5npuJUvc9pLTSqi
	urlcGSNVNBxjFpFlkBDS0rxPOuxwvlM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-6_DaC4L6OByXryJphvV34g-1; Mon, 25 Aug 2025 10:51:16 -0400
X-MC-Unique: 6_DaC4L6OByXryJphvV34g-1
X-Mimecast-MFC-AGG-ID: 6_DaC4L6OByXryJphvV34g_1756133475
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so35507765e9.0
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 07:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133475; x=1756738275;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AkxrvBIB2UgDH4sPvjPCIhDWeQ8GQfYbkHQCnf6NMk=;
        b=J34DBZAlxcEOM/Y9b6tvfib/cu1SoeNpENIfYlla0IRMNopbGHKLKt/SjZquZqkmJ7
         aHiQkbePbDxoFJVZBaLNor+IU3A2MPp5YVphB5UHQkH0qT3SyeyQBfG2PRWpqpfECthi
         9M5ZGl1wYjV0giwBWyuoV7WcXRXS03oyg8J2CG/A35CmSb3/LW/ypl2S7UuR1DGw84M8
         NxyZfLhD2jZlvIaEX/M8e7LvJqwBmhUhbu7obMhPLdQ8v6UhTE6EW7N+Q7ikbzShXIzw
         0bSTpj/WfJHHU+g3/26LpIk1vZblhsOJqKcdCsRDj2Ydezdmz1cZEJaRgHPCCgPoeRBO
         zFcg==
X-Forwarded-Encrypted: i=1; AJvYcCXhKbonR3vgZ3kthPSIs9IqHjWES+XLFQVWstYfH3vlCcAx+9LL/cEty5Yf2EWg65asHEE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq0cUkGNIy9aP97wtVtTCMYQwkqDD4ULFxxwv/qI4mIRw4njjy
	oecHCuA7kwAdStHwnhnBjWEsrMAPkDLi5+K1XHzLTty4qtbjI+R20/VyU/Kv6VSYDHiLLd+JGKg
	RZJoO9lK7jxwqkcXHO04CR0U1ZIhLI5gh6o2+LCIXERGCKbk9htdF+Q==
X-Gm-Gg: ASbGncvSpxjtXsXzLARqRTy3onvv5hK91p+weWAr7jibn47YVnQfhRwBKM6kWVQGxOo
	iEnu4gv59/W+Ol3Hoaf2uC83Lqvs+YviuzefGhAkyZQrZNcSKVNI1otWTJX0JqSfkX33dZwcENE
	jI32g0CupYSEd1ps8ZrC1GCK5Y7opRg461NbIkYGVWTdB3mxtItPSVMtNb9YV94f+JXwFcM9Ctd
	qCRvwKWZ8Q95z9m533JjJIKbOqi5ip0hF/SS4zxjoLhjuc0flshzEbTzBzP/4aMOyCnJOfRqjAM
	EoNOGf/86cD88hGxqO0YDQkBtTe7bTbZOj86gGk4r2oiCJoZPSZd/elc6gwb/kJu1ULScIP1yCA
	bOzootgTuF6E=
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr113382545e9.11.1756133475233;
        Mon, 25 Aug 2025 07:51:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHk7BeSjA8U4Bh+P4ANTHgxAKR355HH2hRjmjNFnbu9lssUhx/ve8pHFzx43qF+/snZMSFyNg==
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr113382255e9.11.1756133474831;
        Mon, 25 Aug 2025 07:51:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5f4ef19dsm56584745e9.19.2025.08.25.07.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 07:51:14 -0700 (PDT)
Message-ID: <3cd48f85-ec6f-44b5-a35a-147e950baad6@redhat.com>
Date: Mon, 25 Aug 2025 16:51:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] MAINTAINERS: Add myself as VFIO-platform reviewer
Content-Language: en-US
To: Mostafa Saleh <smostafa@google.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: alex.williamson@redhat.com, clg@redhat.com
References: <20250820203102.2034333-1-smostafa@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250820203102.2034333-1-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mostafa,

On 8/20/25 10:31 PM, Mostafa Saleh wrote:
> Based on discussion:
> https://lore.kernel.org/kvm/20250806170314.3768750-3-alex.williamson@redhat.com/
>
> I will start looking into adding support for modern HW and more
> features to VFIO-platform.
>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index daf520a13bdf..840da132c835 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26463,6 +26463,7 @@ F:	drivers/vfio/pci/pds/
>  
>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
> +R:	Mostafa Saleh <smostafa@google.com>
>  L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/platform/


