Return-Path: <kvm+bounces-36473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 434BDA1B2ED
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 10:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6D527A0811
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 09:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF646219E82;
	Fri, 24 Jan 2025 09:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HudrXgG5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAEF23A0
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 09:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737712087; cv=none; b=cNYjkXXvcuvwMj/4DEvhB76guN23MohxsqNVjADs3GezpIFVlwv2knFusF/G5TaAutTiUoBei0ZFhJD/tbdhr03WbGUvrbbbrNNRtoCAHtlyAmZmnyJxuDmiTqp8w1HIhd2XNBesn6VYBz994Cveip8XTWG5Fgc7fn45QDufT54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737712087; c=relaxed/simple;
	bh=ZCO/MfX8NlwMysTySYqInSrG/aVh4QrZSiFlw8U2DTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isibsRv02zUBOROZB/9eiFqlTJruYKBokOcz1CapHOFCJBIAVwkIA3n2E993/+MkQVc8irHThYGl6wNaXPEiBBp2r5AEJUpWUzAgoZuHfZZuUwFVlD+MHBia3g+971qkvE8bfLJ781DgRe/3BMukpsH4Adf6cYwOF9+7GEYGSMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HudrXgG5; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737712085; x=1769248085;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZCO/MfX8NlwMysTySYqInSrG/aVh4QrZSiFlw8U2DTU=;
  b=HudrXgG5YQzFhSiTla5iwVGT7ix9c/qd8GhNuPfMe7tugQMyZmxICATQ
   FgSqtiKvCD++qi2YTVWSCKrviXxkufzm4KvU4NCLNWF82DighnOpxTwWM
   OnuLp+VkZ5c4TNN2LrKjCibut/ds4S3/SFhjn+hCpp+o+cGJQgfWpUV/T
   5eZDYigdH/9B5X4X2ElIKTcvkNWyaxuFg5+raVR6BE6Qw2dHlzjqC9d9P
   n2CzD/gfYSR+aHvm1HY3leqRo5cRO1tmR6x+ZYt8rnWVRfROlKNHgHMFT
   q8pOjrGCFZlN3XybNcmoQeJRIZckLrTVkCTdUFdvbwlL9iXuem6gMuxyE
   g==;
X-CSE-ConnectionGUID: EedhIUhkQU6id2FLRwozWw==
X-CSE-MsgGUID: eHgrGsKCSjONtWGERB8jtw==
X-IronPort-AV: E=McAfee;i="6700,10204,11324"; a="38384677"
X-IronPort-AV: E=Sophos;i="6.13,230,1732608000"; 
   d="scan'208";a="38384677"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 01:48:04 -0800
X-CSE-ConnectionGUID: 9Ia2M76ySwGjhE/uJ2a80A==
X-CSE-MsgGUID: tdwLn7+uRXqx0YvAArLPNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,230,1732608000"; 
   d="scan'208";a="138593034"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 24 Jan 2025 01:48:01 -0800
Date: Fri, 24 Jan 2025 17:47:45 +0800
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
Message-ID: <Z5NhwW/IXaLfvjvb@yilunxu-OptiPlex-7050>
References: <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
 <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
 <Z462F1Dwm6cUdCcy@x1n>
 <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
 <Z4-6u5_9NChu_KZq@x1n>
 <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>
 <Z5EgFaWIyjIiOZnv@x1n>
 <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050>
 <Z5Jylb73kDJ6HTEZ@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5Jylb73kDJ6HTEZ@x1n>

On Thu, Jan 23, 2025 at 11:47:17AM -0500, Peter Xu wrote:
> On Thu, Jan 23, 2025 at 05:33:53PM +0800, Xu Yilun wrote:
> > On Wed, Jan 22, 2025 at 11:43:01AM -0500, Peter Xu wrote:
> > > On Wed, Jan 22, 2025 at 05:41:31PM +0800, Xu Yilun wrote:
> > > > On Wed, Jan 22, 2025 at 03:30:05PM +1100, Alexey Kardashevskiy wrote:
> > > > > 
> > > > > 
> > > > > On 22/1/25 02:18, Peter Xu wrote:
> > > > > > On Tue, Jun 25, 2024 at 12:31:13AM +0800, Xu Yilun wrote:
> > > > > > > On Mon, Jan 20, 2025 at 03:46:15PM -0500, Peter Xu wrote:
> > > > > > > > On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
> > > > > > > > > > It is still uncertain how to implement the private MMIO. Our assumption
> > > > > > > > > > is the private MMIO would also create a memory region with
> > > > > > > > > > guest_memfd-like backend. Its mr->ram is true and should be managed by
> > > > > > > > > > RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> > > > > > > > > > listener.
> > > > > > > > > 
> > > > > > > > > My current working approach is to leave it as is in QEMU and VFIO.
> > > > > > > > 
> > > > > > > > Agreed.  Setting ram=true to even private MMIO sounds hackish, at least
> > > > > > > 
> > > > > > > The private MMIO refers to assigned MMIO, not emulated MMIO. IIUC,
> > > > > > > normal assigned MMIO is always set ram=true,
> > > > > > > 
> > > > > > > void memory_region_init_ram_device_ptr(MemoryRegion *mr,
> > > > > > >                                         Object *owner,
> > > > > > >                                         const char *name,
> > > > > > >                                         uint64_t size,
> > > > > > >                                         void *ptr)
> > > 
> > > [1]
> > > 
> > > > > > > {
> > > > > > >      memory_region_init(mr, owner, name, size);
> > > > > > >      mr->ram = true;
> > > > > > > 
> > > > > > > 
> > > > > > > So I don't think ram=true is a problem here.
> > > > > > 
> > > > > > I see.  If there's always a host pointer then it looks valid.  So it means
> > > > > > the device private MMIOs are always mappable since the start?
> > > > > 
> > > > > Yes. VFIO owns the mapping and does not treat shared/private MMIO any
> > > > > different at the moment. Thanks,
> > > > 
> > > > mm.. I'm actually expecting private MMIO not have a host pointer, just
> > > > as private memory do.
> > > > 
> > > > But I'm not sure why having host pointer correlates mr->ram == true.
> > > 
> > > If there is no host pointer, what would you pass into "ptr" as referenced
> > > at [1] above when creating the private MMIO memory region?
> > 
> > Sorry for confusion. I mean existing MMIO region use set mr->ram = true,
> > and unmappable region (gmem) also set mr->ram = true. So don't know why
> > mr->ram = true for private MMIO is hackish.
> 
> That's exactly what I had on the question in the previous email - please
> have a look at what QEMU does right now with memory_access_is_direct().

I see memory_access_is_direct() should exclude mr->ram_device == true, which
is the case for normal assigned MMIO and for private assigned MMIO. So
this func is not a problem.

But I think flatview_access_allowed() is a problem that it doesn't filter
out the private memory. When memory is converted to private, the result
of host access can't be what you want and should be errored out. IOW,
the host ptr is sometimes invalid.

> I'm not 100% sure it'll work if the host pointer doesn't exist.
> 
> Let's take one user of it to be explicit: flatview_write_continue_step()
> will try to access the ram pointer if it's direct:
> 
>     if (!memory_access_is_direct(mr, true)) {
>         ...
>     } else {
>         /* RAM case */
>         uint8_t *ram_ptr = qemu_ram_ptr_length(mr->ram_block, mr_addr, l,
>                                                false, true);
> 
>         memmove(ram_ptr, buf, *l);
>         invalidate_and_set_dirty(mr, mr_addr, *l);
> 
>         return MEMTX_OK;
>     }
> 
> I don't see how QEMU could work yet if one MR set ram=true but without a
> host pointer..
> 
> As discussed previously, IMHO it's okay that the pointer is not accessible,

Maybe I missed something in previous discussion, I assume it is OK cause
no address_space_rw is happening on this host ptr when memory is
private, is it?

> but still I assume QEMU assumes the pointer at least existed for a ram=on
> MR.  I don't know whether it's suitable to set ram=on if the pointer
> doesn't ever exist.

In theory, any code logic should not depends on an invalid pointer. I
think a NULL pointer would be much better than a invalid pointer, at
least you can check whether to access. So if you think an invalid
pointer is OK, a NULL pointer should be also OK.

Thanks,
Yilun

> 
> > 
> > I think We could add another helper to create memory region for private
> > MMIO.
> > 
> > > 
> > > OTOH, IIUC guest private memory finally can also have a host pointer (aka,
> > > mmap()-able), it's just that even if it exists, accessing it may crash QEMU
> > > if it's private.
> > 
> > Not sure if I get it correct: when memory will be converted to private, QEMU
> > should firstly unmap the host ptr, which means host ptr doesn't alway exist.
> 
> At least current QEMU doesn't unmap it? 
> 
> kvm_convert_memory() does ram_block_discard_range() indeed, but that's hole
> punches, not unmap.  So the host pointer can always be there.
> 
> Even if we could have in-place gmemfd conversions in the future for guest
> mem, we should also need the host pointer to be around, in which case (per
> my current understand) it will even avoid hole punching but instead make
> the page accessible (by being able to be faulted in).
> 
> Thanks,
> 
> -- 
> Peter Xu
> 
> 

