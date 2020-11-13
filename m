Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B082B1FB8
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 17:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgKMQME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 11:12:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbgKMQMD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 11:12:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605283922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzPV3G2COP33yZAJV3i6S/9jkDAO8h9mjkNYvu/SPwg=;
        b=ZMfFlICiyxVYaVKoA75+pBccEyW5XzhvdG9W7JVTkuifiylnwQq77X9zjKUbYB6w+qagwD
        OrKBuzfVlD6zlyhKtKQFGVb4swRPL50D2ffVdwk7TUo+7C7dorVz0u1433nD20bEnEsRcD
        OtfrrOgXskbOQL8IuSp1jAGzpr9KAag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-vDgneSjqO1Gg21M8dJbxMw-1; Fri, 13 Nov 2020 11:11:58 -0500
X-MC-Unique: vDgneSjqO1Gg21M8dJbxMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58756801FDE;
        Fri, 13 Nov 2020 16:11:56 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8442B46;
        Fri, 13 Nov 2020 16:11:49 +0000 (UTC)
Subject: Re: [PATCH v10 05/11] vfio/pci: Register an iommu fault handler
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, robin.murphy@arm.com
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-6-eric.auger@redhat.com>
 <571978ff-ee8a-6e9f-6755-519d0871646f@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <80befd0f-8876-2cd2-7af0-c5e32e79323b@redhat.com>
Date:   Fri, 13 Nov 2020 17:11:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <571978ff-ee8a-6e9f-6755-519d0871646f@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 9/24/20 10:49 AM, Zenghui Yu wrote:
> Hi Eric,
> 
> On 2020/3/21 0:19, Eric Auger wrote:
>> Register an IOMMU fault handler which records faults in
>> the DMA FAULT region ring buffer. In a subsequent patch, we
>> will add the signaling of a specific eventfd to allow the
>> userspace to be notified whenever a new fault as shown up.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> [...]
> 
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index 586b89debed5..69595c240baf 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -27,6 +27,7 @@
>>   #include <linux/vfio.h>
>>   #include <linux/vgaarb.h>
>>   #include <linux/nospec.h>
>> +#include <linux/circ_buf.h>
>>     #include "vfio_pci_private.h"
>>   @@ -283,6 +284,38 @@ static const struct vfio_pci_regops
>> vfio_pci_dma_fault_regops = {
>>       .add_capability = vfio_pci_dma_fault_add_capability,
>>   };
>>   +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault,
>> void *data)
>> +{
>> +    struct vfio_pci_device *vdev = (struct vfio_pci_device *)data;
>> +    struct vfio_region_dma_fault *reg =
>> +        (struct vfio_region_dma_fault *)vdev->fault_pages;
>> +    struct iommu_fault *new =
>> +        (struct iommu_fault *)(vdev->fault_pages + reg->offset +
>> +            reg->head * reg->entry_size);
> 
> Shouldn't 'reg->head' be protected under the fault_queue_lock? Otherwise
> things may change behind our backs...>
> We shouldn't take any assumption about how IOMMU driver would report the
> fault (serially or in parallel), I think.

Yes I modified the locking

Thanks

Eric
> 
>> +    int head, tail, size;
>> +    int ret = 0;
>> +
>> +    if (fault->type != IOMMU_FAULT_DMA_UNRECOV)
>> +        return -ENOENT;
>> +
>> +    mutex_lock(&vdev->fault_queue_lock);
>> +
>> +    head = reg->head;
>> +    tail = reg->tail;
>> +    size = reg->nb_entries;
>> +
>> +    if (CIRC_SPACE(head, tail, size) < 1) {
>> +        ret = -ENOSPC;
>> +        goto unlock;
>> +    }
>> +
>> +    *new = *fault;
>> +    reg->head = (head + 1) % size;
>> +unlock:
>> +    mutex_unlock(&vdev->fault_queue_lock);
>> +    return ret;
>> +}
>> +
>>   #define DMA_FAULT_RING_LENGTH 512
>>     static int vfio_pci_init_dma_fault_region(struct vfio_pci_device
>> *vdev)
>> @@ -317,6 +350,13 @@ static int vfio_pci_init_dma_fault_region(struct
>> vfio_pci_device *vdev)
>>       header->entry_size = sizeof(struct iommu_fault);
>>       header->nb_entries = DMA_FAULT_RING_LENGTH;
>>       header->offset = sizeof(struct vfio_region_dma_fault);
>> +
>> +    ret = iommu_register_device_fault_handler(&vdev->pdev->dev,
>> +                    vfio_pci_iommu_dev_fault_handler,
>> +                    vdev);
>> +    if (ret)
>> +        goto out;
>> +
>>       return 0;
>>   out:
>>       kfree(vdev->fault_pages);
> 
> 
> Thanks,
> Zenghui
> 

