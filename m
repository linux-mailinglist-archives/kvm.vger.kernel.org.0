Return-Path: <kvm+bounces-31413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E99519C39DD
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 792731F21FAF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5E0170A0A;
	Mon, 11 Nov 2024 08:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ws/TIPWN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAD016F831
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731314569; cv=fail; b=ruODnc5eTAm/X0sOGwCV1m+RHi6w/KoMhp0bTeRuc1Gz3dVyOyOGlm9oUZ3B+ftOrGjYo4VIXyijRTyG87OeK66WYMhEDcR+12V16O9PFEbcveZ5Fu2elOfr6NwTHII8bDZtVjMmZogu2PK4qX0KcRwItr+cP4dwQeHK6jRiPAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731314569; c=relaxed/simple;
	bh=VTUcwnP5+c6wRMmny+dm98OWPWoFRAI+q8F+LNhMYrw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XWhK3E3nwORT22Q/pMItH2CHJQlL+1edL50FNgIcCAvA1pVUJaChRFLtSoCSmbYuzX9Q1Z0x8yHuYOKw8jWhVZhlTsO4QLULHKEhNro6+EpFLj1RjxWwy4QQhT/YVXH5RywgIO/+mw9hpOyhxt6WAy4dG320JqpooPTIq2291L4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ws/TIPWN; arc=fail smtp.client-ip=40.107.93.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N4fkLtKfUNVZvXMxo/7x44H+bGLgnRvhbXDIKWtk4DDqiznoWNk/wFZwGYHR38Ut2jr/EfgoQ5lu0Ki0MmnwjFvB5ikHGTiGgAcAe686rLlqZgv59VUnwoTmmDIYQqJP25k4yTm8Vbz4c2iFw1p2B77zhLoS9qrxLGtfGzBeuDS9oNdhiIh9zyLKh2vefCUKc89RVhUPyy8iey5gDA2mWW8cbDdBs6L52K2Vwzq1nGlFyXEiM8riVZSJcpGSdYrWahT2J5z39A+f9A2nxlwSBjVzoYYIamu+GJquTVhP6AbbJtRlex06qAsq3hC7l1fvblRZqdVuCM6WFkJSObAVRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8//dFwpsJSHJ91ARrQHLebrxcV6lp1PwM7jvWRNuRE=;
 b=DDMdEBH7/MwJWe5in9cZAPOhhKfz2SnVKRmOTDI6numNJWN8u2FH0EZg2jZN0SZ78dWoer1iKAXidRQPKwnjjpSBpw9uU1w0M1FRfTH1Z7gtWD11fdfuES3ypu20c9j4bBJOdP3YVP0aDcO9XQ96RYVHcaDysipjcBH0lYhV5Tfr6Jk27R3ybY+8LbAp0J+ACOryksC5M2f7OK+qDO4iVIbvfWoyMancLrBZKFTmRtWNO6G7dD3aZaqmfcO+HxieIK78wSyQJpsv7R8EtYb2WqgrYe5jK5fR2g0lbkur3FPFYCLHRwOjWSnSK0b92Ss8JPsr5mDykpYB4hdS4cwp6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8//dFwpsJSHJ91ARrQHLebrxcV6lp1PwM7jvWRNuRE=;
 b=Ws/TIPWNeDMj/3ULWd5smDZvHrovOSpXIx0d1FSl+dxr40jiqQO/lRC6JZnOqPFi7z2DEmTfm5A/jgucTmeh3nQqKOVWVX072h9Ve6XNKVrTpPFNwUYvxxNYCWYj1iXTLLBYYpRZQD1mnA8l7S3vl0+Jiwj/8eEvqVQK5HbKfpZp4AdspJwXEXekNyXPdDhQn7CIaw4tiVZ8vSgeHEE7ax0y8twhGyiPgxgSLk3HBYvOrsG+MNmLSkUUCzJBA3IKoTWZyOR5/n720NCxQDyAS9vuVWct9VfDdpErkR5Fl2C+M6/9NB5AV6bnrNHymUkXMnvXjuVsLR6wf2mcCxVkbg==
Received: from CH5PR04CA0018.namprd04.prod.outlook.com (2603:10b6:610:1f4::29)
 by IA0PR12MB8227.namprd12.prod.outlook.com (2603:10b6:208:406::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.22; Mon, 11 Nov
 2024 08:42:43 +0000
Received: from CH2PEPF00000140.namprd02.prod.outlook.com
 (2603:10b6:610:1f4:cafe::91) by CH5PR04CA0018.outlook.office365.com
 (2603:10b6:610:1f4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28 via Frontend
 Transport; Mon, 11 Nov 2024 08:42:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000140.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 11 Nov 2024 08:42:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:31 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:31 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Mon, 11 Nov
 2024 00:42:28 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V2 vfio 0/7] Enhance the vfio-virtio driver to support live migration
Date: Mon, 11 Nov 2024 10:41:50 +0200
Message-ID: <20241111084157.88044-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000140:EE_|IA0PR12MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: bf39856a-fb85-48ac-ac47-08dd022ccee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4lA2VuCrHvXJxabo1cH2PqVOcSEEbknK+Ioqy/cOwiAE1bo0OTUvHttKbVOh?=
 =?us-ascii?Q?L9xM7PJacEDxTX083FViFmdMVkEPN6Krm1shHGZEnvdUAFsNEOVRIxA2PrXZ?=
 =?us-ascii?Q?tb9H8zc8p6kVh8fZwHTRs6UCiOHhmPymFmfrm8T98Bq+MLgynN8Gloy1SHTF?=
 =?us-ascii?Q?mojKmODwtLZaaVIRq4nx6T+73vq/FckoFd1S1RSWq33Tjv/+wsHrCEFPbFw6?=
 =?us-ascii?Q?RqNqvpHJSTBi0KNVYi72Beq6yfXK6obVD8WPKQZ90ZXyOviMZqwdq1ooHFAC?=
 =?us-ascii?Q?mcDA2Yq2sG1ejNvZaZWEedRG1EwEmOtCSQ8q76Chz5S1foEtW9vKuEYu4cfP?=
 =?us-ascii?Q?kA0VOjd6pB82b95wGRvESWUek9HQAn7MQKjlWgOHH8Iq4c7oB8DgMfuK+rxR?=
 =?us-ascii?Q?/7nwUdloPYjZMjpUR0oTCwDqMtc4Pd9QCueGvTgW5HjbCCQc7DEWcHREm8Lr?=
 =?us-ascii?Q?bqiQ+m9WWg4TFbBoBf2eimMx/kGCNmsLlpgWALoLOfpYhy2P5vikql4oGigb?=
 =?us-ascii?Q?wqKo/yRRYJekyuAR7wmghJxV29+/pOafSXHBfyIddl4yEthkOohYKMO1zWAk?=
 =?us-ascii?Q?tW2qxbcu1iJvzsb51d64VNbOcKK0usMbIIBdbqtf4LBH0/gSijjtT7MoYkjn?=
 =?us-ascii?Q?QKGaJeX2qoZ6Y6WKI1w3g+IYdOB70YWXr27SLkhqoJbFL/CMkEmvIR/QluP8?=
 =?us-ascii?Q?XUPn4IZW8Bb9dW5uieE1yoSo56IHW49K41lyNfNI+oTlPnll9n8O7Ja+Z5Ez?=
 =?us-ascii?Q?U0+eQl3F2XhbydY6m9AG1SBcSX4k9v4KuPje5jYLELMIZ5P/9of/fFQy8QVf?=
 =?us-ascii?Q?vPcL+L5XlfhChgiVu2A9FQgCLMY+eOlN4dSzTiNl+dx/09VR9wErySBzHHkH?=
 =?us-ascii?Q?rL5IJwtQ5MLsU17P2By3FP8sqeJZ53YcTvrca9DQrK9TiJjz9UbEUZsX/Z4V?=
 =?us-ascii?Q?8lGdO9XIfG5E7HTos+KC3c60LYUy65CjWy1+jVZ/joVoMtEPrvCDXrowTcBg?=
 =?us-ascii?Q?8EIvbY7WuGZPoD7izoYSlAH9rP+hLlXFg017FxIoXMu963tGd8SKBsCl79e2?=
 =?us-ascii?Q?W2oK+uBqcmT1q/nWUCUPFJtwkDRbmin0kSk4nuYmCYEVRC6nnUiEKIVPGtY+?=
 =?us-ascii?Q?+uJOdJRcGcmfzRBIkto6Cvy4yr7Qy7FzXTg8dypU1q5+PElFfj8S/QEu4gxN?=
 =?us-ascii?Q?nwFWqaxIRQ0d8/qJNC20OFZTF3RNisbiSibsyBT7+lHgjWM/SeJ2mb1zgPSI?=
 =?us-ascii?Q?w2T/i9paw9o9dXITWKlxUbOhH7aWQd5yvhxcGKBj0rNYJDIThmlrjnqKh+NH?=
 =?us-ascii?Q?/mvCIAFq0B7o3Ui/OSkr4JVYppHJEN0ijcdesvPLtNUqLqO1hqawW7w5RPJn?=
 =?us-ascii?Q?vSYkRaCkm4R97vkiIlPzMhCybpMMXtrxpFrnYW/QM/ndyWMgrw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:42:42.7669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf39856a-fb85-48ac-ac47-08dd022ccee4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000140.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8227

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

 drivers/vfio/pci/virtio/Kconfig     |   43 +-
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
 11 files changed, 2600 insertions(+), 421 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/common.h
 create mode 100644 drivers/vfio/pci/virtio/legacy_io.c
 create mode 100644 drivers/vfio/pci/virtio/migrate.c

-- 
2.27.0


