Return-Path: <kvm+bounces-12159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E1D880134
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:54:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 897DE1F24238
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C5C7FBB7;
	Tue, 19 Mar 2024 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GScfsn32"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D1B657BA;
	Tue, 19 Mar 2024 15:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710863635; cv=none; b=G04vhY9UJNVW0tNSufJnmp5K49JWhyjKdYvqzHq+//ANkGeEqpeD7MG+JVqGbIvNNGdzr7O+4V9x87rErZJzTEIcghj66enNTUeN9on0ouOilKaH50d4W4s6QyL6YLBl4QO0G/zlZ3HZ0+mlykurIw2OXGC19Dzo8gCQw5exFio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710863635; c=relaxed/simple;
	bh=D66pzCkZRuPyCkuZKMTlMhx9uq+3LFhreBlF96tdz/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDj3rHRXiWwyEsTjw4mjzMKMm5j2SRbjpGXk8S1GUlw0Fs+2mBB9J4A6nI1T/9B8U6bAHu/k+Rk9IBN77eQWUYhGwyWX+Ed+s47A/4CYS0an1FK6QToEEj7X4tPbhPD9xKz48JjSvyxqspE5kIAshmAtWUgeQjs0IenuY+6MuGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GScfsn32; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710863633; x=1742399633;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D66pzCkZRuPyCkuZKMTlMhx9uq+3LFhreBlF96tdz/A=;
  b=GScfsn32RY1amNVD0t0ZO3QEAeu0tAwvzx0tcIv6ee8MJFE2rTtLjuuS
   UX2uglOYflKuodLZQUbfX9tX3X/EReYRWFvl8+ZCCKDy8EQLBlSSAKFkD
   IVHnZ8FrIjYOQQ816vSRJl4J+hN2cGcgdZ2z/4ssJTreAnmnquAz/EBh1
   2biqdWZFFHbx0pOC7tx8clXr19tdoKXy3lqzisTMdKNm/gpHcXqDv4jho
   9HeSNNSoH0S4A9HZIo2UF1V/Xe8fAhxBwh8W5AxSahuY6DHI8SuSRspzJ
   o+jna+8xohW7GfQ67UjUURcpe6X+jZTy3p/2WfLK5oGsN8KnhhBMVb7Um
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="17192077"
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="17192077"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 08:53:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="14234456"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 08:53:51 -0700
Date: Tue, 19 Mar 2024 08:53:49 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: David Matlack <dmatlack@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 5/8] KVM: x86/mmu: Introduce kvm_mmu_map_page() for
 prepopulating guest memory
Message-ID: <20240319155349.GE1645738@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <7b7dd4d56249028aa0b84d439ffdf1b79e67322a.1709288671.git.isaku.yamahata@intel.com>
 <ZekMnStRy1WwF2eb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZekMnStRy1WwF2eb@google.com>

On Wed, Mar 06, 2024 at 04:38:53PM -0800,
David Matlack <dmatlack@google.com> wrote:

> On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e4cc7f764980..7d5e80d17977 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4659,6 +4659,36 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  	return direct_page_fault(vcpu, fault);
> >  }
> >  
> > +int kvm_mmu_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> > +		     u8 max_level, u8 *goal_level)
> > +{
> > +	struct kvm_page_fault fault = KVM_PAGE_FAULT_INIT(vcpu, gpa, error_code,
> > +							  false, max_level);
> > +	int r;
> > +
> > +	r = __kvm_mmu_do_page_fault(vcpu, &fault);
> 
> If TDP is disabled __kvm_mmu_do_page_fault() will interpret @gpa as a
> GVA no? And if the vCPU is in guest-mode __kvm_mmu_do_page_fault() will
> interpret gpa as a nGPA right?

Just to close the discussion.
As we discussed at [1], I'd lie to restrict the API to TDP MMU only
(with the next version).  If vCPU is in guest-mode or legacy MMU mode, it will
get error.

[1] https://lore.kernel.org/kvm/ZekQFdPlU7RDVt-B@google.com/
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

