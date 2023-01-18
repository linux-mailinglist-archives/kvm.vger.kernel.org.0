Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CCF671437
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 07:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjARGbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 01:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjARG2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 01:28:15 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1701632F;
        Tue, 17 Jan 2023 22:20:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXpuxtrdm4WiM5/9YZFpO9YbbrOb87M/NruBbOuOzvm3FefpC77SkUsbTc10hutXhjstjW7TZwNL423wPMSi0BzSxrE2cSqYDzUvboN4QGrOUi105WI7MZikFJUFTPY9WuCOVamnlCR/ZqXxgkFMKM0Vyb6at4vj1MFTE0tcwDhgJLoawlhSnxEJT4O9Bn1NfyA2juxgpS6P02a+D3TxSnnxiAB3TO39DzhYHsq++6ffO9zO07XtsjSpKNRTlGKIW7dm7O80aOJKU6jRshQwaeSzSJ7PcczBxSG3qIn6Sys8eBFcvSHBSyrrbseJfciUQ1EsLfbdPYP/q07W4SAOVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0KmN+74GUiUfyHgW76gEdQgI9z9BLuC7wOzq31oGmw=;
 b=k2PD9xNwIhqI8o3uSDAC4bJCcLGeloPDsDEf/+CfTCsYLoegzrtW+d2hnCAvqN7i2x1nuHlFhHHrf89lTflYCzx8i5qgDdbeHeaGhf2zanUrfKxvp30I/0BVrvCfVBtdIPa8vmVNwxoZH8Ap2ex9o3CJwoHdn6YAN4u3x/jwEPr14xSfRBXMLpgIwcsWMlqsSWFfVNN+bXyRGzD93wzyjjrQFGOURXwWbqTUsXjjoqM8Qiipxz0sRF8GeZW5Lb7jmQEsm8emVGlo3x79RTNZ5jRu4GOIEez5OW/G8ByzQTdXrdrvmCsWH0kJy43e/u5cE3OY6YlUHxV4ZLHZurjUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0KmN+74GUiUfyHgW76gEdQgI9z9BLuC7wOzq31oGmw=;
 b=nv8uzTJLahP7KDs+OzjwIQoyRh2VagTiOU+xZWup2U2rhrFdpgmvUgC49K1PkQJctyCzlwYjOZ1W3ng7wp0BC3Z37XXNgvQsTXbCxZDzj1dHMpWmIcjgC/7W0hJWZlRvFjSOe3KBGnFajtQ3CVNToUCy1V11mUUFUUlxt22Lr2o=
Received: from MW4PR04CA0128.namprd04.prod.outlook.com (2603:10b6:303:84::13)
 by DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 06:20:06 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::b8) by MW4PR04CA0128.outlook.office365.com
 (2603:10b6:303:84::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Wed, 18 Jan 2023 06:20:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Wed, 18 Jan 2023 06:20:06 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 18 Jan
 2023 00:19:57 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <bp@alien8.de>
CC:     <mingo@redhat.com>, <tglx@linutronix.de>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <michael.roth@amd.com>, <zhi.wang.linux@gmail.com>,
        "David Rientjes" <rientjes@google.com>, <stable@kernel.org>
Subject: [PATCH v7] x86/sev: Add SEV-SNP guest feature negotiation support
Date:   Wed, 18 Jan 2023 11:49:43 +0530
Message-ID: <20230118061943.534309-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT024:EE_|DM4PR12MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: d1e61eba-13b6-4985-8452-08daf91c0adf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yjPX6LGcYs0nO3UcLPsQqDjXtkpuzvX0/6ZpKpeXq7WHvnDaQuVj+h1dhoKQothE1p/a7DTf1BiJIZFGdDlzZJ1W5K4YzBRY9CYkChdY1aR8FtPpddGqzB4dhTGsNDMKQj/6GvG5iKrQzHblEyJQPMHuixGi7sabg7mCDv4QQWVgPfDo13jkAMy9bMMNg9mRaNqvZrABHE1+T7iez+r9lAl7/HdY+70MM+m6CuCtDjqhtBFPEQJcwt0qkbCxjup7yKrThRwohHZGwwQ05h+xQjSwLPx3VloOfiTxUVQfWlnw6dArB4euirUxFyrBhM4ajDlGCjWvgtGWM4cEoDEKyC5vpyRUlyz7C9W8AiU6zRjHEWirWi3Sk3nly1/OcwTHocnC9gXA1Y6Ge6C2DoBe7nbLOs/xXpW/Vypii3934pbhvytqUTt8TP8tmXLzS+BLiwfv8oKSXFsikTQdVm6Lu/BZG35w9dApQFeHg2tzOH85rfc9aCltdSsfdvFNW4TA7QCpNvD42WkZsQ0nX+gvf932RktUzPwIMI2G5gzqVqK2Rn6JbiHGBSuOxVdIDzzXKGh1Dxjt8dG46po1CSJQNeec9PneO6eecWvJiH5Cbk9wyKVcjUOrMfSiqgjb6MHwb+vNtbMea/Yz4XZrtfT5SOepfqgof1RJxEmkz8E3XDqUBVferU53KFfH4XcnWuvnLk491fb13spPr9C7LiJzk2/UOnh/1qjJEu27VtImxMgee88GvYWJux9mt4q9IqqMwkD3RM5/iLKQo2byg1SOrarQe9HT3ToVuOmSmad4K9KYsf0q2MctTvFFT2gwex0E
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(30864003)(70586007)(4326008)(70206006)(40460700003)(54906003)(110136005)(316002)(2906002)(5660300002)(7416002)(8676002)(8936002)(41300700001)(36756003)(82310400005)(83380400001)(426003)(36860700001)(1076003)(2616005)(26005)(336012)(478600001)(47076005)(16526019)(186003)(40480700001)(7696005)(6666004)(966005)(82740400003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 06:20:06.1448
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e61eba-13b6-4985-8452-08daf91c0adf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7767
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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

---

Changes:
v6:
* Moved sev_es_ghcb_terminate() to boot/compressed/sev.c to fix build warning.
  When there are other users for this function from kernel/sev.c, we can move
  it to sev-shared.c
* Added RoB from Tom

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
 Documentation/x86/amd-memory-encryption.rst | 36 +++++++++++
 arch/x86/boot/compressed/head_64.S          |  9 +++
 arch/x86/boot/compressed/misc.h             |  1 +
 arch/x86/boot/compressed/sev.c              | 68 +++++++++++++++++++++
 arch/x86/include/asm/msr-index.h            | 20 ++++++
 arch/x86/include/uapi/asm/svm.h             |  6 ++
 6 files changed, 140 insertions(+)

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
index c93930d5ccbd..4a320f94af6e 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -208,6 +208,23 @@ void sev_es_shutdown_ghcb(void)
 		error("Can't unmap GHCB page");
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
 bool sev_es_check_ghcb_fault(unsigned long address)
 {
 	/* Check whether the fault was on the GHCB page */
@@ -270,6 +287,57 @@ static void enforce_vmpl0(void)
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
-- 
2.32.0

