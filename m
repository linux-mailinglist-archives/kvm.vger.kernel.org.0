Return-Path: <kvm+bounces-41550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CF2A6A664
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:44:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10815173D93
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 12:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E32E1DF259;
	Thu, 20 Mar 2025 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dkSZs2KO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C421DED5E
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 12:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742474610; cv=fail; b=MFiNFBKNnsekfkugP64/E6ZaCh7Fatp5dM1tZm+J/S2pDK3pwHS3KtdXNK+L+mII5hlrLGv+pPhToLfIC2Y0PgOurj4wT1elnzqE79HM8AIhghWypUUjCQ1adR1deF3g2lp9ScOc69mVUUG1NfM0V1F5CSuembX5962d7Jh/6QI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742474610; c=relaxed/simple;
	bh=XF1eZ1OX5cXxALDvcsKtUmqUTFmpQWjJo88zzqhdwbY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rDIRxvQB9biZ1GvDzKm449d3ePSTeTPykcDr+3tA+m1Eq2imEKAxVw+X9LPIr9yXp1xNjvSkTHQHamLxZpZItelZQl2AXl0cZaBT+TEP0XFFl7tV4Rr/iIZ/rSOlCRGgNngxQctqD8+2EIF4slcAOtRHfHu6Fxbj8IU4eAX1N+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dkSZs2KO; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742474609; x=1774010609;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XF1eZ1OX5cXxALDvcsKtUmqUTFmpQWjJo88zzqhdwbY=;
  b=dkSZs2KOZbVIJERlJa0QgyBl7BcLgZQoIRvYVAKuzSV3ClK2DqwmCqtE
   r2YVrWCGfHT9vNsDPDbNkLnaewx6C5BR3QgzdXQoAmpICMFwoDr3luUSj
   USoNEoyCnjf40thD0C5OqZpdQ//5J37GT9qaXDfhZ0H58EfYnm1wQqmZo
   Oy6x6cbaorZ0TYTE3o7m3gOaf47xnhjO/wVhYLHCiBn8q/j9p+9Cvu7F5
   wCF5ttlHu6guqcpQedrQMxlgaBo9Xoh1hVz6DQd6ODTh12mz8F/iXHZ5U
   emdMMsaO1fPHPkC5gCXQ25/mXYDeb9NtJr4jb/MKHCYP8EdbbCwFqge+W
   A==;
X-CSE-ConnectionGUID: 6feb9QmBThmKCLV2ZOeD4A==
X-CSE-MsgGUID: 866Ndxx8QI63OPkDpwY2Mw==
X-IronPort-AV: E=McAfee;i="6700,10204,11378"; a="43587947"
X-IronPort-AV: E=Sophos;i="6.14,261,1736841600"; 
   d="scan'208";a="43587947"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2025 05:43:28 -0700
X-CSE-ConnectionGUID: PKjBHHrvQW6HPSnn9QrlLA==
X-CSE-MsgGUID: V/uKoCOlRt+2bChOl7zmIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,261,1736841600"; 
   d="scan'208";a="127767431"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2025 05:43:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 20 Mar 2025 05:43:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Mar 2025 05:43:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Mar 2025 05:43:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I9rWMRZ1oEmNJHGQYmyz7uf0CGmi+kDRQZ4lNBC3kOuN+aXY3grZ3Bhhj+B5OM6lZ9z8qSvlN74f/hgwHmJyZJ6M9F2yin92sSJlE2ohVngVtOzXL4K1h+e/QlWJrNwsffzEIlhY9n6l68ztQc0HlT1FkZfC9QedTlsgYddk1eRo43pESCZTlNYn/vjlGfspvAFTm17Tr4meLcZ09uOCmI3QHojYrUUfudaf2XNObXMB05fI6mXTCQjENFb4uZIj7hg5Djoyum2raRiiqmi0ihyx1JgMBS/rDsZsIn80Jj7j77DWFOxLs2sE4xYez6U05DEpUZJsZA1rAtBFBMUiEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41P/w0x8GipqAWR5yfIo/od8pxID5AaPDQL48djlbD0=;
 b=rpKTeFymgZ6DCu5nXSggX/okqn9NxZ1T1QVm5GuqcUKpOL+Lp5qM78ImDjICyX8Yplko0UjW7fEIII5dRW0duNsrI8dIJ/ft8Luyuutgbf1gWN0I4wLh7mX4FqEWDwoc8wAPseQfUPmYCtHwFJBwIP2QUdSlNx3wtytxIvF+M/i2wleYRLhH0sYrbS8hUtkrDHGOnMxnpXhqmIQ1YjRDFJhT23xOU26Pok+IWzQp9aDnUYlaD0wP34mPVAhVaBRbXS1ya/Zssmg6dHzNfpsc046Uh/nQiW1iiUv3c1aK1TPJrBtZ3e9ZU7FLbes4KK6DJFQ3VjrfbVC9jo9OpAHLeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7891.namprd11.prod.outlook.com (2603:10b6:208:3fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Thu, 20 Mar
 2025 12:43:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.8534.031; Thu, 20 Mar 2025
 12:43:24 +0000
Message-ID: <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
Date: Thu, 20 Mar 2025 20:48:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
To: Nicolin Chen <nicolinc@nvidia.com>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
 <Z9sFteIJ70PicRHB@Asurada-Nvidia>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Z9sFteIJ70PicRHB@Asurada-Nvidia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0113.apcprd02.prod.outlook.com
 (2603:1096:4:92::29) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB7891:EE_
X-MS-Office365-Filtering-Correlation-Id: a215bb4f-108f-4d8c-d9ec-08dd67accd7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZDZmR0QyTTBPZWN6bDlScnpydm1nS2xTUFdydy9YaHhmdVo0UWF0Rkp1TlBY?=
 =?utf-8?B?SEJWMXZyOXB4VG1nY28yUjg3d3U4ZnJGa0xZNTZWOURjUURaNjdpaEk5VWVL?=
 =?utf-8?B?ZUw4Szh4cnA1NW9yb3BaUXI1VFI5UXV4MEtTQVlESmh4YnN5dGNQVithZDVN?=
 =?utf-8?B?b1UxUEZKRFRCc3NxYnFMMkJ6eHY0ZVQ0VVJZT0dGZlcwbWpqUGI0RmJoK0E2?=
 =?utf-8?B?YnZXOXJvSjJCTVBCcjdoYm1QZW1lRThkQjlOOG1qS1hLTXlIdTB6RzV5amg4?=
 =?utf-8?B?KytHZWpBY3l3Zk5nN09pR3NlOVdUWElDOHBUR3NZV2RpNWtYaklteTRQOGd6?=
 =?utf-8?B?RzNScnRPbUFTTTd0b1dzRW9kSUNKb2l1cWxpZUJVRENuWXFESXY2R0JkWFNa?=
 =?utf-8?B?NFJERXpIZlZ6aTNBTGgzWnZSQkMwRFdBVGFvT2JlMkNiaEx3S0gvTlVQdWJ2?=
 =?utf-8?B?TDI0Rks2SStIcVhjeGpWRm9kQ016Q0pUN3dhUkpMYUh0MENvbGxTM2YwdGt5?=
 =?utf-8?B?NkF3UnJnNndLKzNHQ1oxQ3IwOVhFeHZnMjU5N2JUQnpET1pWS3U0ZFBSY0RJ?=
 =?utf-8?B?YTJhR0M5TjY1UTdtOVF2WG95NE5ZdWVmUHk4VDlESXVVN1NGUUthRWl2WEIy?=
 =?utf-8?B?M2dOT1VxZmx5bHl4QWpzb0MzSGp0Q3U3aVQ5TnRmcWJNK3djUW1udEY4cm9P?=
 =?utf-8?B?d1U4QjhtdkNZUjFxUkhoTlIzN01SNy9rd092U1M3czZOQWRWWExDSWFGaTQ4?=
 =?utf-8?B?ZlgyL2oyeSsyM0xDektTS2V4N1R6NmR6eU15ekRicE1FQVVnV2xINm5IZ0RI?=
 =?utf-8?B?SGtQYWMxSVpCSjRUQ3pVcjNnZVcvQ0NmZ3BvcHpxOWZoZnd3M2Vkbll1cFlm?=
 =?utf-8?B?UzNZeFlHUVlTdlptUjBVSE1NbHZob2NnUGJ3b2VNeGkyL2lERnBTOHZ3VmNX?=
 =?utf-8?B?UWVldjFHaW5uaEhrNGExVlBxMTdrVWd1MXl4SnpkeFdnOENnUFNER0huTjVl?=
 =?utf-8?B?M210cVdPZ0xnQ21mMGl5RFZib2t1SlJkVHBvd3c1ZytQNzFFYWFZaUVNZEJC?=
 =?utf-8?B?bkE4REdHT0JyODRxTlMrdzVUaThuTmh3aEw0R1drQmgxKzJaOUQvRzcxV3B1?=
 =?utf-8?B?SU9USW1wOFgrQ2pCM2ttU0drTlNPREExdGhhZGc4cVVrYWRXbWdYcUpEWFk2?=
 =?utf-8?B?ZFZEYnpHRTRYNHlIRDNmZ3dHNS9jREhoVmdaZGtSa0ZZWklXdDdxSnlkeEUv?=
 =?utf-8?B?eHFsVjFyamFXdWFTb3ZZa1VSRDJ2RHZoOGNIUWtTTlhGbmFYNlZFM21qRmtm?=
 =?utf-8?B?RVFpMFcvTlZRSjFKNTJZcG95Y2N3cWJ4TjdXcmpYRndOT2JoZnNaZURjZk56?=
 =?utf-8?B?RjRQNXNyTGoxSzRWb3ZQbHMveFVOeWkvNEl4UjUxM3p6RW1XemhrZWNFSEJt?=
 =?utf-8?B?T08ra2IzVnVpV3o3MUdnam9nTkV1SzBTRWRIaTJ3TzFEWlJJelNlM2JOMzAv?=
 =?utf-8?B?clUydFE2SFcxTzhuZkVpUStQc2E0bG9kMDJtZ0Fla1E0aTVnUlZjSFJJRU1W?=
 =?utf-8?B?NDBDdURERGdLYnV3VHFaZGJBeEVuRnh6bGtiOE1lQThMZ3dUVlk4Y09qT0hh?=
 =?utf-8?B?T2JGWnEzeitmalluSUY2ZEY1dTBqUFVpbjdWWHBsdytMVUZiQ2QxN3NCR3J6?=
 =?utf-8?B?aFo4THRkSi9ZcTlORE52dUt0VFB1NlRXMGUzcGVsMnB6WE9ZRzQrVEpLL0VM?=
 =?utf-8?B?MEhrSjBQR21uTEh6czl2ZlJ2dCtraHV1U2pCakEzNzVMS3IxU3dRTE9FOWJP?=
 =?utf-8?B?cTA4RkF4RGgwYWFObm80Y0hrT2F1elY5TUM1aTcydkNpU1YvNEZLS2lNMGZm?=
 =?utf-8?Q?rQ14dotWlHMVr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czVvRkJ1M1N4bVhVUWJKdHdoSTRtbHdZeTdLdzNlSTJjK0tRQXZWYXJLQVJY?=
 =?utf-8?B?VnZ2aUVYbVIzV3QyckNlay9LdzJrQ1h5WmJSMzRZWUplWmVTVGYxdVZQRURn?=
 =?utf-8?B?V1hQOUt4eXI1VW5UcDJvVXB5NklSUUt4RjIrQTQrb2hRNGtBeVhZeER1NVBC?=
 =?utf-8?B?NnVYNUxUU0dJMEtnbXBIb2VOaU5iWFB1aUE0K0NlRzJDL1M3MnpBNG16a0dU?=
 =?utf-8?B?K1VTa3BOZ1pwRDU1SUNhOVpDRkdnN0lLR1c5QzNBNGt0dXJXb2N3WmpTNjU4?=
 =?utf-8?B?RnpxRHJOdVBDSndVT28vNEZSY2QyOXhEdzBpNjhJQTU5TnpZWm90dERMWXZF?=
 =?utf-8?B?dFk1eGp0RDlDVU1ER09idSthOFZTUkUvNGRBUXAxV2NlUTZldnJSYXM4TEU5?=
 =?utf-8?B?eUdIaVE5TWw3OW83R28zdTR1eS85elg3VFo3azZHb1RpQk9yamlKS2F3bVdG?=
 =?utf-8?B?V21obzRNbm1iRWtLWWd0dDFKV3FoZ1M4cHAzcGpoK29TS05KVjRFRVMvclF6?=
 =?utf-8?B?dFBNZmdab08yNjBadFJtbWk5UmthMU90cjVxcDhGT2FlWm1CNFFZT3Y2YmhT?=
 =?utf-8?B?d3lnTjZLWGw1OU1FSmFxSkFzcUxScHlWMjhROGowbTluVEZtWnVDZFZ4NDhY?=
 =?utf-8?B?VFBvK0t0Z05mRXZGWjBpb0ozZTErZU5LZkpCVHl6bjhobURYN1dpV1h4a1Rm?=
 =?utf-8?B?dmdPTlhxRXhzSkV4bVBVbHBjdm01ZC9CaWFaMXZ1Mk02Y1FCclIxVjlPZXFx?=
 =?utf-8?B?Qzd3NzhrMmpWRUV0UFR6MGlueDJQeXdRdU1LbCtCV3ZQRVIrWHN5Wk1ici85?=
 =?utf-8?B?ekdWb2x5Wk9IcWtOZ29jZDdhTDBFVlZRL3FQKzJnb2diT3hGdFc0dnBXWElU?=
 =?utf-8?B?aG9WMzZtQkFWclRNd1kwazRYTHhVeU50Qyt4d0c4NGlOU2I1dW9LWkxQeEk3?=
 =?utf-8?B?KzJTc1dndHZnQmRlemxwTWFJWjd1SVJMOWhYSXlNMEFpS1V2OHZJVkc4M2Fv?=
 =?utf-8?B?d0QzMlFmOVpQSXJjNXcvc0VWTTYrdmpBaGMyNEhOZzhVTldDYlJwYkxWZ2o4?=
 =?utf-8?B?WitzcVNsYjAvVFFuUTROcmt6QVZaTjZBVVdneVR4N1NJbjUxaUlLdXVHR202?=
 =?utf-8?B?amJ6dTZqaWgva3lKcVBmV0hTMWljWS9LckIrTWhhZ2RmWjFGT1A4V2VMYkVt?=
 =?utf-8?B?UEVWNTB4RDFJVWthRC90VjROK3EyVnpXVzcvZDZGcVFnS3VjczlNc25vRG1a?=
 =?utf-8?B?eGVmTVFGallLMWZ4dnlPU2xRMmpLOE9uSmMySld2TmxZaGRFbk9JNUNJdUZj?=
 =?utf-8?B?enBHUi9mL3dseUhUNThCNVRKSC9ZMlNMb2t5cDRTQjBKZ3plUElhZ29ULzlY?=
 =?utf-8?B?c0dSRzdxNFdsWUlRVlc1d1BqMzkyNjhWQnlZK3RMYlNUeHlUYXdNODg4eGdv?=
 =?utf-8?B?NnlaOXRaRkRUU3dabU5iZk9vc0w2WmFBUis1YzNObzJDbjdmdEN1UXpQamdR?=
 =?utf-8?B?bnFWL3Q0TndOd3J1YXdzYTFKcXljOHhuWXV3U2xDMThCL095TThVbmFOeW13?=
 =?utf-8?B?Vi8yMTBrYnFBZEVrSEg2eUJMeS93SW4rbUtoOFo0ZmMwTVMrMG9BK3YwSGlI?=
 =?utf-8?B?RDFGRmJCK1h2OVFrSkFFMVZuTGUvSS8vWG9GL1hWSUxBREcxN29mTzNnM1Ez?=
 =?utf-8?B?L1RWYVJ2eThsOHVYQVZHUVBMNmQ0cDJ4WHU4bFkyd3dMdXNnTHMrenFwM3dq?=
 =?utf-8?B?SGFLQjA5clBqUzErVzM4QXlkTjU0UEFWQmRUVFQyMnhIZCtTTjV2QlVZcTNp?=
 =?utf-8?B?ZUVsR1oySDdJcXV5RkZBWHFvUy8zb1JENjdKd1hsaUVSZ2l5cHc0akpTUzVY?=
 =?utf-8?B?ekl1Mk00Y1V4bjVzRW4zM0EwZG1DTU1Id3hQRzFyVWhOeldPd3VmOHo2S2NJ?=
 =?utf-8?B?WlljSFYxNE5GRjZVZXFnRTNjYzhHcjk2Z2ZkTWFCVTlzd1ZlR3JBUGtYOVI3?=
 =?utf-8?B?WTl0ZGpSK2VKSzFaV3lpbkNYM3FqQXB2OWFtNmZRdUdhOVlYSU5aZHpYdDhu?=
 =?utf-8?B?YXNhS3pYY1ZnQm5VbzVDSnJyTlZUTXBKMmJyU0VHVS9uaUZJeWs1L3gwZW80?=
 =?utf-8?Q?/O2VQsuwzOOYqVqTos7XTcCJI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a215bb4f-108f-4d8c-d9ec-08dd67accd7c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 12:43:23.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: knGh7si8zXjWmSLvVHrBDsJf4Zhvg7XlX9rDJEeyH0N3RPQhRXveZ545F7tzl+kPHqqhYOr3MZD+chh6liFMVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7891
X-OriginatorOrg: intel.com

On 2025/3/20 01:58, Nicolin Chen wrote:
> On Thu, Mar 13, 2025 at 05:47:52AM -0700, Yi Liu wrote:
>> PASID usage requires PASID support in both device and IOMMU. Since the
>> iommu drivers always enable the PASID capability for the device if it
>> is supported, this extends the IOMMU_GET_HW_INFO to report the PASID
>> capability to userspace. Also, enhances the selftest accordingly.
> 
> Overall, I am a bit confused by the out_capabilities field in the
> IOMMU_GET_HW_INFO. Why these capabilities cannot be reported via
> the driver specific data structure?
> 
> E.g. we don't report the "NESTING" capability in out_capabilities
> at all and that works fine since the iommu driver would reject if
> it doesn't support.

NESTING is a bit different. Userspace needs to know underlying PASID
cap and further expose it to guest if it wants. While NESTING is not
from this angle. It's just for the use of userspace. So a try and fail
is ok.

> Mind elaborate the reason for these two new capabilities? What is
> the benefit from keeping them in the core v.s. driver level?

I view the PASID cap is generic just like the DIRTY_TRACKING cap.
Reporting them in the driver-specific part is fine, but I doubt
if it is better since PASID cap is generic to all vendors.

> (sorry for doubting this at such a late stage...)
> 
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org> #aarch64 platform
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/iommufd/device.c | 35 +++++++++++++++++++++++++++++++++-
>>   drivers/pci/ats.c              | 33 ++++++++++++++++++++++++++++++++
>>   include/linux/pci-ats.h        |  3 +++
>>   include/uapi/linux/iommufd.h   | 14 +++++++++++++-
>>   4 files changed, 83 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
>> index 70da39f5e227..1f3bec61bcf9 100644
>> --- a/drivers/iommu/iommufd/device.c
>> +++ b/drivers/iommu/iommufd/device.c
>> @@ -3,6 +3,8 @@
>>    */
>>   #include <linux/iommu.h>
>>   #include <linux/iommufd.h>
>> +#include <linux/pci.h>
>> +#include <linux/pci-ats.h>
> 
> "pci-ats" includes "pci.h" already.
> 

yes, it is.

-- 
Regards,
Yi Liu

