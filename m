Return-Path: <kvm+bounces-10034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E158D868B37
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:50:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 582151F2258E
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 08:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5CD5130AFA;
	Tue, 27 Feb 2024 08:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XZ4C7lpK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BC8130AC0
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 08:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709023831; cv=none; b=IOd6NhMvO2q9gBelTRTwC5x5h+XutRC/yxaiKUiIfwr+iQ3g1X0WLEdc1AFgE8T3IxazLB7pIyjdvViqbmy4+i/9zs8/e6y9pggwNUnx2bEKLoni+D3yImdb9YfRQOh54r9/SoRKKCyo4PI9Nd2n7MSnp5EdqXBvRHpwEcDlPrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709023831; c=relaxed/simple;
	bh=ardLcgLIak0b/zJ+0vG+Ou6kMXBcykLp7l6C+/XT23w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mKDNp3RXGLVPyFevCjyJJRSq0ilKe8uqzw655J8EaddU80eGBvUZD4xEb1CF6Huka0hfOfCg/2TPROwp+OjoIoeKsfBmbVuK86XMu862sRSCTWASt05igdSyWAaE6dHQ1+4DPi5YR5ysnJCaZoALmgFAv4NJuU1jVkJgKJOSmPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XZ4C7lpK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709023828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fjwgf70eagfSqlkzj5EjwJ1uAR0zRc9Pw4NBDTDE8ZQ=;
	b=XZ4C7lpKck7okvWQpu691KytsH6wxwaSl9Fo/jdV+5+R30va2HfhZ1+87R0pLvoR07PJrd
	PYNHzuXhTZPmp3rcyj+kaNx7EJcVo3TWT+pRFV5+D3IsOMkrnhOnb49f0YB2MUlj+XDdhO
	33uwn73GuGA4tg0b5TMtCD6+NbeZ/h8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-N_Ib3ZScOC2kKk8lzIppfQ-1; Tue, 27 Feb 2024 03:50:24 -0500
X-MC-Unique: N_Ib3ZScOC2kKk8lzIppfQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a26f2da3c7bso267821366b.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 00:50:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709023823; x=1709628623;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjwgf70eagfSqlkzj5EjwJ1uAR0zRc9Pw4NBDTDE8ZQ=;
        b=IYvA6L6JJARQK4lU9zFWp2QsfCjWLNWp153RbMweJIW9Rrn9xi+/EjmL/4tg4hNfT5
         auhoGKCXI1i0eYxXy/EeNS4M5/u55v9Qm0cu9XlL/oazQpx5Ql4eeOTr4AW9BZ4M9f8+
         P/dmDOdP1PRMJk4XPQTNkrfn9WS6JvAZ96edCzVqpV8RsUPAZQ2EPlu9Cw7mjfVxvaTt
         mc39RpZv/32f4WUnnfzif0zQcSs7udoYR3Fq66fO0yLDdjp2pHSH+a45By28/+FiWetv
         hCsDI4YL4sNeA+/LxX64FojN9wYaNn66ngDPWzNg/jUIAvtMhk9HFS3PBZKIHpSBsU2x
         BX+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVPAMmh9A4UOBCE9UutvgbaoM+NPz2EwoRDEV9NKVmmYBaiCULdIFHQQrFCSgi3g6eW9zIJzYTBGZQzNZwA0Z6GIGfG
X-Gm-Message-State: AOJu0YwPOvzW3PR/yoLzvlHpGk+qhtp4MS3LHNV5V7YEMOisfXMDFXgm
	pudwOXqK3w0f/vvulOohB/K52cZtaGmkbuIFHPR90umJvDHYMQjfdN5iGrGmCqR4/fUurw55LcX
	AbVCIdB1YgBsICr/QZO9u5zvqngNkop/I4lCsFMr/SY5qiKtLkjnLT1joVA==
X-Received: by 2002:a05:6402:2059:b0:565:5de9:719b with SMTP id bc25-20020a056402205900b005655de9719bmr6626163edb.25.1709023823610;
        Tue, 27 Feb 2024 00:50:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvj/J7mrOUBP8NhuM/T98wRnes1Y0UfzNTWIgfMUAKK8NC1z6G/mukde1G9/WdcUrvxyg8eA==
X-Received: by 2002:a05:6402:2059:b0:565:5de9:719b with SMTP id bc25-20020a056402205900b005655de9719bmr6626152edb.25.1709023823318;
        Tue, 27 Feb 2024 00:50:23 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id n5-20020a056402434500b005644221a3desm549368edc.3.2024.02.27.00.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 00:50:22 -0800 (PST)
Message-ID: <94491aab-b252-4590-b2a7-7a581297606f@redhat.com>
Date: Tue, 27 Feb 2024 09:50:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 03/32] powerpc: Fix stack backtrace
 termination
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-4-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240226101218.1472843-4-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/02/2024 11.11, Nicholas Piggin wrote:
> The backtrace handler terminates when it sees a NULL caller address,
> but the powerpc stack setup does not keep such a NULL caller frame
> at the start of the stack.
> 
> This happens to work on pseries because the memory at 0 is mapped and
> it contains 0 at the location of the return address pointer if it
> were a stack frame. But this is fragile, and does not work with powernv
> where address 0 contains firmware instructions.
> 
> Use the existing dummy frame on stack as the NULL caller, and create a
> new frame on stack for the entry code.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/cstart64.S | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)

Thanks for tackling this! ... however, not doing powerpc work since years 
anymore, I have some ignorant questions below...

> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> index e18ae9a22..14ab0c6c8 100644
> --- a/powerpc/cstart64.S
> +++ b/powerpc/cstart64.S
> @@ -46,8 +46,16 @@ start:
>   	add	r1, r1, r31
>   	add	r2, r2, r31
>   
> +	/* Zero backpointers in initial stack frame so backtrace() stops */
> +	li	r0,0
> +	std	r0,0(r1)

0(r1) is the back chain pointer ...

> +	std	r0,16(r1)

... but what is 16(r1) ? I suppose that should be the "LR save word" ? But 
isn't that at 8(r1) instead?? (not sure whether I'm looking at the right ELF 
abi spec right now...)

Anyway, a comment in the source would be helpful here.

> +
> +	/* Create entry frame */
> +	stdu	r1,-INT_FRAME_SIZE(r1)

Since we already create an initial frame via stackptr from powerpc/flat.lds, 
do we really need to create this additional one here? Or does the one from 
flat.lds have to be completely empty, i.e. also no DTB pointer in it?

>   	/* save DTB pointer */
> -	std	r3, 56(r1)
> +	SAVE_GPR(3,r1)

Isn't SAVE_GPR rather meant for the interrupt frame, not for the normal C 
calling convention frames?

Sorry for asking dumb questions ... I still have a hard time understanding 
the changes here... :-/

>   	/*
>   	 * Call relocate. relocate is C code, but careful to not use
> @@ -101,7 +109,7 @@ start:
>   	stw	r4, 0(r3)
>   
>   	/* complete setup */
> -1:	ld	r3, 56(r1)
> +1:	REST_GPR(3, r1)
>   	bl	setup
>   
>   	/* run the test */

  Thomas


