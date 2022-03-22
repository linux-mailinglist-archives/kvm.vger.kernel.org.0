Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE214E38C6
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 07:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbiCVGVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 02:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbiCVGVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 02:21:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59C838B2
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 23:19:49 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id bx5so14832932pjb.3
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 23:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y6O/R+u8gERWYJP2e4MC/u48l5IVjkYmxjAEHickZzU=;
        b=XL6QFyHKe61Z44sGn50sT0NrZHjSPsPGBG51+YkTxHVfO3a+eTPY7P0Ae1fmkXUdzy
         MuCB6YPQ7+JeGm2wOcbR01RJDNHnqd91VFH6C7ja3Rasy5hsE1eeqyovTtNhqt9IkAnq
         J+OsqnV3/rafOGXCGgNGuaOILNIQ7kbAupWrlyZWNGPCBIp5tVkbGSVhZ+QOkI0jd4Io
         zbhlP6k+tF3JKyEj55c+Me5dmX4JYYhvQ190kDNQUy2dWqbvaXFS1f87LX4J2c6AETp/
         mLxniBqnL5cwLfQ3pmjHTggQjW3Q3A5cv7Ny0NIZTCa28PJw41DONwf3djp3LsgSkJvz
         4/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y6O/R+u8gERWYJP2e4MC/u48l5IVjkYmxjAEHickZzU=;
        b=LQlSMNh7H74yqWdXWMDE+s1KPEfHycJbvom2LljeE3sEzk2EU/cpN3njt+e+mYGwP1
         P1AxgkLzHXLpwBhVc95WuKC5aNu7KR5sz1wmtV4lGqj/OC/MdTwfgmu2DdE16jlV+vN2
         fSLBqE1cqxehI1XHSAEcBBan3VD/mDPiKQVzKGyl4R030+AZ+V6EH0mXhFWei2dDu24f
         pw9F5UV2fS+ssFqKeogAFmnfxseqwC3Zuexj0H8yJQGklBPUNUd2U9oqa3Pypb8RmMEL
         jDXbFLyx8iiWGL3TcBRvsDwxFddIpEsUlP+M7LH31i2IJvh6kVcX9Z72R5LsGNnCPnLV
         F1fQ==
X-Gm-Message-State: AOAM532/d7U9q+yXGJt2ed96nYtC9SpGkSyq63CpoB1baqitx+Gj51ml
        k9N5N5/vkpVEO0A/V7jJW6wgZxCsAdUv6eQRA+btPgQc0MmtpOtX
X-Google-Smtp-Source: ABdhPJzgL+u7Nwb7oIr/wGeK1MqGUiwWik5ORyDIms5pS0q/x+iFHCIwZvgIWYngNUbALvU3ElhIMpzkn20fuvdySNk=
X-Received: by 2002:a17:902:c215:b0:153:8d90:a108 with SMTP id
 21-20020a170902c21500b001538d90a108mr16998874pll.172.1647929989017; Mon, 21
 Mar 2022 23:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com> <20220311174001.605719-10-oupton@google.com>
In-Reply-To: <20220311174001.605719-10-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 21 Mar 2022 23:19:33 -0700
Message-ID: <CAAeT=FyGUZMy-TUZuHu+bZtUY9NfjBQ79JKBX0xK4kEqFTO1OQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/15] KVM: arm64: Add support for userspace to suspend
 a vCPU
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

On Fri, Mar 11, 2022 at 9:41 AM Oliver Upton <oupton@google.com> wrote:
>
> Introduce a new MP state, KVM_MP_STATE_SUSPENDED, which indicates a vCPU
> is in a suspended state. In the suspended state the vCPU will block
> until a wakeup event (pending interrupt) is recognized.
>
> Add a new system event type, KVM_SYSTEM_EVENT_WAKEUP, to indicate to
> userspace that KVM has recognized one such wakeup event. It is the
> responsibility of userspace to then make the vCPU runnable, or leave it
> suspended until the next wakeup event.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/api.rst    | 37 +++++++++++++++++++++++++++++--
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/arm.c              | 35 +++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  2 ++
>  4 files changed, 73 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 5625c08b4a0e..426bcdc1216d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1482,14 +1482,43 @@ Possible values are:
>                                   [s390]
>     KVM_MP_STATE_LOAD             the vcpu is in a special load/startup state
>                                   [s390]
> +   KVM_MP_STATE_SUSPENDED        the vcpu is in a suspend state and is waiting
> +                                 for a wakeup event [arm64]
>     ==========================    ===============================================
>
>  On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
>  in-kernel irqchip, the multiprocessing state must be maintained by userspace on
>  these architectures.
>
> -For arm64/riscv:
> -^^^^^^^^^^^^^^^^
> +For arm64:
> +^^^^^^^^^^
> +
> +If a vCPU is in the KVM_MP_STATE_SUSPENDED state, KVM will emulate the
> +architectural execution of a WFI instruction.
> +
> +If a wakeup event is recognized, KVM will exit to userspace with a
> +KVM_SYSTEM_EVENT exit, where the event type is KVM_SYSTEM_EVENT_WAKEUP. If
> +userspace wants to honor the wakeup, it must set the vCPU's MP state to
> +KVM_MP_STATE_RUNNABLE. If it does not, KVM will continue to await a wakeup
> +event in subsequent calls to KVM_RUN.
> +
> +.. warning::
> +
> +     If userspace intends to keep the vCPU in a SUSPENDED state, it is
> +     strongly recommended that userspace take action to suppress the
> +     wakeup event (such as masking an interrupt). Otherwise, subsequent
> +     calls to KVM_RUN will immediately exit with a KVM_SYSTEM_EVENT_WAKEUP
> +     event and inadvertently waste CPU cycles.
> +
> +     Additionally, if userspace takes action to suppress a wakeup event,
> +     it is strongly recommended that it also restore the vCPU to its

Nit: s/restore/restores/ ?


> +     original state when the vCPU is made RUNNABLE again. For example,
> +     if userspace masked a pending interrupt to suppress the wakeup,
> +     the interrupt should be unmasked before returning control to the
> +     guest.
> +
> +For riscv:
> +^^^^^^^^^^
>
>  The only states that are valid are KVM_MP_STATE_STOPPED and
>  KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
> @@ -5914,6 +5943,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
>    #define KVM_SYSTEM_EVENT_SHUTDOWN       1
>    #define KVM_SYSTEM_EVENT_RESET          2
>    #define KVM_SYSTEM_EVENT_CRASH          3
> +  #define KVM_SYSTEM_EVENT_WAKEUP         4
>                         __u32 type;
>                         __u64 flags;
>                 } system_event;
> @@ -5938,6 +5968,9 @@ Valid values for 'type' are:
>     has requested a crash condition maintenance. Userspace can choose
>     to ignore the request, or to gather VM memory core dump and/or
>     reset/shutdown of the VM.
> + - KVM_SYSTEM_EVENT_WAKEUP -- the guest is in a suspended state and KVM

Nit: Shouldn't 'the guest' be 'the vcpu' ?

> +   has recognized a wakeup event. Userspace may honor this event by marking
> +   the exiting vCPU as runnable, or deny it and call KVM_RUN again.
>
>  Valid flags are:
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index da58eb96d2a8..899f2c0b4c7b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -46,6 +46,7 @@
>  #define KVM_REQ_RECORD_STEAL   KVM_ARCH_REQ(3)
>  #define KVM_REQ_RELOAD_GICv4   KVM_ARCH_REQ(4)
>  #define KVM_REQ_RELOAD_PMU     KVM_ARCH_REQ(5)
> +#define KVM_REQ_SUSPEND                KVM_ARCH_REQ(6)
>
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>                                      KVM_DIRTY_LOG_INITIALLY_SET)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8eed0556ccaa..b94efa05d869 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -444,6 +444,18 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
>         return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
>  }
>
> +static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
> +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> +       kvm_vcpu_kick(vcpu);
> +}
> +
> +static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_SUSPENDED;
> +}
> +
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> @@ -464,6 +476,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>         case KVM_MP_STATE_STOPPED:
>                 kvm_arm_vcpu_power_off(vcpu);
>                 break;
> +       case KVM_MP_STATE_SUSPENDED:
> +               kvm_arm_vcpu_suspend(vcpu);
> +               break;
>         default:
>                 ret = -EINVAL;
>         }
> @@ -648,6 +663,23 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
>         preempt_enable();
>  }
>
> +static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
> +{
> +       if (!kvm_arm_vcpu_suspended(vcpu))
> +               return 1;
> +
> +       kvm_vcpu_wfi(vcpu);
> +
> +       /*
> +        * The suspend state is sticky; we do not leave it until userspace
> +        * explicitly marks the vCPU as runnable. Request that we suspend again
> +        * later.
> +        */
> +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> +       kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_WAKEUP, 0);
> +       return 0;
> +}
> +
>  /**
>   * check_vcpu_requests - check and handle pending vCPU requests
>   * @vcpu:      the VCPU pointer
> @@ -686,6 +718,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>                 if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
>                         kvm_pmu_handle_pmcr(vcpu,
>                                             __vcpu_sys_reg(vcpu, PMCR_EL0));
> +
> +               if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> +                       return kvm_vcpu_suspend(vcpu);

It appears that one of the cases that kvm_vcpu_suspend() returns
is when a pending signal is detected, and the exit reason will be
KVM_EXIT_SYSTEM_EVENT in this case.  On the other hand, when a
pending signal is detected earlier in xfer_to_guest_mode_handle_work(),
KVM_RUN returns -EINTR even if the vCPU is in KVM_MP_STATE_SUSPENDED
state. Shouldn't those behaviors be consistent ? (Perhaps -EINTR?)

Thanks,
Reiji

>         }
>
>         return 1;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5191b57e1562..babb16c2abe5 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -444,6 +444,7 @@ struct kvm_run {
>  #define KVM_SYSTEM_EVENT_SHUTDOWN       1
>  #define KVM_SYSTEM_EVENT_RESET          2
>  #define KVM_SYSTEM_EVENT_CRASH          3
> +#define KVM_SYSTEM_EVENT_WAKEUP         4
>                         __u32 type;
>                         __u64 flags;
>                 } system_event;
> @@ -634,6 +635,7 @@ struct kvm_vapic_addr {
>  #define KVM_MP_STATE_OPERATING         7
>  #define KVM_MP_STATE_LOAD              8
>  #define KVM_MP_STATE_AP_RESET_HOLD     9
> +#define KVM_MP_STATE_SUSPENDED         10
>
>  struct kvm_mp_state {
>         __u32 mp_state;
> --
> 2.35.1.723.g4982287a31-goog
>
