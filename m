Return-Path: <kvm+bounces-11282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E53ED874A66
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 10:10:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A29042887EA
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB06582D9D;
	Thu,  7 Mar 2024 09:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XOEeidBf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E6382D7F;
	Thu,  7 Mar 2024 09:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709802607; cv=none; b=WzOuLFaL41fgdwTkJXudqP/iFZG6VMb571/wVHOJMspoILBmG8uifPQTYnYXrCVCK+YLKmJPggweowJmOMcw7SaLx0XF1ZNguTfHfNmvFeP4OQwtE868Qca4251sTLP7adp4Dd6x9H+mB6WLiZ5VXOfRXec4Dw75YcHTUEfkfS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709802607; c=relaxed/simple;
	bh=joJfI32naIHizqZEIiVjdVjShxZm0AfkYNv34+xBk28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWDB+83M7AHvTGoNFwvh5U//mijI5cCMoS/5Xp/90it0DeeNVGnMGYQODm+8YhnzCSupmBMg1vfJqQF/ja5v5IM8X0boWl+7l65vyCfaqn+HIrpCzygZO0c0bExVbmnR7EDjvXdfdK1J+fjfmSpo8wlCAOH1P+bJecCbwr5T5+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XOEeidBf; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709802606; x=1741338606;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=joJfI32naIHizqZEIiVjdVjShxZm0AfkYNv34+xBk28=;
  b=XOEeidBf83zqMYNwvpxuQtHXVUauxXdWagG8+5LcX117dT8vfFFlSgqN
   fgx9tT9/pLUOXdGwbUvsOBIqWprPsg1hJa163x/fRoU+NpWPhJ0xXxesb
   /sOl3w06/wiyeEuuxRc2Yz/O+MeYcdLPauTuiRFsWEDGAZcDB+XYrXTg5
   SKIvebiUPEjNMSN+FXPZJMRymPUygBbBChOEi2Y6+QhzpJ3V4vg1G6VFD
   RT0eF+okuSn21+WT4NlIGGI62HvF6Ql6dhATJRgjIEWi1cH3uwH9EHBYq
   jWgyeCJ5uo0F2O6kWRBYxD1IL5d4O8DHDJs0DY6azXwX7snmnPT3CT6Jv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4636016"
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="4636016"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 01:10:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="10602967"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 07 Mar 2024 01:10:01 -0800
Date: Thu, 7 Mar 2024 17:05:45 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 05/16] KVM: x86/mmu: Use synthetic page fault error code
 to indicate private faults
Message-ID: <ZemDaWzRCzV4Q5ni@yilunxu-OptiPlex-7050>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-6-seanjc@google.com>
 <Zeg6tKA0zNQ+dUpn@yilunxu-OptiPlex-7050>
 <ZeiBLjzDsEN0UsaW@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeiBLjzDsEN0UsaW@google.com>

On Wed, Mar 06, 2024 at 06:45:30AM -0800, Sean Christopherson wrote:
> On Wed, Mar 06, 2024, Xu Yilun wrote:
> > On Tue, Feb 27, 2024 at 06:41:36PM -0800, Sean Christopherson wrote:
> > > Add and use a synthetic, KVM-defined page fault error code to indicate
> > > whether a fault is to private vs. shared memory.  TDX and SNP have
> > > different mechanisms for reporting private vs. shared, and KVM's
> > > software-protected VMs have no mechanism at all.  Usurp an error code
> > > flag to avoid having to plumb another parameter to kvm_mmu_page_fault()
> > > and friends.
> > > 
> > > Alternatively, KVM could borrow AMD's PFERR_GUEST_ENC_MASK, i.e. set it
> > > for TDX and software-protected VMs as appropriate, but that would require
> > > *clearing* the flag for SEV and SEV-ES VMs, which support encrypted
> > > memory at the hardware layer, but don't utilize private memory at the
> > > KVM layer.
> > 
> > I see this alternative in other patchset.  And I still don't understand why
> > synthetic way is better after reading patch #5-7.  I assume for SEV(-ES) if
> > there is spurious PFERR_GUEST_ENC flag set in error code when private memory
> > is not used in KVM, then it is a HW issue or SW bug that needs to be caught
> > and warned, and by the way cleared.
> 
> The conundrum is that SEV(-ES) support _encrypted_ memory, but cannot support
> what KVM calls "private" memory.  In quotes because SEV(-ES) memory encryption
> does provide confidentially/privacy, but in KVM they don't support memslots that

I see.  I searched the basic knowledge of SEV(-ES/SNP) and finally understand
the difference of encrypted vs. private.  For SEV(-ES) only encrypted.  For SEV-SNP
both encrypted & private(ownership) supported, but seems now we are trying
to make encrypted & private equal, there is no "encrypted but shared" or
"plain but private" memory from KVM's perspective.

> can be switched between private and shared, e.g. will return false for
> kvm_arch_has_private_mem().
> 
> And KVM _can't_ sanely use private/shared memslots for SEV(-ES), because it's
> impossible to intercept implicit conversions by the guest, i.e. KVM can't prevent
> the guest from encrypting a page that KVM thinks is private, and vice versa.

Is it because there is no #NPF for RMP violation?

> 
> But from hardware's perspective, while the APM is a bit misleading and I don't
> love the behavior, I can't really argue that it's a hardware bug if the CPU sets
> PFERR_GUEST_ENC on a fault where the guest access had C-bit=1, because the access
> _was_ indeed to encrypted memory.
> 
> Which is a long-winded way of saying the unwanted PFERR_GUEST_ENC faults aren't
> really spurious, nor are they hardware or software bugs, just another unfortunate
> side effect of the fact that the hypervisor can't intercept shared<->encrypted
> conversions for SEV(-ES) guests.  And that means that KVM can't WARN, because
> literally every SNP-capable CPU would yell when running SEV(-ES) guests.
> 
> I also don't like the idea of usurping PFERR_GUEST_ENC to have it mean something
> different in KVM as compared to how hardware defines/uses the flag.

Thanks for your clue.  I agree PFERR_GUEST_ENC just for encrypted and a
synthetic flag for private.

Yilun

> 
> Lastly, the approach in Paolo's series to propagate PFERR_GUEST_ENC to .is_private
> iff the VM has private memory is brittle, in that it would be too easy for KVM
> code that has access to the error code to do the wrong thing and interpret
> PFERR_GUEST_ENC has meaning "private".

