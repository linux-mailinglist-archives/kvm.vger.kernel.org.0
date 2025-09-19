Return-Path: <kvm+bounces-58180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E2CB8B05C
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04B9C1CC565F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B977727F16F;
	Fri, 19 Sep 2025 19:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PORvNiKB"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010037.outbound.protection.outlook.com [52.101.56.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FE72566F2;
	Fri, 19 Sep 2025 19:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308456; cv=fail; b=YyqoiCqkwJbfb8RNZQ4sF3f2zjGF2HT5eoVai5JIxLAm+qkVqTbTxgDI57K95p2y5uE+484EjX30Xqh3ank8iSaKRrebgFN8O9mYrQd9TvJtw2ogHGkYHoB9HyhWTKYXRNDJMkawUQLfj5iMT1tmqDJoIQqowt29C5pzsO3KWVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308456; c=relaxed/simple;
	bh=PFHCaLyZGihPWrS3tBpQMN7AD1bRBGpy3Su7wQ00E2w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kXqzx0Oq0YTW5StQweoYOvefFrd0in1dvzL53HLqMYfX5Iti/C3MtGZwANJOfqFxV81BGvSMPKYHch8eRmHKI1AykQNh561NCtqj+tT/eMHM+kHj3YiEgvnSdEtIolkWeVPMjSnhVoYbOSGUcWg9QmDwkmoLTkiCPCe+U1E6Cv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PORvNiKB; arc=fail smtp.client-ip=52.101.56.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fu2Xz8bbdMfzoe21NmQH8HrWiJEDCn4QkyZKmluLp+9vpGW0n1pI1V9eKLj7sCh+4/X9UvLnnYA+iVDdR7ojl3GpdCpP7TaqK3C1ISYgzGDWPvq9pryx0sdWpvneXLtW1lR+1OPDNluOrR10dgPkHMZD2B3QaW67WoOieMpguP2QEXC320C7lPei8Ai9fDtZKl1VRDtjecMfCcDw7TL6IvOxDjiOY4n1kMB+c8r0vzX0FKgoNFumgPVlBCJ37fZ+92Y+GlvOQP3+imf5kq9UvkxsQ77bYGDc/0lyU0AZ47m4r8P9fSAQb6oaeIwkCdGiaU+BW1tpXW2lNwZhqlYs6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G451SQdXWSf1qndqz5qjRiQ9dHhcLo0u/qaafmkmLH8=;
 b=hFka5/qE7s+IY+5S3Bfq9Z7h5167rjLB/cJFxl1AYO+NT02wM6t/yuBAmTHhMQt8Y6+CaYunAwztjEAYKEo9XMQP6QcsunOgSKeCvqfYZ9DxsKXcK/4IcHpwRPJ3GUgzP0Qz4qsS9/WjbB5NyiHjEN8bujUvZcsWON4eT9FjPIfkIc72YsE1I5XftMbe9CNOrn9Tf5zRJ98U38KvlG3KcpVL1GPvLGsAHlNqLlVN4gpSpL7zsTSIptx4edvA6VFYH6DjI7NJHBGAFohETro0ZoGokId8bu4v7fB6LPpyCb5JXZbPGJ6Rv2halfSnVEV2EOyoiXY14duaeQHsM9WLKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G451SQdXWSf1qndqz5qjRiQ9dHhcLo0u/qaafmkmLH8=;
 b=PORvNiKB8fleNFmS2oROVHK0F8bwhKlmfOoBRZHt00EXshfziFxxHUXRpIqYcWg4+zqxQiJRianU3lsCwEK72XTfISJ/vM7xpBCpmj++4KAqC3o0fWdNZ+q8EdwiVCXKxHKXRiNFebsIRKmjLhHo8oU/Ah0YcGTu7q6JBaXk60w=
Received: from SJ0PR03CA0337.namprd03.prod.outlook.com (2603:10b6:a03:39c::12)
 by IA1PR12MB6457.namprd12.prod.outlook.com (2603:10b6:208:3ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Fri, 19 Sep
 2025 19:00:50 +0000
Received: from CO1PEPF000044FC.namprd21.prod.outlook.com
 (2603:10b6:a03:39c:cafe::14) by SJ0PR03CA0337.outlook.office365.com
 (2603:10b6:a03:39c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Fri,
 19 Sep 2025 19:00:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044FC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.0 via Frontend Transport; Fri, 19 Sep 2025 19:00:49 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 12:00:48 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH v2 2/4] KVM: SEV: Consolidate the SEV policy bits in a single header file
Date: Fri, 19 Sep 2025 14:00:06 -0500
Message-ID: <0b8321ece36d946fb348ab38332eeaa9982375fd.1758308408.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1758308408.git.thomas.lendacky@amd.com>
References: <cover.1758308408.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FC:EE_|IA1PR12MB6457:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c24ffe9-5c1c-4b6f-bee3-08ddf7aed928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2i1kl1N2bFWbE1Y1/WALka298KYRSjFuNQxSoqJmocS54Osb5bt+x9Etca6o?=
 =?us-ascii?Q?bT4syJe1Z56c6b/Rp7bIfmLwTckSCe79Opybl7XDwez7X4tLTZ/ZHorb7LW0?=
 =?us-ascii?Q?e37LYWE1id6TGlFaBuc49G74AZFU4N3Dht8a8oIrb4b/BJPFNWi8huv3PirK?=
 =?us-ascii?Q?caUgMzkG5f7Bv9BCxO1aaeGb4n5XgYVzeq8RKb4LwDfinE1SwJBbQrabQpza?=
 =?us-ascii?Q?kmNLyAwWxHElZqu6dwytCNZdoKGKTfz+WOqL/xDWPCXHspLaCdcuJ9wSB7Mb?=
 =?us-ascii?Q?/yzrsJai7TbS8hh06TKy2j/Dv511cQtBIG99JZ+UoVHYPZjhzRm3t/lDGGZX?=
 =?us-ascii?Q?abhVH9t5L1/c7DdHxDQa/aMDAWe4qVeWX60GEA8zy3/jCu2duzWO+inDozzG?=
 =?us-ascii?Q?Fv+iCButwAljB8AiqBd55s2cVkzPStwiDALCEeHHL1TXg/oxqQg2oNH6Cuq4?=
 =?us-ascii?Q?qFuPLk5ZeZh1nSmxrJc+2IXvrqsYhAlYLIL3nNKtESRIaNpKfhmVjPLa4wzA?=
 =?us-ascii?Q?t93gfCg3CiihBN7DWrjxLANKTNzpmx6ohtWQIE6m3u5e7WJUPBRz2FoL2hFq?=
 =?us-ascii?Q?E9xmkchpLe5QF9sZT4acwQZhJXkWZr5ZkUON0x2ZfAxKSYMkJi/OjrHwlQ+x?=
 =?us-ascii?Q?BSAbxbRuaV6Vr8/FU1JPk8A4PXow0F1sAIn95ExSy65h1Wx5ilPbesrZdryF?=
 =?us-ascii?Q?5q59A6IE+M/y4GhTE9D3RxmHEQJ1814/EN6byKA/nu1xFLHGFQ6GhM9iq5WE?=
 =?us-ascii?Q?BeLSrD81Ahjz8Qtb7DLkMYqNAxgpmyigkcEd20TA8Hxuc92zl0Mta34q5MF5?=
 =?us-ascii?Q?oJMeBpN+pJhlkMaUJkqiSLKqmC2Z27xa3tBGf9Ru0aaGIGQABiHjJYGeN1OY?=
 =?us-ascii?Q?OVK7eEgesU6JAvC/REYLjp3HwwR0Z8kWW6ydu/qHTAWxUvJgwKXkU2wmVv29?=
 =?us-ascii?Q?jSUOt9dnJtD1C2I62q9eT7K7z9q196VKf2Mb83EZJxB/D7dERzIYxM3KAX5p?=
 =?us-ascii?Q?o73VVCP11KXT2C3smT/EkGwpE/YSo2yTjTbsP5kog/MRK5VmbUBmMzbnQcYV?=
 =?us-ascii?Q?iAoaxtEY1BhM1FERVDFixiCTib1ofUa2OWyWjh9xis/jZt7Owqi+PN+P1XU1?=
 =?us-ascii?Q?Uh98342aknYbQehnko7r7ffrpQyFqFkLmgykMZrII06BoDN4385p8PI7OnmR?=
 =?us-ascii?Q?UIM4FwlRILLzz1C1VKrudvJgpL4NFE8IsSgjogEO4m7rx8BObz999OgnLluY?=
 =?us-ascii?Q?0IpN1o+WQb0QBStYeErjygatozof2gvkHjW/FVoNn26QFxyZUe5YerhmoEZ1?=
 =?us-ascii?Q?zypeX7mNPvHJ8Wp6GDpepdUTimm9AXm5jxm1yBPJrBOekNiYPv7kCEQmgc7E?=
 =?us-ascii?Q?wyrv4yDh+Hp4vKweuVwWDbh75JNz41Gf0at9liVU6S0/4+2Hl1WJ/5eBhuOw?=
 =?us-ascii?Q?/4pIqrO6vCPpAdKy/pjbBHMAm6WkKhbVZiADOQRXbXDz6q0An7JDHjXAjWW+?=
 =?us-ascii?Q?vBpzt4fjfAlpaQq1EyIokgNIj1N1fde/bR2J?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:00:49.4814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c24ffe9-5c1c-4b6f-bee3-08ddf7aed928
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6457

Consolidate SEV policy bit definitions into a single file. Use
include/linux/psp-sev.h to hold the definitions and remove the current
definitions from the arch/x86/kvm/svm/sev.c and arch/x86/include/svm.h
files.

No functional change intended.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c  | 16 ++++------------
 arch/x86/kvm/svm/svm.h  |  3 ---
 include/linux/psp-sev.h | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 65bb2515ffb7..e63f2ee57204 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -66,15 +66,7 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
-/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
-#define SNP_POLICY_MASK_API_MINOR	GENMASK_ULL(7, 0)
-#define SNP_POLICY_MASK_API_MAJOR	GENMASK_ULL(15, 8)
-#define SNP_POLICY_MASK_SMT		BIT_ULL(16)
-#define SNP_POLICY_MASK_RSVD_MBO	BIT_ULL(17)
-#define SNP_POLICY_MASK_DEBUG		BIT_ULL(19)
-#define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
-
-#define SNP_POLICY_MASK_VALID		(SNP_POLICY_MASK_API_MINOR	| \
+#define KVM_SNP_POLICY_MASK_VALID	(SNP_POLICY_MASK_API_MINOR	| \
 					 SNP_POLICY_MASK_API_MAJOR	| \
 					 SNP_POLICY_MASK_SMT		| \
 					 SNP_POLICY_MASK_RSVD_MBO	| \
@@ -3091,7 +3083,7 @@ void __init sev_hardware_setup(void)
 			sev_snp_supported = is_sev_snp_initialized();
 
 		if (sev_snp_supported) {
-			snp_supported_policy_bits = SNP_POLICY_MASK_VALID;
+			snp_supported_policy_bits = KVM_SNP_POLICY_MASK_VALID;
 			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
 		}
 
@@ -5040,10 +5032,10 @@ struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 
 	/* Check if the SEV policy allows debugging */
 	if (sev_snp_guest(vcpu->kvm)) {
-		if (!(sev->policy & SNP_POLICY_DEBUG))
+		if (!(sev->policy & SNP_POLICY_MASK_DEBUG))
 			return NULL;
 	} else {
-		if (sev->policy & SEV_POLICY_NODBG)
+		if (sev->policy & SEV_POLICY_MASK_NODBG)
 			return NULL;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..61911a2b78c3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -113,9 +113,6 @@ struct kvm_sev_info {
 	cpumask_var_t have_run_cpus; /* CPUs that have done VMRUN for this VM. */
 };
 
-#define SEV_POLICY_NODBG	BIT_ULL(0)
-#define SNP_POLICY_DEBUG	BIT_ULL(19)
-
 struct kvm_svm {
 	struct kvm kvm;
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index e0dbcb4b4fd9..27c92543bf38 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -14,6 +14,25 @@
 
 #include <uapi/linux/psp-sev.h>
 
+/* As defined by SEV API, under "Guest Policy". */
+#define SEV_POLICY_MASK_NODBG			BIT(0)
+#define SEV_POLICY_MASK_NOKS			BIT(1)
+#define SEV_POLICY_MASK_ES			BIT(2)
+#define SEV_POLICY_MASK_NOSEND			BIT(3)
+#define SEV_POLICY_MASK_DOMAIN			BIT(4)
+#define SEV_POLICY_MASK_SEV			BIT(5)
+#define SEV_POLICY_MASK_API_MAJOR		GENMASK(23, 16)
+#define SEV_POLICY_MASK_API_MINOR		GENMASK(31, 24)
+
+/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
+#define SNP_POLICY_MASK_API_MINOR		GENMASK_ULL(7, 0)
+#define SNP_POLICY_MASK_API_MAJOR		GENMASK_ULL(15, 8)
+#define SNP_POLICY_MASK_SMT			BIT_ULL(16)
+#define SNP_POLICY_MASK_RSVD_MBO		BIT_ULL(17)
+#define SNP_POLICY_MASK_MIGRATE_MA		BIT_ULL(18)
+#define SNP_POLICY_MASK_DEBUG			BIT_ULL(19)
+#define SNP_POLICY_MASK_SINGLE_SOCKET		BIT_ULL(20)
+
 #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
 
 /**
-- 
2.46.2


