Return-Path: <kvm+bounces-4274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B6680FB5A
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 00:26:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E1961F2142B
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 23:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB56F64CF5;
	Tue, 12 Dec 2023 23:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TiHBqR45"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A16AA;
	Tue, 12 Dec 2023 15:26:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtfwEonri4XoWcQpYqISO8Aj26hCvuHd6QdNCKJh+xSFc6VOcmEJxApyr0XHrQmiI23exGvgWDUwVye4dwvl4/KBy4zuploqCloIrbZJcXC2FCGqRVPByFfp3EM19nPJ5kqtlcWOk4v+x/FpMpsJN41400vHg0+mh7MKIILvXXGwPzcsGrfmxAGNinUJhL6SZTwej4Zqn3UaK6awVzSwg7ZiSXO5B2st5+Umsh14bhh4ckZE4vof/Bqg3001W1Ym0ZhWgcoSVezgWo9wUoizIrBaXc7WhxIDWq+1PpKQVtD3UotdFRalEnCNtC9i2d5iqH8StOZdlHZc1wcNWpX52Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kAeYh07IaJqFQNQOZpHKvjFAub0xGlzznmwwXTzkgiM=;
 b=BnXuWuDuYGpXJrPsSJkeAt1YbFqF+9AA1SdcZezzavoBl7QOpjUUTbC1sNd73qZgFeD6SMUNKZcboqsDdHTJyN4NWVmp13SSpg7penQ0h2jXsZDkUkK1Ks608wIpJvjPI2pLlRdhoDWifGP4HuEsKOLZ3ZjoyRTQiuSs+WKds15oyupFpas79pMggzlVrXeAmgdtt5SBiFliiL22JQ8fh9zjjybAGdmPuy2v+Jg7ID6YRJa0R0snk/NVtNVJwlwgoi4DZUhyiMM28HFsIVl0bptiO01xUzn2s0L5SHf5Lq0ziVS8k42zIp9y6PgY4dgFUHy0ReaDz9pUmVZ6lrCFUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAeYh07IaJqFQNQOZpHKvjFAub0xGlzznmwwXTzkgiM=;
 b=TiHBqR45WhnuxIr/PKdT83SpJiWlPDbHhLHeyy+N4kV3a5xWwqRmYuWnfz6endthunLnvc8GAB3Jpx65tnQZDr42vREoLPwI9dEX4p9qYrsYlVMhRPLCyZKALC3/+xps8jjr1GjNRiQg1C6bFwP0Y6O9Y4kYGBz3gS0w3Zbvuak=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DS7PR12MB8289.namprd12.prod.outlook.com (2603:10b6:8:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.36; Tue, 12 Dec 2023 23:26:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7091.022; Tue, 12 Dec 2023
 23:26:35 +0000
Message-ID: <8c1fd8da-912a-a9ce-9547-107ba8a450fc@amd.com>
Date: Tue, 12 Dec 2023 17:26:29 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 16/50] x86/sev: Introduce snp leaked pages list
Content-Language: en-US
To: Vlastimil Babka <vbabka@suse.cz>, Michael Roth <michael.roth@amd.com>,
 kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-17-michael.roth@amd.com>
 <0e84720f-bb52-c77f-e496-40d91e94a4f6@suse.cz>
 <b54fdac3-9bdf-184e-f3fc-4790a328837c@amd.com>
 <b1b0decf-dc0b-b1bb-db9d-2a00a8c81b0d@suse.cz>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <b1b0decf-dc0b-b1bb-db9d-2a00a8c81b0d@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN0PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:408:e4::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DS7PR12MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: 517df2c1-6902-466a-4de7-08dbfb69c846
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BXd42ElP1wNJ0d8pjXhdQ6fOIFhqtr8+vp/KjED2RjTF6A4BEWFloBrAEBPa9t0OxqEv2ccZMNWgL9PFVcl8sppgKu7pKmRvbI8FMmReS7Fk4FPd7Ig6Fw0dH3NUCgYmOsfEdp2tXWLoc98rLhC2fmjLca1RsOWZx6thM+2WxHQP2YOy4Wmv6Vr6FWq2fuO1QA8dzB1gP1zWtun61KvWJJQwZkzqwrtMsd7YLSyEI1Os4QPssEGjKqIx+OcpAMIH6EtK0MBXdg3BU94xrViww/N4ZoEiWzBC5mDXxRtYT+R7lNOJc8scGupdjdToQ+Ts4qWqu/92sE9j0eGxqVwKa4bmt/h+G/KRiFQvIatMlgHMuTFFwFV7zEgbhkFhToWnJvWyAorgA4ceyNxjRw732WizmVpb+lBQtWmxlWboyyj9ICWUAYYnDqe1/SAIP4Fw4z55QDAPstt+54hHa4+teybwwIIQ2kcsa4xQlLY2H1hFTpYJL1HvGYPAfDrgukfqcMIXfJ672oChQqWniZfHHmP0NNfE1XGZHZwB4vWgFNvugQXhJdHNcJwt6lHIRrzoGahiGLiPFX3Viy5u3jxtGEhpLrIhOKdve5Z+zmZioUOHdeX/rpQ2R5yVloIbwCB1ortH6Wwvs5cuX3lnbuZlKw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(396003)(376002)(136003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(478600001)(53546011)(26005)(6512007)(6506007)(6486002)(6666004)(2616005)(7416002)(7406005)(83380400001)(5660300002)(2906002)(66946007)(66476007)(66556008)(41300700001)(110136005)(4326008)(8936002)(316002)(8676002)(38100700002)(31696002)(86362001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXZvOFE0YzFneU8wWEJqNUgvVlFZNm0wU0xod1ZmUnB6S1ZjdVhZc0hLVFVY?=
 =?utf-8?B?S2p1ekdubzM3VmhuYW5lQUs1Q0FreVEvdU5MamJ0VktyTnphWlZ6ZDJMTlps?=
 =?utf-8?B?bHBYWUYvNS9kYW9MQVVkanJmd2NPb3dTclFKd29ReVF6b2hjOWdIT2o4OGRz?=
 =?utf-8?B?L0Q4UW5kZHZlSGtORE9uWEdBdlRxZjMzRXIvdjdscjQzaU9nVG10aXIwbTQ1?=
 =?utf-8?B?Wk5OOEhoa2ZFbjlIUTErb0gvU3dTZW1ISXV4QXlSZFF4ZlBiVW4xMmdISTZB?=
 =?utf-8?B?SGszdHNTUkFlM2ZEdE1ES24veFkvL3h3SnQ0SkJPTUNIU1k5ZGlIL0IyUVUz?=
 =?utf-8?B?aXdHZE0waTloNzE0THZXUG9KVXFyODJObmwrUlRyM1U4c2ZIT0JlRVVsV0R5?=
 =?utf-8?B?dGNxTFR6TldGQzN1QzRnaENvSlpDVU5TeHlKYjk1RHRIQnZ3K3hhUWxqeVk5?=
 =?utf-8?B?VjVoMGJtM3RKMGZBN3hubmhjTzh3SnJFa1VFc0M0VTBEVGZIRHdQV2pOOVNI?=
 =?utf-8?B?QXpCM2d4RTcwRXhFdEo1NUxwYkl2U2xqZEp4Q1hpSm9UalIySVFEREsxNndk?=
 =?utf-8?B?bWdYK0o1TElaRVhUb1Q1MVQyNzdHck13azFJaHFUMmhXSGYzTVZ3SFk0REMr?=
 =?utf-8?B?Z2haT1VWTWF1RzJyTHNpVVlaaDhINC9Cd1AyVmR5OEhrRDk4Z0JuZkNOS2to?=
 =?utf-8?B?T0RkNVlWZ3Rac0dxMnZjTE9zdW1IVEd4Y2pQWkUvNERGTStzcmZZclB5cHdm?=
 =?utf-8?B?aVBrdnB6dGx0K3d4cUkzaEtxZ28xZk9hWThMcjAzNmFrZXordWtJSC9Jbisz?=
 =?utf-8?B?eXlPU1Z4Sm85Vm5yb1hWZldkWVlyMjdWaERuTHU1ZEM3eklodjRIWUFoRDI4?=
 =?utf-8?B?ZzM1bjRLczFGb3F2UnFPTTVBWm9XMkVPT0J1aXkzWkt2TlNaZ2V4V1gwUndm?=
 =?utf-8?B?cExpK0xUV2V6dXFpanEwUUc0d1I1d3dFNWttT21VSWtBbVRjbSt0ODFiZktm?=
 =?utf-8?B?eUpWZ3hoOWtjRUszRkpNWUhUQjJZVi82M2c1MEZwYWdwOE9FS3ovbm5vQUdC?=
 =?utf-8?B?Wk5zaFMySjg3aVFRSnd0K3dQaDlubFdNM1ZFQy8wTHBLbW03MzBHTENGUk8r?=
 =?utf-8?B?RjFpU09MTnFaQnhFK2JYRFpjU1o3d2VYbXZXbVRPZGpITFdFZjU0dWZnOTht?=
 =?utf-8?B?T0JncWxaTU5kdmtzNHFXZnZBUVZnOXphdjZGMzFuYnROaG9xbnV3UHdkeHNx?=
 =?utf-8?B?OXBqTTZYZFloY1ZRc012Zkp1cXJzYyt6eU1uT05xM0xRSlRSdVZBWE5BL2R1?=
 =?utf-8?B?RThXTGNOZUhpaGJhSzl0MGZYcWZkYUFxcmpvRG9tVkx1blVKWFoyTUNXLzNq?=
 =?utf-8?B?RVRaelQvbm1FVlRFa3pWRWFmb2NIdktrOHF2bVJUUWtlSW13SUg1N0F0bmNn?=
 =?utf-8?B?ZUNZUFhSMmcwZW5paDVnUXVBN1FuNHdKbk10dm9EK2NYS3FIeTB4RDRSZWdl?=
 =?utf-8?B?dm9UMVplYzRZZXpzTnVXQmJHcmtqSFordFphT28vdEZqMzYwN0JQeXZvVW9n?=
 =?utf-8?B?cXBLZ2pMQnZyY1dZMjRyMnd3Tnp3TnFmaVJlNnl5VU8xM2ZGNjRQUGRmbTRK?=
 =?utf-8?B?ZVdjNzNXTXZRdUNiajIxRmxBbmFoWHh4QVpOT1N5em12SDlrUUtJWjQ5UWo1?=
 =?utf-8?B?WW1pekdZcmpVMGNKVTVESGFBWFJoajBPSjJZekNuM0VURDIxT2pBMHk1bERQ?=
 =?utf-8?B?WGE1c3pUSHlZQVBUbGJwVjg1OFJQZTZRVlhHQU5YS0R4cEFoSU91TklQbEVI?=
 =?utf-8?B?bVAzcm4vSHdPVmV3UG5UNHUyaERiUzZDL2thc1RYbzY4NzNtTHU2MDliRFRl?=
 =?utf-8?B?S3Q5ckUvSDcvQlVMWVVtbVhPa1hyUlNNZXI2U1FQb0RhS3hndGl5YjluNzVC?=
 =?utf-8?B?VFliTkdDS0Fka2xnakNvSG1CY2FWVFM5a0ZxdU5oL2NCNm02aGFSN3FDUXho?=
 =?utf-8?B?V1NlS1Q1SUVucVRTOHJ4RjY0UnhBRVoybXI0TzlDWGIrRHNCRFZrcHNFZFFt?=
 =?utf-8?B?Q1VRYjBXcGc2b1lzNngrQjg1WS9PWms4N2I5cHZBUURvTzlmQ0l4czlOWm9x?=
 =?utf-8?Q?1rdVYX5XFxmxfye/j3G2Un99V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 517df2c1-6902-466a-4de7-08dbfb69c846
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 23:26:35.4995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjUoJRxm3N7+OcQiD2ZH+iulff258JyBWIIyOEJkbDj1uwYIlle5ExJD8rPi+icbSA5JHbbtAf92j6GoKUE4mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8289

Hello Vlastimil,

On 12/11/2023 7:08 AM, Vlastimil Babka wrote:
> 
> 
> On 12/8/23 23:10, Kalra, Ashish wrote:
>> Hello Vlastimil,
>>
>> On 12/7/2023 10:20 AM, Vlastimil Babka wrote:
>>
>>>> +
>>>> +void snp_leak_pages(u64 pfn, unsigned int npages)
>>>> +{
>>>> +    struct page *page = pfn_to_page(pfn);
>>>> +
>>>> +    pr_debug("%s: leaking PFN range 0x%llx-0x%llx\n", __func__, pfn,
>>>> pfn + npages);
>>>> +
>>>> +    spin_lock(&snp_leaked_pages_list_lock);
>>>> +    while (npages--) {
>>>> +        /*
>>>> +         * Reuse the page's buddy list for chaining into the leaked
>>>> +         * pages list. This page should not be on a free list currently
>>>> +         * and is also unsafe to be added to a free list.
>>>> +         */
>>>> +        list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
>>>> +        sev_dump_rmpentry(pfn);
>>>> +        pfn++;
>>>
>>> You increment pfn, but not page, which is always pointing to the page
>>> of the
>>> initial pfn, so need to do page++ too.
>>
>> Yes, that is a bug and needs to be fixed.
>>
>>> But that assumes it's all order-0 pages (hard to tell for me whether
>>> that's
>>> true as we start with a pfn), if there can be compound pages, it would be
>>> best to only add the head page and skip the tail pages - it's not
>>> expected
>>> to use page->buddy_list of tail pages.
>>
>> Can't we use PageCompound() to check if the page is a compound page and
>> then use page->compound_head to get and add the head page to leaked
>> pages list. I understand the tail pages for compound pages are really
>> limited for usage.
> 
> Yeah that should work. Need to be careful though, should probably only
> process head pages and check if the whole compound_order() is within the
> range we are to leak, and then leak the head page and advance the loop
> by compound_order(). And if we encounter a tail page, it should probably
> be just skipped. I'm looking at snp_reclaim_pages() which seems to
> process a number of pages with SEV_CMD_SNP_PAGE_RECLAIM and once any
> fails, call snp_leak_pages() on the rest. Could that invoke
> snp_leak_pages with the first pfn being a tail page?

Yes i don't think we can assume that the first pfn will not be a tail 
page. But then this becomes complex as we might have already reclaimed 
the head page and one or more tail pages successfully or probably never 
transitioned head page to FW state as alloc_page()/alloc_pages() would 
have returned subpage(s) of a largepage.

But then we really can't use the buddy_list of a tail page to insert it 
in the snp leaked pages list, right ?

These non-reclaimed pages are not usable anymore anyway, any access to 
them will cause fatal RMP #PF, so don't know if i can use the buddy_list 
to insert tail pages as that will corrupt the page metadata ?

We initially used to invoke memory_failure() here to try to gracefully 
handle failure of these non-reclaimed pages and that used to handle 
hugepages, etc., but as pointed in previous review feedback that is not 
a logical approach for this as that's meant more for the RAS stuff.

Maybe it is a simpler approach to have our own container object on top 
and have this page pointer and list_head in it and use that list_head to 
insert into the snp leaked list instead of re-using the buddy_list for 
chaining into the leaked pages list ?

Thanks,
Ashish


