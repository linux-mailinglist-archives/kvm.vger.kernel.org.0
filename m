Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855386A230F
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 21:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBXUN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 15:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXUN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 15:13:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B19231CD
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677269559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=83oMZbrY2l0l38w3Usm1ZV2q90zXmL7guIkz2T8m0zw=;
        b=GYIVGBdvh5MlFO2PzRjrFVUBdYO/wZ9oMs4LMUBCBkQ3N9jgVip8manNMJ/UJ/Bz4ihFaw
        1VChe0e/Xb4T7oX/+g6hSosaRGHVsgiqs5m1muXn2skRf7s1LnrrG2pRmWrlxHY/DjYh8I
        wgpguV3IsljiT2wsIbakCKlmyO4+x74=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-O49H1U3DMHKMle_8W7Nn_w-1; Fri, 24 Feb 2023 15:12:35 -0500
X-MC-Unique: O49H1U3DMHKMle_8W7Nn_w-1
Received: by mail-il1-f197.google.com with SMTP id h12-20020a92c08c000000b00316f82f1d98so395068ile.7
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:12:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=83oMZbrY2l0l38w3Usm1ZV2q90zXmL7guIkz2T8m0zw=;
        b=h18XYVkTaJ11Z2c6Nujcm+bbcEeyLBz4bYcXR2zQxepBbz2Lga9f3NL6xjECZpKyoU
         6OWuRgZ6kdKsL0UQTugvwdzzFuOCf3554A82xPnAPDayS1ZMKDyHstBkTOVipBmmMSKo
         j6vrz1zAIfu98GukgKNXIHuHf7ODmIf9qX2TRc2pjU0WcHjTuA9hKMMBxDtB/nIIWql6
         BsiWN1nOr4XH+eUi+yJMTRV8A2yinGKvo+jh6QkcOIr3dvK9iM6+/lzQs+h+2MB/ubkd
         3mh7e3gyVLG0zpJgsRXlS8DPuSi66AHP642hn18iNpKc9dYEdyQo7r436xeXxy3Wpfxw
         9vgg==
X-Gm-Message-State: AO0yUKU/+9WYW0/m/UGPLO1J6ulOC9Or8o3+0GjA0joOjupfWZ4rW79H
        tatSbwaKjhLclyN6BrQYATq0YLljp4L3zVV8v5sDi7KVcBzBh3JZbU+DXn9518W19c5BdnWaW4I
        KHTjWLKeUki1oP7m//A==
X-Received: by 2002:a92:5204:0:b0:30f:3d9e:f80 with SMTP id g4-20020a925204000000b0030f3d9e0f80mr11472960ilb.25.1677269554225;
        Fri, 24 Feb 2023 12:12:34 -0800 (PST)
X-Google-Smtp-Source: AK7set9818HJBR7WmIOjbZm7g6cqVX0YlvWFT46jfznNZQkV/T94BVzZ9MQQVQMs2QRkFcpiAlRRxg==
X-Received: by 2002:a92:5204:0:b0:30f:3d9e:f80 with SMTP id g4-20020a925204000000b0030f3d9e0f80mr11472946ilb.25.1677269553943;
        Fri, 24 Feb 2023 12:12:33 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q28-20020a02cf1c000000b003c4f35c21absm4771590jar.137.2023.02.24.12.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 12:12:33 -0800 (PST)
Date:   Fri, 24 Feb 2023 13:12:32 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.3-rc1
Message-ID: <20230224131232.113c5eef.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 2241ab53cbb5cdb08a6b2d4688feb13971058f65:

  Linux 6.2-rc5 (2023-01-21 16:27:01 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.3-rc1

for you to fetch changes up to d649c34cb916b015fdcb487e51409fcc5caeca8d:

  vfio: Fix NULL pointer dereference caused by uninitialized group->iommufd (2023-02-22 10:56:37 -0700)

----------------------------------------------------------------
VFIO updates for v6.3-rc1

 - Remove redundant resource check in vfio-platform. (Angus Chen)

 - Use GFP_KERNEL_ACCOUNT for persistent userspace allocations, allowing
   removal of arbitrary kernel limits in favor of cgroup control.
   (Yishai Hadas)

 - mdev tidy-ups, including removing the module-only build restriction
   for sample drivers, Kconfig changes to select mdev support,
   documentation movement to keep sample driver usage instructions with
   sample drivers rather than with API docs, remove references to
   out-of-tree drivers in docs. (Christoph Hellwig)

 - Fix collateral breakages from mdev Kconfig changes. (Arnd Bergmann)

 - Make mlx5 migration support match device support, improve source
   and target flows to improve pre-copy support and reduce downtime.
   (Yishai Hadas)

 - Convert additional mdev sysfs case to use sysfs_emit(). (Bo Liu)

 - Resolve copy-paste error in mdev mbochs sample driver Kconfig.
   (Ye Xingchen)

 - Avoid propagating missing reset error in vfio-platform if reset
   requirement is relaxed by module option. (Tomasz Duszynski)

 - Range size fixes in mlx5 variant driver for missed last byte and
   stricter range calculation. (Yishai Hadas)

 - Fixes to suspended vaddr support and locked_vm accounting, excluding
   mdev configurations from the former due to potential to indefinitely
   block kernel threads, fix underflow and restore locked_vm on new mm.
   (Steve Sistare)

 - Update outdated vfio documentation due to new IOMMUFD interfaces in
   recent kernels. (Yi Liu)

 - Resolve deadlock between group_lock and kvm_lock, finally.
   (Matthew Rosato)

 - Fix NULL pointer in group initialization error path with IOMMUFD.
   (Yan Zhao)

----------------------------------------------------------------
Angus Chen (1):
      vfio: platform: No need to check res again

Arnd Bergmann (1):
      vfio-mdev: add back CONFIG_VFIO dependency

Bo Liu (1):
      vfio/mdev: Use sysfs_emit() to instead of sprintf()

Christoph Hellwig (4):
      vfio-mdev: allow building the samples into the kernel
      vfio-mdev: turn VFIO_MDEV into a selectable symbol
      vfio-mdev: move the mtty usage documentation
      vfio-mdev: remove an non-existing driver from vfio-mediated-device

Cornelia Huck (1):
      MAINTAINERS: step down as vfio reviewer

Jason Gunthorpe (1):
      vfio: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations

Matthew Rosato (2):
      vfio: fix deadlock between group lock and kvm lock
      vfio: no need to pass kvm pointer during device open

Shay Drory (1):
      vfio/mlx5: Check whether VF is migratable

Steve Sistare (7):
      vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
      vfio/type1: prevent underflow of locked_vm via exec()
      vfio/type1: track locked_vm per dma
      vfio/type1: restore locked_vm
      vfio/type1: revert "block on invalid vaddr"
      vfio/type1: revert "implement notify callback"
      vfio: revert "iommu driver notify callback"

Tomasz Duszynski (1):
      vfio: platform: ignore missing reset if disabled at module init

Yan Zhao (1):
      vfio: Fix NULL pointer dereference caused by uninitialized group->iommufd

Yi Liu (2):
      vfio: Update the kdoc for vfio_device_ops
      docs: vfio: Update vfio.rst per latest interfaces

Yishai Hadas (8):
      vfio/mlx5: Fix UBSAN note
      vfio/mlx5: Allow loading of larger images than 512 MB
      vfio/hisi: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
      vfio/fsl-mc: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
      vfio/platform: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
      vfio/mlx5: Improve the source side flow upon pre_copy
      vfio/mlx5: Improve the target side flow to reduce downtime
      vfio/mlx5: Fix range size calculation upon tracker creation

ye xingchen (1):
      samples: fix the prompt about SAMPLE_VFIO_MDEV_MBOCHS

 Documentation/driver-api/vfio-mediated-device.rst | 108 +--------
 Documentation/driver-api/vfio.rst                 |  82 +++++--
 Documentation/s390/vfio-ap.rst                    |   1 -
 MAINTAINERS                                       |   1 -
 arch/s390/Kconfig                                 |   8 +-
 arch/s390/configs/debug_defconfig                 |   1 -
 arch/s390/configs/defconfig                       |   1 -
 drivers/gpu/drm/i915/Kconfig                      |   3 +-
 drivers/vfio/container.c                          |   7 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                 |   2 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c            |   4 +-
 drivers/vfio/group.c                              |  46 +++-
 drivers/vfio/mdev/Kconfig                         |   8 +-
 drivers/vfio/mdev/mdev_sysfs.c                    |   2 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   4 +-
 drivers/vfio/pci/mlx5/cmd.c                       |  79 +++++--
 drivers/vfio/pci/mlx5/cmd.h                       |  28 ++-
 drivers/vfio/pci/mlx5/main.c                      | 261 ++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_config.c                |   6 +-
 drivers/vfio/pci/vfio_pci_core.c                  |   7 +-
 drivers/vfio/pci/vfio_pci_igd.c                   |   2 +-
 drivers/vfio/pci/vfio_pci_intrs.c                 |  10 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                  |   2 +-
 drivers/vfio/platform/vfio_platform_common.c      |  12 +-
 drivers/vfio/platform/vfio_platform_irq.c         |   8 +-
 drivers/vfio/vfio.h                               |  25 ++-
 drivers/vfio/vfio_iommu_type1.c                   | 248 +++++++++-----------
 drivers/vfio/vfio_main.c                          |  70 +++++-
 drivers/vfio/virqfd.c                             |   2 +-
 include/linux/vfio.h                              |   6 +-
 include/uapi/linux/vfio.h                         |  15 +-
 samples/Kconfig                                   |  19 +-
 samples/vfio-mdev/README.rst                      | 100 +++++++++
 33 files changed, 756 insertions(+), 422 deletions(-)
 create mode 100644 samples/vfio-mdev/README.rst

