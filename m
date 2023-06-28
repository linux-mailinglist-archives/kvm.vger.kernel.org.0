Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A947419D4
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 22:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjF1UoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 16:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjF1UoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 16:44:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B051FC2
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 13:43:59 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b802df5298so3044125ad.3
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 13:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687985038; x=1690577038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hyrs7D/yVCqnGmms3W/NS+8wB+cHPGghwvrqi5p71bU=;
        b=ZSEe2WsVWnVaM0Hb2KxN6nPxO8GCkQuVzewAUfmrPZ9VO9qABstQsHyR6r6mhK34Zb
         xL00uuSx27g+OeN646hx9LI3oLHh9Jqn4c6IOMypXwF3tMAraoIdtqQowXk2DoF2WD2I
         1lTU6oF5v3ylKXyYvkOXr1oys/PjFWkTlH3U34rxEMEf2CoMUZic/hYIKMYiqdgKMU0o
         jIJ9l6oRoHn//nl2S7B/qVTb2UxB3MwZVL6kR8ZzC556r0Savl7RKEks+mCn8/xXeNrP
         QRq/08Il9ZEWVoWFLsxdP+iuTzdrouTm1rViN6fxOtJ7udeeh27/hNvzSMa9YnT9b7Eo
         wCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687985038; x=1690577038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hyrs7D/yVCqnGmms3W/NS+8wB+cHPGghwvrqi5p71bU=;
        b=ld8CvYtY073rXMYcZbVjBGikyXufirMjiBHDrNvE2TL1bJge06tpJeVNT7wtYN/Ihr
         UW4sZeqZfi38TsIjZbC9PcLdMSr8rFvJmQHdwsRT6nC7SFUIrNIkUBsXorAulYpSD0fZ
         TtNXZ7L2zjnLaplKqpJ7aa3yJjORp7SgrYuOIMdc//HBehxPA/QNLd+XbaDEaXZrXhxG
         UpB0xK9jZwMFaKTDyoAWsEVaOp/a5bAixLG3pg6Oi+89SA5k9V3jIfuZ71bwoeja5ar2
         cbdqnHOKfvAPVhjhRPgnR5WyGkmz0N5SFnT/b6sA5Q1XjEw/0hc9fbPKi6lL0jMt1Ugp
         zblA==
X-Gm-Message-State: AC+VfDxrIz+8MCF04OrMZIJ9K8rjyiTccweG0H5M72Fwf5ymrLx3Ifl8
        e9q8NSFF71xq4/JIq+U3p+8ddSBeOEI=
X-Google-Smtp-Source: ACHHUZ4ooop6YX4qVFv0XEOPUIxSsEQYy7RRTMMEQiDRRc8qR9KFdP203aFUSW2PGvi2NH7X5Ei86S9q464=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1001:b0:1b5:2c0b:fa72 with SMTP id
 a1-20020a170903100100b001b52c0bfa72mr2147589plb.12.1687985038669; Wed, 28 Jun
 2023 13:43:58 -0700 (PDT)
Date:   Wed, 28 Jun 2023 13:43:57 -0700
In-Reply-To: <20230530134248.23998-4-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230530134248.23998-1-cloudliang@tencent.com> <20230530134248.23998-4-cloudliang@tencent.com>
Message-ID: <ZJybjcyiLQVkSHMC@google.com>
Subject: Re: [PATCH v2 3/8] KVM: selftests: Test Intel PMU architectural
 events on gp counters
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Jinrong Liang wrote:
> +/* Guest payload for any performance counter counting */
> +#define NUM_BRANCHES 10
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
> +static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint64_t *ucall_arg)
> +{
> +	struct ucall uc;
> +
> +	vcpu_run(vcpu);
> +	switch (get_ucall(vcpu, &uc)) {
> +	case UCALL_SYNC:
> +		*ucall_arg = uc.args[1];
> +		break;
> +	case UCALL_DONE:
> +		break;
> +	default:
> +		TEST_ASSERT(false, "Unexpected exit: %s",
> +			    exit_reason_str(vcpu->run->exit_reason));

TEST_FAIL()

> +	}
> +	return uc.cmd;
> +}
> +
> +static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,

Unless I'm mistaken, this isn't specific to arch events.  And with a bit of
massaging, it doesn't need to be Intel specific.  Typically we try to avoid
speculatively creating infrastructure, but in this case we *know* AMD has vPMU
support, and we *know* from KVM-Unit-Tests that accounting for the differences
between MSRs on Intel vs. AMD is doable, so we should write code with an eye
toward supporting both AMD and Intel.

And then we can avoid having to prefix so many functions with "intel", e.g. this
can be something like

  static void guest_measure_loop()

or whatever.

> +				       uint32_t ctr_base_msr, uint64_t evt_code)
> +{
> +	uint32_t global_msr = MSR_CORE_PERF_GLOBAL_CTRL;
> +	unsigned int i;
> +
> +	for (i = 0; i < max_gp_num; i++) {
> +		wrmsr(ctr_base_msr + i, 0);
> +		wrmsr(MSR_P6_EVNTSEL0 + i, EVENTSEL_OS | EVENTSEL_EN | evt_code);
> +		if (version > 1)
> +			wrmsr(global_msr, BIT_ULL(i));
> +
> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
> +
> +		if (version > 1)
> +			wrmsr(global_msr, 0);
> +
> +		GUEST_SYNC(_rdpmc(i));
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void test_arch_events_cpuid(struct kvm_vcpu *vcpu, uint8_t evt_vector,

"vector" is confusing, as "vector" usually refers to a vector number, e.g. for
IRQs and exceptions.  This is the _length_ of a so called vector.  I vote to ignore
the SDM's use of "vector" in this case and instead call it something like
arch_events_bitmap_size.  And then arch_events_unavailable_mask?

> +				   uint8_t unavl_mask, uint8_t idx)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	uint32_t ctr_msr = MSR_IA32_PERFCTR0;
> +	bool is_supported;
> +	uint64_t counter_val = 0;
> +
> +	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
> +	entry->eax = (entry->eax & ~EVT_LEN_MASK) |
> +		(evt_vector << EVT_LEN_OFS_BIT);

EVT_LEN_OFS_BIT can be a KVM_x86_PROPERTY.  And please also add a helper to set
properties, the whole point of the FEATURE and PROPERTY frameworks is to avoid
open coding CPUID manipulations.  E.g. 

static inline void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
					   struct kvm_x86_cpu_property property,
					   uint32_t value)
{
	...
}

> +	entry->ebx = (entry->ebx & ~EVENTS_MASK) | unavl_mask;
> +	vcpu_set_cpuid(vcpu);
> +
> +	if (vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
> +		ctr_msr = MSR_IA32_PMC0;

This can be done in the guest, no?

> +
> +	/* Arch event x is supported if EBX[x]=0 && EAX[31:24]>x */
> +	is_supported = !(entry->ebx & BIT_ULL(idx)) &&
> +		(((entry->eax & EVT_LEN_MASK) >> EVT_LEN_OFS_BIT) > idx);

Please add a helper for this.

> +
> +	vcpu_args_set(vcpu, 4, X86_INTEL_PMU_VERSION, X86_INTEL_MAX_GP_CTR_NUM,
> +		      ctr_msr, arch_events[idx]);
> +
> +	while (run_vcpu(vcpu, &counter_val) != UCALL_DONE)
> +		TEST_ASSERT(is_supported == !!counter_val,
> +			    "Unavailable arch event is counting.");
> +}
> +
> +static void intel_check_arch_event_is_unavl(uint8_t idx)
> +{
> +	uint8_t eax_evt_vec, ebx_unavl_mask, i, j;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	/*
> +	 * A brute force iteration of all combinations of values is likely to
> +	 * exhaust the limit of the single-threaded thread fd nums, so it's
> +	 * tested here by iterating through all valid values on a single bit.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(arch_events); i++) {
> +		eax_evt_vec = BIT_ULL(i);
> +		for (j = 0; j < ARRAY_SIZE(arch_events); j++) {
> +			ebx_unavl_mask = BIT_ULL(j);
> +			vm = pmu_vm_create_with_one_vcpu(&vcpu,
> +							 intel_guest_run_arch_event);
> +			test_arch_events_cpuid(vcpu, eax_evt_vec,
> +					       ebx_unavl_mask, idx);
> +
> +			kvm_vm_free(vm);
> +		}
> +	}
> +}
> +
> +static void intel_test_arch_events(void)
> +{
> +	uint8_t idx;
> +
> +	for (idx = 0; idx < ARRAY_SIZE(arch_events); idx++) {
> +		/*
> +		 * Given the stability of performance event recurrence,
> +		 * only these arch events are currently being tested:
> +		 *
> +		 * - Core cycle event (idx = 0)
> +		 * - Instruction retired event (idx = 1)
> +		 * - Reference cycles event (idx = 2)
> +		 * - Branch instruction retired event (idx = 5)
> +		 *
> +		 * Note that reference cycles is one event that actually cannot
> +		 * be successfully virtualized.
> +		 */
> +		if (idx > 2 && idx != 5)

As request in a previous patch, use enums, then the need to document the magic
numbers goes away.

> +			continue;
> +
> +		intel_check_arch_event_is_unavl(idx);
> +	}
> +}
> +
> +static void intel_test_pmu_cpuid(void)
> +{
> +	intel_test_arch_events();

Either put the Intel-specific TEST_REQUIRE()s in here, or open code the calls.
Adding a helper and then splitting code across the helper and its sole caller is
unnecessary.

> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> +
> +	if (host_cpu_is_intel) {

Presumably AMD will be supported at some point, but until then, this needs to be

	TEST_REQUIRE(host_cpu_is_intel);

> +		TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
> +		TEST_REQUIRE(X86_INTEL_PMU_VERSION > 0);
> +		TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
> +
> +		intel_test_pmu_cpuid();
> +	}
> +
> +	return 0;
> +}
> -- 
> 2.31.1
> 
