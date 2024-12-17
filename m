Return-Path: <kvm+bounces-33980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E62049F50BD
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 17:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A4401884699
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696661F9F78;
	Tue, 17 Dec 2024 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eSVkFso7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFECE1F9ED8
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734451781; cv=none; b=MZ7/32m8/8jhbl2L7W5L8XBqQh3EuwctHDXv8McJn8Su+QJ7J2UwI1rzD1A4oSbwGzlruT1JO0H8hmSWPkmRfoKfKU1k9C6gk3m2Yiq01fUcb/yF+dZPthUJrQ/KdkxzDHtdyEjnZk2/hXh3Mihp8V2aa8VBrGjwsvBLC14yEZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734451781; c=relaxed/simple;
	bh=AUHAibl6LmWyGqegZDTu5mmsDmP79nEcSrJZYaTz0OQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=knn0ksMshtYoN+S4hOhoxqqeZRELdKTFqokeUXqwCbrPWBV7g2ErVzZ/c/+iC6JXPjOcK2cX6AVL7xxLAD950RUHmosDNrZDLCEntC4kyq0wswAm1+4P0Vw5lhK7n/7UL8freGMzQEdDXCI/p18BYLjRPRJpQdoz1Nl2zyICxDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eSVkFso7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216750b679eso42728085ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 08:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734451779; x=1735056579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=54Sw1Jao5VBLwDPEnZ+6h8TeFzmXdDRfRoFCKhwkt18=;
        b=eSVkFso7vsqOl4CAegmmZLqIUzcb7em6vGJgq0ftBNaqqnr/B01Eu0qq9R1Xe7e62j
         bjJLSQS6br9BXW9lPY94X7qV1u3draYLwn5JxwpxmR6VjKBcKnIVGJSp5T0NroO4MFXn
         4kDU/NNBI9J4UOAeGyPgD+J7T33c1uHsMIId4kvM+WIxWAhSrO1F+xd5FeUTiTyHk3Pd
         H8wi4LSpW4PKI05a4bCX3jCHWxQtuasOvPmjzsbXx8BlX7i4j2QxCnmoElIDOja2jYoN
         BVJZyBRfUZjjM4fJyNtpDuNESQOdTBMVkkfUGnU+lrdjpzTzLBnVdfE1t+KG90J5C29U
         uKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734451779; x=1735056579;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=54Sw1Jao5VBLwDPEnZ+6h8TeFzmXdDRfRoFCKhwkt18=;
        b=ULQp3jfv1WRy7ddZTJa/zAZTGhHQvTyDqviCIX8SmIpuxJIBhPiSHUhY8OPODnKehR
         eVW3PFqwygDXFyxRrCDd+x6cAfaR1SA6x3cQZTg+xBbfWneLYFxye25n5dVkZFMsgFvR
         zWngDoQfPTpWUcUn9oWzHDWfz5jz9L/xYtzWH6Tk2Q+5e2n8KsGHaPnyf/AuX2obKolZ
         OvuRRf4FOhGRcmECGVN3yhXeTdr4sy1+StEN2BOjKI1MOHcTOsydUh/p3njU0OTO2pR2
         bU+gLDbuNc2qPsonSKo2YD6lNCDz8ipVpEeMSCeVuxJdHfq5DDBPnHaUJpinOVDCfEWQ
         spYw==
X-Forwarded-Encrypted: i=1; AJvYcCV4TQ5j28o9ksHN+XdmERzilk3uxdISAIN6gyFDwT6GHEcOFRijzDF341v6fdWG+JtSvII=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA4wN1pKSZmyvgaMlP/JZic09Yoe5CfXpmY6HHvg/M5REfxzSk
	kQW5sBt58u/hibvwv3pfOvCXO+gKr+c6eT45TbjwH1c2jCZozss9J772Ikb7Zu7g9wVvkD4nRQx
	YVQ==
X-Google-Smtp-Source: AGHT+IFGW4xnbT7GEJRsMdRLjBb2HXcUtopADCWfn8m0hBimLFT+2wXmjhaBhFv9imn55YwyXy2b7EBwP5I=
X-Received: from plbko4.prod.google.com ([2002:a17:903:7c4:b0:216:3858:3176])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d50c:b0:216:2426:7666
 with SMTP id d9443c01a7336-2189298baccmr241898095ad.12.1734451779122; Tue, 17
 Dec 2024 08:09:39 -0800 (PST)
Date: Tue, 17 Dec 2024 08:09:37 -0800
In-Reply-To: <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com> <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
Message-ID: <Z2GiQS_RmYeHU09L@google.com>
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, yan.y.zhao@intel.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024, Adrian Hunter wrote:
> On 22/11/24 07:49, Chao Gao wrote:
> >> +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(vcpu->kvm);
> >> +
> >> +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> >> +	    kvm_host.xcr0 !=3D (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> >> +		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
> >> +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> >> +	    /* PT can be exposed to TD guest regardless of KVM's XSS support=
 */
> >> +	    kvm_host.xss !=3D (kvm_tdx->xfam &
> >> +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
> >> +			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)))
> >=20
> > Should we drop CET/PT from this series? I think they are worth a new
> > patch/series.
>=20
> This is not really about CET/PT
>=20
> What is happening here is that we are calculating the current
> MSR_IA32_XSS value based on the TDX Module spec which says the
> TDX Module sets MSR_IA32_XSS to the XSS bits from XFAM.  The
> TDX Module does that literally, from TDX Module source code:
>=20
> 	#define XCR0_SUPERVISOR_BIT_MASK            0x0001FD00
> and
> 	ia32_wrmsr(IA32_XSS_MSR_ADDR, xfam & XCR0_SUPERVISOR_BIT_MASK);
>=20
> For KVM, rather than:
>=20
> 			kvm_tdx->xfam &
> 			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
> 			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
>=20
> it would be more direct to define the bits and enforce them
> via tdx_get_supported_xfam() e.g.
>=20
> /*=20
>  * Before returning from TDH.VP.ENTER, the TDX Module assigns:
>  *   XCR0 to the TD=E2=80=99s user-mode feature bits of XFAM (bits 7:0, 9=
)
>  *   IA32_XSS to the TD's supervisor-mode feature bits of XFAM (bits 8, 1=
6:10)
>  */
> #define TDX_XFAM_XCR0_MASK	(GENMASK(7, 0) | BIT(9))
> #define TDX_XFAM_XSS_MASK	(GENMASK(16, 10) | BIT(8))
> #define TDX_XFAM_MASK		(TDX_XFAM_XCR0_MASK | TDX_XFAM_XSS_MASK)
>=20
> static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_c=
onf)
> {
> 	u64 val =3D kvm_caps.supported_xcr0 | kvm_caps.supported_xss;
>=20
> 	/* Ensure features are in the masks */
> 	val &=3D TDX_XFAM_MASK;
>=20
> 	if ((val & td_conf->xfam_fixed1) !=3D td_conf->xfam_fixed1)
> 		return 0;
>=20
> 	val &=3D td_conf->xfam_fixed0;
>=20
> 	return val;
> }
>=20
> and then:
>=20
> 	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> 	    kvm_host.xcr0 !=3D (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK))
> 		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
> 	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> 	    kvm_host.xss !=3D (kvm_tdx->xfam & TDX_XFAM_XSS_MASK))
> 		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
>=20
> >=20
> >> +		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
> >> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> >=20
> > How about using cpu_feature_enabled()? It is used in kvm_load_host_xsav=
e_state()
> > It handles the case where CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is no=
t
> > enabled.

I would rather just use kvm_load_host_xsave_state(), by forcing vcpu->arch.=
{xcr0,xss}
to XFAM, with a comment explaining that the TDX module sets XCR0 and XSS pr=
ior to
returning from VP.ENTER.  I don't see any justificaton for maintaining a sp=
ecial
flow for TDX, it's just more work.  E.g. TDX is missing the optimization to=
 elide
WRPKRU if the current value is the same as the host value.

KVM already disallows emulating a WRMSR to XSS via the tdx_has_emulated_msr=
()
check, and AFAICT there's no path for the guest to set KVM's view of XCR0, =
CR0,
or CR4, so I'm pretty sure stuffing state at vCPU creation is all that's ne=
eded.

That said, out of paranoia, KVM should disallow the guest from changing XSS=
 if
guest state is protected, i.e. in common code, as XSS is a mandatory passth=
rough
for SEV-ES+, i.e. XSS is fully guest-owned for both TDX and ES+.

Ditto for CR0 and CR4 (TDX only; SEV-ES+ lets the host see the guest values=
).
The current TDX code lets KVM read CR0 and CR4, but KVM will always see the=
 RESET
values, which are completely wrong for TDX.  KVM can obviously "work" witho=
ut a
sane view of guest CR0/CR4, but I think having a sane view will yield code =
that
is easier to maintain and understand, because almost all special casing wil=
l be
in TDX's initialization flow, not spread out wherever KVM needs to know tha=
t what
KVM sees in guest state is a lie.

The guest_state_protected check in kvm_load_host_xsave_state() needs to be =
moved
to svm_vcpu_run(), but IMO that's where the checks belong anyways, because =
not
restoring host state for protected guests is obviously specific to SEV-ES+ =
guests,
not to all protected guests.

Side topic, tdx_cache_reg() is ridiculous.  Just mark the "cached" register=
s as
available on exit.  Invoking a callback just to do nothing is a complete wa=
ste.
I'm also not convinced letting KVM read garbage for RIP, RSP, CR3, or PDPTR=
s is
at all reasonable.  CR3 and PDPTRs should be unreachable, and I gotta imagi=
ne the
same holds true for RSP.  Allow reads/writes to RIP is fine, in that it pro=
bably
simplifies the overall code.

Something like this (probably won't apply, I have other local hacks as the =
result
of suggestions).

---
 arch/x86/kvm/svm/svm.c     |  7 ++++--
 arch/x86/kvm/vmx/main.c    |  4 +--
 arch/x86/kvm/vmx/tdx.c     | 50 ++++++++++----------------------------
 arch/x86/kvm/vmx/x86_ops.h |  4 ---
 arch/x86/kvm/x86.c         | 15 +++++++-----
 5 files changed, 28 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc635655..63df43e5dcce 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4251,7 +4251,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_=
vcpu *vcpu,
 		svm_set_dr6(svm, DR6_ACTIVE_LOW);
=20
 	clgi();
-	kvm_load_guest_xsave_state(vcpu);
+
+	if (!vcpu->arch.guest_state_protected)
+		kvm_load_guest_xsave_state(vcpu);
=20
 	kvm_wait_lapic_expire(vcpu);
=20
@@ -4280,7 +4282,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_=
vcpu *vcpu,
 	if (unlikely(svm->vmcb->control.exit_code =3D=3D SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
=20
-	kvm_load_host_xsave_state(vcpu);
+	if (!vcpu->arch.guest_state_protected)
+		kvm_load_host_xsave_state(vcpu);
 	stgi();
=20
 	/* Any pending NMI will happen here */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 2742f2af7f55..d2e78e6675b9 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -520,10 +520,8 @@ static void vt_sync_dirty_debug_regs(struct kvm_vcpu *=
vcpu)
=20
 static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
-	if (is_td_vcpu(vcpu)) {
-		tdx_cache_reg(vcpu, reg);
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
 		return;
-	}
=20
 	vmx_cache_reg(vcpu, reg);
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7eff717c9d0d..b49dcf32206b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -636,6 +636,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0_guest_owned_bits =3D -1ul;
 	vcpu->arch.cr4_guest_owned_bits =3D -1ul;
=20
+	vcpu->arch.cr4 =3D <maximal value>;
+	vcpu->arch.cr0 =3D <maximal value, give or take>;
+
 	vcpu->arch.tsc_offset =3D kvm_tdx->tsc_offset;
 	vcpu->arch.l1_tsc_offset =3D vcpu->arch.tsc_offset;
 	/*
@@ -659,6 +662,14 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
=20
 	tdx->state =3D VCPU_TD_STATE_UNINITIALIZED;
=20
+	/*
+	 * On return from VP.ENTER, the TDX Module sets XCR0 and XSS to the
+	 * maximal values supported by the guest, so from KVM's perspective,
+	 * those are the guest's values at all times.
+	 */
+	vcpu->arch.ia32_xss =3D (kvm_tdx->xfam & XFEATURE_SUPERVISOR_MASK);
+	vcpu->arch.xcr0 =3D (kvm_tdx->xfam & XFEATURE_USE_MASK);
+
 	return 0;
 }
=20
@@ -824,24 +835,6 @@ static void tdx_user_return_msr_update_cache(struct kv=
m_vcpu *vcpu)
 		kvm_user_return_msr_update_cache(tdx_uret_tsx_ctrl_slot, 0);
 }
=20
-static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
-{
-	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(vcpu->kvm);
-
-	if (static_cpu_has(X86_FEATURE_XSAVE) &&
-	    kvm_host.xcr0 !=3D (kvm_tdx->xfam & kvm_caps.supported_xcr0))
-		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
-	if (static_cpu_has(X86_FEATURE_XSAVES) &&
-	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
-	    kvm_host.xss !=3D (kvm_tdx->xfam &
-			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
-			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)))
-		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
-		write_pkru(vcpu->arch.host_pkru);
-}
-
 static union vmx_exit_reason tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx =3D to_tdx(vcpu);
@@ -941,10 +934,10 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool f=
orce_immediate_exit)
 	tdx_vcpu_enter_exit(vcpu);
=20
 	tdx_user_return_msr_update_cache(vcpu);
-	tdx_restore_host_xsave_state(vcpu);
+	kvm_load_host_xsave_state(vcpu);
 	tdx->host_state_need_restore =3D true;
=20
-	vcpu->arch.regs_avail &=3D ~VMX_REGS_LAZY_LOAD_SET;
+	vcpu->arch.regs_avail =3D TDX_REGS_UNSUPPORTED_SET;
=20
 	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) =3D=3D TDX_SW_ERROR))
 		return EXIT_FASTPATH_NONE;
@@ -1963,23 +1956,6 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_da=
ta *msr)
 	}
 }
=20
-void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
-{
-	kvm_register_mark_available(vcpu, reg);
-	switch (reg) {
-	case VCPU_REGS_RSP:
-	case VCPU_REGS_RIP:
-	case VCPU_EXREG_PDPTR:
-	case VCPU_EXREG_CR0:
-	case VCPU_EXREG_CR3:
-	case VCPU_EXREG_CR4:
-		break;
-	default:
-		KVM_BUG_ON(1, vcpu->kvm);
-		break;
-	}
-}
-
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf =3D &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ef60eb7b1245..efa6723837c6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -145,8 +145,6 @@ bool tdx_has_emulated_msr(u32 index);
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
=20
-void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
-
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
=20
 int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
@@ -193,8 +191,6 @@ static inline bool tdx_has_emulated_msr(u32 index) { re=
turn false; }
 static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)=
 { return 1; }
 static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)=
 { return 1; }
=20
-static inline void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg) =
{}
-
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)=
 { return -EOPNOTSUPP; }
=20
 static inline int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f94b1e24eae..d380837433c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1184,11 +1184,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
=20
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.guest_state_protected)
-		return;
+	WARN_ON_ONCE(vcpu->arch.guest_state_protected);
=20
 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
-
 		if (vcpu->arch.xcr0 !=3D kvm_host.xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
=20
@@ -1207,9 +1205,6 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
=20
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.guest_state_protected)
-		return;
-
 	if (cpu_feature_enabled(X86_FEATURE_PKU) &&
 	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
@@ -3943,6 +3938,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct=
 msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
+
+		if (vcpu->arch.guest_state_protected)
+			return 1;
+
 		/*
 		 * KVM supports exposing PT to the guest, but does not support
 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
@@ -4402,6 +4401,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct=
 msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
+
+		if (vcpu->arch.guest_state_protected)
+			return 1;
+
 		msr_info->data =3D vcpu->arch.ia32_xss;
 		break;
 	case MSR_K7_CLK_CTL:

base-commit: 0319082fc23089f516618e193d94da18c837e35a
--=20

