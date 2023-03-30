Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F236CFACE
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 07:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjC3Fhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 01:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjC3Fhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 01:37:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F5549CF;
        Wed, 29 Mar 2023 22:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680154672; x=1711690672;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v82fYjS6+N5KR9WeN7+UerDe3gBwXirOTVMPWP570TY=;
  b=ZoK/WlKOPYKgUjNVwZCk3lxZOcLQpRJ2BJ4uwq7lJQ7Zx8J7e6F4OZ7j
   hmlRZ0GRt6rvaTzkIBXJwQDqKfTQVxWcBX4EDJWNYZbcl5VHMg2kEVlcy
   hKIN5hhTgR+28aj5Ob4d4z+UCOY6RgmRIGgURjBvghfeTvicVbv1hEOpF
   gjm7yZJ4miuIkz7sDto8Qu7GT2bRrb3tEECHEx/vdttcITa+DoDZb4bxt
   IAbGJ21fWe5rp8SB94ByjexHP8HHy9geJtYDMlv8HMBF2PuvzPnqcJlz/
   UjGOy+nssc3kEo6Sun/1UcgvOaM42S6zk9c/BglS/xdOxnaBsgIaW0AHd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="403723622"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="403723622"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 22:37:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="1014308784"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="1014308784"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 29 Mar 2023 22:37:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 22:37:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 22:37:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 22:37:51 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 22:37:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xrwcg6+8O1Au6WnRRaNlXtm/DSwCCWw56XWgK1D7XnY6m51KWLyAFWwZ4521N3da6kvt3WRnyFcG4PnBEWTMHLgpLiZ0tx47mTZq31OY1KkPykLmAeJK+hDVoRnq85JPA195irWBCE8b6P6NSueQtvUx2cNXfSPbUk3xfpn4jx3kXnNnZK+24BjcmtYsVN6Gd/Vb3EvXFZj3KVKKZ/zphErHv8BrGis4uDS0GvSPrqZ8BXDmKaxWkfBZbSPa2enKEaI8GmqatJ9Cl2IEk37JkCmuXPBpGWdwHuzl1I+O/k+WpJJYQxVou8JnISz6/tLeBI8V1uyNwi6d8r0QbBvK0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEioe6CZ/IHImwouGNU7y/MybBUSQs0Xfbx77bFdR00=;
 b=VmrgRO6X0od5KHq5T4luljg8OtrJZ4UeDE3wlUPKC3J32e1Dc39nezADC/RC9n2BRoRKtUb1mUW2LN7QQzZXg2SEjwzAsDtjBoxwwOeA1Bh+A+ww5e9VKS4X/2NunI2HJjahay4xVpwo3N7XVRhBw6dwv66qjrNeDdMMdubrE6dfXxX+OtGwQmothF2J16GF7cN0lmL1xBPMZXHXEHnT01GJ4QtWTG1Dy/5Awb7ZExohc7FcJChHc26vDFXCT3ukFGZzcjC/VdCsFuLsHsszXWxOe6+KwBOrFkaWEkSdue8tN6mADdf5pqNwxFFUyrNImFCSLswDBHoxqO1kfXD+0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB7469.namprd11.prod.outlook.com (2603:10b6:510:286::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 05:37:49 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada%6]) with mapi id 15.20.6222.034; Thu, 30 Mar 2023
 05:37:49 +0000
Message-ID: <9cf73a9d-d9eb-c6a6-a083-88539a3e78a2@intel.com>
Date:   Thu, 30 Mar 2023 13:37:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 0/7] SVM guest shadow stack support
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
To:     John Allen <john.allen@amd.com>
CC:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Christopherson, Sean" <seanjc@google.com>
References: <20221012203910.204793-1-john.allen@amd.com>
 <Y9B97dZnFnjEHhVf@google.com>
 <d4e15021af4e72d6daba4021feaebf289b676830.camel@intel.com>
 <ZCMpJLAx8//1zLLV@johallen-workstation.lan>
 <b75c6f20-a99c-a6d4-c1c1-7ae9f016d2af@intel.com>
In-Reply-To: <b75c6f20-a99c-a6d4-c1c1-7ae9f016d2af@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0204.apcprd04.prod.outlook.com
 (2603:1096:4:187::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: c6ced0f9-f491-4050-e65a-08db30e0e569
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2IhxoHX1z1S4En314Sy5Od0ftJrhR4D3x4uXzUTCIPXq8dW+Ie/ULnbbz5FAn9D8hgsDgkKrIOnR/fniR/Nxw1tqNKhtCustUwwdFpH/M/6F8UBQL3/sVBAZMInQk4ayvbhjs4wGv2Ba0lO8e3KWdDCcLw3R/xGocMqc4PBms/8TR0YyIyg7+5ixxAS0YjEVc3shG8OG/a+Czu98jfOGLaS5GkECMTWZguoUgmBTJH730NeV0rGK/4EgnHRlOtdxni87FWrLM8NlgE1LUWsEdx1UZ0gG611NGdlsxcvCstLeX3tVHEoY0Itkv8ENLjSj1hOHvHdDTxW3d2SJMIz0Wna2yCno1olUys3ExJk30jTbaKfRs9JYh7ZQ+MbO/UpOBrCXztZ+om04wQOVPiBBf/xL7fpbbGTD1mFrtRgJwcy164twMzCVvgU8ve+qBNdM/z/rDlqj7AtAlPs5vviNm0spvZnDM697Vao6gFjIBX/cCz4ME1mM5ynCtvUYFFMmTU+OaYrKZeBjDHP0OtVagjJP/myoNA76JL7Bq7VLKv5kZKcb++JcBQWu+KYkKK0oH+of0SJ14Iau6t5GAi6/s9GDkS5X1UEl+vyl6rVPSaUsp2v7BsrIQn0mfu1GqFtSpY2bvHfo/ql3qVbiEFO96kJppdswQadjfQCodkt3M7S9rKOYmF8YfiQgzqx5Ii/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(6486002)(6666004)(26005)(53546011)(6506007)(966005)(31686004)(6512007)(6916009)(316002)(54906003)(478600001)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(83380400001)(4326008)(2906002)(82960400001)(38100700002)(41300700001)(8936002)(5660300002)(86362001)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFNiUk9xNGZqV2tiWWsxaE5FTENsZXhqVTEwZDlBTFEwdlVDNDF0M0VwQldJ?=
 =?utf-8?B?bHpQZ2VOQWJrODJVMUZyYVkyNFNIeUIrbEJoaW1kSEp1Q2NVZ0szMDRjaFE4?=
 =?utf-8?B?dXdBTnVXQWh3M1hMeVlEOXFxeHVNSTRCc2cwT1R5NnVENW42K0hiZGQ1dE5C?=
 =?utf-8?B?RkRaR0ZnVXAvYTFQZXYvK2V5b2ZzZGZnNGhORVo1bzkrSVVxUVZRY0RiQ3RY?=
 =?utf-8?B?cmk3eDg1cUR2bFhabmR4VHh6NmhZWS96TmwvWUZSb0NSOEsrd1pXZ05KTndi?=
 =?utf-8?B?UjExZjkrWFVraUg4Vk1YYnR6ZXJTNTF2N2RNNXNPc29SYUtGZ0pUVlo0K3lL?=
 =?utf-8?B?QmFZR0liNmN0UlVSSVRZQXlQanZEVE80S2tWd1ZhRVFRR1VmVmxCR2NSMnNB?=
 =?utf-8?B?M1JsZWdmNVMxSnlsZnNHWmpFSndWNFFxbzZiZWJURmxseG02NjRkZFZwbldr?=
 =?utf-8?B?alRjVzYwV1BSUmZYT0ZvV2U2WXdXcjB2N2xORVFFWFMxZUY5MkRlazkvZTdo?=
 =?utf-8?B?K0M5OVdESlFPS0RKN1plMW9Ta09GdHp4MGRkcnJxS2ZmREVmeG56TVJJd1Nk?=
 =?utf-8?B?UTJISG5scTFKV2p6WVNtK0JUOUFnRUt5cW91dnZTZ3pyWVN6T3BraGV4elI3?=
 =?utf-8?B?YU5xekZaaU9rLzJNMWFONVNCWldrQ0JyV09RMm4yWlpsREdrVEFtMXkxcnBP?=
 =?utf-8?B?a0VMamlndlh1Q3VoYlQ4cW9PRGh5Z0F6MnZPQXU1TDZYM3k5R2tVd3h1M2dw?=
 =?utf-8?B?UnYzWkJjUW1yOXN6S1JOVUIrUjkrTHBpVEMwVjlJU1I1WWlMWmorU1VPcTZx?=
 =?utf-8?B?SFc4ZFFhblRWektObHozNTNvTUEwQklWWHRVMlNqSW5iTndEOERKQ0owbGNu?=
 =?utf-8?B?U0RuLzQxQlhyZ3c1dVFuL09JS1BmcmRwQVMwSm43ajVwZi9HK29iQWhBMlRX?=
 =?utf-8?B?SEZ4L0lTZ2dHQWhOc2ZQNzQwb211YVF2bU5YUkJGZmxkTDBoNnlVYmpSMklm?=
 =?utf-8?B?dVpVL1BXSWFVWXpuQ1RYM3dwaFRmZ3VNUDBsWmswZWhoZU05eVZqRnU1eGRW?=
 =?utf-8?B?Q0ZOM25Od2ZBaXRqTWdoeFA5SGlCSEtVb1A5YzRUYlR2ZkJoblVtNjVRVC9G?=
 =?utf-8?B?V1hRYytsaElKN1FKd0lpa21yYVVWRU0wQXUrcURObnZacmNnRU9LR0FHYU9G?=
 =?utf-8?B?YmJ3SGZ2QUpyVmxWeGcxd1BCTE11NGxwQUhEajU1dnZkdXZZTmhTOExkWFFP?=
 =?utf-8?B?V0MrYjdxVWhXR1NWaHltaUFtMXU1UE9yeHZnT2liQzdMRGVjd0ZsQ0s1N0t0?=
 =?utf-8?B?cFJCU2FGRlRKcno0dmkvNTJxNXFKVHdJVjFOeXZZdFhuU3RSSVhQem0rKzZU?=
 =?utf-8?B?Q0N2QU9JdG9ucGZCL0R2bHI3bTZzMjFFTkxENHF2eENVK1d3elBncllEbEhB?=
 =?utf-8?B?MkJpM0xBZUdsQU1XT0ZzMUJKaGVIUWUyQUtnekgrYXB5MDdCbHNxV2ZNWFRX?=
 =?utf-8?B?ZlBRdGx1SWVWdWwreSs4VzdnNEhoaldaVjA5TENwWUVwQ05FOWFMK0dWaHJD?=
 =?utf-8?B?ZnJNRjRIbUFKcG1obVhjYUVLcHlzckwzMVhGNlV2aUpzMzM5UDFuR3FaQUxO?=
 =?utf-8?B?MWZscjZwVCtVQ0tEMDdVTk1sR1ZGS2hTY0JrOEptdUt2RExHcXZPSjEyS2NI?=
 =?utf-8?B?bVA2NXkyU2VjdGNrWjVqQkRTVnZKRXY1TXVkNDhGTENqeXNhclRNM1ROUG8y?=
 =?utf-8?B?NFhCd1lXbTBXMis3eE1UK2xHWU90VnZwc0E4bzZqMFhXZ2tOc2wvdkhCZ0ln?=
 =?utf-8?B?SjY0N05qT3BOUHp6TGt4TzdYUk80TnU5QkZ2QmsrMVg1aTgwdWU4czRKRDlJ?=
 =?utf-8?B?OExnQTN4TWg2cCtkRUJYQ1hxMU92ckRZcDczdEE3TkdPYjNZQUxSbm5NNGkr?=
 =?utf-8?B?d1dTcnNQZ1ZFMzdyeTMvQnNEcUduV1JybVg5eXVZbUpGTU5xQWJRZE9VOXNj?=
 =?utf-8?B?V3A1aFNKbHp1Ykl1VytoZldQclA1ZC9CYkRRSUJ3NURRUlp0R1g4UnVKK3NY?=
 =?utf-8?B?WnJVd05LQ1Z6dUlrSTkrWUJuSkFPcHVrb1ZpWSs5K1BKdy9XQ2dkUFBQMExp?=
 =?utf-8?B?UWFaYkxETldxT3NYZ1o5OTB0UHJDdm52b1h5c2FqZE5iVUJublVHRjNRbWQr?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ced0f9-f491-4050-e65a-08db30e0e569
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 05:37:48.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDOF04UcjvlE5DTi3iMjqSWE/bF4cv0G004pneVwYvs9qc0ZiN6gQOV+m8MaeVmbrPrHcpcWrRp3f6yaSbYdRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7469
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/2023 8:16 AM, Yang, Weijiang wrote:
>
> On 3/29/2023 1:51 AM, John Allen wrote:
>> On Wed, Jan 25, 2023 at 01:11:44AM +0000, Edgecombe, Rick P wrote:
>>> On Wed, 2023-01-25 at 00:55 +0000, Sean Christopherson wrote:
>>>> On Wed, Oct 12, 2022, John Allen wrote:
>>>>> AMD Zen3 and newer processors support shadow stack, a feature
>>>>> designed to
>>>>> protect against ROP (return-oriented programming) attacks in which
>>>>> an attacker
>>>>> manipulates return addresses on the call stack in order to execute
>>>>> arbitrary
>>>>> code. To prevent this, shadow stacks can be allocated that are only
>>>>> used by
>>>>> control transfer and return instructions. When a CALL instruction
>>>>> is issued, it
>>>>> writes the return address to both the program stack and the shadow
>>>>> stack. When
>>>>> the subsequent RET instruction is issued, it pops the return
>>>>> address from both
>>>>> stacks and compares them. If the addresses don't match, a control-
>>>>> protection
>>>>> exception is raised.
>>>>>
>>>>> Shadow stack and a related feature, Indirect Branch Tracking (IBT),
>>>>> are
>>>>> collectively referred to as Control-flow Enforcement Technology
>>>>> (CET). However,
>>>>> current AMD processors only support shadow stack and not IBT.
>>>>>
>>>>> This series adds support for shadow stack in SVM guests and builds
>>>>> upon the
>>>>> support added in the CET guest support patch series [1] and the CET
>>>>> kernel
>>>>> patch series [2]. Additional patches are required to support shadow
>>>>> stack
>>>>> enabled guests in qemu [3] and glibc [4].
>>>>>
>>>>> [1]: CET guest support patches
>>>>>
>>> https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/ 
>>>
>>>>> [2]: Latest CET kernel patches
>>>>>
>>> https://lore.kernel.org/all/20220929222936.14584-1-rick.p.edgecombe@intel.com/ 
>>>
>>>> That dependency chain makes me sad.
>>>>
>>>> Outside of a very shallow comment on the last patch, I don't plan on
>>>> reviewing
>>>> this until the kernel side of things gets out of our way. When that
>>>> finally
>>>> does happen, I'll definitely prioritize reviewing and merging this
>>>> and the KVM
>>>> Intel series.  I'd love to see this land.
>>> I think all KVM needs is a few patches from the beginning of the host
>>> series (the FPU stuff). At one point Weijiang and I had discussed with
>>> Paolo and x86 folks that those few could go up with the KVM series if
>>> desired.
>> Now that the baremetal series has been accepted, how do we want to
>> proceed? I think I'd like to send a refreshed version based on the
>> version that was accpeted, but I'd want to wait to base it on a new
>> version of Weijiang's kvm/vmx series (if one is planned).
>>
>> Weijiang and Rick,
>>
>> Are you planning on sending a new version of the kvm/vmx series?
>
> Hi, Allen,
>
> Yes, I'm working on the new version of kvm/vmx series, will cc you when
>
> send it to community.

Patch 1/7 did what I wanted to implement to support AMD SHSTK, my next 
version

will continue refactoring them in vmx scope, then  your series may pick 
up the helper

and modify accordingly.

Please note, in my series, I removed check for MSR_IA32_PL{0,1,2}_SSP 
since they're

not supported right now, but your series supports for the MSRs, so you 
have to change

the helper a bit to adapt to your patches.

>
>
>>
>> Thanks,
>> John
