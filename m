Return-Path: <kvm+bounces-67637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEB9D0C14C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 20:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6A6E43024265
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 19:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9031B31194A;
	Fri,  9 Jan 2026 19:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dFA/+nro"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414171EB9E1
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 19:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767987213; cv=pass; b=JDJWMD5UwHeBNMOAxAeWjG+L9Lf7UOxj9PkU6sudd+UjWsnQAfWqoEJi9yNkInrHwRR22LkbyxiEO3MAeBO+d313BxpomGHEHyMfFjf4aCZT+qNOquzm6KQk3FO1VPj5j+Qm4S1dDnswWDs/Ldqdb6VJiBuNf0h6EGZyE5I6MiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767987213; c=relaxed/simple;
	bh=967GVecIdOM0EGCEL5fGySJ1l4JAo4P2jSeR6J700DI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J04iirTbzc1IjQUvwDgckeNPRFTCWLtAO+4vSuihDFFPuPi3CzJRGSz85BnWkZY89mbWS4W6rm0NFyWZ6zkwv+PFC3Z7b/DGpdUzgY+MglYwkzkpBHRHWZbE6hT0Hb0cbVKCEdt32Lq97YKBg2/fLhZXk5ZXnvIZR+KQKqqP4fQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dFA/+nro; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so1902a12.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 11:33:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767987211; cv=none;
        d=google.com; s=arc-20240605;
        b=VLPGp0uW/D6LINbDbGfnqJ6Fxav3FLT5KFjx0gCnZ2DJuPm9dCWMtv8ePX+6HMpU3m
         xjpyNQgx2Qgup1Zp/YN818FFBh26rvkGfE7GqnHp/bVtM9aFHuZRe138vWm7vqTISAZd
         fPPXzPiAY4Wz/+AggtDFcuvraRSbpdwN9sJyOK0ys7t30Ra4P8+UbBk/NuAU9k0DMAg/
         hOZdNgUiJv1RTXq9jNcea+VhLxg/cksJkWf0wtgmpngolwZe6CHuaWUI8OwaRf9kqwEk
         1e1aXgdJpYfVPFKIA5Hx490kU1f4iHisedPYqIgISUVVoxwHY8efYGm78aIQLpyFMPLQ
         hYBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T47/VNuLrquSHCVhcWDrSsmp9W1fggG8AMlv/2jfh+Q=;
        fh=lmLxwR4LTrWQJbtv2sHSnSm2hg17I1ZVWxxXPglA/F0=;
        b=QhSvvul9kaNjMZsNBtPmrPXV0uyaszeAsLwpnfY7sT2d5djl5DFRyS6ktdZU7L4Z2g
         3vBZOdWFQrL30NqYkgxR+Mw0woNGXSM1TtTzeM5dYfV22Ic7iiFfkt/vCB98U3N94gGe
         n6IKlLCkk3dgPgkFQ+25ZIq6B7SEn0E+ZDst6VA8I185bVfRiT/DBaaU1oxSfyWy6IQ4
         TWATEAPEGuK4c9zPzwYVtHWLCkW22AZXACAAyyBBadj0CabIO5dRVTk7I/zNR0kk4xsk
         xxOc+IITMYsCorAjb1xg9mbavgngKY48teZYAyc4JiyxjUSZ6+8cnIpWh3hDybDl0Oj6
         cUZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767987211; x=1768592011; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T47/VNuLrquSHCVhcWDrSsmp9W1fggG8AMlv/2jfh+Q=;
        b=dFA/+nro96n/8OhSObwzut9XoC5CCmu29SLero/SNfDH8N5x2u3SE5K3tP9SY0s14l
         Z6ODG7/O7Mus3oXHscCdYzTSia7t8zYJmU891dDUKE6mdfP7gutDHdDqebFp0Ku6pVu/
         2xUsVFeALHLFO2K1tdsGmKq+QksfkVjIONZwZYGuodiSLs1eBOaCEuATDado7dw+osz5
         GjtEODaRd3lkCqGMU7CZkOoQCMSvBuNLIQDyJUb/VutFNHlE7vgyKbVQo7p7wQQNP9Nh
         Gf7SS0AJCoZjjXp8ZBLqo14hGFkbMQyvVbb5CSNNB5F6sMa7mAYC+jvhqAtVOTKeoibN
         EmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767987211; x=1768592011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T47/VNuLrquSHCVhcWDrSsmp9W1fggG8AMlv/2jfh+Q=;
        b=S1mrsNgWWYL0es1F2t4K8AsicbSdrNdwMM+QTUVqNccrgOvxfH4vf2AAb+CrzyHVnG
         BKOXnfOuPO98/0EShSPsPN7C0yybps+hCVDPFn4VPwTJiu8/Kfe5Jfx1UMzTnh+rzheU
         wa1RgYtbLMKNY3RCoicrDaL3jHT2i6rMNZUL3x7QnsJsGnk6rprDh0U/wtTb45c88Qv0
         j1aiwJSAY5G2vyPDP+8yKCYRtRkz92a39aXmyOjZBvhF9yeUXUSOsd3H1KWarvya10B0
         BJWDSsLb1NRZO2gvVf6IzUjK6UUaO7iLPiV7tjbYGCrEP4HnWRZDX/JH9JfztO8UiEht
         mgVQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+CrGsKffRUeM4avIwhztMzwgS1SIEsF2aksiWJLSOe922K/W7aIwOYUmdT811H+0T12Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6bUgRGH4rgkp9FSTxoDjFFkgR/HJowieJROqCALhnDNBU7Jhn
	SnYUwMjkYDspbKagDu4qS1vhdVwo2L98Hrht1nWLuPONV41c7j9DZJc2hI3d3wEzcuFBEC4hZqi
	86NMR4TIeyxA7qg3e/lAfs2jgmpYbJvT8aLcG9ZQd
X-Gm-Gg: AY/fxX7dE1p7ol0RtzJ9pe/2zOdFVXyu0nOQvDYe3XxbS67uWuBf/k+1zFP0E5G+1MK
	7U9aDt9C1VdfTRbyn3/fYZbGqL7Hs3pv2//b201zrPiXqP97nsaCbdvOid25Ad6XbeaJ1sbZtsI
	/KgQHfgA3wVfXmi6b9MxucQf7/urXWInYvM+Wa7DYMTVJR2SOpjKiYfGrN8vBddCuNsVG5lPDvJ
	URovWvGgQoQuH+DLtPZ4Ob6TzpvyzheMzIPYj9dZgJZbgCelfpIWn3bwkerDjvJ5gb7u5k=
X-Received: by 2002:aa7:c651:0:b0:649:69e6:cd4d with SMTP id
 4fb4d7f45d1cf-650dfeb87damr4524a12.11.1767987210464; Fri, 09 Jan 2026
 11:33:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522005555.55705-1-mlevitsk@redhat.com> <20250522005555.55705-4-mlevitsk@redhat.com>
 <aC-XmCl9SVX39Hgl@google.com> <aC-otXnBwHsdZ7B4@google.com> <aEBR7mbg-iTYdCtJ@google.com>
In-Reply-To: <aEBR7mbg-iTYdCtJ@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 9 Jan 2026 11:33:18 -0800
X-Gm-Features: AZwV_Qhq_qXq-z88hzaQD39JBkO7K03kBJyZgUXlbvElZdg_BufOQzmuzaWMcsI
Message-ID: <CALMp9eTHefPLtNwCgqieWbA4tE489Wyi_gVO9P59YxU+k0wgyg@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] KVM: nVMX: check vmcs12->guest_ia32_debugctl value
 given by L2
To: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 4, 2025 at 7:02=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, May 22, 2025, Sean Christopherson wrote:
> > +Jim
> >
> > On Thu, May 22, 2025, Sean Christopherson wrote:
> > > On Wed, May 21, 2025, Maxim Levitsky wrote:
> > > > Check the vmcs12 guest_ia32_debugctl value before loading it, to av=
oid L2
> > > > being able to load arbitrary values to hardware IA32_DEBUGCTL.
> > > >
> > > > Reviewed-by: Chao Gao <chao.gao@intel.com>
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/nested.c | 3 ++-
> > > >  arch/x86/kvm/vmx/vmx.c    | 2 +-
> > > >  arch/x86/kvm/vmx/vmx.h    | 1 +
> > > >  3 files changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index e073e3008b16..00f2b762710c 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -3146,7 +3146,8 @@ static int nested_vmx_check_guest_state(struc=
t kvm_vcpu *vcpu,
> > > >           return -EINVAL;
> > > >
> > > >   if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> > > > -     CC(!kvm_dr7_valid(vmcs12->guest_dr7)))
> > > > +     (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > > > +      CC(vmcs12->guest_ia32_debugctl & ~vmx_get_supported_debugctl=
(vcpu, false))))
> > >
> > > This is a breaking change.  For better or worse (read: worse), KVM's =
ABI is to
> > > drop BTF and LBR if they're unsupported (the former is always unsuppo=
rted).
> > > Failure to honor that ABI means L1 can't excplitly load what it think=
 is its
> > > current value into L2.
> > >
> > > I'll slot in a path to provide another helper for checking the validi=
ty of
> > > DEBUGCTL.  I think I've managed to cobble together something that isn=
't too
> > > horrific (options are a bit limited due to the existing ugliness).
> >
> > And then Jim ruined my day.  :-)
> >
> > As evidenced by this hilarious KUT testcase, it's entirely possible the=
re are
> > existing KVM guests that are utilizing/abusing DEBUGCTL features.
> >
> >       /*
> >        * Optional RTM test for hardware that supports RTM, to
> >        * demonstrate that the current volume 3 of the SDM
> >        * (325384-067US), table 27-1 is incorrect. Bit 16 of the exit
> >        * qualification for debug exceptions is not reserved. It is
> >        * set to 1 if a debug exception (#DB) or a breakpoint
> >        * exception (#BP) occurs inside an RTM region while advanced
> >        * debugging of RTM transactional regions is enabled.
> >        */
> >       if (this_cpu_has(X86_FEATURE_RTM)) {
> >               vmcs_write(ENT_CONTROLS,
> >                          vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
> >               /*
> >                * Set DR7.RTM[bit 11] and IA32_DEBUGCTL.RTM[bit 15]
> >                * in the guest to enable advanced debugging of RTM
> >                * transactional regions.
> >                */
> >               vmcs_write(GUEST_DR7, BIT(11));
> >               vmcs_write(GUEST_DEBUGCTL, BIT(15));
> >               single_step_guest("Hardware delivered single-step in "
> >                                 "transactional region", starting_dr6, 0=
);
> >               check_db_exit(false, false, false, &xbegin, BIT(16),
> >                             starting_dr6);
> >       } else {
> >               vmcs_write(GUEST_RIP, (u64)&skip_rtm);
> >               enter_guest();
> >       }
> >
> > For RTM specifically, disallowing DEBUGCTL.RTM but allowing DR7.RTM see=
ms a bit
> > silly.  Unless there's a security concern, that can probably be fixed b=
y adding
> > support for RTM.  Note, there's also a virtualization hole here, as KVM=
 doesn't
> > vet DR7 beyond checking that bits 63:32 are zero, i.e. a guest could se=
t DR7.RTM
> > even if KVM doesn't advertise support.  Of course, closing that hole wo=
uld require
> > completely dropping support for disabling DR interception, since VMX do=
esn't
> > give per-DR controls.
> >
> > For the other bits, I don't see a good solution.  The only viable optio=
ns I see
> > are to silently drop all unsupported bits (maybe with a quirk?), or enf=
orce all
> > bits and cross our fingers that no L1 VMM is running guests with those =
bits set
> > in GUEST_DEBUGCTL.
>
> Paolo and I discussed this in PUCK this morning.
>
> We agree trying to close the DR7 virtualization hole would be futile, and=
 that we
> should add support for DEBUGCTL.RTM to avoid breaking use of that specifi=
c bit.
>
> For the other DEBUGCTL bits, none of them actually work (although, somewh=
at
> amusingly, FREEZE_WHILE_SMM would "work" for real SMIs, which aren't visi=
ble to
> L1), so we're going to roll the dice, cross our fingers that no existing =
workload
> is setting those bits only in vmcs12.GUEST_DEBUGCTL, and enforce
> vmx_get_supported_debugctl() at VM-Enter without any quirk.
>
>   6   TR: Setting this bit to 1 enables branch trace messages to be sent.
>   7   BTS: Setting this bit enables branch trace messages (BTMs) to be lo=
gged in a BTS buffer.
>   8   BTINT: When clear, BTMs are logged in a BTS buffer in circular fash=
ion.
>   9   BTS_OFF_OS: When set, BTS or BTM is skipped if CPL =3D 0.
>   10  BTS_OFF_USR: When set, BTS or BTM is skipped if CPL > 0.
>   11  FREEZE_LBRS_ON_PMI: When set, the LBR stack is frozen on a PMI requ=
est.
>   12  FREEZE_PERFMON_ON_PMI: When set, each ENABLE bit of the global coun=
ter control MSR are frozen on a PMI request.
>   13  ENABLE_UNCORE_PMI: When set, enables the logical processor to recei=
ve and generate PMI on behalf of the uncore.
>   14  FREEZE_WHILE_SMM: When set, freezes perfmon and trace messages whil=
e in SMM.

I have encountered an existing workload that sets FREEZE_WHILE_SMM,
and this change wantonly breaks it.

KVM should continue to allow legacy workloads to (perhaps
ineffectively) set FREEZE_WHILE_SMM under a quirk .

