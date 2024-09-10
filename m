Return-Path: <kvm+bounces-26346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 678F1974422
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:37:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5A4E1F272D9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D581AB51F;
	Tue, 10 Sep 2024 20:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ROLhjVxL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3C81AAE2B
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 20:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726000642; cv=none; b=jc312J7RW3rQ7cFQVpBl17PfcZMHYiUrCwyk/kDxV6FVAze9KY64CHSsCt4YDW62BzquQ+cXpb/C2V7rHsE3isCFGqdbkM44feWMvJA2ArpR/glTadBE+Q/u24FFS2x7SQLgviciwhjUgZJWOrwvv1oI3NyQKVG49FkbeKVtz8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726000642; c=relaxed/simple;
	bh=j8BLNPTIlp97YukBiFjqGPOR450ctjl+wiZlePlvtvs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sve6oHr193DJRTA/uQk+9kQhIuannsC2yIe6pf3580r2WtafPimHrpbmy80ofLa9DFMvyk0T3XbKNiNLiidW756KG10WvkoSs7I2VkUhkTlmMxYrBjNO/62AUv8aHUSU6AYM9VtC6Dgr5i3iA2ENJGJhPycpuf6aIXQzLRVbKSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ROLhjVxL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726000638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzZyBKVvrar3lKddj2cXKWYgMoZUq2MZKrtP2P65xVI=;
	b=ROLhjVxLxDLdPUZNVvtpuLJLnIZJFgKX177tOrzChRdNdr1kSnmfhwnksCFkXpXfRTl1Hg
	PWN46NFNL8/LuCIYn8A5q1wOlV554fHVCa0BszGFL5/T9VdhLLWD/E5ScZxPcDZG75hdPY
	IOpVt+F75JIUOOm7aa+Z0z218+p6uOQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-iEqYlZY2OrWUnEJSQbdh_Q-1; Tue, 10 Sep 2024 16:37:17 -0400
X-MC-Unique: iEqYlZY2OrWUnEJSQbdh_Q-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7a7fa083271so888936585a.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 13:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726000637; x=1726605437;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VzZyBKVvrar3lKddj2cXKWYgMoZUq2MZKrtP2P65xVI=;
        b=QfU2sQMX2ElM5SbvnPxc+DnFQy/b2KS7uQ6hSRYzSLUl5KMl7S5gg615V2MhJHpM6g
         mAHTyXXF85wUonEAsrSVTKwZnagf2YRxjnBVAVYYJtbvmCoWCvcVwlSNXTMXbGa67bHb
         1bp4JwOplSRiq9rihEyYJTVSUKGhC4p3Vll0mQMtd3pV5stVlheE8QpR5n8iJ2ZC9i8i
         guFAe3SPZqGTnYubn99furLaAYsTBtVzXaGeFFlLkGdkvDIiPel6dtpV4KlR24rXvmEq
         8Ar7Ldg4wQXD85OywdrCThpgFsXW5lKQzYT/ChuyQp55FspF0kzhuo7Nph/KKWONV4K+
         OwPg==
X-Forwarded-Encrypted: i=1; AJvYcCW56toiWZFiOiqe18yEdsUlk86+l5oYmuw5aOpv+uymvM2VEywAVwG4Rycb6FX4v7ORi00=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHXO8n0qITcKjy9LAjhLRzJ9SnSBXiX8Zf16+HIImwWK9txiWf
	GNOUvo/407iARzsTY2GtEOFDVdw/mxmw1Ni02LIr+XUaDb423pMvOsJneBIF3zRtxOsmHx2pDyn
	m3vlZS62Nnl2obyGRH20AF69cZwqU18qgJ3Iz8QyU5Nh2vfCSLg==
X-Received: by 2002:a05:620a:1a87:b0:7a9:ad18:11e9 with SMTP id af79cd13be357-7a9ad181880mr1993992485a.59.1726000637207;
        Tue, 10 Sep 2024 13:37:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBUfi5upaepXZJmyiNEy6MLGXGKi+4wEzyspuA/wVMEBrgXmQJrGBqUJpCCXlyyqkoL2UTHQ==
X-Received: by 2002:a05:620a:1a87:b0:7a9:ad18:11e9 with SMTP id af79cd13be357-7a9ad181880mr1993986985a.59.1726000636745;
        Tue, 10 Sep 2024 13:37:16 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a7a1ff6bsm338873285a.122.2024.09.10.13.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 13:37:16 -0700 (PDT)
Message-ID: <3563e64b38664bf64c5d66baa7507324e3fb694c.camel@redhat.com>
Subject: Re: [PATCH v2 24/49] KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to
 avoid macro collisions
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>, Borislav Petkov <bp@alien8.de>
Date: Tue, 10 Sep 2024 16:37:15 -0400
In-Reply-To: <ZrFFua_7kWKBESbe@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-25-seanjc@google.com>
	 <20d3017a8dd54b345104bf2e5cb888a22a1e0a53.camel@redhat.com>
	 <ZoxaOqvXzTH6O64D@google.com>
	 <31cf77d34fc49735e6dff57344a0e532e028a975.camel@redhat.com>
	 <ZqQybtNkhSVZDOTu@google.com>
	 <ffa76b1b62c5cd2001f5f313009376e131bc2817.camel@redhat.com>
	 <ZrFFua_7kWKBESbe@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2024-08-05 at 14:35 -0700, Sean Christopherson wrote:
> +Boris
> 
> On Mon, Aug 05, 2024, mlevitsk@redhat.com wrote:
> > У пт, 2024-07-26 у 16:34 -0700, Sean Christopherson пише:
> > > > On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> > > > > > On Mon, 2024-07-08 at 14:29 -0700, Sean Christopherson wrote:
> > > > > > > > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > > > > > > > > Maybe we should instead rename the SPEC_CTRL_SSBD to
> > > > > > > > > > 'MSR_IA32_SPEC_CTRL_SSBD' and together with it, other fields of this msr.  It
> > > > > > > > > > seems that at least some msrs in this file do this.
> > > > > > > > 
> > > > > > > > Yeah, the #undef hack is quite ugly.  But I didn't (and still don't) want to
> > > > > > > > introduce all the renaming churn in the middle of this already too-big series,
> > > > > > > > especially since it would require touching quite a bit of code outside of KVM.
> > > > > > > > I'm also not sure that's the right thing to do; I kinda feel like KVM is the one
> > > > > > > > that's being silly here.
> > > > > > 
> > > > > > I don't think that KVM is silly here. I think that hardware definitions like
> > > > > > MSRs, register names, register bit fields, etc, *must* come with a unique
> > > > > > prefix, it's not an issue of breaking some deeply nested macro, but rather an
> > > > > > issue of readability.
> > > > 
> > > > For the MSR names themselves, yes, I agree 100%.  But for the bits and mask, I
> > > > disagree.  It's simply too verbose, especially given that in the vast majority
> > > > of cases simply looking at the surrounding code will provide enough context to
> > > > glean an understanding of what's going on.
> > 
> > I am not that sure about this, especially if someone by mistake uses a flag
> > that belong to one MSR, in some unrelated place. Verbose code is rarely a bad thing.
> > 
> > 
> > > >   E.g. even for SPEC_CTRL_SSBD, where
> > > > there's an absurd amount of magic and layering, looking at the #define makes
> > > > it fairly obvious that it belongs to MSR_IA32_SPEC_CTRL.
> > > > 
> > > > And for us x86 folks, who obviously look at this code far more often than non-x86
> > > > folks, I find it valuable to know that a bit/mask is exactly that, and _not_ an
> > > > MSR index.  E.g. VMX_BASIC_TRUE_CTLS is a good example, where renaming that to
> > > > MSR_VMX_BASIC_TRUE_CTLS would make it look too much like MSR_IA32_VMX_TRUE_ENTRY_CTLS
> > > > and all the other "true" VMX MSRs.
> > > > 
> > > > > > SPEC_CTRL_SSBD for example won't mean much to someone who only knows ARM, while
> > > > > > MSR_SPEC_CTRL_SSBD, or even better IA32_MSR_SPEC_CTRL_SSBD, lets you instantly know
> > > > > > that this is a MSR, and anyone with even a bit of x86 knowledge should at least have
> > > > > > heard about what a MSR is.
> > > > > > 
> > > > > > In regard to X86_FEATURE_INTEL_SSBD, I don't oppose this idea, because we have
> > > > > > X86_FEATURE_AMD_SSBD, but in general I do oppose the idea of adding 'INTEL' prefix,
> > > > 
> > > > Ya, those are my feelings exactly.  And in this case, since we already have an
> > > > AMD variant, I think it's actually a net positive to add an INTEL variant so that
> > > > it's clear that Intel and AMD ended up defining separate CPUID to enumerate the
> > > > same basic info.
> > > > 
> > > > > > because it sets a not that good precedent, because most of the features on x86
> > > > > > are first done by Intel, but then are also implemented by AMD, and thus an intel-only
> > > > > > feature name can stick after it becomes a general x86 feature.
> > > > > > 
> > > > > > IN case of X86_FEATURE_INTEL_SSBD, we already have sadly different CPUID bits for
> > > > > > each vendor (although I wonder if AMD also sets the X86_FEATURE_INTEL_SSBD).
> > > > > > 
> > > > > > I vote to rename 'SPEC_CTRL_SSBD', it can be done as a standalone patch, and can
> > > > > > be accepted right now, even before this patch series is accepted.
> > > > 
> > > > If we go that route, then we also need to rename nearly ever bit/mask definition
> > > > in msr-index.h, otherwise SPEC_CTRL_* will be the odd ones out.  And as above, I
> > > > don't think this is the right direction.
> > 
> > Honestly not really. If you look carefully at the file, many bits are already defined
> > in the way I suggest, for example:
> > 
> > MSR_PLATFORM_INFO_CPUID_FAULT_BIT
> > MSR_IA32_POWER_CTL_BIT_EE
> > MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT
> > MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT
> 
> Heh, I know there are some bits that have an "MSR" prefix, hence "nearly every".
> 
> > This file has all kind of names for both msrs and flags. There is not much
> > order, so renaming the bit definitions of IA32_SPEC_CTRL won't increase the
> > level of disorder in this file IMHO.
> 
> It depends on what direction msr-index.h is headed.  If the long-term preference
> is to have bits/masks namespaced with only their associated MSR name, i.e. no
> explicit MSR_, then renaming the bits is counter-productive.
> 
> I added Boris, who I believe was the most opinionated about the MSR bit names,
> i.e. who can most likely give us the closest thing to an authoritative answer as
> to the preferred style.
> 
> Boris, we're debating about the best way to solve a weird collision between:
> 
>   #define SPEC_CTRL_SSBD
> 
> and
> 
>   #define X86_FEATURE_SPEC_CTRL_SSBD
> 
> KVM wants to use its CPUID macros to essentially do:
> 
>   #define F(name) (X86_FEATURE_##name)
> 
> as a shorthand for X86_FEATURE_SPEC_CTRL_SSBD, but that can cause build failures
> depending on how KVM's macros are layered.  E.g. SPEC_CTRL_SSBD can get resolved
> to its value prior to token concatentation and result in KVM effectively generating
> X86_FEATURE_BIT(SPEC_CTRL_SSBD_SHIFT).
> 
> One of the proposed solutions is to rename all of the SPEC_CTRL_* bit definitions
> to add a MSR_ prefix, e.g. to generate MSR_SPEC_CTRL_SSBD and avoid the conflict.
> My recollection from the IA32_FEATURE_CONTROL rework a few years back is that you
> wanted to prioritize shorter names over having everything namespaced with MSR_,
> i.e. that this approach is a non-starter.
> 

Hi,

Any update on this?

Best regards,
	Maxim Levitsky



