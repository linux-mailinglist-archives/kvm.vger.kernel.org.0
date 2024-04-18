Return-Path: <kvm+bounces-15060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F6268A958F
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 11:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 619981C20B51
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 09:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD13E15E1E6;
	Thu, 18 Apr 2024 08:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lFgi7fDe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AE715CD4C
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 08:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713430790; cv=fail; b=GshBPhiC+8POjoe/3Pu6RhnLuBWjd/d0nQmx18fQ8Jh1MQAhxWaqpq925aMaDruTXNut/tE3gB/jDomp1klp5s2Umw+7hGcEw72L+yeYYUKHHdjTaK6kw4sefJMKbLaoPnA6Hy3+qhArFRsjjaJQy9G2rmB43tVCYY2+Y0KNFk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713430790; c=relaxed/simple;
	bh=Jf1lYfNblw/uP9zUlPwvlypsGoEI7Hc/xQy4fhjdqcQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OVif55teRMoKUJeNUaJmAxfMUveFeNBYLImSXQKJdf/F2usgiWyklvjF9sMMD8bP873J+h54QKi4r02Q4HRKQVGPjzF53Ix/Dqjgal7Tni6kFNEitee+jasVw4qX8p0SJXn1UJGMgBN32wC6d/vUFvfg0Zp91yK5wbnWCZwYUV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lFgi7fDe; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713430788; x=1744966788;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jf1lYfNblw/uP9zUlPwvlypsGoEI7Hc/xQy4fhjdqcQ=;
  b=lFgi7fDe3nRChI3iZXwZa9FpYW4HgHdA5JH7aB31Fdp9hRFRb/NVDgCq
   We7Z+BeO/IqDacERhf0aE09k11zsfaKX8CV4oKBp9GnCrmDOhe66YPqCi
   SIGUGHGNFnvNnwqRMmNOagp9c7i1Olyku2rr/B+c+OrIVwgHVsb4FsMUN
   3doNU71KynSL7Mizbu7nsUEgegRlOyGvhGjac9tnHpewht2XjQceWCghV
   FENpfdk55RohNz+wSL0ogH8e+ihjaxQI4LPbA7lbDLmDRs4hjbxfy2AoE
   rEiJ1EY0+F4Ba/CePnOMb7wpiXGrHNeyCKIOjxp7W9wFnUkfJEt16lR7Q
   w==;
X-CSE-ConnectionGUID: oThkSa99RWuAxGpoUtpesg==
X-CSE-MsgGUID: kxdc+fO0QpGL2UkQaEyBTw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="19664271"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="19664271"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 01:59:47 -0700
X-CSE-ConnectionGUID: FUOUUnnPQC6fEVR4vlbRqA==
X-CSE-MsgGUID: GFzdGqQgSleRHhw+06m0Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="22989569"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Apr 2024 01:59:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 01:59:46 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 01:59:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 01:59:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 01:59:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbwI6PMVp0jX5AcAv6GiuKJTGhYv4UKGB6LwgZ1mA3k1uVRRVW/DWgoSQaDJf2Gzxwc6PrMtHvbp4vTAluDiCsyAxlPTjd7fk/0a7pqJtTYQxVw/11+yemV9K772JivwnavTB1d2niotCUimy4qMx+9n+f5bdZSfpEcsRoRF8J9jnacOuYqofk394HqQAIX+SefW/Vknqo3O+Q1QkJFooSoooL6MbKPp/9I9jDGl1966elc8d4u7YDFEk7lhf5xJKlNphsaVHi/zJ8X6WCWUFYzLXJ3tb1/whOpXxj1WtIKJnM8/K6rDD0T8awDqNzUXbSoZcDKrYFZTJzGYKspJJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1JX+nMmuaNg0i3UJj2DRxaupzv88Y0b4pT1hJW37W0=;
 b=RbIlf66jw1eddrvJJ54jLDs61BjZT79gOkmWlCMrLs42GSBFP53yeWG/1Kb/NpG08YBM7MuQp/bBCr/4rSVgb1Vury+24FRsIT3TM0NBQ7lKKOP4swrfjgX/A/4hEYsrJuGVycPw8n2DjKF34yCs3T0rSPyDaeavcq078I/3/njkvcf/TVUAvYvFinx0XcTVPCBLaE4W3hr4VM2wgXQCP3AaShekQtt54Y/S5/hwkRlYEMH8m2Vj2wH3jf1P01+xTc+H3Xe4YJGmyeOpQz1+SAHn+LKTdlehDbdOKudj7gEtd4NolP1hAEvTRF3zANBykVyDVvI+4y0Xui3DMP1DSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5949.namprd11.prod.outlook.com (2603:10b6:510:144::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Thu, 18 Apr
 2024 08:59:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Thu, 18 Apr 2024
 08:59:44 +0000
Message-ID: <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
Date: Thu, 18 Apr 2024 17:03:15 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240416175018.GJ3637727@nvidia.com>
 <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0110.apcprd03.prod.outlook.com
 (2603:1096:4:91::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ee8edec-ec93-48f7-6ab7-08dc5f85e424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i23CfdZvOqRQODHP3eZqr+mm8ylyhsEFDzwxqZ3pOzQg7QK45FRZB9N1+5/F9GxUkBvH3aNwgGArgalglCVjBJbaYipsJhI9gtEenQA47pXg/lXY0QgivJyLYRUnKvS+fgt0D5GFfQ5PnWLwPkpikdJDnvOKF5glLniofXtiZGE6fye4sAs89VZz8KOXHmFPpA8ztCvSU6RBQulu9sx+LnAF8ZbRwrgBqkG+TmjbQPO/Qcmy3QjLCy9xr7ZCHcmGX2PWXyi4A0sfxEX+JAU1/6Jm4wRtxvO1dE8Ir6R+r90xzlqcPlYOP94T6s+YylQSlNhdH92opvsnLxnH4oWh7iaZFvn5nmvyWhc8oarf4iwvp/IZ8H1KZfngf+ORL13vzrf482cc4iAQzynU+NJD2GXW+1p9cU9MM5vHeOJJK9ezWWq4q1XWf8NFtCTVJSjHTGnrM0weQT67+dH1fj+oOIhRgHWHP+p8dYOYW6I87HE9jSgBadKltCMchbd3cS15oSZYSkKdd0FfL5z229lY3sSi49YtY7wEs2TY3Uu9BHKQK1WD70B6KqKvVQ0WA/isgpLZe+GKdlclgf/D2QDD+vjZA0geWFBNz0rFvdcLlrl7iCxddMHz638VD2dym9pVemhkDuA52L1Onkm2ulCVktYvTVNtZ1LBSNadQmJHUBQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2l6VVFQSkthbVhwREgrcnQrWlM0Qzg5bmpSdUJTenJHbllsWCtyVUxSdnZF?=
 =?utf-8?B?WFdIZGhuVmZaRWt4b2owRW1Ra2ZQdDh4NmIreHJzdGliRkt1NlRtRG1vczJK?=
 =?utf-8?B?MnkrMzRZaHBHVnU2R2QxeThCSjRGTzQ3U1pQRW9GMExteHJ4VzYydE8rOVJM?=
 =?utf-8?B?TVlwNTI3ZFRWUXNsZTB0NkxpR1pYWDlKTjcvYUVCcjh0a0duMk9hT29HRHhh?=
 =?utf-8?B?UmlZblJYdC8yMGRibDhHNnowVm9JYTNSMXVHNzQzWTBWZkJhSVBKc0tUVTJ1?=
 =?utf-8?B?b1NBakI1UFc2Y21kbklDT2t6S0xFUWs1eG50VlZPL0FPQnRuYlEzUkVLNTUz?=
 =?utf-8?B?ZHZTOE04RXYzSEtEMlhlVW5mTzdrT1cwUjZsSElZanh2b3Z6YlN6dENsaERk?=
 =?utf-8?B?UzhTSDBZb2lLaFdEaUZ0S2ZEa3VBNk04MUJxdEEweXdmRTdYWEVUTmw2Y3p1?=
 =?utf-8?B?THR3V2daUkFDMHFlTlVJcjZBV1p5NTVTbHhVM0F2WEIxdTB4UzRIeEdoMC9M?=
 =?utf-8?B?eVRzVVJ4S0VnczVQdnJQODh5eWJ5TFJaT2J1VVNUOGtETTJJUWRCSXNqR2dH?=
 =?utf-8?B?NVVzNW04NEYvTHd6R3Z1RndpQStGMFdQRnRSdGNnbnA1UVkxbHRYRUx3dnhj?=
 =?utf-8?B?dUdJbVRLRWs2VXJzaEw5eG9uNk4xdDk3dXN3Q2VIdEZWQm1jdWd3YzF4b2dH?=
 =?utf-8?B?OEZOcDB5TGxCdkY3NUxUY1lPS0pjYnhUdjR4QUJSU2Zod0tRVHJMZzJYeHpR?=
 =?utf-8?B?TU9tOEVuNUdaRkFpU3JvcHo4akkvdHMzRzkxbURBeDNjSzRuMFlnM2JjeHpH?=
 =?utf-8?B?NGdvT210U1dodGdMMkhmeVhNQTY3M1RDMzkwMWlRWmVOUm5idU5lRlUvYk5U?=
 =?utf-8?B?b0hkTFlYeUZRWXNIV09OOXVKQXNsRHV5RGxRMkhzbDdyeis1RGR6cktxbjhS?=
 =?utf-8?B?NkY3NVVKaVV1cVpUVVVRR25nTmt6cEpYbjlJWlZVdmVRTlpOSm9MUXhTNkt5?=
 =?utf-8?B?VkZFeVo5SCtUcU9YZkQyV25lZXlyaTZGc2JIV04yNStqWVM4OVhoZk0yZlQ3?=
 =?utf-8?B?QkdWT1B2MGRNUll3NmtlRUxXdWpLTkg4UzRRUEpQWWxKK2Y2RUpTMlFVZjUz?=
 =?utf-8?B?SjZvd0kxRVlPT01jYU1mSWU5UUNvQlBjK1lveU9LR0hwNDAwTThVdmludEJ5?=
 =?utf-8?B?dnFGL3RVK0kzbDJpY0g4a1FQZkYyQ2JGUG9uVUx0cnpuZWpPeWVZSmFDSHdy?=
 =?utf-8?B?czB5S2ZZcGZZZlpRVy82YVdiZUJnR1VVVG5uM3IrZzFkSkpJWnZxUVYvMHQv?=
 =?utf-8?B?K1VNRUZoUVlPeThCQUFzVGM5NWluWXhJRkR1NTdMUnMwRFpCTnpyeHFCRmUx?=
 =?utf-8?B?SDRsTzJ5K2M2TUVsTEVPZVRKeFRPS3VVU3l1NFNvVktxNzViZThCa3BLMHk0?=
 =?utf-8?B?WStLaFVRL1psVXJ0UXdXeXpYUXQrTGpHQTMwUUJodDhsbkxBbHVKblJsZzZn?=
 =?utf-8?B?OVlUbTFVbXdSU0pTbmpTZkQ4OVBtRkR0UnNvQjZrSVNvT3Z4ZlVCZ0dMb054?=
 =?utf-8?B?UjVuS2N0eWw3bnFCcnU4TG9MOHZ5clV3YXpTaitjUGt6TWlPejZrcDBrV1NW?=
 =?utf-8?B?UFdyRHVHSXlad0tPTlBTcGpzdEFwUnVwVHRMdmNlVU84dW9uQkNvR25LMUll?=
 =?utf-8?B?WjczZFMvTWYvSjRzMHhYYUN5Q0hHRXRBUVRmSEwrRHJVT3lVWUhzOTdjTTJ5?=
 =?utf-8?B?Tm9BdWhZdnEvSm1kWjMzZGo5MGNpTG9kZGIwWDZCazVpM2hqZjZyeTdnL01C?=
 =?utf-8?B?aHNLZ1VuRkZpSFJXOVIrWEZZVmg1MGNidDdhc2QxUXRTam9VZUJxTGNIaXhW?=
 =?utf-8?B?MEgwZ05MOXJOMG91YXdRSDI5VWdBaWwyTlJtQ0VVMmJXSXNUazRzZlFlN1RE?=
 =?utf-8?B?Q0FyTmhpOTVMR0hxVnBuZUtWdkN6MFNhcmdqLzNBeENCUlJjNVAzUENaOWQr?=
 =?utf-8?B?NllhRjFhck5ScUVieGwrUE9TZzhTbnVacE1Venc0T2tWdzltMHRQa3FqdmxK?=
 =?utf-8?B?N2dZWEJNZ2F2Vmp0TUFmVmRrbCtjWnhvdldPR3JvMWlsTDVvQmJPZ1lDYVNa?=
 =?utf-8?Q?0nBvb7k1s/SGFdC217ahu8/wB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee8edec-ec93-48f7-6ab7-08dc5f85e424
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 08:59:44.5519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czK5/RIo688fcx5xW+Px7c6p6FYvP+dWQaiBP2klGrd65h754oNEbDwhG5dfAAEB/HbDnEpT4AH5nTURhyKR5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5949
X-OriginatorOrg: intel.com

On 2024/4/18 08:06, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Thursday, April 18, 2024 7:02 AM
>>
>> On Wed, 17 Apr 2024 09:20:51 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> On Wed, Apr 17, 2024 at 07:16:05AM +0000, Tian, Kevin wrote:
>>>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Sent: Wednesday, April 17, 2024 1:50 AM
>>>>>
>>>>> On Tue, Apr 16, 2024 at 08:38:50AM +0000, Tian, Kevin wrote:
>>>>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>>>>> Sent: Friday, April 12, 2024 4:21 PM
>>>>>>>
>>>>>>> A userspace VMM is supposed to get the details of the device's
>> PASID
>>>>>>> capability
>>>>>>> and assemble a virtual PASID capability in a proper offset in the
>> virtual
>>>>> PCI
>>>>>>> configuration space. While it is still an open on how to get the
>> available
>>>>>>> offsets. Devices may have hidden bits that are not in the PCI cap
>> chain.
>>>>> For
>>>>>>> now, there are two options to get the available offsets.[2]
>>>>>>>
>>>>>>> - Report the available offsets via ioctl. This requires device-specific
>> logic
>>>>>>>    to provide available offsets. e.g., vfio-pci variant driver. Or may the
>>>>> device
>>>>>>>    provide the available offset by DVSEC.
>>>>>>> - Store the available offsets in a static table in userspace VMM.
>> VMM gets
>>>>> the
>>>>>>>    empty offsets from this table.
>>>>>>>
>>>>>>
>>>>>> I'm not a fan of requesting a variant driver for every PASID-capable
>>>>>> VF just for the purpose of reporting a free range in the PCI config
>> space.
>>>>>>
>>>>>> It's easier to do that quirk in userspace.
>>>>>>
>>>>>> But I like Alex's original comment that at least for PF there is no
>> reason
>>>>>> to hide the offset. there could be a flag+field to communicate it. or
>>>>>> if there will be a new variant VF driver for other purposes e.g.
>> migration
>>>>>> it can certainly fill the field too.
>>>>>
>>>>> Yes, since this has been such a sticking point can we get a clean
>>>>> series that just enables it for PF and then come with a solution for
>>>>> VF?
>>>>>
>>>>
>>>> sure but we at least need to reach consensus on a minimal required
>>>> uapi covering both PF/VF to move forward so the user doesn't need
>>>> to touch different contracts for PF vs. VF.
>>>
>>> Do we? The situation where the VMM needs to wholly make a up a PASID
>>> capability seems completely new and seperate from just using an
>>> existing PASID capability as in the PF case.
>>
>> But we don't actually expose the PASID capability on the PF and as
>> argued in path 4/ we can't because it would break existing userspace.
> > Come back to this statement.
> 
> Does 'break' means that legacy Qemu will crash due to a guest write
> to the read-only PASID capability, or just a conceptually functional
> break i.e. non-faithful emulation due to writes being dropped?
> 
> If the latter it's probably not a bad idea to allow exposing the PASID
> capability on the PF as a sane guest shouldn't enable the PASID
> capability w/o seeing vIOMMU supporting PASID. And there is no
> status bit defined in the PASID capability to check back so even
> if an insane guest wants to blindly enable PASID it will naturally
> write and done. The only niche case is that the enable bits are
> defined as RW so ideally reading back those bits should get the
> latest written value. But probably this can be tolerated?
> 
> With that then should we consider exposing the PASID capability
> in PCI config space as the first option? For PF it's simple as how
> other caps are exposed. For VF a variant driver can also fake the
> PASID capability or emulate a DVSEC capability for unused space
> (to motivate the physical implementation so no variant driver is
> required in the future)

If kernel exposes pasid cap for PF same as other caps, and in the meantime
the variant driver chooses to emulate a DVSEC cap, then userspace follows
the below steps to expose pasid cap to VM.

1) Check if a pasid cap is already present in the virtual config space
    read from kernel. If no, but user wants pasid, then goto step 2).
2) Userspace invokes VFIO_DEVICE_FETURE to check if the device support
    pasid cap. If yes, goto step 3).
3) Userspace gets an available offset via reading the DVSEC cap.
4) Userspace assembles a pasid cap and inserts it to the vconfig space.

For PF, step 1) is enough. For VF, it needs to go through all the 4 steps.
This is a bit different from what we planned at the beginning. But sounds
doable if we want to pursue the staging direction.

-- 
Regards,
Yi Liu

