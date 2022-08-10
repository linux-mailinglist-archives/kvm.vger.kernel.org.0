Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1458F4FB
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 01:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiHJXtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 19:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiHJXtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 19:49:31 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330D85FAFE
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:49:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso3720603pjf.5
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=7q5JxAK0vHP9WT28bouEchKLTJ6x5HjHy5iEOu3hB8g=;
        b=PQP3OmQ8yy9mPCmXBeVfxwFXkr4rJXuMjfuNJ0PoTW7plQEqGQEwt+anuiCzU2LLM7
         0BMrZ2OG75sJ3N/xOwXrsjiRn4bJvlXbTEesyyS02KbptsUbsdiTBQmIrROBlmJcxmyW
         N3LhnPfaNAgZayfd7ErQ5vQ5DmSqAnjhIibUFsOAJJ6QuyUwIt7j9bcDRfzlUO9nNoze
         LZfRxXiq7X+dw87uvbVGWxFB8DBwOKFJiiqbgixZaDTaYNlEcZ/Ov2cdHZ+oV8PumFxq
         viOnEW6cFNUVq/VAxLwRbxmGD6Tl74W+bV5vCLVC7Icf6WSXUY023GHFDeh+2TOy7Jh0
         kHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7q5JxAK0vHP9WT28bouEchKLTJ6x5HjHy5iEOu3hB8g=;
        b=gLUh3vyAVyUoWvAC1iTbrFxvTdGsMtYgJwRwVrfeXD2neGd3ws/q2opJWBG8mHjFla
         ajC9HkBNfpa85Ta8nTw9VDil53wtrhT9ygcJDh9GaRmFrT2OVObo7D1AIBnhPGAoWKp8
         tDpkOANnAI0Zp33r4ckyZjNYVB2WPZVin7DBPqJUmCjRhEZgmJx1rlIExe3LuZQB9nPT
         WE3UtSEMbG/WzimkDwnzpBWfaaVQgD+ZxDJ6Jde7KN9sQZAIz3VBfK8+aQiOTzNPyRW6
         5dWMjn0Otx9ppBfXz0B3HuVPCBRNiioiziDNmO6oIo99fGZdPMSWGckm9wp5lvMTUPul
         Wh9A==
X-Gm-Message-State: ACgBeo0dqo2f2pe2Mh6DxnpisMEacErMp1jEHN+H+cu05TYgcYTiDYej
        6pYYEOvPt2ifmGU0enjxZrqjWg==
X-Google-Smtp-Source: AA6agR6GvbYePxHJa+JbOqCl3fHy/qnN0YbcZ3tFyqY1yfTtN4Gk0LXuPjSVZ7swjL2m8fkCCplPrw==
X-Received: by 2002:a17:90b:4d88:b0:1f3:34aa:9167 with SMTP id oj8-20020a17090b4d8800b001f334aa9167mr5892651pjb.133.1660175369525;
        Wed, 10 Aug 2022 16:49:29 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id p11-20020a635b0b000000b0041a615381d5sm10492868pgb.4.2022.08.10.16.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 16:49:28 -0700 (PDT)
Date:   Wed, 10 Aug 2022 16:49:23 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH 3/3] KVM: selftests: Randomize page access order
Message-ID: <YvREA1VJA3ryF+io@google.com>
References: <20220810175830.2175089-1-coltonlewis@google.com>
 <20220810175830.2175089-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810175830.2175089-4-coltonlewis@google.com>
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

On Wed, Aug 10, 2022 at 05:58:30PM +0000, Colton Lewis wrote:
> Add the ability to use random_table to randomize the order in which
> pages are accessed. Add the -a argument to enable this new
> behavior. This should make accesses less predictable and make for a
> more realistic test. It includes the possibility that the same pages
> may be hit multiple times during an iteration.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../testing/selftests/kvm/dirty_log_perf_test.c | 11 +++++++++--
>  .../selftests/kvm/include/perf_test_util.h      |  2 ++
>  .../testing/selftests/kvm/lib/perf_test_util.c  | 17 ++++++++++++++++-
>  3 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index dcc5d44fc757..265cb4f7e088 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -132,6 +132,7 @@ struct test_params {
>  	bool partition_vcpu_memory_access;
>  	enum vm_mem_backing_src_type backing_src;
>  	int slots;
> +	bool random_access;
>  	uint32_t random_seed;
>  };
>  
> @@ -227,6 +228,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  				 p->partition_vcpu_memory_access);
>  
>  	perf_test_set_wr_fract(vm, p->wr_fract);
> +	perf_test_set_random_access(vm, p->random_access);
>  
>  	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
>  	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> @@ -357,10 +359,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  static void help(char *name)
>  {
>  	puts("");
> -	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
> +	printf("usage: %s [-h] [-a] [-r random seed] [-i iterations] [-p offset] [-g] "
>  	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
>  	       "[-x memslots]\n", name);
>  	puts("");
> +	printf(" -a: access memory randomly rather than in order.\n");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>  	       TEST_HOST_LOOP_N);
>  	printf(" -g: Do not enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2. This\n"
> @@ -403,6 +406,7 @@ int main(int argc, char *argv[])
>  		.partition_vcpu_memory_access = true,
>  		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.slots = 1,
> +		.random_access = false,
>  		.random_seed = time(NULL),
>  	};
>  	int opt;
> @@ -414,8 +418,11 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "aeghi:p:m:nb:f:v:or:s:x:")) != -1) {
>  		switch (opt) {
> +		case 'a':
> +			p.random_access = true;
> +			break;
>  		case 'e':
>  			/* 'e' is for evil. */
>  			run_vcpus_while_disabling_dirty_logging = true;
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 597875d0c3db..6c6f81ce2216 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -39,6 +39,7 @@ struct perf_test_args {
>  
>  	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
>  	bool nested;
> +	bool random_access;
>  
>  	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
>  };
> @@ -56,6 +57,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  void perf_test_destroy_vm(struct kvm_vm *vm);
>  
>  void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access);
>  
>  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
>  void perf_test_join_vcpu_threads(int vcpus);
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 3c7b93349fef..9838d1ad9166 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -52,6 +52,9 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
>  	uint64_t gva;
>  	uint64_t pages;
> +	uint64_t addr;
> +	bool random_access = pta->random_access;
> +	bool populated = false;
>  	int i;
>  
>  	gva = vcpu_args->gva;
> @@ -62,7 +65,11 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  
>  	while (true) {
>  		for (i = 0; i < pages; i++) {
> -			uint64_t addr = gva + (i * pta->guest_page_size);
> +			if (populated && random_access)

Skipping the populate phase makes sense to ensure everything is
populated I guess. What was your rational?

Either way I think this policy should be driven by the test, rather than
harde-coded in perf_test_guest_code(). i.e. Move the call
perf_test_set_random_access() in dirty_log_perf_test.c to just after the
population phase.

> +				addr = gva +
> +					((random_table[vcpu_idx][i] % pages) * pta->guest_page_size);
> +			else
> +				addr = gva + (i * pta->guest_page_size);
>  
>  			if (random_table[vcpu_idx][i] % 100 < pta->wr_fract)
>  				*(uint64_t *)addr = 0x0123456789ABCDEF;
> @@ -70,6 +77,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  				READ_ONCE(*(uint64_t *)addr);
>  		}
>  
> +		populated = true;
>  		GUEST_SYNC(1);
>  	}
>  }
> @@ -169,6 +177,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  
>  	/* By default vCPUs will write to memory. */
>  	pta->wr_fract = 100;
> +	pta->random_access = false;
>  
>  	/*
>  	 * Snapshot the non-huge page size.  This is used by the guest code to
> @@ -276,6 +285,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
>  	sync_global_to_guest(vm, perf_test_args);
>  }
>  
> +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access)
> +{
> +	perf_test_args.random_access = random_access;
> +	sync_global_to_guest(vm, perf_test_args);
> +}
> +
>  uint64_t __weak perf_test_nested_pages(int nr_vcpus)
>  {
>  	return 0;
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 
