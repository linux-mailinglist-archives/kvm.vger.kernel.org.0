Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA9526D1FE
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 06:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726153AbgIQEAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 00:00:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725886AbgIQEAd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 00:00:33 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 00:00:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600315231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E1WZf9YMUb6/5XbKYk6oGkvxm0myYrBK4fT6wDWBTHU=;
        b=FHktM8EccAYpze4b2F8Vn3fuoz5VQNloVcto4C5V7HkukxYzaTo7mMT1KWZ9Wxx+mt8zuL
        hNGcD9k1yX5CBtVMcfyI2SO1g83XAJS/vWFRdlCfrmv2DpBn5hD94UricX0sO0uK2rpVn6
        TK1QKHUM0SPod23lU4VvleaT+RK1OlM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-AttH2l6fORKqBGY0lxfP4A-1; Wed, 16 Sep 2020 23:54:18 -0400
X-MC-Unique: AttH2l6fORKqBGY0lxfP4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A3D7107464E;
        Thu, 17 Sep 2020 03:54:16 +0000 (UTC)
Received: from [10.72.13.123] (ovpn-13-123.pek2.redhat.com [10.72.13.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 518575DE84;
        Thu, 17 Sep 2020 03:53:50 +0000 (UTC)
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
To:     "Jacob Pan (Jun)" <jacob.jun.pan@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <69ec9537-460f-2351-fa90-c31aaeef3c4b@redhat.com>
Date:   Thu, 17 Sep 2020 11:53:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916160901.000046ec@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/9/17 上午7:09, Jacob Pan (Jun) wrote:
> Hi Jason,
> On Wed, 16 Sep 2020 15:38:41 -0300, Jason Gunthorpe <jgg@nvidia.com>
> wrote:
>
>> On Wed, Sep 16, 2020 at 11:21:10AM -0700, Jacob Pan (Jun) wrote:
>>> Hi Jason,
>>> On Wed, 16 Sep 2020 14:01:13 -0300, Jason Gunthorpe <jgg@nvidia.com>
>>> wrote:
>>>    
>>>> On Wed, Sep 16, 2020 at 09:33:43AM -0700, Raj, Ashok wrote:
>>>>> On Wed, Sep 16, 2020 at 12:07:54PM -0300, Jason Gunthorpe
>>>>> wrote:
>>>>>> On Tue, Sep 15, 2020 at 05:22:26PM -0700, Jacob Pan (Jun)
>>>>>> wrote:
>>>>>>>> If user space wants to bind page tables, create the PASID
>>>>>>>> with /dev/sva, use ioctls there to setup the page table
>>>>>>>> the way it wants, then pass the now configured PASID to a
>>>>>>>> driver that can use it.
>>>>>>> Are we talking about bare metal SVA?
>>>>>> What a weird term.
>>>>> Glad you noticed it at v7 :-)
>>>>>
>>>>> Any suggestions on something less weird than
>>>>> Shared Virtual Addressing? There is a reason why we moved from
>>>>> SVM to SVA.
>>>> SVA is fine, what is "bare metal" supposed to mean?
>>>>    
>>> What I meant here is sharing virtual address between DMA and host
>>> process. This requires devices perform DMA request with PASID and
>>> use IOMMU first level/stage 1 page tables.
>>> This can be further divided into 1) user SVA 2) supervisor SVA
>>> (sharing init_mm)
>>>
>>> My point is that /dev/sva is not useful here since the driver can
>>> perform PASID allocation while doing SVA bind.
>> No, you are thinking too small.
>>
>> Look at VDPA, it has a SVA uAPI. Some HW might use PASID for the SVA.
>>
> Could you point to me the SVA UAPI? I couldn't find it in the mainline.
> Seems VDPA uses VHOST interface?


It's the vhost_iotlb_msg defined in uapi/linux/vhost_types.h.


>
>> When VDPA is used by DPDK it makes sense that the PASID will be SVA
>> and 1:1 with the mm_struct.
>>
> I still don't see why bare metal DPDK needs to get a handle of the
> PASID.


My understanding is that it may:

- have a unified uAPI with vSVA: alloc, bind, unbind, free
- leave the binding policy to userspace instead of the using a implied 
one in the kenrel


> Perhaps the SVA patch would explain. Or are you talking about
> vDPA DPDK process that is used to support virtio-net-pmd in the guest?
>
>> When VDPA is used by qemu it makes sense that the PASID will be an
>> arbitary IOVA map constructed to be 1:1 with the guest vCPU physical
>> map. /dev/sva allows a single uAPI to do this kind of setup, and qemu
>> can support it while supporting a range of SVA kernel drivers. VDPA
>> and vfio-mdev are obvious initial targets.
>>
>> *BOTH* are needed.
>>
>> In general any uAPI for PASID should have the option to use either the
>> mm_struct SVA PASID *OR* a PASID from /dev/sva. It costs virtually
>> nothing to implement this in the driver as PASID is just a number, and
>> gives so much more flexability.
>>
> Not really nothing in terms of PASID life cycles. For example, if user
> uses uacce interface to open an accelerator, it gets an FD_acc. Then it
> opens /dev/sva to allocate PASID then get another FD_pasid. Then we
> pass FD_pasid to the driver to bind page tables, perhaps multiple
> drivers. Now we have to worry about If FD_pasid gets closed before
> FD_acc(s) closed and all these race conditions.


I'm not sure I understand this. But this demonstrates the flexibility of 
an unified uAPI. E.g it allows vDPA and VFIO device to use the same 
PAISD which can be shared with a process in the guest.

For the race condition, it could be probably solved with refcnt.

Thanks


>
> If we do not expose FD_pasid to the user, the teardown is much simpler
> and streamlined. Following each FD_acc close, PASID unbind is performed.
>
>>> Yi can correct me but this set is is about VFIO-PCI, VFIO-mdev will
>>> be introduced later.
>> Last patch is:
>>
>>    vfio/type1: Add vSVA support for IOMMU-backed mdevs
>>
>> So pretty hard to see how this is not about vfio-mdev, at least a
>> little..
>>
>> Jason
>
> Thanks,
>
> Jacob
>

