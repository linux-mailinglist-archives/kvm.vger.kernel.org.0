Return-Path: <kvm+bounces-24886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 642A995CB37
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E41661F22A3F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 11:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3848118733D;
	Fri, 23 Aug 2024 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MFuOdjyo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209AE4F88C
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 11:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724411670; cv=none; b=X+1ikF5ukDCEe7TbHcv/fk7PH/Pqmols23rKZsyYrY3LailahipLBEghMG6cw2s4UVHepxXoLD6UA4i+LDpOwubaAQWlzMUzkRuub1gNIcFeVFEzRjSlkrQjujhxvsXHUZ2aEG2CGY70Tl1ARHRGCIz4jr8+OxauuJpuTMykcyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724411670; c=relaxed/simple;
	bh=vsMS/ZnAQ0CskAhs0EmegJwNPYR6rNO72dSYOc8fu8M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i9euzpNTfcBCL1TJ+OR1ey5/Gm7CJB9WIErs7pFsde0kbU5b26dw2i4i2uhhmzMDsk9VBXPFyCEYgsZituj6t7NcjTRbkry/YOCEg4HkvOdqJEDnc6wTkfke1M3LQbv0qO00HTcs35+yzIYm6oBmxXOhTB5u3sTqTS6SSweiZVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MFuOdjyo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724411666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AvgRNgUeNF/NQOhQ8w2WHxRiSwRZ5hZk/1rYUYrRUhM=;
	b=MFuOdjyodaVU0Szs5wX5xFpxIilbU6A+HdHGFdKlY9JEGAeENWjypvlg20i9miIOFP4Poz
	AajoxpdC5+CsIpPNt45v3gIirv1z0+G3gjjoHJGO9KcmPBJ6xc7+UZjieB2JHPWX+I+dMS
	p69wo5eg7s8dngIAPo1AWzEbAL12Nw4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-Mr5MtISJM8m34QZ62bLE1A-1; Fri, 23 Aug 2024 07:14:25 -0400
X-MC-Unique: Mr5MtISJM8m34QZ62bLE1A-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-428fb72245bso10664705e9.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 04:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724411664; x=1725016464;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AvgRNgUeNF/NQOhQ8w2WHxRiSwRZ5hZk/1rYUYrRUhM=;
        b=OHmpFGy1O9Yqk1wYHotJ2zmp5qn0+l5/4YrFnD/UX2McXyynl5YAKiiiPkxmz7CahT
         OD79kFsmuYMvdYHWUjDT73+m9ZFNhYq66lbEqQW5sf4OgoZWrtLweR05umlUKW3cQHU/
         /6Yxj7KN1huTeKe2J+5vgj0N5o4UIspt68WrrK6OCBWe1PCivKxpXpT9vZs0MvObK/4C
         N2Ik6Tots9J1vgBf+/4r8ns9GphS21ig4lzVSVh01GqCR6FbXonGTFGRBDFm4KZSHxhQ
         TBKbgiuDgb/NKdP0P3J7Mpxl/yDyLrHdJxXBQpkyZWgJEIDLj1qw40dU9lk6V3cvi+uC
         +mZw==
X-Gm-Message-State: AOJu0YyN21smjGd2ubvDn1CSGt8FZE9MnlVRo/ThU0mkWpI6m3/JT735
	MHBcQTKYbboXj/p1jCEL9JMvETHNZ/t3FOpjw9Fr3FnukN4XcU96QvNk/6PwZ3Ms3Wd2TuXvuD/
	HdNpQRRjabKIoBcyvWlXDnf2pDdcaqKAe62JmJcR0XJw1PI08Xw==
X-Received: by 2002:a05:600c:1d16:b0:428:b4a:7001 with SMTP id 5b1f17b1804b1-42ac38dfc60mr34868515e9.15.1724411664033;
        Fri, 23 Aug 2024 04:14:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKT1mg0ON9En57It764EyPFtnZKbhE1cyli+Fq7zjkAvDncnj3/kYXksD+WtitiWXj7RNjjQ==
X-Received: by 2002:a05:600c:1d16:b0:428:b4a:7001 with SMTP id 5b1f17b1804b1-42ac38dfc60mr34868325e9.15.1724411663414;
        Fri, 23 Aug 2024 04:14:23 -0700 (PDT)
Received: from intellaptop.lan ([2a06:c701:7783:7201:2e6e:4397:f7d8:1e47])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ac515a2a5sm56821365e9.20.2024.08.23.04.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 04:14:23 -0700 (PDT)
Message-ID: <8a88f4e6208803c52eba946313804f682dadc5ee.camel@redhat.com>
Subject: Re: [PATCH v3 1/4] KVM: x86: relax canonical check for some x86
 architectural msrs
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Chao Gao
 <chao.gao@intel.com>
Date: Fri, 23 Aug 2024 14:14:21 +0300
In-Reply-To: <ZsYQE3GsvcvoeJ0B@google.com>
References: <20240815123349.729017-1-mlevitsk@redhat.com>
	 <20240815123349.729017-2-mlevitsk@redhat.com> <Zr_JX1z8xWNAxHmz@google.com>
	 <fa69866979cdb8ad445d0dffe98d6158288af339.camel@redhat.com>
	 <0d41afa70bd97d399f71cf8be80854f13fe7286c.camel@redhat.com>
	 <ZsYQE3GsvcvoeJ0B@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=D0=A3 =D1=81=D1=80, 2024-08-21 =D1=83 09:04 -0700, Sean Christopherson =D0=
=BF=D0=B8=D1=88=D0=B5:
> > On Wed, Aug 21, 2024, mlevitsk@redhat.com=C2=A0wrote:
> > > > =D0=A3 =D0=B2=D1=82, 2024-08-20 =D1=83 15:13 +0300, mlevitsk@redhat=
.com=C2=A0=D0=BF=D0=B8=D1=88=D0=B5:
> > > > > > =D0=A3 =D0=BF=D1=82, 2024-08-16 =D1=83 14:49 -0700, Sean Christ=
opherson =D0=BF=D0=B8=D1=88=D0=B5:
> > > > > > > > > > > > > > On Thu, Aug 15, 2024, Maxim Levitsky wrote:
> > > > > > > > > > > > > > > > > > > > > > diff --git a/arch/x86/kvm/x86.c=
 b/arch/x86/kvm/x86.c
> > > > > > > > > > > > > > > > > > > > > > index ce7c00894f32..2e83f7d7459=
1 100644
> > > > > > > > > > > > > > > > > > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > > > > > > > > > > > > > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > > > > > > > > > > > > > > > > > @@ -302,6 +302,31 @@ const stru=
ct kvm_stats_header kvm_vcpu_stats_header =3D {
> > > > > > > > > > > > > > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(kvm_vcpu_stats_desc),
> > > > > > > > > > > > > > > > > > > > > > =C2=A0};
> > > > > > > > > > > > > > > > > > > > > > =C2=A0
> > > > > > > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > > > > > > +/*
> > > > > > > > > > > > > > > > > > > > > > + * Most x86 arch MSR values wh=
ich contain linear addresses like
> > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > Is it most, or all?=C2=A0 I'm guessing all?
> > > > > >=20
> > > > > > I can't be sure that all of them are like that - there could be=
 some
> > > > > > outliers that behave differently.
> > > > > >=20
> > > > > > One of the things my work at Intel taught me is that there is n=
othing
> > > > > > consistent in x86 spec, anything is possible and nothing can be=
 assumed.
> > > > > >=20
> > > > > > I dealt only with those msrs, that KVM checks for canonicality,=
 therefore I
> > > > > > use the word=C2=A0 'most'. There could be other msrs that are n=
ot known to me
> > > > > > and/or to KVM.
> > > > > >=20
> > > > > > I can write 'some' if you prefer.
> > > >=20
> > > > Hi,
> > > >=20
> > > >=20
> > > > So I did some more reverse engineering and indeed, 'some' is the ri=
ght word:
> >=20
> > Is it?=C2=A0 IIUC, we have yet to find an MSR that honors, CR4.LA57, i.=
e. it really
> > is "all", so far as we know.

This is more or less what I meant to say: I meant to say that I verified on=
ly 'some'
of the msrs/instructions, and for others I can't know,=C2=A0although it's l=
ikely that
indeed our theory is correct.

> >=20
> > > > I audited all places in KVM which check an linear address for being=
 canonical
> > > > and this is what I found:
> > > >=20
> > > > - MSR_IA32_BNDCFGS - since it is not supported on CPUs with 5 level=
 paging,
> > > > =C2=A0 its not possible to know what the hardware does.
> >=20
> > Heh, yeah, but I would be very surprised if MSR_IA32_BNDCFGS didn't fol=
low all
> > other system-ish MSRs.
> >=20
> > > > - MSR_IA32_DS_AREA: - Ignores CR4.LA57 as expected. Tested by booti=
ng into kernel
> > > > =C2=A0 with 5 level paging disabled and then using userspace 'wrmsr=
' program to
> > > > =C2=A0 set this msr.=C2=A0 I attached the bash script that I used
> > > >=20
> > > > - MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: - Exactly the sa=
me story,
> > > > =C2=A0 but for some reason the host doesn't suport (not even read) =
from
> > > > =C2=A0 MSR_IA32_RTIT_ADDR2_*, MSR_IA32_RTIT_ADDR3_*.=C2=A0 Probably=
 the system is not new
> > > > =C2=A0 enough for these.
> > > >=20
> > > > - invpcid instruction. It is exposed to the guest without intercept=
ion
> > > > =C2=A0 (unless !npt or !ept), and yes, it works just fine on 57-can=
onical address
> > > > =C2=A0 without CR4.LA57 set....
> >=20
> > Did you verify the behavior for the desciptor, the target, or both?=C2=
=A0 I assume
> > the memory operand, i.e. the address of the _descriptor_, honors CR4.LA=
57, but
> > the target within the descriptor does not.

I verified only the target address. I assume that memory fetches do have to=
 honor the CR.LA57.

> >=20
> > If that assumption is correct, then this code in vm_mmu_invalidate_addr=
() is broken,
> > as KVM actually needs to do a TLB flush if the address is canonical for=
 the vCPU
> > model, even if it's non-canonical for the current vCPU state.
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* It's actually a GPA =
for vcpu->arch.guest_mmu.=C2=A0 */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (mmu !=3D &vcpu->arc=
h.guest_mmu) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0/* INVLPG on a non-canonical address is a NOP ac=
cording to the SDM.=C2=A0 */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0if (is_noncanonical_address(addr, vcpu))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
return;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_x86_call(flush_tlb_gva)(vcpu, addr);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> >=20
> > Assuming INVPCID is indicative of how INVLPG and INVVPID behave (they a=
re nops if
> > the _target_ is non-canonical), then the code is broken for INVLPG and =
INVVPID.
> >=20
> > And I think it's probably a safe assumption that a TLB flush is needed.=
=C2=A0 E.g. the
> > primary (possible only?) use case for INVVPID with a linear address is =
to flush
> > TLB entries for a specific GVA=3D>HPA mapping, and honoring CR4.LA57 wo=
uld prevent
> > shadowing 5-level paging with a hypervisor that is using 4-level paging=
 for itself.

I also think so.

> >=20
> > > > - invvpid - this one belongs to VMX set, so technically its for nes=
ting
> > > > =C2=A0 although it is run by L1, it is always emulated by KVM, but =
still executed on
> > > > =C2=A0 the host just with different vpid, so I booted the host with=
out 5 level
> > > > =C2=A0 paging, and patched KVM to avoid canonical check.
> > > >=20
> > > > =C2=A0 Also 57-canonical adddress worked just fine, and fully non c=
anonical
> > > > =C2=A0 address failed.=C2=A0 and gave a warning in 'invvpid_error'
> > > >=20
> > > > Should I fix all of these too?
> >=20
> > Yeah, though I believe we're at the point where we need to figure out a=
 better
> > naming scheme, because usage of what is currently is_noncanonical_addre=
ss() will
> > be, by far, in the minority.

Yes, I will take this into account.

> >=20
> > Hmm, actually, what if we extend the X86EMUL_F_* flags that were added =
for LAM
> > (and eventually for LASS) to handle the non-canonical checks?=C2=A0 Tha=
t's essentially
> > what LAM does already, there are just a few more flavors we now need to=
 handle.
> >=20
> > E.g. I think we just need flags for MSRs and segment/DT bases.=C2=A0 Th=
e only (or at
> > least, most) confusing thing is that LAM/LASS do NOT apply to INVPLG ac=
cesses,
> > but are exempt from LA57.=C2=A0 But that's an arch oddity, not a proble=
m KVM can solve.
> >=20
> > diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> > index 55a18e2f2dcd..6da03a37bdd5 100644
> > --- a/arch/x86/kvm/kvm_emulate.h
> > +++ b/arch/x86/kvm/kvm_emulate.h
> > @@ -94,6 +94,8 @@ struct x86_instruction_info {
> > =C2=A0#define X86EMUL_F_FETCH=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BIT(1)
> > =C2=A0#define X86EMUL_F_IMPLICIT=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BIT(2)
> > =C2=A0#define X86EMUL_F_INVLPG=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BIT(3)
> > +#define X86EMUL_F_MSR=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BIT(4)
> > +#define X86EMUL_F_BASE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BIT(5)
> > =C2=A0
> > =C2=A0struct x86_emulate_ops {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void (*vm_bugged)(struct x86=
_emulate_ctxt *ctxt);
> > ---
> >=20
> > And then with that, we can do the below, and have emul_is_noncanonical_=
address()
> > redirect to is_noncanonical_address() instead of being an open coded eq=
uivalent.
> >=20
> > ---
> > static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
> > {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return kvm_is_cr4_bit_s=
et(vcpu, X86_CR4_LA57) ? 57 : 48;
> > }
> >=20
> > static inline u8 max_host_virt_addr_bits(void)
> > {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return kvm_cpu_cap_has(=
X86_FEATURE_LA57) ? 57 : 48;
> > }

This is a good name for this function, thanks.

> >=20
> > static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcp=
u,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int flags)
> > {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (flags & (X86EMUL_F_=
INVLPG | X86EMUL_F_MSR | X86EMUL_F_DT_LOAD))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return !__is_canonical_address(la, max_host_virt=
_addr_bits());
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return !__is_canonical_address(la, vcpu_virt_add=
r_bits(vcpu));
> > }

This can work in principle, although are you OK with using these emulator f=
lags
outside of the emulator code?

I am asking because the is_noncanonical_address is used in various places a=
cross KVM.

> > ---
> >=20
> > That will make it _much_ harder to incorrectly use is_noncanonical_addr=
ess(),
> > as all callers will be forced to specify the emulation type, i.e. there=
 is no
> > automatic, implied default type.
> >=20
> > Line lengths could get annoying, but with per-type flags, we could do s=
electively
> > add a few wrappers, e.g.
> >=20
> > ---
> > static inline bool is_noncanonical_msr_address(u64 la, struct kvm_vcpu =
*vcpu)
> > {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return is_noncanonical_=
address(la, vcpu, X86EMUL_F_MSR);
> > }
> >=20
> > static inline bool is_noncanonical_base_address(u64 la, struct kvm_vcpu=
 *vcpu)
> > {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return is_noncanonical_=
address(la, vcpu, X86EMUL_F_BASE);
> > }
> >=20
> > static inline bool is_noncanonical_invlpg_address(u64 la, struct kvm_vc=
pu *vcpu)
> > {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return is_noncanonical_=
address(la, vcpu, X86EMUL_F_INVLPG);
> > }
> > ---
> >=20
> > We wouldn't want wrapper for everything, e.g. to minimize the risk of c=
reating a
> > de factor implicit default, but I think those three, and maybe a code/f=
etch
> > variant, will cover all but a few users.
> >=20
> > > > About fixing the emulator this is what see:
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0emul_is_noncanonica=
l_address
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__load_segment_descriptor
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0load_segment_descriptor
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0em_lldt
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0em_ltr
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0em_lgdt_lidt
> > > >=20
> > > >=20
> > > >=20
> > > > While em_lgdt_lidt should be easy to fix because it calls
> > > > emul_is_noncanonical_address directly,
> >=20
> > Those don't need to be fixed, they are validating the memory operand, n=
ot the
> > base of the descriptor, i.e. aren't exempt from CR4.LA57.

Are you sure?

em_lgdt_lidt reads its memory operands (and checks that it is canonical thr=
ough
linearize) with read_descriptor and that is fine because this is memory fet=
ch,=C2=A0
and then it checks that the base address within the operand is canonical.

This check needs to be updated, as it is possible to load non canonical GDT=
 and IDT
base via lgdt/lidt (I tested this).

For em_lldt, em_ltr, the check on the system segment descriptor base is
in __load_segment_descriptor:

...
 ret =3D linear_read_system(ctxt, desc_addr+8, &base3, sizeof(base3));
 if (ret !=3D X86EMUL_CONTINUE)
 return ret;
 if (emul_is_noncanonical_address(get_desc_base(&seg_desc) |
 ((u64)base3 << 32), ctxt))
 return emulate_gp(ctxt, err_code);

...


64 bases are possible only for system segments, which are
TSS, LDT, and call gates/IDT descriptors.


We don't emulate IDT fetches in protected mode, and as I found out the hard=
 way after
I wrote a unit test to do a call through a call gate, the emulator doesn't
support call gates either)

Thus I can safely patch __load_segment_descriptor.


> >=20
> > > > the em_lldt, em_ltr will be harder
> > > > because these use load_segment_descriptor which calls
> > > > __load_segment_descriptor which in turn is also used for emulating =
of far
> > > > jumps/calls/rets, for which I do believe that canonical check does =
respect
> > > > CR4.LA57, but can't be sure either.
> >=20
> > I'm fairly certain this is a non-issue.=C2=A0 CS, DS, ES, and SS have a=
 fixed base of
> > '0' in 64-bit mode, i.e. are completely exempt from canonical checks be=
cause the
> > base address is always ignored.=C2=A0 And while FS and GS do have base =
addresses, the
> > segment descriptors themselves can only load 32-bit bases, i.e. _can't_=
 generate
> > non-canonical addresses.

Yes - all data segments in 64 bit mode, still have 32 bit base in the GDT/L=
DT,
so this is indeed not an issue.

> >=20

> > There _is_ an indirect canonical check on the _descriptor_ (the actual =
descriptor
> > pointed at by the selector, not the memory operand).=C2=A0 The SDM is c=
alls this case
> > out in the LFS/LDS docs:
> >=20
> > =C2=A0 If the FS, or GS register is being loaded with a non-NULL segmen=
t selector and
> > =C2=A0 any of the following is true: the segment selector index is not =
within descriptor
> > =C2=A0 table limits, the memory address of the descriptor is non-canoni=
cal
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I tested that both ltr and lldt do ignore CR4.LA57 by loading from a descri=
ptor
which had a non canonical value and CR4.LA57 clear.

> > and similarly, when using a CALL GATE, the far transfer docs say:
> >=20
> > =C2=A0 If the segment descriptor from a 64-bit call gate is in non-cano=
nical space.

For the academic reference, when loading offset from a call gate descriptor=
,
the CPU does the canonical check, and it does honour the CR4.LA57.


A variation of the below test can prove it:

void set_callgate_entry(u16 sel, void *offset, int dpl)
{
	idt_entry_t *e =3D (idt_entry_t *)&gdt[sel >> 3];
	set_desc_entry(e, sizeof *e, offset, read_cs(), 12, dpl);
}

int main(int argc, char **argv)
{
	u64 gate_offset =3D (u64)&&gate_entry_point;

	// toggle below to check various cases:
	//setup_5level_page_table();
	//gate_offset =3D 0xff4547ceb1600000;

	set_callgate_entry(FIRST_SPARE_SEL, (void *)gate_offset, 0);

	struct { u64 offset; u16 sel; } call_target =3D
		{ 0 /* ignored */,
		  FIRST_SPARE_SEL};

	// Perform the far call
	asm volatile goto (
//	    KVM_FEP
	    ".byte 0x48; rex.w\n" // optional, just for fun
	    "lcall *%0\n"
	    "jmp %l1\n"
	:
	: "m" (call_target)
	:
	: return_address
	);

	gate_entry_point:
	printf("Call gate worked\n");

	asm volatile (
	     "retfq\n"
	);

	return_address:

	printf("Exit from call gate worked\n");
	return 0;
}



> >=20
> > And given that those implicit accesses are not subjected to LAM/LASS, I=
 strongly
> > suspect they honor CR4.LA57.=C2=A0 So the explicit emul_is_noncanonical=
_address()
> > check in __load_segment_descriptor() needs to be tagged X86EMUL_F_BASE,=
 but
> > otherwise it all should Just Work (knock wood).
> >=20
> > > > It is possible that far jumps/calls/rets also ignore CR4.LA57, and =
instead
> > > > set RIP to non canonical instruction, and then on first fetch, #GP =
happens.
> >=20
> > I doubt this is the case for the final RIP check, especially since ucod=
e does
> > check vmcs.HOST_RIP against vmcs.HOST_CR4.LA57, but it's worth testing =
to confirm.

See above.

So now I'll try to do a v4 of the patches with all of the feedback included=
.
Thanks!

> >=20
> > > > I'll setup another unit test for this. RIP of the #GP will determin=
e if the
> > > > instruction failed or the next fetch.
> >=20

Best regards,
	Maxim Levitsky



