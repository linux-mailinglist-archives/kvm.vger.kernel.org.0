Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B17B25FE0E
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 18:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgIGOn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 10:43:59 -0400
Received: from mail-eopbgr10080.outbound.protection.outlook.com ([40.107.1.80]:39031
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729976AbgIGOlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 10:41:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKeeJOEGvsfR77VtSMIdTgD2up5YgELoDdgnzheSMVG0FKHZATB8+jAGfGVL4e2fCtjZTLgn5a1xOU3JV8An+TK2yQZp6vPQ4Nx0DgcLVuoHgD1RxC6bKvzEJP/dUPaQK8WvmSH0KxTVsofU2s7H9n3y6qFkni9vmbgeJIz/OXIMuTBb0yB7Ahv4J+lhdoSzye3B3FpcCLw8IpDw1W7kO6RlGOm5iK3Vq3eumrijta0RAGx1FjMw1u8B5oSXBU3AaIoxaIrkQthjqmr9N1B6e6wsVtfWGDKsuQB9ByZ7TKKHH0c3oclN0Lcs9q+v9ySVHPLYyXJhGVfS+Ytwe9Cg/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVoMGE35iT1J9pG1jGX4pCtlIZL4R2V02RQMoTSh0Io=;
 b=jSg+Man02NHkwpHWLsqgjaFLI8t3AMzEx90lQcy3dm8eMMd7IXqK+oXD8er0gDVSt3MCMm6vtnt0COk7GqHvXJqAEBwp3uQk7m7emmqneH+PH1EiYPOAS7SpsmWUWcd6nhBMob14R+gSy4WDoTJgVC9FVzizJGxKpZDoYOlL0vDaRoVvkvUbiRVfh7+Zn04o/xkn/KSLCNj53PX3IqD4W7vpRkV4Axn3w5jpLiT3wlnTSDMM53SsMYb+XBKuAZEt7xYr+5/tdg+212LqyCDgi7g0vjoj6vOo9V9zcsKLCHpJUxcPlLFBhe5YMJ9dl7P4mY7kRcU0NnWG9K5h9OsSCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVoMGE35iT1J9pG1jGX4pCtlIZL4R2V02RQMoTSh0Io=;
 b=SaYRtn6pOVs8kx5I/FXW2xuuACnUkP1zpI7TrNaC3KM1fKflm0N08jwQsEllh1hLFkE6g9aLCKWFn4fFPOt4Z16xKDnOeziby5GXjBKUIw3vWUOwfYimZpq4zFgC76xXfsRm41knRL7m1161WyrcxqUJxSXh0BrxEKifokeDM6U=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR04MB5872.eurprd04.prod.outlook.com
 (2603:10a6:803:e2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 14:38:58 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607%9]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 14:38:58 +0000
Subject: Re: [PATCH v4 02/10] vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc
 driver bind
To:     Auger Eric <eric.auger@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-3-diana.craciun@oss.nxp.com>
 <5eb09826-c5d9-7092-3a96-722ae57887a8@redhat.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <596bba39-0bfc-d98c-efb2-ef1768ee3799@oss.nxp.com>
Date:   Mon, 7 Sep 2020 17:38:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <5eb09826-c5d9-7092-3a96-722ae57887a8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0119.eurprd04.prod.outlook.com
 (2603:10a6:208:55::24) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM0PR04CA0119.eurprd04.prod.outlook.com (2603:10a6:208:55::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Mon, 7 Sep 2020 14:38:57 +0000
X-Originating-IP: [188.27.189.94]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fee9013e-d3d0-4993-a2ef-08d8533bc125
X-MS-TrafficTypeDiagnostic: VI1PR04MB5872:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB58722EE127A6613A7538A88DBE280@VI1PR04MB5872.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5OvswXi3z+6g0IdItqHdhBhCYOxCIUfVfbxTR8ltCHgGwl2hGay0CtO7C7g/17C0IryiVvK5NkaKV7B5oI0D3Td3nD+KWLpvB5yn6+CA1puinwJ2g8yR7fwYGHUhHpqYftJKj8HRQLaZXupye1hgM+BaG/H2LEvWeZd+FE1A+UXmdvaW5eKL0f435NPBaLjh5Dqfw8jkHQu7n5fLN2bbXfsTCeQ75g88iOIuSRSEwU0pnN1+hRyAOHzKCJtY3m8IIDH6Q/IQcXjw/CA26JuRoerZ5AgPtX3XLX5wJj5dAXb4Vozd1HLSsA1Pc+dIrQBZMM21dQkh6b44MLCh2U4nXbNPGMYTJBRlGI/BafCqQIjyslu1Pzn4smA2OfSh/t5LfrZm1mrNeW6Le8CBcXIeEoIcTzIdzukOft3rRvOkg4CXQiNCF7VKwUkQ1zOCVk2apmaaRJYFNaR8offSo7dyMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(26005)(52116002)(186003)(16526019)(966005)(86362001)(66556008)(31696002)(5660300002)(6666004)(66946007)(31686004)(66476007)(956004)(6486002)(4326008)(53546011)(2616005)(16576012)(83380400001)(478600001)(8936002)(316002)(8676002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4D6Wgnzr+gYvV61xol0koG51Mxdoqyi2IEXEg1bT48+mbnqtpyxBqDtqC/wTfHln4H4MlGhwTz3pIFIHrGOHW6+ICy5xJn5bv+ZQujku6Z7mZqtMK17MNu2YJLTjmyWkCv8A57OvTZa8g/3skHGom5yNKE6YJgStC+K2f78jdrgu1Fq0iFZAyeCpkZs9NZaevKzXd4kb3HfR8ikKq/750vRMIHJ6W6c1yJxu3BpVEfwwx2rGzvBiv3BXSJ2O41Y7RxLDGKf/5UF57RYosYGaBO1XhV83272CP6S2OiLMGOPCMjjHIKt6cT7/qbDMdYCPAIPvLT7QFIUCrdJU1XY7nRKWGCJ1KeOM7+ziIhiRDTb/6bnSrkeens4DLg0IpNgmxszYzLPg5U1Z/02Fqc4audSXuR0lP/JogmoOq0KAtwxyHVnh7CnDwuBAyGpeWmz9Y7Nf6Zny51lbVEdbRH8OpVvaUXIfYLi9IebfD2P7fypagQevDtpno9PcF59POEL23sdUibm7ndyMsCuRCL6hRy61Rbr2r6UmW2Ho3I160ssbVZBMHAndURMcI2u0QM8vRjmEjHOd3HvTiK5/i8e2XhqfUb8Y6JIwfuaDHzhj89IpwE0u07p4pKym2JRiwRCZVqipHMUzAoCoS7LM/kbU1A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee9013e-d3d0-4993-a2ef-08d8533bc125
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 14:38:58.5458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppNNvXN8SJnlJTAM2B0abC8jejlZD3V03InxPQhDUh1FZWrsmZlKgtCz+PJrmUY555F57vlh6/nPsgsWUCVtTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5872
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 9/3/2020 5:06 PM, Auger Eric wrote:
> Hi Diana,
> 
> On 8/26/20 11:33 AM, Diana Craciun wrote:
>> The DPRC (Data Path Resource Container) device is a bus device and has
>> child devices attached to it. When the vfio-fsl-mc driver is probed
>> the DPRC is scanned and the child devices discovered and initialized.
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 84 +++++++++++++++++++++++
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  1 +
>>   2 files changed, 85 insertions(+)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 8b53c2a25b32..85e007be3a5d 100644
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
>> @@ -84,6 +86,72 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
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
>> +			dev_warn(dev, "Setting driver override for device in dprc %s failed\n",
>> +			     dev_name(&mc_cont->dev));
>> +		dev_info(dev, "Setting driver override for device in dprc %s\n",
>> +			 dev_name(&mc_cont->dev));
> Don't you miss an else here?
>> +	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
>> +		vdev->mc_dev == mc_cont) {
>> +		struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
>> +
>> +		if (mc_drv && mc_drv != &vfio_fsl_mc_driver)
>> +			dev_warn(dev, "Object %s bound to driver %s while DPRC bound to vfio-fsl-mc\n",
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
>> +	if (ret < 0) {
> if (ret) here and in other places? or are there any > returned values
>> +		dev_err(&mc_dev->dev, "Failed to setup DPRC (error = %d)\n", ret);
> nit: maybe align your error messages. Before you were using __func__,
> here you don't. Maybe don't? also you may consider using strerror(-ret)
>> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
>> +		return ret;
>> +	}
>> +
>> +	ret = dprc_scan_container(mc_dev, false);
>> +	if (ret < 0) {
>> +		dev_err(&mc_dev->dev, "Container scanning failed: %d\n", ret);
>> +		dprc_cleanup(mc_dev);
> I see dprc_cleanup is likely to fail. Generally cleanup shouldn't.
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2283433.html

Right, I will change the dprc_cleanup not to fail.


>> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> nit: here also you can factorize code doing goto unregister;
> shouldn't you reset vdev->nb.notifier_call to NULL as well. I see it is
> tested in other places.
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>   static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>>   {
>>   	struct iommu_group *group;
>> @@ -112,6 +180,12 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>>   		return ret;
>>   	}
>>   
>> +	ret = vfio_fsl_mc_init_device(vdev);
>> +	if (ret < 0) {
> I think you also need to call vfio_del_group_dev(&pdev->dev)
>> +		vfio_iommu_group_put(group, dev);
>> +		return ret;
> nit: goto put_group;
>> +	}
>> +
>>   	return ret;
>>   }
>>   
>> @@ -124,6 +198,16 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>>   	if (!vdev)
>>   		return -EINVAL;
>>   
>> +	if (vdev->nb.notifier_call)
>> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
>> +
>> +	if (is_fsl_mc_bus_dprc(mc_dev)) {
>> +		dprc_remove_devices(mc_dev, NULL, 0);
>> +		dprc_cleanup(mc_dev);
>> +	}
> you may consider doing the tear down in opposite order than
> vfio_fsl_mc_init_device, ie. bus_unregister_notifier after the
> dprc_cleanup? That's also what is done in vfio_fsl_mc_init_device error
> path handling.
>> +
>> +	mc_dev->mc_io = NULL;
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
>>   #endif /* VFIO_FSL_MC_PRIVATE_H */>
> Thanks
> 
> Eric
> 

Thanks,
Diana
