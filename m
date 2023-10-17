Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448BA7CC6FC
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343969AbjJQPGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbjJQPGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:06:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F656FB7
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697554282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=On5sJ31uN4Ra8ik6/DRV/F2IIWr320vzwCyo3Oos02o=;
        b=Zsc8hC9MiDcUJsb0EDr4+KTyGJ43pJCBBeV1MxMvYVDWfYLlodblQfkU8eUWLjZp60zPjn
        kHzxrbHY+LQrypilWVi8YoKPEJr1nYVKblPEnAWuMjbjYOVYMo4fG3gcXrvhqG0PSfVnoR
        a4Gfas1374HhANzmU8dbpf9ZTLwtaGg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-rS9tf9tSNKueJ2U3F4C2TA-1; Tue, 17 Oct 2023 10:51:15 -0400
X-MC-Unique: rS9tf9tSNKueJ2U3F4C2TA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6564dbde089so105260986d6.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697554274; x=1698159074;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=On5sJ31uN4Ra8ik6/DRV/F2IIWr320vzwCyo3Oos02o=;
        b=rmJ/5kpMXt8hRkkRw9XGdZUzK630JXuqHOESui9us225suaT3AtETyLWUSlNU9dTnR
         /kbF4ZNTC1B6TbXSr5P6lTn8MWa2iC0NFk19DVmuxehq1ISp7KBUKS/v+nZF5KwCuyxS
         kOIn0LyoxLfr3tI53uJkl+fwOcj6hYsk33pfRXRSfq3jlmO+yyLZd/qQdVzYaxBAW7fE
         COanq23Z3K7xKY/eEe6rV4TXcJD7QMrQ72mj7S8xz89nRuNRdfb6WIFKg3cPwqvXL9pe
         LwAfXnoX4WQDKnJz52pfPLJA95cEyzcGg+cY95H8a2YqHKzOy0WwFu9rIkC/43/F5KJh
         Eedg==
X-Gm-Message-State: AOJu0YzyVV14kNG33LXHKcMI/SJZ8GfcspNWsvww5bDZPdpjOaM+y0Dv
        O5/Anj+qpg9XR8iM3rk2wSnDILCMfqgaFu8TokkC05yaNY/kg0xKb6yb1Lz5a8+oMhEuHYRUDLY
        LQCgnBHsVZfkch3o9hqIi
X-Received: by 2002:a0c:df0a:0:b0:66d:5bed:35f3 with SMTP id g10-20020a0cdf0a000000b0066d5bed35f3mr2798153qvl.20.1697554274326;
        Tue, 17 Oct 2023 07:51:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNHWTiPeUH75hyUb6CD7+pJ8o+547/VfZVUXz9z+btwuN1qTKk/BS6fBNhVW82n5y9oGZWlQ==
X-Received: by 2002:a0c:df0a:0:b0:66d:5bed:35f3 with SMTP id g10-20020a0cdf0a000000b0066d5bed35f3mr2798125qvl.20.1697554274004;
        Tue, 17 Oct 2023 07:51:14 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.237.139])
        by smtp.gmail.com with ESMTPSA id h13-20020a37c44d000000b0076ee973b9a7sm717632qkm.27.2023.10.17.07.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 07:51:13 -0700 (PDT)
Message-ID: <66eade47-54bb-bcf4-931a-9acfbdd5483d@redhat.com>
Date:   Tue, 17 Oct 2023 16:51:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
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
 <20231009230858.3444834-11-rananta@google.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-11-rananta@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,
On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Introduce vpmu_counter_access test for arm64 platforms.
> The test configures PMUv3 for a vCPU, sets PMCR_EL0.N for the vCPU,
> and check if the guest can consistently see the same number of the
> PMU event counters (PMCR_EL0.N) that userspace sets.
> This test case is done with each of the PMCR_EL0.N values from
> 0 to 31 (With the PMCR_EL0.N values greater than the host value,
> the test expects KVM_SET_ONE_REG for the PMCR_EL0 to fail).
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/aarch64/vpmu_counter_access.c         | 247 ++++++++++++++++++
>  2 files changed, 248 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index a3bb36fb3cfc..416700aa196c 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -149,6 +149,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
>  TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
> +TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
>  TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> new file mode 100644
> index 000000000000..58949b17d76e
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -0,0 +1,247 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * vpmu_counter_access - Test vPMU event counter access
> + *
> + * Copyright (c) 2022 Google LLC.
2023 ;-)
> + *
> + * This test checks if the guest can see the same number of the PMU event
> + * counters (PMCR_EL0.N) that userspace sets.
> + * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
> + */
> +#include <kvm_util.h>
> +#include <processor.h>
> +#include <test_util.h>
> +#include <vgic.h>
> +#include <perf/arm_pmuv3.h>
> +#include <linux/bitfield.h>
> +
> +/* The max number of the PMU event counters (excluding the cycle counter) */
> +#define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
> +
> +struct vpmu_vm {
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	int gic_fd;
> +};
> +
> +static struct vpmu_vm vpmu_vm;
> +
> +static uint64_t get_pmcr_n(uint64_t pmcr)
> +{
> +	return (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
> +}
> +
> +static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
> +{
> +	*pmcr = *pmcr & ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> +	*pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> +}
> +
> +static void guest_sync_handler(struct ex_regs *regs)
> +{
> +	uint64_t esr, ec;
> +
> +	esr = read_sysreg(esr_el1);
> +	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> +	__GUEST_ASSERT(0, "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx", regs->pc, esr, ec);
> +}
> +
> +/*
> + * The guest is configured with PMUv3 with @expected_pmcr_n number of
> + * event counters.
> + * Check if @expected_pmcr_n is consistent with PMCR_EL0.N.
> + */
> +static void guest_code(uint64_t expected_pmcr_n)
> +{
> +	uint64_t pmcr, pmcr_n;
> +
> +	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
> +			"Expected PMCR.N: 0x%lx; ARMv8 general counters: 0x%lx",
> +			expected_pmcr_n, ARMV8_PMU_MAX_GENERAL_COUNTERS);
> +
> +	pmcr = read_sysreg(pmcr_el0);
> +	pmcr_n = get_pmcr_n(pmcr);
> +
> +	/* Make sure that PMCR_EL0.N indicates the value userspace set */
> +	__GUEST_ASSERT(pmcr_n == expected_pmcr_n,
> +			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
> +			pmcr_n, expected_pmcr_n);
> +
> +	GUEST_DONE();
> +}
> +
> +#define GICD_BASE_GPA	0x8000000ULL
> +#define GICR_BASE_GPA	0x80A0000ULL
> +
> +/* Create a VM that has one vCPU with PMUv3 configured. */
> +static void create_vpmu_vm(void *guest_code)
> +{
> +	struct kvm_vcpu_init init;
> +	uint8_t pmuver, ec;
> +	uint64_t dfr0, irq = 23;
> +	struct kvm_device_attr irq_attr = {
> +		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
> +		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
> +		.addr = (uint64_t)&irq,
> +	};
> +	struct kvm_device_attr init_attr = {
> +		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
> +		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
> +	};
> +
> +	/* The test creates the vpmu_vm multiple times. Ensure a clean state */
> +	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
> +
> +	vpmu_vm.vm = vm_create(1);
> +	vm_init_descriptor_tables(vpmu_vm.vm);
> +	for (ec = 0; ec < ESR_EC_NUM; ec++) {
> +		vm_install_sync_handler(vpmu_vm.vm, VECTOR_SYNC_CURRENT, ec,
> +					guest_sync_handler);
> +	}
> +
> +	/* Create vCPU with PMUv3 */
> +	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> +	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
> +	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
> +	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
> +	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
> +					GICD_BASE_GPA, GICR_BASE_GPA);
__TEST_REQUIRE(vpmu_vm.gic_fd >= 0, "Failed to create vgic-v3, skipping");
as done in some other tests

> +
> +	/* Make sure that PMUv3 support is indicated in the ID register */
> +	vcpu_get_reg(vpmu_vm.vcpu,
> +		     KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
> +	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
> +	TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
> +		    pmuver >= ID_AA64DFR0_PMUVER_8_0,
> +		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
> +
> +	/* Initialize vPMU */
> +	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
> +	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
> +}
> +
> +static void destroy_vpmu_vm(void)
> +{
> +	close(vpmu_vm.gic_fd);
> +	kvm_vm_free(vpmu_vm.vm);
> +}
> +
> +static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
> +{
> +	struct ucall uc;
> +
> +	vcpu_args_set(vcpu, 1, pmcr_n);
> +	vcpu_run(vcpu);
> +	switch (get_ucall(vcpu, &uc)) {
> +	case UCALL_ABORT:
> +		REPORT_GUEST_ASSERT(uc);
> +		break;
> +	case UCALL_DONE:
> +		break;
> +	default:
> +		TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +		break;
> +	}
> +}
> +
> +/*
> + * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
> + * and run the test.
> + */
> +static void run_test(uint64_t pmcr_n)
> +{
> +	struct kvm_vcpu *vcpu;
> +	uint64_t sp, pmcr;
> +	struct kvm_vcpu_init init;
> +
> +	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
> +	create_vpmu_vm(guest_code);
> +
> +	vcpu = vpmu_vm.vcpu;
> +
> +	/* Save the initial sp to restore them later to run the guest again */
> +	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
> +
> +	/* Update the PMCR_EL0.N with @pmcr_n */
> +	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
> +	set_pmcr_n(&pmcr, pmcr_n);
> +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
> +
> +	run_vcpu(vcpu, pmcr_n);
> +
> +	/*
> +	 * Reset and re-initialize the vCPU, and run the guest code again to
> +	 * check if PMCR_EL0.N is preserved.
> +	 */
> +	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> +	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
> +	aarch64_vcpu_setup(vcpu, &init);
> +	vcpu_init_descriptor_tables(vcpu);
> +	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
> +	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
> +
> +	run_vcpu(vcpu, pmcr_n);
> +
> +	destroy_vpmu_vm();
> +}
> +
> +/*
> + * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
> + * the vCPU to @pmcr_n, which is larger than the host value.
> + * The attempt should fail as @pmcr_n is too big to set for the vCPU.
> + */
> +static void run_error_test(uint64_t pmcr_n)
> +{
> +	struct kvm_vcpu *vcpu;
> +	uint64_t pmcr, pmcr_orig;
> +
> +	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
> +	create_vpmu_vm(guest_code);
> +	vcpu = vpmu_vm.vcpu;
> +
> +	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
> +	pmcr = pmcr_orig;
> +
> +	/*
> +	 * Setting a larger value of PMCR.N should not modify the field, and
> +	 * return a success.
> +	 */
> +	set_pmcr_n(&pmcr, pmcr_n);
> +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
> +	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
> +	TEST_ASSERT(pmcr_orig == pmcr,
> +		    "PMCR.N modified by KVM to a larger value (PMCR: 0x%lx) for pmcr_n: 0x%lx\n",
> +		    pmcr, pmcr_n);
nit: you could introduce a set_pmcr_n() routine  which creates the
vpmu_vm and set the PMCR.N and check whether the setting is applied. An
arg could tell the helper whether this is supposed to fail. This could
be used in both run_error_test and run_test which both mostly use the
same code.
> +
> +	destroy_vpmu_vm();
> +}
> +
> +/*
> + * Return the default number of implemented PMU event counters excluding
> + * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
> + */
> +static uint64_t get_pmcr_n_limit(void)
> +{
> +	uint64_t pmcr;
> +
> +	create_vpmu_vm(guest_code);
> +	vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
> +	destroy_vpmu_vm();
> +	return get_pmcr_n(pmcr);
> +}
> +
> +int main(void)
> +{
> +	uint64_t i, pmcr_n;
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
> +
> +	pmcr_n = get_pmcr_n_limit();
> +	for (i = 0; i <= pmcr_n; i++)
> +		run_test(i);
> +
> +	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
> +		run_error_test(i);
> +
> +	return 0;
> +}

Besides this looks good to me.

Thanks

Eric

