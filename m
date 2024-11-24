Return-Path: <kvm+bounces-32397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A07F9D753C
	for <lists+kvm@lfdr.de>; Sun, 24 Nov 2024 16:32:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CBDD166BB5
	for <lists+kvm@lfdr.de>; Sun, 24 Nov 2024 15:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A371718C900;
	Sun, 24 Nov 2024 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M6m5m6c5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B16166F29
	for <kvm@vger.kernel.org>; Sun, 24 Nov 2024 14:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732458470; cv=fail; b=hTR96G4ZOR/qimRQvBAQ7PDsvuygNO35coPW5wcJ3WksT7bQo4WNfFo+OMAtal/N5t8pUAOb4cfUHBczQQzavwTBiYzStstweeVeKUj+9ReaffP8HaIbmoWKYk3FZlPlT2pVjMSK8geLTOZjkTy0hnxh1J0/KtYitRjUVABDtog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732458470; c=relaxed/simple;
	bh=g4ThNKFnW1JcBQ5OvpoK1JNORWILFxO6UlHOVmhOZOg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JflzbMDjLZhvmmz8wV8AhwLUFC/KzFyNqR0PJ02bll1dXykkP0miCy/wTjKawCIrKkdeO8ip91dA1OWWxSy+X3HhzXviWFqYlP9Aub/SZDI72muymDPIKaCAkdJtTkITIYU8Tb+51Mtz5QaztDWv/yZ8Th8k0AI1KeLfgWuB45Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M6m5m6c5; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HXLaUNQuKK7YyqkwFw6tpHLMkTUWYXfmt/Z1qmOkbtQgizPzMHl4e3c7K3Z8W6sbU2eFuWg6TDhWzQr0h5auzxOiRUFcb4qX6n2GGZXQo1rDTV/f58HFuxT+NXUjSlLDrTV72FJQOCJe43SFpqPGZk60IQ4DUACEHxBUqq4ocPytHfhZlRI4/yT1/nzlNV5cnS8PHlvq3JAmHFPgFqcvl2obfL4YJXIjhBQELMHd2Sx3qx979arBoTawwY13u0eJofbLNDzby2FfUaPCk60hjBRq0kNYwTpce+LWmJRLOHSqLyAd1SuOPeKom+/qZr1rakbqlZOrfY63jse8AdeG9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7sPeC8jGd3Rkm7ywPYbVSNyEBPY8ITH5rxwNeLN9Po=;
 b=kV0HQqeKBhVKP5b5y5KxzvFY6NDjHuc6AnzZ9WNiseVelY8f7f8AcTeIzwHcnkHjPaAFxS0oqhfcfiXtZLfuR8XnioEt1K6welE4ubnkYr0gNn+xZpWKSXj7oYXa41a59oRRFfH6Fz7yFhT50bw9fXf5pM+L0++Ks71bWHm/MbPKCNOfVwomwK+me2HjvgXEU+7GGG3yoHK8zImkXRxMJnJWc/faacJbtmS94tLkchroLgOAPWT/sXAA6QqsS1EV0M8Jga0FOvRkXgWAYrUbxjY0Nq+Eech+ninW0m/gAqJS3sO6AYv1qS6rUf5dwH/glrjDoyhd4Ntw6e7DpLL9Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7sPeC8jGd3Rkm7ywPYbVSNyEBPY8ITH5rxwNeLN9Po=;
 b=M6m5m6c5TQ4cev/q7EAgdX5oy4+9I09Fv96iQf78jzLmdMYJ6MtyzPPj4sWSOQKGCrYOrNKRxL3DsYXtBtaVpxXm12hrku3AytOUdDWF+IL1wJ0mLunP45HAi8UkCCrJXa6v6Fphwq9VpmnIzkK/kvmc/u2lRQ/mFWCpAL4/eec4UTOD8UPcnQWEm/ejFtCwopavXckZnIKZMsIhYM6NFoQ9ehwS0qGRnU2NjhRu9/PeGRxEjNvV/z5PacfVsh86t3809W17ww01oSy3hsJcetPlZ2T2GYkYuxTILes+XPp+D/kyppGulD+xfcXbOEOaQYrmWIJhRs7w2mq1tyKGug==
Received: from CH0P221CA0039.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::21)
 by SA1PR12MB8841.namprd12.prod.outlook.com (2603:10b6:806:376::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Sun, 24 Nov
 2024 14:27:43 +0000
Received: from CH2PEPF0000009C.namprd02.prod.outlook.com
 (2603:10b6:610:11d:cafe::ed) by CH0P221CA0039.outlook.office365.com
 (2603:10b6:610:11d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24 via Frontend
 Transport; Sun, 24 Nov 2024 14:27:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF0000009C.mail.protection.outlook.com (10.167.244.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.16 via Frontend Transport; Sun, 24 Nov 2024 14:27:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 24 Nov
 2024 06:27:42 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 24 Nov 2024 06:27:42 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 24 Nov
 2024 06:27:40 -0800
From: Avihai Horon <avihaih@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, Yi Liu <yi.l.liu@intel.com>, Yishai Hadas
	<yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Maor Gottlieb
	<maorg@nvidia.com>, Avihai Horon <avihaih@nvidia.com>
Subject: [PATCH v3] vfio/pci: Properly hide first-in-list PCIe extended capability
Date: Sun, 24 Nov 2024 16:27:39 +0200
Message-ID: <20241124142739.21698-1-avihaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009C:EE_|SA1PR12MB8841:EE_
X-MS-Office365-Filtering-Correlation-Id: a4445766-9910-41bf-63af-08dd0c9428c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c0+kZQ3FcmVModPSsgFg1ob+farrhysNTZBaUzRupEFBtzjj/VedYHGeFx6d?=
 =?us-ascii?Q?y+KSN2SYBi23h1+0lozJxhk40BgcI1FVk+Ekb93oDU7r6YixdxsDI5vOL8Mp?=
 =?us-ascii?Q?speW0SBhU9yl9vAkoUJn5LjDjIqGBxkmUQdixh1U5nL6/pzLp1+NUEfiP4Ms?=
 =?us-ascii?Q?SI2cjxkYB2t3Y5T3EqZwDqTJJD7TW7Set2HiI3u9nsu1lAxyOINoQmoXbBBF?=
 =?us-ascii?Q?i95Kl8ovWBNXfWTe5MHH/7Vzk4oqA+9PScOczEkcDyyc7WG2b4AH/BpGAgWN?=
 =?us-ascii?Q?WpXOYMvXDuhbYR02MQno/1pXfpxUsli4jto37YhAl3lJAYR+bVJLQroXNUO8?=
 =?us-ascii?Q?/5bDiBoT6TBd9n8nVG0K3lbO+FWcEnhw6lJwio52EUoKbzCAYFmrQhCJzN7Y?=
 =?us-ascii?Q?fJ3jPsbfPJW2BZShcgE1ZDuBGQKm3XLtfSkqOu0bHUxNYVjp7WFFPyYcLhId?=
 =?us-ascii?Q?mlb2sP00hyyUMMhUjEvui9lS7Yqb0F70GJbVfWuscljI5JzOTGsUpRAlfa80?=
 =?us-ascii?Q?oOTZWDMIsZzpnhYL/H+vkvhrTXUw+aFnxraUqItcdrS/SKiwY9NSzYAoMAlR?=
 =?us-ascii?Q?BWqZA5XWM5ScB0Ewdytg3wPSG8eNkmtNlkdO8JFJJ4FcTHL0FVwTGYlHwj0q?=
 =?us-ascii?Q?RlV2s1npqqne1iklkiZq9N2J6z7tC/I+e3j7tS+5DILbaMsLmFTDea6iHMVz?=
 =?us-ascii?Q?uEaP+3iSIbJIIrRmC7wZkjmPjWknYK1ByzVjzz1wfJzWwYpvPfFXqZCUhtqe?=
 =?us-ascii?Q?IJ9t9Hz7zbUlZfKD9+YivuKBqYSZ2xiVEXx5GhdaW2GlEeTCSLtyXynpjz5G?=
 =?us-ascii?Q?s0r3wyhXg2+r3rDVtjBl+BtdHXjVNcTMwy/rcGwfiWMXwfIkUpRjz+/LxVyg?=
 =?us-ascii?Q?m0QBRv+elSunp9ZVZn8nFYQ0EQNAuudUiNYgYUyM27J5sqzGwOapNn3ed7Z1?=
 =?us-ascii?Q?E1ACO6mmM2ES9iJk1EQA0lZ/nKTamvFjL2LxBJBVSXoQ6apBF0QA9r37qLZ+?=
 =?us-ascii?Q?vKFDbwudK2tCBPNd81jOu9ktX6iLgH3ABet++Jm1mv/5T/vXO/LwSh/IAqSx?=
 =?us-ascii?Q?xaEqn63OHyTxFiN/gNHj6Y4+5M0CJT5Ouz6u1SfbsGOlQzF79pFeA2cgc6dJ?=
 =?us-ascii?Q?IA6KyS/5C0DPxWtsu3RTKqF4opV6QJ8gSBpNR0kxVpw2UBMZEiNTXsNCoZkV?=
 =?us-ascii?Q?eBq8GEpETT3rBoAAnkSInYbEwKwPXohoc2Xl2qX+O4Ezk7H8nTrPo/zMUGqC?=
 =?us-ascii?Q?E8P20bMX31c6yHZOvOcUA4QRox0gzIddve18mpZUlCmbNzzPsk9UFXKn7D+n?=
 =?us-ascii?Q?JQ1mG8rOkQxlymnKfEXR9sopwpUZUjTRfkgp2ouBstEaLlrMyz36zc7H+Scv?=
 =?us-ascii?Q?G3fQ75wkNJvQX1dok9FMw4j9URVD9FL73+H9beiRY9gPHY9vHzdccnSyZwBp?=
 =?us-ascii?Q?kq/93TAhzLbVgc+TqwaZgcp1u+9+K1/J?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2024 14:27:43.3593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4445766-9910-41bf-63af-08dd0c9428c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8841

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
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
---
Changes from v2:
* Fix clang compilation error reported by kernel test robot.
* Drop const qualifier of direct_ro_perms to avoid casting in
  vfio_config_do_rw and to be aligned with other perms declaration.
* Add Yi's R-b/T-b tags.

Changes from v1:
* Use Alex's suggestion to fix the bug and adapt the commit message.
---
 drivers/vfio/pci/vfio_pci_config.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 97422aafaa7b..ea2745c1ac5e 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -313,6 +313,10 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
 	return count;
 }
 
+static struct perm_bits direct_ro_perms = {
+	.readfn = vfio_direct_config_read,
+};
+
 /* Default capability regions to read-only, no-virtualization */
 static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
 	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
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
+				perm = &direct_ro_perms;
+			else
+				perm = &ecap_perms[cap_id];
 
-			perm = &ecap_perms[cap_id];
 			cap_start = vfio_find_cap_start(vdev, *ppos);
 		} else {
 			WARN_ON(cap_id > PCI_CAP_ID_MAX);
-- 
2.40.1


