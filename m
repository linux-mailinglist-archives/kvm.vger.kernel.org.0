Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB766746E6
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjASXEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjASXEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:04:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C443D908
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 14:55:59 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so6494092pjq.0
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 14:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cNvkg00G9gX5sw1vto1y1WQdb75bjl+P802YEq1rLwg=;
        b=fE8FXquQqlXEI7aDSuPCC5BOFtwx2+8u9pfVuOBkEuizO8L1ah1XX3AAuTQeApD9EI
         k7jy4RV4nlm5OAkD5H/PT0/gT+jWctUsTqS5rlUlBNerkiV8MIZzNz0p6sD/bqwwJECm
         Q60Lmosy13tM/MY9R85g3Awc5Wak0ibZN5056YaUeo24l9tyV0DKT+PtwY/ekz11VIii
         2FuK40zZr154ovxMAFMb9M6uQGUoyM6XsC+bGa0EzeN0KzDjGs+7rYrr61Ys4IFVQ04C
         kV2PPYRJtjwxDIhOx25k5eA31XP1JckiUR2HbZ6YxjO5VjxP+NlkzjXKRZi2N2YC0nI4
         4T2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cNvkg00G9gX5sw1vto1y1WQdb75bjl+P802YEq1rLwg=;
        b=xvllPZkuP+zv5exr00o/RMwI/OIOw/9BT1PUotBWasUDI1UsoeNDQhgGZfXgilvoOa
         U8ooaL1g3whrurvTSojTs0ksWYJEitRPFbQGM90gxJuJQXQ78K6OhqsWTGgh3xqtXJAR
         OVfcIRFtmcHJSgmfVfMzaWc2grM/DcWUtGNgEsx85kiPROryEIMUY6J4cbbqhkPPQRvB
         ahbgfBNLZGyukvnwVUh9S27CeNipTgXUOzP6XkUiJoJ5yxCpMdllIRRPs8q1Vn7xWZi/
         3+D4R+0n7xo7wmqlfkO/lbHJpjm6Ft+Kgu68IcSABCHsx3YtmurNYqAxhQOkE6baQyRN
         kJgA==
X-Gm-Message-State: AFqh2kqSe0G1p2NsIV3qRufm1qtfknaLMjYC2Vfn5+gtDHYVWUzE9e8X
        ZHkjFFjwrjARG9wmDDCSJ5i45w==
X-Google-Smtp-Source: AMrXdXuXukImNzOy69HjL4zwVVWI15E1APh8voxbmDV5RZfn2iwUJt7WToi3sfTjdmf8LyCF+EPq5w==
X-Received: by 2002:a05:6a20:1456:b0:af:9c75:6699 with SMTP id a22-20020a056a20145600b000af9c756699mr17930857pzi.1.1674168958923;
        Thu, 19 Jan 2023 14:55:58 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id jj22-20020a170903049600b001947c617c45sm11003588plb.221.2023.01.19.14.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 14:55:58 -0800 (PST)
Date:   Thu, 19 Jan 2023 14:55:54 -0800
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 2/2] selftests: KVM: Add page splitting test
Message-ID: <Y8nKerX9tDRHkFq+@google.com>
References: <20230119212510.3938454-1-bgardon@google.com>
 <20230119212510.3938454-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119212510.3938454-3-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 09:25:10PM +0000, Ben Gardon wrote:
> Add a test for page splitting during dirty logging and for hugepage
> recovery after dirty logging.
> 
> Page splitting represents non-trivial behavior, which is complicated
> by MANUAL_PROTECT mode, which causes pages to be split on the first
> clear, instead of when dirty logging is enabled.
> 
> Add a test which makes asserions about page counts to help define the
> expected behavior of page splitting and to provid needed coverage of the
> behavior. This also helps ensure that a failure in eager page splitting
> is not covered up by splitting in the vCPU path.
> 
> Tested by running the test on an Intel Haswell machine w/wo
> MANUAL_PROTECT.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/kvm_util_base.h     |   2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +
>  .../kvm/x86_64/page_splitting_test.c          | 314 ++++++++++++++++++
>  4 files changed, 322 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/page_splitting_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 1750f91dd9362..057ebd709e77a 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -76,6 +76,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
>  TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
>  TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
>  TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
> +TEST_GEN_PROGS_x86_64 += x86_64/page_splitting_test
>  TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
>  TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
>  TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index fbc2a79369b8b..4e38a771fa5d1 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -213,6 +213,7 @@ extern const struct vm_guest_mode_params vm_guest_mode_params[];
>  int open_path_or_exit(const char *path, int flags);
>  int open_kvm_dev_path_or_exit(void);
>  
> +bool get_kvm_param_bool(const char *param);
>  bool get_kvm_intel_param_bool(const char *param);
>  bool get_kvm_amd_param_bool(const char *param);
>  
> @@ -402,6 +403,7 @@ static inline uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
>  	uint64_t data;
>  
>  	__vm_get_stat(vm, stat_name, &data, 1);
> +

Stray newline.

>  	return data;
>  }
>  
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 56d5ea949cbbe..fa6d69f731990 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -80,6 +80,11 @@ static bool get_module_param_bool(const char *module_name, const char *param)
>  	TEST_FAIL("Unrecognized value '%c' for boolean module param", value);
>  }
>  
> +bool get_kvm_param_bool(const char *param)
> +{
> +	return get_module_param_bool("kvm", param);
> +}
> +
>  bool get_kvm_intel_param_bool(const char *param)
>  {
>  	return get_module_param_bool("kvm_intel", param);
> diff --git a/tools/testing/selftests/kvm/x86_64/page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/page_splitting_test.c
> new file mode 100644
> index 0000000000000..3e2ee20adf036
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/page_splitting_test.c
> @@ -0,0 +1,314 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * KVM dirty logging page splitting test
> + *
> + * Based on dirty_log_perf.c
> + *
> + * Copyright (C) 2018, Red Hat, Inc.
> + * Copyright (C) 2020, Google, Inc.
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <time.h>
> +#include <pthread.h>
> +#include <linux/bitmap.h>
> +
> +#include "kvm_util.h"
> +#include "test_util.h"
> +#include "memstress.h"
> +#include "guest_modes.h"
> +
> +/* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
> +#define TEST_HOST_LOOP_N		2UL
> +
> +static int NR_VCPUS = 2;
> +static int NR_SLOTS = 2;
> +static int NR_ITERATIONS = 2;

These should be macros or at least const?

> +static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> +
> +/* Host variables */

What does "Host variables" mean? (And why is guest_percpu_mem_size not a
"Host variable"?)

I imagine this is copy-pasta from a test that has some global variables
that are used by guest code? If that's correct, it's probably best to
just drop this comment.

> +static u64 dirty_log_manual_caps;
> +static bool host_quit;
> +static int iteration;
> +static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
> +
> +struct kvm_page_stats {
> +	uint64_t pages_4k;
> +	uint64_t pages_2m;
> +	uint64_t pages_1g;
> +	uint64_t hugepages;
> +};
> +
> +static void get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats)
> +{
> +	stats->pages_4k = vm_get_stat(vm, "pages_4k");
> +	stats->pages_2m = vm_get_stat(vm, "pages_2m");
> +	stats->pages_1g = vm_get_stat(vm, "pages_1g");
> +	stats->hugepages = stats->pages_2m + stats->pages_1g;
> +
> +	pr_debug("Page stats - 4K: %ld 2M: %ld 1G: %ld huge: %ld\n",
> +		 stats->pages_4k, stats->pages_2m, stats->pages_1g,
> +		 stats->hugepages);
> +}
> +
> +static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
> +{
> +	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
> +	int vcpu_idx = vcpu_args->vcpu_idx;
> +	uint64_t pages_count = 0;
> +	struct kvm_run *run;
> +	int ret;
> +
> +	run = vcpu->run;
> +
> +	while (!READ_ONCE(host_quit)) {
> +		int current_iteration = READ_ONCE(iteration);
> +
> +		ret = _vcpu_run(vcpu);
> +
> +		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);

vcpu_run() handles this assert for you.

> +		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
> +			    "Invalid guest sync status: exit_reason=%s\n",
> +			    exit_reason_str(run->exit_reason));

optional: ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);

(You'll lose the exit reason logging.)

> +
> +		vcpu_last_completed_iteration[vcpu_idx] = current_iteration;
> +
> +		if (current_iteration)
> +			pages_count += vcpu_args->pages;

pages_count looks unnecessary

> +
> +		/* Wait for the start of the next iteration to be signaled. */
> +		while (current_iteration == READ_ONCE(iteration) &&
> +		       READ_ONCE(iteration) >= 0 &&
> +		       !READ_ONCE(host_quit))
> +			;
> +	}
> +}
> +
> +struct test_params {
> +	enum vm_mem_backing_src_type backing_src;
> +};
> +
> +static void run_test(struct test_params *p)
> +{
> +	struct kvm_vm *vm;
> +	unsigned long **bitmaps;
> +	uint64_t guest_num_pages;
> +	uint64_t host_num_pages;
> +	uint64_t pages_per_slot;
> +	int i;
> +	uint64_t total_4k_pages;
> +	struct kvm_page_stats stats_populated;
> +	struct kvm_page_stats stats_dirty_logging_enabled;
> +	struct kvm_page_stats stats_dirty_pass[NR_ITERATIONS];
> +	struct kvm_page_stats stats_clear_pass[NR_ITERATIONS];
> +	struct kvm_page_stats stats_dirty_logging_disabled;
> +	struct kvm_page_stats stats_repopulated;
> +
> +	vm = memstress_create_vm(VM_MODE_DEFAULT, NR_VCPUS, guest_percpu_mem_size,
> +				 NR_SLOTS, p->backing_src, false);
> +
> +	guest_num_pages = (NR_VCPUS * guest_percpu_mem_size) >> vm->page_shift;
> +	guest_num_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, guest_num_pages);
> +	host_num_pages = vm_num_host_pages(VM_MODE_DEFAULT, guest_num_pages);
> +	pages_per_slot = host_num_pages / NR_SLOTS;
> +
> +	bitmaps = memstress_alloc_bitmaps(NR_SLOTS, pages_per_slot);
> +
> +	if (dirty_log_manual_caps)
> +		vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2,
> +			      dirty_log_manual_caps);
> +
> +	/* Start the iterations */
> +	iteration = 0;
> +	host_quit = false;
> +
> +	for (i = 0; i < NR_VCPUS; i++)
> +		vcpu_last_completed_iteration[i] = -1;
> +
> +	memstress_start_vcpu_threads(NR_VCPUS, vcpu_worker);
> +
> +	/* Allow the vCPUs to populate memory */
> +	for (i = 0; i < NR_VCPUS; i++) {
> +		while (READ_ONCE(vcpu_last_completed_iteration[i]) !=
> +		       iteration)
> +			;
> +	}
> +
> +	pr_debug("\nGetting stats after populating memory:\n");
> +	get_page_stats(vm, &stats_populated);
> +
> +	/* Enable dirty logging */
> +	memstress_enable_dirty_logging(vm, NR_SLOTS);
> +
> +	pr_debug("\nGetting stats after enabling dirty logging:\n");
> +	get_page_stats(vm, &stats_dirty_logging_enabled);
> +
> +	while (iteration < NR_ITERATIONS) {
> +		/*
> +		 * Incrementing the iteration number will start the vCPUs
> +		 * dirtying memory again.
> +		 */
> +		iteration++;
> +
> +		for (i = 0; i < NR_VCPUS; i++) {
> +			while (READ_ONCE(vcpu_last_completed_iteration[i])
> +			       != iteration)
> +				;
> +		}
> +
> +		pr_debug("\nGetting stats after dirtying memory on pass %d:\n", iteration);
> +		get_page_stats(vm, &stats_dirty_pass[iteration - 1]);

Incrementing iteration, waiting for vCPUs, and grabbing stats is
repeated below. Throw it in a helper function?

> +
> +		memstress_get_dirty_log(vm, bitmaps, NR_SLOTS);
> +
> +		if (dirty_log_manual_caps) {
> +			memstress_clear_dirty_log(vm, bitmaps, NR_SLOTS, pages_per_slot);
> +
> +			pr_debug("\nGetting stats after clearing dirty log pass %d:\n", iteration);
> +			get_page_stats(vm, &stats_clear_pass[iteration - 1]);
> +		}
> +	}
> +
> +	/* Disable dirty logging */
> +	memstress_disable_dirty_logging(vm, NR_SLOTS);
> +
> +	pr_debug("\nGetting stats after disabling dirty logging:\n");
> +	get_page_stats(vm, &stats_dirty_logging_disabled);
> +
> +	/* Run vCPUs again to fault pages back in. */
> +	iteration++;
> +	for (i = 0; i < NR_VCPUS; i++) {
> +		while (READ_ONCE(vcpu_last_completed_iteration[i]) != iteration)
> +			;
> +	}
> +
> +	pr_debug("\nGetting stats after repopulating memory:\n");
> +	get_page_stats(vm, &stats_repopulated);
> +
> +	/*
> +	 * Tell the vCPU threads to quit.  No need to manually check that vCPUs
> +	 * have stopped running after disabling dirty logging, the join will
> +	 * wait for them to exit.
> +	 */
> +	host_quit = true;
> +	memstress_join_vcpu_threads(NR_VCPUS);
> +
> +	memstress_free_bitmaps(bitmaps, NR_SLOTS);
> +	memstress_destroy_vm(vm);
> +
> +	/* Make assertions about the page counts. */
> +	total_4k_pages = stats_populated.pages_4k;
> +	total_4k_pages += stats_populated.pages_2m * 512;
> +	total_4k_pages += stats_populated.pages_1g * 512 * 512;
> +
> +	/*
> +	 * Check that all huge pages were split. Since large pages can only
> +	 * exist in the data slot, and the vCPUs should have dirtied all pages
> +	 * in the data slot, there should be no huge pages left after splitting.
> +	 * Splitting happens at dirty log enable time without
> +	 * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 and after the first clear pass
> +	 * with that capability.
> +	 */
> +	if (dirty_log_manual_caps) {
> +		TEST_ASSERT(stats_clear_pass[0].hugepages == 0,

Consider using ASSERT_EQ() to simplify these checks. It will
automatically print out the values for you, but you'll lose the
contextual error message ("Unexpected huge page count after
splitting..."). But maybe we could add support for a custom extra error
string?

__ASSERT_EQ(stats_clear_pass[0].hugepages, 0,
            "Expected 0 hugepages after splitting");

Or use a comment to document the context for the assertion. Whoever is
debugging a failure is going to come look at the selftest code no matter
what.

I think I prefer ASSERT_EQ() + comment, especially since the comment
pretty much already exists above.

> +			    "Unexpected huge page count after splitting. Expected 0, got %ld",
> +			    stats_clear_pass[0].hugepages);
> +		TEST_ASSERT(stats_clear_pass[0].pages_4k == total_4k_pages,
> +			    "All memory should be mapped at 4k. Expected %ld 4k pages, got %ld",
> +			    total_4k_pages, stats_clear_pass[0].pages_4k);

Also assert that huge pages are *not* split when dirty logging is first
enabled.

> +	} else {
> +		TEST_ASSERT(stats_dirty_logging_enabled.hugepages == 0,
> +			    "Unexpected huge page count after splitting. Expected 0, got %ld",
> +			    stats_dirty_logging_enabled.hugepages);
> +		TEST_ASSERT(stats_dirty_logging_enabled.pages_4k == total_4k_pages,
> +			    "All memory should be mapped at 4k. Expected %ld 4k pages, got %ld",
> +			    total_4k_pages, stats_dirty_logging_enabled.pages_4k);
> +	}
> +
> +	/*
> +	 * Once dirty logging is disabled and the vCPUs have touched all their
> +	 * memory again, the page counts should be the same as they were
> +	 * right after initial population of memory.
> +	 */
> +	TEST_ASSERT(stats_populated.pages_4k == stats_repopulated.pages_4k,
> +		    "4k page count did not return to its initial value after "
> +		    "dirty logging. Expected %ld, got %ld",
> +		    stats_populated.pages_4k, stats_repopulated.pages_4k);
> +	TEST_ASSERT(stats_populated.pages_2m == stats_repopulated.pages_2m,
> +		    "2m page count did not return to its initial value after "
> +		    "dirty logging. Expected %ld, got %ld",
> +		    stats_populated.pages_2m, stats_repopulated.pages_2m);
> +	TEST_ASSERT(stats_populated.pages_1g == stats_repopulated.pages_1g,
> +		    "1g page count did not return to its initial value after "
> +		    "dirty logging. Expected %ld, got %ld",
> +		    stats_populated.pages_1g, stats_repopulated.pages_1g);

Nice!

> +}
> +
> +static void help(char *name)
> +{
> +	puts("");
> +	printf("usage: %s [-h] [-g] [-m mode] [-b vcpu bytes] [-s mem type]\n",
                                    ^^^^^^^^^
				    -m is not used
> +	       name);
> +	puts("");
> +	printf(" -g: Do not enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2. This\n"
> +	       "     makes KVM_GET_DIRTY_LOG clear the dirty log (i.e.\n"
> +	       "     KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE is not enabled)\n"
> +	       "     and writes will be tracked as soon as dirty logging is\n"
> +	       "     enabled on the memslot (i.e. KVM_DIRTY_LOG_INITIALLY_SET\n"
> +	       "     is not enabled).\n");
> +	printf(" -b: specify the size of the memory region which should be\n"
> +	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
> +	       "     (default: 1G)\n");
> +	backing_src_help("-s");
> +	puts("");
> +	exit(0);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct test_params p = {
> +		.backing_src = VM_MEM_SRC_ANONYMOUS_HUGETLB,
> +	};
> +	int opt;
> +
> +	TEST_REQUIRE(get_kvm_param_bool("eager_page_split"));
> +	TEST_REQUIRE(get_kvm_param_bool("tdp_mmu"));
> +
> +	dirty_log_manual_caps =
> +		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> +	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> +				  KVM_DIRTY_LOG_INITIALLY_SET);

Since this is a correctness test I think the test should, by default,
test both KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE and 0, to ensure we get
test coverage of both.

And with that in place, there's probably no need for the -g flag.

> +
> +	guest_modes_append_default();
> +
> +	while ((opt = getopt(argc, argv, "b:ghs:")) != -1) {
> +		switch (opt) {
> +		case 'b':
> +			guest_percpu_mem_size = parse_size(optarg);
> +			break;
> +		case 'g':
> +			dirty_log_manual_caps = 0;
> +			break;
> +		case 'h':
> +			help(argv[0]);
> +			break;

nit: Move this down so it can fallthrough to the default case.

> +		case 's':
> +			p.backing_src = parse_backing_src_type(optarg);

It's odd that backing_src is in test_params but guest_percpu_mem_size
and dirty_log_manual_caps are global variables.

Personally I prefer using global variables for constants that do not
change across run_test(). i.e. Let's make backing_src a global.

> +			break;
> +		default:
> +			help(argv[0]);
> +			break;
> +		}
> +	}
> +
> +	if (!is_backing_src_hugetlb(p.backing_src)) {
> +		pr_info("This test will only work reliably with HugeTLB memory. "
> +			"It can work with THP, but that is best effort.");
> +		return KSFT_SKIP;
> +	}

backing_src only controls the memstress data slots. The rest of guest
memory could be a source of noise for this test.

> +
> +	run_test(&p);

Use for_each_guest_mode() to run against all supported guest modes.

> +
> +	return 0;
> +}
> -- 
> 2.39.1.405.gd4c25cc71f-goog
> 
