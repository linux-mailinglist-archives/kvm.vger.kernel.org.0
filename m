Return-Path: <kvm+bounces-16304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C46D28B865C
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A5C1C2162A
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 07:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F0D4EB38;
	Wed,  1 May 2024 07:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wem35fG/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3C24D9EF;
	Wed,  1 May 2024 07:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714549699; cv=fail; b=fRJ61eghMSGADIaa7lFQasVwo5S4mQMXYDck8ApMy45s7AU+OpE4zOouVh5RdFf2w3mqM3VnY2Xd84c5fzjgS1UDLQ7Xjl27g7/ORdcqZ3jMGVhyr8TIgo2TrgBa77Byl+hYe5+qpk1XZl4sIhA5sCNQLk5YigpYQwuZIngHL3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714549699; c=relaxed/simple;
	bh=ZPTHj1oq/Ts5Tgv+oxOM5kvyjrALP6F9dYvQjGz1Fe8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tEaIDxJHZ9XvPmNDvOixf8NMA3oMV8yD3V7XnoCtgTwFL5fsncT2TTOs6ZuuQVxLZt7HuEEYJBV5fsEJ/L4MpwcEGUw3P6+Fn9Y+GVr7nEgWURriw0YRwUKyAKWrim8zMIIOYMa0KkK86U90nzIus2x5/6/wBPf0ZW6eNgheSVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wem35fG/; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyYR5InUTA98zfsbk6hjFATbGzr2pJoRAP+9w7Y/ppoimVcOKv7xFVspSbbFswZlkpXF+L9imdRyfrMOQzF9Z6QYXukxJ2i57qWp3Z2CMJqRhByo1Yn3vn32N0liSrI1FvoaGo4uhMKQzCynHcIQBy8Sj7I9xqTXx9K9E+GHrFv85r9PLKkIkBwS/hNh5aOaQJpRcLP6YhUqveL/rsMtQ7zqx7g4GKN4cOaTzgXieI7KSl6f3MviQqxaUACY4QEZpEEEuvomSO2T9nVllX7PH6JdaePZ2HxQ+BFbg4hUDjW0arjQD1tOZpNk576QqJJjyysrca8BtUo0ZgI71cj0UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=55BsZiyOriOSg+pL30Cck6KPdOkZNWZZJ/n3ehKgAlU=;
 b=m1AZMJsTlqgviorug54XD2mK10OyE5KPjz8h4/602vy8T4TVFlLO84falg72v/Oj2rhslVxVGQQwlPCHhLv1EmoLUaUP7p4+NHSxufjemnMCdatPfN3Yf/P2ukw3z0CkRGt8sd+Wwn1BizTFXYX+rMwLG7mANGUq9wZqxwo510Jvp8cYJapZ9k9ouHuED0EG6Wsy21QEcCGDnIPpREAcqD+inQRduR8dnuklBN/8ec5hCckkJZJqKa/I/Uciu+dvw4zDo1zoUQYBR2Q1WFXiE8p4bblsYhwWLQGdrstn2Nb1Hz+G3sMouxznLtYAud7YEsEybwArAWc7/nt3mS+mWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55BsZiyOriOSg+pL30Cck6KPdOkZNWZZJ/n3ehKgAlU=;
 b=wem35fG/9nfcXUsfSsv5Tp75mCX/u8hZE+Gp1wdnTKR6pJhy3xI/p0zqyf/coOpBPkvORmzB3aFYrM0aWEMD3NrBdSvO4/XWAaZ2yqM78Q35TdalM9Xk461WJwu92LTJK+KLZq9gDK3Q5LhsPn2v6VntqFN6NMJkt+IOJ28KTqA=
Received: from PH8PR22CA0014.namprd22.prod.outlook.com (2603:10b6:510:2d1::29)
 by SJ0PR12MB8140.namprd12.prod.outlook.com (2603:10b6:a03:4e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.24; Wed, 1 May
 2024 07:48:15 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:510:2d1:cafe::cb) by PH8PR22CA0014.outlook.office365.com
 (2603:10b6:510:2d1::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36 via Frontend
 Transport; Wed, 1 May 2024 07:48:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 07:48:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 02:48:14 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>
Subject: [PATCH 4/4] KVM: SEV: Allow per-guest configuration of GHCB protocol version
Date: Wed, 1 May 2024 02:10:48 -0500
Message-ID: <20240501071048.2208265-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501071048.2208265-1-michael.roth@amd.com>
References: <20240501071048.2208265-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|SJ0PR12MB8140:EE_
X-MS-Office365-Filtering-Correlation-Id: 023a83b1-0973-441b-3f7b-08dc69b30f0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400014|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pzZ1EN6QItJAEJcltyx1edNlp74kPRg5fEC6R5QlMziJ/lAELVDtDl3bFjPl?=
 =?us-ascii?Q?uPQpHVlBVPBWyeb5Lo4jxeJcM+DoDyA1F9dt10O2DkHXWih0jnkQY76IhRcf?=
 =?us-ascii?Q?lDCC9F7YHLO9FZmE6EX1O256mCHh0TvzqpefwtUsiejrMXn1RysSUpNjdrpj?=
 =?us-ascii?Q?pXUkWzm8xoXHXPYR/bAFgla1VNxb/nz/c0Cot/EfWEsTfZh3+Ak5vW3NjrF2?=
 =?us-ascii?Q?pPnH4SyNpqNeDdDDbhCrYWIFm2tH2ekKNs5D37VhCJO2TbA8XhR8nmz7qddb?=
 =?us-ascii?Q?qeZcK6L+fFO2hzjTX8q5Y+EIW4v+4OQagIbuEB/SoTdSKH4McYH46WaB7Hn1?=
 =?us-ascii?Q?37GlTGX3S46Uj6kaH014ioCan0LLqesJoHxahSAa6xr7CHFkPjIzUG6ps6og?=
 =?us-ascii?Q?WHvyjh0nX8CqLpwEZWdB/E3oYUBqyFsBge5u7oOQc88CGJ8XT7FWVt+Yms+u?=
 =?us-ascii?Q?db98+2LmMvWqdv9C8P5ndf9kz7hfP2Q0LsTal20eDuczOVfi4FcjDzT7datP?=
 =?us-ascii?Q?SRlAgb+8hwHiHLXuntG7cLc9i9eW5mZ+/LOPF46QWMy0TpRQx7oFVtkcq1QD?=
 =?us-ascii?Q?WeU5fSuxcWRtWaqTZdf1VJgxVnCfRH9pVcw+XLV4o8EBUXwlNbJB+ppnmvqk?=
 =?us-ascii?Q?Eo8ZCRMjT7fEVDDj7H5NvXo98Uj4SGsaTx4G7HM5LnuC9abqHwJs0h3q5pSy?=
 =?us-ascii?Q?HnfuP+j+sRARee+JBGdTUluvwUVmvfbEY4lH++mT5oVyhvRYdSeAQPywL+Dj?=
 =?us-ascii?Q?oW9hTnWcBcuvhNdU+vAq4ZNCJr2x5wn+m16ZcgYmLF0DI50nQXMTHs7j3BHP?=
 =?us-ascii?Q?Y3KCwtyXanXwtSoKfecBMhHjHI7p8NaWR/Vv9BBotOfDJl1vgfPb8ltC7BxL?=
 =?us-ascii?Q?b2MM4uhqt+/nR1uVZTbxNBqEbSK7LPmj6/BpJoLTpU9YwryEVLXaN0LIUrsE?=
 =?us-ascii?Q?qOB6mdOpCYIp1XuWrBNkM6M0tW+fNI2+wqaRTC2bIb60qa5zKKIdifUWdIND?=
 =?us-ascii?Q?AKqVGAd4nqtHK0o57g06X8uQD/fseyucuXxQC7duc/Cur8rxPuSL9n8kaEdS?=
 =?us-ascii?Q?Xu2v4ntC0g8Xll1x86VjrTKCcrS8E4ohbigK6i2OZegPongy9O0wN9FyZNeb?=
 =?us-ascii?Q?VQp+yFFfvcMp+aalyReDPF3w675pRK+nWuOEnruTq8Wofi+C9h5z1ZbkByEM?=
 =?us-ascii?Q?FiA6HnErD0stnELav51l+l9Zc2UvRNCMZhxmeTSLKoLykdzS+YKguVXuGlQ7?=
 =?us-ascii?Q?J6iGdNmvAULk0ZlvJeB1imgiEbUEWSunNVmBYoBQ4Y6yTV+LAWC5fbEE56WP?=
 =?us-ascii?Q?yEq7LdBTqqvxhTEF1JKJBaY6sgcYZKc0EZSDBUXPIPkFZoAq2Cqx3RJurS+E?=
 =?us-ascii?Q?u1Mcpg3XFDG8skEhyQOLOHO/BmUw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 07:48:15.1213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 023a83b1-0973-441b-3f7b-08dc69b30f0c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8140

The GHCB protocol version may be different from one guest to the next.
Add a field to track it for each KVM instance and extend KVM_SEV_INIT2
to allow it to be configured by userspace.

Now that all SEV-ES support for GHCB protocol version 2 is in place, go
ahead and default to it when creating SEV-ES guests through the new
KVM_SEV_INIT2 interface. Keep the older KVM_SEV_ES_INIT interface
restricted to GHCB protocol version 1.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 11 +++++--
 arch/x86/include/uapi/asm/kvm.h               |  4 ++-
 arch/x86/kvm/svm/sev.c                        | 32 +++++++++++++++++--
 arch/x86/kvm/svm/svm.h                        |  1 +
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 3381556d596d..9677a0714a39 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -95,13 +95,19 @@ Returns: 0 on success, -negative on error
         struct kvm_sev_init {
                 __u64 vmsa_features;  /* initial value of features field in VMSA */
                 __u32 flags;          /* must be 0 */
-                __u32 pad[9];
+                __u16 ghcb_version;   /* maximum guest GHCB version allowed */
+                __u16 pad1;
+                __u32 pad2[8];
         };
 
 It is an error if the hypervisor does not support any of the bits that
 are set in ``flags`` or ``vmsa_features``.  ``vmsa_features`` must be
 0 for SEV virtual machines, as they do not have a VMSA.
 
+``ghcb_version`` must be 0 for SEV virtual machines, as they do not issue GHCB
+requests. If ``ghcb_version`` is 0 for any other guest type, then the maximum
+allowed guest GHCB protocol will default to version 2.
+
 This command replaces the deprecated KVM_SEV_INIT and KVM_SEV_ES_INIT commands.
 The commands did not have any parameters (the ```data``` field was unused) and
 only work for the KVM_X86_DEFAULT_VM machine type (0).
@@ -112,7 +118,8 @@ They behave as if:
   KVM_SEV_ES_INIT
 
 * the ``flags`` and ``vmsa_features`` fields of ``struct kvm_sev_init`` are
-  set to zero
+  set to zero, and ``ghcb_version`` is set to 0 for KVM_SEV_INIT and 1 for
+  KVM_SEV_ES_INIT.
 
 If the ``KVM_X86_SEV_VMSA_FEATURES`` attribute does not exist, the hypervisor only
 supports KVM_SEV_INIT and KVM_SEV_ES_INIT.  In that case, note that KVM_SEV_ES_INIT
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 72ad5ace118d..9fae1b73b529 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -711,7 +711,9 @@ struct kvm_sev_cmd {
 struct kvm_sev_init {
 	__u64 vmsa_features;
 	__u32 flags;
-	__u32 pad[9];
+	__u16 ghcb_version;
+	__u16 pad1;
+	__u32 pad2[8];
 };
 
 struct kvm_sev_launch_start {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 01baa8aa7e12..a4bde1193b92 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -33,7 +33,8 @@
 #include "cpuid.h"
 #include "trace.h"
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
+#define GHCB_VERSION_DEFAULT	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
 #define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
@@ -268,12 +269,24 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (data->vmsa_features & ~valid_vmsa_features)
 		return -EINVAL;
 
+	if (data->ghcb_version > GHCB_VERSION_MAX || (!es_active && data->ghcb_version))
+		return -EINVAL;
+
 	if (unlikely(sev->active))
 		return -EINVAL;
 
 	sev->active = true;
 	sev->es_active = es_active;
 	sev->vmsa_features = data->vmsa_features;
+	sev->ghcb_version = data->ghcb_version;
+
+	/*
+	 * Currently KVM supports the full range of mandatory features defined
+	 * by version 2 of the GHCB protocol, so default to that for SEV-ES
+	 * guests created via KVM_SEV_INIT2.
+	 */
+	if (sev->es_active && !sev->ghcb_version)
+		sev->ghcb_version = GHCB_VERSION_DEFAULT;
 
 	ret = sev_asid_new(sev);
 	if (ret)
@@ -307,6 +320,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_init data = {
 		.vmsa_features = 0,
+		.ghcb_version = 0,
 	};
 	unsigned long vm_type;
 
@@ -314,6 +328,14 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	vm_type = (argp->id == KVM_SEV_INIT ? KVM_X86_SEV_VM : KVM_X86_SEV_ES_VM);
+
+	/*
+	 * KVM_SEV_ES_INIT has been deprecated by KVM_SEV_INIT2, so it will
+	 * continue to only ever support the minimal GHCB protocol version.
+	 */
+	if (vm_type == KVM_X86_SEV_ES_VM)
+		data.ghcb_version = GHCB_VERSION_MIN;
+
 	return __sev_guest_init(kvm, argp, &data, vm_type);
 }
 
@@ -2897,6 +2919,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 	u64 ghcb_info;
 	int ret = 1;
 
@@ -2907,7 +2930,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
-		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
+		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO((__u64)sev->ghcb_version,
 						    GHCB_VERSION_MIN,
 						    sev_enc_bit));
 		break;
@@ -3268,11 +3291,14 @@ void sev_init_vmcb(struct vcpu_svm *svm)
 
 void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+
 	/*
 	 * Set the GHCB MSR value as per the GHCB specification when emulating
 	 * vCPU RESET for an SEV-ES guest.
 	 */
-	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
+	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO((__u64)sev->ghcb_version,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6fd0f5862681..9ae0c57c7d20 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -87,6 +87,7 @@ struct kvm_sev_info {
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	u64 vmsa_features;
+	u16 ghcb_version;	/* Highest guest GHCB protocol version allowed */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct list_head mirror_vms; /* List of VMs mirroring */
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
-- 
2.25.1


