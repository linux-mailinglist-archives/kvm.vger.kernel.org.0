Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE83141DEC1
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 18:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349702AbhI3QVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 12:21:43 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:29697
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349579AbhI3QVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 12:21:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbfjQvGzvPoqHgK9TsDGhZh4ha+AeeLX6rE8iU1ckNdTf6/M5aluEB7tWr8ScUxxEW5PRNh5q4W39BkWS11zQ/deWcyKlUHGFGexfeJJU6mj8V1sIpUHQ/6aJjNriY4Kci0VyjJZA/prvyIvCLBCenDzfo+fFU6kytKnrgG2/O3puT/Scg7FYv4Kp7K53Z3mrjfhoJE6lm0s1E0imlf9DqtDBPKY6PHg7R5NFY+MBSX8GbJiIVrW1xSOsCPOKmHpBUBLUriC7gR4O1jhkysmFZn5DIAXLge+MmTTsleam53c5w/2KVREwLFp4cntRmi8O7bwAT1FNUlL1Qa7c1AsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8cLPkQVtOLIhpo1DshgHLiXGWKrvPsaemTrJY+zTous=;
 b=TZJTPWIqoxxRPtZIkCxa7YRIiNmUKpZBZLbmh62GYEBSFokgSSNVwWZYSgLbUOQOvt5tJWEt/konoSyWtB3ug9Sv9PCBlP7LpV0Sh1sTMEq8TgJ4AdAwUmQWzfcfoPG7ISO2G9M5Zba6w+94+lefyvXnb0GJK+44p4/4YdYOEBdT0eHCdmKd9Q9q32YRkNflliUq/1/cmaQ9yle05btOmLU+EGex3pc0hRdXTwAK8yrDSywc3DHPBW85VwjKiE/9V9oEvSGw5C7Sez79laNOzTgXH1sJzmVq/VVXPk2InTagnZ+xfBTikXOPYRLzPUpdEJ9b7+fSsR9n+ETmrF63Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cLPkQVtOLIhpo1DshgHLiXGWKrvPsaemTrJY+zTous=;
 b=xCgJiMDafdJrpbzQd0/Wbp3rmrKpQ+NZz58ghIpV6F9omAAyhQ2a8dQ4cmpkYvw6UWr+icET0wrKFjXvlBrhr+9qyIFHZ9dlFEkWmxN8JIF271w12pAJ9ETxlfBWg9ZfNVNE2z2Wp3xIXHZjiejbmRpbMi3nYERns3yUBVFBw3U=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Thu, 30 Sep
 2021 16:19:56 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 16:19:56 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH Part2 v5 06/45] x86/sev: Invalid pages from direct map
 when adding it to RMP table
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-7-brijesh.singh@amd.com> <YVR5cOQOJxy12DcR@zn.tnic>
Message-ID: <60d6a70d-22ab-9e17-b243-7f5669b4b70d@amd.com>
Date:   Thu, 30 Sep 2021 09:19:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YVR5cOQOJxy12DcR@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: BY3PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:a03:255::26) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (50.237.87.214) by BY3PR10CA0021.namprd10.prod.outlook.com (2603:10b6:a03:255::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Thu, 30 Sep 2021 16:19:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56b4d23f-46d8-4b25-f7fa-08d9842e244d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45579E391C03542D6B6F3A36E5AA9@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOq9wwVi/2gwqXq5mCLTOnfQyTTA4RBSM4rZkayzTJP9aXMe1UgUtVQwwj45pWJCa0x+9rVBDfT9B5KMV2XnAQlqd8ZXKJitz5X6TFUi6Tx7870QZ65Sti/javvoz/qpJNgMMtJRxz3q9nvdi80/yrw3MzEugnkWe4wWzlksnNGZjlxn9kEsMS0GJYsjlo8O2bsCarTYaOu5e2jAmR0XsultzUWNJ6QP3KKtEi9CRyM35OHoDUR1KaA0JLYg3moOYnh6YIz9u/xvpo9hcRNSfcn8BENEmt8mA9DKf/jVGGCZMHCfcvP0bVI5VbzPlKsK7VSx36vcgY34JRNtK/25AgElrgdswhoxGDqRFU+Gcce26unQMRdi6dSU+yiinApYpWnJKGczhOSn0il33AiqGsuvdG/7iKDThGFwFxAMW9u0HHVG6tRKYadsmw7FIxBZlNJJz7etkQe7+mKENT813tY8uh1hqTG0oMUOjAr/X5Y+rG5HADv50vZRlN4jsUgbJxp9rVr1xDJR/nqOhKW5ur9lImY83QpQrAEGBmeMnx+BsFvCqnZgC1snpU1uzaLw32FHcPieV299SkmMGZUM9wc88zcxk34bmHcEZ41xkqfMQsowbqCbqptdd/+jQSNGi6CbZ3X5zfrVknsSVvIcTCN7M9Xeo34SbXo8Pc4A1VE5G8iqAI4DQZq/ZHcf3k1AMMhVqZDo+BHjqAmivSWQz6yrvB4iQnbMXbcvD+1ntNP56rrEE1UJYsmhfv0ccqm5PaysLbVit93SDn4ZwXcY3P6dTZDl1CLL+tUElaKjW/g3LI6NBZuFJaosBa9AHNjglXo6c0T+C152sSwY2+sDV8kNKSDSTSofOE87BvJco6Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(8936002)(6512007)(2616005)(83380400001)(26005)(956004)(44832011)(316002)(38350700002)(38100700002)(66476007)(86362001)(7416002)(7406005)(8676002)(5660300002)(66946007)(66556008)(6506007)(36756003)(2906002)(4326008)(966005)(53546011)(31696002)(508600001)(52116002)(6916009)(186003)(54906003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkRyc2QzWWZDOVo1RUNMZGJ2bnV0NWdCalZabG90TEVKMHJJV25rdXBUNjVQ?=
 =?utf-8?B?NFBNd1NPVW5oYnRwcjEzWVhwVS9iRjFjRlVPdFRtQXV2STdMREJjeVNHeFFm?=
 =?utf-8?B?M2RUUUh6T0NHaWxmMkI3K0x1YlpmMUlSQkE3OG1ZSmhrc3Z5VU5URWczczdi?=
 =?utf-8?B?QTgxQ25aNEJHU3JlNjIrQUdjYktDdHE2b2RjNDlCRWw3eG1ydXdXV0tZenly?=
 =?utf-8?B?TmJJZDlad1pCWk8vM1RUOTlWMlExL1VjeEVQSnQrR0lDbnZUUkpaR2s2dkRp?=
 =?utf-8?B?OXNiZmNGUHh6MlJwbkk4Vk0rVEsrRHlLTVpkay84WGZvaGdxYml0WGVVa3h0?=
 =?utf-8?B?V1ZYemJUbmdUZVQ0MWdOWTd2eGhFRnllQkpDRWFWWGcwdWJoWE5kL3NPSFlo?=
 =?utf-8?B?alRPMmw3aUQrbFlsak00U1dTdm52ZG11M21VSDhveTltUUs4MVBsRlZrVnUr?=
 =?utf-8?B?UUNxYTJkZy9DbkdjNnBMZXJielFSVVBSU0p1VlR5WW5uNVRhSis4Uk43WDZT?=
 =?utf-8?B?TnEvRldnZmVkbktqdnB6UHZpdmNwNE1lTk51RFV1SnpRWEJzd3NwVmVhNHdG?=
 =?utf-8?B?UHJEUXdlQS9obDMzYytzMW5jbXgxN3FWaWx5RWJsSnEwV3FaNEpldHMwVkhv?=
 =?utf-8?B?Ni9GNXRSRFR4UGFoeEZhcmJqejBBTG5GQnpYR2pSZm5vR0Z5OGZqZ05XWEl2?=
 =?utf-8?B?b2Q3ZUcwZTg1QmQxdzNySm9qSHNXVTlSb0xsaTB2WWg3RmtHcWxUM0pndUhl?=
 =?utf-8?B?VWwyNHZBL1M2MSsxOHk5THlIeEcydnU5QXhaTFlaMEp6VTVlWXhGempMTHlj?=
 =?utf-8?B?b0ZZaDFKRjQrTnlQOGtHZXRSVjRoaDhrL1BWQTVHU3ZHZG00QVZYZTJvbmV0?=
 =?utf-8?B?bXRLeExOalJxOU9xTHBkMUJENkxLbWtuNzZOcTA2UHBjWVpZZ1NRK3JJOFE3?=
 =?utf-8?B?VHVneFU0RmZ5UXQ3Ri9vNDIzYmNIM2ZxY3dYbStlTUFoZ0RETlRsU0xFMEtR?=
 =?utf-8?B?L2pvWW9KZU1DV2xOdUFmcUdVWEpNRktJQk13QnovaW16NDY4YkJZRFViWHdu?=
 =?utf-8?B?QUwyRkl0Mytad2hnVkc3Nk5jN3JWVjJsVlBiR3c5Mzg5TVhOaXpTTytLdVNv?=
 =?utf-8?B?NzhNTmEzazUvVTJWKy85V2E4aHJSd1plSmo2b3hLSnQvVVpKbXQ2cHJoeFhT?=
 =?utf-8?B?Ym5ta3BoRkhsL1poQUo0N1p3TWM4YXhTeFZwbmkwSXkvZHZleURjTUlnMUxX?=
 =?utf-8?B?bTNKazdkWkcvcXZQcmVidDJsU0ZqWDh4U255bFpXYXFUc0ZUT3g4MFJmQ3pY?=
 =?utf-8?B?aUt2SkRlZlhjbGpsMzJiQXJ4eG1SRHNVa01YdmU2RUVkaStldnRLNkw2MFZt?=
 =?utf-8?B?YmhQL2hSNll2MjlJNlp4a0ZGeDBuUkhTdWwrV29oKy9ZWFhjRXNsVlJTcHBh?=
 =?utf-8?B?UWVLTzZtY1p5TGVSM3k4S3M3WXJUU0FQMFU0ODI1Nyt1SmxkV0xzYUVMaFJp?=
 =?utf-8?B?djBZeFdhNWFiY09UWm5xMlJIZmdIc1NidkthR0czVWpKQ2ZnNVNPcDFGWTE3?=
 =?utf-8?B?cnRDOU02M054bWtjWEZSendGcUFVUEdWSEF6T1FBemF2SjA2L1UzNFVoQ3pG?=
 =?utf-8?B?MkovQjlFbUxSRnQ5LytDNmJGSW1vdmhzSUdNMU5KWExBMkJtKzZmazNqNURo?=
 =?utf-8?B?V1NPMXlGemZnN1hEeE1BbTdlTENXRFpKOG5RSkZJS0V1Tzk5SDg1TVN1S2o3?=
 =?utf-8?Q?rRWnDxwh1PKSHj86qtDtmwaj6f4gedXoKSCwLsL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b4d23f-46d8-4b25-f7fa-08d9842e244d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 16:19:56.5155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHopUICMXmiPfy/5Af9ezwWFRuCR45HQ27iJj5hYWLmgP9WXWr1KWPQmTxCi/9ZhySwaPDgjHZji134X9FeQnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Boris,


On 9/29/21 9:34 AM, Borislav Petkov wrote:

...


>> Improve the rmp_make_private() to
>> invalid state so that pages cannot be used in the direct-map after its
>> added in the RMP table, and restore to its default valid permission after
>> the pages are removed from the RMP table.
> That sentence needs rewriting into proper english.
>
> The more important thing is, though, this doesn't talk about *why*
> you're doing this: you want to remove pages from the direct map when
> they're in the RMP table because something might modify the page and
> then the RMP check will fail?

I'll work to improve the commit description.


> Also, set_direct_map_invalid_noflush() simply clears the Present and RW
> bit of a pte.
>
> So what's up?

The set_direct_map_invalid_noflush() does two steps

1) Split the host page table (if needed)

2) Clear the present and RW bit from pte

In previous patches I was using the set_memory_4k() to split the direct
map before adding the pages in the RMP table. Based on Sean's review
comment [1], I switched to using set_direct_map_invalid_noflush() so
that page is not just split but also removed from the direct map. The
thought process is if in the future  set_direct_map_default_noflush() is
improved to restore the large mapping then it will all work transparently.

[1] https://lore.kernel.org/lkml/YO9kP1v0TAFXISHD@google.com/#t


>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/kernel/sev.c | 61 ++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 60 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index 8627c49666c9..bad41deb8335 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -2441,10 +2441,42 @@ int psmash(u64 pfn)
>>  }
>>  EXPORT_SYMBOL_GPL(psmash);
>>  
>> +static int restore_direct_map(u64 pfn, int npages)
> restore_pages_in_direct_map()
>
>> +{
>> +	int i, ret = 0;
>> +
>> +	for (i = 0; i < npages; i++) {
>> +		ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));
>> +		if (ret)
>> +			goto cleanup;
>> +	}
> So this is looping over a set of virtually contiguous pages, I presume,
> and if so, you should add a function called
>
> 	set_memory_p_rw()
>
> to arch/x86/mm/pat/set_memory.c which does
>
> 	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT | _PAGE_RW), 0);
>
> so that you can do all pages in one go.

I will look into it.

thanks
