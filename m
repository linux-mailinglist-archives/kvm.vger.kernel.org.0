Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291284C32C2
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiBXRAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiBXQ7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 11:59:43 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2079.outbound.protection.outlook.com [40.107.101.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33DF60DA1;
        Thu, 24 Feb 2022 08:58:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpyzQq/joOfVh6H/4GoDwGqhEPVrQ/CvyPfEBl3r5DViMVBLIcgHdApEd1umaYydefijhs3gmtJTV8xL0sDnO276i463qNBB+x0xYTbIjd/1cwD99ja9cNlEj/LaK857uLufM0DD79MOcM/qZVS4IxMLc79yonFVODedZdFs6LY25ue6IXKvw33fPaiR7SvqYvR7gCdnJ0EibZGsZXZOtKK8MaWuhFNoY4iQJrO7E9imrx/ohGwNQWS+HSdRnQwOqdEJ6ZfZeSZlIYxOJ+6MAkwpbaCPk52oeJ4rhDpN7CLMvo9SYJL/awQSXAZUNdRMEY6poKqp0vAwCJCOlRo+qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T29/2TaTjE6y2w/cbm8PhGEi49TMVSH6O9SJYjUyJsI=;
 b=Dcm/e4bmn0oSKbjIZ9zF/fSsmUf8gMz+Ri63HlVqH9W6Aa7N0k8Xf1e0fLpiEWLQ6P1f+DYcEimzjOLPTatYs3PaodEz9bMu6gqhCJZusdNC1B15dPFHqSnQ7hOn084IZyacYKgejFGEhTH/S51jcUM70xOH/7PM1+6OB0hxGU8AfbeCFO6VI1tLMJ3lEM5HJEwQjJ9anIYIyosvwBqQGaLOfGrSPgtRBLZh/nsjrXFOmS42V/wJBQIY3dkqUASxMZNmXAsff5LjG0hahXYbp8QYbl+3XGDlDCN+1Q71pzBomL+UNRewpzmMek0LkHOKtY1FNpfpxIy6ZtS3Z8hkYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T29/2TaTjE6y2w/cbm8PhGEi49TMVSH6O9SJYjUyJsI=;
 b=Dy5M41UspFeF7ExyBuY0ilRqblMZfhKKxY/zHTxBN7YJxz6gNZFHVNCPBoz7ZLFhNjhyeo/1rGVwySbFKuNmwPy1KEC510Tut5oaVUA3pnXtUJNkG2YB0/i6DBkErM31fW9i6utxXjIRfVyFODSP3qPr0YbXzMor3HQl/TPaV+U=
Received: from DM6PR02CA0117.namprd02.prod.outlook.com (2603:10b6:5:1b4::19)
 by BN6PR12MB1699.namprd12.prod.outlook.com (2603:10b6:404:ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 16:58:39 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::3d) by DM6PR02CA0117.outlook.office365.com
 (2603:10b6:5:1b4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 16:58:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 16:58:39 +0000
Received: from sbrijesh-desktop.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Thu, 24 Feb
 2022 10:58:34 -0600
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-efi@vger.kernel.org>,
        <platform-driver-x86@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        <brijesh.ksingh@gmail.com>, <tony.luck@intel.com>,
        <marcorr@google.com>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v11 24/45] x86/compressed/acpi: Move EFI detection to helper
Date:   Thu, 24 Feb 2022 10:56:04 -0600
Message-ID: <20220224165625.2175020-25-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220224165625.2175020-1-brijesh.singh@amd.com>
References: <20220224165625.2175020-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0631fd1c-eb8f-431b-79d5-08d9f7b6e7cf
X-MS-TrafficTypeDiagnostic: BN6PR12MB1699:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1699F9F00BE8901ADC8E5088E53D9@BN6PR12MB1699.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qbq4qfBK7vQE3Lkp9MNKdS2cXrjEIan696GqCG4ATkG8uEQItSVXuKtBAX2ZNvEtjHAZNlI0T7DIfFoWOUfctEgqPn9q3H+oc2etnKGK7uJtEHuh8A99jtS9hVYUwxprsSgrYJ+fz3bwbP0+11MGkix/vBSnJ1dUm56ZWSNSVEjjUCf4i2bPMYovQogbbKTQzDPw3PkhWfIDX0n4fOTrPhGy0/SnHJuTLkvVQnaWedmbdn7US2pA3gvc/NPKKA+KIu+12U1IZSAiYIOIh5p3XcMl3OZIprkwnCHuaFgTNqs8lqq9C6oSbJYyBn5aCUBSIffFlE/43zPWSExOF4jHqpds+T5jMd1jHpW9I2MSgwo6w3NEJXq16EdYZrMGBCoa5xNwPmJLxGaLx3SZQDP00SaUxi3egosegvxg0NRIoJMjO6qN7omKcAnVECkUz2hCATdX+dWDnRldTJ5eCyki8htqKV4XWr56njklCJnt9AN7+fU+NC1y3orf1YTFCSHg3I832mszcMrtBOz7Jy8OLNky4sfLsnBps9m51supAs81jNUk6couqJd5BQuxJpGhjgXs/MiqHY6Vk27AncGPktRqom4FeaSa2eCipicuoy+N2pwHqlrDMd64YufvD6+UK955XhSKB44JUFYZoF3Dm4CB9pMFIGFsVlor5MbvqIZkm9GB3LxLCjZB/NM2V2tNI4uYgrNF38a30zzg0n9/3ybhXLwfstukzhXE+epIf4w=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(86362001)(47076005)(36860700001)(2906002)(7416002)(316002)(5660300002)(7406005)(83380400001)(36756003)(2616005)(426003)(336012)(7696005)(40460700003)(6666004)(16526019)(81166007)(8936002)(186003)(356005)(110136005)(26005)(82310400004)(54906003)(70586007)(1076003)(70206006)(508600001)(4326008)(8676002)(44832011)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 16:58:39.3628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0631fd1c-eb8f-431b-79d5-08d9f7b6e7cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1699
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

Future patches for SEV-SNP-validated CPUID will also require early
parsing of the EFI configuration. Incrementally move the related
code into a set of helpers that can be re-used for that purpose.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/boot/compressed/Makefile |  1 +
 arch/x86/boot/compressed/acpi.c   | 28 +++++++----------
 arch/x86/boot/compressed/efi.c    | 50 +++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.h   | 16 ++++++++++
 4 files changed, 77 insertions(+), 18 deletions(-)
 create mode 100644 arch/x86/boot/compressed/efi.c

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 6115274fe10f..e69c3d2e0628 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -103,6 +103,7 @@ endif
 vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
 
 vmlinux-objs-$(CONFIG_EFI_MIXED) += $(obj)/efi_thunk_$(BITS).o
+vmlinux-objs-$(CONFIG_EFI) += $(obj)/efi.o
 efi-obj-$(CONFIG_EFI_STUB) = $(objtree)/drivers/firmware/efi/libstub/lib.a
 
 $(obj)/vmlinux: $(vmlinux-objs-y) $(efi-obj-y) FORCE
diff --git a/arch/x86/boot/compressed/acpi.c b/arch/x86/boot/compressed/acpi.c
index 8bcbcee54aa1..db6c561920f0 100644
--- a/arch/x86/boot/compressed/acpi.c
+++ b/arch/x86/boot/compressed/acpi.c
@@ -87,7 +87,7 @@ static acpi_physical_address kexec_get_rsdp_addr(void)
 	efi_system_table_64_t *systab;
 	struct efi_setup_data *esd;
 	struct efi_info *ei;
-	char *sig;
+	enum efi_type et;
 
 	esd = (struct efi_setup_data *)get_kexec_setup_data_addr();
 	if (!esd)
@@ -98,10 +98,9 @@ static acpi_physical_address kexec_get_rsdp_addr(void)
 		return 0;
 	}
 
-	ei = &boot_params->efi_info;
-	sig = (char *)&ei->efi_loader_signature;
-	if (strncmp(sig, EFI64_LOADER_SIGNATURE, 4)) {
-		debug_putstr("Wrong kexec EFI loader signature.\n");
+	et = efi_get_type(boot_params);
+	if (et != EFI_TYPE_64) {
+		debug_putstr("Unexpected kexec EFI environment (expected 64-bit EFI).\n");
 		return 0;
 	}
 
@@ -122,29 +121,22 @@ static acpi_physical_address efi_get_rsdp_addr(void)
 	unsigned long systab, config_tables;
 	unsigned int nr_tables;
 	struct efi_info *ei;
+	enum efi_type et;
 	bool efi_64;
-	char *sig;
-
-	ei = &boot_params->efi_info;
-	sig = (char *)&ei->efi_loader_signature;
 
-	if (!strncmp(sig, EFI64_LOADER_SIGNATURE, 4)) {
+	et = efi_get_type(boot_params);
+	if (et == EFI_TYPE_64)
 		efi_64 = true;
-	} else if (!strncmp(sig, EFI32_LOADER_SIGNATURE, 4)) {
+	else if (et == EFI_TYPE_32)
 		efi_64 = false;
-	} else {
-		debug_putstr("Wrong EFI loader signature.\n");
+	else
 		return 0;
-	}
 
 	/* Get systab from boot params. */
+	ei = &boot_params->efi_info;
 #ifdef CONFIG_X86_64
 	systab = ei->efi_systab | ((__u64)ei->efi_systab_hi << 32);
 #else
-	if (ei->efi_systab_hi || ei->efi_memmap_hi) {
-		debug_putstr("Error getting RSDP address: EFI system table located above 4GB.\n");
-		return 0;
-	}
 	systab = ei->efi_systab;
 #endif
 	if (!systab)
diff --git a/arch/x86/boot/compressed/efi.c b/arch/x86/boot/compressed/efi.c
new file mode 100644
index 000000000000..bad0ce3e2ef6
--- /dev/null
+++ b/arch/x86/boot/compressed/efi.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Helpers for early access to EFI configuration table.
+ *
+ * Originally derived from arch/x86/boot/compressed/acpi.c
+ */
+
+#include "misc.h"
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+/**
+ * efi_get_type - Given a pointer to boot_params, determine the type of EFI environment.
+ *
+ * @bp:         pointer to boot_params
+ *
+ * Return: EFI_TYPE_{32,64} for valid EFI environments, EFI_TYPE_NONE otherwise.
+ */
+enum efi_type efi_get_type(struct boot_params *bp)
+{
+	struct efi_info *ei;
+	enum efi_type et;
+	const char *sig;
+
+	ei = &bp->efi_info;
+	sig = (char *)&ei->efi_loader_signature;
+
+	if (!strncmp(sig, EFI64_LOADER_SIGNATURE, 4)) {
+		et = EFI_TYPE_64;
+	} else if (!strncmp(sig, EFI32_LOADER_SIGNATURE, 4)) {
+		et = EFI_TYPE_32;
+	} else {
+		debug_putstr("No EFI environment detected.\n");
+		et = EFI_TYPE_NONE;
+	}
+
+#ifndef CONFIG_X86_64
+	/*
+	 * Existing callers like acpi.c treat this case as an indicator to
+	 * fall-through to non-EFI, rather than an error, so maintain that
+	 * functionality here as well.
+	 */
+	if (ei->efi_systab_hi || ei->efi_memmap_hi) {
+		debug_putstr("EFI system table is located above 4GB and cannot be accessed.\n");
+		et = EFI_TYPE_NONE;
+	}
+#endif
+
+	return et;
+}
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 01cc13c12059..fede1afa39e9 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -176,4 +176,20 @@ void boot_stage2_vc(void);
 
 unsigned long sev_verify_cbit(unsigned long cr3);
 
+enum efi_type {
+	EFI_TYPE_64,
+	EFI_TYPE_32,
+	EFI_TYPE_NONE,
+};
+
+#ifdef CONFIG_EFI
+/* helpers for early EFI config table access */
+enum efi_type efi_get_type(struct boot_params *bp);
+#else
+static inline enum efi_type efi_get_type(struct boot_params *bp)
+{
+	return EFI_TYPE_NONE;
+}
+#endif /* CONFIG_EFI */
+
 #endif /* BOOT_COMPRESSED_MISC_H */
-- 
2.25.1

