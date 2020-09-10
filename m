Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE64263FA0
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 10:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgIJIXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 04:23:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730260AbgIJIVm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 04:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599726087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Licpb2tWu/dWgg8H99rcLlplSx9dLzZWPJS2xlbzcFs=;
        b=bYRZ0Z5f0Dn6zETU/u5JVEQxAeoeT4AZXQCDjl7Xq9dJs1jT3uk9G9dJdm20VqXzTEHFVO
        N3qTsy00D2xhVApYDW3cRx/1od/dnevYOBi0K6h1MjbFqxj/CYP80JoAfiwwFhrNtLiQkX
        PGT8c6DhuNZ4yzTNV5jtYeiwJroxap0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-huJc5G6wPgyIpErT6e2DCQ-1; Thu, 10 Sep 2020 04:21:23 -0400
X-MC-Unique: huJc5G6wPgyIpErT6e2DCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 287B364081;
        Thu, 10 Sep 2020 08:21:22 +0000 (UTC)
Received: from [10.36.112.212] (ovpn-112-212.ams2.redhat.com [10.36.112.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A3E37E165;
        Thu, 10 Sep 2020 08:21:16 +0000 (UTC)
Subject: Re: [PATCH v4 10/10] vfio/fsl-mc: Add support for device reset
To:     Diana Craciun OSS <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-11-diana.craciun@oss.nxp.com>
 <629498a6-8329-1045-c1a4-ab334f3c8107@redhat.com>
 <665b9fbc-90f9-8a7c-4ea7-73583ae30d69@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <27f9d554-e147-900d-bd1f-c2890f87d7f9@redhat.com>
Date:   Thu, 10 Sep 2020 10:21:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <665b9fbc-90f9-8a7c-4ea7-73583ae30d69@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 9/7/20 4:36 PM, Diana Craciun OSS wrote:
> Hi Eric,
> 
> On 9/4/2020 11:21 AM, Auger Eric wrote:
>> Hi Diana,
>>
>> On 8/26/20 11:33 AM, Diana Craciun wrote:
>>> Currently only resetting the DPRC container is supported which
>>> will reset all the objects inside it. Resetting individual
>>> objects is possible from the userspace by issueing commands
>>> towards MC firmware.
>>>
>>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>>> ---
>>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 15 ++++++++++++++-
>>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> index 27713aa86878..d17c5b3148ad 100644
>>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> @@ -310,7 +310,20 @@ static long vfio_fsl_mc_ioctl(void *device_data,
>>> unsigned int cmd,
>>>       }
>>>       case VFIO_DEVICE_RESET:
>>>       {
>>> -        return -ENOTTY;
>>> +        int ret = 0;
>> initialization not needed
>>> +
>> spare empty line
>>> +        struct fsl_mc_device *mc_dev = vdev->mc_dev;
>>> +
>>> +        /* reset is supported only for the DPRC */
>>> +        if (!is_fsl_mc_bus_dprc(mc_dev))
>>> +            return -ENOTTY;
>> it is an error case or do we just don't care?
> 
> 
> I rather don't care, but shouldn't the userspace know that the reset for
> that device failed?I don't know what makes more sense. It was more a question.

Thanks

Eric
> 
>>> +
>>> +        ret = dprc_reset_container(mc_dev->mc_io, 0,
>>> +                       mc_dev->mc_handle,
>>> +                       mc_dev->obj_desc.id,
>>> +                       DPRC_RESET_OPTION_NON_RECURSIVE);
>>> +        return ret;
>>> +
>>>       }
>>>       default:
>>>           return -ENOTTY;
>>>
>> Thanks
>>
>> Eric
>>
> 
> Thanks,
> Diana
> 

