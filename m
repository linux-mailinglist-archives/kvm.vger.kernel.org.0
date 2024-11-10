Return-Path: <kvm+bounces-31358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D808D9C30DA
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 05:09:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EB45B20F54
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 04:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDA61482E6;
	Sun, 10 Nov 2024 04:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BPjNI9yj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F02847B
	for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731211755; cv=none; b=hMUT7rN+GoZgj2D7tOuBKvBZRch40fmeQh+17h+QMls0dUtPFpHwMJaI88li5ckrnpuC4r61gW6hqJM0JXyGD1I/8161NsRGS0HFTp7ioFjLBmzIUFGYWaPx3W2EeU28odTXh/rzhKQYyoz02BY8N9jDN+BX6V2KKaJOe5cox+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731211755; c=relaxed/simple;
	bh=0m4G8wid9HQTY/HDuTEaCuW28rl1xrPM09B1xOR002Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fk/Bbw8qfkmL6Z7dRj2pyfTZfT9wBdp5UPWH5oYSpjocA1I1jVhi8cdHNzq7/tWPrgG8qEB6KZyN/0ECBU22rl6bVBdN3aB6j16PBlaDDj/BGmi9sgtGDYAX/YjFf27F7VosfvH1lKVVOf0nn+/q/JUa8QIzvFiQ9x+P2Gy6r9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BPjNI9yj; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731211753; x=1762747753;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0m4G8wid9HQTY/HDuTEaCuW28rl1xrPM09B1xOR002Q=;
  b=BPjNI9yjShaSxigm7OIY6s0q75W2wl3LurSTF1UTFOzY6UKmBkaM38FT
   ir9RdrwICKvRfMSwvWyuaMSfgAYJz+lXY29wjsmigy2GIpKehbpcABRfU
   OqplTEREeR2m4c5WVYTPyUu5+ar8DQexUkIPV+pmiSZR7Rj+pdhVwz6ZU
   QF32lgyo89sz31wonCfoRVLbQKSaBHNeMzm5hnOFDGXVIXLjKzveWVNEQ
   C1pHwJctXGOBdixdi41S3l6CPD4fuRnLL41/8MSR6tg28231LohDad5Ax
   F+Gp3AgsLFJ4/PYHTHOtzMXLaXJaI5b8vy7HZFgSxvcE1yTTx3LlpLNyr
   A==;
X-CSE-ConnectionGUID: zUi4UHCkS5iMDRo4PeP6PA==
X-CSE-MsgGUID: 0sTUKXEHSgKCbh/vmMSoxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11251"; a="48567910"
X-IronPort-AV: E=Sophos;i="6.12,142,1728975600"; 
   d="scan'208";a="48567910"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2024 20:09:12 -0800
X-CSE-ConnectionGUID: Je9ck4oAQzKdlTA++1svxQ==
X-CSE-MsgGUID: zlNpK7kLTNeAZd6/5EyLFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,142,1728975600"; 
   d="scan'208";a="86369526"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2024 20:09:10 -0800
Message-ID: <559ae236-c0d7-42e2-8df2-97c073f729e9@linux.intel.com>
Date: Sun, 10 Nov 2024 12:08:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] iommu: Consolidate the ops->remove_dev_pasid usage
 into a helper
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, willy@infradead.org
References: <20241108120427.13562-1-yi.l.liu@intel.com>
 <20241108120427.13562-3-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241108120427.13562-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/24 20:04, Yi Liu wrote:
> Add a wrapper for the ops->remove_dev_pasid, this consolidates the iommu_ops
> fetching and callback invoking. It is also a preparation for starting the
> transition from using remove_dev_pasid op to detach pasid to the way using
> blocked_domain to detach pasid.
> 
> Reviewed-by: Vasant Hegde<vasant.hegde@amd.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/iommu.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

