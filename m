Return-Path: <kvm+bounces-63754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DCCFDC7137D
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 23:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 771F429E11
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 22:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93D0305948;
	Wed, 19 Nov 2025 22:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3CWiI2n/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3FF220698
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 22:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763589907; cv=none; b=AjP7ZDl0DHR84zS7bOFsWo8uI6JYgQKNDIH7TC6at8FGW02Lcx4zqkgnPo/EnMbI5q9U5cAnkmeJJPvrgof9AmGRVJFSYq7V+iBzULKF4a1CNLUtBUb2qARiNGlDGE85PRtw3x2JEIE6r94cxoBv/3YcMyyFC+1ZXPxANxnD4us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763589907; c=relaxed/simple;
	bh=v//uOr2tHb8dcjd8beHYgnv1kgNWrlfObycDOhed1Go=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DUgMRp4SN35Zoth78B/PrOOFvBgcVIIKzv5VUfaOcig/ZONPXM67a+zzzkIw16fcR6DiWE1kFRsZrEv70yXx0YSaFB6Fnge+GetYRhqV7SGg+pU2TqWsfTtRJffW7yVMh7t2gNERwMXveQ9aB2AD60TdiCuymic1vmVorjN1kgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3CWiI2n/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436e9e3569so320087a91.2
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 14:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763589906; x=1764194706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sWB7b7gK6U7hKIAe1hY9O5TYN/81WKTU25YszuIj9Y0=;
        b=3CWiI2n/6HOPhuRGR+u1MStufqyDs0x6xSqRhQ5NGKVxVYzKwOcdZ0qAyWYGZZ4+5L
         VtmzVA/T/Y0eZS4G20Mu6Mx/SMdtN2NShhPqroBu+jhif5kT0+RPJ251w0epm7J1Qu/7
         AdoiL0KJT/E4FacQINPK+cjkyZ/ikambyeOHvedujdqD9LXpWsLIyUVKuNkWwaHB8Ub+
         8hGH2v9d6PJB2Lzf5hYbLu8lmCiVNgwa8bNEHc54PAlkCCBn93FKi6O6R/McYWtkrjqm
         JcIEaR71HsjFBxr8O7YpMlbiAQEAen3+CcJqisEv4iKch4kkS4xGE1J12IOm0fBSBV9J
         wkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763589906; x=1764194706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sWB7b7gK6U7hKIAe1hY9O5TYN/81WKTU25YszuIj9Y0=;
        b=bPEx4KeNswrIGJnQ3qfHE4NtcOUuJMZwyyKq8r938IcBqblN850YoV7RB+3hxbMjWW
         2b4OXslTy1vx6YCqUEukkJQIzho0m/BBUSCd/vwZ01cgZBsDWJSuTm5c3iqDnSkac5GL
         ybuUeYkg/fMjzdigHm5gknSaJysZgReVH0g2o6np1mZJ82nGup8mC6IpwzIb3pWakChA
         omAQDOImkjRtKLyZ3W/PejTSt0CtTFP6+AsOlh50Zw21C9c0kcGRFIZdDoi0Go4TAwmr
         YTxXphBesksdaD/k6nxQki47DEgT3IxW3aTIZuNyNRdUdaoQ9i4x/7lwMaZSgR7ta4eg
         xqZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxaLMM6tfiQkvpfGHNRmtDvKkucCVeFy8ademOU1GX+1tydlog65Qd34Q9jhBuO2nsPM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiKerU+jIdddWmt7WxOTFKWx4Ao0u/dTNQ3sRxf5/A3k0oVMnf
	h63vN+P70tMakfComkOMhy1zjAtmlTRO1b62nbVar/EFWoEbFSE1Q2Ubc5U51+OycKfpIVPF2Xe
	lQBnCow==
X-Google-Smtp-Source: AGHT+IGXXe2mly3I9lTqRU7DTze6Hy00otxS9GrKuAXQF5ObAvA8SksetaJS6WQra0+gzJ6P5IIGDOGM8jw=
X-Received: from pjbpd13.prod.google.com ([2002:a17:90b:1dcd:b0:341:8b58:bbce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:558c:b0:340:d578:f299
 with SMTP id 98e67ed59e1d1-34728368940mr563956a91.3.1763589905749; Wed, 19
 Nov 2025 14:05:05 -0800 (PST)
Date: Wed, 19 Nov 2025 14:05:04 -0800
In-Reply-To: <60f7c9b3-312f-41e2-ab47-c4361df1d825@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com> <20251113225621.1688428-7-seanjc@google.com>
 <60f7c9b3-312f-41e2-ab47-c4361df1d825@redhat.com>
Message-ID: <aR4_EM5bWKSQ4iOS@google.com>
Subject: Re: [PATCH 6/9] KVM: SVM: Filter out 64-bit exit codes when invoking
 exit handlers on bare metal
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Sat, Nov 15, 2025, Paolo Bonzini wrote:
> On 11/13/25 23:56, Sean Christopherson wrote:
> > Explicitly filter out 64-bit exit codes when invoking exit handlers, as
> > svm_exit_handlers[] will never be sized with entries that use bits 63:32.
> > 
> > Processing the non-failing exit code as a 32-bit value will allow tracking
> > exit_code as a single 64-bit value (which it is, architecturally).  This
> > will also allow hardening KVM against Spectre-like attacks without needing
> > to do silly things to avoid build failures on 32-bit kernels
> > (array_index_nospec() rightly asserts that the index fits in an "unsigned
> > long").
> > 
> > Omit the check when running as a VM, as KVM has historically failed to set
> > bits 63:32 appropriately when synthesizing VM-Exits, i.e. KVM could get
> > false positives when running as a VM on an older, broken KVM/kernel.  From
> > a functional perspective, omitting the check is "fine", as any unwanted
> > collision between e.g. VMEXIT_INVALID and a 32-bit exit code will be
> > fatal to KVM-on-KVM regardless of what KVM-as-L1 does.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++--
> >   1 file changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 202a4d8088a2..3b05476296d0 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3433,8 +3433,22 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
> >   		sev_free_decrypted_vmsa(vcpu, save);
> >   }
> > -int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
> > +int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 __exit_code)
> >   {
> > +	u32 exit_code = __exit_code;
> > +
> > +	/*
> > +	 * SVM uses negative values, i.e. 64-bit values, to indicate that VMRUN
> > +	 * failed.  Report all such errors to userspace (note, VMEXIT_INVALID,
> > +	 * a.k.a. SVM_EXIT_ERR, is special cased by svm_handle_exit()).  Skip
> > +	 * the check when running as a VM, as KVM has historically left garbage
> > +	 * in bits 63:32, i.e. running KVM-on-KVM would hit false positives if
> > +	 * the underlying kernel is buggy.
> > +	 */
> > +	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR) &&
> > +	    (u64)exit_code != __exit_code)
> > +		goto unexpected_vmexit;
> 
> I reviewed the series and it looks good, but with respect to this patch and
> patch 8, is it really worth it?  While there is a possibility that code
> 0x00000000ffffffff is used, or that any high 32-bit values other than
> all-zeros or all-ones are used, they'd be presumably enabled by some control
> bits in the VMCB or some paravirt thing in the hypervisor.

Maybe.  E.g. TDCALL and SEAMCALL VM-Exits on Intel show up without any enablement
in software (beyond VMXON).  I completely agree that it's extremely unlikely that
AMD will add a on-negative exit code with bits 63:32 != 0, i.e. that we could get
a false positive when truncating exit_code to a u32, but it also seems harmless
to be paranoid.

FWIW, I was assuming VMEXIT_INVALID_PMC (-4) was a generic vPMU thing, but it
looks like that one is also SEV-ES+ specific.

As for e57b84699534 ("KVM: SVM: Limit incorrect check on SVM_EXIT_ERR to running
as a VM"), I agree that being paranoid probably doesn't do anything in practice,
but I like being consistent. :-)

> What really matters is that SEV-ES's kvm_get_cached_sw_exit_code() is
> reading the full 64 bits and discarding invalid codes before reaching
> svm_invoke_exit_handler().

No?  sev_handle_vmgexit() only handles SVM_VMGEXIT_xxx exit codes, everything
else is punted to svm_invoke_exit_handler()

	exit_code = kvm_get_cached_sw_exit_code(control);
	switch (exit_code) {
	case SVM_VMGEXIT_<0>
	...
	case SVM_VMGEXIT_<N>
	default:
		ret = svm_invoke_exit_handler(vcpu, exit_code);
	}

And I don't see anything that filters/modifies exit_code_hi.

