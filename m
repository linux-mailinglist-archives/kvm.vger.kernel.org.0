Return-Path: <kvm+bounces-3064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F01A3800427
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 07:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DDA8281667
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 06:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78FFB11712;
	Fri,  1 Dec 2023 06:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bYFMmRsZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB1F10FD;
	Thu, 30 Nov 2023 22:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701413481; x=1732949481;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y1V3H5MFgEZbNAXCEKld1VULE+2eqeJVuEXiHTZDs2E=;
  b=bYFMmRsZmIOgaS2C5AQpO8qTZfyEdWNbzPUwpPEkpJtb5hMLrPZ272Lf
   AbAhFCdRBgeRwl9+16Iu1hxdrwOBaMjkbihuq5aFb86Eb1ktOfzy82JmN
   X3V/IfRDRBaGxZFQbC49q+TPi3EB6+W1yuoQjKUm1xDLjK2eoyUKfgu0K
   nnJr4eqwdR9TWMWdECzVyxwUYXiKsnHhHocq/xvhukufLWh8sh1ZxHnVL
   rqwBmWf+o/gRPNKD7aZVb866/SxAE02MeIec7xGSMABjQA/7nY80Wn4+N
   Z/Vr2+LD78eggpR36VWhpwUjGf5uCk0ppu6NHGYkmZGHcIEmxDXCNglNX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="12158149"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="12158149"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 22:51:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="11050676"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 22:51:20 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 22:51:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 22:51:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 22:51:18 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 22:51:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2J8CHmGf5XPSDqbvtB6JoLNGb+5x/XQG7jXDpEhXdU4tu0DpSTTk8StfMCg08bp0tzvEvAwMA0fCQhnqXMch5G+9OtcJ8y2oDj7jTbsSiacgOBpTTg60YG7ChpWBTsNIJ2JJDAs4rEAbp/BnEwUAjYDOe6JnwlmitIB1MgQw2Mb6Bl6mg7jpxJ9A1tooAuA9HCik3L/Y1jVdemFI/a9mWEIv77HP83AaHVkDeEhblfyLAavwKlPDGO7cQmDWFY4/Kot3VTNomlfBjjMXgA98a+REqqdL652Fx6WnTHiOXFpf5FVEcD+3DhTHOF5JopWOZ0UFj8Y+UqjljZKwkZ6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRs0vPXmflPwSzmQGa0Wu1iqsk8+l4/Ed5kA0b7xHTc=;
 b=dyrpM7jqYK7RP+9T2MFp++q1ZU8JQss4eevGRi4ckvSVTGmVE8zKCQWjlMCfDkYtRrQpA0HTxkpHqf4zFbuL7s+Ia8aJNa5NHKm/8OWrLfnmxHo1MccKeU4C6I1motvMLaHfg7dHkpt4uVPWF3GOJGrS74ZGzoDm0f8+2PLLiWL1vvNFH3BQDQLQMfGdNHokDJi6wCACG78SgTxnBVdPBArmI4uNWE8oElgWZ6CFJZW6vkoaGrKfWeA0QMEWwwlaI7gP87luWrF8Eyl+s96/lrVHLCLqTrAtN46s+1/wuSWvFhbqdHHwY0WPoq3ZA1yK/KEH5e0XbSXc7Y/B0k6sCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB8445.namprd11.prod.outlook.com (2603:10b6:806:3a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Fri, 1 Dec
 2023 06:51:16 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 06:51:16 +0000
Message-ID: <cdf53e44-62d0-452d-9c06-5c2d2ce3ce66@intel.com>
Date: Fri, 1 Dec 2023 14:51:06 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-3-weijiang.yang@intel.com>
 <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG3P274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::33)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB8445:EE_
X-MS-Office365-Filtering-Correlation-Id: d81c8044-ba8b-4a41-f2de-08dbf239ea29
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1E1iwbSV/0DkVvmwF8W/1qEmCPmmM46OOINP3ZfV3ZhCKgDzvHs2pIBfO+5YlBbZMt1ZP19VEVyMksPKTIyuI/pnZmX23uBy+6JAEZ758ZfspLAVCRDY/dd9kdw7VTv3xOdBB+6tvNrI8H91mT+uTCF8tA2e5lji3MtpiTCvp5bnFCNOr/2HzyHH99nPTnK41rSjQCPQu2Kq7WedpaeGQ5UgVZgnmxrHBVCgORQS4HKtRVj5vgD1OyywBDN73uayKG6VvHWTS05YiBJN6kDjDFBzPD2sspO5rKpyX12En1V5tA02gvrcYOZt03WQ37d4GKsOPsjD0DAWTHt4V7W50b/2pQEP2pgjFoqH/DfvcVPeZANI6eMvwBtZnknZJEhL9kk5lVWpqqpHcCFlN/cY/RCddRfAiHDFJKYg3LYCMXXSeSBAgh9Jr1le4VzDB38CVJDqmWvS82UIFspwnDzI++3SR6fQPKb7EXnjpPqElVjMirEyqP8RLxt0mMmfHOiugknXUpvlyuY1g8cjrYGY3AJ/nngY2ecPfaDR8qDx+P5Wp2p/pwF1e/uuA/4lj0cYcJWjLQl6iFlyU2Tg+qB0GGlUwEGWLKC+KF2Lth1PJPojG9PRWpVrRlxKNu7k0Jcz2RC3Z4kMYmbQMtHjlN7Lgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(83380400001)(2616005)(26005)(8936002)(66946007)(41300700001)(66476007)(6486002)(86362001)(31696002)(4001150100001)(2906002)(8676002)(6916009)(4326008)(966005)(5660300002)(6506007)(53546011)(6512007)(478600001)(66556008)(6666004)(82960400001)(36756003)(316002)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUtUMXRYZzk5cTJudnRMbjFQSnVVdktBUXN3M0VxRlFiWWtITVdoVXpLOFR2?=
 =?utf-8?B?ZENKanczTTNlMll4UW1GYWNmMHllWnQ3ek5xbXVMaWRwQ05tckM1VHlFV3lo?=
 =?utf-8?B?a2ZONmN1REgvVHd6a01OVzl0b1ZhUlN3ZHR0ZndCT2poMVhsU0FmTStNakNW?=
 =?utf-8?B?Z2Y1NjAzK3E2My9XamM3dFVMREpRTjVIalptYkVlTjBLR1JpTVVEVzloeUlz?=
 =?utf-8?B?bmlGOUxIVWJwRVdtbm51YTJDTHRyNHFZWDhjd3c3dE4wcFpWSDZuL0RISCtX?=
 =?utf-8?B?L2ZEUkVXQ3hmcTZiRkpER1J0dWtSSnRLbmhSU1BIOTEzSWtZdERWU2lUQW9n?=
 =?utf-8?B?NkZvdlZaRERFZGJORXAwMXdyMDc4UEoyZWI2eUxTTGZoUlM5TWh2Y01LKzJY?=
 =?utf-8?B?RjMxcDRUc3dIUVM3TUV3ZTNiUWpQWXNJOVNUbFJBQ21qemlUOVAvUnk5bzRV?=
 =?utf-8?B?VnlDRGtsUy9BSk1sUmljYmM0c25ZWjZwcDF1eE9VYSt4eitxb3MxaUoxK3Jh?=
 =?utf-8?B?RnVvZnRnZlZTb0tjV1ZPYXhhV09XblJ6YXgyUXR3TEpvV3dGeXdFWURRa1F5?=
 =?utf-8?B?YTcyOGx2NHNXODlzZnVVMVUxbGxKa21hcHhQb1RwMUE0clRCalVSdHFuMStm?=
 =?utf-8?B?Vnp5SGplR0ltQ3ZpaTI0YzJFREJCaU5tL0VYL3VvbHlsTTZwQmtOT3ZlZVNI?=
 =?utf-8?B?VUU3V3ZTOVZLWWZyMU83alhEbFVxM0V3RDJIKzFYQmt6cWtoY0VWNkRBK3o3?=
 =?utf-8?B?TkI5dmJrbVhaU2dlbmtKWFVSRTBkeVFNRnA0SGNqWGJNbmVIOERZOFkxMGlU?=
 =?utf-8?B?SE1taDI2cGlOcWVuMk53cFAreHpYcTlRU1ZQTmt6MkxlZHlHN2R2d1RQcXlJ?=
 =?utf-8?B?SWF1SUZpMVFMVDY2TG5rQW05WGZnK09SWkltbVUrYlIwWGNwcTZRVi9kUEdD?=
 =?utf-8?B?Y3JnWXJDT016YWJKU3BWd1BNNms2ME4wdHlSK2RjWVIrQ1hOZG4wbWQ4cTlX?=
 =?utf-8?B?S0V4em5xL0tRWTJkYXQ0eEoyV29LUERaUFNoUXA3MnVDenE4YWRKNUQyMndi?=
 =?utf-8?B?Y09Kd09kZWMycEdsWEJRUFNYK2V0bTRjc0RlSzdwU2ZsbUZOanRNamYzVFhz?=
 =?utf-8?B?UXpxVXNUNVhqUFVNVXVtOXdrSUQveWJEdDNrMm9SRWxoOWlBMnQvQjRIakNW?=
 =?utf-8?B?UTN3M1pqOERSWU9BNkxMNjFwYjE1cjVZZCtKSkYxNzIrek5DL25SNFhuZ2xN?=
 =?utf-8?B?UVgvN2N1UE9xSFJjeEhTNi9qMXVDSW5yMWtsWFlvWXhiWnJweFFVT0wxQmhH?=
 =?utf-8?B?b2dPQVlhMWV0MVpuVXllZXh5TjE3V2V3dFo3VDZaMmFuOGtzbVRKQzBuTkdx?=
 =?utf-8?B?MHM5Vi9oMEo2NVFWZlQyQUdxR0pSZVpYeDhjNWNQTXJ2UTIwU0cxZDluUmZS?=
 =?utf-8?B?Z3E1WTU1S3dLWHB5c0hXeVVhRFkxLzZjU3ZpT0x1MnRSUzlYVGY1Q0pKdGx4?=
 =?utf-8?B?djJEbVVXNnVoZXBGNC84eFJmbzgvNUdEUkJUaUJYMWpydmIrMU1vRWpsNDR5?=
 =?utf-8?B?eG12a0FTcGV0Ym9uVmU1TWVuTmNPalh2MHluS3EzY2s5Z21XYXdPTkREWXd0?=
 =?utf-8?B?WURHTDUzMnptZmhsbmN6eExCVTNlRzBVMGVybUVNM0NYV01yeG4yc1pHK3Bp?=
 =?utf-8?B?UU42RzFTRnVWV0FEcUNiay95VU1VRXpFZFJXUXdJSjN2SjYrekJTaGNTVEVo?=
 =?utf-8?B?ZWFjT1JoS2trNk9IdjA1bWZ1OGZoL2JCdG9xb2NxeHpiUW5IWEo5bG4yNUFs?=
 =?utf-8?B?SjJPdFlQblErb3E0SkhpMmNzT1lzRXNuRW1xSFNKazJkR1I3NEJUSlQxNXhh?=
 =?utf-8?B?Y2ZqUWFSRDZIbEFFSlkzczNQS1dYeURFN1NXeG01a2plSkZlbWNOZlExMDhF?=
 =?utf-8?B?Ylp1bTlCTy92Z21BaHlUUEl0NXRWdFVOMDFjSDg3QnREc2F3b2xmSmlsV1Ix?=
 =?utf-8?B?UkFDQ0JobTRnQzdRZzIyU1hwUHVZYUlPR3RUSW0wMk54THRibll3Tk1ENVBw?=
 =?utf-8?B?ZE1uNm1QVnJ3aytTWWUvU0swRVVwRGl3ODZWMXZxaTBZRFU2dThtTXdqZFNG?=
 =?utf-8?B?UnMrOGxEZC9MZjA3RU51Mm8yR2thVk8wNkJNRUpRR2tCNGpnNjNvM3FpZXBx?=
 =?utf-8?B?N0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d81c8044-ba8b-4a41-f2de-08dbf239ea29
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 06:51:16.0815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4C1Sr6pueQb5WOasQFhPkIK7frevdQUgZQ8zj5mtvvJwpk3WR18BpcTTGCPpwXRd48ft5Ka8idUmuuxbInSXDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8445
X-OriginatorOrg: intel.com

On 12/1/2023 1:26 AM, Maxim Levitsky wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
>> reflect true dependency between CET features and the user xstate bit.
>> Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
>> available.
>>
>> Both user mode shadow stack and indirect branch tracking features depend
>> on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
>> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
>>
>> Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
>> from CET KVM series which synthesizes guest CPUIDs based on userspace
>> settings,in real world the case is rare. In other words, the exitings
>> dependency check is correct when only user mode SHSTK is available.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> ---
>>   arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>> index 73f6bc00d178..6e50a4251e2b 100644
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>>   	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>>   	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>>   	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
>> -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
>>   	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>>   	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>>   };
>> @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>   			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>   	}
>>   
>> +	/*
>> +	 * CET user mode xstate bit has been cleared by above sanity check.
>> +	 * Now pick it up if either SHSTK or IBT is available. Either feature
>> +	 * depends on the xstate bit to save/restore user mode states.
>> +	 */
>> +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
>> +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
>> +
>>   	if (!cpu_feature_enabled(X86_FEATURE_XFD))
>>   		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>   
> I am curious:
>
> Any reason why my review feedback was not applied even though you did agree
> that it is reasonable?

My apology! I changed the patch per you feedback but found XFEATURE_CET_USER didn't
work before sending out v7 version, after a close look at the existing code:

         for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
                 unsigned short cid = xsave_cpuid_features[i];

                 /* Careful: X86_FEATURE_FPU is 0! */
                 if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
                         fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
         }

With removal of XFEATURE_CET_USER entry from xsave_cpuid_features, actually
above check will clear the bit from fpu_kernel_cfg.max_features. So now I need
to add it back conditionally.
Your sample code is more consistent with existing code in style, but I don't want to
hack into the loop and handle XFEATURE_CET_USER specifically.  Just keep the handling
and rewording the comments which is also straightforward.

>
>
> https://lore.kernel.org/lkml/c72dfaac-1622-94cf-a81d-9d7ed81b2f55@intel.com/
>
> Best regards,
> 	Maxim Levitsky
>


