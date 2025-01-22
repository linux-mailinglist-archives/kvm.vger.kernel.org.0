Return-Path: <kvm+bounces-36213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D93A18B00
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 05:17:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C8653AAC32
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 04:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7069816F271;
	Wed, 22 Jan 2025 04:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Avb8igKA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9402143723;
	Wed, 22 Jan 2025 04:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737519412; cv=none; b=Rw5SQUxIP2aVklSETBeV+4N+ZCRhJLzleGo9hCHzG1iVFf+6NLkEXkhiLM43RGlXul6i0Sf6wgJ/d9I5D6MIki4N2KrlwLtSmQXM/oTK6HozRyfzUCiQXfrAo4TT+eGiJecsoL3c4C1kfBznjnsQ+jRf96Kr2sUcvqe2gBaM9K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737519412; c=relaxed/simple;
	bh=7N+WkV4xK2RjWSHcvKvxuLDFZUiR1saedshugIKoqxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMiYo50zHQ9kvCI9ia3dGrfRbNo2RzzJk5DhaaHTlmXi7wmEY7RCxBKDx2HOh3wsuGN3wAvSglZbQaLxqtC9SRMtyuarJuOLnCMz2qg4HVWasKs3O1XoHLOfN/gndXLA7Pdpw3EdQwrZ9HrCEbXVAy4+9oczGBkYR0KPhFt55LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Avb8igKA; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737519410; x=1769055410;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=7N+WkV4xK2RjWSHcvKvxuLDFZUiR1saedshugIKoqxk=;
  b=Avb8igKAmsM9DbGnpiLnK5ucYFzzXFn5l+PJVp7PwJPUlyFvKPrV4JQF
   tQiL14W1ys/vw+/LHIMCMXI/Wg7ZwwmWzZxa+ffUhy3Gxb413SLt5z+ld
   qHU+VSugLF3oVUhbbuEskfXionywE6ygyQ3TSVhLn2pHvq2e4FEGutQAc
   ryXackXZxByR4N6nABg5MG2SaZdcb8eYRIK5/Obzjc4cVMVyVlFmWeUFP
   zJ9ifR4bGkatjiEOyn3T4DErZCgxpWXDmZzz1vq61LrSgldui3XH1w+Mh
   uexQ01eSiyvCW4VSI8uUbDWfHT36kd7D5lwwJChehtq2AF0ME7mvyC0OR
   Q==;
X-CSE-ConnectionGUID: CoS23vNTTcy/kHWVdRQnRg==
X-CSE-MsgGUID: JpcnN6cLTpynXnD1eyd9hg==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="38113818"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="38113818"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 20:16:49 -0800
X-CSE-ConnectionGUID: GBhLq0WwTheYgMhSQk1s5Q==
X-CSE-MsgGUID: 92navAJ9QACcQcn6tNGTrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="111994366"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa003.jf.intel.com with ESMTP; 21 Jan 2025 20:16:45 -0800
Date: Wed, 22 Jan 2025 12:16:35 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <Z5BxI3efmCPSpOSK@yilunxu-OptiPlex-7050>
References: <1afd5049-d1d4-4fd6-8259-e7a5454e6a1d@amd.com>
 <20250115141458.GP5556@nvidia.com>
 <c86cfee1-063a-4972-a343-ea0eff2141c9@amd.com>
 <86afb69a-79bd-4719-898e-c6c2e62103f7@amd.com>
 <20250115151056.GS5556@nvidia.com>
 <6f7a14aa-f607-45f9-9e15-759e26079dec@amd.com>
 <20250115170942.GT5556@nvidia.com>
 <5f588dac-d3e2-445d-9389-067b875412dc@amd.com>
 <ZnSm6ULbJbxOU27J@yilunxu-OptiPlex-7050>
 <0d77dc64-df9c-457b-af3b-ecfa49dac7b4@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d77dc64-df9c-457b-af3b-ecfa49dac7b4@amd.com>

On Mon, Jan 20, 2025 at 02:44:13PM +0100, Christian König wrote:
> Am 21.06.24 um 00:02 schrieb Xu Yilun:
> > On Thu, Jan 16, 2025 at 04:13:13PM +0100, Christian König wrote:
> > >     Am 15.01.25 um 18:09 schrieb Jason Gunthorpe:
> > > 
> > >   On Wed, Jan 15, 2025 at 05:34:23PM +0100, Christian König wrote:
> > > 
> > >      Granted, let me try to improve this.
> > >      Here is a real world example of one of the issues we ran into and why
> > >      CPU mappings of importers are redirected to the exporter.
> > >      We have a good bunch of different exporters who track the CPU mappings
> > >      of their backing store using address_space objects in one way or
> > >      another and then uses unmap_mapping_range() to invalidate those CPU
> > >      mappings.
> > >      But when importers get the PFNs of the backing store they can look
> > >      behind the curtain and directly insert this PFN into the CPU page
> > >      tables.
> > >      We had literally tons of cases like this where drivers developers cause
> > >      access after free issues because the importer created a CPU mappings on
> > >      their own without the exporter knowing about it.
> > >      This is just one example of what we ran into. Additional to that
> > >      basically the whole synchronization between drivers was overhauled as
> > >      well because we found that we can't trust importers to always do the
> > >      right thing.
> > > 
> > >   But this, fundamentally, is importers creating attachments and then
> > >   *ignoring the lifetime rules of DMABUF*. If you created an attachment,
> > >   got a move and *ignored the move* because you put the PFN in your own
> > >   VMA, then you are not following the attachment lifetime rules!
> > > 
> > >     Move notify is solely for informing the importer that they need to
> > >     re-fresh their DMA mappings and eventually block for ongoing DMA to end.
> > > 
> > >     This semantics doesn't work well for CPU mappings because you need to hold
> > >     the reservation lock to make sure that the information stay valid and you
> > >     can't hold a lock while returning from a page fault.
> > Dealing with CPU mapping and resource invalidation is a little hard, but is
> > resolvable, by using other types of locks. And I guess for now dma-buf
> > exporters should always handle this CPU mapping VS. invalidation contention if
> > they support mmap().
> > 
> > It is resolvable so with some invalidation notify, a decent importers could
> > also handle the contention well.
> 
> That doesn't work like this.
> 
> See page tables updates under DMA-buf works by using the same locking
> approach for both the validation and invalidation side. In other words we
> hold the same lock while inserting and removing entries into/from the page
> tables.

Not sure what's the issue it causes, maybe I don't get why "you can't
hold a lock while returning from a page fault".

> 
> That this here should be an unlocked API means that can only use it with
> pre-allocated and hard pinned memory without any chance to invalidate it
> while running. Otherwise you can never be sure of the validity of the

Then importers can use a locked version to get pfn, and manually use
dma_resv lock only to ensure the PFN validity during page table setup.
Importers could detect the PFN will be invalid via move notify and
remove page table entries. Then find the new PFN next time page fault
happens.

IIUC, Simona mentions drm/ttm is already doing it this way.

I'm not trying to change the CPU mmap things for existing drivers, just
to ensure importer mapping is possible with faultable MMU. I wanna KVM
MMU (also faultable) to work in this importer mapping way.

Thanks,
Yilun

