Return-Path: <kvm+bounces-18-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C22E97DAD13
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 17:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09FA1B20DFA
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 16:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B079D2E4;
	Sun, 29 Oct 2023 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PE1FP5HY"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486FBB67F
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 16:00:29 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ADCB6
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFlYmOJO7fzuBWirzwW67hofmZYJPwlzf2mD9XFiPWRGAcrl9qDIYGeV0hO87j+o4BBdn8ggvk0DrgJUIVhTFgj1vEFeQ4V3iPHqiaM56vl3Sx99AhrVPZM/DHFfAFdyJLpYCms6HXnmdb5UWAZp9gC5rkxUBHkfH4w5vfXNdH7vc3Feb2fwPCCp2YvzB34h9DNExISGDcZDUMZSi1MJOUbdzwEkIVlQ/r6Lr/z2dOCxmszsyeuCrnr0D5NnDCP9ACABeLvFOXd7S7nsGL0u0c38K5+NJsuxOlju2vORBq4JDSIrfMsYHPo6ZhZJGsZkjcLTYSVW45DHcGXC9tVmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcO6ft9jQAP93NF3EdXq81HefgdHhsfOywEZ8Fb4E1I=;
 b=ESwlqgDeOs3l2hS+1DL/PdkmZTlwg9tnudMYMSSxoKakFalxtBSjykW+qR5hRHAAZCH5+gdIBPEXHGa3nyNvZ3RqP/I/HWg1+FsPHSR6Fx4MoOX4a66TwN6eEpIQfMNND9b4m+mu7gg/GcwxR7xA5ITc1ICQ0+QSmseSunF/OiSIVsWfPoaowScZXbAIA3VFgEtNBRof5EsM0ltoxlD9zRuUzLofpjLOZmDwqc6we/u7C4amVK//7nSiJS1D00t+GMwczLOn2c8YG3Wd3fD1OQyFAyJqXzqArib+v2OBbm6s+umLWtBkiuFmdP41gUi9GYJsoBmn7Bqd8wMD4pR2MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcO6ft9jQAP93NF3EdXq81HefgdHhsfOywEZ8Fb4E1I=;
 b=PE1FP5HYo6cLayC63QXSj//7/ybGqEqutJlMLYBog7182Icj0yQRyY8xw5NxJG3KYRk3gCWIFLkjrfCcEL5xCSvW08+F2nnftaEZp0byZg8k5yggGNLtBFCrAyF6B7KG7iQyT4xpMFLIsmwvJsQP84XvrcUPv/NMzNwJePUugC/kLATTo1/Ya7cFJhHMbe09ueUI87mJ9YcTJM9MiW4l5zclZRe1IyNtcG9cluKDCnDwrQ1FfN7mIf1maN9D7eBYGiO3lM3+havSgZFVI8eMspeh2xKKDrhyjbdeRmxE+x1K6rd1YCdq6Br+wmE7bHZTJR2OXByRBGAiv7QWkbMurg==
Received: from DM6PR17CA0001.namprd17.prod.outlook.com (2603:10b6:5:1b3::14)
 by MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Sun, 29 Oct
 2023 16:00:24 +0000
Received: from DS1PEPF0001709D.namprd05.prod.outlook.com
 (2603:10b6:5:1b3:cafe::11) by DM6PR17CA0001.outlook.office365.com
 (2603:10b6:5:1b3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26 via Frontend
 Transport; Sun, 29 Oct 2023 16:00:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF0001709D.mail.protection.outlook.com (10.167.18.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.22 via Frontend Transport; Sun, 29 Oct 2023 16:00:23 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 29 Oct
 2023 09:00:13 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Sun, 29 Oct 2023 09:00:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Sun, 29 Oct 2023 09:00:09 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 vfio 0/9] Introduce a vfio driver over virtio devices
Date: Sun, 29 Oct 2023 17:59:43 +0200
Message-ID: <20231029155952.67686-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709D:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: b27db548-8c49-4ec6-593f-08dbd89828f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k8Vn/1PaEu5fkeGY8nFDOhdWFAlqk+emqyQUyvv9DUOs7IDYGyx9R6leqxfKfrZOdG1tWsU0mHeuivoAw532DwJfSJ8/ryOIQ77QdfCDT3HLA6vNjcpHnbNQ+rBarKAQ+toGhijAxd8YYsvmyr/mhsSzmqcER0obAdJ1dFAxEyC4uVXqGoNo7HFe54C8lxC77ef0cjakboXP9KILhVquuKwc+++1khMjxakTCBlEyIH3VWkpqy3Yc02donIhurc8Hk+BbfS99SguarD/4EBBiPjEIUzx512xJD0vpdTdFrMoHInh2iYJpATZlYV8fCPZ1I5he7jFC813R1OBo9+4+TdgJOdRVM0CO5ClHX2Qn6KgNwyz5oWqrUNVzWZUKMy+er/WAtsuq7Uolb8grRHO1MS2LRddnSVtOT//RKvbxS1sEHjBvwbrXKUJC7vQXbAlaVWcLfkYaYrsbHP41XpyX4kdcbnUvYGd3xCTYc3cWkPnrSFLROGQDfjwhOfDhMpGupwTTefryB1jFGk8gp712WjCAL3FWXRN+Nx+LvzagPvTKtOipG2lBopDTinFdrL1hl7/q1jNPQ4Z73D2tYHDo64Pk/UYovjDZNHComj3UzQChk8Ew9c1AgzYtX1xG+JFno1uxv9ZK2j32ZBngxlnuqymOYi4ai196O/5Hx8eAMjDA7+l0IXvn67i/p/AGG/16HMaH2wXiycyyFeSRZhFgwBurAGOMPV7IpGwmWsgLOEwM8oGQqfDpZLo+vLDEra/hTCC7sIuct1cM8cC1FPfjI1E1an58EqkarCH9a25KZRErwHnHRdsPWMOnDsi6OtpU5RspPuVmwvI7cArmNhZgBDHl7ROsQcmpCASY4WPJp0=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(346002)(376002)(230922051799003)(1800799009)(82310400011)(186009)(64100799003)(451199024)(46966006)(40470700004)(36840700001)(40460700003)(336012)(1076003)(2906002)(8936002)(36860700001)(966005)(4326008)(70586007)(6666004)(7696005)(426003)(83380400001)(2616005)(107886003)(41300700001)(478600001)(47076005)(26005)(8676002)(5660300002)(110136005)(316002)(6636002)(7636003)(70206006)(356005)(86362001)(82740400003)(54906003)(36756003)(40480700001)(21314003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2023 16:00:23.5709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b27db548-8c49-4ec6-593f-08dbd89828f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238

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

Changes from V1: https://lore.kernel.org/all/20231023104548.07b3aa19.alex.williamson@redhat.com/T/
Virtio:
- Drop its first patch, it was accepted upstream already.
- Add a new patch (#6) which initializes the supported admin commands
  upon admin queue activation as was suggested by Michael.
- Split the legacy_io_read/write commands per common/device
  configuration as was asked by Michael.
- Don't expose any more the list query/used APIs outside of virtio.
- Instead, expose an API to check whether the legacy io functionality is
  supported as was suggested by Michael.
- Fix some Krobot's note by adding the missing include file.

Vfio:
- Refer specifically to virtio-net as part of the driver/module description
  as Alex asked.
- Change to check MSIX enablement based on the irq type of the given vfio
  core device. In addition, drop its capable checking from the probe flow
  as was asked by Alex.
- Adapt to use the new virtio exposed APIs and clean some code accordingly.
- Adapt to some cleaner style code in some places (if/else) as was suggested
  by Alex.
- Fix the range_intersect_range() function and adapt its usage as was
  pointed by Alex.
- Make struct virtiovf_pci_core_device better packed.
- Overwrite the subsystem vendor ID to be 0x1af4 as was discussed in
  the ML.
- Add support for the 'bar sizing negotiation' as was asked by Alex.
- Drop the 'acc' from the 'ops' as Alex asked.

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

Feng Liu (4):
  virtio: Define feature bit for administration virtqueue
  virtio-pci: Introduce admin virtqueue
  virtio-pci: Introduce admin command sending function
  virtio-pci: Introduce admin commands

Yishai Hadas (5):
  virtio-pci: Initialize the supported admin commands
  virtio-pci: Introduce APIs to execute legacy IO admin commands
  vfio/pci: Expose vfio_pci_core_setup_barmap()
  vfio/pci: Expose vfio_pci_iowrite/read##size()
  vfio/virtio: Introduce a vfio driver over virtio devices

 MAINTAINERS                            |   7 +
 drivers/vfio/pci/Kconfig               |   2 +
 drivers/vfio/pci/Makefile              |   2 +
 drivers/vfio/pci/vfio_pci_core.c       |  25 ++
 drivers/vfio/pci/vfio_pci_rdwr.c       |  38 +-
 drivers/vfio/pci/virtio/Kconfig        |  16 +
 drivers/vfio/pci/virtio/Makefile       |   4 +
 drivers/vfio/pci/virtio/main.c         | 551 +++++++++++++++++++++++++
 drivers/virtio/virtio.c                |  37 +-
 drivers/virtio/virtio_pci_common.c     |  14 +
 drivers/virtio/virtio_pci_common.h     |  21 +-
 drivers/virtio/virtio_pci_modern.c     | 551 ++++++++++++++++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c |  18 +
 include/linux/vfio_pci_core.h          |  20 +
 include/linux/virtio.h                 |   8 +
 include/linux/virtio_config.h          |   4 +
 include/linux/virtio_pci_admin.h       |  21 +
 include/linux/virtio_pci_modern.h      |   5 +
 include/uapi/linux/virtio_config.h     |   8 +-
 include/uapi/linux/virtio_pci.h        |  66 +++
 20 files changed, 1381 insertions(+), 37 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 include/linux/virtio_pci_admin.h

-- 
2.27.0


