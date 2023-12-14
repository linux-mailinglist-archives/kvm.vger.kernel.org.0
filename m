Return-Path: <kvm+bounces-4479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D32E81304A
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:39:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C9BE1C219F1
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125E64C3CB;
	Thu, 14 Dec 2023 12:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n7/R4L5d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E118F113
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:38:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCjXtekgCac0nZUzqdkRBbBt/lF/qgZAMck5+DHh5r8ISnFqlX4B6DlWd9ZeZhm8qXYpc9uD/EkOYCYpwTr5HaCFrTbp7sRUB8PAw5padGOrWrAqLq0lMQix320eEWBr+OrDymubl9oqudLy3KXX/Kb7WMRDZrShzaq41VvZ00gYMPnoBVD1YvQAgJ3I69hU0OzhgfXQ8C7Biu0aibhgZaWeptOAWefg+YrRaM+NjKvWv/XNEA5sed/2/uYn6TioITMSBigoCy8aTUwBpnTfVYe7Brf1UCXIj5dpx8tUXplvMwFEWAD5lD6oxzd78+Uynhp1ktSw8zm53xqpVaFXXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6+BLl3KtUVnhLiml9BnswZ4IAjiBuooibaEmrQzB6U=;
 b=kkbuHUwSEyoJbz0YnWBq60evn6ULvje2Gujf8YvNL4cLqIunMlL9wsYzsNQ/aEfTBpFC7OxNsJrq8adXH6V51NDLnftjDNmWXUgVIXFe4Ettpl374qgIfyIV3/t4TQYAkkpUyKAmjxahYYO38bKU4xhpqwkh7UcMi+xmo8W5bkO7+0dJ3coaFpfAyqaXXkXtl9TNVQBpb+GDzGvwe2O/zJOGmrJnrxF0sicH4bemj/rQqqpMyUSXNWyfU4brHMXoQusyMKe3wSAs97bIxbtY6gTEZGPO/gTh8RYqmRQyMjHUQH+jAgTOn09iD/FLN3PCtd3+1QzLNL7QROtsbM6E1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6+BLl3KtUVnhLiml9BnswZ4IAjiBuooibaEmrQzB6U=;
 b=n7/R4L5deTuuzfN28DJ2jRWagJmh5H2sPZuOktmXvbMXsEj+udGIcTQu64oZfN4P472sPwf2zCvs7Z9elyaLM6rsRWps8OBzoYot8FrLmKUd/UvqahyYvHSsSJwnw7ljUvj+G+427h2W2ORsS0qm1pb2E+Ofp7JA27YGdQ4HnoSl4dG9878PPDmuJJp72F5IXunfS5kuD/qA77sDR3ys14MAOTMSIVnVAsj7ySbBCGC3aaK+WwJeaN5O8fXZ+Wt798X9t61Pgf5yFNd4DvEh3Al86Iqr98KVT40ydKYbxMraR8YjxXzcfcZY58dQiMO/GuKbkeGEQ+FwvOouKc5Xkw==
Received: from BY5PR20CA0036.namprd20.prod.outlook.com (2603:10b6:a03:1f4::49)
 by DM4PR12MB6134.namprd12.prod.outlook.com (2603:10b6:8:ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 12:38:52 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::ae) by BY5PR20CA0036.outlook.office365.com
 (2603:10b6:a03:1f4::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Thu, 14 Dec 2023 12:38:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 12:38:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:30 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 14 Dec
 2023 04:38:26 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V8 vfio 0/9] Introduce a vfio driver over virtio devices
Date: Thu, 14 Dec 2023 14:37:59 +0200
Message-ID: <20231214123808.76664-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|DM4PR12MB6134:EE_
X-MS-Office365-Filtering-Correlation-Id: ce0ba285-9db5-4ab8-d114-08dbfca1a071
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fB0OEn6viCErCNIXANvjc55ccsDxlSw9wOJVipTUr5j9PMCYLaml2rYHIjYskZ+I06wINGbtHUfLcUcpCoEfG5oz3pGf2VAssxqjsA/Ro5+oR6lvDX5i5tWlcW/EJU40yUM0UGyom8CvjLxkIYpyAaOF9kwHlikeGpgNRkYJw/am0U+ehBwwCl3hjlxnk2O33sLHV7DayEFEmzECYH1IeLe3hyVNJUUL8DP4rzcAah14grJSGKNgKkP6ClZ8Y4r9poUnv1Kl1QsWcc/nkhkj8ZUqkuCCun9JhlW6Y/pAgjj6qDybGKSvrZl06y757t1+y2lsyxREdw1YIIlwcZcj8yjtYVc7PWyC0t0MSosrtwcMLV2yNAmBzq+TTKwWrUJuqFhIqqyUg6mvFE9miCSrVnSo01IzGnx8fmBXsVPkwWXtZMBkULZ0vxPGAeRRKAMB/c0FsPjePY7Qx+++2bjfH0we9lNqyyfiuQBwtLDPBRAOvci8FubNuNUjgIcsPJgIiRL7ZHTnj2zv76WWGyQJ8eHg87LSc14fZvMs66X+lcrQlHck4TYgCw4EUwK6EA7DMQMFht3oE+fBUdGj1ZBBoAvnTDXYdcpdNV/dac/eltjcXnP61lTZkqOpHZnfO5yMFoDd+YgSbrMwlSiBj6tEdV7yMTfweDLRMXykrPEZ+XUO/sRr5zxAxV3nFY9Ew7K7LyeWqQYd9+YT5B9WDSaAtZUVucpSPfkkm1+N81uaukh5bIiqiyaD+KvWvrc+Ps0vNNuXvvna9WE/USS2XgGbHC3eivtyREiz4FXTIljNgQID42QZ/OYz/kx3p1/AZvqs
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(346002)(136003)(230922051799003)(451199024)(82310400011)(64100799003)(186009)(1800799012)(46966006)(40470700004)(36840700001)(110136005)(54906003)(70586007)(70206006)(6636002)(316002)(8676002)(4326008)(8936002)(1076003)(336012)(83380400001)(426003)(47076005)(7696005)(966005)(6666004)(478600001)(107886003)(26005)(2616005)(5660300002)(2906002)(41300700001)(36756003)(356005)(36860700001)(7636003)(82740400003)(86362001)(40460700003)(40480700001)(21314003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 12:38:51.3398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0ba285-9db5-4ab8-d114-08dbfca1a071
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6134

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

Changes from V7: https://lore.kernel.org/kvm/20231207102820.74820-1-yishaih@nvidia.com/
Virtio:
Patch #6
- Let virtio_pci_admin_has_legacy_io() return false on non X86 systems,
  as was discussed with Michael.
Vfio:
Patch #7, #8:
- Add Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Patch #9:
- Improve the Kconfig description and the commit log, as was suggested by Kevin.
- Rename translate_io_bar_to_mem_bar() to virtiovf_pci_bar0_rw(), as
  was suggested by Kevin.
- Refactor to have virtiovf_pci_write_config() as we have
  virtiovf_pci_read_config(), as was suggested by Kevin.
- Drop a note about MSIX which doesn't give any real value, as was
  suggested by Kevin.

Changes from V6: https://lore.kernel.org/kvm/20231206083857.241946-1-yishaih@nvidia.com/
Vfio:
- Put the pm_runtime stuff into translate_io_bar_to_mem_bar() and
  organize the callers to be more success oriented, as suggested by Jason.
- Add missing 'ops' (i.e. 'detach_ioas' and 'device_feature'), as mentioned by Jason.
- Clean virtiovf_bar0_exists() to cast to bool automatically, as
  suggested by Jason.
- Add Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>.

Changes from V5: https://lore.kernel.org/kvm/20231205170623.197877-1-yishaih@nvidia.com/
Vfio:
- Rename vfio_pci_iowrite64 to vfio_pci_core_iowrite64 as was mentioned
  by Alex.

Changes from V4: https://lore.kernel.org/all/20231129143746.6153-7-yishaih@nvidia.com/T/
Virtio:
- Drop the unused macro 'VIRTIO_ADMIN_MAX_CMD_OPCODE' as was asked by
  Michael.
- Add Acked-by: Michael S. Tsirkin <mst@redhat.com>
Vfio:
- Export vfio_pci_core_setup_barmap() in place and rename
  vfio_pci_iowrite/read<xxx> to have the 'core' prefix as part of the
  functions names, as was discussed with Alex.
- Improve packing of struct virtiovf_pci_core_device, as was suggested
  by Alex.
- Upon reset, set 'pci_cmd' back to zero, in addition, if
  the user didn't set the 'PCI_COMMAND_IO' bit, return -EIO upon any
  read/write towards the IO bar, as was suggested by Alex.
- Enforce by BUILD_BUG_ON that 'bar0_virtual_buf_size' is power of 2 as
  part of virtiovf_pci_init_device() and clean the 'sizing calculation'
  code accordingly, as was suggested by Alex.

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
  vfio/pci: Expose vfio_pci_core_iowrite/read##size()
  vfio/virtio: Introduce a vfio driver over virtio devices

 MAINTAINERS                            |   7 +
 drivers/vfio/pci/Kconfig               |   2 +
 drivers/vfio/pci/Makefile              |   2 +
 drivers/vfio/pci/vfio_pci_rdwr.c       |  57 +--
 drivers/vfio/pci/virtio/Kconfig        |  15 +
 drivers/vfio/pci/virtio/Makefile       |   4 +
 drivers/vfio/pci/virtio/main.c         | 576 +++++++++++++++++++++++++
 drivers/virtio/virtio.c                |  37 +-
 drivers/virtio/virtio_pci_common.c     |  14 +
 drivers/virtio/virtio_pci_common.h     |  21 +-
 drivers/virtio/virtio_pci_modern.c     | 510 +++++++++++++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c |  24 +-
 include/linux/vfio_pci_core.h          |  20 +
 include/linux/virtio.h                 |   8 +
 include/linux/virtio_config.h          |   4 +
 include/linux/virtio_pci_admin.h       |  21 +
 include/linux/virtio_pci_modern.h      |   2 +
 include/uapi/linux/virtio_config.h     |   8 +-
 include/uapi/linux/virtio_pci.h        |  68 +++
 19 files changed, 1364 insertions(+), 36 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 include/linux/virtio_pci_admin.h

-- 
2.27.0


