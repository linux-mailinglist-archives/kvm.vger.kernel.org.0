Return-Path: <kvm+bounces-26551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 590FC97575B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5D4F1F24469
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3011AC458;
	Wed, 11 Sep 2024 15:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3/TJgaXR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5389219F108
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726069298; cv=none; b=JmN1Ai8+oZrbUeirWPE70GiehZhXORIQxvoXrDqcaiViEyYBbtRaIAlvYxzE9H0uOHF+rk3lJygC8u1nb4dOl7ra2NUjzI9UY3KCP+kC5HQdhNarmkuqtCT9pA6xsgTVBquZiTTy3S94oI4opCRVaZkgoUdkTGaKg5ug5aRh2FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726069298; c=relaxed/simple;
	bh=W+tiD1V/X/8R+/g/FQpft47xq5xPlYobfuaHr6OTIXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bgd8D9OjsGbDhUV627dnUoVCYObuFGeWRDDsuyC2WPtmkoRmjXwglrCj+bm/eX3HxgXLslA4oV/Iw0frLTtD/4SL/IQCYoseW2dgMeScrDSWvjVW6wCBH0EVrhgZL2n01RK5d7X1GZZYNTjy81+fsWh6svnr6ytHQzlrI+LUHo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3/TJgaXR; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-717dfdd7c72so8121218b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726069296; x=1726674096; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MrHdXt7JrpjjUmNFGMd/v0CPNQfs3OQgNDJ0sdafxQA=;
        b=3/TJgaXRapFAmpEpFNVFO4wLa+FeGLmvmDIaMjuurQdzq0KX1p8gnpQum1hpW/jiav
         muLVO+2qpm6g8Se9iSvxCn6MRwCQ/GXllQIGNS0PNMkvYzPiIQXdYECIFv+tkKfU5FDM
         cnK6QZTPmWuZ0LBiMjBZJU9A0tv+f1uxmL98e/UfC+URyamZj8pk4pUdrI9qE8dk+4Jz
         Qt2aNpKZLDKVuKpXBkECjT6/7TkVNIQeL1FQVZNb/WZYm2xBRdyBrFds9GIzPRmKE0Bj
         HGGj7ybYIma0PyaUibwduRTtA8XY98PGuiGALnm9CZ0K3o97xUhCXhPY6eE5FbiSqJ5W
         A40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726069296; x=1726674096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MrHdXt7JrpjjUmNFGMd/v0CPNQfs3OQgNDJ0sdafxQA=;
        b=tdNCcBEWtK7zzVOrdke1YSI6XdyXJHxuhPeX0gh/TUqv1XO007mtib508Hb2Q8P1iB
         ABhtR8TBZEK9XsqG2biYPMeKZaUDcEXPg0D/OSwX6/fHwggg9WGgYomRsA3r5NQs9U6M
         NVnXQqrkfCR+XQ47Puw+2rwCNbU/9ARiBeMyCr2dGptDneR5spmxReulgbdKDXvzA54F
         7YStBohqraSYwH2myZtwzm9XvClA/rl7ZISwnfI+8b3bqurp44assjjZkKCymF6httgZ
         eEHR4p5Ad0XBfTuEPmXHMgfMf8izrYH9XzeNQtPBUJqSniDY7FVi4rEQbyp2basLA+ci
         1bAg==
X-Forwarded-Encrypted: i=1; AJvYcCV6lkm1j3P3ha9NAXJTyQq3G2kUCfyLIhXgv0Q4nuLN/7pcR+m+C373Q3Q4dyG6DSMnpU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD/ZieDqgLw4o0jMyaVsCw2+CCTi0oC8BqHavmdj+8DKd09p4L
	+QvbP0xvEMcpkCkmHPm9sn0Br+iHouisSb2y0fwWg3KRCizP4vj3TM+uTE5P7loMaeUd+5DhjvN
	NIA==
X-Google-Smtp-Source: AGHT+IEHOhSB3DGvNEb+fdf89QVvK15AW99bpbRa1rQ/AYagpH+uE8Q8G9twq+/is6tH9A9baDGBHZMmwxU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:90c7:0:b0:718:d528:7423 with SMTP id
 d2e1a72fcca58-718d5e09cccmr43282b3a.2.1726069296465; Wed, 11 Sep 2024
 08:41:36 -0700 (PDT)
Date: Wed, 11 Sep 2024 08:41:34 -0700
In-Reply-To: <b9cf0083783b32fd92edb4805a20a843a09af6fc.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-45-seanjc@google.com>
 <2d554577722d30605ecd0f920f4777129fff3951.camel@redhat.com>
 <ZoyDTJ3nb_MQ38nW@google.com> <b9cf0083783b32fd92edb4805a20a843a09af6fc.camel@redhat.com>
Message-ID: <ZuG6LqLA6tGw9Edi@google.com>
Subject: Re: [PATCH v2 44/49] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> On Mon, 2024-07-08 at 17:24 -0700, Sean Christopherson wrote:
> > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > > -		cpuid_entry_change(best, X86_FEATURE_OSPKE,
> > > > -				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> > > > +		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSPKE,
> > > > +					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> > > > +
> > > >  
> > > >  	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
> > > >  	if (best)
> > > 
> > > I am not 100% sure that we need to do this.
> > > 
> > > Runtime cpuid changes are a hack that Intel did back then, due to various
> > > reasons, These changes don't really change the feature set that CPU supports,
> > > but merly as you like to say 'massage' the output of the CPUID instruction to
> > > make the unmodified OS happy usually.
> > > 
> > > Thus it feels to me that CPU caps should not include the dynamic features,
> > > and neither KVM should use the value of these as a source for truth, but
> > > rather the underlying source of the truth (e.g CR4).
> > > 
> > > But if you insist, I don't really have a very strong reason to object this.
> > 
> > FWIW, I think I agree that CR4 should be the source of truth, but it's largely a
> > moot point because KVM doesn't actually check OSXSAVE or OSPKE, as KVM never
> > emulates the relevant instructions.  So for those, it's indeed not strictly
> > necessary.
> > 
> > Unfortunately, KVM has established ABI for checking X86_FEATURE_MWAIT when
> > "emulating" MONITOR and MWAIT, i.e. KVM can't use vcpu->arch.ia32_misc_enable_msr
> > as the source of truth.
> 
> Can you elaborate on this? Can you give me an example of the ABI?

Writes to MSR_IA32_MISC_ENABLE are guarded with a quirk:

		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
		    ((old_val ^ data)  & MSR_IA32_MISC_ENABLE_MWAIT)) {
			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
				return 1;
			vcpu->arch.ia32_misc_enable_msr = data;
			kvm_update_cpuid_runtime(vcpu);
		} else {
			vcpu->arch.ia32_misc_enable_msr = data;
		}

as is enforcement of #UD on MONITOR/MWAIT.

  static int kvm_emulate_monitor_mwait(struct kvm_vcpu *vcpu, const char *insn)
  {
	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS) &&
	    !guest_cpuid_has(vcpu, X86_FEATURE_MWAIT))
		return kvm_handle_invalid_op(vcpu);

	pr_warn_once("%s instruction emulated as NOP!\n", insn);
	return kvm_emulate_as_nop(vcpu);
  }

If KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT is enabled but KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS
is _disabled_, then KVM's ABI is to honor X86_FEATURE_MWAIT regardless of what
is in vcpu->arch.ia32_misc_enable_msr (because userspace owns X86_FEATURE_MWAIT
in that scenario).

