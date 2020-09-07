Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742D1260206
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbgIGRQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:16:18 -0400
Received: from mail-eopbgr40053.outbound.protection.outlook.com ([40.107.4.53]:12257
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729700AbgIGODm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 10:03:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itDOpu1qN1Uuu7/+PEWvk+sqAvUXpqPvoOkZExZoR3U+64RAmbKncj7LpDf0/JxpJlnkLXzyGygEX8ESFjINjc1LwTNIzgnrk/GTKAfChQRWZ30B1GhG3LQLWwNaH8dDUHjEYkVlN0Rc3ax3jtTgJhaakBkT09ltSZQXYFN3sVXqYtCbFozcmW5SvKsSv4Wb3rhqcj6vNXz5FsUqGJ2poDq9r0ilishgcg6XfRJxU2Ay4qcTmmjcBq2Th9ajzX+tTh4LYnXvow7fIjnm4m44r+hTz/Vq37fQ5Rqiiw/3QWkIcKr49hPXhckKaTxIHUA0NHuEI5+XUhOE9xU/ntYWaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNb9cdfrqtBzolcow4Ww46kPM4vXYGBqRjsYyiOK6vc=;
 b=g5HlP1OwbTIDxfMIgnuMSlt1oyoNzUahrNvNdQB1vG1+bbIudaZDt2DJAf+/Ec4oD0bKFl+qVtipcdalXVyRjKzqVwIuwxlP4AQ3xQd032kaeY5soJjfiPEpGz4KQInLMz0KadNBx+EkIZlKiu3oH7fdc4MB6+E9ob6bsYWKCqiZZvYIoO9zOT6MJIrpFxGsPoBWvUylIG5Ik3THhu+yoG6HxVguiFP8iegUWAUd/td+LvyTRkbGdTsG5IQhvRVsWwgTYPtwMTwgWq7/fyVLxVaCnnwvOd8OXvXPBT+FRetQEZfzKgCuRnzu/ORbBmruNh3VRpQm9feiyg74+Kak9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNb9cdfrqtBzolcow4Ww46kPM4vXYGBqRjsYyiOK6vc=;
 b=gFEpNBa3YFD7v/Efz+lxxdZrP9uga8H7NU2f/M6W1PlSGpnSSo61YFSlwj8rgXXVb4RdMvVdmPwfBw/LwJ0nPX+nqpECFcHVDvUap5iYjLRVMi3tP7beIfUESSnXowXXl+LWwaROMs1eYuZ+YaOT3rNf/oYmsaqhjJQomr6RjUk=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VE1PR04MB7231.eurprd04.prod.outlook.com
 (2603:10a6:800:1a9::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 14:02:42 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607%9]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 14:02:42 +0000
Subject: Re: [PATCH v4 08/10] vfio/fsl-mc: trigger an interrupt via eventfd
To:     Auger Eric <eric.auger@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-9-diana.craciun@oss.nxp.com>
 <f313b0ed-2cb7-cbb0-18f6-943098ecef9a@redhat.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <6c6d803a-2c01-dc44-383c-a7ca5e0556e3@oss.nxp.com>
Date:   Mon, 7 Sep 2020 17:02:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <f313b0ed-2cb7-cbb0-18f6-943098ecef9a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 14:02:40 +0000
X-Originating-IP: [188.27.189.94]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85179a32-a7f8-46ce-f0b4-08d85336afe1
X-MS-TrafficTypeDiagnostic: VE1PR04MB7231:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB723112BDCA7FA644E1526F66BE280@VE1PR04MB7231.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VRnuDC2wX7SxwssHFl+jvqWHxFteuZveBfl6Wlfgk96hDDuCD6ufag/Cg0Dhvk5dv2I67gZyS6fcyLUph5AsHSZkDp5zjL6At3+zKBpvzKw9WItka/hQtJ7Q9BQC1F392menzcPHrHtA1KhViy2twLzHdQpbEzzS7eE8nvCFQj8ML9rHyjlREOs1N6Mv8jDjiqtYkf90/+VHSLfdHTl1YBNi5cPVt94AD3IX6p6P9BZbfjxho3E9SAUAvDqjlRCKD0Pz0yqKh6PZk51NczOOWPs3gfm6fFftAyqpvkG7/B0s5Q7cfdzFNBL+xOZJ5FHVO1Va7uppZF+yFvAp1Ccb34pZigTGBO3mJSHnkmQdPDrz4Zl8a6uGW0l77I5ZX/OB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(16526019)(6486002)(31696002)(4326008)(186003)(8676002)(16576012)(31686004)(6666004)(8936002)(2906002)(83380400001)(478600001)(316002)(26005)(956004)(66476007)(66946007)(66556008)(5660300002)(53546011)(86362001)(52116002)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wYlGFomLMZCua72CfsrZt9Y2nNaZ8CTVgex/iksaxbT1d9AZv1dR5o1bM8NWnQQ+lw3+e6S1Yg8WCBootlinWBfA+FRFYyRqrhqg6DgmTwKSf1apb1/8L5BW8Q8sDEWy9ZOaT3s4aHJiUL+v0jLgpXlZb2Q6RV1tRc72M7xVFfXrwgJ7OLxtIr/PwFQiHsEeLUP9PFQakfSQzqSgRvHUnEC/ESBrOFlV9EBswRMrvajw1u4EWJR9Cu43E9FVZE1c9Qh8Sf8zLN59XqNHZFgbZsht8RXBdCqDrw0BxwClica1IAIjAECLWfkteIvSndBi933ppQQPFemQIKhT1LhuyHwsr/X+Uy+sH0GZfn+RrCzpHSfDdiCsMXakg5m6k0rn1QG3dAO6znqjeVyfAg8UFfYj5K76AW0oKtGjQW6fgZHO/Ris76vFvuT4wELDMTL8qQPDxoOreuUntKUcVliGe47f+7K198TJHcNbxTTegaR0XHERL3HDLlZLWDbJShSZequPAnFaj5IumNZGoNoF4tEp/lmLoMWbqVV0P1CJ1uCIqb+yU3tBvuVSkWLTha9RYePMwuLCS+jFynclkX+cIvBGNiiwqroo0ux/PKC6kWZworXKSozpoALnVMVXI/Db0iGWbk7rJWJgN+69VvYDCA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85179a32-a7f8-46ce-f0b4-08d85336afe1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 14:02:42.0692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5cf0ZC1PLeQRimuRVfKj7ep5urFMV5vrBNSu2qKnjrfVLmtiFkwuet4aODvMLLkNLV4rrf4+vlxauiAZNq/prQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7231
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 9/4/2020 11:02 AM, Auger Eric wrote:
> Hi Diana,
> 
> On 8/26/20 11:33 AM, Diana Craciun wrote:
>> This patch allows to set an eventfd for fsl-mc device interrupts
>> and also to trigger the interrupt eventfd from userspace for testing.
>>
>> All fsl-mc device interrupts are MSIs. The MSIs are allocated from
>> the MSI domain only once per DPRC and used by all the DPAA2 objects.
>> The interrupts are managed by the DPRC in a pool of interrupts. Each
>> device requests interrupts from this pool. The pool is allocated
>> when the first virtual device is setting the interrupts.
>> The pool of interrupts is protected by a lock.
>>
>> The DPRC has an interrupt of its own which indicates if the DPRC
>> contents have changed. However, currently, the contents of a DPRC
>> assigned to the guest cannot be changed at runtime, so this interrupt
>> is not configured.
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         |  18 ++-
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 160 +++++++++++++++++++++-
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  10 ++
>>   3 files changed, 186 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 42014297b484..73834f488a94 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -147,12 +147,28 @@ static int vfio_fsl_mc_open(void *device_data)
>>   static void vfio_fsl_mc_release(void *device_data)
>>   {
>>   	struct vfio_fsl_mc_device *vdev = device_data;
>> +	int ret;
>>   
>>   	mutex_lock(&vdev->reflck->lock);
>>   
>> -	if (!(--vdev->refcnt))
>> +	if (!(--vdev->refcnt)) {
>> +		struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +		struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
>> +		struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
>> +
>>   		vfio_fsl_mc_regions_cleanup(vdev);
>>   
>> +		/* reset the device before cleaning up the interrupts */
>> +		ret = dprc_reset_container(mc_cont->mc_io, 0,
>> +		      mc_cont->mc_handle,
>> +			  mc_cont->obj_desc.id,
>> +			  DPRC_RESET_OPTION_NON_RECURSIVE);
> shouldn't you test ret?
>> +
>> +		vfio_fsl_mc_irqs_cleanup(vdev);
>> +
>> +		fsl_mc_cleanup_irq_pool(mc_cont);
>> +	}
>> +
>>   	mutex_unlock(&vdev->reflck->lock);
>>   
>>   	module_put(THIS_MODULE);
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
>> index 058aa97aa54a..409f3507fcf3 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
>> @@ -29,12 +29,149 @@ static int vfio_fsl_mc_irq_unmask(struct vfio_fsl_mc_device *vdev,
>>   	return -EINVAL;
>>   }
>>   
>> +int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
>> +{
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	struct vfio_fsl_mc_irq *mc_irq;
>> +	int irq_count;
>> +	int ret, i;
>> +
>> +    /* Device does not support any interrupt */
> indent needs to be fixed
>> +	if (mc_dev->obj_desc.irq_count == 0)
>> +		return 0;
>> +
>> +	/* interrupts were already allocated for this device */
>> +	if (vdev->mc_irqs)
>> +		return 0;
>> +
>> +	irq_count = mc_dev->obj_desc.irq_count;
>> +
>> +	mc_irq = kcalloc(irq_count, sizeof(*mc_irq), GFP_KERNEL);
>> +	if (!mc_irq)
>> +		return -ENOMEM;
>> +
>> +	/* Allocate IRQs */
>> +	ret = fsl_mc_allocate_irqs(mc_dev);
>> +	if (ret) {
>> +		kfree(mc_irq);
>> +		return ret;
>> +	}
>> +
>> +	for (i = 0; i < irq_count; i++) {
>> +		mc_irq[i].count = 1;
>> +		mc_irq[i].flags = VFIO_IRQ_INFO_EVENTFD;
>> +	}
>> +
>> +	vdev->mc_irqs = mc_irq;
>> +
>> +	return 0;
>> +}
>> +
>> +static irqreturn_t vfio_fsl_mc_irq_handler(int irq_num, void *arg)
>> +{
>> +	struct vfio_fsl_mc_irq *mc_irq = (struct vfio_fsl_mc_irq *)arg;
>> +
>> +	eventfd_signal(mc_irq->trigger, 1);
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int vfio_set_trigger(struct vfio_fsl_mc_device *vdev,
>> +						   int index, int fd)
>> +{
>> +	struct vfio_fsl_mc_irq *irq = &vdev->mc_irqs[index];
>> +	struct eventfd_ctx *trigger;
>> +	int hwirq;
>> +	int ret;
>> +
>> +	hwirq = vdev->mc_dev->irqs[index]->msi_desc->irq;
>> +	if (irq->trigger) {
>> +		free_irq(hwirq, irq);
>> +		kfree(irq->name);
>> +		eventfd_ctx_put(irq->trigger);
>> +		irq->trigger = NULL;
>> +	}
>> +
>> +	if (fd < 0) /* Disable only */
>> +		return 0;
>> +
>> +	irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
>> +			    hwirq, dev_name(&vdev->mc_dev->dev));
>> +	if (!irq->name)
>> +		return -ENOMEM;
>> +
>> +	trigger = eventfd_ctx_fdget(fd);
>> +	if (IS_ERR(trigger)) {
>> +		kfree(irq->name);
>> +		return PTR_ERR(trigger);
>> +	}
>> +
>> +	irq->trigger = trigger;
>> +
>> +	ret = request_irq(hwirq, vfio_fsl_mc_irq_handler, 0,
>> +		  irq->name, irq);
>> +	if (ret) {
>> +		kfree(irq->name);
>> +		eventfd_ctx_put(trigger);
>> +		irq->trigger = NULL;
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
>>   				       unsigned int index, unsigned int start,
>>   				       unsigned int count, u32 flags,
>>   				       void *data)
>>   {
>> -	return -EINVAL;
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	int ret, hwirq;
>> +	struct vfio_fsl_mc_irq *irq;
>> +	struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
>> +	struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
>> +
>> +	if (start != 0 || count != 1)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&vdev->reflck->lock);
>> +	ret = fsl_mc_populate_irq_pool(mc_cont,
>> +			FSL_MC_IRQ_POOL_MAX_TOTAL_IRQS);
>> +	if (ret)
>> +		goto unlock;
>> +
>> +	ret = vfio_fsl_mc_irqs_allocate(vdev);
> any reason the init is done in the set_irq() and not in the open() if
> !vdev->refcnt?

Actually yes, there is a reason. It comes from the way the MSIs are 
handled.

The DPAA2  devices (the devices that can be assigned to the userspace) 
are organized in a hierarchical way. The DPRC is some kind of container 
(parent) for child devices. Only the DPRC is allocating interrupts (it 
allocates MSIs from the MSI domain). The MSIs cannot be allocated in the 
open() because the MSI setup needs an IOMMU cookie which is set when the 
IOMMU is set with VFIO_SET_IOMMU. But iommu is set later, after open(), 
so the MSIs should be allocated afterwards.

So, the DPRC is allocating a pool of MSIs and each child object will 
request a number of interrupts from that pool. This is what 
vfio_fsl_mc_irqs_allocate does: it requests a number of interrupts from 
the pool.


>> +	if (ret)
>> +		goto unlock;
>> +	mutex_unlock(&vdev->reflck->lock);
>> +
>> +	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
>> +		return vfio_set_trigger(vdev, index, -1);
>> +
>> +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
>> +		s32 fd = *(s32 *)data;
>> +
>> +		return vfio_set_trigger(vdev, index, fd);
>> +	}
>> +
>> +	hwirq = vdev->mc_dev->irqs[index]->msi_desc->irq;
>> +
>> +	irq = &vdev->mc_irqs[index];
>> +
>> +	if (flags & VFIO_IRQ_SET_DATA_NONE) {
>> +		vfio_fsl_mc_irq_handler(hwirq, irq);
>> +
>> +	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>> +		u8 trigger = *(u8 *)data;
>> +
>> +		if (trigger)
>> +			vfio_fsl_mc_irq_handler(hwirq, irq);
>> +	}
>> +
>> +	return 0;
>> +
>> +unlock:
>> +	mutex_unlock(&vdev->reflck->lock);
>> +	return ret;
>>   }
>>   
>>   int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>> @@ -61,3 +198,24 @@ int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>>   
>>   	return ret;
>>   }
>> +
>> +/* Free All IRQs for the given MC object */
>> +void vfio_fsl_mc_irqs_cleanup(struct vfio_fsl_mc_device *vdev)
>> +{
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	int irq_count = mc_dev->obj_desc.irq_count;
>> +	int i;
>> +
>> +	/* Device does not support any interrupt or the interrupts
>> +	 * were not configured
>> +	 */
>> +	if (mc_dev->obj_desc.irq_count == 0 || !vdev->mc_irqs)
>> +		return;
>> +
>> +	for (i = 0; i < irq_count; i++)
>> +		vfio_set_trigger(vdev, i, -1);
>> +
>> +	fsl_mc_free_irqs(mc_dev);
>> +	kfree(vdev->mc_irqs);
>> +	vdev->mc_irqs = NULL;
>> +}
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> index d5b6fe891a48..bbfca8b55f8a 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> @@ -15,6 +15,13 @@
>>   #define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
>>   	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
>>   
>> +struct vfio_fsl_mc_irq {
>> +	u32         flags;
>> +	u32         count;
>> +	struct eventfd_ctx  *trigger;
>> +	char            *name;
>> +};
>> +
>>   struct vfio_fsl_mc_reflck {
>>   	struct kref		kref;
>>   	struct mutex		lock;
>> @@ -35,6 +42,7 @@ struct vfio_fsl_mc_device {
>>   	struct vfio_fsl_mc_region	*regions;
>>   	struct vfio_fsl_mc_reflck   *reflck;
>>   	struct mutex         igate;
>> +	struct vfio_fsl_mc_irq      *mc_irqs;
>>   };
>>   
>>   extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>> @@ -42,4 +50,6 @@ extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>>   			       unsigned int start, unsigned int count,
>>   			       void *data);
>>   
>> +void vfio_fsl_mc_irqs_cleanup(struct vfio_fsl_mc_device *vdev);
>> +
>>   #endif /* VFIO_FSL_MC_PRIVATE_H */
>>
> Thanks
> 
> Eric
> 

Thanks,
Diana
