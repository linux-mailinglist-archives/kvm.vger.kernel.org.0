Return-Path: <kvm+bounces-20754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 022B091D7CA
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 260191C2273F
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 05:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598BF4597B;
	Mon,  1 Jul 2024 05:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jj9kkm6v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D75A23A0;
	Mon,  1 Jul 2024 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719813460; cv=fail; b=QHmiyYd8/YkUQCASxHbrV+sPr+lFBPwtQ59n0Y0Qi9DbnV9H/75sY81ddm8prAN/5jTT5HoX74zs0oE0i7c/HOY95OwM5cnvDipV/noDn6cmpyUBN/eD1CevEgRAEP42a1KzJRm2V2uoJadQdS1yv8Zcd/OMIgDmwi5Cbw49WTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719813460; c=relaxed/simple;
	bh=qMwW8WCZA9m1VzWlAFltz+8Ul0qAHeIGnqiC7ip9DV8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E+fARX5RmSC5F7l94Hqt90IwctZcq/7f4chfw9Gtp+0a0Is0gEvAk7NqabNnSaTSkMEhlUpi0Elh9WNP1ZLqve/Zh39eFjrPcs3SFvahyZwYNO9lsL9yhl1AkgwjIkPXAtSE/9Wk7WGqrnv+gQJwPg/uEANACJWaAYNrTHwCRFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jj9kkm6v; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719813458; x=1751349458;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qMwW8WCZA9m1VzWlAFltz+8Ul0qAHeIGnqiC7ip9DV8=;
  b=Jj9kkm6vBT/lT7RaNPOpk+G0VjbF1faFwaExNN7oFiOb3TQdrYihIklF
   kwE2pTNiaa9KpnNZqgvsLL2KFR9kopVlFhibfi1OcaIttWaz99RyLIgqH
   JRg5T95aKxn1DER+YnwKDjABqASsJmPtQPbF3CICCTiYyuEHIuNV3dh3t
   MAoM+zAxOBYq5N1/gsxAXKAJtfxEGRITBOAxg2AZzBJ12MxLqyR8yhxDF
   70j2BNNG/kFtnvlvSMTegoJnB4KvJk39USOY0ycKzUmsKwjMuoeZHT9Jq
   m9YrNA5VfCpbbXlR2s8NWkprXdOv7dQWG03PMYKLq/D4mu0nJlNINOlDS
   A==;
X-CSE-ConnectionGUID: QDwsm6LDS2SZKg7NZKEqHw==
X-CSE-MsgGUID: CtMNg34UQP2f/CvVt/XQ+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="27535839"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="27535839"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2024 22:57:38 -0700
X-CSE-ConnectionGUID: A+QQVdZrTIe7Qm3RxCA41A==
X-CSE-MsgGUID: z2lSQzbqTbqYGEIHgMKGBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="46072742"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jun 2024 22:57:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 22:57:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 22:57:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 30 Jun 2024 22:57:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 30 Jun 2024 22:57:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbbcUWG4zkhFqDCdIkY5GT+Gsg270MWoBRgetbZTOiEbO8NdztUDqMLnqan5/+whIPH/oo0julsF2GphnEqrq2ZYLceMZuMg7PkjRIbW3G37WSB2zKfl5d7GGWrmaVA6mKbg5BBpMKZKOcgej2b4+KjLGQB+G34gPwTeF0dh8px8c1CZ/xICwsdsIw023pxhEnNFXF8SVxt/av0Kxo7Hrd7zyPHbxlBShwWSOUgzmx/ZBkYkjxZok2yOYL9MJRgkjk3pF6t0FVq1fFIHZVbqd6U2zUIbiCfunDLZHgnt+WP5vLwCaHHGDoVCigHno52TjfoDUzfvvzv1fJTPFtAg1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1KbVkHv7rOGajHIOMBVTYmkks13KjZapc1Q3kUEIpE=;
 b=lvareIDeW1FzRen4YGBIg8oZjeCY1gfqy5zizZfnPSf/MfM6vD4D3wy/6ca/qqp3VfSnWXvojeZHMi6lM2d3buwl6IT+yfJfyYS4BF/Rgnvb/wdaSgbIVww//KVHwb8k+jkHHm9/svMczWK2VkDDe7pSTHtkncGtrr0/v86eK/lkoM8PWzvmToRsrkUEu7+FFTKjlF6SALxQFgWFOYst+DaGcYcNINUC32rNd3gAechAH5FmqRzwHffL6BvPtAugrUpMJOFtqtuhr7j7X9TrCVXISF5o5XDqEuN4zmIBH1zcEISTUD+j5YKnKi8lRQqP70PFy7SYQlQJvPFdYUNOFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7622.namprd11.prod.outlook.com (2603:10b6:8:144::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Mon, 1 Jul
 2024 05:57:34 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Mon, 1 Jul 2024
 05:57:34 +0000
Message-ID: <e7006778-6ad5-4797-bdf5-4e1da1535a20@intel.com>
Date: Mon, 1 Jul 2024 14:01:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Get/put KVM only for the first/last
 vfio_df_open/close in cdev path
To: Yan Zhao <yan.y.zhao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
References: <20240628151845.22166-1-yan.y.zhao@intel.com>
 <5187229e-3f0f-4af3-b3f9-4debf68220fd@intel.com>
 <ZoJBuHuusbzeGoXZ@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ZoJBuHuusbzeGoXZ@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::18)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: d3be0da3-649a-43a4-4533-08dc9992b3c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dG9xVDFTZHkzZjkvb2U3QmpTNFpxVDkwZG91dmhqWkdwV2djWUhtb3RaTjZY?=
 =?utf-8?B?bDNqRnlJaU9tTW5jUlRTVURCNEJsM2pWbXZnekJWelYzaTR6TUZvRFRWazRE?=
 =?utf-8?B?RnJNcytnNk14Q2IrN04ySmJhZzJXNWRpdW1mOFRFdnNiVFJlbWRTUjNzdDlG?=
 =?utf-8?B?S0xZK2M1a0ovdHd5dWRacldEa0pEZkE4bStJTjFoSFQwSWh2MGNkc0t4OXNC?=
 =?utf-8?B?eG81ejhOcnhFTittUjhaQ1BRZUwvT2JnbEVveXBQSWk3MnUraThnRHo5Z0hr?=
 =?utf-8?B?eFFnQ3FLbFdoK0pHZ1FiSDR4VWxqYWxxSVl6YzVRMk9GUzAxV1l1WUd6WkpC?=
 =?utf-8?B?M2RLYzc0NmxGdHU4bGN2ZFNwckE5MDNnWTBKQWtlbW9UN2pkRDkrdk9VMzNE?=
 =?utf-8?B?ZlNDcXZTWDYzQzlnVGJRSUxCNjU1SU85WlNLUFArc1V4d2QzTlo3ZzhwK0FN?=
 =?utf-8?B?dmZCajNhUWZaZmFIdkZTQ3AvODFXQUZGSlNWdzYvQkFSK3hRcGpRQ0NmZEgy?=
 =?utf-8?B?aGhIdTA1azJnd0pReEQ4Q09yVDk4YWd6YVNQVHdQNVBjcXBBUU83elRGK0ZZ?=
 =?utf-8?B?d2l1cDJHSkY0TmpGRG5UU3NjRmNSRGd1ZDdzcUNPOEhUc2w1N2xxVFBPWGJU?=
 =?utf-8?B?VnFXS3FOWnFvZy9yQW9LaUg3SndORDY1L2MybUQzeCtqdHJoV2M4OStHeW1S?=
 =?utf-8?B?Z3FyNTR3K295VUpBNk5oOGczREYyU2htNzVab1RlYzg2VExqSXNJR3ZLQ1R4?=
 =?utf-8?B?VFI4OEw1YzRJZEsyUWRuMVRhUWpGcnZuckxXazMwWk4zNWE0OTZLbWFGVEk0?=
 =?utf-8?B?RjN2SkZycWdXa1RSTmhkQ2RqeTY3TEM0YS8wUUtHcHdIdWpUanRKWXhMV3dy?=
 =?utf-8?B?ZWkxanUyanJDOVZtc2VnZjhNS1RIdnZBNzJ2V0FKZmNETC9iemQrTU8xK0V5?=
 =?utf-8?B?Rm83Uy8vdWFsa0txYUFISU1zV1NQWkNEeW93d3hiZE4wYnFPcWZCTU94ejU5?=
 =?utf-8?B?S3M0MHQxYVY4bGhidlRRUHZiZ2JpUzg2L2QwUmVsbHNacXpmQisrNm5mbDZY?=
 =?utf-8?B?QnRVQlNjVFI2UkxQYmpSTytMMGdyWGxhd1hHcDNOQ2sxYUdvcHIrbThKa3ps?=
 =?utf-8?B?TjFiUTNxajkzSXI0eVNFZlZQZkxqekpWT1pIZ1cwcWtZek1kZ0ZuR2szRThO?=
 =?utf-8?B?TkptUVcvVW1naW5VUUNMUGIxNkZwN0lKZFNJK2dVM0Mwb2FLZWxSQzJKK0dn?=
 =?utf-8?B?U244Q1NuNlF6M0I1NXBNc1EvdmdNam42UXpMQ25td09Wc2tBN1lDMlJYL1pT?=
 =?utf-8?B?VHdUZHBCWXdzMGxGenhxcVcrMXEyRXVSUnZHaFcxUEg4dXcrNXM0OVhmeGt5?=
 =?utf-8?B?QllQVnI5cEVySHg0QkthZkhSRFM3MmFzRHMycGRLUlQ5RDNZenZKSnNCcUtX?=
 =?utf-8?B?ZmtpMVl0YStOaHNuZXpwMVlDTDF6T3hQUFMwZUNSVU5VSVRrOVRpYWdnNndN?=
 =?utf-8?B?OUV6SWl0YmdiMlB5aTQ3dFNKV2VTeXYvRlF6MjkwQVArMzlPWEhIV2lCcEVz?=
 =?utf-8?B?akl4STJhellHc2NDUytUeDRjVHBzT25CZWptVUlHdllrbmpKVEpDVFArTU5Y?=
 =?utf-8?B?WlRLY2hTZjlEU1BBcXB4SFMxazN1RldIaFZWQXhHYzk1YmdJTCs0NnFheG40?=
 =?utf-8?B?M3lxblRobWVWeVh3VS9RdHNOampuL0RoTG1oaXl1LzZqQUJIQzQ3eFF6VFAw?=
 =?utf-8?B?cmdPWEN3L1dKSzJ0ODU1RkJvS2FURUszU3B4NlZHVjZCZDFkVmNyZ0IxbVF3?=
 =?utf-8?B?bUxrWjMwSnRjeGZqSjkzdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkkrenMvY0l2clMreEN4SFdQM2RCSndOSmY2cXR3KzF2K2V0ZDI4WkRvYzY0?=
 =?utf-8?B?R2oyRHJ5SHNralJkNlpNeGlReEJjYkk4aWhrSTAwbjlIWnR0Rm1LRTUzTG93?=
 =?utf-8?B?WnJsa3hxQ0kwZWNMckVDNnFNSDZ1K084ajBJOXI5aFozVnJFTStKMWxqK204?=
 =?utf-8?B?OTJwQnR6a1NxVWd6YzNzMWVudTYrSG5YSGNURGU3KzQ0cE00TXVTc0pmeFdT?=
 =?utf-8?B?WGJvVjEvNTVnTzhZcGFyM0tNNlBFN0pEL3Z1RWJPR2dOOG5ndEVneHY1eDRj?=
 =?utf-8?B?b1BVNHI3NzZkc0UxeXRNT01valRTSjdSdTVmUVR2TVduM1NzNjQwWlZZM2Yv?=
 =?utf-8?B?QzdIV2FaZ0VFazlOYjVyVjJvR2o1elFMYVBaRGZRU1BUNUZ5S0dLdGlKNHBp?=
 =?utf-8?B?M1pDL0lJcEk5eGFzQjk4azdZS3ltd1pTWjd3UHdpd1NWR0ZBLzBQWENEN0VW?=
 =?utf-8?B?dHRSZk9qWHdleXRKYjJFR2JkaFpEa3JFWkpDamJkNXpqVjdtZzF0bGFMZlVI?=
 =?utf-8?B?dDR3ZUhvMXduTFFJWVV1a09LaXpLZGlISjJtOVlmc09EKzV6N1FhOFpSdFg5?=
 =?utf-8?B?Ylh1UE5xNGJjUnlSazBVdzJYMlBuMDhPRkZXU0lQK0Z2STlTUDlCZFZOSWhY?=
 =?utf-8?B?YVNYazFid0JZTUx2Y1ZuVWJQK0NnbDI4MXoyUUtnUWxkK1BiSWdGT3ZXZUdi?=
 =?utf-8?B?L2I4L0kwNlg2RVY2cTNwTDB5VzFRdnZoYm1RdEdZT2tORkNsSUZqeFRVOGJQ?=
 =?utf-8?B?eXY2NzBDUVlvR2lZN1pzVEMyU3hDWUhwdFBFMVQ4eWtuTkxxMzNRa3FqLzl1?=
 =?utf-8?B?d2FVaGh4QVpma3VOUmxndmh3UmVnUVBKZmN2YXpSRlRwSUtaRG4waFNpQ1JV?=
 =?utf-8?B?T3JwbnkvZWxoaHA2TzNtSkQydEFnYllxOVhqT0crMjZBSUphOC9mQjNqd1Zi?=
 =?utf-8?B?cy9xNE5saFJudzJMWE11YkZtU2J2bGRBeDVydWIrS3VvdEUydWg4dFhOVURI?=
 =?utf-8?B?Y2x2dzlyRFl4eDJtS2lWMEdZZEVHYkRJUEhpUHVzY3UwaGdIWVg5NjlqZHh2?=
 =?utf-8?B?aGZ3T1ovcGRaL0RzaWFhZlhMMXVVdDlxMjZvdFQwZmdJc1hQQXdCTjJ0NEV0?=
 =?utf-8?B?Ykw1RTFxbmRBZDdXNFdJc1Qrd0R5cWlnU3dvQklTUk5aU3Z0Yldvb0lRVHdO?=
 =?utf-8?B?ZGMzM21FdVBPUzVMV0JVK25VV2p0eE9kem1hWWhuYzV1UzVueWx0emJha2Jr?=
 =?utf-8?B?djNYVGFORkJTKzZoRzNIOE91Y1ppa1F0Z3MyVEE5SXJmZVJoaVVZckszb0lx?=
 =?utf-8?B?ZXVqSkVOYi84Qy9PbjJzdEg4S0FoVGk4Q0xMd3Y3YjJVNGhCQlh5WUVjVHNF?=
 =?utf-8?B?V1ZRUXNqMVR0UTZiNzlyeC9vZ2h0dUpsVytqb3hLblplWDg0azJyT3FHdnZx?=
 =?utf-8?B?V25FYWg4dG9KendrdllTOWlYQzBpYmJXSk1XK3I0NFNXZHo1MHhVMlpRdmxl?=
 =?utf-8?B?SnlrUkVISzVDQVRBL1FDaHRQR3dqVWlOWE84QlpkclJEclk0Q0RxV21NRmxJ?=
 =?utf-8?B?WkdURjdjYnhYbkNsdkNwc1ZKSVJxY1pFRys4RVo0b3BHY01lYWo3ZXd1MTBq?=
 =?utf-8?B?ZUExbGg2QmM1Q3V6T0ZLUGNnQUhQV1doaUNiSGVmR3I2blAvNjZQeGU0K1Fa?=
 =?utf-8?B?WHkwNE9vcGN1bkVXZjA3VHZ1eDgvQ2VFK3VxUGt4WXRyVzFHSURjWUhPczQ3?=
 =?utf-8?B?WjFJSDFFaWlmQStnTmRSVjAyYVRFSEFQcWFGclh6bm1VSjNYTE9PNmcrTE41?=
 =?utf-8?B?dHg4R3ZRME1Jb091MDhuSm1xcFUxT0hUbmVJTm5VOVJUZVNZSkdDMUFuVFFs?=
 =?utf-8?B?TThrUnREb2F2MUV2YnljTGprVHVWZFNMQW50SHZQVTNpUG5RWGVTWDFSU0Qr?=
 =?utf-8?B?Vnp0bENkaUpvRnAzZXlONVNqUS9oRk9nT3ZPVk5Rd0o0VkZOeHFmRFJnOURx?=
 =?utf-8?B?Wk5HcXJ5SENOUkhIMVBRd1pwUjQzNmJ1cDZFQmpNUmxTMjFTS0pWdzZJQjRz?=
 =?utf-8?B?eDIxaGtteUk0N2ZhYmM1UUU3TmN6VVFTSmRxci9nV1FGUWJadktlZEFRWWdZ?=
 =?utf-8?Q?HkcHovmQTeWkhk1sR6AZ6tLdM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3be0da3-649a-43a4-4533-08dc9992b3c5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 05:57:34.1072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0o4O5Rc8dXoV1Z1aFnuPAQ5ScxPlaWAgH9r1FDDOMgGujzbtlAHuzhIeNnROFBobXWS7Cy05ePw6LMfKXUBrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7622
X-OriginatorOrg: intel.com

On 2024/7/1 13:42, Yan Zhao wrote:
> On Mon, Jul 01, 2024 at 01:08:30PM +0800, Yi Liu wrote:
>> On 2024/6/28 23:18, Yan Zhao wrote:
>>> In the device cdev path, adjust the handling of the KVM reference count to
>>> only increment with the first vfio_df_open() and decrement after the final
>>> vfio_df_close(). This change addresses a KVM reference leak that occurs
>>> when a device cdev file is opened multiple times and attempts to bind to
>>> iommufd repeatedly.
>>>
>>> Currently, vfio_df_get_kvm_safe() is invoked prior to each vfio_df_open()
>>> in the cdev path during iommufd binding. The corresponding
>>> vfio_device_put_kvm() is executed either when iommufd is unbound or if an
>>> error occurs during the binding process.
>>>
>>> However, issues arise when a device binds to iommufd more than once. The
>>> second vfio_df_open() will fail during iommufd binding, and
>>> vfio_device_put_kvm() will be triggered, setting device->kvm to NULL.
>>> Consequently, when iommufd is unbound from the first successfully bound
>>> device, vfio_device_put_kvm() becomes ineffective, leading to a leak in the
>>> KVM reference count.
>>
>> Good catch!!!
>>
>>> Below is the calltrace that will be produced in this scenario when the KVM
>>> module is unloaded afterwards, reporting "BUG kvm_vcpu (Tainted: G S):
>>> Objects remaining in kvm_vcpu on __kmem_cache_shutdown()".
>>>
>>> Call Trace:
>>>    <TASK>
>>>    dump_stack_lvl+0x80/0xc0
>>>    slab_err+0xb0/0xf0
>>>    ? __kmem_cache_shutdown+0xc1/0x4e0
>>>    ? rcu_is_watching+0x11/0x50
>>>    ? lock_acquired+0x144/0x3c0
>>>    __kmem_cache_shutdown+0x1b7/0x4e0
>>>    kmem_cache_destroy+0xa6/0x260
>>>    kvm_exit+0x80/0xc0 [kvm]
>>>    vmx_exit+0xe/0x20 [kvm_intel]
>>>    __x64_sys_delete_module+0x143/0x250
>>>    ? ktime_get_coarse_real_ts64+0xd3/0xe0
>>>    ? syscall_trace_enter+0x143/0x210
>>>    do_syscall_64+0x6f/0x140
>>>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>>
>>> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
>>> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>>> ---
>>>    drivers/vfio/device_cdev.c | 13 +++++++++----
>>>    1 file changed, 9 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
>>> index bb1817bd4ff3..3b85d01d1b27 100644
>>> --- a/drivers/vfio/device_cdev.c
>>> +++ b/drivers/vfio/device_cdev.c
>>> @@ -65,6 +65,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>>>    {
>>>    	struct vfio_device *device = df->device;
>>>    	struct vfio_device_bind_iommufd bind;
>>> +	bool put_kvm = false;
>>>    	unsigned long minsz;
>>>    	int ret;
>>> @@ -101,12 +102,15 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>>>    	}
>>>    	/*
>>> -	 * Before the device open, get the KVM pointer currently
>>> +	 * Before the device's first open, get the KVM pointer currently
>>>    	 * associated with the device file (if there is) and obtain
>>> -	 * a reference.  This reference is held until device closed.
>>> +	 * a reference.  This reference is held until device's last closed.
>>>    	 * Save the pointer in the device for use by drivers.
>>>    	 */
>>> -	vfio_df_get_kvm_safe(df);
>>> +	if (device->open_count == 0) {
>>> +		vfio_df_get_kvm_safe(df);
>>> +		put_kvm = true;
>>> +	}
>>>    	ret = vfio_df_open(df);
>>>    	if (ret)
>>> @@ -129,7 +133,8 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>>>    out_close_device:
>>>    	vfio_df_close(df);
>>>    out_put_kvm:
>>> -	vfio_device_put_kvm(device);
>>> +	if (put_kvm)
>>
>> you may use if (device->open_count == 0) as well here to save a bool.
>> Otherwise looks good to me.
> Upon here, device->open_count is not necessarily 0 even for the first open.
> The failure can be after a successful increment of device->open_count.
> 
> Maybe renaming "bool put_kvm" to "bool is_first_open" to save an assignment
> in most common case?
>   
>> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Thanks:)
> 
>>
>>> +		vfio_device_put_kvm(device);
>>>    	iommufd_ctx_put(df->iommufd);
>>>    	df->iommufd = NULL;
>>>    out_unlock:
>>>
>>> base-commit: 6ba59ff4227927d3a8530fc2973b80e94b54d58f
>>
>> BTW. The vfio_device_get_kvm_safe() is not supposed to be invoked multiple
>> times by design as the second call would override the device->put_kvm and
>> device->kvm. This does not change the put_kvm nor the kvm though. But not a
> "kvm" may also be changed if the second bind is from a different VM.
> 

yep.

>> good thing anyghow. maybe worth a warn like below.
>>
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index ee72c0b61795..a4bead0e5820 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -408,6 +408,8 @@ void vfio_device_get_kvm_safe(struct vfio_device
>> *device, struct kvm *kvm)
>>   	if (!kvm)
>>   		return;
>>
>> +	WARN_ON(device->put_kvm || device->kvm);
> Yes, better.
> 
>>   	pfn = symbol_get(kvm_put_kvm);
>>   	if (WARN_ON(!pfn))
>>   		return;
>>
>> -- 
>> Regards,
>> Yi Liu

-- 
Regards,
Yi Liu

