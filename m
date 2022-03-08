Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E384D207E
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349701AbiCHSuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349685AbiCHSuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:50:20 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA64A532EB;
        Tue,  8 Mar 2022 10:49:22 -0800 (PST)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KCkq2469kz67Qtq;
        Wed,  9 Mar 2022 02:47:58 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Tue, 8 Mar 2022 19:49:20 +0100
Received: from A2006125610.china.huawei.com (10.47.82.254) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 18:49:12 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v9 0/9] vfio/hisilicon: add ACC live migration driver
Date:   Tue, 8 Mar 2022 18:48:53 +0000
Message-ID: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.82.254]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.2 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This series attempts to add vfio live migration support for HiSilicon
ACC VF devices based on the new v2 migration protocol definition and
mlx5 v9 series discussed here[0].

v8 --> v9
 - Added acks by Wangzhou/Longfang/Yekai
 - Added R-by tags by Jason.
 - Addressed comments by Alex on v8.
 - Fixed the pf_queue pointer assignment error in patch #8.
 - Addressed comments from Kevin,
    -Updated patch #5 commit log msg with a clarification that VF
     migration BAR assignment is fine if migration support is not there.
    -Added QM description to patch #8 commit msg.

This is sanity tested on a HiSilicon platform using the Qemu branch
provided here[1].

Please take a look and let me know your feedback.

Thanks,
Shameer
[0] https://lore.kernel.org/kvm/20220224142024.147653-1-yishaih@nvidia.com/
[1] https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2

v7 --> v8
 - Dropped PRE_COPY support and early compatibility checking based on
   the discussion here[1].
 - Addressed comments from John, Jason & Alex (Thanks!).

v6 --> v7
 -Renamed MIG_PRECOPY ioctl name and struct name. Updated ioctl descriptions
  regarding ioctl validity (patch #7).
- Adressed comments from Jason and Alex on PRE_COPY read() and ioctl() fns
  (patch #9).
- Moved only VF PCI ids to pci_ids.h(patch #3).

v5 --> v6
 -Report PRE_COPY support and use that for early compatibility check
  between src and dst devices.
 -For generic PRE_COPY support, included patch #7 from Jason(Thanks!).
 -Addressed comments from Alex(Thanks!).
 -Added the QM state register update to QM driver(patch #8) since that
  is being used in migration driver to decide whether the device is
  ready to save the state.

RFCv4 --> v5
  - Dropped RFC tag as v2 migration APIs are more stable now.
  - Addressed review comments from Jason and Alex (Thanks!).

v3 --> RFCv4
-Based on migration v2 protocol and mlx5 v7 series.
-Added RFC tag again as migration v2 protocol is still under discussion.
-Added new patch #6 to retrieve the PF QM data.
-PRE_COPY compatibility check is now done after the migration data
 transfer. This is not ideal and needs discussion.

RFC v2 --> v3
 -Dropped RFC tag as the vfio_pci_core subsystem framework is now
  part of 5.15-rc1.
 -Added override methods for vfio_device_ops read/write/mmap calls
  to limit the access within the functional register space.
 -Patches 1 to 3 are code refactoring to move the common ACC QM
  definitions and header around.

RFCv1 --> RFCv2

 -Adds a new vendor-specific vfio_pci driver(hisi-acc-vfio-pci)
  for HiSilicon ACC VF devices based on the new vfio-pci-core
  framework proposal.

 -Since HiSilicon ACC VF device MMIO space contains both the
  functional register space and migration control register space,
  override the vfio_device_ops ioctl method to report only the
  functional space to VMs.

 -For a successful migration, we still need access to VF dev
  functional register space mainly to read the status registers.
  But accessing these while the Guest vCPUs are running may leave
  a security hole. To avoid any potential security issues, we
  map/unmap the MMIO regions on a need basis and is safe to do so.
  (Please see hisi_acc_vf_ioremap/unmap() fns in patch #4).
 
 -Dropped debugfs support for now.
 -Uses common QM functions for mailbox access(patch #3).

Longfang Liu (3):
  crypto: hisilicon/qm: Move few definitions to common header
  crypto: hisilicon/qm: Set the VF QM state register
  hisi_acc_vfio_pci: Add support for VFIO live migration

Shameer Kolothum (6):
  crypto: hisilicon/qm: Move the QM header to include/linux
  hisi_acc_qm: Move VF PCI device IDs to common header
  hisi_acc_vfio_pci: add new vfio_pci driver for HiSilicon ACC devices
  hisi_acc_vfio_pci: Restrict access to VF dev BAR2 migration region
  hisi_acc_vfio_pci: Add helper to retrieve the struct pci_driver
  hisi_acc_vfio_pci: Use its own PCI reset_done error handler

 MAINTAINERS                                   |    7 +
 drivers/crypto/hisilicon/hpre/hpre.h          |    2 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c     |   19 +-
 drivers/crypto/hisilicon/qm.c                 |   68 +-
 drivers/crypto/hisilicon/sec2/sec.h           |    2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c      |   21 +-
 drivers/crypto/hisilicon/sgl.c                |    2 +-
 drivers/crypto/hisilicon/zip/zip.h            |    2 +-
 drivers/crypto/hisilicon/zip/zip_main.c       |   17 +-
 drivers/vfio/pci/Kconfig                      |    2 +
 drivers/vfio/pci/Makefile                     |    2 +
 drivers/vfio/pci/hisilicon/Kconfig            |   15 +
 drivers/vfio/pci/hisilicon/Makefile           |    4 +
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 1326 +++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  116 ++
 .../qm.h => include/linux/hisi_acc_qm.h       |   49 +
 include/linux/pci_ids.h                       |    3 +
 17 files changed, 1591 insertions(+), 66 deletions(-)
 create mode 100644 drivers/vfio/pci/hisilicon/Kconfig
 create mode 100644 drivers/vfio/pci/hisilicon/Makefile
 create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
 create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
 rename drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h (87%)

-- 
2.25.1

