Return-Path: <kvm+bounces-50556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 887B1AE703D
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:00:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBB451BC3AE0
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91012E764C;
	Tue, 24 Jun 2025 19:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M52YSA1I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25942233704
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750795196; cv=none; b=RUr6S1NBj7PDr+cd6nwsnS650c+5lvvRSKgV1q560bR2pdpmppaLiBc8MLwn7I4nHoUDfuk8Tf18E0+/ctANjZhJ6XpnW+JPiXLay4NvsakVwUAJaDAwpDo+FIKU7nMjdcPq88+3Q6GZp+Fsn937rPIuEq4p5ta5nloB7fi6eHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750795196; c=relaxed/simple;
	bh=mP9VQIDVKNbxz3/RM9+uao0qvld1/BW66uz6N3bo6lQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XArmzadxSI/+H04HrHq2f4H8G5vgs3620EA2BoGi1u4njvzE2ymgXR/xTNm2Rad0qGNjLTDCOVfxaZs1yCo/1PEODHJnCW4SvYgfK0BcDsqp7NwO5Fv2mvFtMchp0/GikCK0ZkG+2+ysxSFLI+Sit3BNjirtE4HQn6f3XmM1smk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M52YSA1I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750795193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bwA93RS2PkxZGUaWWi0WskjZhCddj/P6rlWDzfBjtMo=;
	b=M52YSA1IBXilLxkuNJV29X9QheNZo2NoAzrabFiT9MCnF57B7GD1kyrBBxz5L7pkKq0aEo
	YoRCWdygWLn4iVfuHvDE+U/++dV1amBC0Yc7zmHr93tZw2Xl0V1KtroKg6TZkTwfEGb+mW
	F2M24ZwSEIthTKG4pA16mVNSpbZcRH8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-zQM6U51WMS-xWd6Bzh8p5w-1; Tue, 24 Jun 2025 15:59:51 -0400
X-MC-Unique: zQM6U51WMS-xWd6Bzh8p5w-1
X-Mimecast-MFC-AGG-ID: zQM6U51WMS-xWd6Bzh8p5w_1750795191
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4a587c85a60so18347921cf.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750795191; x=1751399991;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bwA93RS2PkxZGUaWWi0WskjZhCddj/P6rlWDzfBjtMo=;
        b=fHl3mDRV1LW0ry70IkYuP0Uwb81RWHdD3GHiYRvfmYn0Cy2FeYMUYiXYtBNetNB0xm
         uHKxFpWkj3m+JhlYyoGk+baWw38dqSaa8Y5034jbmT3U0/B0yN59nAuSrqpAbLnHZYJ/
         T0Lehf6A73TovNm6f1XhaVmQv8o5GCSUXC5jLr4sfaW7UbgbJy6G7ybN8s4fv5YgRP4T
         V5UL2fOFLyqBUiR6/SYWoN5XjkR1ihp1WYdl7nTGfd3hl3DADzxkrXlBioCszbwgGYpI
         ZVYAmbxpe3jESwG/mIKu7mEY4RuoekXUYQYlBA4h+KFHakDlKrsrQWKQwN2+2oiFmabf
         SIeA==
X-Gm-Message-State: AOJu0YwrDeHNlZAxNL8wfM0C9E4gDaW2LMcfPS9cZR+9VQ0mkuiuDmpN
	BcfTgqom8XP7B0ks+SDewnvaSfv9YAaEFmn+POGYh1OI5a1LHhWoTAynEIYoOf5OqWMInjUEjPu
	lAAVHzgjFlmNi863uj8bns+lZ+yRqgGAfeLWzFOprRy8Ble0YSOyFmQ==
X-Gm-Gg: ASbGncshNhXNHWfV6mR0haD5F3Yi9mwKZNVXdMRMpMQDz/gqlkhQgIZM90KXSzgqCDB
	u32RRoE99ycAkPUX2QoVALs42d2ksSJbKJxbliilmjU7K0WmQzSw+oLb12VRzB72XhEHOQRc7Pw
	8W+2eBAs69SovOHcbYR6XQ+3XOPZb0PeWQSxD7NRhIqYFzKzdEOcPF4AQdjSXgx5Izhvsc0auH+
	bEbX02prW+qRUcbZOp+l98eIrlXZDCgY0qhxq01V6aZ1O+8VWd9HDKLWmDIsLDEDL+7U0eZJ0bo
	F8Ww5Hxn19VAAiJzo8lhgYhpsRUkHiraem1VNtVSZIsLnv5yMrmto1JT+LkBzvvoGVUuSg==
X-Received: by 2002:ac8:5a93:0:b0:494:9455:5731 with SMTP id d75a77b69052e-4a7c05f4a68mr9289841cf.7.1750795190839;
        Tue, 24 Jun 2025 12:59:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHc8vNhpArdOmgW1D9C1Dlm2dA591RGo2HWO3tSzf8r6djtJ0soN1M2YATVDiqIMIzLFGmt+A==
X-Received: by 2002:ac8:5a93:0:b0:494:9455:5731 with SMTP id d75a77b69052e-4a7c05f4a68mr9289531cf.7.1750795190265;
        Tue, 24 Jun 2025 12:59:50 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a7807b9cbasm46024541cf.54.2025.06.24.12.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 12:59:49 -0700 (PDT)
Message-ID: <17b45add9debcc226f515e5d8bb31c508576fa1e.camel@redhat.com>
Subject: Re: [PATCH v6 8/8] KVM: VMX: Preserve host's
 DEBUGCTLMSR_FREEZE_IN_SMM while running the guest
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Adrian Hunter
	 <adrian.hunter@intel.com>
Date: Tue, 24 Jun 2025 15:59:49 -0400
In-Reply-To: <20250610232010.162191-9-seanjc@google.com>
References: <20250610232010.162191-1-seanjc@google.com>
	 <20250610232010.162191-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-06-10 at 16:20 -0700, Sean Christopherson wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
>=20
> Set/clear DEBUGCTLMSR_FREEZE_IN_SMM in GUEST_IA32_DEBUGCTL based on the
> host's pre-VM-Enter value, i.e. preserve the host's FREEZE_IN_SMM setting
> while running the guest.=C2=A0 When running with the "default treatment o=
f SMIs"
> in effect (the only mode KVM supports), SMIs do not generate a VM-Exit th=
at
> is visible to host (non-SMM) software, and instead transitions directly
> from VMX non-root to SMM.=C2=A0 And critically, DEBUGCTL isn't context sw=
itched
> by hardware on SMI or RSM, i.e. SMM will run with whatever value was
> resident in hardware at the time of the SMI.
>=20
> Failure to preserve FREEZE_IN_SMM results in the PMU unexpectedly countin=
g
> events while the CPU is executing in SMM, which can pollute profiling and
> potentially leak information into the guest.
>=20
> Check for changes in FREEZE_IN_SMM prior to every entry into KVM's inner
> run loop, as the bit can be toggled in IRQ context via IPI callback (SMP
> function call), by way of /sys/devices/cpu/freeze_on_smi.
>=20
> Add a field in kvm_x86_ops to communicate which DEBUGCTL bits need to be
> preserved, as FREEZE_IN_SMM is only supported and defined for Intel CPUs,
> i.e. explicitly checking FREEZE_IN_SMM in common x86 is at best weird, an=
d
> at worst could lead to undesirable behavior in the future if AMD CPUs eve=
r
> happened to pick up a collision with the bit.
>=20
> Exempt TDX vCPUs, i.e. protected guests, from the check, as the TDX Modul=
e
> owns and controls GUEST_IA32_DEBUGCTL.
>=20
> WARN in SVM if KVM_RUN_LOAD_DEBUGCTL is set, mostly to document that the
> lack of handling isn't a KVM bug (TDX already WARNs on any run_flag).
>=20
> Lastly, explicitly reload GUEST_IA32_DEBUGCTL on a VM-Fail that is missed
> by KVM but detected by hardware, i.e. in nested_vmx_restore_host_state().
> Doing so avoids the need to track host_debugctl on a per-VMCS basis, as
> GUEST_IA32_DEBUGCTL is unconditionally written by prepare_vmcs02() and
> load_vmcs12_host_state().=C2=A0 For the VM-Fail case, even though KVM won=
't
> have actually entered the guest, vcpu_enter_guest() will have run with
> vmcs02 active and thus could result in vmcs01 being run with a stale valu=
e.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> =C2=A0arch/x86/include/asm/kvm_host.h |=C2=A0 7 +++++++
> =C2=A0arch/x86/kvm/vmx/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 2 ++
> =C2=A0arch/x86/kvm/vmx/nested.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 3 +++
> =C2=A0arch/x86/kvm/vmx/vmx.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 3 +++
> =C2=A0arch/x86/kvm/vmx/vmx.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 15 ++++++++++++++-
> =C2=A0arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 14 ++++++++++++--
> =C2=A06 files changed, 41 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 3d6325369a4b..e59527dd5a0b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1676,6 +1676,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest=
_mode_logical)
> =C2=A0enum kvm_x86_run_flags {
> =C2=A0	KVM_RUN_FORCE_IMMEDIATE_EXIT	=3D BIT(0),
> =C2=A0	KVM_RUN_LOAD_GUEST_DR6		=3D BIT(1),
> +	KVM_RUN_LOAD_DEBUGCTL		=3D BIT(2),
> =C2=A0};
> =C2=A0
> =C2=A0struct kvm_x86_ops {
> @@ -1706,6 +1707,12 @@ struct kvm_x86_ops {
> =C2=A0	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
> =C2=A0	void (*vcpu_put)(struct kvm_vcpu *vcpu);
> =C2=A0
> +	/*
> +	 * Mask of DEBUGCTL bits that are owned by the host, i.e. that need to
> +	 * match the host's value even while the guest is active.
> +	 */
> +	const u64 HOST_OWNED_DEBUGCTL;
> +
> =C2=A0	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
> =C2=A0	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
> =C2=A0	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index c85cbce6d2f6..4a6d4460f947 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -915,6 +915,8 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
> =C2=A0	.vcpu_load =3D vt_op(vcpu_load),
> =C2=A0	.vcpu_put =3D vt_op(vcpu_put),
> =C2=A0
> +	.HOST_OWNED_DEBUGCTL =3D DEBUGCTLMSR_FREEZE_IN_SMM,
> +
> =C2=A0	.update_exception_bitmap =3D vt_op(update_exception_bitmap),
> =C2=A0	.get_feature_msr =3D vmx_get_feature_msr,
> =C2=A0	.get_msr =3D vt_op(get_msr),
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9edce9f411a3..756c42e2d038 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4860,6 +4860,9 @@ static void nested_vmx_restore_host_state(struct kv=
m_vcpu *vcpu)
> =C2=A0			WARN_ON(kvm_set_dr(vcpu, 7, vmcs_readl(GUEST_DR7)));
> =C2=A0	}
> =C2=A0
> +	/* Reload DEBUGCTL to ensure vmcs01 has a fresh FREEZE_IN_SMM value. */
> +	vmx_reload_guest_debugctl(vcpu);
> +
> =C2=A0	/*
> =C2=A0	 * Note that calling vmx_set_{efer,cr0,cr4} is important as they
> =C2=A0	 * handle a variety of side effects to KVM's software model.
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 196f33d934d3..70a115d99530 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7371,6 +7371,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 =
run_flags)
> =C2=A0	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
> =C2=A0		set_debugreg(vcpu->arch.dr6, 6);
> =C2=A0
> +	if (run_flags & KVM_RUN_LOAD_DEBUGCTL)
> +		vmx_reload_guest_debugctl(vcpu);
> +
> =C2=A0	/*
> =C2=A0	 * Refresh vmcs.HOST_CR3 if necessary.=C2=A0 This must be done imm=
ediately
> =C2=A0	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any=
 time
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index c20a4185d10a..076af78af151 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -419,12 +419,25 @@ bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u=
64 data, bool host_initiated)
> =C2=A0
> =C2=A0static inline void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, =
u64 val)
> =C2=A0{
> +	WARN_ON_ONCE(val & DEBUGCTLMSR_FREEZE_IN_SMM);
> +
> +	val |=3D vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM;
> =C2=A0	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
> =C2=A0}
> =C2=A0
> =C2=A0static inline u64 vmx_guest_debugctl_read(void)
> =C2=A0{
> -	return vmcs_read64(GUEST_IA32_DEBUGCTL);
> +	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~DEBUGCTLMSR_FREEZE_IN_SMM;
> +}
> +
> +static inline void vmx_reload_guest_debugctl(struct kvm_vcpu *vcpu)
> +{
> +	u64 val =3D vmcs_read64(GUEST_IA32_DEBUGCTL);
> +
> +	if (!((val ^ vcpu->arch.host_debugctl) & DEBUGCTLMSR_FREEZE_IN_SMM))
> +		return;
> +
> +	vmx_guest_debugctl_write(vcpu, val & ~DEBUGCTLMSR_FREEZE_IN_SMM);
> =C2=A0}


Wouldn't it be better to use kvm_x86_ops.HOST_OWNED_DEBUGCTL here as well
to avoid logic duplication?

Besides this, everything else looks fine to me.


Best regards,
	Maxim Levitsky

> =C2=A0
> =C2=A0/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6742eb556d91..811f4db824ab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10779,7 +10779,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
> =C2=A0		dm_request_for_irq_injection(vcpu) &&
> =C2=A0		kvm_cpu_accept_dm_intr(vcpu);
> =C2=A0	fastpath_t exit_fastpath;
> -	u64 run_flags;
> +	u64 run_flags, debug_ctl;
> =C2=A0
> =C2=A0	bool req_immediate_exit =3D false;
> =C2=A0
> @@ -11051,7 +11051,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcp=
u)
> =C2=A0		set_debugreg(0, 7);
> =C2=A0	}
> =C2=A0
> -	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> +	/*
> +	 * Refresh the host DEBUGCTL snapshot after disabling IRQs, as DEBUGCTL
> +	 * can be modified in IRQ context, e.g. via SMP function calls.=C2=A0 I=
nform
> +	 * vendor code if any host-owned bits were changed, e.g. so that the
> +	 * value loaded into hardware while running the guest can be updated.
> +	 */
> +	debug_ctl =3D get_debugctlmsr();
> +	if ((debug_ctl ^ vcpu->arch.host_debugctl) & kvm_x86_ops.HOST_OWNED_DEB=
UGCTL &&
> +	=C2=A0=C2=A0=C2=A0 !vcpu->arch.guest_state_protected)
> +		run_flags |=3D KVM_RUN_LOAD_DEBUGCTL;
> +	vcpu->arch.host_debugctl =3D debug_ctl;
> =C2=A0
> =C2=A0	guest_timing_enter_irqoff();
> =C2=A0


