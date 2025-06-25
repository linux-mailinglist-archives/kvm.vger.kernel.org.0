Return-Path: <kvm+bounces-50606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA39AE74E7
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 04:42:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 290113B8CF5
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 02:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F61D1C6FFD;
	Wed, 25 Jun 2025 02:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dQ4lVvKy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751CB10785
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 02:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750819349; cv=none; b=AkyT/Fp9qGTDFxRHlZsJ4An0AG/4SKtppIKkO+pz6VI6LJl3F7kxnMjQh7dGWD+elDqp1hnvowCRkHAjYadAaFAlyJ8LNRFtebet35OeMo/fsABKE9Tr7QYJjeO+T+Jc0nraNVImO7zKjUmgS3WobFq0RvhdQuCD2qHPieKIOAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750819349; c=relaxed/simple;
	bh=KpkIB6SbSpRpq76IrcFaYvHLz5vMQrkSgIXbWYpmNtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ERc0VaW+UQY3TjP3LZaqGQFje73p3ep8Xeaz6ogLX67QExM+HPlXY+EQubFraapN2UlH+KBmZngkM5xdHmRL0748fdmm5QArVnrqGSj3xN/puz88V0KbCoMIOSJglTDT5iE+1dimqxRZcBFisrlmAva2GrBswr8jhG5++tgAfKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dQ4lVvKy; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750819347; x=1782355347;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KpkIB6SbSpRpq76IrcFaYvHLz5vMQrkSgIXbWYpmNtM=;
  b=dQ4lVvKy9VcE41rP/0JK4MlyUVgTKYC70BTGH5heu+d6a0FavWS+2S/a
   WDQjq4t3pSCTPUziWiVbCWXC0zTRLn4eYFcbeAoZSyTxhIdkZANatzgq/
   JsyHsn79qauU1UeWPa0c9lSmvkEVJ2f9miRJH6UFhE+4Rvu///8bKLdiM
   qh40uzy0+/xmPP0wqz3sGXrwJ+8olFNHUiExY69i0LX8KFgOb9UXVpOUe
   qXbHWhdLPmo1uBGsRxq6MlScVGZwQArr2C5VX966Hxg16Be6mlk6nVEbC
   T2b/UjFrHnbiLHKpEYqoGTs436kAcxq36xxQ7qZ5i0wZSO62ZByWY/qUj
   g==;
X-CSE-ConnectionGUID: 5Q36EIjvS6qrGXDWsoDu6g==
X-CSE-MsgGUID: Xjb7+M08SESIXjhAWK16xQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="63676791"
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="63676791"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 19:42:27 -0700
X-CSE-ConnectionGUID: FI60P3ItRaimIunP19C3MQ==
X-CSE-MsgGUID: 6XSaQaMySeaWeGTmRoaW+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="152577366"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 24 Jun 2025 19:42:22 -0700
Date: Wed, 25 Jun 2025 11:03:44 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Babu Moger <babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, cobechen@zhaoxin.com, Frankzhu@zhaoxin.com,
	Runaguo@zhaoxin.com, yeeli@zhaoxin.com, Xanderchen@zhaoxin.com,
	MaryFeng@zhaoxin.com
Subject: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
Message-ID: <aFtnEOlRthXGbC05@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-2-zhao1.liu@intel.com>
 <fa16f7a8-4917-4731-9d9f-7d4c10977168@zhaoxin.com>
 <aDWCxhsCMavTTzkE@intel.com>
 <3318af5c-8a46-4901-91f2-0b2707e0a573@zhaoxin.com>
 <aFpSN+zEgJl72V46@intel.com>
 <8bab0159-54d3-4f48-aadf-23491171018d@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bab0159-54d3-4f48-aadf-23491171018d@zhaoxin.com>

On Tue, Jun 24, 2025 at 07:04:02PM +0800, Ewan Hai wrote:
> Date: Tue, 24 Jun 2025 19:04:02 +0800
> From: Ewan Hai <ewanhai-oc@zhaoxin.com>
> Subject: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
>  Intel
> 
> 
> 
> On 6/24/25 3:22 PM, Zhao Liu wrote:
> > 
> > On Tue, May 27, 2025 at 05:56:07PM +0800, Ewan Hai wrote:
> > > Date: Tue, 27 May 2025 17:56:07 +0800
> > > From: Ewan Hai <ewanhai-oc@zhaoxin.com>
> > > Subject: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
> > >   Intel
> > > 
> > > 
> > > 
> > > On 5/27/25 5:15 PM, Zhao Liu wrote:
> > > > 
> > > > > On 4/23/25 7:46 PM, Zhao Liu wrote:
> > > > > > 
> > > > > > Per SDM, 0x80000005 leaf is reserved for Intel CPU, and its current
> > > > > > "assert" check blocks adding new cache model for non-AMD CPUs.
> > > > > > 
> > > > > > Therefore, check the vendor and encode this leaf as all-0 for Intel
> > > > > > CPU. And since Zhaoxin mostly follows Intel behavior, apply the vendor
> > > > > > check for Zhaoxin as well.
> > > > > > 
> > > > > > Note, for !vendor_cpuid_only case, non-AMD CPU would get the wrong
> > > > > > information, i.e., get AMD's cache model for Intel or Zhaoxin CPUs.
> > > > > > For this case, there is no need to tweak for non-AMD CPUs, because
> > > > > > vendor_cpuid_only has been turned on by default since PC machine v6.1.
> > > > > > 
> > > > > > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > > > > > ---
> > > > > >     target/i386/cpu.c | 16 ++++++++++++++--
> > > > > >     1 file changed, 14 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > > > > > index 1b64ceaaba46..8fdafa8aedaf 100644
> > > [snip]>>> +
> > > > > >             *eax = (L1_DTLB_2M_ASSOC << 24) | (L1_DTLB_2M_ENTRIES << 16) |
> > > > > >                    (L1_ITLB_2M_ASSOC <<  8) | (L1_ITLB_2M_ENTRIES);
> > > > > >             *ebx = (L1_DTLB_4K_ASSOC << 24) | (L1_DTLB_4K_ENTRIES << 16) |
> > > > > 
> > > > > I've reviewed the cache-related CPUID path and noticed an oddity: every AMD
> > > > > vCPU model still reports identical hard-coded values for the L1 ITLB and L1
> > > > > DTLB fields in leaf 0x8000_0005. Your patch fixes this for Intel(and
> > > > > Zhaoxin), but all AMD models continue to receive the same constants in
> > > > > EAX/EBX.
> > > > 
> > > > Yes, TLB info is hardcoded here. Previously, Babu and Eduardo cleaned up
> > > > the cache info but didn't cover TLB [*]. I guess one reason would there
> > > > are very few use cases related to TLB's info, and people are more
> > > > concerned about the cache itself.
> > > > 
> > > > [*]: https://lore.kernel.org/qemu-devel/20180510204148.11687-2-babu.moger@amd.com/
> > > 
> > > Understood. Keeping the L1 I/D-TLB fields hard-coded for every vCPU model is
> > > acceptable.
> > > 
> > > > > Do you know the reason for this choice? Is the guest expected to ignore
> > > > > those L1 TLB numbers? If so, I'll prepare a patch that adjusts only the
> > > > > Zhaoxin defaults in leaf 0x8000_0005 like below, matching real YongFeng
> > > > > behaviour in ecx and edx, but keep eax and ebx following AMD's behaviour.
> > > > 
> > > > This way is fine for me.
> > > > 
> > > 
> > > Thanks for confirming. I'll post the YongFeng cache-info series once your
> > > refactor lands.
> > 
> > Hi Ewan,
> > 
> > By this patch:
> > 
> > https://lore.kernel.org/qemu-devel/20250620092734.1576677-14-zhao1.liu@intel.com/
> > 
> > I fixed the 0x80000005 leaf for Intel and Zhaoxin based on your feedback
> > by the way.
> > 
> > It looks like the unified cache_info would be very compatible with
> > various vendor needs and corner cases. So I'll respin this series based
> > on that cache_info series.
> > 
> > Before sending the patch, I was thinking that maybe I could help you
> > rebase and include your Yongfeng cache model patch you added into my v2
> > series, or you could rebase and send it yourself afterward. Which way do
> > you like?
> 
> It would be great if you could include the Yongfeng cache-model patch in
> your v2 series. Let me know if you need any more information about the
> Yongfeng cache model. After you submit v2, I can review the Zhaoxin parts
> and make any necessary code changes if needed.
> 
> And thanks again for taking Zhaoxin into account.

Welcome; it's something I can easily help with. If possible, when v2 is
out, hope you could help test it on your platform to ensure everything
is fine. :-) And I've verified it myself through TCG.

Thanks,
Zhao


