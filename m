Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C3362A032
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 18:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKORYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 12:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiKORYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 12:24:12 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D5924F1F;
        Tue, 15 Nov 2022 09:24:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIPoQ/RIssKOlh01j+7OIisk7ZaVqCdLIOz7UU0ugA1A5nWOh6uu7gTxLN/wSPX8XlLYdXRpgHLirBRbL3x++N1zqjms+d+mEpb8LeYHRWbcrGtsBo7Bi7Ujwdj7ZQBjK9yFSELwZszeS6pkFDFf4L5phgnhqgUUCWjuXxBGZIrqOlkCh2JhPvmg4dmUaPsslHTG20LLNTibseuSgXXYOYpIiszczCannKdYoy+D78/CvNYoCQ5uLApv13U3YlFeHie/6DVof/UyCPa2GpLY7Sc/5UDw4XXmjDj2YVkLsXWJrcpWQUCYZpZnUdzvgcSedkMuASw7RiFXEbnjsxy5DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zBigR8drfdApnEbZXyp088XEHmr/S0t0MGMTQJ8bLBs=;
 b=WNd+uMNgL+VMvA9pHuHLL6gVZgdtkBu5aG8nWqvnOnYb0/vgvR3SL5mfzy8tg6qhekWItt4GEhYTUX9sDMBuW00UHvpoahuTjbwBZyzW33h6c6Xs9Vu+KICQZbXcGnb5rXaJC9csNOX/bXY6xzT/1Sh3E3zRtLi5jsA+3+fiwcDEV4CC2L5LeCHNosQ0oXRwpf4So7sg+twJbbqbazZkvmsY2UcWmrxKjZ/o7n9shtrC4Q4djEn+n3nOZnNi25z9wu8gcKqUOozMRG8xzi6ejzHX3/VMjwr0iJbHz0sK3jJrQTFWPgAXEvJB9B66bAMeitEPXXeUaKCNK7qeFjsQ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBigR8drfdApnEbZXyp088XEHmr/S0t0MGMTQJ8bLBs=;
 b=U2BgTuJF4z+JfkZOiQJRM0PvfUwt8fSIqVCPGdawOlgXtZ5vSmYIhpTOPCcj1dFJdMBKW7DQZnQ0+prMGVXgPC8FoL0EUWecFpXE9Qmf/8bhxO80LqeZ7yFOsIKbu4NELCiAJb7ZftK0h8j5/IFaIxXBFkRYRfpSh8vhqB6sXfE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN9PR12MB5082.namprd12.prod.outlook.com (2603:10b6:408:133::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 17:24:08 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 17:24:08 +0000
Message-ID: <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
Date:   Tue, 15 Nov 2022 11:24:03 -0600
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
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BN9PR12MB5082:EE_
X-MS-Office365-Filtering-Correlation-Id: b5a848a4-4bff-485e-8369-08dac72e3445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: POjaLthmdaGWZlKxoEaeCCnSOI9ef9eK7t+HPjyc6HAEFgx7W+b0n2WP1v4X0GY6K5si2g8l9v/280Vp559bBjzYUqlkVk9XtIfy0oafleLrNWk3HlUlvTexjVcmBKq80G4lj2fY8wLNGpMLId3IXoCEy5p7ROkifjywup7jiQFIbUBAF4y0/MCpRLjVEqlE2QQtigyMyVyvmqWjD0h+vE8qn/aZMoOJmsvQxEdBJ/Ix7dInQmrYsu+jfQSJl8PiS/et85WWpFxSeVXIcgk51zk1z3ReMoTMvUVSBkZQMJyKSQx4PYSy5YEA+3XtOUh6zIHWE1FlPspXKRGYJ8GwKX8xVhzwVDjqgH7DiyVs4+nF0duE3CKV3sKC5Iz7q6X8C04UWLjAEnbsPy0Ysth4o9nWfGXfRcPNC3bE+Lj0LUHiQ1WlNUAWoA5BDdYm8uoQku+kMoWNr6OdTHbnPw2Jrgt7ScYZF7i591f46b6wASCa3o7UGklDGuOxG9GdzdV79s+yykW7dYiORZGSSpGoHWePTnBCNp49GNEpWmBHWuQbKnOni86H31W+2SedDSY1Zib0ChVuDQ10t9wal2UUDmeP+W+bZuszMDiJEJlBz6j3tE0WIcMKnpuerr29QOl3B3ABFPf8cMDOWfzWyaHJgV3ZJQFla6s8Dq7RDbPgkzOuAv4NBYGa0X6dPbvUibwcboVpBBi9iE2jQEGdBlOSJdwuxksh7YZ17Dnrtmzih8gGFgBCHs1edHcyQvuGW2EDGJLafhi4ppZs4LURyAdwbjxLW5IcumfJxQlO7yt2w997HdAsA2kWuccBIpn6kn94890WM13vwjGmoqYvN4gNsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199015)(41300700001)(31696002)(31686004)(478600001)(2616005)(4326008)(966005)(8676002)(6486002)(66946007)(66476007)(66556008)(36756003)(110136005)(2906002)(54906003)(6666004)(186003)(83380400001)(5660300002)(86362001)(53546011)(6506007)(316002)(7406005)(45080400002)(7416002)(8936002)(26005)(6512007)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWJwUldCY1llckNWdjRQems2RnlWa0ZzWDVkdEljL2tVNkJxT0RXdzhJMUhm?=
 =?utf-8?B?NFlybUh0ZFlFeEszNnFCZjdEaUl6RU0raEc1dHJNTGs1K1pjS3VpWTVqQ1FD?=
 =?utf-8?B?Zk9UMHZhdE9vVnVCdGJ3Zytxc203czI1VklUYmJ2dnZybkNBcmJQTHlHUE12?=
 =?utf-8?B?RVlkcmZ1Z3ptd0NyYzh2NWVvbTI3RzQ3N2lSSzk3ZkFxdnQwc2lXTHhCeGxF?=
 =?utf-8?B?OXRib2pNcUFVazhGNDJibm9wbHlVNG1lSHFvaWxuQlR3bjRMMnhpTUZRTFlU?=
 =?utf-8?B?QnVYc2ZXVDZYK0h6YXFzY0lCTzhJSHBSV2VxR3krdlozcUtKTDF0dmdsYlpF?=
 =?utf-8?B?NWRHa1ZnejBoVFBEYWVITmZpM0txT20vNXp5OXNEUzRyR1c5STJmQ1JTU0d4?=
 =?utf-8?B?cisyWkg2NnBtNEZibkxBNUJKbU9ncUxVeDVsOG54aVNWVkN6Rm1XcjBJM2Fj?=
 =?utf-8?B?bzdmOGRGSXF1bXRac0lpV0p6REU1eTBCcDQwaGVNYnJNMEVXbFVWMXh1eS82?=
 =?utf-8?B?RU9sR1Ira3NhNlBVVkM0NUJrdWFHdVB2UzFYeVU2cVd1UktBWEVWSFhwQzZP?=
 =?utf-8?B?VGN6Z2xJNzNqbldkS0JRYno1Y0VOZUYvcWswMW01UUNXei85MjFKWTd3UlN1?=
 =?utf-8?B?bUJ3SjlUcnE5LzcrTmNMdmF2bDdjNTJyeTQ3aFM1cE8rTjY4UjB2TzNMOFJH?=
 =?utf-8?B?eStBbmdSTG9zazc4WTVGNlVFb2YwTFNJMVA3aGdPT1dCWmdPMS9BaGIzRTlC?=
 =?utf-8?B?WmJXdXY1OFA0WjIxNVJrZlJ1c2czWDlJL0NIV3VFYk54Rm5RMnVPOWx3dHNj?=
 =?utf-8?B?VnIxNTd3M1BLK1dwOFJGSittL0lwUytYUmxoM3pPWlQrKzJEVHlHSTRRMXgz?=
 =?utf-8?B?L0lOcFlDVWp6WERoeFgyWjhrUFRuL3RZdjUzYzBYNTdKUTJsaXVidnVhOTF1?=
 =?utf-8?B?ZDllRUNBQklaNGg0cjA5VUIvaDlJRlMrTnJLMm1LRnZkWjJxT0FHdk1uSlpO?=
 =?utf-8?B?TFBqL0NHYnNUaW1vYmVuWWlaNG41L0RvQTZ1Ui83TDJaeVVlZUV5OGxyT2xW?=
 =?utf-8?B?b284bzFVdjVOL2Y0MXExTmF0Zm5tRzNPVUMvbmZIOXgyWXZ3TS9hMVdyZEd3?=
 =?utf-8?B?ZEpneWJjb3IzQzNFVGdmeW91VnpwSEFyMk1hMjBnUGN0akU0MUlxNDk0YzhN?=
 =?utf-8?B?d2R6MFgrTW1WOFE2c0pld056SGY4WGhiZW5Wd3VmMkpxdkVRUXV5dmpzRmtN?=
 =?utf-8?B?NU5lNEUvS2M4VDBZM3JSSDkvcW9XWW9PSldjSkdnM0VuS2hna1UwU09SVmZ3?=
 =?utf-8?B?aWF1WTNWVmRjc0V2WUJQTVJsUWExcnZpRjNjM0VNVGtDYnR3d0pmOTNsR1Js?=
 =?utf-8?B?VnZDNnUrU0h2UlBtZFQwTzAxWWR4UXNnZXpTU1crd0cra3hyUHZGc3FPdkhN?=
 =?utf-8?B?UmRSQ0FVbGRiZ1lMb2RySVBTVVJKYkhXOWFWYk9PaTFEUXA1bDcvK1lzSGE2?=
 =?utf-8?B?Qjd4cjJkZVF5Q09ERkZXNks5S01YNWlSZFFBaEt2TDc2eXFMbVZHVUJOT2Rp?=
 =?utf-8?B?VGM1Z3BOWldwWHFYTmt1K1pDT3lHd2pISEFqc1F2L294cGt4UXlseWVkRUpt?=
 =?utf-8?B?aGx3UThmVlhiYXBVdWhSZGgyK1Q1b0F6WVZCZmRWSWxQZzNxZERWQWFEbkVp?=
 =?utf-8?B?WEJmUjZmcmxLbDBZaTJSbngzMHc3Z2tUeHBlWS9DL08rd2Q5YlFlZm9vQUdi?=
 =?utf-8?B?WHZsOUk3cTdXMVZFcURvZ2lUVmNWeVRYRVVLWnBXVnhsZFptcWl6QWdHbGll?=
 =?utf-8?B?OHhxRXlTNlB3dVQ3dUZsaSs1dEZua0g2UHRFY1ZnZDB5QlFpc1FvSG8wVEQ0?=
 =?utf-8?B?dHNISDkxckQ3RFFuTmk0NkJaTk91M2tVWlh0Z3l5N3BpNXdiQlVFN3NVSHdN?=
 =?utf-8?B?VHh6R3YzVDFVV2pVdy9oMktHLzJ6TSs5Wk5FL1dPL2ZoN3duczNjbjkrL0Vu?=
 =?utf-8?B?SDZITVZacnZ5WDhrc0M4VWJPMHZHWE41dkFqYktJV2Zac2U2NUdRd2NnbXRC?=
 =?utf-8?B?ODAzbHBRRHdtN3MrYkcxYjhiSVZ5NnFlYVZZYzZPZWYrRFJKUk9wMVgvdnE0?=
 =?utf-8?Q?42elpRg2GRgrjbbEXSpwMHnM+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a848a4-4bff-485e-8369-08dac72e3445
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 17:24:08.7459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jN4g1vkMLOhEEbL37Ihi4IxKX73xnQj6GIPEfnpG8STTK8tyXjqIJ3cHr/+EVWKg+QYJj1Z47+hoB00DMdZnmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Vlastimil,

On 11/15/2022 9:14 AM, Vlastimil Babka wrote:
> Cc'ing memory failure folks, the beinning of this subthread is here:
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra%40amd.com%2F&amp;data=05%7C01%7Cashish.kalra%40amd.com%7C944b59f239c541a52ac808dac71c2089%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638041220947600149%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=do9zzyMlAErkKx5rguqnL2GoG4lhsWHDI74zgwLWaZU%3D&amp;reserved=0
> 
> On 11/15/22 00:36, Kalra, Ashish wrote:
>> Hello Boris,
>>
>> On 11/2/2022 6:22 AM, Borislav Petkov wrote:
>>> On Mon, Oct 31, 2022 at 04:58:38PM -0500, Kalra, Ashish wrote:
>>>>        if (snp_lookup_rmpentry(pfn, &rmp_level)) {
>>>>               do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
>>>>               return RMP_PF_RETRY;
>>>
>>> Does this issue some halfway understandable error message why the
>>> process got killed?
>>>
>>>> Will look at adding our own recovery function for the same, but that will
>>>> again mark the pages as poisoned, right ?
>>>
>>> Well, not poisoned but PG_offlimits or whatever the mm folks agree upon.
>>> Semantically, it'll be handled the same way, ofc.
>>
>> Added a new PG_offlimits flag and a simple corresponding handler for it.
> 
> One thing is, there's not enough page flags to be adding more (except
> aliases for existing) for cases that can avoid it, but as Boris says, if
> using alias to PG_hwpoison it depends what will become confused with the
> actual hwpoison.
> 
>> But there is still added complexity of handling hugepages as part of
>> reclamation failures (both HugeTLB and transparent hugepages) and that
>> means calling more static functions in mm/memory_failure.c
>>
>> There is probably a more appropriate handler in mm/memory-failure.c:
>>
>> soft_offline_page() - this will mark the page as HWPoisoned and also has
>> handling for hugepages. And we can avoid adding a new page flag too.
>>
>> soft_offline_page - Soft offline a page.
>> Soft offline a page, by migration or invalidation, without killing anything.
>>
>> So, this looks like a good option to call
>> soft_offline_page() instead of memory_failure() in case of
>> failure to transition the page back to HV/shared state via SNP_RECLAIM_CMD
>> and/or RMPUPDATE instruction.
> 
> So it's a bit unclear to me what exact situation we are handling here. The
> original patch here seems to me to be just leaking back pages that are
> unsafe for further use. soft_offline_page() seems to fit that scenario of a
> graceful leak before something is irrepairably corrupt and we page fault on it.
> But then in the thread you discus PF handling and killing. So what is the
> case here? If we detect this need to call snp_leak_pages() does it mean:
> 
> a) nobody that could page fault at them (the guest?) is running anymore, we
> are tearing it down, we just can't reuse the pages further on the host

The host can page fault on them, if anything on the host tries to write 
to these pages. Host reads will return garbage data.

> - seem like soft_offline_page() could work, but maybe we could just put the
> pages on some leaked lists without special page? The only thing that should
> matter is not to free the pages to the page allocator so they would be
> reused by something else.
> 
> b) something can stil page fault at them (what?) - AFAIU can't be resolved
> without killing something, memory_failure() might limit the damage

As i mentioned above, host writes will cause RMP violation page fault.

Thanks,
Ashish

>>
>>>
>>>> Still waiting for some/more feedback from mm folks on the same.
>>>
>>> Just send the patch and they'll give it.
>>>
>>> Thx.
>>>
> 
