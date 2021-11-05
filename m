Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9102445EED
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 04:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhKED7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 23:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhKED7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 23:59:14 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F50AC061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 20:56:35 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id k2so7748241pff.11
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 20:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3wzCgdFVdw6+KUtgInc5+5Sbc8SrtKRSrnApz5Y+jeQ=;
        b=S+/4Q6QNYuQugIhLdDHf2a3Og0StCOyC+kge87/awMeP/5Fgbg9qnr1APpQUsz/UAM
         Bbq69bcOIWc4EGZu1HORI/p9eC/Dje1yzEtQyMVXDw6uBhRNi+1NLulnftduefqHtel8
         8zpaLfL9QyQoqzLmFdhmJnDOspuiJsQFnSdC4trY4XjoSVebcrxEBlCmvSIwHhVYKgyF
         v96/DwYsm0VN9+/0Hdp5NBienp5Hwrxa3WksKzeyPDv9+8/SrkYBnHVmalusDxKtc62h
         73MGov85pzhPv5WnN+aCx7pAPCJE3ksiRlxr1Rr64+tOLrZ7ZpdK+URQOGLl53T5aPAV
         2FCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3wzCgdFVdw6+KUtgInc5+5Sbc8SrtKRSrnApz5Y+jeQ=;
        b=lQLoiWhhBFBhHq0/F8CN4rJwr+nAvT7qxRJrEnzAUMRdCnIYaMbVzRwP6/0ceLepFf
         AP1Qt2N4bKBv9jFP2Bz5f8miLrBlXFjsfL16lp2TIvU2Q4lmn3fvxQVpi90cylU44VGx
         Y5HaW8YavEWojr99FgEHGnpCXUrE2HVIPGJ2m/JBesHDk0dewu7WT+jxGb+TrrH6jILi
         jPk5xZ3sgx2tiVXFe5pvytov8v3QYWuHmjk+zK7zaHFSaS2Lq58Xpj5wzidi28bMtp0x
         7ZLEaLH+nuJ5LBEngZfTEUSUASKKlY7y88JFoSD5AOYdN0VzPW0hlcN7fYgD7OK0ddA0
         JKug==
X-Gm-Message-State: AOAM531CbUiIN6AA7IIA0FZt4JFEDVTFoLv4QutIP29ZjU6SnwxQd2dm
        WM22PoVMiI5x52LHROqZTfr+GmYbjsLz1RSUN7NDZA==
X-Google-Smtp-Source: ABdhPJz1im0CZRlcjEoH9Hj85RTATCSSQTagm0M5CLfKK2u0N4fPQ4dSLTNSwPR/Tp1tfPu14Bp8RaT6u96ndH1hGB0=
X-Received: by 2002:a65:4889:: with SMTP id n9mr1359889pgs.303.1636084594368;
 Thu, 04 Nov 2021 20:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com> <20211102094651.2071532-5-oupton@google.com>
In-Reply-To: <20211102094651.2071532-5-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 4 Nov 2021 20:56:18 -0700
Message-ID: <CAAeT=FwKJLaxNU+2BGWZh=HdTY=NWBzGdN=cTDPKv3x6cG2UsA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Emulate the OS Lock
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
>
> The OS lock blocks all debug exceptions at every EL. To date, KVM has
> not implemented the OS lock for its guests, despite the fact that it is
> mandatory per the architecture. Simple context switching between the
> guest and host is not appropriate, as its effects are not constrained to
> the guest context.
>
> Emulate the OS Lock by clearing MDE and SS in MDSCR_EL1, thereby
> blocking all but software breakpoint instructions. To handle breakpoint
> instructions, trap debug exceptions to EL2 and skip the instruction.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  4 ++++
>  arch/arm64/kvm/debug.c            | 20 +++++++++++++++-----
>  arch/arm64/kvm/handle_exit.c      |  8 ++++++++
>  arch/arm64/kvm/sys_regs.c         |  6 +++---
>  4 files changed, 30 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c98f65c4a1f7..f13b8b79b06d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -724,6 +724,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> +
> +#define kvm_vcpu_os_lock_enabled(vcpu)         \
> +       (__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK)

I would think the name of this macro might sound like it generates
a code that is evaluated as bool :)


> +
>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>                                struct kvm_device_attr *attr);
>  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index db9361338b2a..5690a9c99c89 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -95,8 +95,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>                                 MDCR_EL2_TDRA |
>                                 MDCR_EL2_TDOSA);
>
> -       /* Is the VM being debugged by userspace? */
> -       if (vcpu->guest_debug)
> +       /*
> +        * Check if the VM is being debugged by userspace or the guest has
> +        * enabled the OS lock.
> +        */
> +       if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu))

IMHO, it might be nicer to create a macro or function that abstracts the
condition that needs save_guest_debug_regs/restore_guest_debug_regs.
(rather than putting those conditions in each part of codes where they
are needed)

Thanks,
Reiji




>                 /* Route all software debug exceptions to EL2 */
>                 vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
>
> @@ -160,8 +163,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>
>         kvm_arm_setup_mdcr_el2(vcpu);
>
> -       /* Is Guest debugging in effect? */
> -       if (vcpu->guest_debug) {
> +       /*
> +        * Check if the guest is being debugged or if the guest has enabled the
> +        * OS lock.
> +        */
> +       if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
>                 /* Save guest debug state */
>                 save_guest_debug_regs(vcpu);
>
> @@ -223,6 +229,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>                         trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
>                                                 &vcpu->arch.debug_ptr->dbg_wcr[0],
>                                                 &vcpu->arch.debug_ptr->dbg_wvr[0]);
> +               } else if (kvm_vcpu_os_lock_enabled(vcpu)) {
> +                       mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> +                       mdscr &= ~DBG_MDSCR_MDE;
> +                       vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
>                 }
>         }
>
> @@ -244,7 +254,7 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>  {
>         trace_kvm_arm_clear_debug(vcpu->guest_debug);
>
> -       if (vcpu->guest_debug) {
> +       if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
>                 restore_guest_debug_regs(vcpu);
>
>                 /*
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 275a27368a04..a7136888434d 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -119,6 +119,14 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_run *run = vcpu->run;
>         u32 esr = kvm_vcpu_get_esr(vcpu);
> +       u8 esr_ec = ESR_ELx_EC(esr);
> +
> +       if (!vcpu->guest_debug) {
> +               WARN_ONCE(esr_ec != ESR_ELx_EC_BRK64 || esr_ec != ESR_ELx_EC_BKPT32,
> +                         "Unexpected debug exception\n");
> +               kvm_incr_pc(vcpu);
> +               return 1;
> +       }
>
>         run->exit_reason = KVM_EXIT_DEBUG;
>         run->debug.arch.hsr = esr;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index acd8aa2e5a44..d336e4c66870 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1446,9 +1446,9 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>   * Debug handling: We do trap most, if not all debug related system
>   * registers. The implementation is good enough to ensure that a guest
>   * can use these with minimal performance degradation. The drawback is
> - * that we don't implement any of the external debug, none of the
> - * OSlock protocol. This should be revisited if we ever encounter a
> - * more demanding guest...
> + * that we don't implement any of the external debug architecture.
> + * This should be revisited if we ever encounter a more demanding
> + * guest...
>   */
>  static const struct sys_reg_desc sys_reg_descs[] = {
>         { SYS_DESC(SYS_DC_ISW), access_dcsw },
> --
> 2.33.1.1089.g2158813163f-goog
>
