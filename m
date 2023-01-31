Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC1D68398B
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 23:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjAaWrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 17:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjAaWrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 17:47:22 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D414E537
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 14:46:52 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b5so9381682plz.5
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 14:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ChdY/BOQPZ1uBdSScQAnHVJgIw1TfyjijiWytBSiQJU=;
        b=P/csI0Dsr6pSP+yfsdWmPLyR2OV2O9L2+BIw5ZYpmKa46y6S8PELKWe4xTX4sx2mEN
         iz0CIV4aU/Xp55F7vPWK75l8XALnKMEi/qkTo8b0lRlStd85P958+Ao3ZedelC7yXENR
         ORsQfgbiccitrYTxaXdve26+HM4rKn+N02qzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ChdY/BOQPZ1uBdSScQAnHVJgIw1TfyjijiWytBSiQJU=;
        b=gLssl8wAz4g9RM9xxfzO/XbV2Zi/pqkKfSpFvmjEIvwVvjE3YiGybYaIq2ypHQsDFS
         7TDo/w/KQtVWmGNBD9RVpWiaDV0UxSHcoQ/U12/3ixGmJS4/vI6w2YxjOGKSRQ3DW2MI
         4GERfRXGO0tADIQhcrksSW5zp1regtlHNd0YPKpR74EFP9XKrKm9cUFEyodp+5+cJ2ss
         RSXcXUKaI7PGXUnYybuf2XzC2G6pFf+fehRgDUhqEh80rgfVlNLbZ2Xj8V9/qUcb+xZu
         4pIPJjUvgFUeIM9fa3EDtBJX0TzA404suiQoPCdmy1/m8YtMo3qONQcq96xENiC+Fz8/
         PWXA==
X-Gm-Message-State: AO0yUKV0yTZndHJ3v1PYwWdtVbZprfrbOFEv6xToh/ZpOGd0aKSr3XnR
        3Xnw2sa2gbCFWUw48fZeZb2hAI8pDEBFutMJgmRV
X-Google-Smtp-Source: AK7set8AS0MpCMygHXWVJkHhzF3cP+gjObUvIrlXz6+xUJd4hSDWhV5uI7961IASYnnUHYVzNYuuX139DCNVJlEBhXE=
X-Received: by 2002:a17:90a:2dc9:b0:22c:dd5:8f54 with SMTP id
 q9-20020a17090a2dc900b0022c0dd58f54mr4059996pjm.62.1675205208315; Tue, 31 Jan
 2023 14:46:48 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-12-atishp@rivosinc.com>
 <CAAhSdy1+6AprOdzRRTG98p6swisNFO6MUKjXobxW3RWbixvjCg@mail.gmail.com>
In-Reply-To: <CAAhSdy1+6AprOdzRRTG98p6swisNFO6MUKjXobxW3RWbixvjCg@mail.gmail.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 31 Jan 2023 14:46:36 -0800
Message-ID: <CAOnJCU+=A1GXvaQis5RrDabPAvAZccmc9HF1KU4ReuRTSx5pCQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/14] RISC-V: KVM: Implement trap & emulate for hpmcounters
To:     Anup Patel <anup@brainfault.org>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 29, 2023 at 4:44 AM Anup Patel <anup@brainfault.org> wrote:
>
> On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
> >
> > As the KVM guests only see the virtual PMU counters, all hpmcounter
> > access should trap and KVM emulates the read access on behalf of guests.
> >
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_pmu.h | 16 ++++++++++
> >  arch/riscv/kvm/vcpu_insn.c            |  4 ++-
> >  arch/riscv/kvm/vcpu_pmu.c             | 45 ++++++++++++++++++++++++++-
> >  3 files changed, 63 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > index 3f43a43..022d45d 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > @@ -43,6 +43,19 @@ struct kvm_pmu {
> >  #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
> >  #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
> >
> > +#if defined(CONFIG_32BIT)
> > +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> > +{ .base = CSR_CYCLEH,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm }, \
> > +{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
> > +#else
> > +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> > +{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
> > +#endif
> > +
> > +int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> > +                               unsigned long *val, unsigned long new_val,
> > +                               unsigned long wr_mask);
> > +
> >  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata);
> >  int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> >                                 struct kvm_vcpu_sbi_ext_data *edata);
> > @@ -65,6 +78,9 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> >  #else
> >  struct kvm_pmu {
> >  };
> > +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> > +{ .base = 0,      .count = 0, .func = NULL },
> > +
>
> Redundant newline here.
>

Fixed.

> >
> >  static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> >  {
> > diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> > index 0bb5276..f689337 100644
> > --- a/arch/riscv/kvm/vcpu_insn.c
> > +++ b/arch/riscv/kvm/vcpu_insn.c
> > @@ -213,7 +213,9 @@ struct csr_func {
> >                     unsigned long wr_mask);
> >  };
> >
> > -static const struct csr_func csr_funcs[] = { };
> > +static const struct csr_func csr_funcs[] = {
> > +       KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS
> > +};
> >
> >  /**
> >   * kvm_riscv_vcpu_csr_return -- Handle CSR read/write after user space
> > diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> > index 7713927..894053a 100644
> > --- a/arch/riscv/kvm/vcpu_pmu.c
> > +++ b/arch/riscv/kvm/vcpu_pmu.c
> > @@ -17,6 +17,44 @@
> >
> >  #define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> >
> > +static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> > +                       unsigned long *out_val)
> > +{
> > +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +       struct kvm_pmc *pmc;
> > +       u64 enabled, running;
> > +
> > +       pmc = &kvpmu->pmc[cidx];
> > +       if (!pmc->perf_event)
> > +               return -EINVAL;
> > +
> > +       pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
> > +       *out_val = pmc->counter_val;
> > +
> > +       return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> > +                               unsigned long *val, unsigned long new_val,
> > +                               unsigned long wr_mask)
> > +{
> > +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +       int cidx, ret = KVM_INSN_CONTINUE_NEXT_SEPC;
> > +
> > +       if (!kvpmu || !kvpmu->init_done)
> > +               return KVM_INSN_EXIT_TO_USER_SPACE;
>
> As discussed previously, this should be KVM_INSN_ILLEGAL_TRAP.
>

Done.
> > +
> > +       if (wr_mask)
> > +               return KVM_INSN_ILLEGAL_TRAP;
> > +
> > +       cidx = csr_num - CSR_CYCLE;
> > +
> > +       if (pmu_ctr_read(vcpu, cidx, val) < 0)
> > +               return KVM_INSN_EXIT_TO_USER_SPACE;
>
> Same as above.
>

Done.

> > +
> > +       return ret;
> > +}
> > +
> >  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata)
> >  {
> >         struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > @@ -69,7 +107,12 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
> >  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> >                                 struct kvm_vcpu_sbi_ext_data *edata)
> >  {
> > -       /* TODO */
> > +       int ret;
> > +
> > +       ret = pmu_ctr_read(vcpu, cidx, &edata->out_val);
> > +       if (ret == -EINVAL)
> > +               edata->err_val = SBI_ERR_INVALID_PARAM;
> > +
> >         return 0;
> >  }
> >
> > --
> > 2.25.1
> >
>
> Regards,
> Anup



-- 
Regards,
Atish
