Return-Path: <kvm+bounces-10558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E26A486D6D5
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:26:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 996682856AE
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16F577639;
	Thu, 29 Feb 2024 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZ3wpNni"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282BD74C03;
	Thu, 29 Feb 2024 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709245576; cv=fail; b=ap4XepyD3qsGCh53IDT+nPgu3g1VqkK+m2jGA3i2gg40VBZ1LhJIBWUxbrF2ssMIEYG6i5kEAkwwGv0MWB6pyckxrDUL1oRUWeLwGWRPhmbt3f9+gQZByLBk79hBLrjXJMom8+hCe52KeRgqmVVs289IxF9EhhPvPfvSCYNiiKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709245576; c=relaxed/simple;
	bh=l8i7TukRRHpZr/+nCwpuKcwM8uOH1BpZ6h2iZupaGng=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WdGkOn84XZAC9jNUWSs8jNPGACJaEe4fbxxjJFSrUSScH4ABDOvx/wKZVaoZwSG++mKGORuKlegQWkVOnF2JWE4M/QIzd0HbEmCKVWheSSWVYLpw+PQburdt8mAubcc7TTk9HwCvUo8Yy8/mG1jXhgCLjAP1RsjUTe14QR7kAE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZ3wpNni; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709245575; x=1740781575;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l8i7TukRRHpZr/+nCwpuKcwM8uOH1BpZ6h2iZupaGng=;
  b=IZ3wpNniZtpqXtbdnKSkZcnAewDJS+kUVq1Y/FqEM9qVIUg9CGywcDs+
   ULanMxf5RZBO9uc9yV1bfirbsS12rdaqzlRM4N7ERJ7kO/UeOTZVIBsGP
   UA5UEvFrBEzjCtyMZ7h6DXCte4cUSLk8QB3y4SKqgPtQAMPBycSeGwNuC
   t1Q4Dt682wivgQ5WgHTOKdWDUv8APfHdqhbof0DsKarPJIrLiD3m17vNI
   SrlYMj0tbb/CzqvX6gtJnyGC5FJVynju3XVSId4taucaw5A/qETcRWdrO
   5Xm25O15HDAErXLjyuJ/XCDdvZg+hRIgt6jGyQwzW9gIVS9zYHAKL3HK7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="21215370"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="21215370"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 14:26:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="12667792"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Feb 2024 14:26:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 14:26:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 14:26:12 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 29 Feb 2024 14:26:12 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 14:26:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RG0iLTRORdokO1r24fDxqokWlI+2k2gFTi5L5GerPpTpLJqxGCAFZGvZDCoiB7Rh1/UR7lNDAqv8dDwsucIgiN7mA8vDdOx8L/xiqK/FnbQSq2MVAoXeIUOuJt0VOAwYiTz1/D43GZdVwQXzdVr2KMpR1wyVNkFtdDLQEb9BLZOiURzkfDkqYorjX4lkmZmLMmHFV4RWl/eZFbZQWLItL1rXtJD7w4LVgbQ9pDMyro+p8lSdS47PRCXYJqSyy+yQMgsiHEo9nw26nW1ocWxoZTc/rLMfzdog8Gw2uPn+JqVCbOVA1pR3SYuhRJtZf+ktejPAkupwyzhQWpwM5yIFFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKqNKj1cIEb8nwulG9ykL8R/zZgUNNX0Oe4Paj4ImLg=;
 b=XKZm36Xv57t2hp+gxonn5iF3uqbnFye34TiE4JZ3hN9eCAUiYtbr5xWvTjVRNvIQV5xEImv4hOWJj2j8+wrFcpZw1zd/b1d5Tf0svoVSqPYNCACBgw9QudANwdP/eRbo32MvjWbQfdySc1CyCDnBKVZp8pOYgzPxqiDf4I6Caa23v30xT/wZD59N67dCARL5+lgCGsUyDYREpbugipqPghF48BS978XhW9KRTByuEnPRzaZ5armi6OG2JRBlcIKCErCAw4xy/jbgpFwemMrPqG2pcsCoaatV5LjpMqSnN7SOwAbswKEXEOvtINaO0vm11H/e4uuOVPJAiwmM4EI7HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6967.namprd11.prod.outlook.com (2603:10b6:806:2bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.23; Thu, 29 Feb
 2024 22:26:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Thu, 29 Feb 2024
 22:26:10 +0000
Message-ID: <2237d6b1-1c90-4acd-99e9-f051556dd6ac@intel.com>
Date: Fri, 1 Mar 2024 11:26:00 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: WARN and skip MMIO cache on private,
 reserved page faults
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, "Chao
 Peng" <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, "David
 Matlack" <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-9-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:303:6b::16) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA1PR11MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: 341050b0-1fb0-4aa8-70d8-08dc39756e0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fAKyMKgzBBPz2E6PcePcq12CrP1ZXrkjcBOCRvXLY4J9KZY2uwEpCC0buVKEzLFCjr5vWeERCJTonL4WZNaEMBnWw+byqX0nuEQP+W3kKcJYtC+7i8U22aZQtWcZ8wME9gg/wYvvlvNUJzchquI18eLP7dTHLleljUDy/OGh6zsN/MPe+L/2rIVM8iKvyuIVM2xe69LKDJkNdOyPwHe7mEXKiM5AwWkLAgt8i0UQMiO4hs7XRXOLC61BndTzEGnlpronHql0Sp3Cgv8II0qQygR3PqGKdI/7Cmkrr//kFMf/fDeer+HlWLlzhhEipKTd2/CbXkN/XMXZ+M0nd35XMBhJz/S7J/T91l2lbIVhSN7YT8uXFslGrjIdNjVHQsxaMwToOjKtxei5g5ByMHNctxOp7sUqe1Y9R004MiwN2nVW4Y2oQuOh6lrVQ5d4kc90GphSB5LK8anyknSlvp+5KYNNDNx8WprcbwrKfcL9dD0jjKIChPNjvtf78Hrr9amIAkMuKfOALpsiXUj7ys0CqPGmSvfac+1UL8ImpBe6n/umAjZnE4lzP+LRf5q3fMfMpIhSJdoofrKNLQ4yQK5RBHu6e26flnb7gq/mPUI+s2PCXSOcaFyRdwtd2JKnrKG15QXeZkgtTb0lo5t1ZWc8xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2xIby8xTWdxbFBodkxIbHYxS1g4MXpOTm03emhSZ2ZuN0ZOQmU2R1R3MGxN?=
 =?utf-8?B?azZ2MCtqa0V5WDVIVDdJUjRrTDIxZFZHVEVqZzFNcDhGWUZCUFZZdVpIbE05?=
 =?utf-8?B?R0JSSTBLY1UyY1VmVG5OL042bFBkMnpMMm5ySk53amkvOHJJWnQzL3Y1eEl2?=
 =?utf-8?B?ZnBoSWlyaTVkcGxUem5GNzZ5QisrTlYwL2N1MjJOQzQyUWY0YVRYWkM3Z3M5?=
 =?utf-8?B?cnVUcTVhbHNuN0MwWVZGMmRleGpkbmdXSjcvRi9hdk1LSy9ha0FxVmk1Tllj?=
 =?utf-8?B?cHMvVWRkaUZMMzBLM3pibExNK0dCYXlvemlGano1MG9GeEVmTDMrQjNOL2tR?=
 =?utf-8?B?K0JoM3gzOERKTyt5WGgrL3VXT1pUb08xVEdBcGJBSjV0ZlJ0UjlkWi93c3hn?=
 =?utf-8?B?L2xEa1p4dVk3aVBkMnoybU1aRGZxWG9SVTBOQUpoQTFVdUZabURPS3FVNXRt?=
 =?utf-8?B?RHZzQlE2MkMzRGNtRStrM0pKOHM1KzJvOGtWdW1rZGQyaFFDU25NMW5OK1I2?=
 =?utf-8?B?TGh2S1hrOFc2Q1ZOZmZkMFhYeXZYMjRmSTVpQVNrVUxJbTBOcGRJS21aRFUw?=
 =?utf-8?B?d0swY01LR3NLT21pK2cxQ245Y01ET1VCaWZFSE1TUGI4c3JUeFRXR0creW1Q?=
 =?utf-8?B?K0MrRjQ2SDJjZWdCcnBxQnhDeDUyVi85ZmNUbTJmdU1seS84R25OaXBZK1VP?=
 =?utf-8?B?UUIyeXRHenFjNExyUjRmaVpycHQzdjhaRmpjT3VjZGJCcmozbnRQUjQyNC84?=
 =?utf-8?B?TXZ5ajVVdTdldHFJV05jck5IdGh5bFplWGpvOUtqdXpLcURKRldqbDM4QS9W?=
 =?utf-8?B?cjIza0RQL1RpQlE4Z3dXTjErdUp5Y2cwMVkvSXlJNGVUVTBvVVhMSlFrYlE2?=
 =?utf-8?B?Vjc2N05DWVRsK0gwMWRLcHMvOUhVZlhRQTRVSUk5LzdORGcvUy8zT3FLWEd1?=
 =?utf-8?B?a3YyN29FeWlTa1lkcm5HVElxQmpqY1BjcFUvdnRSZWJRSnUwZ3VaOVd6b0Vo?=
 =?utf-8?B?TTRjcCtBQjUwNlpWMGpoVTRjdksyZTF1aCt3a05XQi9FU0FsaDlVcGhZUGFD?=
 =?utf-8?B?NUZlcXNCOWxwRkYzOC9zQy9HZ2g4VmtlcGhIMUY1eWF2dG9YYmZXNm9hMFhU?=
 =?utf-8?B?Mk9ma1VUbWIzTlBSRzhwSitaSUVBbmNTVnIxYTlGZkhwOU00alNuRkZ2bXFI?=
 =?utf-8?B?c01vMDVrRzgzdndzVThHMXpac2MybXMrYWl0eWt1bDlyZDRqZmhNeXdzbzdV?=
 =?utf-8?B?ekk3N2s1aEx6M0ZCL1NKOHIvOTYwSmlVVXZvMld4Zy9mdEFSMjgvdyt2dVVL?=
 =?utf-8?B?Sll0bC9hVnpJai9tM1c5VTk3UHVmL0tuOGx6V0pway82ditZZ2hkRW9FYzBU?=
 =?utf-8?B?RDVLUis1UG5vNGJ3aS96QlZIdHlZRE9zL2NKZTRmd3hheGJ4a3h1dDQwMDRv?=
 =?utf-8?B?SFhoc3I5NG5lZXlqd1JQSHJETUxQaU1QeGdFN0lLaHJnYXZHSFZXVGY5Ynhi?=
 =?utf-8?B?bXM3Nlk0WlY1YjVOS1BPK29rL3J3bWJ5UzRYeFF2WmhvN2VhRURxaWFhMkMz?=
 =?utf-8?B?dG96V0xlWUVINko0S1B3ZDZPL0MyQkkxeVFWWWQzNjNpTitkdU5VVTluOFNW?=
 =?utf-8?B?WHY4R0VzNUhUb3VGbWt3OUJtSk9KZ2F5WHRJTitNZkpwRFpGMXdQaEZSK0NW?=
 =?utf-8?B?QjF0K241d2pBTDdvQ0gzc1RsQ1EzazRaaFl2S3UvbEJzMlViajYvcVVVRkFs?=
 =?utf-8?B?OWdiV2FOcTNRNHNDNHNDZm5CRW52Y1RQai9qTVNJRWJkWW9LQ2pQdFBQOUZS?=
 =?utf-8?B?ZUkyNjI3TVZ1cEdwRUozSlNaSTkzdm1uRTBSSTduYXhsMjRYdVFBNGJ2S01o?=
 =?utf-8?B?NzFZK0tHcUFaVTNyTC80L1paaklJVHQvT2lCUG1UbTRIR0I5eDd5WVN5a1Zl?=
 =?utf-8?B?K0NKazE2VUlPd0twbys5MnhROTJSSHhHNUR2bjN4dXgrSGtmempnLzhLNUVu?=
 =?utf-8?B?b2x3NWZuaktaaEluTHVNa0FadzR5MUhOenB3Ry9kRmVRSjVOWWwvb05mUGNu?=
 =?utf-8?B?bDhscXNtbngxLzcwd2l5OFZrYW5vNC93OEJMMkhrMDhURkVQL1p4NTJoRWZK?=
 =?utf-8?Q?bekbC3ftgqwRRuB9tWU7EXS8K?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 341050b0-1fb0-4aa8-70d8-08dc39756e0b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 22:26:10.1393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fg7TBSR6NFuXU9fcbMQJNhNM0FILNJeLiirG+qJIFHz6vcMRvuikQVwpP8fOVKUv/KsICWciUFs9TpwDmibMuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6967
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> WARN and skip the emulated MMIO fastpath if a private, reserved page fault
> is encountered, as private+reserved should be an impossible combination
> (KVM should never create an MMIO SPTE for a private access).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index bd342ebd0809..9206cfa58feb 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5866,7 +5866,8 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>   		error_code |= PFERR_PRIVATE_ACCESS;
>   
>   	r = RET_PF_INVALID;
> -	if (unlikely(error_code & PFERR_RSVD_MASK)) {
> +	if (unlikely((error_code & PFERR_RSVD_MASK) &&
> +		     !WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))) {
>   		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
>   		if (r == RET_PF_EMULATE)
>   			goto emulate;

It seems this will make KVM continue to call kvm_mmu_do_page_fault() 
when such private+reserve error code actually happens (e.g., due to 
bug), because @r is still RET_PF_INVALID in such case.

Is it better to just return error, e.g., -EINVAL, and give up?

