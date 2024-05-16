Return-Path: <kvm+bounces-17491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6308C6F80
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD446B223DA
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6B8A59;
	Thu, 16 May 2024 00:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UYNQwhvd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4003419E;
	Thu, 16 May 2024 00:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715819172; cv=fail; b=suNJ/V6kt53zRozv4VHLBal+A1mtDAiTJt4WoFMHhOSigD+uhgEFlWemBucOsVMgoPbM4qS+nBldzcvjl4WQC8rXz9ol2FFQFuXkd/GpdzotThvCSrs8++q/NcLhU7K7PYxM3X/Nqjlw+M6kbi55UJRya3ttt9RTSV4OX4ZOMUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715819172; c=relaxed/simple;
	bh=RqkmOLdbXXyonlxvvZ3UEJiFrpAgIJFaCdmyNX660Rw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OALoJ9W1ZtL5NSxmBhFs5mm+LuSabDk52tJM09wTQ+1mdNGr9dTrrRyaNXZW1P7XR0p2lKjD98rEhouHrpRR4kwJDpWENDe1ERdOPUXe9F2OMJcLv/FFX2Sbn+AngcWvbMIVFxaC5V7kFVSiW3Zvrk2chBcHTm4ehPmuUJF5PdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UYNQwhvd; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715819170; x=1747355170;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RqkmOLdbXXyonlxvvZ3UEJiFrpAgIJFaCdmyNX660Rw=;
  b=UYNQwhvdTIaokB4Mj8APJG+naBwBSG15I7I2f6GcbcDLibk/0kOmiJ1l
   cYfbln4EuHW0d91CFdu7ptp+Xx+cYHLHd4HMwkb7VhOQUx2PM7psoTHV5
   U87ajVLW3izho1SfpC7twzEoVa6qHo7H6Shd0bFoxrBEjwOsBB40u8VxX
   HBbNBY0z+BhdTOE4Tq3RkIBuvVWi9mj0o40otEJ6/Pg2k4t59Cb4ru9nL
   mqRxu5wts+qdMXVnFmxDa8NucdrhgVanW0Yymz6Qo5uXaP5UW28D2ohHa
   wglYAgBqhpptWBQ0uX/lKclC61Tm3X6UfLZWXyRGRIrdQPhKlNqpHWKra
   g==;
X-CSE-ConnectionGUID: +tfaihPtT2ObcdI48BG6kQ==
X-CSE-MsgGUID: AjvvnPVWT1m8c9bBnM03ew==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11752318"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11752318"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:26:09 -0700
X-CSE-ConnectionGUID: M4o9bj7FRCShGBrCHTARoA==
X-CSE-MsgGUID: fBErYhfxSRu4UNd9YVXgfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31168740"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 17:26:09 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:26:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:26:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 17:26:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 17:26:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoGZ97Ox5xeOrYpcytWRaTfD8t5mF5jlHAbZtTMUHzdVTq9CD1lWakZn2+Nol9L7yg8HD4TMeCOHO4dpbKfUMVkuK7NgdHNmfFPSE4Rr5SyMJnpFodY6KvvfyTiLyxZwzvDCgaulQM0Vg7cJOSD9U2/honwD5fFdU96NDcjj7o+xBJfeDwFW5suy0+kcltMXabjfVo4PEkSHdre5Jy47d1l6FGiCi1tShqNZmUNzATIHEcs0Bbzmj6XYhfQaxp31JV/DAzs1W1ZwZ5BUMyXvb2feEBWzDxUKC5+PRCzYySC26TvJRqkVnSyf/xF0hJ2o86DCDpH9yQ/tRRDuB4zUZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ep7MS8bGYE+gEfE+9n0yf2PlPqlMjPjbLtUKV9Dtu0=;
 b=crvh9vKmridX7iqVZPwYi+5PoHwp2rBhwxtv+miUSFKs2xIdEnt7b0Y8R3CSxBxBUbqfAsnqP9t7MutJxVTX/mPZ0xyf1u5j2zlzt38Jey215ashlmetGb08m69NryZQUwTDACuTttDvQm8A/5UfwzpIwvo75xrKCgXNG8MAnSd5HR3aLeT+zE675Xr+d8zt5he0M08GLxKoDVgryc5jWnZolr6o3AzgVctsfieiIVqNpwcKhL+OQM0GUs2n2YFlvVDRh26DiwC482OtBpEpXLM4MICEBAdYLzJKjgu5plWU4XOEEbw5507MDOFAIwO7Hq7jEVps9u30fFk+DzOXnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB7610.namprd11.prod.outlook.com (2603:10b6:806:31d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Thu, 16 May
 2024 00:26:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 00:26:00 +0000
Message-ID: <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
Date: Thu, 16 May 2024 12:25:51 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "sagis@google.com"
	<sagis@google.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:303:6b::17) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA3PR11MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a2ed0c1-85bf-4e1a-f2e7-08dc753ec35f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TTdQQVU2RHVnSWhhUmxMRTF6WEROQUlGSFRsa0NuZTFlaEZ4WXg4OTRKcFh3?=
 =?utf-8?B?aS9zS0Z3R1gzWEQ0Q2cveVJXNFVZUzJQam9rZ2d4aExrL2JIc29hRDh0c2pk?=
 =?utf-8?B?KzB5Y0E1ZkdHcytVMW1GMnNhZWxUdWlDVCt6cUwzUmNHVUN1VXhqMEJUbDh3?=
 =?utf-8?B?ejBSZzlqeXY3bFByWFpWcFZRb0EwNDFEZDZ0ZWNseEhXajZmek52MWRvQ0kw?=
 =?utf-8?B?cU1MdC9YZVcxSWNQbmUycWo4RnZjaE4xK1k4dUg1VUFmN1AvTHdOSG5TZytl?=
 =?utf-8?B?TzdRandqTDdqZGd2Tmk5cER3Q0w1Wnk5MlRMUHJMdVRUOWIvc1B6TkJGZ29h?=
 =?utf-8?B?blBvSjh2MVltNy9SbXY3WE1ZVWxzbytwanRldWNwdExaZ0F6WitFSWdjQm5y?=
 =?utf-8?B?dkZaNmJyeDNrNHJMem04dlNYUUYyMzYyQ3grU085V3VLZ1BuR2dqMmQ0a25h?=
 =?utf-8?B?QzAxN2tvK3JHTVRBU21zZXZVakttU0V3ZkFteTlGTTdXOVFzTk9JOHRqWnI2?=
 =?utf-8?B?bkJBY1pmbGplOGdxM2tPTWVkYjM5dGg0bHdlYmZobFdIeW9aSXZIVkU5YWlW?=
 =?utf-8?B?RkFYUHAzY3Y0dGwyZEYrRHdNTm1DOVZ3NlJFSGlKejVBNS8yVlhwd0wrR3Ba?=
 =?utf-8?B?V1RaZ29JOFFNc1BtZmp0Rlo4RE1rR1NqS3VpRW0rMlk5TEVjQnJDQTgraEp1?=
 =?utf-8?B?TnZDMFFpQVVMVTFUY1NEQ09sS0xWR01jWEU2U21IMXMzeEVZM2J3ZmV1Zlp6?=
 =?utf-8?B?ajhFSVlkN2dyRGhxa29zZG52aHIxd1FKQXRNSU5TS0hRVlEraG15N3Z4bGZw?=
 =?utf-8?B?a1p2alhnektzTXROV0ptSjNHZ3RjeFdjYm55MnVqNXF6L2lsQXNsUlVOeC9P?=
 =?utf-8?B?Um0rOW1HYlQ4VXhwYUM4cllSekU1Z3B5d2xYZ1M3Qk9ScFFZS21uMXYzTnA1?=
 =?utf-8?B?d3FJTVpXS3pnZytDcE5YUEt0WCtJNFlBZ0tqeEFOMVZDYkYrd0Y4bmZXVlVI?=
 =?utf-8?B?RFhKamtZc29lM1MrK1hrZmFBcGhzdlpicXNwUWJKL1Rhbkd1aEVHb3NuREYz?=
 =?utf-8?B?UWNTc1JBZ0FYakp0TXNYcHdRNW9xQVBmYmhPS0pXSDZ4RW0wSDhMTHR0c1dl?=
 =?utf-8?B?NGU2WXRvM2w0UGhYNWdFNWNlM0hsUkJWQjBKRURLdDhsdlRQdXpiSE9Ja3Rx?=
 =?utf-8?B?d3hDRU9CVVVxdzF3Rzl2SG1ZdkJNZk5xbW03TENKb3c0d2RXdGF4UE9haWhs?=
 =?utf-8?B?STZnb3NXYnNyUGF4MGRqSStid0RJSFYzYU1ZVUFVUlUwWUxIUVl1NmFxQ21W?=
 =?utf-8?B?VTZ5YWdFZStVY1hGbEpYb3dXVGJWT2xmakJhZ2hZeW5CTjlnem9HTGdxZjkw?=
 =?utf-8?B?elVKbTNvOUhkRTdXSWZqZldEai9YUEtzL2QrYnhzc1ZLT2RnV0VMZVpmT1k2?=
 =?utf-8?B?SkRheGZTY05PbnJONnNYcDBvdWpVL1QxT0N5a3RxSmYrZWdWaVVxMThLa040?=
 =?utf-8?B?anJZZ2NNUks3eGg4OXFnbC9rOWhHTDFYNm1rQSsxdm02b3lGMUtWOWR6Vko1?=
 =?utf-8?B?eStUSmwwNTFYWEF1SFFMN1ZValRCODdxbFp1R1FaTWJlazcxcnB3bDR6Uys4?=
 =?utf-8?B?aU5LSnJvZ1NsSHF4dk9kK1lMcjVJdDJHcHczMFgvN3pqRmFseVB2NHVQR3ly?=
 =?utf-8?B?MlhiQVo1N3l6bmxXOEFNWmpZajlvTGw3Kzc0WVVhQ0QvaFBCcjlKb1Z3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHFTaVlyc0liT2dUaEtKeTU4K1ptc3krS0xiQjRxbEJFQW1hVkNyaGM4eEZz?=
 =?utf-8?B?NVpURkJFRksxSTZybUYyM3RZMUdtcGExakFTTGxMSGZyR2w0eFIyVVZwWlB6?=
 =?utf-8?B?Y2t0SVMzYkJsaEQ4c3llZnFiS3dEaFRxZXVlbFVWV0VFMjdRQ2VsMWsxMDhx?=
 =?utf-8?B?blc2QTlSZDMvdU1CV0E3dmN2VEtHdnB4c0xUaXU3dWhCdStIZmo4TTdrYXdQ?=
 =?utf-8?B?ZTl0cDEvYlFHckxSWExhR0x5OW9OVHJMenp0U2ZqWllwdU10WEVRYjlzUk93?=
 =?utf-8?B?SXVVS2hyZ0VyQ1V5eTNucStOZGJuY0FQbjJKcnN6eGxtQlVKc0t1TzEwVVRw?=
 =?utf-8?B?aGdUWkJSRERMeTltM09SNGN2MW9mWldiNHJGTmJ5T1FGQnlqSnUvNDJDNWlH?=
 =?utf-8?B?RVpORVo2eklMYk4zSVh6aGRvSnIrc2prMUh1dTZzVTFvcGIwRDNFSGVhZHND?=
 =?utf-8?B?RFk3azR5dFBsTWdNKytRVm5QWUg3TEVwYmNLWlk0SEU5RmZuZ3NLcktoYmFG?=
 =?utf-8?B?K1lmK0d6R29UMTlJY1hlcFZyY2g1TzRSZGFkQTM1NFl6NHNLemxtelVjVHI0?=
 =?utf-8?B?UUl4bTI3Y2ROMGllUUg5R0tMRmVKRThzekNlSkhOb2VXWWhVelFrcS9xd0o2?=
 =?utf-8?B?NUtsNW42cFBQYVV4ZHU4cXIxVG5mR1lETjQrOGFNM2JER09Ia3gvUjhxRjdV?=
 =?utf-8?B?OCsxUFdyNTJneVIxejc4czNaN1dqQ3pwQ3pEcXN5Qk5EeUxLQ2xEanU2Znor?=
 =?utf-8?B?Sy9MUnNsWFpzUGJWVkNJenkvRnlvQitNZ3pLUC8yZTB1LzlHZWNFaDdHWDZZ?=
 =?utf-8?B?TWtJWmJUZlRueENOOUc4REpERzZLaWNYeUVSSHk2UklYbm9XV1NDV252SVVU?=
 =?utf-8?B?bUNjaGM2RnF4VUpQbm1kVnBLZzEwMG04RjMwVnRJM2poMm1vT0RYSUszZlRh?=
 =?utf-8?B?a3RPZFArUmJ0UDJmcnBrT3VOQmZDRlBRb0h3Z3RLVitGZytwNy9vTzhibU8v?=
 =?utf-8?B?OFRMbDFSWnRhVlNrQmpOQzBRMXZ1cDNVU2dNVXRWK0VpU3NzVWRyQ2R4cjlk?=
 =?utf-8?B?U3g1TmZZckx4dVZqOXh6YlhhY3dQQmpzYSthL3ovQ1ltYmJPZUFuUzdHNW83?=
 =?utf-8?B?U1U5UGdaOUJ2RFlKWjR2YndrbVE2RCtwaURvSHRDK0pjYm1RTXpDMEUzMlNN?=
 =?utf-8?B?T3BZdHZyN3ZtMVE5OUEzbSs0QXVpOWgyMjR5V2FhdFlMVWx4U2VZR1pobE1o?=
 =?utf-8?B?VGVHTnFRU3AvYTJYSkhScnM5Ympmb293WVAxNzdCTWRmdXlTbjN3UzlxNzFk?=
 =?utf-8?B?dDBzVndrT2p3SDlNS29NWFdDMVJ3UUZHdmwyOHoxRHAwQ1UrZXhldm5PSFJl?=
 =?utf-8?B?RlY2M1dnK1lYR1d0K2g2SnFoaExNelRMdWNQNG5PZnp3VkVGL0tYWnRHMytO?=
 =?utf-8?B?K3gra1c5bGhDci9kNzZka1FPeVE2MEE2blZJMENHWW1QR3FaTC9ueEc2Zi82?=
 =?utf-8?B?UUlUcFN2S1JySmJzdlFGYVlmcUVwTUh0RmNSaXl4WU1RdkxIR3l4RGN5bCtj?=
 =?utf-8?B?TEhBeGZ3SzRrUlpyemJ3Zk5lWEV4Vi80cDBqYzFkQStGK2tzcTBjbUZVcXhy?=
 =?utf-8?B?SEVPNW84Q2kxWkl0UXZCVXR3dEUyemxieitWZ3kzaGRKNVFMMG0wZzR3TytG?=
 =?utf-8?B?dHE3RVpaMkF0NUYyUDArVzVBMVBNSUFkbExRaDRWM2V1Y21GWFUrNTdFRWtl?=
 =?utf-8?B?Q3FiaHdhS3lhcDRoRWV4VTFGYzJlR09KZjFFMThsdzZYelRad21sNjhhcFRS?=
 =?utf-8?B?Z3A3TzEyL1Rwa3R6MlFodStzN3BiRXJRYmkzbG91bU9UMHFuMTJyckVmMlVT?=
 =?utf-8?B?bUs0eUxZVDZoWHZkVzV2RlE0NVNOSFZTblp0TjAxTlhuYm42UTUzcStab1l1?=
 =?utf-8?B?ZjhrL0UvdGJwUERYRFVnN2ZvcVVvd0tpMk1OWHpFSldYZjI4N1BOS1ZPTFRu?=
 =?utf-8?B?Q1hIanQyYUFyYlZqdEU2WitVbndQVzdSRTNSQmtoV284L0IwU2lBdXBwQjBH?=
 =?utf-8?B?NTlBU0V3ZHVTVFBaL2dlSVVRNldYM0VWMTNtMWpScVJsNkMrTERwbXZiYm5p?=
 =?utf-8?Q?F1NrwXelXLUTW1AV0vyDClFYQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2ed0c1-85bf-4e1a-f2e7-08dc753ec35f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 00:26:00.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BiF7rEw9PF9B8U2dYebHTjvFyeiLsOlWRNzzObyy8wVUa3NbpHLsSnXEaB1kZ150vkTplesKUSwUydpqQsskhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7610
X-OriginatorOrg: intel.com



On 16/05/2024 12:19 pm, Edgecombe, Rick P wrote:
> On Thu, 2024-05-16 at 12:12 +1200, Huang, Kai wrote:
>>
>> I don't have strong objection if the use of kvm_gfn_shared_mask() is
>> contained in smaller areas that truly need it.  Let's discuss in
>> relevant patch(es).
>>
>> However I do think the helpers like below makes no sense (for SEV-SNP):
>>
>> +static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
>> +{
>> +       gfn_t mask = kvm_gfn_shared_mask(kvm);
>> +
>> +       return mask && !(gpa_to_gfn(gpa) & mask);
>> +}
> 
> You mean the name? SNP doesn't have a concept of "private GPA" IIUC. The C bit
> is more like an permission bit. So SNP doesn't have private GPAs, and the
> function would always return false for SNP. So I'm not sure it's too horrible.

Hmm.. Why SNP doesn't have private GPAs?  They are crypto-protected and 
KVM cannot access directly correct?

> 
> If it's the name, can you suggest something?

The name make sense, but it has to reflect the fact that a given GPA is 
truly private (crypto-protected, inaccessible to KVM).

