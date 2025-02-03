Return-Path: <kvm+bounces-37162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A32FA26632
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 22:56:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 958D418861EA
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 21:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BE221018A;
	Mon,  3 Feb 2025 21:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fpR8yuZU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66FA20B1FB;
	Mon,  3 Feb 2025 21:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738619786; cv=fail; b=teawZhQrAxpGug+5Bg5SXTmurgtAPBPFETTAa8HXkRCM+CGrxI0cg+i6WUhEEQJK+uiBFd7rQsFww2DkYRHbxDvqdf/VIxKr1madff1UTQC+fUD9UF2nRty4iEEAHiFgNSil9jm6SwbxIePKvrHOHgI/psonxPcmzE3e4UpABUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738619786; c=relaxed/simple;
	bh=Ii71AmI4iKuL3pySBtVyKrzvZMG5fPLbrgotcL3y0Ro=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l3ST3L1rz8+Tr2zDPbJjXyjCYTEHJJkeEoLCbdRv3lENAzwlljVSjEcYsRwnRGw5ZObUW6AjXaAlu8A+ZBZxtCHrSpfZjFsStKzQCLgT0oY9UVFTw7mTvChOZ5jcjlk4xJVBSr+j7ATEwqSxdtYwA+SNuTHdhJh6/+kTJz+rCeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fpR8yuZU; arc=fail smtp.client-ip=40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HtpfhdS5pNnp2QNTiHxuKyFvmT3dmo/w6iMRQLSx/OA2eF72lUKMULpS4m+VjWRlJvMNGiA0qWq48yrtBwM9HfsN4zfZ1aCyzQf/r2KRyea4rBwCZCL6W4QwPXiROndRDViDKWWckUUx21a2qtggCNmWoF61WtzifCNPTywWOOqoM3lF1xyrT8u92I+Y4lTiORh1sXhp/kPjaSTGajLaPyLgvyq4blh/jKYIYZWLfU/h6t+mNsM+piT3aKUv4CbzqFpVBvd0lB6lW/+RmaTmijMJtSIQgbJGDdedYmubvINCNJz44WF0xeMlLt9L2en3AEmQX70XfMP/ELkwt5366g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxTVmHdVjePyEOhaxnVHntAs06z7NcOhKF+Mc1sLImY=;
 b=L3U6TowtUQO2WDQxVD9gVjO5mbcnuHphqmjnuT5s1hAm7bp8r6GKr8U633n5kfXu93AOMVWYg1JWv7a513T/dRmXp+R0lbkyvm5F0nFxYo52Pk1Lm/VfOKwhjH5tPfu2G7k68MiGnMfYB1fpSEqKWeVk7brfT5QIv3JFl8kj4Xij28jTWZsuA+ZWTVcu/SXXRo/KP++zgia3OsAeYVt+0Pi4Mp+A7CjW3yuHEFjSYz8yUFzu4Qeg0MeYwuG2fAO7akFohCvUFag0OKtCxkFc1SS8SyjvYCw4xebirjwmBahdnlamfWm5QLYqBjduJyyQ2Ik117lrcR+xXAP2ipyLpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxTVmHdVjePyEOhaxnVHntAs06z7NcOhKF+Mc1sLImY=;
 b=fpR8yuZUDY9dwF24pB0KNIzNrKVaWWtDoIthLcO6RvPGPL2RmyaFNFocfr+sWHnFQ0nNa5AQGYg0FHS24/85qArjfwe2k/aKD/05C7g/P/tDrTugxMo0et4hh/euulF4r78KE0w1JKkd27nD7OYSMo4y49wP1egM47AngGjKWeI=
Received: from SN6PR16CA0049.namprd16.prod.outlook.com (2603:10b6:805:ca::26)
 by DS7PR12MB6021.namprd12.prod.outlook.com (2603:10b6:8:87::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.23; Mon, 3 Feb 2025 21:56:19 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:805:ca:cafe::b5) by SN6PR16CA0049.outlook.office365.com
 (2603:10b6:805:ca::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 3 Feb 2025 21:56:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Mon, 3 Feb 2025 21:56:18 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 3 Feb
 2025 15:56:17 -0600
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
Subject: [PATCH v3 0/3] Fix broken SNP support with KVM module built-in
Date: Mon, 3 Feb 2025 21:56:07 +0000
Message-ID: <cover.1738618801.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|DS7PR12MB6021:EE_
X-MS-Office365-Filtering-Correlation-Id: de8f7135-4e12-493b-d1c0-08dd449d96af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OaxTkcM+FB9VP/khAUKOupKhTvHaPPs+y5lPhAU8ppT1jdBEj14P90tOmZ2h?=
 =?us-ascii?Q?lSIs06d1wy7htT7feW+nNBgVgg9MOBzaqLQ3zM/dOQ4EzRcpdR7jo/hHGBax?=
 =?us-ascii?Q?s4La0bxd0yIxz3qCBkeqFd9vu0+J8Y7okZyjjAlnMEP5iA+d0waGhu+jnsZa?=
 =?us-ascii?Q?JkpijBvPqvz8f6HMzjgNbn7hLolyUtz0JXw31Kky9IaFg6wn6m8EAeOEgYiJ?=
 =?us-ascii?Q?Vy1cGoB/dXItBW+3EsI8bAmZT4EklHm/+4d7C4bv74MhLoUZHvmSyOseqRFR?=
 =?us-ascii?Q?fdy8tUQ0bbVCaWdbbMMiwx9eALoa5AB+OHVA86RV5GycY2fGMMxcgGwox6XO?=
 =?us-ascii?Q?aHjuwTVR5LXNoyFKUKTDo8cjrMzF6deIWHYAS6LnhqC+4RybCfHxLzbiIEZL?=
 =?us-ascii?Q?/mCo/8tA0B0HJWjdQZ+F5VhYogAT6hMO5sPIJufr/rTKdOnOvG9qTNnZ1abK?=
 =?us-ascii?Q?+8C7vYby12l2L8wxt0h8gL773QyQHxaX1+TF2GNsv+uIuRaNZat4rYqz2/8D?=
 =?us-ascii?Q?nD1KpvvZr/WivzCnMKVZ45abPTU4uiPISZkcQYuerFD24qMBA1iyg1hmN1/6?=
 =?us-ascii?Q?3hLkeNz3xCqmRBZfyrhKgY2tMzALNkSw73+wEY7QDOtAdb8pnOsdKRQEjYUe?=
 =?us-ascii?Q?rKFSWEwbS+65gqZI4qxiIS/x103/FM5VYmxst5q+euv6SC2LB7qSlwbTVZeK?=
 =?us-ascii?Q?M38h82fj9rHb6jyrBtlRSFE2Gw9gYhr/7mn4wTLP8iACi3+TAt7HTlgpwtly?=
 =?us-ascii?Q?lOdRQjuqICqxU7npqerDTqpNyvkqwsoU4bgK60dGyMg3vkE+ulm2La/4orSV?=
 =?us-ascii?Q?FCtRdOSxneca6GKLYUkREFQlDFbY2DQIh8BrdTwXB1dcMuxXtbSzwF+/RFMS?=
 =?us-ascii?Q?HgznFV2SVnnl6n1pKmOVHKBkcQYVZngSPC+G9y8QU1pCr2FbUXQwD10RmrB/?=
 =?us-ascii?Q?JxV/DRDp8EEz2w53r9q3bUG6w0+IxyaFc1sZNpAQTZ2SE+kfVsZ4eKBBW90z?=
 =?us-ascii?Q?6CY5MZNI1MSw1YgzqB0XHKoOIgw9dg0yRmNZBV7xsLIlfHcWivSKgR2SoUXi?=
 =?us-ascii?Q?VeiWnIsRFZRkMX4KTnBpyBw4ZGzb+DyGXYpB1iABhUSaDMjwA8xju7kONtEy?=
 =?us-ascii?Q?F+pOSQCY4yUSn1oZ1rMyj3iTdIppSyLbREAB3DW+/h0CS1mVyTfIZRV++vEu?=
 =?us-ascii?Q?MHUXvVqS1IzWQ4bh4dcnye260Ww+b2HhHt3YdQLtSDJ5iIQfqrYZ4cYNNhXS?=
 =?us-ascii?Q?rHONNz3OFGqnOKaE7mypiw48j71yiUcj+T4g0lJR1P5+PmlZWGW/KNHeUuSC?=
 =?us-ascii?Q?hwiv9j1uF0HbCM2f2KBoGBLa/+4JRDGXk1mgFN3EF15w/hbuMMPqjjduF06z?=
 =?us-ascii?Q?PtbwuE/K9jZpD7aAISRjFwnP6gjE0keRcxEZNx988ahiagjAr2ThAp2BPuE6?=
 =?us-ascii?Q?U0wDa+BRVmbsLl22Dw4Pqkfs7jPALo9STnhZo0sJfTJMgIiJ54rUlxQ3T+VK?=
 =?us-ascii?Q?1S7jBzkoRYHFQ9AAYaJc7xetnevMkDBsPxhd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 21:56:18.4356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de8f7135-4e12-493b-d1c0-08dd449d96af
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6021

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
 drivers/iommu/amd/init.c    | 24 ++++++++++++++++++++----
 include/linux/psp-sev.h     |  9 +++++++++
 6 files changed, 62 insertions(+), 20 deletions(-)

-- 
2.34.1


