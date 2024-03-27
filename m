Return-Path: <kvm+bounces-12863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 587F988E670
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CD4E1C219CC
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA284F208;
	Wed, 27 Mar 2024 13:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aA9OggdS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B3D12F39E
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711544953; cv=fail; b=eGUL0DO2jSVb0g0hlhcSw6oHW54kz8gfwg84fYKvaBp8xEm2hQbi//Mh6kIHbO/xFfeLG270XIQT0Pr4YeOFHVIQvPm4G0Xt9tKVMRHlsYvygqliUqMg5aUoVnu26Q/PBLBZAWsm3UhfjBabcwYRowHnUrvFhzY1GibSv1G5VG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711544953; c=relaxed/simple;
	bh=/ZSUUfoOM6ylKykt7Ax65BLeJ67GG+kXlnxeNHglxYs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AKxKtTcWqsbsAyoaNauje9nFu0/0PXXmljP6wIQkz/v/sLSWGciRtLvaMStzrhCTswGuD+83G/ECJ0ruGlHPc6+c5YS/UZF9TT3l+5NGu9pXl2l/vCnjIdKhuqPSmrhtBiX+fqH25g+Bvw4hDSXFLR6Fs/w4ZuGbXIwHV2mfiRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aA9OggdS; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711544950; x=1743080950;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/ZSUUfoOM6ylKykt7Ax65BLeJ67GG+kXlnxeNHglxYs=;
  b=aA9OggdSgq6E0feItfee1j+ChOI+A+AUFktEG17S+Oxctao45pPBgB01
   /OT46IW4edheZMFaC+fK9VsEIUZoLllBvusT9jekQUOLh3/EdUTXnNFxr
   Fvxmj1CdqcvjSJJvnJB0uJNXYscXq7YlSr6sA3VMTurZHu0m/o6k7/N5w
   37ciEBQaM4kIVJ/BjAeNmxdKRqB7jgDht0CcB7uNe9vBJo1RX4EERYRH4
   sOXoOX690V31SelSmh/B+fuKSHDsqBS+Ogbz7kA0Re3K8p0QxKoYaJ9+F
   j6bLbTdxVR/QPHtN2RPsDsG5etuCCKOBSvNppfjfl7UqJs9zE8k+/YOol
   w==;
X-CSE-ConnectionGUID: bDPE5L5kT0SLjfJBLnjbjg==
X-CSE-MsgGUID: 743g707oQgqXn6wNsAXR5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="24133474"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="24133474"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 06:09:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="20817373"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 06:09:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 06:09:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 06:09:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 06:09:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qqbe6qcJrAXssqbEuhHsKwZQZkiQqr/RHlqrbmrJpTCARjFd1wf7m9Dq5aI43nbVgZf5cZuDBbDBgysAWv5CF7in0V5B1nyDz3CrbInJuVd8NHOgfIxhokqdBHKx9mkIBxiClSawTmcnSCS+xQ8DwCrHzWdAnngyfvjPcGFt5n5nOtH5FtkPPZdvYU5Rkp2pDL3B7zMyroQ4Ierg56dlp1Eaqyu1bJ7CjHQlOeFX7CGDkpJyaYlHH9BCRvLDTYPo6aYiq43mNb+AB9wxQQ6US1NSn9iraWeKHJ86wGMsTAbceKKkcZHqhPkxjVk9VQb/v72HDTYXMNx0otJaSOJLcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NhFL2wQN5KDB8DQpF2NrPoqP74n+zzzngumvO+Eg0Uo=;
 b=QQGus9heSpd1wLM17ms+F14CoeHHa45kE5kA0UtUkx7Bc7yHbIN48P8hZjcS5Vscj9CrU0XCQnPfcpvcX9X+c4CNM848ixeq8ry5jodqiSnfBYK58fKRwNWQg/DeYfRBje2DnqMwe4H5BEjLUvaURtrBYpJeebbFyQx1NiJEOSlo01bU/Sfs1j9NIFcyQiAqGRNEMQzkjSNyToaprYLGZ3ZmfFnNebeZ82dG2TkOMn0cQu3YK66Cjlcp8HBgltNt1p2LAndKS0GDyrimRsgtVdtQ3b8+F5z1g1VKYi+cyNWmmibJCJd4+zzyWA2dVCWVcozZqUW7PQryxs2z4RqRXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ2PR11MB8539.namprd11.prod.outlook.com (2603:10b6:a03:56e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 13:09:06 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7409.028; Wed, 27 Mar 2024
 13:09:06 +0000
Message-ID: <f9b6fe1e-d671-47f0-ba57-ea600b736611@intel.com>
Date: Wed, 27 Mar 2024 21:12:34 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] iommu: Undo pasid attachment only for the devices
 that have succeeded
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
 <20240327125433.248946-3-yi.l.liu@intel.com>
 <20240327130501.GF946323@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240327130501.GF946323@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0041.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::10)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ2PR11MB8539:EE_
X-MS-Office365-Filtering-Correlation-Id: 76f25d27-e775-4cd4-4f78-08dc4e5f14c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Irget6GYoDLtLNuoyRCWLeKLwCPzSu12XU9vGB1avEyxXDQQ/qB/eIQ8Q0CwjJODAWQb9F5/UcJpKTSSmP46pjK2CpeOvrBjVQrdRq9hxo3I4w7kcebpwLa8D+MIjcuGmdEX4eSK6jhpolFp9MFCCqOW3ivPeMjZiEZ4V3XW3v8Z1kppX0pBoGeEsj2wPaeb/hWxIJFe01VmrkvlX/jeBHD+kjwnOfuzAhFCdyaOCFMU4dqQYxNfINpOU/a4TqY9Pn261ubUdEfgCIHJUjp1eMNm67Ej8305oKjHDgbSgFOqmQeqqWwM/UYfUR1D27u1qzJH5Gf4QEFSLJ0KElUhAOfHwkXdTSm8AcRjEEE727qAqtD7JylI3KcY+gE4ATRWM4inALe0FaUrnZV1VAhDVTsWsBDSo94W/5/JkEAlaPB3O/p7pDZdrC6jbZGR2+QaWfLTXz2zUaTn26m7SjHNGgRan8LkXPzPqaR73cPRg40Rwvvchp9lGmWXLTxWeyjQ+jm4JY8QLs0Qz1i59n4/GyGmLZ1R9VpKn985uZxt5mY7QSUuzFb2+i2dLA7qJB125US3109USMJWAdeo0V/QYDGIBdso/J9aFkY0n78Q4kqlklVfSK4MhpjxN+hO/6osrxbismevYNubpun8cbBE3DN8WBHnqoxd/Lmhazl1oOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWtvS0d5dFFHYXNqRkF1RXBSN29kWkExblR3KzRMZVcvUS9kS3BZcTVXbDQv?=
 =?utf-8?B?QTlQSW5mbDJTVGhUdlZQVmZwUHNTY1lyU0Z5czdlZmQ1SFFobmZWWnpZVkg4?=
 =?utf-8?B?a2EzMThyNTBHSk80WVpBdjNaeGZFQ0haZ1kzRElHQ2ZubXF0SHRqdW43U1hH?=
 =?utf-8?B?YVVnRmowVmZCdWNqNHFNRXZTMmRhZzR4cFpIa2ZkWFZCZVpsVTEySWVLTEhQ?=
 =?utf-8?B?NjA4azBsd2dtMklSSmwxNmd6T2JiNXJjRzdvUmUzZDdIZmFPaDgweFlKdU9O?=
 =?utf-8?B?ZXZPZmtXUGdnYlZXY3g1SEQxZEI5MzZ3dFZHdS9ncDNzRGFRUDZjZkJMOHNK?=
 =?utf-8?B?WjBTT3ZURE5rbWpmWVprNXhZV1VxM3BFWklHaFNUMTBMc3JzV3lZdWVZOXZW?=
 =?utf-8?B?aUxRYWFIcUFjeUtDUGlMTVFrRGNONzU1dVR2SkRWaXRCZGVqaVZDaWEvYWtD?=
 =?utf-8?B?SFozbERUNml4STlyYmRpMWM2UjZReldzNmx5V1ExRmZac3phZDAxb3dUQ0Vp?=
 =?utf-8?B?TlFaa2l1QTVnQkhhbFVZRVVhS01TQXJrSUhaMkJRbGxEWGoyTnFURDhEQ2tM?=
 =?utf-8?B?QUpDNkNraXQzTzBXSGdkZHFwb2tRZEtWWGVRWXBhbnRBMFRydHhhUXh1TFdW?=
 =?utf-8?B?WGNDYXEvNEt5cUxoSnF4eFZndkJid3hjUUlEN3NwUENFSEsxTEkyUEhEYS84?=
 =?utf-8?B?ck9VUUVqZlRGaHQ3dlRrbVgwYUFWOEl6dkpBbjVMS2MrbG1mN1lFZnNYRUhx?=
 =?utf-8?B?WDZSQlBjWlpuaDJ6Z2lDQVVsRnhpVXl1bXIzY1VpMTNnVTBuQ3d3VnpSVnNO?=
 =?utf-8?B?bUM1VC9KdzdnTXg4TW1wb0UxejhsTW9iZE42SmRPV1JydjVkRVZXM1ljRmw1?=
 =?utf-8?B?MUlNQUVPVVF3OFdNTWZiZTdZcm4wTGVXU2RUNFVQRDI3ZzBUMm1ZVUgwUjBJ?=
 =?utf-8?B?RDg4M2QwQjZ6bm5Rak50dWFWZDJhQmcrcXpvazRHeVR3cXBPUmo3RUpIaWEz?=
 =?utf-8?B?WFpwQ1dMdy9MSERXbU1FRjRacUFPdzVEZUtvRmJYYm1OQ0R5aXJBeWlpNENS?=
 =?utf-8?B?d28yNVlCTFNvUWl1YjFPU2g4ZENyaitDUVNHUCtPemRvSE1sZzVhem9sQVdh?=
 =?utf-8?B?bmFoQ3dsamtDOVQ3Mm45TGJEc0c0QnBmcmF4OUQySmhpQkkzN01hd210NDhX?=
 =?utf-8?B?cTRKQlVGN1BtV0JRcXFuaTA1b2VPcC9FL2dYSmM5emxRa0t3dys3SFd6YXRI?=
 =?utf-8?B?QTRmc3l1bFVVOWRDWWV3NTFVZVFxSnJBcC82aC9DcngzSmMzUThSVUs1M3pT?=
 =?utf-8?B?dGNJbndaQ0R3VEpLZENCNWNzRi96OGtGKy85V2tMT1BhWWtzRU5EQWZQK0hO?=
 =?utf-8?B?dWI5eFRFWjYwSVVWMnorVHdzQmdOQ2pzaGlMK2dIVm1DRTkyL0s4UWUwUUM2?=
 =?utf-8?B?S3Vacmo1Ymx5T2JEejQrWVlDbzQzZVE3NldHMFhvMjZKeXJOb3pkVVBJM1ZV?=
 =?utf-8?B?WkpmZHRpTE9UWFZSUVNEb3lzeXdrTG1lODU5NVVuRFk5U2MrdEF1NTI4SGF0?=
 =?utf-8?B?cFZPOFhWQy9JZlc1NnhmNnZneFQxcHQxNkRwV084azZUWFJFamdyUzdhQ0Vo?=
 =?utf-8?B?eEY2a1FSeXpWYnVEbjFmUGNoN2Y4VDdrRU5wcjczY2M5UmEybDhBZGN2azBX?=
 =?utf-8?B?b0QydDZYcUNiRUR2V3RldDRsQXJjZE5MRm1vVHdwUmxQU3FqYjYwN20zeVg1?=
 =?utf-8?B?TXpsNU1YZjdnTGd0SHZHeG15RmRCVkFaU2drVUpYbVNmWUxKRVZZN1diN2o0?=
 =?utf-8?B?OUlJZmRmemtwUnAxc2FINEJGUzNXWHRoL3ZDaytVZFRVZHh4QmtMMlZETGVo?=
 =?utf-8?B?UUFRWVYrZEFhZHRkZG5ScThyb1ZtWWFqdnZTYTk0dzgyYmQwRk0rOU83UHND?=
 =?utf-8?B?djFDbW1EWUVlV2tFakE3azIxdm5mOWRKOWxFQjZlUDMwNWJJNHYrN0VscWJN?=
 =?utf-8?B?UHFwU1l5L25MU1I4Q1pzQ2xsZEhNeUd1K216RStEay9wazZvbGsxSUdYVlk4?=
 =?utf-8?B?b0VpcFYxTm16UklHN2ZCNzEwdmdqSWFtaHE4YStZb2ZEN1ovOWJVaU15OWJV?=
 =?utf-8?Q?w5J8HzhDaB6qpaJ/cC2cYBjxU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f25d27-e775-4cd4-4f78-08dc4e5f14c1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 13:09:05.9921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kA2UrtxR2rr+hyW0nOHc/gue0lgYKuKlgjmt0cBrgTG4szxJhtr8Dnk6UvncX4o5dC1vekV+9Hm5YT9mFL1xGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8539
X-OriginatorOrg: intel.com

On 2024/3/27 21:05, Jason Gunthorpe wrote:
> On Wed, Mar 27, 2024 at 05:54:33AM -0700, Yi Liu wrote:
>> There is no error handling now in __iommu_set_group_pasid(), it relies on
>> its caller to loop all the devices to undo the pasid attachment. This is
>> not self-contained and has unnecessary remove_dev_pasid() calls on the
>> devices that have not changed in the __iommu_set_group_pasid() call. this
>> results in unnecessary warnings by the underlying iommu drivers. Like the
>> Intel iommu driver, it would warn when there is no pasid attachment to
>> destroy in the remove_dev_pasid() callback.
>>
>> The ideal way is to handle the error within __iommu_set_group_pasid(). This
>> not only makes __iommu_set_group_pasid() self-contained, but also avoids
>> unnecessary warnings.
>>
>> Fixes: 16603704559c7a68 ("iommu: Add attach/detach_dev_pasid iommu interfaces")
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/iommu.c | 20 ++++++++++++++------
>>   1 file changed, 14 insertions(+), 6 deletions(-)
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> This will need revising when we get to PASID replace, but good enough
> for now

yes, the rollback part would be revised a bit when coming to support
PASID domain replacement. Already in the pending list, will send it
out soon. :)

-- 
Regards,
Yi Liu

