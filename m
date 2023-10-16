Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57E07CAA70
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbjJPNug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbjJPNuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:50:05 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2074.outbound.protection.outlook.com [40.107.101.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7EB19B;
        Mon, 16 Oct 2023 06:49:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6j2xcICb1WAYW5katjxyQMK2ypvYMDkXjd4opOZ4jQCUn+h2V/mRKpqs0PbSUH/m6ZAQGP2usA78Jq+rNqA/IYMeMc+4442ssWSV+K/obeqvoGkdnW3YYy9RiA7FvXpefdIOVkGOl8FUWuymnmxE371ldqOq/goPVOtMyw0clS+uljZ8q9IEW7rnkyfh5g4tH3pvOAevA6BLrw2+Bnfp64+GRIq5IRPOcczTex+76C2BJ+jK3c1RdBdPl3p4qeCG6HZ17h87MviP2bJ9qI2Eqb2snN7TBMUZUSKnPzHnzFNcih0uoz4/QZYjlea3a1t4aMkubWoTZ7K8XFHDHMxGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaqUouGlsYXtY0U9PF+0ZlezqzxFih9kU8fhmzX1CWs=;
 b=MYiLHN+dHD8Dxl9XRxrJvFbOkwGo5mX+Tv5jB42AYJktxjHLXq5zj9ucLpFaaI2keagdv2xOT40ZUIjWHfOWuRwni2Q/DDhwNPIEyNStmQWQQ4Go4EGcCj4vYqXft/1NtlDiwcKETF7NaA6ivDbfh8OyvocQd8pPkr3NJLLgGeV1q+KqcOOAMNML4pax2jmfvv/zxaNwKLtO/GHY4tsy8oHfsS22LTztvGwWF40Z/3RG0KUPsyLU4XXMFmqvG86MFfHYGrKPZrwbsoodbWTqjeA/ZsVE0krt+MBLtBFLIImaSIHgK/UZLjR9Hh3SyfR1srSholn/1N7PRyebItQcjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaqUouGlsYXtY0U9PF+0ZlezqzxFih9kU8fhmzX1CWs=;
 b=AtUj9Oe5EWPTX447mi9BJrfAk8zbh1nvHMwaUdyebkw++ow/u/5esyvTYVSlNnfINvPfzH1ZFqrx3uN3Mw33sLE2tn4QkqehM0WIjdeUDdy7bweYM2tpJDVkabj+xbbtC1tWNh2M6eoriKtJxa1QW/2NYOaov6ZJtVut0wrBBSI=
Received: from BL1PR13CA0399.namprd13.prod.outlook.com (2603:10b6:208:2c2::14)
 by SJ2PR12MB8956.namprd12.prod.outlook.com (2603:10b6:a03:53a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:49:28 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2c2:cafe::4e) by BL1PR13CA0399.outlook.office365.com
 (2603:10b6:208:2c2::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:49:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:49:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:49:25 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization support
Date:   Mon, 16 Oct 2023 08:27:35 -0500
Message-ID: <20231016132819.1002933-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|SJ2PR12MB8956:EE_
X-MS-Office365-Filtering-Correlation-Id: ee9467dc-b333-407f-a278-08dbce4eb746
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sDxYiY0XsI3LBawxOu3aet6qCy52U5gLQgvnKsFkShy5ipSezLMfAdrRKYFsYRI97Y2yEy3K3FEoEzYIvZIjYs1vZxuL4zZ0zWcuuRJY/stkvZ3zH36YC74xVeslGEkaV7YDJqT9WLQ8/pDRA7PKh/aC/tYYkChiyGTNMzX4IJ1yhZwdPsLkpDGnEtIepwVCWHyXSQa05DpUxzSYzsocNbAIUtuUaTJtf9LL/9JDliZ3irPPHl8tciSNsDE4vA3olQcBy7r1KxFBFA/O71Y63Jr3q2m7qr79Js7ulK0vwBlTQMsWRNkFTlisty3506Iqyh8ulMBu3CGdkbqiOwDtbAFaZ58rx9Vtn9dN2uVBEXKwEcoYDG3lTr45/2sLNxE5HoeCus5LYOLP1pO/c4yeWUUS3cToD8D6vJf01O27z71A15fA5Ek8HDI6+zm5KCPXzxVxBVaP+xAuDiy/eBUy/AcAdRX6BsWN9b6ZjGIVvLnQUlfPtajp061BHMTdsbW8vHlkHSRBlyiveyYPuAIW4V+6sPBeddxEoPNSCsZCJskY5noBJhc16kN26Y6ywqgg6ajvAuQE9g4Fv1eliHEjmgfZfWfg+hd04M30ZEWAB9mSeyQGdqPHcRzAQwObgpvDmUd5QHjnkQICFAppGe6NbV6v99RugJ0TWIj1h8rHg914qLnnONgqrt/sTK87RjW2zJ8n0TmFCz16GKKAGR46Ir6vRS4u1PjCSPRGmQAc3aJxHgeJy++nITedyL4wOtsTncQXJ6SNKxB2TwRzIeadtg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(346002)(136003)(230922051799003)(1800799009)(186009)(82310400011)(64100799003)(451199024)(46966006)(36840700001)(40470700004)(40460700003)(336012)(426003)(2616005)(16526019)(1076003)(36860700001)(30864003)(83380400001)(47076005)(7416002)(7406005)(54906003)(70206006)(8676002)(4326008)(316002)(8936002)(70586007)(6916009)(6666004)(41300700001)(5660300002)(44832011)(81166007)(478600001)(2906002)(82740400003)(356005)(40480700001)(86362001)(36756003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:49:25.4906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9467dc-b333-407f-a278-08dbce4eb746
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8956
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
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

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
[mdr: rework commit message to be clearer about what patch does, squash
      in early_rmptable_check() handling from Tom]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/Kbuild                          |   2 +
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/msr-index.h         |  11 +-
 arch/x86/include/asm/sev.h               |   6 +
 arch/x86/kernel/cpu/amd.c                |  19 ++
 arch/x86/virt/svm/Makefile               |   3 +
 arch/x86/virt/svm/sev.c                  | 239 +++++++++++++++++++++++
 drivers/iommu/amd/init.c                 |   2 +-
 include/linux/amd-iommu.h                |   2 +-
 9 files changed, 288 insertions(+), 4 deletions(-)
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
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 702d93fdd10e..83efd407033b 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -117,6 +117,12 @@
 #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
 #endif
 
+#ifdef CONFIG_KVM_AMD_SEV
+# define DISABLE_SEV_SNP	0
+#else
+# define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -141,7 +147,7 @@
 			 DISABLE_ENQCMD)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	(DISABLE_IBT)
-#define DISABLED_MASK19	0
+#define DISABLED_MASK19	(DISABLE_SEV_SNP)
 #define DISABLED_MASK20	0
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d111350197f..2be74afb4cbd 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -589,6 +589,8 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_RMP_BASE		0xc0010132
+#define MSR_AMD64_RMP_END		0xc0010133
 
 /* SNP feature bits enabled by the hypervisor */
 #define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
@@ -690,7 +692,14 @@
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
index 5b4a1ce3d368..b05fcd0ab7e4 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -243,4 +243,10 @@ static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 #endif
 
+#ifdef CONFIG_KVM_AMD_SEV
+bool snp_get_rmptable_info(u64 *start, u64 *len);
+#else
+static inline bool snp_get_rmptable_info(u64 *start, u64 *len) { return false; }
+#endif
+
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 14ee7f750cc7..6cc2074fcea3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -20,6 +20,7 @@
 #include <asm/delay.h>
 #include <asm/debugreg.h>
 #include <asm/resctrl.h>
+#include <asm/sev.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/mmconfig.h>
@@ -618,6 +619,20 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 	resctrl_cpu_detect(c);
 }
 
+static bool early_rmptable_check(void)
+{
+	u64 rmp_base, rmp_size;
+
+	/*
+	 * For early BSP initialization, max_pfn won't be set up yet, wait until
+	 * it is set before performing the RMP table calculations.
+	 */
+	if (!max_pfn)
+		return true;
+
+	return snp_get_rmptable_info(&rmp_base, &rmp_size);
+}
+
 static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 {
 	u64 msr;
@@ -659,6 +674,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 		if (!(msr & MSR_K7_HWCR_SMMLOCK))
 			goto clear_sev;
 
+		if (cpu_has(c, X86_FEATURE_SEV_SNP) && !early_rmptable_check())
+			goto clear_snp;
+
 		return;
 
 clear_all:
@@ -666,6 +684,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
 		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
+clear_snp:
 		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 	}
 }
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
index 000000000000..8b9ed72489e4
--- /dev/null
+++ b/arch/x86/virt/svm/sev.c
@@ -0,0 +1,239 @@
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
+static struct rmpentry *rmptable_start __ro_after_init;
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
+bool snp_get_rmptable_info(u64 *start, u64 *len)
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
+	*start = rmp_base;
+	*len = rmp_sz;
+
+	return true;
+}
+
+static __init int __snp_rmptable_init(void)
+{
+	u64 rmp_base, rmp_size;
+	void *rmp_start;
+	u64 val;
+
+	if (!snp_get_rmptable_info(&rmp_base, &rmp_size))
+		return 1;
+
+	pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n",
+		rmp_base, rmp_base + rmp_size - 1);
+
+	rmp_start = memremap(rmp_base, rmp_size, MEMREMAP_WB);
+	if (!rmp_start) {
+		pr_err("Failed to map RMP table addr 0x%llx size 0x%llx\n", rmp_base, rmp_size);
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
+	memset(rmp_start, 0, rmp_size);
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
+	rmp_start += RMPTABLE_CPU_BOOKKEEPING_SZ;
+	rmp_size -= RMPTABLE_CPU_BOOKKEEPING_SZ;
+
+	rmptable_start = (struct rmpentry *)rmp_start;
+	rmptable_max_pfn = rmp_size / sizeof(struct rmpentry) - 1;
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
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 45efb7e5d725..1c9924de607a 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3802,7 +3802,7 @@ int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn, u64
 	return iommu_pc_get_set_reg(iommu, bank, cntr, fxn, value, true);
 }
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
+#ifdef CONFIG_KVM_AMD_SEV
 int amd_iommu_snp_enable(void)
 {
 	/*
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 99a5201d9e62..55fc03cb3968 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -205,7 +205,7 @@ int amd_iommu_pc_get_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn,
 		u64 *value);
 struct amd_iommu *get_amd_iommu(unsigned int idx);
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
+#ifdef CONFIG_KVM_AMD_SEV
 int amd_iommu_snp_enable(void);
 #endif
 
-- 
2.25.1

