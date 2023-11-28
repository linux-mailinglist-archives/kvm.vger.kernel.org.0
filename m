Return-Path: <kvm+bounces-2584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0974F7FB37B
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 09:02:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4B0B281EAA
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 966D315E94;
	Tue, 28 Nov 2023 08:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wfucxr+H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF3BD5A;
	Tue, 28 Nov 2023 00:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701158507; x=1732694507;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=unlL4HCdsrXqD5j68NEwcEQlb6JLZheBZqsZMV1bMyY=;
  b=Wfucxr+H+1f5A4rfreR66svxVYyyYSOJMmaJgZic4ngjSqQxvC3LIxwl
   In/KB4RfmS97O7bwT0ciWt1Tr/LwwinqCYcgIQIsK5h9bU7iVk53xAp0W
   HKsnc2iJlXu80fTvxo+p2q8E5C74a1NHG+Pjeu/QCHKkWtaTqbaeqQYJp
   y5Eg6jGPY3iSjMt4rCQ9ardmyfc5IBp5xxqqjRFcwKVztnMcNt76avzIn
   s63wc05CZFDehqSpcImaBKe+RAMNlFT/jbBNUrw6CpcsiGMAlTbT3sOyi
   s5t7FXBfsnuSHXCJGkGOkUmTmvI965PMDF8afu6YMHj1D5HGSy8uP5lrH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="457203913"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="457203913"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 00:00:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="797507237"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="797507237"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 00:00:24 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 00:00:23 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 00:00:23 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 00:00:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgQAl4yjSh55r4i0U7xmQ9NxggEkwnV7QkHp/9MwE7LZv5F9BV5sbnO4NZA16tcIDSc2pCPR5mvNqmu994k2eCQGqUMO9szsShco3ifjEiN8EWWAX64WhmRWakVlhQFyybktzB7pp3abTQoxKTpiV5/XBL/P7vMn5lIUwltxZXSMQlFY9K8T5M0Khwmr+qYq2Uxrfc8J9UHOOexS0njC0Htzq17+dZeBCXuK8G5dabFV8fFcL6/ciSU7/Z2xCO69TwdWRXsJbj8Bc/CFUx8USpaHb28WZcfr8/1RQXD+oZMdbiYzHI/9Z9tkhNvPXrGz34zml4Z9bom6YLHPydsELA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZvfftY5rec0KseVZPOQ2f4wt8q8lrp28YSukhWo2Nc=;
 b=VkniotPot+Zx9PtJnUjKvTstvSHlQ3Iuj3zWOfCKlrXPovPYreeCPurX1L0Q9F7KmBURFDdi/SpGbaxBd1W2KQciMcs84UebJ0cizXNNfHXaPqMZZ+BkzQVVce1qEM1J9VCkGblPwsvIXIzsD4ueP7UCu7OEWkzOKZiHUQ3dEuXIMtf7RyXQPzTixXJjfuHwSWxl49bgx3+485XFCK5B4suKxWugTsKsdysIQ2gQEF2NiELKKV3CE4qIjeo4kWRiAxoopXaQUNdzhuRXqHsqQkE701HFL9X40oLA2HUU8/sEJuPnHUL5QD32AGSuCdDiOqBiXSxQUGcOHT0v/NDgNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH3PR11MB7392.namprd11.prod.outlook.com (2603:10b6:610:145::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Tue, 28 Nov
 2023 08:00:14 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 08:00:13 +0000
Message-ID: <2551d35b-e5cf-4a8d-8667-b0f6720408aa@intel.com>
Date: Tue, 28 Nov 2023 16:00:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Content-Language: en-US
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Gao, Chao"
	<chao.gao@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-5-weijiang.yang@intel.com>
 <bbcdb8c0729b6577684f89b180cae2f5ec422bdc.camel@intel.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <bbcdb8c0729b6577684f89b180cae2f5ec422bdc.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:4:197::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH3PR11MB7392:EE_
X-MS-Office365-Filtering-Correlation-Id: bf024115-109c-491a-0ff2-08dbefe80d00
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJEpYamYoSMDz4dKTCPcP5VGuI90y3iLeF7jmdwnOn2nPPaHwXfzjDsVECH9eZfhDHqYKsGaiMe8mq3pVTn+en5dLrHhxaBnTNKTz9GVt+2ZyRNQMd99L/AXDdxv4Axn8GqSnd28m0pV+iFiaskm3IFYLXrJS/uGi3fpF+so29B1rwLk2kO7koK3SMDamAFDYpQmiPIOPtu2LVXZTVZZqmySS+f9DvvxLn90P1tQ7NZanO768kVdv/rEY/+KD6HQBoD2wBB3Th2GB20cpIY4rnUysn9gGEf7CmG+FKQeQTI2RBLL+GnzFp8VGunmoDty53+5jspHEUSV0N80s+KBJ9eYZ3aCQr2NUiCdkang+haxgbwTmCThMgANfZ+Wt08Hyu6OBZfy+jtfGy8cHG3ESG6/iieH07vIKKsMq36oeDOG0zH7kkoLJYpJbiNggpKsO53Us8Q9i+hszX+q4d2EjzVuwQTgU/OR47pdTnaU8sHsP5xn2JOUdu6tij0dZnot7dUEdvlplIJLzhiQq3lkBgdh5e9mbxmZCHNPami1GeoFItgQRTcYmlJzQE1IOEda6LYQFkKyfVKrCf+YE+hWfv0JnMyPf04PfTgbT7bLQhj4jmOhJRsZ0mzDugT5t8LiN9fYxhu+9n+zkjtXjBaVqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(396003)(39860400002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(26005)(6506007)(8676002)(6666004)(6512007)(6862004)(82960400001)(31696002)(8936002)(4326008)(86362001)(6486002)(5660300002)(478600001)(6636002)(316002)(37006003)(66476007)(66946007)(66556008)(53546011)(54906003)(38100700002)(31686004)(41300700001)(2906002)(4001150100001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnhEMm1RUFc5N2cyYXAvUkk3U0VrSmg2SE9vR2o4YWxTZXdYTFBITVptcGFz?=
 =?utf-8?B?N1YzcEVOZitKVUluQlVHeW5JSzhyaUE3ZTR6YlI4bHZNV0g4dGdxaDlrVkN6?=
 =?utf-8?B?OFBDZ0g4Z0ZGZ0kzd09VOTk2MXRrY2wxMC9RbzdhWXdTV3gwOFZDZ3VGdUlt?=
 =?utf-8?B?dUJLSFRYcDE5NGZOS2NleURJUm1Gbk9vbUF2UzFsWktUdzFrTk0vYjBuMXJp?=
 =?utf-8?B?NllhOXRiQTFIT2EzbTB0VEN6aUFhNU8xN05KK091OVk1aVVNN053NDhuZElz?=
 =?utf-8?B?UDlDQnhycGtEcjlrOTI1cGRnUzdvOXBTN0FBTVF2RlFrRG1zWEJPeUxoSGp4?=
 =?utf-8?B?VktoQTJoR3RueFhYWloyVm52dXFJRklQMVJJTHQwa01yWFEzcy9GaFRrV0RQ?=
 =?utf-8?B?bER5SytnZ25Yd2JSRm9uRkJuWUxaSmYxWExVOEYwdStWQnBqSzd3UlJXOXJS?=
 =?utf-8?B?WFdoeVJVd3QrOFJ3UjdnK2Y1L0p3YU00MjAzQTNpQSt5b1RxN1pTQlA5akhL?=
 =?utf-8?B?bDI2dEFUL2IxRGU0bjQ5UUI4L0JKZUpnczVIN1JTdFVHcVRRT01QWHNrcVRQ?=
 =?utf-8?B?Q3FyUEtRaXQ1RGtqNUFOYm5nVUVjam1rYkR2U212N1lrL0hHRWdHY2lRaVEr?=
 =?utf-8?B?MjRKVXpDaEpodWV6YURVMmRjZzNWNDJwS3lSMFFHNU95TlowcEFzNDBNeVF0?=
 =?utf-8?B?UDBlMFNMbmV1RDU5MHFBeFlpSG90bnVNSHFJYWJJaTVVcE1TdXp1T0xHamhp?=
 =?utf-8?B?RGdqNGpLOFJpOHZ2OVhBajJFNW12TVFvL2MxS0lQby9DNDRlUkw4a2x5OVFr?=
 =?utf-8?B?RlVQcEhyby9RcnNqMjZoZVN5R1FSMlgrWWl3NEhJbTRqZGhyTVRiZFU1WmRT?=
 =?utf-8?B?cDhOdVo3UzhpVkQ3SGUrUXV6MllzbEZlbVY0OEt1RkJYSkhtYWU4aitEaVFr?=
 =?utf-8?B?aE91REhnV2NGeWNhMk1rVURHMk5OUVRnUzRyYjl3dnJMaDh5eWFrY0dNelJz?=
 =?utf-8?B?ZUVOcHRodERnY0lQMEhiemRpZk5VNGhiTmplUGlmQzNXd0ZJNmVnbXNTZzJT?=
 =?utf-8?B?U1lzd20zenJ1OUVtVk9oSnd0VHZ2RGlNb2x1Q1ZLQnBwdTFEcjJRV1hvaU5U?=
 =?utf-8?B?RWJBR3dNK015RlpUSlJUSkFUcnVLYVI2UlhTMzlrUGRmZ3cyVFBDbmx0cnZ1?=
 =?utf-8?B?ZUhJdlNDSjYyYk9IaW1QUlc0NU1sNnRMWnQyS0IvMG11QndjR1oyUWRtWFZ6?=
 =?utf-8?B?RnEvU3krbkJMUWM1ZVpMR3JTM2ViNGJTNVNPczhKRVIrN3NlS2NxSUUwcTJo?=
 =?utf-8?B?MFg1NWk3cmZ3WldmbmJ0M3FQVTd1RWMrRTl2dUVpcFYwLzdOZ0JEeFNHTjla?=
 =?utf-8?B?Z2tmZzFpcTdiTy85d3czbFA3Vkp3U0NPcm1hai9FeEM1dXBzZkpOc0drN1FT?=
 =?utf-8?B?RTE1MHo4RStWcVRRck1yZUhCVEEwWHRNTUFoc1dDUHJMeTQza3ZISU9IUDBQ?=
 =?utf-8?B?cGJTdm1Xb1k5ZWxUVHZFTTl2dnkvT01JaFF5UjU0QmhoL2h4dnA3cVA2OWhD?=
 =?utf-8?B?ei9RcnBMcnU0Rlc2SjdLeXVSb3pqTmhoV3FPNTJlamIyM1I0bHhQNzcxcjNz?=
 =?utf-8?B?OFFkdzZ6Q3hlQVE0eUlEclhWaHBMOEhrUVNUdnE3a1M2d1dBcTk3RVBNVFZx?=
 =?utf-8?B?dFlJRFZaRCsxZmtjVWd0SkJldHUvV25Yd0RUdDBtbTVOSVRwUUwzeG1GZGVH?=
 =?utf-8?B?N3A4aWFEM3FSNU96cTNqNEh5QTVVeVBTaDY4V0tOUVhqUFI2RnR2MFF5NFlh?=
 =?utf-8?B?dmJheGY5a3JYc2RCZ0J0YkJ6b1R3RW1RUUN2Yk9qTjd1aFpKK1ZlbkJoNGFW?=
 =?utf-8?B?U2Z3c0FQb3Q1cWEwajNBeVN1ZnpTMVBpSXVZWjVuL3BteWJKYytxT2g1S1NG?=
 =?utf-8?B?bnlpMStreFA4VVNzckJvQWhCT2g3UjdEd3BJMUl4SzcvU1VETGlWRXRlTitm?=
 =?utf-8?B?OU95ZFFpNFljNEI1ZnpldHNuTnlSZ0d2VE5EM3BINTExYTRvQmxqMzd1eFZw?=
 =?utf-8?B?K0R1dnlpMlZuOWl3bWc3RVdPOUlkVlFxWS9iUUFzTTlnN1Fzc3lFZFhUdldj?=
 =?utf-8?B?OWdNTTUxNkFLZFk4cS9XT3pzT3E3SFQveHFRT1JLbzF2a0RISmtSbktJYjJM?=
 =?utf-8?B?MkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf024115-109c-491a-0ff2-08dbefe80d00
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 08:00:13.5644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+xI52twWr817KnlqrQ8oNqQ3pphPJGJCF4M+6h8lg8bXodSKjfYmdUmC+Sjo+3H2hfEu/vNC0W8WWuUAeD7RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7392
X-OriginatorOrg: intel.com

On 11/28/2023 9:46 AM, Edgecombe, Rick P wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Define new XFEATURE_MASK_KERNEL_DYNAMIC set including the features
>> can be
>> optionally enabled by kernel components, i.e., the features are
>> required by
>> specific kernel components.
> The above is a bit tough to parse. Does any of this seem clearer?
>
> Define a new XFEATURE_MASK_KERNEL_DYNAMIC mask to specify the features
> that can be optionally enabled by kernel components. This is similar to
> XFEATURE_MASK_KERNEL_DYNAMIC in that it contains optional xfeatures
> that can allows the FPU buffer to be dynamically sized. The difference
> is that the KERNEL variant contains supervisor features and will be
> enabled by kernel components that need them, and not directly by the
> user.

Definitely the wording is much better,  I'll apply it to next version, thanks a lot!

>>   Currently it's used by KVM to configure guest
>> dedicated fpstate for calculating the xfeature and fpstate storage
>> size etc.
>>
>> The kernel dynamic xfeatures now only contain XFEATURE_CET_KERNEL,
>> which is
>> supported by host as they're enabled in xsaves/xrstors operating
>> xfeature set
>> (XCR0 | XSS), but the relevant CPU feature, i.e., supervisor shadow
>> stack, is
>> not enabled in host kernel so it can be omitted for normal fpstate by
>> default.
>>
>> Remove the kernel dynamic feature from
>> fpu_kernel_cfg.default_features so that
>> the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors can
>> be
>> optimized by HW for normal fpstate.
> Thanks for breaking these into small patches.


