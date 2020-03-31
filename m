Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D57B199530
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 13:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgCaLQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 07:16:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25771 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729483AbgCaLQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 07:16:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585653365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Y3EQ6zy8Ywg1vLVf1iKfWgYP6vdUGdfsrOraLivQYE=;
        b=MmAPsrX+yWGsogzMTbYqrjhsEB144SerAkZNXBUr9Ju7D1BdifTfKlT++uPKpJsDYrraDP
        BBoaow+U9rqGyfpEPrGlAzP8BV+AGopKzpOoAz4gEFYegrWeFDUH3785xJ5Pls78VB/nmb
        ccVWECcKEIMXmi8bJNHx3G+u52iRgb4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-29f4PYmDNWSTKCgqa2GU7g-1; Tue, 31 Mar 2020 07:15:58 -0400
X-MC-Unique: 29f4PYmDNWSTKCgqa2GU7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB311A0CBF;
        Tue, 31 Mar 2020 11:15:56 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1520E9128F;
        Tue, 31 Mar 2020 11:15:42 +0000 (UTC)
Subject: Re: [PATCH v2 08/22] vfio/common: provide PASID alloc/free hooks
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-9-git-send-email-yi.l.liu@intel.com>
 <e6d9a5bc-fd54-c220-067d-0597ad8e86fc@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21AD6D@SHSMSX104.ccr.corp.intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ebd5b8ab-c3b8-87a7-d1cb-2a4c9c02fa61@redhat.com>
Date:   Tue, 31 Mar 2020 13:15:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A21AD6D@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,
On 3/31/20 12:59 PM, Liu, Yi L wrote:
> Hi Eric,
> 
>> From: Auger Eric
>> Sent: Tuesday, March 31, 2020 6:48 PM
>> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
>> alex.williamson@redhat.com; peterx@redhat.com
>> Cc: pbonzini@redhat.com; mst@redhat.com; david@gibson.dropbear.id.au; Tian,
>> Kevin <kevin.tian@intel.com>; Tian, Jun J <jun.j.tian@intel.com>; Sun, Yi Y
>> <yi.y.sun@intel.com>; kvm@vger.kernel.org; Wu, Hao <hao.wu@intel.com>; jean-
>> philippe@linaro.org; Jacob Pan <jacob.jun.pan@linux.intel.com>; Yi Sun
>> <yi.y.sun@linux.intel.com>
>> Subject: Re: [PATCH v2 08/22] vfio/common: provide PASID alloc/free hooks
>>
>> Yi,
>>
>> On 3/30/20 6:24 AM, Liu Yi L wrote:
>>> This patch defines vfio_host_iommu_context_info, implements the PASID
>>> alloc/free hooks defined in HostIOMMUContextClass.
>>>
>>> Cc: Kevin Tian <kevin.tian@intel.com>
>>> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>> Cc: Peter Xu <peterx@redhat.com>
>>> Cc: Eric Auger <eric.auger@redhat.com>
>>> Cc: Yi Sun <yi.y.sun@linux.intel.com>
>>> Cc: David Gibson <david@gibson.dropbear.id.au>
>>> Cc: Alex Williamson <alex.williamson@redhat.com>
>>> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>>> ---
>>>  hw/vfio/common.c                      | 69 +++++++++++++++++++++++++++++++++++
>>>  include/hw/iommu/host_iommu_context.h |  3 ++
>>>  include/hw/vfio/vfio-common.h         |  4 ++
>>>  3 files changed, 76 insertions(+)
>>>
>>> diff --git a/hw/vfio/common.c b/hw/vfio/common.c index
>>> c276732..5f3534d 100644
>>> --- a/hw/vfio/common.c
>>> +++ b/hw/vfio/common.c
>>> @@ -1179,6 +1179,53 @@ static int vfio_get_iommu_type(VFIOContainer
>> *container,
>>>      return -EINVAL;
>>>  }
>>>
>>> +static int vfio_host_iommu_ctx_pasid_alloc(HostIOMMUContext *iommu_ctx,
>>> +                                           uint32_t min, uint32_t max,
>>> +                                           uint32_t *pasid) {
>>> +    VFIOContainer *container = container_of(iommu_ctx,
>>> +                                            VFIOContainer, iommu_ctx);
>>> +    struct vfio_iommu_type1_pasid_request req;
>>> +    unsigned long argsz;
>> you can easily avoid using argsz variable
> 
> oh, right. :-)
> 
>>> +    int ret;
>>> +
>>> +    argsz = sizeof(req);
>>> +    req.argsz = argsz;
>>> +    req.flags = VFIO_IOMMU_PASID_ALLOC;
>>> +    req.alloc_pasid.min = min;
>>> +    req.alloc_pasid.max = max;
>>> +
>>> +    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
>>> +        ret = -errno;
>>> +        error_report("%s: %d, alloc failed", __func__, ret);
>> better use %m directly or strerror(errno) also include vbasedev->name?
> 
> or yes, vbasedev->name is also nice to have.
> 
>>> +        return ret;
>>> +    }
>>> +    *pasid = req.alloc_pasid.result;
>>> +    return 0;
>>> +}
>>> +
>>> +static int vfio_host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx,
>>> +                                          uint32_t pasid) {
>>> +    VFIOContainer *container = container_of(iommu_ctx,
>>> +                                            VFIOContainer, iommu_ctx);
>>> +    struct vfio_iommu_type1_pasid_request req;
>>> +    unsigned long argsz;
>> same
> 
> got it.
> 
>>> +    int ret;
>>> +
>>> +    argsz = sizeof(req);
>>> +    req.argsz = argsz;
>>> +    req.flags = VFIO_IOMMU_PASID_FREE;
>>> +    req.free_pasid = pasid;
>>> +
>>> +    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
>>> +        ret = -errno;
>>> +        error_report("%s: %d, free failed", __func__, ret);
>> same
> 
> yep.
>>> +        return ret;
>>> +    }
>>> +    return 0;
>>> +}
>>> +
>>>  static int vfio_init_container(VFIOContainer *container, int group_fd,
>>>                                 Error **errp)  { @@ -1791,3 +1838,25
>>> @@ int vfio_eeh_as_op(AddressSpace *as, uint32_t op)
>>>      }
>>>      return vfio_eeh_container_op(container, op);  }
>>> +
>>> +static void vfio_host_iommu_context_class_init(ObjectClass *klass,
>>> +                                                       void *data) {
>>> +    HostIOMMUContextClass *hicxc = HOST_IOMMU_CONTEXT_CLASS(klass);
>>> +
>>> +    hicxc->pasid_alloc = vfio_host_iommu_ctx_pasid_alloc;
>>> +    hicxc->pasid_free = vfio_host_iommu_ctx_pasid_free; }
>>> +
>>> +static const TypeInfo vfio_host_iommu_context_info = {
>>> +    .parent = TYPE_HOST_IOMMU_CONTEXT,
>>> +    .name = TYPE_VFIO_HOST_IOMMU_CONTEXT,
>>> +    .class_init = vfio_host_iommu_context_class_init,
>> Ah OK
>>
>> This is the object inheriting from the abstract TYPE_HOST_IOMMU_CONTEXT.
> 
> yes. it is. :-)
> 
>> I initially thought VTDHostIOMMUContext was, sorry for the misunderstanding.
> 
> Ah, my fault, should have got it earlier. so we may have just aligned
> in last Oct.
> 
>> Do you expect other HostIOMMUContext backends? Given the name and ops, it
>> looks really related to VFIO?
> 
> For other backends, I guess you mean other passthru modules? If yes, I
> think they should have their own type name. Just like vIOMMUs, the below
> vIOMMUs defines their own type name and inherits the same parent.
> 
> static const TypeInfo vtd_iommu_memory_region_info = {
>     .parent = TYPE_IOMMU_MEMORY_REGION,
>     .name = TYPE_INTEL_IOMMU_MEMORY_REGION,
>     .class_init = vtd_iommu_memory_region_class_init,
> };
> 
> static const TypeInfo smmuv3_iommu_memory_region_info = {
>     .parent = TYPE_IOMMU_MEMORY_REGION,
>     .name = TYPE_SMMUV3_IOMMU_MEMORY_REGION,
>     .class_init = smmuv3_iommu_memory_region_class_init,
> };
> 
> static const TypeInfo amdvi_iommu_memory_region_info = {
>     .parent = TYPE_IOMMU_MEMORY_REGION,
>     .name = TYPE_AMD_IOMMU_MEMORY_REGION,
>     .class_init = amdvi_iommu_memory_region_class_init,
> };
Sorry I am confused now.

You don't have such kind of inheritance at the moment in your series.

You have an abstract object (TYPE_HOST_IOMMU_CONTEXT, HostIOMMUContext)
which is derived into TYPE_VFIO_HOST_IOMMU_CONTEXT. Only the class ops
are specialized for VFIO. But I do not foresee any other user than VFIO
(ie. other implementers of the class ops), hence my question. For
instance would virtio/vhost ever implement its TYPE_HOST_IOMMU_CONTEXT.

On the other hand you have VTDHostIOMMUContext which is not a QOM
derived object.

Thanks

Eric
> 
> Regards,
> Yi Liu
> 

