Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EF830AC92
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhBAQ3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:29:15 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18188 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhBAQ3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:29:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c320000>; Mon, 01 Feb 2021 08:28:34 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:28:33 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:28:29 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v2 0/9] Introduce vfio-pci-core subsystem
Date:   Mon, 1 Feb 2021 16:28:19 +0000
Message-ID: <20210201162828.5938-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196914; bh=JOHUJGgZP4f+PKr2kMxm2+gk8j/D8K5EuMOq21uy3gE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=qhv2ioT4bFxaVDLCNCtoM19721RK4XMYEpM7JJ6HQ961lwv4MIn/RYx8m7iqlrWL9
         0/1WpITpIFnrbsoqul4wt/pWyZhi92UCVh25DtsuN1SyezJ8ReEkp3lnLI5OvH2Sr/
         d59u+1+jF1drXjMHzzXgyIvt5Unfhfv2jjAdi5V/d7/6ZDUmmUvgyheM/wvvuMvDid
         9QsKRN6t7wAFrXYNomjwoiduCyd6TJ/uq/pKRmwc/SiRrJ0gsSSJeNpazpsF3rMdXu
         txrXAQxkLckx/zQei3q3bID6XPP9re4VwbnbPwvqluM3KU6Hu/PHQDeprtM1Dpx70q
         RHz/7k0PXumnw==
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

+------------------------------------------------------------------+
|                                                                  |
|                               VFIO                               |
|                                                                  |
+------------------------------------------------------------------+

+------------------------------+    +------------------------------+
|                              |    |                              |
|        VFIO_PCI_CORE         |    |         VFIO_MDEV_CORE       |
|                              |    |                              |
+------------------------------+    +------------------------------+

+--------------+ +-------------+    +-------------+ +--------------+
|              | |             |    |             | |              |
|              | |             |    |             | |              |
|   VFIO_PCI   | |MLX5_VFIO_PCI|    |  VFIO_MDEV  | |MLX5_VFIO_MDEV|
|              | |             |    |             | |              |
|              | |             |    |             | |              |
+--------------+ +-------------+    +-------------+ +--------------+

First 3 patches introduce the above changes for vfio_pci and
vfio_pci_core.

Patch (4/9) introduces a new mlx5 vfio-pci module that registers to VFIO
subsystem using vfio_pci_core. It also registers to Auxiliary bus for
binding to mlx5_core that is the parent of mlx5-vfio-pci devices. This
will allow extending mlx5-vfio-pci devices with HW specific features
such as Live Migration (mlx5_core patches are not part of this series
that comes for proposing the changes need for the vfio pci subsystem).

For our testing and development we used 2 VirtIO-BLK physical functions
based on NVIDIAs Bluefield-2 SNAP technology. These 2 PCI functions were
enumerated as 08:00.0 and 09:00.0 by the Hypervisor.

The Bluefield-2 device driver, mlx5_core, will create auxiliary devices
for each VirtIO-BLK SNAP PF (the "parent"/"manager" of each VirtIO-BLK PF
will actually issue auxiliary device creation).

These auxiliary devices will be seen on the Auxiliary bus as:
mlx5_core.vfio_pci.2048 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05=
:00.0/0000:06:00.0/0000:07:00.0/mlx5_core.vfio_pci.2048
mlx5_core.vfio_pci.2304 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05=
:00.0/0000:06:00.0/0000:07:00.1/mlx5_core.vfio_pci.2304

2048 represents BDF 08:00.0 (parent is 0000:07:00.0 Bluefield-2 p0) and
2304 represents BDF 09:00.0 (parent is 0000:07:00.1 Bluefield-2 p1) in
decimal view. In this manner, the administrator will be able to locate the
correct vfio-pci module it should bind the desired BDF to (by finding
the pointer to the module according to the Auxiliary driver of that BDF).

Note: The discovery mechanism we used for the RFC might need some
      improvements as mentioned in the TODO list.

In this way, we'll use the HW vendor driver core to manage the lifecycle
of these devices. This is reasonable since only the vendor driver knows
exactly about the status on its internal state and the capabilities of
its acceleratots, for example.

changes from v1:
 - Create a private and public vfio-pci structures (From Alex)
 - register to vfio core directly from vfio-pci-core (for now, expose
   minimal public funcionality to vfio pci drivers. This will remove the
   implicit behaviour from v1. More power to the drivers can be added in
   the future)
 - Add patch 3/9 to emphasize the needed extension for LM feature (From
   Cornelia)
 - take/release refcount for the pci module during core open/release
 - update nvlink, igd and zdev to PowerNV, X86 and s390 extensions for
   vfio-pci core
 - fix segfault bugs in current vfio-pci zdev code

TODOs:
1. Create subsystem module for VFIO_MDEV. This can be used for vendor
   specific scalable functions for example (SFs).
2. Add Live migration functionality for mlx5 SNAP devices
   (NVMe/Virtio-BLK).
3. Add Live migration functionality for mlx5 VFs
4. Add the needed functionality for mlx5_core
5. Improve userspace and discovery
6. move VGA stuff to x86 extension

I would like to thank the great team that was involved in this
development, design and internal review:
Oren, Liran, Jason, Leon, Aviad, Shahaf, Gary, Artem, Kirti, Neo, Andy
and others.

This series applies cleanly on top of kernel 5.11-rc5+ commit 13391c60da33:
"Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herb=
ert/crypto-2.6"
from Linus.

Note: Live migration for MLX5 SNAP devices is WIP and can be the first
      example for adding vendor extension to vfio-pci devices. As the
      changes to the subsystem must be defined as a pre-condition for
      this work, we've decided to split the submission for now.

Max Gurtovoy (9):
  vfio-pci: rename vfio_pci.c to vfio_pci_core.c
  vfio-pci: introduce vfio_pci_core subsystem driver
  vfio-pci-core: export vfio_pci_register_dev_region function
  mlx5-vfio-pci: add new vfio_pci driver for mlx5 devices
  vfio-pci/zdev: remove unused vdev argument
  vfio-pci/zdev: fix possible segmentation fault issue
  vfio/pci: use s390 naming instead of zdev
  vfio/pci: use x86 naming instead of igd
  vfio/pci: use powernv naming instead of nvlink2

 drivers/vfio/pci/Kconfig                      |   57 +-
 drivers/vfio/pci/Makefile                     |   16 +-
 drivers/vfio/pci/mlx5_vfio_pci.c              |  253 ++
 drivers/vfio/pci/vfio_pci.c                   | 2384 +----------------
 drivers/vfio/pci/vfio_pci_config.c            |   56 +-
 drivers/vfio/pci/vfio_pci_core.c              | 2326 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.h              |   73 +
 drivers/vfio/pci/vfio_pci_intrs.c             |   22 +-
 ...{vfio_pci_nvlink2.c =3D> vfio_pci_powernv.c} |   47 +-
 drivers/vfio/pci/vfio_pci_private.h           |   44 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |   14 +-
 .../pci/{vfio_pci_zdev.c =3D> vfio_pci_s390.c}  |   28 +-
 .../pci/{vfio_pci_igd.c =3D> vfio_pci_x86.c}    |   18 +-
 include/linux/mlx5/vfio_pci.h                 |   36 +
 14 files changed, 2916 insertions(+), 2458 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci.c
 create mode 100644 drivers/vfio/pci/vfio_pci_core.c
 create mode 100644 drivers/vfio/pci/vfio_pci_core.h
 rename drivers/vfio/pci/{vfio_pci_nvlink2.c =3D> vfio_pci_powernv.c} (89%)
 rename drivers/vfio/pci/{vfio_pci_zdev.c =3D> vfio_pci_s390.c} (80%)
 rename drivers/vfio/pci/{vfio_pci_igd.c =3D> vfio_pci_x86.c} (89%)
 create mode 100644 include/linux/mlx5/vfio_pci.h

--=20
2.25.4

