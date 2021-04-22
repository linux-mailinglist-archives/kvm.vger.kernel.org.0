Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D81F367602
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 02:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343820AbhDVACo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 20:02:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234886AbhDVACn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 20:02:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619049729;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AWyEtL+6GA4nLFwMmyJC5Ypm9RaDP0KzLZdhIttrWhA=;
        b=LWi9i9xJwaJB4xtMCaXbgpVrkEH3OFEgJuztTmqSM86vNPxxHW0hWTsg3cH6RPtUMHruCD
        6qJGffrqZU00Bvvy5stQGG1cxgsyjBoI6z5plzXwxmAfF4Q+ST6edZXme5J1rJZL93v4/f
        3zjTTjfHH1pymWIF0dTIbdDU3F0huRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-rpSKvb4KORWQllaxvzqZGA-1; Wed, 21 Apr 2021 20:01:56 -0400
X-MC-Unique: rpSKvb4KORWQllaxvzqZGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E885B1006C82;
        Thu, 22 Apr 2021 00:01:54 +0000 (UTC)
Received: from [10.64.54.94] (vpn2-54-94.bne.redhat.com [10.64.54.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F8596064B;
        Thu, 22 Apr 2021 00:01:51 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Correctly handle the mmio faulting
To:     Marc Zyngier <maz@kernel.org>, Keqian Zhu <zhukeqian1@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, cjia@nvidia.com,
        linux-arm-kernel@lists.infradead.org,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
References: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
 <8b20dfc0-3b5e-c658-c47d-ebc50d20568d@huawei.com>
 <2e23aaa7-0c8d-13ba-2eae-9e6ab2adc587@redhat.com>
 <ed8a8b90-8b96-4967-01f5-cd0f536c38d2@huawei.com>
 <871rb3rgpl.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b97415a2-7970-a741-9690-3e4514b4aa7d@redhat.com>
Date:   Thu, 22 Apr 2021 12:02:00 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <871rb3rgpl.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 4/21/21 9:59 PM, Marc Zyngier wrote:
> On Wed, 21 Apr 2021 07:17:44 +0100,
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>> On 2021/4/21 14:20, Gavin Shan wrote:
>>> On 4/21/21 12:59 PM, Keqian Zhu wrote:
>>>> On 2020/10/22 0:16, Santosh Shukla wrote:
>>>>> The Commit:6d674e28 introduces a notion to detect and handle the
>>>>> device mapping. The commit checks for the VM_PFNMAP flag is set
>>>>> in vma->flags and if set then marks force_pte to true such that
>>>>> if force_pte is true then ignore the THP function check
>>>>> (/transparent_hugepage_adjust()).
>>>>>
>>>>> There could be an issue with the VM_PFNMAP flag setting and checking.
>>>>> For example consider a case where the mdev vendor driver register's
>>>>> the vma_fault handler named vma_mmio_fault(), which maps the
>>>>> host MMIO region in-turn calls remap_pfn_range() and maps
>>>>> the MMIO's vma space. Where, remap_pfn_range implicitly sets
>>>>> the VM_PFNMAP flag into vma->flags.
>>>> Could you give the name of the mdev vendor driver that triggers this issue?
>>>> I failed to find one according to your description. Thanks.
>>>>
>>>
>>> I think it would be fixed in driver side to set VM_PFNMAP in
>>> its mmap() callback (call_mmap()), like vfio PCI driver does.
>>> It means it won't be delayed until page fault is issued and
>>> remap_pfn_range() is called. It's determined from the beginning
>>> that the vma associated the mdev vendor driver is serving as
>>> PFN remapping purpose. So the vma should be populated completely,
>>> including the VM_PFNMAP flag before it becomes visible to user
>>> space.
> 
> Why should that be a requirement? Lazy populating of the VMA should be
> perfectly acceptable if the fault can only happen on the CPU side.
> 

It isn't a requirement and the drivers needn't follow strictly. I checked
several drivers before looking into the patch and found almost all the
drivers have VM_PFNMAP set at mmap() time. In drivers/vfio/vfio-pci.c,
there is a comment as below, but it doesn't reveal too much about why
we can't set VM_PFNMAP at fault time.

static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
{
       :
         /*
          * See remap_pfn_range(), called from vfio_pci_fault() but we can't
          * change vm_flags within the fault handler.  Set them now.
          */
         vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
         vma->vm_ops = &vfio_pci_mmap_ops;

         return 0;
}

To set these flags in advance does have advantages. For example, VM_DONTEXPAND
prevents the vma to be merged with another one. VM_DONTDUMP make this vma
isn't eligible for coredump. Otherwise, the address space, which is associated
with the vma is accessed and unnecessary page faults are triggered on coredump.
VM_IO and VM_PFNMAP avoids to walk the page frames associated with the vma since
we don't have valid PFN in the mapping.

>>>
>>> The example can be found from vfio driver in drivers/vfio/pci/vfio_pci.c:
>>>      vfio_pci_mmap:       VM_PFNMAP is set for the vma
>>>      vfio_pci_mmap_fault: remap_pfn_range() is called
>> Right. I have discussed the above with Marc. I want to find the driver
>> to fix it. However, AFAICS, there is no driver matches the description...
> 
> I have the feeling this is an out-of-tree driver (and Santosh email
> address is bouncing, so I guess we won't have much information from
> him).
> 
> However, the simple fact that any odd driver can provide a fault
> handler and populate it the VMA on demand makes me think that we need
> to support this case.
> 

Yeah, Santosh's email isn't reachable. I think the VM_PFNMAP need to be
rechecked after gup if we're going to support this case.

Thanks,
Gavin

