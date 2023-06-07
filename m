Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D524D725103
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbjFGAKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbjFGAKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:10:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CF61981
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:10:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb3a35ba742so2068276276.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686096600; x=1688688600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7jQ+xYt46hR10tWF91OPdd84A3fR3CneeXhyB7VEVfs=;
        b=IOaGubraBVxN5KZKqG2ei+OyUjRB+hj5dAS1hlNbmUpIsU3SbJAnuS9cCUeiJPr5r8
         5lLlB9jusTHmTSagqCMIDN3aES6NtMJC6xXmfDqyNkMzzrjtKLuX1OmC9AusXc5sGoIA
         wEoH1AXK9oYAepZnLFFfvFv07//QlYUXv9FUqQ5sXvKxe3jmVmgav/76tn/JPKnCHRjq
         yoghl5j9sWXcKEDBaZ+fCu2rXfWQROm47roJ6a6i7MylS6BhLYUkA9AHHIJhGf6VBFSU
         SalXBMAop79PBNnk82YzxO8tBCKwClx5iN9rKDE4i+yvl6TwUXZcNiMtwd/CVCpZRqIT
         zaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686096600; x=1688688600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7jQ+xYt46hR10tWF91OPdd84A3fR3CneeXhyB7VEVfs=;
        b=NRor0wB+zBktB0V1AWHDLS/En1DLhG4eqsUJ+OoncUd746Ca38Usqss1Y1Vb7y1P7i
         mUJg6f10/lJfsNHUMHM7B5oh7zEcXO4wb49pcLpdGXTnI8VTkNo6U+R7MNt8GIMkXAfU
         LMiszIM6MeDHteU2LBMc+s4jyIfKmO1dT3IyP2X6u9ENRkz2OrIFplQBdfcr0R8N8rOW
         KPVOgZtnMmezk/P3E//6BC9WkyWNPvmnkSJ0Qf5zgfl2V8QJNfqSUfMpBhdWen8fjChC
         5R7TrSU4y3JQf5MDNnVCBBO2MSaU4tpl1hnc5aGK7N68YX+TPrZWea0CUlCfq4u9hTGZ
         Pmkg==
X-Gm-Message-State: AC+VfDy3aGbx7WwVXVxTwh3f/h8gIBUlvIO44RLBmaJohpZqkZn7G3f0
        OLjm+ZbRf/iSJCP+wTbzJ3T2Bo2z1fs=
X-Google-Smtp-Source: ACHHUZ662owbssGP0R/z0eAEzt7J4mWnl43/VcibcXVGyAUtItJqI1nNUF/U1AoXhUK5o0Rk9wmIFM1EK1Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1896:b0:ba8:929a:2073 with SMTP id
 cj22-20020a056902189600b00ba8929a2073mr2190865ybb.1.1686096600527; Tue, 06
 Jun 2023 17:10:00 -0700 (PDT)
Date:   Tue, 6 Jun 2023 17:09:58 -0700
In-Reply-To: <20230601184256.180413-1-peterx@redhat.com>
Mime-Version: 1.0
References: <20230601184256.180413-1-peterx@redhat.com>
Message-ID: <ZH/K1uip/k0do9F2@google.com>
Subject: Re: [PATCH v2] selftests/kvm: Allow specify physical cpu list in
 demand paging test
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023, Peter Xu wrote:
> Mimic dirty log test to allow specify physical cpu pinning for vcpu threads.
> Put the help message into a general helper as suggested by Sean.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c  | 15 +++++++++++++--
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 12 +-----------
>  .../testing/selftests/kvm/include/kvm_util_base.h |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c        | 15 +++++++++++++++
>  4 files changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index bdb8e0748154..8581478ed4eb 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -220,7 +220,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  static void help(char *name)
>  {
>  	puts("");
> -	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
> +	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a] [-c cpu_list]\n"

This appears to be based on Anish's unmerged series.

https://lore.kernel.org/all/20230602161921.208564-14-amoorthy@google.com

>  		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
>  		   "          [-s type] [-v vcpus] [-o]\n", name);
>  	guest_modes_help();
> @@ -229,6 +229,7 @@ static void help(char *name)
>  	printf(" -a: Use a single userfaultfd for all of guest memory, instead of\n"
>  		   "     creating one for each region paged by a unique vCPU\n"
>  		   "     Set implicitly with -o, and no effect without -u.\n");
> +	kvm_vcpu_pinning_help();

The helper should have a verb, e.g. kvm_print_vcpu_pinning_help().

>  	printf(" -d: add a delay in usec to the User Fault\n"
>  	       "     FD handler to simulate demand paging\n"
>  	       "     overheads. Ignored without -u.\n");
> @@ -247,6 +248,7 @@ static void help(char *name)
>  int main(int argc, char *argv[])
>  {
>  	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
> +	const char *cpulist = NULL;
>  	struct test_params p = {
>  		.src_type = DEFAULT_VM_MEM_SRC,
>  		.partition_vcpu_memory_access = true,
> @@ -257,7 +259,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:r:")) != -1) {
> +	while ((opt = getopt(argc, argv, "ac:hom:u:d:b:s:v:r:")) != -1) {
>  		switch (opt) {
>  		case 'm':
>  			guest_modes_cmdline(optarg);
> @@ -272,6 +274,9 @@ int main(int argc, char *argv[])
>  		case 'a':
>  			p.single_uffd = true;
>  			break;
> +		case 'c':
> +			cpulist = optarg;
> +			break;

I think it makes sense to put this after 'v' so that the vCPU pinning stuff
directly follows the knobs for defining the number of vCPUs.  This test doesn't
use alphabetical, so inserting here doesn't buy anything.

>  		case 'd':
>  			p.uffd_delay = strtoul(optarg, NULL, 0);
>  			TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
> @@ -309,6 +314,12 @@ int main(int argc, char *argv[])
>  		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -s");
>  	}
>  
> +	if (cpulist) {
> +		kvm_parse_vcpu_pinning(cpulist, memstress_args.vcpu_to_pcpu,
> +				       nr_vcpus);
> +		memstress_args.pin_vcpus = true;
> +	}
> +
>  	for_each_guest_mode(run_test, &p);
>  
>  	return 0;
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index e9d6d1aecf89..a17d4ebebe55 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -402,17 +402,7 @@ static void help(char *name)
>  	       "     so -w X means each page has an X%% chance of writing\n"
>  	       "     and a (100-X)%% chance of reading.\n"
>  	       "     (default: 100 i.e. all pages are written to.)\n");
> -	printf(" -c: Pin tasks to physical CPUs.  Takes a list of comma separated\n"
> -	       "     values (target pCPU), one for each vCPU, plus an optional\n"
> -	       "     entry for the main application task (specified via entry\n"
> -	       "     <nr_vcpus + 1>).  If used, entries must be provided for all\n"
> -	       "     vCPUs, i.e. pinning vCPUs is all or nothing.\n\n"
> -	       "     E.g. to create 3 vCPUs, pin vCPU0=>pCPU22, vCPU1=>pCPU23,\n"
> -	       "     vCPU2=>pCPU24, and pin the application task to pCPU50:\n\n"
> -	       "         ./dirty_log_perf_test -v 3 -c 22,23,24,50\n\n"
> -	       "     To leave the application task unpinned, drop the final entry:\n\n"
> -	       "         ./dirty_log_perf_test -v 3 -c 22,23,24\n\n"

This should print the actual program name.

I've fixed up all of these and rebased.  I'll post a v3 shortly.
