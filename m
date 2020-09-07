Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F6A25FC33
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 16:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgIGOk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 10:40:26 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:56391
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729929AbgIGOfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 10:35:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6MaimAIThUuCxA7+T/zlUlYr5sHelixT5r1T7P7bmz9lJ9wYTt2wgfvrPnHjAaIpAwF9cjiixVu466aR9agJsVTqJU32uWwZF18RdN1HZRbrMaoB+bGtOKpM1OofhATABFwUbgVrK15tXHTDg+Ohfb2wCdGufDDqQaW1Q0wECqHm78pD+DxmdIQFWGYO3LLocMCDKxpypap0xeL2moFmHtgD7RqNQL4xr6AXHSuEKUCd1u8Do/LYm4YHrk/kYNmCIGv/uo0rVP3pdyjzMEuR+6gynGQleS5cLA/B91yH/2+J7k1tntOH8lcQYSlBcPhiLQR1DkEjB8agupdgaHxnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nY1mbqlX8icJGjayfWq4iPPE+UTdLErSbQWwLzuZZDc=;
 b=DrtoufDj8HcmYIpacJTRXOiasrnVkSHSrUWJubHZpo/OsMqZyIr4Dpccw32GVHxD/nTRZDWNsFJgU7vQjqQTRR/1n7/zfpqLWqVDXTlejhfZlWaINtL2/b9ROBc8P3b3JSOLqjw9rKwFUBbcNokd2ioJCib8k599FX36YzZOChIAPxi1cyefXRS8WYQINsVJweurSHegEjfc9ld9nAUjTa/IlMG9gNUoJ7kyH/CAkYIW6fzc+ykWKVKsYoE99a97rnk0ZUrFw/zI9QPllcn3+dy13050pyfyCqwPN8X4svj6XP5ndngMAh4lnWMFqfFkMC8VuSm9Jo4WDtxJJDmfhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nY1mbqlX8icJGjayfWq4iPPE+UTdLErSbQWwLzuZZDc=;
 b=Gz/g5hB2U8vcGGWFdERnT24eshBx9OQhF2i0VTyb/1aN3OQw0n0Qg8OKl1FG7F2FTYNPTYotC6lqy4vHjm9NwAlUhOb29kqGE87rW++BzbbSqXsFS1SFUZAqzTIU6gAB5nQjLhqgz+vEkp49Kj8+eJL59afqk8Jo3vNwicAhc1g=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 7 Sep
 2020 14:35:02 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607%9]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 14:35:02 +0000
Subject: Re: [PATCH v4 09/10] vfio/fsl-mc: Add read/write support for fsl-mc
 devices
To:     Auger Eric <eric.auger@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-10-diana.craciun@oss.nxp.com>
 <182a6686-a1ca-398b-2ccc-8a5638ffe7aa@redhat.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <f256cc69-128a-0bd3-cbab-763b18ea46a4@oss.nxp.com>
Date:   Mon, 7 Sep 2020 17:34:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <182a6686-a1ca-398b-2ccc-8a5638ffe7aa@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0142.eurprd07.prod.outlook.com
 (2603:10a6:207:8::28) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM3PR07CA0142.eurprd07.prod.outlook.com (2603:10a6:207:8::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.10 via Frontend Transport; Mon, 7 Sep 2020 14:35:01 +0000
X-Originating-IP: [188.27.189.94]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc358ba4-4945-4d5f-7055-08d8533b3472
X-MS-TrafficTypeDiagnostic: VI1PR04MB4046:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB404645E8317F3BD6E6BBA46BBE280@VI1PR04MB4046.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QZ97HLMltd6ZQ8SmAnckgyxgbcYdCBfCeNLzHRt1Gh8q7/uMQvKzDz2ZeVm4lJIXw3I95c0TN8kyfqRaDuXrJzTUtR80esnC7a/nHU/GZzVFwLRYOBPHob+SWf944tyLQhKmh/A6RayzpMAkdr2biY/Qywy9Z1hskpU0ikQR7SoJM8LyDz7h1990TGbe0JNgihB+YSxU59Z5ZmzZHZkoME+7itMIQaHlLqN8D3US6PLbrfhNEY2EKlgyZGgdZCXC+gZ1AkBGqew+lle1RwoMGC+5Bqq6NTkeiFUhHhnCN12BPPOF2y1cLbn1Ef8VoEKhCBaMukRugk+5fUJXZu6MuW57F2hS7eRscuPXnb6kN02eWvWbBY9sZQNyQMSfl5re
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(66556008)(53546011)(66476007)(26005)(8676002)(16526019)(5660300002)(66946007)(186003)(52116002)(6666004)(4326008)(956004)(478600001)(2616005)(316002)(31686004)(8936002)(86362001)(6486002)(31696002)(16576012)(2906002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wm0EKW4tojlMLFHRi7JRxqS48YGkL3iZQ/wLeNQYfuaG2FijJHAw/2kJMYUWrFAqiRZQlAZ+6USZnL1ijm8auLiK93J91rA5NAPdib2h7gpD4k6Q44a9uX5p5ZqUlkCep1ut/wO3NNCnsGB12NczNmLI69L4YqnN7uU64U9XTimBAFsXWXJpmNPQAzGM+KW86dOQqKCefNPjg0mBjJkVBU2gxAIsYKXwB5JuLYRC0QA8y+OruuKHl5cTL5eF+bTyujh+oN43pMOe3uDfEjwoObw+siSEyZO/wcumklDYuHcyyPNHuV+YevxkJ+th9W101G5Yd8LxzWR23qmqE63HJtn7enIKYqrP/mougfayJ0zX7wg3nXjPL0ezTJGcAnlljP9Ts3WHlQojn7guWG/MnUn78qNkP4DeJxZHsf5K3HTwEdhA/n+7M5tvbylaHs4reYt5jDn9yCvmQ7RcqmDLxRwn6jz08CeIBpA0N3npghoPrPq0QiAgfTpT0B+0whgL84TPlh0gY6NgbqNsBXkysH0RIHoGcEj9T0LjCUzL/aOUX9tDq5pwzT//QXDy4QWi2gdGPOTplkZLghDvo+yzNN+rXXJizKOHWGOmrOu5QWITb+kf/4f9w0CNlovye7kqVloVzDGXbFj4GzBf/UOPBg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc358ba4-4945-4d5f-7055-08d8533b3472
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 14:35:02.4194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snFxy2fil+8B92Gs1/GxpMCOALj8L9EyFE5E/x8I7w6PmjWAS1exA0f+x6FDXG/IW3D1u1sWvp1pkwLg/G435g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4046
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 9/4/2020 11:18 AM, Auger Eric wrote:
> Hi Diana,
> 
> On 8/26/20 11:33 AM, Diana Craciun wrote:
>> The software uses a memory-mapped I/O command interface (MC portals) to
>> communicate with the MC hardware. This command interface is used to
>> discover, enumerate, configure and remove DPAA2 objects. The DPAA2
>> objects use MSIs, so the command interface needs to be emulated
>> such that the correct MSI is configured in the hardware (the guest
>> has the virtual MSIs).
> What I don't get is all the regions are mmappable too.
> And this patch does not seem to introduce special handling with respect
> to MSIs. Please could you clarify?

The device can be controlled using commands issued towards a firmware. 
Most of the commands can be passthrough, among exceptions is the command 
that configures the interrupts. In a guest the interrupts are emulated 
and for the hardware the numbers in the guest mean nothing. So, in a 
virtual machine scenario, the DPMCP and DPRC regions are emulated in 
qemu such that the command which configures the interrupts will not go 
to hardware with the information set by the guest.
However there are other scenarios apart from virtual machines like DPDK 
in which the interrupt configuration command is not used. The problem 
might be that the userspace could issue the command because there is no 
restriction in the VFIO, but in that case the worst thing that may 
happen is for the interrupts for the device not to work.
However it is possible to restrict the command for this scenario as well 
if I change the code and not allow the DPRC region to be mmapable. In 
practice it proved that it might not gain much by direct assigning that 
area. Also the interrupt configuration command was restricted from the 
firmware to be issued only from the DPRC device region to help such a 
scenario.


>>
>> This patch is adding read/write support for fsl-mc devices. The mc
>> commands are emulated by the userspace. The host is just passing
>> the correct command to the hardware.
>>
>> Also the current patch limits userspace to write complete
>> 64byte command once and read 64byte response by one ioctl.
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 115 +++++++++++++++++++++-
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |   1 +
>>   2 files changed, 114 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 73834f488a94..27713aa86878 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -12,6 +12,7 @@
>>   #include <linux/types.h>
>>   #include <linux/vfio.h>
>>   #include <linux/fsl/mc.h>
>> +#include <linux/delay.h>
>>   
>>   #include "vfio_fsl_mc_private.h"
>>   
>> @@ -106,6 +107,9 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>>   		vdev->regions[i].size = resource_size(res);
>>   		vdev->regions[i].flags = VFIO_REGION_INFO_FLAG_MMAP;
>>   		vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;
>> +		vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
>> +		if (!(mc_dev->regions[i].flags & IORESOURCE_READONLY))
>> +			vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
>>   	}
>>   
>>   	vdev->num_regions = mc_dev->obj_desc.region_count;
>> @@ -114,6 +118,11 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>>   
>>   static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
>>   {
>> +	int i;
>> +
>> +	for (i = 0; i < vdev->num_regions; i++)
>> +		iounmap(vdev->regions[i].ioaddr);
>> +
>>   	vdev->num_regions = 0;
>>   	kfree(vdev->regions);
>>   }
>> @@ -311,13 +320,115 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>>   static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
>>   				size_t count, loff_t *ppos)
>>   {
>> -	return -EINVAL;
>> +	struct vfio_fsl_mc_device *vdev = device_data;
>> +	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
>> +	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
>> +	struct vfio_fsl_mc_region *region;
>> +	u64 data[8];
>> +	int i;
>> +
>> +	if (index >= vdev->num_regions)
>> +		return -EINVAL;
>> +
>> +	region = &vdev->regions[index];
>> +
>> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_READ))
>> +		return -EINVAL;
>> +
>> +	if (!region->ioaddr) {
>> +		region->ioaddr = ioremap(region->addr, region->size);
>> +		if (!region->ioaddr)
>> +			return -ENOMEM;
>> +	}
>> +
>> +	if (count != 64 || off != 0)
>> +		return -EINVAL;
>> +
>> +	for (i = 7; i >= 0; i--)
>> +		data[i] = readq(region->ioaddr + i * sizeof(uint64_t));
>> +
>> +	if (copy_to_user(buf, data, 64))
>> +		return -EFAULT;
>> +
>> +	return count;
>> +}
>> +
>> +#define MC_CMD_COMPLETION_TIMEOUT_MS    5000
>> +#define MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS    500
>> +
>> +static int vfio_fsl_mc_send_command(void __iomem *ioaddr, uint64_t *cmd_data)
>> +{
>> +	int i;
>> +	enum mc_cmd_status status;
>> +	unsigned long timeout_usecs = MC_CMD_COMPLETION_TIMEOUT_MS * 1000;
>> +
>> +	/* Write at command parameter into portal */
>> +	for (i = 7; i >= 1; i--)
>> +		writeq_relaxed(cmd_data[i], ioaddr + i * sizeof(uint64_t));
>> +
>> +	/* Write command header in the end */
>> +	writeq(cmd_data[0], ioaddr);
>> +
>> +	/* Wait for response before returning to user-space
>> +	 * This can be optimized in future to even prepare response
>> +	 * before returning to user-space and avoid read ioctl.
>> +	 */
>> +	for (;;) {
>> +		u64 header;
>> +		struct mc_cmd_header *resp_hdr;
>> +
>> +		header = cpu_to_le64(readq_relaxed(ioaddr));
>> +
>> +		resp_hdr = (struct mc_cmd_header *)&header;
>> +		status = (enum mc_cmd_status)resp_hdr->status;
>> +		if (status != MC_CMD_STATUS_READY)
>> +			break;
>> +
>> +		udelay(MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS);
>> +		timeout_usecs -= MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS;
>> +		if (timeout_usecs == 0)
>> +			return -ETIMEDOUT;
>> +	}
>> +
>> +	return 0;
>>   }
>>   
>>   static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
>>   				 size_t count, loff_t *ppos)
>>   {
>> -	return -EINVAL;
>> +	struct vfio_fsl_mc_device *vdev = device_data;
>> +	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
>> +	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
>> +	struct vfio_fsl_mc_region *region;
>> +	u64 data[8];
>> +	int ret;
>> +
>> +	if (index >= vdev->num_regions)
>> +		return -EINVAL;
>> +
>> +	region = &vdev->regions[index];
>> +
>> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE))
>> +		return -EINVAL;
>> +
>> +	if (!region->ioaddr) {
>> +		region->ioaddr = ioremap(region->addr, region->size);
>> +		if (!region->ioaddr)
>> +			return -ENOMEM;
>> +	}
>> +
>> +	if (count != 64 || off != 0)
>> +		return -EINVAL;
>> +
>> +	if (copy_from_user(&data, buf, 64))
>> +		return -EFAULT;
>> +
>> +	ret = vfio_fsl_mc_send_command(region->ioaddr, data);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return count;
>> +
>>   }
>>   
>>   static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> index bbfca8b55f8a..e6804e516c4a 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> @@ -32,6 +32,7 @@ struct vfio_fsl_mc_region {
>>   	u32			type;
>>   	u64			addr;
>>   	resource_size_t		size;
>> +	void __iomem		*ioaddr;
>>   };
>>   
>>   struct vfio_fsl_mc_device {
>>
> Thanks
> 
> Eric
> 

Thanks,
Diana
