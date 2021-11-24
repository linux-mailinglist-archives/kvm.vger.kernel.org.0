Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B32C45C75E
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 15:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353512AbhKXOdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 09:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355088AbhKXOdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 09:33:51 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C48BC1428D6
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 05:09:00 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id t19so5251316oij.1
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 05:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1rvmNxp+ZtA3HbUdsVCZv4Nlqvs5Xp/+S8TXy0ecUM0=;
        b=pl/FfakhouFer+0yVcn+lqB8MhZkiNrWzu3kYkf5qnxnJqtGJSIs4PYBZfPz2TD4vP
         l6N0I7MlQDR0L+5RYQ2pPRcbMCcJOObJKlv1TwjAeqeR5ZQ2QIHK6uC+kfCCwExqX+ef
         7qxrz0adF7nAZuWapS7EUhelX6F3A8P8KislRj4qV4ey7KJEhASK28fFfEz8N4MSX6zw
         gn7VKGg342BuZ3GquHXcFojbeTege8EanA9l7BvkHPKf+pOehvz3FE58xZvEffVXdku9
         TnWo8TNgn4WtWOGJJgr1Tuik0NzcKARfVrYny+xL/r1NDnoeoItfUSp7PmDZ8HcUOket
         W/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1rvmNxp+ZtA3HbUdsVCZv4Nlqvs5Xp/+S8TXy0ecUM0=;
        b=hJ1mUwzflcew4xVkFaBJFls6YJE+Vhwv/VbWK0tFuEBemdEqi+qDfy8C92co29Gzvb
         r8d7CtV3K0j/HL6S766mHmLd0xpGcJom4HrY78MIoJxE/HWA5HFW0yFavvfu4AxMjQUa
         HPpLS28HCDBC8u40xpHgQ+Qd/9TY0vEzatXPVAnFQ0e7zKH1Fvfs3Mrd56HMioe0CgDy
         fxbqyuswU8VyCeNUbmKDY/TmRpv9rAXvbeNXtGk0c30tGADNeAeZIRcSxQkK3rYx6S/m
         JP6JXykA0bo1Po8N6w1n5PyfC9kfy5VtJO8p9VgPLmIJaTeS9WXqfpp8dXtJApRusYs4
         oDHw==
X-Gm-Message-State: AOAM532NTyiP3G6jiVC7y9GmsNbxq504xgWyxBi5OiZ4OscGg92dF3rF
        VnCyFjWlJDzgpvBCOh2TJrrHjiZID88fVdRwZ3kFZw==
X-Google-Smtp-Source: ABdhPJyTVHnCyxx52YxNwzJrYF43Uk3OQDtKuXCZO7KVCqWd190uR7WGLd+soVX2N6327m8SSW4aKEgqDjPt01EJeRQ=
X-Received: by 2002:a05:6808:485:: with SMTP id z5mr5828262oid.96.1637759339134;
 Wed, 24 Nov 2021 05:08:59 -0800 (PST)
MIME-Version: 1.0
References: <20211123142247.62532-1-maz@kernel.org> <20211123142247.62532-2-maz@kernel.org>
In-Reply-To: <20211123142247.62532-2-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 24 Nov 2021 13:08:23 +0000
Message-ID: <CA+EHjTx1i0jEhhBJx6T=6sjkj_hpy5FnkkJqFuY0td83d6C08A@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Save PSTATE early on exit
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
> In order to be able to use promitives such as vcpu_mode_is_32bit(),
> we need to synchronize the guest PSTATE. However, this is currently
> done deep imto the bowels of the world-switch code, and we do have
> helpers evaluating this much earlier (__vgic_v3_perform_cpuif_access
> and handle_aarch32_guest, for example).

Couple of nits:
s/promitives/primitives
s/imto/into

>
> Move the saving of the guest pstate into the early fixups, which
> cures the first issue. The second one will be addressed separately.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h    | 6 ++++++
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 7 ++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 7a0af1d39303..d79fd101615f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -429,6 +429,12 @@ static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>   */
>  static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> +       /*
> +        * Save PSTATE early so that we can evaluate the vcpu mode
> +        * early on.
> +        */
> +       vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
> +
>         if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
>                 vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index de7e14c862e6..7ecca8b07851 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -70,7 +70,12 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
>  {
>         ctxt->regs.pc                   = read_sysreg_el2(SYS_ELR);
> -       ctxt->regs.pstate               = read_sysreg_el2(SYS_SPSR);
> +       /*
> +        * Guest PSTATE gets saved at guest fixup time in all
> +        * cases. We still need to handle the nVHE host side here.
> +        */
> +       if (!has_vhe() && ctxt->__hyp_running_vcpu)
> +               ctxt->regs.pstate       = read_sysreg_el2(SYS_SPSR);
>
>         if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
>                 ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
> --
> 2.30.2
>

I see that now that you're storing pstate early at the guest exit, and
therefore no need for vhe path to check for it for the guest when saving
the return state. Going through the various possibilities, I think
that all cases are covered.

I tested this code as well and it ran fine.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad
