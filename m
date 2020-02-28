Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA69173C0E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 16:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgB1Poy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 10:44:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:20687 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgB1Poy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 10:44:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 07:44:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,496,1574150400"; 
   d="scan'208";a="385528002"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 28 Feb 2020 07:44:53 -0800
Date:   Fri, 28 Feb 2020 07:44:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Remove superfluous brackets in
 kvm_arch_dev_ioctl()
Message-ID: <20200228154453.GC2329@linux.intel.com>
References: <20200228052527.148384-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228052527.148384-1-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 01:25:27PM +0800, Xiaoyao Li wrote:
> Remove unnecessary brackets from the case statements in

They aren't unnecessary, e.g. simply taking away brackets without
refactoring the code will break the build.

> kvm_arch_dev_ioctl().
> 
> The brackets are visually confusing and error-prone, e.g., brackets of

They're confusing when they're broken, but IMO they're a non-issue when
used correctly, which is the vast majority of the time.  I wouldn't say I
love brackets, but for me it's preferrable to having a big pile of
variables at the top of the function.  I also find having the struct type
in the case helpful, e.g. it's easy to figure out which struct corresponds
to which ioctl in the API.

And despite this being the second instance of this style of bug in KVM in
the last few months, I don't think it's fair to call brackets error-prone.
These are literally the only two times I've ever seen this class of bug.

Regardless, using brackets to create a new scope in a case statement is a
widely used pattern:

  $ git grep case | grep ": {" | wc -l
  1954

Eliminating all current and future uses isn't realistic.

A better way to help prevent these type of bugs from being introduced
would be to teach checkpatch to issue a warning if a set of brackets
encapsulates a case statement.

Fixing this particular bug is then a small patch, and maybe throw in an
opportunistic cleanup to add a "break" in the default path.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2103101eca78..f059697bf61e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3485,6 +3485,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
                        goto out;
                r = 0;
                break;
+       }
        case KVM_GET_MSR_FEATURE_INDEX_LIST: {
                struct kvm_msr_list __user *user_msr_list = argp;
                struct kvm_msr_list msr_list;
@@ -3510,9 +3511,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
        case KVM_GET_MSRS:
                r = msr_io(NULL, argp, do_get_msr_feature, 1);
                break;
-       }
        default:
                r = -EINVAL;
+               break;
        }
 out:
        return r;

> case KVM_X86_GET_MCE_CAP_SUPPORTED accidently includes case
> KVM_GET_MSR_FEATURE_INDEX_LIST and KVM_GET_MSRS.
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/x86.c | 33 ++++++++++++++-------------------
>  1 file changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ddd1d296bd20..9efd693189df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3412,14 +3412,16 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  long kvm_arch_dev_ioctl(struct file *filp,
>  			unsigned int ioctl, unsigned long arg)
>  {
> -	void __user *argp = (void __user *)arg;
> +	struct kvm_msr_list __user *user_msr_list;
> +	struct kvm_cpuid2 __user *cpuid_arg;
> +	struct kvm_msr_list msr_list;
> +	struct kvm_cpuid2 cpuid;
> +	unsigned int n;
>  	long r;
>  
>  	switch (ioctl) {
> -	case KVM_GET_MSR_INDEX_LIST: {
> -		struct kvm_msr_list __user *user_msr_list = argp;
> -		struct kvm_msr_list msr_list;
> -		unsigned n;
> +	case KVM_GET_MSR_INDEX_LIST:
> +		user_msr_list = (void __user *)arg;
>  
>  		r = -EFAULT;
>  		if (copy_from_user(&msr_list, user_msr_list, sizeof(msr_list)))
> @@ -3441,11 +3443,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  			goto out;
>  		r = 0;
>  		break;
> -	}
>  	case KVM_GET_SUPPORTED_CPUID:
> -	case KVM_GET_EMULATED_CPUID: {
> -		struct kvm_cpuid2 __user *cpuid_arg = argp;
> -		struct kvm_cpuid2 cpuid;
> +	case KVM_GET_EMULATED_CPUID:
> +		cpuid_arg = (void __user *)arg;
>  
>  		r = -EFAULT;
>  		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
> @@ -3461,18 +3461,15 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  			goto out;
>  		r = 0;
>  		break;
> -	}
> -	case KVM_X86_GET_MCE_CAP_SUPPORTED: {
> +	case KVM_X86_GET_MCE_CAP_SUPPORTED:
>  		r = -EFAULT;
> -		if (copy_to_user(argp, &kvm_mce_cap_supported,
> +		if (copy_to_user((void __user *)arg, &kvm_mce_cap_supported,
>  				 sizeof(kvm_mce_cap_supported)))
>  			goto out;
>  		r = 0;
>  		break;
> -	case KVM_GET_MSR_FEATURE_INDEX_LIST: {
> -		struct kvm_msr_list __user *user_msr_list = argp;
> -		struct kvm_msr_list msr_list;
> -		unsigned int n;
> +	case KVM_GET_MSR_FEATURE_INDEX_LIST:
> +		user_msr_list = (void __user *)arg;
>  
>  		r = -EFAULT;
>  		if (copy_from_user(&msr_list, user_msr_list, sizeof(msr_list)))
> @@ -3490,11 +3487,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  			goto out;
>  		r = 0;
>  		break;
> -	}
>  	case KVM_GET_MSRS:
> -		r = msr_io(NULL, argp, do_get_msr_feature, 1);
> +		r = msr_io(NULL, (void __user *)arg, do_get_msr_feature, 1);
>  		break;
> -	}
>  	default:
>  		r = -EINVAL;
>  	}
> -- 
> 2.19.1
> 
