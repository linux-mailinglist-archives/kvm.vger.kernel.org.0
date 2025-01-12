Return-Path: <kvm+bounces-35281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7ABCA0B47A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 11:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C984F1652C4
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F041FDA65;
	Mon, 13 Jan 2025 10:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MCzYeIGU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ACB235C12
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 10:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736763871; cv=none; b=d0ZHy425pA/hTnpr9qrtPM/g9kPX6GV8f7l90afB1ooNjVpWyWS0jhvghkgDkO4aG61tZZmBR9AQKzu0yLm3kL79ol30uNn1L9Dx48Q1guTbFLkcmYdMrpEBDsUetc2S9tz18OFWD/T4h0W16IhFkvr9wami/HlCv2badG9oM1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736763871; c=relaxed/simple;
	bh=F4qf+2lORgz1p+95k0zKTTdI+gT5PnvTukho1wgb1nM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2Lvdu1kEkF02Bc+u54njmjvRrMQLIM/8n93fnm7AsZg3huKPppMFQEiYhbnt1w0rgrJhLew7bjqjQo7kUcemfB+X/uke1As8KQMUucy31xdtzUsJhQ0hLT+m4mmkGdwg5zJRg4FiCmft/Tbrpdcw3MDm9LYPnD7g8SgtsYnr58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MCzYeIGU; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736763868; x=1768299868;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F4qf+2lORgz1p+95k0zKTTdI+gT5PnvTukho1wgb1nM=;
  b=MCzYeIGUxhFoJhB27A2QRjuG9EMXdxIM/+c9ZDNx1H+jYRzejdHKFI9K
   qEdWfZvkcdJx2Wf5/G+W4JFvDogWttFzpLg4zmbXd8C0dArIfU/dtM+f5
   yA5XMHoPq6WNLiJ7FmW/1hfTGvq4OsXNk5iDcsrVb7mVzpt5DLQCF4wRE
   LVDvC1aN/h5WXYhS4I4H8bEollUbUapMfaHFOoABV9dxc7AL2rIg6GTp2
   AMMcnWyskDFCrnHTW40ZNFt79gkYBVIN8Rit0y+Gg6CArpUvUvbY73rpP
   dBU0FXJU32Vk7XnFHtj8EonjBLQc7ukswkXc9vHNOSzuS03rUy5WGQFoj
   A==;
X-CSE-ConnectionGUID: sCBrPfMoReiyiZFRIywlaw==
X-CSE-MsgGUID: iwkagot8QdmbOdfPYbXVFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="37246120"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="37246120"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 02:24:28 -0800
X-CSE-ConnectionGUID: Rf+dTPLGTnCIgxLFGBw4Yg==
X-CSE-MsgGUID: EcR+H/ruS/OfAorpyr/i6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104946053"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa007.jf.intel.com with ESMTP; 13 Jan 2025 02:24:25 -0800
Date: Mon, 13 Jan 2025 06:23:18 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z4RA1vMGFECmYNXp@yilunxu-OptiPlex-7050>
References: <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <Z4A45glfrJtq2zS2@yilunxu-OptiPlex-7050>
 <Z4BEqnzkfN2yQg63@yilunxu-OptiPlex-7050>
 <565fb987-a16d-4e15-ab03-807bf3920aa1@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565fb987-a16d-4e15-ab03-807bf3920aa1@intel.com>

On Mon, Jan 13, 2025 at 11:34:44AM +0800, Chenyi Qiang wrote:
> 
> 
> On 1/10/2025 5:50 AM, Xu Yilun wrote:
> > On Fri, Jan 10, 2025 at 05:00:22AM +0800, Xu Yilun wrote:
> >>>>
> >>>> https://github.com/aik/qemu/commit/3663f889883d4aebbeb0e4422f7be5e357e2ee46
> >>>>
> >>>> but I am not sure if this ever saw the light of the day, did not it?
> >>>> (ironically I am using it as a base for encrypted DMA :) )
> >>>
> >>> Yeah, we are doing the same work. I saw a solution from Michael long
> >>> time ago (when there was still
> >>> a dedicated hostmem-memfd-private backend for restrictedmem/gmem)
> >>> (https://github.com/AMDESE/qemu/commit/3bf5255fc48d648724d66410485081ace41d8ee6)
> >>>
> >>> For your patch, it only implement the interface for
> >>> HostMemoryBackendMemfd. Maybe it is more appropriate to implement it for
> >>> the parent object HostMemoryBackend, because besides the
> >>> MEMORY_BACKEND_MEMFD, other backend types like MEMORY_BACKEND_RAM and
> >>> MEMORY_BACKEND_FILE can also be guest_memfd-backed.
> >>>
> >>> Think more about where to implement this interface. It is still
> >>> uncertain to me. As I mentioned in another mail, maybe ram device memory
> >>> region would be backed by guest_memfd if we support TEE IO iommufd MMIO
> >>
> >> It is unlikely an assigned MMIO region would be backed by guest_memfd or be
> >> implemented as part of HostMemoryBackend. Nowadays assigned MMIO resource is
> >> owned by VFIO types, and I assume it is still true for private MMIO.
> >>
> >> But I think with TIO, MMIO regions also need conversion. So I support an
> >> object, but maybe not guest_memfd_manager.
> > 
> > Sorry, I mean the name only covers private memory, but not private MMIO.
> 
> So you suggest renaming the object to cover the private MMIO. Then how

Yes.

> about page_conversion_manager, or page_attribute_manager?

Maybe memory_attribute_manager? Strictly speaking MMIO resource is not
backed by pages.

Thanks,
Yilun

> 
> > 
> >>
> >> Thanks,
> >> Yilun
> >>
> >>> in future. Then a specific object is more appropriate. What's your opinion?
> >>>
> >>
> 

