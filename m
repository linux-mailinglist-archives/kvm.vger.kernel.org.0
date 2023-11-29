Return-Path: <kvm+bounces-2768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B6E7FD9B0
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 515EBB21A25
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250CE328DD;
	Wed, 29 Nov 2023 14:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A0FcXIHq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A602010D4
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 06:38:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6DkwzYqRSCvwVB35wjjeG4/ygTGHOXGINYMKYu8D1olCifU6fS7KhLC/aWVvNPb7mDkiEOkGz95uPR0hBGMiLzuvt3/d3xApWCUixg/U5sTi1Ci1CCyfTriaJFftfM2/lHshzHSh52rMEEVye5wWcYcgZrNO4XH62dY2zBMluGvnCfnr7MuFkKxsmsirSxFTMiJETpagoCA9ggzjs5k9aPpTiT/CVnet4Em2M5YsnlRrNz5plbd3cQVFY5a7DdxGgMS6aws/0qaBQxkX8bv5y7V8MGsswDUPOMvzcvXY/PNpJjKLO8I5q3dK2SUWM4GWmd8GiI571YpWZUKqLbK9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGDDUewpvGz6u+FSKdBpmoUJS2sjT85v14796GetSgI=;
 b=lNmiqubAhXkMkP9UBEhFesPBTDxbCP2EyNnlL4L/+Df+ACsm+DI73R8sd4HRCMC98iNxPvgwZFybGRiBd0pp8eIunGd4p8k4MiH5hh4lZZhfBKFNLdONXmVUNrrDISx5uCKrfw543n8hhctRRuGpQY4E9htLph5+7kmYmd+IJWamNtTwMtL1IrVrQbgz3CU7OajLml+Fy6+VvXIo755cJIK2cFASYkLg4aXryYjOeF6CLB5nTwIdFQta824M2ApIc9VfXSRxAfGY8ofvECcH+kdiZeogfMYBOSXBQmE94XbHePq865Z4hpxHg/Uvlivxw24HtAPgzI1Q+37wWMdYhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGDDUewpvGz6u+FSKdBpmoUJS2sjT85v14796GetSgI=;
 b=A0FcXIHqsBVEIH7A2o32OfisIwwlXlNy/uY8vpxzDLS7Y+FC8pMcp+qT+TT8bOoCmaObwF5RQZT9+6ChPXdrEOCcZfcyMGys0zVfx5vkTHF3lYsNoWwXjMK/G8ZbstQiLh6+DVXFtOORmrUFKAalj8Be63Emy+phKTcGjIbocVhyUcZWFH1kEOGUoo0Djs64Ng0HFWIU9EkH/VsKbdIKu1ePSUO60SHuRcLpl0rEbn083yuaA32q/DbI2V9AfGVXdUlKGE6y3jcF3xdupRxiaYpXh41bbp8DjQB0vkIF0hZmhnA4d+VYfJsrjPaFIGJN0dWTki0QOPgmU8yaNSHOVg==
Received: from DS7P222CA0002.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::30) by
 SN7PR12MB7348.namprd12.prod.outlook.com (2603:10b6:806:29b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Wed, 29 Nov
 2023 14:38:36 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:8:2e:cafe::1d) by DS7P222CA0002.outlook.office365.com
 (2603:10b6:8:2e::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Wed, 29 Nov 2023 14:38:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Wed, 29 Nov 2023 14:38:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 29 Nov
 2023 06:38:27 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Wed, 29 Nov 2023 06:38:26 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Wed, 29 Nov 2023 06:38:23 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 vfio 0/9] Introduce a vfio driver over virtio devices
Date: Wed, 29 Nov 2023 16:37:37 +0200
Message-ID: <20231129143746.6153-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|SN7PR12MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: b4b2248a-5e21-425c-2c61-08dbf0e8deea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7XdjnzByN9UU/Ay7m4frQpvVQVuMep8kJHsQd9edy8V0PvX+iR+zMYIMWQO9VfLRG5a0a6dk7eH3O3Bjrm5Vell1ujO+KGUgfsYEbLSlP6e8S+zZy8D6P+vIkJO7pW6J4TAzUxqH8FJeJDeao2uUrFVKRa/2UQpsa6Th1O14+vURTYGfFr2hM0+hS/jJ6tfSSHhLX5/ZG1eW72LHtv14q9mpKvXxPTkYFtcobHAAFR6CegT/KwFdPmj0gTksECIpz9yRTNcOT4HwkJdufTnLGs6GVlBjRis9wMnNuw+kaHkdXfxC9v2MX7s4oe61EcoRBsscc1BGw9VJunuwIF8htZx18gIlz2sodu4BWzRXturtDk0on2o7qBzXNcQwbto/CX5K9pd7VNQr1MvGv7Q80wLXgedJ6gnso3OUI5ZFNUQpMAqk0kckxUeTkzJifKt57zWfL2lwEUN/Qq9kMsElx+xXLyIADjqsXGJ0E5gRCITInrKPxdkvivDvqPJ236FN2sGecnKsMSnFO4dubp9ml5To/wn2k5I83cXEwO8KWmT5+D5gKlu3uOe6Uu+EfN9aZVH3N5JnSntvFw+yt9Rk1l94WurIH+Ums/WpnrsDPCzIJQL+dk5SzaKeetRo0brhw+fd3E9D1dQhC4PJoa/asYKAmOYDHjbly7+fSg+2QSgSUuBI6sxp96b+pmbs/6mwl9rTN0OAVI1HmJZ7ak787Wsi+tMOVIsGXpyGfFMKRB81q323yUb9LXh7m/vf7n/aZJgpW9Zl/7LeZK5DR9HjkEwWTHiujLzJ6bavRbMe2bFrX2D/7buBSReA/ufJFsxgA0YkXx2bbXcn5inbEorK8vnPVrfc7PLam5DxgJUPKlM=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(82310400011)(36840700001)(40470700004)(46966006)(6666004)(4326008)(8936002)(8676002)(7696005)(110136005)(316002)(54906003)(6636002)(966005)(478600001)(40460700003)(86362001)(7636003)(47076005)(356005)(36756003)(40480700001)(41300700001)(36860700001)(1076003)(107886003)(26005)(70586007)(2906002)(2616005)(82740400003)(426003)(5660300002)(336012)(83380400001)(70206006)(21314003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:38:36.5087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b2248a-5e21-425c-2c61-08dbf0e8deea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7348

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

Changes from V3: https://www.spinics.net/lists/kvm/msg333008.html
Virtio:
- Rebase on top of 6.7 rc3.
Vfio:
- Fix a typo, drop 'acc' from 'virtiovf_acc_vfio_pci_tran_ops'.

Changes from V2: https://lore.kernel.org/all/20231029155952.67686-8-yishaih@nvidia.com/T/
Virtio:
- Rebase on top of 6.7 rc1.
- Add a mutex to serialize admin commands execution and virtqueue
  deletion, as was suggested by Michael.
- Remove the 'ref_count' usage which is not needed any more.
- Reduce the depth of the admin vq to match a single command at a given time.
- Add a supported check upon command execution and move to use a single
  flow of virtqueue_exec_admin_cmd().
- Improve the description of the exported commands to better match the
  specification and the expected usage as was asked by Michael.

Vfio:
- Upon calling to virtio_pci_admin_legacy/common_device_io_read/write()
  supply the 'offset' within the relevant configuration area, following
  the virtio exported APIs.

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
 drivers/vfio/pci/virtio/main.c         | 554 +++++++++++++++++++++++++
 drivers/virtio/virtio.c                |  37 +-
 drivers/virtio/virtio_pci_common.c     |  14 +
 drivers/virtio/virtio_pci_common.h     |  21 +-
 drivers/virtio/virtio_pci_modern.c     | 503 +++++++++++++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c |  24 +-
 include/linux/vfio_pci_core.h          |  20 +
 include/linux/virtio.h                 |   8 +
 include/linux/virtio_config.h          |   4 +
 include/linux/virtio_pci_admin.h       |  21 +
 include/linux/virtio_pci_modern.h      |   2 +
 include/uapi/linux/virtio_config.h     |   8 +-
 include/uapi/linux/virtio_pci.h        |  71 ++++
 20 files changed, 1342 insertions(+), 39 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 include/linux/virtio_pci_admin.h

-- 
2.27.0


