Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778343B8FF4
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbhGAJs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 05:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbhGAJs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 05:48:26 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEB1C061756
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 02:45:55 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so5947133oti.2
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 02:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KxBpDgqk1Ey/xQW5QoMy+bkY1YOpl92uaqUPXrNuvPQ=;
        b=sjwI1qP+JpJtL6HZhO47MI7GrA+78/msovLbbxWqCAi4sh1BvTkCpsP+gBYQQ6s0PA
         92NJ8lPGv9A3dj2aO4C7kM5VpuYnl5h/EocekBQ422n/5+hhAlbyatEVs2HVjoaW75GE
         4UjeMhBg0r3+20mvMgFt3ozek7fqgGw22H/j8OfVhCXjEDYFHxCwKLLrGKF1GHCaiOvZ
         U8S8eAJD+BDr/NYjPQAJ3HP+S2LM/W4VT8b927rLRy2Ng0G2xEjGTesrC8/a8qt4QDFr
         GxiF26a5tnfQfM+QnP5bHzS7kv5CVhp135zVnE3lpo1EUspJGmxl5ioQ1vKXwtB2HIZh
         Wh/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KxBpDgqk1Ey/xQW5QoMy+bkY1YOpl92uaqUPXrNuvPQ=;
        b=pfgs0OpKCOkGiOIYyTNviGRX9Mx/GWRZiVK5Eyc7loHjUdbggV/YwNbBy3h5fp0oTG
         gxFCdE6WhDf3pNZ3Ved2yclCyBim1x7bDm23qLp/K0TnIUKfd4qY/4ru0TNDcnk26Eqp
         1xtRFgApuPh58BfuJeW3OiZuotfHgej7J5zOM1BbI3gz6iVZKHvfPq0djpdGjivpYxHm
         0tlidc209Gu3lsVE94oHmBAmipaedQThKFbIGji5PgU1nIlZ4Pd4iRgHLfif6cUIRErI
         wmX5UncXFW5Z5xsdRo3MgIbMYzAccu0y5Do/ez+2HxUPND83La6KeCPCZtv26ccHDE21
         BUFw==
X-Gm-Message-State: AOAM5315PwoveSpqo9R7zVSIZXDE8Y4YyNM+lrwO5/T7yirp2MUDg/Vh
        TwZDzZa0l991yJpxePIvQuT0gcKySvOHTd/rktyZiw==
X-Google-Smtp-Source: ABdhPJw/wq/WtT3lr6OFv1i4ad9bDItEkA+z5vUXgnxwSrnrnqr8gFWSwGmg6M/o1MTmdcBIKMz0Mg6TzouhOo+TxmQ=
X-Received: by 2002:a9d:17c5:: with SMTP id j63mr1305084otj.52.1625132754456;
 Thu, 01 Jul 2021 02:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210608154805.216869-1-jean-philippe@linaro.org> <20210608154805.216869-3-jean-philippe@linaro.org>
In-Reply-To: <20210608154805.216869-3-jean-philippe@linaro.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 10:45:18 +0100
Message-ID: <CA+EHjTz3AAv2HyfHZBVjtB-0Y4c-_ifC4bPpx1sP0Wtm_Rqs2A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] KVM: arm64: Move WFI execution to check_vcpu_requests()
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
> Prepare for WFI requests from userspace, by adding a suspend request and
> moving the WFI execution into check_vcpu_requests(), next to the
> power-off logic.
>
> vcpu->arch.mp_state, previously only RUNNABLE or STOPPED, supports an
> additional state HALTED and two new state transitions:
>
>   RUNNABLE -> HALTED    from WFI or PSCI CPU_SUSPEND (same vCPU)
>   HALTED -> RUNNABLE    vGIC IRQ, pending timer, signal
>
> There shouldn't be any functional change with this patch, even though
> the KVM_GET_MP_STATE ioctl could now in theory return
> KVM_MP_STATE_HALTED, which would break some users' mp_state support. In
> practice it should not happen because we do not return to userspace with
> HALTED state. Both WFI and PSCI CPU_SUSPEND stay in the vCPU run loop
> until the suspend request is consumed. It does feel fragile though,
> maybe we should explicitly return RUNNABLE in KVM_GET_MP_STATE in place
> of HALTED, to prevent future breakage.

It's not really a functional change, but it might introduce some
timing/scheduling changes I think.

Before your changes, the kvm_vcpu_block() would take place at the end
of the vCPU run loop, via handle_exit(). Now it takes place closer to
the beginning, after cond_resched() is called, and not if there is a
KVM_REQ_IRQ_PENDING.

If my observation is correct, would it be good to mention that?

Thanks,
/fuad



>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/arm.c              | 18 ++++++++++++++-
>  arch/arm64/kvm/handle_exit.c      |  3 +--
>  arch/arm64/kvm/psci.c             | 37 +++++++++++++------------------
>  4 files changed, 35 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 55a04f4d5919..3ca732feb9a5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -46,6 +46,7 @@
>  #define KVM_REQ_VCPU_RESET     KVM_ARCH_REQ(2)
>  #define KVM_REQ_RECORD_STEAL   KVM_ARCH_REQ(3)
>  #define KVM_REQ_RELOAD_GICv4   KVM_ARCH_REQ(4)
> +#define KVM_REQ_SUSPEND                KVM_ARCH_REQ(5)
>
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>                                      KVM_DIRTY_LOG_INITIALLY_SET)
> @@ -722,6 +723,7 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>                                struct kvm_device_attr *attr);
>  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
>  bool kvm_arm_vcpu_is_off(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu);
>
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index bcc24adb9c0a..d8cbaa0373c7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -447,6 +447,12 @@ bool kvm_arm_vcpu_is_off(struct kvm_vcpu *vcpu)
>         return vcpu->arch.mp_state == KVM_MP_STATE_STOPPED;
>  }
>
> +void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
> +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> +}
> +
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> @@ -667,6 +673,8 @@ static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
>
>  static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>  {
> +       bool irq_pending;
> +
>         if (kvm_request_pending(vcpu)) {
>                 if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
>                         vcpu_req_sleep(vcpu);
> @@ -678,7 +686,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>                  * Clear IRQ_PENDING requests that were made to guarantee
>                  * that a VCPU sees new virtual interrupts.
>                  */
> -               kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
> +               irq_pending = kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
>
>                 if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
>                         kvm_update_stolen_time(vcpu);
> @@ -690,6 +698,14 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>                         vgic_v4_load(vcpu);
>                         preempt_enable();
>                 }
> +
> +               if (kvm_check_request(KVM_REQ_SUSPEND, vcpu)) {
> +                       if (!irq_pending) {
> +                               kvm_vcpu_block(vcpu);
> +                               kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> +                       }
> +                       vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +               }
>         }
>  }
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 6f48336b1d86..9717df3104cf 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -95,8 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>         } else {
>                 trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
>                 vcpu->stat.wfi_exit_stat++;
> -               kvm_vcpu_block(vcpu);
> -               kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> +               kvm_arm_vcpu_suspend(vcpu);
>         }
>
>         kvm_incr_pc(vcpu);
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 24b4a2265dbd..42a307ceb95f 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -31,27 +31,6 @@ static unsigned long psci_affinity_mask(unsigned long affinity_level)
>         return 0;
>  }
>
> -static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
> -{
> -       /*
> -        * NOTE: For simplicity, we make VCPU suspend emulation to be
> -        * same-as WFI (Wait-for-interrupt) emulation.
> -        *
> -        * This means for KVM the wakeup events are interrupts and
> -        * this is consistent with intended use of StateID as described
> -        * in section 5.4.1 of PSCI v0.2 specification (ARM DEN 0022A).
> -        *
> -        * Further, we also treat power-down request to be same as
> -        * stand-by request as-per section 5.4.2 clause 3 of PSCI v0.2
> -        * specification (ARM DEN 0022A). This means all suspend states
> -        * for KVM will preserve the register state.
> -        */
> -       kvm_vcpu_block(vcpu);
> -       kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> -
> -       return PSCI_RET_SUCCESS;
> -}
> -
>  static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  {
>         struct vcpu_reset_state *reset_state;
> @@ -227,7 +206,21 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>                 break;
>         case PSCI_0_2_FN_CPU_SUSPEND:
>         case PSCI_0_2_FN64_CPU_SUSPEND:
> -               val = kvm_psci_vcpu_suspend(vcpu);
> +               /*
> +                * NOTE: For simplicity, we make VCPU suspend emulation to be
> +                * same-as WFI (Wait-for-interrupt) emulation.
> +                *
> +                * This means for KVM the wakeup events are interrupts and this
> +                * is consistent with intended use of StateID as described in
> +                * section 5.4.1 of PSCI v0.2 specification (ARM DEN 0022A).
> +                *
> +                * Further, we also treat power-down request to be same as
> +                * stand-by request as-per section 5.4.2 clause 3 of PSCI v0.2
> +                * specification (ARM DEN 0022A). This means all suspend states
> +                * for KVM will preserve the register state.
> +                */
> +               kvm_arm_vcpu_suspend(vcpu);
> +               val = PSCI_RET_SUCCESS;
>                 break;
>         case PSCI_0_2_FN_CPU_OFF:
>                 kvm_arm_vcpu_power_off(vcpu);
> --
> 2.31.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
