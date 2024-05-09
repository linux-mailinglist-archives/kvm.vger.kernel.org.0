Return-Path: <kvm+bounces-17091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 582D28C0AE2
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 07:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74462284861
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 05:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE330149C43;
	Thu,  9 May 2024 05:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LuWVfu8x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C2414900A
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 05:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715231741; cv=none; b=g95fPT+WCryT5IVwDfoHrdnDn9uzGTqR9J6nm4tNA4lqS6Rx201hb6/vbfvktrKqZyaKWELEwpVLAnqHmJr8j6zQoIU0ySxRv+ybw9HCAGFzM91CCzDTeywBEzXqcHQ1zSZDCCO5KqLDkAMpf7qVXzGEozEnjfX84Zxo9DO9OOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715231741; c=relaxed/simple;
	bh=fxPS6z9qo1E2GIGVmeE8HJAGutIsWY89eekH1ZDADiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttRCYZeZZPE1Zk55WWk0nsb3I2Xfjv7Pbk/8GfINTsJ5me3CiVhvtMwnsaaggYMQ6GWu1Z4tZd/G/F4spTgCP/V4t8SvxkBzjGkLa6+aniZN/v3mvpCbOhTHpzF7mIKYlSe6nPLkRBb6G+mifyJCXXODZ0eaFYEC2BA/OyQILz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LuWVfu8x; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715231740; x=1746767740;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fxPS6z9qo1E2GIGVmeE8HJAGutIsWY89eekH1ZDADiY=;
  b=LuWVfu8xP6pR0qh8hbZMi4fLIAc/uL2MF+DdmcRU4jT/hATpVpQIaz/x
   mSmW5ShZmN4U1xVv7koANfhuT3qHIb+j9RXLlV31iXXjfgveSvs84xCkW
   yTyLFbsmSNQIoPp3kVdqEjd8fwWCOA/igWfQPIy4v+0XEiFveETFOF5pH
   i9KmORFYAQ3lvbbJapq1FzLHQTrjKeLU1nJmpX3SDMcRpuiKGk8xe4U1q
   0G0EWGtpWuglXcJuGtvlRYQKxA/IaBGfcBu3pdVr+8mvr7L0spsEZgT/x
   ptzJdwD7kpi/oaHVfYAnJ/9EbET+rtmUs/aK66rFd5Gz9g/PhmR8Nuwwz
   g==;
X-CSE-ConnectionGUID: kq5qITjtSF25UXiBaX7EAw==
X-CSE-MsgGUID: +cmE8iyiTQKm13SYZyVrBQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="28643448"
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="28643448"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 22:15:39 -0700
X-CSE-ConnectionGUID: 0wfjmbebRNWZc+45ecD5OQ==
X-CSE-MsgGUID: 5vEfcwCDTEa03eGB250JpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="33599217"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 22:15:37 -0700
Date: Thu, 9 May 2024 13:12:57 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
	xiaoyao.li@intel.com
Subject: Re: [PATCH] KVM: selftests: x86: Prioritize getting max_gfn from
 GuestPhysBits
Message-ID: <ZjxbWc+qw/LRL/KY@linux.bj.intel.com>
References: <20240508064205.15301-1-tao1.su@linux.intel.com>
 <ZjuHrGROhuBylm4x@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjuHrGROhuBylm4x@google.com>

On Wed, May 08, 2024 at 07:09:48AM -0700, Sean Christopherson wrote:
> On Wed, May 08, 2024, Tao Su wrote:
> > Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
> > max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
> > dirty_log_test...) add RAM regions close to max_gfn, so guest may access
> > GPA beyond its mappable range and cause infinite loop.
> > 
> > Prioritize obtaining pa_bits from the GuestPhysBits field advertised by
> > KVM, so max_gfn can be limited to the mappable range.
> > 
> > Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> > ---
> > This patch is based on https://github.com/kvm-x86/linux/commit/b628cb523c65
> > ---
> >  tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
> >  tools/testing/selftests/kvm/lib/x86_64/processor.c     | 4 +++-
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > index 81ce37ec407d..ff99f66d81a0 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > @@ -282,6 +282,7 @@ struct kvm_x86_cpu_property {
> >  #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
> >  #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
> >  #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
> > +#define X86_PROPERTY_MAX_GUEST_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
> >  #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
> >  #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
> >  
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index 74a4c736c9ae..6c69f1dfeed2 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -1074,7 +1074,9 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
> >  		*pa_bits = kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;
> >  		*va_bits = 32;
> >  	} else {
> > -		*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
> > +		*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);
> > +		if (*pa_bits == 0)
> > +			*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
> 
> This is the wrong place to incorporaate the max mappable GPA.  The pa_bits field
> should reflect the "real" MAXPHYADDR, it's vm->max_gfn that needs to be adjusted,
> and x86 selftests already overrides vm_compute_max_gfn() specifically to deal with
> goofy edge cases like this.

Thanks for pointing out! I will adjust max_gfn in the vm_compute_max_gfn() overrided
by x86 selftests.

> 
> >  		*va_bits = kvm_cpu_property(X86_PROPERTY_MAX_VIRT_ADDR);
> >  	}
> >  }
> > 
> > base-commit: dccb07f2914cdab2ac3a5b6c98406f765acab803
> > -- 
> > 2.34.1
> > 

