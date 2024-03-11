Return-Path: <kvm+bounces-11596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E39E878AA2
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 23:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52055B21204
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 22:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF0A57871;
	Mon, 11 Mar 2024 22:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BcvM42BC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D30757304;
	Mon, 11 Mar 2024 22:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710195574; cv=none; b=pTUaVMc1H2RXsUUHQ9OV3iFo4je8QpysQJBqhxCnMVCe/THffEmVb3KJLO+hH8qDCWbLXBt617Qh0Lu/rW3rnAV7Y++p0tme5C6v95Rp/qe3ir+SkYTY0auXWhW72VHP6imsVQgAeZ3olnNa2dH9IwQEpzGkBH9d0AUI/fgKEz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710195574; c=relaxed/simple;
	bh=0v++ROQPobMGQbI/Vm4BZhMEsVhvWe+m26wqCk9eS1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAHa6PORQl2POYHF7XRSZQjo5VaKs9ro3xcQ17BPyU8MuoOwpPtp59ZyTSOkYrL+SjU/RqA9WeZ8QqorgfyFnFuBaG0j34ktBm+pCPuqMVtbzvusksujJ+5P0alYzSxm9cOgVaaDy1/tjXUDmOMOti9+VfLFwgn3R/YIAkxPfng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BcvM42BC; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710195573; x=1741731573;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0v++ROQPobMGQbI/Vm4BZhMEsVhvWe+m26wqCk9eS1s=;
  b=BcvM42BCwbSlNMFcIoCkHHkemUb1Axa2DHJ6qe6Zwj3+VH21rdC+USkc
   FAhXbkKl/HJ09JmoNOdZSSnQjzo15bHHQKHIZ/4foqdCHwD9CEH3lB5oS
   oyiJcxsNO8YOtZcjWtnzLbNDHp0weMKC1Fi6+lWtdx6vlT8TqSrnO/MbH
   FB3uzQTb2gJEE4pGilPLBQKjnhFcMiaMBvC1KMbJB2VtMP5xuceWH7ciO
   vlaPzHkqXG1rPuh8aZrvmIUnMpmQS8dNGKcV5LGHvZpQatqipbIugrZXX
   8ABJVT0Bt0Ib9ZiewhcIpUcQCz7cFtuKnLtnu+dI54tkhHN2yoKWZ11g0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="16326416"
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="16326416"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 15:19:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="11902821"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 15:19:31 -0700
Date: Mon, 11 Mar 2024 15:19:31 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 2/8] KVM: Add KVM_MAP_MEMORY vcpu ioctl to
 pre-populate guest memory
Message-ID: <20240311221931.GA935089@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>
 <Ze8-EFtsIONMyO3o@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ze8-EFtsIONMyO3o@google.com>

On Mon, Mar 11, 2024 at 10:23:28AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Mar 01, 2024, isaku.yamahata@intel.com wrote:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d1fd9cb5d037..d77c9b79d76b 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4419,6 +4419,69 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
> >  	return fd;
> >  }
> >  
> > +__weak int kvm_arch_vcpu_pre_map_memory(struct kvm_vcpu *vcpu)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +__weak int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
> > +				    struct kvm_memory_mapping *mapping)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +static int kvm_vcpu_map_memory(struct kvm_vcpu *vcpu,
> > +			       struct kvm_memory_mapping *mapping)
> > +{
> > +	bool added = false;
> > +	int idx, r = 0;
> 
> Pointless initialization of 'r'.
> 
> > +
> > +	if (mapping->flags & ~(KVM_MEMORY_MAPPING_FLAG_WRITE |
> > +			       KVM_MEMORY_MAPPING_FLAG_EXEC |
> > +			       KVM_MEMORY_MAPPING_FLAG_USER |
> > +			       KVM_MEMORY_MAPPING_FLAG_PRIVATE))
> > +		return -EINVAL;
> > +	if ((mapping->flags & KVM_MEMORY_MAPPING_FLAG_PRIVATE) &&
> > +	    !kvm_arch_has_private_mem(vcpu->kvm))
> > +		return -EINVAL;
> > +
> > +	/* Sanity check */
> 
> Pointless comment.
> 
> > +	if (!IS_ALIGNED(mapping->source, PAGE_SIZE) ||
> > +	    !mapping->nr_pages ||
> 
> > +	    mapping->base_gfn + mapping->nr_pages <= mapping->base_gfn)
> > +		return -EINVAL;
> > +
> > +	vcpu_load(vcpu);
> > +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> > +	r = kvm_arch_vcpu_pre_map_memory(vcpu);
> 
> This hooks is unnecessary, x86's kvm_mmu_reload() is optimized for the happy path
> where the MMU is already loaded.  Just make the call from kvm_arch_vcpu_map_memory().
> 
> > +	if (r)
> > +		return r;
> 
> Which is a good thing, because this leaks the SRCU lock.
> 
> > +
> > +	while (mapping->nr_pages) {
> > +		if (signal_pending(current)) {
> > +			r = -ERESTARTSYS;
> 
> Why -ERESTARTSYS instead of -EINTR?  The latter is KVM's typical response to a
> pending signal.
> 
> > +			break;
> > +		}
> > +
> > +		if (need_resched())
> 
> No need to manually check need_resched(), the below is a _conditional_ resched.
> The reason KVM explicitly checks need_resched() in MMU flows is because KVM needs
> to drop mmu_lock before rescheduling, i.e. calling cond_resched() directly would
> try to schedule() while holding a spinlock.
> 
> > +			cond_resched();
> > +
> > +		r = kvm_arch_vcpu_map_memory(vcpu, mapping);
> > +		if (r)
> > +			break;
> > +
> > +		added = true;
> > +	}
> > +
> > +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +	vcpu_put(vcpu);
> > +
> > +	if (added && mapping->nr_pages > 0)
> > +		r = -EAGAIN;
> 
> No, this clobbers 'r', which might hold a fatal error code.  I don't see any
> reason for common code to ever force -EAGAIN, it can't possibly know if trying
> again is reasonable.

Thanks for review.  With those included, the hunk is as follows.

	
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d1fd9cb5d037..342269ef9f13 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4419,6 +4419,47 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
        return fd;
 }
 
+__weak int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
+                                   struct kvm_memory_mapping *mapping)
+{
+       return -EOPNOTSUPP;
+}
+
+static int kvm_vcpu_map_memory(struct kvm_vcpu *vcpu,
+                              struct kvm_memory_mapping *mapping)
+{
+       int idx, r;
+
+       if (mapping->flags)
+               return -EINVAL;
+
+       if (!IS_ALIGNED(mapping->source, PAGE_SIZE) ||
+           mapping->base_gfn + mapping->nr_pages <= mapping->base_gfn)
+               return -EINVAL;
+
+       vcpu_load(vcpu);
+       idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+       r = 0;
+       while (mapping->nr_pages) {
+               if (signal_pending(current)) {
+                       r = -EINTR;
+                       break;
+               }
+
+               r = kvm_arch_vcpu_map_memory(vcpu, mapping);
+               if (r)
+                       break;
+
+               cond_resched();
+       }
+
+       srcu_read_unlock(&vcpu->kvm->srcu, idx);
+       vcpu_put(vcpu);
+
+       return r;
+}
+
 static long kvm_vcpu_ioctl(struct file *filp,
                           unsigned int ioctl, unsigned long arg)
 {
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

