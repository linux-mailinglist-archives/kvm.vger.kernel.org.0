Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E141CB66A
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 19:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgEHR5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 13:57:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:63178 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgEHR5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 13:57:38 -0400
IronPort-SDR: yc39fyxfdIoQlWEAD8fDk9pVLjHx/8nME3uJ6lFMdYAt7AeS7SeGdy3/puRvU+6wXMBITb6C25
 r91myFkyZ0Ag==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 10:57:37 -0700
IronPort-SDR: kQBNDjAa47UKKiKVoYs+5QfbZL14CY3OgXOA+VQ+cQ3eAPLyUFnXyf+WKv3/cQNHZIBOkO0Joq
 dACaWLCBD7lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,368,1583222400"; 
   d="scan'208";a="462660139"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 08 May 2020 10:57:37 -0700
Date:   Fri, 8 May 2020 10:57:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Move definition of __ex to kvm_host.h
Message-ID: <20200508175737.GM27052@linux.intel.com>
References: <20200508062753.10889-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508062753.10889-1-ubizjak@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 08:27:53AM +0200, Uros Bizjak wrote:
> Move the definition of __ex to a common include to be
> shared between VMX and SVM.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  arch/x86/kvm/svm/svm.c          | 2 --
>  arch/x86/kvm/vmx/ops.h          | 2 --
>  3 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 35a915787559..4df0c07b0a62 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1620,6 +1620,8 @@ asmlinkage void kvm_spurious_fault(void);
>  	"668: \n\t"							\
>  	_ASM_EXTABLE(666b, 667b)
>  
> +#define __ex(x) __kvm_handle_fault_on_reboot(x)

Moving this to asm/kvm_host.h is a bit sketchy as __ex() isn't exactly the
most unique name.  arch/x86/kvm/x86.h would probably be a better
destination as it's "private".  __ex() is only used in vmx.c, nested.c and
svm.c, all of which already include x86.h.

> +
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>  int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 57fdd752d2bb..9ea0a69d7fee 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -42,8 +42,6 @@
>  
>  #include "svm.h"
>  
> -#define __ex(x) __kvm_handle_fault_on_reboot(x)
> -
>  MODULE_AUTHOR("Qumranet");
>  MODULE_LICENSE("GPL");
>  
> diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
> index 5f1ac002b4b6..3cec799837e8 100644
> --- a/arch/x86/kvm/vmx/ops.h
> +++ b/arch/x86/kvm/vmx/ops.h
> @@ -10,8 +10,6 @@
>  #include "evmcs.h"
>  #include "vmcs.h"
>  
> -#define __ex(x) __kvm_handle_fault_on_reboot(x)
> -
>  asmlinkage void vmread_error(unsigned long field, bool fault);
>  __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
>  							 bool fault);
> -- 
> 2.25.4
> 
