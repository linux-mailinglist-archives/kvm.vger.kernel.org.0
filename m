Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B23493502
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 07:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351790AbiASGeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 01:34:01 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:1696
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349796AbiASGeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 01:34:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNfxQcwKMdQ8jyMNraIl2yXI5857jOeuC7Yeyauh2CjvY8SAxpt7jRysWvj0ZTQofSyw160zUwxieiFDLbWGP1v2WMBLuumvy/k1iJwbYTmSJCvTQbWK3sKbKNmWuV4rjm1xjPvhQ6dIOi9Ky9yWKdKpW/LOLEIZZltGUOBbtHAkpYpIwXTi+ojWXEUdOIOVDpV4UQbZr2pf1j1qCkohEtWbMgz95JSSTb/KUsA4QsDP1H6dQhGbYZXj2W2oyMlBjEVdP845hzy+5E/7+KTELznHwdvdaIMSG05Mw0jNlJ5SXR7ItQAWnwTGcTKCZOH+OLEwvnsbEfQyUudbDd5Qnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gVTCuOTikhSb1HjIaq3jrP8czKDqbH1kNTO/ajFBq4=;
 b=GUQHogk/66DdcO39DWXuqA5IyPZ4CPEzARvTepV+CPOxWzpHp9fA0xPS6MhYxbPQqdWf88efFKa8dNt2INFd7+iw/JH9DNJ1LWGiSMWQSLQBp+pwCq269HijrkauKRmLQZU+Pi8QYjrmGbEUBkm8ktv90Tnj2AUVzsSlC4eYNRRs+cI3WSIzikkZvu4Picpy85g+6bKADlllFbzwoqfVRxS/GlgU4o5z7fsDFUrKZX/vL3Oi8/LBFcBz/O8w3/i29xpE/VgpdFNgqk3MZjomSR4ZWwkffiPGC9QY4/XuL35A54IIWPtFym5xPsiDXO5GIHAMeulWnq9FRqeMHNkE7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gVTCuOTikhSb1HjIaq3jrP8czKDqbH1kNTO/ajFBq4=;
 b=muhdzYWz8+LaBFJVY00UJIW6jEKHNps1iviUwGq6sdvEt6AIN6DLM+AoZBIbjx4Lw9gmrKXcEW8pdFdabK6pl6Jj8zipdIZQO45rV5Mk/l+u9QTr4x7239rmpD1LuchEiHen2EE0kmZzRq6m/DHb7eDRP/4dAvO4iV/Z6DoCNCY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 DM8PR12MB5413.namprd12.prod.outlook.com (2603:10b6:8:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.7; Wed, 19 Jan 2022 06:33:57 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc%7]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 06:33:57 +0000
Message-ID: <0e523405-f52c-b152-1dd3-aa65a9caee3c@amd.com>
Date:   Wed, 19 Jan 2022 12:03:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-7-nikunj@amd.com>
 <010ef70c-31a2-2831-a2a7-950db14baf23@maciej.szmigiero.name>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <010ef70c-31a2-2831-a2a7-950db14baf23@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BMXPR01CA0016.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:d::26) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: beeeeaa5-3d11-4885-b00d-08d9db15ab94
X-MS-TrafficTypeDiagnostic: DM8PR12MB5413:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB541304180990DD42EC6732BFE2599@DM8PR12MB5413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVk6iFHmpYSHAGbDyPtDtVQgGZA3aRPNEDHYnPSfvdM0DjKD8ut3254DSvxs52DBMoyJgpRPui7li2ynWfkjQCVEv+VQgQhDHzP/6tEKHC/J28L9oia+YpgKd9EPxpJ7XtCjL4hjQZJCoacYidkL7E+gRud9S/muTawGsKDpkcKwg6FtSbtgtqZMSuMABSdIDZg8Mj2HSeRsFsJKoZdrnR1D5k8frmnjSKmAaspga2aqAguPZ81P9gYx9+bzqS/dhhvjs0dygVqGUhjPO1gBxNhk5Ok2NwSkC1Bsifw4e+LMxUopJ81WHMyZSZ8y03Qmm45fiimfp85VhXuIXXQ7EUeCGf9+6IDSiPrscHGOFWmK1qoQmvEgTlt5/foJ8TK+/rMidebgzOI4/6Bx5EMxhKuEolFrxg3b+XdolRACrMHjqlpcpmfrmMY3rR87TtZpSX5wFCWu8n3/V2q34VUKTujZ6MF6HwraiRsWjxECpzvsqg9PfFSF3thqhWNmp7xzj3tAGLnvhTgjZqpQcLi6Ipvq6eWnD3kzGY+crhuZ42yFgLhZa15iThAekFWeV8hQ3Nsd9XCHpOcs5O53nRHFj0RWzgfeHXAhXM6KIVBpE+53ERt2wuar39f4MHgTrmcISV9zPdiDewCSmBTKw/IFMqzyB/LMGC16dz1wqhe89WiObVxuIWsHjuDRBOIhPNuHVqkwI9eox4CA44WsVajbGg4inl9WJ7UGc4gFG209GQ12vnuYFk4zY1JoZQqN1mxc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(6506007)(6486002)(6512007)(7416002)(8936002)(4326008)(316002)(508600001)(6666004)(2906002)(31696002)(54906003)(38100700002)(186003)(36756003)(66556008)(66476007)(26005)(8676002)(66946007)(5660300002)(83380400001)(31686004)(6916009)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekJPb0RSSzE4enBOM21Mc0J3aWkxd21vRHFrT2hUeUVlb2NjQzB3K2VTMnU1?=
 =?utf-8?B?T2h2USsrRWhjamlObHdKOTJLeS83dFNlTk1BTGtkK0J4OW5sdjhlMS85OTl1?=
 =?utf-8?B?NEhVQ2RydFZqYkhKNzViUUlOb1NuSVlnbE5sc1NtS29UTmw0REt2TTFvb0wr?=
 =?utf-8?B?dGJZUTJsWTN4UjJnYmMrVVlNWUt5Y0lTSTFDZWdueXV0ZU15NW5mYzB4WjBx?=
 =?utf-8?B?K0hkL3NKMHFsN2dNSldkZWVDdUJhS3Z0MHhia2lncEY3WE54ZEhsTzFOQzFI?=
 =?utf-8?B?YzBSR09nY0U5VzBDQWxyVmhUSExMaElzdzczL1FzS205U0ZvQWw5M0Jsb3py?=
 =?utf-8?B?MUVPVEJiRVplSnNKck1KU2xnTlh5MVI0QUxTa1dpUnJQSld1b2QwRWJPVlZp?=
 =?utf-8?B?Z3U3bXplSDNqbjFlNHdQbXBPdkFoeXZzNEpKM0FVcmwvT2NVYThkZUNBdHIw?=
 =?utf-8?B?WGNEalVlTmtEQnY4UC9ZeW8zSXNpd1hvVDBaTEpHSlJyUVNTYlVXdmpJOWFG?=
 =?utf-8?B?YU9qM0ZSL3NiNjlhaVM1TDdXK014cXFHQmsyMzRNS3Qzek5aNXdHd2tvSXBa?=
 =?utf-8?B?NFZVbm1rQVRoVXUwcytUaERMRlc0MGZIajRNTXplR08ydmowQ1lsdnJUNWNj?=
 =?utf-8?B?cDliVlJMcXVNckVJc1V6RUhXcnp5UzdTQ1BaKzRNRjM2MVk2ZEU4N0szQ3Jt?=
 =?utf-8?B?MXdsMlVuaDJjbjVJT0RpbjVvNmI4blMzZDZEZUJWb2p4ZjdPTFpNM3R0Uit2?=
 =?utf-8?B?ZzYzdS9GV05hMktPVkFsSGE4UzBIWnFkWmcybXF2UXZLR0RRaW16SThXSGVN?=
 =?utf-8?B?TUhPWk5wcnY1VlFHSXd2NUVDQUNrUExhUzhaUDA4cFd1U3RneElWOC9USVJp?=
 =?utf-8?B?blJSVzh2QzdWMVA4RGR2RGdrT0lQeTFhd2ErdDBHbzIzOWRFV0d1MG10NEcx?=
 =?utf-8?B?cXVnY3pzcDlncXZkV0ZYQnl4VVQ0TkF6L3Z2S3NrakpEWXZCTzVBR1FSU0FU?=
 =?utf-8?B?Y2dCRTBtVXMxYlc4b0xoU2JIUExoOVJDN3NKNCtIc2JtS24wT2FRSlJCMk56?=
 =?utf-8?B?dW93UnBZNWlyY2pWbnhZejEvNE5ZQ2hVM1JjTUJLeUxPak5GbEFNRFlUM3Jh?=
 =?utf-8?B?bDBIZkhyYkRPeU94SWdaNlJuM0IyeWFoa2VQYTNiSk1BSmZmQzFRU0dJQnpz?=
 =?utf-8?B?cllGSDkvZmdacXo2ZEkwSmcvQ1FQVUNMa0JLU0RLKy9iZ3hJMUdwS2RkU015?=
 =?utf-8?B?M1lDSkloZzJlRExZMmVPQ1ZPUCsrL2xOWlE4WVZRa3Rya2hTL3VFK09kQ1ds?=
 =?utf-8?B?MjRZaFZRUm1lVFg0VVNzSW1nQThxUXNZdFIzYlVFemIveEREY1VKR3lUVXkw?=
 =?utf-8?B?UmRlRVJraEhVb0pTSVQyZFY1MHhjREpuN002aTdhamthc2FMbllSbnpUZHFC?=
 =?utf-8?B?NHZYQkplKzlVbzlxNDJsZU4veXloR1BkeVRjRkZrd0NaWCtuV1NsNkJkQStP?=
 =?utf-8?B?MDg2VVVDaXU5bWVabUpITXc4dXRpdXpYVjlQNzVCMTZjNnVKZm15ZHZnUDQx?=
 =?utf-8?B?TDZmQzI3Q0FpdjNzdWh0UVVydkttU2d2enJXakNTMGtzYU9OMUtHV2pOMEJD?=
 =?utf-8?B?QXhvSzJvVEdPUWdVNjdjK2Y1cCtha0hrRkJLbGhQYTVQRmZscEJwNHU4ejFz?=
 =?utf-8?B?SWtnbWZMUWo4M3hsam8zeE54Zm5BMHpzNEloZnJJVTJPN2RZVGJuNzR0NHlp?=
 =?utf-8?B?N2lPSmR0amoraFdMSGxyU0VmSlFHS203enRYYWROYmQvSEFaNHAzSUFsdDlD?=
 =?utf-8?B?aGlyZ3djY2J0UUt4SDdGODA1V1NOQ3hQVVZDd2xXUFZkVHg0MnZEdTRyZjQ1?=
 =?utf-8?B?UzBJOElzVWFDY20yTWI4bmV4QlNjeWZyNVlBSjBSUjdEbVdVUUM5RHNQbnFo?=
 =?utf-8?B?MmlrM3l4N1pHWXNoa0pPK3NjdDZDeDJxZ2Z5NElRTWprZ3pwNW1ma1NuVVVy?=
 =?utf-8?B?Q1NOM3g4cmZvRUR4Q3YrOHZuZFRlVEQrNnFFNVdkZUU2ajFlbjhmeTBGRHZI?=
 =?utf-8?B?OXpxMGo4R2lQaStwbnFYUFhQK2ZoNUJDcGhJdjBvZGV3TXNzK0NPemZqMis2?=
 =?utf-8?B?UUJINVBNNkp4bHBRVVZlK1h0eTIyYTFMNzRMRllTekR0K3N4d2F5VEdJVEhM?=
 =?utf-8?Q?Kc+bVj45VeC0a4y73m7ayQE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beeeeaa5-3d11-4885-b00d-08d9db15ab94
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 06:33:57.3923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxVWKZN5W7rpnQDWaWLzcUuRkq8YKqXuRmreOBaXnK6KMjw2i5OaOvgHTFnvAIgmgvoQ7b/Kq2vFbGb+tzxtbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maciej,

On 1/18/2022 8:30 PM, Maciej S. Szmigiero wrote:
> Hi Nikunj,
> 
> On 18.01.2022 12:06, Nikunj A Dadhania wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Pin the memory for the data being passed to launch_update_data()
>> because it gets encrypted before the guest is first run and must
>> not be moved which would corrupt it.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> [ * Changed hva_to_gva() to take an extra argument and return gpa_t.
>>    * Updated sev_pin_memory_in_mmu() error handling.
>>    * As pinning/unpining pages is handled within MMU, removed
>>      {get,put}_user(). ]
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 119 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 14aeccfc500b..1ae714e83a3c 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -22,6 +22,7 @@
>>   #include <asm/trapnr.h>
>>   #include <asm/fpu/xcr.h>
>>   +#include "mmu.h"
>>   #include "x86.h"
>>   #include "svm.h"
>>   #include "svm_ops.h"
>> @@ -490,6 +491,110 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>>       return pages;
>>   }
>>   +#define SEV_PFERR_RO (PFERR_USER_MASK)
>> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
>> +
>> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
>> +                          unsigned long hva)
>> +{
>> +    struct kvm_memslots *slots = kvm_memslots(kvm);
>> +    struct kvm_memory_slot *memslot;
>> +    int bkt;
>> +
>> +    kvm_for_each_memslot(memslot, bkt, slots) {
>> +        if (hva >= memslot->userspace_addr &&
>> +            hva < memslot->userspace_addr +
>> +            (memslot->npages << PAGE_SHIFT))
>> +            return memslot;
>> +    }
>> +
>> +    return NULL;
>> +}
> 
> We have kvm_for_each_memslot_in_hva_range() now, please don't do a linear
> search through memslots.
> You might need to move the aforementioned macro from kvm_main.c to some
> header file, though.

Sure, let me try optimizing with this newly added macro.

> 
>> +static gpa_t hva_to_gpa(struct kvm *kvm, unsigned long hva, bool *ro)
>> +{
>> +    struct kvm_memory_slot *memslot;
>> +    gpa_t gpa_offset;
>> +
>> +    memslot = hva_to_memslot(kvm, hva);
>> +    if (!memslot)
>> +        return UNMAPPED_GVA;
>> +
>> +    *ro = !!(memslot->flags & KVM_MEM_READONLY);
>> +    gpa_offset = hva - memslot->userspace_addr;
>> +    return ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
>> +}
>> +
>> +static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
>> +                       unsigned long size,
>> +                       unsigned long *npages)
>> +{
>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +    struct kvm_vcpu *vcpu;
>> +    struct page **pages;
>> +    unsigned long i;
>> +    u32 error_code;
>> +    kvm_pfn_t pfn;
>> +    int idx, ret = 0;
>> +    gpa_t gpa;
>> +    bool ro;
>> +
>> +    pages = sev_alloc_pages(sev, addr, size, npages);
>> +    if (IS_ERR(pages))
>> +        return pages;
>> +
>> +    vcpu = kvm_get_vcpu(kvm, 0);
>> +    if (mutex_lock_killable(&vcpu->mutex)) {
>> +        kvfree(pages);
>> +        return ERR_PTR(-EINTR);
>> +    }
>> +
>> +    vcpu_load(vcpu);
>> +    idx = srcu_read_lock(&kvm->srcu);
>> +
>> +    kvm_mmu_load(vcpu);
>> +
>> +    for (i = 0; i < *npages; i++, addr += PAGE_SIZE) {
>> +        if (signal_pending(current)) {
>> +            ret = -ERESTARTSYS;
>> +            break;
>> +        }
>> +
>> +        if (need_resched())
>> +            cond_resched();
>> +
>> +        gpa = hva_to_gpa(kvm, addr, &ro);
>> +        if (gpa == UNMAPPED_GVA) {
>> +            ret = -EFAULT;
>> +            break;
>> +        }
> 
> This function is going to have worst case O(n²) complexity if called with
> the whole VM memory (or O(n * log(n)) when hva_to_memslot() is modified
> to use kvm_for_each_memslot_in_hva_range()).

I understand your concern and will address it. BTW, this is called for a small 
fragment of VM memory( <10MB), that needs to be pinned before the guest execution 
starts.

> That's really bad for something that can be done in O(n) time - look how
> kvm_for_each_memslot_in_gfn_range() does it over gfns.
> 

I saw one use of kvm_for_each_memslot_in_gfn_range() in __kvm_zap_rmaps(), and 
that too calls slot_handle_level_range() which has a for_each_slot_rmap_range().
How would that be O(n) ?

kvm_for_each_memslot_in_gfn_range() {
	...
	slot_handle_level_range()
	...
}

slot_handle_level_range() {
	...
	for_each_slot_rmap_range() {
		...
	}
	...
}

Regards,
Nikunj
