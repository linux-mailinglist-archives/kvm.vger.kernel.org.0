Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67ED978E234
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 00:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245651AbjH3WRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 18:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbjH3WRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 18:17:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D84B4
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 15:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693433700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BvLcRrgbS93qCwOb6Dq41wAHdRdQIMERBbEHIY8sTms=;
        b=a6WJQZT2NLJTvzS0JXT0LneCnVkhv2wJD4TvRz3XbpcV6YwpuUg7jnaxD9wG1SNP/ErJ+i
        /A5d48UiIUSR4x//vV0smNidY72SmrR99xhCNfAumeQ+mV6IxZb+liLzqOz3oEzQ7+tLGc
        p8oRO1HKnqylwiYjFN5y2ma7aHUw684=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-O3r7aJXvObCU5Qd4MOuq6w-1; Wed, 30 Aug 2023 18:14:58 -0400
X-MC-Unique: O3r7aJXvObCU5Qd4MOuq6w-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7872be95468so20480239f.1
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 15:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693433697; x=1694038497;
        h=content-transfer-encoding:mime-version:organization:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BvLcRrgbS93qCwOb6Dq41wAHdRdQIMERBbEHIY8sTms=;
        b=bvbchaUahL190g0XyoblNYnjjHTV6LkErURPNZ2ZsFpe8pPO6h6D5aWMHkF8TB9iMn
         tOGhSAkg6/WL28UOgFUZr1wXfykyRwoHJWAIi7xToRG/3BTq2SV1AZgxpUyRPnsiwiEb
         3y4RwVFifHUhySZpizouFMLivMfg6u5C7TCZOWHi0doNdL05jVQ7NEfkav8UZSJ1C3is
         G31JwQyjmmUgI0VKmRBL+MI5ewg2x9vSHTmP7eOcZkTSwWmX1q3d6V2Yn1sImJIPhnZ9
         Ith8oUHhR2SibBu7w6TFRRB3xgdLNI29vga9IuOUjovZRy5Uc7pxL4MLERSXyNKGDQY8
         4RFQ==
X-Gm-Message-State: AOJu0YxfzJ85Cikbmu+RLMQjH5fN1nROMstCBb3do6TMmJEntQD2AfSn
        U9A0KlLgyYXJlQQCIWwuXgZsdsOB3miFkjhp/FTO9Sov0rnuEUsHKn/VPFVllTu1lhQYkXTKWYi
        fLrCX1ziVal3K
X-Received: by 2002:a5e:a813:0:b0:794:efb0:83d6 with SMTP id c19-20020a5ea813000000b00794efb083d6mr4083101ioa.12.1693433697611;
        Wed, 30 Aug 2023 15:14:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbbwbaTj/Wk1h/aBt2tZP10zzHBBTmtAxo43C+S2GX8oSFo/vvtCw+FTIH6mNsjq4C6NpXIw==
X-Received: by 2002:a5e:a813:0:b0:794:efb0:83d6 with SMTP id c19-20020a5ea813000000b00794efb083d6mr4083091ioa.12.1693433697348;
        Wed, 30 Aug 2023 15:14:57 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id r11-20020a02c84b000000b00433dd6c78b0sm18379jao.97.2023.08.30.15.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 15:14:56 -0700 (PDT)
Date:   Wed, 30 Aug 2023 16:14:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.6-rc1
Message-ID: <20230830161456.646826da.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 6eaae198076080886b9e7d57f4ae06fa782f90ef:

  Linux 6.5-rc3 (2023-07-23 15:24:10 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.6-rc1

for you to fetch changes up to 642265e22ecc7fe05c49cb8e1e0000a049df9857:

  vfio/pds: Send type for SUSPEND_STATUS command (2023-08-22 13:11:57 -0600)

----------------------------------------------------------------
VFIO updates for v6.6-rc1

 - VFIO direct character device (cdev) interface support.  This extracts
   the vfio device fd from the container and group model, and is intended
   to be the native uAPI for use with IOMMUFD. (Yi Liu)

 - Enhancements to the PCI hot reset interface in support of cdev usage.
   (Yi Liu)

 - Fix a potential race between registering and unregistering vfio files
   in the kvm-vfio interface and extend use of a lock to avoid extra
   drop and acquires. (Dmitry Torokhov)

 - A new vfio-pci variant driver for the AMD/Pensando Distributed Services
   Card (PDS) Ethernet device, supporting live migration. (Brett Creeley)

 - Cleanups to remove redundant owner setup in cdx and fsl bus drivers,
   and simplify driver init/exit in fsl code. (Li Zetao)

 - Fix uninitialized hole in data structure and pad capability structures
   for alignment. (Stefan Hajnoczi)

----------------------------------------------------------------
Brett Creeley (10):
      vfio: Commonize combine_ranges for use in other VFIO drivers
      vfio/pds: Initial support for pds VFIO driver
      pds_core: Require callers of register/unregister to pass PF drvdata
      vfio/pds: register with the pds_core PF
      vfio/pds: Add VFIO live migration support
      vfio/pds: Add support for dirty page tracking
      vfio/pds: Add support for firmware recovery
      vfio/pds: Add Kconfig and documentation
      pds_core: Fix function header descriptions
      vfio/pds: Send type for SUSPEND_STATUS command

Dmitry Torokhov (2):
      kvm/vfio: ensure kvg instance stays around in kvm_vfio_group_add()
      kvm/vfio: avoid bouncing the mutex when adding and deleting groups

Li Zetao (2):
      vfio/cdx: Remove redundant initialization owner in vfio_cdx_driver
      vfio/fsl-mc: Use module_fsl_mc_driver macro to simplify the code

Nicolin Chen (1):
      iommufd/device: Add iommufd_access_detach() API

Stefan Hajnoczi (2):
      vfio/type1: fix cap_migration information leak
      vfio: align capability structures

Yang Yingliang (1):
      vfio/pds: fix return value in pds_vfio_get_lm_file()

Yi Liu (35):
      vfio/pci: Update comment around group_fd get in vfio_pci_ioctl_pci_hot_reset()
      vfio/pci: Move the existing hot reset logic to be a helper
      iommufd: Reserve all negative IDs in the iommufd xarray
      iommufd: Add iommufd_ctx_has_group()
      iommufd: Add helper to retrieve iommufd_ctx and devid
      vfio: Mark cdev usage in vfio_device
      vfio: Add helper to search vfio_device in a dev_set
      vfio/pci: Extend VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
      vfio/pci: Copy hot-reset device info to userspace in the devices loop
      vfio/pci: Allow passing zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
      vfio: Allocate per device file structure
      vfio: Refine vfio file kAPIs for KVM
      vfio: Accept vfio device file in the KVM facing kAPI
      kvm/vfio: Prepare for accepting vfio device fd
      kvm/vfio: Accept vfio device file from userspace
      vfio: Pass struct vfio_device_file * to vfio_device_open/close()
      vfio: Block device access via device fd until device is opened
      vfio: Add cdev_device_open_cnt to vfio_group
      vfio: Make vfio_df_open() single open for device cdev path
      vfio-iommufd: Move noiommu compat validation out of vfio_iommufd_bind()
      vfio-iommufd: Split bind/attach into two steps
      vfio: Record devid in vfio_device_file
      vfio-iommufd: Add detach_ioas support for physical VFIO devices
      vfio-iommufd: Add detach_ioas support for emulated VFIO devices
      vfio: Move vfio_device_group_unregister() to be the first operation in unregister
      vfio: Move device_del() before waiting for the last vfio_device registration refcount
      vfio: Add cdev for vfio_device
      vfio: Test kvm pointer in _vfio_device_get_kvm_safe()
      iommufd: Add iommufd_ctx_from_fd()
      vfio: Avoid repeated user pointer cast in vfio_device_fops_unl_ioctl()
      vfio: Add VFIO_DEVICE_BIND_IOMMUFD
      vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
      vfio: Move the IOMMU_CAP_CACHE_COHERENCY check in __vfio_register_dev()
      vfio: Compile vfio_group infrastructure optionally
      docs: vfio: Add vfio device cdev description

 Documentation/driver-api/vfio.rst                  | 147 +++++-
 .../device_drivers/ethernet/amd/pds_vfio_pci.rst   |  79 +++
 .../networking/device_drivers/ethernet/index.rst   |   1 +
 Documentation/virt/kvm/devices/vfio.rst            |  47 +-
 MAINTAINERS                                        |   7 +
 drivers/gpu/drm/i915/gvt/kvmgt.c                   |   1 +
 drivers/iommu/iommufd/Kconfig                      |   4 +-
 drivers/iommu/iommufd/device.c                     | 116 ++++-
 drivers/iommu/iommufd/iommufd_private.h            |   2 +
 drivers/iommu/iommufd/main.c                       |  26 +-
 drivers/iommu/iommufd/vfio_compat.c                |   2 +
 drivers/net/ethernet/amd/pds_core/auxbus.c         |  24 +-
 drivers/s390/cio/vfio_ccw_ops.c                    |   1 +
 drivers/s390/crypto/vfio_ap_ops.c                  |   1 +
 drivers/vfio/Kconfig                               |  27 +
 drivers/vfio/Makefile                              |   3 +-
 drivers/vfio/cdx/main.c                            |   1 -
 drivers/vfio/device_cdev.c                         | 228 +++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |  15 +-
 drivers/vfio/group.c                               | 173 ++++---
 drivers/vfio/iommufd.c                             | 138 +++--
 drivers/vfio/pci/Kconfig                           |   2 +
 drivers/vfio/pci/Makefile                          |   2 +
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |   2 +
 drivers/vfio/pci/mlx5/cmd.c                        |  48 +-
 drivers/vfio/pci/mlx5/main.c                       |   1 +
 drivers/vfio/pci/pds/Kconfig                       |  19 +
 drivers/vfio/pci/pds/Makefile                      |  11 +
 drivers/vfio/pci/pds/cmds.c                        | 510 +++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h                        |  25 +
 drivers/vfio/pci/pds/dirty.c                       | 564 +++++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                       |  39 ++
 drivers/vfio/pci/pds/lm.c                          | 434 ++++++++++++++++
 drivers/vfio/pci/pds/lm.h                          |  41 ++
 drivers/vfio/pci/pds/pci_drv.c                     | 209 ++++++++
 drivers/vfio/pci/pds/pci_drv.h                     |   9 +
 drivers/vfio/pci/pds/vfio_dev.c                    | 227 +++++++++
 drivers/vfio/pci/pds/vfio_dev.h                    |  39 ++
 drivers/vfio/pci/vfio_pci.c                        |   1 +
 drivers/vfio/pci/vfio_pci_core.c                   | 261 ++++++----
 drivers/vfio/platform/vfio_amba.c                  |   1 +
 drivers/vfio/platform/vfio_platform.c              |   1 +
 drivers/vfio/vfio.h                                | 218 +++++++-
 drivers/vfio/vfio_iommu_type1.c                    |  13 +-
 drivers/vfio/vfio_main.c                           | 307 ++++++++++-
 include/linux/iommufd.h                            |   7 +
 include/linux/pds/pds_adminq.h                     | 375 ++++++++++++++
 include/linux/pds/pds_common.h                     |   9 +-
 include/linux/vfio.h                               |  69 ++-
 include/uapi/linux/kvm.h                           |  13 +-
 include/uapi/linux/vfio.h                          | 144 +++++-
 samples/vfio-mdev/mbochs.c                         |   1 +
 samples/vfio-mdev/mdpy.c                           |   1 +
 samples/vfio-mdev/mtty.c                           |   1 +
 virt/kvm/vfio.c                                    | 161 +++---
 55 files changed, 4350 insertions(+), 458 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst
 create mode 100644 drivers/vfio/device_cdev.c
 create mode 100644 drivers/vfio/pci/pds/Kconfig
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/dirty.c
 create mode 100644 drivers/vfio/pci/pds/dirty.h
 create mode 100644 drivers/vfio/pci/pds/lm.c
 create mode 100644 drivers/vfio/pci/pds/lm.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.c
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.h

