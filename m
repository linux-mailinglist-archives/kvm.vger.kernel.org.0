Return-Path: <kvm+bounces-25336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A650996405B
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 11:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FC311F261F5
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 09:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D04818E359;
	Thu, 29 Aug 2024 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V0k1Ed0p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C08418E053;
	Thu, 29 Aug 2024 09:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724924249; cv=none; b=EwPhNAXX04cX2lc4JXeB5K5WsWmEKxxHN71CM9e/7dD7LmN/wqdAxXto+BVxQd7UgWZaDoZ3SvpMZqY0jv7EHYsMbTrK8uVUqtSpSY0awzoxj9Vh0sPH1g0vmf4+M97pMMSHJWnti1FZoqQBNJMUevYLf1cTX9AAVfs41x1Nw58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724924249; c=relaxed/simple;
	bh=AsQiOUdqeFNaOGTs/WOSOkZKmODY99yIldxyKcZ3eP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhv+ZT3+21VCb11jLa+Cp1S09uKA2eX6gFDTvg5RzYviJMHi36eIOGJbvuc0YmedZmJhfaNELYIIAAzANva822WQbVwpvqOP5Y7cZwHnM2gO7c9bFqN7N23XJrdvO6LYBBVB10uZBK/v4975UJvECZb4PyrWJ9+L34xaLVkXCAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V0k1Ed0p; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724924248; x=1756460248;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AsQiOUdqeFNaOGTs/WOSOkZKmODY99yIldxyKcZ3eP0=;
  b=V0k1Ed0p0KORm8YAKC0XRtqNSJIYuGZrws9omNF9KysP02l0cRzkhwrn
   HWVWJtt9gdZskHmY5G3/Jk3EZSwtaBnoBOH2UklQ6T1d1Wbiy1QPKXiez
   Klwnw4f28KljQlLZDy/Olv2loWU3yYfBCjLPNLiucXRawDUvDUxadZaKS
   6U9FRXrckYY3lzaUwDomvOPx9cPZyQbPn3+DHAyPsJcFR455CKkIWUdnK
   Kfgv+VZSK+hR2iTielyxo0uqLXF8DXpXu0PS6R1lUo06zpLwwtEQXre9l
   zporukM29EO/MLxTR+e9TdTT6SXVdDiFoutkhpBLx7DHRkzVoCOdlAfSp
   Q==;
X-CSE-ConnectionGUID: 3yZuAta4SMKGeBQbx9v8ZQ==
X-CSE-MsgGUID: IUtGT53vTAebkk91XGYfcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="34659697"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="34659697"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 02:37:28 -0700
X-CSE-ConnectionGUID: +v6HzWNLTYGlHe9yRXv/xg==
X-CSE-MsgGUID: nuiL9r1NRTaSeHbvhO9P7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="63859002"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa006.jf.intel.com with ESMTP; 29 Aug 2024 02:37:23 -0700
Date: Thu, 29 Aug 2024 17:34:52 +0800
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
Message-ID: <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826123024.GF3773488@nvidia.com>

On Mon, Aug 26, 2024 at 09:30:24AM -0300, Jason Gunthorpe wrote:
> On Mon, Aug 26, 2024 at 08:39:25AM +0000, Tian, Kevin wrote:
> > > IOMMUFD calls get_user_pages() for every mapping which will allocate
> > > shared memory instead of using private memory managed by the KVM and
> > > MEMFD.
> > > 
> > > Add support for IOMMUFD fd to the VFIO KVM device's KVM_DEV_VFIO_FILE
> > > API
> > > similar to already existing VFIO device and VFIO group fds.
> > > This addition registers the KVM in IOMMUFD with a callback to get a pfn
> > > for guest private memory for mapping it later in the IOMMU.
> > > No callback for free as it is generic folio_put() for now.
> > > 
> > > The aforementioned callback uses uptr to calculate the offset into
> > > the KVM memory slot and find private backing pfn, copies
> > > kvm_gmem_get_pfn() pretty much.
> > > 
> > > This relies on private pages to be pinned beforehand.
> > > 
> > 
> > There was a related discussion [1] which leans toward the conclusion
> > that the IOMMU page table for private memory will be managed by
> > the secure world i.e. the KVM path.
> 
> It is still effectively true, AMD's design has duplication, the RMP
> table has the mappings to validate GPA and that is all managed in the
> secure world.
> 
> They just want another copy of that information in the unsecure world
> in the form of page tables :\
> 
> > btw going down this path it's clearer to extend the MAP_DMA
> > uAPI to accept {gmemfd, offset} than adding a callback to KVM.
> 
> Yes, we want a DMA MAP from memfd sort of API in general. So it should
> go directly to guest memfd with no kvm entanglement.

A uAPI like ioctl(MAP_DMA, gmemfd, offset, iova) still means userspace
takes control of the IOMMU mapping in the unsecure world. But as
mentioned, the unsecure world mapping is just a "copy" and has no
generic meaning without the CoCo-VM context. Seems no need for userspace
to repeat the "copy" for IOMMU.

Maybe userspace could just find a way to link the KVM context to IOMMU
at the first place, then let KVM & IOMMU directly negotiate the mapping
at runtime.

Thanks,
Yilun

> 
> Jason
> 

