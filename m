Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C934E7D157D
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 20:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377973AbjJTSJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 14:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377936AbjJTSI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 14:08:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4569ED5D
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 11:08:57 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a824ef7a83so14812197b3.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 11:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697825336; x=1698430136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RDarGDP1RT+TJzzdOkpOOWFxKR5bBC0tLy2rKhn8u+E=;
        b=jvDTw4y2oDqUcjrKw/wKn6IyuBofLwbYUs+HoHVg7GkHJ8CanFTRfDvvOFsHXVT2Lq
         nogDFcPfJmlmfsjogxdZ6ZBrkzopeAUBwmhm0f/Pipw7aK6fwMy8EEjmVhHSaCQfzJB+
         HzO/S4IffrXHIaMUmoIPs9rJwb6sno6bbDLlVErEfgTF6oy5wQ4riaB9nUEGNZlLJ7s7
         uM5oWJdiwajbZUVaEqimYlFvtu+VRjy9p19Dk7av5JA9UYCAbJ+jJUhH9tcRuKIYpd4A
         QDIIIRdQQhkrSEYEnhd90sm3z/THbnCgedCx3+OGDIXbXDDCZ91lNxutUaHEe7tLj4GY
         0rXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697825336; x=1698430136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RDarGDP1RT+TJzzdOkpOOWFxKR5bBC0tLy2rKhn8u+E=;
        b=TcdffdfloOtO7Jj5qaRSGvLH9mIBZWy7s2qAoHjzQDIuccMZjqWB4xGH9kQ7ahTAZZ
         ss0qG4deb45cH5MEvqsQU2o3VclECEama7/L1sbR/D1xWf6p1BrrQgHRTbiRRLSFakaR
         V3SefD660EfyPXObd2qiV0dwBjgyVMWbdAWzUH//M/XMEGUvDwnrnnzqSqZBqmVlYXi7
         LnN3gc9SfySZrOtzMFCmlHL5hOLiF+hB8ukM0T0GAE4Lz3kR4SUSdzczsD/JS8zUxBrZ
         hL+MoEtTvmdktxA6ShceO/mift1tvdb1v5hweoJrvrN/t3br26aD9JXVFotNEQHq2Hoi
         o6Dw==
X-Gm-Message-State: AOJu0YwCfsAOyyGbQIAZFwtZN+1d4RjztiZ0FAPicdUXJpu9VcEJk4a8
        EG/nVjjxYUnuUHgTHjkeo6x+NA5ELJU=
X-Google-Smtp-Source: AGHT+IEgWy41pC/eTi/gJfRGC3ZhDUWXjAXPp8I/V7gc3dlmhMC6N2x8SU2flh6zFey7F1gX8cPCtljTf8k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cac6:0:b0:5a7:b543:7f0c with SMTP id
 m189-20020a0dcac6000000b005a7b5437f0cmr65661ywd.10.1697825336424; Fri, 20 Oct
 2023 11:08:56 -0700 (PDT)
Date:   Fri, 20 Oct 2023 11:08:55 -0700
In-Reply-To: <20230911114347.85882-7-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com> <20230911114347.85882-7-cloudliang@tencent.com>
Message-ID: <ZTLCN8HW0jcD6LaN@google.com>
Subject: Re: [PATCH v4 6/9] KVM: selftests: Test consistency of CPUID with num
 of gp counters
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Add test to check if non-existent counters can be accessed in guest after
> determining the number of Intel generic performance counters by CPUID.
> When the num of counters is less than 3, KVM does not emulate #GP if
> a counter isn't present due to compatibility MSR_P6_PERFCTRx handling.
> Nor will the KVM emulate more counters than it can support.
> 
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../selftests/kvm/x86_64/pmu_counters_test.c  | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index fe9f38a3557e..e636323e202c 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -17,6 +17,11 @@
>  /* Guest payload for any performance counter counting */
>  #define NUM_BRANCHES		10
>  
> +static const uint64_t perf_caps[] = {
> +	0,
> +	PMU_CAP_FW_WRITES,
> +};

Put this on the stack in the one testcase that uses it.  Placing the array super
far away from its use makes it unnecessarily difficult to see that the testcase
is simply running with and without full-width writes.

>  static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>  						  void *guest_code)
>  {
> @@ -189,6 +194,85 @@ static void test_intel_arch_events(void)
>  	}
>  }
>  
> +static void __guest_wrmsr_rdmsr(uint32_t counter_msr, uint8_t nr_msrs,
> +				bool expect_gp)

Rather than pass in "expect_gp", compute it in here.  It's easy enough to explicitly
check for MSR_P6_PERFCTR[0|1]

> +{
> +	uint64_t msr_val;
> +	uint8_t vector;
> +
> +	vector = wrmsr_safe(counter_msr + nr_msrs, 0xffff);

Doing all this work to test _one_ MSR at a time is silly.  And I see no reason
to do only negative testing.  Sure, postive testing might be redundant with other
tests (I truly don't know), but _not_ hardcoding one-off tests often ends up
requiring less code, and almost always results in more self-documenting code.
E.g. it took me far too much staring to understand why the "no #GP" case expects
to read back '0'.

> +	__GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,
> +		       "Expected GP_VECTOR");

Print the actual vector!  And the MSR!  One of my pet peeves with KVM's tests is
not providing information on failure.  Having to hack a test or do interactive
debug just to figure out which MSR failed is *super* frustrating.

And I think it's worth providing a macro to handle the assertion+message, that
way it'll be easier to add more sub-tests, e.g. that the MSR can be written back
to '0'.

> +
> +	vector = rdmsr_safe(counter_msr + nr_msrs, &msr_val);
> +	__GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,
> +		       "Expected GP_VECTOR");
> +
> +	if (!expect_gp)
> +		GUEST_ASSERT_EQ(msr_val, 0);
> +
> +	GUEST_DONE();
> +}
> +
> +static void guest_rd_wr_gp_counter(void)
> +{
> +	uint8_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
> +	uint64_t perf_capabilities = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> +	uint32_t counter_msr;
> +	bool expect_gp = true;
> +
> +	if (perf_capabilities & PMU_CAP_FW_WRITES) {
> +		counter_msr = MSR_IA32_PMC0;
> +	} else {
> +		counter_msr = MSR_IA32_PERFCTR0;
> +
> +		/* KVM drops writes to MSR_P6_PERFCTR[0|1]. */
> +		if (nr_gp_counters == 0)
> +			expect_gp = false;
> +	}
> +
> +	__guest_wrmsr_rdmsr(counter_msr, nr_gp_counters, expect_gp);
> +}
> +
> +/* Access the first out-of-range counter register to trigger #GP */
> +static void test_oob_gp_counter(uint8_t eax_gp_num, uint64_t perf_cap)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_rd_wr_gp_counter);
> +
> +	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_GP_COUNTERS,
> +				eax_gp_num);
> +	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, perf_cap);
> +
> +	run_vcpu(vcpu);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +static void test_intel_counters_num(void)
> +{
> +	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
> +	unsigned int i;
> +
> +	TEST_REQUIRE(nr_gp_counters > 2);

This is beyond silly.  Just iterate over all possible counter values.  Again,
hardcoding values is almost never the best way to do things.

> +
> +	for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
> +		/*
> +		 * For compatibility reasons, KVM does not emulate #GP
> +		 * when MSR_P6_PERFCTR[0|1] is not present, but it doesn't
> +		 * affect checking the presence of MSR_IA32_PMCx with #GP.
> +		 */
> +		test_oob_gp_counter(0, perf_caps[i]);
> +		test_oob_gp_counter(2, perf_caps[i]);
> +		test_oob_gp_counter(nr_gp_counters, perf_caps[i]);
> +
> +		/* KVM doesn't emulate more counters than it can support. */
> +		test_oob_gp_counter(nr_gp_counters + 1, perf_caps[i]);

Hmm, so I think we should avoid blindly testing undefined MSRs.  I don't disagree
that expecting #GP is reasonable, but I don't think this is the right place to
test for architecturally undefined MSRs.  E.g. if Intel defines some completely
unrelated MSR at 0xc3 or 0x4c9 then this test will fail.

Rather than assume anything about "nr_gp_counters + 1", I think we should test up
to what Intel has architecturally defined, e.g. define the max number of counters
and then pass that in as the "possible" counters:

#define GUEST_ASSERT_PMC_MSR_ACCESS(insn, msr, expect_gp, vector)		\
__GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
	       "Expected %s on " #insn "(0x%x), got vector %u",			\
	       expect_gp ? "#GP" : "no fault", msr, vector)			\

static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
				 uint8_t nr_counters, uint32_t or_mask)
{
	uint8_t i;

	for (i = 0; i < nr_possible_counters; i++) {
		const uint32_t msr = base_msr + i;

		/*
		 * Fixed counters are supported if the counter is less than the
		 * number of enumerated contiguous counters *or* the counter is
		 * explicitly enumerated in the supported counters mask.
		 */
		const bool expect_success = i < nr_counters || (or_mask & BIT(i));

		/*
		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
		 * unsupported, i.e. doesn't #GP and reads back '0'.
		 */
		const uint64_t expected_val = expect_success ? 0xffff : 0;
		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
				       msr != MSR_P6_PERFCTR1;
		uint8_t vector;
		uint64_t val;

		vector = wrmsr_safe(msr, 0xffff);
		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);

		vector = rdmsr_safe(msr, &val);
		GUEST_ASSERT_PMC_MSR_ACCESS(RDMSR, msr, expect_gp, vector);

		/* On #GP, the result of RDMSR is undefined. */
		if (!expect_gp)
			__GUEST_ASSERT(val == expected_val,
				       "Expected RDMSR(0x%x) to yield 0x%lx, got 0x%lx",
				       msr, expected_val, val);

		vector = wrmsr_safe(msr, 0);
		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
	}
}
