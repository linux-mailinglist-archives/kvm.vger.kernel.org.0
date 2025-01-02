Return-Path: <kvm+bounces-34499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9999FFED5
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 19:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D36018839F9
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 18:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA133185B48;
	Thu,  2 Jan 2025 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZzK4ks9h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF424431
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735843845; cv=fail; b=KrwAe410AApweO7LMW57AHhtvRGhRBbGN9UqB4K/icqAxj7OoAKaql4Ri+YC2H9SVoaLsIj5y4o4OxAILbvZeb/HJdx2wWt+UIEBwGBpC9V4Rs1peUJVXhfYKXsuGzKkQljtlRF/qnO6CUwk7kbNfUurWq/jSjSh+YrQEPFvhCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735843845; c=relaxed/simple;
	bh=C1r17jMzEbDwxV9E1QcVnIrlvLvBbij/lySD1diLsQ8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZWVRIUVMmsb/mVHXad0u6fwsxjyMaO9jaxc8qvuKfBzu26hkyRNvgmRrMRGhqo4ntu2s+N2zops3iGt/vu6HcPneX2bxG1oOjNW2kAIDdN0rW279oVwgazKmr0u9VgwYQTvYcyP1AVudUczRXQIJOMa51QvredaKb/6CYHcLHz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZzK4ks9h; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qNdk5dg0m3qTiKPSIOR7mUQk6QxOnDtFUf6F8LYFE4LPljZJAxyaQC4eZHLNNNbxnPZ0K4563g69Y01Pfa4UPjLiA0nxji9l8m4Qq7VliwRv1GHQviDqyctENLZ2A14qGAendsF3UBj2Xd363FOA6+NE4PiB59m+Sun7uxeFdvlZGD+6roAkVtqhbqQSfLnKLEzbdZpTSkxTUqE/fTeRZ7wQ2cMDpUqrtRsVxsASNNRZHXyxkS34vh86C8sjxLpEyDO3Iti2ERv60nwATyF21XDvBfqrfDfLEW+s/3jJxWwH9PLJkRDNpd59bcjSD0yffCAciV5n4twoLf2yf1ekNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxvK8Zk3eGkbYAHEuJmzuzNfZlKFdovoRhh/zO4aEZI=;
 b=Zj08MLVyXU0jYqKjYyy9HpEj79MukO9AzLPCVOitUyBLCbxEkJrNMqFH9dPQfdQtc3WS4vLGvM0LzPuAzoQ/y/UML3+4mUtflXz/igZ55vS0g++wKhxc0L0R7G2G0M+EepNYKt4/EumsH9gExIDD/jRFYOjieRDUZ6bba8GKd7j0dxtCuFDvWaVIqDqfkpbpcC8J6I/4jppxAP2rfsWHRzIMVccTEgzt5b1Wb0UNoUQL9PgvwIktCxnu5dKG3ypEfqG03/o3O4ZA3UFH4eLfwIqfXaaZBff9QD+hgRzEH1JY8sagufypRL4+a3E4UtfCynJfss0rDkD+AqF5CpDjUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxvK8Zk3eGkbYAHEuJmzuzNfZlKFdovoRhh/zO4aEZI=;
 b=ZzK4ks9h2aVoOKUgdLE33bv7b9FoqWRCImKkhunYIjHQRne2Tb8Q01YeW84wLisam+2eC0rWF5KQw3EcM3ELw64nAPUCHipcHc1P0/ExQA0AD+ZtzZrXjJCxzJ17Pww5CHOArVb6/MM7pDpAikpXg5ar+kvLtZRp3bj1CLueGCs=
Received: from CH0PR03CA0330.namprd03.prod.outlook.com (2603:10b6:610:118::22)
 by DM4PR12MB6352.namprd12.prod.outlook.com (2603:10b6:8:a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 18:50:35 +0000
Received: from CH2PEPF00000146.namprd02.prod.outlook.com
 (2603:10b6:610:118:cafe::c1) by CH0PR03CA0330.outlook.office365.com
 (2603:10b6:610:118::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Thu,
 2 Jan 2025 18:50:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000146.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8314.11 via Frontend Transport; Thu, 2 Jan 2025 18:50:34 +0000
Received: from MKM-L10-YUNXIA9.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 2 Jan
 2025 12:50:33 -0600
From: Yunxiang Li <Yunxiang.Li@amd.com>
To: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>
CC: <kevin.tian@intel.com>, <yishaih@nvidia.com>, <ankita@nvidia.com>,
	<jgg@ziepe.ca>, Yunxiang Li <Yunxiang.Li@amd.com>
Subject: [PATCH v2 0/2] Use setup ROM as fallback for ROM bar
Date: Thu, 2 Jan 2025 13:50:11 -0500
Message-ID: <20250102185013.15082-1-Yunxiang.Li@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000146:EE_|DM4PR12MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: 17a79f25-958b-4679-8df7-08dd2b5e5758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iSBgkckyzpd3j3mae00f/tlaWb8Ay8pFrmtBFsmvE3ZZKkT5dzNLfpa0NJ6I?=
 =?us-ascii?Q?y4K61hQB8+HlS/Za477fmV9fRxU/5Kfo8/SfenUGEkxyWX7OgVwd3TMH7Qn/?=
 =?us-ascii?Q?4Ha3prjiGbIl8dn+a3axuSJ04kRjPaOOvBrCpD9LNySBJLugzlJAt6/sfX/U?=
 =?us-ascii?Q?+39lktUpc5MZcX45zsxLQ12kDIqFw+0OFRSNVwVaEzN0YlwlSdyLdhTpq21y?=
 =?us-ascii?Q?lR7zXUWT2jQXGNxNVEBsD2vAx1efibzKTfb/jxmpJavp/Vq+zLcRJ0bLOq05?=
 =?us-ascii?Q?B20hywUVufFbrcyfYFMAh98jtGaRAgz7MoXcl8/GzWh1fAK3rY6vC+KM5hnB?=
 =?us-ascii?Q?YnbA3vRLnVdFQLB1z1hC24sUA4PhkRSph2EAAkIhJUuN1AUC9kZ/rJweHqkX?=
 =?us-ascii?Q?bbu/GKJa5VcaYcNbNPfZZW97TDVj0kq6QzE1cZjXWbrKT92nxbwfGQYBkYHw?=
 =?us-ascii?Q?4/3IeYhvGXI/CG1Z3q96ZkBucRY9Tge+P/02PKlQ+fXyoNwRZ+pNsqXUBbKE?=
 =?us-ascii?Q?CalyHcOcYEKAauxpx5CuLnq10wBcRFmia88ifEvMo0eU6J76m1dmh7Yg3Lye?=
 =?us-ascii?Q?2mRPFrvDa4RE4ukhlOi2zXVr+t43X3XKKy8OVc5erPw8uGzPR5RWNwUrcWO4?=
 =?us-ascii?Q?qel3rtolz7RfBjuWHAqoZmr2SC83vyTmGilgOlQUWWRdRNYaUtEreADYpZ2F?=
 =?us-ascii?Q?EImYengELR5r0PMjqZJHh4p2Sx5RbA5aGRdUX6Gxp2e+EE+tixyDNOP1nA9f?=
 =?us-ascii?Q?G8xRmjp5IuRKMvNcbEC4qBhnLFJYkFYdvUKbI7KxJ08gFuwZrABZSdSHhbWg?=
 =?us-ascii?Q?jE2ReTOf7dd9lHz7I6Gd2L9k5ojCJdnyQoWxObfO3bT9wEZM6Ox7+I7QUPO2?=
 =?us-ascii?Q?EIzN4xaZiL23zIV5cUVgvRfsUBK5dqtlmv7oaCa980u9wVWCFWXFaWJtRt+G?=
 =?us-ascii?Q?bn9rpzzefjnpx3IoBwXmEwYWGMFcagGIHQeXLKB4WrXOJXDYcqJVPmECxX4q?=
 =?us-ascii?Q?Q0tVx4rxV60cd/Q7kr/FqgilWCCL+fGFVEl9YbAfHupEQ1E6tN0yr5yp6vtP?=
 =?us-ascii?Q?0VglMSNZsJPwGL2vWSRJVX7MApPn7kAuZk9ECU+n2Y7yHjdsp1PAWWDdk9If?=
 =?us-ascii?Q?Oe6drRpanc+y8ASS4VZAve5tAFx2cTNi4lxGD4ecByaN3iOiEZ1E9V+//ZX2?=
 =?us-ascii?Q?UkNT99sSTRjTrGgev2Vfmc2kBRYHDQvmqrY49Bkgd1llg2WrIybQfBg6bX4u?=
 =?us-ascii?Q?51d7FAKZZusPKLpmZEusOfwW0pN7QDaVL1eOdwvXvBYpreCvBPSE+Zvx02pQ?=
 =?us-ascii?Q?yu4OElyS2qYhDA/XuJ3Qf5fbAQMO8YIwczA9ul/Brjti5k3zA176yjHYi7iE?=
 =?us-ascii?Q?UXp2MefHcBASv/EfiXVacoG0s4AyEOD3BXhZYpv3YM1B7gLQ+DUz1nl27mQ9?=
 =?us-ascii?Q?rSaECmgaluFP1jcwWCy/1SuqWl+fkxJ08u2huDcqWdRzaNw98t8vgl5mJS5A?=
 =?us-ascii?Q?yeWLGzjl2aZsHeM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:50:34.8038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a79f25-958b-4679-8df7-08dd2b5e5758
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000146.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6352

On some servers the upstream bridge does not have enough address window
for the ROM bar, currently this will result in the vdev not having a ROM
bar and this causes issues if ROM content is needed by the guest driver.

On x86 the device's ROM may be passed via setup data to pdev->rom, so it
can be used as a fallback. However, it can't be exposed transparently as
a PCI resource like the shadow ROM, because it is not aligned to power
of two boundaries. So special handling need to be added in vfio to make
use of this data just like in the GPU drivers.

Yunxiang Li (2):
  vfio/pci: Remove shadow ROM specific code paths
  vfio/pci: Expose setup ROM at ROM bar when needed

 drivers/vfio/pci/vfio_pci_config.c |  8 +++---
 drivers/vfio/pci/vfio_pci_core.c   | 40 ++++++++++++++----------------
 drivers/vfio/pci/vfio_pci_rdwr.c   | 25 ++++++++++++-------
 3 files changed, 38 insertions(+), 35 deletions(-)

-- 
2.47.0


