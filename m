Return-Path: <kvm+bounces-18242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 650068D2836
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 00:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7A571F274D3
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 22:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C5D13E05D;
	Tue, 28 May 2024 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KLaDcYK4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD70217E8F3;
	Tue, 28 May 2024 22:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716936524; cv=fail; b=Wm/hVsGBHIakVnBIdLR9bpkKx8KndBuJ2f0vAGx4hpFjHMI6Ziui7CnggQaN9rbGMPivo85V8XgUwrfwk8l8Nw/ZDED5PYvtQljWzeU3IKCAPOaQX+NGY+dyrRw8ADDexuM2K3xLEc0yrVQdJ248vBmw5elG1sYkuUO+Glmpc0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716936524; c=relaxed/simple;
	bh=pRw0V/YbiV9giAtxSnAJoXbpm37s8/GWNum0YbUsqGc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dFbXsmNRwvOezRcEZ8Cjh6WQpgwA+v6abYfitydR2VSdiokEgS2E+fRyGjNaUqri3rZmCcHbPUIpwDiAaxq5l9CllZmqGDqDDrMThqW8qPMj1ei6DhGTRG3GhD/60S9kTSklKmXAYbl/tbAfktozHvj4qc7kpcVCZlGd+PyC6Fc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KLaDcYK4; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716936523; x=1748472523;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pRw0V/YbiV9giAtxSnAJoXbpm37s8/GWNum0YbUsqGc=;
  b=KLaDcYK4h2aK//lrAve09oFv6n1Xly1qI6kSCF6BeLSVBtPdMi6P+5cf
   nSiU/TB5PZIo+d9BriAr5NbQVdcaB0u5FuIi61VHi0Rlg1tFrNIrH9jG/
   aVyOdlnu5q9emaf23Y/IQAb/7IWNdlzN9/T65HilSfDqfDv839nTGHyaK
   BWFCviU92qGLPYiq3UaXF6/g7hmPPPRVnmfdM3T/ShL89PqcmsbodC6U1
   uWzuueTDgORwtQAtAc3J2IZfOslI0aZ/V46mGObHUE4qQjmnG/fMb7npE
   a+LMHdlzh4oLf/ugJrXxeEZK2wmvCVyTh3oKx2fQNgG77Bhm+cWaT55D6
   Q==;
X-CSE-ConnectionGUID: hsB/F6NcT1SEADd5V1URFQ==
X-CSE-MsgGUID: HGhqNbxjRcWgAuYUevkGYw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13187216"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="13187216"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:48:42 -0700
X-CSE-ConnectionGUID: 0/kH5DtkS22rMIP849hBqw==
X-CSE-MsgGUID: Qffu1z5oR5qpRHbO1lBQQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="35206292"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 15:48:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 15:48:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 15:48:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 15:48:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkQ2dqijpGvQv2Nla3V/6+CyCwRv4JKHIq0olE4X1IqZZkHGXwSqOULmX6G2ropYXrWDjJyApesbDCQcAcTuaA/DxnCl5qPHfMwgG3Fo4Gnj85R18yCf63PbaJ1PS+5Ssj6p943rFfzYhbSlIDlbivPK+d8ZdjaCOvJc/budJh7PkOvrsyJPXBletVmjCORJfDpfR4KhfyFsWj5X0HZueqQKf7qD+bZtyu2AQn3B+p4UYMqEVOuu1fs2BBBl2LF7fJqjR2WGSYiCXc2e+/gJjvfTgQBAtZNTGHXCuNI3yubMu5ibKxhfe1gCBr7Bmf8EvPidmLzvDaRURdkw6/8uQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/H04MWnbkMyUppWIMG6HyE87vvIPEznfkbv3bbM8sjA=;
 b=XwROKY37IYHioW0VMS7A7Nw/PUCQVaXiz7hMvujnbyCygfZZf2mRRf19IhdPkOxnHhHKbPgVbGkp1dPTSQG9dggv1cPvO8zHU8XuWPrfXkSERDLeBXbwtRa4u85VyqH2HxQn+DZTDmYCYfg6l8aG/4Y286IQw2DDOWp0r0Gk35LJehi/fQiAabJ5kVavKUJpGaXpaaSXqsqj3S4c6JFTq/bp6Ojkj/GP6DMPwrtJ0dq0BAtugydAyTi000WgliTwuuJSBuGKWnPT4EDlL/AXYCELdSlAIHIS/oajSspqOCLVll2ikjQf75dgQ/sO38EHPmlHsaDpJnnkZJKaVyAqsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by PH8PR11MB8037.namprd11.prod.outlook.com (2603:10b6:510:25d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 22:48:39 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%6]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 22:48:39 +0000
Message-ID: <bfb273b2-fc5e-4a8b-a40d-56996fc9e0af@intel.com>
Date: Tue, 28 May 2024 15:48:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pci: Add iowrite64 and ioread64 support for vfio pci
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: <alex.williamson@redhat.com>, <schnelle@linux.ibm.com>,
	<gbayer@linux.ibm.com>, <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
	<ankita@nvidia.com>, <yishaih@nvidia.com>, <pasic@linux.ibm.com>,
	<julianr@linux.ibm.com>, <bpsegal@us.ibm.com>, <kevin.tian@intel.com>
References: <20240522232125.548643-1-ramesh.thomas@intel.com>
 <20240524140013.GM69273@ziepe.ca>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <20240524140013.GM69273@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:303:83::6) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|PH8PR11MB8037:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bbcd029-9934-464a-8b61-08dc7f685102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dWw3TitDQWpjb2Z5eGtobk1TZWJjOWdNR0NLQVBlQ3RHZUtmWStxZ3M0dXZ5?=
 =?utf-8?B?ckN4bi85WUloWnNLUWlFVjNua0Q3SVJVRDNLZ29NMXJXWDhsaWFSVEJFK05q?=
 =?utf-8?B?WEZiTmJJbVZxOEdKUGNuZlNxN08rWFJseVVkV0NlMXBXRjJvdnFJTkE5UjUv?=
 =?utf-8?B?K0VwcVVYbFd5elQ1QklHTjczbnQ1bzhNcjdiTWNua3NiWXBEd3loTHBmQTVu?=
 =?utf-8?B?ZkRGUklXMy9LcEEwdXdvZEpRM0tRQWZIOVZRUEJ4VytXenRQU1lING1ZZjl2?=
 =?utf-8?B?VXpSWkphYmY3YWJ3bGVVS2NSekUrYmxZY2xxdGsvNWxxcGd3SU02SzRldUNB?=
 =?utf-8?B?RmR1TEljTkpNaURDR1o2ZUhXeFo3UnowOUdjd3JEU2twZHpnZ3ZMakYzaXMz?=
 =?utf-8?B?dEFmZFgxSGhpVHVOZE1ON2FiRGF6UllxRzk2MkluYm00ZmIyR3BkdjFONmVH?=
 =?utf-8?B?N0ZzYTArMXlwdldIenlLYk0zRWljR0hOWXFCMHZVeUlkYjhYVmxvdE5Xdncy?=
 =?utf-8?B?elBlVW9KNkRXK2xOMGQ4aHY5SU16MitIM250cXJXYlIzd0MxenFKa3d3UXg2?=
 =?utf-8?B?am9tckVFQWQ2YjU1OHdXMVRXT01XSmNMK3orTzZGaTg4TFAyQ1FtN1dwajIx?=
 =?utf-8?B?YUtoTTBRWUsxMFRMbURUNHVBc0Mva0taTXVPU3h3VlZmOFBFZExWdnYweFIw?=
 =?utf-8?B?K0hEamFwWmIwb0hTQUJtbjJEcXlrejYzK3JFMjkxSDNLaVM4Q1VLVXJ5MTV2?=
 =?utf-8?B?aVBoZ2F4RldWYTZHaXdxSkx2OC8zRFAydUlhN2x3Z2x1ZEtVMCtRNEYrMXpa?=
 =?utf-8?B?VkEwQitMSXF2SC9nOEtxclFSZFB4a1k2SldlL2tLREUvejZlc2syZUxXb3ky?=
 =?utf-8?B?ZFJ3eENuSlBTc0pBcnhLVi91TTdIQ1FKZ3RLL2Nza1RwV0NDbHIvdHB4V2pj?=
 =?utf-8?B?a21CeHpWbE4wdGJQY2F0N2FLdTVqTzB1djBhd3FMMGxlR0Y1M3U1WW1jMmJZ?=
 =?utf-8?B?SXowZUJlT3NSWldOcFZRcTQycUU3RWVaeVI3QndUSzI1MitjLzJkaFJoUkIr?=
 =?utf-8?B?bFlmYXVWbUg3eHI0UUc2TVJvcFlFN3dyMTdDMmRVcm81aEhXeENmbVFYYVEz?=
 =?utf-8?B?UitCZnUyWWIxanAzUVFZdC9mTWhFNktWc3NuWldUcS9VS2hzd0g2Ynl2MDdU?=
 =?utf-8?B?TzdPUnhLaTJZYXh5ZFcwSlBYcENHK2J6c0pDVEVSWDhyc1dXVy92K3lrdmwz?=
 =?utf-8?B?THhLVWs4U0hodXdIbmF6WkEwWWpJRXJFbWhqNWRIMm9aUkZYK2pUWWNJRDIz?=
 =?utf-8?B?aHg1ZHk1N2xFbEJQb2xtZ1NscUlTTmRtYWN3ZE1FSjQ5MzFUVWl4a2xHQW9W?=
 =?utf-8?B?elY2WXBDLzVGSTRqekhaMTkwejUrSEoyd2xzL2Z1dFY4SHlrZC9QVVZHdW9T?=
 =?utf-8?B?OVBpZGdOUjhCL09QcWVzdzBPQkhMQUV5NllmeXZzVDRRV1NLZ3RHOEswd1dw?=
 =?utf-8?B?eTd0bG5zcDd2SzVhNDZINm9JdHJFUmF2K0RTVmZlUUJDRGdMRWV1dGxSTjB1?=
 =?utf-8?B?OGFBK0FBU2VQTWhRalJvUTgrUkN2OE13SkNraFJ1TUJRbTlCYlh3OWtaR3hZ?=
 =?utf-8?Q?a1bpLoqowOZdbsklQaA1vL7wyzyCYPro/A+MYUdtSvro=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3JjVjJ6eHJlMWpZakhPYnQ5cXU0WGJic3pMY01WRmtEUm1vQ1BrdXczTHQ3?=
 =?utf-8?B?eDhVK3dvOFExOHZFMWZHTmU4b0w3dWtJSFVrcjFOYnExUk1GaUdhYmMrNG43?=
 =?utf-8?B?NGJGSmM3ditwVGs0SUlKdURUVFBaZXlxV1NacThLZjBqdTducFFGdll1SjZE?=
 =?utf-8?B?TkhnbTJJTjgyRmpldnBRVFlOV1VibmNkVkE0Zkt6bGwwSFc3WWNjenBpZGhQ?=
 =?utf-8?B?ZHVhMFpsR3dyL1RzdlNDV0dqNFM5UnkxRmF1TTZVUFkzczhpeW5CTk9kcWoz?=
 =?utf-8?B?ZW9WNVd0REtzeUI3Nm9OVjZQMG5LRmM1dm5PcWZNekUvUVBocEZMZHh0ZUxX?=
 =?utf-8?B?TnQ1THBnUXJrUkV5Rng3bytNSXRIZjhqYk1STDJHZFFFNm5YVkpES0s0azR0?=
 =?utf-8?B?UDdFRlRjYkE3VEFaQ0djclltR3VjSEJ2Q1RGeUlWclhpQWdtNzlUcHlNNy9M?=
 =?utf-8?B?dWJ3dWdVY2pBQms4VysvM05lQklnVFMraEJlaDlFMEh5OTBXZGtIRmdYSVdP?=
 =?utf-8?B?THl1WFpTa2h4NzNCcVFIOXhCdTBSamNtVG1wMEtPM0J1UkFnZEt5Kyt5QmJm?=
 =?utf-8?B?REhGbFlLWVoyc1gvTmd4TnBZUTg0NEVwVkxYVUsvaE1EY09Gengva1ZjZm1L?=
 =?utf-8?B?ajljcXc0YlZvbnI5WUR4TEM1ZHp1Nk50UmNuY0ZUdlM3TjVsVElUU2pXdWdh?=
 =?utf-8?B?WDV5d255UUVBdlc1SDV2NWNPdTlUV3Fpb3FOT2ZQaWkyaFZ1dlBxNmFkMjBC?=
 =?utf-8?B?emxvbXVvNW9RTFdiVWtrdjVlVnRjOEhEallRbHd6MEo4eTR3WkpSZ0RaQ3Ba?=
 =?utf-8?B?YmNxeVFIY0F6NnNuQTZCM2ZuR0RtSGJKK3BjKzdOVEpnb2xobHVEbUNJcWVu?=
 =?utf-8?B?SkRwZ3J0d1AzTkhjYnFjUXpkUHF4dGxoamtDMHM2MGtIZWVRZlJldzJNeDlm?=
 =?utf-8?B?U3BVNWlyU1RLUERONnlvcHMvTlRweXF6eWwxTnphVHdLNGd6SmM1Smx6YjJs?=
 =?utf-8?B?ZlBweGp6MUYwbmk0ZjVDZWZIVFVoRzJMeVl2NVRFaEppelArVTBXYTlKR244?=
 =?utf-8?B?ZytWQVh2SVVQaFZrZlV3Z0ZSOU10VkhaTFZ3QnpjRlNTcmpTU0haaTdJUWV4?=
 =?utf-8?B?NDJRT215SGdhMjFMMzhWOXJpUWpxRDFGcGtHRUxYTUFJbmZwY0wrcVRXR2pU?=
 =?utf-8?B?OThJWHlRd0N2SmxaUTBBQUpVSEkxNHQ2SDR2MGtIOUtrYk0ySk1vZzNEemtz?=
 =?utf-8?B?aGpOTFFPUDduamp2NkNhMFBITTJDZ3FhWDg4WFAxcEd2Y2kzd1dSdnBwSk1J?=
 =?utf-8?B?dWptWitEajZEbG5aam9BSVVZa2tXK1JEVkloMkQ1TkplS0ZldkpCeU5XWGRw?=
 =?utf-8?B?UU1VN1VvNVlGRXNxUkhGRW9KSERibG03eEoxR3gzYTh4Y1JuampXMzJuMlRX?=
 =?utf-8?B?YmNadVpyTmFheExJVnJENUdLSkF6TFY3WnhXbVg5RmZCeGhlN3BQOGlVU3U1?=
 =?utf-8?B?M2dxVnJtVVl0Zi9rdHRycFlXczNlWjlXalFvNXZaVGNFU3NnUStFTUZSdUxX?=
 =?utf-8?B?eG5SbFJSOTdwRGt6S28yYzBIL252RHJRaVRQeEN4cHYvZUo0Sm43OTFKTTRW?=
 =?utf-8?B?OThTQjcxTGFDeDNhZHdZVE9YVHl4SkhYY05BME1NS3h6cWZlOTBkZjVOQ1E4?=
 =?utf-8?B?NmhKVkdCK1NGRkplczlDL3VrcEZUd1prNFZQaWNiRDVCUzlibWxMMUk4Mkhu?=
 =?utf-8?B?d2d5Y2FKOEs0SVhqM2pCQ05jTXJIZUQxTzE3dEZZZnlYVWthbG9NN05KOGZV?=
 =?utf-8?B?QTV4K3lGOFl4d3h1azZZSlVvOE91dzRnTUlVSXFZcXZSdDZGRk1oeFJKZEJD?=
 =?utf-8?B?ZXhuRW5LZ0E0ZnJzcHI3ZHg4SXNGamdheGRpMFVvK3BkWEd2UG03TTJ0Smpt?=
 =?utf-8?B?UzdnKzZvd20vRXgxN0FSVTJYeG90aWJhWHVwdXZxVU4ybDRNSEgxRUZnSDV0?=
 =?utf-8?B?VTd5ckczR3VQbEI3Kzg1dEd4dEZCOGkxQlhPZHBpeUkyd2pGSytSMTdXTW1n?=
 =?utf-8?B?Nk1tNERRb09wT0M1UFBtdjhSWHl0anl4MVBQbSthZVd4Qm5nUXlYQzlvQ01y?=
 =?utf-8?Q?KV2GTdVgLx0yC6qY4Z2dJiAmh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bbcd029-9934-464a-8b61-08dc7f685102
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 22:48:39.3951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7KC5FlVFgBphANyDkfhzp//NB+Nu8QQcidOo/qmWCxTBNZ8Dwp1FOHD60+u89PzmXtPLAd3++S7u27DmcLi4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8037
X-OriginatorOrg: intel.com

Hi Jason,


On 5/24/2024 7:00 AM, Jason Gunthorpe wrote:
> On Wed, May 22, 2024 at 04:21:25PM -0700, Ramesh Thomas wrote:
>> ioread64 and iowrite64 macros called by vfio pci implementations are
>> defined in asm/io.h if CONFIG_GENERIC_IOMAP is not defined. Include
>> linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64 macros
>> when they are not defined. io-64-nonatomic-lo-hi.h maps the macros to
>> generic implementation in lib/iomap.c. The generic implementation
>> does 64 bit rw if readq/writeq is defined for the architecture,
>> otherwise it would do 32 bit back to back rw.
>>
>> Note that there are two versions of the generic implementation that
>> differs in the order the 32 bit words are written if 64 bit support is
>> not present. This is not the little/big endian ordering, which is
>> handled separately. This patch uses the lo followed by hi word ordering
>> which is consistent with current back to back implementation in the
>> vfio/pci code.
>>
>> Refer patch series the requirement originated from:
>> https://lore.kernel.org/all/20240522150651.1999584-1-gbayer@linux.ibm.com/
>>
>> Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_priv.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
>> index 5e4fa69aee16..5eab5abf2ff2 100644
>> --- a/drivers/vfio/pci/vfio_pci_priv.h
>> +++ b/drivers/vfio/pci/vfio_pci_priv.h
>> @@ -3,6 +3,7 @@
>>   #define VFIO_PCI_PRIV_H
>>   
>>   #include <linux/vfio_pci_core.h>
>> +#include <linux/io-64-nonatomic-lo-hi.h>
> 
> Why include it here though?
> 
> It should go in vfio_pci_rdwr.c and this patch should remove all the
> "#ifdef iowrite64"'s from that file too.

I was trying to make it future proof, but I agree it should be included 
only where iowrite64/ioread64 is getting called. I will make both the 
changes.

Thanks,
Ramesh

> 
> But the idea looks right to me
> 
> Thanks,
> Jason


