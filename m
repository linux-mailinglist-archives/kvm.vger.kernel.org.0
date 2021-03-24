Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68A6347E09
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhCXQpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:06 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:10848
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236566AbhCXQot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/7HV0f9WHb7LQDj7s2V6axgLlFBVyDZaR2vly6OA1AN1sZ6xi+cOEcRnX/CmcKJDk/OxSRFxgGcp0Dx4joQV0XTc4ktkFGBB0q/qoZYpDn/URymvf57vWyk0Dh3mND1bfb1c3j9YzGSHXGq5gusWqMaJnAw3bEOY9xUaXyp5nvVM0Jyv6Y0dQLSQDOruSGIlozQxvv415BZMo0l9aoQlHApgGXIm2eLbyB6dgTKBZd2YW7zQ9Pi7hIJMUSimjmj5tBf9O7S/rBzAwHgTvucEJlwhDHlds6GYF2OA4x+BEmu4Bc8bQl9cNjyMEE2/FZcIURJB1zfLFjMJVE6SPq6EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mn0ry8FpjJChdaSX5BJFECjvARQCELK3H7wK6hvg9XU=;
 b=jwDPPKz/Jeb7lAwwHtGVpBwZ74cguh3nfdSt3oKDhFr1Cxc2u84HPfFziRZlXg3vrgRVCULiHf34Dp2zNLQCUndrHkBP3BSreOlcM8Qf8QK2WURy+d3egqWSSgGKxPQ4079T2HvENko0mH+yVBJBi52ATYPwAYZqElgCUIIint+BHzgvb+zmS/oza9MseLD+kRQw8nUOqpnSXZ45qzrVuGcOcFVXg9nj6mdSRFPnNLWTbZVYoLAJkw7E9D00n82CWCfPPgHWtPKn6UDeO/UDpeLnhKUgevfxhh7cXgfIUXanyhq/DTORimbCaumjup+Z6Jyjx4hlYs9HoMv84fPfAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mn0ry8FpjJChdaSX5BJFECjvARQCELK3H7wK6hvg9XU=;
 b=Z2iGkGpgPWbu+PS5rfyGQaOsDgSO6+1EsY5CP8+/KFayGnELN4TfHfhrICV/tjXiF6DUMXd7cZg7G82h6TD2jQNKGV5UHk9iGYNn7SuZqGmIGs0m+jcctuc8jl8AT1qSiOmxeIkzHIYQ9b2J6dU+/aE/KzBdYO88cTd7eCvhaxo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:44:42 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:42 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
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
Subject: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate the memory used for the GHCB
Date:   Wed, 24 Mar 2021 11:44:17 -0500
Message-Id: <20210324164424.28124-7-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6f76b8ec-9dbd-48dd-ab07-08d8eee41fb2
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2447147B7EB6666675024E7FE5639@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dXy9MekrF0HlOIKE5JsLMLTPcYxecXBnO9nlvKen14nNbkdDPl2BSG/bR/A4LdXR5RsOjW3cdzxGArv1UwEOJc8JIlraSJi85vIW1T6RCAlxZbsvkntzE5ESJDwtu7zylgasPd0lmp90oS1hu9TyiLbVpVQ5YYkl424Bs9mOr4O2NCHFr8mn4rI3IJOEFRxVB1z+HX4LXJlNbPz3m7/HOrpLFkwgSdM03yMW/bDc6MLuFZyVqVZVakce0EWNoHc/ylrIxZlNLftG+acv8BDC0cglR021y/lmqU86572Qhn0sPBHrFrIrT3kise7Kz833wp7yWaMqR9z3ayEbS49ERAPE08BM0IIAm7g1rsKDuVnUkeqG92BwMpTMdwLO5cHYR4TGqnEGbvh0tUJynbAoe4/ms/0ysHRjUNtK154fQSit106pXJ59o2bRPFKAwqNAoPiQqzEDT6WwNhFKzQXrcXjHxSNoNsWiOCSPQwplTzJWqDQmBZPCsVOuIBuf7M6EjHGMjSH6clNkCvXml2DC9FRvHfFvQ5umSdVADKFqwXD7D0+Hir2Sp/9PPSY0oWT2KbLyDh5/GEc4SmB50CRKtmDwKVJMJYHxDaH5a0HqRqMryqX2RQUA4+8ltZqyGvs4AY0xtNDcEXahGP353Ns37i36QNaPRWIGZqhgYrk5kg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(38100700001)(5660300002)(26005)(44832011)(15650500001)(36756003)(1076003)(54906003)(8676002)(316002)(83380400001)(8936002)(4326008)(956004)(2906002)(186003)(6486002)(86362001)(7416002)(2616005)(66946007)(7696005)(478600001)(66556008)(66476007)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QR5JzdSX0iDkPmgcY9nFCJ5p3iZlgrxrSU2VAtEtSK9+w0+7VBnJj3Hyza/m?=
 =?us-ascii?Q?wEJkjQi//gQ5yS2dmun8GkHcnUwUMsse+N4mnzWCFLPljUdFn84OmYLIKAA3?=
 =?us-ascii?Q?xLWKpqdiYEP9n6G1alpXX+HgJXyeZJ4fREJrf2TZFh2+UCgnNS2JA/DJE1cO?=
 =?us-ascii?Q?TjUmD7ahgrukTh42vyrDqxW27xTXlyjdx+bGk58geQnpFxYhvdfKd7ruRJjq?=
 =?us-ascii?Q?XIzrurrRH0ZTiwlu+sR71FXk2C2ManjoASC4wBgAggnbMvi0q/iSienqhHnd?=
 =?us-ascii?Q?UiDTHynrYe1cwppC6bzGxMwNRR+4y/+M3pNU/zfZ6ksUlbevxuZaiGXpLpAj?=
 =?us-ascii?Q?zRvcH1IMKOBcCdG7rO26jaBUi8S99q1BiZGBhl2Vfwf7RFjKGqWtW9feB0p9?=
 =?us-ascii?Q?d8+W+bRtmVhlzokEjsysA78c+nkLQRL2pVAWRHo++Drs23WgG6378jiOFeTs?=
 =?us-ascii?Q?p6fsSPV2P9hKYGsUUJO8wEUJl3qmgIFkl9zAa3sVVO0bxVF3Sq/1NrzDlKP8?=
 =?us-ascii?Q?zU72QBufRPfYLA77t6QW0BNwSc6U7TX23fVBDanyyLpg+2lLobtcWeD8hySU?=
 =?us-ascii?Q?8rqJf8FreeRSKC7wLghYQiTtkkY1czXbfiXDZUGd7unZe9a10juGiDlGKRus?=
 =?us-ascii?Q?sRiGqmPn0VrVNdrmvfnKdCpWRZRrf+UxriMjdYG/vyJWBs2kGhRqX00FSkyI?=
 =?us-ascii?Q?825A/JmkSSMuKaGMkt0kQnHrfSa8iEexUf80qPhwmJ3Hcel6c/4zQgmdmNNb?=
 =?us-ascii?Q?eU6zGK5w+0qAMyjxnoOPxh0J/1IMy0aQ/TtCcLt2o8gQLeomaOSlaptm3Kq4?=
 =?us-ascii?Q?16eHDRF7Xo1ivN65UiHeURwE+zhQjxDvhwLwHI6Oe+YwLOBWhi9gDyssqfG5?=
 =?us-ascii?Q?UjgoxvIFHj9z9IC78E/q5RR5DhhPY0qgeB+IdhMImf2+VxTW3pyQX3G3GXJM?=
 =?us-ascii?Q?wNqpQZg3kVApbx/c+ArVciUtKCnQ9iNikvyF6q+mAE0jRyhEUr9Ctr0srqaM?=
 =?us-ascii?Q?arYs9vtzvOvCDvl9joDtquV0LAWe/obBfzAXV/tIeDPc+8AfwCqzUZV5CYGB?=
 =?us-ascii?Q?Zx6oJ8QFzAEvyVq/Lc6YC1RUNtpE873ehRiSDLR/y55AVbzZnK6jzq9jN00d?=
 =?us-ascii?Q?dr7SWpCqTb65rwVO7p9cbTChFKrAjRW3IKaN//ewuUZKKmcn4gAy0Ys/7BM7?=
 =?us-ascii?Q?n5DUR81f/rjcd5zhS8Xpi9UrhTTBOYBOwtiqo55qY4+4PhsgDyKeZZ30+uJu?=
 =?us-ascii?Q?eWAzWQNUdslNJ6hoCfLiDF0QjApiSHwgfrSqQjTc0iL4OuW9geW3ZdQy8Rpi?=
 =?us-ascii?Q?ecW1h66RXwjz5jkXvbx/dziJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f76b8ec-9dbd-48dd-ab07-08d8eee41fb2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:42.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXCEpo9dLisXPzf+J5ieAk7Zj5+AuXiI0uKJ1EDlJOPpDnpnzZunSIkSBAsF/230Qi05GZGQFmOQyVGHQiglxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Many of the integrity guarantees of SEV-SNP are enforced through the
Reverse Map Table (RMP). Each RMP entry contains the GPA at which a
particular page of DRAM should be mapped. The VMs can request the
hypervisor to add pages in the RMP table via the Page State Change VMGEXIT
defined in the GHCB specification section 2.5.1 and 4.1.6. Inside each RMP
entry is a Validated flag; this flag is automatically cleared to 0 by the
CPU hardware when a new RMP entry is created for a guest. Each VM page
can be either validated or invalidated, as indicated by the Validated
flag in the RMP entry. Memory access to a private page that is not
validated generates a #VC. A VM can use PVALIDATE instruction to validate
the private page before using it.

To maintain the security guarantee of SEV-SNP guests, when transitioning
a memory from private to shared, the guest must invalidate the memory range
before asking the hypervisor to change the page state to shared in the RMP
table.

After the page is mapped private in the page table, the guest must issue a
page state change VMGEXIT to make the memory private in the RMP table and
validate it. If the memory is not validated after its added in the RMP table
as private, then a VC exception (page-not-validated) will be raised. We do
not support the page-not-validated exception yet, so it will crash the guest.

On boot, BIOS should have validated the entire system memory. During
the kernel decompression stage, the VC handler uses the
set_memory_decrypted() to make the GHCB page shared (i.e clear encryption
attribute). And while exiting from the decompression, it calls the
set_memory_encyrpted() to make the page private.

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
 arch/x86/boot/compressed/Makefile       |   1 +
 arch/x86/boot/compressed/ident_map_64.c |  18 ++++
 arch/x86/boot/compressed/sev-snp.c      | 115 ++++++++++++++++++++++++
 arch/x86/boot/compressed/sev-snp.h      |  25 ++++++
 4 files changed, 159 insertions(+)
 create mode 100644 arch/x86/boot/compressed/sev-snp.c
 create mode 100644 arch/x86/boot/compressed/sev-snp.h

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index e0bc3988c3fa..4d422aae8a86 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -93,6 +93,7 @@ ifdef CONFIG_X86_64
 	vmlinux-objs-y += $(obj)/mem_encrypt.o
 	vmlinux-objs-y += $(obj)/pgtable_64.o
 	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-es.o
+	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-snp.o
 endif
 
 vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index f7213d0943b8..0a420ce5550f 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -37,6 +37,8 @@
 #include <asm/setup.h>	/* For COMMAND_LINE_SIZE */
 #undef _SETUP
 
+#include "sev-snp.h"
+
 extern unsigned long get_cmd_line_ptr(void);
 
 /* Used by PAGE_KERN* macros: */
@@ -278,12 +280,28 @@ static int set_clr_page_flags(struct x86_mapping_info *info,
 	if ((set | clr) & _PAGE_ENC)
 		clflush_page(address);
 
+	/*
+	 * If the encryption attribute is being cleared, then change the page state to
+	 * shared in the RMP entry. Change of the page state must be done before the
+	 * PTE updates.
+	 */
+	if (clr & _PAGE_ENC)
+		sev_snp_set_page_shared(pte_pfn(*ptep) << PAGE_SHIFT);
+
 	/* Update PTE */
 	pte = *ptep;
 	pte = pte_set_flags(pte, set);
 	pte = pte_clear_flags(pte, clr);
 	set_pte(ptep, pte);
 
+	/*
+	 * If the encryption attribute is being set, then change the page state to
+	 * private in the RMP entry. The page state must be done after the PTE
+	 * is updated.
+	 */
+	if (set & _PAGE_ENC)
+		sev_snp_set_page_private(pte_pfn(*ptep) << PAGE_SHIFT);
+
 	/* Flush TLB after changing encryption attribute */
 	write_cr3(top_level_pgt);
 
diff --git a/arch/x86/boot/compressed/sev-snp.c b/arch/x86/boot/compressed/sev-snp.c
new file mode 100644
index 000000000000..5c25103b0df1
--- /dev/null
+++ b/arch/x86/boot/compressed/sev-snp.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD SEV SNP support
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ *
+ */
+
+#include "misc.h"
+#include "error.h"
+
+#include <asm/msr-index.h>
+#include <asm/sev-snp.h>
+#include <asm/sev-es.h>
+
+#include "sev-snp.h"
+
+static bool sev_snp_enabled(void)
+{
+	unsigned long low, high;
+	u64 val;
+
+	asm volatile("rdmsr\n" : "=a" (low), "=d" (high) :
+			"c" (MSR_AMD64_SEV));
+
+	val = (high << 32) | low;
+
+	if (val & MSR_AMD64_SEV_SNP_ENABLED)
+		return true;
+
+	return false;
+}
+
+/* Provides sev_snp_{wr,rd}_ghcb_msr() */
+#include "sev-common.c"
+
+/* Provides sev_es_terminate() */
+#include "../../kernel/sev-common-shared.c"
+
+static void sev_snp_pages_state_change(unsigned long paddr, int op)
+{
+	u64 pfn = paddr >> PAGE_SHIFT;
+	u64 old, val;
+
+	/* save the old GHCB MSR */
+	old = sev_es_rd_ghcb_msr();
+
+	/* Issue VMGEXIT to change the page state */
+	sev_es_wr_ghcb_msr(GHCB_SNP_PAGE_STATE_REQ_GFN(pfn, op));
+	VMGEXIT();
+
+	/* Read the response of the VMGEXIT */
+	val = sev_es_rd_ghcb_msr();
+	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SNP_PAGE_STATE_CHANGE_RESP) ||
+	    (GHCB_SNP_PAGE_STATE_RESP_VAL(val) != 0))
+		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+
+	/* Restore the GHCB MSR value */
+	sev_es_wr_ghcb_msr(old);
+}
+
+static void sev_snp_issue_pvalidate(unsigned long paddr, bool validate)
+{
+	unsigned long eflags;
+	int rc;
+
+	rc = __pvalidate(paddr, RMP_PG_SIZE_4K, validate, &eflags);
+	if (rc) {
+		error("Failed to validate address");
+		goto e_fail;
+	}
+
+	/* Check for the double validation and assert on failure */
+	if (eflags & X86_EFLAGS_CF) {
+		error("Double validation detected");
+		goto e_fail;
+	}
+
+	return;
+e_fail:
+	sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+}
+
+static void sev_snp_set_page_private_shared(unsigned long paddr, int op)
+{
+	if (!sev_snp_enabled())
+		return;
+
+	/*
+	 * We are change the page state from private to shared, invalidate the pages before
+	 * making the page state change in the RMP table.
+	 */
+	if (op == SNP_PAGE_STATE_SHARED)
+		sev_snp_issue_pvalidate(paddr, false);
+
+	/* Request the page state change in the RMP table. */
+	sev_snp_pages_state_change(paddr, op);
+
+	/*
+	 * Now that pages are added in the RMP table as a private memory, validate the
+	 * memory range so that it is consistent with the RMP entry.
+	 */
+	if (op == SNP_PAGE_STATE_PRIVATE)
+		sev_snp_issue_pvalidate(paddr, true);
+}
+
+void sev_snp_set_page_private(unsigned long paddr)
+{
+	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_PRIVATE);
+}
+
+void sev_snp_set_page_shared(unsigned long paddr)
+{
+	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_SHARED);
+}
diff --git a/arch/x86/boot/compressed/sev-snp.h b/arch/x86/boot/compressed/sev-snp.h
new file mode 100644
index 000000000000..12fe9581a255
--- /dev/null
+++ b/arch/x86/boot/compressed/sev-snp.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AMD SEV Secure Nested Paging Support
+ *
+ * Copyright (C) 2021 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#ifndef __COMPRESSED_SECURE_NESTED_PAGING_H
+#define __COMPRESSED_SECURE_NESTED_PAGING_H
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+
+void sev_snp_set_page_private(unsigned long paddr);
+void sev_snp_set_page_shared(unsigned long paddr);
+
+#else
+
+static inline void sev_snp_set_page_private(unsigned long paddr) { }
+static inline void sev_snp_set_page_shared(unsigned long paddr) { }
+
+#endif /* CONFIG_AMD_MEM_ENCRYPT */
+
+#endif /* __COMPRESSED_SECURE_NESTED_PAGING_H */
-- 
2.17.1

