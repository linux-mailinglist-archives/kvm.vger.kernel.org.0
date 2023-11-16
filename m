Return-Path: <kvm+bounces-1890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C3C7EE929
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 23:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A488B1C20A6F
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 22:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE70358AB;
	Thu, 16 Nov 2023 22:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lNO544Zy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0800C93
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 14:19:13 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9a541b720aso1790453276.0
        for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 14:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700173152; x=1700777952; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fl6pks/5nXHIxwnkpgKQp0jBSB1m9Szr34Vwe0okSLc=;
        b=lNO544ZyxyuljkS8Anwl0VfYeICczJBJk4fOhNyerjGF+q79/cGChsn+XdyL9jlwZr
         7QHvAWlBjEKVj//flGE3y8s3yzymPGeWLX0wMZhNiaOgF+8L5vWI090PrqRlHknuB4IW
         KdirP4xIjnM+0CIb/BgR2YRq9GMMDmZB6Y9HQKTU9u5Ofm6uclyL+4vCJHoHLDErGe6m
         HGZzvRVnq71XNdRRin/dfmTncjX3uFn0kcp5ko/PtKCSfGJ1yKH4VHBB9Ggf3lA+qLIS
         IJBIUiV/p0Q+XIKlZ7tOC5mDg9MljbTNDkGqVSau527ui8ER0J6roLEorDgeWzVMk9zj
         UdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700173152; x=1700777952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fl6pks/5nXHIxwnkpgKQp0jBSB1m9Szr34Vwe0okSLc=;
        b=LMvdN+dITKnZXh73X0QwHSf1CFiDrNOPzIty6H+rTBUmUJS5/zY4ARZJ8fdE43NnsU
         nFXsvbWfOiYcDsEUDZcB/wfVvkJ8yPQpKyLU8g4PLG4ybU9elQldOqPG759GsIapWLWx
         eDIo3zHsACWzBHx2AL2DRiBCRpnjZs2K9rCTl0EpVcalwZQ3k7yqLeDbf43Ji00auCKc
         MKHXVpQHy6NvnkmjnbRT6yg631w32hVdtLXGzNq2+Mh2AH4Z7KIbRCxXdDazmcp9iAZr
         IOgRLYh9PqgJENKb0S28YakOv0HRul7D5QUHVoTK/l2HLOMZuz21X81lkJ4ebUBTs1tQ
         7vaA==
X-Gm-Message-State: AOJu0YwHVNZdb4zPMjv0xCQwP4J8WuzlXNA/zOIkP5NNjZdbVrUn1yC+
	ojXT9fBt38Bm9+03vjMWlNRFAFVVYDY=
X-Google-Smtp-Source: AGHT+IEqo0jiu8MtHkcdfWCPlttWfKv9BaFWX/gYTmABVC5zf10/TpE+l8r8f8rYCLUPVsOPCyTcKVQo0Do=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dcc3:0:b0:d9a:4fb2:16a2 with SMTP id
 y186-20020a25dcc3000000b00d9a4fb216a2mr400823ybe.12.1700173152181; Thu, 16
 Nov 2023 14:19:12 -0800 (PST)
Date: Thu, 16 Nov 2023 14:19:10 -0800
In-Reply-To: <bc2534fe-ade3-496e-a1be-bb2196fb2003@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com> <20231110235528.1561679-7-seanjc@google.com>
 <bc2534fe-ade3-496e-a1be-bb2196fb2003@intel.com>
Message-ID: <ZVaVXtKU1nxjFkrw@google.com>
Subject: Re: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
From: Sean Christopherson <seanjc@google.com>
To: Weijiang Yang <weijiang.yang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 16, 2023, Weijiang Yang wrote:
> On 11/11/2023 7:55 AM, Sean Christopherson wrote:
> >   static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
> >   				       int nent)
> >   {
> >   	struct kvm_cpuid_entry2 *best;
> > +	struct kvm_vcpu *caps = vcpu;
> > +
> > +	/*
> > +	 * Don't update vCPU capabilities if KVM is updating CPUID entries that
> > +	 * are coming in from userspace!
> > +	 */
> > +	if (entries != vcpu->arch.cpuid_entries)
> > +		caps = NULL;
> 
> Nit, why here we use caps instead of vcpu? Looks a bit weird.

See my response to Robert: https://lore.kernel.org/all/9395d416-cc5c-536d-641e-ffd971b682d1@gmail.com

> >   	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> > -	if (best) {
> > -		/* Update OSXSAVE bit */
> > -		if (boot_cpu_has(X86_FEATURE_XSAVE))
> > -			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> > +
> > +	if (boot_cpu_has(X86_FEATURE_XSAVE))
> > +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSXSAVE,
> >   					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
> > -		cpuid_entry_change(best, X86_FEATURE_APIC,
> > -			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> > +	kvm_update_feature_runtime(caps, best, X86_FEATURE_APIC,
> > +				   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> > -		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> > -			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> > -					   vcpu->arch.ia32_misc_enable_msr &
> > -					   MSR_IA32_MISC_ENABLE_MWAIT);
> > -	}
> > +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> > +		kvm_update_feature_runtime(caps, best, X86_FEATURE_MWAIT,
> > +					   vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT);
> 
> > 80 characters?

Hmm, yeah, I suppose.

