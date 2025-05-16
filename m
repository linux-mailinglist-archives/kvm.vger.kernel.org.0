Return-Path: <kvm+bounces-46763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB8AAB95D4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34EF64E474D
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 06:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E69223DCA;
	Fri, 16 May 2025 06:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bLLhv56b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D3A221728;
	Fri, 16 May 2025 06:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747375782; cv=none; b=jdhpopBLndEuK5PiaVpD3UPmMMKjNefuTmIiBtIyuvSLQybSe7rzpXsLQhztFCR7GicX7MTxdYj5Mxsd+t7Pqa7SUtnojH5/yq0MNEkAqwQDl6yCD9e91uxEXpQ9TODg4Ne4zizT12GWkB2fILFYbiLoQJYY7FHc1lI8N3hx8uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747375782; c=relaxed/simple;
	bh=qyhT7n431vXM4anrRMDRMlFCdybdA0lFKBwmzpN5FDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXTYlCcwFk5EwYnjvSbTGZMeAlzgasmf9vzv/s/ZWC90hPFsIGf7tyrAP+r2gQLCs/omnDRSc8Oe3A+CJ+LtCkU2jQG306KcYHBWiSMEgsd1TLoNb7QPy/o1eLI49EmbAlgcwTBd+kBNzTYhtR3nKqfljkiHbbTRmiz8VMzVhNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bLLhv56b; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747375781; x=1778911781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qyhT7n431vXM4anrRMDRMlFCdybdA0lFKBwmzpN5FDQ=;
  b=bLLhv56bCqW/6CxhMzAFF0KIWqp5SQqV4M+hRZsJ35NcwEUEz8UtqG1C
   x88tqzEg9IIOqkP1TSuAqm2YhrR6GgWEQCu/TQVAB5VgpN6wY4a8vAWIO
   qo5epaYnt28HlKaWfPGNtSgU1SRTZsAtY/8bKOWprSH75oLLkySR8i0jM
   mQuE5urIBhI6t9iPXT9+9fP5d1uYu9thfKptE9x+N7hEmq/+pqCtdKj9W
   poQoC3+IBS7mznJ/o70YS7f5lZQhx459N/ZiyvahOqZJMfT2YVKG5DADS
   9FVO0k355/DOz/d89vNUzACitFDHhKs6QN8dfdjcrDyMcHELt6mikuOS6
   A==;
X-CSE-ConnectionGUID: e5u9mQvqRPKUlfmF3N95gw==
X-CSE-MsgGUID: 5yBI/D7FT3q2rGwKRR64ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="36955275"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="36955275"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:09:40 -0700
X-CSE-ConnectionGUID: 3mdypJMGTIagJOxBJAReOw==
X-CSE-MsgGUID: wT2fZ/BCRcqrCSFZ3R6eGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="139087544"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa010.fm.intel.com with ESMTP; 15 May 2025 23:09:34 -0700
Date: Fri, 16 May 2025 14:03:55 +0800
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
Message-ID: <aCbVSxg0wS3wJXWB@yilunxu-OptiPlex-7050>
References: <aB3jLmlUKKziwdeG@yilunxu-OptiPlex-7050>
 <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <aCRAHRCKP1s0Oi0c@yilunxu-OptiPlex-7050>
 <20250514163339.GD382960@nvidia.com>
 <aCYQdDrYYZRAgsen@yilunxu-OptiPlex-7050>
 <20250515175658.GR382960@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515175658.GR382960@nvidia.com>

On Thu, May 15, 2025 at 02:56:58PM -0300, Jason Gunthorpe wrote:
> On Fri, May 16, 2025 at 12:04:04AM +0800, Xu Yilun wrote:
> > > arches this was mostly invisible to the hypervisor?
> > 
> > Attest & Accept can be invisible to hypervisor, or host just help pass
> > data blobs between guest, firmware & device.
> > 
> > Bind cannot be host agnostic, host should be aware not to touch device
> > after Bind.
> 
> I'm not sure this is fully true, this could be a Intel thing. When the
> vPCI is created the host can already know it shouldn't touch the PCI
> device anymore and the secure world would enforce that when it gets a
> bind command.
> 
> The fact it hasn't been locked out immediately at vPCI creation time
> is sort of a detail that doesn't matter, IMHO.

I see, SW can define the lock out in a wider range. I suddenly understand
you are considering finish all host side CC setup on viommu_alloc &
vdevice_alloc before KVM run, then "Bind" could host agnostic, and TDISP
LOCK/STOP could also be a guest_request.

Now the problem is for TDX, host cannot be agnostic to LOCK/STOP because
of the KVM MMIO mapping ...

I still have to make VFIO uAPIs for "Bind"/"Unbind"

> 
> > > It might be reasonable to have VFIO reach into iommufd to do that on
> > > an already existing iommufd VDEVICE object. A little weird, but we
> > > could probably make that work.
> > 
> > Mm, Are you proposing an uAPI in VFIO, and a kAPI from VFIO -> IOMMUFD like:
> >
> >  ioctl(vfio_fd, VFIO_DEVICE_ATTACH_VDEV, vdev_id)
> >  -> iommufd_device_attach_vdev()
> >     -> tsm_tdi_bind()
> 
> Not ATTACH, you wanted BIND. You could have a VFIO_DEVICE_BIND(iommufd
> vdevice id)

Yes.

> 
> > > sees VFIO remove the S-EPT and release the KVM, then have iommufd
> > > destroy the VDEVICE object.
> > 
> > Regarding VM destroy, TDX Connect has more enforcement, VM could only be
> > destroyed after all assigned CC vPCI devices are destroyed.
> 
> And KVM destroys the VM?

Yes.

>  
> > Nowadays, VFIO already holds KVM reference, so we need
> > 
> > close(vfio_fd)
> > -> iommufd_device_detach_vdev()
> 
> This doesn't happen though, it destroys the normal device (idev) which
> the vdevice is stacked on top of. You'd have to make normal device
> destruction trigger vdevice destruction
> 
> >    -> tsm_tdi_unbind()
> >       -> tdi stop
> >       -> callback to VFIO, dmabuf_move_notify(revoke)
> >          -> KVM unmap MMIO
> >       -> tdi metadata remove
> 
> This omits the viommu. It won't get destroyed until the iommufd
> closes, so iommufd will be holding the kvm and it will do the final
> put.

I see.

https://lore.kernel.org/all/20250319233111.GE126678@ziepe.ca/

Thanks,
Yilun

> 
> Jason

