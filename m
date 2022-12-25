Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0116B655C54
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 05:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiLYEIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 23:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLYEIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 23:08:41 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADA564EB;
        Sat, 24 Dec 2022 20:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671941320; x=1703477320;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xQPGdXuaAFTMU687xofMxBDXT/qtCOKjDR88jnYDbvM=;
  b=VozuIQ5N57s7HKDWp6p8wRlxVa7GJiCk3QYCOKiDoXNDC8OurqiucLLQ
   7naSWUus4Y7uprXPenPZAND36KrC/bc6MBNI9QTUI3NYMWVU/v8lEZWQf
   7konV+PPhUZV/dKT4GDTAFu3kAxasUWvnadqo4glPRW1uEZCm1HqRV+jd
   711tJOkRKcpPzD7BjujKGooZ+KtVPq3L3rj4EfcOIB2/pUE4vGlVgPall
   WP/yIRBhM3BsyyKxmTfJcXdHZaMDYVHdzxvdgbsbtYC5ElfdJs/Fam9b6
   vxm4rbrlRxXjTRBS49itF3tlPRpGj+acmg7Zh0v7dIHaV8wEKniMHXHUv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="347634075"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="347634075"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2022 20:08:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="645882206"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="645882206"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 24 Dec 2022 20:08:39 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:08:39 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:08:38 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 24 Dec 2022 20:08:38 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 20:08:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naEaGgrQTMhiprLR/Rm9t45xWJC76BhwKjY8B4Z+gtFP/SZDHP+jKR0H7zDt3bbQU1jqbaOutHaVKSWAfa/ARCzQHLfd15DyR6KgqakJ/qxtjUb3gTGzFmpPuOrup2y0hYr5pn+QeouwbxUGJcl74eJ/t+tYwD7epGyyoUS9G+blYjwxG/oACaXLW6PoWLEzTLfm0jgekIulUBUfQ6cTbI/B2YLB48cmtr1/q3/EePypLJfkvWCm6rXzoKnPXxgwqRiNaf75iGfgTmdUFAXyiNtPq47UVPB7j3LS1d2j/5LlpvaNYJIif1wOt4c6dDX+Ysx2/oEZdn5JiCZg1bbA4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iHRJdwmS+nT83w64aMLRpirQzhAqj2UD1pq/eidR5s=;
 b=KAO8WniG9vdZEp2PzPWxQDZRUXWoXsydkmt9PtsZzUVjO9B/7Au+WoAuuOc22h84P4AvMy/TZ+vzZiy1BM3GbgJ+cAt7CdJrM06GJBQcBevCemXoO/GXHJngN6YjupgpWuQUD61q+fEgRlY52OUmBiCOSvmfHVVzJHn3ZW0w/xE+lzcPtHmgT9ppo806kkrzoBHF1AsrT3F9yZaRhXQiNdr/xbLiOmuv5vPUQwuSMDONYjkNJlw07J+kCpC+WSIjckMwPzWXrk6BkF+HVmSU5UgwER1cJ5C7c5UitQ8ozmbOqCMI/U/vUiVCBw8IYAYFWnYElGn3HYUx4cBiGDhbrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7465.namprd11.prod.outlook.com (2603:10b6:806:34e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 25 Dec
 2022 04:08:36 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.014; Sun, 25 Dec 2022
 04:08:36 +0000
Message-ID: <8832073f-be29-76a8-4e17-d498b959aa2b@intel.com>
Date:   Sun, 25 Dec 2022 12:08:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 06/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest
 Arch LBR
To:     Like Xu <like.xu.linux@gmail.com>
CC:     <kan.liang@linux.intel.com>, <wei.w.wang@intel.com>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-7-weijiang.yang@intel.com>
 <03fd9d59-16da-9b93-74bb-593937eae941@gmail.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <03fd9d59-16da-9b93-74bb-593937eae941@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0089.apcprd02.prod.outlook.com
 (2603:1096:4:90::29) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: bbbf99c6-2ca1-4c0a-25df-08dae62db20a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ya+oE2A9wIi1U0Bts2vwjGRG0T3lQdlL8NzeEMhxOFQLFOKccOWC/XUXYwePW1PxancAKAQN0nxnStNQ3VTzE4dxH3gLK+X0XkM75wTWyPrTFpSC2F/9SWlziaQLSDKb0fue/v4fMhpsihUUbheQsq20MNCgfJacorcC5o4XKO2H6/w6Sfy7XqszPojLCKLx7Puf80CdZn0x97xT5OKPK7cuL0YJD7k3lIUu67s0OQe7bg6WG2OurHeLNGTzlTpD4ukDOtFI7bfGpels5yu+qOJnwgNmUic9NXA25gPhrTP78ecxVB+xa/SV6SlRWR16Y+a+RboVEdQqDoDBFUnLWmK61pK61b5P+T+db5Zy5e3duJtQAwim4MYJRqrHnP1NfY7EqK8aMZmY3uPvU4tNxWqsLNR/9J0M9LVYZdUtf+0pjznokl8T12je+0UOUugYQ8mttROfdYfbZIZXa9rXY4LJ6/ReerxtdMtnbCVDaZmFRn4HBG1yc3v0dCW2+kYB5LQIyWvgVIC3QIZxezw/xEBkk42ZqAj78XuEELvsmLCc6Xd3PJYzar5PaHCkBoYZjgx7S/GG3cZdoLa/zCK0+H4nWcEaI7hhY4LSeXz+9a2dD0EDgaPldlmJfTLRyNZAPiH2MT9N3R+ZMCbbTenHVOFhnhqhHt/UB8W2VaowMzyBCEj2He3/tHDIYpCpVz9n6sFjNCm4ToPOpLU/j5kmi3VOiNpb6yF4/u0YT4gWKZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199015)(6486002)(8936002)(31696002)(66556008)(66476007)(66946007)(2616005)(31686004)(82960400001)(86362001)(36756003)(4326008)(186003)(6512007)(26005)(8676002)(41300700001)(83380400001)(4744005)(5660300002)(53546011)(6506007)(478600001)(6916009)(316002)(6666004)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWJjbHdWRTB1aTN3WDdWcEFJbmdxQjVHRnNMYklMMEE4dmYxeUJQanFsZU5w?=
 =?utf-8?B?c2xQaVEwNWl3cHNRWkhkN2VKWWFIdEU5VFNzejV1TThRMkt4b2trTVVLdjFJ?=
 =?utf-8?B?TElCM2FNNjI0MXJoRExSZ3FMYzBlQXlqS0VtNTR3eDByL3UrZlUwbVpEUWtB?=
 =?utf-8?B?c2lmdVc5SHdKelJoenZGRHVMOVlSQTlHZ1g5S3ozU1lVcFJrQkFBMURDZ1Ax?=
 =?utf-8?B?WVF3d2grZG8wR0lhM3M4OEU5ZmRKV1RvakZYRjkwNVlldGVaNHYxWWtGM0l6?=
 =?utf-8?B?VXlDeDBJSHpXcnhCNS9uYm56OGZhS0xkbElSbVV3OHRLRG5FZFJFejJxeU5R?=
 =?utf-8?B?OXdjUUptdzdsUGFGcHc4dnczL0J3NnQzSFpkNXM4QmY0QTdheEZnZkR1Znor?=
 =?utf-8?B?TjFpOUtWWElpK0padW9qYXBIVUhDNFgyWEdvNU43YlZpemFFdTZ1b05hNEQv?=
 =?utf-8?B?NzlqV2NUamtpcDRtWjhicDQyTDh0UjE1TmtvWlJXRm9hQnYzanFnVVFBQktu?=
 =?utf-8?B?QldodmRZVnpSQ3JvVlI3Ky9nRUxkMTJEYzJDSWVyZTNXdVcveHNRSmlxMDFp?=
 =?utf-8?B?c0NlcmZyVm8vYTU4YmQvUWFDSWg5VXR5VVEwOTFQWEdEREx2RDB6cks2bmsv?=
 =?utf-8?B?YUFjbjZPSktuTWVuT0JzY0ZvUjlKM2J6SEF4emJvYW94YVpTL0dHUDlkeU9a?=
 =?utf-8?B?azJCUVQrV2M4MlNxbVNsNUlhbS9wVThsbzhhR04rbW9zRXMzTkllOUpSVUdI?=
 =?utf-8?B?MTh2K0Yzckk2RTlPdEtPK0JsWUFsbEtTNlZTc3FyZG9vZzF0YmQrT25oNWRj?=
 =?utf-8?B?bUNobFF6V1dFOVhuWkc2ODhMd1NNWkZDM29HODFNWHBtVHZ5VWF6bktyRUVr?=
 =?utf-8?B?QU94RTA2bm1sdXZHTXVLQ05JK1lvUlFNc3FHWnFUV1VzcG13Zk5kbGdnMURj?=
 =?utf-8?B?eEpscU1GQWw4bGFCYWl1ZFIyWHVaUHE5UXZaOUhDd1IwSlRGSnRxZnE2cytt?=
 =?utf-8?B?eVRYcnVHbk1aWDBjRERsdzlBSkZBRFNrUHVJSEl2OVdwa3NoNFNyTnFlUkR5?=
 =?utf-8?B?RGdPT0ZHK2RPbVlmS0xUL0xQOHFvZEM5TmJJYktSRWlIK0ExNENEMmpZMzBV?=
 =?utf-8?B?NS9xMDVTUjArczRjZlJzRmhUQ3dxdlhndmZ2ZjRCMTZYN2JRZWpHKzdKakJn?=
 =?utf-8?B?bmgrYUhkNjIwK3ZOaklneWxadC9oN2x6ZHNjNFZlTjhLYS9JeG52S2d1cjda?=
 =?utf-8?B?MVB5R0dFR0dPVTVZaUZJVnUyMjFQSWZTcTdtNDNTRGZCWEpGc3JiQW9wb2ZS?=
 =?utf-8?B?QnRwQzNIeGRXM0tENUF5RG40dENiMUFjWHBvTkRwYnl1MTlpOHBIdDc4YVl0?=
 =?utf-8?B?WU9pNldvOU9QMjFQK0lvSHN1L2NqemJLaTRBYzYxUENRc2VZT096QjNEK01m?=
 =?utf-8?B?Yjc3MEkwR3dJOG5id3U5VDFVWDZ1c1ZyVEhoVE9WeURCMHRQbVFlUDJtalJF?=
 =?utf-8?B?UXlzUTlqS3ZDVGU1MXZyVjBPOGJtMll1QmZiQVdzQlI5elllUkxpcFpMajEv?=
 =?utf-8?B?amRvRkZEYjhxZzErN0xIdllDTm9KaXZwdkdRVUxkajJ6bkdQQlU3d3FIMlZz?=
 =?utf-8?B?MGtOS1N0NG5jeXNwU2R3bG1VL3VPYUlBYjVBZWVyYWZnYkRTQjZaZGxSTzlp?=
 =?utf-8?B?WFBPNUk4V2sxUXJ6SURsckNDMFhVQklpc1N5M2xrd3ptbDgxM1BSUVJVVGxj?=
 =?utf-8?B?TUEzSS9sSGxBU2tYY1llUnZYUU5jRWxPdktMUFpFSEYxYTNpZ3p5MGx0SDI4?=
 =?utf-8?B?NnVZU0s3alFibzB4VzBRZUZ0am9GZFJsdzBrNHRyaWduSElMN2swdUlnbWNG?=
 =?utf-8?B?V1gvZ2tsTjVRNGhIdWtiazkvRHNzRklnRFE0M3JBY3EwN3FvaWdBaDN3djlv?=
 =?utf-8?B?WXNPZ0xUSFE0T0tYbGUxRVdoTXJ4K25YUlVCTDJkWVVXejZCZVEzOGZ4anh0?=
 =?utf-8?B?TisvWmI0YnNUdnN0MytXdlFZRUJYU1o5VTNyS0I0QnJHMG1nSStNNXBNWUM4?=
 =?utf-8?B?czF4MktxcUp0ZVllRC9VM01TSUhCMEFidDFiY2F2eUFpUXd5bkVQN2g2VHlh?=
 =?utf-8?B?L09vMTlsUEhPbmx3MzdWQXNQZytGVUc0eklYUmlwcWhWakZXU1E5SUp5b0sv?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbf99c6-2ca1-4c0a-25df-08dae62db20a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2022 04:08:36.4865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXpqlxx9zlGgdYiGFOs8Iuy/HnGnhMIhBeFgIhxb5IWsnwKG1b6LQsdJILWFApaLUrgTuBkN7wrrCjubeJN8xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7465
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/22/2022 7:24 PM, Like Xu wrote:
> On 25/11/2022 12:05 pm, Yang Weijiang wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index cea8c07f5229..1ae2efc29546 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2120,6 +2120,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>                           VM_EXIT_SAVE_DEBUG_CONTROLS)
>>               get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>>   +        /*
>> +         * For Arch LBR, IA32_DEBUGCTL[bit 0] has no meaning.
>> +         * It can be written to 0 or 1, but reads will always return 0.
>> +         */
>
> The comment looks good, please verify it with a test.


OK, I'll add the test into pmu_lbr KUT test together with arch-lbr test 
cases.



>
>> +        if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +            data &= ~DEBUGCTLMSR_LBR;
>> +
>>           vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>>           if (intel_pmu_lbr_is_enabled(vcpu) && 
>> !to_vmx(vcpu)->lbr_desc.event &&
>>               (data & DEBUGCTLMSR_LBR))
