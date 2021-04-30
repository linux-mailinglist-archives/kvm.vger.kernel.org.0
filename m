Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B9836FA80
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhD3MkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:05 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:15105
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232475AbhD3Mj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCtWZca2Njik7qz99/C/z629S0X74MwkfQcBiayanHvLptiGamYNhS888AKcYG7ykJouugwmPLwwknoX46ceLE+ZFyxYsPIdwzEc2MYHGao+KWcLfHAEUNFplnmXQaw0V5J6FJShmeTPiq9SJqGJsfZxJRNPi1OlKABp56vHh94/plGP7HYhuo7xE7hMEeIKemPk88RIsh/lyQUMyLESOtD5xk4W6AQ9pUT+d07UCA5izRhCtgaOnz5D6mYufcByyIUVZlv6AJ7poYFYHNAgPVTUoeU3y1FrzwFT2Lz5qrc1X5f8zQxXJOmjhVuYKWvjpeJCbHS32zXTxlo1ji5AVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q83C/jzYOOnVgwB4PymkXjtqp1TK1hMza9YW4F1I3zE=;
 b=leo/pFQwqrfIEmBR8g/cfAd/k1LARf39inLnA5tu6WMrYXoKoxFoJJaOVt9IF6HlKR66tdeBuzd7ol86vpHRjgstE6raOCYrOSclL7SNdqQHyRM0mkDUJMwajPqrN7QfGNuFhurDT7rf84PLHd1BbVSjQjcpfjKJOJm406wSKPXcGbLHLXxhaCO2blcGNnRGHeOxJCVl8bJdGznODeOPl2JWC8FM39mV6OFBIQE4pZjYvjdhI2PEoUkJ2gJb0suz6mhcBtwij46r+mFpyXJimrIDF9ukbOBjxFIBoy2kqEQM6GP4uGmPdfwM6poDGw5KjzC+UdUmgFnSgrr3q3qZ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q83C/jzYOOnVgwB4PymkXjtqp1TK1hMza9YW4F1I3zE=;
 b=j1JQxfpDvgSr5KN7IAIn1hCupw87/EXBdeJiqPLZHbZCMWcfanF5Y+Y1GNhw5VMPAcw2sXuvW88r8IvFsD2NkhvnLX6F/gvhOrnktFI40qct3yVmJuAsTfkfLnacULLVO6MDCb5ClBdwzW6SmP5HSgmPgITT+/Unnn3OnfF7KUE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:38:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:58 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 06/37] x86/sev: Add RMP entry lookup helpers
Date:   Fri, 30 Apr 2021 07:37:51 -0500
Message-Id: <20210430123822.13825-7-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:38:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcd307f5-92da-4cce-3a9c-08d90bd4ec8b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45118AAE86C53C024FAF0E6BE55E9@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +UxaLWrgwcBTeYb+zu9mq6cXP1QXZI1Fv96m7sGTM4LnV1Jsn+6ObdAzaP8R1VoFK3uGgojQBHYzikk/OLw1SUFayXL/WXggsqCgCowYw9D//jZkqf8jUWBZk3/zIH6kMALvYhzh7nTmj8aCcvcbPt7N/Y+Y313/hVUNW0H4DJPb4AejhOx+aTXSjKU7JXQysSB26tTUXPxiMiyNhjLAQFNz+qZOPjsGJyr0Zq3ROM4tXR8xJK86Wjp4Gw+A+AHxzFKhuoXNFC06Xgb0da+ykmp5fEkra90nCNga0/T/GL4su8sqk87eXRu9j/etdJX2AQQL63etdPBuNoPb6dRnyWLLSkZUPPEtCPiUgmTnoKrUh2vUwjEbWV90TQfmuIjUt2Yb78XDy4Q2bq4PUnhsSNSMVzxfgNhEEPn/4yw7VUlTWds+2WFOio/z+UO7NiFrT3w7nKsrSeac8S9mqs7Y/v1HMt0e2dSqpQYNZ9VdZn3IAv5Q9OByrCT3oRRkW1wMMyrOnAkQY6LDPbQaDkvzNp87dFvhJQeGl6bgaKN3c48abdXut0pt2dbfnhVDOHNFtT+JU32qyNG85fm5oOZEXdfoVrL1hw+Dmt1eDUIejeGSeFAltpPnszMtpfP0gW+7dgeGxMClfiRpHzKfHn2y4C26XQrqYcVyVXAlJBK273vWUqullCZarfzJB6sAayJ7nWpvB3KhsvdkItAfoZCSQt2naoHj8jj0rcPM39gnhqg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(83380400001)(36756003)(8936002)(86362001)(966005)(66476007)(956004)(186003)(38350700002)(16526019)(6666004)(6486002)(44832011)(52116002)(5660300002)(38100700002)(7416002)(66556008)(2616005)(26005)(478600001)(4326008)(66946007)(316002)(2906002)(8676002)(7696005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DmbDIJDrPmIKxQYt5VwsqyEU5wg0nRizDxnL3y7UMqa1vEta5kMnlWBxYjkL?=
 =?us-ascii?Q?EmaKJnx+Zb2LatRnygh6L3e1jwDmok5EMnPwVLmn2A0zqol/9j9NKMsLPIHm?=
 =?us-ascii?Q?uPCeqGCEMLpwLA+6ocWhLX4LQezmG7KuEM/TMqndDbQUenbKjXRcDCrBvjFJ?=
 =?us-ascii?Q?bx89dtC42aRQ53v7yP2DgBD8sz0qVPJHwdPVQ8m9OCaf5Z69t3cP/hGpvsUy?=
 =?us-ascii?Q?JSMAXmhYp9eybKJsORhXmgZJglW4DOlaQLFmelEM2cWPzB283QVm6iDFNMDh?=
 =?us-ascii?Q?j9hzubRT8NQoEYy+lRYoHkThTNC0kDqZ5a287Mi2zi2TWD4d74h9OY3EYe5B?=
 =?us-ascii?Q?nxmYebB4gFMe+9rwCGiVRuWtBceuiWSJmh6Md4OqACkyzEr5h6nR71x3QofB?=
 =?us-ascii?Q?Onv8rRn/0vWI3LLuZ7dc7kJN+WBhBiED2teYjZUzsPBNeb8UbuV9GmIvQQnv?=
 =?us-ascii?Q?5dcQtwpPNxgYOkmV/In6OC2XYO1atY9U3E98T76E3D5oQRUv/M4xm8303vqe?=
 =?us-ascii?Q?ZexLTuyyR+j+cA+yxUOgATxXn5uKGBdOugZE4e7oro7yywQXUBYXgPgI8ndU?=
 =?us-ascii?Q?Zp2dpnB1v3Cg9LkRYfiyw1uzQvnK0sSHYwvzrVR9V1sCDTBhSIDIGyZkmMdQ?=
 =?us-ascii?Q?UQIgFGE1kzVzKY+JY46ox6g7zjZYirrXDWuKOsgLmDdn4Dzrjm14AO0t6XKB?=
 =?us-ascii?Q?JmcWpYoDgLWrb1gaBFsjiLwzV1Ttyo1b8iwgde1nMBa4BJ7N4LGwGKd/tGRE?=
 =?us-ascii?Q?jS9awfnmQQWeJf4cBq5Ya4gfHhsQAO4DfNXxDk817VVjYF1M3lt9sHOxYjc/?=
 =?us-ascii?Q?hspBlwSAJmhFKM3yEvdly4QfzNu3PmCmmBG/7AfeqIzkBHst5VfkukJ2NsYA?=
 =?us-ascii?Q?NhXdtPvbHyDG4ACeBKi9awFKOcOiF+h001Cw1OrU2eKoiB40mHsbsrl+F2MJ?=
 =?us-ascii?Q?FoSBVYvnkfs+rjIPd9i72DKZYeuZKmThl2/DOKonB0otGf8h28cqwVw8MnvZ?=
 =?us-ascii?Q?AV+XYPMHsbO7zKZrw0B0kn5tLQyWMy6/4qbBnz80e5+EIDCTcNesF7LanjOB?=
 =?us-ascii?Q?LNvNDQavZd56CRlPlkfMZBTl6/noLYdjEGDpT6UZd2tALUC/LpVsEa9mIkoI?=
 =?us-ascii?Q?sV7TdVfzIW6aj4+docvjd8l/4iYVjw7KrsWOCgomPl7JtN5wduexlrAU0eUz?=
 =?us-ascii?Q?FCpDkQCHR8DlsxJmh7j8TU3s4I1CTlxaoMUExQWtKtFef5g7/VFhwxkjWy0C?=
 =?us-ascii?Q?J39nv7Ww/50G16YM5CffK+BQ1UZDiNfMcIDpPcFdf6LLixjUcyNisGXKuDlM?=
 =?us-ascii?Q?Gf8RO7/5DYd/YSUWBYF3Iz+A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd307f5-92da-4cce-3a9c-08d90bd4ec8b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:58.0854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hSNtlePMb3EHlJwEW4QziuByoD36ZAqgGiuODz0/jGZdaGmZ4unFPWIob2aG6C/Xmq5ZFFJ6EOG1QhgRuRgWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
entry for a given page. The RMP entry format is documented in AMD PPR, see
https://bugzilla.kernel.org/attachment.cgi?id=296015.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h |  5 +---
 arch/x86/kernel/sev.c      | 28 ++++++++++++++++++++
 include/linux/sev.h        | 54 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/sev.h

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 7f4c34dd84e1..a65e78fa3d51 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -9,6 +9,7 @@
 #define __ASM_ENCRYPTED_STATE_H
 
 #include <linux/types.h>
+#include <linux/sev.h>
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 
@@ -65,10 +66,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 #define PVALIDATE_FAIL_SIZEMISMATCH	6
 #define PVALIDATE_FAIL_NOUPDATE		255 /* Software defined (when rFlags.CF = 1) */
 
-/* RMP page size */
-#define RMP_PG_SIZE_2M			1
-#define RMP_PG_SIZE_4K			0
-
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern struct static_key_false sev_es_enable_key;
 extern void __sev_es_ist_enter(struct pt_regs *regs);
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 126fa441c0f8..dec4f423e232 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -40,6 +40,10 @@
 
 #define DR7_RESET_VALUE        0x400
 
+#define RMPTABLE_ENTRIES_OFFSET	0x4000
+#define RMPENTRY_SHIFT		8
+#define rmptable_page_offset(x)	(RMPTABLE_ENTRIES_OFFSET + (((unsigned long)x) >> RMPENTRY_SHIFT))
+
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
 
@@ -1873,3 +1877,27 @@ static int __init snp_rmptable_init(void)
 	return 0;
 }
 early_initcall(snp_rmptable_init);
+
+struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level)
+{
+	unsigned long phys = page_to_pfn(page) << PAGE_SHIFT;
+	struct rmpentry *entry, *large_entry;
+	unsigned long vaddr;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return NULL;
+
+	vaddr = rmptable_start + rmptable_page_offset(phys);
+	if (unlikely(vaddr > rmptable_end))
+		return NULL;
+
+	entry = (struct rmpentry *)vaddr;
+
+	/* Read a large RMP entry to get the correct page level used in RMP entry. */
+	vaddr = rmptable_start + rmptable_page_offset(phys & PMD_MASK);
+	large_entry = (struct rmpentry *)vaddr;
+	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(large_entry));
+
+	return entry;
+}
+EXPORT_SYMBOL_GPL(snp_lookup_page_in_rmptable);
diff --git a/include/linux/sev.h b/include/linux/sev.h
new file mode 100644
index 000000000000..ee038d466786
--- /dev/null
+++ b/include/linux/sev.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AMD Secure Encrypted Virtualization
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#ifndef __LINUX_SEV_H
+#define __LINUX_SEV_H
+
+struct __packed rmpentry {
+	union {
+		struct {
+			u64 assigned:1;
+			u64 pagesize:1;
+			u64 immutable:1;
+			u64 rsvd1:9;
+			u64 gpa:39;
+			u64 asid:10;
+			u64 vmsa:1;
+			u64 validated:1;
+			u64 rsvd2:1;
+		} info;
+		u64 low;
+	};
+	u64 high;
+};
+
+#define rmpentry_assigned(x)	((x)->info.assigned)
+#define rmpentry_pagesize(x)	((x)->info.pagesize)
+#define rmpentry_vmsa(x)	((x)->info.vmsa)
+#define rmpentry_asid(x)	((x)->info.asid)
+#define rmpentry_validated(x)	((x)->info.validated)
+#define rmpentry_gpa(x)		((unsigned long)(x)->info.gpa)
+#define rmpentry_immutable(x)	((x)->info.immutable)
+
+/* RMP page size */
+#define RMP_PG_SIZE_2M			1
+#define RMP_PG_SIZE_4K			0
+
+/* Macro to convert the x86 page level to the RMP level and vice versa */
+#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
+#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level);
+#else
+static inline struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_AMD_MEM_ENCRYPT */
+#endif /* __LINUX_SEV_H */
-- 
2.17.1

