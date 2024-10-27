Return-Path: <kvm+bounces-29754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E97D9B1D11
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 11:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E205C281AD1
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 10:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2B813B59B;
	Sun, 27 Oct 2024 10:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PCcXgPKH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F3F29CE8
	for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 10:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730023720; cv=fail; b=Qcjw2EWzISJs+nQ6cOcxsc7fsUEqOZx97OXZkp/s98Bsmg/kBirnTU34NE9Pnt3tby5pTV+DSoSRDN44Pys/IgkSxP0ulCF3Z9WQaNPTMP5lVetQZ0ki/vBsTps4BYyLOjvoSG+iS5o9pGmUoajCbgjAj7pzpvqg87SJ1lv1avQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730023720; c=relaxed/simple;
	bh=42KrXyNjAsSguxripYCr4BOT2l9Zkpr09QnRkDrdnFQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uL/J4cBsq55EBLmu3U8ZMQevVlLShWNxxNL/z75dYaSpMiWkf7CAC9RXo7VrjojpdscgSb4zKsmmFe2AiWzoUQbBRNIGD6pY5EJDZXaCOVZ/mUZk2QtLPjqcn4OHMKyWDPWDFN06sLY5DYL4L3zeR5ameEtzQ1+soQe8gy4/Elg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PCcXgPKH; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s7UO58fSFo7vVZZajKYIGiFKMUpfsgKEp/bsetvMFNVDSAu+2XI3AJCT4gIKwrEpfJ7ijqu0ERP4b/BVMv14YlMzGPbtb08PME07FtpU/Dy6MJuscgWcNvfUOk5w6/N3G47brIP1KWG1cGqxsu/DedzK9xXE0RkUUrwkdUYZOB747HrSaFcB8CfShoS9HZ5L2P40rc8fR06tAauFH9Fop/Bfd5VUsoj6qx2GC8T3ude3yDIBn0qllP/2yM2pd8RC+ZzYimGOjGqpuDaDMqBVoIcrh14ENYMscWF9VO9fxKNuSkfMGl7QmqZ7HZNMF6Fl5tlq7t31jd9fNfmSgy2C+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPjQUWXk6Tra4ix46EvHuWdZcFfmvfQEc7G/zbY7vhI=;
 b=V0fcZTl38QXZSEubSi1K9mirf93/TGD/wTPFR2e5HOQDgVaBqyWDQmc63y0DKipDqeBX7FS8DZQlgGFIl4yR6XHed0vp8uypmA86JrJG3Vnf3xe9bx/igIjVQVArQUL7ZSSLKGefwt7aCLC/vZvrhU5ciU59vIz60eyseaziC7SicKe2lJgre3BPgMPXYeiH5LPmJRaA+UoaHM+ztwIUdC6Iq05TymJZQ6mPPWuAXFo9u3a/T24sfOZ2UVR3UOSVsMa+eujMHQrdEJ97Gu617Qnk+/idXA69oaOicjG/f1NPaiIjiqL4fpnyYHo5GoH18NpzgIPC9oeSpkQRmcNKzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPjQUWXk6Tra4ix46EvHuWdZcFfmvfQEc7G/zbY7vhI=;
 b=PCcXgPKHZVFrlr7yj+8KZtohx1yXLRJ8r/vMHI6SbTqKNfwA3lA/6TYclOjutWsGzUHeGclR8gP2zAx1ZvYKTt0zTeVEKxkreiyJSpg1NMKeB2cV0FytAGZMFBgXfuduaqLekDjTakXTUes+jVURUMqbYV94BmeC8WtUC6707RsUB9JPTVhniyMsApcBNLwKPB/0V23aedLL4STibIquLCxEIu4PdRt10lIwWuTBIX1WK7JIP7MhUuIsfeaXizaQmgrGAFw3HFTxjs4bQS1bKeVs90DdloUFVekF1qnq+m+UVCUfkPUHG94+rbxyrf+LLz6B36ylWaPAgP6jcIkdyw==
Received: from MW4PR04CA0049.namprd04.prod.outlook.com (2603:10b6:303:6a::24)
 by SA1PR12MB7102.namprd12.prod.outlook.com (2603:10b6:806:29f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Sun, 27 Oct
 2024 10:08:34 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:303:6a:cafe::dd) by MW4PR04CA0049.outlook.office365.com
 (2603:10b6:303:6a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24 via Frontend
 Transport; Sun, 27 Oct 2024 10:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Sun, 27 Oct 2024 10:08:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:19 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:19 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 27 Oct
 2024 03:08:15 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live migration
Date: Sun, 27 Oct 2024 12:07:44 +0200
Message-ID: <20241027100751.219214-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|SA1PR12MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 3413feaf-a4c9-45c2-07ea-08dcf66f50d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VETwP+kmJc6Ptomncv1ipUioTQzUqjPdsWnpBqxgQq0xmP26ph9au5iQTR3D?=
 =?us-ascii?Q?tKJSAPitiomPtnBiobgUxE9wweQwC7AdOXWGdC6EiZnH8c58tbLX2llwgYI8?=
 =?us-ascii?Q?JkV7xd2MOGRex4p4QWCSBtANafqYzNnXHBT9e3oNFCrFcDS5gEdJH4830G52?=
 =?us-ascii?Q?d04yepr45t1zs0LyyZBCjLJ9ScPZ2i84AvffHeFaOPyEXeEHTnmdu75mT1Nq?=
 =?us-ascii?Q?U2MVcX0lLH0kJWFJoUukVhKhN6Y/gXmpBddfUssGcRuG30PsFFYPqDvxFFeo?=
 =?us-ascii?Q?u9oy1poonBZYLOa7AokgRNTvkB9vJm3MFGHJ6szYyyavdGZd5WuJxHI7waUb?=
 =?us-ascii?Q?WuVCT28/pXNQRZ5P63AVW6Bvy+3FdsZv5haSBnAVX2GK4HdIy3wLFYN3KtC/?=
 =?us-ascii?Q?3WoUZm3SChWkmVwMVccPH5asJqe2FWRygCjbvR4YwMf9Z2UE1Puqs0sU16ol?=
 =?us-ascii?Q?o0eMJN2VYEngNseM4xMA5XSPbcf795pNzmNr/HDg/lLYcOIn/zCh/mBCbt2j?=
 =?us-ascii?Q?O2nRClGb8ziP1kOMp8HV9pgx5P5+3T6mpwA2NxiF27dro0MJNF62bNE8VLug?=
 =?us-ascii?Q?sB6yyiHRKsRf8+dl2rn805uw/C8DNecLT9YEIWolP2a9ZinfWqSxL6TvpLt4?=
 =?us-ascii?Q?tw8ZZlmRdESM1DlCOaWUTlpfY4Xwu1GXTlNvJhrqm2RtcRUzyZ/laM9R7DGa?=
 =?us-ascii?Q?Vqc1phGnCsS/Ds4ONndwxV1IACkXtNAiIrW1AGiogOsdIhbM7vl+rzrEmPOs?=
 =?us-ascii?Q?fE+NTigrJWfcjGUZEM8lCVL3SgI04IQr/LIYcGyhRLHr6dk6HmWoj2m1sgRD?=
 =?us-ascii?Q?hfOFFiOW4O2g4YTp8zDRwdpG6pRTeQ8Z3g2nSthmNqA1KzXv6Dyds9WyT7vq?=
 =?us-ascii?Q?rJ9zBubmO9/6+lQUqXjWzP5S8HwO2JjS5AhCEpwr0hUZj+R0dGnZfIhRzyxy?=
 =?us-ascii?Q?fFvS5XONnpBrym9zCDBsTyVfumuFOZ5C01B7U5MGIYjceMcbh0nau3QdxbuM?=
 =?us-ascii?Q?ndxFXKYFtQn7DffAziuX3HBiU5mnGcw2tJMsooripV9c4DcyotBHjvJHGUyy?=
 =?us-ascii?Q?1HzlqgOn3vOq868+LfxKJz11H+nhZ9Npkt8GZUdW9DTXNwiNcdRQ2yB2/mkq?=
 =?us-ascii?Q?1o0kZKCfgo+/I0TiLXVZhw+m5sUiieMYkKDDB2LwU/y7shvC5+f6i6xfMzD8?=
 =?us-ascii?Q?06aqYZ1jFLDuCWJopTc6N4y2DueLIdHwodpnHkZeGyE6ycgKsdlqmhC/D/QF?=
 =?us-ascii?Q?5hOGaYjC7LlRiyUT6eHrfn3TBmIT3I4ALbL69nBmyFfIQjTfOrngfUaCHRT/?=
 =?us-ascii?Q?Y988w3vhxlxU1l7jyNEVKVTn9yYRPDwgZyjXZxr146BNUlBMogoGAHhqGJjV?=
 =?us-ascii?Q?7wAGoTazZlmCxo+u5NpqH62CBqd1hAwA/8gk2lD5arXus5mIvg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2024 10:08:33.5808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3413feaf-a4c9-45c2-07ea-08dcf66f50d7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7102

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
  which point it resumes its RUNNING state.
 
- Furthermore, the Virtio specification does not support reading partial
  or incremental device contexts. This means that during the PRE_COPY
  state, the vfio-virtio driver reads the full device state. This step is
  beneficial because it allows the device to send some "initial data"
  before moving to the STOP_COPY state, thus reducing downtime by
  preparing early. To avoid an infinite number of device calls during
  PRE_COPY, the vfio-virtio driver limits this flow to a maximum of 128
  calls. After reaching this limit, the driver will report zero bytes
  remaining in PRE_COPY, signaling to QEMU to transition to STOP_COPY.
 
- Support for dirty page tracking during migration will be provided via
  the IOMMUFD framework.
 
- This series has been successfully tested on Virtio-net VF devices.

Yishai

Yishai Hadas (7):
  virtio_pci: Introduce device parts access commands
  virtio: Extend the admin command to include the result size
  virtio: Manage device and driver capabilities via the admin commands
  virtio-pci: Introduce APIs to execute device parts admin commands
  vfio/virtio: Add support for the basic live migration functionality
  vfio/virtio: Add PRE_COPY support for live migration
  vfio/virtio: Enable live migration once VIRTIO_PCI was configured

 drivers/vfio/pci/virtio/Kconfig     |    4 +-
 drivers/vfio/pci/virtio/Makefile    |    3 +-
 drivers/vfio/pci/virtio/common.h    |  127 +++
 drivers/vfio/pci/virtio/legacy_io.c |  420 +++++++++
 drivers/vfio/pci/virtio/main.c      |  496 ++--------
 drivers/vfio/pci/virtio/migrate.c   | 1339 +++++++++++++++++++++++++++
 drivers/virtio/virtio_pci_common.h  |   19 +-
 drivers/virtio/virtio_pci_modern.c  |  457 ++++++++-
 include/linux/virtio.h              |    1 +
 include/linux/virtio_pci_admin.h    |   11 +
 include/uapi/linux/virtio_pci.h     |  131 +++
 11 files changed, 2593 insertions(+), 415 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/common.h
 create mode 100644 drivers/vfio/pci/virtio/legacy_io.c
 create mode 100644 drivers/vfio/pci/virtio/migrate.c

-- 
2.27.0


