Return-Path: <kvm+bounces-32610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2A99DAF5F
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82D85B21C6D
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252ED20371C;
	Wed, 27 Nov 2024 22:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="O2O0A1xF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7538913BC35;
	Wed, 27 Nov 2024 22:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748167; cv=fail; b=lhBYyaNXJA0CtJ/kvBV8i7QD51LOBDfxCr3AHqQVYZ1THisdI0atWaf+eKe+zEMDLUiGJhGPHV9b/n0DkzG/pkT2dy/Z2teAedXkXHMoRIEeK9dN5LP/rUDu0crgiVJNXzON0LSoGFvPGwHntkFJdRXq5o/axvNJdwQ2iFbHKrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748167; c=relaxed/simple;
	bh=0XFXdmRdxdcFzr3/76Ag/yTmy1oZdFUy6DKzlF9ULpE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h8ko8J6ZSciXcbfBWjnBPdQlfgZ7EFt3BwSRXuNynVcJjBn+UKKy4z0mU0+2QAxyb2EU4d8pkWTB+3gxCprwYfUQR/o7y1IW0WfTZIb8qVWrTt+3Rxgn+zJHOnAD/d0iba2m8ILpQiwh0ItcytjKCbSxBcXd/yaYYjdedNDrLHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=O2O0A1xF; arc=fail smtp.client-ip=40.107.101.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGFjK21LS28lp510OQxs5SC9joA+LbRriewjramoRluODQWinZokxyQ8CwsAg8ImA6jx+GTMCr+TV+LLL+Icdx/UmZzD6CZT0R8dW3VOKZWuT8dfiq7RHfpMjsWpFPf9EOnIX0xVrnDF9y+yjPyxJdvgJmbvA1/rqdYhYVr1QjZGoJKyvz8qQxtMlWB3sfkiUP8FrbLBrHA/BdZ4XHQHW6+ScBONdOerErbFzqnwpAw1ga7jkj2BHcwKkRJrFZSNdxlD6O+YyNYNfaVSfkkk/BnK5ar56+RxItw9NIhpBNVtbAqdAQefVeE2Lmr2RPQdgTmPepanalJV3KAp7liQmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3AENNWLv+G08/F8tiP/6RTTA/0px26Q1rRorYl61z7M=;
 b=EwLndnDab/p8Z1rF8cd/1sibNnVzJEUU6rlGoTiYeJRYvjTDUhUuOfAuW5sr2cNnkccHsYD32Fq2gcoNNRhnZI6iW6yrWVfcxAIT5i/BOAhu6FV3smOlhbyeUtp7UbFJZgmX7fTfQa8U10qFy9tT7WmUFHExTOiICtEK54bAtFqGb1SBrCj1JjGNDV7U0k4cnxlan4dSN+9mp9b777F7jqklMMagGv6HnbwcFLJ2YjonidB+k6kdLhNAuD5YexttPRDu9eEYVLER6gXvfBhjh+nnTV5EFuwlZD51jtRSJVITKNmOKbiQmChKshia++4bYf+DWk5ah4P4yNilp53jbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3AENNWLv+G08/F8tiP/6RTTA/0px26Q1rRorYl61z7M=;
 b=O2O0A1xFYKa5j18ACvqPfgz89PxWpYMWY7w8oafa1izkY+ckEkHRkikUiOsWU5RHSTE7015vchPUvdRuocvmwJN94XhCGzX6I8Ya7Wd1lDwnEJLuefsM+soMqFLgQ5p25NyRJUSKlyOtRoZaWUrH+RTz9oCx6TseueAJLLRgoP8=
Received: from BN9P223CA0025.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::30)
 by SJ2PR12MB8110.namprd12.prod.outlook.com (2603:10b6:a03:4fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.18; Wed, 27 Nov
 2024 22:56:00 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:408:10b:cafe::7c) by BN9P223CA0025.outlook.office365.com
 (2603:10b6:408:10b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 22:56:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.0 via Frontend Transport; Wed, 27 Nov 2024 22:56:00 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Nov
 2024 16:55:59 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Neeraj
 Upadhyay" <neeraj.upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v3 0/7] Add SEV-SNP restricted injection hypervisor support
Date: Wed, 27 Nov 2024 22:55:32 +0000
Message-ID: <20241127225539.5567-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|SJ2PR12MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c799232-2faa-4182-d607-08dd0f36a999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wc+sBVXdSOF2KP6THtutyEAZ9tMSUFaly/rkcsYTcWASl5dDZcylleQ2e+1n?=
 =?us-ascii?Q?nHfJincW/BK2DGn8dsaCTWYAFCn4dZnx0MXyDf/j74MCHRps+dLjtt6BPi53?=
 =?us-ascii?Q?oWZidMcdOZeqLtx62EP869UF7XFvr2w7n9oOZfyJF+6dTuArNChTOzw6j7iZ?=
 =?us-ascii?Q?WnYETQwzYruLdy2JnKTEQ+81ipOyWAbCix8U7KCWi3My6zXc3kaNgB4MEapE?=
 =?us-ascii?Q?+DVM+WGefp6RPN0LEACzOMCVXij8GJe2rL2StFG9NLmYPfCuWWBH/COx6Ia9?=
 =?us-ascii?Q?ywuQ/dCukAPbZ6j4FLdQy7j0QlMvHEyWCSWu1DF4oejk7qWdiCMec8obFVxY?=
 =?us-ascii?Q?U2I2rGq1MZRNG9ls/rxUvbgGmz7tsH8Ub/ekTKiXcw2cNT4gucdZie5nuT5I?=
 =?us-ascii?Q?OQpXQlfSJZ7c3GT/w/0Db4D2dO6g9kv+cxQG20gBeRDtgUnCuCEGOImcJpa+?=
 =?us-ascii?Q?qkD45y6R55kBuG1KMCypjAiUAl+fT3GQxPa2OoHhvtV51aCfNlhGHYLnsKo7?=
 =?us-ascii?Q?kdjd+/SLCBB7BlTEZEFo9UQKkDeroeOAJjQdZd80WucR+34/h6fTEpYKz+8u?=
 =?us-ascii?Q?kHDL4LE0bNgsgliYe48l4vImSChKV+q0BBTfYpMkzlaAJDoF/KldeR4pNec+?=
 =?us-ascii?Q?onbWFeiXAfSijOCSn7frjUrZ5+qToWuHrXqnPO42aV7TbqXDnsIT/C4UOmQR?=
 =?us-ascii?Q?xhPc1OpJhmyY4tJ0Uh/bUFc/QcVVvs0DyqYRVMj2u82EaMIIOu2xpRJEkFfW?=
 =?us-ascii?Q?SwbDo7+JpdJ/za4dO/b7Ke2xlEB4X4RVXd/XkJvJHIGiIpaaUbVDMAILFvFP?=
 =?us-ascii?Q?Kp6ZpMTc2nwxz5pOPym4NqeJOm29yryjXE30NKLA1gHDOQcET4EusxlRTFUI?=
 =?us-ascii?Q?TN5FiiOsiFvUnrQ/siuM/I56Pq8QIo/wEX14xLmsvRjf+5FsQz/wO6rbRM+y?=
 =?us-ascii?Q?eU4Xbf8d4oHBCGVhtUgN081mQPvZmCxLH4RPzBr9pa2i6GjJctHoUYKCzNmw?=
 =?us-ascii?Q?DqeSHSikEkqAHbxJfTcsEeLjBjrBNMVeakdY5YYp5afFQN4SHSKerifk61NF?=
 =?us-ascii?Q?n5JKTZBy4PAFcmO7pqz+tMiOv7muwGC5C780uQMnnGqWmRNRexXcPIluMjI/?=
 =?us-ascii?Q?nF5W7JL1uEXwYHMWWMetTqyTDlF6i3a0i3dKytvlb/96F3xsjkr1+EA0A4Pb?=
 =?us-ascii?Q?8YqP5puSbF05xoT63mfV/WEtYcnG1zyaRaxWjU3lkwBTlrUY6dP+8bQK6n0d?=
 =?us-ascii?Q?StjSHDhzkZS8M6kJpx4OrdHRU+H6zT5Ike9LwFnoDx77UT4Hve4yqRXpq08W?=
 =?us-ascii?Q?ZPRbiorcZ8vrd9lr4kiphmDdsC4eLG+XuN2YSUbobAzB9iU71JCW7DZgc4J7?=
 =?us-ascii?Q?rhft5YDQjs2cEqmEw/d8z/ztz+Wn+8XI/J12keMNWZwORup5Og=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 22:56:00.3779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c799232-2faa-4182-d607-08dd0f36a999
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8110

Hi all,

This is v3 of the Restricted Injection hypervisor support patches.

The previous, v2 version was submitted here:

https://lore.kernel.org/r/cover.1725945912.git.huibo.wang@amd.com

Since then, the series experienced the following changes:

1. Remove unused field in struct hvdb_events. 

2. Add comments explaining sev_snp_blocked() with no_further_signal and vector.
   Explain that only a single interrupt vector is presented by the hypervisor
   in the doorbell page. Only when the interrupt is acked, the next interrupt is
   presented.

3. Add warning in sev_snp_cancel_injection() when vector is not #HV_VECTOR.

4. Update hvdb_map() failure handling. When it fails, no interrupt will be
   injected.

5. Remove sev_snp_queue_exception() in svm_update_soft_interrupt_rip(), since
   the soft interrupt is only BP_VECTOR and OF_VECTOR, so it will always return
   false, then sev_snp_queue_exception() will be executed in
   svm_inject_exception() always.

6. Add new #HV IPI feature in XAPIC and X2APIC mode, test each mode with three
   IPI types: broadcast, self-IPI, and allbutself.


Changelog:
----------
v2

Hi all,

This is a v2 of the restricted injection hypervisor support patches.
 
The previous version was submitted here:
https://lore.kernel.org/r/cover.1722989996.git.huibo.wang@amd.com

Since the previous submission, one issue reported by the kernel test robot was
fixed.

All comments and review feedback are appreciated.

Thanks. 

v1

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

The patchset is rebased on the kvm/next (commit 15e1c3d65975524c5c792fcd59f7d89f00402261).

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


[1] https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/56421.pdf

Melody Wang (7):
  x86/sev: Define the #HV doorbell page structure
  KVM: SVM: Add support for the SEV-SNP #HV doorbell page NAE event
  KVM: SVM: Inject #HV when restricted injection is active
  KVM: SVM: Inject NMIs when restricted injection is active
  KVM: SVM: Inject MCEs when restricted injection is active
  KVM: SVM: Add support for the SEV-SNP #HV IPI NAE event
  KVM: SVM: Enable restricted injection for an SEV-SNP guest

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/include/asm/sev-common.h  |   1 +
 arch/x86/include/asm/svm.h         |  33 +++
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/include/uapi/asm/svm.h    |   6 +
 arch/x86/kvm/lapic.c               |  24 ++-
 arch/x86/kvm/lapic.h               |   2 +
 arch/x86/kvm/svm/sev.c             | 318 ++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c             |  41 +++-
 arch/x86/kvm/svm/svm.h             |  26 ++-
 arch/x86/kvm/vmx/main.c            |   1 +
 arch/x86/kvm/vmx/vmx.c             |   5 +
 arch/x86/kvm/vmx/x86_ops.h         |   1 +
 arch/x86/kvm/x86.c                 |   7 +
 16 files changed, 463 insertions(+), 6 deletions(-)

-- 
2.34.1


