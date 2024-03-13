Return-Path: <kvm+bounces-11723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B98687A521
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 10:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A656EB21662
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 09:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D9221109;
	Wed, 13 Mar 2024 09:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ffz+/Y77"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E4920B2E;
	Wed, 13 Mar 2024 09:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710323015; cv=fail; b=M8J/tAVcGysN1k5CEHcGmjc17ePyo9K0ZGbm/vD8hw8h4Cj5+FYfw9HJyrUS/oG/PonLdHzqTzRNf59aYYbk4dYJZv7aV2FiqZ9VvQh5jCDMpvLSC7AdSVAAyZylbrNty/QWs1lKqh/h8ROb1d3GgQiNJcn9uo57Ya3W/H7+sIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710323015; c=relaxed/simple;
	bh=ShVQJxC2S5sjYfePOCxDorBxedzvjBgyJxVrU79/9AY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K8pPTJA4Rh/DtRdwnGQFSf9r1EH4mq+v5UGYcLjQwbPEd++AJcYK1K4ji0c5zF6kti1Xemz0tuD/PRfmPyH2BFLkO7PL2yshinoqGrELu/2EYU2AmLOGoQAqp1pMNUkamD73kXRJjLIP4iIGwXnMVLj27QoYFpb29cnZqd42IKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ffz+/Y77; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710323013; x=1741859013;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ShVQJxC2S5sjYfePOCxDorBxedzvjBgyJxVrU79/9AY=;
  b=Ffz+/Y77H54ulxsG6gjmNE3xNBVCeJA0o2IooloLjetO5yTIEi0YZWRn
   LV3mAwv0uwklymQ2hW+h9N0dIHRXkcPIBOaLevXNpSMpTHIPSmhK2oo7u
   XpSGD46KUQCwp2hE7qwBLPW9lhK7FVJMcwuJ163EeYW22EQPuF4HDY5CP
   ilw1ZRGFOCtWG64ALOiYFEUIGAnHQSOIBc9cAjP6hU08hnv7/t/xoJhGB
   PaTuiO270GIt0Oj67sVTLlXHFb0/8nm+42cPmAKqhopPTV22Fpa2G0dd3
   r9QVnT/+Wp2MgwPL1+LhwQ2Vhlo14UQ32S3YXm1YTM2bFXuzQsinqboPw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="27552879"
X-IronPort-AV: E=Sophos;i="6.07,122,1708416000"; 
   d="scan'208";a="27552879"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 02:43:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,122,1708416000"; 
   d="scan'208";a="12285169"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Mar 2024 02:43:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 02:43:31 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 02:43:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Mar 2024 02:43:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Mar 2024 02:43:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQB/CH4w078YJ3KS2x28HL1wnfpt06r62zXsSIFW60SIYTl+YlB7zZfF5UI5Nc2eOezEW33XDSdtoophioPBurxNvqj6jc3TicHdG29BN8vDNcuQZT+Q+JNtXzihBRVEq9akOP0vLDdOuHipDRVD2lKdlBogRqG+CbrX3U3MxhYCxrY9HDjjgM3pMAwFKWdwColkvDs315e25kx7WJ4/ZCazIYdfXqMQE5pu79roxFkrmtq95+4OH3rtWX2bgKgGR8sOBQaqg1eXkygWBfOVXtZ6EJwHI0XHyyR4anHwwlxfU5Rd5QyfR6+X+I8uQYML8OtPZJxa0Mjs37ud+z5Unw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnyC991cOWFiW3rqZY862kdKJV0FPQYgRqUBf4H7yzM=;
 b=RMqeT0UOYnBUDkuD9L8JZGIAadfKisRxSAPNiMJ63XgFz4yckaY25NWL1mo2KHvuXPhcF0mLvBVxo/zWlFGMpd4xamYLA/FFFwnkk8DhTeDjN+nr08lH2O4JRT87AfRRF5J/MPb1ULtcHbbABtRYx3GBIgZROypCDsPX+BPUeQreOkuLvWoYf1YnvRWmn4SkIfJLCh4Z21+Ogn505NO5x/goHao/+Ucy0rodzdO1HciJ0tE6LMaSfFzHAf3z4S6m1wuTJ1HA3NYIQNTP/qts40hpE9QH12J1ctfBvIVLOdXiBfHyEjNKKuQWg6K27mnXgkI1/e/VZpc5XIF9oXxH/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7873.namprd11.prod.outlook.com (2603:10b6:930:79::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20; Wed, 13 Mar
 2024 09:43:24 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff%5]) with mapi id 15.20.7386.015; Wed, 13 Mar 2024
 09:43:23 +0000
Message-ID: <9f820b96-0e4b-4cdc-93ff-f63aed829f0d@intel.com>
Date: Wed, 13 Mar 2024 17:43:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 20/27] KVM: VMX: Emulate read and write to CET MSRs
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>,
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>,
	Oliver Upton <oupton@google.com>, Mingwei Zhang <mizhang@google.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-21-weijiang.yang@intel.com>
 <ZfDdS8rtVtyEr0UR@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZfDdS8rtVtyEr0UR@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:4:197::19) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7873:EE_
X-MS-Office365-Filtering-Correlation-Id: 87a1c72c-7984-4619-d112-08dc4342066a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02JajowEWif4Xvaoyf1HUJyY78FePab9bn32tYFGcizmffcOK37BO7oT151JtcCNKMHtIs2o4QcZpIPnEsHG2dEluoPRZ6EJqsmejnZqpejQVAWBdLSYph8y06mBdq+E0RK6P947L6vG9UyycQcaiNFDpNdfVObIUQyi79PiWNR95QnY0K9WqAVBvBwO6iTNb1rc2pNSQeejYM1in/8Ocs10G64ckarzoKhMf2RMgtiBRmz6CfPTGN7tbV2HsvYZG86erQGiSQWouXp4obaNcWK71nOb1GtxVGrs16Iey0PmfkajxY7wPCR8ZweqmKvFjd2iu/eHzAj9Xz6eUcTKllEFoPBNnqlpvbr/NYG7tcQ9omVJ3QMqwtdRa/ipyLqDuFaIxwHqu9bzleAaQc2lSDjvP45ooVwW+lyiED8wWMEFwW6qisAORaUdgiqe4zIBA2/12SX9Sqk4BYrXUfqPKgRie9NZLWpB6zLPdk2bZPBuXJgJYmv6QZpDKlEdnTENAGnPYCRM1Gq6pnPdvLnc5zVznJWNyDqTnO+SFlFAWgFMiqzP2pFQ3mMvFSIs2gbK7c5e4AS+1+vq5jjlCGcwFP6Uk0A/DLpkHwMYgafDDASDjVeDN+ZCjj0BJnV0dKbr4c4+sYy2afBWeU2/AsZ1sjPfiEl8xauppJ7mUDV9nLY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3FDMXRpc0ZBSHZ4d1lCR2VzREh0WlpQZzRTMXY2OTE5MktFRkhuZmdVZVJ5?=
 =?utf-8?B?cFNGOWZSNXREbVN6ZDhvbFBqTkxBeHNoTlAxTzJPbFJ6MVRWclZuRGlkdi9H?=
 =?utf-8?B?RnJVRXlRNDBiakIrY1A3Rkx0Q1pQdTlRUS9uZDN5K3FlR1JFSllIRnp6VmRS?=
 =?utf-8?B?WU8zWVlvVnhwb1BYZGtBd0hkTFY2c0RCbEFtbWkrWVRkaXBjODA2V20rTDY1?=
 =?utf-8?B?QlFwd2pRMHY4Z1VHSmxlNVp5THc3eGFlTng4WEgrTk9OSklsRnFscDNoZ0FU?=
 =?utf-8?B?L2VPbVVmK2NwZlpSTW1CRFJOQ1JDNkFkODFjN0x3cmNaQTJtM0hWaS83NW95?=
 =?utf-8?B?Zmp1N05JR1dWK3M3OUFlV2dGakYvUDRnKzhEbFpSOE1kS1lRQXhFeTFtenpo?=
 =?utf-8?B?aDAyekdPYWhCNnFZNTc0Nm5kWEJiZ0ZrenBYODRPWHZvenEyclNuMEZXSTlp?=
 =?utf-8?B?Sm1OOW9ESnBnMFhHWGpnbldFOEZqTTZWZlN0S0hsL09WSlNTL05iY3dNY0dI?=
 =?utf-8?B?MlJ4MzZCaHpyaEhBMm9qeFRjTGlCZ1l1cHhaZXE4TksrU0licTNxMnhHSS9k?=
 =?utf-8?B?aVF3aU1WSGdya1hpOHFncU84dFh1aUpJcys3L0hNVGtSc2ZTZkl1RzZXQXZK?=
 =?utf-8?B?ZUViY0VxdUoyL05hUnJqUDNXZWFhZ1R0L1hHTTgvWW1RbXpmZ2ZoTXhOdkdi?=
 =?utf-8?B?U2JUaFBGOFNVQ0RtTTg4ZVNMTnFndHdnTFp2M0lvamJ3UUJZaEQ1eTUrSjZW?=
 =?utf-8?B?Y0pPWHR5alRQN0xUdVBja3B6NEN2NlVYbGwreW1MT2YyVmY0b0VJUzZOWUJq?=
 =?utf-8?B?U09YK0d2VVYzVW9mdmpHTXAyT2lhcHJXZG1vdThseWRMQmVjQjVxRHRTdmpN?=
 =?utf-8?B?eTRUY0RVVFZUa2M3a1V3THRVMzFRUlFSNzVVS1FDaWlxcXFtRWdLaUNLUFZQ?=
 =?utf-8?B?Wk5WeEFyNGkzVFBxTVNjejRBKytsbUEzYnNaZlhoT1Vlcmx2SnI4MTYvRmo1?=
 =?utf-8?B?aEJuVzlibnRPOUhyMnNCT0FRS3VUQUNQUlROc21tUmlpS0xlS3d6Q2JCKyt1?=
 =?utf-8?B?cVBOTDdwaEQvamlQS0ovbGNtWk1wRllXdW44RmYrcEpraUp6Y25xYWg3L0Nh?=
 =?utf-8?B?V3Bia0tsSTB1YzdZKzBURWJ5UVNYWk1qTnJ1VXloZ3NWOGRiWDhqZFBDcStG?=
 =?utf-8?B?amVkVVpSdkZ0RlFSc0Zrd0FtTUFBMGVTR3BtU0gwVmttTnFEaklTUDBKVmpD?=
 =?utf-8?B?dlpGT1pDYzRqOTZSNTVjcWhSTDhMRVcvUVBBZERyUUUvcXZMNytydkdWQjM0?=
 =?utf-8?B?WWtNUGkrSHlPelZBcmp5dW5MOVdzelh4UmtKQ0xYM0tOcElYc3ZnYUprQ2Rq?=
 =?utf-8?B?OUxzbTVPdjhtbG9nL0hFU3lnUldTY211L0NWMVhjYW9keWlYRnZ2Z0h3dnZl?=
 =?utf-8?B?M0JUbDh5WGtlVXV3dFRrazlBd2VjTWd2NzNsdHkrNnROR0N5SWgvaTdqUFQw?=
 =?utf-8?B?QWtibXlVMmcvcGlVWStteWxBM1JUc3grajdyZUpaTFNvdkFHN3pQdHVpRGVO?=
 =?utf-8?B?UGlxWW9NYUcrS0I2bzgySklOSE1EdmU0VHBVbWRNY211QUNma243eW12Rktk?=
 =?utf-8?B?WFFiM3lkcm9FVjNvYzBuSUtnL1VLSFBXZlJBaHpKWUR0L0ZnVk9QSzZqSGpW?=
 =?utf-8?B?TmNPSjBFNUF3YnhrM0dBb2xoZVJxNTNzTUVVR2lnZkhuR3pWVUo2SWZGd3dC?=
 =?utf-8?B?NHp3NjBOTzJCejdzVDhITnpvVnJKamprNktYM2FjMjMvNmVZRmtwWGpMdVc5?=
 =?utf-8?B?dlZNUzBIcXBZSlhJbHR4WHBXc1hVS3J6bjRLVWJlTWlVTGNLMzY1YXZEa01p?=
 =?utf-8?B?YkZDZmtVNktGbUs2TTViaHBCRlk5Rm9ESmRvbTd6bHhWM0xhejIyckNTdldl?=
 =?utf-8?B?QVJVdDR4RlVWcDkzVGVBSjJKWTNxVTRNNzhpOU5DZTlsZFo1cHhub1NCNW9u?=
 =?utf-8?B?aU41bjZzdWxEQjR0akpQTVFkSHdLcU9JUDZ5S2tQYkRIZjlMZXVrV2pMVW5t?=
 =?utf-8?B?UGpQc2JEcUpqNHBwSmlNMWpZejlxem1CVFQ1NnVPZzMzR3M1OFB0Y1NWNlJ2?=
 =?utf-8?B?TnVBRUNQRVp3ck1zOXQ1RWpQYzB3dXZvSHN2N2lSeU9qNUd1RjNxb0lta0lw?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a1c72c-7984-4619-d112-08dc4342066a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 09:43:23.7524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQNbeLzGXWxQZd/VKc31EMTb1zd6+SyORZ266R4EoQypgX8O24E8NnpfnrkFLlThq5C0PRSJijp83e+grhT3UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7873
X-OriginatorOrg: intel.com

On 3/13/2024 6:55 AM, Sean Christopherson wrote:
> -non-KVM people, +Mingwei, Aaron, Oliver, and Jim
>
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>>   	case MSR_IA32_PERF_CAPABILITIES:
>>   		if (data && !vcpu_to_pmu(vcpu)->version)
>>   			return 1;
> Ha, perfect, this is already in the diff context.
>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c0ed69353674..281c3fe728c5 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1849,6 +1849,36 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_msr_allowed);
>>   
>> +#define CET_US_RESERVED_BITS		GENMASK(9, 6)
>> +#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
>> +#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
>> +#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
>> +
>> +static bool is_set_cet_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u64 data,
>> +				   bool host_initiated)
>> +{
> ...
>
>> +	/*
>> +	 * If KVM supports the MSR, i.e. has enumerated the MSR existence to
>> +	 * userspace, then userspace is allowed to write '0' irrespective of
>> +	 * whether or not the MSR is exposed to the guest.
>> +	 */
>> +	if (!host_initiated || data)
>> +		return false;
> ...
>
>> @@ -1951,6 +2017,20 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>>   		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
>>   			return 1;
>>   		break;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
>> +		    !guest_can_use(vcpu, X86_FEATURE_IBT))
>> +			return 1;
> As pointed out by Mingwei in a conversation about PERF_CAPABILITIES, rejecting
> host *reads* while allowing host writes of '0' is inconsistent.  Which, while
> arguably par for the course for KVM's ABI, will likely result in the exact problem
> we're trying to avoid: killing userspace because it attempts to access an MSR KVM
> has said exists.

Thank you for the notification!
Agree on it.

>
> PERF_CAPABILITIES has a similar, but opposite, problem where KVM returns a non-zero
> value on reads, but rejects that same non-zero value on write.  PERF_CAPABILITIES
> is even more complicated because KVM stuff a non-zero value at vCPU creation, but
> that's not really relevant to this discussion, just another data point for how
> messed up this all is.
>
> Also relevant to this discussion are KVM's PV MSRs, e.g. MSR_KVM_ASYNC_PF_ACK,
> as KVM rejects attempts to write '0' if the guest doesn't support the MSR, but
> if and only userspace has enabled KVM_CAP_ENFORCE_PV_FEATURE_CPUID.
>
> Coming to the point, this mess is getting too hard to maintain, both from a code
> perspective and "what is KVM's ABI?" perspective.
>
> Rather than play whack-a-mole and inevitably end up with bugs and/or inconsistencies,
> what if we (a) return KVM_MSR_RET_INVALID when an MSR access is denied based on
> guest CPUID,

Can we define a new return value KVM_MSR_RET_REJECTED for this case in order to tell it from KVM_MSR_RET_INVALID which means the msr index doesn't exit?
> (b) wrap userspace MSR accesses at the very top level and convert
> KVM_MSR_RET_INVALID to "success" when KVM reported the MSR as savable and userspace
> is reading or writing '0',

Yes, this can limit the change on KVM side.

> and (c) drop all of the host_initiated checks that
> exist purely to exempt userspace access from guest CPUID checks.
>
> The only possible hiccup I can think of is that this could subtly break userspace
> that is setting CPUID _after_ MSRs, but my understanding is that we've agreed to
> draw a line and say that that's unsupported.

Yeah,  it would mess up things.

> And I think it's low risk, because
> I don't see how code like this:
>
> 	case MSR_TSC_AUX:
> 		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
> 			return 1;
>
> 		if (!host_initiated &&
> 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> 			return 1;
>
> 		if (guest_cpuid_is_intel(vcpu) && (data >> 32) != 0)
> 			return 1;
>
> can possibly work if userspace sets MSRs first.  The RDTSCP/RDPID checks are
> exempt, but the vendor in guest CPUID would be '0', not Intel's magic string,
> and so setting MSRs before CPUID would fail, at least if the target vCPU model
> is Intel.
>
> P.S. I also want to rename KVM_MSR_RET_INVALID => KVM_MSR_RET_UNSUPPORTED, because
> I can never remember that "invalid" doesn't mean the value was invalid, it means
> the MSR index was invalid.

So do I :-)

>
> It'll take a few patches, but I believe we can end up with something like this:
>
> static bool kvm_is_msr_to_save(u32 msr_index)
> {
> 	unsigned int i;
>
> 	for (i = 0; i < num_msrs_to_save; i++) {
> 		if (msrs_to_save[i] == msr_index)
> 			return true;
> 	}

Should we also check emulated_msrs list here since KVM_GET_MSR_INDEX_LIST exposes it too?

>
> 	return false;
> }
> typedef int (*msr_uaccess_t)(struct kvm_vcpu *vcpu, u32 index, u64 *data,
> 			     bool host_initiated);
>
> static __always_inline int kvm_do_msr_uaccess(struct kvm_vcpu *vcpu, u32 msr,
> 					      u64 *data, bool host_initiated,
> 					      enum kvm_msr_access rw,
> 					      msr_uaccess_t msr_uaccess_fn)
> {
> 	const char *op = rw == MSR_TYPE_W ? "wrmsr" : "rdmsr";
> 	int ret;
>
> 	BUILD_BUG_ON(rw != MSR_TYPE_R && rw != MSR_TYPE_W);
>
> 	/*
> 	 * Zero the data on read failures to avoid leaking stack data to the
> 	 * guest and/or userspace, e.g. if the failure is ignored below.
> 	 */
> 	ret = msr_uaccess_fn(vcpu, msr, data, host_initiated);
> 	if (ret && rw == MSR_TYPE_R)
> 		*data = 0;
>
> 	if (ret != KVM_MSR_RET_UNSUPPORTED)
> 		return ret;
>
> 	/*
> 	 * Userspace is allowed to read MSRs, and write '0' to MSRs, that KVM
> 	 * reports as to-be-saved, even if an MSRs isn't fully supported.
> 	 * Simply check that @data is '0', which covers both the write '0' case
> 	 * and all reads (in which case @data is zeroed on failure; see above).
> 	 */
> 	if (kvm_is_msr_to_save(msr) && !*data)
> 		return 0;
>
> 	if (!ignore_msrs) {
> 		kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
> 				      op, msr, *data);
> 		return ret;
> 	}
>
> 	if (report_ignored_msrs)
> 		kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n", op, msr, *data);
> 	
> 	return 0;
> }

The handling flow looks good to me. Thanks a lot!



