Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFAD69D2FE
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbjBTSpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBTSpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:45:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927021E29E;
        Mon, 20 Feb 2023 10:45:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7HWQHHJW/IMSA6hEFRJzptrlKZhPrVs7NOyo4oVnw5kC0nxz0Vs519oN6Qj0p/cmGOB3DPHbDndak9CoHVHhyCWQGRaMt9Cczq/VsGlHAyj86ZApAJaY8w484grokDpfBO5n5kzEzV5f6dVQ0g5CsS6ahwp7G3v55Cqtj0Hthh9WZDz9xi/HE/hHthjPytXiQ20m5L5L25h+bwDeSqLuu8wK5z7uBkNOZvyNdaU/9fs3sugcHen865auZpVHhZZeXsk3CQvna4OMe98acj0ePX6wWYebJ5AoK2A0OjtE8nKxZAFFQSrMga5QaeSIXpmMWdvVoTG0daGtEzeRWQnqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6j+nSgs/DGvg/kRPK1aMPVbYjA2l54XSMEcjve6IfB0=;
 b=V6N4qiYCoAUXvq9vc7Lw2gKq0Pao0XA9ykOtxb3GFpSx6PzoqkAD+609O5AuDRD/E9JTxRJU6uYcU8ZIVAVuAtLiqQjboMMQ6qcoUvcL6bzipshGlsyCsJ/iSOwF4vIsUzAVbB8eg0NBmhAqhk0jeTEZ7sRpm8YbF8wtCRbPfw/fk7dJ0i3s/Y6pKrhIrjBS3w2xo+NZaYL4JQOC7aljNYl/+IB15kVNs/IquvqYisk8UHXV9kKRwRWUmj2TbChljaWvflE0KDi05MBykQefsmus19o7SXwgJ6d/xmf0QIQjz7n/n2OxC8NYetNYeRXVVxiMsl5DPUDi/VrxIVyzGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j+nSgs/DGvg/kRPK1aMPVbYjA2l54XSMEcjve6IfB0=;
 b=S8f43poqY6Nyp6QnkCEQYzf8yFPtylMKIqDNjT0+BY1i/EZGom4RVwMioH+Im+cOPwMD3i09QEGCIwZ9ezp2kGBQBOWb27C7z2/uYQ3QtGhlELX2GzSJkxTuBcTEvcPp1nZvNHx1O3oXrR4tcPVz+4kgC7GBLeRh6twPIGCojsI=
Received: from CY8PR22CA0006.namprd22.prod.outlook.com (2603:10b6:930:45::10)
 by DM6PR12MB4548.namprd12.prod.outlook.com (2603:10b6:5:2a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:45:17 +0000
Received: from CY4PEPF0000C968.namprd02.prod.outlook.com
 (2603:10b6:930:45:cafe::d8) by CY8PR22CA0006.outlook.office365.com
 (2603:10b6:930:45::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:45:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C968.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:45:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:45:16 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 14/56] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date:   Mon, 20 Feb 2023 12:38:05 -0600
Message-ID: <20230220183847.59159-15-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C968:EE_|DM6PR12MB4548:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c7b35f8-8bbb-4c44-7e6d-08db13729ca6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fVXsoiXv4t1w41x5qa0C7Di15m7ZevA1abEVi1IH48Myl98XNk4RHw9YlY8o+yKPDuCPMTKeRK35yGzKZK8hvV+BOWzuCb3wlpI8LOaLFTtRIb5iRJc9kH9srYpPL2F5tmNGMyWw+s9IfoNuryac4kPI33Df3mbwTuErbIiJQrVGofmO7Ef+25VZhgekoQwgtVMuz2JnY72cyuLnHMGtX4wSDCxaz4LY04EM6v9LUj0Ag8G+zlAseKtK7BnCug9GHwfSNHtLBUy6pfN+8pgyMxx/ZBhMDzrOCVhLm5Za/uSvwaF1/moWst0Zk3R5eobQ2MtOem0rKrUXhyr34uX02KwePqvBP/cC8RWXgSz1JHIhASujdmDiZ1A0edqkLe/WKA+CT7o+msWXza9x4WFBOHY0RBAbHsfofTlRG3jVMA/ypNvClqSkeSqLByGBwgt8HKnu0DsqXMr84ineVxlUiTGkJAXb8o0COenPLr+xoAMSGi1DGGx47ThoHAAoEbYyEZTmy92YTbZip9n7BmjADB+Mp+wk585AzzXXMWz2PWr+SY3Ii4F8jk4NbijgguY1v4NdE7SSLvutRmpEVIBJ1SzjxzuHrBajQxXyiRcRr/PSFvSyeiX5vLOKRhNPHJ4K0D0d23PTu48d1iZhQpSMY2WWEcbdr/SElAkH+a9bl+JE+6pSDfK+9pyNepGl4gHvKFTYmj1RBjikbRgzXvtdMhFs09NcaotK9RowmzjnJk2Ad3KTbYb1ITvK/PZ9+wdFrGxzT7fcwpnFdsZZ3H006A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(5660300002)(7406005)(7416002)(36860700001)(44832011)(82310400005)(82740400003)(86362001)(2906002)(81166007)(478600001)(356005)(336012)(16526019)(47076005)(426003)(186003)(26005)(36756003)(40480700001)(70586007)(54906003)(40460700003)(316002)(70206006)(2616005)(6666004)(6916009)(1076003)(83380400001)(4326008)(41300700001)(8936002)(8676002)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:45:17.7319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c7b35f8-8bbb-4c44-7e6d-08db13729ca6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C968.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4548
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
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
 arch/x86/include/asm/sev.h |  24 +++++++++
 arch/x86/kernel/sev.c      | 108 +++++++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index edbb7fa488af..7d728b30319c 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -80,10 +80,15 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
 /* Software defined (when rFlags.CF = 1) */
 #define PVALIDATE_FAIL_NOUPDATE		255
+/* RMUPDATE detected 4K page and 2MB page overlap. */
+#define RMPUPDATE_FAIL_OVERLAP		7
 
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
+#define RMP_PG_SIZE_2M			1
 #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
+
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
 /* SNP Guest message request */
@@ -133,6 +138,15 @@ struct snp_secrets_page_layout {
 	u8 rsvd3[3840];
 } __packed;
 
+struct rmp_state {
+	u64 gpa;
+	u8 assigned;
+	u8 pagesize;
+	u8 immutable;
+	u8 rsvd;
+	u32 asid;
+} __packed;
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern struct static_key_false sev_es_enable_key;
 extern void __sev_es_ist_enter(struct pt_regs *regs);
@@ -199,6 +213,9 @@ void __init __noreturn snp_abort(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
 int snp_lookup_rmpentry(u64 pfn, int *level);
 void sev_dump_rmpentry(u64 pfn);
+int psmash(u64 pfn);
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
+int rmp_make_shared(u64 pfn, enum pg_level level);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -225,6 +242,13 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
 }
 static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
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
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a01741c4a1b8..a49f30c10dc1 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2567,3 +2567,111 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
 	return !!rmpentry_assigned(e);
 }
 EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
+
+/*
+ * psmash is used to smash a 2MB aligned page into 4K
+ * pages while preserving the Validated bit in the RMP.
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
+	int max_attempts = 4 * num_present_cpus();
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
+		if (ret)
+			pr_debug("RMPUPDATE retry needed, ASID: %d, ret: %d, pfn: %llx, npages: %d, level: %d, assigned: %d, attempts: %d (max: %d)\n",
+				 ret, val->asid, pfn, npages, level, val->assigned,
+				 attempts, max_attempts);
+	} while (ret && attempts < max_attempts);
+
+	if (ret) {
+		pr_err("RMPUPDATE failed after %d attempts, ret: %d, pfn: %llx, npages: %d, level: %d\n",
+		       attempts, ret, pfn, npages, level);
+		sev_dump_rmpentry(pfn);
+		dump_stack();
+		return -EFAULT;
+	} else if (attempts > 1) {
+		pr_debug("RMPUPDATE succeeded after %d attempts, ASID: %d, ret: %d, pfn: %llx, npages: %d",
+			 attempts, val->asid, ret, pfn, npages);
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
+	if (!pfn_valid(pfn))
+		return -EINVAL;
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
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	memset(&val, 0, sizeof(val));
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_shared);
-- 
2.25.1

