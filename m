Return-Path: <kvm+bounces-11395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D372876C2F
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:02:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12D0E283057
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 21:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6F35FB9A;
	Fri,  8 Mar 2024 21:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ce5BxOhb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B035E090;
	Fri,  8 Mar 2024 21:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709931680; cv=none; b=V3dsQKeaAAsPNtFtGQmdpxGRCSH71EpxtHEwcuegARsZqUruU6N9ATcjh8ZAxnEcIZ8oD7Y1n/pcUASXQCiiN6K7WdIuOetq3aimep52tfMAi+OobdpSh996nTgwIhzU58KRyKqTt9v2OQ/9Hq6vJ9FdABin3B1zcEEgUZNWnlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709931680; c=relaxed/simple;
	bh=DDl8vWySAK96jU7FvSbeJPzo1lFEUUlodXhYmz+FK+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhIyiAxce9PN1nSerMPVcZC8lZChbuPyKjVT+5tuYqoKkXZTl492RlsJFg7N7ecOqe3kQk2hymmKrS6tPoqnbBEz5NwgBEreUp8GDKZLppw+wFiQTgN0naUbrHAn3EYrYVi6Vg3h3UuXVFTP8SXcd2ZZFkaHU07K5G5JmbqVluo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ce5BxOhb; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709931678; x=1741467678;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DDl8vWySAK96jU7FvSbeJPzo1lFEUUlodXhYmz+FK+o=;
  b=ce5BxOhb7mJEsC10tFHwQb6Xc74RRP8Mu+V3LLyE8CHEUiJsh8Deo8Mn
   PrEki+08cVqFtIxh736+biYeSCwREScuj5UvOGDG70JRLkznHGHrV/7nM
   TaVoGFB7A5Z52xv+sWltN1b0Drv3GBxhoBjqtYxNY45ziL0hj1pEoL8y2
   RxUCyAbtj+aH7y0YEvFONDsrYB/lQUSU9e5j3TjPmBJjsmzXU+f0H4EaP
   GNqyPUcCUGLTKDSjZy/QzVelGPr3AqxLPIeBrQ5Z7nGd7a7kAvauo1pgC
   JwcexCbEEFoBfWP65c9KvDNN+YOds26sbFW8fn0YmJJmi40iEJCxhim0p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11007"; a="8485088"
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="8485088"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 13:01:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="15067143"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 13:01:17 -0800
Date: Fri, 8 Mar 2024 13:01:16 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Yin Fengwei <fengwei.yin@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 014/130] KVM: Add KVM vcpu ioctl to pre-populate
 guest memory
Message-ID: <20240308210116.GB713729@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8b7380f1b02f8e3995f18bebb085e43165d5d682.1708933498.git.isaku.yamahata@intel.com>
 <6b453972-2723-47c5-981e-56c150f217d7@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6b453972-2723-47c5-981e-56c150f217d7@intel.com>

On Thu, Mar 07, 2024 at 03:01:11PM +0800,
Yin Fengwei <fengwei.yin@intel.com> wrote:

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 0349e1f241d1..2f0a8e28795e 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4409,6 +4409,62 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
> >  	return fd;
> >  }
> >  
> > +__weak void kvm_arch_vcpu_pre_memory_mapping(struct kvm_vcpu *vcpu)
> > +{
> > +}
> > +
> > +__weak int kvm_arch_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
> > +					struct kvm_memory_mapping *mapping)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +static int kvm_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
> > +				   struct kvm_memory_mapping *mapping)
> > +{
> > +	bool added = false;
> > +	int idx, r = 0;
> > +
> > +	/* flags isn't used yet. */
> > +	if (mapping->flags)
> > +		return -EINVAL;
> > +
> > +	/* Sanity check */
> > +	if (!IS_ALIGNED(mapping->source, PAGE_SIZE) ||
> > +	    !mapping->nr_pages ||
> > +	    mapping->nr_pages & GENMASK_ULL(63, 63 - PAGE_SHIFT) ||
> > +	    mapping->base_gfn + mapping->nr_pages <= mapping->base_gfn)
> I suppose !mapping->nr_pages can be deleted as this line can cover it.
> > +		return -EINVAL;
> > +
> > +	vcpu_load(vcpu);
> > +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> > +	kvm_arch_vcpu_pre_memory_mapping(vcpu);
> > +
> > +	while (mapping->nr_pages) {
> > +		if (signal_pending(current)) {
> > +			r = -ERESTARTSYS;
> > +			break;
> > +		}
> > +
> > +		if (need_resched())
> > +			cond_resched();
> > +
> > +		r = kvm_arch_vcpu_memory_mapping(vcpu, mapping);
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
> > +
> > +	return r;
> > +}
> > +
> >  static long kvm_vcpu_ioctl(struct file *filp,
> >  			   unsigned int ioctl, unsigned long arg)
> >  {
> > @@ -4610,6 +4666,17 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >  		r = kvm_vcpu_ioctl_get_stats_fd(vcpu);
> >  		break;
> >  	}
> > +	case KVM_MEMORY_MAPPING: {
> > +		struct kvm_memory_mapping mapping;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&mapping, argp, sizeof(mapping)))
> > +			break;
> > +		r = kvm_vcpu_memory_mapping(vcpu, &mapping);
> return value r should be checked before copy_to_user

That's intentional to tell the mapping is partially or fully processed
regardless that error happened or not.

> 
> 
> Regards
> Yin, Fengwei
> 
> > +		if (copy_to_user(argp, &mapping, sizeof(mapping)))
> > +			r = -EFAULT;
> > +		break;
> > +	}
> >  	default:
> >  		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
> >  	}
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

