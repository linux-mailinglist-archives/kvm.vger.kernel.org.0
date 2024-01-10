Return-Path: <kvm+bounces-5982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8EC82948B
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 08:55:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E3F01F280E8
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 07:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1743C47B;
	Wed, 10 Jan 2024 07:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XHvz8zwR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D58C364B4;
	Wed, 10 Jan 2024 07:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704873324; x=1736409324;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y6Mii2fEJq+LAezalOLGEKnkrctOM7rZFhPVgIL+OZ8=;
  b=XHvz8zwRrr6DFExfWFPovc/2CO26dL0riCneradj15QPSiGfDddDehiq
   iZ9h47B4HR0ed9xFXdK6OM5kGiHLzEoJ3Ns2MnXtWaP3cUpWd88Bkribg
   /uax6uHdm1CfhzzC4t+wKMdTz9xtZQ5o1PLCHDC0SdIeikvReHibMVCtc
   i/89261ML+RzpO9mXF3ZNRFelPPC/7rXcnl98sPyC9HLkXad+Ebk9PMW0
   bG1AtmUGBQUP4A6Qfpm/mgt49n079oIWKH4022AAxgjbArHOhqKU0mS41
   JH6Hqdl6ZX2xBujmbAqu4qo128OStIdkikafaqKSACRM4NVXELYJjrjtz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="398130262"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="398130262"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 23:55:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="901054996"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="901054996"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2024 23:55:21 -0800
Date: Wed, 10 Jan 2024 15:55:20 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 2/4] KVM: x86: Rely solely on preempted_in_kernel flag
 for directed yield
Message-ID: <20240110075520.psahkt47hoqodqqf@yy-desk-7060>
References: <20240110003938.490206-1-seanjc@google.com>
 <20240110003938.490206-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110003938.490206-3-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Tue, Jan 09, 2024 at 04:39:36PM -0800, Sean Christopherson wrote:
> Snapshot preempted_in_kernel using kvm_arch_vcpu_in_kernel() so that the
> flag is "accurate" (or rather, consistent and deterministic within KVM)
> for guest with protected state, and explicitly use preempted_in_kernel
> when checking if a vCPU was preempted in kernel mode instead of bouncing
> through kvm_arch_vcpu_in_kernel().
>
> Drop the gnarly logic in kvm_arch_vcpu_in_kernel() that redirects to
> preempted_in_kernel if the target vCPU is not the "running", i.e. loaded,
> vCPU, as the only reason that code existed was for the directed yield case
> where KVM wants to check the CPL of a vCPU that may or may not be loaded
> on the current pCPU.
>
> Cc: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 415509918c7f..77494f9c8d49 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5062,8 +5062,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	int idx;
>
>  	if (vcpu->preempted) {
> -		if (!vcpu->arch.guest_state_protected)
> -			vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
> +		vcpu->arch.preempted_in_kernel = kvm_arch_vcpu_in_kernel(vcpu);
>
>  		/*
>  		 * Take the srcu lock as memslots will be accessed to check the gfn
> @@ -13093,7 +13092,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
>
>  bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_arch_vcpu_in_kernel(vcpu);
> +	return vcpu->arch.preempted_in_kernel;
>  }
>
>  bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
> @@ -13116,9 +13115,6 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.guest_state_protected)
>  		return true;
>
> -	if (vcpu != kvm_get_running_vcpu())
> -		return vcpu->arch.preempted_in_kernel;
> -

Now this function accepts vcpu parameter but can only get
information from "current" vcpu loaded on hardware for VMX.
I'm not sure whether need "WARN_ON(vcpu != kvm_get_running_vcpu())"
here to guard it. i.e. kvm_guest_state() still
uses this function (although it did chekcing before).

>  	return static_call(kvm_x86_get_cpl)(vcpu) == 0;
>  }
>
> --
> 2.43.0.472.g3155946c3a-goog
>
>

