Return-Path: <kvm+bounces-57526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F39FB57403
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBE4A17F578
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90952F39B3;
	Mon, 15 Sep 2025 09:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MW0PYxrt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED5A20B81B
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757926807; cv=fail; b=rq3FlUoPl8XKyYA34pWsJUmZ1fIcextznSBmjB+oYd7L/sRmaJerdcVNuBT8FXwcSFYHvE6q6/6hBlpLM6zcM6dfAXiitAw1KYWuVdyTSLDqNuRXWjHkY9XiwBQZKfccfpm+5HKn/00MYBVTo/hsYtvLiw+RgdJzmhcbziu5xGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757926807; c=relaxed/simple;
	bh=kGLmsGKsmbIpz/Mt0wfmQW5AxrIJqVPpHTjjUvdWmYk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y44QfaZCVgQ/IkV8m4FTIxeHx5JE+AE5z/XauiuXi49pyGUiPbq7dbw0fSzX1+6ck9P/z38ta7t+i8h0DIYScsL1TdUxPim6cpO1Wo0rZlkYCOtz4d/SXTnRowfUrt9w28SwFKNAAIPsgK/B4XH6HrYVYaa9x3XNY/cJ8n7riHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MW0PYxrt; arc=fail smtp.client-ip=40.107.92.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUvhYFEDycyv7wAAxEYUiDyuQQ8nTO9yvO4hbhoTjeQCXy+/4/IJz/GUALJJkiBaGWXNep81Cvtlqgy7wCpUHE69QSV4m3rYq8DiyBrMyCj3ZoNRJh9kxC6ZHcvEwUzMSRPs/kCPIqX0cx7vzAVKI6JLrdBt4PH0H4ncAaAof5Lef5lYfVLczfGyg/Q7kZwVLH9KfjJSdvwMF+sQphy0/9skVoBRDfBbf+zdJG+7wRnPPgsIcfPt57awgF1KEuPbeBiI8+GHofNR6tPUttbIB0J169uqPZDGGKfV0y5GJ5SNuNM5mwwIRAQEIW86pQo859QrRjITEYnIGMXJ9cx7SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ogT+d5wz5fOLQmj92byw0azTxn8qV1WKaCzp3zYfYc=;
 b=y2InEdt7+FrXUeF4YF7pXQLTplO8dtZ1iYfGFX/H8LY2GJiVZ3f3CjOcT4zsUrud7M/8jofBaGXKUlQEYFmPO2DgPFfr/vAcjFY0Z2YnZ5fAdO56YlPeSX7nfZSRObgqmI92XWJj7N9rAdNPMtqfECoHJmfrAh+Iu/4qDzuWzejvu69VZWxyyg3Pf9MEy6nEwsFd2GaBbyyXtKEhURdF4KwkGWMdXIxDsbAjy6ydtqV4/8SuzYRLCTgaQxKegU6Vq3pp3ZbiqNoAO15bNjStJD5cnbUOZPAX8kXYoiCLrdNavCUMcnjW1zZ5tQ38sEmxbr1s78Yt29e1D8hC8peQ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ogT+d5wz5fOLQmj92byw0azTxn8qV1WKaCzp3zYfYc=;
 b=MW0PYxrtL8eFwdAssFKApwrDQj+BRWGOeP7wq4rQ1D29PdB+pHpMt0H31vx94oGNMWYrHIzbhA0maD2Rp764wv9S6FvIgJ7L1gHQgUb1DB8/coolW6f9IfW9ePzLJRc/yD6Ggxm6gtxug2famTkmwTb6adwreUsbK6nNbBuYC7c=
Received: from SJ0P220CA0004.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::9)
 by DS0PR12MB9726.namprd12.prod.outlook.com (2603:10b6:8:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 09:00:00 +0000
Received: from SJ5PEPF000001EC.namprd05.prod.outlook.com
 (2603:10b6:a03:41b:cafe::ce) by SJ0P220CA0004.outlook.office365.com
 (2603:10b6:a03:41b::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 08:59:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EC.mail.protection.outlook.com (10.167.242.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 15 Sep 2025 08:59:59 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 01:59:54 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v2 0/4] KVM: SVM: Add Page Modification Logging (PML) support
Date: Mon, 15 Sep 2025 08:59:34 +0000
Message-ID: <20250915085938.639049-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EC:EE_|DS0PR12MB9726:EE_
X-MS-Office365-Filtering-Correlation-Id: 3618e60c-be6a-45c0-cb34-08ddf436402a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6ofKI8tQ4c6XrOcP6eMSC6MVPCprG8KX9A5uv2lLdp+juwhiQ32AEr9T6WDy?=
 =?us-ascii?Q?48QBYu9b76pyGY0ZzjIWK3Q0Y53n3BvFAIv1IksySzZiZS7yz+dA1Me7cJPH?=
 =?us-ascii?Q?ee6sMRLeDl+wXAehAlAhQXFBjiGEEfmFnhUJkSbfTZetB7kftPHBNfauvf9E?=
 =?us-ascii?Q?ia3xLZHwwgwbWJl6ryW7JsiINHzBfctgUyLNLcfpF4jAVrW6e65sRAZJXEN8?=
 =?us-ascii?Q?evZQaw+r7Ti2aif6epRMwQBD3Wi91xnW7egdlucU9CdgXlhPhE09B7EOLnT9?=
 =?us-ascii?Q?uZ3QLfxEaERa/eeY9XQqzSPGR+MVck9T6417ZeU0s7XYw1l5IHFbELENNkaU?=
 =?us-ascii?Q?34RgRYxTblHmSNZKWHXSx5Yra9dKbeaGlPYEH/hDW7LaIhTzcObprG7oFeCY?=
 =?us-ascii?Q?eyYzvnVnbK7DfBe6gZqaqlFlKEE9yYtoQDlLdxWY44trojY+MlJDMk2ihHYb?=
 =?us-ascii?Q?XnRg7JknOpWJVj/ipK7xUDJTu3O9DlW9eCtbaO41O+5p0shIA5pfT+cdcaE1?=
 =?us-ascii?Q?RjhjdjiHe6Su2sBmCtVqGHWvhHMm4AB776Fx/hCQAkBOUyjJ7l0z1bITEpNs?=
 =?us-ascii?Q?uuZnTH6CrypEzSjaM0e9FH1s34tJ4RcAAaGRaMgxDHRnNSR6eGqqvMQgLV4q?=
 =?us-ascii?Q?qqUuf4ZcNrc36dWyqFYMGPFFztLNSlTH7c83G+6BIrh1PrR8GNMFelT0NbT7?=
 =?us-ascii?Q?LSGUI9B3tC2Xiwb3tmC++jiVajV4hZoOSuQKIbiKkMVk/s4zlM4DlAtF7Ui0?=
 =?us-ascii?Q?q0owPtJs0eFndWX/Zm8bjuR0c2sjeBnxlF6ci3Ku754KSDF74zLvA2NzSwRu?=
 =?us-ascii?Q?5Gu2PwYz1rGGsNYMZzibl89RfKrArQdPsMHCbTNRbusQyWCO5paoVqh/GN+3?=
 =?us-ascii?Q?LOOzy7ORycvizkNv8kyw7zv0ZQELCY0Fukt6ftbruCpb4wWb6KqTyvjLR7Yt?=
 =?us-ascii?Q?ll6Amghrlo0kum4qCDa6a4VWONgYlW/6OQ8LsRRaLIz8L+T6pyzLb927KnK9?=
 =?us-ascii?Q?PFr5z6NsMDAC0r3MrfN31fA7j6NFOXsdI49JUEO7DZdxdq7Ndr9qbsCO1BCi?=
 =?us-ascii?Q?TJBettI7AFI4VHtsapKiFUYPUqrYYs8wmz4WQHipJbQoNXoz8wZsvhyPv4uT?=
 =?us-ascii?Q?lZmAgyz1DTh74ATZ4SbzvdezMoavTaikIffLM9WtC/OQGup0FPbVPVncAjY+?=
 =?us-ascii?Q?q0EPXYITB5eHw39Hz7W0Zf9bQwrxlwiAbrbf4FjZb5eX16dmDGHpcdEfPwVF?=
 =?us-ascii?Q?ArLfSxnagrlZ5Wqhi+IGXCzY1S+D7Np3uPnWFCWGygiPZps4y1SMVRUZv8Ym?=
 =?us-ascii?Q?ulHVykDPnMvX0uz0iZrYHr0A6/UsdqKWWCqeHhoC1t9fErxRankEO82nnQJN?=
 =?us-ascii?Q?WbGFCwn3LZ+dsQLItUIeD2clVwcqaICoZzmZ65FE8Lrg5K2RvaUFoiPfPwFB?=
 =?us-ascii?Q?rNzid3XLhjA1drYNEUIISBftl5HEzMyie+3wyde2EdpPpeJVnFnD+A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 08:59:59.7113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3618e60c-be6a-45c0-cb34-08ddf436402a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9726

This series implements Page Modification Logging (PML) for guests, bringing
hardware-assisted dirty logging support. PML is designed to track guest
modified memory pages. PML enables the hypervisor to identify which pages in a
guest's memory have been modified since the last checkpoint or during live
migration.

The PML feature uses two new VMCB fields (PML_ADDR and PML_INDEX) and
generates a VMEXIT when the 4KB log buffer becomes full.

Patch breakdown:
1. Refactor existing VMX PML code to be shared between VMX and SVM
2. Prepare to share the PML page in VMX and SVM
3. Add AMD SVM PML CPUID
4. Implement SVM PML support using the shared infrastructure

The feature is enabled by default when hardware support is detected and
can be disabled via the 'pml' module parameter.

Changelog:

v2:
* Rebased on latest kvm/next
* Added patch to move pml_pg field from struct vcpu_vmx to struct kvm_vcpu_arch
  to share the PML page. (Kai Huang)
* Dropped the SNP safe allocation optimization patch, will submit it separately.
* Update commit message adding explicit mention that AMD PML follows VMX behavior
  (Kai Huang)
* Updated SNP erratum comment to include PML buffer alongside VMCB, VMSA, and
  AVIC pages. (Kai Huang)

RFC: https://lore.kernel.org/kvm/20250825152009.3512-1-nikunj@amd.com/


Nikunj A Dadhania (4):
  KVM: x86: Carve out PML flush routine
  KVM: x86: Move PML page to common vcpu arch structure
  x86/cpufeatures: Add Page modification logging
  KVM: SVM: Add Page modification logging support

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +
 arch/x86/include/asm/svm.h         |  6 +-
 arch/x86/include/uapi/asm/svm.h    |  2 +
 arch/x86/kernel/cpu/scattered.c    |  1 +
 arch/x86/kvm/svm/sev.c             |  2 +-
 arch/x86/kvm/svm/svm.c             | 99 +++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h             |  4 ++
 arch/x86/kvm/vmx/vmx.c             | 48 ++++-----------
 arch/x86/kvm/vmx/vmx.h             |  7 ---
 arch/x86/kvm/x86.c                 | 31 ++++++++++
 arch/x86/kvm/x86.h                 |  7 +++
 12 files changed, 163 insertions(+), 47 deletions(-)


base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
-- 
2.48.1


