Return-Path: <kvm+bounces-15275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2DD8AAEEF
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 251AB1F22D9B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9608595F;
	Fri, 19 Apr 2024 13:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2TD4oR3e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F598592C
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531601; cv=fail; b=FC4iitvY9At5f1BouAwGYQOiUlVuVrEVuUyqhdwFD8SRmnwGn2icLnha4aegNW8MsUUlH20UBHa8Va+jDBYjIoDtSc1T4EkyBMnl0m4WgM23UGcZbeEUtufVMuYaj8rDmoPVAsTajvBhixov77LZkQsg5txPDuqwknBE6YicbtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531601; c=relaxed/simple;
	bh=QpBcmKKB5SgeZbyQwukEH3zOSwVegCQJFwxVDgf4TrU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jfPuq5qgs8wZgmGvshiuGpbIrLh4ZpJI4TOop3qTpT32Thc2LKxkUNp8W0SIAhuKH3+Ux2LV8xapUGHqqhcThQt9OCwHypdVPdhy6WJJvW76LIzZnM3xLYwHfLDJtM5E5Q65a1+s6GJGe4kkRHscoeQQUTYfL7OCONnBF2oOODU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2TD4oR3e; arc=fail smtp.client-ip=40.107.102.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtmMBxAHAvNJ+AbkyHx34WWf874vJnP0sJJDav3pIVs5BAftm0NRya9oGPYKKC6o6UWW5ItmePUFr1UWZWAhJwB8QSwlAOOesrWLMEobr2fPWsJFC97n+2XBeJEyrKCl2SgtsZQ5MdrurtsVFV2F5JC8/OB1Wez4LVQxB3S6cqh2Ow61TPNqLX8Q9Z5SxArrNzZjjPneOJx5Ou0sHTUV+C0gWYrquQ9mYfm9hhoOaKA/n9Xlz61Mn3RrIT00xkBswCbQNmhl3Uj7ZsHuQOpqBnorniwQ9H37Nn5H+hS4AgTGBeV2k/G6iPcgjvPqkQtQBure0wEUvBFUQRVFL/o6sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iUMSEN1fAI2NxU47msr7drfMnFNCTpbWT5FNt253Is=;
 b=KsbsIkUuKYK9LhhaNqOTxAxj7MVj6EoGOqqdTbF7nCvIQPcrJU/8Kx3tRDt7jZJb6o8tKzTIqpOWi6JOy/ISgOeC9/cjnwky1pNdxzeS3YwV+TSb3zsakDLS5zY4msU39f8u8Z2X7Kadj2rwfvGOtpLv44tn6Z8DNlMad4cWm3jKn2ys5nszWsGxLdcceZDjVZCSIMAxjYe2gIe9fm13ps//8acVOHjcPdG3fJP7hFN1JBHuMy+TVZLXYIUAEeCt/gDT0r53X8U0wfieZPv3Lm5SnjnpRVrt0ygNSXZzmyAtJLseZPEG0FDs+MYaK7+E/42f1Pn9gPP+MP3g1PXzbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iUMSEN1fAI2NxU47msr7drfMnFNCTpbWT5FNt253Is=;
 b=2TD4oR3egC39FWoDfK7JybjcU3dwxmN01ioUhjkOuXC/+wBYh9Qk5daL/JPNqf7MPUFHE/zq+2UYnhA9PnY0of4iw6tfkeLGAs7F8ZEqiRxbqTiAzYyOiuFEBRzQWQfvzxz/F6w2YnDFh0EL/2Vd+aIT5Dm34LJc83AmJMhxsAY=
Received: from PH7PR13CA0020.namprd13.prod.outlook.com (2603:10b6:510:174::27)
 by MW4PR12MB7382.namprd12.prod.outlook.com (2603:10b6:303:222::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Fri, 19 Apr
 2024 12:59:56 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:510:174:cafe::c6) by PH7PR13CA0020.outlook.office365.com
 (2603:10b6:510:174::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.16 via Frontend
 Transport; Fri, 19 Apr 2024 12:59:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 12:59:56 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 07:59:54 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 08/13] x86 AMD SEV-SNP: Test Private->Shared Page state changes using GHCB MSR
Date: Fri, 19 Apr 2024 07:57:54 -0500
Message-ID: <20240419125759.242870-9-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419125759.242870-1-papaluri@amd.com>
References: <20240419125759.242870-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|MW4PR12MB7382:EE_
X-MS-Office365-Filtering-Correlation-Id: b77900af-f0be-4a1c-2e47-08dc60709cb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+0GLTT5PZTjVHNhGDJ/6kSFnv1tuypSQQqMf9BWDE/q2dMaN8PYs7gy3c83u6S+gj+x168hB2S/a4rOZm6a8SbcM11za9Edm527GRb/cT9OfL/c3JBqca/R4luHZ4vq0f5FigT7IanR4togZvCKOUpbDD1RTqkuBrGrlKAL8caqtXz5IoVHr96zVriMxlG4ubHi2yN2wQ7CbrP0Nmg3SO7UvTzZRFnTf3yjeVbIstutMJHKjLYbo5PdrA+EWgAY84jgn6Q5kUc9Ejmpo6V199TQxiMZ4absp4SvD5G2MIyicjZknsBBCmhEKatltR/MCdNM5DVlkhyZdWElSW5VoGrlSY5RT78tbi1uH9tdqQSvmpN4nsPILT8yPXrwBVjoeuuXT+m9YHaKgn2WczP9h701x/nfEaFLEMv0kPgYSgC2N3TufGly3muzVQ5xWZIroSgzHa0c2ewwIb96RZV5Ir8ghMIPMQ0Hss39Fd7JIvRtOaRB+hYtXfwNEll8SSyHPZFWS+enhMZ0EPWXCLomRU0hYx7A5fbNE1FLbX1MzZIGfBUgeRGAHAh6EtUG75Mudk329/xfmVwWomQDVLrGLB9/iLyDaop6TzN9n/U0D+hN1ltaLRoFJqGwn68F1qIvYAwciGQvvttxwWEnsE6e166NdJCd90x/3I+lvN7SoNGyIOJBHab5V2keaAAqxw5GLFtyv902Yu22FBAHnN61gJQ1Fw7sVBJIfob1hZOqyw/Fc6rd90t92t6kB2gfDiNdp
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 12:59:56.0281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b77900af-f0be-4a1c-2e47-08dc60709cb8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7382

As mentioned in the GHCB spec (Section 2.3.1 GHCB MSR protocol), the
SEV-SNP guest VM issues 4K page state change requests to the hypervisor
to convert KUT's newly allocated private pages to shared pages using
GHCB MSR protcol.

The purpose of this test is to determine whether the hypervisor changes
the page state to shared. Before the conversion test, ensure the state
of the pages are in an expected state (i.e., private) by issuing a
re-validation on one of the newly allocated page to determine the
expected state of the page matches with the page's current state.
Report failure if the expected page state is not private.

Import GHCB MSR PSC related definitions from upstream linux
(arch/x86/include/asm/sev-common.h and arch/x86/include/asm/sev.h)

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/amd_sev.h |  51 ++++++++++
 x86/amd_sev.c     | 241 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 292 insertions(+)

diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 70f3763fe231..b648fb0e7873 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -84,6 +84,15 @@ struct ghcb {
 
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
 
+/* PVALIDATE return codes */
+#define PVALIDATE_FAIL_SIZEMISMATCH	6
+
+/* Software defined (when rFlags.CF = 1) */
+#define PVALIDATE_FAIL_NOUPDATE		255
+
+/* RMP page size */
+#define RMP_PG_SIZE_4K			0
+
 enum es_result {
 	ES_OK,			/* All good */
 	ES_UNSUPPORTED,		/* Requested operation not supported */
@@ -157,6 +166,36 @@ efi_status_t setup_amd_sev(void);
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
+ */
+enum psc_op {
+	SNP_PAGE_STATE_PRIVATE = 1,
+	SNP_PAGE_STATE_SHARED,
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
@@ -166,6 +205,18 @@ void handle_sev_es_vc(struct ex_regs *regs);
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
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 23f6e3490546..71d1ee1cef91 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -14,11 +14,14 @@
 #include "x86/processor.h"
 #include "x86/amd_sev.h"
 #include "msr.h"
+#include "x86/vm.h"
+#include "alloc_page.h"
 
 #define EXIT_SUCCESS 0
 #define EXIT_FAILURE 1
 
 #define TESTDEV_IO_PORT 0xe0
+#define SNP_PSC_ALLOC_ORDER 10
 
 static char st1[] = "abcdefghijklmnop";
 
@@ -94,6 +97,140 @@ static efi_status_t find_cc_blob_efi(void)
 	return EFI_SUCCESS;
 }
 
+static inline int pvalidate(u64 vaddr, bool rmp_size,
+			    bool validate)
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
+static efi_status_t __sev_set_pages_state_msr_proto(unsigned long vaddr, int npages,
+						    int operation)
+{
+	unsigned long vaddr_end = vaddr + (npages * PAGE_SIZE);
+	unsigned long paddr;
+	int ret;
+	u64 val;
+
+	/*
+	 * We are re-using GHCB MSR value setup by OVMF, so save and
+	 * restore it after PSCs.
+	 */
+	phys_addr_t ghcb_old_msr = rdmsr(SEV_ES_GHCB_MSR_INDEX);
+
+	while (vaddr < vaddr_end) {
+		/*
+		 * Although identity mapped, compute GPA to use guest
+		 * physical frame number (GFN) while requesting an
+		 * explicit page state change.
+		 */
+		paddr = __pa(vaddr);
+
+		if (operation == SNP_PAGE_STATE_SHARED) {
+			/* Page invalidation happens before changing to shared */
+			ret = pvalidate(vaddr, RMP_PG_SIZE_4K, false);
+			if (ret) {
+				printf("Failed to invalidate vaddr: 0x%lx, ret: %d\n",
+				       vaddr, ret);
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
+			printf("Wrong PSC response code: 0x%x\n",
+			       (unsigned int)GHCB_RESP_CODE(val));
+			return ES_VMM_ERROR;
+		}
+
+		if (GHCB_MSR_PSC_RESP_VAL(val)) {
+			printf("Failed to change page state to %s paddr: 0x%lx error: 0x%llx\n",
+			       operation == SNP_PAGE_STATE_PRIVATE ? "private"
+								   : "shared",
+			       paddr, GHCB_MSR_PSC_RESP_VAL(val));
+			return ES_VMM_ERROR;
+		}
+
+		if (operation == SNP_PAGE_STATE_PRIVATE) {
+			ret = pvalidate(vaddr, RMP_PG_SIZE_4K, true);
+			if (ret) {
+				printf("Failed to validate vaddr: 0x%lx, ret: %d\n",
+				       vaddr, ret);
+				return ES_UNSUPPORTED;
+			}
+		}
+
+		vaddr += PAGE_SIZE;
+	}
+
+	/* Restore old GHCB MSR - setup by OVMF */
+	wrmsr(SEV_ES_GHCB_MSR_INDEX, ghcb_old_msr);
+
+	return ES_OK;
+}
+
+static void set_pte_decrypted(unsigned long vaddr, int npages)
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
+		/* unset c-bit */
+		*pte &= ~(get_amd_sev_c_bit_mask());
+
+		vaddr += PAGE_SIZE;
+	}
+
+	flush_tlb();
+}
+
+static efi_status_t sev_set_pages_state_msr_proto(unsigned long vaddr, int npages,
+						  int operation)
+{
+	efi_status_t status;
+
+	vaddr = vaddr & PAGE_MASK;
+
+	/*
+	 * If the encryption bit is to be cleared, change the page state
+	 * in the RMP table.
+	 */
+	if (operation == SNP_PAGE_STATE_SHARED) {
+		status = __sev_set_pages_state_msr_proto(vaddr, npages,
+							 operation);
+		if (status != ES_OK) {
+			printf("Page state change (Private->Shared) failure.\n");
+			return status;
+		}
+
+		set_pte_decrypted(vaddr, npages);
+	}
+
+	return ES_OK;
+}
+
 static void test_sev_snp_activation(void)
 {
 	efi_status_t status;
@@ -109,6 +246,51 @@ static void test_sev_snp_activation(void)
 	report(status == EFI_SUCCESS, "SEV-SNP CC-blob presence");
 }
 
+/*
+ * Perform page revalidation to ensure page is in the expected private
+ * state. We can confirm this test to succeed when the pvalidate fails
+ * with a return code of PVALIDATE_FAIL_NOUPDATE.
+ */
+static bool is_validated_private_page(unsigned long vaddr, bool rmp_size,
+				      bool state)
+{
+	int ret;
+
+	/* Attempt a pvalidate here for the provided page size */
+	ret = pvalidate(vaddr, rmp_size, state);
+	if (ret == PVALIDATE_FAIL_NOUPDATE)
+		return true;
+
+	/*
+	 * If PVALIDATE_FAIL_SIZEMISMATCH, Entry in the RMP is a 4K
+	 * entry, and what guest is providing is a 2M entry. Therefore,
+	 * fallback to pvalidating 4K entries within 2M range.
+	 */
+	if (rmp_size && ret == PVALIDATE_FAIL_SIZEMISMATCH) {
+		unsigned long vaddr_end = vaddr + LARGE_PAGE_SIZE;
+
+		for (; vaddr < vaddr_end; vaddr += PAGE_SIZE) {
+			ret = pvalidate(vaddr, RMP_PG_SIZE_4K, state);
+			if (ret != PVALIDATE_FAIL_NOUPDATE)
+				return false;
+		}
+	}
+
+	return ret == PVALIDATE_FAIL_NOUPDATE ? true : false;
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
 static void test_stringio(void)
 {
 	int st1_len = sizeof(st1) - 1;
@@ -126,6 +308,60 @@ static void test_stringio(void)
 	report((got & 0xff00) >> 8 == st1[sizeof(st1) - 2], "outsb up");
 }
 
+static void test_sev_psc_ghcb_msr(void)
+{
+	pteval_t *pte;
+	unsigned long *vaddr;
+	efi_status_t status;
+
+	vaddr = alloc_pages(SNP_PSC_ALLOC_ORDER);
+	if (!vaddr)
+		assert_msg(vaddr, "Page allocation failure at addr: %p", vaddr);
+
+	/*
+	 * Page state changes using GHCB MSR protocol can only happen on
+	 * 4K pages.
+	 */
+	force_4k_page(vaddr);
+
+	/* Use this pte to check the C-bit */
+	pte = get_pte_level((pgd_t *)read_cr3(), (void *)vaddr, 1);
+	if (!pte) {
+		assert_msg(pte, "No pte found for vaddr %p", vaddr);
+		return;
+	}
+
+	if (*pte & get_amd_sev_c_bit_mask()) {
+		/*
+		 * Before performing private->shared test, ensure the
+		 * page is in private and in a validated state.
+		 */
+		report(is_validated_private_page((unsigned long)vaddr,
+						 RMP_PG_SIZE_4K, true),
+		       "Expected page state: Private");
+
+		report_info("Private->Shared conversion test using GHCB MSR");
+
+		/* Perform Private->Shared page state change */
+		status = sev_set_pages_state_msr_proto((unsigned long)vaddr,
+						       1 << SNP_PSC_ALLOC_ORDER,
+						       SNP_PAGE_STATE_SHARED);
+
+		report(status == ES_OK, "Private->Shared Page State Change");
+
+		/*
+		 * Access the now-shared page(s) with C-bit cleared and
+		 * ensure read/writes return expected data.
+		 */
+		report(!test_write((unsigned long)vaddr, 1 << SNP_PSC_ALLOC_ORDER),
+		       "Write to %d unencrypted pages after private->shared conversion",
+		       1 << SNP_PSC_ALLOC_ORDER);
+	}
+
+	/* Cleanup */
+	free_pages_by_order(vaddr, SNP_PSC_ALLOC_ORDER);
+}
+
 int main(void)
 {
 	int rtn;
@@ -134,5 +370,10 @@ int main(void)
 	test_sev_es_activation();
 	test_sev_snp_activation();
 	test_stringio();
+	setup_vm();
+
+	if (amd_sev_snp_enabled())
+		test_sev_psc_ghcb_msr();
+
 	return report_summary();
 }
-- 
2.34.1


