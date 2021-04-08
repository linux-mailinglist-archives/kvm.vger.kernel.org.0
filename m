Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98564358476
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 15:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhDHNSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 09:18:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229803AbhDHNSu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 09:18:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617887918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PiO3GvP9OJOtaO934VB9+eCT8vSHoSl1RS40T3FyfR4=;
        b=S/sU7MBiavapUHRo7tNkVcp25RPAalpNUUtcdIaBj1A2pEgK0BrPan9KcVKNVJCaBa7rRV
        UCUOgZDT0XOZENjuBaoCoA+raPJe+lBTfJdMjPe/TXSiur0xw26O0n8BNAYGnngCERt1Up
        5Lr9adQyQOym9Q+PKF2VAM+qPfIqThY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-1pPep34SOE21HGMUXwbNcg-1; Thu, 08 Apr 2021 09:18:35 -0400
X-MC-Unique: 1pPep34SOE21HGMUXwbNcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32C59107ACCA;
        Thu,  8 Apr 2021 13:18:34 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-93.pek2.redhat.com [10.72.12.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A70A95C1C4;
        Thu,  8 Apr 2021 13:18:28 +0000 (UTC)
Subject: Re: [PATCH v2 2/3] virito_pci: add timeout to reset device operation
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     oren@nvidia.com, nitzanc@nvidia.com, cohuck@redhat.com
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <20210408081109.56537-2-mgurtovoy@nvidia.com>
 <2bead2b3-fa23-dc1e-3200-ddfa24944b75@redhat.com>
 <a00abefe-790d-8239-ac42-9f70daa7a25c@nvidia.com>
 <93221213-8fc3-96ef-7e89-b7c03bea5322@redhat.com>
 <7ed9cafa-498e-156d-c667-6da3fa432b18@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2b4edcaf-779d-b197-0437-c6cb8e82e8e1@redhat.com>
Date:   Thu, 8 Apr 2021 21:18:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <7ed9cafa-498e-156d-c667-6da3fa432b18@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/4/8 下午8:57, Max Gurtovoy 写道:
>
> On 4/8/2021 3:45 PM, Jason Wang wrote:
>>
>> 在 2021/4/8 下午5:44, Max Gurtovoy 写道:
>>>
>>> On 4/8/2021 12:01 PM, Jason Wang wrote:
>>>>
>>>> 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
>>>>> According to the spec after writing 0 to device_status, the driver 
>>>>> MUST
>>>>> wait for a read of device_status to return 0 before reinitializing 
>>>>> the
>>>>> device. In case we have a device that won't return 0, the reset
>>>>> operation will loop forever and cause the host/vm to stuck. Set 
>>>>> timeout
>>>>> for 3 minutes before giving up on the device.
>>>>>
>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>> ---
>>>>>   drivers/virtio/virtio_pci_modern.c | 10 +++++++++-
>>>>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/virtio/virtio_pci_modern.c 
>>>>> b/drivers/virtio/virtio_pci_modern.c
>>>>> index cc3412a96a17..dcee616e8d21 100644
>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>> @@ -162,6 +162,7 @@ static int vp_reset(struct virtio_device *vdev)
>>>>>   {
>>>>>       struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>>>       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>>>> +    unsigned long timeout = jiffies + msecs_to_jiffies(180000);
>>>>>         /* 0 status means a reset. */
>>>>>       vp_modern_set_status(mdev, 0);
>>>>> @@ -169,9 +170,16 @@ static int vp_reset(struct virtio_device *vdev)
>>>>>        * device_status to return 0 before reinitializing the device.
>>>>>        * This will flush out the status write, and flush in device 
>>>>> writes,
>>>>>        * including MSI-X interrupts, if any.
>>>>> +     * Set a timeout before giving up on the device.
>>>>>        */
>>>>> -    while (vp_modern_get_status(mdev))
>>>>> +    while (vp_modern_get_status(mdev)) {
>>>>> +        if (time_after(jiffies, timeout)) {
>>>>
>>>>
>>>> What happens if the device finish the rest after the timeout?
>>>
>>>
>>> The driver will set VIRTIO_CONFIG_S_FAILED and one can re-probe it 
>>> later on (e.g by re-scanning the pci bus).
>>
>>
>> Ok, so do we need the flush through vp_synchronize_vectors() here?
>
> If the device didn't write 0 to status I guess we don't need that.
>
> The device shouldn't raise any interrupt before negotiation finish 
> successfully.


The reset could be triggered in other places like driver removing.

Thanks


>
> MST, is that correct ?
>
>>
>> Thanks
>>
>>
>>>
>>>
>>>>
>>>> Thanks
>>>>
>>>>
>>>>> + dev_err(&vdev->dev, "virtio: device not ready. "
>>>>> +                "Aborting. Try again later\n");
>>>>> +            return -EAGAIN;
>>>>> +        }
>>>>>           msleep(1);
>>>>> +    }
>>>>>       /* Flush pending VQ/configuration callbacks. */
>>>>>       vp_synchronize_vectors(vdev);
>>>>>       return 0;
>>>>
>>>
>>
>

