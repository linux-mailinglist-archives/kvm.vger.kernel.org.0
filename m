Return-Path: <kvm+bounces-5368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58F8B820777
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:34:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 110B6282474
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84999C12B;
	Sat, 30 Dec 2023 16:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N6OrfSxp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1203B168A7;
	Sat, 30 Dec 2023 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjtaULWjEm1/e+/B7pe1HfZyXYX+bQD7ArizQMNyFsONOLOBkcu29FWTYnopEUPHRCRw0nlsk0JtRZmvKhCc5BOgNzp3YUhUkXcxRJ8hIZXsIO1O4wAf8aiSFUWUmPDgS+oBIoo8XejcNHbhcIa1EzUsAr91E83rtH92Vb5sddLA9szKnwVMOb7H7J6Bzc/psJS1h/5xN4ueiAKRR+3SW9ifMaaUeD/RzxT2GQ8kEWO0LfJMkCvzHcWOJKygN9TIVcU0fepfznMipY5UXU6shwqhNLCheXJWEe+wghFyldC7JvlLFKGbt9YZGqCVGj7QeDJrQjFwzgYysomdpQ9cUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhTFObKbairMGEk15tYxLwI5g62xwgKJDEcdqgz6Ngw=;
 b=D4K/ljpPbnlQDnUUhHQ/uY9Srnonv3pfZ+YEJzPWtBBuSoKu2WzGAObgjb3hjb/x7+39mZU/aXMkTD8/UKx5bQvNAeMsIB3AdXQs5YjUs1armpI7sACMbMnhErLE40llLsig9pmY9k/kFvINJ/SnH2lfdZQC4G5wMGol8Cs+jx7IudgPKRX3w+EOQ9/FRO7UT72NVkEwgDJXDtvFIw9R4TK101fa4zhLQPzpeacOb06aOAuBQo8LDs9zjuRVEe8g3yucTCfXL+Z4fp6KIgRA6mvFvQeMTXwVaQZ6Kxvmk/PB0/7RJjRaP/QMJypOhlf72U7pTssfxQxEf0yG5AoOkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhTFObKbairMGEk15tYxLwI5g62xwgKJDEcdqgz6Ngw=;
 b=N6OrfSxpCYune0roQX4NtvoPWvDxsBnz0FasIqKKe1kEbm0fWMBmcj4bvi0b0ImSsVY5FFHboxuxtv9jjPBd/PVXiWqgnpSndx+zLEfWEbHXJzK30GQNm/jWeEAzpGlMhvQhldMO4yL7tsTT8M/IvIN+QLzT0m9XWC7Yaej9mU8=
Received: from PR1P264CA0172.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:344::20)
 by MW3PR12MB4585.namprd12.prod.outlook.com (2603:10b6:303:54::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21; Sat, 30 Dec
 2023 16:30:11 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10a6:102:344:cafe::af) by PR1P264CA0172.outlook.office365.com
 (2603:10a6:102:344::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Sat, 30 Dec 2023 16:30:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:30:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:30:05 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization support
Date: Sat, 30 Dec 2023 10:19:32 -0600
Message-ID: <20231230161954.569267-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|MW3PR12MB4585:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b50c9fd-2ac2-49e4-42d3-08dc09549791
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rGQfRAr/tpKq8pXudKo1fGGvHf7ZWWQ0ZIEKZBxDWjdicwtJgLuAU7JLSY0jG4s1eMIygA9OxMVJEooisil29HAQCKV0oEfUzoTU2VrkOR0vcBl8+hjWfyqUw3fziUkCSDzNPdEF7APOCjad0dB/5/GWgFc3ZxwIf7pvRSnNqkx2kzW78igss29LyFrTX+f/eqoL5d0rnntQ7+YmbftSR78vPLeug8H+Idhcio5zh2EDGG14wSXl/qjes78M/uuWDXjC3M7XjA6VCtBLtimtVCTLu+U6pRWB4Q6ag9KW6NuQK/KPkN5hUSo0fMQQNZYa46z5yeGIgIzRSXQeWOGYFnJBI464gCJ0Jq5kk0nw3LklDGrvVgnsZj6tl42HdTXW0RPpYaHsb7iRCBR2LodCbb0IyEWZHuJax9BjzH1POq8VcXZZm2yfdG02VK81atniGwFvaT2k3t4jJqU+yNMMnV3c8YSEiCdcAyAlVez2IyyDPD6J2uBcGzUANwo9k/xekaFatUF7EPVyqoe51hjLnRhDtCCRVSYNottDsPMFMOVZheM2noeiHz/q4BtnN6GM5ieKt7RgYrqsU1Vr0J2bd1DZoz3cLYaZT0Px53wPJILHlgnQgp4WH31AnOC0fVj4OidvFbWbtIMy+V0XxOoRCe6Jy2xXekcKT1uGwEAh4MOyg2pTESMOX6LROy7ddpieiYotGuYG9rocQ4rBWrlqB83hJZQmJuBWs28kjZLKR4hsEiMyWG9vcZxw+YmD8rt5pf8zrrPuaMjMec3L8R/GBQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(39860400002)(346002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(82310400011)(40470700004)(36840700001)(46966006)(26005)(1076003)(336012)(83380400001)(81166007)(16526019)(356005)(426003)(2616005)(47076005)(36860700001)(41300700001)(82740400003)(2906002)(316002)(4326008)(54906003)(30864003)(7416002)(70586007)(5660300002)(40480700001)(70206006)(44832011)(6916009)(40460700003)(36756003)(86362001)(8676002)(6666004)(8936002)(478600001)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:30:10.3925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b50c9fd-2ac2-49e4-42d3-08dc09549791
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4585

From: Brijesh Singh <brijesh.singh@amd.com>

The memory integrity guarantees of SEV-SNP are enforced through a new
structure called the Reverse Map Table (RMP). The RMP is a single data
structure shared across the system that contains one entry for every 4K
page of DRAM that may be used by SEV-SNP VMs. APM2 section 15.36 details
a number of steps needed to detect/enable SEV-SNP and RMP table support
on the host:

 - Detect SEV-SNP support based on CPUID bit
 - Initialize the RMP table memory reported by the RMP base/end MSR
   registers and configure IOMMU to be compatible with RMP access
   restrictions
 - Set the MtrrFixDramModEn bit in SYSCFG MSR
 - Set the SecureNestedPagingEn and VMPLEn bits in the SYSCFG MSR
 - Configure IOMMU

RMP table entry format is non-architectural and it can vary by
processor. It is defined by the PPR. Restrict SNP support to CPU
models/families which are compatible with the current RMP table entry
format to guard against any undefined behavior when running on other
system types. Future models/support will handle this through an
architectural mechanism to allow for broader compatibility.

SNP host code depends on CONFIG_KVM_AMD_SEV config flag, which may be
enabled even when CONFIG_AMD_MEM_ENCRYPT isn't set, so update the
SNP-specific IOMMU helpers used here to rely on CONFIG_KVM_AMD_SEV
instead of CONFIG_AMD_MEM_ENCRYPT.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/Kbuild                  |   2 +
 arch/x86/include/asm/msr-index.h |  11 +-
 arch/x86/include/asm/sev.h       |   6 +
 arch/x86/kernel/cpu/amd.c        |  15 +++
 arch/x86/virt/svm/Makefile       |   3 +
 arch/x86/virt/svm/sev.c          | 219 +++++++++++++++++++++++++++++++
 6 files changed, 255 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/virt/svm/Makefile
 create mode 100644 arch/x86/virt/svm/sev.c

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index 5a83da703e87..6a1f36df6a18 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -28,5 +28,7 @@ obj-y += net/
 
 obj-$(CONFIG_KEXEC_FILE) += purgatory/
 
+obj-y += virt/svm/
+
 # for cleaning
 subdir- += boot tools
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index f1bd7b91b3c6..15ce1269f270 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -599,6 +599,8 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_RMP_BASE		0xc0010132
+#define MSR_AMD64_RMP_END		0xc0010133
 
 /* SNP feature bits enabled by the hypervisor */
 #define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
@@ -709,7 +711,14 @@
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
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 5b4a1ce3d368..1f59d8ba9776 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -243,4 +243,10 @@ static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 #endif
 
+#ifdef CONFIG_KVM_AMD_SEV
+bool snp_probe_rmptable_info(void);
+#else
+static inline bool snp_probe_rmptable_info(void) { return false; }
+#endif
+
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9a17165dfe84..0f0d425f0440 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -20,6 +20,7 @@
 #include <asm/delay.h>
 #include <asm/debugreg.h>
 #include <asm/resctrl.h>
+#include <asm/sev.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/mmconfig.h>
@@ -574,6 +575,20 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		break;
 	}
 
+	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
+		/*
+		 * RMP table entry format is not architectural and it can vary by processor
+		 * and is defined by the per-processor PPR. Restrict SNP support on the
+		 * known CPU model and family for which the RMP table entry format is
+		 * currently defined for.
+		 */
+		if (!(c->x86 == 0x19 && c->x86_model <= 0xaf) &&
+		    !(c->x86 == 0x1a && c->x86_model <= 0xf))
+			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+		else if (!snp_probe_rmptable_info())
+			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+	}
+
 	return;
 
 warn:
diff --git a/arch/x86/virt/svm/Makefile b/arch/x86/virt/svm/Makefile
new file mode 100644
index 000000000000..ef2a31bdcc70
--- /dev/null
+++ b/arch/x86/virt/svm/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_KVM_AMD_SEV) += sev.o
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
new file mode 100644
index 000000000000..ce7ede9065ed
--- /dev/null
+++ b/arch/x86/virt/svm/sev.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD SVM-SEV Host Support.
+ *
+ * Copyright (C) 2023 Advanced Micro Devices, Inc.
+ *
+ * Author: Ashish Kalra <ashish.kalra@amd.com>
+ *
+ */
+
+#include <linux/cc_platform.h>
+#include <linux/printk.h>
+#include <linux/mm_types.h>
+#include <linux/set_memory.h>
+#include <linux/memblock.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/cpumask.h>
+#include <linux/iommu.h>
+#include <linux/amd-iommu.h>
+
+#include <asm/sev.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+#include <asm/svm.h>
+#include <asm/smp.h>
+#include <asm/cpu.h>
+#include <asm/apic.h>
+#include <asm/cpuid.h>
+#include <asm/cmdline.h>
+#include <asm/iommu.h>
+
+/*
+ * The RMP entry format is not architectural. The format is defined in PPR
+ * Family 19h Model 01h, Rev B1 processor.
+ */
+struct rmpentry {
+	u64	assigned	: 1,
+		pagesize	: 1,
+		immutable	: 1,
+		rsvd1		: 9,
+		gpa		: 39,
+		asid		: 10,
+		vmsa		: 1,
+		validated	: 1,
+		rsvd2		: 1;
+	u64 rsvd3;
+} __packed;
+
+/*
+ * The first 16KB from the RMP_BASE is used by the processor for the
+ * bookkeeping, the range needs to be added during the RMP entry lookup.
+ */
+#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
+
+static u64 probed_rmp_base, probed_rmp_size;
+static struct rmpentry *rmptable __ro_after_init;
+static u64 rmptable_max_pfn __ro_after_init;
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
+#define RMP_ADDR_MASK GENMASK_ULL(51, 13)
+
+bool snp_probe_rmptable_info(void)
+{
+	u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
+
+	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
+	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
+
+	if (!(rmp_base & RMP_ADDR_MASK) || !(rmp_end & RMP_ADDR_MASK)) {
+		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
+		return false;
+	}
+
+	if (rmp_base > rmp_end) {
+		pr_err("RMP configuration not valid: base=%#llx, end=%#llx\n", rmp_base, rmp_end);
+		return false;
+	}
+
+	rmp_sz = rmp_end - rmp_base + 1;
+
+	/*
+	 * Calculate the amount the memory that must be reserved by the BIOS to
+	 * address the whole RAM, including the bookkeeping area. The RMP itself
+	 * must also be covered.
+	 */
+	max_rmp_pfn = max_pfn;
+	if (PHYS_PFN(rmp_end) > max_pfn)
+		max_rmp_pfn = PHYS_PFN(rmp_end);
+
+	calc_rmp_sz = (max_rmp_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
+
+	if (calc_rmp_sz > rmp_sz) {
+		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
+		       calc_rmp_sz, rmp_sz);
+		return false;
+	}
+
+	probed_rmp_base = rmp_base;
+	probed_rmp_size = rmp_sz;
+
+	pr_info("RMP table physical range [0x%016llx - 0x%016llx]\n",
+		probed_rmp_base, probed_rmp_base + probed_rmp_size - 1);
+
+	return true;
+}
+
+static int __init __snp_rmptable_init(void)
+{
+	u64 rmptable_size;
+	void *rmptable_start;
+	u64 val;
+
+	if (!probed_rmp_size)
+		return 1;
+
+	rmptable_start = memremap(probed_rmp_base, probed_rmp_size, MEMREMAP_WB);
+	if (!rmptable_start) {
+		pr_err("Failed to map RMP table\n");
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
+	memset(rmptable_start, 0, probed_rmp_size);
+
+	/* Flush the caches to ensure that data is written before SNP is enabled. */
+	wbinvd_on_all_cpus();
+
+	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
+	on_each_cpu(mfd_enable, NULL, 1);
+
+	on_each_cpu(snp_enable, NULL, 1);
+
+skip_enable:
+	rmptable_start += RMPTABLE_CPU_BOOKKEEPING_SZ;
+	rmptable_size = probed_rmp_size - RMPTABLE_CPU_BOOKKEEPING_SZ;
+
+	rmptable = (struct rmpentry *)rmptable_start;
+	rmptable_max_pfn = rmptable_size / sizeof(struct rmpentry) - 1;
+
+	return 0;
+}
+
+static int __init snp_rmptable_init(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	if (!amd_iommu_snp_en)
+		return 0;
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
+ * This must be called after the IOMMU has been initialized.
+ */
+device_initcall(snp_rmptable_init);
-- 
2.25.1


