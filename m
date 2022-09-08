Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B5B5B23BC
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 18:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiIHQk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 12:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiIHQkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 12:40:24 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD68E22A2
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 09:40:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id j12so6043382pfi.11
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 09:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=TfyRq0jlvH8eDPYzNpB9Vr+eTdHW9JBmU8SwAEh+UbI=;
        b=bS0esx3pFAUj+EVbeFPV9u5vwPsNdXvXeji2Zssg31MV+d5VzLH4+TJjKI22EYvrwx
         BjYrNN08JHqW+5MxLXUPwD5R/I2pUYI99rdq+rVCleYFh5VxBVClyeQsUqDgzxGcea6c
         bxb3BWOKNS91V7cVo8SJh22quzbb8UmURWu5sZSd/Dyd5+SJhalc6LM0mkKE7y6h568V
         mCftnGBr5zao3amDZ4QrLN1tGp+g+8rPaCPJjpGO+Z/kEDvhWrLKxLX948aBj4f5BRks
         g2jFaEEUWieIrj/FlAFSvMCfsMOT/CmjnniPRuYmrYg34+KrUFfmYWVNZa0TPZTQk1Ii
         z6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TfyRq0jlvH8eDPYzNpB9Vr+eTdHW9JBmU8SwAEh+UbI=;
        b=N5qMRdBnuW+RBuyKIIbbXQYZ7FqN33NepuyZI0mlUj+i3jbydTTw2U9LrBUDGhInjM
         xd4E49hKXuAsey/gHz7FYQswQGkWMMSj5+u14fadjMK3H09Z3ZimF5OpspR2Rc6aO96E
         IepF1wR60FZe6kEVbFkfX3pq1BUjL6Rctc5VnC3DCCyi5mQy933PX60lTGls58U3vCIb
         mgJ1RgnBMadCQwa4N5Hu7KwHmSIgn2U7HcY8ECIXoLij6ZbdamPh+qqbZNTPSubyjhpk
         FAKqLUQJfzYpoLLymv/uozMVcHDJyCtuRXVjQzEyhzGUucBNCxzJelnF96Bd6Rz0ZwdU
         1rug==
X-Gm-Message-State: ACgBeo2vzdIVUNw4WsnU2a0+KbrYF86A1+rPMivx2NzXo2KGo2rEcMc+
        j6ObTCJxS3U4uuFuW6MBM5l0mg==
X-Google-Smtp-Source: AA6agR7ChjM3guR8LuRlEvQHMnqFM6CMxasWsQoVOG5xIoP2XS2Abkp6caJMLnhG1o+8tNqOrJf9xQ==
X-Received: by 2002:a63:4ca:0:b0:434:b550:2115 with SMTP id 193-20020a6304ca000000b00434b5502115mr8445482pge.203.1662655221642;
        Thu, 08 Sep 2022 09:40:21 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id kx6-20020a17090b228600b001fffbad35f6sm1949910pjb.44.2022.09.08.09.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 09:40:19 -0700 (PDT)
Date:   Thu, 8 Sep 2022 09:40:15 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, oupton@google.com
Subject: Re: [PATCH v3 2/3] KVM: selftests: Randomize which pages are written
 vs read.
Message-ID: <Yxoa78p2QTXXgZej@google.com>
References: <20220901195237.2152238-1-coltonlewis@google.com>
 <20220901195237.2152238-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901195237.2152238-3-coltonlewis@google.com>
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

On Thu, Sep 01, 2022 at 07:52:36PM +0000, Colton Lewis wrote:
> Randomize which pages are written vs read using the random number
> generator.
nit:       ^ I haven't seen this style before (the period at the end)

> 
> Change the variable wr_fract and associated function calls to
> write_percent that now operates as a percentage from 0 to 100 where X
> means each page has an X% chance of being written. Change the -f
> argument to -w to reflect the new variable semantics. Keep the same
> default of 100 percent writes.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/access_tracking_perf_test.c |  2 +-
>  .../selftests/kvm/dirty_log_perf_test.c       | 28 ++++++++++---------
>  .../selftests/kvm/include/perf_test_util.h    |  4 +--
>  .../selftests/kvm/lib/perf_test_util.c        | 10 +++----
>  4 files changed, 23 insertions(+), 21 deletions(-)
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
> index 2f91acd94130..c9441f8354be 100644
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

nit: make it an int to match perf_test_args.write_percent

>  	uint32_t random_seed;
>  };
>  
> @@ -223,7 +223,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	pr_info("Random seed: %u\n", p->random_seed);
>  	perf_test_set_random_seed(vm, p->random_seed);
> -	perf_test_set_wr_fract(vm, p->wr_fract);
> +	perf_test_set_write_percent(vm, p->write_percent);
>  
>  	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
>  	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> @@ -341,7 +341,7 @@ static void help(char *name)
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
>  	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
> -	       "[-x memslots]\n", name);
> +	       "[-x memslots] [-w percentage]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>  	       TEST_HOST_LOOP_N);
> @@ -358,10 +358,6 @@ static void help(char *name)
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
> @@ -369,6 +365,11 @@ static void help(char *name)
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
> @@ -378,10 +379,10 @@ int main(int argc, char *argv[])
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
> @@ -393,7 +394,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
>  		switch (opt) {
>  		case 'g':
>  			dirty_log_manual_caps = 0;
> @@ -413,10 +414,11 @@ int main(int argc, char *argv[])
>  		case 'b':
>  			guest_percpu_mem_size = parse_size(optarg);
>  			break;
> -		case 'f':
> -			p.wr_fract = atoi(optarg);
> -			TEST_ASSERT(p.wr_fract >= 1,
> -				    "Write fraction cannot be less than one");
> +		case 'w':
> +			perf_test_args.write_percent = atoi(optarg);

I'm a bit confused, where is p.write_percent being set? I later see

	perf_test_set_write_percent(vm, p->write_percent);

that rewrites perf_test_args.write_percent with whatever was in
p->write_percent.

> +			TEST_ASSERT(perf_test_args.write_percent >= 0
> +				    && perf_test_args.write_percent <= 100,
> +				    "Write percentage must be between 0 and 100");
>  			break;
>  		case 'v':
>  			nr_vcpus = atoi(optarg);
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index f18530984b42..52c450eb6b9b 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -35,7 +35,7 @@ struct perf_test_args {
>  	uint64_t size;
>  	uint64_t guest_page_size;
>  	uint32_t random_seed;
> -	int wr_fract;
> +	int write_percent;
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
> index 1292ed7d1193..be6176faaf8e 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -64,10 +64,10 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  
>  	while (true) {
>  		for (i = 0; i < pages; i++) {
> -			rand = perf_test_random(rand);
>  			uint64_t addr = gva + (i * pta->guest_page_size);
> +			rand = perf_test_random(rand);
>  
> -			if (i % pta->wr_fract == 0)
> +			if (rand % 100 < pta->write_percent)
>  				*(uint64_t *)addr = 0x0123456789ABCDEF;
>  			else
>  				READ_ONCE(*(uint64_t *)addr);
> @@ -125,7 +125,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
>  	/* Set perf_test_args defaults. */
> -	pta->wr_fract = 1;
> +	pta->write_percent = 100;
>  	pta->random_seed = time(NULL);
>  
>  	/*
> @@ -228,9 +228,9 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
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
> 2.37.2.789.g6183377224-goog
> 
