Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595116D0753
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjC3Nwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 09:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjC3Nwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 09:52:34 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD425597
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 06:52:31 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id t17-20020a05600c451100b003edc906aeeaso3308087wmo.1
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 06:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680184350;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nmvB0NTQrDiRlfzH0jLgbkaEBBtUzQLvijPN/bRob8w=;
        b=AYgPkVd7iJiubq8H2FPVHuum6aZF05/ggCLt56WcB2sjHMuZivzroGFUxkoKZ+QHnR
         mQqPWX2Tv4oadh+gODiF1eggMV4drMPbVIUDsvxVd8HncBF1BQycNxdIPWDvd0Gxy5N7
         W+nM3WPC++V9zeWlF704MMZtjfoUgYwXVSO/heMxMqoWSaFCgSPrKBiOS3qXV8zeWC8g
         Hu9KrRef73ICuTLhwUlBshjbjFUeAim1Spc+croSoWftFepcWGc8jHeAD4/A/rG7PQMY
         siGmt6lzEh4/TQgUSOrbEoAuYijKd8k6mVP67NNzrJeIVVZAkEtl6+Mxk1VjDQXtvrHw
         fhtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680184350;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmvB0NTQrDiRlfzH0jLgbkaEBBtUzQLvijPN/bRob8w=;
        b=zsmxKxxoL8jm2h2zNYjIdO7otpC/jYWq70mkdhBIrsSMCzqdlfGm5HJ6qHt76ohnAV
         PcwXDluputde3Od7h4En/QjvJLA/GeZJ5kUMijQR3ejOx4COuoJ9aV7i1CvypwYTryWG
         /Ph+FDdnJrkdPcQ6wZHeRMLobs3X85aiNN2DlSURZQrJ2LuyWzGbRxsWtug/bB7vshu4
         qdpPOnPxIlRqot38R/LGvSddQZdnetpBmbSmPVQEH8nFEuU5yXzmPSJT4swTFoGEM/7n
         wJbBPPnSwD2MDBEZLfjynPuPMcnjTYjXzgMHz+VfpGhXRiDPq6c288j+JDJ7DmH+HdPl
         1S0A==
X-Gm-Message-State: AO0yUKW2eQL7pItI0MbvFNXB2c6cjKE7y+hTZmzU257gW+Me62cbAiIi
        wXti36Bl0dMZsyDRTQuPbTtC1A==
X-Google-Smtp-Source: AK7set/3cVyO8ccelqupRVgfsJaEF40qp7oCqfaSHeVzcEevJWac3px5O5OAVonM4CPmfryVUmJ7Ag==
X-Received: by 2002:a05:600c:3642:b0:3e2:1d1e:78d6 with SMTP id y2-20020a05600c364200b003e21d1e78d6mr17837142wmq.7.1680184350250;
        Thu, 30 Mar 2023 06:52:30 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id e3-20020a05600c218300b003e20cf0408esm5882606wme.40.2023.03.30.06.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 06:52:29 -0700 (PDT)
Date:   Thu, 30 Mar 2023 15:52:27 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] RISC-V: KVM: Add ONE_REG interface to
 enable/disable SBI extensions
Message-ID: <2rtvbdh234r5zvdj5rjznrs4f6mgkywfgxtwc5hfkn2kcwcsh5@3xu3duhcxwmw>
References: <20230330053135.1686577-1-apatel@ventanamicro.com>
 <20230330053135.1686577-2-apatel@ventanamicro.com>
 <7gtvgdxjwa662kfafnd5xrgugjt3w6iwv4w7rbrfeooviq2cnb@dqplsikshpzw>
 <CAK9=C2Xe2wRtv02cOCfdeKK4K=UVjWf-bLjAz_WJ80zYLE1LNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9=C2Xe2wRtv02cOCfdeKK4K=UVjWf-bLjAz_WJ80zYLE1LNQ@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 03:18:57PM +0530, Anup Patel wrote:
> On Thu, Mar 30, 2023 at 12:34 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Thu, Mar 30, 2023 at 11:01:35AM +0530, Anup Patel wrote:
> > > We add ONE_REG interface to enable/disable SBI extensions (just
> > > like the ONE_REG interface for ISA extensions). This allows KVM
> > > user-space to decide the set of SBI extension enabled for a Guest
> > > and by default all SBI extensions are enabled.
> > >
> > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > ---
> > >  arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
> > >  arch/riscv/include/uapi/asm/kvm.h     |  20 ++++
> > >  arch/riscv/kvm/vcpu.c                 |   2 +
> > >  arch/riscv/kvm/vcpu_sbi.c             | 150 +++++++++++++++++++++++---
> > >  arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
> > >  5 files changed, 163 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > index 8425556af7d1..4278125a38a5 100644
> > > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > @@ -16,6 +16,7 @@
> > >
> > >  struct kvm_vcpu_sbi_context {
> > >       int return_handled;
> > > +     bool extension_disabled[KVM_RISCV_SBI_EXT_MAX];
> > >  };
> > >
> > >  struct kvm_vcpu_sbi_return {
> > > @@ -45,7 +46,12 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
> > >                                    struct kvm_run *run,
> > >                                    u32 type, u64 flags);
> > >  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
> > > -const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
> > > +int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
> > > +                                const struct kvm_one_reg *reg);
> > > +int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> > > +                                const struct kvm_one_reg *reg);
> > > +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> > > +                             struct kvm_vcpu *vcpu, unsigned long extid);
> > >  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
> > >
> > >  #ifdef CONFIG_RISCV_SBI_V01
> > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> > > index 92af6f3f057c..33c3457b94e7 100644
> > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > @@ -108,6 +108,23 @@ enum KVM_RISCV_ISA_EXT_ID {
> > >       KVM_RISCV_ISA_EXT_MAX,
> > >  };
> > >
> > > +/*
> > > + * SBI extension IDs specific to KVM. This is not the same as the SBI
> > > + * extension IDs defined by the RISC-V SBI specification.
> > > + */
> > > +enum KVM_RISCV_SBI_EXT_ID {
> > > +     KVM_RISCV_SBI_EXT_V01 = 0,
> > > +     KVM_RISCV_SBI_EXT_TIME,
> > > +     KVM_RISCV_SBI_EXT_IPI,
> > > +     KVM_RISCV_SBI_EXT_RFENCE,
> > > +     KVM_RISCV_SBI_EXT_SRST,
> > > +     KVM_RISCV_SBI_EXT_HSM,
> > > +     KVM_RISCV_SBI_EXT_PMU,
> > > +     KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> > > +     KVM_RISCV_SBI_EXT_VENDOR,
> > > +     KVM_RISCV_SBI_EXT_MAX,
> > > +};
> > > +
> > >  /* Possible states for kvm_riscv_timer */
> > >  #define KVM_RISCV_TIMER_STATE_OFF    0
> > >  #define KVM_RISCV_TIMER_STATE_ON     1
> > > @@ -152,6 +169,9 @@ enum KVM_RISCV_ISA_EXT_ID {
> > >  /* ISA Extension registers are mapped as type 7 */
> > >  #define KVM_REG_RISCV_ISA_EXT                (0x07 << KVM_REG_RISCV_TYPE_SHIFT)
> > >
> > > +/* SBI extension registers are mapped as type 8 */
> > > +#define KVM_REG_RISCV_SBI_EXT                (0x08 << KVM_REG_RISCV_TYPE_SHIFT)
> > > +
> > >  #endif
> > >
> > >  #endif /* __LINUX_KVM_RISCV_H */
> > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > index 7d010b0be54e..311fd347c5a8 100644
> > > --- a/arch/riscv/kvm/vcpu.c
> > > +++ b/arch/riscv/kvm/vcpu.c
> > > @@ -601,6 +601,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
> > >                                                KVM_REG_RISCV_FP_D);
> > >       case KVM_REG_RISCV_ISA_EXT:
> > >               return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
> > > +     case KVM_REG_RISCV_SBI_EXT:
> > > +             return kvm_riscv_vcpu_set_reg_sbi_ext(vcpu, reg);
> > >       default:
> > >               break;
> > >       }
> > > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > > index 15fde15f9fb8..bedd7d78a5f0 100644
> > > --- a/arch/riscv/kvm/vcpu_sbi.c
> > > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > > @@ -30,17 +30,52 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> > >  };
> > >  #endif
> > >
> > > -static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> > > -     &vcpu_sbi_ext_v01,
> > > -     &vcpu_sbi_ext_base,
> > > -     &vcpu_sbi_ext_time,
> > > -     &vcpu_sbi_ext_ipi,
> > > -     &vcpu_sbi_ext_rfence,
> > > -     &vcpu_sbi_ext_srst,
> > > -     &vcpu_sbi_ext_hsm,
> > > -     &vcpu_sbi_ext_pmu,
> > > -     &vcpu_sbi_ext_experimental,
> > > -     &vcpu_sbi_ext_vendor,
> > > +struct kvm_riscv_sbi_extension_entry {
> > > +     enum KVM_RISCV_SBI_EXT_ID dis_idx;
> > > +     const struct kvm_vcpu_sbi_extension *ext_ptr;
> > > +};
> > > +
> > > +static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_V01,
> > > +             .ext_ptr = &vcpu_sbi_ext_v01,
> > > +     },
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_MAX, /* Can't be disabled */
> > > +             .ext_ptr = &vcpu_sbi_ext_base,
> > > +     },
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_TIME,
> > > +             .ext_ptr = &vcpu_sbi_ext_time,
> > > +     },
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_IPI,
> > > +             .ext_ptr = &vcpu_sbi_ext_ipi,
> > > +     },
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_RFENCE,
> > > +             .ext_ptr = &vcpu_sbi_ext_rfence,
> > > +     },
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_SRST,
> > > +             .ext_ptr = &vcpu_sbi_ext_srst,
> > > +     },
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_HSM,
> > > +             .ext_ptr = &vcpu_sbi_ext_hsm,
> > > +     },
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_PMU,
> > > +             .ext_ptr = &vcpu_sbi_ext_pmu,
> > > +     },
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> > > +             .ext_ptr = &vcpu_sbi_ext_experimental,
> > > +     },
> > > +     {
> > > +             .dis_idx = KVM_RISCV_SBI_EXT_VENDOR,
> > > +             .ext_ptr = &vcpu_sbi_ext_vendor,
> > > +     },
> > >  };
> > >
> > >  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > > @@ -99,14 +134,95 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > >       return 0;
> > >  }
> > >
> > > -const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
> > > +int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
> > > +                                const struct kvm_one_reg *reg)
> > > +{
> > > +     unsigned long __user *uaddr =
> > > +                     (unsigned long __user *)(unsigned long)reg->addr;
> > > +     unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> > > +                                         KVM_REG_SIZE_MASK |
> > > +                                         KVM_REG_RISCV_SBI_EXT);
> > > +     unsigned long i, reg_val;
> > > +     const struct kvm_riscv_sbi_extension_entry *sext = NULL;
> > > +     struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> > > +
> > > +     if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> > > +             return -EINVAL;
> > > +
> > > +     if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> > > +             return -EFAULT;
> > > +
> > > +     if (reg_num >= KVM_RISCV_SBI_EXT_MAX ||
> > > +         (reg_val != 1 && reg_val != 0))
> > > +             return -EINVAL;
> > > +
> > > +     if (vcpu->arch.ran_atleast_once)
> > > +             return -EBUSY;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> > > +             if (sbi_ext[i].dis_idx == reg_num) {
> > > +                     sext = &sbi_ext[i];
> > > +                     break;
> > > +             }
> > > +     }
> > > +     if (!sext)
> > > +             return -ENOENT;
> > > +
> > > +     scontext->extension_disabled[sext->dis_idx] = !reg_val;
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> > > +                                const struct kvm_one_reg *reg)
> > > +{
> > > +     unsigned long __user *uaddr =
> > > +                     (unsigned long __user *)(unsigned long)reg->addr;
> > > +     unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> > > +                                         KVM_REG_SIZE_MASK |
> > > +                                         KVM_REG_RISCV_SBI_EXT);
> > > +     unsigned long i, reg_val;
> > > +     const struct kvm_riscv_sbi_extension_entry *sext = NULL;
> > > +     struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> > > +
> > > +     if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> > > +             return -EINVAL;
> > > +
> > > +     if (reg_num >= KVM_RISCV_SBI_EXT_MAX)
> > > +             return -EINVAL;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> > > +             if (sbi_ext[i].dis_idx == reg_num) {
> > > +                     sext = &sbi_ext[i];
> > > +                     break;
> > > +             }
> > > +     }
> > > +     if (!sext)
> > > +             return -ENOENT;
> > > +
> > > +     reg_val = !scontext->extension_disabled[sext->dis_idx];
> > > +     if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> > > +             return -EFAULT;
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> > > +                             struct kvm_vcpu *vcpu, unsigned long extid)
> > >  {
> > > -     int i = 0;
> > > +     int i;
> > > +     const struct kvm_riscv_sbi_extension_entry *sext;
> > > +     struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> > >
> > >       for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> > > -             if (sbi_ext[i]->extid_start <= extid &&
> > > -                 sbi_ext[i]->extid_end >= extid)
> > > -                     return sbi_ext[i];
> > > +             sext = &sbi_ext[i];
> > > +             if (sext->ext_ptr->extid_start <= extid &&
> > > +                 sext->ext_ptr->extid_end >= extid) {
> > > +                     if (sext->dis_idx < KVM_RISCV_SBI_EXT_MAX &&
> > > +                         scontext->extension_disabled[sext->dis_idx])
> > > +                             return NULL;
> > > +                     return sbi_ext[i].ext_ptr;
> > > +             }
> > >       }
> > >
> > >       return NULL;
> > > @@ -126,7 +242,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > >       };
> > >       bool ext_is_v01 = false;
> > >
> > > -     sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> > > +     sbi_ext = kvm_vcpu_sbi_find_ext(vcpu, cp->a7);
> > >       if (sbi_ext && sbi_ext->handler) {
> > >  #ifdef CONFIG_RISCV_SBI_V01
> > >               if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
> > > diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> > > index 9945aff34c14..5bc570b984f4 100644
> > > --- a/arch/riscv/kvm/vcpu_sbi_base.c
> > > +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> > > @@ -44,7 +44,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > >                       kvm_riscv_vcpu_sbi_forward(vcpu, run);
> > >                       retdata->uexit = true;
> > >               } else {
> > > -                     sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> > > +                     sbi_ext = kvm_vcpu_sbi_find_ext(vcpu, cp->a0);
> > >                       *out_val = sbi_ext && sbi_ext->probe ?
> > >                                          sbi_ext->probe(vcpu) : !!sbi_ext;
> > >               }
> > > --
> > > 2.34.1
> > >
> >
> > This looks good, but I wonder if we shouldn't instead get/set a bitmap of
> > all SBI extension enables at once for scalability.
> 
> The SBI extensions (just like ISA extensions) are enabled by default
> so user-space only needs to disable selected ones which it does not
> want.

I guess it depends on the anticipated KVM version gap a guest may need to
migrate. For example, if a guest is running on an enterprise host with
a long major version release cadence, then it may need to jump several
years of KVM changes when its host is upgraded to the next major version.
All SBI extensions added since the old KVM version would need to be
disabled one by one each time its VCPUs are created on the new host.
Nothing would change if a bitmap was used.

> 
> Also, the problem with bitmap is that we can't fix the size of bitmap

That's true. While the set/get-reg interface is a good interface for
almost all VCPU configuration, arbitrary length arrays need their
own IOCTLs. Or, if the anticipated growth rate of the SBI-ext bitmap
is low, then selecting a register width of 128 may be sufficient. If a
day comes when we need 129, then another 128-bit virtual register can
be added.

> and we will have to define each XLEN bitmap word (along with
> the bits) separately.

I don't think we need to worry about that. Each SBI-ext gets a UAPI
number, and the per-XLEN word and bit numbers can be derived from
those numbers with a couple macros exported in UAPI along with them.

> 
> Instead (like you had suggested previously), we should rather add
> a generic IOCTL which allows user-space to create a VCPU based
> on some other VCPU as reference.

I need to prototype that idea, but I think choosing each feature's
interface can be independent of it, as even if we only need to
configure a single VCPU, we might as well make that as efficient
as possible too.

Thanks,
drew
