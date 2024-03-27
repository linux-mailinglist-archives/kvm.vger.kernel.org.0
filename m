Return-Path: <kvm+bounces-12874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A6388E8E5
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:26:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B3FE1F318AB
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64D8130AD4;
	Wed, 27 Mar 2024 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PpNmvGR1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFC912A157;
	Wed, 27 Mar 2024 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711552836; cv=fail; b=BuZ8b44x1RSHKQvOGsSIQvcngPsPkPY0hbGx1XwqtOGb9zCLHqFFxZaX8p92FJeD62oCuSRdRXAKdAkUkQRye8b1a4lpD+vaLbl4RvhSyKMWqAJgA4RGErCXN5naB8ZW8oFJ+BVD2MdRGpP52HZJvabxim2uu0fViK8Lqs4ZPSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711552836; c=relaxed/simple;
	bh=ZUgIFkug9CLoLpvVHNvNq0KyD8RJkYJE71kqhDGtUZc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y3Rfwl0JIZAeWXVrVv228SFhqWwxxlCwnWPqOPk6lvC4d5nQEZwILCY/BMMhYSbAskolyv/tmNo7diwdhLgpZ3ycbxO4KnuH/MLu7ihILzyZZmEgpai2B8Aa0dA0FYqYbP3+r0ivQrrsohOlfTvLi+L1fp7Zt1uwVQNXBjm7nc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PpNmvGR1; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711552834; x=1743088834;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZUgIFkug9CLoLpvVHNvNq0KyD8RJkYJE71kqhDGtUZc=;
  b=PpNmvGR1qOSFcQO4VjVj6y9dlvSSwq2WSHB18LH97sq03wR19UuNbhbK
   B9ZFyMI/toGxMfaERbhNDZiKgveSRnHGEzSmmrsrQDUrpDTSBmKqD9Eqy
   /p2+1BmspagLEEjWbiVynO/MPV9CBSJAo7pG143GocQ7EAp5zcdj7y9nB
   5IYQY2/v9KGVXEp1zIx37Il76ORtZ7I4OquELGFX5CvGci0M+TvtpW0a/
   HFarNBqPiWApHEh0RtCyEgxyh64szflM1fk1Vy2rhw6AKD22PPDP5HpCq
   xXdVJC62fs/w7z94n3+Qai/mxv6EESLN0jvbFhQK/Dezym6fz0HDpFgIj
   Q==;
X-CSE-ConnectionGUID: K6o2vfoAQ6i2lPtFXQjAVA==
X-CSE-MsgGUID: zbK9oZeMTzuT+o/NTJRJSg==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17804267"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="17804267"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 08:20:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="20859456"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 08:20:32 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 08:20:32 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 08:20:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 08:20:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 08:20:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6PZotyaA9LMN/zA4M1jcM7/DgjK2LcHOATiJdpU22eNz0YETFL4QWWKbi++miLN+6qwstHF8AWoZNpnVR78jMqkA2VQ+zPdMusaw6cT7gRqCjhwXJEuY6H2piGXSj3Y33WDpz6+sUPuztUwtUD4lzoPB4EbKFDXDuKyDbeuxbDWUiJ5VPoHs59XLDELy/fN9Z19x/7rPTa+qIyQspuU8Ve6OYnIiIa2n78I0z2a9l1Wdwto9Md+Jaajdl3AerOiFAEnoihZFSvaS5AYKw1R+BZ95Ca34goKPHkRgfsCMxSaCc4nccp/hQ9scw7XIoCl3FsiTp6u5Wc7P/6Jpi2KUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4m9AcOcZ49vZtj4ioEBjLzEG63NuUKPXAC9a7aB9vXg=;
 b=WHunsfBqFcSB1ZGIUnMh1lkx0hwmUdlPbj97G4WBtZ1pmNrNl0jiLO3ZXAqLWQKsajXranV0dRTnqsMFtjf4VVydR8442xW0L5uVjNjfYYucZx0tMIBwfOrRpWG3SB+68hmLWLuqtpiR2DwV07WnYpkHr+uyL/lz+7pn5ijACh18lx0LoDmDs/78dI2+oFX6jQNoeaZmENbQQd8IbLtfqTHRU7WZArzKvsphQ9OKf3kzycMhjRMBsXijPXR8IXGQ3MGD3cElBogkrva/9bGXf9UaVc5YRKF7KZiNhQxzdZfC4hGW6cqFS2vUoHow5Bntf8wR8yLJfS4/ET2S17qpKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB6967.namprd11.prod.outlook.com (2603:10b6:806:2bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 15:20:18 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 15:20:18 +0000
Message-ID: <ea33d2fa-6e69-4904-b5fd-ecec67e43352@intel.com>
Date: Wed, 27 Mar 2024 23:20:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 09/11] x86: pmu: Improve LLC misses
 event verification
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
CC: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Zhenyu Wang <zhenyuw@linux.intel.com>,
	"Zhang, Xiong Y" <xiong.y.zhang@intel.com>, Mingwei Zhang
	<mizhang@google.com>, Like Xu <like.xu.linux@gmail.com>, Jinrong Liang
	<cloudliang@tencent.com>, "Mi, Dapeng1" <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-10-dapeng1.mi@linux.intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240103031409.2504051-10-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0108.apcprd02.prod.outlook.com
 (2603:1096:4:92::24) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: d72c86ad-bd1c-4542-794c-08dc4e7168f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8fPOY9XsqS/Yke10xlJwzqrwuW1G+4NcN1TgPyl0rKpoFqriZoV1yfgb9DNrWZwjrhyuXFOhzzEMMtVRoPnQIlZcgR7XqWXa5JMWwGDx+oglrEZRNZxAIKmir3XPknPwABuYT/UZUvxDQIJfrzlkbzVDQpPt3WX7WsBOLRU3KIclmM+5Q/QZglQRmmgZWjYIGZ8GfzJpRklm+VNcDLdrM8PHwgMOBXFgDEJKzjnuvU4MkNJsIUf3nGaU4lqa3JPlVvKnvqn+q89bRvNmlEH+KsFU7kbNHWLJ1RldkscXXvU6p3EVhV1KqbYkci9cWmTCsTJByWFQ6zAhlJTkRzxHz+AqN6NYORqhHUnauGZ0f3exXillSW6gY7ezOkwqLM6nleuwRRK3x2UCxw4noC1oeFV2T60KfYT7AN5A9odk97J5EinTHq/ae7c+TJTKRCPkj7083fifvIjptZNDoiwOYXl4jTSDej/fkIvtwHY/jdhBUGDRdqkvnGyJmTPIVqaUOzvYm0Phpv/EjTtA0cEY2hen0C2GjuRsbi3gVBxwbP2M22NJYpKwJLLYLGXoyuClmnkj3Xf3WKRXF3PyORC8btNV+HBrp0ocIxsl1ypnfKkAhcK9aGSwiyaNqmxgzRjUN5//1zB/1QUry+cWDY0MNF0bpf6Al+7FUOmL8FvP+nk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1NwK3BJdlAvdXZsT0FZMlY0TGlsc0srNE9pMmYyTXZNL1lDNTlJVUVXbnht?=
 =?utf-8?B?blJDT2dSaExqRHZZcHlZZHordXVBYzNBTFVnRHIvWTJtaHlHLzBjVG0wWmRE?=
 =?utf-8?B?SzBnVXZEeGZ1Q2d0QVFPcEZJU1psdFExR2dITWFFQ1RmRjREWkpvRHh1WWcx?=
 =?utf-8?B?LzdLT1p2MjNlbjUrd2g1ekFZWEUvSlcwL0hqM0ZJbFZsRmllb3JPZ1c5b1Zh?=
 =?utf-8?B?clVyQngzQ0dWZjlYZkZCaVJoY2FxbStWazF1UHBmcmx0QzN5RDlOcGMxelE2?=
 =?utf-8?B?SmNGczVlN2FOcWhNeWoxa3VrWVBzVHBJOWhORUVXR0lhTWNLWGI2R3JLN0o4?=
 =?utf-8?B?TElYeVpZTmVVRlVCWmh1ZEpKbmQxUjlBS0ttTSttNkptM3Z1cThqaTNVRjkv?=
 =?utf-8?B?bEgwdjJTZWwzTDlwbUVlRDZJY0tMWnhoZnIxK0c4UjllV3Q0Zm5FKyt3RXgr?=
 =?utf-8?B?aUFKc1ExU3NvdktUMzAwTmpqU2V6OEN5MFc5Q1BoOFdkc2ZEV2Jzb0xuODZF?=
 =?utf-8?B?YUx5a0RKRFRQeWkwQXdSUUpXWlhVWDlOOVlwY3kvamVUR05EbWdKOUhMekc2?=
 =?utf-8?B?LytGNjdXRTV0NHY2TVNiazZ3bi9XK1VWVTFGVkhqS0J5SVJXUU4zc0J3ZUZ5?=
 =?utf-8?B?K25rUXFtSzB0bDJCMUJBbDJFY2FtT0ZwN0tCcVIyUmozdkpxNVpGZGZUcmxW?=
 =?utf-8?B?a2I4ZnU5dWFpNkMvU0pyNEJhd1lUOVlmai9EWnVFeldCWjZtQnZ4eGI3QnVF?=
 =?utf-8?B?Z3Y1NG9qLzZlUFh6NnZlU1cxU3J6QXZDWm9UdzZFNlRZK2ZyVHBRR2IzaFJN?=
 =?utf-8?B?TTVkV1BLaEJqUnhvcUVSRE1LaE05T1FBemV3WTBGWENKaFZCeU9oUEQyOEND?=
 =?utf-8?B?Nks3VXFiY2VDMUswUlc4QUZhV3FIQ05hTXB6WExLdk5LL1N0QlJsTWRPbXFT?=
 =?utf-8?B?WWVIVGN5Q3A0elp6c0NqRjVqNVVvVjRkb2UzdGo0SnUwZWNDeXVMcXBoVmVH?=
 =?utf-8?B?d0ozMHBVSDZvRlFsc0RJTyt0dTdRWFhtK2ZuNmJFd0lyL2ErUmJDSGxDcXV5?=
 =?utf-8?B?N2NYRXVwVXlOdmFJMSs3R29mV2lPNGVhVlV0VmNqWFpIZVErcHZkb2lFSnA1?=
 =?utf-8?B?WjhPR093UnZ6K0xWR1EzYXZIS2lEaXFvVmY0Uk9Wek5USTJZWUw3Q2hwTXFa?=
 =?utf-8?B?czdXRzZZaExjb01tcVFjVGFIOSt2U25IWkY3WmxVdEt3NnM5a3B2Uy9DVGRp?=
 =?utf-8?B?bTlON21uZ3d0dTdLSGwzNzA0MGdHajM3UW1WaWVFOEFKSyt5RGdWZ3Zpa3Ur?=
 =?utf-8?B?a2dRb0d5cHVIZXFkYVVMWWlwYkhRRjNxL2oreGNUWGJJcmFIWXdTV1d1RFVm?=
 =?utf-8?B?SGZPV05ZNGFLV2V4TVR0bERZbi9iQko1SVpKMFk4WXU5OE1DWWlXQjFRR2VP?=
 =?utf-8?B?WEF0NFJkNVY3ZERNWFRDeFpVclp6bi9RZ3B5QlIzWXhwb0k2YTZxWEg0T2kz?=
 =?utf-8?B?bUg0eEV5UnRFS1Z3bjdzTHFBNEY1ZXArNXMrV2V0YzBVNTZ4M1B0b2YrMkda?=
 =?utf-8?B?ZWlyc005blZZbEY1U2JjNXNFOHgyeWtyWTVwQmZzVHlUM3FiNEh3QXNrdXcy?=
 =?utf-8?B?T3A1Z0V2bFZYMm8zalFhYndYdDg0b3FEbENzQ2psRTRBV3lzcWZmS2hRWDZW?=
 =?utf-8?B?RjIwY0NOU0VLdTFPVUl6SXRTdmVFeDNrSWE3TjRoSHNwaE0vOWxhTHBtaENH?=
 =?utf-8?B?eDZjelhoMU1qd2NCbXdJQmRNUW5QQlVKUnV4QnU0ZkptWFozVHNaLy9NM2pw?=
 =?utf-8?B?QWp3ME1uTFR5anlsb08ydmZBZmtNOVJJM0lOUHh5MWxaOHlycVZDM0wxSmgy?=
 =?utf-8?B?ZkNlVEQ3WkNuaFh5d2VxU1luNFhjZHM1a0h3amh4cFhTMm83dWczTkhaZFZj?=
 =?utf-8?B?NFdKTndZa2xQak9RUTdRWmsyR245NGlTaWY5L3lNRjJIZW82Yi9jZE9xa1Z6?=
 =?utf-8?B?VEt4dk9CYWJEOGxrbXZ4Uk5XVjJTOVFYRFpCQmNEV1JkTkN6Z1V0SGxlQU9N?=
 =?utf-8?B?UzlPcjYwVDNJenhCS2x3Tkp1TmZaNTBhdXFjUlo2bXh3elNoekVFTzB4VGxY?=
 =?utf-8?B?MVkwTlk0RDM1NmpFaEQ1RlpmNWo0MzJSS3NTQVFUSHlpY2tabEZQekNuQ013?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d72c86ad-bd1c-4542-794c-08dc4e7168f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 15:20:18.1668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+4iNiN7rUihNdJSRmjB8l9AsdTfcFsYEJYA5JCWClZZRN3ZDRQZiccUvYaDuoMmbiMpuoKi6s9Brb79F97pjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6967
X-OriginatorOrg: intel.com

On 1/3/2024 11:14 AM, Dapeng Mi wrote:
> When running pmu test on SPR, sometimes the following failure is
> reported.
>
> 1 <= 0 <= 1000000
> FAIL: Intel: llc misses-4
>
> Currently The LLC misses occurring only depends on probability. It's
> possible that there is no LLC misses happened in the whole loop(),
> especially along with processors have larger and larger cache size just
> like what we observed on SPR.
>
> Thus, add clflush instruction into the loop() asm blob and ensure once
> LLC miss is triggered at least.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>   x86/pmu.c | 43 ++++++++++++++++++++++++++++++-------------
>   1 file changed, 30 insertions(+), 13 deletions(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index b764827c1c3d..8fd3db0fbf81 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -20,19 +20,21 @@
>   
>   // Instrustion number of LOOP_ASM code
>   #define LOOP_INSTRNS	10
> -#define LOOP_ASM					\
> +#define LOOP_ASM(_clflush)				\
> +	_clflush "\n\t"                                 \
> +	"mfence;\n\t"                                   \
>   	"1: mov (%1), %2; add $64, %1;\n\t"		\
>   	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
>   	"loop 1b;\n\t"
>   
> -/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
> -#define PRECISE_EXTRA_INSTRNS  (2 + 4)
> +/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
> +#define PRECISE_EXTRA_INSTRNS  (2 + 4 + 2)
>   #define PRECISE_LOOP_INSTRNS   (N * LOOP_INSTRNS + PRECISE_EXTRA_INSTRNS)
>   #define PRECISE_LOOP_BRANCHES  (N)
> -#define PRECISE_LOOP_ASM						\
> +#define PRECISE_LOOP_ASM(_clflush)					\
>   	"wrmsr;\n\t"							\
>   	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
> -	LOOP_ASM							\
> +	LOOP_ASM(_clflush)						\
>   	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
>   	"wrmsr;\n\t"
>   
> @@ -72,14 +74,30 @@ char *buf;
>   static struct pmu_event *gp_events;
>   static unsigned int gp_events_size;
>   
> +#define _loop_asm(_clflush)					\
> +do {								\
> +	asm volatile(LOOP_ASM(_clflush)				\
> +		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)	\
> +		     : "0"(N), "1"(buf));			\
> +} while (0)
> +
> +#define _precise_loop_asm(_clflush)				\
> +do {								\
> +	asm volatile(PRECISE_LOOP_ASM(_clflush)			\
> +		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
> +		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
> +		       "0"(N), "1"(buf)				\
> +		     : "edi");					\
> +} while (0)
>   
>   static inline void __loop(void)
>   {
>   	unsigned long tmp, tmp2, tmp3;

Can you move these tmp variables into macro's do...while block since they're not
needed here?

>   
> -	asm volatile(LOOP_ASM
> -		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
> -		     : "0"(N), "1"(buf));
> +	if (this_cpu_has(X86_FEATURE_CLFLUSH))
> +		_loop_asm("clflush (%1)");
> +	else
> +		_loop_asm("nop");
>   }
>   
>   /*
> @@ -96,11 +114,10 @@ static inline void __precise_count_loop(u64 cntrs)
>   	u32 eax = cntrs & (BIT_ULL(32) - 1);
>   	u32 edx = cntrs >> 32;

Ditto.

>   
> -	asm volatile(PRECISE_LOOP_ASM
> -		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
> -		     : "a"(eax), "d"(edx), "c"(global_ctl),
> -		       "0"(N), "1"(buf)
> -		     : "edi");
> +	if (this_cpu_has(X86_FEATURE_CLFLUSH))
> +		_precise_loop_asm("clflush (%1)");
> +	else
> +		_precise_loop_asm("nop");
>   }
>   
>   static inline void loop(u64 cntrs)


