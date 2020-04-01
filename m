Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6F19A5C6
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 09:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbgDAHDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 03:03:44 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30380 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731792AbgDAHDo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 03:03:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585724622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=peXFAP/tNqhduATvqLwoltzsPFD/EhXv4vwTpmobIrQ=;
        b=TYUzK2Ra3dFGiDylIRaiCbyiEV07Lbdv5hVKspbIffSbM0W7s40e6Ezfo6gA0RFKjby9ob
        lsFreGzn7LMGJG7GjXbS8FrbOCz70grzpzG4nLhxUlg7oMeWzbXekiHVS5J6q/0OJI4HIW
        gRppuh1cU4+gNJKEgmfT1cmZCLOiphw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-Q5TMCUgcOFClZTm4UNkHzw-1; Wed, 01 Apr 2020 03:03:41 -0400
X-MC-Unique: Q5TMCUgcOFClZTm4UNkHzw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D42A1107ACC7;
        Wed,  1 Apr 2020 07:03:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F159F5E000;
        Wed,  1 Apr 2020 07:03:25 +0000 (UTC)
Date:   Wed, 1 Apr 2020 09:03:22 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v8 11/14] KVM: selftests: Introduce after_vcpu_run hook
 for dirty log test
Message-ID: <20200401070322.yqdp5g2amzlbftk6@kamzik.brq.redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
 <20200331190000.659614-12-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331190000.659614-12-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 02:59:57PM -0400, Peter Xu wrote:
> Provide a hook for the checks after vcpu_run() completes.  Preparation
> for the dirty ring test because we'll need to take care of another
> exit reason.
> 
> Since at it, drop the pages_count because after all we have a better
> summary right now with statistics, and clean it up a bit.

I don't see what you mean by "drop the pages_count", because it's still
there. But otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>

> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 36 +++++++++++++-------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 139ccb550618..a2160946bcf5 100644
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
> @@ -261,25 +282,16 @@ static void *vcpu_worker(void *data)
>  	struct kvm_vm *vm = data;
>  	uint64_t *guest_array;
>  	uint64_t pages_count = 0;
> -	struct kvm_run *run;
> -
> -	run = vcpu_state(vm, VCPU_ID);
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

