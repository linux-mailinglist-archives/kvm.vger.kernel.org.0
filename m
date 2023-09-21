Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454707A9651
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjIURDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjIURC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:02:56 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448381AB
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:02:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYs0yTXa4QecrIUpmynTA0Mp14ch7v9r9W9OdBOBtPt+oI7NA9YNVZ94p1d0V+WICJLC9FXZEIKB9ngnExhCQ2mbzrUn6bCh/g/nTEd7gZNjfbnAN3ewb37X9mAsgU0KGT91PM9+yAp0WTs+jJOxPiEe2z4gBspzRhWTAtlCf5H2pN/YSohF6c3rbmwSt1RlZMopoYF6R+9dLmOT958A7Zs7Nuky62X7HjZeh7t5BbyV4I0134LtVZfpvIreC/1zgQxD++HCh5KpNaA7w8U/572okNAPjAayX11P25RUfvVeWcwATY7H2MeV3rTiZjfHAToj86CrAZBpIfrrtuulcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59dubuvXeUjoPSNQfRdS6u3kbhXNaC7z1kNHFViP++U=;
 b=WIRrP5mWap1bzEY9hG8xdF5W/4TBCVGShB35IZ0K5OvjCin05uc3kOZm21FYefPycY9hwAf2xR+qI+PBlKa3CMxWg5Nj3QXZE3JcKp3VmyTdceO+EbBnI1mq6KSO9Iyv+To5FaBRgHrTAfp0Ij3unKBGIFDkIIUWkupEHj5PcD3tlkDwT0szEO0rGFCMPLcqmsEIntdM6mOEonVYTLUouGuSJG6/JDgvKahKQTv+Gr3nqSfYbO2adNBlEu5mJ794qa53kqLOtFeAGeY9DiRXKq5q/u2KUJVm0XFYOmuF7xYBL3xYVPanFGqhg9t75kZJd/kXBgUD6zRa5dP5oXp8NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59dubuvXeUjoPSNQfRdS6u3kbhXNaC7z1kNHFViP++U=;
 b=Ml6gCNyyWTha1jTtzX6Tf1M9lu5wKTOib7lVwfsapF++yL3pYjznG0+fGAkDD0DHIKeqI9XIuZgIYH3ks2ckEc2YfW9bXtYuIZu2zIuryeb04YlrXbwELBT2+Ic/cB9qSdxQuKZ1EDB2m6s/AWBDYWRVpPxvDhmqEmN2mHDQ3lyxEoXqUH4iQirKbpm4ezTrcH6pNoY/SPbpwPIkbmVotkPu7w0SXItZ4qbZ273jakRzjcDq/dvQYF04A0aI73pEmQdl8yDwvToBYYmCD7W/MZ226GxSx1ah1icbtBsLOs3OmKhAh61t5wmcxqR3G4/qFCRmTkgk1Uzd8PFhYXzZhg==
Received: from DM6PR06CA0050.namprd06.prod.outlook.com (2603:10b6:5:54::27) by
 SA3PR12MB8048.namprd12.prod.outlook.com (2603:10b6:806:31e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.21; Thu, 21 Sep 2023 12:41:31 +0000
Received: from DS1PEPF00017094.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::c2) by DM6PR06CA0050.outlook.office365.com
 (2603:10b6:5:54::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.31 via Frontend
 Transport; Thu, 21 Sep 2023 12:41:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017094.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Thu, 21 Sep 2023 12:41:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:23 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:23 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 21 Sep
 2023 05:41:19 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 00/11] Introduce a vfio driver over virtio devices
Date:   Thu, 21 Sep 2023 15:40:29 +0300
Message-ID: <20230921124040.145386-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017094:EE_|SA3PR12MB8048:EE_
X-MS-Office365-Filtering-Correlation-Id: efed2546-13e1-45e0-8f81-08dbbaa014fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z5bfFNSDLWJ0Ap5DRoiFMmGLou+PHWWZ0yc8Y18fb28mkVZuUaVfJOaCEY2Q7F29DCQ2WrOAmbV29WqwaVurY1nxdrv/xMcTwXPkbX/09PXEhVQhTVIhcFW3zKsDj1j2eDf+hNcjpB6PLeB5meyb5Nsak7KQnmZXq58p8GERpWRwiRaqDKQHSmY88F7xsEaQqsJjKeJWLwlrZjh7KnB9OUkY+VSwJiVk93HqxggJHTGxHwd5aJglYXk73rveZkHZP0Opv5Ta+VCP6diPhkn2jjzLIsLfHFBYZeShf2H4sFmOICdtcfFODHBPpvAWZBWZuyQkhp5s++F5nzwX2NEHyMqcqMxMwLc9S3oDTNAFaVBwrpzUJ7NsgNYxZrL7jmjVoHijaW1SOpnlJ+7hjZ6mRNZen5bdJL+rQXr30LqWV8lzGlIXfvf/Ab2zOVku72fc1M+ydUjqzccX6LOtpYvnwoInlDUZyzOzu1a5gjSkFar2aHnb7mHvIPHsmtRXr90y6CuNqktu4mKJNK5+V/xRU1RVI/mKnbefEXYRIM0vAR5cVz5Y89BrVAXi59lbY8eWpgnTSF24VUVLY98/QM7ynVQTyZGHbYXyIUVXPrOStL8nCrENCOJzqvV3sfBM6A4fImJWa92RYrq78+hrV7zoQ8HgIFrhbQw8A1sV9sXtFYJ6/RMcznJ6YMjmmtqEwowjDlMKGJaBZYhrcTJ1zxjILWDIgi79uT32v1zfDlshYZ3C9cDFSA8C4tTQKATzOC3apafO8QmQNYisWkmRmD/PsGg4ZPqFC9EZigIO6VTpNSI=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(346002)(136003)(82310400011)(451199024)(186009)(1800799009)(40470700004)(36840700001)(46966006)(7696005)(82740400003)(356005)(7636003)(2616005)(40480700001)(86362001)(70586007)(70206006)(110136005)(6666004)(966005)(478600001)(47076005)(36860700001)(426003)(336012)(1076003)(107886003)(26005)(40460700003)(5660300002)(4326008)(54906003)(6636002)(316002)(8676002)(8936002)(41300700001)(2906002)(36756003)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 12:41:31.1215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efed2546-13e1-45e0-8f81-08dbbaa014fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017094.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8048
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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

The first 7 patches are in the virtio area and handle the below:
- Introduce the admin virtqueue infrastcture.
- Expose APIs to enable upper layers as of vfio, net, etc 
  to execute admin commands.
- Expose the layout of the commands that should be used for
  supporting the legacy access.

The above follows the virtio spec that was lastly accepted in that area
[1].

The last 4 patches are in the vfio area and handle the below:
- Expose some APIs from vfio/pci to be used by the vfio/virtio driver.
- Expose admin commands over virtio device.
- Introduce a vfio driver over virtio devices to support the legacy
  interface functionality for VFs. 

The series was tested successfully over virtio-net VFs in the host,
while running in the guest both modern and legacy drivers.

[1]
https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c

Yishai

Feng Liu (7):
  virtio-pci: Use virtio pci device layer vq info instead of generic one
  virtio: Define feature bit for administration virtqueue
  virtio-pci: Introduce admin virtqueue
  virtio: Expose the synchronous command helper function
  virtio-pci: Introduce admin command sending function
  virtio-pci: Introduce API to get PF virtio device from VF PCI device
  virtio-pci: Introduce admin commands

Yishai Hadas (4):
  vfio/pci: Expose vfio_pci_core_setup_barmap()
  vfio/pci: Expose vfio_pci_iowrite/read##size()
  vfio/virtio: Expose admin commands over virtio device
  vfio/virtio: Introduce a vfio driver over virtio devices

 MAINTAINERS                            |   6 +
 drivers/net/virtio_net.c               |  21 +-
 drivers/vfio/pci/Kconfig               |   2 +
 drivers/vfio/pci/Makefile              |   2 +
 drivers/vfio/pci/vfio_pci_core.c       |  25 ++
 drivers/vfio/pci/vfio_pci_rdwr.c       |  38 +-
 drivers/vfio/pci/virtio/Kconfig        |  15 +
 drivers/vfio/pci/virtio/Makefile       |   4 +
 drivers/vfio/pci/virtio/cmd.c          | 146 +++++++
 drivers/vfio/pci/virtio/cmd.h          |  35 ++
 drivers/vfio/pci/virtio/main.c         | 546 +++++++++++++++++++++++++
 drivers/virtio/Makefile                |   2 +-
 drivers/virtio/virtio.c                |  44 +-
 drivers/virtio/virtio_pci_common.c     |  24 +-
 drivers/virtio/virtio_pci_common.h     |  17 +-
 drivers/virtio/virtio_pci_modern.c     |  12 +-
 drivers/virtio/virtio_pci_modern_avq.c | 138 +++++++
 drivers/virtio/virtio_ring.c           |  27 ++
 include/linux/vfio_pci_core.h          |  20 +
 include/linux/virtio.h                 |  19 +
 include/linux/virtio_config.h          |   7 +
 include/linux/virtio_pci_modern.h      |   3 +
 include/uapi/linux/virtio_config.h     |   8 +-
 include/uapi/linux/virtio_pci.h        |  66 +++
 24 files changed, 1171 insertions(+), 56 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/cmd.c
 create mode 100644 drivers/vfio/pci/virtio/cmd.h
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 drivers/virtio/virtio_pci_modern_avq.c

-- 
2.27.0

