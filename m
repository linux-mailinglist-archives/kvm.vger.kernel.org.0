Return-Path: <kvm+bounces-17507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E128C702B
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 04:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88624B217F6
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FFE1854;
	Thu, 16 May 2024 02:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iBaO35OG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03311366;
	Thu, 16 May 2024 02:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715825291; cv=fail; b=hHwTiwlZC4w/JN8h1G7KkUfNUh3LarpC9pXpaQtZCecgWO6fIJTzMLippRY5sNJ/CL/V8iThTdCV99rGkF4myLAvJtDPGaf2cdheGNP1gLGlwvz1gqvpEFhUoXcPXlUpP2gU3PP84eVyAV+PoPMsyi62i/vFVzbhl04txbgND6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715825291; c=relaxed/simple;
	bh=uAnUruLdrx5ZvjNOVibedcmimGp08MPJyKGXAZ9zkXc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mpYfHPUnSuUOZSooDJEjYh+pporF/R8ds7wT3XfPE2uzcd8XrhwKRNU3wuZ4iY8yRAXEAyPDPeBVt0dAFRt5rfV0rvEUMPXCq7azk3QWvd3hXw46pe3NzhjrYeVF5uM/GYPwX5NHzxaJcEDalZQMCnv4tbAId/4YI/ymxXShEsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iBaO35OG; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715825289; x=1747361289;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uAnUruLdrx5ZvjNOVibedcmimGp08MPJyKGXAZ9zkXc=;
  b=iBaO35OGCzvDndBwfOmmMWB2IlAPxHlooy1CJeXS31Oio4hbEO/Y9BR8
   Nk+hQoloweBtAhe+JThdlIzVymYExibmcrVh9vOIFndGGE+HR8eEsUJ9s
   xZS8B1sXUPQYBzksX8D+f8ETDNc64mMW3eS7wGygEsHwOqf7wwYsXOeG2
   kdqrdQvS1cN1qJRW8XUBXu+csDdVId01LozTdCvZ8VRrk+eX2M9eJ0SEM
   Fl9dWHYWUAdScKOqVwdHYPK+fQt8QtAm1RZvsawocF6gXS7WsWK0i8Yrr
   DfUgmhjeHD7j3LQsHO9kVudE+vSNDRwYichNKyduS/TzTH2DukNiPyxEp
   g==;
X-CSE-ConnectionGUID: LocubfRER5aZPMQ8WcUv9g==
X-CSE-MsgGUID: xobKR4WtSpib/hTdMTcTnw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23312918"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="23312918"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 19:07:49 -0700
X-CSE-ConnectionGUID: j6JryqY8Qn6S7U0aAcb/BQ==
X-CSE-MsgGUID: KHYezrGWS6CuaqA3wr2TQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="31193711"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 19:07:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 19:07:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 19:07:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 19:07:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 19:07:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qzlk7Q6LwgZT8ZVgJ1MCVLgkXc1gux6QGV1iD0OhOvQZZMiYO5EfhNPEq9rru/XpM2jiiekIMcL+USzEU3lzAdwR0Z966HHAsnKI4ts3QWpmUtpJzj4U2aXuefs5PVNjCTNzGhVXSnxEZoI/iJPNQUZJjl0gg64MSnjRO1JEUDaN1K4xu9UKFNxgPSUESa3wEkAMOgqouBPdsm6GXFHS69bo9tEWh1o5EMcd5Qa6lnLYLgCOeWXBHryakVeHxGP38t9mZfRDP61yvSTHbse8HnOlt9rLIde3mM9S0x7dH3OotA2nkPsb7sH/hbjUyo0X9CXqvdXVDCd7FNHut2QBTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxFF3uEid76uG0yZlX+GnBxNFFU1yEOiucwaQEVXfw0=;
 b=H0jjKGX6Mzf0HnODxVrpbU2RsjHZbofCSDb1VorqWOLq5NrfaDW/ebBgoxJLcOpibF2Bg2C4UnASSZ4wnk2irAiJNAvic1Mj1zgtCLp2Whzps+UVfetGpoSbr7Z0l6YKpgeq7JaZUNi1qRqBdiXaitQjw3pQb3vrmFKam9AvXjTktVYEQ3FHyrrThEsR0OxykUseEqELMdnNtBXDRPq6CnCv9CzCaJhC5cxtNkaYrVcmX/5W6Lo4/tD6P+qWUAb7M9r04b1aoVvhC+6P2Rsco5ETteZse8jBptAIyNdxEZ/DGr8GNn+pUkVWWtnHpmJ0ENr34TcY2srUSC9g64Tukw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB7039.namprd11.prod.outlook.com (2603:10b6:806:2b5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 02:07:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 02:07:44 +0000
Message-ID: <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
Date: Thu, 16 May 2024 14:07:36 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0185.namprd04.prod.outlook.com
 (2603:10b6:303:86::10) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA1PR11MB7039:EE_
X-MS-Office365-Filtering-Correlation-Id: 31e5b551-1887-4e91-fd22-08dc754cf986
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a0drMUhXOE1MWThrQmxTRWV6M284L0VXQ1VFNGxhRkJGcU9oRXNiQmI5MzJt?=
 =?utf-8?B?T2VETDMvdXEwRDNLYmtUNTRrSmlac3pBZmQzWGlyOG1qYSt0QTVqK1V4M2dM?=
 =?utf-8?B?WE8yNk5XU1lpdWFGMWp6QkF0aHN5N2tEek9JWmhYUXJNRGRXT0lydlBINTRz?=
 =?utf-8?B?eU1ScEh6ZHo0Y3JBeW0xeU9oOU5RQ2xZRmVJNGNEeVhpK3pCVEZyd2RyMzA1?=
 =?utf-8?B?eW9uSUJSQW55dk1nYlB5R3R5LzVTUWl4cWljbHpIZTNqVHgwRmdCZzQ4ZE0x?=
 =?utf-8?B?UXJxMUNOWEQ1ZWtOb0pHKzFTTEVDbXhOcTJudVZMTWtNTkVQQ1pXb3VZdnRi?=
 =?utf-8?B?SVh2dkx4MUpRZmVCYVRHNHdnb2J0WitjbjdpWWRPZ3VZcm5JV0N2Tkk2VUk1?=
 =?utf-8?B?eWxUcW5aZEtyekIvMTZuWExrWXh1RjQ0cVZSSjluQ0dubzEvU292Zmdjc3hN?=
 =?utf-8?B?ajA0Umt2dFpQSWlzZnNDVEE3YTQ3aE4waTlyT3NjL3E1YXcyVGZWSEpWRnNz?=
 =?utf-8?B?d25zR1piUFRjZWw2cFBrMlBXNnlOb2xLSit0V3hFQzY3bjBhR040SXJjeGpx?=
 =?utf-8?B?a25VR3YwS0VrT3E3WFl3Z1RPT0NVYUVETjhJWm5IcUN6Z3k2QkRmUDdQOVYy?=
 =?utf-8?B?TTVZcGFQdkg2U1FEWUN6b0xhR0JORmxpRE1sRUhqSW9hVVppSEZDd0NrMGlN?=
 =?utf-8?B?T1BJVEpkVms3TEFTSjR1NkpXRUhQa05qWHl0bFpmbUhoSHc1WlBJWWpEdGJS?=
 =?utf-8?B?N0VqYjNsVmZrWGhHakIvNWFSR0RCRURwMTgwQUxrTHcvNHlnb0ZaMEF1VXBs?=
 =?utf-8?B?UXlQWWkzbDlzbGpMeTNxNGpMMUM3WjU0NEs1WkplRU1oTlk1aEgxWnh5aXJo?=
 =?utf-8?B?TTdQUUxCRlpHZ2d3TVBwemJmV0hHTm1LeE12MCszK3lIdGtvUXpJTVJBVU1i?=
 =?utf-8?B?TTNaT1U5RWlWemtSMVV6UmtuL29CUXVybVlzNFlCSE4wQ2dwcE1kQ2Rxbk1J?=
 =?utf-8?B?bE5GY2hyc2NQYkFmUnF3emMwNnU5WUhld0pvOER3UFpzakl0VE9sOFBmelpt?=
 =?utf-8?B?VG1mSm5aY3FEMGpzNExkMVFocmFaeFd2OFc5Y0t5c0N0T1gzRHNVM1hQYnIv?=
 =?utf-8?B?aGh2NndUQjlGQ2JlMGtVYkYxbThQbE5UTUlTMlNQK0h3b1pLbHVHdUJGNVQ2?=
 =?utf-8?B?TnlnTFVIRE9WQVhKQnBvYzc1K3RrWnRGRzkrdURvSFBXWkl1SVFtd0JzZ1ha?=
 =?utf-8?B?L2FrTFQ0YUcwbHdIVUNaaTY0Tm5IRzkwNzc2d2NEbUVFL2Npa0FtVHV3aUhR?=
 =?utf-8?B?ZXp0a3l5Nm5rc0NWZ2Fxa3hlQkNSajVPeFprUUtnUjF0RzNzVzRTdlBxZGxY?=
 =?utf-8?B?eEdDeVNmZVJjczkxa3A2U0xoTm9zT2tuSUtkYkRtaXh0YmJGdVp5bVNKenNv?=
 =?utf-8?B?YzRUd0sxU1dhTEpkbXFubHNodWtndDlJTDVTK0FUeTJVandNRVFrTENYcCtV?=
 =?utf-8?B?Q2FJVWlDUisybWNKTFNxWUNsQ3pSbDJMMUQ4THcrTjJKMUJPRnBGRGNYaEF1?=
 =?utf-8?B?aDR0RVVoK1NKNGN4NTZBc2d0N1pCWE5NVWNsOVdUaVZ1QjRwM1pGZTVScXdl?=
 =?utf-8?Q?5RWzHjDuxh0Q58sP59tODhAvOca1/QLvmEho4BPhJbbs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTIrcjU2Tk9mSDExNnNmbFVCR2g1d3oyWFdpZCtjVThnZDd3eWJSK2JSekVx?=
 =?utf-8?B?TlpWenl2czBOSXNLclNGTEkveUMrUk5oVWJiMFFtRStWS3ZoNlBLbEx6WXVX?=
 =?utf-8?B?U2RkRXpKNEZ0SkZGMHdDeVY3d1lsV2g1TnFUaFRrTXZ6ZWRJeWp1KzdrREQ1?=
 =?utf-8?B?OGVkb1FmRFd4Sk1maS8wQW9naTZGN2lmZTVOZ1JmalY1V21ZT09meUpaRTly?=
 =?utf-8?B?dnd6djZCL29vOTFWb1A1enhuZTg1Y1pjMlRsWGh5VnFLelYxRjlvZENRdEdM?=
 =?utf-8?B?S1MzZFNaYTk5aU9wZXVoZXVxdXRObHhUSTROcCtNeVZMbExXYzYyb1ZZbTZt?=
 =?utf-8?B?Z0lFY0J3OUpYTmdrTHczWVhRNEZFRDRSU0F3NXJ0Mjk0dUY5WkFyK2sxY3FY?=
 =?utf-8?B?aW5ON2FRbUYzaWlhNVZidGdnUFdSenVVTnNlaXFSRTRpSURUME45dW5zQnNm?=
 =?utf-8?B?MitwNjE5TzNtZ21jdEJYdmp1akp5allpQTRZcnJhSWlhak5IdW5wQ3pIZWJV?=
 =?utf-8?B?QVh4eHB3ZDdjVTU4cmc2cUhhQjZZN3FZQjB1RWpwZFhGYzhYdkpZbm1oL2FU?=
 =?utf-8?B?Ry9YWXpackd6Ti9BU2dtMFhHWW45cFk2dTVGVmFsQVpsNERIdGRlZzc3YmR4?=
 =?utf-8?B?bWNCNEc0MDM1b0ZyM1FSMGh6Nk1MOWVOSDJEd05Eckx6QlhQS1V3eDVvT2tW?=
 =?utf-8?B?UDBsc1JhUEFBNUV1V28ydWFZYnhCL0tPbW9kK25WWndlTnNiVjlnQWxGcDho?=
 =?utf-8?B?NWNVWnc3MUZKTHgwajZrL1lwaFNwYzN0M2FYUGpueEk0Q08yWkhLWng5S3d1?=
 =?utf-8?B?WmRzZE9NS2VmMytnZXY5aEVmZE9YMmlyalcyN1RLZjF0eXlvMnhDK0duWTJX?=
 =?utf-8?B?RVY0Q0syZkZIcTB1Q1VmTjJvU2ZxMnJCL0I3MlJ2bnlZbXJvUWtOdGRuKzFw?=
 =?utf-8?B?RHBqK3J5UjVWemQxUUd1TmJvVE45R3RiT0RmSHhySnpIcjFjWHRCckZpSXFm?=
 =?utf-8?B?UUIxNlZpVWdBS1oyeG5ITFZrOU51SWJ6R212TlB0ck5jWFRUdjVBMHQ3U1V4?=
 =?utf-8?B?ZnlST0QrQVVEK0xQTlhBT3E5S2dPTGZiWVlla3VvT2FaV3hqUkNyT2I4b3hq?=
 =?utf-8?B?Z3hkZkw4a1d3Y3VVNFBHK21HQUhwL2FqckY3SytmNkhSZEJFZ0F4KzkzaDRm?=
 =?utf-8?B?dXA5T3g3Y1U5YVh5Ujd2ZnUwL2tuUjhQTjBlZ1pnZE1pbC85Y2tGS0UzdnJ0?=
 =?utf-8?B?b1JMS0gzOHlPZjdGU2FRUFN1NEFwbW1NZmVFUjNhc1R6UGNZTGtVWDFFbm9K?=
 =?utf-8?B?bDRrN1RWa2tRK3FUWUhFRVZGUE45UjNXRE50emhiZ3Mwc2x2N3VuTEQvcnlX?=
 =?utf-8?B?YmVYZGFVTk5RWHpxa1VyVi9hcFRFb1R6bVJOVldxeWIzUnJLQkRnUkNYd0xH?=
 =?utf-8?B?RzlnSVBoYVJjVlowUFY0WEFWem91YWI5WGdRaVNTS1h1b01Bd2FEYlFIdTFm?=
 =?utf-8?B?Mk5HaXVKN2F2S1JmNWVvQlNEeEJsNGFQN01UcTRwZStuYjVVUnlMRTExeE1G?=
 =?utf-8?B?UWlPZjNuR3NDNUlWV3ZjOWtGbkpSUDlZdUJ1K2JLQXA2bGhFTXl4UlFYbTcz?=
 =?utf-8?B?b2xQR1Mya011TEh5MmZJTlBsTjFYUnEwcDcyS0VqdHpKbDRMSlpVM05mcGYv?=
 =?utf-8?B?Z3cydWhoYmtvUG1qZCtQeUFjWFFETXBmblZRMDBOL0NFYXc4d1czbnJJUjBT?=
 =?utf-8?B?cXZaZU5KRDZ2aGRLK2orbGNLMUpUdUdvbGhPZEp0dFJNajV2d2Fjc3pTZ21z?=
 =?utf-8?B?THBLMVVSK0h6T0Uyc3BHRG1hVUl1MWJlS05DdFF0dUcwWkdJQTlFRkRIRjhP?=
 =?utf-8?B?M0pkdlNHNjZXelVpbzV4YmtDQXhrSGJIeFZoVU5nNG9LMElnRis3TlNRWFZW?=
 =?utf-8?B?Q2pFSWhRT2VURmFTQWlyM3BIeUtSc0t2a3pEUmdBOGxMUzdpWUpobGV6NklI?=
 =?utf-8?B?TFdzY3lZZmFPdmUvUDRKcnJGSExmLzVocDMzdHZkRWlWaGpQZ3dvVGhtS2tu?=
 =?utf-8?B?WTBadFFtUzJRVGlnelE1TmRvNkJXa2xGWFdhSnFaRkw3UDQyT01zR3hvdkJU?=
 =?utf-8?Q?1y9g5y0HOXEsPuPmR+xhCnlkO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e5b551-1887-4e91-fd22-08dc754cf986
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 02:07:44.6239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZeP3VVSfjD005H3yYxIP3f/4IFQVk+Xn33E3fE3czKaTpk9D4Z+4Gek9Vx0cM7CmJwBCw2VGrntgubPAFJ7n4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7039
X-OriginatorOrg: intel.com


>>> @@ -470,6 +470,7 @@ struct kvm_mmu {
>>>          int (*sync_spte)(struct kvm_vcpu *vcpu,
>>>                           struct kvm_mmu_page *sp, int i);
>>>          struct kvm_mmu_root_info root;
>>> +       hpa_t private_root_hpa;
>>
>> Should we have
>>
>>          struct kvm_mmu_root_info private_root;
>>
>> instead?
> 
> This is corresponds to:
> mmu->root.hpa
> 
> We don't need the other fields, so I think better to not take space. It does
> look asymmetric though...

Being symmetric is why I asked.  Anyway no strong opinion.

[...]

>>>    
>>> @@ -4685,7 +4687,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct
>>> kvm_page_fault *fault)
>>>          if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
>>>                  for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level)
>>> {
>>>                          int page_num = KVM_PAGES_PER_HPAGE(fault-
>>>> max_level);
>>> -                       gfn_t base = gfn_round_for_level(fault->gfn,
>>> +                       gfn_t base = gfn_round_for_level(gpa_to_gfn(fault-
>>>> addr),
>>>                                                           fault->max_level);
>>
>> I thought by reaching here the shared bit has already been stripped away
>> by the caller?
> 
> We don't support MTRRs so this code wont be executed for TDX, but not clear what
> you are asking.
> fault->addr has the shared bit (if present)
> fault->gfn has it stripped.

When I was looking at the code, I thought fault->gfn is still having the 
shred bit, and gpa_to_gfn() internally strips aways the shared bit, but 
sorry it is not true.

My question is why do we even need this change?  Souldn't we pass the 
actual GFN (which doesn't have the shared bit) to 
kvm_mtrr_check_gfn_range_consistency()?

If so, looks we should use fault->gfn to get the base?

> 
>>
>> It doesn't make a lot sense to still have it here, given we have a
>> universal KVM-defined PFERR_PRIVATE_ACCESS flag:
>>
>> https://lore.kernel.org/kvm/20240507155817.3951344-2-pbonzini@redhat.com/T/#mb30987f31b431771b42dfa64dcaa2efbc10ada5e
>>
>> IMHO we should just strip the shared bit in the TDX variant of
>> handle_ept_violation(), and pass the PFERR_PRIVATE_ACCESS (when GPA
>> doesn't hvae shared bit) to the common fault handler so it can correctly
>> set fault->is_private to true.
> 
> I'm not sure what you are seeing here, could elaborate?
See reply below.

[...]

>>
>> Anyway, from common code's perspective, we need to have some
>> clarification why we design to do it here.
>>
>>>          free_mmu_pages(&vcpu->arch.root_mmu);
>>>          free_mmu_pages(&vcpu->arch.guest_mmu);
>>>          mmu_free_memory_caches(vcpu);
>>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h
>>> b/arch/x86/kvm/mmu/mmu_internal.h
>>> index 0f1a9d733d9e..3a7fe9261e23 100644
>>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>>> @@ -6,6 +6,8 @@
>>>    #include <linux/kvm_host.h>
>>>    #include <asm/kvm_host.h>
>>>    
>>> +#include "mmu.h"
>>> +
>>>    #ifdef CONFIG_KVM_PROVE_MMU
>>>    #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
>>>    #else
>>> @@ -178,6 +180,16 @@ static inline void kvm_mmu_alloc_private_spt(struct
>>> kvm_vcpu *vcpu, struct kvm_m
>>>          sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu-
>>>> arch.mmu_private_spt_cache);
>>>    }
>>>    
>>> +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page
>>> *root,
>>> +                                    gfn_t gfn)
>>> +{
>>> +       gfn_t gfn_for_root = kvm_gfn_to_private(kvm, gfn);
>>> +
>>> +       /* Set shared bit if not private */
>>> +       gfn_for_root |= -(gfn_t)!is_private_sp(root) &
>>> kvm_gfn_shared_mask(kvm);
>>> +       return gfn_for_root;
>>> +}
>>> +
>>>    static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page
>>> *sp)
>>>    {
>>>          /*
>>> @@ -348,7 +360,12 @@ static inline int __kvm_mmu_do_page_fault(struct
>>> kvm_vcpu *vcpu, gpa_t cr2_or_gp
>>>          int r;
>>>    
>>>          if (vcpu->arch.mmu->root_role.direct) {
>>> -               fault.gfn = fault.addr >> PAGE_SHIFT;
>>> +               /*
>>> +                * Things like memslots don't understand the concept of a
>>> shared
>>> +                * bit. Strip it so that the GFN can be used like normal,
>>> and the
>>> +                * fault.addr can be used when the shared bit is needed.
>>> +                */
>>> +               fault.gfn = gpa_to_gfn(fault.addr) &
>>> ~kvm_gfn_shared_mask(vcpu->kvm);
>>>                  fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
>>
>> Again, I don't think it's nessary for fault.gfn to still have the shared
>> bit here?
> 
> It's getting stripped as it's set for the first time... What do you mean still
> have it?

Sorry, I meant fault->addr.

> 
>>
>> This kinda usage is pretty much the reason I want to get rid of
>> kvm_gfn_shared_mask().
> 
> I think you want to move it to an x86_op right? Not get rid of the concept of a
> shared bit? I think KVM will have a hard time doing TDX without knowing about
> the shared bit location.
> 
> Or maybe you are saying you think it should be stripped earlier and live as a PF
> error code?

I meant it seems we should just strip shared bit away from the GPA in 
handle_ept_violation() and pass it as 'cr2_or_gpa' here, so fault->addr 
won't have the shared bit.

Do you see any problem of doing so?

> 
>>
>>>          }
>>>    
>>> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
>>> index fae559559a80..8a64bcef9deb 100644
>>> --- a/arch/x86/kvm/mmu/tdp_iter.h
>>> +++ b/arch/x86/kvm/mmu/tdp_iter.h
>>> @@ -91,7 +91,7 @@ struct tdp_iter {
>>>          tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
>>>          /* A pointer to the current SPTE */
>>>          tdp_ptep_t sptep;
>>> -       /* The lowest GFN mapped by the current SPTE */
>>> +       /* The lowest GFN (shared bits included) mapped by the current SPTE
>>> */
>>>          gfn_t gfn;
>>
>> IMHO we need more clarification of this design.
> 
> Have you seen the documentation patch? Where do you think it should be? You mean
> in the tdp_iter struct?

My thinking:

Changelog should clarify why include shared bit to 'gfn' in tdp_iter.

And here around the 'gfn' we can have some simple sentence to explain 
why to include the shared bit.



