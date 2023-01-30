Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABB7681547
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 16:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbjA3Pkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 10:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbjA3Pko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 10:40:44 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2103EFF2
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 07:40:39 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id me3so32888946ejb.7
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 07:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2uWNLeObEWhqX0EPqUst6Jx9xzhPty1njI9796x8WDA=;
        b=TFpuuk2lRENvuGyVkV4C+pR+ZBAUyoE6ml4pI8VkIKfF3aFRajMCH+UIJHWmlG8rP4
         WhWW3OIkbae5RvmK3plsMaclmr6aPcWZSBz1aa3QMmTP56ky2P3D87amS2pwcp7iWpOB
         cKMaSAtEqlYQXdN+o3xPP1F828yq9/de5HWi8HH6C4lVwvsfbzTXB6bk/K+JesneoOyO
         9Lu4A2lyvDRhtR9A/O0eC8wRya79NBAcKJMCgWyBic7DkCuZTVL7b1LE0TSOHSwe4lTr
         za2381vs/bKixzBKMw9tdr0n2liobpb0l38ULCgshxYH66lW7P5oC+jPC1I9tbJ8fWtO
         hzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2uWNLeObEWhqX0EPqUst6Jx9xzhPty1njI9796x8WDA=;
        b=xWbeKSC7cz2Ewqcx1WG/OLl39s6vwzqmzRzwf9HnOpY4JCGP4eQXweYOgm8NV0qMFz
         MtHAGEySDFLEoUKebe2SCRHS2/5tIpIKaTytLWz5vzN+wODRHyhJhEDBzPqzJq0kIKRr
         PHywuTATJqXkzMtoDNyybrYdJP6urvtx47lWQQe2jE9OfQfSPbKB0Z3rqZIVgKCJLU2X
         B16VCusAOpPDjAqRZoGV3JPFdqMnCTYywfAP4kwP69uEcPmz09kP59ypVJ+ewCHecciE
         0+SvQAJhuDEiL3cSrhS1caFIb3V8E/pwY+rG0oW1YbySivfySf7zDagPS6uPRCc2aNLJ
         xrow==
X-Gm-Message-State: AO0yUKUfjq+DY0ERWCr0ePQWymFAa1oQa3uo1lBHOD4/spBRQm3/uXbW
        CDRp3AEHwlH+yrJqmF0oFv1qS4b/HjbeT0XXmsCEXQ==
X-Google-Smtp-Source: AK7set/ioqJJWiyNE0di1prWUTf2OPRGOEGWOiAFclFtb2jHhhviT5CyCcX7eSoRcNNAKLjDwzqmJ3M83ZnQKy85vGI=
X-Received: by 2002:a17:906:c20d:b0:87d:d218:3923 with SMTP id
 d13-20020a170906c20d00b0087dd2183923mr2934115ejz.117.1675093237422; Mon, 30
 Jan 2023 07:40:37 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-13-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-13-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 30 Jan 2023 21:10:24 +0530
Message-ID: <CAAhSdy2Q5tXkDfzzDNXP178EZJtjkEZ-9ivNvbX_RSQVtpc-xg@mail.gmail.com>
Subject: Re: [PATCH v3 12/14] RISC-V: KVM: Implement perf support without sampling
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
> RISC-V SBI PMU & Sscofpmf ISA extension allows supporting perf in
> the virtualization enviornment as well. KVM implementation
> relies on SBI PMU extension for the most part while trapping
> & emulating the CSRs read for counter access.
>
> This patch doesn't have the event sampling support yet.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_pmu.c | 366 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 360 insertions(+), 6 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 894053a..73dccf7 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -12,10 +12,190 @@
>  #include <linux/perf/riscv_pmu.h>
>  #include <asm/csr.h>
>  #include <asm/kvm_vcpu_sbi.h>
> +#include <asm/bitops.h>
>  #include <asm/kvm_vcpu_pmu.h>
>  #include <linux/kvm_host.h>
>
>  #define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> +#define get_event_type(x) (((x) & SBI_PMU_EVENT_IDX_TYPE_MASK) >> 16)
> +#define get_event_code(x) ((x) & SBI_PMU_EVENT_IDX_CODE_MASK)
> +
> +

Redundant newline.

> +static enum perf_hw_id hw_event_perf_map[SBI_PMU_HW_GENERAL_MAX] = {
> +       [SBI_PMU_HW_CPU_CYCLES] = PERF_COUNT_HW_CPU_CYCLES,
> +       [SBI_PMU_HW_INSTRUCTIONS] = PERF_COUNT_HW_INSTRUCTIONS,
> +       [SBI_PMU_HW_CACHE_REFERENCES] = PERF_COUNT_HW_CACHE_REFERENCES,
> +       [SBI_PMU_HW_CACHE_MISSES] = PERF_COUNT_HW_CACHE_MISSES,
> +       [SBI_PMU_HW_BRANCH_INSTRUCTIONS] = PERF_COUNT_HW_BRANCH_INSTRUCTIONS,
> +       [SBI_PMU_HW_BRANCH_MISSES] = PERF_COUNT_HW_BRANCH_MISSES,
> +       [SBI_PMU_HW_BUS_CYCLES] = PERF_COUNT_HW_BUS_CYCLES,
> +       [SBI_PMU_HW_STALLED_CYCLES_FRONTEND] = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND,
> +       [SBI_PMU_HW_STALLED_CYCLES_BACKEND] = PERF_COUNT_HW_STALLED_CYCLES_BACKEND,
> +       [SBI_PMU_HW_REF_CPU_CYCLES] = PERF_COUNT_HW_REF_CPU_CYCLES,
> +};
> +
> +static u64 kvm_pmu_get_sample_period(struct kvm_pmc *pmc)
> +{
> +       u64 counter_val_mask = GENMASK(pmc->cinfo.width, 0);
> +       u64 sample_period;
> +
> +       if (!pmc->counter_val)
> +               sample_period = counter_val_mask + 1;
> +       else
> +               sample_period = (-pmc->counter_val) & counter_val_mask;
> +
> +       return sample_period;
> +}
> +
> +static u32 kvm_pmu_get_perf_event_type(unsigned long eidx)
> +{
> +       enum sbi_pmu_event_type etype = get_event_type(eidx);
> +       u32 type = PERF_TYPE_MAX;
> +
> +       switch (etype) {
> +       case SBI_PMU_EVENT_TYPE_HW:
> +               type = PERF_TYPE_HARDWARE;
> +               break;
> +       case SBI_PMU_EVENT_TYPE_CACHE:
> +               type = PERF_TYPE_HW_CACHE;
> +               break;
> +       case SBI_PMU_EVENT_TYPE_RAW:
> +       case SBI_PMU_EVENT_TYPE_FW:
> +               type = PERF_TYPE_RAW;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return type;
> +}
> +
> +static bool kvm_pmu_is_fw_event(unsigned long eidx)
> +{
> +       return get_event_type(eidx) == SBI_PMU_EVENT_TYPE_FW;
> +}
> +
> +static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
> +{
> +       if (pmc->perf_event) {
> +               perf_event_disable(pmc->perf_event);
> +               perf_event_release_kernel(pmc->perf_event);
> +               pmc->perf_event = NULL;
> +       }
> +}
> +
> +static u64 kvm_pmu_get_perf_event_hw_config(u32 sbi_event_code)
> +{
> +       return hw_event_perf_map[sbi_event_code];
> +}
> +
> +static u64 kvm_pmu_get_perf_event_cache_config(u32 sbi_event_code)
> +{
> +       u64 config = U64_MAX;
> +       unsigned int cache_type, cache_op, cache_result;
> +
> +       /* All the cache event masks lie within 0xFF. No separate masking is necesssary */

s/necesssary/necessary/

> +       cache_type = (sbi_event_code & SBI_PMU_EVENT_CACHE_ID_CODE_MASK) >>
> +                     SBI_PMU_EVENT_CACHE_ID_SHIFT;
> +       cache_op = (sbi_event_code & SBI_PMU_EVENT_CACHE_OP_ID_CODE_MASK) >>
> +                   SBI_PMU_EVENT_CACHE_OP_SHIFT;
> +       cache_result = sbi_event_code & SBI_PMU_EVENT_CACHE_RESULT_ID_CODE_MASK;
> +
> +       if (cache_type >= PERF_COUNT_HW_CACHE_MAX ||
> +           cache_op >= PERF_COUNT_HW_CACHE_OP_MAX ||
> +           cache_result >= PERF_COUNT_HW_CACHE_RESULT_MAX)
> +               return config;
> +
> +       config = cache_type | (cache_op << 8) | (cache_result << 16);
> +
> +       return config;
> +}
> +
> +static u64 kvm_pmu_get_perf_event_config(unsigned long eidx, uint64_t evt_data)
> +{
> +       enum sbi_pmu_event_type etype = get_event_type(eidx);
> +       u32 ecode = get_event_code(eidx);
> +       u64 config = U64_MAX;
> +
> +       switch (etype) {
> +       case SBI_PMU_EVENT_TYPE_HW:
> +               if (ecode < SBI_PMU_HW_GENERAL_MAX)
> +                       config = kvm_pmu_get_perf_event_hw_config(ecode);
> +               break;
> +       case SBI_PMU_EVENT_TYPE_CACHE:
> +               config = kvm_pmu_get_perf_event_cache_config(ecode);
> +               break;
> +       case SBI_PMU_EVENT_TYPE_RAW:
> +               config = evt_data & RISCV_PMU_RAW_EVENT_MASK;
> +               break;
> +       case SBI_PMU_EVENT_TYPE_FW:
> +               if (ecode < SBI_PMU_FW_MAX)
> +                       config = (1ULL << 63) | ecode;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return config;
> +}
> +
> +static int kvm_pmu_get_fixed_pmc_index(unsigned long eidx)
> +{
> +       u32 etype = kvm_pmu_get_perf_event_type(eidx);
> +       u32 ecode = get_event_code(eidx);
> +
> +       if (etype != SBI_PMU_EVENT_TYPE_HW)
> +               return -EINVAL;
> +
> +       if (ecode == SBI_PMU_HW_CPU_CYCLES)
> +               return 0;
> +       else if (ecode == SBI_PMU_HW_INSTRUCTIONS)
> +               return 2;
> +       else
> +               return -EINVAL;
> +}
> +
> +static int kvm_pmu_get_programmable_pmc_index(struct kvm_pmu *kvpmu, unsigned long eidx,
> +                                         unsigned long cbase, unsigned long cmask)
> +{
> +       int ctr_idx = -1;
> +       int i, pmc_idx;
> +       int min, max;
> +
> +       if (kvm_pmu_is_fw_event(eidx)) {
> +               /* Firmware counters are mapped 1:1 starting from num_hw_ctrs for simplicity */
> +               min = kvpmu->num_hw_ctrs;
> +               max = min + kvpmu->num_fw_ctrs;
> +       } else {
> +               /* First 3 counters are reserved for fixed counters */
> +               min = 3;
> +               max = kvpmu->num_hw_ctrs;
> +       }
> +
> +       for_each_set_bit(i, &cmask, BITS_PER_LONG) {
> +               pmc_idx = i + cbase;
> +               if ((pmc_idx >= min && pmc_idx < max) &&
> +                   !test_bit(pmc_idx, kvpmu->pmc_in_use)) {
> +                       ctr_idx = pmc_idx;
> +                       break;
> +               }
> +       }
> +
> +       return ctr_idx;
> +}
> +
> +static int pmu_get_pmc_index(struct kvm_pmu *pmu, unsigned long eidx,
> +                            unsigned long cbase, unsigned long cmask)
> +{
> +       int ret;
> +
> +       /* Fixed counters need to be have fixed mapping as they have different width */
> +       ret = kvm_pmu_get_fixed_pmc_index(eidx);
> +       if (ret >= 0)
> +               return ret;
> +
> +       return kvm_pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask);
> +}
>
>  static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>                         unsigned long *out_val)
> @@ -34,6 +214,16 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>         return 0;
>  }
>
> +static int kvm_pmu_validate_counter_mask(struct kvm_pmu *kvpmu, unsigned long ctr_base,
> +                                        unsigned long ctr_mask)
> +{
> +       /* Make sure the we have a valid counter mask requested from the caller */
> +       if (!ctr_mask || (ctr_base + __fls(ctr_mask) >= kvm_pmu_num_counters(kvpmu)))
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
>  int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
>                                 unsigned long *val, unsigned long new_val,
>                                 unsigned long wr_mask)
> @@ -83,7 +273,39 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>                                  unsigned long ctr_mask, unsigned long flag, uint64_t ival,
>                                  struct kvm_vcpu_sbi_ext_data *edata)
>  {
> -       /* TODO */
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       int i, pmc_index, sbiret = 0;
> +       struct kvm_pmc *pmc;
> +
> +       if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
> +               sbiret = SBI_ERR_INVALID_PARAM;
> +               goto out;
> +       }
> +
> +       /* Start the counters that have been configured and requested by the guest */
> +       for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
> +               pmc_index = i + ctr_base;
> +               if (!test_bit(pmc_index, kvpmu->pmc_in_use))
> +                       continue;
> +               pmc = &kvpmu->pmc[pmc_index];
> +               if (flag & SBI_PMU_START_FLAG_SET_INIT_VALUE)
> +                       pmc->counter_val = ival;
> +               if (pmc->perf_event) {
> +                       if (unlikely(pmc->started)) {
> +                               sbiret = SBI_ERR_ALREADY_STARTED;
> +                               continue;
> +                       }
> +                       perf_event_period(pmc->perf_event, kvm_pmu_get_sample_period(pmc));
> +                       perf_event_enable(pmc->perf_event);
> +                       pmc->started = true;
> +               } else {
> +                       sbiret = SBI_ERR_INVALID_PARAM;
> +               }
> +       }
> +
> +out:
> +       edata->err_val = sbiret;
> +
>         return 0;
>  }
>
> @@ -91,7 +313,45 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>                                 unsigned long ctr_mask, unsigned long flag,
>                                 struct kvm_vcpu_sbi_ext_data *edata)
>  {
> -       /* TODO */
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       int i, pmc_index, sbiret = 0;
> +       u64 enabled, running;
> +       struct kvm_pmc *pmc;
> +
> +       if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
> +               sbiret = SBI_ERR_INVALID_PARAM;
> +               goto out;
> +       }
> +
> +       /* Stop the counters that have been configured and requested by the guest */
> +       for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
> +               pmc_index = i + ctr_base;
> +               if (!test_bit(pmc_index, kvpmu->pmc_in_use))
> +                       continue;
> +               pmc = &kvpmu->pmc[pmc_index];
> +               if (pmc->perf_event) {
> +                       if (pmc->started) {
> +                               /* Stop counting the counter */
> +                               perf_event_disable(pmc->perf_event);
> +                               pmc->started = false;
> +                       } else
> +                               sbiret = SBI_ERR_ALREADY_STOPPED;
> +
> +                       if (flag & SBI_PMU_STOP_FLAG_RESET) {
> +                               /* Relase the counter if this is a reset request */
> +                               pmc->counter_val += perf_event_read_value(pmc->perf_event,
> +                                                                         &enabled, &running);
> +                               kvm_pmu_release_perf_event(pmc);
> +                               clear_bit(pmc_index, kvpmu->pmc_in_use);
> +                       }
> +               } else {
> +                       sbiret = SBI_ERR_INVALID_PARAM;
> +               }
> +       }
> +
> +out:
> +       edata->err_val = sbiret;
> +
>         return 0;
>  }
>
> @@ -100,7 +360,89 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>                                      unsigned long eidx, uint64_t evtdata,
>                                      struct kvm_vcpu_sbi_ext_data *edata)
>  {
> -       /* TODO */
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       struct perf_event *event;
> +       int ctr_idx;
> +       u32 etype = kvm_pmu_get_perf_event_type(eidx);
> +       u64 config;
> +       struct kvm_pmc *pmc;
> +       int sbiret = 0;

Organize this local variables in better way.

> +       struct perf_event_attr attr = {
> +               .type = etype,
> +               .size = sizeof(struct perf_event_attr),
> +               .pinned = true,
> +               /*
> +                * It should never reach here if the platform doesn't support the sscofpmf
> +                * extension as mode filtering won't work without it.
> +                */
> +               .exclude_host = true,
> +               .exclude_hv = true,
> +               .exclude_user = !!(flag & SBI_PMU_CFG_FLAG_SET_UINH),
> +               .exclude_kernel = !!(flag & SBI_PMU_CFG_FLAG_SET_SINH),
> +               .config1 = RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS,
> +       };
> +
> +       if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
> +               sbiret = SBI_ERR_INVALID_PARAM;
> +               goto out;
> +       }
> +
> +       if (kvm_pmu_is_fw_event(eidx)) {
> +               sbiret = SBI_ERR_NOT_SUPPORTED;
> +               goto out;
> +       }
> +
> +       /*
> +        * SKIP_MATCH flag indicates the caller is aware of the assigned counter
> +        * for this event. Just do a sanity check if it already marked used.
> +        */
> +       if (flag & SBI_PMU_CFG_FLAG_SKIP_MATCH) {
> +               if (!test_bit(ctr_base + __ffs(ctr_mask), kvpmu->pmc_in_use)) {
> +                       sbiret = SBI_ERR_FAILURE;
> +                       goto out;
> +               }
> +               ctr_idx = ctr_base + __ffs(ctr_mask);
> +       } else  {
> +
> +               ctr_idx = pmu_get_pmc_index(kvpmu, eidx, ctr_base, ctr_mask);
> +               if (ctr_idx < 0) {
> +                       sbiret = SBI_ERR_NOT_SUPPORTED;
> +                       goto out;
> +               }
> +       }
> +
> +       pmc = &kvpmu->pmc[ctr_idx];
> +       kvm_pmu_release_perf_event(pmc);
> +       pmc->idx = ctr_idx;
> +
> +       config = kvm_pmu_get_perf_event_config(eidx, evtdata);
> +       attr.config = config;
> +       if (flag & SBI_PMU_CFG_FLAG_CLEAR_VALUE) {
> +               //TODO: Do we really want to clear the value in hardware counter
> +               pmc->counter_val = 0;
> +       }
> +
> +       /*
> +        * Set the default sample_period for now. The guest specified value
> +        * will be updated in the start call.
> +        */
> +       attr.sample_period = kvm_pmu_get_sample_period(pmc);
> +
> +       event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
> +       if (IS_ERR(event)) {
> +               pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
> +               return PTR_ERR(event);
> +       }
> +
> +       set_bit(ctr_idx, kvpmu->pmc_in_use);
> +       pmc->perf_event = event;
> +       if (flag & SBI_PMU_CFG_FLAG_AUTO_START)
> +               perf_event_enable(pmc->perf_event);
> +
> +       edata->out_val = ctr_idx;
> +out:
> +       edata->err_val = sbiret;
> +
>         return 0;
>  }
>
> @@ -164,9 +506,9 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>                         kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_HW;
>                         if (i < 3)
>                                 /* CY, IR counters */
> -                               kvpmu->pmc[i].cinfo.width = 63;
> +                               pmc->cinfo.width = 63;
>                         else
> -                               kvpmu->pmc[i].cinfo.width = hpm_width;
> +                               pmc->cinfo.width = hpm_width;
>                         /*
>                          * The CSR number doesn't have any relation with the logical
>                          * hardware counters. The CSR numbers are encoded sequentially
> @@ -187,7 +529,19 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>
>  void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
>  {
> -       /* TODO */
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       struct kvm_pmc *pmc;
> +       int i;
> +
> +       if (!kvpmu)
> +               return;
> +
> +       for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_MAX_COUNTERS) {
> +               pmc = &kvpmu->pmc[i];
> +               pmc->counter_val = 0;
> +               kvm_pmu_release_perf_event(pmc);
> +       }
> +       bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
>  }
>
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> --
> 2.25.1
>

Apart from minor nits, it looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup
