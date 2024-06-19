Return-Path: <kvm+bounces-35632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97179A13564
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:33:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A2AD3A4913
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 08:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB541D5CE3;
	Thu, 16 Jan 2025 08:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FpbUqyUK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208931991BB;
	Thu, 16 Jan 2025 08:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737016375; cv=none; b=j1tUTEGo7GI+WqulOlrqnNk6w24aKxO4sg4okuD7mv8Wagrgi22IAoXmzLWiQ6AIogXblTPN0K+ZQ4pw61EpC3DI69w/3w+Bq7f9DF5ElrmnV7zzm6U3lEN+1GtGm2NzCjGaLUzGas8VQoj76V31UMdl0LtWjNnTuZugXu1a+jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737016375; c=relaxed/simple;
	bh=VGrWjvhJhhUTVfrWrN34OBRcBc2wi3Pd0KUwUFHy7HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxkPozW8rm+LQB4zHiZtAlMrwtzGlC4v42OR5NW8m9OAmowdi8tNyHFHoFROSl4vL78hL26O3eGrUY5Wq3I+q38ORnKt4tVlO6X1VayeX9wnIAuh7wfxaggTiayscQ9XSfTHGTqp86zcjum1k+aMln8JITKY4Cx3JRITmtg31Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FpbUqyUK; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737016375; x=1768552375;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VGrWjvhJhhUTVfrWrN34OBRcBc2wi3Pd0KUwUFHy7HQ=;
  b=FpbUqyUKLgNFG+nm4yXJRJDWyBwnf0z1xzDuLj9Z3J1Rc2u3Ltw1alVK
   PP+QQavVU5rkVuz/09G0G+2wR0HHKatirlmGHtVjxuLbegtpPyzV1Nsvt
   YdfvKLVmGH/1a/CKClV7DYe+r5nVbq+qFpvl0vlK3BGMmVFVEmUwxa5KT
   +AGUSWlkekrxiZU1tg8V0P2EwdEvd6KcUiGHLOm3YXy1zWxIyuE4Zay04
   f1Q5QkSt+24xj+V/7H5HoiejBlQW8Kv14s/oLT45VfhaTd3CN0pSKwnLf
   cJ3p2Ie9nVzTf58MWbUaGTPfp4X+TZLPZCbF+OrbC1AhoTSxlaxsx1yFC
   w==;
X-CSE-ConnectionGUID: 1QgLggWiTjut7nKEhpRSHg==
X-CSE-MsgGUID: uDgruy7WQwmwzXcimfQ5Wg==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="48782703"
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="48782703"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 00:32:54 -0800
X-CSE-ConnectionGUID: RHQ6cZtPQfClhhKO2tTqFw==
X-CSE-MsgGUID: eaHL4luvRdGgumdMQzCsTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="105178638"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa009.jf.intel.com with ESMTP; 16 Jan 2025 00:32:49 -0800
Date: Thu, 20 Jun 2024 07:39:36 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
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
Message-ID: <ZnNsOOqM4ziy2reV@yilunxu-OptiPlex-7050>
References: <58e97916-e6fd-41ef-84b4-bbf53ed0e8e4@amd.com>
 <Z38FCOPE7WPprYhx@yilunxu-OptiPlex-7050>
 <Z4F2X7Fu-5lprLrk@phenom.ffwll.local>
 <20250110203838.GL5556@nvidia.com>
 <Z4Z4NKqVG2Vbv98Q@phenom.ffwll.local>
 <20250114173103.GE5556@nvidia.com>
 <Z4d4AaLGrhRa5KLJ@phenom.ffwll.local>
 <20250115093234.GB6805@lst.de>
 <20250115133419.GN5556@nvidia.com>
 <20250116053348.GA24046@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116053348.GA24046@lst.de>

On Thu, Jan 16, 2025 at 06:33:48AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 15, 2025 at 09:34:19AM -0400, Jason Gunthorpe wrote:
> > > Or do you mean some that don't have pages associated with them, and
> > > thus have pfn_valid fail on them?  They still have a PFN, just not
> > > one that is valid to use in most of the Linux MM.
> > 
> > He is talking about private interconnect hidden inside clusters of
> > devices.
> > 
> > Ie the system may have many GPUs and those GPUs have their own private
> > interconnect between them. It is not PCI, and packets don't transit
> > through the CPU SOC at all, so the IOMMU is not involved.
> > 
> > DMA can happen on that private interconnect, but from a Linux
> > perspective it is not DMA API DMA, and the addresses used to describe
> > it are not part of the CPU address space. The initiating device will
> > have a way to choose which path the DMA goes through when setting up
> > the DMA.
> 
> So how is this in any way relevant to dma_buf which operates on
> a dma_addr_t right now and thus by definition can't be used for
> these?

One part of dma-buf is the fd-based machanism for exporters to share
buffers across devices & subsystems, while still have buffer's lifetime
controlled by exporters.  Another part is the way the importers use
the buffer (i.e. the dma_addr_t based kAPI).

The fd-based exporting machanism is what we want to dmaareuse for buffer
sharing. But we are pursuing some extended buffer sharing and DMA usage
which doesn't fit into existing DMA API mapping, e.g. for GPA/userspace
IOVA accessing, or IIUC other side channel DMA, multi-channel DMA ...

Thanks,
Yilun 

