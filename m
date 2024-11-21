Return-Path: <kvm+bounces-32266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B81239D4E37
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 15:01:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78130280D59
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 14:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4D81D86CB;
	Thu, 21 Nov 2024 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LcYN2/fY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0C64C66
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 14:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732197678; cv=fail; b=EflFjYqEaQjtaLEvCezb4OgIns45gMMR/ek8yV/qut6JitSeZ7iaccDoEOreau+Ks3oyWkej3TR0sUYiuir91CW4THtyGtZetm3sIU6IBZ0VFU/feRhWMNdWq1lpPUVAriY8UzZoejxB+S0pbrrmZBukKh4GBbZPgd/I87S/AaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732197678; c=relaxed/simple;
	bh=QdjUCG5rJI+E0Wckd78pjdJe1Thtn5bAXfSCLN/EJfM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mm1JKIQk+mS4lAHLuZzcM55fJWXqOa/YrXt89V7BPVgc/9lrE8+7MLyiSV2y7cdu4RWeii6PBf2e1fPZK4/mQ0OAVE88kvsUnh6z+Tu+8WE8y46jVYUURQ3wCEDmL3Bh599A9Hj+cfMHSLpGK3lPIXFeLAxC6POefi7EBoj9qkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LcYN2/fY; arc=fail smtp.client-ip=40.107.101.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WdXXUEx1elgXNdK60RgDqCsaEy+eGA/L/1lNw8vHiCR5eZdyNoLyrRKOrw8+AMeGEl/jT2q/um6C6YnQL0t09zxMsBV/EKoK+jNhTLAZv3jXXnWpF6mSIB8LWY6BPe4gM/Az5jO/pDM6Tg2JyilGiGCgBQefEP6pfKjfosGZHFSEPUeM8EiVY72aXhyLqajsRNBKGlRLTXdnE5zwRJddl/BW4/lD1r7MhCQr4D9/KT4e8kSs7ORuUBzzE3k5+Xwk+r+hqq0BCygpcAkTmkPK+qe397SJ3aAokWeHf6ZK52Jnjv849kwB8WHDR1R2NriY0TpSwC6519As0zxFxUY+0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEyndTrUulFF3bs0T4nJlL75rAczFrTPAZl5rVyBnuk=;
 b=Q2u7BtGNVradbPgS8BwS2+iONU6O38bY2sYBhrYcSdqWMJlnqwO0ex9oyA16zPqlNEVl7ZH1xLNBTnabZM4vZV5HJLu29xiB+LwRf1QpQSza+R9a8a9gi01/JSperedNBHS6GdA4K9gzaU0XIV55J1Eu/uaCH47iyJGVlHtEUOuvEgYOpEtItFur9oElAr/qe66tTDou1uqHgBJIftETo0dnsz+CE9zMcUhEfE7eWlWSixMFmrUo80Gt4AvWvxixupwbrc0vJBlHT6l78VEQY+sOXjZoQD6I7mNuGi1B7Ft1KOAduOJvw70rayxWGo0YIh5USznvKLCm7sgBsSTl4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEyndTrUulFF3bs0T4nJlL75rAczFrTPAZl5rVyBnuk=;
 b=LcYN2/fY42PZ4ep0KSzZWrSK3pi74zIn76HhzxdUSdDdxKUAGVN//J89z3pqrlIBkInmeaRH+7PPkTI7BaLCruaTLCa6o/FPQ96cr15t+onI+0Bs+FZtTV0EiWmmOvsxFlRjMKoW0EfkD6EZZLLSxAWGtX8zkMkmxOMv5SUNRYd5Z+LiEMeOPco82OPoJjfW9CyoB5+Ws+gbJaRzECl5oDDEV/MTeuTGo0NxW/kfdXmhla0orkr8A3xHbmsps1cNyyTM/hSmlydA3H6wi4LhfIPE50VSnAooOVpkwdKT2GeGCR+eFPIN5n5Q4FKRzgHbwz0UPUzQrZSiB/SQvP/YHA==
Received: from CH2PR10CA0018.namprd10.prod.outlook.com (2603:10b6:610:4c::28)
 by DS7PR12MB8083.namprd12.prod.outlook.com (2603:10b6:8:e4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Thu, 21 Nov
 2024 14:01:12 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:4c:cafe::bd) by CH2PR10CA0018.outlook.office365.com
 (2603:10b6:610:4c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15 via Frontend
 Transport; Thu, 21 Nov 2024 14:01:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.16 via Frontend Transport; Thu, 21 Nov 2024 14:01:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 21 Nov
 2024 06:01:00 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 21 Nov
 2024 06:01:00 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Thu, 21 Nov
 2024 06:00:58 -0800
From: Avihai Horon <avihaih@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe
	<jgg@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>, Avihai Horon
	<avihaih@nvidia.com>
Subject: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended capability
Date: Thu, 21 Nov 2024 16:00:57 +0200
Message-ID: <20241121140057.25157-1-avihaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|DS7PR12MB8083:EE_
X-MS-Office365-Filtering-Correlation-Id: 843b7e1a-7598-4173-827e-08dd0a34f4f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KU5FmCWWvQ+XYWgdXzRQXy3+V1Eo7ubi3wWwfdYAv9xLpcTKGYCabdLd4hpP?=
 =?us-ascii?Q?3yRsZC4AuD6z32Cvo8HncWMrMtqVcoJHLFk3urrvOHHIwh5l6Dy/exuKEYLV?=
 =?us-ascii?Q?2zgedw3//r9u9VBveYRdMm/501amzjWwHo81nOcuxW0Adqvqgu2T2kdTajhk?=
 =?us-ascii?Q?k/aphMS89drRSXDor/mIkV54PKTVzSq4ALpVEfPzKsPRja8WzzTLow+qaGTN?=
 =?us-ascii?Q?I41cC447VsiKDsPpQl2G6WWB7HMCPoBk6Sai8mYu2E9IvoWtqFw1UAHuiIuS?=
 =?us-ascii?Q?ii1MaTPEy5N6NQSW7U90RKFp0ORSoeFTixrMAFmJfU4/rkpfgm2SAfwCPUFU?=
 =?us-ascii?Q?L+hBE2lSdlQxTtu6WEK1Fa2SKIW+2zLjOmKXlPZeOi4r9I0a0QtD7n9h9uIg?=
 =?us-ascii?Q?o/WqaVl6Nn8s/6OWWTdKbx/5eyW1t/khGePYVZ0JO3O+zXaLmlEXSGuvL9Bc?=
 =?us-ascii?Q?BhwZ5kdrCq6XD4zHVh9DBh3UajpFqGa1TVF7qZzsLo3P2TBB2VVA5HQB76jk?=
 =?us-ascii?Q?TctJb3nVl5sIbaGMu7/V1bc7XcSvcq8WAfj4bSisCPHrDn2MAFho6xWxGYnv?=
 =?us-ascii?Q?WVhnub/f1JL880jrMGNlHW0AgqxLhZHcQe6EYIlmInnuE4nojXCBX4GGIK67?=
 =?us-ascii?Q?xXoatll6aHRg9xIYrSUcQcq/ylLqDWTBxmsPO2a/FDh4nKpEmMRtsf4vYJNT?=
 =?us-ascii?Q?Kb3BIlQRDwW54IjKF6EHjIXK+KYMQOENADE14fXKT6IkJLQhXgkhQUnJWOeB?=
 =?us-ascii?Q?GjCkL+V9v7Ieo3S8SnAa3ahlY8rWCk1oZL/mlTS5z57mDgUZj2E1xAUyuS0c?=
 =?us-ascii?Q?Hpkfou4e3zmdgOqAZX3qereglco5QJZP5E/JExZgfl1io2SZJVUAY5BTAadp?=
 =?us-ascii?Q?QNo6cJjSQ33tKKUzNhpMaQO+frZ7+EHI1qwiOodYXCRJcQd7WCxF+OAtuMWa?=
 =?us-ascii?Q?y7URCRSlTewlHwpO48Mt+APg0DlvMNCUoN3rXjGTxqrvgID+b7bllw1u6D2Z?=
 =?us-ascii?Q?/nmIKIAjMzQeWfNsyC1JHhKRC1BYr/uUAQeBD+qWVVdsGNUnm1irnAwsGe/+?=
 =?us-ascii?Q?z6NZhKda4opTCjuAZKzLlJCMrrAtFwzpYW5R8v3eMVb6rmt9+R8DYX7isgid?=
 =?us-ascii?Q?Yk9aoPKQrYa2haLdW8DN62Thftcp1WKwMwUvWS/iQibDXG60A16EST95tVg1?=
 =?us-ascii?Q?311v+Wu9boE/D+PsiDUML0FyfxVTpJR11mnVj6KVoaL2jruLHrhlJSiLmUzT?=
 =?us-ascii?Q?Er8J4YKNHV9XoxGkjbXuPK0JDf4/6iQYiSkMZiQBLWYdbZYBCw/4bgGW08wb?=
 =?us-ascii?Q?NpKjUDuCD5mTyCU3YAr0ZEEVBOsdF43T5RZnJxGqM9xA1Lq3LKaqZw6+W0IR?=
 =?us-ascii?Q?wZ5PCTdXd+jznC0ZcWvQLLZNi05UmzL2oGC0zTw+AyXylOU47A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 14:01:11.6945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 843b7e1a-7598-4173-827e-08dd0a34f4f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8083

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
properly if the capability is unknown, as struct
vfio_pci_core_device->pci_config_map is set to the capability ID during
initialization but the capability ID is not properly checked later when
used in vfio_config_do_rw(). This leads to the following warning [1] and
to an out-of-bounds access to ecap_perms array.

Fix it by checking cap_id in vfio_config_do_rw(), and if it is greater
than PCI_EXT_CAP_ID_MAX, use an alternative struct perm_bits for direct
read only access instead of the ecap_perms array.

Note that this is safe since the above is the only case where cap_id can
exceed PCI_EXT_CAP_ID_MAX (except for the special capabilities, which
are already checked before).

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
Changes from v1:
* Use Alex's suggestion to fix the bug and adapt the commit message.
---
 drivers/vfio/pci/vfio_pci_config.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 97422aafaa7b..b2a1ba66e5f1 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -313,12 +313,16 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
 	return count;
 }
 
+static const struct perm_bits direct_ro_perms = {
+	.readfn = vfio_direct_config_read,
+};
+
 /* Default capability regions to read-only, no-virtualization */
 static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
-	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
+	[0 ... PCI_CAP_ID_MAX] = direct_ro_perms
 };
 static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
-	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
+	[0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
 };
 /*
  * Default unassigned regions to raw read-write access.  Some devices
@@ -1897,9 +1901,17 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
 		cap_start = *ppos;
 	} else {
 		if (*ppos >= PCI_CFG_SPACE_SIZE) {
-			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
+			/*
+			 * We can get a cap_id that exceeds PCI_EXT_CAP_ID_MAX
+			 * if we're hiding an unknown capability at the start
+			 * of the extended capability list.  Use default, ro
+			 * access, which will virtualize the id and next values.
+			 */
+			if (cap_id > PCI_EXT_CAP_ID_MAX)
+				perm = (struct perm_bits *)&direct_ro_perms;
+			else
+				perm = &ecap_perms[cap_id];
 
-			perm = &ecap_perms[cap_id];
 			cap_start = vfio_find_cap_start(vdev, *ppos);
 		} else {
 			WARN_ON(cap_id > PCI_CAP_ID_MAX);
-- 
2.40.1


