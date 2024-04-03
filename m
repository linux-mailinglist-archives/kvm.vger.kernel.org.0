Return-Path: <kvm+bounces-13505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3EAB897BA1
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 00:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8951F2830FA
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 22:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54EEC156993;
	Wed,  3 Apr 2024 22:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QJcDOMo3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01093156984;
	Wed,  3 Apr 2024 22:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712183197; cv=fail; b=NUuEfLrqFVR4CJn6VLFclvuLDJg08uh3LcPh7lQWvGQHlvfmH7da8aXGNCxVAfLM2qkIdJCiMnXQXT9jFJlH8210l2c3Ohm4r2mpgGcM3gCctWKDfgUN1ZkQ9Uhm70m5FyfkgfrPhO+eqruSgHBL5+z8n/uN/CoydR8Fe7XhdXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712183197; c=relaxed/simple;
	bh=Pvla0oPHwvuOsT011ibTJoHa1V7hlNItuHdjAJ3KFhc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rW4xJxsot9KRPHqubiIyjlkRXOF/4VFTrLeZ+KR7B4+SPiKV5Qp3MwV+h6Q4vFtMtYTFe8nLACncUNPNChpe/PRm3ubzYfSEjc4Xp9dJ8Za9YqIdgnrg4SCNg9t1t5Mb/Hf+H4PkcnEBE5Po33pMx98m8KNarDP5qlMdv2p5P3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QJcDOMo3; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712183196; x=1743719196;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pvla0oPHwvuOsT011ibTJoHa1V7hlNItuHdjAJ3KFhc=;
  b=QJcDOMo3N9CnPiszNcI50Qny9EwFp08aHunoIS//c8XtTnTNnOw+1jwL
   kzSsn769b+UgwA1lf7u/NXzcd35ugGMg0a/PERX+Tx2VbfsuXd41R3MvF
   YT8vbRW7pOwN9k0qrxeYW6JdVVrLYKfEh4xEOx2o1ho2yIgxS7QtIvVcz
   x3IkIfCButzQEuuvStiJNeQ+dD+ZhMfUf2n5/gJh0apTIlbyzsLjIDM2u
   lMpedqoqvAHLL3Xgur4s4np8E3kmvQIciipCcmlpz99kCJ9VQAzQ+8IWG
   WTFCVtRKjrfnlx2b9ambk/WppuX2G4hmwvdry+DH0qMZDOH9BTzPUF7lH
   g==;
X-CSE-ConnectionGUID: hyzBaVldRCCIXzApewlPpA==
X-CSE-MsgGUID: ynXUjb2KSp2F4bHx38PNYg==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="18059076"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="18059076"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 15:26:35 -0700
X-CSE-ConnectionGUID: FkLRfmOQQWe01H3Z5aRgVA==
X-CSE-MsgGUID: fa0eg3Z8T6uvkbSf0MilNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="23282727"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Apr 2024 15:26:35 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Apr 2024 15:26:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Apr 2024 15:26:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Apr 2024 15:26:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6IGJ7NyMp1aZqB4Pu//Xy1UhgjV8bz3khCGKmJikG7EkNhKqQFDIfHKOi60qXgBjffs2LxWBu2FQqs6wNiMtDqJ8U5MaLLVMxAFdsB02DPZNK9X5SpWEATnw9oPGFKpw7yeyjIYdRPU3CVyqUE0BJzHBfT1Z4DSO2s4PpQOCEdnfZgMe0x8f0wZsLkK07re5D5sxdngF6YSvnncvw5JhWgtvidWS1PUHssQdaO33Fk4SXPGQIXG1Zrym4NWamKjn0/jGAOGts6tmeTcbgkUd4nN4GnGPyBeuTG4oAps1fo9dad29ueVYtd9MW08QUskMBzb8DNsPeTzYtB4sm9lug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXbgpkZJye3+XhE1q2ghFtBTK/Nccovw0K/75xxqYE8=;
 b=MWG+kdd998659q/jTrlMop5Qu0xYjgebB0ZLIv4qlosh9cmjXbPOdKJ0WJ5LUfMtaWkTLHvm92ZNCnwCQa2oEB6NaomLZt67N+MnDeF5SUjocnot6s64XzH0hP3EqwpGZWQjtATTjSZSFEsDHNmuMtbSsFuCRRrusJwAxh0gI3+jw75/9cE0msFqJ9lAWgYZvWz/eoXDJwbVM6ljafsI0dUTORx8OnvxBSvcYMXut0EkN/PcTbf0B2zAExYm8ype1nczulVQPxYYqJX/KTVoj6kJQGt8nzAVZT6trBvzJ9OxpYUbC/O4haxsf3aEYcoDn2LgxZUdDUEajYO3Ap1aFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB7013.namprd11.prod.outlook.com (2603:10b6:806:2be::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Wed, 3 Apr
 2024 22:26:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 22:26:29 +0000
Message-ID: <92a60bea-99f5-4656-b205-da468f6c2b63@intel.com>
Date: Thu, 4 Apr 2024 11:26:19 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <9f5c6259-78e1-4470-a013-91392bf3cea5@intel.com>
 <20240403172417.GE2444378@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240403172417.GE2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:303:8c::9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA1PR11MB7013:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NFOxr/KAnx2EKbYxy10xZttb5HxpnM7DbBVHAiFt8x+sZohqQQd0BiiTieBPogBSFnhjrgztUwVwlSADyTMR9nfvNzhSVj5XFWUQJh2j+CU8gFDCiocGo/p0fcwUy71D7mupQ25sw9yXEHe07Ka/P5t1tRv0Q+oF1Jzv1S3/1+Q+mAd2db9Wtr8MZ+DZm9B5INmPgEd+/DHRlixvM8WPjxa02kJ9L8o9buxVEjDqu+iIMJdp7bv0T8BvBsUFeclBRQAvqp+u4ZAfxkp9fVpQ/9GSLwT7qeRdrPwpjPDt2PGAuHn1wY34GDBEhw1ObPo5XQ/R0YmQLGyiHny0if2UyjXfJ5BdEdNqYu9yXF5t/9FcMqiFWtqEBkm9ZI462Q3N97hfJ2E9GZ+DG0XawC2Jf7OiJILKA8UNguDTCPg/QgqGclHKvbMxL2H2igm32aYxVcRidB25EvE0FgQ+GvmljQEi8wKWgREdTCejXLY5WYPtK/FVyIxQFSsAPJKqvOYDKebkEOI08DqBdyvPlsQsgimKFuYbIns/xEc1gbdA2Ex4ArUZtAU7iKP7QbjGYiQK7M187HRac2eITtaWepzlot7OmgGYfxp+S5UuXczqeYo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXY4SjdsZWxSbXdia0ZZRUtoeFF1ZVNiUGtrS0Y4aTJRcHpuN3ZIek1NMkU3?=
 =?utf-8?B?ak5zVWtjOTcwSkl3SHNablBINkhpQnY1UVZWL3c4Ym96ejlOZmZPVmI5dzdr?=
 =?utf-8?B?SmtSRG5DK0h3dFNMeEtjaFZWZW9KVk56bTY1TXRwaDYzTnRQVUlHQWovcDhs?=
 =?utf-8?B?aWlrNWVjWFV6dG9PMmU4aGhmYStPM0lqY1V4em5qVitYNXZSaFMzVTdwOUtW?=
 =?utf-8?B?U1B0N2lKYjVTR1c4bVR2VE1UUnUvU1F2dWQyWGdVMUQrRHVYK0hQbm5GSGFB?=
 =?utf-8?B?eDU3K3AxWVQ5VFpsbXNQL0dpRmoyZ3NIemtGYVcxSmRDVWhSUHNabTJSaDVj?=
 =?utf-8?B?MFNNRHcyaytPSGFoUWk2b0NzT3E1V3A0eTV6aGU1SGRXTW5Ba3VyM2IvZC8v?=
 =?utf-8?B?TWtEZUNNQVNHY0tUQ1YveXhBNWZ0Qm9RWVZpWGZVbjdObGplSGRyMVNGUnlI?=
 =?utf-8?B?aWhZVER0dS9RTE5aOHhTcDdORlV5MWVxQVFKNUN5eFJvMmxPOThiQzlOdlpx?=
 =?utf-8?B?eG1aS0V2T1BsL0d0emdlZVU1ME5leUJ4T3E0SWxTNzRCclhPWEYzOEZObE00?=
 =?utf-8?B?VmdoWWxTMkkyR3JGNzV6NjFFT1ZNQ0dpbkRNZFV0Skk5ajBQYmJNZVJYczZr?=
 =?utf-8?B?N1BoWnNvRnhTc1NlY0RZWkkyeHo2QVd2eEJHSmp5azd3VWZBekc2d0R5cjlW?=
 =?utf-8?B?SGhxbm9aLzlFaHR4YW9OSUVPRUZSbVZRYjVLdFU2bFhCdzhGRjhYd2RnRStW?=
 =?utf-8?B?UkNIRStTeVJkZ0hRaER6bW9JU0puU21DbzdncHRySEJNWGtpRDBiU043MitX?=
 =?utf-8?B?ZVovaTRnR1hzQ2U1SG9XMUpnUzNBQ0JmMFcrTm9scXlQZEtKNFY3YmVHYVZC?=
 =?utf-8?B?cGhXWXJnVlAvRDlEOEgzOE5BbUZ0M3JMOURxQ0RRd1Z4L3ZLOTFBTmFjdURr?=
 =?utf-8?B?bmcraExiNGsvU2VWWU0vY2ZJVW1RNjVhcFc5REx6Sng1NlNEei9ESTB2NjZj?=
 =?utf-8?B?clQ5K3h0eVBmM2puYXVlZFdFSkRvcHY0SlBBRnVMclhPYURDSXQ4SWQxcHNR?=
 =?utf-8?B?dEtraWNzOElwbDdGWVMrT0pEV24yUndoMDRFZ21hQkRscER5WVZnVituYWs5?=
 =?utf-8?B?TWNtNXYwY3FodFRwUnpPZVRINEFuUWQrWWVCL1BEaFJCVTVRR0FDNm5UWUVX?=
 =?utf-8?B?bDRMOXYyclFWc29MRXo3bFFkQnRWWFNDS2NTUk5Da1lmS005dW1oWG1BTTIx?=
 =?utf-8?B?Y1dNZ003QmNIZmozWnVzQW5Oc2xPMDVJdXI0WExBb2VsaXd0aXp5SGtRaWJk?=
 =?utf-8?B?VkFtb1BSbi9OSmVCblBQZ3d2ZDdkTEhDdUlobnJxdnFXbmhLM3BPdFJmSWYv?=
 =?utf-8?B?SzNkRFlBaENWQzRlZ0RFUUNjNGk1aE1Oanc1b3ZFQkVMU3c5TWc1dEdtYXE1?=
 =?utf-8?B?SEZYVkVFN0hHZzhMcVlHVlgvejFudU9ScFlzMWtXVTJlNVhqUmZNa25TYlJy?=
 =?utf-8?B?L1BiTFBzbVNkOGxOY0poK3B2NkUrK2dhOXg0WUl1andBQ1gvbnVMb3lwMUZC?=
 =?utf-8?B?bWtLbG9DMVVGeHhVanR5RnFWMkY0R2R0VVdaZGZHQnhpVjdSVE5seXdPMGNp?=
 =?utf-8?B?eEp3eGdZSVNmMEM0RkZMR3lUZ0VaaEQyUTNiN1BaOE9IUFdhdDQrSWRZaXhi?=
 =?utf-8?B?Q29zdnUwQkZVbDgxdW92bi9sSkQ0OHRvMThzQVFOVzVsU3BKRzhyLzUrd2wy?=
 =?utf-8?B?NG1IVHdmTW1TZnBzejBjeThCTFhoaGVFRzhIeDF6S09ibE1VVGZmR2U0bkg5?=
 =?utf-8?B?Zy9SdlhqSUtTOHpCK0x3bUFCMXNadG9qVTR4L0lZek9iZlZpSXk0U2lTRHBC?=
 =?utf-8?B?cWd3WDN6ZHFBTHFlY1dFTGpSVk9hMnQ3Y2dsUktqdDgwZVhPL25FQlZ3bnYv?=
 =?utf-8?B?RXIzWXNzMi8vTmxDWm5icjRCMFRVdFJnaDVieUpvM05IK0N4OXN0dnRtTGRn?=
 =?utf-8?B?bVJVRnZYVGZjUndCWGg3NGZSemZpTDVSQmtPOG0zcVhVVjVoek5hNTE2MHlO?=
 =?utf-8?B?YzJIMlQwc0tEQkNnV04vNzBGb2laQVRFU2Juei9JeTVVMDZCUWtzS09zY3d2?=
 =?utf-8?Q?bHty8MLgvyGGeyvtG0wL66cDX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d6e46f-a095-4358-11bb-08dc542d1bd1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 22:26:29.8591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uoYKn158Da7w92pHEsHRJtrNxgn4g8YIOTidHhhCywVM796MZqDR+JOfCXxdlOzTZcYWxBj+Opm5uH764gUI6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7013
X-OriginatorOrg: intel.com



On 4/04/2024 6:24 am, Yamahata, Isaku wrote:
> On Thu, Mar 28, 2024 at 12:33:35PM +1300,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
>>> +	kvm_tdx->tdr_pa = tdr_pa;
>>> +
>>> +	for_each_online_cpu(i) {
>>> +		int pkg = topology_physical_package_id(i);
>>> +
>>> +		if (cpumask_test_and_set_cpu(pkg, packages))
>>> +			continue;
>>> +
>>> +		/*
>>> +		 * Program the memory controller in the package with an
>>> +		 * encryption key associated to a TDX private host key id
>>> +		 * assigned to this TDR.  Concurrent operations on same memory
>>> +		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
>>> +		 * mutex.
>>> +		 */
>>
>> IIUC the race can only happen when you are creating multiple TDX guests
>> simulatenously?  Please clarify this in the comment.
>>
>> And I even don't think you need all these TDX module details:
>>
>> 		/*
>> 		 * Concurrent run of TDH.MNG.KEY.CONFIG on the same
>> 		 * package resluts in TDX_OPERAND_BUSY.  When creating
>> 		 * multiple TDX guests simultaneously this can run
>> 		 * concurrently.  Take the per-package lock to
>> 		 * serialize.
>> 		 */
> 
> As pointed by Chao, those mutex will be dropped.
> https://lore.kernel.org/kvm/ZfpwIespKy8qxWWE@chao-email/
> Also we would simplify cpu masks to track which package is online/offline,
> which cpu to use for each package somehow.

Please see my reply there.  I might be missing something, though.

> 
> 
>>> +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
>>> +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
>>> +				      &kvm_tdx->tdr_pa, true);
>>> +		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
>>> +		if (ret)
>>> +			break;
>>> +	}
>>> +	cpus_read_unlock();
>>> +	free_cpumask_var(packages);
>>> +	if (ret) {
>>> +		i = 0;
>>> +		goto teardown;
>>> +	}
>>> +
>>> +	kvm_tdx->tdcs_pa = tdcs_pa;
>>> +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
>>> +		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
>>> +		if (err == TDX_RND_NO_ENTROPY) {
>>> +			/* Here it's hard to allow userspace to retry. */
>>> +			ret = -EBUSY;
>>> +			goto teardown;
>>> +		}
>>> +		if (WARN_ON_ONCE(err)) {
>>> +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
>>> +			ret = -EIO;
>>> +			goto teardown;
>>> +		}
>>> +	}
>>> +
>>> +	/*
>>> +	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
>>> +	 * ioctl() to define the configure CPUID values for the TD.
>>> +	 */
>>
>> Then, how about renaming this function to __tdx_td_create()?
> 
> So do we want to rename also ioctl name for consistency?
> i.e. KVM_TDX_INIT_VM => KVM_TDX_CREATE_VM.

Hmm.. but this __tdx_td_create() (the __tdx_td_init() in this patch) is 
called via kvm_x86_ops->vm_init(), but not IOCTL()?

If I read correctly, only TDH.MNG.INIT is called via IOCTL(), in that 
sense it makes more sense to name the IOCTL() as KVM_TDX_INIT_VM.

> 
> I don't have strong opinion those names. Maybe
> KVM_TDX_{INIT, CREATE, or CONFIG}_VM?
> And we can rename the function name to match it.
> 

