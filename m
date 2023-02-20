Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5C569D2DD
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjBTSkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjBTSkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:40:46 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A309212AC;
        Mon, 20 Feb 2023 10:40:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlUNlkge1EIgxPPpvhKbOAmPUspaieyUmK0B0rDURF0FnRV5rywRzqVtLUEbdLVk6W5r7wTdPjwvvSWHeJGO1LYA31cXErz9vdIhOVr1aIvU8Fr/IY64GV9W3AuqNYhN32it3KcAg+9ATR5Jh6CjylUif3ZFCIhGYy2CE6dtsWl6paGojyMW6u6MRH0FkPAfugeFZW7CbgyA6QxFwE67Y+uk1yP+eAMXbYbski+sOFukBmEkZiSWmcOglBRMDYMPExvb9F5w5kji+qUJWDa3X5NvLFI4LknuXiy+EcMIRwA7sHvhA/hum14U9XsdD/qXeDsAvGPZZz0oV0pee6ABUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VCT0diDUuBiNxbQj4irtCaHwl+/vl5tfhPxGNP0oDs=;
 b=WPxPjn5cCNTUJuH5Ybp1XuTSvNmmPf1CpCyN58t1dDVcZcM4sq5WZdkLVIMQEM7vXeSfZi912enpbul0k1INLTvglFybITjVs9S3xd6OHj/ebtVhzlZTeChNZNIxbhDCqmIRs1nuLtJMM4wFr5ebI+p/7Tkp9RwKZkeEhAOu106y/H1cQR/4hfpuc9EkTrqQDWFXRWk2+L4yWNXR5sOdHCYPjTXwKNyOv+qNceIv/nsOySfp/y/rpEIvB8sYTGiN0oAOC892W4m48f5RTIQLUtQEv4VKHiZ5pgRIOjCV+5S8TcZ8K5ENloBLzu1yX/I7D/vwrxvfzWSdlaioMP+0WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VCT0diDUuBiNxbQj4irtCaHwl+/vl5tfhPxGNP0oDs=;
 b=rJy62BWVS/4DNR4nMSvcxZEkS61bIBxgm0d7KgSJ5zrRXngl4Z6SzzZRvg/qN8lQyR28GR1DOW3zPq9w7V8zVSyLcyXxmkhxZKFugDyZd2/ywBgP2RIO9TdcUclXV4f/NfUs59hGrjVdpBaxESflOnCGptMFtlr/FXzWfhVYcLs=
Received: from DM6PR03CA0087.namprd03.prod.outlook.com (2603:10b6:5:333::20)
 by PH8PR12MB7208.namprd12.prod.outlook.com (2603:10b6:510:224::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:40:22 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::64) by DM6PR03CA0087.outlook.office365.com
 (2603:10b6:5:333::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:40:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 18:40:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:40:21 -0600
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
Subject: [PATCH RFC v8 11/56] x86/sev: Add the host SEV-SNP initialization support
Date:   Mon, 20 Feb 2023 12:38:02 -0600
Message-ID: <20230220183847.59159-12-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT016:EE_|PH8PR12MB7208:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a1d5b7-efbc-41a0-6f29-08db1371ecaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AorAVHYxkAKOEYDG6S8s/Oq1bZm6MfoKO5Gabd51zyjIGK//ljU+ywaPeR3USqAwzSBqxEAcZWjXh9yaZ42+Lxj7UPAAl6L7DxG4Ix8+LAyYkV5vXsH7WbovSfPrBNYj17/Q8r99PuNx4CBzt/FbE1HbWya/o+CmZoNelmzU/m9g5lUIgnSJTQ5Q1SRhGfW78t1L5EZxVEWPe5VxBkGb1N0/vQGQaTae79khb5Fe+7NhU5PVAoI9+ULHnUl5HQwo4AOZYipvj7y4QJLeGfWmUoFOl2VgryUtCxb8rn9ABHnI568QgMKf66s/V8ZXO9bL3p0w5fGjXL0+hWLRp/ksqTkwqVMm/dSBcvCnAcnwtkL7xKY5rWct6+n6pYO1GiUXYX8DJhEuIlo1naLTOX03u3vrbTj7tybztPuaG+hYPaMdthvqnu8RrO+LDPFelXkl2IAOWYiGIVp7BrLEyzuzwlHlMzBvBRIOt7HgUr4AIQEm879pNhkXAn3A9D4n828FIrOxIyYFuEngNgsFs6R+RQ77dY84GzGV229U82eu7f02xVSSLVjEEKJK69D2jXu2XBGPrUO7styNw3Yq95a8/eL3nyqpFb9c1ygZ5IVAdxgtJJZmEzSnVilCNMvTcJRK6wx/QRzGVD0rB+JWW8E/ILDsoHkJmkHnGYBEIalDwvHqygTNCBZbBN3ETLXyftxGWeCBc8rrz0MWOmhIwmAA1iLrKBtA/IACDHJ8s6UJ0jc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199018)(46966006)(36840700001)(40470700004)(40460700003)(47076005)(36756003)(6666004)(8676002)(1076003)(478600001)(2616005)(336012)(186003)(54906003)(26005)(316002)(41300700001)(70586007)(4326008)(44832011)(16526019)(70206006)(5660300002)(81166007)(7406005)(7416002)(82740400003)(36860700001)(8936002)(82310400005)(2906002)(356005)(40480700001)(86362001)(426003)(83380400001)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:40:22.5100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a1d5b7-efbc-41a0-6f29-08db1371ecaa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7208
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

The memory integrity guarantees of SEV-SNP are enforced through a new
structure called the Reverse Map Table (RMP). The RMP is a single data
structure shared across the system that contains one entry for every 4K
page of DRAM that may be used by SEV-SNP VMs. The goal of RMP is to
track the owner of each page of memory. Pages of memory can be owned by
the hypervisor, owned by a specific VM or owned by the AMD-SP. See APM2
section 15.36.3 for more detail on RMP.

The RMP table is used to enforce access control to memory. The table
itself is not directly writable by the software. New CPU instructions
(RMPUPDATE, PVALIDATE, RMPADJUST) are used to manipulate the RMP
entries.

Based on the platform configuration, the BIOS reserves the memory used
for the RMP table. The start and end address of the RMP table must be
queried by reading the RMP_BASE and RMP_END MSRs. If the RMP_BASE and
RMP_END are not set then disable the SEV-SNP feature.

The SEV-SNP feature is enabled only after the RMP table is successfully
initialized.

Also set SYSCFG.MFMD when enabling SNP as SEV-SNP FW >= 1.51 requires
that SYSCFG.MFMD must be se

RMP table entry format is non-architectural and it can vary by processor
and is defined by the PPR. Restrict SNP support on the known CPU model
and family for which the RMP table entry format is currently defined
for.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/msr-index.h         |  11 +-
 arch/x86/kernel/sev.c                    | 175 +++++++++++++++++++++++
 3 files changed, 192 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 33d2cd04d254..9b5a2cc8064a 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -87,6 +87,12 @@
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
@@ -110,7 +116,7 @@
 			 DISABLE_ENQCMD)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK19	0
+#define DISABLED_MASK19	(DISABLE_SEV_SNP)
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 10ac52705892..35100c630617 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -565,6 +565,8 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_RMP_BASE		0xc0010132
+#define MSR_AMD64_RMP_END		0xc0010133
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
@@ -649,7 +651,14 @@
 #define MSR_K8_TOP_MEM2			0xc001001d
 #define MSR_AMD64_SYSCFG		0xc0010010
 #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
-#define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
+#define MSR_AMD64_SYSCFG_MEM_ENCRYPT		BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
+#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
+#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
+#define MSR_AMD64_SYSCFG_MFDM_BIT		19
+#define MSR_AMD64_SYSCFG_MFDM			BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
+
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */
 #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a428c62330d3..e54e412c9916 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -22,6 +22,9 @@
 #include <linux/efi.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/cpumask.h>
+#include <linux/iommu.h>
+#include <linux/amd-iommu.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
@@ -38,6 +41,7 @@
 #include <asm/apic.h>
 #include <asm/cpuid.h>
 #include <asm/cmdline.h>
+#include <asm/iommu.h>
 
 #define DR7_RESET_VALUE        0x400
 
@@ -57,6 +61,12 @@
 #define AP_INIT_CR0_DEFAULT		0x60000010
 #define AP_INIT_MXCSR_DEFAULT		0x1f80
 
+/*
+ * The first 16KB from the RMP_BASE is used by the processor for the
+ * bookkeeping, the range needs to be added during the RMP entry lookup.
+ */
+#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
+
 /* For early boot hypervisor communication in SEV-ES enabled guests */
 static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
 
@@ -69,6 +79,9 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+static unsigned long rmptable_start __ro_after_init;
+static unsigned long rmptable_end __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -2260,3 +2273,165 @@ static int __init snp_init_platform_device(void)
 	return 0;
 }
 device_initcall(snp_init_platform_device);
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"SEV-SNP: " fmt
+
+static int __mfd_enable(unsigned int cpu)
+{
+	u64 val;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	rdmsrl(MSR_AMD64_SYSCFG, val);
+
+	val |= MSR_AMD64_SYSCFG_MFDM;
+
+	wrmsrl(MSR_AMD64_SYSCFG, val);
+
+	return 0;
+}
+
+static __init void mfd_enable(void *arg)
+{
+	__mfd_enable(smp_processor_id());
+}
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
+	u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
+
+	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
+	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
+
+	if (!rmp_base || !rmp_end) {
+		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
+		return false;
+	}
+
+	rmp_sz = rmp_end - rmp_base + 1;
+
+	/*
+	 * Calculate the amount the memory that must be reserved by the BIOS to
+	 * address the whole RAM. The reserved memory should also cover the
+	 * RMP table itself.
+	 */
+	calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + totalram_pages()) << 4)
+		      + RMPTABLE_CPU_BOOKKEEPING_SZ;
+
+	if (calc_rmp_sz > rmp_sz) {
+		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
+		       calc_rmp_sz, rmp_sz);
+		return false;
+	}
+
+	*start = rmp_base;
+	*len = rmp_sz;
+
+	pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n", rmp_base, rmp_end);
+
+	return true;
+}
+
+static __init int snp_rmptable_init(void)
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
+		pr_err("Failed to map RMP table addr 0x%llx size 0x%llx\n", rmp_base, sz);
+		return 1;
+	}
+
+	/*
+	 * Check if SEV-SNP is already enabled, this can happen in case of
+	 * kexec boot.
+	 */
+	rdmsrl(MSR_AMD64_SYSCFG, val);
+	if (val & MSR_AMD64_SYSCFG_SNP_EN)
+		goto skip_enable;
+
+	memset(start, 0, sz);
+
+	/* Flush the caches to ensure that data is written before SNP is enabled. */
+	wbinvd_on_all_cpus();
+
+	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */
+	on_each_cpu(mfd_enable, NULL, 1);
+
+	/* Enable SNP on all CPUs. */
+	on_each_cpu(snp_enable, NULL, 1);
+
+skip_enable:
+	rmptable_start = (unsigned long)start;
+	rmptable_end = rmptable_start + sz - 1;
+
+	return 0;
+}
+
+static int __init snp_host_init(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	/*
+	 * RMP table entry format is not architectural and it can vary by processor and
+	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
+	 * model and family for which the RMP table entry format is currently defined for.
+	 */
+	if (boot_cpu_data.x86 != 0x19 || boot_cpu_data.x86_model > 0xaf)
+		goto nosnp;
+
+	if (amd_iommu_snp_enable())
+		goto nosnp;
+
+	if (snp_rmptable_init())
+		goto nosnp;
+
+	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
+
+	return 0;
+
+nosnp:
+	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+	return -ENODEV;
+}
+
+/*
+ * This must be called after the PCI subsystem. This is because amd_iommu_snp_enable()
+ * is called to ensure the IOMMU supports the SEV-SNP feature, which can only be
+ * called after subsys_initcall().
+ *
+ * NOTE: IOMMU is enforced by SNP to ensure that hypervisor cannot program DMA
+ * directly into guest private memory. In case of SNP, the IOMMU ensures that
+ * the page(s) used for DMA are hypervisor owned.
+ */
+fs_initcall(snp_host_init);
-- 
2.25.1

