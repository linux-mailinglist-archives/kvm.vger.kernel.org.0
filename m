Return-Path: <kvm+bounces-3646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE90806334
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 01:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1452B1F21759
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 00:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5442336F;
	Wed,  6 Dec 2023 00:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SFRwWQDX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752691A2
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 16:10:00 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da04776a869so4009475276.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 16:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701821399; x=1702426199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9/6P2wyn6Tp4auG0R2mfgrmmsVCBDCHzfDL1PUHTUpE=;
        b=SFRwWQDXqmdZQTYEauTFevPCgZKE6s4AtWvtQtVQuQM4J2vObpEtmH7eL8cRgYIfJk
         563Jy/8pxYO2FLrDmPIHNobYpnEWOH436hxodfp55uSCaEOWEZf92zdeecccHQgStMBj
         9Tvnytrz/0Q78udyc5KZja/JKUd5rg37SwT/g0Vu6JaHQyMhruPQAOoAUYGeS3/6ix6l
         kwfjhJRzJBAMDXPFCDygvQk1XN8wQfD5PvHxoFFlu+lfaYGsdQh3TsJQbhi7+Ei7Z6j2
         LYQ/++PkzR/WziJz3CBg8TZcaYgWN/SnQYCHP2DtMKYGj0Q3IAlhIFN19vrBTjyolkY2
         YLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701821399; x=1702426199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9/6P2wyn6Tp4auG0R2mfgrmmsVCBDCHzfDL1PUHTUpE=;
        b=l1jqG+8ODBMJygFR3XBHfo/9zfUDzjBeL1gQvm7u4olbAzDbgYQlC24svs14vyEeBI
         MaVCt0Rj/DFOHmywY6IXYeAL0IzG4Cm/JgpdxKN81D6suxgDiAyduILNSsiJiywBknMF
         qWojCiAYsK7jRPFlWV5eblw4N8Kxo5ipTgavHKuZouMl5SeESdxaOzI9t9FaHX+wElKv
         Na8/aSrTdyIZ79SjuAyuV9FrvnvjDtQHZcQE2bzpVli3q+v315ccMAw8bAeYPC5OqE/j
         0Ex6IxwJAef4YDGJDXKu5eVONcXkeN1Cp8QIyGboWiQMq25LvQK7VnsGQV2dQmSZImcP
         BI1Q==
X-Gm-Message-State: AOJu0Yw0CmSJk8shpAuiCVuThdgZ3dpjit4ibi3+G/212LD61Cbh+ubE
	oZq+dXUbikrs3ImSQXQkgvUWBoGTmC0=
X-Google-Smtp-Source: AGHT+IH4C4oAQE3PPjBrAx5GHXCbwzyXQ/CRPUBNvUMevnTM9O0XpfBdd0lSzsjL0Gpcy4iEwVPPe7hEN58=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d401:0:b0:db5:47bd:8b14 with SMTP id
 m1-20020a25d401000000b00db547bd8b14mr364391ybf.4.1701821399697; Tue, 05 Dec
 2023 16:09:59 -0800 (PST)
Date: Tue, 5 Dec 2023 16:09:58 -0800
In-Reply-To: <edbacce0-cbff-4351-be00-9cf7bf300864@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231204074535.9567-1-likexu@tencent.com> <ZW32geNb18p9ibrR@google.com>
 <edbacce0-cbff-4351-be00-9cf7bf300864@gmail.com>
Message-ID: <ZW-71hINZPdposgb@google.com>
Subject: Re: [PATCH] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 05, 2023, Like Xu wrote:
> On 4/12/2023 11:55 pm, Sean Christopherson wrote:
> > On Mon, Dec 04, 2023, Like Xu wrote:
> > > From: Like Xu <likexu@tencent.com>
> > > 
> > > Explicitly checking the source of external interrupt is indeed NMI and not
> > > other types in the kvm_arch_pmi_in_guest(), which prevents perf-kvm false
> > > positive samples generated after vm-exit but before kvm_before_interrupt()
> > > from being incorrectly labelled as guest samples:
> > 
> > ...
> > 
> > > Fixes: 73cd107b9685 ("KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu variable")
> > 
> > The behavior is deliberate, and was added by commit dd60d217062f ("KVM: x86: Fix
> > perf timer mode IP reporting").  *If* we want to undo that, then the best "fix"
> > would be to effective reverting that commit by dropping the IRQ usage of
> > kvm_before_interrupt() and renaming the helpers kvm_{before,after}_nmi().  But
> > my understanding is that the behavior is necessary for select PMU usage.
> 
> Thanks for your comment. Yes, the commit dd60d217062f should be tracked.
> 
> We don't have to undo the commit, and we also don't want to hurt
> either of the perf/core use cases (including perf NMI and timer modes).
> 
> Thanks to the introduction of "enum kvm_intr_type", we can cover both cases
> instead of sacrificing one of two modes, how about:

Hmm, yeah, that should work.  It's not the prettiest thing, but I don't see an
easy way to remedy that (I tried).  False positives are still possible, but it's
a clear improvement over what we have.

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c8c7e2475a18..5db607a564c6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1868,8 +1868,16 @@ static inline int
> kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
>  }
>  #endif /* CONFIG_HYPERV */
> 
> +enum kvm_intr_type {
> +	/* Values are arbitrary, but must be non-zero. */
> +	KVM_HANDLING_IRQ = 1,
> +	KVM_HANDLING_NMI,
> +};
> +
> +/* Linux always use NMI for PMU. */
>  #define kvm_arch_pmi_in_guest(vcpu) \
> -	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> +	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
> +	 (in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
> 
>  void __init kvm_mmu_x86_module_init(void);
>  int kvm_mmu_vendor_module_init(void);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2f7e19166658..4dc38092d599 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -431,12 +431,6 @@ static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
>  	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
>  }
> 
> -enum kvm_intr_type {
> -	/* Values are arbitrary, but must be non-zero. */
> -	KVM_HANDLING_IRQ = 1,
> -	KVM_HANDLING_NMI,
> -};
> -
>  static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
>  						 enum kvm_intr_type intr)
>  {
> -- 
> 2.43.0
> 
> I noticed that timer mode is used when perf-record uses SW events like
> "cpu-clock" event,
> with or without hw-PMU support. My side of the tests no longer show false
> positives and
> the above diff does not affect the use of perf timer mode as well. Any better move ?

