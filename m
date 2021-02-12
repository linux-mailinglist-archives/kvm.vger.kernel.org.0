Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E268831A4D5
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 19:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhBLS5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 13:57:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:56951 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhBLS5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 13:57:11 -0500
IronPort-SDR: BgZecbE0lGmkR87LbXyQDYnTqpZDry4LEyTbZK9PNFnxpueCMuICtVKVxNdqBY0BN0EnPmqmip
 mXv6RiCW+rJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="201611643"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="201611643"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 10:56:26 -0800
IronPort-SDR: leerKFvFy2ZEqyp1pfCzhIAK6tRH3zQvMTF3w/OEEoH/kSQXyVhxCjn5KvIp9XzqWyuE+0lPUS
 fKaKca2+OU6A==
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="398100969"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.46.84]) ([10.209.46.84])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 10:56:25 -0800
Subject: Re: [PATCH v5 04/14] vfio/mdev: idxd: Add auxialary device plumbing
 for idxd mdev support
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255839829.339900.16438737078488315104.stgit@djiang5-desk3.ch.intel.com>
 <20210210234639.GI4247@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <92c0e4b2-c85c-bda6-811b-8547b027d1ee@intel.com>
Date:   Fri, 12 Feb 2021 11:56:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210234639.GI4247@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/10/2021 4:46 PM, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 01:53:18PM -0700, Dave Jiang wrote:
>> diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
>> index a2438b3166db..f02c96164515 100644
>> +++ b/drivers/dma/idxd/idxd.h
>> @@ -8,6 +8,7 @@
>>   #include <linux/percpu-rwsem.h>
>>   #include <linux/wait.h>
>>   #include <linux/cdev.h>
>> +#include <linux/auxiliary_bus.h>
>>   #include "registers.h"
>>   
>>   #define IDXD_DRIVER_VERSION	"1.00"
>> @@ -221,6 +222,8 @@ struct idxd_device {
>>   	struct work_struct work;
>>   
>>   	int *int_handles;
>> +
>> +	struct auxiliary_device *mdev_auxdev;
>>   };
> If there is only one aux device there not much reason to make it a
> dedicated allocation.

Hi Jason. Thank you for the review. Very much appreciated!

Yep. I had it embedded and then changed it when I was working on the 
UACCE bits to make it uniform. Should've just kept it the way it was.

>>   /* IDXD software descriptor */
>> @@ -282,6 +285,10 @@ enum idxd_interrupt_type {
>>   	IDXD_IRQ_IMS,
>>   };
>>   
>> +struct idxd_mdev_aux_drv {
>> +	        struct auxiliary_driver auxiliary_drv;
>> +};
> Wrong indent. What is this even for?

Will remove.

>> +
>>   static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot,
>>   					    enum idxd_interrupt_type irq_type)
>>   {
>> diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
>> index ee56b92108d8..fd57f39e4b7d 100644
>> +++ b/drivers/dma/idxd/init.c
>> @@ -382,6 +382,74 @@ static void idxd_disable_system_pasid(struct idxd_device *idxd)
>>   	idxd->sva = NULL;
>>   }
>>   
>> +static void idxd_remove_mdev_auxdev(struct idxd_device *idxd)
>> +{
>> +	if (!IS_ENABLED(CONFIG_VFIO_MDEV_IDXD))
>> +		return;
>> +
>> +	auxiliary_device_delete(idxd->mdev_auxdev);
>> +	auxiliary_device_uninit(idxd->mdev_auxdev);
>> +}
>> +
>> +static void idxd_auxdev_release(struct device *dev)
>> +{
>> +	struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
>> +	struct idxd_device *idxd = dev_get_drvdata(dev);
> Nope, where did you see drvdata being used like this? You need to use
> container_of.
>
> If put the mdev_auxdev as a non pointer member then this is just:
>
>       struct idxd_device *idxd = container_of(dev, struct idxd_device, mdev_auxdev)
>       
>       put_device(&idxd->conf_dev);
>
> And fix the 'setup' to match this design

Yes. Once it's embedded, everything falls in place. The drvdata hack was 
to deal with the auxdev being a pointer.


>> +	kfree(auxdev->name);
> This is weird, the name shouldn't be allocated, it is supposed to be a
> fixed string to make it easy to find the driver name in the code base.

Will fix.


>> +static int idxd_setup_mdev_auxdev(struct idxd_device *idxd)
>> +{
>> +	struct auxiliary_device *auxdev;
>> +	struct device *dev = &idxd->pdev->dev;
>> +	int rc;
>> +
>> +	if (!IS_ENABLED(CONFIG_VFIO_MDEV_IDXD))
>> +		return 0;
>> +
>> +	auxdev = kzalloc(sizeof(*auxdev), GFP_KERNEL);
>> +	if (!auxdev)
>> +		return -ENOMEM;
>> +
>> +	auxdev->name = kasprintf(GFP_KERNEL, "mdev-%s", idxd_name[idxd->type]);
>> +	if (!auxdev->name) {
>> +		rc = -ENOMEM;
>> +		goto err_name;
>> +	}
>> +
>> +	dev_dbg(&idxd->pdev->dev, "aux dev mdev: %s\n", auxdev->name);
>> +
>> +	auxdev->dev.parent = dev;
>> +	auxdev->dev.release = idxd_auxdev_release;
>> +	auxdev->id = idxd->id;
>> +
>> +	rc = auxiliary_device_init(auxdev);
>> +	if (rc < 0) {
>> +		dev_err(dev, "Failed to init aux dev: %d\n", rc);
>> +		goto err_auxdev;
>> +	}
> Put the init earlier so it can handle the error unwinds

I think with auxdev embedded, there's really not much going on so I 
think this resolves itself.


>> +	rc = auxiliary_device_add(auxdev);
>> +	if (rc < 0) {
>> +		dev_err(dev, "Failed to add aux dev: %d\n", rc);
>> +		goto err_auxdev;
>> +	}
>> +
>> +	idxd->mdev_auxdev = auxdev;
>> +	dev_set_drvdata(&auxdev->dev, idxd);
> No to using drvdata, and this is in the wrong order anyhow.
>
>> +	return 0;
>> +
>> + err_auxdev:
>> +	kfree(auxdev->name);
>> + err_name:
>> +	kfree(auxdev);
>> +	return rc;
>> +}
>> +
>>   static int idxd_probe(struct idxd_device *idxd)
>>   {
>>   	struct pci_dev *pdev = idxd->pdev;
>> @@ -434,11 +502,19 @@ static int idxd_probe(struct idxd_device *idxd)
>>   		goto err_idr_fail;
>>   	}
>>   
>> +	rc = idxd_setup_mdev_auxdev(idxd);
>> +	if (rc < 0)
>> +		goto err_auxdev_fail;
>> +
>>   	idxd->major = idxd_cdev_get_major(idxd);
>>   
>>   	dev_dbg(dev, "IDXD device %d probed successfully\n", idxd->id);
>>   	return 0;
>>   
>> + err_auxdev_fail:
>> +	mutex_lock(&idxd_idr_lock);
>> +	idr_remove(&idxd_idrs[idxd->type], idxd->id);
>> +	mutex_unlock(&idxd_idr_lock);
> Probably wrong to order things like this..

How should it be ordered?

>
> Also somehow this has a
>
> 	idxd = devm_kzalloc(dev, sizeof(struct idxd_device), GFP_KERNEL);
>
> but the idxd has a kref'd struct device in it:

So the conf_dev is a struct device that let the driver do configuration 
of the device and other components through sysfs. It's a child device to 
the pdev. It should have no relation to the auxdev. The confdevs for 
each component should not be released until the physical device is 
released. For the mdev case, the auxdev shouldn't be released until the 
removal of the pdev as well since it is a child of the pdev also.

pdev --- device conf_dev --- wq conf_dev

     |                   |--- engine conf_dev

     |                   |--- group conf_dev

     |--- aux_dev

>
> struct idxd_device {
> 	enum idxd_type type;
> 	struct device conf_dev;
>
> So that's not right either
>
> You'll need to fix the lifetime model for idxd_device before you get
> to adding auxdevices

Can you kindly expand on how it's suppose to look like please?


>
>> +static int idxd_mdev_host_init(struct idxd_device *idxd)
>> +{
>> +	/* FIXME: Fill in later */
>> +	return 0;
>> +}
>> +
>> +static int idxd_mdev_host_release(struct idxd_device *idxd)
>> +{
>> +	/* FIXME: Fill in later */
>> +	return 0;
>> +}
> Don't leave empty stubs like this, just provide the whole driver in
> the next patch

Ok will do that.


>
>> +static int idxd_mdev_aux_probe(struct auxiliary_device *auxdev,
>> +			       const struct auxiliary_device_id *id)
>> +{
>> +	struct idxd_device *idxd = dev_get_drvdata(&auxdev->dev);
> Continuing no to using drvdata, must use container_of
>
>> +	int rc;
>> +
>> +	rc = idxd_mdev_host_init(idxd);
> And why add this indirection? Just write what it here

ok


>
>> +static struct idxd_mdev_aux_drv idxd_mdev_aux_drv = {
>> +	.auxiliary_drv = {
>> +		.id_table = idxd_mdev_auxbus_id_table,
>> +		.probe = idxd_mdev_aux_probe,
>> +		.remove = idxd_mdev_aux_remove,
>> +	},
>> +};
> Why idxd_mdev_aux_drv ? Does a later patch add something here?


Yes. There is a callback function that's added later. But I can code it 
so that it gets changed later on.


>
>> +static int idxd_mdev_auxdev_drv_register(struct idxd_mdev_aux_drv *drv)
>> +{
>> +	return auxiliary_driver_register(&drv->auxiliary_drv);
>> +}
>> +
>> +static void idxd_mdev_auxdev_drv_unregister(struct idxd_mdev_aux_drv *drv)
>> +{
>> +	auxiliary_driver_unregister(&drv->auxiliary_drv);
>> +}
>> +
>> +module_driver(idxd_mdev_aux_drv, idxd_mdev_auxdev_drv_register, idxd_mdev_auxdev_drv_unregister);
> There is some auxillary driver macro that does this boilerplate

Ok thanks.


>
> Jason
