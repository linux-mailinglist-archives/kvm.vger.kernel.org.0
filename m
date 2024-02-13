Return-Path: <kvm+bounces-8584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F28A0852790
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 03:46:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2326C1C23357
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 02:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA306FBD;
	Tue, 13 Feb 2024 02:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k12m35I4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734C917CE
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 02:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707792389; cv=none; b=LAfvKDO/4cr0KrltE6kLZMmFFDpmB56an5Wqop+xIO1TalTv3pML/F+16vNwm9HKNQN9ADxQKSys1nJ3P+W1jMzS5jlVQg0S9V8XLUTmlsVVEQpY5T9iDyi4bJePrC3o+MC+NweDaneo/2FQdi/b4isdqw9ZjkxEV6506qDcjY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707792389; c=relaxed/simple;
	bh=bi//PTUtY+EwVoi0mPqaJExzueAl50/QOcxwdbDfkec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hwTGcHi6vASB6jmfLb19QNwGru/fGP+jrgtbk10GnFSwFQVfBTw0ikHQ8Au1shn5WC3/n/n42gIXeI2pwMQJc11tdPWCIQJb2PyuqB7PwAbZgvBoU6Bi0bpjxV3yzPZ1jW+MaZsy9XCIJ3Qd6ZLWFIz/PUSNMpj7BVNO9EXHY7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k12m35I4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ee22efe5eeso67043397b3.3
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 18:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707792384; x=1708397184; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fa6JPy2ikfqnkDj89yS4RCnJk+0NDmtRigU+S/WJCr8=;
        b=k12m35I4wgJvNv2P/brlbjo8hlFADt7YWUvI5tpnrye8jukTPbfsFJ5iYKrHNxRYAq
         RKjhAIyrFdkwggD+aAOULmCvaxoCNr3XD968p11kQ5zEAgcMC6EGyufEX7zSetAJcFE8
         jgzEH8djQnI8Qe0OPrwTbLQU3jO6L3D3h+fVPhGTacI3gVmTPn2MKX2PIXnd6On+mIt+
         rbl/AMBeqUs/HhInBbHP00NVpoinuzmitr1xmCkMZWjmggShuHdMlECDKhXSIZNjL1Oi
         6UUmMM0+4lHBDkvb60dw/NE2FsEpjDvUWw7FWvXTwj2r1Lt9TKFlDWCqlossYuE69WyF
         VA9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707792384; x=1708397184;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fa6JPy2ikfqnkDj89yS4RCnJk+0NDmtRigU+S/WJCr8=;
        b=C92d/FJNKnV0oBUVnL4MO3E2AXHv8IyeNsWvVMkdNGTdkalMRZLdyhsK67zLoxv6yr
         yfwQ+3q1hySv9H6h6GczYoCn05g8GXXyH+gLi40Acd6bBc5AXlaeDlIK8JIAQnqSTid1
         eAyeo92HyT8bp+R93ewp9A/biwOwUTqxuYD87XzTgezHcb9OOIabjVHdi+pTEfiJfQK7
         c35v45Qpb7UCLoITZCaAMijJWi1XqUMlAfKlsE15ZNWSZXpY/i60tTMnaHQ5ft/2kfmZ
         qQwQLq8c4txQWC3kq1nVICOoV8b1UMsy+EzKWSyulFnnBWRP2qv1itbE5U4ohOL1qd05
         Drnw==
X-Forwarded-Encrypted: i=1; AJvYcCXSzjRNSA9eD97OHYPt8bCOQX1xdN6YvwuurpelJYUB1zK+HYQ1IOe2LGWjh69pFHBh9daAFHiypjf2JrmW1ocDFZRn
X-Gm-Message-State: AOJu0YwHWOQrj+KfHvair/U5G87Q/NBcVY5o5irmNzARONvGKvLe49mU
	LPFvN9cshkpDOhEI9uxUCX+usf9J/3reK51+Q0uToG6o9ewOg4WkpzM2QqP/QpQYS5A8QUQbArB
	QeQ==
X-Google-Smtp-Source: AGHT+IG/ZSnLAURqx4lnOTAhY5bAE9qh5urnqzGu6F6ugq7mMYh8QI//JZSqfEiPz4iWnQgtIf0dTS0PHII=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d603:0:b0:607:7901:425b with SMTP id
 y3-20020a0dd603000000b006077901425bmr340812ywd.0.1707792384492; Mon, 12 Feb
 2024 18:46:24 -0800 (PST)
Date: Mon, 12 Feb 2024 18:46:23 -0800
In-Reply-To: <CABgObfaum2=MpXE2kJsETe31RqWnXJQWBQ2iCMvFUoJXJkhF+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209183743.22030-1-pbonzini@redhat.com> <ZcZ_m5By49jsKNXn@google.com>
 <CABgObfaum2=MpXE2kJsETe31RqWnXJQWBQ2iCMvFUoJXJkhF+w@mail.gmail.com>
Message-ID: <ZcrX_4vbXNxiQYtM@google.com>
Subject: Re: [PATCH 00/10] KVM: SEV: allow customizing VMSA features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com, isaku.yamahata@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 09, 2024, Paolo Bonzini wrote:
> On Fri, Feb 9, 2024 at 8:40=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > On Fri, Feb 09, 2024, Paolo Bonzini wrote:
> > > The idea that no parameter would ever be necessary when enabling SEV =
or
> > > SEV-ES for a VM was decidedly optimistic.
> >
> > That implies there was a conscious decision regarding the uAPI.  AFAICT=
, all of
> > the SEV uAPIs are direct reflections of the PSP invocations.  Which is =
why I'm
> > being so draconian about the SNP uAPIs; this time around, we need to ac=
tually
> > design something.
>=20
> You liked that word, heh? :) The part that I am less sure about, is
> that it's actually _possible_ to design something.
>=20
> If you end up with a KVM_CREATE_VM2 whose arguments are
>=20
>    uint32_t flags;
>    uint32_t vm_type;
>    uint64_t arch_mishmash_0; /* Intel only */
>    uint64_t arch_mishmash_1; /* AMD only */
>    uint64_t arch_mishmash_2; /* Intel only */
>    uint64_t arch_mishmash_3; /* AMD only */
>=20
> and half of the flags are Intel only, the other half are AMD only...
> do you actually gain anything over a vendor-specific ioctl?

Sane, generic names.  I agree the code gains are likely negligible, but for=
 me
at least, having KVM-friendly names for the commands would be immensely hel=
pful.
E.g. for KVM_CREATE_VM2, I was thinking more like:

  __u32 flags;
  __u32 vm_type;
  union {
	struct tdx;
	struct sev;
	struct sev_es;
	struct sev_snp;
	__u8 pad[<big size>]
  };

Rinse and repeat for APIs that have a common purpose, but different payload=
s.

Similar to KVM_{SET,GET}_NESTED_STATE, where the data is wildly different, =
and
there's very little overlap between {svm,vmx}_set_nested_state(), I find it=
 quite
valuable to have a single set of APIs.  E.g. I don't have to translate betw=
een
VMX and SVM terminology when thinking about the APIs, when discussing them,=
 etc.

That's especially true for all this CoCo goo, where the names are ridiculou=
sly
divergent, and often not exactly intuitive.  E.g. LAUNCH_MEASURE reads like
"measure the launch", but surprise, it's "get the measurement".

> Case in point being that the SEV VMSA features would be one of the
> fields above, and they would obviously not be available for TDX.
>=20
> kvm_run is a different story because it's the result of mmap, and not
> a ioctl. But in this case we have:
>=20
> - pretty generic APIs like UPDATE_DATA and MEASURE that should just be
> renamed to remove SEV references. Even DBG_DECRYPT and DBG_ENCRYPT
> fall in this category
>=20
> - APIs that seem okay but may depend on specific initialization flows,
> for example LAUNCH_UPDATE_VMSA. One example of the problems with
> initialization flows is LAUNCH_FINISH, which seems pretty tame but is
> different between SEV{,-ES} and SNP. Another example could be CPUID
> which is slightly different between vendors.
>=20
> - APIs that are currently vendor-specific, but where a second version
> has a chance of being cross-vendor, for example LAUNCH_SECRET or
> GET_ATTESTATION_REPORT. Or maybe not.

AFAICT, LAUNCH_SECRET (a.k.a. LAUNCH_UPDATE_SECRET) and GET_ATTESTATION_REP=
ORT
shouldn't even be a KVM APIs.  Ditto for LAUNCH_MEASURE, and probably other=
 PSP
commands.  IIUC, userspace has the VM's firmware handle, I don't see why KV=
M
needs to be a middle-man.

> - others that have no hope, because they include so many pieces of
> vendor-specific data that there's hardly anything to share. INIT is
> one of them. I guess you could fit the Intel CPUID square hole into
> AMD's CPUID round peg or vice versa, but there's really little in
> common between the two.
>=20
> I think we should try to go for the first three, but realistically
> will have to stop at the first one in most cases. Honestly, this
> unified API effort should have started years ago if we wanted to go
> there. I see where you're coming from, but the benefits are marginal
> (like the amount of userspace code that could be reused) and the
> effort huge in comparison.

The effort doesn't seem huge, so long as we don't try to make the parameter=
s
common across vendor code.  The list of APIs doesn't seem insurmountable (n=
ote,
I'm not entirely sure these are correct mappings):

  create
  init VM   (LAUNCH_START / TDH.MNG.INIT)
  update    (LAUNCH_UPDATE_DATA / TDH.MEM.PAGE.ADD+TDH.MR.EXTEND)
  init vCPU (LAUNCH_UPDATE_VMSA / TDH.VP.INIT)
  finalize  (LAUNCH_FINISH / TDH.MR.FINALIZE)

