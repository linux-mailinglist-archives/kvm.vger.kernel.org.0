Return-Path: <kvm+bounces-24921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A765795CE8A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCC291C237DE
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3701885AA;
	Fri, 23 Aug 2024 13:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ihKMXpWO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBAC18858F
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724421583; cv=none; b=McrqDZTd+ZeuRKpa7yaRcavZ/T8NpCHXCddHcBqsaWDsTngKp3mtNqlOxcHSMJsdU+cWSWRpCP26laqrE9BSJcb/8lDBir4o9M272WFyyEutatcnvmB4BZDwmQIjcLAi3/yIt2bRvxG/FT98cI9POwA/A3yPnVSvClA43+jPFPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724421583; c=relaxed/simple;
	bh=AGZmhe0T2AgEMIHy2xceRfJbrR2RLVCYdBoG5yI9gQQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gRovxp84V7mDAlnIniKjrjINEtoWk+ktKi44fLg5uydneACoPTAVDSFGuIZx1xfVo6LNmq+Jc84Q+5yZocPSygBU4Q1EOVaV0CnPmPwXzyd8DSUFbIFlTW/Afh4Sa86qcmc4ly/3clI6+7S4s3U2llM7Mw80f5hsNq+QXLoeS0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ihKMXpWO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d3c6b19444so2132270a91.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 06:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724421581; x=1725026381; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4xJQmay/XmAEKHbSiksTaIcglpDFUxbk2mW4DZp5Gak=;
        b=ihKMXpWOv9AXwVY8hzzhysTroQBZpGP2WN92smvOKWkiWOQC7VZZusBQfX7AwPLYKM
         pFxYynBng/tyyOtd7NFiPe9HFartP4wRWutnhTE38hIbMonqXX14MUxR/S2QR5w5twut
         Rx9lWBjPrexnCf88UgbR49zimN0YEmeVIk2ifhD0dHnva3OVDeeiQi58LexUiz2XOhwd
         ljtJFLtkqkfEco0aQ8rptLOYKq0bb4ANjhl3f0lq2ML9JAlagX2lUrE8RXB1lNEoHL2K
         4ctg6DzfQYMuV7EUW6J+wV6iSVT+WAo4lOkKgCWoTseAfCrEPWJ2dl2rDhmuyeb2SEIs
         Hryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724421581; x=1725026381;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4xJQmay/XmAEKHbSiksTaIcglpDFUxbk2mW4DZp5Gak=;
        b=eKD2c6quhZOzH+gjcC/888sVAq3YyYxljkxh84AGQe/BXWrd8kIWKyvPqfsI695yq8
         gJN7pG6TfzFN1jiwVCxbS5vrXMNU8p3Z+eUGCvHSrwtvTP6ZKZVtmXHy3G7n5E2npJqN
         RsFat9EupLQJoi8SPeFiC4XMJUnHlFtXhVxNSOWmcmaRkicCW7y9kYdyh086eG4ApUNP
         tKMHzjmuPQE7IowYL/s2iVBBzzEiZ3iGvQHHQbJxuf49876653GFXBaXTMwG5/EXe9Ii
         XkqfTW+/q3aMjmkT360yjWPO0ekpnt5l6kfaUbY8ZRAZAhIlbt1Qh+fskWwMx5YkPhVY
         +Cug==
X-Gm-Message-State: AOJu0YyiHTiegbRS6sCA8XMVlLJ5NSS6SJyLFSJxlrHzzUriDMsbHpK4
	qWWDnvt3TLyDZGjK5tVDWAsbDFEaFF56CFPCoRVETkccENKaQwVNpEWMWgwJGMt4bin9uPBzOgM
	nbw==
X-Google-Smtp-Source: AGHT+IGGV5ZRy7+pcKSjaNr2Hgurjyx7riaEDaS/XwMLv28GIWrDw40sqoM7olDfEF+E/zZm/sj4g4tPKhE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5d8b:b0:2c2:e0f0:f40c with SMTP id
 98e67ed59e1d1-2d646d7023emr41095a91.6.1724421580473; Fri, 23 Aug 2024
 06:59:40 -0700 (PDT)
Date: Fri, 23 Aug 2024 06:59:39 -0700
In-Reply-To: <8a88f4e6208803c52eba946313804f682dadc5ee.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240815123349.729017-1-mlevitsk@redhat.com> <20240815123349.729017-2-mlevitsk@redhat.com>
 <Zr_JX1z8xWNAxHmz@google.com> <fa69866979cdb8ad445d0dffe98d6158288af339.camel@redhat.com>
 <0d41afa70bd97d399f71cf8be80854f13fe7286c.camel@redhat.com>
 <ZsYQE3GsvcvoeJ0B@google.com> <8a88f4e6208803c52eba946313804f682dadc5ee.camel@redhat.com>
Message-ID: <ZsiVy5Z3q-7NmNab@google.com>
Subject: Re: [PATCH v3 1/4] KVM: x86: relax canonical check for some x86
 architectural msrs
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024, mlevitsk@redhat.com wrote:
> =D0=A3 =D1=81=D1=80, 2024-08-21 =D1=83 09:04 -0700, Sean Christopherson =
=D0=BF=D0=B8=D1=88=D0=B5:
> > > static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *v=
cpu,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int flags)
> > > {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (flags & (X86EMUL_=
F_INVLPG | X86EMUL_F_MSR | X86EMUL_F_DT_LOAD))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return !__is_canonical_address(la, max_host_virt=
_addr_bits());
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return !__is_canonical_address(la, vcpu_virt_add=
r_bits(vcpu));
> > > }
>=20
> This can work in principle, although are you OK with using these emulator=
 flags
> outside of the emulator code?

Yep, they're already used in VMX's vmx_get_untagged_addr(). =20

> I am asking because the is_noncanonical_address is used in various places=
 across KVM.

...

> > > We wouldn't want wrapper for everything, e.g. to minimize the risk of=
 creating a
> > > de factor implicit default, but I think those three, and maybe a code=
/fetch
> > > variant, will cover all but a few users.
> > >=20
> > > > > About fixing the emulator this is what see:
> > > > >=20
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0emul_is_noncanoni=
cal_address
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__load_segment_descriptor
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0load_segment_descriptor
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0em_lldt
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0em_ltr
> > > > >=20
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0em_lgdt_lidt
> > > > >=20
> > > > >=20
> > > > >=20
> > > > > While em_lgdt_lidt should be easy to fix because it calls
> > > > > emul_is_noncanonical_address directly,
> > >=20
> > > Those don't need to be fixed, they are validating the memory operand,=
 not the
> > > base of the descriptor, i.e. aren't exempt from CR4.LA57.
>=20
> Are you sure?

Nope.  Re-reading what I wrote, I have no idea what code past me was lookin=
g at.

I even contradicted myself later on:

  So the explicit emul_is_noncanonical_address() check in __load_segment_de=
scriptor()
  needs to be tagged X86EMUL_F_BASE, but otherwise it all should Just Work =
(knock wood).

so yeah, ignore this.

> em_lgdt_lidt reads its memory operands (and checks that it is canonical t=
hrough
> linearize) with read_descriptor and that is fine because this is memory f=
etch,=C2=A0
> and then it checks that the base address within the operand is canonical.
>=20
> This check needs to be updated, as it is possible to load non canonical G=
DT and IDT
> base via lgdt/lidt (I tested this).
>=20
> For em_lldt, em_ltr, the check on the system segment descriptor base is
> in __load_segment_descriptor:
>=20
> ...
>  ret =3D linear_read_system(ctxt, desc_addr+8, &base3, sizeof(base3));
>  if (ret !=3D X86EMUL_CONTINUE)
>  return ret;
>  if (emul_is_noncanonical_address(get_desc_base(&seg_desc) |
>  ((u64)base3 << 32), ctxt))
>  return emulate_gp(ctxt, err_code);
>=20
> ...
>=20
>=20
> 64 bases are possible only for system segments, which are
> TSS, LDT, and call gates/IDT descriptors.
>=20
>=20
> We don't emulate IDT fetches in protected mode, and as I found out the ha=
rd way after
> I wrote a unit test to do a call through a call gate, the emulator doesn'=
t
> support call gates either)
>=20
> Thus I can safely patch __load_segment_descriptor.

Agreed.

And thinking more about how this is likely implemented in ucode, this is pr=
obably
working as intended.  The the SDM gives CPUs a _lot_ of leeway:

  In 64-bit mode, an address is considered to be in canonical form if addre=
ss
  bits 63 through to the most-significant implemented bit by the microarchi=
tecture
  are set to either all ones or all zeros.

as does the APM:

  Long mode defines 64 bits of virtual address, but implementations of the =
AMD64
  architecture may support fewer bits of virtual address. Although implemen=
tations
  might not use all 64 bits of the virtual address, they check bits 63 thro=
ugh the
  most-significant implemented bit to see if those bits are all zeros or al=
l ones.
  An address that complies with this property is said to be in canonical ad=
dress
  form. If a virtual-memory reference is not in canonical form, the impleme=
ntation
  causes a general-protection exception or stack fault.

I suspect that CR4.LA_57 is only consulted when the CPU is actually consumi=
ng the
address, i.e. is (or is about to, e.g. for code fetches) generating a memor=
y
access.

Heh, and for MPX, the SDM kinda sorta confirms that LA57 is ignored, though=
 I
doubt the author of this section intended their words to be taken this way =
:-)

  WRMSR to BNDCFGS will #GP if any of the reserved bits of BNDCFGS is not z=
ero or
  if the base address of the bound directory is not canonical. XRSTOR of BN=
DCFGU
  ignores the reserved bits and does not fault if any is non-zero; similarl=
y, it
  ignores the upper bits of the base address of the bound directory and sig=
n-extends
  the highest implemented bit of the linear address to guarantee the canoni=
cality
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^
  of this address.

> > > There _is_ an indirect canonical check on the _descriptor_ (the actua=
l descriptor
> > > pointed at by the selector, not the memory operand).=C2=A0 The SDM is=
 calls this case
> > > out in the LFS/LDS docs:
> > >=20
> > > =C2=A0 If the FS, or GS register is being loaded with a non-NULL segm=
ent selector and
> > > =C2=A0 any of the following is true: the segment selector index is no=
t within descriptor
> > > =C2=A0 table limits, the memory address of the descriptor is non-cano=
nical
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> I tested that both ltr and lldt do ignore CR4.LA57 by loading from a desc=
riptor
> which had a non canonical value and CR4.LA57 clear.

