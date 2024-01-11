Return-Path: <kvm+bounces-6078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 554A782AEF5
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 13:48:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CB9D1C21813
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 12:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6797A15E9D;
	Thu, 11 Jan 2024 12:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dBlwR6I2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1AF15E85;
	Thu, 11 Jan 2024 12:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704977275; x=1736513275;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cYs9Y/tzmUUmAlPWCC8CezHNT235rZZV4IJuzj8AYyE=;
  b=dBlwR6I2eGokefQ3FnJKpQePHadNesdC7BiJr8kCBh5MG+qOoAtwWmkZ
   G14GSsOGHX7oQz8aTs3ZfEMRVF9tBkF6bY8QAj+T/iEiSm/iPZwLgkvH5
   WhWUX0p7wJnP0CENQquKv7x+At6f5oBvy9V+Qvl6VwMYH4/nGjZD/vWK4
   8sUILGa0b8wteSQhgclMeOBJioAPLvHy0fg5h6zv4MBh51PBy6fIwEuKj
   pPIgBwlLh+CbMesXauGxux9mgfBN/XLpT0caR+YYZ8HV20l8Wxyae9j08
   s2jb5z7/g1ate+Lzsm/RR+2xrPWagvygfWZ2/zFvaVxuA+xDS9zlFYLJN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="12190679"
X-IronPort-AV: E=Sophos;i="6.04,186,1695711600"; 
   d="scan'208";a="12190679"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 04:47:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="873011676"
X-IronPort-AV: E=Sophos;i="6.04,186,1695711600"; 
   d="scan'208";a="873011676"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jan 2024 04:47:27 -0800
Date: Thu, 11 Jan 2024 20:47:27 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 2/4] KVM: x86: Rely solely on preempted_in_kernel flag
 for directed yield
Message-ID: <20240111124727.wsnmjrh6jdtdbeuo@yy-desk-7060>
References: <20240110003938.490206-1-seanjc@google.com>
 <20240110003938.490206-3-seanjc@google.com>
 <20240110075520.psahkt47hoqodqqf@yy-desk-7060>
 <ZZ7QOMxBwHZW8oij@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZ7QOMxBwHZW8oij@google.com>
User-Agent: NeoMutt/20171215

On Wed, Jan 10, 2024 at 09:13:28AM -0800, Sean Christopherson wrote:
> On Wed, Jan 10, 2024, Yuan Yao wrote:
> > On Tue, Jan 09, 2024 at 04:39:36PM -0800, Sean Christopherson wrote:
> > > @@ -13093,7 +13092,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
> > >
> > >  bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
> > >  {
> > > -	return kvm_arch_vcpu_in_kernel(vcpu);
> > > +	return vcpu->arch.preempted_in_kernel;
> > >  }
> > >
> > >  bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
> > > @@ -13116,9 +13115,6 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> > >  	if (vcpu->arch.guest_state_protected)
> > >  		return true;
> > >
> > > -	if (vcpu != kvm_get_running_vcpu())
> > > -		return vcpu->arch.preempted_in_kernel;
> > > -
> >
> > Now this function accepts vcpu parameter but can only get information from
> > "current" vcpu loaded on hardware for VMX.  I'm not sure whether need
> > "WARN_ON(vcpu != kvm_get_running_vcpu())" here to guard it. i.e.
> > kvm_guest_state() still uses this function (although it did chekcing before).
>
> Eh, I don't think it's worth adding a one-off kvm_get_running_vcpu() sanity check.
> In the vast majority of cases, if VMREAD or VMWRITE is used improperly, the
> instruction will fail at some point due to the pCPU not having any VMCS loaded.
> It's really just cross-vCPU checks that could silently do the wrong thing, and
> those flows are so few and far between that I'm comfortable taking a "just get
> it right stance".
>
> If we want to add sanity checks, I think my vote would be to plumb @vcpu down
> into vmcs_read{16,32,64,l} and add sanity checks there, probably with some sort
> of guard so that the sanity checks can be enabled only for debug kernels.

I got your point.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

