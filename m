Return-Path: <kvm+bounces-25408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E919650A9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 22:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEBEF1F22095
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 20:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47C21BAEDD;
	Thu, 29 Aug 2024 20:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KFvgWyfG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7591C1BAEC6
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 20:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724962711; cv=none; b=NFQDhOdkjzLiW5DfYeNuNOVuvPnxxcIyQTilAOtepet7Hc9lNvUACUP+zlaKSKaHjxGWypUZwPh2vorGAJUmBXXvErnAAiI12OAMUvos1wYxmETO6qLCi9GhUJRtHu6yr2t68B7LXZQLdyLLUWiXQvlGqNRZ8zxj4hoj3dU6ZrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724962711; c=relaxed/simple;
	bh=gWZDX2yB/LRVevbJYJAmyipmeTu7Crz6O/4RZ1n2yNw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FCvV55V+5tH1revYUkt1yqocBnKm/OyQ9kpVanZh8TLcJJPvfB8eyRnUWv8tsRxqvJ22dr+FZu6ZiZGxOJr9H3kt3hGTpf1eS6kVizF0ljuEX9qvzWaTAByDRi5TCWendgQ8Jm0ruWhGDSbyhIKcatgq73rAfVkrJr655Rq0OgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KFvgWyfG; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e13cfd506b8so1760951276.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 13:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724962709; x=1725567509; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xp+nUWa7e3H9z7YXgjztwQOeCXL6SgtH037N9HE8+a8=;
        b=KFvgWyfG8c3iIGnKl/6UaxSTFyKWkqoO/nzaYxTmYl0uHrrDRRZKN4XNuQmfxWwsgw
         IB9xeOVFHUFzsOhmD6ASIBJ5w+X4GXPb6cLjxxSkVktJYDZPW2Ce48uL2wD2TkQ36wmM
         s3S5mU8JEk0WtPhRp0du4o1AkykFDLFKXPaqp+pt6X6gxaR9/w5UaqPjClfSHbEq4v15
         2xibPl78GP+UI2j+UP5v5M81YHVxxhzfvkkEJz1V1ajcfcyxSMEuiM3wjECSlpnA6vSb
         rDaofpM0Y4Vabq8eFofQA8aLob5/VRAni09bKilQL68FHPTNTEGOn6qtIuIB3+ADEUvJ
         hKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724962709; x=1725567509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xp+nUWa7e3H9z7YXgjztwQOeCXL6SgtH037N9HE8+a8=;
        b=PNcIE9nSLg54xTCJRbj5mBr4rWnW+ldVZQ9KhCzFkPgeLQRgnonYCdwo4Fvn8Yn+xa
         ckeyNDKTHwh2VqmBnk2YpKaOWoq7NDx747wpP3Nhm/gSh0lT5V2hK63AqczV6tCUL7WM
         +o9+wpaN3j026rAkCr44MwSAJCYW8KV8Z2QIehk0wmA7iyCPESpq8qg0O2eGQ4a0uYxj
         9dCsIXxpEWjYZtvsm+HQZoy8jAlfljG6laRvrjenZ2iJ4ICL8X1sLsOu9JJMv9higSnq
         uhzjno+aknTMD4uLBQeeIXyZN+zOyYVAQmcZMbz55zvTLnZL7c9k86E3swAPJ/yTygIH
         binQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVxbMxn8mofxvIqUtoB786PqUbdyOGHYph44IS7YywhaCbT0V6O4GIQ7A7ZSZDiYHYicc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN0uqRHp6MrVwV4l9jNK8WlJjvmap8KSUAi26UV+O5f+60OC6O
	j2iAGl7GE+6qs8Trers9I6sPJ+Eu85jygXoQnBWey8kuU39f4Q7OMtl6sACLI/HJRSOElowo+Pa
	rBg==
X-Google-Smtp-Source: AGHT+IGxLbIhfuqYDQioPCPEOkolNsROz1Gi6Rdvmdjoei6tLD1VnRlcfB7/z+Ib5bQ9Ont+AQs+mc72u2w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4986:0:b0:e16:6d88:b8c2 with SMTP id
 3f1490d57ef6-e1a7a00db26mr7276.4.1724962709044; Thu, 29 Aug 2024 13:18:29
 -0700 (PDT)
Date: Thu, 29 Aug 2024 13:18:27 -0700
In-Reply-To: <20240829191135.2041489-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240829191135.2041489-1-vipinsh@google.com> <20240829191135.2041489-2-vipinsh@google.com>
Message-ID: <ZtDXQ6oeQrb8LxkX@google.com>
Subject: Re: [PATCH v2 1/4] KVM: x86/mmu: Track TDP MMU NX huge pages separately
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 29, 2024, Vipin Sharma wrote:
> @@ -871,8 +871,17 @@ void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  		return;
>  
>  	++kvm->stat.nx_lpage_splits;
> -	list_add_tail(&sp->possible_nx_huge_page_link,
> -		      &kvm->arch.possible_nx_huge_pages);
> +	if (is_tdp_mmu_page(sp)) {
> +#ifdef CONFIG_X86_64
> +		++kvm->arch.tdp_mmu_possible_nx_huge_pages_count;
> +		list_add_tail(&sp->possible_nx_huge_page_link,
> +			      &kvm->arch.tdp_mmu_possible_nx_huge_pages);
> +#endif

Pass in the count+list, that way there's no #ifdef and no weird questions for
what happens if the impossible happens (is_tdp_mmu_page() on 32-bit KVM).

void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
				 u64 *nr_pages, struct list_head *pages)
{
	/*
	 * If it's possible to replace the shadow page with an NX huge page,
	 * i.e. if the shadow page is the only thing currently preventing KVM
	 * from using a huge page, add the shadow page to the list of "to be
	 * zapped for NX recovery" pages.  Note, the shadow page can already be
	 * on the list if KVM is reusing an existing shadow page, i.e. if KVM
	 * links a shadow page at multiple points.
	 */
	if (!list_empty(&sp->possible_nx_huge_page_link))
		return;

	++kvm->stat.nx_lpage_splits;
	++(*nr_pages);
	list_add_tail(&sp->possible_nx_huge_page_link, pages);
}

> +	} else {
> +		++kvm->arch.possible_nx_huge_pages_count;
> +		list_add_tail(&sp->possible_nx_huge_page_link,
> +			      &kvm->arch.possible_nx_huge_pages);
> +	}
>  }
>  
>  static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> @@ -906,6 +915,13 @@ void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  		return;
>  
>  	--kvm->stat.nx_lpage_splits;
> +	if (is_tdp_mmu_page(sp)) {
> +#ifdef CONFIG_X86_64
> +		--kvm->arch.tdp_mmu_possible_nx_huge_pages_count;
> +#endif
> +	} else {
> +		--kvm->arch.possible_nx_huge_pages_count;
> +	}

Same thing here.  Only tweak to my proposed API in patch 4 is that it needs to
take nr_pages as a pointer.  Then it can simply pass those along to this helper.

>  	list_del_init(&sp->possible_nx_huge_page_link);
>  }

