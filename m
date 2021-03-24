Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE88347E87
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbhCXRFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:24 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:50401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236969AbhCXREz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:04:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bthrg5kW6PcX2M/nlcdG4IeDEWaQ1qb7kpdHXIarpaFB5tiwzXsPe81MK6PBUU80M7wXFHEmpigBiqhrm6igXpgKt66khZiaBxmReHg8oeDDt2gGGGQuMFZhuNxXefA7jyQkPIQjDlUdtBX5dY8OMRafphmmw//DSKy+1mR5V5SXTObzaxWSIJhVqjTzOIujB5vDBohVMPOCWs0TPlbktWMzrFgp14o1qf+BJ8Nid8kjeHXSxkPGC3VWDmpZq+IZsZRIFjnpkiW6jLcLPRMYT4jZ7FzxGVnK+Jkx4ZkLeY38UeV7GR4aNxMaX13B8MDKc3jRIC/19Zo9fmFnzkMfsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cDXjFNVFAaRSlS7j6WayXMMTGKYDSSEn4KD++ibe/I=;
 b=nOCyc9b9gZVXOSjSFWC1eWcO2PpKRB9A9g/mTY6JfUBIAs8df9eWzQb9KXOcVdugltZGcUeoKPFK/xZnVPHufoBpyTcOBAfbOk/1OAb9uly/M62YGFgatWRyIKJh/Dvi3wl9+eQ5PBeuJlaMqAIEjH80d4LLZAPojk/cwoPsfUe+aeu7OPLtIKhZz3tOzIxPxFXTur3Rz6IDChqQt3vXgwZEc3wWK8mK73f4fJg5vjt0TakcX2S6iTaWtzdBY3WIVQreJQE+Lf/U6MgKS5+it82S4e4A4oIcl3dyRAY5/HWX8e+DoeU9r5XSi0AsK+93u0NHrekMCdvYU4VGukSkxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cDXjFNVFAaRSlS7j6WayXMMTGKYDSSEn4KD++ibe/I=;
 b=pd4P3SzwHC8eTpt7HyPaW41igllN3cB9+pa5GvGklbDO5CUzNmwETJUaKWOjBzt723xfRj6TJw9XbGj6L5RLlF//eUcdO61R7Ymf3bmbz1BNKn6ErK3rh0CEvlViCUlv8mDjoBqvQXvrx9A1uwEfnbQPRSYBJLvi47TEZt/708M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:52 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:52 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 02/30] x86/sev-snp: add RMP entry lookup helpers
Date:   Wed, 24 Mar 2021 12:04:08 -0500
Message-Id: <20210324170436.31843-3-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 95e6e956-b01b-45a3-a6f8-08d8eee6f0cd
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB455794502291C44A03870C57E5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8ysawRqgCbwERxnaZYWFqsaVSLHpAePAdHpFFyrysTUkWfHj8qUBQ6Uqmoq4kR2NDqOjIthGOKdEFahQF3ib4+lJhLR98Pwho96nF0GSQLfqXvUaeBTYeWP8yQBBjtcKDSwh9O58yjr7miB1pouA0tC5aXAKYiD4Am6a4Z2GiBzcf3fPsTAVytADN3VTSzJd8mbC5NLuTx8cR6YPfM1TMEf6pTwdKWZoQfiARxgeg3z02N5q60DyEuNaJzqfn4OdT0+W8IAR6QpLEn4L0L1XzL7t/YsT5w7IRmSvxuVjRZIqd2THDNTurV4uE9i8MdeR6uibyxST6e7SeKc6iOLYPBJ0g/bMX7yqKbHkrK51so5J313G05qWpArbONGlzHrNqCy8KKe6HhNHz7IBQBmiLktkQZNxI8DWdycHOrM2Q9eWmLDOAhtAfNYcYj1WwxlxBa4CJ9hysviZF/xbiOrJf1dZTJG/wlKb4tOI3J/S7RM1TPsEysa9b2tgcWsvoLXtediiIGKngYHbpsr3qGCk5eZRKOSVSf4ZaPGoODgtf/4RD6vsyEBxTxsGoYOBW+0VsEB/Sb4stKBIpNGXuhkmLC83wWnLVbqH8zpef+lC7Peu+POqwFQD4FOK0y0QEJYcyXtF23+zIE6scCV/jU+LKW8nmmn5Id4KoJprXuabUM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cxKarHWY07auMEaK0g2kkhLY9xSePl6b9vveS8Ngr2alygTEqLdBNDKJtTVI?=
 =?us-ascii?Q?rT4j40XoH/Ggae9t6Tfki+46kH0hvAlAFuP1Bn9mTQ0THjMExplnViB1VOaX?=
 =?us-ascii?Q?d/awwPYzHz9OtCgV4z9A5qTOC4vyGB7EMJ/2pufzGFoh88Oq++XqF6EYtUpP?=
 =?us-ascii?Q?/8vOIa73m2cl86VArORNOjEq4HuWOirD8WN8niE04HlR11nVgUZXsURJnMfH?=
 =?us-ascii?Q?vVHr+mYgNPmxafiYOSr0Yd5mMaBR9YODXM/uhciyfyoRd7qwaEX6Xvchzv0u?=
 =?us-ascii?Q?lSBGaVghPzlZisFYyhfOjuVqNJMkHP1FkRTQkfDE7FJEGDCWku7UhMwQERoV?=
 =?us-ascii?Q?wyyPNPM/J3EBKtz7le2hf7rgPMVLCUMYEHhnJNHVTIuWy0Bh3qcQdrKZ2EJC?=
 =?us-ascii?Q?7YrePttBQ1VLOeUPBI1VmPTmmSK58ab7z7E/4nHtjk5Oui2a408aXLYyynSI?=
 =?us-ascii?Q?F6yWaSgaGpr88J14QzckXQhj0LIBcJYdcvDkTMHhovKZe9EJ7Byk9aTGf/gn?=
 =?us-ascii?Q?sKCrDHiq1fJR0/9hjVfkV2Kd9fJ17h7DxPWPwfFW08Y2qq8W5aPqCgGsM50p?=
 =?us-ascii?Q?4ds09tN10Njifrkx4ts9Jq8dCE7kdNTQN6Q8zDcQhM2tHYLk+wEqrJaHTy0F?=
 =?us-ascii?Q?4l6LN5efSRXI1Jh0qvDpe/roO7BxOx57EseFodcObpZQjnyTibnhHL/KJJgN?=
 =?us-ascii?Q?0MqT4dAVYGFrOg8h2ASEpnwdlD16wvdhDQojRxzoOVOYtB8d3Q2bwXqB3o4W?=
 =?us-ascii?Q?uLlbLk3mgr740sJ+x2kJYEI3Q+kqVJ99VqI7EnjsMG4DXdJv+3zJcyZKXXAa?=
 =?us-ascii?Q?JLPfT9w99yRTHYUcsmZWPWRa/o1itJ0z+TLvrQKpdQmr/PEwZ1d355RuPOhr?=
 =?us-ascii?Q?8wpDaD+n138/WXNV/LUULVCGYhxIvJEv9BzdGgCb3HHlSFOvbsKXIPq7lesC?=
 =?us-ascii?Q?C7oAtiMEuyk0iilfNeq3u5x9G/2MCTHwC8PAsHo7Ic4bi4rBmD/VP4DVaFym?=
 =?us-ascii?Q?wbQPC1EN6NGlj7yYqQMtSXN5pJTX3DWdxExQcnrLuqprkdIDSFolVYYElkSQ?=
 =?us-ascii?Q?+bfwI11ibjSGzt5JPCkOL8NBFhx2tk8NyEg/A0a5HG5cgr9v2Y7qBg60Uqo4?=
 =?us-ascii?Q?ybWpAvkDcItq05ySBKJUIPvV1hFK4xero4+YhMRzLuM6o7WjqvQDdUn6MGpe?=
 =?us-ascii?Q?KOH3Sj0Fc/PwGke/aaXwZk8WmMyvobfG/a6YMcZjszCoY4weCchx1RgZvAgy?=
 =?us-ascii?Q?Lssbi4RUbrqs6PLAmsjvr5kLU5LBE0rtzPOhwnPSjOmofTL/pM9gakRZm0tn?=
 =?us-ascii?Q?AEFAwnVtpxITHCwtaFFSCqYu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e6e956-b01b-45a3-a6f8-08d8eee6f0cd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:52.4312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 81VWIe+FuX0crAm6RMssgi7CSZvKJXJJ6Y2pkYHL1eylsy8YLo26bmNM7ONk3HMrr+AWZkn/4jT8h+waTAq70A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lookup_page_in_rmptable() can be used by the host to read the RMP
entry for a given page. The RMP entry format is documented in PPR
section 2.1.5.2.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-snp.h | 31 +++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c      | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
index f7280d5c6158..2aa14b38c5ed 100644
--- a/arch/x86/include/asm/sev-snp.h
+++ b/arch/x86/include/asm/sev-snp.h
@@ -67,6 +67,35 @@ struct __packed snp_page_state_change {
 #define X86_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
 #define RMP_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
 
+/* RMP table entry format (PPR section 2.1.5.2) */
+struct __packed rmpentry {
+	union {
+		struct {
+			uint64_t assigned:1;
+			uint64_t pagesize:1;
+			uint64_t immutable:1;
+			uint64_t rsvd1:9;
+			uint64_t gpa:39;
+			uint64_t asid:10;
+			uint64_t vmsa:1;
+			uint64_t validated:1;
+			uint64_t rsvd2:1;
+		} info;
+		uint64_t low;
+	};
+	uint64_t high;
+};
+
+typedef struct rmpentry rmpentry_t;
+
+#define rmpentry_assigned(x)	((x)->info.assigned)
+#define rmpentry_pagesize(x)	(RMP_X86_PG_LEVEL((x)->info.pagesize))
+#define rmpentry_vmsa(x)	((x)->info.vmsa)
+#define rmpentry_asid(x)	((x)->info.asid)
+#define rmpentry_validated(x)	((x)->info.validated)
+#define rmpentry_gpa(x)		((unsigned long)(x)->info.gpa)
+#define rmpentry_immutable(x)	((x)->info.immutable)
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #include <linux/jump_label.h>
 
@@ -94,6 +123,7 @@ void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr
 		unsigned int npages);
 int snp_set_memory_shared(unsigned long vaddr, unsigned int npages);
 int snp_set_memory_private(unsigned long vaddr, unsigned int npages);
+rmpentry_t *lookup_page_in_rmptable(struct page *page, int *level);
 
 extern struct static_key_false snp_enable_key;
 static inline bool snp_key_active(void)
@@ -124,6 +154,7 @@ early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr, unsigned i
 static inline int snp_set_memory_shared(unsigned long vaddr, unsigned int npages) { return 0; }
 static inline int snp_set_memory_private(unsigned long vaddr, unsigned int npages) { return 0; }
 static inline bool snp_key_active(void) { return false; }
+static inline rpmentry_t *lookup_page_in_rmptable(struct page *page, int *level) { return NULL; }
 
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 39461b9cb34e..06394b6d56b2 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -34,6 +34,8 @@
 
 #include "mm_internal.h"
 
+#define rmptable_page_offset(x)	(0x4000 + (((unsigned long) x) >> 8))
+
 /*
  * Since SME related variables are set early in the boot process they must
  * reside in the .data section so as not to be zeroed out when the .bss
@@ -612,3 +614,33 @@ static int __init mem_encrypt_snp_init(void)
  * SEV-SNP must be enabled across all CPUs, so make the initialization as a late initcall.
  */
 late_initcall(mem_encrypt_snp_init);
+
+rmpentry_t *lookup_page_in_rmptable(struct page *page, int *level)
+{
+	unsigned long phys = page_to_pfn(page) << PAGE_SHIFT;
+	rmpentry_t *entry, *large_entry;
+	unsigned long vaddr;
+
+	if (!static_branch_unlikely(&snp_enable_key))
+		return NULL;
+
+	vaddr = rmptable_start + rmptable_page_offset(phys);
+	if (WARN_ON(vaddr > rmptable_end))
+		return NULL;
+
+	entry = (rmpentry_t *)vaddr;
+
+	/*
+	 * Check if this page is covered by the large RMP entry. This is needed to get
+	 * the page level used in the RMP entry.
+	 *
+	 * e.g. if the page is covered by the large RMP entry then page size is set in the
+	 *       base RMP entry.
+	 */
+	vaddr = rmptable_start + rmptable_page_offset(phys & PMD_MASK);
+	large_entry = (rmpentry_t *)vaddr;
+	*level = rmpentry_pagesize(large_entry);
+
+	return entry;
+}
+EXPORT_SYMBOL_GPL(lookup_page_in_rmptable);
-- 
2.17.1

