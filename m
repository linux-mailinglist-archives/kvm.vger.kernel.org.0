Return-Path: <kvm+bounces-47715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91063AC3F32
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 14:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB3F57AC250
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 12:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC3B1FCFE9;
	Mon, 26 May 2025 12:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJ7Ouwbt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5369A3D994
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 12:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748261833; cv=fail; b=bEVjeHKLlpLWK4yJfN/0y0ooI7JJs66sMfm/k1TjxNgzGYwuRLgTkALVPeVBLufp6W/UWwroymlRfvWY0rxlBcfzHBUxx5Wgg+SXVYMgMc2O/A5xdEi2tGxMccemgXlBxj0E0hSNcMPJDUuLYjdhSXNfV0abvwyZr39jdzCUJtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748261833; c=relaxed/simple;
	bh=CFPPwCC4aMOzrgxIq3aFF0o66t82kjFza920lEv7Gfw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bRctxm6rkOE1Eyiz8TLBS2LkPC0V8Pvz8IeJThtRLGfq9nNLs6ST7K+x77KAEUy7UJfAE/pcl3mAxzIcJTw8RpEIyL5pj7zvdrh0g978+Xd2dEVzQHhRlX3DH7ghmk7h8ohh8pOZ/0boNuFsx/9sE+UTN9+dr5bpsV8NyWFVxCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kJ7Ouwbt; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748261832; x=1779797832;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CFPPwCC4aMOzrgxIq3aFF0o66t82kjFza920lEv7Gfw=;
  b=kJ7OuwbtC6oDV4gYQyt+177yXvs7HoCtYhREcy03pfwAsdZdwDYHeujc
   mQU4fIJfeDcm6gJUqRNFpdBhqNgpKmRu9f3XfsNmFXvNMf+q1JLEXrolp
   kXtEahM4E6qWGUCwiMt+8akk7pAZk4zO5EfpD8m9ywhR9RrLqciUnBo6y
   GSrw/EmGw0BVdcsoX6QtZHg5RBgrJvHdByJnqANcGmVsmVrxgKD9OxFAt
   161S+27PdLwoqB9NPC5he6vCqX4LgVCSqYo2aEhQbM2c6UoQgurt11EGB
   JACaZZcCA+P6I6Daa51pIyuc5idi20KW+Gl+At9/okONuX25FHxBqBPnT
   w==;
X-CSE-ConnectionGUID: su8Varq6Q/e5yRC9/EzddQ==
X-CSE-MsgGUID: sjRCltUuSoGMnA36LOwXog==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="61294063"
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="61294063"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 05:17:11 -0700
X-CSE-ConnectionGUID: IKyaqBVNQpGGgZXV+7rfGg==
X-CSE-MsgGUID: njGM885LRq+r8SF0FUw4Og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="165539237"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 05:17:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 05:17:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 05:17:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.51)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 05:17:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pKsZVQlKkOxCywBAPTZJdAMIFKrF99PWsT02tW4Hb+RkpwsApMQUvFwjaG57uCcTSWJWkvjg28XTie8f0WZHJgUKri4PlcoftaPTr8/BjP2sBjvO5IIOP2D6heHqTE0s7MYEIpenFjeIoXTLZ3cbhlmNtPAGnM0lxwTE3gZVcWWr4HpIK8VyPeKWZGi7o3le/xprCgyfgRwKXmrOMTCiR25aVCRBKMiofn+fuNE0ldJ4xo9DCpXyRlz5pQrdYbo/NnC+3JTW/BH4NNun9Tjm8cV5ksSe0adHnvg1Lcd8hRW6YWMx4p9Uuq3e4qeO/I0hcwTeVmxQLF9PjZszSldQJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UuOVo7wMzAROHYO0tnI32b9luNwBKLc3c2/TD6ujI/E=;
 b=DcXfyzs1Rz83RaU3SFhR3DVx1MuaTakEdoww7QXeKZVsAYhf0vGZ8QzFgQncm6VTwCoJ8IdSI2/sb3Caq5Wga9sdrqoBifUREI21omlaP0h2PWtG6dxOIHi1hBjyGGEZY+Ux6GOL5bbli7HmPL3R1rGBIjK6qFj8xImWXucqJUpr7EV00HeLPutpTToEbHCwkorpOKlxLFjYcfqq0k7Kd75sCXRD+4tRvFSLssy1bY1SUoWqGno//Ai8tinHFA/A7hO0jtltCFR5sRQxk2LDfG2vyPg/qZPtfpEC88Wium0hjd4nYazgYtEh0fIrB0bnT/M9Fo5cMt0II2YfVXoY9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 MW6PR11MB8411.namprd11.prod.outlook.com (2603:10b6:303:23c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Mon, 26 May
 2025 12:17:06 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.022; Mon, 26 May 2025
 12:17:06 +0000
Message-ID: <faa1f415-4c12-4082-abdb-7bdd637a4d36@intel.com>
Date: Mon, 26 May 2025 20:16:55 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/10] Enable shared device assignment
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, David Hildenbrand
	<david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>, Peter Xu
	<peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini
	<pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>, 'Alex Williamson'
	<alex.williamson@redhat.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <7283f8f2-a9d9-4e7d-bfbd-3854b3d1736e@kaod.org>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <7283f8f2-a9d9-4e7d-bfbd-3854b3d1736e@kaod.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR0401CA0012.apcprd04.prod.outlook.com
 (2603:1096:820:f::17) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|MW6PR11MB8411:EE_
X-MS-Office365-Filtering-Correlation-Id: 77e4825b-c93f-453d-2070-08dd9c4f3acd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?enRsYVZIQ21UV1M3dXY5WFJaUzZNRWNxNGpTaXhydXdmUkkzM2FzaXNHVDNm?=
 =?utf-8?B?MExQNUtmOG4wMzRNWFdCZU1XR3BrditLNnFVTXd1blpKYXR1c1lHTW9EUklq?=
 =?utf-8?B?RmZNSU9xY041WjdMV3lzWi85WW0vRXRFajF1M3Bwa3dMbDhmZkdlZi9rc1pm?=
 =?utf-8?B?OGs0NWwwOG5aZXBQSUpnbCtmWUdNN3RHamxqWW96U0NsdTY2Tlh4dDhyeFE3?=
 =?utf-8?B?WE9iNW8xUkx6dTBISjdCR2p2MTF1dXU5TnlTaGRha2w3V0RsNXIxUjlIaEJJ?=
 =?utf-8?B?TjdzeUZRTHhtVm4zc3hDWmkyRWtaclNyMjZoK3NFcUZSSkFVVEYxSFFianQy?=
 =?utf-8?B?VjNDc3NpdHo1Sm00akVYaDVGNmlNeUxlemJQZ28wVit4TnQyUFIzS0Jtb0xv?=
 =?utf-8?B?WVZZc2MzNnloQ01iNVVIOTBGR1pHWS9UQmF0Q2NyMUlDUzBZWXhKMWFRUURF?=
 =?utf-8?B?cnlvZnN3YndvNUpTQVplY1JGRDZZcTNGdjQrTFA4YnZkMzFDbGN4dFhaUkYv?=
 =?utf-8?B?cUZabUdKOVg3YTBIcVdPNFR1enRKS3N4ZUFGZ0lkdjU2NGNTdDBBUms1TWF2?=
 =?utf-8?B?Q2UwUWZaWS9ad1FjaVZrazY0NUdaQlYvK2RabEE4anU0UkwyMWo1ZTR0aEMw?=
 =?utf-8?B?K3Q5SFZZZ0dCVnM4SlNvUkQ1UGNGVXN5RWQwVjVPdlNoNGNxT1BMOG1EelZu?=
 =?utf-8?B?M2NiZjZ4dnEwQloxWmxPOWtNZnlYMXgydGM3R3p2TFhWYUlOYStaazc3czB4?=
 =?utf-8?B?d3NxakhQblkzS1h0OC81R1B0dTJvYXdpbzl5V2ExTnV0S0g0Q3NJQnZtS3dL?=
 =?utf-8?B?QjNxcFJialUySDdhTWxrc0xoQWRmTEFvUStDbktkY3ZvaDNXMjVJZEFlZnNs?=
 =?utf-8?B?M2pBbjZ5T0NuREpnNzBQNDN6K2tUTEY3WGZHYnJKdXh1K09sZnA3RWFtMGdL?=
 =?utf-8?B?dXBxVlEycEdtVVd4L1BUMDdnVjJpVkE2NVRVU0NRTjdRZm1pVUNmS2hoRFZS?=
 =?utf-8?B?VUlVR2VzQ0VUZzFjcnRtRFZ4YTBxVllBUjQyRm5UeS9mTHFpbHFSUHplUzZv?=
 =?utf-8?B?SGVDUFJMcXpyWE11SFNtaTFiUlpXNjN6NCt1S2trNzJZVW9HN1JtRjRZdzJG?=
 =?utf-8?B?OXozNE5HMVlnVkhOWWpIa2RkSlN1MTR6VFRCZzJZK0dwTmErNldDUjJueTgx?=
 =?utf-8?B?NXRlWEdKSyswMnZSNFNMbWVsSEJvaDliRGVzR29uSHRDT2o1MWhLQU1menl4?=
 =?utf-8?B?QllDZDY5SlgzSWtGTStZcVpNZkZCYkFUck9PbWFIRHRGWE44dCt1dHpyQ3Iv?=
 =?utf-8?B?RWE1Yjl6KzcvQ1J2ZUhWWFhNRkV5QnRkdnpuYnpGSjRYaUxwUDRKdmZGQUtV?=
 =?utf-8?B?Tk1ZUitRRDhnT2x4ckw1aWtJKzc1TDhVQS9TK3h3cXgvcUVTa1ZIaGdpbU5O?=
 =?utf-8?B?dnkzM0g2Vk5FZnBQTktBK0xOSG4xaXdqckQyUWlhV1hoVEl3MDZZN2hhdko1?=
 =?utf-8?B?QlhFa0hzd2h3OWdXejkwbHY4UFdndDIrQjF1VzVudzRpREtIbmZTaXNrL2Ra?=
 =?utf-8?B?dk0wMFJmcnczZmNvSGdoTVlhMEJxRWc4ajBBR2dyTERLSGd4MkZPbHdZWGw4?=
 =?utf-8?B?ek5CamNPWlB2N2dGWDF3SFZEdndmK3dnUkQ1MjZhc0NFYzhjaDYvWnhSYmRN?=
 =?utf-8?B?WXdsdnFGa2JCdk1ZVE5FOHdGSzdCV2V1cWRGUFI0T29EOEpOeVZNcG5tRmxa?=
 =?utf-8?B?cjVtOWh1UDB1cTNOdmNid0podGdDcnNhOGlvaGc4eXpGQzF3cXMvS0lsZ3Q0?=
 =?utf-8?B?cGdadThCa0tpbmVWT3d3VzlXVVcxZmJCalRqUTU4dXhtYVJPN255WFBZTFR3?=
 =?utf-8?B?amkrdk5aTlArb3Y4VE15V1YvRXVoZjl5NlJwVjJYOHl1ZW9Ib2ZQYkpuUlJR?=
 =?utf-8?Q?b8bsy2mRlG8NN2uG9AscvreGLIcnNjkY?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDA2YkU4aHhCUUx5bWVpNm5jbEdyaVhlU3hyNVZqblNVZk5Wd05pc3hFSi9O?=
 =?utf-8?B?UFExelFnOVEweXhIS3VDUWhvMnE3ZVMzWVJwNy9GUFJlc0Q0dUhkd1htU2Iv?=
 =?utf-8?B?NThkbGpEbWd3YWlZYVUvZWljKzZSSndPWkl4MnJoNWM5OEM2aEpTbWo4bXYx?=
 =?utf-8?B?RnlocHQvMU1tdEtkT3NjUnpXZWdtMjhmTWN3UlNJbXc0R3JoT0NSbWp1N0JF?=
 =?utf-8?B?MnJoQmZqd1htek94ellpTm9IcVZDU09sQm02ZHFzRExDd1l3U3ZZM1NKRzIz?=
 =?utf-8?B?R1h6ditCdFBkSjJQOTYrTHVwTjYwOHBKbElxOXlzbUFSWFNEYkdEY0ZxQ24w?=
 =?utf-8?B?YzM1bXNMTGlhOTZOZEg4c1BQZW9kU3puT3VIVmpVRnFENkhVNUk1aWtGMXZi?=
 =?utf-8?B?S0ZBYUxESmJCNE1FL1ZvWE5vNTBRQllJVVdkK1NaOFhUcjB1VzBoc1RoT2RF?=
 =?utf-8?B?R3h3VjY0RFp6Mncya2NUZkJjbTBseFAvYmY0cStRUXlkYXA5b3hGTWovZUxs?=
 =?utf-8?B?WlJHOGtFOVlYcUYvYVBsMG1NcmJqTEpGdFdObENnQ2Z2cTQ2dDNwSGZCUjNV?=
 =?utf-8?B?SGhaMzRicVlaSW5uTkVoblByZ1pENml3MVVhaWw4eGhOM3hybnJzbFlpaXZQ?=
 =?utf-8?B?dy9TcFFNSmtWc242Q1VEMzBod0J2b25oOGUvYjNla0V5VnVURmpvNXBOQkFP?=
 =?utf-8?B?Zm5WOWtnaER5VjVEamFPMjJZU2phcG03MjZPazhHaEZTdkovN1JTM0tSbHgr?=
 =?utf-8?B?VkJTc2k4dW1UaUZFQWNoWnFQcFJ2RGh2Nnl1NDV1Znhod2ZjellNNWVIVjAw?=
 =?utf-8?B?RmdoeHMrVnQrUTQ5RXFaRWcxdXBnSHcybGgwT3dtVlExbGpoaDVqSzVSSU93?=
 =?utf-8?B?UW9DNmFxOWkxaXZYTU52eEF1QzZLdWtDdlhVSkNKTFp3TysyNW1lTWFJOHpS?=
 =?utf-8?B?UnpQaFRwUEJoTEJSZFB4eXNZQS96c08xQXdzTzRyNE0xbzZVZzBvSmU1R05p?=
 =?utf-8?B?NEpJbm53NXpsL0wrbTllTmMzeFdEcGtXWStxL2Q4T1MraC9VajdLcGZOd1hT?=
 =?utf-8?B?YXNub0VJZDNXV2JnM2xtcnMwRWoxbUpXU05ZdFN1K2lvTVBsWDR1ZitIUCt1?=
 =?utf-8?B?UXpaUlZRTUNjcVV5YUx0QXJad2lheVF4L1p3UWtQRnorV09SdGZvbnliT0Zj?=
 =?utf-8?B?ajYvZ0VaWXREclVkZFo5WU56M05XUWtZYWE4YU00TlcxcmxmNU5ibCtPM1E2?=
 =?utf-8?B?N05vUHJMNmJmNURZRGJ4ZUp4N1lWdjBtRG9vdzZiSGdkeVVLK0JnUmZSdG9u?=
 =?utf-8?B?TGtxSVZ3UE44cC9neVU4TDdCelFOT2tLaDlJL0JiSmRLVHRIbXdLREhzREtJ?=
 =?utf-8?B?UkgwUWJoTHo1NDByT2l0Q3RrYlZzNldoamMvRlR2VkxMOGc4MDBIemFUckh5?=
 =?utf-8?B?QmdEbEJXRHZ3bEhZNFBRSXJPclZDdWp5QVNyS2gxQnJnK3oxM1FtK1hEbW5D?=
 =?utf-8?B?aWNUNEZwM05UR09iZXM1TENXS3M1ODl6Z1pmbGIraXBYSHVFOWN2NE5aWTZE?=
 =?utf-8?B?cHRJelNHSHBidWdEaEkwekhnYWJDZVRNY2hlbFdmdzJXOHh4UkFVUFNaR3A1?=
 =?utf-8?B?bXVyY05IaUdKZjlQWUNYWTQ1Rm14Ny9pbThqb1dZYmFLMnN2Zkw2M1QxNHFq?=
 =?utf-8?B?L0lxOEFKR1JOblJXc3JKU0NjMllTR1BhZkk5MGZUVWNZbllmb05FQ1laVUhx?=
 =?utf-8?B?N3NtNUNMcktJS2JibzRrdm5BZGcwZHpPRnpYUmdidDNiMFFEYnJqWDlxdVBJ?=
 =?utf-8?B?WHpnTW13bFJLZUVEU0R1L0h2ZXJyV3JtSktpaHNGc0IySWNGdWdLMkdQWHpG?=
 =?utf-8?B?eXRrcFQzWWVWNzlaYksvaWduNWluOStjZFNjMlAzWWNpSXMydm9OWEZZbytn?=
 =?utf-8?B?Zk5RSGd1M0pLVzRMaTFTQnBNODkvMVFCU1l6b1ZvZHJBZXdtdTZwRk8xSXdr?=
 =?utf-8?B?L1JrL3lVaXpNSnVQM3UyYzJVdXN2N1kzUzh2L1RyaVVGMmkyMUMxQndTWjE2?=
 =?utf-8?B?ODA4d2xZZm1pblRFUW81b0hoVDNMV2pON1FXa2FiT2JDSTdna0duMHUzSzJE?=
 =?utf-8?B?Wlp4MkhwV1JnNGF2ZjdpbU05cGpVV0V4dUN1VVlRbDZ6dTFQdk9nNUVzRE5X?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e4825b-c93f-453d-2070-08dd9c4f3acd
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2025 12:17:06.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/bEHGZM4IDz0EhhbWRAM2m53DXXWckZh9SZQIxuFWRf5jrV3dzpysGV/yUIC+PY4PLgmySywPBdRyWouBLUxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8411
X-OriginatorOrg: intel.com



On 5/26/2025 7:37 PM, Cédric Le Goater wrote:
> On 5/20/25 12:28, Chenyi Qiang wrote:
>> This is the v5 series of the shared device assignment support.
>>
>> As discussed in the v4 series [1], the GenericStateManager parent class
>> and PrivateSharedManager child interface were deemed to be in the wrong
>> direction. This series reverts back to the original single
>> RamDiscardManager interface and puts it as future work to allow the
>> co-existence of multiple pairs of state management. For example, if we
>> want to have virtio-mem co-exist with guest_memfd, it will need a new
>> framework to combine the private/shared/discard states [2].
>>
>> Another change since the last version is the error handling of memory
>> conversion. Currently, the failure of kvm_convert_memory() causes QEMU
>> to quit instead of resuming the guest. The complex rollback operation
>> doesn't add value and merely adds code that is difficult to test.
>> Although in the future, it is more likely to encounter more errors on
>> conversion paths like unmap failure on shared to private in-place
>> conversion. This series keeps complex error handling out of the picture
>> for now and attaches related handling at the end of the series for
>> future extension.
>>
>> Apart from the above two parts with future work, there's some
>> optimization work in the future, i.e., using other more memory-efficient
>> mechanism to track ranges of contiguous states instead of a bitmap [3].
>> This series still uses a bitmap for simplicity.
>>   The overview of this series:
>> - Patch 1-3: Preparation patches. These include function exposure and
>>    some definition changes to return values.
>> - Patch 4-5: Introduce a new object to implement RamDiscardManager
>>    interface and a helper to notify the shared/private state change.
>> - Patch 6: Store the new object including guest_memfd information in
>>    RAMBlock. Register the RamDiscardManager instance to the target
>>    RAMBlock's MemoryRegion so that the RamDiscardManager users can run in
>>    the specific path.
>> - Patch 7: Unlock the coordinate discard so that the shared device
>>    assignment (VFIO) can work with guest_memfd. After this patch, the
>>    basic device assignement functionality can work properly.
>> - Patch 8-9: Some cleanup work. Move the state change handling into a
>>    RamDiscardListener so that it can be invoked together with the VFIO
>>    listener by the state_change() call. This series dropped the priority
>>    support in v4 which is required by in-place conversions, because the
>>    conversion path will likely change.
>> - Patch 10: More complex error handing including rollback and mixture
>>    states conversion case.
>>
>> More small changes or details can be found in the individual patches.
>>
>> ---
>> Original cover letter:
>>
>> Background
>> ==========
>> Confidential VMs have two classes of memory: shared and private memory.
>> Shared memory is accessible from the host/VMM while private memory is
>> not. Confidential VMs can decide which memory is shared/private and
>> convert memory between shared/private at runtime.
>>
>> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
>> private memory. In current implementation, shared memory is allocated
>> with normal methods (e.g. mmap or fallocate) while private memory is
>> allocated from guest_memfd. When a VM performs memory conversions, QEMU
>> frees pages via madvise or via PUNCH_HOLE on memfd or guest_memfd from
>> one side, and allocates new pages from the other side. This will cause a
>> stale IOMMU mapping issue mentioned in [4] when we try to enable shared
>> device assignment in confidential VMs.
>>
>> Solution
>> ========
>> The key to enable shared device assignment is to update the IOMMU
>> mappings
>> on page conversion. RamDiscardManager, an existing interface currently
>> utilized by virtio-mem, offers a means to modify IOMMU mappings in
>> accordance with VM page assignment. Although the required operations in
>> VFIO for page conversion are similar to memory plug/unplug, the states of
>> private/shared are different from discard/populated. We want a similar
>> mechanism with RamDiscardManager but used to manage the state of private
>> and shared.
>>
>> This series introduce a new parent abstract class to manage a pair of
>> opposite states with RamDiscardManager as its child to manage
>> populate/discard states, and introduce a new child class,
>> PrivateSharedManager, which can also utilize the same infrastructure to
>> notify VFIO of page conversions.
>>
>> Relationship with in-place page conversion
>> ==========================================
>> To support 1G page support for guest_memfd [5], the current direction
>> is to
>> allow mmap() of guest_memfd to userspace so that both private and shared
>> memory can use the same physical pages as the backend. This in-place page
>> conversion design eliminates the need to discard pages during shared/
>> private
>> conversions. However, device assignment will still be blocked because the
>> in-place page conversion will reject the conversion when the page is
>> pinned
>> by VFIO.
>>
>> To address this, the key difference lies in the sequence of VFIO map/
>> unmap
>> operations and the page conversion. It can be adjusted to achieve
>> unmap-before-conversion-to-private and map-after-conversion-to-shared,
>> ensuring compatibility with guest_memfd.
>>
>> Limitation
>> ==========
>> One limitation is that VFIO expects the DMA mapping for a specific IOVA
>> to be mapped and unmapped with the same granularity. The guest may
>> perform partial conversions, such as converting a small region within a
>> larger region. To prevent such invalid cases, all operations are
>> performed with 4K granularity. This could be optimized after the
>> cut_mapping operation[6] is introduced in future. We can alway perform a
>> split-before-unmap if partial conversions happen. If the split succeeds,
>> the unmap will succeed and be atomic. If the split fails, the unmap
>> process fails.
>>
>> Testing
>> =======
>> This patch series is tested based on TDX patches available at:
>> KVM: https://github.com/intel/tdx/tree/kvm-coco-queue-snapshot/kvm-
>> coco-queue-snapshot-20250408
>> QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-
>> snapshot-2025-05-20
>>
>> Because the new features like cut_mapping operation will only be
>> support in iommufd.
>> It is recommended to use the iommufd-backed VFIO with the qemu command:
> 
> Is it recommended or required ? If the VFIO IOMMU type1 backend is not
> supported for confidential VMs, QEMU should fail to start.

VFIO IOMMU type1 backend is also supported but need to increase the
dma_entry_limit parameter, as this series currently do the map/unmap
with 4K granularity.

> 
> Please add Alex Williamson and I to the Cc: list.

Sure, will do in next version.

> 
> Thanks,
> 
> C.
> 

