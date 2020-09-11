Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D94265C48
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 11:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgIKJPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 05:15:48 -0400
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:38720
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725613AbgIKJPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 05:15:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEGDtxkTyEJ/IqcC15rtg2+fj77lVRR0a1IUzimg/0uOdn/COa+YaQSvKcDWJlVT6l1NeGE65THe7LscwtsdV6VYEsp6ceJ8/7+ZcRrXLjMcadcAitghBpMmW9/lcCzlMqwT+xYMQA3a7Z0UpOJk90nfAryVh+SnlfuBDuuA+exZqBQ/i9z1+T1D2pg7cZDeVsxV2PGSTBapq6y3b+h0DsEERM2SzsKAd2S1nmdKax5V7O9xOkE2kCZXcd8lRtgMpDaPp4TRJupp8oIVAvakvOD8jFHGmqgBmmahgxoblJZ/zBZ3sKWwgoQW95t/WBhg7sODGxoJAo0jnmrqK1PwNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWR8CT6Tt75bLGdjrr6pTrmJ+S3Di1I0JHNdwbSJr58=;
 b=Zqj11rNiA8qgfHW2zzM8QFE9cLzCgfBCVq+7QPoK4U51mhB+ofZew5wtz8KuzgKeVlZM9lQ/F1FC7mNsu90rQi8+U9PzpoheywH5Dpv2kXsUm0hy1s/qPqw6K6l2o+v5v4FYp4c0ZE113wWd8+DOKHYCpnRQFy20vwxVsg3HBitOqIF6wcs30nOnChIP0VzjZ4e7xh6VMI81hw9t8kna4m7mBXg6rpOLaQU6PL1+yy7LnnE4+hHJGD11EwebP7xNz5l1YgYJY64hSCwdwLmUbBq1xwgortiDU6y5e5SjKthlxE1BtCz/RyvoJhuUF/Xdo5O+YHBpjSNT7gEY9pz3gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWR8CT6Tt75bLGdjrr6pTrmJ+S3Di1I0JHNdwbSJr58=;
 b=eskunWU1UTVXEbfYr3P+b7jdZfAyNHAWRt0TWBb0n2TYof7bZBB/wevn7F2WtIhUCKnUu1he5Pnm+ZnCeEMqtO4VpX3AhbCBlHGeaxFc06F+Fv1m+zVIqWDlNNoYIOoiQfrnpFlT0OBhvgW/9BPp0DeDaU00EwkQ3L8lF8+v4LM=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR04MB6112.eurprd04.prod.outlook.com
 (2603:10a6:803:fd::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 09:15:35 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607%9]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 09:15:35 +0000
Subject: Re: [PATCH v4 09/10] vfio/fsl-mc: Add read/write support for fsl-mc
 devices
To:     Auger Eric <eric.auger@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-10-diana.craciun@oss.nxp.com>
 <182a6686-a1ca-398b-2ccc-8a5638ffe7aa@redhat.com>
 <f256cc69-128a-0bd3-cbab-763b18ea46a4@oss.nxp.com>
 <fa27af72-5ec4-312a-aeb1-35a6db626cdd@redhat.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <c1c33788-67d0-134c-fd74-43c2726ecb64@oss.nxp.com>
Date:   Fri, 11 Sep 2020 12:15:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <fa27af72-5ec4-312a-aeb1-35a6db626cdd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0202CA0024.eurprd02.prod.outlook.com
 (2603:10a6:200:89::34) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM4PR0202CA0024.eurprd02.prod.outlook.com (2603:10a6:200:89::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 09:15:34 +0000
X-Originating-IP: [188.27.189.94]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53dd6af9-40e8-4a71-acb8-08d856333d77
X-MS-TrafficTypeDiagnostic: VI1PR04MB6112:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6112F7ACED37131209909A0FBE240@VI1PR04MB6112.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vyNTkmEVv7r9KIWhenwfr9AUe55r4qtKGHpFLTYYmgvZCepmZt0w9PQ86yPyvAdu0sfF99RezX6kWPFyscPQQcULkKBDqPGhkrEU740+ozZYjXTjsAG/S7/dcuzIsDpUPSPNK9uoceHbxCPikuLfOE0HhNUo8eROytymCXnP5/GXUBV855ulCUQmxKqBl6zeraBoHNbl1f8lwnMyW3+4JeBWZ92Bqizk1diEmxMptqMoWNtmycLtNkAzwFF7mX6c2OhoSIcRcpRj4d8Ux0qrswuG6KrxgyThESpH2LzS9MnHOaIcajQIo1GAwujhqdTpa5SI/S92pVyRVRoNhJLuldrxllurkmwxGXMPvXqIUpi+0irxxCXSm0HNFiJ1S8nK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(4326008)(316002)(2906002)(52116002)(26005)(5660300002)(2616005)(956004)(53546011)(8676002)(16576012)(83380400001)(31696002)(478600001)(6486002)(31686004)(86362001)(8936002)(6666004)(66556008)(66946007)(66476007)(186003)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nvL9oAvhXWAal5cXuxAkWROTFwhCDfDIoza7Rk1KE2OSGbV8eWgbRJDbNT25zgSIiQ6SbAQgERlADraAhT+PVYjdAT8t2xwHmUPn2uzjWL+gTphX4yIy9Xp6df1J7WZAVOuJByo2es0RrVAwrC54h6d7tIRZkIS94BmddDaak7Gbw+8Zun3t1BUE5VDgZNWBeXVgzGURw3cqISjQOSLWGsXOaOoiIJAJVgt0RAkpYOZjaoF1Sv7vsM5ZVu2FXplhUuqkouzF41tWMVKjoH4j6qSDoy47yVEi58F1KFW/ftZoJdqZX7L03NWYX+skxkoeq2cSHgmLQpgoa0MJXACvTmVD/QlIpkYCBanUtOTEmbdAe0kPViD2Yu00O8RocC4r46ueBeVmTkIYWL+8BXwyxrPec88M1FKYessTJp+/5Gklbv2sUUwDz181r7knOfAbww7nzxzuPt5G1Y6klAwSVGkb1/hnW8I8tVSmUhxX3KdBFqQZsRttp/nnWo2G4aNWN4+DxjI6sqPWKh35HLlNJahx11oq5UPmxEpb0fkeQLiJw2RGfiOzeSeroRZe8W7aDUYniE1VB222n8Q/fcTRwbqbtI1y1qyBQ3lNi1nW/TS/iYWe//5DNd9/1iLSG3x/fLso6VU9XCx+NLFJKW6Xmw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53dd6af9-40e8-4a71-acb8-08d856333d77
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 09:15:35.0377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4s016Bgjeuw/4zskaA/fBy+2SZWPy0f/uaQH38Z1MlYb9yL5ju6JEk8aclbYQkUAYINfeVlaR9gBarIzN6xd7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 9/10/2020 11:20 AM, Auger Eric wrote:
> Hi Diana,
> 
> On 9/7/20 4:34 PM, Diana Craciun OSS wrote:
>> Hi Eric,
>>
>> On 9/4/2020 11:18 AM, Auger Eric wrote:
>>> Hi Diana,
>>>
>>> On 8/26/20 11:33 AM, Diana Craciun wrote:
>>>> The software uses a memory-mapped I/O command interface (MC portals) to
>>>> communicate with the MC hardware. This command interface is used to
>>>> discover, enumerate, configure and remove DPAA2 objects. The DPAA2
>>>> objects use MSIs, so the command interface needs to be emulated
>>>> such that the correct MSI is configured in the hardware (the guest
>>>> has the virtual MSIs).
>>> What I don't get is all the regions are mmappable too.
>>> And this patch does not seem to introduce special handling with respect
>>> to MSIs. Please could you clarify?
>>
>> The device can be controlled using commands issued towards a firmware.
>> Most of the commands can be passthrough, among exceptions is the command
>> that configures the interrupts. In a guest the interrupts are emulated
>> and for the hardware the numbers in the guest mean nothing. So, in a
>> virtual machine scenario, the DPMCP and DPRC regions are emulated in
>> qemu such that the command which configures the interrupts will not go
>> to hardware with the information set by the guest.
>> However there are other scenarios apart from virtual machines like DPDK
>> in which the interrupt configuration command is not used. The problem
>> might be that the userspace could issue the command because there is no
>> restriction in the VFIO, but in that case the worst thing that may
>> happen is for the interrupts for the device not to work.
>> However it is possible to restrict the command for this scenario as well
>> if I change the code and not allow the DPRC region to be mmapable. In
>> practice it proved that it might not gain much by direct assigning that
>> area. Also the interrupt configuration command was restricted from the
>> firmware to be issued only from the DPRC device region to help such a
>> scenario.
> Yes actually I meant that the region used to configure MSIs should not
> be mmappable then?
> 
> 

That region is not used only for the MSI configuration. The way it works 
is through commands that are written at a certain memory address. And 
the commands can be different. Applications like DPDK do not use the 
command to configure interrupts, so that is the reason that the region 
is mmapable. But at a second thought, I think that I can restrict the 
DPRC region not to be mmapable. And that is the only region that can be 
used to configure interrupts.

Thanks,

Diana

> Thanks
> 
> Eric
>>
>>
>>>>
>>>> This patch is adding read/write support for fsl-mc devices. The mc
>>>> commands are emulated by the userspace. The host is just passing
>>>> the correct command to the hardware.
>>>>
>>>> Also the current patch limits userspace to write complete
>>>> 64byte command once and read 64byte response by one ioctl.
>>>>
>>>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>>>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>>>> ---
>>>>    drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 115 +++++++++++++++++++++-
>>>>    drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |   1 +
>>>>    2 files changed, 114 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>>> b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>>> index 73834f488a94..27713aa86878 100644
>>>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>>> @@ -12,6 +12,7 @@
>>>>    #include <linux/types.h>
>>>>    #include <linux/vfio.h>
>>>>    #include <linux/fsl/mc.h>
>>>> +#include <linux/delay.h>
>>>>      #include "vfio_fsl_mc_private.h"
>>>>    @@ -106,6 +107,9 @@ static int vfio_fsl_mc_regions_init(struct
>>>> vfio_fsl_mc_device *vdev)
>>>>            vdev->regions[i].size = resource_size(res);
>>>>            vdev->regions[i].flags = VFIO_REGION_INFO_FLAG_MMAP;
>>>>            vdev->regions[i].type = mc_dev->regions[i].flags &
>>>> IORESOURCE_BITS;
>>>> +        vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
>>>> +        if (!(mc_dev->regions[i].flags & IORESOURCE_READONLY))
>>>> +            vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
>>>>        }
>>>>          vdev->num_regions = mc_dev->obj_desc.region_count;
>>>> @@ -114,6 +118,11 @@ static int vfio_fsl_mc_regions_init(struct
>>>> vfio_fsl_mc_device *vdev)
>>>>      static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device
>>>> *vdev)
>>>>    {
>>>> +    int i;
>>>> +
>>>> +    for (i = 0; i < vdev->num_regions; i++)
>>>> +        iounmap(vdev->regions[i].ioaddr);
>>>> +
>>>>        vdev->num_regions = 0;
>>>>        kfree(vdev->regions);
>>>>    }
>>>> @@ -311,13 +320,115 @@ static long vfio_fsl_mc_ioctl(void
>>>> *device_data, unsigned int cmd,
>>>>    static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
>>>>                    size_t count, loff_t *ppos)
>>>>    {
>>>> -    return -EINVAL;
>>>> +    struct vfio_fsl_mc_device *vdev = device_data;
>>>> +    unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
>>>> +    loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
>>>> +    struct vfio_fsl_mc_region *region;
>>>> +    u64 data[8];
>>>> +    int i;
>>>> +
>>>> +    if (index >= vdev->num_regions)
>>>> +        return -EINVAL;
>>>> +
>>>> +    region = &vdev->regions[index];
>>>> +
>>>> +    if (!(region->flags & VFIO_REGION_INFO_FLAG_READ))
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (!region->ioaddr) {
>>>> +        region->ioaddr = ioremap(region->addr, region->size);
>>>> +        if (!region->ioaddr)
>>>> +            return -ENOMEM;
>>>> +    }
>>>> +
>>>> +    if (count != 64 || off != 0)
>>>> +        return -EINVAL;
>>>> +
>>>> +    for (i = 7; i >= 0; i--)
>>>> +        data[i] = readq(region->ioaddr + i * sizeof(uint64_t));
>>>> +
>>>> +    if (copy_to_user(buf, data, 64))
>>>> +        return -EFAULT;
>>>> +
>>>> +    return count;
>>>> +}
>>>> +
>>>> +#define MC_CMD_COMPLETION_TIMEOUT_MS    5000
>>>> +#define MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS    500
>>>> +
>>>> +static int vfio_fsl_mc_send_command(void __iomem *ioaddr, uint64_t
>>>> *cmd_data)
>>>> +{
>>>> +    int i;
>>>> +    enum mc_cmd_status status;
>>>> +    unsigned long timeout_usecs = MC_CMD_COMPLETION_TIMEOUT_MS * 1000;
>>>> +
>>>> +    /* Write at command parameter into portal */
>>>> +    for (i = 7; i >= 1; i--)
>>>> +        writeq_relaxed(cmd_data[i], ioaddr + i * sizeof(uint64_t));
>>>> +
>>>> +    /* Write command header in the end */
>>>> +    writeq(cmd_data[0], ioaddr);
>>>> +
>>>> +    /* Wait for response before returning to user-space
>>>> +     * This can be optimized in future to even prepare response
>>>> +     * before returning to user-space and avoid read ioctl.
>>>> +     */
>>>> +    for (;;) {
>>>> +        u64 header;
>>>> +        struct mc_cmd_header *resp_hdr;
>>>> +
>>>> +        header = cpu_to_le64(readq_relaxed(ioaddr));
>>>> +
>>>> +        resp_hdr = (struct mc_cmd_header *)&header;
>>>> +        status = (enum mc_cmd_status)resp_hdr->status;
>>>> +        if (status != MC_CMD_STATUS_READY)
>>>> +            break;
>>>> +
>>>> +        udelay(MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS);
>>>> +        timeout_usecs -= MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS;
>>>> +        if (timeout_usecs == 0)
>>>> +            return -ETIMEDOUT;
>>>> +    }
>>>> +
>>>> +    return 0;
>>>>    }
>>>>      static ssize_t vfio_fsl_mc_write(void *device_data, const char
>>>> __user *buf,
>>>>                     size_t count, loff_t *ppos)
>>>>    {
>>>> -    return -EINVAL;
>>>> +    struct vfio_fsl_mc_device *vdev = device_data;
>>>> +    unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
>>>> +    loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
>>>> +    struct vfio_fsl_mc_region *region;
>>>> +    u64 data[8];
>>>> +    int ret;
>>>> +
>>>> +    if (index >= vdev->num_regions)
>>>> +        return -EINVAL;
>>>> +
>>>> +    region = &vdev->regions[index];
>>>> +
>>>> +    if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE))
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (!region->ioaddr) {
>>>> +        region->ioaddr = ioremap(region->addr, region->size);
>>>> +        if (!region->ioaddr)
>>>> +            return -ENOMEM;
>>>> +    }
>>>> +
>>>> +    if (count != 64 || off != 0)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (copy_from_user(&data, buf, 64))
>>>> +        return -EFAULT;
>>>> +
>>>> +    ret = vfio_fsl_mc_send_command(region->ioaddr, data);
>>>> +    if (ret)
>>>> +        return ret;
>>>> +
>>>> +    return count;
>>>> +
>>>>    }
>>>>      static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
>>>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>>>> b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>>>> index bbfca8b55f8a..e6804e516c4a 100644
>>>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>>>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>>>> @@ -32,6 +32,7 @@ struct vfio_fsl_mc_region {
>>>>        u32            type;
>>>>        u64            addr;
>>>>        resource_size_t        size;
>>>> +    void __iomem        *ioaddr;
>>>>    };
>>>>      struct vfio_fsl_mc_device {
>>>>
>>> Thanks
>>>
>>> Eric
>>>
>>
>> Thanks,
>> Diana
>>
> 

