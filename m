Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF1F64D04D
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbiLNTuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbiLNTtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:49:42 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A902B60F;
        Wed, 14 Dec 2022 11:49:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cn2Ae1LQU+Vn0XFK4F8HLBvNwEmLCNFvi0LYNUAmLLvWMYNWBHXEoB2/YrDHOqjhKuWt0lzIuytTi4UfoeEjs29+YMZb6Krd/MIb4hr2A/CIEL7qpReFg2zs+8kZJNvlcQXycss+Ne8UJ7hrAu/Mg3S5++zUn5QBK9arI4FVP9Wfgk1IkM4fVTWz07kSKA7oEzvr46RoCrv5Hk7funmCcFT4/czBn405qmALaQaS9xcWeq7Z2BwSrr1fU2Sh/0BSRdesbuf3r6ZEnfJActdJbxcUNf6dg2/pnxzcje4JfgTXbaHID/XhRGFZGO9zWR1TfX1/w9tof0qcqLrpbLB9Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7kNHsOKDKxIu0jjw+KLsxb4fgN6qewANaORLbviVCg=;
 b=Av/qiHeJwhZWwrHzhL9Ge+Ywc6A3oNstkxHmr+4/gkHYVFcZOh4yJODi5J3u01pjl5AW1JBBORG3G6ISdpvJb+mukOjeSSL1KNNlv8DvNllYXURQpzs0KBYuIzefpiQrPOkr5kmBrBkIs4+Y1EVHBJzq9dGlnEJkYHOkK+YOmQaBCGVkht8tsN34cCKchcnUgC1JO7e14Q0TbsFguCHw13Sn3WjwuUT5WF9D+tVSTpaaxk4WTV7y4717/WLuBJsksmMjH2r7hm39xGplj61RoCJ1GHBuSh9AGVRSm/YD+aECCliBe4xiMFhmo+CWMpTRqjDCOxOWkipfq+RhGibseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7kNHsOKDKxIu0jjw+KLsxb4fgN6qewANaORLbviVCg=;
 b=dwSrjTpTD+cncx+8Ct5UUL6oBw46pwSq8dFaui46Ghbu9QPCUZnuoAN6t0w/wVTKuzIPlQHQy+GvtiXirB1UHfZOrIISpzenYHU5e5YF5j4RDoMX/Ef/fL4OxDMF1YKMgtLLdxoN8logvs/7ELP1/IietOWFq+FMT93VGUjyDJo=
Received: from CY5PR20CA0012.namprd20.prod.outlook.com (2603:10b6:930:3::16)
 by DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:49:11 +0000
Received: from CY4PEPF0000C97A.namprd02.prod.outlook.com
 (2603:10b6:930:3:cafe::54) by CY5PR20CA0012.outlook.office365.com
 (2603:10b6:930:3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:49:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C97A.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:49:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:49:10 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 15/64] x86/sev: Add RMP entry lookup helpers
Date:   Wed, 14 Dec 2022 13:40:07 -0600
Message-ID: <20221214194056.161492-16-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97A:EE_|DM6PR12MB5520:EE_
X-MS-Office365-Filtering-Correlation-Id: 60d16971-69c7-42f6-d3d9-08dade0c458e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +t2pWl4C43ruuLfvcGn2WkSW+Sz3bUyHw0fA+f7PF6R1xtG9xlHDPclQ4h7P0jqe5T++ae2Mh190din6M+TyrosQnYuvO0UjHwv9LnC9AtzS9FSZNbGzP/p0OiZpDoJczrE1MCR2JWuG6b4E2ZeWNcidUVh5luJZ/ydbe0Z8Yoenk95KaIO1zg4ysMKeGtYasQ3MUVLudJPCX2LVTaMy2B/JI2+BpF/F3VhaeTUjQB+IAE6EsnzHbJD/3wVo00IW0LxpY3k2tmhOzQD4CRTnt35a/QgzDXMcd+mRpxjoK34/fjTkFPpyahHO9rY6s1W32d+J2MKWGuvHQtTEaY2mwTW7NF2D/DGlWyGCADpdvjd8ugC/zlPp2P5eQNGHwOef1qWulLpuWo36vc9Vdi66F77BxkVABZc3czxC7wFOmPOE3xRb+KFsR1RrDCyxW7i2BvK+ZxrEBn8Zb35r+McB9T662+JJ8cDmkhvUIeUSav5WsSTWmHDe06/VooLERkQAVJGkodWENp157EsEMfra0Y7WQtCIhPexcgovZbB2v5VkaBDK6ZpA4JuOpEgqC8le9ThQWmsDLGigctp5MimI9S6tpO2zO6nfi5ACdlaXiL4zjZI7KVFehEdwGxw4wZWvdYZ1iZ0boOjp6RE8oKEo6/3ghlz1ej+dYYjw/1HOMjuUTtdm7NpE2NgxaTu1/sFvLG/4tPhIhnO1BfeD930Hsymo1i4XenETTRqKfb9KkzuJlipKW/t0Lyg0o9qMTt1WBiCMAGMPDvMiadFqgm2NPM6B322JRG66ncP36u5nP+E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199015)(40470700004)(46966006)(36840700001)(86362001)(83380400001)(40480700001)(36860700001)(316002)(356005)(81166007)(54906003)(82740400003)(7406005)(6916009)(70206006)(70586007)(8676002)(336012)(7416002)(6666004)(2906002)(1076003)(82310400005)(5660300002)(44832011)(2616005)(26005)(47076005)(8936002)(16526019)(41300700001)(426003)(186003)(4326008)(478600001)(966005)(40460700003)(36756003)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:49:11.3214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d16971-69c7-42f6-d3d9-08dade0c458e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5520
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The snp_lookup_rmpentry() can be used by the host to read the RMP entry
for a given page. The RMP entry format is documented in AMD PPR, see
https://bugzilla.kernel.org/attachment.cgi?id=296015.

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h |  4 +-
 arch/x86/kernel/sev.c      | 83 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 1 deletion(-)

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
index 687a91284506..706675561f49 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -61,11 +61,35 @@
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
+#define rmptable_page_offset(x)	(RMPTABLE_CPU_BOOKKEEPING_SZ + (((unsigned long)x) >> RMPENTRY_SHIFT))
 
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
@@ -2440,3 +2464,62 @@ static int __init snp_rmptable_init(void)
  * the page(s) used for DMA are hypervisor owned.
  */
 fs_initcall(snp_rmptable_init);
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

