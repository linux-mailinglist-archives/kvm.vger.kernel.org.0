Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF1F64D04A
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbiLNTuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239181AbiLNTtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:49:18 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A00193DB;
        Wed, 14 Dec 2022 11:48:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOhNFYptC2xhjLrxDkv8dC1tML0YumzjEK365ET1F1Mzr0VuK7Aer9+ykzsil0THd0C9xkBu70qRRw17NQv6rc8B7UYNYQiWCYkOw6FMYF2gjraslQCD7ADG0SqvQ0IaM1Nss4f8bY5IuqmNrbZBZcijOPc0R1abCRP8356/O20dZaYY9PhACDEl0Xp6mBPv2PZNH3LXBnSBJ9+8tyEWDQDwCyv16TEpVvuT+DsNCjxZzuMt0FaMyexX1RzbdPN7oEi/0AVFEqC5QZsty47zNkO6si2/Cz40ruQQ8YU/7U/e/VIbHcar7XEk0qXWT5DNx1rd6OypFZyD1A6ZQm4yLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KphY0nexziHJ8xx+b9qdlFw6j59/C+D0P79fmBASfcE=;
 b=UYkOdChObdAMxoB8RI7H94+1M8iHB9QSbKwy2zV6ttDjYPgHpMzeB/SrUf7woylKDUgSW2CpEndd8ktXwv7l0oeiJQTDd1+zbEdwLg41uIecjl8qq22hcvgJPQxa2i+z6fP1Ylob+iyeoqkqDnjkpmKME8m/lngdp6VhNycb/Xf8HDbc/f+lRbn4AS7Ye9Ysblbp6ogUrTURMoT93Ivytsfy0dfRF0KpyYzf/zFpkaYQVkcB6fct4QFuc9jyC8ex1lgmBkj4cTiPoEwD9kiamrsZHw0qAwQrffSCZSh7hJ0ofsOGJCdrGgk2XHMyQIR05DPgeXipFLcwweheTx2BUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KphY0nexziHJ8xx+b9qdlFw6j59/C+D0P79fmBASfcE=;
 b=rEKAk+3+cS44NPCg1kBBo+RRRzaVUL9F4v0TICV4jksidX36QyiJZ6H41W7cqiEEOPWF5KX2gz4EEma1mIdO50gwOARZANRnvezlnuQ7dYdp0t4nqDbebJQPhtK1X+fLpxc7t5S2MG+tiLVyp4enmkF0OfL1ZFkMKvvxb9rIeGw=
Received: from CY5PR22CA0060.namprd22.prod.outlook.com (2603:10b6:930:1d::23)
 by MW3PR12MB4492.namprd12.prod.outlook.com (2603:10b6:303:57::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:48:50 +0000
Received: from CY4PEPF0000C978.namprd02.prod.outlook.com
 (2603:10b6:930:1d:cafe::46) by CY5PR22CA0060.outlook.office365.com
 (2603:10b6:930:1d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:48:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C978.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:48:50 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:48:49 -0600
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
Subject: [PATCH RFC v7 14/64] x86/sev: Add the host SEV-SNP initialization support
Date:   Wed, 14 Dec 2022 13:40:06 -0600
Message-ID: <20221214194056.161492-15-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C978:EE_|MW3PR12MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: c4d3f694-9ede-493e-0e1f-08dade0c3906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xFZFCMWmoc7enASiKwAQimkzH6Emc3BN1f+lhT3OttRWp78gGdSCyTwZck75gxZPSEMaK43WkevD1quulNeWJkUuxBuVyVWN7vZ+uPtmo11WF5R1gZeoY6yH+Q4HMUv1LtmyckLbhOyvTbBtseHvpjKEEgR9TRqv8hDbSkjfHBhFoB8OG1m58qCB6HqrEH6aJDAaSNfcDy/CaH0o/0paPbjIzpNMw05/Bd9px/t2jTdjy73qFi1zE5cPJ1Z4odKU8DrzXuORxPF/hUYO9mQmdOSn/HopDJlN6SjV8C0IdsmcCI2sUpeUPM+5WT1q+8BccYtRpm4IR/TA1ET2/P7rQy1mAJQK72WxDPex1aCM1xk1MpPzbJhirvbJgU3RFDnvPKWOY3EP4brL7hPwgYQX5vIvLHp+leW6cU4bgsAYsMEBcFJIHILvv0z+FX3b+ECFkN8JYt/G7G+fe6FrK448st0T3sOkw16k5KmtqwjeVw6iVQf11qSOHe2OWWKD9Rzb0QTluRyL+zubGW+gEfiohx5i8H4aEGw/nKpaRKzjeNm4HXiuldn5cZ94+d2yA+TuqQ6M4oDCOXc5bxHNxyVgxCnpuIGo/j6LEJX51E8Finq12xighVpuYvFin/K6ViOinFDwY2TveTIh8mwyqL4yAPK74i+BS4RZmsY1I89EPW1y4d85GnXr01H/7i5uzD7c7OB+QdCr2jPtVUeiLM5QYiQp25+tlr8WKkHvprvsG4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(81166007)(7406005)(41300700001)(8936002)(6666004)(478600001)(356005)(40460700003)(86362001)(82310400005)(82740400003)(40480700001)(36860700001)(2616005)(5660300002)(16526019)(44832011)(1076003)(336012)(70206006)(186003)(6916009)(8676002)(426003)(4326008)(316002)(70586007)(7416002)(83380400001)(26005)(2906002)(47076005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:48:50.2924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d3f694-9ede-493e-0e1f-08dade0c3906
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C978.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4492
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

Also set SYSCFG.MFMD when enabling SNP as SEV-SNP FW >= 1.51 requires
that SYSCFG.MFMD must be se

RMP table entry format is non-architectural and it can vary by processor
and is defined by the PPR. Restrict SNP support on the known CPU model
and family for which the RMP table entry format is currently defined for.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-b: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/msr-index.h         |  11 +-
 arch/x86/kernel/sev.c                    | 180 +++++++++++++++++++++++
 3 files changed, 197 insertions(+), 2 deletions(-)

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
index a428c62330d3..687a91284506 100644
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
@@ -2260,3 +2273,170 @@ static int __init snp_init_platform_device(void)
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
+	calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + totalram_pages()) << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
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
+	/* Initialize the RMP table to zero */
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
+static int __init snp_rmptable_init(void)
+{
+	int family, model;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	family = boot_cpu_data.x86;
+	model  = boot_cpu_data.x86_model;
+
+	/*
+	 * RMP table entry format is not architectural and it can vary by processor and
+	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
+	 * model and family for which the RMP table entry format is currently defined for.
+	 */
+	if (family != 0x19 || model > 0xaf)
+		goto nosnp;
+
+	if (amd_iommu_snp_enable())
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
+	return -ENOSYS;
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
+fs_initcall(snp_rmptable_init);
-- 
2.25.1

