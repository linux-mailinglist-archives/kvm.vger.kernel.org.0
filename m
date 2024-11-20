Return-Path: <kvm+bounces-32163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C8719D3DB9
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50FF3284A09
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB321AB6CD;
	Wed, 20 Nov 2024 14:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I/myns9o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080E719F424
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 14:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732113538; cv=fail; b=rh/x0tKNMGBCC1Rphaan6fhnPNouKWpPHW+bMdjTo+BrLWdUkZ3i3iPS8pPdlV9eVBS/kWGDTSVGGnVvVPqsa7y29TvIEu/54T9fXo0WrYt6RwafOL/p8mSRIVJ6bfBuaXXKM5scCBjz+A9aF+d0NzwC5I9V13/8CFDon8g6Iy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732113538; c=relaxed/simple;
	bh=8SNau7ZjhgIuiVbeUdGQ7P80hiE2e1NFH8cqdUEwGj8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a9z8gEY0GggNcOoBj3YTVtd1yN6rND0xLiUnBTEeRvODm6F46+cQdH6N2+SV9eMG6djxYfKL+5LgY1jf44Jq2XMQZT5dT5AyctHa4IgzO4yjOpztr5KAgU7M3dmTwdDHhndVwayrrEc1ufAREQ3iTRS1DMhLiGNA59V140KoQTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I/myns9o; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJLlKq/mdLes4dc+JwJelEFXzSCndTs7TC7BzfJBr/O9ZW9VMuN1LGO2nwhwHkfmyjIUZljxKsehww7vEcK1EEvFGmqYbesSMZF81EI8w28WvaOlqkgZZKGoosZ/SVhD1JoCKBsZnIvZTtKgcvEaqfwdBjWTKYRLpg5V0cqnMktzIbSOQI4BF9YCkPRLzqxK6xDKmfv7LaBzENV/NTdsMXt7xJy7xkmeFTs1jtEOMizchCuy7euvOpxmH+hRYD9uDQVZTBQn4Kupeexy3Wbe3hBj2bG7RU4pLVFMUFCO9lYOgavflk8x2Bx3rlG6rKGW2M7e+5ORK1BJJ24/KzGLuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZanLZJSg1vNTakdUDyazLicG7MncEb2+IfUVNaZFIKs=;
 b=SbnaRg8Y6gU7Ks+nWUlI8Ej3oVVbPdo6SdxPGKGC1nrH7I2dskWL2YSWbFzEDj16glimcw+uD3X7/kJedmgyV+F5g64CrkzjF5HfjdU1jTul5sHwbztXpwXXRFFHrKFBJmErDdvtdPwuHq+5Lmn0Dr3+Rmj5CLcexVsArS2MfSrmtnp8/SWJmTlbX/w6EkNLWLsEosH2/125TiuZaw7oFeGYsYyX7gxnS/VGQeRwpcN2TJ13Qugzy8XGfFrZbzfSR4abQ2PcdDwPtpXwN/4St+yleFjjXIAU1B64lji8OU3h/0BR4gzC0mpknc2Ankwighc14DPR7W9DKbOj/9d7xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZanLZJSg1vNTakdUDyazLicG7MncEb2+IfUVNaZFIKs=;
 b=I/myns9o5fyDHzbvZfeRrfWKtDdWkXgseMYWfXQDyP9b1dONgiTFYUIHYACVgy2nem1mT3izk3zNg70FVxtwyKRFUx2CHtthFFDFByLjju4G7PMBCCcDF+ggTvTCJG7cEWBKs2ULJORgoky2TzOJLfNfGUAYcuiJ28iN/SKENP4vef438DDbv3peIp9b3hWCsp26VIpAJr1Q+TcpOW5UupyuPQEXjE9UP4VkF7NV3H7o4xirL8qZZK8/SIYeDM/DHpvWwEVi9PFdXHlsIFTHbW0gSsjLT6aCjXVuKoK0woPPFy78fHU2xD0Exm7OPS9h6OzAmbcakdeWTfVv/Bmptg==
Received: from SJ0PR03CA0165.namprd03.prod.outlook.com (2603:10b6:a03:338::20)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15; Wed, 20 Nov
 2024 14:38:50 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:a03:338:cafe::87) by SJ0PR03CA0165.outlook.office365.com
 (2603:10b6:a03:338::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24 via Frontend
 Transport; Wed, 20 Nov 2024 14:38:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.16 via Frontend Transport; Wed, 20 Nov 2024 14:38:49 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 20 Nov
 2024 06:38:28 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 20 Nov
 2024 06:38:28 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Wed, 20 Nov
 2024 06:38:26 -0800
From: Avihai Horon <avihaih@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe
	<jgg@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>, Avihai Horon
	<avihaih@nvidia.com>
Subject: [PATCH] vfio/pci: Properly hide first-in-list PCIe extended capability
Date: Wed, 20 Nov 2024 16:38:26 +0200
Message-ID: <20241120143826.17856-1-avihaih@nvidia.com>
X-Mailer: git-send-email 2.21.3
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|DM6PR12MB4267:EE_
X-MS-Office365-Filtering-Correlation-Id: 032195fb-9cab-4522-d053-08dd09710c3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FPbR0SJEJwNl61MJ9hwwYKy17FwY2ZPOkp72xN0BPKiwFATC8pFpbYBhk0Q6?=
 =?us-ascii?Q?DeUo60W/0qaxMHwqWgY8am6FFk4mKw9nrkpQS9EPxlc8tjiL66jppoHefM5u?=
 =?us-ascii?Q?hjWxMP1Afss+NNH5dStreOUhMIdpDiC5Bdiu7Q2UEbfJ7+NjVZkC3/D3ThFw?=
 =?us-ascii?Q?yR6HDN+X+Rcf1BWkrUyLwN6D6j/OArKNBwDPCLTPbxLsG/SLdw0A19vWVf+V?=
 =?us-ascii?Q?o6y0QZr2Svqp++MGQwq/85k9qyeVAD4K/Skw2Ku6w5rI4HO/UHHUY3JfsInW?=
 =?us-ascii?Q?ZAellKvwQP/vUvXkFRV2PZKZDPx3nQ0PQyGtiI3J2CtjEEcHhEXN0DFRz0en?=
 =?us-ascii?Q?mHTnwStKaiWJZ05DKOJvMtn/N4GEVCRgqsqIbUGpNOG2v1W9y5i82AZTApkC?=
 =?us-ascii?Q?SBuuGEN2HJLH4k+PqqFIheRkKeT3rrR8VRGiJpvXsryDwSM8fyg11xFaRmD6?=
 =?us-ascii?Q?HGpiDI4XZkVO94Awej4GDfbxpIK/BAdUcdXX+hUwOL+IuPK8bvq/1NtxRcHW?=
 =?us-ascii?Q?LZLidztiSnrQifPl0f78zhAVbH35jeI3Qr8P52pd+A3YtPh+8Hd4LHTWkZrm?=
 =?us-ascii?Q?5aVHwLQFcF6dG0iolBkGDI9zfdX9+ZDdpXlMX0kyBOWwIuINYrJarYOTCIhh?=
 =?us-ascii?Q?52jzbkxS5jKxSo7F08y7gkAA+V2/of9eBg2T9XoCp5tHSkOOpIKUw5nSUKAB?=
 =?us-ascii?Q?UlT4HsBLQxk+WE2V5S4M1qWiip0Zb/EbWVcOe1kctSZKZgsihY2HtfVcHhtv?=
 =?us-ascii?Q?bfUOgcNR9F3C+aa0UurCzgUoum5D8RoO25eLx7UUxSlKsSCUgHPZ8ZT1fE/m?=
 =?us-ascii?Q?X3+Xkk8D/kLJxdWXUPzioGfk67dyafCZFW3WhhPqX3QBLDW2gskIGbJH62qg?=
 =?us-ascii?Q?nUgwAuh/Cgd+7zgPGbf3P0/PCM25FkzonV8uSoOPkaGkqx4qi8jRs4hFPW2Y?=
 =?us-ascii?Q?CoGGd4Uhrs5E+eYYvBi9N2lPw+zkvXWK5US6FOM98iyvyYYmj1RC/baKEo88?=
 =?us-ascii?Q?s0cQW6V0HbCMP7u8H3cXN1Tnu0IoQf5WgkO3LCLQq+IIPNwD3v2/RammU3Y1?=
 =?us-ascii?Q?j1N390IToM0JF+KK5EQErXCc/ir5Tq+1WwqwzUKHdcosNDAkwKhiqZYw47CT?=
 =?us-ascii?Q?/0GeM/V1+DrXM6l4PWZDlIjHj/Uz0vm4x1BPABovN6qdU8sk1+8J/4LhAEuz?=
 =?us-ascii?Q?r83zZLZNb4THIpwUxkwFkozLKoiTkRuvgrzl2twYzmlFyDO2omwuffOxcmUv?=
 =?us-ascii?Q?43B5+flw1AqZsxggAy3/R69s2HHD40FQzyDe0XPsCpmQBBog636r603dCQ09?=
 =?us-ascii?Q?XHtwQmH/zQKrGO8BifBzhtFMi5oZ01HYeBkWo+8/a7g+dfDPAGtKjPiCoGSx?=
 =?us-ascii?Q?M1MuApT2J4WAjDpBVfRG8+sb65bOViMssVjDtBSqdxL1HWjauw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 14:38:49.6207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 032195fb-9cab-4522-d053-08dd09710c3a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267

There are cases where a PCIe extended capability should be hidden from
the user. For example, an unknown capability (i.e., capability with ID
greater than PCI_EXT_CAP_ID_MAX) or a capability that is intentionally
chosen to be hidden from the user.

Hiding a capability is done by virtualizing and modifying the 'Next
Capability Offset' field of the previous capability so it points to the
capability after the one that should be hidden.

The special case where the first capability in the list should be hidden
is handled differently because there is no previous capability that can
be modified. In this case, the capability ID and version are zeroed
while leaving the next pointer intact. This hides the capability and
leaves an anchor for the rest of the capability list.

However, today, hiding the first capability in the list is not done
properly, as struct vfio_pci_core_device->pci_config_map is still set to
the capability ID. If the first capability in the list is unknown, the
following warning [1] is triggered and an out-of-bounds access to
ecap_perms array occurs when vfio_config_do_rw() later uses
pci_config_map to pick the right permissions.

Fix it by defining a new special capability PCI_CAP_ID_FIRST_HIDDEN,
that represents a hidden extended capability that is located first in
the extended capability list, and set pci_config_map to it in the above
case.

[1]

WARNING: CPU: 118 PID: 5329 at drivers/vfio/pci/vfio_pci_config.c:1900 vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
CPU: 118 UID: 0 PID: 5329 Comm: simx-qemu-syste Not tainted 6.12.0+ #1
(snip)
Call Trace:
 <TASK>
 ? show_regs+0x69/0x80
 ? __warn+0x8d/0x140
 ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
 ? report_bug+0x18f/0x1a0
 ? handle_bug+0x63/0xa0
 ? exc_invalid_op+0x19/0x70
 ? asm_exc_invalid_op+0x1b/0x20
 ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
 ? vfio_pci_config_rw+0x244/0x430 [vfio_pci_core]
 vfio_pci_rw+0x101/0x1b0 [vfio_pci_core]
 vfio_pci_core_read+0x1d/0x30 [vfio_pci_core]
 vfio_device_fops_read+0x27/0x40 [vfio]
 vfs_read+0xbd/0x340
 ? vfio_device_fops_unl_ioctl+0xbb/0x740 [vfio]
 ? __rseq_handle_notify_resume+0xa4/0x4b0
 __x64_sys_pread64+0x96/0xc0
 x64_sys_call+0x1c3d/0x20d0
 do_syscall_64+0x4d/0x120
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Signed-off-by: Avihai Horon <avihaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_priv.h   |  1 +
 drivers/vfio/pci/vfio_pci_config.c | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5e4fa69aee16..4728b8069c52 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -7,6 +7,7 @@
 /* Special capability IDs predefined access */
 #define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
 #define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
+#define PCI_CAP_ID_FIRST_HIDDEN		0xFD	/* default direct access */
 
 /* Cap maximum number of ioeventfds per device (arbitrary) */
 #define VFIO_PCI_IOEVENTFD_MAX		1000
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 97422aafaa7b..95f8a6a10166 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -320,6 +320,10 @@ static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
 static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
 	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
 };
+/* Perms for a first-in-list hidden extended capability */
+static struct perm_bits hidden_ecap_perm = {
+	.readfn = vfio_direct_config_read,
+};
 /*
  * Default unassigned regions to raw read-write access.  Some devices
  * require this to function as they hide registers between the gaps in
@@ -1582,7 +1586,7 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
 				 __func__, pos + i, map[pos + i], cap);
 		}
 
-		BUILD_BUG_ON(PCI_CAP_ID_MAX >= PCI_CAP_ID_INVALID_VIRT);
+		BUILD_BUG_ON(PCI_CAP_ID_MAX >= PCI_CAP_ID_FIRST_HIDDEN);
 
 		memset(map + pos, cap, len);
 		ret = vfio_fill_vconfig_bytes(vdev, pos, len);
@@ -1673,9 +1677,9 @@ static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
 		/*
 		 * Even though ecap is 2 bytes, we're currently a long way
 		 * from exceeding 1 byte capabilities.  If we ever make it
-		 * up to 0xFE we'll need to up this to a two-byte, byte map.
+		 * up to 0xFD we'll need to up this to a two-byte, byte map.
 		 */
-		BUILD_BUG_ON(PCI_EXT_CAP_ID_MAX >= PCI_CAP_ID_INVALID_VIRT);
+		BUILD_BUG_ON(PCI_EXT_CAP_ID_MAX >= PCI_CAP_ID_FIRST_HIDDEN);
 
 		memset(map + epos, ecap, len);
 		ret = vfio_fill_vconfig_bytes(vdev, epos, len);
@@ -1688,10 +1692,11 @@ static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
 		 * indicates to use cap id = 0, version = 0, next = 0 if
 		 * ecaps are absent, hope users check all the way to next.
 		 */
-		if (hidden)
+		if (hidden) {
 			*(__le32 *)&vdev->vconfig[epos] &=
 				cpu_to_le32((0xffcU << 20));
-		else
+			memset(map + epos, PCI_CAP_ID_FIRST_HIDDEN, len);
+		} else
 			ecaps++;
 
 		prev = (__le32 *)&vdev->vconfig[epos];
@@ -1895,6 +1900,9 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
 	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT) {
 		perm = &virt_perms;
 		cap_start = *ppos;
+	} else if (cap_id == PCI_CAP_ID_FIRST_HIDDEN) {
+		perm = &hidden_ecap_perm;
+		cap_start = PCI_CFG_SPACE_SIZE;
 	} else {
 		if (*ppos >= PCI_CFG_SPACE_SIZE) {
 			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
-- 
2.40.1


