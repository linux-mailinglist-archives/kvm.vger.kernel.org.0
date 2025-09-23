Return-Path: <kvm+bounces-58514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 399D6B94B26
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 09:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE9F4190284A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E1831986E;
	Tue, 23 Sep 2025 07:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SHRkSOcd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5296B311960;
	Tue, 23 Sep 2025 07:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758611082; cv=fail; b=hbveIm4DncoXeO7uvbfCip/oiXsbeMNdJbLVjqWvSye095IqVsQc2m0SOEZZBUqB34m/zCsFDXKztuQmGMtuEaOZ90t7QnMGwdtGxJkTdsZT7XuXDyVG7tRqUXm8onalZiE6lyVXIMRIBbcypZ+ajjnHcoAC3+ezcvywudSVH10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758611082; c=relaxed/simple;
	bh=yMFCmWVjiMtiR9NSrGVz2QFFtDgvD7TPq9FppRs8xUA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E/mw2tR1VfOO1flpVKyH8affdsOy26+9sHedi4xuGSBK9nmQqB/mKwU85hEIZoC/vroe+dhD6XKrVeKfX+GAVylC58nn1gshE18t2/N+uu8Bytso6DdyPOP1W0Tl92xyK9owR7JGwlYBoLD4gFsMR0B084Z4GJwid5ppqz/vf7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SHRkSOcd; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758611079; x=1790147079;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=yMFCmWVjiMtiR9NSrGVz2QFFtDgvD7TPq9FppRs8xUA=;
  b=SHRkSOcd5zZnjIfRjwEl7G+Q+PA46OFzsm9huG4aE27Q16qx+lwWzVfW
   TcYd24X+uX0LxQMHwJmLbd0VpP06EG87mEx+VS2HLeiOWFLbhf8wzEehq
   zM01peDk3XB4HWkPEW5uEVD9xONQyS+vWnF1i0hvjrIOr5d3bVwYNkL3b
   QEx00AzOZI0zT7Ve81It/gD+V67zJlEDfELLFOHbn1/xstDy3aoc50/K+
   KfZVukhOizv6xyvbTTTvK5SsCHVm6OgY7paBPZskKYa7/mk2fCj/JB/ne
   99UBTx0930bAlLmn0riRrKlT7g2BAT2GoFxY9dNNErbQKuU+MrUKp8XjF
   Q==;
X-CSE-ConnectionGUID: +/PmxI4TQH2urtzZArEXIQ==
X-CSE-MsgGUID: vY22MTegRuuxmBMcDG6m+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="83485919"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="83485919"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 00:04:38 -0700
X-CSE-ConnectionGUID: zMQROwUVTjKFoiWdh7Y8Jw==
X-CSE-MsgGUID: xhkBHFB8QCOzIhKjSAz97g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="180984609"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 00:04:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 00:04:38 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 00:04:38 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.66) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 00:04:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I3GrrOGUqma2hBg6+373GgFCkprE3y5mGXldKq3qLC+oNNY818bYJMbTCrFcYqmhlGa7AqyPCdyilPnR2B3XqPwleewN9uk26CNtLPu4abF5HVlNPOMjZaOsSKzTi3Wq9rcFQjtS6ZZkIGEluL1uedw0dDYVJAsYcgRbmaVqDK+ZZGN2z7s1pGJaaYaW/9+3I+HjkB7dqyUj1JGysvT9zD8Ok/SxpNrRpG2Nt0WEXE0L+1qJk3+yJHI1AybfVrfRfGqfLxTJBJ4+SNRcxWa0QpILg5OaTWLa4y1Fb0qFDB9c9KodcVG4sjvBdIzZ2nLIgFnTiPQqWSXvVXPtVzKr9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DwrvwpNhhz7M1DW7rXWdk2LcUPq9uuVFKwxWJR9lM3E=;
 b=LukK3vmIsbHI6yX+PYB3rGJYljzVsjjnfTzhE43F8caDTjdZKwbd7uxvzvaXPDTQGlIrV26doShY6qni3aW8hULCgi6CppuwvG8MqZ9pGSE1npd+oIhIr36ShbT0MVGSsJMuTJYqZl+rkW+lCw6ODEcwQMt/lwxfmtA9h9yZvVSsA7u2ybKAS4NMEiX2OoSq7N/AGwpag7BGT5O5BcaIREFL+afpT2eHwAmKEkGJe5lQVUsx8O3tqFrYZ9GGLmRsI62oLVGyyYWmNkBIMg93tqMlggYWNaSWBxK8UNKcuIyAynV4E4PxIcjJp5zNDw9ybd37k8WcfkuchDzf48zoaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7074.namprd11.prod.outlook.com (2603:10b6:510:20d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.19; Tue, 23 Sep 2025 07:04:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 07:04:34 +0000
Date: Tue, 23 Sep 2025 15:03:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <kas@kernel.org>, <bp@alien8.de>, <chao.gao@intel.com>,
	<dave.hansen@linux.intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>,
	<vannapurve@google.com>
Subject: Re: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
Message-ID: <aNJGP6lwO9WOqjfh@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:3:18::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 1786e200-9b8f-4ac9-7610-08ddfa6f7387
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NlNzOVV4SlVsazl1RWE4OUJ5T2ZXRDFHUE50TzE4blNUeTJkcnJ1OHpGb0E5?=
 =?utf-8?B?cHFUU2dVNlR2c0tkZXU2WG43NlVsUHVRQW1QSnczb21JS091K29Cd2lNemtp?=
 =?utf-8?B?K1o1ckxyOVZKUThzeFNFclUxSk1PQUVZby9kY0VYSGV6K1BwdTVjc2JDOHpx?=
 =?utf-8?B?bDJEemVtNnhhQlVlbDJrdkRTSnhmazFzUkd2d0FCWFNUdjZON0krY1NoY1ZC?=
 =?utf-8?B?bkxxMXh3UUtseDBYbGdBVDFRRjhWamZ2N1pjTTB1dGhzeVpNdDdWVWc3cTgw?=
 =?utf-8?B?SWdCb3BzL3oxcGFJU3hhYm1OdHpsQXA1a1JZL3ZTMWNSTUQzZlRwWm40TzE5?=
 =?utf-8?B?N1ZMRks0V013ZFNiS0xxRHhJc1FtTVlUOVdGeGRWRngweUhlVHZJY3hKaHZq?=
 =?utf-8?B?blJNNDRiNUVmOWN1Z2tqb1o3NW9jdWZ5eWNLUE9iT2xuOTJYVjNsMmZ2UUp0?=
 =?utf-8?B?cFk2VUxkSTFRUUFjK1M4dXR5Q2hzRS9XVXlUaEFhMUdBMytiM1l5a2tPTWhW?=
 =?utf-8?B?SVpYRVNTcXlOWThTSk1pUWZ5djVDYnoxQmhDWDBoNVcyY09qM0VxOTdWQUlt?=
 =?utf-8?B?M2ZLOEtXR0thZkN6bUxPcWhCRnFvQ2wvanQ3aCtMdGRRVEF5QzJHRUxMbmNG?=
 =?utf-8?B?Zm1JQzdxcnJmSHZNWFcwTlczWS83ZmNDRGJ0ZlM5VFQxK0lEVEk3SW5WSnRM?=
 =?utf-8?B?d3l2ellTVTRPRDZSYmZ4TjB6dmplRHJnSTltcW8zV3ZCaUN2STU2STBQR295?=
 =?utf-8?B?ajNGYXY4ZG05ZGpyeVdtb3MrRHZYd3BmSmJRZTJjSGJkcnFIbHBHeHl0R3ZP?=
 =?utf-8?B?dVZ1OHIvLyt2M1htdUxtZThWQlNFbVQyaUdvQWhHaGFwSkJSamtIL1ZRcnNu?=
 =?utf-8?B?T2lxV01mNk9EME9zOVVheXUwUFlCb3Q4SjlwTGpKWDNDb0gyYitINm8wb2Q0?=
 =?utf-8?B?OUwrbFZPVkc0UE9udS9JZUtheG1JeXhMUGRqeEZsVDFtMDlBb0p5VEVkL2VI?=
 =?utf-8?B?eC92RE8rdGNvTkl4TnVoRk40T0JYY3lmeTVEbGRVN0R3UG9OT1h0dGNvaGhV?=
 =?utf-8?B?cGpZWjlGcDhpUktud2hVSUY3WDFCdWNUdW5salI4MjJSWFM2T3JEL2ExaU9a?=
 =?utf-8?B?SjVSVFZlQlg2MmtmK2kyT0xEN3RBWm5CQVVuRnlnQmc1cVNRZUhQaTA4Ukkv?=
 =?utf-8?B?aE1yRzV6T1l1NVgwczBIUjMwU1dRVnA3TWNWeHIvSGJZVmZJOXo1cnV1d0lY?=
 =?utf-8?B?OFhnVUh4TVFheG50bEZoZW1vb0lsSkorcHJHWFRMYUZpZlpXak1MMGJVL2Zs?=
 =?utf-8?B?UGdJcTZUSE43UFVnYzY5bGdoak81NEhQNU9RbHpndDFFa0IxeHR3Z08zT2cr?=
 =?utf-8?B?VXlLdVZlQlNaYUpQL011cTkzeFU4SXBqS1ozSWp0VU82b0VTN2VkSTh1eXEz?=
 =?utf-8?B?My81TG9rWE9IVGlOSm93U0NWTlRCTGVOU3pqUDJTcTVmUkJxODc3MmI0bDV5?=
 =?utf-8?B?OXY0TnlVNUlDU01YelBqcnJOQlRsbWhIaTNXVjhjb0lGVE50VktPMEJIbU9a?=
 =?utf-8?B?ZzcyM0ppSm9uc2FmM1pVMnR1eU0vQUxOQU9Kak9rQ0RzdjBZc3Y3czBuTGJP?=
 =?utf-8?B?M2c3L1FncGtUZEJnbk9odytSZHdJWUxocTQra2duOWlZc1M3TWdGNXI1ZGUv?=
 =?utf-8?B?WE1VM05IbmJTQ3IxamFiTjNQSnBBbVNIUjQ2UzlnWE5vWjZETzRqb1Zwb2FB?=
 =?utf-8?B?RHY3SktaM3VxclNSVTBLOXN4Ry9wekc3cmcweVk4MUYxYXFHRFVGalFpYkhX?=
 =?utf-8?B?N1luNklWS3k2QmVBcVhyU2Vwei9xWjMrOVYxR2hVZytBd0JFeG1jRkdZd00z?=
 =?utf-8?B?aENOMDhkdXZDaCtTRlpDWlBkeGovdDRHQUNVYkt6bmJwa3hCV1FXajY1cCtB?=
 =?utf-8?Q?S1W8mAkTbQs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWU0eTR3QlVJVFJhVUo5T0x4Nk9PUWhvc2txbXZxdW5wcWh3SWdpTW1GR2xq?=
 =?utf-8?B?S0o3MGF2VmlEQjdmbFJia29xQkY2ZTMvQm40Wk5JbXlTNDNXZVhVMDFFVXNv?=
 =?utf-8?B?ZlFJbGhzeWxPaFNSbFN6UFNMQWZ6d200MkpJMzRmWDNVL0l1RWIzWVlaR2NS?=
 =?utf-8?B?SUI5cWhTZGxBeUplVmJVeEx4SDFrUHN2N0U0M3BNZ3E0S3lNVzhCNk82S1pV?=
 =?utf-8?B?MHJhTlpPR25XQjBrU2VabHZkbjdBV09EVHpPU2VPL2NUUUNLL0ZqVmlOZjJT?=
 =?utf-8?B?MHdjbkxMaVNMclNXUVZyRzlXRS9hblIwL3dKeGppZGVHb1k0bUdyaEljNlRS?=
 =?utf-8?B?OHJQZ2hSWk1vTEJNUmw3emwyUGVFWkJicStzZEpEMFE2cDdYVkl4Wis1MTRF?=
 =?utf-8?B?NGg3eEJVQUN0OVN4ODRoa0wydEdEWldtK2hLNDQxLzBFcjZMUW5YWXFiN3hV?=
 =?utf-8?B?dlRDMStaS3RMZ0I2WmExdnpieXhPVm1wOG5nMWxPTVc5RytXNVpreUJ5dUtz?=
 =?utf-8?B?Z1FBQk9jYnFKZjREZ0VCUHV2cGhYSG1PcHlUbEVOekx2M3laZlk0V1VMWklB?=
 =?utf-8?B?Z25BaFRTQVJ1b0Q1cVhLWk45YzdmalhNVHk0c3dWMFZFM0gxVjdjWDk5cGt5?=
 =?utf-8?B?akl3SDBXL2Y0VWN6VVNUdlhIcG5iYndlOHphYURYZXNndy9zQ24ySnlCbFZj?=
 =?utf-8?B?UGFIaGhQVGVuNHJKc05CUDFmMFpoME1KUzdBNXhKOW8vZ1YzZ2R0SmxVcXZt?=
 =?utf-8?B?VnJ2Zi9lN0xyWWtuMWs2TEpOaEpLZzYvVXlGSVVUWnVaMlZNS1BiL2pxMmdp?=
 =?utf-8?B?UGs1bkMrbHI3WE1KMy9RbFdpZGdNdDVTMUVrNzB6ZGhjSnhaV3pTR0Y2K0xh?=
 =?utf-8?B?Z2p5K0RIanBWU25WQ2Z5cGJoVE9ibldqWE9iNlJZZk1YbG9PZ0N2VUlnN3R2?=
 =?utf-8?B?eS95MTZxYnlLazUyNWVwZUtHNDNjbEMvazYwYnJDeGMzWHNMc1BteGxhN2dt?=
 =?utf-8?B?S2UySWR3RzRqc2laUEFCelhyWXRrZzFhQ2RmS0RiYjN6S1ZtRE4rNnlGa1BQ?=
 =?utf-8?B?c2dRQlkyU05LOHpwaitHaHYweWFiZFVwUVRPbG0wMCtyeG1XODJsdnNjdWRJ?=
 =?utf-8?B?VEd1NzMzUVQ3cnlyQndzV1hiR1BJVDRLMTFhb1N1bWVCUFpLZkxaaUxTUnh3?=
 =?utf-8?B?aDBzbUI5a0VhbWo4NVc1emE2bXZBVWlJNlA5QzNoeDFrVFpFNFdXMVIxVnpH?=
 =?utf-8?B?aHJSVzVIbEFsSG1MQ1d3ak5NTnZubE43NkxSSG8wc1Z4dkQ0QlYvK0VKb1hO?=
 =?utf-8?B?UTdGRlNCczRtekdoUkFiWTNjSTFLb2wvQVJFVmQ3bDYyM09jOWl0V0tINVBa?=
 =?utf-8?B?NXdUQ3FtYnRvYUpJU1VDazVTYW4welV5c2FGVTVmMjY2K2hqZmxXdmFiNW14?=
 =?utf-8?B?Z24zSEp1ckRmMlRZakFabStHU09EeFdNZnVkcUp2Tnp1YWMzc1VXTmw4NHRX?=
 =?utf-8?B?S1oyWXcwZlYyUEhPRGpwaGtIaVJZdFNFNFRDUU9EcDNkQldWS3M2TWdadkJE?=
 =?utf-8?B?QURTaU8rKzNIYkEvWnNRcnMwbm4xUzVzK0hPTElNK3RGRHdZc2dnYTJNZmo2?=
 =?utf-8?B?SEphUDU1MUx6YVkxMkIyVng0RWJGbFFsbWp5cFo4VEtlNDErQ1VlNlVMSDlK?=
 =?utf-8?B?RENNbkdmOXM4enRaKzhwOFl0WnFUZ29VN0NqUFpURWdLQTFSRXZ1UnF5TVhU?=
 =?utf-8?B?TW9YMWZKd0dJTS9adU9WNjhQYng4Mzk2SVFMWVVrQm1JNE4wbmtsSExSRFRw?=
 =?utf-8?B?V3g0cnhTdzU1WHF2WkFxVWEzYllCKyt2MFRvaFQyc2lhSDJ6SFJNQ29HbXE5?=
 =?utf-8?B?cjdjMFd3bGJmeWVublVDRUNpZS9zS1c5aXFlUTVWWVVwb25ZOS9pYTJMMzlZ?=
 =?utf-8?B?ZEJuSTZMTU9sUWQ2MncyMllzTy9xMVE4UEp2MEdyZFN4QlhNdXA0b3RJY3ZC?=
 =?utf-8?B?UHNaVGdPWkF2UXg5a2g3Y29EYVhvSkdCR3c1MnhScU83Y2tsNjZ1eWNMbEs0?=
 =?utf-8?B?R1BBWXNLNVhWZzFuU0ptK1A5a085K1Q3Z0E5cnJxOFZ4UVIxY2tQY284ejJZ?=
 =?utf-8?Q?dOFR9ACNEcpltOlK76+sM6qvN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1786e200-9b8f-4ac9-7610-08ddfa6f7387
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 07:04:34.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePiDMlpuWW1jUrrkBPD9YhOuceuKRCOqwCYS9ak3em0y63gXe47oLdNrK5RRuWcXIr+cR611W+uMRLDuAtotBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7074
X-OriginatorOrg: intel.com

On Thu, Sep 18, 2025 at 04:22:19PM -0700, Rick Edgecombe wrote:
> Move mmu_external_spt_cache behind x86 ops.
> 
> In the mirror/external MMU concept, the KVM MMU manages a non-active EPT
> tree for private memory (the mirror). The actual active EPT tree the
> private memory is protected inside the TDX module. Whenever the mirror EPT
> is changed, it needs to call out into one of a set of x86 opts that
> implement various update operation with TDX specific SEAMCALLs and other
> tricks. These implementations operate on the TDX S-EPT (the external).
> 
> In reality these external operations are designed narrowly with respect to
> TDX particulars. On the surface, what TDX specific things are happening to
> fulfill these update operations are mostly hidden from the MMU, but there
> is one particular area of interest where some details leak through.
> 
> The S-EPT needs pages to use for the S-EPT page tables. These page tables
> need to be allocated before taking the mmu lock, like all the rest. So the
> KVM MMU pre-allocates pages for TDX to use for the S-EPT in the same place
> where it pre-allocates the other page tables. It’s not too bad and fits
> nicely with the others.
> 
> However, Dynamic PAMT will need even more pages for the same operations.
> Further, these pages will need to be handed to the arch/86 side which used
> them for DPAMT updates, which is hard for the existing KVM based cache.
> The details living in core MMU code start to add up.
> 
> So in preparation to make it more complicated, move the external page
> table cache into TDX code by putting it behind some x86 ops. Have one for
> topping up and one for allocation. Don’t go so far to try to hide the
> existence of external page tables completely from the generic MMU, as they
> are currently stores in their mirror struct kvm_mmu_page and it’s quite
> handy.
> 
> To plumb the memory cache operations through tdx.c, export some of
> the functions temporarily. This will be removed in future changes.
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> v3:
>  - New patch
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 ++
>  arch/x86/include/asm/kvm_host.h    | 11 ++++++-----
>  arch/x86/kvm/mmu/mmu.c             |  4 +---
>  arch/x86/kvm/mmu/mmu_internal.h    |  2 +-
>  arch/x86/kvm/vmx/tdx.c             | 17 +++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h             |  2 ++
>  virt/kvm/kvm_main.c                |  2 ++
>  7 files changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 62c3e4de3303..a4e4c1333224 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -98,6 +98,8 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
>  KVM_X86_OP_OPTIONAL(set_external_spte)
>  KVM_X86_OP_OPTIONAL(free_external_spt)
>  KVM_X86_OP_OPTIONAL(remove_external_spte)
> +KVM_X86_OP_OPTIONAL(alloc_external_fault_cache)
> +KVM_X86_OP_OPTIONAL(topup_external_fault_cache)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
>  KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cb86f3cca3e9..e4cf0f40c757 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -855,11 +855,6 @@ struct kvm_vcpu_arch {
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>  	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
> -	/*
> -	 * This cache is to allocate external page table. E.g. private EPT used
> -	 * by the TDX module.
> -	 */
> -	struct kvm_mmu_memory_cache mmu_external_spt_cache;
>  
>  	/*
>  	 * QEMU userspace and the guest each have their own FPU state.
> @@ -1856,6 +1851,12 @@ struct kvm_x86_ops {
>  	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>  				    kvm_pfn_t pfn_for_gfn);
>  
> +	/* Allocation a pages from the external page cache. */
> +	void *(*alloc_external_fault_cache)(struct kvm_vcpu *vcpu);
> +
> +	/* Top up extra pages needed for faulting in external page tables. */
> +	int (*topup_external_fault_cache)(struct kvm_vcpu *vcpu);
> +
>  	bool (*has_wbinvd_exit)(void);
>  
>  	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 55335dbd70ce..b3feaee893b2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -601,8 +601,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  	if (r)
>  		return r;
>  	if (kvm_has_mirrored_tdp(vcpu->kvm)) {
> -		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_external_spt_cache,
> -					       PT64_ROOT_MAX_LEVEL);
> +		r = kvm_x86_call(topup_external_fault_cache)(vcpu);
>  		if (r)
>  			return r;
>  	}
> @@ -625,7 +624,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
> -	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_external_spt_cache);
Though pre-allocated pages are eventually freed in tdx_vcpu_free() in patch 13,
looks they are leaked in this patch.

BTW, why not invoke kvm_x86_call(free_external_fault_cache)(vcpu) here?
It looks more natural to free the remaining pre-allocated pages in
mmu_free_memory_caches(), which is invoked after kvm_mmu_unload(vcpu) while
tdx_vcpu_free() is before it. 

>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>  
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index ed5c01df21ba..1fa94ab100be 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -175,7 +175,7 @@ static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_
>  	 * Therefore, KVM does not need to initialize or access external_spt.
>  	 * KVM only interacts with sp->spt for private EPT operations.
>  	 */
> -	sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
> +	sp->external_spt = kvm_x86_call(alloc_external_fault_cache)(vcpu);
>  }
>  
>  static inline gfn_t kvm_gfn_root_bits(const struct kvm *kvm, const struct kvm_mmu_page *root)
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index dd2be7bedd48..6c9e11be9705 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1590,6 +1590,21 @@ static void tdx_unpin(struct kvm *kvm, struct page *page)
>  	put_page(page);
>  }
>  
> +static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	return kvm_mmu_memory_cache_alloc(&tdx->mmu_external_spt_cache);
> +}
> +
> +static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache,
> +					  PT64_ROOT_MAX_LEVEL);
> +}
> +
>  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
>  			    enum pg_level level, struct page *page)
>  {
> @@ -3647,4 +3662,6 @@ void __init tdx_hardware_setup(void)
>  	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
>  	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
>  	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
> +	vt_x86_ops.topup_external_fault_cache = tdx_topup_external_fault_cache;
> +	vt_x86_ops.alloc_external_fault_cache = tdx_alloc_external_fault_cache;
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index f4e609a745ee..cd7993ef056e 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -70,6 +70,8 @@ struct vcpu_tdx {
>  
>  	u64 map_gpa_next;
>  	u64 map_gpa_end;
> +
> +	struct kvm_mmu_memory_cache mmu_external_spt_cache;
>  };
>  
>  void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fee108988028..f05e6d43184b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -404,6 +404,7 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  {
>  	return __kvm_mmu_topup_memory_cache(mc, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, min);
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_topup_memory_cache);
>  
>  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
>  {
> @@ -436,6 +437,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
>  	BUG_ON(!p);
>  	return p;
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
>  #endif
>  
>  static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
> -- 
> 2.51.0
> 

