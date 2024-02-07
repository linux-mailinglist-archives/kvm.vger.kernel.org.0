Return-Path: <kvm+bounces-8219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F4984C6D6
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 10:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C518F1F245FE
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 09:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7ED219ED;
	Wed,  7 Feb 2024 09:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="Xw2DTsw/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2127.outbound.protection.outlook.com [40.107.92.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F7020DD8;
	Wed,  7 Feb 2024 09:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707296728; cv=fail; b=ODIDacohBzbdLEH+x7xbCVH6f0sRV9te/hGQTXitRz60mzEEWXZ3q8FRdjO65lqEmb+izOF7iZzReAS5M5oLCQpXR/hA6khd6yZfbZnaWHQuk4L2um0D6NdGFmVPeQzx7f78Vm4W7R6/o5nXBCH9+t3Lw9uXyG2QEmPk1JnoUH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707296728; c=relaxed/simple;
	bh=fVsAGeDe8ZqiFNbv5KWPeoN6rCuPSqe/RN48damwqcU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=j2aK1CTIBc+67o3oh1x8zUML9EGkzV4Ebv+sDAQqdjkrtS9tQ/vtXTNGJ9+Q7xHPp6O2D4UbjVveBSsiLlzxqFbUJ5SZNSuQpoUz8HRDHVotNFdVviLAdZbntBrmFif3o+15zCDGaR769o1vcMSqCS0sHAsmDhJ0oKuHokts1u8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=Xw2DTsw/; arc=fail smtp.client-ip=40.107.92.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmwVBfAKj1kA5itgi8XL08zpCR//JiNQrP/fv7OTbgd6i5bJVg26HT740lqFVEIWt4Asz0IzuTp0XYU85HwebUQJhvJq46VrgyQpaTvOpOvzOm6idTQjpyFdZdnNJmeaBIijuJlMACDAnPusnzanO3wIW1ukS2xrjla7iUSM+CY2MnMZrSaMJIE2udHxunMBhTqnmFXPjG1FQ8Xj2vX9APY+Ok3egUrVIMitqOC7OzJ2fMrrfbrKlsJmnUR9a2sfvITM5qm5BvzDFcrWwKS+H+TN55w3o5LCV8ZN773Sclk7zo10xCs4pSvsCvcEiVcrEb+Y6yZPHS8k592HDp6NRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZkSRAJa4mX8Q56vBzxG3rhDNVPERySmvgC+YP2D4M0=;
 b=EEyXBmkg7CXG8fIqcnfe5+RQyyEYXP8jOA4CurZQRPMQrZEUzM5lOIb3KYaRl7ondnbUvMuMeniFWTpg+F1671aCncY59xkeW0E3Yr/ldgTQneDXAEc/3RMpT5/khgFXTJydiNOnqpKyIhy53qQF4xkRqPhbI9XBE6rMVwMgMGfKA8wx768RCtG/bNpKgkxj1pEXWC/lxZOBgwXEvinXtNVZUgU+meswyiRypHUYTu3/z3E8Uq1bCSB3TtHExsrX+sOIS8SaOP6aI3rnzmwZPUYGthM8vsdETkUIXyAIkfYQ5CSPwrO+lLgb3O3g5JEOxaeRy6r1zm9WOF8BzxKe9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZkSRAJa4mX8Q56vBzxG3rhDNVPERySmvgC+YP2D4M0=;
 b=Xw2DTsw/HaAWqe8bwDAYlhe/zcoJA4Y6TJ2aBqrEiWhybc0HOtfHSn/+8Jh8KsLfElnpWlt0HV9GaZiB/zCBIu9fgyTvpx1mLfnR3T9eTOXdd3BBvBxCSwRxJjaqi8vjRdKPaT81kEDvj5DBAQ/UcK8vunJFS8P5LM9Dc0u+wy8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SN4PR01MB7518.prod.exchangelabs.com (2603:10b6:806:205::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.36; Wed, 7 Feb 2024 09:05:22 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::a0ca:67bd:8f75:4f37]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::a0ca:67bd:8f75:4f37%5]) with mapi id 15.20.7249.035; Wed, 7 Feb 2024
 09:05:22 +0000
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: oliver.upton@linux.dev,
	maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	suzuki.poulose@arm.com,
	james.morse@arm.com,
	corbet@lwn.net,
	boris.ostrovsky@oracle.com,
	darren@os.amperecomputing.com,
	d.scott.phillips@amperecomputing.com,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH] arm64: errata: Minimize tlb flush due to vttbr writes on AmpereOne
Date: Wed,  7 Feb 2024 01:04:58 -0800
Message-Id: <20240207090458.463021-1-gankulkarni@os.amperecomputing.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY8PR12CA0041.namprd12.prod.outlook.com
 (2603:10b6:930:49::18) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SN4PR01MB7518:EE_
X-MS-Office365-Filtering-Correlation-Id: 74c5ceb8-afd3-4e3f-2720-08dc27bbea06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gdDBK3XjyFHQlC87Pg3BUdOnDKZJH65k9pyIemkdACVYxUL42dUGm1GIjlMCa8Gh+ZmbPX0t+A2nbrM+71wXxZ/KsDnrI98VbrzQ7M1KdJuP2CdoWrM9k9/9/K4y/RYFA7fwVCs6Zjh3xeYLboF3l+scou5gx39+nYCDCbuAtJiqV53FgFq9R+Ek03jIxXkO851Ca4zpNhlWkIzAVNjJGY/YJuKlMIoXZZgq1vNNDABpvBSLy7zvWsPGAB4E1nPDsHDZHNlGoILJhiALODbz2G0oEElodrfO58IaPwICWtg8yamBRT96qFSPGjy+rZo5YG5tUhmmfPXyMPH4v+3gAkgBoE3IJVdV8F2jY40i5U2LHY3dzxZxDEnzUsWSXHoeQ9SVHZ1cegQHAkqbPPCg5jnWOjxaLC3COLxfNhxBa66BUg+79af3YU30K/W+BfaTTZzNRD5nY22PwoN+iLgjEYwz90YSR03QVnLJdknWG2oGZxbTUfNvsvGWX8sUNT/Shx8ZgL6vvzZNptzEmyNva0adQ49KkmbAlHTZXHlN2/RzEHWbHDL3HoCrGuO+mC0k2+NRqvYuBGXP2ZBgWD9oVpFEz2ENqiX7zV469NLEChmNEP+dW7azjUD6deUhBBFZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39850400004)(346002)(376002)(366004)(396003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(38100700002)(6666004)(83380400001)(6506007)(52116002)(86362001)(26005)(41300700001)(1076003)(2616005)(107886003)(7416002)(4326008)(8936002)(8676002)(6512007)(2906002)(6486002)(5660300002)(316002)(66946007)(66556008)(66476007)(478600001)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pmlNihy9pPGizQpLdLACM87jaUs209YEm9Lb7Z5c6FymDkp58gW1Z4f2bdcm?=
 =?us-ascii?Q?ZIm8A3BMwIq/ygoGf6JUQL+pnAjCJjE8p0JFEe+1A852vwtphWwOoNQq7v3C?=
 =?us-ascii?Q?QUsvUSafvWfruL783hHrlB9oILp3bdDDipvloBoqj9SQuZp3XKuusFXps7JW?=
 =?us-ascii?Q?qN2z5b9koV7ZPJ0HiNI81JUcNnm/ap9gao9a+W9oQnBBtZnVbr9X3YuLywkI?=
 =?us-ascii?Q?eNAvp3mDQx7j4qscFCV/of6lvrMdJ8D2gbPB2UAH8PNxwWadMfmcXa7sXGg7?=
 =?us-ascii?Q?JfK6AJZkuFg6QwVKba/NpcU5I+6DpOvNQetgq6bCq27EzHGhv/q44hmva3Lc?=
 =?us-ascii?Q?l2zmM1exyquOWn6yNpWXwsdZ4gKa/DO5ScUvfH9p0N3TTMKeMQ2SEZHJcO9Y?=
 =?us-ascii?Q?71KDoa2Pe1850IeQPI4QswJzgpviMx0xatTK9vaZ2OiUzDjKyzLYggWRaptS?=
 =?us-ascii?Q?0YZY932T3DI5PXFCTKpO3IwHggOZavhhUQJTOuOWqv2b/lQLH3K0SmtJwP9s?=
 =?us-ascii?Q?dfGZjedO5yZW13/2fF4X3xfKTKbzDiOszm89cp8l/QKzNkfl0yfFCSpSSLF0?=
 =?us-ascii?Q?II5+4C3PbzgA4rl7QDcn1zPA89oOLPjfvUzRVtEgf8tdc0eowsw5QG51zyLu?=
 =?us-ascii?Q?Ll7LTZBZNCEoHT5NbF/Wg7itB8cObYyP6dwsGkquSWZPumlTB7BVUZyHc++y?=
 =?us-ascii?Q?Y7Tj/H8HyySmMKaozOVYe1I3aJ8jboRKQ7SCA9UI8MEc+7ykgmGvrDOyfYrG?=
 =?us-ascii?Q?cR0O2FN1g3S++1pkZQIU2wls5jjHGsjc9Ei4efX/OZ7oXDX7ZCD1vb7kDbdE?=
 =?us-ascii?Q?HbO1ut6BUUEJQGmys6dCMW3LJsLYBo4YA6hf+JgEqJFP4KV3UBl+wGtOrV5O?=
 =?us-ascii?Q?o+ySODkzaDdFCOYKKOM1Z1SvGmVutqYRZMLZbdc/pLQqS8VVsKgOSkza8bSi?=
 =?us-ascii?Q?jpTNZ1enzOimoHUFP5S07+hfRzCZ/aNGT94G06vZgRbiDS4+gxGucwW3IJdk?=
 =?us-ascii?Q?JV+AkSTuGSU9Xgl1um5h/2dmsHg96Ayxj1Eh/vVxwIfMWzeVPltwocK4lhFt?=
 =?us-ascii?Q?FK/RdP6vUIFpQiMsxnwKMRqo0nuZBYPyxtrR6EW769qsbRUGvF8BfF+RkbpU?=
 =?us-ascii?Q?K+5jmY/YVPJENK+DkCZOnlbBhNcR1BrQtGURGbULdGnCdHaClpv1eN7LdNZa?=
 =?us-ascii?Q?nHZRG+mBr6H1dXK5sdT9BTRxjMjq0lOo5HV01Vy6xHfMpEadpCkUWrb0cGu2?=
 =?us-ascii?Q?lZRHFlprG3kFNY8dmdVw2a1yFHGRBUiDEpnnm4K/s2vVaF6N8sgJB26BxvHb?=
 =?us-ascii?Q?l9wqYeC501H7a6FnV95+Zy/D8TqOVHlOcTo9nMkGS19+3I6cN7GdFnyUti46?=
 =?us-ascii?Q?7d0Nfjlf9IEJnASk2OyjHpDgBTI2BAChe7XjLQ9SjHcbzDzUcgERbpFf/IDz?=
 =?us-ascii?Q?rE774ap5eluviS2/XAB6pCbE3Pnx8tvDDD/a5mNzmF9TMa0kFA9JC1HKeOUX?=
 =?us-ascii?Q?lbKp0+xnVywuql4D5doZ7P1WMgqBQGrYtoROwRmTqQcddhFbefzkGAZdJ7qD?=
 =?us-ascii?Q?iGOVXG7OTWhZeqwwigtf/k2MbZ5so6BVXSEAIQLEWh1H5uJsZNZZolwntIqT?=
 =?us-ascii?Q?zt6FLeeOuzXr0OtOHHZeXog=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c5ceb8-afd3-4e3f-2720-08dc27bbea06
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 09:05:21.9962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A6yTL7g8OXA4t02xbLPe5iH23qRnwdObQ76NqJrwOiVM0c/QGgKa2SdZA1Dd7ng8pg4nvQLbSJgx1UZAHLhKASC5fG5exa6emiEL7WkyePWDYsM0cvzMNaMxU9OLcv+H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR01MB7518

AmpereOne implementation is doing tlb flush when ever there is
a write to vttbr_el2. As per KVM implementation, vttbr_el2 is updated
with VM's S2-MMU while return to VM. This is not necessary when there
is no VM context switch and a just return to same Guest.

Adding a check to avoid the vttbr_el2 write if the same value
already exist to prevent needless tlb flush.

Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
---
 Documentation/arch/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                          | 13 +++++++++++++
 arch/arm64/include/asm/kvm_mmu.h            |  8 +++++++-
 arch/arm64/kernel/cpu_errata.c              |  7 +++++++
 arch/arm64/tools/cpucaps                    |  1 +
 5 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index e8c2ce1f9df6..8924e84358c9 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -54,6 +54,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne       | N/A             | AMPERE_AC03_REDUCE_TLB_FLUSH|
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index aa7c1d435139..77485d0322e4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -436,6 +436,19 @@ config AMPERE_ERRATUM_AC03_CPU_38
 
 	  If unsure, say Y.
 
+config AMPERE_AC03_REDUCE_TLB_FLUSH
+	bool "AmpereOne: Minimize the writes to vttbr_el2 register"
+	default y
+	help
+	  On AmpereOne, any writes to vttbr_el2 results in TLB flush.
+	  It can be avoided to improve the performance when there is no VM
+	  context switches and a just return to same VM from the hypervisor.
+
+	  This option adds a check to avoid rewrite of the same value
+	  to vttbr_el2.
+
+	  If unsure, say Y.
+
 config ARM64_WORKAROUND_CLEAN_CACHE
 	bool
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e3e793d0ec30..da39e4749434 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -317,8 +317,14 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
 static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu,
 					  struct kvm_arch *arch)
 {
+	u64 vttbr;
+
+	vttbr = kvm_get_vttbr(mmu);
 	write_sysreg(mmu->vtcr, vtcr_el2);
-	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
+
+	if (!cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_TLB_FLUSH) ||
+	    read_sysreg(vttbr_el2) != vttbr)
+		write_sysreg(vttbr, vttbr_el2);
 
 	/*
 	 * ARM errata 1165522 and 1530923 require the actual execution of the
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 967c7c7a4e7d..f612975e0cb5 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -740,6 +740,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1),
 	},
+#endif
+#ifdef CONFIG_AMPERE_AC03_REDUCE_TLB_FLUSH
+	{
+		.desc = "AmpereOne, minimize tlb flush due to vttbr write",
+		.capability = ARM64_WORKAROUND_AMPERE_AC03_TLB_FLUSH,
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index b912b1409fc0..b4bee37d0527 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -85,6 +85,7 @@ WORKAROUND_2457168
 WORKAROUND_2645198
 WORKAROUND_2658417
 WORKAROUND_AMPERE_AC03_CPU_38
+WORKAROUND_AMPERE_AC03_TLB_FLUSH
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.41.0


