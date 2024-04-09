Return-Path: <kvm+bounces-14031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E13689E5B9
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E13F71F22B7A
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 22:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ECB2158A2B;
	Tue,  9 Apr 2024 22:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F+hrzrIM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB55433A6
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 22:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712702672; cv=none; b=EmECQ3lLmxBTce1W7Ms4tn2/6xrHIyv7YlTSRC/ckwcBJwB5rVQcAYgV7xvgAwdsjhsSDCg9JH9LOY+M/fe/Qa0TR8abAwLrgcGkiwG6UiJfqDfs+MGSQ+sVcKmw8vOpxRZExs55rADUpOEeKIvWr8bIibZ+EaBRYF1XzC5KPhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712702672; c=relaxed/simple;
	bh=qM29SkS5o2wfxy/5l80wfNAUyeavrf9BVcVfOkwKY/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EoLPdRdYhmG840TOfEpJWio28mQgBHLMln+BoG5nir7+53gQVkr179RAnw1MStFXcJVjLPBz9SlTrix8xKpZsYKWoYDkgLtr8vp5YoScVyvM/QnWvL9Ygd5KpoVRW5zuzvMS3pSay+umdwUTVTGnWSGHKzQaHn7UemLMBu4VlDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F+hrzrIM; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dcbb769a71so5743593a12.3
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 15:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712702670; x=1713307470; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VH/UmEChwdyjZ/9aT/KUw9UQuyTiVzbfxn08LZ7BSrg=;
        b=F+hrzrIMEmIjOUFkZ6ZVcVr5JXxky0YNQdgOq5afSG96mrISa3+Gxr3Sk3pt5c9EfR
         VTQvM+ZzukcxDfhA96gIGdvmxs2kK2h/RbuYV0Mp8Wdx4u6UCnMSbqyluvBtRE2wIJw2
         IyICzio9zBT5jmPWYqPs3N6yTWzC9JsWhzluRWtmO3kbwQuRB0ySZ+0S8otGZxX+BNwe
         A77oELbn6y5PLF0QQrnCn7CPsePSW4a1BlYgq4WQ19cCVtDLRWQf7SoniYQIUs9kN/+K
         LgmlcGjAnVGUTiUpuuITYtNoJnPx1bMORk7lIvFlcg1ZSKkOnqs4trkSaEAkburWmQ1s
         srog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712702670; x=1713307470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VH/UmEChwdyjZ/9aT/KUw9UQuyTiVzbfxn08LZ7BSrg=;
        b=BeYbpp5deyUGnBCP0T5v3VDRj31Rt27n8GR0nFDZ4f5ihyc1ikKErSklv0c2d98N77
         KpyQ25/Ga4sJvWjTIl9/V8y1gBWm+1giYjAYGJiycp8B/pk2TMKvmFGCQDEpqjWQh8Dc
         cTnzuJ7DMWddazEqpOyhwN8W3GjKOUjVWt2YqoR+jxnJAaf08lUYLiygf/cZmktCMacR
         Ivd4W0gG44sGO9kI6QcMu7XPvf32AlLa+WYZPc/+iEyaO9oKwZ8lbsdI6UpVSLUZlGG8
         X/vnPE6QNudX6T4NnIUCWwW7deTbls77K6kLl7qWYvEefHriFHcQuQf74YSUKmqbkZiE
         brJg==
X-Forwarded-Encrypted: i=1; AJvYcCVkODAe5HUM8XYg75w/97XfMChsY/KYfr1GGQynJ+GXJ1en7MaTf+JDPpDFy5jtRpqn5zR9+i5B4JoMhjeriPT2Wy6x
X-Gm-Message-State: AOJu0YxpNjL4GKjSYl6RCdNinJqjKGg8nuFx2te/IQr0OjPYTnewPQPY
	QdShU7Dui/NV4o95d0Y9nw38IE4309xQn34V6LhPD0aTreM+CkTjv961pPf5UU+0vTHn2yefHLt
	bYw==
X-Google-Smtp-Source: AGHT+IEKcTUQbJF7HcWLxaLFN0XfKlKXAruCoVy4SPhA/1+pHY/GIZSslF6K8fw3dj5zJXbZ707++dbd2JI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5c88:0:b0:5dc:14c9:64aa with SMTP id
 a8-20020a655c88000000b005dc14c964aamr2813pgt.3.1712702670100; Tue, 09 Apr
 2024 15:44:30 -0700 (PDT)
Date: Tue, 9 Apr 2024 15:44:28 -0700
In-Reply-To: <20240215235405.368539-5-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-5-amoorthy@google.com>
Message-ID: <ZhXEzACz-Z2ruLaT@google.com>
Subject: Re: [PATCH v7 04/14] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
> KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
> duplicate the "if (writable)" block. Fix this by bringing all
> kvm_is_error_hva() cases under one conditional.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7186d301d617..67ca580a18c5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3031,15 +3031,13 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>  	if (hva)
>  		*hva = addr;
>  
> -	if (addr == KVM_HVA_ERR_RO_BAD) {
> -		if (writable)
> -			*writable = false;
> -		return KVM_PFN_ERR_RO_FAULT;
> -	}
> -
>  	if (kvm_is_error_hva(addr)) {
>  		if (writable)
>  			*writable = false;
> +
> +		if (addr == KVM_HVA_ERR_RO_BAD)
> +			return KVM_PFN_ERR_RO_FAULT;
> +
>  		return KVM_PFN_NOSLOT;

This would be a good use of a ternary operator, e.g. to make it super obvious
that "if (kvm_is_error_hva(addr))" is terminal in all cases.  I'll fixup when
applying.

>  	}
>  
> -- 
> 2.44.0.rc0.258.g7320e95886-goog
> 

