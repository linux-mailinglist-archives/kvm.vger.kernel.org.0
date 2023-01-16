Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDEF66B9F3
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 10:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjAPJM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 04:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbjAPJLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 04:11:48 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35EB166C6;
        Mon, 16 Jan 2023 01:11:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUGi1Z8j1JNe8aIZRXgU1BNyzXt7MXBVRfLOdadd6SGTNNcBZ3NbN+HLr2nvTvTPgBuPuUdi/OZ76OFsjkfNTcloqQZtdeL0CkqAFvggUN1ENYlWe+P8TWDZGebqg35iIWtsWHTfPl58xg1LYMQ4PNFQ0e/uRvanI7BHEhPCX1J5cgbSKsBY/F/+/N6+Q4EDhQDaGRNFdLaJVocXxgGBbT3tkCd9gavoPpNSdgxld42sk02mbq2bB5csVqjWLHbeO1YpMQpAAI7EcuXpnVRndXQmj/YwpINZR3tJFIlqti9JVbzmRP+4wWdpj0t/ClWHE2YVyyV9Ui/9muMKOtyNbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgynuXsdUhB3Z71t45zfxqy8YjDSC1EPhAopqjFJuj8=;
 b=hZQr4qj9HfCyCauqXUkdRJ0h1DERUHCmLm2QNBZ4Kuefait0edpwHfZHlpaZ693B0ui5N+SHkse13Lr1rT5aLk85X18gJAdQohqOV+ycewtQSQvjvBYzjsKd1lNsWJHCburAQTjwUv283Jf/kvWCkhzhLdlg8BXdqh11/JiI8Xa13K4aoAy3E2KDEVs38aAHnUxpQYR5U4DqccNYyoyRdrfGgX45oqu8MXsI12VgKeKy+bUAeg+wtA7yIjWyyDroQ07S5/EQ6aJ5Vs1hgj4Z2knm3PfV89IVr1XfDhIe4PEm+0DvAS1I4yFAA40vi97m0GwowIHkwORKbRzjiagHYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgynuXsdUhB3Z71t45zfxqy8YjDSC1EPhAopqjFJuj8=;
 b=JtkkvfjfnJPWK/vTsZ1HSDlOghcw5P7Q//MYqbGHD9zEoJ94SN0JKA8bkYSFI2VpnOi/SWBpobwy/iMA82x3pGfcC1h8lkqcejla0gvsa/ZTdByzrOqJbgdzd73L3BTQ7e5WG5IcY7B7r3CGfWsLmEXWm0LVYrSbO8cak/Fsf6g=
Received: from BN0PR03CA0042.namprd03.prod.outlook.com (2603:10b6:408:e7::17)
 by BL0PR12MB4916.namprd12.prod.outlook.com (2603:10b6:208:1ce::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 09:11:17 +0000
Received: from BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::ae) by BN0PR03CA0042.outlook.office365.com
 (2603:10b6:408:e7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Mon, 16 Jan 2023 09:11:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT079.mail.protection.outlook.com (10.13.177.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Mon, 16 Jan 2023 09:11:17 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 03:11:07 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <bp@alien8.de>
CC:     <mingo@redhat.com>, <tglx@linutronix.de>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <michael.roth@amd.com>, <zhi.wang.linux@gmail.com>,
        "David Rientjes" <rientjes@google.com>, <stable@kernel.org>
Subject: [PATCH v6] x86/sev: Add SEV-SNP guest feature negotiation support
Date:   Mon, 16 Jan 2023 14:40:36 +0530
Message-ID: <20230116091036.72579-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT079:EE_|BL0PR12MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 35a63ffe-1243-4106-a26f-08daf7a1a03a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iNcw6QhXnnn7XaRUXyGPWSa2vLVJJCQknxNHsycPaZLocW7eC48Go9F45GNupgKG8BMWyDZ7JAQVglSOT8w8FeLhMzoShO/IC9oik4W89/bytL+6Ds4BR8Dv4aSQbSx/hygOiFC3/QkH4xSMOHV1YM6qwlYD+RiWeUFZdpyiUdlNVwXpncBnOwColF1ii7SroLeNxfDGJcWzyPjjRX7FAI6hSWEpZvHJTGkwYsjWRiaamfJSAGJI0XA+diLBhy11xfJmUs+KEANiEXiZsueX29xCQfWYf0VJDt3SOOh2gsliiq5QzewFvlKB1K9yidvC2bT5PgXDXiYxUMDyS8Fg+Sez/kHh9Uqe45pqoTUpZZtHaD8U54iH/MVQggxcOqchIrZFaN3fMXGwqDNlPwn6wiYvtKn0gYIPCC/aJxZ3WAnIhcEK8mrBbNSuvVW4i4GfVT9kVe2aqFBKmI7gURGKHYFhN8/O1mWKg5WGDrJ6PnryiWjzwkFIUTJprPeEfIoiZAo20wX29lcB2uSScce0Moqlu4n3R8KAKOZlgadsnwcg4Mva8Erlx6lp8foSRrXUiieNUcSEJBJEZ7/Mw9qrJvvG3cBp5d2Dem//bepROQcGO+p/eJ3h+W+dlew0rIw2K6t+GrFW74rfmE2K7r2z1UOMY8BBECqcaj8A9L99OJIquoOrhTigb0Bwo/e5eY75NCpPDr50dRRFe0mRsnUQI8SS3JMb7BDgy/hObDVKwj9x7ybbio7XHxk76IxfsJmuhZSkOHeu9QRQYEmS1VUHCWwx+4o3DRFS2ANQ6+SVkz6vp3WFRBc8lx5WkCiV8xgC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199015)(36840700001)(40470700004)(46966006)(82310400005)(70206006)(70586007)(426003)(2616005)(47076005)(41300700001)(186003)(16526019)(26005)(8676002)(4326008)(36756003)(40480700001)(83380400001)(5660300002)(336012)(36860700001)(82740400003)(8936002)(6666004)(54906003)(110136005)(478600001)(7696005)(1076003)(316002)(30864003)(7416002)(81166007)(2906002)(966005)(356005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 09:11:17.5870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a63ffe-1243-4106-a26f-08daf7a1a03a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4916
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

[2] https://www.amd.com/system/files/TechDocs/40332.pdf

Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
CC: Borislav Petkov <bp@alien8.de>
CC: David Rientjes <rientjes@google.com>
CC: Michael Roth <michael.roth@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: <stable@kernel.org>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

---

Changes:
v5:
* Use ghcb_version directly
* Add helper function - sev_es_ghcb_terminate()
* Update broken document links

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
 Documentation/x86/amd-memory-encryption.rst | 36 +++++++++++++++
 arch/x86/boot/compressed/head_64.S          |  9 ++++
 arch/x86/boot/compressed/misc.h             |  1 +
 arch/x86/boot/compressed/sev.c              | 51 +++++++++++++++++++++
 arch/x86/include/asm/msr-index.h            | 20 ++++++++
 arch/x86/include/uapi/asm/svm.h             |  6 +++
 arch/x86/kernel/sev-shared.c                | 17 +++++++
 7 files changed, 140 insertions(+)

diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
index a1940ebe7be5..934310ce7258 100644
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
+[1] https://www.amd.com/system/files/TechDocs/40332.pdf
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
index c93930d5ccbd..e7423da79d33 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -270,6 +270,57 @@ static void enforce_vmpl0(void)
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
+		if (ghcb_version < 2 || (!boot_ghcb && !early_setup_ghcb()))
+			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
+
+		sev_es_ghcb_terminate(boot_ghcb, SEV_TERM_SET_GEN,
+				      GHCB_SNP_UNSUPPORTED, unsupported_features);
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
index f69c168391aa..80e1df482337 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -116,6 +116,12 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
+#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
+#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
+	/* SW_EXITINFO1[3:0] */					\
+	(((((u64)reason_set) & 0xf)) |				\
+	/* SW_EXITINFO1[11:4] */				\
+	((((u64)reason_code) & 0xff) << 4))
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 /* Exit code reserved for hypervisor/software use */
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 3a5b0c9c4fcc..d6786c6407a6 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -164,6 +164,23 @@ static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 	__builtin_memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
+static void __noreturn sev_es_ghcb_terminate(struct ghcb *ghcb, unsigned int set,
+					     unsigned int reason, u64 exit_info_2)
+{
+	u64 exit_info_1 = SVM_VMGEXIT_TERM_REASON(set, reason);
+
+	vc_ghcb_invalidate(ghcb);
+	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_TERM_REQUEST);
+	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	while (true)
+		asm volatile("hlt\n" : : : "memory");
+}
+
 static bool vc_decoding_needed(unsigned long exit_code)
 {
 	/* Exceptions don't require to decode the instruction */
-- 
2.32.0

