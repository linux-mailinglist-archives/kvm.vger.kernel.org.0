Return-Path: <kvm+bounces-46411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8381AB612F
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 05:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0335E1B446F9
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 03:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD001DE894;
	Wed, 14 May 2025 03:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iDAjfITm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E728A2260C;
	Wed, 14 May 2025 03:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747193169; cv=none; b=Wrk1QZ7UkyK95CZ6OVGpS8ud2pVv+oMTSi/H9vPXtsdxEOqfaDQAo9pOsVvGQdOtgSxmynZYHQ4VW5polkTBca7Rjeffgo0dqpalY7A/YNpFxsThhl7BPAnu68fQik/29XUOybOjyYr+a3ra7qo6tl6F5vcnd0NU/EkJ1OOjjnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747193169; c=relaxed/simple;
	bh=Vl2JsS0XoEFiPBo2fr8NpOs+oJP1wxKRrrfjW+0W2cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HgPAwgEf+5nllTVBdIma9ehGbt2ii4jksQK4z33u9DF8CyYaRn79X+kJDmtU9eIqxq/6Ylw/8SFI/vZg9e6L6IzBd3xQFbCja/YHseeigSiuCVLSq+hF2oEAn0Y9nUBuEE1mcEWwRhUy1J6/48RoJBHJaXGkSc5L57Gqfjhk9zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iDAjfITm; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747193168; x=1778729168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vl2JsS0XoEFiPBo2fr8NpOs+oJP1wxKRrrfjW+0W2cw=;
  b=iDAjfITmbHsjerNVQjnIEb/F+0E0U0P8kvZkCez91M8aRa0evoQq3UNB
   Q6pwqaob9QZVoaUfYBRpEJcCuxA6m+tnQS05wTrUaBwOQ92RN7OeaYnUW
   TA3Drmnjesf6qZV9Rutm+H5gF43XF4TNV6qTl5wJloRxGwEqW8FGkMaPX
   hlFhXGOBP9ocWbshZTHxDV4FHbygZEdRg6b9Rb5oGYThopzIP84Gb3+ot
   nllM9/P9dD0xa8HU63RIfhdoKppvmwrIRe58iBIDjm9aRYy92n47t/RIM
   mliqlLx596A1nNaSHsTGurjVzHSoanhCZdO3P8Fje4h7SHa1vEHKYmgqI
   A==;
X-CSE-ConnectionGUID: 8qYWF0CgQ7G5w5LYKjGj2w==
X-CSE-MsgGUID: zrIJFVyCTcm/1jkAwhfExQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="60471341"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="60471341"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 20:26:07 -0700
X-CSE-ConnectionGUID: fvdv4vi/TEOML9s+DB98Cg==
X-CSE-MsgGUID: IVD+dxO3Q+uiMjPNb8pcYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="137948936"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa007.fm.intel.com with ESMTP; 13 May 2025 20:26:01 -0700
Date: Wed, 14 May 2025 11:20:27 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	christian.koenig@amd.com, pbonzini@redhat.com, seanjc@google.com,
	alex.williamson@redhat.com, vivek.kasireddy@intel.com,
	dan.j.williams@intel.com, yilun.xu@intel.com,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	lukas@wunner.de, yan.y.zhao@intel.com, daniel.vetter@ffwll.ch,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 00/12] Private MMIO support for private assigned dev
Message-ID: <aCQL+/HDYcxfWM4F@yilunxu-OptiPlex-7050>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
 <371ab632-d167-4720-8f0d-57be1e3fee84@amd.com>
 <4b6dc759-86fd-47a7-a206-66b25a0ccc6d@amd.com>
 <c10bf9c2-e073-479d-ad1c-6796c592d333@amd.com>
 <aB3jLmlUKKziwdeG@yilunxu-OptiPlex-7050>
 <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>

On Mon, May 12, 2025 at 07:30:21PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 10/5/25 13:47, Xu Yilun wrote:
> > On Fri, May 09, 2025 at 03:43:18PM -0300, Jason Gunthorpe wrote:
> > > On Sat, May 10, 2025 at 12:28:48AM +0800, Xu Yilun wrote:
> > > > On Fri, May 09, 2025 at 07:12:46PM +0800, Xu Yilun wrote:
> > > > > On Fri, May 09, 2025 at 01:04:58PM +1000, Alexey Kardashevskiy wrote:
> > > > > > Ping?
> > > > > 
> > > > > Sorry for late reply from vacation.
> > > > > 
> > > > > > Also, since there is pushback on 01/12 "dma-buf: Introduce dma_buf_get_pfn_unlocked() kAPI", what is the plan now? Thanks,
> > > > > 
> > > > > As disscussed in the thread, this kAPI is not well considered but IIUC
> > > > > the concept of "importer mapping" is still valid. We need more
> > > > > investigation about all the needs - P2P, CC memory, private bus
> > > > > channel, and work out a formal API.
> > > > > 
> > > > > However in last few months I'm focusing on high level TIO flow - TSM
> > > > > framework, IOMMUFD based bind/unbind, so no much progress here and is
> > > > > still using this temporary kAPI. But as long as "importer mapping" is
> > > > > alive, the dmabuf fd for KVM is still valid and we could enable TIO
> > > > > based on that.
> > > > 
> > > > Oh I forgot to mention I moved the dmabuf creation from VFIO to IOMMUFD
> > > > recently, the IOCTL is against iommufd_device.
> > > 
> > > I'm surprised by this.. iommufd shouldn't be doing PCI stuff, it is
> > > just about managing the translation control of the device.
> > 
> > I have a little difficulty to understand. Is TSM bind PCI stuff? To me
> > it is. Host sends PCI TDISP messages via PCI DOE to put the device in
> > TDISP LOCKED state, so that device behaves differently from before. Then
> > why put it in IOMMUFD?
> 
> 
> "TSM bind" sets up the CPU side of it, it binds a VM to a piece of IOMMU on the host CPU.

I didn't fully get your idea, are you defending for "TSM bind is NOT PCI
stuff"? To me it is not true.

TSM bind also sets up the device side. From your patch, it calls
tsm_tdi_bind(), which in turn calls spdm_forward(), I assume it is doing
TDISP LOCK. And TDISP LOCK changes device a lot.

> The device does not know about the VM, it just enables/disables encryption by a request from the CPU (those start/stop interface commands).
> And IOMMUFD won't be doing DOE, the platform driver (such as AMD CCP) will. Nothing to do for VFIO here.

IOMMUFD calls tsm_tdi_bind(), which is an interface doing PCI stuff.

Thanks,
Yilun

> 
> We probably should notify VFIO about the state transition but I do not know VFIO would want to do in response.
> 
> 

