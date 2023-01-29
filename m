Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A3D67FF33
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 13:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbjA2MpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 07:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbjA2Mor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 07:44:47 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49801241F9
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:44:31 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gr7so231984ejb.5
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hzvl/LqOmRuw2DLDajc9nmwbZP+g/NBX1KDunvAJzQY=;
        b=fY2QFwBTKBZO8Qst6ZUPyMu24A/jtW4pov+KH93ZP6/BznpvqQcwmDLlU9AlvfKvHc
         kx1xqrQiAdRu1gI52+5qnmtBBw15VMdkOECUlNhT3f8RgCEjtRC2sD9hx92S0IRA7UZb
         dbuzIexlxY2xnBHPJSFzDxTOPcc6Woi6Hq1hant2sI9rU3oXS9qKpMHoAiAc/E8Rsm50
         jF9blpDcxyN56OCp0mwJpQw9r5/Yp6W4WSPMHNQ/X+0RAf+3DoSPj0DDL4EpygJtbeHj
         IH1nClRvnDmSkrauRgGR/vJ2W9/BRexsnmqgHAhLchQrqyGIyHcdyqbbXNqK9kcehZ/R
         UZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hzvl/LqOmRuw2DLDajc9nmwbZP+g/NBX1KDunvAJzQY=;
        b=dHY7GMo8gx3fGN5wLXlAwae0SIEfdbL9KyMHXbbVeJ8s26yT5ZgTpgOoyiGVXMdUmg
         myd0xChrgAh+6SaZKfsaVzg5AWtE0ozp2DCRO2JtyGpSAPSDDkgpOH2I+5/cqItJfh4A
         W1I1plv8vpTlkTKubzTRJs3Sj/vhxhssJRGbHYpt2ElYAQzBLVOgYkny5KMkFlD8/TCz
         l4iazf3nOH4tDGUFVzGPGxo4evnA8z1Y+Q3VEqIh7KOY2fRn0xBtec6NMgqApUa/LNTQ
         EO2aP1+83J3iP6X/8IwFZ4NEC59lBLGpJmSurhY0EbvH6oVLS+Wyz6JAG2ZL/B24Uj0x
         rJFg==
X-Gm-Message-State: AO0yUKUn+f1haGWIY/Do36uwkCjcOq+NZbmXwYwkuPp3+IcR1lO9DeZt
        TRYF1BenQiEm2d5D5a7oCOg3CQnBfAZrhdEmFWQnvg==
X-Google-Smtp-Source: AK7set+98zHjTjUCfz1Po+4TvGNEYBc/NoX6CxQ6nYhmE2sLz3ErpGLxfO2NEtvlVStSPaC/HwnxsOot12jRU9W6Y68=
X-Received: by 2002:a17:906:e116:b0:881:4488:297c with SMTP id
 gj22-20020a170906e11600b008814488297cmr1198000ejb.129.1674996269674; Sun, 29
 Jan 2023 04:44:29 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-12-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-12-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 29 Jan 2023 18:14:18 +0530
Message-ID: <CAAhSdy1+6AprOdzRRTG98p6swisNFO6MUKjXobxW3RWbixvjCg@mail.gmail.com>
Subject: Re: [PATCH v3 11/14] RISC-V: KVM: Implement trap & emulate for hpmcounters
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> As the KVM guests only see the virtual PMU counters, all hpmcounter
> access should trap and KVM emulates the read access on behalf of guests.
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h | 16 ++++++++++
>  arch/riscv/kvm/vcpu_insn.c            |  4 ++-
>  arch/riscv/kvm/vcpu_pmu.c             | 45 ++++++++++++++++++++++++++-
>  3 files changed, 63 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> index 3f43a43..022d45d 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -43,6 +43,19 @@ struct kvm_pmu {
>  #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
>  #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
>
> +#if defined(CONFIG_32BIT)
> +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> +{ .base = CSR_CYCLEH,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm }, \
> +{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
> +#else
> +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> +{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
> +#endif
> +
> +int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> +                               unsigned long *val, unsigned long new_val,
> +                               unsigned long wr_mask);
> +
>  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata);
>  int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
>                                 struct kvm_vcpu_sbi_ext_data *edata);
> @@ -65,6 +78,9 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
>  #else
>  struct kvm_pmu {
>  };
> +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> +{ .base = 0,      .count = 0, .func = NULL },
> +

Redundant newline here.

>
>  static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> index 0bb5276..f689337 100644
> --- a/arch/riscv/kvm/vcpu_insn.c
> +++ b/arch/riscv/kvm/vcpu_insn.c
> @@ -213,7 +213,9 @@ struct csr_func {
>                     unsigned long wr_mask);
>  };
>
> -static const struct csr_func csr_funcs[] = { };
> +static const struct csr_func csr_funcs[] = {
> +       KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS
> +};
>
>  /**
>   * kvm_riscv_vcpu_csr_return -- Handle CSR read/write after user space
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 7713927..894053a 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -17,6 +17,44 @@
>
>  #define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
>
> +static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                       unsigned long *out_val)
> +{
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       struct kvm_pmc *pmc;
> +       u64 enabled, running;
> +
> +       pmc = &kvpmu->pmc[cidx];
> +       if (!pmc->perf_event)
> +               return -EINVAL;
> +
> +       pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
> +       *out_val = pmc->counter_val;
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> +                               unsigned long *val, unsigned long new_val,
> +                               unsigned long wr_mask)
> +{
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       int cidx, ret = KVM_INSN_CONTINUE_NEXT_SEPC;
> +
> +       if (!kvpmu || !kvpmu->init_done)
> +               return KVM_INSN_EXIT_TO_USER_SPACE;

As discussed previously, this should be KVM_INSN_ILLEGAL_TRAP.

> +
> +       if (wr_mask)
> +               return KVM_INSN_ILLEGAL_TRAP;
> +
> +       cidx = csr_num - CSR_CYCLE;
> +
> +       if (pmu_ctr_read(vcpu, cidx, val) < 0)
> +               return KVM_INSN_EXIT_TO_USER_SPACE;

Same as above.

> +
> +       return ret;
> +}
> +
>  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata)
>  {
>         struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> @@ -69,7 +107,12 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>                                 struct kvm_vcpu_sbi_ext_data *edata)
>  {
> -       /* TODO */
> +       int ret;
> +
> +       ret = pmu_ctr_read(vcpu, cidx, &edata->out_val);
> +       if (ret == -EINVAL)
> +               edata->err_val = SBI_ERR_INVALID_PARAM;
> +
>         return 0;
>  }
>
> --
> 2.25.1
>

Regards,
Anup
