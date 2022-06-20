Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEA0552781
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346392AbiFTXCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346435AbiFTXC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:02:27 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82B821E3F;
        Mon, 20 Jun 2022 16:02:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nW13WQo/Z3792e0PoAL4v2PbYWZ/HdlEYjnQ9CkAm/Qf+AXF2eHnXrOrx7XbG/6BfHc1+sPkB7UVHrFYA7xET3kMJQ5wbdeVjzF+k6Zqh0f9Phc059TTJpXJTFI0TpJ+t3Yz4KTjPQZxqU6JK6Ss34vbMcTMAf9BPgA08F9zm3E9u0w/dL6faO5Xi7wUi1Ev6WKhSdhvExvX8BW/7kyqTfL73Z+b4Q9uQZRHGx2ciIJ/yU6wWU7brC4b3XQYy5IbJTPe28ulMut9S8FBd23d5GYR/WVUZP7aJ3YT5+1/9HgsAaOB43VOa73USbLIlKeQrNkYsugf5C1GnVcyZNLIAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvxK3sgL9uPUw1r29lmHh+BrQxA04Cm/99qT8Zj3GBc=;
 b=NeRFZYNzLUQrt+8Ep3VJqkRzxcfJPXiZzgLytbf63twq23Sh3DDsMcteJ92G/RluTrZ2t0pfMLp5aF5WbXpBEQh729EiurLyMLgcX8BdeI55sQ5/IU6twXM2XyTprbhZIAByyHecP0iZIOY7gwT9obMNRNqbQO4WT4xeoGel0octgRCxL115+ZiB1+JRGnrJB57HdwrWIalhmde6t/rj+AqlY+LOMv+M2g+Niv+ckHjAHw/PJKrhbi4mcGDyxach8JwItqMYZ38krCabcljUuYYVxyOiyAD2N1hkHtd6S/vj6Mef15Gds1x3alb9Z+svT6xZsri0dyw453JdfNB6Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvxK3sgL9uPUw1r29lmHh+BrQxA04Cm/99qT8Zj3GBc=;
 b=iWedkQh5PGiwOXGGG+EtbFu+QtStrtVoIddP1zOh9fmxkg4n/hP6kPAl4KGzR+WbAT735YHR2HrO+gqInB3x7a7BHzs9ahRejybkFbAfD1QqQXIFk7OGYeJfUHPpK8IwA+GQyEFPOJxIFhCKhzekxy7I4kXKVyW49avE+VKSpPk=
Received: from DM6PR01CA0025.prod.exchangelabs.com (2603:10b6:5:296::30) by
 DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.15; Mon, 20 Jun 2022 23:02:13 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::d9) by DM6PR01CA0025.outlook.office365.com
 (2603:10b6:5:296::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20 via Frontend
 Transport; Mon, 20 Jun 2022 23:02:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:02:13 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:02:10 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP initialization support
Date:   Mon, 20 Jun 2022 23:02:01 +0000
Message-ID: <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39303a01-980f-49ae-ab64-08da5310e9e9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4516:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB451638503F0D5A3AB4ABA0628EB09@DM6PR12MB4516.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXzg8G3IGLDDScwyb54VajP7JgI3ng8/uNbkE06uPuDp3fBPX+HYR0b/EUTljLU3ekjNwGqcCkg/VAozWTgoxjqdleNhdKceTc6HWd2+MdsCiPF6wdGftkBJHM2iZKrd7L5sOQlhtSI28spQrMHWxOrXMXRSa7FlAwwEMjTycyINzyCIez4sZKUJj8txJdXP0eRWBtE3mJWnZpFs5a3TiE6O7mj8G+jOEwZUkAepDPEbzZ2o3Traxyxa+3ILtT8wL2gvINgJOFab02imKKYwref948gjlE7IKOyIffinuAH1q5aXcBtufGo3c3GwnNAXh8Gqw9T/8J6n3FfUw34JNZgz21K2Gr/UdUh+mvDTke9WdMwREi35JdDemhpiIlDATtCzZxOZFEB6YD++mEr5XygBlGaC5/pn4PA8+HirzHmrnjeYP6vv+q9xmvtojuYCpT8Z8M6eH+77VP/vzQFLZzhKY81tGPstPjq+pRIXHS3j1NvxHzb8sVyngs2DpzyfU9OA2GAACYJu835+BH8oSPXfnnaoouKE2EtK6Pfvmi7JM8bPJI2v4hvfneikTuhoJx+1PoGq5L4INKGLNksQKaFN7Wldd4Wa6A1y3ceXrSrwKTCy/qh3dzi49Z0A/HO5LnZh8xyGY3zfr/BR3ILwvSCey3DtH9J9vHwFMLITZYGwAimoIatb+dKZU7/P+EV27lOII8sdsUwG+spskJEmVzPtkd/Wpe/tMo6fbVMsBxGf+gHc/fKoyxwkJeGHdnWPFAYlo94zrmiB1gmfkd+sEA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(36840700001)(46966006)(40470700004)(82740400003)(356005)(82310400005)(36756003)(36860700001)(81166007)(110136005)(316002)(40480700001)(54906003)(186003)(47076005)(26005)(8676002)(16526019)(4326008)(426003)(2906002)(70206006)(336012)(70586007)(83380400001)(7416002)(7406005)(8936002)(478600001)(86362001)(5660300002)(2616005)(40460700003)(6666004)(41300700001)(7696005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:02:13.4240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39303a01-980f-49ae-ab64-08da5310e9e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4516
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The memory integrity guarantees of SEV-SNP are enforced through a new
structure called the Reverse Map Table (RMP). The RMP is a single data
structure shared across the system that contains one entry for every 4K
page of DRAM that may be used by SEV-SNP VMs. The goal of RMP is to
track the owner of each page of memory. Pages of memory can be owned by
the hypervisor, owned by a specific VM or owned by the AMD-SP. See APM2
section 15.36.3 for more detail on RMP.

The RMP table is used to enforce access control to memory. The table itself
is not directly writable by the software. New CPU instructions (RMPUPDATE,
PVALIDATE, RMPADJUST) are used to manipulate the RMP entries.

Based on the platform configuration, the BIOS reserves the memory used
for the RMP table. The start and end address of the RMP table must be
queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
RMP_END are not set then disable the SEV-SNP feature.

The SEV-SNP feature is enabled only after the RMP table is successfully
initialized.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/msr-index.h         |   6 +
 arch/x86/kernel/sev.c                    | 144 +++++++++++++++++++++++
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 36369e76cc63..c1be3091a383 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -68,6 +68,12 @@
 # define DISABLE_TDX_GUEST	(1 << (X86_FEATURE_TDX_GUEST & 31))
 #endif
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+# define DISABLE_SEV_SNP	0
+#else
+# define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -91,7 +97,7 @@
 			 DISABLE_ENQCMD)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK19	0
+#define DISABLED_MASK19	(DISABLE_SEV_SNP)
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9e2e7185fc1d..57a8280e283a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -507,6 +507,8 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_RMP_BASE		0xc0010132
+#define MSR_AMD64_RMP_END		0xc0010133
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
@@ -581,6 +583,10 @@
 #define MSR_AMD64_SYSCFG		0xc0010010
 #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
 #define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
+#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
+#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN	BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */
 #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index f01f4550e2c6..3a233b5d47c5 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -22,6 +22,8 @@
 #include <linux/efi.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/cpumask.h>
+#include <linux/iommu.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
@@ -38,6 +40,7 @@
 #include <asm/apic.h>
 #include <asm/cpuid.h>
 #include <asm/cmdline.h>
+#include <asm/iommu.h>
 
 #define DR7_RESET_VALUE        0x400
 
@@ -57,6 +60,12 @@
 #define AP_INIT_CR0_DEFAULT		0x60000010
 #define AP_INIT_MXCSR_DEFAULT		0x1f80
 
+/*
+ * The first 16KB from the RMP_BASE is used by the processor for the
+ * bookkeeping, the range need to be added during the RMP entry lookup.
+ */
+#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
+
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
 
@@ -69,6 +78,10 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+static unsigned long rmptable_start __ro_after_init;
+static unsigned long rmptable_end __ro_after_init;
+
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -2218,3 +2231,134 @@ static int __init snp_init_platform_device(void)
 	return 0;
 }
 device_initcall(snp_init_platform_device);
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"SEV-SNP: " fmt
+
+static int __snp_enable(unsigned int cpu)
+{
+	u64 val;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	rdmsrl(MSR_AMD64_SYSCFG, val);
+
+	val |= MSR_AMD64_SYSCFG_SNP_EN;
+	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
+
+	wrmsrl(MSR_AMD64_SYSCFG, val);
+
+	return 0;
+}
+
+static __init void snp_enable(void *arg)
+{
+	__snp_enable(smp_processor_id());
+}
+
+static bool get_rmptable_info(u64 *start, u64 *len)
+{
+	u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end, nr_pages;
+
+	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
+	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
+
+	if (!rmp_base || !rmp_end) {
+		pr_info("Memory for the RMP table has not been reserved by BIOS\n");
+		return false;
+	}
+
+	rmp_sz = rmp_end - rmp_base + 1;
+
+	/*
+	 * Calculate the amount the memory that must be reserved by the BIOS to
+	 * address the full system RAM. The reserved memory should also cover the
+	 * RMP table itself.
+	 *
+	 * See PPR Family 19h Model 01h, Revision B1 section 2.1.4.2 for more
+	 * information on memory requirement.
+	 */
+	nr_pages = totalram_pages();
+	calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + nr_pages) << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
+
+	if (calc_rmp_sz > rmp_sz) {
+		pr_info("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
+			calc_rmp_sz, rmp_sz);
+		return false;
+	}
+
+	*start = rmp_base;
+	*len = rmp_sz;
+
+	pr_info("RMP table physical address 0x%016llx - 0x%016llx\n", rmp_base, rmp_end);
+
+	return true;
+}
+
+static __init int __snp_rmptable_init(void)
+{
+	u64 rmp_base, sz;
+	void *start;
+	u64 val;
+
+	if (!get_rmptable_info(&rmp_base, &sz))
+		return 1;
+
+	start = memremap(rmp_base, sz, MEMREMAP_WB);
+	if (!start) {
+		pr_err("Failed to map RMP table 0x%llx+0x%llx\n", rmp_base, sz);
+		return 1;
+	}
+
+	/*
+	 * Check if SEV-SNP is already enabled, this can happen if we are coming from
+	 * kexec boot.
+	 */
+	rdmsrl(MSR_AMD64_SYSCFG, val);
+	if (val & MSR_AMD64_SYSCFG_SNP_EN)
+		goto skip_enable;
+
+	/* Initialize the RMP table to zero */
+	memset(start, 0, sz);
+
+	/* Flush the caches to ensure that data is written before SNP is enabled. */
+	wbinvd_on_all_cpus();
+
+	/* Enable SNP on all CPUs. */
+	on_each_cpu(snp_enable, NULL, 1);
+
+skip_enable:
+	rmptable_start = (unsigned long)start;
+	rmptable_end = rmptable_start + sz;
+
+	return 0;
+}
+
+static int __init snp_rmptable_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	if (!iommu_sev_snp_supported())
+		goto nosnp;
+
+	if (__snp_rmptable_init())
+		goto nosnp;
+
+	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
+
+	return 0;
+
+nosnp:
+	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+	return 1;
+}
+
+/*
+ * This must be called after the PCI subsystem. This is because before enabling
+ * the SNP feature we need to ensure that IOMMU supports the SEV-SNP feature.
+ * The iommu_sev_snp_support() is used for checking the feature, and it is
+ * available after subsys_initcall().
+ */
+fs_initcall(snp_rmptable_init);
-- 
2.25.1

