Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D6AE4058
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbfJXX2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:28:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:24181 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbfJXX2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:28:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 16:28:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="204390348"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Oct 2019 16:28:02 -0700
Date:   Thu, 24 Oct 2019 16:28:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 2/3] kvm: Allocate memslots and buses before calling
 kvm_arch_init_vm
Message-ID: <20191024232802.GI28043@linux.intel.com>
References: <20191024230327.140935-1-jmattson@google.com>
 <20191024230327.140935-3-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024230327.140935-3-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 04:03:26PM -0700, Jim Mattson wrote:
> This reorganization will allow us to call kvm_arch_destroy_vm in the
> event that kvm_create_vm fails after calling kvm_arch_init_vm.
> 
> Suggested-by: Junaid Shahid <junaids@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Junaid Shahid <junaids@google.com>
> ---
>  virt/kvm/kvm_main.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 525e0dbc623f9..77819597d7e8e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -627,8 +627,9 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  
>  static struct kvm *kvm_create_vm(unsigned long type)
>  {
> -	int r, i;
>  	struct kvm *kvm = kvm_arch_alloc_vm();
> +	int r = -ENOMEM;
> +	int i;
>  
>  	if (!kvm)
>  		return ERR_PTR(-ENOMEM);
> @@ -642,6 +643,25 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	mutex_init(&kvm->slots_lock);
>  	INIT_LIST_HEAD(&kvm->devices);
>  
> +	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
> +
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		struct kvm_memslots *slots = kvm_alloc_memslots();
> +
> +		if (!slots)
> +			goto out_err_no_disable;
> +		/* Generations must be different for each address space. */
> +		slots->generation = i;
> +		rcu_assign_pointer(kvm->memslots[i], slots);
> +	}
> +
> +	for (i = 0; i < KVM_NR_BUSES; i++) {
> +		rcu_assign_pointer(kvm->buses[i],
> +			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
> +		if (!kvm->buses[i])
> +			goto out_err_no_disable;

Personally I'd prefer to add labels for each stage of destruction instead
of abusing the NULL handling of kfree() and kvm_free_memslots(), especially
since not doing so forces the next patch to update these gotos.

Inverting the labels to describe what's being done instead of what's not
being done might help with the readability and naming.

> +	}
> +
>  	r = kvm_arch_init_vm(kvm, type);
>  	if (r)
>  		goto out_err_no_disable;
> @@ -654,28 +674,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
>  #endif
>  
> -	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
> -
> -	r = -ENOMEM;
> -	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> -		struct kvm_memslots *slots = kvm_alloc_memslots();
> -		if (!slots)
> -			goto out_err_no_srcu;
> -		/* Generations must be different for each address space. */
> -		slots->generation = i;
> -		rcu_assign_pointer(kvm->memslots[i], slots);
> -	}
> -
>  	if (init_srcu_struct(&kvm->srcu))
>  		goto out_err_no_srcu;
>  	if (init_srcu_struct(&kvm->irq_srcu))
>  		goto out_err_no_irq_srcu;
> -	for (i = 0; i < KVM_NR_BUSES; i++) {
> -		rcu_assign_pointer(kvm->buses[i],
> -			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
> -		if (!kvm->buses[i])
> -			goto out_err;
> -	}
>  
>  	r = kvm_init_mmu_notifier(kvm);
>  	if (r)
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 
