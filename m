Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F707CAA90
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbjJPNvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjJPNu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:50:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D860A198B;
        Mon, 16 Oct 2023 06:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbAfEmYF+8YgDV+ROtzoPKEfYN89424ZPdQ+DtJhwYnra+2pPge8zZi576ANZzXDZjoTMm0u/v1SAbzucEyAHw9jCFnNpAhA5xTVrH+23F49EPkjHTvpNDogDF9BzVe6OYDXrr+GWLHTnZ7H9mKGxCS+0ao1L2uYB7JGMCDM5VmO7xJQzRm8tt17DMQI2rcHbdOoFAnGalNt0IJbLT7GIKB9vwqSN3udMmAeRDO1dGN++CuRfIlNrkNdDVKpkjzphlimYGdhMAhIhINHtjpQoD3XYe4YfxUTwxuZk0X8A7077E2DTVQys6kPF1/+5E8Fx28Hs7rK0ZP373ADIMz5WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+o0s1fiCnrdKryYp9V6EEAV3T1cs6BBbqrNpjMPuQT0=;
 b=dvM5PIiLKEx29NDKRPYmWb5fTwO6XQMKeAIqvoaHxDVs09Kx9qmgpnBJD3U5JLdPGQ0pNMNwe+jJdIwfjTt65Jm9eWVZNolX1DXVHRXF2b9Rkn51N/9Qpe1f5nnvqOoK+r1vONxer3YBib+LT8w/G+JGwzKsvahW61S9WEhOA+/tVpzHWnsq4ORYV/gOnK9FEMrb5kb0JAiFeGNottu+I/LQRC/Z1tJDXFbQcat0ilgoMFYkuydjQB6DChwr6xSTWUcSuWC4BxrgkT0RRJJOsIRKhZXHTc3Qepk+e6qHgjPOtxd/ToTTWKhSThPwmda7MSkd3QRFfKNX7HfW7Bp0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+o0s1fiCnrdKryYp9V6EEAV3T1cs6BBbqrNpjMPuQT0=;
 b=HKb+VgnCj5Hh9+T+q+ahkgJswIKX2lOOTwBVHsgzrtEowX0GSMJZhNX0SFkd1ZyRmXXL8Ie4OPFvXOQh4AJ+EBD18+jM2/pMmIq23iugnE6CvBRhLkeZFZsrK32k7wemJ2mAXNLqb8EImxlDvtK0V4f0iW7qTYkcNg3SN5fLBoo=
Received: from BL1PR13CA0149.namprd13.prod.outlook.com (2603:10b6:208:2bb::34)
 by MW4PR12MB7381.namprd12.prod.outlook.com (2603:10b6:303:219::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:49:46 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:2bb:cafe::f4) by BL1PR13CA0149.outlook.office365.com
 (2603:10b6:208:2bb::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Mon, 16 Oct 2023 13:49:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:49:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:49:45 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 07/50] x86/sev: Add RMP entry lookup helpers
Date:   Mon, 16 Oct 2023 08:27:36 -0500
Message-ID: <20231016132819.1002933-8-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|MW4PR12MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: 85a6f4ac-4dfc-4c14-746a-08dbce4ec23d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YT6g/3KhLb3PZBmdYGW/nAz+e3zuQRyv5j+/4stL0VWytWIpGx0wydcw30rX+tK7HvJx0IhFWndKLoTkDVW4O20gNb5Wte2oheJuMOhTzW7m1FaXo7/bkSv0390YblxYngsBwOak7BX01TV/3XADCcPq+xCpRy+MgfYe5YE6gu9+mpTDvCgV558K1e682nOOGpn+qtCY/v7P2MpEIzjuLvWyIR5KDII4+XrzxGtS+LGwy6ooe1aB+7xMotrdeIOAM+c52YX9Hd2/EmaZKhyGZI7SK0kzaPtkRsbfhp6zALCtYFnHikHHc7lmaSbcmbRdB7C57GxmDmsjNCiuSvbf5Fun0yxf/pPz3wSSqvZf3B3xRVHz02PL2rW0k1HcBcbOp1xnECa7Luunh4N3lFQbSvQrnwTgQlNEfpfiIVFLaBZmLKK0e32J37mDlq9oh/+fZIckEjJbc7KEmhe1rVSzumDLousQNPDdaJK/Zfifu+bMm4GOlfwsgLXJ5pJyOq3SQcWgsCV+aBOtjrdSnmJ/jLn9LxvQm/p1rpK82n37FP2PSVsVPk2CeTZGaAvOC4vWin2yDMNJbB1QgOZY69N7bgidUTnSDcUDsRCWDVW9lKidEWPLTFYGjokMLiP3rboZt3zs58E6hgZikPyGSfm5rh4ZZ+Uxzl8VNvnShY2SAtjpET1F722aWPdL0s0gWKAcCfTqnvQxjytleK/yeBPsgKFniarHnQ10ra6YdMhbD+Lo6PgTXLxfZCtkUbd0AViEWxJtNompV67HzQ1uQnUsNDzD9BKFXqApifr0lc6Pfaw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(82310400011)(1800799009)(451199024)(46966006)(40470700004)(36840700001)(478600001)(966005)(54906003)(70206006)(70586007)(6666004)(6916009)(47076005)(16526019)(26005)(1076003)(41300700001)(336012)(426003)(2616005)(8676002)(8936002)(7406005)(7416002)(2906002)(44832011)(5660300002)(316002)(36756003)(4326008)(81166007)(86362001)(356005)(36860700001)(82740400003)(40480700001)(40460700003)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:49:46.4010
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a6f4ac-4dfc-4c14-746a-08dbce4ec23d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7381
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/sev-common.h |  4 +++
 arch/x86/include/asm/sev-host.h   | 22 +++++++++++++
 arch/x86/virt/svm/sev.c           | 53 +++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)
 create mode 100644 arch/x86/include/asm/sev-host.h

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b463fcbd4b90..1e6fb93d8ab0 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -173,4 +173,8 @@ struct snp_psc_desc {
 #define GHCB_ERR_INVALID_INPUT		5
 #define GHCB_ERR_INVALID_EVENT		6
 
+/* RMP page size */
+#define RMP_PG_SIZE_4K			0
+#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+
 #endif
diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
new file mode 100644
index 000000000000..4c487ce8457f
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
+static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENXIO; }
+#endif
+
+#endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 8b9ed72489e4..7d3802605376 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -53,6 +53,9 @@ struct rmpentry {
  */
 #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
 
+/* Mask to apply to a PFN to get the first PFN of a 2MB page */
+#define PFN_PMD_MASK	(~((1ULL << (PMD_SHIFT - PAGE_SHIFT)) - 1))
+
 static struct rmpentry *rmptable_start __ro_after_init;
 static u64 rmptable_max_pfn __ro_after_init;
 
@@ -237,3 +240,53 @@ static int __init snp_rmptable_init(void)
  * the page(s) used for DMA are hypervisor owned.
  */
 fs_initcall(snp_rmptable_init);
+
+static int rmptable_entry(u64 pfn, struct rmpentry *entry)
+{
+	if (WARN_ON_ONCE(pfn > rmptable_max_pfn))
+		return -EFAULT;
+
+	*entry = rmptable_start[pfn];
+
+	return 0;
+}
+
+static int __snp_lookup_rmpentry(u64 pfn, struct rmpentry *entry, int *level)
+{
+	struct rmpentry large_entry;
+	int ret;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	ret = rmptable_entry(pfn, entry);
+	if (ret)
+		return ret;
+
+	/*
+	 * Find the authoritative RMP entry for a PFN. This can be either a 4K
+	 * RMP entry or a special large RMP entry that is authoritative for a
+	 * whole 2M area.
+	 */
+	ret = rmptable_entry(pfn & PFN_PMD_MASK, &large_entry);
+	if (ret)
+		return ret;
+
+	*level = RMP_TO_X86_PG_LEVEL(large_entry.pagesize);
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
+	*assigned = !!e.assigned;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
-- 
2.25.1

