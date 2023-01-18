Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99AE67161C
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 09:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjARIW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 03:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjARIVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 03:21:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1476F89E
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 23:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674028073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tlVUxcaPaiWawLUro82o60VnJJfjPIrLSa466P13ZoI=;
        b=Vich5gUeb6P8T6uetfix7NjPbrcPHDVJrJJ4xDFrsyE1JLrAMatJxSlxXbVe/wmIIOYTWs
        EpXDidSzLJuiYgktoT9e77TzoONhfDzn4f8bYqNTy+6CzU43F6LRQ3cK1IMUNm0s8SEUQ4
        oQug4qSv6iGmRMWdkhyhawB/Sll4uvc=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-aBRm9vn5PS20NeKPFPWiAg-1; Wed, 18 Jan 2023 02:47:49 -0500
X-MC-Unique: aBRm9vn5PS20NeKPFPWiAg-1
Received: by mail-pf1-f197.google.com with SMTP id dc11-20020a056a0035cb00b00589a6a97519so12012597pfb.8
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 23:47:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlVUxcaPaiWawLUro82o60VnJJfjPIrLSa466P13ZoI=;
        b=4UrRzf3kmA0UpkJfyMFuPcoTVAU9Zan+rPUS2LNrOyPzhEoDj/x6FSJPlYOMrFx4Hw
         KH6JqaLkyG6rqVFPk7wnZStW97eLh9Zw7/ZzdGxAA1z9MItqQXfsERAW6uiBHlCiVjfP
         sDwfCE5g1iEmQRNOpePWC8wPRI3jfB+mDd9zLz/CpOjDPCtMuJSiGDHwEptZHwGDEWZ7
         jFlIYIXQ8egWFuC0HEJg8Dxv6pnfqB65FNEhtmFGm1wzKLJnaVVHb93P2/HtVAm2rGBe
         xyy29utp9Kn6tACAiumPFuQAWW2b2UAr1Mxx9SBXKF+hepMRohr3FNVLY6uKmM2DYQv4
         Wh5g==
X-Gm-Message-State: AFqh2krDz0L+9BHZdpJy6uDydbua1PuanAhRSL0KH12pvc/GqKtKQGkL
        9pWkM7dzEtYkYaMCm5OiJ0lp2O8FhV6Ot9jHB4G6cHQMrsXHPTbip6HLrxM5EDhzQq0KNCuDo/r
        KIZKcKylJF4fC
X-Received: by 2002:aa7:9114:0:b0:57f:d5d1:41d0 with SMTP id 20-20020aa79114000000b0057fd5d141d0mr1507041pfh.3.1674028068460;
        Tue, 17 Jan 2023 23:47:48 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvYKTekF4XxUh8s4kPzgSvNbcgQ4xezNbU2QpJP5Qj3AUKhgCwzUxS/yP593Zsc6apCJlRhbw==
X-Received: by 2002:aa7:9114:0:b0:57f:d5d1:41d0 with SMTP id 20-20020aa79114000000b0057fd5d141d0mr1507033pfh.3.1674028068138;
        Tue, 17 Jan 2023 23:47:48 -0800 (PST)
Received: from [10.66.60.207] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x186-20020a6263c3000000b0058dbb5b44edsm4136563pfb.178.2023.01.17.23.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 23:47:47 -0800 (PST)
Message-ID: <1c5f7194-277a-d8bd-8714-a8e1553344c4@redhat.com>
Date:   Wed, 18 Jan 2023 15:47:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 7/8] KVM: selftests: aarch64: vPMU register test for
 implemented counters
Content-Language: en-US
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20230117013542.371944-1-reijiw@google.com>
 <20230117013542.371944-8-reijiw@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230117013542.371944-8-reijiw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,


I found some place should be PMEVTYPER, but wrongly written to 
PMEVTTYPE. Should we fix them?


I list some of them, but not covered every one.

On 1/17/23 09:35, Reiji Watanabe wrote:
> Add a new test case to the vpmu_counter_access test to check if PMU
> registers or their bits for implemented counters on the vCPU are
> readable/writable as expected, and can be programmed to count events.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>   .../kvm/aarch64/vpmu_counter_access.c         | 347 +++++++++++++++++-
>   1 file changed, 344 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index 704a2500b7e1..54b69c76c824 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -5,7 +5,8 @@
>    * Copyright (c) 2022 Google LLC.
>    *
>    * This test checks if the guest can see the same number of the PMU event
> - * counters (PMCR_EL1.N) that userspace sets.
> + * counters (PMCR_EL1.N) that userspace sets, and if the guest can access
> + * those counters.
>    * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
>    */
>   #include <kvm_util.h>
> @@ -18,19 +19,350 @@
>   /* The max number of the PMU event counters (excluding the cycle counter) */
>   #define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
>   
> +/*
> + * The macros and functions below for reading/writing PMEVT{CNTR,TYPER}<n>_EL0
Here should be PMEV{CNTR, TYPER}.
> + * were basically copied from arch/arm64/kernel/perf_event.c.
> + */
> +#define PMEVN_CASE(n, case_macro) \
> +	case n: case_macro(n); break
> +
> +#define PMEVN_SWITCH(x, case_macro)				\
> +	do {							\
> +		switch (x) {					\
> +		PMEVN_CASE(0,  case_macro);			\
> +		PMEVN_CASE(1,  case_macro);			\
> +		PMEVN_CASE(2,  case_macro);			\
> +		PMEVN_CASE(3,  case_macro);			\
> +		PMEVN_CASE(4,  case_macro);			\
> +		PMEVN_CASE(5,  case_macro);			\
> +		PMEVN_CASE(6,  case_macro);			\
> +		PMEVN_CASE(7,  case_macro);			\
> +		PMEVN_CASE(8,  case_macro);			\
> +		PMEVN_CASE(9,  case_macro);			\
> +		PMEVN_CASE(10, case_macro);			\
> +		PMEVN_CASE(11, case_macro);			\
> +		PMEVN_CASE(12, case_macro);			\
> +		PMEVN_CASE(13, case_macro);			\
> +		PMEVN_CASE(14, case_macro);			\
> +		PMEVN_CASE(15, case_macro);			\
> +		PMEVN_CASE(16, case_macro);			\
> +		PMEVN_CASE(17, case_macro);			\
> +		PMEVN_CASE(18, case_macro);			\
> +		PMEVN_CASE(19, case_macro);			\
> +		PMEVN_CASE(20, case_macro);			\
> +		PMEVN_CASE(21, case_macro);			\
> +		PMEVN_CASE(22, case_macro);			\
> +		PMEVN_CASE(23, case_macro);			\
> +		PMEVN_CASE(24, case_macro);			\
> +		PMEVN_CASE(25, case_macro);			\
> +		PMEVN_CASE(26, case_macro);			\
> +		PMEVN_CASE(27, case_macro);			\
> +		PMEVN_CASE(28, case_macro);			\
> +		PMEVN_CASE(29, case_macro);			\
> +		PMEVN_CASE(30, case_macro);			\
> +		default:					\
> +			GUEST_ASSERT_1(0, x);			\
> +		}						\
> +	} while (0)
> +
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
> +/* Read PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
> +static inline unsigned long read_sel_evcntr(int sel)
> +{
> +	write_sysreg(sel, pmselr_el0);
> +	isb();
> +	return read_sysreg(pmxevcntr_el0);
> +}
> +
> +/* Write PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
> +static inline void write_sel_evcntr(int sel, unsigned long val)
> +{
> +	write_sysreg(sel, pmselr_el0);
> +	isb();
> +	write_sysreg(val, pmxevcntr_el0);
> +	isb();
> +}
> +
> +/* Read PMEVTTYPER<n>_EL0 through PMXEVTYPER_EL0 */
Here should be PMEVTYPER.
> +static inline unsigned long read_sel_evtyper(int sel)
> +{
> +	write_sysreg(sel, pmselr_el0);
> +	isb();
> +	return read_sysreg(pmxevtyper_el0);
> +}
> +
> +/* Write PMEVTTYPER<n>_EL0 through PMXEVTYPER_EL0 */
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
> +	/* A function to be used to read PMEVTTYPER<n>_EL0 */
> +	unsigned long	(*read_typer)(int idx);
> +	/* A function to be used write PMEVTTYPER<n>_EL0 */
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
> +
> +static void pmu_disable_reset(void)
> +{
> +	uint64_t pmcr = read_sysreg(pmcr_el0);
> +
> +	/* Reset all counters, disabling them */
> +	pmcr &= ~ARMV8_PMU_PMCR_E;
> +	write_sysreg(pmcr | ARMV8_PMU_PMCR_P, pmcr_el0);
> +	isb();
> +}
> +
> +static void pmu_enable(void)
> +{
> +	uint64_t pmcr = read_sysreg(pmcr_el0);
> +
> +	/* Reset all counters, disabling them */
> +	pmcr |= ARMV8_PMU_PMCR_E;
> +	write_sysreg(pmcr | ARMV8_PMU_PMCR_P, pmcr_el0);
> +	isb();
> +}
> +
> +static bool pmu_event_is_supported(uint64_t event)
> +{
> +	GUEST_ASSERT_1(event < 64, event);
> +	return (read_sysreg(pmceid0_el0) & BIT(event));
> +}
> +
>   static uint64_t pmcr_extract_n(uint64_t pmcr_val)
>   {
>   	return (pmcr_val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
>   }
>   
> +#define GUEST_ASSERT_BITMAP_REG(regname, mask, set_expected)		\
> +{									\
> +	uint64_t _tval = read_sysreg(regname);				\
> +									\
> +	if (set_expected)						\
> +		GUEST_ASSERT_3((_tval & mask), _tval, mask, set_expected); \
> +	else								   \
> +		GUEST_ASSERT_3(!(_tval & mask), _tval, mask, set_expected);\
> +}
> +
> +/*
> + * Check if @mask bits in {PMCNTEN,PMOVS}{SET,CLR} registers
> + * are set or cleared as specified in @set_expected.
> + */
> +static void check_bitmap_pmu_regs(uint64_t mask, bool set_expected)
> +{
> +	GUEST_ASSERT_BITMAP_REG(pmcntenset_el0, mask, set_expected);
> +	GUEST_ASSERT_BITMAP_REG(pmcntenclr_el0, mask, set_expected);
> +	GUEST_ASSERT_BITMAP_REG(pmovsset_el0, mask, set_expected);
> +	GUEST_ASSERT_BITMAP_REG(pmovsclr_el0, mask, set_expected);
> +}
> +
> +/*
> + * Check if the bit in {PMCNTEN,PMOVS}{SET,CLR} registers corresponding
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
> +		write_sysreg(test_bit, pmovsset_el0);
> +
> +		/* The bit will be set only if the counter is implemented */
> +		pmcr_n = pmcr_extract_n(read_sysreg(pmcr_el0));
> +		set_expected = (pmc_idx < pmcr_n) ? true : false;
> +	} else {
> +		write_sysreg(test_bit, pmcntenclr_el0);
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
> +	uint64_t write_data, read_data, read_data_prev, test_bit;
> +
> +	/* Disable all PMCs and reset all PMCs to zero. */
> +	pmu_disable_reset();
> +
> +
> +	/*
> +	 * Tests for reading/writing {PMCNTEN,PMOVS}{SET,CLR}_EL1.
> +	 */
> +
> +	test_bit = 1ul << pmc_idx;
> +	/* Make sure that the bit in those registers are set to 0 */
> +	test_bitmap_pmu_regs(test_bit, false);
> +	/* Test if setting the bit in those registers works */
> +	test_bitmap_pmu_regs(test_bit, true);
> +	/* Test if clearing the bit in those registers works */
> +	test_bitmap_pmu_regs(test_bit, false);
> +
> +
> +	/*
> +	 * Tests for reading/writing the event type register.
> +	 */
> +
> +	read_data = acc->read_typer(pmc_idx);
> +	/*
> +	 * Set the event type register to an arbitrary value just for testing
> +	 * of reading/writing the register.
> +	 * ArmARM says that for the event from 0x0000 to 0x003F,
> +	 * the value indicated in the PMEVTYPER<n>_EL0.evtCount field is
> +	 * the value written to the field even when the specified event
> +	 * is not supported.
> +	 */
> +	write_data = (ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMUV3_PERFCTR_INST_RETIRED);
> +	acc->write_typer(pmc_idx, write_data);
> +	read_data = acc->read_typer(pmc_idx);
> +	GUEST_ASSERT_4(read_data == write_data,
> +		       pmc_idx, acc, read_data, write_data);
> +
> +
> +	/*
> +	 * Tests for reading/writing the event count register.
> +	 */
> +
> +	read_data = acc->read_cntr(pmc_idx);
> +
> +	/* The count value must be 0, as it is not used after the reset */
> +	GUEST_ASSERT_3(read_data == 0, pmc_idx, acc, read_data);
> +
> +	write_data = read_data + pmc_idx + 0x12345;
> +	acc->write_cntr(pmc_idx, write_data);
> +	read_data = acc->read_cntr(pmc_idx);
> +	GUEST_ASSERT_4(read_data == write_data,
> +		       pmc_idx, acc, read_data, write_data);
> +
> +
> +	/* The following test requires the INST_RETIRED event support. */
> +	if (!pmu_event_is_supported(ARMV8_PMUV3_PERFCTR_INST_RETIRED))
> +		return;
> +
> +	pmu_enable();
> +	acc->write_typer(pmc_idx, ARMV8_PMUV3_PERFCTR_INST_RETIRED);
> +
> +	/*
> +	 * Make sure that the counter doesn't count the INST_RETIRED
> +	 * event when disabled, and the counter counts the event when enabled.
> +	 */
> +	disable_counter(pmc_idx);
> +	read_data_prev = acc->read_cntr(pmc_idx);
> +	read_data = acc->read_cntr(pmc_idx);
> +	GUEST_ASSERT_4(read_data == read_data_prev,
> +		       pmc_idx, acc, read_data, read_data_prev);
> +
> +	enable_counter(pmc_idx);
> +	read_data = acc->read_cntr(pmc_idx);
> +
> +	/*
> +	 * The counter should be increased by at least 1, as there is at
> +	 * least one instruction between enabling the counter and reading
> +	 * the counter (the test assumes that all event counters are not
> +	 * being used by the host's higher priority events).
> +	 */
> +	GUEST_ASSERT_4(read_data > read_data_prev,
> +		       pmc_idx, acc, read_data, read_data_prev);
> +}
> +
>   /*
>    * The guest is configured with PMUv3 with @expected_pmcr_n number of
>    * event counters.
> - * Check if @expected_pmcr_n is consistent with PMCR_EL0.N.
> + * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
> + * if reading/writing PMU registers for implemented counters can work
> + * as expected.
>    */
>   static void guest_code(uint64_t expected_pmcr_n)
>   {
>   	uint64_t pmcr, pmcr_n;
> +	int i, pmc;
>   
>   	GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS);
>   
> @@ -40,6 +372,15 @@ static void guest_code(uint64_t expected_pmcr_n)
>   	/* Make sure that PMCR_EL0.N indicates the value userspace set */
>   	GUEST_ASSERT_2(pmcr_n == expected_pmcr_n, pmcr_n, expected_pmcr_n);
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
>   	GUEST_DONE();
>   }
>   
> @@ -96,7 +437,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
>   	vcpu_run(vcpu);
>   	switch (get_ucall(vcpu, &uc)) {
>   	case UCALL_ABORT:
> -		REPORT_GUEST_ASSERT_2(uc, "values:%#lx %#lx");
> +		REPORT_GUEST_ASSERT_4(uc, "values:%#lx %#lx %#lx %#lx");
>   		break;
>   	case UCALL_DONE:
>   		break;

-- 
Regards,
Shaoqin

