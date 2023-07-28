Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1A57660D7
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 02:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjG1Anr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 20:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjG1Anp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 20:43:45 -0400
Received: from mgamail.intel.com (unknown [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA9D35AF;
        Thu, 27 Jul 2023 17:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690505006; x=1722041006;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YCs7HVvlobpdq+KUXBCboLB5kDdsSorJ2F+cJRZxZ1s=;
  b=I2McGfRcLIjojNg8aB60IQTjDYuMYCs+QHR5Cd5Vvee39Jo5sQgVgSQn
   vyMtavZvMtHMVCgFn1xJa+KNo+r/If9J72FnUEkSW3Fu2FIu91uIP3FIT
   V+Q+WL+cVBL/TrNdXCJL6RQyEIg8zSEIzokdiIxLTL639Yo608AgIpuW/
   zrs7AKuyg4r8Dc7cioMn+0XJXfjcUsfhS7h7eXu7WuyNJtftcRGDFHS2N
   K1kjPaK8TG0U1zYUz2M2VzUCi2ENPBLtmBPZmnaOaRiH4kI01YxGRc5TM
   1s1AHTCTgx1Tn/o7PRnfRWPjwhiqZQSR2z6dmQoXUZsmTD3tjvcBApjUd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="365929151"
X-IronPort-AV: E=Sophos;i="6.01,236,1684825200"; 
   d="scan'208";a="365929151"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 17:43:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="1057914547"
X-IronPort-AV: E=Sophos;i="6.01,236,1684825200"; 
   d="scan'208";a="1057914547"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 27 Jul 2023 17:43:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 17:43:25 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 17:43:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 17:43:24 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 17:43:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdFLHybRMMFddW2/T2ZGjR2yR/hTe8AH6UyGWvSrNjeTvvQMcGGRDxIQm6BOjNspBvuNKaZrHQGmCWblGFWqj6yVnqQM8haNXJknnutmpMwTNyifEcGPsNWIwmwaNz0ZrRTDjHAh77FJMTWexsHrzeKagQOhNPLqQpOJf1qdxUgLRVsmMqM0vgZHDtjWbpoyHUMHojNEJJypTwY8OS2hRSWh17O/e9Kj+G+0wzPTeFOA6j3moy9PKs3Y8odyDzIXWLLE48C7UZnLs4k5FvjuKXFec1Rw5XPfp6X8C8D6pjEyd2TxgaFlWB9ZNQeEspoScCPGoNccvpwCNLaTCTAolg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Bejdg8VnBDI+X+v8VQBjzoX3LJKsIeMwIugZIiFH+Q=;
 b=HjvcMaG6PGTPRb9HmJpo1riUmMVoPrKRLjW6g83aQPwV2jcxeZe963egcRVuley/jwu+ujuofLwXUgAzeg/YXni4Fj8pSucipWTZdJGBA2PAw4EKXI08jSyQwpaLqe3z+Jk+kBCv8ACgF9RacLhdtJQ5O7qWbX7esBv4J8b7DmG9URZ7ClQ98j2L30ftjzolttzZV+eGR58PGTYu7U1Kcez8vMelVdg9U4hXjBYCvL239VH2Jh4Gw70u1/ctfuZvEfppA6rjwoUbaG8F7MJH9Yq3GrzfFH44E6QzUZoEzYBOQqjDj1MEOzptqPajjXCLBWPQDWSZ2zwMD3dVpnENbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7468.namprd11.prod.outlook.com (2603:10b6:806:329::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 00:43:22 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 00:43:22 +0000
Message-ID: <10511c2d-7b64-374d-cd91-ddac2c1a788e@intel.com>
Date:   Fri, 28 Jul 2023 08:43:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 13/20] KVM:VMX: Emulate read and write to CET MSRs
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <pbonzini@redhat.com>,
        <peterz@infradead.org>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rick.p.edgecombe@intel.com>, <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-14-weijiang.yang@intel.com>
 <ZMDT/r4sEfMj5Bmu@chao-email>
 <3d5fdd07-563c-6841-a867-88369c4dbb36@intel.com>
 <ZMH9tIXfPk0dl7ye@chao-email>
 <2801b9d6-4f32-c4b2-ae93-c56ffc2b4621@intel.com>
 <ZMKLRnjCTwqTr/MF@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMKLRnjCTwqTr/MF@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0099.apcprd03.prod.outlook.com
 (2603:1096:4:7c::27) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7468:EE_
X-MS-Office365-Filtering-Correlation-Id: dabe293d-d491-406b-704f-08db8f03a4d9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6RXWczCgHXqqWL0JkH7BRmowhGtWZlZ+lAEwUsQWs7jawnfxkvHqgnYMqxYEC5rHt5uqzRtqleyLJeU0Oyp9m2Tjkn2EbmN+VEbM9ruem46ctDpYVOqj36KTkr43HuKPPtVzZiz3U9FZHhBF+kEG9atmfARcN1pQdWYpk4uaglDk60Bf5cc/ok4/bcl5RAJSmXuWwM2FFS4RFOzQTKA1OKgXwD+6qPYQBAQaDCLXWbYvz6SGkgp91cpdifJI084Ur4++6mECV9KjH0Ll8WRzwLonrt1WCz7v2/Px1L2SqFeJQMU6SJ+Jm/fbltESGGd3UTlEnBcpdkTS8lrAxrg8FNjPsnRSJlzCwaNUPBpYJXHlLVfr7+FivPXkJxfox1P6Cy/S/Ssizl3VimNiNU0A0RwHHGeYZT3CBRUeaLLav1I2Idv9TKvqZ3NVsAdct+kv3auco79Uxvq3RzbktjU7AgofH26/GPMlRc+xDkMUTXvwqXgJ2jnARld/bt1J5Rt91ftZbx+6rIE2tbXWkPHn/6edMMzkwJZdlF7A7pYWI4zwY/NjZhXoSdlD+GoVRdW42Guj2hDoMAyQBmHPK2Fl9QtwNXyLZREOGc27DOhVCOgcjabxdzfq55QUs9kfS/ffd4NFleVVL4R6y5aNlUl/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199021)(2906002)(316002)(8936002)(8676002)(5660300002)(86362001)(41300700001)(36756003)(31696002)(53546011)(6512007)(6506007)(26005)(82960400001)(478600001)(6666004)(6486002)(186003)(31686004)(2616005)(4326008)(38100700002)(6916009)(66476007)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1p3RnNGa1cwbnJXS3BCUnJQRm5xdHlnU0JCN2E2NEVadXRKQlJCNXR4bTZG?=
 =?utf-8?B?MXRGUVJrcjYwdzVuV09rMmlmRkNrMjdmOGpKTnlNV3JONG8vd25IWExVaTIv?=
 =?utf-8?B?enYvRTJPOE9rZytTM0ovRTJIOC9xRVorRC9PK1Bta0NNcFJzc1ZFWHdCa0xR?=
 =?utf-8?B?WFcraFBwUWdXU0lmOThlNVhlODdkN1d5VWxKOHNvd0hJZzBEaVRySkpFK3pV?=
 =?utf-8?B?YkdrRThyeUlJNlNCVjc2U2kvc2c3YWduL0NXSzhiSTJuanh2TkdLUzZZU0JR?=
 =?utf-8?B?ajVBbUMrcVpaSmVsMVVBMU84eFlyRWxvSlZ3TzB6QXd5QVd5ZGdtYVdnVnkr?=
 =?utf-8?B?M0FQbll1dkxkVWJHL1l5aWcxN1E4OWRqYzdrZmF1UFR2V2xaNDBkeHV1R1Nj?=
 =?utf-8?B?N3QwT1gwQzdrVVRvK0dCS1RJeWUycTU4NlB1aDVaeHg3RGo0dExPZ1VWM09X?=
 =?utf-8?B?cTZmY1pQSkhyWGFvV2ovMWMxUjRHWmNXaXFzTlJ2NTlQeWZJUU8wdzdOeWYz?=
 =?utf-8?B?VXdpbG1MeU4wT0xGc0NIRklBYWU2eDQvKzhuUVArdUFMY3VwMlNPNHl5aEw3?=
 =?utf-8?B?eHBhNnVXZVBZSFlOOG8zQ3dHd0ZSNlRlbzNmYm03RGRwM3FFN1Qwc1BpQnRm?=
 =?utf-8?B?SDdVVWdrYnBhSUVZOE1yRm1MRFdRQTVGeWdvdnh3Q3RrT0E0RXZwcW9hSHli?=
 =?utf-8?B?Z3BOcWtuNHdVZmdnOHQrem1DM0J1R1N0U2xwWkNRQk1vNFo0WVMwODlyR1dE?=
 =?utf-8?B?U3IxVDg5TElmTk9EeE85Y1VuRHptcXJpOFl6OXpHOFFITkNHNGluL1Bjc21S?=
 =?utf-8?B?K2hHVmlsOTF3OWVVWWhyMmZpamtNWWMwRzBUeVBQVkF2TjAxUnhIdkp4VEpl?=
 =?utf-8?B?ZkNPSHFOYk84WTlFckE4bHE1b002Q0lNdDRmRkJaWEhCQytqMWI1OHBHdmhm?=
 =?utf-8?B?Q1NUQnBva0creG11Z1V1SUU1bGJ5a3JXblFtMDNiYkExcWFhVDdNNXVDZmR3?=
 =?utf-8?B?VFhHUUhkcmpKQzVGY3ZnT2QvOHg5NFRVdE90K1FTMlk5Rm9rNDV2VnY5ZjhZ?=
 =?utf-8?B?YmdqQVJrWFpVaUlFRmVCakVDZGJpb3loWVFuR1paRC8rNkRKbVB6THlwcngz?=
 =?utf-8?B?Y3Vad1hpVTVDZmxRMnk5QjdVN1V0QitFeTV3ME15dVZIclFFeU5kbHJMYlMy?=
 =?utf-8?B?NmNWb08yS0ExQkF4Z0lKcnZoMjRtRG9oYmN3d0ljWG0rTm1OZllJc1ovQUF3?=
 =?utf-8?B?SEdUZVF3T1NZZTVZR09nNDFNVTROYXNkd0M3R2FyNjdsOENZN3BIQktnZVNR?=
 =?utf-8?B?Y2VOTmJVT1htV2NlOEMwOGozQjR0ZmZKYTBqRUZvb0hXRXBJVGNvS3pmQy9M?=
 =?utf-8?B?eEZYYThRZDlKVkg1VjRCR25YN2NDcUZTTTQ1a2Izb2Z3M2FxMVkwV3BLcmRZ?=
 =?utf-8?B?b0xpaXFXQU9JQlFKTXZMMXJyMFoyem5ic3Qwc1o4UDkyTFJ0dGxMTzluQlEv?=
 =?utf-8?B?bkM2OUQ5emEyVitGTUNJWElYU04rQmxOd1NQUm9KU3lERjE1V1NxbGdqSC8y?=
 =?utf-8?B?dDBYcm5HOUlGK2pwTFZrUyswNEV3aE9ROGxmdnMwbURBZDNwME9ZcUZTQUYx?=
 =?utf-8?B?OHFjelhwMmNQZlV2TVM5bWx4c1JRaHE0Wi9kQmw2UjhWOVpzSFZYY0xZOFZr?=
 =?utf-8?B?RTFGUm1iVFR2RlNWeEovOUtWY2tBQzQ1cGlRRGU4aEJBZG5tajlwa2ppOWVq?=
 =?utf-8?B?Z1FQejRaZGFPeUlCUWpJRFBYeG9XaWY4VHNUV0ZKUnRydXl6WFVSWVc1ZEg5?=
 =?utf-8?B?M3pRRmNabStEeFVEb3V1R3IxUGdydkdRSEUzT1FpK1ZLUDB5VmF4TVl3S3RJ?=
 =?utf-8?B?Q0lMTjJrTGFBZEdEY2N6WTV6a3JkUTRKRzJhT2xxV2h2OGpRbHd4bGRZVSts?=
 =?utf-8?B?VWFibnJtUlkwaGZXLzl6ZEYwUW5xWlI4VU5oMVdsSC9jK0x3RGZrYWRCVGs4?=
 =?utf-8?B?dTBUcHpDMzBiMHFVazNtTWJaZ0drQndySnpJLzdDTkMzd1ZydnpoTjBqbkx2?=
 =?utf-8?B?M3BpZ29wZjU5S05naDhPZ1ZWVWZWajJSR2Y1VXpVNUtrVmwweC9hRzIvZU9T?=
 =?utf-8?B?SjlTV2dFdGszNDA2SWFjbXZBcG80d2ZFeEU3eDNLOVZqL2N2YlQ2d2JHVzI4?=
 =?utf-8?B?S2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dabe293d-d491-406b-704f-08db8f03a4d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2023 00:43:21.9965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxGMMrYWVBm3UudLNCsEuREYKWxoZlLTvqEQOSiYXiCg1n2ZkqS1ca9RJ3emQbVcKzoxATAtHXQutnkCavvdhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7468
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/27/2023 11:20 PM, Sean Christopherson wrote:
> On Thu, Jul 27, 2023, Weijiang Yang wrote:
>> On 7/27/2023 1:16 PM, Chao Gao wrote:
>>>>>> @@ -2402,6 +2417,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>>>> 		else
>>>>>> 			vmx->pt_desc.guest.addr_a[index / 2] = data;
>>>>>> 		break;
>>>>>> +#define VMX_CET_CONTROL_MASK		(~GENMASK_ULL(9, 6))
>>>>> bits9-6 are reserved for both intel and amd. Shouldn't this check be
>>>>> done in the common code?
>>>> My thinking is, on AMD platform, bit 63:2 is anyway reserved since it doesn't
>>>> support IBT,
>>> You can only say
>>>
>>> 	bits 5:2 and bits 63:10 are reserved since AMD doens't support IBT.
>>>
>>> bits 9:6 are reserved regardless of the support of IBT.
>>>
>>>> so the checks in common code for AMD is enough, when the execution flow comes
>>>> here,
>>>>
>>>> it should be vmx, and need this additional check.
>>> The checks against reserved bits are common for AMD and Intel:
>>>
>>> 1. if SHSTK is supported, bit1:0 are not reserved.
>>> 2. if IBT is supported, bit5:2 and bit63:10 are not reserved
>>> 3. bit9:6 are always reserved.
>>>
>>> There is nothing specific to Intel.
> +1
>
>> So you want the code to be:
>>
>> +#define CET_IBT_MASK_BITS          (GENMASK_ULL(5, 2) | GENMASK_ULL(63,
>> 10))
>>
>> +#define CET_CTRL_RESERVED_BITS GENMASK(9, 6)
>>
>> +#define CET_SHSTK_MASK_BITSGENMASK(1, 0)
>>
>> +if ((!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
>>
>> +(data & CET_SHSTK_MASK_BITS)) ||
>>
>> +(!guest_can_use(vcpu, X86_FEATURE_IBT) &&
>>
>> +(data & CET_IBT_MASK_BITS)) ||
>>
>>                              (data & CET_CTRL_RESERVED_BITS) )
>>
>> ^^^^^^^^^^^^^^^^^^^^^^^^^
> Yes, though I vote to separate each check, e.g.
>
> 	if (data & CET_CTRL_RESERVED_BITS)
> 		return 1;
>
> 	if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) && (data & CET_SHSTK_MASK_BITS))
> 		return 1;
>
> 	if (!guest_can_use(vcpu, X86_FEATURE_IBT) && (data & CET_IBT_MASK_BITS))
> 		return 1;
>
> I would expect the code generation to be similar, if not outright identical, and
> IMO it's easier to quickly understand the flow if each check is a separate if-statement.

It looks good to me! Thank you!

