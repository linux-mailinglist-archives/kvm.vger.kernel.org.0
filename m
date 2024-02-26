Return-Path: <kvm+bounces-9998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DEC868324
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 455131F27326
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0A6131E30;
	Mon, 26 Feb 2024 21:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QiSCjg1v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755A012F388;
	Mon, 26 Feb 2024 21:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983189; cv=fail; b=gnehmv1XIzJQK1kCPTys5Nd8jp54Ikmcn70ncZHfz3E6N6UMEuNVMdGnKgsUZeO8E+M00Jw5gY7v9DLML8TOb9CIFwWV81EP+q3ftb58QUxmTryfyt9QJeTQoNjUO13ZU3FRod0ShQp6lA1vDGjDXXlj84Hz1pYnuXUAge5yRB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983189; c=relaxed/simple;
	bh=oVa8hClrPildBwz6HTLTjPCEromLMSzgFfQ2mx/GI5w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cuhvYNMdlXPtaDl/fr6N4MBwO0x27wlSkVMuBsHLfadlGF7j3cjewQCZL/fM/PB6U4rTs1d3s3SGZ+3uaVVVRo+fAX4eES29kaKQGt4ysYdM99mwrhXvr/5wbsyQbE4QAIhV7UUaYFe11UJc/D/KcRB3mnhkR5MTMGxAveVJLaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QiSCjg1v; arc=fail smtp.client-ip=40.107.220.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMU9zK61bx5Oqh0SVp+FO+Ldj1oARlH04SZO+FI2rJkj5pKyCbvRsKXIxtau0/+68PwnOfVAvbIncZB9rKr3UguWJ0fLz8NrUIl9n8Pv28yoRnXArFCOG4y/IcFvCeIrLpRErPF64WjrLVoNPWpsHVRP1Sqwg4l797IU2ohWuQZ6GpY/vAxnqV114dJPClA9FnEN9XUJi6q8wwhpDPp7Kz6JBlIhKje5OI31StvV7x6SbECHW4D1maeI7fTjtTH73GR4C47J3fIGLhb1YriYFmr6ONkEjxRFrriG4lL4mHhQyNEr/5qZH5Go/3VP1+CxRwEtWGBJugTUvV6cK4QQWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cIoK8aelrOdPlmMtKKsKtDTk66qMx7hxEL/WyskVk0o=;
 b=e4SJyfNMSR70O9CC0KEu0iwc0cYi6j8Q/NbewqXS1sgKHvvubt0jIUtqMWny8miwYUHfic0UcMckPCFk+5CDaZimcs0Yxqed9w5BiB0ulas0VF8W1zzetTYq7t9Fty6OXxy8vxkUEH8ooPp2no4omRMYM6xJG3QoFBA3YJLOGSibxS6p82H9CaBQLlgce+oFbH04MV8qoT5bplSAouHFpdbT62qzoHRChbRxKBrhjTLbMbTHIRvmfgKl1ZSs4UkRR3phTOWhkvMCm3LL99zfPCXxHhAdVN7AauYqwJ4C/wFQr/BqOVpgpBhKzSRWvy1U/dh4FyFvSgWiBg0c1tprUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIoK8aelrOdPlmMtKKsKtDTk66qMx7hxEL/WyskVk0o=;
 b=QiSCjg1vr9LAOzbQOU1vLguZsGNyd6p29taGjrExK+BI1jbbSbdrM60HQionIhoy3FvgYkJDXthEVXbyOgNG2DMefBRzrgXUkcEJx/ooyBxBn2oFdAa1plct0C2ls90cUoaeP2w0kEH55ym+x6u0bwc6hRe2oKlKDhPoZguBgBY=
Received: from CH0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:610:b0::17)
 by DM4PR12MB7501.namprd12.prod.outlook.com (2603:10b6:8:113::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 21:33:05 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:b0:cafe::8b) by CH0PR03CA0012.outlook.office365.com
 (2603:10b6:610:b0::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:05 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:04 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 0/9] SVM guest shadow stack support
Date: Mon, 26 Feb 2024 21:32:35 +0000
Message-ID: <20240226213244.18441-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|DM4PR12MB7501:EE_
X-MS-Office365-Filtering-Correlation-Id: bb029737-e9ff-495a-3e03-08dc3712848a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rrSdtvAFCzvbIueju+8XINMcwVSCtWDgWckCiL3gjSp5KCbhe7W2MPxjShbZ3g+uk9WG0Wx8WFKv5aZrUVwgVRTpTtvabH+ZZLVnnfUi+6wY0a09veDm8LyHFRmmnNbSyybiopiaxKXgzWZXC1b/YvLcuhPStgC1qLs8g1OwGQItbd1OlYBX5kSc1Sm2Sj/VoVCWb6AMBv00YxrbSvVl7p58AhSbN/4vPZh8Da+d1N8qfBVBDaPwM9K8ej7LrVyrfPvnxA4Opp0J3Q5JrfJ8xRWN+ExbKR9ZBqTZqwefF/JwZpIZEUevhKVPw9DcY+4wBqTliFt4h369PtHng1jTqmyxO2cCUPDPycJlgjPglBifye31Ya+1/WDLm/a0HoiPtWScGjj3D1SicBczsN6w33zIMJ8FHk3+/Fy1656ClsFJuVGwJJyytkVYW630iZJkav9ycQ+IXwFJdTwarngP9FTAzVq7bWWK3iTLiHS7Ns2lDVO061cyYUE0z6O9PnfX4rg8GjG8NkbrDkSAso6qntxUA8UJ+nMnGUQrcnm7r0Lr/16KRSFT5baDWnd5ywT5X4ImTLebecTf95TWq35EsBxhYMQ8K4oAyJti8+czRebf2aLvfeLI8Z0ZjiiAi9L4Gn7HN+ZfWJL2vqQiNq2CXdNho33pWhJbABcOP07/Q+zGSi0LTxI8en5zYv1ZC7n+jU+ykhRCXMvBO4ZEBPiArdP9vgMCtaFzCtjuhIcsecoZoVkI68zug9cxVXWkzG1T
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:05.1734
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb029737-e9ff-495a-3e03-08dc3712848a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7501

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

[1]: CET guest support patches (v10)
https://lore.kernel.org/all/20240219074733.122080-1-weijiang.yang@intel.com/

[2]: CET qemu patches
https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/

[3]: Initial SVM support series
https://lore.kernel.org/all/20231010200220.897953-1-john.allen@amd.com/

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

John Allen (9):
  x86/boot: Move boot_*msr helpers to asm/shared/msr.h
  KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
  KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
  KVM: x86: SVM: Pass through shadow stack MSRs
  KVM: SVM: Rename vmplX_ssp -> plX_ssp
  KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
  x86/sev-es: Include XSS value in GHCB CPUID request
  KVM: SVM: Use KVM-governed features to track SHSTK
  KVM: SVM: Add CET features to supported_xss

 arch/x86/boot/compressed/sev.c    | 10 +++---
 arch/x86/boot/cpucheck.c          | 16 +++++-----
 arch/x86/boot/msr.h               | 26 ---------------
 arch/x86/include/asm/shared/msr.h | 15 +++++++++
 arch/x86/include/asm/svm.h        |  9 +++---
 arch/x86/kernel/sev-shared.c      |  7 ++++
 arch/x86/kvm/svm/sev.c            |  9 ++++--
 arch/x86/kvm/svm/svm.c            | 53 +++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  3 +-
 9 files changed, 102 insertions(+), 46 deletions(-)
 delete mode 100644 arch/x86/boot/msr.h

-- 
2.40.1


