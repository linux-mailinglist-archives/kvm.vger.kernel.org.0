Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2977CCB55
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344153AbjJQSzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344122AbjJQSzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E2990
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 11:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697568863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJVkq0zNvcclouon75ab/8AAB1pbNZXcLIT/5DGOsag=;
        b=UHzvkBCWYvwGhuUc8QvKF9Cp4Fm159weM4Qc0a5Yyf29BgT/R0IHOe2q7qaYMwGcyYoJGS
        sj3+yn1X9X/uIfSAMotJcThmNn0GNbfDNCVfUtsowYFYVIRvJRA0uBioOYYyVAR/aGd8zY
        rLwFraLOZvM1BMsPwholIbYThnneCis=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-hvLtajDfM366nzF3rGZ24Q-1; Tue, 17 Oct 2023 14:54:20 -0400
X-MC-Unique: hvLtajDfM366nzF3rGZ24Q-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5a88f9a1cf7so30277117b3.3
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 11:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697568859; x=1698173659;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MJVkq0zNvcclouon75ab/8AAB1pbNZXcLIT/5DGOsag=;
        b=SL6covAZIvYg0yWcp2xJyDJi/LhiajW2Y9fyIKiJESYmEZDuZVkR0BSTQedc7fTtvv
         WqmsA5m//B2E8nJ8tke021vf4BLYeIy8qjpS+L1Q6easIj0rpw3cC5ZgxeTWeOF5ipVC
         roCRLMyCXScXEn8ad9MW3K9rNb4aR9uEzTMITSTGLphiwnw6Ehc+caY/frT91LaPTH7l
         IB5UhqyV29+Iv1RBB/ij8YlaqMHH050NHim+DmvQM99lMHZBn0EtBejuNUyzzyar0JXZ
         diUJJI4iDfdQjq4JCvwgeI58pXTye3QpyXOWpOmWRFpbWFO8fz503d5Gj7OUZ5V6VS4w
         HErg==
X-Gm-Message-State: AOJu0YzL1jcLNPb5mB61tBHG5QB4vwCiy+klIsl0kouy9l1xRMLWuX1k
        FKzkcOHCXI0NS00m56in6hCjvbgM0BYB+sttBkPZmkXCQoo/coPazqL5TX9lbJotSj0o0vLTko1
        Fa9MEkh8iadS/
X-Received: by 2002:a81:83ce:0:b0:5a7:c641:4fd2 with SMTP id t197-20020a8183ce000000b005a7c6414fd2mr3212638ywf.10.1697568859054;
        Tue, 17 Oct 2023 11:54:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNaO+BRo9SvV0Dxy/Mj2SdGWzz2a2vRYlvQwsHWXx/xJ95iYRzRrqR8KlRPGhWgvUaGDsfdg==
X-Received: by 2002:a81:83ce:0:b0:5a7:c641:4fd2 with SMTP id t197-20020a8183ce000000b005a7c6414fd2mr3212609ywf.10.1697568858677;
        Tue, 17 Oct 2023 11:54:18 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.237.139])
        by smtp.gmail.com with ESMTPSA id t1-20020a0cea21000000b00655e2005350sm771105qvp.9.2023.10.17.11.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 11:54:17 -0700 (PDT)
Message-ID: <6a83ce25-7e45-5b71-86e4-58e905e490ea@redhat.com>
Date:   Tue, 17 Oct 2023 20:54:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 11/12] KVM: selftests: aarch64: vPMU register test for
 implemented counters
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
 <20231009230858.3444834-12-rananta@google.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-12-rananta@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Add a new test case to the vpmu_counter_access test to check if PMU
> registers or their bits for implemented counters on the vCPU are
> readable/writable as expected, and can be programmed to count events.>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../kvm/aarch64/vpmu_counter_access.c         | 270 +++++++++++++++++-
>  1 file changed, 268 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index 58949b17d76e..e92af3c0db03 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -5,7 +5,8 @@
>   * Copyright (c) 2022 Google LLC.
>   *
>   * This test checks if the guest can see the same number of the PMU event
> - * counters (PMCR_EL0.N) that userspace sets.
> + * counters (PMCR_EL0.N) that userspace sets, and if the guest can access
> + * those counters.
>   * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
>   */
>  #include <kvm_util.h>
> @@ -37,6 +38,259 @@ static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
>  	*pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
>  }
>  
> +/* Read PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
> +static inline unsigned long read_sel_evcntr(int sel)
> +{
> +	write_sysreg(sel, pmselr_el0);
> +	isb();
> +	return read_sysreg(pmxevcntr_el0);
> +}> +
> +/* Write PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
> +static inline void write_sel_evcntr(int sel, unsigned long val)
> +{
> +	write_sysreg(sel, pmselr_el0);
> +	isb();
> +	write_sysreg(val, pmxevcntr_el0);
> +	isb();
> +}
> +
> +/* Read PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
> +static inline unsigned long read_sel_evtyper(int sel)
> +{
> +	write_sysreg(sel, pmselr_el0);
> +	isb();
> +	return read_sysreg(pmxevtyper_el0);
> +}
> +
> +/* Write PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
> +static inline void write_sel_evtyper(int sel, unsigned long val)
> +{
> +	write_sysreg(sel, pmselr_el0);
> +	isb();
> +	write_sysreg(val, pmxevtyper_el0);
> +	isb();
> +}
> +
> +static inline void enable_counter(int idx)
> +{
> +	uint64_t v = read_sysreg(pmcntenset_el0);
> +
> +	write_sysreg(BIT(idx) | v, pmcntenset_el0);
> +	isb();
> +}
> +
> +static inline void disable_counter(int idx)
> +{
> +	uint64_t v = read_sysreg(pmcntenset_el0);
> +
> +	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
> +	isb();
> +}
> +
> +static void pmu_disable_reset(void)
> +{
> +	uint64_t pmcr = read_sysreg(pmcr_el0);
> +
> +	/* Reset all counters, disabling them */
> +	pmcr &= ~ARMV8_PMU_PMCR_E;
> +	write_sysreg(pmcr | ARMV8_PMU_PMCR_P, pmcr_el0);
> +	isb();
> +> +
> +#define RETURN_READ_PMEVCNTRN(n) \
> +	return read_sysreg(pmevcntr##n##_el0)
> +static unsigned long read_pmevcntrn(int n)
> +{
> +	PMEVN_SWITCH(n, RETURN_READ_PMEVCNTRN);
> +	return 0;
> +}
> +
> +#define WRITE_PMEVCNTRN(n) \
> +	write_sysreg(val, pmevcntr##n##_el0)
> +static void write_pmevcntrn(int n, unsigned long val)
> +{
> +	PMEVN_SWITCH(n, WRITE_PMEVCNTRN);
> +	isb();
> +}
> +
> +#define READ_PMEVTYPERN(n) \
> +	return read_sysreg(pmevtyper##n##_el0)
> +static unsigned long read_pmevtypern(int n)
> +{
> +	PMEVN_SWITCH(n, READ_PMEVTYPERN);
> +	return 0;
> +}
> +
> +#define WRITE_PMEVTYPERN(n) \
> +	write_sysreg(val, pmevtyper##n##_el0)
> +static void write_pmevtypern(int n, unsigned long val)
> +{
> +	PMEVN_SWITCH(n, WRITE_PMEVTYPERN);
> +	isb();
> +}
> +
> +/*
> + * The pmc_accessor structure has pointers to PMEVT{CNTR,TYPER}<n>_EL0
> + * accessors that test cases will use. Each of the accessors will
> + * either directly reads/writes PMEVT{CNTR,TYPER}<n>_EL0
> + * (i.e. {read,write}_pmev{cnt,type}rn()), or reads/writes them through
> + * PMXEV{CNTR,TYPER}_EL0 (i.e. {read,write}_sel_ev{cnt,type}r()).
> + *
> + * This is used to test that combinations of those accessors provide
> + * the consistent behavior.
> + */
> +struct pmc_accessor {
> +	/* A function to be used to read PMEVTCNTR<n>_EL0 */
> +	unsigned long	(*read_cntr)(int idx);
> +	/* A function to be used to write PMEVTCNTR<n>_EL0 */
> +	void		(*write_cntr)(int idx, unsigned long val);
> +	/* A function to be used to read PMEVTYPER<n>_EL0 */
> +	unsigned long	(*read_typer)(int idx);
> +	/* A function to be used to write PMEVTYPER<n>_EL0 */
> +	void		(*write_typer)(int idx, unsigned long val);
> +};
> +
> +struct pmc_accessor pmc_accessors[] = {
> +	/* test with all direct accesses */
> +	{ read_pmevcntrn, write_pmevcntrn, read_pmevtypern, write_pmevtypern },
> +	/* test with all indirect accesses */
> +	{ read_sel_evcntr, write_sel_evcntr, read_sel_evtyper, write_sel_evtyper },
> +	/* read with direct accesses, and write with indirect accesses */
> +	{ read_pmevcntrn, write_sel_evcntr, read_pmevtypern, write_sel_evtyper },
> +	/* read with indirect accesses, and write with direct accesses */
> +	{ read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevtypern },
> +};
what is the rationale behing testing both direct and indirect accesses
and any combinations? I think this would deserve some
comments/justification.
> +
> +/*
> + * Convert a pointer of pmc_accessor to an index in pmc_accessors[],
> + * assuming that the pointer is one of the entries in pmc_accessors[].
> + */
> +#define PMC_ACC_TO_IDX(acc)	(acc - &pmc_accessors[0])
> +
> +#define GUEST_ASSERT_BITMAP_REG(regname, mask, set_expected)			 \
> +{										 \
> +	uint64_t _tval = read_sysreg(regname);					 \
> +										 \
> +	if (set_expected)							 \
> +		__GUEST_ASSERT((_tval & mask),					 \
> +				"tval: 0x%lx; mask: 0x%lx; set_expected: 0x%lx", \
> +				_tval, mask, set_expected);			 \
> +	else									 \
> +		__GUEST_ASSERT(!(_tval & mask),					 \
> +				"tval: 0x%lx; mask: 0x%lx; set_expected: 0x%lx", \
> +				_tval, mask, set_expected);			 \
> +}
> +
> +/*
> + * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
> + * are set or cleared as specified in @set_expected.
> + */
> +static void check_bitmap_pmu_regs(uint64_t mask, bool set_expected)
> +{
> +	GUEST_ASSERT_BITMAP_REG(pmcntenset_el0, mask, set_expected);
> +	GUEST_ASSERT_BITMAP_REG(pmcntenclr_el0, mask, set_expected);
> +	GUEST_ASSERT_BITMAP_REG(pmintenset_el1, mask, set_expected);
> +	GUEST_ASSERT_BITMAP_REG(pmintenclr_el1, mask, set_expected);
> +	GUEST_ASSERT_BITMAP_REG(pmovsset_el0, mask, set_expected);
> +	GUEST_ASSERT_BITMAP_REG(pmovsclr_el0, mask, set_expected);
> +}
> +
> +/*
> + * Check if the bit in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers corresponding
> + * to the specified counter (@pmc_idx) can be read/written as expected.
> + * When @set_op is true, it tries to set the bit for the counter in
> + * those registers by writing the SET registers (the bit won't be set
> + * if the counter is not implemented though).
> + * Otherwise, it tries to clear the bits in the registers by writing
> + * the CLR registers.
> + * Then, it checks if the values indicated in the registers are as expected.
> + */
> +static void test_bitmap_pmu_regs(int pmc_idx, bool set_op)
> +{
> +	uint64_t pmcr_n, test_bit = BIT(pmc_idx);
> +	bool set_expected = false;
> +
> +	if (set_op) {
> +		write_sysreg(test_bit, pmcntenset_el0);
> +		write_sysreg(test_bit, pmintenset_el1);
> +		write_sysreg(test_bit, pmovsset_el0);
> +
> +		/* The bit will be set only if the counter is implemented */
> +		pmcr_n = get_pmcr_n(read_sysreg(pmcr_el0));
> +		set_expected = (pmc_idx < pmcr_n) ? true : false;
> +	} else {
> +		write_sysreg(test_bit, pmcntenclr_el0);
> +		write_sysreg(test_bit, pmintenclr_el1);
> +		write_sysreg(test_bit, pmovsclr_el0);
> +	}
> +	check_bitmap_pmu_regs(test_bit, set_expected);
> +}
> +
> +/*
> + * Tests for reading/writing registers for the (implemented) event counter
> + * specified by @pmc_idx.
> + */
> +static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
> +{
> +	uint64_t write_data, read_data;
> +
> +	/* Disable all PMCs and reset all PMCs to zero. */
> +	pmu_disable_reset();
> +
> +
nit: double empty line
> +	/*
> +	 * Tests for reading/writing {PMCNTEN,PMINTEN,PMOVS}{SET,CLR}_EL1.
> +	 */
> +
> +	/* Make sure that the bit in those registers are set to 0 */
> +	test_bitmap_pmu_regs(pmc_idx, false);
> +	/* Test if setting the bit in those registers works */
> +	test_bitmap_pmu_regs(pmc_idx, true);
> +	/* Test if clearing the bit in those registers works */
> +	test_bitmap_pmu_regs(pmc_idx, false);
> +
> +
same here
> +	/*
> +	 * Tests for reading/writing the event type register.
> +	 */
> +
> +	read_data = acc->read_typer(pmc_idx);
not needed I think
> +	/*
> +	 * Set the event type register to an arbitrary value just for testing
> +	 * of reading/writing the register.
> +	 * ArmARM says that for the event from 0x0000 to 0x003F,
nit s/ArmARM/Arm ARM
> +	 * the value indicated in the PMEVTYPER<n>_EL0.evtCount field is
> +	 * the value written to the field even when the specified event
> +	 * is not supported.
> +	 */
> +	write_data = (ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMUV3_PERFCTR_INST_RETIRED);
> +	acc->write_typer(pmc_idx, write_data);
> +	read_data = acc->read_typer(pmc_idx);
> +	__GUEST_ASSERT(read_data == write_data,
> +		       "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx; write_data: 0x%lx",
> +		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
> +
> +
> +	/*
> +	 * Tests for reading/writing the event count register.
> +	 */
> +
> +	read_data = acc->read_cntr(pmc_idx);
> +
> +	/* The count value must be 0, as it is not used after the reset */
s/not used/disabled and reset?
> +	__GUEST_ASSERT(read_data == 0,
> +		       "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx",
> +		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data);
> +
> +	write_data = read_data + pmc_idx + 0x12345;
> +	acc->write_cntr(pmc_idx, write_data);
> +	read_data = acc->read_cntr(pmc_idx);
> +	__GUEST_ASSERT(read_data == write_data,
> +		       "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx; write_data: 0x%lx",
> +		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
> +}
> +
>  static void guest_sync_handler(struct ex_regs *regs)
>  {
>  	uint64_t esr, ec;
> @@ -49,11 +303,14 @@ static void guest_sync_handler(struct ex_regs *regs)
>  /*
>   * The guest is configured with PMUv3 with @expected_pmcr_n number of
>   * event counters.
> - * Check if @expected_pmcr_n is consistent with PMCR_EL0.N.
> + * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
> + * if reading/writing PMU registers for implemented counters can work
s/can work/works
> + * as expected.
>   */
>  static void guest_code(uint64_t expected_pmcr_n)
>  {
>  	uint64_t pmcr, pmcr_n;
> +	int i, pmc;
>  
>  	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
>  			"Expected PMCR.N: 0x%lx; ARMv8 general counters: 0x%lx",
> @@ -67,6 +324,15 @@ static void guest_code(uint64_t expected_pmcr_n)
>  			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
>  			pmcr_n, expected_pmcr_n);
>  
> +	/*
> +	 * Tests for reading/writing PMU registers for implemented counters.
> +	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> +		for (pmc = 0; pmc < pmcr_n; pmc++)
> +			test_access_pmc_regs(&pmc_accessors[i], pmc);
> +	}
> +
>  	GUEST_DONE();
>  }
>  
Thanks

Eric

