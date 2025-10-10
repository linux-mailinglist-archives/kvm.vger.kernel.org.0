Return-Path: <kvm+bounces-59759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2428DBCBC0F
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 08:04:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DB0124E3E50
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 06:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B0E23A995;
	Fri, 10 Oct 2025 06:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="kICVF1zl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF0C23CB
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 06:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760076246; cv=none; b=uvJSJPg8WSg8Di4atliqb3CWSQPnxHzRlVTG4/kSle41a4xdNm6navl3UGhITymD42P5p1JFFAmW71Gzx/dbxQ2YErlWZL/hYrxUD02TXWNGoBEYHl29qjPdRrhPEMTFQucTrRuTsFn8HY6B4tnhW+K8WLq8vmlYGpvDC69OQLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760076246; c=relaxed/simple;
	bh=Knw0Xm5x7sagdbZ2CjV09CXcu6GCzFXbWHzdPW7//lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QrqC4TpqO2anhSzBg0HXfhcnSOgxZJ+a/a2n3BOcq70FzIf++m1cja1bwaxf6KpPiOSy0cXzlbZrySzOaGXE1thQbQZobLzi4mYTFnkIIU/PrD47OaZuQvxWLKKikG8I4w+eQtUTS+bRaKouQNXPWdEGIg6QfBMZs1iDw/zWM30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=kICVF1zl; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4060b4b1200so415769f8f.3
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 23:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1760076241; x=1760681041; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0r1NWqbZEzbO/7uoD9Io08Y9S0vOpUmxWufTX689ooo=;
        b=kICVF1zlSmTdI3NEdpXC9OA/IOTxh9+ADBgVdrfYB70mLTq9OkOPmyXIdPbZukAzZN
         0A/bAn0nVUYGqyqm7XUiZd7+J7lKKwfq8Du2s1rrx8wAoLjxj/C9tfhLQX0NVuUNoHEM
         PsffxKVDIaAKfvKcC26XhqfK5fDnw5Yv3X3kw1Y/ZaH0HYTqhfJmpcrkwqPpv0N07sGw
         +WzKAa4JKBmUTo0TfWgo1d3URevYsAoFxVog3ghcuaQ43gNvfdDQ0wbPQe/B9v9WSLqM
         bWsEfNRAOurBILuPrMhbTFxVVM303kVbmvEtJnoeNoK6CRsu7GLyGqMwvZ8NkcfDy37i
         8Lkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760076241; x=1760681041;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0r1NWqbZEzbO/7uoD9Io08Y9S0vOpUmxWufTX689ooo=;
        b=cd+ES+N/SmjWkFOkuIpFRQQSYbHoH6VIbfK1ELRbTVrmS83kYu2vSyfzvTfSKI7tXL
         BpTYu0WBF47vn/8SXmYLC+jAQr67hqNfxjda48b2i8FoH/PvqvwlxV3u/GLN1gu/lQje
         90CUR1Rj0ArqKSlyKqFSLHvLgcv2E1m8F1rJ/LGy0jsJtgH18qX9uP/i7YO5yValsoc0
         Gmgdus1qn/xz+pcY61l8ajIX4e+gD1zhZcakahlKL7ZPhkrn2y3XHskEkP7E9BiTidjb
         vptuXw6Pq4D0/R8Qi7vyihRXJb4Mp80Ldz1mvLYgTJcrSxl6FC/ygjR+I0ZC6D5nqPFy
         +vCA==
X-Forwarded-Encrypted: i=1; AJvYcCXEY+MbqcObQJlcX3ohBwAioYWYUoNODIcLypdp2HKZgDDTSJEVAPbhA1m//LSpGliFKDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCy+7FGk/W4gao/a7JNBiJ1uzV2dJfpX8NdBWOhcV+VKrNGRPQ
	1bVlNcLYh/ywhb6rDCeZ/smob1W8Qm7HH2J4wtDjyTr+ALBk+GQRXneHTDcW8pnokfI=
X-Gm-Gg: ASbGncs5124LJAtR0aLt9jC09eNR/Jasx2hcdjq8XQr4gKETliV9rXIK6ROpOLBoaca
	V/hrHMrAGnsBEDtdfdQaERqj1898AxInaSgE/R6cZks1AGZAnKj/izm8Wzyvj1GKYIxpWD+o8Qe
	Ji0iLlBYKRDC80VTOMd8Vva1D11JYI4HxojQGyEDXPcSkh9v9LcKYz6Ujh6vFBOZ8jjZc3u4l27
	WGU+DZQ8DOzUQbzwAfo9zKUbuPE8lUigo8rSwtsIMWu4VYZN5FjmgoZ/MzcI40LbJcig4jrsCaZ
	Tj1CKQFOpKdDbO90jvWc+wYqA57GiTS+ByTRIqmst2gUzAuZ7ck+P3kdHF+aNFzh66Hz2E5EqRC
	XAAAvfoeeolYWALmCPP4JBbfIkqpOmmbZJTlGurYMmqulYipnIC2Z29rvqWnhE0o4NfxfntBb69
	U9NVYqtMipYkHkqSz+KzPcVhiAlvgWD6a5o5IHTnnraBSJEXy7weB74ToZydcypqXCvuunqzff5
	GdBUDdn/hwiap0=
X-Google-Smtp-Source: AGHT+IGdlF1jJjO4YieAmsTi+1sflzPmBHkkN/w6hIawqy3/GnHDDQIxkQU107FHhfo85ITKsyPITg==
X-Received: by 2002:a05:6000:18a6:b0:40f:5eb7:f234 with SMTP id ffacd0b85a97d-4266e7cea15mr6381158f8f.5.1760076240292;
        Thu, 09 Oct 2025 23:04:00 -0700 (PDT)
Received: from ?IPV6:2003:fa:af00:da00:8e63:e663:d61a:1504? (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e8309sm2387739f8f.50.2025.10.09.23.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 23:03:59 -0700 (PDT)
Message-ID: <47d87ba2-83c1-4a0d-ba8a-cc7adc2b105c@grsecurity.net>
Date: Fri, 10 Oct 2025 08:03:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/4] x86: Better backtraces for leaf
 functions
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Thomas Huth <thuth@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <20250915215432.362444-3-minipli@grsecurity.net>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250915215432.362444-3-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/15/25 23:54, Mathias Krause wrote:
> Leaf functions are problematic for backtraces as they lack the frame
> pointer setup epilogue. If such a function causes a fault, the original
> caller won't be part of the backtrace. That's problematic if, for
> example, memcpy() is failing because it got passed a bad pointer. The
> generated backtrace will look like this, providing no clue what the
> issue may be:
> 
> 	STACK: @401b31 4001ad
>   0x0000000000401b31: memcpy at lib/string.c:136 (discriminator 3)
>         	for (i = 0; i < n; ++i)
>       > 		a[i] = b[i];
> 
>   0x00000000004001ac: gdt32_end at x86/cstart64.S:127
>         	lea __environ(%rip), %rdx
>       > 	call main
>         	mov %eax, %edi
> 
> By abusing profiling, we can force the compiler to emit a frame pointer
> setup epilogue even for leaf functions, making the above backtrace
> change like this:
> 
> 	STACK: @401c21 400512 4001ad
>   0x0000000000401c21: memcpy at lib/string.c:136 (discriminator 3)
>         	for (i = 0; i < n; ++i)
>       > 		a[i] = b[i];
> 
>   0x0000000000400511: main at x86/hypercall.c:91 (discriminator 24)
> 
>       > 	memcpy((void *)~0xbadc0de, (void *)0xdeadbeef, 42);
> 
>   0x00000000004001ac: gdt32_end at x86/cstart64.S:127
>         	lea __environ(%rip), %rdx
>       > 	call main
>         	mov %eax, %edi
> 
> Above backtrace includes the failing memcpy() call, making it much
> easier to spot the bug.
> 
> Enable "fake profiling" if supported by the compiler to get better
> backtraces. The runtime overhead should be negligible for the gained
> debugability as the profiling call is actually a NOP.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
> One may argure that the "ifneq ($(KEEP_FRAME_POINTER),) ... endif"
> wrapping isn't needed, and that's true. However, it simplifies toggling
> that variable, if there'll ever be a need for it.
> 
>  x86/Makefile.common | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 5663a65d3df4..be18a77a779e 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -43,6 +43,17 @@ COMMON_CFLAGS += -O1
>  # stack.o relies on frame pointers.
>  KEEP_FRAME_POINTER := y
>  
> +ifneq ($(KEEP_FRAME_POINTER),)
> +# Fake profiling to force the compiler to emit a frame pointer setup also in
> +# leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
> +#
> +# Note:
> +# We need to defer the cc-option test until -fno-pic or -no-pie have been
> +# added to CFLAGS as -mnop-mcount needs it. The lazy evaluation of CFLAGS
> +# during compilation makes this do "The Right Thing."
> +LATE_CFLAGS += $(call cc-option, -pg -mnop-mcount, "")
> +endif
> +
>  FLATLIBS = lib/libcflat.a
>  
>  ifeq ($(CONFIG_EFI),y)

Paolo, can you please comment on this one, so the fixes for ARM and
AArch64 are no longer blocked and, ideally, this series can be merged?

Thanks,
Mathias

