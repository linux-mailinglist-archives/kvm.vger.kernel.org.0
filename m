Return-Path: <kvm+bounces-34036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A1779F5EC2
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 07:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B45DB188B014
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 06:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460C8154BF5;
	Wed, 18 Dec 2024 06:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UoJxIYj/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A17C154457
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 06:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734504348; cv=fail; b=dgyeveJtQCLmY6Dgh7FYsE2byL7eUITwUzGv0K3V1a9ao265gYYRin6WT0R9QSu7KYLIAbDNFsNAa2GfZBXdAuQ2X6ddhUbxMcPAX5SMbIL6DBJJQM/Uhw4htBhOBV5dADAfviRh9AsuBqBIm21XAP6JAcHoGrq2uOz2q7wzo4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734504348; c=relaxed/simple;
	bh=aLB3a4j+mCUCpnTUcZvuh2jnjbmiEbVC8yPxaDtHIfw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Wnu9VLEpCVlRheQQkh/nsxi5BVzRrQa0r/zkIDar+Mi/LrDAwgcI2inl7MI4QucwlX+qvMWVYt/bLRFz+ddcjONbYGzjOATrsvjoOUl3Q+QFuYHPZwdyHy2q416q50LIJE9SplhEY1V3CncBj/mW/kF7lLDHB0guiXmcPsqG0Go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UoJxIYj/; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734504346; x=1766040346;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aLB3a4j+mCUCpnTUcZvuh2jnjbmiEbVC8yPxaDtHIfw=;
  b=UoJxIYj/IRPZIfnyqotqk3nZXHNO0IXuDd/SEUZHxOvt6K4U8C9x+Rbx
   rzFxyaBw8jQg9/Op5cjPr8igxk25zcsE6ktAFG+r4002ZVwTQUYup7tDx
   4QY/1pH9BJOv6agdg+Ssbd2G6jHmM8j27WbYMxFgvJ4mxN8Cfs98SliV5
   i8WT0cn+KxU4PoFQgDFnn1Mx7BTPPY6sPCNkE/YyIFpDE4QyBVAlcKQnB
   5bi0P3j5JST8LWAi/rKwmQ9B9LXSqHwzwKihZ/icgosvw6Pp3zTHOWfMo
   RGc8Q/Ojgd4bRgxf62q2ZhmiaQEkfD0q2c1Y2wYOEyz6pzOWwqexvxyGz
   Q==;
X-CSE-ConnectionGUID: nI7WwWFNQiSu4odfLdMPrQ==
X-CSE-MsgGUID: MzqFA911SYG7YbQEwW4FMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11289"; a="37800015"
X-IronPort-AV: E=Sophos;i="6.12,244,1728975600"; 
   d="scan'208";a="37800015"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 22:45:45 -0800
X-CSE-ConnectionGUID: uXqtmZ0URlan8GOEPEi/LQ==
X-CSE-MsgGUID: gcrux4WoSU+E+blpo4HZEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="128747237"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Dec 2024 22:45:42 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 17 Dec 2024 22:45:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 17 Dec 2024 22:45:40 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 17 Dec 2024 22:45:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/aDiw5+re3yVC0HyClRygzpWa2ULcXLj51y/nmfO0cMJ1+FZnVGjflov/uBrkScZbK4LThQgs2nDlP2/H+DLzpc5jqpDEjAtsMzHoZikY3PYuipCiBEiZ3/QmqXjDJQUYGJO9hAftCglE/vv+a6NR9MThXnOTuk4kFe+1aoNtKpV4GM1DNeXKUuARZ208G8o1MK1rjTAuN+zOqMS+UZ0bfSyFtPxF77xWSjnisFr7sdVQobKPX0gGVw2i4X80W7ssyu//kc7j7sQyxlvSjxBktbN5fKDVbzn/SH11ODBylJiDGUl1xf0PHF74to+SIrKSA87bdSyFOxq6+to+AM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZMo2sihx40RddUTaTAfsil/F6/ehq/Wto8FAajinXQ=;
 b=rhKASRcYzQtIsqNViDi37SgRGDPR0g68uEQKF9dOqlfDRcVskb2IlU9AeAOqdwERCeLBaiM6am8f1e+G1Sx4+Fy2DtxN1oVqd2Se1hYcc8J1CyVYZj1L77KFVIzGxCCPNYmbE+Km7u4RAI7I/eSQ/JXW89Svkx11jfEBT4kR35DxS7l5gNDFySisrco7OlfCR8j3Aw3GeMbBq+YOdSB0gJN81qT95G52iamhcMLi4FSk11RGxqY6j64645QuxXYDppfFXuFLGtsvO5I9++07NU40r1YWUBvoAAqkv0CeepvvQvifkzEy9DaBxn7W90JWoLwmbjH2Xj8jI7F59FG9Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SN7PR11MB7419.namprd11.prod.outlook.com (2603:10b6:806:34d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 06:45:33 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 06:45:33 +0000
Message-ID: <7ee7534e-223f-4629-8523-622db551b66f@intel.com>
Date: Wed, 18 Dec 2024 14:45:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20241213070852.106092-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0237.apcprd06.prod.outlook.com
 (2603:1096:4:ac::21) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SN7PR11MB7419:EE_
X-MS-Office365-Filtering-Correlation-Id: 88a9bb02-3506-4ef7-4360-08dd1f2f91c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bHNrcXRRZ1hGSW5oemlLRGdkNGE2dldpenBTOG1FYTdJN1NKd3R1UEc2OVNK?=
 =?utf-8?B?ZWtBbmcxamtzWk5WUCtvdTV5STZUVWZhMU5xRUNydFp6RHdRZEN3bUgwa3Vt?=
 =?utf-8?B?UERlRW5pK3JkWGZBZWkzcFVGUzg4cjI2b1hJZ01wSEJaQ0VpWkJ1V0l0djd2?=
 =?utf-8?B?d0tJOUV0QkVlRkJqMnJCcVNWMm15SitEM0oyY1J0dE5ZL1ZXaVRKbi9yMjVt?=
 =?utf-8?B?eXlic0p4NDRRSW9tZVB1TG1PdGNqK2FTRnVYUHNDM0d1M0ZDMFlTOHc4MGQx?=
 =?utf-8?B?Zmo5djBHQUErTTJHa0R4YTF4K2daU1NLN3RwUjVRbnBNbmdoSGJzZmxoSDlK?=
 =?utf-8?B?WVBaWDhCNzRrQVIzVWN1NmxxRlRyc3BxbUpQMSt4S1RNYmNOc1YzNTE5VU01?=
 =?utf-8?B?dkRZU0hBQXYvdTlJc2FRYTJtTnMxR29DMkMzWHQyZXE2Smt0dHBxbEZneFEv?=
 =?utf-8?B?WDMvYUo3S1h2dklFL2NiSkoyczdJZC9xK2phdy91eW5CdU16WStkZmJ4bGlr?=
 =?utf-8?B?NWFXUWNNT1hFY1g0WlQ1eFl2NjEwSWNqY1cvMnF5UGE1NjJ0MlJ0UHZaN254?=
 =?utf-8?B?REgvVGg1aVl6WEk3c2xmSi9YOHNsRWF0Q1hxNjVZRWZCOWJGbHhENG01RWpH?=
 =?utf-8?B?UGpLeDFNMXFUTWlEaWhydUlmdTZhUVNLRFZJaldzNDZHbkYwVmdpcUZKMTM4?=
 =?utf-8?B?dUE1TU91bHpGZzRmbjFCRWo3cGZHRkZuaGEzQWZ5TU1Ga0MwM2l2cVl6MGdo?=
 =?utf-8?B?VUdXcGtTY0VkMU1KT3pibDgzMWRhZFcycGJydmhtbVFwN25tOEUwMXAwdEtG?=
 =?utf-8?B?djJUSE1MWk9pdGw5ZUkvQ0l2UTFRU2xyQjMyUGUwY0Q0WElYWXR4RkhlK0h3?=
 =?utf-8?B?MjRCdnRpclhKdnJMRkJsRCtWODJRK29FbkhUOXNIeDZTaThaRU9ZbGYyRlh3?=
 =?utf-8?B?aXEycDN0djV3aWg1YnJYZXNOWEFPaitHZlNrS0dhRXMwdEtuWkdBaEdpSWl1?=
 =?utf-8?B?ZkphbFI0Q0h2eTZoS3ZwSmtPVCt1VW5HWlBqTVUvZ244ZW8rc3ZmLzBVT0oy?=
 =?utf-8?B?S3QwZk5xRmJXYjRYcFB1dUg1d1RHY1VMRDRkVlN2NmlKV2Z1MFBpV2hBdDVj?=
 =?utf-8?B?QnR2MkNSWWx0VHZVNlNkUGk4dW1lVjdLRHpCMGlTTlMrZVBVRTRiazhPTWx6?=
 =?utf-8?B?dDA4d0xhTU9jOUh6WHpzT3hVTld1TStyS2h1OGtkOGxBdEtqdzBVUG1pY056?=
 =?utf-8?B?RnFWZ1pOdzNHVmFtY2ZJZ09hVXdKdUxDMUJOSVdScFV3SUFZNTNXekJOSmVJ?=
 =?utf-8?B?U2tsKzBCZlZMMzlLNEQ3WnU4bllMeUtwcmN3NUs5ZjNkaUg5U3BXZW5KTnE0?=
 =?utf-8?B?NldOYm5uemJXUmNXZUQxdmxobzF1cjdrMURxWXR0Um80Ymh4aUNLazNqakFU?=
 =?utf-8?B?TUdjTEN6SUw2cVQvb0pIak1xdW5JQmhFcFNMRS9pcmtOa3lYeHJ2UW1RR2wy?=
 =?utf-8?B?YndxQk0zMS9jRWpIM0FFRzB2bmJjRWdGZnV5WHhZcWhpQjNDN1hUVEg1Mlhi?=
 =?utf-8?B?a0lsVks5SmNDVlJXLzJ5UHNTbDZHNUlRTGpkVytVTy96TVNEMEZTNFcyamlY?=
 =?utf-8?B?UTgyTkQ3S1MvMWpoYWhzUWhmNmNQMXdMa2dMbVdKUXVwdk15eWFFT1VHNjJu?=
 =?utf-8?B?NkhuMFRZbmhMRWtJU1ZETWt2MjdXNTZZRVFRdTRVdXFWbC9DZmhxVEE5TG5y?=
 =?utf-8?B?dFcrL28xSUZ2Vzd4b2lKdTd5blpJT2lVUFhuMWZDdW1qZ09TWDhEaFh4cjJj?=
 =?utf-8?B?Y2hpTy9VRUVXenV6R3VDOEdFMFQ1WS9xZlViNkc0Y1JoVCtlR09FdXFTNlBS?=
 =?utf-8?Q?2r+ZrBWvzdSWk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SksxWnljL21pUnozMzhyT1ZNQ0l6TE5OUjRSSjcxZ2dCcGpuSlUxY1ZzWklz?=
 =?utf-8?B?aG0rd25ScWVRMGs5N0pXZHdEV2RpeEEvTGw0TVpJY3hOTFNOekNwSnZNU21n?=
 =?utf-8?B?NURrR1NycENScHhNb0J1RDkyeVBnRjFHTXlDaGRoMDBkbCtrTkliVEw3NDBS?=
 =?utf-8?B?cmtRN0kyMEd6cG1LYjdMekpNUWRoaUJ0blRXS1ZTMVlSeWhoL01admhvMFBl?=
 =?utf-8?B?TWJpODlDbncrc1F2bWFmVEFxOTVRaXg0VTlmMjF3OVlhMXBZcVFHU3lUcHdh?=
 =?utf-8?B?a1IzZzVSS1NCYjJGVjZKaWF6bzhEVFY3UmIxbzFUOWkrSUNsUzduaExHSDlC?=
 =?utf-8?B?bTNEckh4blRaeVNVemgxUGhtdjJoT0JCSmVGY0tnM0Izb0M3Q0ZNMVU3REN1?=
 =?utf-8?B?cDNuZUFJdUxzY1hxa3AzTzIxZlFVeTIydkJCdjBONE41V1RCczBKUEI1a1Rx?=
 =?utf-8?B?MFhYRHlPSVIvNHE3RUVaWGVheDBxV2s4VUZvTHZMZlhKUW1lMGxWWk54Nk0x?=
 =?utf-8?B?Q0NNUVFDSHIwMktaNW1UeUkwdkNlK0VPbUViWXVMTTdkS0M2eGt6TC9wbXRy?=
 =?utf-8?B?N1FJTmQ2VEp2SDNoWCtKN2xWbmgwYStxcVdpSUtGODY2M0hwbGgrUlFpaFJs?=
 =?utf-8?B?TGJDU2RLYVlqWVlJUEowTzN2clRXUkkzT1QzNWt4SWp2ckRQY3o2NDJsMklL?=
 =?utf-8?B?a3lSclZxU0ZsOVJsRk1kMWtzZXRybllxSTM3bEhPOTFFV3lqR21ENk01Mkh1?=
 =?utf-8?B?NlJiNmN5anVOZE0xZ1RnWjB1VmJHbWYxWURqS25UbHJXOHVWR1JkSHNPU1Zh?=
 =?utf-8?B?RVhiSEoyZE1MWXBMb0R3WHJSWEdJeDNZSjV1T2JJR3JXSytPTXYyU1pjM2Rj?=
 =?utf-8?B?VWlIRkIyc21odzdsMS9oUDdrQk1sS1BpMWNuN1Z2NmRGWVhxWVNtem9SM0VT?=
 =?utf-8?B?d3pVUWl1eEJTOVlwNjk2L1RaT0hIc05jOVROTkJjT1dvQ0M1ZmE2a1RTOVpq?=
 =?utf-8?B?UjZ0VnZ1WmN5SkVFcFRvN0lvWHhhdTU5NCtDR3MxS24vZm5uOHJVaFRicCtO?=
 =?utf-8?B?NGpSOURVaExoWlRXQURPeWRXWU84TFU0YUZRZzVROUx3OCtraWZXL2RKRitk?=
 =?utf-8?B?M3RFdzJZSDBYOFlyUTlWVFhmOFZxNkVkamtMMm94ajVOc1paVFZVZmlLV2pu?=
 =?utf-8?B?ZUlhVE5IRkttamp6NjFEdnFxU1p0Q0FlWnRzOFhqcXFsWkdTM3I0aTlXY3NW?=
 =?utf-8?B?dE5RZmd5aDdwM2ZqWVpjMXN1QzcvdjdiMElQdnM4Q1hMbGxpNW9tdjM2ZGpj?=
 =?utf-8?B?Rkc2dGhBV05zeVFWOCswSmU1a3ZvZFd4ZFlZWk51d21SNjNtSnRUWCtOZEdF?=
 =?utf-8?B?eStobktBYWxPSS9HVDMwclM1aUpFQVY3THoxM01ZTXlDS0JxSk9BcW4yTjhs?=
 =?utf-8?B?WTBtWjZkcnM1c283RENMQkM3UkhzOTdVRkVad2tzZHhPSnBKbkJTcHpWWkVY?=
 =?utf-8?B?UFh2L0pvaWpIOTJoUDZnNlFQeVhiQWdwbU90dWQxcFV4OHF5Z1dERFFBMlBu?=
 =?utf-8?B?cXUrMWFJOW9yN1hxdGpER2dWeTFyUTU4cjRZN0I0UnRhZHkyd3RtN3dxQ3RP?=
 =?utf-8?B?cXhUd3VYMFlDbmtNbkhaMU5jb0x1VXdWYm1SbWRWdDQ2a2hkbWw4alRSVUZR?=
 =?utf-8?B?WU4rVjgvQWpzdjhSUmg5aDk4TFBWTkdsMnJrSy9CckZ3V1JqS0xtdmZxTmxK?=
 =?utf-8?B?VEttdVVPK3EyRUNYU2JtcGcyZiswUnpUd0RsSStvRGtSR1FMam9EdE1WYjdo?=
 =?utf-8?B?eWtxWXpOVXIxNTN5ZnZZQ1E4OFh3QjE4WFhmMTVIZXVsOTdJV1Jxc2x3QVM3?=
 =?utf-8?B?dkRXbS9FUFN1ZlloWGVoaCt2RDVKalZFdVZ4TTBSRys4a1hHVjJJRXgxWk1p?=
 =?utf-8?B?YzB1NVE4ejh5VTNmaG5EZ08xZWtuUTRTeXJkbVZHeVVvVG94eS9BckVvZnp0?=
 =?utf-8?B?Z1c4dlNxOVBXaC9DejBBbzFBMFI4ckhqL3N3aFpxWWpJKzR1RktaWFhTSU96?=
 =?utf-8?B?eStIOUtReitGZFc1MlVOU1R4Nlhlc0hLTDNHVkoyR0E1VmJ3aTl5YXBLSDR3?=
 =?utf-8?B?VWpKZlhmQStZQkQ1VFBqeXA5ajhPTiszWXVCb2pzMXp0aUg5R2ZtaTZ0WVNX?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a9bb02-3506-4ef7-4360-08dd1f2f91c0
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 06:45:32.9650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /wKR6O26HjrDFFchVtxtXFge3v68ioH3fJlxafJ5NqfrNYcFN5nhunu3HULAiYiJnUInc4k9hsNW9L/RRJ+QEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7419
X-OriginatorOrg: intel.com



On 12/13/2024 3:08 PM, Chenyi Qiang wrote:
> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
> uncoordinated discard") highlighted, some subsystems like VFIO might
> disable ram block discard. However, guest_memfd relies on the discard
> operation to perform page conversion between private and shared memory.
> This can lead to stale IOMMU mapping issue when assigning a hardware
> device to a confidential VM via shared memory (unprotected memory
> pages). Blocking shared page discard can solve this problem, but it
> could cause guests to consume twice the memory with VFIO, which is not
> acceptable in some cases. An alternative solution is to convey other
> systems like VFIO to refresh its outdated IOMMU mappings.
> 
> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
> VFIO mappings in relation to VM page assignment. Effectively page
> conversion is similar to hot-removing a page in one mode and adding it
> back in the other, so the similar work that needs to happen in response
> to virtio-mem changes needs to happen for page conversion events.
> Introduce the RamDiscardManager to guest_memfd to achieve it.
> 
> However, guest_memfd is not an object so it cannot directly implement
> the RamDiscardManager interface.
> 
> One solution is to implement the interface in HostMemoryBackend. Any
> guest_memfd-backed host memory backend can register itself in the target
> MemoryRegion. However, this solution doesn't cover the scenario where a
> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
> the virtual BIOS MemoryRegion.
> 
> Thus, choose the second option, i.e. define an object type named
> guest_memfd_manager with RamDiscardManager interface. Upon creation of
> guest_memfd, a new guest_memfd_manager object can be instantiated and
> registered to the managed guest_memfd MemoryRegion to handle the page
> conversion events.
> 
> In the context of guest_memfd, the discarded state signifies that the
> page is private, while the populated state indicated that the page is
> shared. The state of the memory is tracked at the granularity of the
> host page size (i.e. block_size), as the minimum conversion size can be
> one page per request.
> 
> In addition, VFIO expects the DMA mapping for a specific iova to be
> mapped and unmapped with the same granularity. However, the confidential
> VMs may do partial conversion, e.g. conversion happens on a small region
> within a large region. To prevent such invalid cases and before any
> potential optimization comes out, all operations are performed with 4K
> granularity.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  include/sysemu/guest-memfd-manager.h |  46 +++++
>  system/guest-memfd-manager.c         | 250 +++++++++++++++++++++++++++
>  system/meson.build                   |   1 +
>  3 files changed, 297 insertions(+)
>  create mode 100644 include/sysemu/guest-memfd-manager.h
>  create mode 100644 system/guest-memfd-manager.c
> 
> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/guest-memfd-manager.h
> new file mode 100644
> index 0000000000..ba4a99b614
> --- /dev/null
> +++ b/include/sysemu/guest-memfd-manager.h
> @@ -0,0 +1,46 @@
> +/*
> + * QEMU guest memfd manager
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#ifndef SYSEMU_GUEST_MEMFD_MANAGER_H
> +#define SYSEMU_GUEST_MEMFD_MANAGER_H
> +
> +#include "sysemu/hostmem.h"
> +
> +#define TYPE_GUEST_MEMFD_MANAGER "guest-memfd-manager"
> +
> +OBJECT_DECLARE_TYPE(GuestMemfdManager, GuestMemfdManagerClass, GUEST_MEMFD_MANAGER)
> +
> +struct GuestMemfdManager {
> +    Object parent;
> +
> +    /* Managed memory region. */
> +    MemoryRegion *mr;
> +
> +    /*
> +     * 1-setting of the bit represents the memory is populated (shared).
> +     */
> +    int32_t bitmap_size;
> +    unsigned long *bitmap;
> +
> +    /* block size and alignment */
> +    uint64_t block_size;
> +
> +    /* listeners to notify on populate/discard activity. */
> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
> +};
> +
> +struct GuestMemfdManagerClass {
> +    ObjectClass parent_class;
> +};
> +
> +#endif
> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
> new file mode 100644
> index 0000000000..d7e105fead
> --- /dev/null
> +++ b/system/guest-memfd-manager.c
> @@ -0,0 +1,250 @@
> +/*
> + * QEMU guest memfd manager
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "sysemu/guest-memfd-manager.h"
> +
> +OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(GuestMemfdManager,
> +                                          guest_memfd_manager,
> +                                          GUEST_MEMFD_MANAGER,
> +                                          OBJECT,
> +                                          { TYPE_RAM_DISCARD_MANAGER },
> +                                          { })
> +

Fixup: Use OBJECT_DEFINE_TYPE_WITH_INTERFACES() instead of
OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES() as we define a class struct.

diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
index 50802b34d7..f7dc93071a 100644
--- a/system/guest-memfd-manager.c
+++ b/system/guest-memfd-manager.c
@@ -15,12 +15,12 @@
 #include "qemu/error-report.h"
 #include "sysemu/guest-memfd-manager.h"

-OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(GuestMemfdManager,
-                                          guest_memfd_manager,
-                                          GUEST_MEMFD_MANAGER,
-                                          OBJECT,
-                                          { TYPE_RAM_DISCARD_MANAGER },
-                                          { })
+OBJECT_DEFINE_TYPE_WITH_INTERFACES(GuestMemfdManager,
+                                   guest_memfd_manager,
+                                   GUEST_MEMFD_MANAGER,
+                                   OBJECT,
+                                   { TYPE_RAM_DISCARD_MANAGER },
+                                   { })

 static bool guest_memfd_rdm_is_populated(const RamDiscardManager *rdm,



