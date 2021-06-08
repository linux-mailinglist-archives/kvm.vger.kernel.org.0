Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CED3A067B
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhFHV62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:58:28 -0400
Received: from mail-lj1-f171.google.com ([209.85.208.171]:44958 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbhFHV61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:58:27 -0400
Received: by mail-lj1-f171.google.com with SMTP id d2so24841866ljj.11
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ICPivJ4fNVCeOxtaxAcxDOI+YT+16jaE2z8xLsluEHg=;
        b=b1pSVJXnKLKGAy5ZsofRPA2UOdcZFakwZCJaUtFDnocvimR1Ab235ijXeFQD41lE5j
         t2hGo3ObJZztI9EAK1jytIIBQNzc6dhxXDwIvdEpfVRWj++rBUKW4SSwFBdiU429Z5J0
         VKQo6VfKthXYojKWv3uayyC8AdkMcSDrwdQmjmLgYW1OVxSKDNx17OJqtuV5KFaBDvIq
         kwPnknf63XaD9XIJ6srt5d9o2PeYWddIeUyHl1oLApX9c8sP0cVuinQxMoQg9FYCx2iZ
         76NHFMoKMsbiIaA6wkxkC6wvtPWKKzngCVzV0vG5gAueppU6lSupfRTU9tiX3pKTw8rG
         a08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ICPivJ4fNVCeOxtaxAcxDOI+YT+16jaE2z8xLsluEHg=;
        b=E/mX5RgSsR4Adntx2eyVJuqa+rPhxpRAPdpfV7MTcj/dJ9JAJO13yb35IqPNTodDJq
         OMbCXoSI5iNN1H9/F18fXkPtO9OLNLRIc1PltfuiGR905m3EYy/SpylGthwyp7cYnYSh
         sbeqLbjTPvq+991F+JCugCqt1T41V+ZgX6r1B5X+IxSOxrf01CDdCiUm8jbU9GAOKI2N
         07FBrMoxcatOcY6m+RMaTHS9kANpV7d1qlucXLe9zzCbO6RTyz2OZiubD6NKpPRIjnKY
         vc0nQSr6NCca6QAuQm3YAtZc1vI4UwtV8HaLTIDKx2doA1Gc56+yhLiYQ4O6NpaS6hXV
         VkEw==
X-Gm-Message-State: AOAM532WFb4jRGtRsMiCCU1S6eZk4Zz12ar8gWNPdzqxBdqVyAjPzTVz
        i+y8Cqc/rAFZta8Jbv/9rwDw37ffW5aQJYYCq1uQMIkYiTw=
X-Google-Smtp-Source: ABdhPJyX9DOpC2fgzkhUH6FK5jSLx1lkuyZUzL84X29TKJKHZ+vAHeAbsjPD40fvAYOI2ouIHegKMOVcNqwuLLLRf1A=
X-Received: by 2002:a2e:b60d:: with SMTP id r13mr11160716ljn.314.1623189319503;
 Tue, 08 Jun 2021 14:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com> <20210608214742.1897483-3-oupton@google.com>
In-Reply-To: <20210608214742.1897483-3-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 8 Jun 2021 16:55:08 -0500
Message-ID: <CAOQ_Qsg65HKghatMVpy0puENh9t2ob51f=fTNnnjQtcNwbRxcQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] KVM: arm64: Implement initial support for KVM_CAP_SYSTEM_COUNTER_STATE
To:     kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 8, 2021 at 4:48 PM Oliver Upton <oupton@google.com> wrote:
>
> ARMv8 provides for a virtual counter-timer offset that is added to guest
> views of the virtual counter-timer (CNTVOFF_EL2). To date, KVM has not
> provided userspace with any perception of this, and instead affords a
> value-based scheme of migrating the virtual counter-timer by directly
> reading/writing the guest's CNTVCT_EL0. This is problematic because
> counters continue to elapse while the register is being written, meaning
> it is possible for drift to sneak in to the guest's time scale. This is
> exacerbated by the fact that KVM will calculate an appropriate
> CNTVOFF_EL2 every time the register is written, which will be broadcast
> to all virtual CPUs. The only possible way to avoid causing guest time
> to drift is to restore counter-timers by offset.
>
> Implement initial support for KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
> to migrate the value of CNTVOFF_EL2. These ioctls yield precise control
> of the virtual counter-timers to userspace, allowing it to define its
> own heuristics for managing vCPU offsets.
>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jing Zhang <jingzhangos@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 +++++
>  arch/arm64/include/uapi/asm/kvm.h | 10 ++++++++++
>  arch/arm64/kvm/arch_timer.c       | 22 ++++++++++++++++++++++
>  arch/arm64/kvm/arm.c              | 25 +++++++++++++++++++++++++
>  4 files changed, 62 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cd7d5c8c4bc..31107d5e61af 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -781,4 +781,9 @@ void __init kvm_hyp_reserve(void);
>  static inline void kvm_hyp_reserve(void) { }
>  #endif
>
> +int kvm_arm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
> +                                         struct kvm_system_counter_state *state);
> +int kvm_arm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
> +                                         struct kvm_system_counter_state *state);
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 24223adae150..d3987089c524 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -184,6 +184,16 @@ struct kvm_vcpu_events {
>         __u32 reserved[12];
>  };
>
> +/* for KVM_{GET,SET}_SYSTEM_COUNTER_STATE */
> +struct kvm_system_counter_state {
> +       /* indicates what fields are valid in the structure */
> +       __u32 flags;
> +       __u32 pad;
> +       /* guest counter-timer offset, relative to host cntpct_el0 */
> +       __u64 cntvoff;
> +       __u64 rsvd[7];
> +};
> +
>  /* If you need to interpret the index values, here is the key: */
>  #define KVM_REG_ARM_COPROC_MASK                0x000000000FFF0000
>  #define KVM_REG_ARM_COPROC_SHIFT       16
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 74e0699661e9..955a7a183362 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1259,3 +1259,25 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>         return -ENXIO;
>  }
> +
> +int kvm_arm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
> +                                         struct kvm_system_counter_state *state)
> +{
> +       if (state->flags)
> +               return -EINVAL;
> +
> +       state->cntvoff = timer_get_offset(vcpu_vtimer(vcpu));
> +
> +       return 0;
> +}
> +
> +int kvm_arm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
> +                                         struct kvm_system_counter_state *state)
> +{
> +       if (state->flags)
> +               return -EINVAL;
> +
> +       timer_set_offset(vcpu_vtimer(vcpu), state->cntvoff);

Adding some discussion that Ricardo and I had regarding this portion
of the patch:

Ricardo asks if it would make more sense to have the
KVM_SET_SYSTEM_COUNTER_STATE ioctl broadcast the counter offset to all
vCPUs, like we do for the value-based SET_REG() implementation. To me,
the broadcasting was more necessary for the value-based interface as
it is difficult/impossible to synchronize by value, but now some of
the onus to do the right thing might be on the VMM. No strong opinions
either way, so open to suggestions here.

--
Thanks,
Oliver

> +
> +       return 0;
> +}
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1126eae27400..b78ffb4db9dd 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -207,6 +207,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_SET_GUEST_DEBUG:
>         case KVM_CAP_VCPU_ATTRIBUTES:
>         case KVM_CAP_PTP_KVM:
> +       case KVM_CAP_SYSTEM_COUNTER_STATE:
>                 r = 1;
>                 break;
>         case KVM_CAP_SET_GUEST_DEBUG2:
> @@ -1273,6 +1274,30 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>
>                 return kvm_arm_vcpu_finalize(vcpu, what);
>         }
> +       case KVM_GET_SYSTEM_COUNTER_STATE: {
> +               struct kvm_system_counter_state state;
> +
> +               if (copy_from_user(&state, argp, sizeof(state)))
> +                       return -EFAULT;
> +
> +               r = kvm_arm_vcpu_get_system_counter_state(vcpu, &state);
> +               if (r)
> +                       break;
> +
> +               if (copy_to_user(argp, &state, sizeof(state)))
> +                       return -EFAULT;
> +
> +               break;
> +       }
> +       case KVM_SET_SYSTEM_COUNTER_STATE: {
> +               struct kvm_system_counter_state state;
> +
> +               if (copy_from_user(&state, argp, sizeof(state)))
> +                       return -EFAULT;
> +
> +               r = kvm_arm_vcpu_set_system_counter_state(vcpu, &state);
> +               break;
> +       }
>         default:
>                 r = -EINVAL;
>         }
> --
> 2.32.0.rc1.229.g3e70b5a671-goog
>
