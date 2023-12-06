Return-Path: <kvm+bounces-3672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05EB18069E1
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A27E3281BC1
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1611C288B0;
	Wed,  6 Dec 2023 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="igHt6pSy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75268112
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 00:39:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZwyxQlYCM0n5WDMFIQNeswjfpZAjuxWQXnzcZT4WwkWCjkxl5ZLLVmwi/E087ZAblqfXRAZLuRFkvW0voQnmmZZ/iGYpJ5vtfTD1Q61EgtNzkpbntgavz21Q+k7ULXC1vija+iUqpskSDGHQYxap4O5bWVFBTjIt5Wor7Dw0xlhh+NNK4csk2FHUL9vqzwfDIgrORe5CuZtXdF/7tJrJhdfzSKFUW95cjiD0itFyv+idJq8GYr46CvKJ8EQd2atBmU/1Gl0diOcFwYDL7+SIQVMEZjSmmpmLiw4L8eXcfV4LeqPZcMzoZzeG/qvrJA8OIZpAAJCkxDbJdMBFmhrsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCzfZY0Z5ymK3T02h7blHoqcqS3UJ+rAIPWLwV33Ato=;
 b=PcSyL8Tw2xbI97kbNd9zSHB+sUpf4Rrhcap5mXVhiokVka9gSgPsC9uRvwY9tzOPXxllmFaEPGjTNaJ6oZjT/OIX/WomOGENOiJomo3HR+RoIaUnfrR+JRkoncjoQ6Vv88KiTgoRxO2pPHkRTdUaP6gxZYYuEIY+4O95VNPliFuMKzzfbmMENudYvYxSMNziqwwV2e1eQKRuss6x8csZwo2qh2U8YS9yqsn3nBXOMTVQPASZw1BjRTgKyNsv/W44FfBx14rofHkHBDA+Ll0tyKNloKqaWH5xKoW7CrBRpL885sYidYAIGXwjAck5gJJzrH0L+hGkEUTskcZffgXeOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCzfZY0Z5ymK3T02h7blHoqcqS3UJ+rAIPWLwV33Ato=;
 b=igHt6pSyrF6YtU6vyKsKC5OS1qe1k1XRECZZe9AFJWPaQnW/RoL2otsXgw7MdksmeAieFqOXMK6mWFADX6GjW1rQJkmgacTCR00XZCOvh98FbI6oY2eaCzfeQKOk5mOdwP1NwM+yxiF+eoBDDd2pS1Dlq0nPusroYlR1Mg78QiS/GAyrttq8oqE153tqNueBroX78dkDJV4/bMIuCF4qYzCZgDZBCogaZXXKcnmo+Ze02L115V0JksyvUTx6SBWNEAg63c9sivwGiJHxh/wxXZuX9Og6Mrg0ps4qCk18DDNCIXpOC+E9UDr51T7DvjNjv3n+i9c20CIrigcyG2E7Uw==
Received: from SA9PR11CA0008.namprd11.prod.outlook.com (2603:10b6:806:6e::13)
 by IA1PR12MB6458.namprd12.prod.outlook.com (2603:10b6:208:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 08:39:55 +0000
Received: from SN1PEPF0002BA51.namprd03.prod.outlook.com
 (2603:10b6:806:6e:cafe::9e) by SA9PR11CA0008.outlook.office365.com
 (2603:10b6:806:6e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 08:39:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA51.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 08:39:55 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:38 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:38 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Wed, 6 Dec
 2023 00:39:34 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 vfio 0/9] Introduce a vfio driver over virtio devices
Date: Wed, 6 Dec 2023 10:38:48 +0200
Message-ID: <20231206083857.241946-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA51:EE_|IA1PR12MB6458:EE_
X-MS-Office365-Filtering-Correlation-Id: 14e85f60-a920-44cf-38c7-08dbf636ec1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QHHNgRUsZCrAMJq6RMFRcOhTW9zFAy350JucDZcPPR6u0PfKVSsGNKikP9vAxkwic/+JpWmlcUCDx7yRvckB4Rqoy5w7dETwi4Ivbo/Phq+b5BdrTyqmacDXLDCmpkKzI/o+4gABvNPhx2nOmPEuWI3F36RJbwDn2Xyo6GVFBl1J9KZnKyAP8dfKn6LpUr+zcRz4AZD7PLdmjGRP6HjprCcTQFJgQMUUUx/j3PUELChs7Hy+rtNgJmlXQZjuS1rjxqnF0DGKVL4aljuLUxI6a0mccDwWINX5vZKKL22QNTx67EWktxMfU8Qee37PPZ2/LxyWFnh/Sjk3JoK6tF1ZSwrmiooQZld2HXSeyzU/V8/LixdmxO616ZWOtPvs4kjuLfesc/LCZg1IGoEzGi4IhAvTssQU0nrg/2ZLoFHtY5gARZnALMScTE2IL6ljFvZsHLVzSM6QO1QmL5okXJHYQnvUMLeJyYa4m5akzFi2zrKJL1RfZoEv+fEw9OtPJy1uFKnw5BpRjvFjILOflnXwCXN9M/CONv1AosKzy2Ky6DKRJsetpt7aXNqU9dM3K97wyIZHXeWzmeoGjRBoMXnXPDkFeUwL1xu+tGSsdlZnBHbiiHm5o18cWfkPDqPi8LrfRNW/UYMsLqsVpqaH2JVjnEmdiBfaG61VeSPBdRfSQ+i7M8F0eclqbB+wXRD0cw0UWFAskqpN2/msDu43+1E5TIcllX28KTFjivA+g9WT2M23Oux9eCfgPbogcuCNF0DyZL5Siqddo/A3laNUqGchlWciutQthkEmKdwySO2a0u7QjSu0D7cZlRtGtRXnlFQfF5xZMSSX3WA01aSYq0wuWXcKykYuPH8nlvclqOkke6M=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(136003)(376002)(230922051799003)(1800799012)(186009)(82310400011)(451199024)(64100799003)(36840700001)(40470700004)(46966006)(36860700001)(7696005)(40480700001)(966005)(6666004)(478600001)(110136005)(54906003)(6636002)(7636003)(70586007)(70206006)(356005)(316002)(26005)(2616005)(107886003)(1076003)(47076005)(83380400001)(4326008)(8676002)(8936002)(426003)(336012)(82740400003)(5660300002)(2906002)(40460700003)(41300700001)(86362001)(36756003)(21314003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 08:39:55.1721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e85f60-a920-44cf-38c7-08dbf636ec1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA51.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6458

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
 drivers/vfio/pci/virtio/Kconfig        |  16 +
 drivers/vfio/pci/virtio/Makefile       |   4 +
 drivers/vfio/pci/virtio/main.c         | 569 +++++++++++++++++++++++++
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
 include/uapi/linux/virtio_pci.h        |  68 +++
 19 files changed, 1351 insertions(+), 36 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 include/linux/virtio_pci_admin.h

-- 
2.27.0


