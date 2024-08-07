Return-Path: <kvm+bounces-23461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3277949D27
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 02:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CC932834F5
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 00:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF22E1EB29;
	Wed,  7 Aug 2024 00:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ge7VvpHe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFFCB667;
	Wed,  7 Aug 2024 00:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722992311; cv=fail; b=JHlsnDsFcKMAmKYmDSbL3Qhkew/B1kl1RbvvWk1/UBLX7Q2/dgv11BL9Chaktfxei9LpqEigNSWj9DK0iKVN+dKzKjh6MamFw+dtnENO1PpGC2BCqV3ddBhmxWU+4iWcUAKTE3OySQSdT2gkiFqvHivuGLk9mgJBmB6s8HVT1vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722992311; c=relaxed/simple;
	bh=XQWKwDPFlsAe6wzwb+v6C5V2LQKGKTBAdKKilsqV1Ow=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c1KQ3pRMYvAKwXkyzkmU3ZQFTrg3gvfgdqMXvbC1j4ahOAqhQAf2WxGwazQasQXrWIVb0u+FSzOR73HwRD5HBOCtIp/9fGN5YHeWN9sDVpDtD9Iu1w+93/2XZOSwfQaH+IPfpJonWzwsrM7H2GPvq5tbY77NAmMSUmqj2EHNXnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ge7VvpHe; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6qgcP1lzWaygpA32cQuG26ksPBo/MSjjxVZqa/PXRkOexQnfdTVbsxLnxFDhyRxsFZZ/jiMceiNphx8FrvZ4GiGGdIWuLQbx10XahbbfcfzONogHay91qg1nYYAUo5BqaWwEYFiC7fHYlDsqk8ppasvWdyYcF5VghxgegTDN6pb4/Gl6mkK0/dTgHbTavn9Qm4EZWpX552Ycy5eSjCfY+bg09HCwEwE7hSPQSj+QY6l06AAE/5eoqvu8SHa039KIqqvHZYcxJ6OL8vfElT+ctNn3BmMjSJSYH+vOQYxf/XInwfuw1To+PhFu9Ib+hbbitsi+uGyrUxu8M0P7sztsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHwTQq/uYvsXbMRfjP+Xr2TW7dVG1EU0X0Pl4h1XSjY=;
 b=nEt6voLbprbRtTeT77e9dJBxff7LwiTKm5HuJtPDsbPe9EXXEl2W503cHYUiees75sYvUZXrZQ+S4WtgEmUT6vTKBE2OcoTxiV55PNwKu+Zy3CQuANVs2aGocGpxdWPrfzy5BpqMH/qF6x+htoWWYOc07/Yl2Vc1F9+sKSdUPn0vTqzMqwEj1D3WipJ1oKXnkf2ToZO40nQeL93yi9LwxIBBglrowTQMNh/erg4DM5H6eoVWJEqDYOpEO8KJIqgkaY+J2BuPvcQzXZmQ8l/vO8kUOmjffPV3CkBIuO5IUUghGsBGJWSGxTSc/8Plvp4tUJ1izVObhVkLM4j+oO/F7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHwTQq/uYvsXbMRfjP+Xr2TW7dVG1EU0X0Pl4h1XSjY=;
 b=ge7VvpHeRVLOQvoDdN9KLzRV8r9Ty12+v7sb7hLq65Gv2+O4BYCmC5GwJMXHJPi6mPSVAeHfscTJgtrYNyFoDPq19vt8YiM8Wtn3i9uA3dn3/e1uGHFlG80dTBAwc3bM0+xRnRqvMpU9T45KV7Y3rQVWUQuVpabrXMinbgybvbY=
Received: from PH7P220CA0095.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::24)
 by MW5PR12MB5652.namprd12.prod.outlook.com (2603:10b6:303:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Wed, 7 Aug
 2024 00:58:25 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:510:32d:cafe::29) by PH7P220CA0095.outlook.office365.com
 (2603:10b6:510:32d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13 via Frontend
 Transport; Wed, 7 Aug 2024 00:58:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 7 Aug 2024 00:58:25 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 19:58:23 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Ashish Kalra" <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Melody Wang" <huibo.wang@amd.com>
Subject: [PATCH 0/6] SEV-SNP restricted injection hypervisor patches
Date: Wed, 7 Aug 2024 00:57:54 +0000
Message-ID: <cover.1722989996.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|MW5PR12MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 50d2ab24-ef31-4e92-74fc-08dcb67c0ace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PA25CqYIQ4/pbwJjdqmrvkvovP80QDR0ygZFNZZhuirvLQjLdEE8xa7mdg8O?=
 =?us-ascii?Q?2x+bSuR75Un2qXRVrpjFgwxrQE9Jez5jgApDWGibOjg1EXzxccXysbyuckzT?=
 =?us-ascii?Q?Uxh5z7q8v0Y081NPWFmBnaH1A77lxRIdJpaGAkgVP9CcgkRZpl7YHTfXXQ8+?=
 =?us-ascii?Q?KB67PiW82iUJnLf3HFbEY+FtYTES6Wp/4qFYRFgQof8fd/opxLEzirxLUH5Q?=
 =?us-ascii?Q?e8m1DsO5rc1YBKIdwBWvmJEYvg52oSVPwPr6aRH0dOc3TljAz7laGSLkQzOR?=
 =?us-ascii?Q?zCWC7evyNlL8hA9QT7YW8gKOVK60rlh83g49Fu1OJK7Ya0Okvg13KwY/UB3C?=
 =?us-ascii?Q?XcDyTnh7hCwQTHDD3UEuHha3XMAYcEtfR4MktakaRWOFeXdDl4JkLcUoos5p?=
 =?us-ascii?Q?D9drBJZBUW57KOA/Rygu0YQrXbJWeOfaWIrEX81tdNCEUJS6SXxX8OwUc6cY?=
 =?us-ascii?Q?U8I4bg0o1yBfwFY+y/KCAWLafAT4sUUd47XvEUXFSvf7H6HSdn3itHx4bch9?=
 =?us-ascii?Q?i+yznIQirJXgtgEWIDP/omHwisPBok7qyL2GUM2Kaz+q/T/mE8R2byo3jiNl?=
 =?us-ascii?Q?JqU2i4ekdZvt12KFslZ3mRuTnSYT3vhOpFa3j1QwqSs1BTzBa/RNBFRAWNod?=
 =?us-ascii?Q?nZipprvcFLGnowc2T+MOTMtEPN08yuXsbh8bXs3NydsDcgzY2A4pIxfasKfF?=
 =?us-ascii?Q?qDsO+7wr4tRIiMuJtYTUJJwktk96LYciU3Jq0JnssBpNhvyA8UjtbQjN7Eo5?=
 =?us-ascii?Q?/N9Xz//mjeaOunLtrDlH1Lh03WHVdztju++efLen3CiTz7VJJ7SDo9JUPDAP?=
 =?us-ascii?Q?aXkwCLYkYc3OaPWgZ+Q6UhBQixVHE2fHBZggIdFI1uFLhOisegARwUwOEa/o?=
 =?us-ascii?Q?1lZbM+jrl45cCN49kbN2q55fQ8L6N4uLisHcv6CSGLLoHoq6p4we66HQjadM?=
 =?us-ascii?Q?qOTFjAX4xJPml8gee3n/zpTizOalF5PTdmQadovRjeyV6PLUeo39o5LuiB/M?=
 =?us-ascii?Q?yxO8RbbAHD+9/8uEdX+v6WcxtOmTwEOoFBY1oWs/UpHmTEYrpLQOsmOgVJt6?=
 =?us-ascii?Q?7JJAIkpuLJ0jjZFvivDR5lQtk5ZYArAA6roE0dvO+nSq5QyWtM6DL0MP228k?=
 =?us-ascii?Q?juvYX1YL70vm+45yWJ+TsSwlVG3f+iG9mKvJHLJFKSQVRI/1go3F8i9UZsI6?=
 =?us-ascii?Q?HQ7zySUWGBSKeHohIHtwQ3XR4Uyr4P5RY286AaYYj96rU5PhR4W78c76Tt4c?=
 =?us-ascii?Q?0azy3ToTqMCuMirI4zj3NvboP7hfV/W0Xu6z74LC1XoGYdDbbdu0I/BVI/cW?=
 =?us-ascii?Q?CMVsKWdS3RcV1I9Sg5wrzT0vPM1Uupr6LW/5rfVF/otZFatWFDl5XI8XgUSN?=
 =?us-ascii?Q?13I/ASurqtKdB/XMhZf3YyNiLVenom7u8GZdYrhCPiuPwR/kcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 00:58:25.2488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d2ab24-ef31-4e92-74fc-08dcb67c0ace
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5652

Operating systems may not handle unexpected interrupt or exception sequences.
A malicious hypervisor can inject random interrupt or exception sequences,
putting guest drivers or guest OS kernels into an unexpected state, which could
lead to security issues.

To address this concern, SEV-SNP restricts the injection of interrupts and
exceptions to those only allowed by the guest. Restricted Injection disables
all hypervisor-based interrupt queuing and event injection for all vectors,
allowing only a single vector, #HV (28), which is reserved for SNP guest use
but is never generated by hardware. #HV is only permitted to be injected into
VMSAs that execute with Restricted Injection.

Guests operating with Restricted Injection are expected to communicate with the
hypervisor about events via a software-managed para-virtualization interface.
This interface can utilize #HV injection as a doorbell to inform the guest that
new events have occurred. This patch set implements Restricted Injection on the
KVM side directly into VMPL0.

Overview:

The GHCB 2.0 specification[1] defines #HV doorbell page and the #HV doorbell
page NAE event allows for an SEV-SNP guest to register a doorbell page for use
with the hypervisor injection exception (#HV). When Restricted Injection is
active, only #HV exceptions can be injected into the guest, and the hypervisor
follows the GHCB #HV doorbell communication to inject the exception or
interrupt. Restricted Injection can be enabled by setting the bit in
vmsa_features.

The patchset is rebased on the kvm/next (commit 1773014a975919195be71646fc2c2cad1570fce4).

Testing:

The patchset has been tested with the sev-snp guest, ovmf and qemu supporting
restricted injection.

Four test sets:
1.ls -lr /
2.apt update
3.fio
4.perf

Thanks
Melody

Melody Wang (6):
  x86/sev: Define the #HV doorbell page structure
  KVM: SVM: Add support for the SEV-SNP #HV doorbell page NAE event
  KVM: SVM: Inject #HV when restricted injection is active
  KVM: SVM: Inject NMIs when restricted injection is active
  KVM: SVM: Inject MCEs when restricted injection is active
  KVM: SVM: Enable restricted injection for an SEV-SNP guest

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/include/asm/sev-common.h  |   1 +
 arch/x86/include/asm/svm.h         |  41 +++++
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/include/uapi/asm/svm.h    |   5 +
 arch/x86/kvm/svm/sev.c             | 277 ++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c             |  44 ++++-
 arch/x86/kvm/svm/svm.h             |  26 ++-
 arch/x86/kvm/vmx/main.c            |   1 +
 arch/x86/kvm/vmx/vmx.c             |   5 +
 arch/x86/kvm/vmx/x86_ops.h         |   1 +
 arch/x86/kvm/x86.c                 |   7 +
 14 files changed, 407 insertions(+), 5 deletions(-)

-- 
2.34.1
[1] https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/56421.pdf

