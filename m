Return-Path: <kvm+bounces-16740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A6C8BD33C
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D32E41F264E2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93C2156F47;
	Mon,  6 May 2024 16:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v1tjfmHv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9740D156C69
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 16:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715014490; cv=none; b=Zw9o5bQi5vJBaMI20XMxw2BF1CtQUdcs8uetLnVtvtjjqAoJ7DEvhkxAJWfOCKJwtm4M/zdLbHCUokn9lsE/Vaki9LVMmVBl+VXL5eb3O11/3dqxYq54RNbsH4c6oZb44bqvGk9OZDf7cbJysCm4HSEJ9/ik2m6YdtWd+a6pNVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715014490; c=relaxed/simple;
	bh=YV70YhhV1rRenJW+J47TAVixYhKt6tnlxLJU4RuhfdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UQ8LJvonee8KpOdEMjY23DpImEj9BlOOr8PGc8kmRr9931guFytFyAi6v4ZTMdejpKljxRz3dD2xYKoNZ8d82JVm2Au8ML5qPkvRaEoYUtB7Pqck3iaEDbk31AXX9CCRZPvJtELRPc8XWS9+7NjfDLiz8YXvyfLNxnPei3fdyCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v1tjfmHv; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61bd64c9eadso40074237b3.3
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 09:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715014487; x=1715619287; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1q7kv4eiqfBXu87xL8Ycp/RG/MD0+b+6v2pcsNs/bQo=;
        b=v1tjfmHvIsUQXfNyYqvvFilz6D2hnpzzefTNm2j3ev3EM5Mow4Z3s7TqXLhgZX9cS9
         WIBA4W3kwSq3Zu52eQL9Y8Hm3Jjmyd1WvV3qBzxF8kndNC7/csD5lj4I8spfuBtajQEy
         2HFkN6CNagVRihIWhZKWAFL3kEFAm49Om4/wwV1PP/oI6+pN31x1GU5XVk+FpCopHiRL
         lTbTsca9VNnax0xVJz9lG4YhA/nvaFZ1FUgBbb58u0x7FIUoaNk3j37nIINri4C9e6e6
         fo8LfA/2hORCFbkAACK7LunRNds2evk4vwVQ5qGN4tjBgpb+ndQ91BEiNVd+kW+4DTFN
         aVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715014487; x=1715619287;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1q7kv4eiqfBXu87xL8Ycp/RG/MD0+b+6v2pcsNs/bQo=;
        b=LX3KnxwmacI5BGXbNhrEX0WyjdXi2SPXDzWLNhUipV9YozDp2N1EImhmY6qb1Pff7x
         9S7sqjNnxrcpis8Z4vUC4qRKhazxXjhwO0d4tXVLSSVlmzwAEvvIqhmXfRYTf7qIBhvO
         J95jeHmJc3uW5sKdqX36eYsr2IpEAy4W50UU88M5Ip588TCWjGewJzxkY1fTUOdzqma4
         n9HVHC1kvz41Zh8hZP0qAO8+CRLolj3mJsyP2UAe5ZL2a2PRh2JwveVi1sqhr+5Cp/GL
         bDYdI0oI2Ax8As29zXpiZgXPOVnIllfY2D1KvAkMUNvHJSnruqle5cRGtsZG1SEnjXfC
         lQUw==
X-Forwarded-Encrypted: i=1; AJvYcCVGK9/5U3V6/nFLrnvWcZ02ljysESOUhtZtmVzBlVaDuytBrman5odbEiwgUIooJxanApKZpCI0h9/OhdWxWLXUzolt
X-Gm-Message-State: AOJu0Yy+KZQivwtC0aSwwvbFf/7U0TeHZU/ZUmrYZbcIwgJlLqQfY5Y3
	cQ1Zn/f+e0kEXs+xxQVgb+zYnXU9GlAcouDzoOfE/HCo4TYypAEKVKRpl2IhXBXexd6kOsV9/BU
	A8A==
X-Google-Smtp-Source: AGHT+IHEw5neWA5Inlvhuc0btC99JrsPKumcht6Uc3OZryuwncKT9jonar0LZzd46QHHnpCHfXUGDD2kDm4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:52ca:0:b0:61b:e8a2:6f4b with SMTP id
 g193-20020a8152ca000000b0061be8a26f4bmr2879705ywb.1.1715014487705; Mon, 06
 May 2024 09:54:47 -0700 (PDT)
Date: Mon, 6 May 2024 09:54:46 -0700
In-Reply-To: <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com> <ZjLNEPwXwPFJ5HJ3@google.com>
 <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com>
Message-ID: <ZjkLVj01V4bM8z5c@google.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Weijiang Yang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 06, 2024, Weijiang Yang wrote:
> On 5/2/2024 7:15 AM, Sean Christopherson wrote:
> > On Sun, Feb 18, 2024, Yang Weijiang wrote:
> > > @@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
> > >   		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> > >   	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
> > >   		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> > > +	/*
> > > +	 * Don't use boot_cpu_has() to check availability of IBT because the
> > > +	 * feature bit is cleared in boot_cpu_data when ibt=off is applied
> > > +	 * in host cmdline.
> > I'm not convinced this is a good reason to diverge from the host kernel.  E.g.
> > PCID and many other features honor the host setup, I don't see what makes IBT
> > special.
> 
> This is mostly based on our user experience and the hypothesis for cloud
> computing: When we evolve host kernels, we constantly encounter issues when
> kernel IBT is on, so we have to disable kernel IBT by adding ibt=off. But we
> need to test the CET features in VM, if we just simply refer to host boot
> cpuid data, then IBT cannot be enabled in VM which makes CET features
> incomplete in guest.
> 
> I guess in cloud computing, it could run into similar dilemma. In this case,
> the tenant cannot benefit the feature just because of host SW problem.

Hmm, but such issues should be found before deploying a kernel to production.

The one scenario that comes to mind where I can see someone wanting to disable
IBT would be running a out-of-tree and/or third party module.

> I know currently KVM except LA57 always honors host feature configurations,
> but in CET case, there could be divergence wrt honoring host configuration as
> long as there's no quirk for the feature.
> 
> But I think the issue is still open for discussion...

I'm not totally opposed to the idea.

Somewhat off-topic, the existing LA57 code upon which the IBT check is based is
flawed, as it doesn't account for the max supported CPUID leaf.  On Intel CPUs,
that could result in a false positive due CPUID (stupidly) returning the value
of the last implemented CPUID leaf, no zeros.  In practice, it doesn't cause
problems because CPUID.0x7 has been supported since forever, but it's still a
bug.

Hmm, actually, __kvm_cpu_cap_mask() has the exact same bug.  And that's much less
theoretical, e.g. kvm_cpu_cap_init_kvm_defined() in particular is likely to cause
problems at some point.

And I really don't like that KVM open codes calls to cpuid_<reg>() for these
"raw" features.  One option would be to and helpers to change this:

	if (cpuid_edx(7) & F(IBT))
		kvm_cpu_cap_set(X86_FEATURE_IBT);

to this:

	if (raw_cpuid_has(X86_FEATURE_IBT))
		kvm_cpu_cap_set(X86_FEATURE_IBT);

but I think we can do better, and harden the CPUID code in the process.  If we
do kvm_cpu_cap_set() _before_ kvm_cpu_cap_mask(), then incorporating the raw host
CPUID will happen automagically, as __kvm_cpu_cap_mask() will clear bits that
aren't in host CPUID.

The most obvious approach would be to simply call kvm_cpu_cap_set() before
kvm_cpu_cap_mask(), but that's more than a bit confusing, and would open the door
for potential bugs due to calling kvm_cpu_cap_set() after kvm_cpu_cap_mask().
And detecting such bugs would be difficult, because there are features that KVM
fully emulates, i.e. _must_ be stuffed after kvm_cpu_cap_mask().

Instead of calling kvm_cpu_cap_set() directly, we can take advantage of the fact
that the F() maskes are fed into kvm_cpu_cap_mask(), i.e. are naturally processed
before the corresponding kvm_cpu_cap_mask().

If we add an array to track which capabilities have been initialized, then F()
can WARN on improper usage.  That would allow detecting bad "raw" usage, *and*
would detect (some) scenarios where a F() is fed into the wrong leaf, e.g. if
we added F(LA57) to CPUID_7_EDX instead of CPUID_7_ECX.

#define F(name)								\
({									\
	u32 __leaf = __feature_leaf(X86_FEATURE_##name);		\
									\
	BUILD_BUG_ON(__leaf >= ARRAY_SIZE(kvm_cpu_cap_initialized));	\
	WARN_ON_ONCE(kvm_cpu_cap_initialized[__leaf]);			\
									\
	feature_bit(name);						\
})

/*
 * Raw Feature - For features that KVM supports based purely on raw host CPUID,
 * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
 * Simply force set the feature in KVM's capabilities, raw CPUID support will
 * be factored in by kvm_cpu_cap_mask().
 */
#define RAW_F(name)						\
({								\
	kvm_cpu_cap_set(X86_FEATURE_##name);			\
	F(name);						\
})

Assuming testing doesn't poke a hole in my idea, I'll post a small series.

