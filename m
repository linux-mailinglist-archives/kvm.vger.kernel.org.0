Return-Path: <kvm+bounces-11331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0968758B5
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 21:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE4F31C2264C
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 20:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12A713A244;
	Thu,  7 Mar 2024 20:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i6bbRt0C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D70A139589;
	Thu,  7 Mar 2024 20:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709844113; cv=none; b=Jj979mhOCNn9VdYLko019lDgTHl0zx8Hu4V7I+V4OI95cEFhCXBd8A1Mt9PfRUuVgXAwkGFK2eU7dY6HNQDkp6amDVHywtOTAr5u/ui54hats/PVnz5ST3vjh8BbQpm3Rcoet/fctoADo9F44ehGxtZfUrCI/keJLWS32ghKi3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709844113; c=relaxed/simple;
	bh=iabhuQF72B+oEKUE+qeOJGbEh25CxZgZkTnc9Ai+Iqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dvklcdXrMM9KoLHGta0tX+zogfgCODWUl254JzxuECncrdU8IrdrqiJcldkS+S455l6pvXVvMsaUokDAZrGi7FcX97xvem/+b5x5ytnI/JPs1tiW7APVcMrSuRfzHWqhZ5N2wLUpIReIMWh3NnslwFvUEhmEclVpBMcKXem2jbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i6bbRt0C; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709844112; x=1741380112;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iabhuQF72B+oEKUE+qeOJGbEh25CxZgZkTnc9Ai+Iqk=;
  b=i6bbRt0CTRxfu5YMRwJekcK4q7iimbAOEh6e0MXJw79Imbq6Evl+7DQ6
   gGr0BDYEJ73ubphp51pL87CaJqsuRfwEb+6rXOwHJUTSr02s8DRDn8NNx
   dt415+oL6LUSEq48J/RUw136Its7ct+n2gKEId3kAMXf7Wi5INXSzbCOq
   JnDP3P+Z/RJBIVuwu0hmJ2Q7dZYY77SYIq1bMQmnNWgFqpKLXkX+2VeFA
   tS8/LAVifEUJPtov7ueLflW6MzFErMlCyPcTsENgwlq6anGJ2/6/ZmD/j
   Fj19Rbk7m1WSyYIWxwjqxZzL1bqdrzZPsxAw0COALIirpmE1yc0PnkIoo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4680568"
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="4680568"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 12:41:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="10363198"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 12:41:49 -0800
Date: Thu, 7 Mar 2024 12:41:49 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 2/8] KVM: Add KVM_MAP_MEMORY vcpu ioctl to
 pre-populate guest memory
Message-ID: <20240307204149.GJ368614@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>
 <85ad9d17fc50ff0784f5bcaefccdade53d2c18a9.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <85ad9d17fc50ff0784f5bcaefccdade53d2c18a9.camel@intel.com>

On Thu, Mar 07, 2024 at 12:45:16PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> >  
> > +int kvm_arch_vcpu_pre_map_memory(struct kvm_vcpu *vcpu);
> 
> No explanation of why this is needed, and why it only takes @vcpu as input w/o
> having the @mapping.
>  
> > +int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
> > +			     struct kvm_memory_mapping *mapping);
> > +
> > 
> 
> [...]
> 
> > +static int kvm_vcpu_map_memory(struct kvm_vcpu *vcpu,
> > +			       struct kvm_memory_mapping *mapping)
> > +{
> > +	bool added = false;
> > +	int idx, r = 0;
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
> > +	if (!IS_ALIGNED(mapping->source, PAGE_SIZE) ||
> > +	    !mapping->nr_pages ||
> > +	    mapping->base_gfn + mapping->nr_pages <= mapping->base_gfn)
> > +		return -EINVAL;
> > +
> > +	vcpu_load(vcpu);
> > +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> > +	r = kvm_arch_vcpu_pre_map_memory(vcpu);
> > +	if (r)
> > +		return r;
> 
> Returning w/o unloading the vcpu and releasing the SRCU.

Oos, Will fix.


> > +
> > +	while (mapping->nr_pages) {
> > +		if (signal_pending(current)) {
> > +			r = -ERESTARTSYS;
> > +			break;
> > +		}
> > +
> > +		if (need_resched())
> > +			cond_resched();
> 
> need_resched() is not needed.
> 
> And normally I think we just put it at the end of the loop.

Ok, will move it.


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
> Why do we need @added?
> 
> I assume the kvm_arch_vcpu_map_memory() can internally update the mapping-
> >nr_pages but still return -E<WHATEVER>.  So when that happens in the first call
> of kvm_arch_vcpu_map_memory(), @added won't get chance to turn to true.

I intend to tell the caller if the range is partially processed or not.
Anyway this seems moot. Let's drop this if clause.  Then it's caller's
responsibility to check error and partial conversion and to optionally loop
with the remaining region.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

