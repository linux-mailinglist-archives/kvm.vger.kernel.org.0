Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E0040C2F7
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 11:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbhIOJwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 05:52:18 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3814 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbhIOJwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 05:52:17 -0400
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8b4w348nz67xvT;
        Wed, 15 Sep 2021 17:48:32 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:50:56 +0200
Received: from A2006125610.china.huawei.com (10.47.83.177) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 10:50:50 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Date:   Wed, 15 Sep 2021 10:50:31 +0100
Message-ID: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.83.177]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Thanks to the introduction of vfio_pci_core subsystem framework[0],
now it is possible to provide vendor specific functionality to
vfio pci devices. This series attempts to add vfio live migration
support for HiSilicon ACC VF devices based on the new framework.

HiSilicon ACC VF device MMIO space includes both the functional
register space and migration control register space. As discussed
in RFCv1[1], this may create security issues as these regions get
shared between the Guest driver and the migration driver.
Based on the feedback, we tried to address those concerns in
this version. 

This is now sanity tested on HiSilicon platforms that support these
ACC devices.

Thanks,
Shameer

[0] https://lore.kernel.org/kvm/20210826103912.128972-1-yishaih@nvidia.com/
[1] https://lore.kernel.org/lkml/20210415220137.GA1672608@nvidia.com/

Change History:

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

Shameer Kolothum (4):
  crypto: hisilicon/qm: Move the QM header to include/linux
  hisi_acc_qm: Move PCI device IDs to common header
  hisi-acc-vfio-pci: add new vfio_pci driver for HiSilicon ACC devices
  hisi_acc_vfio_pci: Restrict access to VF dev BAR2 migration region

 drivers/crypto/hisilicon/hpre/hpre.h          |    2 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c     |   12 +-
 drivers/crypto/hisilicon/qm.c                 |   34 +-
 drivers/crypto/hisilicon/sec2/sec.h           |    2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c      |    2 -
 drivers/crypto/hisilicon/sgl.c                |    2 +-
 drivers/crypto/hisilicon/zip/zip.h            |    2 +-
 drivers/crypto/hisilicon/zip/zip_main.c       |   11 +-
 drivers/vfio/pci/Kconfig                      |   13 +
 drivers/vfio/pci/Makefile                     |    3 +
 drivers/vfio/pci/hisi_acc_vfio_pci.c          | 1217 +++++++++++++++++
 drivers/vfio/pci/hisi_acc_vfio_pci.h          |  117 ++
 .../qm.h => include/linux/hisi_acc_qm.h       |   45 +
 13 files changed, 1414 insertions(+), 48 deletions(-)
 create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c
 create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.h
 rename drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h (88%)

-- 
2.17.1

