Return-Path: <kvm+bounces-40706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1877A5B157
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 01:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E5B13AE19E
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 00:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D7E2F5E;
	Tue, 11 Mar 2025 00:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ogDADxfo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7C01367
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 00:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741651722; cv=none; b=uN/JPcnjdQ5s5zqlqC/fUyB3O6PBPZ15ys0t082rc5I/xMPLa5uHvp/oFEHcGgh2A/Q/bQOBlFyRGK/TjP4Ekr1GvJxJ87W3uwrGdAmwwpMz9lKkWWrH89ZxJmMDdAMky7VkN7FIOz1Am5VWmdMOjpe4iTFMv12qsWxb4zFPC7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741651722; c=relaxed/simple;
	bh=Cvh1RtQnMU6grwKtrt7k8hVDS0kw9T+tOkujjathD0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pJk3SKUfXzUdXvJJQyWkqyw1BlKDNxbVSMql70yZdn2sbb4lxJ4RuikEwoM421MYGtIWI8EP0W0s+0Z7AC75l3cKoFCYdIyic89kY/PS1+bv4MRm4qFmJJoHnRNCSMMABCJTFltWfkoNaH48hiZf19MOt9Ar1tX8e1h51RUT2Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ogDADxfo; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2f9d3d0f55dso7381395a91.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 17:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741651719; x=1742256519; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PTvxJUlPBJjWMPlx3bz6qPMSvpnDhRXJlpzPDdfISJA=;
        b=ogDADxfoVu54PKpYq1ObC6cmVzhuZioDrvC25EuNGvA9aBVUjp3aTk64RQT2D/gGrw
         7YwP5cuo9orYA7dq7zk13bbJTKbMhGDmIqL0SR+oLTd6CqLZ1sbRf+Xba7drlAQPW2hy
         imDyiiuTU15S3G44GFALTfFf/SqZ/qMhpFKyXy6N27oaaMrI27wuPxYhyZG7ALiXMUXT
         2ceLYxXddr4m9KBWg+HjXKjyvDAyfKVHBqmCaGJ+AgIoDSEoW3kvo/guEE+K5K7clb22
         teXhj6Am1Y5q5Dxe42Mk98GtjGUu5MYkZ07zDptY157whZlWE3EdoJs9m+WISdavie8h
         sSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741651719; x=1742256519;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PTvxJUlPBJjWMPlx3bz6qPMSvpnDhRXJlpzPDdfISJA=;
        b=Jnu7i9xEjr+oHkdqqr8f0VxxWdR+7KoLJEvzI8ezYo6xjklcq/2ozHABxognpf63PO
         AzcbUVLUgeLbf82imCj00L2CJuhNe4Q3hJbK5bb/AjtHUEo5apaRXADaopQSGYB/ZKA0
         N/Yyms4VbdkqALbk/Iyk+o2ZMWXkdC073rGCgD6pSfOxAqVi3WizNNX/vNpMq94+kJPT
         Q7moNEmLw2fjvfv5vJHwZ5uqIqNq8//mijOHe3pkBSBDuT9mn5PFRaigki5nEA3a9yW2
         KymWgBxb9yK1ry3/oQa2/pwzsERdge8I+jcR//DiW0aEVcVMiWJFYV0+j0AxfNpJRoe+
         gEQw==
X-Forwarded-Encrypted: i=1; AJvYcCWnqYRWuNnJGYc4BClTshPgpRzFmpDdOnNJb8ZGD0f0GKaEmRbjyb6L5eCmHlPFnObk01Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWS4uDYnur/A68HD9BFmaosXwe4uH2B39kcqIEHTUBOO8LXTXn
	NrXGADBROv+P6a2iXweBI66U7DMNt5/CsZ7hCSqwntEEPn2ppKdx/Rh8Fbw6SSc=
X-Gm-Gg: ASbGncslVlgJ8t0On0koExjUNxsH8zBXMpLUmf2jH6E/7vbBFEQ5Lwh6dg34oPxPEy7
	LXfRuOGBtORQfHFDE4qYh60mCwXhdJgw/6dFuljXKR8WeQf+oVRQlL314jlOLfYxIRFDURhE2Ww
	AZYX5v6dGdGbVJweZJCGiao9ZfOpfz22DZbswkN6lZLe7eS93bg8rn8Ci37b/BJIum4BGFR9+Nb
	8RlMFFAUcNb89RwP29AhJD5cbWwaMSmY42hlO6h4MwAjONhHPQ7nSPifVTuPctP0Uch7/CRSBDS
	6U2H9v1pi0MNsqO5y4RO/ORTe511jRtsDODpLpZdsLi7GX9KveYhDxoNhw==
X-Google-Smtp-Source: AGHT+IGi4aJraVBfVl/EoRE61kEiyTdmOlXjmvYO10+d4f3aT2ylBHqrXw1ypyhAFiauPBgYo5Y/4w==
X-Received: by 2002:a17:90b:3c49:b0:2ee:e317:69ab with SMTP id 98e67ed59e1d1-2ff7cd62f6dmr28557548a91.0.1741651719455;
        Mon, 10 Mar 2025 17:08:39 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30103449c84sm109325a91.1.2025.03.10.17.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 17:08:39 -0700 (PDT)
Message-ID: <106877af-deff-4919-adad-698b4c09b85e@linaro.org>
Date: Mon, 10 Mar 2025 17:08:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] exec/memory_ldst_phys: extract memory_ldst_phys
 declarations from cpu-all.h
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Paul Durrant <paul@xen.org>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Anthony PERARD <anthony@xenproject.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, manos.pitsidianakis@linaro.org,
 qemu-riscv@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
 <20250310045842.2650784-3-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250310045842.2650784-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/25 21:58, Pierrick Bouvier wrote:
> They are now accessible through exec/memory.h instead, and we make sure
> all variants are available for common or target dependent code.
> 
> To allow this, we need to implement address_space_st{*}_cached, simply
> forwarding the calls to _cached_slow variants.
> 

It's not needed, following inclusion will do it.

#define ENDIANNESS
+#include "exec/memory_ldst_cached.h.inc"

> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h              | 15 ------------
>   include/exec/memory.h               | 36 +++++++++++++++++++++++++++++
>   include/exec/memory_ldst_phys.h.inc |  5 +---
>   3 files changed, 37 insertions(+), 19 deletions(-)
> 
> diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
> index 17ea82518a0..1c2e18f492b 100644
> --- a/include/exec/cpu-all.h
> +++ b/include/exec/cpu-all.h
> @@ -75,21 +75,6 @@ static inline void stl_phys_notdirty(AddressSpace *as, hwaddr addr, uint32_t val
>                                  MEMTXATTRS_UNSPECIFIED, NULL);
>   }
>   
> -#define SUFFIX
> -#define ARG1         as
> -#define ARG1_DECL    AddressSpace *as
> -#define TARGET_ENDIANNESS
> -#include "exec/memory_ldst_phys.h.inc"
> -
> -/* Inline fast path for direct RAM access.  */
> -#define ENDIANNESS
> -#include "exec/memory_ldst_cached.h.inc"
> -
> -#define SUFFIX       _cached
> -#define ARG1         cache
> -#define ARG1_DECL    MemoryRegionCache *cache
> -#define TARGET_ENDIANNESS
> -#include "exec/memory_ldst_phys.h.inc"
>   #endif
>   
>   /* page related stuff */
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 78c4e0aec8d..7c20f36a312 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -2798,6 +2798,42 @@ static inline void address_space_stb_cached(MemoryRegionCache *cache,
>       }
>   }
>   
> +static inline uint16_t address_space_lduw_cached(MemoryRegionCache *cache,
> +    hwaddr addr, MemTxAttrs attrs, MemTxResult *result)
> +{
> +    return address_space_lduw_cached_slow(cache, addr, attrs, result);
> +}
> +
> +static inline void address_space_stw_cached(MemoryRegionCache *cache,
> +    hwaddr addr, uint16_t val, MemTxAttrs attrs, MemTxResult *result)
> +{
> +    address_space_stw_cached_slow(cache, addr, val, attrs, result);
> +}
> +
> +static inline uint32_t address_space_ldl_cached(MemoryRegionCache *cache,
> +    hwaddr addr, MemTxAttrs attrs, MemTxResult *result)
> +{
> +    return address_space_ldl_cached_slow(cache, addr, attrs, result);
> +}
> +
> +static inline void address_space_stl_cached(MemoryRegionCache *cache,
> +    hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result)
> +{
> +    address_space_stl_cached_slow(cache, addr, val, attrs, result);
> +}
> +
> +static inline uint64_t address_space_ldq_cached(MemoryRegionCache *cache,
> +    hwaddr addr, MemTxAttrs attrs, MemTxResult *result)
> +{
> +    return address_space_ldq_cached_slow(cache, addr, attrs, result);
> +}
> +
> +static inline void address_space_stq_cached(MemoryRegionCache *cache,
> +    hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result)
> +{
> +    address_space_stq_cached_slow(cache, addr, val, attrs, result);
> +}
> +
>   #define ENDIANNESS   _le
>   #include "exec/memory_ldst_cached.h.inc"
>   
> diff --git a/include/exec/memory_ldst_phys.h.inc b/include/exec/memory_ldst_phys.h.inc
> index ecd678610d1..db67de75251 100644
> --- a/include/exec/memory_ldst_phys.h.inc
> +++ b/include/exec/memory_ldst_phys.h.inc
> @@ -19,7 +19,6 @@
>    * License along with this library; if not, see <http://www.gnu.org/licenses/>.
>    */
>   
> -#ifdef TARGET_ENDIANNESS
>   static inline uint16_t glue(lduw_phys, SUFFIX)(ARG1_DECL, hwaddr addr)
>   {
>       return glue(address_space_lduw, SUFFIX)(ARG1, addr,
> @@ -55,7 +54,7 @@ static inline void glue(stq_phys, SUFFIX)(ARG1_DECL, hwaddr addr, uint64_t val)
>       glue(address_space_stq, SUFFIX)(ARG1, addr, val,
>                                       MEMTXATTRS_UNSPECIFIED, NULL);
>   }
> -#else
> +
>   static inline uint8_t glue(ldub_phys, SUFFIX)(ARG1_DECL, hwaddr addr)
>   {
>       return glue(address_space_ldub, SUFFIX)(ARG1, addr,
> @@ -139,9 +138,7 @@ static inline void glue(stq_be_phys, SUFFIX)(ARG1_DECL, hwaddr addr, uint64_t va
>       glue(address_space_stq_be, SUFFIX)(ARG1, addr, val,
>                                          MEMTXATTRS_UNSPECIFIED, NULL);
>   }
> -#endif
>   
>   #undef ARG1_DECL
>   #undef ARG1
>   #undef SUFFIX
> -#undef TARGET_ENDIANNESS


