Return-Path: <kvm+bounces-6080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C5A782AEFA
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 13:50:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6EAF281D18
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 12:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E0816410;
	Thu, 11 Jan 2024 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FrOE4VmD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF8716400;
	Thu, 11 Jan 2024 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704977389; x=1736513389;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oIFCuUvPwoxvyeSdEWGklHOP+KJiBPUYcOtOvhrmoxA=;
  b=FrOE4VmDAVCwrWJE+p9yZbwM2jKGI8pIEwyT0gN0/351PaUIittQks0L
   ltHu+L5mAjkkV37du1Nvq5bs2HMlJfWoxxyZL42noUMkmWGKzIVJzMGgC
   CyaRaGdewPGzdovrJoYrRuY3Or54UcCmn2EGxzo0rEQSc7hoq2wTKERvE
   2z3+e6o2mm6M74AXT2KGaBzmFpiz1KeJvtYBqsCnFZ6oxiLPfLdMzu2Vf
   p26e6UJsldEd+fFpSrocoKAFD/lHYZjB4kbRdy7K8O9C1+QEav+enN1Tm
   l4pI3RFfsBCtETMvVu79weRhU4rDZjHSoXdPFE5PlAnI8xW5WVgt7YJ40
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="430017252"
X-IronPort-AV: E=Sophos;i="6.04,186,1695711600"; 
   d="scan'208";a="430017252"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 04:49:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="816705049"
X-IronPort-AV: E=Sophos;i="6.04,186,1695711600"; 
   d="scan'208";a="816705049"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga001.jf.intel.com with ESMTP; 11 Jan 2024 04:49:46 -0800
Date: Thu, 11 Jan 2024 20:49:45 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 3/4] KVM: x86: Clean up directed yield API for "has
 pending interrupt"
Message-ID: <20240111124945.pto6bmvcl5saz53n@yy-desk-7060>
References: <20240110003938.490206-1-seanjc@google.com>
 <20240110003938.490206-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110003938.490206-4-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Tue, Jan 09, 2024 at 04:39:37PM -0800, Sean Christopherson wrote:
> Directly return the boolean result of whether or not a vCPU has a pending
> interrupt instead of effectively doing:
>
>   if (true)
> 	return true;
>
>   return false;
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/kvm/x86.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 77494f9c8d49..b7996a75d9a3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13083,11 +13083,8 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>
>  bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_vcpu_apicv_active(vcpu) &&
> -	    static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
> -		return true;
> -
> -	return false;
> +	return kvm_vcpu_apicv_active(vcpu) &&
> +	       static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu);
>  }
>
>  bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
> --
> 2.43.0.472.g3155946c3a-goog
>
>

