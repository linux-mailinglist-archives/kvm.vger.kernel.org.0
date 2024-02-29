Return-Path: <kvm+bounces-10534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D91C86D1F5
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:21:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5175C1C22297
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F101C3839D;
	Thu, 29 Feb 2024 18:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Y+lGtd47"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E197A121
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 18:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709230884; cv=none; b=N6n0qrSrUujGD/qmCBWyOUd/XbGcyb0Y7IB9KNaqt7eGryIbFiGg0buJM57dYrHfS6rcpambqq1UIQif1rn5RNIRgfL0ePEJyxkTiORGHAvEp64mLVn1TURCXcBu0mDklo8u8U825qV7sAfz/aITGye9GvgtTxlinlStt7EtD7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709230884; c=relaxed/simple;
	bh=yA8q5nl2Pm3AknNxeGVkbhgKpgbLi5R5ahDZHQAZt+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eOc2iRte1+liROaqej+/HtMtvBSkmCTuTxkCgavUu77+ToQdJFuheh5IR13cUUEtZ4uhY7x9yeF8kKH58eagAWYfmq1V4VXClvjLp3prJaIh7gHLkKnVrszoyXdlXxeP+0qORifyKsAkDDOJ5nTYJ1oRNpU9t3TSFcZjuj6+lSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Y+lGtd47; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e5675f2ca2so803736b3a.0
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709230881; x=1709835681; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uelYmC/3eujYpFJjjTLThKTYFmviv/Q9F24/PWdcSjs=;
        b=Y+lGtd47kRFvFX4mxz5XiOjyBgm2Q4LnhxcCls4/SZ7dYCQHw7ujuqDiqLPCOK/FUC
         iJqC347EhvQt05OF7DbGw6U90Ozn+tkckxQTk/fJKgCRmZwKODWu2QjiiIWBha57KFJb
         IO9yakc6W8KMJK+kwbPbCYponTiMk7WsUWklE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709230881; x=1709835681;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uelYmC/3eujYpFJjjTLThKTYFmviv/Q9F24/PWdcSjs=;
        b=qNBbXn/DBagygmwPXRhHz8P5SqMGImVflGfZZ+qt8qS7qlrDBbHCmGi5zgCo9pQi0p
         gwZVH1a9dqpwyKcUcnCQESFvavUY2+qiP7Mq5+05VxMD772dgS+ILpi2YnMiVR8bhPhj
         tMqXxb8GfQoV2NlcrpuThVhfFSRzhxhd0tnVlgS2Bbz4UY41sUqO1XO32LqMtRScW+sS
         WOAfFPCcDmAZeFi//nllesXrWfjUdmNijYYRYz+1chfElM9n7K7TrA87zhTfCLovDDwa
         c4ljGSurmkudFKl1dLD3wd/hN81BW+0ppmSjqk7UQ0K52uRdW7tMUEExYkrJ3gCW8xkv
         Wy/w==
X-Forwarded-Encrypted: i=1; AJvYcCWAqVed/y/6MufY6c4xjsQ8KyiPSYs9MUKit+vcuhJvROfsnSfKgHSAPQGNHfQe6Or27MyrXT9iOjxz80v3CKmJ4uPT
X-Gm-Message-State: AOJu0Yxk5PoX7k+p3q4XQIzwkN/7TFI8s3EZLOjJlk+EKQ96qbnNmwDx
	8VrSw4P6KjwE4YJzRbnEYWO3EV9I1ZshBzXXiHEigOal5aR+60433/eh0ooi7Q==
X-Google-Smtp-Source: AGHT+IF67MkOkX4xB3W7wovC5c0+HzMPvfIwuYaEdzq68KesLXoAZl6H2TahEhNe+okQqfkwtIxndQ==
X-Received: by 2002:a05:6a21:1743:b0:1a0:e4a6:2d86 with SMTP id nw3-20020a056a21174300b001a0e4a62d86mr3605699pzb.59.1709230881286;
        Thu, 29 Feb 2024 10:21:21 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x37-20020a631725000000b005dc48e56191sm1447341pgl.11.2024.02.29.10.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 10:21:20 -0800 (PST)
Date: Thu, 29 Feb 2024 10:21:19 -0800
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marco Pagani <marpagan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH v1 1/8] kunit: Run tests when the kernel is fully setup
Message-ID: <202402291019.17D24E9@keescook>
References: <20240229170409.365386-1-mic@digikod.net>
 <20240229170409.365386-2-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240229170409.365386-2-mic@digikod.net>

On Thu, Feb 29, 2024 at 06:04:02PM +0100, Mickaël Salaün wrote:
> Run all the KUnit tests just before the first userspace code is
> launched.  This makes it it possible to write new tests that check the
> kernel in its final state i.e., with all async __init code called,
> memory and RCU properly set up, and sysctl boot arguments evaluated.
> 
> The initial motivation is to run hardening tests (e.g. memory
> protection, Heki's CR-pinning), which require such security protection
> to be fully setup (e.g. memory marked as read-only).
> 
> Because the suite set could refer to init data, initialize the suite set
> with late_initcall(), before kunit_run_all_tests(), if KUnit is built-in
> and enabled at boot time.  To make it more consistent and easier to
> manage, whatever filters are used or not, always copy test suite entries
> and free them after all tests are run.
> 
> Because of the prepare_namespace() call, we need to have a valid root
> filesystem.  To make it simple, let's use tmpfs with an empty root.
> Teach kunit_kernel.py:LinuxSourceTreeOperations*() about the related
> kernel boot argument, and add this filesystem to the kunit.py's kernel
> build requirements.
> 
> Remove __init and __refdata markers from iov_iter, bitfield, checksum,
> and the example KUnit tests.  Without this change, the kernel tries to
> execute NX-protected pages (because the pages are deallocated).

I defer to the KUnit maintainers, but I'd find this patch easier to
review if the __init and __refdata changes were a separate patch.

But otherwise, I like the goals of this series! It should make adding a
userspace memory region for porting the usercopy tests easier too.

-Kees

> 
> Tested with:
> ./tools/testing/kunit/kunit.py run --alltests
> ./tools/testing/kunit/kunit.py run --alltests --arch x86_64
> 
> Cc: Alan Maguire <alan.maguire@oracle.com>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Marco Pagani <marpagan@redhat.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> ---
>  init/main.c                         |  4 +-
>  lib/bitfield_kunit.c                |  8 +--
>  lib/checksum_kunit.c                |  2 +-
>  lib/kunit/executor.c                | 81 +++++++++++++++++++++--------
>  lib/kunit/kunit-example-test.c      |  6 +--
>  lib/kunit_iov_iter.c                | 52 +++++++++---------
>  tools/testing/kunit/kunit_kernel.py |  6 ++-
>  7 files changed, 96 insertions(+), 63 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index e24b0780fdff..b39d74727aad 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1463,6 +1463,8 @@ static int __ref kernel_init(void *unused)
>  
>  	do_sysctl_args();
>  
> +	kunit_run_all_tests();
> +
>  	if (ramdisk_execute_command) {
>  		ret = run_init_process(ramdisk_execute_command);
>  		if (!ret)
> @@ -1550,8 +1552,6 @@ static noinline void __init kernel_init_freeable(void)
>  
>  	do_basic_setup();
>  
> -	kunit_run_all_tests();
> -
>  	wait_for_initramfs();
>  	console_on_rootfs();
>  
> diff --git a/lib/bitfield_kunit.c b/lib/bitfield_kunit.c
> index 1473d8b4bf0f..71e9f2e96496 100644
> --- a/lib/bitfield_kunit.c
> +++ b/lib/bitfield_kunit.c
> @@ -57,7 +57,7 @@
>  		CHECK_ENC_GET_BE(tp, v, field, res);			\
>  	} while (0)
>  
> -static void __init test_bitfields_constants(struct kunit *context)
> +static void test_bitfields_constants(struct kunit *context)
>  {
>  	/*
>  	 * NOTE
> @@ -100,7 +100,7 @@ static void __init test_bitfields_constants(struct kunit *context)
>  				tp##_encode_bits(v, mask) != v << __ffs64(mask));\
>  	} while (0)
>  
> -static void __init test_bitfields_variables(struct kunit *context)
> +static void test_bitfields_variables(struct kunit *context)
>  {
>  	CHECK(u8, 0x0f);
>  	CHECK(u8, 0xf0);
> @@ -126,7 +126,7 @@ static void __init test_bitfields_variables(struct kunit *context)
>  }
>  
>  #ifdef TEST_BITFIELD_COMPILE
> -static void __init test_bitfields_compile(struct kunit *context)
> +static void test_bitfields_compile(struct kunit *context)
>  {
>  	/* these should fail compilation */
>  	CHECK_ENC_GET(16, 16, 0x0f00, 0x1000);
> @@ -137,7 +137,7 @@ static void __init test_bitfields_compile(struct kunit *context)
>  }
>  #endif
>  
> -static struct kunit_case __refdata bitfields_test_cases[] = {
> +static struct kunit_case bitfields_test_cases[] = {
>  	KUNIT_CASE(test_bitfields_constants),
>  	KUNIT_CASE(test_bitfields_variables),
>  	{}
> diff --git a/lib/checksum_kunit.c b/lib/checksum_kunit.c
> index 225bb7701460..41aaed3a4963 100644
> --- a/lib/checksum_kunit.c
> +++ b/lib/checksum_kunit.c
> @@ -620,7 +620,7 @@ static void test_csum_ipv6_magic(struct kunit *test)
>  #endif /* !CONFIG_NET */
>  }
>  
> -static struct kunit_case __refdata checksum_test_cases[] = {
> +static struct kunit_case checksum_test_cases[] = {
>  	KUNIT_CASE(test_csum_fixed_random_inputs),
>  	KUNIT_CASE(test_csum_all_carry_inputs),
>  	KUNIT_CASE(test_csum_no_carry_inputs),
> diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
> index 689fff2b2b10..ff3e66ffa739 100644
> --- a/lib/kunit/executor.c
> +++ b/lib/kunit/executor.c
> @@ -15,6 +15,8 @@ extern struct kunit_suite * const __kunit_suites_end[];
>  extern struct kunit_suite * const __kunit_init_suites_start[];
>  extern struct kunit_suite * const __kunit_init_suites_end[];
>  
> +static struct kunit_suite_set final_suite_set = {};
> +
>  static char *action_param;
>  
>  module_param_named(action, action_param, charp, 0400);
> @@ -233,6 +235,21 @@ kunit_filter_suites(const struct kunit_suite_set *suite_set,
>  		if (!filtered_suite)
>  			continue;
>  
> +		if (filtered_suite == suite_set->start[i]) {
> +			/*
> +			 * To make memory allocation consistent whatever
> +			 * filters are used or not, and to keep
> +			 * kunit_free_suite_set() simple, always copy static
> +			 * data.
> +			 */
> +			filtered_suite = kmemdup(filtered_suite, sizeof(*filtered_suite),
> +					GFP_KERNEL);
> +			if (!filtered_suite) {
> +				*err = -ENOMEM;
> +				goto free_parsed_filters;
> +			}
> +		}
> +
>  		*copy++ = filtered_suite;
>  	}
>  	filtered.start = copy_start;
> @@ -348,7 +365,7 @@ static void kunit_handle_shutdown(void)
>  
>  }
>  
> -int kunit_run_all_tests(void)
> +static int kunit_init_suites(void)
>  {
>  	struct kunit_suite_set suite_set = {NULL, NULL};
>  	struct kunit_suite_set filtered_suite_set = {NULL, NULL};
> @@ -361,6 +378,9 @@ int kunit_run_all_tests(void)
>  	size_t init_num_suites = init_suite_set.end - init_suite_set.start;
>  	int err = 0;
>  
> +	if (!kunit_enabled())
> +		return 0;
> +
>  	if (init_num_suites > 0) {
>  		suite_set = kunit_merge_suite_sets(init_suite_set, normal_suite_set);
>  		if (!suite_set.start)
> @@ -368,41 +388,56 @@ int kunit_run_all_tests(void)
>  	} else
>  		suite_set = normal_suite_set;
>  
> -	if (!kunit_enabled()) {
> -		pr_info("kunit: disabled\n");
> +	filtered_suite_set = kunit_filter_suites(&suite_set, filter_glob_param,
> +			filter_param, filter_action_param, &err);
> +
> +	/* Free original suite set before using filtered suite set */
> +	if (init_num_suites > 0)
> +		kfree(suite_set.start);
> +	suite_set = filtered_suite_set;
> +
> +	if (err) {
> +		pr_err("kunit executor: error filtering suites: %d\n", err);
>  		goto free_out;
>  	}
>  
> -	if (filter_glob_param || filter_param) {
> -		filtered_suite_set = kunit_filter_suites(&suite_set, filter_glob_param,
> -				filter_param, filter_action_param, &err);
> +	final_suite_set = suite_set;
> +	return 0;
>  
> -		/* Free original suite set before using filtered suite set */
> -		if (init_num_suites > 0)
> -			kfree(suite_set.start);
> -		suite_set = filtered_suite_set;
> +free_out:
> +	kunit_free_suite_set(suite_set);
>  
> -		if (err) {
> -			pr_err("kunit executor: error filtering suites: %d\n", err);
> -			goto free_out;
> -		}
> +out:
> +	kunit_handle_shutdown();
> +	return err;
> +}
> +
> +late_initcall(kunit_init_suites);
> +
> +int kunit_run_all_tests(void)
> +{
> +	int err = 0;
> +
> +	if (!kunit_enabled()) {
> +		pr_info("kunit: disabled\n");
> +		goto out;
>  	}
>  
> +	if (!final_suite_set.start)
> +		goto out;
> +
>  	if (!action_param)
> -		kunit_exec_run_tests(&suite_set, true);
> +		kunit_exec_run_tests(&final_suite_set, true);
>  	else if (strcmp(action_param, "list") == 0)
> -		kunit_exec_list_tests(&suite_set, false);
> +		kunit_exec_list_tests(&final_suite_set, false);
>  	else if (strcmp(action_param, "list_attr") == 0)
> -		kunit_exec_list_tests(&suite_set, true);
> +		kunit_exec_list_tests(&final_suite_set, true);
>  	else
>  		pr_err("kunit executor: unknown action '%s'\n", action_param);
>  
> -free_out:
> -	if (filter_glob_param || filter_param)
> -		kunit_free_suite_set(suite_set);
> -	else if (init_num_suites > 0)
> -		/* Don't use kunit_free_suite_set because suites aren't individually allocated */
> -		kfree(suite_set.start);
> +	kunit_free_suite_set(final_suite_set);
> +	final_suite_set.start = NULL;
> +	final_suite_set.end = NULL;
>  
>  out:
>  	kunit_handle_shutdown();
> diff --git a/lib/kunit/kunit-example-test.c b/lib/kunit/kunit-example-test.c
> index 798924f7cc86..248949eb3b16 100644
> --- a/lib/kunit/kunit-example-test.c
> +++ b/lib/kunit/kunit-example-test.c
> @@ -337,7 +337,7 @@ static struct kunit_suite example_test_suite = {
>   */
>  kunit_test_suites(&example_test_suite);
>  
> -static int __init init_add(int x, int y)
> +static int init_add(int x, int y)
>  {
>  	return (x + y);
>  }
> @@ -345,7 +345,7 @@ static int __init init_add(int x, int y)
>  /*
>   * This test should always pass. Can be used to test init suites.
>   */
> -static void __init example_init_test(struct kunit *test)
> +static void example_init_test(struct kunit *test)
>  {
>  	KUNIT_EXPECT_EQ(test, init_add(1, 1), 2);
>  }
> @@ -354,7 +354,7 @@ static void __init example_init_test(struct kunit *test)
>   * The kunit_case struct cannot be marked as __initdata as this will be
>   * used in debugfs to retrieve results after test has run
>   */
> -static struct kunit_case __refdata example_init_test_cases[] = {
> +static struct kunit_case example_init_test_cases[] = {
>  	KUNIT_CASE(example_init_test),
>  	{}
>  };
> diff --git a/lib/kunit_iov_iter.c b/lib/kunit_iov_iter.c
> index 859b67c4d697..a77991a9bffb 100644
> --- a/lib/kunit_iov_iter.c
> +++ b/lib/kunit_iov_iter.c
> @@ -44,9 +44,8 @@ static void iov_kunit_unmap(void *data)
>  	vunmap(data);
>  }
>  
> -static void *__init iov_kunit_create_buffer(struct kunit *test,
> -					    struct page ***ppages,
> -					    size_t npages)
> +static void *iov_kunit_create_buffer(struct kunit *test, struct page ***ppages,
> +				     size_t npages)
>  {
>  	struct page **pages;
>  	unsigned long got;
> @@ -69,11 +68,10 @@ static void *__init iov_kunit_create_buffer(struct kunit *test,
>  	return buffer;
>  }
>  
> -static void __init iov_kunit_load_kvec(struct kunit *test,
> -				       struct iov_iter *iter, int dir,
> -				       struct kvec *kvec, unsigned int kvmax,
> -				       void *buffer, size_t bufsize,
> -				       const struct kvec_test_range *pr)
> +static void iov_kunit_load_kvec(struct kunit *test, struct iov_iter *iter,
> +				int dir, struct kvec *kvec, unsigned int kvmax,
> +				void *buffer, size_t bufsize,
> +				const struct kvec_test_range *pr)
>  {
>  	size_t size = 0;
>  	int i;
> @@ -95,7 +93,7 @@ static void __init iov_kunit_load_kvec(struct kunit *test,
>  /*
>   * Test copying to a ITER_KVEC-type iterator.
>   */
> -static void __init iov_kunit_copy_to_kvec(struct kunit *test)
> +static void iov_kunit_copy_to_kvec(struct kunit *test)
>  {
>  	const struct kvec_test_range *pr;
>  	struct iov_iter iter;
> @@ -145,7 +143,7 @@ static void __init iov_kunit_copy_to_kvec(struct kunit *test)
>  /*
>   * Test copying from a ITER_KVEC-type iterator.
>   */
> -static void __init iov_kunit_copy_from_kvec(struct kunit *test)
> +static void iov_kunit_copy_from_kvec(struct kunit *test)
>  {
>  	const struct kvec_test_range *pr;
>  	struct iov_iter iter;
> @@ -213,12 +211,11 @@ static const struct bvec_test_range bvec_test_ranges[] = {
>  	{ -1, -1, -1 }
>  };
>  
> -static void __init iov_kunit_load_bvec(struct kunit *test,
> -				       struct iov_iter *iter, int dir,
> -				       struct bio_vec *bvec, unsigned int bvmax,
> -				       struct page **pages, size_t npages,
> -				       size_t bufsize,
> -				       const struct bvec_test_range *pr)
> +static void iov_kunit_load_bvec(struct kunit *test, struct iov_iter *iter,
> +				int dir, struct bio_vec *bvec,
> +				unsigned int bvmax, struct page **pages,
> +				size_t npages, size_t bufsize,
> +				const struct bvec_test_range *pr)
>  {
>  	struct page *can_merge = NULL, *page;
>  	size_t size = 0;
> @@ -254,7 +251,7 @@ static void __init iov_kunit_load_bvec(struct kunit *test,
>  /*
>   * Test copying to a ITER_BVEC-type iterator.
>   */
> -static void __init iov_kunit_copy_to_bvec(struct kunit *test)
> +static void iov_kunit_copy_to_bvec(struct kunit *test)
>  {
>  	const struct bvec_test_range *pr;
>  	struct iov_iter iter;
> @@ -308,7 +305,7 @@ static void __init iov_kunit_copy_to_bvec(struct kunit *test)
>  /*
>   * Test copying from a ITER_BVEC-type iterator.
>   */
> -static void __init iov_kunit_copy_from_bvec(struct kunit *test)
> +static void iov_kunit_copy_from_bvec(struct kunit *test)
>  {
>  	const struct bvec_test_range *pr;
>  	struct iov_iter iter;
> @@ -370,10 +367,9 @@ static void iov_kunit_destroy_xarray(void *data)
>  	kfree(xarray);
>  }
>  
> -static void __init iov_kunit_load_xarray(struct kunit *test,
> -					 struct iov_iter *iter, int dir,
> -					 struct xarray *xarray,
> -					 struct page **pages, size_t npages)
> +static void iov_kunit_load_xarray(struct kunit *test, struct iov_iter *iter,
> +				  int dir, struct xarray *xarray,
> +				  struct page **pages, size_t npages)
>  {
>  	size_t size = 0;
>  	int i;
> @@ -401,7 +397,7 @@ static struct xarray *iov_kunit_create_xarray(struct kunit *test)
>  /*
>   * Test copying to a ITER_XARRAY-type iterator.
>   */
> -static void __init iov_kunit_copy_to_xarray(struct kunit *test)
> +static void iov_kunit_copy_to_xarray(struct kunit *test)
>  {
>  	const struct kvec_test_range *pr;
>  	struct iov_iter iter;
> @@ -459,7 +455,7 @@ static void __init iov_kunit_copy_to_xarray(struct kunit *test)
>  /*
>   * Test copying from a ITER_XARRAY-type iterator.
>   */
> -static void __init iov_kunit_copy_from_xarray(struct kunit *test)
> +static void iov_kunit_copy_from_xarray(struct kunit *test)
>  {
>  	const struct kvec_test_range *pr;
>  	struct iov_iter iter;
> @@ -522,7 +518,7 @@ static void __init iov_kunit_copy_from_xarray(struct kunit *test)
>  /*
>   * Test the extraction of ITER_KVEC-type iterators.
>   */
> -static void __init iov_kunit_extract_pages_kvec(struct kunit *test)
> +static void iov_kunit_extract_pages_kvec(struct kunit *test)
>  {
>  	const struct kvec_test_range *pr;
>  	struct iov_iter iter;
> @@ -602,7 +598,7 @@ static void __init iov_kunit_extract_pages_kvec(struct kunit *test)
>  /*
>   * Test the extraction of ITER_BVEC-type iterators.
>   */
> -static void __init iov_kunit_extract_pages_bvec(struct kunit *test)
> +static void iov_kunit_extract_pages_bvec(struct kunit *test)
>  {
>  	const struct bvec_test_range *pr;
>  	struct iov_iter iter;
> @@ -680,7 +676,7 @@ static void __init iov_kunit_extract_pages_bvec(struct kunit *test)
>  /*
>   * Test the extraction of ITER_XARRAY-type iterators.
>   */
> -static void __init iov_kunit_extract_pages_xarray(struct kunit *test)
> +static void iov_kunit_extract_pages_xarray(struct kunit *test)
>  {
>  	const struct kvec_test_range *pr;
>  	struct iov_iter iter;
> @@ -756,7 +752,7 @@ static void __init iov_kunit_extract_pages_xarray(struct kunit *test)
>  	KUNIT_SUCCEED();
>  }
>  
> -static struct kunit_case __refdata iov_kunit_cases[] = {
> +static struct kunit_case iov_kunit_cases[] = {
>  	KUNIT_CASE(iov_kunit_copy_to_kvec),
>  	KUNIT_CASE(iov_kunit_copy_from_kvec),
>  	KUNIT_CASE(iov_kunit_copy_to_bvec),
> diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
> index 0b6488efed47..e1980ea58118 100644
> --- a/tools/testing/kunit/kunit_kernel.py
> +++ b/tools/testing/kunit/kunit_kernel.py
> @@ -104,12 +104,13 @@ class LinuxSourceTreeOperationsQemu(LinuxSourceTreeOperations):
>  		self._kconfig = qemu_arch_params.kconfig
>  		self._qemu_arch = qemu_arch_params.qemu_arch
>  		self._kernel_path = qemu_arch_params.kernel_path
> -		self._kernel_command_line = qemu_arch_params.kernel_command_line + ' kunit_shutdown=reboot'
> +		self._kernel_command_line = qemu_arch_params.kernel_command_line + ' kunit_shutdown=reboot rootfstype=tmpfs'
>  		self._extra_qemu_params = qemu_arch_params.extra_qemu_params
>  		self._serial = qemu_arch_params.serial
>  
>  	def make_arch_config(self, base_kunitconfig: kunit_config.Kconfig) -> kunit_config.Kconfig:
>  		kconfig = kunit_config.parse_from_string(self._kconfig)
> +		kconfig.add_entry('TMPFS', 'y')
>  		kconfig.merge_in_entries(base_kunitconfig)
>  		return kconfig
>  
> @@ -139,13 +140,14 @@ class LinuxSourceTreeOperationsUml(LinuxSourceTreeOperations):
>  
>  	def make_arch_config(self, base_kunitconfig: kunit_config.Kconfig) -> kunit_config.Kconfig:
>  		kconfig = kunit_config.parse_file(UML_KCONFIG_PATH)
> +		kconfig.add_entry('TMPFS', 'y')
>  		kconfig.merge_in_entries(base_kunitconfig)
>  		return kconfig
>  
>  	def start(self, params: List[str], build_dir: str) -> subprocess.Popen:
>  		"""Runs the Linux UML binary. Must be named 'linux'."""
>  		linux_bin = os.path.join(build_dir, 'linux')
> -		params.extend(['mem=1G', 'console=tty', 'kunit_shutdown=halt'])
> +		params.extend(['mem=1G', 'console=tty', 'kunit_shutdown=halt', 'rootfstype=tmpfs'])
>  		return subprocess.Popen([linux_bin] + params,
>  					   stdin=subprocess.PIPE,
>  					   stdout=subprocess.PIPE,
> -- 
> 2.44.0
> 

-- 
Kees Cook

