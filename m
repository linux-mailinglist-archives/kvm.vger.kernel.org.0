Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AD5B9389
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 16:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfITO6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 10:58:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57554 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725867AbfITO6A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Sep 2019 10:58:00 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8KEgeu6014364;
        Fri, 20 Sep 2019 10:57:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v4xd66rq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 10:57:52 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8KEh4Ov015557;
        Fri, 20 Sep 2019 10:57:52 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v4xd66rpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 10:57:52 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8KEjuBI018221;
        Fri, 20 Sep 2019 14:57:51 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 2v3vbuprg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 14:57:51 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8KEvlMn39649560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 14:57:47 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C14937805E;
        Fri, 20 Sep 2019 14:57:47 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B97FC7805C;
        Fri, 20 Sep 2019 14:57:45 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.85.141.73])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 14:57:45 +0000 (GMT)
Subject: Re: [PATCH v4 4/4] vfio: pci: Using a device region to retrieve zPCI
 information
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     sebott@linux.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        heiko.carstens@de.ibm.com, robin.murphy@arm.com, gor@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com
References: <1567815231-17940-1-git-send-email-mjrosato@linux.ibm.com>
 <1567815231-17940-5-git-send-email-mjrosato@linux.ibm.com>
 <20190919165750.73675997@x1.home>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Openpgp: preference=signencrypt
Message-ID: <adeb6955-81a4-23c3-d73e-f02eb4c0fde1@linux.ibm.com>
Date:   Fri, 20 Sep 2019 10:57:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919165750.73675997@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/19 6:57 PM, Alex Williamson wrote:
> On Fri,  6 Sep 2019 20:13:51 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> From: Pierre Morel <pmorel@linux.ibm.com>
>>
>> We define a new configuration entry for VFIO/PCI, VFIO_PCI_ZDEV
>>
>> When the VFIO_PCI_ZDEV feature is configured we initialize
>> a new device region, VFIO_REGION_SUBTYPE_ZDEV_CLP, to hold
>> the information from the ZPCI device the use
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>  drivers/vfio/pci/Kconfig            |  7 +++
>>  drivers/vfio/pci/Makefile           |  1 +
>>  drivers/vfio/pci/vfio_pci.c         |  9 ++++
>>  drivers/vfio/pci/vfio_pci_private.h | 10 +++++
>>  drivers/vfio/pci/vfio_pci_zdev.c    | 85 +++++++++++++++++++++++++++++++++++++
>>  5 files changed, 112 insertions(+)
>>  create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
>>
>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>> index ac3c1dd..d4562a8 100644
>> --- a/drivers/vfio/pci/Kconfig
>> +++ b/drivers/vfio/pci/Kconfig
>> @@ -45,3 +45,10 @@ config VFIO_PCI_NVLINK2
>>  	depends on VFIO_PCI && PPC_POWERNV
>>  	help
>>  	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
>> +
>> +config VFIO_PCI_ZDEV
>> +	bool "VFIO PCI Generic for ZPCI devices"
>> +	depends on VFIO_PCI && S390
>> +	default y
>> +	help
>> +	  VFIO PCI support for S390 Z-PCI devices
>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>> index f027f8a..781e080 100644
>> --- a/drivers/vfio/pci/Makefile
>> +++ b/drivers/vfio/pci/Makefile
>> @@ -3,5 +3,6 @@
>>  vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
>>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>>  vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
>> +vfio-pci-$(CONFIG_VFIO_PCI_ZDEV) += vfio_pci_zdev.o
>>  
>>  obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index 703948c..b40544a 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -356,6 +356,15 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>>  		}
>>  	}
>>  
>> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV)) {
>> +		ret = vfio_pci_zdev_init(vdev);
>> +		if (ret) {
>> +			dev_warn(&vdev->pdev->dev,
>> +				 "Failed to setup ZDEV regions\n");
>> +			goto disable_exit;
>> +		}
>> +	}
>> +
>>  	vfio_pci_probe_mmaps(vdev);
>>  
>>  	return 0;
>> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
>> index ee6ee91..08e02f5 100644
>> --- a/drivers/vfio/pci/vfio_pci_private.h
>> +++ b/drivers/vfio/pci/vfio_pci_private.h
>> @@ -186,4 +186,14 @@ static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
>>  	return -ENODEV;
>>  }
>>  #endif
>> +
>> +#ifdef CONFIG_VFIO_PCI_ZDEV
>> +extern int vfio_pci_zdev_init(struct vfio_pci_device *vdev);
>> +#else
>> +static inline int vfio_pci_zdev_init(struct vfio_pci_device *vdev)
>> +{
>> +	return -ENODEV;
>> +}
>> +#endif
>> +
>>  #endif /* VFIO_PCI_PRIVATE_H */
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>> new file mode 100644
>> index 0000000..22e2b60
>> --- /dev/null
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -0,0 +1,85 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +/*
>> + * VFIO ZPCI devices support
>> + *
>> + * Copyright (C) IBM Corp. 2019.  All rights reserved.
>> + *	Author: Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +#include <linux/io.h>
>> +#include <linux/pci.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/vfio.h>
>> +#include <linux/vfio_zdev.h>
>> +
>> +#include "vfio_pci_private.h"
>> +
>> +static size_t vfio_pci_zdev_rw(struct vfio_pci_device *vdev,
>> +			       char __user *buf, size_t count, loff_t *ppos,
>> +			       bool iswrite)
>> +{
>> +	struct vfio_region_zpci_info *region;
>> +	struct zpci_dev *zdev;
>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +
>> +	if (!vdev->pdev->bus)
>> +		return -ENODEV;
>> +
>> +	zdev = vdev->pdev->bus->sysdata;
>> +	if (!zdev)
>> +		return -ENODEV;
>> +
>> +	if (pos >= sizeof(*region) || iswrite)
>> +		return -EINVAL;
>> +
>> +	region = vdev->region[index - VFIO_PCI_NUM_REGIONS].data;
>> +	region->dasm = zdev->dma_mask;
>> +	region->start_dma = zdev->start_dma;
>> +	region->end_dma = zdev->end_dma;
>> +	region->msi_addr = zdev->msi_addr;
>> +	region->flags = VFIO_PCI_ZDEV_FLAGS_REFRESH;
> 
> Even more curious what this means, why do we need a flag that's always
> set?  Maybe NOREFRESH if it were ever to exist.>

This flag also has a hardware structure counterpart -- this is
associated with Pierre's comment from the cover letter:

"Note that in the current state we do not use the CLP instructions to
access the firmware but get the information directly from the zdev
device. <...> But we will need this later, eventually in the next
iteration to retrieve values not being saved inside the zdev structure.
like maxstbl and the PCI supported version"

Since this data isn't stored in the zdev, a subsequent patch that pulls
the flag info from the CLP data would set this value intelligently vs
the current hard-coded value.

>> +	region->gid = zdev->pfgid;
>> +	region->mui = zdev->fmb_update;
>> +	region->noi = zdev->max_msi;
>> +	memcpy(region->util_str, zdev->util_str, CLP_UTIL_STR_LEN);
> 
> Just checking, I assume this is dynamic based on it being recreated
> every time, otherwise you'd have created it in the init function and
> just do the below on read, right?  The fields that I can guess what they
> might be don't seem like they'd change.  Comments would be good.

I think you're right and this can be done in init, I'll have a look.

> Thanks,
> 
> Alex
> 
>> +
>> +	count = min(count, (size_t)(sizeof(*region) - pos));
>> +	if (copy_to_user(buf, region, count))
>> +		return -EFAULT;
>> +
>> +	return count;
>> +}
>> +
>> +static void vfio_pci_zdev_release(struct vfio_pci_device *vdev,
>> +				  struct vfio_pci_region *region)
>> +{
>> +	kfree(region->data);
>> +}
>> +
>> +static const struct vfio_pci_regops vfio_pci_zdev_regops = {
>> +	.rw		= vfio_pci_zdev_rw,
>> +	.release	= vfio_pci_zdev_release,
>> +};
>> +
>> +int vfio_pci_zdev_init(struct vfio_pci_device *vdev)
>> +{
>> +	struct vfio_region_zpci_info *region;
>> +	int ret;
>> +
>> +	region = kmalloc(sizeof(*region) + CLP_UTIL_STR_LEN, GFP_KERNEL);
>> +	if (!region)
>> +		return -ENOMEM;
>> +
>> +	ret = vfio_pci_register_dev_region(vdev,
>> +		PCI_VENDOR_ID_IBM | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
>> +		VFIO_REGION_SUBTYPE_ZDEV_CLP,
>> +		&vfio_pci_zdev_regops, sizeof(*region) + CLP_UTIL_STR_LEN,
>> +		VFIO_REGION_INFO_FLAG_READ, region);
>> +
>> +	return ret;
>> +}
> 
> 

