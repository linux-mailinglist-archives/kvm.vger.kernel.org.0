Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C657500567
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 07:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbiDNF3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 01:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiDNF3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 01:29:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB1430570
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 22:26:40 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id be5so3755108plb.13
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 22:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9vlVfiZwBDOMVXXKsnbrHV4I5oPCCbywG7emutHTWMM=;
        b=NsVykSlKA6aI9WsiY3gwIh6IyEFpsmT2szT/8roufHu7rJr+BH8zU73QShRKr7c7OL
         Dnj8x7YdEl2SXfqQfyCBUiupVqC3LzuMhtubLFUzOMz/Cc4/8G+qmAVx53jszf46VUlo
         49o8jvOZpxsMPyEc13OQLreXW2DUgHqxecPKWKZ2/6+ncpZ1GL853bKH49TWBBYgK/p6
         W8vNEYlHmGXCDb1CMsfWvJHOyirCIaZ+oLiKEBhEb5PtVt6O5yicc/JSMGlU5ovQyjf7
         LmanSRP0TL1jqWdyYVZ+Yc2NDWLqSSxdKnha6UBDKgZllbnwPzmaIo2lgn7lMlmbsdRH
         UJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9vlVfiZwBDOMVXXKsnbrHV4I5oPCCbywG7emutHTWMM=;
        b=qXVgBLnKhGs5xBf+PkJy8z26VZbFA/5IhlAKH/+oPjB9hn2QU+GXw5wkaLnJ8SmSHd
         +I2V+WyWnDUblYvpHibz5d+8kQ9LmoyYlIbrCDr2urPXdThFfYlMhKNT6UIh0CY/pJyh
         GQcq3iSqxWhnSyikW46V56j9pHqLtt2j0HzGwGhIiQMaDUtsvpvb4H5MJcvTX0QrJCGR
         V15i7WhJuhmLy32yELjA8oNcU8LCzNrXSmWCdPSEw9tJvUWmX7jnf4G28clMDcvmgqAP
         vxCl+FRi3KUxkgMgMAqbHmnjHHvrSrN+BB74EUXK8j4Wh4Nc9tMgx1URtAriTNChg7sg
         527Q==
X-Gm-Message-State: AOAM530Bm7C6m/HLfpyfiClhTfeh5zAL8wdClhkfu0NgxeRBoeoDa+at
        NFBfde/WB7mcX74SAo0TU/iX3h5hPx/mqbxO8RUWwA==
X-Google-Smtp-Source: ABdhPJxYbLAZL6pUd8Y1Ic11i0hZvS30omWAysWY4sRB1WveSfEDXUbbVNyRCwKWiaodAl+cwsee2mDNaQfeVQcsy0g=
X-Received: by 2002:a17:902:c215:b0:153:8d90:a108 with SMTP id
 21-20020a170902c21500b001538d90a108mr46002363pll.172.1649914000259; Wed, 13
 Apr 2022 22:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com> <20220409184549.1681189-4-oupton@google.com>
In-Reply-To: <20220409184549.1681189-4-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 13 Apr 2022 22:26:24 -0700
Message-ID: <CAAeT=FxQ5qBMrYZpGbDT7i+bGFCyfoV32ddKeeprj7mEemnbEA@mail.gmail.com>
Subject: Re: [PATCH v5 03/13] KVM: arm64: Track vCPU power state using MP
 state values
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
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

Hi Oliver,

On Sat, Apr 9, 2022 at 11:46 AM Oliver Upton <oupton@google.com> wrote:
>
> A subsequent change to KVM will add support for additional power states.
> Store the MP state by value rather than keeping track of it as a
> boolean.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 +++--
>  arch/arm64/kvm/arm.c              | 22 ++++++++++++----------
>  arch/arm64/kvm/psci.c             | 12 ++++++------
>  3 files changed, 21 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 490cd7f3a905..f3f93d48e21a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -365,8 +365,8 @@ struct kvm_vcpu_arch {
>                 u32     mdscr_el1;
>         } guest_debug_preserved;
>
> -       /* vcpu power-off state */
> -       bool power_off;
> +       /* vcpu power state */
> +       struct kvm_mp_state mp_state;
>
>         /* Don't run the guest (internal implementation need) */
>         bool pause;
> @@ -842,5 +842,6 @@ static inline void kvm_hyp_reserve(void) { }
>  #endif
>
>  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> +bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
>
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 28c83c6ddbae..29e107457c4d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -434,18 +434,20 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>
>  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
>  {
> -       vcpu->arch.power_off = true;
> +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
>         kvm_make_request(KVM_REQ_SLEEP, vcpu);
>         kvm_vcpu_kick(vcpu);
>  }
>
> +bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
> +}
> +
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> -       if (vcpu->arch.power_off)
> -               mp_state->mp_state = KVM_MP_STATE_STOPPED;
> -       else
> -               mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
> +       *mp_state = vcpu->arch.mp_state;
>
>         return 0;
>  }
> @@ -457,7 +459,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>
>         switch (mp_state->mp_state) {
>         case KVM_MP_STATE_RUNNABLE:
> -               vcpu->arch.power_off = false;
> +               vcpu->arch.mp_state = *mp_state;

Nit: It might be a bit odd that KVM_MP_STATE_STOPPED case only copies
the 'mp_state' field of kvm_mp_state from userspace (that's not a 'copy'
operation though), while KVM_MP_STATE_RUNNABLE case copies entire
kvm_mp_state from user space.
('mp_state' is the only field of kvm_mp_state though)

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji

>                 break;
>         case KVM_MP_STATE_STOPPED:
>                 kvm_arm_vcpu_power_off(vcpu);
> @@ -480,7 +482,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
>         bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
>         return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -               && !v->arch.power_off && !v->arch.pause);
> +               && !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
>  }
>
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> @@ -597,10 +599,10 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
>         struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>
>         rcuwait_wait_event(wait,
> -                          (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
> +                          (!kvm_arm_vcpu_stopped(vcpu)) && (!vcpu->arch.pause),
>                            TASK_INTERRUPTIBLE);
>
> -       if (vcpu->arch.power_off || vcpu->arch.pause) {
> +       if (kvm_arm_vcpu_stopped(vcpu) || vcpu->arch.pause) {
>                 /* Awaken to handle a signal, request we sleep again later. */
>                 kvm_make_request(KVM_REQ_SLEEP, vcpu);
>         }
> @@ -1126,7 +1128,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>         if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
>                 kvm_arm_vcpu_power_off(vcpu);
>         else
> -               vcpu->arch.power_off = false;
> +               vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
>
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index cdc0609c1135..f2f45a3cbe86 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -76,7 +76,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>          */
>         if (!vcpu)
>                 return PSCI_RET_INVALID_PARAMS;
> -       if (!vcpu->arch.power_off) {
> +       if (!kvm_arm_vcpu_stopped(vcpu)) {
>                 if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
>                         return PSCI_RET_ALREADY_ON;
>                 else
> @@ -100,12 +100,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>         kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
>
>         /*
> -        * Make sure the reset request is observed if the change to
> -        * power_off is observed.
> +        * Make sure the reset request is observed if the RUNNABLE mp_state is
> +        * observed.
>          */
>         smp_wmb();
>
> -       vcpu->arch.power_off = false;
> +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
>         kvm_vcpu_wake_up(vcpu);
>
>         return PSCI_RET_SUCCESS;
> @@ -143,7 +143,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>                 mpidr = kvm_vcpu_get_mpidr_aff(tmp);
>                 if ((mpidr & target_affinity_mask) == target_affinity) {
>                         matching_cpus++;
> -                       if (!tmp->arch.power_off)
> +                       if (!kvm_arm_vcpu_stopped(tmp))
>                                 return PSCI_0_2_AFFINITY_LEVEL_ON;
>                 }
>         }
> @@ -169,7 +169,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
>          * re-initialized.
>          */
>         kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> -               tmp->arch.power_off = true;
> +               tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
>         memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> --
> 2.35.1.1178.g4f1659d476-goog
>
