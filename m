Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373325FC80B
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 17:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiJLPPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 11:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiJLPOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 11:14:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5402BE4
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 08:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665587682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lvCLdD9hVzl92XEzd3wlNSAX65cU1Voc3mxq9uUCtIo=;
        b=YX1Ajg7R4LM1OMA4c2ZoG7MpLdr0jcdK2YR5s05fDP6xe0v9855ejDSQZZ8LXI6RIGO/xI
        OD72Kndp7e9B3gUqFWgg6ttB8M+76twDS+FkOzIEz+Eotxsc8cFtqGf5uiWNHl0iIKY1ca
        oBAsWhf3Ja+hh7RoXZRSmxX8/O7ZenI=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-380-cRkfE8GfNkCDbJt4kg3nkw-1; Wed, 12 Oct 2022 11:14:38 -0400
X-MC-Unique: cRkfE8GfNkCDbJt4kg3nkw-1
Received: by mail-il1-f200.google.com with SMTP id j29-20020a056e02219d00b002f9b13c40c5so13757946ila.21
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 08:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lvCLdD9hVzl92XEzd3wlNSAX65cU1Voc3mxq9uUCtIo=;
        b=jRFKeHX3C0N+mN7GzzUos/f4AcJihCbleZVIftgW1c5TIn8gb0vEDUnwOOe+cCGgEv
         hi75aF2PGabMGxkrZM4UUrz49ejmvdE6i6pJAsayMAliS/vPoXT+c6q7YmvXHrUqxs+4
         oiPHStyF2LHB6bpHfRfS2OODex+6ua68sXyzBhGr6rTQj9pN/hc0L+dX0JpZw8IYaguh
         zVbqF8RBURxnHwhDxCm7lfUSw1WiVsDzXjyKKdtHTOXiaGtL4wRAEz6tCrvi/3l7aOz3
         GzSCAcaqQNXmdyIZNZ3Fre8ImbxJM/iPl4Iqnnf8ChcU0EfdDFwPh2HxMJJgXKOJADdu
         a9pg==
X-Gm-Message-State: ACrzQf2vDdlIXYj7wSUv6Fm0xJiDtpVMVDrPWxDksI74NTh1ePr+pP0M
        soQmWBf0BqB77pmVKpnJxblLZqzS36uwv4qoD0dLJ0/tKffPhe5vLmJBp625nRrSWT0obEYAz5e
        6h3oRMAWI3vE/
X-Received: by 2002:a05:6638:1903:b0:363:e824:2193 with SMTP id p3-20020a056638190300b00363e8242193mr1321843jal.40.1665587677215;
        Wed, 12 Oct 2022 08:14:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6qzDlGaLBJVuq49wdsvqo/L5/17dKv5UEq26PYXju5ZSVlfDMK6CTzZ3H/Y/CXF2mtwfgn7g==
X-Received: by 2002:a05:6638:1903:b0:363:e824:2193 with SMTP id p3-20020a056638190300b00363e8242193mr1321789jal.40.1665587676076;
        Wed, 12 Oct 2022 08:14:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k15-20020a0566022d8f00b00688e35a2674sm6672137iow.40.2022.10.12.08.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 08:14:35 -0700 (PDT)
Date:   Wed, 12 Oct 2022 09:14:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        alex.williamson@redhat.com
Subject: [GIT PULL] VFIO updates for v6.1-rc1
Message-ID: <20221012091434.650250cd.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 939838632b9119614128028eaea3b1d7bf29f16f:

  net/mlx5: Query ADV_VIRTUALIZATION capabilities (2022-09-07 11:57:27 +0300)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.1-rc1

for you to fetch changes up to b1b8132a651cf6a5b18a01d8f1bd304f5d210315:

  vfio: More vfio_file_is_group() use cases (2022-10-07 13:06:52 -0600)

----------------------------------------------------------------
VFIO updates for v6.1-rc1

 - Prune private items from vfio_pci_core.h to a new internal header,
   fix missed function rename, and refactor vfio-pci interrupt defines.
   (Jason Gunthorpe)

 - Create consistent naming and handling of ioctls with a function per
   ioctl for vfio-pci and vfio group handling, use proper type args
   where available. (Jason Gunthorpe)

 - Implement a set of low power device feature ioctls allowing userspace
   to make use of power states such as D3cold where supported.
   (Abhishek Sahu)

 - Remove device counter on vfio groups, which had restricted the page
   pinning interface to singleton groups to account for limitations in
   the type1 IOMMU backend.  Document usage as limited to emulated IOMMU
   devices, ie. traditional mdev devices where this restriction is
   consistent.  (Jason Gunthorpe)

 - Correct function prefix in hisi_acc driver incurred during previous
   refactoring. (Shameer Kolothum)

 - Correct typo and remove redundant warning triggers in vfio-fsl driver.
   (Christophe JAILLET)

 - Introduce device level DMA dirty tracking uAPI and implementation in
   the mlx5 variant driver (Yishai Hadas & Joao Martins)

 - Move much of the vfio_device life cycle management into vfio core,
   simplifying and avoiding duplication across drivers.  This also
   facilitates adding a struct device to vfio_device which begins the
   introduction of device rather than group level user support and fills
   a gap allowing userspace identify devices as vfio capable without
   implicit knowledge of the driver. (Kevin Tian & Yi Liu)

 - Split vfio container handling to a separate file, creating a more
   well defined API between the core and container code, masking IOMMU
   backend implementation from the core, allowing for an easier future
   transition to an iommufd based implementation of the same.
   (Jason Gunthorpe)

 - Attempt to resolve race accessing the iommu_group for a device
   between vfio releasing DMA ownership and removal of the device from
   the IOMMU driver.  Follow-up with support to allow vfio_group to
   exist with NULL iommu_group pointer to support existing userspace
   use cases of holding the group file open.  (Jason Gunthorpe)

 - Fix error code and hi/lo register manipulation issues in the hisi_acc
   variant driver, along with various code cleanups. (Longfang Liu)

 - Fix a prior regression in GVT-g group teardown, resulting in
   unreleased resources. (Jason Gunthorpe)

 - A significant cleanup and simplification of the mdev interface,
   consolidating much of the open coded per driver sysfs interface
   support into the mdev core. (Christoph Hellwig)

 - Simplification of tracking and locking around vfio_groups that
   fall out from previous refactoring. (Jason Gunthorpe)

 - Replace trivial open coded f_ops tests with new helper.
   (Alex Williamson)

----------------------------------------------------------------
Abhishek Sahu (5):
      vfio: Add the device features for the low power entry and exit
      vfio: Increment the runtime PM usage count during IOCTL call
      vfio/pci: Mask INTx during runtime suspend
      vfio/pci: Implement VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY/EXIT
      vfio/pci: Implement VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP

Alex Williamson (2):
      Merge remote-tracking branch 'mlx5/mlx5-vfio' into v6.1/vfio/next
      vfio: More vfio_file_is_group() use cases

Christoph Hellwig (12):
      drm/i915/gvt: fix a memory leak in intel_gvt_init_vgpu_types
      drm/i915/gvt: simplify vgpu configuration management
      vfio/mdev: make mdev.h standalone includable
      vfio/mdev: embedd struct mdev_parent in the parent data structure
      vfio/mdev: simplify mdev_type handling
      vfio/mdev: remove mdev_from_dev
      vfio/mdev: unexport mdev_bus_type
      vfio/mdev: remove mdev_parent_dev
      vfio/mdev: remove mtype_get_parent_dev
      vfio/mdev: consolidate all the name sysfs into the core code
      vfio/mdev: consolidate all the available_instance sysfs into the core code
      vfio/mdev: consolidate all the description sysfs into the core code

Christophe JAILLET (1):
      vfio/fsl-mc: Fix a typo in a message

Jason Gunthorpe (29):
      vfio/pci: Split linux/vfio_pci_core.h
      vfio/pci: Rename vfio_pci_register_dev_region()
      vfio/pci: Simplify the is_intx/msi/msix/etc defines
      vfio-pci: Fix vfio_pci_ioeventfd() to return int
      vfio-pci: Break up vfio_pci_core_ioctl() into one function per ioctl
      vfio-pci: Re-indent what was vfio_pci_core_ioctl()
      vfio-pci: Replace 'void __user *' with proper types in the ioctl functions
      vfio: Fold VFIO_GROUP_GET_DEVICE_FD into vfio_group_get_device_fd()
      vfio: Fold VFIO_GROUP_SET_CONTAINER into vfio_group_set_container()
      vfio: Follow the naming pattern for vfio_group_ioctl_unset_container()
      vfio: Split VFIO_GROUP_GET_STATUS into a function
      vfio: Remove vfio_group dev_counter
      vfio: Add header guards and includes to drivers/vfio/vfio.h
      vfio: Rename __vfio_group_unset_container()
      vfio: Split the container logic into vfio_container_attach_group()
      vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
      vfio: Split out container code from the init/cleanup functions
      vfio: Rename vfio_ioctl_check_extension()
      vfio: Split the register_device ops call into functions
      vfio: Move container code into drivers/vfio/container.c
      vfio: Follow a strict lifetime for struct iommu_group
      drm/i915/gvt: Add missing vfio_unregister_group_dev() call
      vfio/mdev: consolidate all the device_api sysfs into the core code
      vfio/mdev: add mdev available instance checking to the core
      vfio: Remove the vfio_group->users and users_comp
      vfio: Change vfio_group->group_rwsem to a mutex
      vfio: Add vfio_file_is_group()
      vfio: Hold a reference to the iommu_group in kvm for SPAPR
      vfio: Make the group FD disassociate from the iommu_group

Joao Martins (1):
      vfio: Add an IOVA bitmap support

Kevin Tian (6):
      vfio: Add helpers for unifying vfio_device life cycle
      drm/i915/gvt: Use the new device life cycle helpers
      vfio/platform: Use the new device life cycle helpers
      vfio/amba: Use the new device life cycle helpers
      vfio/ccw: Use the new device life cycle helpers
      vfio: Rename vfio_device_put() and vfio_device_try_get()

Longfang Liu (5):
      hisi_acc_vfio_pci: Fixes error return code issue
      hisi_acc_vfio_pci: Fix device data address combination problem
      hisi_acc_vfio_pci: Remove useless function parameter
      hisi_acc_vfio_pci: Remove useless macro definitions
      hisi_acc_vfio_pci: Update some log and comment formats

Shameer Kolothum (1):
      hisi_acc_vfio_pci: Correct the function prefix for hssi_acc_drvdata()

Yi Liu (9):
      vfio/pci: Use the new device life cycle helpers
      vfio/mlx5: Use the new device life cycle helpers
      vfio/hisi_acc: Use the new device life cycle helpers
      vfio/mdpy: Use the new device life cycle helpers
      vfio/mtty: Use the new device life cycle helpers
      vfio/mbochs: Use the new device life cycle helpers
      vfio/ap: Use the new device life cycle helpers
      vfio/fsl-mc: Use the new device life cycle helpers
      vfio: Add struct device to vfio_device

Yishai Hadas (7):
      vfio: Introduce DMA logging uAPIs
      vfio: Introduce the DMA logging feature support
      vfio/mlx5: Init QP based resources for dirty tracking
      vfio/mlx5: Create and destroy page tracker object
      vfio/mlx5: Report dirty pages from tracker
      vfio/mlx5: Manage error scenarios on tracker
      vfio/mlx5: Set the driver DMA logging callbacks

 Documentation/ABI/testing/sysfs-devices-vfio-dev  |    8 +
 Documentation/driver-api/vfio-mediated-device.rst |   26 +-
 Documentation/s390/vfio-ap.rst                    |    2 +-
 Documentation/s390/vfio-ccw.rst                   |    2 +-
 MAINTAINERS                                       |    1 +
 drivers/gpu/drm/i915/gvt/aperture_gm.c            |   20 +-
 drivers/gpu/drm/i915/gvt/gvt.h                    |   46 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c                  |  205 +--
 drivers/gpu/drm/i915/gvt/vgpu.c                   |  212 +---
 drivers/s390/cio/vfio_ccw_drv.c                   |   12 +-
 drivers/s390/cio/vfio_ccw_ops.c                   |   92 +-
 drivers/s390/cio/vfio_ccw_private.h               |   11 +-
 drivers/s390/crypto/vfio_ap_ops.c                 |  109 +-
 drivers/s390/crypto/vfio_ap_private.h             |    6 +-
 drivers/vfio/Kconfig                              |    1 +
 drivers/vfio/Makefile                             |    7 +-
 drivers/vfio/container.c                          |  680 ++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                 |   89 +-
 drivers/vfio/iova_bitmap.c                        |  422 +++++++
 drivers/vfio/mdev/mdev_core.c                     |  195 +--
 drivers/vfio/mdev/mdev_driver.c                   |    7 +-
 drivers/vfio/mdev/mdev_private.h                  |   32 +-
 drivers/vfio/mdev/mdev_sysfs.c                    |  190 +--
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  136 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |    7 +-
 drivers/vfio/pci/mlx5/cmd.c                       |  995 ++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h                       |   63 +-
 drivers/vfio/pci/mlx5/main.c                      |   55 +-
 drivers/vfio/pci/vfio_pci.c                       |   22 +-
 drivers/vfio/pci/vfio_pci_config.c                |    4 +-
 drivers/vfio/pci/vfio_pci_core.c                  | 1105 ++++++++++------
 drivers/vfio/pci/vfio_pci_igd.c                   |    8 +-
 drivers/vfio/pci/vfio_pci_intrs.c                 |   34 +-
 drivers/vfio/pci/vfio_pci_priv.h                  |  104 ++
 drivers/vfio/pci/vfio_pci_rdwr.c                  |    6 +-
 drivers/vfio/pci/vfio_pci_zdev.c                  |    2 +-
 drivers/vfio/platform/vfio_amba.c                 |   72 +-
 drivers/vfio/platform/vfio_platform.c             |   66 +-
 drivers/vfio/platform/vfio_platform_common.c      |   71 +-
 drivers/vfio/platform/vfio_platform_private.h     |   18 +-
 drivers/vfio/vfio.h                               |   62 +
 drivers/vfio/vfio_main.c                          | 1394 +++++++++------------
 include/linux/iova_bitmap.h                       |   26 +
 include/linux/mdev.h                              |   77 +-
 include/linux/vfio.h                              |   57 +-
 include/linux/vfio_pci_core.h                     |  149 +--
 include/uapi/linux/vfio.h                         |  142 +++
 samples/vfio-mdev/mbochs.c                        |  172 ++-
 samples/vfio-mdev/mdpy.c                          |  185 ++-
 samples/vfio-mdev/mtty.c                          |  157 ++-
 virt/kvm/vfio.c                                   |   45 +-
 51 files changed, 4888 insertions(+), 2721 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-vfio-dev
 create mode 100644 drivers/vfio/container.c
 create mode 100644 drivers/vfio/iova_bitmap.c
 create mode 100644 drivers/vfio/pci/vfio_pci_priv.h
 create mode 100644 include/linux/iova_bitmap.h

