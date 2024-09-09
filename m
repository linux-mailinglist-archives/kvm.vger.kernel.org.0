Return-Path: <kvm+bounces-26118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 210C6971AF3
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F4021C239C2
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 13:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471291B9B27;
	Mon,  9 Sep 2024 13:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CUPjGgpM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016A81BA88E
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725888305; cv=fail; b=ADT5b+P+ZDE0/Q5c1FPHx1rIfxrTALtekWWkVu/ymM84KxY4jwxzT7XA5pGCIhLYFodL0j7dYGiBoI+snc/xFhzlIAKsVaspPn8Q3tvQBLmxAYns4+OBhKNO0dh4pN8Zy4Rf4wKIaQMEtuHGwvXONhb7QtZjV+5WZKe5BAvI9tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725888305; c=relaxed/simple;
	bh=qXA5szpUHgIguiz/n7+0ZxJwLAKTFD2D7RmVlmmPt9o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bNHkVdlX51DTPIZwiGipw6NAYJFB6FeEEmCOnd0rc30VwfvnFY2tEgvT51rSqGk2wRDZqAhLOVWPunHoBjLKYwsObXz9lqny9VPPpgr9CKqgfLWMhTGKmQD/NcV9kgV3n05e7WuJPPDpLndZlqII+8A/c+5RSxFQmG1+Te/mE6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CUPjGgpM; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725888304; x=1757424304;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qXA5szpUHgIguiz/n7+0ZxJwLAKTFD2D7RmVlmmPt9o=;
  b=CUPjGgpMLMv4iCB2qXtiUw2u6z2x96HfIrGkHA6qkF/O1K6+iBUbBjZa
   d5+dw3It9b1L6oswIUV3SvbMZT/n3wQqegU36z80Yo3771Ll+bPk/UhX2
   8apdNmvmEB1qsqPdPD/bR29UEui22y8GfnMwUyaZW9KcUNKLcY4rlv0Jm
   OyIe38U9FCQ8CUrXMGaKxCg/YdyICcMpOEo0Iz5fOoVWR7rlzqTsdRr0z
   +ye5nySXvrENrggCtIyunmj248UwG5AzmdVu/4i2WFeJLE5J2cqvMNuYw
   gJI98S9reI4bKJJgQ9XEbl9q1VHrnvAKKBzoa0x5ZwBn0TsL4ThkJRTiy
   A==;
X-CSE-ConnectionGUID: k1JBk1PLRGSCwnaK9c093w==
X-CSE-MsgGUID: oPiuQdJXQd2Y6Vt3yKKwAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24728727"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="24728727"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 06:25:03 -0700
X-CSE-ConnectionGUID: lJ+rnPIPQTWZTUWpMO1wOg==
X-CSE-MsgGUID: uI45yiE2Rl6tek2wnrvSaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="71448998"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 06:25:04 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 06:25:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 06:25:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 06:25:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iNYhgitT3DzumqR1+y4D40ckMPPsjqcnxT8SOa/6PcuS3wMzz1O1/kcPoGe4cjhTAAb5yiLkwpMI03OC/cKOG9vkSRDmVKG0SBWgwO/RdxOriKUgRTeV6FogaKjZj3leZUa8LbIg5Q4Fcdmr2Ej5s8IDl6fe/7z87YEl6nrCcBUmOgJstc8Vh8o69/P6XMldohiuwgZy62AI62TxcSMEsATl/ZqtZ9ICH2Ad7Wne265vSvuaAMi0FdIfAJB27NQJHMhEYeKDEo+HCUDUaUa+mDsPlpsDuZr2y3BU57W6eg+o1bsRZ0aLjqrMnAt3zHRvShk6s1p09lDMXMBAeZ/Qzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=syZ6hzDiPbfmN5vqmN0MikJziQjcisordFRItJqLLWs=;
 b=JDr8TYgtjQqQn85tRCepfscS+9snOBaTiN9LBE3zezpFyuMaOcDJRGkaFadAgrgtqMZE0c/qsuw0Y2omyOj4UeHBX3JogkFusN2xy7INySehFytPwZc+OjP1+UKMXo9IrQGQ9Ed/XV8IXW/NqSD0RBeR7bWpEnRrAiJ95m/e+l/GECTYVnjRPCz+1uE2haHT+NNIEc/hDhfhNdTP5irp0uXW2XqoF3EoXcvrGKlcRUvi5xg4KX6qxb7UNJMvgBwK19zgfbC6yRnyE7V5gk0b3d302j6ifVHzXBia87ZqR9MhxIzTBidy1+LEgJYBmrjwTkhYxGgpyEPV692CA+UdUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7245.namprd11.prod.outlook.com (2603:10b6:208:42f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Mon, 9 Sep
 2024 13:24:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 13:24:54 +0000
Message-ID: <bf023188-ba72-457c-b1df-7209be423567@intel.com>
Date: Mon, 9 Sep 2024 21:29:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
	<clg@redhat.com>
References: <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com>
 <20240909130437.GB58321@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240909130437.GB58321@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0054.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::23)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB7245:EE_
X-MS-Office365-Filtering-Correlation-Id: fb66e768-d93a-491f-42da-08dcd0d2cac3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b29LZlVDRmhRaG5LZ2RHQjZRTDlaOHlLTnN0dzFBTndaWG5kcS9kbis4S1d6?=
 =?utf-8?B?MzdUNGp3dGRzdDZ0RkMrT1lleEE4Zjd4eS93NEt1bXJTY0JncmJJV0d6bXYr?=
 =?utf-8?B?MWg5b1QzRkM5M0lhVjE0WGpzZ08xZFh1alNhRktNWWR2NHpmcUJ5aFdINHFM?=
 =?utf-8?B?bFA3QlFZL2lqa1o2UEVKS3JJcDRsZ09QVmp0ZjRMaEpiWnA4YndTalM3MlNX?=
 =?utf-8?B?Z244bFFRWlBXNE9QUitJc1Y2TVlrTnZOOFdPR1VyWkFWM1JSR1BIRTN5N2dJ?=
 =?utf-8?B?YjFJd1dJVUNuSUttcXJkait1OHBSWHBzOUV1RVY5TUhrV3dkclljZE5aMUlW?=
 =?utf-8?B?MmJhZVFsVGQ3SWRWVUVaRFdNbHFNUExtK0hidy9HUHovOUFmbkxrT0FLVDNL?=
 =?utf-8?B?dlR6S0RTL0FLbkZHelZxUjRQUDBlKzJDUWhZTEdCWHZUSkxheFpWejF5dVBB?=
 =?utf-8?B?YmZ3WkZUQjR5UnFzN0R0VTdJMlQ5Z2tQT2hHN3JOYVdlcmp3RXpNZlNQLzV1?=
 =?utf-8?B?Y3gwOWx4cU05b1JIN3dKQUhjRzN1amZqNStjTHluZGxPcGdwM3FKSlRVOW9Y?=
 =?utf-8?B?dDIya0tzZFhYREp4UlN6Z09NUG9LNndUdzNKTklzVHN5SVEyVjZOV1BCYStn?=
 =?utf-8?B?YURPSDM3ZUF5Wlkrb0NFc3luMTZYUVcrYjZ3SjVnRzY2TWgxWFZSaXZUL29r?=
 =?utf-8?B?ejlwNDU5Q1h5MDlUWHpTM0hIU2FEc1c0ek1EanNRTXFXZEVtL3N3emV5NE9u?=
 =?utf-8?B?cjdTUVVVVjc5RjVMS2g2S2xUQU9XbEl6TTZ6SGUxOTBxQ1dvem03N01JVTlx?=
 =?utf-8?B?aHpZWWZTM3lkaE8rM0ZnQjQ3YnVxNWtWc3FXZUdiTmFJSVdmSDVJdjdiY3BI?=
 =?utf-8?B?TjNnZDgwRlZWOE5ieTR4T1VkbnF5SS9uQmpOVWsrM1ErbkpySWdUWUVKd0FY?=
 =?utf-8?B?aEhtZHJpeElDc3UrZkN0YkxmQlZuNFNBOWRkUVBFUGZUeGFWQlI4OE1Xeis3?=
 =?utf-8?B?Z29CcE1iUkFvd3VpdElnaGlvSWpFU1NVWFdMTGNFVm8yakpsWkg2akQxSnAw?=
 =?utf-8?B?T08wVWN4T2NOQVhFMTl0RHlCeEl0ZkQwSTFTWXBjMzZLYVlURVNOV1NTb1RL?=
 =?utf-8?B?VWxMM2l1Mjd6d2NCZ1FxNTRWVld0YzV4eVFXKzFPdGdIQUwvOHdwUUlUN2hw?=
 =?utf-8?B?bDBBUWFOa2JyOVR4cm80QTRMU09QUExtNnFjWmxad1dlSjA2NTQyRGJLazJH?=
 =?utf-8?B?cmJlTjRPVk5UZFZCVFNMZytFUkJjUmFNRlA4eEtObjI1WnFpREJ5Vnp2RTlz?=
 =?utf-8?B?bDR1SnJpNjNCbmhSWEdKMWJvRDM2NU9jZ0p3c3lXakNCRFF3L1ZRc2NiWXlT?=
 =?utf-8?B?ZldLZENab1Q2ZVliaHliSDN3ZXZzMXJTN2JDNTJzVXlzQU5YKyt6OE9pQ1o2?=
 =?utf-8?B?RGIweWFVZ0NaYU9saUUzc3RDQm05cW9mM0RkaFVhdkVqaGUvTHRET0Fkd0s2?=
 =?utf-8?B?Q1lwMmQ2QXlST1dNR3ZoZ0hEZVhuUEhXZFUrUW91VHQ4S0FaQ0pZb2NhL2dZ?=
 =?utf-8?B?enZIekJoZU9HeHJmZDYyYzI1Z2VRWXJFa0tVcTdOdGlzQjllRHpDT1RCb1ZD?=
 =?utf-8?B?QUthQ0FCYVZoZDBNTm5iQm8yZHZUWWViMFpLeEZRT1AvRkdjMkgxaHJuOGJ1?=
 =?utf-8?B?cnppM1dnR0hGREt0V1ltNzEwZzk4WXlnWXgyTDFVYXlSOE5ORWszVlVHcnpI?=
 =?utf-8?B?Q01iVVBVU1VTTi91Zzd1Y0Vvd2E2UkpyeWhPRTBBa1N4YUkrQlE1TG9hVU5G?=
 =?utf-8?B?NzVHcFRwSEFHZUhWN1BWUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEdXeHFNRXllMHhMdWk3ZzBaQ3JoaDhCN0wrVmZwbjYwVWpyRDRpSi85b3Bj?=
 =?utf-8?B?U01TYkc5UFpZUzE5MkMraFFSZFAxUjREamFMOGpsckg3c0VuMFowZmwyWE1O?=
 =?utf-8?B?YjdLSmxUMG1sKzZWajQrNlhPUEJnV0EzUXpqQVVDeWJySnFqdUhPTGxYMTZq?=
 =?utf-8?B?bXQ1b1VlMGVDeVh6VENvekM4azMrTm9KbmpaTm9GNWlRSjBzKyt3b0J1ZEpS?=
 =?utf-8?B?MnBRQVdyN2U3UlRPUWFWS3JoejVCandxY2dsL0tSNmN0ZUN2M0NNRkk4SDJX?=
 =?utf-8?B?SVg5NnBHZ09pSUdBZXVLYUxqdld1YTJmQ1dMYVZwZjdCS1dHS0o2WTAxcEVH?=
 =?utf-8?B?NmNwT0l4cmJDNTc0SDJHTFpLL25KaWJWZGRUdnJJdzloYktqOWhRcVp0ZExh?=
 =?utf-8?B?M1ViVFRMb3Mrd2hoT2YwVnIxdS95U3JuNjBDZUlBdFZhaC92V1V1RU9pdHNO?=
 =?utf-8?B?MFh4MGh2OHp0bGp0L3ZYM2J3VGNzWERjV1BxZTVFSFlKcVhMYk5lcFBPdGVB?=
 =?utf-8?B?d0NEY3M4U1Y2c3NZbVcySzBnUFJmMEI1NGo0VGlkcVZSTyt0Uk1SZEJKb0tL?=
 =?utf-8?B?SWJFOG1MV290dGFaWmVNRnhZbzY3UDM3ZzZ4cnBBRVl5K0JVbVRjaHVrRHhu?=
 =?utf-8?B?Z0hTUkkva1dkT3FvS2hySTY2eldJVGpwdk5Xa0JDcjNRMDA5U20wRjZVVGFw?=
 =?utf-8?B?SnFJbXRxU0dGYmc1UGttenIzY3pVcEl1dGVlMmcvWDYyQk5ORUxlL3gzdDhj?=
 =?utf-8?B?UkF4M0tIVzVkczlCZDFsT3J4czB3ajRqNm1adEc1SFlLN0ZWL1NuaHhxL2ZG?=
 =?utf-8?B?L0l6VCt0TkdkUnRORzNYL3Bnb011QU44YUNiSEJ4MUFRUHFrbWUveEV3K1VV?=
 =?utf-8?B?dWpmWC82bGgyRk84MURwQlZRRUxyUDN3Yy9vQlRYenVCOWtZR3E4VEd3QlVT?=
 =?utf-8?B?WnJOWWhCN1FEZjFWOHRqdXBaVHAvQy96TkJuUDd5dUh3akxUVUxNcm9mZ2dR?=
 =?utf-8?B?WWlHRUNEd09iQ2lRZGhncDRTT3hrNUJHWWh4Vmw5NTYxb2hKa2xqcmcycXpQ?=
 =?utf-8?B?Q3lnZng5YjBpK3NKd0tSaVcyaGQ2TlZSalZUQ3EvenBKUlVtNzNhUDFqMzdB?=
 =?utf-8?B?TUJmWkExclhGam9HMi9Ud3N6MmFRczI1cC9BdDV0RnNubnlBUFlVVG9TbTla?=
 =?utf-8?B?TVVRTGNvQnhvMnR2VkxQc0RGdkNmaTU4YjRQbmRWUTRTd1FQZlY0TG1YcUFj?=
 =?utf-8?B?Tmg3MjZmSGswN3I0UXQvS1VDcXVyY05PeWFvY1pPQ2xYZEx5T2FBbUxLR1hL?=
 =?utf-8?B?MytJZ1E2Q25seVlyVGVtSGZIcHRBaHRyY21tcU81YTNIam5ZTi9ha2xJaDlL?=
 =?utf-8?B?aTlyRkVoaHNZdjBsZU4vMU4weUVuTkpQMUFCK3JISitGV05RcU94YU92K1hT?=
 =?utf-8?B?ODBySU91NDQwMFoxMVg5T3lFOU9Rb1hCMnk4V2dIaHB4Rlh2L2VRQVZOSHBG?=
 =?utf-8?B?RmxHQTJaZGV3bHlUbzhHRXVvZzdNWEljZVNzL0RwUUxpOHJmUHYwZ1BtWDgw?=
 =?utf-8?B?dU9TM3dpVnNIWlQ3LzVnK1dUU0NQYXZGWk9tZ3VMek5XL2djeUdFdE95bTds?=
 =?utf-8?B?VVB3TElCSk9LR3dZN2Y0UGtsdkhud2xkWkFBUEVmUnU5K3QxaTEreHBzTldK?=
 =?utf-8?B?VTRhTFVNT0xCakpHL2FZTEoxMkxvOGttcGU1K1pRNS96V3dIb0lxTlRhWnhT?=
 =?utf-8?B?cGUyd3M5SXpoVmRmREZJcmhMZmcwZTFKQlpjK0pzV3NtWEsxR3dSRU83SmRT?=
 =?utf-8?B?T1FoZmlma0JhRVVxb292bHQ3M2x3NUhQRUIzUG5yRXp1WFRJdm1Rc1hCMEE3?=
 =?utf-8?B?OExvcTZQcE43MnhpZ2xnL3NQTGJyZkdPUmFLMThaOFhxamJWUGd5VlFXSTZt?=
 =?utf-8?B?c1lDMXpvV2ZFV25DdVkrNzZoQktGb3ZSKzlZVFpia2ZJKzhMVjFybGdJNjVy?=
 =?utf-8?B?RTZSYi9NYXYyT25MOGRyMlpQclc4RUZnOVdpVVhmL0IrbjN0bTV6alNkOHR1?=
 =?utf-8?B?azNYbzRSdEFiUGYvbkVvL2pBMEY2UUpkUFJDNTB4ZytFLzNTNFF3Vm92TGNo?=
 =?utf-8?Q?CSp6jJGB8IzUtZsxzkzm+zoaS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb66e768-d93a-491f-42da-08dcd0d2cac3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 13:24:54.6650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuzK6A/rdhnbcpYk+vitUsrVfgPk7iKXoMt/8LXyNsHFAew7SMh/ZrtBmo00Gr3Hb7bYNKUBPoPSs+dZuI5yhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7245
X-OriginatorOrg: intel.com

On 2024/9/9 21:04, Jason Gunthorpe wrote:
> On Mon, Sep 09, 2024 at 08:59:32PM +0800, Yi Liu wrote:
> 
>> In order to synthesize the vPASID cap, the VMM should get to know the
>> capabilities like Privilege mode, Execute permission from the physical
>> device's config space. We have two choices as well. vfio or iommufd.
>>
>> It appears to be better reporting the capabilities via vfio uapi (e.g.
>> VFIO_DEVICE_FEATURE). If we want to go through iommufd, then we need to
>> add a pair of data_uptr/data_size fields in the GET_HW_INFO to report the
>> PASID capabilities to userspace. Please let me know your preference. :)
> 
> I don't think you'd need a new data_uptr, that doesn't quite make
> sense
> 
> What struct data do you imagine needing?

something like below.

struct iommufd_hw_info_pasid {
        __u16 capabilities;
#define IOMMUFD_PASID_CAP_EXEC     (1 << 0)
#define IOMMUFD_PASID_CAP_PRIV     (1 << 1)
        __u8 width;
        __u8 __reserved;
};

-- 
Regards,
Yi Liu

