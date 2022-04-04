Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D734F0DD6
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 05:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiDDEAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 00:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiDDEAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 00:00:00 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72A036174
        for <kvm@vger.kernel.org>; Sun,  3 Apr 2022 20:58:04 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t13so7277020pgn.8
        for <kvm@vger.kernel.org>; Sun, 03 Apr 2022 20:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PIS05ym5w1d+Mlq2cABcR0KR9m3g+YJtsa/sE4OhS2k=;
        b=AMK1z3WsncgnRYcnZkhTzdfB2tmThpo1J+RJmQF+9WzSoLI+bawDcdr/Ade56iAQBX
         i3+ZFq6PQM7ASZYAlLyuXNS9zkf3xNRY+s/gWnzzzbjLkp/RZs9axi/AGLV+s02n4a7R
         ULbkQuGHamOI5DhZ/7NfIUkgSueZ8cDF/5oakXvCaJvFf8h0PxskUuCovzTxfzx4oroM
         7xK+24d7heHb03MhTazG0mtjzS6VKOrdNtrgWDaIyKjFGcf8ZBmgl6hyD4sCsUotZhSc
         4aj4QB7APIZiuwdo7euIsYeCUhNnzS2puBHlg7pbXWA7gMYXYgItj9ecpwQMmWFOF2NS
         UI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PIS05ym5w1d+Mlq2cABcR0KR9m3g+YJtsa/sE4OhS2k=;
        b=TKpbPw1UYK0VTUzzOKzOdZnqGS0wQrP15xU8/fq5tO5AICSyKF+waj/ZbjK231wfje
         bKHoYV1ox0zhaRnC52N9N8fPtNTXgkEH6PUNrHgN02gxYcMV4XIIFB+HqtMMyPjAccd3
         GfPGflRh8dtuQL6RP8Atyx1yfePEQGEQXPtxh6mMb7Cge6LsZKArL96jBHIB07raukdj
         aqKRz5OwfnbBSY+enH+wesuSFUokahScdj7+INh+yTnCsDGAKiwdxQXEvAQKDBhoBB4e
         I1WeCSsA/53OcVGBDgk8c2BUyWpZM0yJ0rCiiZESc2JDprthQUfC+df1G6DI8quWKPZn
         zHSA==
X-Gm-Message-State: AOAM533N7G1TV1fMw5r0bKpX8mEfrZ6t6gsJahHw94hG6Z2Pco4OWS5I
        d0UPb8qVAUEkt5w6AcYxU2mi5z9FdWVpeTpN4QEIaw==
X-Google-Smtp-Source: ABdhPJwmoXhGeQNRDquyBYcS4RsvdcgA6YiyfzIFEASfaq4Kklv+UmNjM2R6OUs2nFFulBe2SAznKzgf7AgF8xCU67o=
X-Received: by 2002:a63:af47:0:b0:398:4be1:ce1d with SMTP id
 s7-20020a63af47000000b003984be1ce1dmr24515445pgo.514.1649044683975; Sun, 03
 Apr 2022 20:58:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com> <20220401010832.3425787-3-oupton@google.com>
In-Reply-To: <20220401010832.3425787-3-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 3 Apr 2022 20:57:47 -0700
Message-ID: <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Plumb cp10 ID traps through the
 AArch64 sysreg handler
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

On Thu, Mar 31, 2022 at 6:08 PM Oliver Upton <oupton@google.com> wrote:
>
> In order to enable HCR_EL2.TID3 for AArch32 guests KVM needs to handle
> traps where ESR_EL2.EC=0x8, which corresponds to an attempted VMRS
> access from an ID group register. Specifically, the MVFR{0-2} registers
> are accessed this way from AArch32. Conveniently, these registers are
> architecturally mapped to MVFR{0-2}_EL1 in AArch64. Furthermore, KVM
> already handles reads to these aliases in AArch64.
>
> Plumb VMRS read traps through to the general AArch64 system register
> handler.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/handle_exit.c      |  1 +
>  arch/arm64/kvm/sys_regs.c         | 61 +++++++++++++++++++++++++++++++
>  3 files changed, 63 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0e96087885fe..7a65ac268a22 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -673,6 +673,7 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
>  int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
>  int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
>  int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
> +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
>
>  void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 97fe14aab1a3..5088a86ace5b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -167,6 +167,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>         [ESR_ELx_EC_CP15_64]    = kvm_handle_cp15_64,
>         [ESR_ELx_EC_CP14_MR]    = kvm_handle_cp14_32,
>         [ESR_ELx_EC_CP14_LS]    = kvm_handle_cp14_load_store,
> +       [ESR_ELx_EC_CP10_ID]    = kvm_handle_cp10_id,
>         [ESR_ELx_EC_CP14_64]    = kvm_handle_cp14_64,
>         [ESR_ELx_EC_HVC32]      = handle_hvc,
>         [ESR_ELx_EC_SMC32]      = handle_smc,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 8b791256a5b4..4863592d060d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2341,6 +2341,67 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>
>  static int emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
>
> +/*
> + * The CP10 ID registers are architecturally mapped to AArch64 feature
> + * registers. Abuse that fact so we can rely on the AArch64 handler for accesses
> + * from AArch32.
> + */
> +static bool kvm_esr_cp10_id_to_sys64(u32 esr, struct sys_reg_params *params)
> +{
> +       params->is_write = ((esr & 1) == 0);
> +       params->Op0 = 3;
> +       params->Op1 = 0;
> +       params->CRn = 0;
> +       params->CRm = 3;
> +
> +       switch ((esr >> 10) & 0xf) {
> +       /* MVFR0 */
> +       case 0b0111:
> +               params->Op2 = 0;
> +               break;
> +       /* MVFR1 */
> +       case 0b0110:
> +               params->Op2 = 1;
> +               break;
> +       /* MVFR2 */
> +       case 0b0101:
> +               params->Op2 = 2;
> +               break;
> +       default:
> +               return false;
> +       }
> +
> +       return true;
> +}
> +
> +/**
> + * kvm_handle_cp10_id() - Handles a VMRS trap on guest access to a 'Media and
> + *                       VFP Register' from AArch32.
> + * @vcpu: The vCPU pointer
> + *
> + * MVFR{0-2} are architecturally mapped to the AArch64 MVFR{0-2}_EL1 registers.
> + * Work out the correct AArch64 system register encoding and reroute to the
> + * AArch64 system register emulation.
> + */
> +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
> +{
> +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> +       u32 esr = kvm_vcpu_get_esr(vcpu);
> +       struct sys_reg_params params;
> +       int ret;
> +
> +       /* UNDEF on any unhandled register or an attempted write */
> +       if (!kvm_esr_cp10_id_to_sys64(esr, &params) || params.is_write) {
> +               kvm_inject_undefined(vcpu);

Nit: For debugging, it might be more useful to use unhandled_cp_access()
(, which needs to be changed to support ESR_ELx_EC_CP10_ID though)
rather than directly calling kvm_inject_undefined().

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji



> +               return 1;
> +       }
> +
> +       ret = emulate_sys_reg(vcpu, &params);
> +
> +       vcpu_set_reg(vcpu, Rt, params.regval);
> +       return ret;
> +}
> +
>  /**
>   * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
>   *                            CRn=0, which corresponds to the AArch32 feature
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
