Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B68D41457C
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhIVJsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbhIVJsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 05:48:09 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AB3C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 02:46:40 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id z11so3651058oih.1
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 02:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OIWGcb3ySIbzUvZEkVKjXmhjf3rmY3nKuyetU4CzjHk=;
        b=SbYEAhzq2gf6n1hwHzCEghmk4IpldMK08xgALBOwSeiNC3Ut22UA+nBGyMYd6vJ+ub
         XkvIVCtmbThFbHAcFzC2kz7v1o2vdITxSDIFbXkHO0w3WfmFNZBBH2KblObThhpIKn2/
         x3lJLNkHhZRq3BE/iV+WRpNiYbV9SsFZynXrIeuQOfE1j2kDdYFusFT8mSjjrh8wQTbg
         Mt+p/buf4NzEqkLuETxqy01xNtCEmeKyUiPUrUo+mMrdP/I3FplmSjsEDarsFbFxrnM5
         2fr18gKX7HRdD7JLnC9c4FZG71b5i47PU63fqrRKIb4tQHeHF+dvbdFNztZp0TuvDWZK
         QVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OIWGcb3ySIbzUvZEkVKjXmhjf3rmY3nKuyetU4CzjHk=;
        b=kUEuEovXKyn0Dj3Ud0TPVQLNElYU3vuqIT8PfQfCJZmjsWJOnIFvv2/KrwvozZZlBC
         8F0ayxkJF+ON7s58kcneVHI5NxcsDXdNIR04phBBnbe5gU93IpJQ3diKW4o6XPOdir24
         2ICOHlkEP8faXJlgLOOU6ZZZjQlHK/Fl4o6KqaaSr7fdqtlNeQr6bW8bTMsDiGnSzTwV
         Tsa6TVYemnl3GaXQ6zLHfiHm1gPgqADzpy5hoek9cuh8tbr38LDGlcUnzygo9bfOq3wp
         vARfwbAPb6YmMXfqeG0klXtgNJewdVlQmU/HhelLcyY5Cr54fjb9nRW5uW9HhxZBEwLu
         jkwQ==
X-Gm-Message-State: AOAM5315LT6lcVfTHOfX1Lcnn69qwztJPzzvObt07OiA83ZQPiGf51Dy
        o+rM1mfDnGiHgGLI9xscm7H7kKfqQPIKgBIOF3noFw==
X-Google-Smtp-Source: ABdhPJzQgMRqz+FHAVYI/MoUTl2jANHq7OBjCFtIyPwr6vs67bf5nTuIucp8SSL9ew2ZTUq0q3A+UIKtRPwckjxFqQc=
X-Received: by 2002:aca:604:: with SMTP id 4mr296015oig.8.1632303999123; Wed,
 22 Sep 2021 02:46:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com> <20210827101609.2808181-5-tabba@google.com>
 <20210908122032.uhcjzoq3lxn3bv4r@gator>
In-Reply-To: <20210908122032.uhcjzoq3lxn3bv4r@gator>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 22 Sep 2021 10:46:03 +0100
Message-ID: <CA+EHjTwFWyZK01R_FQ5L7er91HTxqfyn9NFGk0K0cVsz=-bsUQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/8] KVM: arm64: Add trap handlers for protected VMs
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

> > +
> > +/*
> > + * No restrictions on instructions implemented in AArch64.
> > + */
> > +#define PVM_ID_AA64ISAR0_ALLOW (~0ULL)
> > +#define PVM_ID_AA64ISAR1_ALLOW (~0ULL)
>
> Hmm, I really like the explicit allow masks, but these are no longer
> explicit. Why not set just the safe, supported features like we do
> with the other registers? In fact, I feel it's a bit wrong to set the
> res0 fields for ID_AA64ISAR0.

I agree. Will make it explicit when I respin it.

> > +u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
> > +{
> > +     const struct kvm *kvm = (const struct kvm *) kern_hyp_va(vcpu->kvm);
>
> I didn't think checkpatch liked spaces after casts.

Will fix.

>
> > +     u64 set_mask = 0;
> > +     u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
> > +
> > +     if (!vcpu_has_sve(vcpu))
> > +             allow_mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
>
> I'm not sure why this is here. SVE is not set in PVM_ID_AA64PFR0_ALLOW
> and there's even a comment for PVM_ID_AA64ZFR0_ALLOW stating that SVE
> is not supported for protected VMs.

This is here just in case in the future SVE becomes allowed for
protected VMs, yet it's disbled via KVM feature config
(vcpu->arch.features.

> > +
> > +     set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
> > +             PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
> > +
> > +     /* Spectre and Meltdown mitigation in KVM */
> > +     set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2),
> > +                            (u64)kvm->arch.pfr0_csv2);
> > +     set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3),
> > +                            (u64)kvm->arch.pfr0_csv3);
> > +
> > +     return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
> > +}
> > +
> > +u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu)
> > +{
> > +     const struct kvm *kvm = (const struct kvm *) kern_hyp_va(vcpu->kvm);
> > +     u64 allow_mask = PVM_ID_AA64PFR1_ALLOW;
> > +
> > +     if (!kvm_has_mte(kvm))
> > +             allow_mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
>
> Again, I'm not sure why we're clearing bits we never set.

Same as above. In case it does get supported in the future both by the
system and allowed by pKVM, but disabled in KVM (vcpu->arch.features).


> > +u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu)
> > +{
> > +     u64 allow_mask = PVM_ID_AA64ISAR1_ALLOW;
> > +
> > +     if (!vcpu_has_ptrauth(vcpu))
> > +             allow_mask &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
> > +                             ARM64_FEATURE_MASK(ID_AA64ISAR1_API) |
> > +                             ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |
> > +                             ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
>
> So here, since PVM_ID_AA64ISAR1_ALLOW is ~0, we do actually clear bits
> when the vcpu doesn't support ptrauth. I presume the trap handling for
> ptrauth will be covered for protected VMs too when we don't clear them.

Yes, but similar to the cases above this is to future-proof against
allowing it for protected VMs in principle, but having it being
disabled in KVM.

> > +
> > +     return id_aa64isar1_el1_sys_val & allow_mask;
> > +}
> > +
> > +u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
> > +{
> > +     u64 set_mask =
> > +             get_restricted_features_unsigned(id_aa64mmfr0_el1_sys_val,
> > +             PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED);
>
> Rather than the above style, how about
>
>         u64 set_mask;
>
>         set_mask = get_restricted_features_unsigned(id_aa64mmfr0_el1_sys_val,
>                                                     PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED);
>
> which is a best effort at staying in 80 chars and definitely stays
> under 100, which is checkpatch's max. Alternatively, the local
> function get_restricted_features_unsigned could be named more tersely.

Will do.


> > +     /*
> > +      * No support for AArch32 guests, therefore, pKVM has no sanitized copy
> > +      * of AArch32 feature id registers.
> > +      */
> > +     BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1),
> > +                  PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) >
> > +                     ID_AA64PFR0_ELx_64BIT_ONLY);
>
> I'd prefer to blow the 80 char soft limit here and do
>
>                      PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) > ID_AA64PFR0_ELx_64BIT_ONLY);

Sure.

Thanks,
/fuad

> > +
> > +     /* Use 0 for architecturally "unknown" values. */
> > +     p->regval = 0;
> > +     return true;
> > +}
> > +
> > +/*
> > + * Accessor for AArch64 feature id registers.
> > + *
> > + * If access is allowed, set the regval to the protected VM's view of the
> > + * register and return true.
> > + * Otherwise, inject an undefined exception and return false.
> > + */
> > +static bool pvm_access_id_aarch64(struct kvm_vcpu *vcpu,
> > +                               struct sys_reg_params *p,
> > +                               const struct sys_reg_desc *r)
> > +{
> > +     if (p->is_write)
> > +             return undef_access(vcpu, p, r);
> > +
> > +     p->regval = read_id_reg(vcpu, r);
> > +     return true;
> > +}
> > +
> > +/* Mark the specified system register as an AArch32 feature id register. */
> > +#define AARCH32(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch32 }
> > +
> > +/* Mark the specified system register as an AArch64 feature id register. */
> > +#define AARCH64(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch64 }
> > +
> > +/* Mark the specified system register as not being handled in hyp. */
> > +#define HOST_HANDLED(REG) { SYS_DESC(REG), .access = NULL }
> > +
> > +/*
> > + * Architected system registers.
> > + * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> > + *
> > + * NOTE: Anything not explicitly listed here is *restricted by default*, i.e.,
> > + * it will lead to injecting an exception into the guest.
> > + */
> > +static const struct sys_reg_desc pvm_sys_reg_descs[] = {
> > +     /* Cache maintenance by set/way operations are restricted. */
> > +
> > +     /* Debug and Trace Registers are restricted. */
> > +
> > +     /* AArch64 mappings of the AArch32 ID registers */
> > +     /* CRm=1 */
> > +     AARCH32(SYS_ID_PFR0_EL1),
> > +     AARCH32(SYS_ID_PFR1_EL1),
> > +     AARCH32(SYS_ID_DFR0_EL1),
> > +     AARCH32(SYS_ID_AFR0_EL1),
> > +     AARCH32(SYS_ID_MMFR0_EL1),
> > +     AARCH32(SYS_ID_MMFR1_EL1),
> > +     AARCH32(SYS_ID_MMFR2_EL1),
> > +     AARCH32(SYS_ID_MMFR3_EL1),
> > +
> > +     /* CRm=2 */
> > +     AARCH32(SYS_ID_ISAR0_EL1),
> > +     AARCH32(SYS_ID_ISAR1_EL1),
> > +     AARCH32(SYS_ID_ISAR2_EL1),
> > +     AARCH32(SYS_ID_ISAR3_EL1),
> > +     AARCH32(SYS_ID_ISAR4_EL1),
> > +     AARCH32(SYS_ID_ISAR5_EL1),
> > +     AARCH32(SYS_ID_MMFR4_EL1),
> > +     AARCH32(SYS_ID_ISAR6_EL1),
> > +
> > +     /* CRm=3 */
> > +     AARCH32(SYS_MVFR0_EL1),
> > +     AARCH32(SYS_MVFR1_EL1),
> > +     AARCH32(SYS_MVFR2_EL1),
> > +     AARCH32(SYS_ID_PFR2_EL1),
> > +     AARCH32(SYS_ID_DFR1_EL1),
> > +     AARCH32(SYS_ID_MMFR5_EL1),
> > +
> > +     /* AArch64 ID registers */
> > +     /* CRm=4 */
> > +     AARCH64(SYS_ID_AA64PFR0_EL1),
> > +     AARCH64(SYS_ID_AA64PFR1_EL1),
> > +     AARCH64(SYS_ID_AA64ZFR0_EL1),
> > +     AARCH64(SYS_ID_AA64DFR0_EL1),
> > +     AARCH64(SYS_ID_AA64DFR1_EL1),
> > +     AARCH64(SYS_ID_AA64AFR0_EL1),
> > +     AARCH64(SYS_ID_AA64AFR1_EL1),
> > +     AARCH64(SYS_ID_AA64ISAR0_EL1),
> > +     AARCH64(SYS_ID_AA64ISAR1_EL1),
> > +     AARCH64(SYS_ID_AA64MMFR0_EL1),
> > +     AARCH64(SYS_ID_AA64MMFR1_EL1),
> > +     AARCH64(SYS_ID_AA64MMFR2_EL1),
> > +
> > +     HOST_HANDLED(SYS_SCTLR_EL1),
> > +     HOST_HANDLED(SYS_ACTLR_EL1),
> > +     HOST_HANDLED(SYS_CPACR_EL1),
> > +
> > +     HOST_HANDLED(SYS_RGSR_EL1),
> > +     HOST_HANDLED(SYS_GCR_EL1),
> > +
> > +     /* Scalable Vector Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_TTBR0_EL1),
> > +     HOST_HANDLED(SYS_TTBR1_EL1),
> > +     HOST_HANDLED(SYS_TCR_EL1),
> > +
> > +     HOST_HANDLED(SYS_APIAKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APIAKEYHI_EL1),
> > +     HOST_HANDLED(SYS_APIBKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APIBKEYHI_EL1),
> > +     HOST_HANDLED(SYS_APDAKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APDAKEYHI_EL1),
> > +     HOST_HANDLED(SYS_APDBKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APDBKEYHI_EL1),
> > +     HOST_HANDLED(SYS_APGAKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APGAKEYHI_EL1),
> > +
> > +     HOST_HANDLED(SYS_AFSR0_EL1),
> > +     HOST_HANDLED(SYS_AFSR1_EL1),
> > +     HOST_HANDLED(SYS_ESR_EL1),
> > +
> > +     HOST_HANDLED(SYS_ERRIDR_EL1),
> > +     HOST_HANDLED(SYS_ERRSELR_EL1),
> > +     HOST_HANDLED(SYS_ERXFR_EL1),
> > +     HOST_HANDLED(SYS_ERXCTLR_EL1),
> > +     HOST_HANDLED(SYS_ERXSTATUS_EL1),
> > +     HOST_HANDLED(SYS_ERXADDR_EL1),
> > +     HOST_HANDLED(SYS_ERXMISC0_EL1),
> > +     HOST_HANDLED(SYS_ERXMISC1_EL1),
> > +
> > +     HOST_HANDLED(SYS_TFSR_EL1),
> > +     HOST_HANDLED(SYS_TFSRE0_EL1),
> > +
> > +     HOST_HANDLED(SYS_FAR_EL1),
> > +     HOST_HANDLED(SYS_PAR_EL1),
> > +
> > +     /* Performance Monitoring Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_MAIR_EL1),
> > +     HOST_HANDLED(SYS_AMAIR_EL1),
> > +
> > +     /* Limited Ordering Regions Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_VBAR_EL1),
> > +     HOST_HANDLED(SYS_DISR_EL1),
> > +
> > +     /* GIC CPU Interface registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_CONTEXTIDR_EL1),
> > +     HOST_HANDLED(SYS_TPIDR_EL1),
> > +
> > +     HOST_HANDLED(SYS_SCXTNUM_EL1),
> > +
> > +     HOST_HANDLED(SYS_CNTKCTL_EL1),
> > +
> > +     HOST_HANDLED(SYS_CCSIDR_EL1),
> > +     HOST_HANDLED(SYS_CLIDR_EL1),
> > +     HOST_HANDLED(SYS_CSSELR_EL1),
> > +     HOST_HANDLED(SYS_CTR_EL0),
> > +
> > +     /* Performance Monitoring Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_TPIDR_EL0),
> > +     HOST_HANDLED(SYS_TPIDRRO_EL0),
> > +
> > +     HOST_HANDLED(SYS_SCXTNUM_EL0),
> > +
> > +     /* Activity Monitoring Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_CNTP_TVAL_EL0),
> > +     HOST_HANDLED(SYS_CNTP_CTL_EL0),
> > +     HOST_HANDLED(SYS_CNTP_CVAL_EL0),
> > +
> > +     /* Performance Monitoring Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_DACR32_EL2),
> > +     HOST_HANDLED(SYS_IFSR32_EL2),
> > +     HOST_HANDLED(SYS_FPEXC32_EL2),
> > +};
> > +
> > +/*
> > + * Handler for protected VM restricted exceptions.
> > + *
> > + * Inject an undefined exception into the guest and return true to indicate that
> > + * the hypervisor has handled the exit, and control should go back to the guest.
> > + */
> > +bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     __inject_undef(vcpu);
> > +     return true;
> > +}
> > +
> > +/*
> > + * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
> > + *
> > + * Returns true if the hypervisor has handled the exit, and control should go
> > + * back to the guest, or false if it hasn't.
> > + */
> > +bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     const struct sys_reg_desc *r;
> > +     struct sys_reg_params params;
> > +     unsigned long esr = kvm_vcpu_get_esr(vcpu);
> > +     int Rt = kvm_vcpu_sys_get_rt(vcpu);
> > +
> > +     params = esr_sys64_to_params(esr);
> > +     params.regval = vcpu_get_reg(vcpu, Rt);
> > +
> > +     r = find_reg(&params, pvm_sys_reg_descs, ARRAY_SIZE(pvm_sys_reg_descs));
> > +
> > +     /* Undefined access (RESTRICTED). */
> > +     if (r == NULL)
> > +             return kvm_handle_pvm_restricted(vcpu, exit_code);
> > +
> > +     /* Handled by the host (HOST_HANDLED) */
> > +     if (r->access == NULL)
> > +             return kvm_hyp_handle_sysreg(vcpu, exit_code);
> > +
> > +     /* Handled by hyp: skip instruction if instructed to do so. */
> > +     if (r->access(vcpu, &params, r))
> > +             __kvm_skip_instr(vcpu);
> > +
> > +     if (!params.is_write)
> > +             vcpu_set_reg(vcpu, Rt, params.regval);
> > +
> > +     return true;
> > +}
> > +
> > +/*
> > + * Handler for protected floating-point and Advanced SIMD accesses.
> > + *
> > + * Returns true if the hypervisor has handled the exit, and control should go
> > + * back to the guest, or false if it hasn't.
> > + */
> > +bool kvm_handle_pvm_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     /* Linux guests assume support for floating-point and Advanced SIMD. */
> > +     BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
> > +                             PVM_ID_AA64PFR0_ALLOW));
> > +     BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
> > +                             PVM_ID_AA64PFR0_ALLOW));
> > +
> > +     return kvm_hyp_handle_fpsimd(vcpu, exit_code);
> > +}
> > --
> > 2.33.0.259.gc128427fd7-goog
> >
>
> Thanks,
> drew
>
