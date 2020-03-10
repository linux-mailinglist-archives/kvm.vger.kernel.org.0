Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F7717F178
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 09:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgCJIKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 04:10:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58668 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726220AbgCJIKX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 04:10:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583827821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y8x9NS/lYE2S2oFb/lFbf/lfu1VEhk3WN65h9nLvjjo=;
        b=Hnw6kr6UV4hIQexdBBWt5UKel9PQeot5BgTLI658CMxT0vSU09YF/rofjSnOrozuzKL+Ug
        +0ctEJs8+XGBFmjvn9u3lda5JWt0O30R6e8cL5lSo7SnKDBr3M8dCpj9HywTRwPBKYFgdW
        uu+v16JtpAyB4NODKH3G4i8wd9mK8Kk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-4RmNmFdIP0yGquPYazzkLw-1; Tue, 10 Mar 2020 04:10:19 -0400
X-MC-Unique: 4RmNmFdIP0yGquPYazzkLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E550801E72;
        Tue, 10 Mar 2020 08:10:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88F5E91820;
        Tue, 10 Mar 2020 08:10:04 +0000 (UTC)
Date:   Tue, 10 Mar 2020 09:10:02 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v6 10/14] KVM: selftests: Use a single binary for
 dirty/clear log test
Message-ID: <20200310081002.unxq6kwlevmr6m3b@kamzik.brq.redhat.com>
References: <20200309214424.330363-1-peterx@redhat.com>
 <20200309222519.345601-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309222519.345601-1-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 06:25:19PM -0400, Peter Xu wrote:
> Remove the clear_dirty_log test, instead merge it into the existing
> dirty_log_test.  It should be cleaner to use this single binary to do
> both tests, also it's a preparation for the upcoming dirty ring test.
> 
> The default behavior will run all the modes in sequence.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   2 -
>  .../selftests/kvm/clear_dirty_log_test.c      |   2 -
>  tools/testing/selftests/kvm/dirty_log_test.c  | 169 +++++++++++++++---
>  3 files changed, 146 insertions(+), 27 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index d91c53b726e6..941bfcd48eaa 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -27,11 +27,9 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>  TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
> -TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>  TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
>  
> -TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_test
>  TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
>  
> diff --git a/tools/testing/selftests/kvm/clear_dirty_log_test.c b/tools/testing/selftests/kvm/clear_dirty_log_test.c
> deleted file mode 100644
> index 749336937d37..000000000000
> --- a/tools/testing/selftests/kvm/clear_dirty_log_test.c
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -#define USE_CLEAR_DIRTY_LOG
> -#include "dirty_log_test.c"
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 3c0ffd34b3b0..642886394e34 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -128,6 +128,73 @@ static uint64_t host_dirty_count;
>  static uint64_t host_clear_count;
>  static uint64_t host_track_next_count;
>  
> +enum log_mode_t {
> +	/* Only use KVM_GET_DIRTY_LOG for logging */
> +	LOG_MODE_DIRTY_LOG = 0,
> +
> +	/* Use both KVM_[GET|CLEAR]_DIRTY_LOG for logging */
> +	LOG_MODE_CLEAR_LOG = 1,
> +
> +	LOG_MODE_NUM,
> +
> +	/* Run all supported modes */
> +	LOG_MODE_ALL = LOG_MODE_NUM,
> +};
> +
> +/* Mode of logging to test.  Default is to run all supported modes */
> +static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
> +/* Logging mode for current run */
> +static enum log_mode_t host_log_mode;
> +
> +static bool clear_log_supported(void)
> +{
> +	return kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> +}
> +
> +static void clear_log_create_vm_done(struct kvm_vm *vm)
> +{
> +	struct kvm_enable_cap cap = {};
> +
> +	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
> +	cap.args[0] = 1;
> +	vm_enable_cap(vm, &cap);
> +}
> +
> +static void dirty_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
> +					  void *bitmap, uint32_t num_pages)
> +{
> +	kvm_vm_get_dirty_log(vm, slot, bitmap);
> +}
> +
> +static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
> +					  void *bitmap, uint32_t num_pages)
> +{
> +	kvm_vm_get_dirty_log(vm, slot, bitmap);
> +	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
> +}
> +
> +struct log_mode {
> +	const char *name;
> +	/* Return true if this mode is supported, otherwise false */
> +	bool (*supported)(void);
> +	/* Hook when the vm creation is done (before vcpu creation) */
> +	void (*create_vm_done)(struct kvm_vm *vm);
> +	/* Hook to collect the dirty pages into the bitmap provided */
> +	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
> +				     void *bitmap, uint32_t num_pages);
> +} log_modes[LOG_MODE_NUM] = {
> +	{
> +		.name = "dirty-log",
> +		.collect_dirty_pages = dirty_log_collect_dirty_pages,
> +	},
> +	{
> +		.name = "clear-log",
> +		.supported = clear_log_supported,
> +		.create_vm_done = clear_log_create_vm_done,
> +		.collect_dirty_pages = clear_log_collect_dirty_pages,
> +	},
> +};
> +
>  /*
>   * We use this bitmap to track some pages that should have its dirty
>   * bit set in the _next_ iteration.  For example, if we detected the
> @@ -137,6 +204,43 @@ static uint64_t host_track_next_count;
>   */
>  static unsigned long *host_bmap_track;
>  
> +static void log_modes_dump(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < LOG_MODE_NUM; i++)
> +		printf("%s, ", log_modes[i].name);
> +	puts("\b\b  \b\b");

This will be ugly when the output is redirected to a file.
How about just

printf("%s", log_modes[0].name);
for (i = 1; i < LOG_MODE_NUM; i++)
  printf(", %s", log_modes[i].name);
printf("\n");

> +}
> +
> +static bool log_mode_supported(void)
> +{
> +	struct log_mode *mode = &log_modes[host_log_mode];
> +
> +	if (mode->supported)
> +		return mode->supported();
> +
> +	return true;
> +}
> +
> +static void log_mode_create_vm_done(struct kvm_vm *vm)
> +{
> +	struct log_mode *mode = &log_modes[host_log_mode];
> +
> +	if (mode->create_vm_done)
> +		mode->create_vm_done(vm);
> +}
> +
> +static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
> +					 void *bitmap, uint32_t num_pages)
> +{
> +	struct log_mode *mode = &log_modes[host_log_mode];
> +
> +	TEST_ASSERT(mode->collect_dirty_pages != NULL,
> +		    "collect_dirty_pages() is required for any log mode!");
> +	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
> +}
> +
>  static void generate_random_array(uint64_t *guest_array, uint64_t size)
>  {
>  	uint64_t i;
> @@ -257,6 +361,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
>  #ifdef __x86_64__
>  	vm_create_irqchip(vm);
>  #endif
> +	log_mode_create_vm_done(vm);
>  	vm_vcpu_add_default(vm, vcpuid, guest_code);
>  	return vm;
>  }
> @@ -271,6 +376,12 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	struct kvm_vm *vm;
>  	unsigned long *bmap;
>  
> +	if (!log_mode_supported()) {
> +		fprintf(stderr, "Log mode '%s' not supported, skip\n",
> +			log_modes[host_log_mode].name);

I think kvm selftests needs a skip_test() function that outputs a more
consistent test skip message. It seems we mostly do

fprintf(stderr, "%s, skipping test\n", custom_message);

but here we have ', skip'. Also, I see a few places were we output
skipping to stderr and others to stdout. I think I like stdout better.

> +		return;
> +	}
> +
>  	/*
>  	 * We reserve page table for 2 times of extra dirty mem which
>  	 * will definitely cover the original (1G+) test range.  Here
> @@ -316,14 +427,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	bmap = bitmap_alloc(host_num_pages);
>  	host_bmap_track = bitmap_alloc(host_num_pages);
>  
> -#ifdef USE_CLEAR_DIRTY_LOG
> -	struct kvm_enable_cap cap = {};
> -
> -	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
> -	cap.args[0] = 1;
> -	vm_enable_cap(vm, &cap);
> -#endif
> -
>  	/* Add an extra memory slot for testing dirty logging */
>  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
>  				    guest_test_phys_mem,
> @@ -364,11 +467,8 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	while (iteration < iterations) {
>  		/* Give the vcpu thread some time to dirty some pages */
>  		usleep(interval * 1000);
> -		kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
> -#ifdef USE_CLEAR_DIRTY_LOG
> -		kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
> -				       host_num_pages);
> -#endif
> +		log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
> +					     bmap, host_num_pages);
>  		vm_dirty_log_verify(bmap);
>  		iteration++;
>  		sync_global_to_guest(vm, iteration);
> @@ -413,6 +513,9 @@ static void help(char *name)
>  	       TEST_HOST_LOOP_INTERVAL);
>  	printf(" -p: specify guest physical test memory offset\n"
>  	       "     Warning: a low offset can conflict with the loaded test code.\n");
> +	printf(" -M: specify the host logging mode "
> +	       "(default: run all log modes).  Supported modes: \n\t");
> +	log_modes_dump();
>  	printf(" -m: specify the guest mode ID to test "
>  	       "(default: test all supported modes)\n"
>  	       "     This option may be used multiple times.\n"
> @@ -432,18 +535,11 @@ int main(int argc, char *argv[])
>  	bool mode_selected = false;
>  	uint64_t phys_offset = 0;
>  	unsigned int mode;
> -	int opt, i;
> +	int opt, i, j;
>  #ifdef __aarch64__
>  	unsigned int host_ipa_limit;
>  #endif
>  
> -#ifdef USE_CLEAR_DIRTY_LOG
> -	if (!kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2)) {
> -		fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not available, skipping tests\n");
> -		exit(KSFT_SKIP);
> -	}
> -#endif
> -
>  #ifdef __x86_64__
>  	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
>  #endif
> @@ -463,7 +559,7 @@ int main(int argc, char *argv[])
>  	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
>  #endif
>  
> -	while ((opt = getopt(argc, argv, "hi:I:p:m:")) != -1) {
> +	while ((opt = getopt(argc, argv, "hi:I:p:m:M:")) != -1) {
>  		switch (opt) {
>  		case 'i':
>  			iterations = strtol(optarg, NULL, 10);
> @@ -485,6 +581,22 @@ int main(int argc, char *argv[])
>  				    "Guest mode ID %d too big", mode);
>  			vm_guest_mode_params[mode].enabled = true;
>  			break;
> +		case 'M':

Can also add

if (!strcmp(optarg, "all"))
  host_log_mode_option = LOG_MODE_ALL;

> +			for (i = 0; i < LOG_MODE_NUM; i++) {
> +				if (!strcmp(optarg, log_modes[i].name)) {
> +					DEBUG("Setting log mode to: '%s'\n",
> +					      optarg);

Basing this on kvm/queue won't work as DEBUG() no longer exists. This
looks like a pr_info().

> +					host_log_mode_option = i;
> +					break;
> +				}
> +			}
> +			if (i == LOG_MODE_NUM) {
> +				printf("Log mode '%s' is invalid.  "
> +				       "Please choose from: ", optarg);
> +				log_modes_dump();
> +				exit(-1);

Exit code of 255? Probably just want exit(1);

> +			}
> +			break;
>  		case 'h':
>  		default:
>  			help(argv[0]);
> @@ -506,7 +618,18 @@ int main(int argc, char *argv[])
>  		TEST_ASSERT(vm_guest_mode_params[i].supported,
>  			    "Guest mode ID %d (%s) not supported.",
>  			    i, vm_guest_mode_string(i));
> -		run_test(i, iterations, interval, phys_offset);
> +		if (host_log_mode_option == LOG_MODE_ALL) {
> +			/* Run each log mode */
> +			for (j = 0; j < LOG_MODE_NUM; j++) {
> +				DEBUG("Testing Log Mode '%s'\n",
> +				      log_modes[j].name);
> +				host_log_mode = j;
> +				run_test(i, iterations, interval, phys_offset);
> +			}
> +		} else {
> +			host_log_mode = host_log_mode_option;
> +			run_test(i, iterations, interval, phys_offset);
> +		}
>  	}
>  
>  	return 0;
> -- 
> 2.24.1
>

Thanks,
drew 

