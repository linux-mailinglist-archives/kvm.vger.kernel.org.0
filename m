Return-Path: <kvm+bounces-36955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06127A2387D
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 02:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65FF81677C0
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 01:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC7A1BF24;
	Fri, 31 Jan 2025 01:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1cM0nYLN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2058.outbound.protection.outlook.com [40.107.102.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD371DFE1;
	Fri, 31 Jan 2025 01:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738285748; cv=fail; b=ETMcLKpxxe/IlRtNhTWADHtM+zxx5/+axw59UfFeNYgojZMHClzz/gy1QUS1N3qGOOv752Wvx8AZWXeKQxs2AXOfEkah+G99d2wKUfqDyLXpHzJCy76m5w4JoDwFuuCgs6jHb0647hI29qNYgOdF0zhJLC1Dq4+T+ZD3d0pPzSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738285748; c=relaxed/simple;
	bh=A0laYhJWjA9u9p3M00mDWr7AFbZqJ9w8n3oCqICGvJE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BzPATRbJDSachNNPt7Nd7rg8fo8BdnEI0maHwLHoRTPuvLGGUdbHV/sOAMzo82HvrX2LQuZcyyQyJ71FbHo8gkSrDuUqqFONXH/8yM3JRZ5nvcq8lZZw9zCAzh4jDEAxYtysH43hP09M485N9kbd8TxIay1usSr8K41otns8kDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1cM0nYLN; arc=fail smtp.client-ip=40.107.102.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tiS1bKUUFmRW4Au/mUXYD6GJZN+Z/m5iVByD7KnK4AzAa9j62+WUaPB84X1biL+q0N2GQTSz6gXSWzJKVnx0hS6b8j1JEvxi98Tw0NEzxZYgrzooW3ppfD1BHa/itdt+q6ECkkh3TFFrPNXKQzC3RJkTwiNaGppGTwYgshf50KrVkhbtkspV0wAyeJHEsa3QMT2IHsxF/9d172mEeoyX6iBgIIyNwO+EJf6P5VL7znJv5obszVNs0x1mjx2EGnCz/ihG0HatdSLv8QKr+0U2uaPgqZyvTHcRkXXjsO9J+ygWit5RKUjlxj01WGLXJqDb7wR/nymtoDI8Chgr9BK1tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50BlS3ODR3HSgcL9ULC2VvomUPV0VAdlbI7vxiLDP6A=;
 b=XsrW95J3j0+qUNxtw0PAr/oUu5yEYl3SLvz32OA1uhb2kE+rQJvHmqsqoNCGscZEfIoT3is94QuAG+n16LtfgMshW0QaEqlldt9eCmtmkRWRM0U8RxaEE+QFUCp+e+/HTimq0tx5RGGa4RY22FVkapibV3dNODpM7VESPbR5udSiWftUDz29bGbPNIc6r4XyFq+a/N26MZHel9mN9OyOFOhPU9Pm9ChvC3+f6h9OTNqkRi18C9kBIRlfBP+tSTGOxTXPYs41tnZBiBOxLmVtpHDT9uc7zWb/Zu2aVgx0eS7k20TIIN0usIv6ZvVXn+XERVopqKA8C0dm9dCxUJFA2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50BlS3ODR3HSgcL9ULC2VvomUPV0VAdlbI7vxiLDP6A=;
 b=1cM0nYLN4gJp/cCfQ6Doe5NmrxThfPX1+JnGjzHWyKsyFM5h6OZndqstGvOHgJmThtWQ1ParABwkv4I+CcZRhHl0k69Gi8IhD7TYfSvqSX0zbrk/xSxp+7exPCzRkeQmGCnQgI0IH8eSEXO4lS2+qsoEvcfhQo7Lev9RaVPSbvU=
Received: from BN9PR03CA0107.namprd03.prod.outlook.com (2603:10b6:408:fd::22)
 by SA1PR12MB8741.namprd12.prod.outlook.com (2603:10b6:806:378::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Fri, 31 Jan
 2025 01:09:03 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:408:fd:cafe::69) by BN9PR03CA0107.outlook.office365.com
 (2603:10b6:408:fd::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Fri,
 31 Jan 2025 01:09:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 01:09:03 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 30 Jan
 2025 19:09:01 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH v2 0/4] Fix broken SNP support with KVM module built-in
Date: Fri, 31 Jan 2025 01:08:52 +0000
Message-ID: <cover.1738274758.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|SA1PR12MB8741:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b0be6d6-fd83-40a5-6586-08dd4193da0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3V0xWG2wGkLZFHbbvep+R/GOZcPmRilTBIJJFH+rFura6F19yT09vcXO5KfD?=
 =?us-ascii?Q?gt7JTWQZIbZCHnhNa7BtPciX/OTh+gwbFbp66sfpyoK863WmR+r2Z9ZkrZgX?=
 =?us-ascii?Q?vQhyZyfDLzxI/OcnDaRzr3SP5+wC9sU+zq4+6e/MRuUZ8sZmaXgwrBLUrtm9?=
 =?us-ascii?Q?XwgDYEvanKSZKI92s1di2Amxc3Vdj69S253YLBkiwzHChI/I9sOx27WwOdaV?=
 =?us-ascii?Q?Z5KdGReZ6tDDEomU6KRQ3IboBHVghARUMj8YRk4WclZjVqA2v3K6ZyAZADAV?=
 =?us-ascii?Q?kc8hZ2yySmjJ6uXA4upthlW9V1MJw+cS8z/25aSuO5bfDHmeHwbWGscuy1A4?=
 =?us-ascii?Q?7ytrDcFjwx2HZq5gmuwptUasRYNURhA03ZFrDEFyVZbz71ruDrri1hDiRXVu?=
 =?us-ascii?Q?T+XjWAnuXqlcvjNpN213A8LP4mCFcHUvzOANhDPrFzskOmI5e9AV/r+RNRrr?=
 =?us-ascii?Q?nr12yoHWBHKa+wi/wl3SxEb0U9TJpjel3fZwn8tVvpczH3mqW6M64yBkHBtq?=
 =?us-ascii?Q?ByjleUuyOwBSQC0sd0mLBKqz87TcJQ03yC9f3lS0R1R1JEmf83IaokIYPCn4?=
 =?us-ascii?Q?Th1Y4MvFIvA9r6kjXT8Hnene7rAUh+n1URoz/t3Ud1Pqrci/sBkQHrSYTBKW?=
 =?us-ascii?Q?AyhYi5XtXhWY7cEfU1Lusk1aQLlfUtNro+WykJKh6YOm5VYi85rZMl1ctX5q?=
 =?us-ascii?Q?Sgye8bOrJCpBRSkanYndCTLUveQWueYOC0HahKncefNlt9fyvdYd8E9A/JeE?=
 =?us-ascii?Q?jFFQYVhpnyRtNl9ZtwOFCEqdWZhtV/j2kR6Lzk6P3EXtPkUY+cm3yFqQfLwI?=
 =?us-ascii?Q?ePjKugp3TmfkRhuIEOoejiOlYmq91JbuoA24qdwRIWpdJ7nV+7Tlb3Pa9NXW?=
 =?us-ascii?Q?6f27cZtbOmrXRnnFGgtcQuZOR791BmE1bJwmE+tPyx28f35v9Qt6Iuz3ATXs?=
 =?us-ascii?Q?/36A+UeX1pnAzkDBF43EAZfTkrrKHKNcXqJQkN07Y7QtO+dniGS2DTufdCN9?=
 =?us-ascii?Q?71OQs4vjfzWdbNTQFzrx1KFfGrULeTWohnxjHCfTf40NMg2QSJwa+NynkbNS?=
 =?us-ascii?Q?N7DaROEhfNvH7fYov9akkq+O1BBM3Npoi8fenq5iKGKDdTWPtzn+vVu1x8GE?=
 =?us-ascii?Q?hXZWH4pIJMxty5ydHJGB6GqwuRH9+79vRwTtu4kdtRP+WWEvI/jp4nOvzvp5?=
 =?us-ascii?Q?nOCNk1VOhOLz3eXDGVyVlWJwl+29HIg5xmGIHMGBE1mQO+V9TTa45RtZR05+?=
 =?us-ascii?Q?VXyxPfwoUaITcDi8BcQqqCeV0HMykWuHLQOgBmjvbS6USeQ6F3nMaNYSPNeS?=
 =?us-ascii?Q?UWb6q1OltO5LTgqOCxAFC0NuXwMXoKD7c/2iv7s+vhMxjFerncpY/IdCWZPZ?=
 =?us-ascii?Q?iKby0QWXzJBwqCc4cV/F2EMaMjHeqfjfsiSWBLp1LgIrEQ1ZYKV2C5NSpipK?=
 =?us-ascii?Q?W5kVUbKqexQz9Nh7Ho2BqQAgcvvzMidudTAXBO/EmQMH/rIj5FK3dbN+5WyV?=
 =?us-ascii?Q?W91jpioh2+lsVLI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 01:09:03.0227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0be6d6-fd83-40a5-6586-08dd4193da0e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8741

From: Ashish Kalra <ashish.kalra@amd.com>

This patch-set fixes the current SNP host enabling code and effectively SNP
which is broken with respect to the KVM module being built-in.

Essentially SNP host enabling code should be invoked before KVM
initialization, which is currently not the case when KVM is built-in.

SNP host support is currently enabled in snp_rmptable_init() which is
invoked as a device_initcall(). Here device_initcall() is used as
snp_rmptable_init() expects AMD IOMMU SNP support to be enabled prior
to it and the AMD IOMMU driver enables SNP support after PCI bus enumeration.

This patch-set adds support to call snp_rmptable_init() early and
directly from iommu_snp_enable() (after checking and enabling IOMMU
SNP support) which enables SNP host support before KVM initialization
with kvm_amd module built-in.

Additionally the patch-set adds support to initialize PSP SEV driver
during KVM module probe time.

This patch-set has been tested with the following cases/scenarios:
1). kvm_amd module built-in.
2). kvm_amd module built-in with intremap=off kernel command line.
3). kvm_amd module built-in with iommu=off kernel command line.
4). kvm_amd built as a module.
5). kvm_amd built as module with iommu=off kernel command line.

v2:
- Drop calling iommu_snp_enable() early before enabling IOMMUs as
IOMMU subsystem gets initialized via subsys_initcall() and hence
snp_rmptable_init() cannot be invoked via subsys_initcall().
- Instead add support to call snp_rmptable_init() early and
directly via iommu_snp_enable().
- Fix commit logs.

Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")

Ashish Kalra (1):
  x86/sev: Fix broken SNP support with KVM module built-in

Sean Christopherson (3):
  crypto: ccp: Add external API interface for PSP module initialization
  KVM: SVM: Ensure PSP module is initialized if KVM module is built-in
  iommu/amd: Enable Host SNP support after enabling IOMMU SNP support

 arch/x86/include/asm/sev.h  |  2 ++
 arch/x86/kvm/svm/sev.c      | 10 ++++++++++
 arch/x86/virt/svm/sev.c     | 23 +++++++----------------
 drivers/crypto/ccp/sp-dev.c | 14 ++++++++++++++
 drivers/iommu/amd/init.c    | 18 ++++++++++++++----
 include/linux/psp-sev.h     |  9 +++++++++
 6 files changed, 56 insertions(+), 20 deletions(-)

-- 
2.34.1


