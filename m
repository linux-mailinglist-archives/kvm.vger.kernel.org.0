Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43107CAD26
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbjJPPSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjJPPR7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:17:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74048B4
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697469433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y4eWOrGel0AHpPuDoogCLtYn6AWGTJZhIutExsyeeH0=;
        b=dk14ruQNuHTkOlLXftZmnhP6Dlm7zjJGKiuW6FF1puJe5eg1mqK2AukLtPRDWtvCZbSRqP
        +mcWKz7hM2Tu6acYl1VuovXYga43nB3mWE/5DpFtG4WwCz0LYre/gj32Za9OQsSIgq1C34
        BSfw+Mr0JhMJeZRJGj40hjnqhG7kfB8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-qsJz1s_zMjewEW3uDhYrdw-1; Mon, 16 Oct 2023 11:17:12 -0400
X-MC-Unique: qsJz1s_zMjewEW3uDhYrdw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4197fa36adaso39748071cf.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:17:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697469431; x=1698074231;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4eWOrGel0AHpPuDoogCLtYn6AWGTJZhIutExsyeeH0=;
        b=QhRZXxEjiv3EBqq/9GSE3bXJfnEvHDJgxI6byzVTxWNPmdxLfcyqcRUVRrnP9P4Ljz
         sA+lOtu17cAMFKpjJ10kivOatv7+4WeHb/tqyV4p/i4ecz9rs78iaMAcj0IaD/QFXSiX
         uLSWIhn1exDX4e4oHpqlI6GD5K7cOPCQbbc0GcgU7j7cXQkA34+KDl/1t4rBu/oJJ50d
         JE9g4BvOoLUns4qX1W2gjdERuWXdbKMI/XAijwobsfFwGeYUkefMF0PffksrUNhEuIRM
         HYuMJ/5WjDRSsb3UwW6DvdUYkO7esasDwuV9lHzxBvk9Fs9uUwQLo7HgagzHc7b3jhep
         yotw==
X-Gm-Message-State: AOJu0YxCqCTwHgjc8TKQDTQwEl95cT+TiRSmuwkWxHZqY85Mw+0PXiR/
        16nrwvoZDhoMrjk5qf3EMYKy/JWbKy43DZH0DLt7YBR0VI58j5JL3Fe64vYRka5Uatv9B7D6Dek
        i1WFa/Rv+tLQG
X-Received: by 2002:ac8:5b8e:0:b0:418:1002:cfd8 with SMTP id a14-20020ac85b8e000000b004181002cfd8mr35378659qta.67.1697469431495;
        Mon, 16 Oct 2023 08:17:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfouO36OI09/bnPKrrFbEXKQZyqqDdVFztdSpdKFFQRJ0n70/L5ty7l/F9dJ4HHUwBGdGjhw==
X-Received: by 2002:ac8:5b8e:0:b0:418:1002:cfd8 with SMTP id a14-20020ac85b8e000000b004181002cfd8mr35378641qta.67.1697469431041;
        Mon, 16 Oct 2023 08:17:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id r16-20020ac867d0000000b004199c98f87dsm3100752qtp.74.2023.10.16.08.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 08:17:10 -0700 (PDT)
Message-ID: <dee481c3-f6bd-4ba9-a2d4-528dfb668159@redhat.com>
Date:   Mon, 16 Oct 2023 17:17:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 1/2] vfio/migration: Add debugfs to live migration
 driver
To:     Longfang Liu <liulongfang@huawei.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        jonathan.cameron@huawei.com
Cc:     bcreeley@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org
References: <20231013090441.36417-1-liulongfang@huawei.com>
 <20231013090441.36417-2-liulongfang@huawei.com>
From:   =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clegoate@redhat.com>
Content-Language: en-US
In-Reply-To: <20231013090441.36417-2-liulongfang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Longfang,

On 10/13/23 11:04, Longfang Liu wrote:
> There are multiple devices, software and operational steps involved
> in the process of live migration. An error occurred on any node may
> cause the live migration operation to fail.
> This complex process makes it very difficult to locate and analyze
> the cause when the function fails.
> 
> In order to quickly locate the cause of the problem when the
> live migration fails, I added a set of debugfs to the vfio
> live migration driver.
> 
>      +-------------------------------------------+
>      |                                           |
>      |                                           |
>      |                  QEMU                     |
>      |                                           |
>      |                                           |
>      +---+----------------------------+----------+
>          |      ^                     |      ^
>          |      |                     |      |
>          |      |                     |      |
>          v      |                     v      |
>       +---------+--+               +---------+--+
>       |src vfio_dev|               |dst vfio_dev|
>       +--+---------+               +--+---------+
>          |      ^                     |      ^
>          |      |                     |      |
>          v      |                     |      |
>     +-----------+----+           +-----------+----+
>     |src dev debugfs |           |dst dev debugfs |
>     +----------------+           +----------------+
> 
> The entire debugfs directory will be based on the definition of
> the CONFIG_DEBUG_FS macro. If this macro is not enabled, the
> interfaces in vfio.h will be empty definitions, and the creation
> and initialization of the debugfs directory will not be executed.
> 
>     vfio
>      |
>      +---<dev_name1>
>      |    +---migration
>      |        +--state
>      |
>      +---<dev_name2>
>           +---migration
>               +--state
> 
> debugfs will create a public root directory "vfio" file.
> then create a dev_name() file for each live migration device.
> First, create a unified state acquisition file of "migration"
> in this device directory.
> Then, create a public live migration state lookup file "state".
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>   drivers/vfio/Kconfig      | 10 +++++
>   drivers/vfio/Makefile     |  1 +
>   drivers/vfio/debugfs.c    | 90 +++++++++++++++++++++++++++++++++++++++
>   drivers/vfio/vfio.h       | 14 ++++++
>   drivers/vfio/vfio_main.c  | 14 +++++-
>   include/linux/vfio.h      |  7 +++
>   include/uapi/linux/vfio.h |  1 +
>   7 files changed, 135 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/vfio/debugfs.c
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 6bda6dbb4878..ceae52fd7586 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -80,6 +80,16 @@ config VFIO_VIRQFD
>   	select EVENTFD
>   	default n
>   
> +config VFIO_DEBUGFS
> +	bool "Export VFIO internals in DebugFS"
> +	depends on DEBUG_FS
> +	help
> +	  Allows exposure of VFIO device internals. This option enables
> +	  the use of debugfs by VFIO drivers as required. The device can
> +	  cause the VFIO code create a top-level debug/vfio directory
> +	  during initialization, and then populate a subdirectory with
> +	  entries as required.
> +
>   source "drivers/vfio/pci/Kconfig"
>   source "drivers/vfio/platform/Kconfig"
>   source "drivers/vfio/mdev/Kconfig"
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index c82ea032d352..d43a699d55b1 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -8,6 +8,7 @@ vfio-$(CONFIG_VFIO_GROUP) += group.o
>   vfio-$(CONFIG_IOMMUFD) += iommufd.o
>   vfio-$(CONFIG_VFIO_CONTAINER) += container.o
>   vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> +vfio-$(CONFIG_VFIO_DEBUGFS) += debugfs.o
>   
>   obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>   obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> diff --git a/drivers/vfio/debugfs.c b/drivers/vfio/debugfs.c
> new file mode 100644
> index 000000000000..ae53d6110f47
> --- /dev/null
> +++ b/drivers/vfio/debugfs.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, HiSilicon Ltd.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/vfio.h>
> +#include "vfio.h"
> +
> +static struct dentry *vfio_debugfs_root;
> +
> +static int vfio_device_state_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev = seq->private;
> +	struct vfio_device *vdev = container_of(vf_dev, struct vfio_device, device);
> +	enum vfio_device_mig_state state;
> +	int ret;
> +
> +	BUILD_BUG_ON(VFIO_DEVICE_STATE_NR !=
> +		VFIO_DEVICE_STATE_PRE_COPY_P2P + 1);
> +
> +	ret = vdev->mig_ops->migration_get_state(vdev, &state);
> +	if (ret)
> +		return -EINVAL;
> +
> +	switch (state) {
> +	case VFIO_DEVICE_STATE_ERROR:
> +		seq_printf(seq, "%s\n", "ERROR");
> +		break;
> +	case VFIO_DEVICE_STATE_STOP:
> +		seq_printf(seq, "%s\n", "STOP");
> +		break;
> +	case VFIO_DEVICE_STATE_RUNNING:
> +		seq_printf(seq, "%s\n", "RUNNING");
> +		break;
> +	case VFIO_DEVICE_STATE_STOP_COPY:
> +		seq_printf(seq, "%s\n", "STOP_COPY");
> +		break;
> +	case VFIO_DEVICE_STATE_RESUMING:
> +		seq_printf(seq, "%s\n", "RESUMING");
> +		break;
> +	case VFIO_DEVICE_STATE_RUNNING_P2P:
> +		seq_printf(seq, "%s\n", "RUNNING_P2P");
> +		break;
> +	case VFIO_DEVICE_STATE_PRE_COPY:
> +		seq_printf(seq, "%s\n", "PRE_COPY");
> +		break;
> +	case VFIO_DEVICE_STATE_PRE_COPY_P2P:
> +		seq_printf(seq, "%s\n", "PRE_COPY_P2P");
> +		break;
> +	default:
> +		seq_printf(seq, "%s\n", "Invalid");

seq_puts() is more appropriate than seq_printf() above.

I would suggest to add an array or some helper, that the VFIO drivers
could use to debug the migration flow with pr_* primitives. It can be
done later.


> +	}
> +
> +	return 0;
> +}
> +
> +void vfio_device_debugfs_init(struct vfio_device *vdev)
> +{
> +	struct device *dev = &vdev->device;
> +
> +	vdev->debug_root = debugfs_create_dir(dev_name(vdev->dev), vfio_debugfs_root);
> +
> +	if (vdev->mig_ops) {
> +		struct dentry *vfio_dev_migration = NULL;

mig_dir maybe ?

It would be easier to understand the nature of the variable IMHO.

> +
> +		vfio_dev_migration = debugfs_create_dir("migration", vdev->debug_root);
> +		debugfs_create_devm_seqfile(dev, "state", vfio_dev_migration,
> +					  vfio_device_state_read);
> +	}
> +}
> +
> +void vfio_device_debugfs_exit(struct vfio_device *vdev)
> +{
> +	debugfs_remove_recursive(vdev->debug_root);
> +}
> +
> +void vfio_debugfs_create_root(void)
> +{
> +	vfio_debugfs_root = debugfs_create_dir("vfio", NULL);
> +}
> +
> +void vfio_debugfs_remove_root(void)
> +{
> +	debugfs_remove_recursive(vfio_debugfs_root);
> +	vfio_debugfs_root = NULL;
> +}
> +
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 307e3f29b527..bde84ad344e5 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -448,4 +448,18 @@ static inline void vfio_device_put_kvm(struct vfio_device *device)
>   }
>   #endif
>   
> +#ifdef CONFIG_VFIO_DEBUGFS
> +void vfio_debugfs_create_root(void);
> +void vfio_debugfs_remove_root(void);
> +
> +void vfio_device_debugfs_init(struct vfio_device *vdev);
> +void vfio_device_debugfs_exit(struct vfio_device *vdev);
> +#else
> +static inline void vfio_debugfs_create_root(void) { }
> +static inline void vfio_debugfs_remove_root(void) { }
> +
> +static inline void vfio_device_debugfs_init(struct vfio_device *vdev) { }
> +static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { }
> +#endif /* CONFIG_VFIO_DEBUGFS */
> +
>   #endif
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index e31e1952d7b8..9aec4c22f051 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -309,7 +309,6 @@ static int __vfio_register_dev(struct vfio_device *device,
>   
>   	/* Refcounting can't start until the driver calls register */
>   	refcount_set(&device->refcount, 1);
> -

superfluous change.

>   	vfio_device_group_register(device);
>   
>   	return 0;
> @@ -320,7 +319,15 @@ static int __vfio_register_dev(struct vfio_device *device,
>   
>   int vfio_register_group_dev(struct vfio_device *device)
>   {
> -	return __vfio_register_dev(device, VFIO_IOMMU);
> +	int ret;
> +
> +	ret = __vfio_register_dev(device, VFIO_IOMMU);
> +	if (ret)
> +		return ret;
> +
> +	vfio_device_debugfs_init(device);

Can it be called from __vfio_register_dev() instead ? and mdev devices
would get debugfs support also.

Thanks,

C.

> +
> +	return 0;
>   }
>   EXPORT_SYMBOL_GPL(vfio_register_group_dev);
>   
> @@ -378,6 +385,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>   		}
>   	}
>   
> +	vfio_device_debugfs_exit(device);
>   	/* Balances vfio_device_set_group in register path */
>   	vfio_device_remove_group(device);
>   }
> @@ -1676,6 +1684,7 @@ static int __init vfio_init(void)
>   	if (ret)
>   		goto err_alloc_dev_chrdev;
>   
> +	vfio_debugfs_create_root();
>   	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>   	return 0;
>   
> @@ -1691,6 +1700,7 @@ static int __init vfio_init(void)
>   
>   static void __exit vfio_cleanup(void)
>   {
> +	vfio_debugfs_remove_root();
>   	ida_destroy(&vfio.device_ida);
>   	vfio_cdev_cleanup();
>   	class_destroy(vfio.device_class);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 454e9295970c..769d7af86225 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -69,6 +69,13 @@ struct vfio_device {
>   	u8 iommufd_attached:1;
>   #endif
>   	u8 cdev_opened:1;
> +#ifdef CONFIG_DEBUG_FS
> +	/*
> +	 * debug_root is a static property of the vfio_device
> +	 * which must be set prior to registering the vfio_device.
> +	 */
> +	struct dentry *debug_root;
> +#endif
>   };
>   
>   /**
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 7f5fb010226d..2b68e6cdf190 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1219,6 +1219,7 @@ enum vfio_device_mig_state {
>   	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>   	VFIO_DEVICE_STATE_PRE_COPY = 6,
>   	VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
> +	VFIO_DEVICE_STATE_NR,
>   };
>   
>   /**

