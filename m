Return-Path: <kvm+bounces-41245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 993B9A657EA
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81143179D5F
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF58819D8A2;
	Mon, 17 Mar 2025 16:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ShZPyNqr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD4516F8F5
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742228630; cv=none; b=Czfs21srUwgH2Q320g9Du2e43FN+kCm/g8bhSi4J9OaBjWpt2i1WgsI6S3auTJPN9x/sSPAo9fS3FHxZwmp9IRF3eEb/NaBOWGR/L9Lpxs8uK6cBUhtfAJguPu7NV49AS520xwDtCZ/r56MypMGfGrHF99cb5XKZDBK5+aIyk8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742228630; c=relaxed/simple;
	bh=m6vFdRioa4CBmeBIm8XkhpWztB3JJhDBiHXopcBmf4o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VRATMEYlGAZzFLmOXemROUA8F1bMLl8YPav1gAB+JUv3JTVRlqhGodMXgCk9xS/lLCxbS/yR1IC/G2AwhfBeMB/Kru9CN9mIJFskcnk8tCGsmZ5SI0kvuqQAKRrn7qxATViSjwxi3yKed4jge/tWdfftu27gSQHDVFkXbyhSKsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ShZPyNqr; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-390e3b3d3f4so2764697f8f.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742228627; x=1742833427; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=avfzUeOggfHVdiAQhDfUOVX9Fi+u2OCZ2GM9j7NAP70=;
        b=ShZPyNqr/h8VsGh09yCfWFG0CDrZZW2e2338QLVMyzqkeU0Y7ggQld9YZuHWCHf43A
         sfsJvZlBAF1kBfRccNuX2gWzl9Ngglz2lNMbAAEyfL1vAmoA3srbIcsdDvud3Z+kMZeT
         4pu/uRYYddAjqkXfJJ/dYz9qmNWdMtF5siPZlWuLpUIHGIMJ5iYNsMf51xoMnPoITmbN
         83lVmruWvIYDc/E0j6cJNZSrnChLy9NWZ/H39Agt53lziuhkm3a0O/hvECDTJZRIOoV0
         QAojcpqt0XmHyQZ/5sXCou/Ha0Q5kZ5LW8eUmu2ixPtRcyWMdHYD7CSF03xD3SgWFr/d
         uqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742228627; x=1742833427;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avfzUeOggfHVdiAQhDfUOVX9Fi+u2OCZ2GM9j7NAP70=;
        b=RtIHI7fwYLfgl+97faW6a57+eyJDWhDG7aZIBZCPeN1Wr/t2Ahef4b7hwS90yCRxok
         dz0R52qB8xtUfw9zJyrAFS+TSI8mqIXI4DYTGDupUMb5fG3SWOKFgpgKkhQO71CdzB8X
         75mUaVURgBJ+6USM4cYboKwizZsGgpt17S5sS8B0K2X4Qp85/MBR/y96R9+aNAcxMwWO
         2LsjfYLxY6MujPLWneSKQimzsqTrxbmOkzQP1ZYYYrHeqiKBmzLDYVyrWBAPmGbnUjVj
         9BUWJv5tQc7QWAuRxENuIZcr3Nl5MMw9F/+JniS2LlqwpMtSTIAt+rioWZi5jreP1Son
         8h6w==
X-Forwarded-Encrypted: i=1; AJvYcCV2qqkzEqTKjFtXz0K/MI3ELBaPF+4shvtTb1t46rXRAzA6vVWaP6o83jcFFLnzlmwgzmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQFXfDmPhsfNpi/ev/eJpXrfgCUBtA6fvXoXXKH9AzIx97p/QA
	TETdCJ8gvsReO7FfTnGp6ziQYF1ggxNfprSfOBu45ki6na7W7toOhin9rB8PQuE=
X-Gm-Gg: ASbGncthELauf/Y/1HUg5BbhL4VpOWsILrWNgPKZF/JfooodJK9Adr1UsEC8kBm8RnL
	V8yZORZCZAooETvrBQmc/QY9daju4Ov6CDDHtMq47UYxAWXrClpC14YkOdUnEHjJZAntMcCC5cz
	qkU5kQyk2zaLMEwRbor/UcfGtwsT48YOdYTc34KgzqBH3qhdh+9l7oVRn4toLsd7uI3Kfjtj/Yu
	0v6qUHZcB5bFkdxLbNaNvJl7zd4phG0VBurwFjl1Xyj9GSjGKaOXjGLRgDyFYRILrrgHGyxe6NT
	fqB+iUOyifbqKfMYO7XNNZKybFB0NN/2g9VUqg3+3n1HaJWCIb34LrqE4OFCqB9aisrBIKNrHxP
	/Kr7zfwFaiw==
X-Google-Smtp-Source: AGHT+IEamG3WdlxD2LrQxwdmg89i4SPc4GJaByF7u76Lrx89qJx15nBJz8iHq3PU1coEHuSB+Sy0JA==
X-Received: by 2002:a05:6000:1ac6:b0:391:48f7:bd8a with SMTP id ffacd0b85a97d-3996b467819mr185608f8f.30.1742228627083;
        Mon, 17 Mar 2025 09:23:47 -0700 (PDT)
Received: from [192.168.1.74] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c83b6b2bsm15083896f8f.26.2025.03.17.09.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 09:23:46 -0700 (PDT)
Message-ID: <d93f6514-6d42-467d-826b-c95c6efd66b1@linaro.org>
Date: Mon, 17 Mar 2025 17:23:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/17] exec/ram_addr: call xen_hvm_modified_memory only
 if xen is enabled
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
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
 <20250314173139.2122904-12-pierrick.bouvier@linaro.org>
 <ad7cdcaf-46d6-460f-8593-a9b74c600784@linaro.org>
 <edc3bc03-b34f-4bed-be0d-b0fb776a115b@linaro.org>
 <9c55662e-0c45-4bb6-83bf-54b131e30f48@linaro.org>
Content-Language: en-US
In-Reply-To: <9c55662e-0c45-4bb6-83bf-54b131e30f48@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/3/25 17:22, Philippe Mathieu-Daudé wrote:
> On 17/3/25 17:07, Pierrick Bouvier wrote:
>> On 3/17/25 08:50, Philippe Mathieu-Daudé wrote:
>>> On 14/3/25 18:31, Pierrick Bouvier wrote:
>>>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>> ---
>>>>    include/exec/ram_addr.h | 8 ++++++--
>>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
>>>> index f5d574261a3..92e8708af76 100644
>>>> --- a/include/exec/ram_addr.h
>>>> +++ b/include/exec/ram_addr.h
>>>> @@ -339,7 +339,9 @@ static inline void 
>>>> cpu_physical_memory_set_dirty_range(ram_addr_t start,
>>>>            }
>>>>        }
>>>> -    xen_hvm_modified_memory(start, length);
>>>> +    if (xen_enabled()) {
>>>> +        xen_hvm_modified_memory(start, length);
>>>
>>> Please remove the stub altogether.
>>>
>>
>> We can eventually ifdef this code under CONFIG_XEN, but it may still 
>> be available or not. The matching stub for xen_hvm_modified_memory() 
>> will assert in case it is reached.
>>
>> Which change would you expect precisely?
> 
> -- >8 --
> diff --git a/include/system/xen-mapcache.h b/include/system/xen-mapcache.h
> index b68f196ddd5..bb454a7c96c 100644
> --- a/include/system/xen-mapcache.h
> +++ b/include/system/xen-mapcache.h
> @@ -14,8 +14,6 @@
> 
>   typedef hwaddr (*phys_offset_to_gaddr_t)(hwaddr phys_offset,
>                                            ram_addr_t size);
> -#ifdef CONFIG_XEN_IS_POSSIBLE
> -
>   void xen_map_cache_init(phys_offset_to_gaddr_t f,
>                           void *opaque);
>   uint8_t *xen_map_cache(MemoryRegion *mr, hwaddr phys_addr, hwaddr size,
> @@ -28,44 +26,5 @@ void xen_invalidate_map_cache(void);
>   uint8_t *xen_replace_cache_entry(hwaddr old_phys_addr,
>                                    hwaddr new_phys_addr,
>                                    hwaddr size);
> -#else
> -
> -static inline void xen_map_cache_init(phys_offset_to_gaddr_t f,
> -                                      void *opaque)
> -{
> -}
> -
> -static inline uint8_t *xen_map_cache(MemoryRegion *mr,
> -                                     hwaddr phys_addr,
> -                                     hwaddr size,
> -                                     ram_addr_t ram_addr_offset,
> -                                     uint8_t lock,
> -                                     bool dma,
> -                                     bool is_write)
> -{
> -    abort();
> -}
> -
> -static inline ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
> -{
> -    abort();
> -}
> -
> -static inline void xen_invalidate_map_cache_entry(uint8_t *buffer)
> -{
> -}
> -
> -static inline void xen_invalidate_map_cache(void)
> -{
> -}
> -
> -static inline uint8_t *xen_replace_cache_entry(hwaddr old_phys_addr,
> -                                               hwaddr new_phys_addr,
> -                                               hwaddr size)
> -{
> -    abort();
> -}
> -
> -#endif
> 
>   #endif /* XEN_MAPCACHE_H */

(sorry, the include/system/xen-mapcache.h change is for the next patch)

> diff --git a/include/system/xen.h b/include/system/xen.h
> index 990c19a8ef0..04fe30cca50 100644
> --- a/include/system/xen.h
> +++ b/include/system/xen.h
> @@ -30,25 +30,16 @@ extern bool xen_allowed;
> 
>   #define xen_enabled()           (xen_allowed)
> 
> -void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length);
> -void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
> -                   struct MemoryRegion *mr, Error **errp);
> -
>   #else /* !CONFIG_XEN_IS_POSSIBLE */
> 
>   #define xen_enabled() 0
> -static inline void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t 
> length)
> -{
> -    /* nothing */
> -}
> -static inline void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
> -                                 MemoryRegion *mr, Error **errp)
> -{
> -    g_assert_not_reached();
> -}
> 
>   #endif /* CONFIG_XEN_IS_POSSIBLE */
> 
> +void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length);
> +void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
> +                   MemoryRegion *mr, Error **errp);
> +
>   bool xen_mr_is_memory(MemoryRegion *mr);
>   bool xen_mr_is_grants(MemoryRegion *mr);
>   #endif
> ---


