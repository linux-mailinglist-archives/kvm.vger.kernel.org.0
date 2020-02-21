Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC519168172
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgBUPYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:24:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:13619 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbgBUPYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 10:24:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 07:23:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,468,1574150400"; 
   d="scan'208";a="230458771"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 21 Feb 2020 07:23:58 -0800
Date:   Fri, 21 Feb 2020 07:23:58 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: X86: eliminate some meaningless code
Message-ID: <20200221152358.GC12665@linux.intel.com>
References: <1582293926-23388-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582293926-23388-1-git-send-email-linmiaohe@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 10:05:26PM +0800, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> When kvm_vcpu_ioctl_get_cpuid2() fails, we set cpuid->nent to the value of
> vcpu->arch.cpuid_nent. But this is in vain as cpuid->nent is not copied to
> userspace by copy_to_user() from call site. Get rid of this meaningless
> assignment and further cleanup the var r and out jump label.

Ha, took me a while to see that.
 
> On the other hand, when kvm_vcpu_ioctl_get_cpuid2() succeeds, we do not
> change the content of struct cpuid. We can avoid copy_to_user() from call
> site as struct cpuid remain unchanged.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/cpuid.c | 14 ++++----------
>  arch/x86/kvm/x86.c   |  6 ------
>  2 files changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..b83cedc63328 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -265,20 +265,14 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>  			      struct kvm_cpuid2 *cpuid,
>  			      struct kvm_cpuid_entry2 __user *entries)
>  {
> -	int r;
> -
> -	r = -E2BIG;
>  	if (cpuid->nent < vcpu->arch.cpuid_nent)
> -		goto out;
> -	r = -EFAULT;
> +		return -E2BIG;
> +
>  	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
>  			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
> -		goto out;
> -	return 0;

Hmm, so this ioctl() is straight up broken.  cpuid->nent should be updated
on success so that userspace knows how many entries were retrieved, i.e.
the code should look something like below, with kvm_arch_vcpu_ioctl()
unchanged.

I'm guessing no VMM actually uses this ioctl(), e.g. neither Qemu or CrosVM
use it, which is why the broken behavior has gone unnoticed.  Don't suppose
you'd want to write a selftest to hammer KVM_{SET,GET}_CPUID2?

int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
                              struct kvm_cpuid2 *cpuid,
                              struct kvm_cpuid_entry2 __user *entries)
{
        if (cpuid->nent < vcpu->arch.cpuid_nent)
                return -E2BIG;

        if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
                         vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
                return -EFAULT;

	cpuid->nent = vcpu->arch.cpuid_nent;

        return 0;
}

> +		return -EFAULT;
>  
> -out:
> -	cpuid->nent = vcpu->arch.cpuid_nent;
> -	return r;
> +	return 0;
>  }
>  
>  static __always_inline void cpuid_mask(u32 *word, int wordnum)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbabb2f06273..683c54e7be36 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4295,12 +4295,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  			goto out;
>  		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
>  					      cpuid_arg->entries);
> -		if (r)
> -			goto out;
> -		r = -EFAULT;
> -		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
> -			goto out;
> -		r = 0;
>  		break;
>  	}
>  	case KVM_GET_MSRS: {
> -- 
> 2.19.1
> 
