Return-Path: <kvm+bounces-61217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3683C112DC
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 20:39:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF3D819A2B1D
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 19:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78BF6327783;
	Mon, 27 Oct 2025 19:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WxhEThY2"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010051.outbound.protection.outlook.com [52.101.46.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5C62D8372;
	Mon, 27 Oct 2025 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593654; cv=fail; b=rSe6rs0JHqOtm5yfU6q1DJH7m94XEYaaK9isdNTaJnOKQuj7+/x9BN13J3uE9krIggsEsj8dxAaZRP7yttLXpIT1x7pAMBdJXJLqtpch/toa1KgXoTibqrdgcZtNcaUafHxP4yEkQGuZo5fWSc25DTrASR6CsUnEdiSClher3/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593654; c=relaxed/simple;
	bh=Qq3mdicbTmmVjCbssR4ZSr7ZtW5UwdHwvxN3L6W93Fw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mgexm0kswh/XRXeRIkzaj+vbxv6lT3PsD7lDl/NQI6TIkunairK1bMRGNKo15R2c2cXXqcGBXrIb5QAIpiEY+BsG77A0IJ35/MZUznmlOIgQ3FgUyMAysto6ZSIJfA9cyKsFiYyRPciOak54LdBZxPE08QhuIGHbiL0UwF1qSYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WxhEThY2; arc=fail smtp.client-ip=52.101.46.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NTqUzuxgGCS3NWyElsM2q3Vhu3pKseuwgerATzmcpLjd9SqnkNOogtBbchcATDYhtvCXLWUn+WucOvywkyGxlFpqpTmQ9tYmS3MDv8u/3ZgX77AhaK/11MDEcKAZS+pLlzaXqPGqRgW+ia7D+CS4s72hxlnfJshpJk4MO/sIyxffSwJiI3m+tOb7XELGg8/KK19Z2XypTctgCCdLgKtOUUYubutbTcGjKnNDD6jFB9zFyIi+/sWTQBWIEmfT64hRVgOGpqR1xEYXVsBoqQDvJz9vY36zLxqEkww34R5uoY7yIcqx7Gdz3i06dFSpKDU5KUzYTpai8MrsaYG74fZDSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1u46BiZ5gKHh80LFQ5m+WZFM0PNwJEsrfHNbg/YJmQ=;
 b=N8HS22H4FjPcqntdidXcZTxLo7rmMx78/xO6Vta0DLHEF3o7xwz1yjWmH4wCQtqu/x5a7N9MkNyFlvtzwMxOyXjwvDmKP2OYFu2kY4jIe4WiLTjEV0KQ4XQZdhkQ7Sp++cLbjxd0bJKl39JM7CiOFawbj+GeG8gFbzVhdHphlmK9CUxXyPapee+K3OPINEpQ83Tx3vfgFUG0ROY+t0jHq0zDoczZ1Zp+mK2Q/ODlHka6ARKRI4PaSM4iyYuXjLi0Xto0QbKRVa83JIEqQk8CYQeCvJXY3mG7tb8BgDoW6XNlNaOn/tjdxPpXjA/MkWV8DkLSKhIZwUCDtru3TPNO8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1u46BiZ5gKHh80LFQ5m+WZFM0PNwJEsrfHNbg/YJmQ=;
 b=WxhEThY2dusAKojXqg0YN4hw+Ky9Ado8laPo44f2OTGeTNVugkj3MOa566bl+4+eDM0GqopXdeTWIKf0MY/ZtC+iO7MyUUL5c3mYCEqif+b9XH39EoYwroEXrY7FLcZFkLFds2U0jfto5l6T7ndTg9GVNFm3OP1AXwRt6c6tir4=
Received: from MN2PR08CA0010.namprd08.prod.outlook.com (2603:10b6:208:239::15)
 by DM6PR12MB4331.namprd12.prod.outlook.com (2603:10b6:5:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 19:34:08 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:239:cafe::28) by MN2PR08CA0010.outlook.office365.com
 (2603:10b6:208:239::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.18 via Frontend Transport; Mon,
 27 Oct 2025 19:34:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Mon, 27 Oct 2025 19:34:07 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 27 Oct
 2025 12:34:05 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v4 0/4] SEV-SNP guest policy bit support updates
Date: Mon, 27 Oct 2025 14:33:48 -0500
Message-ID: <cover.1761593631.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|DM6PR12MB4331:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f635d4e-bcfa-4e7d-dbf8-08de158fcb83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NwQViuZMZdU+K6gi305iZ+VWGDz5EN/ZE4WmVVM5OBfVsxQ0gMA1INh0RREu?=
 =?us-ascii?Q?wvgjgIEjwrBNKQL4sLWveWQMnK2HhOfgkivBrzygErMxvWqaLBWYLNsss8PY?=
 =?us-ascii?Q?AEz6x863Jrg1vux/a/OckWEaMYUrX9Kn7elej3k+lfbyfhG/w2AirR2yErQY?=
 =?us-ascii?Q?InfGXqz1PdE1P8F1kpKTKA/uZUib3xscpZVQ+QyXwVFByB9Ap4hUC2pjfmHI?=
 =?us-ascii?Q?mZ/68cZ+dk9I4oGDY2l+mfg+QS4OcLq6wD8CqQ36/yEe0YuYOhe8kQAKBRZV?=
 =?us-ascii?Q?JisxoRwpN5ARJDmhh3DJx1adTzMfwAIN+e7ierbAPs0yhLZ9ukxCHs2LJlZt?=
 =?us-ascii?Q?LIhbvkfGCotw80jCNPge2p+KjHUTFl9bX8PtOn5WXR5/zS/nfYdsoO4vU+WB?=
 =?us-ascii?Q?TSKxJln/AnjF5FBjzkm8b5LctgacsjK7J0rqtMRujSv0wXI/ocRE4KbtsrQo?=
 =?us-ascii?Q?k37LK+0xLcMqMka5+2sJyD+t+VEDnMOURSgTLqps9EJTR9HMSTYZA81F2Y1N?=
 =?us-ascii?Q?MoFWFB0FG3Ar+W/Q937xJD90xveMJxZY08LlzMZwHm6ugUAfmHJKPqQYuYT/?=
 =?us-ascii?Q?8R26Gli5mYE+1NOF1AvQeS+M9Q3FEWK5rbggRWVCNB58fwBZXK/WYGA4s/e2?=
 =?us-ascii?Q?50tvjJuxLXiUJXd7VdF2OFg/rp3rM4CFO91mdQeREQW+KQXsoZacifT+Vm2G?=
 =?us-ascii?Q?YSdW1/8Zzp4PpYcr5+iqz7jufaqow6CX3QhZXe/wBX4QSNLfv8QwdxiKCZFo?=
 =?us-ascii?Q?JCfYs9OgR3cj+8otD2cC3a0EiLQW0VUBGafClBBWmOY6tSR1p3cuAe8u+hYw?=
 =?us-ascii?Q?bW6BmFuFlPp+isX+hxV8W5TQcWRcG4uDKD/JWlzoZo/dF2HcCsIkfn1tlNIK?=
 =?us-ascii?Q?U5b+ZVRKsSaLC9FJJvNnh6XZpzXNic0ZGJlU5touKapnCsll2DEk43nyiKPV?=
 =?us-ascii?Q?wfCuDoBJmTNCU7LxEJ/z5ZSXxFF03More4ltwPpEVfk3uBrdq08buGEZThmt?=
 =?us-ascii?Q?S7eEwTXBqk0IHH5CqW4k2dD+QZRwiGdmF+i18JIx9FQehf6SY3Ep7t/IqHmn?=
 =?us-ascii?Q?eNlQ5+oR2Xh34ib1eaEXqgQkQIAdSM+qJv0+rQa7WTljbsczB4RpDRXZIJRv?=
 =?us-ascii?Q?B6Jaat6p3XMDI/TK+q8DiU7UAUwyg/w1UCc7iY0jmxgaUgdnMwoepaVOVYQq?=
 =?us-ascii?Q?b55Mq0/AAr4LEmVk9jTwyv7RHDIO8eIfBT0NlXHuEIsXsczmB+1x0eY3VK2D?=
 =?us-ascii?Q?+Qccn4IM4tUrhXZm122AMRd8CRo5VrkHiTaSh2/r4R6ggJngGi04iX5wc6be?=
 =?us-ascii?Q?+iJNF93S3cqggxycJwrk6vVzUHYPpt4yoCgBf/JIpDvAGTL9bDh/mkUhX7vd?=
 =?us-ascii?Q?+dLmA/ao/tA4gHJ5dS7dCUTKzGzX2Jxo1ieKiXMeh7117uo92u4CaJmKpjuM?=
 =?us-ascii?Q?ivjqTEcYyVfLwuzsz0YilGhEBFsqq/pN9GDiI4Jcv+zYZMefXvUNfIeqQPU7?=
 =?us-ascii?Q?43kGHWe7cbcZc3fOQn5HSvUN6n+GR6xI0deDGqoyryhDxRszQCSSLZxNpLNw?=
 =?us-ascii?Q?tbrh8Az+LTsTx2FurFM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 19:34:07.1676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f635d4e-bcfa-4e7d-dbf8-08de158fcb83
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4331

This series aims to allow more flexibility in specifying SEV-SNP policy
bits by improving discoverability of supported policy bits from userspace
and enabling support for newer policy bits.

- The first patch consolidates the policy definitions into a single header
  file.

- The second patch adds a CCP driver API to return the supported policy
  bits. Policy bit support is dependent on the version of SEV firmware.

- The third patch adds a new KVM_X86_GRP_SEV attribute group,
  KVM_X86_SNP_POLICY_BITS, that can be used to return the supported
  SEV-SNP policy bits. The initial support for this attribute will use
  the new CCP driver API to return the firmware supported policy bits
  ANDed with the KVM supported policy bits.

- The fourth patch expands the number of policy bits that KVM supports.

The series is based off of:
  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

---

Changes for v4:
  - Swizzle the patch order in order to preserve ABI.
  - Use the new CCP API from the start for the KVM_X86_SNP_POLICY_BITS
    attribute.

Changes for v3:
  - Remove RFC tag.

Changes for v2:
  - Marked the KVM supported policy bits as read-only after init.

Tom Lendacky (4):
  KVM: SEV: Consolidate the SEV policy bits in a single header file
  crypto: ccp - Add an API to return the supported SEV-SNP policy bits
  KVM: SEV: Publish supported SEV-SNP policy bits
  KVM: SEV: Add known supported SEV-SNP policy bits

 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 45 ++++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.h          |  3 ---
 drivers/crypto/ccp/sev-dev.c    | 37 +++++++++++++++++++++++++++
 include/linux/psp-sev.h         | 39 ++++++++++++++++++++++++++++
 5 files changed, 105 insertions(+), 20 deletions(-)


base-commit: 4361f5aa8bfcecbab3fc8db987482b9e08115a6a
-- 
2.51.1


