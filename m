Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351237324F4
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 03:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbjFPB7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 21:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239330AbjFPB7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 21:59:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA962952;
        Thu, 15 Jun 2023 18:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686880781; x=1718416781;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lykc/8k3MmLDlN+5h1ZWFbo2u+PInUmGA7idUxLkujM=;
  b=gUJIvV8pOSWarJwdCxGq9kvNciEkT3X9zU9DJUAzRKAPsIkfu1Ol4pOe
   Siqq64GXH8DIcQLIgP3ITuV9S7whjnTLDBbm/OXOMAC/Q1Bl+3oH7pcae
   wQFMZ6ie9KjE2UqSBZsnRjHAHZxzAn7Mpg+3eEwFUekcwLwuwGDQq7z2h
   CeySRWnsJUOuW82tbozoFtlWJFGNGNotEcfe3xSOsCLs3Q+1FJU8DOGU5
   7y3Y4YlqyC2/mWi263sWdUP+Wqo5UqxxgXBINdQXZ8hMqKVzRrJKM/1ck
   m87FDPJKQETZGmzRUQbr0OWmLw6H9mhQFOislWybN2Snk7aUuVikESJNb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="362508027"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="362508027"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 18:59:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="742469189"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="742469189"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 15 Jun 2023 18:59:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 18:59:15 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 18:59:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 18:59:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 18:59:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtXPKvGAEjP9IvYzDhChgsWH8K0tMoG16BcPJ39/DRQdDtkaFRkadl+o6PozsuBuuPCS18jUAxxodnHjzqXiFiTBShRwyuDk7wuQW9bPIqhjyAw6o6agkeX55v1jCmAyKTLhfeCvSmEjThvo73ow8VnXuXR2OlJbKXySAmhDn0P6OYVFm/73NuNL2pq47hQgMWbgXO5mGHoRxovNMU2tYSaBO+pHHHz75CXKkfFv9A1bFlUnqqu/aAZzJG4kQS26tUlWP6Qdebe+vp2mIAcpxfGDwNx5wbnrBNkPeiADwsC/FZ28szb0rLF6MODDsWfUbLMTw7POjTN6WzeSZUdRPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0r1BJETKkoAwL3LJSnwuSrn8Qf9ILldSIcYSby21mM=;
 b=HwRBNW0F38Y+OWAtPFKDbTsSTu6TsKw28EX9Ug3kglG4xi6fws9VTl3xkwPt+qj/swVAFXuGmd97mIZwYtxijjozpWTsjiOY8FKS0R/OJ/2DtE2ccAAx/ageGPt8UgcPVts9ZEyD3KoJfvAwUXQw2eB/A9QQZGjTR6ArpYHly2WcAoxcNSCKSEzewlqC+KtSt7XJYl9nzCet0r+O4rT4wOsoulINUkQWKaH3XBYpGRkIFbyuNrai10bC2OMrACtrrdvPNJOjNO71uXAb+BZoATpZyoZy+57uLWgAkG/1YpbhDvMx106RYGhrzTKHLUgfjiPljcPM2RDC+IGNJ6YIjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7993.namprd11.prod.outlook.com (2603:10b6:806:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 01:59:07 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 01:59:07 +0000
Message-ID: <f2708ad5-494c-c91e-cf5a-09f6e2d81e15@intel.com>
Date:   Fri, 16 Jun 2023 09:58:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 07/21] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-8-weijiang.yang@intel.com> <ZG77wu4PyBn1z587@chao-email>
 <23169e5f-9793-9486-fd5f-287e3317b837@intel.com>
 <ZHXnP5bEvxPrDg3m@chao-email>
 <6e1e9de9-8def-46c3-a238-c1b4ef52e331@intel.com>
 <ZIuitcH7P1JpkzFH@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZIuitcH7P1JpkzFH@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:196::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7993:EE_
X-MS-Office365-Filtering-Correlation-Id: 060d26a9-ede5-4cf8-816b-08db6e0d44a9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZpKW3vri+rOGcn+XemjxR5Ks9mDEWgOApVzI9BnR+LPjlmgx6sNNatzM0w8HH+QvvnMuxysceP1rEFWBV1/YyNj5pmj1Bk1jMizipTQzgDg5F4T/FyIkGdXHeLgL09xPIuPk119NfRGwdCPop7YGp7hgI2P0CX8vtN4XZeL0sbBYrJhTCiq7hyWx9EfB/D0lDAj9dw1xhOefP/3BXA93ufAQ1JtKHXCF+Hg2XnqzlV7iZHPwXJwIl6fhTuC/ku5kSJvgr+vzy3s8Jed5cvYhsL8SCD0fEUMRCX5SByA/S+u3eELPndHofoKbGL/1z1dW4RSNV5RBwB+sYWy/ft/gudPaWnDg0GG7tmsFW1Fs4BQNxGAyyVImuQcDYlZC2WZhD9S9pw4KyL1zrbccRoJ6BcNS72Juv8pGTvqrk6S4Fxv2LR4+7p0koDc+ZoEjddhxl9qiJd+AhHTQOxs1qv683tN0b6ezrYTKTeeR5YuGzB+sbY0gONuHxMYNo7BdBVFJJo+WeEldzmzFJ6LWvboIU6mA5jiRQfe43IxrAcn6e/xvD0gaWajxqD2K+RE/cCfTwKln0x/7854nIOHyvg/lsxyh3b3Ien02Komf8ttnFLvDoBQsU715t4ji+2BwU1FmKHES/NaJ3owsA5qOWA9O3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(26005)(36756003)(6506007)(6512007)(186003)(478600001)(53546011)(6666004)(6486002)(2906002)(316002)(41300700001)(86362001)(31696002)(82960400001)(31686004)(5660300002)(8676002)(8936002)(38100700002)(54906003)(83380400001)(2616005)(66476007)(4326008)(66946007)(66556008)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3VnRHZOcHFOOGxpRmVGdExQVkJUTXlMdk5MZEJrZk1aMzVRT2xWNXFZWXVN?=
 =?utf-8?B?cFdycjBGbWZUL0xMWjRhTDNlbG1JeGo0ZW00cWxGdit6TE0zWnBaQTdlL0NR?=
 =?utf-8?B?WS9MZW9ZYlR1V2h6NjV6MjdidGFPNGdtWlplZTgyTXBUZXphbkpFZmlNK3Rr?=
 =?utf-8?B?dHQvUEIxeXpidGFRSElYRGxQREg4M2hqQWF1NVpqQnF6U0hzRzFyZ05YYkRB?=
 =?utf-8?B?MUZBVEk3R1FLK2xhRzNvRnVuQTV1ZUNrd3o4TlRsMUt1b05PMjkzWDFCcTBD?=
 =?utf-8?B?TXRkS1hSS3lCbmljOS9YeHJyOTZqZGQwUTF0cGlRZFhTVkxFVHpGVSsvbCtC?=
 =?utf-8?B?QVpVbWsrdlpiZkllTFJqYlZ2NHFPdVNCSHZnSFUxYjYwL0FtaUlPY05zK3FI?=
 =?utf-8?B?Uzd6MzFLZ1hWeDNJWkdOb1hERHcrSHAyWHVtVzlmSjZnNVhFMmM1QW5Dc1BN?=
 =?utf-8?B?WWFzV1Zuek5XQm1BR2JiTHpUem10c0Y5QnVEeUtIRGpiQWhQejlENEF5bjBj?=
 =?utf-8?B?R0ZZSFp5cCtEaVVzUU4wOWdNRy81bkt0Sm81SzVTaXlYNWNvSUhGTFVqSklC?=
 =?utf-8?B?OWxsUzIzdDc4RGpNS01jU0NsTzhOQzdyK0ZOQlhoTlMvSzdCUERzWUt3Qnoz?=
 =?utf-8?B?ai85NWlqQngyWFp6cVR0ZVVPV3dJQnordGNjWEh1cWYrQ29OUENNU01DOEZK?=
 =?utf-8?B?MzdRT2JTYUl2a3BWZUhZN0RHL1IvMGVRa1I0ZTF6V0dRZ3EwQ3pJTEJ3bUho?=
 =?utf-8?B?Q0pqYk16aVJaNUx6N1R3NndOKzBHaWZYcVMzTlIzR3QvcE1HaDJ3WFNZYU1C?=
 =?utf-8?B?TmROMXJ2RkRTMUQ2Qks3dTk0ZmF5VVZMVE53N09ZMnFXNmhoSUc5eW5Ta2ln?=
 =?utf-8?B?aVFCZUJHdXB5SW5aK0Q5L0c2N3RuM09KMFpTSG5qaFNXUEw0VnVROVppMXpF?=
 =?utf-8?B?dDQ1bWFVQVpUUlFuNGxjMDBzRWxwK0tTUDhkWDJQVWxJdFhYSE0xVUpyclBG?=
 =?utf-8?B?L0J5aVpzZlBqNnU2VjdkNGFXSis0RjZCL3BzOTFtWmQ4WXRtcXlUVVl1dHdj?=
 =?utf-8?B?bmYzcWVCR3lnenZXSzJKNzd4SkQ2UE9pR0IrcmRheWVWQzYwTVFLb3N1bTE0?=
 =?utf-8?B?WjhXMWNTbGx6RVNBVVJPc0krbEM1T3JzM3dDdnBaUlB6bS9HZE9RSzFDVEJ6?=
 =?utf-8?B?dW5hNDUvbHZabG4yU1lkdE5UeDhTL2FvOUZzS0xwc091aHl2OFNiQTEzQjVH?=
 =?utf-8?B?ekVkcFMwK25PVHc4ZWlJYmRFTkIxcFJndHozT2RRdW43MENVMEFDbEUycFgw?=
 =?utf-8?B?cFZqTjAwOWRNc1hkZFJiNmdaT0RWaVBXazc3NnNOdFhqT0hwUU1GSjJOalY4?=
 =?utf-8?B?UWVqVjlCRU5aV29zUlFlT2sxUGtMUEdPdkFZVjd1a1Y2V21DNHpYSDlOVFVR?=
 =?utf-8?B?M1gxWnNSbkpObVBLZ2pNb0R0NUowemlTeTdEVzRGQkQ4bmY1by82K0I4R0lH?=
 =?utf-8?B?UkxiOC9lalRhdDM1ckFtVzIzYU1Sa0J4Z3FNNUxLSVZCSndaVEJkSGd0Ni80?=
 =?utf-8?B?TEtJZTBFNytqdVoycUdnZFNyK2JOZGpzR3p1UW1COHpnQWUrQmtzckhxcnVQ?=
 =?utf-8?B?RHlCUGpOcG5KcTBnWTR5Y1d2dlZwY2ZRVDd2dkJDVmxlcFBxNXJVQWRkdDRl?=
 =?utf-8?B?dDJhQzcrL2dNcDQyYzA5WjBqQ0tBcHhQdlA4cXBiWm94Y2VnTVdsdkhqSDEv?=
 =?utf-8?B?VkhWS3J0OU9PK2VuRjJHRE9YdkZZMXUvZFMxR3FBdmdiL0JjYjZkbkNSZG9k?=
 =?utf-8?B?VjVrY3I3Qzk0OGxLMkFqNWU1REhnMkljVGIrVVUrdmZXV0FPVk8rdkVJdldO?=
 =?utf-8?B?dlZPeFNFVFNOSVZ1eUVVamZna2s5YmZUaGFkS0FONitKRWRSb2ZGT2xXaXFG?=
 =?utf-8?B?NURZdVVnVTVXZ0pZc2R1N3F2cnFjenROaVE4TWYzWW9xWCt4WGpaeFQzSCtX?=
 =?utf-8?B?Tm1Odk1SV3Yzb0xiMzVPZDErRXFxc0xYZmQzWnU3dm1NaXBObVZyRzFtT3ph?=
 =?utf-8?B?eHFndGJVS1lCMUVUT01GOVdqNUU4TkJudWd3bDkvSVpDTENTd1ArekFBWUZR?=
 =?utf-8?B?SGtTRGtQRlBLeW5MRnQ4Tyt4cHRHM2xnMDI1VlZhK29hM3dnZkxVNEg2d0Iw?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 060d26a9-ede5-4cf8-816b-08db6e0d44a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 01:59:07.2185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aw39vubbGsImPctZh+MGoauLD/ZI/ya3ZLlV+yJorcNKAkxWUmJP9iSaeh+7GrcGf92EFZPY7EUyJOW2rDmIng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7993
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


On 6/16/2023 7:45 AM, Sean Christopherson wrote:
> On Wed, May 31, 2023, Weijiang Yang wrote:
>> On 5/30/2023 8:08 PM, Chao Gao wrote:
>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>> @@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>>>> 		 */
>>>>>> 		if (data & ~kvm_caps.supported_xss)
>>>>> Shouldn't we check against the supported value of _this_ guest? similar to
>>>>> guest_supported_xcr0.
>>>> I don't think it requires an extra variable to serve per guest purpose.
>>>>
>>>> For guest XSS settings, now we don't add extra constraints like XCR0, thus
>>> QEMU can impose constraints by configuring guest CPUID.0xd.1 to indicate
>>> certain supervisor state components cannot be managed by XSAVES, even
>>> though KVM supports them. IOW, guests may differ in the supported values
>>> for the IA32_XSS MSR.
>> OK, will change this part to align with xcr0 settings. Thanks!
> Please write KVM-Unit-Tests to verify KVM correctly handles the various MSRs related
> to CET, e.g. a test_cet_msrs() subtest in msr.c would do nicely.  Hmm, though testing
> the combinations of CPUID bits will require multiple x86/unittests.cfg entries.
> Might be time to split up msr.c into a library and then multiple tests.

Since there's already a CET specific unit test app, do you mind adding 
all CET related stuffs to

the app to make it inclusive? e.g.,  validate constraints between CET 
CPUIDs vs. CET/XSS MSRs?

