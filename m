Return-Path: <kvm+bounces-30594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 624BB9BC367
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92A0E1C21F40
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 02:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B9055887;
	Tue,  5 Nov 2024 02:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iPyXpq2l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D1F51016
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 02:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730775135; cv=none; b=CaawZYc/qK5VJ8qxFgBl+WKmt7DJdpjCV8D03dU4EpA1cOl2zVTxmNcZpW6MupsnjUz1qrOT70NpeoHrlLrtnIoUVfp7Io+9fyDV/WQN1G8v+nxHWAZHXkwGgNW+UEE1yR9+yreJHj0iV0tjmSgEcnL7UUwhecB2ofLghSKc7zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730775135; c=relaxed/simple;
	bh=/fne5fCFChojEHGlVra1bCqeCuKKR9purCKtH81mryg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MaHE8qvTNS2Lt+HYBAgagg5cTqlP+d9aNVO0bb3fT/lTEB30im5vPKuIfWPJ1ttT2k0QFSJr5osHyGn8qxlNyX5IDSKmLingRsVtOkcCgKUTpMUbrO+uEOrT9UnRLVaErXmbfDfXM2W5nB2r+XeCU1X+5ScsKMidrRaIHYWcl18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iPyXpq2l; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730775134; x=1762311134;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/fne5fCFChojEHGlVra1bCqeCuKKR9purCKtH81mryg=;
  b=iPyXpq2lRNKA0sTBGTWEyWnfkvSyzJDKRc0jMHy8H32r3ZxjzW0L3ngY
   lWQNIAfjWkrenRsmYvISKlsQC2IaOUjVovIbWhgXOKmyeve8i8H/FkR6v
   dEOvy8zi9Nybf4DtbSmVQpdLQaWxl6632ZFVSOrEvAXmpelIzZ9kcfD2y
   i8I3a6HoENp1neyDdhALcafrBArskeCQE9tbpB+zLmABJdTufis8SOWnY
   yHB1a4h+uLYez/JIXQkq52Qhn6vG5vK7IcI6TarSBsL22rOM3HfvqGtC4
   qgh61P4qPl/QoIU/euNQLGzaA08k/+ybXevwSBXWYTr5K6swjDwKapMek
   A==;
X-CSE-ConnectionGUID: TBDM9ERjQf2Gro48W0/uEQ==
X-CSE-MsgGUID: 9ZyW7iutR4CMN8zj96q6wA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30452392"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30452392"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:52:10 -0800
X-CSE-ConnectionGUID: M6k3pBrOR0SsCckXJ4RWvQ==
X-CSE-MsgGUID: X+wSg261T76MbUkolaWTMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="114644999"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:50:04 -0800
Message-ID: <63b941ed-4f46-47e8-9fdb-211b6413137d@linux.intel.com>
Date: Tue, 5 Nov 2024 10:49:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-6-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241104131842.13303-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 21:18, Yi Liu wrote:
> To handle domain replacement, the intel_iommu_set_dev_pasid() needs to
> keep the old configuration and the prepare for the new setup. This requires
> a bit refactoring to prepare for it.

Above description is a bit hard to understand, are you saying

... the intel_iommu_set_dev_pasid() needs to roll back to the old
configuration in the failure path, therefore refactor it to prepare for
the subsequent patches ...

?

> 
> domain_add_dev_pasid() and domain_remove_dev_pasid() are added to add/remove
> the dev_pasid_info which represents the association of the pasid/device and
> domain. Till now, it's still not ready for replacement yet.
> 
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/iommu.c | 90 +++++++++++++++++++++++++------------
>   1 file changed, 61 insertions(+), 29 deletions(-)

The change itself looks good to me,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

