Return-Path: <kvm+bounces-31361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 593989C30DE
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 05:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88BFF1C20AD3
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 04:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7A11482ED;
	Sun, 10 Nov 2024 04:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YL36fLIG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702EA41C94
	for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 04:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731212458; cv=none; b=Go4OSYxg8Qs+aSM2J3+lsr0YggG4rd+FOERTGDDsRHOcbWif4U+j+ERjCZg2kjoUXx/EJwsFD5zZpckx3t+/E5HA8QBzGFiFVWqKFqVV0x7sSFILmQT7KMTdeoqi7+TD7FWbD9EGms/b3vjwmUzeNwr/1bbL3K0F9ZMxgq6P0iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731212458; c=relaxed/simple;
	bh=qb7dr9Blg0E6VV7j4L+zvqKr+CvCxcahCt5fMVKT8Jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OqpIY6iQqJJzA84juhkOKVE5AuHqoMo+MUsIdoFs/rdyoi+C6tddbyVcMvsqbkOBIXdwHKsB2jgwmUe9YFOI7YmlLuI98krn4gZsSMLv2ePfcwu0UGJUuqS/HPEf5zzcx+4cqiHSfH/fvvWx4sXImrBmVl9kyGYwoMzNZdqtiL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YL36fLIG; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731212457; x=1762748457;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qb7dr9Blg0E6VV7j4L+zvqKr+CvCxcahCt5fMVKT8Jk=;
  b=YL36fLIGrAMiIkNkh7MLZIKlsN3K457r62fsanDNAZTDF1wqg5Pi7PJo
   cJNj6fHjf/9ve6G3mOGbr9X9YFD5yAd44orRAWFMqP6XkpOg4ymbjDvfu
   w3zzGcJd1FQIbPq4wEilokpa/LJggUAm8mrRJ+/UmFRefJwJWvUkXu7LH
   wNjuWGtBmBi+EtfhST+W7XTGL5t35wwNU/xpp+Ao4dUpqZBRZLxku1MqQ
   KQZMijU8pj78ltFOj8mZttA8ojFz2psZsZOj0w92tuBOkQEvphgRGgXlD
   9Oc8DIwyxjGyeDwM/kXjBDiXmPCAGDQBrxfDszFoKTCftFKjbHSDFRIgj
   g==;
X-CSE-ConnectionGUID: Ig2f0dIHR7mytFHZ2akbSg==
X-CSE-MsgGUID: wQrFM4j2Tl+N8SzJ8e7sfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11251"; a="48568194"
X-IronPort-AV: E=Sophos;i="6.12,142,1728975600"; 
   d="scan'208";a="48568194"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2024 20:20:57 -0800
X-CSE-ConnectionGUID: FxB0qan2QX2a8VsHGIg2ZQ==
X-CSE-MsgGUID: pBZ32nigQ92xBzTtUNnp5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,142,1728975600"; 
   d="scan'208";a="87095874"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2024 20:20:54 -0800
Message-ID: <af875e12-e960-48b3-a9a8-ce8fb28dc81b@linux.intel.com>
Date: Sun, 10 Nov 2024 12:19:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] iommu: Remove the remove_dev_pasid op
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, willy@infradead.org
References: <20241108120427.13562-1-yi.l.liu@intel.com>
 <20241108120427.13562-8-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241108120427.13562-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/24 20:04, Yi Liu wrote:
> The iommu drivers that supports PASID have supported attaching pasid to the
> blocked_domain, hence remove the remove_dev_pasid op from the iommu_ops.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Vasant Hegde<vasant.hegde@amd.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/iommu.c | 17 ++++-------------
>   include/linux/iommu.h |  5 -----
>   2 files changed, 4 insertions(+), 18 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

