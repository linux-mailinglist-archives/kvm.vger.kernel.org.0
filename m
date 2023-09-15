Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7865E7A28E5
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 23:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbjIOVDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 17:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbjIOVCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 17:02:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F8FD19BC
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 14:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694811631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+DYMbVRs8xDCtF10EOXfbPaBUn/i3lpJXJRzM5wjU8=;
        b=TDIao2OSmt3/hbYnEI6zpayIhv7WET41JtbuHGWCqFBsjeQzXoUkuWx7OKSszBPXpGWUpA
        EaZS9S5wzAtDObNYh29Q9lHne7PArr+Uvm3X8bCaqs8n3XXG004Rp1uc8q9ckoW89PoTrr
        8uYlQq/2U9QgLhEKOpzA1tIcJ2240eI=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-402d3ay2MSKX0jaO8siVPw-1; Fri, 15 Sep 2023 17:00:29 -0400
X-MC-Unique: 402d3ay2MSKX0jaO8siVPw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-778d823038bso240858639f.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 14:00:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694811629; x=1695416429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+DYMbVRs8xDCtF10EOXfbPaBUn/i3lpJXJRzM5wjU8=;
        b=mXhf1mkTS25Xc1kI+jDrhgZyQlyOvGGL0XPlM0O8wcIHilrpVJR8encjlasT5KGQ4U
         TJlHmoTqZhYkxRvxAJPDZfDX+hgCTotIReeovT0bNgdpYvno8OE3fmKDQE02T8oqOhdq
         GixTm8XzoTh5Fu4wvgcqBq3lesefTU4aXhnb/l2Ry7vRBPG8UstwJDSoC1evTt9eMjFu
         /5bjEsVgyM/tHSFsQEaXLgF9sIAyTOVoyrgh6Jr/58jXPEHxrFg1pBNXqM9MjDFA/LWz
         3FiWeqjEYJNku5uD6FPRTPkJDb3pCTCAdb/TLgmELuv9gcSFdPhkuZty8lvToJwBmvOt
         3Pnw==
X-Gm-Message-State: AOJu0YwthuXaKfUjsRRkIddBr2hKzenDUBmaNRjoUoi/BsaR3gcied2h
        T7wSdfiebS2+NkKiGaGuzP2LONP8DDwqfRW31ssav3pIdb3JO4U/J6PauLYGbk4ehAZjw3VRKBc
        OttaAZaUhD+LZ
X-Received: by 2002:a5d:84c5:0:b0:790:f866:d71b with SMTP id z5-20020a5d84c5000000b00790f866d71bmr2760282ior.13.1694811628767;
        Fri, 15 Sep 2023 14:00:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFE+/7b23ZVRSvv5lHFNO4h2ccvzwGYKSWfaFtCFygGCrGuaa4xKbx1/uqLbQv6HC7qWqXDvw==
X-Received: by 2002:a5d:84c5:0:b0:790:f866:d71b with SMTP id z5-20020a5d84c5000000b00790f866d71bmr2760269ior.13.1694811628471;
        Fri, 15 Sep 2023 14:00:28 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id f4-20020a5d8144000000b00790d81167a7sm1326279ioo.2.2023.09.15.14.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 14:00:27 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:00:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     liulongfang <liulongfang@huawei.com>
Cc:     <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>, <bcreeley@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: Re: [PATCH v15 1/2] vfio/migration: Add debugfs to live migration
 driver
Message-ID: <20230915150026.06bea533.alex.williamson@redhat.com>
In-Reply-To: <20230901023606.47587-2-liulongfang@huawei.com>
References: <20230901023606.47587-1-liulongfang@huawei.com>
        <20230901023606.47587-2-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Sep 2023 10:36:05 +0800
liulongfang <liulongfang@huawei.com> wrote:

> From: Longfang Liu <liulongfang@huawei.com>
> 
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
>     +-------------------------------------------+
>     |                                           |
>     |                                           |
>     |                  QEMU                     |
>     |                                           |
>     |                                           |
>     +---+----------------------------+----------+
>         |      ^                     |      ^
>         |      |                     |      |
>         |      |                     |      |
>         v      |                     v      |
>      +---------+--+               +---------+--+
>      |src vfio_dev|               |dst vfio_dev|
>      +--+---------+               +--+---------+
>         |      ^                     |      ^
>         |      |                     |      |
>         v      |                     |      |
>    +-----------+----+           +-----------+----+
>    |src dev debugfs |           |dst dev debugfs |
>    +----------------+           +----------------+
> 
> The entire debugfs directory will be based on the definition of
> the CONFIG_DEBUG_FS macro. If this macro is not enabled, the
> interfaces in vfio.h will be empty definitions, and the creation
> and initialization of the debugfs directory will not be executed.
> 
>    vfio
>     |
>     +---<dev_name1>
>     |    +---migration
>     |        +--state
>     |
>     +---<dev_name2>
>          +---migration
>              +--state
> 
> debugfs will create a public root directory "vfio" file.
> then create a dev_name() file for each live migration device.
> First, create a unified state acquisition file of "migration"
> in this device directory.
> Then, create a public live migration state lookup file "state"
> Finally, create a directory file based on the device type,
> and then create the device's own debugging files under
> this directory file.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/vfio/Makefile       |  1 +
>  drivers/vfio/vfio.h         | 14 +++++++
>  drivers/vfio/vfio_debugfs.c | 80 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_main.c    |  5 ++-
>  include/linux/vfio.h        |  7 ++++
>  5 files changed, 106 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/vfio/vfio_debugfs.c
> 
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index c82ea032d352..7934ac829989 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -8,6 +8,7 @@ vfio-$(CONFIG_VFIO_GROUP) += group.o
>  vfio-$(CONFIG_IOMMUFD) += iommufd.o
>  vfio-$(CONFIG_VFIO_CONTAINER) += container.o
>  vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> +vfio-$(CONFIG_DEBUG_FS) += vfio_debugfs.o
>  
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 307e3f29b527..09b00757d0bb 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -448,4 +448,18 @@ static inline void vfio_device_put_kvm(struct vfio_device *device)
>  }
>  #endif
>  
> +#ifdef CONFIG_DEBUG_FS
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
> +#endif /* CONFIG_DEBUG_FS */
> +
>  #endif
> diff --git a/drivers/vfio/vfio_debugfs.c b/drivers/vfio/vfio_debugfs.c
> new file mode 100644
> index 000000000000..cd6c01437475
> --- /dev/null
> +++ b/drivers/vfio/vfio_debugfs.c
> @@ -0,0 +1,80 @@
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
> +	ret = vdev->mig_ops->migration_get_state(vdev, &state);
> +	if (ret)
> +		return -EINVAL;
> +
> +	switch (state) {
> +	case VFIO_DEVICE_STATE_RUNNING:
> +		seq_printf(seq, "%s\n", "RUNNING");
> +		break;
> +	case VFIO_DEVICE_STATE_STOP_COPY:
> +		seq_printf(seq, "%s\n", "STOP_COPY");
> +		break;
> +	case VFIO_DEVICE_STATE_STOP:
> +		seq_printf(seq, "%s\n", "STOP");
> +		break;
> +	case VFIO_DEVICE_STATE_RESUMING:
> +		seq_printf(seq, "%s\n", "RESUMING");
> +		break;
> +	case VFIO_DEVICE_STATE_RUNNING_P2P:
> +		seq_printf(seq, "%s\n", "RUNNING_P2P");
> +		break;
> +	case VFIO_DEVICE_STATE_ERROR:
> +		seq_printf(seq, "%s\n", "ERROR");

Please order these the same as enum vfio_device_mig_state, we're also
missing a couple states, ie. PRE_COPY and PRE_COPY_P2P.  Can we use any
compiler tricks to create a build error when these are out of sync?

> +		break;
> +	default:
> +		seq_printf(seq, "%s\n", "Invalid");
> +	}
> +
> +	return 0;
> +}
> +
> +void vfio_device_debugfs_init(struct vfio_device *vdev)
> +{
> +	struct dentry *vfio_dev_migration = NULL;
> +	struct device *dev = &vdev->device;

Nit, both of these could be defined within the scope of the mig_ops
test below.

> +
> +	vdev->debug_root = debugfs_create_dir(dev_name(vdev->dev), vfio_debugfs_root);
> +
> +	if (vdev->mig_ops) {
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
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index cfad824d9aa2..8a7456f89842 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -309,7 +309,7 @@ static int __vfio_register_dev(struct vfio_device *device,
>  
>  	/* Refcounting can't start until the driver calls register */
>  	refcount_set(&device->refcount, 1);
> -
> +	vfio_device_debugfs_init(device);
>  	vfio_device_group_register(device);
>  
>  	return 0;
> @@ -378,6 +378,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  		}
>  	}
>  
> +	vfio_device_debugfs_exit(device);
>  	/* Balances vfio_device_set_group in register path */
>  	vfio_device_remove_group(device);
>  }

init/exit calls should try to be symmetric, if we call init before
vfio_device_group_register() then we should call exit after
vfio_device_group_unregister().  In this case, why shouldn't init be
the last call in __vfio_register_dev() and exit the first call in
vfio_unregister_group_dev()?

> @@ -1662,6 +1663,7 @@ static int __init vfio_init(void)
>  	if (ret)
>  		goto err_alloc_dev_chrdev;
>  
> +	vfio_debugfs_create_root();
>  	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>  	return 0;
>  
> @@ -1684,6 +1686,7 @@ static void __exit vfio_cleanup(void)
>  	vfio_virqfd_exit();
>  	vfio_group_cleanup();
>  	xa_destroy(&vfio_device_set_xa);
> +	vfio_debugfs_remove_root();
>  }

Same, if we create it last, let's remove it first.  The above creates
it last and removes it last.  Thanks,

Alex

>  
>  module_init(vfio_init);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 454e9295970c..769d7af86225 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -69,6 +69,13 @@ struct vfio_device {
>  	u8 iommufd_attached:1;
>  #endif
>  	u8 cdev_opened:1;
> +#ifdef CONFIG_DEBUG_FS
> +	/*
> +	 * debug_root is a static property of the vfio_device
> +	 * which must be set prior to registering the vfio_device.
> +	 */
> +	struct dentry *debug_root;
> +#endif
>  };
>  
>  /**

