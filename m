Return-Path: <kvm+bounces-38722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B7EA3DF77
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 16:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8CAB3AC92E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 15:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5C41FDA8E;
	Thu, 20 Feb 2025 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QlldkZDU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3976D14A82
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740066867; cv=none; b=mPwOCkEgNoNb54fag+fb2SLTFErAqe7Mrs4fzWsWu5riHlaBSAwkydgjsmxnC6PyY+AJ5LqsjkPayaZLHrJ6Sqq0lvZRVBw78ri/JWA5XKNf47JhOoqSDkC0sI21ZGh9omrsCiwYPufgq65EjSSLQzrtKdJL6888VX+HVKUfpCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740066867; c=relaxed/simple;
	bh=C8XAjohLsmNt3zsRasjqQzTOTHFo4T11QDu3NtDN+qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mn4FqG5rRngqAEr/Zh9pZzlsU0ena5x3+i6tZ4bIYpLUJNQl0k32+b4SSEk3QzUYcgtcWaqLxBPlARS83wUDczmjz5XNizfkFs6KBnyw60Cd1hpcwyVRk4GA1+WhaBVh3jdHWhbTjj/+DUYENRR+gNOhBdmCC5EVmuTbmvwFFXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=QlldkZDU; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4399a1eada3so9641745e9.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 07:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1740066863; x=1740671663; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NGNRf0ReiaPdK/EevU1+7Jg4AAbm107WpQnKn2mTvz0=;
        b=QlldkZDUHONJHTq1zBsgdvxPYQFJUNsK1UEaklAM/NR91YjO4ZLoir/A7wR1MQcpxY
         tRurwtKrqnIX40Ng3wWHiJaCPoWfiDAqYBsVbFslMNOFfTpY2Owi6onDCEhYJrQmRneS
         mqkCKVvrM03x9cU71fm+poQTvs2IpI6kcFnLAfnLjoPaG/WlTjmZyszb8nukc38kxBek
         NdWtFg4DQWG8+sMxIO6nE+HDLs2d8UoMu6cbcxRW2iaj3HW4J/12GbKf/r9UcHEiGICF
         kDCBUHN9iR1vlZTap9llgUMDkMwr8JUHijzcAQyBObNDobAPjLbCo6zgIECmLqy6aooP
         7Qww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740066863; x=1740671663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGNRf0ReiaPdK/EevU1+7Jg4AAbm107WpQnKn2mTvz0=;
        b=ntQZ0wjQ+S/d+fL9vrbgQMtLzmMe0w8//inPHbhDNnD7/Ink3zxlFEL4nyl+8L8/K4
         CR9svHlsNVULam5i/zDnXphCe2Bkso8BRpkn5XVpgsCQsg17ILQtS/bYLFLPUf5KId/8
         kQVb+KUpKuE6+FOKZLB85FfzKnYdXHrB4DsmpNS9mJSY3VU20zDdnQ6XApIb4hSqjg4d
         f/DvmMGC3uVEax7/bZi4TzHXxNgsK7xtyUOy/oKjEJGCuDyF8pLgBV1cSawKa3ltk5hi
         0b6Xei+QW4VL0kT4jQPHKNATAuw780RQ3tr6d9ygfgtgS4/OIETQ7iXbZjZ1F3kM9nT/
         RaxA==
X-Gm-Message-State: AOJu0YzVj898A/ap8t7XgfUIk91pzS+WgY3u/r2EgfBakyg6jldTns4O
	RnmuNBvA07aQaATbkLWc1BL57BG/Q6PxRK2gJ+GZ+kuPe1JKjA5IIinEMMG6ewA=
X-Gm-Gg: ASbGncvply+zDlMnitOedOzxG3aeZmjLEsquPuYRfSOUHOqwIA/t1DBS56Nd579Rp7N
	Anj2HEXUyxv8NaTJ25ab1KoHuDDVWUITU1wAWNEHv3JKmPlFG2vwuIvyCsw9wv8O05YWVViyE5J
	hdPPQzEiqtDG/7yuvcsiUIO0IV7SsuvVxkqr36H+Zb9Wv3fs2RPuA3s5UAnMc8ujlyKZPn59EE3
	EK5MDcgTaxG7wpKgTifDWrOc+U0QZCJNzPzmiVJ5NKtOYLDrjeCv+v2OtxvYhWbXYgZGdJV9Q5p
	qec=
X-Google-Smtp-Source: AGHT+IH4fqTjkvhr0HHpOydyGRkDW++RxVC/fTe8tk+RbOSjRT8wGHnhH2c8wiUThy0+JlbRpY5IRQ==
X-Received: by 2002:a05:600c:4691:b0:439:88bb:d02f with SMTP id 5b1f17b1804b1-43999d7563emr94560285e9.5.1740066863484;
        Thu, 20 Feb 2025 07:54:23 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d5e9esm21338889f8f.61.2025.02.20.07.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 07:54:22 -0800 (PST)
Date: Thu, 20 Feb 2025 16:54:22 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: [PATCH] RISC-V: KVM: Fix comments in
 kvm_riscv_vcpu_isa_disable_allowed
Message-ID: <20250220-69956156f8489f179d3ed97d@orel>
References: <20250220074905.29014-1-duchao@eswincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220074905.29014-1-duchao@eswincomputing.com>

On Thu, Feb 20, 2025 at 07:49:05AM +0000, Chao Du wrote:
> The comments for EXT_SVADE are opposite with the codes. Fix it to avoid
> confusion.
> 
> Signed-off-by: Chao Du <duchao@eswincomputing.com>
> ---
>  arch/riscv/kvm/vcpu_onereg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index f6d27b59c641..6df41794e346 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -203,7 +203,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_SVADE:
>  		/*
>  		 * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero.
> -		 * Svade is not allowed to disable when the platform use Svade.
> +		 * Svade is allowed to disable when the platform use Svade.
>  		 */

It was correct (but confusing) before this change. When
arch_has_hw_pte_young() returns true, that means we can use
SVADU (which is !SVADE). If we don't have SVADU, then we must
be using SVADE, and therefore can't disable it.

How about

/*
 * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero.
 * Svade can't be disabled unless we support Svadu.
 */

Thanks,
drew

>  		return arch_has_hw_pte_young();
>  	default:
> -- 
> 2.34.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

