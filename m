Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278786654C7
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 07:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjAKGqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 01:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjAKGqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 01:46:05 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3568921BE;
        Tue, 10 Jan 2023 22:46:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyfwlzil95HSlPC1zjKbAg7hxGO2GGW0dLBNRa/PA9Q9QD6tWeMeX7pCBpbu8zKJx3aLXxhX3W1govruK8U97UsoRLLBUbX1Eb1+/U8KtEnn9w8Jol7lI8VLnp93zl1XW08QkWh8dudUSX7eqpl4u2Hax+AiDOlFNSgzD2YzTLCeQT66kWgoJZnGSwU1uqululssat6lhX+cMaK3aAuyRy4e8lv6iYRDilpLi7Mcq5QKt2Icoolsqa+S0tGfCvIKXXCz4yZTTFNelK/p81ARRSSiQvR7+T3PUtup5PWggHUap9hdzRybHGLnaHjO+hBRTTZ5NGyBPF9ImpPiCTcVnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvYG36sDU2hdu8ouZWIl90XkRWHIg84wVo+9LXhVAjI=;
 b=kChA9EaRtzpLK7NVPoVujwh5dOOe7hHwp0S61KuNQOU+TO7hInElprq5dHxZmGTtaICIK3zLRHVzqB+6V4CDs85yYnhD7IYcdOlSUET+MCfVS8JuMF/fcxWnhJ5drjuKtD7u47DKSJekaDx8iuYazR0JpCN24WIDmg+4WdMuuk2co8fj350R/QGDahBlBQHyr4RXpCvpDAQWdL2rGniRTq6SSGRl28AEWW7VmbbbSDwWfd5oNNcL8IGIbLMjUvU2BZgAYT/FeXqopr+4bxsI/j02MpBreCpazMmbAec0WytTgFYmJhovgA9rbMLWKHsZNN0XKOk11TXooAc2cdgS7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvYG36sDU2hdu8ouZWIl90XkRWHIg84wVo+9LXhVAjI=;
 b=erdSMSFDLyRilyJstduIRcW+RN2EDGkA3Oa18iHmOidlYtbhuv2nrE/DYsCcCpT3N3if2FsboOLaENiTKeH1sJ9snnQfoNQIho7g6Cw9WMYul8AakZs0q2h/byPUaIKBmsQ+gUtX7tv9H7c5kAP642qjw2OkjSFjApgLG2Wt1FU=
Received: from DS7PR03CA0057.namprd03.prod.outlook.com (2603:10b6:5:3b5::32)
 by IA1PR12MB6042.namprd12.prod.outlook.com (2603:10b6:208:3d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 06:46:00 +0000
Received: from DS1PEPF0000E63E.namprd02.prod.outlook.com
 (2603:10b6:5:3b5:cafe::ad) by DS7PR03CA0057.outlook.office365.com
 (2603:10b6:5:3b5::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Wed, 11 Jan 2023 06:46:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E63E.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Wed, 11 Jan 2023 06:46:00 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 11 Jan
 2023 00:45:55 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <bp@alien8.de>
CC:     <mingo@redhat.com>, <tglx@linutronix.de>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <michael.roth@amd.com>, David Rientjes <rientjes@google.com>,
        <stable@kernel.org>
Subject: [PATCH v4] x86/sev: Add SEV-SNP guest feature negotiation support
Date:   Wed, 11 Jan 2023 12:15:22 +0530
Message-ID: <20230111064522.957859-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E63E:EE_|IA1PR12MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: 08fe61f0-205c-4bcd-484f-08daf39f8048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWCkm5lH3G55qjwxdhYETy3YpSJSGqreECzRxKEu+uihsFw3zlXEDWcLxLBguOuke5ieZAIaSwaNO9JBjJC/HzJvx2Fvi9OaARl+3Yh6QlHaMLXldVOixmN0luOitOTH4wu57TAAs7u3yo2dPYLHlF+FLplneFIt7TftfPtBwsPcbEExN3clufGTz0ohs6VfVsGHTMr+PHUvPiv2LvMV9UnWf3T58JmXTNxRK/uYfXkwHM/uRTc5i+I6Fp0mc+cGntENSxukkAgZAD2cGkqUZs5SSGUM/IzFwzu766bKig45SnLh+zWxIYcMM40moxiepAd04UOGpiqLMe3Bn7OcLNWFqQxOEDvobfAHfvCNsBIBfchS33wXrkJGlYi48hOwPZQ70B6+wK0683RAaAQvKqjxPM4BFhxxS2bjqliaytaU4Nw/wtpXSmSVXoT1D4O2/CseuX6RJ0yfi8C716huL5kMtSqCcVgDD4P5JOOEuJ0gwxdKGEgdVAx96AHK5eMeIA5Si/KFfm7k4shg6fjgjA0ANncO8ytF0ygl2TcguenD+KrX0qkpkVvJDKcbWV/dhR5n39Tw+Wlb726m6Ks9nkAHhMU+0mgy/CxHrvbcjEfzUjvu3bolEf0X2SknJoip+Wj2Vi0uYREuJREBcloxBUBIrmK9J3fzy+qZHW69BU7QGVt+HDg5iA295k+GhWF6RGDnf2g0peZaG4IiYn74AesP/XlHaKcJFQr3hjR1N2+3aqub5/VyZ+33STr0Tsl7j/KCil/q7g2SPg2/dlA+4XoxzwBRxrI7yklstv4kIHxewZRWGan6UgUV4YqfGTiq
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(186003)(1076003)(40480700001)(316002)(5660300002)(30864003)(7696005)(16526019)(26005)(966005)(7416002)(478600001)(2616005)(40460700003)(47076005)(110136005)(336012)(4326008)(54906003)(8676002)(70206006)(41300700001)(70586007)(82310400005)(83380400001)(8936002)(36756003)(426003)(6666004)(36860700001)(82740400003)(356005)(2906002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 06:46:00.2979
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08fe61f0-205c-4bcd-484f-08daf39f8048
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E63E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6042
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
 Documentation/x86/amd-memory-encryption.rst | 36 +++++++++++++
 arch/x86/boot/compressed/head_64.S          | 10 ++++
 arch/x86/boot/compressed/misc.h             |  2 +
 arch/x86/boot/compressed/sev.c              | 59 +++++++++++++++++++++
 arch/x86/include/asm/msr-index.h            | 20 +++++++
 arch/x86/include/asm/sev-common.h           |  1 +
 arch/x86/include/uapi/asm/svm.h             | 10 ++++
 7 files changed, 138 insertions(+)

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
index a75712991df3..22037443e958 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -557,6 +557,16 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
 	/* Pass boot_params to initialize_identity_maps() */
 	movq	(%rsp), %rdi
 	call	initialize_identity_maps
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	/*
+	 * Now that the required page table and mappings are done, early boot ghcb
+	 * page can be setup and used. Check for SNP guest/HV feature compatibility
+	 * and terminate the guest providing exit information in boot ghcb.
+	 */
+	call	snp_check_features
+#endif
+
 	popq	%rsi
 
 /*
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 62208ec04ca4..0bc3639be1f8 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -126,6 +126,7 @@ static inline void console_init(void)
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 void sev_enable(struct boot_params *bp);
+void snp_check_features(void);
 void sev_es_shutdown_ghcb(void);
 extern bool sev_es_check_ghcb_fault(unsigned long address);
 void snp_set_page_private(unsigned long paddr);
@@ -143,6 +144,7 @@ static inline void sev_enable(struct boot_params *bp)
 	if (bp)
 		bp->cc_blob_address = 0;
 }
+static void snp_check_features(void) { }
 static inline void sev_es_shutdown_ghcb(void) { }
 static inline bool sev_es_check_ghcb_fault(unsigned long address)
 {
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index c93930d5ccbd..a26a5d6949c3 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -270,6 +270,65 @@ static void enforce_vmpl0(void)
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
+				MSR_AMD64_SNP_REFLECT_VC |		\
+				MSR_AMD64_SNP_RESTRICTED_INJ |		\
+				MSR_AMD64_SNP_ALT_INJ |			\
+				MSR_AMD64_SNP_DEBUG_SWAP |		\
+				MSR_AMD64_SNP_VMPL_SSS |		\
+				MSR_AMD64_SNP_SECURE_TSC |		\
+				MSR_AMD64_SNP_VMGEXIT_PARAM |		\
+				MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
+				MSR_AMD64_SNP_RESERVED_BIT13 |		\
+				MSR_AMD64_SNP_RESERVED_BIT15 |		\
+				MSR_AMD64_SNP_RESERVED_MASK)
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
+		u64 exit_info_1 = SVM_VMGEXIT_TERM_REASON(SVM_VMGEXIT_TERM_REASON_SET,
+							  SVM_VMGEXIT_TERM_SNP_FEAT_UNSUPPORTED);
+
+		if (!boot_ghcb && !early_setup_ghcb())
+			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
+
+		ghcb_set_sw_exit_code(boot_ghcb, SVM_VMGEXIT_TERM_REQUEST);
+		ghcb_set_sw_exit_info_1(boot_ghcb, exit_info_1);
+		ghcb_set_sw_exit_info_2(boot_ghcb, unsupported_features);
+		sev_es_wr_ghcb_msr(__pa(boot_ghcb));
+		VMGEXIT();
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
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b8357d6ecd47..db60cbb01b31 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -148,6 +148,7 @@ struct snp_psc_desc {
 #define GHCB_SEV_ES_GEN_REQ		0
 #define GHCB_SEV_ES_PROT_UNSUPPORTED	1
 #define GHCB_SNP_UNSUPPORTED		2
+#define GHCB_SNP_FEAT_NOT_IMPLEMENTED	3
 
 /* Linux-specific reason codes (used with reason set 1) */
 #define SEV_TERM_SET_LINUX		1
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index f69c168391aa..5bd81adfb114 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -116,6 +116,16 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
+#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
+#define SVM_VMGEXIT_TERM_REASON_SET		0
+#define SVM_VMGEXIT_TERM_GENERAL		0
+#define SVM_VMGEXIT_TERM_SEVES			1
+#define SVM_VMGEXIT_TERM_SNP_FEAT_UNSUPPORTED	2
+#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
+	/* SW_EXITINFO1[3:0] */					\
+	(((((u64)reason_set) &  0xf)) |				\
+	/* SW_EXITINFO1[11:4] */				\
+	((((u64)reason_code) & 0xff) << 4))
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 /* Exit code reserved for hypervisor/software use */
-- 
2.32.0

