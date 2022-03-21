Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103294E2332
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 10:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbiCUJVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 05:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345848AbiCUJVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 05:21:20 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2040.outbound.protection.outlook.com [40.107.101.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC743F47E8;
        Mon, 21 Mar 2022 02:19:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFiDvvp3mFan3Dh3wlYuKtoV5ZWKxRFFZdfGn7ssXjRTT9v+//8EWon/LVwz09VJoPZS0RU3Ncz9ErOFJeGfgZ9TAhJY788VJggRvepJxHElLkExm8Vdm+zjzeJHgIIrF5PPizBWv2l2SJlbr8Tp4NgKptR0wHt7hWYh+pWykHvBVTy2cWGfa8oSIca2Xpt2nrT8JiZ4thAq0xkDkXqByjZz0rdt5MajqFB2pqJHW5DITOxiAUWzXfyc3C54AR6504cw7dfsAjtgiMpzBcma0Yzho7cqCyqJVP63pmBmgKICECdxQjlzcN84g6ivw/IWsuqQHBzdTFv0/jPSI06V6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgOnopaxFkCz4jotxSGJbLScQ7YdYlWHl/LWmij2dBU=;
 b=SDOuIz9eK5cDsrpCikaWIbWkO14ycrxKhRXy4/Jejvo6+AFy/Ml/1DyGULeM3so9Ou4ipgTo/kzgGv+EWKz4GOiL8rTWVzTKKBcjCE784BO7065OGxo3FjQQXeDgcV9GrqiiFS4zzq0l82IeCkji0GAJwgTpV1LYahkQe/83YoqmoLSYAdLor6h5Ozk5UmvYbHPsqBHRSnkRTrQzZEhhXEniOlilytZ73e6nqfpCRyWKjMwMYLhaSGSE+eCZzc20klYLEiH2iKxiKz9bubp9uZ0gENPOJe7H2giasBcQ37ozYFu2gXMLpz/b6UwRWZJBYALDXNTKhZdCoYQImZhjAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgOnopaxFkCz4jotxSGJbLScQ7YdYlWHl/LWmij2dBU=;
 b=04PdmHDlrCmuvCqbC/aBPBOgMJiRXvvM1auXrwaMY/juZojz3QZbIYd6i9qK2nwIfAvRcC3W7F3ovRt6IVwo5B1i5X0wR8jcrtP9U6X9jwtUgciA1xwOsiP8TiQto3cCQI90gzcEOMQvLI2t+GtxR4D+5f1108Stg5mn/3m2Ppk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 DM6PR12MB3084.namprd12.prod.outlook.com (2603:10b6:5:117::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.17; Mon, 21 Mar 2022 09:19:49 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::413:8455:a28:3f6e]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::413:8455:a28:3f6e%5]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 09:19:49 +0000
Message-ID: <22268ddb-5643-f35e-6c34-eb5c2b0ad4cb@amd.com>
Date:   Mon, 21 Mar 2022 14:49:27 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 5/9] KVM: SVM: Implement demand page pinning
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>
References: <20220308043857.13652-1-nikunj@amd.com>
 <20220308043857.13652-6-nikunj@amd.com> <YifQbxW/NUt0HrGV@google.com>
 <03e87e5c-0345-5919-9a33-0bdf50285d8b@amd.com> <YjgXIyrcDA5+u8d+@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <YjgXIyrcDA5+u8d+@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN1PR0101CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:d::29) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5307086e-18cc-48c0-6343-08da0b1bf28f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3084:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB30843C74C4CF970254C2AFCEE2169@DM6PR12MB3084.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IjXn5rVa+g2bTzTX6ajLnf/xnfkKmD2qGeq9h9Qf4erS0N+D/WrWJ007Pi7w53O3lO1yzwUZhPCf6uvFO8mk9p5yWCM1XoUOx+g/TdiSsNBo7Pr0tEOzkCBj+hPqgX8yM4wqELlHI/dHpZja1F+s9M9qbLczTBgA2MZkFcDHHw9C+XMtI1ecjxMK89nAHCrGdwegDyXoN0seVp5V8/II2o9ECAcRq8NzhHgz4FyE7aGWqPqPSRCHfTF8FqIoWQ3b9zWx/ujlaXWuGvpW0UCMS9VUYGuN5I0KghG+YfhkDZMDn92Vcsg3QhiW8mUUlcbEBWTyDzYnpq62q1/O7B8xxVBTZYw0Y5FkXSPe/hmE/0ss4ifvpPYrNkU0Eor5b/kDjALiAgMhP0vIblGou0RLY8HFO1K05HtagwWLjryqrxNWZJHiGA6wy9R0RjhN6Ua/cWxpp2bom+dctg+xk+K8TEwEPvIUIFZXw8D7sgX4r7pS0eBoG3J5+5+02JUcZtyCe/ilsc6X/8VHjEJdxX3v8YLAsKfa5o4++sqGbNHxewRPDjC+/Co4jj99dOjOov2Pa73SipBKj+8B98cO7HXf2d4MVYvYd7zFHXxHogUciTnEf+n2OrvkE8zAQdCeGPDF4SeBvVHBAjP7Tv7/0bT4+dT5VtyLGsYdV9cSIgW14yTbVfqLnJ7T3xUlLJzqdkus6zQMSQ7BiV5RGFdJToN5bUhERJkCb7iVDV/2pby5e5OUiLs8+ugUILPzixiqMydfhTssMVQutG5Shgg1KULRoHDPSDlOQpTMQABWD5Bc+DCDT2WLMJDhWiv7N8Om+VDDTyM5v/g2Xctjnv5lo70KkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6512007)(36756003)(53546011)(6506007)(8676002)(316002)(6916009)(54906003)(31686004)(38100700002)(66556008)(31696002)(4326008)(66476007)(6486002)(966005)(7416002)(508600001)(8936002)(5660300002)(6666004)(83380400001)(186003)(26005)(66946007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFYyNjZjMEtKY2twU2NXUTJNVWhvWGZpZEd2ZDNMekp4VEVJVWhsQm8zUDRw?=
 =?utf-8?B?V3ZTUlBSVGFYUnhFU3lhSENBU3g4eU56MTRhbDI2UjRpTTZFUVBMbDRrNFFr?=
 =?utf-8?B?REVFOUVVN3UxNlA5dkJ5dzhqMDlyZ1dJOEpHNGYrL2VUK1FPVkYvMjFyUjBx?=
 =?utf-8?B?NWJoSkZzT3RMb0lxSTBFVm5HRHIreWdOa01URXlqdnFVemJIWDB4a0FwVWRl?=
 =?utf-8?B?bGlkYlM2YlFvTm1aN2xWNDBKRlRkWFpvaGdLL1BEU29TTC9uYUdWcDFXTWJY?=
 =?utf-8?B?T3c4bkIxMGJ5OG90a2ptYU9OQllyd2V6YkVvRU5aaDUvb1lScFhJb01yVE9o?=
 =?utf-8?B?clYvbGZmOVpQYVlEa0xqUFBXYlBlTVc5dXA3UzRWMmtJbGxsTTViTC9ISWpp?=
 =?utf-8?B?Y2sxUzQxcGtoTFlaa1oxcjZKUWl0ZS9IbG1NeTlMeEQvZXZRMmFwRjVFMVM0?=
 =?utf-8?B?V3VjMFA2cVk1ZTF2WmNXU1hPMXcrYWhHVldmVzdXV3VvTlowNjFDVldhMzVp?=
 =?utf-8?B?TjRmZjQ5NHE2S3ZudEFlMHMzOVN0aDRBcjZmWmxtSkw2elNqNFhiUHU0OVZp?=
 =?utf-8?B?aEtZb1FPeWRVSzRFVFNFenVGY0xFdEtESzFxUHZNS0pUY2Q4WWdzMS9UaGE3?=
 =?utf-8?B?QWRKUm1kS2ovVy9kK3hCbzc3aW1kalVKMExCcmVuYURLS3VVdTNvamtXNnJr?=
 =?utf-8?B?eFBsUTBqQVUwVklmeE05STF0Y1NKbmhXTk91T1BSV3dFbmxTV0Jwck52UGVh?=
 =?utf-8?B?Y3ZyUUd1aTRaT1RYTU5nZXFsSnZ3aXIxNHlUZ0FLSTg5L21mR2tqYm9acnBY?=
 =?utf-8?B?ZnUydDRwbzI5SS9qM2ZOSXA1d2RqdlBobGtJQUVMM0ErRU14alVZTEwzeVpy?=
 =?utf-8?B?R3dlODNxaXNOZ0c0WE5MSlVqK2x4WlZ0ZzRWZCtaZlRhb1BjbjJHaFEralpC?=
 =?utf-8?B?R3pjdloycVlMYzUyTXZzWGdDL3ZVVVFqM3ZwTjltR1ZKbmVWSTBnZmJpTStt?=
 =?utf-8?B?UnlUT0xGUzh6eHVGZXBpaDRVamV3NFBVRnBqaHVPdGs4NExzaXRNSzlDdXRL?=
 =?utf-8?B?VlNnRC9Ta09vVkNxOEVHb2pnbTFSTklvVnM2eW50eTFWOEdOV3M4VWkzUlhY?=
 =?utf-8?B?TU5kV2o5NGVaRjBpSmZ4dDU1bjg4OUJEK1BiVk91VElQSlV3QmJUb3FINFhY?=
 =?utf-8?B?bmdaOE80T2hkYnZOUTVUbGpCUVlFWFVZMk1oZlpRZ1BVUCt0N3hqM0REWkli?=
 =?utf-8?B?enV2bm00MHpqczl2eFJHYm5wQklDeVhxTnhmdzZDbWtsUXBwQW1md200T0pz?=
 =?utf-8?B?emx5aFZ5WlZSSW1mcjRZM2Nya1J0eVRGdElIYlZEVmZUTzFIYitFNTlPRVFK?=
 =?utf-8?B?cUJNMDZJcXJSOXBGcTM1ZCtDa1lMSHJYdFN4STI2WmkxSUVYTW5haWFIUjJ3?=
 =?utf-8?B?ZFhibXlIOEFxa3NqempEQmtNdVJBeCtMMDhrblBjazFwSXYzdDJ2V0s4dUJT?=
 =?utf-8?B?TmNUdGxZMkFlREY4dGU2eStVMUxrdFArdys3L2hsTUVkbHhmMEREZW1xZENY?=
 =?utf-8?B?NTZSQzZZalQ4MDQ1aUExeVNSaks1VFplbDFEUGpSRnFnWStsaUtCcFg0bDJK?=
 =?utf-8?B?aW1PQ3N4MjRWVzFiVjg5NUVMNGFLK0tDMUljNktaMkZzVk15QjlDcjZKWTEv?=
 =?utf-8?B?Yms5UkU3Y2NrS2MyWGUzNDlJSTNRTXdFSEozVkVBL0NGUmtiZmFrVmw5TTQv?=
 =?utf-8?B?T3NaMm5udFdyM1R3dUJKeHdJOUJYNHVJUG1vUllicXBiWnFveVgyQU1VRFIz?=
 =?utf-8?B?bWh0NnNuV3BJWStqVDUvZGJQSk41RnRPNWpReFoxNXFZcjBnSFZVOGdYZkwr?=
 =?utf-8?B?ZlA0SC84VHNQNlphWk5wRGFsUnhOcTJnV0k0UmRwb21meWgwR1BBLzdmN3lB?=
 =?utf-8?Q?11YkK14ZR7AFi20ol86+5ro2KczVdiH3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5307086e-18cc-48c0-6343-08da0b1bf28f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 09:19:49.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uk9hTlE09iSzE9YCNYOMZcC9dqS7BpeqA3dCrO4LIWHrxohwuwrDLdBbOUvHu63Us4Scm88ycJ/4dXqSDbdvHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3084
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/2022 11:41 AM, Mingwei Zhang wrote:
> On Wed, Mar 09, 2022, Nikunj A. Dadhania wrote:
>> On 3/9/2022 3:23 AM, Mingwei Zhang wrote:
>>> On Tue, Mar 08, 2022, Nikunj A Dadhania wrote:
>>>> Use the memslot metadata to store the pinned data along with the pfns.
>>>> This improves the SEV guest startup time from O(n) to a constant by
>>>> deferring guest page pinning until the pages are used to satisfy
>>>> nested page faults. The page reference will be dropped in the memslot
>>>> free path or deallocation path.
>>>>
>>>> Reuse enc_region structure definition as pinned_region to maintain
>>>> pages that are pinned outside of MMU demand pinning. Remove rest of
>>>> the code which did upfront pinning, as they are no longer needed in
>>>> view of the demand pinning support.
>>>
>>> I don't quite understand why we still need the enc_region. I have
>>> several concerns. Details below.
>>
>> With patch 9 the enc_region is used only for memory that was pinned before 
>> the vcpu is online (i.e. mmu is not yet usable)
>>
>>>>
>>>> Retain svm_register_enc_region() and svm_unregister_enc_region() with
>>>> required checks for resource limit.
>>>>
>>>> Guest boot time comparison
>>>>   +---------------+----------------+-------------------+
>>>>   | Guest Memory  |   baseline     |  Demand Pinning   |
>>>>   | Size (GB)     |    (secs)      |     (secs)        |
>>>>   +---------------+----------------+-------------------+
>>>>   |      4        |     6.16       |      5.71         |
>>>>   +---------------+----------------+-------------------+
>>>>   |     16        |     7.38       |      5.91         |
>>>>   +---------------+----------------+-------------------+
>>>>   |     64        |    12.17       |      6.16         |
>>>>   +---------------+----------------+-------------------+
>>>>   |    128        |    18.20       |      6.50         |
>>>>   +---------------+----------------+-------------------+
>>>>   |    192        |    24.56       |      6.80         |
>>>>   +---------------+----------------+-------------------+
>>>>
>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>> ---
>>>>  arch/x86/kvm/svm/sev.c | 304 ++++++++++++++++++++++++++---------------
>>>>  arch/x86/kvm/svm/svm.c |   1 +
>>>>  arch/x86/kvm/svm/svm.h |   6 +-
>>>>  3 files changed, 200 insertions(+), 111 deletions(-)
>>>>

<SNIP>

>>>>  static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>>>  				    unsigned long ulen, unsigned long *n,
>>>>  				    int write)
>>>>  {
>>>>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> +	struct pinned_region *region;
>>>>  	unsigned long npages, size;
>>>>  	int npinned;
>>>> -	unsigned long locked, lock_limit;
>>>>  	struct page **pages;
>>>> -	unsigned long first, last;
>>>>  	int ret;
>>>>  
>>>>  	lockdep_assert_held(&kvm->lock);
>>>> @@ -395,15 +413,12 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>>>  	if (ulen == 0 || uaddr + ulen < uaddr)
>>>>  		return ERR_PTR(-EINVAL);
>>>>  
>>>> -	/* Calculate number of pages. */
>>>> -	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
>>>> -	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
>>>> -	npages = (last - first + 1);
>>>> +	npages = get_npages(uaddr, ulen);
>>>>  
>>>> -	locked = sev->pages_locked + npages;
>>>> -	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>>>> -	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
>>>> -		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n", locked, lock_limit);
>>>> +	if (rlimit_memlock_exceeds(sev->pages_to_lock, npages)) {
>>>> +		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n",
>>>> +			sev->pages_to_lock + npages,
>>>> +			(rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT));
>>>>  		return ERR_PTR(-ENOMEM);
>>>>  	}
>>>>  
>>>> @@ -429,7 +444,19 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>>>  	}
>>>>  
>>>>  	*n = npages;
>>>> -	sev->pages_locked = locked;
>>>> +	sev->pages_to_lock += npages;
>>>> +
>>>> +	/* Maintain region list that is pinned to be unpinned in vm destroy path */
>>>> +	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
>>>> +	if (!region) {
>>>> +		ret = -ENOMEM;
>>>> +		goto err;
>>>> +	}
>>>> +	region->uaddr = uaddr;
>>>> +	region->size = ulen;
>>>> +	region->pages = pages;
>>>> +	region->npages = npages;
>>>> +	list_add_tail(&region->list, &sev->pinned_regions_list);
>>>
>>> Hmm. I see a duplication of the metadata. We already store the pfns in
>>> memslot. But now we also do it in regions. Is this one used for
>>> migration purpose?
>>
>> We are not duplicating, the enc_region holds regions that are pinned other 
>> than svm_register_enc_region(). Later patches add infrastructure to directly 
>> fault-in those pages which will use memslot->pfns. 
>>
>>>
>>> I might miss some of the context here. 
>>
>> More context here:
>> https://lore.kernel.org/kvm/CAMkAt6p1-82LTRNB3pkPRwYh=wGpreUN=jcUeBj_dZt8ss9w0Q@mail.gmail.com/
> 
> hmm. I think I might got the point. However, logically, I still think we
> might not need double data structures for pinning. When vcpu is not
> online, we could use the the array in memslot to contain the pinned
> pages, right?

Yes.

> Since user-level code is not allowed to pin arbitrary regions of HVA, we
> could check that and bail out early if the region goes out of a memslot.
> 
> From that point, the only requirement is that we need a valid memslot
> before doing memory encryption and pinning. So enc_region is still not
> needed from this point.
> 
> This should save some time to avoid double pinning and make the pinning
> information clear.

Agreed, I think that should be possible:

* Check for addr/end being part of a memslot
* Error out in case it is not part of any memslot
* Add __sev_pin_pfn() which is not dependent on vcpu arg.
* Iterate over the pages and use __sev_pin_pfn() routine to pin.
	slots = kvm_memslots(kvm);
	kvm_for_each_memslot_in_hva_range(node, slots, addr, end) {
		slot = container_of(node, struct kvm_memory_slot,
			    hva_node[slots->node_idx]);
		slot_start = slot->userspace_addr;
		slot_end = slot_start + (slot->npages << PAGE_SHIFT);
		hva_start = max(addr, slot_start);
		hva_end = min(end, slot_end)
		for (uaddr = hva_start; uaddr < hva_end; uaddr += PAGE_SIZE) {
			__sev_pin_pfn(slot, uaddr, PG_LEVEL_4K)
		}
	}

This will make sure memslot based data structure is used and enc_region can be removed.

Regards
Nikunj
  


