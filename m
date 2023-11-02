Return-Path: <kvm+bounces-361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D59E7DEBD7
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9AD9281A40
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 04:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481D51FA4;
	Thu,  2 Nov 2023 04:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FXdnoizt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594F01FB3
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 04:30:51 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFA718B;
	Wed,  1 Nov 2023 21:30:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sjk+Sp15Vh0ofKPjGsBzncBm/WN7SFXKH9EbmCKOtVfw6Drd5NtJ3jUqKDVuL0bphp5X4dFNqJFLP6WhgZwz7Ua3kqmFRigHGcDlG3Z2nByhNwSn50nKk5Mr5XrETlKl9b1ePKPcawfWujAkHGfHr9/4TFH6F2JXs8S4VfF34WAg6+vFXiiRVAJAkzrpoOx/uH2EJ3+6R4Z4Ed7zaf3RZQfKh1WPD5cLhcgHn4wCRpdnYTJ8FZjX4MoBYZVVwqn8rdpXT9l3DI49R2abSLeiuj+QjZHE6OXv51uNM+70GqcewL4qcq9KSbQ6EBRC4OHqCStxZJSr8ZD0z9XlQNvGwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Hrzo8kc203Sv+OHLRL2+qc7So5Hbia0tz2X+CR+6j4=;
 b=WduRBIGEEcvXXXCy3jdyrw5ygcMDgbo65+UK6/hmsaDUcfaV+GXDffAaq/skjAwgRoHVdbKF/EZA9ORkjobLPvhlYOkQe4EvIPenY24JzAze9PIZg7ksBDLhxm2xfB6bFpKGhxz69w8Zvi7fe76RamlgwN+Sq3pv2hcvhNUaYrFO256s+Mg7E+JOKYHdDZX/9lTriKSSk0TD2XcvLRp+7T0ILLgPbSNjvmVYsC0Mai/EkPfXUlonLKQgNUXZlaXkwTyEqyHBYRd5ypuyl5fS6fe4CgMvtgJqrizBBo2edlwvS68wqtyBM9l+SIf19YSU6tmlVphFynLHcWDo4xnWIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Hrzo8kc203Sv+OHLRL2+qc7So5Hbia0tz2X+CR+6j4=;
 b=FXdnoiztkFOuR7QWyzWyoeeJB/m3lIvj+8eglTVS50q6g/8AFhx9wRaChS/JKdDNQRD1JbKaHzIdHcZftXw8/3/g/CPeUj+xCoXtBGp7y5iHnDUqBaSwXY3/hoGA27eheZcCiWinudLXaTonD+rqLBpMo6oaowxebWZFMqqfwsM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4093.namprd12.prod.outlook.com (2603:10b6:208:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22; Thu, 2 Nov
 2023 04:30:41 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 04:30:41 +0000
Message-ID: <193a0476-042f-4766-9637-5ad25fd6f3e2@amd.com>
Date: Thu, 2 Nov 2023 10:00:30 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 08/14] x86/mm: Add generic guest initialization hook
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-9-nikunj@amd.com>
 <32e898b4-3567-4d4b-9f18-80a20d05db1e@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <32e898b4-3567-4d4b-9f18-80a20d05db1e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0028.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::7) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4093:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab6036f-8b61-431d-a5fb-08dbdb5c78a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q9zRz6m5L2NZ8J5J2yVwNdn7lstd7nWLWdBL9totmH2d/eQ670fv6b4RCZDy8OMLak6NuOMRZNkwYBjd6CFjnvHSinehnTBIhEVEGzFFYg21Rcdn105uJW7GhIhGbyrFCqHUE1KbO6Jwv+ho8GFPyiW/nhhpaCC58Q6OGc5A0crzPoJFdqHs1IL3oFRc8F4KwfZufOjKoLgi53gM+q1UtLEtPa0ji4Cl9U9Mrk1+XFYZl9C5EktB6lq8cweBZqeTabepUgCu08AZOv9rsBQrH0Cr5Avx/rmxxlJd/lkLsFWf6FBXuXPCSoVHrZTI1ATo+/7RFp/svf2HbUuFDMDqHuKh5sSerHEAEXulw7gaBby6JNfllsPvI42nWz0LMGLU23KT5Y34ripZ7lcxLrCwqBNT/s/A9D6HP2w5q/lNvI5a5IgouDpM4ZKBW7Lu74ZMtWIcvcZ5WkuZ8iMsrVaDMsYu1aMyyIB4XTmomyP8sRFtGLlSGeKh/eoEN1JfNdhGPQNnuvB85pCLlCaHcd6B97akhtQHXzJoeqzgBUe9u4QJY+5DVnOqD3xxmGBlWRs5CJCPUWrOXBbc1P/pFUz6khSfLOpuGR74jV1Prhu2p8LLhEEIvU+nA8L8myd0aZyxb0P95G1haalX5d9zzIfNltURYLQf+k5ydS4mtFH67vs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(346002)(376002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(66556008)(41300700001)(7416002)(66946007)(66476007)(316002)(478600001)(4326008)(8676002)(5660300002)(8936002)(3450700001)(26005)(31686004)(6486002)(2906002)(6666004)(6506007)(53546011)(83380400001)(6512007)(2616005)(36756003)(31696002)(38100700002)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTdoS1VIQ0NDajZuUGhwTUNFeXRaZjlMN2plcWJ2MUpFOUk2MGlQYk9hYTQv?=
 =?utf-8?B?bzFjU0hVT2R3MDZFL05XdndlQ1ZiQXBXazlDYUU1eC9qZ1JpNno1OEorUW1R?=
 =?utf-8?B?MjJ6VUllWHZZWWxmRHhzSWh3NnMyR2RWWEZrdWdPc2tuVmE1cnhKSWhvTWxZ?=
 =?utf-8?B?UzlqalJkTFo1N0ozTkc0RUxzRzlwWEJiSVRsZnd3dFAzYzI2Umc0d1hKUnZQ?=
 =?utf-8?B?YVVlOEM5WVdHMTc3NnNMNDNYU0hkVVRpVW1zTHdvanRFeGhYS3R4VHBISlY3?=
 =?utf-8?B?K2c2b2IwYTR5NU02VDNHaStoM3dIZnlzWjR6anR4QlF4blZONHlwdzNiS3p4?=
 =?utf-8?B?ZGZMSDY1Z3Y4MFBKVEpDSS9QaWZaZHBzYmNFVm1MZlBxZUZwSk5MRnl4WnZY?=
 =?utf-8?B?Z0wvemNkM0ZLZWN2L2FoZGZUL3FKdXRxd3BPNkFqeEVVc3NTditVVFRtNnNU?=
 =?utf-8?B?djFGQXJhMGo5TUYxL0U2cmU1M2hFdXQ5RlNBNVhaYWltN1lnYXBXbDdQb0w4?=
 =?utf-8?B?WkhPQ09XVVI4ckJBdURQdzBMb0oxRTV6by96OXNIZUJhR0xDU212a2xFL0hk?=
 =?utf-8?B?ZjZYN0U2bDRGZDBSZDhubnJjT1UwTFhET0htdm1OOWsybUlDTHVHT3RacExn?=
 =?utf-8?B?ZkJZUUdsK0g3Q2N6bnFvUU40RnhkMVVhL2w4ck9uVFkySXVZVGZtdjJFd3I1?=
 =?utf-8?B?UE9jYzQ0VU42U0ltQkV2L2labnh6cnU4Y0xMUWxLOUlwUkFVeWhDL01tUy95?=
 =?utf-8?B?ejdzRHFvVTE2Ly9hME1PZlZBY2RkcG82Um0xUi9tWVEvV1NvZHoxOWZHTk9i?=
 =?utf-8?B?aXZCZHJLZjdYTVhQdk1pWHl5bmVtTjcxcFFzM3BrQXNWRUg5TUlhVWF6Y1hS?=
 =?utf-8?B?MStLNDhaU3pxdGJDYmNCQU1vOSs5RmZyMG9iOW5aVUlnVytUb2NXcjNVdjVN?=
 =?utf-8?B?ZjNBTnZmdkJ0czJ3ZklDVFR6cWRqNmRWbGo3YW9EVUpKNG9LcHZmeG9nYmtj?=
 =?utf-8?B?MWFrM3hiTXJiNU1PZUpUWDhuNkFFRE9yMXpmL3JDbmxUbkk0USs0UDRRSjFQ?=
 =?utf-8?B?MU9pdUFWeW05TkR0UXBmZTVnako2aGNkUU9oRWp4ZWIxKzZJODNnZmxyaVhu?=
 =?utf-8?B?bGlTNnl6MnhXcDZWb2pLQjRBRlJzUFdQMlJsWXlZVmYvWVN2bzJxME5Wa0Y1?=
 =?utf-8?B?QUxFS2t6dWV2UW5IV1psb2wxdm5EeTdiNVFoRExadkNqNTEweDNlK2pITnVT?=
 =?utf-8?B?U0pOY0Q4L3oxZE5KWVl0SEIyT3d6SDFGTmVXZ1lKSytrQnhLMFZoWG9tckNR?=
 =?utf-8?B?T1dIdjB1dEp3V3k5L3ZOR0dHaGtnMCt6aktVMEQ4WTNaTnRxWjY2MVJ4VEJX?=
 =?utf-8?B?OFg4eStFVjV1SW1xMkVUdXl4cjREVHNvTmRLZU5ibUN2b3VJeUFHdzZVZUVk?=
 =?utf-8?B?NStLRk4zZk94K3V0UldNbXpwdzdtVkQ1MmtIYXVLY0tXcFRscXFxZ0t4d0pC?=
 =?utf-8?B?b204U2I0RWdZNm5yKzJyWVFvdEJPTDQyenh4Vnp6M2U2MDBYcEtIc1Z1Vkpi?=
 =?utf-8?B?Nlp5dWFCRWtoMzF1V0N0cUcvUFArSnlRQ0NtbTNVUTd3c1k4RHJaSnpUSkRP?=
 =?utf-8?B?WEllaVh5dmJUUE11OVNEaytxVENidlN6cXJjVUJVNmNUNExzYUgyNTdET0N6?=
 =?utf-8?B?K1E0OFZwQzNzL3hpSDBNSjZadDl6WW1PY2k4SlQ4YjArN0wyVkpOMDZvcGNP?=
 =?utf-8?B?RXpVWnlxT00rWUkrN3FZL1Jqazh3aSt0OWloUjUrbHNEWnczNjNNL25JZTkz?=
 =?utf-8?B?Qi92cXU2ZVF0cUZWRmlTZFBoN05CNXFUZ3hiVWFZcE9qc1l3T1pEYm1nVHVI?=
 =?utf-8?B?M25NZjJaZTdlRVkrTmF3NEM0UFpkMDk1V0VpUjRUeDNielNaVjNIUDcybDUr?=
 =?utf-8?B?bUNZb2lmSURFVnNkNnlJWEdhWmZkeVp3eGpDWHhnc3ltdW81NzY0R2xDdHp1?=
 =?utf-8?B?ZjNSSmxMV3dqRDFCNWRxazBXSzl5ODRraHlWc3RPMGlXRWZHL3U5THpJSkNK?=
 =?utf-8?B?eVdjWHMyVEJ4V2w4MHhWd3VIZlJ3cWVDZFZIcUJzcmpVYjRkS3p5Y2JYTWox?=
 =?utf-8?Q?19JgDofnbN4vm3Ov5PdiFWeZh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab6036f-8b61-431d-a5fb-08dbdb5c78a1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 04:30:41.4065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRbVNgimIS6jdSrJngrFTkb6YLirIlQudFyVyykg0VCSYEfUFKf67lpNNK7Z1iKRcb1xhKJxnFnIGPpyUPyAUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4093

On 10/30/2023 10:53 PM, Dave Hansen wrote:
> On 10/29/23 23:36, Nikunj A Dadhania wrote:
>> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
>> index a37ebd3b4773..a07985a96ca5 100644
>> --- a/arch/x86/kernel/x86_init.c
>> +++ b/arch/x86/kernel/x86_init.c
>> @@ -136,6 +136,7 @@ static bool enc_status_change_finish_noop(unsigned long vaddr, int npages, bool
>>  static bool enc_tlb_flush_required_noop(bool enc) { return false; }
>>  static bool enc_cache_flush_required_noop(void) { return false; }
>>  static bool is_private_mmio_noop(u64 addr) {return false; }
>> +static void enc_init_noop(void) { }
>>  
>>  struct x86_platform_ops x86_platform __ro_after_init = {
>>  	.calibrate_cpu			= native_calibrate_cpu_early,
>> @@ -158,6 +159,7 @@ struct x86_platform_ops x86_platform __ro_after_init = {
>>  		.enc_status_change_finish  = enc_status_change_finish_noop,
>>  		.enc_tlb_flush_required	   = enc_tlb_flush_required_noop,
>>  		.enc_cache_flush_required  = enc_cache_flush_required_noop,
>> +		.enc_init		   = enc_init_noop,
>>  	},
>>  };
>>  
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index 9f27e14e185f..01abecc9a774 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -84,5 +84,8 @@ void __init mem_encrypt_init(void)
>>  	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>>  	swiotlb_update_mem_attributes();
>>  
>> +	if (x86_platform.guest.enc_init)
>> +		x86_platform.guest.enc_init();
>> +
>>  	print_mem_encrypt_feature_info();
>>  }
> 
> How does '.enc_init' ever get set to NULL?  Isn't the point of having
> and using a 'noop' function so that you don't have to do NULL checks?

True, I will remove the check.

Regards
Nikunj


