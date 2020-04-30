Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5111F1BFFFF
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgD3PUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:20:35 -0400
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:32888
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726468AbgD3PUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 11:20:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXaLjkxIZvnOs6JqvjLwpsAQk9yI1Q9bXnXgqi3Wo8vsINhcC72kU15i98iKwAPRCBQY4aPRxVqD+NYc5P3GlZDEVdWoE/TBw20MHfCezA0DWlhXH2YgSVNOubZKwlniu0y7qWA2cUA31T5V3otM9Pr+QszP3XrBpgAJmPBE3D2Ilty144A7+ZoV1Fl2vGI4jS00mbhrcXbPAWOa14wBYFH2nZkuKOFnSCwACHU3Szm6vTphHscYarwjjhP7vequNPrARwMGTcPNInSUxu6MHUXy1oEjW1m644uEl6CA33naOpAQvSXy7/wf0eH8VtBvjIb5pA7+4NuQJP7J2gPnqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cER7JEsYjSdkgwG6iBkDOpeP6vU6ywTF4jdK+eMQziI=;
 b=CbuTu3SqLCCwTJ0uOCEsQslWPoXVz6yXDk3FjYcwL0bHKc/ZLavLiRdHg6AEKkE0TA4mpCxvf8rcTbiOFIe3YL79GSEFT0mIc+/hXvPuZUaROEuJfXH8+vjs0zrbcOl23VYrkbU8O5t6uyYYGFeY/6Jb2+Jye0CtiWZvFudJlo/eGA7pjpv0eOFTIDC6JNNQ8/e37X8vpi/S3Ht33Agso0a2GDIicMHfPN0i8TWxx3NqoSrKgStlyMvYTBKxwYxkfT9uasmmgtO+821KqGlb6I3YC18LsIi26dQRpRovYzxA0Y6XmCJx2OqwXNF15+SFKbwd/ZVfT4lvqF1SAsPx9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cER7JEsYjSdkgwG6iBkDOpeP6vU6ywTF4jdK+eMQziI=;
 b=1bZbD7NeAyIddJvrz+76T/WZH+ihOuVcW0SWVVABpxy21K+L1b2fpnH7Refu2dLGvDJgNB2wRa3E8LPlr1InfN1iS2DBhCsWsjr2iqI8ZwQtX22cJkR4z0IzRGW6SmSOiHfnS5jHrTPGYYGcReSAaWZYugNozjqnhn4it/PiXDs=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 15:20:31 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::38b5:63c2:6c7c:d03d]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::38b5:63c2:6c7c:d03d%7]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 15:20:31 +0000
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, venu.busireddy@oracle.com
Subject: Re: [PATCH v7 11/18] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <c167e7191cb8f9c7635f5d8cfecb1157cc96cf6b.1588234824.git.ashish.kalra@amd.com>
 <486fe740-0c2d-9d2b-d490-bdb3215a120c@suse.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <c75af894-b216-d8c0-8863-7df1ccff5c9f@amd.com>
Date:   Thu, 30 Apr 2020 10:21:29 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <486fe740-0c2d-9d2b-d490-bdb3215a120c@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0401CA0003.namprd04.prod.outlook.com
 (2603:10b6:803:21::13) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0401CA0003.namprd04.prod.outlook.com (2603:10b6:803:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 15:20:29 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 37ebd0c5-d71c-4c65-9e9c-08d7ed1a0547
X-MS-TrafficTypeDiagnostic: SA0PR12MB4464:|SA0PR12MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4464B911722079B7CD3267EFE5AA0@SA0PR12MB4464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +cP7M4sQ2sgEIo6O39PAwVncNjW5gmHr/hEm0CgRrGnAlKVEGrQ9BoLor6FbZPgl9fgOnRDKtqS4syZBEvJegXqA+DGAgG2m2OamneZFoPQjhgMvkKk8Wyb8KLd4I6XQMauXZY8IrTgVspg1gns2bjdBwadOPyxVH7QbZClS8KgKo4L4QA5OQ5i+pa6CLblrAvKp0qG1S/N55r6xUznGRfpkFT4zrZznaIBNrFrZLNbTZsCHRKpo8FEtav9eLqPi4DRyG9SqxskHfSRcAaw8e0GQpfGb8s4ACqqYxdZ3AUfW1fuc/W0PJ4jrMVQrVxjIfUivyCa6u+LF86AtU43h4BF8gx4VGjKxuKZHE/0NU+cIdu9YB5mtm+vwZYx/dDf7kDWtoakZCyYSDoSArKgabfSxphCf9IeUH7HzTskVzCd9AI6qa3gnOWd+jbsGieKD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(16526019)(6486002)(956004)(6506007)(4326008)(66574012)(7416002)(36756003)(53546011)(186003)(26005)(2616005)(44832011)(2906002)(31686004)(316002)(31696002)(86362001)(8936002)(5660300002)(478600001)(110136005)(66476007)(66556008)(8676002)(52116002)(6512007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a1JHY68Q+8j9JY5O/ai6yjaHfqRBeAoROeUymFRwhqg+RQ0y7Z4MmzQFTUjAa4BDaoa5UHitQgDNWurvyAABZMnqD+GJHOEdcuhwjcefckZub7Ns8vcC444A9FzRarCmWX6kbvQe5zuPl08nGqW5HkCCbAJRxM9ALha3OI84D2cIF6zbUAm1oSbNGv9UVhGROGfq68LWnHaycnOG8PzUna8mXfbK5/x1ZrAebLfCrtz9nB91/s1CQ5JgF/M2nAHrUpj+CEiAsD4lwCx9os/dGi9dI5WBPRAthmFTqqdbXbjod+WecN0U/We0ny73ifiHW9U79EtrrA4GM/zV/rObulcSM6IlmmvBXkj27YBCzWwvyhVAAcEif7LyzW7x+zPNRQkk960gdiLTNwESMFyr8WfHS1w31Fja7gpvK77VZOPZ9Nl/R41GCVMB6GIAyq5wuRJpxO8gmsHMELJGLKPBUy8/Nfl9E4Wi1jIqhUh3XW5I086vFFIbfelkqZ5DKn3r+ngOEnreMogitCu7klQJkD/2iq53iQjR+nBfDmpfa6NKiYdgi6pxi65qj5azdcqBU5oQ1xSeQexcqhKJLSV6E7v17cscbcJGzsksgPRBM36OMd4LbGCh0mIDC+y+04MaaJYQslrwM6MhSa4341yKc3vW0bcUngi2hi1Sbl2wy6fpk2Evgv4R3H0ECOJDcKf+3qMsFNYwR8Z+9jEWu3ci6tpYYo9QIPD1zvJnonTunt5cAOArLlsmELzaH2JkP91r2tjjQV7MWVOuwn+GXAI29vUs9JYOENzH7DhQr3MHUM0=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ebd0c5-d71c-4c65-9e9c-08d7ed1a0547
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 15:20:31.1420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +K5Ze8KZ4bDCHptzD0xP0FOhqQMpCTUiBElAs45pKNEg0MOIoMaD80ScP1dgYW4v02HNFZKf5Ow6zEqo29617g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/30/20 4:49 AM, Jürgen Groß wrote:
> On 30.04.20 10:45, Ashish Kalra wrote:
>> From: Brijesh Singh <Brijesh.Singh@amd.com>
>>
>> Invoke a hypercall when a memory region is changed from encrypted ->
>> decrypted and vice versa. Hypervisor needs to know the page encryption
>> status during the guest migration.
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: x86@kernel.org
>> Cc: kvm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>   arch/x86/include/asm/paravirt.h       | 10 +++++
>>   arch/x86/include/asm/paravirt_types.h |  2 +
>>   arch/x86/kernel/paravirt.c            |  1 +
>>   arch/x86/mm/mem_encrypt.c             | 58 ++++++++++++++++++++++++++-
>>   arch/x86/mm/pat/set_memory.c          |  7 ++++
>>   5 files changed, 77 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/paravirt.h
>> b/arch/x86/include/asm/paravirt.h
>> index 694d8daf4983..8127b9c141bf 100644
>> --- a/arch/x86/include/asm/paravirt.h
>> +++ b/arch/x86/include/asm/paravirt.h
>> @@ -78,6 +78,12 @@ static inline void paravirt_arch_exit_mmap(struct
>> mm_struct *mm)
>>       PVOP_VCALL1(mmu.exit_mmap, mm);
>>   }
>>   +static inline void page_encryption_changed(unsigned long vaddr,
>> int npages,
>> +                        bool enc)
>> +{
>> +    PVOP_VCALL3(mmu.page_encryption_changed, vaddr, npages, enc);
>> +}
>> +
>>   #ifdef CONFIG_PARAVIRT_XXL
>>   static inline void load_sp0(unsigned long sp0)
>>   {
>> @@ -946,6 +952,10 @@ static inline void paravirt_arch_dup_mmap(struct
>> mm_struct *oldmm,
>>   static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
>>   {
>>   }
>> +
>> +static inline void page_encryption_changed(unsigned long vaddr, int
>> npages, bool enc)
>> +{
>> +}
>>   #endif
>>   #endif /* __ASSEMBLY__ */
>>   #endif /* _ASM_X86_PARAVIRT_H */
>> diff --git a/arch/x86/include/asm/paravirt_types.h
>> b/arch/x86/include/asm/paravirt_types.h
>> index 732f62e04ddb..03bfd515c59c 100644
>> --- a/arch/x86/include/asm/paravirt_types.h
>> +++ b/arch/x86/include/asm/paravirt_types.h
>> @@ -215,6 +215,8 @@ struct pv_mmu_ops {
>>         /* Hook for intercepting the destruction of an mm_struct. */
>>       void (*exit_mmap)(struct mm_struct *mm);
>> +    void (*page_encryption_changed)(unsigned long vaddr, int npages,
>> +                    bool enc);
>>     #ifdef CONFIG_PARAVIRT_XXL
>>       struct paravirt_callee_save read_cr2;
>> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
>> index c131ba4e70ef..840c02b23aeb 100644
>> --- a/arch/x86/kernel/paravirt.c
>> +++ b/arch/x86/kernel/paravirt.c
>> @@ -367,6 +367,7 @@ struct paravirt_patch_template pv_ops = {
>>               (void (*)(struct mmu_gather *, void *))tlb_remove_page,
>>         .mmu.exit_mmap        = paravirt_nop,
>> +    .mmu.page_encryption_changed    = paravirt_nop,
>>     #ifdef CONFIG_PARAVIRT_XXL
>>       .mmu.read_cr2        = __PV_IS_CALLEE_SAVE(native_read_cr2),
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index f4bd4b431ba1..603f5abf8a78 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -19,6 +19,7 @@
>>   #include <linux/kernel.h>
>>   #include <linux/bitops.h>
>>   #include <linux/dma-mapping.h>
>> +#include <linux/kvm_para.h>
>>     #include <asm/tlbflush.h>
>>   #include <asm/fixmap.h>
>> @@ -29,6 +30,7 @@
>>   #include <asm/processor-flags.h>
>>   #include <asm/msr.h>
>>   #include <asm/cmdline.h>
>> +#include <asm/kvm_para.h>
>>     #include "mm_internal.h"
>>   @@ -196,6 +198,48 @@ void __init sme_early_init(void)
>>           swiotlb_force = SWIOTLB_FORCE;
>>   }
>>   +static void set_memory_enc_dec_hypercall(unsigned long vaddr, int
>> npages,
>> +                    bool enc)
>> +{
>> +    unsigned long sz = npages << PAGE_SHIFT;
>> +    unsigned long vaddr_end, vaddr_next;
>> +
>> +    vaddr_end = vaddr + sz;
>> +
>> +    for (; vaddr < vaddr_end; vaddr = vaddr_next) {
>> +        int psize, pmask, level;
>> +        unsigned long pfn;
>> +        pte_t *kpte;
>> +
>> +        kpte = lookup_address(vaddr, &level);
>> +        if (!kpte || pte_none(*kpte))
>> +            return;
>> +
>> +        switch (level) {
>> +        case PG_LEVEL_4K:
>> +            pfn = pte_pfn(*kpte);
>> +            break;
>> +        case PG_LEVEL_2M:
>> +            pfn = pmd_pfn(*(pmd_t *)kpte);
>> +            break;
>> +        case PG_LEVEL_1G:
>> +            pfn = pud_pfn(*(pud_t *)kpte);
>> +            break;
>> +        default:
>> +            return;
>> +        }
>> +
>> +        psize = page_level_size(level);
>> +        pmask = page_level_mask(level);
>> +
>> +        if (x86_platform.hyper.sev_migration_hcall)
>> +            x86_platform.hyper.sev_migration_hcall(pfn << PAGE_SHIFT,
>> +                                   psize >> PAGE_SHIFT,
>> +                                   enc);
>
> Why do you need two indirections? One via pv.mmu_ops and then another
> via x86_platform.hyper? Isn't one enough?
>
Currently, there is no strong reason to have two indirections other than
building a flexibility for the future expansion, e.g when we add SEV
support for the Xen then hypercall invocation may be slightly different
but the code to walk the page table to find the GPA will be same for
both KVM and Xen. The pv.mmu_ops provides a generic indirection which
can be used by set_memory_{decrypted,encrypted}. I will look into
removing the extra indirection in next version. thanks.


> And if x86_platform.hyper.sev_migration_hcall isn't set the whole loop
> is basically a nop.
>
Yes, this double indirection has a draw back that we will be executing
the unnecessary code  when x86_platform.hyper.sev_migration_hcall isn't
set. I will look into improving it.


>> +        vaddr_next = (vaddr & pmask) + psize;
>> +    }
>> +}
>> +
>>   static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>>   {
>>       pgprot_t old_prot, new_prot;
>> @@ -253,12 +297,13 @@ static void __init __set_clr_pte_enc(pte_t
>> *kpte, int level, bool enc)
>>   static int __init early_set_memory_enc_dec(unsigned long vaddr,
>>                          unsigned long size, bool enc)
>>   {
>> -    unsigned long vaddr_end, vaddr_next;
>> +    unsigned long vaddr_end, vaddr_next, start;
>>       unsigned long psize, pmask;
>>       int split_page_size_mask;
>>       int level, ret;
>>       pte_t *kpte;
>>   +    start = vaddr;
>>       vaddr_next = vaddr;
>>       vaddr_end = vaddr + size;
>>   @@ -313,6 +358,8 @@ static int __init
>> early_set_memory_enc_dec(unsigned long vaddr,
>>         ret = 0;
>>   +    set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >>
>> PAGE_SHIFT,
>> +                    enc);
>>   out:
>>       __flush_tlb_all();
>>       return ret;
>> @@ -451,6 +498,15 @@ void __init mem_encrypt_init(void)
>>       if (sev_active())
>>           static_branch_enable(&sev_enable_key);
>>   +#ifdef CONFIG_PARAVIRT
>> +    /*
>> +     * With SEV, we need to make a hypercall when page encryption
>> state is
>> +     * changed.
>> +     */
>> +    if (sev_active())
>> +        pv_ops.mmu.page_encryption_changed =
>> set_memory_enc_dec_hypercall;
>> +#endif
>> +
>>       pr_info("AMD %s active\n",
>>           sev_active() ? "Secure Encrypted Virtualization (SEV)"
>>                    : "Secure Memory Encryption (SME)");
>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>> index 59eca6a94ce7..9aaf1b6f5a1b 100644
>> --- a/arch/x86/mm/pat/set_memory.c
>> +++ b/arch/x86/mm/pat/set_memory.c
>> @@ -27,6 +27,7 @@
>>   #include <asm/proto.h>
>>   #include <asm/memtype.h>
>>   #include <asm/set_memory.h>
>> +#include <asm/paravirt.h>
>>     #include "../mm_internal.h"
>>   @@ -2003,6 +2004,12 @@ static int __set_memory_enc_dec(unsigned
>> long addr, int numpages, bool enc)
>>        */
>>       cpa_flush(&cpa, 0);
>>   +    /* Notify hypervisor that a given memory range is mapped
>> encrypted
>> +     * or decrypted. The hypervisor will use this information during
>> the
>> +     * VM migration.
>> +     */
>> +    page_encryption_changed(addr, numpages, enc);
>
> Is this operation really so performance critical that a pv-op is
> needed? Wouldn't a static key be sufficient here?
>
Well, in a typical Linux kernel boot it does not get called so many
times. We noticed that some drivers (mainly nvme) calls it more often
than others. I am open for the suggestions, we went with the pv-op path
based on the previous feedbacks. A static key maybe sufficient as well.

