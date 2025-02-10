Return-Path: <kvm+bounces-37755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFF2A2FDCE
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 23:53:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BE423A4EA8
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7C125A2A8;
	Mon, 10 Feb 2025 22:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kq0K4PPY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAD42586E4;
	Mon, 10 Feb 2025 22:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228026; cv=fail; b=dYCJDFoZd20AyzPYSYn2bWRonWF2zSMXSedrsYNeQBns9fur575mm+b5ARmXobifek1Lf5eTUt2CGRvgq5j7V+qI7+3wclk+dg/nCk7sXlX45ZVJsaCivg+PHjf4KIICuVdB3IhvqRBQlEYVgyLGR3ai8x2Mcrg7MSYuCwnpH2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228026; c=relaxed/simple;
	bh=shF3SVdLmwCQm6B/tzjDai357btRppXx6otszFFmZMI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=X8n2oXj+tFoiqebxAmZqXWAr6x92tNN0jXWvuqQX6Zz4kA/wGcPmcHFWFE6wR3TeWE7XQre9V+L6JnwnBnE/f4aPN75Koe8c4R5uan06L6oU2FmLwEb0cIKxUQVhMj4EgEPrmD1ft+s+bTyTai7C45QOLGU7KDE+pZqb83FNiL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kq0K4PPY; arc=fail smtp.client-ip=40.107.102.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Abu9EqvUzGZk0nAhkSGFRJTR+7IyMtxaL4cLSInjxbY8X3ifA5K4Z7GUsZeyoQOJYp5Lz8OGVJ6/AnOwH9RtxbQpLIyRlx/CFfv3XMVjpIYMx4I31O4wxZJ5D58zYnil4MCdLEnb1kzQXe6CP6lxRY0jF0ubKuBfCvQ1hwvq6B2AAUVbfSsZqgma/aT7CohtiS5MjEeP/3TEVOz6q0DyJ7Z4v7Fr4jxs7N7pLI3wELGBbScklBPWg4iPlkK4aDKlQFw2OJ8tRGEK51zeBP+5M4gKeBkLGGTzYvqid58tU9CoDicL1EahIQaobMuBoIiOJeVgI5ISvESE9LBmk8oglg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9zvQoXEYq+0FAvlzUaGUD/wo8pG1yrjRiQjZ+7CbEk=;
 b=kxIeJGYyWGylpm8m/aqxuzNs3d1vQo6GJsAcg3ZQbBqiIpP6HBY/B9W6p1G88cUBdLAt2HhTegqQNA1e9GohgfmJj6FeALLlREahMUk0ZSbGd21hYA1kDi8NkoOM6SdXIImbFta9NKFd9DGBApNVVv0QTcJxXyPFiqkT/bpOKpunQmYwauK2vdBMnGFvh0afDWRosgzHWzXaxqw/OwBek7yRIYGBPm+t/GIN4MAyvZkEko1EHVSsU9YLPYwQk1fo1ulTc19BZ38PJzOp0JC5WoQWJHumQ/R+R2gzHzlZo4dyJ06LbwdnEFBUJQSoQx8Zx7/a7ow0BqSL8xTp7lToTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9zvQoXEYq+0FAvlzUaGUD/wo8pG1yrjRiQjZ+7CbEk=;
 b=kq0K4PPYXk2mpB3gKLSidMhc+O1QgAyN6LqlvmjRVTbrypfKF/RxuVgquG3C/sTURwywB7fnubzmImhWh4iecBwnACgMZFIIWKe/YEKhMN9rj/PCo9HvAYXydzQJQgValozTKINk4EvIP8uYNEyhTEiURPzGkkJX82kLflEYFFg=
Received: from BN0PR04CA0143.namprd04.prod.outlook.com (2603:10b6:408:ed::28)
 by DM4PR12MB6400.namprd12.prod.outlook.com (2603:10b6:8:b9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.28; Mon, 10 Feb 2025 22:53:40 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:408:ed:cafe::c) by BN0PR04CA0143.outlook.office365.com
 (2603:10b6:408:ed::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Mon,
 10 Feb 2025 22:53:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Mon, 10 Feb 2025 22:53:40 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Feb
 2025 16:53:39 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<vasant.hegde@amd.com>, <Stable@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>
Subject: [PATCH v4 0/3] Fix broken SNP support with KVM module built-in
Date: Mon, 10 Feb 2025 22:53:29 +0000
Message-ID: <cover.1739226950.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|DM4PR12MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: b3979a56-9dfa-4ab7-a862-08dd4a25c33a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YzpbiiHdq08jnC3q/0TEnJD5HaUMfOD8pKk9nnc/lr/vKksNJ1C66Sg/0FZU?=
 =?us-ascii?Q?38dLsrXmE0t6H8Ikqin5xCFeVXYRYZihDUPEJwWwrFTeapozxKrjPdCZbK1E?=
 =?us-ascii?Q?d625Eu3tHugUZLwZ3jubWUZnwnq7PxfbbydFXoyAb2SOIb8rwTb6sSGNPOZO?=
 =?us-ascii?Q?nB8tsFv7aZEsyeh5JwcbnFXoEv6EbxjPl99AMCYQXd8KVPOBwcOQnv4lyJpk?=
 =?us-ascii?Q?rvyTADzg2cfQ99nbcoBmKZVOwZf57mmBfnOPZg0pUoTJaEWCdPnetABQuFms?=
 =?us-ascii?Q?whaQn2N2XyrUIs/rodk1ptBwj/J2G3cctvFTlQ36qyCy1CUA4xgjsqsJkDqg?=
 =?us-ascii?Q?R5NOSP1weH81urcmh75DWpLg2xbcpPgkQBh3Pe3V4aQvju2qFKkSnLVost7k?=
 =?us-ascii?Q?j+APACzI+681osFdnvDDziSQZMGqSKg+bNNUA7D5fW3oZ2ZSdiyaJ+C0vlFW?=
 =?us-ascii?Q?fv5SpHTzy4X5RCzW0FB73IdyjI+MS/TWyBKOxOAV8mh03nCwZVn5VYEFjG/I?=
 =?us-ascii?Q?mnLDC23YYoFOzIwMYUOsIGlkjvPy0jLlIvj9U2hUy/tZ79v/c+ddXnvVWDNI?=
 =?us-ascii?Q?1APdMbKJKDqjt4662Ob1NBFJc+SEKAYnIVILt4E982ukohNL2ZA+P7cKO8Ap?=
 =?us-ascii?Q?OxTkamBKpP1dOahHI7BTGGwiQIPl8QKNJmW6ufHVLhQwiQWmN7tvird4dKaF?=
 =?us-ascii?Q?gRZhKRK7k4lLZkdER3T5+1Xy8eV9jHaEzI0Ap5K8ZTIih/vOF1ajtDQGvPZq?=
 =?us-ascii?Q?7GB0xjN4nz+11gHidVHiWOi3VX+Qwxw5FN0aW/yce+bZcOV54qqkPk+o4MSP?=
 =?us-ascii?Q?YiLUgqZRxH8B0PmVMxUBvZLLkJjfESmySHTRp5bJJa7ttDIHYQ0LtnfAzrs9?=
 =?us-ascii?Q?AqJMnnGaTZPv2Y9P0BnPBO9vn0AqKZ7fBvLXLlIJv088GcahIjfmpcwHKsgW?=
 =?us-ascii?Q?5ucYYMCNpmledjnDedQAM8D9CURHn0WA9XU5HPwwz22/pU6wzrwdMnbgv1j1?=
 =?us-ascii?Q?Hg2Ey1tXGsD4S3+nyI55Rn/LoVvfLnLa0ebD0luXyumEvB/B6KFG6VELDmQI?=
 =?us-ascii?Q?VXIlZp+9IsIZ7bK3Z8nuztL8wWEcAihUfpgUg3azfoi8HlVANSUVaHhO7kum?=
 =?us-ascii?Q?MXGWF3SBUJtRoNSSBvspBV6Pxdip9W3w8rT9IN43b0R8qaGSlCj2mNUkC0tb?=
 =?us-ascii?Q?kjqmIy2cCUnV/yLzTvuMZu8htIPnXqbydmLeT7FI3jrUbUnXcO7WnejjnWoD?=
 =?us-ascii?Q?KIeovKZBi/l2+tu7BnwZnbIQD1AwKBZyLRh7EDQxzAEZuqc/P/PSlxd3m4zt?=
 =?us-ascii?Q?DksCjHGnbv3CjtTJsgEHWnVhbsiXOOMGy6w/GWi05zrBeQiTfeqt9oWrxfRn?=
 =?us-ascii?Q?T2UEj18NT+OAW8rOz6YVPdRua3X83OFQCQK3DX/S9TKs7CL84pgg+6pHdnub?=
 =?us-ascii?Q?ci1lZjOTgqCISP1D38WUZoVWW+Wlov6WPnYDxWOjL4QMfUnj1Wbgap66ucI+?=
 =?us-ascii?Q?x/ANDvDOZH0ZbOzWJviNkwx/uWdx8cE5q2nK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 22:53:40.5500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3979a56-9dfa-4ab7-a862-08dd4a25c33a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6400

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
1). kvm_amd module and PSP driver built-in.
2). kvm_amd module built-in with intremap=off kernel command line.
3). kvm_amd module built-in with iommu=off kernel command line.
4). kvm_amd and PSP driver built as modules.
5). kvm_amd built as module with iommu=off kernel command line.
6). kvm_amd module as built-in and PSP driver as module.
7). kvm_amd build as a module and PSP driver as built-in.

v4:
- Add warning if SNP support has been checked on IOMMUs and host
SNP support has been enabled but late IOMMU initialization fails
subsequently.
- Add reviewed-by's.

v3:
- Ensure that dropping the device_initcall() happens in the same
patch that wires up the IOMMU code to invoke snp_rmptable_init()
which then makes sure that snp_rmptable_init() is still getting
called and also merge patches 3 & 4.
- Fix commit logs.

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

Sean Christopherson (2):
  crypto: ccp: Add external API interface for PSP module initialization
  KVM: SVM: Ensure PSP module is initialized if KVM module is built-in

 arch/x86/include/asm/sev.h  |  2 ++
 arch/x86/kvm/svm/sev.c      | 10 ++++++++++
 arch/x86/virt/svm/sev.c     | 23 +++++++----------------
 drivers/crypto/ccp/sp-dev.c | 14 ++++++++++++++
 drivers/iommu/amd/init.c    | 34 ++++++++++++++++++++++++++++++----
 include/linux/psp-sev.h     |  9 +++++++++
 6 files changed, 72 insertions(+), 20 deletions(-)

-- 
2.34.1


