Return-Path: <kvm+bounces-38203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D5F3A367F4
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 23:01:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B39B0188D26D
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 22:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905AD1FC10E;
	Fri, 14 Feb 2025 22:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CemxHM5J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483D31FC0E7
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739570450; cv=none; b=ZUb8ljNk5U3SouZp24zse8TVvjNREvfPg3Z+Sahmcart3NAv6xJHv7KX8QbCEdkFDz54KMe+Y971RkVeBkc3QQL4nePad/HFfST9tAUBnr3ewMfvUGkT53B8o/9sPbk2dnBMzqVbU3K3DeNHY9etjVMaJyDXWxoq31ElcZmopJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739570450; c=relaxed/simple;
	bh=yxp048zKIEtHjhiIY7CU7E4iJEvk4TbWFpqjbvBjOT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PODkFgyQD9ju2r0S7/i0wuXYXj67SM7vWg58S19c+L+Nl7HBYWA+bOZ8vaYnPBxDSGsV51nE6S1izp2qa/dsKI547wIpNqEqymQC1kAQvEPJNi152ipWeY0thU5u3HId8C3q/5O7KZuZe0wHoXK9k+NMSwDWb/+J+KCbkshXXhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CemxHM5J; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fa6793e8b8so6158525a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 14:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739570448; x=1740175248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vIfyjLKpTDnv4aJfcA9rATISA+dS7OMvPFy+zXQ9sIA=;
        b=CemxHM5JbY9FFTNziWE0qmOGgKSuzFRAQWvM2KcWcf23gox6OQtM9MFmmAmByu2Hz7
         HBKc1BGehV+V+XRDtCihY8cvtLKRn5trYlsmIAYWaY4BuHGtKCsseZ5q2dZwIR0aCGwE
         1fFEW8GByn5yLHF46nRHioqqEQCjPytPvFdeT5Vi4SU9yRjIAHZJkt4hUx4UI7MA8DkI
         vMDlejcgLl214En6EcjTRkha1gXKMTiR3dXoQHHH3cEcGIjeWhf2/Vt70y8OfjYE6/8f
         s2gn53zKlORNuJFuFcjupzbPr33rvuQvObiX7knhjrqGwSNJFhFUBf9iGslIS9Skx20R
         Gm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739570448; x=1740175248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vIfyjLKpTDnv4aJfcA9rATISA+dS7OMvPFy+zXQ9sIA=;
        b=CmS854A8JGgtQ1CPl7dIWeDLcEUi3iK6/eGUusFTS9BR0PO3+rOcpO1ts4jmDtps23
         hYe5KnQTiP1wEuKbkk0N8BcXXvhlmjKjcGixHdS7YFdG7Cz7CjWp3xlHoo2hj8zEqGBU
         P44U/UBwizKDHOg4U3goYYC0mN7SM5Q+rpM4YLlOvBGyQDR0bQzEgc6U/G7IRnTHd4zM
         peCBn0kX3iEb0RK/cw94s/5PcfKiS0oZnDJFqCex4sLNHbSvT1uHH+tz+PnqUwXQEQ8e
         t0vaeON6GQtLeXai8swWJgGS1nzcyJeXx937bzFsCOmHA2BLA5X5S9nkfon716ivHcGs
         UbBg==
X-Gm-Message-State: AOJu0YzD5jSS8qDF0MfG+5+X/+QXioEWDhy59x1iZsW3PrGHN3i6tACH
	x/FwpLCSMmX+7ORrM6QiAxjoVfIndnXs/iQ9m0Xyhq0KR6uC1KVF8zfO/d3WTeV7w/1NR0KUcu1
	dcw==
X-Google-Smtp-Source: AGHT+IGeCOllheDHrfgVMv8I9s7PtEPV6JfGeuH6Fa9nSv8cCv9pqW6DE9WLm1zjW3jVFLjV8cepsCcIKd8=
X-Received: from pfbjt23.prod.google.com ([2002:a05:6a00:91d7:b0:730:8a7b:24e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2351:b0:732:564e:1ec6
 with SMTP id d2e1a72fcca58-7326193a7e0mr1347483b3a.22.1739570448535; Fri, 14
 Feb 2025 14:00:48 -0800 (PST)
Date: Fri, 14 Feb 2025 14:00:47 -0800
In-Reply-To: <20240907005440.500075-5-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240907005440.500075-1-mlevitsk@redhat.com> <20240907005440.500075-5-mlevitsk@redhat.com>
Message-ID: <Z6-9D_YZGniOKZjl@google.com>
Subject: Re: [kvm-unit-tests PATCH 4/5] Add a test for writing canonical
 values to various msrs and fields
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 06, 2024, Maxim Levitsky wrote:
> +static void test_register_write(const char *register_name, u64 test_register,
> +				bool force_emulation, u64 test_value,
> +				bool expect_success)
> +{
> +	u64 old_value, expected_value;
> +	bool success, test_passed = false;
> +	int test_mode = (force_emulation ? SET_REGISTER_MODE_FEP : SET_REGISTER_MODE_SAFE);
> +
> +	old_value = get_test_register_value(test_register);
> +	expected_value = expect_success ? test_value : old_value;
> +
> +	/*
> +	 * TODO: Successful write to the MSR_GS_BASE corrupts it,
> +	 * and that breaks the wrmsr_safe macro.
> +	 */
> +	if ((test_register >> 32) == MSR_GS_BASE && expect_success)
> +		test_mode = SET_REGISTER_MODE_UNSAFE;
> +
> +	/* Write the test value*/
> +	success =  set_test_register_value(test_register, test_mode, test_value);
> +
> +	if (success != expect_success) {
> +		report(false,

This can be report_fail().  But that's a moot point because skipping the cleanup
on unexpected *success* leaves registers in a bad state and crashes the test.

> +		       "Write of test register %s with value %lx unexpectedly %s",
> +		       register_name, test_value,
> +		       (success ? "succeeded" : "failed"));
> +		goto exit;
> +	}
> +
> +	/*
> +	 * Check that the value was really written.
> +	 * Don't test TR and LDTR, because it's not possible to read them
> +	 * directly.
> +	 */
> +
> +	if (test_register != TEST_REGISTER_TR_BASE &&
> +	    test_register != TEST_REGISTER_LDT_BASE) {
> +		u64 new_value = get_test_register_value(test_register);
> +
> +		if (new_value != expected_value) {
> +			report(false,

Same thing here (on both fronts).

> +			       "Register %s wasn't set to %lx as expected (actual value %lx)",
> +			       register_name, expected_value, new_value);
> +			goto exit;
> +		}
> +	}
> +
> +	/*
> +	 * Restore the old value directly without safety wrapper,
> +	 * to avoid test crashes related to temporary clobbered GDT/IDT/etc bases.
> +	 */
> +
> +	set_test_register_value(test_register, SET_REGISTER_MODE_UNSAFE, old_value);
> +	test_passed = true;
> +exit:
> +	report(test_passed, "Tested setting %s to 0x%lx value - %s", register_name,
> +	       test_value, success ? "success" : "failure");
> +}

...

> +#define TEST_REGISTER(register_name, force_emulation) \
> +		      test_register(#register_name, register_name, force_emulation)

Rather than print the entire name, concatenate TEST_REGISTER with the register
name, e.g. GDTR_BASE, so that the outputs are simply GDTR_BASE.

> +	/*
> +	 * SYSENTER ESP/EIP MSRs have canonical checks only on Intel,
> +	 * because only on Intel these instructions were extended to 64 bit.
> +	 *
> +	 * TODO: KVM emulation however ignores canonical checks for these MSRs
> +	 * even on Intel, to support cross-vendor migration.
> +	 *
> +	 * Thus only run the check on bare metal.

Sadly, KVM's behavior also applies for nested VMX, i.e. when running the test
nested, there is no bare metal.  AFAIK, there's no easy way to detect a nested
run from within the test; it would have to be fed in from the test runner.

For now, I'll make the whole thing a TODO so that people don't have to re-debug
why the test fails when run in a VM (and because testing bare metal isn't all
that interesting).

> +static void do_test(void)
> +{
> +	printf("\n");
> +	printf("Running the test without emulation:\n");
> +	__do_test(false);

Do the printf()s in the inner helper, it's easy to pivot on @forced_emulation.

> +	printf("\n");
> +
> +	if (is_fep_available()) {
> +		printf("Running the test with forced emulation:\n");
> +		__do_test(true);
> +	} else

Needs curly braces (moot point if the printf() is moved).

> +		report_skip("force emulation prefix not enabled - skipping");
> +}
> +
> +int main(int ac, char **av)
> +{
> +	/* set dummy LDTR pointer */
> +	set_gdt_entry(FIRST_SPARE_SEL, 0xffaabb, 0xffff, 0x82, 0);
> +	lldt(FIRST_SPARE_SEL);
> +
> +	do_test();
> +
> +	printf("\n");
> +
> +	if (this_cpu_has(X86_FEATURE_LA57)) {
> +		printf("Switching to 5 level paging mode and rerunning the test...\n");
> +		setup_5level_page_table();
> +		do_test();
> +	} else

Curly braces.

> +		report_skip("Skipping the test in 5-level paging mode - not supported on the host");
> +
> +	return report_summary();
> +}
> -- 
> 2.26.3
> 

