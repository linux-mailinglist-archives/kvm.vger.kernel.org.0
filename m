Return-Path: <kvm+bounces-21846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C971E934D7F
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 497651F22CCC
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E8D13C80B;
	Thu, 18 Jul 2024 12:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1W9dixFH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EE713AA26
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307175; cv=fail; b=EWx3pPgU2ave9a4VbU30vGp21KZUpcE5QX01TtIUwpUSXpC9TxRyCbB+V8yTbUaA+WgEKe6jD15ScUWE5j1QRu3XTu7rbtVtnPKyQ5T5spGdf+x2OO61ivNrSt/9Ir9sUjc0ph4Rgo/0Xk5JX0hB34PX1fhXbSHPP+rFAwHS6Og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307175; c=relaxed/simple;
	bh=T4r7OhigpxnrjzppqAIpnW2qHgAFM/fV5zLlgqzFSMU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b96yrbB/6xLAIi98wMXxUX/6IxIEH8TgANIW6AIJQMn1p3tZSjCKypjUujouddt4kbUh/wCDgsTLdvDETo3+lye2WIj9MzX30gH1amzgi+uwRdpaxAsqnTX3wztVxgdn09YIrKoUyyKrSFth9Z3UbtDYTnnL+m7dNkXgLuqH8fA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1W9dixFH; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=whfabjw5U+lFaMoS3KLmvKek/FD/kN3cN2hUog/3/yFOYJemjKDGvNtcROzd+v8JvJqZUfAVmwPXGjJo9b+LqNc+2wwWgV7Dk5eo51Jsy9/+mXLjvNlM0K7GzQf8BT+D5BFcE3HxO9bFlOuoweNFBm5jehIuwc5T797hkJvQdSBNdvHjrwhz1dmtcz49PHWvkl4OucpYgkZK3rmxFRdhjmDL0shbRYE+NvO28ONSMJ5+Rcf2Hh3NbLrsTa9CWuuc0XE8wvVto38pQhaqvAqmyz+PaMoJX/007Z/PW2cOLw+Zv2CgUnbSt47TU4E5lIgVKnyVRHDu05HQWEVgaaRMiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=505Ze1pkSBUgB5+CxDTxpRoXs3NqwoIKH9ol/L9wCss=;
 b=IgX0ahnV3alAY7e1+O64FivtadhDkzkzeD1WgrVziB6KdBm+5rhejoAywH5VW/JT1NTA+hwgsSf9LVeMWPBZkGf+tWIvj+cPvAeEYLx49zvz2cYhZpuy5PcMh9GBXZQLHy8SBhM+RdfK3eHLZFpkbY+zXlHM9OH0bd18/i4fv0C3ylR5eRo3TnsLTIY8EFTAK/Is/PQnNFrRgmZJPMmbQgcFvsMtbge0N8mYz/nT3Yw62lZfk4CHEBR7SR34wEG9ocRCNy0pDeSHr5/iGiDPbdG7p/sOIIHkFTXD+U8LA10DU3LpJ0HmpNnYCGxvsyBGxBYQXRSAvtRPyPTvj92KCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=505Ze1pkSBUgB5+CxDTxpRoXs3NqwoIKH9ol/L9wCss=;
 b=1W9dixFHpEidn80DZseDTI7zSeYsbnQv31IS4YLdDz4pO6vxPbdeeeTta1U4AEr9bxQgVLETyHv6LvIjUYPf2mQ4J4WkbsVV523AtfauYB7dVhlzvIwc7xKd09teudEJRK6cuAcmdFuOw0C4pTnQokAgn6LO42PCWvcZjFbBIXc=
Received: from DM6PR03CA0045.namprd03.prod.outlook.com (2603:10b6:5:100::22)
 by BL3PR12MB6620.namprd12.prod.outlook.com (2603:10b6:208:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Thu, 18 Jul
 2024 12:52:48 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:5:100:cafe::23) by DM6PR03CA0045.outlook.office365.com
 (2603:10b6:5:100::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.15 via Frontend
 Transport; Thu, 18 Jul 2024 12:52:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:52:48 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:52:47 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 15/16] x86 AMD SEV-SNP: Issue PSMASH/UNSMASH PSC requests on 2M ranges
Date: Thu, 18 Jul 2024 07:49:31 -0500
Message-ID: <20240718124932.114121-16-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|BL3PR12MB6620:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e640ae8-cf74-4ea1-5c52-08dca72886fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UiOl9aburEfPxVFy79TFNrRTFTVZX4yMEIDtGM/U9QE/F0O3A4iFAopaJHvQ?=
 =?us-ascii?Q?uCTq9jZzAwL23KvWm5lhJJ/USy4M2DjYwKVHnGatZPq9jIYJcMOXlnNPMNz2?=
 =?us-ascii?Q?joaIati4ErNmn6+ODwxWD32yrS2W+HAiqz1pa/I7qhGvRO/Esw4nX0VeZ48x?=
 =?us-ascii?Q?l0f8mj+y2SjbKwKP6MTNAnB8/UvsYr+bmqrF9UQwfgxz5nAqqdfwdxau8aQX?=
 =?us-ascii?Q?IOmrwUa+EwpVUhdrZw232WZWx11uPC9r6vB7+cqBeEAqyakn6fCHITXTJFx9?=
 =?us-ascii?Q?6ppwZmgiu6+MOZhH2y0ZDy5bMAHhLvqn+z6/Hw/ZK9hY8MJVA7XtHNbljljh?=
 =?us-ascii?Q?F07M6Pj5c2k3fPsEC/Eil++QPO0XagZVnwm/CB1xpJXM1SflKgRJ8qEQEIwW?=
 =?us-ascii?Q?NFdr4Me+PFhCWfg48RKksFtriF31jzpEiRyLfDKvbBUtARFdnK0DutLt6GIW?=
 =?us-ascii?Q?aHMVukR4YKTeeb0CHbqNBHXVGW4e4ZHhoh0n6IxlbvolLASA5I7Zs7KZmcf/?=
 =?us-ascii?Q?KL4/OFfSou2kC8VmfCPxUNGSKKqSnv/335t0XmabHD2zTKPtofYZWnHdik9t?=
 =?us-ascii?Q?Az/8+gkqmCJJ4eKxLDMhQLPQiYXsOb/LLJ4WVlqOem/1El7/B1J22csEWp9j?=
 =?us-ascii?Q?qp0ojzzcDtqaJl3ZGcjiE9ZaKEDaHiaTjFETLFZqF6ch0EKUp4ds7Qg6M+YE?=
 =?us-ascii?Q?JPZGvKuNnlnyAAo5nGnvu2sm1jN0Y14THUZDur5IthI06XNnpgcHEc9qicFm?=
 =?us-ascii?Q?O3MnmtWQVHOQ38H/88eIDFVgFHXaJM3EnXFgwcEX3Sz1ZnT4Plwhou34i/DY?=
 =?us-ascii?Q?EwpuITz13b8J/aotNlMkW90wDIv9fhgg4vFo0TQQaxGDRJB5BzhCDkUmzdDt?=
 =?us-ascii?Q?wSeqSHnx8X42tP0hW4D+8KlqGorg+7gvfh0MsSPsgi7a5X7FR1vga/pkxMVz?=
 =?us-ascii?Q?qiUCyk1uCgfZh6NPdqoALVjz/FxUlf+uN5y3uDEbkNYsoXR7EjjtZXDJrvl+?=
 =?us-ascii?Q?MstwXDIlLcF13l3hNAZRxSARPOHEfoydt4nVTleELGMaieeRfcp9u66z4g6C?=
 =?us-ascii?Q?3U5VPi94AdG0CvEAOz/bQzne2/9kuZCcaAzSs6yTIrnkYk2RypNXQz89iqIq?=
 =?us-ascii?Q?MROBRGexw8qkN8r1wastageDcmu2UiHqvPbAMKGcqsCYcgXYqZPR5ud0wjna?=
 =?us-ascii?Q?7zzaorlZz2T+JVwlTaGWNpRJzF68GmRtcwAgv130f9+kDoMqLZ6bSGgvqN9X?=
 =?us-ascii?Q?24IPOqYUOhRXKXB7/6j+FuzgHKe5dF8SF9kuZd9IkYhmpf04bPSaCdPMPls2?=
 =?us-ascii?Q?rXbGIrAWcyzOSnZOJDQWlptQrCB91qkxGWcr/sGYOpxrqDOn/+kLtmV4dLR8?=
 =?us-ascii?Q?aC01emH+V0+Bsv59gFUa7z4YnDdOOE7GqlQ+P3g5KfDlGnckhLwjN22Qr1lQ?=
 =?us-ascii?Q?etiLEQOMBzccKUCsJOD0p5AbnvyoJS/4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:52:48.4333
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e640ae8-cf74-4ea1-5c52-08dca72886fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6620

GHCB spec specifies that an SNP guest can submit PSMASH/UNSMASH hints
to hypervisor via PSC requests. Include a test to create such a PSC
request where KUT-SNP guest requests hypervisor to PSMASH/UNSMASH
2M ranges, to ensure hypervisor handles these requests without any
issues.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/amd_sev.c | 10 +++----
 lib/x86/amd_sev.h |  5 ++++
 x86/amd_sev.c     | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index c2f2a3f43193..468ed9eef943 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -355,8 +355,8 @@ static bool pvalidate_failed(int result, bool allow_noupdate)
 	return false;
 }
 
-static void pvalidate_pages(struct snp_psc_desc *desc, unsigned long *vaddr_arr,
-			    bool allow_noupdate)
+void pvalidate_pages(struct snp_psc_desc *desc, unsigned long *vaddr_arr,
+		     bool allow_noupdate)
 {
 	struct psc_entry *entry;
 	int ret, i;
@@ -403,7 +403,7 @@ static int sev_ghcb_hv_call(struct ghcb *ghcb, u64 exit_code,
 	return verify_exception(ghcb);
 }
 
-static int vmgexit_psc(struct snp_psc_desc *desc, struct ghcb *ghcb)
+int vmgexit_psc(struct snp_psc_desc *desc, struct ghcb *ghcb)
 {
 	int cur_entry, end_entry, ret = 0;
 	struct snp_psc_desc *data;
@@ -457,8 +457,8 @@ static int vmgexit_psc(struct snp_psc_desc *desc, struct ghcb *ghcb)
 	return ret;
 }
 
-static void add_psc_entry(struct snp_psc_desc *desc, u8 idx, u8 op, unsigned long vaddr,
-			  bool large_entry, u16 cur_page_offset)
+void add_psc_entry(struct snp_psc_desc *desc, u8 idx, u8 op, unsigned long vaddr,
+		   bool large_entry, u16 cur_page_offset)
 {
 	struct psc_hdr *hdr = &desc->hdr;
 	struct psc_entry *entry = &desc->entries[idx];
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index e180a269fb63..8357a658d47d 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -247,6 +247,11 @@ unsigned long __sev_set_pages_state(struct snp_psc_desc *desc, unsigned long vad
 				    struct ghcb *ghcb, bool large_entry,
 				    bool allow_noupdate);
 void vc_ghcb_invalidate(struct ghcb *ghcb);
+void pvalidate_pages(struct snp_psc_desc *desc, unsigned long *vaddr_arr,
+		     bool allow_noupdate);
+int vmgexit_psc(struct snp_psc_desc *desc, struct ghcb *ghcb);
+void add_psc_entry(struct snp_psc_desc *desc, u8 idx, u8 op,
+		   unsigned long vaddr, bool large_entry, u16 offset);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index ae19f8ad6cc8..bd369e5cada7 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -366,6 +366,71 @@ static void test_sev_psc_intermix_to_shared(void)
 	test_sev_psc_intermix(false);
 }
 
+static void test_sev_snp_psmash(void)
+{
+	int ret;
+	unsigned long vaddr, vaddr_arr[3];
+	struct snp_psc_desc desc = {0};
+	struct ghcb *ghcb = (struct ghcb *)(rdmsr(SEV_ES_GHCB_MSR_INDEX));
+
+	report_info("TEST: PSMASH and UNSMASH operations on 2M range");
+
+	vaddr = (unsigned long)vmalloc_pages(SEV_ALLOC_PAGE_COUNT,
+					     SEV_ALLOC_ORDER, RMP_PG_SIZE_2M);
+
+	/*
+	 * Create a PSC request for first PSC entry where:
+	 * - guest issues an UNSMASH on a 2M private range.
+	 * Hypervisor treats an UNSMASH hint from guest as a nop.
+	 * So it is expected that the state of pages after conversion to
+	 * be in the same state as before.
+	 */
+	vaddr_arr[0] = vaddr;
+	add_psc_entry(&desc, 0, SNP_PAGE_STATE_UNSMASH, vaddr_arr[0],
+		      true, 0);
+
+	/*
+	 * Create a PSC request for second PSC entry where:
+	 * - guest issues a PSMASH on the next 2M private range.
+	 * Hypervisor should also treat PSMASH hint from guest as a nop.
+	 */
+	vaddr_arr[1] = vaddr + LARGE_PAGE_SIZE;
+	add_psc_entry(&desc, 1, SNP_PAGE_STATE_PSMASH, vaddr_arr[1],
+		      true, 0);
+
+	/*
+	 * For 3rd PSC entry:
+	 * Perform an UNSMASH on the PSMASH'd entry where:
+	 * - guest now issues an UNSMASH on a 2M private PSMASH'd entry,
+	 * but since a PSMASH/UNSMASH are noops, states of these pages
+	 * should be in their original (private) states.
+	 */
+	vaddr_arr[2] = vaddr_arr[1];
+	add_psc_entry(&desc, 2, SNP_PAGE_STATE_UNSMASH, vaddr_arr[2],
+		      true, 0);
+
+	ret = vmgexit_psc(&desc, ghcb);
+
+	assert_msg(!ret, "VMGEXIT failed with ret value: %d", ret);
+
+	/*
+	 * Ensure the page states are still in the original (private)
+	 * state after hypervisor handled PSMASH/UNSMASH operations.
+	 */
+	report(is_validated_private_page(vaddr, RMP_PG_SIZE_2M),
+	       "Expected page state: Private");
+
+	report(is_validated_private_page(vaddr + LARGE_PAGE_SIZE,
+					 RMP_PG_SIZE_2M),
+	       "Expected page state: Private");
+
+	pvalidate_pages(&desc, vaddr_arr, true);
+
+	/* Free up all the used pages */
+	snp_free_pages(SEV_ALLOC_ORDER, SEV_ALLOC_PAGE_COUNT, vaddr,
+		       ghcb, true);
+}
+
 int main(void)
 {
 	int rtn;
@@ -387,6 +452,7 @@ int main(void)
 		test_sev_psc_ghcb_nae();
 		test_sev_psc_intermix_to_private();
 		test_sev_psc_intermix_to_shared();
+		test_sev_snp_psmash();
 	}
 
 	return report_summary();
-- 
2.34.1


