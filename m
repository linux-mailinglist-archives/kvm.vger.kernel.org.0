Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D5B50B106
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444635AbiDVHFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 03:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444636AbiDVHF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 03:05:28 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F58A51318
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 00:02:29 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id r8so8106447oib.5
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 00:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6aJ56+/D85v1WUes/289evvEd8UaI+AEzgCXqIJWGo8=;
        b=Nxd7Tr2/xJdEHBhykgjnBKfGUE5ylklfyGW154UjNzxFdx4Xv7YI9WI42qcj8jGgSO
         WsQXOGQVsvOp6dGTTyIe9kadBG5VLl2e3dLvl3z8jePCvJrQxsd8lb2+/pGdmIo6eS9w
         RLrX7L8+R21eTRYinS89xMJGP6j0vFiR46Mpco3O+wfvnuwKIE0ozOdNfjiRvQgdntBt
         V4qFH1bv0YhnGpDH4BEtvR0ZwBozgyCfl9HwSgDVoK9a+iWvbc/1LzTnG9g4Xoj+tV6j
         dLZ0fVS/+HM4TCrWoXWtajFr7cts1+c7hPtH9wTmdGquHLrmG+OT6b73FutBpq8orzew
         CfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6aJ56+/D85v1WUes/289evvEd8UaI+AEzgCXqIJWGo8=;
        b=GAQrr4dc4JyzAqPf+QBli24K6c5rISSt9amtVQe7DQ1LqRMS4mTj5QxYjILDnCKCoe
         JZsJ6jmIPLa9W3fd55+bGvZsZEsM3L7X4ZVCklYv1txvvCBapuBuO/yZyYmfWUPaoTVG
         b1P2/WvtbADHd1BJWJOYYLb1XA8S1R21CI4zAoG27P66P93dCPXP39pE+u37wM/uVq64
         uCzo8I67b4ORhGyaAkC2SlkE3FQbRURI/JUjP0Dbl1Pxyt5mo405X8qhQjNIR9w2upNK
         /r1e84nX/u+EPtXzWJOtt88Pr4Snn3Fg/Hz938vVQGCAqAF3HRhVkL0DjUreTtc/EsKi
         D/Bw==
X-Gm-Message-State: AOAM531u0k186ymuko/ohFx3gBgWlZrMFfE71o07m18Ips72Ia1t4cT0
        U62b37DAI19dAzSmbXQzwsalDi+Fv9uHPpT3+lncvg==
X-Google-Smtp-Source: ABdhPJwRa4h1m6F5mg3Telnou/9rsA3F3+ROZcrdY2GEDdGYZ8dH4LMEqrFAjcfAOWY0FOBgyLEwxpNzUPAFVuDnNlM=
X-Received: by 2002:aca:b405:0:b0:322:ed83:59a1 with SMTP id
 d5-20020acab405000000b00322ed8359a1mr4901031oif.16.1650610948355; Fri, 22 Apr
 2022 00:02:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com> <20220409184549.1681189-9-oupton@google.com>
In-Reply-To: <20220409184549.1681189-9-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 22 Apr 2022 00:02:12 -0700
Message-ID: <CAAeT=Fw5as0GtZhdU6M2vGnP5ZX0GZqyiJm9Q4Ng2J1zY4AppQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/13] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 9, 2022 at 11:46 AM Oliver Upton <oupton@google.com> wrote:
>
> ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND" describes a PSCI call that allows
> software to request that a system be placed in the deepest possible
> low-power state. Effectively, software can use this to suspend itself to
> RAM.
>
> Unfortunately, there really is no good way to implement a system-wide
> PSCI call in KVM. Any precondition checks done in the kernel will need
> to be repeated by userspace since there is no good way to protect a
> critical section that spans an exit to userspace. SYSTEM_RESET and
> SYSTEM_OFF are equally plagued by this issue, although no users have
> seemingly cared for the relatively long time these calls have been
> supported.
>
> The solution is to just make the whole implementation userspace's
> problem. Introduce a new system event, KVM_SYSTEM_EVENT_SUSPEND, that
> indicates to userspace a calling vCPU has invoked PSCI SYSTEM_SUSPEND.
> Additionally, add a CAP to get buy-in from userspace for this new exit
> type.
>
> Only advertise the SYSTEM_SUSPEND PSCI call if userspace has opted in.
> If a vCPU calls SYSTEM_SUSPEND, punt straight to userspace. Provide
> explicit documentation of userspace's responsibilites for the exit and
> point to the PSCI specification to describe the actual PSCI call.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/api.rst    | 39 +++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h |  3 ++-
>  arch/arm64/kvm/arm.c              | 12 +++++++++-
>  arch/arm64/kvm/psci.c             | 25 ++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  2 ++
>  5 files changed, 79 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d104e34ad703..24e2fac2fea7 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6015,6 +6015,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
>    #define KVM_SYSTEM_EVENT_RESET          2
>    #define KVM_SYSTEM_EVENT_CRASH          3
>    #define KVM_SYSTEM_EVENT_WAKEUP         4
> +  #define KVM_SYSTEM_EVENT_SUSPENDED      5

Nit: This should be KVM_SYSTEM_EVENT_SUSPEND based on the code.
(a few more parts in the doc use KVM_SYSTEM_EVENT_SUSPENDED)

Otherwise,
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji


>                         __u32 type;
>                         __u64 flags;
>                 } system_event;
> @@ -6042,6 +6043,34 @@ Valid values for 'type' are:
>   - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
>     KVM has recognized a wakeup event. Userspace may honor this event by
>     marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
> + - KVM_SYSTEM_EVENT_SUSPENDED -- the guest has requested a suspension of
> +   the VM.
> +
> +For arm/arm64:
> +^^^^^^^^^^^^^^
> +
> +   KVM_SYSTEM_EVENT_SUSPENDED exits are enabled with the
> +   KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest invokes the PSCI
> +   SYSTEM_SUSPEND function, KVM will exit to userspace with this event
> +   type.
> +
> +   It is the sole responsibility of userspace to implement the PSCI
> +   SYSTEM_SUSPEND call according to ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
> +   KVM does not change the vCPU's state before exiting to userspace, so
> +   the call parameters are left in-place in the vCPU registers.
> +
> +   Userspace is _required_ to take action for such an exit. It must
> +   either:
> +
> +    - Honor the guest request to suspend the VM. Userspace can request
> +      in-kernel emulation of suspension by setting the calling vCPU's
> +      state to KVM_MP_STATE_SUSPENDED. Userspace must configure the vCPU's
> +      state according to the parameters passed to the PSCI function when
> +      the calling vCPU is resumed. See ARM DEN0022D.b 5.19.1 "Intended use"
> +      for details on the function parameters.
> +
> +    - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
> +      "Caller responsibilities" for possible return values.
>
>  Valid flags are:
>
> @@ -7756,6 +7785,16 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
>  this capability will disable PMU virtualization for that VM.  Usermode
>  should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>
> +8.36 KVM_CAP_ARM_SYSTEM_SUSPEND
> +-------------------------------
> +
> +:Capability: KVM_CAP_ARM_SYSTEM_SUSPEND
> +:Architectures: arm64
> +:Type: vm
> +
> +When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
> +type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
> +
>  9. Known KVM API problems
>  =========================
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 46027b9b80ca..9243115c9d7b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -137,7 +137,8 @@ struct kvm_arch {
>          */
>  #define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED             3
>  #define KVM_ARCH_FLAG_EL1_32BIT                                4
> -
> +       /* PSCI SYSTEM_SUSPEND enabled for the guest */
> +#define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
>         unsigned long flags;
>
>         /*
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9641b86d375..1714aa55db9c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -97,6 +97,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 }
>                 mutex_unlock(&kvm->lock);
>                 break;
> +       case KVM_CAP_ARM_SYSTEM_SUSPEND:
> +               r = 0;
> +               set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
> +               break;
>         default:
>                 r = -EINVAL;
>                 break;
> @@ -210,6 +214,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_SET_GUEST_DEBUG:
>         case KVM_CAP_VCPU_ATTRIBUTES:
>         case KVM_CAP_PTP_KVM:
> +       case KVM_CAP_ARM_SYSTEM_SUSPEND:
>                 r = 1;
>                 break;
>         case KVM_CAP_SET_GUEST_DEBUG2:
> @@ -447,8 +452,13 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
>  static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
>  {
>         vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
> +
> +       /*
> +        * Since this is only called from the intended vCPU, the target vCPU is
> +        * guaranteed to not be running. As such there is no need to kick the
> +        * target to handle the request.
> +        */
>         kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> -       kvm_vcpu_kick(vcpu);
>  }
>
>  static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 362d2a898b83..58b5e2c2ff6a 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -191,6 +191,11 @@ static void kvm_psci_system_reset2(struct kvm_vcpu *vcpu)
>                                  KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2);
>  }
>
> +static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
> +{
> +       kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_SUSPEND, 0);
> +}
> +
>  static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
>  {
>         int i;
> @@ -296,6 +301,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
>  {
>         unsigned long val = PSCI_RET_NOT_SUPPORTED;
>         u32 psci_fn = smccc_get_function(vcpu);
> +       struct kvm *kvm = vcpu->kvm;
>         u32 arg;
>         int ret = 1;
>
> @@ -327,6 +333,11 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
>                 case ARM_SMCCC_VERSION_FUNC_ID:
>                         val = 0;
>                         break;
> +               case PSCI_1_0_FN_SYSTEM_SUSPEND:
> +               case PSCI_1_0_FN64_SYSTEM_SUSPEND:
> +                       if (test_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags))
> +                               val = 0;
> +                       break;
>                 case PSCI_1_1_FN_SYSTEM_RESET2:
>                 case PSCI_1_1_FN64_SYSTEM_RESET2:
>                         if (minor >= 1)
> @@ -334,6 +345,20 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
>                         break;
>                 }
>                 break;
> +       case PSCI_1_0_FN_SYSTEM_SUSPEND:
> +               kvm_psci_narrow_to_32bit(vcpu);
> +               fallthrough;
> +       case PSCI_1_0_FN64_SYSTEM_SUSPEND:
> +               /*
> +                * Return directly to userspace without changing the vCPU's
> +                * registers. Userspace depends on reading the SMCCC parameters
> +                * to implement SYSTEM_SUSPEND.
> +                */
> +               if (test_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags)) {
> +                       kvm_psci_system_suspend(vcpu);
> +                       return 0;
> +               }
> +               break;
>         case PSCI_1_1_FN_SYSTEM_RESET2:
>                 kvm_psci_narrow_to_32bit(vcpu);
>                 fallthrough;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 64e5f9d83a7a..752e4a5c3ce6 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -445,6 +445,7 @@ struct kvm_run {
>  #define KVM_SYSTEM_EVENT_RESET          2
>  #define KVM_SYSTEM_EVENT_CRASH          3
>  #define KVM_SYSTEM_EVENT_WAKEUP         4
> +#define KVM_SYSTEM_EVENT_SUSPEND        5
>                         __u32 type;
>                         __u64 flags;
>                 } system_event;
> @@ -1146,6 +1147,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_MEM_OP_EXTENSION 211
>  #define KVM_CAP_PMU_CAPABILITY 212
>  #define KVM_CAP_DISABLE_QUIRKS2 213
> +#define KVM_CAP_ARM_SYSTEM_SUSPEND 214
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> --
> 2.35.1.1178.g4f1659d476-goog
>
