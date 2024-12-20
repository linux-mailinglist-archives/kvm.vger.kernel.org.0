Return-Path: <kvm+bounces-34253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1AE69F9793
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 18:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BF201898E8A
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 17:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B375321C19C;
	Fri, 20 Dec 2024 16:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wec+JrUh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B68219A86
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 16:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734713990; cv=none; b=r9/mepbp1KW94gb3jQIwNn5TexOmhjw/pqS+WUILcQgWinxwlWsQ3CgSkI1s/1rPh/E2ma2FOhZ0geh29ni4EK5a/dkmQvMZp4rVsVyFUHKK2Gn2k29eGBv/z7NFsXwZytRokt19Ni+eCwJUgw7dAEZH0Kd+rzQtM1AQDJKjiuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734713990; c=relaxed/simple;
	bh=8Q/LpE2q0fmGD7fBfuaXuK0b7Ix+Nn4hK1B6f7zFVh0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ElbMJqqg5R4ggIKPtWC4e5t02QR+dEh526WvMZLi5e/gfhoDHN1osVG8j26Y+dR+jJ9pO6vgwCDU23IN4nK7dOeRitup/PvhvyCvDS3zNYS1dfFXtqxeVpDdHhO8bl5OOhPEANeIQWxC5IgZGXlIjXASQ2OXNVcNrEyj1WrMdmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wec+JrUh; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ea69eeb659so1437202a12.0
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 08:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734713988; x=1735318788; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n61l0zrRSrZD3ftUtvSs02eIlCxovtOVrwB65P210Fg=;
        b=Wec+JrUh5ToPPXx+TmLD040V3yL75MSD2IQzGfX6ipFBX6XYlO/iAD2d6QnntPMq2C
         C7Dbw++WqPhwsW+WcPQ/aXurLIBh+c93kA1BLMT0b80ikfguAlMLHX4ZFHD75mUnN5UI
         FdlyTT4SeDRHzrETp+YksRHF16smIqEY33hAhn6uSVZonTpFwKdf8bMOFxUagPdzShxC
         B2AUlCrlaEsmeu4sWuT7KUSZzj06Lv0LJABn0ye6htJ/EdqK8gA6itIcf2rt1L3mrHD7
         7Uh3kyXlKYlSXvY7tn8VW/q6ldwrjr3FFyf09QWSpueOeEoyTb1mocCw9vqXyt/YtmhT
         h4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734713988; x=1735318788;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n61l0zrRSrZD3ftUtvSs02eIlCxovtOVrwB65P210Fg=;
        b=n+7DLUk1DTkcxS5tki9fmJACs9vW8Khmjv7gTl/1ncHDdFunDPYoZhbAycbfmfKMIj
         6k+VjQouo6LIt2LcpzVO9kyhyG3XGeCEEyQVAXc0XBrdCFM4pPOeE6sCmd0OocgvysSH
         8cArLvLt1ftEB44sUXB3smD9wygleVCOp2mccekZCbU0wweCSXA/NiN1zVCjxLM0QMog
         B2HQn1tlQQcS9HpV4mVSjOpp7lDksl94O/eI6+m7a84V8MIui2cMFWQRVLAwIbh7Vmua
         ub7D/MwvzxWQMv73GLJCihkTf1Cb43hy5GLApTKznGrWWddBJO6Of3K6bajfmN7OcRyI
         8ZzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEjkWw/rvpZ7Y0YzYcF4daswai1F8Oqq6ZG75guM+JHIbYWUeEY124PKrGqB/qs+F01w0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIHjARnoFZh2Jal1lvMnooDprSeMZy0AvMw4BESeiqeEkPYb8V
	tJeiV2zNe9ri7vE7MR6mEMmX4ARvmvV1UiScd2UJS5cnxJpu2Irf1eRHOce2VHMtRm3nExYMwDf
	Psw==
X-Google-Smtp-Source: AGHT+IGdgk5HiSUnypJSBS1nKyIa0BWmsZTWLmrxxURD+4sMnll4s3ySbEPev1+VFPU7ihrePN1uazKe0nI=
X-Received: from pjbqn3.prod.google.com ([2002:a17:90b:3d43:b0:2e2:44f2:9175])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ccc:b0:2ef:3192:d280
 with SMTP id 98e67ed59e1d1-2f452dfaed8mr5764829a91.5.1734713988589; Fri, 20
 Dec 2024 08:59:48 -0800 (PST)
Date: Fri, 20 Dec 2024 08:59:47 -0800
In-Reply-To: <88c87ff8-bae0-4522-bb65-109b959a7e52@intel.com>
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
 <Z2OEQdxgLX0GM70n@google.com> <88c87ff8-bae0-4522-bb65-109b959a7e52@intel.com>
Message-ID: <Z2Wig9CiowRkeeOl@google.com>
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2024, Xiaoyao Li wrote:
> On 12/19/2024 10:33 AM, Sean Christopherson wrote:
> > > > For all other CPUID bits, what the TDX Module thinks and/or present=
s to the guest
> > > > is completely irrelevant, at least as far as KVM cares, and to some=
 extent as far
> > > > as QEMU cares.  This includes the TDX Module's FEATURE_PARAVIRT_CTR=
L, which frankly
> > > > is asinine and should be ignored.  IMO, the TDX Module spec is enti=
rely off the
> > > > mark in its assessment of paravirtualization.  Injecting a #VE inst=
ead of a #GP
> > > > isn't "paravirtualization".
> > > > Take TSC_DEADLINE as an example.  "Disabling" the feature from the =
guest's side
> > > > simply means that WRMSR #GPs instead of #VEs.*Nothing* has changed =
from KVM's
> > > > perspective.  If the guest makes a TDVMCALL to write IA32_TSC_DEADL=
INE, KVM has
> > > > no idea if the guest has opted in/out of #VE vs #GP.  And IMO, a sa=
ne guest will
> > > > never take a #VE or #GP if it wants to use TSC_DEADLINE; the kernel=
 should instead
> > > > make a direct TDVMCALL and save itself a pointless exception.
> > > >=20
> > > >    Enabling Guest TDs are not allowed to access the IA32_TSC_DEADLI=
NE MSR directly.
> > > >    Virtualization of IA32_TSC_DEADLINE depends on the virtual value=
 of
> > > >    CPUID(1).ECX[24] bit (TSC Deadline). The host VMM may configure =
(as an input to
> > > >    TDH.MNG.INIT) virtual CPUID(1).ECX[24] to be a constant 0 or all=
ow it to be 1
> > > >    if the CPU=E2=80=99s native value is 1.
> > > >=20
> > > >    If the TDX module supports #VE reduction, as enumerated by TDX_F=
EATURES0.VE_REDUCTION
> > > >    (bit 30), and the guest TD has set TD_CTLS.REDUCE_VE to 1, it ma=
y control the
> > > >    value of virtual CPUID(1).ECX[24] by writing TDCS.FEATURE_PARAVI=
RT_CTRL.TSC_DEADLINE.
> > > >=20
> > > >    =E2=80=A2 If the virtual value of CPUID(1).ECX[24] is 0, IA32_TS=
C_DEADLINE is virtualized
> > > >      as non-existent. WRMSR or RDMSR attempts result in a #GP(0).
> > > >=20
> > > >    =E2=80=A2 If the virtual value of CPUID(1).ECX[24] is 1, WRMSR o=
r RDMSR attempts result
> > > >      in a #VE(CONFIG_PARAVIRT). This enables the TD=E2=80=99s #VE h=
andler.
> > > >=20
> > > > Ditto for TME, MKTME.
> > > >=20
> > > > FEATURE_PARAVIRT_CTRL.MCA is even weirder, but I still don't see an=
y reason for
> > > > KVM or QEMU to care if it's fixed or configurable.  There's some cr=
azy logic for
> > > > whether or not CR4.MCE can be cleared, but the host can't see guest=
 CR4, and so
> > > > once again, the TDX Module's view of MCA is irrelevant when it come=
s to handling
> > > > TDVMCALL for the machine check MSRs.
> > > >=20
> > > > So I think this again purely comes to back to KVM correctness and s=
afety.  More
> > > > specifically, the TDX Module needs to report features that are unco=
nditionally
> > > > enabled or disabled and can't be emulated by KVM.  For everything e=
lse, I don't
> > > > see any reason to care what the TDX module does.
> > > >=20
> > > > I'm pretty sure that gives us a way forward.  If there only a handf=
ul of features
> > > > that are unconditionally exposed to the guest, then KVM forces thos=
e features in
> > > > cpu_caps[*].
> > > I see. Hmm. We could use this new interface to double check the fixed=
 bits. It
> > > seems like a relatively cheap sanity check.
> > >=20
> > > There already is an interface to get CPUID bits (fixed and dynamic). =
But it only
> > > works after a TD is configured. So if we want to do extra verificatio=
n or
> > > adjustments, we could use it before entering the TD. Basically, if we=
 delay this
> > > logic we don't need to wait for the fixed bit interface.
> > Oh, yeah, that'd work.  Grab the guest CPUID and then verify that bits =
KVM needs
> > to be 0 (or 1) are set according, and WARN+kill if there's a mismatch.
> >=20
> > Honestly, I'd probably prefer that over using the fixed bit interface, =
as my gut
> > says it's less likely for the TDX Module to misreport what CPUID it has=
 created
> > for the guest, than it is for the TDX module to generate a "fixed bits"=
 list that
> > doesn't match the code.  E.g. KVM has (had?) more than a few CPUID feat=
ures that
> > KVM emulates without actually reporting support to userspace.
>=20
> The original motivation of the proposed fxied0 and fixed1 data is to
> complement the CPUID configurability report, which is important for
> userspace. E.g., Currently, what QEMU is doing is hardcoding the fixed0 a=
nd
> fixed1 information of a specific TDX release to adjust the
> KVM_GET_SUPPORTED_CPUID result and gets a final "supported" CPUID set for
> TDX. Hardcoding is not a good idea and it's better that KVM can get the d=
ata
> from TDX module, then pass to userspace (of course KVM can tweak the data
> based on its own requirement). So, do you think it's useful to have TDX
> module report the fixed0/fixed1 data for this purpose?

I'm definitely supportive of KVM passing on accurate information, so long a=
s KVM's
ABI isn't too crazy.

That said, I'm starting to agree with Rick's assessment that trying to enum=
erate
fixed CPUID feature bits is becoming a fool's errand as the TDX architectur=
e gets
more and more complex.

But _that_ said, if userspace ever needs to pivot on the TDX Module *versio=
n*,
then IMO that's a non-starter.  E.g. QEMU shouldn't have to hardcode fixed0=
/fixed1
bits based on TDX 1.5.whatever vs. TDX 2.0.whatever.

One alternative idea to trying to enumerate every fixed bit would be to mim=
ic what
the VMX architecture does for fixed CR0 bits.  Use TDX Module spec 1.5.06 (=
or whatever
version makes the most sense) as the base, and then adjust fixed/configurab=
le
information based on *features*.  E.g. when unrestricted guest is enabled, =
CR0.PG
and CR0.PE switch from fixed0 to configurable.  At a glance, I think the wh=
ole #VE
reduction madness could follow a similar path.

And then if the TDX tries to add fixed bits in the future that aren't expli=
citly
and clearly tied to some feature enablement, we collectively reject that TD=
X spec.

