Return-Path: <kvm+bounces-9844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 565EF867349
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10581283865
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39422557F;
	Mon, 26 Feb 2024 11:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fD8m1rPj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF1E21A0D
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 11:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708947361; cv=none; b=bD3kH5c/W+alxukXt09h1LuS/ei0rAGMLuQAug7E8P31+JtMdJBK7OFgSmUInonlymjdVTH8K+BHccZ/hDdT1+q68PKKUAnqtWQGmBEh9BFem5MnQlNSSUh6a5jRITjto7LOiVmevnPbNG3xVQ42/qroLhqneXwL6y26NCJPc5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708947361; c=relaxed/simple;
	bh=2jPsxnp8+FNTIYq4ljBTKZjIpt/TCWslTM/XvwhVmg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kmVIaEGSQBhjzMnpkhzcNJwj3tk6xWTxGMEoYlMoIusumSjYozGWc8zXPyR+GL+lzw4YdHs3yyU0shdL2GwduGYi8GzjG7kJXyjxi/X/R++hE7YgGhHLKqLur1ZU6pCaOXv1f55SlS8x+VpOD1jY4kSA/DkJTkJHZp8nmeTI3ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fD8m1rPj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708947358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nLV9mtpVkZr3zVwNful7hoIpZ+cz6YUR/Wsl1FJnKmc=;
	b=fD8m1rPjUvY0tbONzcZBqAM8BASWnu55Ve3m7upz+fwQKkHrWlPSAr6jk/NPLHPq3zKLgZ
	DnKWhbwz8dkGJPVW2W6zM+aeRWH4olVoT2C+B6T0dkfsr9vUX0ykKjfuxKeEmy2edIbRDg
	kXuoELLfTscepfIT5hd+38KD6wXEKn8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-FrLr-2LeOaOUoMqPn6RFGQ-1; Mon, 26 Feb 2024 06:35:57 -0500
X-MC-Unique: FrLr-2LeOaOUoMqPn6RFGQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6901234f078so3927446d6.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 03:35:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708947356; x=1709552156;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nLV9mtpVkZr3zVwNful7hoIpZ+cz6YUR/Wsl1FJnKmc=;
        b=NyVnmYQF1VF8oACeuY3mBUko7m/xtnyPsHLusJT2PSHkqCuiFozt24E2fNuUg8WICV
         YGbOOMatQkt1ljbv7v2Jpdiw38JBCptutcvcM5SpeZdLpafOYhg97DhnePsa261V+vTI
         QthmFy4djYrpt0QAkRex4oyA7e/MZX5JG4dAriquM+oxBXKWalKfbEQPQaPYBBiqDhk+
         rIddOWdNG0179mcf1FmB7ZZZd67g1oN/jNB7LBQC3mJ7Uhy3h9lA8AyUD52HKe7r3DA6
         UO7O1xLZrk+0Jgsh0HJtprXqQv2KYXS1ZxUEzO0efYn7D9TW3s4b5bjjAkdgEIsHA34o
         oF/g==
X-Forwarded-Encrypted: i=1; AJvYcCXLNcnB/r3TlDIlaDn19PSIi2PUVUwT+YlQQavFyE3T8WynlCT/1H7CO+vQJAM7oIhyyCaE95Qfp7beOjGj0ipgtN4J
X-Gm-Message-State: AOJu0YyxbLWkpd0BKr4Lfma+aOXXfp26+0lgQsJN2g2kwboZfvw+/hbM
	bsFwQEHtgrcJKTFT+Hm2qzkFCENcuE48mnpMbQwCD3g41JdzQDYgtEnXqwkOPl/NcOTjWMJLY81
	VD7tsidssRU2lvQpB+aelsclFsPbyezBQ2G7f7+qWUJt04NqVJA==
X-Received: by 2002:a0c:f2ca:0:b0:68f:ab60:785d with SMTP id c10-20020a0cf2ca000000b0068fab60785dmr6480374qvm.11.1708947356785;
        Mon, 26 Feb 2024 03:35:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFjuwtmpBRlPkgdcmp7lRxEx7lALjlGE01hfMLKCdUwKk5bHL1lesfeK5TI+OaaKLBbJR0jlQ==
X-Received: by 2002:a0c:f2ca:0:b0:68f:ab60:785d with SMTP id c10-20020a0cf2ca000000b0068fab60785dmr6480363qvm.11.1708947356524;
        Mon, 26 Feb 2024 03:35:56 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-176-215.web.vodafone.de. [109.43.176.215])
        by smtp.gmail.com with ESMTPSA id f30-20020a0caa9e000000b0068fc83bb48fsm2817441qvb.105.2024.02.26.03.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 03:35:56 -0800 (PST)
Message-ID: <269ec33f-e2ad-4f55-b3e8-52ce88f966c5@redhat.com>
Date: Mon, 26 Feb 2024 12:35:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 02/32] powerpc: Fix pseries getchar return
 value
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-3-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240226101218.1472843-3-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/02/2024 11.11, Nicholas Piggin wrote:
> getchar() didn't get the shift value correct and never returned the
> first character. This never really mattered since it was only ever
> used for press-a-key-to-continue prompts. but it tripped me up when
> debugging a QEMU console output problem.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/hcall.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/powerpc/hcall.c b/lib/powerpc/hcall.c
> index 711cb1b0f..b4d39ac65 100644
> --- a/lib/powerpc/hcall.c
> +++ b/lib/powerpc/hcall.c
> @@ -43,5 +43,5 @@ int __getchar(void)
>   	asm volatile (" sc 1 "  : "+r"(r3), "+r"(r4), "=r"(r5)
>   				: "r"(r3),  "r"(r4));
>   
> -	return r3 == H_SUCCESS && r4 > 0 ? r5 >> 48 : -1;
> +	return r3 == H_SUCCESS && r4 > 0 ? r5 >> 56 : -1;
>   }

Reviewed-by: Thomas Huth <thuth@redhat.com>


