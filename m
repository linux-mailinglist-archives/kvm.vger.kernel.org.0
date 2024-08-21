Return-Path: <kvm+bounces-24784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E28A895A25B
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 18:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11EC61C2279F
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B814714F9E1;
	Wed, 21 Aug 2024 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sf82RkzM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A5F14D2B4
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724256279; cv=none; b=Y7ZmkBIMajp/Ga7juaEoFdpWdES+18jqW96I+08UINhhLpurM5MP9YrUDlcg7c6+jIt26Ha4XK9r+m45se6hGG+iaoWpPg3n5gt/TztOR0JwgPhUnYJHtWqu+tJjj3XOnuXr72tgJNAsG1DqcST4kOsPzhF6s1P7ZbzsnjgtXAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724256279; c=relaxed/simple;
	bh=7l31PYljpMiUjDG7WoxzgPTDCdWuNg7HbPdeHlbWEZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aEfV5/KSVTlXKPHGEL/1qEgE33booQodrRY+x7uLb3SRR7TgHXt0HKVdjcNXtCt0jJ8E2MlqluR6p8kZJJVuWYIogtNAe09P/Pr3tGJUrwbYECXRDS3JJ5ZJ0nGJ2VK5LZ91lTDtIM/BEaCtzA34CkFTqLrGeI3Nb84bblUQn28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sf82RkzM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d392d311cso6052383b3a.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 09:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724256277; x=1724861077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AZweo51xHH5eMoQkU3hP1R6v8p8ciqpJ9NUUWtcbf/g=;
        b=Sf82RkzMYvIsnvAPt0YEwOLoSVyOqSS1M9AVpegvm662m9BD1tmetCaW3If+i4QwHC
         hrmH0iyB99IlzqNgCAXkc0yvPCMDsgSDYywm45Kk0gzUVGqd7tBU3gJH7syRM+9HmY/o
         tLE6e2lJRa4kan/pTWBfjL+VdRY36oPMGidtJlVcDZs/kVAkTA+Y1VVRUpeJyszJh9e0
         w6bDZ1o7nJOmp999FArYxad0p78X0wlAK/luZUjD8o5qZrN+vBzD47uk5nmW8Mhwap75
         XyxPAn2DCi98jAuWzsIC3GL6ZDHB3JbvNANQXBxjD9lAil7Kqnr6+n/g7wKhtENZs9wG
         dQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724256277; x=1724861077;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AZweo51xHH5eMoQkU3hP1R6v8p8ciqpJ9NUUWtcbf/g=;
        b=gKrGAMPqCqiqdTlQw9mRfjeoy7I781KB92nlWCdKlLE7s+PUYv7BZcZizFlryzbe9V
         nMbcQOmPF3VOC5xPmKqQLRViCzO5QWBz2k1w8RncZ1pt9k7NiCZlscCZ19kiY4gJixvO
         038t3eivWGCW6NRWLqOg1oaoxV0UXIfjtLGDsV1tsdulfr9zjbnDFwFKog/BYZdex9Po
         a21aH6cSfsrXoUQcKvq+2fZzkn/jtjkVruv28WHqhSe8SA3RCxq2pLMlW6PbzR7ojwzh
         E03H2/0IT1F9irYn4eOEh5QESLeY9taRuctpSU9Aw56xTE/PZ8iVraAalcWUqJ4MXCO8
         k+HA==
X-Gm-Message-State: AOJu0YwBes6WY+KXfARjWhFRldTDu2rOCak9i0j+6jxMCGOfUyoE4TbA
	pjZiUzk4nt7ZUU6xRa5y9nJuHADLQTDbDjteBm7neWzTPrH8UwtHG1PmQdj36k2fK3v/LI4akA8
	KWg==
X-Google-Smtp-Source: AGHT+IH6t5O4htIbaytL3GKHuhFX8d7u0Z4mDbKDKxiDftznLCincOQdd6grHbdENmxutCctT45WJo3jT98=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:87d0:0:b0:710:9d5e:268 with SMTP id
 d2e1a72fcca58-71423573f2bmr37705b3a.4.1724256277023; Wed, 21 Aug 2024
 09:04:37 -0700 (PDT)
Date: Wed, 21 Aug 2024 09:04:35 -0700
In-Reply-To: <0d41afa70bd97d399f71cf8be80854f13fe7286c.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240815123349.729017-1-mlevitsk@redhat.com> <20240815123349.729017-2-mlevitsk@redhat.com>
 <Zr_JX1z8xWNAxHmz@google.com> <fa69866979cdb8ad445d0dffe98d6158288af339.camel@redhat.com>
 <0d41afa70bd97d399f71cf8be80854f13fe7286c.camel@redhat.com>
Message-ID: <ZsYQE3GsvcvoeJ0B@google.com>
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

On Wed, Aug 21, 2024, mlevitsk@redhat.com wrote:
> =D0=A3 =D0=B2=D1=82, 2024-08-20 =D1=83 15:13 +0300, mlevitsk@redhat.com =
=D0=BF=D0=B8=D1=88=D0=B5:
> > =D0=A3 =D0=BF=D1=82, 2024-08-16 =D1=83 14:49 -0700, Sean Christopherson=
 =D0=BF=D0=B8=D1=88=D0=B5:
> > > > > > On Thu, Aug 15, 2024, Maxim Levitsky wrote:
> > > > > > > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > > > > > > index ce7c00894f32..2e83f7d74591 100644
> > > > > > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > > > > > @@ -302,6 +302,31 @@ const struct kvm_stats_header kvm_=
vcpu_stats_header =3D {
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 sizeof(kvm_vcpu_stats_desc),
> > > > > > > > > > =C2=A0};
> > > > > > > > > > =C2=A0
> > > > > > > > > > +
> > > > > > > > > > +/*
> > > > > > > > > > + * Most x86 arch MSR values which contain linear addre=
sses like
> > > > > >=20
> > > > > > Is it most, or all?=C2=A0 I'm guessing all?
> >=20
> > I can't be sure that all of them are like that - there could be some
> > outliers that behave differently.
> >=20
> > One of the things my work at Intel taught me is that there is nothing
> > consistent in x86 spec, anything is possible and nothing can be assumed=
.
> >=20
> > I dealt only with those msrs, that KVM checks for canonicality, therefo=
re I
> > use the word=C2=A0 'most'. There could be other msrs that are not known=
 to me
> > and/or to KVM.
> >=20
> > I can write 'some' if you prefer.
>=20
> Hi,
>=20
>=20
> So I did some more reverse engineering and indeed, 'some' is the right wo=
rd:

Is it?  IIUC, we have yet to find an MSR that honors, CR4.LA57, i.e. it rea=
lly
is "all", so far as we know.

> I audited all places in KVM which check an linear address for being canon=
ical
> and this is what I found:
>=20
> - MSR_IA32_BNDCFGS - since it is not supported on CPUs with 5 level pagin=
g,
>   its not possible to know what the hardware does.

Heh, yeah, but I would be very surprised if MSR_IA32_BNDCFGS didn't follow =
all
other system-ish MSRs.

> - MSR_IA32_DS_AREA: - Ignores CR4.LA57 as expected. Tested by booting int=
o kernel
>   with 5 level paging disabled and then using userspace 'wrmsr' program t=
o
>   set this msr.  I attached the bash script that I used
>=20
> - MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: - Exactly the same sto=
ry,
>   but for some reason the host doesn't suport (not even read) from
>   MSR_IA32_RTIT_ADDR2_*, MSR_IA32_RTIT_ADDR3_*.  Probably the system is n=
ot new
>   enough for these.
>
> - invpcid instruction. It is exposed to the guest without interception
>   (unless !npt or !ept), and yes, it works just fine on 57-canonical addr=
ess
>   without CR4.LA57 set....

Did you verify the behavior for the desciptor, the target, or both?  I assu=
me
the memory operand, i.e. the address of the _descriptor_, honors CR4.LA57, =
but
the target within the descriptor does not.

If that assumption is correct, then this code in vm_mmu_invalidate_addr() i=
s broken,
as KVM actually needs to do a TLB flush if the address is canonical for the=
 vCPU
model, even if it's non-canonical for the current vCPU state.

	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
	if (mmu !=3D &vcpu->arch.guest_mmu) {
		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
		if (is_noncanonical_address(addr, vcpu))
			return;

		kvm_x86_call(flush_tlb_gva)(vcpu, addr);
	}

Assuming INVPCID is indicative of how INVLPG and INVVPID behave (they are n=
ops if
the _target_ is non-canonical), then the code is broken for INVLPG and INVV=
PID.

And I think it's probably a safe assumption that a TLB flush is needed.  E.=
g. the
primary (possible only?) use case for INVVPID with a linear address is to f=
lush
TLB entries for a specific GVA=3D>HPA mapping, and honoring CR4.LA57 would =
prevent
shadowing 5-level paging with a hypervisor that is using 4-level paging for=
 itself.

> - invvpid - this one belongs to VMX set, so technically its for nesting
>   although it is run by L1, it is always emulated by KVM, but still execu=
ted on
>   the host just with different vpid, so I booted the host without 5 level
>   paging, and patched KVM to avoid canonical check.
>=20
>   Also 57-canonical adddress worked just fine, and fully non canonical
>   address failed.  and gave a warning in 'invvpid_error'
>
> Should I fix all of these too?

Yeah, though I believe we're at the point where we need to figure out a bet=
ter
naming scheme, because usage of what is currently is_noncanonical_address()=
 will
be, by far, in the minority.

Hmm, actually, what if we extend the X86EMUL_F_* flags that were added for =
LAM
(and eventually for LASS) to handle the non-canonical checks?  That's essen=
tially
what LAM does already, there are just a few more flavors we now need to han=
dle.

E.g. I think we just need flags for MSRs and segment/DT bases.  The only (o=
r at
least, most) confusing thing is that LAM/LASS do NOT apply to INVPLG access=
es,
but are exempt from LA57.  But that's an arch oddity, not a problem KVM can=
 solve.

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 55a18e2f2dcd..6da03a37bdd5 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -94,6 +94,8 @@ struct x86_instruction_info {
 #define X86EMUL_F_FETCH                BIT(1)
 #define X86EMUL_F_IMPLICIT             BIT(2)
 #define X86EMUL_F_INVLPG               BIT(3)
+#define X86EMUL_F_MSR                  BIT(4)
+#define X86EMUL_F_BASE                 BIT(5)
=20
 struct x86_emulate_ops {
        void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
---

And then with that, we can do the below, and have emul_is_noncanonical_addr=
ess()
redirect to is_noncanonical_address() instead of being an open coded equiva=
lent.

---
static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
{
	return kvm_is_cr4_bit_set(vcpu, X86_CR4_LA57) ? 57 : 48;
}

static inline u8 max_host_virt_addr_bits(void)
{
	return kvm_cpu_cap_has(X86_FEATURE_LA57) ? 57 : 48;
}

static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu,
					   unsigned int flags)
{
	if (flags & (X86EMUL_F_INVLPG | X86EMUL_F_MSR | X86EMUL_F_DT_LOAD))
		return !__is_canonical_address(la, max_host_virt_addr_bits());
	else
		return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
}
---

That will make it _much_ harder to incorrectly use is_noncanonical_address(=
),
as all callers will be forced to specify the emulation type, i.e. there is =
no
automatic, implied default type.

Line lengths could get annoying, but with per-type flags, we could do selec=
tively
add a few wrappers, e.g.

---
static inline bool is_noncanonical_msr_address(u64 la, struct kvm_vcpu *vcp=
u)
{
	return is_noncanonical_address(la, vcpu, X86EMUL_F_MSR);
}

static inline bool is_noncanonical_base_address(u64 la, struct kvm_vcpu *vc=
pu)
{
	return is_noncanonical_address(la, vcpu, X86EMUL_F_BASE);
}

static inline bool is_noncanonical_invlpg_address(u64 la, struct kvm_vcpu *=
vcpu)
{
	return is_noncanonical_address(la, vcpu, X86EMUL_F_INVLPG);
}
---

We wouldn't want wrapper for everything, e.g. to minimize the risk of creat=
ing a
de factor implicit default, but I think those three, and maybe a code/fetch
variant, will cover all but a few users.

> About fixing the emulator this is what see:
>=20
> 	emul_is_noncanonical_address
> 		__load_segment_descriptor
> 			load_segment_descriptor
> 				em_lldt
> 				em_ltr
>=20
> 		em_lgdt_lidt
>=20
>=20
>=20
> While em_lgdt_lidt should be easy to fix because it calls
> emul_is_noncanonical_address directly,

Those don't need to be fixed, they are validating the memory operand, not t=
he
base of the descriptor, i.e. aren't exempt from CR4.LA57.

> the em_lldt, em_ltr will be harder
> because these use load_segment_descriptor which calls
> __load_segment_descriptor which in turn is also used for emulating of far
> jumps/calls/rets, for which I do believe that canonical check does respec=
t
> CR4.LA57, but can't be sure either.

I'm fairly certain this is a non-issue.  CS, DS, ES, and SS have a fixed ba=
se of
'0' in 64-bit mode, i.e. are completely exempt from canonical checks becaus=
e the
base address is always ignored.  And while FS and GS do have base addresses=
, the
segment descriptors themselves can only load 32-bit bases, i.e. _can't_ gen=
erate
non-canonical addresses.

There _is_ an indirect canonical check on the _descriptor_ (the actual desc=
riptor
pointed at by the selector, not the memory operand).  The SDM is calls this=
 case
out in the LFS/LDS docs:

  If the FS, or GS register is being loaded with a non-NULL segment selecto=
r and
  any of the following is true: the segment selector index is not within de=
scriptor
  table limits, the memory address of the descriptor is non-canonical
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
and similarly, when using a CALL GATE, the far transfer docs say:

  If the segment descriptor from a 64-bit call gate is in non-canonical spa=
ce.

And given that those implicit accesses are not subjected to LAM/LASS, I str=
ongly
suspect they honor CR4.LA57.  So the explicit emul_is_noncanonical_address(=
)
check in __load_segment_descriptor() needs to be tagged X86EMUL_F_BASE, but
otherwise it all should Just Work (knock wood).

> It is possible that far jumps/calls/rets also ignore CR4.LA57, and instea=
d
> set RIP to non canonical instruction, and then on first fetch, #GP happen=
s.

I doubt this is the case for the final RIP check, especially since ucode do=
es
check vmcs.HOST_RIP against vmcs.HOST_CR4.LA57, but it's worth testing to c=
onfirm.

> I'll setup another unit test for this. RIP of the #GP will determine if t=
he
> instruction failed or the next fetch.

