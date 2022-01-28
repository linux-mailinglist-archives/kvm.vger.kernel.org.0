Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AF849F37B
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 07:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346380AbiA1GXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 01:23:05 -0500
Received: from mga05.intel.com ([192.55.52.43]:59204 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230048AbiA1GXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 01:23:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643350985; x=1674886985;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6irQ78t5n9MzVfcySSYal2d+bHS5atM4R3TKuen5qig=;
  b=Fi2oNL/bR6lmK03rP/BZ3629zZNXl/dTngY7fus/t3wcmZYl+VVu52QI
   Phf3l9b6EWfL++v2XkYW+M038vk0KAIfmQskq4cfOZud+cLJMk/0Z0NzI
   hKlv270SOrfPipxTVJS7i9LfsSDYY8CuOhQq5uwq8BPN87YNo4ZLFcMhk
   pOy5fLye7Pkxo0lTrhuhLy1HSsIuipTo+2jfjMCu7f1L03Ojp+8klvvle
   LGvD968U1q7cPu30jXwG0ir+FmnTmDFpnCOh7WRfDLR/rR1/4pQQpaPIr
   j2XZjQhPU3ZzqM6MpmfqadHKUYsDgWr2D7fIlxlBby4/tRUTUeDp966x8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="333409267"
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="333409267"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 22:23:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="480621957"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.145.56])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 27 Jan 2022 22:23:03 -0800
Date:   Fri, 28 Jan 2022 14:07:40 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yang.zhong@intel.com
Subject: Re: [PATCH 2/3] KVM: x86: add system attribute to retrieve full set
 of supported xsave states
Message-ID: <20220128060740.GB10089@yangzhon-Virtual>
References: <20220126152210.3044876-1-pbonzini@redhat.com>
 <20220126152210.3044876-3-pbonzini@redhat.com>
 <YfK71pSnmtpnSJQ8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YfK71pSnmtpnSJQ8@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022 at 03:35:50PM +0000, Sean Christopherson wrote:
> On Wed, Jan 26, 2022, Paolo Bonzini wrote:
> > +static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
> > +{
> > +	if (attr->group)
> > +		return -ENXIO;
> > +
> > +	switch (attr->attr) {
> > +	case KVM_X86_XCOMP_GUEST_SUPP:
> > +		if (put_user(supported_xcr0, (u64 __user *)attr->addr))
> 
> Deja vu[*].
> 
>   arch/x86/kvm/x86.c: In function ‘kvm_x86_dev_get_attr’:
>   arch/x86/kvm/x86.c:4345:46: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>    4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>         |                                              ^
>   arch/x86/include/asm/uaccess.h:221:31: note: in definition of macro ‘do_put_user_call’
>     221 |         register __typeof__(*(ptr)) __val_pu asm("%"_ASM_AX);           \
>         |                               ^~~
>   arch/x86/kvm/x86.c:4345:21: note: in expansion of macro ‘put_user’
>    4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>         |                     ^~~~~~~~
>   arch/x86/kvm/x86.c:4345:46: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>    4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>         |                                              ^
>   arch/x86/include/asm/uaccess.h:223:21: note: in definition of macro ‘do_put_user_call’
>     223 |         __ptr_pu = (ptr);                                               \
>         |                     ^~~
>   arch/x86/kvm/x86.c:4345:21: note: in expansion of macro ‘put_user’
>    4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>         |                     ^~~~~~~~
>   arch/x86/kvm/x86.c:4345:46: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>    4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>         |                                              ^
>   arch/x86/include/asm/uaccess.h:230:45: note: in definition of macro ‘do_put_user_call’
>     230 |                        [size] "i" (sizeof(*(ptr)))                      \
>         |                                             ^~~
>   arch/x86/kvm/x86.c:4345:21: note: in expansion of macro ‘put_user’
>    4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
> 
> Given that we're collectively 2 for 2 in mishandling {g,s}et_attr(), what about
> a prep pacth like so?  Compile tested only...
>

  Just found those issues are from 32bit kernel build, thanks!
  
  I applied below patch, and did AMX functions test, this patch work well with AMX.

  Thanks!
  Yang

 
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 27 Jan 2022 07:31:53 -0800
> Subject: [PATCH] KVM: x86: Add a helper to retrieve userspace address from
>  kvm_device_attr
> 
> Add a helper to handle converting the u64 userspace address embedded in
> struct kvm_device_attr into a userspace pointer, it's all too easy to
> forget the intermediate "unsigned long" cast as well as the truncation
> check.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8033eca6f3a1..67836f7c71f5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4335,14 +4335,28 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	return r;
>  }
> 
> +static inline void __user *kvm_get_attr_addr(struct kvm_device_attr *attr)
> +{
> +	void __user *uaddr = (void __user*)(unsigned long)attr->addr;
> +
> +	if ((u64)(unsigned long)uaddr != attr->addr)
> +		return ERR_PTR(-EFAULT);
> +	return uaddr;
> +}
> +
>  static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
>  {
> +	u64 __user *uaddr = kvm_get_attr_addr(attr);
> +
>  	if (attr->group)
>  		return -ENXIO;
> 
> +	if (IS_ERR(uaddr))
> +		return PTR_ERR(uaddr);
> +
>  	switch (attr->attr) {
>  	case KVM_X86_XCOMP_GUEST_SUPP:
> -		if (put_user(supported_xcr0, (u64 __user *)attr->addr))
> +		if (put_user(supported_xcr0, uaddr))
>  			return -EFAULT;
>  		return 0;
>  	default:
> @@ -5070,11 +5084,11 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
>  static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
>  				 struct kvm_device_attr *attr)
>  {
> -	u64 __user *uaddr = (u64 __user *)(unsigned long)attr->addr;
> +	u64 __user *uaddr = kvm_get_attr_addr(attr);
>  	int r;
> 
> -	if ((u64)(unsigned long)uaddr != attr->addr)
> -		return -EFAULT;
> +	if (IS_ERR(uaddr))
> +		return PTR_ERR(uaddr);
> 
>  	switch (attr->attr) {
>  	case KVM_VCPU_TSC_OFFSET:
> @@ -5093,12 +5107,12 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
>  static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
>  				 struct kvm_device_attr *attr)
>  {
> -	u64 __user *uaddr = (u64 __user *)(unsigned long)attr->addr;
> +	u64 __user *uaddr = kvm_get_attr_addr(attr);
>  	struct kvm *kvm = vcpu->kvm;
>  	int r;
> 
> -	if ((u64)(unsigned long)uaddr != attr->addr)
> -		return -EFAULT;
> +	if (IS_ERR(uaddr))
> +		return PTR_ERR(uaddr);
> 
>  	switch (attr->attr) {
>  	case KVM_VCPU_TSC_OFFSET: {
> --
> 
> 
> 
> [*] https://lore.kernel.org/all/20211007231647.3553604-1-seanjc@google.com
> 
> 
> > +			return -EFAULT;
> > +		return 0;
> > +	default:
> > +		return -ENXIO;
> > +		break;
> > +	}
> > +}
> > +
