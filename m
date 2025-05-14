Return-Path: <kvm+bounces-46469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D416AAB6803
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 11:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 365724A6B1C
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8301725DD15;
	Wed, 14 May 2025 09:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xp3ySUz6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E965C259CB1;
	Wed, 14 May 2025 09:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747216373; cv=none; b=h9AOqXzH9DSo1lRlgUxU+QhKUWBfrQRfVEYCgWRqJ1u98WlcO++V01Q2fMs1eFsVsppKm8sNEgcVw8ln5RHOVb1y0Hrm72mMoLawE+MjTkVgSMc56brlyf2mkhSb37P8XBxtBwcM6HDGahvVv3xBvKJWTeQMFbGuJ2rOqWkNPAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747216373; c=relaxed/simple;
	bh=DlDgEjTIw8VY2y5DvL0wFj1k14fF3hRHHDZCoRPLVMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVpoJ/FcIarnB6+gdACaHpcZYt8hO3oHYpEXa5Cvu0nBHijRLJvqasHBLML3OC6D3KvuyWmXy/M03d9/LPmIkAqj8pRUzHJoJlIPRseM4IH2xi9t14zElawQ3vbM0vrpLxYQclQ7Mv5+jzx+yUrsGTnNN/Nc3chmG7oQXvzm6+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xp3ySUz6; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747216372; x=1778752372;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DlDgEjTIw8VY2y5DvL0wFj1k14fF3hRHHDZCoRPLVMY=;
  b=Xp3ySUz6q9qtPP+5sTiRQAgBhy8FmmJHhYuMp9dYgdMo6WJpUNMR6oGr
   9TyBKumXOm2Lki68qA4+Mvmav9NZIQywgV7fq0YF1UT204l8NrRSOc/6w
   lToMb8yh4RY8sMQ2UY2Pk8x/XYGlLOccH3OVwp+a5rqnbWOH1MrnwRjdf
   bR0ws3VtItHwUQy8qIdRJFlqm9Duk56xOv6bPxXn8OQZHoklR00It39vL
   L+CDr7zp37XJELeV0KPF9t8ThV8R8ZOwKZIj6L11yPLDuMR9LMtsOMfcL
   OgiYj9DXhjDuYuXxNhPPy9AVw+/su1fsaC9ylKMRcjwSyZ9s7AoHamrwK
   Q==;
X-CSE-ConnectionGUID: jg1Dc9RuRb+dsHy9BLFutg==
X-CSE-MsgGUID: dC78j0cpTL2dfPSUXrb3fQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="52911883"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="52911883"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 02:52:51 -0700
X-CSE-ConnectionGUID: 1vGlQfU6TTiVJ/FihayGEA==
X-CSE-MsgGUID: vcaR5YHEQmC6RgOptATxfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="142866085"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa005.fm.intel.com with ESMTP; 14 May 2025 02:52:46 -0700
Date: Wed, 14 May 2025 17:47:12 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alexey Kardashevskiy <aik@amd.com>,
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
Message-ID: <aCRmoDupzK9zTqFL@yilunxu-OptiPlex-7050>
References: <371ab632-d167-4720-8f0d-57be1e3fee84@amd.com>
 <4b6dc759-86fd-47a7-a206-66b25a0ccc6d@amd.com>
 <c10bf9c2-e073-479d-ad1c-6796c592d333@amd.com>
 <aB3jLmlUKKziwdeG@yilunxu-OptiPlex-7050>
 <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <20250513130315.0158a626.zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513130315.0158a626.zhiw@nvidia.com>

On Tue, May 13, 2025 at 01:03:15PM +0300, Zhi Wang wrote:
> On Mon, 12 May 2025 11:06:17 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, May 12, 2025 at 07:30:21PM +1000, Alexey Kardashevskiy wrote:
> > 
> > > > > I'm surprised by this.. iommufd shouldn't be doing PCI stuff,
> > > > > it is just about managing the translation control of the device.
> > > > 
> > > > I have a little difficulty to understand. Is TSM bind PCI stuff?
> > > > To me it is. Host sends PCI TDISP messages via PCI DOE to put the
> > > > device in TDISP LOCKED state, so that device behaves differently
> > > > from before. Then why put it in IOMMUFD?
> > > 
> > > 
> > > "TSM bind" sets up the CPU side of it, it binds a VM to a piece of
> > > IOMMU on the host CPU. The device does not know about the VM, it
> > > just enables/disables encryption by a request from the CPU (those
> > > start/stop interface commands). And IOMMUFD won't be doing DOE, the
> > > platform driver (such as AMD CCP) will. Nothing to do for VFIO here.
> > > 
> > > We probably should notify VFIO about the state transition but I do
> > > not know VFIO would want to do in response.
> > 
> > We have an awkward fit for what CCA people are doing to the various
> > Linux APIs. Looking somewhat maximally across all the arches a "bind"
> > for a CC vPCI device creation operation does:
> > 
> >  - Setup the CPU page tables for the VM to have access to the MMIO
> >  - Revoke hypervisor access to the MMIO
> >  - Setup the vIOMMU to understand the vPCI device
> >  - Take over control of some of the IOVA translation, at least for
> > T=1, and route to the the vIOMMU
> >  - Register the vPCI with any attestation functions the VM might use
> >  - Do some DOE stuff to manage/validate TDSIP/etc
> > 
> > So we have interactions of things controlled by PCI, KVM, VFIO, and
> > iommufd all mushed together.
> > 
> > iommufd is the only area that already has a handle to all the required
> > objects:
> >  - The physical PCI function
> >  - The CC vIOMMU object
> >  - The KVM FD
> >  - The CC vPCI object
> > 
> > Which is why I have been thinking it is the right place to manage
> > this.
> > 
> > It doesn't mean that iommufd is suddenly doing PCI stuff, no, that
> > stays in VFIO.
> > 
> > > > > So your issue is you need to shoot down the dmabuf during vPCI
> > > > > device destruction?
> > > > 
> > > > I assume "vPCI device" refers to assigned device in both shared
> > > > mode & prvate mode. So no, I need to shoot down the dmabuf during
> > > > TSM unbind, a.k.a. when assigned device is converting from
> > > > private to shared. Then recover the dmabuf after TSM unbind. The
> > > > device could still work in VM in shared mode.
> > 
> > What are you trying to protect with this? Is there some intelism where
> > you can't have references to encrypted MMIO pages?
> > 
> 
> I think it is a matter of design choice. The encrypted MMIO page is
> related to the TDI context and secure second level translation table
> (S-EPT). and S-EPT is related to the confidential VM's context.
> 
> AMD and ARM have another level of HW control, together
> with a TSM-owned meta table, can simply mask out the access to those
> encrypted MMIO pages. Thus, the life cycle of the encrypted mappings in
> the second level translation table can be de-coupled from the TDI
> unbound. They can be reaped un-harmfully later by hypervisor in another
> path.
> 
> While on Intel platform, it doesn't have that additional level of
> HW control by design. Thus, the cleanup of encrypted MMIO page mapping
> in the S-EPT has to be coupled tightly with TDI context destruction in
> the TDI unbind process.

Thanks for the accurate explanation. Yes, in TDX, the references/mapping
to the encrypted MMIO page means a CoCo-VM owns the MMIO page. So TDX
firmware won't allow the CC vPCI device (which physically owns the MMIO
page) unbind/freed from a CoCo-VM, while the VM still have the S-EPT mapping.

AMD doesn't use KVM page table to track CC ownership, so no need to
interact with KVM.

Thanks,
Yilun

> 
> If the TDI unbind is triggered in VFIO/IOMMUFD, there has be a
> cross-module notification to KVM to do cleanup in the S-EPT.
> 
> So shooting down the DMABUF object (encrypted MMIO page) means shooting
> down the S-EPT mapping and recovering the DMABUF object means
> re-construct the non-encrypted MMIO mapping in the EPT after the TDI is
> unbound. 
> 
> Z.
> 
> > > > What I really want is, one SW component to manage MMIO dmabuf,
> > > > secure iommu & TSM bind/unbind. So easier coordinate these 3
> > > > operations cause these ops are interconnected according to secure
> > > > firmware's requirement.
> > >
> > > This SW component is QEMU. It knows about FLRs and other config
> > > space things, it can destroy all these IOMMUFD objects and talk to
> > > VFIO too, I've tried, so far it is looking easier to manage. Thanks,
> > 
> > Yes, qemu should be sequencing this. The kernel only needs to enforce
> > any rules required to keep the system from crashing.
> > 
> > Jason
> > 
> 

