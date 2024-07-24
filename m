Return-Path: <kvm+bounces-22185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96AE93B635
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0846D1C23B24
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FECA16A94B;
	Wed, 24 Jul 2024 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YHJN81JF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE8E15E5C2
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721843688; cv=none; b=kpmwIcKtvaJNHb7Pric2BLgshg9+QHshNLV6m9hqvP8oEWtEpTXegDZ9FcHiKnCmqHan446yyr1euAIB6A+J33VX8WO+A67JbSzAia/e+yA98J09uJZzIFXK2R+uyLq5z0yOIMfbc13H2Hjz24sY/CB9Yl8+JvhyHHNVbWPmd9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721843688; c=relaxed/simple;
	bh=wPbZa8uAkjpmTlvhMMPRbL1i9A7Un2i3eW8F2HLaIco=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pl5IMEEWPvdv36A1xfp4rnG5/WYvyMbwjQ2aN0ZrIw4E0UZJyXGNR+fHU9u7fdfgenro7Oq9wYSbI3pqmzTWiGF7v7BQv4mHeGGDjLk1EIxqMyty1eX9dy74fixFZc040lMAcP4Slek9iyprL9FS2iSba2uulZQeg4zGA2kzBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YHJN81JF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721843685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VtsJeKW2MN5I+G1FVsyysTWbPnlcSoryOv+03zhCSuY=;
	b=YHJN81JFyPj7KekhSkqDVF7HV+ZdXmUkNzn3nC4upPC6Owb82ibyM46DYerlA3yqFOqOwH
	fxs/I98LWyAhoD/o69Qc3axuUXjhl6iSNXSHKIkAwkopgAmiALd/xyR+4iC3oxPb5RpHFv
	Jjs6sJa3xjCqb6k1uYO7wHOXHQFtoz4=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-ZTdRPfV0MOuMacu90WSlXA-1; Wed, 24 Jul 2024 13:54:43 -0400
X-MC-Unique: ZTdRPfV0MOuMacu90WSlXA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-6648363b329so1113517b3.3
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:54:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721843682; x=1722448482;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VtsJeKW2MN5I+G1FVsyysTWbPnlcSoryOv+03zhCSuY=;
        b=fOmLa5eILUUy315rezHsHDDrUrlwcX85l9/cfTVfM5jq9ABckPPHjoKBkYwAA8eT4J
         M6hOghGyTZuI2zz9/R+R0MNMrMK8hH/2xpYp349EvVVdp6+u1NdM0jpKpqdELvva87KR
         W6GJQQBP35Jf61fkLlcZUjX/h5gF+8RYHTF7EsfpXQ0syXQEzO+TV2d1xBGIV6wSq8FD
         4wib4FDYGP2uS3SvwfvnQMEN898ps9d8TGwou442j4vlHNkc/y4ujHVPquOrFDebbX4o
         GNDQ9JJPWrr6sZG+v09Do5QOiaYcZv4ohEGjPHDMlmjSkMKcH9l20Z1kH0VIPWDwQ6VV
         Sp/A==
X-Forwarded-Encrypted: i=1; AJvYcCUOixcP9Z9HsYc0Qowt1xsfGV5iLOKEUNWHrBSoq7Hbc0zl34kX9GS8lO6AyHtjv5HeXnAqDUrHoLq/cYLcf8xnvIdn
X-Gm-Message-State: AOJu0YxWlRezCwbDLXrGfn3r2YlSqhH3UddJLXaGhiqImmH0B9h7uj3K
	ikgYkPK6xMZr1wBAV+exCYZiv1FO1RPZ+vYsu8PJRLL1PUsdXCBxKUdtcpt9LBN/3moQJkbcAWX
	Fn1ickrelrxq+CTiL8yTR8beXB1665kW4x6vPoZxeJ+E/U0lpJg==
X-Received: by 2002:a05:690c:6ac4:b0:64b:77e:84cf with SMTP id 00721157ae682-675157de1b7mr2129837b3.43.1721843682225;
        Wed, 24 Jul 2024 10:54:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7ZhufvVDu7CBu0unHvBaoAn0APjwBQ3xRxdftEl7H3sXGXMaJ3Q7LuMOi4YATlacG3B5dzg==
X-Received: by 2002:a05:690c:6ac4:b0:64b:77e:84cf with SMTP id 00721157ae682-675157de1b7mr2129627b3.43.1721843681907;
        Wed, 24 Jul 2024 10:54:41 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7ac7bd61dsm60223346d6.12.2024.07.24.10.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:54:41 -0700 (PDT)
Message-ID: <31cf77d34fc49735e6dff57344a0e532e028a975.camel@redhat.com>
Subject: Re: [PATCH v2 24/49] KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to
 avoid macro collisions
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:54:40 -0400
In-Reply-To: <ZoxaOqvXzTH6O64D@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-25-seanjc@google.com>
	 <20d3017a8dd54b345104bf2e5cb888a22a1e0a53.camel@redhat.com>
	 <ZoxaOqvXzTH6O64D@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 14:29 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > Undefine SPEC_CTRL_SSBD, which is #defined by msr-index.h to represent the
> > > enable flag in MSR_IA32_SPEC_CTRL, to avoid issues with the macro being
> > > unpacked into its raw value when passed to KVM's F() macro.  This will
> > > allow using multiple layers of macros in F() and friends, e.g. to harden
> > > against incorrect usage of F().
> > > 
> > > No functional change intended (cpuid.c doesn't consume SPEC_CTRL_SSBD).
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 8efffd48cdf1..a16d6e070c11 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -639,6 +639,12 @@ static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
> > >  	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
> > >  }
> > >  
> > > +/*
> > > + * Undefine the MSR bit macro to avoid token concatenation issues when
> > > + * processing X86_FEATURE_SPEC_CTRL_SSBD.
> > > + */
> > > +#undef SPEC_CTRL_SSBD
> > > +
> > >  void kvm_set_cpu_caps(void)
> > >  {
> > >  	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
> > 
> > Hi,
> > 
> > Maybe we should instead rename the SPEC_CTRL_SSBD to
> > 'MSR_IA32_SPEC_CTRL_SSBD' and together with it, other fields of this msr.  It
> > seems that at least some msrs in this file do this.
> 
> Yeah, the #undef hack is quite ugly.  But I didn't (and still don't) want to
> introduce all the renaming churn in the middle of this already too-big series,
> especially since it would require touching quite a bit of code outside of KVM.



> 
> I'm also not sure that's the right thing to do; I kinda feel like KVM is the one
> that's being silly here.

I don't think that KVM is silly here. I think that hardware definitions like
MSRs, register names, register bit fields, etc, *must* come with a unique prefix,
it's not an issue of breaking some deeply nested macro, but rather an issue of readability.

SPEC_CTRL_SSBD for example won't mean much to someone who only knows ARM, while
MSR_SPEC_CTRL_SSBD, or even better IA32_MSR_SPEC_CTRL_SSBD, lets you instantly know
that this is a MSR, and anyone with even a bit of x86 knowledge should at least have
heard about what a MSR is.

In regard to X86_FEATURE_INTEL_SSBD, I don't oppose this idea, because we have
X86_FEATURE_AMD_SSBD, but in general I do oppose the idea of adding 'INTEL' prefix,
because it sets a not that good precedent, because most of the features on x86
are first done by Intel, but then are also implemented by AMD, and thus an intel-only
feature name can stick after it becomes a general x86 feature.

IN case of X86_FEATURE_INTEL_SSBD, we already have sadly different CPUID bits for
each vendor (although I wonder if AMD also sets the X86_FEATURE_INTEL_SSBD).

I vote to rename 'SPEC_CTRL_SSBD', it can be done as a standalone patch, and can
be accepted right now, even before this patch series is accepted.

Best regards,
	Maxim Levitsky


> 
> Aha!  Rather than rename the MSR bits, what if we rename the X86_FEATURE flag,
> e.g. to X86_FEATURE_INTEL_SPEC_CTRL_SSBD, X86_FEATURE_MSR_SPEC_CTRL_SSBD, or maybe
> even just X86_FEATURE_INTEL_SSBD.  Much less churn, and it would add even more
> clarity as to why there's also X86_FEATURE_SSBD and X86_FEATURE_AMD_SSBD.
> 
> I'll post a standalone patch to make that change, and maybe see if I can take it
> through the KVM tree.
> 




