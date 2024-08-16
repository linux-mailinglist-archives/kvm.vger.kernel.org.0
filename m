Return-Path: <kvm+bounces-24451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A19BC955306
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57D52287076
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 22:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A34144307;
	Fri, 16 Aug 2024 22:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l4wcb5Bk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1561313DBBE
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 22:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845816; cv=none; b=Umb2Xkl5CybI/zF929fneCAEAfHxZyBS77roEYbfl3zXOVaRDaXQJVnLwkB+sTSd63Ml3O4epgnKwVW/SGYJaDXU4hqj0ugNjXoKP54VIBxSzvwZGH9uqhek0bXPmxxQCwqNTJUkMo3kHmdj3GsEkRcy65W4XSIZGd8f+FRyoF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845816; c=relaxed/simple;
	bh=urfXUbAOu7E9g3v50QErvwDMupII/UkjeKbAyN6Ee0o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SKlnGMH4VzGEPRM13sqJP5uBNqXfQO6E/kQbaF7yTHe+SK+CFBUpiumQ52Xu/CFqbKn5A2+fkTCVrXoibPdpI0HcTTSakkUTXQgwAOwtwpp6ddmI+jsfNzjYm/PA5+TjXv3wb7ckDat38iocuGyq4cHYuxEeer427ElcPiurQlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l4wcb5Bk; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b44f75f886so6781467b3.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 15:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723845813; x=1724450613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=urfXUbAOu7E9g3v50QErvwDMupII/UkjeKbAyN6Ee0o=;
        b=l4wcb5BkQAYQ1DfaVqVw3Z0FgoqxXcflajoojzqgTqp/+o4NNqWDnagdAwaDTSxPp0
         gMftfcQOU/7xDjreJRievqrBfVJMGv+baVbmUTPPbYkiUdEOSV943ffJ8loisSZ01ERZ
         pNGnaHNPtNcdXUaRYg66ja9QCKJzG6HHhS175WCbbi6r9suPN4PTqKQwPgcy0ltHpJCt
         Tji0RdvzJ1/CRJaEfMmjddisoCTG8EU+cbvhlIPtSJK6LkY4sWIeu6OJioD5w6rEDVr8
         CZiH9eNLIEAHNFzl5e7xg3x+4Wo1XnaRZd1U/iqorrREnZ+JsZlctt1r0zLSW777rmaW
         Zjgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723845813; x=1724450613;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=urfXUbAOu7E9g3v50QErvwDMupII/UkjeKbAyN6Ee0o=;
        b=uSLAyJFctqXPhthqsLF0vh38Tjpi02InjZO1M4RQRdlr21Ax7Y7021942TIIo0o5s0
         /iHzCPJW2VjA2aTx59vBcgTl49SGEXWQJmmae07y9xrDgSJMDaWNczZrSfE4ej1fh6Vd
         Dx8ZtkLukXNIcjy4F0yOyNHRrMprztd+HK6Q2toNaIoJYifQZzodrmxQrizZNnWdXBDF
         /VrMv+XhaduA3gtAyPmxkNmMYw6mD+YvIkxrcztZhek6LRwqrkD5QP3KDQQ48Epb5y1s
         j6wPboASowsXiN4IX7GtUYRxaZI9WhMOMBP2simb6V7RwpejyMxB79Vr87ZGSitB87Q1
         21/A==
X-Gm-Message-State: AOJu0YykLCRFf8Ea1xvnTM+vonponiYNxDJTmQ0HswNI8CH4T88EcNVy
	frOfWaQoynH+7wj3cidnkQkffMdPZMwdzMriSxtKynF5cAHcpr0bR8FtFn88cnp5iz25mEfI3TX
	Rvw==
X-Google-Smtp-Source: AGHT+IGga5+2zHl5cUHcKwgjDnA98j6UFf8RXinc6Ui+a4Hm3pv+VnOhpcqlp1g4CIw05pB6mfFrQ7gsiYE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6784:b0:681:8b2d:81ae with SMTP id
 00721157ae682-6b1bb85ee4bmr1011737b3.9.1723845813082; Fri, 16 Aug 2024
 15:03:33 -0700 (PDT)
Date: Fri, 16 Aug 2024 15:03:31 -0700
In-Reply-To: <4d292a92016c65ae7521edec2cc0e9842c033e26.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240815123349.729017-1-mlevitsk@redhat.com> <20240815123349.729017-4-mlevitsk@redhat.com>
 <4d292a92016c65ae7521edec2cc0e9842c033e26.camel@redhat.com>
Message-ID: <Zr_Ms-7IpzINzmc7@google.com>
Subject: Re: [PATCH v3 3/4] KVM: nVMX: relax canonical checks on some x86
 registers in vmx host state
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024, mlevitsk@redhat.com wrote:
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> > =C2=A0arch/x86/kvm/vmx/nested.c | 30 +++++++++++++++++++++++-------
> > =C2=A01 file changed, 23 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 2392a7ef254d..3f18edff80ac 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2969,6 +2969,22 @@ static int nested_vmx_check_address_space_size(s=
truct kvm_vcpu *vcpu,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > =C2=A0}
> > =C2=A0
> > +static bool is_l1_noncanonical_address_static(u64 la, struct kvm_vcpu =
*vcpu)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u8 max_guest_address_bits =
=3D guest_can_use(vcpu, X86_FEATURE_LA57) ? 57 : 48;

I don't see any reason to use LA57 support from guest CPUID for the VMCS ch=
ecks.
The virtualization hole exists can't be safely plugged for all cases, so wh=
y
bother trying to plug it only for some cases?

It'd be very odd that an L1 could set a "bad" value via WRMSR, but then cou=
ldn't
load that same value on VM-Exit, e.g. if L1 gets the VMCS value by doing RD=
MSR.

> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Most x86 arch registers w=
hich contain linear addresses like
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * segment bases, addresses =
that are used in instructions (e.g SYSENTER),
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * have static canonicality =
checks,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * size of whose depends onl=
y on CPU's support for 5-level
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * paging, rather than state=
 of CR4.LA57.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * In other words the check =
only depends on the CPU model,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * rather than on runtime st=
ate.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return !__is_canonical_addre=
ss(la, max_guest_address_bits);
> > +}
> > +
> > =C2=A0static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 struct vmcs12 *vmcs12)
> > =C2=A0{
> > @@ -2979,8 +2995,8 @@ static int nested_vmx_check_host_state(struct kvm=
_vcpu *vcpu,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(!=
kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_noncanonical_addre=
ss(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_non=
canonical_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_l1_noncanonical_ad=
dress_static(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_=
noncanonical_address_static(vmcs12->host_ia32_sysenter_eip, vcpu)))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((vmcs12->vm_exit_co=
ntrols & VM_EXIT_LOAD_IA32_PAT) &&
> > @@ -3014,11 +3030,11 @@ static int nested_vmx_check_host_state(struct k=
vm_vcpu *vcpu,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(v=
mcs12->host_ss_selector =3D=3D 0 && !ia32e))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_noncanonical_addre=
ss(vmcs12->host_fs_base, vcpu)) ||
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_non=
canonical_address(vmcs12->host_gs_base, vcpu)) ||
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_non=
canonical_address(vmcs12->host_gdtr_base, vcpu)) ||
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_non=
canonical_address(vmcs12->host_idtr_base, vcpu)) ||
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_non=
canonical_address(vmcs12->host_tr_base, vcpu)) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_l1_noncanonical_ad=
dress_static(vmcs12->host_fs_base, vcpu)) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_=
noncanonical_address_static(vmcs12->host_gs_base, vcpu)) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_=
noncanonical_address_static(vmcs12->host_gdtr_base, vcpu)) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_=
noncanonical_address_static(vmcs12->host_idtr_base, vcpu)) ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_=
noncanonical_address_static(vmcs12->host_tr_base, vcpu)) ||

If loads via LTR, LLDT, and LGDT are indeed exempt, then we need to update
emul_is_noncanonical_address() too.

The best idea I have is to have a separate flow for system registers (not a=
 great
name, but I can't think of anything better), and the

E.g. s/is_host_noncanonical_msr_value/is_non_canonical_system_reg, and then
wire that up to the emulator.

> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(i=
s_noncanonical_address(vmcs12->host_rip, vcpu)))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > =C2=A0
>=20

