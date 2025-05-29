Return-Path: <kvm+bounces-47984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F51AC7FE0
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 16:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E25D54E74BE
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 14:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940D822B8D2;
	Thu, 29 May 2025 14:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HMO06GfX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B67B1D54E3;
	Thu, 29 May 2025 14:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748530061; cv=none; b=B0MBSGJB2PYDX3/HPd2EHZeZZhFJ/phB/6teuuwnJfWw0RHaeC2JvZ1cgWPcndy8WD9x/e16ergA5PZKuMBcgjJPBs+J8htD7w8ZPXd7xDZIRyHj+JP9d00fPo24bSXXy1wjntxuiPE14Efu5C9BKBm3pgcVf2ltaP968TIdrfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748530061; c=relaxed/simple;
	bh=kEjzFkO+XU4YWTcwrv0cEo/Sjcef1XQplfcw8JrSKxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZbTp4lACPxsyOiqm1+XGHAmaqKSL+5lHduxU0svU+vT/eYtl26slWy9oKupjeVbSSYM3vjEKTOry0opty0fJFotw2eYReRhgE3KefZFHN3EaunQhM/RHDTaSl44vNliswazzobG5FgmLEEGH24B/Pok+krKtZmkpXXDp2gDIP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HMO06GfX; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748530060; x=1780066060;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kEjzFkO+XU4YWTcwrv0cEo/Sjcef1XQplfcw8JrSKxU=;
  b=HMO06GfXHU0cMRvm1edpZFoFOn8DQgjvvWfKaiXVPsQEchVYPxjLGWcr
   5FEiDWa2VdiUM8gsRu38DQ2Av1AUwfdPkQefi0Mgd7Uzz2CuTRRvtCByU
   RMfFa4eWggce2Fot4M9xHi4QX5ceXfvmrj+18kC0TlgtlVh+zmbOvr5UE
   G7heSH0Uyy6lLQ9w6Snu0ltto1IjChJQ79RuJZ+GiseYutRHKOefntvaz
   B9lrMnZcjGOxVpkeS5wNI0QM8aQZca/XzkmI1g1NBys9HIe6D31nr0C3E
   dQFRaixYUVXvQpkjLsrZnhqX0dVRKHpu6uLibhxJEHGJXJ7JPFFBadFWo
   A==;
X-CSE-ConnectionGUID: y29a8GFNSEipct84UJS8mw==
X-CSE-MsgGUID: bhujHordR5SE15kBo+7eQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="49840886"
X-IronPort-AV: E=Sophos;i="6.16,193,1744095600"; 
   d="scan'208";a="49840886"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 07:47:39 -0700
X-CSE-ConnectionGUID: 8v9maovfSSmE7dB+aC69nQ==
X-CSE-MsgGUID: WkireV+rTKS43Kq0z8SZxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,193,1744095600"; 
   d="scan'208";a="148621109"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 29 May 2025 07:47:34 -0700
Date: Thu, 29 May 2025 22:41:15 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
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
Message-ID: <aDhyC73r149syMpc@yilunxu-OptiPlex-7050>
References: <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <aCRAHRCKP1s0Oi0c@yilunxu-OptiPlex-7050>
 <20250514163339.GD382960@nvidia.com>
 <aCYQdDrYYZRAgsen@yilunxu-OptiPlex-7050>
 <9dea400f-a57b-43be-a2e4-24a9f51e6ba0@amd.com>
 <aDE5SPzOAU0sNIt+@yilunxu-OptiPlex-7050>
 <ae16db07-5fca-4369-aa67-cbe2e0fd60fd@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae16db07-5fca-4369-aa67-cbe2e0fd60fd@amd.com>

> > > > 
> > > > FLR to a bound device is absolutely fine, just break the CC state.
> > > > Sometimes it is exactly what host need to stop CC immediately.
> > > > The problem is in VFIO's pre-FLR handling so we need to patch VFIO, not
> > > > PCI core.
> > > 
> > > What is a problem here exactly?
> > > FLR by the host which equals to any other PCI error? The guest may or may not be able to handle it, afaik it does not handle any errors now, QEMU just stops the guest.
> > 
> > It is about TDX Connect.
> > 
> > According to the dmabuf patchset, the dmabuf needs to be revoked before
> > FLR. That means KVM unmaps MMIOs when the device is in LOCKED/RUN state.
> > That is forbidden by TDX Module and will crash KVM.
> 
> 
> FLR is something you tell the device to do, how/why would TDX know about it?

I'm talking about FLR in VFIO driver. The VFIO driver would zap bar
before FLR. The zapping would trigger KVM unmap MMIOs. See
vfio_pci_zap_bars() for legacy case, and see [1] for dmabuf case.

[1] https://lore.kernel.org/kvm/20250307052248.405803-4-vivek.kasireddy@intel.com/

A pure FLR without zapping bar is absolutely OK.

> Or it check the TDI state on every map/unmap (unlikely)?

Yeah, TDX Module would check TDI state on every unmapping.

> 
> 
> > So the safer way is
> > to unbind the TDI first, then revoke MMIOs, then do FLR.
> > 
> > I'm not sure when p2p dma is involved AMD will have the same issue.
> 
> On AMD, the host can "revoke" at any time, at worst it'll see RMP events from IOMMU. Thanks,

Is the RMP event firstly detected by host or guest? If by host,
host could fool guest by just suppress the event. Guest thought the
DMA writting is successful but it is not and may cause security issue.

Thanks,
Yilun

