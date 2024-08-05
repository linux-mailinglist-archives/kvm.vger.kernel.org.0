Return-Path: <kvm+bounces-23220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6A7947A49
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 13:12:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF33A1C21179
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 11:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708A015575D;
	Mon,  5 Aug 2024 11:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XOPJlI2Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D893214B09E
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 11:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722856310; cv=none; b=pMvcTa2nmoTSZi54ixXI+PFjwX2lXgaEv8dIXZ61sayJGLhsNZUYOHiYH6JqgQCp7PmMpuX1rctixFpfIeE1P8DGU9tpzGmz4tplS0Ddt/YT5UBoG83WvN7thLgoap4GApjBbw7TD8R1FTOaMzzEGEDcu+15ceq7lZUrgjk2Xww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722856310; c=relaxed/simple;
	bh=3mw2XsUesvt6vUvxNvJW3SkWUkc4iJ+xCBnk9yNDzMQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MPIJWymcTg3hnRnldGB+cIS5u7U+Blb0jag0EcGW53QJ8dxQ9a4Z1Tl4eyGftrvOftlk7cO2pdaVWkR4yGa0wnkQ38kTbNlp+FLRmpK+KvWcQLBcvwtg0aKOqrdDGvMQoqQtG26yvGMmO3ZkQwOWRkvVclp89cgYUwbM+aE+ZGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XOPJlI2Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722856307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KwYB9LtW6vzSpi4prq/zdm+NavJBCZbeppKmDuey/Fw=;
	b=XOPJlI2QBUA/bOD884IJ53jJhB5o2Wyj1HkZnBRBLR5MxMzoi+yeWVm9VPSSzgaB/e0ufM
	ZLkI1HK8v+zh/PNxmlmR2aXtMIWpTIucUq4WxUmxaLXkVEwhpAI9N+ReSO/ZDnzzbtwdpf
	FYvV7qgsiJSJhLDvV3f7ZWAUbSbjWls=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-mvsyvYXRN8aQ8tuMDis-tA-1; Mon, 05 Aug 2024 07:11:46 -0400
X-MC-Unique: mvsyvYXRN8aQ8tuMDis-tA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3687e6d7a3aso5150633f8f.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 04:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722856305; x=1723461105;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KwYB9LtW6vzSpi4prq/zdm+NavJBCZbeppKmDuey/Fw=;
        b=DUEFlyge7oRnX8YTY/Nd7NANBymMy4X5N9zBSLR8HnISi+btt42dRQduUkgf2B/1e1
         7PmACYXzKP0pw9Pg4waD49eLzdPBP8vFPKnDruXMbjtbflZxE4MQyqlwPaHNGQpbofkU
         H4u94pn0Mdn/sY8NgI1x1JU8ApwWfEzYlKNfeDIxYhs/HpKEAODtVLkbwC0HtfTa7zvl
         LX/qZWgsotQZRkTNCjGzeKZkSlXIBDlcbrbO3mytLzgy/GEu/NDwHWPMFDm2nsuj0Inp
         Ex0ZUdfi36QhQZ/cYaysFaFFAwtSsrKH7LUXPTat7V5w3ABERAt4qVJDd2IqXY1kPBIE
         +5LA==
X-Forwarded-Encrypted: i=1; AJvYcCXtAy+5Q66GoxXT1g4H6U29P2sPE37eSnad4J33yQ/poBS1j6sy5pbUgju6ddy21P8jttmsgR201kDjWs/zVu+KR5Su
X-Gm-Message-State: AOJu0YyBA/jQLih2f7QZkI6Bem7hopnghgoYdtbEiFUe2GTZVQMpedY9
	z1NqJqlk8O/VBzbPamzwu8V/nSXE7jrPiVd+JZvmUXrcdH3F25leRpzFznYw5A07i50cXNDwznP
	4xJimtSuvgkBjUaDUQB3A187srgLpKbvZ272AEQ8GaMp08OyiqA==
X-Received: by 2002:adf:e801:0:b0:368:3f04:d5b with SMTP id ffacd0b85a97d-36bbc0dc2d3mr6504079f8f.25.1722856305125;
        Mon, 05 Aug 2024 04:11:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWsJDkKzDHo+UlZ3XdkaAkXTlDXmC3GFIojo0rgzrcWyIP68KYYrmvA1nsRgBtSL0L8m6TeQ==
X-Received: by 2002:adf:e801:0:b0:368:3f04:d5b with SMTP id ffacd0b85a97d-36bbc0dc2d3mr6504057f8f.25.1722856304665;
        Mon, 05 Aug 2024 04:11:44 -0700 (PDT)
Received: from intellaptop.lan ([2a06:c701:778d:5201:3e8a:4c9c:25dd:6ccc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbcf0c2dasm9559753f8f.7.2024.08.05.04.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 04:11:44 -0700 (PDT)
Message-ID: <ffa76b1b62c5cd2001f5f313009376e131bc2817.camel@redhat.com>
Subject: Re: [PATCH v2 24/49] KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to
 avoid macro collisions
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Mon, 05 Aug 2024 14:11:42 +0300
In-Reply-To: <ZqQybtNkhSVZDOTu@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-25-seanjc@google.com>
	 <20d3017a8dd54b345104bf2e5cb888a22a1e0a53.camel@redhat.com>
	 <ZoxaOqvXzTH6O64D@google.com>
	 <31cf77d34fc49735e6dff57344a0e532e028a975.camel@redhat.com>
	 <ZqQybtNkhSVZDOTu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=D0=A3 =D0=BF=D1=82, 2024-07-26 =D1=83 16:34 -0700, Sean Christopherson =D0=
=BF=D0=B8=D1=88=D0=B5:
> > On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> > > > On Mon, 2024-07-08 at 14:29 -0700, Sean Christopherson wrote:
> > > > > > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > > > > > > Maybe we should instead rename the SPEC_CTRL_SSBD to
> > > > > > > > 'MSR_IA32_SPEC_CTRL_SSBD' and together with it, other field=
s of this msr.=C2=A0 It
> > > > > > > > seems that at least some msrs in this file do this.
> > > > > >=20
> > > > > > Yeah, the #undef hack is quite ugly.=C2=A0 But I didn't (and st=
ill don't) want to
> > > > > > introduce all the renaming churn in the middle of this already =
too-big series,
> > > > > > especially since it would require touching quite a bit of code =
outside of KVM.
> > > >=20
> > > > > >=20
> > > > > > I'm also not sure that's the right thing to do; I kinda feel li=
ke KVM is the one
> > > > > > that's being silly here.
> > > >=20
> > > > I don't think that KVM is silly here. I think that hardware definit=
ions like
> > > > MSRs, register names, register bit fields, etc, *must* come with a =
unique
> > > > prefix, it's not an issue of breaking some deeply nested macro, but=
 rather an
> > > > issue of readability.
> >=20
> > For the MSR names themselves, yes, I agree 100%.=C2=A0 But for the bits=
 and mask, I
> > disagree.=C2=A0 It's simply too verbose, especially given that in the v=
ast majority
> > of cases simply looking at the surrounding code will provide enough con=
text to
> > glean an understanding of what's going on.

I am not that sure about this, especially if someone by mistake uses a flag
that belong to one MSR, in some unrelated place. Verbose code is rarely a b=
ad thing.


> > =C2=A0 E.g. even for SPEC_CTRL_SSBD, where
> > there's an absurd amount of magic and layering, looking at the #define =
makes
> > it fairly obvious that it belongs to MSR_IA32_SPEC_CTRL.
> >=20
> > And for us x86 folks, who obviously look at this code far more often th=
an non-x86
> > folks, I find it valuable to know that a bit/mask is exactly that, and =
_not_ an
> > MSR index.=C2=A0 E.g. VMX_BASIC_TRUE_CTLS is a good example, where rena=
ming that to
> > MSR_VMX_BASIC_TRUE_CTLS would make it look too much like MSR_IA32_VMX_T=
RUE_ENTRY_CTLS
> > and all the other "true" VMX MSRs.
> >=20
> > > > SPEC_CTRL_SSBD for example won't mean much to someone who only know=
s ARM, while
> > > > MSR_SPEC_CTRL_SSBD, or even better IA32_MSR_SPEC_CTRL_SSBD, lets yo=
u instantly know
> > > > that this is a MSR, and anyone with even a bit of x86 knowledge sho=
uld at least have
> > > > heard about what a MSR is.
> > > >=20
> > > > In regard to X86_FEATURE_INTEL_SSBD, I don't oppose this idea, beca=
use we have
> > > > X86_FEATURE_AMD_SSBD, but in general I do oppose the idea of adding=
 'INTEL' prefix,
> >=20
> > Ya, those are my feelings exactly.=C2=A0 And in this case, since we alr=
eady have an
> > AMD variant, I think it's actually a net positive to add an INTEL varia=
nt so that
> > it's clear that Intel and AMD ended up defining separate CPUID to enume=
rate the
> > same basic info.
> >=20
> > > > because it sets a not that good precedent, because most of the feat=
ures on x86
> > > > are first done by Intel, but then are also implemented by AMD, and =
thus an intel-only
> > > > feature name can stick after it becomes a general x86 feature.
> > > >=20
> > > > IN case of X86_FEATURE_INTEL_SSBD, we already have sadly different =
CPUID bits for
> > > > each vendor (although I wonder if AMD also sets the X86_FEATURE_INT=
EL_SSBD).
> > > >=20
> > > > I vote to rename 'SPEC_CTRL_SSBD', it can be done as a standalone p=
atch, and can
> > > > be accepted right now, even before this patch series is accepted.
> >=20
> > If we go that route, then we also need to rename nearly ever bit/mask d=
efinition
> > in msr-index.h, otherwise SPEC_CTRL_* will be the odd ones out.=C2=A0 A=
nd as above, I
> > don't think this is the right direction.

Honestly not really. If you look carefully at the file, many bits are alrea=
dy defined
in the way I suggest, for example:

MSR_PLATFORM_INFO_CPUID_FAULT_BIT
MSR_IA32_POWER_CTL_BIT_EE
MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT
MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT


This file has all kind of names for both msrs and flags. There is not much =
order,
so renaming the bit definitions of IA32_SPEC_CTRL won't increase the level =
of disorder
in this file IMHO.


Best regards,
	Maxim Levitsky



> >=20


