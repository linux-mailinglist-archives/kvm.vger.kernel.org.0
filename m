Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0093367F8CA
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 15:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjA1OpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 09:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjA1Oo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 09:44:56 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BD154209
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 06:44:52 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id kt14so20828640ejc.3
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 06:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cxgcNH+i6l64zcOgAcO50nbqnktfB8T2iDT3aKt9XNo=;
        b=oQ2dc3IhUAgPPTyUTM1XB5B3fQjGZ5A17Sm2jd1NpD4Tt+/wuDl5gazJt1pxTa8OMp
         eyucpzUntHS5jUjinFCl/FDnAk7eoHBJDP5hfVEHybDdihYRg7y7mzpgscjdr14zmZlG
         x4yZzM7DNvRX7bikgs3hF8gPbXwHykQoO0cxfXh26VFtx963vI0mhArDCQB855eAqNNV
         GoAxj1TOSbuAKbIQLeuFShcaSj3UklZ8jQXI8Ip9GKjaGoWKIL2MoRruQnvwIYTQT9Qh
         EumwqHrmvsscL+/pEyf0F5l+PBH6PYpDh6TMPd9MlvD06zzoqQp/1cFd6Y2gQCVEaRbY
         E7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cxgcNH+i6l64zcOgAcO50nbqnktfB8T2iDT3aKt9XNo=;
        b=39Z1uVmpQLg5rZTahQsu9//TU94WFwoPDIsCG+hdrn6uDIx8C0mTNJkD+kmOUFGHjZ
         uQJ09Qh2f70N2abzRC3+5qmw+JlDMr7bEuz/z4Saboo+Rncjyi/uwS3ms2KSUrYlsudO
         mfNOARkigtkjZmlGVlh7v/z3WsyaB3oEohdNi+uBJojK/IsgvdSu36hIyZybMLMgox8E
         3Z24EQDEAYu0HE7VP5wdhHaqA/+ygBm21ZtY9HjLskWxQgeRJbjgEdYdVx6HrUICEkKG
         ilgbXUtRuwfM+BO5FJ7JDm+yyplMoHtYB6nFGihxplrp+yZL9isgKSVBhmKEzsF/2cE6
         rb6g==
X-Gm-Message-State: AO0yUKUm8261JavYXGD5fOnRKjvSQomKQzBp+QoqP0VYFbXrRp/86A71
        RZYvd6PKtJ+c1m8FPornYOF5c6BXCqQdgnSnBtOl+A==
X-Google-Smtp-Source: AK7set8+4g33VhKHLNUQ/cQTpvdJvVcDfW5CesrwOD5jPXBburR4nRtEWk++r1qaqnYKZl5Mnorrb2FeRxmQhuCXneQ=
X-Received: by 2002:a17:906:840e:b0:884:8380:20db with SMTP id
 n14-20020a170906840e00b00884838020dbmr186235ejx.301.1674917090800; Sat, 28
 Jan 2023 06:44:50 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-2-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-2-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 28 Jan 2023 20:14:38 +0530
Message-ID: <CAAhSdy3U0sgZG6gT3i6vOaupmycHBwALmr_0DHVjuRR7U0Tr6w@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] perf: RISC-V: Define helper functions expose hpm
 counter width and count
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
> KVM module needs to know how many hardware counters and the counter
> width that the platform supports. Otherwise, it will not be able to show
> optimal value of virtual counters to the guest. The virtual hardware
> counters also need to have the same width as the logical hardware
> counters for simplicity. However, there shouldn't be mapping between
> virtual hardware counters and logical hardware counters. As we don't
> support hetergeneous harts or counters with different width as of now,
> the implementation relies on the counter width of the first available
> programmable counter.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  drivers/perf/riscv_pmu_sbi.c   | 37 ++++++++++++++++++++++++++++++++--
>  include/linux/perf/riscv_pmu.h |  3 +++
>  2 files changed, 38 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index f6507ef..6b53adc 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -44,7 +44,7 @@ static const struct attribute_group *riscv_pmu_attr_groups[] = {
>  };
>
>  /*
> - * RISC-V doesn't have hetergenous harts yet. This need to be part of
> + * RISC-V doesn't have heterogeneous harts yet. This need to be part of
>   * per_cpu in case of harts with different pmu counters
>   */
>  static union sbi_pmu_ctr_info *pmu_ctr_list;
> @@ -52,6 +52,9 @@ static bool riscv_pmu_use_irq;
>  static unsigned int riscv_pmu_irq_num;
>  static unsigned int riscv_pmu_irq;
>
> +/* Cache the available counters in a bitmask */
> +static unsigned long cmask;
> +
>  struct sbi_pmu_event_data {
>         union {
>                 union {
> @@ -267,6 +270,37 @@ static bool pmu_sbi_ctr_is_fw(int cidx)
>         return (info->type == SBI_PMU_CTR_TYPE_FW) ? true : false;
>  }
>
> +/*
> + * Returns the counter width of a programmable counter and number of hardware
> + * counters. As we don't support heterogeneous CPUs yet, it is okay to just
> + * return the counter width of the first programmable counter.
> + */
> +int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr)
> +{
> +       int i;
> +       union sbi_pmu_ctr_info *info;
> +       u32 hpm_width = 0, hpm_count = 0;
> +
> +       if (!cmask)
> +               return -EINVAL;
> +
> +       for_each_set_bit(i, &cmask, RISCV_MAX_COUNTERS) {
> +               info = &pmu_ctr_list[i];
> +               if (!info)
> +                       continue;
> +               if (!hpm_width && info->csr != CSR_CYCLE && info->csr != CSR_INSTRET)
> +                       hpm_width = info->width;
> +               if (info->type == SBI_PMU_CTR_TYPE_HW)
> +                       hpm_count++;
> +       }
> +
> +       *hw_ctr_width = hpm_width;
> +       *num_hw_ctr = hpm_count;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(riscv_pmu_get_hpm_info);
> +
>  static int pmu_sbi_ctr_get_idx(struct perf_event *event)
>  {
>         struct hw_perf_event *hwc = &event->hw;
> @@ -812,7 +846,6 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
>  static int pmu_sbi_device_probe(struct platform_device *pdev)
>  {
>         struct riscv_pmu *pmu = NULL;
> -       unsigned long cmask = 0;
>         int ret = -ENODEV;
>         int num_counters;
>
> diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
> index e17e86a..a1c3f77 100644
> --- a/include/linux/perf/riscv_pmu.h
> +++ b/include/linux/perf/riscv_pmu.h
> @@ -73,6 +73,9 @@ void riscv_pmu_legacy_skip_init(void);
>  static inline void riscv_pmu_legacy_skip_init(void) {};
>  #endif
>  struct riscv_pmu *riscv_pmu_alloc(void);
> +#ifdef CONFIG_RISCV_PMU_SBI
> +int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr);
> +#endif
>
>  #endif /* CONFIG_RISCV_PMU */
>
> --
> 2.25.1
>
