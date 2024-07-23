Return-Path: <kvm+bounces-22084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7829398C9
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 06:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B47B21F21596
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 04:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF3513BAE5;
	Tue, 23 Jul 2024 04:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AA162UBx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15452F2A
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 04:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721707284; cv=fail; b=esr1OI4ApVAQAUkMdmjOU0rBgWPxEkQaDUtTBAm/d48ca8r40cgMFRtAjDXub8qqS+CZo5jxt8kCzWyH10H974IFHI+JNvLn130pbEarMtWpdZV/ooHMk/M5F9+ySb0Un4kfmynSIikMWqHtEkjLNq1wlggf5M+33wan7SbY9Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721707284; c=relaxed/simple;
	bh=FGkEmQg3MHF/WjcRAYnUn1VgM+wuCYsb0PvOb8X80YE=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dRwu8dW1m14kjACsfgrAbolaYIIhZZN39lGZosnC/fCFK0d4f27zJt025otrjVoXbIIfRiqmPQtilAxUfqBRDlZYn+rZe2c8k/sPdl69keSHgTFy8Nif9hkNHJsz3P4AOUdzoxkjMz1I9CQi/gD4vPQ3VvX9UKUZTOOmjGh8+6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AA162UBx; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721707282; x=1753243282;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=FGkEmQg3MHF/WjcRAYnUn1VgM+wuCYsb0PvOb8X80YE=;
  b=AA162UBxq6Pfj+2+w6fgJfUqAmfodGJD9xkgCbsaSlzxAiZ3PIAC1Vgw
   kQl/QggfKRd1GytxI7j5XNx0NZhz3KtMOFdTK51kjwQ2btEy1GNTcftMK
   ksDTCYPJYgb3iqRCAjqTXhqADjszVbgEvFISbADfA/i7D9XknIRzjsn7f
   j+KWRIlQeCyBlfBZNqSxnKNgOQlaCYTUr41HmckLU9OIky33TzVJufUvw
   St2+o5DKL98EMVyJIarzQG5pVkyY8N0Soz1oxao9EhL3E+VVolAICy+rP
   WS1ARCbvkNhyi/4LVFN8NvoKj4wZmJmWaX0vZs5riM2yPgLkg0jaHglzV
   A==;
X-CSE-ConnectionGUID: eYesz37YS1WT0OOJBIBgyg==
X-CSE-MsgGUID: BGL7sWG7TX+ORDBcuBFfXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11141"; a="23177379"
X-IronPort-AV: E=Sophos;i="6.09,229,1716274800"; 
   d="scan'208";a="23177379"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 21:01:22 -0700
X-CSE-ConnectionGUID: qERbm+94Q+i7BbVIq0fRFg==
X-CSE-MsgGUID: C0YqpjyWTYK3qTYYWljAgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,229,1716274800"; 
   d="scan'208";a="83111885"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Jul 2024 21:01:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 22 Jul 2024 21:01:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 22 Jul 2024 21:01:20 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 22 Jul 2024 21:01:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dbLJmaCfbPK3/skc+KWIi4BPu3dVCgsuiyvCyI2361GYwCxB393A0uISNMBXz7WiFCGWOrkDIucWjeWzZoI0WU/eWC0fQZ0Hs7xl02SDKxUoLv5BLTnuVmFZwccrzZqDytYiLVYijVzgEuCOrIHDHshfVHLCxCcaASZiW07dfW6fvKpC4acwQ4KhzvuQN4k8epOupJC7RTL3fFh9Orw/H92PjTxF/McgUQVNp9NqTRJBG7Jfn3QJjPIBKZN987bhqLA4BeRHm8TqWek0AQxVDRrY3uhrYKzhuS3NOQr0IeNzujOKsgfxY6JjyKkGVd/rV0ER2LskOaZle5w4Nk4yGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xkygeAvsX243cgJxGTKKWxiroIphfpugfFzPkZPDe0=;
 b=XS7YmS1+m1pIFoYdOO73+ZN/7mfeCyOPe5aLWyaszfMnVJ7+bD4n/ZdQ0ZWghhoHYXBm1naaaTze0L2gLx9xLqZA6aJOJbNsF+5y3ZW85BB+3mMvc0gpcrWaPYuQG4R/tiWRfO78/hOY3AfkexxRtbBlyl8Nt0nX7mVrwCtEBpjphgCl3uRs5Zd2sNBjSyVGV3vthzc9j9W32z1P7bkvBmX0hQh2e60vh4Cnpt5yG5lRMp16J0xi239VJWJ5GzOIE5WVtUhQRRA572TcoEIdBJumagsm0hWkuwgnpo3Gn+dRk/+oWg07w7xy46tO/DCdTMmSbiJ1MGCTqq+dfvhnhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8657.namprd11.prod.outlook.com (2603:10b6:610:1ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Tue, 23 Jul
 2024 04:01:18 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 04:01:18 +0000
Message-ID: <859fc583-6aca-4311-ad9c-ffbea68c5b17@intel.com>
Date: Tue, 23 Jul 2024 12:05:30 +0800
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_FW=3A_About_the_patch_=E2=80=9Dhttps=3A//lore=2Eker?=
 =?UTF-8?Q?nel=2Eorg/linux-iommu/20240412082121=2E33382-1-yi=2El=2Eliu=40int?=
 =?UTF-8?Q?el=2Ecom/_=E2=80=9C_for_help?=
To: XueMei Yue <xuemeiyue@petaio.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "joro@8bytes.org"
	<joro@8bytes.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <SJ0PR18MB51863C8625058B9BB35D3EC1D3A82@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <903517d3-7a65-4269-939c-6033d57f2619@intel.com>
 <SJ0PR18MB5186AD98B2B0449BF097333FD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <SJ0PR18MB5186AD98B2B0449BF097333FD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::9) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH3PR11MB8657:EE_
X-MS-Office365-Filtering-Correlation-Id: b929ffcd-bca8-44b5-41eb-08dcaacc1b25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|220923002;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Uk1IaytqZVdyUm1QZUprenpqOHNuZ0xjazFPYXdsSDZ1NFAySExvMm5odkxl?=
 =?utf-8?B?TTZGQW5MVXFZdTcxR05helJaZHlUQ3ZmQ1p1VzhEZ1JnUU1pV1F2SmNobW1X?=
 =?utf-8?B?YTVTbjU2MWg5R25FMHJJWkZCSlNDcW9ZK0ZERWx5dEMrOFp2LzduaGRFdU1C?=
 =?utf-8?B?WDJtVlA4WDVoRU14QWZhU1hKNDNaa09tYWROMUNLQW5UKytHR3pCSW83QXZk?=
 =?utf-8?B?aU9Ca3VnQnBJMVFxMnBuRWVwdEZkeEwxYzVaRHl0Rkg0WkVyakZiQmtBS2ZX?=
 =?utf-8?B?ejVwQ2FnU3RkaU1XQjhqR29QKzVsZXd3NkZ6aUJ0WmxxRjFrbndjVWJKRGlI?=
 =?utf-8?B?NWZrN0RFc2tlVW4wSGpPS2IrNVZ0NlVTK1h2dUVGZzBSQkJsVFliU1JJYUQ4?=
 =?utf-8?B?ZFgvMC9BamJKVllKNlJvVHNDMlFOazl3YldKVmthN0N0Mzh1TGhzYmJXVld6?=
 =?utf-8?B?V0Z6N3duMThJQTdXWWgxL3VIWG9VdFIwNG95MHlTQ29CVFlJWnZNZURVU3Vq?=
 =?utf-8?B?KzRVZWhnWGtadVRLY2hIUk9qaFE1SVRiRXNqTkQxN2ovYVdqTkpSTWVlSXJ0?=
 =?utf-8?B?Qkp0eExMZ1RsaWV2STJUODAraXlSMFdRNFRpWVNrZXk5a2hSeVVTNFdiUTFQ?=
 =?utf-8?B?S1BuYUJDa3NxTWY5M1NoTFJhTmpqMThRajFUSGxRQ2gxSWJmR2RGcXdXc0Ri?=
 =?utf-8?B?MWFjdXZzS1c3ZkNjYm16WnBXUnYwUTdFZ3lBL1JUSnNpOWdBQ1AyQWF1UjR1?=
 =?utf-8?B?Q0NaVHRUa1lnVjZ5bFpCYjZXcFgyRG0rVzEyeU9Bdm5lYW5JN3doQnNJNk5M?=
 =?utf-8?B?VmZYVXJYbDFQZXhnVkdiZDNEY2RLemxEdnR3cldLa1hrMWRHU2FCME81MWJI?=
 =?utf-8?B?TjAvblp6OVkraEFoa0JNQnhrVk1KY3dnRVl6K2N5ZEIvZ2tFdGQ3MU83S3M2?=
 =?utf-8?B?WUgvNGNkcEk0dFRGY21yTXJDMzVIeC8yUHpWZlpuRm1HY3JhSk9hWlRET3NX?=
 =?utf-8?B?bkx5bmYrNjdwMHg2UlBlM0Y1K1k5WlBIaW1CQy9reWZ3YlBVWE5IaWtTVkdH?=
 =?utf-8?B?Y2g3b2NkQjl6b0FPeFpYa1NCelVXOTFSSS91YkVxRVdmR2FRa2tBVjI2R3lm?=
 =?utf-8?B?S1lvMlJUOGo2MHFobGJRSmxYMFRZOHpRSDdyQmtNUXVWa0hhbXZNWFNYUmVj?=
 =?utf-8?B?Tk1sVHhvWTZZUHQzemxoQmVYZkhzZGRZZ0hkZmcreXZacWlFSVVmbVpoOU8x?=
 =?utf-8?B?LzBXbHgwc3dlYUZvc3M0VTZyb2JYN2VOcC9KK2pIRjNYQUFLR0Uva2FJUjlI?=
 =?utf-8?B?MVlkbVBCNXM4aEZSdWZ1UjIxMU1BZnFzWnZ5MWE3WU1VcVVoY1ZEUmtTOXBJ?=
 =?utf-8?B?NGVmWXlCZWptcDRsZXZ0WjBDSGQ4MFJydXQvaHYxZ0k4SEJJaEV5YUhiZzBQ?=
 =?utf-8?B?M2RxV0lCbjRtWS9TeTgySWdBL1NPYlZ5SHppakVDdkVkd2E3QTVPdHR5TUpL?=
 =?utf-8?B?dFgwK3lhK2Q5dEdEN0xFdmJJdlZvTFNWS2Robjk5VjFQd2l2UGtmTUxPNWlp?=
 =?utf-8?B?YWp6a215NFhXeFJsTTk2aEQvZndkMms1WWFvSDlRdS9RWWROb3g0aEJaR0pZ?=
 =?utf-8?B?Qk52UGtQbUhsbWVkUGVnblQ4eFNobCtLaGlrNVRTMjFES2wzTVlHeTV1bnBH?=
 =?utf-8?B?b0VPMGhzcW16V0xyQXhXR1h6aXM2QmtiWDMzdm5oTU5QeTlWNGN1WFp6bFJw?=
 =?utf-8?B?SVVsN215UWw0YXowM1NnLzJicW0ybUM1Zml2eUk5dGRralIzb20yc0VPNTVY?=
 =?utf-8?Q?2JMC0bEZ8UO4No/w3zpjJ+Wux9BziEitgW5/8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(220923002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SThxMEt1SkdhUkJLN01DdlZpT3R6R3BURGNYekswZEVWYStVaWZmRW5zRnFo?=
 =?utf-8?B?alBjdExYVHg1cmJWQlNyS1A1ejlOVW9JMWxLUmd0d1l6bm9USlhzT1ZBblFK?=
 =?utf-8?B?VHRqQUVLMU9SLzNEVGV6aTU3QWZ5dGMrem9tbzFxUGMxZDNBNmk0ckR5dEdv?=
 =?utf-8?B?SXlRUzNPSGJkL3E2UVhaNVovN25uSExReEpLZE9nU2ZZeDgrRnF3Ulhydzhl?=
 =?utf-8?B?SnNWL25oTStYTWdValg3Uks0M1FnUnZFT0NsT2NOVG1vdk5lVUdPQm4xM216?=
 =?utf-8?B?dTlrRHJRc3RIQ3BNNlhDNEkzRXN3ckxPSlZGQ0tBOGpyS2pHb1J3dlZvL1No?=
 =?utf-8?B?Zmd2NzBwU3hEYVo4ajA1T2syTlJsVlJucWwwOW52RzNoN1I5dGJWYzV0SzhS?=
 =?utf-8?B?bEU1TVFRNE1Gd3lWb1pZVThVNTB5Ukp1eHRYcjNmSXU4MHg0RjhOWCtvUjJ5?=
 =?utf-8?B?dElGTUREOTBCU2d6VDRXTmpibXEzNHJGV3Vvak50ZkF2N1ZlbDJ0N3E0d0dy?=
 =?utf-8?B?MFArbzlCUTRXV1A3OFhTMUZ1dzAwVGtCcER5dlNLSmVZNUEzc1BFa0pQeVRH?=
 =?utf-8?B?SXhqNUFkcHRNYk5VRUxYVmMrS3IyYjQ5ZzdwWDZJRWFWc1ozOHB3bFVoaWFj?=
 =?utf-8?B?N0kycDQ4WnJLeGFyYVNOYW4vdmJWaHBER2RvcmFJOEF3NHdDQ0htTEhpMEFa?=
 =?utf-8?B?S3dIeklKRkR6VmpydVJzTXB1KzdzdzFTOWdPYXRJbUg5M0p3T3RPUWdDODVS?=
 =?utf-8?B?WTV0MXYzbmh6NnZ1Rno5N2EyV3RlcFgvU2ZPRVBycTRZb3BWd1hPY2EvQ2k3?=
 =?utf-8?B?a0Q5WXQ5NXJHaFpkbGdBSGtwc1Myb0VBOEMxbEFKZXFEbm1QVnFrRTdrYnN4?=
 =?utf-8?B?S0tneWZSQWJ4MGRYYTZGVk54M1hqT2l3bkJVSzdwL2F6c2JwZVZyRWozN09M?=
 =?utf-8?B?cTB1QnE1d3JDMVhGSVo2VS9GanJUNEVMVjllbWt6a3RVN0VvTnhpMWhIM2Uw?=
 =?utf-8?B?bEk5aVBnaXFZYzhpWWlaRDJEQWhiNk10aVpUR1UrUzFBaDhMMlBsZ1l2Qjhq?=
 =?utf-8?B?elNiY3BJU2swS3hoYjZyVit3eVB6NEZVRG0xSzB1TzMrajRabWFoNlVPMkln?=
 =?utf-8?B?UC9YN0c5SXpSRGdWbFRyMEdMOWlyWmZyWllFWnJ0YUtMeE5TUWpuNGF0N3U1?=
 =?utf-8?B?Tkt0YnQ3aVdkWHFZclRYbFQ1WGErZVd2d2JBaitPRFlXVmpHdmpYSnVxYlFU?=
 =?utf-8?B?aDhlWk9CMDQzUk5iNkczWTFQbGcyOHdKS3lpZkxCVHJLays4WXczSWJOVDFW?=
 =?utf-8?B?UXBVa3RZalpiTDJjNG0wSmg3TDdoR3MxOFJtMjhHRmdjWVdONDBnUUw4TWZr?=
 =?utf-8?B?eVV1d2NRL0gzbkdzM1YzT3hZcm5NdXVUSWgwcStadVJxOElIZzNNVy9STTN4?=
 =?utf-8?B?YWdkeTZTdmcwd3d3Nm5pUWhaWGE4ak9XWWszc3pMTDdZSWROd3lCN01Xbzc1?=
 =?utf-8?B?dHp3dFR5d21xTEdrajV1RlFwYjlodjBKOURTQVJsNUMra25NN3lOTVhuTXZy?=
 =?utf-8?B?VjZEalU0WnVhQytmSzdRK1N1NjlLWjZDeEpDM1l6UWV2NDFPV09MeWg2T2pa?=
 =?utf-8?B?WTZjcU9xMHFZMHFhZXljbysvRnE4Wm9ibXNZbTdVbFFBNVJmdHF4aXRmNU5F?=
 =?utf-8?B?eFBCK2Q1Y01zU3JuQkpNSzhaOHZvMy9kOGViN1V2a21lSkgxOEJYTWh4MlVl?=
 =?utf-8?B?Q3VYZFpNWUVsUDQyaG9uK3NPVWw5UFFtM09uMnp2QWJlNC9IczczbktUQ1dM?=
 =?utf-8?B?REZnZ3VmWjZkbTJOVVpsUW56aDJZTTlWZFc0eTh6eElneVQraFpKZmZlUHk0?=
 =?utf-8?B?NC9BMCsvTmJLOEF6MVZDMXB6VlhPSkZOMHlxekVSTmlvWThzSjBNeU5BTHJB?=
 =?utf-8?B?WTJjSkxYTXNXaDIzZE1ib1F0a0xnK20ycld0QThSQlY5Q2diZ1c0RnVmb2dW?=
 =?utf-8?B?QlNxQ1I5STlQN0o5RHdZUUpyYjV3K1hhS1R2a3RxaFFVeVR2Yk0yQVMrRURy?=
 =?utf-8?B?alVjMW9CMVdqS01HZFpraUI3VmR6STBGZkpmU0RZdmVXVUtjdHFzWWtnSlJh?=
 =?utf-8?Q?mcamVOMNLW8eNz2aA33I91NV6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b929ffcd-bca8-44b5-41eb-08dcaacc1b25
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2024 04:01:18.8452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e58rpmzCYdtQ8u+z6xC40JgGnjqJIdX0ON33f2m96bV6ezHn7lExAhw/QRCh4aJq47NYkiBRjzW1yfHtptJg2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8657
X-OriginatorOrg: intel.com

On 2024/7/23 11:22, XueMei Yue wrote:
> Thank you for your reply！
> My pc has the PASID capability, See the attachment.

ok.

BTW. A heads up: you are looping the mailing list, so you'd better use
the plain text format and avoid including pictures if it can be expressed
by text.

>   " I don't think the AMD iommu driver has supported the set_dev_pasid callback for the non-SVA domains."
>     ------ xuemei :  So if I want to use the PASID to test PCIE ATS request messages,could you give some suggestions ? usr SVA domain can solve thie issue ?

You should not mix ATS with PASID, ATS does not rely on PASID. You
should be able to test ATS without PASID. ATS is a performance feature,
so if you want to test it in system level, you need a benchmark to do
it. Or you can test it in pci transaction level, you would need tools
for it then. It's up to you.

-- 
Regards,
Yi Liu

