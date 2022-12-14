Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2917F64D069
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiLNTzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239319AbiLNTyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:54:09 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423512C670;
        Wed, 14 Dec 2022 11:52:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeJrjchzstX+34F60lSkC/h/M3fnjKEnKBOdjIxBB9jdYqXqKUqNQuck8qw8hRVcSSs1pMOZu+lhEoXqkp3gmo8cYJKY/Q/Ik5GFdhlas35XFq4iAIfrHLBYVeouc/8eYQaAibGGaRimZVb/b/TPNEWIOyHn6FGpEZdUIsM02jBFIrYQmKnLmOm57tpRmcDF1oRAV/LiNcwnJkidz8gkRmrvfDrkoS648dblsskM7iBfBsj8//cz+x6twM6gdnkAT3AgwX3WC3AKT6ffs+KfaTegtIhkHoAyXz4Xjo/UwNGTeK0Fs6QBuwxZejIq2fF0YyYkTo3QVAa5h6ql9Ujiuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLx0x+amPIYqW7BaWhik7eNiLUWDfU0/h7EA7b98jRw=;
 b=aXbb15zlV5XK8J19kKciSQOtm8YAL5uVKmrujJtDaWQUJ/+KF2UxM7NM/C/UnzQyxG5bBpCS07y2SaVXsuZJLrQv9/4W5KfsCAY9RO/rr1HI31XuZL/yK+NktwxFvkp6Amumz8yEgOzbM5mBDns//+/yo60js4P3xhVeAyofKoFL+S2FmFJ/nyWBKgsaELx0PUpsh9BRgeDcRNYPpyWIQTUYwpt21XXuU1ItsiNnRXtJXjBdPeLFXyUv9ora61w6j+2Gz1KeIkKO1/aH+2sYv8CvsA1+PPD9fqMmRjzsgVHDg6JR7vPGhN6htAdLxsAWiOJQsb/sIa3Yy8WwzrL7ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLx0x+amPIYqW7BaWhik7eNiLUWDfU0/h7EA7b98jRw=;
 b=GXPMg1SltUKH5rMWaqkffdWnDX9U5z29XguTGYER1o8KyYcNvdKhWyqdnUlTJJNPsnyD7wW0lQePmmvuVOFv40z0k3uyQY2LOleBpZSybRkwRfASE3/Mx2RkOCL0Qsp3tthzoTkZrgGZb6kc+he6ueHXdZgmZMZ9g+qEczaGrzw=
Received: from CY5P221CA0119.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:1f::26)
 by IA1PR12MB6185.namprd12.prod.outlook.com (2603:10b6:208:3e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 19:52:21 +0000
Received: from CY4PEPF0000C979.namprd02.prod.outlook.com
 (2603:10b6:930:1f:cafe::27) by CY5P221CA0119.outlook.office365.com
 (2603:10b6:930:1f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:52:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C979.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:52:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:52:19 -0600
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
Subject: [PATCH RFC v7 23/64] x86/fault: Add support to dump RMP entry on fault
Date:   Wed, 14 Dec 2022 13:40:15 -0600
Message-ID: <20221214194056.161492-24-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C979:EE_|IA1PR12MB6185:EE_
X-MS-Office365-Filtering-Correlation-Id: 00e693a5-0038-499f-da17-08dade0cb66b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a8Vt/lxhQOcj00ofq1kEjyvUayt+iCeXuA/WKe8DB1urotvUecchOA74klJY5NtJ97pNZVMD4ctnXHofZcovbz+R/aj3PCkzIzf9C8wFAvY3hnrcPLoRa0moPfyBAHfuxyK2HvooN3kYAh8acZZDRnj94qI5/j8M0rF09G/yJgNeXp9gum+602kCmuu9pPr6RpSIaOOiH4YdEwAECW/qY9OffCg1ya4a8MXAaE0EqsVA1iE6yubF+9/zMIyamSyDxBp9K/JxNBNdA4FPg53iM5xn15ENKEqLreogHvHkwL42W25Sh3SVgsFp+o3jQAXdQNCibB5h5rU9fitSZ2lPn8y+9YISXWDsRKXsNRTYk9y4kynl3mVHxslghcgt9hrfSbfNlTo7D91g/RU2P5VJX/ZzVpLYvaTyhCIPV+/7Za5EzVSpWtmNT4ITDsUzZoQluVbKi2mOSmHnMq/is/W86nfaKmTN9n9UzSK0BAyYdWS/1JuRlovkgQivnzwj8NwBBlxD8GRp6DI2AgywPmpvjZt5QwbZfznfRNqYVVR8smc5bfNQY3JiUOBJncguIV0sSByrag5pHH8SEQzSwqWjHkWCK1ECHeCTtVnGIG8eB/XNJdaE+kXwE8ymjjg3n7sJIQFFaoRNpPTT1mAMzE5//jeJHHSBlsBWtY6c2QOksDwe4mWPrHPkBWVfkNO5/cfzhKfTA5fuTv/XZkl5RvdMWV+2b83Jv1riho7xm1OVrHA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199015)(46966006)(36840700001)(40470700004)(70206006)(70586007)(41300700001)(8676002)(7416002)(4326008)(7406005)(5660300002)(316002)(2906002)(8936002)(186003)(26005)(6916009)(54906003)(6666004)(478600001)(426003)(47076005)(86362001)(83380400001)(40480700001)(36860700001)(82310400005)(2616005)(336012)(16526019)(1076003)(36756003)(81166007)(82740400003)(44832011)(356005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:52:20.6748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e693a5-0038-499f-da17-08dade0cb66b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C979.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6185
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

When SEV-SNP is enabled globally, a write from the host goes through the
RMP check. If the hardware encounters the check failure, then it raises
the #PF (with RMP set). Dump the RMP entry at the faulting pfn to help
the debug.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/kernel/sev.c      | 43 ++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault.c        |  7 ++++++-
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 4eeedcaca593..2916f4150ac7 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -215,6 +215,7 @@ int snp_lookup_rmpentry(u64 pfn, int *level);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
+void sev_dump_rmpentry(u64 pfn);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -247,6 +248,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
 	return -ENODEV;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
+static inline void sev_dump_rmpentry(u64 pfn) {}
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index e2b38c3551be..1dd1b36bdfea 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2508,6 +2508,49 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
 	return entry;
 }
 
+void sev_dump_rmpentry(u64 pfn)
+{
+	unsigned long pfn_end;
+	struct rmpentry *e;
+	int level;
+
+	e = __snp_lookup_rmpentry(pfn, &level);
+	if (!e) {
+		pr_info("failed to read RMP entry pfn 0x%llx\n", pfn);
+		return;
+	}
+
+	if (rmpentry_assigned(e)) {
+		pr_info("RMPEntry paddr 0x%llx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx"
+			" asid=%d vmsa=%d validated=%d]\n", pfn << PAGE_SHIFT,
+			rmpentry_assigned(e), e->info.immutable, rmpentry_pagesize(e),
+			(unsigned long)e->info.gpa, e->info.asid, e->info.vmsa,
+			e->info.validated);
+		return;
+	}
+
+	/*
+	 * If the RMP entry at the faulting pfn was not assigned, then not sure
+	 * what caused the RMP violation. To get some useful debug information,
+	 * iterate through the entire 2MB region, and dump the RMP entries if
+	 * one of the bit in the RMP entry is set.
+	 */
+	pfn = pfn & ~(PTRS_PER_PMD - 1);
+	pfn_end = pfn + PTRS_PER_PMD;
+
+	while (pfn < pfn_end) {
+		e = __snp_lookup_rmpentry(pfn, &level);
+		if (!e)
+			return;
+
+		if (e->low || e->high)
+			pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
+				pfn << PAGE_SHIFT, e->high, e->low);
+		pfn++;
+	}
+}
+EXPORT_SYMBOL_GPL(sev_dump_rmpentry);
+
 /*
  * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
  * and -errno if there is no corresponding RMP entry.
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index ded53879f98d..f2b16dcfbd9a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -536,6 +536,8 @@ static void show_ldttss(const struct desc_ptr *gdt, const char *name, u16 index)
 static void
 show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long address)
 {
+	unsigned long pfn;
+
 	if (!oops_may_print())
 		return;
 
@@ -608,7 +610,10 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		show_ldttss(&gdt, "TR", tr);
 	}
 
-	dump_pagetable(address);
+	pfn = dump_pagetable(address);
+
+	if (error_code & X86_PF_RMP)
+		sev_dump_rmpentry(pfn);
 }
 
 static noinline void
-- 
2.25.1

