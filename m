Return-Path: <kvm+bounces-47156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 643EEABE073
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8A94189EAFD
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4393728315E;
	Tue, 20 May 2025 16:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jLQZTfnu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D50C283142
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 16:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747757750; cv=none; b=FpgNe2NNX08buo3a/pIpR45M4/UtcpNcZw+5luyuHkeb5iBuy+iQMsaG30EdxyG0q63BWRm4FDoj9jXzN3oa96rQBSZc9c319se/uBuTpCRDuPXUGH5Ek6dJJhtuxTdhILytID61G/hRj/GsDjjIxAdqGgPXnahWD20iSM9KSEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747757750; c=relaxed/simple;
	bh=+Vcw99hArJNg96u9C+1xlSH1x7gl3AusJncKN9s2FM8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=p/gkglPIUEoVbNyP3ez9zFh5q0nWktGrvKcyu7wAFIx5HtZkfmjm1VrqD6FuhgbmIu7psqWIZrb/fddmkuWloyOAmPGYMcSxyugC0KghW3uTSHxRxUl2LLx0ShyFcXxXZBKp71jSuXuC93qOr7XipIWPJQp50ruisVjPt9ys04o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jLQZTfnu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e74ee960aso4519470a91.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 09:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747757748; x=1748362548; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bZGR3h8ZXjmEa2GSMvAS+bskJuHQ62fc+lc2T3EMCe8=;
        b=jLQZTfnuHDUJ8TIB5y/9OFJwvlV5qOS7cXrKOcTIIE/hC4UAaRHBvEzPrgCCOHCz/L
         pmb3vv8ujSdYolXXXKckOFTHji7lYbpkWOa4Hf8GrR35d7YSaWgNJhDvG+YzNZyLeQc0
         D+2jXn5MaDXCjpZX3hcUloEGj+cVQozqxBcw0+GR9Gzv4OlZfzzokILHRvDSovVhc//E
         6jsBxqOnnzxQxKNkWkECnIbNW2QbXRQUEcQhGyfwt3acaI1O8Ff/ihBMwwONkrzUus/7
         VLX0YypBFm76/R5TklOGWsR2gVpXeHRoUk+Kd+0dHxnRFj5F7w+SVgkJvy45UG+t87Ge
         OZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747757748; x=1748362548;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bZGR3h8ZXjmEa2GSMvAS+bskJuHQ62fc+lc2T3EMCe8=;
        b=IX7a53VahlbtHrzVFAz/hJI+WBRb0ivR9Pa6RzPZeu/7Z1FIiGugqnPkEOzLKv0jvy
         0xZFtbvlOwg7FCjXU0ngrMtauBoZ8+PxT7Qdph5v3GoHrAjPTmW+Dk3K9s+E68tFwIe8
         s6riaAnJAqZmntmc7F/FQkexemGUU27wPm3G9X+nKOHQIyMCfdGzcTZC/TDdp1jqzWYp
         m9eI7b4sTBxRc734kgxm4InJd+YxpS6fAbE5QL7aInJu+BG7D3R1YRPtEaYRLPFDYWb7
         Zu62FZmqeecxdSeuMpNflqDhkbL1KAyD8T7SBnbcdlptQ63UIEI9isC9QyXnItlAt6Ri
         PMOg==
X-Forwarded-Encrypted: i=1; AJvYcCXiUOYfeMYO0RksdImgd1ezwoCzUM6M9gc1Vxy53YR1pJAq9nW7aMHyv5KNPVYVwklY0bc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlDiR0+tOwZ+wT4/HgPwpXsdCe8bTXz53TUfxsuHlgU0vnmfFo
	NJ70vvn05IqobsFtqEdjCvEIvS84w5D4WGv8HtbkoIXBuIUDrRG/mZOMlO7/HY/urZAjupxPiU7
	JElR22A==
X-Google-Smtp-Source: AGHT+IEOGvM3znTeHBFpGt+G8+/5jz10loCWHUqdckQa0FPVp/EK8lWGYjsG7vLyd1Y+UJ5BtLugpTJwv5E=
X-Received: from pjp15.prod.google.com ([2002:a17:90b:55cf:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcd:b0:2fa:13d9:39c
 with SMTP id 98e67ed59e1d1-30e83121243mr27086604a91.14.1747757748369; Tue, 20
 May 2025 09:15:48 -0700 (PDT)
Date: Tue, 20 May 2025 09:15:47 -0700
In-Reply-To: <20250516215422.2550669-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com> <20250516215422.2550669-3-seanjc@google.com>
Message-ID: <aCyqs4VdPsw4mA_F@google.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 16, 2025, Sean Christopherson wrote:
> +/*
> + * Assert that "struct kvm_{svm,vmx,tdx}" is an order-0 or order-1 allocation.
> + * Spilling over to an order-2 allocation isn't fundamentally problematic, but
> + * isn't expected to happen in the foreseeable future (O(years)).  Assert that
> + * the size is an order-0 allocation when ignoring the memslot hash tables, to
> + * help detect and debug unexpected size increases.
> + */
> +#define KVM_SANITY_CHECK_VM_STRUCT_SIZE(x)						\
> +do {											\
> +	BUILD_BUG_ON(get_order(sizeof(struct x) - SIZE_OF_MEMSLOTS_HASHTABLE) &&	\
> +		     !IS_ENABLED(CONFIG_DEBUG_KERNEL) && !IS_ENABLED(CONFIG_KASAN));	\
> +	BUILD_BUG_ON(get_order(sizeof(struct x)) < 2 &&					\

Ugh, I jinxed myself.  My severe ineptitude and inability to test persists.  I
inverted this check, it should be:

		     get_order(sizeof(struct x)) >= 2

> +		     !IS_ENABLED(CONFIG_DEBUG_KERNEL) && !IS_ENABLED(CONFIG_KASAN));	\
> +} while (0)
> +
>  #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
>  ({									\
>  	bool failed = (consistency_check);				\
> -- 
> 2.49.0.1112.g889b7c5bd8-goog
> 

