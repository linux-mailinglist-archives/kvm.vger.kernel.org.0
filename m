Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C14672B65C
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbjFLE1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjFLE1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:27:02 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2059.outbound.protection.outlook.com [40.107.212.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F6510A;
        Sun, 11 Jun 2023 21:26:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIG4ldRGetGcHHgn5DhjUD5JrTINL0kA4DtdJ7uu4HR58y1LBpLx/BFHt5N6zhbimhS1Prw1I6tKam6nKylAEgh6QcVnEqeEPisJoJYMPzNzmZ2ZD/XcyP8R8wiJi2KkmszntrUYeDNQ5ZQCmsv+v1O68PqOeYp5DbUxx0Bq2JVVWOQDC7XAT0visrLqsOiVuRr/qBAJHmZpI3Qsx+cCwGa1D9hv/GGhljAEbd672UTTmYZQzbcnlOm2n/lKenkFl1IQzB1vlRhuroQofV3dDtULaADBEf8ufTuiyIQei1jZtSwA3DOKpwhOovxNzCSWDXOLdbrgItgzO+odUVpVMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WlfUBo/FyI8IPg/IWyuoH/hWaTywD2b9n9I2Lt8R/Us=;
 b=C1B94VZchwKv3F94bOkJ1tjmpUTzydlPwl0TqTip01c/qMWaHfisWKB237bbrUGeq2ttebcxmvrqvs36DRp520gSLmX1JXnjIFhI/ZY7HCIyiD78oo1uJNR3goh3CxkznLnHQadcGldg3rcOVDTWgfA7AAAM4dV3PTwMQZEh9sq9JSsQ2CYhnEOaC/bt15ZgpK0vQOap2/VnaXntLFVKTNcd7GNkknTmp4aD/hWmkQ+0vhwh/v7FS8HjDvWfT3KvP9uuoeqYs7vLZJQbbjMHUbXbFbSW3wXE6NDc/f9fM+xT7asluv5CH8iydSRIzEhzGGFcNt8Jq2SA55zwSRdULg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlfUBo/FyI8IPg/IWyuoH/hWaTywD2b9n9I2Lt8R/Us=;
 b=KZfhxEGHUCpzZv5AZWYn3o5O0rij1zTtcu2i4BA5BqMbWhvNygQqG8lylRaiGSdx0vav4dk6wOVOjd/mOnady979WlJu7+/OVxCz8EMJL0obXb9LI7JZ/YZT0gnXHvV+HAcUje+6qvEMEA4VBjC9vcnNMDN1dPAEAlnhhI5tjxU=
Received: from MW2PR16CA0025.namprd16.prod.outlook.com (2603:10b6:907::38) by
 CYYPR12MB8701.namprd12.prod.outlook.com (2603:10b6:930:bf::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Mon, 12 Jun 2023 04:26:53 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:907:0:cafe::f8) by MW2PR16CA0025.outlook.office365.com
 (2603:10b6:907::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:26:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:26:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:26:51 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 09/51] x86/sev: Add RMP entry lookup helpers
Date:   Sun, 11 Jun 2023 23:25:17 -0500
Message-ID: <20230612042559.375660-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|CYYPR12MB8701:EE_
X-MS-Office365-Filtering-Correlation-Id: 280b3df5-4843-4484-af1c-08db6afd3fa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DQ826GZCtXMQmsxLj56srWSPkfqaN/BwIjmcqprxu/9TitlM1EnxxLdZ+Y0wVs1CkN2Hh90DoOcRGd8bsohMzUeSE4yTSPDz0ZTWwICEOA6jfG8/LuKq4lJGiSz5DdVo7qWY0xUP3gnPZ/hc0/UiPTV7etC3pdCa0KKOVD7VgBMi+1xN/YbGjNbkTWYQdd3aK3MJyqzKly77zGebHzESoTLUSL+NMAhy068J2leiQxXVgri9BtCeujf1y4CHsCPWiBRNX8WhAiNM2+8ImUOVJ6esEcuVUqTpjVWHruLjEtRkx4luX/dwl52tXHqdNFprwidKy475hsnEjHUnV6TPYyjHjiwhCZifVLqSeVAc+kxEKLSRmG9BhTounJEycTNPloHW1LeEuDesRbUV+5KOQgzn6W5Xzny8UIJm2oYBenz6j6mO4d5HXhu0Iok7LMDa+/7+XINUazJdATlbSKpjRMH4ikISkNlia2HVHnZm0xNeL9c2PqflRJv5hQeS+7xHkT/WLf1xden8OMwuo2L0/E+3YeF3fddy6hvYJRCoDE4ZXcvld+PZlmTAuGlt5k1Rg0D6KqXToKpvqw439zNfgfr3QNtbTq/xdgbjielwQ7Yt9A1QZYCmIwFHIxGaeyuKYmPcviXD7Kx4bkRGLp8G2X8fv/Y4mR+awrtRcmaAxnndFBmnSeypffoSrEdphccNfcCrK4QF8r+NfoCyXCqcTCKQKbXebGmqPeJQijt9P5Ypst2LwTGgS7Rd1IBVK8CYlBnzMVHsasGyhPgOEqEh3oXdy5nwUlxAD9ibKbkk3CY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199021)(40470700004)(36840700001)(46966006)(7406005)(5660300002)(7416002)(47076005)(8936002)(2906002)(8676002)(41300700001)(83380400001)(336012)(36860700001)(44832011)(426003)(82740400003)(356005)(81166007)(6916009)(70206006)(82310400005)(316002)(2616005)(70586007)(40460700003)(4326008)(186003)(16526019)(40480700001)(26005)(86362001)(1076003)(54906003)(966005)(478600001)(36756003)(6666004)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:26:52.8260
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 280b3df5-4843-4484-af1c-08db6afd3fa0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8701
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
entry for a given page. The RMP entry format is documented in AMD PPR, see
https://bugzilla.kernel.org/attachment.cgi?id=296015.

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
[mdr: separate 'assigned' indicator from return code]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/coco/sev/host.c          | 85 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/sev-common.h |  4 ++
 arch/x86/include/asm/sev-host.h   | 22 ++++++++
 arch/x86/include/asm/sev.h        |  3 --
 4 files changed, 111 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/sev-host.h

diff --git a/arch/x86/coco/sev/host.c b/arch/x86/coco/sev/host.c
index 6907ce887b23..0cc5a6d11b25 100644
--- a/arch/x86/coco/sev/host.c
+++ b/arch/x86/coco/sev/host.c
@@ -30,11 +30,36 @@
 #include <asm/cmdline.h>
 #include <asm/iommu.h>
 
+/*
+ * The RMP entry format is not architectural. The format is defined in PPR
+ * Family 19h Model 01h, Rev B1 processor.
+ */
+struct rmpentry {
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
+} __packed;
+
 /*
  * The first 16KB from the RMP_BASE is used by the processor for the
  * bookkeeping, the range needs to be added during the RMP entry lookup.
  */
 #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
+#define RMPENTRY_SHIFT			8
+#define rmptable_page_offset(x)	(RMPTABLE_CPU_BOOKKEEPING_SZ +		\
+				 (((unsigned long)x) >> RMPENTRY_SHIFT))
 
 static unsigned long rmptable_start __ro_after_init;
 static unsigned long rmptable_end __ro_after_init;
@@ -210,3 +235,63 @@ static int __init snp_rmptable_init(void)
  * the page(s) used for DMA are hypervisor owned.
  */
 fs_initcall(snp_rmptable_init);
+
+static inline unsigned int rmpentry_assigned(const struct rmpentry *e)
+{
+	return e->info.assigned;
+}
+
+static inline unsigned int rmpentry_pagesize(const struct rmpentry *e)
+{
+	return e->info.pagesize;
+}
+
+static int rmptable_entry(unsigned long paddr, struct rmpentry *entry)
+{
+	unsigned long vaddr;
+
+	vaddr = rmptable_start + rmptable_page_offset(paddr);
+	if (unlikely(vaddr > rmptable_end))
+		return -EFAULT;
+
+	*entry = *(struct rmpentry *)vaddr;
+
+	return 0;
+}
+
+static int __snp_lookup_rmpentry(u64 pfn, struct rmpentry *entry, int *level)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	struct rmpentry large_entry;
+	int ret;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	ret = rmptable_entry(paddr, entry);
+	if (ret)
+		return ret;
+
+	/* Read a large RMP entry to get the correct page level used in RMP entry. */
+	ret = rmptable_entry(paddr & PMD_MASK, &large_entry);
+	if (ret)
+		return ret;
+
+	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(&large_entry));
+
+	return 0;
+}
+
+int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
+{
+	struct rmpentry e;
+	int ret;
+
+	ret = __snp_lookup_rmpentry(pfn, &e, level);
+	if (ret)
+		return ret;
+
+	*assigned = !!rmpentry_assigned(&e);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b8357d6ecd47..bf0378136289 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -171,4 +171,8 @@ struct snp_psc_desc {
 #define GHCB_ERR_INVALID_INPUT		5
 #define GHCB_ERR_INVALID_EVENT		6
 
+/* RMP page size */
+#define RMP_PG_SIZE_4K			0
+#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+
 #endif
diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
new file mode 100644
index 000000000000..30d47e20081d
--- /dev/null
+++ b/arch/x86/include/asm/sev-host.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AMD SVM-SEV Host Support.
+ *
+ * Copyright (C) 2023 Advanced Micro Devices, Inc.
+ *
+ * Author: Ashish Kalra <ashish.kalra@amd.com>
+ *
+ */
+
+#ifndef __ASM_X86_SEV_HOST_H
+#define __ASM_X86_SEV_HOST_H
+
+#include <asm/sev-common.h>
+
+#ifdef CONFIG_KVM_AMD_SEV
+int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
+#else
+static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return 0; }
+#endif
+
+#endif
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index d34c46db7dd1..446fc7a9f7b0 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -81,9 +81,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 /* Software defined (when rFlags.CF = 1) */
 #define PVALIDATE_FAIL_NOUPDATE		255
 
-/* RMP page size */
-#define RMP_PG_SIZE_4K			0
-
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
 /* SNP Guest message request */
-- 
2.25.1

