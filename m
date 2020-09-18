Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF0A26F4D9
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 05:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIRD65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 23:58:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgIRD65 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 23:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600401535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvuOWRWNIiYpIWtybWCQWDV22wHbKAsOWIP2gscO7JY=;
        b=ggJ7wBI4cg6ZFB7eetla8Wqbr9dz9Z++fEYt9vuBAQorJhxS1Dl0202irDrOqVrSSvIxAo
        D8OEE5B7UFsugpTI9kr/QZRZFqWwRQPQC74m9yfCKdJR/gAJZQn2P8EKRz2aQDbGezlmA8
        J8XHjC7WbuTc2BUsX3kOvKJmxKt1ot4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-8o9i7UA2P7iBe0zuAxo_Hw-1; Thu, 17 Sep 2020 23:58:51 -0400
X-MC-Unique: 8o9i7UA2P7iBe0zuAxo_Hw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A1DA186DD40;
        Fri, 18 Sep 2020 03:58:48 +0000 (UTC)
Received: from [10.72.13.167] (ovpn-13-167.pek2.redhat.com [10.72.13.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0B181C4;
        Fri, 18 Sep 2020 03:58:30 +0000 (UTC)
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
To:     "Jacob Pan (Jun)" <jacob.jun.pan@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Liu Yi L <yi.l.liu@intel.com>, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        jacob.jun.pan@linux.intel.com
References: <20200915113341.GW904879@nvidia.com>
 <20200915181154.GA70770@otc-nc-03> <20200915184510.GB1573713@nvidia.com>
 <20200915150851.76436ca1@jacob-builder> <20200915235126.GK1573713@nvidia.com>
 <20200915171319.00003f59@linux.intel.com> <20200916150754.GE6199@nvidia.com>
 <20200916163343.GA76252@otc-nc-03> <20200916170113.GD3699@nvidia.com>
 <20200916112110.000024ee@intel.com> <20200916183841.GI6199@nvidia.com>
 <20200916160901.000046ec@intel.com>
 <69ec9537-460f-2351-fa90-c31aaeef3c4b@redhat.com>
 <20200917111754.00006bcc@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ad909852-1201-6a4a-ffb0-9ad0df6c2e81@redhat.com>
Date:   Fri, 18 Sep 2020 11:58:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200917111754.00006bcc@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/9/18 上午2:17, Jacob Pan (Jun) wrote:
> Hi Jason,
> On Thu, 17 Sep 2020 11:53:49 +0800, Jason Wang <jasowang@redhat.com>
> wrote:
>
>> On 2020/9/17 上午7:09, Jacob Pan (Jun) wrote:
>>> Hi Jason,
>>> On Wed, 16 Sep 2020 15:38:41 -0300, Jason Gunthorpe <jgg@nvidia.com>
>>> wrote:
>>>   
>>>> On Wed, Sep 16, 2020 at 11:21:10AM -0700, Jacob Pan (Jun) wrote:
>>>>> Hi Jason,
>>>>> On Wed, 16 Sep 2020 14:01:13 -0300, Jason Gunthorpe
>>>>> <jgg@nvidia.com> wrote:
>>>>>       
>>>>>> On Wed, Sep 16, 2020 at 09:33:43AM -0700, Raj, Ashok wrote:
>>>>>>> On Wed, Sep 16, 2020 at 12:07:54PM -0300, Jason Gunthorpe
>>>>>>> wrote:
>>>>>>>> On Tue, Sep 15, 2020 at 05:22:26PM -0700, Jacob Pan (Jun)
>>>>>>>> wrote:
>>>>>>>>>> If user space wants to bind page tables, create the PASID
>>>>>>>>>> with /dev/sva, use ioctls there to setup the page table
>>>>>>>>>> the way it wants, then pass the now configured PASID to a
>>>>>>>>>> driver that can use it.
>>>>>>>>> Are we talking about bare metal SVA?
>>>>>>>> What a weird term.
>>>>>>> Glad you noticed it at v7 :-)
>>>>>>>
>>>>>>> Any suggestions on something less weird than
>>>>>>> Shared Virtual Addressing? There is a reason why we moved from
>>>>>>> SVM to SVA.
>>>>>> SVA is fine, what is "bare metal" supposed to mean?
>>>>>>       
>>>>> What I meant here is sharing virtual address between DMA and host
>>>>> process. This requires devices perform DMA request with PASID and
>>>>> use IOMMU first level/stage 1 page tables.
>>>>> This can be further divided into 1) user SVA 2) supervisor SVA
>>>>> (sharing init_mm)
>>>>>
>>>>> My point is that /dev/sva is not useful here since the driver can
>>>>> perform PASID allocation while doing SVA bind.
>>>> No, you are thinking too small.
>>>>
>>>> Look at VDPA, it has a SVA uAPI. Some HW might use PASID for the
>>>> SVA.
>>> Could you point to me the SVA UAPI? I couldn't find it in the
>>> mainline. Seems VDPA uses VHOST interface?
>>
>> It's the vhost_iotlb_msg defined in uapi/linux/vhost_types.h.
>>
> Thanks for the pointer, for complete vSVA functionality we would need
> 1 TLB flush (IOTLB and PASID cache etc.)
> 2 PASID alloc/free
> 3 bind/unbind page tables or PASID tables
> 4 Page request service
>
> Seems vhost_iotlb_msg can be used for #1 partially. And the
> proposal is to pluck out the rest into /dev/sda? Seems awkward as Alex
> pointed out earlier for similar situation in VFIO.


Consider it doesn't have any PASID support yet, my understanding is that 
if we go with /dev/sva:

- vhost uAPI will still keep the uAPI for associating an ASID to a 
specific virtqueue
- except for this, we can use /dev/sva for all the rest (P)ASID operations


>
>>>   
>>>> When VDPA is used by DPDK it makes sense that the PASID will be SVA
>>>> and 1:1 with the mm_struct.
>>>>   
>>> I still don't see why bare metal DPDK needs to get a handle of the
>>> PASID.
>>
>> My understanding is that it may:
>>
>> - have a unified uAPI with vSVA: alloc, bind, unbind, free
> Got your point, but vSVA needs more than these


Yes it's just a subset of what vSVA required.


>
>> - leave the binding policy to userspace instead of the using a
>> implied one in the kenrel
>>
> Only if necessary.


Yes, I think it's all about visibility(flexibility) and**manageability.

Consider device has queue A, B, C. We will only dedicated queue A, B for 
one PASID(for vSVA) and C with another PASID(for SVA). It looks to me 
the current sva_bind() API doesn't support this. We still need an API 
for allocating a PASID for SVA and assign it to the (mediated) device.  
This case is pretty common for implementing a shadow queue for a guest.


>
>>> Perhaps the SVA patch would explain. Or are you talking about
>>> vDPA DPDK process that is used to support virtio-net-pmd in the
>>> guest?
>>>> When VDPA is used by qemu it makes sense that the PASID will be an
>>>> arbitary IOVA map constructed to be 1:1 with the guest vCPU
>>>> physical map. /dev/sva allows a single uAPI to do this kind of
>>>> setup, and qemu can support it while supporting a range of SVA
>>>> kernel drivers. VDPA and vfio-mdev are obvious initial targets.
>>>>
>>>> *BOTH* are needed.
>>>>
>>>> In general any uAPI for PASID should have the option to use either
>>>> the mm_struct SVA PASID *OR* a PASID from /dev/sva. It costs
>>>> virtually nothing to implement this in the driver as PASID is just
>>>> a number, and gives so much more flexability.
>>>>   
>>> Not really nothing in terms of PASID life cycles. For example, if
>>> user uses uacce interface to open an accelerator, it gets an
>>> FD_acc. Then it opens /dev/sva to allocate PASID then get another
>>> FD_pasid. Then we pass FD_pasid to the driver to bind page tables,
>>> perhaps multiple drivers. Now we have to worry about If FD_pasid
>>> gets closed before FD_acc(s) closed and all these race conditions.
>>
>> I'm not sure I understand this. But this demonstrates the flexibility
>> of an unified uAPI. E.g it allows vDPA and VFIO device to use the
>> same PAISD which can be shared with a process in the guest.
>>
> This is for user DMA not for vSVA. I was contending that /dev/sva
> creates unnecessary steps for such usage.


A question here is where the PASID management is expected to be done. 
I'm not quite sure the silent 1:1 binding done in intel_svm_bind_mm() 
can satisfy the requirement for management layer.


>
> For vSVA, I think vDPA and VFIO can potentially share but I am not
> seeing convincing benefits.
>
> If a guest process wants to do SVA with a VFIO assigned device and a
> vDPA-backed virtio-net at the same time, it might be a limitation if
> PASID is not managed via a common interface.


Yes.


> But I am not sure how vDPA
> SVA support will look like, does it support gIOVA? need virtio IOMMU?


Yes, it supports gIOVA and it should work with any type of vIOMMU. I 
think vDPA will start from Intel vIOMMU support in Qemu.

For virtio IOMMU, we will probably support it in the future consider it 
doesn't have any SVA capability, and it doesn't use a page table that 
can be nested via a hardware IOMMU.


>> For the race condition, it could be probably solved with refcnt.
>>
> Agreed but the best solution might be not to have the problem in the
> first place :)


I agree, it's only worth to bother if it has real benefits.

Thanks


>
>> Thanks
>>
>>
>>> If we do not expose FD_pasid to the user, the teardown is much
>>> simpler and streamlined. Following each FD_acc close, PASID unbind
>>> is performed.
>>>>> Yi can correct me but this set is is about VFIO-PCI, VFIO-mdev
>>>>> will be introduced later.
>>>> Last patch is:
>>>>
>>>>     vfio/type1: Add vSVA support for IOMMU-backed mdevs
>>>>
>>>> So pretty hard to see how this is not about vfio-mdev, at least a
>>>> little..
>>>>
>>>> Jason
>>> Thanks,
>>>
>>> Jacob
>>>   
>
> Thanks,
>
> Jacob
>

