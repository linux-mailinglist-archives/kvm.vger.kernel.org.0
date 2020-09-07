Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0C426033F
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731285AbgIGRqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:46:30 -0400
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:34478
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729336AbgIGNKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:10:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGfdZPct9XXmIpa174rn8sLLv2R4sIUZg4ObCK+J4+mfwHMuSi/NF5DLCiCBgRBv4TuyVZ9+wn7wS3S++4mSvOzM34GmDXaT68z4PWVULaa4xRzT3ZoKc2XzQuoakpf7tgAPe8CBdCF0qnJIeK0hWpvm9G0o89pjCphr07Z+owH5tYR8gCIilCWdS9erbY7cVQZuuyhsToihjLEdvSaWop20SR11GhozzfyXvkuWJi4TnPvJZ6s7p40JFQLPORpFFjz4iNxauFbbnYJ+rNV4m9SznoI7vz/zi/31U0AxpxNgFvmYKoyz9SWQFSAwIc10LDwuXwnyj8x1AzQyH7gGRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XKWjgJZTJZGvhnNQ9afqQjolLYYjpOoaukTjb0Mi9M=;
 b=HaIPgh26JOnjyYJM+zkb8l2rGxCN/kiU32bmM71Zg508RfsIG4t9AJmw59Ow+qJM+5tis9IxRd7oGmh1N16hWMwng1k2wP53QAJ1jIRx6nD+mXdpMfzzRrVksHDwpT4oVVxST4ziV+RWpzUkV/SGDl6I57dDzmapj/U9zc4MTw4raVRn5l2Be0ZspklA9JDhr4sWa/beAWs0yaOErFJAOrM5ObAViCeKFLiJW/sXCEx4eJlRkEnGsIVodnrD2sPaEn8KxBecg89AwEKYkAKLsRnVdOXc80eS+mdkC1tdao8hzeFVXt7DCu4VPcfh1ztRIab5laNRuJBju6hUjGnYBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XKWjgJZTJZGvhnNQ9afqQjolLYYjpOoaukTjb0Mi9M=;
 b=a4kJCHxrQX7qapgk5MUYkBKWPihfmPI6JbANVvXtIyMreMeHBBLKpxyOY//UDdcTUoLryQfkrX1si7wsamHat/4hzh2jy9jv0gntoB0tB6zxofr0eRc/dk4TiAtZt2CWQSnUOQXQ+/+U5Gizw0ijBa5UjVTJ14vzDQRPalB9Ug8=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR04MB7181.eurprd04.prod.outlook.com
 (2603:10a6:800:12a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 13:09:56 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607%9]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 13:09:56 +0000
Subject: Re: [PATCH v4 07/10] vfio/fsl-mc: Add irq infrastructure for fsl-mc
 devices
To:     Auger Eric <eric.auger@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-8-diana.craciun@oss.nxp.com>
 <9dacbfc8-32a6-54c9-ce0c-50538ee588bf@redhat.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <a98038d7-1a37-94b6-e6e5-51ca7b68a904@oss.nxp.com>
Date:   Mon, 7 Sep 2020 16:09:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <9dacbfc8-32a6-54c9-ce0c-50538ee588bf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0112.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::17) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM0PR01CA0112.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Mon, 7 Sep 2020 13:09:55 +0000
X-Originating-IP: [188.27.189.94]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 11e6e257-c198-4e38-3321-08d8532f50e5
X-MS-TrafficTypeDiagnostic: VI1PR04MB7181:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB718122AFBE7240CD3B78DE4CBE280@VI1PR04MB7181.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iwMI61N59+DXhKREU+l5huCt+ZjPrOX4b1c1kKn7smgLsOA6yp0mh22A2/qTlrxL1aFdTHTEK1TM2Wrw4tU/ilFM2CHug5IL6rcwJOaRtIUlaeMDEg21SoyN/N+pd78Fn+aaZit7Ki0OVSdqEUCPR26l55qV3V9N8Jc+Az5sFZAXbAdJFZV+1V3oKsKv8n4aTkIcv9Yu1Fzg9noiWNoG8xKTloLkDEL8HiYndULnu/7yw8SdX7dSMWVlTDW07jRnKjt+qlL47GBhXONHLTf27U/LgFnannKEXrmvmVi5C9/zXY3sD0cQ+rdhiaExu4ZFkkewLSniKvjOFmEeF6GLzkJpBtJdDcDgoTYj7/K+W+5spezWwsHuHWe8tzpEEC6Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(86362001)(66556008)(66946007)(66476007)(5660300002)(16576012)(8676002)(2616005)(4326008)(31696002)(316002)(6486002)(956004)(53546011)(16526019)(26005)(186003)(8936002)(6666004)(478600001)(52116002)(31686004)(83380400001)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z0Njcg+ixThwwf2tB+Zhfpr3cuB323Q6GKpGipRsgPQFy3f8/DJfaGT4nOqvX8bhknA+PcAXRHjVxR26WJyzw1/e+Nwe27f6eA6jniCgTm52a++d35BY6QryYynp2fp2FDBKOMQR/SNFyQCmmwatJ5BfSteyCyUqOp5o8lvsZuUSvh50kkeuumaZ0vM254N8K5YBQssoq5jUa9KruCheqEibf6zh/AsoZAvwq+BUQ31Gbk4S2+kJVEc1NrymYSpT5PfOxTgd/Au29UDS1+OO6gp03vrisrEhy3hrXhNXIoCLwy+g41GSHajEqDsT1ePx6H4iLUkB9EphgRTsW4peRr1yJiRtobw7X163zFRmEzSzUYjWG5X1kgix1tuMhwcwrLc0zWNap4UOUFcX9PVBxzQtDGwepghm0FPSWsZp4+h2l7DUfYi1f0Y4N9pOPSbpHKX5J50VFLWiJJ99JycE9PXR1b/arH/8f3tCAAUcaUVtAYyeqx95TeFJdaXi1FwtWoTmi+2WgrETvCDJ3XG5PL+YKOXqjouVTObQeHxdeSD+QGnQfrS3wD/3fFEoEXAE1yRV5L0LwFXI4zLf9Z/V5kNnEAUVoDlIVT6zgX4q1j5eZwCxx2EGDsZuRDbIx35FyO+0RDLyxe9bER7f+90xvw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e6e257-c198-4e38-3321-08d8532f50e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 13:09:56.2769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqYO7hlrwmt5yB/jxtpz+r9M1ZWkVgP0hvZJ8KJIPmR79WPHHYcNkJYdtA/gQq8FuSv6KOYtNt+hzvvjIe/8QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 9/3/2020 11:15 PM, Auger Eric wrote:
> Hi Diana,
> 
> On 8/26/20 11:33 AM, Diana Craciun wrote:
>> This patch adds the skeleton for interrupt support
>> for fsl-mc devices. The interrupts are not yet functional,
>> the functionality will be added by subsequent patches.
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   drivers/vfio/fsl-mc/Makefile              |  2 +-
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 75 ++++++++++++++++++++++-
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 63 +++++++++++++++++++
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  7 ++-
>>   4 files changed, 143 insertions(+), 4 deletions(-)
>>   create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
>>
>> diff --git a/drivers/vfio/fsl-mc/Makefile b/drivers/vfio/fsl-mc/Makefile
>> index 0c6e5d2ddaae..cad6dbf0b735 100644
>> --- a/drivers/vfio/fsl-mc/Makefile
>> +++ b/drivers/vfio/fsl-mc/Makefile
>> @@ -1,4 +1,4 @@
>>   # SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>>   
>> -vfio-fsl-mc-y := vfio_fsl_mc.o
>> +vfio-fsl-mc-y := vfio_fsl_mc.o vfio_fsl_mc_intr.o
>>   obj-$(CONFIG_VFIO_FSL_MC) += vfio-fsl-mc.o
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index bbd3365e877e..42014297b484 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -209,11 +209,79 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>>   	}
>>   	case VFIO_DEVICE_GET_IRQ_INFO:
>>   	{
>> -		return -ENOTTY;
>> +		struct vfio_irq_info info;
>> +
>> +		minsz = offsetofend(struct vfio_irq_info, count);
>> +		if (copy_from_user(&info, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (info.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		if (info.index >= mc_dev->obj_desc.irq_count)
>> +			return -EINVAL;
>> +
>> +		info.flags = VFIO_IRQ_INFO_EVENTFD;
> shouldn't it be MASKABLE as well? I see skeletons for MASK.

The skeletons for mask are not implemented. Maybe I should just remove 
the skeletons.

>> +		info.count = 1;
>> +
>> +		return copy_to_user((void __user *)arg, &info, minsz);
>>   	}
>>   	case VFIO_DEVICE_SET_IRQS:
>>   	{
>> -		return -ENOTTY;
>> +		struct vfio_irq_set hdr;
>> +		u8 *data = NULL;
>> +		int ret = 0;
>> +
>> +		minsz = offsetofend(struct vfio_irq_set, count);
>> +
>> +		if (copy_from_user(&hdr, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (hdr.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		if (hdr.index >= mc_dev->obj_desc.irq_count)
>> +			return -EINVAL;
>> +
>> +		if (hdr.start != 0 || hdr.count > 1)
>> +			return -EINVAL;
>> +
>> +		if (hdr.count == 0 &&
>> +		    (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE) ||
>> +		    !(hdr.flags & VFIO_IRQ_SET_ACTION_TRIGGER)))
>> +			return -EINVAL;
>> +
>> +		if (hdr.flags & ~(VFIO_IRQ_SET_DATA_TYPE_MASK |
>> +				  VFIO_IRQ_SET_ACTION_TYPE_MASK))
>> +			return -EINVAL;
>> +
>> +		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
>> +			size_t size;
>> +
>> +			if (hdr.flags & VFIO_IRQ_SET_DATA_BOOL)
>> +				size = sizeof(uint8_t);
>> +			else if (hdr.flags & VFIO_IRQ_SET_DATA_EVENTFD)
>> +				size = sizeof(int32_t);
>> +			else
>> +				return -EINVAL;
>> +
>> +			if (hdr.argsz - minsz < hdr.count * size)
>> +				return -EINVAL;
>> +
>> +			data = memdup_user((void __user *)(arg + minsz),
>> +					   hdr.count * size);
>> +			if (IS_ERR(data))
>> +				return PTR_ERR(data);
>> +		}
> can't you reuse vfio_set_irqs_validate_and_prepare()?

Yes, I think I can reuse it.

>> +
>> +		mutex_lock(&vdev->igate);
>> +		ret = vfio_fsl_mc_set_irqs_ioctl(vdev, hdr.flags,
>> +						 hdr.index, hdr.start,
>> +						 hdr.count, data);
>> +		mutex_unlock(&vdev->igate);
>> +		kfree(data);
>> +
>> +		return ret;
>>   	}
>>   	case VFIO_DEVICE_RESET:
>>   	{
>> @@ -413,6 +481,8 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>>   		return ret;
>>   	}
>>   
>> +	mutex_init(&vdev->igate);
>> +
>>   	return ret;
>>   }
>>   
>> @@ -436,6 +506,7 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>>   	mc_dev->mc_io = NULL;
>>   
>>   	vfio_fsl_mc_reflck_put(vdev->reflck);
>> +	mutex_destroy(&vdev->igate);
>>   
>>   	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
>>   
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
>> new file mode 100644
>> index 000000000000..058aa97aa54a
>> --- /dev/null
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
>> @@ -0,0 +1,63 @@
>> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>> +/*
>> + * Copyright 2013-2016 Freescale Semiconductor Inc.
>> + * Copyright 2019 NXP
>> + */
>> +
>> +#include <linux/vfio.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/eventfd.h>
>> +#include <linux/msi.h>
>> +
>> +#include "linux/fsl/mc.h"
>> +#include "vfio_fsl_mc_private.h"
>> +
>> +static int vfio_fsl_mc_irq_mask(struct vfio_fsl_mc_device *vdev,
>> +				unsigned int index, unsigned int start,
>> +				unsigned int count, u32 flags,
>> +				void *data)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static int vfio_fsl_mc_irq_unmask(struct vfio_fsl_mc_device *vdev,
>> +				unsigned int index, unsigned int start,
>> +				unsigned int count, u32 flags,
>> +				void *data)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
>> +				       unsigned int index, unsigned int start,
>> +				       unsigned int count, u32 flags,
>> +				       void *data)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>> +			       u32 flags, unsigned int index,
>> +			       unsigned int start, unsigned int count,
>> +			       void *data)
>> +{
>> +	int ret = -ENOTTY;
>> +
>> +	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>> +	case VFIO_IRQ_SET_ACTION_MASK:
>> +		ret = vfio_fsl_mc_irq_mask(vdev, index, start, count,
>> +					   flags, data);
>> +		break;
>> +	case VFIO_IRQ_SET_ACTION_UNMASK:
>> +		ret = vfio_fsl_mc_irq_unmask(vdev, index, start, count,
>> +					     flags, data);
>> +		break;
>> +	case VFIO_IRQ_SET_ACTION_TRIGGER:
>> +		ret = vfio_fsl_mc_set_irq_trigger(vdev, index, start,
>> +						  count, flags, data);
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> index 3b85d930e060..d5b6fe891a48 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> @@ -34,7 +34,12 @@ struct vfio_fsl_mc_device {
>>   	u32				num_regions;
>>   	struct vfio_fsl_mc_region	*regions;
>>   	struct vfio_fsl_mc_reflck   *reflck;
>> -
>> +	struct mutex         igate;
>>   };
>>   
>> +extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>> +			       u32 flags, unsigned int index,
>> +			       unsigned int start, unsigned int count,
>> +			       void *data);
>> +
>>   #endif /* VFIO_FSL_MC_PRIVATE_H */
>>
> Thanks
> 
> Eric
> 

Regards,
Diana

