Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC854168C00
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 03:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgBVCQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 21:16:04 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:57724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727614AbgBVCQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 21:16:03 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 029D1CC4DAC9F3D0C1A2;
        Sat, 22 Feb 2020 10:15:56 +0800 (CST)
Received: from [127.0.0.1] (10.177.246.209) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Sat, 22 Feb 2020
 10:15:49 +0800
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <arei.gonglei@huawei.com>,
        <weidong.huang@huawei.com>, <weifuqiang@huawei.com>,
        <kvm@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
 <20200218203717.GE28156@linux.intel.com>
 <a041fdb4-bfd0-ac4b-2809-6fddfc4f8d83@huawei.com>
 <20200219015836.GM28156@linux.intel.com>
 <098a5dd6-e1da-f161-97d7-cfe735d14fd8@oracle.com>
 <502b5e52-060b-6864-d1b7-eab2dc951aed@huawei.com>
 <a82956f7-26e4-5c1c-8d5d-4b2510f6b17d@oracle.com>
From:   "Longpeng (Mike)" <longpeng2@huawei.com>
Message-ID: <e2b9af10-b048-e5d2-e5b5-609622226a3c@huawei.com>
Date:   Sat, 22 Feb 2020 10:15:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a82956f7-26e4-5c1c-8d5d-4b2510f6b17d@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.246.209]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

在 2020/2/21 8:22, Mike Kravetz 写道:
> On 2/19/20 6:30 PM, Longpeng (Mike) wrote:
>> 在 2020/2/20 3:33, Mike Kravetz 写道:
>>> + Kirill
>>> On 2/18/20 5:58 PM, Sean Christopherson wrote:
>>>> On Wed, Feb 19, 2020 at 09:39:59AM +0800, Longpeng (Mike) wrote:
> <snip>
>>>> The race and the fix make sense.  I assumed dereferencing garbage from the
>>>> huge page was the issue, but I wasn't 100% that was the case, which is why
>>>> I asked about alternative fixes.
>>>>
>>>>> We change the code from
>>>>> 	if (pud_huge(*pud) || !pud_present(*pud))
>>>>> to
>>>>> 	if (pud_huge(*pud)
>>>>> 		return (pte_t *)pud;
>>>>> 	busy loop for 500ms
>>>>> 	if (!pud_present(*pud))
>>>>> 		return (pte_t *)pud;
>>>>> and the panic will be hit quickly.
>>>>>
>>>>> ARM64 has already use READ/WRITE_ONCE to access the pagetable, look at this
>>>>> commit 20a004e7 (arm64: mm: Use READ_ONCE/WRITE_ONCE when accessing page tables).
>>>>>
>>>>> The root cause is: 'if (pud_huge(*pud) || !pud_present(*pud))' read entry from
>>>>> pud twice and the *pud maybe change in a race, so if we only read the pud once.
>>>>> I use READ_ONCE here is just for safe, to prevents the complier mischief if
>>>>> possible.
>>>>
>>>> FWIW, I'd be in favor of going the READ/WRITE_ONCE() route for x86, e.g.
>>>> convert everything as a follow-up patch (or patches).  I'm fairly confident
>>>> that KVM's usage of lookup_address_in_mm() is safe, but I wouldn't exactly
>>>> bet my life on it.  I'd much rather the failing scenario be that KVM uses
>>>> a sub-optimal page size as opposed to exploding on a bad pointer.
>>>
>>> Longpeng(Mike) asked in another e-mail specifically about making similar
>>> changes to lookup_address_in_mm().  Replying here as there is more context.
>>>
>>> I 'think' lookup_address_in_mm is safe from this issue.  Why?  IIUC, the
>>> problem with the huge_pte_offset routine is that the pud changes from
>>> pud_none() to pud_huge() in the middle of
>>> 'if (pud_huge(*pud) || !pud_present(*pud))'.  In the case of
>>> lookup_address_in_mm, we know pud was not pud_none() as it was previously
>>> checked.  I am not aware of any other state transitions which could cause
>>> us trouble.  However, I am no expert in this area.
> 
> Bad copy/paste by me.  Longpeng(Mike) was asking about lookup_address_in_pgd.
> 
>> So... I need just fix huge_pte_offset in mm/hugetlb.c, right?
> 
> Let's start with just a fix for huge_pte_offset() as you can easily reproduce
> that issue by adding a delay.
> 
>> Is it possible the pud changes from pud_huge() to pud_none() while another CPU
>> is walking the pagetable ?
> 
All right, I'll send V2 to fix it, thanks :)

> I believe it is possible.  If we hole punch a hugetlbfs file, we will clear
> the corresponding pud's.  Hence, we can go from pud_huge() to pud_none().
> Unless I am missing something, that does imply we could have issues in places
> such as lookup_address_in_pgd:
> 
> 	pud = pud_offset(p4d, address);
> 	if (pud_none(*pud))
> 		return NULL;
> 
> 	*level = PG_LEVEL_1G;
> 	if (pud_large(*pud) || !pud_present(*pud))
> 		return (pte_t *)pud;
> 
> I hope I am wrong, but it seems like pud_none(*pud) could become true after
> the initial check, and before the (pud_large) check.  If so, there could be
> a problem (addressing exception) when the code continues and looks up the pmd.
> 
> 	pmd = pmd_offset(pud, address);
> 	if (pmd_none(*pmd))
> 		return NULL;
> 
> It has been mentioned before that there are many page table walks like this.
> What am I missing that prevents races like this?  Or, have we just been lucky?
> 
That's what I worry about. Maybe there is no usecase to hit it.

-- 
Regards,
Longpeng(Mike)

