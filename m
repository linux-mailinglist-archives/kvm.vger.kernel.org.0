Return-Path: <kvm+bounces-63286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E36D9C60033
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 06:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4E5C04E4668
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 05:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678CD1DED63;
	Sat, 15 Nov 2025 05:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="lOq9uXio"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE181ACDFD
	for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 05:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763184651; cv=none; b=kfEt4ul7+tnsFbCecgdN+UNUumvvH4ZO96f3FXayBmLw3sbqcnMCZUQAQj450QgGLvfkGbUyObmQ6wRyWqPEa4mc356NISV1pGINTEQgu5/veW3gXZerQMeDm2P8MMmbOpoaOJIzw1JenvHMK8MlvwY870zfjm43QABC5t0UbPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763184651; c=relaxed/simple;
	bh=wZ4yDUi+E4eqcnF+IkQWFZuqvHtqQWGq/JRWTz5gmZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B0lNDko+9MtMFlEKIfFsHhLmHTutUEMMOlas9siOmRm3Q/zDnPaltuX4leXJrnj2+N6exICxFOWai+4vsat59wXjIvFAzb/Y9beqPoPpAarHeOIdhPNFXlLaCSBiRWwxe1zrP+UxYCYnfRu4CeGo4JSDq6+RNNMOAbQuMqi0chk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=lOq9uXio; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47789cd2083so19538155e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 21:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763184646; x=1763789446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZBVl6rxsCB8n1n03GXoPt/FJ/duB1/D5T0JDvYu+wiU=;
        b=lOq9uXioUznm0eQyPyvcyV8gUIckvD71GdsEH34NBlM46EBbkNszMYoQp/rRH+4UUf
         HOPZMqAp2v1+VkBdHdBz9tQS/MxR7DtaJbeA9Pww7PUwklihQGpyAeu/nfp9JrQXr/62
         SqAVYO28XA3vufAttuaDYq71HJ2COHGucYTJ39kAPdXLC4ipBUxynwm2GICQ5D7IkFxz
         APvO3VGwOS5x7DntDPMyb94hAAFzV+c9U7X8tEZ1BNdHutc4FoMsXHYSeb3WbZBwheNe
         y41u/6HEXvKsC3vblJdTllOC81FP/P+0k74ft5tvIQNP8+85cGT6rFWZVqkjabaR1WjV
         5Ycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763184646; x=1763789446;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZBVl6rxsCB8n1n03GXoPt/FJ/duB1/D5T0JDvYu+wiU=;
        b=ZewL3Piih7bwGPFHyrJ8SbbU6KA/7UAakGrRhwnWk/t70AxGrD74f7RHl/JkvjYWtr
         mjNRXxfuhrE4TTh8BmQabr7Z/1aAD5hnmtqju9OxeW3kmWn9O62rVfJ2+NdOr+Abdl6C
         SUwPtIS/YOKZO0RO91nyIKTEal0ZHWLsYOW+I2/6xM0QVUY6YdUGuEbhmJ0am9kahnFb
         hrRPeo7u5nOQHjTkfbBAxtJWEQxS6TBqrm0s6EwpUDaA0PvhHRPLsVvWWTvBikFcoCuI
         qCwriXvt1Pg0ka3KYQR3Vkh6wxfwLhgwqqDc1Wsag8qFNb2PFfpG3hHDk1i2fMkduuCY
         249w==
X-Gm-Message-State: AOJu0Yyry86R35n6j80vZWF0xTgJLrKj1I28gWi3WRKUBc9XXc6xkhy+
	MUl+7ZVxqg0G/XEY7nR50sHtLfeJRwGtyubLsaZK1wLnqoDsDsCdXDG3wZligKPgasw=
X-Gm-Gg: ASbGncu3ygb1gAk/Uu++NASYbskJM0SKmaNRhEfKIVlwvtmKNABtu4izj/7JNJg/lsZ
	4nl0crPfFyOpeOHLB2Vx0UGB+E+IntPDtBW+sgJ6O18WhTQ8zRaGbLkEmhoAZJAZfXiHpUy0pKT
	VsZlkhYvmzURjv1Uv4dOUE85x1Yf92JJcpZ3Pfr+VMZXfaWZGdKDsNdWWF0xuKE9u+WbnuYQUC/
	ktvpVTUc69sa78OrQsQnL40kYzOxULvofZ+ne4UkZjG5jc5GT6JzMrnjBNQB+o/1a8G/ZTiFN+K
	CIbR4f4ERdh4KAQX26fDArNDnxvlkYW2WimELBjgZE9AYg7qBTHhriqe4DaX+xFuJBzCDn9hTsl
	Y/38wwIkqE7c/nMl5qY9vUsaDEKNYUN9bxYFaESQZ4PEbiGB6Fy61dcPGkxSnBGxsHnuKvfUcOs
	N0NRSWNb4o6uyCSE9B36emQGtXczAn+ngbJnVlGCZK/yDVr76ZKnHrx+T4ivoj6LwYI8Ngy6H0D
	axrm/lY4CEoEeJIgSBooFgI1ecB8/5urRq6K76vPxMyGg==
X-Google-Smtp-Source: AGHT+IEx9b6zkQp4GyuTFehmALoWq8HDn7IW6cQXc/J8veqZFMkYa8p2G4jNp/wGZBl6wxCMgXPrKw==
X-Received: by 2002:a05:600c:630e:b0:477:7af8:c8ad with SMTP id 5b1f17b1804b1-4778fea85b4mr56491965e9.31.1763184646379;
        Fri, 14 Nov 2025 21:30:46 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e8e6a1sm177159755e9.11.2025.11.14.21.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 21:30:45 -0800 (PST)
Message-ID: <817ee8ef-a912-4e5d-b381-885429f13e7b@grsecurity.net>
Date: Sat, 15 Nov 2025 06:30:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 16/18] x86: cet: Enable NOTRACK handling
 for IBT tests
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20251114205100.1873640-1-seanjc@google.com>
 <20251114205100.1873640-17-seanjc@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20251114205100.1873640-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 21:50, Sean Christopherson wrote:
> gcc's jump table handling makes use of 'notrack' indirect jumps, causing
> spurious #CP(3) exceptions.
> 

Missing a "From: Mathias Krause <minipli@grsecurity.net>", maybe?

> Enable 'notrack' handling for the IBT tests instead of disabling jump
> tables as we may want to make use of 'notrack' ourselves in future
> tests.  This will allow using report() in IBT tests, as gcc likes to
> generate a small jump table for exception_mnemonic():
> 
>  000000000040707c <exception_mnemonic>:
>   40707c:       endbr64
>   407080:       cmp    $0x1e,%edi
>   407083:       ja     407117 <exception_mnemonic+0x9b>
>   407089:       mov    %edi,%edi
>   40708b:       notrack jmp *0x4107e0(,%rdi,8)
>     ::
>   4070b1:       mov    $0x411c7c,%eax	# <-- #CP(3) here
> 
> Link: https://lore.kernel.org/all/fc886a22-49f3-4627-8ba6-933099e7640d@grsecurity.net
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/cet.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/x86/cet.c b/x86/cet.c
> index 26cd1c9b..74d3f701 100644
> --- a/x86/cet.c
> +++ b/x86/cet.c
> @@ -82,8 +82,9 @@ static uint64_t cet_ibt_func(void)
>  #define CP_ERR_SETSSBSY	0x0005
>  #define CP_ERR_ENCL		BIT(15)
>  
> -#define ENABLE_SHSTK_BIT 0x1
> -#define ENABLE_IBT_BIT   0x4
> +#define CET_ENABLE_SHSTK			BIT(0)
> +#define CET_ENABLE_IBT				BIT(2)
> +#define CET_ENABLE_NOTRACK			BIT(4)
>  
>  static void test_shstk(void)
>  {
> @@ -112,7 +113,7 @@ static void test_shstk(void)
>  	install_pte(current_page_table(), 1, shstk_virt, pte, 0);
>  
>  	/* Enable shadow-stack protection */
> -	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
> +	wrmsr(MSR_IA32_U_CET, CET_ENABLE_SHSTK);
>  
>  	/* Store shadow-stack pointer. */
>  	wrmsr(MSR_IA32_PL3_SSP, (u64)(shstk_virt + 0x1000));
> @@ -140,8 +141,8 @@ static void test_ibt(void)
>  		return;
>  	}
>  
> -	/* Enable indirect-branch tracking */
> -	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
> +	/* Enable indirect-branch tracking (notrack handling for jump tables) */
> +	wrmsr(MSR_IA32_U_CET, CET_ENABLE_IBT | CET_ENABLE_NOTRACK);
>  
>  	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
>  	report(rvc && exception_error_code() == CP_ERR_ENDBR,

Otherwise, LGTM!

Thanks,
Mathias

