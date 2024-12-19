Return-Path: <kvm+bounces-34095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C16FD9F729A
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78EAD18903D2
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADE378F34;
	Thu, 19 Dec 2024 02:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dcp5VdZj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0C14C98
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575586; cv=none; b=AQv9/TobvZe5DcWi4wC73CQ9awea8Jew06beeCPYsuswB3Zt7xOcOUGaqqj79konWiaAIOf8oa+CrLM8Z4f/i6ZenWFZy+kLfnkDVuLFgP0lDWDdxp3y4V29sCSOWQ7Tj3yzuuyZ4OL+csxgMqLdNQzjLpSEyIOHxi+RxtEYyN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575586; c=relaxed/simple;
	bh=xYUDSZsic34i8qW39Enlng1kiUll4zHWqTZZCNBvMpU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MOQwH4gYa1c/cWqGaT+17lF3UajXn/t7u1r3LyIcB58KyN1+ACQeIoXGa73/Sf8jm9xQwgKc+HNnXTHbNH5s0FGqMFbj78fNg3PVnMmH06+NDH1E0ZeNHbIsdfCH0ri4D254j2RU1fNwjKspYoMBmnbXcN7M5NEjo871+gi4f0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dcp5VdZj; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216430a88b0so3399325ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734575584; x=1735180384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQz/W0jA/cWE29IHSyfApDS/sF2Zud2SdAZLUMT0YUo=;
        b=dcp5VdZjrcQf1Pl9zKq8ROZhiNtGPnBFyh7tFklSKdtEUUUIUQ2c5YqF/OKxbvzItc
         yMf7RSzPaNPm3/BcJfijlDdcapn5XZV7pNQq891BD6zroskO9yo1V/NLbxdr57atfnnW
         Qn9qN7nnl/Xje7lYuc5m61CVWHQc6nXMZoGeCP7sOKfneY9CiasU5NPliHuKTLjjwoFy
         O0tzUT9xBzEm33tbNNLvcVcZmZGN2fi909SwubqxNTJWeLJkjknu1x+Ls+tImdrMukp4
         sTQ7xikMi96Uz5Ej5MQJt4yYcCtlEtASKiQRDS8ZpQ/pfVKK1xjk4gFJUlWc8TeVIWVP
         0rAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734575584; x=1735180384;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HQz/W0jA/cWE29IHSyfApDS/sF2Zud2SdAZLUMT0YUo=;
        b=t/xD7C159bqCA0YothGL5v3VmGstjGf8dFSLOarIjvra+5CvYzpTYtaQjf10hupt+P
         ge3dZhDCn+vb+hrS89bYE3BKH7+yvfL6b258JW5QXTclU6drhebgOD6OYthwjxPeL/HT
         0Hc/plpZHAtj3Z6pY6F9M8lsuQv92HrPIUv7qLKmQJ21/IcwVpzYr0/Q6Oe7Ynh7OSXn
         Yo0EBw24vTyX9BqjCd5lFff9wGKSlj+Owub5XZUp4XQ+RFmQ3V64wvQBd9tTgaFbU6B7
         GH4S9x97ep3OgQJmru+/wLG9oPACJ0tUg7dHM0xQxOp1vtbfQK7N8MrdpYIjBVJYfZUw
         OB/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWL8jwd8THw+bVYq2/znrwRx/mpBaFY8LGJY8pjcv2kIAxILvKp2nj0YWMIbdOit3GRqYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmV2jV5Vm3zpKAAdjhJ4ev/NPb/sDYXAOlTITggs+HHKiS54Kj
	jA95Jw0Bm3a8OKI/ikh+L6z5Fjt9hQryeWlBSECsCW3YGbmV5FoSuUWJqwg2lJ8gbr+9DWLHp3M
	Z8A==
X-Google-Smtp-Source: AGHT+IGvNxp6Y5CDKAj2Fil5RlhKrICn/fVyxK4RhafU7lQC1PQbHLvUMm/awn2nglyRSxT/yimJ3J4w8eA=
X-Received: from plev13.prod.google.com ([2002:a17:903:31cd:b0:216:248e:8fab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c410:b0:215:7faa:ece2
 with SMTP id d9443c01a7336-219d96ff1cemr29517635ad.35.1734575584390; Wed, 18
 Dec 2024 18:33:04 -0800 (PST)
Date: Wed, 18 Dec 2024 18:33:03 -0800
In-Reply-To: <f58c24757f8fd810e5d167c8b6da41870dace6b1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
 <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com> <269199260a42ff716f588fbac9c5c2c2038339c4.camel@intel.com>
 <Z2DZpJz5K9W92NAE@google.com> <3ef942fa615dae07822e8ffce75991947f62f933.camel@intel.com>
 <Z2INi480K96q2m5S@google.com> <f58c24757f8fd810e5d167c8b6da41870dace6b1.camel@intel.com>
Message-ID: <Z2OEQdxgLX0GM70n@google.com>
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024, Rick P Edgecombe wrote:
> On Tue, 2024-12-17 at 16:08 -0800, Sean Christopherson wrote:
> > On Tue, Dec 17, 2024, Rick P Edgecombe wrote:
> > > Some options discussed on the call:
> > >=20
> > > 1. If we got a promise to require any new CPUID bits that clobber hos=
t state to
> > > require an opt-in (attributes bit, etc) then we could get by with a p=
romise for
> > > that too. The current situation was basically to assume TDX module wo=
uldn't open
> > > up the issue with new CPUID bits (only attributes/xfam).
> > > 2. If we required any new configurable CPUID bits to save/restore hos=
t state
> > > automatically then we could also get by, but then KVM's code that doe=
s host
> > > save/restore would either be redundant or need a TDX branch.
> > > 3. If we prevent setting any CPUID bits not supported by KVM, we woul=
d need to
> > > track these bits in KVM. The data backing GET_SUPPORTED_CPUID is not =
sufficient
> > > for this purpose since it is actually more like "default values" then=
 a mask of
> > > supported bits. A patch to try to do this filtering was dropped after=
 upstream
> > > discussion.[0]
> >=20
> > The only CPUID bits that truly matter are those that are associated wit=
h hardware
> > features the TDX module allows the guest to use directly.  And for thos=
e, KVM
> > *must* know if they are fixed0 (inverted polarity only?), fixed1, or co=
nfigurable.
> > As Adrian asserted, there probably aren't many of them.
>=20
> I don't follow why the fixed bits are special here. If any configuration =
can
> affect the host, KVM needs to know about it. Whether it is fixed or
> configurable.

I think we're in violent agreement.  Ignore the last line about Adrian's as=
sertion,
which was very poorly phrased, and the above boils down to:

  The only CPUID bits that truly matter are those that are associated with =
hardware
  features the TDX module allows the guest to use directly, and KVM *must* =
know
  if the bits are fixed0, fixed1, or configurable.

> I wonder if there could be some confusion about how much KVM can trust th=
at its
> view of the CPUID bits is the same as the TDX Modules? In the current pat=
ches
> userspace is responsible for assembling KVM's CPUID data which it sets wi=
th
> KVM_SET_CPUID2 like normal. It fetches all the set bits from the TDX modu=
le,
> massages them, and pass them to KVM. So if a host affecting configurable =
bit is
> set in the TDX module, but not in KVM then it could be a problem. I think=
 we
> need to reassess which bits could affect host state, and make sure we re-=
check
> them before entering the TD. But we can't simply check that all bits matc=
h
> because there are some bits that are set in KVM, but not TDX module (real=
 PV
> leafs, guestmaxpa, etc).
>=20
> So that is how I arrived at that we need some list of host affecting bits=
 to
> verify match in the TD.

At the end of the day, the list is going to be human-generated.  For the UX=
 side
of things, it makes sense to push that responsibility to the TDX Module, be=
cause
it should be trivially easy to derive from the source code.

But identifying CPUID bits that control features requires human interventio=
n (or
I suppose AI that can cross-reference specs with code).

Again, I think we're in violent agreement.

> > For all other CPUID bits, what the TDX Module thinks and/or presents to=
 the guest
> > is completely irrelevant, at least as far as KVM cares, and to some ext=
ent as far
> > as QEMU cares.  This includes the TDX Module's FEATURE_PARAVIRT_CTRL, w=
hich frankly
> > is asinine and should be ignored.  IMO, the TDX Module spec is entirely=
 off the
> > mark in its assessment of paravirtualization.  Injecting a #VE instead =
of a #GP
> > isn't "paravirtualization".
> > =20
> > Take TSC_DEADLINE as an example.  "Disabling" the feature from the gues=
t's side
> > simply means that WRMSR #GPs instead of #VEs.  *Nothing* has changed fr=
om KVM's
> > perspective.  If the guest makes a TDVMCALL to write IA32_TSC_DEADLINE,=
 KVM has
> > no idea if the guest has opted in/out of #VE vs #GP.  And IMO, a sane g=
uest will
> > never take a #VE or #GP if it wants to use TSC_DEADLINE; the kernel sho=
uld instead
> > make a direct TDVMCALL and save itself a pointless exception.
> >=20
> >   Enabling Guest TDs are not allowed to access the IA32_TSC_DEADLINE MS=
R directly.
> >   Virtualization of IA32_TSC_DEADLINE depends on the virtual value of
> >   CPUID(1).ECX[24] bit (TSC Deadline). The host VMM may configure (as a=
n input to
> >   TDH.MNG.INIT) virtual CPUID(1).ECX[24] to be a constant 0 or allow it=
 to be 1
> >   if the CPU=E2=80=99s native value is 1.
> >=20
> >   If the TDX module supports #VE reduction, as enumerated by TDX_FEATUR=
ES0.VE_REDUCTION
> >   (bit 30), and the guest TD has set TD_CTLS.REDUCE_VE to 1, it may con=
trol the
> >   value of virtual CPUID(1).ECX[24] by writing TDCS.FEATURE_PARAVIRT_CT=
RL.TSC_DEADLINE.=20
> >=20
> >   =E2=80=A2 If the virtual value of CPUID(1).ECX[24] is 0, IA32_TSC_DEA=
DLINE is virtualized
> >     as non-existent. WRMSR or RDMSR attempts result in a #GP(0).
> >=20
> >   =E2=80=A2 If the virtual value of CPUID(1).ECX[24] is 1, WRMSR or RDM=
SR attempts result
> >     in a #VE(CONFIG_PARAVIRT). This enables the TD=E2=80=99s #VE handle=
r.
> >=20
> > Ditto for TME, MKTME.
> >=20
> > FEATURE_PARAVIRT_CTRL.MCA is even weirder, but I still don't see any re=
ason for
> > KVM or QEMU to care if it's fixed or configurable.  There's some crazy =
logic for
> > whether or not CR4.MCE can be cleared, but the host can't see guest CR4=
, and so
> > once again, the TDX Module's view of MCA is irrelevant when it comes to=
 handling
> > TDVMCALL for the machine check MSRs.
> >=20
> > So I think this again purely comes to back to KVM correctness and safet=
y.  More
> > specifically, the TDX Module needs to report features that are uncondit=
ionally
> > enabled or disabled and can't be emulated by KVM.  For everything else,=
 I don't
> > see any reason to care what the TDX module does.
> >=20
> > I'm pretty sure that gives us a way forward.  If there only a handful o=
f features
> > that are unconditionally exposed to the guest, then KVM forces those fe=
atures in
> > cpu_caps[*].
>=20
> I see. Hmm. We could use this new interface to double check the fixed bit=
s. It
> seems like a relatively cheap sanity check.
>=20
> There already is an interface to get CPUID bits (fixed and dynamic). But =
it only
> works after a TD is configured. So if we want to do extra verification or
> adjustments, we could use it before entering the TD. Basically, if we del=
ay this
> logic we don't need to wait for the fixed bit interface.

Oh, yeah, that'd work.  Grab the guest CPUID and then verify that bits KVM =
needs
to be 0 (or 1) are set according, and WARN+kill if there's a mismatch.

Honestly, I'd probably prefer that over using the fixed bit interface, as m=
y gut
says it's less likely for the TDX Module to misreport what CPUID it has cre=
ated
for the guest, than it is for the TDX module to generate a "fixed bits" lis=
t that
doesn't match the code.  E.g. KVM has (had?) more than a few CPUID features=
 that
KVM emulates without actually reporting support to userspace.

> What is special about the new proposed fixed bit interface is that it can=
 run
> before a TD runs (when QEMU wants to do it's checking of the users args).

