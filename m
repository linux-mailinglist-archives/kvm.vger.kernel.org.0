Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19630508272
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 09:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376307AbiDTHpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 03:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376277AbiDTHps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 03:45:48 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFBF3B578
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 00:43:02 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id f17so1350867ybj.10
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 00:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cic/lmVeICvTPM3bIFzSlnqztIyS7Y2EoW5ARigCG0A=;
        b=s/ciJ8lMhG4LLgARFOfSM8q0G/vnREGeJ2tEuGmZ6Qz1x6PcfJ3F9bjpoNTp9q28S8
         /N8Md10+1Hw3XlKP2UFVKbmaXKPUg4UCnMfyyxtO1ZXXiF/dOrIzNxuHB4aYG+JWXRTl
         aIXcM0vNX7r4oypff+hHWhIS+iEa26RDMZyQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cic/lmVeICvTPM3bIFzSlnqztIyS7Y2EoW5ARigCG0A=;
        b=4MEgv0p89ekH9/2sHE+b13x2pFXDQWUjM7fLrfg7PpMSs1rEOYBSGK480mK3USrN8o
         0K30YLJUWF/GgEzdlrnfYTCmDkMnyDTa4Ic/DxEjlIJzIR6BAelEkHTMZ8OaZi1JIXwp
         lTZ3giHdyagWyU6q37BO1Y7Lzo//c4m9q8KF6dG9LBEMcI2RI7bvzHY5oHwB6sgwvRFy
         cdK9T7U7u2fH9+WgfUEFgb4/qxPi2eC7fuyGu5oLON3ewcHRk02tN2Wjcm1N7up4quEX
         Fwl1Ci5cRxP+IFnCILKWuN7nJGMZZdiMNteRR52l4HrJvRIrVhJmKPrG8RS+yzfqgF1o
         VbyA==
X-Gm-Message-State: AOAM532kjqZ+kXpYrDPfE5roI8hfm1ts54MuI5dqSBRaXznwFzUkc+1N
        TB7D1XCKiZfAeu175SAVzBBAU1clMvjMvFDFokXNWhNRa+SZ
X-Google-Smtp-Source: ABdhPJy6qgrX3X0fcMprBIXxkdVXgaBpxQHgQNT5mrlWB67ltcFM8mvuiIGYv+VxFX94vHy9xIzWFAjaUpdkySngZZo=
X-Received: by 2002:a5b:803:0:b0:633:749f:9acd with SMTP id
 x3-20020a5b0803000000b00633749f9acdmr19288159ybp.236.1650440581619; Wed, 20
 Apr 2022 00:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220420013258.3639264-1-atishp@rivosinc.com> <20220420013258.3639264-3-atishp@rivosinc.com>
In-Reply-To: <20220420013258.3639264-3-atishp@rivosinc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Wed, 20 Apr 2022 00:42:50 -0700
Message-ID: <CAOnJCU+EPHxD7MqbswKMy=gZhmyyXMiezqaw1+D1h+O+pbYR2w@mail.gmail.com>
Subject: Re: [PATCH 2/2] RISC-V: KVM: Restrict the extensions that can be disabled
To:     Atish Patra <atishp@rivosinc.com>
Cc:     KVM General <kvm@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        devicetree <devicetree@vger.kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 6:33 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> Currently, the config reg register allows to disable all allowed
> single letter ISA extensions. It shouldn't be the case as vmm
> shouldn't be able disable base extensions (imac).

/s/able/able to/

> These extensions should always be enabled as long as they are enabled
> in the host ISA.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 2e25a7b83a1b..14dd801651e5 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -38,12 +38,16 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>                        sizeof(kvm_vcpu_stats_desc),
>  };
>
> -#define KVM_RISCV_ISA_ALLOWED  (riscv_isa_extension_mask(a) | \
> -                                riscv_isa_extension_mask(c) | \
> -                                riscv_isa_extension_mask(d) | \
> -                                riscv_isa_extension_mask(f) | \
> -                                riscv_isa_extension_mask(i) | \
> -                                riscv_isa_extension_mask(m))
> +#define KVM_RISCV_ISA_DISABLE_ALLOWED  (riscv_isa_extension_mask(d) | \
> +                                       riscv_isa_extension_mask(f))
> +
> +#define KVM_RISCV_ISA_DISABLE_NOT_ALLOWED      (riscv_isa_extension_mask(a) | \
> +                                               riscv_isa_extension_mask(c) | \
> +                                               riscv_isa_extension_mask(i) | \
> +                                               riscv_isa_extension_mask(m))
> +
> +#define KVM_RISCV_ISA_ALLOWED (KVM_RISCV_ISA_DISABLE_ALLOWED | \
> +                              KVM_RISCV_ISA_DISABLE_NOT_ALLOWED)
>
>  static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
> @@ -217,9 +221,10 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>         switch (reg_num) {
>         case KVM_REG_RISCV_CONFIG_REG(isa):
>                 if (!vcpu->arch.ran_atleast_once) {
> -                       vcpu->arch.isa = reg_val;
> +                       /* Ignore the disable request for these extensions */
> +                       vcpu->arch.isa = reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED;
>                         vcpu->arch.isa &= riscv_isa_extension_base(NULL);
> -                       vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
> +                       vcpu->arch.isa &= KVM_RISCV_ISA_DISABLE_ALLOWED;
>                         kvm_riscv_vcpu_fp_reset(vcpu);
>                 } else {
>                         return -EOPNOTSUPP;
> --
> 2.25.1
>

Sorry. I forgot to add the fixes tag.

Fixes: 92ad82002c39 (RISC-V: KVM: Implement
KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls)

-- 
Regards,
Atish
