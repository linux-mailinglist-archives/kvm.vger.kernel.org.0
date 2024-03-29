Return-Path: <kvm+bounces-13136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E198927A7
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 415C21F249E5
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7916813E6DB;
	Fri, 29 Mar 2024 23:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2/X0W5nB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9439D13E6B9;
	Fri, 29 Mar 2024 23:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753651; cv=fail; b=bf2jjCnhfXgVAh7Q/vA+TDx++V8aXhhvWMk42IW5HCrtGoHL8rug4Se8kCeg80THGFe5gLYZoTMiZBDzo0UPw0m1VmU4F75xpU4Op95o18NaTDpab6l9/ExmwdSlo5pcHI3hyyX/nzUUqVyZ+ggzpj8vbHcp8bJ9WgrEsLcsI+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753651; c=relaxed/simple;
	bh=AuY2NMnF/F0eKaAZp9hi/QFwQoIZNLKhY4i1/5N3D9s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CHcLqA1zJJJw1emEI6Mt5T6jfWTlJK9ybjmsnXwEFNUYEC70cTAKaqpsKvMqqk00m++zDptjHzoR2oJ99t/HvPvowJIq2V8y8RYa6k+Ud1ji9Pwv+QY5k9adJ2A+GGT07KHI6Gm2g6T8KM7oYaTAlBKl+q4g0vsa4lKSKCTbYBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2/X0W5nB; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8RyJEt/gLT+Q3ntE+VTap3fAuWeh0NusiwR8TjW9b5LKQpD0e5iXZTC2PjyhwF6NHQH5PgtiaLGczcledBExFT2vBw/BXWj/9Dc6skUj1Zf9BuCWXMqJXnCv92Sj2RAaj/DHi2CbZRloCM88HF4osOkw0lD+qidmEYFqMZyjlXE8gulAp5FQLuKrk0MPhXsf6pAV9h/29/ZAGnMh0tHw6p4D9nkBDiwMQmyq0+HJd4U/fRw2RPucWJD9USgMgmcFY6VEpGBX98Q86v2R3LohXaUiDHagz1RaV3FKN8ITDyL1neYoxhZDz5ED9Fe7E5SHBn5E/PGig8+2ge6XYFagw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taVbrIHOx6Vdes43tKem9S8Cee5XAjBK9GyxEIOMYEc=;
 b=KSxusj4xyHoqDKiHZ3XSJVVpROATGNSMyeu4tPRhqpSV5joO8dnTQyfhaywwop+AlfwRLP98z8ReRm6BYKp5uvOUtdfDMpIY2hw6N5FcewbiTcqIgOb6iYkYEk96MF+uT/6/WvVPAOoWIQiNVyuMZCukydE1RSA6rxg8GJIBCh7C7DSsaXlLixAKF4brgYQ78zw5zbKj5X6W1hWq7v91OaPGob06PN8FxZulC4+L4v1XMZRxYBVKyYe2aQz6FdEZbOv6Uoq98i7PfYbZPqaU7Bcxm39QZC5Y/NkYZT3LdI4rhQenigbWTzqnnPVOCpejj5mjfqwK1BcPKXSRmwNCKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taVbrIHOx6Vdes43tKem9S8Cee5XAjBK9GyxEIOMYEc=;
 b=2/X0W5nBoIQgjPbXpzId5s79hkITJn4qEsCseoAaWqcXrrOC8u7BAqa7BlB12MS2MFzs2IQWh6ZvKCUqVljnldha36u3xKoNXDtRdTFhpgWqpldjTTWo0+5punzN0zonCHtehR9jGW/7BNddBXIEU86anrjLUTtar714Kubvn6Q=
Received: from DM6PR11CA0030.namprd11.prod.outlook.com (2603:10b6:5:190::43)
 by BY5PR12MB4260.namprd12.prod.outlook.com (2603:10b6:a03:206::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:07:25 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:190:cafe::57) by DM6PR11CA0030.outlook.office365.com
 (2603:10b6:5:190::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:07:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:07:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:07:23 -0500
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
Subject: [PATCH v12 03/29] [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()
Date: Fri, 29 Mar 2024 17:58:09 -0500
Message-ID: <20240329225835.400662-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|BY5PR12MB4260:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7d57fe-8506-46bc-df93-08dc5044ff0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Cxx5VtOLnKMFgtSO/4Wzq/K44byZ3gsNedFkAhUlTQdg7uoHF1mDoAWqN9Lq6q18OCw05/wnFfUjWEGS1PQyIQYsIULWCQU9m0N7R48F14iU95iVtSh5pS+N0oSISCyGJcVv0qQCCsiEJ/zR1ktHTH15ttTkHWd42a+mgjcW0fiByNMuhaWyORvfePFPs2Ur17gmZOfUTAi053KJ0VPMm5gbizMLN98+IrAwICpwm26vVKAdXZ85Um+YStUR+GnQCuONHP6Mfmfmtu8tsoVV41VAviL/JLM5kuQcAI9yE4XLhD2iHjLVmyHS2SwcwiOEkxMbCykkHNFRF2c0GHNhLGIXZ6+jX7hPpGQopaAE/eNMnd3PM0UEhNw3z3z16pq4DZtKlVRiKswy1cCMyAoSB+wuXwZGuSm0MEHBjWcG7LyFzFP2ZL+gN9e1dN1c2vzg56xEL1lHud3XAfsgKGdZOCG8F7Ccv4jub4Rc6ryuv7DAuToeF9dfDWmfw54Sif1UaHuS19WaO/GbLq+3PY7WlwhL8S0lV1lbStm7Ti/KVTjFdOljrPL00KXRjEBuz40MRSu6yjD8BP6l4mOeqPT+4SYsiNe6d0W312YPuThmbgOM8jUJUel1WHP5fvJ2dzXmke3lnLw+VhGS77DrCjVyc6c9Lk4C2NnwNOD0AncvFHVCq448mue4TSALjPmzPqmAeUpDhbuDWWB7jkMxNYqyvS3bxhm0h9NbU7qB6W2Bz1k+2J7kYICtPwlzJGld1GOW
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:07:24.6058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7d57fe-8506-46bc-df93-08dc5044ff0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4260

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
index d30bd30d4f7a..7b872f97a452 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3279,7 +3279,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
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


