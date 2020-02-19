Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0361F164EF3
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 20:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgBSTdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 14:33:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35986 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgBSTdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 14:33:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JJXKuA144965;
        Wed, 19 Feb 2020 19:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=X5qzcOpy3VlKMndETNl6L0f1kWYOYvm23ts3KVhlQPM=;
 b=m5v9iDq2tFVQJFmeoaNzAN3JFRHJXQPthZkWDElsSLuv0ce2WgkIyBTVDazZLaK69q2u
 evEWCEPFmc13Q3hQDo9eDpCWQ/0AWcMqud/xocUHMNtuL40wuLXdYuKZdBWYbTxdTjVv
 HPCu+AQBjK5F11qhUf6G5wcnySX7ZCUaBSn6fzoQiEtFG9wS3xwK1jhDj47IrjO4jckm
 9DjF+P1y2bEnLqQjrWjM7d6YV5FlEL44O4RBT5vWlLQ6Cssuz1frR8W9+3whk+lAnVr+
 EchWtVwCxcROJPllIVYUhrDGmLGbNuhENBkCWivVw7wkTKQfhOWQkl1DnkM/dQzzISoj qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y8udkdbfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 19:33:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JJWDkf152341;
        Wed, 19 Feb 2020 19:33:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y8udb3p6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 19:33:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01JJXHIH006227;
        Wed, 19 Feb 2020 19:33:17 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 11:33:17 -0800
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Longpeng (Mike)" <longpeng2@huawei.com>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kvm@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
 <20200218203717.GE28156@linux.intel.com>
 <a041fdb4-bfd0-ac4b-2809-6fddfc4f8d83@huawei.com>
 <20200219015836.GM28156@linux.intel.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <098a5dd6-e1da-f161-97d7-cfe735d14fd8@oracle.com>
Date:   Wed, 19 Feb 2020 11:33:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219015836.GM28156@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ Kirill
On 2/18/20 5:58 PM, Sean Christopherson wrote:
> On Wed, Feb 19, 2020 at 09:39:59AM +0800, Longpeng (Mike) wrote:
>> 在 2020/2/19 4:37, Sean Christopherson 写道:
>>> On Tue, Feb 18, 2020 at 08:10:25PM +0800, Longpeng(Mike) wrote:
>>>> Our machine encountered a panic after run for a long time and
>>>> the calltrace is:
>>>
>>> What's the actual panic?  Is it a BUG() in hugetlb_fault(), a bad pointer
>>> dereference, etc...?
>>>
>> A bad pointer dereference.
>>
>> pgd -> pud -> user 1G hugepage
>> huge_pte_offset() wants to return NULL or pud (point to the entry), but it maybe
>> return the a bad pointer of the user 1G hugepage.
>>
>>>> RIP: 0010:[<ffffffff9dff0587>]  [<ffffffff9dff0587>] hugetlb_fault+0x307/0xbe0
>>>> RSP: 0018:ffff9567fc27f808  EFLAGS: 00010286
>>>> RAX: e800c03ff1258d48 RBX: ffffd3bb003b69c0 RCX: e800c03ff1258d48
>>>> RDX: 17ff3fc00eda72b7 RSI: 00003ffffffff000 RDI: e800c03ff1258d48
>>>> RBP: ffff9567fc27f8c8 R08: e800c03ff1258d48 R09: 0000000000000080
>>>> R10: ffffaba0704c22a8 R11: 0000000000000001 R12: ffff95c87b4b60d8
>>>> R13: 00005fff00000000 R14: 0000000000000000 R15: ffff9567face8074
>>>> FS:  00007fe2d9ffb700(0000) GS:ffff956900e40000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: ffffd3bb003b69c0 CR3: 000000be67374000 CR4: 00000000003627e0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>> Call Trace:
>>>>  [<ffffffff9df9b71b>] ? unlock_page+0x2b/0x30
>>>>  [<ffffffff9dff04a2>] ? hugetlb_fault+0x222/0xbe0
>>>>  [<ffffffff9dff1405>] follow_hugetlb_page+0x175/0x540
>>>>  [<ffffffff9e15b825>] ? cpumask_next_and+0x35/0x50
>>>>  [<ffffffff9dfc7230>] __get_user_pages+0x2a0/0x7e0
>>>>  [<ffffffff9dfc648d>] __get_user_pages_unlocked+0x15d/0x210
>>>>  [<ffffffffc068cfc5>] __gfn_to_pfn_memslot+0x3c5/0x460 [kvm]
>>>>  [<ffffffffc06b28be>] try_async_pf+0x6e/0x2a0 [kvm]
>>>>  [<ffffffffc06b4b41>] tdp_page_fault+0x151/0x2d0 [kvm]
>>>>  [<ffffffffc075731c>] ? vmx_vcpu_run+0x2ec/0xc80 [kvm_intel]
>>>>  [<ffffffffc0757328>] ? vmx_vcpu_run+0x2f8/0xc80 [kvm_intel]
>>>>  [<ffffffffc06abc11>] kvm_mmu_page_fault+0x31/0x140 [kvm]
>>>>  [<ffffffffc074d1ae>] handle_ept_violation+0x9e/0x170 [kvm_intel]
>>>>  [<ffffffffc075579c>] vmx_handle_exit+0x2bc/0xc70 [kvm_intel]
>>>>  [<ffffffffc074f1a0>] ? __vmx_complete_interrupts.part.73+0x80/0xd0 [kvm_intel]
>>>>  [<ffffffffc07574c0>] ? vmx_vcpu_run+0x490/0xc80 [kvm_intel]
>>>>  [<ffffffffc069f3be>] vcpu_enter_guest+0x7be/0x13a0 [kvm]
>>>>  [<ffffffffc06cf53e>] ? kvm_check_async_pf_completion+0x8e/0xb0 [kvm]
>>>>  [<ffffffffc06a6f90>] kvm_arch_vcpu_ioctl_run+0x330/0x490 [kvm]
>>>>  [<ffffffffc068d919>] kvm_vcpu_ioctl+0x309/0x6d0 [kvm]
>>>>  [<ffffffff9deaa8c2>] ? dequeue_signal+0x32/0x180
>>>>  [<ffffffff9deae34d>] ? do_sigtimedwait+0xcd/0x230
>>>>  [<ffffffff9e03aed0>] do_vfs_ioctl+0x3f0/0x540
>>>>  [<ffffffff9e03b0c1>] SyS_ioctl+0xa1/0xc0
>>>>  [<ffffffff9e53879b>] system_call_fastpath+0x22/0x27
>>>>
>>>> ( The kernel we used is older, but we think the latest kernel also has this
>>>>   bug after dig into this problem. )
>>>>
>>>> For 1G hugepages, huge_pte_offset() wants to return NULL or pudp, but it
>>>> may return a wrong 'pmdp' if there is a race. Please look at the following
>>>> code snippet:
>>>>     ...
>>>>     pud = pud_offset(p4d, addr);
>>>>     if (sz != PUD_SIZE && pud_none(*pud))
>>>>         return NULL;
>>>>     /* hugepage or swap? */
>>>>     if (pud_huge(*pud) || !pud_present(*pud))
>>>>         return (pte_t *)pud;
>>>>
>>>>     pmd = pmd_offset(pud, addr);
>>>>     if (sz != PMD_SIZE && pmd_none(*pmd))
>>>>         return NULL;
>>>>     /* hugepage or swap? */
>>>>     if (pmd_huge(*pmd) || !pmd_present(*pmd))
>>>>         return (pte_t *)pmd;
>>>>     ...
>>>>
>>>> The following sequence would trigger this bug:
>>>> 1. CPU0: sz = PUD_SIZE and *pud = 0 , continue
>>>> 1. CPU0: "pud_huge(*pud)" is false
>>>> 2. CPU1: calling hugetlb_no_page and set *pud to xxxx8e7(PRESENT)
>>>> 3. CPU0: "!pud_present(*pud)" is false, continue
>>>> 4. CPU0: pmd = pmd_offset(pud, addr) and maybe return a wrong pmdp
>>>> However, we want CPU0 to return NULL or pudp.
>>>>
>>>> We can avoid this race by read the pud only once.
>>>
>>> Are there any other options for avoiding the panic you hit?  I ask because
>>> there are a variety of flows that use a very similar code pattern, e.g.
>>> lookup_address_in_pgd(), and using READ_ONCE() in huge_pte_offset() but not
>>> other flows could be confusing (or in my case, anxiety inducing[*]).  At
>>> the least, adding a comment in huge_pte_offset() to explain the need for
>>> READ_ONCE() would be helpful.
>>>
>> I hope the hugetlb and mm maintainers could give some other options if they
>> approve this bug.
> 
> The race and the fix make sense.  I assumed dereferencing garbage from the
> huge page was the issue, but I wasn't 100% that was the case, which is why
> I asked about alternative fixes.
> 
>> We change the code from
>> 	if (pud_huge(*pud) || !pud_present(*pud))
>> to
>> 	if (pud_huge(*pud)
>> 		return (pte_t *)pud;
>> 	busy loop for 500ms
>> 	if (!pud_present(*pud))
>> 		return (pte_t *)pud;
>> and the panic will be hit quickly.
>>
>> ARM64 has already use READ/WRITE_ONCE to access the pagetable, look at this
>> commit 20a004e7 (arm64: mm: Use READ_ONCE/WRITE_ONCE when accessing page tables).
>>
>> The root cause is: 'if (pud_huge(*pud) || !pud_present(*pud))' read entry from
>> pud twice and the *pud maybe change in a race, so if we only read the pud once.
>> I use READ_ONCE here is just for safe, to prevents the complier mischief if
>> possible.
> 
> FWIW, I'd be in favor of going the READ/WRITE_ONCE() route for x86, e.g.
> convert everything as a follow-up patch (or patches).  I'm fairly confident
> that KVM's usage of lookup_address_in_mm() is safe, but I wouldn't exactly
> bet my life on it.  I'd much rather the failing scenario be that KVM uses
> a sub-optimal page size as opposed to exploding on a bad pointer.

Longpeng(Mike) asked in another e-mail specifically about making similar
changes to lookup_address_in_mm().  Replying here as there is more context.

I 'think' lookup_address_in_mm is safe from this issue.  Why?  IIUC, the
problem with the huge_pte_offset routine is that the pud changes from
pud_none() to pud_huge() in the middle of
'if (pud_huge(*pud) || !pud_present(*pud))'.  In the case of
lookup_address_in_mm, we know pud was not pud_none() as it was previously
checked.  I am not aware of any other state transitions which could cause
us trouble.  However, I am no expert in this area.
-- 
Mike Kravetz
