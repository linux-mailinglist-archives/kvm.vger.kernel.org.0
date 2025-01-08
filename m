Return-Path: <kvm+bounces-34863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B56F9A06D55
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 05:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0685164C6F
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 04:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7793214239;
	Thu,  9 Jan 2025 04:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gnGKSany"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58AC1AAC9;
	Thu,  9 Jan 2025 04:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736398748; cv=none; b=WjEWxa34icINGdxZvJTBBLSpBjSHnmiLKwebwnJDlbzqCf1r+tegRDg32Eo+T8pQ877GAYlZR3DGT/iRvR8cQJ2O4WjiMWBiY5xLcbHk6XfSWgr0wjRhBz+cNACKwSXtddlprDSYn7gPMXpZigD4SOPIQ33pxxgZ1Gua95PTYBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736398748; c=relaxed/simple;
	bh=hTsQuirja3kP5fdTsWRC1+w6gEXwh2kLQxBcBcrjnGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K0+sSN8jprlw1z3HlVBfeLVV21W6nFuMzNI4R6ppl/e7vgxoLhpIpHUsAG9hzTqKpXneVcuyVR77EG7fmGr/SCRA6ud6CvCd9BEpU3u47RJZsIXJYfZ02M5Snu6btsf6MIF9IvZ16Hz9g1VG//l5GsJs4tCNNehOgRlE0DmkUb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gnGKSany; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736398747; x=1767934747;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hTsQuirja3kP5fdTsWRC1+w6gEXwh2kLQxBcBcrjnGc=;
  b=gnGKSanyOXKy0U+d+/2347yok0CmmCq+vFRycO7GW7z7BbABx5UECxzY
   hNq+kSYKoF062Xyc/e8pBRkL9EshhOCsgoEIIX49jIYH8fyzP8vosbcRT
   m6gQWZ/UdnteZXjEQAMq3irD73ycWbvZFIEcLO4Km1MXHaCmtFjMLXmoS
   5ZiFFozl7UctnHp08e2K3CNamfiWxgLoZhCx3Hw5SIFh5W9LoDDGfqtIo
   J5avcItPoh9256IsnBXUalynKAStdwpIvLmuWFxeBZZhzHK/2Agt+bsj3
   9nhJ22C9NbWV+9r4Fu9excFzekRQ1B85OvagX6kZXDDWeoE0l8ownhucZ
   A==;
X-CSE-ConnectionGUID: xjWePMbFQvyHshgMIVoLZw==
X-CSE-MsgGUID: cvA7iiVjS3qURTlBUy/3VQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36544353"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="36544353"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 20:59:05 -0800
X-CSE-ConnectionGUID: Bqdvx8OPQBunJyDfrdjsLg==
X-CSE-MsgGUID: wzJdr5qoSB2owTRZBfIIug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="126591019"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa002.fm.intel.com with ESMTP; 08 Jan 2025 20:59:00 -0800
Date: Thu, 9 Jan 2025 00:57:58 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
Message-ID: <Z36ulpCoJAllp4fP@yilunxu-OptiPlex-7050>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
 <20250107142719.179636-9-yilun.xu@linux.intel.com>
 <20250108133026.GQ5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108133026.GQ5556@nvidia.com>

On Wed, Jan 08, 2025 at 09:30:26AM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 07, 2025 at 10:27:15PM +0800, Xu Yilun wrote:
> > Add a flag for ioctl(VFIO_DEVICE_BIND_IOMMUFD) to mark a device as
> > for private assignment. For these private assigned devices, disallow
> > host accessing their MMIO resources.
> 
> Why? Shouldn't the VMM simply not call mmap? Why does the kernel have
> to enforce this?

MM.. maybe I should not say 'host', instead 'userspace'.

I think the kernel part VMM (KVM) has the responsibility to enforce the
correct behavior of the userspace part VMM (QEMU). QEMU has no way to
touch private memory/MMIO intentionally or accidently. IIUC that's one
of the initiative guest_memfd is introduced for private memory. Private
MMIO follows.

Thanks,
Yilun

> 
> Jason

