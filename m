Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ED7E2748
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 02:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392795AbfJXAFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 20:05:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:2315 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392153AbfJXAFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 20:05:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 17:05:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,222,1569308400"; 
   d="scan'208";a="223373532"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 23 Oct 2019 17:05:44 -0700
Date:   Wed, 23 Oct 2019 17:05:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        John Sperbeck <jsperbeck@google.com>
Subject: Re: [PATCH v2] kvm: call kvm_arch_destroy_vm if vm creation fails
Message-ID: <20191024000544.GA3744@linux.intel.com>
References: <20191023203214.93252-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023203214.93252-1-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 23, 2019 at 01:32:14PM -0700, Jim Mattson wrote:
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

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

>  v1 -> v2: Call kvm_arch_destroy_vm before refcount_set
>  
>  virt/kvm/kvm_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fd68fbe0a75d2..c1a1cc2aa7a80 100644
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
> @@ -697,11 +697,13 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  out_err_no_srcu:
>  	hardware_disable_all();
>  out_err_no_disable:
> +	kvm_arch_destroy_vm(kvm);
>  	refcount_set(&kvm->users_count, 0);
>  	for (i = 0; i < KVM_NR_BUSES; i++)
>  		kfree(kvm_get_bus(kvm, i));
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
>  		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));

Side topic, the loops to free the buses and memslots belong higher up,
the arrays aren't initialized until after hardware_enable().  Probably
doesn't harm anything but it's a waste of cycles.  I'll send a patch.

> +out_err_no_arch_destroy_vm:
>  	kvm_arch_free_vm(kvm);
>  	mmdrop(current->mm);
>  	return ERR_PTR(r);
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 
