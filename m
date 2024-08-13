Return-Path: <kvm+bounces-24058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C49D2950C92
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 20:56:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 097B8B232BB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DECE1A3BD0;
	Tue, 13 Aug 2024 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XaTkQaYH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDE91A3BA8
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723575361; cv=none; b=FHi2BKHrQVtDbCLiIrD6tAdWtBeX20DgZr2o+uVca3wecIu7QY5TjgpBEhdEv+HZTXdMIrcUixAdChUdgrEbaax4eD7Bje+A5/8ppU8RyqHz+6QIuhKs3yrBD1QZvaG02L0gfQmtD+tEpH3gW5bj6uIX4mMszhli+zK4mnqBRp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723575361; c=relaxed/simple;
	bh=uz4Lk1CQYACULUAwm7tJvpDL6knHk0jFHH5VOVVHDis=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jFLbAD2Z7l/3/TR/ykmmNp7XbfHJEzt0krf+O2KEm3G7q/1dCwfMDxvEQu6DIKR3ZncCJy7ScruRgmj1yBvwBAQc9UztF65LsQEXNaIQM47GWC8J/X5zhv0eRAEiDa8UCe5Y5HfYg2qmFKxdXcDSlVlY1kuM9/OA9jCrNzfEShY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XaTkQaYH; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d392d311cso5150848b3a.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 11:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723575359; x=1724180159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YIwyRI9MZtZeo1mI2C/miZzSeV2UjG9Vo3bAQzKw5cU=;
        b=XaTkQaYHI3Lf+Wca8vbSkhLDvPeG5SW811oSsXIl8fwWlNstxbbRn7pLBA7WvLdlzV
         0GguQ/2AmlLoVp3O39CBe/GL5kUJC0R8qYuR4/hOrISOzxp/j+aq1ZFHYbk03FrfJdon
         L6tEZHALlU2o9pd34SqoJO5ivVUpMgw2dbV+DXnkGO1pDF5xhNYmbYtJD+CBD3MtWDAP
         pErEMhl3ihW/C01nC3Kov+NiD6ARCEQkh9NrpV1W7JuazXhSbDH8NLKqiECGtHkiii8s
         H/Ns0PY9LMnnJ3HL8BnSfNeEk46qqETmGjPGqNcPcDricz63v9xuPJrHUv6jyjuALnXW
         9dMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723575359; x=1724180159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YIwyRI9MZtZeo1mI2C/miZzSeV2UjG9Vo3bAQzKw5cU=;
        b=sSzFiKE20jniUS6povLshONuVxVZF2AuncUKprQD1iDtF+VkYyqdxQ15vlo5dWtZcx
         EGivIZnHgO7INBxZUY8sDKK4EA3sGRqEyi+pLfyIgp/Uo4c+I+dHrVp1N/2HEcBC+wYK
         G5CjOv8/YC3ZZsH2YOo+j17608+5EPUZLcEzD3uiJq/yvM919kUs4EPV5CcG60wZMUik
         dqOe1dL1ZSwS9eXoL0GNhq2ZpgIc+OImMqwGdIvfRzAaQ69zpwiHXMTEo7K+n1G3hCKl
         fD1LBWU6TZMDYK7KzaUVobdqL+aDV7e3SRKLQfZbsR0A0l1wyTROqUKGK6SP/us9Tl0l
         /ivg==
X-Gm-Message-State: AOJu0YwkeggcOrp90vHLX9yBu6T8B0n4m17otgpHBaGLbTdFxET9XgeL
	x1PLYZqzb9pHzvdDTEMFGLAmvrWKb2+TO2vSa5rJRxkb9e75vsZUcZdQBrRiNWiCLs2slyqcmp2
	BGg==
X-Google-Smtp-Source: AGHT+IE4Y4KFJ5Upvg/w8mkmeB/IUJyaWk9lTVg3XEnbN4gS5RvAHV9sOvm7no7vasckUgUymsBZfgODW9E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4d03:b0:704:3140:5a94 with SMTP id
 d2e1a72fcca58-7126710c15bmr7017b3a.2.1723575358775; Tue, 13 Aug 2024 11:55:58
 -0700 (PDT)
Date: Tue, 13 Aug 2024 11:55:57 -0700
In-Reply-To: <20240522001817.619072-6-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-6-dwmw2@infradead.org>
Message-ID: <ZrusPRKEuvcO11m0@google.com>
Subject: Re: [RFC PATCH v3 05/21] KVM: selftests: Add KVM/PV clock selftest to
 prove timer correction
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
> The guest the records a singular TSC reference point in time and uses it to
            ^^^^
            then

> calculate 3 KVM clock values utilizing the 3 recorded PVTI prior. Let's
> call each clock value CLK[0-2].
> 
> In a perfect world CLK[0-2] should all be the same value if the KVM clock
> & TSC relationship is preserved across the LU/LM (or faked in this test),
> however it is not.
> 
> A delta can be observed between CLK0-CLK1 due to KVM recalculating the PVTI
> (and the inaccuracies associated with that). A delta of ~3500ns can be
> observed if guest TSC scaling to half host TSC frequency is also enabled,
> where as without scaling this is observed at ~180ns.

It'd be helpful to explain why TSC scaling results in a larger drift.  I'm by no
means a clock expert, but I've likely stared at this code more than most and it's
not obvious to me why scaling is problematic.  If I thought hard maybe I could
figure it out, but it's been an -ENOCOFFE sort of week so far, so I wouldn't bet
on it :-)

> +static void trigger_pvti_update(vm_paddr_t pvti_pa)
> +{
> +	/*
> +	 * We need a way to trigger KVM to update the fields

Please avoid "we", it's unnecessarily confusing as there are too many possible
subjects that "we" could apply to.  And please use the "full" 80 characters for
comments, there's no reason to wrap more aggressively.  E.g.

	/*
	 * Toggle between KVM's old and new system time methods to coerce KVM
	 * into updating the fields in the PV time info struct.
	 */

> +	 * in the PV time info. The easiest way to do this is
> +	 * to temporarily switch to the old KVM system time
> +	 * method and then switch back to the new one.
> +	 */
> +	wrmsr(MSR_KVM_SYSTEM_TIME, pvti_pa | KVM_MSR_ENABLED);
> +	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
> +}
> +
> +static void guest_code(vm_paddr_t pvti_pa)
> +{
> +	struct pvclock_vcpu_time_info *pvti_va =
> +		(struct pvclock_vcpu_time_info *)pvti_pa;

Casting to "void *" will let this vit on a single line.  Though I don't see any
reason to take a vm_paddr_t, the infrastructure doesn't validate the arg types.

> +	struct pvclock_vcpu_time_info pvti_boot;
> +	struct pvclock_vcpu_time_info pvti_uncorrected;
> +	struct pvclock_vcpu_time_info pvti_corrected;
> +	uint64_t cycles_boot;
> +	uint64_t cycles_uncorrected;
> +	uint64_t cycles_corrected;
> +	uint64_t tsc_guest;
> +
> +	/*
> +	 * Setup the KVMCLOCK in the guest & store the original

s/&/and

And wrap less aggressively here too.

> +	 * PV time structure that is used.
> +	 */
> +	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
> +	pvti_boot = *pvti_va;
> +	GUEST_SYNC(STAGE_FIRST_BOOT);
> +
> +	/*
> +	 * Trigger an update of the PVTI, if we calculate
> +	 * the KVM clock using this structure we'll see
> +	 * a delta from the TSC.

Too many pronouns.  Maybe this?

	/*
	 * Trigger an update of the PVTI and snapshot the time, which at this
	 * point is uncorrected, i.e. have a 

> +	 */
> +	trigger_pvti_update(pvti_pa);
> +	pvti_uncorrected = *pvti_va;
> +	GUEST_SYNC(STAGE_UNCORRECTED);
> +
> +	/*
> +	 * The test should have triggered the correction by this
> +	 * point in time. We have a copy of each of the PVTI structs
> +	 * at each stage now.
> +	 *
> +	 * Let's sample the timestamp at a SINGLE point in time and
> +	 * then calculate what the KVM clock would be using the PVTI
> +	 * from each stage.
> +	 *
> +	 * Then return each of these values to the tester.
> +	 */

	/*
	 * Snapshot the corrected time (the host does KVM_SET_CLOCK_GUEST when
	 * handling STAGE_UNCORRECTED).
	 */  

> +	pvti_corrected = *pvti_va;

	/*
	 * Sample the timestamp at a SINGLE point in time, and then calculate
	 * the effective KVM clock using the PVTI from each stage, and sync all
	 * values back to the host for verification.
	 */


On that last point though, why sync things back to the host?  The verification
can be done in the guest via __GUEST_ASSERT(), that way there are few magic
fields being passed around, e.g. no need for uc.args[2..4].

> +	tsc_guest = rdtsc();
> +
> +	cycles_boot = __pvclock_read_cycles(&pvti_boot, tsc_guest);
> +	cycles_uncorrected = __pvclock_read_cycles(&pvti_uncorrected, tsc_guest);
> +	cycles_corrected = __pvclock_read_cycles(&pvti_corrected, tsc_guest);
> +
> +	GUEST_SYNC_ARGS(STAGE_CORRECTED, cycles_boot, cycles_uncorrected,
> +			cycles_corrected, 0);
> +}

> +
> +static void run_test(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +{
> +	struct pvclock_vcpu_time_info pvti_before;
> +	uint64_t before, uncorrected, corrected;
> +	int64_t delta_uncorrected, delta_corrected;
> +	struct ucall uc;
> +	uint64_t ucall_reason;
> +
> +	/* Loop through each stage of the test. */
> +	while (true) {
> +
> +		/* Start/restart the running vCPU code. */
> +		vcpu_run(vcpu);
> +		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> +
> +		/* Retrieve and verify our stage. */
> +		ucall_reason = get_ucall(vcpu, &uc);
> +		TEST_ASSERT(ucall_reason == UCALL_SYNC,
> +			    "Unhandled ucall reason=%lu",
> +			    ucall_reason);

Or just TEST_ASSERT_EQ().

> +		/* Run host specific code relating to stage. */
> +		switch (uc.args[1]) {
> +		case STAGE_FIRST_BOOT:
> +			/* Store the KVM clock values before an update. */
> +			vcpu_ioctl(vcpu, KVM_GET_CLOCK_GUEST, &pvti_before);
> +
> +			/* Sleep for a set amount of time to increase delta. */
> +			sleep(5);

This is probably worth plumbing in via command line, e.g. so that the test can
run with a shorter sleep() by default while also allowing users to stress things
by running with longer delays.  Ideally, the default sleep() would be as short
as possible while still detecting ~100% of bugs.

> +			break;
> +
> +		case STAGE_UNCORRECTED:
> +			/* Restore the KVM clock values. */
> +			vcpu_ioctl(vcpu, KVM_SET_CLOCK_GUEST, &pvti_before);
> +			break;
> +
> +		case STAGE_CORRECTED:
> +			/* Query the clock information and verify delta. */
> +			before = uc.args[2];
> +			uncorrected = uc.args[3];
> +			corrected = uc.args[4];
> +
> +			delta_uncorrected = before - uncorrected;
> +			delta_corrected = before - corrected;
> +
> +			pr_info("before=%lu uncorrected=%lu corrected=%lu\n",
> +				before, uncorrected, corrected);
> +
> +			pr_info("delta_uncorrected=%ld delta_corrected=%ld\n",
> +				delta_uncorrected, delta_corrected);
> +
> +			TEST_ASSERT((delta_corrected <= 1) && (delta_corrected >= -1),
> +				    "larger than expected delta detected = %ld", delta_corrected);
> +			return;
> +		}
> +	}
> +}
> +
> +static void configure_pvclock(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +{
> +	unsigned int gpages;

I'd prefer something like nr_pages
> +
> +	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, KVMCLOCK_SIZE);
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +				    KVMCLOCK_GPA, 1, gpages, 0);
> +	virt_map(vm, KVMCLOCK_GPA, KVMCLOCK_GPA, gpages);
> +
> +	vcpu_args_set(vcpu, 1, KVMCLOCK_GPA);

This is somewhat silly.  If you're going to hardcode the address, just use the
#define in both the host and the guest.  Then this helper doesn't need to take
a vCPU and could be more easily expanded to multiple vCPUs (if there's a good
reason to do so).

> +}
> +
> +static void configure_scaled_tsc(struct kvm_vcpu *vcpu)
> +{
> +	uint64_t tsc_khz;
> +
> +	tsc_khz =  __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
> +	pr_info("scaling tsc from %ldKHz to %ldKHz\n", tsc_khz, tsc_khz / 2);
> +	tsc_khz /= 2;

There's nothing special about scaling to 50%, correct?  So rather than hardcode
a single testcase, enumerate over a variety of frequencies, and specifically
cross the 32-bit boundary, e.g. 1Ghz - 5Ghz at 500Mhz jumps or something, plus
the host's native unscaled value.

> +	vcpu_ioctl(vcpu, KVM_SET_TSC_KHZ, (void *)tsc_khz);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	bool scale_tsc;
> +
> +	scale_tsc = argc > 1 && (!strncmp(argv[1], "-s", 3) ||
> +				 !strncmp(argv[1], "--scale-tsc", 10));

I think it's worth adding proper argument parsing, e.g. to print a help.  The
boilerplate is annoying, but it'll payoff in the long run as I suspect we'll end
up with more params, e.g. to configure the sleep/delay, the min/max frequency,
the intervals between frequencies, etc.

> +
> +	TEST_REQUIRE(sys_clocksource_is_based_on_tsc());
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	configure_pvclock(vm, vcpu);
> +
> +	if (scale_tsc)
> +		configure_scaled_tsc(vcpu);
> +
> +	run_test(vm, vcpu);
> +
> +	return 0;
> +}
> -- 
> 2.44.0
> 

