Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499B8283D4A
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgJERaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 13:30:10 -0400
Received: from mail-vi1eur05on2049.outbound.protection.outlook.com ([40.107.21.49]:25600
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbgJERaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 13:30:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwqZ2qcI23cE1HgYTEczS4/dqAdTgxkYV6Yav2+7hssx615NQekx4QvhQmE6ZdK+limKyQAQGpBcQmxngoCHRufQ7kg9sJ6h+CikdmmgjV2AuEqYxFsYRvG0Y9ZW46zG92+UDW9TVF50aXZwWbP4/Xnv++1qKIAUYuD2vg3Thby1zbcctePPLLHspvIq4PzVMZJAWXs34h6nCIs+Iw66ljKVLMMq+g2GNIxIUqkseYlTiV4YhA8cP5hjStCEtM1UJ26JTgDQCIntyyTKyZeF6HBlSwgKo18fXe872XP6FCgyce0Dx3opy6p8L6z953Gh3+MGREe/2zkqY1bS4dizKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8ClXaQcaZ821aPcYn/6COAqqY+zd0ERVKwfVfM0328=;
 b=SlgzbpDs2IjUfSE0rCaEez44xYntLdEF7Su8BoYcqtSha7tb83y/yk04/XnzydM+6oxWjf0Omycc5xxTiCNcqLGk6XxPL/Y5g6cm+OrXdsWnDA6RGgzXf2P1LW5mCJOzo88XNaMb4+F4yogbWV017lw51rGiAI8b5y0GKHQdYIz1zJkgvsYnCeYsNdgcBB3mMbmsqrmN7zWKdFEtEOEkE1cO7aljUQJdCTcSICpC4AuJq6fGscUIJ0Z7lWC3E1Ty5JG5vDip1sqgHpws2n69vpafoI7z00PgkYRXlJgJinlSGgQiPDz0sAW27ofjDf548bPGjGKRjByMwFTLLoZBLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8ClXaQcaZ821aPcYn/6COAqqY+zd0ERVKwfVfM0328=;
 b=I7B5HHiaX5Wd/Yeb7DEcjbFyBo9kZzpASbiZYikSrvx71MWv3Reys4d4XNTmmmFUXi3BoTRW9kbB8/i2yzBJF/nNEyC+Wy1G9RlZBYquROnr1MW6wZAK8++u0OxCl9KKoFmqA7CWjQ46jrDUF/2+bAwxrI0WmZ4jz1mu3nfw7es=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR04MB6141.eurprd04.prod.outlook.com
 (2603:10a6:803:f9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Mon, 5 Oct
 2020 17:30:05 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f%11]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 17:30:05 +0000
Subject: Re: [PATCH v5 09/10] vfio/fsl-mc: Add read/write support for fsl-mc
 devices
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, bharatb.linux@gmail.com,
        linux-kernel@vger.kernel.org, eric.auger@redhat.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
 <20200929090339.17659-10-diana.craciun@oss.nxp.com>
 <20201002145043.3d663f92@x1.home>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <06b5721c-71d6-739f-94d2-7a22c40421f2@oss.nxp.com>
Date:   Mon, 5 Oct 2020 20:29:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
In-Reply-To: <20201002145043.3d663f92@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.27.189.94]
X-ClientProxiedBy: AM3PR04CA0133.eurprd04.prod.outlook.com (2603:10a6:207::17)
 To VI1PR0402MB2815.eurprd04.prod.outlook.com (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM3PR04CA0133.eurprd04.prod.outlook.com (2603:10a6:207::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Mon, 5 Oct 2020 17:30:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 910a47f5-d008-413d-74e0-08d869544c7b
X-MS-TrafficTypeDiagnostic: VI1PR04MB6141:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB61419E5D6F18F08C0A2DD40EBE0C0@VI1PR04MB6141.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHicpfakDTLXq5U9GCe4Izg1eMHKXsvamDnNxrF9pP0B1XNGFdy3JRWb1C+2H+0dABHxNigGQgwOspA4NoYTwMOu/rK2Ks4MEXOzvgzWVTPoEZKqMHVBrPUuDfipL82I2BOI8dx3cGL6IX/uYwXsPxiJKTYjaelbG1S9vf27+A0PA0Gg7TjeFbkEg4mpFyLsLzhpFnghr7wlb7ljmVQCrusWzHoFCWOlL0Mi+fSMkBUkYQXE65ISY3rG5SBs84zP+CcKoqBQ5B+Z9KgUmV3vTTWJIWBgoUJ6PL4WAWHXqliVJL7SZfIo+w5Zs6PTmJmB+RFgvEkgikgLXw/LiEbouRXsClYtTrRtJD5eMsTGXoP70WHZZZ7hz1WShr9nud+4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(66476007)(66556008)(5660300002)(16576012)(6666004)(2616005)(186003)(26005)(16526019)(53546011)(316002)(956004)(83380400001)(52116002)(66946007)(478600001)(2906002)(8676002)(6916009)(4326008)(86362001)(31696002)(6486002)(31686004)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EmtMgNTb9YfJwkLgb38RTTHnDkxkC/K7/AR/wrB7ubpnNUmRzGhVSuy0Wo3JbJEOOy1wrQFxTEThfj6Rzu81T6EHphsiuIR+gW9pf1RChbHHNl4+ImvDkugY6hJYwpNmUb2oBcGsW5mEluDBL6hJaXDlPfR11bB6odMis6/9xzAR4yjcy0p7PCgHWP86jFS6b0fg0cpGGOaxNlU1EG6p3fhYJd8z/WQcZizV44qtHKkfL5doKTpyqEsu+jXqRSbdBWM4Y8IPyrvpSTm97ZYqjiO1mh1WG620nGi+UIpbsuNImtBel/BVlSMqo7II49TlJyPHurymULkparHmt40Ydl71y/5r+a9nXn+BmrSpXMq/c89I1e2FQYMPSmPfgK/N7TgihpiCHdO6zuoZ0f5vTE23LRC1O49GGX0KCL0Z/Vo3aA0HgIc8TnBz5kANJ1oHjs3pP6iUAUMw1IE5DMiybPjxFM15MeWHC2T6IMt8WoLtiJRzjBVXo+qRSBjWHNs21Im0QohZ58wqPK0QzcSVXp42pTpSrLb2SlVvUjDUVRWA7dRX5rMWQ/0y8y8v94k7TqbGBFgdoZyT9vBji0zJK663FC3QSy9MswaZAHlwfbETaSrwCuTkUqNclPxYL52F/5Yoi4tRytvtqDLa6EXnSw==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910a47f5-d008-413d-74e0-08d869544c7b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 17:30:05.6732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EcH3ELbPthDZLAAwboGmT9SYDwV8KwEkQVYm7nw8jKr8MkS5LNiXi/46j6KCluVzAoKMtYuAxRWmZg3BZODrOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6141
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/2020 11:50 PM, Alex Williamson wrote:
> On Tue, 29 Sep 2020 12:03:38 +0300
> Diana Craciun <diana.craciun@oss.nxp.com> wrote:
> 
>> The software uses a memory-mapped I/O command interface (MC portals) to
>> communicate with the MC hardware. This command interface is used to
>> discover, enumerate, configure and remove DPAA2 objects. The DPAA2
>> objects use MSIs, so the command interface needs to be emulated
>> such that the correct MSI is configured in the hardware (the guest
>> has the virtual MSIs).
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
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 118 +++++++++++++++++++++-
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |   1 +
>>   2 files changed, 116 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 82157837f37a..0aff99cdf722 100644
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
>> @@ -115,7 +116,9 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>>   				!(vdev->regions[i].size & ~PAGE_MASK))
>>   			vdev->regions[i].flags |=
>>   					VFIO_REGION_INFO_FLAG_MMAP;
>> -
>> +		vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
>> +		if (!(mc_dev->regions[i].flags & IORESOURCE_READONLY))
>> +			vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
>>   	}
>>   
>>   	return 0;
>> @@ -123,6 +126,11 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>>   
>>   static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
>>   {
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	int i;
>> +
>> +	for (i = 0; i < mc_dev->obj_desc.region_count; i++)
>> +		iounmap(vdev->regions[i].ioaddr);
>>   	kfree(vdev->regions);
>>   }
>>   
>> @@ -301,13 +309,117 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>>   static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
>>   				size_t count, loff_t *ppos)
>>   {
>> -	return -EINVAL;
>> +	struct vfio_fsl_mc_device *vdev = device_data;
>> +	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
>> +	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	struct vfio_fsl_mc_region *region;
>> +	u64 data[8];
>> +	int i;
>> +
>> +	if (index >= mc_dev->obj_desc.region_count)
>> +		return -EINVAL;
>> +
>> +	region = &vdev->regions[index];
>> +
>> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_READ))
>> +		return -EINVAL;
> 
> Nit, there are no regions w/o read access according to the regions_init
> code above.  Maybe this is just for symmetry with write?  Keep it if
> you prefer.  Thanks,

I would prefer to keep it like this for symmetry with write.

Thanks,
Diana

> 
> Alex
> 
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
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	struct vfio_fsl_mc_region *region;
>> +	u64 data[8];
>> +	int ret;
>> +
>> +	if (index >= mc_dev->obj_desc.region_count)
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
>> index 7aa49b9ba60d..a97ee691ed47 100644
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
> 

