Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CF653D616
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 10:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbiFDIRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jun 2022 04:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbiFDIRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jun 2022 04:17:04 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C6ADF2F
        for <kvm@vger.kernel.org>; Sat,  4 Jun 2022 01:17:01 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-edeb6c3642so13395599fac.3
        for <kvm@vger.kernel.org>; Sat, 04 Jun 2022 01:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JAv6TmeB/u+Xmiczcgk77PHsW0AKopWiHZR3bN+6WWo=;
        b=M2i5/m2y8SBIk1XawfgwbGjnzKF5iqpsFo0gVRl4hoWm3HJWShIV36J61ZZXI6Hb6k
         tJMhSILd8lqsF6kxLAq+82P5CSQIt+58DhjM8/YQp0Kxdc/vJzgatosbUhOqUklxNMRQ
         ghkBW27SljC/1wwxFJ3UsTOTPvST2A3zePI/Je7Pf/GhGGHSBfuy88GIGu2NtImtTOmx
         kiFNGAQiWiYoVXVPfevFgjk2le3NwbL3ssvKTRyeu/ZfF0jePQuXBvzHfZ618Wc8hXeO
         gb+lKg9CnT/R0TcGtQGW6Xu5nyJ4uE30eZfUnMqN1e+xfvUDTm8THV5oeLk4gtsQumh6
         sNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JAv6TmeB/u+Xmiczcgk77PHsW0AKopWiHZR3bN+6WWo=;
        b=PdDnmXjxREdI0mMuoS9mF2OaArLbc4nHYpptOE+a/9u/XuQG3hYF9gtiyEkwV60aj6
         b7f4l8sKXct+J1K2iRZ/MmVsdedugh/29OSNygGUKKVea8TprOaWkyhYJ5/8k38zVch+
         Le4MszPEofQmjTissLJPksk31CHzvoIBU8CZKX45Nr2iqwEJgtwp93TcC9N1kDKBgofE
         Tavj77kK28zGmjGnn3ASnXcAakPx2au7oH2OOQ3BvWk/fZvLLFoF7sUZAMI7aACLbMW1
         v+YSE/7kitDW1iDfgerlWnvyom1WVvcFP9JJNY4XcoE1xqS5ealJQxCQhnEWVe5rEoCb
         RIUg==
X-Gm-Message-State: AOAM533E9G35Wcq8ZVwBsnuOxPWQflBtA7vaGfLcicfDvOjCi+CpH4pH
        +5NzVuaDqj5zo7kJvKde1W3m2ZqjxTXwG2HhQ5VNyg==
X-Google-Smtp-Source: ABdhPJz3J9U5bFSoVT1FbkGyokU7Wc8fWQkvlFKPPR3FH53hgcZ0JvbgSYQ82dNI9J+tIbbpVyEr0P8KZpqslowVvjs=
X-Received: by 2002:a05:6870:304b:b0:f2:d164:5c85 with SMTP id
 u11-20020a056870304b00b000f2d1645c85mr24850626oau.107.1654330620608; Sat, 04
 Jun 2022 01:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org> <20220528113829.1043361-5-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-5-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 4 Jun 2022 01:16:44 -0700
Message-ID: <CAAeT=FydqQFoUcawxeR4wFD3=AJusYe16fSWhEWpQmkm8yPZTw@mail.gmail.com>
Subject: Re: [PATCH 04/18] KVM: arm64: Move FP state ownership from flag to a tristate
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The KVM FP code uses a pair of flags to denote three states:
>
> - FP_ENABLED set: the guest owns the FP state
> - FP_HOST set: the host owns the FP state
> - FP_ENABLED and FP_HOST clear: nobody owns the FP state at all
>
> and both flags set is an illegal state, which nothing ever checks
> for...
>
> As it turns out, this isn't really a good match for flags, and
> we'd be better off if this was a simpler tristate, each state
> having a name that actually reflect the state:
>
> - FP_STATE_CLEAN
> - FP_STATE_HOST_DIRTY
> - FP_STATE_GUEST_DIRTY
>
> Kill the two flags, and move over to an enum encoding these
> three states. This results in less confusing code, and less risk of
> ending up in the uncharted territory of a 4th state if we forget
> to clear one of the two flags.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

I have the same comment as I have for the patch-3 though.
(i.e. I think having kvm_arch_vcpu_load_fp() set vcpu->arch.fp_state to
FP_STATE_DIRTY_HOST only when FP is supported would be more consistent.)

Thanks,
Reiji

> ---
>  arch/arm64/include/asm/kvm_host.h       |  9 +++++++--
>  arch/arm64/kvm/fpsimd.c                 | 11 +++++------
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  8 +++-----
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  4 ++--
>  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
>  5 files changed, 18 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9252d71b4ac5..a46f952b97f6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -328,6 +328,13 @@ struct kvm_vcpu_arch {
>         /* Exception Information */
>         struct kvm_vcpu_fault_info fault;
>
> +       /* Ownership of the FP regs */
> +       enum {
> +               FP_STATE_CLEAN,
> +               FP_STATE_DIRTY_HOST,
> +               FP_STATE_DIRTY_GUEST,
> +       } fp_state;
> +
>         /* Miscellaneous vcpu state flags */
>         u64 flags;
>
> @@ -433,8 +440,6 @@ struct kvm_vcpu_arch {
>
>  /* vcpu_arch flags field values: */
>  #define KVM_ARM64_DEBUG_DIRTY          (1 << 0)
> -#define KVM_ARM64_FP_ENABLED           (1 << 1) /* guest FP regs loaded */
> -#define KVM_ARM64_FP_HOST              (1 << 2) /* host FP regs loaded */
>  #define KVM_ARM64_HOST_SVE_ENABLED     (1 << 4) /* SVE enabled for EL0 */
>  #define KVM_ARM64_GUEST_HAS_SVE                (1 << 5) /* SVE exposed to guest */
>  #define KVM_ARM64_VCPU_SVE_FINALIZED   (1 << 6) /* SVE config completed */
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 9ebd89541281..0d82f6c5b110 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -77,8 +77,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>         BUG_ON(!current->mm);
>         BUG_ON(test_thread_flag(TIF_SVE));
>
> -       vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
> -       vcpu->arch.flags |= KVM_ARM64_FP_HOST;
> +       vcpu->arch.fp_state = FP_STATE_DIRTY_HOST;



>
>         vcpu->arch.flags &= ~KVM_ARM64_HOST_SVE_ENABLED;
>         if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
> @@ -100,7 +99,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>
>                 if (read_sysreg_s(SYS_SVCR_EL0) &
>                     (SYS_SVCR_EL0_SM_MASK | SYS_SVCR_EL0_ZA_MASK)) {
> -                       vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
> +                       vcpu->arch.fp_state = FP_STATE_CLEAN;
>                         fpsimd_save_and_flush_cpu_state();
>                 }
>         }
> @@ -119,7 +118,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
>  {
>         if (!system_supports_fpsimd() || test_thread_flag(TIF_FOREIGN_FPSTATE))
> -               vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_FP_HOST);
> +               vcpu->arch.fp_state = FP_STATE_CLEAN;
>  }
>
>  /*
> @@ -133,7 +132,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
>  {
>         WARN_ON_ONCE(!irqs_disabled());
>
> -       if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> +       if (vcpu->arch.fp_state == FP_STATE_DIRTY_GUEST) {
>                 /*
>                  * Currently we do not support SME guests so SVCR is
>                  * always 0 and we just need a variable to point to.
> @@ -176,7 +175,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>                                          CPACR_EL1_SMEN_EL1EN);
>         }
>
> -       if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> +       if (vcpu->arch.fp_state == FP_STATE_DIRTY_GUEST) {
>                 if (vcpu_has_sve(vcpu)) {
>                         __vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 1209248d2a3d..b22378abfb57 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -40,7 +40,7 @@ extern struct kvm_exception_table_entry __stop___kvm_ex_table;
>  /* Check whether the FP regs are owned by the guest */
>  static inline bool guest_owns_fp_regs(struct kvm_vcpu *vcpu)
>  {
> -       return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
> +       return vcpu->arch.fp_state == FP_STATE_DIRTY_GUEST;
>  }
>
>  /* Save the 32-bit only FPSIMD system register state */
> @@ -179,10 +179,8 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
>         isb();
>
>         /* Write out the host state if it's in the registers */
> -       if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
> +       if (vcpu->arch.fp_state == FP_STATE_DIRTY_HOST)
>                 __fpsimd_save_state(vcpu->arch.host_fpsimd_state);
> -               vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
> -       }
>
>         /* Restore the guest state */
>         if (sve_guest)
> @@ -194,7 +192,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
>         if (!(read_sysreg(hcr_el2) & HCR_RW))
>                 write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
>
> -       vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
> +       vcpu->arch.fp_state = FP_STATE_DIRTY_GUEST;
>
>         return true;
>  }
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index a6b9f1186577..89e0f88c9006 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -123,7 +123,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>         }
>
>         cptr = CPTR_EL2_DEFAULT;
> -       if (vcpu_has_sve(vcpu) && (vcpu->arch.flags & KVM_ARM64_FP_ENABLED))
> +       if (vcpu_has_sve(vcpu) && (vcpu->arch.fp_state == FP_STATE_DIRTY_GUEST))
>                 cptr |= CPTR_EL2_TZ;
>         if (cpus_have_final_cap(ARM64_SME))
>                 cptr &= ~CPTR_EL2_TSM;
> @@ -335,7 +335,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>
>         __sysreg_restore_state_nvhe(host_ctxt);
>
> -       if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
> +       if (vcpu->arch.fp_state == FP_STATE_DIRTY_GUEST)
>                 __fpsimd_save_fpexc32(vcpu);
>
>         __debug_switch_to_host(vcpu);
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 46f365254e9f..258e87325c95 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -175,7 +175,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>
>         sysreg_restore_host_state_vhe(host_ctxt);
>
> -       if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
> +       if (vcpu->arch.fp_state == FP_STATE_DIRTY_GUEST)
>                 __fpsimd_save_fpexc32(vcpu);
>
>         __debug_switch_to_host(vcpu);
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
