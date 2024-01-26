Return-Path: <kvm+bounces-7072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D659583D3BD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41BB7B24698
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231E112E57;
	Fri, 26 Jan 2024 04:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VDIeUJNs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616EF14A81;
	Fri, 26 Jan 2024 04:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244475; cv=fail; b=Jap1LBkyOEM8Ny/J5/oYvJ0/UoYWTO7ZvM0jYYt44sayG3hu5Tg0YKtyllxHzT6J4PrGrJys+C27BzKcWMRgUXrxDrqc4QT7rvEj3vrkuIxZ82KXj3bjTR4jVFqVCoM+hdpo+fM0rc99Qtx4rwqVCLAdB8Bo3ZQ2mZ3IWjIMJHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244475; c=relaxed/simple;
	bh=Q8YGlkH8jrvgXayRuAMNwbZ33Oikj0SxcYLhtYmXvOo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bu5ogl2ecPUL5CBQANkxraBm7Lx9CG5t0tdUzTjRmdAaxubkESigmHvUReKKoWeVLSvQsqYGyA1scB6ti4g0wr1o99Y1+MT7V4oxM4eHvctFtG1rcweRGHsY4DH/dVUrd9iy/FWw7Td4+noNm8NgGNxNfgQwOu3dFQ9cQcHdcvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VDIeUJNs; arc=fail smtp.client-ip=40.107.237.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHMe/JkGzdHxP8twb6fChAw8gQvajWedazTVciiRwC7JoH+3kPUb0b/69oMRsc/Lo9DDapZioz3kkoHydWxXwl3VatvHZ+wOX3P/fG2QkGkod0DVhvtCcPBrdqcC//eFsX1JY0m1sHbHAaoBsQUdsWcea9rIktBrIDp3sGsIElVYQuJE2TjcAJ/JpHjzsiQzQDQxbvoc0ySoIELb9T8Owsq+B1SUIjeDFChJDX/Px1Q+nmXiWuZTqH24WeoDWLcha2MFoXOWrhxdnbyBvz1uXQ4JHJy6NUj8ZzSp9JMBqBh/HLvS5Xn0oxQ3fAybgc5pjpku8zE5Z0c3Ehp2ye965g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBxBpWLLh4SxtbEWcLpyIsbUIEYmQcgwhc3PL61stys=;
 b=M7lxUyruAbxOfEaRbm3wWqTdmKcjVUUKrXCBz1mriPp4SjhKcP3nvJs9C6t0IVKQ2kZOEsaMb66rdRJfeEwLAVPHjUMgG4SP+Lq94B7Lrf7enqbop20nUnrPakajh0oKUrbCIw1T4mZgGmPkjKT0MgTXC5FHPHUqoplLZesXXtVYLhyr9hyOnq/M6E6BhstAVhdy6rMfWjFCazCoK0HTZAFJnmGm+7eKDUFPQN2b2zmmXyZmQ/4GRf5MfwC/UARsREQU9MMi14bFvmP4Jx4T4+e1DBOa4M+szX+foemUTfI0G8hprKLlj1vYD+0fZ+xnVltkWc6fvba6FfGq7QEwJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBxBpWLLh4SxtbEWcLpyIsbUIEYmQcgwhc3PL61stys=;
 b=VDIeUJNsV+jYIZ0DOYtyphKyRTSxGDpZtRiyrjA44hqdiketwB+3ZJ7fY0KxIwmXwaaMbZQb/W4Lw12+NKdgiT/5yjaTcRLeTRHMgCo1ElFCISGrkQu4xGiseZLBXdCB3Gn1QwZTJ3aRjHAf0ZzkTXDRuFX5vizBOGL7MOF1yTg=
Received: from DM6PR08CA0035.namprd08.prod.outlook.com (2603:10b6:5:80::48) by
 PH7PR12MB6906.namprd12.prod.outlook.com (2603:10b6:510:1b8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.32; Fri, 26 Jan 2024 04:47:47 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::44) by DM6PR08CA0035.outlook.office365.com
 (2603:10b6:5:80::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22 via Frontend
 Transport; Fri, 26 Jan 2024 04:47:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:47:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:47:45 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v2 04/25] x86/sev: Add the host SEV-SNP initialization support
Date: Thu, 25 Jan 2024 22:11:04 -0600
Message-ID: <20240126041126.1927228-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|PH7PR12MB6906:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eabc104-c699-4330-dead-08dc1e29f180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M5cjxA2CEZ+fq5KJEv3P05gNOK2/idubEfRpL6we+PfGzsmg3gdlygs+7l3tBA85ObKR+VN20csw6tMEdIpoEJ4YhlXSESuUuFERtTfuG0S1y5OHo/lHJXh7z//nvaTyg6RuChctiIH98RrOPvez7gMV/LtxNenFp/fMQaSbORpbGPrZcXQOktYjAegaHt3zjXb4yPLtOJXGPdvNwdNkVdAeTDh9IfX4G03VvmFswx+SkVtQCV3Wgfa5I2HWVnXkIBVDcDqylZvRz/BAhcQT3kyu5E7pA9qNxgByf0m04XJSME+la6vlmmq3SSx4eTCK8Xn9RWWFi4Zbkn84Kjo6tlxrYPgE/P3HSj61jb7A2rT+OHHglrz0HxWMhC19/72u9JDxGxZQANG9Xq3yo7VNVo08G+l8xcYORuvaL7ENyF3Znr5MOOVv5zNqVJQVG0bBZFYNQeys3+1cj87Lxxu/fZ4afJYme/0NFZXmj9J/IFe6LBCFvP2pgh72S31nUaTGrxmNwtP/qVW+D07B+fikFBSuCXCvsAU0rnl0RNvZj2nMsuIgG176IeYP5wqI4MZHnq8s059d5Pprf/9m4g0Br4qwfgRobOPPMnSFzam9mJGD/b0dHEteT3RQ/51S9C6QnWJqIug99eNdDOg9IFlUbGDLusHhuSHn/oab0NjPfByV5bqVMveCVbIlaX6hpe5SVsKGDucHR2Vxo9GgeBU1CNGKbr2H6Rc5+7q5ceod5963H6YxNydPstlb0vshHLRaJOuGtL+cJ4rI82TYTDlFBg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(1800799012)(64100799003)(82310400011)(451199024)(186009)(46966006)(36840700001)(40470700004)(30864003)(40480700001)(82740400003)(40460700003)(6666004)(36860700001)(478600001)(356005)(7416002)(2906002)(5660300002)(7406005)(81166007)(86362001)(1076003)(8676002)(2616005)(41300700001)(6916009)(316002)(44832011)(47076005)(54906003)(70586007)(26005)(16526019)(426003)(4326008)(36756003)(336012)(83380400001)(8936002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:47:47.3233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eabc104-c699-4330-dead-08dc1e29f180
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6906

From: Brijesh Singh <brijesh.singh@amd.com>

The memory integrity guarantees of SEV-SNP are enforced through a new
structure called the Reverse Map Table (RMP). The RMP is a single data
structure shared across the system that contains one entry for every 4K
page of DRAM that may be used by SEV-SNP VMs. The APM Volume 2 section
on Secure Nested Paging (SEV-SNP) details a number of steps needed to
detect/enable SEV-SNP and RMP table support on the host:

 - Detect SEV-SNP support based on CPUID bit
 - Initialize the RMP table memory reported by the RMP base/end MSR
   registers and configure IOMMU to be compatible with RMP access
   restrictions
 - Set the MtrrFixDramModEn bit in SYSCFG MSR
 - Set the SecureNestedPagingEn and VMPLEn bits in the SYSCFG MSR
 - Configure IOMMU

RMP table entry format is non-architectural and it can vary by
processor. It is defined by the PPR document for each respective CPU
family. Restrict SNP support to CPU models/families which are compatible
with the current RMP table entry format to guard against any undefined
behavior when running on other system types. Future models/support will
handle this through an architectural mechanism to allow for broader
compatibility.

SNP host code depends on CONFIG_KVM_AMD_SEV config flag which may be
enabled even when CONFIG_AMD_MEM_ENCRYPT isn't set, so update the
SNP-specific IOMMU helpers used here to rely on CONFIG_KVM_AMD_SEV
instead of CONFIG_AMD_MEM_ENCRYPT.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/Kbuild                  |   2 +
 arch/x86/include/asm/msr-index.h |  11 +-
 arch/x86/include/asm/sev.h       |   6 +
 arch/x86/kernel/cpu/amd.c        |  16 +++
 arch/x86/virt/svm/Makefile       |   3 +
 arch/x86/virt/svm/sev.c          | 216 +++++++++++++++++++++++++++++++
 6 files changed, 253 insertions(+), 1 deletion(-)
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
index f1bd7b91b3c6..f482bc6a5ae7 100644
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
@@ -708,8 +710,15 @@
 #define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K8_TOP_MEM2			0xc001001d
 #define MSR_AMD64_SYSCFG		0xc0010010
-#define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
+#define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT 23
 #define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
+#define MSR_AMD64_SYSCFG_SNP_EN_BIT	24
+#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT 25
+#define MSR_AMD64_SYSCFG_SNP_VMPL_EN	BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
+#define MSR_AMD64_SYSCFG_MFDM_BIT	19
+#define MSR_AMD64_SYSCFG_MFDM		BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
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
index 79153e9b92b5..f48c51640c65 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -20,6 +20,7 @@
 #include <asm/delay.h>
 #include <asm/debugreg.h>
 #include <asm/resctrl.h>
+#include <asm/sev.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/mmconfig.h>
@@ -584,6 +585,21 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		break;
 	}
 
+	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
+		/*
+		 * RMP table entry format is not architectural and it can vary by processor
+		 * and is defined by the per-processor PPR. Restrict SNP support on the
+		 * known CPU model and family for which the RMP table entry format is
+		 * currently defined for.
+		 */
+		if (!boot_cpu_has(X86_FEATURE_ZEN3) &&
+		    !boot_cpu_has(X86_FEATURE_ZEN4) &&
+		    !boot_cpu_has(X86_FEATURE_ZEN5))
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
index 000000000000..575a9ff046cb
--- /dev/null
+++ b/arch/x86/virt/svm/sev.c
@@ -0,0 +1,216 @@
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
+/*
+ * Do the necessary preparations which are verified by the firmware as
+ * described in the SNP_INIT_EX firmware command description in the SNP
+ * firmware ABI spec.
+ */
+static int __init snp_rmptable_init(void)
+{
+	void *rmptable_start;
+	u64 rmptable_size;
+	u64 val;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	if (!amd_iommu_snp_en)
+		return 0;
+
+	if (!probed_rmp_size)
+		goto nosnp;
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


