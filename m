Return-Path: <kvm+bounces-36200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1578A18938
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:59:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC47D3A72E9
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 00:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F27A1CA81;
	Wed, 22 Jan 2025 00:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G+jh3dqw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B30EED8;
	Wed, 22 Jan 2025 00:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737507587; cv=fail; b=L6aDE2FrwjX2x5PqtzpPGsMwdOZp+0FZD6EfcXJVBRMxXuWxIP4Yao0TDFRS0fp+9vntm19TT8tLtmQz16WLyurYEyBbf8mbN7f79mDR276VMexUD7+zT995+ybskBYzkIHyZAVegVBk3oLgUvJ0UcoMygUSBcCN16N2PEgySh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737507587; c=relaxed/simple;
	bh=yBuyZ7QSWOHEw8lSyhWMQ0QMLn86uP6E5nHaPWdVMAo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KXHskPlzY8I1VMmsJLtY/6scv2xarzj8mL0PCcueig5Ef1PmZiYKogA9M+qWWiEGyWnFizF5XRVwFL+J7Y2VCnRFqvsKKUI9ZGZF5Q5m47NYJ3+1zaHLHoGpy4OvkRUKbjD3WLp5EKu71YxTjclYrybeIlZeVxdU+OPmmh70Yfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G+jh3dqw; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xg+NF6Te0JFbPryIxm8HPSkO2WBycp5cWc7gUK1rPa4FnW6aigiHPD+cKM6NO1WUzC8ZxeZs7QrrSp2IBEsGggZ/P51Vp/gOffXVdmWvpRAdzUBuQJugvt8Z9feVeOFmEab09V62Y7SayBT9BZnbH49Wrw4YEFbomvqzFKexUBmVyVthUXPYVvYkBTv7o+q+ps1+cmRGStyuqJppw0A97Jkx2dPwUkA8EdgNZ5jHipidY+M6WhAhLEXxxDJJu1v6HLkOD1t6WaW+h7Fl/uXL1kSnsG3LDasStStF04gJ1iqV5D8pc3RPOPOqyZMzfrkdfPlRG6ZgCi9FTXToLOSI8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WN1r903fN4SG1qhKzRjzi4AcfP+o7gYEqmg410hSslk=;
 b=zWhiL6hwgJkKzHK5wgdHO6WHoyfibwwepxP5WQFJsZzAtmlOvsnhH2dMvkFUxBcjM9YcWuecuSQu6Rw8I1ekrBqClptz+O5Xv83I3+Uo3osArVGKWcHEdCJJrNJnhE9AZxFOJYef9IXrQ7l0jj/sx2JeZtP/rkNzmUu0b6IM4WwqJiU3xUUl1tJAPFH20Ui6/y+6lyhsMEgW7P33Ui2CrFPMle76RnOio700hguRzWqcNqc+HrsPERMidfnBPR7ZcL5SHeau5WxlH1WWvV1/2ddJC3pVtKkyRJLhdqw5KFBOlxFfLL9zxv0WxIBvGd+lstlDH7Byb0QAqMjr2Ysomw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WN1r903fN4SG1qhKzRjzi4AcfP+o7gYEqmg410hSslk=;
 b=G+jh3dqwrNoW72i4wH+le38gh1YGp7xdyYzFn3PS2jYKRtQiqgVK35ZQz0WUJOBbLH1y6Yq5DUHcGaiPvMLlxVtVDVVKHpLvkToooKzjDVqqUkR6hHtJdCJnBy668RbO8JnCglxG7VfvWm7hneBPDVjmnWaVSgFG5RPiwTE29sI=
Received: from SJ0PR13CA0152.namprd13.prod.outlook.com (2603:10b6:a03:2c7::7)
 by CH2PR12MB9495.namprd12.prod.outlook.com (2603:10b6:610:27d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Wed, 22 Jan
 2025 00:59:42 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::2c) by SJ0PR13CA0152.outlook.office365.com
 (2603:10b6:a03:2c7::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Wed,
 22 Jan 2025 00:59:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8377.8 via Frontend Transport; Wed, 22 Jan 2025 00:59:41 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 21 Jan
 2025 18:59:39 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <vasant.hegde@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH 0/4] Fix broken SNP support with KVM module built-in
Date: Wed, 22 Jan 2025 00:59:28 +0000
Message-ID: <cover.1737505394.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|CH2PR12MB9495:EE_
X-MS-Office365-Filtering-Correlation-Id: a0656fa4-b16f-4eb0-34a0-08dd3a800d81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sOBYOzREMA45WYicKtxRBPivBtU1WFvGMHzHiQULStG2kivTljOwkYgL2Yjp?=
 =?us-ascii?Q?xFyfrR9ysmXlVjMqlsOno7Mb6dmL1/etbZ4Y42IA0Ajf+mf7MkiZkNrUFp36?=
 =?us-ascii?Q?e/EI+ffeCZFADSDiciQ0NKasUdyNqlVYuWhA3un5qstP895rDlWHiMbflhYG?=
 =?us-ascii?Q?AqtOWt0fmdZ+mu67DwFm9X/P14HFmllqE0K0hINdN2h/2JK5dxkQqjD8flLL?=
 =?us-ascii?Q?ws2jFRzS8fadqVBnv7HGScDCdcEd7efc1rgm+ZU8xE/S0iwFxU4XpcvCP+g5?=
 =?us-ascii?Q?J2O8DtsEdW2cMxFtbdkN1GtHAFDfaWeZwlzI15D3nEL1oTBUQzv51n0Lez3b?=
 =?us-ascii?Q?dxnKfKTuYPke8XyRi9xrV4zLGqHQZK7sS/HtE/2JFM1D8PYgbEWuH/o+pT4t?=
 =?us-ascii?Q?ogNH/55ChMnnfCB1GRJ1IBLXAU2n1dnAXLC9f/uH5YZ44XK+p1dPDvvIWnPE?=
 =?us-ascii?Q?CQ7ZOGqvFoFZ6p3/QTg55mxyxIYXbyIc1ieP41jjAqb+Efp6FNcMRui7E/ch?=
 =?us-ascii?Q?QqhUq2oRJTlqeG1IFN/UPUycFLSWyN2/s7W4JtTDxzjJg3sF3TsWHzDGn4M6?=
 =?us-ascii?Q?Cg7Axw+Bscbh0BiPoC0j6gvYXNzBE2M6jnC3jwj8/xEipCgJYLbU+uyQ7bIe?=
 =?us-ascii?Q?rHrb8WtA/iFG2TH+b6ernClVjUptEMA7MTLht2xe+8/0UUQs7Nr5KnLT4/5a?=
 =?us-ascii?Q?I3ljIf4s1HaJf0BTKAY3Pn38pRXuS1w05BC/Lh4P4rsBHs+gb3XcBd3z/sP1?=
 =?us-ascii?Q?ZlVpXxKNmbIbzEV7yG2EgjJsmX5U+CS3b28YBMaJ52cEgjtDxub8XlREivyf?=
 =?us-ascii?Q?09/TQZgY5Csl8KTd7kKO+KFC2eh1XiHZJ/XETFuPBUiJst4u06/SNUZateVq?=
 =?us-ascii?Q?jmoemTwCiXUudlLZD9jbX49z4PY0xbMwVWw851pzT4aKQXb4mBMBkYPByb2N?=
 =?us-ascii?Q?yLfTZZ6/gIbJrLe3Qd4cbpIm5K4hPI8c/90+f6spYRTjO9ktxWbhIetmMM+B?=
 =?us-ascii?Q?ZLGjEANfn7fNkN84kiCUr+dgWp8SpY/YGSnn5t7KqQ7L6xDZeffewuow2CHg?=
 =?us-ascii?Q?Lxjq467iwMR/kwv1l8SQ/H/nUWyrE3eB8t20nDsfehKaw3k3NWi+X3dj8akY?=
 =?us-ascii?Q?QFzjqkSfWhxrYqofbM4A99+GN6ZzhDhRFb3sUy5dAWplq0WM5GRXFvOwxVsj?=
 =?us-ascii?Q?+nQkoodDpHtPkt55yPWjc9tSUOstUqpTnhJmokfw0wKGKIIENluVE/oMmUi1?=
 =?us-ascii?Q?QXQS79FSDino/oFPL4/qslbu+QWCUv6YHiV7xyBvq6nDeooB9W4n91zDL0DN?=
 =?us-ascii?Q?4Z1/49gPfGy5LGX1rzFl3bytVXag95cyx6F5/sp7innB1ljyEid0KsSYIW7o?=
 =?us-ascii?Q?rGoeNJ1MW94Ry/FD5j2QI+DNBO+msIpCjAOLL1/g/yt8PDlcGuyp6DFgct69?=
 =?us-ascii?Q?yI+OZG8UeE5zpG0+VwpIuLvXclcnm7a7iwifFfweqyvRkZiu/VrQii4lplZB?=
 =?us-ascii?Q?5oOCQ6/tjMOmr2k=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 00:59:41.1712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0656fa4-b16f-4eb0-34a0-08dd3a800d81
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9495

From: Ashish Kalra <ashish.kalra@amd.com>

This patch-set fixes the current SNP host enabling code and effectively SNP
which is broken with respect to the KVM module being built-in.

Essentially SNP host enabling code should be invoked before KVM
initialization, which is currently not the case when KVM is built-in.

SNP host support is enabled in snp_rmptable_init() which is invoked as a
device_initcall(). Here device_initcall() is used as snp_rmptable_init()
expects AMD IOMMU SNP support to be enabled prior to it and the AMD
IOMMU driver enables SNP support after PCI bus enumeration.

The first pre-patch in this patch-set is the AMD IOMMU driver patch
which moves SNP enable check before enabling IOMMUs. With this patch
applied, the final patch in this patch-set calls snp_rmptable_init()
early with subsys_initcall() which then enables SNP host support before
KVM initialization with kvm_amd module built-in. The other two pre-patches
in the patch-set ensure that the dependent PSP SEV driver is initialized
before KVM module if KVM module is built-in.

Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")

Ashish Kalra (1):
  x86/sev: Fix broken SNP support with KVM module built-in

Sean Christopherson (2):
  crypto: ccp: Add external API interface for PSP module initialization
  KVM: SVM: Ensure PSP module initialized before built-in KVM module

Vasant Hegde (1):
  iommu/amd: Check SNP support before enabling IOMMU

 arch/x86/kvm/svm/sev.c      | 10 ++++++++++
 arch/x86/virt/svm/sev.c     |  2 +-
 drivers/crypto/ccp/sp-dev.c | 12 ++++++++++++
 drivers/crypto/ccp/sp-dev.h |  1 +
 drivers/iommu/amd/init.c    |  3 ++-
 include/linux/psp-sev.h     | 11 +++++++++++
 6 files changed, 37 insertions(+), 2 deletions(-)

-- 
2.34.1


