Return-Path: <kvm+bounces-21845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD8F5934D7E
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 574541F22BF0
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE6B13C80B;
	Thu, 18 Jul 2024 12:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z9xWEU+N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6867154645
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307156; cv=fail; b=SvnQdFLt+p/BW0LY9rBZiHu0gdevN2EMJZNSt/tZuADxejXwpYO3AGcx4Yt4bH03qAAeS/lUSGELnLTUPNQwf8HIkbb3z+hhRpPx0qHUJkFdy1oQ0+m7bsWkfu854TjQWahoMikTT8q1QYKJcPWUrkQAGrU3r09gQGgRzqdIhmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307156; c=relaxed/simple;
	bh=5BPIQ6D/UY2TWYaQaQgVjoqMarXkblbW9w+HX8WOU44=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QD8dwwc/8rTDy0hUYfJH/OetudeM93kVpKeu8ee4MmjTeB157sT4Wvzg3qIxtwukk5DDkCedK5rWluXYZ4wufoaBvsK5NEMpVSz56rRHkwDgTznbL+iqSgVedbG+CRuQAZY1ynY3zGGmuDe8dyum3io+BhIppAsO8zmLNXT8hHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z9xWEU+N; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e2Hrjl9P2iPR2+oLmQ1F7TXggEKYvbu6kPLkKv9b+XrrgeV/o2+qAZkYXrPuHZBeage6AR1W7teztG/zewY4MxfkF/qfVaCIkglyQgk6dVxIhr/7AlOX73XZ9shL7zTCLND6n5Ev+VFQWlQfxZEx2s1JkWZbxn3rFN4/y7H9yOVJ7Yc2dwHEa9fSgyquWSHcfLEsvsz6UYqIRJfQuVCYW1nubYIoEHEkM6EZd4t1HReRLhCZbC8sQoByDVnnW1ZA6UUG37LhR4sYVpPVzv2n3+rzn0g18hRgOX7zweYYGfFrOjm0RcEDbweh08wq98MtBScMkgzmw8S3HV3PMMst3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2pE6hnj2UM9FZbyBPKsEQah0Qp1UZ6xqYOsYpN1p7g=;
 b=yyw1cqfaHaXVYjyHQswcTuezaA1gPd478+YdTpNCwv6nk69OzFQWl5IaEY/lmnbzV7KBnTIX1+eA53P7yRA7jhD/sbZHTpMCQe2Qbti+RrvNydvg0dzeaJJCx69T1EJ0igCO76MOerGtkXbKJBjO88nwlldYX0POhT4YPCDIIyC14awKOKfF8ffU1ErOPoSbo14cjQ8G+7PjL0LN+7b6eXSGCJaYoIO0Uzb+Lf1JyT9653sCflfu/h2HHCw0Dd7QnDLA0Qych/H+DlbDTn4w/VpKn7fXoCehEVRK/7cvgzjY2XSEG7+Fzo+ElWSm3bRFsdYh8tiD/7VFNF8yZqfFAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2pE6hnj2UM9FZbyBPKsEQah0Qp1UZ6xqYOsYpN1p7g=;
 b=Z9xWEU+NI3j43u9n8+OGInx3LCpxorVpm018gSK/Jt5dIq61SSCNuL5zu9ANmSu+ikkYAQOKaUNYMEv99Zgv0PlJ8F6mNHXGGdHTB1Am196eAHfcqPfBhFoACs+bb6eB6nJUlnIaOtZjQC5y2q199/idSHnFNp7uFPLdK6R7RMI=
Received: from DM6PR03CA0059.namprd03.prod.outlook.com (2603:10b6:5:100::36)
 by CY5PR12MB6477.namprd12.prod.outlook.com (2603:10b6:930:36::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14; Thu, 18 Jul
 2024 12:52:32 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:5:100:cafe::a9) by DM6PR03CA0059.outlook.office365.com
 (2603:10b6:5:100::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Thu, 18 Jul 2024 12:52:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:52:32 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:52:31 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 14/16] x86 AMD SEV-SNP: Change guest pages from Intermix->Shared using GHCB NAE
Date: Thu, 18 Jul 2024 07:49:30 -0500
Message-ID: <20240718124932.114121-15-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|CY5PR12MB6477:EE_
X-MS-Office365-Filtering-Correlation-Id: cba40fcb-82b7-4d02-04cd-08dca7287d88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4ZZ4FdTyT4LBcRlJIWZeY5Un7knzvVgZexH4NjiG0f3TlQxZR/JHgdfAPwK5?=
 =?us-ascii?Q?gmCOTe9ckNroSpyJmoDZu1t6WhZmqDhF71/I2cZkEyhPdK10MNfL2Nzfa5AB?=
 =?us-ascii?Q?+u1oEcd/VyD5EXRwe/xsJy0KgNojz6jSTI80/lT2J4YYvkuWtPvB+werDPgY?=
 =?us-ascii?Q?avZPlSrb/h3Uk/i0/BoxIqiayAOF86Ye4Z6XJOKuqEml64lrcmixcf980TTq?=
 =?us-ascii?Q?eizCggKswODkHCbMQjq0uR7UB+5hJ3BBnytWtmrek5kN1jy+E0alsJePcYUV?=
 =?us-ascii?Q?baBZ5ypoGspy0I1c+0WVzUilDmlGcSPyILhrdIpSGkWS++gYHv3qnD755tIR?=
 =?us-ascii?Q?bwoo9TMZ1g76EXJeCx7VZq/AupFkXZ2aifZwUb2t+4qRVY1Rjb6/1GEdExDh?=
 =?us-ascii?Q?YQGB5Ed4sbzI6CX9+/X7v+Bfpz33jllVhxvtiPa7EOBF215FbgzNY3HYsreJ?=
 =?us-ascii?Q?YLwh+RvLqfFeoZdZfZn1kbLajILm5B1ECzWAkyVOqamvt8by7sYXqfMOz+UG?=
 =?us-ascii?Q?idtOq/V0/WYGu8zDzk9RzSndVXBOHdgOL/CbjvQB2y4HbixF1MLA9GaBzIj/?=
 =?us-ascii?Q?rLdHkcv1gn297YMyLtfn1JsqixlDaJbum5fZghgMHg11cRs2BM7VEqpfQ78l?=
 =?us-ascii?Q?Uer3lgDtNRXLCwW423UPyXsdSYawSfRFmwXUaV55xc2c27wExFX3OBtydvk4?=
 =?us-ascii?Q?Z3+2nomBQIf/JVUOk6ljXOEXAXggXhck4QZNxpsSrpukcF1Ws729fKLYy8XG?=
 =?us-ascii?Q?uTji/dvHjYvIMxNxfLuBHYaxu89q1bJMa7rjJd6soTqCjC/Bj8oO7eyz07Ew?=
 =?us-ascii?Q?O6Y42fL9ZQiyMrbOw2Vbn/W5Shfeywhv6Y7vu0LzBmK6teLLc3i/9lVgrpCz?=
 =?us-ascii?Q?zj0FqDe1P8cA69Xm5k7jhZjbKTIaCeNimmlm/5IflqEvs8i+WfivY9Rklht+?=
 =?us-ascii?Q?5gXcvs7Qj2MfcrMqMZGlTLsw5C9FlJitHow3PzdpHtuXxm50oEL0xu8B7kjB?=
 =?us-ascii?Q?uz5ODSX4xZlhxrUHoPHOsPzYRaG+QQ32FdjfXzCUwZB2UR0OJxtzMcMIbY74?=
 =?us-ascii?Q?rBu9f5ZT18wnnYF0a3AC6PAz085lz8kH18NPU6kHaotJYwkC44TNDFZQWI0q?=
 =?us-ascii?Q?sRg/uwsE8kcmNSaNTWboS65Wm3RTfc9LBHcVaXLFlc+HPHVrhGp9cnF2Ku8y?=
 =?us-ascii?Q?PjejOMarlOwxgTolaz6tY7c7D1QbWcTGBZUU4YfMEQ8Z6FvMdbDgogpP8TEc?=
 =?us-ascii?Q?53gmVqVbikYRIHqZDLwP/ZsLJOv9pt0ideJdW340uh5QtyzcRGdvfSkaUhQE?=
 =?us-ascii?Q?BPFJMtqHw/UzquQxJU3pNgDRolaRGLzR3yERLlilUdjmmWwaKys0lQ2Q++ft?=
 =?us-ascii?Q?OCIO8FoA2HWAaEV7VyMvTVs5SrhTnY+rS5wNbhuw5ouGrLnRr6Nw0ElPDUb0?=
 =?us-ascii?Q?5sfF17jhIJV28diZtHYKCPVqyc02IBYT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:52:32.5583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cba40fcb-82b7-4d02-04cd-08dca7287d88
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6477

The test performs the following actions:
1. Allocates a 2M private page (512 4K entries) and performs 2M private
to shared conversion.
2. Performs partial page state changes (shared->private) on first 256 4K
entries and conducts a re-validation ('pvalidate') check on one of these
entries to ensure its state has been changed to private.
3. Performs PSC from intermixed state to shared state on the 2M large
page.
4. Conducts a write test on the shared pages to ensure page state change
has been successful.

The main goal of this test is to ensure 2M page state changes are
handled properly even if 2M range contains a mix of private/shared
pages.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/amd_sev.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index fc385613b993..ae19f8ad6cc8 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -303,6 +303,21 @@ static void __test_sev_psc_private(unsigned long vaddr, struct ghcb *ghcb,
 	       "Expected page state: Private");
 }
 
+static void __test_sev_psc_shared(unsigned long vaddr, struct ghcb *ghcb,
+				  int npages, bool allow_noupdate)
+{
+	/* Convert the whole 2M range to shared */
+	sev_set_pages_state(vaddr, npages, SNP_PAGE_STATE_SHARED, ghcb,
+			    allow_noupdate);
+
+	set_pte_decrypted(vaddr, npages);
+
+	/* Conduct a write test to ensure pages are in expected state */
+	report(!test_write(vaddr, npages),
+	       "Write to %d unencrypted 2M pages after private->shared conversion",
+	       npages / (1 << ORDER_2M));
+}
+
 static void test_sev_psc_intermix(bool to_private)
 {
 	unsigned long vaddr;
@@ -331,6 +346,8 @@ static void test_sev_psc_intermix(bool to_private)
 	/* Now convert all the pages back to private */
 	if (to_private)
 		__test_sev_psc_private(vaddr, ghcb, (SEV_ALLOC_PAGE_COUNT) / 2, true);
+	else
+		__test_sev_psc_shared(vaddr, ghcb, (SEV_ALLOC_PAGE_COUNT) / 2, true);
 
 	/* Free up all the used pages */
 	snp_free_pages(SEV_ALLOC_ORDER - 1, (SEV_ALLOC_PAGE_COUNT) / 2,
@@ -343,6 +360,12 @@ static void test_sev_psc_intermix_to_private(void)
 	test_sev_psc_intermix(true);
 }
 
+static void test_sev_psc_intermix_to_shared(void)
+{
+	report_info("TEST: 2M Intermixed to Shared PSC test");
+	test_sev_psc_intermix(false);
+}
+
 int main(void)
 {
 	int rtn;
@@ -363,6 +386,7 @@ int main(void)
 		test_sev_psc_ghcb_msr();
 		test_sev_psc_ghcb_nae();
 		test_sev_psc_intermix_to_private();
+		test_sev_psc_intermix_to_shared();
 	}
 
 	return report_summary();
-- 
2.34.1


