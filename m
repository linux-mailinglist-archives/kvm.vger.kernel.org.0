Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54F672B679
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbjFLEap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbjFLEaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:30:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0A01B7;
        Sun, 11 Jun 2023 21:30:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ON74fhmb2Z1ghvMvCk83tRfulyUCwUfEX0mIiLRJ5HOrELUXkpCmstlNptzUiuMaPizjCqDnWzHDm13IV14gEhlNr3p1gG067KsT6+hEmEN2Cnj00d7h3pJEXoPS0/O5tlFD0i54M9kJ3YKR3QISbLVyX/voxb8C0kBc61qQ7jwQL3hBWNobnRgROclpLedspwh0EP8IrEaRWa8rWnO/enZAx/vOiLptA/fHbbQg8X0is9Z+XMJg0U9Jfokq5e67R2vag9nTTF6tFnJ40G20AYRj25nWefSieb1KHsojHpmXQTEtoyAF8syTXerIxk/GD+05acuCoVysGik7x2bxYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFANIoBEvW5rShPu60LwTEesSM4XP/tF5PsDV4uYZYY=;
 b=G2rOHByURF1yvDTl6L85QhtZcek4j0tbbVmTvcz+lkabi+f31m1VMe7FAM7bANfy5qYi7H44ENWy0WvE2fPtVHPU9rMhj49upkgH9B3WdeQi0gi0yvaju8Gf3dCC8G35oEVcpJd/4f8zLSeOhgJ3purtmh4t7eD57wmX/0fk2M+rYOGn10aef+zF3veYHBHJAvFmvHy/R83mSNSvR7Mu8N/5efpqWm1jdXmEfvZtFuyh145JwHNM0q2j42CBpi7vGhzJX76Wm7yR0cRx7H3ictIOr+Djj8bAwfYvmUglVHWaCs2MYASk97dwqTAlydMOxt6j74y5kKaVfyTATMrtLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFANIoBEvW5rShPu60LwTEesSM4XP/tF5PsDV4uYZYY=;
 b=5czQLo7vQZY+/u/TtvChvGoD5d8M+8RiSVaUvU60SCNKA35fwdaExNjiUHBbJBrO2zQcu5j9XFET0KidVLGfxmJm0UlQe7P0YZp83q5NG9iBL4ebavXBSMyV1wlxnQAFwh5gYzyeYpDWWo5QjgaZLzklivau4EGMKH8Pw0UTcG8=
Received: from CY5PR16CA0016.namprd16.prod.outlook.com (2603:10b6:930:10::26)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Mon, 12 Jun
 2023 04:29:58 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:10:cafe::dd) by CY5PR16CA0016.outlook.office365.com
 (2603:10b6:930:10::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:29:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:29:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:29:57 -0500
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
Subject: [PATCH RFC v9 14/51] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date:   Sun, 11 Jun 2023 23:25:22 -0500
Message-ID: <20230612042559.375660-15-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 39ba6556-3c53-4fa1-dc99-08db6afdae0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 04MwOKBMy0hHqW72uwGFCIQAR5VZ0XGfGh13jB0YlT/VVFeD5TBEw1iJJVQCM81pyaGS2kKKNx2Bwct827AM6ESe513J7QhQBRxY38+3R1qZVDVqCOtq/qDPNbIfafwB9zhPLP/gn8rMQzOL46tpSMuvV1gVsp0IktEoIsg1Djfx7bo63PW7Z2E02znn+yMCVCnybCs1i3PQuszH7RPpFqk42flhhK+cs9jjMhpgLAxFcckSmW5nuVxLnlxHP0xke0TF6FUWzRTMb1qsi5uBcQPPKj8hvxL38aBlg8RF1P1p3SdwvtzHl6gVQKrx5NXD72YTvu6zOoUc16mQF4l+ibznEYYn1VHHBtRAdYrdRM2mC6qQ7EtSwlUW1QQwzFB4ozacij4TSDb0HsnmGKS2glp5EXfQVM0qEkdBJ79BqgJ3hc7pLjxNmAGUM7QrCTkd1X7V21hX5xEz09rXNn9s9kmgu+AdBVPxToHoOM30umP4vTeEBm8SaOF0zdatKN+2pWEgwm5uVR4bc7iXKAPPg2zjEw15aUaZU2X98NEjmWt6RKZyNW9YTyA/hDg/dNZMWDXAWgyt6x1+1DsYsIGzudux81NLzmpsLugb81r5SKahHa8PsBrSXUYZ2lJa8hEgiK+91SaA/tyWd2BUkvB0tPnLl2lH4DR8q1ACy5aYTjLrVJkIeXT8VdEbh6LGVqw0xkX1k35wHWOogPcTEBRsq2R4IePsLc2yDej7J0gssohqozPqngsQjIf9BtSok7cj9jivkRY5shtvcXnSOrmfBA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199021)(40470700004)(46966006)(36840700001)(5660300002)(7416002)(8936002)(8676002)(2906002)(70206006)(70586007)(7406005)(4326008)(54906003)(44832011)(6666004)(1076003)(26005)(316002)(6916009)(41300700001)(186003)(16526019)(36860700001)(356005)(82740400003)(426003)(336012)(47076005)(83380400001)(2616005)(40460700003)(478600001)(40480700001)(82310400005)(36756003)(86362001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:29:58.1065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39ba6556-3c53-4fa1-dc99-08db6afdae0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
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

The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
hypervisor will use the instruction to add pages to the RMP table. See
APM3 for details on the instruction operations.

The PSMASH instruction expands a 2MB RMP entry into a corresponding set
of contiguous 4KB-Page RMP entries. The hypervisor will use this
instruction to adjust the RMP entry without invalidating the previous
RMP entry.

Add the following external interface API functions:

psmash():
  Used to smash a 2MB aligned page into 4K pages while preserving the
  Validated bit in the RMP.

rmp_make_private():
  Used to assign a page to guest using the RMPUPDATE instruction.

rmp_make_shared():
  Used to transition a page to hypervisor/shared state using the
  RMPUPDATE instruction.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
[mdr: add RMPUPDATE retry logic for transient FAIL_OVERLAP errors]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/coco/sev/host.c          | 94 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/sev-common.h | 14 +++++
 arch/x86/include/asm/sev-host.h   | 10 ++++
 3 files changed, 118 insertions(+)

diff --git a/arch/x86/coco/sev/host.c b/arch/x86/coco/sev/host.c
index d766b3bc6647..9df690b0b263 100644
--- a/arch/x86/coco/sev/host.c
+++ b/arch/x86/coco/sev/host.c
@@ -338,3 +338,97 @@ void sev_dump_rmpentry(u64 pfn)
 	}
 }
 EXPORT_SYMBOL_GPL(sev_dump_rmpentry);
+
+/*
+ * PSMASH a 2MB aligned page into 4K pages in the RMP table while preserving the
+ * Validated bit.
+ */
+int psmash(u64 pfn)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret;
+
+	pr_debug("%s: PFN: 0x%llx\n", __func__, pfn);
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	/* Binutils version 2.36 supports the PSMASH mnemonic. */
+	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
+		      : "=a"(ret)
+		      : "a"(paddr)
+		      : "memory", "cc");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(psmash);
+
+static int rmpupdate(u64 pfn, struct rmp_state *val)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret, level, npages;
+	int attempts = 0;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	do {
+		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
+		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
+			     : "=a"(ret)
+			     : "a"(paddr), "c"((unsigned long)val)
+			     : "memory", "cc");
+
+		attempts++;
+	} while (ret == RMPUPDATE_FAIL_OVERLAP);
+
+	if (ret) {
+		pr_err("RMPUPDATE failed after %d attempts, ret: %d, pfn: %llx, npages: %d, level: %d\n",
+		       attempts, ret, pfn, npages, level);
+		sev_dump_rmpentry(pfn);
+		dump_stack();
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/*
+ * Assign a page to guest using the RMPUPDATE instruction.
+ */
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
+{
+	struct rmp_state val;
+
+	pr_debug("%s: GPA: 0x%llx, PFN: 0x%llx, level: %d, immutable: %d\n",
+		 __func__, gpa, pfn, level, immutable);
+
+	memset(&val, 0, sizeof(val));
+	val.assigned = 1;
+	val.asid = asid;
+	val.immutable = immutable;
+	val.gpa = gpa;
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_private);
+
+/*
+ * Transition a page to hypervisor/shared state using the RMPUPDATE instruction.
+ */
+int rmp_make_shared(u64 pfn, enum pg_level level)
+{
+	struct rmp_state val;
+
+	pr_debug("%s: PFN: 0x%llx, level: %d\n", __func__, pfn, level);
+
+	memset(&val, 0, sizeof(val));
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_shared);
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index bf0378136289..9eb20b416251 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -171,8 +171,22 @@ struct snp_psc_desc {
 #define GHCB_ERR_INVALID_INPUT		5
 #define GHCB_ERR_INVALID_EVENT		6
 
+/* RMUPDATE detected 4K page and 2MB page overlap. */
+#define RMPUPDATE_FAIL_OVERLAP		4
+
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
+#define RMP_PG_SIZE_2M			1
 #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
+
+struct rmp_state {
+	u64 gpa;
+	u8 assigned;
+	u8 pagesize;
+	u8 immutable;
+	u8 rsvd;
+	u32 asid;
+} __packed;
 
 #endif
diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
index 85cfe577155c..753e80d16433 100644
--- a/arch/x86/include/asm/sev-host.h
+++ b/arch/x86/include/asm/sev-host.h
@@ -16,9 +16,19 @@
 #ifdef CONFIG_KVM_AMD_SEV
 int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
 void sev_dump_rmpentry(u64 pfn);
+int psmash(u64 pfn);
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
+int rmp_make_shared(u64 pfn, enum pg_level level);
 #else
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return 0; }
 static inline void sev_dump_rmpentry(u64 pfn) {}
+static inline int psmash(u64 pfn) { return -ENXIO; }
+static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
+				   bool immutable)
+{
+	return -ENODEV;
+}
+static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
 #endif
 
 #endif
-- 
2.25.1

