Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EAF32CE95
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 09:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbhCDIgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 03:36:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235895AbhCDIga (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 03:36:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614846904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0bXhR7YJ9IaSyeZ7VfID8y95/AMg+XDUasgSyE009NI=;
        b=YfP6WUN7ImCBSGznzRgDAe9KpDYmTsmTckBhCMJjOEN/PO4GNE8VtRQeLuG90yY61pWDVi
        7udEWoHZ0OVKZXs3380pQ3m8/FvQeOPtHA4BimhKHMs7/6KFcCQZOpZLp27clbpj1LC9vX
        ceBgEr2SBFpmFlCYI5Dxkdjowb4LPSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-TEysT5XLPrWNfNrk6byMxQ-1; Thu, 04 Mar 2021 03:35:03 -0500
X-MC-Unique: TEysT5XLPrWNfNrk6byMxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E97ED5A090;
        Thu,  4 Mar 2021 08:35:01 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1580E5FCC8;
        Thu,  4 Mar 2021 08:34:53 +0000 (UTC)
Subject: Re: [RFC PATCH 01/10] vdpa: add get_config_size callback in
 vdpa_config_ops
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
 <20210216094454.82106-2-sgarzare@redhat.com>
 <5de4cd5b-04cb-46ca-1717-075e5e8542fd@redhat.com>
 <20210302141516.oxsdb7jogrvu75yc@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8a3f39ab-1cee-d0c3-e4d1-dc3ec492a763@redhat.com>
Date:   Thu, 4 Mar 2021 16:34:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210302141516.oxsdb7jogrvu75yc@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/3/2 10:15 下午, Stefano Garzarella wrote:
> On Tue, Mar 02, 2021 at 12:14:13PM +0800, Jason Wang wrote:
>>
>> On 2021/2/16 5:44 下午, Stefano Garzarella wrote:
>>> This new callback is used to get the size of the configuration space
>>> of vDPA devices.
>>>
>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>> ---
>>>  include/linux/vdpa.h              | 4 ++++
>>>  drivers/vdpa/ifcvf/ifcvf_main.c   | 6 ++++++
>>>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 6 ++++++
>>>  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 9 +++++++++
>>>  4 files changed, 25 insertions(+)
>>>
>>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>> index 4ab5494503a8..fddf42b17573 100644
>>> --- a/include/linux/vdpa.h
>>> +++ b/include/linux/vdpa.h
>>> @@ -150,6 +150,9 @@ struct vdpa_iova_range {
>>>   * @set_status:            Set the device status
>>>   *                @vdev: vdpa device
>>>   *                @status: virtio device status
>>> + * @get_config_size:        Get the size of the configuration space
>>> + *                @vdev: vdpa device
>>> + *                Returns size_t: configuration size
>>
>>
>> Rethink about this, how much we could gain by introducing a dedicated 
>> ops here? E.g would it be simpler if we simply introduce a 
>> max_config_size to vdpa device?
>
> Mainly because in this way we don't have to add new parameters to the 
> vdpa_alloc_device() function.
>
> We do the same for example for 'get_device_id', 'get_vendor_id', 
> 'get_vq_num_max'. All of these are usually static, but we have ops.
> I think because it's easier to extend.
>
> I don't know if it's worth adding a new structure for these static 
> values at this point, like 'struct vdpa_config_params'.


Yes, that's the point. I think for any static values, it should be set 
during device allocation.

I'm fine with both.

Thanks


>
> Thanks,
> Stefano
>

