Return-Path: <kvm+bounces-43739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 210DEA95A2F
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 02:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C8D317500C
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 00:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6954A14BFA2;
	Tue, 22 Apr 2025 00:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wpvzcx2Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FB078C91;
	Tue, 22 Apr 2025 00:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745281536; cv=fail; b=CFq/3EoA2qFqml+LW1SHagWV7mI7SjSiUTd9pKJXvCmPNiEQ6tf3gY64fu0MW6m86IwFvqDQDM1e0sCsncn4uWZOH1N4SvOQpDGUKKAvwbB5IZIlRU32IpvE7XbxtJPxY9qXBkzhKtFpexBvVoE4Y6DURltQAujKzjjioK9mKJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745281536; c=relaxed/simple;
	bh=vh39ONNVYu1qA9fZZzaPVguXl5scdhzV99zQM8WWZYU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fV0x3RGwaL9DbmM3EATikSagW9IawjKgwkBtGZUTn5oi8HAW9A5m2Pyh4PoniAq0ojAZPBPk22KRyCVG8lzgbby3fOYYafL+SFoCO3tYi3xY7q+wIuo8On+/hoHort6kuB7OVoXQhWQqX7/Uegl+sBldFVcj8OClitbdLaFWqv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wpvzcx2Y; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WmuNW6vwgIyKB9YqNKRoo1KZyerR2IixK8bwmXxUFj6UYKE5d44otWx9dvu18/NM3XXYwBPdlgNz0ZbajqFYPmgwW+YqcxCc/2J13gk6ROVKRkS20J3f4XyY7RD1NTcKMqUZ1ILQPmb0iBMN/QWAwALZbcqQzyilJ1IKt2E44orMYxTOl3n/wy5yc/JZonwisTG4mBWWCXxOhDFPhCRU9Hl063JpeCW5Z429bipwxcNDVzrY56dqT4QawR2ziz1ZZ6vYyA5c5vnRhYo5DMrm7JgiCYD0BkHpo0lHh3NN+zwNFBNkYltkEiX2GRo2dm/1bv1pMbwa/PPNf3FzoiOffg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HDEhbbL+pkSEqxULIZEOH/7Vt8ITkMTD40e0xID/3z8=;
 b=VHgy0Ebbm2eRVQELs8H7cLgIT6KXND7E4iBtVw2BbWXw99JmnF/GzBsuXHVAEWKFfQNmgWwANlTa+mI0daGY/A+TRVdbgUF4Xc2UpFdv7nC0mJGCJVYXRx3GUutrhuBLwX9UUPKf5T5PoMzNpd8IadIN8YCsZ9j1uzAKrE03DKB8SKH7oSoibjh0kphWUkf8kg+u0k/Hwp5UHXnOubS4K6UUtdtPMZ0RtsFTaV+qj4AGIeprJG7hgdkUWo0cmV+t2of3/u7k1URMtwK+zzBRgcRZ2qOqKUqpdvXrZeWSPF8F07ddvi7GGovVhSfZ+CNkHKmQgmRbLUYnwKGxuiVreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDEhbbL+pkSEqxULIZEOH/7Vt8ITkMTD40e0xID/3z8=;
 b=wpvzcx2YrGwgAKUyhzHjJERwfNbf3p8xDchQ4eSBLieZipwAUUU3HCvEH0m33Su7zJYE++UQyvy6Z47tkVUEP4vXA48611pCFodXd9d9412DE9gVjaoKCdCmBLWGQif8aerQxPlkGOlEe2O9Lg+AuZPKQpRoqs59l3a2VNROOvI=
Received: from BN9PR03CA0206.namprd03.prod.outlook.com (2603:10b6:408:f9::31)
 by CY5PR12MB6455.namprd12.prod.outlook.com (2603:10b6:930:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 00:25:31 +0000
Received: from BN3PEPF0000B06D.namprd21.prod.outlook.com
 (2603:10b6:408:f9:cafe::46) by BN9PR03CA0206.outlook.office365.com
 (2603:10b6:408:f9::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.35 via Frontend Transport; Tue,
 22 Apr 2025 00:25:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06D.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.1 via Frontend Transport; Tue, 22 Apr 2025 00:25:31 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Apr
 2025 19:25:29 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v3 4/4] KVM: SVM: Add SEV-SNP CipherTextHiding support
Date: Tue, 22 Apr 2025 00:25:17 +0000
Message-ID: <b64d61cc81611addb88ca410c9374e10fe5c293a.1745279916.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1745279916.git.ashish.kalra@amd.com>
References: <cover.1745279916.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06D:EE_|CY5PR12MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: b3f1376c-1e44-4afe-d292-08dd813430cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N0bP+22qWoxaLDCYiEr+I2tukj3AufkrEPKeOWycsgChIUDkwNRE2Tk8mebs?=
 =?us-ascii?Q?6/ioxxpT+C4QPSoJZNexIMwdMak6nnmbQ/PCD5ofe5buVfI2hqLBTRHKDqni?=
 =?us-ascii?Q?xXFf+nbcmG6nITkXUj+a62oWNhAExZj1lyaJ8YW8C4QjHAYqYZVbsdeVfd1R?=
 =?us-ascii?Q?RQcxUNAKi6E5A4b4GvPSJiya4/nmkYWvhZ44j5kx40psf/RRxWyIW8F0JG7R?=
 =?us-ascii?Q?SsexbbdNGqFUw9xxtoLDFSzl1TheX91tnFxULHZUHW7Ysl+Ti8RMWS/qHMmW?=
 =?us-ascii?Q?byrYUPp9qRIyFClBjDNkS1R7xUAXTh+83vb4n6DoUf7ahwn55xbu694zy34S?=
 =?us-ascii?Q?+mtxNd9ba/pphzAqFIPvDG8dOjfheD0FYVofNwy+dA7Nk727mGAJSt24mSJm?=
 =?us-ascii?Q?PiE/WNcAWAWnceMP0hTfeNOou8yI5zzfQWMa5cXm3bUAE0WS/8kuA+FWh+U1?=
 =?us-ascii?Q?tOdxJ6NZblmkYWXW8ZMBnK+bwfjw0b8BCm83zZAi603OMyP/lN0kACK64qPM?=
 =?us-ascii?Q?X5vNlIu9IILt1JkC0VhuZLg9w2jrffz0H/VFsByLq7hQVvgjmqoBrn0qhjGj?=
 =?us-ascii?Q?DkLgAu6TwpECd+1cSdOrkrfxwcZqrZXrauNPVjqoj7CtXfJ0ywyYzk2hj4MJ?=
 =?us-ascii?Q?jqeQ7/1aPrLItPCrmHYssumPGaBxBdFkbheS8HNURcIgXK8D4ZR2YuQNlO7S?=
 =?us-ascii?Q?m1yvKT+mHQFscFa48SLC93tPqJoVdx/phuBxoWxGAynJg5WRrz9b+Wu1XMkS?=
 =?us-ascii?Q?SYzJE07K9E94Sn24YPneXeVBqmL5GyhKilZJFv3C9JDNrR7DD6rOwRyo1PE4?=
 =?us-ascii?Q?Y1kcrLlHNSQGNprXIsm/zIy74ALdbNaSnUoCMPYJqjoURvamgwdK3/aLPfH+?=
 =?us-ascii?Q?rHu2IecGuMbJlkQnVRifsi6jm6YGU8gdruwgqtnerujC2aJ1OiAdvdi5AoGL?=
 =?us-ascii?Q?Tgl/zNr9zXKHzL7HVbpQRWNpZ0ePUkJXIyWS4y/lcusofKbjtounC+XW8Fpf?=
 =?us-ascii?Q?gIdjvkaQxoJ1U7OdBUTAmh3lQVa1fInbzkm9WmC3L9Pgh5g7V05Z4Q6/EjVx?=
 =?us-ascii?Q?778zrwFceZk6PsA/ys4YybCQcaFkGvHslTJPOWx0o1FZ+7tZl32e5eKsrEAh?=
 =?us-ascii?Q?9lPDbrcqtngiNB5qIv3BBQtDd5iWGw9qhayh/eqmUvADS837AQKKfOO/bj4u?=
 =?us-ascii?Q?sko9e5K4+bmL5hN2riSPTXUm0id4n07ydAR3gwdMw3tR3yIiTk4v8gylB0H+?=
 =?us-ascii?Q?d8aJvRTD6LT9U5NlEWHwnojbBJFfobRggDegUeLZOI3Gkj7QkmFEZd64jkNy?=
 =?us-ascii?Q?M3lj+NA9nROadhAvGHgd7xc838QmQhHygc6/2YO6xYufgoO4TOcaOmP2B7ku?=
 =?us-ascii?Q?PFK4xkJ9LzuWMBjBX+STJJ2eYuoMyVlySSJNFzx6e/w8SNmdz2ZCYlSx8ShF?=
 =?us-ascii?Q?+Zu5tTE3sxw8/63zKgbQ/mwACI/2xcFU+QEOulpVn/9srLVpDD/dxVdCRIx5?=
 =?us-ascii?Q?t3tDcZeP/jBcQTzOrzsPEJKUiVie1UIgzNaJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 00:25:31.3258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f1376c-1e44-4afe-d292-08dd813430cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6455

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext of
SNP guest private memory. Instead of reading ciphertext, the host reads
will see constant default values (0xff).

Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
ASIDs. All SNP active guests must have an ASID less than or equal to
MAX_SNP_ASID provided to the SNP_INIT_EX command. All SEV-legacy guests
(SEV and SEV-ES) must be greater than MAX_SNP_ASID.

This patch-set adds two new module parameters to the KVM module, first
to enable CipherTextHiding support and a user configurable MAX_SNP_ASID
to define the system-wide maximum SNP ASID value. If this value is not set,
then the ASID space is equally divided between SEV-SNP and SEV-ES guests.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 50 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7a156ba07d1f..a905f755312a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -58,6 +58,14 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+static bool cipher_text_hiding;
+module_param(cipher_text_hiding, bool, 0444);
+MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable Cipher Text Hiding");
+
+static int max_snp_asid;
+module_param(max_snp_asid, int, 0444);
+MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -85,6 +93,8 @@ static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long sev_me_mask;
+static unsigned int snp_max_snp_asid;
+static bool snp_cipher_text_hiding;
 static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
@@ -171,7 +181,7 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 	misc_cg_uncharge(type, sev->misc_cg, 1);
 }
 
-static int sev_asid_new(struct kvm_sev_info *sev)
+static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 {
 	/*
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
@@ -199,6 +209,18 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 	mutex_lock(&sev_bitmap_lock);
 
+	/*
+	 * When CipherTextHiding is enabled, all SNP guests must have an
+	 * ASID less than or equal to MAX_SNP_ASID provided on the
+	 * SNP_INIT_EX command and all the SEV-ES guests must have
+	 * an ASID greater than MAX_SNP_ASID.
+	 */
+	if (snp_cipher_text_hiding && sev->es_active) {
+		if (vm_type == KVM_X86_SNP_VM)
+			max_asid = snp_max_snp_asid;
+		else
+			min_asid = snp_max_snp_asid + 1;
+	}
 again:
 	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
 	if (asid > max_asid) {
@@ -438,7 +460,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-	ret = sev_asid_new(sev);
+	ret = sev_asid_new(sev, vm_type);
 	if (ret)
 		goto e_no_asid;
 
@@ -3005,6 +3027,18 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled)
 		goto out;
 
+	if (cipher_text_hiding && is_sev_snp_ciphertext_hiding_supported()) {
+		/* Do sanity checks on user-defined MAX_SNP_ASID */
+		if (max_snp_asid >= edx) {
+			pr_info("max_snp_asid module parameter is not valid, limiting to %d\n",
+				 edx - 1);
+			max_snp_asid = edx - 1;
+		}
+		snp_max_snp_asid = max_snp_asid ? : (edx - 1) / 2;
+		snp_cipher_text_hiding = true;
+		pr_info("SEV-SNP CipherTextHiding feature support enabled\n");
+	}
+
 	/*
 	 * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
 	 * instruction stream, i.e. can't emulate in response to a #NPF and
@@ -3040,14 +3074,18 @@ void __init sev_hardware_setup(void)
 								       "unusable" :
 								       "disabled",
 			min_sev_asid, max_sev_asid);
-	if (boot_cpu_has(X86_FEATURE_SEV_ES))
+	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
+		if (snp_max_snp_asid >= (min_sev_asid - 1))
+			sev_es_supported = false;
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_es_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1 : 1 :
+							      0, min_sev_asid - 1);
+	}
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_snp_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_asid > 1 ? 1 : 0, snp_max_snp_asid ? : min_sev_asid - 1);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
@@ -3068,6 +3106,8 @@ void __init sev_hardware_setup(void)
 	 * Do both SNP and SEV initialization at KVM module load.
 	 */
 	init_args.probe = true;
+	init_args.cipher_text_hiding_en = snp_cipher_text_hiding;
+	init_args.snp_max_snp_asid = snp_max_snp_asid;
 	sev_platform_init(&init_args);
 }
 
-- 
2.34.1


