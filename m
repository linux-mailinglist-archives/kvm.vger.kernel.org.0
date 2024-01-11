Return-Path: <kvm+bounces-6079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C18D82AEF8
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 13:49:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7142B22F81
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 12:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34DE15E9B;
	Thu, 11 Jan 2024 12:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lf++cxwl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B381715E86;
	Thu, 11 Jan 2024 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704977328; x=1736513328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ukyTAga3PhxT8gHfHH+ePSWsZGHVupmWdDMB7taiAKk=;
  b=Lf++cxwlgcWKm3JYE8TA+HxLRZh3rwKC1Msb0G64iPH7+bW3NY1CLbTY
   aTQL81MD03WTkt/F4BmEGi7NKBpumc1fWCqN5+53hULifeI001JJCcAMp
   oFgcwzcWi8rXzmwEJEgB9NPq9JIBhZsFh8+eYjAqIkG/+bJuErVSvJNyv
   J39etODMZfZi4jxkjGX/dzO6qZc3TFcq/Acbc3J8jAfTPduXyEKe1sjQW
   JFTDjrUmWZuO6aVZMOCI9LmUAdoEzYzuuRYWOQc+760OcRupl37E+QrgD
   8YjZjRXZB4/insXvExJDEHBbYXEpHY64wg3VhkumECQqH4C3QVpXMPrZp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="430016996"
X-IronPort-AV: E=Sophos;i="6.04,186,1695711600"; 
   d="scan'208";a="430016996"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 04:48:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="816704670"
X-IronPort-AV: E=Sophos;i="6.04,186,1695711600"; 
   d="scan'208";a="816704670"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga001.jf.intel.com with ESMTP; 11 Jan 2024 04:48:36 -0800
Date: Thu, 11 Jan 2024 20:48:35 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 1/4] KVM: Add dedicated arch hook for querying if vCPU
 was preempted in-kernel
Message-ID: <20240111124835.vrabew5nqf5qyqhr@yy-desk-7060>
References: <20240110003938.490206-1-seanjc@google.com>
 <20240110003938.490206-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110003938.490206-2-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Tue, Jan 09, 2024 at 04:39:35PM -0800, Sean Christopherson wrote:
> Plumb in a dedicated hook for querying whether or not a vCPU was preempted
> in-kernel.  Unlike literally every other architecture, x86's VMX can check
> if a vCPU is in kernel context if and only if the vCPU is loaded on the
> current pCPU.
>
> x86's kvm_arch_vcpu_in_kernel() works around the limitation by querying
> kvm_get_running_vcpu() and redirecting to vcpu->arch.preempted_in_kernel
> as needed.  But that's unnecessary, confusing, and fragile, e.g. x86 has
> had at least one bug where KVM incorrectly used a stale
> preempted_in_kernel.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/kvm/x86.c       |  5 +++++
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 15 +++++++++++++--
>  3 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 27e23714e960..415509918c7f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13091,6 +13091,11 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
>  	return false;
>  }
>
> +bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_arch_vcpu_in_kernel(vcpu);
> +}
> +
>  bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
>  {
>  	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..28b020404a41 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1505,6 +1505,7 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
>  bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
> +bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu);
>  int kvm_arch_post_init_vm(struct kvm *kvm);
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>  int kvm_arch_create_vm_debugfs(struct kvm *kvm);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 10bfc88a69f7..6326852bfb3d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4042,11 +4042,22 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
>  	return false;
>  }
>
> +/*
> + * By default, simply query the target vCPU's current mode when checking if a
> + * vCPU was preempted in kernel mode.  All architectures except x86 (or more
> + * specifical, except VMX) allow querying whether or not a vCPU is in kernel
> + * mode even if the vCPU is NOT loaded, i.e. using kvm_arch_vcpu_in_kernel()
> + * directly for cross-vCPU checks is functionally correct and accurate.
> + */
> +bool __weak kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_arch_vcpu_in_kernel(vcpu);
> +}
> +
>  bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	return false;
>  }
> -
>  void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  {
>  	struct kvm *kvm = me->kvm;
> @@ -4080,7 +4091,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  				continue;
>  			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
>  			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
> -			    !kvm_arch_vcpu_in_kernel(vcpu))
> +			    !kvm_arch_vcpu_preempted_in_kernel(vcpu))
>  				continue;
>  			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
>  				continue;
> --
> 2.43.0.472.g3155946c3a-goog
>
>

