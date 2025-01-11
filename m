Return-Path: <kvm+bounces-35139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15593A09F0C
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 248D63A3D51
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D05A55;
	Sat, 11 Jan 2025 00:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uJMbi2zn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410497E1
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736554334; cv=none; b=ir31lptlEkQ/9M+G/1WVmHOGovq1v0Yb3/6aBB5Exq9Yg/OFrG3aP9GbnOY2AHzIPnPrZ55Jyz39F/hqzPSoiBJmw3AbR+zDSi2XroYXaimghIRK/KIvEE+IswxtM/5NMzbPAYAF7i96UZOTl6bo4U1Lb+Za+pdQj2CjgpvUJ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736554334; c=relaxed/simple;
	bh=zRUq8o8MbtArGj0SdDlIAh6WNMHNVFu9KyiKnCsTgBw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UPLbyyFWsSSKosVz8bAerrJLzESunkNwLhdISTFxmcEd6hdmyh/u0NGvrpNKr5YeBUiXan6tw+/Ekn+D8/sD3ys9meQBSO4rrebwpG9NJ0yKUdlOppGzmaXpb7ifAtIGAjh14tAwVRAz00/3JZIRNwaTOqpzZAvf/HAPTR9yomI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uJMbi2zn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef35de8901so4517960a91.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736554331; x=1737159131; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i35jKTWqRNl/MdHYB2XImKJRFZJtdK332egjSF7ps50=;
        b=uJMbi2zn+UPidbr2EODdbv6/duK0n0XOjK+iWwxecR89jGESb/hvPh/Al+Sy/AxpX4
         STaLzHNOmulIjJI8jt1dnI671PQoNf19EiFraZpVIGjTh0Ukrl9O/weJAe1I9TFgT+G1
         0ghRrrZOGm6d7ya5qpgEQjQ/yR3DnJzGIgOc1x+jzF+ljlS3veOC3q28jc3kYcnxICZq
         vVttcdemoQOpn97dk1V5dVFaCxDReJuMznjjDvbzruri//WpDq9HxQvTduSyFQ6WZcFG
         ovYYf5i5Yu3zVtyPM9ig2JJCnI8wtOS50SHajHvpcNd6hcE2M2SV3MxzLjN17UzMPYnE
         rx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736554331; x=1737159131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i35jKTWqRNl/MdHYB2XImKJRFZJtdK332egjSF7ps50=;
        b=cQVvlCIndpaL1vNB6nFeMYdBmRA7UwV5qHQw2UgM34pV10+mZnSr34S3a2x2Ub+PZ6
         kH4HqLT5WgvpanLyHeyyUW+EsXilq44mqPdA0W0WRCvgcAcPvto1OL0CSQwYO4vNCz0F
         tbLLqjweKDl0kSLpB8oSFrFVGPHs0LB1HOADzrW3eVp3IGm22UHcl5iF4AVjOPy141OZ
         xUegxrEPC1RGUDGU1TorHqJdcyzOq1aiBDmIJjlBZZ1SYqIZkrvRjF46SOiXrxKB3D1Y
         +oM9Pe6cfAwgdA7WhFySi3AigX4/+G2YO5SYDKk6hd/tQBEw5P8HxAFjnxBxhU9xwlqU
         FY4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWeIWouhjrhZO97wLxZAayfd/F6AjZGxKxb45gcLZi+LgcKTvRkFAXzZw/eE1h9uXo6Klk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzB4/jngW+XuIQitE+8lbfXtW20JMqJ/eBu1zMJBplEQZb2Xafm
	irjQ+1Tvw9q/GzCVu4fThjsLWxzlQTCQbG0BWbStPZfGI827GIePH0iLRp2vCOjzecjJ6NN4Bqz
	5aQ==
X-Google-Smtp-Source: AGHT+IFuRG/K4kTsW4QAulVIVS/RRpGYBgg/3860TnAgIuAn5ZzT6sEdRdBeQ9K5Y/U7tSRq5GWGPb4qp1w=
X-Received: from pjboi12.prod.google.com ([2002:a17:90b:3a0c:b0:2eb:12c1:bf8f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b8b:b0:2ee:d824:b594
 with SMTP id 98e67ed59e1d1-2f548f761d7mr16535890a91.31.1736554331609; Fri, 10
 Jan 2025 16:12:11 -0800 (PST)
Date: Fri, 10 Jan 2025 16:12:10 -0800
In-Reply-To: <20241105184333.2305744-12-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-12-jthoughton@google.com>
Message-ID: <Z4G3Wny5N-NC3fB1@google.com>
Subject: Re: [PATCH v8 11/11] KVM: selftests: Add multi-gen LRU aging to access_tracking_perf_test
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

This can/should be posted separately, no?  MGLRU support for secondary MMUs went
through mm/, the KVM changes in this series are all about making KVM x86 faster.

On Tue, Nov 05, 2024, James Houghton wrote:
> This test now has two modes of operation:

Bad Google3, bad!  Write changelogs as commands, i.e. state what the patch is
doing.  The above is also misleading (at least, it was to me), as I assumed one
of the modes would be "legacy" and the other would be MGLRU.  But it looks like
this patch adds MGLRU support *and* benchmarking.

This should be split into at least two patches, possibly three (I can't tell how
much pre-work there is).  I.e. add MGLRU support, and then add the benchmarking
stuff.  And if there's substantial refactoring and/or new utilities, do that first.

> 1. (default) To check how much vCPU performance was affected by access
>              tracking (previously existed, now supports MGLRU aging).
> 2. (-p) To also benchmark how fast MGLRU can do aging while vCPUs are
>         faulting in memory.
> 
> Mode (1) also serves as a way to verify that aging is working properly
> for pages only accessed by KVM.  It will fail if one does not have the

"one" what?

> 0x8 lru_gen feature bit.
> 
> To support MGLRU, the test creates a memory cgroup, moves itself into
> it, then uses the lru_gen debugfs output to track memory in that cgroup.
> The logic to parse the lru_gen debugfs output has been put into
> selftests/kvm/lib/lru_gen_util.c.
>
> Co-developed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>

...

> @@ -47,6 +48,19 @@
>  #include "memstress.h"
>  #include "guest_modes.h"
>  #include "processor.h"
> +#include "lru_gen_util.h"
> +
> +static const char *TEST_MEMCG_NAME = "access_tracking_perf_test";
> +static const int LRU_GEN_ENABLED = 0x1;
> +static const int LRU_GEN_MM_WALK = 0x2;

Is there really no uAPI #define for these?

> +static const char *CGROUP_PROCS = "cgroup.procs";
> +/*
> + * If using MGLRU, this test assumes a cgroup v2 or cgroup v1 memory hierarchy

I would say "requires", not "assumes".

> + * is mounted at cgroup_root.
> + *
> + * Can be changed with -r.

This is amusingly vague.  I vote to omit explicitly referencing the command line
option, we have enough problems maintaining them as it is.  Instead simply say
something like "Default to the kernel's preferred path for mounting cgroups" to
both explain where the default comes from, and to give the reader a hint that the
path can be changed.

Actually, there's zero reason for this to be global.  More below.

Ugh, and if this test is manipulating cgroups, won't it need to root?  I doubt
y'all have tried to run this outside of devrez, i.e. on a system where you're
not logged in as root.

Oh, never mind, this test already effectively requires root.

> +	/* Whether to use lru_gen aging instead of idle page tracking. */
> +	bool lru_gen;

Needs a verb, otherwise this looks like it tracks the LRU generation.  E.g. use_lru_gen.

> +
> +	/* Whether to test the performance of aging itself. */
> +	bool benchmark_lru_gen;
>  };
>  
>  static uint64_t pread_uint64(int fd, const char *filename, uint64_t index)
> @@ -89,6 +112,50 @@ static uint64_t pread_uint64(int fd, const char *filename, uint64_t index)
>  
>  }
>  
> +static void write_file_long(const char *path, long v)
> +{
> +	FILE *f;
> +
> +	f = fopen(path, "w");
> +	TEST_ASSERT(f, "fopen(%s) failed", path);
> +	TEST_ASSERT(fprintf(f, "%ld\n", v) > 0,
> +		    "fprintf to %s failed", path);
> +	TEST_ASSERT(!fclose(f), "fclose(%s) failed", path);
> +}
> +
> +static char *path_join(const char *parent, const char *child)
> +{
> +	char *out = NULL;
> +
> +	return asprintf(&out, "%s/%s", parent, child) >= 0 ? out : NULL;
> +}

These are common utilities, no?  I.e. should be somewhere common, not buried in
this test.

> +
> +static char *memcg_path(const char *memcg)
> +{
> +	return path_join(cgroup_root, memcg);

Eh, do the join when cgroup_root is first defined.  Actually, looking at the
usage more closely, the cgroup path is only used during main().  Just do all of
the joins there, I see no reason to have these one-off helpers.

> +}
> +
> +static char *memcg_file_path(const char *memcg, const char *file)
> +{
> +	char *mp = memcg_path(memcg);
> +	char *fp;
> +
> +	if (!mp)
> +		return NULL;

Returning NULL just so that the one user can assert on !NULL is rather pointless.

> +	fp = path_join(mp, file);
> +	free(mp);
> +	return fp;
> +}
> +
> +static void move_to_memcg(const char *memcg, pid_t pid)
> +{
> +	char *procs = memcg_file_path(memcg, CGROUP_PROCS);
> +
> +	TEST_ASSERT(procs, "Failed to construct cgroup.procs path");
> +	write_file_long(procs, pid);
> +	free(procs);
> +}
> +
>  #define PAGEMAP_PRESENT (1ULL << 63)
>  #define PAGEMAP_PFN_MASK ((1ULL << 55) - 1)
>  
> @@ -242,6 +309,8 @@ static void vcpu_thread_main(struct memstress_vcpu_args *vcpu_args)
>  		};
>  
>  		vcpu_last_completed_iteration[vcpu_idx] = current_iteration;
> +		clock_gettime(CLOCK_MONOTONIC,
> +			      &vcpu_last_completed_time[vcpu_idx]);
>  	}
>  }
>  
> @@ -253,38 +322,68 @@ static void spin_wait_for_vcpu(int vcpu_idx, int target_iteration)
>  	}
>  }
>  
> +static bool all_vcpus_done(int target_iteration, int nr_vcpus)
> +{
> +	for (int i = 0; i < nr_vcpus; ++i)

Preferred style is to declare variables outside of loops.

Needs curly braces.

> +		if (READ_ONCE(vcpu_last_completed_iteration[i]) !=
> +		    target_iteration)

Don't wrap.

> +			return false;
> +
> +	return true;
> +}
> +
>  /* The type of memory accesses to perform in the VM. */
>  enum access_type {
>  	ACCESS_READ,
>  	ACCESS_WRITE,
>  };
>  
> -static void run_iteration(struct kvm_vm *vm, int nr_vcpus, const char *description)
> +static void run_iteration(struct kvm_vm *vm, int nr_vcpus, const char *description,
> +			  bool wait)
>  {
> -	struct timespec ts_start;
> -	struct timespec ts_elapsed;
>  	int next_iteration, i;
>  
>  	/* Kick off the vCPUs by incrementing iteration. */
>  	next_iteration = ++iteration;
>  
> -	clock_gettime(CLOCK_MONOTONIC, &ts_start);
> -
>  	/* Wait for all vCPUs to finish the iteration. */
> -	for (i = 0; i < nr_vcpus; i++)
> -		spin_wait_for_vcpu(i, next_iteration);
> +	if (wait) {
> +		struct timespec ts_start;
> +		struct timespec ts_elapsed;
> +
> +		clock_gettime(CLOCK_MONOTONIC, &ts_start);
>  
> -	ts_elapsed = timespec_elapsed(ts_start);
> -	pr_info("%-30s: %ld.%09lds\n",
> -		description, ts_elapsed.tv_sec, ts_elapsed.tv_nsec);
> +		for (i = 0; i < nr_vcpus; i++)
> +			spin_wait_for_vcpu(i, next_iteration);
> +
> +		ts_elapsed = timespec_elapsed(ts_start);
> +
> +		pr_info("%-30s: %ld.%09lds\n",
> +			description, ts_elapsed.tv_sec, ts_elapsed.tv_nsec);
> +	} else

Needs curly braces.

> +		pr_info("%-30s\n", description);
>  }
>  
> -static void access_memory(struct kvm_vm *vm, int nr_vcpus,
> -			  enum access_type access, const char *description)
> +static void _access_memory(struct kvm_vm *vm, int nr_vcpus,

Use double underscores (ignore any precedent in selftests that uses just one,
we're trying to purge that ugliness).

> +			   enum access_type access, const char *description,
> +			   bool wait)
>  {
>  	memstress_set_write_percent(vm, (access == ACCESS_READ) ? 0 : 100);
>  	iteration_work = ITERATION_ACCESS_MEMORY;
> -	run_iteration(vm, nr_vcpus, description);
> +	run_iteration(vm, nr_vcpus, description, wait);
> +}
> +
> +static void access_memory(struct kvm_vm *vm, int nr_vcpus,
> +			  enum access_type access, const char *description)
> +{
> +	return _access_memory(vm, nr_vcpus, access, description, true);
> +}
> +
> +static void access_memory_async(struct kvm_vm *vm, int nr_vcpus,

Maybe "nowait" instead of "async"?  Yeah, something ends up being asynchronous
(presumably), but the call itself is "synchronous", i.e. isn't spun off to a
worker or anything.

> +				enum access_type access,
> +				const char *description)
> +{
> +	return _access_memory(vm, nr_vcpus, access, description, false);
>  }
>  
>  static void mark_memory_idle(struct kvm_vm *vm, int nr_vcpus)
> @@ -297,19 +396,115 @@ static void mark_memory_idle(struct kvm_vm *vm, int nr_vcpus)
>  	 */
>  	pr_debug("Marking VM memory idle (slow)...\n");
>  	iteration_work = ITERATION_MARK_IDLE;
> -	run_iteration(vm, nr_vcpus, "Mark memory idle");
> +	run_iteration(vm, nr_vcpus, "Mark memory idle", true);
>  }
>  
> -static void run_test(enum vm_guest_mode mode, void *arg)
> +static void create_memcg(const char *memcg)
> +{
> +	const char *full_memcg_path = memcg_path(memcg);
> +	int ret;
> +
> +	TEST_ASSERT(full_memcg_path, "Failed to construct full memcg path");
> +retry:
> +	ret = mkdir(full_memcg_path, 0755);
> +	if (ret && errno == EEXIST) {
> +		TEST_ASSERT(!rmdir(full_memcg_path),
> +			    "Found existing memcg at %s, but rmdir failed",
> +			    full_memcg_path);
> +		goto retry;

	while (1) {
		ret = mkdir(full_memcg_path, 0755);
		if (!ret)
			break;

		TEST_ASSERT(errno == EEXIST,
			    Creating the memcg via 'mkdir(%s)' failed",
			    full_memcg_path);

		TEST_ASSERT(!rmdir(full_memcg_path),
			    "Found existing memcg at %s, but rmdir failed",
			    full_memcg_path);
	}

> +	}
> +	TEST_ASSERT(!ret, "Creating the memcg failed: mkdir(%s) failed",

Heh, so it failed?

> +		    full_memcg_path);
> +
> +	pr_info("Created memcg at %s\n", full_memcg_path);
> +}

...

> +/*
> + * Test how much access tracking affects vCPU performance.
> + *
> + * Supports two modes of access tracking:
> + * - idle page tracking
> + * - lru_gen aging
> + *
> + * When using lru_gen, this test additionally verifies that the pages are in
> + * fact getting younger and older, otherwise the performance data would be
> + * invalid.
> + *
> + * The forced lru_gen aging can race with aging that occurs naturally.
> + */
> +static void run_test(enum vm_guest_mode mode, struct kvm_vm *vm,
> +		     struct test_params *params)
> +{
> +	int nr_vcpus = params->nr_vcpus;
> +	bool lru_gen = params->lru_gen;
> +	struct memcg_stats stats;
> +	// If guest_page_size is larger than the host's page size, the
> +	// guest (memstress) will only fault in a subset of the host's pages.

No C++ comments, please.

> +	long total_pages = nr_vcpus * params->vcpu_memory_bytes /
> +			   max(memstress_args.guest_page_size,
> +			       (uint64_t)getpagesize());

max_t() is probably better.

> +	int found_gens[5];
>  
>  	pr_info("\n");
>  	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Populating memory");
> @@ -319,11 +514,78 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from populated memory");
>  
>  	/* Repeat on memory that has been marked as idle. */
> -	mark_memory_idle(vm, nr_vcpus);
> +	if (lru_gen) {
> +		/* Do an initial page table scan */
> +		lru_gen_do_aging(&stats, TEST_MEMCG_NAME);
> +		TEST_ASSERT(sum_memcg_stats(&stats) >= total_pages,
> +		  "Not all pages tracked in lru_gen stats.\n"
> +		  "Is lru_gen enabled? Did the memcg get created properly?");

Align indentation.

		TEST_ASSERT(sum_memcg_stats(&stats) >= total_pages,
			    "Not all pages tracked in lru_gen stats.\n"
			    "Is lru_gen enabled? Did the memcg get created properly?");

> +
> +		/* Find the generation we're currently in (probably youngest) */
> +		found_gens[0] = lru_gen_find_generation(&stats, total_pages);
> +
> +		/* Do an aging pass now */
> +		lru_gen_do_aging(&stats, TEST_MEMCG_NAME);
> +
> +		/* Same generation, but a newer generation has been made */
> +		found_gens[1] = lru_gen_find_generation(&stats, total_pages);
> +		TEST_ASSERT(found_gens[1] == found_gens[0],
> +			    "unexpected gen change: %d vs. %d",
> +			    found_gens[1], found_gens[0]);

I don't have any ideas off the top of my head, but there's gotta be a way to
dedup these blocks.

> +	} else

Needs curly braces.

> +		mark_memory_idle(vm, nr_vcpus);
> +
>  	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Writing to idle memory");
> -	mark_memory_idle(vm, nr_vcpus);
> +
> +	if (lru_gen) {
> +		/* Scan the page tables again */
> +		lru_gen_do_aging(&stats, TEST_MEMCG_NAME);
> +
> +		/* The pages should now be young again, so in a newer generation */
> +		found_gens[2] = lru_gen_find_generation(&stats, total_pages);
> +		TEST_ASSERT(found_gens[2] > found_gens[1],
> +			    "pages did not get younger");
> +
> +		/* Do another aging pass */
> +		lru_gen_do_aging(&stats, TEST_MEMCG_NAME);
> +
> +		/* Same generation; new generation has been made */
> +		found_gens[3] = lru_gen_find_generation(&stats, total_pages);
> +		TEST_ASSERT(found_gens[3] == found_gens[2],
> +			    "unexpected gen change: %d vs. %d",
> +			    found_gens[3], found_gens[2]);
> +	} else

Once more, with feeling!

> +		mark_memory_idle(vm, nr_vcpus);
> +
>  	access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from idle memory");
>  
> +	if (lru_gen) {
> +		/* Scan the pages tables again */
> +		lru_gen_do_aging(&stats, TEST_MEMCG_NAME);
> +
> +		/* The pages should now be young again, so in a newer generation */
> +		found_gens[4] = lru_gen_find_generation(&stats, total_pages);
> +		TEST_ASSERT(found_gens[4] > found_gens[3],
> +			    "pages did not get younger");
> +	}
> +}

...

> @@ -353,13 +618,15 @@ int main(int argc, char *argv[])
>  		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
>  		.nr_vcpus = 1,
> +		.lru_gen = false,
> +		.benchmark_lru_gen = false,
>  	};
>  	int page_idle_fd;
>  	int opt;
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "hm:b:v:os:")) != -1) {
> +	while ((opt = getopt(argc, argv, "hm:b:v:os:lr:p")) != -1) {
>  		switch (opt) {
>  		case 'm':
>  			guest_modes_cmdline(optarg);
> @@ -376,6 +643,15 @@ int main(int argc, char *argv[])
>  		case 's':
>  			params.backing_src = parse_backing_src_type(optarg);
>  			break;
> +		case 'l':
> +			params.lru_gen = true;
> +			break;
> +		case 'p':
> +			params.benchmark_lru_gen = true;
> +			break;
> +		case 'r':
> +			cgroup_root = strdup(optarg);
> +			break;
>  		case 'h':
>  		default:
>  			help(argv[0]);
> @@ -383,12 +659,42 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> -	page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
> -	__TEST_REQUIRE(page_idle_fd >= 0,
> -		       "CONFIG_IDLE_PAGE_TRACKING is not enabled");
> -	close(page_idle_fd);
> +	if (!params.lru_gen) {
> +		page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
> +		__TEST_REQUIRE(page_idle_fd >= 0,
> +			       "CONFIG_IDLE_PAGE_TRACKING is not enabled");
> +		close(page_idle_fd);
> +	} else {
> +		int lru_gen_fd, lru_gen_debug_fd;
> +		long mglru_features;
> +		char mglru_feature_str[8] = {};
> +
> +		lru_gen_fd = open("/sys/kernel/mm/lru_gen/enabled", O_RDONLY);
> +		__TEST_REQUIRE(lru_gen_fd >= 0,
> +			       "CONFIG_LRU_GEN is not enabled");

Noooo!  Do not assume opening a path failed because some config option.  That
reminds me, this needs to be rewritten.  I can't count the number of times this
stupid test has oh so helpfully told me CONFIG_IDLE_PAGE_TRACKING is disabled,
when in fact the problem is that I didn't run it as root.

		page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
		__TEST_REQUIRE(page_idle_fd >= 0,
			       "CONFIG_IDLE_PAGE_TRACKING is not enabled");


By all means, give the user a hint, but don't assume anything.  E.g.

		page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
		__TEST_REQUIRE(page_idle_fd >= 0,
			       "Failed to open blah blah blah, is CONFIG_IDLE_PAGE_TRACKING enabled?");

> +		TEST_ASSERT(read(lru_gen_fd, &mglru_feature_str, 7) > 0,
> +				 "couldn't read lru_gen features");
> +		mglru_features = strtol(mglru_feature_str, NULL, 16);
> +		__TEST_REQUIRE(mglru_features & LRU_GEN_ENABLED,
> +			       "lru_gen is not enabled");
> +		__TEST_REQUIRE(mglru_features & LRU_GEN_MM_WALK,
> +			       "lru_gen does not support MM_WALK");
> +
> +		lru_gen_debug_fd = open(DEBUGFS_LRU_GEN, O_RDWR);
> +		__TEST_REQUIRE(lru_gen_debug_fd >= 0,
> +				"Cannot access %s", DEBUGFS_LRU_GEN);
> +		close(lru_gen_debug_fd);
> +	}
> +
> +	TEST_ASSERT(!params.benchmark_lru_gen || params.lru_gen,
> +		    "-p specified without -l");
> +
> +	if (params.lru_gen) {
> +		create_memcg(TEST_MEMCG_NAME);
> +		move_to_memcg(TEST_MEMCG_NAME, getpid());

After this, cgroup_root is never used.  Hint, hint.

> +	}
>  
> -	for_each_guest_mode(run_test, &params);
> +	for_each_guest_mode(setup_vm_and_run, &params);
>  
>  	return 0;
>  }
> diff --git a/tools/testing/selftests/kvm/include/lru_gen_util.h b/tools/testing/selftests/kvm/include/lru_gen_util.h
> new file mode 100644
> index 000000000000..4eef8085a3cb
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/lru_gen_util.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Tools for integrating with lru_gen, like parsing the lru_gen debugfs output.
> + *
> + * Copyright (C) 2024, Google LLC.
> + */
> +#ifndef SELFTEST_KVM_LRU_GEN_UTIL_H
> +#define SELFTEST_KVM_LRU_GEN_UTIL_H
> +
> +#include <inttypes.h>
> +#include <limits.h>
> +#include <stdlib.h>
> +
> +#include "test_util.h"
> +
> +#define MAX_NR_GENS 16 /* MAX_NR_GENS in include/linux/mmzone.h */
> +#define MAX_NR_NODES 4 /* Maximum number of nodes we support */

Who is "we"?  KVM selftests?  Kernel?
> +
> +static const char *DEBUGFS_LRU_GEN = "/sys/kernel/debug/lru_gen";

So, root again?  

> +
> +struct generation_stats {
> +	int gen;
> +	long age_ms;
> +	long nr_anon;
> +	long nr_file;
> +};
> +
> +struct node_stats {
> +	int node;
> +	int nr_gens; /* Number of populated gens entries. */
> +	struct generation_stats gens[MAX_NR_GENS];
> +};
> +
> +struct memcg_stats {
> +	unsigned long memcg_id;
> +	int nr_nodes; /* Number of populated nodes entries. */
> +	struct node_stats nodes[MAX_NR_NODES];
> +};
> +
> +void print_memcg_stats(const struct memcg_stats *stats, const char *name);
> +
> +void read_memcg_stats(struct memcg_stats *stats, const char *memcg);
> +
> +void read_print_memcg_stats(struct memcg_stats *stats, const char *memcg);

These need lru_gen_ namespacing.  As is, they are very, very misleading names.
They don't read core memcg stuff, they read LRU_GEN stuff, which AFAICT happens
to be indexed by the memcg name.

> +static void memcg_stats_handle_in_node(struct memcg_stats *stats,
> +				       struct memcg_stats_parse_context *ctx,
> +				       char *line)
> +{
> +	/* Have to copy since we might not consume */

Huh?

> +	char *my_line = strdup(line);
> +	struct split_iterator it = { .str = my_line };
> +	char *gen, *age, *nr_anon, *nr_file;
> +	struct node_stats *node_stats;
> +	struct generation_stats *gen_stats;
> +	char *end;
> +
> +	TEST_ASSERT(it.str, "failed to copy input line");
> +
> +	gen = split_next(&it);
> +
> +	/* Skip empty lines */
> +	if (!gen)
> +		goto out_consume; /* Skip empty lines */

If you say it three times, it might happen!  (Can you tell it's Friday afternoon?)

> +	if (!strcmp("memcg", gen) || !strcmp("node", gen)) {
> +		/*
> +		 * Reached next memcg or node section. Don't consume, let the
> +		 * other handler deal with this.
> +		 */
> +		ctx->next_handler = memcg_stats_handle_in_memcg;
> +		goto out;
> +	}

...

> +void print_memcg_stats(const struct memcg_stats *stats, const char *name)
> +{
> +	int node, gen;
> +
> +	fprintf(stderr, "stats for memcg %s (id %lu):\n",

Why stderr?  This is effectively wrapped with DEBUG, so why not pr_debug()?

> +			name, stats->memcg_id);
> +	for (node = 0; node < stats->nr_nodes; ++node) {
> +		fprintf(stderr, "\tnode %d\n", stats->nodes[node].node);
> +		for (gen = 0; gen < stats->nodes[node].nr_gens; ++gen) {
> +			const struct generation_stats *gstats =
> +				&stats->nodes[node].gens[gen];
> +
> +			fprintf(stderr,
> +				"\t\tgen %d\tage_ms %ld"
> +				"\tnr_anon %ld\tnr_file %ld\n",
> +				gstats->gen, gstats->age_ms, gstats->nr_anon,
> +				gstats->nr_file);
> +		}
> +	}
> +}
> +
> +/* Re-read lru_gen debugfs information for @memcg into @stats. */
> +void read_memcg_stats(struct memcg_stats *stats, const char *memcg)
> +{
> +	FILE *f;
> +	ssize_t read = 0;
> +	char *line = NULL;
> +	size_t bufsz;
> +	struct memcg_stats_parse_context ctx = {
> +		.next_handler = memcg_stats_handle_searching,
> +		.name = memcg,
> +	};
> +
> +	memset(stats, 0, sizeof(struct memcg_stats));
> +
> +	f = fopen(DEBUGFS_LRU_GEN, "r");
> +	TEST_ASSERT(f, "fopen(%s) failed", DEBUGFS_LRU_GEN);
> +
> +	while (ctx.next_handler && (read = getline(&line, &bufsz, f)) > 0) {
> +		ctx.consumed = false;
> +
> +		do {
> +			ctx.next_handler(stats, &ctx, line);
> +			if (!ctx.next_handler)
> +				break;
> +		} while (!ctx.consumed);
> +	}
> +
> +	if (read < 0 && !feof(f))
> +		TEST_ASSERT(false, "getline(%s) failed", DEBUGFS_LRU_GEN);
> +
> +	TEST_ASSERT(stats->memcg_id > 0, "Couldn't find memcg: %s\n"
> +		    "Did the memcg get created in the proper mount?",
> +		    memcg);
> +	if (line)
> +		free(line);
> +	TEST_ASSERT(!fclose(f), "fclose(%s) failed", DEBUGFS_LRU_GEN);
> +}
> +
> +/*
> + * Find all pages tracked by lru_gen for this memcg in generation @target_gen.
> + *
> + * If @target_gen is negative, look for all generations.
> + */
> +static long sum_memcg_stats_for_gen(int target_gen,
> +				    const struct memcg_stats *stats)
> +{
> +	int node, gen;
> +	long total_nr = 0;
> +
> +	for (node = 0; node < stats->nr_nodes; ++node) {
> +		const struct node_stats *node_stats = &stats->nodes[node];
> +
> +		for (gen = 0; gen < node_stats->nr_gens; ++gen) {
> +			const struct generation_stats *gen_stats =
> +				&node_stats->gens[gen];
> +
> +			if (target_gen >= 0 && gen_stats->gen != target_gen)
> +				continue;
> +
> +			total_nr += gen_stats->nr_anon + gen_stats->nr_file;
> +		}
> +	}
> +
> +	return total_nr;
> +}
> +
> +/* Find all pages tracked by lru_gen for this memcg. */
> +long sum_memcg_stats(const struct memcg_stats *stats)
> +{
> +	return sum_memcg_stats_for_gen(-1, stats);
> +}
> +
> +/* Read the memcg stats and optionally print if this is a debug build. */
> +void read_print_memcg_stats(struct memcg_stats *stats, const char *memcg)
> +{
> +	read_memcg_stats(stats, memcg);
> +#ifdef DEBUG
> +	print_memcg_stats(stats, memcg);

print_memcg_stats() should be static, because this is the only caller.  But I'm
guessing you made it globally visible so that the compiler wouldn't complain
about unused functions.  A better approach would be to wrap the guts with the
#ifdef.

> +#endif
> +}
> +
> +/*
> + * If lru_gen aging should force page table scanning.
> + *
> + * If you want to set this to false, you will need to do eviction
> + * before doing extra aging passes.
> + */
> +static const bool force_scan = true;
> +
> +static void run_aging_impl(unsigned long memcg_id, int node_id, int max_gen)
> +{
> +	FILE *f = fopen(DEBUGFS_LRU_GEN, "w");
> +	char *command;
> +	size_t sz;
> +
> +	TEST_ASSERT(f, "fopen(%s) failed", DEBUGFS_LRU_GEN);
> +	sz = asprintf(&command, "+ %lu %d %d 1 %d\n",
> +		      memcg_id, node_id, max_gen, force_scan);
> +	TEST_ASSERT(sz > 0, "creating aging command failed");
> +
> +	pr_debug("Running aging command: %s", command);
> +	if (fwrite(command, sizeof(char), sz, f) < sz) {
> +		TEST_ASSERT(false, "writing aging command %s to %s failed",
> +			    command, DEBUGFS_LRU_GEN);
> +	}
> +
> +	TEST_ASSERT(!fclose(f), "fclose(%s) failed", DEBUGFS_LRU_GEN);
> +}
> +
> +static void _lru_gen_do_aging(struct memcg_stats *stats, const char *memcg,

Two underscores.

> +/* Do aging, and print how long it took. */
> +void lru_gen_do_aging(struct memcg_stats *stats, const char *memcg)
> +{
> +	return _lru_gen_do_aging(stats, memcg, true);
> +}
> +
> +/* Do aging, don't print anything. */
> +void lru_gen_do_aging_quiet(struct memcg_stats *stats, const char *memcg)
> +{
> +	return _lru_gen_do_aging(stats, memcg, false);

static inline helpers in the header?  Having to come all this way to see that
these are simple wrapper is annoying.

> +}
> +
> +/*
> + * Find which generation contains more than half of @total_pages, assuming that
> + * such a generation exists.
> + */
> +int lru_gen_find_generation(const struct memcg_stats *stats,
> +			    unsigned long total_pages)
> +{
> +	int node, gen, gen_idx, min_gen = INT_MAX, max_gen = -1;
> +
> +	for (node = 0; node < stats->nr_nodes; ++node)

Curly braces.

> +		for (gen_idx = 0; gen_idx < stats->nodes[node].nr_gens;
> +		     ++gen_idx) {
> +			gen = stats->nodes[node].gens[gen_idx].gen;
> +			max_gen = gen > max_gen ? gen : max_gen;
> +			min_gen = gen < min_gen ? gen : min_gen;
> +		}
> +
> +	for (gen = min_gen; gen < max_gen; ++gen)
> +		/* See if the most pages are in this generation. */
> +		if (sum_memcg_stats_for_gen(gen, stats) >
> +				total_pages / 2)
> +			return gen;
> +
> +	TEST_ASSERT(false, "No generation includes majority of %lu pages.",

TEST_FAIL.

> +		    total_pages);
> +
> +	/* unreachable, but make the compiler happy */
> +	return -1;

I _think_ selftests can use unreachable().

> +}
> -- 
> 2.47.0.199.ga7371fff76-goog
> 

