Return-Path: <kvm+bounces-60843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27374BFDA01
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 19:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54BD93A34A9
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36852D5C67;
	Wed, 22 Oct 2025 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F97T6tyb"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013043.outbound.protection.outlook.com [40.93.196.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487F02D4811;
	Wed, 22 Oct 2025 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154693; cv=fail; b=rt7W4+Yl47Nc1hhCRZ3E9AVqqZfqqR9WMNUrEUBvUMJQ6UpICfZlSUCKM4mjB27OE1aIv1JUANwSqmHVVY4BVudN6vIUae3HM9r5OM5zyRLBFe5++YYvGGoh5G5xsK1eKk8M7gbOLV1CxaC5CDdcaBrrtGc1tmXLlAnm3oAQmw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154693; c=relaxed/simple;
	bh=PuoTyl9ye9CN0/xbVpsf3ax+i4FUMyuVR19Q2eg5t8M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=debZtQ0yVmUjfMEgMuexzKhhvCMlkFMQVG7gyj/zVoXBLwJrTndDFg1gzR0zXGYP3ru3yh5HlDeyjuDNiAt9vKGyK6gxmZ+LA+UMryqc7b9fijEw0RV9uhp5E+nt5ZPPZPRjpKgnn2VdC5h1MXWJiPSSzU9vyDH2GJkR4Q8uKNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F97T6tyb; arc=fail smtp.client-ip=40.93.196.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LpDbqBooPXT/9uIhtQWhFHjJAR2O5rOvOCkGpaKggaeh7U3K1xtU1kgr2gg8RJuWJcPFYecPNCpRX7uBPQFY2GHa1+ALKCq9rLfpdYfQI+/1RklTIJmJKGe8vtDDIvbzP+U9vMVdVuhN0yDLDa0joUprqbx1MnukwLjD6mo9HkHCWY4k1QNbGq49lNFa0sSCOS8iTp2uh5kAMIOHgijZWBUi30AKLB3SDhjT1RfuhPM4SFmBRSfzV/oEmW566QqOW/x1JQfHp77EzmXD1UWD+m/G70l+3MliN9dJq0OVBb+CGQ7CVB0HzQWoMhrWKAOfuooq4DHgG8fTXaeuos0C/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuGzia3XeBZUZpraRdNlkzYKccM9/9G2QiGfESQ+5fg=;
 b=N5iYgHvlcqhqftEQN5gFWJ42Ibi2BTpInOK9b+55Y0sSUb59OkPWB2+oBc0Il7yJQQOxyaGH8mHGe45p3jSRZGpFHX5fb3N6uvb2/o9d44LjdXa4qKNFgC0+bqfkUYArGD1oRWzkRub+cxBBeG+Eu5x4x60yn+i+7Ci0ijmtbRmhBrxXNXfyi6vyA+hE/9/oelKJ3vO9UsxMs1oy6Q2gjNcEIp5LgT0eMAbd1XjnyBJFRSVzNMzF6zcKFsx7lsS5YNxqET5QxgQbj5TvGm5k+JjsesMVyHVUUcsxFQ/bVyU23vJcWdkeSwyuHgJni6ow7ktQlyGLq3wZox2Tj5tpOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuGzia3XeBZUZpraRdNlkzYKccM9/9G2QiGfESQ+5fg=;
 b=F97T6tybe8KY/g3ZqNJF7MQLpWd4Mo4gPzAx3YTLgzhC03CxSQ5DKUDqp5qBFrq9eovequGQ8pHBm/zOruUk68NtNMmwwHJMeRK/GaKk8sTJIhBuJrEMKpciRGP6v+Dg8zZHbeV+Qf8bQcL/0gzNXXOtjBMn5Nd1ESFw8XYuyWM=
Received: from SJ0PR03CA0216.namprd03.prod.outlook.com (2603:10b6:a03:39f::11)
 by DS7PR12MB9475.namprd12.prod.outlook.com (2603:10b6:8:251::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 17:38:09 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::fb) by SJ0PR03CA0216.outlook.office365.com
 (2603:10b6:a03:39f::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Wed,
 22 Oct 2025 17:38:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Wed, 22 Oct 2025 17:38:08 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 22 Oct
 2025 10:38:07 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v3 2/4] KVM: SEV: Consolidate the SEV policy bits in a single header file
Date: Wed, 22 Oct 2025 12:37:22 -0500
Message-ID: <68f3807f80245fd5f5f1bd02645bea387b65d6cb.1761154644.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1761154644.git.thomas.lendacky@amd.com>
References: <cover.1761154644.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|DS7PR12MB9475:EE_
X-MS-Office365-Filtering-Correlation-Id: 95aab2ac-e0dc-4de6-1eec-08de1191c397
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+sg9v4uyx542+YQVUCRwb7KwZyz4HO4cVtDyPvuVg86LiBZvVCahwozwtZBg?=
 =?us-ascii?Q?Q7E8MglyBy3CXZcsa8J4e5mrwl8xsd8/O7enKV+pZG6CrPKSk7Qx6SiUk9H0?=
 =?us-ascii?Q?j27tEz8WV6aKKTDQR5xppcyj3XhtZXye0SovEF/nD4sYrEC2wCEK3HLivFMs?=
 =?us-ascii?Q?a2eGebGJcPmCwYoGH/SwwV9RIyh8bdC3EpJj4tIVt9cNcaaGq9pZ3R7ddfGn?=
 =?us-ascii?Q?bInARzDgl7CD83VPgPvO6Z4PlV1PMCfPxeISICxWml1Mc6WIRfm8KC8DEFlM?=
 =?us-ascii?Q?gGt66pctrJ6GL/0yajciCg6s+wuMBo8J0JYl7D05cNrnvkf7VaZ3lKOqLcgh?=
 =?us-ascii?Q?+9WrorVu0nh6WezXzwdfB8tuChvlARK2IVwgM37OyN6nWZsFyizh8JhSescC?=
 =?us-ascii?Q?zhNDV1l3tHLskC7MCZTLv5NcKuMl2VNyVPJuLtgqOCL6HapiT7yAYL4Qh+pm?=
 =?us-ascii?Q?Jbes/xpqLGtu66e7GcgM4YoTMMnnVDFAylGBcrFeCcmVxOEvjgDVsbJpFYkU?=
 =?us-ascii?Q?tJedvtdysEyeIun1ev3Q70p3YCDRVPjiU712RspCaXvFXRJuYq5t+kMBT3AY?=
 =?us-ascii?Q?nFr+Go7Jv2pC1LFtfvWlB/vVeGR/mdIL3XjykCs4IojOFmwZt/cRcZ9zz/ZX?=
 =?us-ascii?Q?gs+TgYL0tp0a4elZ5czGJiMwuzWC+A5koY69a3SQoh46hyAfbooSPiiMBVVU?=
 =?us-ascii?Q?rk1NdBoQAqUUU6OnsWXVvgarWJjUb03j8aBh6IAQHcTmlZoPDQMQ3uYucV3U?=
 =?us-ascii?Q?xSVCNxUWE9Ns0FfAfkWAw/0vH1XGfzb+MP2r6838gxAdqgc79DEut530gz1I?=
 =?us-ascii?Q?DEGhM6vowCMr8a9fnMS/o0B3aBA7XyyiHeur1VXo/WtZPPsOg5eDthCR+Z3g?=
 =?us-ascii?Q?8mO9O1p2DtTn+4we9pr21LOl2u4hdQGaoFFClMQpJPPHLDWdTqqcw4+oRoR0?=
 =?us-ascii?Q?bKO2P7uI0EzSdBbMelYcT0VZckd06j9rJ7hNy2kbTTRAhrn89bLphYGGsZOa?=
 =?us-ascii?Q?nncRiSRmG6df/WyJtNdRswlgK0MEyyJoWtBFpEj5PofaSqMWE8uI2ltTN9fu?=
 =?us-ascii?Q?1o6shCtcfjhl7kUUHBVkqj5l8zbj+FQ4ifS902CefLQHwiRguy2QaelA5eLV?=
 =?us-ascii?Q?pawBRVggG8UzN/nXm//yS0pJQ4VjywH7VKNgqs/Oc3jxeLHYZcQUhJLALlRB?=
 =?us-ascii?Q?6R4X3aaBOh5H5VulXm4TvYgZVpjRFbQPZ/hKciytWDXqJtkuRhqZaVGJKl0z?=
 =?us-ascii?Q?Fws72Nb+XY78vA6iWgchN+34WSFWriAtd2JjgAWE0sKMAhbe8Q3IYDt6Q2BH?=
 =?us-ascii?Q?H4ivndNvXgcBbOgJ5tOqdydVTGdaLp36T0LM/0cLRBWds+EkrfxfsxkE/RvP?=
 =?us-ascii?Q?/W5a4PdkmHJgYjHSkL6ENM7fxQQ6g5hm3DEdHyYeRvG+tRfr7PhAyjm/9WBw?=
 =?us-ascii?Q?Y5e+NhsIP7Ix3HsuRdtHD90ysjK1741UlgW0npERO/yuRllrjbfNx1UjCD4U?=
 =?us-ascii?Q?fh88adlzP2NQUgXTEqYJzuyBTpdi5tQcvzmT8cZTivz12/Ir1STXjth0vdWl?=
 =?us-ascii?Q?AnU8CqJkNErE5Wz4bFU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 17:38:08.1229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95aab2ac-e0dc-4de6-1eec-08de1191c397
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9475

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
index 72cc7cc8c9b8..45e87d756e15 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -65,15 +65,7 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
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
@@ -3107,7 +3099,7 @@ void __init sev_hardware_setup(void)
 			sev_snp_supported = is_sev_snp_initialized();
 
 		if (sev_snp_supported) {
-			snp_supported_policy_bits = SNP_POLICY_MASK_VALID;
+			snp_supported_policy_bits = KVM_SNP_POLICY_MASK_VALID;
 			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
 		}
 
@@ -5093,10 +5085,10 @@ struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 
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
index e4b04f435b3d..379e14ad30e5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -117,9 +117,6 @@ struct kvm_sev_info {
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
2.51.1


