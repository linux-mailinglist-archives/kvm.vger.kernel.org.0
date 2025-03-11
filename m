Return-Path: <kvm+bounces-40774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C492A5C52D
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 987F61893BBC
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F99A25DD12;
	Tue, 11 Mar 2025 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QG6oajQF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40EA8632E
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705754; cv=none; b=XZKcCH00ihE/rNBdC1LILjrtIUm3fNbKDpqWtQwQAZJ2Hi3ehF3cr151X03pNIaxi5i0Y/8ChzmxQgyTW2030Z04OWxy16iRVlWP6XQfEHcz94KBx7o2SLvuxCLBZmX13OICNZb2sHc81eNgaCETnPan3AFYlUh+ytgmA7+4VqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705754; c=relaxed/simple;
	bh=UJXSVBifmgXhu5e9Wyo4KWVbVHftcCNkWgkb5UELmx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gPkZc6amH84g33myK4ek0EcYhadOjB1fL2/aiqZ+b3kXH7hNiWXCh48icygnxv3GFukSIRnprZzjJn+mLCoUPY04+cUaR35EuoilfIzBU5CI0Un5DnRoqoOo/M9KbSk9UM1mMqsHbciIeHttDnZMef37oM+n3pxis7LVa72mah0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QG6oajQF; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22548a28d0cso17363505ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741705752; x=1742310552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qBzq3gZ4RElKkwYhaj8ZNxHgJX2I6SVrzxCcg9CG9Dw=;
        b=QG6oajQFP32lHGXQt34/9oYiZurbtm8pJLS4xkrnJ3Ia1MgR+eW65cry/2jTuYqwAQ
         /Q7EO8JW309KFxaqkt+eS356Q7dL3gqvbewELpIfZiY+8NCtzMyTiy8wYgf7aba4HZJ2
         hMwpUV6Cwp1SCHQyh9mmhOQ3WBd38UNVeN868aypqaXx3f8m63gjrw6GJvYQ5nVYhdzk
         itClurnlbV2PyPauuYEzb8pqindqXuz7X8DLsJgMEOXpNZ/ujtTpyspxfgfp2ZH3U0wx
         8MtTZ4JkjcogbQgp4PPqvzEv1Qh1oX7Aj7e2/8BT2UBEt+aOs2HhCeOPu4z9VZ6f6fXV
         JX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741705752; x=1742310552;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBzq3gZ4RElKkwYhaj8ZNxHgJX2I6SVrzxCcg9CG9Dw=;
        b=NLzfDMPCma1x7p7NJcGYV1Z/biv/2FpdZPUqUdz7Ur8Ii6nGJOKtc1RCZMhmteFX1s
         1JMm6N7cFyg4gwMZOhc9QMGTBxEJ824btxTnFqqoQKsINzxyWKKF4Y4ZcN4poOFNrGeY
         AzRZMcaF3FKWktMP9ipTYE8oK+PCdEForqYiKucnwZrLP7yL7Ye5wdXsVinp9Pj27bfj
         N+HM9YldsdeIvV2X78A/LWFfHUCs6EguOLdc6xg1IC4qRxTKM7aNVwzEwdkt3PfNsisu
         BlsG6W1IYtBhZXLTiagnLTpFWQ9Xu8OhXIPfzTSfotc6s8EGjqNrSRB94IYbfdz8phA+
         dsDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWA56Ci+b+I7A0rDN8dsniImOcEMtqIngXWiUO9gQhgjVLkzrxgu57iWejbWo/KzRnUcjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxPyL2ULALUcKr4B5jhjO6Z690tEuV/UiE1MrO5vSuonyx6JJO
	PEuGN3DjyoSgYSbTRqKjhZKBvfLfzAhXL0HANeZij1pDwuACwp/UvouPxBaeWig=
X-Gm-Gg: ASbGncslM2LpRdmj7YGpkXuJBXubmg9crR9JQ9OxBCBjAeTpOAWXoEklomJVRrkmr2P
	zma2nZCf5WLyq2Udrirb0aV/BoettbuYxCKmD04XMAYLiQwdAUoV6e+pPqgUakDmjZbh5apTOaj
	O9GqkG55nSheuQU1+Gvzx9Ij5e/4f4Z8Z+vUtM4idViAAEmlYpdwZftDtW/rhTS6HJnnF0j6cGD
	zOs9TsdyEsurhjYt54/wE3Is+GYaIzgVWdpTY+/46Kd4KoqcFBub1bJpixkm6VXW29vCA8eP9hE
	NWgNhuh1QO+JjnJw8EMSJPch513MjEM2tc7g3aDqvzUCHScoNyUmNjNqsw==
X-Google-Smtp-Source: AGHT+IHdtXZCBvbhA4fnw5TeglBYyYnfR3rHysBoeOpLSs+t9AWpL5KS2rwpMgVJc9S6ANeeel2twg==
X-Received: by 2002:a05:6a00:2e17:b0:730:95a6:3761 with SMTP id d2e1a72fcca58-736aa9e745amr29105632b3a.3.1741705752226;
        Tue, 11 Mar 2025 08:09:12 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736b3f2412csm8273161b3a.175.2025.03.11.08.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 08:09:11 -0700 (PDT)
Message-ID: <437c66f2-b2f5-42dd-a266-581997d90581@linaro.org>
Date: Tue, 11 Mar 2025 08:09:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/16] exec/memory_ldst: extract memory_ldst
 declarations from cpu-all.h
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
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
 <20250311040838.3937136-4-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250311040838.3937136-4-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 21:08, Pierrick Bouvier wrote:
> They are now accessible through exec/memory.h instead, and we make sure
> all variants are available for common or target dependent code.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h         | 12 ------------
>   include/exec/memory_ldst.h.inc |  4 ----
>   2 files changed, 16 deletions(-)
> 
> diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
> index e56c064d46f..0e8205818a4 100644
> --- a/include/exec/cpu-all.h
> +++ b/include/exec/cpu-all.h
> @@ -44,18 +44,6 @@
>   
>   #include "exec/hwaddr.h"
>   
> -#define SUFFIX
> -#define ARG1         as
> -#define ARG1_DECL    AddressSpace *as
> -#define TARGET_ENDIANNESS
> -#include "exec/memory_ldst.h.inc"
> -
> -#define SUFFIX       _cached_slow
> -#define ARG1         cache
> -#define ARG1_DECL    MemoryRegionCache *cache
> -#define TARGET_ENDIANNESS
> -#include "exec/memory_ldst.h.inc"
> -
>   static inline void stl_phys_notdirty(AddressSpace *as, hwaddr addr, uint32_t val)
>   {
>       address_space_stl_notdirty(as, addr, val,
> diff --git a/include/exec/memory_ldst.h.inc b/include/exec/memory_ldst.h.inc
> index 92ad74e9560..7270235c600 100644
> --- a/include/exec/memory_ldst.h.inc
> +++ b/include/exec/memory_ldst.h.inc
> @@ -19,7 +19,6 @@
>    * License along with this library; if not, see <http://www.gnu.org/licenses/>.
>    */
>   
> -#ifdef TARGET_ENDIANNESS
>   uint16_t glue(address_space_lduw, SUFFIX)(ARG1_DECL,
>       hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
>   uint32_t glue(address_space_ldl, SUFFIX)(ARG1_DECL,
> @@ -34,7 +33,6 @@ void glue(address_space_stl, SUFFIX)(ARG1_DECL,
>       hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result);
>   void glue(address_space_stq, SUFFIX)(ARG1_DECL,
>       hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
> -#else
>   uint8_t glue(address_space_ldub, SUFFIX)(ARG1_DECL,
>       hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
>   uint16_t glue(address_space_lduw_le, SUFFIX)(ARG1_DECL,
> @@ -63,9 +61,7 @@ void glue(address_space_stq_le, SUFFIX)(ARG1_DECL,
>       hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
>   void glue(address_space_stq_be, SUFFIX)(ARG1_DECL,
>       hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
> -#endif
>   
>   #undef ARG1_DECL
>   #undef ARG1
>   #undef SUFFIX
> -#undef TARGET_ENDIANNESS

Just to track last Richard answer,
Posted on v1:

On 3/10/25 17:04, Pierrick Bouvier wrote:
 >  From what I understand, non endian versions are simply passing 
DEVICE_NATIVE_ENDIAN as a
 > parameter for address_space_ldl_internal, which will thus match the 
target endianness.
 >
 > So what is the risk for common code to call this?

You're right.  I failed to look at the current implementation
to see that it would already work.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~


