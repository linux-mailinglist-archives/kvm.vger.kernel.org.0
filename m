Return-Path: <kvm+bounces-21836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CF32934D73
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51914281B0C
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5990A13C801;
	Thu, 18 Jul 2024 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hO7GtbU7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAF513AA26
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307054; cv=fail; b=gftPuuwH5A56KgBMwU5MTEJVKrEcCRRCJUc8AWeRz//YUqBFpaDWJq1jFCTngI7Xu9xqUlI2uOPYmtnSQ6O000GnDdlcOw/2MJV73Bwebr9I7I0FQt0ucaJRI7z3dWuD2dsUa4o1I9loPZTX/ksG1AH972wLwJ2lIH3bWma/uOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307054; c=relaxed/simple;
	bh=NcflvymHHmEvw1W6OFsOMrKbJKD1bDoNY8+5+0y+heo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uBJeDzd6CDelbKk1/iuUxU69vd6LROC2soD0rzwPRkTwcm+xq0LeyskzNCa40t+hY9vBwVy9PCBclpm4A/SoWea1aYpR9BPOMQQpT3HoWXusWcNNuutBA81BsOw+RmtApYdiwLSEksZj1kRXdaM7kI6ASSwoU1zTaD+bHUs9t3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hO7GtbU7; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p7fQzQjFpjdtf+9UmSFWnBJjGIxLGO/K/X01Hm8KjtAUFRKgPMmvY9qaKWzYqNNsL8x3yPsJhLcVa7guLrRxIIsK1kW80k3b+gv4befAOg3sKrzz0b7XpNLsCXgIQNlsfBR/ln7ifULUrF+K20rvsr1USJjWenLgRI7t92nDgCVKJBKxmc6NCpabbAHRqoEHO/Kz2fNPAXKbbOp67i+K7KdwfP40rsXlw07XCv6Znv3iGXLdbQ1GeU98yornkMqefvpG/jnTF59kGP5XFrC2IV5wvGbxzQSjpE5tuBOaghiiQM8KM/4AM5kJziblsxXbzwW+aX/51g3Wte9wCM6nJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTHPOP/zUmRcNFGqvTXKJGku/hgbNLGR50NxRVMppWc=;
 b=twpt3U9YG7PJlF/Fwc3aFVxqCmuRD/DiC+a2MES1UsY+iYVj2D1lSQyD9Eeh/6sVvLiaQNFoiRNCKmx2Wl4RCMMlp8zSk2VdWGXE1Y4BgbbB/l8stLAvT6xcnIXN3EPDDvw+PuL96bRzMCHbdsCh/EDg84Z+6ypV/1eXlVw27HzUj4sAr9nxnpxxijWPpjD3lB40qHEk3Q1tZhVD9ogIL0CkSCOxVySXyX+xQYh62r9hZX+NZwcC0Uj404rdqT4PkxJfLwsxTW/PlewW+O9l5u7sPOeWuvsoyk0+5VMybCvszdPAk8aV7MrPKrRyIHqbN5VW/9LQOh34WQ4FK0wEzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTHPOP/zUmRcNFGqvTXKJGku/hgbNLGR50NxRVMppWc=;
 b=hO7GtbU73oliLGDC4v8KbgnXfMp3E5sRA2y/DWIgFkDoRc0M6BfJK2vsTVtXTcrAvgyUQZ8nevcgtEDuxCrjeOnSyCtUG/cC5e/0rtK8HMP1sz+4gR7MiyfgcTJfH93IZq3Mlvd7gF57ZqZrq/qDwmvB4ZzwG1qL+kE1a4YhPRo=
Received: from DM6PR21CA0017.namprd21.prod.outlook.com (2603:10b6:5:174::27)
 by CH3PR12MB9282.namprd12.prod.outlook.com (2603:10b6:610:1cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Thu, 18 Jul
 2024 12:50:50 +0000
Received: from CH3PEPF00000017.namprd21.prod.outlook.com
 (2603:10b6:5:174:cafe::8d) by DM6PR21CA0017.outlook.office365.com
 (2603:10b6:5:174::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.18 via Frontend
 Transport; Thu, 18 Jul 2024 12:50:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000017.mail.protection.outlook.com (10.167.244.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:50:49 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:50:49 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 05/16] x86 AMD SEV-SNP: Enable SEV-SNP support
Date: Thu, 18 Jul 2024 07:49:21 -0500
Message-ID: <20240718124932.114121-6-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000017:EE_|CH3PR12MB9282:EE_
X-MS-Office365-Filtering-Correlation-Id: 2065fb3e-1a63-402a-79ca-08dca7284061
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zh5SIKN7loBKsGy/trPBCVdMgCF2AoxMS0LpF5Ihkbo7QmrtmZ0rNkPAyJoM?=
 =?us-ascii?Q?L6/R168lWho3eOrHRsFdm8ZrbLLoEhDdMGrchnSqXmfLrY3J2e9ns6cxf2B8?=
 =?us-ascii?Q?906m2TWK20vpBNnZsTlKCX/4PCbDSe1hh1Iv0bXNSXDN6BBoJfkWj2OuoHHG?=
 =?us-ascii?Q?0wYFZWWO0XsG1YLbw+vYS8iEJFdNQf4Y3UgBDOZyy8IEz5CCggbQvKJBGbJe?=
 =?us-ascii?Q?cCNgDKrL0gSWO+SkV3aR5nDXY9jIMMyaWEreQ4B3ozs7CdmouPgLP+FCtMN0?=
 =?us-ascii?Q?8X22mxoZJaqCj1PyhJn+ZWL3MMWgJE5lhKU8TiITIepvoms3r3QFfCN10Vro?=
 =?us-ascii?Q?l7ryps96VH8D76DLwN24FePFT4GWQHUtmujKMDflGPwx0b8TTcGRnF8UTSV7?=
 =?us-ascii?Q?rM+1NdmRBEnCbyrZvu2Sdd/zAd1ugvmwb8Rs1of8LmBkIr3NmaNFFQem7jcB?=
 =?us-ascii?Q?SSoyPr6yZ6HIkyAVjqxoFovT/W1vvTXeShpGFGJNiLlFhBehHhDUCAjy78oZ?=
 =?us-ascii?Q?o3PiatUtBtUPxtPtVJJofPaSBZGbn7prgmpsqUbx7lN8AuBdZf5gVZ/3Xrcj?=
 =?us-ascii?Q?KGQWPYuJMT17yvTWfDPi6eStXug17/WE4bfhhJWiTAmOhw99uzwa9/QrfkHz?=
 =?us-ascii?Q?moiaUzMRVc9SKUi2eCazqcvK2xyBMgVU4O3q9hQHA/N8x4D5Ed3/siZHRdVu?=
 =?us-ascii?Q?zW6fe7IF/1HE1IUdKXW7VPVTl/CArYiWjLnOALlc6ZgGAZDql9fWepCa4xke?=
 =?us-ascii?Q?AdfygxZuQkM7F0tYuJEw4e90BWxGKa5HLWCbitFIiIJWGdOatdhj3OPlkZuH?=
 =?us-ascii?Q?RgBWVpdY+hbJFNDrHPNR2Hbcpy/Ac4mpsxxGHFAL04YhZCs554TJ2ZcrJUnk?=
 =?us-ascii?Q?6Odq2uN6rVRXMSaWoKyv6Ypv80hhojODa8f7hIVNeBnmJ86Mmo+uZ35/G+4d?=
 =?us-ascii?Q?rbgUfVnQju2PPAbDGzj876TkKyXHAUCFfZaySZ4X1Yx+T7iW/cxj5aCyn7Bu?=
 =?us-ascii?Q?YCcCT+ujjPaxzMu//Yr6YnywUS+m9Veoy20OTE3KvKxyHVGRTvqPtsoU6GLR?=
 =?us-ascii?Q?Hhp6Lt2yj3fOhUj1x3UZ1vDopf1fkLUHcwi9VBzyGGPIvVQZggi6gkA24a5q?=
 =?us-ascii?Q?Zd++eVxM9yeLtBjdYRpiKxco0F2lrPDOYk3+BMnNF+G/v678x8DEa8MEb+fn?=
 =?us-ascii?Q?c/riPvp3jy7ioPs9QO6drRAm36BW5yPudxp921OwvxQ14ZbP+Hs4ymi3WZiU?=
 =?us-ascii?Q?61bbpihWT0f3aN8Aq6ZgCKfYGk6vAQkmIc5KwQR2iWsSRAxH6V8O6J1jYT48?=
 =?us-ascii?Q?B1AdgmEea5+VXAMG++v75KGHHAZeiwVxJbDpa94t9ht8614djwXVUNCaIsra?=
 =?us-ascii?Q?rXmA7bgrgzcaogOvosEY4f7wWKqPdHw1q+5qx04tcFpLvh6O0otNqdyWKd3L?=
 =?us-ascii?Q?i1+V6y1mbJ947r/0o1rKmrHMG7zyVJN5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:50:49.9490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2065fb3e-1a63-402a-79ca-08dca7284061
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000017.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9282

Incorporate support for SEV-SNP enablement. Provide a simple activation
test to determine whether SEV-SNP is enabled or not.

SKIP this activation test if the guest is not an SEV-SNP guest.

Besides, for SEV-SNP, the requirement is that SEV-ES and SEV be enabled.
In addition, setup_vc_handler() is common to both SEV-ES and SEV-SNP.
Therefore, call setup_vc_handler() only when SEV-ES is enabled.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/amd_sev.c | 15 +++++++++++++++
 lib/x86/amd_sev.h |  2 ++
 lib/x86/setup.c   | 13 ++++++++++---
 x86/amd_sev.c     | 13 +++++++++++++
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index ff435c90eeea..f84230eba2a4 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -89,6 +89,21 @@ bool amd_sev_es_enabled(void)
 	return sev_es_enabled;
 }
 
+bool amd_sev_snp_enabled(void)
+{
+	static bool sev_snp_enabled;
+	static bool initialized;
+
+	if (!initialized) {
+		if (amd_sev_es_enabled())
+			sev_snp_enabled = rdmsr(MSR_SEV_STATUS) &
+					  SEV_SNP_ENABLED_MASK;
+		initialized = true;
+	}
+
+	return sev_snp_enabled;
+}
+
 efi_status_t setup_vc_handler(void)
 {
 	struct descriptor_table_ptr idtr;
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index b5715082284b..4c58e761c4af 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -122,6 +122,7 @@ struct es_em_ctxt {
 #define MSR_SEV_STATUS      0xc0010131
 #define SEV_ENABLED_MASK    0b1
 #define SEV_ES_ENABLED_MASK 0b10
+#define SEV_SNP_ENABLED_MASK 0b100
 
 bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
@@ -140,6 +141,7 @@ efi_status_t setup_amd_sev(void);
 
 bool amd_sev_es_enabled(void);
 efi_status_t setup_vc_handler(void);
+bool amd_sev_snp_enabled(void);
 void setup_ghcb_pte(pgd_t *page_table);
 void handle_sev_es_vc(struct ex_regs *regs);
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index d79a9f86eda4..561397af93d5 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -331,9 +331,16 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	phase = "AMD SEV";
 	status = setup_amd_sev();
 
-	/* Continue if AMD SEV is not supported, but skip SEV-ES setup */
-	if (status == EFI_SUCCESS) {
-		phase = "AMD SEV-ES";
+	/*
+	 * Continue if AMD SEV is not supported, but skip SEV-ES or
+	 * SEV-SNP setup.
+	 * setup_vc_handler() already checks whether SEV-ES is enabled
+	 * or not before it does anything. However, for an SEV-guest, a
+	 * function call to setup_vc_handler() can be avoided altogether
+	 * by incorporating amd_sev_es_enabled() check below.
+	 */
+	if (status == EFI_SUCCESS && amd_sev_es_enabled()) {
+		phase = amd_sev_snp_enabled() ? "AMD SEV-SNP" : "AMD SEV-ES";
 		status = setup_vc_handler();
 	}
 
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 7757d4f85b7a..3e6e9129cfaa 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -69,6 +69,18 @@ static void test_sev_es_activation(void)
 	}
 }
 
+static void test_sev_snp_activation(void)
+{
+	report_info("TEST: SEV-SNP Activation test");
+
+	if (!(rdmsr(MSR_SEV_STATUS) & SEV_SNP_ENABLED_MASK)) {
+		report_skip("SEV-SNP is not enabled");
+		return;
+	}
+
+	report_info("SEV-SNP is enabled");
+}
+
 static void test_stringio(void)
 {
 	int st1_len = sizeof(st1) - 1;
@@ -92,6 +104,7 @@ int main(void)
 	rtn = test_sev_activation();
 	report(rtn == EXIT_SUCCESS, "SEV activation test.");
 	test_sev_es_activation();
+	test_sev_snp_activation();
 	test_stringio();
 	return report_summary();
 }
-- 
2.34.1


