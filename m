Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A0F2F946F
	for <lists+kvm@lfdr.de>; Sun, 17 Jan 2021 19:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbhAQSQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 13:16:22 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15746 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbhAQSQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 13:16:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60047ecb0000>; Sun, 17 Jan 2021 10:15:39 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 17 Jan
 2021 18:15:39 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Sun, 17 Jan 2021 18:15:35 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <jgg@nvidia.com>, <liranl@nvidia.com>, <oren@nvidia.com>,
        <tzahio@nvidia.com>, <leonro@nvidia.com>, <yarong@nvidia.com>,
        <aviadye@nvidia.com>, <shahafs@nvidia.com>, <artemp@nvidia.com>,
        <kwankhede@nvidia.com>, <ACurrid@nvidia.com>, <gmataev@nvidia.com>,
        <cjia@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Date:   Sun, 17 Jan 2021 18:15:31 +0000
Message-ID: <20210117181534.65724-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610907339; bh=cZxuhQ/Stj31VbqhP+SsSpV6fSsj+nQppuqqTMbTnK8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=JimQaeZL+eFUUU7ZyJKcuozZNid60c3LARdrZKS3EKqB2kOH1PD/ZGsvCDP0cc7Sy
         Yt/etQZgacMUtSmL/LIp7oXQJLpXIMB56UkPT5TsGzIeXirFfg/zM78EnhVR25Ih7e
         gXDK2fas/EHVqVtx1MnZZHPrrESmkCVAE8mrw327+FJ6VCWOkPtPfr7p4O6eynB8hK
         7TFrVIKRq3q0L55aWczULZtSJinMVqLqN4GVaQESTxpqD8lmda7ycALBdtNaxlzn3j
         gJ34jjCiq5c0XsH2HxHsR9DKwdWxK/RbRZicxkglsAbNwZDOODxhFh7Ji4spv0TkSO
         cJeQ0EvBUvDTQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex and Cornelia,

This series split the vfio_pci driver into 2 parts: pci driver and a
subsystem driver that will also be library of code. The pci driver,
vfio_pci.ko will be used as before and it will bind to the subsystem
driver vfio_pci_core.ko to register to the VFIO subsystem. This patchset
if fully backward compatible. This is a typical Linux subsystem
framework behaviour. This framework can be also adopted by vfio_mdev
devices as we'll see in the below sketch.

This series is coming to solve the issues that were raised in the
previous attempt for extending vfio-pci for vendor specific
functionality: https://lkml.org/lkml/2020/5/17/376 by Yan Zhao.

This solution is also deterministic in a sense that when a user will
bind to a vendor specific vfio-pci driver, it will get all the special
goodies of the HW.
=20
This subsystem framework will also ease on adding vendor specific
functionality to VFIO devices in the future by allowing another module
to provide the pci_driver that can setup number of details before
registering to VFIO subsystem (such as inject its own operations).

Below we can see the proposed changes (this patchset only deals with
VFIO_PCI subsystem but it can easily be extended to VFIO_MDEV subsystem
as well):

+----------------------------------------------------------------------+
|                                                                      |
|                                VFIO                                  |
|                                                                      |
+----------------------------------------------------------------------+

+--------------------------------+    +--------------------------------+
|                                |    |                                |
|          VFIO_PCI_CORE         |    |          VFIO_MDEV_CORE        |
|                                |    |                                |
+--------------------------------+    +--------------------------------+

+---------------+ +--------------+    +---------------+ +--------------+
|               | |              |    |               | |              |
|               | |              |    |               | |              |
| VFIO_PCI      | | MLX5_VFIO_PCI|    | VFIO_MDEV     | |MLX5_VFIO_MDEV|
|               | |              |    |               | |              |
|               | |              |    |               | |              |
+---------------+ +--------------+    +---------------+ +--------------+

First 2 patches introduce the above changes for vfio_pci and
vfio_pci_core.

Patch (3/3) introduces a new mlx5 vfio-pci module that registers to VFIO
subsystem using vfio_pci_core. It also registers to Auxiliary bus for
binding to mlx5_core that is the parent of mlx5-vfio-pci devices. This
will allow extending mlx5-vfio-pci devices with HW specific features
such as Live Migration (mlx5_core patches are not part of this series
that comes for proposing the changes need for the vfio pci subsystem).

These devices will be seen on the Auxiliary bus as:
mlx5_core.vfio_pci.2048 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05=
:00.0/0000:06:00.0/0000:07:00.0/mlx5_core.vfio_pci.2048
mlx5_core.vfio_pci.2304 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05=
:00.0/0000:06:00.0/0000:07:00.1/mlx5_core.vfio_pci.2304

2048 represents BDF 08:00.0 and 2304 represents BDF 09:00.0 in decimal
view. In this manner, the administrator will be able to locate the
correct vfio-pci module it should bind the desired BDF to (by finding
the pointer to the module according to the Auxiliary driver of that
BDF).

In this way, we'll use the HW vendor driver core to manage the lifecycle
of these devices. This is reasonable since only the vendor driver knows
exactly about the status on its internal state and the capabilities of
its acceleratots, for example.

TODOs:
1. For this RFC we still haven't cleaned all vendor specific stuff that
   were merged in the past into vfio_pci (such as VFIO_PCI_IG and
   VFIO_PCI_NVLINK2).
2. Create subsystem module for VFIO_MDEV. This can be used for vendor
   specific scalable functions for example (SFs).
3. Add Live migration functionality for mlx5 SNAP devices
   (NVMe/Virtio-BLK).
4. Add Live migration functionality for mlx5 VFs
5. Add the needed functionality for mlx5_core

I would like to thank the great team that was involved in this
development, design and internal review:
Oren, Liran, Jason, Leon, Aviad, Shahaf, Gary, Artem, Kirti, Neo, Andy
and others.

This series applies cleanly on top of kernel 5.11-rc2+ commit 2ff90100ace8:
"Merge tag 'hwmon-for-v5.11-rc3' of git://git.kernel.org/pub/scm/linux/kern=
el/git/groeck/linux-staging"
from Linus.

Note: Live migration for MLX5 SNAP devices is WIP and will be the first
      example for adding vendor extension to vfio-pci devices. As the
      changes to the subsystem must be defined as a pre-condition for
      this work, we've decided to split the submission for now.

Max Gurtovoy (3):
  vfio-pci: rename vfio_pci.c to vfio_pci_core.c
  vfio-pci: introduce vfio_pci_core subsystem driver
  mlx5-vfio-pci: add new vfio_pci driver for mlx5 devices

 drivers/vfio/pci/Kconfig            |   22 +-
 drivers/vfio/pci/Makefile           |   16 +-
 drivers/vfio/pci/mlx5_vfio_pci.c    |  253 +++
 drivers/vfio/pci/vfio_pci.c         | 2386 +--------------------------
 drivers/vfio/pci/vfio_pci_core.c    | 2311 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |   21 +
 include/linux/mlx5/vfio_pci.h       |   36 +
 7 files changed, 2734 insertions(+), 2311 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci.c
 create mode 100644 drivers/vfio/pci/vfio_pci_core.c
 create mode 100644 include/linux/mlx5/vfio_pci.h

--=20
2.25.4

