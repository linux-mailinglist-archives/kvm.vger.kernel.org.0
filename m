Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22278264011
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 10:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgIJIds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 04:33:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730136AbgIJIUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 04:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599726023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I7g9XHSyyT6+AOBpFrPSMv8YWka9NpbJkzSJ/h44F3s=;
        b=i8yb4y6nV0sc/+VMHPukceYnnC9JEIc95V9SIEIOsJdYcxt8azXkfJD7bWcu9oFmGU741t
        Hst0TEf5SUNdZBRtnWULZFHZXw+T6MUZqIeuRg70ETSHs9qLCmfMYoF7F5oBuR0LnGaYec
        tjYpfcgsvCHQ9s3xUNTV8NKpz9wNe84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-BZVquaokNYmhETq_MzRQ9g-1; Thu, 10 Sep 2020 04:20:19 -0400
X-MC-Unique: BZVquaokNYmhETq_MzRQ9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 646D5801ABC;
        Thu, 10 Sep 2020 08:20:04 +0000 (UTC)
Received: from [10.36.112.212] (ovpn-112-212.ams2.redhat.com [10.36.112.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BD137E46E;
        Thu, 10 Sep 2020 08:20:02 +0000 (UTC)
Subject: Re: [PATCH v4 09/10] vfio/fsl-mc: Add read/write support for fsl-mc
 devices
To:     Diana Craciun OSS <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-10-diana.craciun@oss.nxp.com>
 <182a6686-a1ca-398b-2ccc-8a5638ffe7aa@redhat.com>
 <f256cc69-128a-0bd3-cbab-763b18ea46a4@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <fa27af72-5ec4-312a-aeb1-35a6db626cdd@redhat.com>
Date:   Thu, 10 Sep 2020 10:20:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <f256cc69-128a-0bd3-cbab-763b18ea46a4@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 9/7/20 4:34 PM, Diana Craciun OSS wrote:
> Hi Eric,
> 
> On 9/4/2020 11:18 AM, Auger Eric wrote:
>> Hi Diana,
>>
>> On 8/26/20 11:33 AM, Diana Craciun wrote:
>>> The software uses a memory-mapped I/O command interface (MC portals) to
>>> communicate with the MC hardware. This command interface is used to
>>> discover, enumerate, configure and remove DPAA2 objects. The DPAA2
>>> objects use MSIs, so the command interface needs to be emulated
>>> such that the correct MSI is configured in the hardware (the guest
>>> has the virtual MSIs).
>> What I don't get is all the regions are mmappable too.
>> And this patch does not seem to introduce special handling with respect
>> to MSIs. Please could you clarify?
> 
> The device can be controlled using commands issued towards a firmware.
> Most of the commands can be passthrough, among exceptions is the command
> that configures the interrupts. In a guest the interrupts are emulated
> and for the hardware the numbers in the guest mean nothing. So, in a
> virtual machine scenario, the DPMCP and DPRC regions are emulated in
> qemu such that the command which configures the interrupts will not go
> to hardware with the information set by the guest.
> However there are other scenarios apart from virtual machines like DPDK
> in which the interrupt configuration command is not used. The problem
> might be that the userspace could issue the command because there is no
> restriction in the VFIO, but in that case the worst thing that may
> happen is for the interrupts for the device not to work.
> However it is possible to restrict the command for this scenario as well
> if I change the code and not allow the DPRC region to be mmapable. In
> practice it proved that it might not gain much by direct assigning that
> area. Also the interrupt configuration command was restricted from the
> firmware to be issued only from the DPRC device region to help such a
> scenario.
Yes actually I meant that the region used to configure MSIs should not
be mmappable then?


Thanks

Eric
> 
> 
>>>
>>> This patch is adding read/write support for fsl-mc devices. The mc
>>> commands are emulated by the userspace. The host is just passing
>>> the correct command to the hardware.
>>>
>>> Also the current patch limits userspace to write complete
>>> 64byte command once and read 64byte response by one ioctl.
>>>
>>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>>> ---
>>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 115 +++++++++++++++++++++-
>>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |   1 +
>>>   2 files changed, 114 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> index 73834f488a94..27713aa86878 100644
>>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>> @@ -12,6 +12,7 @@
>>>   #include <linux/types.h>
>>>   #include <linux/vfio.h>
>>>   #include <linux/fsl/mc.h>
>>> +#include <linux/delay.h>
>>>     #include "vfio_fsl_mc_private.h"
>>>   @@ -106,6 +107,9 @@ static int vfio_fsl_mc_regions_init(struct
>>> vfio_fsl_mc_device *vdev)
>>>           vdev->regions[i].size = resource_size(res);
>>>           vdev->regions[i].flags = VFIO_REGION_INFO_FLAG_MMAP;
>>>           vdev->regions[i].type = mc_dev->regions[i].flags &
>>> IORESOURCE_BITS;
>>> +        vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
>>> +        if (!(mc_dev->regions[i].flags & IORESOURCE_READONLY))
>>> +            vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
>>>       }
>>>         vdev->num_regions = mc_dev->obj_desc.region_count;
>>> @@ -114,6 +118,11 @@ static int vfio_fsl_mc_regions_init(struct
>>> vfio_fsl_mc_device *vdev)
>>>     static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device
>>> *vdev)
>>>   {
>>> +    int i;
>>> +
>>> +    for (i = 0; i < vdev->num_regions; i++)
>>> +        iounmap(vdev->regions[i].ioaddr);
>>> +
>>>       vdev->num_regions = 0;
>>>       kfree(vdev->regions);
>>>   }
>>> @@ -311,13 +320,115 @@ static long vfio_fsl_mc_ioctl(void
>>> *device_data, unsigned int cmd,
>>>   static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
>>>                   size_t count, loff_t *ppos)
>>>   {
>>> -    return -EINVAL;
>>> +    struct vfio_fsl_mc_device *vdev = device_data;
>>> +    unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
>>> +    loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
>>> +    struct vfio_fsl_mc_region *region;
>>> +    u64 data[8];
>>> +    int i;
>>> +
>>> +    if (index >= vdev->num_regions)
>>> +        return -EINVAL;
>>> +
>>> +    region = &vdev->regions[index];
>>> +
>>> +    if (!(region->flags & VFIO_REGION_INFO_FLAG_READ))
>>> +        return -EINVAL;
>>> +
>>> +    if (!region->ioaddr) {
>>> +        region->ioaddr = ioremap(region->addr, region->size);
>>> +        if (!region->ioaddr)
>>> +            return -ENOMEM;
>>> +    }
>>> +
>>> +    if (count != 64 || off != 0)
>>> +        return -EINVAL;
>>> +
>>> +    for (i = 7; i >= 0; i--)
>>> +        data[i] = readq(region->ioaddr + i * sizeof(uint64_t));
>>> +
>>> +    if (copy_to_user(buf, data, 64))
>>> +        return -EFAULT;
>>> +
>>> +    return count;
>>> +}
>>> +
>>> +#define MC_CMD_COMPLETION_TIMEOUT_MS    5000
>>> +#define MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS    500
>>> +
>>> +static int vfio_fsl_mc_send_command(void __iomem *ioaddr, uint64_t
>>> *cmd_data)
>>> +{
>>> +    int i;
>>> +    enum mc_cmd_status status;
>>> +    unsigned long timeout_usecs = MC_CMD_COMPLETION_TIMEOUT_MS * 1000;
>>> +
>>> +    /* Write at command parameter into portal */
>>> +    for (i = 7; i >= 1; i--)
>>> +        writeq_relaxed(cmd_data[i], ioaddr + i * sizeof(uint64_t));
>>> +
>>> +    /* Write command header in the end */
>>> +    writeq(cmd_data[0], ioaddr);
>>> +
>>> +    /* Wait for response before returning to user-space
>>> +     * This can be optimized in future to even prepare response
>>> +     * before returning to user-space and avoid read ioctl.
>>> +     */
>>> +    for (;;) {
>>> +        u64 header;
>>> +        struct mc_cmd_header *resp_hdr;
>>> +
>>> +        header = cpu_to_le64(readq_relaxed(ioaddr));
>>> +
>>> +        resp_hdr = (struct mc_cmd_header *)&header;
>>> +        status = (enum mc_cmd_status)resp_hdr->status;
>>> +        if (status != MC_CMD_STATUS_READY)
>>> +            break;
>>> +
>>> +        udelay(MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS);
>>> +        timeout_usecs -= MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS;
>>> +        if (timeout_usecs == 0)
>>> +            return -ETIMEDOUT;
>>> +    }
>>> +
>>> +    return 0;
>>>   }
>>>     static ssize_t vfio_fsl_mc_write(void *device_data, const char
>>> __user *buf,
>>>                    size_t count, loff_t *ppos)
>>>   {
>>> -    return -EINVAL;
>>> +    struct vfio_fsl_mc_device *vdev = device_data;
>>> +    unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
>>> +    loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
>>> +    struct vfio_fsl_mc_region *region;
>>> +    u64 data[8];
>>> +    int ret;
>>> +
>>> +    if (index >= vdev->num_regions)
>>> +        return -EINVAL;
>>> +
>>> +    region = &vdev->regions[index];
>>> +
>>> +    if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE))
>>> +        return -EINVAL;
>>> +
>>> +    if (!region->ioaddr) {
>>> +        region->ioaddr = ioremap(region->addr, region->size);
>>> +        if (!region->ioaddr)
>>> +            return -ENOMEM;
>>> +    }
>>> +
>>> +    if (count != 64 || off != 0)
>>> +        return -EINVAL;
>>> +
>>> +    if (copy_from_user(&data, buf, 64))
>>> +        return -EFAULT;
>>> +
>>> +    ret = vfio_fsl_mc_send_command(region->ioaddr, data);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    return count;
>>> +
>>>   }
>>>     static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
>>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>>> b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>>> index bbfca8b55f8a..e6804e516c4a 100644
>>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>>> @@ -32,6 +32,7 @@ struct vfio_fsl_mc_region {
>>>       u32            type;
>>>       u64            addr;
>>>       resource_size_t        size;
>>> +    void __iomem        *ioaddr;
>>>   };
>>>     struct vfio_fsl_mc_device {
>>>
>> Thanks
>>
>> Eric
>>
> 
> Thanks,
> Diana
> 

