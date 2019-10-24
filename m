Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED5FE405E
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbfJXX3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:29:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:24347 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730945AbfJXX3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:29:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 16:29:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="188749553"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 24 Oct 2019 16:29:43 -0700
Date:   Thu, 24 Oct 2019 16:29:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 3/3] kvm: call kvm_arch_destroy_vm if vm creation fails
Message-ID: <20191024232943.GJ28043@linux.intel.com>
References: <20191024230327.140935-1-jmattson@google.com>
 <20191024230327.140935-4-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024230327.140935-4-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 04:03:27PM -0700, Jim Mattson wrote:
> From: John Sperbeck <jsperbeck@google.com>
> 
> In kvm_create_vm(), if we've successfully called kvm_arch_init_vm(), but
> then fail later in the function, we need to call kvm_arch_destroy_vm()
> so that it can do any necessary cleanup (like freeing memory).
> 
> Fixes: 44a95dae1d229a ("KVM: x86: Detect and Initialize AVIC support")
> 
> Signed-off-by: John Sperbeck <jsperbeck@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Junaid Shahid <junaids@google.com>
> ---
>  virt/kvm/kvm_main.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 77819597d7e8e..f8f0106f8d20f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -649,7 +649,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  		struct kvm_memslots *slots = kvm_alloc_memslots();
>  
>  		if (!slots)
> -			goto out_err_no_disable;
> +			goto out_err_no_arch_destroy_vm;
>  		/* Generations must be different for each address space. */
>  		slots->generation = i;
>  		rcu_assign_pointer(kvm->memslots[i], slots);
> @@ -659,12 +659,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  		rcu_assign_pointer(kvm->buses[i],
>  			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
>  		if (!kvm->buses[i])
> -			goto out_err_no_disable;
> +			goto out_err_no_arch_destroy_vm;
>  	}
>  
>  	r = kvm_arch_init_vm(kvm, type);
>  	if (r)
> -		goto out_err_no_disable;
> +		goto out_err_no_arch_destroy_vm;
>  
>  	r = hardware_enable_all();
>  	if (r)
> @@ -685,7 +685,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  
>  	/*
>  	 * kvm_get_kvm() isn't legal while the vm is being created
> -	 * (e.g. in kvm_arch_init_vm).
> +	 * (e.g. in kvm_arch_init_vm or kvm_arch_destroy_vm).

LOL, even I don't think this one is necessary ;-)

>  	 */
>  	refcount_set(&kvm->users_count, 1);
>  
> @@ -704,6 +704,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  out_err_no_srcu:
>  	hardware_disable_all();
>  out_err_no_disable:
> +	kvm_arch_destroy_vm(kvm);
> +out_err_no_arch_destroy_vm:
>  	for (i = 0; i < KVM_NR_BUSES; i++)
>  		kfree(kvm_get_bus(kvm, i));
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 
