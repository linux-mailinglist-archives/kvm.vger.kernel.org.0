Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B118AD7E
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 08:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCSHua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 03:50:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32189 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgCSHu3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 03:50:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584604227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1FjOpHO7DVBelpmj+x+16nQtzOUq2HDnloAulowS+9c=;
        b=eVuZ6/Kmno57qZpnP2QpHCCXPrqvsMHQeay0xf/j3AXGhKSd5I/i3vVdMEAlqljLh40RZU
        U6YcO6uBlDkP+sEjDfdS0gObxO9K8BeNBa9FwQkSujZNsY9V62YRFUgkDJyPhkVQDX8cL4
        x/Qf4jOy6gCqTj7y0sq05BCBvZ6il0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-bZiPtl6MN6-Z1oAlMHQFdA-1; Thu, 19 Mar 2020 03:50:24 -0400
X-MC-Unique: bZiPtl6MN6-Z1oAlMHQFdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED885477;
        Thu, 19 Mar 2020 07:50:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 925316EFA7;
        Thu, 19 Mar 2020 07:50:08 +0000 (UTC)
Date:   Thu, 19 Mar 2020 08:50:05 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 11/14] KVM: selftests: Introduce after_vcpu_run hook
 for dirty log test
Message-ID: <20200319075005.hdddb4xiqzuxcqbn@kamzik.brq.redhat.com>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-12-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318163720.93929-12-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 18, 2020 at 12:37:17PM -0400, Peter Xu wrote:
> Provide a hook for the checks after vcpu_run() completes.  Preparation
> for the dirty ring test because we'll need to take care of another
> exit reason.
> 
> Since at it, drop the pages_count because after all we have a better
> summary right now with statistics, and clean it up a bit.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 41 ++++++++++++++------
>  1 file changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 139ccb550618..94122c2e0185 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -178,6 +178,15 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
>  	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
>  }
>  
> +static void default_after_vcpu_run(struct kvm_vm *vm)
> +{
> +	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +
> +	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
> +		    "Invalid guest sync status: exit_reason=%s\n",
> +		    exit_reason_str(run->exit_reason));
> +}
> +
>  struct log_mode {
>  	const char *name;
>  	/* Return true if this mode is supported, otherwise false */
> @@ -187,16 +196,20 @@ struct log_mode {
>  	/* Hook to collect the dirty pages into the bitmap provided */
>  	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
>  				     void *bitmap, uint32_t num_pages);
> +	/* Hook to call when after each vcpu run */
> +	void (*after_vcpu_run)(struct kvm_vm *vm);
>  } log_modes[LOG_MODE_NUM] = {
>  	{
>  		.name = "dirty-log",
>  		.collect_dirty_pages = dirty_log_collect_dirty_pages,
> +		.after_vcpu_run = default_after_vcpu_run,
>  	},
>  	{
>  		.name = "clear-log",
>  		.supported = clear_log_supported,
>  		.create_vm_done = clear_log_create_vm_done,
>  		.collect_dirty_pages = clear_log_collect_dirty_pages,
> +		.after_vcpu_run = default_after_vcpu_run,
>  	},
>  };
>  
> @@ -247,6 +260,14 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
>  	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
>  }
>  
> +static void log_mode_after_vcpu_run(struct kvm_vm *vm)
> +{
> +	struct log_mode *mode = &log_modes[host_log_mode];
> +
> +	if (mode->after_vcpu_run)
> +		mode->after_vcpu_run(vm);
> +}
> +
>  static void generate_random_array(uint64_t *guest_array, uint64_t size)
>  {
>  	uint64_t i;
> @@ -261,25 +282,23 @@ static void *vcpu_worker(void *data)
>  	struct kvm_vm *vm = data;
>  	uint64_t *guest_array;
>  	uint64_t pages_count = 0;
> -	struct kvm_run *run;
> +	struct sigaction sigact;
>  
> -	run = vcpu_state(vm, VCPU_ID);
> +	current_vm = vm;
> +	vcpu_fd = vcpu_get_fd(vm, VCPU_ID);

You don't add this call until 13/14, which means bisection is broken.
Please test the series with 'git rebase -i -x make'.


> +	memset(&sigact, 0, sizeof(sigact));
> +	sigact.sa_handler = vcpu_sig_handler;
> +	sigaction(SIG_IPI, &sigact, NULL);
>  
>  	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
> -	generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
>  
>  	while (!READ_ONCE(host_quit)) {
> +		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
> +		pages_count += TEST_PAGES_PER_LOOP;
>  		/* Let the guest dirty the random pages */
>  		ret = _vcpu_run(vm, VCPU_ID);
>  		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
> -		if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
> -			pages_count += TEST_PAGES_PER_LOOP;
> -			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
> -		} else {
> -			TEST_FAIL("Invalid guest sync status: "
> -				  "exit_reason=%s\n",
> -				  exit_reason_str(run->exit_reason));
> -		}
> +		log_mode_after_vcpu_run(vm);
>  	}
>  
>  	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
> -- 
> 2.24.1
> 

