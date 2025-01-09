Return-Path: <kvm+bounces-34935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE5BA08065
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB5BB168D2B
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE531FAC4E;
	Thu,  9 Jan 2025 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WlXOPkDx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DC61922ED
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736449270; cv=none; b=Z/F+0TzA0I7ZipkmX3VMvGnaIQWdvJ56LYM8PWJd2T/b5Jg1lje8RK+jbp4LC7NlDFjxrOeMLvsxYGyPyRaAgIfV78VkBk9yZfYuNNJdKeQV4R2UY+qUcb2LXB/Lpjhaoj4QHFazf5WVPm9FpGmWlFK0y/GcqlhldlF1E+Op9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736449270; c=relaxed/simple;
	bh=0Wqndvrw6Ac797CYqWAX1cSbrSIBep0LKHDXmfAwv3g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fhUxEfvYqOSk/juwEi7+Wq5T/fMb7Y+k6IV7W7lHL/nol/FDbgkvxjwJKfExvJPv4dfVlTKtU6w5CXnZhnkDz78rVel1XMqm2M6bHJG61r/YHFRc7noIq7IDC+aRErtOwTdsJ0GLKaXwbn10suOuRcF5bdHgSARNB9TL9ojetFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WlXOPkDx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2eeeb5b7022so2297736a91.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736449267; x=1737054067; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+HfpA5fbP7TfH76TZ3Uj5yQZsZSY/yn7fUa0meeoBcw=;
        b=WlXOPkDx2nNDuocuAGhSHirLQrhW/iMA0Q2KlM3HwPVgDWLP/m8ZYV668qKktvWCow
         xGgles4RpIrEj1rCieIV/AM76MKJN3wot7N+d6MQZ9YrVYlUUtDUuocOnrAadwpECU+R
         jjOuNKO0UVvbJ5LQDz39kPOKSYSXMCxn3E0d/K6SRUNSHZ4YaoB5XrAqmzu4K7fopLNe
         /NzG5QXv+MH01jkFavsNQW2eTY+EVTPOgErgD8g9O3QFa9fvk/rI0F5DHnIV5F4gQX2N
         BxJF63yvxpClJspuIQvXNYRrpYQnFr1XfnTCWuJoTxaZthxMB0gyHuWsCrh/6g32ALne
         4Oag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736449267; x=1737054067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+HfpA5fbP7TfH76TZ3Uj5yQZsZSY/yn7fUa0meeoBcw=;
        b=RItX6u/nig/GFP+nygPS/S31QPpdrlDpybt9l/9P+dLufqcXMiY0nxoU0WPblKpPuH
         2OFeS/3JpMGtUSw/CuvtlJ+LctvbSXegJ/ZOTmkTXaHo8PxjQ9w7daBv9Ivlx020tRQ0
         w9ZCzVVdiz2vW+FR1T55gcSzrwDU2X+ULF+L7CPaayx6oAJTBoaz1pFpt77qOJDjtIeO
         QNQUwVhxHeYCPtc++WUAw9XbMC0KhrHvvmnUdk8sI5Gi58MKM3TrCgvNdYUErLt4mCkO
         YkjxVvsTMCsvku1AFtExPNpIMmr56pAPfXPT15hV9xYMLRdlsKYNbX1/W63Ux78diroH
         K1zQ==
X-Forwarded-Encrypted: i=1; AJvYcCXo5JAuq7MM0pHDiNS4Dg8dUBy7hMYOfzJnWzDxv6aM/2j9NGL9gY8zQ/VRE4CsQCloDjU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxkN+oVGsmd8fWpy5mYjuZ80mMZ2rIDgbkh+cCd3gnpVgHIusI
	dua7bvYoj/BAVaD5H2EF9QzeOLOD/OznaKgM/4tgkWkgC4mE5yiqzta1Daymao5P0jXTv5adv5r
	yvw==
X-Google-Smtp-Source: AGHT+IEy+gndLs4E1tSPKEcp4HwCWd68h7GZr39HDdXY/jAdD+K43aJiHJRninKh3yqF1SWahOdjjhE3bz0=
X-Received: from pjbqb12.prod.google.com ([2002:a17:90b:280c:b0:2ef:9239:aab1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fc48:b0:2ef:e0bb:1ef2
 with SMTP id 98e67ed59e1d1-2f548ecc3a7mr10739900a91.19.1736449266829; Thu, 09
 Jan 2025 11:01:06 -0800 (PST)
Date: Thu, 9 Jan 2025 11:01:05 -0800
In-Reply-To: <20250109133817.314401-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109133817.314401-1-pbonzini@redhat.com> <20250109133817.314401-3-pbonzini@redhat.com>
Message-ID: <Z4Ac8Xw4ELtHGAHo@google.com>
Subject: Re: [PATCH 2/5] KVM: e500: use shadow TLB entry as witness for writability
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, oliver.upton@linux.dev, 
	Will Deacon <will@kernel.org>, Anup Patel <apatel@ventanamicro.com>, 
	Andrew Jones <ajones@ventanamicro.com>, linuxppc-dev@lists.ozlabs.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, Paolo Bonzini wrote:
> kvmppc_e500_ref_setup is returning whether the guest TLB entry is writable,
> which is than passed to kvm_release_faultin_page.  This makes little sense

s/than/then

> for two reasons: first, because the function sets up the private data for
> the page and the return value feels like it has been bolted on the side;
> second, because what really matters is whether the _shadow_ TLB entry is
> writable.  If it is not writable, the page can be released as non-dirty.
> Shift from using tlbe_is_writable(gtlbe) to doing the same check on
> the shadow TLB entry.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/powerpc/kvm/e500_mmu_host.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
> index 732335444d68..06e23c625be0 100644
> --- a/arch/powerpc/kvm/e500_mmu_host.c
> +++ b/arch/powerpc/kvm/e500_mmu_host.c
> @@ -242,7 +242,7 @@ static inline int tlbe_is_writable(struct kvm_book3e_206_tlb_entry *tlbe)
>  	return tlbe->mas7_3 & (MAS3_SW|MAS3_UW);
>  }
>  
> -static inline bool kvmppc_e500_ref_setup(struct tlbe_ref *ref,
> +static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
>  					 struct kvm_book3e_206_tlb_entry *gtlbe,
>  					 kvm_pfn_t pfn, unsigned int wimg)
>  {
> @@ -251,8 +251,6 @@ static inline bool kvmppc_e500_ref_setup(struct tlbe_ref *ref,
>  
>  	/* Use guest supplied MAS2_G and MAS2_E */
>  	ref->flags |= (gtlbe->mas2 & MAS2_ATTRIB_MASK) | wimg;
> -
> -	return tlbe_is_writable(gtlbe);
>  }
>  
>  static inline void kvmppc_e500_ref_release(struct tlbe_ref *ref)
> @@ -493,10 +491,11 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
>  			goto out;
>  		}
>  	}
> -	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
>  
> +	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
>  	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
>  				ref, gvaddr, stlbe);
> +	writable = tlbe_is_writable(stlbe);
>  
>  	/* Clear i-cache for new pages */
>  	kvmppc_mmu_flush_icache(pfn);
> -- 
> 2.47.1
> 

