Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A395B3DDB
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 19:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiIIRVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 13:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiIIRVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 13:21:48 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE64AF4B2
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 10:21:47 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q9so2176565pgq.6
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 10:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=/hw+ReXH5Efl2BBpqBwVsi6Z8z1JnQlymLf9lixzPJE=;
        b=Z3ZyiHL5HZbxR9SgEVLbRE0BtVw3OTckWxnBDPzRiOILXJv+KldU+AdTDgzuWXq08s
         ZpWVZdG839/EdnyAQa9G2Kl+7lNBTqtdjVBaSk2uOj7ZxdSiEkPwXwLGPt+xX922p7Bx
         TWmdpOjBwyreKoTNT1+SIzLqMNib/Jgl1ahaPleTAzEu4gMMcrAxIbTAlJiA8gSjHntW
         VUCK6P7aM8+1B6yzOVfCN0YB3bms2aB+FaUtBCwT+xlfPqWCdiIBCG0BXEOyj3W/c+Lj
         i+f3D7JQhUUDgwyRwWnEXQBtb4wO9NCS1TsPBZ7Fmh2m3ZacRunskUga5WhiSZEFcZMc
         6lww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/hw+ReXH5Efl2BBpqBwVsi6Z8z1JnQlymLf9lixzPJE=;
        b=SECALVN8mvpYAkviz4klNjTAFcXmkJwsiYm7jitRYg07QdNLYCWOSDRFm+L4dHzezE
         hXGhI2/vYvoyEZq6hY1OKD5S5q0TA24mD7l5k1zk7yCZN095AQy0qCF4IwTAJdYRxZ1t
         L2gd084nLrVf1LE7OGaodfJBT5LXsU79qY44BPZ11b5ROtOxeBOBB4m8od+HG4+mqorT
         q60mrT8DLm0MZmSDtIsX+vDiwAO+xcg3lkb2WnGGM1Zm7BOPzqn63zsLbccVfb2C4PTy
         MbcSc4CnXj9Z8pcdX9yHRSjn7hE50zHPUh+GMRzrus80flV6wD/jltTpeYQlsR4n5l/c
         bikQ==
X-Gm-Message-State: ACgBeo0QEBMmTJgvLvBWtbC8yCA8I8+ivktmbpLF23mIz1YhI21nP8bY
        EEhYaA4vjPgDTJhVC+7yB+/10w==
X-Google-Smtp-Source: AA6agR7PSaC23nNvSB+mWD7BW3iy7/nNWj8LikWs8zI2m3t4ZivgKQK4lIRN4fLQts/qIxNXzuEFPA==
X-Received: by 2002:a63:4613:0:b0:434:9669:ceff with SMTP id t19-20020a634613000000b004349669ceffmr12719018pga.126.1662744107051;
        Fri, 09 Sep 2022 10:21:47 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id w5-20020a634745000000b00434272fe870sm719947pgk.88.2022.09.09.10.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 10:21:45 -0700 (PDT)
Date:   Fri, 9 Sep 2022 10:21:40 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v5 2/3] KVM: selftests: randomize which pages are written
 vs read
Message-ID: <Yxt2JHYiE6A3pTbE@google.com>
References: <20220909124300.3409187-1-coltonlewis@google.com>
 <20220909124300.3409187-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909124300.3409187-3-coltonlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 12:42:59PM +0000, Colton Lewis wrote:
> Randomize which pages are written vs read using the random number
> generator.
> 
> Change the variable wr_fract and associated function calls to
> write_percent that now operates as a percentage from 0 to 100 where X
> means each page has an X% chance of being written. Change the -f
> argument to -w to reflect the new variable semantics. Keep the same
> default of 100% writes.
> 
> Population always uses 100% writes.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/access_tracking_perf_test.c |  2 +-
>  .../selftests/kvm/dirty_log_perf_test.c       | 30 +++++++++++--------
>  .../selftests/kvm/include/perf_test_util.h    |  4 +--
>  .../selftests/kvm/lib/perf_test_util.c        | 10 +++----
>  4 files changed, 25 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index d8909032317a..d86046ef3a0b 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -274,7 +274,7 @@ static void run_iteration(struct kvm_vm *vm, int vcpus, const char *description)
>  static void access_memory(struct kvm_vm *vm, int vcpus, enum access_type access,
>  			  const char *description)
>  {
> -	perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
> +	perf_test_set_write_percent(vm, (access == ACCESS_READ) ? 0 : 100);
>  	iteration_work = ITERATION_ACCESS_MEMORY;
>  	run_iteration(vm, vcpus, description);
>  }
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 2f91acd94130..c2ad299b3760 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -122,10 +122,10 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
>  struct test_params {
>  	unsigned long iterations;
>  	uint64_t phys_offset;
> -	int wr_fract;
>  	bool partition_vcpu_memory_access;
>  	enum vm_mem_backing_src_type backing_src;
>  	int slots;
> +	uint32_t write_percent;
>  	uint32_t random_seed;
>  };
>  
> @@ -223,7 +223,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	pr_info("Random seed: %u\n", p->random_seed);
>  	perf_test_set_random_seed(vm, p->random_seed);
> -	perf_test_set_wr_fract(vm, p->wr_fract);
>  
>  	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
>  	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> @@ -248,6 +247,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
>  		vcpu_last_completed_iteration[vcpu_id] = -1;
>  
> +	perf_test_set_write_percent(vm, 100);

This is a very important line of code and it's not very clear why it's
here to a random reader. Please a comment here so someone doesn't have
to go through the same confusion/debugging we went through to figure out
why this is necessary. e.g.

        /*
         * Use 100% writes during the population phase to ensure all
         * memory is actually populated and not just mapped to the zero
         * page. The prevents expensive copy-on-write faults from
         * occurring during the dirty memory iterations below, which
         * would pollute the performance results.
         */
        perf_test_set_write_percent(vm, 100);

Aside from that,

Reviewed-by: David Matlack <dmatlack@google.com>

>  	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
>  
>  	/* Allow the vCPUs to populate memory */
> @@ -269,6 +269,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
>  
> +	perf_test_set_write_percent(vm, p->write_percent);
> +
>  	while (iteration < p->iterations) {
>  		/*
>  		 * Incrementing the iteration number will start the vCPUs
> @@ -341,7 +343,7 @@ static void help(char *name)
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
>  	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
> -	       "[-x memslots]\n", name);
> +	       "[-x memslots] [-w percentage]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>  	       TEST_HOST_LOOP_N);
> @@ -358,10 +360,6 @@ static void help(char *name)
>  	printf(" -b: specify the size of the memory region which should be\n"
>  	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
>  	       "     (default: 1G)\n");
> -	printf(" -f: specify the fraction of pages which should be written to\n"
> -	       "     as opposed to simply read, in the form\n"
> -	       "     1/<fraction of pages to write>.\n"
> -	       "     (default: 1 i.e. all pages are written to.)\n");
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> @@ -369,6 +367,11 @@ static void help(char *name)
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> +	printf(" -w: specify the percentage of pages which should be written to\n"
> +	       "     as an integer from 0-100 inclusive. This is probabalistic,\n"
> +	       "     so -w X means each page has an X%% chance of writing\n"
> +	       "     and a (100-X)%% chance of reading.\n"
> +	       "     (default: 100 i.e. all pages are written to.)\n");
>  	puts("");
>  	exit(0);
>  }
> @@ -378,10 +381,10 @@ int main(int argc, char *argv[])
>  	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
>  	struct test_params p = {
>  		.iterations = TEST_HOST_LOOP_N,
> -		.wr_fract = 1,
>  		.partition_vcpu_memory_access = true,
>  		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.slots = 1,
> +		.write_percent = 100,
>  		.random_seed = time(NULL),
>  	};
>  	int opt;
> @@ -393,7 +396,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
>  		switch (opt) {
>  		case 'g':
>  			dirty_log_manual_caps = 0;
> @@ -413,10 +416,11 @@ int main(int argc, char *argv[])
>  		case 'b':
>  			guest_percpu_mem_size = parse_size(optarg);
>  			break;
> -		case 'f':
> -			p.wr_fract = atoi(optarg);
> -			TEST_ASSERT(p.wr_fract >= 1,
> -				    "Write fraction cannot be less than one");
> +		case 'w':
> +			p.write_percent = atoi(optarg);
> +			TEST_ASSERT(p.write_percent >= 0
> +				    && p.write_percent <= 100,
> +				    "Write percentage must be between 0 and 100");
>  			break;
>  		case 'v':
>  			nr_vcpus = atoi(optarg);
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index f18530984b42..f93f2ea7c6a3 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -35,7 +35,7 @@ struct perf_test_args {
>  	uint64_t size;
>  	uint64_t guest_page_size;
>  	uint32_t random_seed;
> -	int wr_fract;
> +	uint32_t write_percent;
>  
>  	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
>  	bool nested;
> @@ -51,7 +51,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  				   bool partition_vcpu_memory_access);
>  void perf_test_destroy_vm(struct kvm_vm *vm);
>  
> -void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> +void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
>  void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
>  
>  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 4d9c7d7693d9..12a3597be1f9 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -60,7 +60,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  			uint64_t addr = gva + (i * pta->guest_page_size);
>  			guest_random(&rand);
>  
> -			if (i % pta->wr_fract == 0)
> +			if (rand % 100 < pta->write_percent)
>  				*(uint64_t *)addr = 0x0123456789ABCDEF;
>  			else
>  				READ_ONCE(*(uint64_t *)addr);
> @@ -118,7 +118,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
>  	/* Set perf_test_args defaults. */
> -	pta->wr_fract = 1;
> +	pta->write_percent = 100;
>  	pta->random_seed = time(NULL);
>  
>  	/*
> @@ -221,10 +221,10 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
>  	kvm_vm_free(vm);
>  }
>  
> -void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
> +void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent)
>  {
> -	perf_test_args.wr_fract = wr_fract;
> -	sync_global_to_guest(vm, perf_test_args);
> +	perf_test_args.write_percent = write_percent;
> +	sync_global_to_guest(vm, perf_test_args.write_percent);
>  }
>  
>  void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
> -- 
> 2.37.2.789.g6183377224-goog
> 
