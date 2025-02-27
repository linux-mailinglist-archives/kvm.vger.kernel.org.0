Return-Path: <kvm+bounces-39546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 119D8A47755
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 09:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C41C1169A90
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D692222BC;
	Thu, 27 Feb 2025 08:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="e1cQWA37"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C1A213E71
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 08:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643717; cv=none; b=dHISxm1CAgPXFN41IED1bpUrz5N6gqHrR8jqypuHWZBURjT/VVkvSupm4/gA5S1uJJBuJ+d+WEB9X2lepyY79sZ6T/v2VsJV6VOiWNWRDo86rfR12alQhOGPRWOCpdPKkZUbmaaHAsl1gopdtbM0pqjE2R23z7YCbwcVphcS54s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643717; c=relaxed/simple;
	bh=r5MYi7hZkFxlnQNhgITPV8HgnQ6Ea2Joi+mAWXpJyyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdL3VDNWuJwFEpbyrKXOqV0tfvEM9llkqT9TDmbIBVsok2FAQyGnjMjA2w1wV2Ikeclm7x/HUGGMsBfICADb2Tt+mOY0TrGCeaJqA7ItDg3NjhuYPVT+3oQKo2VmO44WhpWBC+3BlrIKhv4WAyztfbK1Ex7JdOM2ilG6wSCIIog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=e1cQWA37; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4398e839cd4so10925345e9.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1740643713; x=1741248513; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SXEKvsRH1IHGZjXRKII/sR3OF5jBOeQXuZKp+7GCCWk=;
        b=e1cQWA37aUhyGsR2OBViUQPAq6FgG+YLOGWZRsc4sHnPG4EpG3XUGvLqBiMOOasXM/
         lFnrajwvHe5m5ZXImLhJ8tc0nBEvMOvPanmfXg0xlPITTjAGoG8cAcw5kpFmAjBxdJo/
         5s94IBY49j52HmTWEr6g7FKUmku1O7f1gBuD5cyPFn3A8SLWvYnddTAtQUAwZReCDFaU
         YRJLQRbpxkDRFx3AmZV5Mmmd6/2LV+EoMwQfbxzPeG0uSItAhE7db6WPii0vJ1OqNr57
         l8bbgjxxtOqciDkKCrYa8mhWOTqn86TTljeI2p0mEndi+byXz5o2UjrhusQukCCo0fZt
         wL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740643713; x=1741248513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXEKvsRH1IHGZjXRKII/sR3OF5jBOeQXuZKp+7GCCWk=;
        b=v4J/GDCxwLhHMUTwimkyPLKysLU9brJY0p+Rgbo2fBRITehO41bXYDI7QGDH/OLNAY
         VrvIaHsNz0ICapiqtHUx2bboIkgOsuH38vMM5bWYXP27xSTXSGl8CY+qR//nGoicUTRs
         iIL6q0ZpOIsrj4tljti0Grk4N1o9zYrM/7OKUtzFGAxv8jjbC3cKR0uaTcVd1MtyZ+Ca
         yDSL+iYSb6HBDlEzlqqSDYePaVFwsengYQzWS3ZHkwnUqvNBD4Xm9CfReMpbktPsi9z9
         lW5/1prO4jnds67aoHlieMZCfbGwQYh+1xPXLJqepW62poX++vQQyzNOgYAGxqMOnS3+
         Ld+g==
X-Forwarded-Encrypted: i=1; AJvYcCXWcfp3XyQNDzfhAtvS9Cbwv8tzPkT1CgP6jioNpmruWdXCICr/DW2HAAXGsnc7fQf5pHo=@vger.kernel.org
X-Gm-Message-State: AOJu0YykqXaFtYcf9qRwbVLDvlpSjWo7ZD6e60A2IfXmb+kXnLNHfJKi
	F75VhB9f7ORHBJSS1Dd4ElIRReNgqp04cX0u68rDxeNWJFVX2F0fShnzOECao1o=
X-Gm-Gg: ASbGnctmzQwowMKdzM8EsdE0euKUgq+cDTV7wsFW/wMMd/FG3HmkhodwmO1l9B0F7Qq
	L1ltJ3rKp0vUrlrP9ZvAgQnH2XAuWFSFsvbwiRWwq8sofsyCDO92eUG8CM6ZJlPm4xP7eompuqr
	WlcfVlIp0/F+mfJMDt1Vy1nUh4EOTDQLVjjV5X27m2u7URZykhG0csCMlURKAX8d7q63TvhRIvD
	FKVQebjnQEbhJVUvvD1M4J1WJSE4Kk905a8S7vOCBqVFBgdbKfsoBHAjldJWWxRq8iMjbZN6sLQ
	JvZOclXQ5O47fQ==
X-Google-Smtp-Source: AGHT+IFfzFnOGuM3XpELAhnmFcvI3sNcf5fvXpL9iafVg+5GXrJpxNcbrV4SnJPTY8dCnZQ7wtZd1A==
X-Received: by 2002:a5d:5f93:0:b0:38b:f4e6:21aa with SMTP id ffacd0b85a97d-390e1648bd8mr1563072f8f.5.1740643713445;
        Thu, 27 Feb 2025 00:08:33 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::8cf0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47b6cd8sm1198683f8f.44.2025.02.27.00.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 00:08:33 -0800 (PST)
Date: Thu, 27 Feb 2025 09:08:32 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: riscv: selftests: Change command line option
Message-ID: <20250227-eb9e3d8de1de2ff609ac8f64@orel>
References: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
 <20250226-kvm_pmu_improve-v1-3-74c058c2bf6d@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226-kvm_pmu_improve-v1-3-74c058c2bf6d@rivosinc.com>

On Wed, Feb 26, 2025 at 12:25:05PM -0800, Atish Patra wrote:
> The PMU test commandline option takes an argument to disable a
> certain test. The initial assumption behind this was a common use case
> is just to run all the test most of the time. However, running a single
> test seems more useful instead. Especially, the overflow test has been
> helpful to validate PMU virtualizaiton interrupt changes.
> 
> Switching the command line option to run a single test instead
> of disabling a single test also allows to provide additional
> test specific arguments to the test. The default without any options
> remains unchanged which continues to run all the tests.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 40 +++++++++++++++---------
>  1 file changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> index 284bc80193bd..533b76d0de82 100644
> --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> @@ -39,7 +39,11 @@ static bool illegal_handler_invoked;
>  #define SBI_PMU_TEST_SNAPSHOT	BIT(2)
>  #define SBI_PMU_TEST_OVERFLOW	BIT(3)
>  
> -static int disabled_tests;
> +struct test_args {
> +	int disabled_tests;
> +};
> +
> +static struct test_args targs;
>  
>  unsigned long pmu_csr_read_num(int csr_num)
>  {
> @@ -604,7 +608,11 @@ static void test_vm_events_overflow(void *guest_code)
>  	vcpu_init_vector_tables(vcpu);
>  	/* Initialize guest timer frequency. */
>  	timer_freq = vcpu_get_reg(vcpu, RISCV_TIMER_REG(frequency));
> +
> +	/* Export the shared variables to the guest */
>  	sync_global_to_guest(vm, timer_freq);
> +	sync_global_to_guest(vm, vcpu_shared_irq_count);
> +	sync_global_to_guest(vm, targs);
>  
>  	run_vcpu(vcpu);
>  
> @@ -613,28 +621,30 @@ static void test_vm_events_overflow(void *guest_code)
>  
>  static void test_print_help(char *name)
>  {
> -	pr_info("Usage: %s [-h] [-d <test name>]\n", name);
> -	pr_info("\t-d: Test to disable. Available tests are 'basic', 'events', 'snapshot', 'overflow'\n");
> +	pr_info("Usage: %s [-h] [-t <test name>]\n", name);
> +	pr_info("\t-t: Test to run (default all). Available tests are 'basic', 'events', 'snapshot', 'overflow'\n");

It's probably fine to drop '-d', since we don't make any claims about
support, but doing so does risk breaking some CI somewhere. If that
potential breakage is a concern, then we could keep '-d', since nothing
stops us from having both.

>  	pr_info("\t-h: print this help screen\n");
>  }
>  
>  static bool parse_args(int argc, char *argv[])
>  {
>  	int opt;
> -
> -	while ((opt = getopt(argc, argv, "hd:")) != -1) {
> +	int temp_disabled_tests = SBI_PMU_TEST_BASIC | SBI_PMU_TEST_EVENTS | SBI_PMU_TEST_SNAPSHOT |
> +				  SBI_PMU_TEST_OVERFLOW;
> +	while ((opt = getopt(argc, argv, "h:t:n:")) != -1) {

'-h' doesn't need an argument and '-n' should be introduced with the next
patch.

>  		switch (opt) {
> -		case 'd':
> +		case 't':
>  			if (!strncmp("basic", optarg, 5))
> -				disabled_tests |= SBI_PMU_TEST_BASIC;
> +				temp_disabled_tests &= ~SBI_PMU_TEST_BASIC;
>  			else if (!strncmp("events", optarg, 6))
> -				disabled_tests |= SBI_PMU_TEST_EVENTS;
> +				temp_disabled_tests &= ~SBI_PMU_TEST_EVENTS;
>  			else if (!strncmp("snapshot", optarg, 8))
> -				disabled_tests |= SBI_PMU_TEST_SNAPSHOT;
> +				temp_disabled_tests &= ~SBI_PMU_TEST_SNAPSHOT;
>  			else if (!strncmp("overflow", optarg, 8))
> -				disabled_tests |= SBI_PMU_TEST_OVERFLOW;
> +				temp_disabled_tests &= ~SBI_PMU_TEST_OVERFLOW;
>  			else
>  				goto done;
> +			targs.disabled_tests = temp_disabled_tests;
>  			break;
>  		case 'h':
>  		default:
> @@ -650,25 +660,27 @@ static bool parse_args(int argc, char *argv[])
>  
>  int main(int argc, char *argv[])
>  {
> +	targs.disabled_tests = 0;
> +
>  	if (!parse_args(argc, argv))
>  		exit(KSFT_SKIP);
>  
> -	if (!(disabled_tests & SBI_PMU_TEST_BASIC)) {
> +	if (!(targs.disabled_tests & SBI_PMU_TEST_BASIC)) {
>  		test_vm_basic_test(test_pmu_basic_sanity);
>  		pr_info("SBI PMU basic test : PASS\n");
>  	}
>  
> -	if (!(disabled_tests & SBI_PMU_TEST_EVENTS)) {
> +	if (!(targs.disabled_tests & SBI_PMU_TEST_EVENTS)) {
>  		test_vm_events_test(test_pmu_events);
>  		pr_info("SBI PMU event verification test : PASS\n");
>  	}
>  
> -	if (!(disabled_tests & SBI_PMU_TEST_SNAPSHOT)) {
> +	if (!(targs.disabled_tests & SBI_PMU_TEST_SNAPSHOT)) {
>  		test_vm_events_snapshot_test(test_pmu_events_snaphost);
>  		pr_info("SBI PMU event verification with snapshot test : PASS\n");
>  	}
>  
> -	if (!(disabled_tests & SBI_PMU_TEST_OVERFLOW)) {
> +	if (!(targs.disabled_tests & SBI_PMU_TEST_OVERFLOW)) {
>  		test_vm_events_overflow(test_pmu_events_overflow);
>  		pr_info("SBI PMU event verification with overflow test : PASS\n");
>  	}
> 
> -- 
> 2.43.0
>

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

