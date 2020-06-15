Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6710F1F8C67
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 05:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgFODCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Jun 2020 23:02:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41314 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728164AbgFODCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Jun 2020 23:02:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592190129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K4U+ztHAwvhjjKgIyDd+AhXpFv+PexCkPkFdjCrijfk=;
        b=RtzaXk8+EF5HViCnH+rOHut8QYZa26XZmAWwOT2HL6fYcuEs5aSXwqzxf46TraEGJu7QKW
        nBxAX48tozZfldUi6H4Y9xydOaYvpXkyE52oejSBs2o4KTEFiqXSDMcN8mxJTwsYtxl70A
        Iac5r5bZH+uP9ChNr9bDGNnwMSg0kug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-c7Q0tsasP_2KGTb5GXXjng-1; Sun, 14 Jun 2020 23:02:05 -0400
X-MC-Unique: c7Q0tsasP_2KGTb5GXXjng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D2B78064D8;
        Mon, 15 Jun 2020 03:02:03 +0000 (UTC)
Received: from [10.72.13.232] (ovpn-13-232.pek2.redhat.com [10.72.13.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E19610013D6;
        Mon, 15 Jun 2020 03:01:56 +0000 (UTC)
Subject: Re: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
 <467d5b58-b70c-1c45-4130-76b6e18c05af@redhat.com>
 <f7eb1154-0f52-0f12-129f-2b511f5a4685@linux.ibm.com>
 <6356ba7f-afab-75e1-05ff-4a22b88c610e@linux.ibm.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a02b9f94-eb48-4ae2-0ade-a4ce26b61ad8@redhat.com>
Date:   Mon, 15 Jun 2020 11:01:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6356ba7f-afab-75e1-05ff-4a22b88c610e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/6/12 下午7:38, Pierre Morel wrote:
>
>
> On 2020-06-12 11:21, Pierre Morel wrote:
>>
>>
>> On 2020-06-11 05:10, Jason Wang wrote:
>>>
>>> On 2020/6/10 下午9:11, Pierre Morel wrote:
>>>> Protected Virtualisation protects the memory of the guest and
>>>> do not allow a the host to access all of its memory.
>>>>
>>>> Let's refuse a VIRTIO device which does not use IOMMU
>>>> protected access.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>   drivers/s390/virtio/virtio_ccw.c | 5 +++++
>>>>   1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/drivers/s390/virtio/virtio_ccw.c 
>>>> b/drivers/s390/virtio/virtio_ccw.c
>>>> index 5730572b52cd..06ffbc96587a 100644
>>>> --- a/drivers/s390/virtio/virtio_ccw.c
>>>> +++ b/drivers/s390/virtio/virtio_ccw.c
>>>> @@ -986,6 +986,11 @@ static void virtio_ccw_set_status(struct 
>>>> virtio_device *vdev, u8 status)
>>>>       if (!ccw)
>>>>           return;
>>>> +    /* Protected Virtualisation guest needs IOMMU */
>>>> +    if (is_prot_virt_guest() &&
>>>> +        !__virtio_test_bit(vdev, VIRTIO_F_IOMMU_PLATFORM))
>>>> +            status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
>>>> +
>>>>       /* Write the status to the host. */
>>>>       vcdev->dma_area->status = status;
>>>>       ccw->cmd_code = CCW_CMD_WRITE_STATUS;
>>>
>>>
>>> I wonder whether we need move it to virtio core instead of ccw.
>>>
>>> I think the other memory protection technologies may suffer from 
>>> this as well.
>>>
>>> Thanks
>>>
>>
>>
>> What would you think of the following, also taking into account 
>> Connie's comment on where the test should be done:
>>
>> - declare a weak function in virtio.c code, returning that memory 
>> protection is not in use.
>>
>> - overwrite the function in the arch code
>>
>> - call this function inside core virtio_finalize_features() and if 
>> required fail if the device don't have VIRTIO_F_IOMMU_PLATFORM.


I think this is fine.


>>
>> Alternative could be to test a global variable that the architecture 
>> would overwrite if needed but I find the weak function solution more 
>> flexible.
>>
>> With a function, we also have the possibility to provide the device 
>> as argument and take actions depending it, this may answer Halil's 
>> concern.
>>
>> Regards,
>> Pierre
>>
>
> hum, in between I found another way which seems to me much better:
>
> We already have the force_dma_unencrypted() function available which 
> AFAIU is what we want for encrypted memory protection and is already 
> used by power and x86 SEV/SME in a way that seems AFAIU compatible 
> with our problem.
>
> Even DMA and IOMMU are different things, I think they should be used 
> together in our case.
>
> What do you think?
>
> The patch would then be something like:
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index a977e32a88f2..53476d5bbe35 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -4,6 +4,7 @@
>  #include <linux/virtio_config.h>
>  #include <linux/module.h>
>  #include <linux/idr.h>
> +#include <linux/dma-direct.h>
>  #include <uapi/linux/virtio_ids.h>
>
>  /* Unique numbering for virtio devices. */
> @@ -179,6 +180,10 @@ int virtio_finalize_features(struct virtio_device 
> *dev)
>         if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>                 return 0;
>
> +       if (force_dma_unencrypted(&dev->dev) &&
> +           !virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM))
> +               return -EIO;
> +
>         virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
>         status = dev->config->get_status(dev);
>         if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {


I think this can work but need to listen from Michael.

Thanks


>
>
> Regards,
> Pierre
>

