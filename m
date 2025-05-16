Return-Path: <kvm+bounces-46765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DF5AB95F5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADD1C1B62C76
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 06:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D799224B05;
	Fri, 16 May 2025 06:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dU+m4VKp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B995223DC7;
	Fri, 16 May 2025 06:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747376732; cv=none; b=D8mJxsOyPocMNXva2ARfYhF2ntYwgg5IPt88LVxLJt+Iu8Wv1yrErizhe9kr2sTzJsNmSrosnvDKx3izfh4BGGrjMo/DF1ky99er9EWN+2Z3jAAFSf0SPb+6pw5Nc80iVDwBQWYDBb7iAn9q1ghtAXt8UsCvM/WOWvKH0YxLtm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747376732; c=relaxed/simple;
	bh=lCwb6qvlkqeYb94a9hs2gM7d9RlJ/96IMNwhyjCb+Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FpZAZS5hnqpGB3Ki9bgHAfOIZRwmsd+9HXxoOZ/EkmsNhGfIYZffcd2/y5onbD+khc5ksBsMQt710y5tuRGCRNHB2KaMyQRRnp+nRR6z0h3jQRYBhDoLlWW9EKBzEhcKqwvnpDd+qLEXi0p4LGcEbA/+riBhRCQAE9LHztaXS6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dU+m4VKp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747376731; x=1778912731;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lCwb6qvlkqeYb94a9hs2gM7d9RlJ/96IMNwhyjCb+Lg=;
  b=dU+m4VKpsYEOmF2tRhwwsasbi+d4bXcwQBJmbmm8xWFAE07FTb7sLox7
   CdhikvXUECvx584l6sdyyHtF18es9beUjms2WUUvYtOKhkSiYPxc6HIAg
   hnGsW+jKBNt37RVVHH1dZWEBrnA1HsdObAjKn/V5Z+kvupi8ou2hwcz4s
   Ogep/XLpnSgJjg8hZlavZR+V5RPyUGCzW0AXf+j78VaO7Tt5qhWvODRNH
   2s0qmFtinpO9S3gomi4lL1UhKNBTJnYDgUds/RPFm6QO8ybkLuKMqMfoj
   mC1jxzXuKNIx8VkOwfM4Yqm/VFfAmxJWs7bny7agOnGqy5MSonYukM7V1
   A==;
X-CSE-ConnectionGUID: X7TKXzZkR92UfBtuNo9Ehg==
X-CSE-MsgGUID: hQzWwRlkSgyZwfnW1tFQVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="66741987"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="66741987"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:25:30 -0700
X-CSE-ConnectionGUID: 5Zv+L4k4Q/GDOPGKqyBYEA==
X-CSE-MsgGUID: u+Y2gDkpS/CZp7vpWOupPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="143831538"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 15 May 2025 23:25:24 -0700
Date: Fri, 16 May 2025 14:19:45 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Zhi Wang <zhiw@nvidia.com>, Alexey Kardashevskiy <aik@amd.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 00/12] Private MMIO support for private assigned dev
Message-ID: <aCbZATrK7EPyH4qt@yilunxu-OptiPlex-7050>
References: <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <20250513130315.0158a626.zhiw@nvidia.com>
 <aCRmoDupzK9zTqFL@yilunxu-OptiPlex-7050>
 <20250514230502.6b64da7f.zhiw@nvidia.com>
 <aCYsNSFQJZzHVOFI@yilunxu-OptiPlex-7050>
 <20250515192127.GA580805@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515192127.GA580805@nvidia.com>

On Thu, May 15, 2025 at 04:21:27PM -0300, Jason Gunthorpe wrote:
> On Fri, May 16, 2025 at 02:02:29AM +0800, Xu Yilun wrote:
> > > IMHO, I think it might be helpful that you can picture out what are the
> > > minimum requirements (function/life cycle) to the current IOMMUFD TSM
> > > bind architecture:
> > > 
> > > 1.host tsm_bind (preparation) is in IOMMUFD, triggered by QEMU handling
> > > the TVM-HOST call.
> > > 2. TDI acceptance is handled in guest_request() to accept the TDI after
> > > the validation in the TVM)
> > 
> > I'll try my best to brainstorm and make a flow in ASCII. 
> > 
> > (*) means new feature
> > 
> > 
> >       Guest          Guest TSM       QEMU           VFIO            IOMMUFD       host TSM          KVM 
> >       -----          ---------       ----           ----            -------       --------          ---
> > 1.                                                                               *Connect(IDE)
> > 2.                                 Init vdev            
> 
> open /dev/vfio/XX as a VFIO action
> 
> Then VFIO attaches to IOMMUFD as an iommufd action creating the idev
> 
> > 3.                                *create dmabuf   
> > 4.                                               *export dmabuf                              
> > 5.                                create memslot
> > 6.                                                                                              *import dmabuf
> > 7.                                setup shared DMA
> > 8.                                                                 create hwpt
> > 9.                                               attach hwpt
> > 10.                                  kvm run
> > 11.enum shared dev
> > 12.*Connect(Bind)
> > 13.                  *GHCI Bind
> > 14.                                  *Bind
> > 15                                                                 CC viommu alloc
> > 16.                                                                vdevice allloc
> 
> viommu and vdevice creation happen before KVM run. The vPCI function
> is visible to the guest from the very start, even though it is in T=0
> mode. If a platform does not require any special CC steps prior to KVM
> run then it just has a NOP for these functions.
> 

Fine.

> What you have here is some new BIND operation against the already
> existing vdevice as we discussed earlier.
> 
> > 16.                                              *attach vdev
> > 17.                                                               *setup CC viommu
> > 18                                                                 *tsm_bind
> > 19.                                                                                  *bind
> > 20.*Attest
> > 21.               *GHCI get CC info
> > 22.                                 *get CC info
> > 23.                                                                *vdev guest req
> > 24.                                                                                 *guest req
> > 25.*Accept
> > 26.             *GHCI accept MMIO/DMA
> > 27.                                *accept MMIO/DMA
> > 28.                                                               *vdev guest req
> > 29.                                                                                 *guest req
> > 30.                                                                                              *map private MMIO
> > 31.             *GHCI start tdi
> > 32.                                *start tdi
> > 33.                                                               *vdev guest req
> > 34.                                                                                 *guest req
> 
> This seems reasonable you want to have some generic RPC scheme to
> carry messages fro mthe VM to the TSM tunneled through the iommufd
> vdevice (because the vdevice has the vPCI ID, the KVM ID, the VIOMMU
> id and so on)
> 
> > 35.Workload...
> > 36.*disconnect(Unbind)
> > 37.              *GHCI unbind
> > 38.                                *Unbind
> > 39.                                            *detach vdev
> 
> unbind vdev. vdev remains until kvm is stopped.
> 
> > 40.                                                               *tsm_unbind
> > 41.                                                                                 *TDX stop tdi
> > 42.                                                                                 *TDX disable mmio cb
> > 43.                                            *cb dmabuf revoke
> > 44.                                                                                               *unmap private MMIO
> > 45.                                                                                 *TDX disable dma cb
> > 46.                                                              *cb disable CC viommu
> 
> I don't know why you'd disable a viommu while the VM is running,
> doesn't make sense.

Here it means remove the CC setup for viommu, shared setup is still
kept.

It is still because of the TDX enforcement on Unbind :(

  1. STOP TDI via TDISP message STOP_INTERFACE
  2. Private MMIO unmap from Secure EPT
  3. Trusted Device Context Table cleanup for the TDI
  4. TDI ownership reclaim and metadata free

It is doing Step 3 so that the TDI could finally been removed.

Please also note I does CC viommu setup on "Bind".

Thanks,
Yilun

> 
> > 47.                                                                                 *TDX tdi free
> > 48.                                                                                 *enable mmio
> > 49.                                            *cb dmabuf recover
> > 50.workable shared dev
> 
> This is a nice chart, it would be good to see a comparable chart for
> AMD and ARM
> 
> Jason

