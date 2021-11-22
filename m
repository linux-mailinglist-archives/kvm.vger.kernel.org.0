Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61BA459476
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbhKVSEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:04:51 -0500
Received: from mail-dm3nam07on2080.outbound.protection.outlook.com ([40.107.95.80]:14567
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232075AbhKVSEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:04:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0HOGvDZLFXtENCCrGN3MV1TOs/g3cdzpOfpaLMIGzacMMQffzUTxBTP+YpGhedNNPsV0Xk2i3V+gow6M+oL8vflXothBNA6p9P9tZwKucrU+ELnttnXbfl7SbsCJVJVZ/nI1mhgZ35A3loTEwrk2qWC2A3HGvn8C+eBF1IL1G1JgyHd5wM3xZA41fU7Y1RPtfXPIuA9821IPOQIyPJsSrduKgSYYexmiK3i8iG0s9uoUcsyWP+aRc9kTRuQYqZgdw7QxR59iSsikIaqaeKMlRcz/1Vs5Fpxy7Ytq35gM1ofXKc0wN52zhV0UKeDSStKup9l6iOSdTWymk4ifs0bfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxRc8zdB5sm9t8/iti8opHkQcW3Gm5a/8Hww0+PBDT8=;
 b=oe83ibWt4MGC2zDWqBYPgyaNiWloAsSMb5AlGgHy46RJnJeSY0dFFBWK+yiZVVHOx83gmGrhbhztxOvuB+eWTeIsks2n9ai/z+dBopOzN0BfCQl1/w9mXizFjXvi1Yp7S01H82tA0ZzGbZ7rqCVnVr/PxbD3liCjFQ14gOgR3qI98yuNFUFIdPsSV2ihfxIPW9SvQ8u4okBPU6xk43jK9y/bZJ64Tl4TCFeAS61rQdlCp8Kjra12GZQGO/iOLULCC0RjGC1IQKSmcOMXkCn+WIn4pVkVfbWE9U+2hWGt0viwQ6OVDizg0od9nKmjp1EKisS8++yRZqFNRrQZRF6ltQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OxRc8zdB5sm9t8/iti8opHkQcW3Gm5a/8Hww0+PBDT8=;
 b=uOxv3oZExCYvKkUH+Y2BbAUPB9GE24BMEibRi1CrD8Jg+iGwsCFc/28GXohJA5A6noM6XOfgxgTJ1kfqjlFrJhiHhV5JqhqCBo/19c79oIPRkdx6AMeWjdXoNVfKjHfUdlOHiGeVspiOFgbmchd4HYegiRU3B3dGStXdBYoz75g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 18:01:42 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 18:01:42 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Vlastimil Babka <vbabka@suse.cz>, Peter Gonda <pgonda@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <6e67f74a-fb4e-fda4-9583-dad28f14ed3a@suse.cz>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <11937ca5-0dc2-d3a0-329b-236345d9f904@amd.com>
Date:   Mon, 22 Nov 2021 12:01:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <6e67f74a-fb4e-fda4-9583-dad28f14ed3a@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:208:329::21) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by BLAPR03CA0076.namprd03.prod.outlook.com (2603:10b6:208:329::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Mon, 22 Nov 2021 18:01:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78a3ae89-2924-48cf-27e2-08d9ade2234e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-Microsoft-Antispam-PRVS: <SA0PR12MB45092B4C0C831CD644E80DE0E59F9@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6tdJoGnU0eXbBLq4UBhxVXFM2erWQXm8JqsZheoTXAg0y+sTh9VqqtzcW/RkFkAeiXVkkHjY5W0UZy/zNi9tRkysSzNNO8OkjNLQDFJT7WnA/aoJmmmYLCBieKfPSEQUph48Qq1sUFf4leVsjqMsmBbeLCKTEHSJ4tPUo9jPxEfwuBKaVFRr3sIMPvplYugCfMj4t5o1jQ+XDqS7ys+0k3eB9ITNuzffCvj/zMJKu3+wDvA+6y7uv/Kl9a8pFV0qbNyWg3f6DZjGlpfyGZsSxOlQtUsHFhnG2HoE42RucBB/wp8aC5ti4sIgQyCS/YO3f2I3E0bNQ58MVtu0Rin0rudVKUCS1TVyc9AaYmOrm16NH2be2FjAQenZwMLS2xvgh2RTrYsUu1YygXJU0jqilVOa92spCNcbZFLRPpX3tUfWTmgoXqyPZnL1nhKQPtSoU0RtWJxPqdRXeiNgt9kWc+JFWL2DKghZ2tr8v4t3yuAfnP7QAy1zye7il8J+hdi7Th3QFFjKu3C+v5jx+2BOmUzvWr1Tg+Em6s6uYZeGLE0PbIucOKVHzPU04S42oGCHHOEfJzT8Xl+kjGm6U8I1bfUvmFN/YxOvn2Q1yMdXx02Xm1/qS1TsU77beE169L+KLNMDOKmySAVlmTqNvRnDvwLMUklBXXgHpRtirrBSBOa3YlCa/XElJBTuJkLskqJFoPt2djUD+u6jq9J8KzOwg6EGKc9nCQUHbiXydb6sXB8p0GpkxdBIkD1XwJTIGIGipvAyUCo9eZAHDDRUc0I08XVJt985Qsvs3Lo39CWlx0s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(2616005)(508600001)(5660300002)(86362001)(110136005)(31686004)(44832011)(7406005)(66476007)(66556008)(7416002)(66946007)(36756003)(4326008)(26005)(8936002)(54906003)(31696002)(16576012)(316002)(38100700002)(6486002)(83380400001)(53546011)(2906002)(8676002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjNaaGx2WXdVMkpBUWJscnNteXBkc2FxNnFCTk1FTi92ajEwb0IveEN4alcx?=
 =?utf-8?B?R2VQQ1VCZWwzRWd4dG9xS1daU2NTa2o5RHdWa1d1Z0FmOHJ6VzRzdUVmUnhJ?=
 =?utf-8?B?TTR6TWR4QU9NUG1Za3NMVWhocm1YVnVpN3ZLNkxNOXVEcnFnQmxEdWgxOUJx?=
 =?utf-8?B?OVlQdjNLUjZMbldibHNnRFRaYVEvRllhRDJzTmFaWXBSbzA2UTBEVzNZWmJo?=
 =?utf-8?B?WHI3OGRaUnVycUNQUitYYlhpV08vLzF4bW9vYzJBMzFZZlQ3eHhzYXlEcUlC?=
 =?utf-8?B?bmgva0lwSGtrdk5hZGhFL3ZMbm9pcVRxK1p2UFFMZ3MzQnNOT1RCRDhueEFX?=
 =?utf-8?B?NW5rZ0JsaFlBRkRDbk1nTWNWNFNuVEh3NFNxOG1pYjNaNWJ1VFl5d3lUazJF?=
 =?utf-8?B?cVZ6dDZBVU1KdWRNM3Btbm1hZkVrSkNyTXNFN3dkVW1qN2JLTlNWck5FUENz?=
 =?utf-8?B?Z09yQ2lneW1SekVHc1NlOHFjOTh4SVA5aFNPaVBPaXl0am9LMnNpdHRQMHli?=
 =?utf-8?B?OEtRWmNCc3JWaWdDei94OHZWYis3K1JubnN6ekxJbHQ3VWJaRVArUWYwcTZP?=
 =?utf-8?B?TldoeEZWalJPZHJxV0lSL0lFMFR2aUJJVTA4YitWQ0VwTEFVSUl4alN5THNM?=
 =?utf-8?B?QkRMMWxTdE81WWNjZFZCTEZtUnJWUEs2Y3NUWm51dmVjMU5Bdk1mdzdHTTU0?=
 =?utf-8?B?RmI0cXBkVmNWVU9sNmJMZWh4S1Nqa0x4N3NhN2dMR29UaytXNnpyME9ONWhT?=
 =?utf-8?B?VnVxd2g0NUYwb21IQTBTY0VNM0ppQVliSCtiUmFIbFNtSndnMld1RlZNTVBW?=
 =?utf-8?B?amJSOGdSZ0pXNXpGemZ3bEdnblFHZGRjQ1JWcWt6a00zak41MHl4K0hRS25F?=
 =?utf-8?B?M3ZtMlNBK21PemtUaVkxZHZSMllTNzdyQ01uRUExMkpBbGZGa3daeTh6bHVE?=
 =?utf-8?B?N0RiK2I0bDJ0bG41ZzVKTWtaTUJkV2NzTEJvck9GNVcrdjVEZ2h6S3hYT1pn?=
 =?utf-8?B?Mk5HYjRxMTNHK2pHTHJwMC9LbWg4cjY3THhQV3VpVUZGS1BMK0xlTFlxZXZI?=
 =?utf-8?B?bFA5RXFPNUVUUGovQkZBeVhDUlNpcElPNC80N2VQbjRROTU3ZlVINWZKOUgy?=
 =?utf-8?B?YnlVRkYxWWFMS1hpQUNDU2RhczBUZ0xhU1lzUWlqVFZlY1NPZFBmRGxTY2J5?=
 =?utf-8?B?R2xNV0puRlBhT2RRWWxiZ3ZvU0NUbTNnZUxGQVUyVGltcEJ3ZDY3VEEwa0Jv?=
 =?utf-8?B?aVJlcjZZOCtSaWtCNHpoZ1Z0SDVaL2pLb1N3dnA1TU95d21wK1I0KzdxU2lu?=
 =?utf-8?B?ZlpocHVPS2NVdVcxdW5Hc2xrdmkvNC82NjVleDhTUUZta0c2UDZSemh5VjEr?=
 =?utf-8?B?c1NkT1NzVE5oeUg1ZVhpdDFMRlM2NXdzRk1UamZIV0k2dUY4a3JXcUVNOFUw?=
 =?utf-8?B?SFpocE0vZkc0WjF1eTlZb3NHY2N5VjFKVEF0ZkwwM3pUbU4vUnc1VW1CaDdz?=
 =?utf-8?B?ZXZ3K0V1NmJYTitqRTlZcFE3dmZLV2FSZHVnbVN2dnlTUlplSmJDUGNBMHVM?=
 =?utf-8?B?VTI2SGpSNDF2enFVS3ZCZmxvSnpOSzMrbHRjdC9Ha0c1MmJBRWJOai9kL2F3?=
 =?utf-8?B?dU85M1pQTitLUGdxbHIvVjkrMXgwOGIyWDhubEZnYjY1UTJYQ1JHL0lrZmJp?=
 =?utf-8?B?bGV2b1g2M0hzVkFqekZ1Z1Fwbm16eUY4RzhlZzZtdHd1RkpxWm9PUCtSTnZU?=
 =?utf-8?B?aXdreWxkbFhBaUtYWGxYNVhCaG5LQTcyK3k5dmd0VkFZdEQvbTRnVHVWRWZn?=
 =?utf-8?B?V1FLRE1yUm5SS0FkNEpCNEFKOE9JWXFuUzNaYkxZbWtjc1BVVEJ2TzBqZXJq?=
 =?utf-8?B?UlhtMzVPR0tvVzU1L2tjTy9SVGs2TWFxRlV3czlKc1lYTmpVcVdyMk9zdVRV?=
 =?utf-8?B?SktjclU5OXhnZTVFN0E0NCtkTEpNMzlWWDdSdEtzck1sZzhaanFGN3F5ZUNt?=
 =?utf-8?B?RGxZa0pOb3BSS2RrVThya3c3SXRvVmpFSUxHYTRvRHFtaHJHNnBQdVNobHJL?=
 =?utf-8?B?dXlNNnFoSmNhbysxYmloV0FDSlNjSVJxYnZZZFhPcUF6T1FlTGNxRGN6UElV?=
 =?utf-8?B?dlJCUEFWbnpiYkpIVit6cEYvbEhPSWZ3YUtKTkxCMi9RUlRWWmoxTG42MENS?=
 =?utf-8?Q?xZtkw38ICR+tE066ykV3JU4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a3ae89-2924-48cf-27e2-08d9ade2234e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 18:01:42.3180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fx23DdH2VGEtSR2mCib2j+JYX5TEsk6OmhOmjz+mb11XNgjib7yWaZVQKt31T0aBK180lBl+03j0zUJkZK0MYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/22/21 11:03 AM, Vlastimil Babka wrote:
> On 11/22/21 16:23, Brijesh Singh wrote:
>> Hi Peter,
>>
>> On 11/12/21 9:43 AM, Peter Gonda wrote:
>>> Hi Brijesh,,
>>>
>>> One high level discussion I'd like to have on these SNP KVM patches.
>>>
>>> In these patches (V5) if a host userspace process writes a guest
>>> private page a SIGBUS is issued to that process. If the kernel writes
>>> a guest private page then the kernel panics due to the unhandled RMP
>>> fault page fault. This is an issue because not all writes into guest
>>> memory may come from a bug in the host. For instance a malicious or
>>> even buggy guest could easily point the host to writing a private page
>>> during the emulation of many virtual devices (virtio, NVMe, etc). For
>>> example if a well behaved guests behavior is to: start up a driver,
>>> select some pages to share with the guest, ask the host to convert
>>> them to shared, then use those pages for virtual device DMA, if a
>>> buggy guest forget the step to request the pages be converted to
>>> shared its easy to see how the host could rightfully write to private
>>> memory. I think we can better guarantee host reliability when running
>>> SNP guests without changing SNP’s security properties.
>>>
>>> Here is an alternative to the current approach: On RMP violation (host
>>> or userspace) the page fault handler converts the page from private to
>>> shared to allow the write to continue. This pulls from s390’s error
>>> handling which does exactly this. See ‘arch_make_page_accessible()’.
>>> Additionally it adds less complexity to the SNP kernel patches, and
>>> requires no new ABI.
>>>
>>> In the current (V5) KVM implementation if a userspace process
>>> generates an RMP violation (writes to guest private memory) the
>>> process receives a SIGBUS. At first glance, it would appear that
>>> user-space shouldn’t write to private memory. However, guaranteeing
>>> this in a generic fashion requires locking the RMP entries (via locks
>>> external to the RMP). Otherwise, a user-space process emulating a
>>> guest device IO may be vulnerable to having the guest memory
>>> (maliciously or by guest bug) converted to private while user-space
>>> emulation is happening. This results in a well behaved userspace
>>> process receiving a SIGBUS.
>>>
>>> This proposal allows buggy and malicious guests to run under SNP
>>> without jeopardizing the reliability / safety of host processes. This
>>> is very important to a cloud service provider (CSP) since it’s common
>>> to have host wide daemons that write/read all guests, i.e. a single
>>> process could manage the networking for all VMs on the host. Crashing
>>> that singleton process kills networking for all VMs on the system.
>>>
>> Thank you for starting the thread; based on the discussion, I am keeping the
>> current implementation as-is and *not* going with the auto conversion from
>> private to shared. To summarize what we are doing in the current SNP series:
>>
>> - If userspace accesses guest private memory, it gets SIGBUS.
> 
> So, is there anything protecting host userspace processes from malicious guests?
> 

Unfortunately, no.

In the future, we could look into Sean's suggestion to come with an ABI 
that userspace can use to lock the guest pages before the access and 
notify the caller of the access violation. It seems that TDX may need 
something similar, but I cannot tell for sure. This proposal seems good 
at the first glance but devil is in the detail; once implemented we also 
need to measure the performance implication of it.

Should we consider using SIGSEGV (SEGV_ACCERR) instead of SIGBUS? In 
other words, treating a guest's private pages as read-only and writing 
to them will generate a standard SIGSEGV.

thanks


>> - If kernel accesses[*] guest private memory, it does panic.
>>
>> [*] Kernel consults the RMP table for the page ownership before the access.
>> If the page is shared, then it uses the locking mechanism to ensure that a
>> guest will not be able to change the page ownership while kernel has it mapped.
>>
>> thanks
>>
