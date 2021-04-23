Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64672368919
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 00:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhDVWmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 18:42:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232844AbhDVWml (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 18:42:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619131326;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MXWelGrKJsOVHMNa4BvG+vmhagOlpndp+VmZanYIb8Y=;
        b=dRLtZw70s1VYvOJvQ79LztlFpOYZ/wHdLpvaVkdH1f/ZufUPRG7GEmIh9ePPM5gP+5qphI
        oEyash4vANzLDUzm9k6SvpBt+rtfNaKCjYX+Ao/fTwm9AlZnL8eqMnp/0HNr5Rs/Lk1xOc
        DJtSUq8U0GnQMR+CU4WnoDBMiJwt4oI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-Bj5_orOsNDCDYpVONoT8NA-1; Thu, 22 Apr 2021 18:42:02 -0400
X-MC-Unique: Bj5_orOsNDCDYpVONoT8NA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F410B801814;
        Thu, 22 Apr 2021 22:42:00 +0000 (UTC)
Received: from [10.64.54.94] (vpn2-54-94.bne.redhat.com [10.64.54.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B2F85C3E0;
        Thu, 22 Apr 2021 22:41:57 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To:     Marc Zyngier <maz@kernel.org>
Cc:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, wanghaibin.wang@huawei.com
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-3-zhukeqian1@huawei.com>
 <960e097d-818b-00bc-b2ee-0da17857f862@redhat.com>
 <105a403a-e48b-15bc-44ff-0ff34f7d2194@huawei.com>
 <46606f3e-ef41-6520-6647-88c0f76a83e0@redhat.com>
 <87tunyq0av.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b39cb015-39bb-cb03-e095-414e323fd6aa@redhat.com>
Date:   Fri, 23 Apr 2021 10:42:08 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87tunyq0av.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 4/22/21 4:51 PM, Marc Zyngier wrote:
> On Thu, 22 Apr 2021 03:25:23 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>> On 4/21/21 4:36 PM, Keqian Zhu wrote:
>>> On 2021/4/21 15:52, Gavin Shan wrote:
>>>> On 4/16/21 12:03 AM, Keqian Zhu wrote:
>>>>> The MMIO region of a device maybe huge (GB level), try to use
>>>>> block mapping in stage2 to speedup both map and unmap.
>>>>>
>>>>> Compared to normal memory mapping, we should consider two more
>>>>> points when try block mapping for MMIO region:
>>>>>
>>>>> 1. For normal memory mapping, the PA(host physical address) and
>>>>> HVA have same alignment within PUD_SIZE or PMD_SIZE when we use
>>>>> the HVA to request hugepage, so we don't need to consider PA
>>>>> alignment when verifing block mapping. But for device memory
>>>>> mapping, the PA and HVA may have different alignment.
>>>>>
>>>>> 2. For normal memory mapping, we are sure hugepage size properly
>>>>> fit into vma, so we don't check whether the mapping size exceeds
>>>>> the boundary of vma. But for device memory mapping, we should pay
>>>>> attention to this.
>>>>>
>>>>> This adds get_vma_page_shift() to get page shift for both normal
>>>>> memory and device MMIO region, and check these two points when
>>>>> selecting block mapping size for MMIO region.
>>>>>
>>>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>>>> ---
>>>>>     arch/arm64/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++--------
>>>>>     1 file changed, 51 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>>> index c59af5ca01b0..5a1cc7751e6d 100644
>>>>> --- a/arch/arm64/kvm/mmu.c
>>>>> +++ b/arch/arm64/kvm/mmu.c
>>>>> @@ -738,6 +738,35 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>>>>>         return PAGE_SIZE;
>>>>>     }
>>>>>     +static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
>>>>> +{
>>>>> +    unsigned long pa;
>>>>> +
>>>>> +    if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
>>>>> +        return huge_page_shift(hstate_vma(vma));
>>>>> +
>>>>> +    if (!(vma->vm_flags & VM_PFNMAP))
>>>>> +        return PAGE_SHIFT;
>>>>> +
>>>>> +    VM_BUG_ON(is_vm_hugetlb_page(vma));
>>>>> +
>>>>
>>>> I don't understand how VM_PFNMAP is set for hugetlbfs related vma.
>>>> I think they are exclusive, meaning the flag is never set for
>>>> hugetlbfs vma. If it's true, VM_PFNMAP needn't be checked on hugetlbfs
>>>> vma and the VM_BUG_ON() becomes unnecessary.
>>> Yes, but we're not sure all drivers follow this rule. Add a BUG_ON() is
>>> a way to catch issue.
>>>
>>
>> I think I didn't make things clear. What I meant is VM_PFNMAP can't
>> be set for hugetlbfs VMAs. So the checks here can be simplified as
>> below if you agree:
>>
>>      if (is_vm_hugetlb_page(vma))
>>          return huge_page_shift(hstate_vma(vma));
>>
>>      if (!(vma->vm_flags & VM_PFNMAP))
>>          return PAGE_SHIFT;
>>
>>      VM_BUG_ON(is_vm_hugetlb_page(vma));       /* Can be dropped */
> 
> No. If this case happens, I want to see it. I have explicitly asked
> for it, and this check stays.
> 

Thanks for the explanation. To keep VM_BUG_ON() sounds good to me too :)

Thanks,
Gavin

