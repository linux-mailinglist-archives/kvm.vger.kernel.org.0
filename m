Return-Path: <kvm+bounces-19281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C52A902DC6
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 02:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3089B1C2132B
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 00:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C1CB662;
	Tue, 11 Jun 2024 00:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ii0A2SFr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5C26FC5
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 00:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718067091; cv=none; b=nuMNVV/T7SctLI9J5A2+z7LYc/I0D2gM8kHDDm0GTCL9137Neo1jjTx6iHTa22u2Z6zHPQFZssSJ2hqhQ3stJs9X23eyJJjvrPKdNLo1B5FKnBV69WMeeZxuiyte6C5bUoHNlaxp/fAJuYXdS4E47m1WPBwioCI+0HpcoexE3Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718067091; c=relaxed/simple;
	bh=4tGsZXuoCnAYaQks7DUaHqHmrE2xVhNvtR6tBHdIssQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mmwWOkrLJZjYLWoovQAq3y+J7wrSi5MttSsGEllOBcho8ZSMUbCtEZb8pYiZNQ6edfevl4O9k7IYY4KLaqycz9zjEU4F7vaaL6MxpWiPOpAHykwR8gtMrxvG+Dl+sBiAe4Zh6yz/Fj1GalyqgRCIa3K8FcEbrAaT4Qgi2j8W9/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ii0A2SFr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c2dd66e05dso494286a91.0
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 17:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718067089; x=1718671889; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ngaY7gpQRpIirX5s53yfK0/qc/j88qyKxzdVZ+iIXkA=;
        b=Ii0A2SFr7vXeUEFqjuMnASfs96nwEXd4dmzN59Gj0oFdZ4d6D+qLZvPwZEWjM7XRII
         WVBLaPRxF7lH6t08Gl90ltosKAaU5IlD/Q/85VnFXUAoT3viJjmMHbi/rg83oupWW5sj
         ClxMpV7OuV8hlBaVp/m8DhzYXSYVYvtpHQdA2MtbyyfegkTGvDBvuZ7Rmxme0anevB12
         dzTNIazbg6djOjD7BXVA7J+uOAJpL9qNvhA0+EX+1W3H+whGgq8J6QB02EHH9CgZ9Kt7
         WzejXlNjSxAlLqYkAkJJbqrhqUg/T6wcOS6ZF4rdQ6bore33ItQKUSZWbc/sT18JQYVg
         pkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718067089; x=1718671889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ngaY7gpQRpIirX5s53yfK0/qc/j88qyKxzdVZ+iIXkA=;
        b=CX62oRyhC2bOO2u0AFrCFnq9Q6EeXdMzAErGhx79QbG+vLBBD/gHlU7eeZltUy3TYT
         5s6ohYsR7hIhL3EhdgeZmuoXvSUc7EieVxrBgFLlbpFSJyosLskCnN95+zG/jvQkpjBq
         UnR5QfVirQjwXZfg4mglSNVVkjmeQwHA4lL1TxtExSkm2BlNXhjs05BDV3bwPXx65MG1
         tr0xxey8le0/mWtrn3K5ZG5gP29Sa9p4e+Aapt4jx7fqZG2J8Xch39TtNG6w6zcsZv8l
         cPlMbhCVYXSwWhdv62FD5421XSQx1Nf47tlSeSAqVsN/vsKlWja8jIKz+O7MQCFugWZZ
         dQRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0V8y2G3V3VSBJI4BGNQWIwjESBoSKY3pLWpuKEpHyGb1YQd5piBD+qBslPhbE8AUbCe3ukFSGr93W0Q4tAZTeIYT0
X-Gm-Message-State: AOJu0YwfmeaQ3FYsUzgsY8KsumEPzoHhWcOCM+u8jKYzY3SLmGlyyIe4
	aTZNNa7keRV1aONSGsroIDpQaRX0NmAPyGJBuVFdRnypDkMHLROV3QKQvpHbKjzeOntP/31xjGZ
	fbA==
X-Google-Smtp-Source: AGHT+IHmfJ/VJwnV/Ts9WgwV+Kr1dfTAHQeRT1T5YAUGH65g5e5V/RyAuMx5Gd4OsNR/LuxIsWYovt4RqT8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:bb08:b0:2c2:dd50:a0b5 with SMTP id
 98e67ed59e1d1-2c2dd50a22bmr104092a91.0.1718067088517; Mon, 10 Jun 2024
 17:51:28 -0700 (PDT)
Date: Mon, 10 Jun 2024 17:51:26 -0700
In-Reply-To: <09b11d24e957056c621e3bf2d6c9d78bd4f7461b.1718043121.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1718043121.git.reinette.chatre@intel.com> <09b11d24e957056c621e3bf2d6c9d78bd4f7461b.1718043121.git.reinette.chatre@intel.com>
Message-ID: <ZmefjsFArRSnC71I@google.com>
Subject: Re: [PATCH V8 2/2] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 10, 2024, Reinette Chatre wrote:
> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> new file mode 100644
> index 000000000000..602cec91d8ee
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> @@ -0,0 +1,219 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024 Intel Corporation
> + *
> + * Verify KVM correctly emulates the APIC bus frequency when the VMM configures
> + * the frequency via KVM_CAP_X86_APIC_BUS_CYCLES_NS.  Start the APIC timer by
> + * programming TMICT (timer initial count) to the largest value possible (so
> + * that the timer will not expire during the test).  Then, after an arbitrary
> + * amount of time has elapsed, verify TMCCT (timer current count) is within 1%
> + * of the expected value based on the time elapsed, the APIC bus frequency, and
> + * the programmed TDCR (timer divide configuration register).
> + */
> +
> +#include "apic.h"
> +#include "test_util.h"
> +
> +/*
> + * Pick 25MHz for APIC bus frequency. Different enough from the default 1GHz.
> + * User can override via command line.
> + */
> +unsigned long apic_hz = 25 * 1000 * 1000;

static, and maybe a uint64_t to match the other stuff?

> +/*
> + * Possible TDCR values with matching divide count. Used to modify APIC
> + * timer frequency.
> + */
> +struct {
> +	uint32_t tdcr;
> +	uint32_t divide_count;
> +} tdcrs[] = {
> +	{0x0, 2},
> +	{0x1, 4},
> +	{0x2, 8},
> +	{0x3, 16},
> +	{0x8, 32},
> +	{0x9, 64},
> +	{0xa, 128},
> +	{0xb, 1},
> +};
> +
> +void guest_verify(uint64_t tsc_cycles, uint32_t apic_cycles, uint32_t divide_count)

uin64_t for apic_cycles?  And maybe something like guest_check_apic_count(), to
make it more obvious what is being verified?  Actually, it should be quite easy
to have the two flavors share the bulk of the code.

> +{
> +	unsigned long tsc_hz = tsc_khz * 1000;
> +	uint64_t freq;
> +
> +	GUEST_ASSERT(tsc_cycles > 0);

Is this necessary?  Won't the "freq < ..." check fail?  I love me some paranoia,
but this seems unnecessary.

> +	freq = apic_cycles * divide_count * tsc_hz / tsc_cycles;
> +	/* Check if measured frequency is within 1% of configured frequency. */
> +	GUEST_ASSERT(freq < apic_hz * 101 / 100);
> +	GUEST_ASSERT(freq > apic_hz * 99 / 100);
> +}
> +
> +void x2apic_guest_code(void)
> +{
> +	uint32_t tmict, tmcct;
> +	uint64_t tsc0, tsc1;
> +	int i;
> +
> +	x2apic_enable();
> +
> +	/*
> +	 * Setup one-shot timer.  The vector does not matter because the
> +	 * interrupt should not fire.
> +	 */
> +	x2apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_ONESHOT | APIC_LVT_MASKED);
> +
> +	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
> +		x2apic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
> +
> +		/* Set the largest value to not trigger the interrupt. */

Nit, the goal isn't to avoid triggering the interrupt, e.g. the above masking
takes care of that.  The goal is to prevent the timer from expiring, because if
the timer expires it stops counting and will trigger a false failure because the
TSC doesn't stop counting.

Honestly, I would just delete the comment.  Same with the "busy wait for 100 msec"
and "Read APIC timer and TSC" comments.  They state the obvious.  Loading the max
TMICT is mildly interesting, but that's covered by the file-level comment.

> +		tmict = ~0;

This really belongs outside of the loop, e.g.

	const uint32_t tmict = ~0u;

> +		x2apic_write_reg(APIC_TMICT, tmict);
> +
> +		/* Busy wait for 100 msec. */

Hmm, should this be configurable?

> +		tsc0 = rdtsc();
> +		udelay(100000);
> +		/* Read APIC timer and TSC. */
> +		tmcct = x2apic_read_reg(APIC_TMCCT);
> +		tsc1 = rdtsc();
> +
> +		/* Stop timer. */

This comment is a bit more interesting, as readers might not know writing '0'
stops the timer.  But that's even more interesting is the ordering, e.g. it's
not at all unreasonable to think that the timer should be stopped _before_ reading
the current count.  E.g. something like:

		/*
		 * Stop the timer _after_ reading the current, final count, as
		 * writing the initial counter also modifies the current count.
		 */

> +		x2apic_write_reg(APIC_TMICT, 0);
> +
> +		guest_verify(tsc1 - tsc0, tmict - tmcct, tdcrs[i].divide_count);
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +void xapic_guest_code(void)
> +{
> +	uint32_t tmict, tmcct;
> +	uint64_t tsc0, tsc1;
> +	int i;
> +
> +	xapic_enable();
> +
> +	/*
> +	 * Setup one-shot timer.  The vector does not matter because the
> +	 * interrupt should not fire.
> +	 */
> +	xapic_write_reg(APIC_LVTT, APIC_LVT_TIMER_ONESHOT | APIC_LVT_MASKED);
> +
> +	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
> +		xapic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
> +
> +		/* Set the largest value to not trigger the interrupt. */
> +		tmict = ~0;
> +		xapic_write_reg(APIC_TMICT, tmict);
> +
> +		/* Busy wait for 100 msec. */
> +		tsc0 = rdtsc();
> +		udelay(100000);
> +		/* Read APIC timer and TSC. */
> +		tmcct = xapic_read_reg(APIC_TMCCT);
> +		tsc1 = rdtsc();
> +
> +		/* Stop timer. */
> +		xapic_write_reg(APIC_TMICT, 0);
> +
> +		guest_verify(tsc1 - tsc0, tmict - tmcct, tdcrs[i].divide_count);

That's some nice copy+paste :-)

This test isn't writing ICR, so the whole 32-bit vs. 64-bit weirdness with xAPIC
vs X2APIC is irrevelant.  Two tiny helpers, a global flag, and you can avoid a
pile of copy+paste, and the need to find a better name than guest_verify().

static bool is_x2apic;

static uint32_t apic_read_reg(unsigned int reg)
{
	return is_x2apic ? x2apic_read_reg(reg) : xapic_read_reg(reg);
}

static void apic_read_write(unsigned int reg, uint32_t val)
{
	if (is_x2apic)
		x2apic_write_reg(reg, val);
	else
		xapic_write_reg(reg, val);
	return is_x2apic ? x2apic_read_reg(reg) : xapic_read_reg(reg);
}

> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +void test_apic_bus_clock(struct kvm_vcpu *vcpu)
> +{
> +	bool done = false;
> +	struct ucall uc;
> +
> +	while (!done) {
> +		vcpu_run(vcpu);
> +		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_DONE:
> +			done = true;
> +			break;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +			break;
> +		}
> +	}
> +}
> +
> +void run_apic_bus_clock_test(bool xapic)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int ret;
> +
> +	vm = vm_create(1);
> +
> +	sync_global_to_guest(vm, apic_hz);
> +
> +	vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
> +		      NSEC_PER_SEC / apic_hz);
> +
> +	vcpu = vm_vcpu_add(vm, 0, xapic ? xapic_guest_code : x2apic_guest_code);
> +
> +	ret = __vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
> +			      NSEC_PER_SEC / apic_hz);
> +	TEST_ASSERT(ret < 0 && errno == EINVAL,
> +		    "Setting of APIC bus frequency after vCPU is created should fail.");
> +
> +	if (xapic)
> +		virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> +
> +	test_apic_bus_clock(vcpu);
> +	kvm_vm_free(vm);
> +}
> +
> +void run_xapic_bus_clock_test(void)
> +{
> +	run_apic_bus_clock_test(true);
> +}
> +
> +void run_x2apic_bus_clock_test(void)
> +{
> +	run_apic_bus_clock_test(false);
> +}
> +
> +void help(char *name)
> +{
> +	puts("");
> +	printf("usage: %s [-h] [-a APIC bus freq]\n", name);
> +	puts("");
> +	printf("-a: The APIC bus frequency (in Hz) to be configured for the guest.\n");
> +	puts("");
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int opt;
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GET_TSC_KHZ));
> +
> +	while ((opt = getopt(argc, argv, "a:h")) != -1) {
> +		switch (opt) {
> +		case 'a':

Maybe -f for frequency instead of -a for APIC?  And if we make the delay
configurable, -d (delay)?

> +			apic_hz = atol(optarg);
> +			break;
> +		case 'h':
> +			help(argv[0]);
> +			exit(0);
> +		default:
> +			help(argv[0]);
> +			exit(1);
> +		}
> +	}
> +
> +	run_xapic_bus_clock_test();
> +	run_x2apic_bus_clock_test();
> +}
> -- 
> 2.34.1
> 

