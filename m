Return-Path: <kvm+bounces-61218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69852C1130C
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 20:40:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD22956198D
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 19:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4712C32C329;
	Mon, 27 Oct 2025 19:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MDwARtA2"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013043.outbound.protection.outlook.com [40.93.196.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA33329C41;
	Mon, 27 Oct 2025 19:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593658; cv=fail; b=uHU2judSmVVRTHnGdj0gjDkWrilU06rBmBA9+nZ/+rwAxBUi70oMBeoj89GnxzO6BhS19I6XDK1IcnRVZwmydBYmw/VCVfRc65OlI4+/lXflU5cWAmc5m40Km23mZHxBBu2DuKnaoph3HZkxlhcgpllnv7O02i/WR2ToY0w/oZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593658; c=relaxed/simple;
	bh=r84b4/P89ksJaa5Z80MwL/+4KxwORP4PgWaOSSaTsyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YHqW7g3u8kpEKW8vvCnexN4ZE+I/ha5mP+NOem87CQIkanGDlQlPSvfnDYMtGs8xkCh7wljBqjLYCWW4DVdgd5HMbnXMw99uCev+j5VS6SaEeJG50rSbIZ7aoXjGRerx+wDIxhsf3vWuc+9W/RRVAzLwhGWBlsnedeXFunYU2+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MDwARtA2; arc=fail smtp.client-ip=40.93.196.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zGDk0qvahEG/lrERkXrpqsrB+aws/fOb1EEJti8G7R+hEkVZKYXB0ZEIBwPSC2kbLUF8xnCPpdxigASuLiIauYDxM5BWurPtLJalnBgEdtbFJ5N8brQZlVFHwKHNZyHTghLtKaRUfKcMEqUtOPvxFev1vQqnhsr04XBO5HheNQEpd7DDaYXNpFEqyH1r4BcSbOM38fKSc6vTabIt9WINKLnRsrBS2fcr8HY3AwJzbLlEKZwhJXYHDVpmhp7J3jI6BNkles50+YqiKhLxsisI2XPe9r6JfV+TY5zKKoCjGC0hJ4zs69VDItppB+jCQUrGA7RsfT0oApjCc+TqwNyqPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FUxvbvx4I1H6k+uY9Y46qGBxkJRFGlb7aT1XUCRux8=;
 b=K4y6N0IrDhbUnfUKmUKlTBXYRxnvDf5tugxZeVtH3GfKi04EK02AkxPZp+urtpvNYv2jZP/dS+nD904iBI1kp3f9VWsDBY08ROzlh9mTwXmHOkn17zwMhh8fBjE2GGRYqlJuHskkWt6iaXGEgOYEN3YG3gQfGDB2A76X78iv4dBmUYUUNKsaTh9nmcqBLDx37mvQze3n/CfSfB/dyd1qzCSP1YBpDa/1Kr2pHBeaFOoFqQpsHEeHYlyv/gTR2GX533zW0tXm6IMWk3ywRJBT3/FD/QIfHxf8pLL6nP2etxqwzv69kYkgsBHtOJ3svRMRJyguxu4ROI+8KFMGh+C9Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FUxvbvx4I1H6k+uY9Y46qGBxkJRFGlb7aT1XUCRux8=;
 b=MDwARtA2ahj1qZaTjhj16fiCQe/Ec5kWa4kk8xZmJHlfrY1OLs5x9M8W5ViN9lVHBQW+ZayXXCZvVPp5c7uH9e3OIa8t/GIYEZsPBFfZxeLbyUhU8d2G+RTElPizoEndh61ekqmDm/sT9EJdvaMxYA4VxWsnLGM43ij+4qWalIQ=
Received: from MN2PR08CA0012.namprd08.prod.outlook.com (2603:10b6:208:239::17)
 by SA1PR12MB8986.namprd12.prod.outlook.com (2603:10b6:806:375::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 19:34:13 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:239:cafe::9c) by MN2PR08CA0012.outlook.office365.com
 (2603:10b6:208:239::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.18 via Frontend Transport; Mon,
 27 Oct 2025 19:34:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Mon, 27 Oct 2025 19:34:13 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 27 Oct
 2025 12:34:12 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v4 1/4] KVM: SEV: Consolidate the SEV policy bits in a single header file
Date: Mon, 27 Oct 2025 14:33:49 -0500
Message-ID: <d9639f88a0b521a1a67aeac77cc609fdea1f90bd.1761593632.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1761593631.git.thomas.lendacky@amd.com>
References: <cover.1761593631.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|SA1PR12MB8986:EE_
X-MS-Office365-Filtering-Correlation-Id: ee2a47e2-0458-4dce-da69-08de158fcf19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WvSt3vb5+kv1djPqvYur8Cgx2GSXfTwwm58G65puNI/2sCtPuWKhRjHktFKO?=
 =?us-ascii?Q?g0/acFdACwfKaJMS56FLMsnu681kx+g1TS59ktExf5ZBLXF3JRWPrFxXBCD4?=
 =?us-ascii?Q?Lg9K1FM1zPbdCgSol5BtjGRD3urH6tyrl0R9XlcSIYTUl6ticYRTbRCogv6F?=
 =?us-ascii?Q?ZzD6tVis4aUI94tABSoeoB6t9PVE8waVswm6vZ7d0Tg9FcqY4ov5V7+mfewv?=
 =?us-ascii?Q?v86MoMblwxTiYoVAysu7p5dbpP3BF9JqzCC9ja0sxxEENOyKQ35WnId5ux7c?=
 =?us-ascii?Q?CFdi2kLdUavWqOuU8cWIDx0Xr4tNjE/X65I9mA5WwZf0oZou1bcC7Y6nWhW1?=
 =?us-ascii?Q?06/XjfiU10c/Esb9lOrv/ZV0aAev/KCKQB3sNG7+5Moa3YH84pfBu4S443NA?=
 =?us-ascii?Q?iz259JB760XleHQYXTiSl0iunZJm9ZemeDSAiclpQhBLHbMWIBA5TA26e6KM?=
 =?us-ascii?Q?VvzJO/5zdBYLkfVdTfWVbcYz0xO1szwyPmGDFxmgsTToGYh1ESRvuEFYYEBL?=
 =?us-ascii?Q?zqFrpbv77ES1hfhU06Yw5JNysWrsqJ/Z8d1xQfKpv0IN7xrM/6vDfr2ha/rZ?=
 =?us-ascii?Q?O1e8YZTB0ANQtq941EhApFY1reGFZT9phTVGiS5TcjSgT5oL+AkzTL4C0FSn?=
 =?us-ascii?Q?SyYk6xI0B4Oh6s8DrdqRaPnRLdlBNqv7Y/J8jAMwXTggZM15OrbGLBf8qpxt?=
 =?us-ascii?Q?rE35pYJWcWYILKmcEOCNzC6befCkSHYbNjoTiR4bEu1r9HXIYDH266hkInSf?=
 =?us-ascii?Q?qsH21U+SmdNGvd+bcJtLcyJ+lawVYc5AOujjJFk2+TgI8+25HFDoTXmOKucw?=
 =?us-ascii?Q?oEqJrCwoC9lq64qa95CGsyJnr6nNT30mz2vBe52JGJjBUI8vFYwQqnx7LKUZ?=
 =?us-ascii?Q?nOufg0JEaPXNtpRozwXSnTydY115w8FlvxsvxZdC55FPNE/nUsvv2oj8DlY1?=
 =?us-ascii?Q?hbOHBbmMwGBbdeU7T3EUFnZfYg1P0cMm8MCGfkFGaKQkc+aeOsbcQb+M6oFZ?=
 =?us-ascii?Q?SFosiav207mLutzqtTzf3d/y5LDyDBCmc/TuXk+5ejACq7xF1vlYRg92fLDO?=
 =?us-ascii?Q?vgNdUXnJgQIF3XRjsu9QYUIT6sD2u2JsiknNmNNn8fvUNU3gbvKzJVFvuwz9?=
 =?us-ascii?Q?jht3VOBp5JNUBfdYPifKr3VlcZHPSj9NuTN+2BJs/xv2hKJBD5xD4Hf8alsR?=
 =?us-ascii?Q?qibx9V85BB5TBbqUWKQGcYjHPYHpE6+4+j236/dGKVpTJqUkhGVAxfAmub3H?=
 =?us-ascii?Q?MSFE86/XMOuoKFcrR4FAg1bSetiWE5p2i5pk3U3adA3TzMqL7VOPv7smFjTh?=
 =?us-ascii?Q?LdHsXzWuyiVBlvhnbfeVIrU1AdC4MS58GvKLiQw/X8Zm7r2gFVPKHT5T7T3Q?=
 =?us-ascii?Q?/PzpElbpIo+vSwtWpZs0tbcpP9suyFhgXfyjO3TsPZIJjneirZcBtfyQhHBL?=
 =?us-ascii?Q?3emvexFeGdcavQHfrPWJoeOo5aUozdPCDehFb7/j/Q6gloo058Dspz2VHizH?=
 =?us-ascii?Q?AKyAMhqPj+SaxEVRD6aKyZHZT7NnXG01PqldGeoBDVfZp+uq+GHxraZQH1a9?=
 =?us-ascii?Q?RLhDFgQgZXQkIt8t6f4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 19:34:13.1828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee2a47e2-0458-4dce-da69-08de158fcf19
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8986

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
index 0835c664fbfd..f04589ae76bb 100644
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
@@ -2207,7 +2199,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.flags)
 		return -EINVAL;
 
-	if (params.policy & ~SNP_POLICY_MASK_VALID)
+	if (params.policy & ~KVM_SNP_POLICY_MASK_VALID)
 		return -EINVAL;
 
 	/* Check for policy bits that must be set */
@@ -5085,10 +5077,10 @@ struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 
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


