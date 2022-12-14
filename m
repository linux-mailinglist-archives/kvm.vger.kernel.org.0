Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D242E64C1FC
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 02:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbiLNBtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 20:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbiLNBtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 20:49:01 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFEB2714D
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 17:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670982538; x=1702518538;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z/IlmUtbXD3k+N2vyGrj+41C/1cYwJR3IbirDIpleKw=;
  b=i44z2+dtOMu/KRm5RLMhQUTvzjEmD5J69OYiykbhAzt9w8F+BampsqCm
   fijxOa9O0MHnhh4PjjVqGjOwJTHxZF3BOJRZxO21HsWY/0eIf9qdsok9J
   nCXDHvBQ270uSebh5dWRvjwanumAgSaW2Ug9l8DBAgI2g0DNp1CLiA24C
   qX6ukPk0qD6tM6zKl8/D9YPIqBHME3be/g1KiK9YrBvjucIfN2+WVwM3z
   NzlPK3PZChexuW1QI1b4IsG+Zorbm9AJpNczNOnaI8IIQ6f05Oav/Aeir
   Vc3uhKyYX+xCao5xs3IT7ZKBb+5326B1FhqT6Ybz+vQay0BbjtCy4uWFm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="297971180"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="297971180"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 17:48:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="791145509"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="791145509"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2022 17:48:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 17:48:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 17:48:45 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 17:48:45 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 17:48:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9Gq9F6M3BOx+wtnoU/5AoVFK2OjcsClrt/JxTgbAcFJ56fq42VFOVcBBFbrdHstyBTmi6LJ4MrMcJpzduYFlGVXTABfdfKdJaHdxNjgCG76nhC0aD+wWECBSVFGDBesCkUEf5XsJz+5Y5Y8ElRH6I4hWRa++tbywG8hW2E/gLJ71kZS6wQw9lXKw3bRCzWUsIbTvUVYRjM98Q14wDvFN6HfWqgLsmm78lmSwkhgDwKR5q6HiKWHzlJs20AdquCoDy9Tgtyx6khm+XxgDd/L1MYZ5sgrdWn8AwoDN5bdP/MRLP+I5j1saKT7VFKNr/5JKEjK3Mz507IAz8r3T21svA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmrhgU4AnGCmvVsjnnZPmsy6zpKXPTaDhSPLk4RA5Ps=;
 b=WvnihWmKN37qoI1NOTI8E3AATTg2L6QrzQOhJLA+sw+f6BQNquJDA1Qsp8L87DYp/VniZAfgmGTdylWpmAYXv+Wih9tJdxM/UH2xoBE3uv353mIBJJxPpz0P1FKi409w7nASa8pFIILTH65VYEyVZEvy2wGi1O/Qc6I+u4ZHbOd7TcuW83x4GhhQ+DlyuiIJu5ZkIvz1qGvjzVzMFIbD5RVqKCUzGdt6PsQ9locP5Osh88vQsiVDNxCHgmUBgS8n/K3exham8k7JOQxrxxUhxQlQ2xIy1dsLLf7PCxakje4YhkVYZDNu/hEFCzVz8oPp6ElHRjkcEXedXFv+ZofR0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by DS7PR11MB7836.namprd11.prod.outlook.com (2603:10b6:8:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 01:48:38 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327%9]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 01:48:38 +0000
Message-ID: <492816a9-0b7b-cbc5-9ee7-d5dffe44d29e@intel.com>
Date:   Wed, 14 Dec 2022 09:48:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH v3 4/8] target/i386/intel-pt: print special message for
 INTEL_PT_ADDR_RANGES_NUM
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
 <20221208062513.2589476-5-xiaoyao.li@intel.com>
 <c920ff81-0231-b70f-5ede-b1085c583086@intel.com>
 <cc6304b1-fe60-565c-f561-541ec1c8b479@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <cc6304b1-fe60-565c-f561-541ec1c8b479@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0216.apcprd06.prod.outlook.com
 (2603:1096:4:68::24) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|DS7PR11MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: a34dd9b6-5b4e-463c-3db8-08dadd7551df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dTnas7+j61kxbdH590ocWufVH/Et8ixQ3j4bNqlAypHWywpUfysNb9OhzDKA+DUUdfLp5avoRNOgzNLKVkS7mx6rl6dGzwPL3kDeKjYV0XbAqvZmIkbKoHuwiq5iiBe7+/5bHJ7+BYe9EvIFEOfcRL4I5NxAFxs3wOBmjqGQvmpLtehxEZ4LbqoqQLXrw2L3RymI1EkemDtA1Z+ktbk8j/o/ZCBl8SnJFOzJzEk2psGBOQM1UuBD6+Q7SgInnKAz2x3u+uBzAkTR10EpyjlEgZfmQ8t012xGCYjXsXWDO17tweuaa+aLPxP49PpAFS7bZLCAjo8OSIbo1pzeu1Vrn6Zs3B3U5/xII/rLdvlldzMYXtufd8DIegHK8+psrvDHmX9YwOs60ecRrSuZPBrE1EAzYSGMhbtFu4m2Qhi7nXJfdxNTpIlFIl6i6U0kweLKzRZnNIXW5nWj12ca/SvIBn5LcuoQAi60hSTEvVJ9pQGxDHcYIRt4ywe08HpFFaKQh09e+X97r8Aae3oTL/sgUcG/9fWr/xYXGyc8diuCQFKr8msaaNkG7f/bMwf8RZ7bm448/HzHfTHAVwDqzdTbipwfSgEM6Ath79zEFYtNuJ7E+YFWO0G84xo2Z9BbgXIzSTse1iPJ0ZJbxihgRnOTFm8aslo+t3qV2RV10W7BP05wMN2iK7bEoUl9wxM3lphzDOVxDmesDwfcMVXHUsXmJUZ5KBHoxt78x7RZnYE51FY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199015)(36756003)(86362001)(6666004)(6486002)(478600001)(82960400001)(38100700002)(8936002)(31696002)(5660300002)(2616005)(53546011)(44832011)(31686004)(186003)(316002)(66946007)(41300700001)(4326008)(8676002)(110136005)(66556008)(66476007)(26005)(2906002)(6512007)(15650500001)(6506007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmJ0azBqbW5wVzdoZ0dZb0txUUE2dkhWNE5nMFRPdlE4alNNdEIyb00wc2k3?=
 =?utf-8?B?eURiM1RDdTlOTlBFRU1wZFpTRGNUUjNPd2JiOFNUbU5vSVF6L0E1N0hKTnJ6?=
 =?utf-8?B?bThvS3Q2WFpKc1ZIMUdVWmlKbzl5SjJMVzdhTlVuNEhvK1doNXlxV3E2QXd6?=
 =?utf-8?B?VHVVUnlqT2pzVFpTWStvWUN2S29jWDBVTGt4Ynh6TURWbHFibmI1ZWQ2TkdO?=
 =?utf-8?B?QVo4Nk9kaDFGTkxDRGFZUU5CdmVRS0NSVEpFRlJ3K2tmenlTRlpCWHZSRXFy?=
 =?utf-8?B?M1h3clJVaDZyTTNMd20rNE1Zd2QrTUdKc0hpT0prc1FKWUVRRXhTcHRINDVX?=
 =?utf-8?B?dllyV1dUMWIyOHNXN0gycWtjSGRLTGgxdWROUEJoNitSUkZVdyttR2dyUkV4?=
 =?utf-8?B?L3hxcXJidWQ0U21EQ21RNTVUQUxWOHlRTE02UzlhallqZm45dWtHWktVZ05E?=
 =?utf-8?B?QmhhZzFTZHUwc0NDRFBGaVFFaGhPeFBRQ2txYTl3SWZTOWNvODlwTFR3ZzZW?=
 =?utf-8?B?dHYvSUdTTWtiNmVDcWkySUhvZkc1L1cwcFErb2dTSlA5dGtDWlRPcFR3U1VE?=
 =?utf-8?B?bjJpWHIvSWl0ZzVFaTJXSzdGZDVEZFlGZm9NL05oSmNIUXBNWk9pY1RBZzUx?=
 =?utf-8?B?bXVhMFNSbFUyaWRJeGVBOHJSTzUwMm9XajVUdjdSQW9VekF4V0owYUltcWFa?=
 =?utf-8?B?QmQ1Q0d0ZjdVblhOOUFENjZMc1FOK1NCZlF6eDdUUmU3TGlOemhmOGlxM2RO?=
 =?utf-8?B?TDVwbGxuenJTdVFUdnRCQmpPdG5GanJOOWFHaG5wUTRZT0k4c0NMZFU2TDdU?=
 =?utf-8?B?NWEvbG9zWjlzQ2JlaGVlRlRoMktFZXFkS1Q5Wm5sQVREcEprK0R6VS9MUWxV?=
 =?utf-8?B?blFpR0xXK3U4QnpMZWJERFNoSlVCSFBhc0RpcmVuMzFvMVo3ZTJVK08vR0Rl?=
 =?utf-8?B?ZzZZVjNpbFhhcHBJTmhscldnWmxQSWpDVmVtMnNydjhMeXk5eWRiR3JhUlEr?=
 =?utf-8?B?SUl2NmpWWUtXc0NnL1UxbEFSL2VpVWVuVnI1Q1ZZV2pqL2VOczArRzdXa1FI?=
 =?utf-8?B?MGUwbWFLUXhNTWFHaGZJVXliNjg5ZUZFdXNpaWwwVFJsRjI1UXNXc1NvSVhj?=
 =?utf-8?B?allDbVNwTFZWUUhoZHFsaHRyZnptQTgzdUViV09TYUZGeE9uQ1VWWlIybzJt?=
 =?utf-8?B?cDZOcCtvbzNjQkx1OGhhMThwSEF6VzFFOFBXTVlEYXNOU1RxTFh3SzB3WnBN?=
 =?utf-8?B?aGt4bW0yQlpkVUlQdm4xWUxpbkxHSjEyTlhGMUxOOFRTYjkrSUZVdDFvWElQ?=
 =?utf-8?B?MUE1N29wMVdyUUJ2eWFkMnFVN2xlNUNaWWpZeTU0WE0wWkVkdC93WjhhbzRw?=
 =?utf-8?B?bTEveHkybVZnSWdXUEJNbjIweUo1S1RtQ2tSdTlNczBYVVBmV2VmdmhxeVJL?=
 =?utf-8?B?azAyZHFUeU1rNDZwbWpZZmE0N01qNm12eGlMRExiQitNeWR6T2wzc3NsRzNX?=
 =?utf-8?B?U1I5eGtTZ1owZTl1V3ZFWGZxb3dRay9JcUxicDY3eUlJdmJJcVduYVRIckJn?=
 =?utf-8?B?WGV6THFnMFUrT09lS1g0d2JncHFmY2IvRi8zWEIxdGRHN1lTcDRxNW1TTnVS?=
 =?utf-8?B?WnNheWQyVldTZXhBdy9CSnVGSTh0RTRGbnlBOS9WTFJjTDR2YVRMRzFHTjRV?=
 =?utf-8?B?MmdVa3NSbEhUdGRkRmtXQkpmdXRXZ0s4NkFNbGx2UXdhMzY5RERsamdtQ1ZQ?=
 =?utf-8?B?emc0U2FNUkRWby9RUGJOemEycG5yMnpTNktibkw5Z0pZSTZvZXVMWWRqY2h3?=
 =?utf-8?B?Q3NINkFQZ1lXUU5hRlF1RW5xRHowOGwrWWRLWlkxMStWNlBxS1hGZW4xbWxm?=
 =?utf-8?B?aFV1ZUxTcTZMSkh4dkxwMlJZQzNKSTlMeHNjZW4vNFR2ZDBydzE2ME44RjQ3?=
 =?utf-8?B?RVZyaCsxai9yRVZIaE9OWHZhclpTWWxxeGp1blFsVWlVR3RIdXlqcjhoZ0N4?=
 =?utf-8?B?RkpUOHhId0JYM2dpVjNqT0FlTlJuUTJvRjA1WkF1NHhEaXExTG5nYXBwZlE0?=
 =?utf-8?B?ay8vT3dXWnlzVm90UGtqWkhwN3dLVFpDZWx5Vko4aHA1YnFGT0l3Ykl1SU5Y?=
 =?utf-8?B?TFU2ZFZYZDV3V2tpbWJXdC9sVitGY1NpeklVODRwcGVaSGJqRk5pTHplUCtX?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a34dd9b6-5b4e-463c-3db8-08dadd7551df
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 01:48:38.3655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Imzj1MsN/cEQv+nwI+8uLe2D7/Xxr6neTsCHlBjOjsJq6tb54oHFJ39+CiFQ+NtDB9z4VSsKI+MiD5HaTlwypQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7836
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/2022 8:09 PM, Xiaoyao Li wrote:
> On 12/9/2022 2:43 PM, Chenyi Qiang wrote:
>>
>>
>> On 12/8/2022 2:25 PM, Xiaoyao Li wrote:
>>> Bit[2:0] of CPUID.14H_01H:EAX stands as a whole for the number of INTEL
>>> PT ADDR RANGES. For unsupported value that exceeds what KVM reports,
>>> report it as a whole in mark_unavailable_features() as well.
>>>
>>
>> Maybe this patch can be put before 3/8.
> 
> patch 3 introduces the logic to check bit 2:0 of CPUID leaf 14_1 as
> whole. So it's better to be after patch 3.
> 
> +            /* Bits 2:0 are as a whole to represent
> INTEL_PT_ADDR_RANGES */
> +            if ((requested_features & INTEL_PT_ADDR_RANGES_NUM_MASK) >
> +                (host_feat & INTEL_PT_ADDR_RANGES_NUM_MASK)) {
> +                unavailable_features |= requested_features &
> +                                        INTEL_PT_ADDR_RANGES_NUM_MASK;
> 

Yeah, I didn't notice Eduardo prefer having duplicate error message
showing bit 2,1,0 which I considered to avoid. Then it's OK.

>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> ---
>>>   target/i386/cpu.c | 9 ++++++++-
>>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index 65c6f8ae771a..4d7beccc0af7 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -4387,7 +4387,14 @@ static void mark_unavailable_features(X86CPU
>>> *cpu, FeatureWord w, uint64_t mask,
>>>           return;
>>>       }
>>>   -    for (i = 0; i < 64; ++i) {
>>> +    if ((w == FEAT_14_1_EAX) && (mask &
>>> INTEL_PT_ADDR_RANGES_NUM_MASK)) {
>>> +        warn_report("%s: CPUID.14H_01H:EAX [bit 2:0]", verbose_prefix);
>>> +        i = 3;
>>> +    } else {
>>> +        i = 0;
>>> +    }
>>> +
>>> +    for (; i < 64; ++i) {
>>>           if ((1ULL << i) & mask) {
>>>               g_autofree char *feat_word_str =
>>> feature_word_description(f, i);
>>>               warn_report("%s: %s%s%s [bit %d]",
> 
