Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6F63B9EA0
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 11:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhGBKBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 06:01:50 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3342 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhGBKBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 06:01:49 -0400
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GGVhq1hXHz6G8FM;
        Fri,  2 Jul 2021 17:51:23 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 11:59:15 +0200
Received: from A2006125610.china.huawei.com (10.47.85.147) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 10:59:08 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <yuzenghui@huawei.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Date:   Fri, 2 Jul 2021 10:58:45 +0100
Message-ID: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.85.147]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This series attempts to add vfio live migration support for
HiSilicon ACC VF devices. HiSilicon ACC VF device MMIO space
includes both the functional register space and migration 
control register space. As discussed in RFCv1[0], this may create
security issues as these regions get shared between the Guest
driver and the migration driver. Based on the feedback, we tried
to address those concerns in this version. 

This is now based on the new vfio-pci-core framework proposal[1].
Understand that the framework proposal is still under discussion,
but really appreciate any feedback on the approach taken here
to mitigate the security risks.

The major changes from v1 are,

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

This is now sanity tested on HiSilicon platforms that support these
ACC devices.

From v1:
 -In order to ensure the compatibility of the devices before and
  after the migration, the device compatibility information check
  will be performed in the Pre-copy stage. If the check fails,
  an error will be returned and the source VM will exit the migration.
 -After the compatibility check is passed, it will enter the
  Stop-and-copy stage. At this time, all the live migration data
  will be copied and saved to the VF device of the destination.
  Finally, the VF device of the destination will be started.

Thanks,
Shameer
[0] https://lore.kernel.org/lkml/20210415220137.GA1672608@nvidia.com/
[1] https://lore.kernel.org/lkml/20210603160809.15845-1-mgurtovoy@nvidia.com/

Longfang Liu (2):
  crypto: hisilicon/qm - Export mailbox functions for common use
  hisi_acc_vfio_pci: Add support for vfio live migration

Shameer Kolothum (2):
  hisi-acc-vfio-pci: add new vfio_pci driver for HiSilicon ACC devices
  hisi_acc_vfio_pci: Override ioctl method to limit BAR2 region size

 drivers/crypto/hisilicon/qm.c        |    8 +-
 drivers/crypto/hisilicon/qm.h        |    4 +
 drivers/vfio/pci/Kconfig             |   13 +
 drivers/vfio/pci/Makefile            |    2 +
 drivers/vfio/pci/hisi_acc_vfio_pci.c | 1155 ++++++++++++++++++++++++++
 drivers/vfio/pci/hisi_acc_vfio_pci.h |  144 ++++
 6 files changed, 1323 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c
 create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.h

-- 
2.17.1

