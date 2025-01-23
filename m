Return-Path: <kvm+bounces-36329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A93A1A0E1
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 10:34:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D55E3AA3D4
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 09:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72AC20C48D;
	Thu, 23 Jan 2025 09:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B2Kw2G6B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673D71BC3F
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 09:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737624850; cv=none; b=t1uXNmOMqSFW0qY8wFfDrhjj2Ei1Sgowc/EgUkJNCrh7RlTLqAAP7ikvw5O1bZC9ue1UFcyTRW9BXk1I2Mxe1S+NHiS7cWEMPP9x+bFyW/2f1ZvsnLNrm7dgZ5rIIyasAxakmdeFOtGI3lppIwYVUTDQL8tMrLTr+kIrPu5qp1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737624850; c=relaxed/simple;
	bh=LFoe2M4h2MR8WGWqKYSw1Zj4e0KwcSMzi45qyN7Ol4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sERIlpm4hPugMsQapmgRp+PpXuSynhDgx7NfrTTasbU53BDVg7gJKk9oQyQQvgv7mtHToh3qIbIJ26rQTTkiHElyAytfOX9UU+8gTZp3xhioyeMLbpFPt/HTNGx+031f5taN/rVLIpQ29iWFdWHZAIUS/JM2a8j9CcdUO2sN4Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B2Kw2G6B; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737624849; x=1769160849;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LFoe2M4h2MR8WGWqKYSw1Zj4e0KwcSMzi45qyN7Ol4c=;
  b=B2Kw2G6B5JomUD1Z6/drk0t5MBjUrTQasfWTorm2WVsi9bDUPxuxRgFu
   eRMFqxJL4pn44lSAZLzDgs+btg7NRc6nu/Niun5DXQHE9kg6CvompMHDH
   fO58MqajOfiFCL7xNxnf+aBC3y6v2rwWlDqgXDSCLRuq8QvLi3k+oIwOG
   XnVSaGPob09llbhvKeSb2Grgw2TYVrmcsT7YxSUupdWe5NKDjVRexPpiG
   8N8Zbge/PyXGCRIBamV1d8nFHY9hjUvPXXRLLLJGdODbdrYvxQCZmtBVj
   r93AM0XyUw/iejUEdr+AfX6rVoPOXQ62pyxR1F+rHw1nSWrqE9SFa59AJ
   A==;
X-CSE-ConnectionGUID: VbO5TJ3aSwShJEJ1T6itcA==
X-CSE-MsgGUID: nWUpmq2CTq2zKXAVxZxKCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="37996844"
X-IronPort-AV: E=Sophos;i="6.13,228,1732608000"; 
   d="scan'208";a="37996844"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 01:34:08 -0800
X-CSE-ConnectionGUID: ZDooXmqKQd2+fDzx0x5NVw==
X-CSE-MsgGUID: Rr12phi6QGGYF8BLwSYDbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,228,1732608000"; 
   d="scan'208";a="138269350"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 23 Jan 2025 01:34:05 -0800
Date: Thu, 23 Jan 2025 17:33:53 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Peter Xu <peterx@redhat.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050>
References: <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
 <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
 <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
 <Z462F1Dwm6cUdCcy@x1n>
 <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
 <Z4-6u5_9NChu_KZq@x1n>
 <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>
 <Z5EgFaWIyjIiOZnv@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5EgFaWIyjIiOZnv@x1n>

On Wed, Jan 22, 2025 at 11:43:01AM -0500, Peter Xu wrote:
> On Wed, Jan 22, 2025 at 05:41:31PM +0800, Xu Yilun wrote:
> > On Wed, Jan 22, 2025 at 03:30:05PM +1100, Alexey Kardashevskiy wrote:
> > > 
> > > 
> > > On 22/1/25 02:18, Peter Xu wrote:
> > > > On Tue, Jun 25, 2024 at 12:31:13AM +0800, Xu Yilun wrote:
> > > > > On Mon, Jan 20, 2025 at 03:46:15PM -0500, Peter Xu wrote:
> > > > > > On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
> > > > > > > > It is still uncertain how to implement the private MMIO. Our assumption
> > > > > > > > is the private MMIO would also create a memory region with
> > > > > > > > guest_memfd-like backend. Its mr->ram is true and should be managed by
> > > > > > > > RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> > > > > > > > listener.
> > > > > > > 
> > > > > > > My current working approach is to leave it as is in QEMU and VFIO.
> > > > > > 
> > > > > > Agreed.  Setting ram=true to even private MMIO sounds hackish, at least
> > > > > 
> > > > > The private MMIO refers to assigned MMIO, not emulated MMIO. IIUC,
> > > > > normal assigned MMIO is always set ram=true,
> > > > > 
> > > > > void memory_region_init_ram_device_ptr(MemoryRegion *mr,
> > > > >                                         Object *owner,
> > > > >                                         const char *name,
> > > > >                                         uint64_t size,
> > > > >                                         void *ptr)
> 
> [1]
> 
> > > > > {
> > > > >      memory_region_init(mr, owner, name, size);
> > > > >      mr->ram = true;
> > > > > 
> > > > > 
> > > > > So I don't think ram=true is a problem here.
> > > > 
> > > > I see.  If there's always a host pointer then it looks valid.  So it means
> > > > the device private MMIOs are always mappable since the start?
> > > 
> > > Yes. VFIO owns the mapping and does not treat shared/private MMIO any
> > > different at the moment. Thanks,
> > 
> > mm.. I'm actually expecting private MMIO not have a host pointer, just
> > as private memory do.
> > 
> > But I'm not sure why having host pointer correlates mr->ram == true.
> 
> If there is no host pointer, what would you pass into "ptr" as referenced
> at [1] above when creating the private MMIO memory region?

Sorry for confusion. I mean existing MMIO region use set mr->ram = true,
and unmappable region (gmem) also set mr->ram = true. So don't know why
mr->ram = true for private MMIO is hackish.

I think We could add another helper to create memory region for private
MMIO.

> 
> OTOH, IIUC guest private memory finally can also have a host pointer (aka,
> mmap()-able), it's just that even if it exists, accessing it may crash QEMU
> if it's private.

Not sure if I get it correct: when memory will be converted to private, QEMU
should firstly unmap the host ptr, which means host ptr doesn't alway exist.

Thanks,
Yilun

> 
> Thanks,
> 
> -- 
> Peter Xu
> 

