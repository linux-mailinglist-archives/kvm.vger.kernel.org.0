Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985E2E2267
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 20:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388625AbfJWSVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 14:21:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:4472 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388078AbfJWSVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 14:21:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 11:21:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="210120369"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 23 Oct 2019 11:21:06 -0700
Date:   Wed, 23 Oct 2019 11:21:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        John Sperbeck <jsperbeck@google.com>
Subject: Re: [PATCH] kvm: call kvm_arch_destroy_vm if vm creation fails
Message-ID: <20191023182106.GB26295@linux.intel.com>
References: <20191023171435.46287-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023171435.46287-1-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 23, 2019 at 10:14:35AM -0700, Jim Mattson wrote:
> From: John Sperbeck <jsperbeck@google.com>
> 
> In kvm_create_vm(), if we've successfully called kvm_arch_init_vm(), but
> then fail later in the function, we need to call kvm_arch_destroy_vm()
> so that it can do any necessary cleanup (like freeing memory).
> 
> Fixes: 44a95dae1d229a ("KVM: x86: Detect and Initialize AVIC support")
> Signed-off-by: John Sperbeck <jsperbeck@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  virt/kvm/kvm_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fd68fbe0a75d2..10ac7ae03677b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -645,7 +645,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  
>  	r = kvm_arch_init_vm(kvm, type);
>  	if (r)
> -		goto out_err_no_disable;
> +		goto out_err_no_arch_destroy_vm;
>  
>  	r = hardware_enable_all();
>  	if (r)
> @@ -698,10 +698,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	hardware_disable_all();
>  out_err_no_disable:
>  	refcount_set(&kvm->users_count, 0);
> +	kvm_arch_destroy_vm(kvm);

Calling destroy_vm() after zeroing the refcount could lead to a refcount
underrun (and a WARN with CONFIG_REFCOUNT_FULL=y) if an arch were to do
kvm_put_kvm() in destroy_vm() to pair with a kvm_get_kvm() in create_vm().
I doubt any arch actually does that, but it's technically possible since
kvm_arch_create_vm() is called with users_count=1.

If we wanted to be paranoid, a follow-up patch could change refcount_set()
to WARN_ON(!refcount_dec_and_dest()), e.g.:

	kvm_arch_destroy_vm(kvm);
	WARN_ON(!refcount_dec_and_dest(&kvm->users_count));

>  	for (i = 0; i < KVM_NR_BUSES; i++)
>  		kfree(kvm_get_bus(kvm, i));
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
>  		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
> +out_err_no_arch_destroy_vm:
>  	kvm_arch_free_vm(kvm);
>  	mmdrop(current->mm);
>  	return ERR_PTR(r);
> -- 
> 2.23.0.866.gb869b98d4c-goog
> 
