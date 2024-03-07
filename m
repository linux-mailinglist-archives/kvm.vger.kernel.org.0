Return-Path: <kvm+bounces-11223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FBC1874508
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA8F11F263FC
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D68139B;
	Thu,  7 Mar 2024 00:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XG0kaCRz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E62380;
	Thu,  7 Mar 2024 00:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709770290; cv=fail; b=qy8Os/XUmiMtSXf0sWug9FBFyxMUjHm6O7eF1vMgaru9lrtzNeZCGJeabgXxY5PWOcbiaQ6XlKHzf7Gi726U+Mkx/ou4t9YO00a1Bdhq6SxCCZETMU1SDLM2mnX9AP7P2ewN2a14XmcNPC1/W7tfz+2Y1jOkZueEGXpIBvbebvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709770290; c=relaxed/simple;
	bh=gXDcHork2fYwQCwKX7bR3nzseO/D4H5vngqk1ZM7EM8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=unCvI83f7L2MoGZPMCNv34EePoEEOiPPmQV/xSQfdqOsSPZ5jQ8TuJtJvqN7qm+0TvPX6f3F7Rs+zZUYk5lcgE9PWwaNmNae3qkv8p9Aou/WXMW1KAD0W5KTkSxLBfeyAqTLvoB0mXqGnarXa67/Mis0ySzvQvIX307DJzzp21k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XG0kaCRz; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709770288; x=1741306288;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gXDcHork2fYwQCwKX7bR3nzseO/D4H5vngqk1ZM7EM8=;
  b=XG0kaCRzw+ZCPrK9GfDJHCuWMBG7zCFcqFR/Dhu8R44s78OltoLMRUAz
   nkxUGLVqmnFAekfwFLOyKszIL7gCtlFAa8pyWOrdn/Uf+8un6s0tacRsV
   tkdx3RbjqmYRM8gcQcKXLMaAjyYKQPIJdtT2MCFuUomEll6TPOpY3HmwC
   bT9pDzjoZwKZqZJC7x6zUexv/v90LJB54KVXTFjwAmduVkOC9g0IMu6hK
   xs5cH0upu8sLhOCZweIt7//OMpkiULj/K5Eje0tNEuso2jNudfL8vx4H7
   ehsZjjBfMK3KHTGu2wceNDUx3J2CVDboEW0tL/9u+CcbQ4z6mpLbotjMi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4584416"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4584416"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 16:11:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="47428728"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 16:11:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:11:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:11:26 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 16:11:26 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 16:11:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PuO49o2UlyAC+uwRuPAjPHWoOcfzH88z4RrfS5kHs07mnFRiMDSesVZwT8Wy/SOb/1C4AlNkmjYnbUmEGA857YyDx69TVkXq6/aJM5Ryz6V7slCrCnVu7ZwQDQcdhrmJ7KY0AtXHV7AlXsEOhd/UOIWS1rk/A9X1sBpD+3KghryKr+Fr401xGHMqM5YpWdNWBrUIqnLGD2Nv+ADjuIu8U6lBH7Pi53vjszVHVdeKs8edQsB4Nv2m3n3XP8i9evg3n1cezqXcBUdLGz75mhYLN6JtPCBzgYnmbCt4875WIui4NLIS77MI953yrH/bVhCPDcLqms84EgoRDIUDxUGXDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGI/BGSRb1ymhei3mSufCeknCHcxjur/SOjoRB6S1fQ=;
 b=R0XOUKZy5EXIPE2r2+qKo5zd9WPjtq59u+VvFb9GtYyiqixXxtFVKA5KdXjvae6WkjIDO7kuHTBsDSK8NCZWTgOvAQtahlm+DB9b9VBsMR6wxSqXJw2DAhrGFlJA3ALQixlJRrVq+PUaL8f1AF8UOwsTlJVNmHXYRRhfwwaH4/JbUeKpFL1bQ4DPGE4RBJb2Q5bDFmnhyjsvkJfraVDCce3/CPzMHHHrQ6YR1UN8EvHmJJsIwaWV2KcwT+8P6kopqrVtwgjaqjS77K/4V3ar1NEkc4UYw4dOoAQNMhxxATnY2wjTTr4KKnp95eH+AdDny2Pd55MWho4lmd0ts4Eahg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6728.namprd11.prod.outlook.com (2603:10b6:806:264::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 00:11:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 00:11:24 +0000
Message-ID: <ccf85ef8-049b-40a9-adcb-eac0cdc57b37@intel.com>
Date: Thu, 7 Mar 2024 13:11:15 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] KVM: x86/mmu: Move slot checks from
 __kvm_faultin_pfn() to kvm_faultin_pfn()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, "Chao
 Peng" <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, "David
 Matlack" <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-13-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-13-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0030.namprd06.prod.outlook.com
 (2603:10b6:303:2a::35) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB6728:EE_
X-MS-Office365-Filtering-Correlation-Id: 974cc6de-e7f1-470d-6002-08dc3e3b1fd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gBhXo7cJnL1yWx98eAVcmCzOEGoLo+4f3StVwqV+in8lYrlSe2ZmDeQiqZ9zTD0ZqB+UANQN8i39iDqaXhFy+lIGF92hhJ4zdC9JAvxsWgr7S9A+xCqA9kCrYcOJNyMjFlInI2bhPLOmf3PhaoP8YESL4aNuhfL8wMMjafTE1eXfAqJRDuRxChzDcXoIczfuhVWVnBh0OpOshTKgCHCOwm3qhkSdO90LjYRx5H2A/i0Yqv+mf7w8f5pFKOa4EhYGZc3YmnXhFaeurlAu7Kw9kij752mQTUJIlVBOzpG63kHUb3HT0hufhLPsUxBBnh2yNqql8HTVsPfSa3rzD6yoq9ogwCE3dCIcTM2W1ioV4nd4pqIZyAws3Cen02W65OkGVsdB+k0oKF2PVK29Tpv1tImw+9VHnDTwnYhpWADfBVeCP3yUWbWDN1lyZ6ORBGMkSuXpZxSikaFFAyVpUzb+ZLriPtqsqN/EQ0AxVtW4mHPjq9Bzwqf5rLWgSb23aB4Be7/rfHKnuIj/EGT+VpzMyiz52I8pbI8IKuxOHAxE3P0ygG9ukSnTE/+ML3++bRiPf7qwQjF0ECl5T/Dr8oE/jXW9kHdyXv37E4xtzNqEjkdYZZIcf/2DdRZgijdabO17lWWPhIsaCqjhlIn+Rl2p52HGQH8xVd/zZL2C9WJ/L28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWlIb3llN2ZaTjBZQmhjMi9qTXpuZE5iVU4zSkc2a0xJOHNteHRFaGxQSkty?=
 =?utf-8?B?TGp6eENCL3gxdGR0UVRZcTNITzJRbGtOblNBMVMyRXN3dUQxNFB0QTZWQkF2?=
 =?utf-8?B?dmRac2VaTHFQQndTUUYzRTJqcFJmTUVYY2RrbURpeTNQMkQ4N2czUldlMEd4?=
 =?utf-8?B?ZU9zZEJDTUFQVTJPVEN5NCtYNUMwZVUxcnlYUUF0SFNYU0xFV2l3eEw1M1VX?=
 =?utf-8?B?cW84OWJ6VjkvYnB3a0p4NkZTQXR4RjJhaE1UNmVXTGlZTDViMFh4UE9xc1ZQ?=
 =?utf-8?B?Mk5Ga05JRlNFQ2lVQTN4RjVWeGt0QW4yMEVqSTU4aEh4NUtIR3J1dU50MVVO?=
 =?utf-8?B?b2M1aExvL1hxV3NKc0xZNVFXYVo5dk5JVXhkZVlvUWZVeEZFQzZZTHBDZmxo?=
 =?utf-8?B?bWJucTFnY3VOUmsyelMvVW5ZSEc5U1gwdnJZQ2RmcEJrYkFPVkhCTEMycmpz?=
 =?utf-8?B?cDVNay9kUWdId3FJdlNwNXRjemxBcGc1cDRvRG5DY1BmYkxiSVJoV2U4a2ty?=
 =?utf-8?B?UlU4MStzYnNUZEN5Q0xiQjJGOXF6Y2ZndiszS0c1eUxmRTk2bVd0ZHozaktU?=
 =?utf-8?B?dUFsUEtPajVRcXIxSktPYUNZcUpCTDR0T1JDMmZEVFNxcEZFYW1nMCt3dnkv?=
 =?utf-8?B?SUhxV0sxRURHNGhyQmp2aG41MVExVmdBa1ZMbFZkcTg4cllOc3IxYjVmdkIz?=
 =?utf-8?B?T05TUlhkcVhHbHBlU3ZMUG10dlpncTZwNXRwRUg0TzBkOE53TUZoV1lBYThU?=
 =?utf-8?B?TU9ieDdQNkgzNEdOZm5yQU52enFYSWxPTzF5ckhXSHZGYkcvYVlkY1ZLU1pO?=
 =?utf-8?B?N1NkRTl2NWhOdTRhNk9sNHcwQ3pYU3NVbnFiaGhDMkxqa2szcDA3aFRCOXhP?=
 =?utf-8?B?UGgwTEZ1eVptNWZEajNacll4dDdqVVMvQ2YrMG1kY1dyQmxxMmpSeUNWWlBy?=
 =?utf-8?B?MC9wU2M0c1BIUTVVQ2NqbzVPRzNuV2d1VGUzdGFmV0E0U1F2T1h5WE9makZx?=
 =?utf-8?B?V2t0RU5ubWNIR3pQdTFmU0diWW0xZ3Y5c2FZMmNwR2VpVzI2cXRESCtwVEpt?=
 =?utf-8?B?TG43TjJwTUJvYVFtcTl5R0Q4bFdXekxxeTRJbWVTc0hCS1BlbmlHMnVHcjFo?=
 =?utf-8?B?Y1lYOXF5dE5yWGlNbktiU0h3Q2VjV3lDRHpGZjlJNXc1OUMxV0RZVzJGcVZu?=
 =?utf-8?B?VGl2emZBVlhkRnZROFYzeTd2cjNQelZtbHlWRmdBSFRMaHA3ZzlSbExXT081?=
 =?utf-8?B?ZmN1WHJPSmFRcllTcnYrdXNDalVjNHJySWdBbVpvSWFocTVnaElRcUEwNFoz?=
 =?utf-8?B?NSs2QThoWS9pZmFXVllmQ2hYdFBuYWppR1ZMOGFaZ1Z2TmRhOGNNczQ2VWRw?=
 =?utf-8?B?VEpOTDd2dFd1V3hVMEh2ZXdnQUkzVHRMNGJvemV2azVaUGpQQ1ZuMmxHTTQv?=
 =?utf-8?B?WkFlMlNsWEFNU1c2REZYcThGTmJBS2NvV0tYYWpzcjIva2xTYnRJSWE3R3o1?=
 =?utf-8?B?T2Z1RUV3SndsT0h6UDc1Q0c4MGZ3RllDT1pSZVFrbTZiRHFNalR6cEsydURX?=
 =?utf-8?B?ZERYTUxDcUhUOFFEVmFJVEtCWE5qKzdoaElZRGRRajFpVnh5bHppbllocmVV?=
 =?utf-8?B?dUtpTXpnTG5aTEMwUFVkdG5qNU5yMUpIdjV2ZklMbWtzNjNFVGRHVWJhNUpo?=
 =?utf-8?B?Y3pBMVhIT21OaVAvaFI4ZU5uVTVoeXNlNTErRlI1UElsR2JKeDFrLzZNVFpT?=
 =?utf-8?B?dDk3eW1pbTJGampOeThCbFBYclBLQmpFWHVRNGNuVUxUa21rR0ExN3V2MGl0?=
 =?utf-8?B?VENFV2k0UFVRWTBUWXBEQ05RbEhndS9nMVoxamV0QzNoQkR0NjVmZ1hTQ25K?=
 =?utf-8?B?bmNZa3JmU3F4eTdDWjFOVDZuN0xUcXdTWkhpbU5YeTBpTFh3a1lrL1J6bFdO?=
 =?utf-8?B?dmRXTHZkTzFNODlnbGdkcGc4T0hmNTl6dlpmNW5xMCszbzRuNkxVQlJRR2RC?=
 =?utf-8?B?a3YwOExKSzI3ZytUdytSVXlyU1hwRlMxbDdxNnplVEgzdk5DNGc5UUVpQzJE?=
 =?utf-8?B?RmpWRGEwc3NYWk4vd3ZKSDhkcUFjd1g2UmRKdFppVGdWK2drV0hrcWdVZHlr?=
 =?utf-8?Q?nI0NTanSwOcaX1/ldSXoVVaQA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 974cc6de-e7f1-470d-6002-08dc3e3b1fd9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 00:11:23.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pLdfrcGRgw+FtfFa19LsfX6MIL0ahIfJad/IT6yIMoxfSLY7bCVcscNSKeHs0doKlo8/G/3YP9d0Sg8CaYDWRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6728
X-OriginatorOrg: intel.com




Ditto for accesses to KVM internal memslots from L2, which
> KVM also treats as emulated MMIO.

Nit:

This is not accurate anymore due to your previous patch ("KVM: x86/mmu: 
Don't force emulation of L2 accesses to non-APIC internal slots").

> 
> More importantly, this will allow for future cleanup by having the
> "no memslot" case bail from kvm_faultin_pfn() very early on.
> 
> Go to rather extreme and gross lengths to make the change a glorified
> nop, e.g. call into __kvm_faultin_pfn() even when there is no slot, as the
> related code is very subtle.  E.g. fault->slot can be nullified if it
> points at the APIC access page, some flows in KVM x86 expect fault->pfn
> to be KVM_PFN_NOSLOT, while others check only fault->slot, etc.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Feel free to add:

Reviewed-by: Kai Huang <kai.huang@intel.com>

