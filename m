Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D1C7CD4B1
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 08:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjJRGz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 02:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjJRGzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 02:55:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B47DC6
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 23:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697612077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ws44xpujh++UeLP3dJKBJiYZxBdnuJb4IuYVHtKx0u4=;
        b=MniksQDZ9Tvmbjoygy4Vkrxnd3RHg5z3Z2H1fDbFxuorYXz4yIFoxSKiRgMyrEjKLUFJOA
        nIPRhGbpW9G56kX8rXe28dDbJAntjP0k/aLd6PpyOe/CMl1U1E/WcIYzleENINVGpM2AHb
        0qig/Hh9sS95VaFwzNAeB45/zqJWUAs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-4795K1D7MuOOTJXtLA0-Kw-1; Wed, 18 Oct 2023 02:54:34 -0400
X-MC-Unique: 4795K1D7MuOOTJXtLA0-Kw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7740c3506b9so825303385a.0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 23:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697612073; x=1698216873;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ws44xpujh++UeLP3dJKBJiYZxBdnuJb4IuYVHtKx0u4=;
        b=THc9PVvc8ijh48387myXwtPci9h+MPKIj5fBS8/RWg/k3eNa4xJdKhHQBlUEOeZrLO
         45Q2zT7ZOU+bDBBO7C5UNvNctWUiawFfKIDiwEnMh0xlbPsvqsfPzh/ZQTge7cibja8X
         qf4r1KotXCm0yiLxregrjuKmIucwuMRPcMOT+L/PbDg3UP/hY7ajNgJxqsqnx2OZIeDw
         GEzBGcJASGY+tEw6glZdTixqYS/pJ1ib3o7DWX44SS04Zci/2UX5z6YAqrKKQXtQRKkQ
         8w5r+qVNcrmh0Xx/x5csN+Lbr6E3qzhZzc9utcU1M0jtijcT3wYySLXvrEZsl/pUSVFb
         jC1A==
X-Gm-Message-State: AOJu0Yxo6WDzqNlwP92aMkDFU8LFgNTUp3LOxCSdPqdg5fqsGgdy70ZT
        YiA8G1DzjLO/kKQJPa532qTbENcWXiAdK5X08fNlgvNTwxVRBqs6Q4uxj3OCQjppxX6ZjTp0TSw
        iu6ODya//zTfa
X-Received: by 2002:a05:620a:c4b:b0:778:8cce:dbf3 with SMTP id u11-20020a05620a0c4b00b007788ccedbf3mr3318527qki.46.1697612073476;
        Tue, 17 Oct 2023 23:54:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWMELTCfRDqIOtX7AHVLG36zAPI8rt7Pp0jV0lmTUM5Q7A1Fx4EeXlrDC/BJy60i8KUmcMkQ==
X-Received: by 2002:a05:620a:c4b:b0:778:8cce:dbf3 with SMTP id u11-20020a05620a0c4b00b007788ccedbf3mr3318513qki.46.1697612073174;
        Tue, 17 Oct 2023 23:54:33 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.100.204])
        by smtp.gmail.com with ESMTPSA id de26-20020a05620a371a00b007743446efd1sm1260215qkb.35.2023.10.17.23.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 23:54:32 -0700 (PDT)
Message-ID: <3e6e6c25-7b20-46b4-ffce-d34841aca209@redhat.com>
Date:   Wed, 18 Oct 2023 08:54:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 12/12] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-13-rananta@google.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-13-rananta@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Add a new test case to the vpmu_counter_access test to check
> if PMU registers or their bits for unimplemented counters are not
> accessible or are RAZ, as expected.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../kvm/aarch64/vpmu_counter_access.c         | 95 +++++++++++++++++--
>  .../selftests/kvm/include/aarch64/processor.h |  1 +
>  2 files changed, 87 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index e92af3c0db03..788386ac0894 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -5,8 +5,8 @@
>   * Copyright (c) 2022 Google LLC.
>   *
>   * This test checks if the guest can see the same number of the PMU event
> - * counters (PMCR_EL0.N) that userspace sets, and if the guest can access
> - * those counters.
> + * counters (PMCR_EL0.N) that userspace sets, if the guest can access
> + * those counters, and if the guest cannot access any other counters.
I would suggest: if the guest is prevented from accessing any other counters
>   * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
>   */
>  #include <kvm_util.h>
> @@ -131,9 +131,9 @@ static void write_pmevtypern(int n, unsigned long val)
>  }
>  
>  /*
> - * The pmc_accessor structure has pointers to PMEVT{CNTR,TYPER}<n>_EL0
> + * The pmc_accessor structure has pointers to PMEV{CNTR,TYPER}<n>_EL0
>   * accessors that test cases will use. Each of the accessors will
> - * either directly reads/writes PMEVT{CNTR,TYPER}<n>_EL0
> + * either directly reads/writes PMEV{CNTR,TYPER}<n>_EL0
I guess this should belong to the previous patch?
>   * (i.e. {read,write}_pmev{cnt,type}rn()), or reads/writes them through
>   * PMXEV{CNTR,TYPER}_EL0 (i.e. {read,write}_sel_ev{cnt,type}r()).
>   *
> @@ -291,25 +291,85 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
>  		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
>  }
>  
> +#define INVALID_EC	(-1ul)
> +uint64_t expected_ec = INVALID_EC;
> +uint64_t op_end_addr;
> +
>  static void guest_sync_handler(struct ex_regs *regs)
>  {
>  	uint64_t esr, ec;
>  
>  	esr = read_sysreg(esr_el1);
>  	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> -	__GUEST_ASSERT(0, "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx", regs->pc, esr, ec);
> +
> +	__GUEST_ASSERT(op_end_addr && (expected_ec == ec),
> +			"PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx; EC expected: 0x%lx",
> +			regs->pc, esr, ec, expected_ec);
> +
> +	/* Will go back to op_end_addr after the handler exits */
> +	regs->pc = op_end_addr;
> +
> +	/*
> +	 * Clear op_end_addr, and setting expected_ec to INVALID_EC
and set
> +	 * as a sign that an exception has occurred.
> +	 */
> +	op_end_addr = 0;
> +	expected_ec = INVALID_EC;
> +}
> +
> +/*
> + * Run the given operation that should trigger an exception with the
> + * given exception class. The exception handler (guest_sync_handler)
> + * will reset op_end_addr to 0, and expected_ec to INVALID_EC, and
> + * will come back to the instruction at the @done_label.
> + * The @done_label must be a unique label in this test program.
> + */
> +#define TEST_EXCEPTION(ec, ops, done_label)		\
> +{							\
> +	extern int done_label;				\
> +							\
> +	WRITE_ONCE(op_end_addr, (uint64_t)&done_label);	\
> +	GUEST_ASSERT(ec != INVALID_EC);			\
> +	WRITE_ONCE(expected_ec, ec);			\
> +	dsb(ish);					\
> +	ops;						\
> +	asm volatile(#done_label":");			\
> +	GUEST_ASSERT(!op_end_addr);			\
> +	GUEST_ASSERT(expected_ec == INVALID_EC);	\
> +}
> +
> +/*
> + * Tests for reading/writing registers for the unimplemented event counter
> + * specified by @pmc_idx (>= PMCR_EL0.N).
> + */
> +static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
> +{
> +	/*
> +	 * Reading/writing the event count/type registers should cause
> +	 * an UNDEFINED exception.
> +	 */
> +	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_cntr(pmc_idx), inv_rd_cntr);
> +	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0), inv_wr_cntr);
> +	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_typer(pmc_idx), inv_rd_typer);
> +	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_typer(pmc_idx, 0), inv_wr_typer);
> +	/*
> +	 * The bit corresponding to the (unimplemented) counter in
> +	 * {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers should be RAZ.
{PMCNTEN,PMINTEN,PMOVS}{SET,CLR}
> +	 */
> +	test_bitmap_pmu_regs(pmc_idx, 1);
> +	test_bitmap_pmu_regs(pmc_idx, 0);
>  }
>  
>  /*
>   * The guest is configured with PMUv3 with @expected_pmcr_n number of
>   * event counters.
>   * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
> - * if reading/writing PMU registers for implemented counters can work
> - * as expected.
> + * if reading/writing PMU registers for implemented or unimplemented
> + * counters can work as expected.
>   */
>  static void guest_code(uint64_t expected_pmcr_n)
>  {
> -	uint64_t pmcr, pmcr_n;
> +	uint64_t pmcr, pmcr_n, unimp_mask;
>  	int i, pmc;
>  
>  	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
> @@ -324,15 +384,32 @@ static void guest_code(uint64_t expected_pmcr_n)
>  			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
>  			pmcr_n, expected_pmcr_n);
>  
> +	/*
> +	 * Make sure that (RAZ) bits corresponding to unimplemented event
> +	 * counters in {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers are reset to zero.
> +	 * (NOTE: bits for implemented event counters are reset to UNKNOWN)
> +	 */
> +	unimp_mask = GENMASK_ULL(ARMV8_PMU_MAX_GENERAL_COUNTERS - 1, pmcr_n);
> +	check_bitmap_pmu_regs(unimp_mask, false);
wrt above comment, this also checks pmintenset|clr_el1.
> +
>  	/*
>  	 * Tests for reading/writing PMU registers for implemented counters.
> -	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
> +	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
>  	 */
>  	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
>  		for (pmc = 0; pmc < pmcr_n; pmc++)
>  			test_access_pmc_regs(&pmc_accessors[i], pmc);
>  	}
>  
> +	/*
> +	 * Tests for reading/writing PMU registers for unimplemented counters.
> +	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> +		for (pmc = pmcr_n; pmc < ARMV8_PMU_MAX_GENERAL_COUNTERS; pmc++)
> +			test_access_invalid_pmc_regs(&pmc_accessors[i], pmc);
> +	}
> +
>  	GUEST_DONE();
>  }
>  
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index cb537253a6b9..c42d683102c7 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -104,6 +104,7 @@ enum {
>  #define ESR_EC_SHIFT		26
>  #define ESR_EC_MASK		(ESR_EC_NUM - 1)
>  
> +#define ESR_EC_UNKNOWN		0x0
>  #define ESR_EC_SVC64		0x15
>  #define ESR_EC_IABT		0x21
>  #define ESR_EC_DABT		0x25

Thanks

Eric

