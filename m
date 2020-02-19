Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7838C163975
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 02:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgBSBkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 20:40:14 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44480 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727996AbgBSBkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 20:40:14 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 23035346CDDA970D66F2;
        Wed, 19 Feb 2020 09:40:11 +0800 (CST)
Received: from [127.0.0.1] (10.177.246.209) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 09:40:01 +0800
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     <mike.kravetz@oracle.com>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <weidong.huang@huawei.com>,
        <weifuqiang@huawei.com>, <kvm@vger.kernel.org>
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
 <20200218203717.GE28156@linux.intel.com>
From:   "Longpeng (Mike)" <longpeng2@huawei.com>
Message-ID: <a041fdb4-bfd0-ac4b-2809-6fddfc4f8d83@huawei.com>
Date:   Wed, 19 Feb 2020 09:39:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200218203717.GE28156@linux.intel.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.246.209]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

�� 2020/2/19 4:37, Sean Christopherson д��:
> On Tue, Feb 18, 2020 at 08:10:25PM +0800, Longpeng(Mike) wrote:
>> Our machine encountered a panic after run for a long time and
>> the calltrace is:
> 
> What's the actual panic?  Is it a BUG() in hugetlb_fault(), a bad pointer
> dereference, etc...?
> 
A bad pointer dereference.

pgd -> pud -> user 1G hugepage
huge_pte_offset() wants to return NULL or pud (point to the entry), but it maybe
return the a bad pointer of the user 1G hugepage.

>> RIP: 0010:[<ffffffff9dff0587>]  [<ffffffff9dff0587>] hugetlb_fault+0x307/0xbe0
>> RSP: 0018:ffff9567fc27f808  EFLAGS: 00010286
>> RAX: e800c03ff1258d48 RBX: ffffd3bb003b69c0 RCX: e800c03ff1258d48
>> RDX: 17ff3fc00eda72b7 RSI: 00003ffffffff000 RDI: e800c03ff1258d48
>> RBP: ffff9567fc27f8c8 R08: e800c03ff1258d48 R09: 0000000000000080
>> R10: ffffaba0704c22a8 R11: 0000000000000001 R12: ffff95c87b4b60d8
>> R13: 00005fff00000000 R14: 0000000000000000 R15: ffff9567face8074
>> FS:  00007fe2d9ffb700(0000) GS:ffff956900e40000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: ffffd3bb003b69c0 CR3: 000000be67374000 CR4: 00000000003627e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  [<ffffffff9df9b71b>] ? unlock_page+0x2b/0x30
>>  [<ffffffff9dff04a2>] ? hugetlb_fault+0x222/0xbe0
>>  [<ffffffff9dff1405>] follow_hugetlb_page+0x175/0x540
>>  [<ffffffff9e15b825>] ? cpumask_next_and+0x35/0x50
>>  [<ffffffff9dfc7230>] __get_user_pages+0x2a0/0x7e0
>>  [<ffffffff9dfc648d>] __get_user_pages_unlocked+0x15d/0x210
>>  [<ffffffffc068cfc5>] __gfn_to_pfn_memslot+0x3c5/0x460 [kvm]
>>  [<ffffffffc06b28be>] try_async_pf+0x6e/0x2a0 [kvm]
>>  [<ffffffffc06b4b41>] tdp_page_fault+0x151/0x2d0 [kvm]
>>  [<ffffffffc075731c>] ? vmx_vcpu_run+0x2ec/0xc80 [kvm_intel]
>>  [<ffffffffc0757328>] ? vmx_vcpu_run+0x2f8/0xc80 [kvm_intel]
>>  [<ffffffffc06abc11>] kvm_mmu_page_fault+0x31/0x140 [kvm]
>>  [<ffffffffc074d1ae>] handle_ept_violation+0x9e/0x170 [kvm_intel]
>>  [<ffffffffc075579c>] vmx_handle_exit+0x2bc/0xc70 [kvm_intel]
>>  [<ffffffffc074f1a0>] ? __vmx_complete_interrupts.part.73+0x80/0xd0 [kvm_intel]
>>  [<ffffffffc07574c0>] ? vmx_vcpu_run+0x490/0xc80 [kvm_intel]
>>  [<ffffffffc069f3be>] vcpu_enter_guest+0x7be/0x13a0 [kvm]
>>  [<ffffffffc06cf53e>] ? kvm_check_async_pf_completion+0x8e/0xb0 [kvm]
>>  [<ffffffffc06a6f90>] kvm_arch_vcpu_ioctl_run+0x330/0x490 [kvm]
>>  [<ffffffffc068d919>] kvm_vcpu_ioctl+0x309/0x6d0 [kvm]
>>  [<ffffffff9deaa8c2>] ? dequeue_signal+0x32/0x180
>>  [<ffffffff9deae34d>] ? do_sigtimedwait+0xcd/0x230
>>  [<ffffffff9e03aed0>] do_vfs_ioctl+0x3f0/0x540
>>  [<ffffffff9e03b0c1>] SyS_ioctl+0xa1/0xc0
>>  [<ffffffff9e53879b>] system_call_fastpath+0x22/0x27
>>
>> ( The kernel we used is older, but we think the latest kernel also has this
>>   bug after dig into this problem. )
>>
>> For 1G hugepages, huge_pte_offset() wants to return NULL or pudp, but it
>> may return a wrong 'pmdp' if there is a race. Please look at the following
>> code snippet:
>>     ...
>>     pud = pud_offset(p4d, addr);
>>     if (sz != PUD_SIZE && pud_none(*pud))
>>         return NULL;
>>     /* hugepage or swap? */
>>     if (pud_huge(*pud) || !pud_present(*pud))
>>         return (pte_t *)pud;
>>
>>     pmd = pmd_offset(pud, addr);
>>     if (sz != PMD_SIZE && pmd_none(*pmd))
>>         return NULL;
>>     /* hugepage or swap? */
>>     if (pmd_huge(*pmd) || !pmd_present(*pmd))
>>         return (pte_t *)pmd;
>>     ...
>>
>> The following sequence would trigger this bug:
>> 1. CPU0: sz = PUD_SIZE and *pud = 0 , continue
>> 1. CPU0: "pud_huge(*pud)" is false
>> 2. CPU1: calling hugetlb_no_page and set *pud to xxxx8e7(PRESENT)
>> 3. CPU0: "!pud_present(*pud)" is false, continue
>> 4. CPU0: pmd = pmd_offset(pud, addr) and maybe return a wrong pmdp
>> However, we want CPU0 to return NULL or pudp.
>>
>> We can avoid this race by read the pud only once.
> 
> Are there any other options for avoiding the panic you hit?  I ask because
> there are a variety of flows that use a very similar code pattern, e.g.
> lookup_address_in_pgd(), and using READ_ONCE() in huge_pte_offset() but not
> other flows could be confusing (or in my case, anxiety inducing[*]).  At
> the least, adding a comment in huge_pte_offset() to explain the need for
> READ_ONCE() would be helpful.
>
I hope the hugetlb and mm maintainers could give some other options if they
approve this bug.
We change the code from
	if (pud_huge(*pud) || !pud_present(*pud))
to
	if (pud_huge(*pud)
		return (pte_t *)pud;
	busy loop for 500ms
	if (!pud_present(*pud))
		return (pte_t *)pud;
and the panic will be hit quickly.

ARM64 has already use READ/WRITE_ONCE to access the pagetable, look at this
commit 20a004e7 (arm64: mm: Use READ_ONCE/WRITE_ONCE when accessing page tables).

The root cause is: 'if (pud_huge(*pud) || !pud_present(*pud))' read entry from
pud twice and the *pud maybe change in a race, so if we only read the pud once.
I use READ_ONCE here is just for safe, to prevents the complier mischief if
possible.

I'll add comments in v2.

> [*] In kernel 5.6, KVM is moving to using lookup_address_in_pgd() (via
>     lookup_address_in_mm()) to identify large page mappings.  The function
>     itself is susceptible to such a race, but KVM only does the lookup
>     after it has done gup() and also ensures any zapping of ptes will cause
>     KVM to restart the faulting (guest) instruction or that the zap will be
>     blocked until after KVM does the lookup, i.e. racing with a transition
>     from !PRESENT -> PRESENT should be impossible (in theory).
> 
This bug is from hugetlb core, we could trigger it in other usages even if the
latest KVM won't.

>> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
>> ---
>>  mm/hugetlb.c | 34 ++++++++++++++++++----------------
>>  1 file changed, 18 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index dd8737a..3bde229 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -4908,31 +4908,33 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
>>  pte_t *huge_pte_offset(struct mm_struct *mm,
>>  		       unsigned long addr, unsigned long sz)
>>  {
>> -	pgd_t *pgd;
>> -	p4d_t *p4d;
>> -	pud_t *pud;
>> -	pmd_t *pmd;
>> +	pgd_t *pgdp;
>> +	p4d_t *p4dp;
>> +	pud_t *pudp, pud;
>> +	pmd_t *pmdp, pmd;
>>  
>> -	pgd = pgd_offset(mm, addr);
>> -	if (!pgd_present(*pgd))
>> +	pgdp = pgd_offset(mm, addr);
>> +	if (!pgd_present(*pgdp))
>>  		return NULL;
>> -	p4d = p4d_offset(pgd, addr);
>> -	if (!p4d_present(*p4d))
>> +	p4dp = p4d_offset(pgdp, addr);
>> +	if (!p4d_present(*p4dp))
>>  		return NULL;
>>  
>> -	pud = pud_offset(p4d, addr);
>> -	if (sz != PUD_SIZE && pud_none(*pud))
>> +	pudp = pud_offset(p4dp, addr);
>> +	pud = READ_ONCE(*pudp);
>> +	if (sz != PUD_SIZE && pud_none(pud))
>>  		return NULL;
>>  	/* hugepage or swap? */
>> -	if (pud_huge(*pud) || !pud_present(*pud))
>> -		return (pte_t *)pud;
>> +	if (pud_huge(pud) || !pud_present(pud))
>> +		return (pte_t *)pudp;
>>  
>> -	pmd = pmd_offset(pud, addr);
>> -	if (sz != PMD_SIZE && pmd_none(*pmd))
>> +	pmdp = pmd_offset(pudp, addr);
>> +	pmd = READ_ONCE(*pmdp);
>> +	if (sz != PMD_SIZE && pmd_none(pmd))
>>  		return NULL;
>>  	/* hugepage or swap? */
>> -	if (pmd_huge(*pmd) || !pmd_present(*pmd))
>> -		return (pte_t *)pmd;
>> +	if (pmd_huge(pmd) || !pmd_present(pmd))
>> +		return (pte_t *)pmdp;
>>  
>>  	return NULL;
>>  }
>> -- 
>> 1.8.3.1
>>
>>
> 
> .
> 


-- 
Regards,
Longpeng(Mike)

