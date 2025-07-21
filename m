Return-Path: <kvm+bounces-52991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5447AB0C60B
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C133544092
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59A42DD60E;
	Mon, 21 Jul 2025 14:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GHfnDonw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351C62DA756;
	Mon, 21 Jul 2025 14:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107291; cv=fail; b=YMxgus/3KXRtYQZzDFXaY1R7G1tBitAQ+X1v7D6Tx3U+WAJ4g9+XpRj22+BWmMQepK0UnvF/BK+CX51GxA7w+o6uY103EqOMSNBRPD9QVPjUfWfLTM+tpRIGaGiAPcU/7gN+EZy9nc8neEPGnpZeh/S3iT/HbRQndY8ujkMsTPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107291; c=relaxed/simple;
	bh=QnqatDwS6C1TlUaiLjpLpxoRyDSjrOoyEljr42P1nCU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDzgiTnYHZnTPSH6pZcOfHOn2AaRBqbXCsy3BAxhV6pIhExwjejb1tfPCVVmJpZYXUDWa8Kz1Mo/pnuZTE8cQKoiPybdirt5WWcvnYgDS0eWC5bz5vpCxbcKFmkNC8rzBg8SYHav9bceJcQClTvrLqMAzG3P81pbVhcz3dlt/QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GHfnDonw; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4OuMREGbTnmKqBXFqLwiVYeZBn12+a4cb5VxHL42wLBi0gXeqNRpG4q2wrO5ARcNigSYO2AdkoQ9KTXa7EYdWngK9CbI7CKGat3Yh5ITq1L92v0cvDI0jKD5IIPCDRD4VSnSoRBPZze1hlO0RWKOJvDe5nbcgHJ7Z1bWd+Mtrkah18GRNhq66ARlWOaTp5ohsy8AKLmaJBCTMNI35aTVgw0qbHuwgwlZ8magFxJNj/1tisW5d7At8z4YAzm7ehcp1WlCWNE9RdxYs9CLCJFS8NRXgbFemCnlFrrz42N8cYyK1WVn/vGPRcuUVpKGzQiCn5BaQ0pAg88wd6fi37OqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZ1rDRUfkYnTzBDta/PF7CJ/rp4tiA2xA3l5HM5c84g=;
 b=m1We/oJ1/ZIY0AE8lhocbxisp1O3/TQ056Lhwi8WdwTHcM6bK+kzm0FAQZusiGh8Dh8DNIR+5EtqBf7emcYUoHG0OwCPl2Zyl8oXUcLEmieWO0ZEX3FGg/3SoojKuM2IittRZnEvOCHOoqzqFXn1K0a/ZJDwGJ53Q4m99GXS74GNrMad6jPPjz/WL90Wq1kk7iw0Rw1v9p64BLtpxlQRAEz5x1GnDnfM5DfXRRGU4lCDtMCJMgCljKSnOW5EA79cOqwvMe92aUnKJURufJ/fBAM4klUgULHmLqn0wPP3kVFHgQCR/P8WxvHbR4bgE3RCD02Dk12lbc5XcXyckWfx1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZ1rDRUfkYnTzBDta/PF7CJ/rp4tiA2xA3l5HM5c84g=;
 b=GHfnDonwHGkRo5qVvYEyvcT/MguiHrAnIQQ+hpcTLt11LkAuavyM9Ivw0FFlV9rYes3Mrbqb/+xp3ySNaKdhx/8Rf+uUeniCQJtpuNSU1pRqSbkcxLIS5FsvdPaT2cUyCAeUCUmaBY/0VA6LC+GEjzLOtR+v7FtDYpeBOiQUnUE=
Received: from SN7PR04CA0218.namprd04.prod.outlook.com (2603:10b6:806:127::13)
 by BL3PR12MB6449.namprd12.prod.outlook.com (2603:10b6:208:3b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Mon, 21 Jul
 2025 14:14:47 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:127:cafe::24) by SN7PR04CA0218.outlook.office365.com
 (2603:10b6:806:127::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.23 via Frontend Transport; Mon,
 21 Jul 2025 14:14:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Mon, 21 Jul 2025 14:14:47 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 09:14:45 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
Date: Mon, 21 Jul 2025 14:14:34 +0000
Message-ID: <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752869333.git.ashish.kalra@amd.com>
References: <cover.1752869333.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|BL3PR12MB6449:EE_
X-MS-Office365-Filtering-Correlation-Id: a569ea05-6df9-4635-22ed-08ddc860f2e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jNnHcCXc7UrzrYDszK5BtglkYi1irknFj9CMvpzzl0Bg8M5SiY7lWkpmRanF?=
 =?us-ascii?Q?qamJ7jvWFGyuWFFNjdQGN0I89rGAj+aLhGryZlWQWh0B/RedcsL4KGbnBC2H?=
 =?us-ascii?Q?+ZW52uxU7FHgWh1y9TTE5AxzQqBaLd6bMV+RhGjw2quClMvfQq4LI0nz8He7?=
 =?us-ascii?Q?EN8kH/V6ucJ/EmbUNoOVB/Vvr5slRPyOpiAzLm7UWKZ6HoxyzzMJvDtSFcdX?=
 =?us-ascii?Q?7qm/oXVn3mQ8/cP4GliORZF9snypcguf6s6IsVVLyu3y1ODXSCK3L5A8amvz?=
 =?us-ascii?Q?RPBuLmhHLz6NGXhALiiyWG3M/RIzo2iYDDNgwnUyRRecgwMdS5mbif/xfjYE?=
 =?us-ascii?Q?wSTZyLyAZ6lcBvFmEeu612kDFbK6Bq1H2kwk1Y1wt/n0k96aWbXrHBm1AS2U?=
 =?us-ascii?Q?E9HlFXtcZLvmJNDjTyQyf38JznKAYPGITLMPFhYmkU+7YdEd0vxpkPKywYiu?=
 =?us-ascii?Q?WBA3+YPTs3o7PRjXvwh9lLmNG34RtInkpMEvcLovFzapLXNhVeLKct0KW/qF?=
 =?us-ascii?Q?adoRWfNRr1uLMwNJ8PGQYVBqOrFjy/4vKOp8DhM4pn/q3lFIWtiElnC7bENr?=
 =?us-ascii?Q?oT2YnUYwDzoHs81IUnNWHt1uvpJSwFUa/UndakXNtotvZYiYT46GDS2/hinf?=
 =?us-ascii?Q?ZGpDzrn8dY1HXwbgE1kXBzbe8Hrgu8KudPtJgYGPwrsJlSSS2CJ/eKdDyU0L?=
 =?us-ascii?Q?+b+YDqOITb7EyM580c3sgAucUd6kjCUn5vSAPUN8atPtD2zeO+zsHaeGLuLC?=
 =?us-ascii?Q?k8Un0BwpbRgVMyhjUntcIedYg8UcsvRnkS79cwNjjTvqvTe5KEJB7JqUpBAK?=
 =?us-ascii?Q?eyhUULPZPIctf38fawiu8BlTxCoJAe1szLe9bzcJjxqdCktNj+XtXmdhC3tz?=
 =?us-ascii?Q?bGnxazFiBaFdtD9iscMhgPt6Gh3v2+EgEtnK0KRBSAePWy+9KGZ3QimMORzC?=
 =?us-ascii?Q?rdStjoQvpdvKNjMrytJ254uLmZxZf+Uxu++5CFHGdB9aCuGFL/RbVqRJ+GZV?=
 =?us-ascii?Q?Q8UZJSVCJVS+YF/FKfSllgdmXix3+0wUi7qFgn/G7fNxIda808ifLFFLO8DC?=
 =?us-ascii?Q?iIu0+Ur+1UBjY1BKt9BJaCQEHwjKZ3l7ik+5zz+Pgd4WNXA2qgtzm4DgqOFr?=
 =?us-ascii?Q?H5U8G2MuAoEI7L2/EXcQAKjjo9OU+96bfoAPi0aWNLN4SFtVSiqQS1AdbGvl?=
 =?us-ascii?Q?Y0dxccq1Zn17oBBYfmxUM2I45bP0dnQpa/4cCdhy/QJBupjD6BRU1rAKBUJZ?=
 =?us-ascii?Q?FaLlMhi9JkCyn/rXnwjJ5Rhdrr4IqklW8597sUF9jrKE19N/u4POuo9iSNTw?=
 =?us-ascii?Q?9hObSWfsTEkI7G0JCnn1UohcXCnraq+u/efqahe+CqPjnAQHpshKSS14l2r2?=
 =?us-ascii?Q?KeMaJpLz6H9Q74VYgaYWHAwW6ptWg/dkz1Y3LhV+/MRmaMBXXqQLdauWZvfR?=
 =?us-ascii?Q?V6ILKTdGY47LDb6KDjIlqyzSbP/U43vw3a2zxT6fzHkVgsppy+QxGS6FlDoG?=
 =?us-ascii?Q?AGlLVllP2efmx7ECxQQtWQ9blYNF1JOS6DbN4Pm3gWjkxMizJ6uzG8CdSw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:14:47.3228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a569ea05-6df9-4635-22ed-08ddc860f2e3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6449

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext of
SNP guest private memory. Instead of reading ciphertext, the host reads
will see constant default values (0xff).

The SEV ASID space is split into SEV and SEV-ES/SEV-SNP ASID ranges.
Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
into separate ASID ranges for SEV-ES and SEV-SNP guests.

Add new module parameter to the KVM module to enable ciphertext hiding
support and a user configurable system-wide maximum SNP ASID value. If
the module parameter value is "max" then the complete SEV-ES/SEV-SNP
ASID space is allocated to SEV-SNP guests.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../admin-guide/kernel-parameters.txt         | 18 ++++++
 arch/x86/kvm/svm/sev.c                        | 60 ++++++++++++++++++-
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index eb2fab9bd0dc..379350d7ae19 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2942,6 +2942,24 @@
 			(enabled). Disable by KVM if hardware lacks support
 			for NPT.
 
+	kvm-amd.ciphertext_hiding_asids=
+			[KVM,AMD] Ciphertext hiding prevents host accesses from reading
+			the ciphertext of SNP guest private memory. Instead of reading
+			ciphertext, the host will see constant default values (0xff).
+			The SEV ASID space is split into SEV and joint SEV-ES and SEV-SNP
+			ASID space. Ciphertext hiding further partitions the joint
+			SEV-ES/SEV-SNP ASID space into separate SEV-ES and SEV-SNP ASID
+			ranges with the SEV-SNP ASID range starting at 1. For SEV-ES/
+			SEV-SNP guests the maximum ASID available is MIN_SEV_ASID - 1
+			where MIN_SEV_ASID value is discovered by CPUID Fn8000_001F[EDX].
+
+			Format: { <unsigned int> | "max" }
+			A non-zero value enables SEV-SNP ciphertext hiding feature and sets
+			the ASID range available for SEV-SNP guests.
+			A Value of "max" assigns all ASIDs available in the joint SEV-ES
+			and SEV-SNP ASID range to SNP guests, effectively disabling
+			SEV-ES.
+
 	kvm-arm.mode=
 			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
 			operation.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b5f4e69ff579..7ac0f0f25e68 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,6 +59,11 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+static char ciphertext_hiding_asids[16];
+module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
+		    sizeof(ciphertext_hiding_asids), 0444);
+MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for SEV-SNP guests and specify the number of ASIDs to use ('max' to utilize all available SEV-SNP ASIDs");
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -201,6 +206,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 	/*
 	 * The min ASID can end up larger than the max if basic SEV support is
 	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 * Similarly for SEV-ES guests the min ASID can end up larger than the
+	 * max when ciphertext hiding is enabled, effectively disabling SEV-ES
+	 * support.
 	 */
 	if (min_asid > max_asid)
 		return -ENOTTY;
@@ -2269,6 +2277,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 				ret = -EFAULT;
 				goto err;
 			}
+
 			kunmap_local(vaddr);
 		}
 
@@ -2959,6 +2968,46 @@ static bool is_sev_snp_initialized(void)
 	return initialized;
 }
 
+static bool check_and_enable_sev_snp_ciphertext_hiding(void)
+{
+	unsigned int ciphertext_hiding_asid_nr = 0;
+
+	if (!ciphertext_hiding_asids[0])
+		return false;
+
+	if (!sev_is_snp_ciphertext_hiding_supported()) {
+		pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported\n");
+		return false;
+	}
+
+	if (isdigit(ciphertext_hiding_asids[0])) {
+		if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr))
+			goto invalid_parameter;
+
+		/* Do sanity check on user-defined ciphertext_hiding_asids */
+		if (ciphertext_hiding_asid_nr >= min_sev_asid) {
+			pr_warn("Module parameter ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
+				ciphertext_hiding_asid_nr, min_sev_asid);
+			return false;
+		}
+	} else if (!strcmp(ciphertext_hiding_asids, "max")) {
+		ciphertext_hiding_asid_nr = min_sev_asid - 1;
+	}
+
+	if (ciphertext_hiding_asid_nr) {
+		max_snp_asid = ciphertext_hiding_asid_nr;
+		min_sev_es_asid = max_snp_asid + 1;
+		pr_info("SEV-SNP ciphertext hiding enabled\n");
+
+		return true;
+	}
+
+invalid_parameter:
+	pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
+		ciphertext_hiding_asids);
+	return false;
+}
+
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
@@ -3068,6 +3117,13 @@ void __init sev_hardware_setup(void)
 out:
 	if (sev_enabled) {
 		init_args.probe = true;
+		/*
+		 * The ciphertext hiding feature partitions the joint SEV-ES/SEV-SNP
+		 * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
+		 * the SEV-SNP ASID starting at 1.
+		 */
+		if (check_and_enable_sev_snp_ciphertext_hiding())
+			init_args.max_snp_asid = max_snp_asid;
 		if (sev_platform_init(&init_args))
 			sev_supported = sev_es_supported = sev_snp_supported = false;
 		else if (sev_snp_supported)
@@ -3082,7 +3138,9 @@ void __init sev_hardware_setup(void)
 			min_sev_asid, max_sev_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
-			str_enabled_disabled(sev_es_supported),
+			sev_es_supported ? min_sev_es_asid <= max_sev_es_asid ? "enabled" :
+										"unusable" :
+										"disabled",
 			min_sev_es_asid, max_sev_es_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
-- 
2.34.1


