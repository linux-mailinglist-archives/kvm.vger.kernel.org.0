Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433E13F307D
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241459AbhHTQA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:00:59 -0400
Received: from mail-bn8nam08on2041.outbound.protection.outlook.com ([40.107.100.41]:41272
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241331AbhHTQAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:00:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M44ckCnfqqwmeXcBMZ5joEPo1iouJAoPQusMj3G5UbsT0PaRKg0TxMMPAfxOsgp3nkj2pink1uSA93s5aEVc6NdxoY7ZcOtje9+XD97hunQjCuQ2VaEQPlJcIGF/gNR63ACz4kOhfcNs2uwRGzW4h7yA4kbtgqCitXlcq+ZS8GmTkpRvwMpE3bOWkh/yh1f0049ZF73qUjH4w21N9ufj/cBa8Ku31FdE7cyGfIUazWke2/IMFH3/QtHXjwRLJ+HQJ4OYZ+RdkgluTzHlqecbpoKKbRGrUSEDfjdKSyf5C+kB3/GNcCsXA4EQKfQ3EbGzSwMb9w7n7VXYHDZNrTYGxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDuty8fciVTbuT4DbrWGCzSi8qFkUopmznZZW0S9Zgs=;
 b=Bo/AScl1Uu8Zvoa3Ere4e98o0H9VD1RY9J19QOPHNs2LONEKSopS88dGwWL/BVtDdUSmn1k+gDjb7ydnkkJhrzSC4OhmeOUIuWyxQEwqVl5quYNtQAxxK1vlAnO8RTMJogENyVOU9dsh31h+9hwGkTiYLoxTbZd9+UU3gpa4YTLbiifZFXlFeXmzG7RENBiauOE8sdt5tlgWg8EmmAA4FxiP+LwqQ7+LFj2t3IL5lpUImahSyP400hh1W/niEP0BnwzTyP+pMlTeEcOY+SycWcjcn/JxTVS9kagrUd+1c4s5fpydZcpjI3A9rWMRcj3/KvW7O2s77cQ25/wYQLH0xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDuty8fciVTbuT4DbrWGCzSi8qFkUopmznZZW0S9Zgs=;
 b=iz7B3sVeloUlN4iDS56YSsLCL2ZXLmsDDSiB6vVLDBFWLFXNdy48qdd2Vz+ntwXXj48breu6MZwYRBNYmld9wTWXnE7aAXGsgxQ73wEsEsFce2IIGlo7CWGbP0k8sLn2q+8NZ9iIRTeBWWfV5rKyFCYdoeQmGibCKrvIAzOduSY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 15:59:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 15:59:58 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 04/45] x86/sev: Add RMP entry lookup helpers
Date:   Fri, 20 Aug 2021 10:58:37 -0500
Message-Id: <20210820155918.7518-5-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 15:59:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a97f0a64-29df-4304-1e25-08d963f38f4c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384E067F164C3A814CA63E7E5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JtFV/Fw6dGyH/GUi5p3J1DTFJ/+PKLi/fOE6jiXLvrTyW1qEzW66YIZuxyEzlCj0udto7zBGQdk3W/XwWUTip3PyGdRSsUqMhIWpgso5PzACZ/V5ABJzySGdBA5Z4rZfYmQHSuqQisLS9gQamzZ3f2RTpgK6S4MbcKzJvhfT0G829LrDy1y/KtaAALlD9qZTtmlrJyiCYmgqSlobn7ZU/XkGXy+E01ohyqfwbCPkuz/ye36UdomEBdWQ2I7uOIHnDibUoXnESKztktT7mE2Kw9+oYjF3/LdRHjcKajoUALseuYihVhPYdigqOMFDTW20ZBVybmgl+Kz8otuQXR7hQ9e313Rs2+HK7G+Maung4QgJvG5UbRH27I/uYHTG4KxYlE4gZNR+13Yk3mxR/kvgEXbtUzKx57sbWkBL5spSwP0lZp+copk8dwKgdeq5xD4Ee8ByR/mPCLMQR4+D/XBDMc3epafsNDVTvuabqg0et7M7ClyhZQna+o4hi0ULWqmjxFZvBFYuVww2uY8uQEbAgZDijWDoHJGcuWI5Am8MAhsz8xYbRE4cRGrPNpgzhdSbEemDY+eMOkczZRsVOe6JZnVwzhUMGE1OKhALDXE0zZrtPxloBxQwaQIjC6D8p4KvgnJ/Pj1B4U0ky42co5up7U3y9iZPpWtyUAw4TriYweHOC6P6P2lWhYPO3tmuQUNKmlI1WFHOQ0ZNaSngzzPyiHVP528AktqmthXG4SifwW7TpBY+WFJck4LL4Ip6kVX3HlUJBu8PrQWBWTSFK8J9V5avX3BPmr2s9p7/Avv5U4RrfZd2lxWfJA9hiFtc5ZHm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(966005)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R2XygyW1OzSyFvSYUmCoxRhtuo4YxgFXa9+1r8x+nJzdYPSVjKMDJbPzmbG5?=
 =?us-ascii?Q?/LJoCq1TGk53iRmq/4onT1Hm7VDPONkbZPiJh57abYD7dANLdnsEZJSVXJEz?=
 =?us-ascii?Q?ox5KK5pyeXMq1lD+CmH+kDVteW9+jMAj8chWY3dBL86hlfllrFnhXc8vmzF0?=
 =?us-ascii?Q?DJJP8fe3qBnEBtXxYKd5zVE1GMIz2Y1yg005bOezyN65qNI31z2B42pOju8d?=
 =?us-ascii?Q?b2cMYqqGpmQ4vq9CMAKiziHsibYinEiPK4okt7R4UazChuklu/+xDBTjA66g?=
 =?us-ascii?Q?Z06FByY4Apeb5Coqex6ms90hD6c3h3RPIcpU8pj6oQB+3ptL+LDhXVKEdQa8?=
 =?us-ascii?Q?9NI0Uo1QyUNYE0bHnZdQJzH+NlX4j+MU9iHuj+cRmlr8SDBtfXMkjg5BsSA2?=
 =?us-ascii?Q?AJ4nQ3+wSpYyWvh21M9bjbldx6jks5rNwIrBRYFKC3+yQO2lQ1mTGrJNHDJ+?=
 =?us-ascii?Q?rDwtnEZHlDV5IIfldAwUBf5rgxwJtlIdyNYDfVwmItv/QQbzbUnsn+TPc2y8?=
 =?us-ascii?Q?VpIQxs/qrdVia0RV6AHVnZdgeFy3ANpRW+YtpM2CR7tQfxDj8wiCV7bfuIzT?=
 =?us-ascii?Q?cBCPvA95aL7fGj+vu+lVN2fKToNTCBXWhsdERDwQDzOGs38H2bXih8Qs/V+L?=
 =?us-ascii?Q?aIMZzeXAa8DE6CMFPIjzhHYDd6seZE1cWCpowAi4beZRJQ+ckvmBARTzA8J6?=
 =?us-ascii?Q?kiEOlmvdWAdoZQm8B1qkLvLHMs5T9Zr+Jj0ZcZgLw4A9zWTAOckOEoNTCOpt?=
 =?us-ascii?Q?7ZxNE7wc6Wq7YVkTGul1Ujz8EW7mkCVSRg8sgdoqRoqPdnHq4AB0SYEUxzD9?=
 =?us-ascii?Q?Zv9UiGjK5ML8RRBDwqES5X8Bw9MQ97e/LW53rVs2zeUn45fcW8/u6RCv9GGD?=
 =?us-ascii?Q?ibYhOy/Cm/v6JUDMfadXBnPJXoxBF1WUx800+wDN394XIRfYoSBTE1Uu7P1G?=
 =?us-ascii?Q?v0lEUnAppRfLli3/1gD3oKrZCLXsLzRP+t8BOArvX52VIfD6qBACDgoQiWk0?=
 =?us-ascii?Q?8guJTl2BL6BOHLD09vNtPhGYLzg/NxK2Ka3wbdgjbgTBBcu6Lw5GYwVYnS5f?=
 =?us-ascii?Q?LnlKW2v5jrqukV0d4jXuw/cXFRbBHg2B3rncpNZbukzgoACHird/7Z6raIfg?=
 =?us-ascii?Q?Uh55YDVeHw/P2Zignbf9Mh3x49a4mpVKUqygmB8gvFhXaFJwhmmL7oRUEBKp?=
 =?us-ascii?Q?P3rqLyyyQcUVGO5+FN7JLtRzCno4XQIc7Xo/Yk29pIlf0X7ClDzGikFw+Srv?=
 =?us-ascii?Q?B27MJg53FJpIQD/7G0sfATTlvvZzWaFYEPRgxIW7Mhe3gKzWeTfHSlDfAYB5?=
 =?us-ascii?Q?L/wswy1Fv1LnCb3WaAGrkRew?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a97f0a64-29df-4304-1e25-08d963f38f4c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 15:59:58.4027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XRjpqYnwyQ11HUPAv9jzc2vFGzn+ZKF4/KJm6Wzbpx1ReLPorgH2Yxs7NyMq8yG6a8YNJ3yRHl+W7DsjnUKrWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
entry for a given page. The RMP entry format is documented in AMD PPR, see
https://bugzilla.kernel.org/attachment.cgi?id=296015.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h | 27 ++++++++++++++++++++++++
 arch/x86/kernel/sev.c      | 43 ++++++++++++++++++++++++++++++++++++++
 include/linux/sev.h        | 30 ++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)
 create mode 100644 include/linux/sev.h

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index a5f0a1c3ccbe..5b1a6a075c47 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -9,6 +9,7 @@
 #define __ASM_ENCRYPTED_STATE_H
 
 #include <linux/types.h>
+#include <linux/sev.h>
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 #include <asm/bootparam.h>
@@ -77,6 +78,32 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
+#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+
+/*
+ * The RMP entry format is not architectural. The format is defined in PPR
+ * Family 19h Model 01h, Rev B1 processor.
+ */
+struct __packed rmpentry {
+	union {
+		struct {
+			u64	assigned	: 1,
+				pagesize	: 1,
+				immutable	: 1,
+				rsvd1		: 9,
+				gpa		: 39,
+				asid		: 10,
+				vmsa		: 1,
+				validated	: 1,
+				rsvd2		: 1;
+		} info;
+		u64 low;
+	};
+	u64 high;
+};
+
+#define rmpentry_assigned(x)	((x)->info.assigned)
+#define rmpentry_pagesize(x)	((x)->info.pagesize)
 
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 7936c8139c74..f383d2a89263 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -54,6 +54,8 @@
  * bookkeeping, the range need to be added during the RMP entry lookup.
  */
 #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
+#define RMPENTRY_SHIFT			8
+#define rmptable_page_offset(x)	(RMPTABLE_CPU_BOOKKEEPING_SZ + (((unsigned long)x) >> RMPENTRY_SHIFT))
 
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
@@ -2376,3 +2378,44 @@ static int __init snp_rmptable_init(void)
  * available after subsys_initcall().
  */
 fs_initcall(snp_rmptable_init);
+
+static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
+{
+	unsigned long vaddr, paddr = pfn << PAGE_SHIFT;
+	struct rmpentry *entry, *large_entry;
+
+	if (!pfn_valid(pfn))
+		return ERR_PTR(-EINVAL);
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return ERR_PTR(-ENXIO);
+
+	vaddr = rmptable_start + rmptable_page_offset(paddr);
+	if (unlikely(vaddr > rmptable_end))
+		return ERR_PTR(-ENXIO);
+
+	entry = (struct rmpentry *)vaddr;
+
+	/* Read a large RMP entry to get the correct page level used in RMP entry. */
+	vaddr = rmptable_start + rmptable_page_offset(paddr & PMD_MASK);
+	large_entry = (struct rmpentry *)vaddr;
+	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(large_entry));
+
+	return entry;
+}
+
+/*
+ * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
+ * and -errno if there is no corresponding RMP entry.
+ */
+int snp_lookup_rmpentry(u64 pfn, int *level)
+{
+	struct rmpentry *e;
+
+	e = __snp_lookup_rmpentry(pfn, level);
+	if (IS_ERR(e))
+		return PTR_ERR(e);
+
+	return !!rmpentry_assigned(e);
+}
+EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
diff --git a/include/linux/sev.h b/include/linux/sev.h
new file mode 100644
index 000000000000..1a68842789e1
--- /dev/null
+++ b/include/linux/sev.h
@@ -0,0 +1,30 @@
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
+/* RMUPDATE detected 4K page and 2MB page overlap. */
+#define RMPUPDATE_FAIL_OVERLAP		7
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+int snp_lookup_rmpentry(u64 pfn, int *level);
+int psmash(u64 pfn);
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
+int rmp_make_shared(u64 pfn, enum pg_level level);
+#else
+static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
+static inline int psmash(u64 pfn) { return -ENXIO; }
+static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
+				   bool immutable)
+{
+	return -ENODEV;
+}
+static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
+
+#endif /* CONFIG_AMD_MEM_ENCRYPT */
+#endif /* __LINUX_SEV_H */
-- 
2.17.1

