Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CA064E249
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 21:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiLOUZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 15:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLOUZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 15:25:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754F327CE8
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 12:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671135862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=t6fm+oSV8oyjIgUEqoII+1G68WCI6elRrYgUjqSdR64=;
        b=PtKtcIGtywN3jvUw+wW/yYGN4/TCVaYctL39onEOLKDobDahplqE70whIHTgfG89ttDzJO
        ILiXSaLwr5ZbBvdui/mrjTx4XvQFWjyynCYP2Qi5iF/obytUpQc01I7E2CTdR3YXFfEk5P
        utUwOQEOzb3pRHtJ1xSaBW97tcXnaUY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-57-IE8ZQBEiNgWdAiTWbBG-kw-1; Thu, 15 Dec 2022 15:24:19 -0500
X-MC-Unique: IE8ZQBEiNgWdAiTWbBG-kw-1
Received: by mail-io1-f70.google.com with SMTP id r25-20020a6bfc19000000b006e002cb217fso264523ioh.2
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 12:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t6fm+oSV8oyjIgUEqoII+1G68WCI6elRrYgUjqSdR64=;
        b=bSXqeYHrWlwGAPqoBxzAleITC1p+UfIE0HBSbtt01J4SEqAWT+n0Sr3ldqlYJePQtp
         N6HQ4AsP+TMMonJxexSjj8p+K2F5VAMXL1fd2W50OZ4z30Rth//UTTfIQFN/KiUNX9v5
         KSv+lj9mWDD0+iwT8X6ip8ytirNaG+7+w4B2Jw/tzDNKKewRdpoDggBiCtHDyRvsC9eG
         c7G8WV41x4rVTwQ7qo8sLNOu0BbaX6LWqC73QPxz6vRH77wWS4LPet62LxyQx+MVo2Ef
         N/pkRuDUDffHvNyFixF8viMHnEwZX3u/6CLQidF6ihCvcz0QGfoeaA8TFYaTNOyYb6z6
         qhwg==
X-Gm-Message-State: ANoB5pmlT23rbMplbPL9hIIY+W2gItYh2h+WgCVtRlkqpBjFou8o+eSj
        ZymwHP75kaO7St1ay2IrQWJoCg8QLc/PXg0kqo8xPeY+isZGXeq/cIhjUDzQzpWafpn+zAtAryS
        /cllFahS5pUQC
X-Received: by 2002:a5d:81d4:0:b0:6da:9d71:313c with SMTP id t20-20020a5d81d4000000b006da9d71313cmr16998182iol.0.1671135858676;
        Thu, 15 Dec 2022 12:24:18 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4dmlFhjIy5ir8nIG8tlpvPyR9ig0f54SmRU9chZ6WVGhm45NSeA7q8EL3FhCGobyde5Mi1Mg==
X-Received: by 2002:a5d:81d4:0:b0:6da:9d71:313c with SMTP id t20-20020a5d81d4000000b006da9d71313cmr16998169iol.0.1671135858301;
        Thu, 15 Dec 2022 12:24:18 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q8-20020a0566022f0800b006e2f42a30c2sm1432610iow.35.2022.12.15.12.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 12:24:17 -0800 (PST)
Date:   Thu, 15 Dec 2022 13:24:15 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.2-rc1
Message-ID: <20221215132415.07f82cda.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

Happy holidays!  As Jason noted in his pull request[1], there were some
unavoidable conflicts between vfio and iommufd this cycle.  The iommufd
code has already been merged, so you'll encounter these with this pull
request.  I've provided resolution of the conflict chunks here below
the diffstat.  These are entirely predictable, perhaps with the exception
of the goto label renaming that Jason had proposed in his version and
I've copied here.  Thanks,

Alex

[1]https://lore.kernel.org/all/Y5dzTU8dlmXTbzoJ@nvidia.com/

The following changes since commit f0c4d9fc9cc9462659728d168387191387e903cc:

  Linux 6.1-rc4 (2022-11-06 15:07:11 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.2-rc1

for you to fetch changes up to 70be6f322860d322ebcd120cf0c05402ead5c6de:

  vfio/mlx5: error pointer dereference in error handling (2022-12-12 14:10:12 -0700)

----------------------------------------------------------------
VFIO updates for v6.2-rc1

 - Replace deprecated git://github.com link in MAINTAINERS. (Palmer Dabbelt)

 - Simplify vfio/mlx5 with module_pci_driver() helper. (Shang XiaoJing)

 - Drop unnecessary buffer from ACPI call. (Rafael Mendonca)

 - Correct latent missing include issue in iova-bitmap and fix support
   for unaligned bitmaps.  Follow-up with better fix through refactor.
   (Joao Martins)

 - Rework ccw mdev driver to split private data from parent structure,
   better aligning with the mdev lifecycle and allowing us to remove
   a temporary workaround. (Eric Farman)

 - Add an interface to get an estimated migration data size for a device,
   allowing userspace to make informed decisions, ex. more accurately
   predicting VM downtime. (Yishai Hadas)

 - Fix minor typo in vfio/mlx5 array declaration. (Yishai Hadas)

 - Simplify module and Kconfig through consolidating SPAPR/EEH code and
   config options and folding virqfd module into main vfio module.
   (Jason Gunthorpe)

 - Fix error path from device_register() across all vfio mdev and sample
   drivers. (Alex Williamson)

 - Define migration pre-copy interface and implement for vfio/mlx5
   devices, allowing portions of the device state to be saved while the
   device continues operation, towards reducing the stop-copy state
   size. (Jason Gunthorpe, Yishai Hadas, Shay Drory)

 - Implement pre-copy for hisi_acc devices. (Shameer Kolothum)

 - Fixes to mdpy mdev driver remove path and error path on probe.
   (Shang XiaoJing)

 - vfio/mlx5 fixes for incorrect return after copy_to_user() fault and
   incorrect buffer freeing. (Dan Carpenter)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/ap/ccw/samples: Fix device_register() unwind path

Dan Carpenter (2):
      vfio/mlx5: fix error code in mlx5vf_precopy_ioctl()
      vfio/mlx5: error pointer dereference in error handling

Eric Farman (7):
      vfio/ccw: create a parent struct
      vfio/ccw: remove private->sch
      vfio/ccw: move private initialization to callback
      vfio/ccw: move private to mdev lifecycle
      vfio/ccw: remove release completion
      vfio/ccw: replace vfio_init_device with _alloc_
      vfio: Remove vfio_free_device

Jason Gunthorpe (6):
      vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
      vfio/spapr: Move VFIO_CHECK_EXTENSION into tce_iommu_ioctl()
      vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
      vfio: Remove CONFIG_VFIO_SPAPR_EEH
      vfio: Fold vfio_virqfd.ko into vfio.ko
      vfio: Extend the device migration protocol with PRE_COPY

Joao Martins (3):
      vfio/iova_bitmap: Explicitly include linux/slab.h
      vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
      vfio/iova_bitmap: refactor iova_bitmap_set() to better handle page boundaries

Palmer Dabbelt (1):
      MAINTAINERS: git://github -> https://github.com for awilliam

Rafael Mendonca (1):
      vfio: platform: Do not pass return buffer to ACPI _RST method

Shameer Kolothum (4):
      hisi_acc_vfio_pci: Add support for precopy IOCTL
      hisi_acc_vfio_pci: Introduce support for PRE_COPY state transitions
      hisi_acc_vfio_pci: Move the dev compatibility tests for early check
      hisi_acc_vfio_pci: Enable PRE_COPY flag

Shang XiaoJing (2):
      vfio/mlx5: Switch to use module_pci_driver() macro
      samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()

Shay Drory (3):
      net/mlx5: Introduce ifc bits for pre_copy
      vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
      vfio/mlx5: Enable MIGRATION_PRE_COPY flag

Yishai Hadas (12):
      vfio: Add an option to get migration data size
      vfio/mlx5: Fix a typo in mlx5vf_cmd_load_vhca_state()
      vfio/mlx5: Enforce a single SAVE command at a time
      vfio/mlx5: Refactor PD usage
      vfio/mlx5: Refactor MKEY usage
      vfio/mlx5: Refactor migration file state
      vfio/mlx5: Refactor to use queue based data chunks
      vfio/mlx5: Introduce device transitions of PRE_COPY
      vfio/mlx5: Introduce SW headers for migration states
      vfio/mlx5: Introduce vfio precopy ioctl implementation
      vfio/mlx5: Consider temporary end of stream as part of PRE_COPY
      vfio/mlx5: Introduce multiple loads

 MAINTAINERS                                    |   2 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c               |   1 -
 drivers/s390/cio/vfio_ccw_chp.c                |   5 +-
 drivers/s390/cio/vfio_ccw_drv.c                | 174 +++---
 drivers/s390/cio/vfio_ccw_fsm.c                |  27 +-
 drivers/s390/cio/vfio_ccw_ops.c                | 107 ++--
 drivers/s390/cio/vfio_ccw_private.h            |  37 +-
 drivers/s390/crypto/vfio_ap_drv.c              |   2 +-
 drivers/s390/crypto/vfio_ap_ops.c              |   6 -
 drivers/vfio/Kconfig                           |   7 +-
 drivers/vfio/Makefile                          |   5 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c              |   1 -
 drivers/vfio/iova_bitmap.c                     |  33 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 156 ++++-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h |   2 +
 drivers/vfio/pci/mlx5/cmd.c                    | 413 ++++++++++---
 drivers/vfio/pci/mlx5/cmd.h                    |  96 ++-
 drivers/vfio/pci/mlx5/main.c                   | 784 ++++++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_core.c               |  15 +-
 drivers/vfio/platform/vfio_amba.c              |   1 -
 drivers/vfio/platform/vfio_platform.c          |   1 -
 drivers/vfio/platform/vfio_platform_common.c   |   3 +-
 drivers/vfio/vfio.h                            |  13 +
 drivers/vfio/vfio_iommu_spapr_tce.c            |  65 +-
 drivers/vfio/vfio_main.c                       | 145 ++++-
 drivers/vfio/vfio_spapr_eeh.c                  | 107 ----
 drivers/vfio/virqfd.c                          |  17 +-
 include/linux/mlx5/mlx5_ifc.h                  |  14 +-
 include/linux/vfio.h                           |  31 +-
 include/uapi/linux/vfio.h                      | 136 ++++-
 samples/vfio-mdev/mbochs.c                     |   8 +-
 samples/vfio-mdev/mdpy-fb.c                    |   8 +-
 samples/vfio-mdev/mdpy.c                       |   8 +-
 samples/vfio-mdev/mtty.c                       |   8 +-
 34 files changed, 1792 insertions(+), 646 deletions(-)
 delete mode 100644 drivers/vfio/vfio_spapr_eeh.c

Conflict resolution chunks vs mainline (057b40f43ce4):

diff --cc drivers/vfio/Kconfig
index 286c1663bd75,0b8d53f63c7e..a8f544629467
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@@ -46,17 -38,6 +46,12 @@@ config VFIO_NOIOMM
  	  this mode since there is no IOMMU to provide DMA translation.
  
  	  If you don't know what to do here, say N.
 +endif
 +
- config VFIO_SPAPR_EEH
- 	tristate
- 	depends on EEH && VFIO_IOMMU_SPAPR_TCE
- 	default VFIO
- 
 +config VFIO_VIRQFD
- 	tristate
++	bool
 +	select EVENTFD
 +	default n
  
  source "drivers/vfio/pci/Kconfig"
  source "drivers/vfio/platform/Kconfig"
diff --cc drivers/vfio/Makefile
index 3783db7e8082,0721ed4831c9..7eae72e2c6bf
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@@ -2,17 -2,12 +2,14 @@@
  obj-$(CONFIG_VFIO) += vfio.o
  
  vfio-y += vfio_main.o \
 -	  iova_bitmap.o \
 -	  container.o
 +	  group.o \
 +	  iova_bitmap.o
+ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
 +vfio-$(CONFIG_IOMMUFD) += iommufd.o
 +vfio-$(CONFIG_VFIO_CONTAINER) += container.o
  
- obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
- obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
  obj-$(CONFIG_VFIO_PCI) += pci/
  obj-$(CONFIG_VFIO_PLATFORM) += platform/
  obj-$(CONFIG_VFIO_MDEV) += mdev/
diff --cc drivers/vfio/vfio_main.c
index e21ff965141e,03dbcd3d96f0..d4087fe74199
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@@ -1260,27 -1902,59 +1348,34 @@@ static int __init vfio_init(void
  	if (ret)
  		return ret;
  
+ 	ret = vfio_virqfd_init();
+ 	if (ret)
 -		goto err_virqfd;
 -
 -	/* /dev/vfio/$GROUP */
 -	vfio.class = class_create(THIS_MODULE, "vfio");
 -	if (IS_ERR(vfio.class)) {
 -		ret = PTR_ERR(vfio.class);
 -		goto err_group_class;
 -	}
 -
 -	vfio.class->devnode = vfio_devnode;
++		goto err_group;
+ 
  	/* /sys/class/vfio-dev/vfioX */
  	vfio.device_class = class_create(THIS_MODULE, "vfio-dev");
  	if (IS_ERR(vfio.device_class)) {
  		ret = PTR_ERR(vfio.device_class);
--		goto err_dev_class;
++		goto err_virqfd;
  	}
  
 -	ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1, "vfio");
 -	if (ret)
 -		goto err_alloc_chrdev;
 -
  	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
  	return 0;
  
 -err_alloc_chrdev:
 -	class_destroy(vfio.device_class);
 -	vfio.device_class = NULL;
--err_dev_class:
 -	class_destroy(vfio.class);
 -	vfio.class = NULL;
 -err_group_class:
 -	vfio_virqfd_exit();
+ err_virqfd:
 -	vfio_container_cleanup();
++	vfio_virqfd_exit();
++err_group:
 +	vfio_group_cleanup();
  	return ret;
  }
  
  static void __exit vfio_cleanup(void)
  {
 -	WARN_ON(!list_empty(&vfio.group_list));
 -
  	ida_destroy(&vfio.device_ida);
 -	ida_destroy(&vfio.group_ida);
 -	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
  	class_destroy(vfio.device_class);
  	vfio.device_class = NULL;
 -	class_destroy(vfio.class);
+ 	vfio_virqfd_exit();
 -	vfio_container_cleanup();
 -	vfio.class = NULL;
 +	vfio_group_cleanup();
  	xa_destroy(&vfio_device_set_xa);
  }
  

