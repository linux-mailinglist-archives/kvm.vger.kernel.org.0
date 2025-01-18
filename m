Return-Path: <kvm+bounces-35895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C38FA15A3A
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 778531674E4
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13ABD80B;
	Sat, 18 Jan 2025 00:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zUx9ymlq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1522173
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737158814; cv=none; b=E4tK+pD6UUw0f5ZVEXpBkB6QYvHd4bTurbKjsYGA9r3OkuyptnqK/EJzBxXEbfogEgRl+7hx3r/7vawbiwD82C24GRoawjP0/Ye1isyO9BXqRWvcGeoMPusZcG28IuXqAZ1w4wukNRtPM+Tal9R5jJ8lCZCNyLpSlERl8vrKolE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737158814; c=relaxed/simple;
	bh=rFiSGAEYI0oUKzAZ9cdsI/nVcPTVNxsl6QsFPSERTYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l6SSKgbPDxOmhSI/SVEyyuWHscaMsylU3jq/sutp4HhatjiZTae241LwLWO27QNS5dsF9Ec43ni2/F4OIihOQJOGqiVpf5rxJz6//nj17LxYz8LS14oMlk0e1sYxnwflnhXtktN4o4zRJ8tMPiJmYIwquYeuWsICBfMYk2a9ABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zUx9ymlq; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-216395e151bso38000745ad.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737158812; x=1737763612; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NKI978WNr/tmVVEFjRafX7xDGZCXJp7rhKxpi24uDDM=;
        b=zUx9ymlq1y6BclZfMmW5WKXA5tXUQpiqNq3J6t5ixn+2pbkxKHKLGTCdUp76HASgoQ
         XAYrg/ctdw61mUSslrcOkUsETMG6ImBX4XbeNyN+kjkgASypgenbmhLY7E/J92V06Duw
         IzTuMWaENQAZUV5xdxOqvHFENtZhxPaSYmxAImZs0kOGKDskwgsIDOc1qnTKglzg6zhk
         gJJ+ju/SqpzWyWeOc5AkMEp+skCbpjLuKJIeJh36d6p5USgVese0Fh1MWCiHkgsZqc0v
         gwiUS6dc3l50Dt5rpVJDBb6YF9Q62OUDDiR+JkUTUlFxRc+Y69Jn/CUGrF/eojEjkWqr
         q5BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737158812; x=1737763612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NKI978WNr/tmVVEFjRafX7xDGZCXJp7rhKxpi24uDDM=;
        b=nekrzPI4GscyLtkeVPENW7kfamMWs7tXErrjan0jeWoNaERt9fP/mz7bSe2UtmJBTS
         QqLmrOtyEcUtzOTumdYajLa1B+hLtqQ+2JaoiGM9Yya5HFh3UO5Gs4iU1J11Yr2xgAPQ
         u6sJfquVDttY5zAXxO6NEsbfQzUFsji9Vlt1MOzhzNxKM1eBAgh3o8GM2Yl7RKgVB10r
         z7d+0jn5UhppS6Vtmk5zJ7eirv7WwwMaC7rKYX4MtWzZ5eSn1OdZAzjb9ts15xseytLq
         HPP/TFeMjyqpq2FxRD/6cS7YjsuRRP7NwoopJJLr3SclPntPF6zYQO8y/JAQ0nyAm/VU
         +9Cg==
X-Forwarded-Encrypted: i=1; AJvYcCVilUwNzPuxJzEnOHzYAYIlLxASuXkuxZ8aUjgb/CB85mI28lca+xy5Dn/XuvVOx4vdKi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjXuRNf8sREIqbA0Su10BqeckakT4YWgdXkWHBEXFTlkhOFXMV
	r+mV3UXVGjoQ1rx7RamSgS3nX91WxnrMEajVsw9BdJQXZ7VCnU+y5jw1Nfb7pQ==
X-Gm-Gg: ASbGncumgw9hY1cPSi7a1RbayfAlI5RTNkKLkcs76l08slSBitpATXpsojV1SGDBW9J
	vDzjug9dpUcIE1laDpvOdfpUugmGsnzV7II3Aq3Chnik3JX3MoaTZRNMaBJK/OeNsNeTRTLWMAb
	u6zAtYgyJUy5Jbz93+mYqsSTHp5CU8xwRCxE7eSuCwF15B+eBn1iG2ERul2TLkFuW7gFQTaB+fz
	lhDNDBuQmwnxMNZZuQJ2gLMAthuxSJ7DuTBVSI5+n8lmn1iClQF5ZcjQCvdU+dPgIPnQeD2CM9I
	9Ysc7LcZGtM6+ThMyS2BVpBkh62rjAwZ9cgJLqjvQw==
X-Google-Smtp-Source: AGHT+IF7HxIa1c5v/h6tQHCCefWog3j2YTShYTHyN1VPg/jPa0S8RLmDiqU3vOlWKD5WIDrGR9rvHQ==
X-Received: by 2002:a17:902:ecc1:b0:21a:874f:1de1 with SMTP id d9443c01a7336-21bf0ce086emr183185645ad.21.1737158811472;
        Fri, 17 Jan 2025 16:06:51 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f77614c15bsm2765061a91.16.2025.01.17.16.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 16:06:50 -0800 (PST)
Date: Sat, 18 Jan 2025 00:06:47 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 2/5] KVM: selftests: Only validate counts for
 hardware-supported arch events
Message-ID: <Z4rwlyysGukXBBw4@google.com>
References: <20250117234204.2600624-1-seanjc@google.com>
 <20250117234204.2600624-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117234204.2600624-3-seanjc@google.com>

On Fri, Jan 17, 2025, Sean Christopherson wrote:
> In the Intel PMU counters test, only validate the counts for architectural
> events that are supported in hardware.  If an arch event isn't supported,
> the event selector may enable a completely different event, and thus the
> logic for the expected count is bogus.
> 
> This fixes test failures on pre-Icelake systems due to the encoding for
> the architectural Top-Down Slots event corresponding to something else
> (at least on the Skylake family of CPUs).
> 
> Note, validation relies on *hardware* support, not KVM support and not
> guest support.  Architectural events are all about enumerating the event
> selector encoding; lack of enumeration for an architectural event doesn't
> mean the event itself is unsupported, i.e. the event should still count as
> expected even if KVM and/or guest CPUID doesn't enumerate the event as
> being "architectural".
> 
> Note #2, it's desirable to _program_ the architectural event encoding even
> if hardware doesn't support the event.  The count can't be validated when
> the event is fully enabled, but KVM should still let the guest program the
> event selector, and the PMC shouldn't count if the event is disabled.
> 
> Fixes: 4f1bd6b16074 ("KVM: selftests: Test Intel PMU architectural events on gp counters")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202501141009.30c629b4-lkp@intel.com
> Debugged-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/x86/pmu_counters_test.c     | 25 +++++++++++++------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> index fe7d72fc8a75..8159615ad492 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> @@ -29,6 +29,8 @@
>  /* Total number of instructions retired within the measured section. */
>  #define NUM_INSNS_RETIRED		(NUM_LOOPS * NUM_INSNS_PER_LOOP + NUM_EXTRA_INSNS)
>  
> +/* Track which architectural events are supported by hardware. */
> +static uint32_t hardware_pmu_arch_events;
>  
>  static uint8_t kvm_pmu_version;
>  static bool kvm_has_perf_caps;
> @@ -89,6 +91,7 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>  
>  	vm = vm_create_with_one_vcpu(vcpu, guest_code);
>  	sync_global_to_guest(vm, kvm_pmu_version);
> +	sync_global_to_guest(vm, hardware_pmu_arch_events);
>  
>  	/*
>  	 * Set PERF_CAPABILITIES before PMU version as KVM disallows enabling
> @@ -152,7 +155,7 @@ static void guest_assert_event_count(uint8_t idx,
>  	uint64_t count;
>  
>  	count = _rdpmc(pmc);
> -	if (!this_pmu_has(event))
> +	if (!(hardware_pmu_arch_events & BIT(idx)))
>  		goto sanity_checks;
>  
>  	switch (idx) {
> @@ -560,7 +563,7 @@ static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
>  
>  static void test_intel_counters(void)
>  {
> -	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
> +	uint8_t nr_arch_events = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
>  	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
>  	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
>  	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
> @@ -582,18 +585,26 @@ static void test_intel_counters(void)
>  
>  	/*
>  	 * Detect the existence of events that aren't supported by selftests.
> -	 * This will (obviously) fail any time the kernel adds support for a
> -	 * new event, but it's worth paying that price to keep the test fresh.
> +	 * This will (obviously) fail any time hardware adds support for a new
> +	 * event, but it's worth paying that price to keep the test fresh.
>  	 */
>  	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
>  		    "New architectural event(s) detected; please update this test (length = %u, mask = %x)",
> -		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
> +		    nr_arch_events, this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));

This is where it would make troubles for us (all companies that might be
using the selftest in upstream kernel and having a new hardware). In
this case when we get new hardware, the test will fail in the downstream
kernel. We will have to wait until the fix is ready, and backport it
downstream, re-test it.... It takes lots of extra work.

Perhaps we can just putting nr_arch_events = NR_INTEL_ARCH_EVENTS
if the former is larger than or equal to the latter? So that the "test"
only test what it knows. It does not test what it does not know, i.e.,
it does not "assume" it knows everything. We can always a warning or
info log at the moment. Then expanding the capability of the test should
be added smoothly later by either maintainers of SWEs from CPU vendors
without causing failures.

Thanks.
-Mingwei
>  
>  	/*
> -	 * Force iterating over known arch events regardless of whether or not
> -	 * KVM/hardware supports a given event.
> +	 * Iterate over known arch events irrespective of KVM/hardware support
> +	 * to verify that KVM doesn't reject programming of events just because
> +	 * the *architectural* encoding is unsupported.  Track which events are
> +	 * supported in hardware; the guest side will validate supported events
> +	 * count correctly, even if *enumeration* of the event is unsupported
> +	 * by KVM and/or isn't exposed to the guest.
>  	 */
>  	nr_arch_events = max_t(typeof(nr_arch_events), nr_arch_events, NR_INTEL_ARCH_EVENTS);
> +	for (i = 0; i < nr_arch_events; i++) {
> +		if (this_pmu_has(intel_event_to_feature(i).gp_event))
> +			hardware_pmu_arch_events |= BIT(i);
> +	}
>  
>  	for (v = 0; v <= max_pmu_version; v++) {
>  		for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
> -- 
> 2.48.0.rc2.279.g1de40edade-goog
> 

