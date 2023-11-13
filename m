Return-Path: <kvm+bounces-1570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5F857E9733
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDA531C208A8
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61C615AD6;
	Mon, 13 Nov 2023 08:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DQHyICsE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ECA156C7
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:03:10 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2080.outbound.protection.outlook.com [40.107.96.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2074710F1
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:03:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLnw2xK6EJTvfhD4A7mOjwWhDzGUk0UudchYEUsXSwFhCiCJoAmvgJk45zkL/NO1d32z6HhrfVOcMRXe5RCt0+CIzKWfxvQCMPdWJp48ZIYW1W54FNq4ltn1uRBHxnoAnhAb14+BnYCZjAfbDv6GARNprVn9bdoLJiFQzFRwUct1gSdMVXfaMBMdvqp7qVN+78G3vUYYJ76nR6sIWT13Nu4L6dG6Qou95tCzlARmSZ7kVDb9iQNPE9zRNjQQ8TaXc5srdllINDpCVq99VDMFAiqhcx4dUqA4o+PdoPjr9Va1kjP54ZWN0m1moGk91jIAftocTLnetkDC1S/s+BgupQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XDeY+sUlhgz0Fp+g8zRPNhMEL0yhpp8CGqPgwRnV3w=;
 b=DRCnv+1zu/nci4vB2E7u0Fx9EAWuBDtM6WzxcVMc0ht1B6rxyjWDYIrDn46BBjh0dYg4S9Q64LYN0M1EksaZuqxFWwNPh9AwZtxcJGWMDi+2U3fGkwEsJdeyTBHHMK3c8XMP5IAOk0qrEtlle+plGiDe+WeyJ3A8m9Nx+ALZN7HEFH73H9CQoju9S2lpj0t4qnfZJKFy0P92oKxKHll716CpAKeyNYVuyTx3gRUUhrcc24dlKd6v/p8T4tAtjxDIVyZkUTpO6G3UMBClhY7xf2xnEJ03yIc32rblnkPxHwncqa76h+OJrxryzC8QdLCksiFzW4ODnxAHG0nWuhGsqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XDeY+sUlhgz0Fp+g8zRPNhMEL0yhpp8CGqPgwRnV3w=;
 b=DQHyICsEjD1C29+qnLNahQmDzJAGDsvKLplbasOIWgyr1U8gFHxXny0k0LwLx/bqczluGDnAqQXWQWRymWReBHmwO3TI08iC9twcKTIXp7RzRlvzrbLXtS5OrJ0cohVfbgeZJPs5IH3Q0aA7FGXBanjmVZUxkOYMhbJfSjDGQSR6ATUvzzJZ9O+F80FYiPMpsVyzrBh5obMO1/GLtmHN2M+fOidC8yat4tG3PI/jktXavrYav8OZ2RVQzCGfhuvn9xvZgw6FdKn7aD5tBf1hf0uj9uBzy/xYEuPj5f+DZtUN8YZciv8HTN/JmBgbfK8tsbcDd4Brt4F3DARAtfmLLQ==
Received: from SA0PR11CA0131.namprd11.prod.outlook.com (2603:10b6:806:131::16)
 by BN9PR12MB5340.namprd12.prod.outlook.com (2603:10b6:408:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Mon, 13 Nov
 2023 08:03:05 +0000
Received: from SA2PEPF000015C7.namprd03.prod.outlook.com
 (2603:10b6:806:131:cafe::e2) by SA0PR11CA0131.outlook.office365.com
 (2603:10b6:806:131::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29 via Frontend
 Transport; Mon, 13 Nov 2023 08:03:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF000015C7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.13 via Frontend Transport; Mon, 13 Nov 2023 08:03:04 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 13 Nov
 2023 00:02:55 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 13 Nov 2023 00:02:54 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Mon, 13 Nov 2023 00:02:51 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 vfio 0/9] Introduce a vfio driver over virtio devices
Date: Mon, 13 Nov 2023 10:02:13 +0200
Message-ID: <20231113080222.91795-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C7:EE_|BN9PR12MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: a058dc56-19a1-43c5-0383-08dbe41ef71d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UaCDINB+qDVqtRABKWg1dyiSp4R0wIIH19zo0VyHdjwpz3xnSfCLYg6O8a1spmKCnShqkRtvlXq1Vl5JpTqBRrlpWjb5b2xjJGxqHYZbuyeRaIfQfGGOKpDYNaA4I5qP3V0mPdLQanMcDnJqYoVBeZs26l7hFmJnqhn/a9yCAmoH0U2GWsq5Bjnf+FD1QTc1tI06wRGD8A7kGEUVulbxkUnHvqisMD48D+K1gqRxnZvwFbGBZ6vEcZpRgC15dGj6BgIPQ/wBeXJN3dStUyOkgUdAqLZ9zVfTERs1O1gwM+RVF8Otl11ThddmiuuI84Ia+MjgYKiDoYKhJesGWb9qKc9j9JTOCYZPOoUCr40WNwrdj6zONpOYBSUAtQ5x5FuZaTggsiwFxxIdZkOeCmEQkPySkhBmivL23HdH+w76qt42E0u/Aqn0cf5b4JR/DTX8zIpt+OZh4tu4JT+3FPsxmOf/N3yyKOoEqEhmEMphltafAOS0rDgFNmJKc2vfl/si5UfkTlF7KCNm7NG28ZG/1JHgyl3u7pUcd5y6wORpODCZd3R+9zypxkcPbt+PyT4IRDiH0A5qvnNjkOPBWo4WGtqZrdM4SA0YSGLzaLKQfm8OAKqx057z02Z0jn/QLcozusMs2143OJAU6wa0JTTvsVsnhejiv2eCHYrucXl197V4DDRVOszotS1OgS00w4KKe45+QzWw5nd8cWclEeqMP0m6oMuGjT6kJaXghpozWnivHjUEZMWOwvFERbUWIMtuvhP1zh1gzjYPd43h3d5PXOmmc8OxnjNJS1Z/skXya7xuqo3PgA36ws7Nl0BDYBEi2P/cFFz41lqcoYxTCWKRMzCZwoH1/8yD7G+Cyo2ZeAg=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(64100799003)(82310400011)(451199024)(1800799009)(186009)(36840700001)(40470700004)(46966006)(316002)(54906003)(6636002)(70586007)(70206006)(83380400001)(82740400003)(110136005)(6666004)(8676002)(40480700001)(8936002)(4326008)(478600001)(36756003)(966005)(356005)(7636003)(7696005)(40460700003)(5660300002)(86362001)(2616005)(107886003)(1076003)(36860700001)(2906002)(47076005)(26005)(336012)(426003)(41300700001)(21314003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:03:04.7676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a058dc56-19a1-43c5-0383-08dbe41ef71d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5340

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
 drivers/virtio/virtio_pci_modern_dev.c |  22 +
 include/linux/vfio_pci_core.h          |  20 +
 include/linux/virtio.h                 |   8 +
 include/linux/virtio_config.h          |   4 +
 include/linux/virtio_pci_admin.h       |  21 +
 include/linux/virtio_pci_modern.h      |   5 +
 include/uapi/linux/virtio_config.h     |   8 +-
 include/uapi/linux/virtio_pci.h        |  68 +++
 20 files changed, 1341 insertions(+), 38 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c
 create mode 100644 include/linux/virtio_pci_admin.h

-- 
2.27.0


