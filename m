Return-Path: <kvm+bounces-10780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3B286FCD6
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 10:13:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB68EB20C22
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D880C1B971;
	Mon,  4 Mar 2024 09:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B16j+h9G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B6C1B7E8;
	Mon,  4 Mar 2024 09:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709543574; cv=none; b=nYFjbR6dINV4hwe2oqqwUYtowcHU6+GgJ+NVD6ejRXpd+xf7XWDZnb9MvjzbfNH1dYYyN1EkIO5pxJ2uOYYsIkFwCn76NW0F9ePmkzsifPjlsNdYijy1rrKM/xLvsV73NKquZPN61qUiijEOsFk33UjrsKkQQfZ6A7/iOcB84y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709543574; c=relaxed/simple;
	bh=fYUc9MBfCK5M1i9aW28WCU7ziu1UFtyPbddQMGeFd2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/RD3ogXrUDznDwGKtOVVbE9vLtoHWkeXIqoTwTNCstY30r2r19hrNHEj62eWA1h35KgZD45a6eakXOpn6tY2Qjbkm+4xFWnlJ0hrxfoyrSBNc7d0Y4tTCkZtk1HbbCQr1gyh16BFtHtO2zPbmyP5DTwI0CAiCDPJ8t7j4E7rWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B16j+h9G; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709543572; x=1741079572;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fYUc9MBfCK5M1i9aW28WCU7ziu1UFtyPbddQMGeFd2w=;
  b=B16j+h9GsWu01gWbv8pxEX4znck67+f1QR942Aqb9MYKyg5Xs+um3uv8
   o3OKT2yDiHHJ6zOPeBLKfh3gcX5HUI+H7cbMh2OW2fpGqtG0lbpHuGzMg
   6EowJRv85TmN1xizGgeGGNPLqk7CYU+8pm9pda6DrGxDB7WmW4KWMeUno
   JGJ4HpR+PyD0fuHAFlAROQQXRrfd9QRhA+iKI9ce8EVVjpFEwapolaxwg
   Rd3/CQaGALy+Fq/otnxoZAGQnCJv6Es/fk4FJRKjUjivc3PBBSlRhkFGG
   fYBY3N5+EXUD5C7p1OWqO52gjEfNxUFTBSQvZ1GFAgRjCCkDqBPjzBEbr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="4188817"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="4188817"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 01:12:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="13589213"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 04 Mar 2024 01:12:49 -0800
Date: Mon, 4 Mar 2024 17:08:38 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, aik@amd.com
Subject: Re: [PATCH v3 02/15] KVM: x86: use u64_to_user_addr()
Message-ID: <ZeWPlvFAgtUOE7vm@yilunxu-OptiPlex-7050>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226190344.787149-3-pbonzini@redhat.com>

On Mon, Feb 26, 2024 at 02:03:31PM -0500, Paolo Bonzini wrote:
> There is no danger to the kernel if userspace provides a 64-bit value that
> has the high bits set, but for whatever reason happ[ens to resolve to an
                                                     ^

remove the messy char.

> address that has something mapped there.  KVM uses the checked version
> of put_user() in kvm_x86_dev_get_attr().

See from the code change, not just kvm_x86_dev_get_attr().

Thanks,
Yilun

> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 24 +++---------------------
>  1 file changed, 3 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f3f7405e0628..14c969782d73 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4791,25 +4791,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	return r;
>  }
>  
> -static inline void __user *kvm_get_attr_addr(struct kvm_device_attr *attr)
> -{
> -	void __user *uaddr = (void __user*)(unsigned long)attr->addr;
> -
> -	if ((u64)(unsigned long)uaddr != attr->addr)
> -		return ERR_PTR_USR(-EFAULT);
> -	return uaddr;
> -}
> -
>  static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
>  {
> -	u64 __user *uaddr = kvm_get_attr_addr(attr);
> +	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
>  
>  	if (attr->group)
>  		return -ENXIO;
>  
> -	if (IS_ERR(uaddr))
> -		return PTR_ERR(uaddr);
> -
>  	switch (attr->attr) {
>  	case KVM_X86_XCOMP_GUEST_SUPP:
>  		if (put_user(kvm_caps.supported_xcr0, uaddr))
> @@ -5664,12 +5652,9 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
>  static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
>  				 struct kvm_device_attr *attr)
>  {
> -	u64 __user *uaddr = kvm_get_attr_addr(attr);
> +	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
>  	int r;
>  
> -	if (IS_ERR(uaddr))
> -		return PTR_ERR(uaddr);
> -
>  	switch (attr->attr) {
>  	case KVM_VCPU_TSC_OFFSET:
>  		r = -EFAULT;
> @@ -5687,13 +5672,10 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
>  static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
>  				 struct kvm_device_attr *attr)
>  {
> -	u64 __user *uaddr = kvm_get_attr_addr(attr);
> +	u64 __user *uaddr = u64_to_user_ptr(attr->addr);
>  	struct kvm *kvm = vcpu->kvm;
>  	int r;
>  
> -	if (IS_ERR(uaddr))
> -		return PTR_ERR(uaddr);
> -
>  	switch (attr->attr) {
>  	case KVM_VCPU_TSC_OFFSET: {
>  		u64 offset, tsc, ns;
> -- 
> 2.39.1
> 
> 
> 

