Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718BA7A28DB
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 23:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbjIOVBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 17:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbjIOVBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 17:01:09 -0400
Received: from out-219.mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2E235A3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 14:00:08 -0700 (PDT)
Date:   Fri, 15 Sep 2023 21:00:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694811606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Um3DxvRo8y9xHx2WI0oXJn2/oJ2IDX4d0Wgi0ZW0gpo=;
        b=aRbnaAbj2UylHDoVZALHjVXVIFFrvuc68JyaQSDtve8/c7z030eZJTPdWmq2fqFPD+Owzz
        JRr6XjGe1Dgnm+C1qDBwvHj+dr/Ks9jmMqx8XNdCHvI7KibwFusLSZ+hnnyss9sXhmqHFn
        4wtWt1AVk2anOGLZdefSVhYh/hIG9dw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
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
Subject: Re: [PATCH v5 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
Message-ID: <ZQTF0bxzXN2kUPTI@linux.dev>
References: <20230817003029.3073210-1-rananta@google.com>
 <20230817003029.3073210-11-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817003029.3073210-11-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Thu, Aug 17, 2023 at 12:30:27AM +0000, Raghavendra Rao Ananta wrote:
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
>  .../kvm/aarch64/vpmu_counter_access.c         | 235 ++++++++++++++++++
>  2 files changed, 236 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c692cc86e7da8..a1599e2b82e38 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -148,6 +148,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
>  TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
> +TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
>  TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> new file mode 100644
> index 0000000000000..d0afec07948ef
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -0,0 +1,235 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * vpmu_counter_access - Test vPMU event counter access
> + *
> + * Copyright (c) 2022 Google LLC.
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

nit: this test is single threaded, so there will only ever be a single
instance of a VM at a time. Dynamically allocating a backing structure
doesn't add any value, IMO.

You can just get away with using globals.

> +/*
> + * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
> + * the vCPU to @pmcr_n, which is larger than the host value.
> + * The attempt should fail as @pmcr_n is too big to set for the vCPU.
> + */
> +static void run_error_test(uint64_t pmcr_n)
> +{
> +	struct vpmu_vm *vpmu_vm;
> +	struct kvm_vcpu *vcpu;
> +	int ret;
> +	uint64_t pmcr, pmcr_orig;
> +
> +	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
> +	vpmu_vm = create_vpmu_vm(guest_code);
> +	vcpu = vpmu_vm->vcpu;
> +
> +	/* Update the PMCR_EL0.N with @pmcr_n */
> +	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
> +	pmcr = pmcr_orig & ~ARMV8_PMU_PMCR_N;
> +	pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> +
> +	/* This should fail as @pmcr_n is too big to set for the vCPU */
> +	ret = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
> +	TEST_ASSERT(ret, "Setting PMCR to 0x%lx (orig PMCR 0x%lx) didn't fail",
> +		    pmcr, pmcr_orig);

The failure pattern for this should now be the write to PMCR_EL0.N had
no effect.

-- 
Thanks,
Oliver
