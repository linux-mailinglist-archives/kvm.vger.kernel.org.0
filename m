Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24815A31C7
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 00:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344877AbiHZWNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 18:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245107AbiHZWNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 18:13:11 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB38E1908
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 15:13:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n65-20020a17090a5ac700b001fbb4fad865so3172340pji.1
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 15:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=noyECnwXgtjKfHv/YLeUhMfXehWDRYQ455do/OeJnwU=;
        b=A4Hch5amnwf5uUaSmu5DeuvdIAWpbJSdyIs6VK7cYHwZKUfN0JaPZwfP9lpt2BIQ3/
         5Kq4HQXZI8lkcRyl3UEy4OfB0uBDf5XKo7lbMFUG5DvL8tS+Tptb9AbWPKF41o62UFsi
         e5HyCr3ytdjZHV3KQTlKinEVmEEyHPux8Jkkgv1iWPo2zOXeyGtsnw1+dAqcglG+RDUC
         aGfHM40zhHgbblpCGTPElS+F1t0rdIJWO5YYu9tJ9umcUgzj+ToicQRZwRn0QHI9ftcs
         IcIHMAsqnnKcB20ebR+uWCuaQF0+F5mca7aPmfJe50HMOL+krnui6v/uJhdgeBlH7/El
         rOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=noyECnwXgtjKfHv/YLeUhMfXehWDRYQ455do/OeJnwU=;
        b=oG6bunCwHWbi5L968SiViCZTQyVwolQE2YD+pdLZp+6CwsgOnJJnraXOfNIMavqsP5
         yzaSKxehQspfu+0woqhiFknj/vD4idMVO+AWWVm2TptwbQlvhbGI2TpMFwHGBCSkjIDu
         iVEv9yTyWnw75J5L1jcO7jtLIb44KX4X5aR5NW0P2ejl7tpf8JEZgPDRZplauEdFLfIo
         kZBGwEHoWbpwtSkRgWUDNi/q/EWaLCtpmRHhs44ITfSQ9UMsWxDJhZf42/TKaGWicbIh
         3+rQ4nJyNoHMuBAM+GdfxRI7wfRSeQ1s1/o/v5EXkccX6Iq3RU8p/6heaU2PMm5MAgjn
         khVA==
X-Gm-Message-State: ACgBeo1CAizz/M+kGQF1kdSsSkAQO149V4YOKFpTR4ctI7coy7ZqEqMG
        cMgCSkU6ApZPErOuDoQOGUxJ3g==
X-Google-Smtp-Source: AA6agR7gNph/WZcZ3M9YG46vs7+GrcFDxopGYkRL+aAX21ErmzZnWDHKjlnFVeuWeYra9gZga2wM3g==
X-Received: by 2002:a17:90a:f0c9:b0:1fa:e017:7d13 with SMTP id fa9-20020a17090af0c900b001fae0177d13mr6452994pjb.128.1661551990012;
        Fri, 26 Aug 2022 15:13:10 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902e54700b0016a6caacaefsm2091623plf.103.2022.08.26.15.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 15:13:09 -0700 (PDT)
Date:   Fri, 26 Aug 2022 15:13:04 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v2 2/3] KVM: selftests: Randomize which pages are written
 vs read.
Message-ID: <YwlFcGn4w34uXPQd@google.com>
References: <20220817214146.3285106-1-coltonlewis@google.com>
 <20220817214146.3285106-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817214146.3285106-3-coltonlewis@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 09:41:45PM +0000, Colton Lewis wrote:
> Randomize which tables are written vs read using the random number
> arrays. Change the variable wr_fract and associated function calls to
> write_percent that now operates as a percentage from 0 to 100 where X
> means each page has an X% chance of being written. Change the -f
> argument to -w to reflect the new variable semantics. Keep the same
> default of 100 percent writes.

Doesn't the new option cause like a 1000x slowdown in "Dirty memory
time"?  I don't think we should merge this until that is understood and
addressed (and it should be at least called out here so that reviewers
can be made aware).

> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/access_tracking_perf_test.c |  2 +-
>  .../selftests/kvm/dirty_log_perf_test.c       | 28 ++++++++++---------
>  .../selftests/kvm/include/perf_test_util.h    |  4 +--
>  .../selftests/kvm/lib/perf_test_util.c        |  9 +++---
>  4 files changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index 1c2749b1481a..e87696b60e0f 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -272,7 +272,7 @@ static void run_iteration(struct kvm_vm *vm, int nr_vcpus, const char *descripti
>  static void access_memory(struct kvm_vm *vm, int nr_vcpus,
>  			  enum access_type access, const char *description)
>  {
> -	perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
> +	perf_test_set_write_percent(vm, (access == ACCESS_READ) ? 0 : 100);
>  	iteration_work = ITERATION_ACCESS_MEMORY;
>  	run_iteration(vm, nr_vcpus, description);
>  }
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 362b946019e9..9226eeea79bc 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -128,10 +128,10 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
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
> @@ -227,7 +227,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  				 p->partition_vcpu_memory_access);
>  
>  	perf_test_set_random_seed(vm, p->random_seed);
> -	perf_test_set_wr_fract(vm, p->wr_fract);
> +	perf_test_set_write_percent(vm, p->write_percent);
>  
>  	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
>  	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> @@ -355,7 +355,7 @@ static void help(char *name)
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
>  	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
> -	       "[-x memslots]\n", name);
> +	       "[-x memslots] [-w percentage]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>  	       TEST_HOST_LOOP_N);
> @@ -375,10 +375,6 @@ static void help(char *name)
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
> @@ -386,6 +382,11 @@ static void help(char *name)
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
> @@ -395,10 +396,10 @@ int main(int argc, char *argv[])
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
> @@ -410,7 +411,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "eghi:p:m:nb:v:or:s:x:w:")) != -1) {
>  		switch (opt) {
>  		case 'e':
>  			/* 'e' is for evil. */
> @@ -433,10 +434,11 @@ int main(int argc, char *argv[])
>  		case 'b':
>  			guest_percpu_mem_size = parse_size(optarg);
>  			break;
> -		case 'f':
> -			p.wr_fract = atoi(optarg);
> -			TEST_ASSERT(p.wr_fract >= 1,
> -				    "Write fraction cannot be less than one");
> +		case 'w':
> +			perf_test_args.write_percent = atoi(optarg);
> +			TEST_ASSERT(perf_test_args.write_percent >= 0
> +				    && perf_test_args.write_percent <= 100,
> +				    "Write percentage must be between 0 and 100");

perf_test_create_vm() overwrites this with 100. Did you mean
p.write_percent?

>  			break;
>  		case 'v':
>  			nr_vcpus = atoi(optarg);
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 9517956424fc..8da4a839c585 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -37,7 +37,7 @@ struct perf_test_args {
>  	uint64_t size;
>  	uint64_t guest_page_size;
>  	uint32_t random_seed;
> -	int wr_fract;
> +	int write_percent;
>  
>  	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
>  	bool nested;
> @@ -53,7 +53,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  				   bool partition_vcpu_memory_access);
>  void perf_test_destroy_vm(struct kvm_vm *vm);
>  
> -void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> +void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
>  void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
>  
>  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 8d85923acb4e..1a6b69713337 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -48,6 +48,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
>  	uint64_t gva;
>  	uint64_t pages;
> +	uint32_t *rnd_arr = (uint32_t *)vcpu_args->random_array;
>  	int i;
>  
>  	gva = vcpu_args->gva;
> @@ -60,7 +61,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  		for (i = 0; i < pages; i++) {
>  			uint64_t addr = gva + (i * pta->guest_page_size);
>  
> -			if (i % pta->wr_fract == 0)
> +			if (rnd_arr[i] % 100 < pta->write_percent)
>  				*(uint64_t *)addr = 0x0123456789ABCDEF;
>  			else
>  				READ_ONCE(*(uint64_t *)addr);
> @@ -150,7 +151,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
>  	/* Set perf_test_args defaults. */
> -	pta->wr_fract = 100;
> +	pta->write_percent = 100;
>  	pta->random_seed = time(NULL);
>  
>  	/*
> @@ -258,9 +259,9 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
>  	kvm_vm_free(vm);
>  }
>  
> -void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
> +void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent)
>  {
> -	perf_test_args.wr_fract = wr_fract;
> +	perf_test_args.write_percent = write_percent;
>  	sync_global_to_guest(vm, perf_test_args);
>  }
>  
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
