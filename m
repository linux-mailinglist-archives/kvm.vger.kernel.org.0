Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E464BE110
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356580AbiBULla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:41:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiBULl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:41:29 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3601ADA8;
        Mon, 21 Feb 2022 03:41:06 -0800 (PST)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K2L2C51xkz67KVW;
        Mon, 21 Feb 2022 19:40:03 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 12:41:03 +0100
Received: from A2006125610.china.huawei.com (10.47.91.169) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 11:40:57 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v5 0/8] vfio/hisilicon: add ACC live migration driver
Date:   Mon, 21 Feb 2022 11:40:35 +0000
Message-ID: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.91.169]
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

This series attempts to add vfio live migration support for
HiSilicon ACC VF devices based on the new v2 migration protocol
definition and mlx5 v8 series discussed here[0].

RFCv4 --> v5
  - Dropped RFC tag as v2 migration APIs are more stable now.
  - Addressed review comments from Jason and Alex (Thanks!).

This is sanity tested on a HiSilicon platform using the Qemu branch
provided here[1].

Please take a look and let me know your feedback.

Thanks,
Shameer
[0] https://lore.kernel.org/kvm/20220220095716.153757-1-yishaih@nvidia.com/
[1] https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2


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

Longfang Liu (2):
  crypto: hisilicon/qm: Move few definitions to common header
  hisi_acc_vfio_pci: Add support for VFIO live migration

Shameer Kolothum (6):
  crypto: hisilicon/qm: Move the QM header to include/linux
  hisi_acc_qm: Move PCI device IDs to common header
  hisi_acc_vfio_pci: add new vfio_pci driver for HiSilicon ACC devices
  hisi_acc_vfio_pci: Restrict access to VF dev BAR2 migration region
  hisi_acc_vfio_pci: Add helper to retrieve the PF qm data
  hisi_acc_vfio_pci: Use its own PCI reset_done error handler

 drivers/crypto/hisilicon/hpre/hpre.h          |    2 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c     |   18 +-
 drivers/crypto/hisilicon/qm.c                 |   34 +-
 drivers/crypto/hisilicon/sec2/sec.h           |    2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c      |   20 +-
 drivers/crypto/hisilicon/sgl.c                |    2 +-
 drivers/crypto/hisilicon/zip/zip.h            |    2 +-
 drivers/crypto/hisilicon/zip/zip_main.c       |   17 +-
 drivers/vfio/pci/Kconfig                      |    2 +
 drivers/vfio/pci/Makefile                     |    2 +
 drivers/vfio/pci/hisilicon/Kconfig            |   16 +
 drivers/vfio/pci/hisilicon/Makefile           |    4 +
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 1316 +++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  119 ++
 .../qm.h => include/linux/hisi_acc_qm.h       |   44 +
 include/linux/pci_ids.h                       |    6 +
 16 files changed, 1552 insertions(+), 54 deletions(-)
 create mode 100644 drivers/vfio/pci/hisilicon/Kconfig
 create mode 100644 drivers/vfio/pci/hisilicon/Makefile
 create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
 create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
 rename drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h (88%)

-- 
2.25.1

