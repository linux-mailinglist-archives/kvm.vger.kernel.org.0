Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A4A69D2F3
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjBTSop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjBTSom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:44:42 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7911E2A5;
        Mon, 20 Feb 2023 10:44:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCbQyQqF6a+KBoc1ykyWOG211hV4H1ndN41W5pOqJhLBIJj6eRHSsR04flIYPylO/dH8yvVutktMGxE8cG/lpS0/RXW5ZLtrEPhIp56xbrVdvW6cjF6UHUZ0XD+ozhI+L05ep0h/AW+UIjEI8rDYeMNl+qRxc2dnGlKAh3JcsJClwUc1sXZu+/tpuV1UhXUC0xYBE7igXwUrPL3kifs6zNlDy9M+2/5hI/bm05g3Bp74vCKZwI/0/DMbkgm5mi1+IopHI2+BuBRERJjh4QfYJIBglpZIfogo7O0aYOEEpR0atZlx3tzXMf9sJG/ubkqq4vqhAlZQHTdXPXvQudbJVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PyENLFIa0rQ2Wtg5Iei7J7RXR143JffNAsYZ2SlRxIs=;
 b=OlSQvEO93n80019jyLJ6lYtZ0urD31oAprmPIT1xD+nJqwYoB+TblLlez4xh72+Zb99WzUhW75ZMx37hM204CINgwE8U/K5BKY7wvAocoHrzQ8mOv8+C4ibMQyON2cKsjjQatu8DpA9BRBUsHCFGGp/EbfAC+h47LG/ZwD/kNFPZE7sXAebaFJqZY2sLTDF3/eRAqMnsBpzo0LWnb6F1qLrDlsQagH4TJ7gKacL+AEhU6p+qt+RTPs7S0/e2Nd2jC3GpTC/1Gkvjz9EjFvwwRLlE64nC+f4VxOkSu/zboOEdRhmehTZ3UWALlv6a/tbNDE7SspREjiOnRi4OfqqUEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PyENLFIa0rQ2Wtg5Iei7J7RXR143JffNAsYZ2SlRxIs=;
 b=lM6emfzzp7OKNY/Jwv5svpD1nZMjgdkGKkRU8LndYmpk/iOnhCWj3YklsH6+c1wdN6avC/oggMd22ZNBFD96xtsyY3R6woDN4lMHsWagCmd3l1XEsErb5yVMCK/OEHvrn+WIzKjeE0J9Vu3Pmvfz4Bns9/z1v21KMY4q9c4msA0=
Received: from DS7PR03CA0055.namprd03.prod.outlook.com (2603:10b6:5:3b5::30)
 by DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:44:35 +0000
Received: from DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::f8) by DS7PR03CA0055.outlook.office365.com
 (2603:10b6:5:3b5::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:44:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT101.mail.protection.outlook.com (10.13.172.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 18:44:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:44:34 -0600
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
Subject: [PATCH RFC v8 12/56] x86/sev: Add RMP entry lookup helpers
Date:   Mon, 20 Feb 2023 12:38:03 -0600
Message-ID: <20230220183847.59159-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT101:EE_|DM6PR12MB4140:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f06a04f-cc09-473b-2865-08db1372838b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFT2kjw0bm+eGlPQP6oylLpv4iMAnT9m2wHTjNcei05ZfJv7vE5JVZqFywn7rVQ7JsLC4eV/5dUpriH5H2K6B91tqgUL2ArSxHcIZczA1GmvGMYKDglmHUVJBqPGecusMHGN2LbTMKQAGiNla6joXWmMB3o8GGBWt67YBdND94cVBdNaisSTz2YdFfifvdbLKCbciEAwY8euRLm7KUwxfkNvM9jc0MtZSuVGP4ZDpR/4Jky/AUpqJq041PLApaW6GOftJBG2UjY6q14/06bwY68+YBaiGD78gDq2MZriuaNtF5WZpVW/hpi7RKjdZ0UN+IPU2NLlOURh6d06s7fpZAAARomx9e5UE1O9a/TjhyhWIuJQFIrQdw6a5bo2jDIRDM6kwfBQLiNG3hJC/QN/g/g2XNe529MXDND4ujrhE6ctVlo3QsrZavsvOpv7uXRFV/jpLCIFxhjyNw3aOdZbGcvLqPC+4QvEDizrDBXC4n43SGV/TZzpCLBEjAKIYfU8BrLM9aFTYkwxfMg4K3wVYnYfKORgVjlCAvv/0ONtfX1gUL/edbu1E6OIrV9kqlkWaFBLR8vyOWuKxigTHf9AzDyu3iCiHJ/xCXAgos+bIHoTnuPF2m5gTyQUCRpOmqrNXE0SKzdFU3yq5nDIpsHvlL1oMk0RREqkl7zqdnbMeTUHhAGy8cSSzVFZlKxPliuNrkJ83MjNB6sp+IEmqLpIBzcN0huK1L7nEF7GRLMNl89UDKOVF5Zyeh+8MM2rHkJX
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(70206006)(4326008)(70586007)(6916009)(8676002)(316002)(7416002)(54906003)(44832011)(966005)(8936002)(41300700001)(5660300002)(356005)(40460700003)(36756003)(86362001)(478600001)(26005)(16526019)(1076003)(186003)(6666004)(47076005)(426003)(2616005)(336012)(7406005)(2906002)(82310400005)(81166007)(82740400003)(40480700001)(36860700001)(83380400001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:44:35.6410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f06a04f-cc09-473b-2865-08db1372838b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4140
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

The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
entry for a given page. The RMP entry format is documented in AMD PPR, see
https://bugzilla.kernel.org/attachment.cgi?id=296015.

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h |  4 +-
 arch/x86/kernel/sev.c      | 84 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index ebc271bb6d8e..8d3ce2ad27da 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -83,7 +83,7 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
-
+#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
 /* SNP Guest message request */
@@ -197,6 +197,7 @@ void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
+int snp_lookup_rmpentry(u64 pfn, int *level);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -221,6 +222,7 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
 {
 	return -ENOTTY;
 }
+static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index e54e412c9916..a063c1b98034 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -61,11 +61,36 @@
 #define AP_INIT_CR0_DEFAULT		0x60000010
 #define AP_INIT_MXCSR_DEFAULT		0x1f80
 
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
+#define rmptable_page_offset(x)	(RMPTABLE_CPU_BOOKKEEPING_SZ + \
+				 (((unsigned long)x) >> RMPENTRY_SHIFT))
 
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
@@ -2435,3 +2460,62 @@ static int __init snp_host_init(void)
  * the page(s) used for DMA are hypervisor owned.
  */
 fs_initcall(snp_host_init);
+
+static inline unsigned int rmpentry_assigned(struct rmpentry *e)
+{
+	return e->info.assigned;
+}
+
+static inline unsigned int rmpentry_pagesize(struct rmpentry *e)
+{
+	return e->info.pagesize;
+}
+
+static struct rmpentry *rmptable_entry(unsigned long paddr)
+{
+	unsigned long vaddr;
+
+	vaddr = rmptable_start + rmptable_page_offset(paddr);
+	if (unlikely(vaddr > rmptable_end))
+		return ERR_PTR(-EFAULT);
+
+	return (struct rmpentry *)vaddr;
+}
+
+static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	struct rmpentry *entry, *large_entry;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return ERR_PTR(-ENXIO);
+
+	if (!pfn_valid(pfn))
+		return ERR_PTR(-EINVAL);
+
+	entry = rmptable_entry(paddr);
+	if (IS_ERR(entry))
+		return entry;
+
+	/* Read a large RMP entry to get the correct page level used in RMP entry. */
+	large_entry = rmptable_entry(paddr & PMD_MASK);
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
-- 
2.25.1

