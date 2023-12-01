Return-Path: <kvm+bounces-3141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 932AE800FD6
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:15:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49920281C09
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889AA4C60C;
	Fri,  1 Dec 2023 16:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WihU1HS4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB0110E4;
	Fri,  1 Dec 2023 08:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701447339; x=1732983339;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gcXCHHlE7Hqj+vLFvBRbo3qqnLusQdqU3MXRiklmMWA=;
  b=WihU1HS4wC1uvbObMoUXgKC2rFTSXIzRo+BAQFOElnkQ0m5LbcpK7xnc
   pjYhgiOWUyI/jCfHeW0N5nSgJuqy1yQDv3JnqJJPxS6B2lCsjOygHRKO3
   9gGFBkLT98Oe0bam7UcESMBaouq0/7nXbk/keUAliVsx155wB3JPqKrrJ
   z06Ht9J6KNTSjMFjv6gEtqj5FjTOV4dA2w/W1XVZadhK937m9jCMiZVPh
   dprwTZtvb4pAFFyes7PBAc1kflSWf001RpxWPsOf36jYT0m+6cpFz/DzD
   xj8vC/0KvKcNZeCZR2fXtXvxVNA1TEVgFPasIaqn+lTlBjmzhHydLBMri
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="373698749"
X-IronPort-AV: E=Sophos;i="6.04,242,1695711600"; 
   d="scan'208";a="373698749"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 08:15:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="887701383"
X-IronPort-AV: E=Sophos;i="6.04,242,1695711600"; 
   d="scan'208";a="887701383"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Dec 2023 08:15:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 08:15:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 1 Dec 2023 08:15:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 1 Dec 2023 08:15:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRp2Hrkylk5AjqwiAwHKAZEgwmCmZinRf65/FDtofpz0vnGHTstXQlxxlrlFSbch96AFEJZt+sHgml0IwC0zfq2GGpixpF87C2i7P44rkr6OKuA+329pGuU2Frx46fTlnZnSi2rNL5jDATIcOfJO5HFx3ePhsVk9gXM970nR7ZWcD1ITKnYdZQlxcHQcSOAhn0LccaKd2FPjKm5RxntUy6LNNJ2bAlixo4FUanoploashJP6usj99y8oGQcfICa7kCzwXXzxFXJbAOXH/gWRKiHm8+dr7RqE8eflCqmhhsful6fJWqFYx7mZ4Fz0sMAyCIodgoGttnTwbrVfet0i4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5uFyAIObr5QO3o73WmsefFT1MWDPR2WVjvxHWz5wHQ=;
 b=ilzXqeK7BaRrTZcmFW8aCNsv0s2gobpzxwZ8WptzHuQeDSYX2/bUGtr6Be0nb4Ba38dyDG0XSJlDCxnn0btOh+KAKS4zr45SWWMIRYn31gnml6Alrcu1nHFFZgJEcGfyqggcpvxsDiju5aQAXCETBPnfgmyuHsPUL8STL3/d6wp/3j2/UVGW3HSXZen2rnWrxjZcnwrASBXMPKwBNlJWHC7iu7qiC1V6z1JHPJNTRGox+oRdF3+47gJpT/g+/okxdFQ3BtW/uewELN3JTS77rfVp2Xka7znsShJIjemqx0omkPNR3oxAvxPvkjZJwtOlduxdsSj4XSHFRY0ZseI4Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB8284.namprd11.prod.outlook.com (2603:10b6:806:268::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 16:15:29 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 16:15:29 +0000
Message-ID: <8b68d17c-9b65-4d01-8d3d-fccdb50306ac@intel.com>
Date: Sat, 2 Dec 2023 00:15:19 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 24/26] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<linux-kernel@vger.kernel.org>, <peterz@infradead.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <john.allen@amd.com>, <kvm@vger.kernel.org>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-25-weijiang.yang@intel.com>
 <ad3156de93a31449e1e88c52169a08cd6fc7edb1.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ad3156de93a31449e1e88c52169a08cd6fc7edb1.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB8284:EE_
X-MS-Office365-Filtering-Correlation-Id: 160610b3-a98a-4494-e91d-08dbf288bc4e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /6YsguzOcD9BEXFh8LAVIP7bfISao/9Im8MLHYmoqhi8Bb46BuDvQU0/1OrIcfahe86xZWYKyGzPU21UQU6dpyfd/Hmugt3ftQeeFDh9ccssAEzGKATF2e0peyEuXnokbh5V9f82eh3awPyYX0rdfd3oQGaeGymmqqBEIUNzUZ0AYcDGg+2YeEM+N5MvxGtDRkVYL703MMQUmBayCGo8oM4G1E9ZbVQzP7f1wjYCdb90vPkXFH4dR7euWepZOksJU3zpCG2dTi3PxHDpfHXpaOIg1DeIOgS+q+lUWkY4s8BAbOMIw2sE/OWse/PTeG9abMKQ28onu9WnqtH9gQACtdjJHaZfL4kbJRR8qqs1UVB8SJv+29yC0Xu7465JhVpmuz967EziiPhOBTWCUjZ141qXBGEaszGQObzLc7nXcIMK7hO9e9X5C3eJdSFe9LO6xe8cd1W2VjLsJI8LfvSwrLQzl9IjoQ+yHDeGQOz32LpD6LCvfwAK1oO+QJax2j1+i3nX7XwkGTP0DRWJ9Cjnz+RSGzyhk8SnUmZcgCKtMDtTG7ESCfeqvNl6L6jZ+/MetzTjLvjnfVvZaasHkq/ief39BhYiTdT/G8YkO1VJB0E1mks4iZHYBLtcVXzgkF5N0nROJr1HBRs1IBQVNwPj3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(376002)(366004)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(26005)(31686004)(82960400001)(38100700002)(5660300002)(2906002)(53546011)(83380400001)(6666004)(6506007)(6512007)(2616005)(478600001)(316002)(66556008)(66476007)(6486002)(66946007)(36756003)(41300700001)(6916009)(86362001)(8936002)(31696002)(4326008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WENmMU5RbllpUnEydTlmb0hyVUN4UHBYK0IzQnNzNk5uaWRPbFVGdFJ4Vmwx?=
 =?utf-8?B?dlVERVM2Uk50OXM5NDB6N2pjak5CY1JMS2hPLzlVdE1xVkUyN0dOZWZVdEpa?=
 =?utf-8?B?aktvVWxoQzNKMTROTHFFWUhTaW12MEh4UTVhY2J0M3pGWlpuZkFCWEV1YnNs?=
 =?utf-8?B?M0pLSHREcnRRUkxnVVZ6WURDRkU3cUdjQlNjSHJ6TExLTnQwa2FTeGljcHRm?=
 =?utf-8?B?NDl0NHp3ZHA1QVRaQzNWKzNYYzR4N1JRNjFVZTZkbVZZcWxKY25qbzJwa3RC?=
 =?utf-8?B?eUVYNEM1WGovbGZPNFFENXZiUUdkK2hoOEs2QmRmRmM4c3cxNmEzRGdheHlU?=
 =?utf-8?B?UFFhUFhVNXdqWkNMRVN4elo0MVRJaXBJZm5LMCt4OE9EV20yc0xrNVZPaVd1?=
 =?utf-8?B?enhZSy9GSmt4YnphRW42dy84OTgyekJuUjM0VUplTkxISW96VEVYRFdOSXZi?=
 =?utf-8?B?MnpxeDViU2RxRHRYN0MrSWlyc1diVGgzQW1hSG13RWZJQTFZU0lPYzNoNUdi?=
 =?utf-8?B?NG5vS2tqajBsV3dqM0hKWTRNZjluMlhkaHIwYmZ5b1NHQWVpSDJpVDhNbUJl?=
 =?utf-8?B?U0NkdTI0dDYvSG1MUzlLa0lOZHpSdXBzOEU3V0VrY2diaGR0aDcvUDFnRW92?=
 =?utf-8?B?WjhMSGxMcXNoTG02VjE3UDV0MkdyTnB4cEFlRWdzVFNJT2RPNzlqendXZWJD?=
 =?utf-8?B?ZDZ2VE4xdmtZZUZrK2tERXhLdGcrZWU0QzBjNDczS2wrOUlPbmZlRXFJaXBU?=
 =?utf-8?B?YkJQNElDeXRvZHNqL2RGc1JEdGIyM3hiQTY4RTcrTFdsTlFjT1hCSlVwL0hq?=
 =?utf-8?B?NVBJZWZqdGFENWJIWDhZNDBXQnFDSWVvVXBHTnN0aUNkWDY0ZkJtRE14Kzk1?=
 =?utf-8?B?RVRhT01laWtBQVZsdXRpTzlQWlVCb0VaeE1GSlN4Y3FkbmpYdElNcEEyVUtr?=
 =?utf-8?B?UlRyUXVTUHRzYjc4VW0rUWVYNXRydzhSamtiaHlDdVQxRWs0cmNzUUx4aHlX?=
 =?utf-8?B?Vkk5RW1jZmRDZWV3UUlVbzdzcGNTcXBNY1RyL0R4UjhSdGhiT3plK3JuUXpo?=
 =?utf-8?B?UjBrWEhtYjBuTDdKMEdHU05KMnZrWmRTY00wSms0SFl3cEJLV0cyRE0vTVJT?=
 =?utf-8?B?NHBWWm5PeC9vS1EySzM5NzJGNG9RdDErK0VtSkE0MGw5ZjYzN2RmL1diUEYv?=
 =?utf-8?B?dmlBSStPMFphdVNsbnhoeWNkeFhGdGM1VU9wRHBMZ0Z0QTV6aHBBdnlIaGdC?=
 =?utf-8?B?alBBRzRSMGR0eTB2QXc1Zm5JSCtPTXhZNk9uc25XVGtLYUtxTzU3QnpRbUpm?=
 =?utf-8?B?Sk15dDlNNnJ4TnhCYVJmeGZqRnYwQk9VRVlYUlVVNmRQSzhQczBpci9JM0p5?=
 =?utf-8?B?SVBJSWJUT21qVVo4NUY4MVNYZmU5QXMzcElkaDNRYndFaGJyckp0cWEvaWg0?=
 =?utf-8?B?QnhOTWNEK29hSmxlSW9EMnU2RkptTXVxYmdzWEZ0MFFYLzJ2M0RNRi9BMkFz?=
 =?utf-8?B?elhucTd0WUl4bWVPWXhZSXdseUUvaWtud2tpNXFORUorMlFOb1NkMHlWU3Zu?=
 =?utf-8?B?dFZJdjJwbDlMbmRRaXdEUlJwc3o0Ry82bDBpM1NTUVFuRmJlQlMyTC9EL2tO?=
 =?utf-8?B?S0pmZ1VCTnBTNjc0b2cyT3dPODhhM1o3KzA1aHNKNXdMbjBwME1MeVc1WStY?=
 =?utf-8?B?WjREK2hHQWNkdFcvY2ZvYjI2VC9yK1BpaVYzYjJ6TjlmMTZGaUxacWRyRWxk?=
 =?utf-8?B?OWduSHVXdENDZVozRXNKRHpsYzhzZFNFSVhYMWFTNGUxa2NRMERBMXFFV2hh?=
 =?utf-8?B?czJXbDhVejNoQlJuVVpEaUxDeDBMNE1SYnBKY0NvZjlkN1J1alFnblU2ei9x?=
 =?utf-8?B?VU9EeC9HendtRTIrSGNFaUhTdlhxYm9PRko4QnhSK25oakc3LzQwTHdRMjhh?=
 =?utf-8?B?dndYcGVNZWtRamFIaVh4dzNrUVM2akRxTmZVeCttOFM0VjlTVyt1cjRURkVN?=
 =?utf-8?B?dU9vVzNnR29MOEdZeDgxdG9iU2ZHSFNaN0NRUW9CYWFwS2Y0enFiRXhIRnh4?=
 =?utf-8?B?RFFaa040T3p2M3Y2SnArS3FvK053VU5UQWM1cHIrT3hBKzRuN3lYK09NNHhZ?=
 =?utf-8?B?VVpydXhuOVhTdXRNRTUwTWV5RjhsbTdwOTdsNDlqdktKQUlFWmhobHJWdkcy?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 160610b3-a98a-4494-e91d-08dbf288bc4e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 16:15:29.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jS5NpyzvQx6USy50jPpyiF814XHFHUogswbP6W4OtmSDPVmVwKIbiF4ZexufU039r0eMNnMH21zHmE/sOwXuJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8284
X-OriginatorOrg: intel.com

On 12/1/2023 1:46 AM, Maxim Levitsky wrote:

[...]

>>   
>> +static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
>> +{
>> +	return	((u64)vmcs_config.basic_cap << 32) &
>> +		 VMX_BASIC_NO_HW_ERROR_CODE_CC;
>> +}
> I still think that we should add a comment explaining why this check is needed,
> as I said in the previous review.

OK, I'll add some comments above the function. Thanks!

>> +
>>   static inline bool cpu_has_virtual_nmis(void)
>>   {
>>   	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c658f2f230df..a1aae8709939 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2614,6 +2614,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
>>   		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
>>   		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
>> +		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
>>   	};
>>   
>>   	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
>> @@ -4935,6 +4936,15 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   
>>   	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
>>   
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>> +		vmcs_writel(GUEST_SSP, 0);
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
>> +	    kvm_cpu_cap_has(X86_FEATURE_IBT))
>> +		vmcs_writel(GUEST_S_CET, 0);
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>> +	    IS_ENABLED(CONFIG_X86_64))
>> +		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
> Looks reasonable now.
>> +
>>   	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>>   
>>   	vpid_sync_context(vmx->vpid);
>> @@ -6354,6 +6364,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>>   	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
>>   		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
>>   
>> +	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE) {
>> +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
>> +		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
>> +		pr_err("INTR SSP TABLE = 0x%016lx\n",
>> +		       vmcs_readl(GUEST_INTR_SSP_TABLE));
>> +	}
>>   	pr_err("*** Host State ***\n");
>>   	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
>>   	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
>> @@ -6431,6 +6447,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>>   	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
>>   		pr_err("Virtual processor ID = 0x%04x\n",
>>   		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
>> +	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE) {
>> +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
>> +		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
>> +		pr_err("INTR SSP TABLE = 0x%016lx\n",
>> +		       vmcs_readl(HOST_INTR_SSP_TABLE));
>> +	}
>>   }
>>   
>>   /*
>> @@ -7964,7 +7986,6 @@ static __init void vmx_set_cpu_caps(void)
>>   		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>>   
>>   	/* CPUID 0xD.1 */
>> -	kvm_caps.supported_xss = 0;
>>   	if (!cpu_has_vmx_xsaves())
>>   		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
>>   
>> @@ -7976,6 +7997,12 @@ static __init void vmx_set_cpu_caps(void)
>>   
>>   	if (cpu_has_vmx_waitpkg())
>>   		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
>> +
>> +	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
>> +	    !cpu_has_vmx_basic_no_hw_errcode()) {
>> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>> +	}
> My review feedback from previous version still applies here, I don't have an
> idea why this was not addressed....
>
> "I think that here we also need to clear kvm_caps.supported_xss,
> or even better, lets set the CET bits in kvm_caps.supported_xss only
> once CET is fully enabled (both this check and check in __kvm_x86_vendor_init pass)."

Ah, previously I had a helper to check whether CET bits were enabled in kvm_caps.supported_xss,
so need to set the bits earlier before vmx's hardware_setup.  I still want to keep the code as-is
in case other features need to check the their related bits set before configure something in
vmx hardware_setup.

> In addition to that I just checked and unless I am mistaken:
>
> vmx_set_cpu_caps() is called from vmx's hardware_setup(), which is called
> from __kvm_x86_vendor_init.
>
> After this call, __kvm_x86_vendor_init does clear kvm_caps.supported_xss,
> but doesn't do this if the above code cleared X86_FEATURE_SHSTK/X86_FEATURE_IBT.
>
Yeah, I checked the history, the similar logic was there until v6, I can pick it up, thanks!

>>   }
>>   
>>   static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index c2130d2c8e24..fb72819fbb41 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -480,7 +480,8 @@ static inline u8 vmx_get_rvi(void)
>>   	 VM_ENTRY_LOAD_IA32_EFER |					\
>>   	 VM_ENTRY_LOAD_BNDCFGS |					\
>>   	 VM_ENTRY_PT_CONCEAL_PIP |					\
>> -	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
>> +	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
>> +	 VM_ENTRY_LOAD_CET_STATE)
>>   
>>   #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
>>   	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
>> @@ -502,7 +503,8 @@ static inline u8 vmx_get_rvi(void)
>>   	       VM_EXIT_LOAD_IA32_EFER |					\
>>   	       VM_EXIT_CLEAR_BNDCFGS |					\
>>   	       VM_EXIT_PT_CONCEAL_PIP |					\
>> -	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
>> +	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
>> +	       VM_EXIT_LOAD_CET_STATE)
>>   
>>   #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
>>   	(PIN_BASED_EXT_INTR_MASK |					\
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c6b57ede0f57..2bcf3c7923bf 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -231,7 +231,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>>   
>> -#define KVM_SUPPORTED_XSS     0
>> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
>> +				 XFEATURE_MASK_CET_KERNEL)
>>   
>>   u64 __read_mostly host_efer;
>>   EXPORT_SYMBOL_GPL(host_efer);
>> @@ -9854,6 +9855,15 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>>   		kvm_caps.supported_xss = 0;
>>   
>> +	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
>> +	     XFEATURE_MASK_CET_KERNEL)) !=
>> +	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
>> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>> +		kvm_caps.supported_xss &= ~XFEATURE_CET_USER;
>> +		kvm_caps.supported_xss &= ~XFEATURE_CET_KERNEL;
>> +	}
>> +
>>   #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
>>   	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
>>   #undef __kvm_cpu_cap_has
>> @@ -12319,7 +12329,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>   
>>   static inline bool is_xstate_reset_needed(void)
>>   {
>> -	return kvm_cpu_cap_has(X86_FEATURE_MPX);
>> +	return kvm_cpu_cap_has(X86_FEATURE_MPX) ||
>> +	       kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
>> +	       kvm_cpu_cap_has(X86_FEATURE_IBT);
>>   }
>>   
>>   void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> @@ -12396,6 +12408,16 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   						       XFEATURE_BNDCSR);
>>   		}
>>   
>> +		if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>> +			fpstate_clear_xstate_component(fpstate,
>> +						       XFEATURE_CET_USER);
>> +			fpstate_clear_xstate_component(fpstate,
>> +						       XFEATURE_CET_KERNEL);
>> +		} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>> +			fpstate_clear_xstate_component(fpstate,
>> +						       XFEATURE_CET_USER);
>> +		}
>> +
>>   		if (init_event)
>>   			kvm_load_guest_fpu(vcpu);
>>   	}
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index d9cc352cf421..dc79dcd733ac 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -531,6 +531,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>>   		__reserved_bits |= X86_CR4_VMXE;        \
>>   	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>>   		__reserved_bits |= X86_CR4_PCIDE;       \
>> +	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
>> +	    !__cpu_has(__c, X86_FEATURE_IBT))           \
>> +		__reserved_bits |= X86_CR4_CET;         \
>>   	__reserved_bits;                                \
>>   })
>>   
>
> Best regards,
> 	Maxim Levitsky
>
>
>


