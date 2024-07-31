Return-Path: <kvm+bounces-22730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7767794279C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFE011F25429
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590551A6178;
	Wed, 31 Jul 2024 07:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d8YBjrMP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864661A4F3B
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 07:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722410085; cv=none; b=YK/K07Q4Qi2hM4OGCffmkNuBvV2kASLycwFYbMxX/rvc6M0oIgpJd0GwI0Pv7dHoYoVT3ZFOczvXuj9UAe0TT62BHKL8tAT1ZQu4HivnIS4JY89fabOgTP1UsiD3N3o/2YhcwS3hxbJZGTjXYhUTEHp1Ft5IAqWGV3Uaro5H45o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722410085; c=relaxed/simple;
	bh=ssbII7MpEx5cZOyBZ8ZwGo8GeGJli2aCyYIPdwP4ZJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEmO3238Qa8Re6C1RbeWMPSqatXfZOoWhVbgBqP2JRHQUXbgcI5mObCDFayX6RqlyoIcS3S4WXlmXobKNGhVzXIK5J7Wa36N4T1va+i7Av99wo9Gfd9XYUcuM1nEQjD+DP15MfOQ+1fjksX1jjG2tdaXarz2NPfaPLZI83KwqMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d8YBjrMP; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722410083; x=1753946083;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ssbII7MpEx5cZOyBZ8ZwGo8GeGJli2aCyYIPdwP4ZJA=;
  b=d8YBjrMPWIHd/871Dngbwx7irtW+Z9SMJdgP/2sAgBQKHamUjEiutrlC
   foLFSKkaLUmtmyB7XqSUZBKM0eScLf5IwY/UMbV7JDO4TI+V3h04LH5Bk
   dL4C2iesE2cUbKUW+Sq5e/BP5nafcPdYHmogBJTfP/a55vo2vsnfeFUNn
   qF6dblOKCjrsGNroT95lTstvFoYu9eYYxubaUEDQp52InI5ndDWi96pC5
   XkQW07s52J2Lc1JBXgiXCtUOPtSnnZJBTmqLWheIwjp1AyH1iaTrzf+IR
   D6o/ShUTXAstryJ5TQujvttJtDmi1Tj/po98fIpWIcNCiVvHHrwzBDCet
   Q==;
X-CSE-ConnectionGUID: SjcXgj6lRLKgOztE3OGizw==
X-CSE-MsgGUID: ruTGgyVbSwanpTp41GAYaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11149"; a="45687464"
X-IronPort-AV: E=Sophos;i="6.09,250,1716274800"; 
   d="scan'208";a="45687464"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2024 00:14:42 -0700
X-CSE-ConnectionGUID: 7xnhCxgnTAeY/NKjeetbXw==
X-CSE-MsgGUID: trA+W0KpRZqggGOAshqrDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,250,1716274800"; 
   d="scan'208";a="55396439"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2024 00:14:38 -0700
Date: Wed, 31 Jul 2024 15:12:44 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: David Hildenbrand <david@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"Qiang, Chenyi" <chenyi.qiang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>,
	"Gao, Chao" <chao.gao@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
	"Xu, Yilun" <yilun.xu@intel.com>
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
Message-ID: <Zqnj7PZKX6Rzh/yl@yilunxu-OptiPlex-7050>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
 <BN9PR11MB527635939C0A2A0763E326A58CB42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c9556944-16e4-4eb0-b9cd-56426099f813@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9556944-16e4-4eb0-b9cd-56426099f813@redhat.com>

On Fri, Jul 26, 2024 at 09:08:51AM +0200, David Hildenbrand wrote:
> On 26.07.24 07:02, Tian, Kevin wrote:
> > > From: David Hildenbrand <david@redhat.com>
> > > Sent: Thursday, July 25, 2024 10:04 PM
> > > 
> > > > Open
> > > > ====
> > > > Implementing a RamDiscardManager to notify VFIO of page conversions
> > > > causes changes in semantics: private memory is treated as discarded (or
> > > > hot-removed) memory. This isn't aligned with the expectation of current
> > > > RamDiscardManager users (e.g. VFIO or live migration) who really
> > > > expect that discarded memory is hot-removed and thus can be skipped
> > > when
> > > > the users are processing guest memory. Treating private memory as
> > > > discarded won't work in future if VFIO or live migration needs to handle
> > > > private memory. e.g. VFIO may need to map private memory to support
> > > > Trusted IO and live migration for confidential VMs need to migrate
> > > > private memory.
> > > 
> > > "VFIO may need to map private memory to support Trusted IO"
> > > 
> > > I've been told that the way we handle shared memory won't be the way
> > > this is going to work with guest_memfd. KVM will coordinate directly
> > > with VFIO or $whatever and update the IOMMU tables itself right in the
> > > kernel; the pages are pinned/owned by guest_memfd, so that will just
> > > work. So I don't consider that currently a concern. guest_memfd private
> > > memory is not mapped into user page tables and as it currently seems it
> > > never will be.
> > 
> > Or could extend MAP_DMA to accept guest_memfd+offset in place of

With TIO, I can imagine several buffer sharing requirements: KVM maps VFIO
owned private MMIO, IOMMU maps gmem owned private memory, IOMMU maps VFIO
owned private MMIO. These buffers cannot be found by user page table
anymore. I'm wondering it would be messy to have specific PFN finding
methods for each FD type. Is it possible we have a unified way for
buffer sharing and PFN finding, is dma-buf a candidate?

> > 'vaddr' and have VFIO/IOMMUFD call guest_memfd helpers to retrieve
> > the pinned pfn.
> 
> In theory yes, and I've been thinking of the same for a while. Until people
> told me that it is unlikely that it will work that way in the future.

Could you help specify why it won't work? As Kevin mentioned below, SEV-TIO
may still allow userspace to manage the IOMMU mapping for private. I'm
not sure how they map private memory for IOMMU without touching gmemfd.

Thanks,
Yilun

> 
> > 
> > IMHO it's more the TIO arch deciding whether VFIO/IOMMUFD needs
> > to manage the mapping of the private memory instead of the use of
> > guest_memfd.
> > 
> > e.g. SEV-TIO, iiuc, introduces a new-layer page ownership tracker (RMP)
> > to check the HPA after the IOMMU walks the existing I/O page tables.
> > So reasonably VFIO/IOMMUFD could continue to manage those I/O
> > page tables including both private and shared memory, with a hint to
> > know where to find the pfn (host page table or guest_memfd).
> > 
> > But TDX Connect introduces a new I/O page table format (same as secure
> > EPT) for mapping the private memory and further requires sharing the
> > secure-EPT between CPU/IOMMU for private. Then it appears to be
> > a different story.
> 
> Yes. This seems to be the future and more in-line with in-place/in-kernel
> conversion as e.g., pKVM wants to have it. If you want to avoid user space
> altogether when doing shared<->private conversions, then letting user space
> manage the IOMMUs is not going to work.
> 
> 
> If we ever have to go down that path (MAP_DMA of guest_memfd), we could have
> two RAMDiscardManager for a RAM region, just like we have two memory
> backends: one for shared memory populate/discard (what this series tries to
> achieve), one for private memory populate/discard.
> 
> The thing is, that private memory will always have to be special-cased all
> over the place either way, unfortunately.
> 
> -- 
> Cheers,
> 
> David / dhildenb
> 
> 

