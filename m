Return-Path: <kvm+bounces-66700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CFDA4CDE58C
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 06:17:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CCB8530069B6
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 05:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211E1259C9C;
	Fri, 26 Dec 2025 05:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N6lJiiyn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA95B3A1E7E;
	Fri, 26 Dec 2025 05:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766726232; cv=fail; b=K2cZk/eZvFa8iyumo4gqOAtFYW8MKEXoeSP4bdkFm9dktMtUnZAbn2n7aoDYckFOsnMAx/xV765hcVbFUt2rCrOxCXaBSHywyWiS2l0Ly/Ssc/3UZzwai3jcddgUEn6xMXAVRhWw438QAMlLPrfB1dT8OghedEVX0rDNo9w0Zbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766726232; c=relaxed/simple;
	bh=4gJq9YrOH1eu1waiXXAYe+1t9cljpDOf52vVBDO+2fI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=B7yJ6knigAzML1ZtQG8QEVJ+Ngu3WVJRP36R/PeAOK7wiBWMcTV4pK4maU9qe9pl30Uj2pxzAY/6o0AnoNcHm5IMPs10zQGtllcWXQF4d/6sacVokLL7RdnkIDTabV6rFvQnautkMCvdA8QUFcIOr5HItMUmEo3iiV73tBPLWVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N6lJiiyn; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766726230; x=1798262230;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4gJq9YrOH1eu1waiXXAYe+1t9cljpDOf52vVBDO+2fI=;
  b=N6lJiiynGh1eZvq4tusAi0Ngz8XlbxQ+NCCoxNTF3/deWIXRckN5ylrZ
   +bOrei2Jy2uo1oCNc5KL/mN7e87LZxvSw41z+xcHDSUcDLguVLofye/9Q
   +IPji4qKES7J4ZX6UAYVWW23kxwuVyZb86AkyhGm6uwYKHmw/ia9wTPxR
   ZFAnNa0IFUs/Umldzlvh6rqF1ywD7mWJlBGtHq/xFDqVFCVyxW7ARL8Bp
   E2JlWi6WK67dLFJrJI7p3p3UPWgXlqy5/pmLFfkRZqssgvHEEA2RtNhbU
   oS2cJIvJHaF2/2QI1uapK6cdU/XN9DFFBKZLRWiuJAeewAab7raQH7aVF
   g==;
X-CSE-ConnectionGUID: GuTn/DQST2Ot42fY9r8Vww==
X-CSE-MsgGUID: pSRzMYsMTJmHYGa3eCHhSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="79217700"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="79217700"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 21:17:10 -0800
X-CSE-ConnectionGUID: uo8yuXifThGQZswO5fGf7Q==
X-CSE-MsgGUID: E0P77y1AROSvbySq3IKxDg==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 21:17:10 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 21:17:09 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 25 Dec 2025 21:17:09 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.9) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 21:17:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/rKOpREhvlTTVMmcGJyS+Wof+wQu2xOd1YXTZgLsUwQOPk+k8NLb1zhMGYrvgwzNobdDB5XmzgH4Ys1CyWs5HLBq3bATf/w7xLsnUFHdC6J84BMlWDe5qQiKIRVXXUojspS7Fv58GGoolIErfCRjdN23ZyTj9U8bylC6c4Oox17zHPdnewoYZBhSoIdbn710G0h5WAc5xXNLosWfLRni2ppI5g1uLW9ULZklupmZcS70q0fKZq5c+4KdRv/QVxB+WcMbgfHgUq7eAfv/V4PwbN/S7QmrFc2k68q7m8FxWGwKpH782wy1khOhTg4xDBX20EF7ObkUf5Mb7AJsVdQkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNmltr8BSNkIruSaecHHaFaGIPPTTlo/hzkVIQvBZOU=;
 b=OQzYpu0pMrd/1rlT51jHMPZX61j8NaY4FJPrQqDX6imvBaWKbIBcG7BVMwz+Pgv6PWltRvHHwAHXIW7okMLW/+yikVtX7xH6QN8VZjveuVgXt4Kq1UJ3b4mvm2j6KkieLXkNOXI5STkizvTYvYO0uYdoGFIvuW1xq/5zzh/E2GJZPrVsIh2kYdItOGgEQuyFgkRWnUmJ4eWHhBY/0zOuJ0gCX+U7KM1H6haBiS+kY5dmsvChqY4sXfqHCXJvucPY7evzBUxDYMuUlWWf+TAj6NEd7E4bIM5PACJ4cQ5nms3lkFyxe64w4z/PX6nvjVjGle2T+9Jexopu1IE7F1M5JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB4791.namprd11.prod.outlook.com (2603:10b6:510:43::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Fri, 26 Dec
 2025 05:17:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9456.008; Fri, 26 Dec 2025
 05:17:07 +0000
Date: Fri, 26 Dec 2025 13:16:58 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v3 10/10] KVM: x86: Update APICv ISR (a.k.a. SVI) as part
 of kvm_apic_update_apicv()
Message-ID: <aU4aSrhA+Ygdibjj@intel.com>
References: <20251205231913.441872-1-seanjc@google.com>
 <20251205231913.441872-11-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251205231913.441872-11-seanjc@google.com>
X-ClientProxiedBy: KUZPR03CA0020.apcprd03.prod.outlook.com
 (2603:1096:d10:24::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB4791:EE_
X-MS-Office365-Filtering-Correlation-Id: dd3918d7-b6b0-48d0-7164-08de443e0378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3FWo2Kw3gJbwJke+Rm+oK1Wcc5ZpA17/6RcP3eOKrnKB36t0jmhuNyNiFaxE?=
 =?us-ascii?Q?zdqEHELdbZxwGtEpnNI0idPr7OT42ZpVe55h+em1z0LGtikIL9S8oHBhaSGr?=
 =?us-ascii?Q?0WHNAn8uE08Yf+cM1uJNjh8NhbgqfOR6oPB+2P0Eo+0CkIehYVQbiXZlH/Qq?=
 =?us-ascii?Q?ohbShLiyW+ged1xPUQWwSEAfPseMsjl5wJeMKsSAnbxsolt3djW06L6qpdTQ?=
 =?us-ascii?Q?dthWG/rCzX0HdIacreXIzyorWs9H+oypy0K9qEAEEJtxKQ601gTs1WdIsYXQ?=
 =?us-ascii?Q?p4h7eSH3y8EMuen6LqBgtW84moyOTcd4+IK5BVoTsNtqRQYdN2tKAa8wmpSu?=
 =?us-ascii?Q?4LAGt4dkH2dnF2HJTo8wltvoW1yPU1OIR1cDHaSjTSHYzfIht9X6phZbcrjg?=
 =?us-ascii?Q?BiOtFOJLuYjZ3p8pbVyBUslMXOeenqwhD7BgUaeodzVykJVu5aX1oUh3fkVI?=
 =?us-ascii?Q?tceVjssv6WOjVRlAUKnP/oArPUMCgEPzhuc/5q94KaDK2WVima7rSPHX09+a?=
 =?us-ascii?Q?O9w85sUazWrv4dGrikHzWUZlmvNTOsCni5H6HYiVeOYrTZ2fJBu82MTt/RTP?=
 =?us-ascii?Q?6oBEbNj2gZ6/uveMsU4V0DSTKF6tBRAxeZZQgxnTET6lDkhnn7yq1QSFCEHK?=
 =?us-ascii?Q?loArCwLnN7iv0kFJK1XUWL/MpQdit3kuJ5RQjYKM3ebRvyz2TNDD7gse/hp6?=
 =?us-ascii?Q?/G41M+mTymKltN+P8M39Pa98Tp6sOcIJjROLBGOXNdnyiJwlGv2d1HHH4ZUj?=
 =?us-ascii?Q?iiPsHtKnh7dzmNanbvCErxGB9vdbWtjpNRagsTsbeGltOY0LZYdinT+5odJ8?=
 =?us-ascii?Q?Fkn+IrbQlxIhYvGMxb6bFC4smAMWDFHTAi3xbzkHsgsEBt5vUldCLYe1DIO9?=
 =?us-ascii?Q?PEGEi6R1bXezc/a4GZ6v3xWEtYnpu8F6X4eiNN+wcKb+CDww3GOUqHBGxpPR?=
 =?us-ascii?Q?9HTsTb/6I9imSLR94cyFQjKtVmWT4mhhpJVDnEK5d6BxPfIUpJh1d6YiVKFA?=
 =?us-ascii?Q?LHocDKVkKulYRCg647vzDKBeAVeG9IkfKQoArTgMnPuC7PeSbzR0STOMQCqX?=
 =?us-ascii?Q?rwMMllhsRhKIcsnrSXZHXFQzgf1pNIOvY9qsdJVoUx1eCaSO3qGxHkqbMLcE?=
 =?us-ascii?Q?ymNSz9Zt9Yu+7OKEkygn+KigjixzqGZXxJgv314YoKkCuBMbpNx8wiQ1qKoN?=
 =?us-ascii?Q?NoSkZa9y6SY0EEk21wCgsb4t58HbF6AGQ9L3UOxtxwjGuk5w9kSGpSuSiE9u?=
 =?us-ascii?Q?j24JAFd/xVrUTUCsApdfWcwH//KKxJ3qg00OoKS0cN+PFsvnLTyEuB/IJ7Xa?=
 =?us-ascii?Q?glJzf09WhKRkdYNbvTITpV5ZlydNQjhVvFZxiw8/D34cAJ2P3LO1s/OJ7Dl4?=
 =?us-ascii?Q?C2+lnZmx1Fp+QOcWu2cITbm3AIWdhYfCT6sLL7C9GGpisAPik6Et3iJrGWw2?=
 =?us-ascii?Q?UtMrq9WCwu9dLmF4+o0SZ/EbjV75w3vc?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nfeNqrK+SdbrpmLw7eCK6UCHj1uL/uHU+1SbNOYcFR8UHKB2S6yi0LDUkGFK?=
 =?us-ascii?Q?y0RLM0MLqxqAW809uq5cNMV90mWUwUwXeRBTEhXHxBoZpKobsqwtBOCK+3tx?=
 =?us-ascii?Q?oKkMTDTZpZNHHHzJSmKFLI0y7ZLHDWAM0+EXfD4OxiEaOo/KlyOwLvlwWl4t?=
 =?us-ascii?Q?1CkvpUeGAcIF9QRzIxxBgJsvmgECVzGHwHC4vnT65T03v3KwyfTcgBxumCaX?=
 =?us-ascii?Q?ZRCKBBQw6yu2pq43HukPn6ezXLQGOSeaMH9nFapGFIuylecEvfRK8okPKSSg?=
 =?us-ascii?Q?YYcLDCTZOEjUxk0aq2iOpwOEHpzuNBRlqqi354xKrdpCf5FKs8Ld3gE24FFc?=
 =?us-ascii?Q?XuLZC3HapirEMsFh/frRSph5y3qP0CJheLlGGojr0CSCic00G670hjy0FB/m?=
 =?us-ascii?Q?ON8Kdcw/GcuJUUjR2hKK5mNvYzz0GhVpsx6hHrT+QjNHAPXqW8PMb3e8ASR9?=
 =?us-ascii?Q?QEQy7nJN76PvMOPbmAGIT98bW3YKvhSbNzAGWuhVdkLhSAUwF+X71yHwDF8U?=
 =?us-ascii?Q?Qo6CA9ISUXNiocZUh/y9z2CU0OrizUUQn5NtMHVJRU1LGV0plO8QVEBxj8wQ?=
 =?us-ascii?Q?iMZo8h34isIbbgVANluOWlfjonW80y5nlkFO252nDvupj9nAHhwWaH/n16k3?=
 =?us-ascii?Q?E9BRSO98AtSysExMvkjKpEwMuf7KeBjAR1iaoERfrb4G7Q4ID7ivdBp0r70j?=
 =?us-ascii?Q?w9upqwIBtWzY4BPvi4nUFC3gUK71TBBXYP0XyzNlL9ZUoZ1c+I2xIv2GI4X6?=
 =?us-ascii?Q?l9sFz9NQD+WKdLSjXdYZIYLH6FIDUWE6CvS84fFMPleBbcT4Dq4k7DAkCQjv?=
 =?us-ascii?Q?/XOyRgT0HqHGW9ATkk9PXPDKFgwAFKZ9EYCC+0pjTiwQGPaGaZQmWbJM2P12?=
 =?us-ascii?Q?gDAtIQugWdIiDeRDTlDN+f5UlH0kGC7bN1+4Bb++RXivcC5uxdOQkU+q9VBo?=
 =?us-ascii?Q?8qSsk/n99PcaW48BuTTCCI+R7KQ5GcTx9r6H5T/Afbf9akPFjMYKrkRzkOgQ?=
 =?us-ascii?Q?l2maaxwNDIpawWFJOONBjaN0zic6xlwpzD3exLeSzFUJfJ7Ed3yRBtTr3h5k?=
 =?us-ascii?Q?ZS1u7Zm0gQI/TCH/DQLKBG1S4dp5UI004f4Mav7D5SLVPTwLCYV2ws+eoflp?=
 =?us-ascii?Q?gfQ66MfAM8QTNiKaGtXILY7UUseZDB8II1U5XOSkZnzbrYnZS0hV4FgKCy2K?=
 =?us-ascii?Q?6Bt1dBQfevb25x/owc9owGSm4ONwrwzTGFHUFDZ2QMqGx5uVfEFNPYF6muU2?=
 =?us-ascii?Q?4OCiN7+2Ef/SNn2fLwHOQ0CnsOPy+vf7d2Tg23sqQdnDFi48HkuoJ3rxyFPU?=
 =?us-ascii?Q?oEknkL4Rgr0a1yxAFdYBK7zMMhWopatBi60Zpz1y03k5lcdB2TLQdLrI99+G?=
 =?us-ascii?Q?mrOWyQPsf7fLbFQn1WPCVUGEqc2L8t07tc6Ue3K0YwLWX42JP7KKM/a4W8aV?=
 =?us-ascii?Q?VKkBLE9dw6OMMpLygMCG6sihdXKMezWw0RzgY2j4TxDnQugEPPkLh6wukUYn?=
 =?us-ascii?Q?GYdT5b2liuwckkinYut9u2Y91EXznlRNXYI1F0uLxsy0aiGDyTKdF7WPqWsq?=
 =?us-ascii?Q?bvJCNcNZBXMjfV7hFtws9yjiTKj77QnNiJQ+KMEDuuHjJ/IeZL5XeoJ+qbQk?=
 =?us-ascii?Q?BDI9AtcX61Y8Te+PkNPTaySFI3PlaIJ6zbVdBMvRnr1v2m5VJHEqU/vmMKw/?=
 =?us-ascii?Q?0CoDygQY6QXWUcELAoZsNzQH/gYcuNzZXuI4oIOM0hUGETUMp/5dkPECnW3c?=
 =?us-ascii?Q?kL5ZYq8HAA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3918d7-b6b0-48d0-7164-08de443e0378
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 05:17:07.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A5jM6nYXclhMSNNbvhbFZsghDg7JHMP9g/wmKA9S7+Y+GN2gjhxNasW5xE4RnkstpDPa9NIj5s+bBPYKhgrhPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4791
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 03:19:13PM -0800, Sean Christopherson wrote:
>Fold the calls to .hwapic_isr_update() in kvm_apic_set_state() and
>__kvm_vcpu_update_apicv() into kvm_apic_update_apicv(), as updating SVI is
>directly related to updating KVM's own cache of ISR information, e.g.
>SVI is more or less the APICv equivalent of highest_isr_cache.
>
>Note, calling .hwapic_isr_update() during kvm_apic_update_apicv() has two
>benign side effects.  First, it adds a call during kvm_lapic_reset(), but
>that's a glorified nop as the ISR has already been zeroed.  Second, it
>changes the order between .hwapic_isr_update() and
>.apicv_post_state_restore() in kvm_apic_set_state(), but the former is
>VMX-only and the latter is SVM-only, i.e. is also a glorified nop.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

