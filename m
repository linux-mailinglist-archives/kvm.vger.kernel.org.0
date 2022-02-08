Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772D14AD9F5
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348493AbiBHNfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbiBHNfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 08:35:31 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9B6C03FECE;
        Tue,  8 Feb 2022 05:35:29 -0800 (PST)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtPBX6x53z67Zjj;
        Tue,  8 Feb 2022 21:34:44 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 14:35:26 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 13:35:20 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [RFC v4 0/8] vfio/hisilicon: add ACC live migration driver
Date:   Tue, 8 Feb 2022 13:34:17 +0000
Message-ID: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
definition and mlx5 v7 series discussed here[0]. Many thanks to
everyone involved in the v2 protocol discussions.

Since the v2 protocol is still under discussion, this is provided
as a RFC for now. This migration driver supports only the
VFIO_MIGRATION_STOP_COPY and doesn't have the support for optional
VFIO_MIGRATION_P2P or VFIO_MIGRATION_PRE_COPY features.

Since we are not making use of the PRE_COPY state as used in v1,
the compatibility check for source and destination devices is now
done once the migration data transfer is finished. As discussed
here[1], this is not ideal as it will delay reporting the error
in case of a mismatch.

This is sanity tested on a HiSilicon platform using the Qemu branch
provided here[2].

Please take a look and let know your feedback.

Thanks,
Shameer
[0] https://lore.kernel.org/netdev/20220207172216.206415-1-yishaih@nvidia.com/
[1] https://lore.kernel.org/kvm/20220202103041.2b404d13.alex.williamson@redhat.com/
[2] https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2 


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
  crypto: hisilicon/qm: Add helper to retrieve the PF qm data
  hisi_acc_vfio_pci: Use its own PCI reset_done error handler

 drivers/crypto/hisilicon/hpre/hpre.h          |    2 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c     |   18 +-
 drivers/crypto/hisilicon/qm.c                 |   72 +-
 drivers/crypto/hisilicon/sec2/sec.h           |    2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c      |   20 +-
 drivers/crypto/hisilicon/sgl.c                |    2 +-
 drivers/crypto/hisilicon/zip/zip.h            |    2 +-
 drivers/crypto/hisilicon/zip/zip_main.c       |   17 +-
 drivers/vfio/pci/Kconfig                      |    9 +
 drivers/vfio/pci/Makefile                     |    3 +
 drivers/vfio/pci/hisi_acc_vfio_pci.c          | 1232 +++++++++++++++++
 drivers/vfio/pci/hisi_acc_vfio_pci.h          |  121 ++
 .../qm.h => include/linux/hisi_acc_qm.h       |   44 +
 include/linux/pci_ids.h                       |    6 +
 14 files changed, 1496 insertions(+), 54 deletions(-)
 create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c
 create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.h
 rename drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h (87%)

-- 
2.17.1

