Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59F91644AD
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 13:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgBSMwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 07:52:53 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33276 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726491AbgBSMwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 07:52:53 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E9F2C4E3A921C48424B1;
        Wed, 19 Feb 2020 20:52:12 +0800 (CST)
Received: from [127.0.0.1] (10.177.246.209) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 20:52:03 +0800
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
To:     Mike Kravetz <mike.kravetz@oracle.com>
CC:     Matthew Wilcox <willy@infradead.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <weidong.huang@huawei.com>,
        <weifuqiang@huawei.com>, <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
 <20200218205239.GE24185@bombadil.infradead.org>
 <593d82a3-1d1e-d8f2-6b90-137f10441522@huawei.com>
 <8292299c-4c5a-a8cb-22e2-d5c9051f122a@oracle.com>
From:   "Longpeng (Mike)" <longpeng2@huawei.com>
Message-ID: <805f6f4b-af57-b08c-49c6-6c2f02ee2f96@huawei.com>
Date:   Wed, 19 Feb 2020 20:52:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8292299c-4c5a-a8cb-22e2-d5c9051f122a@oracle.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.246.209]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

在 2020/2/19 11:49, Mike Kravetz 写道:
> On 2/18/20 6:09 PM, Longpeng (Mike) wrote:
>> 在 2020/2/19 4:52, Matthew Wilcox 写道:
>>> On Tue, Feb 18, 2020 at 08:10:25PM +0800, Longpeng(Mike) wrote:
>>>>  {
>>>> -	pgd_t *pgd;
>>>> -	p4d_t *p4d;
>>>> -	pud_t *pud;
>>>> -	pmd_t *pmd;
>>>> +	pgd_t *pgdp;
>>>> +	p4d_t *p4dp;
>>>> +	pud_t *pudp, pud;
>>>> +	pmd_t *pmdp, pmd;
>>>
>>> Renaming the variables as part of a fix is a really bad idea.  It obscures
>>> the actual fix and makes everybody's life harder.  Plus, it's not even
>>> renaming to follow the normal convention -- there are only two places
>>> (migrate.c and gup.c) which follow this pattern in mm/ while there are
>>> 33 that do not.
>>>
>> Good suggestion, I've never noticed this, thanks.
>> By the way, could you give an example if we use this way to fix the bug?
> 
> Matthew and others may have better suggestions for naming.  However, I would
> keep the existing names and add:
> 
> pud_t pud_entry;
> pmd_t pmd_entry;
> 
> Then the *_entry variables are the target of the READ_ONCE()
> 
> pud_entry = READ_ONCE(*pud);
> if (sz != PUD_SIZE && pud_none(pud_entry))
> ...
> ...
> pmd_entry = READ_ONCE(*pmd);
> if (sz != PMD_SIZE && pmd_none(pmd_entry))
> ...
> ...
> 
Uh, looks much better.

BTW, I missed one of your email in my mail client, but I find it in lkml.org.
'''
I too would like some more information on the panic.
If your analysis is correct, then I would expect the 'ptep' returned by
huge_pte_offset() to not point to a pte but rather some random address.
This is because the 'pmd' calculated by pmd_offset(pud, addr) is not
really the address of a pmd.  So, perhaps there is an addressing exception
at huge_ptep_get() near the beginning of hugetlb_fault()?

	ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
	if (ptep) {
		entry = huge_ptep_get(ptep);
		...
'''
Yep, your analysis above is the same as mine, we got a 'dummy pmd' and then
cause access a bad address.

What's your opinion about the solution to fix this problem, not only
huge_pte_offset, some other places also have the same problem(e.g.
lookup_address_in_pgd) ?

> BTW, thank you for finding this issue!
> 


-- 
Regards,
Longpeng(Mike)

