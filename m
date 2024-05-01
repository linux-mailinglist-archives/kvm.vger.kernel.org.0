Return-Path: <kvm+bounces-16324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A15548B874F
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18A041F22EAD
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF788502B2;
	Wed,  1 May 2024 09:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Yrt7Qos"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B2D1DFDE;
	Wed,  1 May 2024 09:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554531; cv=fail; b=jcW13NP+rVtVs/fp9VsfDPI/JMYGnZnaFcO0sHnoYgKY5YMebkN5JdcmM8Zt/BaOggrQhIGGiqPs1gOzz8bSuwW4fzdm9h+LLgFNoFnue5S+W9RjYyFLvRpcjY2Yyvvv28KUXVZuI3UqOe42zEkfEYv1mtcgF0d51f6/KaD0ra8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554531; c=relaxed/simple;
	bh=HhUZiTPLKI4dfVpuq0XBgFOOUfHPDQtyi4lDJRp77c0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P1QMJDm+vjaJswRXzxRw2kQfvZLXDcsmW01WxysypKb1uDQbyK7CapAO+NpPeFV0n86FEkdBemsvPhwClQMi8pR9lwpQAscA9x+4p5+GYPl5Xr+h+kfZQzVErI52Fj6scQySx748Xlyf/A5OmKIJMokQLJGewO1KYnY174/LFS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Yrt7Qos; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8QeFKvXVCPtsJC/i7aFhXqdtY1jyEO2WpmlNvWbBgzvQpph/L7CTbiXu25B2//0BNImztXPiQySwS7LIhAIq3DWzfMfIM4axk0QmZshn3xKR0WJAmfSAqjIswTAo1nQQaORSi8gQvA5TiFskFjujOx7FV408NgpKDktMOcmeVryHKSx0Pxuxzvxto0WD1L1HGYuPdtBhWzZ90AXMx2kOwh/6xWFnbVO4o29D0meY3crLfHrgDAZi3fTwq2g25qnL64Y50/x02Hf+bUqa26qOwXTIbf9fgCjmNO0uzlyxf8SVykFY6exDHg3tc35qZzS9TOoGH75//E/n9QGuqlnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMtwTcljvfpmFGi8ikmGc+WUjG3kns5eqcMGLb6+ovM=;
 b=NFvasFS7Vl9haVoNllAoM/kQlRPhPe8RHzsWr3AX0U9ZeAT6kZQ6XhVB5BYcZ8GkYDORlqe1w7q5QB2M7kjgfxTCO+YMkB1nnOb6wTAvViw6D5MyL8mFhKcJ4qpxh3R05vrdjtLbiSmzFohqO46w6AsUqcG5IH6HIcCnf4cdlpDdc/e0D0gsZT0FNwMDuMnFp90gRbQuKF969IiODDQMfK2RO+ThLT6JnK4K9Sqbd/TvrFa0QTtrXDX/wZ7PqR+hYWxWKqGHotfiLLVxksqUJvfGAHP5BbWpW72B/syQDfww60hFKuAwfn+HTRwsE6Vb3Dren0oYrzFx2KxoQtxYHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMtwTcljvfpmFGi8ikmGc+WUjG3kns5eqcMGLb6+ovM=;
 b=4Yrt7Qosq9ZNy45QRReZp1feV3ndLJbUFysYvr5krjWkbxk98Q/bL900zAIOKe0jTMwYyljaF6l/Qz4AAO7aC9wPVkQNulrOJxAbH/OqKWB/NBQEKLg1TzuyQmR9BC8+Ny34R4qXywoy/knRMCSKT01nMZo7H1NlagCTS9eNTpI=
Received: from BN9PR03CA0586.namprd03.prod.outlook.com (2603:10b6:408:10d::21)
 by PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.29; Wed, 1 May
 2024 09:08:45 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:10d:cafe::c4) by BN9PR03CA0586.outlook.office365.com
 (2603:10b6:408:10d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34 via Frontend
 Transport; Wed, 1 May 2024 09:08:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:08:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:08:43 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v15 06/20] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date: Wed, 1 May 2024 03:51:56 -0500
Message-ID: <20240501085210.2213060-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: a2579a33-0673-4ea6-7644-08dc69be4d5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400014|36860700004|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YYuspEeVpV3Pn2EC5/RaN8YeyD38zjyCDjxwg8kK8R8wyxDNEQb42teo1p6d?=
 =?us-ascii?Q?M/J2Y/aMusw5eEkKVNrVMZOHVYwYTnaUOW5tlAO+RFgoH6LpGD6sKDieJzx3?=
 =?us-ascii?Q?6knCpkjAshkbYZ9eOT1Nsk3+/p3T2IduNs+KcK/msyK/M5+/XmdUzNpa2SSH?=
 =?us-ascii?Q?k62ZGzd+bprV4ramDMTKc9QK74wTMVYhLknahnNPgyiVBEcQ+mPC9uhXom9C?=
 =?us-ascii?Q?8KJNGUg71X2ijfcjAVP7ela611fBJHjILjzbiz/wCv79mJE9R3+nnU+t4Tvl?=
 =?us-ascii?Q?mUiQiivQ+Rpx8viWgYLHM5DyI3jImOLE0o2Vt/bRZJOhs5BCCpRckjz7VHnc?=
 =?us-ascii?Q?JGgFtGT413+Vehp0yvSJwQAdAYUg8vfYF7frLn6ZvDmgiPMD75aDwGiw+yur?=
 =?us-ascii?Q?x5aoQHZVymO/K+ICskBLfq8Dxq0zGFP1bWtVteOmEb1wmTgBTCLJLJHzCVCa?=
 =?us-ascii?Q?9aMPxfB7Mfa49C7ja9PwGzf1f7/X9sslh17VdC9zTjJ6pNQwH+6oSfnUcOzo?=
 =?us-ascii?Q?IN71Ndyh5UGTIR7QFZm36K4d7rFEAEpqtDvH9nPCfPcA4k3N0wl1iDY0vjs7?=
 =?us-ascii?Q?ovMt3ST1uAQkXLMg2X1rRvF9wuuD2LetaSkNbeCXzD8/M0mKlptZe5k7RDe+?=
 =?us-ascii?Q?fTBC/UOaaIHdsD6t34vBQH2geuUOTW8Az4G1h4E9R1IomoozsXxCdv50gAOp?=
 =?us-ascii?Q?9vgtCQ9f+IkIxBcZ25igN9Npt8Lo3PUFK6ZP5dZ5CFTi++RvyKzXlF3n8M1V?=
 =?us-ascii?Q?49RpChHMyuMxFh2ZWXW+rF+UsR91o7DBS42QOIbbFCsZ7vhd2CShUzM5uTf4?=
 =?us-ascii?Q?w0nMtUZjC6bnucZnXEOSlXYNQQRwmU94vNGU/PtH9JXBRi39a9z/nOeimyDh?=
 =?us-ascii?Q?ajpCLWIZWcy6Zt39HikLkPBQmMoJslQjVYpevX1WKo/Hvo0Pnnwd/R6AT04+?=
 =?us-ascii?Q?bhTzZENv0D2hbZfTyA8BK0DRdecnWcCzxoTNovgc+JcoNb5EHjA1YFH7SjAJ?=
 =?us-ascii?Q?0lZoRpnSzxmX0utam/f7eIwi9MO108dUGmia541ilmIocxGgy2Ghm3uP85Jz?=
 =?us-ascii?Q?RHdeInrSyuUseAQY5ErWmoIjzduPmUFCpUzdvqsHkwdxws0MrjicvrRVajso?=
 =?us-ascii?Q?kRqtvg6JAG++dAYds087UeS5s+JiKtik7Zlq+Ipy27L9QU5fWuEEzH363QJw?=
 =?us-ascii?Q?fUWLIDG6xcLxBaO2nv/U5qMebS74EFGMxIgkI+Tt2d3Uze/UqDDXVh9St0Io?=
 =?us-ascii?Q?x4hB/d5VFwD0L1uM3LK0DvV+vg932PkC1mGAkt2ydmcXjxE8JPCdlseliDup?=
 =?us-ascii?Q?a49qlaiuda7GO/CDK+2r0ET9+XlYQTDm7RlMDUj1PF0bKij/juCFUl2UGHjp?=
 =?us-ascii?Q?njZkkLuzVyDMfntDh+6tAz/oupA+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:08:44.1881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2579a33-0673-4ea6-7644-08dc69be4d5e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010

From: Brijesh Singh <brijesh.singh@amd.com>

A key aspect of a launching an SNP guest is initializing it with a
known/measured payload which is then encrypted into guest memory as
pre-validated private pages and then measured into the cryptographic
launch context created with KVM_SEV_SNP_LAUNCH_START so that the guest
can attest itself after booting.

Since all private pages are provided by guest_memfd, make use of the
kvm_gmem_populate() interface to handle this. The general flow is that
guest_memfd will handle allocating the pages associated with the GPA
ranges being initialized by each particular call of
KVM_SEV_SNP_LAUNCH_UPDATE, copying data from userspace into those pages,
and then the post_populate callback will do the work of setting the
RMP entries for these pages to private and issuing the SNP firmware
calls to encrypt/measure them.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  54 ++++
 arch/x86/include/uapi/asm/kvm.h               |  19 ++
 arch/x86/kvm/svm/sev.c                        | 230 ++++++++++++++++++
 3 files changed, 303 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index dd179e162a87..cc16a7426d18 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -490,6 +490,60 @@ Returns: 0 on success, -negative on error
 See SNP_LAUNCH_START in the SEV-SNP specification [snp-fw-abi]_ for further
 details on the input parameters in ``struct kvm_sev_snp_launch_start``.
 
+19. KVM_SEV_SNP_LAUNCH_UPDATE
+-----------------------------
+
+The KVM_SEV_SNP_LAUNCH_UPDATE command is used for loading userspace-provided
+data into a guest GPA range, measuring the contents into the SNP guest context
+created by KVM_SEV_SNP_LAUNCH_START, and then encrypting/validating that GPA
+range so that it will be immediately readable using the encryption key
+associated with the guest context once it is booted, after which point it can
+attest the measurement associated with its context before unlocking any
+secrets.
+
+It is required that the GPA ranges initialized by this command have had the
+KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
+for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
+
+Upon success, this command is not guaranteed to have processed the entire
+range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
+``struct kvm_sev_snp_launch_update`` will be updated to correspond to the
+remaining range that has yet to be processed. The caller should continue
+calling this command until those fields indicate the entire range has been
+processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
+range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
+buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
+``uaddr`` will be ignored completely.
+
+Parameters (in): struct  kvm_sev_snp_launch_update
+
+Returns: 0 on success, < 0 on error, -EAGAIN if caller should retry
+
+::
+
+        struct kvm_sev_snp_launch_update {
+                __u64 gfn_start;        /* Guest page number to load/encrypt data into. */
+                __u64 uaddr;            /* Userspace address of data to be loaded/encrypted. */
+                __u64 len;              /* 4k-aligned length in bytes to copy into guest memory.*/
+                __u8 type;              /* The type of the guest pages being initialized. */
+                __u8 pad0;
+                __u16 flags;            /* Must be zero. */
+                __u32 pad1;
+                __u64 pad2[4];
+
+        };
+
+where the allowed values for page_type are #define'd as::
+
+        KVM_SEV_SNP_PAGE_TYPE_NORMAL
+        KVM_SEV_SNP_PAGE_TYPE_ZERO
+        KVM_SEV_SNP_PAGE_TYPE_UNMEASURED
+        KVM_SEV_SNP_PAGE_TYPE_SECRETS
+        KVM_SEV_SNP_PAGE_TYPE_CPUID
+
+See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page type is
+used/measured.
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 693a80ffe40a..5935dc8a7e02 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -699,6 +699,7 @@ enum sev_cmd_id {
 
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START = 100,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -835,6 +836,24 @@ struct kvm_sev_snp_launch_start {
 	__u64 pad1[4];
 };
 
+/* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 gfn_start;
+	__u64 uaddr;
+	__u64 len;
+	__u8 type;
+	__u8 pad0;
+	__u16 flags;
+	__u32 pad1;
+	__u64 pad2[4];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4676ce171aaa..f31f87655a67 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -259,6 +259,45 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
 
+/*
+ * Certain page-states, such as Pre-Guest and Firmware pages (as documented
+ * in Chapter 5 of the SEV-SNP Firmware ABI under "Page States") cannot be
+ * directly transitioned back to normal/hypervisor-owned state via RMPUPDATE
+ * unless they are reclaimed first.
+ *
+ * Until they are reclaimed and subsequently transitioned via RMPUPDATE, they
+ * might not be usable by the host due to being set as immutable or still
+ * being associated with a guest ASID.
+ */
+static int snp_page_reclaim(u64 pfn)
+{
+	struct sev_data_snp_page_reclaim data = {0};
+	int err, rc;
+
+	data.paddr = __sme_set(pfn << PAGE_SHIFT);
+	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+	if (WARN_ONCE(rc, "Failed to reclaim PFN %llx", pfn))
+		snp_leak_pages(pfn, 1);
+
+	return rc;
+}
+
+/*
+ * Transition a page to hypervisor-owned/shared state in the RMP table. This
+ * should not fail under normal conditions, but leak the page should that
+ * happen since it will no longer be usable by the host due to RMP protections.
+ */
+static int host_rmp_make_shared(u64 pfn, enum pg_level level)
+{
+	int rc;
+
+	rc = rmp_make_shared(pfn, level);
+	if (WARN_ON_ONCE(rc))
+		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -2121,6 +2160,194 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+struct sev_gmem_populate_args {
+	__u8 type;
+	int sev_fd;
+	int fw_error;
+};
+
+static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
+				  void __user *src, int order, void *opaque)
+{
+	struct sev_gmem_populate_args *sev_populate_args = opaque;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	int n_private = 0, ret, i;
+	int npages = (1 << order);
+	gfn_t gfn;
+
+	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
+		return -EINVAL;
+
+	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
+		struct sev_data_snp_launch_update fw_args = {0};
+		bool assigned;
+		int level;
+
+		if (!kvm_mem_is_private(kvm, gfn)) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx has private memory attribute set\n",
+				 __func__, gfn);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		ret = snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
+		if (ret || assigned) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
+				 __func__, gfn, ret, assigned);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		if (src) {
+			void *vaddr = kmap_local_pfn(pfn + i);
+
+			ret = copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE);
+			if (ret)
+				goto err;
+			kunmap_local(vaddr);
+		}
+
+		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+				       sev_get_asid(kvm), true);
+		if (ret)
+			goto err;
+
+		n_private++;
+
+		fw_args.gctx_paddr = __psp_pa(sev->snp_context);
+		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
+		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+		fw_args.page_type = sev_populate_args->type;
+
+		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &fw_args, &sev_populate_args->fw_error);
+		if (ret)
+			goto fw_err;
+	}
+
+	return 0;
+
+fw_err:
+	/*
+	 * If the firmware command failed handle the reclaim and cleanup of that
+	 * PFN specially vs. prior pages which can be cleaned up below without
+	 * needing to reclaim in advance.
+	 *
+	 * Additionally, when invalid CPUID function entries are detected,
+	 * firmware writes the expected values into the page and leaves it
+	 * unencrypted so it can be used for debugging and error-reporting.
+	 *
+	 * Copy this page back into the source buffer so userspace can use this
+	 * information to provide information on which CPUID leaves/fields
+	 * failed CPUID validation.
+	 */
+	if (!snp_page_reclaim(pfn + i) && !host_rmp_make_shared(pfn + i, PG_LEVEL_4K) &&
+	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
+	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
+		void *vaddr = kmap_local_pfn(pfn + i);
+
+		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
+			pr_debug("Failed to write CPUID page back to userspace\n");
+
+		kunmap_local(vaddr);
+	}
+
+	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
+	n_private--;
+
+err:
+	pr_debug("%s: exiting with error ret %d (fw_error %d), restoring %d gmem PFNs to shared.\n",
+		 __func__, ret, sev_populate_args->fw_error, n_private);
+	for (i = 0; i < n_private; i++)
+		host_rmp_make_shared(pfn + i, PG_LEVEL_4K);
+
+	return ret;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_gmem_populate_args sev_populate_args = {0};
+	struct kvm_sev_snp_launch_update params;
+	struct kvm_memory_slot *memslot;
+	long npages, count;
+	void __user *src;
+	int ret = 0;
+
+	if (!sev_snp_guest(kvm) || !sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
+		 params.gfn_start, params.len, params.type, params.flags);
+
+	if (!PAGE_ALIGNED(params.len) || params.flags ||
+	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
+		return -EINVAL;
+
+	npages = params.len / PAGE_SIZE;
+
+	/*
+	 * For each GFN that's being prepared as part of the initial guest
+	 * state, the following pre-conditions are verified:
+	 *
+	 *   1) The backing memslot is a valid private memslot.
+	 *   2) The GFN has been set to private via KVM_SET_MEMORY_ATTRIBUTES
+	 *      beforehand.
+	 *   3) The PFN of the guest_memfd has not already been set to private
+	 *      in the RMP table.
+	 *
+	 * The KVM MMU relies on kvm->mmu_invalidate_seq to retry nested page
+	 * faults if there's a race between a fault and an attribute update via
+	 * KVM_SET_MEMORY_ATTRIBUTES, and a similar approach could be utilized
+	 * here. However, kvm->slots_lock guards against both this as well as
+	 * concurrent memslot updates occurring while these checks are being
+	 * performed, so use that here to make it easier to reason about the
+	 * initial expected state and better guard against unexpected
+	 * situations.
+	 */
+	mutex_lock(&kvm->slots_lock);
+
+	memslot = gfn_to_memslot(kvm, params.gfn_start);
+	if (!kvm_slot_can_be_private(memslot)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	sev_populate_args.sev_fd = argp->sev_fd;
+	sev_populate_args.type = params.type;
+	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
+
+	count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
+				  sev_gmem_post_populate, &sev_populate_args);
+	if (count < 0) {
+		argp->error = sev_populate_args.fw_error;
+		pr_debug("%s: kvm_gmem_populate failed, ret %ld (fw_error %d)\n",
+			 __func__, count, argp->error);
+		ret = -EIO;
+	} else {
+		params.gfn_start += count;
+		params.len -= count * PAGE_SIZE;
+		if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+			params.uaddr += count * PAGE_SIZE;
+
+		ret = 0;
+		if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
+			ret = -EFAULT;
+	}
+
+out:
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2220,6 +2447,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r = snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r = snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.25.1


