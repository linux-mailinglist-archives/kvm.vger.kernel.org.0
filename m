Return-Path: <kvm+bounces-48627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B84ACACFBA9
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 05:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED67B1899B37
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 03:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FDB1E1C3A;
	Fri,  6 Jun 2025 03:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bBtLj6+G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5334A0A;
	Fri,  6 Jun 2025 03:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749180745; cv=none; b=uw6R9gigfZb3Id+G03xegkJ+wUoKsSDM8w2O2Id3bq/SGgA2XSbw0NgaSmE0ZOI6V17+3p19BYiIoUW0ewayLGKKdPGkVPBVgce2z7Jmsada8CDH3RpdSp+UwWA3hRAqGtfW+0/yjXjjUiZJrLI5VCfxYoPB9qS1zH9V0Y8fC9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749180745; c=relaxed/simple;
	bh=Qcz12GY2obmAahfa+Hf4viUpaHRcvM1vkETwyIXnzVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nJJPx/ePDTaa/iPJSumhTBiFvPd9Iq18PTaaJqhDDPaafHQOZ6d39pkZm12NOrp2deM9IdDzISSTMLuaqe8cRQvsftraLe95LvDywCz9KdmbMRkjG+THhdle/CCcOLUCKT9pk0DkC9VyZeD7g3llNPt1CYDCX0WSkMhuzVzaH/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bBtLj6+G; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749180745; x=1780716745;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Qcz12GY2obmAahfa+Hf4viUpaHRcvM1vkETwyIXnzVQ=;
  b=bBtLj6+G+KM9WWIWbB4mblwVOVF2RI7eOOLMcid7FfbjRRZ/c+3ZSC/j
   5ihXRnJmcECztOCISIH6FbBJoYYZ5U00f7fx3qLnEeefDQCpi6r3xdQeq
   HS5hFQlkWYzPCIKM5+O3h/i5zvnC1MzvPQ61zskCV/QIgbPGBOW5r4tJI
   9D3ZIYgXQr25NyEvQT6ZqG7ek9KBH48WM/Hsm0TjgdV9IZdfIvjZBFY5/
   7KipzjZuYun3aYkWz45NsgLmkIBYjqbnwr6FnZLgtZlxymDEo7nt00hah
   V0z5boK4nvvhhy7c8itbcTlY3O4kd4OWpJAA0MpBzHwBJI3TTd782lC66
   A==;
X-CSE-ConnectionGUID: 2e0jv3SURS20XdQUoSi38w==
X-CSE-MsgGUID: 6ESo2b8AQe687K3fcEoJcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11455"; a="51205003"
X-IronPort-AV: E=Sophos;i="6.16,214,1744095600"; 
   d="scan'208";a="51205003"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 20:32:24 -0700
X-CSE-ConnectionGUID: +lkkTJKXTyuykVQI6XdC0g==
X-CSE-MsgGUID: Fs5aCXcMTN+tx2jIxltA5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,214,1744095600"; 
   d="scan'208";a="149541684"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 05 Jun 2025 20:32:17 -0700
Date: Fri, 6 Jun 2025 11:25:36 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	dan.j.williams@intel.com, aik@amd.com, linux-coco@lists.linux.dev,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, linux-kernel@vger.kernel.org, lukas@wunner.de,
	yan.y.zhao@intel.com, daniel.vetter@ffwll.ch, leon@kernel.org,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com, linux-pci@vger.kernel.org, zhiw@nvidia.com,
	simona.vetter@ffwll.ch, shameerali.kolothum.thodi@huawei.com,
	iommu@lists.linux.dev, kevin.tian@intel.com
Subject: Re: [RFC PATCH 19/30] vfio/pci: Add TSM TDI bind/unbind IOCTLs for
 TEE-IO support
Message-ID: <aEJfsFxVxXTDIucc@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-20-yilun.xu@linux.intel.com>
 <yq5aplfn210z.fsf@kernel.org>
 <aD24r44v0g1NgeZs@yilunxu-OptiPlex-7050>
 <yq5ajz5r8w6p.fsf@kernel.org>
 <aEFmPaYorqaYCKBY@yilunxu-OptiPlex-7050>
 <20250605150916.GB19710@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605150916.GB19710@nvidia.com>

On Thu, Jun 05, 2025 at 12:09:16PM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 05, 2025 at 05:41:17PM +0800, Xu Yilun wrote:
> 
> > No, this is not device side TDISP requirement. It is host side
> > requirement to fix DMA silent drop issue. TDX enforces CPU S2 PT share
> > with IOMMU S2 PT (does ARM do the same?), so unmap CPU S2 PT in KVM equals
> > unmap IOMMU S2 PT.
> > 
> > If we allow IOMMU S2 PT unmapped when TDI is running, host could fool
> > guest by just unmap some PT entry and suppress the fault event. Guest
> > thought a DMA writting is successful but it is not and may cause
> > data integrity issue.
> 
> So, TDX prevents *any* unmap, even of normal memory, from the S2 while
> a guest is running?  Seems extreme?

Prevents any unmap *not intended* by guest, even for normal memory.

Guest could show its unmapping intention by issuing an "page release"
firmware call then host is OK to unmap. This for normal memory.

For MMIO, Guest implicitly hwo the intention by unbind the TDI first.

> 
> MMIO isn't special, if you have a rule like that for such a security
> reason it should cover all of the S2.

It does.

Thanks,
Yilun

> 
> > This is not a TDX specific problem, but different vendors has different
> > mechanisms for this. For TDX, firmware fails the MMIO unmap for S2. For
> > AMD, will trigger some HW protection called "ASID fence" [1]. Not sure
> > how ARM handles this?
> 
> This seems even more extreme, if the guest gets a bad DMA address into
> the device then the entire device gets killed? No chance to debug it?
> 
> Jason
> 

