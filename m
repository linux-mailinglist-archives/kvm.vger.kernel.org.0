Return-Path: <kvm+bounces-31727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 235379C6E4B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:54:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9BDBB26A95
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 381E2201026;
	Wed, 13 Nov 2024 11:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HJVs5bTy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30608200CBE
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498776; cv=fail; b=htIlNhTUp658iRAIyCUUF9p5YQwe71MTAIVbCWeRvQ8sgIJzUOu8C+5p+8yiSnVo8Jm9NtO9URzVISLk4vb2MBboCxD68RD57AwlrkHETh4sfMnPqCKSQbp3IBRAMvrgEiWgbja4j/1fvPgPemDPTz5DkRVrRJ2cxXPjJS4ZNUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498776; c=relaxed/simple;
	bh=5fV/bRBNs4c0/PYg41x7+Aoq8B5oDNjssQh3RyMH5yk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dDmV33T5Ow4fubuj7qpPn5N9H1PDfuzym7rSiOKjN5JciPIAMgwcD/m872gwss+KbpbJ0mTEZQhej0UnEIlq9ntoCb8my2c6SCjmgKTk8oA2SqqLSPyvjMyix0aJMz5qS6uP7U2RCAUa0IfwVw0qiqwCn9PyH4fxIGP8uInqkjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HJVs5bTy; arc=fail smtp.client-ip=40.107.94.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yk86eM7ck2v3evo+d87VhD+U4sRMvyV5VB7WZc/Dlvvw1MNJJ45ChMc4ied37ynJML4IwmXWLx9SO21p/wwQY6MCb9jQkfawdqqgINE2RL4VnHKfICVVwLg9iqB+OZUL8JE1t86e4gPKtH6orsicnxGUiM+4w7F/MLX0HgzcdPsXDD6FwZJ2cXoLhK6oRIlYjY+d+ZhhoCoVlz/LtqywQitTdbfR6fF9pYhWGh0JCFZNeccKIyRvgwSoMHibrHxOLymSaDfHNYH0wyHJZO+QEy5H7uufnwE0nKjnJSRW7J/W2BzsBtbtu/UHM0GeHE3coDX4m0GPoW62ZJxRBbYw2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AiYEGpYM5K4PcpgkPpOT7vsIFujHdU0wJHKaPFmly8I=;
 b=ZULvLErq9n017/9LApn+C9TQg6Dua3VnKOMDy2B6nH38ACNQtqANOQlFGtkik05Ab/FK3bu/3veQxYIZZBrh5V4lYDYIVE+5ig3EaEH6rmlqjxce0qVxlVqys147kBJgOTLoxwaUDO9IyifYtGIBIdmN7Jw0nl207BiRkIxYvnFCHbUP4PUaKY9Sx27htCiMqQ60iH3x/fatcFurTsu1SFOaHEBFnmOzH9R/j5tLSVczoHvDHqqVGAc2W36QqrI0vroww/LH0J/11bs5jueiYcDAdH1YYeIV6P4FPVuePy/+sjYiN0VqUmiOUhm4q4Mz6KHVEMUchJXc1WrZbGIYhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiYEGpYM5K4PcpgkPpOT7vsIFujHdU0wJHKaPFmly8I=;
 b=HJVs5bTy/xOWpHoU9XvzNfJ0y4Z9Z8ZZCFjJRGLpXbo9w59VIrQiqSajqtMmYcLv7qyedzC3d6ZUnQImUi8JojWj+cf6Uki9xeSrAcEe7YAYuTv8DyzQK5yf4QtPoTKCB3qGI+t13dTQsxexgvEUtQZJ5knhku6Lw3JfqpmlTGr2JM9El0PUThzvX1fop9xsQozx8phOM8fLxVx0Lw9cQx5WsGhURzeswC+3BOI1CuANp9Yq2RABj9/8zKzV87WlkT6D8R5SaTD2PiQ9N9B5UtVjEW1uFZCw44krYZPchgrtgbtJGxuN/J+H29BInZQcAOQg80iEe/JHSGTdRnoTyw==
Received: from SJ0PR03CA0071.namprd03.prod.outlook.com (2603:10b6:a03:331::16)
 by DM4PR12MB5940.namprd12.prod.outlook.com (2603:10b6:8:6b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 11:52:51 +0000
Received: from SJ5PEPF00000204.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::f5) by SJ0PR03CA0071.outlook.office365.com
 (2603:10b6:a03:331::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29 via Frontend
 Transport; Wed, 13 Nov 2024 11:52:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000204.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 11:52:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:40 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:39 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Wed, 13 Nov
 2024 03:52:36 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V4 vfio 0/7] Enhance the vfio-virtio driver to support live migration
Date: Wed, 13 Nov 2024 13:51:53 +0200
Message-ID: <20241113115200.209269-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000204:EE_|DM4PR12MB5940:EE_
X-MS-Office365-Filtering-Correlation-Id: 248ffe6b-db5d-43e7-9bf5-08dd03d9b392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RrmUQMOEgtgfpNth1RKTFFrmqIR0O1Css6iQyr808suI7vk2aBfgNSqHL5CL?=
 =?us-ascii?Q?5DaS/1/6Zr2NXdiyfmzxEjVKhJv6HVD/ZzMi3sbY7mhfMN+Zcp4Nu3R9nEUm?=
 =?us-ascii?Q?VsBT31Svvge1Y/WxJxMh/WFugEhyvre3aCFQYtU23DUbNIXu1TMzDyFDE4+Y?=
 =?us-ascii?Q?ykDSHfXbMnt//7mOg9PwjKr5UKMdyKD7LuAmLGvkmIvcNn3v+YfodpD/POrb?=
 =?us-ascii?Q?5WmX7fb0/UQGOQ5uOKv1fl9CIMnTaDOBICFZ2BX/ljeriu71jKEkLVLKlWpA?=
 =?us-ascii?Q?Gup/s7hgYpEf/vOdCTzWjg+N7iAQ1Z8dxUtyigrp/zAQ0wm0dPYwFwles5Mi?=
 =?us-ascii?Q?pdhQgxiGYzcZqyBE+lCJXez3PR3y8lzyQJd4ZE0Ow14GDE6zabxYiXX29wlH?=
 =?us-ascii?Q?xpraBZGvijuSHqnCctJaaE7VudEHdQrymFqHL1Ej8uuOCtWPngjCbKgOMG9G?=
 =?us-ascii?Q?ojdj/rB+hw5CX4ceQvNmh1NrEbzqCxoqHr1ZbtG3UZnGbI5JrGzRerfBOWfs?=
 =?us-ascii?Q?Fwq675su4N3TxbdBoWF+qKx8jMmcrU1oeIiMUcp/S7V8z/KRtd33rODJsECn?=
 =?us-ascii?Q?1j8PZt78ku5oCRNOvY2H3aF3IPtCxy94H7XJ5ixOXEgEtRo8JfRPxTwJKBOh?=
 =?us-ascii?Q?F+q7fYZOW1xnzGSjiyPmiZvcYpX8215FFHQ+8yrQmOHtB9zf50Aeu2s+1wXo?=
 =?us-ascii?Q?iRlhqN+xOnQi/jQMMbKEWDgVRtOf577lmcMmdWZtH80N0lA1/eJE5pmR7spm?=
 =?us-ascii?Q?K7/IwkCXk32SN9ZLaLrn21o6OtUAIKx4pURBb84XkqOoFAfBSc0eDSfBRS65?=
 =?us-ascii?Q?VbYUYZPX0Byy4qcy4iwsU8hb5gioz6J4wb5RS8ddK2P0ZRupf8x2ah7KeXaZ?=
 =?us-ascii?Q?OCgHgyNDODCHrGfYxtA6IH9vZWw3KexiWVimqaVvUL97nDolPyWg8EkphlbB?=
 =?us-ascii?Q?xyjtHzYOArtJ36QayYJc82LQDmmcGaviXIhQqjEN7tHM8QFzDskfCoOxoBoL?=
 =?us-ascii?Q?7o6kQKXdCVRShfImjXWr85gZXpoW7zFfLT2veDE77BUKCEY69bahabMKES8B?=
 =?us-ascii?Q?A2fYhExvY81zw7n6OZNM2aq609mUV4tplHC3VktrNih4gBvRBXVv3GhwdQR4?=
 =?us-ascii?Q?RqHzP/AKlJNsFYdbRylg+wnoMp2iFgYResNW4pvfwDjD6jiF2w8Tjyq7BMv4?=
 =?us-ascii?Q?dEc05mSKXOssw6UsnYxqrUHw/c4PvQxYEJs+IeQwZrh3yzty2I1Z9Bxg56t7?=
 =?us-ascii?Q?1zVsAqN/xUFtdjDe5Ij5p7iC3Ts5u0IWRFi27E+9MSucleyv/J8XBcqtbggH?=
 =?us-ascii?Q?1UYzU18bRPODghi2RAPEiyMzaPpZFx1UqvTsuNUzkqcDES7IxC9wROYZDXl0?=
 =?us-ascii?Q?XucHrSiaCZUa6VAt2hDxB5X4H1bQBRoX1GWyRy4d13CAr23euQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 11:52:51.0744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 248ffe6b-db5d-43e7-9bf5-08dd03d9b392
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000204.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5940

This series enhances the vfio-virtio driver to support live migration
for virtio-net Virtual Functions (VFs) that are migration-capable.
 
This series follows the Virtio 1.4 specification to implement the
necessary device parts commands, enabling a device to participate in the
live migration process.

The key VFIO features implemented include: VFIO_MIGRATION_STOP_COPY,
VFIO_MIGRATION_P2P, VFIO_MIGRATION_PRE_COPY.
 
The implementation integrates with the VFIO subsystem via vfio_pci_core
and incorporates Virtio-specific logic to handle the migration process.
 
Migration functionality follows the definitions in uapi/vfio.h and uses
the Virtio VF-to-PF admin queue command channel for executing the device
parts related commands.
 
Patch Overview:
The first four patches focus on the Virtio layer and address the
following:
- Define the layout of the device parts commands required as part of the
  migration process.
- Provide APIs to enable upper layers (e.g., VFIO, net) to execute the
  related device parts commands.
 
The last three patches focus on the VFIO layer:
- Extend the vfio-virtio driver to support live migration for Virtio-net
  VFs.
- Move legacy I/O operations to a separate file, which is compiled only
  when VIRTIO_PCI_ADMIN_LEGACY is configured, ensuring that live
  migration depends solely on VIRTIO_PCI.
 
Additional Notes:
- The kernel protocol between the source and target devices includes a
  header containing metadata such as record size, tag, and flags.
  The record size allows the target to read a complete image from the
  source before passing device part data. This follows the Virtio
  specification, which mandates that partial device parts are not
  supplied. The tag and flags serve as placeholders for future extensions
  to the kernel protocol between the source and target, ensuring backward
  and forward compatibility.
 
- Both the source and target comply with the Virtio specification by
  using a device part object with a unique ID during the migration
  process. As this resource is limited to a maximum of 255, its lifecycle
  is confined to periods when live migration is active.

- According to the Virtio specification, a device has only two states:
  RUNNING and STOPPED. Consequently, certain VFIO transitions (e.g.,
  RUNNING_P2P->STOP, STOP->RUNNING_P2P) are treated as no-ops. When
  transitioning to RUNNING_P2P, the device state is set to STOP and
  remains STOPPED until it transitions back from RUNNING_P2P->RUNNING, at
  which point it resumes its RUNNING state. During transition to STOP,
  the virtio device only stops initiating outgoing requests(e.g. DMA,
  MSIx, etc.) but still must accept incoming operations.

- Furthermore, the Virtio specification does not support reading partial
  or incremental device contexts. This means that during the PRE_COPY
  state, the vfio-virtio driver reads the full device state. This step is
  beneficial because it allows the device to send some "initial data"
  before moving to the STOP_COPY state, thus reducing downtime by
  preparing early and warming-up. As the device state can be changed and
  the benefit is highest when the pre copy data closely matches the final
  data we read it in a rate limiter mode and reporting no data available
  for some time interval after the previous call. With PRE_COPY enabled,
  we observed a downtime reduction of approximately 70-75% in various
  scenarios compared to when PRE_COPY was disabled, while keeping the
  total migration time nearly the same.

- Support for dirty page tracking during migration will be provided via
  the IOMMUFD framework.
 
- This series has been successfully tested on Virtio-net VF devices.

Changes from V3:
https://www.spinics.net/lists/kvm/msg363002.html

Vfio:
Patch #5:
- Fix an unwind flow as part of virtiovf_add_migration_pages() as noted
  by Alex.
- Fix an unwind flow as part of virtiovf_pci_save/resume_device_data()
  to not kfree the migf upon 'end' as it will be done as part of
  fput(migf->filp) -> virtiovf_release_file().

Changes from V2:
https://lore.kernel.org/kvm/20241111084157.88044-6-yishaih@nvidia.com/T/

Vfio:
Patch #7:
- Remove the 'select IOMMUFD_DRIVER' clause.
  As noted by Alex and Joao, IOMMUFD_DRIVER is only configuring in
  iova_bitmap support independent of IOMMUFD, which is not needed for
  this driver.

Changes from V1:
https://lore.kernel.org/kvm/20241104102131.184193-3-yishaih@nvidia.com/T/

Virtio:
Patches #1-#4:
- Add Acked-by: Michael S. Tsirkin <mst@redhat.com>

Vfio:
Patch #5:
- Set the driver 'ops' within probe(), including the call to
  virtiovf_set_migratable() right after allocating the virtiodev.
  Consequently, virtiovf_pci_init_device() is now only used for legacy IO
  access, where its specific initialization is performed. This approach
  was recommended by Alex to avoid modifying the 'ops' pointer after the
  core device has been allocated.
- Fix multi-line comment style.

Patch #6:
- Improve the rate limiter flow to account for the 'initial/dirty bytes'
  which potentially might not being fully read yet, as noted by Alex.
- Add a comment for the rate limiter uristic. As Alex mentioned this
  would be useful for future maintenance.

Patch #7:
- Add a new boolean Kconfig entry named
  CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY as a submenu item under the
  primary driver functionality for live migration. This new entry allows
  users to selectively enable legacy access functionality, providing a
  dedicated description for each feature.
  This addition aligns with Alex's recommendation in this area.

Changes from V0:
https://lore.kernel.org/kvm/20241101102518.1bf2c6e6.alex.williamson@redhat.com/T/

Vfio:
Patch #5:
- Enhance the commit log to provide a clearer explanation of P2P
  behavior over Virtio devices, as discussed on the mailing list.
Patch #6:
- Implement the rate limiter mechanism as part of the PRE_COPY state,
  following Alex's suggestion.
- Update the commit log to include actual data demonstrating the impact of
  PRE_COPY, as requested by Alex.
Patch #7:
- Update the default driver operations (i.e., vfio_device_ops) to use
  the live migration set, and expand it to include the legacy I/O
  operations if they are compiled and supported.

Yishai

Yishai Hadas (7):
  virtio_pci: Introduce device parts access commands
  virtio: Extend the admin command to include the result size
  virtio: Manage device and driver capabilities via the admin commands
  virtio-pci: Introduce APIs to execute device parts admin commands
  vfio/virtio: Add support for the basic live migration functionality
  vfio/virtio: Add PRE_COPY support for live migration
  vfio/virtio: Enable live migration once VIRTIO_PCI was configured

 drivers/vfio/pci/virtio/Kconfig     |   42 +-
 drivers/vfio/pci/virtio/Makefile    |    3 +-
 drivers/vfio/pci/virtio/common.h    |  127 +++
 drivers/vfio/pci/virtio/legacy_io.c |  418 +++++++++
 drivers/vfio/pci/virtio/main.c      |  476 ++--------
 drivers/vfio/pci/virtio/migrate.c   | 1337 +++++++++++++++++++++++++++
 drivers/virtio/virtio_pci_common.h  |   19 +-
 drivers/virtio/virtio_pci_modern.c  |  457 ++++++++-
 include/linux/virtio.h              |    1 +
 include/linux/virtio_pci_admin.h    |   11 +
 include/uapi/linux/virtio_pci.h     |  131 +++
 11 files changed, 2601 insertions(+), 421 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/common.h
 create mode 100644 drivers/vfio/pci/virtio/legacy_io.c
 create mode 100644 drivers/vfio/pci/virtio/migrate.c

-- 
2.27.0


