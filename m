Return-Path: <kvm+bounces-52372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0767B04AEE
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B68584A5F31
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E83227A93A;
	Mon, 14 Jul 2025 22:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yKZ/t+H5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2082.outbound.protection.outlook.com [40.107.95.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D834523AB88;
	Mon, 14 Jul 2025 22:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532886; cv=fail; b=RqdMkvR/Cz2Wxe7jMUHcUnskbpZs4wOYBUTRZUb803c5Wkft4CILVi4V9tfHy8TuiWBv7yNDsBix6CTl+olawziGpSHZ5HNhriqSA/pb8oDuc/72tgO0AENu6ytAjHAbmcbo7NnAfVyxWUS9akOqmJRytt1bLepxSVv8hL9IkhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532886; c=relaxed/simple;
	bh=NyAYI3qjl0np09laPyxW1YlwippYa2OOYUeEBkClB0Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tuWNRXV4wEmduJHOgdmAO1AIAv6ocrkcALcFj51OTS8XcpynQb0JxLlq5u98sNvO+t/JwfdHbu0SEcxeDmmbf/0efUQjsTMxjzbp019e3KTXWSOX7B1higB83ZcmoqvJDjOPWbScmHRxELGCa/GdGbHKwarEiJuOT39N2lUOE8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yKZ/t+H5; arc=fail smtp.client-ip=40.107.95.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V+K8kQYA2fuwhrUOKgbuJo9zYoTNS9/bePElQDo9plURJZJsTbWce4muYW+bKe1vZbi6bEonWibbAz4XVumDmdP2Uilzsn3oSY1hIjHuS5D7xOoFNTVFgVYV/mVov5MwrsnRbNZug52A58FQDma0lZOkz7vOARfq9vM6Awso5jOhG6XbrNq1W1VdLio4L/BYSpBwnbdZVBr29gTd+xSh798DK/Mdrjw5f39js7T5i6tZbp2wmHIFTs+AUCQEdASpUeqvZdtAClfyFjB4ZqiEOSQa2ECqrrRpZ2665bwtOC0YczCxurLBjLtbY4UrkhDZoXOKIJkUR50tB2JFeqUSxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUQl+Oru6hsFYf5JeVi++pjrywDP0IuX7BWDiSoedAU=;
 b=Tvf8EcSSE3pwNLazKBYS6X3BUz9YqWOkINAEYdbTglK8A2UlLM6Cm480g9Xe9bHZZWnyjh+Eca/QmtQvBQena9AEMF4SEulu0Q4rTbNHKbkuwFjpkMGNsZhb9dlQo246LpMkhcMqDOO5BN3/M+sfBN3fVHisB4aq04AsupdCe1TOjGjFhhsbFqeqQC1YVLvHXO3LpfXZjuf1g0jLR8YcJJ+Dqv5LZfnB/6++T5yhin2Lcb7iwHQA6ccpRG8b51YBAiCPjyGA/PPiwMKK9OwAgVkf7HwJhsxf16GTA+NDXwGW0oSZxuL3TGST+ibo1Mjd7nO3RQT2RS9et2bMrX26Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUQl+Oru6hsFYf5JeVi++pjrywDP0IuX7BWDiSoedAU=;
 b=yKZ/t+H5SrngAfzm3EerKxt+sOTWItvZflpyuoFCNkkcDIRdmSkHeg/wN3lhFY8nNOt23gYM7U+g97WA5pDFn3dnHcFOf3m2ZZrz7D3MF42wHF8oTD3INR3evhb1EXhIbNiSTc8tMH5PnAlkCdMGrr4dgoQ3gJ+qQKWS+kkcixA=
Received: from SN7PR04CA0219.namprd04.prod.outlook.com (2603:10b6:806:127::14)
 by SA1PR12MB9516.namprd12.prod.outlook.com (2603:10b6:806:45b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Mon, 14 Jul
 2025 22:41:21 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:806:127:cafe::43) by SN7PR04CA0219.outlook.office365.com
 (2603:10b6:806:127::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.33 via Frontend Transport; Mon,
 14 Jul 2025 22:41:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Mon, 14 Jul 2025 22:41:20 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 14 Jul
 2025 17:41:18 -0500
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
Subject: [PATCH v6 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
Date: Mon, 14 Jul 2025 22:41:08 +0000
Message-ID: <1b60078dabee495d789fee68b01e8433b4791c69.1752531191.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752531191.git.ashish.kalra@amd.com>
References: <cover.1752531191.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|SA1PR12MB9516:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dc4baec-db23-44d6-794c-08ddc3278e05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vcV+PrDsvkMz0Tiem71sAfjNuUmnUDd3oV61Jk1z9IH0vM9H1Ebg58EKgjLA?=
 =?us-ascii?Q?Bm9/WKoTGVrw+K1hVdzL/VgXy5P68H5zdGIN5uhGMuxBG7Owsh0wHqV9La3b?=
 =?us-ascii?Q?Y4aj573lgt7YIrh8AFndsl+tQSVcghtZ5ipsmUVjm1jxPwwyBsqyl2YgHG5i?=
 =?us-ascii?Q?Qh7NRqYnknKiay4AIxNnDgaEZc7dvVEA79/4tYuUTn/KM1bbCYiEKx5+aQVQ?=
 =?us-ascii?Q?ib33kuAqSkSrZ5EA7C5rxBby1AQRLKBvMRRXHYypnB1sHNs/TuAH20KuhrBP?=
 =?us-ascii?Q?+GJ7n1wxUbmybKomiPhQRpE8Dx6R0+x0SKG16TkZzLx7wBZhVVTTKuFrtv/+?=
 =?us-ascii?Q?mDhMMc466iGrKDgNV1WctCupi2YTJI5DXN5guD9b7A5VRU9J0YQLvHm73GZK?=
 =?us-ascii?Q?Arqk59wcO0fvPaJ9xRkJlEJlQUPxjEqqlaHIV+xy1DYvXY8YPbSw6KAaCztH?=
 =?us-ascii?Q?uRWoQQIRGeK8k3CQSkSsNJO9mxWOztDesbkhCsJdKEYQPJoQKsnZf7lsIBvq?=
 =?us-ascii?Q?Etx/niqh5ubdI51N/InSmFGIHE9VG9OfDE9h68En7Lv9IjL6LxMvAdzbQHp+?=
 =?us-ascii?Q?to0U3Ag3JTT0T/zsN1pb9THXCRQ9YKWQXXjjsN7AHjUBD0J0C6c4oS/hyVol?=
 =?us-ascii?Q?BPQbWKYw6VT5E7nplP2ZXKyJHmTFk5WfnL8W6xz788pC5GYwR43l8LQ2r+fM?=
 =?us-ascii?Q?pDHJXFZqcq0+VA+R7ak6z7bnOjfAab4J5gK4SXS7nmjBkWlFdIJMTjwk1neh?=
 =?us-ascii?Q?FADIlro8kOc4ZCW/gcFy5eL6MI7CWvOmpcuaXVOriQ7/63R5PmyDfQpgsFvc?=
 =?us-ascii?Q?fGefVZhyz8oA3e0pkMGAcODAy6onfcx5vqM/EYpqMbnWhcbjsyNOvuM6j/LB?=
 =?us-ascii?Q?sISZkSQloXCXzJTuBp04Y6ccfdqqfRZ7lP/qWk17uH/ksvIHl1uR7pQFp99q?=
 =?us-ascii?Q?ADChej5GXcg1W8V6aJL/C6If4+osCE5S5p2GOezPIet6DZMPmt7gPPths0Os?=
 =?us-ascii?Q?KnelPbhklO4Zi9jgSnfdc1snIHy+8+3u6VBTmLmi1Kr6lPDJ+gD9VYgis3tp?=
 =?us-ascii?Q?+rfRE1Uxl4JngSjNQBc8MStQn9njwKEGFt2VxFWZ8J4psVVmQSOA6yJDJ8Wu?=
 =?us-ascii?Q?0tyJvmIsDQoBkKqq9PJfV+nY91GqYikDe6LQ5cSM5Hc+2gTpOI9fXgeHpjDj?=
 =?us-ascii?Q?YG7ZItZQa+a6mywhKcAKSjoAh/Dpcx3XJqgLJC3Wy5NIaqoCyJXTD84mE/fn?=
 =?us-ascii?Q?ugJks8TnW8K0DG6SmhVrxVR3hpKYti7SyIbvb/GAb3j7HFlRMe6m4egg/6ae?=
 =?us-ascii?Q?DnXOWB+7qv4vQjddEgjjI/IGDYjuislxqm+C4rqf9vCljG8v+NFaxHdu8cUH?=
 =?us-ascii?Q?kcT0f1rBvnxoiRsqdBQhEz43teM76QMaAb0Ou/lZxl+K/4pE7bGV89Af5keN?=
 =?us-ascii?Q?Kf9c0d2+DoVhgXk+ZZdcbB6OVLDgD8j11bfjLYkr0nOP87oGGqGjn/0BO3xC?=
 =?us-ascii?Q?Ge9VOxhyWA8SbqOJwDxOwrA7d+l9GLDV5EKjYlSm/wk/c0Il6bhpVUtjNA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 22:41:20.9674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc4baec-db23-44d6-794c-08ddc3278e05
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9516

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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../admin-guide/kernel-parameters.txt         | 18 ++++++
 arch/x86/kvm/svm/sev.c                        | 61 ++++++++++++++++++-
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6305257de698..de086bfd7e27 100644
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
index 77f7c103134e..b795ec988025 100644
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
@@ -2258,6 +2266,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 				ret = -EFAULT;
 				goto err;
 			}
+
 			kunmap_local(vaddr);
 		}
 
@@ -2938,10 +2947,48 @@ static bool is_sev_snp_initialized(void)
 	return initialized;
 }
 
+static bool check_and_enable_sev_snp_ciphertext_hiding(void)
+{
+	unsigned int ciphertext_hiding_asid_nr = 0;
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
 	struct sev_platform_init_args init_args = {0};
+	bool snp_ciphertext_hiding_enabled = false;
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3039,6 +3086,14 @@ void __init sev_hardware_setup(void)
 	min_sev_es_asid = min_snp_asid = 1;
 	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
 
+	/*
+	 * The ciphertext hiding feature partitions the joint SEV-ES/SEV-SNP
+	 * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
+	 * the SEV-SNP ASID starting at 1.
+	 */
+	if (ciphertext_hiding_asids[0])
+		snp_ciphertext_hiding_enabled = check_and_enable_sev_snp_ciphertext_hiding();
+
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
@@ -3047,6 +3102,8 @@ void __init sev_hardware_setup(void)
 out:
 	if (sev_enabled) {
 		init_args.probe = true;
+		if (snp_ciphertext_hiding_enabled)
+			init_args.max_snp_asid = max_snp_asid;
 		if (sev_platform_init(&init_args))
 			sev_supported = sev_es_supported = sev_snp_supported = false;
 		else if (sev_snp_supported)
@@ -3061,7 +3118,9 @@ void __init sev_hardware_setup(void)
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


