Return-Path: <kvm+bounces-26199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5382D972935
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 08:04:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7A031F26218
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDEC175D2F;
	Tue, 10 Sep 2024 06:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YwOyIlfT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D9213AD09;
	Tue, 10 Sep 2024 06:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725948240; cv=fail; b=oN87h1Mjx0ia8hDqpC03fgO3XG8lfvfzurL1y/vaSWXX7UG6jbmOBNvws2ScugeqN1rWCPW4u86mKnuPkkLVL/abRbeSHakDDSHpIIs81jjpfLfTTFMRPgBsnPlOoj+6hfmiflNA1zrSHg/zZJyeydHRI29IfMam4P/qUdE+oM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725948240; c=relaxed/simple;
	bh=6tC2uBIAAOP/gckKDLmvJh4Po3Nv4AbVmmFCkDBjzjA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DKjdhC5m4JL2IF5sJrn3nN56o9IodqagDZOb1fuSuc7HxuyRBMeLxH+tTom17Tr6fcJKIjCQQ+fOFeV/OyiElrA2I65niYnUa8Z0dZP2LftbBMHrG2k9vY4560Pvp5pI632Q/n0v3aLS7A+Wrbypg8Lb2Gw2Amo69C23R9RJ+I4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YwOyIlfT; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJgsxi08urGMmSBhkyqLL+TuZCXSnVzwtvzIeRZM/+bGUufeayFmRCxcUm2EpyFkXmd9QeHVdjlEwr5k0nAGo/d4HLhglE9RehfeCeD0uzA0i5zQ3ttDOBQHZvolbYw47iGunVYCvaRpd8p0zBpYhfYGud8R7NkRmJbRuZtRO7XUlfJjDAQE612t+KIrpydI3Dlps8kbin8N7+yXRN/4czTS5coOSaWr1Ec+dCZT4tqj1RGKEMENoNcnTopJn6F25qXwkmDVfnvHPEdoATat6hfgyns7vZmrtr67iUx4l+LO7lPKzEOP5p70kNcf9dhpr1yHeHe3SxhpdVjjfvBbPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8t2t/u3V4VNuulSELjP+bju54IM8pzOdafWVoIy2DmM=;
 b=AWukiFzF1b6A3EVckSljYv1C9TRrEjyycAptBWwRRSax2JD8mnPFc+Sh5vccrKp/Sv2WezNS6c5oc2Sb2YpC59Tiyz+DD1HIj8cw76Dyw6tVXHDWIyyu91HvO0z9MA4oxw9h3BgtZ7GoN4F/uH/+sjTLJjg1HIP/D3DCoRQboF11bX5jSLgDxQI6DH+CeaAeeJY2OHL4oG796u9S3apvDCpidbCISz4agHvYwL5298V8qoKOqGX0U+nGfU15QrlcaWxWlcNtlHlvdzyNLp6dMxVS0nYvfcxYflaTcDujECJDPstk/1aVSq1Nsz49Nu5ITONp6fQ6O49lJ2a1VwSSew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8t2t/u3V4VNuulSELjP+bju54IM8pzOdafWVoIy2DmM=;
 b=YwOyIlfTyXYPWUtsYZVaZiDpz5y43Ho3qSaR72QzbOY/z9D7AMBHplxmlGQbIMSSK/r2BYmJLvfI03kTO0/LwkpSX55pUOyjS/EMNKIz7cswY7X10sx7F3nbBW64WfsQW2z5NRWBHxJSy09J8GCh3zjqgf9foZBD41xAV1gHyd0=
Received: from SJ0PR13CA0127.namprd13.prod.outlook.com (2603:10b6:a03:2c6::12)
 by CY8PR12MB7756.namprd12.prod.outlook.com (2603:10b6:930:85::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Tue, 10 Sep
 2024 06:03:55 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::2f) by SJ0PR13CA0127.outlook.office365.com
 (2603:10b6:a03:2c6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Tue, 10 Sep 2024 06:03:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 10 Sep 2024 06:03:55 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Sep
 2024 01:03:53 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, Melody Wang
	<huibo.wang@amd.com>
Subject: [PATCH v2 0/6] Add SEV-SNP restricted injection hypervisor support
Date: Tue, 10 Sep 2024 06:03:30 +0000
Message-ID: <cover.1725945912.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|CY8PR12MB7756:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e4685b8-ac45-489e-3647-08dcd15e5a7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M9P7B2NvMfJrsAi3hsJYWJh8b+5FuROXK2ebbBWwfXCHakCWHsXRl6rnWGLW?=
 =?us-ascii?Q?UuS33/ZnJsttKYneX/CP6xhlGn+mT2W3TGTgIBVEktNoD1RJPHdyl0KvZAyU?=
 =?us-ascii?Q?N3jgjzSOjAlZWPxfXM7QVnAnd+HFSUsnaIZaDp6d/RlTpjYKItRHqq6C0fhm?=
 =?us-ascii?Q?UpzSzxn1Zs1O8hR/MSjSO1UHR9WukEKiq1wOc4hes1y/VLzLiDHOcQk7gg5K?=
 =?us-ascii?Q?pARMGfjSBpNzlhoZ39K0KQbKDyaytk3JVpVD4R4OE1SxmEMilSsIYrzlWrDx?=
 =?us-ascii?Q?S4XYWoYx3l/dyB4kq6phM8xesY25Dlm04VFr+fuAQdyY6jVxEx7Sqm8b46qN?=
 =?us-ascii?Q?/unAhDeRIkX3A9/WHD07xV2dQy+bTX9DynSujYuqzMW9GpppTyWWh4wLdgAA?=
 =?us-ascii?Q?RKuon3ixjF4EQdnbZc88rNygRuk1oLLkCaRUNxJNAeud53aat2XE6uFXaJaf?=
 =?us-ascii?Q?wHuNE4NHLMMpgnU/H54pw8CDDP0qQtN6N8n8+pr4Qz/vvC6STp//4BumgXRA?=
 =?us-ascii?Q?1eqiE8LKPgEVDveN8seaJVVIstaEKHPQYBN5QELhS+9JmwO8s3eeMJtAaOon?=
 =?us-ascii?Q?C8b+HgHjSET84+dQbUvFW3S1oVGsf5QSx/91AYYljVwHYTvfyt88weXFWONC?=
 =?us-ascii?Q?HnjYTKfu+wHJ/1OLE36hRAzC+HINLcVt0Vu1cksafbAaz/XESteJsrQKfn2a?=
 =?us-ascii?Q?YwR9O/rBjl+/gOJSReq3UA1DDN2KhbVPtqfl0Wq3snbrBTODec0+8CB8X+7o?=
 =?us-ascii?Q?6vLDMS7mn39Or4ZidzafajBxBB01Tm+YyvDg2hb6RlLwCXLVPiMKhlsWLSr3?=
 =?us-ascii?Q?8pU01FdkOojFt78F3IkbqXeXicdYQAfkD+b3BWqnDGW7n1ABkmmjwn3ZxDuv?=
 =?us-ascii?Q?K4vsfZhmWzc8lazyUflgmFPmBnxBNxffE0ra6RSvP3KRt0//MndtN4UPok0a?=
 =?us-ascii?Q?u+r2cPTsTJUQ6kGiBPLBirZn/zBj2OlMOpEDH//jc4z+2jWefgsqOBLZkbgo?=
 =?us-ascii?Q?dsnvhhPvEcd6+0rC+tmWheQ+Lgy42Oj7k35to0OEE0TqovjDwyNf3hICU3QN?=
 =?us-ascii?Q?cRgFEPGPiy1N6X06/RPY/Aos4T+w09P2xeHnnvsCDlcBx6M1OVpjR+cizdxQ?=
 =?us-ascii?Q?cB0TzU0wcnMufXn1E8YtJv7NsFpvLs9x/y28UW2yV8Ex8+K98i5dRqJOgtnn?=
 =?us-ascii?Q?3/TG0L2IK8EzYvSVsOBsVFuvOeQAwRhsk8RadBRZmJ+FLLzONY3G9YKvXDmx?=
 =?us-ascii?Q?RaYzOxqtlWFldXJoGytcWuSsbPlxptodfysZLaxk7qrdRjNF6XRPltWylL7F?=
 =?us-ascii?Q?gDNIo9SR+Myf8D1FP56I30ypSyElKtAiU7P388H80LrbKLNaVCHSs80H48eE?=
 =?us-ascii?Q?0puUDjUwqOYKXiLlhFPvMZi+ak+ol60KGUp0wQpr7Ap/a8VY++7cSxfDBhTc?=
 =?us-ascii?Q?GLoVFpF015uRK5n++j0t40AIxx4VFtYxRgpKpkDffKBSU8SKECqMMA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 06:03:55.3244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4685b8-ac45-489e-3647-08dcd15e5a7e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7756

Hi all,

This is a v2 of the restricted injection hypervisor support patches.
 
The previous version was submitted here:
https://lore.kernel.org/r/cover.1722989996.git.huibo.wang@amd.com.

Since the previous submission, one issue reported by the kernel test robot was
fixed.

All comments and review feedback are appreciated.

Thanks. 

Changelog:
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
 arch/x86/kvm/x86.c                 |   8 +
 14 files changed, 408 insertions(+), 5 deletions(-)

-- 
2.34.1

[1] https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/56421.pdf

