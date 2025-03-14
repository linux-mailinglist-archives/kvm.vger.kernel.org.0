Return-Path: <kvm+bounces-41027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C511BA60B37
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4D213BFA4A
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 08:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B221A23AA;
	Fri, 14 Mar 2025 08:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQDSzo2Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA801A4B69
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741940480; cv=fail; b=dRCHKbLUuZUCh7c4aWLJZ3lx/rFHvu/1aBRg2UgkRSJ6xR08bB37JkXtFt7NJ5YI9dvpScZLk8ZvFf52XlsGJ6565cmn8Tz/NuQ8TgcIpec+SZ3tFcqBt466A2jCyUXNtO9o67Sf0mwbcpHn4hJfKtlH7RtHouW6RJMFxkQg+F0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741940480; c=relaxed/simple;
	bh=786xoJ/SusLOsuFtvF51Stltflw8F+MIGI0/xzavgUk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AnsGT95PFcl1wJuyOJMFG+s63a3Nhar76N4m+Zn8NOm5eY3p4TjIDc8fj/ctz0zc+khqpuhMcwoV2asG6YAxhLB7oXGrLOJN0ri5sghDUHthi4yXjyn/SxBjUafMWHtUdFaHJOXtPLSukTsCtMPZVhXVPUyHo7tA0OzsB7QZCmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SQDSzo2Y; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741940478; x=1773476478;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=786xoJ/SusLOsuFtvF51Stltflw8F+MIGI0/xzavgUk=;
  b=SQDSzo2YhgaXJ0CisXHO/PuS3R4E6ZxQPrFMRvzgudxXSkWPRptDqgWt
   yDzAPFXhccifGrQ3looLpTmSgdkOavOXz3BTS5AAqU46juVBWf9gr9Gav
   mUhlw9POPbCtvSLzUUFSBW/lUz735uyBLMJyF6RHnxFj89HXjIDUfIBSc
   rosCbpufDlUCCFbyHjkuDNgzZ5vgyYbhXsyigYgvFIKBUG+cb1I8TOLil
   /uppWtWfOYybgVkdTSyc3rua03utG05YgL81/57G2nvkCf7Myb1nqX3EF
   TcwRxSwEpf3N6M7zmTfAnrjqtfnw+qXDy05HBWJBRGyP+xVCahrR7IxQD
   g==;
X-CSE-ConnectionGUID: IlA4Xy++TbqGpTgieZg6Xg==
X-CSE-MsgGUID: Nuwgi+TDTt2bGAmM7fLUdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="42813522"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="42813522"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 01:21:16 -0700
X-CSE-ConnectionGUID: RYs7VRPmRs29hBtqHMG9mg==
X-CSE-MsgGUID: M/9gfA/ASb6I0cAggu6p6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="121151189"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2025 01:21:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 14 Mar 2025 01:21:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 14 Mar 2025 01:21:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Mar 2025 01:21:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=en/MoXc23S6bNL8nv6KeFWIG7hMHqIgA/LNkHD1aK9Ne6UxjXekGH4Rb3ei57hMff+fMDqrFwK8lxJNFL0ZuTYbWZTpXoTpoyZAlRguEQGVJam+/OjMX36WOyQl9cBUaKPm/V4h1zc/sLSJm9F0hswcR8BjTVhyX8As4n4KD5IMNyrCuRevSN+TV3o71woml+jQ3lDg+E3Wnzu4QmHiqL3lOZsozGZcNQrSoTNaGD3GWKLVC8ziYKap1mcDz8PqQbiwhP4tAqHCQ0gEbe4ISkD1jxT7cQOXcHDbvHoStFuBHmIE3kNEV9j+8CgX/S3X3zJSEL37x2nJWq583G2PzUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEBIOUC4cWSWfBwVlVOMplfeTjAXhK1oUBaoPnURl7E=;
 b=E+kMKxXpx9B7/lnwEA0wp4URRxIeVUOXyVVt7bK1/pZNzYHz2+ReKiYGWplCyc4VU2C76snbI1+s7/C0/W5etbMUsP4quPXmSyCt6hfGNjUiQBgvxL01Lrmb2cVQqsRzR9G/E5ock8Idf3jbLI56nJAZuIbUWdddfxvsCLFIwSjzp59y4bk7HXAupGo5/uXWhH7dM9kkz1e7X+T2jZ9mR+i0DIEHvruA9ZLNBLMdLuVu6V8KMt+cCmtlC+uw7y9zlv96qeKHx5LU+e3M7c4+8k3VgMLlZNJkV6RiKImJe+4lPbnfe2OKQtzH/97wAkI9mN+xyOrDXae2lrSjhPkQ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.27; Fri, 14 Mar 2025 08:21:12 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.027; Fri, 14 Mar 2025
 08:21:12 +0000
Message-ID: <8d9ff645-cfc2-4789-9c13-9275103fbd8c@intel.com>
Date: Fri, 14 Mar 2025 16:21:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] memory: Attach MemoryAttributeManager to
 guest_memfd-backed RAMBlocks
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-7-chenyi.qiang@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20250310081837.13123-7-chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:195::7) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH0PR11MB4965:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d6b542-8866-401e-34c4-08dd62d12e7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OXhoRmNTelM5N0RNbnhhZ0FWQ1FKYWlMWDRSU2hXbDR5bThZMmROWUJ0QjE0?=
 =?utf-8?B?K3pVR2tFSTBTZ0oxM1JOOHpRNXA5R09USEVDdGdxeXduSFJjVHZEdFd0aVNR?=
 =?utf-8?B?TERBVE1CbTRXL2x2amxWc0ZFdmJPVEhqOGlmNVhJanp3dU9Sa2w2ZFpGdDFj?=
 =?utf-8?B?enBXenFZRzdyVUx4K1FwbitWcHRFaTlCTHdHa2ViaHAvSkl6OHlNSmN5WHI0?=
 =?utf-8?B?VFkrZ1RCTW5aVG9yOWloTUVsb0k0MXZzdFBhTS9RVWEwL3R3a3pDU2lLWGU0?=
 =?utf-8?B?Nk0zNW03RmpDTjVQOUNmKy9FbE4yTnhHU0x6UEU2amRadkVIYTZuaFFlUjQr?=
 =?utf-8?B?SlFxdjZvbC9sL2E4SG1ZOGpQckRwcUI3TVl0YkdrUlBXM1paYmh2ek5oV00x?=
 =?utf-8?B?dGVpanhCRFhOcDRzdWtFc3lqUTZnSjdNbmtHWmpMYTBGRzZnWGNFSHVZOUE4?=
 =?utf-8?B?aDYzVlRxNGVKLzR2bG04UEZxMDNTWlJLQUlBNlA5bXpCQVBFT1FDVnhFT28r?=
 =?utf-8?B?eUhhQmU0U3Y0Ui95aTVPTnc4N1ZkTzVuTG1WSVZpVkFhTGxBL2xQc094RWI0?=
 =?utf-8?B?SlI5Y2tjZXlYVnRaajNDQXY0OWhYRVNsVFFzak9YMFVjZ05Ob0RrUnZrY3ZT?=
 =?utf-8?B?VUU0N2pHNzIvZVNoTk1hZis2MDdwVzdkT3c5NTJwSWNuWkxjanQ3S2ZQcU1s?=
 =?utf-8?B?RTROd2h2MEx6Y00zQmtGYXc3MHN5dk03MlN1eCsyMEJoOHIrMWM0RkpSbWdj?=
 =?utf-8?B?ZFRUa1ArN25NNGVLdmxyZGlkK1VISzdKbUs4cnE0elE3ajdwNzJWVmZxS0dz?=
 =?utf-8?B?M2lTb2Z3R3FsU3RJb3JMWmdsRThyMU9xUDdVVlFBK2hHV2ZlVmlYQ0FoZkxJ?=
 =?utf-8?B?cE9kU1gzcy8venZwb09ySlZabWR5NDhWWEIyaGNSelVoQ21WdVQ4b2d2OFhu?=
 =?utf-8?B?VzRORWEySEJHZVRQOEdrVWRKWHNVOTVUVFNNOFB4RmU3dFNjaDhlemJ4ZElC?=
 =?utf-8?B?SFladityelQ0dm5kWnN3Vi96Ym1FcUZmRUpOY08xV2JQcm5kOUhnejczVXlt?=
 =?utf-8?B?M0VsaWdWVWpxcmUrY2s0RlNjaTdUcFhqY25pclZaSGZDZkVuVXhVOEtpSTUx?=
 =?utf-8?B?bHZIRzJEMG9pU1Y0MmpuYjhORXhtMUZOcGJhTUVoblZIaXpyb3NBN2NIK2NL?=
 =?utf-8?B?MzRheXc1K0E0b3Z5OFRLcldyR0o2RG5pemJBSmNGUGd0dFdnd3pYS3FLTVVS?=
 =?utf-8?B?OWNCZUZXanFGdkdzLzk2RDROeHRNZXFtUTZPSTQ4WmpOZkZ3M1dCelFNaWJ3?=
 =?utf-8?B?b1NJeDk3MDlCOXBteE00cFFpTDJCeXNWc25CamR0M0NYQ3pFNm9pQ1BJNStw?=
 =?utf-8?B?RVpueS9vOUlYSTVlVFFpQm5sZDV5LzZZSldYWUdoU1VKMUtlNFdtM0t1UUt2?=
 =?utf-8?B?K0pRaWxCSmQzbU5NWURzY1UxR2wxYkhIRkpBL3NaM2lLMldBNWFlRDdtc1Y2?=
 =?utf-8?B?eHI1VS9IeFFMVWY4bzlXVU10ZWRYT1VRWnpDdDExT2g1VXhJdHRCR0Z4R1Yz?=
 =?utf-8?B?L2Fla25zOHgzUWJFMkwvUFFSNERoOHg1dVNMNURGRHBEZmVtQnFyT1BHWWp0?=
 =?utf-8?B?T1RFdE5jNlRUT2JKam9hQ0JzTUQ1QzkvVk1sQUdlMU10TUxzcitSa04xQ1NT?=
 =?utf-8?B?Ulo3eGd2d2o5dDVqN2tScmV6VU9IaExNNWFFVVNGQUdNZ092cDJaOE13Z2Yr?=
 =?utf-8?B?ZEtMY2NvOXdKdG5nV0kwT0xpWGp0RnRVa2tVYUZRS0xYOUdHMDFGaEhlL1JO?=
 =?utf-8?B?SW95WDNrL3FBcmJjdUJxUS9ucDl0RE91U2xpNWxMVFZHZUVBM0pVcUFyNDFN?=
 =?utf-8?Q?xHbNmx4E9tH07?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0ZDc0d5UWU1M0NsWmdRL1FvQ3R2OVMzVGhOdm9sOERsMGhleDJSdXJJMERR?=
 =?utf-8?B?MnBkUmtoRmIyazNxdytPc3FwS2VpelJiY1pIUCtGY1k3Ti93WU9TeFZUY09w?=
 =?utf-8?B?UHhwWmlZMDBoYURlTTJlTXB4dnZ2eXI5NURsamhXcFpDZkF3UHFpeUdBZjlF?=
 =?utf-8?B?VkVpQ3U4Qy81VGFOdzhHLzYrT3F3SVJMYXFYbVFZOEZmNnlFTlhWMVdxeHkz?=
 =?utf-8?B?d0Y3OE03L2hnczJubTJURENuZDNTWkVZZ0FuSDJKeWRzS1RLbEVBcnpFZTFG?=
 =?utf-8?B?SmlSVDB0M1hDd1R6QlcrckFHa3hMTEFZQ0IyTWZYcWlrYWpvdHBZamh6eVNz?=
 =?utf-8?B?OW5IMVI5TUdOY2RCTDJ1dTl5WkxDV1R3UjZLNmVCdGtJSHZxSmRteUZlcHBp?=
 =?utf-8?B?NVhCT2FBQXhNZml0RjVlZW9md2VrTDd6NlY4TjFSTUlCMzYxcEJSb1hGVzZy?=
 =?utf-8?B?clJLQjBaelRvaldYeWJORUdDN0VEbjh2a2Z1MysvWDhIZHpkTzErMDRPY3Ey?=
 =?utf-8?B?cjcwMWMyMGtuRTR1cW5JVHlGM3J6NnJMMGdFR3NPRDA3UCtJQlNOblowNUhT?=
 =?utf-8?B?TVhWcjR5V2FoRElzSVNXT29ybjRTeHl0b0d3SkFNZFVQNmRvcnhmN3NKSVFD?=
 =?utf-8?B?NkJIODdEeDBlOS9xVGVHOUpqbjZBUThOOEFQREJIRDZ4WDJmbDkwWGNkRkJv?=
 =?utf-8?B?aCttUDVqdkxIbEM5QlVPWGZUYmhRckRzTjBCRnJVNmVJNG9OR2Z1YzNRN1NW?=
 =?utf-8?B?bUJHQkhjRlVrVnNiOUJKa2M0SDJwNWZNK2tsd3F6VDVkV1Z4L2ZneTNKN0hw?=
 =?utf-8?B?YnNSQVBmd2REbWVLMis5bmcrb21RWWd1S1VTY1EyT1RRU0haRmE5RFJVck93?=
 =?utf-8?B?NFU2d0c3RDBmYmFyRGxiVWJtVEx2VTNmdkJVME8rVTZTUHYwRENJeXI3dWx2?=
 =?utf-8?B?ZkZTWUR4eGJlZUlZSGFwak41VmF0V29Ub3VRSE5Cd3h1WnY3QTY4WTZDVERi?=
 =?utf-8?B?UzMrVTdGSllkcnM1V3VjdE5uKzJQNjc4MFFwT3k2eWdiMExQdGVEMUUwYllO?=
 =?utf-8?B?a01oeGx0clVTMlc5MGdqVEQvWUwzWkhLUzFyTHpDU2k2TkVtZFlWeUF0Tks3?=
 =?utf-8?B?c1RTT0FIRnFWVjZpNlBRZk9Gc01JVng1clAveUtSbFJMdFptSmNsWnRvNVc2?=
 =?utf-8?B?R2FmSUxIOXh1QlNKd3h0UGphZFpIdHR6N2FlSWZIajJpUndIZW9nRllGZWcr?=
 =?utf-8?B?NUZvc2xnU2RBRDJWbGlIMHg3VklYWEN6UzhDdDRWbzhCVjlCL25MMmhldVhC?=
 =?utf-8?B?bEtwdk1kaVBicEVkR3R4U0JRdlNsRDVocGtnQUFVQ3BzeHRTNngvUlFUYmg2?=
 =?utf-8?B?SnJJSVdmcjlJWVlXeXdVelExaU96aVVSNGxIc3MrdnVqUjV4UHNua3lONVFi?=
 =?utf-8?B?ZFNWTzV1enhZU0hENzdmT3N6N3FORDZpd2dCdUhsRE16YmNNYnFWZ0JxQ0Jw?=
 =?utf-8?B?ZFFDZThxOE1DV2dOU0ZQYi8raTRBK1I3aTJUMTZwRnVrTlFnRDBYNThHYzlu?=
 =?utf-8?B?cityTE1jTmViWTdUQ0hkWUpLNEE1aWdkcXZjNzN0d0xZSENMWFY5Nml3ak9r?=
 =?utf-8?B?dXRTbFczVTNmZnBkVHlicmMxeHdiQkpaMndOY0NDK0FkMHg0SzBUVm9qSVRp?=
 =?utf-8?B?Yk91emU4NnB3SWtyTzFMb3pHODJ5NUxqcGlKL2dsYUQ2ai9OYWlTb3R0Q3M2?=
 =?utf-8?B?cjdPdmlEK0k5eHhaeWJnZEV3YXFvdUpJOVVNdFFGYjNDRWxYb00vMHJOcXN4?=
 =?utf-8?B?WktacU9jdGxnOVkyOC92ZkZxcnZ6bzNLTXdZbnhPaWpiUUd2aVJmU0tvd3Zo?=
 =?utf-8?B?ZHBHY29PMU8zT0hyQTYyU1VZSlJPY2Z5NWZFa3NPUUpjd1MwR1FzOHRTZXpS?=
 =?utf-8?B?Q3loMHdLU1JvTTZ2cnFzUlJqb05pbzB6UmhDOElKazhsZlF3dUJDdml6UCt4?=
 =?utf-8?B?ZExYTGhRQ09LZkpzUEhiQVp4YmZRTUUyRENPMXNiSTlhMko2L0NLR21qLzdo?=
 =?utf-8?B?a3B6bjNDRUk0eVNha3h5cFg2dEpXZDhBYXFLemh4WlB2cXV6ZFZQbnVLM2c3?=
 =?utf-8?B?Vm9SSTlKVWdLMFFyci9VcnQ5R0VwTUxHUDBYR1hXVlhqM1k4Rkd2bUVWZnR1?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d6b542-8866-401e-34c4-08dd62d12e7c
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 08:21:12.7425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HpIDyL/MTEqbEa5vXlbTAzFt4lmtT1VjpMSxDN79hY/8SffMVAkDlDn+GPX3smEvCrfsSdYjoEc36IKeefNiyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4965
X-OriginatorOrg: intel.com

Hi David & Alexey,

To keep the bitmap aligned, I add the undo operation for
set_memory_attributes() and use the bitmap + replay callback to do
set_memory_attributes(). Does this change make sense?

Alexey, I didn't add your Reivewed-by since this patch introduced some
new changes.

On 3/10/2025 4:18 PM, Chenyi Qiang wrote:
> Introduce a new field, memory_attribute_manager, in RAMBlock to link to
> an MemoryAttributeManager object. This change centralizes all
> guest_memfd state information (like fd and shared_bitmap) within a
> RAMBlock, making it easier to manage.
> 
> Use the realize()/unrealize() helpers to initialize/uninitialize the
> MemoryAttributeManager object. Register/unregister the object in the
> target RAMBlock's MemoryRegion when creating guest_memfd.
> 
> In the kvm_convert_memory() function, manage memory state changes by
> using the shared_bitmap to call set_attribute() only on the specific
> memory range. Additionally, use the
> memory_attribute_manager_state_change() helper to notify the reigstered
> RamDiscardListener of these changes.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v3:
>     - Use ram_discard_manager_reply_populated/discarded() to set the
>       memory attribute and add the undo support if state_change()
>       failed.
>     - Didn't add Reviewed-by from Alexey due to the new changes in this
>       commit.
> 
> Changes in v2:
>     - Introduce a new field memory_attribute_manager in RAMBlock.
>     - Move the state_change() handling during page conversion in this patch.
>     - Undo what we did if it fails to set.
>     - Change the order of close(guest_memfd) and memory_attribute_manager cleanup.
> ---
>  accel/kvm/kvm-all.c     | 50 +++++++++++++++++++++++++++++++++++++++--
>  include/exec/ramblock.h |  2 ++
>  system/physmem.c        | 13 +++++++++++
>  3 files changed, 63 insertions(+), 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index c1fea69d58..a89c5655e8 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -48,6 +48,7 @@
>  #include "kvm-cpus.h"
>  #include "system/dirtylimit.h"
>  #include "qemu/range.h"
> +#include "system/memory-attribute-manager.h"
>  
>  #include "hw/boards.h"
>  #include "system/stats.h"
> @@ -3018,6 +3019,25 @@ static void kvm_eat_signals(CPUState *cpu)
>      } while (sigismember(&chkset, SIG_IPI));
>  }
>  
> +typedef struct SetMemoryAttribute {
> +    bool to_private;
> +} SetMemoryAttribute;
> +
> +static int kvm_set_memory_attributes_cb(MemoryRegionSection *section,
> +                                        void *opaque)
> +{
> +    hwaddr start = section->offset_within_address_space;
> +    hwaddr size = section->size;
> +    SetMemoryAttribute *args = opaque;
> +    bool to_private = args->to_private;
> +
> +    if (to_private) {
> +        return kvm_set_memory_attributes_private(start, size);
> +    } else {
> +        return kvm_set_memory_attributes_shared(start, size);
> +    }
> +}
> +
>  int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>  {
>      MemoryRegionSection section;
> @@ -3026,6 +3046,7 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>      RAMBlock *rb;
>      void *addr;
>      int ret = -EINVAL;
> +    SetMemoryAttribute args = { .to_private = to_private };
>  
>      trace_kvm_convert_memory(start, size, to_private ? "shared_to_private" : "private_to_shared");
>  
> @@ -3077,9 +3098,13 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>      }
>  
>      if (to_private) {
> -        ret = kvm_set_memory_attributes_private(start, size);
> +        ret = ram_discard_manager_replay_populated(mr->rdm, &section,
> +                                                   kvm_set_memory_attributes_cb,
> +                                                   &args);
>      } else {
> -        ret = kvm_set_memory_attributes_shared(start, size);
> +        ret = ram_discard_manager_replay_discarded(mr->rdm, &section,
> +                                                   kvm_set_memory_attributes_cb,
> +                                                   &args);
>      }
>      if (ret) {
>          goto out_unref;
> @@ -3088,6 +3113,27 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>      addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>      rb = qemu_ram_block_from_host(addr, false, &offset);
>  
> +    ret = memory_attribute_manager_state_change(MEMORY_ATTRIBUTE_MANAGER(mr->rdm),
> +                                                offset, size, to_private);
> +    if (ret) {
> +        warn_report("Failed to notify the listener the state change of "
> +                    "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
> +                    start, size, to_private ? "private" : "shared");
> +        args.to_private = !to_private;
> +        if (to_private) {
> +            ret = ram_discard_manager_replay_populated(mr->rdm, &section,
> +                                                       kvm_set_memory_attributes_cb,
> +                                                       &args);
> +        } else {
> +            ret = ram_discard_manager_replay_discarded(mr->rdm, &section,
> +                                                       kvm_set_memory_attributes_cb,
> +                                                       &args);
> +        }
> +        if (ret) {
> +            goto out_unref;
> +        }
> +    }
> +
>      if (to_private) {
>          if (rb->page_size != qemu_real_host_page_size()) {
>              /*
> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
> index 0babd105c0..06fd365326 100644
> --- a/include/exec/ramblock.h
> +++ b/include/exec/ramblock.h
> @@ -23,6 +23,7 @@
>  #include "cpu-common.h"
>  #include "qemu/rcu.h"
>  #include "exec/ramlist.h"
> +#include "system/memory-attribute-manager.h"
>  
>  struct RAMBlock {
>      struct rcu_head rcu;
> @@ -42,6 +43,7 @@ struct RAMBlock {
>      int fd;
>      uint64_t fd_offset;
>      int guest_memfd;
> +    MemoryAttributeManager *memory_attribute_manager;
>      size_t page_size;
>      /* dirty bitmap used during migration */
>      unsigned long *bmap;
> diff --git a/system/physmem.c b/system/physmem.c
> index c76503aea8..0ed394c5d2 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -54,6 +54,7 @@
>  #include "system/hostmem.h"
>  #include "system/hw_accel.h"
>  #include "system/xen-mapcache.h"
> +#include "system/memory-attribute-manager.h"
>  #include "trace.h"
>  
>  #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
> @@ -1885,6 +1886,16 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>              qemu_mutex_unlock_ramlist();
>              goto out_free;
>          }
> +
> +        new_block->memory_attribute_manager = MEMORY_ATTRIBUTE_MANAGER(object_new(TYPE_MEMORY_ATTRIBUTE_MANAGER));
> +        if (memory_attribute_manager_realize(new_block->memory_attribute_manager, new_block->mr)) {
> +            error_setg(errp, "Failed to realize memory attribute manager");
> +            object_unref(OBJECT(new_block->memory_attribute_manager));
> +            close(new_block->guest_memfd);
> +            ram_block_discard_require(false);
> +            qemu_mutex_unlock_ramlist();
> +            goto out_free;
> +        }
>      }
>  
>      ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
> @@ -2138,6 +2149,8 @@ static void reclaim_ramblock(RAMBlock *block)
>      }
>  
>      if (block->guest_memfd >= 0) {
> +        memory_attribute_manager_unrealize(block->memory_attribute_manager);
> +        object_unref(OBJECT(block->memory_attribute_manager));
>          close(block->guest_memfd);
>          ram_block_discard_require(false);
>      }


