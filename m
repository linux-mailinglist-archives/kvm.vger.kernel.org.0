Return-Path: <kvm+bounces-16070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BBF48B3DBC
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C60DF1F23F84
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C547715B974;
	Fri, 26 Apr 2024 17:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qZxm4k7T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A709315991C
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 17:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714151892; cv=none; b=lXLFFRomXEYlpG7TkgV1D7DqRtAirRRMPvMXwZxWcA9WBrOKe1LeU+/PynWec2IuJWZAz5E3/NBSnOUMCUu3rQWDcdTn0YJRhWt2EDep6fn1sxYrhS/BrVswfY6INR2s4BLpmqMwgpBcf1dRum0R9EV3u7mHq55HjJobConYpZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714151892; c=relaxed/simple;
	bh=Do/rI4aMTZVW2rrHZe87GB+gH60P9wQpb+vboLZOVb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FAlgOP/drfCpG4xK4YwX5MU3Inh4itjHpBC3XXHIprrR+h5RfxisZTtQyMhEs1cYdySQoeSmY5QZFqrb4diDgriMV1in7iknlHwaceULmmHRvmsVm56x56R0t3ZN5rCDVEv6agMaQ2x4QK5+Dz9LYr2FMvyjOj0vmkPQq6M8iD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qZxm4k7T; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a5e1e7bab9so2908349a91.2
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 10:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714151890; x=1714756690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pd6qdpv6bt24qY9l1H9ZWkNsyLznO92ECUS5fTbSWEs=;
        b=qZxm4k7T1VaD7+cmqFPcXJ51F10o/5ZSeyHqge8OyvZgnQPSgFDrD2GyGcNg08gj5b
         PmqKRYp1EN9It48DSK0U+WDtSv4+odWwi93bkBe4pKeU0vpSGZF8RioPndP4k9FRzSzJ
         JuUG5G80kFFNZq7AReHOb+n4rFQvGlhQ5rFObXm/yCs70bS+9tirus4qDvbN4BemwYqi
         eiQuy6/NJODHVDsqT6Dxrg85mYi9w3WJdgWRsYh4YCLyKsf8yqqFZ++rO3n+mL51ElNk
         +QOtSHzAB7B6LDHtjChCs2djmK2gt5d757f/LPVJS5lcBBsKK6hw6cZccNYSV1qrT7cy
         biuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714151890; x=1714756690;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pd6qdpv6bt24qY9l1H9ZWkNsyLznO92ECUS5fTbSWEs=;
        b=FBRI+osTQkwPn1Ys9atSpRXfp0ao8IFP8PWkSTZatUCSVhIyaD9Nn3eO9jYqcP0j/3
         +agwDl6xc36H3k8yBGTh+4DkSHu0lBG1dGLQpk3LkxVjpVIkOslQdP2RZi5xlWp7f3Jr
         mpvbJ11xbK6VykKjPz7Ehd4N3zQs5/Vv99E1fydWJEIYAE7gWS60uzeP3gAp+deGd+Wt
         bd07ItPpiuky1PJk8bl9ZyMUGW2RkOcGcIPRdNGKvduz81ZDZ6o8sqI8Ho5EYDU6/4o+
         NEYHMCxkO+trf/isa3w79z23z87lPp5YzNDPqkIH232VhzzBSsMiAs2QDGpN4g3K3pXB
         ED0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVgVtQsYML6jGcU2ucGGTnCYbMI52vvqRTeAMHXP+onGvo8Aa2LQXOVP9nc8yWI2ejIlv2R964cvgA20IIT71IjlnK4
X-Gm-Message-State: AOJu0Yym95JRpk3AH7fHpI2v8e4BamX+9sAanRYTrYSFswtA5NDDGCWN
	FF06gdGV4c7gq/mNCbXrJC5JKieHTRL30W7HtriHpVIZRY+QZVGHcrI7FXDzTefT3fOkMzPanxq
	EMA==
X-Google-Smtp-Source: AGHT+IF1AegauUY4Wl6VLYbDm4peg04BGO2kaMq8hp7QlvFc4qOJF6aA4KNwA32wtyNH/CBJrdd562Diooc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e60d:b0:2ad:7c60:423c with SMTP id
 j13-20020a17090ae60d00b002ad7c60423cmr58759pjy.3.1714151889896; Fri, 26 Apr
 2024 10:18:09 -0700 (PDT)
Date: Fri, 26 Apr 2024 10:18:08 -0700
In-Reply-To: <4c0cd892-8b7c-451b-9c04-2e83f33bef0f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425181422.3250947-1-seanjc@google.com> <20240425181422.3250947-10-seanjc@google.com>
 <4c0cd892-8b7c-451b-9c04-2e83f33bef0f@intel.com>
Message-ID: <Zivh0IaAmHsEOLFc@google.com>
Subject: Re: [PATCH 09/10] KVM: x86: Suppress failures on userspace access to
 advertised, unsupported MSRs
From: Sean Christopherson <seanjc@google.com>
To: Weijiang Yang <weijiang.yang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2024, Weijiang Yang wrote:
> On 4/26/2024 2:14 AM, Sean Christopherson wrote:
> > Extend KVM's suppression of failures due to a userspace access to an
> > unsupported, but advertised as a "to save" MSR to all MSRs, not just th=
ose
> > that happen to reach the default case statements in kvm_get_msr_common(=
)
> > and kvm_set_msr_common().  KVM's soon-to-be-established ABI is that if =
an
> > MSR is advertised to userspace, then userspace is allowed to read the M=
SR,
> > and write back the value that was read, i.e. why an MSR is unsupported
> > doesn't change KVM's ABI.
> >=20
> > Practically speaking, this is very nearly a nop, as the only other path=
s
> > that return KVM_MSR_RET_UNSUPPORTED are {svm,vmx}_get_feature_msr(), an=
d
> > it's unlikely, though not impossible, that userspace is using KVM_GET_M=
SRS
> > on unsupported MSRs.
> >=20
> > The primary goal of moving the suppression to common code is to allow
> > returning KVM_MSR_RET_UNSUPPORTED as appropriate throughout KVM, withou=
t
> > having to manually handle the "is userspace accessing an advertised"
> > waiver.  I.e. this will allow formalizing KVM's ABI without incurring a
> > high maintenance cost.
> >=20
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/x86.c | 27 +++++++++------------------
> >   1 file changed, 9 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 04a5ae853774..4c91189342ff 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -527,6 +527,15 @@ static __always_inline int kvm_do_msr_access(struc=
t kvm_vcpu *vcpu, u32 msr,
> >   	if (ret !=3D KVM_MSR_RET_UNSUPPORTED)
> >   		return ret;
> > +	/*
> > +	 * Userspace is allowed to read MSRs, and write '0' to MSRs, that KVM
> > +	 * reports as to-be-saved, even if an MSR isn't fully supported.
> > +	 * Simply check that @data is '0', which covers both the write '0' ca=
se
> > +	 * and all reads (in which case @data is zeroed on failure; see above=
).
> > +	 */
> > +	if (host_initiated && !*data && kvm_is_msr_to_save(msr))
> > +		return 0;
> > +
>=20
> IMHO,=C2=A0 it's worth to document above phrase into virt/kvm/api.rst KVM=
_{GET,
> SET}_MSRS sections as a note because when users space reads/writes MSRs
> successfully, it doesn't necessarily mean the operation really took effec=
t.
> Maybe it's=C2=A0 just due to the fact they're exposed in "to-be-saved" li=
st.

Agreed, though I think I'd prefer to wait to officially document the behavi=
or
until we have fully converted KVM's internals to KVM_MSR_RET_UNSUPPORTED.  =
I'm
99% certain the behavior won't actually be as simple as "userspace can writ=
e '0'",
e.g. I know of at least one case where KVM allows '0' _or_ the KVM's non-ze=
ro
default.

In the case that I'm aware of (MSR_AMD64_TSC_RATIO), the "default" is a har=
dcoded
KVM constant, e.g. won't change based on underlying hardware, but there me =
be
other special cases lurking, and we won't know until we complete the conver=
sion :-(

