Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1837D89C0
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 22:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjJZUjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 16:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJZUjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 16:39:06 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27422191
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 13:39:04 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6be840283ceso1337904b3a.3
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 13:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698352743; x=1698957543; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jWfxmYPISTWv/m0+qLcYuup4KIcKEYDUaiihDfB8dmA=;
        b=snMV+O71zErV79g2oz8hjGhqi7TJr4s/gzn3kcp4cWASWG4Sy2SylxNBwPsUL6sTcF
         w3PFFqZi7WuxXNcGmheWFYBjuGAn58xvj+/DbAwKYY0x7nj11iPP78TkAq+gxc40mf7U
         y8rCWRbbjozPRpu8ZBPl3XdwJ+cIKVcmcrSGQMdfEFA8SIy3Gcj/NvscqiVNoxnU+SUJ
         BcmdFDzR/ha0CSabV2agKyzPGAz0BZPqJqf7lI1n/4hX5k/R9q6tdENAGQtJRS6Ygd/C
         I79l960GeSfbad8oFqrLzaSsZi+oo/H5Mq6KB25aeCYgkaJ7OHagQ2cbs0IegQhcZA/j
         l6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698352743; x=1698957543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jWfxmYPISTWv/m0+qLcYuup4KIcKEYDUaiihDfB8dmA=;
        b=sdPmTub2rgo756ynNHXQXJ6w4KHdLo71tfV6QaKFrCZAtQ+BYFk+LDtBFNz5X9L9b6
         7eWBjtiYZKURT/8PUZZf2LT4350l1O6gSBaiOJcHYBZ/zHtNUyvz9K3KJBafH7c//QSK
         D8/Wsj3p2D8EuU05lrEL73bdZF+IhPRdrDKj9FglbawdDdGLdMzoDFYes6Z5AfDzUJqu
         gNDkze97N8JCNdjxSSZVgiIaK3GSUufZR4ACFARsCRZyGC8xjp6YMeNFNmt7gwG6cI5D
         3S2d3RaPq3j331mIKZjdre1SNexCzE6VRcyoSlg7LlGm/Vz+h4r9bok6+fIZJr7P7Xu6
         B6xQ==
X-Gm-Message-State: AOJu0YwPMpKO/3u2lQlbuCBolb+EJvUBqqDcwlfj+8qMqycZ/8nPtekO
        Kk89f3tH1rgJiltYO1V4AQ7SfA==
X-Google-Smtp-Source: AGHT+IFilC9641yy8FOf7WlFYjOMhK9h8JtCU22JBuWdYCW3VluppU4gHYDx8I3yNbaMkIxSCMqVlA==
X-Received: by 2002:a05:6a20:1447:b0:17b:2b7e:923c with SMTP id a7-20020a056a20144700b0017b2b7e923cmr1144985pzi.16.1698352743191;
        Thu, 26 Oct 2023 13:39:03 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id g18-20020a62e312000000b0068feb378b89sm6151pfh.171.2023.10.26.13.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 13:39:02 -0700 (PDT)
Date:   Thu, 26 Oct 2023 20:38:59 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH v5 08/13] KVM: selftests: Test Intel PMU architectural
 events on gp counters
Message-ID: <ZTrOYztylSn7jNIE@google.com>
References: <20231024002633.2540714-1-seanjc@google.com>
 <20231024002633.2540714-9-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024002633.2540714-9-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023, Sean Christopherson wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Add test cases to check if different Architectural events are available
> after it's marked as unavailable via CPUID. It covers vPMU event filtering
> logic based on Intel CPUID, which is a complement to pmu_event_filter.
> 
> According to Intel SDM, the number of architectural events is reported
> through CPUID.0AH:EAX[31:24] and the architectural event x is supported
> if EBX[x]=0 && EAX[31:24]>x.
> 
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/pmu_counters_test.c  | 189 ++++++++++++++++++
>  2 files changed, 190 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index ed1c17cabc07..4c024fb845b4 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -82,6 +82,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
>  TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
>  TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
>  TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
> +TEST_GEN_PROGS_x86_64 += x86_64/pmu_counters_test
>  TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
>  TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
>  TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> new file mode 100644
> index 000000000000..2a6336b994d5
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -0,0 +1,189 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023, Tencent, Inc.
> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <x86intrin.h>
> +
> +#include "pmu.h"
> +#include "processor.h"
> +
> +/* Guest payload for any performance counter counting */
> +#define NUM_BRANCHES		10
> +
> +static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
> +						  void *guest_code)
> +{
> +	struct kvm_vm *vm;
> +
> +	vm = vm_create_with_one_vcpu(vcpu, guest_code);
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(*vcpu);
> +
> +	return vm;
> +}
> +
> +static void run_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +
> +	do {
> +		vcpu_run(vcpu);
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			break;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		case UCALL_DONE:
> +			break;
> +		default:
> +			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
> +		}
> +	} while (uc.cmd != UCALL_DONE);
> +}
> +
> +static bool pmu_is_intel_event_stable(uint8_t idx)
> +{
> +	switch (idx) {
> +	case INTEL_ARCH_CPU_CYCLES:
> +	case INTEL_ARCH_INSTRUCTIONS_RETIRED:
> +	case INTEL_ARCH_REFERENCE_CYCLES:
> +	case INTEL_ARCH_BRANCHES_RETIRED:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}

Brief explanation on why other events are not stable please. Since there
are only a few architecture events, maybe listing all of them with
explanation in comments would work better. Let out-of-bound return false
on default.
> +
> +static void guest_measure_pmu_v1(struct kvm_x86_pmu_feature event,
> +				 uint32_t counter_msr, uint32_t nr_gp_counters)
> +{
> +	uint8_t idx = event.f.bit;
> +	unsigned int i;
> +
> +	for (i = 0; i < nr_gp_counters; i++) {
> +		wrmsr(counter_msr + i, 0);
> +		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
> +		      ARCH_PERFMON_EVENTSEL_ENABLE | intel_pmu_arch_events[idx]);
> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));

Some comment might be needed for readability. Abuptly inserting inline
assembly code in C destroys the readability.

I wonder do we need add 'clobber' here for the above line, since it
takes away ecx?

Also, I wonder if we need to disable IRQ here? This code might be
intercepted and resumed. If so, then the test will get a different
number?
> +
> +		if (pmu_is_intel_event_stable(idx))
> +			GUEST_ASSERT_EQ(this_pmu_has(event), !!_rdpmc(i));

Okay, just the counter value is non-zero means we pass the test ?!

hmm, I wonder other than IRQ stuff, what else may affect the result? NMI
watchdog or what?
> +
> +		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
> +		      !ARCH_PERFMON_EVENTSEL_ENABLE |
> +		      intel_pmu_arch_events[idx]);
> +		wrmsr(counter_msr + i, 0);
> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
ditto for readability. Please consider using a macro to avoid repeated
explanation.

> +
> +		if (pmu_is_intel_event_stable(idx))
> +			GUEST_ASSERT(!_rdpmc(i));
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void guest_measure_loop(uint8_t idx)
> +{
> +	const struct {
> +		struct kvm_x86_pmu_feature gp_event;
> +	} intel_event_to_feature[] = {
> +		[INTEL_ARCH_CPU_CYCLES]		   = { X86_PMU_FEATURE_CPU_CYCLES },
> +		[INTEL_ARCH_INSTRUCTIONS_RETIRED]  = { X86_PMU_FEATURE_INSNS_RETIRED },
> +		[INTEL_ARCH_REFERENCE_CYCLES]	   = { X86_PMU_FEATURE_REFERENCE_CYCLES },
> +		[INTEL_ARCH_LLC_REFERENCES]	   = { X86_PMU_FEATURE_LLC_REFERENCES },
> +		[INTEL_ARCH_LLC_MISSES]		   = { X86_PMU_FEATURE_LLC_MISSES },
> +		[INTEL_ARCH_BRANCHES_RETIRED]	   = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED },
> +		[INTEL_ARCH_BRANCHES_MISPREDICTED] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED },
> +	};
> +
> +	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
> +	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
> +	struct kvm_x86_pmu_feature gp_event;
> +	uint32_t counter_msr;
> +	unsigned int i;
> +
> +	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
> +		counter_msr = MSR_IA32_PMC0;
> +	else
> +		counter_msr = MSR_IA32_PERFCTR0;
> +
> +	gp_event = intel_event_to_feature[idx].gp_event;
> +	TEST_ASSERT_EQ(idx, gp_event.f.bit);
> +
> +	if (pmu_version < 2) {
> +		guest_measure_pmu_v1(gp_event, counter_msr, nr_gp_counters);
> +		return;
> +	}
> +
> +	for (i = 0; i < nr_gp_counters; i++) {
> +		wrmsr(counter_msr + i, 0);
> +		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
> +		      ARCH_PERFMON_EVENTSEL_ENABLE |
> +		      intel_pmu_arch_events[idx]);
> +
> +		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
> +		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +
> +		if (pmu_is_intel_event_stable(idx))
> +			GUEST_ASSERT_EQ(this_pmu_has(gp_event), !!_rdpmc(i));
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void test_arch_events_cpuid(uint8_t i, uint8_t j, uint8_t idx)
> +{
> +	uint8_t arch_events_unavailable_mask = BIT_ULL(j);
> +	uint8_t arch_events_bitmap_size = BIT_ULL(i);
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_measure_loop);
> +
> +	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH,
> +				arch_events_bitmap_size);
> +	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EVENTS_MASK,
> +				arch_events_unavailable_mask);
> +
> +	vcpu_args_set(vcpu, 1, idx);
> +
> +	run_vcpu(vcpu);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +static void test_intel_arch_events(void)
> +{
> +	uint8_t idx, i, j;
> +
> +	for (idx = 0; idx < NR_INTEL_ARCH_EVENTS; idx++) {
> +		/*
> +		 * A brute force iteration of all combinations of values is
> +		 * likely to exhaust the limit of the single-threaded thread
> +		 * fd nums, so it's test by iterating through all valid
> +		 * single-bit values.
> +		 */
> +		for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {
> +			for (j = 0; j < NR_INTEL_ARCH_EVENTS; j++)
> +				test_arch_events_cpuid(i, j, idx);
> +		}
> +	}
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> +
> +	TEST_REQUIRE(host_cpu_is_intel);
> +	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
> +	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
> +	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));

hmm, this means we cannot run this in nested if X86_FEATURE_PDCM is
missing. It only affects full-width counter, right?

> +
> +	test_intel_arch_events();
> +
> +	return 0;
> +}
> -- 
> 2.42.0.758.gaed0368e0e-goog
> 
