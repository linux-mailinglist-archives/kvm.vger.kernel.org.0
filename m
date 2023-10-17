Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B697CC4F2
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343934AbjJQNm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343839AbjJQNm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:42:57 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2041.outbound.protection.outlook.com [40.107.102.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B16F7
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:42:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjzMmMAEdHK1b163G9lHxtJ5Xui9jDa/eNKSPcVrZU9iXH6zyRZxoNNn3SDZMglP0WOTnmG35ssm/B/T9cAknc02vBg6ZQPOnN6OqyylGBaeLn7Sx99iSKpNKJgSbyxBD4gNZeNdDYAaSHBE3mAUJ9grvGQ9tlE0luyfkuUj/LsnV1HCGt63hHY7arbTwe8QgiKOdhIsvd1wBsfsmQ2AkJxJNT9lqTnQ8Dha9AYLO/9iIL6mrhWDuN31I8ykdusZ7vn0WOFen9jreFgWAs1KOoHs57ZwHHrtEHcp0hjm2XRuwKAuRSzTMLx2kKlsJ5L4aMxEu+6pZXNBviseggPsvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fc/Bwoemc6LCkX076U5fu8GJRtPUWnTfze5+FdUE9QM=;
 b=ZvPJdewNEsdgUVi44Is6B3/R933dGL44Yfyj7Xk2aySv6YcKnWS/9G8LveMY75l8F0t6NCHUUPC5c0NySvEcNGTiYtM5KutmjzehMyJtEMRr14mMjPOnVn89iWaeUwjK4n0NCvzShWgJHOabbso3TbUnzb5Ri8Ddc5G8hdtlAH08EVg8/hfi/ACoAx/wxYSEUn5mPTAtyVXCkgzbN8K0QZXkgIUD0nksQ+UZa9WO7a6sHn7OCbGwfNCBonXA19voGjjsMlMoTHq5sSEnTNr63OFGlRxk1C9AQ2r/xm2qo9nwHzWNmgb25B502kPeJxWHp8MBi27i7zLDTL0IFKtaFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fc/Bwoemc6LCkX076U5fu8GJRtPUWnTfze5+FdUE9QM=;
 b=Vi+odGwozCxBQ+S7kY5ZlKahO1w+JhLhPKPT+LGnKggGv9EeVUSPQErWiHtUD0PlBuoDMXmpJrjwLI6tcoLUULgSiL5fpPn/CSGOKy6L3BuaTDl4hRGqV64rWiOy584xA0qyyuIHgutkt7gzt4pE0mINnfrvnQuM+YPic+FxLxHANJRnKIL4DYzoP6icpBOzI2NVp+GIcJWIyKzT4e2WpohwxGgsHGHYa1Nl05WjaTfxYP/BYLChfif4bgwsPuWLd9OjfcGt7ZShACEmA9hVCXxse/IBd5Qd4XqDUw204iLbP3876dtYdEFz78LD80mD0cF5gEmTMvga/mt4x6IuWQ==
Received: from BL1PR13CA0200.namprd13.prod.outlook.com (2603:10b6:208:2be::25)
 by DM4PR12MB5101.namprd12.prod.outlook.com (2603:10b6:5:390::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 13:42:51 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:208:2be:cafe::4f) by BL1PR13CA0200.outlook.office365.com
 (2603:10b6:208:2be::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Tue, 17 Oct 2023 13:42:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.21 via Frontend Transport; Tue, 17 Oct 2023 13:42:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:42 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:41 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 17 Oct
 2023 06:42:38 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>
Subject: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Date:   Tue, 17 Oct 2023 16:42:08 +0300
Message-ID: <20231017134217.82497-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|DM4PR12MB5101:EE_
X-MS-Office365-Filtering-Correlation-Id: 97e1df6c-b18c-4e96-97fb-08dbcf16f52a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ftJuE30pkr3/Q45lYpTLpEtSNOHWIz8ZsgrYPapRIbrgYFid+BCkUNIEjLAec0dKJlTptJdyt8hW8MaKGVe3t3zC41OpfXknL8Lw+/OoUA6tihvdqrFjWcKLTGi8r3F0pQLLY9y62mNPUWcF7niXdFSmcOtUDl91b8B6zCUN4Yc0E/15b4wxiIMbL393cg7Q0d3p81V6wVPHG3qLcTJ2sQ6SPvONLii63iEyd+wuy4avah59HQGtE/gh2uj8ZKW0Ba3ywDX7dl9e+w0VwRzcwEilddK2kizEkfIa/brF7638QcNTYp8v2p1ojW3mjSms9P14MAl5kaLiJVwB9a9fy6MtGT8N2qubqLyWQd0PV16Rj3pLxxvoPDTnhZDP7f+JaUy4ETTK8TAo2XqTjlReCgQo7+rUjGGSPXZ0LYe8NZw9+HM5uHbcFbN2DB5n6ueFrQErNYxWQOR4JQPd1l1Qvd4vePnTY0VVCg3LGBKEH8sXsLu2hiEGvDHRkdEhmApCpX+D+mOlklpxgH4k4EpjS+bPzSDzBeIhcwWpjHHW17NwObxPADvD2YHYkaaBhMSnxAqHOoDdFXX362KXWPga4jIguBxoXpvNWL9GzjnlAn464QDFGAfeKAJA0gx7RO9nlfe6pZ+AGLEytXSpeg1cUZRDVvg3w0bui8YLAvSmfWCDVDdvq15bJ3sbcuQHe8tPMSmlro2OZNo6TRRiqHvNkn/GHIwXw5S2cq6YVv3w4IEQFyCdPbhr+Zi4vy7Z0cYsB1lA4NevnoAVgT5I0IEmHBDhuieL3x7a0QId8dODrPxFTUdTWGD5AFplw/FPq7v1ByRjVvR0fSvWfhypcvLm4A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(82310400011)(186009)(64100799003)(1800799009)(451199024)(40470700004)(36840700001)(46966006)(36756003)(40480700001)(40460700003)(110136005)(316002)(6636002)(54906003)(70586007)(70206006)(86362001)(82740400003)(7636003)(356005)(36860700001)(83380400001)(426003)(336012)(107886003)(26005)(1076003)(2616005)(8936002)(966005)(6666004)(7696005)(2906002)(478600001)(41300700001)(5660300002)(8676002)(47076005)(4326008)(21314003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:42:51.0465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e1df6c-b18c-4e96-97fb-08dbcf16f52a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5101
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduce a vfio driver over virtio devices to support the
legacy interface functionality for VFs.

Background, from the virtio spec [1].
--------------------------------------------------------------------
In some systems, there is a need to support a virtio legacy driver with
a device that does not directly support the legacy interface. In such
scenarios, a group owner device can provide the legacy interface
functionality for the group member devices. The driver of the owner
device can then access the legacy interface of a member device on behalf
of the legacy member device driver.

For example, with the SR-IOV group type, group members (VFs) can not
present the legacy interface in an I/O BAR in BAR0 as expected by the
legacy pci driver. If the legacy driver is running inside a virtual
machine, the hypervisor executing the virtual machine can present a
virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
legacy driver accesses to this I/O BAR and forwards them to the group
owner device (PF) using group administration commands.
--------------------------------------------------------------------

The first 6 patches are in the virtio area and handle the below:
- Fix common config map for modern device as was reported by Michael Tsirkin.
- Introduce the admin virtqueue infrastcture.
- Expose the layout of the commands that should be used for
  supporting the legacy access.
- Expose APIs to enable upper layers as of vfio, net, etc
  to execute admin commands.

The above follows the virtio spec that was lastly accepted in that area
[1].

The last 3 patches are in the vfio area and handle the below:
- Expose some APIs from vfio/pci to be used by the vfio/virtio driver.
- Introduce a vfio driver over virtio devices to support the legacy
  interface functionality for VFs. 

The series was tested successfully over virtio-net VFs in the host,
while running in the guest both modern and legacy drivers.

[1]
https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c

Changes from V0: https://www.spinics.net/lists/linux-virtualization/msg63802.html

Virtio:
- Fix the common config map size issue that was reported by Michael
  Tsirkin.
- Do not use vp_dev->vqs[] array upon vp_del_vqs() as was asked by
  Michael, instead skip the AQ specifically.
- Move admin vq implementation into virtio_pci_modern.c as was asked by
  Michael.
- Rename structure virtio_avq to virtio_pci_admin_vq and some extra
  corresponding renames.
- Remove exported symbols virtio_pci_vf_get_pf_dev(),
  virtio_admin_cmd_exec() as now callers are local to the module.
- Handle inflight commands as part of the device reset flow.
- Introduce APIs per admin command in virtio-pci as was asked by Michael.

Vfio:
- Change to use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL for
  vfio_pci_core_setup_barmap() and vfio_pci_iowrite#xxx() as pointed by
  Alex.
- Drop the intermediate patch which prepares the commands and calls the
  generic virtio admin command API (i.e. virtio_admin_cmd_exec()).
- Instead, call directly to the new APIs per admin command that are
  exported from Virtio - based on Michael's request.
- Enable only virtio-net as part of the pci_device_id table to enforce
  upon binding only what is supported as suggested by Alex.
- Add support for byte-wise access (read/write) over the device config
  region as was asked by Alex.
- Consider whether MSIX is practically enabled/disabled to choose the
  right opcode upon issuing read/write admin command, as mentioned
  by Michael.
- Move to use VIRTIO_PCI_CONFIG_OFF instead of adding some new defines
  as was suggested by Michael.
- Set the '.close_device' op to vfio_pci_core_close_device() as was
  pointed by Alex.
- Adapt to Vfio multi-line comment style in a few places.
- Add virtualization@lists.linux-foundation.org in the MAINTAINERS file
  to be CCed for the new driver as was suggested by Jason.

Yishai

Feng Liu (5):
  virtio-pci: Fix common config map for modern device
  virtio: Define feature bit for administration virtqueue
  virtio-pci: Introduce admin virtqueue
  virtio-pci: Introduce admin command sending function
  virtio-pci: Introduce admin commands

Yishai Hadas (4):
  virtio-pci: Introduce APIs to execute legacy IO admin commands
  vfio/pci: Expose vfio_pci_core_setup_barmap()
  vfio/pci: Expose vfio_pci_iowrite/read##size()
  vfio/virtio: Introduce a vfio driver over virtio devices

 MAINTAINERS                            |   7 +
 drivers/vfio/pci/Kconfig               |   2 +
 drivers/vfio/pci/Makefile              |   2 +
 drivers/vfio/pci/vfio_pci_core.c       |  25 ++
 drivers/vfio/pci/vfio_pci_rdwr.c       |  38 +-
 drivers/vfio/pci/virtio/Kconfig        |  15 +
 drivers/vfio/pci/virtio/Makefile       |   4 +
 drivers/vfio/pci/virtio/main.c         | 577 +++++++++++++++++++++++++
 drivers/virtio/virtio.c                |  37 +-
 drivers/virtio/virtio_pci_common.c     |  14 +
 drivers/virtio/virtio_pci_common.h     |  20 +-
 drivers/virtio/virtio_pci_modern.c     | 441 ++++++++++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c |  24 +-
 include/linux/vfio_pci_core.h          |  20 +
 include/linux/virtio.h                 |   8 +
 include/linux/virtio_config.h          |   4 +
 include/linux/virtio_pci_admin.h       |  18 +
 include/linux/virtio_pci_modern.h      |   5 +
 include/uapi/linux/virtio_config.h     |   8 +-
 include/uapi/linux/virtio_pci.h        |  66 +++
 20 files changed, 1295 insertions(+), 40 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 include/linux/virtio_pci_admin.h

-- 
2.27.0

