Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEFB1909D5
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 10:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCXJpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 05:45:22 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9169 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgCXJpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 05:45:22 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e79d6830000>; Tue, 24 Mar 2020 02:44:35 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 24 Mar 2020 02:45:20 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 24 Mar 2020 02:45:20 -0700
Received: from [10.40.103.10] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Mar
 2020 09:45:12 +0000
Subject: Re: [PATCH v15 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
To:     Yan Zhao <yan.y.zhao@intel.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1584649004-8285-1-git-send-email-kwankhede@nvidia.com>
 <1584649004-8285-5-git-send-email-kwankhede@nvidia.com>
 <20200319165704.1f4eb36a@w520.home>
 <bc48ae5c-67f9-d95e-5d60-6c42359bb790@nvidia.com>
 <20200320120137.6acd89ee@x1.home>
 <cf0ee134-c1c7-f60c-afc2-8948268d8880@nvidia.com>
 <20200320125910.028d7af5@w520.home>
 <7062f72a-bf06-a8cd-89f0-9e729699a454@nvidia.com>
 <20200323124448.2d3bc315@w520.home> <20200323185114.GF3017@work-vm>
 <20200324030118.GD5456@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <d271acf4-7fd6-c93d-aa3d-399a7ace20cf@nvidia.com>
Date:   Tue, 24 Mar 2020 15:15:07 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200324030118.GD5456@joy-OptiPlex-7040>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585043075; bh=pJMe/GAA4sfde9GLzoXG8Wcbd3DHl6ib3TB6JeCREiw=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=iuV0dASS0fgg+Uh4jEnnojKFwRNSTGbAwz/7pp4Af89OA2FvLPr7QtA4zoLb0IdaI
         EvjxH57GaU3ESekUpT7shyoAJThSDeqUU2K20MFmNPkFu4bA/IOmWci/bYonDss5Ep
         0QRi/Jlst+Ix+3cDGEIZcAmVxKiB4N5D2Yt2nz+tl/pZwsjzkGfQpDigqjhGmr1b3G
         sEWyAX4AFvbxiePiovusC459lj6N0bkBNYgGi1Bsg37pKWYZovoG5kzKqShlpaIqyf
         YSFfWvaxnZ8keyTpYBMDIUaM82RIzlwxbJ1vJCQC1k35fFGhdSOZmtOuVbHjGwaoPN
         yxZhpMKU11GDw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/24/2020 8:31 AM, Yan Zhao wrote:
> On Tue, Mar 24, 2020 at 02:51:14AM +0800, Dr. David Alan Gilbert wrote:
>> * Alex Williamson (alex.williamson@redhat.com) wrote:
>>> On Mon, 23 Mar 2020 23:24:37 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>
>>>> On 3/21/2020 12:29 AM, Alex Williamson wrote:
>>>>> On Sat, 21 Mar 2020 00:12:04 +0530
>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>    
>>>>>> On 3/20/2020 11:31 PM, Alex Williamson wrote:
>>>>>>> On Fri, 20 Mar 2020 23:19:14 +0530
>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>>>       
>>>>>>>> On 3/20/2020 4:27 AM, Alex Williamson wrote:
>>>>>>>>> On Fri, 20 Mar 2020 01:46:41 +0530
>>>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>>>>>          
>>>>>>
>>>>>> <snip>
>>>>>>   
>>>>>>>>>> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
>>>>>>>>>> +				  size_t size, uint64_t pgsize,
>>>>>>>>>> +				  u64 __user *bitmap)
>>>>>>>>>> +{
>>>>>>>>>> +	struct vfio_dma *dma;
>>>>>>>>>> +	unsigned long pgshift = __ffs(pgsize);
>>>>>>>>>> +	unsigned int npages, bitmap_size;
>>>>>>>>>> +
>>>>>>>>>> +	dma = vfio_find_dma(iommu, iova, 1);
>>>>>>>>>> +
>>>>>>>>>> +	if (!dma)
>>>>>>>>>> +		return -EINVAL;
>>>>>>>>>> +
>>>>>>>>>> +	if (dma->iova != iova || dma->size != size)
>>>>>>>>>> +		return -EINVAL;
>>>>>>>>>> +
>>>>>>>>>> +	npages = dma->size >> pgshift;
>>>>>>>>>> +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
>>>>>>>>>> +
>>>>>>>>>> +	/* mark all pages dirty if all pages are pinned and mapped. */
>>>>>>>>>> +	if (dma->iommu_mapped)
>>>>>>>>>> +		bitmap_set(dma->bitmap, 0, npages);
>>>>>>>>>> +
>>>>>>>>>> +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
>>>>>>>>>> +		return -EFAULT;
>>>>>>>>>
>>>>>>>>> We still need to reset the bitmap here, clearing and re-adding the
>>>>>>>>> pages that are still pinned.
>>>>>>>>>
>>>>>>>>> https://lore.kernel.org/kvm/20200319070635.2ff5db56@x1.home/
>>>>>>>>>          
>>>>>>>>
>>>>>>>> I thought you agreed on my reply to it
>>>>>>>> https://lore.kernel.org/kvm/31621b70-02a9-2ea5-045f-f72b671fe703@nvidia.com/
>>>>>>>>      
>>>>>>>>     > Why re-populate when there will be no change since
>>>>>>>>     > vfio_iova_dirty_bitmap() is called holding iommu->lock? If there is any
>>>>>>>>     > pin request while vfio_iova_dirty_bitmap() is still working, it will
>>>>>>>>     > wait till iommu->lock is released. Bitmap will be populated when page is
>>>>>>>>     > pinned.
>>>>>>>
>>>>>>> As coded, dirty bits are only ever set in the bitmap, never cleared.
>>>>>>> If a page is unpinned between iterations of the user recording the
>>>>>>> dirty bitmap, it should be marked dirty in the iteration immediately
>>>>>>> after the unpinning and not marked dirty in the following iteration.
>>>>>>> That doesn't happen here.  We're reporting cumulative dirty pages since
>>>>>>> logging was enabled, we need to be reporting dirty pages since the user
>>>>>>> last retrieved the dirty bitmap.  The bitmap should be cleared and
>>>>>>> currently pinned pages re-added after copying to the user.  Thanks,
>>>>>>>       
>>>>>>
>>>>>> Does that mean, we have to track every iteration? do we really need that
>>>>>> tracking?
>>>>>>
>>>>>> Generally the flow is:
>>>>>> - vendor driver pin x pages
>>>>>> - Enter pre-copy-phase where vCPUs are running - user starts dirty pages
>>>>>> tracking, then user asks dirty bitmap, x pages reported dirty by
>>>>>> VFIO_IOMMU_DIRTY_PAGES ioctl with _GET flag
>>>>>> - In pre-copy phase, vendor driver pins y more pages, now bitmap
>>>>>> consists of x+y bits set
>>>>>> - In pre-copy phase, vendor driver unpins z pages, but bitmap is not
>>>>>> updated, so again bitmap consists of x+y bits set.
>>>>>> - Enter in stop-and-copy phase, vCPUs are stopped, mdev devices are stopped
>>>>>> - user asks dirty bitmap - Since here vCPU and mdev devices are stopped,
>>>>>> pages should not get dirty by guest driver or the physical device.
>>>>>> Hence, x+y dirty pages would be reported.
>>>>>>
>>>>>> I don't think we need to track every iteration of bitmap reporting.
>>>>>
>>>>> Yes, once a bitmap is read, it's reset.  In your example, after
>>>>> unpinning z pages the user should still see a bitmap with x+y pages,
>>>>> but once they've read that bitmap, the next bitmap should be x+y-z.
>>>>> Userspace can make decisions about when to switch from pre-copy to
>>>>> stop-and-copy based on convergence, ie. the slope of the line recording
>>>>> dirty pages per iteration.  The implementation here never allows an
>>>>> inflection point, dirty pages reported through vfio would always either
>>>>> be flat or climbing.  There might also be a case that an iommu backed
>>>>> device could start pinning pages during the course of a migration, how
>>>>> would the bitmap ever revert from fully populated to only tracking the
>>>>> pinned pages?  Thanks,
>>>>>    
>>>>
>>>> At KVM forum we discussed this - if guest driver pins say 1024 pages
>>>> before migration starts, during pre-copy phase device can dirty 0 pages
>>>> in best case and 1024 pages in worst case. In that case, user will
>>>> transfer content of 1024 pages during pre-copy phase and in
>>>> stop-and-copy phase also, that will be pages will be copied twice. So we
>>>> decided to only get dirty pages bitmap at stop-and-copy phase. If user
>>>> is going to get dirty pages in stop-and-copy phase only, then that will
>>>> be single iteration.
>>>> There aren't any devices yet that can track sys memory dirty pages. So
>>>> we can go ahead with this patch and support for dirty pages tracking
>>>> during pre-copy phase can be added later when there will be consumers of
>>>> that functionality.
>>>
>>> So if I understand this right, you're expecting the dirty bitmap to
>>> accumulate dirty bits, in perpetuity, so that the user can only
>>> retrieve them once at the end of migration?  But if that's the case,
>>> the user could simply choose to not retrieve the bitmap until the end
>>> of migration, the result would be the same.  What we have here is that
>>> dirty bits are never cleared, regardless of whether the user has seen
>>> them, which is wrong.  Sorry, we had a lot of discussions at KVM forum,
>>> I don't recall this specific one 5 months later and maybe we weren't
>>> considering all aspects.  I see the behavior we have here as incorrect,
>>> but it also seems relatively trivial to make correct.  I hope the QEMU
>>> code isn't making us go through all this trouble to report a dirty
>>> bitmap that gets thrown away because it expects the final one to be
>>> cumulative since the beginning of dirty logging.  Thanks,
>>
>> I remember the discussion that we couldn't track the system memory
>> dirtying with current hardware; so the question then is just to track

> hi Dave
> there are already devices that are able to track the system memory,
> through two ways:
> (1) software method. like VFs for "Intel(R) Ethernet Controller XL710 Family
> support".
> (2) hardware method. through hardware internal buffer (as one Intel
> internal hardware not yet to public, but very soon) or through VTD-3.0
> IOMMU.
> 
> we have already had code verified using the two ways to track system memory
> in fine-grained level.
> 
> 
>> what has been pinned and then ideally put that memory off until the end.
>> (Which is interesting because I don't think we currently have  a way
>> to delay RAM pages till the end in qemu).
> 
> I think the problem here is that we mixed pinned pages with dirty pages.
> yes, pinned pages for mdev devices are continuously likely to be dirty
> until device stopped.
> But for devices that are able to report dirty pages, dirtied pages
> will be marked again if hardware writes them later.
> 
> So, is it good to introduce a capability to let vfio/qemu know how to
> treat the dirty pages?
> (1) for devices have no fine-grained dirty page tracking capability
>    a. pinned pages are regarded as dirty pages. they are not cleared by
>    dirty page query
>    b. unpinned pages are regarded as dirty pages. they are cleared by
>    dirty page query or UNMAP ioctl.
> (2) for devices that have fine-grained dirty page tracking capability
>     a. pinned/unpinned pages are not regarded as dirty pages
>     b. only pages they reported are regarded as dirty pages and are to be
>     cleared by dirty page query and UNMAP ioctl.
> (3) for dirty pages marking APIs, like vfio_dma_rw()...
>     pages marked by them are regared as dirty and are to be cleared by
>     dirty page query and UNMAP ioctl
> 
> For (1), qemu VFIO only reports dirty page amount and would not transfer
> those pages until last round.

(1) and (3) can be implemented now. I don't think QEMU have support to 
delay certain marked pages dirty as of now. If QEMU queries dirty pages 
bitmap in pre-copy phase, all pinned pages reported as dirty will be 
transferred in pre-copy and again in stop-and-copy phase.

> for (2) and (3), qemu VFIO should report and transfer them in each
> round.
>

(2) can be added later

Thanks,
Kirti

> 
>> [I still worry whether migration will be usable with any
>> significant amount of system ram that's pinned in this way; the
>> downside will very easily get above the threshold that people like]
>>
> yes. that's why we have to do multi-round dirty page query and
> transfer and clear the dirty bitmaps in each round for devices that are
> able to track in fine grain.
> and that's why we have to report the amount of dirty pages before
> stop-and-copy phase for mdev devices, so that people are able to know
> the real downtime as much as possible.
> 
> Thanks
> Yan
> 
