Return-Path: <kvm+bounces-55220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0697AB2E964
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 02:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83AA13AD9EA
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 00:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A66E1BD035;
	Thu, 21 Aug 2025 00:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ETWmkSM3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224A94430
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 00:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755735890; cv=none; b=F8u+ni+2WSSWI7+yzZN95vXpEHwjmu60NLZt6/B98ILsVuNRimvb+NPXI+Lic1AlQ1odsXQ5fh1kQMSvrX6ClwEEyZQbG3UDn2YxDX01I5XSpwsNTI1TmcVGUvSij4OUoSIOv8cpG2mM6zKdID6qzvKDumctDhHy0IMKnrD/m5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755735890; c=relaxed/simple;
	bh=ouPE6xmkeY4aYQfvv2K7TkBNeEwsezMGqf/BRWSZoPs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H8ai0krr3wSxlOlM9tDs2TI12t4UF7JCNPvx7R7lcBs5tuA7x6g0fasI5fTpCATO8z6+YzLVUYyXagdtLh0357v1pMdFhL2ZCfQ83NOqcip3lRJkBvIxNgndiBGirXrCkENN/hNWNR1V0c7nJjh6Q1sJQ/2OZqRN83PaM5cGvzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ETWmkSM3; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47173a00e8so287672a12.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 17:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755735888; x=1756340688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZzV/mlBPnS2GvNCCcjdoQhPKlsDEhZV19xDyokbadQ=;
        b=ETWmkSM3knew4jCVH5G/fPdTKIBoZPqAKOp1jVsLLTS0e2/BZ4V5YLnRpgRcEGC3An
         P1gUy79f15N77K7IKol4EnaGluQdn8tJ0e+Rif0Hx8+iReWYWWECl22VzBVXACg/vB7f
         bcC8Q2b2aL+NN6KfS87k5IxuHc6L24yf9Al3W6jMZQAsn04+rwdoJurIjqMwoqrxkirT
         XQn9VebrZ9vOdeINiczPltkmuMjQHDmaHXxudDnffiehMoDq3ZiIIL9dKKOgkbgAYa7F
         mg5NwwA+BY1n97BgL6SQ59xEFtiCcHT/FyASMo8qn+gMFOX6pDJtO+LIAGxvlShIKYko
         E7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755735888; x=1756340688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZzV/mlBPnS2GvNCCcjdoQhPKlsDEhZV19xDyokbadQ=;
        b=o64WfSEfhoZv5rii93urOZbZvs/4ar+Tu1cJJvqyQaJQvqdgaedcbPlKmMTFag2pKs
         ohy8scycIm2k/gLypMuEGFIdxXhaNdOhQLZ6fLZIbXJiiu+EfXZFidDMQJWpCe61dsUb
         goRZPvKBhSm7SG/6ltScwzbqqAnu7NBA7VjxrQ8YBsGRpTqE9c6DhbtxRJKHkG019EVZ
         5pDgPzlUrjz0BT6vXua/ZzqSvwjdxoTq2Yku0gPkRPVIWhTCfs+O6J9yQNBRaFnRp/11
         U/ilD+Oz6AyHiU16sCR+omADtxm9UppQP5OROvlTDTQxIw84Ff1TAS/1NLo+aQiYDuQ/
         WI3g==
X-Forwarded-Encrypted: i=1; AJvYcCXC+UyZ2uqThd7Can2eCgZ3Ei5RYJJMrp8bRBYbB64OxXW2Atafnew+L1aG8RjZ4jZFfQk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz2kvwXAT5NGT6PbMJW5C2k2ymgsjQVwKvBft/3vUjzSirB/e1
	Syws74uRpZ02RIX6aaPr5juvr8pVki1mcxnsydpgLt5RhRWc0Uy5pUouds1PNWWZEKcM4P15XeP
	yWt9Zyg==
X-Google-Smtp-Source: AGHT+IGbcGjNVYeJAsxCM13+2V27BLrczzbABDW//9tJzxcoTaUWncDgkTlsyuUrUapckiQp+ahpmhndqtk=
X-Received: from pfbfd5.prod.google.com ([2002:a05:6a00:2e85:b0:76e:313a:6f90])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2591:b0:243:78a:827b
 with SMTP id adf61e73a8af0-24330b47cd1mr462519637.51.1755735888381; Wed, 20
 Aug 2025 17:24:48 -0700 (PDT)
Date: Wed, 20 Aug 2025 17:24:47 -0700
In-Reply-To: <20250722055030.3126772-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250722055030.3126772-1-suleiman@google.com> <20250722055030.3126772-2-suleiman@google.com>
Message-ID: <aKZnT_57aPWfrfia@google.com>
Subject: Re: [PATCH v8 1/3] KVM: x86: Advance guest TSC after deep suspend.
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	John Stultz <jstultz@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, Suleiman Souhlal wrote:
> Try to advance guest TSC to current time after suspend when the host
> TSCs went backwards.
> 
> This makes the behavior consistent between suspends where host TSC
> resets and suspends where it doesn't, such as suspend-to-idle, where
> in the former case if the host TSC resets, the guests' would
> previously be "frozen" due to KVM's backwards TSC prevention, while
> in the latter case they would advance.

Before you waste too much time reading through the various pieces of feedback...

I'm leaning towards scrapping this patch.  I still like the idea, but making it
do the right thing given all the edge cases and caveats with TSC management in
KVM seems practically impossible.  E.g. as you called out in an earlier version,
fast-forwarding to "now" is probably undesirable if a vCPU's TSC was completel
disassociated from "now" and/or arch.kvmclock_offset.

We could probably figure out ways to cobble together a solution that works for
most situations, but given that no one is clamoring for KVM to operate this way,
I doubt it'd be worth the effort and complexity.  And it certainly isn't worth
taking on the risk of breaking an existing setup/user.

For the suspend steal time angle, a PV feature bit means both the host and the
guest need to opt-in.  A host opt-in means we can punt to documentation, e.g.
we can document that there are caveats with running VMs across deep suspend, and
the user should consider whether or not they care before enable suspend steal time.

And then if someone really wants KVM to fast-forward time (or comes up with a
simple solution), they can have honor of figuring out how to do so correctly for
all of the crazy TSC flows.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++
>  arch/x86/kvm/x86.c              | 49 ++++++++++++++++++++++++++++++++-
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fb01e456b624..e57d51e9f2be 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1415,6 +1415,9 @@ struct kvm_arch {
>  	u64 cur_tsc_offset;
>  	u64 cur_tsc_generation;
>  	int nr_vcpus_matched_tsc;
> +#ifdef CONFIG_X86_64
> +	bool host_was_suspended;

Adding an #idfef to save a single bool isn't worth it, especially since it
necessitates a wrapper (or more #ifdefs).  For something like this, I'd just
set it unconditionally, and then esentially ignore it for 32-bit, along with a
comment explaining why we can't do anything useful for 32-bit.

> +#endif
>  
>  	u32 default_tsc_khz;
>  	bool user_set_tsc;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a9d992d5652f..422c7fcc5d83 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2779,7 +2779,7 @@ static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
>  	kvm_vcpu_write_tsc_offset(vcpu, tsc_offset + adjustment);
>  }
>  
> -static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
> +static inline void __adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
>  {
>  	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_caps.default_tsc_scaling_ratio)
>  		WARN_ON(adjustment < 0);
> @@ -4995,6 +4995,52 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
>  
>  static DEFINE_PER_CPU(struct kvm_vcpu *, last_vcpu);
>  
> +#ifdef CONFIG_X86_64
> +static void kvm_set_host_was_suspended(struct kvm *kvm)
> +{
> +	kvm->arch.host_was_suspended = true;
> +}
> +
> +static void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, u64 adj)
> +{
> +	unsigned long flags;
> +	struct kvm *kvm;
> +	bool advance;
> +	u64 kernel_ns, l1_tsc, offset, tsc_now;
> +
> +	kvm = vcpu->kvm;
> +	advance = kvm_get_time_and_clockread(&kernel_ns, &tsc_now);
> +	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
> +	/*
> +	 * Advance the guest's TSC to current time instead of only preventing
> +	 * it from going backwards, while making sure all the vCPUs use the
> +	 * same offset.
> +	 */
> +	if (kvm->arch.host_was_suspended && advance) {
> +		l1_tsc = nsec_to_cycles(vcpu,
> +					kvm->arch.kvmclock_offset + kernel_ns);
> +		offset = kvm_compute_l1_tsc_offset(vcpu, l1_tsc);

This is where my idea really falls apart.  For this to be correct, KVM would need
to know the relationship between a vCPU's TSC offset and kvmclock_offset.  The
simplest thing would likely be to do something like force an update if and only
if TSCs are matched across all vCPUs, but trying to reason about how that would
work when vCPUs account for the suspend time at different and arbitrary times
makes my head hurt.

One idea I might fiddle with is to snapshot get_kvmclock_base_ns() on suspend
and then grab it again on resume, and use _that_ delta for tsc_offset_adjustment.
But that's something that can be pursued separately (if at all; I don't see any
reason to gate suspend steal time on it.

