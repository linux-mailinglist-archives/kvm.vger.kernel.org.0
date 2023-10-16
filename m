Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9EB7CA967
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbjJPNaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbjJPNaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:30:22 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2069.outbound.protection.outlook.com [40.107.212.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966A8AD;
        Mon, 16 Oct 2023 06:30:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYpQMrW4zcE5x1Xc0Z5lci7we+lq8y33FQKSpm20V2GvNW7jlPttw9VKCfuuJ1aCfRZUL2Gn1BfUtleAVzPLxeUwOjk894Cw/sgtqEn0wGA2HHw0Ml7zSpcgme0smbN+PoVrnEBKEmxnMlwgaRv97QfZhrPwD02YP9p9qkldX9/ukU+jVvmKkexsj6Iy6+g7DcXwiHf2Kd+o0f0JxZEiSOwSY76Kd9ru7DZlsj4zyUAxwHgjAdxNhfMKjqkJUnw3bC+cl8q/Vq7ZAqFTntAN8EkH7mrSoFrQbatJGjc0kTEUd37W69pwZu8s6SPQh8cnQNIcVW/1DlmwWcGYc8bI7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1+y3wfu/XrPWjk6IeufF6Nsc1TJN1LoCddCx5qbXng=;
 b=GIY5CYNDckwvsJEyz2LEODUWkKZlyZUId+WB7YWc5hOuIl0RBRzbZw6tlFXmNL6ajOMI15HERBrCYk2qK8se6ZqlPExCp1WzRjp8ncRUX2Tdwktez8OOlBoHQHSjrY+Im0fmzGee15RSNbxxZvTamjOtSW5MO8toeKc0f5kGvHqgKpZVysExQSVvysP6wNB7FoC6+O2DyRyb8oV2l29KoQr2UMeT2laYPI6ZozClUmA8sMF3VlsPmy8cedUfHHOWx86tMIBs0ZiToub//GYYD2cLbIuo7V+HNdudUsu/jJnlMuGSNJXQDvbPExHkTos1vh5qJcy9ap5hBZSvwNgnpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1+y3wfu/XrPWjk6IeufF6Nsc1TJN1LoCddCx5qbXng=;
 b=Z1d+UQoSClFfkvJ987QxE0Ou5hucEf6bisC7lfAjcEGIVy7J513EUZpqEot/0u8lwxBD2CiattwQqRSEcuXk75eI9EOu5U4xv49PKmfSLM2XWZoWRLFLL14xMoSZa+gkrxMg8ivWqL6IwWVqlmxV/i9NC71omStqlYgNvugBc8A=
Received: from CYXPR03CA0054.namprd03.prod.outlook.com (2603:10b6:930:d1::24)
 by BY5PR12MB5512.namprd12.prod.outlook.com (2603:10b6:a03:1df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:30:15 +0000
Received: from CY4PEPF0000E9D8.namprd05.prod.outlook.com
 (2603:10b6:930:d1:cafe::1a) by CYXPR03CA0054.outlook.office365.com
 (2603:10b6:930:d1::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Mon, 16 Oct 2023 13:30:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D8.mail.protection.outlook.com (10.167.241.83) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:30:14 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:30:13 -0500
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
Subject: [PATCH v10 11/50] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date:   Mon, 16 Oct 2023 08:27:40 -0500
Message-ID: <20231016132819.1002933-12-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D8:EE_|BY5PR12MB5512:EE_
X-MS-Office365-Filtering-Correlation-Id: 52558e21-ba98-4b01-ddea-08dbce4c0805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cpW8BjRbu9BRGw8TUleBq2S+6bo1mfCs6/VBy63cNzF5RIiL+o8h1lYVxkPrXlqseyi+cuaNH+7TnIt/iZ5/nREUZz/7zNNHrQTYWnCIUgKfAuLGUsQZ2rx34rrarBG2hF1QiQMMmiPpwdNuNEr5VCxCQ9BlqbpSHOKS6x88+fYJDPSMzsQTLiz7D/TozEZXatTVnlJIYVlji5wj3p45IdDOud5NU0iapewNMhx/Jn9l4JyTUfyoTBe1i2koF320fDT4RDMIKTg0TKLfIqlRKCO5PpQ+PbRPEACo7DA9OLE356B1iPUy4is0SQuBHXV5dJ2iwm/UmzVMCwy6WSPBQ2NRr5Mo1ah2O6cshmj7mIYpduFogVH+RVV0vsVW917vThvxUSVGh+0xj4Z1NJIJXMdpuTIGqQyyrfzmJmR5N2RYEs3GTAj5vgj6ScK2B/yudbUxg7IZ8ID8b3YkM1AgQyuX6i0Ry1dySDw3VH6pJmNnO7ZiA6BBFCvxB1ikBhXVdnzHac3CIIL+HoGelE5lyjKjKz3CPBgazjxz9r83ycYYDx0dZeDXoBmxjeuG4XAQ0FzameYnWD2DQPnd6f3VPU8AFSh0EaRJHWHnO/ik5g5mU+1rlJDULy6nG3C+Eni2utnvh4P2Vl9VA5yHDuleVxhmU7Td4WcXSpevWXay281fgGiK960gIUU0VtL09iVjc7ZpW6R9R9HGW9Oo2KsHqhombxWm1NkiJGCsW94WV+RPXHYkVU44GkilZcWDPBZKlzksPtraE1EAEkkhrQoKxg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(82310400011)(1800799009)(186009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(70206006)(70586007)(2616005)(6916009)(54906003)(478600001)(316002)(7406005)(426003)(1076003)(336012)(26005)(16526019)(5660300002)(8676002)(8936002)(4326008)(44832011)(2906002)(7416002)(41300700001)(86362001)(6666004)(36756003)(82740400003)(356005)(47076005)(83380400001)(36860700001)(81166007)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:30:14.9245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52558e21-ba98-4b01-ddea-08dbce4c0805
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5512
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
 arch/x86/include/asm/sev-common.h | 14 +++++
 arch/x86/include/asm/sev-host.h   | 10 ++++
 arch/x86/virt/svm/sev.c           | 89 +++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 1e6fb93d8ab0..93ec8c12c91d 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -173,8 +173,22 @@ struct snp_psc_desc {
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
index bb06c57f2909..1df989411334 100644
--- a/arch/x86/include/asm/sev-host.h
+++ b/arch/x86/include/asm/sev-host.h
@@ -16,9 +16,19 @@
 #ifdef CONFIG_KVM_AMD_SEV
 int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
 void sev_dump_hva_rmpentry(unsigned long address);
+int psmash(u64 pfn);
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
+int rmp_make_shared(u64 pfn, enum pg_level level);
 #else
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENXIO; }
 static inline void sev_dump_hva_rmpentry(unsigned long address) {}
+static inline int psmash(u64 pfn) { return -ENXIO; }
+static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
+				   bool immutable)
+{
+	return -ENXIO;
+}
+static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENXIO; }
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index cac3e311c38f..24a695af13a5 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -367,3 +367,92 @@ void sev_dump_hva_rmpentry(unsigned long hva)
 	sev_dump_rmpentry(pte_pfn(*pte));
 }
 EXPORT_SYMBOL_GPL(sev_dump_hva_rmpentry);
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
+	memset(&val, 0, sizeof(val));
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_shared);
-- 
2.25.1

