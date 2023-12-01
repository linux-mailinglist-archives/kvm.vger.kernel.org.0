Return-Path: <kvm+bounces-3076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 902D480065C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:56:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47F4C281974
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13961CA84;
	Fri,  1 Dec 2023 08:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LPu9C6zw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C2884;
	Fri,  1 Dec 2023 00:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701420979; x=1732956979;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NPKkqjovvT2xaSO8FFU59pZGNKNdLQ7oKHblUEUbUHo=;
  b=LPu9C6zw30kMP/4mokRjUsROdBK6TOlCNj6vC+ublSo0MEEI8+VS1Ga+
   7gu24VPpJbACPfYeu7qNv4UV/Dsejjl1t6iZZnsb7QfPxYgzRLdmaqLz8
   7mnkn7z3TtsPd9/opll6OyluImbMgdcGu1S2e0dF3o8js9Va+N6+p0GwG
   U9axLyrdkTegMHw21ZlJnnW/rFveWKgqztEuASUgG6JhCQvtvpMZ+Kwq/
   TSQSL5ljYD5I7RnmGaSFPEXpmqM6jX/2bQvDrzVIAurcTUGATXyMXgupo
   H1In4asahhRRbJ/0l6uktx+0GrT4njmIeLAqAYHeat/ZpDt1gmcbaVAdN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="390629339"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="390629339"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 00:56:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="769614092"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="769614092"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Dec 2023 00:56:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 00:56:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 1 Dec 2023 00:56:17 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 1 Dec 2023 00:56:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=becm4NKOKf8FHJ5M+shNsv1Hqt4u2PSP8JOFNPm5csD+G8wZ3no5MglHB1UDGsq0JQrUkI5mcyZ2xiYraIqgAJi5vZrC2Pw8cMKiI8Ou86mJBg91PaGAMVavYI9FuGGzBG+xLjy3S+ZBa6qSF+P5v4V6wq+pPq6blgEUavWfjGpbz3MM6sARWU9o4ob3sILybs6FB2y0KAtLlsDzf7iZRqNVkgOYqQxBOcQEaW+pKTBlWs8IjQC630sDaoEI8cTsf+iYCyaIykERUF0hMSsByVhl4PUHnmTSG8dwY8xXS9/I2yuxmSbRWq4Gp/rSIamu6fIBkfZruLvcxqwgsfJyGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/Hn8LxmLqgsiA2Xs46x2mMo2o9Oj9wdxLM234fy8tU=;
 b=OyvbNY8Bo+ZagGkEdRNRJnJJlPepgOAIc91BsCmibaZTxW2fN9udjkC1IBs8OLUsyEr/tn8o0rZCH04CgKSMofrEUg045sTuhnuxJ4lUTPrW+87DEkkaInYPR9UCbHcV7R1IfAQ2QKneFmyDh+eLZid5Pz+Jl1LB51uKwlDElXofzV7d/RrNEP3TzsARR/GhdZLkjNlza6JLIHdkaVOAuh5gP16I8e9bkALKYji/r9TDqQgilFX8HYjCP4S5hodlADPiz41t9s6CzZejAiy4L2sbJ+gi3o4E4tt0iMIpE7bUYQk34/+5JkTmH9qm0N4PMP0aUav+8q5fjVdOn8BrdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB5827.namprd11.prod.outlook.com (2603:10b6:806:236::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Fri, 1 Dec
 2023 08:56:09 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 08:56:08 +0000
Message-ID: <3cfaf679-a739-4e76-937f-a66d03d256a8@intel.com>
Date: Fri, 1 Dec 2023 16:55:58 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 21/26] KVM: x86: Save and reload SSP to/from SMRAM
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <peterz@infradead.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-22-weijiang.yang@intel.com>
 <d2be8a787969b76f71194ce65bd6f35426b60dcc.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <d2be8a787969b76f71194ce65bd6f35426b60dcc.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:196::12) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB5827:EE_
X-MS-Office365-Filtering-Correlation-Id: e19b1fe6-392a-4c41-071d-08dbf24b5b6a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SNm37Q+BYRRHZa87VO+WXZIuGX+QwgJLipiR/beY2n5ldo5zSNN2msEV2k8lYU8U2aOiHPbi/BFAPgJySEBQk0/2A7/BGgmzJf4alo7bKGEDLUDoc/QEl0MUf5MT8kdQHfcnRILRtoEoUs550KgklqbeSKn3Ar27Kpuc/TpLIKFVU+E6cXQuI284Ti/QTKxiVaTIqJII3upC+A6fECbk95wM+7Col31F6Ssa5a2Oa/K50CHou+TRZIQyCCut8DwgPazzeaXcw2OcOaCcCNoe7ijSKTHPzfH87PBB4o0QLBoyKz87QWV46eF0jkjTi3miv4a8YbdfuexgERqkA6ehlNmriE/lSbnbkUMWeeaVivTnQ7tgv7sTnPzDUljpJDdAcRMCJmnvaZSg9e51IvJkDnGEbn/c0RHPUYrHrbH7BqrIsadmOWeBDNbLoJRZ01bZCdu41Cdk6SUzq+vDCqa1x5FBzSCdUAqf0cNnX1n7Qahc7+XlsgLAurO6gKbRltOvIVelLfHtjcbXaRcchUglw9c/ffM6fwqr10+BEkToW4OkDNHvCDCKleA2goK3eW1RTM26Lm65Vem9lqHVIl6uGvMLUk6oca4sCdCjvwfZKS/VctC9uxxZGkZlni2DI7wlYbzH+apHAcPkDvszGbbkhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(39860400002)(376002)(366004)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(82960400001)(38100700002)(31686004)(83380400001)(86362001)(5660300002)(4001150100001)(4326008)(2906002)(8676002)(31696002)(8936002)(66476007)(66556008)(316002)(66946007)(6486002)(6666004)(478600001)(6506007)(53546011)(36756003)(41300700001)(6512007)(2616005)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWxqY2lLR1lablRqb3ByZjFEV2lObHgwSURaVEtTVVBzTllYdVA1Tm5hUGNx?=
 =?utf-8?B?Q2NtWkpHSHNQVklZczNoL2hkTHlQbTdKMC8rYkV0UXFmOXZzaEZtcW1QZnND?=
 =?utf-8?B?MlpoSkc5TUZVWjdjZTB4QWRhOGJTMC82aC9Ec2VmcU1MRWU3czNOZXhDMUdO?=
 =?utf-8?B?TU1zeTNVU1k0K0pLV2pTVmdrOHBpUW1VcFdhd294N0IwOEM2R2VGMWRweTVI?=
 =?utf-8?B?bWFveVdzMVJNby82N0VOL2RmSlhqdmpvcysyZHlkZXl2czVDdm9UWGFtQ09h?=
 =?utf-8?B?bFFvaTgxWGZyOHdWY3VCeVM2RWF3K1Flcmh3cG50N29LU2tCR09XZnJUZUw0?=
 =?utf-8?B?TEQrbWxlclo3TDIzSmwzbitZdVFGV3VrbVJkeHBINUwvbHdNaUNzd215YnRD?=
 =?utf-8?B?VmpkRWo5S1lpWHV4aDJaTmEralQ0VndKMThoZHNXYmlwRFdrMm1wN3I0bVoy?=
 =?utf-8?B?K1ZQTytTMUhkZG1KWHhBS1ZoQnpnNDhBNm1ORXc1bEhUazVxK21hSXlGWkdz?=
 =?utf-8?B?Y0t3Tlp3V01MdE93U2xZOU81N3FzS1QxMHJNbUNnZ2JOcDdHMjEzZnJBblUw?=
 =?utf-8?B?ZUxzempSQms0K3pJZ0o2enRSUExrTGduTHNLTUpOK2tXc2hUbk4vQlh4RDZU?=
 =?utf-8?B?ZWJrUFN1a3crUkc0TmUrZWNUYnpncSsweTYwcXl4ZUdzeHd2a24rVnBhaDk1?=
 =?utf-8?B?NXNZV3RtTDJHd1hISmlVaHZkZk9OMFFjd2xHYnB3U3VEbTB4a2ZLMnExcWIy?=
 =?utf-8?B?KzlwTktTQzhnNkgzclpwa1JwYk1GVHRKc3FiTFk1TGdVTFhZVVUwUlFSWUZM?=
 =?utf-8?B?VzRvdHNuOVFMM3FQOW4zdS8yZ3BnenBaQ2k1ekg1UFMwVS95N1Z5L1EwbDhM?=
 =?utf-8?B?UTAxOWNaWHdiUFpGRmZFbDVhcHUwRTFoa3h3L1pqMHBscitUcmVCT0hkVkFP?=
 =?utf-8?B?cUNpSkY1Vy9BaDRLZ3p1ZHYyWDgwTmkyUW16aWJXRlRlV0ozdUpVMWdSQjNv?=
 =?utf-8?B?eE1LT0pSRjFqQTc3UkJRTWVVZlFVM3pNNnlURkVHRlpEbW1BUTMvNDBrZXRK?=
 =?utf-8?B?UkxWOVJvYkNXQU0wNjdyQjkwR2owSmVwMHBTd0tMdEdKaWVrYk9UdmZoTTg1?=
 =?utf-8?B?aXQweUNZamFPZlcvNmJIVEdmVXlMczN6MGd0NXpjU3ZDd1E4MXlzUk1rOXJ5?=
 =?utf-8?B?RzRGcGZTOHh0eTkxT3pmQWY4RHR4K2hYdzl6OHlQTlFWRGJmMWFRVGduWndX?=
 =?utf-8?B?SVZ2UlBaVVNrbHJnazNYb0hldjd3MkJtUlJMNFp6UVlqUHVCVldLRmxFVlpq?=
 =?utf-8?B?QjM5d1pVNjR3T280Ui9YTm80SnJZdkFGR01TT0UyTkFTUUY5bS81eHkyc0tI?=
 =?utf-8?B?eS9FT2FPSmtnaXlNalIvdlJRanE3WmxjYXZTZnJyaWdyYWVzVzFSZ1VVMEp5?=
 =?utf-8?B?NTk3SkNRUDk4N1JQZ25LTk5YRXNuSzYyRUJDeEU3ZkUxTzNtMjBldEFYbEtw?=
 =?utf-8?B?VkNSMVVsM3VMWFB5RzVxd3RDWEVtT2NkNlJtT05rdHc3bnBwb2k0WnQ5SDhx?=
 =?utf-8?B?YlNuQVhIMVVCMHZXTFVYZTNGNnhRQnhFb3hhb2RzSmwvMjdyT0RCRVBtMHkw?=
 =?utf-8?B?cU1ZQ1NNc0hYd1RGSE1udUdoaVJadGo2ais0eTJ2ejFEZGJHbmlnSWxJWUxL?=
 =?utf-8?B?UVZBRWZXM0I5a0k1ZVBlcVFXd2pyUWp2Slp3N0VEZm9lUDk1ZURXZ2VKNkts?=
 =?utf-8?B?UWl0WDdGZW5jK25aV0VTNXRGVVZ5TGovS29WSWZ6OVpaSDJITFBZcTU0ckZ6?=
 =?utf-8?B?RU5aVU1zYlV6d0hLNkZtVFduakRneTRNY2N0Qk9sQlNMYWxxa005d3lnS0E5?=
 =?utf-8?B?OUxUdnphNVFTOFlQYWFuWDNIcldNTUVnQXhhOXQwRS9iZWcyRUlxeHVRTlBi?=
 =?utf-8?B?ZlRqY2JrRU1MN2hKdElsZmN3cm5NQVBlY0h6NEkrMUFXaHJtRkhBTjV2cE83?=
 =?utf-8?B?b0kzeEdqNXBKNFdxTXdFbDY3cng4N2NpMUZxNFB6N2NIZWtDRW1jTFZlOG1I?=
 =?utf-8?B?ZHcwNENicHgwK1RQSVBWNlhleFlIT2NXanIyazBCVjBVbnJKaHlPWW4xaVBk?=
 =?utf-8?B?djdnQUxlTnpaSXd4eTcwVFRJQTFyRmZLc3pKOENUaDcyRjFSOEpaRWR1Wng1?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e19b1fe6-392a-4c41-071d-08dbf24b5b6a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 08:56:08.5722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwnP2rhOP86jJxNLCyqFDNAu/zJalro6SF31lIx47HFl8Qoi+v+K72FjmgfSPOJ9HZeczPJVReeR2GElLCTtdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5827
X-OriginatorOrg: intel.com

On 12/1/2023 1:42 AM, Maxim Levitsky wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
>> behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
>> at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
>> one of such registers on 64bit Arch, so add the support for SSP.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/smm.c | 8 ++++++++
>>   arch/x86/kvm/smm.h | 2 +-
>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>> index 45c855389ea7..7aac9c54c353 100644
>> --- a/arch/x86/kvm/smm.c
>> +++ b/arch/x86/kvm/smm.c
>> @@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>>   	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>>   
>>   	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>> +
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>> +		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_SSP, &smram->ssp),
>> +			   vcpu->kvm);
>>   }
>>   #endif
>>   
>> @@ -564,6 +568,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>>   	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
>>   	ctxt->interruptibility = (u8)smstate->int_shadow;
>>   
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>> +		KVM_BUG_ON(kvm_msr_write(vcpu, MSR_KVM_SSP, smstate->ssp),
>> +			   vcpu->kvm);
>> +
>>   	return X86EMUL_CONTINUE;
>>   }
>>   #endif
>> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>> index a1cf2ac5bd78..1e2a3e18207f 100644
>> --- a/arch/x86/kvm/smm.h
>> +++ b/arch/x86/kvm/smm.h
>> @@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
>>   	u32 smbase;
>>   	u32 reserved4[5];
>>   
>> -	/* ssp and svm_* fields below are not implemented by KVM */
>>   	u64 ssp;
>> +	/* svm_* fields below are not implemented by KVM */
>>   	u64 svm_guest_pat;
>>   	u64 svm_host_efer;
>>   	u64 svm_host_cr4;
>
> My review feedback from the previous patch series still applies, and I don't
> know why it was not addressed/replied to:
>
> I still think that it is worth it to have a check that CET is not enabled in
> enter_smm_save_state_32 which is called for pure 32 bit guests (guests that don't
> have X86_FEATURE_LM enabled)

I'm not sure whether it's worth doing so for CET on 32-bit guest since you said:
" it lacks several fields because it is no longer maintained ".

I kick the ball to Sean and Paolo to get their voice on this.


