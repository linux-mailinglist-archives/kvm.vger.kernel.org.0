Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E3C283D3F
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 19:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgJERYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 13:24:37 -0400
Received: from mail-eopbgr00047.outbound.protection.outlook.com ([40.107.0.47]:64740
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbgJERYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 13:24:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgrTKgMrtoETOj4dg0XFKkKGvXiQzl8AZtZaJJV/YH6Z9oQeR9qj+5Vx3z6BOx0XPi1izcMz16laEMJUwBvZuyyDIrHAmmgAAdjkesggEMvhuhbxC/eJwM5XkbW3ve7udnXEWu9ZigEy2HFuHn3JFlevZ54fZTR6nkmgqOd94iDnngd8jvqqKi1cNkrkyMFHN5iVhUER4RCqB/Po7fdkgfFOr7TAAalfy0o/5rQoIQ2gTHFkM2dQhRw5ImO+gL3Vrg4JOh8pOBy75tohKF2v1OIb6wscPfFfPv2c+lO6LQZD9uc6WqK75zjuQehQLBsQ+cFIS1EoxKrGCdNr3pI6jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9bAxbfWxJ0xYKhcIsVvhtMpga8Riz6o1qU8D850HxU=;
 b=VVI3Kko0FtLwbQjgJWyUYEGKUzGEqRNU6e6cTbIaTnr1nBQ+/ArxuCF4oslblXU5k7RIPF77t2882wrEmoh8dEjP1PJigEgD4uB/PtdHotxZalDXx4rf2sH3GYfbzIu56A6DJ40OzUh4FDaBS07aGh/05lmMO2+LVqzyj5WqctRVjBVoI9ofyAogP1qNwCBQ039/HkHzQ9rEous3ubpaCEadkmVc9OlvFGjpmVbemIKJdHJQuh/63s3GfdZO3rfSE6r1CdhQ3phEaTXFc1KkdxmpGGeZY6OhgctQ7LC8kcPEa1Jo7E4t+7jksw052JASg9Cl4mXo/JY/nG7NlcEPnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9bAxbfWxJ0xYKhcIsVvhtMpga8Riz6o1qU8D850HxU=;
 b=CH2b82WxZl9Y2Ik9CihUD71FzBXBaOxNTME8Yg6+vYoOdTYKKnGmF/c3/qrUbksEckJz+REFAaJFZfHBRgC9B10NZWN8U/RNIsmtyvdWE2nIMzcShjHG8a7rygBnZhw1kQHNEGUfZT8tGCg0C9pcCD7pYMIu1aeLA9pVc4k8YkA=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VE1PR04MB7344.eurprd04.prod.outlook.com
 (2603:10a6:800:1a1::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Mon, 5 Oct
 2020 17:24:32 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f%11]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 17:24:32 +0000
Subject: Re: [PATCH v5 02/10] vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc
 driver bind
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, bharatb.linux@gmail.com,
        linux-kernel@vger.kernel.org, eric.auger@redhat.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
 <20200929090339.17659-3-diana.craciun@oss.nxp.com>
 <20201002112437.0b15a986@x1.home>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <837880b9-c0f5-2da2-0038-36cb45aac9f5@oss.nxp.com>
Date:   Mon, 5 Oct 2020 20:24:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
In-Reply-To: <20201002112437.0b15a986@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.27.189.94]
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM3PR05CA0156.eurprd05.prod.outlook.com (2603:10a6:207:3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Mon, 5 Oct 2020 17:24:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ef89c34-247b-4b1c-1913-08d86953857a
X-MS-TrafficTypeDiagnostic: VE1PR04MB7344:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7344085E929D3B8C4A8086EFBE0C0@VE1PR04MB7344.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:336;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+BPRf5A8ZM3rheubxnRITtm+QsPqrOjdrIHL+snekory2aAfT3BLgJwdV8qDNYjtxPE/dXkYwEPGhM5vVGwAe7dTKV9ImltS7jayD6+QRMrpFfcPQaCSYud+b7aArK3dQhM1L2BdElvX7p/TR/LOlPEHkc+IQ98b8SqojUK5S4unpclzL06D8Zrpn8zuPcahYqFB2fseNsrCdk0eyMunEaLDXBcpjS6Dce8r3GitJzuXDJ2ntqGoAvY55db6gOjG6SzHJyEL20WWB86vOpLyOMVuwHg70zsasx/nUsfJPJL/uyIdotRozJ2dx3J50MdrkMxW96ZxkE0/VeC5Vs/l5ItSXX4wyLguWWCKM14WIgUhfWeH4R9rkjc+p5WqvoT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(4326008)(478600001)(66476007)(66946007)(31696002)(2906002)(8676002)(16576012)(66556008)(83380400001)(186003)(52116002)(53546011)(316002)(26005)(16526019)(8936002)(6666004)(86362001)(956004)(6916009)(31686004)(6486002)(5660300002)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ek578FykG2hTPG+gqWsWwOfLDfJ/0PMFaslirzASh4E6rc8ZZRONonJfEX7AhyPZATi3obFW1GZGgQWP4tHgj4FD7wNfZWLJnO+Bym2zmhM2cL3d7/kYP40oW81CVHPr99Xz+FSfGunDtEnHOfTiCcYn6Z11G2JxcCIl42vnOKLnUny3p7NIU8nKw6Grg4OoHqiMbzBHIzIAPAwUJwORAurUuCYNfFJRA8xtp2AFRgTt9b8eA+UspIME+R8gvzkKcyaFbvA3YhqhwjtDarHHdFj8uYEK9ItQBqUdw8dCKO2yI41cOwsd1UHcE9/tDsxeBRvM64FeUUwVZu3CUFsqk6Oe7I8RDGgJCvwNGaHKujmotlamnd5XgN0S5WDOGu1v7WLu+pv1W+YQOJb63re/3K8l2okc5VJgiVPplNi0gLwabis0uCGkFA4RB+MopsxorCzWLUfprCzWyAc9laRNUYNLq+SAGpuHWXsGYiHB/01+UFTHBiQd5sRvD2le/rJKDHY3/7yLsS24BYZNnSEmnf09MrPJGslHLoPu2pnb2GcevA3mnPk3oOl+SWFi2pwPO/7GQGVLmG1wZx8JFVljUkbBt796ReBAzwGoRZlmjyobJxaXi6lO2IyIFtioEl29TbOFUXS5cuD83e8jpRMwFw==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef89c34-247b-4b1c-1913-08d86953857a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 17:24:31.9177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mZoMze6kADFUQJCQlWmP3n7+l3dDGSZp31kTQUpVL41hzD2pmRwKjftnb+1gDlqtpw5AiKsKebJjGtpAHuw8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7344
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/2020 8:24 PM, Alex Williamson wrote:
> On Tue, 29 Sep 2020 12:03:31 +0300
> Diana Craciun <diana.craciun@oss.nxp.com> wrote:
> 
>> The DPRC (Data Path Resource Container) device is a bus device and has
>> child devices attached to it. When the vfio-fsl-mc driver is probed
>> the DPRC is scanned and the child devices discovered and initialized.
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 90 +++++++++++++++++++++++
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  1 +
>>   2 files changed, 91 insertions(+)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index a7a483a1e90b..ba44d6d01cc9 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -15,6 +15,8 @@
>>   
>>   #include "vfio_fsl_mc_private.h"
>>   
>> +static struct fsl_mc_driver vfio_fsl_mc_driver;
>> +
>>   static int vfio_fsl_mc_open(void *device_data)
>>   {
>>   	if (!try_module_get(THIS_MODULE))
>> @@ -84,6 +86,79 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
>>   	.mmap		= vfio_fsl_mc_mmap,
>>   };
>>   
>> +static int vfio_fsl_mc_bus_notifier(struct notifier_block *nb,
>> +				    unsigned long action, void *data)
>> +{
>> +	struct vfio_fsl_mc_device *vdev = container_of(nb,
>> +					struct vfio_fsl_mc_device, nb);
>> +	struct device *dev = data;
>> +	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
>> +	struct fsl_mc_device *mc_cont = to_fsl_mc_device(mc_dev->dev.parent);
>> +
>> +	if (action == BUS_NOTIFY_ADD_DEVICE &&
>> +	    vdev->mc_dev == mc_cont) {
>> +		mc_dev->driver_override = kasprintf(GFP_KERNEL, "%s",
>> +						    vfio_fsl_mc_ops.name);
>> +		if (!mc_dev->driver_override)
>> +			dev_warn(dev, "VFIO_FSL_MC: Setting driver override for device in dprc %s failed\n",
>> +			     dev_name(&mc_cont->dev));
>> +		else
>> +			dev_info(dev, "VFIO_FSL_MC: Setting driver override for device in dprc %s\n",
>> +			 dev_name(&mc_cont->dev));
> 
> Nit, some whitespace inconsistencies on the second line of each of
> these.  I can fixup on commit if we don't find anything else worth a
> respin.
> 
>> +	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
>> +		vdev->mc_dev == mc_cont) {
>> +		struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
>> +
>> +		if (mc_drv && mc_drv != &vfio_fsl_mc_driver)
>> +			dev_warn(dev, "VFIO_FSL_MC: Object %s bound to driver %s while DPRC bound to vfio-fsl-mc\n",
>> +				 dev_name(dev), mc_drv->driver.name);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
>> +{
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	int ret;
>> +
>> +	/* Non-dprc devices share mc_io from parent */
>> +	if (!is_fsl_mc_bus_dprc(mc_dev)) {
>> +		struct fsl_mc_device *mc_cont = to_fsl_mc_device(mc_dev->dev.parent);
>> +
>> +		mc_dev->mc_io = mc_cont->mc_io;
>> +		return 0;
>> +	}
>> +
>> +	vdev->nb.notifier_call = vfio_fsl_mc_bus_notifier;
>> +	ret = bus_register_notifier(&fsl_mc_bus_type, &vdev->nb);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* open DPRC, allocate a MC portal */
>> +	ret = dprc_setup(mc_dev);
>> +	if (ret) {
>> +		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Failed to setup DPRC (%d)\n", ret);
>> +		goto out_nc_unreg;
>> +	}
>> +
>> +	ret = dprc_scan_container(mc_dev, false);
>> +	if (ret) {
>> +		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Container scanning failed (%d)\n", ret);
>> +		goto out_dprc_cleanup;
>> +	}
> 
> If I understand this correctly, we've setup the bus notifier to write
> the driver override as each sub-devices appear on the bus from this
> scan.  When non-dprc devices are removed below, it appears we remove all
> their sub-devices.  Is there a chance here that an error from the scan
> leaves residual sub-devices, ie. should we proceed the below
> dprc_cleanup() with a call to dprc_remove_devices() to be certain none
> remain?  Thanks,
> 
> Alex

Right, we should call dprc_remove_devices as well. I will respin another 
version.

> 
> 
>> +
>> +	return 0;
>> +
>> +out_dprc_cleanup:
>> +	dprc_cleanup(mc_dev);
>> +out_nc_unreg:
>> +	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
>> +	vdev->nb.notifier_call = NULL;
>> +
>> +	return ret;
>> +}
>> +
>>   static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>>   {
>>   	struct iommu_group *group;
>> @@ -110,8 +185,15 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>>   		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
>>   		goto out_group_put;
>>   	}
>> +
>> +	ret = vfio_fsl_mc_init_device(vdev);
>> +	if (ret)
>> +		goto out_group_dev;
>> +
>>   	return 0;
>>   
>> +out_group_dev:
>> +	vfio_del_group_dev(dev);
>>   out_group_put:
>>   	vfio_iommu_group_put(group, dev);
>>   	return ret;
>> @@ -126,6 +208,14 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>>   	if (!vdev)
>>   		return -EINVAL;
>>   
>> +	if (is_fsl_mc_bus_dprc(mc_dev)) {
>> +		dprc_remove_devices(mc_dev, NULL, 0);
>> +		dprc_cleanup(mc_dev);
>> +	}
>> +
>> +	if (vdev->nb.notifier_call)
>> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
>> +
>>   	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
>>   
>>   	return 0;
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> index e79cc116f6b8..37d61eaa58c8 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> @@ -9,6 +9,7 @@
>>   
>>   struct vfio_fsl_mc_device {
>>   	struct fsl_mc_device		*mc_dev;
>> +	struct notifier_block        nb;
>>   };
>>   
>>   #endif /* VFIO_FSL_MC_PRIVATE_H */
> 

