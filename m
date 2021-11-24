Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC5045C760
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 15:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355326AbhKXOeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 09:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355278AbhKXOeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 09:34:13 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEAEC061785
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 05:12:29 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id t19so5271525oij.1
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 05:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JqN346vu81xV6yQg3GItWA6XVAjI0w4RnyXhzwybFVw=;
        b=GdE6vOdYO2UZK3IVHXRiN/8XrRot+7I7LZF7o5UQEEuqcBzZxFYFd56+wN9qno6V0o
         Xs5Tqh/QVh0kLhIA/JP3b12vua0n1kXM9QUVRyXOBfDkxWta5h+ze+lO2NIoeDIPUPVO
         7IgZfmrm+3RKHTcC0+oR+yMGXAVIf2qmOYc6aKan+x7ZzNvrP4eiLV49whZSIxw4N3t2
         Ap2Xrr0e4uMgGo5h0vj3xO+SBCN9hHTeOh/6E4Oeh9SlFHVLmgmoLrplzop1C/s3y1tt
         GqnOfRv5HV1/ECSxPVyrbBCNtF06nuTSFOciTJIELVxSSwiNFAfZ0RizPPA+n7KLtq44
         bHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JqN346vu81xV6yQg3GItWA6XVAjI0w4RnyXhzwybFVw=;
        b=gy0mQd7UxgFzYQ31FYVNT/o+Rkg/mvlFTIFRXW0R+AnYqbO0ZNxfzBY0Jx4rsqUspW
         W7a8Mu7Hh4JK8nXJ0Gn2sAC1KQktgg7cFXdCYRYL67bjrtF1WV2gDPQforogYWaZ22ce
         bKp9znS95Gs5VJ+6LuYSae0BpcrOQ/7lYKMWG2t3VPXqsi1Wd+E9FAVH3sg/5D4l1Nhu
         JTbK8lPqwCfvPyDLqFVAbg6r+Iux20dIw7PVls5FgKZFnYClt0btVXHl8GeXD/h92eK3
         nykVlA9RKiqToKfYTSjpezV0pBWVVIfmhWWZzn2+d43wcUWVUyUVq84QyHRn5GvsBnBq
         HICg==
X-Gm-Message-State: AOAM5339HLAOzl/O7KL445ukrnLKfexiK/Zm1eUXTgvWHZQ/8m2NNm97
        KjcciPIOElyTg3trilxgXVff08h9VW6BNQPPN9o+2w==
X-Google-Smtp-Source: ABdhPJx6aGoSfut46o7LozaSaGDBEYjnElPUGNTmNdIG3WvaJORhEJnZ4e5LPQV4sDNoPQnTg2+QL6dL0q6ON8peIzc=
X-Received: by 2002:aca:a88f:: with SMTP id r137mr5760840oie.85.1637759547911;
 Wed, 24 Nov 2021 05:12:27 -0800 (PST)
MIME-Version: 1.0
References: <20211123142247.62532-1-maz@kernel.org> <20211123142247.62532-3-maz@kernel.org>
In-Reply-To: <20211123142247.62532-3-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 24 Nov 2021 13:11:52 +0000
Message-ID: <CA+EHjTx47iiyKNuS5utSScSNbnE74Mktiv1AA9wwvTBF+U4LTw@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Move pkvm's special 32bit handling into a
 generic infrastructure
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Nov 23, 2021 at 2:23 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Protected KVM is trying to turn AArch32 exceptions into an illegal
> exception entry. Unfortunately, it does that it a way that is a bit

Small nit: s/it/in

> abrupt, and too early for PSTATE to be available.

> Instead, move it to the fixup code, which is a more reasonable place
> for it. This will also be useful for the NV code.

This approach seems to be easier to generalize for other cases than
the previous one.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 8 ++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 8 +-------
>  arch/arm64/kvm/hyp/vhe/switch.c         | 4 ++++
>  3 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index d79fd101615f..96c5f3fb7838 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -403,6 +403,8 @@ typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
>
>  static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu);
>
> +static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code);
> +
>  /*
>   * Allow the hypervisor to handle the exit with an exit handler if it has one.
>   *
> @@ -435,6 +437,12 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>          */
>         vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
>
> +       /*
> +        * Check whether we want to repaint the state one way or
> +        * another.
> +        */
> +       early_exit_filter(vcpu, exit_code);
> +
>         if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
>                 vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index c0e3fed26d93..d13115a12434 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -233,7 +233,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
>   * Returns false if the guest ran in AArch32 when it shouldn't have, and
>   * thus should exit to the host, or true if a the guest run loop can continue.
>   */
> -static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>         struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>
> @@ -248,10 +248,7 @@ static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
>                 vcpu->arch.target = -1;
>                 *exit_code &= BIT(ARM_EXIT_WITH_SERROR_BIT);
>                 *exit_code |= ARM_EXCEPTION_IL;
> -               return false;
>         }
> -
> -       return true;
>  }
>
>  /* Switch to the guest for legacy non-VHE systems */
> @@ -316,9 +313,6 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>                 /* Jump in the fire! */
>                 exit_code = __guest_enter(vcpu);
>
> -               if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
> -                       break;
> -
>                 /* And we're baaack! */
>         } while (fixup_guest_exit(vcpu, &exit_code));
>
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 5a2cb5d9bc4b..fbb26b93c347 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -112,6 +112,10 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
>         return hyp_exit_handlers;
>  }
>
> +static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
> +{
> +}
> +
>  /* Switch to the guest for VHE systems running in EL2 */
>  static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  {
> --
> 2.30.2
>
