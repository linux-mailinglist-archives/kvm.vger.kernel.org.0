Return-Path: <kvm+bounces-47315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91114ABFE0A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 22:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F3E17A1495
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 20:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB11129CB39;
	Wed, 21 May 2025 20:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z6SetwoO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF04129C355
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 20:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860215; cv=none; b=ZDh9L2jBtoE0pT05QzM99X326XU3oqHaEe+X/fhWSUEnkxZtW8N703jI8/TRtcVHb7gkxdFVWF8Une63Zm7ceH8nTIeBJYndagQhL2kCJKxHHcqv44uT0Xy6ZMl2L68d7shZhTIF2JwQHy+nqcoSnOpxpb8tXDZAi4f15Vdm2I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860215; c=relaxed/simple;
	bh=0ceGMOHptUyIy0ypOVSOmofHrFvCX+ASufP889K450c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z7QYAIfWsX4kkir27caz8lwnLJA6ZkuqmlBjAz0O88caawSJtr22sPte52YC9QjrgzdSPxZmwIbImP09RPqigAZWyo6uC5zTEZUv1mFGKQowxaCK/0+NRsofiOR0v/wPTPm1SE3UYDMkpM+7JJReQDXtJEfVH3WDvWdvu4ducDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z6SetwoO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747860212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5QhVuiYHXnMKTT9hZMGdfVh8tHp1Qoyqf1HjxLRFKog=;
	b=Z6SetwoO/4hNQ8tNcddDmiJISK5Qq6g9nmSMYm0fvJ3MjrTgRg7JRjAV7vaAuInTPKhboA
	Xs041XFsWsxhwclO68BbiN78m10px9bo0S5HDZwxxNQEiKn0TAd0PKk6DAUyTRIVmy2Nfr
	JFhO1gfGRPrqtdt5VwVy+qA/OErEzI8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-zbglCbMSMh-HKfK-_A_Y4A-1; Wed, 21 May 2025 16:43:28 -0400
X-MC-Unique: zbglCbMSMh-HKfK-_A_Y4A-1
X-Mimecast-MFC-AGG-ID: zbglCbMSMh-HKfK-_A_Y4A_1747860208
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c9255d5e8cso1228156285a.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 13:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747860208; x=1748465008;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5QhVuiYHXnMKTT9hZMGdfVh8tHp1Qoyqf1HjxLRFKog=;
        b=bRI2u2rGR9cLgkhebzfS7BS4o3SD1XWdzkC15RvfJB3U03f3uf3DirxxekkoazSeWO
         wKr+8NeRGhK3xHzB1yBUYC5TsJFeeNkodgMHVC6VstStl3AuKNzXGBku1j4E4KR1Skj6
         A2IzcUYJFrQHG6FFK90hFoo+3drb7xCoI3/9P0SUrNaZQbZq9D+/uIT/K/5WCbfaSVBQ
         E3QZ5oSNZwWVfOmLqx4iZQRJ0+HUvboqOkk1tjYS7fnLlam3Q1eLXlQV5JkEG/0Dma2C
         XhdZQ6hx/OaYG07DRY0aNnhLcQvE1VyGwb+OK3bwTIeUUdGGp13ZZwThCNGSBtvanH+S
         IWVw==
X-Gm-Message-State: AOJu0Yzyj3mw3qWjDvBkOWoVDi+6fRNJYhz5cCUEDXduKngamAzyy/TK
	tr8XY2F8TCX0AOOhwZlyh5CciPs2jYxbyDjZ/4qX2eKmpkkkMbdV1BoXJRC/IEeVFHpNBoGI+UV
	57hi444QhJWWgedSTx44uljoDSzBd63jZpx1kNrp/kKaE9wU+C7aAvg==
X-Gm-Gg: ASbGnct9vcDo0YhKw+irTVauhlKn8wOxiCJt8SQr4jWbWKawQvTviJluzW0vvw9E0Er
	6p3YkzkQ4tmOyeZ5obtWrxHthJ6FkcflnLyBUZcSGFzPEswZZSXdtWevjz5eUHEi2owYqGir5Rq
	XBwMaR9w+Aai43ihLxz6HMMUzy/b/g/Ekt18ZPDet9oeL2RYa1Gw7KgMQWDlD1TfLK4UCIiZUQQ
	bTE9/xPxHAjTv8LJGd6klRfCM+OH4AZHSHF1NvZrMT3e5AiKUcMOsvsdYoBt/jsHaKzHwobgDVM
	Jgy6M+meJ2oo2E6epK8jtdkmJlrwoiJ+zSYaAUZHHgm2YAII1w7FZY0KUAg=
X-Received: by 2002:a05:620a:454b:b0:7ca:f41d:ce06 with SMTP id af79cd13be357-7cd4673c0acmr3595566885a.31.1747860207940;
        Wed, 21 May 2025 13:43:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/vUkExQdWyMJBBGahe35PDZUdiPaA5CMO+SY75XRIorypUiCDgVaDI/XRxEABMXS/iSSM5g==
X-Received: by 2002:a05:620a:454b:b0:7ca:f41d:ce06 with SMTP id af79cd13be357-7cd4673c0acmr3595563885a.31.1747860207591;
        Wed, 21 May 2025 13:43:27 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd467bc2dbsm927205385a.15.2025.05.21.13.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 13:43:27 -0700 (PDT)
Message-ID: <24c39bb2f1e97ef2e6207894cb62e456bededce0.camel@redhat.com>
Subject: Re: [PATCH v4 4/4] x86: KVM: VMX: preserve DEBUGCTLMSR_FREEZE_IN_SMM
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav
 Petkov <bp@alien8.de>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 21 May 2025 16:43:26 -0400
In-Reply-To: <aC0IwYfNvuo_vUDU@google.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
	 <20250515005353.952707-5-mlevitsk@redhat.com> <aC0IwYfNvuo_vUDU@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-05-20 at 15:57 -0700, Sean Christopherson wrote:
> KVM: VMX:
>=20
> On Wed, May 14, 2025, Maxim Levitsky wrote:
> > Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the guest
> > GUEST_IA32_DEBUGCTL without the guest seeing this value.
> >=20
> > Since the value of the host DEBUGCTL can in theory change between VM ru=
ns,
> > check if has changed, and if yes, then reload the GUEST_IA32_DEBUGCTL w=
ith
> > the new value.
>=20
> Please split this into two patches.=C2=A0 Add vmx_guest_debugctl_{read,wr=
ite}(), then
> land the FREEZE_IN_SMM change on top.=C2=A0 Adding the helpers should be =
a nop and
> thus trivial to review, and similarly the DEBUGCTLMSR_FREEZE_IN_SMM chang=
e is
> actually pretty small.=C2=A0 But combined, this patch is annoying to revi=
ew because
> there's a lot of uninteresting diff to wade through to get at the FREEZE_=
IN_SMM
> logic.

No problem.

>=20
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> > =C2=A0arch/x86/include/asm/kvm_host.h |=C2=A0 1 +
> > =C2=A0arch/x86/kvm/vmx/nested.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 4 ++--
> > =C2=A0arch/x86/kvm/vmx/vmx.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 22 +++++++++++++++++++---
> > =C2=A0arch/x86/kvm/vmx/vmx.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 2 ++
> > =C2=A0arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 +++++--
> > =C2=A05 files changed, 29 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index d2ad31a1628e..2e7e4a8b392e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1673,6 +1673,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool de=
st_mode_logical)
> > =C2=A0enum kvm_x86_run_flags {
> > =C2=A0	KVM_RUN_FORCE_IMMEDIATE_EXIT	=3D BIT(0),
> > =C2=A0	KVM_RUN_LOAD_GUEST_DR6		=3D BIT(1),
> > +	KVM_RUN_LOAD_DEBUGCTL		=3D BIT(2),
> > =C2=A0};
> > =C2=A0
> > =C2=A0struct kvm_x86_ops {
>=20
> ...
>=20
> > @@ -7368,6 +7381,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u6=
4 run_flags)
> > =C2=A0	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
> > =C2=A0		set_debugreg(vcpu->arch.dr6, 6);
> > =C2=A0
> > +	if (run_flags & KVM_RUN_LOAD_DEBUGCTL)
> > +		vmx_guest_debugctl_write(vcpu, vmx_guest_debugctl_read());
> > +
> > =C2=A0	/*
> > =C2=A0	 * Refresh vmcs.HOST_CR3 if necessary.=C2=A0 This must be done i=
mmediately
> > =C2=A0	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) a=
ny time
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 1b80479505d3..5ddedf73392b 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -416,6 +416,8 @@ static inline void vmx_set_intercept_for_msr(struct=
 kvm_vcpu *vcpu, u32 msr,
> > =C2=A0
> > =C2=A0void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
> > =C2=A0u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_i=
nitiated);
> > +void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val);
> > +u64 vmx_guest_debugctl_read(void);
>=20
> I vote to make these static inlines, I don't see any reason to bury them =
in vmx.c

No problem as well.

>=20
> > =C2=A0/*
> > =C2=A0 * Note, early Intel manuals have the write-low and read-high bit=
map offsets
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 684b8047e0f2..a85078dfa36d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10752,7 +10752,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu)
> > =C2=A0		dm_request_for_irq_injection(vcpu) &&
> > =C2=A0		kvm_cpu_accept_dm_intr(vcpu);
> > =C2=A0	fastpath_t exit_fastpath;
> > -	u64 run_flags;
> > +	u64 run_flags, host_debug_ctl;
> > =C2=A0
> > =C2=A0	bool req_immediate_exit =3D false;
> > =C2=A0
> > @@ -11024,7 +11024,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *v=
cpu)
> > =C2=A0		set_debugreg(0, 7);
> > =C2=A0	}
> > =C2=A0
> > -	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > +	host_debug_ctl =3D get_debugctlmsr();
>=20
> This can probably just be debug_ctl to shorten the lines, I don't see a s=
trong
> need to clarify it's the host's value since all accesses are clustered to=
gether.
>=20
> > +	if (host_debug_ctl !=3D vcpu->arch.host_debugctl)
> > +		run_flags |=3D KVM_RUN_LOAD_DEBUGCTL;
> > +	vcpu->arch.host_debugctl =3D host_debug_ctl;
>=20
> Argh, the TDX series didn't get refreshed (or maybe it got poorly rebased=
), and
> now there's a redundant and confusing "host_debugctlmsr" field in vcpu_vt=
.=C2=A0 Can
> you slot in the below?=C2=A0 It's not urgent enough to warrant posting se=
parately,
> and handling TDX in this series would get a bit wonky if TDX uses a diffe=
rent
> snapshot.
>=20
> The reason I say that TDX will get wonky is also why I think the "are bit=
s
> changing?" check in x86.c needs to be precise.=C2=A0 KVM_RUN_LOAD_DEBUGCT=
L should
> *never* be set for TDX and SVM, and so they should WARN instead of silent=
ly
> doing nothing.=C2=A0 But to do that without generating false positives, t=
he common
> check needs to be precise.
>=20
> I was going to say we could throw a mask in kvm_x86_ops, but TDX throws a=
 wrench
> in that idea.=C2=A0 Aha!=C2=A0 Actually, we can still use kvm_x86_ops.=C2=
=A0 TDX can be exempted
> via guest_state_protected.=C2=A0 E.g. in common x86:
>=20
> 	debug_ctl =3D get_debugctlmsr();
> 	if (((debug_ctl ^ vcpu->arch.host_debugctl) & kvm_x86_ops.HOST_DEBUGCTL_=
MASK) &&
> 	=C2=A0=C2=A0=C2=A0 !vcpu->arch.guest_state_protected)
> 		run_flags |=3D KVM_RUN_LOAD_DEBUGCTL;
> 	vcpu->arch.host_debugctl =3D debug_ctl;

Makes sense. I need to remember that TDX has arrived so I have to take it
in the account from now on.

All right, thanks for the review, I will post a new patch series soon.


Best regards,
	Maxim Levitsky

>=20
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 20 May 2025 15:37:41 -0700
> Subject: [PATCH] KVM: TDX: Use kvm_arch_vcpu.host_debugctl to restore the
> =C2=A0host's DEBUGCTL
>=20
> Use the kvm_arch_vcpu.host_debugctl snapshot to restore DEBUGCTL after
> running a TD vCPU.=C2=A0 The final TDX series rebase was mishandled, like=
ly due
> to commit fb71c7959356 ("KVM: x86: Snapshot the host's DEBUGCTL in common
> x86") deleting the same line of code from vmx.h, i.e. creating a semantic
> conflict of sorts, but no syntactic conflict.
>=20
> Using the version in kvm_vcpu_arch picks up the ulong =3D> u64 fix (which
> isn't relevant to TDX) as well as the IRQ fix from commit 189ecdb3e112
> ("KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs").
>=20
> Link: https://lore.kernel.org/all/20250307212053.2948340-10-pbonzini@redh=
at.com
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: 8af099037527 ("KVM: TDX: Save and restore IA32_DEBUGCTL")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> =C2=A0arch/x86/kvm/vmx/common.h | 2 --
> =C2=A0arch/x86/kvm/vmx/tdx.c=C2=A0=C2=A0=C2=A0 | 6 ++----
> =C2=A02 files changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 8f46a06e2c44..66454bead202 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -53,8 +53,6 @@ struct vcpu_vt {
> =C2=A0#ifdef CONFIG_X86_64
> =C2=A0	u64		msr_host_kernel_gs_base;
> =C2=A0#endif
> -
> -	unsigned long	host_debugctlmsr;
> =C2=A0};
> =C2=A0
> =C2=A0#ifdef CONFIG_KVM_INTEL_TDX
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 7dbfad28debc..84b2922b8119 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -778,8 +778,6 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcp=
u)
> =C2=A0	else
> =C2=A0		vt->msr_host_kernel_gs_base =3D read_msr(MSR_KERNEL_GS_BASE);
> =C2=A0
> -	vt->host_debugctlmsr =3D get_debugctlmsr();
> -
> =C2=A0	vt->guest_state_loaded =3D true;
> =C2=A0}
> =C2=A0
> @@ -1056,8 +1054,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 =
run_flags)
> =C2=A0
> =C2=A0	tdx_vcpu_enter_exit(vcpu);
> =C2=A0
> -	if (vt->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
> -		update_debugctlmsr(vt->host_debugctlmsr);
> +	if (vcpu->arch.host_debugctl & ~TDX_DEBUGCTL_PRESERVED)
> +		update_debugctlmsr(vcpu->arch.host_debugctl);
> =C2=A0
> =C2=A0	tdx_load_host_xsave_state(vcpu);
> =C2=A0	tdx->guest_entered =3D true;
>=20
> base-commit: 475a02020ac2de6b10e85de75e79833139b556e0
> --
>=20


