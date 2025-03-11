Return-Path: <kvm+bounces-40748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE208A5BA05
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 08:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A735171A34
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 07:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14DA226CF8;
	Tue, 11 Mar 2025 07:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O3yu8ea5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409FD2236FF
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 07:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741678569; cv=none; b=TfMb8+ou7LBYVPr6+redmXgn58Jrm4ovcxfLX1k/SXoByXYWgM3DyqB/9FM3cxarQBFEzL+qe1ZWxAPDlvKsREuY+88gtaASnkU+v6J8rAfHQzG/mPKfHtkrH7F08cOps3ysTV4rIv3bpGSH3iB5rU1a1u8lye44llkHEcWbPJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741678569; c=relaxed/simple;
	bh=4chk0QrrepO/Cat9v97wiBz05ZXvI+azg+G5vbiTGEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZSNTt5m0BEpL/xvHAdjJ0vFXxn6XSR4XA6jvsLhLB+dhtUKaT6oN4LUfzHbUQ6kYfakuapMJgRyztRvOKZ6Ix+Y/GiaQZRH+byAOG78Vbe35HyUZ1/sdumm0m5Im+00r1J7yxluncDFrfysOmNFVdlrJQ5vBsXEOopLy/SfBcCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O3yu8ea5; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-390e3b3d3f4so2403754f8f.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 00:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741678564; x=1742283364; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YBDtd+wGYXepiPCUvcu8NxohmXbd41Si0c1Rztrtm0M=;
        b=O3yu8ea54x3lGbDd+aJdeHQSclFxvPYN3c6m+BN/WNlno69LKllMg65Vby+4mg7GqZ
         sPGxRnySp2QmO18TW9Wc+PpNLxMOCGWszh88ZmmsGeu1jxPsrKvT34HRtHvhjqmpwxvi
         6KC7m1ym2zB+Mm1JB98M7mrbPEnJKZLdMm/M1AyycWKXRdsbHyxjE3Gq8vwNPV+2U9Ee
         KlH8un3lnjGpX6W848qr7nIN2QgYS0Kgpf6Tg+za4isGb/dBRYWcVfJLUJR2DWoUeFd4
         v5jDlLaAh6x2/yi4peuwliT1sMQ1I8V+cLvTCmSEsqMJFYeVfbm7rB/QLjJsOqbGBkuR
         +EpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741678564; x=1742283364;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YBDtd+wGYXepiPCUvcu8NxohmXbd41Si0c1Rztrtm0M=;
        b=n2SnvG0qN1EuGbF+SigazPQY+CYHTAmSET5lqR2j+tvXjvjZzUsaK2NLGASjMeBIu3
         brWRqi7HNYA3Oc6QyJmO4ajTd3TJdIovjCDUsL+KmNsAX+jRbqksQPWNY6RcUO0eoCpL
         n08xbBpS2OMZm3suDQ/zbEH3+C55kbXRJOTmQnbVYQO5/jVm2ME9Iwra8OpCwJpS/UfD
         Xfop03hpc0nIwCI2MFRsGv1odzzFP5EBei1r+jRqf0aRGf474tLmopMSyxQ43AN1/WmN
         XQt9bodoRNGEp1P8GnUbulSCzaITpX3SnuvM24zjsPfOWm6N03P3L9RPSM4ZXKmKpDKS
         +KWw==
X-Forwarded-Encrypted: i=1; AJvYcCXrjthmpC8zpGO9Yf0MK0GIhPVnPDoi+iRn+UsJUQmw98+cdP3whsQPbr4b8w/GB7RBXPM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7RnB53TYbPPqDl6FSCGiVeGAapU3C3/0DkPt+GwkvI1MRofwQ
	IgrbNPwuhaOU/fO673ycYUc2w3Dx5AepGCPveZJXTGr7V27UKKYIyqt+gmc2N/M=
X-Gm-Gg: ASbGncsHJMpQYmNXHDaPXLj98w/spsiycGlDcOz1OZusoRWyn7h3noxFbsIjK6R4iL7
	HS4PVOet6tkw1N+v889g9XlcnxD7F0ZmexuAjkc66WSXQIKQsThNN8SGIYeOxpJdg18SMrYejh9
	729/vwV1F+YVq+QgXel9on00yv0QhqsG/MstitiQVlmppIgFjBZ1QMf+6x/6EN1glepI9wJEfqZ
	t0/Nc8AO+Fx/Z+QIV8KIPqhHtMGRR7UwLYOI3LWyYUKOe+fRBnYWBI/X7I9ISFHQ1VH4WrdmltW
	NhHLTkIZf85EzoDGC+F1Xh200WmYrtvCGaFcmunkWYB2v3y9uIKXYWFk4PKulsbZqLR8vYSrvaz
	0RwshOptmFXLTYHO6ITk6tHk=
X-Google-Smtp-Source: AGHT+IFSPGz9/gfwsiFYEmt/RzI+9DcM9u3J2MgkQs5at33CHQLyaRLSm47Zlzsudug5b+arJ/EAbg==
X-Received: by 2002:a05:6000:188b:b0:391:496b:5646 with SMTP id ffacd0b85a97d-391496b5792mr6565392f8f.28.1741678564530;
        Tue, 11 Mar 2025 00:36:04 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cee67ae5esm91023745e9.33.2025.03.11.00.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 00:36:03 -0700 (PDT)
Message-ID: <b8073e25-ae8a-462b-b085-84c471a4bf5e@linaro.org>
Date: Tue, 11 Mar 2025 08:36:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/16] include/exec/memory: extract devend_big_endian
 from devend_memop
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 xen-devel@lists.xenproject.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 qemu-riscv@nongnu.org, manos.pitsidianakis@linaro.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Anthony PERARD <anthony@xenproject.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
 <20250311040838.3937136-15-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250311040838.3937136-15-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/25 05:08, Pierrick Bouvier wrote:
> we'll use it in system/memory.c.

Having part of the commit description separated in its subject is a
bit annoying. But then I'm probably using 20-years too old tools in
my patch workflow.

Only used in system/{memory,physmem}.c, worth move to a local
system/memory-internal.h header? Or even simpler, move
include/exec/memory-internal.h -> exec/memory-internal.h first.

> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/memory.h | 18 ++++++++++++------
>   1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 60c0fb6ccd4..57661283684 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -3138,16 +3138,22 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
>   MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
>                                 uint8_t c, hwaddr len, MemTxAttrs attrs);
>   
> -/* enum device_endian to MemOp.  */
> -static inline MemOp devend_memop(enum device_endian end)
> +/* returns true if end is big endian. */
> +static inline bool devend_big_endian(enum device_endian end)
>   {
>       QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
>                         DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
>   
> -    bool big_endian = (end == DEVICE_NATIVE_ENDIAN
> -                       ? target_words_bigendian()
> -                       : end == DEVICE_BIG_ENDIAN);
> -    return big_endian ? MO_BE : MO_LE;
> +    if (end == DEVICE_NATIVE_ENDIAN) {
> +        return target_words_bigendian();
> +    }
> +    return end == DEVICE_BIG_ENDIAN;
> +}
> +
> +/* enum device_endian to MemOp.  */
> +static inline MemOp devend_memop(enum device_endian end)
> +{
> +    return devend_big_endian(end) ? MO_BE : MO_LE;
>   }
>   
>   /*


