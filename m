Return-Path: <kvm+bounces-44630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86AEFA9FEE5
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6E294646A6
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 01:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B95C1953A1;
	Tue, 29 Apr 2025 01:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="386rQsjO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128BA84A3E
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 01:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745889553; cv=none; b=SukO6DOliE5NR46KDJffL3uzPqkyxJ/pTbwVzC/MegiGIYFtR2TjBUCbMN3a2/0RnN8ixtTcEdPGUZmjsPVZZtd+6MUsgq5hV/vRuMR+y6X47q02DWFaJV3AdgBbPrlk3Qy8glFZBCP81br/etFK1f39I+vI/JmTPtWdJq1Y2XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745889553; c=relaxed/simple;
	bh=8oSsZIRrhqgjMG9L29Y+UGuvrGWsxwTQz535yyZMwqQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ezAiG1tb4aGvI988jl4Wv2Srrg7yQTHbmjeZ/9wmoG/4LmeGsBd0AZys6WPcI+UtAo1+piyT1gko0YSrfVmSY2B8b3CQiv1vOSx5gUMRppnXyU7Q+CpSOrzApSs6dx6oXpQI4K9kC6f/P/nkuA5nZtm/UuO5qYqdLFiEyv5NRqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=386rQsjO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736c0306242so7201408b3a.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 18:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745889551; x=1746494351; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IgdQOgaoElQqRGycTH5PUw+/zFDYClhZUhKSCH+8S4I=;
        b=386rQsjO+nCy+CItozFbB0WsdccOGWrXAIVTy58x7N661m4alDxE9NZNFpAhPM0omf
         /062jViU5LyBdR0SxgM+/RIiFjdi9qQdAyLa8mNhbk3C1If6vbt1kTIo5EAB0n8IWGiy
         OzLU5iYx/KKOPboc3V5vHncbZn1c/59WTkAiowlI4gwZBAnGe6bgoPFPf+kkEaNA4c+E
         thS1aviAzX7ZWHrVfUuW4++Qad1OBsHsy8ekMKVCgHyfXgFCCnULWSO39iQ1cLxogzl3
         U2FvMz+O+suEzhRDUVvjfWfHja10tSomQ/RBotIZYUS88J8c3Q4T3iOJ4lWgg0PpYY0M
         HWlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745889551; x=1746494351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IgdQOgaoElQqRGycTH5PUw+/zFDYClhZUhKSCH+8S4I=;
        b=XnimYnWmHSfcjQpy7cuazzonx39RWCPn1+Ng0cbXLhOuhPGZN2cFNpi4pr20mMLS6V
         Oe6JrktXMrr2actrG1WHPdtWSuOhty1AFvMxZa47x5NqXF+HmtFflf+Oijjr6K2tHv3/
         7OQImFLI5OsNlFFfUYf05CkwdPYxGe9jTZBBv0+MKGpR4/XqPRhE4kGXm21ZPs71pwdp
         1domxfhnofVH3RxgcAALMCbjtSlE5Mjcm6rDGKIoRVTG4heVIXZUdtxsp2QOD211JKFZ
         kp2VDADFE8AqRbZz31CsZXEk5t9OywhqQYDl7Lw7oAg5hf6fjMpMspbZjlP++sbTCk7d
         yi/g==
X-Gm-Message-State: AOJu0Yx4MRTyp/jhPBFeD2xVc2NSk80/Yd72wjDE4F1UyUeuzIQoHibo
	evbon0FKN6mSh5CuXlvca882Nx27PZlsK0w9FCXI4nX58FbPV3diL+e2POUv9tmHhum7e8y6Edf
	oOA==
X-Google-Smtp-Source: AGHT+IFMVZIcEoYw8FABuJXXX8OutA5bqS+INEhWMiGnzilKwpVAX2SYR+yiUpwvIN/ITA/l63MsHdptzFA=
X-Received: from pfgu8.prod.google.com ([2002:a05:6a00:988:b0:737:6b9f:8ab4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:78b:b0:1f5:837b:1868
 with SMTP id adf61e73a8af0-2046a646b03mr15898790637.29.1745889551303; Mon, 28
 Apr 2025 18:19:11 -0700 (PDT)
Date: Mon, 28 Apr 2025 18:19:09 -0700
In-Reply-To: <20250414200929.3098202-6-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414200929.3098202-1-jthoughton@google.com> <20250414200929.3098202-6-jthoughton@google.com>
Message-ID: <aBApDSHblacSBaFH@google.com>
Subject: Re: [PATCH v3 5/5] KVM: selftests: access_tracking_perf_test: Use
 MGLRU for access tracking
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 14, 2025, James Houghton wrote:
> By using MGLRU's debugfs for invoking test_young() and clear_young(), we
> avoid page_idle's incompatibility with MGLRU, and we can mark pages as
> idle (clear_young()) much faster.
> 
> The ability to use page_idle is left in, as it is useful for kernels
> that do not have MGLRU built in. If MGLRU is enabled but is not usable
> (e.g. we can't access the debugfs mount), the test will fail, as
> page_idle is not compatible with MGLRU.
> 
> cgroup utility functions have been borrowed so that, when running with
> MGLRU, we can create a memcg in which to run our test.
> 
> Other MGLRU-debugfs-specific parsing code has been added to
> lru_gen_util.{c,h}.

This is not a proper changelog, at least not by upstream KVM standards.  Please
rewrite it describe the changes being made, using imperative mood/tone.  From
Documentation/process/maintainer-kvm-x86.rst:

  Changelog
  ~~~~~~~~~
  Most importantly, write changelogs using imperative mood and avoid pronouns.

> @@ -354,7 +459,12 @@ static int access_tracking_unreliable(void)
>  		puts("Skipping idle page count sanity check, because NUMA balancing is enabled");
>  		return 1;
>  	}
> +	return 0;
> +}
>  
> +int run_test_in_cg(const char *cgroup, void *arg)

static

> +{
> +	for_each_guest_mode(run_test, arg);

Having "separate" flows for MGLRU vs. page_idle is unnecessary.  Give the helper
a more common name and use it for both:

static int run_test_for_each_guest_mode(const char *cgroup, void *arg)
{
	for_each_guest_mode(run_test, arg);
	return 0;
}

>  	return 0;
>  }
>  
> @@ -372,7 +482,7 @@ static void help(char *name)
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> -	printf(" -w: Control whether the test warns or fails if more than 10%\n"
> +	printf(" -w: Control whether the test warns or fails if more than 10%%\n"
>  	       "     of pages are still seen as idle/old after accessing guest\n"
>  	       "     memory.  >0 == warn only, 0 == fail, <0 == auto.  For auto\n"
>  	       "     mode, the test fails by default, but switches to warn only\n"
> @@ -383,6 +493,12 @@ static void help(char *name)
>  	exit(0);
>  }
>  
> +void destroy_cgroup(char *cg)

static.  But this is a pointless wrapper, just delete it.

> +{
> +	printf("Destroying cgroup: %s\n", cg);
> +	cg_destroy(cg);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	struct test_params params = {
> @@ -390,6 +506,7 @@ int main(int argc, char *argv[])
>  		.vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
>  		.nr_vcpus = 1,
>  	};
> +	char *new_cg = NULL;
>  	int page_idle_fd;
>  	int opt;
>  
> @@ -424,15 +541,53 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> -	page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
> -	__TEST_REQUIRE(page_idle_fd >= 0,
> -		       "CONFIG_IDLE_PAGE_TRACKING is not enabled");
> -	close(page_idle_fd);
> +	if (lru_gen_usable()) {

Using MGLRU on my home box fails.  It's full cgroup v2, and has both
CONFIG_IDLE_PAGE_TRACKING=y and MGLRU enabled.

==== Test Assertion Failure ====
  access_tracking_perf_test.c:244: false
  pid=114670 tid=114670 errno=17 - File exists
     1	0x00000000004032a9: find_generation at access_tracking_perf_test.c:244
     2	0x00000000004032da: lru_gen_mark_memory_idle at access_tracking_perf_test.c:272
     3	0x00000000004034e4: mark_memory_idle at access_tracking_perf_test.c:391
     4	 (inlined by) run_test at access_tracking_perf_test.c:431
     5	0x0000000000403d84: for_each_guest_mode at guest_modes.c:96
     6	0x0000000000402c61: run_test_for_each_guest_mode at access_tracking_perf_test.c:492
     7	0x000000000041d8e2: cg_run at cgroup_util.c:382
     8	0x00000000004027fa: main at access_tracking_perf_test.c:572
     9	0x00007fa1cb629d8f: ?? ??:0
    10	0x00007fa1cb629e3f: ?? ??:0
    11	0x00000000004029d4: _start at ??:?
  Could not find a generation with 90% of guest memory (235929 pages).

Interestingly, if I force the test to use /sys/kernel/mm/page_idle/bitmap, it
passes.

Please try to reproduce the failure (assuming you haven't already tested that
exact combination of cgroups v2, MGLRU=y, and CONFIG_IDLE_PAGE_TRACKING=y). I
don't have bandwidth to dig any further at this time.

> +		if (cg_find_unified_root(cgroup_root, sizeof(cgroup_root), NULL))
> +			ksft_exit_skip("cgroup v2 isn't mounted\n");
> +
> +		new_cg = cg_name(cgroup_root, TEST_MEMCG_NAME);
> +		printf("Creating cgroup: %s\n", new_cg);
> +		if (cg_create(new_cg) && errno != EEXIST)
> +			ksft_exit_skip("could not create new cgroup: %s\n", new_cg);
> +
> +		use_lru_gen = true;
> +	} else {
> +		page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
> +		__TEST_REQUIRE(page_idle_fd >= 0,
> +			       "Couldn't open /sys/kernel/mm/page_idle/bitmap. "
> +			       "Is CONFIG_IDLE_PAGE_TRACKING enabled?");
> +
> +		close(page_idle_fd);
> +	}

Splitting the "check" and "execute" into separate if-else statements results in
some compilers complaining about new_cg possibly being unused.  The compiler is
probably being a bit stupid, but the code is just as must to blame.  There's zero
reason to split this in two, just do everything after the idle_pages_warn_only
and total_pages processing.  Code at the bottom (note, you'll have to rebase on
my not-yet-posted series, or undo the use of __open_path_or_exit()).

>  
>  	if (idle_pages_warn_only == -1)
>  		idle_pages_warn_only = access_tracking_unreliable();
>  
> -	for_each_guest_mode(run_test, &params);
> +	/*
> +	 * If guest_page_size is larger than the host's page size, the
> +	 * guest (memstress) will only fault in a subset of the host's pages.
> +	 */
> +	total_pages = params.nr_vcpus * params.vcpu_memory_bytes /
> +		      max(memstress_args.guest_page_size,
> +			  (uint64_t)getpagesize());
> +
> +	if (use_lru_gen) {
> +		int ret;
> +
> +		puts("Using lru_gen for aging");
> +		/*
> +		 * This will fork off a new process to run the test within
> +		 * a new memcg, so we need to properly propagate the return
> +		 * value up.
> +		 */
> +		ret = cg_run(new_cg, &run_test_in_cg, &params);
> +		destroy_cgroup(new_cg);
> +		if (ret)
> +			return ret;
> +	} else {
> +		puts("Using page_idle for aging");
> +		for_each_guest_mode(run_test, &params);
> +	}

static int run_test_for_each_guest_mode(const char *cgroup, void *arg)
{
	for_each_guest_mode(run_test, arg);
	return 0;
}

int main(int argc, char *argv[])
{
	struct test_params params = {
		.backing_src = DEFAULT_VM_MEM_SRC,
		.vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
		.nr_vcpus = 1,
	};
	int page_idle_fd;
	int opt;

	guest_modes_append_default();

	while ((opt = getopt(argc, argv, "hm:b:v:os:w:")) != -1) {
		switch (opt) {
		case 'm':
			guest_modes_cmdline(optarg);
			break;
		case 'b':
			params.vcpu_memory_bytes = parse_size(optarg);
			break;
		case 'v':
			params.nr_vcpus = atoi_positive("Number of vCPUs", optarg);
			break;
		case 'o':
			overlap_memory_access = true;
			break;
		case 's':
			params.backing_src = parse_backing_src_type(optarg);
			break;
		case 'w':
			idle_pages_warn_only =
				atoi_non_negative("Idle pages warning",
						  optarg);
			break;
		case 'h':
		default:
			help(argv[0]);
			break;
		}
	}

	if (idle_pages_warn_only == -1)
		idle_pages_warn_only = access_tracking_unreliable();

	/*
	 * If guest_page_size is larger than the host's page size, the
	 * guest (memstress) will only fault in a subset of the host's pages.
	 */
	total_pages = params.nr_vcpus * params.vcpu_memory_bytes /
		      max_t(uint64_t, memstress_args.guest_page_size, getpagesize());

	if (lru_gen_usable()) {
		bool cg_created = true;
		char *test_cg = NULL;
		int ret;

		puts("Using lru_gen for aging");
		use_lru_gen = true;

		if (cg_find_controller_root(cgroup_root, sizeof(cgroup_root), "memory"))
			ksft_exit_skip("Cannot find memory group controller\n");

		test_cg = cg_name(cgroup_root, TEST_MEMCG_NAME);
		printf("Creating cgroup: %s\n", test_cg);
		if (cg_create(test_cg)) {
			if (errno == EEXIST)
				cg_created = false;
			else
				ksft_exit_skip("could not create new cgroup: %s\n", test_cg);
		}

		/*
		 * This will fork off a new process to run the test within
		 * a new memcg, so we need to properly propagate the return
		 * value up.
		 */
		ret = cg_run(test_cg, &run_test_for_each_guest_mode, &params);
		if (cg_created)
			cg_destroy(test_cg);
		return ret;
	}

	puts("Using page_idle for aging");
	page_idle_fd = __open_path_or_exit("/sys/kernel/mm/page_idle/bitmap", O_RDWR,
					   "Is CONFIG_IDLE_PAGE_TRACKING enabled?");
	close(page_idle_fd);
	run_test_for_each_guest_mode(NULL, &params);
	return 0;
}

