Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B4016209F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 06:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgBRF7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 00:59:08 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15997 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgBRF7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 00:59:08 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4b7d1d0000>; Mon, 17 Feb 2020 21:58:53 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 17 Feb 2020 21:59:06 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 17 Feb 2020 21:59:06 -0800
Received: from [10.40.101.150] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Feb
 2020 05:58:57 +0000
Subject: Re: [PATCH v12 Kernel 4/7] vfio iommu: Implementation of ioctl to for
 dirty pages tracking.
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
 <1581104554-10704-5-git-send-email-kwankhede@nvidia.com>
 <20200210102518.490a0d87@x1.home>
 <7e7356c8-29ed-31fa-5c0b-2545ae69f321@nvidia.com>
 <20200212161320.02d8dfac@w520.home>
 <0244aca6-80f7-1c1d-812e-d53a48b5479d@nvidia.com>
 <20200213162011.40b760a8@w520.home>
 <ea31fb62-4cd3-babb-634d-f69407586c93@nvidia.com>
 <20200217135518.4d48ebd6@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <57199367-e562-800a-ef73-f28bc5ddb2fe@nvidia.com>
Date:   Tue, 18 Feb 2020 11:28:53 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200217135518.4d48ebd6@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582005533; bh=UVFuTcvlyh3iWYM+gJt93GCmfNP7VaK7DTQFFJhvpSk=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=SXytaGDwhevD6jXrh2a64+moNmNGuOsWvDYZ4i02wQXHW4VGGAYAdtBQ07O/y5wCt
         caYOqD7Dk7TC7JjSS59wBggf3aAz9ANVALhBmcn6EMGkNP/FwnlCFi/+1tK4bXbJuc
         +rLy27AcexbPB/Js/6InITnDv4SlhG9MHw9ddp+S8giLHtp3A25TVOwvZQtDIjFd3g
         DqRDhqeRAAOuCqg9OJ5MSZBC6ErTApYqwgZWCNJs5JlYQi59pd5EysJiZ574WLa0Rf
         BT4oXP+e8iLa2b5yZYL6HJehK/FVYzt0dWL1f/3e8Dsdsaxk8xpq1F+2get2uh/muc
         1RsxHD2eeiPew==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

<snip>

>>>>>    As I understand the above algorithm, we find a vfio_dma
>>>>> overlapping the request and populate the bitmap for that range.  Then
>>>>> we go back and put_user() for each byte that we touched.  We could
>>>>> instead simply work on a one byte buffer as we enumerate the requested
>>>>> range and do a put_user() ever time we reach the end of it and have bits
>>>>> set. That would greatly simplify the above example.  But I would expect
>>>>> that we're a) more likely to get asked for ranges covering a single
>>>>> vfio_dma
>>>>
>>>> QEMU ask for single vfio_dma during each iteration.
>>>>
>>>> If we restrict this ABI to cover single vfio_dma only, then it
>>>> simplifies the logic here. That was my original suggestion. Should we
>>>> think about that again?
>>>
>>> But we currently allow unmaps that overlap multiple vfio_dmas as long
>>> as no vfio_dma is bisected, so I think that implies that an unmap while
>>> asking for the dirty bitmap has even further restricted semantics.  I'm
>>> also reluctant to design an ABI around what happens to be the current
>>> QEMU implementation.
>>>
>>> If we take your example above, ranges {0x0000,0xa000} and
>>> {0xa000,0x10000} ({start,end}), I think you're working with the
>>> following two bitmaps in this implementation:
>>>
>>> 00000011 11111111b
>>> 00111111b
>>>
>>> And we need to combine those into:
>>>
>>> 11111111 11111111b
>>>
>>> Right?
>>>
>>> But it seems like that would be easier if the second bitmap was instead:
>>>
>>> 11111100b
>>>
>>> Then we wouldn't need to worry about the entire bitmap being shifted by
>>> the bit offset within the byte, which limits our fixes to the boundary
>>> byte and allows us to use copy_to_user() directly for the bulk of the
>>> copy.  So how do we get there?
>>>
>>> I think we start with allocating the vfio_dma bitmap to account for
>>> this initial offset, so we calculate bitmap_base_iova as:
>>>     (iova & ~((PAGE_SIZE << 3) - 1))
>>> We then use bitmap_base_iova in calculating which bits to set.
>>>
>>> The user needs to follow the same rules, and maybe this adds some value
>>> to the user providing the bitmap size rather than the kernel
>>> calculating it.  For example, if the user wanted the dirty bitmap for
>>> the range {0xa000,0x10000} above, they'd provide at least a 1 byte
>>> bitmap, but we'd return bit #2 set to indicate 0xa000 is dirty.
>>>
>>> Effectively the user can ask for any iova range, but the buffer will be
>>> filled relative to the zeroth bit of the bitmap following the above
>>> bitmap_base_iova formula (and replacing PAGE_SIZE with the user
>>> requested pgsize).  I'm tempted to make this explicit in the user
>>> interface (ie. only allow bitmaps starting on aligned pages), but a
>>> user is able to map and unmap single pages and we need to support
>>> returning a dirty bitmap with an unmap, so I don't think we can do that.
>>>    
>>
>> Sigh, finding adjacent vfio_dmas within the same byte seems simpler than
>> this.
> 
> How does KVM do this?  My intent was that if all of our bitmaps share
> the same alignment then we can merge the intersection and continue to
> use copy_to_user() on either side.  However, if QEMU doesn't do the
> same, it doesn't really help us.  Is QEMU stuck with an implementation
> of only retrieving dirty bits per MemoryRegionSection exactly because
> of this issue and therefore we can rely on it in our implementation as
> well?  Thanks,
> 

QEMU sync dirty_bitmap per MemoryRegionSection. Within 
MemoryRegionSection there could be multiple KVMSlots. QEMU queries 
dirty_bitmap per KVMSlot and mark dirty for each KVMSlot.
On kernel side, KVM_GET_DIRTY_LOG ioctl calls 
kvm_get_dirty_log_protect(), where it uses copy_to_user() to copy bitmap 
of that memSlot.
vfio_dma is per MemoryRegionSection. We can reply on MemoryRegionSection 
in our implementation. But to get bitmap during unmap, we have to take 
care of concatenating bitmaps.

In QEMU, in function kvm_physical_sync_dirty_bitmap() there is a comment 
where bitmap size is calculated and bitmap is defined as 'void __user 
*dirty_bitmap' which is also the concern you raised and could be handled 
similarly as below.

         /* XXX bad kernel interface alert
          * For dirty bitmap, kernel allocates array of size aligned to
          * bits-per-long.  But for case when the kernel is 64bits and
          * the userspace is 32bits, userspace can't align to the same
          * bits-per-long, since sizeof(long) is different between kernel
          * and user space.  This way, userspace will provide buffer which
          * may be 4 bytes less than the kernel will use, resulting in
          * userspace memory corruption (which is not detectable by valgrind
          * too, in most cases).
          * So for now, let's align to 64 instead of HOST_LONG_BITS here, in
          * a hope that sizeof(long) won't become >8 any time soon.
          */
         if (!mem->dirty_bmap) {
             hwaddr bitmap_size = ALIGN(((mem->memory_size) >> 
TARGET_PAGE_BITS),
                                         /*HOST_LONG_BITS*/ 64) / 8;
             /* Allocate on the first log_sync, once and for all */
             mem->dirty_bmap = g_malloc0(bitmap_size);
         }

Thanks,
Kirti

