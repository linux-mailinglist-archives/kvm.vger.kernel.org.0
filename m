Return-Path: <kvm+bounces-20602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F32991A56E
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 13:37:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48756284106
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569DC14E2FD;
	Thu, 27 Jun 2024 11:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dlUZBv6J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0268A14AD0E
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 11:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719488223; cv=none; b=WHrpiBPknLZZYWRilIEfMhGekx3CCUqV0LJ6wl+eF+Ub3z2iYGm59VretWshnQqg2DDzPF9jYmfpsrk7OlfShbkIARVYC99aFY+F6+GWcrGSN3I5suo3c8lx/7voYOzO9t2zw/uuZY9Z6s+RVrPv/OLOlu63ZkypnApPrKC/+rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719488223; c=relaxed/simple;
	bh=EsHyF8FI9Ep/AX9p5cB8YmwhhJICxdbmONHp5r/od0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktZo+1t/QYC/eW8cB4ncu9oGnGFH4Fa0hefhagyrvD2MvRsZ0m/Cr9TcW6PvFBP3iuX6wcAZQBfe6q+naxRtShmkclW4FXsk7pSrJ5Rd3h4IqvIyBtv12cI+TcGC/YQ43y6EHK9+8EO/mbdYMEYcqEMypMzNPzXn9YuzWBKB2E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dlUZBv6J; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719488222; x=1751024222;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EsHyF8FI9Ep/AX9p5cB8YmwhhJICxdbmONHp5r/od0M=;
  b=dlUZBv6JpRNkzbcBdJL3YTqLSIds6QGV30PM2+1n7MujgWi952TegJjp
   FhcpdvJRoNqX79PRFchD3uUN0wNI79eo1dNLwuH0XPu8s5qKGkTr5FLJg
   mqvM2q1KZ2e6ljWglHmq4QlzIFGRSoutcFiYxTWEldGaV3FPpOqfEC1rP
   JUJdMe7k9MUUMjMK5O1sPMSn1Uyg53pqDpS+MZm/vH1yfzyXh3PVFNoEW
   SyZH078aaa6P6ngClfVS6PflNODFukzK81A8pJ4NhROu+DHqbsMYO6iPD
   ZxCuC+TyuyhSmRsU6MKYfMgcSdQf6bCYV1GgtdSvybWgBtG0vYOl3hfrj
   g==;
X-CSE-ConnectionGUID: MvPliNyGT968KOuHCaRFPg==
X-CSE-MsgGUID: VmAoQ8GGQ+Gz3WYXxkVlgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="16746360"
X-IronPort-AV: E=Sophos;i="6.09,270,1716274800"; 
   d="scan'208";a="16746360"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 04:37:02 -0700
X-CSE-ConnectionGUID: n4BhW3wDSUSLn+FZCgQ65w==
X-CSE-MsgGUID: fjG01yxjRwiAHNMsz+O03w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,270,1716274800"; 
   d="scan'208";a="49281031"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa003.jf.intel.com with ESMTP; 27 Jun 2024 04:37:00 -0700
Date: Thu, 27 Jun 2024 19:52:35 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/6] target/i386: Misc cleanup on KVM PV defs and
 outdated comments
Message-ID: <Zn1SgwRCnbbwyWzb@intel.com>
References: <20240506085153.2834841-1-zhao1.liu@intel.com>
 <ZmGAi4j+IxZgNShC@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmGAi4j+IxZgNShC@intel.com>

Hi Paolo,

A gentle poke for this series.

Thanks,
Zhao

On Thu, Jun 06, 2024 at 05:25:31PM +0800, Zhao Liu wrote:
> Date: Thu, 6 Jun 2024 17:25:31 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: Re: [PATCH v2 0/6] target/i386: Misc cleanup on KVM PV defs and
>  outdated comments
> 
> Hi Paolo,
> 
> Just a ping for this cleanup series.
> 
> Thanks,
> Zhao
> 
> On Mon, May 06, 2024 at 04:51:47PM +0800, Zhao Liu wrote:
> > Date: Mon, 6 May 2024 16:51:47 +0800
> > From: Zhao Liu <zhao1.liu@intel.com>
> > Subject: [PATCH v2 0/6] target/i386: Misc cleanup on KVM PV defs and
> >  outdated comments
> > X-Mailer: git-send-email 2.34.1
> > 
> > Hi,
> > 
> > This is my v2 cleanup series. Compared with v1 [1], only tags (R/b, S/b)
> > updates, and a typo fix, no code change.
> > 
> > This series picks cleanup from my previous kvmclock [2] (as other
> > renaming attempts were temporarily put on hold).
> > 
> > In addition, this series also include the cleanup on a historically
> > workaround and recent comment of coco interface [3].
> > 
> > Avoiding the fragmentation of these misc cleanups, I consolidated them
> > all in one series and was able to tackle them in one go!
> > 
> > [1]: https://lore.kernel.org/qemu-devel/20240426100716.2111688-1-zhao1.liu@intel.com/
> > [2]: https://lore.kernel.org/qemu-devel/20240329101954.3954987-1-zhao1.liu@linux.intel.com/
> > [3]: https://lore.kernel.org/qemu-devel/2815f0f1-9e20-4985-849c-d74c6cdc94ae@intel.com/
> > 
> > Thanks and Best Regards,
> > Zhao
> > ---
> > Zhao Liu (6):
> >   target/i386/kvm: Add feature bit definitions for KVM CPUID
> >   target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
> >     MSR_KVM_SYSTEM_TIME definitions
> >   target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
> >   target/i386/kvm: Save/load MSRs of kvmclock2
> >     (KVM_FEATURE_CLOCKSOURCE2)
> >   target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
> >   target/i386/confidential-guest: Fix comment of
> >     x86_confidential_guest_kvm_type()
> > 
> >  hw/i386/kvm/clock.c              |  5 +--
> >  target/i386/confidential-guest.h |  2 +-
> >  target/i386/cpu.h                | 25 +++++++++++++
> >  target/i386/kvm/kvm.c            | 63 +++++++++++++++++++-------------
> >  4 files changed, 66 insertions(+), 29 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 
> 

