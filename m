Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3633B63B3E0
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 22:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiK1VF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 16:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234437AbiK1VFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 16:05:04 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3EC2F662
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:04:53 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id q2-20020a4a8e02000000b004a0236114ecso1837845ook.11
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vRGZCzUJ0ffhia8X2kGoAwEvcGD3EwbjnSNO0K2/wNw=;
        b=EhD2l7i+4krHkkf9vXvO2XsUcD5IiujCezypdNr4fvjW3w70qr5E41O4r2ZyXRmXjX
         p2HI+fJuTvI6Df3He52fE/lU7Dze89xJ1KoZPBtv/zmd2NwCZbj6MT+RAYsDKrxYWBfz
         FiEBLvVukJYZpWpxIjqmBORfCsfBEET/jcuTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vRGZCzUJ0ffhia8X2kGoAwEvcGD3EwbjnSNO0K2/wNw=;
        b=TZELIFOvVBJnT8+NAhN25OgWi7mvjU+TehAnjI6dzE0pKMZOaZn3aEtcOy5MprpvC1
         CSprQ1mGkD0ciU7WNFaNdjeq6/nYjsO7fdYQava4U5dsNLYa8SJw7YO1Co5WHYeuTbBZ
         ajDLsCmSAENFCVjkslwXtDe/qN4FSFYN3/sX6HGFchKgVE2yn96tTeBrI0xcK5PUKEsP
         yX9UYW6XNAKJbyqP9ICVmBoJwmx+jdPviOTpU7yEQ0WD1EyN/oeXpsk1mKpHERXCs3BK
         KBOXpgWCztiSHgHoa4zV9DuD64DktijLXgq6P++90jEnNzXe21M7UgXFIrYEqdemDiGG
         5g8Q==
X-Gm-Message-State: ANoB5pmEVl7ob+Qd92309ugmmXmE07FuB4etQzv2hQovfrGSvY0V3Qwq
        1aoIYhebnMezDk2KSvVi1vB0ISyKt+bi6voiooQI
X-Google-Smtp-Source: AA0mqf5+31JnISbgZecc7GnG0/XpncjmVgCp7OXM0CWoMRMxsX14BRJcn81qDRI9NepRLIRfMzvOi8k7RRpSLWuz2hI=
X-Received: by 2002:a4a:c58a:0:b0:49f:4297:5612 with SMTP id
 x10-20020a4ac58a000000b0049f42975612mr15036822oop.13.1669669492686; Mon, 28
 Nov 2022 13:04:52 -0800 (PST)
MIME-Version: 1.0
References: <20221128161424.608889-1-apatel@ventanamicro.com> <20221128161424.608889-5-apatel@ventanamicro.com>
In-Reply-To: <20221128161424.608889-5-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 28 Nov 2022 13:04:42 -0800
Message-ID: <CAOnJCULajHen9us+AePGKarM1xSXp0wVBXyz7ySQyZz9YQvFaQ@mail.gmail.com>
Subject: Re: [PATCH 4/9] RISC-V: KVM: Use switch-case in kvm_riscv_vcpu_set/get_reg()
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 8:14 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> We should use switch-case in kvm_riscv_vcpu_set/get_reg() functions
> because the else-if ladder is quite big now.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 982a3f5e7130..68c86f632d37 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -544,22 +544,26 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
>  static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
>                                   const struct kvm_one_reg *reg)
>  {
> -       if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
> +       switch (reg->id & KVM_REG_RISCV_TYPE_MASK) {
> +       case KVM_REG_RISCV_CONFIG:
>                 return kvm_riscv_vcpu_set_reg_config(vcpu, reg);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
> +       case KVM_REG_RISCV_CORE:
>                 return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
> +       case KVM_REG_RISCV_CSR:
>                 return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
> +       case KVM_REG_RISCV_TIMER:
>                 return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_F)
> +       case KVM_REG_RISCV_FP_F:
>                 return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
>                                                  KVM_REG_RISCV_FP_F);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_D)
> +       case KVM_REG_RISCV_FP_D:
>                 return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
>                                                  KVM_REG_RISCV_FP_D);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_ISA_EXT)
> +       case KVM_REG_RISCV_ISA_EXT:
>                 return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
> +       default:
> +               break;
> +       }
>
>         return -EINVAL;
>  }
> @@ -567,22 +571,26 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
>  static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
>                                   const struct kvm_one_reg *reg)
>  {
> -       if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
> +       switch (reg->id & KVM_REG_RISCV_TYPE_MASK) {
> +       case KVM_REG_RISCV_CONFIG:
>                 return kvm_riscv_vcpu_get_reg_config(vcpu, reg);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
> +       case KVM_REG_RISCV_CORE:
>                 return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
> +       case KVM_REG_RISCV_CSR:
>                 return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
> +       case KVM_REG_RISCV_TIMER:
>                 return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_F)
> +       case KVM_REG_RISCV_FP_F:
>                 return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
>                                                  KVM_REG_RISCV_FP_F);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_D)
> +       case KVM_REG_RISCV_FP_D:
>                 return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
>                                                  KVM_REG_RISCV_FP_D);
> -       else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_ISA_EXT)
> +       case KVM_REG_RISCV_ISA_EXT:
>                 return kvm_riscv_vcpu_get_reg_isa_ext(vcpu, reg);
> +       default:
> +               break;
> +       }
>
>         return -EINVAL;
>  }
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
-- 
Regards,
Atish
