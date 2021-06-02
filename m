Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B1C398C08
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhFBOOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:14:06 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:57888
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230234AbhFBONh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlSZLEjeg7eDOwUbgqJ0Bp0tPyZwXNsw1F4vK/gCQycbxyhEb78T4NoZD8SINKYqPCWc+0mi5fjtn8qVXc8SvhtoTRumqcZJ8bKAYIdbU4lVA/nObCE2AFPbV36lYn7VzTp275MT6l2mNzC61PodNtSxOl722RkkFYr5flv7/PZE16trTJ18rwB/siDB5JaU/LLdUukqOU3GWRqHsLzxOTMfs79+Sh4R2waJBxYrraINXd3AEWXz96TtFxovFBzi9fLaOI5zNxXYMA/kAatrYZJoAPTNCPqu36Prz52GaH2n4GCDZjV96JBys8lY5REaocf/lEJSLFrTMcpIG8/BWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5FeCbgJvCPDvNZucTG6C/Be5DjljDLwjfU1yTbGz3c=;
 b=TY2unl9Bn0+gYOR5KBXrA78lSQxlA2K6KUgv7Vgg1iJbWO1Jmqu9ViVlGAdKzjpKPZRXQ/JjjsEWxHufCybRiNbTTIQCkcaILtkH5LEopt7M1471IYR1MaXnIXJUCV+kzJy1OnAGXn6kr63rdtrz/dYQbDHYFoBXMqxlFgpUDdN5hKN1koTohjREzqLq2t/pFXPWnAma5qAbiyA2+ywK+EYQ6EALkXqUtcFFyy+s8Ak3WWRoThIuAarMPc5wVxpjHl0sCmaWVEI0VIl5ByeS3jrDgK3xlSJPuq7QAM23RUwRsFMRYhY5UG3KV1Tmf35UalV28rUpNj/Sbo2aytjiZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5FeCbgJvCPDvNZucTG6C/Be5DjljDLwjfU1yTbGz3c=;
 b=L1orI7FmTdpKRbgmDwBg96RjF/tICP0FErx2qc91HbJb1LTCoesCE7jNnnFzQ+eiXI6L21uggrZMstojC07lQoxBqC8iTQBlpdJcsiYI2MmP3twIyQgulXd+IVAqGAfPX1D/BrOrfWDAgUllNo4oI+3hC5YUY31IvokhH4btaoM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:35 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:35 +0000
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 05/37] x86/sev: Add RMP entry lookup helpers
Date:   Wed,  2 Jun 2021 09:10:25 -0500
Message-Id: <20210602141057.27107-6-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d93bc58-4741-45b7-ecaf-08d925d0541b
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23681E81E6B88E35286E006FE53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cwEXj2G1id13+xvZBTNiYGMkxdPHBwII5WrimSoKIo539E+Z/paSSL1aQdKq6NIX/7ivLU3R4o1CjXBDitypLB4CX4pigEbHy/H0qJ5wSJU24AOasbr6HfMz/rvhE3dKo9GHBtd2pLc/dtOhTJ+JcVeBfbQUSRDIDpOC+nBuLFcFm77luuD1+2JDyFvgaTr4VO14/J3JvCU8hiDXo5dUj0MVIuNdO4WIcvm9A9tFjSiIyBPdBgG5dV2Wd/GbMC42rgio+uzltI0wpVlPvfeevRVvyWF8X1dShnmBna8ulr/eQiZrDNtslcAZVOFwftCd1LQy/Td5GxbErZB6qC/Bj4edncC1e3FsTViCx6tRIp4V3pehi6BwvucqMYwSmHt71+fDJFGFN/2qxf8l1kb7iulT82BYz7M1NPbh34ZyZiyBRUAl71yd7TbjOyrZ2cIJn5dgQ0lDmDNeMIdTaRpQjTi5ultzF3rtU8H+lS6iQMEoB8gp/QzaswqedbBR8HQx+v01dLvp3arSgrQY6nAR6NTdnr+zM433B6k2m9U6B5/0dk6D17Tmm+G9CyndeAULHm+p2GUkxqRH1YnqEgilS9DT11AGIjSuIkYs6ctMs5sJUNo7495ZPL05nH+RntEXAGys8lIfmyrAFTeSny/TCtXVw+wnez0BFTRQnDaq08o5sk9l7xwG4MlYUXER1/H7FssGrrIdNu3/odFj7fs3k9oa+HFGXt7EYN72rmyfoHG7/KJJ95zKNuAPh3c+ih1kJ+PPPMWCJm0+bp1NHfb+qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(966005)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zBSld+TuNf6/haO0tZT1K/xqBnmj+ca7s7QDmKbOtkHl+g3UHbO1aCIl4QqP?=
 =?us-ascii?Q?QJ5RzrhVuY+WP96cUmKtigpmtajn+OQt3Nn9e0W2rDEbGJGkj3m1RrcNVrPa?=
 =?us-ascii?Q?ovzVI8rne+Ocoy4TwEasUrF9uQ2gSOyENAknHRrdWdXzLj+hOYuKNlXUjUJh?=
 =?us-ascii?Q?k5uxwSAlrkg7Kiofe+GoRWnevQE4bY5PbXcsJNmLDnBvuOkTrp/XuFc0uh8m?=
 =?us-ascii?Q?CvMPaWEkh4aCFbG2vQYL07QxNLQTz7DMRNfL+cIjiFUHWS0BtkAXeQSf+Uau?=
 =?us-ascii?Q?o3o0Hc5hfK1J8MW7V05hAXgZCyeHvj7qZcuxcw41+8Q111bIGrauS6wbvAKm?=
 =?us-ascii?Q?bj2O5YbUp8CJ50nbN0uUdl4nEfLzNDjqKSBlnDW8kaVp2kWGTt2qBpttiuB0?=
 =?us-ascii?Q?t5YR3SK5jSgzsKeIfYT4XnB2iaGxFe+L9E6V2YfOMG0b2QlVhiMou1BD7xmp?=
 =?us-ascii?Q?Nd2/wrmr3Gfhkqrh9DrYnjf2UYFNSUtrvX1cX1Gf8FidjnNkMzoZL0U28EeP?=
 =?us-ascii?Q?6ELL7DZWc24Jxe8M9/apRe+qFsJtF7/kZD3p8oAyqLKbCJE0mquqRjG5Q268?=
 =?us-ascii?Q?nhSUfz7qvDHU2mb8bgRRAxTSs4j4GD0+3KjbS3T5Tnjbruu6tCQPQ1DwN92I?=
 =?us-ascii?Q?tkFnCmuHhzzxEYhbLqyxLKqFDLAkjihN2TRbgahDI3WDAzdrMgGd5MxqaA/G?=
 =?us-ascii?Q?Ky/erszbI5HkWgv/Sjb1QMx/hiVpOJOZcOFpgRUAZ9fGkV9aU7ofe7Ty/8qM?=
 =?us-ascii?Q?9MrHhgatrSIpBBgkpfTqeSgwmmqsZAKS/Dy2dJa/kBfDMGWGH6M5Dm1FaJxp?=
 =?us-ascii?Q?fF/GcjMTk2ErSMUW8vsAwt+X8AHxxAN8JWqvgrU/eelRiJT2vIbv/gub2fzn?=
 =?us-ascii?Q?WA/c+uf94UC5MDXtFiT/eNR5y5siS2ZOFT6rCbkvd/nZGXVt8HsNDhrcjJWh?=
 =?us-ascii?Q?JOzrhRzE6m9WDVahYSFo08VZUaR0hKf4Pnm76PGyFDcdIjZabKp/7UeYiyL1?=
 =?us-ascii?Q?CS2cROnebfspErFDAd48xTKB6g7y4l2X4b437bpM8P/PLrayO0GBg+qg5jni?=
 =?us-ascii?Q?oL8q+xTJks56Nn3JrtIr4WxsrXJggGUv6obWzMUYSXtNyoM1pAV3dYiTD+UI?=
 =?us-ascii?Q?fRzWiLL9xu8PYyzc2N77sKHKDjAjj6JW7AQLCnDm6Yon6dQ43xBkycc038Ku?=
 =?us-ascii?Q?VjK5Hwd2PSeQcOSjvwpQeJwpNT+n/LgWW6/HuG8GUtiGK6KFmsBwa2pMet+i?=
 =?us-ascii?Q?D6J2wHbYkRu9NBnZJ7pqqZvUPR5Mxl7e+lQ+jag8LYatkfULBEMUWKdq/iBa?=
 =?us-ascii?Q?l67UoZ65WJfGSJNaXWTifK1q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d93bc58-4741-45b7-ecaf-08d925d0541b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:34.6126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9i+wQwB0Dmb4NtK6Foir73OXN7Ze5RP3r4mfUgC0lUK86sCg7kDLx2CX7qtOW16FQSlIfS2x9hg9nHT+EKc1wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
entry for a given page. The RMP entry format is documented in AMD PPR, see
https://bugzilla.kernel.org/attachment.cgi?id=296015.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h |  4 +--
 arch/x86/kernel/sev.c      | 28 +++++++++++++++++++++
 include/linux/sev.h        | 51 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/sev.h

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index da2f757cd9bc..2764a438dbeb 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -9,6 +9,7 @@
 #define __ASM_ENCRYPTED_STATE_H
 
 #include <linux/types.h>
+#include <linux/sev.h>
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 
@@ -74,9 +75,6 @@ struct cc_blob_sev_info {
 /* Software defined (when rFlags.CF = 1) */
 #define PVALIDATE_FAIL_NOUPDATE		255
 
-/* RMP page size */
-#define RMP_PG_SIZE_4K			0
-
 /* Memory opertion for snp_prep_memory() */
 enum snp_mem_op {
 	MEMORY_PRIVATE,
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 172497d6cbb9..51676ab1a321 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -46,6 +46,10 @@
 
 #define DR7_RESET_VALUE        0x400
 
+#define RMPTABLE_ENTRIES_OFFSET	0x4000
+#define RMPENTRY_SHIFT		8
+#define rmptable_page_offset(x)	(RMPTABLE_ENTRIES_OFFSET + (((unsigned long)x) >> RMPENTRY_SHIFT))
+
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
 
@@ -2198,3 +2202,27 @@ static int __init snp_rmptable_init(void)
  * passthough state, and it is available after subsys_initcall().
  */
 fs_initcall(snp_rmptable_init);
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
index 000000000000..83c89e999999
--- /dev/null
+++ b/include/linux/sev.h
@@ -0,0 +1,51 @@
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
+#define rmpentry_vmsa(x)	((x)->info.vmsa)
+#define rmpentry_asid(x)	((x)->info.asid)
+#define rmpentry_validated(x)	((x)->info.validated)
+#define rmpentry_gpa(x)		((unsigned long)(x)->info.gpa)
+#define rmpentry_immutable(x)	((x)->info.immutable)
+
+/* RMP page size */
+#define RMP_PG_SIZE_4K			0
+
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

