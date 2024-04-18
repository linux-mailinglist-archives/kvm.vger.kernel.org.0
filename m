Return-Path: <kvm+bounces-15160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BABA18AA372
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 318511F21CDD
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BA4190665;
	Thu, 18 Apr 2024 19:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gzIPSXtj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4525918410C;
	Thu, 18 Apr 2024 19:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469789; cv=fail; b=hN4E1tTS4hrqd0cMvKWOl/A+/nQWnDhTqbjbJlECOb7o1pT8hNMOwUAqgHpfKMvvTEBSU9SkCUGKuyBmFAMj7IglPWLuGGjId364swjpMfF9I/qw1hc7bHuZ/oLV/NMvLJX/cNVtYzkuhPjZDTbPmGOtl/9qNzJ9nMiiWSDnVgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469789; c=relaxed/simple;
	bh=ddUSwBlfHO+8zTHMgusjbhzIC+bNlw/iilQT/iJeD9M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLrwzfmFQxUMKqIjyO1x0pv4VpAi/qhQ50LDMfAcTO42tZY0WjaaIO7v9YoKmiSWBg9i8sGjY14zwG4xb3CLocmxg2cPOmQQt7/d4vI3GazIAle0YujsBpZ08whRgZn1x5iuMw87+AOd0o782Ig4E+xRqPp0BHSa53Rx+9YMveU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gzIPSXtj; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6Eenume8AqTmKjn9Nqt0WdiJI/O1xktbv6BY6ymfhCuXtktPK7dsRVYfO7lq8putnPvLMBvM8Li9dza/+roJHllR07wzdS7RAnNuUGPahaZOzQ5erguO0anZLnnbtKAGe6moFd622LC1KN+3PjzAvD4PLYcT8l9kUS3UL9Cd4WcuS6V/fN7R6iKK7XNd7yGwStObgJjq7IxR8nU5cYlIWYC898OQlAVTx9ZxwLzmcfLhWcVKvGxycp3YRwzoWlcxq5xKkk6OJQj7Eg3wNmXQ3UwI2T6bmCg6al490TxiNilMWc6SpdNvFlF8qboSzNG1Q1e6WfoGlA1sU2FoBO+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5zEqGM1bhYNGAIK+xd0rpn984OnQ1sfqnbzI9kFBWg=;
 b=LYyo9CqSBRZKyhVQU8pUTcj+emkMHDlX2jY5AgNiVS6lq9+37+M4pDrJWY2EtRi/IWjjWjJVAQ9+RY/ZS44bUqrUMQaonM/Omf0fvPaSNiORp0hwuUjKJEgxp51rT+O8SCJI8jOzb/tHVim+s0cXOUzfpl2hcIRiGvEYW5sjdiegCEnNlGgaZaL7H/W4/1YrtGeDP1RQm/BqZSzNDWy01FP10HCm0NiIjBAiNaVwSUJF0vantNYKdWbMVER+2be3/6OOqkCiI2SIdDrdU03BWGdwFP8BJYRvnIlPZ4+nc4Ctorn1QNlitzVxg7USmsqWfX8BVFl0KAIjHZyvy8vAqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5zEqGM1bhYNGAIK+xd0rpn984OnQ1sfqnbzI9kFBWg=;
 b=gzIPSXtjE2pkzk9rncAwCg42Q1Z+0VtKNI6N7FlirLRzzQFx5NnLGw9jhONAmw+VWoJ6C3GGMt2Ba7rxF7uB5L0l/MqaXA2TzrI5e7RoMwe1yq+hYqz2/FCgIU97F8K19VKPbrbDOyL46YPsYWpGBaabvpUFx6jmEK6u1dcSVYI=
Received: from SN7PR18CA0030.namprd18.prod.outlook.com (2603:10b6:806:f3::7)
 by BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.42; Thu, 18 Apr
 2024 19:49:42 +0000
Received: from SN1PEPF0002BA51.namprd03.prod.outlook.com
 (2603:10b6:806:f3:cafe::a2) by SN7PR18CA0030.outlook.office365.com
 (2603:10b6:806:f3::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.26 via Frontend
 Transport; Thu, 18 Apr 2024 19:49:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA51.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:49:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:49:41 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v13 03/26] [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()
Date: Thu, 18 Apr 2024 14:41:10 -0500
Message-ID: <20240418194133.1452059-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA51:EE_|BY5PR12MB4116:EE_
X-MS-Office365-Filtering-Correlation-Id: d5168f74-a41d-4869-0780-08dc5fe0b0cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Y+KjFbYPNcH+V86Ht5gVP8tt2wl1UqECapNRF+ZDjNDAjHjyuYfybAnjlnyYTb5tVNxKICTVOAzbaDs3oBDXXKPLm1LhTmu3qjY1Zz2GObcgq/FW9MNDEiNkYkcSfkMI6WbYbODV/mfrciqvm7H4XRo2iFVeFE7OVA4W60mjXrYe7vZ7iFchkilIakYz8S5ZP4a7AuMCaWW2QGtr7uyE+4a0Q1WvpazT3etSINDj+8SafTutHAKLUzWyyYocUgBHNQE6V151bmSX5IsbD9K85A+lkx8MNCCdTBz+vIyAOva/dRWUtY/eSO+I706K96NRAJE0hkXed6hUzJGVPAGf9gBjMW4inQ/XIA7A5x2YfNCuby4OqIukcgJ7xZxw7nOhz2NqpmBK85X/nA7px9+ZQWolPUFCYx1mpnQ7vGr8rxju0xC2FXKtxE54J8SKvusC/Q+WjwfVod2s4wRm4ERO9Vg7p6635miWPNPnay/r2fbfQ8YfJpxxkKpRIrRXU14dcMG4VAWHrLJy16+gzEBd8m++QasiJDYWnBObRA7a6/j2hTyKg+dVx+CfpUbbKwJ+FOhZj99lYQ2Sz3+Q70odpGILNnTmk3pUHIFttgIofx3qeH8B1YMJBYolt74pFbYseQtJYHmbPTnd6ky6GeB87RM03eCZADMdFCCdyMjsEA6NRdkaTQdhwDA47FetqqzI6HpEBHtIh+ZFYXH2D95I6yU53kAna0d3hqKWuk4ZR5oowWY8At/sjeckqKudAfO9
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(1800799015)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:49:42.1679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5168f74-a41d-4869-0780-08dc5fe0b0cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA51.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4116

From: "Borislav Petkov (AMD)" <bp@alien8.de>

The host SNP worthiness can determined later, after alternatives have
been patched, in snp_rmptable_init() depending on cmdline options like
iommu=pt which is incompatible with SNP, for example.

Which means that one cannot use X86_FEATURE_SEV_SNP and will need to
have a special flag for that control.

Use that newly added CC_ATTR_HOST_SEV_SNP in the appropriate places.

Move kdump_sev_callback() to its rightfull place, while at it.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h         |  4 ++--
 arch/x86/kernel/cpu/amd.c          | 38 ++++++++++++++++++------------
 arch/x86/kernel/cpu/mtrr/generic.c |  2 +-
 arch/x86/kernel/sev.c              | 10 --------
 arch/x86/kvm/svm/sev.c             |  2 +-
 arch/x86/virt/svm/sev.c            | 26 +++++++++++++-------
 drivers/crypto/ccp/sev-dev.c       |  2 +-
 drivers/iommu/amd/init.c           |  4 +++-
 8 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9477b4053bce..780182cda3ab 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -228,7 +228,6 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
-void kdump_sev_callback(void);
 void sev_show_status(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
@@ -258,7 +257,6 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
-static inline void kdump_sev_callback(void) { }
 static inline void sev_show_status(void) { }
 #endif
 
@@ -270,6 +268,7 @@ int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
 void snp_leak_pages(u64 pfn, unsigned int npages);
+void kdump_sev_callback(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -282,6 +281,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
+static inline void kdump_sev_callback(void) { }
 #endif
 
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6d8677e80ddb..9bf17c9c29da 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -345,6 +345,28 @@ static void srat_detect_node(struct cpuinfo_x86 *c)
 #endif
 }
 
+static void bsp_determine_snp(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_ARCH_HAS_CC_PLATFORM
+	cc_vendor = CC_VENDOR_AMD;
+
+	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
+		/*
+		 * RMP table entry format is not architectural and is defined by the
+		 * per-processor PPR. Restrict SNP support on the known CPU models
+		 * for which the RMP table entry format is currently defined for.
+		 */
+		if (!cpu_has(c, X86_FEATURE_HYPERVISOR) &&
+		    c->x86 >= 0x19 && snp_probe_rmptable_info()) {
+			cc_platform_set(CC_ATTR_HOST_SEV_SNP);
+		} else {
+			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+			cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
+		}
+	}
+#endif
+}
+
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
@@ -452,21 +474,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		break;
 	}
 
-	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
-		/*
-		 * RMP table entry format is not architectural and it can vary by processor
-		 * and is defined by the per-processor PPR. Restrict SNP support on the
-		 * known CPU model and family for which the RMP table entry format is
-		 * currently defined for.
-		 */
-		if (!boot_cpu_has(X86_FEATURE_ZEN3) &&
-		    !boot_cpu_has(X86_FEATURE_ZEN4) &&
-		    !boot_cpu_has(X86_FEATURE_ZEN5))
-			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
-		else if (!snp_probe_rmptable_info())
-			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
-	}
-
+	bsp_determine_snp(c);
 	return;
 
 warn:
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 422a4ddc2ab7..7b29ebda024f 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -108,7 +108,7 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 	      (boot_cpu_data.x86 >= 0x0f)))
 		return;
 
-	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 
 	rdmsr(MSR_AMD64_SYSCFG, lo, hi);
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index b59b09c2f284..1e1a3c3bd1e8 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2287,16 +2287,6 @@ static int __init snp_init_platform_device(void)
 }
 device_initcall(snp_init_platform_device);
 
-void kdump_sev_callback(void)
-{
-	/*
-	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
-	 * safely do SNP_SHUTDOWN on the local CPU.
-	 */
-	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
-		wbinvd();
-}
-
 void sev_show_status(void)
 {
 	int i;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1642d7d49bde..598d78b4107f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3296,7 +3296,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 	unsigned long pfn;
 	struct page *p;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 
 	/*
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index cffe1157a90a..ab0e8448bb6e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -77,7 +77,7 @@ static int __mfd_enable(unsigned int cpu)
 {
 	u64 val;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
 
 	rdmsrl(MSR_AMD64_SYSCFG, val);
@@ -98,7 +98,7 @@ static int __snp_enable(unsigned int cpu)
 {
 	u64 val;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
 
 	rdmsrl(MSR_AMD64_SYSCFG, val);
@@ -174,11 +174,11 @@ static int __init snp_rmptable_init(void)
 	u64 rmptable_size;
 	u64 val;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
 
 	if (!amd_iommu_snp_en)
-		return 0;
+		goto nosnp;
 
 	if (!probed_rmp_size)
 		goto nosnp;
@@ -225,7 +225,7 @@ static int __init snp_rmptable_init(void)
 	return 0;
 
 nosnp:
-	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 	return -ENOSYS;
 }
 
@@ -246,7 +246,7 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
 {
 	struct rmpentry *large_entry, *entry;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return ERR_PTR(-ENODEV);
 
 	entry = get_rmpentry(pfn);
@@ -363,7 +363,7 @@ int psmash(u64 pfn)
 	unsigned long paddr = pfn << PAGE_SHIFT;
 	int ret;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
 
 	if (!pfn_valid(pfn))
@@ -472,7 +472,7 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 	unsigned long paddr = pfn << PAGE_SHIFT;
 	int ret, level;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
 
 	level = RMP_TO_PG_LEVEL(state->pagesize);
@@ -558,3 +558,13 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
 	spin_unlock(&snp_leaked_pages_list_lock);
 }
 EXPORT_SYMBOL_GPL(snp_leak_pages);
+
+void kdump_sev_callback(void)
+{
+	/*
+	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
+	 * safely do SNP_SHUTDOWN on the local CPU.
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		wbinvd();
+}
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f44efbb89c34..2102377f727b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1090,7 +1090,7 @@ static int __sev_snp_init_locked(int *error)
 	void *arg = &data;
 	int cmd, rc = 0;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
 
 	sev = psp->sev_data;
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index e7a44929f0da..33228c1c8980 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3228,7 +3228,7 @@ static bool __init detect_ivrs(void)
 static void iommu_snp_enable(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 	/*
 	 * The SNP support requires that IOMMU must be enabled, and is
@@ -3236,12 +3236,14 @@ static void iommu_snp_enable(void)
 	 */
 	if (no_iommu || iommu_default_passthrough()) {
 		pr_err("SNP: IOMMU disabled or configured in passthrough mode, SNP cannot be supported.\n");
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 		return;
 	}
 
 	amd_iommu_snp_en = check_feature(FEATURE_SNP);
 	if (!amd_iommu_snp_en) {
 		pr_err("SNP: IOMMU SNP feature not enabled, SNP cannot be supported.\n");
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 		return;
 	}
 
-- 
2.25.1


