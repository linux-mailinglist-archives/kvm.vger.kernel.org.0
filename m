Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F144DAAA6
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 07:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347833AbiCPGUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 02:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243543AbiCPGUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 02:20:10 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90279195
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 23:18:56 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z7so1286603iom.1
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 23:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PACq8sZgGskNO3fnwp6dU9qCu6yaAOSrnEDLI63iMFE=;
        b=ayr6Ny3qqaUmF6M5D2Aprf6cVgMvL0YY6KHUqgt+AxhumiTbhTrxNSR0xYp/TQ93Oh
         HIHJUva+G2a15irrUkgc/krIljD06D0BAE5jGRhZw9sUxUK35FK+IuPlmBqghzZzT+Lk
         3zvtpf/ISFNxo1QxVTya3RW1MuPgGyvPQe92I76l2fBUsrkS40gnJwZdSzomCB39Vnq5
         7zm0sQj8ZjmxkTvStcagHb9Zg4a2ej4iWUG0fGG3mWiLws/pjUG1eon7IAm0nxaKR2uJ
         KoqeK+Ac+dXuzJfkEs9H/3UL+TAR3+A4muCWhW7TNXtZkkaxGFCCt6uVC3IvsxGfT+ac
         pjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PACq8sZgGskNO3fnwp6dU9qCu6yaAOSrnEDLI63iMFE=;
        b=uuQTZJiPO+Nz0uB38S9w3GqaVWWC9jar7HJiVws1yEaBV2oPExlgoHcYZY7pWHtCqr
         OlJdUu9R3quEyJpFxE/qrM28hIUadvoiWWxHPahOA8/qbucRB6gABUHwwIRweGr4Z6ow
         Jn1oiWuL+KdnMscbVwCWjjSEslJbmRglfUz1n7seW8D/mdsI5jEqx58Z+Ttrjeyxp3zi
         XhoCPukR4++8/njd2PvV9+lRhJ28t8B8vIWNN8YEPqTrZBg434NScW4fKWeJyEVNroVw
         o+DJ/x/ATF+bDfbGCXd9LCIWj/464PcuIdLTckIh5ibKXk0cOSuR24Q1ygGThYmS8FGG
         apdg==
X-Gm-Message-State: AOAM531AP1VjZpsqerEevwD1jzWZsDa58P+O839t9T5SGOAxXZ/bFk/o
        rA6eP3hWkABXrJk4x/M8OUCF9Q==
X-Google-Smtp-Source: ABdhPJzM9S+XFaNxlDLu1I/Wfn6KYUBeidI4UxCsU2I05Xf4qmaU2lXCH9wIB4GsOczdBGKbCuG6Rw==
X-Received: by 2002:a6b:7b03:0:b0:648:40c7:309d with SMTP id l3-20020a6b7b03000000b0064840c7309dmr23596081iop.15.1647411535587;
        Tue, 15 Mar 2022 23:18:55 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id m11-20020a056e021c2b00b002c7c5e0e7ecsm707383ilh.60.2022.03.15.23.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 23:18:54 -0700 (PDT)
Date:   Wed, 16 Mar 2022 06:18:51 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v4 2/3] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
Message-ID: <YjGBS8JMLiyLqcYv@google.com>
References: <20220314061959.3349716-1-reijiw@google.com>
 <20220314061959.3349716-3-reijiw@google.com>
 <Yi+j7zGxA80ZR4t7@google.com>
 <27834312-1877-f244-634d-6e645dea9f9e@google.com>
 <CAOQ_Qsgw9iUPBA7o_reEbt96NDgVHit46_b_UozyNtNzFaFnHw@mail.gmail.com>
 <327cff85-ec57-2585-6ed2-24ff8f190d38@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <327cff85-ec57-2585-6ed2-24ff8f190d38@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 09:22:10PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Tue, Mar 15, 2022 at 12:48 AM Oliver Upton <oupton@google.com> wrote:
> > 
> > On Mon, Mar 14, 2022 at 11:19 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > Hi Oliver,
> > >
> > > On 3/14/22 1:22 PM, Oliver Upton wrote:
> > > > On Sun, Mar 13, 2022 at 11:19:58PM -0700, Reiji Watanabe wrote:
> > > >> KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
> > > >> for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
> > > >> if the vcpu's register width is consistent with all other vCPUs'.
> > > >> Since the checking is done even against vCPUs that are not initialized
> > > >> (KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
> > > >> are erroneously treated as 64bit vCPU, which causes the function to
> > > >> incorrectly detect a mixed-width VM.
> > > >>
> > > >> Introduce KVM_ARCH_FLAG_EL1_32BIT and KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED
> > > >> bits for kvm->arch.flags.  A value of the EL1_32BIT bit indicates that
> > > >> the guest needs to be configured with all 32bit or 64bit vCPUs, and
> > > >> a value of the REG_WIDTH_CONFIGURED bit indicates if a value of the
> > > >> EL1_32BIT bit is valid (already set up). Values in those bits are set at
> > > >> the first KVM_ARM_VCPU_INIT for the guest based on KVM_ARM_VCPU_EL1_32BIT
> > > >> configuration for the vCPU.
> > > >>
> > > >> Check vcpu's register width against those new bits at the vcpu's
> > > >> KVM_ARM_VCPU_INIT (instead of against other vCPUs' register width).
> > > >>
> > > >> Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
> > > >> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > >
> > > > Hrmph... I hate to be asking this question so late in the game, but...
> > > >
> > > > Are there any bits that we really allow variation per-vCPU besides
> > > > KVM_ARM_VCPU_POWER_OFF? We unintentionally allow for variance with the
> > > > KVM_ARM_VCPU_PSCI_0_2 bit even though that's complete nonsense.
> > > >
> > > > Stated plainly, should we just deny any attempts at asymmetry besides
> > > > POWER_OFF?>
> > > > Besides the nits, I see nothing objectionable with the patch. I'd really
> > > > like to see more generalized constraints on vCPU configuration, but if
> > > > this is the route we take:
> > >
> > > Prohibiting the mixed width configuration is not a new constraint that
> > > this patch creates (this patch fixes a bug that erroneously detects
> > > mixed-width configuration), and enforcing symmetry of other features
> > > among vCPUs is a bit different matter.
> > 
> > Right, I had managed to forget that context for a moment when I
> > replied to you. Then I fully agree with this patch, and the other
> > feature flags can be handled later.
> > 
> > >
> > > Having said that, I like the idea, which will be more consistent with
> > > my ID register series (it can simplify things).  But, I'm not sure
> > > if creating the constraint for those features would be a problem for
> > > existing userspace even if allowing variation per-vCPU for the features
> > > was not our intention.
> > > I would guess having the constraint for KVM_ARM_VCPU_PSCI_0_2 should
> > > be fine.  Do you think that should be fine for PMU, SVE, and PTRAUTH*
> > > as well ?
> > 
> > Personally, yes, but it prompts the question of if we could break
> > userspace by applying restrictions after the fact. The original patch
> > that applied the register width restrictions didn't cause much of a
> > stir, so it seems possible we could get away with it.
> 
> 
> I agree that it's possible we might get away with it, and I can try
> that for the other features besides KVM_ARM_VCPU_POWER_OFF :)
> (I will work it on separately from this series)
> 

Oh, that'd be great! I was just whining publicly :-)

> BTW, if there had been a general interface to configure per-VM feature,
> I would guess that interface might have been chosen for PSCI_0_2.
> Perhaps we should consider creating it the next time per-VM feature
> is introduced.
> 

I believe there is a lot in KVM we could go back and do better if we had
the patience for it ;-) On a more serious note, I do agree that we need
better mechanisms for VM-scoped bits going forward. 

> Thanks,
> Reiji
> 
> 
> > 
> > > >
> > > > Reviewed-by: Oliver Upton <oupton@google.com>
> > > >
> > > >> ---
> > > >>   arch/arm64/include/asm/kvm_emulate.h | 27 ++++++++----
> > > >>   arch/arm64/include/asm/kvm_host.h    |  9 ++++
> > > >>   arch/arm64/kvm/reset.c               | 64 ++++++++++++++++++----------
> > > >>   3 files changed, 70 insertions(+), 30 deletions(-)
> > > >>
> > > >> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > > >> index d62405ce3e6d..7496deab025a 100644
> > > >> --- a/arch/arm64/include/asm/kvm_emulate.h
> > > >> +++ b/arch/arm64/include/asm/kvm_emulate.h
> > > >> @@ -43,10 +43,22 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
> > > >>
> > > >>   void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
> > > >>
> > > >> +#if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
> > > >>   static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
> > > >>   {
> > > >>      return !(vcpu->arch.hcr_el2 & HCR_RW);
> > > >>   }
> > > >> +#else
> > > >> +static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
> > > >> +{
> > > >> +    struct kvm *kvm = vcpu->kvm;
> > > >> +
> > > >> +    WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED,
> > > >> +                           &kvm->arch.flags));
> > > >> +
> > > >> +    return test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
> > > >> +}
> > > >> +#endif
> > > >>
> > > >>   static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> > > >>   {
> > > >> @@ -72,15 +84,14 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> > > >>              vcpu->arch.hcr_el2 |= HCR_TVM;
> > > >>      }
> > > >>
> > > >> -    if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
> > > >> +    if (vcpu_el1_is_32bit(vcpu))
> > > >>              vcpu->arch.hcr_el2 &= ~HCR_RW;
> > > >> -
> > > >> -    /*
> > > >> -     * TID3: trap feature register accesses that we virtualise.
> > > >> -     * For now this is conditional, since no AArch32 feature regs
> > > >> -     * are currently virtualised.
> > > >> -     */
> > > >> -    if (!vcpu_el1_is_32bit(vcpu))
> > > >> +    else
> > > >> +            /*
> > > >> +             * TID3: trap feature register accesses that we virtualise.
> > > >> +             * For now this is conditional, since no AArch32 feature regs
> > > >> +             * are currently virtualised.
> > > >> +             */
> > > >>              vcpu->arch.hcr_el2 |= HCR_TID3;
> > > >>
> > > >>      if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
> > > >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > >> index 11a7ae747ded..22ad977069f5 100644
> > > >> --- a/arch/arm64/include/asm/kvm_host.h
> > > >> +++ b/arch/arm64/include/asm/kvm_host.h
> > > >> @@ -125,6 +125,15 @@ struct kvm_arch {
> > > >>   #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER 0
> > > >>      /* Memory Tagging Extension enabled for the guest */
> > > >>   #define KVM_ARCH_FLAG_MTE_ENABLED                  1
> > > >> +    /*
> > > >> +     * The following two bits are used to indicate the guest's EL1
> > > >> +     * register width configuration. A value of KVM_ARCH_FLAG_EL1_32BIT
> > > >> +     * bit is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED is set.
> > > >> +     * Otherwise, the guest's EL1 register width has not yet been
> > > >> +     * determined yet.
> > > >> +     */
> > > >> +#define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED          2
> > > >> +#define KVM_ARCH_FLAG_EL1_32BIT                             3
> > > >>      unsigned long flags;
> > > >>
> > > >>      /*
> > > >> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > > >> index ecc40c8cd6f6..cbeb6216ee25 100644
> > > >> --- a/arch/arm64/kvm/reset.c
> > > >> +++ b/arch/arm64/kvm/reset.c
> > > >> @@ -181,27 +181,45 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
> > > >>      return 0;
> > > >>   }
> > > >>
> > > >> -static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> > > >> +/*
> > > >> + * A guest can have either all EL1 32bit or 64bit vcpus only. It is
> > > >> + * indicated by a value of KVM_ARCH_FLAG_EL1_32BIT bit in kvm->arch.flags,
> > > >> + * which is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED in
> > > >> + * kvm->arch.flags is set.
> > > >> + * This function sets the EL1_32BIT bit based on the given @is32bit (and
> > > >> + * sets REG_WIDTH_CONFIGURED bit). When those flags are already set,
> > > >> + * @is32bit must be consistent with the flags.
> > > >> + * Returns 0 on success, or non-zero otherwise.
> > > >> + */
> > > >
> > > > nit: use kerneldoc style:
> > > >
> > > >    https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html
> > >
> > > Sure, I can fix the comment to use kerneldoc style.
> > >
> > >
> > > >
> > > >> +static int kvm_set_vm_width(struct kvm *kvm, bool is32bit)
> > > >>   {
> > > >> -    struct kvm_vcpu *tmp;
> > > >> -    bool is32bit;
> > > >> -    unsigned long i;
> > > >> +    bool allowed;
> > > >> +
> > > >> +    lockdep_assert_held(&kvm->lock);
> > > >> +
> > > >> +    if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
> > > >> +            /*
> > > >> +             * The guest's register width is already configured.
> > > >> +             * Make sure that @is32bit is consistent with it.
> > > >> +             */
> > > >> +            allowed = (is32bit ==
> > > >> +                       test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags));
> > > >> +            return allowed ? 0 : -EINVAL;
> > > >
> > > > nit: I'd avoid the ternary and just use a boring if/else (though I could
> > > > be in the minority here).
> > >
> > > I agree with you and will fix it.
> > > (The ternary with 'allowed' was just copied from the previous patch,
> > >   and I should have changed that in this patch...)
> > >
> > > Thanks,
> > > Reiji
> > >
> > >
> > > >
> > > >> +    }
> > > >>
> > > >> -    is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> > > >>      if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
> > > >> -            return false;
> > > >> +            return -EINVAL;
> > > >>
> > > >>      /* MTE is incompatible with AArch32 */
> > > >> -    if (kvm_has_mte(vcpu->kvm) && is32bit)
> > > >> -            return false;
> > > >> +    if (kvm_has_mte(kvm) && is32bit)
> > > >> +            return -EINVAL;
> > > >>
> > > >> -    /* Check that the vcpus are either all 32bit or all 64bit */
> > > >> -    kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> > > >> -            if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
> > > >> -                    return false;
> > > >> -    }
> > > >> +    if (is32bit)
> > > >> +            set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
> > > >>
> > > >> -    return true;
> > > >> +    set_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags);
> > > >> +
> > > >> +    return 0;
> > > >>   }
> > > >>
> > > >>   /**
> > > >> @@ -230,10 +248,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> > > >>      u32 pstate;
> > > >>
> > > >>      mutex_lock(&vcpu->kvm->lock);
> > > >> -    reset_state = vcpu->arch.reset_state;
> > > >> -    WRITE_ONCE(vcpu->arch.reset_state.reset, false);
> > > >> +    ret = kvm_set_vm_width(vcpu->kvm,
> > > >> +                           vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT));
> > > >> +    if (!ret) {
> > > >> +            reset_state = vcpu->arch.reset_state;
> > > >> +            WRITE_ONCE(vcpu->arch.reset_state.reset, false);
> > > >> +    }
> > > >>      mutex_unlock(&vcpu->kvm->lock);
> > > >>
> > > >> +    if (ret)
> > > >> +            return ret;
> > > >> +
> > > >>      /* Reset PMU outside of the non-preemptible section */
> > > >>      kvm_pmu_vcpu_reset(vcpu);
> > > >>
> > > >> @@ -260,14 +285,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> > > >>              }
> > > >>      }
> > > >>
> > > >> -    if (!vcpu_allowed_register_width(vcpu)) {
> > > >> -            ret = -EINVAL;
> > > >> -            goto out;
> > > >> -    }
> > > >> -
> > > >>      switch (vcpu->arch.target) {
> > > >>      default:
> > > >> -            if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> > > >> +            if (vcpu_el1_is_32bit(vcpu)) {
> > > >>                      pstate = VCPU_RESET_PSTATE_SVC;
> > > >>              } else {
> > > >>                      pstate = VCPU_RESET_PSTATE_EL1;
> > > >> --
> > > >> 2.35.1.723.g4982287a31-goog
> > > >>
