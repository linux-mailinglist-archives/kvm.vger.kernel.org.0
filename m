Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7675C666CBF
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 09:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbjALIol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 03:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239964AbjALInw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 03:43:52 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE3F4E412;
        Thu, 12 Jan 2023 00:42:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuGXPP6gTTG1QKrWKH2mLcganAY5Ej9W+GDYB5ANDFFmgcFSNcf6R0ikZJ6AYYBfwKC/GOp8QoDC7iqPXyEOSwIptK2jV6+Sw0GBTzB8Mz+CBOGJpcvyV4DkKTW94/qkhMyS/M0HP/QHgvlcSQynY9Mzvg2WI4WPhBYqTYkEuX/VCf9lSu2QHe9gcImRGz9/CAdlmFJK6jxEjQKHsOFUG7M+ksgzn+mg2zxM0sm0gIWJbHTn91Fl0QVmjqK1SnsYfBT3WxH3cHACY2bUV2aASJHe/8+fke8oR5mCCokfeho+N17LjWY7g6BRmi0vM4CjwGy5VuLHT8LO05h09KA3+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xk3r7IsMp6vEsIrvmUXjz3hXKyNrFf7A8kcdsRUH1NI=;
 b=XkR7P9US8unWuf4UX3MDc54spRva/5wA5AbsAaU1SO8tI2SmIaI+hE3QAhQge3Cc7w1KvsnuSd3yeJJGUteA0Z8SAmWpB+GAdYRpxs+nqe+9nGANCcYjdy12IA/OM2trnc6FIEAYFBnAZXO3GgLkJLFLFjvAcv04V3a2kTaMqpjfOKxsy6vlElbdqGZ71/eZ0YUfwLgq9ZfblXJAna1GOG707Ps1W+QGMi96+UDq6wYvvfoAUbKSxFm2PL9zwfemQ38Htw0QOeqWaJ/iOGBD4ud0zSX3/vjE3y22H6oFA4SKbpYNj3cCrF+9icakxtfePPZc76HqTIAcNoKgXHND5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xk3r7IsMp6vEsIrvmUXjz3hXKyNrFf7A8kcdsRUH1NI=;
 b=gdYdiW5PlxBTpCbrsiDICM5cLEg07LjPeJZKHe+FJVbbhAC6Z5eHVz0ziiIP2+rK60Jwxy4TfddXHCSJf+U0WyVugZNpfALcYogSJ/8vYJ3HKy9Oc4qtRETiP0m/xzQD7rYeyAqE/fO+wSNisXelMoXEUhYgaW8AOzgX+/kiBCw=
Received: from DM6PR06CA0034.namprd06.prod.outlook.com (2603:10b6:5:120::47)
 by DM4PR12MB7621.namprd12.prod.outlook.com (2603:10b6:8:10a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 08:42:23 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::13) by DM6PR06CA0034.outlook.office365.com
 (2603:10b6:5:120::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 08:42:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 08:42:23 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 12 Jan
 2023 02:41:54 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <bp@alien8.de>
CC:     <mingo@redhat.com>, <tglx@linutronix.de>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <michael.roth@amd.com>, David Rientjes <rientjes@google.com>,
        <stable@kernel.org>
Subject: [PATCH v5] x86/sev: Add SEV-SNP guest feature negotiation support
Date:   Thu, 12 Jan 2023 14:11:39 +0530
Message-ID: <20230112084139.12615-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|DM4PR12MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: f1857ae4-6d75-4b5a-eca8-08daf478ecc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCYLhIN4G4aV7NJJ7habcdOwVKaWpMBR049Z/XBWpaHATBaZHFVKhS0ocP2jEWcoAaPs6NJaLs+Xk+w0uyPb13b6zJ11BbPGtG31HD4xN7LzXFdwlnRI/65MCP245/mjj3J5TRPSaBQXoearQkScjU3x2kF5jCyz6w1eooNdU/sBpjKNXfGOjSTzXLfm+AHm6l3x/L9XQ1mRrlXCiZ0cHKF5546bE0Pgvshpx6gcYeaqrePE3Yt3+Nyw/vWl71p9wrSy8hdVWdoMBnOw9yxFNEIixgcJLbLqx8xH2UDgbpdn2UQvFYXdxo7KJEUuagDqga42VUKjUcqIOum4mnSuEcJK73IP9Y2J4eXZnFgawuTqkj3GrJzmb6GseaoLvUm5OEIyfZmuyhqhzqiA+XF2EQVy2UcanshDTkOkaQrwiOMiSydtrEk7WBcP3ZrGRgcc6C125MZuuyteSFpiipZLvYttlaJfLUnBPMnfjPPnI7FkhsrAOcwAnUhWeB1s0eBiygghi8zgTvB5f4nucK0+Qr6JOpnex2yualebIA6Y6f9OHNjBkvlIRTqygyzXv2Y6eUdNt3pkvBS+9aDxGZ8ZcWe5JS5a+6/LtcvzRPICbfxUpNhSZh9fiqgIGRoDi4OoZ0Pw5o/VHf4uz2G0jDMO8mfKxqofcFlOhlFCpQ++RY+IK8+ypraV6Eic9HugAlaNrABbkV1G8N5iCCXUQS73MpCBSw6gpdHf5EwTkMUtnXIzbTLLMLP396zm4YKFKgLFPcdT8MTdxyYLMtEfaWq52O4hLxtd7PBJJCwSh+S4CavrWZNkOzMoVn5CnsPoRFir
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(2906002)(16526019)(7696005)(478600001)(186003)(6666004)(26005)(966005)(2616005)(54906003)(336012)(4326008)(30864003)(70586007)(36756003)(426003)(1076003)(8676002)(40480700001)(316002)(40460700003)(36860700001)(41300700001)(47076005)(82310400005)(5660300002)(110136005)(82740400003)(70206006)(8936002)(83380400001)(7416002)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 08:42:23.1015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1857ae4-6d75-4b5a-eca8-08daf478ecc2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hypervisor can enable various new features (SEV_FEATURES[1:63])
and start the SNP guest. Some of these features need guest side
implementation. If any of these features are enabled without guest
side implementation, the behavior of the SNP guest will be undefined.
The SNP guest boot may fail in a non-obvious way making it difficult
to debug.

Instead of allowing the guest to continue and have it fail randomly
later, detect this early and fail gracefully.

SEV_STATUS MSR indicates features which the hypervisor has enabled.
While booting, SNP guests should ascertain that all the enabled
features have guest side implementation. In case any feature is not
implemented in the guest, the guest terminates booting with GHCB
protocol Non-Automatic Exit(NAE) termination request event[1]. Populate
SW_EXITINFO2 with mask of unsupported features that the hypervisor
can easily report to the user.

More details in AMD64 APM[2] Vol 2: 15.34.10 SEV_STATUS MSR

[1] https://developer.amd.com/wp-content/resources/56421.pdf
    4.1.13 Termination Request

[2] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf

Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
CC: Borislav Petkov <bp@alien8.de>
CC: David Rientjes <rientjes@google.com>
CC: Michael Roth <michael.roth@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: <stable@kernel.org>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

---

Changes:
v4:
* Update comments and indentation
* Reuse GHCB MSR Protocol reason set
* Invalidate ghcb page before using
* GHCB protocol NAE termination event is available after version 2,
  verify ghcb version before using the termination event.

v3:
* Use GHCB protocol NAE termination event SEV-SNP feature(s)
  not supported along with SW_EXITINFO2 containing mask of the
  unsupported features. Need handling of this event on the HV.
* Add the SNP features check initialize_identity_maps() when the
  boot GHCB page can be initialized and used.
* Fixed sphinx warnings in documentation

v2:
* Updated Documentation/x86/amd-memory-encryption.rst
* Address review feedback from Boris/Tom

v1:
* Dropped _ENABLED from the feature bits
* Use approprate macro/function names and move closer to the function where
  it is used.
* More details added to the commit message and comments
* Fixed compilation issue
---
 Documentation/x86/amd-memory-encryption.rst | 36 ++++++++++++
 arch/x86/boot/compressed/head_64.S          |  9 +++
 arch/x86/boot/compressed/misc.h             |  1 +
 arch/x86/boot/compressed/sev.c              | 62 +++++++++++++++++++++
 arch/x86/include/asm/msr-index.h            | 20 +++++++
 arch/x86/include/uapi/asm/svm.h             |  6 ++
 arch/x86/kernel/sev-shared.c                |  5 ++
 7 files changed, 139 insertions(+)

diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
index a1940ebe7be5..b3adc39d7735 100644
--- a/Documentation/x86/amd-memory-encryption.rst
+++ b/Documentation/x86/amd-memory-encryption.rst
@@ -95,3 +95,39 @@ by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
 not enable SME, then Linux will not be able to activate memory encryption, even
 if configured to do so by default or the mem_encrypt=on command line parameter
 is specified.
+
+Secure Nested Paging (SNP)
+==========================
+
+SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be enabled
+by the hypervisor for security enhancements. Some of these features need
+guest side implementation to function correctly. The below table lists the
+expected guest behavior with various possible scenarios of guest/hypervisor
+SNP feature support.
+
++-----------------+---------------+---------------+------------------+
+| Feature Enabled | Guest needs   | Guest has     | Guest boot       |
+| by the HV       | implementation| implementation| behaviour        |
++=================+===============+===============+==================+
+|      No         |      No       |      No       |     Boot         |
+|                 |               |               |                  |
++-----------------+---------------+---------------+------------------+
+|      No         |      Yes      |      No       |     Boot         |
+|                 |               |               |                  |
++-----------------+---------------+---------------+------------------+
+|      No         |      Yes      |      Yes      |     Boot         |
+|                 |               |               |                  |
++-----------------+---------------+---------------+------------------+
+|      Yes        |      No       |      No       | Boot with        |
+|                 |               |               | feature enabled  |
++-----------------+---------------+---------------+------------------+
+|      Yes        |      Yes      |      No       | Graceful boot    |
+|                 |               |               | failure          |
++-----------------+---------------+---------------+------------------+
+|      Yes        |      Yes      |      Yes      | Boot with        |
+|                 |               |               | feature enabled  |
++-----------------+---------------+---------------+------------------+
+
+More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
+
+[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index a75712991df3..551d583fac9c 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -557,6 +557,15 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
 	/* Pass boot_params to initialize_identity_maps() */
 	movq	(%rsp), %rdi
 	call	initialize_identity_maps
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	/*
+	 * Now that the required page table mappings are established and a
+	 * GHCB can be used, check for SNP guest/HV feature compatibility.
+	 */
+	call	snp_check_features
+#endif
+
 	popq	%rsi
 
 /*
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 62208ec04ca4..593415e22614 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -126,6 +126,7 @@ static inline void console_init(void)
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 void sev_enable(struct boot_params *bp);
+void snp_check_features(void);
 void sev_es_shutdown_ghcb(void);
 extern bool sev_es_check_ghcb_fault(unsigned long address);
 void snp_set_page_private(unsigned long paddr);
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index c93930d5ccbd..40c5f8bc733d 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -270,6 +270,68 @@ static void enforce_vmpl0(void)
 		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
 }
 
+/*
+ * SNP_FEATURES_IMPL_REQ is the mask of SNP features that will need
+ * guest side implementation for proper functioning of the guest. If any
+ * of these features are enabled in the hypervisor but are lacking guest
+ * side implementation, the behavior of the guest will be undefined. The
+ * guest could fail in non-obvious way making it difficult to debug.
+ *
+ * As the behavior of reserved feature bits is unknown to be on the
+ * safe side add them to the required features mask.
+ */
+#define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |			\
+				 MSR_AMD64_SNP_REFLECT_VC |		\
+				 MSR_AMD64_SNP_RESTRICTED_INJ |		\
+				 MSR_AMD64_SNP_ALT_INJ |		\
+				 MSR_AMD64_SNP_DEBUG_SWAP |		\
+				 MSR_AMD64_SNP_VMPL_SSS |		\
+				 MSR_AMD64_SNP_SECURE_TSC |		\
+				 MSR_AMD64_SNP_VMGEXIT_PARAM |		\
+				 MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
+				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
+				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
+				 MSR_AMD64_SNP_RESERVED_MASK)
+
+/*
+ * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
+ * by the guest kernel. As and when a new feature is implemented in the
+ * guest kernel, a corresponding bit should be added to the mask.
+ */
+#define SNP_FEATURES_PRESENT (0)
+
+void snp_check_features(void)
+{
+	u64 unsupported_features;
+
+	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
+		return;
+
+	/*
+	 * Terminate the boot if hypervisor has enabled any feature
+	 * lacking guest side implementation.
+	 */
+	unsupported_features = sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT;
+	if (unsupported_features) {
+		u64 exit_info_1 = SVM_VMGEXIT_TERM_REASON(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
+
+		if (sev_es_get_ghcb_version() < 2 ||
+		    (!boot_ghcb && !early_setup_ghcb()))
+			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
+
+		vc_ghcb_invalidate(boot_ghcb);
+		ghcb_set_sw_exit_code(boot_ghcb, SVM_VMGEXIT_TERM_REQUEST);
+		ghcb_set_sw_exit_info_1(boot_ghcb, exit_info_1);
+		ghcb_set_sw_exit_info_2(boot_ghcb, unsupported_features);
+
+		sev_es_wr_ghcb_msr(__pa(boot_ghcb));
+		VMGEXIT();
+
+		while (true)
+			asm volatile("hlt\n" : : : "memory");
+	}
+}
+
 void sev_enable(struct boot_params *bp)
 {
 	unsigned int eax, ebx, ecx, edx;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 37ff47552bcb..d3fe82c5d6b6 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -566,6 +566,26 @@
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
 
+/* SNP feature bits enabled by the hypervisor */
+#define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
+#define MSR_AMD64_SNP_REFLECT_VC		BIT_ULL(4)
+#define MSR_AMD64_SNP_RESTRICTED_INJ		BIT_ULL(5)
+#define MSR_AMD64_SNP_ALT_INJ			BIT_ULL(6)
+#define MSR_AMD64_SNP_DEBUG_SWAP		BIT_ULL(7)
+#define MSR_AMD64_SNP_PREVENT_HOST_IBS		BIT_ULL(8)
+#define MSR_AMD64_SNP_BTB_ISOLATION		BIT_ULL(9)
+#define MSR_AMD64_SNP_VMPL_SSS			BIT_ULL(10)
+#define MSR_AMD64_SNP_SECURE_TSC		BIT_ULL(11)
+#define MSR_AMD64_SNP_VMGEXIT_PARAM		BIT_ULL(12)
+#define MSR_AMD64_SNP_IBS_VIRT			BIT_ULL(14)
+#define MSR_AMD64_SNP_VMSA_REG_PROTECTION	BIT_ULL(16)
+#define MSR_AMD64_SNP_SMT_PROTECTION		BIT_ULL(17)
+
+/* SNP feature bits reserved for future use. */
+#define MSR_AMD64_SNP_RESERVED_BIT13		BIT_ULL(13)
+#define MSR_AMD64_SNP_RESERVED_BIT15		BIT_ULL(15)
+#define MSR_AMD64_SNP_RESERVED_MASK		GENMASK_ULL(63, 18)
+
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
 /* AMD Collaborative Processor Performance Control MSRs */
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index f69c168391aa..a04fe07eb9a8 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -116,6 +116,12 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
+#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
+#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
+	/* SW_EXITINFO1[3:0] */					\
+	(((((u64)reason_set) &  0xf)) |				\
+	/* SW_EXITINFO1[11:4] */				\
+	((((u64)reason_code) & 0xff) << 4))
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 /* Exit code reserved for hypervisor/software use */
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 3a5b0c9c4fcc..38ec3386984a 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -158,6 +158,11 @@ static bool sev_es_negotiate_protocol(void)
 	return true;
 }
 
+static u16 sev_es_get_ghcb_version(void)
+{
+	return ghcb_version;
+}
+
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
 	ghcb->save.sw_exit_code = 0;
-- 
2.32.0

