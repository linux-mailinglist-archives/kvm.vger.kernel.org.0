Return-Path: <kvm+bounces-31590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 821AD9C50F0
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42A67283AFB
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C71B20C000;
	Tue, 12 Nov 2024 08:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sdk+Jc3H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872920B80E
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 08:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400719; cv=fail; b=s4aEttB974ZYDfWLQalwy2CVxeN2VNxi9WAxFz7WnrikBoNx5MgkCk35qJ3KaOHBzEZOitBYBho/d2r6ohaMgkzGyf4vKwzFsxcQOSHQt+9YEcLU7gNJoSYnXaMEZ/VYgwaRmNTqT3mm+tSwEGJUtTxrvRT7Ys5JSsHEhpTBX8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400719; c=relaxed/simple;
	bh=qrYUc6yiJBU+hxKzTYK/4tt/pSd5WjR85G4lAD9ajww=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uzETLtonGtjxr9RwIx820OEXRRnan4S9GxvO6mxvrSNkO2298AKsPlfBXMz4gKTslcNerdv09Yue4PnquqNtbqjCD7FfGfz4LYR1Q1Heqf0q2SIFvT4HzgpGZFtlR+zaDiuSOACq7WVrfJ+nVlJ8sdsBtCAKnCAvimT8oJD4c2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sdk+Jc3H; arc=fail smtp.client-ip=40.107.223.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lhHGJTKO2vpD13IzLYBfHu2yqHjTBIZ9/mnP8indkUs5WiYRP/gpOSWRuV52Fdgcg1ukgVi+9yaGyG0imA8h3yR6IlZhEHRLQUELHhd7rVZpLj1OF+roCFVnQIQh4kSHpHto/U61W4vRLk2g3TzxtMk3mqMvPcGLEKm5seseG51AZy41aCRtKAt+hMYta5a93ZuwDpq2NKCRNeN4ubkyhgAQmss5pWOnMALmnBvTd0ZiwiZtupWD2nRAK4rM4n3u5pQwcY/vNnWb9BWqfmRM9LT9lSbg8GYtJE+yDk1jRq21u/Py5BeX8qhCuMVcv74nnAWFNsKS4jX4T+7CfZxDoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dq44S19Lm8KfkgMV1Tzr1oKGg9H1HhsKMYUp2itZwDM=;
 b=dd0y8tZJqj4RYexXSNZTIwlUHXq8dh1mi98iE4hsiURiMNFNGU05gse/u0HVnsBRcADhn7jdqrTCbv/ZaMJaHMDTytGoMH78ZlVCDEZaATcXoC+P2+/SDh3trUCVDXvNPr7Cxd5Z0zDcsrMD04vMAVNvXE05gxHHyWRoyXyH03CaeLq3yM8/OyNeYRRKgqxkE5NHvsDoqh3hke/uSBh2Sol56zT5+oWGBnyu4FtE7nxxqUKYgihiohlVEni+b+zOG2jWc9hUlCG7v/io8RkO/jsePJrCmhx5rOZoRf9386SDVFcA7ESDX2XmkRe9CnxRoBLnEbASM2Eoy1a/XVGjwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dq44S19Lm8KfkgMV1Tzr1oKGg9H1HhsKMYUp2itZwDM=;
 b=sdk+Jc3HGPXL3AxzOo/jMagxqmEmgSuyjcv9ksrNZhrK2NFDly/ZV8HAjZzFjKD0xqZV0jZJE/n7Nmi4SQTL9ckDAit4O6JLJh2XahbsojI9CoiTvzwWd0ZLyDOat9nuNleaqxfFvIveA489P4v2g4fzrCrI6RAymxeWBkCbqlH4+UkXwNV5kzN2OgNCvMiEntup54FZnhlTJB6SQIFCsOKz+3a9Qjth6drVjB1T0JtEi6C5r0XR8x5mpUGxr1cAogyF+YHOe2awCD/1xR08vxcVKjU2L0KXEQYDIQoltqoXzKOCmXoVQzvYQUmqhHvgG2FNwd28z7DJJOMQIcwuWg==
Received: from SA0PR11CA0050.namprd11.prod.outlook.com (2603:10b6:806:d0::25)
 by DS7PR12MB6215.namprd12.prod.outlook.com (2603:10b6:8:95::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.26; Tue, 12 Nov 2024 08:38:31 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:806:d0:cafe::dc) by SA0PR11CA0050.outlook.office365.com
 (2603:10b6:806:d0::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29 via Frontend
 Transport; Tue, 12 Nov 2024 08:38:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 08:38:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:17 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:17 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Tue, 12 Nov
 2024 00:38:13 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V3 vfio 0/7] Enhance the vfio-virtio driver to support live migration
Date: Tue, 12 Nov 2024 10:37:22 +0200
Message-ID: <20241112083729.145005-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|DS7PR12MB6215:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f54f6de-c9b3-42b6-8a97-08dd02f56385
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5zblFyH/+kqU2eBDYjFG/+MVMuN36GLA1piMUhLKGkmRdJ9Gnx+Y5our7oUT?=
 =?us-ascii?Q?ZjnddMZ5xFJGkopCLfS1BHKcYkizlvGdudv4Oo2ZDRqbovYs0NioWV8747Kx?=
 =?us-ascii?Q?zqxpNXGzp1TEebgZkm3aNUEtiinJOosw+kKJk1X75i3mPKy7ZplByCBIDklJ?=
 =?us-ascii?Q?ab9BlQxloza5N6Kt2aNSYQe4IvgUSRYUu5t9ORUdlmfhgbwiKOYOUvbQO7y8?=
 =?us-ascii?Q?itYMDi5BJYklIyARGdGQDt95g/TqsmE48SKuXuvKmYBjFtGadE0hfvSZpkwz?=
 =?us-ascii?Q?gC6+0C34MzouJX4x29QdUHkyuNGg1a81EAEOHU2CzCeZzGDAfdW3ipbRYO0Z?=
 =?us-ascii?Q?sL3n4wNmXtwdquQwparE1EN0rVJ6P53mew0gcsX0ntwXYDzUbkbpWICZRUv7?=
 =?us-ascii?Q?xmT2b+3Gp21B7IgW7g8pTkOSiFHJINddXrOHKrai65LrpN3wnftyEdyn5mD0?=
 =?us-ascii?Q?8Q4u+MblrYX/lNhLc8yJXao5IJDsvVrn9sjxiSx+yqUPgWGsTNyaIe8Scs7N?=
 =?us-ascii?Q?7xdAVhxqXgX4zi43XgPN/84mefPgC7J6M02gR9NmHpVKM9DIK5Egsz7yCh0F?=
 =?us-ascii?Q?+E7TZBXGZZeFGa78c+feenpDXf+6yUw4Tp4GGiUAr+6lJugNJWq4OFbkaZzx?=
 =?us-ascii?Q?7gCwsdKXjJdFC0NauPrThRjVucH7d5bFtul1sqc0Pf3fCIH+HNVPosuLLeTp?=
 =?us-ascii?Q?4bMFQSuOFJZwtEQ7pcPLeeDEdCCrfNQO3rDY2MiwmdEhahfcQIjc3UWy+dZC?=
 =?us-ascii?Q?g4lBmglPd7IiUsRDBdAMQk25y/QEfQlPQtKirVPCkx61iy0pH0PDaJY92qhf?=
 =?us-ascii?Q?t8c990+H9m0C/5DUfyZjR5/hgjSHLP2iK9t2xe9oSxUwRhhVvcFg9q1XiKfu?=
 =?us-ascii?Q?+kDZk7uE/7ulRgOHivvFCytqmB585n4SY1sTGSuzz3ulRni/X8Cesh42KsDN?=
 =?us-ascii?Q?RKBfI7SR8XpTFd+AO0QnwlMeq9tu3IRrShUnA2WLwxr0NGlARFaw2ErbKIdy?=
 =?us-ascii?Q?izOdwdEsWfEafZgaq2lnnXVNZbGoTJoazU599aSMUxWS9WFg29NQUiL8YZxt?=
 =?us-ascii?Q?FQai/SwPwRWItxUDLXgCCkUSwhmnl8c5ADC3WdQf0hpJ33vfExSVAjMgvcLM?=
 =?us-ascii?Q?jz7jD1X4WueIEStJc0E/EyQAVfvrWfTVWnyfHX1dWO+887tsBCG+RamcR5Pp?=
 =?us-ascii?Q?f1ra7p93nvTeWhTV/bRBBJCMz66UUQRB0nmz3Df8+4SNvoKsifjcjR9ktGpn?=
 =?us-ascii?Q?UYavEwVwOHOQWeW2o+blhAa3Q6QUep26oMQ+nakudeax/gTocAq6ZxZV/5BO?=
 =?us-ascii?Q?SRH4fzAeRTypEO6XchlS+8XyyENLW3ZCblsPu5S5Im+a1d49t5W1DlGjjCWc?=
 =?us-ascii?Q?GeBA/Hq9OJYiHiVYQRanKPTED2tYngf1TrI+XAwg6N2aBSU9Ew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 08:38:31.5323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f54f6de-c9b3-42b6-8a97-08dd02f56385
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6215

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
 drivers/vfio/pci/virtio/migrate.c   | 1335 +++++++++++++++++++++++++++
 drivers/virtio/virtio_pci_common.h  |   19 +-
 drivers/virtio/virtio_pci_modern.c  |  457 ++++++++-
 include/linux/virtio.h              |    1 +
 include/linux/virtio_pci_admin.h    |   11 +
 include/uapi/linux/virtio_pci.h     |  131 +++
 11 files changed, 2599 insertions(+), 421 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/common.h
 create mode 100644 drivers/vfio/pci/virtio/legacy_io.c
 create mode 100644 drivers/vfio/pci/virtio/migrate.c

-- 
2.27.0


