Return-Path: <kvm+bounces-46102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 325ABAB2114
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 05:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEA277BAFAB
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 03:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622401B4244;
	Sat, 10 May 2025 03:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nVwMizCX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71F3288D6;
	Sat, 10 May 2025 03:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746849204; cv=none; b=HBckOXfyEgnioPvrskyiwKBc5IuDITIUC7sbjFPhawPzPnYSNYp2wGXq9G4X8DsoXwP9yxRuZWxRK2fFGpkeOlX3ePYmT0iWeU3uXsL2oml5NyTgwjNiht+yyDvFnlh3SjQh2uEgn+1kxLvcHNCPWEVCrj7MShuJBaCocu/oLhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746849204; c=relaxed/simple;
	bh=7qd8Dq2IKH8h6Z7jvG365ZGz9qLosU047aoIDs4o9oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=niEWPZ0saHTVDki//8NfvQPCRJiGY2kEQxslGGkC37n+kNEoaOO+wlpf6lvgsOD6ekVQHhiRyB1K3+ikTrsJadgy8XhLvGGOva9/DMW2wQ/5pASOYgQM8DK2brbeIfWSHbI52sE0/o+1Iu6+96uojThBbCAg9XtLGWEqwVaY/jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nVwMizCX; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746849203; x=1778385203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7qd8Dq2IKH8h6Z7jvG365ZGz9qLosU047aoIDs4o9oc=;
  b=nVwMizCXBN2guwF+vXSbwEbxtpLhrJNvl/PqoDCWvp9WLWPyDwyC6XIj
   Z6wcnGhdjSnh/U/wMmMFDpWwingkfGcPTpc/UTGqqyHhxAcrtehZU+ZOf
   TbFlvMA/tJyMEpOGT0IeB0Uajw8ZsCu5wntAnBGHTuSwpVWl/jTMiSyaU
   hv+limzd+UohZwWGkxk/pwU9bITvsWGwDCvNWu68z8aFxf7dufSVZrG6F
   7iFVEY+PINirOXyfxJcL7O3V7LFGhvx/IwnHCjJ9jFZtF0UI/2f1s5/KW
   vZMg1o1xoqQU0MI/xgUwmKCzWa1oY0xOq+6ynBXrTDXa3wYTcZFXlBtIy
   g==;
X-CSE-ConnectionGUID: Bt7B+ElmQ3O+AjoKBRIOdg==
X-CSE-MsgGUID: 1ng2/xBISC+qm39FQLVJgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48843481"
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="48843481"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 20:53:22 -0700
X-CSE-ConnectionGUID: Ia6DHy6hToG9AsdGC0hjsw==
X-CSE-MsgGUID: SEM7hvo0QLuzcu2Q3hWrYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="160095646"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa002.fm.intel.com with ESMTP; 09 May 2025 20:53:17 -0700
Date: Sat, 10 May 2025 11:47:55 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
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
Message-ID: <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
 <371ab632-d167-4720-8f0d-57be1e3fee84@amd.com>
 <4b6dc759-86fd-47a7-a206-66b25a0ccc6d@amd.com>
 <c10bf9c2-e073-479d-ad1c-6796c592d333@amd.com>
 <aB3jLmlUKKziwdeG@yilunxu-OptiPlex-7050>
 <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250509184318.GD5657@nvidia.com>

On Fri, May 09, 2025 at 03:43:18PM -0300, Jason Gunthorpe wrote:
> On Sat, May 10, 2025 at 12:28:48AM +0800, Xu Yilun wrote:
> > On Fri, May 09, 2025 at 07:12:46PM +0800, Xu Yilun wrote:
> > > On Fri, May 09, 2025 at 01:04:58PM +1000, Alexey Kardashevskiy wrote:
> > > > Ping?
> > > 
> > > Sorry for late reply from vacation.
> > > 
> > > > Also, since there is pushback on 01/12 "dma-buf: Introduce dma_buf_get_pfn_unlocked() kAPI", what is the plan now? Thanks,
> > > 
> > > As disscussed in the thread, this kAPI is not well considered but IIUC
> > > the concept of "importer mapping" is still valid. We need more
> > > investigation about all the needs - P2P, CC memory, private bus
> > > channel, and work out a formal API.
> > > 
> > > However in last few months I'm focusing on high level TIO flow - TSM
> > > framework, IOMMUFD based bind/unbind, so no much progress here and is
> > > still using this temporary kAPI. But as long as "importer mapping" is
> > > alive, the dmabuf fd for KVM is still valid and we could enable TIO
> > > based on that.
> > 
> > Oh I forgot to mention I moved the dmabuf creation from VFIO to IOMMUFD
> > recently, the IOCTL is against iommufd_device.
> 
> I'm surprised by this.. iommufd shouldn't be doing PCI stuff, it is
> just about managing the translation control of the device.

I have a little difficulty to understand. Is TSM bind PCI stuff? To me
it is. Host sends PCI TDISP messages via PCI DOE to put the device in
TDISP LOCKED state, so that device behaves differently from before. Then
why put it in IOMMUFD?

Or "managing the translation control" means IOMMUFD provides the TSM
bind/unbind uAPI and call into VFIO driver for real TSM bind
implementation?

> 
> > According to Jason's
> > opinion [1], TSM bind/unbind should be called against iommufd_device,
> > then I need to do the same for dmabuf.  This is because Intel TDX
> > Connect enforces a specific operation sequence between TSM unbind & MMIO
> > unmap:
> > 
> >   1. STOP TDI via TDISP message STOP_INTERFACE
> >   2. Private MMIO unmap from Secure EPT
> >   3. Trusted Device Context Table cleanup for the TDI
> >   4. TDI ownership reclaim and metadata free
> 
> So your issue is you need to shoot down the dmabuf during vPCI device
> destruction?

I assume "vPCI device" refers to assigned device in both shared mode &
prvate mode. So no, I need to shoot down the dmabuf during TSM unbind,
a.k.a. when assigned device is converting from private to shared.
Then recover the dmabuf after TSM unbind. The device could still work
in VM in shared mode. 

> 
> VFIO also needs to shoot down the MMIO during things like FLR
> 
> I don't think moving to iommufd really fixes it, it sounds like you
> need more coordination between the two parts??

Yes, when moving to iommufd, VFIO needs extra kAPIs to inform IOMMUFD
about the shooting down. But FLR or MSE toggle also breaks TSM bind
state. As long as we put TSM bind in IOMMUFD, anyway the coordination
is needed.

What I really want is, one SW component to manage MMIO dmabuf, secure
iommu & TSM bind/unbind. So easier coordinate these 3 operations cause
these ops are interconnected according to secure firmware's requirement.
Otherwise e.g. for TDX, when device is TSM bound (IOMMUFD controls
bind) and VFIO wants FLR, VFIO revokes dmabuf first then explode.

Safe way is one SW component manages all these "pre-FLR" stuffs, let's say
IOMMUFD, it firstly do TSM unbind, let the platform TSM driver decides
the correct operation sequence (TDISP, dmabuf for private MMIO mapping,
secure dma). After TSM unbind, it's a shared device and IOMMUFD have no
worry to revoke dmabuf as needed.

Maybe I could send a patchset to illustrate...

Thanks,
Yilun

> 
> Jason

