Return-Path: <kvm+bounces-41238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E14A65683
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7778D189BB13
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 15:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4C6165EFC;
	Mon, 17 Mar 2025 15:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vtgghO7W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141BC2904
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 15:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742226539; cv=none; b=BpQzYI/Ri02sPDfxBFTKev6nHRjZFUu3yox6ub/sORZHAFnGu+cbHZZTf1kBWRxrrwZ5EripXT4qPlccDYGIeI0k8n/NAJiR8QJ/TPEAD/DB7TUUpYzbPMf6nKP08NdskW/ZqIDuKe7M7ojIDIlYMztonz+FDlbSeNcwlExRY20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742226539; c=relaxed/simple;
	bh=Uw+4TerDIA3UCbjHcfpZdt7dVoQcitzy3oh5bXzXT50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7DNOOOXvWZ/hh1J7wSwrmWEuqxWAr0n/L9RfE9cw7GjR9Um2ey2/XKBhMnAD6dJxQamvJwSTBTEGwJNi6/uLkG5FcYZzLdwdsQKtqO6f9sm2TlkziCUPz/oFyTluDGwC+QITCEW2VWKf+nuRydMzKmkuYB+EcXKTdX4gUF95rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vtgghO7W; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-390fdaf2897so4322680f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742226535; x=1742831335; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o+5W+UssECkTKS4DrzEwRnjDFNiMZjlh6x8JkFvP4I8=;
        b=vtgghO7WPKbUZdjP7G8AS62ASGHwsMGObJUwXFZOLl2IsbqyU9C1fhuJj4+qe2wz4y
         WVaQyPaFOVThxqjl3a6KpTBnfJ8U5vDIV2RJEENNy3z13Nr6NpNcNvG4SAAf70peJJ5S
         0CWGVWhA3tXUHNdg5lEd3iC3DSqgJ+YRbWOaH6tKHemQTwJpAV9ZPhT2NgzruNcOqhTI
         PmSNDJRLj1YGiUMT6yREMyCjqcBToyIRDgUwr2CQMFsjWq+IwIYQ+RaNkXE+0D0A0fes
         iOJ1U9z8RsCe8JFSGj1AmSLN5zOZakfWn7/WRjOjYNYHhJ2tOPKjYsOcuylS/b2l5yZ3
         viAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742226535; x=1742831335;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o+5W+UssECkTKS4DrzEwRnjDFNiMZjlh6x8JkFvP4I8=;
        b=pqQHGeZZ1tV+ulhHb8sdn4oDbaFOGfY0gWBLPYEfdPF+0G6l1IyukGCjWzo550usG4
         GO6c22+5H6uglnK6Lj6sfQ6jnk1HGwaCP/AVNzUacwNbXsy4nhVWhFr0gLQmOMG70u5P
         3Jbpe5W/CvKm59QV99sH2Cx3SM4OXFP7iitI9ha+G6ibWy0AUdG213S+5lWsWH4AD+Qt
         iISt5AjJT3ryDsvYygdgz2+uT4VdY8DWYoDnX5hZHwQ5rUqpJP6SDJS/ml+djCxJKVyi
         oaYQDQtzdojtzQuUa9GR+v7Lp/KLLtR/AOVF13gyECFXhk/Fq7CpMk7Yxkq4fLknrCse
         IwoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrhZIGjO7tmxuXaddw9dA4gX9zY/AOVlHDl+WTy+wHm38fbQyKBvBNBxJ5pa9Bq3kFocY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnEYVUtLfFKsShg4X0uFrD9HE+oh9GYsBTip4+ketUP+rwzqde
	eM+ueNd2N4egHIiNIcyDNwzICtiK2laUxQZjDdzIi84lp2K13SB5AbpTj7rI/NU=
X-Gm-Gg: ASbGncvh+oI56GEyiCc0bEmIhlTntXL8DcRq6PVacNhb0nYR3C/2JyeAzalXOrOw8pn
	I2l5AzqBpaTo8VgSpfqDk1S5UaaNqu4c1F4/2QPAHnaIGWBKfJ+l+1klmvcDPkGBeSAeUtaTfsZ
	N0dYCsKRPj9tKZU2ZdJ1FL3urcuAOFTM6lFsWtTmGcxBmD9U+6VQRj5jAfIG7RBLo79SO3FRc8i
	/+6z3H2ktpjdUAsQu7sXzkoQrcLAAW8phpZNZR/k82ZXn7teoKiP/5qAcwviwi6PwII1NYThKrP
	3sJkiYwbYmiW5JIANSgxUmxMDASZmDCiuhr7/+X2hyDHHFOyVRi5hv8Tb4P0oHSg9sY5jtI/g31
	WXBt7s88rCg==
X-Google-Smtp-Source: AGHT+IGPYq8a1DX+sutBQTGjwo1ZKdFnw90ZowytYQDXuqZKLeSdwoGehqSW8lE4c/1Od7xg7Lk9Jg==
X-Received: by 2002:a5d:5f4b:0:b0:391:212:459a with SMTP id ffacd0b85a97d-3971e781d76mr12793882f8f.22.1742226534980;
        Mon, 17 Mar 2025 08:48:54 -0700 (PDT)
Received: from [192.168.1.74] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb40cdafsm15448541f8f.62.2025.03.17.08.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 08:48:54 -0700 (PDT)
Message-ID: <d5e2aa98-5b9c-4521-927f-86585b7b2cfa@linaro.org>
Date: Mon, 17 Mar 2025 16:48:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/17] exec/memory.h: make devend_memop "target
 defines" agnostic
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Paul Durrant <paul@xen.org>, Peter Xu <peterx@redhat.com>,
 alex.bennee@linaro.org, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-riscv@nongnu.org,
 manos.pitsidianakis@linaro.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Anthony PERARD <anthony@xenproject.org>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Weiwei Li <liwei1518@gmail.com>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
 <20250314173139.2122904-6-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250314173139.2122904-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/3/25 18:31, Pierrick Bouvier wrote:
> Will allow to make system/memory.c common later.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/memory.h | 16 ++++------------
>   1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index da21e9150b5..069021ac3ff 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -3138,25 +3138,17 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
>   MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
>                                 uint8_t c, hwaddr len, MemTxAttrs attrs);
>   
> -#ifdef COMPILING_PER_TARGET
>   /* enum device_endian to MemOp.  */
>   static inline MemOp devend_memop(enum device_endian end)
>   {
>       QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
>                         DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
>   
> -#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
> -    /* Swap if non-host endianness or native (target) endianness */
> -    return (end == DEVICE_HOST_ENDIAN) ? 0 : MO_BSWAP;
> -#else
> -    const int non_host_endianness =
> -        DEVICE_LITTLE_ENDIAN ^ DEVICE_BIG_ENDIAN ^ DEVICE_HOST_ENDIAN;
> -
> -    /* In this case, native (target) endianness needs no swap.  */
> -    return (end == non_host_endianness) ? MO_BSWAP : 0;
> -#endif
> +    bool big_endian = (end == DEVICE_NATIVE_ENDIAN
> +                       ? target_words_bigendian()
> +                       : end == DEVICE_BIG_ENDIAN);

Unnecessary parenthesis?

> +    return big_endian ? MO_BE : MO_LE;
>   }
> -#endif /* COMPILING_PER_TARGET */
>   
>   /*
>    * Inhibit technologies that require discarding of pages in RAM blocks, e.g.,


