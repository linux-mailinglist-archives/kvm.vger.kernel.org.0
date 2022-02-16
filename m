Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67C44B8699
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 12:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiBPLZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 06:25:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiBPLZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 06:25:15 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5DD97B8D;
        Wed, 16 Feb 2022 03:25:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHn2cyv9hQLoZLFTrTBUnlGoRt+tCIDaor3tfwYrHNdsPdh80tw11vxckMG2iNoA92efFZanGvXbrKady9EHbaKtBfD6i3lVPYouCiA29IdCGFv3qURb0H1jqNVfYu9ePEJjVsqEhzTMn6PCQRua981llcYX/CRVRtQHlT9Ptz7eY6x86efiyCbZUTA0fXNtzkgwqvq3n0BsDOpSgu+CnXJqz5u2lK7Xaf7GiCD3TvM+lyawZNQ/Q258cdziMUKPNAhOwFN7mkEG0IeB2A5qMgEBTaHlqWnWgzy+GmM1R9kfugoq4t2GoQtNrpXO9rF8kW08hoXx4piREjIUx5LRgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEmELowk0T9nwZSfkvdpb3kJXu/Dn9miGAJsj4HQyIQ=;
 b=bK1MxSGJRjJKCSpz6QIwSIYnNcxujJw+POhU+853OQRyiN287RHazkizkadFG9uCf7mBNDA8FOLzquD7PlGUu/eJbNFlmPr6WTSUO9SqB59oaLhd/v0YGmSJA5cVmvxOR0AZRTExHx/KSQIanE/XVcttcPaab3FILWqSeJRoNNDknMqFVpvH5NsrBNF7Dqi6ugplgvxLd0pNBYEBRuI3ZdV3aGLfQ9GtgFpM6SROG1TwSlewGhkKkRZ7sadrWlowQGaYM7iJteNiw2tI45nYM0B3jxPc7z4q7nH1fnlU2ZPP2NzpJil17oyCAEqBsco/Ql9CRE15gUahrbls0MkXag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEmELowk0T9nwZSfkvdpb3kJXu/Dn9miGAJsj4HQyIQ=;
 b=u3SHesq+/dgb8qIiWD7hHMf3AuKxP83R+8lH4vEcSdns8cTUIJOSTBUsAiKZ7WFUoc2F4XSbYo09eLCaovRAWviZF3f5KHYUZn+mAd6lgC3XjdGB4Jc37N3VbE8Qp5af6Wkp6ZWd30fm7NlzK4CxSlfI8ukvs7t14qOJVYnNhiY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by CY4PR12MB1751.namprd12.prod.outlook.com (2603:10b6:903:121::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Wed, 16 Feb
 2022 11:25:00 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b%4]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 11:25:00 +0000
Message-ID: <146a96a7-dfc0-6ab9-0c9f-5c07a229bf1f@amd.com>
Date:   Wed, 16 Feb 2022 16:54:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to
 pmc_perf_hw_id()
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>,
        Stephane Eranian <eranian@google.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com>
 <7de112b2-e6d1-1f9d-a040-1c4cfee40b22@gmail.com>
 <CALMp9eTVxN34fCV8q53_38R2DxNdR9_1aSoRmF8gKt2yhOMndg@mail.gmail.com>
 <3bedc79a-5e60-677c-465b-3bc8aa2daad8@gmail.com>
 <d4dae262-3063-3225-c6e1-3a8513a497ec@amd.com>
 <CALMp9eShc-o+OZ3j4kDkTbXmY58wQu6Rq6qviZAHsDr4X21a5Q@mail.gmail.com>
 <4373e8d7-e3e8-164c-75e3-6ca495a79167@amd.com>
 <71689d29-caf8-ed7e-2cd7-61cbab0fc7e0@gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <71689d29-caf8-ed7e-2cd7-61cbab0fc7e0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::16) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 691dd116-8f58-46da-ec90-08d9f13ef7b7
X-MS-TrafficTypeDiagnostic: CY4PR12MB1751:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1751230A4B3A48BB0B90F848E0359@CY4PR12MB1751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bEvdLlj7XurNxrlkrau1hJjpdpkPv2KVlUOkq5zeNe6/RJaxH3TJlesehQphc+FLYXdsLCiBez0y7QB4vpCrrXPnB1rinJsFWTgv74mleO+5ON2c81Q2PWP1xIGEAN9DOedcH2i2nH7xu+HsSy5K8K8XU6euiYyOpncz7T5nSYR2gcd4xIE/iNm8zks2z2Ie+om0+NThBjIDUmvp6VKMvPSyhDeaeMVHy64ZVTGBLGJPgw62PqTQz1763UMwf842pzUBlY3lls111xC7nB0+Oth8YrsmKz0JFr2ImhI/W1obbRpnb5xxPTL1wffXrg2IL9qdbrlEcKaT+mf/98zjQqV6FvwWpOtL2IUyd3y/KMF4JvYfVZiAOi1VySa5T3a+/NbfhzyqLdPmI42PwI49ezUFu8ruK72p9jX1TOWHwlsQxYuKZonw61wvLs0sRFOtll9k+RNghPx9iOHsh1BCknBICA0lviV6EihL/cs6YO1Si4IRqLhWmQVmtJrOvIFKf+r6sgrWFLvO+rXZntwjk1q+5zyF6QYo5q6ZwEi5e70aIwN3eK0BIN35CFxH1blrEsZLsbi7Gikm0C0prypKMJfSefAoZpcU92hRMauCHze5neGGVrXXa9E0jqVtnvLLbUd6vRYzD7OE1GcdROlujpJ8l+jyC4SgoUyt8jfvZaXjS/LaFJUI/2Vt6dx9e0dDWCRZ77AgZGhfFZAuguBdL/bek3fv5TM8rrzmqtSl4Tw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(54906003)(6512007)(26005)(6916009)(53546011)(66946007)(316002)(66556008)(186003)(8676002)(66476007)(83380400001)(2616005)(86362001)(4326008)(38100700002)(31696002)(2906002)(44832011)(5660300002)(31686004)(6486002)(36756003)(6506007)(508600001)(6666004)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjR2SW5ZOWxRMjdwTUk0d2pWcUxBaE9pZkM5cDRWb0k1d1YvQ3V6WXVJVXpO?=
 =?utf-8?B?aDExVmhFZ3oyT0ZPSmpYZ2RPeEp2ZldLcjc2aXU1MUdzdFNjcU16eXd0enVO?=
 =?utf-8?B?WUVyQ3FOSUFESS9TTm9BdzMvcUUxUW0xWDVIbjBTcWxkNmhXNE4xNDVRbmhq?=
 =?utf-8?B?MTZZRitiVjFqMVVKekVsSTJnNWtqc1ZQS0dSSU93QmdZeVdrYXJyK3ZlT0ZG?=
 =?utf-8?B?Sk5TL3g4ckxEQlV4VTQ1aHdxVnVwbGVjOVVJSm9nZGU5YUt6UXhjT0I5dDNB?=
 =?utf-8?B?RHh1WGl2cWZ3bTVXV0w5N2cvb0dvT3h5Y2JPOW5UdE04R1dKSCtDY21BeTBH?=
 =?utf-8?B?RlgwNXdsSkxFWkZmT3pBcWhlSUIrNFZvNWRZcGlyNWNGME1waGhoR2tpMHMv?=
 =?utf-8?B?VnlkMTZqWG9pRnlRcjdFRHpJNVE5SDNFNG9DQUpzRkhzS2JPN3BHM2Z0Z0E0?=
 =?utf-8?B?MTJsbC9XQnByYldSRStJamV5NDV2Skw1UVRvY2R4T3JvaTNqK1BHYngvQ2JG?=
 =?utf-8?B?d3pBSVMwRWl0WndhWTl3T3ZCZW1xendkUVR0dlp3empuMFJrTlhtaVZvN2RU?=
 =?utf-8?B?NmtUY1F1Q2pPakF1eFFoWmM5SUN6Zno5alRYT2lQSjhpejR0MTNPdENaUUM3?=
 =?utf-8?B?cGdBcmF4TXM2YU1uTHM4eWpqRkhPajg0b09WT01uREo2Z0xIRm9pYzMxYkRR?=
 =?utf-8?B?Y3ZmSUw0eDZnNDl6dWpDSml5QVRnM0JTdlBaK2VBdW11ckl0MkxGQzA3bGQx?=
 =?utf-8?B?YjEzelRJSTFsQ2lUT3VDV0dDWFdOSkpYOHhyQTNWRm5LSWtuQzRKaUo3bDFo?=
 =?utf-8?B?ejBkeEc4Umx2SzA0WDJtbVRHbDhaWU56VXhEU2RHMnhWQi95TTZRUjVUZEh3?=
 =?utf-8?B?U2l3MWF4TWlhQ2lNc3N3Y09BOWQ4MG1zdExsZThKbTZOK0JoM0RDRHpEOVpJ?=
 =?utf-8?B?MG4rMUFQektrVzd0NFhOaFJxMzBnSUZUOWFEVGRwb3BaNzZRSWpHYzdpZXJQ?=
 =?utf-8?B?MEZORXhsN2tGa0t4TFp2WStFUUxJWWREZmdqdVNGaWw5dlNmL3NoRG1OMjA3?=
 =?utf-8?B?dlA3bE95RndiQ1d4bTVvKzBZRExUTklRUzdDcWtMY3BEa1FvSFk4WnNwR2ZS?=
 =?utf-8?B?YkRZMjVkbTNXekx1OWsrZTVrZWhlSXdlVmVKWUxsOExjZFc5VXVWeXo0Z3RZ?=
 =?utf-8?B?YWg4MUdiWnN4K3lPZEFaVmpna1hiWmp3UC95WDVpSXUxUzIzSFQ5ZGY3clBt?=
 =?utf-8?B?T0xDVjZTNDVjOUFIUmEzcktILzIyZGgwbVI1a2J0a0tQeGxsZ2VRbjVoU3Bs?=
 =?utf-8?B?ZDl4aVpreDZoSlZNUXhXUWw2aytyM1BkNkJ3MjhBWC9wOXpRZU5MT0dxK0t1?=
 =?utf-8?B?SXEvZFhHcXBpUEY4VVA4cnJDYS84UE1FazJnc25TYXhobEZlN2hKS0hUc0pp?=
 =?utf-8?B?bzM4UmM3TDh3bkkwdk9MbmJkbkNaVkJ0K210SlpWb3VSWU94OHg1RnptTkZp?=
 =?utf-8?B?WEU5MktaWkJVbVAveDRsWE9ia2wrVk9ZUFhPZnNIZEhEMGM1YXU1VnZYOUFB?=
 =?utf-8?B?NzJqM2M4QXFia0g5b3lidXhFVm56TlpSRzhhTEZVY1ZPc1RRcHowK3p5SmRE?=
 =?utf-8?B?eTVJWmhKdGRqbW5xY0EwOCtqMHcwVW1pMFV1cHRJc2QzUkJib2NzOXpBWnlW?=
 =?utf-8?B?RTk2TWpkc0FyemF5d3RwTm5QbFRwc21QbVhIS2FUcENDN1Rqa3dGbG93TW1X?=
 =?utf-8?B?Q0FRNTIyS1hRN29YMGp3R2ZsejF4WFpKZWtWSFRsQVk3Q1U1Y2djeFJWWHhT?=
 =?utf-8?B?bEZ6YVFENzFYa0JQUTZVdFhwa09iOFZHNFJJZFdUd2NsbDRQYko0V0x2ZmxY?=
 =?utf-8?B?NXcrdk9yUkRkVjZpZ1F1aGtPQStxRkFYZzFmbjFiTkt6N1VsbXBFcU04bVZq?=
 =?utf-8?B?NzFrcjZXTEFPMW1IQXcrZjhBV1M4MkdpVlpVUWM3b0pVUVFQUXBwQnJ5STI0?=
 =?utf-8?B?a2paMUYycXRtVDhIYVV1cEVUbjI0Y3FOME4rMGkxcUR2MVlXc21XaVkrbEZr?=
 =?utf-8?B?bjV0NDdnbkI4bVU5Q2x1ZW1Ka1l4QmwrRTdRRTVadDd5ZU1JWHdRakMyVG9J?=
 =?utf-8?B?Mm41SG9ONFBSK0hWN09vNXNsbDhoWC9ZZGZlOHNXNkNyMUl0REVDc0crKzBN?=
 =?utf-8?Q?BByfpFIHLM6bt1ksdI0rnUc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691dd116-8f58-46da-ec90-08d9f13ef7b7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:24:59.9990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: po2lqCucMgoTl0I2rwmKyEOc+BMKRwArGYy+u1EI61XZgRjR8dg1S4RoVqs/EYJ0lhLPRKEN7+/kAmunDjghmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1751
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16-Feb-22 1:14 PM, Like Xu wrote:
> On 14/2/2022 6:14 pm, Ravi Bangoria wrote:
>>
>>
>> On 11-Feb-22 11:46 PM, Jim Mattson wrote:
>>> On Fri, Feb 11, 2022 at 1:56 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>
>>>>
>>>>
>>>> On 10-Feb-22 4:58 PM, Like Xu wrote:
>>>>> cc Kim and Ravi to help confirm more details about this change.
>>>>>
>>>>> On 10/2/2022 3:30 am, Jim Mattson wrote:
>>>>>> By the way, the following events from amd_event_mapping[] are not
>>>>>> listed in the Milan PPR:
>>>>>> { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES }
>>>>>> { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES }
>>>>>> { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND }
>>>>>> { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND }
>>>>>>
>>>>>> Perhaps we should build a table based on amd_f17h_perfmon_event_map[]
>>>>>> for newer AMD processors?
> 
> So do we need another amd_f19h_perfmon_event_map[] in the host perf code ?

I don't think so.

CACHE_REFERENCES/MISSES eventcode and umask for Milan is same as f17h.
Although STALLED_CYCLES_FRONTEND/BACKEND has been removed from PPR
event list, it will continue to work on Milan.

Ravi
