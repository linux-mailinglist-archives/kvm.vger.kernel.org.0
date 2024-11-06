Return-Path: <kvm+bounces-30886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CAB29BE27A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:27:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05228281022
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378031D95A1;
	Wed,  6 Nov 2024 09:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XuIL0C1U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DD01CF2A6
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885220; cv=fail; b=iS8Clg1cP1LH6BygOo0qFR/n3djrV3VxHJuCrzrisDTjhLdHe5P7Zy4W3AhgF1JJubkDHsMOrx7x5S9BlLNw2eceIft2viC0K4NUJjU8SZboPu98OB+vpLXfaMVQoMB6FskNmkBCYVNx4ZYUYvYs1vXWAkD9jtVw0Y25nsViQuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885220; c=relaxed/simple;
	bh=39+S2SGOfe983tarZaA2l1zY9RC37UXteN5wAhBbYnc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F0c7Lxmx7h/qTecIn40xARco2pCu0R3leJCq6usKN7c0lyf1QaJiFE7ZswrHRSnfbNHh56B6D6cFChQ1NnuDzre/vC3U/MQJ5AqkYT/UVMxTPew4XrrLnpodKJfy/W/QlfHSwQM58W/Zl/lJfnO+qERgbiCyA53b3DI1wAj7MgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XuIL0C1U; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730885218; x=1762421218;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=39+S2SGOfe983tarZaA2l1zY9RC37UXteN5wAhBbYnc=;
  b=XuIL0C1UQCiuZVTRBrDfYMTcD/b1XgrztLBsffCj3UObQK9sE82hvb43
   1QV+XlYYNDcNjbWx1TnytzrwntDuEq7oAODPoLB4+ME9vrQI+p9V7Nvbc
   OfaTuv57z+ea8SOvkCSpyd0KQT/Fxlqb+1wlD191HzIuCOP8wiYfeGdgy
   XM1N8htAZy5M2MHQFp2h4sODziyMFm4NVLFyIgvBJmacJOq6GAjFRheZk
   kPM8eSo71uGy5HDUapDl1HSgmylp2tfb+o5KzmPxv1sLQRFgD9Busaf0f
   o0cls272p9ryLc+Urws1TEuHn5Gx5rlzrCwW2aahSEfV9E1vRJItAq2KQ
   w==;
X-CSE-ConnectionGUID: 1HVfYOKpSBqTe7UXcHso+w==
X-CSE-MsgGUID: 0yMxymbgTeWpP4hOxNk5vg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="42072856"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="42072856"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 01:26:57 -0800
X-CSE-ConnectionGUID: opeaEJyWSragC+t7wiOIGQ==
X-CSE-MsgGUID: 0VxSTavTT8m1iP8/EAMXMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84351491"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 01:26:57 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 01:26:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 01:26:55 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 01:26:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r32kC3rUaJcUKmKluwWGsfNpF7CO9BHher4DKmM7q9vHPgUrg0BuA5hrQ3Uz7I0r66b2t5gJwjxssveNNI8OhNDDrKKKEJBzhSYlC0DLSPuVTWBUjfCmdNbVF6D0/LmiR4bjpx9T3e2O91zTVQrm9tDjCNgmDi2BitX5BzJeLtWeFp0MFJMPXCzncFRSXVtJ1h1UA2whOYJoFqI6oMaqDz2opx5OcydfTbqPxmLt/GhkH4UoXbFkJYpB158q3LmYbeKuQgHTHWnMF/7AHdNcPLHgixkcD/hIMcktHKLmaawBR2EIO439Z9/A9O/nyLWWqYS2cW7WDsropdI2FxhyNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDMVkQ7fKwfAVeNcRrBG7SFSRWrD5GOp7ovSPDJAAjA=;
 b=KasaMRtj7v96crW3HS6PjaO7JIZfG8oh1Z3RLRGESWUIatqf58kFO2K91cmH9WSxTpCGVHiFys9JImVHm/oL0QPC+ZlO1a163QbIGEWSJjs5Ky6NbN4QgFzsr6uYSEaHEO7Nf6iZKDm1+MQiB74FmAa3Mr+V2Tmj77+wd4EF13ogHXaC4at3jb4xvydXfAcjgYSn2R65qRBXUFBqm8Lvf3Kq9GwBCuJK4OJ4DWNNQSNv6E5dvhes/TVPQwR3iMXwNmL36yMxUOS9g+dmMBJnCVrKJYHxs+fGJq5m0lLB0tHuHzgPjNGBoQNSPzSioyg8IJC5GMixxIqRcALuCWoeLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6824.namprd11.prod.outlook.com (2603:10b6:806:29e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 09:26:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:26:52 +0000
Message-ID: <d218eb1c-ca02-4975-bd6a-310a81b3d88c@intel.com>
Date: Wed, 6 Nov 2024 17:31:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-5-yi.l.liu@intel.com>
 <BN9PR11MB5276B9F6A5D42D30579E05E28C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276B9F6A5D42D30579E05E28C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0152.apcprd04.prod.outlook.com (2603:1096:4::14)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB6824:EE_
X-MS-Office365-Filtering-Correlation-Id: 497ce2f0-4da4-42ae-5b78-08dcfe452602
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXBwaUEvb2VTSEl0bVVJemZ6TG1acFduRXgvbnJaQVRxRHJXZzZJcHlnMld2?=
 =?utf-8?B?ZGdVMFRuQkg5US9xcktocDA2c3NqZmVSelY0Vy9pSTIvR0JSd1d1QXJ4SDhS?=
 =?utf-8?B?T01OdXQ0MkxkZlg2MVdXbDNvOG4veUsrU0VWcW1TS3dUMFVBT3dvV0J3Y2lr?=
 =?utf-8?B?VUJRSjI3THpaWmpMcC95dENqK3I0VUpUODE1cVpWTDVSa0pMRnVsbkl1OGc5?=
 =?utf-8?B?dTlKZUNWTTdYdHgrUTN0ZFFHQ3RxbTFsVVdRNnZ1QUJ5NitwUVdCdnlRL0JM?=
 =?utf-8?B?cHlFWUI0UnpxT2VrN0drYjlEbHNNQVBqQjBMZFAvRjhkRGUxYVJrOHBFV0lz?=
 =?utf-8?B?LzRSVDg2RHRuYVd2RFdWWVFYSStiL3FlV2RwakpiSmxrOHdkOUlrQjlKbkpT?=
 =?utf-8?B?RkR1bzdLbWR4WHZ3UXc1OUNXM0loekRwUkRYMzhMT1N2RUJIdzhHU2pPbVA0?=
 =?utf-8?B?UHVsWnhQeWFJVWl3N1FwdGQxbGptbUFFOW5LR3ZFTXV4bFRIcmlucWpyRmJ6?=
 =?utf-8?B?Q2Niek0weDhHOUNnM1R0V2VxUnViWUxzZlBsRmhmMDhEQ05CN3hKcThZRUxK?=
 =?utf-8?B?bHBoOVlObkZmRWhGSS9LbTVlT0thc1lyMHd2N0xHSmphUkVvWDQ0a1ZxcHpa?=
 =?utf-8?B?QVVmNDdFajd5RXp5bWM5amZKNkNNUEJFYldGYlR2Z3h6RkU3S0FGL1VYQm05?=
 =?utf-8?B?NXRTTmRmM05sOGw3TnNUVk9hc1NtZ1F5QTU5SlN4V3hYZDFMVVVrR0Fjbzli?=
 =?utf-8?B?bEhUNWxzTWY5QXc0eWN5eGw2ejdOSGxoZms5dkdNL295NFZ0Z01vcC92eXhk?=
 =?utf-8?B?Z25FcWNrOHJaRVBvVGZNbFl3Y1RPTjF3anRJRW5yU3F5ZEVNV2QrM05VeVdV?=
 =?utf-8?B?WXpNMUNnYmZoRlozaWtxU3dqQnlVcHZRR0U0UVpPRjZpaHE1bENkcWtvc1lh?=
 =?utf-8?B?QlVSS21LK1Ria2hUaUp1bGJnUTVXUVJVZUhta1NwV1diVzRWMnhqV3ZYektp?=
 =?utf-8?B?VUprbWEzREVxT2hLVDlDcXJsUTExaTQ0aUFibUdLazdXUUNzeXNLWDR2cUo1?=
 =?utf-8?B?QTh2eXplWE52eEFOV1VrSGNCa2QzS1VLdklZMEYrQjJ1ZlJFaEFHcDJJbGd0?=
 =?utf-8?B?YXFMaFZWWml5WW9OcTV6dG5NM3BXOWlKMWs5dmkwU3lqYU9TYjdDWHZ5bkRw?=
 =?utf-8?B?U2ZOM2Rzem9tMy9ZMmtOcE5xL1JCVFZCOCt3cVJOUG1GUkpXUjE1TnY3eGVK?=
 =?utf-8?B?UDgwVUtMUHpNNU5POHR2V3pWaHZ0NG1peng1M0ZLZVExYUFLa0ZOMGNoTWpB?=
 =?utf-8?B?QTdTS0x1MGpTQko5V01jbmtyUTNaTnY5M2hkVzBMcS81bTZmVGlpcXRxdkZF?=
 =?utf-8?B?ZEt0QjMzNWUvUlZ0NDhJS0hJQUpzWFRwRjdxR2JVN25sVDY1bi9lSTJzeXZt?=
 =?utf-8?B?cXRGaGpEZmxxTlI5NEVLLzBsR3NvL0Y5d0labFM3T3MrdjlNVjVTamhid0dT?=
 =?utf-8?B?L3RPY1d5Q3Q2V3pvclJWdW81RjR2eXBNL3ZUeU1HZ1hEZWpTeThCYlBOZ25B?=
 =?utf-8?B?a2VhYWxHSk1iOU51bld0b2NGU0F3UlkxbUpyNzdaQmkxdm9ENmY3Y0o1RFVr?=
 =?utf-8?B?VURLM2ExekxjSGpsU1BxM1hPbFFyOVBBc0FlVWR0Rkcyc2QzMktXd0p3aWRB?=
 =?utf-8?B?TkNSZzFrTUNCR3Q1Z2NIQXJkZEJkakRhZTliYTdaN1NjZHVlR3pUam9TKzB2?=
 =?utf-8?Q?ytFJNNtCCOfeeFc+so=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGNHR2RVN2IyUndFZTBMczNDNVBzVklua2ZqSE5NSkcwbWZHTURMRVpoUHp1?=
 =?utf-8?B?ZW9nVUFkcTBMdWhScWNrUjIwNE13WWZBVUtFV2MwQWxhcmJtT0Ruak1lRjNr?=
 =?utf-8?B?SWx5Q0lySkJ3dmRjZ0hTdVNPS3dPZjNLWnh3ZkxOTWwyOU5xR2M4NW9aTzV2?=
 =?utf-8?B?VlNyYWlvMEpoVmFieG14Q3pvYUVORmQ2c21tZHFBeWpaN2xsNW9kMkVrS0Ny?=
 =?utf-8?B?ZWQ2WUpwL2pkV3E5S0JUamFsSEtpZ245Y3g0N0tuQXZTYWgzRmFYeU91ZFdG?=
 =?utf-8?B?WlRZcU5NZm5icmNTYVRJa0Q5Yk9RaGxIM1F3Zlk0ekVoRWYwV0Z5ZUpXYjFP?=
 =?utf-8?B?YU1ialZCNmkvV2UrWjZmandtZ291QU1zeitUeTdUUkEvYmVVSGJWb1lXTEs3?=
 =?utf-8?B?Z204TkxwT2tnV2NlVXhnYW13MEJFb0d1YW8ySEJJdWRkRTBrczArOGFNVExJ?=
 =?utf-8?B?cVZWa0ZhbDl4K004elNCcFdMamc1VEUvb0VKb1hxMDdlRW0xM1NXaHFFbDVU?=
 =?utf-8?B?R3VpcHRyVkJHMUxoRGl1Yzhya2NTa1FnT1pqUlp6WHcvUkQvbDhBd2tsR0oy?=
 =?utf-8?B?K2NXS3RhdDdNMS9mZkQ3bEZha1B5QWpVZlBpS0h4SDEzRDZ1WUE0WUthSG9s?=
 =?utf-8?B?U0ZKQmhaOXY5b1AwSDRKTk8rTHpBdG1uTDQ0Z1ljNU9iR0M0c2UxY1dReTdI?=
 =?utf-8?B?cnI2QVRVS01DeDZyQzRrMksvZk5PQ0p0L0w0eDNDVXZDRFp6MGtuN094WEZi?=
 =?utf-8?B?K05oR3VPUnR2bkF4bi9IRS9kTjBMazB3RGg1RDJXZytqbVM3UmMzbHRTQ3BE?=
 =?utf-8?B?Qm9oZTBsMXRzcXhXaVBoeUpnd3NaTllQQUpqM0QycElyOUdndSt6aXdJczgr?=
 =?utf-8?B?SklvN29Oa09HNWNXTDVWekZXbmZSV0lucWJ5WGJBNVhwSkFCdnhJdDNrdE1q?=
 =?utf-8?B?ZUlsdTNQOEVVcWVTc1VueTdDZmN2d0czVkVsT3pxTklnc2pIaVFSZkRhcGxV?=
 =?utf-8?B?TWxrTTBmKzVkK1g0czA0QUVDWnhlYmRNdEE5M3VSS2M3MW9VREdPeFFlY3JX?=
 =?utf-8?B?cW1VdnVXSG1seGViQWZhK3RYOU16b1ZuZGtaTFc2Q2JkdUtJNXdBQmMxQldM?=
 =?utf-8?B?WWtaVk9lZmpqdFgzaE5YUnA2bVk1cGtPcmVXdWNSQVI0aHQvQ2Fwam9SU2kz?=
 =?utf-8?B?OHAxUm1uNzRqb1ptbjZSYXl0VTMyOGlhNWNSQTc3S21SckxybDhRM0ZwWnZl?=
 =?utf-8?B?ckZUNEpJNjdRcEVXOVA4V2xWd2wwVU5Xd2dZbUxEcktJOSsrcVpGdDJLN1Rt?=
 =?utf-8?B?ZDFCVXhnSkJ2cytvRXlLVnZJc2UrQno3alFnUVdOSnZRbm45b25xOW1PanNw?=
 =?utf-8?B?RW9Fd0QrbHJIL0FxcG9xbDRlVUNBUmdtekNxOGVWNDh0RzhBc3UwbVBINk11?=
 =?utf-8?B?U0UvYlY5L2V6TFlWYUNDV2Q0RkxNKzN5WjRodHA4N3J6QjBKc3RPWEVRMTg4?=
 =?utf-8?B?L2R0eVJXRUZ1b0V2TnpBWDIweFl4NFladXY5Y3RnNEhNdXg2M0RzRTBjallm?=
 =?utf-8?B?VDczdm0yK3pWWXVyeFhGYnVKeGtLbFlRYWJWaFJOWUcrOVZIUTE0ZjNuWjBi?=
 =?utf-8?B?NUc2ekdtUG0yeHVPdkRRUDNSRHZWUHFWT21iYzRDOGczYzV3aUgzZ3l4QVl4?=
 =?utf-8?B?bVNSMi92enJrQTJjR21aWGZYYVo0SDhtL1V1WUNaVmFuc3FjbnJRVlNoWGhL?=
 =?utf-8?B?K25jWW5YbDFtUkIwdFNwb2kzazNiRzZiUHdGNC9FZjZFUjgvenRmMUFmWjM1?=
 =?utf-8?B?dmJlYXdheHVjQUZ5OXMrSnVGK0t4bk9KVHI3Z3FWVlRYaGt3RHNVd2ZjaWRD?=
 =?utf-8?B?YzZyWXNzRklFc2c4cm1ScTV4a3YzTzJUYjNVNVE1M3E0VngzazhpZkNVekpW?=
 =?utf-8?B?cE85M1pHN2V5RHhuLzZKTU0wL3BBajNkQ0cwRjRHdjNXQ2ZvaUFDU1ZUcXUz?=
 =?utf-8?B?bTJpS2hVaU80c1RaK2dsTUp0L1hUWm5oTlh3aFpIN3k5R2szM0N0MFNOdXEw?=
 =?utf-8?B?eHRkOW54YlcrdEZ6S01jTktiRGh5UUYxWmg0eE5EN0p2SVNEUFZvU1BjblJN?=
 =?utf-8?Q?TFJ9TUrpUbO8ZxpRKicD0He9h?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 497ce2f0-4da4-42ae-5b78-08dcfe452602
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:26:52.6716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3wxvABG9m53WLM0uohZc+rRLLS8fbckDPpEn/gQ9DS+dAEnUBFhhJhDcBKWrH+QuB1+VVw9eC7xdagOTmOaXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6824
X-OriginatorOrg: intel.com

On 2024/11/6 15:31, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, November 4, 2024 9:19 PM
>>
>> pasid replacement allows converting a present pasid entry to be FS, SS,
>> PT or nested, hence add helpers for such operations. This simplifies the
>> callers as well since the caller can switch the pasid to the new domain
>> by one-shot.
> 
> 'simplify' compared to what? if it's an obvious result from creating
> the helpers then no need to talk about it.

agreed, no need to talk about it.

>>
>> Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/intel/pasid.c | 173
>> ++++++++++++++++++++++++++++++++++++
>>   drivers/iommu/intel/pasid.h |  12 +++
>>   2 files changed, 185 insertions(+)
>>
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index 65fd2fee01b7..b7c2d65b8726 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -390,6 +390,40 @@ int intel_pasid_setup_first_level(struct intel_iommu
>> *iommu,
>>   	return 0;
>>   }
>>
>> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
>> +				    struct device *dev, pgd_t *pgd,
>> +				    u32 pasid, u16 did, int flags)
>> +{
>> +	struct pasid_entry *pte;
>> +	u16 old_did;
>> +
>> +	if (!ecap_flts(iommu->ecap) ||
>> +	    ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)))
>> +		return -EINVAL;
> 
> better copy the error messages from the setup part.
> 
> there may be further chance to consolidate them later but no clear
> reason why different error warning schemes should be used
> between them.
> 
> same for other helpers.

sure. I think Baolu has a point that this may be trigger-able by userspace
hence drop the error message to avoid DOS.

>> +
>> +	spin_lock(&iommu->lock);
>> +	pte = intel_pasid_get_entry(dev, pasid);
>> +	if (!pte) {
>> +		spin_unlock(&iommu->lock);
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (!pasid_pte_is_present(pte)) {
>> +		spin_unlock(&iommu->lock);
>> +		return -EINVAL;
>> +	}
>> +
>> +	old_did = pasid_get_domain_id(pte);
> 
> probably should pass the old domain in and check whether the
> domain->did is same as the one in the pasid entry and warn otherwise.

this would be a sw bug. :) Do we really want to catch every bug by warn? :)

> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

-- 
Regards,
Yi Liu

