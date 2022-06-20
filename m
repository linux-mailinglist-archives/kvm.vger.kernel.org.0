Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3796E55277A
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346478AbiFTXDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346466AbiFTXCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:02:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2963B59;
        Mon, 20 Jun 2022 16:02:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkBFZPbJvsDOBqM8Q/KACrbk34p2LkYs6HYDnaAjMOjBoMlYGC9ltI5f4qBBwVG43nj/Ac8ltzni8iYSBFwjfDgVDrGkeSrHRhOoh5Tl3F0tQWT0UC8KO1MvgnbUyL5thlF1G+L1HvuPIQPWZc8KjaZb/KAk11ayM3rW5pifl9x4ZLvozba0YvDXVkDExAQhsTDRFCCQtsznIEWF0V5hRiSXVVLc13acQw4AjFhfQyZDyppamDxUyCk5PBlbX+mJ6vaHgbtnS066Zs+L31cF+GvBZ6tVai6kgJUKzkXRRsY8Tds/bzk97t1Z5yZUVTofakJ2nJq6Nsq/J0Q2yksiKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oAoJX5flzsntszliVXrvpYvkVr670hqrgr1gvF2321A=;
 b=esFRds8N5JIqOrWlm00kWFhqDAB/iJFog3WiE9LqVY/BrgfvNwBtl8Ilr8165PRP6rmpZyAHeeZAMNbq+Pt1f3aRkt0xHf82NUTkN1+gtUmwUK+RuNplKLqKePB5tblXFV/eysI3tgQNWTOskflsiMEQ78mStRJahZQ5z7JUDWfTNZDcP4m1z1DUKj/WWYI5C98vdp4lJBU+uuhAW1BQKbCuL5SJGlm0IGwUmIXyGaKMDea5Tmpm2ir/DqkO2k8eh7zbgWWngW+dLVgycX/kaKQow/N7YYavKpL6IndOnWRE8y8U5ru3ko50HfwthaCCa43pvPxGqBi+wbmD1eqypg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAoJX5flzsntszliVXrvpYvkVr670hqrgr1gvF2321A=;
 b=o449PgJqSphEha5LiMYBMJ4QWEcWGDofpHQjSefKyiIyJREb0Gw9NsIGcaRVSRncaVn0VmdL0NROR53lRHjm3Koy+Avlm2H40SQP6l9Xm4fLrjMT64HAOH4Frnt4BjofVD2fOaOS9jRQRSkSkdE9/vXufpigy8fakCcz0brIY4s=
Received: from CP3P284CA0010.BRAP284.PROD.OUTLOOK.COM (2603:10d6:103:6c::15)
 by SA1PR12MB5657.namprd12.prod.outlook.com (2603:10b6:806:234::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 23:02:49 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10d6:103:6c:cafe::1f) by CP3P284CA0010.outlook.office365.com
 (2603:10d6:103:6c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15 via Frontend
 Transport; Mon, 20 Jun 2022 23:02:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:02:47 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:02:41 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Date:   Mon, 20 Jun 2022 23:02:33 +0000
Message-ID: <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92e091da-fed3-4f66-04a9-08da5310fdf7
X-MS-TrafficTypeDiagnostic: SA1PR12MB5657:EE_
X-Microsoft-Antispam-PRVS: <SA1PR12MB5657A3B932A1E3F107A701528EB09@SA1PR12MB5657.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5wBFJK3K2xzQ375f0+s0hfrGgXJ2XYdHs4mBCAx8ZgXbm29NVy9g1d5sqPcn9RVa1ZqpR5WKiiPsYwQGt9FxVczkhdZPsE7ZxczuXYdC3PFK0BY6NzaS23XESygoyzsGrXdokGeT/E66XGPX+pYf7k28fWut0tmgbtbyb3ubK49/VA1VORy4eg8yLh2rGIVaULdUe3w3huAhz7fQIeCRAZLuJF4+vkojI92DL2mr60qxcRBXTqoRPlbEWPdqbEeE0Xbpg4FZfZ21KoPCsMymMZ0MKSbcbG4h9o1wS7CNrW43/RW8OEZEKxsFiyn8tOSmwHP981/3ahGCPZxCstl60lvXlFRtmBWkET2cDeH8oj3glfy8eLz8D2CT74E1LWAM3z3+cV3b7cakyXL9kkf05ueo8ttRKTi/dQL0lnEsFjgxbk2zBSE1QShWcnKQ9FAdEL1pf7wq2Rkt94WQBvmXDk2rqk7dMW9hZizMqJj0GMoP8zKlqscSjDMvYicOWXab9JTafkkwl0s9jiDfI8v9SDjMRBiCjtgm1V8Y1Y4VwuJMNiX+AIxFaa6GUZZctkGL+Jvw8IlxTIRuqAiUnt5V96gCDCuhTNIbGlXbQ8augN9Kg44iQ28qD4ZzYPtcSvhmShr4lry/eZJktD5d75gm899SRcJk3JhiNwkLbH0Skj1NbXFljD+oG2w/PKG4Txz8h41Cok89zwgu6MOTPMB3fy1QS1YbrK3/Bghthxmj+7ayNmgss1hZWbns0gE4U+PMetwy8bJ5oX88AC6rSge1qOE2f0UKHi3uA/yScOmRLjJyDfMdL8i7FlEmJQ3f1/usoc3hSkEFbVGaHB1RBzC5j+D1bTebntq1hxH0JZwXZ/4Q332Y6YY+7K01N4IlX1pN
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(39860400002)(376002)(40470700004)(46966006)(36840700001)(356005)(36860700001)(2906002)(7696005)(82310400005)(6666004)(86362001)(426003)(26005)(316002)(70206006)(40480700001)(54906003)(478600001)(47076005)(2616005)(36756003)(82740400003)(110136005)(186003)(7406005)(7416002)(8676002)(5660300002)(4326008)(81166007)(966005)(70586007)(40460700003)(8936002)(336012)(16526019)(83380400001)(41300700001)(36900700001)(2101003)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:02:47.0815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e091da-fed3-4f66-04a9-08da5310fdf7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5657
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

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
index 9c2d33f1cfee..cb16f0e5b585 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -9,6 +9,7 @@
 #define __ASM_ENCRYPTED_STATE_H
 
 #include <linux/types.h>
+#include <linux/sev.h>
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 #include <asm/bootparam.h>
@@ -84,6 +85,32 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
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
index 25c7feb367f6..59e7ec6b0326 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -65,6 +65,8 @@
  * bookkeeping, the range need to be added during the RMP entry lookup.
  */
 #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
+#define RMPENTRY_SHIFT			8
+#define rmptable_page_offset(x)	(RMPTABLE_CPU_BOOKKEEPING_SZ + (((unsigned long)x) >> RMPENTRY_SHIFT))
 
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
@@ -2386,3 +2388,44 @@ static int __init snp_rmptable_init(void)
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
2.25.1

