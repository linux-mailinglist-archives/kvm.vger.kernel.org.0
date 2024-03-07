Return-Path: <kvm+bounces-11244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 902938745AB
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 02:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B989286C49
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059235227;
	Thu,  7 Mar 2024 01:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YkjcK10B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E93C4689;
	Thu,  7 Mar 2024 01:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709775295; cv=none; b=lrtoUB5zfg2S8EO8R3h2xU23s2Jiq+ffxAYVTSF02Gf5/MZrcXkEIu0r635EXwOBPehYSJpQxeRzmKEyIKJg9JZxl06MeLesPhPXe1Fa4wPhlkvzwrUcwZJZtMIjco57xxEe2CA7A3fLGgIkuhIs7qQbyecGhqn/UsIw8XeaaXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709775295; c=relaxed/simple;
	bh=FxSafHmZOK92FTSBXrwz0pUq3BM0aeLdXeQdbuUUjS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cHDlFG8X4jEU92aKRKF4u+Zp6QaeGbRgjlVZf1vR5hcuR4WYwcbq8Dr5/cmUW+w38P8hgKBWP/MBcCAfUUIgoz6bvlzVk5vF9SIQvJUhOlnriTfuahmJ+uY0jLfdCkeA8GplBiNwY2flpCPLlY80Hn9v3xuzDCCDTivDwTeLWXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YkjcK10B; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709775294; x=1741311294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FxSafHmZOK92FTSBXrwz0pUq3BM0aeLdXeQdbuUUjS8=;
  b=YkjcK10BrElQnTzXnXMFfLxoL+lUkKioYDPjlRla+2vI9zMJtAJ3djoC
   uz4B+TuoUWK09DqisTnHiUPRce6tub6z0U1lX6NPo8b3MkqbNgz3bamFS
   HufMzS6q9azIbhbYAiST17MwbKjfKhZRFTERO7mOOiVHmx8pXay9PWw6r
   +LM8UiJisdhk7r0I9kqmejKGhGq5MKq6kSUuLuas2z2oMsonqb7VI3qZC
   XpMWEAvznNeFvFEFefgoVvCUw2dehmjjx77Y5XOnEH2V+hMEpUNscGKev
   tCZ3pN6qTeMebiAwKra8Pq5AIf2tIJXrW8/T8f536tscZw1NgpG5WSZRy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4549168"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4549168"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 17:34:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9929621"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 17:34:51 -0800
Date: Wed, 6 Mar 2024 17:34:50 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: David Matlack <dmatlack@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Message-ID: <20240307013450.GE368614@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
 <ZekKwlLdf6vm5e5u@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZekKwlLdf6vm5e5u@google.com>

On Wed, Mar 06, 2024 at 04:30:58PM -0800,
David Matlack <dmatlack@google.com> wrote:

> On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Wire KVM_MAP_MEMORY ioctl to kvm_mmu_map_tdp_page() to populate guest
> > memory.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 3b8cb69b04fa..6025c0e12d89 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4660,6 +4660,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> >  	case KVM_CAP_IRQFD_RESAMPLE:
> >  	case KVM_CAP_MEMORY_FAULT_INFO:
> > +	case KVM_CAP_MAP_MEMORY:
> >  		r = 1;
> >  		break;
> >  	case KVM_CAP_EXIT_HYPERCALL:
> > @@ -5805,6 +5806,54 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
> >  	}
> >  }
> >  
> > +int kvm_arch_vcpu_pre_map_memory(struct kvm_vcpu *vcpu)
> > +{
> > +	return kvm_mmu_reload(vcpu);
> > +}
> 
> Why is the here and not kvm_arch_vcpu_map_memory()?

We can push down kvm_mmu_relaod into kvm_arch_vcpu_map_memory() under gpa loop.
Probably the inefficiency won't matter.

kvm_mmu_realod()
loop on gpa
  kvm_arch_vcpu_map_memory()

=>

loop on gpa
    kvm_arch_vcpu_map_memory()
      kvm_mmu_reload()
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

