Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8962534955D
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 16:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhCYPY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 11:24:29 -0400
Received: from mail-co1nam11on2061.outbound.protection.outlook.com ([40.107.220.61]:2144
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230406AbhCYPYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 11:24:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOxihlm7JY0cvOmWgeYVAjc5ko7hHkym15QAljmVR7oo7C2aZtVELm039b64DRoDUg4ryCoIjZt5SKnwcdbGeTefJWEHxXytBu9+EigbzENH4dEEn1Wf3x8NiwlwtO6/Qzgz3axqvP8fPEtnaH7OJsBRGYFpcsYowr1aQtwt+yihxCJnS3gL7YYB9pGThmL1WwNLVjfCDNumDFqQI4AIYSItP8gkNZlqoLKINlaZHerXGY651jCPIMCuKoBcvESg+oIjzRaImbaeVL8QJwRl2atS2uPYl18DXCbqFCHNwLK8vg6ipFTkl1dvC0WH8GHc2jaNkBpWnq2vGI+WoRh9tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AD9KNmVfhhViPQyyiVf6g/08PF0U56vprA7d2arOxR0=;
 b=JFYGTyy3nUdMxLLXg0fZUNE71NuEV9/kqRMq6o1uHcUGHzX0DjLeLPVvd3pdHOxNMKShEa1cjfyyONGeY6ARF4BbLA8MNWet2CHcQA9cGdhjCCCJzXR/bru4p/jF/Orw7rVaTs3QyFrA5/OMHj7/iLu2y2bb6XJ4K187wunJz+JCeRAdLh43Jwdzt6d0VE84qtKaQEf2ibQLcTdaOkmABpg23WZOOqCZnN4ZGS6DozngONp8ATO6GyRNHb//YR7ikl2A9QskTT764hFBgra9TnjE2F8wKiJXpL81rVIPrn14onxYW/oDuynrUqA1z0L08eRV7XNxw6at+yc/P7xtSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AD9KNmVfhhViPQyyiVf6g/08PF0U56vprA7d2arOxR0=;
 b=zdRDV4hOXpPqtLRXn0pTTvJc/K7gAm4qn/jl56hrh59mQsr/AC+udzKCXkldRxB7MWeW6PFhDHb+CUGd7btgwqCjLMS6L7SNEKe8nod4jyJ+SnZ98bAg4R0N2p6qNyMH6JcPbBm46We9D1rN6Z5HqsFV+0k7VMV509DL5ESHg6Q=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 25 Mar
 2021 15:24:19 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 15:24:19 +0000
Cc:     brijesh.singh@amd.com, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 07/30] mm: add support to split the large THP
 based on RMP violation
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-8-brijesh.singh@amd.com>
 <0edd1350-4865-dd71-5c14-3d57c784d62d@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <86c9d9db-a881-efa4-c937-12fc62ce97e8@amd.com>
Date:   Thu, 25 Mar 2021 10:24:17 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <0edd1350-4865-dd71-5c14-3d57c784d62d@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0116.namprd13.prod.outlook.com
 (2603:10b6:806:24::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0116.namprd13.prod.outlook.com (2603:10b6:806:24::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend Transport; Thu, 25 Mar 2021 15:24:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1624ac7c-6522-4b20-9655-08d8efa20f31
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2717F4522766447B2C5DC9B8E5629@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UoUGBZICAq0Pjuh72+ljs2hXdZuyxKYGfkeCqenhpPA98+HwPPrH8PtrIqex82Ql/7Hri4RIRvz0cJdZl/MGIBvx5pUsFxSqKcF73LjoEAID9s9hjw3ixs1MLF5tWfFbMiOFlGJ/Q5DpiNHe9m3FeSYL4NiuJKJG/5M+UknXw+vyhbYOIirEnXJ1ZGAhwnurUYucRdiTLmALMc8wZ3uW1AJ4MZH9RqN7iTcVYjXJU/jmRliWSkXe5L09rqqaREjY0aiKnf21a5zp/k4/ekK9ssvD+k0fZL3MfO2u/F1IGtiwWfkKfMtqkbml+VY/nyAgVGmRN4W5RuWKgRR+z5HZRqNiR+rfiTn2WdGNgCInsWP/reRkYyWE/awyzgHF6ghUhL+K2g2aibxWS/WAEKC31sjiCbs/CU2IrIiT1CYClcys9Zki65LdFKKxwpcDPfnHt4u0NokH7sRrP6ION/4xYzwVvASpuRjY4//bS7nT6vbfo2CGuZ0QNh3sOzHI/+OO30Th+UzkZt/65QZFtX+YWQNyfJlh2nzDEcvdpsrJeoi796s0KJNJEgddBI8SdyQj82XVztqRvnXfBx/kHqucRU4GPGfcp6M6+yhD9Ykj3gnGmEpamAz1h55VepU+/7nhxaBhhPSLIrqq4z3lSVBB4mto3d7A+MFGy8cxB+bobC/55Y0G+C8/kB8UqxDXTr09hloEMjbkm8v6P8pGi3KbED+GQYKunTObIjl3Oohc5zI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(53546011)(2906002)(8676002)(956004)(36756003)(31696002)(44832011)(2616005)(66476007)(86362001)(8936002)(6486002)(52116002)(5660300002)(66946007)(31686004)(66556008)(6506007)(38100700001)(6512007)(4326008)(7416002)(478600001)(54906003)(186003)(316002)(83380400001)(16526019)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L3FsRzRtRXhDelNEMzhsVW5qWXMxa3VTaU1Hem9STGlsZ1BqWG95VFc1cXdq?=
 =?utf-8?B?UEdzRWZNRTh2aWxZcDROa1lRL1RENUMrK2JzNnkxR0RNTk5taDI0UzliYkgv?=
 =?utf-8?B?WEplTytJT1Ara2M1MGxTajdxVkNTdHNZb29KZ0ZVb1FZdldiczh2bGFRT0ZS?=
 =?utf-8?B?dWF1aTVubHpOKzlnRUNRZklnY2R4NnlxS3EwckVvWlpYWTJtbXVhaFdtWlY5?=
 =?utf-8?B?dWVRU0lyZlJyNms1V1J2d0hXSHRjU1VGK3FHaGorZy96U2VieVNlRVhvdFAz?=
 =?utf-8?B?V09OOGFkTnlZcWZzcUVrU3krc1A4RzZ6cEYxSlltSWFzUjdaSHo2ai9LbWlj?=
 =?utf-8?B?WVNEZzE1dW1FRDYzL3F4VU0rNDgyY2dhemZnUHIrSEJVNXBNZkJYa21HMEFo?=
 =?utf-8?B?OVFuSm95TTJOV3dGa0M4a1pTdlF3UWdqMzhOOVdmY2ZISWhweGJxeUtqV0tN?=
 =?utf-8?B?WERleUNlOVRrelJ3T3Q3bjRUd1MxdUlxYUpINmxPUVJSN2xDeU5JWVM1MzBW?=
 =?utf-8?B?WElQMTFzR2hNb0Z2THVSRS9zRStBTHd5V0d2R3ZWT2xaV0hNVFVjRFAvVlpJ?=
 =?utf-8?B?RUNqcmErRWs1RDhvVDVLV3FHRWxWL0ZKZGR5NHRDSW96UUJjODdTY3Bid0NJ?=
 =?utf-8?B?d04zUys1TGRHQ1JXRkxiaC83S1o3QXlTWWYzdG05NFhDbXBqWU4wK045dS92?=
 =?utf-8?B?N1lDVTNUdjVqOVhacXBvbmRheSs5cjJqUk1RWUFpMzlhcmx6VHd4MUh3R1RP?=
 =?utf-8?B?OHFldVYvbTVlLytZWGtGMzhkY3BubGRLMnRNeCtKS1BSSDZ3dWllZzRZbjNp?=
 =?utf-8?B?cnZUQnIwMzhKTW9XZGM3c3hzZjFJMi9QdWpwQXc2TUxCYlNFVFdkUGxBNzN1?=
 =?utf-8?B?ZGVKR0prNnljTHhiaHFLaU9RM0tNRjVpdW9NcHZORWZIdnBCazEyQlJpYTdQ?=
 =?utf-8?B?aWJ2bGJab3RRbFh5STlRZWR6RmV6STZOSUpKZGpVaFhlZjZSVXdJaDN3QU56?=
 =?utf-8?B?SmpGd1lhZEMveGpUM1VwSTYzSUhLQ2JZY2xEcVlGTVJ2RTNoTDdwSEVWOGY3?=
 =?utf-8?B?b0VCVmF4L3JTQmVJOS9LOFhFNmxhRmJKWWJ2cnI1NTlqTVVQcml0VWxDbXMx?=
 =?utf-8?B?Mkl0am91MHc4SGdEMEJ3RlhhVVliVVVSaE92WDZZMERVcUFqM25rMmJLQTJU?=
 =?utf-8?B?d1Yvdjc3VDBrRnhMVm0yQnNXYjRybmFrVXJxNmVXbmd5OHMxZnY5YUJlcFdN?=
 =?utf-8?B?T2hhTDdScm9NSzkxdmxQVnc4ZmVqbHlDRTlOR1YydWJwZzNrTkk2QUFNSHVm?=
 =?utf-8?B?STh2bkRhckc1OW9PdVBZaVJCNGlCeGthYkhYaitMRDVmcGxMeDNreUd0ZUNw?=
 =?utf-8?B?Z2t5bzdIVmNmWU83TFNOS3BybFZsRHJyQk51YXBmL2U0R3FYRGZudUY5YVJ3?=
 =?utf-8?B?Z0h1QWIzQXpzMjUzUEJleEVocmxyUVB6azQ3WVE0WEl6NE83Z0xsSDVoRU1E?=
 =?utf-8?B?cG9kRXVGQXB1WlVGRzNwWGQ5K3BrYVE5cGFsbzBGWHpCMHRpMGJDUkxJdFVW?=
 =?utf-8?B?OE82cXJZQkNicSs4aFhQbDBxK0t3WVBVZFlsZFJsNFBVVGxEOHBYQnZLa3A5?=
 =?utf-8?B?N1JjNEhiR1F0ZjhSMko3NVd4Y0lFZ1Nob2ZPWk9mU3FMTkxRYkNXYSs5OXZG?=
 =?utf-8?B?MmF2WDVjdjBuejZoNDRYMnVkdEhuNWxPeXc0M1FUSmJzOU5hdDlYVFNodS9o?=
 =?utf-8?Q?ieusfQyl4GAqhfXg3DeC1k5iLxpYD7qE09Wi1hp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1624ac7c-6522-4b20-9655-08d8efa20f31
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 15:24:19.3262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rb4FSbFpq/cljaQQylDVn7w4HTmQ2Vf+vad/QxzLnlxSHh/traN9dIHX0xZiglEtdyuV1L8sdV9lLqD7UPjfnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/25/21 9:48 AM, Dave Hansen wrote:
> On 3/24/21 10:04 AM, Brijesh Singh wrote:
>> When SEV-SNP is enabled globally in the system, a write from the hypervisor
>> can raise an RMP violation. We can resolve the RMP violation by splitting
>> the virtual address to a lower page level.
>>
>> e.g
>> - guest made a page shared in the RMP entry so that the hypervisor
>>   can write to it.
>> - the hypervisor has mapped the pfn as a large page. A write access
>>   will cause an RMP violation if one of the pages within the 2MB region
>>   is a guest private page.
>>
>> The above RMP violation can be resolved by simply splitting the large
>> page.
> What if the large page is provided by hugetlbfs?

I was not able to find a method to split the large pages in the
hugetlbfs. Unfortunately, at this time a VMM cannot use the backing
memory from the hugetlbfs pool. An SEV-SNP aware VMM can use either
transparent hugepage or small pages.


>
> What if the kernel uses the direct map to access the page instead of the
> userspace mapping?


See the Patch 04/30. Currently, we split the kernel direct maps to 4K
before adding the page in the RMP table to avoid the need to split the
pages due to the RMP fault.


>
>> The architecture specific code will read the RMP entry to determine
>> if the fault can be resolved by splitting and propagating the request
>> to split the page by setting newly introduced fault flag
>> (FAULT_FLAG_PAGE_SPLIT). If the fault cannot be resolved by splitting,
>> then a SIGBUS signal is sent to terminate the process.
> Are users just supposed to know what memory types are compatible with
> SEV-SNP?  Basically, don't use anything that might map a guest using
> non-4k entries, except THP?


Currently, VMM will need to know the compatible memory type and use it
for allocating the backing pages.

>
> This does seem like a rather nasty aspect of the hardware.  For
> everything else, if the virtualization page tables and the x86 tables
> disagree, the TLB just sees the smallest page size.
>
>> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
>> index 7605e06a6dd9..f6571563f433 100644
>> --- a/arch/x86/mm/fault.c
>> +++ b/arch/x86/mm/fault.c
>> @@ -1305,6 +1305,70 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
>>  }
>>  NOKPROBE_SYMBOL(do_kern_addr_fault);
>>  
>> +#define RMP_FAULT_RETRY		0
>> +#define RMP_FAULT_KILL		1
>> +#define RMP_FAULT_PAGE_SPLIT	2
>> +
>> +static inline size_t pages_per_hpage(int level)
>> +{
>> +	return page_level_size(level) / PAGE_SIZE;
>> +}
>> +
>> +/*
>> + * The RMP fault can happen when a hypervisor attempts to write to:
>> + * 1. a guest owned page or
>> + * 2. any pages in the large page is a guest owned page.
>> + *
>> + * #1 will happen only when a process or VMM is attempting to modify the guest page
>> + * without the guests cooperation. If a guest wants a VMM to be able to write to its memory
>> + * then it should make the page shared. If we detect #1, kill the process because we can not
>> + * resolve the fault.
>> + *
>> + * #2 can happen when the page level does not match between the RMP entry and x86
>> + * page table walk, e.g the page is mapped as a large page in the x86 page table but its
>> + * added as a 4K shared page in the RMP entry. This can be resolved by splitting the address
>> + * into a smaller page level.
>> + */
> These comments need to get wrapped a bit sooner.  Could you try to match
> some of the others in the file?


Noted.


>
>> +static int handle_rmp_page_fault(unsigned long hw_error_code, unsigned long address)
>> +{
>> +	unsigned long pfn, mask;
>> +	int rmp_level, level;
>> +	rmpentry_t *e;
>> +	pte_t *pte;
>> +
>> +	/* Get the native page level */
>> +	pte = lookup_address_in_mm(current->mm, address, &level);
>> +	if (unlikely(!pte))
>> +		return RMP_FAULT_KILL;
>> +
>> +	pfn = pte_pfn(*pte);
>> +	if (level > PG_LEVEL_4K) {
>> +		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
>> +		pfn |= (address >> PAGE_SHIFT) & mask;
>> +	}
> What is this trying to do, exactly?


Trying to calculate the pfn within the large entry.

The lookup above will return a base pfn of a large page. Need to find
index within the large page to calculate the PFN.

>
>> +	/* Get the page level from the RMP entry. */
>> +	e = lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
>> +	if (!e) {
>> +		pr_alert("SEV-SNP: failed to lookup RMP entry for address 0x%lx pfn 0x%lx\n",
>> +			 address, pfn);
>> +		return RMP_FAULT_KILL;
>> +	}
>> +
>> +	/* Its a guest owned page */
>> +	if (rmpentry_assigned(e))
>> +		return RMP_FAULT_KILL;
>> +
>> +	/*
>> +	 * Its a shared page but the page level does not match between the native walk
>> +	 * and RMP entry.
>> +	 */
> For these two-line comments, please try to split the text fairly evenly
> between the lines.


Noted.

>
>> +	if (level > rmp_level)
>> +		return RMP_FAULT_PAGE_SPLIT;
>> +
>> +	return RMP_FAULT_RETRY;
>> +}
>> +
>>  /* Handle faults in the user portion of the address space */
>>  static inline
>>  void do_user_addr_fault(struct pt_regs *regs,
>> @@ -1315,6 +1379,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>>  	struct task_struct *tsk;
>>  	struct mm_struct *mm;
>>  	vm_fault_t fault;
>> +	int ret;
>>  	unsigned int flags = FAULT_FLAG_DEFAULT;
>>  
>>  	tsk = current;
>> @@ -1377,6 +1442,22 @@ void do_user_addr_fault(struct pt_regs *regs,
>>  	if (hw_error_code & X86_PF_INSTR)
>>  		flags |= FAULT_FLAG_INSTRUCTION;
>>  
>> +	/*
>> +	 * If its an RMP violation, see if we can resolve it.
>> +	 */
>> +	if ((hw_error_code & X86_PF_RMP)) {
>> +		ret = handle_rmp_page_fault(hw_error_code, address);
>> +		if (ret == RMP_FAULT_PAGE_SPLIT) {
>> +			flags |= FAULT_FLAG_PAGE_SPLIT;
>> +		} else if (ret == RMP_FAULT_KILL) {
>> +			fault |= VM_FAULT_SIGBUS;
>> +			mm_fault_error(regs, hw_error_code, address, fault);
>> +			return;
>> +		} else {
>> +			return;
>> +		}
>> +	}
>> +
>>  #ifdef CONFIG_X86_64
>>  	/*
>>  	 * Faults in the vsyscall page might need emulation.  The
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index ecdf8a8cd6ae..1be3218f3738 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -434,6 +434,8 @@ extern pgprot_t protection_map[16];
>>   * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
>>   * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
>>   * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
>> + * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the region to smaller
>> + *   page size and retry.
>>   *
>>   * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
>>   * whether we would allow page faults to retry by specifying these two
>> @@ -464,6 +466,7 @@ extern pgprot_t protection_map[16];
>>  #define FAULT_FLAG_REMOTE			0x80
>>  #define FAULT_FLAG_INSTRUCTION  		0x100
>>  #define FAULT_FLAG_INTERRUPTIBLE		0x200
>> +#define FAULT_FLAG_PAGE_SPLIT			0x400
>>  
>>  /*
>>   * The default fault flags that should be used by most of the
>> @@ -501,7 +504,8 @@ static inline bool fault_flag_allow_retry_first(unsigned int flags)
>>  	{ FAULT_FLAG_USER,		"USER" }, \
>>  	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
>>  	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
>> -	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
>> +	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
>> +	{ FAULT_FLAG_PAGE_SPLIT,	"PAGESPLIT" }
>>  
>>  /*
>>   * vm_fault is filled by the pagefault handler and passed to the vma's
>> diff --git a/mm/memory.c b/mm/memory.c
>> index feff48e1465a..c9dcf9b30719 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4427,6 +4427,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>>  	return 0;
>>  }
>>  
>> +static int handle_split_page_fault(struct vm_fault *vmf)
>> +{
>> +	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
>> +	return 0;
>> +}
> Wait a sec, I thought this could fail.  Where's the "failed to split"
> path?  Why does this even return an error code if it's always 0?


Ah, I missed it. Let me address this comment by propagating the error
code to the caller so that it can take the corrective action. In this
particular case, if we fail to split then we will not be able to resolve
the fault and will need to send SIGBUG to abort the process.


>
>>  /*
>>   * By the time we get here, we already hold the mm semaphore
>>   *
>> @@ -4448,6 +4454,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>>  	pgd_t *pgd;
>>  	p4d_t *p4d;
>>  	vm_fault_t ret;
>> +	int split_page = flags & FAULT_FLAG_PAGE_SPLIT;
>>  
>>  	pgd = pgd_offset(mm, address);
>>  	p4d = p4d_alloc(mm, pgd, address);
>> @@ -4504,6 +4511,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>>  				pmd_migration_entry_wait(mm, vmf.pmd);
>>  			return 0;
>>  		}
>> +
>> +		if (split_page)
>> +			return handle_split_page_fault(&vmf);
>> +
>>  		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
>>  			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
>>  				return do_huge_pmd_numa_page(&vmf, orig_pmd);
> Is there a reason for the 'split_page' variable?  It seems like a waste
> of space.


I can remove it to save some space.


