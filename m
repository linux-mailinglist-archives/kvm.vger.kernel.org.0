Return-Path: <kvm+bounces-41247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 383D0A6584D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:38:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18BAF189C385
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900BD1A2860;
	Mon, 17 Mar 2025 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lT2JEXDD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430F21A2381
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742229460; cv=none; b=qdz9fu77WlFCf4mDiKU0a4TGOkX0Rd/cD9fKcMqQnirAgor+emeWIngvgP4xfmLeWm5X18J0SUz4HPGlsShgLhCrrApLfna8ge1rETPbGqmcedDJBtPMUsnLY2u4+SHM9zbOxRlMp0hh5pTmEdWREgB4xSf2hwoo9LrppeLQ2vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742229460; c=relaxed/simple;
	bh=AKuD9lL+3cui9iII20V5Gg63ovIP2T9Hg6+6gg3T6ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBOrF6sjPrJjHpP5y/yT8+QDlKxsO5k/zKg1OJXUjaoVWvKoS8hBfYJImzHmhXnGkUHmezrImB92ZR5LpxnaopdvUSeHwuCJ41Tf0v3s3abNxjA2TWlLXUG0g0ZrgCEVrWKlA9vzr8p+CFOwUvW5tnn8EDaRk75hoWDC3br43o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lT2JEXDD; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2240aad70f2so55265ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742229458; x=1742834258; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V3/EYuGkMIiunQkE35x51UlkP8FydWfrU3XJ5GNt/b4=;
        b=lT2JEXDDW+AHpokZVPlM0pItosya9KanX/Bf+oX152gmIP/fZa9quGSLSA7e41mqKF
         ygIHYanY/z2y6bsOte9xwUH0Cpe5TfsWylutqZWDFSM48rAbST0k7i+60gTPfyBAmfwJ
         EbkxHUOogJL2MFMtMdN9/n0oAy6Nl2BZXfYIKRtEk7yC3shySVs1fVsy7CxI8bvMsYdj
         m3W2eeWDiJRzajZy1sbTBd1W+NcgWxHOzp6V2l1aSLJPo+tZnWcF5roab83oWpl3830H
         qvEp2WtaGNobc2oimeOqIEolcUKsGyCrIH0iUIRA8peFYvO5E6JbVfvwFQnzMVJ/+iDS
         QbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742229458; x=1742834258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V3/EYuGkMIiunQkE35x51UlkP8FydWfrU3XJ5GNt/b4=;
        b=u+396NCzzYZZyGxcD84kRc2QJvEq+GSuWiUHvI9Cp0gTJBprSLWhWxE1PK9Js/Xo0u
         AokBsCWWDdsmd5+jd81CxKUHvK2TXC45Lwy+jQE/Xn/B7EdaYNMiwe0PTojPk2edkQxH
         1RU96OXTWFM23JgOXMCZOxpsKbT++wSeNHAONDvUj7AlJ4vCGC0p0HdRzCWdOb7FOt9u
         67b5rgMrR/pwJx+P4yOwDZe1wby2imWSQSBTpnQKlRuANOrHmhMREGJEwAU4NQOAaD7F
         g65hjhZ3V0okJJm/ie16w45P3FPkZ8gAv1PFqvkk1ATepdOlZxXSGUvS3CCfqvy/dfCc
         VmZw==
X-Forwarded-Encrypted: i=1; AJvYcCXGYudotX7F0FzizRiMCNU2DvBdKqF+1hHASpqu92fRWVcHLlaISAwB9gTngwb/jw41aH0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVOPClvT7kcmgxHwyRb1t6/AqpEsqjakUKYdG4wI19tuKdbsD9
	sUp2IGLrMK2sZuyidCRb1hhdBKyRXLtMgC2XM8QiyYn/K6OeqqdhJbNeGqfsHHqu8QQ+F6l0GBo
	ENw==
X-Gm-Gg: ASbGncsnnUU8rQXcJjaWZoaICOelH925Y/6tEn6zFYi9fxaqgxebacZHrN9yQ3AaDyu
	zJWNbNYEmnifxQmIITQWXq7BiWk/4wif3hXNFQy7yz8pN59vhYAshKS/G6ZiFz39MVNFto/AyGf
	0/Zo8duKk5E34ovdF940QygZdvVDtpKhEi1eOFGLgSkmX+usaLmifL16g6o0w399UHv5sYD2gJx
	nwnah6/pPw0CZWP14UctuBUmIeF2wiC9C3koRnEuX/2Y7aROy08pX8qP5iMzALyR9jiUZNNgO2V
	/ESVg+zdO8t3tN26SUVk+O/t0ZH3Nc0OHlI/ItPNozFxgpUAjDB6dU2NS1YfaTZpXsgpmw4+KnL
	Bo8SrQ72k/Cf1CfvG
X-Google-Smtp-Source: AGHT+IGTT7oirH5Crt6ZdBBB+GEod7hnh7ZOY2WV0JKG5s0rcA9DoR4brF9uecD18UnvNguCFzREug==
X-Received: by 2002:a17:903:17cd:b0:220:c905:68a2 with SMTP id d9443c01a7336-225f57daf74mr4054325ad.5.1742229458021;
        Mon, 17 Mar 2025 09:37:38 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371167e109sm7796841b3a.115.2025.03.17.09.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 09:37:36 -0700 (PDT)
Date: Mon, 17 Mar 2025 09:37:32 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Dynamically allocate shadow MMU's
 hashed page list
Message-ID: <20250317163732.GA1863989.vipinsh@google.com>
References: <20250315024010.2360884-1-seanjc@google.com>
 <20250315024010.2360884-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315024010.2360884-2-seanjc@google.com>

On 2025-03-14 19:40:08, Sean Christopherson wrote:
> Dynamically allocate the (massive) array of hashed lists used to track
> shadow pages, as the array itself is 32KiB, i.e. is an order-3 allocation
> all on its own, and is *exactly* an order-3 allocation.  Dynamically
> allocating the array will allow allocating "struct kvm" using regular
> kmalloc(), and will also allow deferring allocation of the array until
> it's actually needed, i.e. until the first shadow root is allocated.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++--
>  arch/x86/kvm/mmu/mmu.c          | 21 ++++++++++++++++++++-
>  arch/x86/kvm/x86.c              |  5 ++++-
>  3 files changed, 26 insertions(+), 4 deletions(-)
> 
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6673,13 +6685,19 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  		kvm_tdp_mmu_zap_invalidated_roots(kvm, true);
>  }
>  
> -void kvm_mmu_init_vm(struct kvm *kvm)
> +int kvm_mmu_init_vm(struct kvm *kvm)
>  {
> +	int r;
> +
>  	kvm->arch.shadow_mmio_value = shadow_mmio_value;
>  	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>  	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
>  	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
>  
> +	r = kvm_mmu_alloc_page_hash(kvm);
> +	if (r)
> +		return r;
> +

In the patch 3, shouldn't this be moved to else part of the below 
'if (tdp_mmu_enabled)' line? Otherwise, this hash array will always get
allocated.

>  	if (tdp_mmu_enabled)
>  		kvm_mmu_init_tdp_mmu(kvm);
>  
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12704,7 +12704,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	if (ret)
>  		goto out;
>  
> -	kvm_mmu_init_vm(kvm);
> +	ret = kvm_mmu_init_vm(kvm);
> +	if (ret)
> +		goto out_cleanup_page_track;
>  
>  	ret = kvm_x86_call(vm_init)(kvm);
>  	if (ret)
> @@ -12757,6 +12759,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  out_uninit_mmu:
>  	kvm_mmu_uninit_vm(kvm);
> +out_cleanup_page_track:

I think there is a memory leak in this series.

1. kvm_mmu_uninit_vm() is not freeing kvm->arch.mmu_page_hash. So, in
error case out_uninit_mmu will not recover memory allocated in
kvm_mmu_alloc_page_hash().

2. When VM terminates or is killed then the same thing will happen, no
one is reclaiming the memory.

>  	kvm_page_track_cleanup(kvm);
>  out:
>  	return ret;

