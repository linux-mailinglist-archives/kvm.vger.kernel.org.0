Return-Path: <kvm+bounces-17508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A57578C702E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 04:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BF332837E7
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705C31862;
	Thu, 16 May 2024 02:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V1wPb590"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382A71366;
	Thu, 16 May 2024 02:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715825459; cv=fail; b=ewFRgoCXfJKVLbGWnwvDeWDxk+AsAQ11oYK77j6UenLPa8xSeOn2hZznl3/JBwodlzcy/iPtKVIkAcJy6iAiy8O3Kxzhb2L3wQz3S3l8uHGAGWkRMtZ4AzzCxQHA0axVHLOJZBcC+6i4XQLkwfrg69hzvRsRoNStmK5z2dItsKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715825459; c=relaxed/simple;
	bh=8iHCbXRXGFWqNv3qlJY8NSdQ6gsk6JuoC+GkuQj5wt4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S3U9a6fzEqY96oaGDQFC/5DJI6NOBCfn/qEHYKRlDpC2MEPlinOTlZmQPFGAjxhV2WbuC7io+9cz0p5bNXoORWl7+FV4DzjxJc5xMzOhhKcNy5PKPXvcbUryp2I/5CoubG3jTrCJrGCv1cdBNB6+tWa4Oh8AHRv/+coIHssMZVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V1wPb590; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715825458; x=1747361458;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8iHCbXRXGFWqNv3qlJY8NSdQ6gsk6JuoC+GkuQj5wt4=;
  b=V1wPb5908ib5ZJGxVmc9wim+K+YHHe3qM8CHUSuhKc8O52QNjpwd5/xX
   /1+QJiwhbSBbbjgoUXhMeL+tneEXaas0zrntrbORpGSq1D0spK1qPVL76
   QDRMG5R7Ubrrq2PucVGYYvhz9jONtJchIAF7jJRM6kpldq/o7luz1nvUh
   m4fFU0J49B458jubSyb8D0txorvB9BSXu+p94s9TJraasd1RWu0P8w02H
   VN14h/b0Ww1E6hXmP2YuTo24qqyuJoW+1qVohn72cDAEL4O8d9uB0Hwo4
   m9q4i2epUHzAvQq3h9GEv5bZw5msS9BX3e1CcC1J+9oa69eeGy567k9tT
   Q==;
X-CSE-ConnectionGUID: R1mbPkRGRjGl3G74CpXA7Q==
X-CSE-MsgGUID: Ou0A0W66Q9GK7Rl6+uI2Wg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12122608"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="12122608"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 19:10:57 -0700
X-CSE-ConnectionGUID: Xiv1RFx/RWehaS2YuFpgjQ==
X-CSE-MsgGUID: wuWerOxDTeW3RZVQneZFYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="36139519"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 19:10:57 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 19:10:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 19:10:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 19:10:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yi9BVT4423Lka5Fz9paBLhzwYFuY/0JGU8vRzDZbVIhqZeewhzbJxoDGaBQJIAcKrH0qXb0uQbVU9PBu/8Z9vOG2zTfEcWyi0O2uK6MLPtgOttepWHDPh6U4RLyRZm2//5/lH4o2xjvJ/JPjdmfLQK3pP78E4AJAOnjk40xDzGG44J7F3ubC9q3+GXZthc2GySvFjyWyQh535LZs+p2A9W4oSauyNGMRPVYx+dG5LnfpzuKxHcl44FSQXMyDssFfKWBY2W+2jifiUO6bPtJdzY1765El8DfhsA/yYn2MaIsU3g/+vDa2XW+JPLRPwZsyvWqutO+YfSxdWxe1BxRpzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxsP+ZskzyndE+loAlGy00fGfzpgxRF0OqYU56JFXng=;
 b=TyuwndKj6+XETrVCgTTSdBEvHgkjPsJ37Awl92gtt+L5B5a45YtBHiYEEij0pYZERxNBJ4CO10VJgNqLOZ0fB17x6903ALmc50A+LoqljVHk243EGbJVv3miaztVHC/OKEX59aXpIn9RaYbBrtWYszfVAr8fnnJhaYp/mKPsqmkFeb/zdCTAAMLcuJ9fVHq6uD4Jy6TyYC2p3GUVI4xZ0eg/8U0RJnNZAZl0HSvm1tMi1fpWL0CnH/m8pwywHz0jEAglnBsg9wj6Lj5goze+xEsI7m+WSW+pHPGzquKw5QTnHPDNGPiyXcI0vQj0fYa0NE/wVmcJr2LGqReRQKUZ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB7039.namprd11.prod.outlook.com (2603:10b6:806:2b5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 02:10:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 02:10:48 +0000
Message-ID: <b6e8f705-e4ab-4709-bf18-c8767f63f92e@intel.com>
Date: Thu, 16 May 2024 14:10:41 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <20240516014803.GI168153@ls.amr.corp.intel.com>
 <c8fe14f6c3b4a7330c3dc26f82c679334cf70994.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <c8fe14f6c3b4a7330c3dc26f82c679334cf70994.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0363.namprd04.prod.outlook.com
 (2603:10b6:303:81::8) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA1PR11MB7039:EE_
X-MS-Office365-Filtering-Correlation-Id: 257971ac-86a6-45c5-9ed8-08dc754d674a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cHRic2k0dUUrcVM1b1hXcXZYaklzekdNZnptN2VLU2l2a0tNQSt5dGlEYlMv?=
 =?utf-8?B?VWpNbEMweWR0RzBWU2FDTmVTRTVncWNLVzBKQWJxTi9GcVlEZmJ5bjYvOUsz?=
 =?utf-8?B?cDkrUWtmVmdSR1BrUk9IZ0dCc3pRNEs1UWtNT1JBRjFISDZWSjBTUjhQYklF?=
 =?utf-8?B?QnBINXY2UUw2Y0VnU2tiSm8raUhJbDFvbno3dkhOUkdQVXJXcGFDaFpXNEMr?=
 =?utf-8?B?VlZVcFZmeUk4K2pXc3JYNi9OUkUxZkN1bkJQSTlwZTIyVGtJaDVHT1VaeDBq?=
 =?utf-8?B?Ym5SQ3VxNW5wWGVtT1dORWRKNlJobTUzUkx5QjNFK1U1VmtKajdpTmV0RWF2?=
 =?utf-8?B?ZXlPVzBhVmkreTBGWEV2ck4wZ1FjOStFWEtqeXZWcmQ3SnpjUGdiR0w3MDJI?=
 =?utf-8?B?ekRZK1RqL1o4d0NhY1ZiQjVaZmhCT2doM0w0c05PNG9xU20zN2VZMXdTdnJF?=
 =?utf-8?B?MFhnY0NTQy9MQk9qS2wrZXVSWDdITkg5aXkxdmYwUnRBenV6K09wazVVbDk4?=
 =?utf-8?B?UE5qZk9JNWNYNjlIUEFBVEFzZGRYMTNqamV4QnFFR0pMaGxXbERyZnlDdEw5?=
 =?utf-8?B?c2JhREJLenpEU21oajhSejh5VnBBWTJzcStqRmRGZUVTc215T1VDRVNBWEo0?=
 =?utf-8?B?RHFIV0UvSDVBcEdiczVaZ0pkOHRBQ3FPS3VWVEtGNDhMalM3eDgxRnNGWUpn?=
 =?utf-8?B?QmpjK3BDVjNFaTQ0TmZtME84MzdzaG1tcE9GNjdxQW1hd3Z4Y2xTMlFmN3Vk?=
 =?utf-8?B?M0txdUpndjZLVUpuejFtTmIwb0FqZzB2SmJ3NVFmWmpjdWpvY0JOYXpCTE1N?=
 =?utf-8?B?YWFIclJpSloyeXBIN1RzenZSQUNTdkpFOEp4b3RLM1E2WldpRG9hUmIrR2R3?=
 =?utf-8?B?SlBnb3lMYXRsbG56MFMrYlNjRnFVNUVOdC9YNnltKzM0TzRxTWE2a2kvN0JM?=
 =?utf-8?B?ODdMdmFPSE4razY2RHMya1JEcGhGMzJoNHJNRzdibXpKWVY0blMwMENGRzJs?=
 =?utf-8?B?SnhnUVdNRENhdDRsVzNwNG92bExURXI3MTczVWd4cFZQSk9GQ2NyajkvYlBB?=
 =?utf-8?B?enBjYmNGbk1iVXZkcVFleE9CRkZoV0pEVEE3WFJJTlVWRnYyVzJYSXJSd1Qr?=
 =?utf-8?B?dVJoenBzdzRCaWh1eWNiSE16SXFPNGg5M3ZIVVJFa3dPKzd2K1Z4eDRWOEli?=
 =?utf-8?B?OE56eXFya21odzcwblJtS0pIdHMvdmdSamFjSlNsNnhoalh4bWRSSncxbGRr?=
 =?utf-8?B?MW1tYytjTVdiOER2SGh3cy96amhzOElPa3E5N25ZOEJEYjV6NFlIbVF5WXgv?=
 =?utf-8?B?VWdwZHo2UjNlRmVobDI2cUVja2Y3akw0TXgwZTBEV21wcXNVZXA1Wnl4dmtu?=
 =?utf-8?B?SmVWUUMvaWxDWGJaNWw2eWxEek1MSEdYWGUvc0xGRFJLNkFDWGVadGtMc0dT?=
 =?utf-8?B?R0t3dkFIcGZxUFNNTm5la1MxaUhkdTM1a3EzZUZadGMyZkcvUnpMbmc5MWIr?=
 =?utf-8?B?cFExZmhlRlNSeXJUUm94K29tS3FXM05pbFF5OUYrNG44WEJ6MHZZS3VnS1JT?=
 =?utf-8?B?RHpMZzNZYjU0VUZ2TURZLzF5TytaSDNEMFF5bDA5b1BqOEFEQnNuQ3lmNHpt?=
 =?utf-8?B?YkU0T0UvWUVzVHdkdHpZcUdSeU84ckE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2tmWXdBdENWYWZocllRaHRhVTZRWWJZT0F4TDdxM29lM3AzNE5NUWdmYU1M?=
 =?utf-8?B?RXRzakI5YlR0WHRVdmwzeVFtS0pMUHNQeWFaZk4yRWx2WFYyajViSy95Q2N0?=
 =?utf-8?B?S3hCNitFZHBONWJVSk9tN3NBZkRCbVdsMC8rdVFuR25kWldyQ3JuNFdkMDRZ?=
 =?utf-8?B?b2ViVzRJRnNlejkrRlAwd0JLaUcrSE80Y0VlZ3M0S09LeVZKZThmdGRQSmhX?=
 =?utf-8?B?bWo2K1lsbkQ2QnEzSUtKYnJNZkluYWRvWk0zQUh0V2RsYmswR3NaUUIvQnRw?=
 =?utf-8?B?ZDJKeDdMWWQ4SXo1NFNHMWlybHFva29VdHJOTEN6VW4yOHhHNzFBdlRya1dr?=
 =?utf-8?B?ck8yZkVobDRiL2QrQVpXM0dpMnlDcXdqa3dyUU5zVVZqQ0NZT3RKVU1EaVR1?=
 =?utf-8?B?OWlQcDRWdGF5Wi8zanZtU3NFMm5PSjJ0TDgyTzNFQ0FIOW1heXpGOWhWTksv?=
 =?utf-8?B?VndRTGZFZk5hUXNibll2QzNSZEprUzVJYW5xWTcreEtPUkQyT0J1M2JRYlBS?=
 =?utf-8?B?MEJpUEMySmY1VUsrcU1WMjA3VHNwdFFnYXBVN3pFQ2lWUTAyd3Jsa2xDaGtp?=
 =?utf-8?B?bGFiTllmcHFzc3lsZldaMVJ3cjF3SjJySXNUOWFvTkZGVUVzb1JjUmdYeW0y?=
 =?utf-8?B?TXNpWHNUNkFIRW5TZUY3SUJVV2RBeEpzL3dyU3JJRFY1TFBsQlZGS2FDTGdZ?=
 =?utf-8?B?Uk9kNFVONWhMK2NEelh3UzlnT2xjK0UzYkp1dmFhdTFXbXhibGhsZDVsSDZM?=
 =?utf-8?B?UEZycno4bzhkWWdzbmFQQnpFZUlZb0FvSkNNZjhtOG1ndzZPQ09pcnQ3Q1pn?=
 =?utf-8?B?SWF0VDlvTjFTamRBNVRiQzRLTEtlYnE4VEdBM0g4SlZpR3dvaG5MU2NUUlRj?=
 =?utf-8?B?SyszY0dORUVlWmEybklOclYyYUFSWHhha0RMYTIyMzU2ems3aVlwdWhrK2Rz?=
 =?utf-8?B?YUV6RXQ0SnVpQWpDSjhDcHJXb3VMSjJpOWhPeWd2ZEFDOEVSUk5kWWo0Qmhz?=
 =?utf-8?B?L0l0UDZBM0VSSU52b0EvZGpJWklNRGVoT3o4bWhNUitHb1VxYUtEYWtvOTRy?=
 =?utf-8?B?MTJSdE5aZ2V1YklNQ3J1WkxHYjl6QTRYRUx6bjA5aFFFbm1jNzdzbWg4NHFo?=
 =?utf-8?B?dzR3cUhwRGhGd0xZOTFrK0xwVEpJaUl6MzhpcENmSmpWMDF1T084ZFpuMUk3?=
 =?utf-8?B?Z2JUMm1EK1A2TUx5ZkY4cFpXYm9YTE5XaGdyYk53akkyOVExMHd6cUU1MUxm?=
 =?utf-8?B?U3NsREdVcEhiaTNJQ0xpTHNYT3hoMVhCVHhCMlJMcVZhblF5d1lNUVVSamNX?=
 =?utf-8?B?TUVoNXEzVFZhTFdGZDRWL0lCUE96RXpqWXJHZDRyUlBVQU8wMGVXMC9JUFBJ?=
 =?utf-8?B?M2h5MmN2NnhMMzVscFp0dE5UZnFWeGRiUDQ3OTZadjNCVUNWT2p3UTBTOEtk?=
 =?utf-8?B?Wk9YU2F6WWxFRmpKdEdnTVdudnBUZXM2OGR1czJock5HY0VpRkVFMEw3YSs3?=
 =?utf-8?B?djNrd1k2SmRJZ2paVDZ0TW43c3lYVnJlSUZiRE9vVnlKZlhUMmpaNnBCdjhV?=
 =?utf-8?B?UlBOR0VscWFsUXJTUTBFZytYUUtUWUt0R25oQXBtZ255Z05RNThLcHpsOStp?=
 =?utf-8?B?WXo3Qk9QckVEV2dQcFJjOFQwVjQ4TUdkdno3MkQyZEF2eDdWK0V4WGUvWC91?=
 =?utf-8?B?MlVmdjB6RmtieGM5VUx0ZWwra3pnRzFUakZ5eHg4NnFzUlNmRWU1aDFrMk5C?=
 =?utf-8?B?a0xWTkxCWmsxUVhsYlZMWFpZakhoYVkyTHk5TlpLUkJJN2JqS0tMT3gwMnhB?=
 =?utf-8?B?RVRSdnlXejRNRVdLSHFHZ2R4djVEMkVacmNFL3RGR2gvUXRvT1ExQmlYRFJv?=
 =?utf-8?B?cVJMemM3RFo2WHlLU2hyQThXNGNoTk50MXZMOGJIRW43UVZROU90RzBwVmdz?=
 =?utf-8?B?K2tLQU80ZVpNMkIzeG1CZ3ZGZHhJNHAxR3BkV1piQUhETXQ3SUNQa0RuTEFQ?=
 =?utf-8?B?YWVPWXU1YlkvejNKT2JnejdzV29nN2E4WFJzWE1nM1VWbXVFQUhmR0VhVm5x?=
 =?utf-8?B?VnByRlpGYkI2Mld0YjBIRzlTNFhNK2t4aTgzWWNzSW1zeXZ3dldRRmsyRHFz?=
 =?utf-8?Q?xsbMs8+/8PZadpzaVGJd8qssu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 257971ac-86a6-45c5-9ed8-08dc754d674a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 02:10:48.7324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Zpmmpr+9fISWniUJhLMK2oPiC2JnEVkQOconKMXd6fWVge+evOOYDrxqu6uU45XI1wMvfL6quRcEUkSeKb/KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7039
X-OriginatorOrg: intel.com


>>>> +       gfn_t raw_gfn;
>>>> +       bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
>>>
>>> Ditto.  I wish we can have 'has_mirrored_private_pt'.
>>
>> Which name do you prefer? has_mirrored_pt or has_mirrored_private_pt?
> 
> Why not helpers that wrap vm_type like:
> https://lore.kernel.org/kvm/d4c96caffd2633a70a140861d91794cdb54c7655.camel@intel.com/

I am fine with any of them -- boolean (with either name) or helper.

