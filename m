Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B4C7C7F93
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 10:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjJMIJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 04:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjJMIJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 04:09:53 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12B9BE;
        Fri, 13 Oct 2023 01:09:50 -0700 (PDT)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4S6Jx40TlWzVjqg;
        Fri, 13 Oct 2023 16:06:16 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm000005.china.huawei.com (7.193.23.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 13 Oct 2023 16:09:48 +0800
Subject: Re: [PATCH v16 1/2] vfio/migration: Add debugfs to live migration
 driver
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>, <bcreeley@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20230926093356.56014-1-liulongfang@huawei.com>
 <20230926093356.56014-2-liulongfang@huawei.com>
 <20231003132630.764d9488.alex.williamson@redhat.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <8a25fd59-0690-cef0-95e2-cdc1a8b54955@huawei.com>
Date:   Fri, 13 Oct 2023 16:09:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231003132630.764d9488.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.121.110]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/4 3:26, Alex Williamson wrote:
> On Tue, 26 Sep 2023 17:33:55 +0800
> liulongfang <liulongfang@huawei.com> wrote:
> 
>> From: Longfang Liu <liulongfang@huawei.com>
>>
>> There are multiple devices, software and operational steps involved
>> in the process of live migration. An error occurred on any node may
>> cause the live migration operation to fail.
>> This complex process makes it very difficult to locate and analyze
>> the cause when the function fails.
>>
>> In order to quickly locate the cause of the problem when the
>> live migration fails, I added a set of debugfs to the vfio
>> live migration driver.
>>
>>     +-------------------------------------------+
>>     |                                           |
>>     |                                           |
>>     |                  QEMU                     |
>>     |                                           |
>>     |                                           |
>>     +---+----------------------------+----------+
>>         |      ^                     |      ^
>>         |      |                     |      |
>>         |      |                     |      |
>>         v      |                     v      |
>>      +---------+--+               +---------+--+
>>      |src vfio_dev|               |dst vfio_dev|
>>      +--+---------+               +--+---------+
>>         |      ^                     |      ^
>>         |      |                     |      |
>>         v      |                     |      |
>>    +-----------+----+           +-----------+----+
>>    |src dev debugfs |           |dst dev debugfs |
>>    +----------------+           +----------------+
>>
>> The entire debugfs directory will be based on the definition of
>> the CONFIG_DEBUG_FS macro. If this macro is not enabled, the
>> interfaces in vfio.h will be empty definitions, and the creation
>> and initialization of the debugfs directory will not be executed.
>>
>>    vfio
>>     |
>>     +---<dev_name1>
>>     |    +---migration
>>     |        +--state
>>     |
>>     +---<dev_name2>
>>          +---migration
>>              +--state
>>
>> debugfs will create a public root directory "vfio" file.
>> then create a dev_name() file for each live migration device.
>> First, create a unified state acquisition file of "migration"
>> in this device directory.
>> Then, create a public live migration state lookup file "state"
>> Finally, create a directory file based on the device type,
>> and then create the device's own debugging files under
>> this directory file.
> 
> We don't actually do the thing claimed in this last statement.
>  

OK, I will modify it in the next version.

>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  drivers/vfio/Makefile       |  1 +
>>  drivers/vfio/vfio.h         | 14 ++++++
>>  drivers/vfio/vfio_debugfs.c | 87 +++++++++++++++++++++++++++++++++++++
>>  drivers/vfio/vfio_main.c    | 14 +++++-
>>  include/linux/vfio.h        |  7 +++
>>  5 files changed, 121 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/vfio/vfio_debugfs.c
>>
>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>> index c82ea032d352..7934ac829989 100644
>> --- a/drivers/vfio/Makefile
>> +++ b/drivers/vfio/Makefile
>> @@ -8,6 +8,7 @@ vfio-$(CONFIG_VFIO_GROUP) += group.o
>>  vfio-$(CONFIG_IOMMUFD) += iommufd.o
>>  vfio-$(CONFIG_VFIO_CONTAINER) += container.o
>>  vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
>> +vfio-$(CONFIG_DEBUG_FS) += vfio_debugfs.o
> 
> I see that other subsystems create Kconfig entries allowing more fine
> grained control of DEBUGFS support.  Wouldn't it make sense to have a
> VFIO_DEBUGFS config option, similar to IOMMU_DEBUGFS?
>
OK, I create a version with VFIO_DEBUGFS

> Also, with our trend towards less redundant file naming, this could
> just be debugfs.[co].
>

OK.

>>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
>> index 307e3f29b527..09b00757d0bb 100644
>> --- a/drivers/vfio/vfio.h
>> +++ b/drivers/vfio/vfio.h
>> @@ -448,4 +448,18 @@ static inline void vfio_device_put_kvm(struct vfio_device *device)
>>  }
>>  #endif
>>  
>> +#ifdef CONFIG_DEBUG_FS
>> +void vfio_debugfs_create_root(void);
>> +void vfio_debugfs_remove_root(void);
>> +
>> +void vfio_device_debugfs_init(struct vfio_device *vdev);
>> +void vfio_device_debugfs_exit(struct vfio_device *vdev);
>> +#else
>> +static inline void vfio_debugfs_create_root(void) { }
>> +static inline void vfio_debugfs_remove_root(void) { }
>> +
>> +static inline void vfio_device_debugfs_init(struct vfio_device *vdev) { }
>> +static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { }
>> +#endif /* CONFIG_DEBUG_FS */
>> +
>>  #endif
>> diff --git a/drivers/vfio/vfio_debugfs.c b/drivers/vfio/vfio_debugfs.c
>> new file mode 100644
>> index 000000000000..b79bdef08357
>> --- /dev/null
>> +++ b/drivers/vfio/vfio_debugfs.c
>> @@ -0,0 +1,87 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2023, HiSilicon Ltd.
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/debugfs.h>
>> +#include <linux/seq_file.h>
>> +#include <linux/vfio.h>
>> +#include "vfio.h"
>> +
>> +static struct dentry *vfio_debugfs_root;
>> +
>> +static int vfio_device_state_read(struct seq_file *seq, void *data)
>> +{
>> +	struct device *vf_dev = seq->private;
>> +	struct vfio_device *vdev = container_of(vf_dev, struct vfio_device, device);
>> +	enum vfio_device_mig_state state;
>> +	int ret;
>> +
>> +	ret = vdev->mig_ops->migration_get_state(vdev, &state);
>> +	if (ret)
>> +		return -EINVAL;
>> +
>> +	switch (state) {
>> +	case VFIO_DEVICE_STATE_STOP:
>> +		seq_printf(seq, "%s\n", "STOP");
>> +		break;
>> +	case VFIO_DEVICE_STATE_RUNNING:
>> +		seq_printf(seq, "%s\n", "RUNNING");
>> +		break;
>> +	case VFIO_DEVICE_STATE_STOP_COPY:
>> +		seq_printf(seq, "%s\n", "STOP_COPY");
>> +		break;
>> +	case VFIO_DEVICE_STATE_RESUMING:
>> +		seq_printf(seq, "%s\n", "RESUMING");
>> +		break;
>> +	case VFIO_DEVICE_STATE_RUNNING_P2P:
>> +		seq_printf(seq, "%s\n", "RUNNING_P2P");
>> +		break;
>> +	case VFIO_DEVICE_STATE_PRE_COPY:
>> +		seq_printf(seq, "%s\n", "PRE_COPY");
>> +		break;
>> +	case VFIO_DEVICE_STATE_PRE_COPY_P2P:
>> +		seq_printf(seq, "%s\n", "PRE_COPY_P2P");
>> +		break;
>> +	case VFIO_DEVICE_STATE_ERROR:
>              ^^^^^^^^^^^^^^^^^^^^^^^
> 
>> +		seq_printf(seq, "%s\n", "ERROR");
>> +		break;
>> +	default:
>> +		seq_printf(seq, "%s\n", "Invalid");
>> +	}
> 
> Not exactly in the order they're defined:
> 
> enum vfio_device_mig_state {
>         VFIO_DEVICE_STATE_ERROR = 0,
>         ^^^^^^^^^^^^^^^^^^^^^^^
>         VFIO_DEVICE_STATE_STOP = 1,
>         VFIO_DEVICE_STATE_RUNNING = 2,
> 	...
> 
> I also suggested last time some means to keep this in sync with the set
> of states defined.  Maybe there are better suggestions, but one way to
> do that could be:
> 
> diff --git a/drivers/vfio/vfio_debugfs.c b/drivers/vfio/vfio_debugfs.c
> index ee6b1831b3e5..1ec90b90d150 100644
> --- a/drivers/vfio/vfio_debugfs.c
> +++ b/drivers/vfio/vfio_debugfs.c
> @@ -18,6 +18,9 @@ static int vfio_device_state_read(struct seq_file *seq, void *data)
>         enum vfio_device_mig_state state;
>         int ret;
>  
> +       BUILD_BUG_ON(VFIO_DEVICE_STATE_NR !=
> +                    VFIO_DEVICE_STATE_PRE_COPY_P2P + 1);
> +
>         ret = vdev->mig_ops->migration_get_state(vdev, &state);
>         if (ret)
>                 return -EINVAL;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 7f5fb010226d..2b68e6cdf190 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1219,6 +1219,7 @@ enum vfio_device_mig_state {
>         VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>         VFIO_DEVICE_STATE_PRE_COPY = 6,
>         VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
> +       VFIO_DEVICE_STATE_NR,
>  };
>  
>  /**
> 
> Thanks,
> Alex
>

OK, I will modify it in the next version

Thanks,
Longfang

> 
>> +
>> +	return 0;
>> +}
>> +
>> +void vfio_device_debugfs_init(struct vfio_device *vdev)
>> +{
>> +	struct device *dev = &vdev->device;
>> +
>> +	vdev->debug_root = debugfs_create_dir(dev_name(vdev->dev), vfio_debugfs_root);
>> +
>> +	if (vdev->mig_ops) {
>> +		struct dentry *vfio_dev_migration = NULL;
>> +
>> +		vfio_dev_migration = debugfs_create_dir("migration", vdev->debug_root);
>> +		debugfs_create_devm_seqfile(dev, "state", vfio_dev_migration,
>> +					  vfio_device_state_read);
>> +	}
>> +}
>> +
>> +void vfio_device_debugfs_exit(struct vfio_device *vdev)
>> +{
>> +	debugfs_remove_recursive(vdev->debug_root);
>> +}
>> +
>> +void vfio_debugfs_create_root(void)
>> +{
>> +	vfio_debugfs_root = debugfs_create_dir("vfio", NULL);
>> +}
>> +
>> +void vfio_debugfs_remove_root(void)
>> +{
>> +	debugfs_remove_recursive(vfio_debugfs_root);
>> +	vfio_debugfs_root = NULL;
>> +}
>> +
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index cfad824d9aa2..4e3ced20d2d1 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -309,7 +309,6 @@ static int __vfio_register_dev(struct vfio_device *device,
>>  
>>  	/* Refcounting can't start until the driver calls register */
>>  	refcount_set(&device->refcount, 1);
>> -
>>  	vfio_device_group_register(device);
>>  
>>  	return 0;
>> @@ -320,7 +319,15 @@ static int __vfio_register_dev(struct vfio_device *device,
>>  
>>  int vfio_register_group_dev(struct vfio_device *device)
>>  {
>> -	return __vfio_register_dev(device, VFIO_IOMMU);
>> +	int ret;
>> +
>> +	ret = __vfio_register_dev(device, VFIO_IOMMU);
>> +	if (ret)
>> +		return ret;
>> +
>> +	vfio_device_debugfs_init(device);
>> +
>> +	return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_register_group_dev);
>>  
>> @@ -378,6 +385,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>>  		}
>>  	}
>>  
>> +	vfio_device_debugfs_exit(device);
>>  	/* Balances vfio_device_set_group in register path */
>>  	vfio_device_remove_group(device);
>>  }
>> @@ -1662,6 +1670,7 @@ static int __init vfio_init(void)
>>  	if (ret)
>>  		goto err_alloc_dev_chrdev;
>>  
>> +	vfio_debugfs_create_root();
>>  	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>>  	return 0;
>>  
>> @@ -1677,6 +1686,7 @@ static int __init vfio_init(void)
>>  
>>  static void __exit vfio_cleanup(void)
>>  {
>> +	vfio_debugfs_remove_root();
>>  	ida_destroy(&vfio.device_ida);
>>  	vfio_cdev_cleanup();
>>  	class_destroy(vfio.device_class);
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index 454e9295970c..769d7af86225 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -69,6 +69,13 @@ struct vfio_device {
>>  	u8 iommufd_attached:1;
>>  #endif
>>  	u8 cdev_opened:1;
>> +#ifdef CONFIG_DEBUG_FS
>> +	/*
>> +	 * debug_root is a static property of the vfio_device
>> +	 * which must be set prior to registering the vfio_device.
>> +	 */
>> +	struct dentry *debug_root;
>> +#endif
>>  };
>>  
>>  /**
> 
> .
> 
