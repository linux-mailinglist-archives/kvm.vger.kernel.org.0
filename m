Return-Path: <kvm+bounces-25454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6A79656D9
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2473B22FB9
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 05:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B684B13C672;
	Fri, 30 Aug 2024 05:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VvWy/AIh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FF914EC48;
	Fri, 30 Aug 2024 05:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724995366; cv=none; b=n0gUi28nkyDRriVxayKdnQzumIFuzVTsJVLaT9PwLc9ecJsPbfsL7qhsWiyCF8RNwFexL5su2h9SJ7KxSvFSxgwtIL/uOisN5yKw+l4IYSzKKgW+e8dic4cYCeyoWBEy2KIS/dUhMSs8wlnLssxfoipglpFf4nEMkKwN0VfUyhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724995366; c=relaxed/simple;
	bh=l5MtcJ16/20NZRgzbOdI4tgn55AzLQjMnx6XNybvpRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddMfIcng9nRwaZ84kjO22xVBimn9nHg8DDsqXYyw3uJAZdCtf2Mg3ygCZRi9/F/U7CI1ZrhJOgzYk1xwXdfP1iGJYIWjDl60PnM6U4VJmFQw5I53HPPuSV/q2exUtGajhGhnipRnVMGPT57xrCT9OhvGEUQeNzuSrlCaak1/a6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VvWy/AIh; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724995365; x=1756531365;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l5MtcJ16/20NZRgzbOdI4tgn55AzLQjMnx6XNybvpRQ=;
  b=VvWy/AIhXiwqW1DIA0qBSmGpR/KDzNCJZazpsnRTbIwmbMJ6A56Noy7O
   tACfc2Ix9z8JKVxKLv/JSfJd5leq5cAMTQxl2kQSAbYbgphzcsV9MMaes
   mOw4tWd6nq+DLkqFwHLcdjdjpULANuNtAESVZIU9ZReFG8JQ7/rL/oWen
   MEBsb/IBycrOeCQaTlXggtlOOgp4LUYYw2SlAhVfIyZokpAPnIHt358Dj
   P6WPvIItorreogXM/PygfahehNnB9d2vcDwsH43fxozyEPogR6Nu8pSNV
   ZwH0A43eCc9TQVnTNQyw/2oePQrndnLGt7hrQUwOUjnTZQ6fof68aOWEh
   Q==;
X-CSE-ConnectionGUID: vGBWevh/SfOVMHMO9845sg==
X-CSE-MsgGUID: 85hEoWQrRQOaoj1jO4ay9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="27384639"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="27384639"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 22:22:45 -0700
X-CSE-ConnectionGUID: AnweIVdsTPuWUjAol7yh+w==
X-CSE-MsgGUID: uX0TDv7jS9mKqVrFzAMgYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="67956141"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 29 Aug 2024 22:22:39 -0700
Date: Fri, 30 Aug 2024 13:20:12 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
	"david@redhat.com" <david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829121549.GF3773488@nvidia.com>

On Thu, Aug 29, 2024 at 09:15:49AM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 29, 2024 at 05:34:52PM +0800, Xu Yilun wrote:
> > On Mon, Aug 26, 2024 at 09:30:24AM -0300, Jason Gunthorpe wrote:
> > > On Mon, Aug 26, 2024 at 08:39:25AM +0000, Tian, Kevin wrote:
> > > > > IOMMUFD calls get_user_pages() for every mapping which will allocate
> > > > > shared memory instead of using private memory managed by the KVM and
> > > > > MEMFD.
> > > > > 
> > > > > Add support for IOMMUFD fd to the VFIO KVM device's KVM_DEV_VFIO_FILE
> > > > > API
> > > > > similar to already existing VFIO device and VFIO group fds.
> > > > > This addition registers the KVM in IOMMUFD with a callback to get a pfn
> > > > > for guest private memory for mapping it later in the IOMMU.
> > > > > No callback for free as it is generic folio_put() for now.
> > > > > 
> > > > > The aforementioned callback uses uptr to calculate the offset into
> > > > > the KVM memory slot and find private backing pfn, copies
> > > > > kvm_gmem_get_pfn() pretty much.
> > > > > 
> > > > > This relies on private pages to be pinned beforehand.
> > > > > 
> > > > 
> > > > There was a related discussion [1] which leans toward the conclusion
> > > > that the IOMMU page table for private memory will be managed by
> > > > the secure world i.e. the KVM path.
> > > 
> > > It is still effectively true, AMD's design has duplication, the RMP
> > > table has the mappings to validate GPA and that is all managed in the
> > > secure world.
> > > 
> > > They just want another copy of that information in the unsecure world
> > > in the form of page tables :\
> > > 
> > > > btw going down this path it's clearer to extend the MAP_DMA
> > > > uAPI to accept {gmemfd, offset} than adding a callback to KVM.
> > > 
> > > Yes, we want a DMA MAP from memfd sort of API in general. So it should
> > > go directly to guest memfd with no kvm entanglement.
> > 
> > A uAPI like ioctl(MAP_DMA, gmemfd, offset, iova) still means userspace
> > takes control of the IOMMU mapping in the unsecure world. 
> 
> Yes, such is how it seems to work.
> 
> It doesn't actually have much control, it has to build a mapping that
> matches the RMP table exactly but still has to build it..
> 
> > But as mentioned, the unsecure world mapping is just a "copy" and
> > has no generic meaning without the CoCo-VM context. Seems no need
> > for userspace to repeat the "copy" for IOMMU.
> 
> Well, here I say copy from the information already in the PSP secure
> world in the form fo their RMP, but in a different format.
> 
> There is another copy in KVM in it's stage 2 translation but..
> 
> > Maybe userspace could just find a way to link the KVM context to IOMMU
> > at the first place, then let KVM & IOMMU directly negotiate the mapping
> > at runtime.
> 
> I think the KVM folks have said no to sharing the KVM stage 2 directly
> with the iommu. They do too many operations that are incompatible with
> the iommu requirements for the stage 2.

I kind of agree.

I'm not considering the page table sharing for AMD's case. I was just
thinking about the way we sync up the secure mapping for KVM & IOMMU,
when Page attribute conversion happens, still via userspace or KVM
directly notifies IOMMU.

> 
> If that is true for the confidential compute, I don't know.

For Intel TDX TEE-IO, there may be a different story.

Architechturely the secure IOMMU page table has to share with KVM secure
stage 2 (SEPT). The SEPT is managed by firmware (TDX Module), TDX Module
ensures the SEPT operations good for secure IOMMU, so there is no much
trick to play for SEPT.

> 
> Still, continuing to duplicate the two mappings as we have always done
> seems like a reasonable place to start and we want a memfd map anyhow
> for other reasons:
> 
> https://lore.kernel.org/linux-iommu/20240806125602.GJ478300@nvidia.com/
> 
> Jason

