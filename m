Return-Path: <kvm+bounces-10543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0968B86D274
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 297DE1C20B7F
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2EBC7E580;
	Thu, 29 Feb 2024 18:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v98Jnhab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DCC224D7
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 18:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709232008; cv=none; b=gN2EEup9TVBfxXxXyxVtVeZTTG5UO2ZBkO5ORbchlFlLU9yCNv43rB/Q3DbaFTtEZoIZt6KQfcEBUoAnc0itPbiuer5UwnKWqWwfURLOg98TdUUjpw8rEOmcXJ7tGGsLKn7qspmJ8qIvg82CNlCKlNR+SW9htHDE9rEEawOSn/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709232008; c=relaxed/simple;
	bh=EfSzWHQXiIuv/QXiMcoNXY6pXi3oCnDesgNhCcVu5z4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tcr3YH7W0ptEQ1M01JrxpAnktFqxJ68RiLeg4uI5+8VCTzehB984tuvQ5TjlPkJjDdPhBvVDf8zRHjJHtCa+PJVbeTUosHqj4OkgoczoZRzSBlvoBEGsEGJJF6OUAfNpERC1E57ekzdtiI2o1JL6XTD9EB2HokZ7FpZXgLUbJqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v98Jnhab; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60904453110so15524277b3.2
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709232005; x=1709836805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vY/rdOoD7orW1sSyXqQMEdLlDPVHr5lpBJycktuWo78=;
        b=v98JnhabzmqTSfjRq8Je7E5qmQeMOZC6VxwZfVfo30sJoX6NsNLR/KOz7t8MiLnF2n
         DPbWvdtLZ60biyTC7scafSoEnF5ppBAbu3+9lzuKSdYDzL6vFwxYkPNSzuR3CgAGeXRH
         NKxBxkTNc7FTgIcuYAD5BK4+bw54wqNX3M35ocCo/PvEFe9nVHbyQsrCRK9PRze8P36E
         1Bi54/TgcYMKz71c8Myr8pvTJiSYvn3d79rCLyZcEEulFCqCj5CybtiQrpVbDL1wtj4o
         iF/6Uq2dGV4Te9plU0lblnxmqr9xW/RinYxB/IvV4u8RtDhkUK7T2JQtJoUU1Fsb4iZw
         VHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709232005; x=1709836805;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vY/rdOoD7orW1sSyXqQMEdLlDPVHr5lpBJycktuWo78=;
        b=GjtlxXfmEHkaMAkfB0L/hx9rHqxg2tCtw5UPdwkNlJC12JwC9FrH9MvE+MRu5TaGW5
         Yy7TVf6GrvV4zQaaXPzi7nZTvRASZI622Spgs0fDbNuSsMSKs0uyDA4SsP75Rw9fnjRn
         kdpwS/05wVURklPBi40c2UQBBVB/WBszS5DDcIt9yhWS2F7JIpZLQv30i76gpzuAPclH
         KW+7/NYAHpwSzwmnw30qgbnWOAT1zPyxZO3goJU4EgA+GdAl+pfDgOX63j6eVcaI3QWu
         lBHIfcq+802Aq5Ays7pH4pRhtvw/owsA9Lc60fQiHaplRQVlir0SeY/JycLu5s1ATulF
         WfOg==
X-Gm-Message-State: AOJu0YxHA71C6qyfVWoYSb71r3JOyYR/m8+s630bmNcPBC/RjdbeKmfF
	qEhSty/apNFI1yjHxYz8f14VtkdKqXoQffqJ9PwPx7NUN85fjWOBOncItS2ZHdrSnQdeQITI8gu
	GPQ==
X-Google-Smtp-Source: AGHT+IEg+77D7oFXFUtb7myxTYn0+eui+WQiWZe+o6cGIvgW/UaK+dQNFE4gTiVy8VFY9DzEUtC/JeMjDT8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9b47:0:b0:608:1b39:246b with SMTP id
 s68-20020a819b47000000b006081b39246bmr706371ywg.3.1709232005455; Thu, 29 Feb
 2024 10:40:05 -0800 (PST)
Date: Thu, 29 Feb 2024 10:40:03 -0800
In-Reply-To: <CABgObfbtPJ6AAX9GnjNscPRTbNAOtamdxX677kx_r=zd4scw6w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-3-seanjc@google.com>
 <CABgObfbtPJ6AAX9GnjNscPRTbNAOtamdxX677kx_r=zd4scw6w@mail.gmail.com>
Message-ID: <ZeDPgx1O_AuR2Iz3@google.com>
Subject: Re: [PATCH 02/16] KVM: x86: Remove separate "bit" defines for page
 fault error code masks
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024, Paolo Bonzini wrote:
> On Wed, Feb 28, 2024 at 3:46=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 60f21bb4c27b..e8b620a85627 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -213,7 +213,7 @@ static inline u8 permission_fault(struct kvm_vcpu *=
vcpu, struct kvm_mmu *mmu,
> >          */
> >         u64 implicit_access =3D access & PFERR_IMPLICIT_ACCESS;
> >         bool not_smap =3D ((rflags & X86_EFLAGS_AC) | implicit_access) =
=3D=3D X86_EFLAGS_AC;
> > -       int index =3D (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
> > +       int index =3D (pfec + (not_smap << ilog2(PFERR_RSVD_MASK))) >> =
1;
>=20
> Just use "(pfec + (not_smap ? PFERR_RSVD_MASK : 0)) >> 1".
>=20
> Likewise below, "pte_access & PT_USER_MASK ? PFERR_RSVD_MASK : 0"/
>=20
> No need to even check what the compiler produces, it will be either
> exactly the same code or a bunch of cmov instructions.

I couldn't resist :-)

The second one generates identical code, but for this one:

  int index =3D (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;

gcc generates almost bizarrely different code in the call from vcpu_mmio_gv=
a_to_gpa().
clang is clever enough to realize "pfec" can only contain USER_MASK and/or =
WRITE_MASK,
and so does a ton of dead code elimination and other optimizations.  But fo=
r some
reason, gcc doesn't appear to realize that, and generates a MOVSX when comp=
uting
"index", i.e. sign-extends the result of the ADD (at least, I think that's =
what it's
doing).

There's no actual bug today, and the vcpu_mmio_gva_to_gpa() path is super s=
afe
since KVM fully controls the error code.  But the call from FNAME(walk_addr=
_generic)
uses a _much_ more dynamic error code.

If an error code with unexpected bits set managed to get into permission_fa=
ult(),
I'm pretty sure we'd end up with out-of-bounds accesses.  KVM sanity checks=
 that
PK and RSVD aren't set,=20

	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));

but KVM unnecessarily uses an ADD instead of OR, here


	int index =3D (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;

and here

		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
		offset =3D (pfec & ~1) +
			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));

i.e. if the WARN fired, KVM would generate completely unexpected values due=
 to
adding two RSVD bit flags.

And if _really_ unexpected flags make their way into permission_fault(), e.=
g. the
upcoming RMP flag (bit 31) or Intel's SGX flag (bit 15), then the use of in=
dex

	fault =3D (mmu->permissions[index] >> pte_access) & 1;

could generate a read waaaya outside of the array.  It can't/shouldn't happ=
en in
practice since KVM shouldn't be trying to emulate RMP violations or faults =
in SGX
enclaves, but it's unnecessarily dangerous.

Long story short, I think we should get to the below (I'll post a separate =
series,
assuming I'm not missing something).

	unsigned long rflags =3D static_call(kvm_x86_get_rflags)(vcpu);
	unsigned int pfec =3D access & (PFERR_PRESENT_MASK |
				      PFERR_WRITE_MASK |
				      PFERR_USER_MASK |
				      PFERR_FETCH_MASK);

	/*
	 * For explicit supervisor accesses, SMAP is disabled if EFLAGS.AC =3D 1.
	 * For implicit supervisor accesses, SMAP cannot be overridden.
	 *
	 * SMAP works on supervisor accesses only, and not_smap can
	 * be set or not set when user access with neither has any bearing
	 * on the result.
	 *
	 * We put the SMAP checking bit in place of the PFERR_RSVD_MASK bit;
	 * this bit will always be zero in pfec, but it will be one in index
	 * if SMAP checks are being disabled.
	 */
	u64 implicit_access =3D access & PFERR_IMPLICIT_ACCESS;
	bool not_smap =3D ((rflags & X86_EFLAGS_AC) | implicit_access) =3D=3D X86_=
EFLAGS_AC;
	int index =3D (pfec | (not_smap ? PFERR_RSVD_MASK : 0)) >> 1;
	u32 errcode =3D PFERR_PRESENT_MASK;
	bool fault;

	kvm_mmu_refresh_passthrough_bits(vcpu, mmu);

	fault =3D (mmu->permissions[index] >> pte_access) & 1;

	/*
	 * Sanity check that no bits are set in the legacy #PF error code
	 * (bits 31:0) other than the supported permission bits (see above).
	 */
	WARN_ON_ONCE(pfec !=3D (unsigned int)access);

	if (unlikely(mmu->pkru_mask)) {
		u32 pkru_bits, offset;

		/*
		* PKRU defines 32 bits, there are 16 domains and 2
		* attribute bits per domain in pkru.  pte_pkey is the
		* index of the protection domain, so pte_pkey * 2 is
		* is the index of the first bit for the domain.
		*/
		pkru_bits =3D (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;

		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
		offset =3D (pfec & ~1) | (pte_access & PT_USER_MASK ? PFERR_RSVD_MASK : 0=
);

		pkru_bits &=3D mmu->pkru_mask >> offset;
		errcode |=3D -pkru_bits & PFERR_PK_MASK;
		fault |=3D (pkru_bits !=3D 0);
	}

	return -(u32)fault & errcode;

