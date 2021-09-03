Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4060A3FFEA4
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 13:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348610AbhICLGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 07:06:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348589AbhICLGU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 07:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630667119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HKIY6ikHaYXPyQ8mc3z2vSwsDwCqgabZwLfvmGN6b8E=;
        b=It1RMP5Oo96Cd88eLIHwgChvUqx6IK+aJoHA6SHx6qLz0kIgHObxQNjMoU7TxOWN8ENJuQ
        n5qFcGdcU0LYKyqoxGkngtt0aAjj6w0baqWch0tduhjVE9IdfgYmiNzeDvczUicv2GYDxS
        evpocg3VeXbslZjy2CD0LnJS5ISLPEo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-SgEEqcOnPE2AnpOFN3AkhA-1; Fri, 03 Sep 2021 07:05:18 -0400
X-MC-Unique: SgEEqcOnPE2AnpOFN3AkhA-1
Received: by mail-ej1-f71.google.com with SMTP id bo11-20020a170906d04b00b005d477e1e41fso2539806ejb.11
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 04:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HKIY6ikHaYXPyQ8mc3z2vSwsDwCqgabZwLfvmGN6b8E=;
        b=IdD7aYy0EMNrhwEBWCB8FW0qXbQ0X1nFVKB1ymm7HC3givPn4cSA9Qn4mIwILQZRhn
         p4M302LjeZIAZ8FCbZdtK9n53ET/8YH+QYy98mRcYRnqvZ/6mhGOMw/JyR3NDTBiAg9C
         m2bB4liFSCBLiX0/MuiZ57iEGQJPNDKvNv/elUbNYl9NgeTkldyUIH58kxJC6ghwEC+V
         pPRkmAXZqP6HfTuKHaWuq3B1tdnHzY7paNkODMU0ipVUKJbvfKbNbLtmHC/JkGIc9NTf
         zPb4sOn2ygXEspsZFBEbp5HnXFW2H/6HBhl/8QVwqueCv2iFUTpdXeyomPwdopQ5GPNP
         rX8Q==
X-Gm-Message-State: AOAM5316tbXJi9WyBiVjl7zom7RekKEJ/R9EAStVwFURs8xc9hsFRK9R
        jRXOWl6lzXdGWf4477+eCIqrfen6XDLL0Bz6SkzoHwyXRJ7wNVG2watS3ERV4KVa7mx650zx18C
        PZzqhmG07Us4E
X-Received: by 2002:aa7:c649:: with SMTP id z9mr3434778edr.304.1630667117285;
        Fri, 03 Sep 2021 04:05:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3MQKea1R8lQ0vwpT0Bk599an+E9Z7X4uNcjB0uA7SB1DzNkJn4bAYb6lg/3Nhge6byxQIRA==
X-Received: by 2002:aa7:c649:: with SMTP id z9mr3434757edr.304.1630667117046;
        Fri, 03 Sep 2021 04:05:17 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id n2sm2842024edi.32.2021.09.03.04.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 04:05:16 -0700 (PDT)
Date:   Fri, 3 Sep 2021 13:05:14 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 12/12] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
Message-ID: <20210903110514.22x3txynin5hg46z@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-13-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-13-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:12PM +0000, Raghavendra Rao Ananta wrote:
> Since the timer stack (hardware and KVM) is per-CPU, there
> are potential chances for races to occur when the scheduler
> decides to migrate a vCPU thread to a different physical CPU.
> Hence, include an option to stress-test this part as well by
> forcing the vCPUs to migrate across physical CPUs in the
> system at a particular rate.
> 
> Originally, the bug for the fix with commit 3134cc8beb69d0d
> ("KVM: arm64: vgic: Resample HW pending state on deactivation")
> was discovered using arch_timer test with vCPU migrations and
> can be easily reproduced.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/aarch64/arch_timer.c        | 108 +++++++++++++++++-
>  1 file changed, 107 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> index 1383f33850e9..de246c7afab2 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> @@ -14,6 +14,8 @@
>   *
>   * The test provides command-line options to configure the timer's
>   * period (-p), number of vCPUs (-n), and iterations per stage (-i).
> + * To stress-test the timer stack even more, an option to migrate the
> + * vCPUs across pCPUs (-m), at a particular rate, is also provided.
>   *
>   * Copyright (c) 2021, Google LLC.
>   */
> @@ -24,6 +26,8 @@
>  #include <pthread.h>
>  #include <linux/kvm.h>
>  #include <linux/sizes.h>
> +#include <linux/bitmap.h>
> +#include <sys/sysinfo.h>
>  
>  #include "kvm_util.h"
>  #include "processor.h"
> @@ -41,12 +45,14 @@ struct test_args {
>  	int nr_vcpus;
>  	int nr_iter;
>  	int timer_period_ms;
> +	int migration_freq_ms;
>  };
>  
>  static struct test_args test_args = {
>  	.nr_vcpus = NR_VCPUS_DEF,
>  	.nr_iter = NR_TEST_ITERS_DEF,
>  	.timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> +	.migration_freq_ms = 0,		/* Turn off migrations by default */

I'd rather we enable good tests like these by default.

>  };
>  
>  #define msecs_to_usecs(msec)		((msec) * 1000LL)
> @@ -81,6 +87,9 @@ struct test_vcpu {
>  static struct test_vcpu test_vcpu[KVM_MAX_VCPUS];
>  static struct test_vcpu_shared_data vcpu_shared_data[KVM_MAX_VCPUS];
>  
> +static unsigned long *vcpu_done_map;
> +static pthread_mutex_t vcpu_done_map_lock;
> +
>  static void
>  guest_configure_timer_action(struct test_vcpu_shared_data *shared_data)
>  {
> @@ -216,6 +225,11 @@ static void *test_vcpu_run(void *arg)
>  
>  	vcpu_run(vm, vcpuid);
>  
> +	/* Currently, any exit from guest is an indication of completion */
> +	pthread_mutex_lock(&vcpu_done_map_lock);
> +	set_bit(vcpuid, vcpu_done_map);
> +	pthread_mutex_unlock(&vcpu_done_map_lock);
> +
>  	switch (get_ucall(vm, vcpuid, &uc)) {
>  	case UCALL_SYNC:
>  	case UCALL_DONE:
> @@ -235,9 +249,73 @@ static void *test_vcpu_run(void *arg)
>  	return NULL;
>  }
>  
> +static uint32_t test_get_pcpu(void)
> +{
> +	uint32_t pcpu;
> +	unsigned int nproc_conf;
> +	cpu_set_t online_cpuset;
> +
> +	nproc_conf = get_nprocs_conf();
> +	sched_getaffinity(0, sizeof(cpu_set_t), &online_cpuset);
> +
> +	/* Randomly find an available pCPU to place a vCPU on */
> +	do {
> +		pcpu = rand() % nproc_conf;
> +	} while (!CPU_ISSET(pcpu, &online_cpuset));
> +
> +	return pcpu;
> +}
> +static int test_migrate_vcpu(struct test_vcpu *vcpu)
> +{
> +	int ret;
> +	cpu_set_t cpuset;
> +	uint32_t new_pcpu = test_get_pcpu();
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(new_pcpu, &cpuset);
> +	ret = pthread_setaffinity_np(vcpu->pt_vcpu_run,
> +					sizeof(cpuset), &cpuset);
> +
> +	/* Allow the error where the vCPU thread is already finished */
> +	TEST_ASSERT(ret == 0 || ret == ESRCH,
> +			"Failed to migrate the vCPU:%u to pCPU: %u; ret: %d\n",
> +			vcpu->vcpuid, new_pcpu, ret);

It'd be good to collect stats for the two cases so we know how many
vcpus we actually migrated with a successful setaffinity and how many
just completed too early. If our stats don't look good, then we can
adjust our timeouts and frequencies.

> +
> +	return ret;
> +}
> +static void *test_vcpu_migration(void *arg)
> +{
> +	unsigned int i, n_done;
> +	bool vcpu_done;
> +
> +	do {
> +		usleep(msecs_to_usecs(test_args.migration_freq_ms));
> +
> +		for (n_done = 0, i = 0; i < test_args.nr_vcpus; i++) {
> +			pthread_mutex_lock(&vcpu_done_map_lock);
> +			vcpu_done = test_bit(i, vcpu_done_map);
> +			pthread_mutex_unlock(&vcpu_done_map_lock);
> +
> +			if (vcpu_done) {
> +				n_done++;
> +				continue;
> +			}
> +
> +			test_migrate_vcpu(&test_vcpu[i]);
> +		}
> +	} while (test_args.nr_vcpus != n_done);
> +
> +	return NULL;
> +}
> +
>  static void test_run(struct kvm_vm *vm)
>  {
>  	int i, ret;
> +	pthread_t pt_vcpu_migration;
> +
> +	pthread_mutex_init(&vcpu_done_map_lock, NULL);
> +	vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
> +	TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap\n");
>  
>  	for (i = 0; i < test_args.nr_vcpus; i++) {
>  		ret = pthread_create(&test_vcpu[i].pt_vcpu_run, NULL,
> @@ -245,8 +323,23 @@ static void test_run(struct kvm_vm *vm)
>  		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
>  	}
>  
> +	/* Spawn a thread to control the vCPU migrations */
> +	if (test_args.migration_freq_ms) {
> +		srand(time(NULL));
> +
> +		ret = pthread_create(&pt_vcpu_migration, NULL,
> +					test_vcpu_migration, NULL);
> +		TEST_ASSERT(!ret, "Failed to create the migration pthread\n");
> +	}
> +
> +
>  	for (i = 0; i < test_args.nr_vcpus; i++)
>  		pthread_join(test_vcpu[i].pt_vcpu_run, NULL);
> +
> +	if (test_args.migration_freq_ms)
> +		pthread_join(pt_vcpu_migration, NULL);
> +
> +	bitmap_free(vcpu_done_map);
>  }
>  
>  static struct kvm_vm *test_vm_create(void)
> @@ -286,6 +379,7 @@ static void test_print_help(char *name)
>  		NR_TEST_ITERS_DEF);
>  	pr_info("\t-p: Periodicity (in ms) of the guest timer (default: %u)\n",
>  		TIMER_TEST_PERIOD_MS_DEF);
> +	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. 0 to turn off (default: 0)\n");
>  	pr_info("\t-h: print this help screen\n");
>  }
>  
> @@ -293,7 +387,7 @@ static bool parse_args(int argc, char *argv[])
>  {
>  	int opt;
>  
> -	while ((opt = getopt(argc, argv, "hn:i:p:")) != -1) {
> +	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
>  		switch (opt) {
>  		case 'n':
>  			test_args.nr_vcpus = atoi(optarg);
> @@ -320,6 +414,13 @@ static bool parse_args(int argc, char *argv[])
>  				goto err;
>  			}
>  			break;
> +		case 'm':
> +			test_args.migration_freq_ms = atoi(optarg);
> +			if (test_args.migration_freq_ms < 0) {
> +				pr_info("0 or positive value needed for -m\n");
> +				goto err;
> +			}
> +			break;
>  		case 'h':
>  		default:
>  			goto err;
> @@ -343,6 +444,11 @@ int main(int argc, char *argv[])
>  	if (!parse_args(argc, argv))
>  		exit(KSFT_SKIP);
>  
> +	if (get_nprocs() < 2) {

if (test_args.migration_freq_ms && get_nprocs() < 2)

> +		print_skip("At least two physical CPUs needed for vCPU migration");
> +		exit(KSFT_SKIP);
> +	}
> +
>  	vm = test_vm_create();
>  	test_run(vm);
>  	kvm_vm_free(vm);
> -- 
> 2.33.0.153.gba50c8fa24-goog
>

Thanks,
drew 

