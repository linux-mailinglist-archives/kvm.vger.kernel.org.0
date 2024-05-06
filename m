Return-Path: <kvm+bounces-16605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 075458BC5D1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 04:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88FEA1F2226E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 02:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7530A3399B;
	Mon,  6 May 2024 02:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djWDYfPI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C9643156
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 02:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714963236; cv=none; b=eDwmOxqm2BX1r0dg4t5XUWctHQbCcwELDjkizBtx39bmeqeERADaS8BX4HKcunMUIXSGTAiBynihpKPsVrDPeRBgBXIOXbLPBYvh3Nb87MMRI/AzmoAAaVd7lleZc963WpwEOOd9CyNFdLgBm48Ypvi6/LJhHe9G9cYvh5nRBl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714963236; c=relaxed/simple;
	bh=8NCHiPb7AIUJPCLV8GfvbkSeFl/6CephUsTfkltLJuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=efcqLZT79JL6x6bBRvhB7itN8BAItMau98eGPVhhgSGWDb6KVKagLrYvLkMN6XbNWvOY+lnq1wXN8HHBfAaz6JSaUDmgvCYRyRJOXbvmX6fefjqtYw4HWiOdH34Qx+/60TolNsZxOCK7mpRwk88bgCOfUD2jdASb9KkJAWAR+CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=djWDYfPI; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714963234; x=1746499234;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8NCHiPb7AIUJPCLV8GfvbkSeFl/6CephUsTfkltLJuU=;
  b=djWDYfPIedTKz8kOoawhVlBoiYMQM8fYZB/ad4nn6wicYmHMtRI2zwqj
   IzpaTb/p92UHQdqG79unhQWEpBQQGK9p1w9FhvJh8K2+URSENeSqJBFNc
   jUQU0C0HsrH6aSjN49e8Kdly2h6Zy4N8fz2QKaJwFgi9BIr3DYDJoy63m
   jkLdIYz/Aq6KthDnZMHvZF3IYu1hr5YdGVdekXMnoCRJpCescZz6EucaV
   W4JY5JY5AfQ8uUxdkioK4MC1yrgy5tHcojcS6At9aVld/+d9W5UweKD49
   txt4f2d20eoPQnGSsD7F122f4mxPTsG8wKX4TaVjCgfsZRC0Jp8Wgrus+
   Q==;
X-CSE-ConnectionGUID: ulv0MauKSQ65RuZFKdgeMg==
X-CSE-MsgGUID: XJpzucKvSyW9bqXawRry4Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="36080382"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="36080382"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2024 19:40:33 -0700
X-CSE-ConnectionGUID: ool1PNuwS6WykBKUBLBn2g==
X-CSE-MsgGUID: Os5rVDVeQ9yhjdj2IAtbiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="32494811"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa005.fm.intel.com with ESMTP; 05 May 2024 19:40:30 -0700
Date: Mon, 6 May 2024 10:54:42 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: "Chen, Zide" <zide.chen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 1/6] target/i386/kvm: Add feature bit definitions for KVM
 CPUID
Message-ID: <ZjhGchDOqGB1taVz@intel.com>
References: <20240426100716.2111688-1-zhao1.liu@intel.com>
 <20240426100716.2111688-2-zhao1.liu@intel.com>
 <04d827f7-fb18-4c93-b223-91dd5e190421@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d827f7-fb18-4c93-b223-91dd5e190421@intel.com>

Hi Zide,

On Fri, Apr 26, 2024 at 10:23:27AM -0700, Chen, Zide wrote:
> Date: Fri, 26 Apr 2024 10:23:27 -0700
> From: "Chen, Zide" <zide.chen@intel.com>
> Subject: Re: [PATCH 1/6] target/i386/kvm: Add feature bit definitions for
>  KVM CPUID
> 
> On 4/26/2024 3:07 AM, Zhao Liu wrote:
> > Add feature definiations for KVM_CPUID_FEATURES in CPUID (
> > CPUID[4000_0001].EAX and CPUID[4000_0001].EDX), to get rid of lots of
> > offset calculations.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > ---
> > v2: Changed the prefix from CPUID_FEAT_KVM_* to CPUID_KVM_*. (Xiaoyao)
> > ---
> >  hw/i386/kvm/clock.c   |  5 ++---
> >  target/i386/cpu.h     | 23 +++++++++++++++++++++++
> >  target/i386/kvm/kvm.c | 28 ++++++++++++++--------------
> >  3 files changed, 39 insertions(+), 17 deletions(-)
> > 
> > diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
> > index 40aa9a32c32c..ce416c05a3d0 100644
> > --- a/hw/i386/kvm/clock.c
> > +++ b/hw/i386/kvm/clock.c
> > @@ -27,7 +27,6 @@
> >  #include "qapi/error.h"
> >  
> >  #include <linux/kvm.h>
> > -#include "standard-headers/asm-x86/kvm_para.h"
> >  #include "qom/object.h"
> >  
> >  #define TYPE_KVM_CLOCK "kvmclock"
> > @@ -334,8 +333,8 @@ void kvmclock_create(bool create_always)
> >  
> >      assert(kvm_enabled());
> >      if (create_always ||
> > -        cpu->env.features[FEAT_KVM] & ((1ULL << KVM_FEATURE_CLOCKSOURCE) |
> > -                                       (1ULL << KVM_FEATURE_CLOCKSOURCE2))) {
> > +        cpu->env.features[FEAT_KVM] & (CPUID_KVM_CLOCK |
> > +                                       CPUID_KVM_CLOCK2)) {
> 
> To achieve this purpose, how about doing the alternative to define an
> API similar to KVM's guest_pv_has()?
>
> xxxx_has() is simpler and clearer than "features[] & CPUID_xxxxx",
> additionally, this helps to keep the definitions identical to KVM, more
> readable and easier for future maintenance.

Yes, it's a clearer way! I can explore the xxxx_has() pattern in another
series and try to expand it to more CPUID leaves.

Thanks,
Zhao



