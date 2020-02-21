Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB452166B8C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 01:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgBUAXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 19:23:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbgBUAXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 19:23:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01L0IuBc097560;
        Fri, 21 Feb 2020 00:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=j3orcV8N7f6tsO1hzt4d6bYa8i40eAtvmiZrDeUsowc=;
 b=cVgkuu1q0ENV4pHWiXR021YoDnJt/upxXvl+V7TptYMU6reyQ9uuYXRwAz5ius5oIyTO
 YmwNJWi92N/4cDdoxdkAni9VqOlV+FR9E4F7GFK/r7pXVJ3E0XEpuXnjvvEmOqXngjow
 CtPXx7EndrPPiiNOevB6oh5vwEoM5H6upA9kEQ3giDn9xX1UKjeigv4UkdsV8UvBMTHk
 Pty3uFwFC1DoD8CcbRLZf8hAE/WGbNVKx6LGYYj+TOz6ppUHBu/5y+TzbjpsBWBpOe4J
 5X4q0LuRs/zDbbtQIJQ3skmEPVXUs+DF0+Qy1pOZKvAdgDr/l71Kaf5Szqh5LbKj/bis dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2y8udddayy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 00:22:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01L0HssC082442;
        Fri, 21 Feb 2020 00:22:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8udgkksv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 00:22:28 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01L0MP4K016579;
        Fri, 21 Feb 2020 00:22:26 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 16:22:25 -0800
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
To:     "Longpeng (Mike)" <longpeng2@huawei.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
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
 <098a5dd6-e1da-f161-97d7-cfe735d14fd8@oracle.com>
 <502b5e52-060b-6864-d1b7-eab2dc951aed@huawei.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <a82956f7-26e4-5c1c-8d5d-4b2510f6b17d@oracle.com>
Date:   Thu, 20 Feb 2020 16:22:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <502b5e52-060b-6864-d1b7-eab2dc951aed@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/19/20 6:30 PM, Longpeng (Mike) wrote:
> 在 2020/2/20 3:33, Mike Kravetz 写道:
>> + Kirill
>> On 2/18/20 5:58 PM, Sean Christopherson wrote:
>>> On Wed, Feb 19, 2020 at 09:39:59AM +0800, Longpeng (Mike) wrote:
<snip>
>>> The race and the fix make sense.  I assumed dereferencing garbage from the
>>> huge page was the issue, but I wasn't 100% that was the case, which is why
>>> I asked about alternative fixes.
>>>
>>>> We change the code from
>>>> 	if (pud_huge(*pud) || !pud_present(*pud))
>>>> to
>>>> 	if (pud_huge(*pud)
>>>> 		return (pte_t *)pud;
>>>> 	busy loop for 500ms
>>>> 	if (!pud_present(*pud))
>>>> 		return (pte_t *)pud;
>>>> and the panic will be hit quickly.
>>>>
>>>> ARM64 has already use READ/WRITE_ONCE to access the pagetable, look at this
>>>> commit 20a004e7 (arm64: mm: Use READ_ONCE/WRITE_ONCE when accessing page tables).
>>>>
>>>> The root cause is: 'if (pud_huge(*pud) || !pud_present(*pud))' read entry from
>>>> pud twice and the *pud maybe change in a race, so if we only read the pud once.
>>>> I use READ_ONCE here is just for safe, to prevents the complier mischief if
>>>> possible.
>>>
>>> FWIW, I'd be in favor of going the READ/WRITE_ONCE() route for x86, e.g.
>>> convert everything as a follow-up patch (or patches).  I'm fairly confident
>>> that KVM's usage of lookup_address_in_mm() is safe, but I wouldn't exactly
>>> bet my life on it.  I'd much rather the failing scenario be that KVM uses
>>> a sub-optimal page size as opposed to exploding on a bad pointer.
>>
>> Longpeng(Mike) asked in another e-mail specifically about making similar
>> changes to lookup_address_in_mm().  Replying here as there is more context.
>>
>> I 'think' lookup_address_in_mm is safe from this issue.  Why?  IIUC, the
>> problem with the huge_pte_offset routine is that the pud changes from
>> pud_none() to pud_huge() in the middle of
>> 'if (pud_huge(*pud) || !pud_present(*pud))'.  In the case of
>> lookup_address_in_mm, we know pud was not pud_none() as it was previously
>> checked.  I am not aware of any other state transitions which could cause
>> us trouble.  However, I am no expert in this area.

Bad copy/paste by me.  Longpeng(Mike) was asking about lookup_address_in_pgd.

> So... I need just fix huge_pte_offset in mm/hugetlb.c, right?

Let's start with just a fix for huge_pte_offset() as you can easily reproduce
that issue by adding a delay.

> Is it possible the pud changes from pud_huge() to pud_none() while another CPU
> is walking the pagetable ?

I believe it is possible.  If we hole punch a hugetlbfs file, we will clear
the corresponding pud's.  Hence, we can go from pud_huge() to pud_none().
Unless I am missing something, that does imply we could have issues in places
such as lookup_address_in_pgd:

	pud = pud_offset(p4d, address);
	if (pud_none(*pud))
		return NULL;

	*level = PG_LEVEL_1G;
	if (pud_large(*pud) || !pud_present(*pud))
		return (pte_t *)pud;

I hope I am wrong, but it seems like pud_none(*pud) could become true after
the initial check, and before the (pud_large) check.  If so, there could be
a problem (addressing exception) when the code continues and looks up the pmd.

	pmd = pmd_offset(pud, address);
	if (pmd_none(*pmd))
		return NULL;

It has been mentioned before that there are many page table walks like this.
What am I missing that prevents races like this?  Or, have we just been lucky?
-- 
Mike Kravetz
