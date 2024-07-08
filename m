Return-Path: <kvm+bounces-21133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DC392AB32
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 23:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E42BC28304A
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 21:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5118F15098F;
	Mon,  8 Jul 2024 21:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k+8sMvi6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAF514F9E2
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 21:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720474173; cv=none; b=s1ywX/71cv/oYatLwhBgZHSY2U6XqtgFtbVyh6TXFx0A56mYcHm6qM0koH22cDff5ijQ8OiIrmK3SEnyzMe0zwyB7bLAUuBz9twzjftq+r7G+zdFcAWZdBcZzyvp/cBg0sbtWClUFVBmuX3b59xnHlTqvDl1uiDs7tLNaT627II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720474173; c=relaxed/simple;
	bh=fA11Z8zia3cYlXaiPSOq5f069nsBdPqCXu/1Ho4jXU4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i6/ktbrn9oNLSDHwS3Y4I2S7BmxTayPMHY1HKnnUwL2mmYS5IUsp1MscxlwXE5qQg2KvXfOI7JoF/xPrWsKjVh+Nyj69Ga4b6ZSrj/KjWL7zrTarTH+6ThKdewuKFLMlG2kg84SA68QdoAEG8a7Aw69UFY9S+KI5luqlGD5SpHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k+8sMvi6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-778702b9f8fso712596a12.1
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 14:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720474171; x=1721078971; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pjlku0FbMtchabcksUiJW3MsyZp4/0PZpvNArF9ea54=;
        b=k+8sMvi601ulz6ajR7b5lwZWHDPdfQilTu2o0P2ENj7sq60Vf5TDdazK0nP9fFWJUq
         rBwnTZAg3LZdfWjQlASyOK4f2sMKF+vVNf1XZKQG7/qVNNjY9IbcwZwN1THVYwwOfPsE
         pgZ9+4t0hlkVYVeR+WLPpdhGn1j03bIAV7Qpgk+/FrM/a4FjQCq0mhDmjjkSIHt7VXut
         MDzzG5rsWPe09MCi0FFgpAoS3rkm16XPV/z+/oTmHCmrT9owon6Z3U4oFxnO/UGp5p0T
         oCyxYbsOq0JeBcissGMsw6S290F4fZWIQlqHcNX7C5vSyrB9U4NBVZ3QstIRS7XuDfI/
         xcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720474171; x=1721078971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pjlku0FbMtchabcksUiJW3MsyZp4/0PZpvNArF9ea54=;
        b=KTQ6h5nxfnCHx5Mcor96Bk60Iaz4yRFCZH/0qs4wOGUDyGVEREigncNdyy/bD9abkk
         OX8pGpfYBJV1arrwZYs9HfaJWk8a94kWDalkEu0jyXrFrVdQ4FYP1aqFDTfL+iOSxgy0
         PwoMDwPF6x92Cjj52CxMSg4ADwbvtLb0JfwNMacy1/0Eeij1irr2aNohzsCSdfZwIJ/A
         8EVaPwnU6Rgh3sSRBKOANSdfGK46ilVlZlUGWHN6CyAGzlcrVpils+bLIvYS31pEIYA0
         Ou6VzJ0QxDyPkHQ9aslRozPTOWkRvZbi0MPOowAsn32F9jvdJ04Og7Mwi7ZkjfuHzokH
         /WWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZhTAry/2/SppDW5w0Slf9NoCnDKsE6oUUHbwrvVbBc35GvxsEGhhdMoFM64u92a7oHqAel0G3COKDIAAjX+HRiVin
X-Gm-Message-State: AOJu0Yy+PKWopIGCeHuAaB/bnNeBEM8PD/1F396mFMpLYSEDFVyD2+kP
	PAVyHuC7HaiU42ZaHkukf+vUbm1aMlrF1AIXBJqR+p4d9anKZLvu3GwDpk72YqXgpx8RkK4H+uL
	j9w==
X-Google-Smtp-Source: AGHT+IGV+aBzDxPjpTlMW3iophRE8faoTHQHg2Cqx4AlKd5i3aqVIA4PBMPjvg5BvxW9yF/qznp78BsBuzA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6882:0:b0:6e3:a2ac:efd4 with SMTP id
 41be03b00d2f7-77e05b86503mr965a12.6.1720474171307; Mon, 08 Jul 2024 14:29:31
 -0700 (PDT)
Date: Mon, 8 Jul 2024 14:29:30 -0700
In-Reply-To: <20d3017a8dd54b345104bf2e5cb888a22a1e0a53.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-25-seanjc@google.com>
 <20d3017a8dd54b345104bf2e5cb888a22a1e0a53.camel@redhat.com>
Message-ID: <ZoxaOqvXzTH6O64D@google.com>
Subject: Re: [PATCH v2 24/49] KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to
 avoid macro collisions
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > Undefine SPEC_CTRL_SSBD, which is #defined by msr-index.h to represent the
> > enable flag in MSR_IA32_SPEC_CTRL, to avoid issues with the macro being
> > unpacked into its raw value when passed to KVM's F() macro.  This will
> > allow using multiple layers of macros in F() and friends, e.g. to harden
> > against incorrect usage of F().
> > 
> > No functional change intended (cpuid.c doesn't consume SPEC_CTRL_SSBD).
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 8efffd48cdf1..a16d6e070c11 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -639,6 +639,12 @@ static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
> >  	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
> >  }
> >  
> > +/*
> > + * Undefine the MSR bit macro to avoid token concatenation issues when
> > + * processing X86_FEATURE_SPEC_CTRL_SSBD.
> > + */
> > +#undef SPEC_CTRL_SSBD
> > +
> >  void kvm_set_cpu_caps(void)
> >  {
> >  	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
> 
> Hi,
> 
> Maybe we should instead rename the SPEC_CTRL_SSBD to
> 'MSR_IA32_SPEC_CTRL_SSBD' and together with it, other fields of this msr.  It
> seems that at least some msrs in this file do this.

Yeah, the #undef hack is quite ugly.  But I didn't (and still don't) want to
introduce all the renaming churn in the middle of this already too-big series,
especially since it would require touching quite a bit of code outside of KVM.

I'm also not sure that's the right thing to do; I kinda feel like KVM is the one
that's being silly here.

Aha!  Rather than rename the MSR bits, what if we rename the X86_FEATURE flag,
e.g. to X86_FEATURE_INTEL_SPEC_CTRL_SSBD, X86_FEATURE_MSR_SPEC_CTRL_SSBD, or maybe
even just X86_FEATURE_INTEL_SSBD.  Much less churn, and it would add even more
clarity as to why there's also X86_FEATURE_SSBD and X86_FEATURE_AMD_SSBD.

I'll post a standalone patch to make that change, and maybe see if I can take it
through the KVM tree.

