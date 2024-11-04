Return-Path: <kvm+bounces-30487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 403DD9BB0EE
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3A642815C4
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8C311B0F18;
	Mon,  4 Nov 2024 10:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hDWM6RDd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010B01ABEBD
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 10:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730715802; cv=fail; b=aPjfYg9YeYkDk7eCPxHDahmAYGB0cds6wdjsMh1WoUedxkouKXrthkPwisXv9cp+l1jFPSP0GgtbncOjhPCof/Pa/BreTC7FcyJLzGB61fYIpAHwLd9nP90G60/JGtToTjKr/uCeEekbqHEh7QfbvsQoGIp670vC3XIeXTrrpDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730715802; c=relaxed/simple;
	bh=z+Z3y9gWt6jbbvCTMElq4tSqRa74hjblB8ae1/TRk3Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bUO2eRfJS/m4BwVl93GoEPAskSsAWFmdlhFuxr8VFx+Np9qjbLsBit4BT+87OWb0VhXBC9AAIMDzi5+DaWW1ptI/YAkb/Upk7+nOZj3aJ7FWTdaKnxtXlQRvWlTtEIpVHhJOzOZKLEoHCDsfMX5OVdd9tRIaiUkHTuWe9sc+O60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hDWM6RDd; arc=fail smtp.client-ip=40.107.95.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ye1O9fmwhfH7tAHCcjxzpZlir54+2XiTzuUKp/CHZ/9K2lwNSNL3nNset01QG300driV7TlfdUUNuriPrD+DptqBm2EZ/zb6RT3sxCjgZ5vNbCiWZFlydC5HQs48wDtYkfmayJVYbYGTlCyUsKuO+xn/J3b+fIv9S/Dg1QORj5cvNhjEzpGF1uh9pjenJIScCfK2vmZznQCdx/3eYeskJSeC+8mPAxUlQWI11gal7nxAJk49kiPfyf3JXrlk1HA8sKikIW2lS8EkiUcZJkvmGjAbLiAKvSsXZ6c1+nog4OoVm/b7Xh26mrvKRgR4F57cUr8DHgcAKaJJIigcr6FA+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYENykhwxnpGV4NPoy1HdAE5Yq6nNphIEDBzUZgRoj4=;
 b=v4YJIDrgH/se+ZDld0j9ty/4XEQEV/Hm5MhU/QEbw0ry6UMMQr3obQAK/QK2GAfirGHr1u6TvlPyzJ3qjx8MKrlRzdcGVIfFNpWtoVVgkO6GD4Obb48C4GAQlmqBA0YH/HNXp9NiZ2e+8XPTvuGY3KYLhjl+3BLl49WPyxrqd5v1cNbje7pIh+2a8vvGhiaxk3aHFqzjJEcYOE6xBjvBfICSyl+PnOC/fEmz8PO1F139uU2PVX1Nl9fjRC3OENM2mEaLk/H9aqILaj0xfkvd2URHsdKZxYi57Bre/7JjAmUcXvEx8ZnkGIas11OjjW2nNnlx7CtOTLAZQFZKVnc2LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYENykhwxnpGV4NPoy1HdAE5Yq6nNphIEDBzUZgRoj4=;
 b=hDWM6RDdhZ98Rz+0F9jeameBRfDPtvmUJwX6xrWMGDA4011w8EA+Mqk0g2yVSF/EPmIzwFefFIsxIT3mN5ulzLmc6unIaRf6XLxV1uqYHm9Te8G6HEuof11/iJrxQ/ZTnrNWa0dNKtHBRvFSIRmqnRHYda54hQIQqNUOfLHR/FsEuDrDWOAUiouWH1Q+7yyc4IPUCcsA77dlC3BTCRraLC6FBcjHc++8ydYkbN1u9h3EVGrCnFJBMFxYlur9gpU70E0SQtpJcfhB75/uVlIRzrq7PMAOvSpSvl8RqPtOvTAor4fjILvbHCDbK2uavtLtD/C2FGXoQ5XktdEgmF/uYQ==
Received: from BN9PR03CA0765.namprd03.prod.outlook.com (2603:10b6:408:13a::20)
 by CH3PR12MB7596.namprd12.prod.outlook.com (2603:10b6:610:14b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 10:23:15 +0000
Received: from BN1PEPF0000468D.namprd05.prod.outlook.com
 (2603:10b6:408:13a:cafe::80) by BN9PR03CA0765.outlook.office365.com
 (2603:10b6:408:13a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30 via Frontend
 Transport; Mon, 4 Nov 2024 10:23:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF0000468D.mail.protection.outlook.com (10.167.243.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Mon, 4 Nov 2024 10:23:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 4 Nov 2024
 02:23:03 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 4 Nov 2024 02:23:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 4 Nov 2024 02:23:00 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 0/7] Enhance the vfio-virtio driver to support live migration
Date: Mon, 4 Nov 2024 12:21:24 +0200
Message-ID: <20241104102131.184193-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468D:EE_|CH3PR12MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: e44c5a25-92d4-48bf-6428-08dcfcbab1b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d2Y0aE9GeWpMTDNpSWc5MGtwSU9SRGNnNFdVanV4b1I5cklBZlNBWWtheG1H?=
 =?utf-8?B?S1drY0ZieTdmeFAvUmJSRUkwRVl2aGxodWpNSjE2N0xoTnA4R1hsV01yMTRa?=
 =?utf-8?B?VUxOS3Zqbncyc0tIZ2hTTkkxb0d6NVh5RUQwaXVoSkYxckwxQmRJcWs5S2xY?=
 =?utf-8?B?K0pFVzJ1Z00vbisyMFU5MWdxZi9OLytSUHZyQTdvd2IvdkY1NTN0QlpqUk9L?=
 =?utf-8?B?aVRtOS83eGsrbzNHTU1KbkZjZjFRc0J0U0pWUDRUS2xibTd5OEZrdDZsc2Zn?=
 =?utf-8?B?WVVqYSt3djk0WGlJOU5zUTRWcHBDc0o2VDlYdzdwWUVsby90ZU50bCtQV1FM?=
 =?utf-8?B?YTkyMk9PRWpEbGdqYysxWlJVblc3U3YrVU9XL3pOWGlabEcrSDVNYXBzV3V2?=
 =?utf-8?B?YzkvWlZHeUtya3FUVXRtQ1NNNnFab1NJREVXWnJ4WHE1QlVhSHhMYU5xNjhG?=
 =?utf-8?B?L2hEb3oxcWlOOEpuU09oMmlVNTR6YnhVWGpudGFpUWdSVldNTlE3dWVaeFJp?=
 =?utf-8?B?MEg1YTErVEZEZDIzRVJ5a2UxekhZOTYwZTY3UlNhTG5LbEZXRUxQWHZBTGNH?=
 =?utf-8?B?NDFxaElXNCs0UVpOTVZ6S1BoZnI4aFlFWEJ0RlB1OGpvZGZ6dXVpNi9leHBL?=
 =?utf-8?B?aFlPRjdzY1ZIQytldEpYSnZYY2Vod3BQNTBlaDFkT2dGVjJGaVpGQnV5dlJ5?=
 =?utf-8?B?Q1lKQzRBcEFUdCtDZDJWZmlKdFBSdy85QXY5UmNkVjNCY1pjcmVycWZTSm91?=
 =?utf-8?B?SlJKenVLNk9vUkZwRVgzSlFDL1F1WXUyRTRzNm9OSXliTzYzYkthT1hmbVh5?=
 =?utf-8?B?Q0x3MUlhdXc0Yk4rVXZjWmpkY0ZFVFB2aGFyTlZ1bEtENW9qeUpWdHhXT0pT?=
 =?utf-8?B?dnNCUWJ6VlMwU0krZjNVR1cyZnBmNG5YZk1SWkhOTWhIdXhnMzVEbVl2K2N5?=
 =?utf-8?B?R0FEZXJiMjZabkVnL0VzeFJIN0VhdUhCZ1E4L2dnczRlMEVlRVpxem5xaEN4?=
 =?utf-8?B?d2M3R3VkeFkrOWMraWsycUhZVGQzeTFPY1M4K29LcTN0UVk4YnFjTHRrR3R5?=
 =?utf-8?B?T1JpZm1VRDR3azFpcEh5VVlCelhyT2RLVHR5WmtvY2tlbVhKZDBnU0U1WVcz?=
 =?utf-8?B?a2lLWEpjN082RHFGcng0YzdzWXdDb1hwUDhxdk5qclVIVWdtVFQ4Mnk0MFFq?=
 =?utf-8?B?YWdENDY1d2EvczBVZUtyUTFZRmpmaHhYU0lYN3BCUkxFWGpnUHpVcmV3a2Ry?=
 =?utf-8?B?endveWN2QXdEandhMmJrKzNhOG85L1NGT1ZyYk5ITCtUTk9wS3VoTCtUbW1y?=
 =?utf-8?B?UC9wSSthYkpSWUlGcncvSEdRak1UVGY4cFFYZzllMkk5SHJ4aEtkanhBM1ls?=
 =?utf-8?B?Smh3VzJJNnArcHNRSmJNRlM3NkhVVk9qQ1Y1YVQ5UnZqcFJmcXF3TmIvdWxE?=
 =?utf-8?B?dVFSZ3dtQ1MwYkV3UDRvaXZkQm9hVGUveDN4NEJWMFBPcEVQdEtWRFBGckFH?=
 =?utf-8?B?WUxEOE8xcU9wQ000ZXljUE1nanlkK2N5NVRHbytXWHExRmo4QW9JZHhIeFUx?=
 =?utf-8?B?dk5yWUxxbGxqd1pJUXNxelluZFdrRUxGZjk2ZnBSS0R3aVpZa05TZkwwb2c2?=
 =?utf-8?B?NkE1WFA0U2k2NHRYczhSa2JRc01IbEZtT1h5T1NNSVp0aVArd1UvbWxZTmtT?=
 =?utf-8?B?VUVhTVI2bVF6TG5hQmZRRFk0K1pYQkdZVmxKYlFmWVJQalllaWFWSitmSEJr?=
 =?utf-8?B?b0x5VjRVZDViWVZqUzN2ekVWM2haeTliTVBoQTRxS1JwSlQ5Y2E4OGJXbCt6?=
 =?utf-8?B?dTlWV2xLQndpSGcxUWlRcFA4QjNYMk40L1BqdU9vK2FxaDVyYmV6ZlV4OWUr?=
 =?utf-8?B?TkJPVHgzeUhjSzlWVXFBZ0oxRFU4K3FidzlUb2UxME9yWkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 10:23:15.3504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e44c5a25-92d4-48bf-6428-08dcfcbab1b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7596

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

Changes from V0:
https://lore.kernel.org/kvm/20241101102518.1bf2c6e6.alex.williamson@redhat.com/T/

Vfio:
Patch #5:
- Enhance the commit log to provide a clearer explanation of P2P
  behavior over Virtio devices, as discussed on the mailing list.
Patch #6:
- Implement the rate limiter mechanism as part of the PRE_COPY state,
  following Alex’s suggestion.
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

 drivers/vfio/pci/virtio/Kconfig     |    4 +-
 drivers/vfio/pci/virtio/Makefile    |    3 +-
 drivers/vfio/pci/virtio/common.h    |  127 +++
 drivers/vfio/pci/virtio/legacy_io.c |  420 +++++++++
 drivers/vfio/pci/virtio/main.c      |  500 ++--------
 drivers/vfio/pci/virtio/migrate.c   | 1336 +++++++++++++++++++++++++++
 drivers/virtio/virtio_pci_common.h  |   19 +-
 drivers/virtio/virtio_pci_modern.c  |  457 ++++++++-
 include/linux/virtio.h              |    1 +
 include/linux/virtio_pci_admin.h    |   11 +
 include/uapi/linux/virtio_pci.h     |  131 +++
 11 files changed, 2594 insertions(+), 415 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/common.h
 create mode 100644 drivers/vfio/pci/virtio/legacy_io.c
 create mode 100644 drivers/vfio/pci/virtio/migrate.c

-- 
2.27.0


