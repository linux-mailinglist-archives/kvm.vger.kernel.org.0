Return-Path: <kvm+bounces-57705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05367B59303
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03F101BC22F7
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2110E2F83D6;
	Tue, 16 Sep 2025 10:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Xyp0Hq6g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2302F3C13
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 10:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758017452; cv=none; b=r7iLeO4JPwf7vikvFo6EX87NfRda3CfMo/TBiePNE5VnygpzFTX4sn9FURNWBaJszzHpdCdKOwr7Pyo3RniIrLUuwS4kYiJR9dAQ7xriSYGPjrnyo0gD2Pyy2qd5xG+uUXHYHTkXeh5EDFSH6tL5phd/E4+wwIl6V3kINxDEe+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758017452; c=relaxed/simple;
	bh=c1NaLiU5BSXjpyvWvtJ+IA3Hfgdcc1CkUa6L4X6MUFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OmH6vNVYc7Mx/iBJKCkkb5YgV32z8Vn7ZmOksuzGn+o/2EyACaxq8JRksikNuhM/PcXxn1Ed3474QZe1P17vAH/sYEa2x88ddkAfstAgUZlPdCxUKD0oSatip7wO4muzcN8YQ38ETWUASXRinwT0fIUId41uUZIX/KhkQ7KUBR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Xyp0Hq6g; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8117aef2476so532452485a.1
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 03:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1758017449; x=1758622249; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MHR5RzJiQlOpTm5+EwWgakXK9pfUv3hqYa5tSy9/H24=;
        b=Xyp0Hq6g9qwWC1tHXpd8Z4wG1oI5ismmqo7l7mfY1SvcxRIyfejr+iOXRRfUJGDMBf
         xnoCuEGUVmTmqKX1F9LKn/X8P+c+r/uA69TfTckTskfzpl7HVDBAqQFW6mmZWwca6a3u
         uF4UNxX03jEhBWU7WzdXYohAQndqv+OkGE2CO0vowk07IEnBxQHbEqQ4ZH0FNqOlxX2f
         Qb3grK4oRHyPt1e4aWd6PAQ6lQpzVRJHZu1oWVJ6P10UyAoN1+NL+bhmnaGQTg0PHiYs
         v6y9MWJBNSzSqDV2Pu8THnGYZC2fAS8uPIsKvnJLnlL0HVg8S3TxozJMb2Z0JpZxVQ63
         n2Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758017449; x=1758622249;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MHR5RzJiQlOpTm5+EwWgakXK9pfUv3hqYa5tSy9/H24=;
        b=qu6FwsLRGwlP2zI6eUqp/AkgqwnO3kb7BhvUMG6LpvJJJWrOKRuLeivz5yzXoro10K
         hgfP8qDBazTSZiJK94HqlpIL4NbQ474hRzWXKYYU1lPA+yJU0mRx2tXOCIJwh2HSxU9C
         3A+8N4xTevEkJGLcINzTIMLe4TteE8T1pqH1PalFYneBRPadCBYzXZQemJOWzezofeHX
         cpZYearywPeYVVUHoBYUx+3qVvbR/GfXkco58TuoBNazG7qU9cBrnEmUl3VvoMwlqw/1
         oJdS8IbUYneDtyWXbWBwn1Oo920gVT4dB0PFjq6qlpnVuJYlNdpjBdFi3gmVibdO84J5
         V5BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlqWlehJn6mJ6+40DISRCIUqBXFlXqE6UxPEG39IRvcEbaAe/e/X4BdXkvYDqEpl0JkIo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJFCvNA2yp6S+KFBtSAMGwfchMN96/+Xu8I3M11ALiQMJhGsIX
	bTXluc0/JDl+4vdlJj90aCUulK7GObFA2KdALQwYKcA22Y0ITX9Aqha4UDgViYN8s+Y=
X-Gm-Gg: ASbGnctwKXba8Gr2M/XrECS/scjtbWDby9Et0jFJgI4dnUQ1bbpMa9IPHaZYSLmg2VR
	QtFsqvqJBjizVIvOAxaN+6+/2nxe0/tNv6FWiq9t+JVdZSevRDECZCesH1/q3SAX3VorgNeGgiv
	j9fPbPvSrTvLcGVl08iD73Ns0utKjS1NgWkmT5dJ8hfH8qkJwYI/m+0+llAR8IAScR+7z5iPVBy
	MTyCssWkXKcfHzVhojLf2QcUqj9NuL7akeYUoM4MuuBQUEGgsJHlLvt+nf3zesvN5EIubetBqqI
	aZYF6c5C7WiLnMEUcaD+NIbPLyiNq/2J+2TPU75gPeqMXUsYek/YIcfS+e9Rhk4DKKZ26V4+0yK
	neIcciCjriKpEERnrBA6bw9p1Lnu8m/beUs0Ipy6J52djdwYEz7Q1QXxGuX/s2aij932vdwzlEp
	tm38+2DjBVznuK4ifuvb2kWhtMT1AQNd6nrWctY6bL+dQyxPYpv960za7evQ==
X-Google-Smtp-Source: AGHT+IGZ0YonfmrKwetM2Jrdfgt1qWeC6ADbrp2AYjJ1+SgKfeyYvlu0xIDOAMe4zfhpa+l2Hfxf3Q==
X-Received: by 2002:a05:620a:371e:b0:80f:74f2:4a57 with SMTP id af79cd13be357-824030c19c3mr1510309785a.82.1758017449231;
        Tue, 16 Sep 2025 03:10:49 -0700 (PDT)
Received: from ?IPV6:2003:fa:af00:da00:8e63:e663:d61a:1504? (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b639daba5dsm81787221cf.31.2025.09.16.03.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 03:10:48 -0700 (PDT)
Message-ID: <a8c4d415-a23b-46f6-89fc-28facaba0a44@grsecurity.net>
Date: Tue, 16 Sep 2025 12:10:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/eventinj: Use global asm label for nested NMI IP
 address verification
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com
References: <20250915144936.113996-1-chao.gao@intel.com>
 <20250915144936.113996-2-chao.gao@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250915144936.113996-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Am 15.09.25 um 16:49 schrieb Chao Gao:
> Use a global asm label to get the expected IP address for nested NMI
> interception instead of reading a hardcoded offset from the stack.
> 
> the NMI test in eventinj.c verifies that a nested NMI occurs immediately at
> the return address (IP register) in the IRET frame, as IRET opens the
> NMI window. Currently, nested_nmi_iret_isr() reads the return address
> using a magic offset (iret_stack[-3]), which is unclear and may break if
> more values are pushed to the "iret_stack".
> 
> To improve readability, add a global 'ip_after_iret' label for the expected
> return address, push it to the IRET frame, and verify it matches the
> interrupted address in the nested NMI handler.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  x86/eventinj.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index 6fbb2d0f..ec8a5ef1 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -127,12 +127,13 @@ static void nmi_isr(struct ex_regs *r)
>  }
>  
>  unsigned long *iret_stack;
> +extern char ip_after_iret[];
>  
>  static void nested_nmi_iret_isr(struct ex_regs *r)
>  {
>  	printf("Nested NMI isr running rip=%lx\n", r->rip);
>  
> -	if (r->rip == iret_stack[-3])
> +	if (r->rip == (unsigned long)ip_after_iret)

This change basically eliminates the need for the global
'ip_after_iret', it can be local to nmi_iret_isr() now.

>  		test_count++;
>  }
>  
> @@ -156,11 +157,11 @@ asm("do_iret:"
>  	"mov %cs, %ecx \n\t"
>  	"push"W" %"R "cx \n\t"
>  #ifndef __x86_64__
> -	"push"W" $2f \n\t"
> +	"push"W" $ip_after_iret \n\t"
>  
>  	"cmpb $0, no_test_device\n\t"	// see if need to flush
>  #else
> -	"leaq 2f(%rip), %rbx \n\t"
> +	"leaq ip_after_iret(%rip), %rbx \n\t"
>  	"pushq %rbx \n\t"
>  
>  	"mov no_test_device(%rip), %bl \n\t"
> @@ -170,7 +171,9 @@ asm("do_iret:"
>  	"outl %eax, $0xe4 \n\t"		// flush page
>  	"1: \n\t"
>  	"iret"W" \n\t"
> -	"2: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
> +	".global ip_after_iret \n\t"
> +	"ip_after_iret: \n\t"
> +	"xchg %"R "dx, %"R "sp \n\t"	// point to old stack
>  	"ret\n\t"
>     );
>  


