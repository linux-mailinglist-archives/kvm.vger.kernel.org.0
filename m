Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6010262B798
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 11:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbiKPKUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 05:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiKPKUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 05:20:07 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885B312A9D;
        Wed, 16 Nov 2022 02:20:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2hFwo9F0dAacHqTkE6CsYdHVn1LZ8WreKUsF4ZiHBrihEiFENMrnJQutcjYUso31g6SgVR0ExkdXm6eJvd+Eg/TL7ozjjyN2oTk9NHqDQTnpRsjrL1xR8xqo0lMnHjBoyqh6bDGnTyJrAaQa7dk+mCplKimCi2WZNP24Oc1slbR5iF85IBS0ulCs4BNjhXhywK2xXOVr1RwcITYjZqS9wUAoznhLCVMqHigg5E7Tcfzsu5TajmZXA8i28HfUAHr2dzco3+Khf1c/ZSUInrN8lZgNmPowSnJfn9TJMen1nmDA5SCIXHBicktC2iesUl7shzByWPukfDL+/RZ5DC6Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0B+4SO4SCmdqLKKG7vS6vUqwAozhNwIbNV6nwBemID8=;
 b=KFWGOI55BUI+16j2vhTgNvl56oK9GO+KnOKgKlBA8aH4S/8beD+ycpQODAJJ3jgflJrYIQ/KLDkyQxNx/LJK2IjSFTeccn8lQbueNPZShpUqTLauRa9fIWrHI0nVwNjTC/f2PI0JH0S0wfnz/Gy0tsg3y8w59+GmEaWST3sb7jKyE4qYaoE0njgoFl2ZOwfK2CWum0SpuoIFuUSfemo5yA8p3v5pDjOnhSenHrgU3QIFmIZgbHKK0J/EdHKNGoehugfQc6U5jVhSqi4jgVt7+7/tvU+uyvodz9cT3zadai7rD3uLGj+Znb/tzNmZA2hcXzxeJLLKmUlb4ljp6QtFhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0B+4SO4SCmdqLKKG7vS6vUqwAozhNwIbNV6nwBemID8=;
 b=TXEfTEe5UB7NLlHVH7IPxVI3H+AA2dmb33gbXqHqF7v6C6Xt0OBANMHQhR9quSkZ6/vZDyt8WGHYq65cV8DW75ToqSQTpBpONok2DpVA7ILmFvs/vwv4JR9r0x1OFaHK1aoFTwrlW2I970uA2yzv7XlFyaLP1MHl2wjcHPrxnTQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN7PR12MB6959.namprd12.prod.outlook.com (2603:10b6:806:261::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 10:20:03 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 10:20:03 +0000
Message-ID: <8692e736-7518-d6d2-ae83-720e42e7a059@amd.com>
Date:   Wed, 16 Nov 2022 04:19:56 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>, Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic> <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic> <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
 <9d9f1afe-c981-4df9-f012-89c4cb783cc3@amd.com>
 <973c6f79-38ad-aa30-bfec-c2a1c7db5d70@suse.cz>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <973c6f79-38ad-aa30-bfec-c2a1c7db5d70@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0043.namprd04.prod.outlook.com
 (2603:10b6:610:77::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SN7PR12MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 097c2853-463d-468f-3ec3-08dac7bc200e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEiFTot3uejJQkwT8xAzoihzZAaaCwibhVthAfKh0RUIAQ3lB3kktgbm/hO7k1ghk+SSJA9+mBrjDn8kCC8r9QTp7X9f4+sC+POZhnAyPLLL8fV1e+LnRWC0yw3+PqAG274YuuN68HnmkcS075+TGnnova7qhHdoVN3hYhBmAeNEA/6Pml/rHtd89NMu955RQ5rdKXTRutEYRwRPh9AVHJ5ly2uYiEUi8c4NdwEVy8ajF0B9bpwqiMx5ROqsnhDCzqe/xF1w+wG+3ApFs2sacGVdkH7pWZlaRoAWKw1V1oMcnRg8naI6uWI7IlsURh6to2WUDrdJ7O5yf6qAQf4ruxks5i1NUHcb5WXP+WcIliWput2mFAihdaITP0vsuRR83gyEEwOu4r/PWgZ8jg2A7hc2z5CR6L8kLYWvF2iSdMJH+MXsEZ3Ml9LzZKfnJHJ68EKdAAAS8vxCv8a8164uNtIpqjleOjd/BYgNuoYvFUTW5xffNJG9jDcB5YJOMBCZFB8hghtvbAocpICuWMpoxIkAXruxCVy+sxg2bhz5ZB8tNThCBJorxRHdk8tWqs84tnEbwgPq3L57T+FPZSp8xieqbTmRzQxJSrd9zrKqIcHq1YWbBk8cYI18mkOvPmJhZoxA+yyFv6DDw+VnqseRwaoBaTdqhtBaYuDZyfBvyVh/FTV3TdZkgaEd5LwVWAMf8ANWsjMKLThqsYUyk8wSVdnyLfmrCwxNIH7UsjPw6O5B+THYgWpSmMntpKerR3W+85KeuTZBBiSXuzhb+CV21v+EUG26yTVvKLSDyeALGRnh5vcCrgcVohKgElJ2QLin
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(45080400002)(6666004)(478600001)(53546011)(54906003)(6506007)(110136005)(6486002)(31686004)(966005)(316002)(26005)(6512007)(7416002)(41300700001)(2616005)(66946007)(66476007)(8676002)(4326008)(66556008)(36756003)(7406005)(5660300002)(2906002)(186003)(8936002)(31696002)(83380400001)(38100700002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTRhYTBHSE92WTVTUnY5dG1vb2s2OTEwc3ZCMGYzWkU0R0laLzBma0VhL2JO?=
 =?utf-8?B?MkdPZFlhVFIxUUMzdENxQ2g4Mm9OQ3lUVWZ2dnJNeWl2S1l5Zmpsc0hTbjlL?=
 =?utf-8?B?bUQveldaY29nbHNJRnJzUFk0WXc4UGJJVUdETkUwRXgrczFKUzFmZEY1ZGsv?=
 =?utf-8?B?ZXNDOUUwVXdmSk5XV29xQ0twd29DWHpYZWZpTnJyVlhGdDBTa1pDV0VpY1R4?=
 =?utf-8?B?MFNFbThTYnZqQ3lDV3NYVjJFcDUxVUtPWU8yN0dxelJFbGU3T3BNKzZVZVph?=
 =?utf-8?B?ZW5zVWM2cUpkcFpkSk4vQmlpeC9IallJTXh0S1lmYzN5RE9oMHJaYzhDVXpK?=
 =?utf-8?B?UjhYRnlvWDd6ZTRLTTNSbGRFR3NnVy9FNGN3ZDBBQVpOU1FtYWFCdXo3RFVG?=
 =?utf-8?B?amhYTGNjVHdIRFF1V1BEREs0Y1pWOUNaZnZKTHVGaWVLSzU5S2htWVcvOEp4?=
 =?utf-8?B?SXVCbFdJaHl0anlxSG5qWHVyZTBXSFlQa1k1NHpMWUhVaUdMajB1WjRMZGNm?=
 =?utf-8?B?ak9NNlNJTnBmWlpVVm1tZVJLdzU5ci9sNk9Ub25GejNuQ0IrbFJHQm56ZFly?=
 =?utf-8?B?MDRDcFM0Ty9ELytVK09tWU9jck96S1dpZWZ3KzhUS1ZlYTIzWW9tZ1J6Uzh5?=
 =?utf-8?B?UzEvcFN5NStVWWRmbkgyUk43dTlnQlFaMDI2R0p6WVpUeGVXTTNDTVN5c2Rr?=
 =?utf-8?B?T0QxZHEvOHNUZ2RxK3E1WGY4VksxYUpSNXJhelN0ZE85WTZTV0lYaXhlYTFa?=
 =?utf-8?B?bTNneEJXVnE1aGF4bmZZSldsTis2c1hPQXVHZlAzckZRYUpySWhXWEgrbzdE?=
 =?utf-8?B?b2N5dHprbkpMc2ZEdFhyOW10WnlUVkk5dklRTmlBNmNBMGtzT293dkN5MUV4?=
 =?utf-8?B?YkREYldLcUFadHhNU2xTYkJNZksrUE5KSHJCSWtLaUc0T3FlN1pSSndxMzRX?=
 =?utf-8?B?RmUrenBRR09YTS9FZVVLbWRHWkVzaU54bG8ydmRzZmZxckxDQy9DeUJ3MkJT?=
 =?utf-8?B?MWNOSjFKVkhzanU4WnVVZFVIRHU3M3Q5QmdsNkI4K3FIWTNPQVNWN0RqRGZU?=
 =?utf-8?B?REthZ0tYSVlXWXVRYXpSalVOTlluYzViaElKc1dUZm1YcFlQWm1qQXJxcDAw?=
 =?utf-8?B?bU9OTU1LM0NEUUdaYThzZVZPbzFxdUdJSXAxTk9qUHNLa0pGNDRHeHBvVDYz?=
 =?utf-8?B?dFc1UytZYjNITklVUUVnVlMvV0lYR1RJc2crcG4zOEw4T3h5cTJXc0RvWjBP?=
 =?utf-8?B?Z3ViU2ZKN0dKOHppcFBiamJTWTNCYWRxblZrMnN4NEt3bEFSZVlEU0NGMlJB?=
 =?utf-8?B?K1o4YW5yc2l4QnU5Zk9LYmpwRldabU0vRm5ia3Z3UVk2ekN1OVdjU2NNWHY2?=
 =?utf-8?B?NkdlRUdDa3lvNFY4M1I1bmg4V3d4V1VjenhBVTI0ZVNESHdyc1hKbkVVaHN5?=
 =?utf-8?B?L0t4QjhRdGFnbG9PKzB3TUZnazh5Um5seFBUczhJMVVyTzFSb2twOWxyWC9n?=
 =?utf-8?B?SDhFdTA1THZCUm13MXlvcjFIRU9nRzRZRTlINnJHcDV3Vk8ybTU5Q0dSZXZP?=
 =?utf-8?B?RVZ5YytCTzFlbWhIUU1TZnFtZ2d5cno5WWhKam1zSkZDZzlSTUNGaWUzMnZJ?=
 =?utf-8?B?R2h4YUNjWWFzSFJxZkxtRlowbE9HOHRzVkxvS255dkdyMEQzdHU2ajc1bW9X?=
 =?utf-8?B?VzNpanl2VThuSHYrMVFGSkZBWGp1UUZWSHJjN0tZQUJHL0ZHd3dvdVc5UTdK?=
 =?utf-8?B?Ukc2ZThTZU16QlpBNmgvU2hmT0ZmeGxzd1NUa3VqSjVVMC9oa1pYUWFtV3VM?=
 =?utf-8?B?RXh0a0FZSzl0bVVCMTFuejV5WTZyYWFsY2FhRW9GU0NIaldmRTY2czlXaEt1?=
 =?utf-8?B?VldId1pTQ0dINklpb1pZZlVXUmRuSGZWdWZzdHE2M1VBcnNFaUFYaklSaGJr?=
 =?utf-8?B?S01WY1JIRkJ1YzA0QkN2cHppZHMrdTVTYlAzMlo1R09zUGdvbUxYSW5DTmpG?=
 =?utf-8?B?WXo1MHdFdDZTOFRWZmZwdEQ4TzdZdHcwRjdMZ0F0d2wrSGdCQ21KVHVFQ242?=
 =?utf-8?B?d0JNekZ2c3pwaFFZZWphUDlSS0JHcXNieGJHMC9HMStTRVFzM2w5b1Nzb25L?=
 =?utf-8?Q?yUhlxXMf+G02ecJbJIrOS7Ttt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 097c2853-463d-468f-3ec3-08dac7bc200e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 10:20:03.3492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CKnpBdwPGDgyX8y5GnmZ2GTN1gISvZnumBl9khP22dC4NJ0GDniQ9WDyWAJ54R4a4+1ywlYMp8jONgZkSRBIow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6959
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/2022 3:08 AM, Vlastimil Babka wrote:
> On 11/15/22 19:15, Kalra, Ashish wrote:
>>
>> On 11/15/2022 11:24 AM, Kalra, Ashish wrote:
>>> Hello Vlastimil,
>>>
>>> On 11/15/2022 9:14 AM, Vlastimil Babka wrote:
>>>> Cc'ing memory failure folks, the beinning of this subthread is here:
>>>>
>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra%40amd.com%2F&amp;data=05%7C01%7Cashish.kalra%40amd.com%7C38f8b76238014c67049308dac7b213a5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638041865033588985%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=DDm7tZhUJLy%2BMzS1SXUnsBmBQnAI5dqR6tWZhCKRMEI%3D&amp;reserved=0
>>>>
>>>> On 11/15/22 00:36, Kalra, Ashish wrote:
>>>>> Hello Boris,
>>>>>
>>>>> On 11/2/2022 6:22 AM, Borislav Petkov wrote:
>>>>>> On Mon, Oct 31, 2022 at 04:58:38PM -0500, Kalra, Ashish wrote:
>>>>>>>         if (snp_lookup_rmpentry(pfn, &rmp_level)) {
>>>>>>>                do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
>>>>>>>                return RMP_PF_RETRY;
>>>>>>
>>>>>> Does this issue some halfway understandable error message why the
>>>>>> process got killed?
>>>>>>
>>>>>>> Will look at adding our own recovery function for the same, but that will
>>>>>>> again mark the pages as poisoned, right ?
>>>>>>
>>>>>> Well, not poisoned but PG_offlimits or whatever the mm folks agree upon.
>>>>>> Semantically, it'll be handled the same way, ofc.
>>>>>
>>>>> Added a new PG_offlimits flag and a simple corresponding handler for it.
>>>>
>>>> One thing is, there's not enough page flags to be adding more (except
>>>> aliases for existing) for cases that can avoid it, but as Boris says, if
>>>> using alias to PG_hwpoison it depends what will become confused with the
>>>> actual hwpoison.
>>>>
>>>>> But there is still added complexity of handling hugepages as part of
>>>>> reclamation failures (both HugeTLB and transparent hugepages) and that
>>>>> means calling more static functions in mm/memory_failure.c
>>>>>
>>>>> There is probably a more appropriate handler in mm/memory-failure.c:
>>>>>
>>>>> soft_offline_page() - this will mark the page as HWPoisoned and also has
>>>>> handling for hugepages. And we can avoid adding a new page flag too.
>>>>>
>>>>> soft_offline_page - Soft offline a page.
>>>>> Soft offline a page, by migration or invalidation, without killing
>>>>> anything.
>>>>>
>>>>> So, this looks like a good option to call
>>>>> soft_offline_page() instead of memory_failure() in case of
>>>>> failure to transition the page back to HV/shared state via SNP_RECLAIM_CMD
>>>>> and/or RMPUPDATE instruction.
>>>>
>>>> So it's a bit unclear to me what exact situation we are handling here. The
>>>> original patch here seems to me to be just leaking back pages that are
>>>> unsafe for further use. soft_offline_page() seems to fit that scenario of a
>>>> graceful leak before something is irrepairably corrupt and we page fault
>>>> on it.
>>>> But then in the thread you discus PF handling and killing. So what is the
>>>> case here? If we detect this need to call snp_leak_pages() does it mean:
>>>>
>>>> a) nobody that could page fault at them (the guest?) is running anymore, we
>>>> are tearing it down, we just can't reuse the pages further on the host
>>>
>>> The host can page fault on them, if anything on the host tries to write to
>>> these pages. Host reads will return garbage data.
>>>
>>>> - seem like soft_offline_page() could work, but maybe we could just put the
>>>> pages on some leaked lists without special page? The only thing that should
>>>> matter is not to free the pages to the page allocator so they would be
>>>> reused by something else.
>>>>
>>>> b) something can stil page fault at them (what?) - AFAIU can't be resolved
>>>> without killing something, memory_failure() might limit the damage
>>>
>>> As i mentioned above, host writes will cause RMP violation page fault.
>>>
>>
>> And to add here, if its a guest private page, then the above fault cannot be
>> resolved, so the faulting process is terminated.
> 
> BTW would this not be mostly resolved as part of rebasing to UPM?
> - host will not have these pages mapped in the first place (both kernel
> directmap and qemu userspace)
> - guest will have them mapped, but I assume that the conversion from private
> to shared (that might fail?) can only happen after guest's mappings are
> invalidated in the first place?
> 

Yes, that will be true for guest private pages. But then there are host 
allocated pages for firmware use which will remain in firmware page 
state or reclaim state if they can't be transitioned back to HV/shared 
state once the firmware releases them back to the host and accessing 
them at this point can potentially cause RMP violation #PF.

Again i don't think this is going to happen regularly or frequently so 
it will be a rare error case where the page reclamation, i.e., the 
transition back to HV/shared state fails and now these pages are no 
longer safe to be used.

Referring back to your thoughts about putting these pages on some leaked
pages list, do any such leaked pages list exist currently ?

Thanks,
Ashish

>>>
>>>>>
>>>>>>
>>>>>>> Still waiting for some/more feedback from mm folks on the same.
>>>>>>
>>>>>> Just send the patch and they'll give it.
>>>>>>
>>>>>> Thx.
>>>>>>
>>>>
> 
