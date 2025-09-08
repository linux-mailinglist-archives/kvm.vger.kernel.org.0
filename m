Return-Path: <kvm+bounces-57008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA41B49AD7
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE085208047
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A4F2D9ECF;
	Mon,  8 Sep 2025 20:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rIjBqD3W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A6926CE07;
	Mon,  8 Sep 2025 20:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362708; cv=fail; b=boorwm7zDqoH/cDcHA/o157QQoOV8PHl7QIMRrvb1IXmgZ7Nhn+vY5JR55Nmf/YexK+deGkN66jxa0VNzHDvmfx/rAbWSPlrLE+bKHv2FmmXZiuXDywnPSci7vCnf05Cn0eW85wB599vAjopa+QbRg9HlbNy1DVIEbj+Ptdg0pk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362708; c=relaxed/simple;
	bh=b06TgVahoNdIrCpukOGVEvs5lMH0WWbMMkeb8wp/JrE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YHKwEoWqKzf87Zp90VZCXmcZvbcIz8AphCnCxbGYFlYspja5dQd8bGmzUCfgB3YNtKMccBOjJc0IbkUIPiF/NAas6BxEzuXFa2JyQdQZk8VrtMgv9oflMrTWmbxl+PqfkoPRNAzGjB73ouuDbsVQrGWBuPCe3eXJKT/mo/e+dxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rIjBqD3W; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GThrJ8Fmgz3XO7iaW3KgUDc1UAc3Rmfezo+Ds58KMPX8Tgr7WJWc0oj9CHZ4MCHcbSVnGXir8ZohfLTMedJFxiHdqqIQF/RwWVX5jv44+Tx+J7exwDc8J+VLeLq+1jDkp2GEkC3AR7qPGy8xTFLOHD7wXs3vtqKENCRLuo0HR3lVG2BWEB/aQurdn5iavnq88ja7E8bFKtHUxRWbaIxfhGO1+xfyZQSFzYFu2ejDqwN/ikyj+/FRQmp+amEdpLNULFI3lmKoO26K1z0iOw+Ev+GHoHC4EkZOfELy+amufARN85hpO4yGgcsYuEPRGMoWibte15aTbhFXxAnWhXUnUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DWefOvmB68bvnzzG7KNwlBAl6aFzd6dOnVNg9kxwVk=;
 b=oQo77w8I3yn44LdbpRPJXw5snwf2/PyS2NHpJwQAD646FL6OWZgpHfZ3HL88lFSfR9OdQ7qqopdDToX0a10GY08oOAFRHWAWNckJOwEAHRKRCgMSnxgPEn2LWKvjFPTdNE1tm3U8kxEL3AHaWGpfHnv9SN9ckU2UXHKLCx+L8b1iYgITrZR/r8WP81G+yT3Rto3icLg7cO3GAdbj+udlsY7hcu14Ut39OGRux9DD68JSPCHdXg9gZHajecWI6xABL3lGo4TQkNHzeQLDJbFFO5pPafa4AloVvnzHhNWguaj8U33HYGby/DTsvCAw9v7dsn8ny1gpmJ9DcWECWTXbTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DWefOvmB68bvnzzG7KNwlBAl6aFzd6dOnVNg9kxwVk=;
 b=rIjBqD3WGku9aiBQzyBIMSVbB7jWKpCYjp7sEX0pQ0OywqeeK24aceWx7NCFFVQXtU+IYBfOohAd2sIr2G5NIo1r4+vBSyAo0I41SXAsChzQlRPrMRSwAPuUh6T4Lt8pxi/C7cfDXi2QfiGzrJhKG3biivxMkHyoHnj69MS5tBU=
Received: from SA9P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::17)
 by SJ2PR12MB9114.namprd12.prod.outlook.com (2603:10b6:a03:567::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:18:21 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:806:25:cafe::dc) by SA9P221CA0012.outlook.office365.com
 (2603:10b6:806:25::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Mon,
 8 Sep 2025 20:18:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 20:18:21 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 8 Sep
 2025 13:18:10 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v4 0/5] Enable Shadow Stack Virtualization for SVM 
Date: Mon, 8 Sep 2025 20:17:45 +0000
Message-ID: <20250908201750.98824-1-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|SJ2PR12MB9114:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b8d1ede-68c0-45b4-ee6c-08ddef14db29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6KvWY+dC6Yu4aOlMtWnbz9gLtLG61KoFiZxeZUC3oUvVlxEkJP1T3GvSI3na?=
 =?us-ascii?Q?LFj8ZY60Huz5mh8m7oO9cQAfBg+O1N2pS0UBX4mPERhQzv1r5WPBMsVtrlW0?=
 =?us-ascii?Q?APT1EWRNREN4TrnDyY2EQ1puEo2yCRpDe4avKyFBQPcS5XiCCO7uCUUDopFz?=
 =?us-ascii?Q?bW8HOupfdfecGJrV953+nxGBPX69yg0Eti6cSedaLwkfLwCx0wTU/og21hmy?=
 =?us-ascii?Q?1h6VwS/WIpLswA0rj70kQligKe0dSvquHgk5SQxDZyQVmHjpG/QdtI8SKkJy?=
 =?us-ascii?Q?6ppSP4S6q0PjSHT+GwfUIMGV3dItbbG9wYHaT/r2IWbwdgpeslvRpacctr8b?=
 =?us-ascii?Q?C37WixC1wrVtNfloz7z34VfUruRuxgRsah/Yr8nU+WNcW+C4o2OgYmYqghdh?=
 =?us-ascii?Q?lJkF6KCfa5f5OgFc0iJXhnKI9fchEd3ZsFkhTDfTcQawFvTpbY28x6YKYGFH?=
 =?us-ascii?Q?TZFx5nSEzozZN0UO1RNhTQ2m5b4qNKu0DdES+zj4x3zkJhSI4AEm3PJXHaL2?=
 =?us-ascii?Q?u0z55fxw+x02w99aAGznUrmh0RLN6FERYytBtHMP6K5iNH9erJx14sMHc8X7?=
 =?us-ascii?Q?L1FtHb9HTf2di1ORkzQpxrf1pXkqnYXRPJhoUz+36tXSfTfcC8vT91c09MZz?=
 =?us-ascii?Q?4PrQMVReRYPjgMNrTv3QwKeZAk3zaSNbSk+vrkCqC2h9FMLwOWTDfmjC/xHc?=
 =?us-ascii?Q?Ux0EnMdMGPeYk22oq/2HWIjStUhwMdLmqe++Fqvzo7fE/0weHwBC2IPs4Z6/?=
 =?us-ascii?Q?2rYhWlgIL2MepOzrUeou4+GS4RoQt3MNDtFT81s4Fik43Rt5OAvrTFmt5QFG?=
 =?us-ascii?Q?c4JJhceFwL16fvHxduaUg9MeWFJXEN/sSOew/d544T+1v8NFkhaZimKqGap5?=
 =?us-ascii?Q?9B/LmvSgaJ4vbLnJ0WzhXJt3NzkjHpqfUoETwyjOEhvUt5Nd7AoBnzJ1Q8AL?=
 =?us-ascii?Q?050FlSHo/Y7lPfFv8VJhvxyWfqEeI7Xp/bT8c2fxaRAZgKP48rQWFH7xNZy+?=
 =?us-ascii?Q?Ut+byInHflZVOwx4hgyB50+TGu2gI20wULTFhV72sTIas9FUTUJihhqs1lAh?=
 =?us-ascii?Q?b4IVKFjDIKI1DdtYCMd6YOGkNrULmW7s9w1JY8YxzP3dmJcyFREtF1KbYuil?=
 =?us-ascii?Q?U8yuXm5/GPlaqBZEFpYvMcyLspj/RX1NcMBrttBoyMgaBwQ4l8rFss9rH6rY?=
 =?us-ascii?Q?MBWIVuIjX4BLfoZ44kP8gPIvoJSxtwEOFj62u48qfM1q7tL5T379iFCAYv1t?=
 =?us-ascii?Q?MO8y/ePbFPfB9IqnRcRmTAMgFApNLOOa15Z7GuyBhUAQuK7HqQ9+elOiR1HD?=
 =?us-ascii?Q?27lZlfuR9+G7rLQoAaavu6OhPEeEaMyFpUhY6vu1N/PtN3j2xQcgB071pfl+?=
 =?us-ascii?Q?3rUAn2Ca0a2hYkZrsFZTWI/wjc3qZHiSCZthyJEwGZJOOHQ3su49h/QIe4nO?=
 =?us-ascii?Q?2+2ZKdPjMw2Zt6ztqErF4yBSrIyHJi5xxVtB6LofQT8DQsmRgCW9XXw+mG1n?=
 =?us-ascii?Q?x4YzgOn1T88UtjOT9iLcY7T8aqS85pKtlN89P/1bXHDOHsK3U+uXqHs8wA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:18:21.1073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b8d1ede-68c0-45b4-ee6c-08ddef14db29
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9114

AMD Zen3 and newer processors support shadow stack, a feature designed
to protect against ROP (return-oriented programming) attacks in which an
attacker manipulates return addresses on the call stack in order to
execute arbitrary code. To prevent this, shadow stacks can be allocated
that are only used by control transfer and return instructions. When a
CALL instruction is issued, it writes the return address to both the
program stack and the shadow stack. When the subsequent RET instruction
is issued, it pops the return address from both stacks and compares
them. If the addresses don't match, a control-protection exception is
raised.

Shadow stack and a related feature, Indirect Branch Tracking (IBT), are
collectively referred to as Control-flow Enforcement Technology (CET).
However, current AMD processors only support shadow stack and not IBT.

This series adds support for shadow stack in SVM guests and builds upon
the support added in the CET guest support patch series [1]. Additional
patches are required to support shadow stack enabled guests in qemu [2].

[1]: CET guest support patches (v13)
https://lore.kernel.org/all/20250821133132.72322-1-chao.gao@intel.com/

[2]: CET qemu patches
https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/

[3]:  Previous SVM support patches (v3)
https://lore.kernel.org/all/20250806204510.59083-1-john.allen@amd.com/

---

RFC v2:
  - Rebased on v3 of the Intel CET virtualization series, dropping the
    patch that moved cet_is_msr_accessible to common code as that has
    been pulled into the Intel series.
  - Minor change removing curly brackets around if statement introduced
    in patch 6/6.
RFC v3:
  - Rebased on v5 of the Intel CET virtualization series.
  - Add patch changing the name of vmplX_ssp SEV-ES save area fields to
    plX_ssp.
  - Merge this series intended for KVM with the separate guest kernel
    patch (now patch 7/8).
  - Update MSR passthrough code to conditionally pass through shadow
    stack MSRS based on both host and guest support.
  - Don't save PL0_SSP, PL1_SSP, and PL2_SSP MSRs on SEV-ES VMRUN as
    these are currently unused.
v1:
  - Remove RFC tag from series
  - Rebase on v6 of the Intel CET virtualization series
  - Use KVM-governed feature to track SHSTK for SVM
v2:
  - Add new patch renaming boot_*msr to raw_*msr. Utilize raw_rdmsr when
    reading XSS on SEV-ES cpuid instructions.
  - Omit unnecessary patch for saving shadow stack msrs on SEV-ES VMRUN
  - Omit passing through of XSS for SEV-ES as support has already been
    properly implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
    accesses to MSR_IA32_XSS for SEV-ES guests") 
v3:
  - Rebased on v11 of the Intel CET Virtualization series.
  - Split guest kernel patches into a separate series as these are
    independent of this series and are needed to support non-KVM
    hypervisors.
v4:
  - Rebased on v13 of the Intel CET Virtualization series.
  - Add SEV-ES save area fields to dump_vmcb.
  - Don't pass through MSR_IA32_INT_SSP_TAB.
  - Don't remove clearing of IBT capability.

John Allen (5):
  KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
  KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
  KVM: x86: SVM: Pass through shadow stack MSRs
  KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
  KVM: SVM: Enable shadow stack virtualization for SVM

 arch/x86/kvm/svm/sev.c |  5 +++++
 arch/x86/kvm/svm/svm.c | 43 +++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 46 insertions(+), 3 deletions(-)

-- 
2.47.3


