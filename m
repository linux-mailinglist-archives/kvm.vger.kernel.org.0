Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143AA4E4693
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 20:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiCVTWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 15:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiCVTWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 15:22:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 396A9674D2
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 12:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647976863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uobYkTlHaU5hNxcuMpSrqFNKe1fOGuBAldZ6JiUI3Lc=;
        b=F4peW2D/ahr5n3uOke8ZYI532FiYGC7yLn5IlyBiz9G7/aZs4k3MqJPu5gFHNxnGi89VYV
        DoMXN+8HtMMR/SUHogPW118Snyi44YBnAJ9ndqaC0a/RsqS9yaLsZytVK2NqX5/bofSNpj
        /65/TFjOeQaBBpxXrsG8U8SNA5nSdI4=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-5xJqRu29ML6AtdGD-Z_6lg-1; Tue, 22 Mar 2022 15:21:00 -0400
X-MC-Unique: 5xJqRu29ML6AtdGD-Z_6lg-1
Received: by mail-il1-f200.google.com with SMTP id y7-20020a92d207000000b002c7f55e413bso6575285ily.5
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 12:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-transfer-encoding;
        bh=uobYkTlHaU5hNxcuMpSrqFNKe1fOGuBAldZ6JiUI3Lc=;
        b=1Bb4QU2s8OU3Xany16NdMUC9mNT8vTXfblpQz0bLWpwDg/7qf0blpjAShwf0WgijHP
         ym2x/df/5smIy/VRYG1rwhBntGQ8DKQBuebyDJ5VFR23ABvMhDRBJv/MQwQZWl/3gq+z
         ll7QJPAKUQcxb83VaLvuZ22uszO7lcGm5KpWcj5i7KFeOpOpT6BP/+5EzqP5jtYTY526
         rzQr2Po2Q2gqUNfkF2O+YT9/ocRMTdHZD6/29ktHm6esRh/K08sFaQuHJ4ftbzH9VKKC
         BEkDII4vN2VSw9gtTJ3qZWVhRuyjmkQdoAI5QahCmyw7cxg9cNLuzSeFp8eiT76BXqMM
         T2dg==
X-Gm-Message-State: AOAM531wbrtffi4es2Nt6btm3jg3J2a9CdC343WFeoU0fGNWOFt3uubK
        yJabyuMxMBMHLPbErxmgzb10ct+uM4UVIlaPUJnn1FGh1Fv7Gb0W2wsH1owoImmKAW11PLS6Gxj
        wuFmgx2FVZiQo
X-Received: by 2002:a05:6e02:eca:b0:2c8:ffd:2f54 with SMTP id i10-20020a056e020eca00b002c80ffd2f54mr7938415ilk.228.1647976859474;
        Tue, 22 Mar 2022 12:20:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+yx9F9n69WeYYL/Ic50YblisiZdhUyh7eXisnUvnL4XX/n74xcyANfF9pxxkjfkzt6BgpeQ==
X-Received: by 2002:a05:6e02:eca:b0:2c8:ffd:2f54 with SMTP id i10-20020a056e020eca00b002c80ffd2f54mr7938400ilk.228.1647976859223;
        Tue, 22 Mar 2022 12:20:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r9-20020a6bd909000000b00649276ea9fesm10040705ioc.7.2022.03.22.12.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 12:20:58 -0700 (PDT)
Date:   Tue, 22 Mar 2022 13:20:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [GIT PULL] VFIO updates for v5.18-rc1
Message-ID: <20220322132057.5cf2a4a1.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit cfb92440ee71adcc2105b0890bb01ac3cddb8507:

  Linux 5.17-rc5 (2022-02-20 13:07:20 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v5.18-rc1

for you to fetch changes up to f621eb13facb7681a79f4fec8ec6553ae160da76:

  vfio-pci: Provide reviewers and acceptance criteria for variant drivers (2022-03-17 09:57:11 -0600)

----------------------------------------------------------------
VFIO updates for v5.18-rc1

 - Introduce new device migration uAPI and implement device specific
   mlx5 vfio-pci variant driver supporting new protocol (Jason Gunthorpe,
   Yishai Hadas, Leon Romanovsky)

 - New HiSilicon acc vfio-pci variant driver, also supporting migration
   interface (Shameer Kolothum, Longfang Liu)

 - D3hot fixes for vfio-pci-core (Abhishek Sahu)

 - Document new vfio-pci variant driver acceptance criteria
   (Alex Williamson)

 - Fix UML build unresolved ioport_{un}map() functions
   (Alex Williamson)

 - Fix MAINTAINERS due to header movement (Lukas Bulwahn)

----------------------------------------------------------------
Abhishek Sahu (2):
      vfio/pci: fix memory leak during D3hot to D0 transition
      vfio/pci: wake-up devices around reset functions

Alex Williamson (4):
      vfio/pci: Stub vfio_pci_vga_rw when !CONFIG_VFIO_PCI_VGA
      Merge tag 'mlx5-vfio-v10' of https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux into v5.18/vfio/next/mlx5-migration-v10
      Merge branches 'v5.18/vfio/next/mlx5-migration-v10', 'v5.18/vfio/next/pm-fixes' and 'v5.18/vfio/next/uml-build-fix' into v5.18/vfio/next/next
      vfio-pci: Provide reviewers and acceptance criteria for variant drivers

Jason Gunthorpe (6):
      PCI/IOV: Add pci_iov_vf_id() to get VF index
      PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
      vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
      vfio: Define device migration protocol v2
      vfio: Extend the device migration protocol with RUNNING_P2P
      vfio: Remove migration protocol v1 documentation

Leon Romanovsky (2):
      net/mlx5: Reuse exported virtfn index function call
      PCI/IOV: Fix wrong kernel-doc identifier

Longfang Liu (3):
      crypto: hisilicon/qm: Move few definitions to common header
      crypto: hisilicon/qm: Set the VF QM state register
      hisi_acc_vfio_pci: Add support for VFIO live migration

Lukas Bulwahn (1):
      MAINTAINERS: adjust entry for header movement in hisilicon qm driver

Shameer Kolothum (6):
      crypto: hisilicon/qm: Move the QM header to include/linux
      hisi_acc_qm: Move VF PCI device IDs to common header
      hisi_acc_vfio_pci: add new vfio_pci driver for HiSilicon ACC devices
      hisi_acc_vfio_pci: Restrict access to VF dev BAR2 migration region
      hisi_acc_vfio_pci: Add helper to retrieve the struct pci_driver
      hisi_acc_vfio_pci: Use its own PCI reset_done error handler

Yishai Hadas (9):
      net/mlx5: Disable SRIOV before PF removal
      net/mlx5: Expose APIs to get/put the mlx5 core device
      net/mlx5: Introduce migration bits and structures
      net/mlx5: Add migration commands definitions
      vfio/mlx5: Expose migration commands over mlx5 device
      vfio/mlx5: Implement vfio_pci driver for mlx5 devices
      vfio/pci: Expose vfio_pci_core_aer_err_detected()
      vfio/mlx5: Use its own PCI reset_done error handler
      vfio/mlx5: Fix to not use 0 as NULL pointer

 Documentation/driver-api/index.rst                 |    1 +
 .../vfio-pci-device-specific-driver-acceptance.rst |   35 +
 .../maintainer/maintainer-entry-profile.rst        |    1 +
 MAINTAINERS                                        |   25 +-
 drivers/crypto/hisilicon/hpre/hpre.h               |    2 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   19 +-
 drivers/crypto/hisilicon/qm.c                      |   68 +-
 drivers/crypto/hisilicon/sec2/sec.h                |    2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   21 +-
 drivers/crypto/hisilicon/sgl.c                     |    2 +-
 drivers/crypto/hisilicon/zip/zip.h                 |    2 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |   17 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   45 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   17 +-
 drivers/pci/iov.c                                  |   43 +
 drivers/vfio/pci/Kconfig                           |    5 +
 drivers/vfio/pci/Makefile                          |    4 +
 drivers/vfio/pci/hisilicon/Kconfig                 |   15 +
 drivers/vfio/pci/hisilicon/Makefile                |    4 +
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     | 1326 ++++++++++++++++++++
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h     |  116 ++
 drivers/vfio/pci/mlx5/Kconfig                      |   10 +
 drivers/vfio/pci/mlx5/Makefile                     |    4 +
 drivers/vfio/pci/mlx5/cmd.c                        |  259 ++++
 drivers/vfio/pci/mlx5/cmd.h                        |   36 +
 drivers/vfio/pci/mlx5/main.c                       |  676 ++++++++++
 drivers/vfio/pci/vfio_pci.c                        |    1 +
 drivers/vfio/pci/vfio_pci_core.c                   |  162 ++-
 drivers/vfio/pci/vfio_pci_rdwr.c                   |    2 +
 drivers/vfio/vfio.c                                |  296 ++++-
 .../hisilicon/qm.h => include/linux/hisi_acc_qm.h  |   49 +
 include/linux/mlx5/driver.h                        |    3 +
 include/linux/mlx5/mlx5_ifc.h                      |  147 ++-
 include/linux/pci.h                                |   15 +-
 include/linux/pci_ids.h                            |    3 +
 include/linux/vfio.h                               |   53 +
 include/linux/vfio_pci_core.h                      |   13 +
 include/uapi/linux/vfio.h                          |  406 +++---
 40 files changed, 3558 insertions(+), 358 deletions(-)
 create mode 100644 Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst
 create mode 100644 drivers/vfio/pci/hisilicon/Kconfig
 create mode 100644 drivers/vfio/pci/hisilicon/Makefile
 create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
 create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c
 rename drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h (87%)

