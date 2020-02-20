Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0DDB16551D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 03:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgBTCcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 21:32:33 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:49320 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727211AbgBTCcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 21:32:32 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 371B5B13612E52EF5B93;
        Thu, 20 Feb 2020 10:32:30 +0800 (CST)
Received: from [127.0.0.1] (10.177.246.209) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 10:32:22 +0800
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     <mike.kravetz@oracle.com>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <weidong.huang@huawei.com>,
        <weifuqiang@huawei.com>, <kvm@vger.kernel.org>
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
 <20200218203717.GE28156@linux.intel.com>
 <a041fdb4-bfd0-ac4b-2809-6fddfc4f8d83@huawei.com>
 <20200219015836.GM28156@linux.intel.com>
 <6ccbde03-953c-c006-a07e-8146b84389d9@huawei.com>
 <20200219162231.GE15888@linux.intel.com>
From:   "Longpeng (Mike)" <longpeng2@huawei.com>
Message-ID: <6d4d2b59-5b40-49da-a6f7-e8ea34ed30e6@huawei.com>
Date:   Thu, 20 Feb 2020 10:32:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200219162231.GE15888@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.246.209]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

在 2020/2/20 0:22, Sean Christopherson 写道:
> On Wed, Feb 19, 2020 at 08:21:26PM +0800, Longpeng (Mike) wrote:
>> 在 2020/2/19 9:58, Sean Christopherson 写道:
>>> FWIW, I'd be in favor of going the READ/WRITE_ONCE() route for x86, e.g.
>>> convert everything as a follow-up patch (or patches).  I'm fairly confident
>>> that KVM's usage of lookup_address_in_mm() is safe, but I wouldn't exactly
>>> bet my life on it.  I'd much rather the failing scenario be that KVM uses
>>> a sub-optimal page size as opposed to exploding on a bad pointer.
>>>
>> Um...our testcase starts 50 VMs with 2U4G(use 1G hugepage) and then do
>> live-upgrade(private feature that just modify the qemu and libvirt) and
>> live-migrate in turns for each one. However our live upgraded new QEMU won't do
>> touch_all_pages.
>> Suppose we start a VM without touch_all_pages in QEMU, the VM's guest memory is
>> not mapped in the CR3 pagetable at the moment. When the 2 vcpus running, they
>> could access some pages belong to the same 1G-hugepage, both of them will vmexit
>> due to ept_violation and then call gup-->follow_hugetlb_page-->hugetlb_fault, so
>> the race may encounter, right?
> 
> Yep.  The code I'm referring to is similar but different code that just
> happened to go into KVM for kernel 5.6.  It has no effect on the gup() flow
> that leads to this bug.  I mentioned it above as an example of code outside
> of hugetlb_fault() that would also benefit from moving to READ/WRITE_ONCE().
> 
> 
I understand better now, thanks for your patience. :)

-- 
Regards,
Longpeng(Mike)

