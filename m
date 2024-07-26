Return-Path: <kvm+bounces-22362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8512A93DB2B
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FB78282B2A
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9139215350B;
	Fri, 26 Jul 2024 23:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="szm0+8Ox"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDD417BDC
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722036851; cv=none; b=VFQP4ZirHxk/CP9DuQI8gucJaUJpNqfqqdoBrPlQ965GYBocI+H4zDp3dlJ/one6EZpLtKMFaN/Yx44O5B6YCLJJGZJBH1907DY0XX7o0kg0W1c0wbRR/dKCY8IjAJ5JzeKfzWDT1C+S+8eZgoUzHX+g3pSO355e5C7yAvZh/7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722036851; c=relaxed/simple;
	bh=RQtMbylGuU16XFykl5/Sl5CGPbrXSVa/OeAnd9P5ZI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gyAer713FcdLKB+H74lTuHYWSxxgHR0NXminUKN4rRuWNWSpYJqTvLpFK99yefgN/kk87DZhLhJyFZoh4HLZRyo+jMypXNPSankXaHBWjf6ikVFWpxDI/gJBmE9uTmdQ/O1HtMwCMjryc90OncGpUp/19yCk4jC8UtASUWaw9XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=szm0+8Ox; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-666010fb35cso4211927b3.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722036848; x=1722641648; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SSdsezEIt/Fp32s2FTf13aRyq05x0uAP+V8KzHmTBR4=;
        b=szm0+8OxmOK+2/lCPfkUlvqCMBx5esrwkkuOgfxXXM0HgMdj9F9wR0sX+lxwsH/VR8
         RP9+53kGICxa60G20KjZ1enuhZOasNk6/K7c662N8LAa0yPzsabTNTXrm/WT6DbaDaRr
         bWZrUBD0d813IRzSxBEMSRJ2X+V3rB5Pg8Lhsw+TmXChsng7sCq+1DhdDfdIWHPvS2XE
         rQVFqhmKPmRO+5z0c+RIJ0diwlGCR70RnP4kVB/ubwZKWTIHt2vUh1C6av7Jd38jVJ9T
         hnouWZh1R0A3bmCSTzt8GErOLVmnV7BRZlCEY4GdOC2V/TWuyCIiaUESCS5BMh+L/2aO
         YjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722036848; x=1722641648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSdsezEIt/Fp32s2FTf13aRyq05x0uAP+V8KzHmTBR4=;
        b=AR8J3ufFuIccqg44aXvZumFEAa026anAi3hBogD85enBU+NIixM3InwcF0hh2rJxzw
         e66ad0b8vc/MLhe//YYFptNuBxC2gLXY/qwWpqI+5/0fYtod02niUDpU/ndcEHrpPCF+
         kX0NUikguz7/DaHk29yKPnxiK7iN1+7NjHwhzTiJQ+n4LKfnY+kDSm/ZuIDX2us+7FHi
         ZTI28WRPEw2jHBN64E2hks/ycOqfnzBuseBK5b3trkUAGIfL3DGl3DM2btmMAJnWFeVE
         UkVvG+PyYGEtoxy0EJrpfG6RwQUXVKEnbwGWWo/fnFK7ROXB4qQ2tc0WzVccQ/8ZAEIP
         QIjw==
X-Forwarded-Encrypted: i=1; AJvYcCWVqzAcXfJXW1Z7uNWx5t/KleFoPwjSDTvpdZMtoxO5P0YxQvpM/A0Qv6L2Erf7VCNNfRp+2ItDRdPBX1b9FP/PvK2H
X-Gm-Message-State: AOJu0Yw8XPNuSPGd0HFgHQzPvcYFHG0TMgRMrtTl26K8JVgEncTsETGE
	cRUYXuQamAETgqJs2JDpqTUhi4CEYbxltVspk15c4hIMEQ3iXqBCO7VNkYyIf9QxdW8JM2zF/ZW
	mlA==
X-Google-Smtp-Source: AGHT+IE0Qhn7yLAoE6OMcvxw1EBbEbmBeHfypxe4U8DmBzxyyUTTUeSlmFqxg+6tY/vt3w4FV2PjG/zCs7A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3411:b0:66a:a05e:9fe4 with SMTP id
 00721157ae682-67a2cd74953mr37387b3.3.1722036848234; Fri, 26 Jul 2024 16:34:08
 -0700 (PDT)
Date: Fri, 26 Jul 2024 16:34:06 -0700
In-Reply-To: <31cf77d34fc49735e6dff57344a0e532e028a975.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-25-seanjc@google.com>
 <20d3017a8dd54b345104bf2e5cb888a22a1e0a53.camel@redhat.com>
 <ZoxaOqvXzTH6O64D@google.com> <31cf77d34fc49735e6dff57344a0e532e028a975.camel@redhat.com>
Message-ID: <ZqQybtNkhSVZDOTu@google.com>
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

On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> On Mon, 2024-07-08 at 14:29 -0700, Sean Christopherson wrote:
> > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > Maybe we should instead rename the SPEC_CTRL_SSBD to
> > > 'MSR_IA32_SPEC_CTRL_SSBD' and together with it, other fields of this msr.  It
> > > seems that at least some msrs in this file do this.
> > 
> > Yeah, the #undef hack is quite ugly.  But I didn't (and still don't) want to
> > introduce all the renaming churn in the middle of this already too-big series,
> > especially since it would require touching quite a bit of code outside of KVM.
>
> > 
> > I'm also not sure that's the right thing to do; I kinda feel like KVM is the one
> > that's being silly here.
> 
> I don't think that KVM is silly here. I think that hardware definitions like
> MSRs, register names, register bit fields, etc, *must* come with a unique
> prefix, it's not an issue of breaking some deeply nested macro, but rather an
> issue of readability.

For the MSR names themselves, yes, I agree 100%.  But for the bits and mask, I
disagree.  It's simply too verbose, especially given that in the vast majority
of cases simply looking at the surrounding code will provide enough context to
glean an understanding of what's going on.  E.g. even for SPEC_CTRL_SSBD, where
there's an absurd amount of magic and layering, looking at the #define makes
it fairly obvious that it belongs to MSR_IA32_SPEC_CTRL.

And for us x86 folks, who obviously look at this code far more often than non-x86
folks, I find it valuable to know that a bit/mask is exactly that, and _not_ an
MSR index.  E.g. VMX_BASIC_TRUE_CTLS is a good example, where renaming that to
MSR_VMX_BASIC_TRUE_CTLS would make it look too much like MSR_IA32_VMX_TRUE_ENTRY_CTLS
and all the other "true" VMX MSRs.

> SPEC_CTRL_SSBD for example won't mean much to someone who only knows ARM, while
> MSR_SPEC_CTRL_SSBD, or even better IA32_MSR_SPEC_CTRL_SSBD, lets you instantly know
> that this is a MSR, and anyone with even a bit of x86 knowledge should at least have
> heard about what a MSR is.
> 
> In regard to X86_FEATURE_INTEL_SSBD, I don't oppose this idea, because we have
> X86_FEATURE_AMD_SSBD, but in general I do oppose the idea of adding 'INTEL' prefix,

Ya, those are my feelings exactly.  And in this case, since we already have an
AMD variant, I think it's actually a net positive to add an INTEL variant so that
it's clear that Intel and AMD ended up defining separate CPUID to enumerate the
same basic info.

> because it sets a not that good precedent, because most of the features on x86
> are first done by Intel, but then are also implemented by AMD, and thus an intel-only
> feature name can stick after it becomes a general x86 feature.
> 
> IN case of X86_FEATURE_INTEL_SSBD, we already have sadly different CPUID bits for
> each vendor (although I wonder if AMD also sets the X86_FEATURE_INTEL_SSBD).
> 
> I vote to rename 'SPEC_CTRL_SSBD', it can be done as a standalone patch, and can
> be accepted right now, even before this patch series is accepted.

If we go that route, then we also need to rename nearly ever bit/mask definition
in msr-index.h, otherwise SPEC_CTRL_* will be the odd ones out.  And as above, I
don't think this is the right direction.

