Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1B3B8FF1
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 11:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhGAJsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 05:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbhGAJsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 05:48:08 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748A5C0617A8
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 02:45:37 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id t3so6617467oic.5
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 02:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S4TJbDbmRHYbelCTMQc9PtwVVnooXUeP5A1QqT0HJx0=;
        b=Ms8bX1TZnLJgR7ZZZdcU7eQCDD2YpR2IrQ7nLRai3kq/EG1QO7IHtO0zKLcFgGRdcH
         sAfej2gsPnsh9TCVPiI54d3E3impx+tYVwGgX+MbZUamZGi9RqYFd1zj7TngbaEZ0Py3
         oH2IYHYhMRKnn4OOTcUCkPN6JZWxMhP64Uwn/gFM/dUCdhynk8dyXxT8GPb2dJoTOh4w
         dIMv4adoo9oIoEXEUZMMbJVwBZ+n9aPoZq6mtQmFkdNBA8k6uMClQ2fGjPn7B8wb+9CP
         BU36vtyu/X4N6ZYreyhw9TycxVNDWWwDoWMzndGQX1UjkiUPPp/abrybA+fXfrL6o63I
         ZTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S4TJbDbmRHYbelCTMQc9PtwVVnooXUeP5A1QqT0HJx0=;
        b=FaxC7KOHMIevAuBP1lFLX2r5DWFKMSjyZif5YQOhG8fxo9sGjpCjZ/FtpAfdpT+7Cu
         ATcgQAHncozMtTYUU+S222Ua8esC4IVABDortdj0nDmERWiSfm+cYgc3ZHWTtCPMy8bY
         Qs+PekmVceUi5aAiPBmcCFPnpTg3LaZcY+BXjQz1QG+JpNqOdDN2Lyolv/1Azir8qxQj
         C9lf7vWlr02V6pDXrNVontnu1l0pjOWqeroi/+pHBtfa7Qzwjan6N/wPWNdQbXu7xGJc
         tUi/gc9dMUg5vC0+70P1FjlE6lPZgAx/YcJRCecbXxpufWStGnL7v4OTvFdHrvwXlTPt
         SBcQ==
X-Gm-Message-State: AOAM530SU7cJgBcNVjr74Po54U7VZOM3PE5Yc3og666hc4KYi3huOHvu
        KVGNIGoZDgeYQBatL5ks3XQuIacmfKcuIXtGjJmJVQ==
X-Google-Smtp-Source: ABdhPJyoiG7rNKpy1FkxlCFar9u5j2o+S5C1PZiAfvWpayLt/f0mt4lQcp5C2OOHDao6REjtiRNHHYdv74ArtXSsLK4=
X-Received: by 2002:a05:6808:158b:: with SMTP id t11mr128947oiw.8.1625132735641;
 Thu, 01 Jul 2021 02:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210608154805.216869-1-jean-philippe@linaro.org> <20210608154805.216869-2-jean-philippe@linaro.org>
In-Reply-To: <20210608154805.216869-2-jean-philippe@linaro.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 10:44:59 +0100
Message-ID: <CA+EHjTws5L8Nti_Pr7TYtECZXGbgOHiNQsoc5ez1Ncf7yaCQaw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] KVM: arm64: Replace power_off with mp_state in
 struct kvm_vcpu_arch
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     maz@kernel.org, salil.mehta@huawei.com, lorenzo.pieralisi@arm.com,
        kvm@vger.kernel.org, corbet@lwn.net, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, will@kernel.org,
        jonathan.cameron@huawei.com, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean-Philippe,

On Tue, Jun 8, 2021 at 4:54 PM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> In order to add a new "suspend" power state, replace power_off with
> mp_state in struct kvm_vcpu_arch. Factor the vcpu_off() function while
> we're here.
>
> No functional change intended.
>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  6 ++++--
>  arch/arm64/kvm/arm.c              | 29 +++++++++++++++--------------
>  arch/arm64/kvm/psci.c             | 19 ++++++-------------
>  3 files changed, 25 insertions(+), 29 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cd7d5c8c4bc..55a04f4d5919 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -340,8 +340,8 @@ struct kvm_vcpu_arch {
>                 u32     mdscr_el1;
>         } guest_debug_preserved;
>
> -       /* vcpu power-off state */
> -       bool power_off;
> +       /* vcpu power state (runnable, stopped, halted) */

Should the comment be, for clarity, something along the lines of
KVM_MP_STATE_(STOPPED, RUNNABLE, HALTED), or maybe "a valid struct
kvm_mp_state", if you think other states might be added in the future?

Thanks,
/fuad


> +       u32 mp_state;
>
>         /* Don't run the guest (internal implementation need) */
>         bool pause;
> @@ -720,6 +720,8 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>                                struct kvm_device_attr *attr);
>  int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>                                struct kvm_device_attr *attr);
> +void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> +bool kvm_arm_vcpu_is_off(struct kvm_vcpu *vcpu);
>
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e720148232a0..bcc24adb9c0a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -435,21 +435,22 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>         vcpu->cpu = -1;
>  }
>
> -static void vcpu_power_off(struct kvm_vcpu *vcpu)
> +void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
>  {
> -       vcpu->arch.power_off = true;
> +       vcpu->arch.mp_state = KVM_MP_STATE_STOPPED;
>         kvm_make_request(KVM_REQ_SLEEP, vcpu);
>         kvm_vcpu_kick(vcpu);
>  }
>
> +bool kvm_arm_vcpu_is_off(struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.mp_state == KVM_MP_STATE_STOPPED;
> +}
> +
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> -       if (vcpu->arch.power_off)
> -               mp_state->mp_state = KVM_MP_STATE_STOPPED;
> -       else
> -               mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
> -
> +       mp_state->mp_state = vcpu->arch.mp_state;
>         return 0;
>  }
>
> @@ -460,10 +461,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>
>         switch (mp_state->mp_state) {
>         case KVM_MP_STATE_RUNNABLE:
> -               vcpu->arch.power_off = false;
> +               vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>                 break;
>         case KVM_MP_STATE_STOPPED:
> -               vcpu_power_off(vcpu);
> +               kvm_arm_vcpu_power_off(vcpu);
>                 break;
>         default:
>                 ret = -EINVAL;
> @@ -483,7 +484,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
>         bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
>         return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -               && !v->arch.power_off && !v->arch.pause);
> +               && !kvm_arm_vcpu_is_off(v) && !v->arch.pause);
>  }
>
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> @@ -643,10 +644,10 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
>         struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>
>         rcuwait_wait_event(wait,
> -                          (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
> +                          !kvm_arm_vcpu_is_off(vcpu) && !vcpu->arch.pause,
>                            TASK_INTERRUPTIBLE);
>
> -       if (vcpu->arch.power_off || vcpu->arch.pause) {
> +       if (kvm_arm_vcpu_is_off(vcpu) || vcpu->arch.pause) {
>                 /* Awaken to handle a signal, request we sleep again later. */
>                 kvm_make_request(KVM_REQ_SLEEP, vcpu);
>         }
> @@ -1087,9 +1088,9 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>          * Handle the "start in power-off" case.
>          */
>         if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> -               vcpu_power_off(vcpu);
> +               kvm_arm_vcpu_power_off(vcpu);
>         else
> -               vcpu->arch.power_off = false;
> +               vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index db4056ecccfd..24b4a2265dbd 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -52,13 +52,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>         return PSCI_RET_SUCCESS;
>  }
>
> -static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
> -{
> -       vcpu->arch.power_off = true;
> -       kvm_make_request(KVM_REQ_SLEEP, vcpu);
> -       kvm_vcpu_kick(vcpu);
> -}
> -
>  static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  {
>         struct vcpu_reset_state *reset_state;
> @@ -78,7 +71,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>          */
>         if (!vcpu)
>                 return PSCI_RET_INVALID_PARAMS;
> -       if (!vcpu->arch.power_off) {
> +       if (!kvm_arm_vcpu_is_off(vcpu)) {
>                 if (kvm_psci_version(source_vcpu, kvm) != KVM_ARM_PSCI_0_1)
>                         return PSCI_RET_ALREADY_ON;
>                 else
> @@ -107,7 +100,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>          */
>         smp_wmb();
>
> -       vcpu->arch.power_off = false;
> +       vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>         kvm_vcpu_wake_up(vcpu);
>
>         return PSCI_RET_SUCCESS;
> @@ -142,7 +135,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>                 mpidr = kvm_vcpu_get_mpidr_aff(tmp);
>                 if ((mpidr & target_affinity_mask) == target_affinity) {
>                         matching_cpus++;
> -                       if (!tmp->arch.power_off)
> +                       if (!kvm_arm_vcpu_is_off(tmp))
>                                 return PSCI_0_2_AFFINITY_LEVEL_ON;
>                 }
>         }
> @@ -168,7 +161,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
>          * re-initialized.
>          */
>         kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> -               tmp->arch.power_off = true;
> +               tmp->arch.mp_state = KVM_MP_STATE_STOPPED;
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
>         memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> @@ -237,7 +230,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>                 val = kvm_psci_vcpu_suspend(vcpu);
>                 break;
>         case PSCI_0_2_FN_CPU_OFF:
> -               kvm_psci_vcpu_off(vcpu);
> +               kvm_arm_vcpu_power_off(vcpu);
>                 val = PSCI_RET_SUCCESS;
>                 break;
>         case PSCI_0_2_FN_CPU_ON:
> @@ -350,7 +343,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
>
>         switch (psci_fn) {
>         case KVM_PSCI_FN_CPU_OFF:
> -               kvm_psci_vcpu_off(vcpu);
> +               kvm_arm_vcpu_power_off(vcpu);
>                 val = PSCI_RET_SUCCESS;
>                 break;
>         case KVM_PSCI_FN_CPU_ON:
> --
> 2.31.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
