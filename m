Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706143F14DE
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 10:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbhHSIK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 04:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbhHSIKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 04:10:55 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39322C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 01:10:19 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id r9so11022780lfn.3
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 01:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cPvH0LAivty+kbGWONu/jrOGMYsTsQGu9Ph+/kEuth0=;
        b=g5iwvH8XtD7qDEMB1qOF7bydpGwXpsD48tcbfS1oqQ1/AOUKJ58PaLfDH/Uf7ZvMxL
         9slA7pl+LKesXBh9sAoUdK8o5t7/R5NlMqMlsMViU2NaAAcTiRSwM9+7In32BROIWMiO
         SLXjhlfNgiP3XulDo6rYqIecUgk3X+GLsp90ZdVudD00utjZ/I5aZxIXqeJgsjP9XKRk
         xZ9lJZVoq7lNj7IF4r7/R+A5/lprgvfHhUtkOsOjq8Bdz71XvbkC1TqNd33VIYEGH1AE
         Gr/YN0lpgkXlpvE3F/PsNvtpnxlN/ehBHKhLXsjjZbil2pQuuexGvvUKmhZKRpsm7Gj6
         tj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cPvH0LAivty+kbGWONu/jrOGMYsTsQGu9Ph+/kEuth0=;
        b=GcEjhfIeRuP7wemGjXbE1pdlsNVtwurWo4gOKIN46nqfUJ9NuMCl69UOruWohwcF5h
         pXIZ30kSydHRb2wyNMz52nSSZZ12JlTeqwfdZq+IL8YA6bVRD3R5RsnXdD5K6Q//xogt
         TF2GGjr0uLbenapxRj2hZmWWHco4qcDLLoxRZLzmeF4ceNRPK2yUxiLTh4MhEyNqmy4u
         eO53kLM5D8nf1IwPBV9iv3Vt9AxuEr6VYf490rR0zvtY3iFohsin0aJe1DZOD6FZoXaI
         SWInSs68roQN0WZjq6aK+gZSCqEk8CTk4pVbmK04AJ2fWD6Dnh3y6tXkKzYG+8t6bfGR
         9ceg==
X-Gm-Message-State: AOAM533HyClhDI2aP23NBOmDIB4xezmzCSPbeCBzRR+babmKD9neP0RP
        eBaz7DIIKnsZzx2RmzEA3adLEi/wRB5m9GI3kBEqHw==
X-Google-Smtp-Source: ABdhPJwRJHRfC6bp+yucaRYcXg+6U4jr3ewQU/A/l03h51iZvbtfcjZ1PlG9Cpe3GEnFknctx1QJD+vQf8rj5XBM0m8=
X-Received: by 2002:a05:6512:3fa8:: with SMTP id x40mr9659895lfa.0.1629360617193;
 Thu, 19 Aug 2021 01:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com> <20210817081134.2918285-16-tabba@google.com>
In-Reply-To: <20210817081134.2918285-16-tabba@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 19 Aug 2021 01:10:06 -0700
Message-ID: <CAOQ_QsgSfHVjJkSJku5DwUe0_=ds4GduPbJ7vC-t+4_=fPVFBQ@mail.gmail.com>
Subject: Re: [PATCH v4 15/15] KVM: arm64: Handle protected guests at 32 bits
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, Alexandru.Elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Fuad,

On Tue, Aug 17, 2021 at 1:12 AM Fuad Tabba <tabba@google.com> wrote:
>
> Protected KVM does not support protected AArch32 guests. However,
> it is possible for the guest to force run AArch32, potentially
> causing problems. Add an extra check so that if the hypervisor
> catches the guest doing that, it can prevent the guest from
> running again by resetting vcpu->arch.target and returning
> ARM_EXCEPTION_IL.
>
> If this were to happen, The VMM can try and fix it by re-
> initializing the vcpu with KVM_ARM_VCPU_INIT, however, this is
> likely not possible for protected VMs.
>
> Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> AArch32 systems")
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/switch.c | 37 ++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 398e62098898..0c24b7f473bf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -20,6 +20,7 @@
>  #include <asm/kprobes.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_fixed_config.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
> @@ -195,6 +196,39 @@ exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
>                 return NULL;
>  }
>
> +/*
> + * Some guests (e.g., protected VMs) might not be allowed to run in AArch32. The
> + * check below is based on the one in kvm_arch_vcpu_ioctl_run().
> + * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
> + * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
> + * hypervisor spots a guest in such a state ensure it is handled, and don't
> + * trust the host to spot or fix it.
> + *
> + * Returns true if the check passed and the guest run loop can continue, or
> + * false if the guest should exit to the host.
> + */
> +static bool check_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)

This does a bit more than just check & return, so maybe call it
handle_aarch32_guest()?

> +{
> +       if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&

maybe initialize a local with a hyp pointer to the kvm structure.

> +           vcpu_mode_is_32bit(vcpu) &&
> +           FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
> +                                        PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) <
> +               ID_AA64PFR0_ELx_32BIT_64BIT) {

It may be more readable to initialize a local variable with this
feature check, i.e:

bool aarch32_allowed = FIELD_GET(...) == ID_AA64PFR0_ELx_32BIT_64BIT;

and then:

  if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu) &&
!aarch32_allowed) {

> +               /*
> +                * As we have caught the guest red-handed, decide that it isn't
> +                * fit for purpose anymore by making the vcpu invalid. The VMM
> +                * can try and fix it by re-initializing the vcpu with
> +                * KVM_ARM_VCPU_INIT, however, this is likely not possible for
> +                * protected VMs.
> +                */
> +               vcpu->arch.target = -1;
> +               *exit_code = ARM_EXCEPTION_IL;
> +               return false;
> +       }
> +
> +       return true;
> +}
> +
>  /* Switch to the guest for legacy non-VHE systems */
>  int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  {
> @@ -255,6 +289,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>                 /* Jump in the fire! */
>                 exit_code = __guest_enter(vcpu);
>
> +               if (unlikely(!check_aarch32_guest(vcpu, &exit_code)))
> +                       break;
> +
>                 /* And we're baaack! */
>         } while (fixup_guest_exit(vcpu, &exit_code));
>
> --
> 2.33.0.rc1.237.g0d66db33f3-goog
>
