Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511E87D5BCD
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 21:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344261AbjJXTtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 15:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbjJXTto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 15:49:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495D5111
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 12:49:42 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59b5a586da6so1223457b3.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 12:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698176981; x=1698781781; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eq9Uw3bJ9CtDZfbgv9i9x/0b/vFeu6BK0ERlK4TBVC8=;
        b=bEoehSSl1/Oazt0nWtpDXR0SeUSEPA9x3oWcqJBOq8HjPeZOPN0LNRuKdF5ApzKkRB
         BELfpZiXzOOy4+1Bh+YQ2W1oTMrzMfx5KnYNiM4eJ2Lno3DSLikRL59Gf3mG0R197Opw
         5VXJx7ZpWaeuo13Mt9SksSsOMxNgrrqhYkxg1XMIAI/oT2FRgOQ037KgEY/yxdRthdIF
         dn2EeVyQerJ7wqzVL4P05ri7+JFwQEMNhruPCzWNVBrCD5yOsF8gXqhaNEmHgUFLHIQP
         XtSCOd8Z3po7vaDAiYz+IZGvP0S+d7WrtT0y9ouusALdTyhaB4UZjioVheGLwJ2hjZ/4
         Y56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698176981; x=1698781781;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eq9Uw3bJ9CtDZfbgv9i9x/0b/vFeu6BK0ERlK4TBVC8=;
        b=ozNbKJqj5D/NmFLHY9BZAvwDspNB0LXx4D6Iuhhci+e4qIovTN62JsqdYUVX1meEKI
         VoBq9aiAicoofPB/JOYJUz3IjR2eT+ZIaEdoJEV5A+GfkDS764FT+NOV6yuwGLxqFV9p
         QcZUd4y0sVHmXoHlMA7+23BkHK83STkug1yhBWIcBV5r5lhjiOzMvbxQkcH3UBCDbygl
         zD1gvtD9rOyYLtSexR5kchx6pBSzMR4zDqirVXhqJbuYFddGyheHxgTaooLQGUPM6y8e
         pRmKgjviEuoQh8JUBh4zuzwfdRCTZGjJPr/9Co0RbtjQTeI9V1QwbRVl8KteFrk+20cA
         MBfw==
X-Gm-Message-State: AOJu0YzzwqxY00GkC4Q7C4pQPlEM5zMpil3r7y9+k/3jmjz2qh/LWgCp
        D2ZvXOT7DFWlkgG59LmCRd1Jw0lsyBQ=
X-Google-Smtp-Source: AGHT+IFnTbI6l93X7NfKGbQRYo+BNxCrWauKr/IGIM3luNTLtn9ZWkQHbLp4A+5Sm5uWobg8ccbIEcj2d+g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7815:0:b0:59b:b0b1:d75a with SMTP id
 t21-20020a817815000000b0059bb0b1d75amr478778ywc.4.1698176981543; Tue, 24 Oct
 2023 12:49:41 -0700 (PDT)
Date:   Tue, 24 Oct 2023 12:49:40 -0700
In-Reply-To: <20231024002633.2540714-9-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com> <20231024002633.2540714-9-seanjc@google.com>
Message-ID: <ZTgf1Cutah5VQp_q@google.com>
Subject: Re: [PATCH v5 08/13] KVM: selftests: Test Intel PMU architectural
 events on gp counters
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023, Sean Christopherson wrote:
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
> +
> +		if (pmu_is_intel_event_stable(idx))
> +			GUEST_ASSERT_EQ(this_pmu_has(event), !!_rdpmc(i));
> +
> +		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
> +		      !ARCH_PERFMON_EVENTSEL_ENABLE |
> +		      intel_pmu_arch_events[idx]);
> +		wrmsr(counter_msr + i, 0);
> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
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

Looking at this again, testing guest PMU version 1 is practically impossible
because this testcase doesn't force the guest PMU version.  I.e. unless I'm
missing something, this requires old hardware or running in a VM with its PMU
forced to '1'.

And if all subtests use similar inputs, the common configuration can be shoved
into pmu_vm_create_with_one_vcpu().

It's easy enough to fold test_intel_arch_events() into test_intel_counters(),
which will also provide coverage for running with full-width writes enabled.  The
only downside is that the total runtime will be longer.

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

There's no need to iterate over each event in the host, we can simply add a wrapper
for guest_measure_loop() in the guest.  That'll be slightly faster since it won't
require creating and destroying a VM for every event.

> +		/*
> +		 * A brute force iteration of all combinations of values is
> +		 * likely to exhaust the limit of the single-threaded thread
> +		 * fd nums, so it's test by iterating through all valid
> +		 * single-bit values.
> +		 */
> +		for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {

This is flawed/odd.  'i' becomes arch_events_bitmap_size, i.e. it's a length,
but the length is computed byt BIT(i).  That's nonsensical and will eventually
result in undefined behavior.  Oof, that'll actually happen sooner than later
because arch_events_bitmap_size is only a single byte, i.e. when the number of
events hits 9, this will try to shove 256 into an 8-bit variable.

The more correct approach would be to pass in 0..NR_INTEL_ARCH_EVENTS inclusive
as the size.  But I think we should actually test 0..length+1, where "length" is
the max of the native length and NR_INTEL_ARCH_EVENTS, i.e. we should verify KVM
KVM handles a size larger than the native length.

> +			for (j = 0; j < NR_INTEL_ARCH_EVENTS; j++)
> +				test_arch_events_cpuid(i, j, idx);

And here, I think it makes sense to brute force all possible values for at least
one configuration.  There aren't actually _that_ many values, e.g. currently it's
64 (I think).  E.g. test the native PMU version with the "full" length, and then
test single bits with varying lengths.

I'll send a v6 later this week.
