Return-Path: <kvm+bounces-24391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97665954AD5
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 15:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01154B23787
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 13:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B145E1B8EA6;
	Fri, 16 Aug 2024 13:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bA9cXxnV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9608C1B86DC
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 13:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723814085; cv=none; b=JoNaSlRQdOw1V7iOgEoK5oijBnM2tkJ0XUaY2PEnVoC1ZorodtAmqhpp9Sl5+kk7Agerey2fWedU/rP8j234Tounl9/sm03CPIQDOAeVotMBQ4FL0pqqnKlLmFyqOztVDfo1q2vqDTNmX4yQ3ZhfMkwzdAMzrE1Ovtz0V1qegmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723814085; c=relaxed/simple;
	bh=Okg3+uwu0bCLZvjjHJ2snIchx4goVhonI4QHQBcac3s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DCsUUpD+t+5Xi7RNOyVkpQe3ZfhUhqk/vu0E0zLyV1CTifv9eldPw4Roc03OhjS2TzlOTHr8NU/FhFMBY68jDKtcg+ezjspKEcLdnb7PzRyxM3WBJaXC0HU6HIEtrBPGL09qGKtE4qgEVJOG8Yo/JcUkw+AuLiKrSZ3G69wP+DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bA9cXxnV; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723814084; x=1755350084;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Okg3+uwu0bCLZvjjHJ2snIchx4goVhonI4QHQBcac3s=;
  b=bA9cXxnVm0XZXMySrTr+qJgeE6JlrLZ5vw6iFIko1gn04rBPdD8bMmyj
   jUKgdLzjPuHbkwmbgnIDnMMmeReDNpZb8XdEPnVL16A+UrmWbruXEORyt
   oWVkoaA9ADQh6vcngyOaBUll7zzIxjmHVQWeP+zeSm1cyBkWsCYj0cfNw
   tecNilf7Moxhjl89zmeqdWvqfP4BqO5jnXYvYs+2CD9sHGiGsrXMScMFn
   WteKjUkNtemqWJLCCFRf3mA4Q3p5dGHmPjWLfKYtSguA9ipC9vgCwSIMj
   WMhQKPzPQ1NTok2+XsSJ+z+/Ns0/p4yl6bL5DZabqxA9yoYmubEXeM0O5
   g==;
X-CSE-ConnectionGUID: SnxhNZZlSy+FGZ29Jzn/+Q==
X-CSE-MsgGUID: exOGYvT/RQC4q+x4QbDdaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11166"; a="25866873"
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="25866873"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 06:14:44 -0700
X-CSE-ConnectionGUID: Gyua7FRbSE2nKtlIbaowgg==
X-CSE-MsgGUID: y6hKpDWTRJeNvbjkGWhTQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="64616054"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.125.248.220]) ([10.125.248.220])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 06:14:40 -0700
Message-ID: <215647fb-5aec-48db-9e09-5034dd19977c@linux.intel.com>
Date: Fri, 16 Aug 2024 21:14:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Yi Liu <yi.l.liu@intel.com>,
 "Tian, Kevin" <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Jason Gunthorpe <jgg@nvidia.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
 <20240814144031.GO2032816@nvidia.com>
 <b37a7336-36af-4ffc-a50f-c9b578cd9bda@intel.com>
 <6f293363-1c02-4389-a6b3-7e9845b0f251@amd.com>
 <8a73ef9c-bd37-403f-abdf-b00e8eb45236@intel.com>
 <f6c4e06e-e946-489f-8856-f18e1c1cc0aa@amd.com>
 <20240816125252.GA2032816@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240816125252.GA2032816@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/8/16 20:52, Jason Gunthorpe wrote:
> On Fri, Aug 16, 2024 at 05:31:31PM +0530, Vasant Hegde wrote:
>>> I see. So AMD side also has a gap. Is it easy to make it suit Jason's
>>> suggestion in the above?
>> We can do that. We can enable ATS, PRI and PASID capability during probe time
>> and keep it enabled always.
> I don't see a downside to enabling PASID at probe time, it exists to
> handshake with the device if the root complex is able to understand
> PASID TLPs.
> 
> SMMU3 calls
>   arm_smmu_probe_device
>    arm_smmu_enable_pasid
>     pci_enable_pasid
> 
> So it looks Ok

I made a patch for the Intel driver.

https://lore.kernel.org/linux-iommu/20240816104945.97160-1-baolu.lu@linux.intel.com/

Thanks,
baolu

