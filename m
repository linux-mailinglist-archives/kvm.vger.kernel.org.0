Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8EA36F9E5
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhD3MR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:17:56 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:15328
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232158AbhD3MRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5yothtKWFDIRkbl7S+6HbGErpC4+ZlCVa7zNBKE4kNeItZUSL0U4O/j3NPh65nphDSFE7tcBcN2tRPQMkeFfklx9IAL9a9u2DjPfMFloZZyy85q0NNToJLAFKMPKaUhY5Ai8ptcQcDm2HU3beZmRPOFbYNHUv9QmnH9gcd0rmPd+M6sfSn0EnA7bgYI3fVvZyRagk/zWJlSFwgQ66WRzV0KilYQb6xGpWZRPq2PJUln3UE9TyWcPk0XceAH+TZViZzEGQTZxMO3KfK1A9YDaeTjDT5Vc/vj8gRoYDcQfFO9wC9PEzkZZ2Tjj6FX3IQxxrWE+hXpSzp8kiqsxKP9Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dR/UBnMvWHCPi7NmmG5+lK70cAQaTJlDu5VpRm84CGM=;
 b=Qsag7k6RdUCABvzNi4HZIII0HhKhWXiHQBafvVMHPuVC27CBBfWNnRvJFHX4WDZNVMBsQdcfcdvhSL7M5l5aMl1M4ReyKkShVJ1e47MEB7fxyt/AfR8S54+YcSjzXTrkd4clFtRnJ8X0Rki02+8b30ffhfnv6DwCcthoBzX8iAvbd4+uno+MyWC9aFtTJoQFLWZX1ADcUXT/u2y3tpezkdFaLzgU/9r6b1MJ3jQB+Y6TXIjyTWnV0NGQeJS9Ym8JEYdfwDevHgfGDZP9FMcH2UsFuM6F6sJQx23Ux5C2wDCSqRwvXiKVza9ePNkPQd5svmjkTfhGtWX9fF4eq1YfAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dR/UBnMvWHCPi7NmmG5+lK70cAQaTJlDu5VpRm84CGM=;
 b=y2WDnsEyoCR4xUgPza/tIMJls6Qi9BzmtR5j+kxU3Ivc0MwepldivQyr33gi9bh4Kv5jGJhBECQ1YRtx3iUecb1fQ/K5TKlul3xfYfGLdLLXoSiP87T2Y/zuqSiOaIgY3kJqwhxf7nlY4OBfdAGA1WWjUwk2wwZC4IGxOdcgP5s=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 12:17:01 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:59 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 11/20] x86/compressed: Add helper for validating pages in the decompression stage
Date:   Fri, 30 Apr 2021 07:16:07 -0500
Message-Id: <20210430121616.2295-12-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14fe380f-a7d6-4a71-7ed8-08d90bd1d862
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB264066864EE9D59B743C4E81E55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMgbvEj/LkhCtcdaWgfq++nsDioY8PPqrgTQ0H0G43a/yOy6S0dRRv/UT65iCcsGpT7TTIf2Zb0QGJ2Ek7Z1bc0bKCerumCYPjNipY22xRFhoLTFHBnoWiB7CogQ3sRFiB0PzA8KIaQ7/hkOB1misdmEeT0NScO74hm1BKmvn7ifpe1YjN47LAOxPh+5kDVl9FCjttbE2Iv7D5Q3cPINi8i5nfX0C8R4y9xXZawFytgvy/e0rS9rGxSwT9AskAU819LkiIDJM4meXkfVlka4eu/qOUzkbKlGPI4/QLyN8R52GSrCUk3evsQMhOuG4X0Wy/KDeJvFXzfsrMwLQHEsP42Vs5+yg1X7kTU1AmYGjZhK1VMAqTVw4ovu00RwLH5DQRC3wVongglFGnhZ9fihKUOYGmhn0ImtNq1F5HEu5Gi6pz0pnmIoDSC27aVAqAAMcGj3iWbCmQDdpQpq+SaY4j6WoPfap+/vg9J01uy6xRoV03Pp56QRHtJ12sc1qVq5/j9vwzRYhdLCxiB2QAuP/7Fp+qDqcN3LxJ6Gc50uqfgjjBNDqejxx5HOG/kYsDTiMeu52tg73Yt5RtBvrkkCzDngLb7YcBSyB25N/EXqBcYJe1OvzZbxk/cSkop0BgxuMUNnSfi1JOreoCitaSR22w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(83380400001)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JP+S5NWxGQqrfu0PkCxJh1ngkPenyxHKhzJyrfhQuIMDArflLOfIBHmloQdL?=
 =?us-ascii?Q?O6l/Jxh1EUdkNml1GZni6rWLPpgtpmOkLyWLZFQgZBc/8oGMKR95T7Rvy2fX?=
 =?us-ascii?Q?GTx/3V8m4TMJPyjt3uv7nAroYSYEgt848MK5yMvHk1ur0bDezvb3zVRo+vZ/?=
 =?us-ascii?Q?RsVxOoJAtqhwI/WZJrkpYkLw59ngjzzeuHrnqYkkjclIytZpHZHVbaPQUy96?=
 =?us-ascii?Q?7W5XgKUk1jLsjqLEcReMUIXeLmvFKuUleWPlMvPxw3lEE/YCzX+VP1yCtdsx?=
 =?us-ascii?Q?07EIPUwieKio8F3v1cscQomxwEMXc7sDcSPByhg+1VTPXMES7xHjU72fLFkg?=
 =?us-ascii?Q?JwfjSwRZuGZX+ciYApmOjVK7iZ8zoZIxkNK4ddj1XXoZX8HoG/GH+wonkHw3?=
 =?us-ascii?Q?e3viLTjPARpbi/BLtN/cE9/6ZUnYEcefnl4mT+l41FNTUb40r6rxZCj5zeMo?=
 =?us-ascii?Q?A5aBx1dEmAyytKQ34AxkpENDJnSVlmmDxvG/ZEwAQE1u4mQzpC0qBZvFUIyE?=
 =?us-ascii?Q?InSwnBOhTM14sGwcqJbZbF9WgN8nnm14uKCFcuuBZ+JkzhZ1SINDM8E1l1Jv?=
 =?us-ascii?Q?UPwxUvUW6xRzPxcpMIzdwy50Z6jF7Xqj1nfhWGM9VTKs7OXkCUOmuEc13S0k?=
 =?us-ascii?Q?tInL2qvi9JpcFzdDVEp7WoWhKVvsfvK2OsISQDeZ8TxhBCeD8xYT4wqP1SCU?=
 =?us-ascii?Q?wtSdv2p6RT+ueyFquDL3Y8gfgWLUOfWZjjPlhdsGzJLTKeeADGofNkYuScHP?=
 =?us-ascii?Q?LRaVgSsDWZKoE2GEiYdGyBvjkZLWPXn8NHxLVOULLi6hc8bbQiRLTfS/8wBk?=
 =?us-ascii?Q?zk6YbI+bHQRt8zTwm005dE2Q62/DSl7TXtqtX5FeI0YJq1CkFcSVZqOiAjFe?=
 =?us-ascii?Q?JTNqIFtJmLoEIInstv3E1YX24yj/+1suPENLJuedqsRKD5z9Nhx/R+OnxCOs?=
 =?us-ascii?Q?QmZMtBX/2TSSnWTljUha9CJUaG4waUWVT4jJzpNiAMtXUvsOCPZlfqqKw55n?=
 =?us-ascii?Q?MCB2n9owtTyD2xAgqaoDT0e4giqqZE3jl/levI/jRZ/DkbqDbyHxEpo+fw/1?=
 =?us-ascii?Q?9eEbIveGN7NTlNW8RRaziiXGJDQQx3d0FIi27jJTlEyodVA/xwluE6ZmO/Er?=
 =?us-ascii?Q?RWH4ITzEhFGA915JRBItE6VamDamCgmt7gVehvyg4cN3UqUdGnhboikL9Dx4?=
 =?us-ascii?Q?UPD7aOYplB49VsU/KF3GbHCiISQtbONEf3yi1/PiEfNMGCJWVc6lqoVgrNAa?=
 =?us-ascii?Q?uT/rg5lPyPJ6ipS10U0BKUlw7wFDRR2vYFAzxXki+8Eo1q1Ibuc1mnYU3gS+?=
 =?us-ascii?Q?uAWH8vv+T4cdPeKmcAAmWMI2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14fe380f-a7d6-4a71-7ed8-08d90bd1d862
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:55.7648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTKO2RSzL3MOFTGmZMd8OekYx2aV7mBJT+MXRKqzMwHn7FP6Wz/Qf72hPqJyKyTUQFgw0F0+Z2aE3QYqBEBs8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Many of the integrity guarantees of SEV-SNP are enforced through the
Reverse Map Table (RMP). Each RMP entry contains the GPA at which a
particular page of DRAM should be mapped. The VMs can request the
hypervisor to add pages in the RMP table via the Page State Change VMGEXIT
defined in the GHCB specification. Inside each RMP entry is a Validated
flag; this flag is automatically cleared to 0 by the CPU hardware when a
new RMP entry is created for a guest. Each VM page can be either
validated or invalidated, as indicated by the Validated flag in the RMP
entry. Memory access to a private page that is not validated generates
a #VC. A VM must use PVALIDATE instruction to validate the private page
before using it.

To maintain the security guarantee of SEV-SNP guests, when transitioning
pages from private to shared, the guest must invalidate the pages before
asking the hypervisor to change the page state to shared in the RMP table.

After the pages are mapped private in the page table, the guest must issue a
page state change VMGEXIT to make the pages private in the RMP table and
validate it.

On boot, BIOS should have validated the entire system memory. During
the kernel decompression stage, the VC handler uses the
set_memory_decrypted() to make the GHCB page shared (i.e clear encryption
attribute). And while exiting from the decompression, it calls the
set_page_encrypted() to make the page private.

Add sev_snp_set_page_{private,shared}() helper that is used by the
set_memory_{decrypt,encrypt}() to change the page state in the RMP table.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/boot/compressed/ident_map_64.c | 17 +++++++++
 arch/x86/boot/compressed/sev.c          | 50 +++++++++++++++++++++++++
 arch/x86/boot/compressed/sev.h          | 25 +++++++++++++
 3 files changed, 92 insertions(+)
 create mode 100644 arch/x86/boot/compressed/sev.h

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index f7213d0943b8..c2a1a5311b47 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -21,6 +21,7 @@
 
 #include "error.h"
 #include "misc.h"
+#include "sev.h"
 
 /* These actually do the work of building the kernel identity maps. */
 #include <linux/pgtable.h>
@@ -278,12 +279,28 @@ static int set_clr_page_flags(struct x86_mapping_info *info,
 	if ((set | clr) & _PAGE_ENC)
 		clflush_page(address);
 
+	/*
+	 * If the encryption attribute is being cleared, then change the page state to
+	 * shared in the RMP entry. Change of the page state must be done before the
+	 * PTE updates.
+	 */
+	if (clr & _PAGE_ENC)
+		snp_set_page_shared(pte_pfn(*ptep) << PAGE_SHIFT);
+
 	/* Update PTE */
 	pte = *ptep;
 	pte = pte_set_flags(pte, set);
 	pte = pte_clear_flags(pte, clr);
 	set_pte(ptep, pte);
 
+	/*
+	 * If the encryption attribute is being set, then change the page state to
+	 * private in the RMP entry. The page state must be done after the PTE
+	 * is updated.
+	 */
+	if (set & _PAGE_ENC)
+		snp_set_page_private(pte_pfn(*ptep) << PAGE_SHIFT);
+
 	/* Flush TLB after changing encryption attribute */
 	write_cr3(top_level_pgt);
 
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 7badbeb6cb95..4f215d0c9f76 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -22,6 +22,7 @@
 #include <asm/svm.h>
 
 #include "error.h"
+#include "sev.h"
 
 struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
 struct ghcb *boot_ghcb;
@@ -136,6 +137,55 @@ static inline bool sev_snp_enabled(void)
 	return sev_status_val & MSR_AMD64_SEV_SNP_ENABLED ? true : false;
 }
 
+static void snp_page_state_change(unsigned long paddr, int op)
+{
+	u64 val;
+
+	if (!sev_snp_enabled())
+		return;
+
+	/*
+	 * If the page is getting changed from private to shard then invalidate the page
+	 * before requesting the state change in the RMP table.
+	 */
+	if ((op == SNP_PAGE_STATE_SHARED) && pvalidate(paddr, RMP_PG_SIZE_4K, 0))
+		goto e_pvalidate;
+
+	/* Issue VMGEXIT to change the page state in RMP table. */
+	sev_es_wr_ghcb_msr(GHCB_MSR_PSC_REQ_GFN(paddr >> PAGE_SHIFT, op));
+	VMGEXIT();
+
+	/* Read the response of the VMGEXIT. */
+	val = sev_es_rd_ghcb_msr();
+	if ((GHCB_RESP_CODE(val) != GHCB_MSR_PSC_RESP) || GHCB_MSR_PSC_RESP_VAL(val))
+		goto e_psc;
+
+	/*
+	 * Now that page is added in the RMP table, validate it so that it is consistent
+	 * with the RMP entry.
+	 */
+	if ((op == SNP_PAGE_STATE_PRIVATE) && pvalidate(paddr, RMP_PG_SIZE_4K, 1))
+		goto e_pvalidate;
+
+	return;
+
+e_psc:
+	sev_es_terminate(1, GHCB_TERM_PSC);
+
+e_pvalidate:
+	sev_es_terminate(1, GHCB_TERM_PVALIDATE);
+}
+
+void snp_set_page_private(unsigned long paddr)
+{
+	snp_page_state_change(paddr, SNP_PAGE_STATE_PRIVATE);
+}
+
+void snp_set_page_shared(unsigned long paddr)
+{
+	snp_page_state_change(paddr, SNP_PAGE_STATE_SHARED);
+}
+
 static bool early_setup_sev_es(void)
 {
 	if (!sev_es_negotiate_protocol())
diff --git a/arch/x86/boot/compressed/sev.h b/arch/x86/boot/compressed/sev.h
new file mode 100644
index 000000000000..a693eabc379b
--- /dev/null
+++ b/arch/x86/boot/compressed/sev.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AMD Secure Encrypted Virtualization
+ *
+ * Copyright (C) 2021 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#ifndef BOOT_COMPRESSED_SEV_H
+#define BOOT_COMPRESSED_SEV_H
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+
+void snp_set_page_private(unsigned long paddr);
+void snp_set_page_shared(unsigned long paddr);
+
+#else
+
+static inline void snp_set_page_private(unsigned long paddr) { }
+static inline void snp_set_page_shared(unsigned long paddr) { }
+
+#endif /* CONFIG_AMD_MEM_ENCRYPT */
+
+#endif /* BOOT_COMPRESSED_SEV_H */
-- 
2.17.1

