Return-Path: <kvm+bounces-16448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 438E08BA3EA
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:21:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF57F1F24E88
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B851CF8B;
	Thu,  2 May 2024 23:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EMJVd0MR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4C1C2AD
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 23:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692103; cv=none; b=HMx9sO7oJlFTfXEJ0I+bWsmuNC3fjN3egWcTCFAQT87nG92Xhl4zFfCMUpuKbd4AMnwQW3ZfRn36jRI/unArRoax0oQzXYmHpX7N1pmLQLvhpcZOdKZHdi5XufVfukSsN/PL1qx5y5O2T66G/etMG4rOweH03e+dkFYV1foxnH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692103; c=relaxed/simple;
	bh=t0ocJHvY73hrUFCV06uFlb3wGHL2RVlZU9n1KTZ7hPY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dqkn7byg+Cv8OgRnJ++esvdj/DS9/gSMIgUjAD8wrOcYZlDyQMrj1n8E5f1uWe5Fh1reZix7neaxo9iciKzMIlf+d40OktgnrXHVfxvXQVX+kKXG+pSNpvOFPF0d5dX7h/bN6Ac5iVgx+8D3qgzb14QpoMJGU1/Rt68D6pW/kQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EMJVd0MR; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de0b4063e59so7617456276.3
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 16:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714692101; x=1715296901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s0bl+EXjP+FAcnnealSKe+UO8h20s3Bb2rwaSYi0ocI=;
        b=EMJVd0MRiJqm3UnPJGEkLl6LrggKvvFrfdAGX8rmY3ImBqu474OjktOA/hjEjlrmCX
         fmrBXGeIY2skkftEbxpfawAbf/qosKiXfyPX647e79Rokt/VDVig5oMnYAtx0DIBbmiq
         MAYNy63TJwTdOY/scvKX/Bdvb1imxiSiSVESqh18pD0oH2u8yVUjjFTHA+FXRO3dW7Et
         vjGPn4NKb3kblBfRW+R80b6viy+KWjyQ6GeRa/tgxL5WATN0l7C+m+BHHS4XHonnPKDX
         LnFxrp9LNrzPsERkfVyIvpbL0v4qGpL5O7qsjGnu++R9octd9DZ/21MQUrdEsmveCjMs
         s9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714692101; x=1715296901;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0bl+EXjP+FAcnnealSKe+UO8h20s3Bb2rwaSYi0ocI=;
        b=D7XjAXzJBPfIyUHnvmHsZvq5ESiqpLjPUfy5WzKgAerwpoonv4E4gOTIzM41r8FFBu
         KgwBoyPr6DoafgEjYeEuyRjnkcOYrCXRzQtExTRc4kqotiDqbbkOq/KD5cCbdm0WjQcv
         asneYIsARZt9r2AWzubne59y4uu+y9YpXn24Tx/LmvKwOH0a7bmkEWv56NNz5/+Q/CEG
         bf1StmFn4Yp0JsljiXZboy4Xv/EDzUBroplqbfJZj9f6J3KDUxhpzDGOyF6Fuz7Y8VEk
         lbXXuclLOjY3HClPa9uzmwwnrqBUos9wdmht9Bafi9foVxxL8iZfakF3UmDrAgIxCFP4
         miCA==
X-Gm-Message-State: AOJu0YyJflxu7Iiir4hYhqoBBpob7Dn7YboT592dHGcR4In1YkzKePFN
	tbfDShzOJbyLR+zEjRMXmfhwI50IXtQ59kCdgewEdKUoID9Ky1Cxbzyh5kpPMcHkJUzFPZ8BuM0
	20Q==
X-Google-Smtp-Source: AGHT+IHjDGmpaXVSoAwTIzLen1vuSbxCgrToQC/Icn+sgd/CbVo8NnwSTKIPPZRYPCvB6poyTUeH1apk8qc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b83:b0:dd1:390a:51e8 with SMTP id
 fj3-20020a0569022b8300b00dd1390a51e8mr368460ybb.10.1714692101128; Thu, 02 May
 2024 16:21:41 -0700 (PDT)
Date: Thu, 2 May 2024 16:21:39 -0700
In-Reply-To: <20240418021823.1275276-2-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240418021823.1275276-1-alejandro.j.jimenez@oracle.com> <20240418021823.1275276-2-alejandro.j.jimenez@oracle.com>
Message-ID: <ZjQgA0ml4-mRJC-e@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: Only set APICV_INHIBIT_REASON_ABSENT if
 APICv is enabled
From: Sean Christopherson <seanjc@google.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 18, 2024, Alejandro Jimenez wrote:
> Use the APICv enablement status to determine if APICV_INHIBIT_REASON_ABSENT
> needs to be set, instead of unconditionally setting the reason during
> initialization.
> 
> Specifically, in cases where AVIC is disabled via module parameter or lack
> of hardware support, unconditionally setting an inhibit reason due to the
> absence of an in-kernel local APIC can lead to a scenario where the reason
> incorrectly remains set after a local APIC has been created by either
> KVM_CREATE_IRQCHIP or the enabling of KVM_CAP_IRQCHIP_SPLIT. This is
> because the helpers in charge of removing the inhibit return early if
> enable_apicv is not true, and therefore the bit remains set.
> 
> This leads to confusion as to the cause why APICv is not active, since an
> incorrect reason will be reported by tracepoints and/or a debugging tool
> that examines the currently set inhibit reasons.
> 
> Fixes: ef8b4b720368 ("KVM: ensure APICv is considered inactive if there is no APIC")
> Co-developed-by: Sean Christopherson <seanjc@google.com>

Heh, no need, I just provided review feedback.

> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> ---
>  arch/x86/kvm/x86.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 26288ca05364..09052ff5a9a0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9995,15 +9995,14 @@ static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
>  
>  static void kvm_apicv_init(struct kvm *kvm)
>  {
> -	unsigned long *inhibits = &kvm->arch.apicv_inhibit_reasons;
> +	enum kvm_apicv_inhibit reason = enable_apicv ?
> +						APICV_INHIBIT_REASON_ABSENT :
> +						APICV_INHIBIT_REASON_DISABLE;

Just let this poke out, the 80 char limit is a soft limit, where "soft" is fairly
"hard" in KVM", but there are still legitimate situations where running past 80
is yields more readable code, and IMO this is one of them.

> -	init_rwsem(&kvm->arch.apicv_update_lock);
> -
> -	set_or_clear_apicv_inhibit(inhibits, APICV_INHIBIT_REASON_ABSENT, true);
> +	set_or_clear_apicv_inhibit(&kvm->arch.apicv_inhibit_reasons, reason,
> +				   true);

Same here.

No need for a v3, I'll fixup when applying.

>  
> -	if (!enable_apicv)
> -		set_or_clear_apicv_inhibit(inhibits,
> -					   APICV_INHIBIT_REASON_DISABLE, true);
> +	init_rwsem(&kvm->arch.apicv_update_lock);
>  }
>  
>  static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
> -- 
> 2.39.3
> 

