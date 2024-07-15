Return-Path: <kvm+bounces-21635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AAA930FDC
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06F6D1C2124D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48AA413AD16;
	Mon, 15 Jul 2024 08:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iUbidYxj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA8C1836CE
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 08:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721032409; cv=fail; b=YASCo24aZSy0BrJ6mbMsVnKegwcCVGAJ7r8rBvPng73Rm6rOKFRXEVc1WQ06JyN1W+3y8Cfnj9R0SNjChW+jPV5qL8h74C1vdzHDNoB/IYCeBSkG4O8+jF+iYlI6CXi6RlHCzNG6RsBQ5j6BD5Z2cHTu0/EfptyQ2s1fLT9LKEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721032409; c=relaxed/simple;
	bh=0MsSa7o5h+FAf/M3/8atY9MYoSDSBf5G3HvasXFLHLM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BfKeSAvdBMIr6nq7T1FMV+bVaqPvqA6sDl6mJAPtCOCa7C0xsywz/ucSy8v3Ki2pHO0SqreIMlXsrkogJ0t9rC+pD04LNIqOMDeGVsDsIrQQIOpdiLDGOOvFwTSc4Qbw479Zz7/BviJKFQStkjJaTEk3skmnEkmBB8csb2JxWWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iUbidYxj; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721032408; x=1752568408;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0MsSa7o5h+FAf/M3/8atY9MYoSDSBf5G3HvasXFLHLM=;
  b=iUbidYxjV7aPAKABG7D2+hZ940HSI14yB/+LT/H2GmnaSXTf7fpmPcuh
   3EOKoKWDxzh4c4EqIxSHn+B3oHVcBB4lfkR3hJXyVUuylozPQ3rAEGCfI
   C7yrTI7WiqnuiZ+pfDQCSiitx7K8pSJZgmEix7X4PYzuCj+1xE+ri/4we
   jkYl/TpK9+gPdHWmDMhw8SutQhpwgxgfC9Urz5FKziMeP2nOVYQtuU9Mv
   A43Fdy2m2ZPpBmDI2aHK2IipkX+G1OLIVmeldx8rScXEYf4OW0/uqw1+q
   A8Ep8vDob3evwUSkAuKLTJ0uD2dpu5JxyUildcmsQez9ctW0Nt5LZpcWf
   Q==;
X-CSE-ConnectionGUID: DTangcvPRLuuzKwwPv3dGA==
X-CSE-MsgGUID: UJ1fE56BTkaSWbpgKP+sKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="29809633"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="29809633"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 01:33:27 -0700
X-CSE-ConnectionGUID: Wv+h8C36Tt2abfq6lHyR9Q==
X-CSE-MsgGUID: Kr0qlMKdTT+VxslsnZRTqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="49638249"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 01:33:26 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 01:33:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 01:33:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 01:33:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GapSEtigJBxeQwrH9eUnEcGLX3WfNFDMmqSD0/Otm81eK8zOdTgFFVmtaztVVp+ZlnaJSpQuo95A8Q4j2k+NXAgxWEGehnD7Ep/9Iv40D34fCt5kfsHk8XDG/qy1E+8cRUGkkbR48/VuCMwk2iw/U5xkDmOuw/IGpA2yAWFx1UMTXaPmKl386ETEYYywNrsv0qfyU/8qSJJ3UeAqK0b6JZgTXK6lnEG5U0IffJ4kmiPx/IIDzkGxQFDj6QMAt3EFTzSBwnrZNBVLZVNlNsjxuzgMfL+A5LdBPwVh2z76itDTqBv1m+dJEQQvU0OAsHlUOOpEKqBA3GffZcV/687C/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixxLsP+VALJI6Ij9i3VCJ4pl6I9J6NCN9CAI1CeV7wc=;
 b=lVK7rlA1RFCVqS4G04g9CU6iNGXXvEwNnMootDUjZbueDgS8M6fRUC8ODZnCkDp37PTCeg67dgNho/FT/oUqDFf05kJ1ZioR6WNzNXvJvYd0Rhf9b1PZnW19S4bI/VBE9QwTKJVoV7t8VUFkr3Xoha7+npJcVEVipWWJE0NOdaYM2eYMECTGweqc0hyD/fn804TZvAqMLhTRxOKQ7ZjLr1/qMcJfRYs3Y5KHnhZmPfgFwvgmNFchMM75Q3jQlb+Q5bx5d/oeUlKOuxoqsWqX9GgAkH7u6l9DAIoFM5ojmIEbm55V1cSQbvxtmTdKInpT4w8FEbt3f/8AAwdlEIMuSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5878.namprd11.prod.outlook.com (2603:10b6:510:14c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.22; Mon, 15 Jul
 2024 08:33:22 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 08:33:22 +0000
Message-ID: <7dd86099-3f86-49f5-b298-00af81009548@intel.com>
Date: Mon, 15 Jul 2024 16:37:18 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] iommu: Make set_dev_pasid op support domain
 replacement
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-7-yi.l.liu@intel.com>
 <BN9PR11MB527693855A23F517DE3830FB8CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB527693855A23F517DE3830FB8CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: 1842f917-02fa-40cc-382c-08dca4a8c985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dE1DZFpjckdabXE0VzRXS24vYkV3SGVnQUNVU212OE9Dd2xmczYwOEtLaTM2?=
 =?utf-8?B?RTlaR0kxQUxLelgxdS9oLzFTSkk1bGp3MTBGYURCUTBpSjltY3hsZE80ZDVr?=
 =?utf-8?B?d3lkbGdVd0RmcFVKdDUxNlY1YVdyNHhLbjgvam9tMmNEYXBkL0pYNVBGMGx3?=
 =?utf-8?B?MnhZb1BtaXREV0ppWVV0d3BQK2FCdWVDakJEc2xJajlPa3B3eEpMVm9SZ3Mw?=
 =?utf-8?B?REJLTEhycFhjSnYvM21YQ3FuQVJZcytzSlhDSFRSMGVWRlVuSHlScXVSNlNU?=
 =?utf-8?B?bkNZQnZRMno3WjFrbTR3OGt4dUFib05GZGE5anlacFMrVWpQejgzOTRXbTlk?=
 =?utf-8?B?UkN5MTdHaXhKL1B0bEVFb3hNZ2w1bEI5S3dLcWIzNUxzNXpIVENicU1DMk8v?=
 =?utf-8?B?MXRldXJwYllLZlZRYmdJRldqaGl1Z2FnZlgxUkdOQ1VEY3Q4YVNzeXVDdEth?=
 =?utf-8?B?bjFDWWs2YXRVUUdlRDI3M2QzVmlya3VXN21VZ1JOdGdrdlBKS1QreGkzZnVI?=
 =?utf-8?B?VGdzYURFREZ6Ulc5V0J0aE9PQks4T3FLZFhRZjFmTi91a2IraXROY01VSVFY?=
 =?utf-8?B?ZjF2OEc2ZzU5L2pqUFdTYTdrTm5EK3NyaGM3T21weDFnK2VNQWdLaDNwajVy?=
 =?utf-8?B?K1ZaVEttNGVybmYzS2VETHB4b2I1eHh4cWdkZnRocDhsRHZ2ZkJ4SmgvR0Fv?=
 =?utf-8?B?a1R6R2ZLQTQwc0VlaUJ4bjRMMVpwLzZ0eDY5UE14emNJcEZERWFQYm1WK3hz?=
 =?utf-8?B?N3pLNkFHRUgxWDZwVGorYXc2QmhuUUN5ZkJTQ0NweUpmQlRYbWlkUm81T1A5?=
 =?utf-8?B?M3hTeUs3NE8yWHRaN2NxdGNVUUpmNWJnV1RJUkhrS0Y2TkdIWUhTeEx2YVUz?=
 =?utf-8?B?d056MU1lai9jM3MzOS83a0hpVnJvQitEbmNjL3A2ZnpiaWgzQTYvMGhGV0th?=
 =?utf-8?B?RVBqS0p5UCtTTjRjRGMyRzVOLzVpN1UrMnVkZUFLQzRaZHdpYXFsY3B1VExx?=
 =?utf-8?B?SW9GdFNvdG4zN3VDU3FmUks5WHlWVVdPb1l3WGtRQlhtWU5mMDhoUjhxc2JY?=
 =?utf-8?B?bFprVTU1SHJFakVNN2NkYytNOHBWRzdxZWs0K3NicDUrRXI4cDNlTVVsaTNt?=
 =?utf-8?B?dE9BWWtwR0w1NzQzVWsrbG5ad2NOWnFTaTlsdGhtN2xRUnFUNjltdFpJNktN?=
 =?utf-8?B?d0R6NzgyZzFNeVkydVVhNzVHZHZ2VXl5WlRrN1dneG13cDlvMTJRT3lIMkY0?=
 =?utf-8?B?VitJTFRwaUhVZHJ5eXRUNCtUbCtOOWoyZHd4S2RHbDcwanRMS1pUbldESmV3?=
 =?utf-8?B?UkkzQlcrbXpXNU9wdnZHT0dIbzhzV25EZFBrWktDekQwc04wSHZTSldHZ3Rr?=
 =?utf-8?B?S3BBOUNHUFR3U3ZFekhWa0hZUkVWdkgxK3BiVEJyc0hvL0o0YmNqL0RicnIx?=
 =?utf-8?B?a1ZxaElVMjZrVTUzOHk0L0g2NktVQjJjTTYvMTIwUGM5L2UwRnQ4RDh5LzBZ?=
 =?utf-8?B?bWUwdThNS2N0Z2lxRHJTSjZjOCtVWTB0S0ZDYzJMTVdyQWZBQ2IyWnBaMU5r?=
 =?utf-8?B?ZVRSODg2NGdrVVJEd0xUcjkzSmRwaEJpK3lNVFg3SXJZa01iRzBXdFhGMGNU?=
 =?utf-8?B?WlFaN2xPZFY5WitjV0hsMXF5M0ZtdzQwbVBxN2h6b1dMYUZLK1RoZDhFUUlu?=
 =?utf-8?B?N042NCtYa0hseHJOWDVNSEhPc2lhQ0NWZ09URHFXOFd5bERZK2xvQzJJV1h4?=
 =?utf-8?B?ZUF5bmwwcUdJTzhMczV5MEYvaHRvem4zdnJyLzdSb3MySnR5OHJOL3dHZUJj?=
 =?utf-8?B?UTVyRld2NS84NEFFQ1lhdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlJZckZsT29PczFkTm93bWJBbWUzY095RjU0NHU3NjMzQXp6ZlN2QXZ6Nnc4?=
 =?utf-8?B?dGxuM3ZhaTYxSkY5WkpMbTd2MVVTL2ZsVjYxTWRwUXhkaUFUTU1tSVcySEhj?=
 =?utf-8?B?c3BSc0hBSjMvNzdnK3RZK3dnVU4wOGR0dHkzYk9ZbU5KV1dJUjRzR1dlUWsx?=
 =?utf-8?B?VGhXTmx5ems2UW5WNytIR1JpMGwwMWZmYnJ3MUloeFFTQktHdXF4V09wZUp5?=
 =?utf-8?B?bi9OTzJ6alJLcGVVdzkwL1NFejdxcDhLbHo2VzBPbjl1SDNPbjArQ0VjT1VV?=
 =?utf-8?B?em90bE9sME5ZOWlKQlhLWldHTVlzMUMzZWY5TDJBWlFpaHRwdzQ2WEFhU2dq?=
 =?utf-8?B?MC9SVDhYWXhLTVNKbjF2VG1XU21taDZLQ2J2THZqSWFtM3ZaNXNpb3ZiM1dP?=
 =?utf-8?B?Yis5QStIQzArY3NieEFuc1dyL2tRcnhWWFRiM2t2anpFbG1ubjhYb0NlRkZ2?=
 =?utf-8?B?NmcyY3lNN0ZFck01eWRJcis0MzF0Yk5wMldEVlJwV1dBVzJMbzJHWmRob2hz?=
 =?utf-8?B?b01yT2QrQitHdlZkWlQ0dlNwWlMwd3RmbXVPcUwxeHhpK0hVMmJxajV5cm1Z?=
 =?utf-8?B?U0FVU0VVbms3NkdGRlhVZTB4ZWFBam9PMjN2L1NaU25ldEFkWFpCdytMWjR6?=
 =?utf-8?B?bmN3VXlXRjAzekpxVkZwUGJHdmhpeDl6VmYzYVJ0cmFjQ1BEL0JuZXBoVlBR?=
 =?utf-8?B?elNSQUhoTVFQb1plOW94c3drWkkrcGZsRndMOU9teC93Zk5QSFBWQlVYRDd3?=
 =?utf-8?B?TnNDa1NlRU4wMVpQbTljaDZIK3R5REp2bDE2K0oxbWxrZ3hzaXZIcllPRlRL?=
 =?utf-8?B?dEExNWpNRDRWemVVWFVOWXNNTVJtd2hTS1FzNFJCZDdySkE2RndQelJWVStS?=
 =?utf-8?B?TDV2VnFDMnNKaFlxU2VEa1JhOEt3V1QwdnhaRGV1Sit2dEllVkxybVowTmhL?=
 =?utf-8?B?SXh1TzdMWG5UcXFlVkU5c1NlSit2bUZLaHNCS2pRcVNMM0czVUVXclVNaENr?=
 =?utf-8?B?ZFlnb2hzdWs0T1dUd3BSOEl5aDdlNTZhZ3VGWW1qUUZ2Y2VraW8xQXdzT0V4?=
 =?utf-8?B?akJGMTc0azVCbmY1dFhXWXd1cU9nTzFsUXN5Nks5RlkwN21heTZuVTJQdlRR?=
 =?utf-8?B?MFQ2eVBSOHhuZjEvcnloU09lNlpaNUQwbjljY1FKS2tpRGd5TzNZNFBTYkY2?=
 =?utf-8?B?RndKRkM5NTJxZEptTG1WWjVDMDdLajkxeHhWbDgvbnpTN25uK3d2QnNDL282?=
 =?utf-8?B?dVFZOFdIKzhmN05maldJdG5FTG9lVDhxUWNPWGNrdG9wU1dMQWFydkQ5RFVK?=
 =?utf-8?B?Tk03bno2a1N5UytZZnJ6MmZvL08zYVZRbG9FNGZtV0Jjb2dHZC9hU2UrTEUy?=
 =?utf-8?B?QlVzTEMyUUtlQmdRRXhMVjBvb2pyZmdQMWtDallmeVBaZ2ZqeUJFQmRpWGpV?=
 =?utf-8?B?bkkxTUlTTS9vbkpvVDBtMFhaSmtXRkFMUXR2RUNQaEV3YXdMTHI3ejZNWmVT?=
 =?utf-8?B?RzJvL3FINXdnOXVQSDlpbFhQakttQmxUZVpqRGhDMnI2L000N1BrM09TR2g4?=
 =?utf-8?B?VzZJUHR2TWhHMmxBRzBZZnBLdkRzdmxTTkJEU2U2RFBmSmRZSWloNGU3UDlX?=
 =?utf-8?B?SU5hbDhYcEhxeGo4WGt3Yjh1dTIwUTNRYmlaZi81TFZabjE4aE9mQTVVYjZX?=
 =?utf-8?B?YkRlbXh1OUI0N3FYMitMZERsV1ZDeHA1NC9YY242NFZOVkZaY216SjZmRnpJ?=
 =?utf-8?B?UG1VcmJsQnpPOTdzcmFsU3c3UlBDaS8rL0xxaW0yQmpTY0pZcGNROStaWUhi?=
 =?utf-8?B?bUpOZnFLVWFEN25ObDZxVGFZVEswbnEvVlhVd3Y3U3B0dmdVTThMZSs3NFRt?=
 =?utf-8?B?bytteDZqUWZlQ2F6cW04MjNQWkE4eThIUkdBUHNkbE11N052UkRaUVBYVEtm?=
 =?utf-8?B?YjdxTXlCVWpRV3JleXVHNjdOU0l5YVlrU3lHZ2RoNmdhaFpQaHIzSEp1UVJ0?=
 =?utf-8?B?K0tWWXJTVG1UeVc3K08zQVNaMDVmVHdva0hLUFlpNE8xNjg3VlZBdFRrU3pX?=
 =?utf-8?B?bGdWSUtmdHgrVm0xaXVoZ3JLRjNRa0FhZlVFTU1kd2Q2bm4zSWZIaWpBY1Zh?=
 =?utf-8?Q?/tTIRbkSJY5/+alJwLopVpDh/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1842f917-02fa-40cc-382c-08dca4a8c985
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 08:33:22.4859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMW2XsR91fRwJ5VSYXTyZAz4Bmv/SP14wGzsXOz3nDYv/y5UEZRJq69plOOqUJeznJHQasp1iEsZVRbHaZATfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5878
X-OriginatorOrg: intel.com

On 2024/7/15 16:02, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, June 28, 2024 4:56 PM
>>
>> The iommu core is going to support domain replacement for pasid, it needs
>> to make the set_dev_pasid op support replacing domain and keep the old
>> domain config in the failure case.
>>
>> Currently only the Intel iommu driver supports the latest set_dev_pasid
>> op definition. ARM and AMD iommu driver do not support domain
>> replacement
>> for pasid yet, both drivers would fail the set_dev_pasid op to keep the
>> old config if the input @old is non-NULL.
> 
> why splitting this from patch01?

The major reason is we already have multiple set_dev_pasid callbacks. It's
better to make the existing callbacks suit the new definition before
claiming it. Although this is not quite true for ARM and AMD since their
set_dev_pasid() callback would fail replacement attempts. But it looks
like there is no pasid domain replacement usage on AMD and ARM due to arch
difference.

>>
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/amd/pasid.c                       | 3 +++
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
>>   include/linux/iommu.h                           | 3 ++-
>>   3 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
>> index 77bf5f5f947a..30e27bda3fac 100644
>> --- a/drivers/iommu/amd/pasid.c
>> +++ b/drivers/iommu/amd/pasid.c
>> @@ -109,6 +109,9 @@ int iommu_sva_set_dev_pasid(struct iommu_domain
>> *domain,
>>   	unsigned long flags;
>>   	int ret = -EINVAL;
>>
>> +	if (old)
>> +		return -EOPNOTSUPP;
>> +
>>   	/* PASID zero is used for requests from the I/O device without PASID
>> */
>>   	if (!is_pasid_valid(dev_data, pasid))
>>   		return ret;
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
>> index c058949749cb..a1e411c71efa 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
>> @@ -637,6 +637,9 @@ static int arm_smmu_sva_set_dev_pasid(struct
>> iommu_domain *domain,
>>   	int ret = 0;
>>   	struct mm_struct *mm = domain->mm;
>>
>> +	if (old)
>> +		return -EOPNOTSUPP;
>> +
>>   	if (mm_get_enqcmd_pasid(mm) != id)
>>   		return -EINVAL;
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index a33f53aab61b..3259f77ff2e3 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -607,7 +607,8 @@ struct iommu_ops {
>>    * * EBUSY	- device is attached to a domain and cannot be changed
>>    * * ENODEV	- device specific errors, not able to be attached
>>    * * <others>	- treated as ENODEV by the caller. Use is discouraged
>> - * @set_dev_pasid: set an iommu domain to a pasid of device
>> + * @set_dev_pasid: set or replace an iommu domain to a pasid of device.
>> The pasid of
>> + *                 the device should be left in the old config in error case.
>>    * @map_pages: map a physically contiguous set of pages of the same size
>> to
>>    *             an iommu domain.
>>    * @unmap_pages: unmap a number of pages of the same size from an
>> iommu domain
>> --
>> 2.34.1
> 

-- 
Regards,
Yi Liu

