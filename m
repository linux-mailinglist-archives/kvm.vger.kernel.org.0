Return-Path: <kvm+bounces-6479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8C4D833545
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 16:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D162B22BA9
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 15:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69FC012E47;
	Sat, 20 Jan 2024 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TMsp9W2X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3618511C94;
	Sat, 20 Jan 2024 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705764467; cv=none; b=U0fJJ7qwsijK4EVJBJEPRj1D5hKa5DdSeEkKafCYLMVpOFohtK0rQsFqObJh4FSVFfwATrw1ZFL6wo3To8oaZntA4WmXOBnv+r0M/b9RPyC30mU1BB8NKA4VyBzpgIVVIqw5+uPhnkeaXLqzIzplsbOXbt3SvKI+c5MiQ0tuRyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705764467; c=relaxed/simple;
	bh=/mXGlIyQCY4NHrPWDhvtkkDReoY5hcLaj9tfxnmilYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+cqgI/b9FYxkl94rDgr2Ky/EKypb8+4wPbXuFNmeyzE/+xF+YcE0TqitBNy9zdV4Ufk+jaKIeNgJxsOr0yc24lectNpPhPtWbKRJ4uTqpFnSiPAwRgkBpJj7KpAedDB7hCQnLGbzBLj3qymspBNWKbZipmF/EghUnfKJoqi2lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TMsp9W2X; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705764466; x=1737300466;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/mXGlIyQCY4NHrPWDhvtkkDReoY5hcLaj9tfxnmilYM=;
  b=TMsp9W2XjHaAQgP0CojKNXvoKza/TtsECa/fLhVjclIMDO7I18oslPop
   L2ngBoS4s2GOoG44wd/UwC9Tsb8Ef7sfI4HypS2kD4fsCEuCdtquu7wSK
   CW7kzMnULIzktPwd+18kHlaQTaIkkKWtids9FPOCeLGyILB+GyHJtPNV0
   EizggAoc9/FGPXYtwZZ2mxz1fooG+oWuK331tX28WHYOjxJUKihYgF3yP
   p+mTpwtewfCSqYO7RUJ2yG4Cwwe2QA0vjKIhe8hNfPryb6CN9cvm7lQ0U
   a+g4+xDdt2WSRYe9Dj2o8mJCi8ZFJg60ZzBrCaZwv/RZ1KH1UUT84HqEx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10959"; a="820818"
X-IronPort-AV: E=Sophos;i="6.05,208,1701158400"; 
   d="scan'208";a="820818"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2024 07:27:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10959"; a="928631934"
X-IronPort-AV: E=Sophos;i="6.05,208,1701158400"; 
   d="scan'208";a="928631934"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jan 2024 07:27:43 -0800
Date: Sat, 20 Jan 2024 23:24:31 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 4/4] KVM: Nullify async #PF worker's "apf" pointer as
 soon as it might be freed
Message-ID: <Zavlr12AwoPkKrzK@yilunxu-OptiPlex-7050>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110011533.503302-5-seanjc@google.com>

On Tue, Jan 09, 2024 at 05:15:33PM -0800, Sean Christopherson wrote:
> Nullify the async #PF worker's local "apf" pointer immediately after the
> point where the structure can be freed by the vCPU.  The existing comment
> is helpful, but easy to overlook as there is no associated code.
> 
> Update the comment to clarify that it can be freed by as soon as the lock
> is dropped, as "after this point" isn't strictly accurate, nor does it
> help understand what prevents the structure from being freed earlier.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xu Yilun <yilun.xu@intel.com>

> ---
>  virt/kvm/async_pf.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index c3f4f351a2ae..1088c6628de9 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -83,13 +83,14 @@ static void async_pf_execute(struct work_struct *work)
>  	apf->vcpu = NULL;
>  	spin_unlock(&vcpu->async_pf.lock);
>  
> -	if (!IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC) && first)
> -		kvm_arch_async_page_present_queued(vcpu);
> -
>  	/*
> -	 * apf may be freed by kvm_check_async_pf_completion() after
> -	 * this point
> +	 * The apf struct may freed by kvm_check_async_pf_completion() as soon
> +	 * as the lock is dropped.  Nullify it to prevent improper usage.
>  	 */
> +	apf = NULL;
> +
> +	if (!IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC) && first)
> +		kvm_arch_async_page_present_queued(vcpu);
>  
>  	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
>  
> -- 
> 2.43.0.472.g3155946c3a-goog
> 

