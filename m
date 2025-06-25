Return-Path: <kvm+bounces-50644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 472DEAE804A
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 12:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC0271889B83
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 10:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C4272D5436;
	Wed, 25 Jun 2025 10:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GMrhQOFE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A538D29E103;
	Wed, 25 Jun 2025 10:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750848768; cv=none; b=tUmmPW9Af3Y4nsI0DE0OWFAaIAMb1YzlocvP5dWi8D4CwAOL9kfpn+b5Jkbb/yo+8VCO29HNdp6pMAK3hq5C7IdvQg4b9g/93uX9VHaAXY3CGuv+1lZCu6qteSNryy4xRZFybu212CItO38+HIkIURWGsFdy0DiW7Ps2iFDLoR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750848768; c=relaxed/simple;
	bh=L2E1mHlLHz7wbD1s3c/UvvxtaaMR/FMov2jR+AourPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WyWG24r8zGL5xgOI3insY8DwF7JT2+fw9WcbYrZzb5VawzhDPcrne9Bxq/Dgb3kcXKYSIVjFL//daVhbs21Kzkb228Km+oW9sk+E0sTt8iV66Ue3hieSMcQmhuU/uJIQ3eIXgEgIoVZP5uxNDkEnPwGNUC8r9Lt2Cf/G7EwmLJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GMrhQOFE; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750848767; x=1782384767;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L2E1mHlLHz7wbD1s3c/UvvxtaaMR/FMov2jR+AourPo=;
  b=GMrhQOFEicb8altn3mGUaVAKKDR3cfJzVgoVw6yzlus8ZefB483/x00d
   xvAPLdpyq+/JJjOZzo90gXrwycnXSoN/WPLs1IC1GPZK68Ttj2zeTATF0
   XaHa4d+rtfvleBdBgIxcsdYT3ML9Sf2noszZ2J9V8yqMZO9mclOt8FLWO
   DMmM4QGWYcne2MUhc42OwEpxQB2c/zi5J6jxy0vr5uEZ/HjC2xTov0kzY
   xbF2HmdBoJ3JHrSn8mxLxhyQACt1b5I/qcBDRi1pGa6/xA4XoHwaEg5V9
   gH8tl77RYg1oCwv79C9no8eUxf1duNM4/39EhpoXtGh4v802rSY6r6RFc
   Q==;
X-CSE-ConnectionGUID: HrwcsdjPTb26dsXhRyQu7g==
X-CSE-MsgGUID: rLNn5fx2Q/WY2HpLjGyWIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="64172256"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="64172256"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 03:52:46 -0700
X-CSE-ConnectionGUID: WvY+25yWSNy9ZVBI9nCQAQ==
X-CSE-MsgGUID: Srouzp+WTZKyngVqfHLDdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="183073412"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 25 Jun 2025 03:52:40 -0700
Date: Wed, 25 Jun 2025 18:45:03 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com,
	linux-coco@lists.linux.dev, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com, yilun.xu@intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, aneesh.kumar@kernel.org,
	iommu@lists.linux.dev, kevin.tian@intel.com
Subject: Re: [RFC PATCH 00/30] Host side (KVM/VFIO/IOMMUFD) support for TDISP
 using TSM
Message-ID: <aFvTL6MUkVZrPoBS@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <e886855f-25cc-4274-9f11-fe0e5b025284@amd.com>
 <f5958bda-838a-4ed6-84c6-fef62cd0b28f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5958bda-838a-4ed6-84c6-fef62cd0b28f@amd.com>

On Sat, Jun 21, 2025 at 11:07:24AM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 11/6/25 11:55, Alexey Kardashevskiy wrote:
> > Hi,
> > 
> > Is there a QEMU tree using this somewhere?
> 
> Ping? Thanks,

Sorry for late. I've finally got a public tree.

https://github.com/yiliu1765/qemu/tree/zhenzhong/devsec_tsm

Again, I think the changes are far from good, just work for enabling.

Thanks,
Yilun

