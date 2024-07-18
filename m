Return-Path: <kvm+bounces-21839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2985D934D76
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C7441C20969
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8396F13C699;
	Thu, 18 Jul 2024 12:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YnLIK5U2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2054.outbound.protection.outlook.com [40.107.100.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814B213A407
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307087; cv=fail; b=LeNhHLw0NNx+x9kau9eEdkRsaxvm0WAdsSFepETFa4maytNHqLXh1HkdaCOgUqsdjzgGeoDyI+n/rjNVgMFzdHeAliBi4EcnASZ6pFz8Ylk1tXWHR74XRSkzs2GEucaHBMhMGABH/eS3GVFx9rOR6wTeJZr3KjoUJJw/jKkuUag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307087; c=relaxed/simple;
	bh=RGtYnh711XtDTfuZ5H+WZ1uu1LB1bwaUf8nGg3R2Lfo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CUnX7mV2rJYRAPFa2Y1d59hQdNwFkt2zHJMUhh5D8Os8afqVdYCSXFdRHdhqV+prZCYNIipQgpPjQ3H4eFTmtDTS0kOHcvmThFaBP8U0Pq2okGXxWUcDJBgXO8Kamk7ZCdE/ugAQwUt2tnsj25RebBQH2eUdN0lsc6M9eUXQWa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YnLIK5U2; arc=fail smtp.client-ip=40.107.100.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D14Cz6ZpQipyu4Up+2/X95Qx0Y8Co9eZy2vNE0pdjnUaqO0tXO859Q6aaLzO+lGa+rpihKe/TRoS0b1u9c5h4goeK36B1bOLsVgl9S4KEW7qJGtaZSbDoU4OjatgvbV5eQoT/HsSoKRG+IaWqhU9DrcgoyLUKYYT0xKuKUzHCzrSM9tomasb9QBFKjGpiZ4Ua9+T8NBn82Xe+/J6VGulKwEidyusxU+iXCHR9Y0bbRjUTTX5rE7doh9x6sNF744x1PO1gMRJ/lqZFl3gZIQPStfosp9AMdQ0dVz2AODKv7B+DLv8vdkHcXEpMCmLs9I19NTDlLmmURfdoTGGtT0MIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2h54DwI+E5zunNBkcMlyN4CDXP149UIb147CJB169w=;
 b=vCDkW/iMJ9lyKaNJ+FNfcNUI7oQxEKsMIibUT4/NdUtJ6bwbW+a64YIUJmMqTfRWRcVsfq3IasDbHz69t7G+lzmz9ceL8yZd6UbsQA9SkJTz3wF3M91ja13vUoN2uEpI4hsswZZycX+ABDQttw29VNl4h5v12sMSzeaErMgvkPwOb0WM5nVaD8oc/t7yHbBlYh2ZutVV50POXPZ7oVLz7Hn2pz474i0FEiUAEGewsbDBX7Av+4oyrA4VXX4+Yuzuk+h1LM3d6xcb79ieJw8NODzGiyPb5yqGWhtYR6AA34vdV+cC6rUbD2+t6jyrhF87ybv72aeJpyoqe16sBNfKSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2h54DwI+E5zunNBkcMlyN4CDXP149UIb147CJB169w=;
 b=YnLIK5U2GySIwRdun5V/qQyY8bpJnjwfd6b4WSx9CV0j0qH2+3cDg0hPkiSWDcXjLCwW3GKPZ2QSx/ruUL79uOL3fxgqqy9AEZjG3d9i00VXGJpk+gkWBlEopR+08UcA9wPU8UN/hZaYUKqGUU3W17OurcNg3CRtm+GaAeHoOeY=
Received: from CH2PR17CA0027.namprd17.prod.outlook.com (2603:10b6:610:53::37)
 by MW6PR12MB7087.namprd12.prod.outlook.com (2603:10b6:303:238::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Thu, 18 Jul
 2024 12:51:22 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:53:cafe::64) by CH2PR17CA0027.outlook.office365.com
 (2603:10b6:610:53::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Thu, 18 Jul 2024 12:51:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:51:22 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:51:21 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 08/16] x86 AMD SEV-SNP: Test Private->Shared page state changes using GHCB MSR
Date: Thu, 18 Jul 2024 07:49:24 -0500
Message-ID: <20240718124932.114121-9-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|MW6PR12MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: 736c568e-952b-43a3-0794-08dca72853d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lURWWSTOFqF6qo8lwFf0WxtoD/OU/26NS/Ch0pjNS2AQ3yOlnVjJZyEY4aay?=
 =?us-ascii?Q?KhD1QU8k/RIdCvs1LqnkfOkooCY7LOTRnkn+4ThuHhOUjsGFWCxOIp47t+sl?=
 =?us-ascii?Q?gU9gKzeKBmtkm7TzYTYqT8S/gWPYZx37pnCUWvtJEY5NNMZF1hiJPgKAlfrQ?=
 =?us-ascii?Q?J3VRw8mhnMKqLaHZObXtMxp3U6QLLQxoP0SaIOCGRN8HtsT/Iqz2osAuSR3A?=
 =?us-ascii?Q?1w6SaiaArxj7SKbt1wkpIgkWX41PcXWAix0ey1DQJQXE61DSzOpL/07AXZ8I?=
 =?us-ascii?Q?7xAhMrJCJwsgaY3f2EqGItdVutIuE+ES0Y+9dTCzc2zLH5u/McDSIRzX+8m4?=
 =?us-ascii?Q?SxCUEee3OJkFVmhejf7YNxARGgL4sYPgTp3p7XG+ZDSRmgEe5+XLVLS5VRnZ?=
 =?us-ascii?Q?7i+1K+UlH+bZGDLTT2FF9MfFojUZpGZ15Me+vedPc9MclNF1hC6WmQSqnTUt?=
 =?us-ascii?Q?BaXjH9oqZwUPSSXmdHeJ7JlEYZfz4H9UfGfRt+3sAM5W5cn7J33CmNaNYqEX?=
 =?us-ascii?Q?jwoYytGjbRewEG+nlCYM2RUkDfCSBKKPiPLl4RK9ryMzkIVK+jR4DRgjpz+V?=
 =?us-ascii?Q?RV/ytAMNe1fieQMJJr03ENPMyRT09XVUb14ZbviJLrN6CrGWgi/Oz+sJzYc1?=
 =?us-ascii?Q?aTbtiS6SCcFWXeG8xiaXIhkTRXpOPY7GESURinp4SQuTeCybbqrIHZwaW4+z?=
 =?us-ascii?Q?ggJmV4Q8gcprY/sNBdgTwS+/X7/0FqSlyXzHo8EKNUwEZGt5GCbww3LGozus?=
 =?us-ascii?Q?BJsIFWgjGYKkPIGvERORnCwXbJR7PVqtPe5R24Y+cvHVcjO/AsTIJ+2P0j/q?=
 =?us-ascii?Q?VOYrlRHzTQHXM5Z26rW7wOfMK4JLFqzThkk4WBcFVNDblddNgjyZTb0SBGXr?=
 =?us-ascii?Q?128bKdyrOPHZRQBGvJvURyWMwwIQakYUbEGJcj7b4qLl65tiuILWquPwUQf4?=
 =?us-ascii?Q?QN7xGpSzEIK6Vn6EIO4hB7y9N8ndcIdAzqvDSUF53q3okh30Mkgi1k+cucsM?=
 =?us-ascii?Q?bYBtrtjPwvyZUgXGI/jrvFWd2wuTKpStvLCLSZ8UNvdhE36mlAba+39OSggV?=
 =?us-ascii?Q?z3yaXhJsVeQivAOy8V39cVUv0gIkbKfMIf63+KzZuisEcSqe085Qed4XEu+Y?=
 =?us-ascii?Q?5CrfV4g/MXr2a+vS017ZZAhtuFQRySIwA2Du3Qz38nLCAxYShtKLFyuQ9fEZ?=
 =?us-ascii?Q?frGBN5pf86/3haIov9nSjnv1oaE+c/TFWtHlOJGl1younUbpMnRmzX4nvbvV?=
 =?us-ascii?Q?YVv+DeYRPH1rpN6Qoqs2wXVUfv2JmKhy+W82T0AH0nHVxP3kfwqqbwkxIaUL?=
 =?us-ascii?Q?3ie1ad3Bdf5a5FA3oONi/SHXrQdBGCKIcOZg2vpd8kszNfn2V3U5eBbyjjFE?=
 =?us-ascii?Q?DSH1XknFQ2vKHo3FYePd2zvgVbtkntVT8u/BzC5F3LuQ2umMBqwfONZTpxqh?=
 =?us-ascii?Q?DEeoS2zyyzFtejf7gUCF6WF0qtgQo79D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:51:22.5724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 736c568e-952b-43a3-0794-08dca72853d1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7087

As mentioned in the GHCB spec (Section 2.3.1 GHCB MSR protocol), the
page state change GHCB MSR protocol is used to convert a 4K page from
private to shared or vice-versa. Add support for this test by allocating
a total of 1024 4K pages to ensure the test can handle large cases.

The purpose of this test is to determine whether the hypervisor changes
the page state to shared when using the MSR protocol. Before the
conversion test, ensure the state of the pages are in an expected state
(i.e., private) by issuing a re-validation on one of the newly allocated
page to determine the expected state of the page matches with the page's
current state. Report failure if the expected page state is not private.

After the page state conversion to shared by the hypervisor, ensure the
state of the pages are in shared by writing data to these pages while
the C-bit in its PTEs is not set. Report a failure otherwise.

Provide support for cleaning up the physical pages by converting the
pages to default guest-owned state before freeing them.

Import GHCB MSR PSC related and pvalidate definitions from upstream
linux. (arch/x86/inlcude/asm/sev-common.h and
arch/x86/include/asm/sev.h)

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/asm-generic/page.h |   2 +
 lib/x86/amd_sev.c      | 158 +++++++++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h      |  69 ++++++++++++++++++
 lib/x86/vm.h           |   3 +
 x86/amd_sev.c          |  88 +++++++++++++++++++++++
 5 files changed, 320 insertions(+)

diff --git a/lib/asm-generic/page.h b/lib/asm-generic/page.h
index 5ed086129657..ed9be58e31d0 100644
--- a/lib/asm-generic/page.h
+++ b/lib/asm-generic/page.h
@@ -14,6 +14,8 @@
 #define PAGE_SHIFT		12
 #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
+#define LARGE_PAGE_SIZE		(512 * PAGE_SIZE)
+#define LARGE_PAGE_MASK		(~(LARGE_PAGE_SIZE - 1))
 
 #ifndef __ASSEMBLY__
 
diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index f84230eba2a4..5cbdeb35bba8 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -12,6 +12,8 @@
 #include "amd_sev.h"
 #include "x86/processor.h"
 #include "x86/vm.h"
+#include "vmalloc.h"
+#include "alloc_page.h"
 
 static unsigned short amd_sev_c_bit_pos;
 phys_addr_t ghcb_addr;
@@ -188,3 +190,159 @@ unsigned long long get_amd_sev_addr_upperbound(void)
 		return PT_ADDR_UPPER_BOUND_DEFAULT;
 	}
 }
+
+void set_pte_decrypted(unsigned long vaddr, int npages)
+{
+	pteval_t *pte;
+	unsigned long vaddr_end = vaddr + (npages * PAGE_SIZE);
+
+	while (vaddr < vaddr_end) {
+		pte = get_pte((pgd_t *)read_cr3(), (void *)vaddr);
+
+		if (!pte)
+			assert_msg(pte, "No pte found for vaddr 0x%lx", vaddr);
+
+		/* unset C-bit */
+		*pte &= ~get_amd_sev_c_bit_mask();
+
+		vaddr += PAGE_SIZE;
+	}
+
+	flush_tlb();
+}
+
+void set_pte_encrypted(unsigned long vaddr, int npages)
+{
+	pteval_t *pte;
+	unsigned long vaddr_end = vaddr + (npages * PAGE_SIZE);
+
+	while (vaddr < vaddr_end) {
+		pte = get_pte((pgd_t *)read_cr3(), (void *)vaddr);
+
+		if (!pte)
+			assert_msg(pte, "No pte found for vaddr 0x%lx", vaddr);
+
+		/* set C-bit */
+		*pte |= get_amd_sev_c_bit_mask();
+
+		vaddr += PAGE_SIZE;
+	}
+
+	flush_tlb();
+}
+
+int pvalidate(unsigned long vaddr, bool rmp_size, bool validate)
+{
+	bool rmp_unchanged;
+	int result;
+
+	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
+		     CC_SET(c)
+		     : CC_OUT(c) (rmp_unchanged), "=a" (result)
+		     : "a" (vaddr), "c" (rmp_size), "d" (validate)
+		     : "memory", "cc");
+
+	if (rmp_unchanged)
+		return PVALIDATE_FAIL_NOUPDATE;
+
+	return result;
+}
+
+bool is_validated_private_page(unsigned long vaddr, bool rmp_size)
+{
+	int ret;
+
+	/* Attempt a PVALIDATE here for the provided page size */
+	ret = pvalidate(vaddr, rmp_size, true);
+	if (ret == PVALIDATE_FAIL_NOUPDATE)
+		return true;
+
+	/*
+	 * If PVALIDATE_FAIL_SIZEMISMATCH, entry in the RMP is 4K and
+	 * what guest is providing is a 2M entry. Therefore, fallback
+	 * to pvalidating 4K entries within 2M range.
+	 */
+	if (rmp_size && ret == PVALIDATE_FAIL_SIZEMISMATCH) {
+		unsigned long vaddr_end = vaddr + LARGE_PAGE_SIZE;
+
+		for (; vaddr < vaddr_end; vaddr += PAGE_SIZE) {
+			ret = pvalidate(vaddr, RMP_PG_SIZE_4K, true);
+			if (ret != PVALIDATE_FAIL_NOUPDATE)
+				return false;
+		}
+
+		return true;
+	}
+
+	return false;
+}
+
+enum es_result __sev_set_pages_state_msr_proto(unsigned long vaddr, int npages,
+					       int operation)
+{
+	unsigned long vaddr_end = vaddr + (npages * PAGE_SIZE);
+	unsigned long paddr;
+	int ret;
+	unsigned long val;
+
+	/*
+	 * GHCB maybe established at this point, so save and restore the
+	 * current value which will be overwritten by the MSR protocol
+	 * request.
+	 */
+	phys_addr_t ghcb_old_msr = rdmsr(SEV_ES_GHCB_MSR_INDEX);
+
+	while (vaddr < vaddr_end) {
+		paddr = __pa(vaddr);
+
+		if (operation == SNP_PAGE_STATE_SHARED) {
+			ret = pvalidate(vaddr, RMP_PG_SIZE_4K, false);
+			if (ret) {
+				printf("Failed to invalidate vaddr: 0x%lx, ret: %d\n",
+				       vaddr, ret);
+				wrmsr(SEV_ES_GHCB_MSR_INDEX, ghcb_old_msr);
+				return ES_UNSUPPORTED;
+			}
+		}
+
+		wrmsr(SEV_ES_GHCB_MSR_INDEX,
+		      GHCB_MSR_PSC_REQ_GFN(paddr >> PAGE_SHIFT, operation));
+
+		VMGEXIT();
+
+		val = rdmsr(SEV_ES_GHCB_MSR_INDEX);
+
+		if (GHCB_RESP_CODE(val) != GHCB_MSR_PSC_RESP) {
+			printf("Incorrect PSC response code: 0x%x\n",
+			       (unsigned int)GHCB_RESP_CODE(val));
+			wrmsr(SEV_ES_GHCB_MSR_INDEX, ghcb_old_msr);
+			return ES_VMM_ERROR;
+		}
+
+		if (GHCB_MSR_PSC_RESP_VAL(val)) {
+			printf("Failed to change page state to %s paddr: 0x%lx error: 0x%llx\n",
+			       operation == SNP_PAGE_STATE_PRIVATE ? "private" :
+								     "shared",
+			       paddr, GHCB_MSR_PSC_RESP_VAL(val));
+			wrmsr(SEV_ES_GHCB_MSR_INDEX, ghcb_old_msr);
+			return ES_VMM_ERROR;
+		}
+
+		if (operation == SNP_PAGE_STATE_PRIVATE) {
+			ret = pvalidate(vaddr, RMP_PG_SIZE_4K, true);
+			if (ret) {
+				printf("Failed to validate vaddr: 0x%lx, ret: %d\n",
+				       vaddr, ret);
+				wrmsr(SEV_ES_GHCB_MSR_INDEX, ghcb_old_msr);
+				return ES_UNSUPPORTED;
+			}
+		}
+
+		vaddr += PAGE_SIZE;
+	}
+
+	/* Restore old GHCB msr - setup by OVMF */
+	wrmsr(SEV_ES_GHCB_MSR_INDEX, ghcb_old_msr);
+
+	return ES_OK;
+}
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 70f3763fe231..04c569be57eb 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -84,6 +84,16 @@ struct ghcb {
 
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
 
+/* PVALIDATE return codes */
+#define PVALIDATE_FAIL_SIZEMISMATCH	6
+
+/* Software defined (when rFlags.CF = 1) */
+#define PVALIDATE_FAIL_NOUPDATE		255
+
+/* RMP page size */
+#define RMP_PG_SIZE_4K		0
+#define RMP_PG_SIZE_2M		1
+
 enum es_result {
 	ES_OK,			/* All good */
 	ES_UNSUPPORTED,		/* Requested operation not supported */
@@ -106,6 +116,13 @@ struct es_em_ctxt {
 	struct es_fault_info fi;
 };
 
+/*
+ * Assign a large enough order to run SEV-SNP based tests for 4K as well
+ * as 2M ranges
+ */
+#define SEV_ALLOC_ORDER		10
+#define SEV_ALLOC_PAGE_COUNT	1 << SEV_ALLOC_ORDER
+
 /*
  * AMD SEV Confidential computing blob structure. The structure is
  * defined in OVMF UEFI firmware header:
@@ -157,15 +174,67 @@ efi_status_t setup_amd_sev(void);
  */
 #define SEV_ES_GHCB_MSR_INDEX 0xc0010130
 
+#define GHCB_DATA_LOW		12
+#define GHCB_MSR_INFO_MASK	(BIT_ULL(GHCB_DATA_LOW) - 1)
+#define GHCB_RESP_CODE(v)	((v) & GHCB_MSR_INFO_MASK)
+
+/*
+ * SNP Page State Change Operation
+ *
+ * GHCBData[55:52] - Page operation:
+ *	0x0001	Page assignment, Private
+ *	0x0002	Page assignment, Shared
+ *	0x0003	PSMASH
+ *	0x0004	UNSMASH
+ */
+enum psc_op {
+	SNP_PAGE_STATE_PRIVATE = 1,
+	SNP_PAGE_STATE_SHARED,
+	SNP_PAGE_STATE_PSMASH,
+	SNP_PAGE_STATE_UNSMASH,
+};
+
+#define GHCB_MSR_PSC_REQ	0x14
+#define GHCB_MSR_PSC_REQ_GFN(gfn, op)				\
+	/* GHCBData[55:52] */					\
+	(((u64)((op) & 0xf) << 52) |				\
+	/* GHCBData[51:12] */					\
+	((u64)((gfn) & GENMASK_ULL(39, 0)) << 12) |		\
+	/* GHCBData[11:0] */					\
+	GHCB_MSR_PSC_REQ)
+
+#define GHCB_MSR_PSC_RESP	0x15
+#define GHCB_MSR_PSC_RESP_VAL(val)				\
+	/* GHCBData[63:32] */					\
+	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
+
 bool amd_sev_es_enabled(void);
 efi_status_t setup_vc_handler(void);
 bool amd_sev_snp_enabled(void);
 void setup_ghcb_pte(pgd_t *page_table);
 void handle_sev_es_vc(struct ex_regs *regs);
+int pvalidate(unsigned long vaddr, bool rmp_size, bool validate);
+void set_pte_decrypted(unsigned long vaddr, int npages);
+void set_pte_encrypted(unsigned long vaddr, int npages);
+bool is_validated_private_page(unsigned long vaddr, bool rmp_size);
+enum es_result  __sev_set_pages_state_msr_proto(unsigned long vaddr,
+					        int npages, int operation);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
 
+/*
+ * Macros to generate condition code outputs from inline assembly,
+ * The output operand must be type "bool".
+ */
+#ifdef __GCC_ASM_FLAG_OUTPUTS__
+# define CC_SET(c) "\n\t/* output condition code " #c "*/\n"
+# define CC_OUT(c) "=@cc" #c
+#else
+# define CC_SET(c) "\n\tset" #c " %[_cc_" #c "]\n"
+# define CC_OUT(c)[_cc_ ## c] "=qm"
+#endif
+
 /* GHCB Accessor functions from Linux's include/asm/svm.h */
 #define GHCB_BITMAP_IDX(field)							\
 	(offsetof(struct ghcb_save_area, field) / sizeof(u64))
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index cf39787aa8b0..a5bd8d4ecf7c 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -7,6 +7,9 @@
 #include "asm/io.h"
 #include "asm/bitops.h"
 
+#define ORDER_4K	0
+#define ORDER_2M	9
+
 void setup_5level_page_table(void);
 
 struct pte_search {
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 4c34a5965a1b..3b1593e42634 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -14,6 +14,9 @@
 #include "x86/processor.h"
 #include "x86/amd_sev.h"
 #include "msr.h"
+#include "vmalloc.h"
+#include "x86/vm.h"
+#include "alloc_page.h"
 
 #define EXIT_SUCCESS 0
 #define EXIT_FAILURE 1
@@ -128,6 +131,85 @@ static void test_stringio(void)
 	report((got & 0xff00) >> 8 == st1[sizeof(st1) - 2], "outsb up");
 }
 
+static enum es_result sev_set_pages_state_msr_proto(unsigned long vaddr,
+						    int npages, int operation)
+{
+	efi_status_t status;
+
+	vaddr &= PAGE_MASK;
+
+	if (operation == SNP_PAGE_STATE_SHARED) {
+		status = __sev_set_pages_state_msr_proto(vaddr, npages, operation);
+
+		if (status != ES_OK) {
+			printf("Page state change (private->shared) failure");
+			return status;
+		}
+
+		set_pte_decrypted(vaddr, npages);
+	} else {
+		set_pte_encrypted(vaddr, npages);
+
+		status = __sev_set_pages_state_msr_proto(vaddr, npages, operation);
+
+		if (status != ES_OK) {
+			printf("Page state change (shared->private) failure.\n");
+			return status;
+		}
+	}
+
+	return ES_OK;
+}
+
+static int test_write(unsigned long vaddr, int npages)
+{
+	unsigned long vaddr_end = vaddr + (npages << PAGE_SHIFT);
+
+	while (vaddr < vaddr_end) {
+		memcpy((void *)vaddr, st1, strnlen(st1, PAGE_SIZE));
+		vaddr += PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+static void test_sev_psc_ghcb_msr(void)
+{
+	void *vaddr;
+	efi_status_t status;
+
+	report_info("TEST: GHCB MSR based Page state change test");
+
+	vaddr = alloc_pages(SEV_ALLOC_ORDER);
+	force_4k_page(vaddr);
+
+	report(is_validated_private_page((unsigned long)vaddr, RMP_PG_SIZE_4K),
+	       "Expected page state: Private");
+
+	status = sev_set_pages_state_msr_proto((unsigned long)vaddr,
+					       SEV_ALLOC_PAGE_COUNT,
+					       SNP_PAGE_STATE_SHARED);
+
+	report(status == ES_OK, "Private->Shared Page state change for %d pages",
+	       SEV_ALLOC_PAGE_COUNT);
+
+	/*
+	 * Access the now-shared page(s) with C-bit cleared and ensure
+	 * writes to these pages are successful
+	 */
+	report(!test_write((unsigned long)vaddr, SEV_ALLOC_PAGE_COUNT),
+	       "Write to %d unencrypted 4K pages after private->shared conversion",
+	       (SEV_ALLOC_PAGE_COUNT) / (1 << ORDER_4K));
+
+	/* convert the pages back to private after PSC */
+	status = sev_set_pages_state_msr_proto((unsigned long)vaddr,
+					       SEV_ALLOC_PAGE_COUNT,
+					       SNP_PAGE_STATE_PRIVATE);
+
+	/* Free up all the pages */
+	free_pages_by_order(vaddr, SEV_ALLOC_ORDER);
+}
+
 int main(void)
 {
 	int rtn;
@@ -136,5 +218,11 @@ int main(void)
 	test_sev_es_activation();
 	test_sev_snp_activation();
 	test_stringio();
+
+	/* Setup a new page table via setup_vm() */
+	setup_vm();
+	if (amd_sev_snp_enabled())
+		test_sev_psc_ghcb_msr();
+
 	return report_summary();
 }
-- 
2.34.1


