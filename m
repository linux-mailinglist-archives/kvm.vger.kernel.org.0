Return-Path: <kvm+bounces-31082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B30919C01A7
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D757B1C21BAF
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746B31E909C;
	Thu,  7 Nov 2024 09:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GDovVlGo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D311E8834
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730973484; cv=fail; b=USFCs3dkJgouLK8FxEZ1Yph/54PCWRAOOy09cBTss+u2F7UxLpZrLECeo56Mq6vrN5BA18/vJvofr1GXs9y08Mk94VOCzaWLpZueXzpxjsfd824zuKeg4rlg9pWP+lJNs3Uu9mNbc8VWT+b237tmUNFCzmUd4XZeLKlYkWXrkL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730973484; c=relaxed/simple;
	bh=yqW1axH3g+Pksu3mivVdLrJGjIvH4o6/RQXhNKLAj/Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lGIm/NmTmn0ZP0/biqmwwG6aBD6Fcsq18XY8DtckgP5OA77okqPxfv9ZDQXQEF0ewbtBfT5tmdnihXeKsiWRHzD5NgfW05648GYGJRvhqPigLtEAfGpbea5ZS2onIVxEcW25PYbow0A40hjEu3TV6ry4HpK0rgbRy9TEyGwRf8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GDovVlGo; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730973483; x=1762509483;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yqW1axH3g+Pksu3mivVdLrJGjIvH4o6/RQXhNKLAj/Y=;
  b=GDovVlGo2t4L+m+5DDR14YfDK5pW45c42v8J1kLbVmXnKdsMkwsDdNKJ
   VRuQ6HZe9JW8h1GiGXfc1bwhF4hyqdlFN5q/bBIDwPXylXW9VqzWne/Ne
   QYhoaK8Pt7SZCfLYpyo7BkeM/Glt6VeWZgszZSCwhYpoiafd5z5jv1bAc
   JhB8f2MOFFYtH+MO7tlZz0MJPpDGcqSLExvJhR4SDD6JsDSUSsm+v7QKQ
   1cRqfzgDO4WvwM4z75mzFQtm1g6CGnQnCBZA0Au9iG5TSPkKO0gID9COZ
   tsyR8iyY1mnAoPEGYDXCqlf1Ti5Pgl2qN9jBWiyJNTGGoTQvi9a/5KyB9
   g==;
X-CSE-ConnectionGUID: IrbjNDFOQoWDd+vfcNM4Og==
X-CSE-MsgGUID: L7TXhe6CQ3uYj1kI2Jhycw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41910198"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41910198"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 01:58:02 -0800
X-CSE-ConnectionGUID: AddMKj4HSF+lcTc8+7w3Aw==
X-CSE-MsgGUID: recmqF3ATNGd1sXQxrAWVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="84568380"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 01:58:02 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 01:58:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 01:58:01 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 01:58:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wNzlCJJwN+uc2KhIEL47nj2FEPp1o9t53AUz26cZ2rQ23b1uJZyBHZfA9OueJb3+ciupVxObqh9zupMoeRhZMGYR/fGkcnjq3Bb7ZzaK4Nn6rszwiZFVwp2yJfVz6GKEPbp1i4SRSQXunOa02EiDYi0x4y9rHgil3Z8OAFLaNklxev+FT7wagVtgJ91yP3A0IdX7Oamsx7I3CnGYDGORG+dgakS2h3YYTcaRHbYv5hK6f2RfPv1eVeJNtGGOjYGKH3blZexU6HpgXAh9Y7jB/7rScVcIXVaBO4bj0EnIncnRROTEHlWbjY58py5gG6gIfhcZkjEbFD9IHNqTIYaNFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iebkv0+aShe3/zOMHn/O/d4/iReMyKN96nZ8I2Bfltw=;
 b=rjPnqfy/zPvKIFnbJx/r05zkMU3uHE3um1EfDAFfPe/6TGSK37Wa3OQcIbFmizyz9CMD/Iboy3Fi89XXVIUcRHF5qde30g2i4LhEzDWTwiEN3XzSkYiPbW74C5m0sWxJmgCH8/EryYD98oMjBond0zM9wCOZlf0MD+NDTWKnYmyHGiyHCp/R81AjrL4rm/SSxI+CK6is1AvTWvCfiSNo5iZnURtaEp3hw1Lu69dZh+p/dIR1NBNprYJkj9CoagYD/wOwzbBzirVD+LoR3MbDGUTVi9AxeeX9YcdPJFengSKitzqQrUwiTcfUkE5KEAuKZtjIKO2bkaKPSbwetcepvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5015.namprd11.prod.outlook.com (2603:10b6:510:39::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 09:57:58 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 09:57:58 +0000
Message-ID: <62f72c3b-3b58-4536-9fb1-0d7df4eb836e@intel.com>
Date: Thu, 7 Nov 2024 18:02:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] iommu: Prevent pasid attach if no
 ops->remove_dev_pasid
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>, "will@kernel.org"
	<will@kernel.org>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-2-yi.l.liu@intel.com>
 <20241105154200.GF458827@nvidia.com>
 <BN9PR11MB527668F5E61584E5EBEB21B58C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB527668F5E61584E5EBEB21B58C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0191.apcprd06.prod.outlook.com (2603:1096:4:1::23)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB5015:EE_
X-MS-Office365-Filtering-Correlation-Id: 508689d2-8831-4b6b-258a-08dcff12a867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cFp4SWV4bS9PZVVzaDQydCs4OU4zYTZ3Q0ttTGJ5YllCRkxlMDN1eTBhUTVi?=
 =?utf-8?B?eEdKL2hlUzYzbndtMnJpRGtXaVBsZDdvSE9yQklTNFFacmVsajcya2pLNDQ5?=
 =?utf-8?B?LzluOFlQSS9tYWdpRDRMa3FycEVabU8vNTV6QzZMdWNkL2pWanRCWElOUC9C?=
 =?utf-8?B?ZitBTmR5NzV1ZnNja1ByNHNkMEl4MFpDa3BET29NR1pZbGlvNDNqM1VaODMz?=
 =?utf-8?B?NmlTMnBpOHVTUjhwTUYwZ3dZS0JROWRkM0YxZlUrYVArRnpOUCtYUmdvVCs0?=
 =?utf-8?B?N1Q0Zmh4Q0ZXbExScWw2U3RqUStneGdwN1hqdG5tUEJlMDRCeThpWUlEdTlP?=
 =?utf-8?B?UG55dythV2pzT2hYcTFiSUp3S282WHBsTEpWa1REMThPcU9wVi9icW9sQnBM?=
 =?utf-8?B?a1piS21ISEFkbWM2ZG9TbDc2K3FhUTEvMkxlcFZTUmFGbTZzRHpSVUJ2K2Jm?=
 =?utf-8?B?QkNqcWRHZjN3bUhzd0hFWVVJQ1ZHajBUb0dPNmNudmUvRjJRTG5CS2U5S05Q?=
 =?utf-8?B?aEtpUEh2a1RGRDdjTEYvbFNZKzAxTEFxQ1lqcWsrQzg1M1h2U2FNY3VyS3dr?=
 =?utf-8?B?eUU5T3hrMUVGVlBlU2FJV2NKb0ZiYmdidDBEb1dFYTVrMFo1Q3RDZXFJbS9x?=
 =?utf-8?B?R3FVYzlCdEFoZmRkS3RuRXlpZklPc0hwMWlnZXFiQi9MdjNpQ29CeS83eUlQ?=
 =?utf-8?B?WFYxWDFBaCs1TzlGdks0aUROR2hjQ0dTSWE4amt1TnNScnF6QzZEaVFtS29r?=
 =?utf-8?B?LysvUEdEL3d5VVVIWGRoWENSaStXMjY2VHk3RC9LdzJtSGJObmlRWGZJa21Z?=
 =?utf-8?B?MmU1V3JGUXJjTitJY09EemlyOEl6a1U1Y3NPalF1c082SGkyVEc0MWhFekI3?=
 =?utf-8?B?VWZXR09ZVk1RWnRMd010cVJ4eXN3eHc4M2xBcmZ5cTBSK0lOc2NKT2hvSS9m?=
 =?utf-8?B?LzlnVmdRVjA4cSszcUxNR0lMcWFBSFhqVFZYWnJFeUFGaHA2VW1EYUlyWTR6?=
 =?utf-8?B?Nk1pVk1sMjhUeDBCdWZlOXQrdklwTVZIL3dvcklYNDEzQUJINXZJUWRzc3hr?=
 =?utf-8?B?ZzhaRTlqNU1tczVKYkRVN2dPQko1NmM0eXA5bDQ3ZWhrQU9qQXpzR1psKzUr?=
 =?utf-8?B?Y1FNb2RDSmU4WGVZZHRLWkliTnNkQWtMRTRPRzZsSlJMUnMzcjk2Q0ZRUCtx?=
 =?utf-8?B?WnViK1FwdmZ2Uks3TWM2bStqZU5vL29FcEhGSTVobHJaU0p4WEhsNkhLcHly?=
 =?utf-8?B?VnhOc09FYm1ML1FpUGtPcXRIN2NvaG1MQUJRKzhBNmhhaVo2QlNtbXJ1YUJi?=
 =?utf-8?B?b3o0dllTQmRsYVVTTG52VzVkamx3OEhXbEFQVGNKVGhSWTg1VUZVbzF4NUpo?=
 =?utf-8?B?ZGZlT2gra3E5Qk5RZmZxblg4Qnp6elIrYkZwZU1tVGkwVVFmcnZMay9RaEo3?=
 =?utf-8?B?QzEyOVFDTzFlVlJzZnRyYWNrM0Vma2xwMjU2ZlpBWFdHUUtrSk95YjlQaGZu?=
 =?utf-8?B?SkN3akVReXhidC9KeTl2R2ZWeGtmcDcrRnpDK1AvaEQ3Qm8xSUhRUUl6SmFh?=
 =?utf-8?B?OXR6WlJBQXRCeUFmWGNuZDUyeVVNMm5odXFSUUJBOExXNWlXVjZWOTVYUWVv?=
 =?utf-8?B?YXJYWUQ3WS9ZcXl3QUxRWGFRNGIxTHJkY3AwaGJWSXNJVDNkR2djczc1WHNN?=
 =?utf-8?B?Zk5FOHdIN0xzdG9hcWN4cnhCdEFDeU1uWGRhS29oNjkxOFlDejRsYkowcHlS?=
 =?utf-8?Q?9m5X+TIkVVYSIzWx8XEZ0pL/+V6KqIYozEweK1+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGJOWkZ4UHhCOFQ5aVFwTnlsNWRuNy9nRFNKYk1XSHUydzJRRkVSMGJIVHFk?=
 =?utf-8?B?UXBvcVYrdDB3WGlNSXp5WGR5QnBSUnl3TS9zVWtDSWRMNWVhdU9CbHMySWRR?=
 =?utf-8?B?MWhPbHRHYWFxQTUyWlMxZ0VybU5LdDBHcWJydU9MRUR2OWtuM0E3YU92RFlR?=
 =?utf-8?B?M01JSEhCcU5iWGJwbVFmTy9DYzcvU2NYS2VSVmFyR3RoTTdlNjVZVE1jdTMx?=
 =?utf-8?B?RS94eTlVZituM3FjQ3pXQWdMdjZrR1pxczRpWWowVTdTb2srNjRMenZmUFZG?=
 =?utf-8?B?ZGhKd0JRQ1MrTmpPemhaS2NDbVpMVGNOM2plL1FXNVNpR1pvL0lTTnhzK3FW?=
 =?utf-8?B?cVVYRTdHU0tJK2FDejNYOWplTjJGZlhEMjVKK2JMMTBJMFNMRVBCd3JJUStS?=
 =?utf-8?B?RFJCcS9ZTXZpdmgvdjczY0I1YXNhdER0RFdXK0o5WmlSVXN5bzV1WnlSTWYy?=
 =?utf-8?B?Q0ZHTUJqY1lNNHoyZFVNTUxDSzk0cVZTemZ2Y0tQeDd6M2x5SlEwSnV0Qzk5?=
 =?utf-8?B?cE55Z3Y2bXUrZkUxVWlEY2tXVm9NNFRDVm1lRHdQOWY5ZGRXMmE1TG9zMm9L?=
 =?utf-8?B?V3N3V2xRTjZkUitmOXJxVWVmUlV5SktLNTRvVGszaVNmaVYyNDViZ3RoSTAz?=
 =?utf-8?B?WncrUmtYeTJsWHVuZHN4OS9rYWg5V2swL1JxOVNuUGpEUWlCeXREZ1haU2Iy?=
 =?utf-8?B?UnJyM0lveFl1NWp1NDlrbzhvWHdnZ3djbzhEbDZEbzdHbDZ6d1V5WEQ2Rm0w?=
 =?utf-8?B?L3lxWWVSMmFuMGRMN2dadEdFNnZLNGFrQVpiQXBSM292NkViUjZ4Z0xrSFBK?=
 =?utf-8?B?TGZuRWQxY3FmcWRoZWVlQ2hNZ2FaRUlHUm1leUxrbWkzTWJXUU5ySkpxc1cr?=
 =?utf-8?B?R242enJNWElxNkZOL1BKOURvY2tVWTh2TTd3WUErNEZNVlNrUUpWQnNSbHYw?=
 =?utf-8?B?dFhXOTdYZXdUd1Znd1FqSWZXWUtLWUtzaEdjY1gxR3RWSmNCdmZ4VEdDRHlK?=
 =?utf-8?B?a0Q3ZHloN0R2UFE1dDRXVEpDS0l1NVpDclIyREUwUWVSbmtqYTVrRURUNHN5?=
 =?utf-8?B?NkxzM2JGTk9qWXRXZ0c3TU9GWStzd0RjRkN1NlBQb1FhNW5aVjR3NHpaNXNj?=
 =?utf-8?B?eUtyUjdTTFJyTUYxZE9iV1J2Y2x1d2tlK1EvTWV3b3MvM3FOeHBMVUhMT1FT?=
 =?utf-8?B?RGlUQVA1TjdLOVk5SGVTcTM2cXg5akh3WDI2Z3FCY3lZV1YrSlY2L1FUcVUw?=
 =?utf-8?B?RStLNEhKR2NYVk1jeXJsSDZyaFZWNzhRR2dXc0FmVEpDUHIvOG1rS0pEdGoz?=
 =?utf-8?B?a1BpMlVBaVpIaGVNbUpzZXM0aFlLWG9wd0l2c3BuRHNTUEZLSkZFOUpMdEhB?=
 =?utf-8?B?WUVoaXErckdZVUJ5dDF3QzRrUHZxQXpHZzVDY0hKamZXdGxqanBSWlRyQmhn?=
 =?utf-8?B?Q0VhUEM1a1RVVWFYaFVBRXFuRGkyYjQwV3JkbUlEa3pTbG1VMHN6dEthRXc0?=
 =?utf-8?B?UU5RczRRSDllL280RzdxdlpkMlVGSXhZY215eW1IbVdEL2NWOVFFb3dKbjd2?=
 =?utf-8?B?RWFRbU5aM0x1bUxYV2orOXlPYWVNR1hNNy9IeG5SK1lybjRwTWhDaWdtZm01?=
 =?utf-8?B?T1lhM2JqWXNHbjM3akZESHB2YjVnRnZ5Wm9GdVRIZE02ZWRzUlVMYmN3S1pp?=
 =?utf-8?B?TnVSeGcxUVVOblUvV3c5Qi9UaUtheEZDTjJndFdsbnlJa3BxaFNRb1BvVWFv?=
 =?utf-8?B?a0ViMUJPZElncDduQVlMbkdnTDZUeHNDa1lvaUFVQnJPdlVHNVZ6Q1I2U2VK?=
 =?utf-8?B?OGhrcVc5MWVUTElOSlNnNE1KSngrTGRjQTJ4Rlk2R01EUFZyUVc4QjZtVWNs?=
 =?utf-8?B?RjZWV1ZwN1pwUCtwVmtjcEV2enNiSEtPWkh5WmRtd2U1Qm13S1I1NnpMREJF?=
 =?utf-8?B?UzVtSHBMbXRCS1NZL2JBM2NGc2FIY2pVdzZ5eitwNlZmdHA3THlvdjgzVVFJ?=
 =?utf-8?B?VytYaE5pVUdueURnSGtQYkg3RHpQQThaRmc3cjlBaXorWWJtb1l3UEw2dTJZ?=
 =?utf-8?B?MFlhTVNjR3J3aEV1bEpsTmV1eUY5V0JqdVNVKzhnR0tIcnBFUC9lc1RVR3BO?=
 =?utf-8?Q?2b9APl8ml1CA35SX0t1W/MLCi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 508689d2-8831-4b6b-258a-08dcff12a867
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 09:57:58.2756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o79mAO4Bihd4Lnm9jSxVeZ/ZqSgeg4yw2lVxm80qhy/GqG7LPhAxNFZNGaTbtJ3AvjqMqNh1rwCbgHrLKOvH0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5015
X-OriginatorOrg: intel.com

On 2024/11/7 17:33, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Tuesday, November 5, 2024 11:42 PM
>>
>> On Mon, Nov 04, 2024 at 05:20:27AM -0800, Yi Liu wrote:
>>> driver should implement both set_dev_pasid and remove_dev_pasid op,
>> otherwise
>>> it is a problem how to detach pasid. In reality, it is impossible that an
>>> iommu driver implements set_dev_pasid() but no remove_dev_pasid() op.
>> However,
>>> it is better to check it.
>>>
>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>> ---
>>>   drivers/iommu/iommu.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> I was wondering if we really needed this, but it does make the patches
>> a bit easier to understand
>>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>
> 
> me too. btw when Vasant's series introduces the PASID flag to
> domain above checks can be moved to the domain alloc time
> then here just needs to check whether the domain allows
> pasid attach.

hmmm. Are we sure all the caller of iommu_attach_device_pasid() will
allocate domain with this flag? Besides iommufd, idxd driver would
also call iommu_attach_device_pasid(), and it uses the DMA domain of
the device. I suppose this domain is allocated with the pasid flag.

Given that Vasant's series has been queued and this series is based
on that. It might make sense to drop this patch. If the pasid capable
domain can be allocated successfully, the iommu driver already indicates
it has the ability to support set_dev_pasid and the undo op.

> for now,
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 
> and a nit - there is another reference to dev_iommu_ops in this
> function:
> 
> 	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
> 
> could be replaced with ops too.

If we decide to keep this patch, I'll add it.

-- 
Regards,
Yi Liu

