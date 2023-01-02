Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D666065AE41
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 09:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjABIil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 03:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjABIij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 03:38:39 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060D7113A;
        Mon,  2 Jan 2023 00:38:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrRLifb8pmcQcMlP84zoGnLRNFzBBI09Q3QDfmIW3hVRszcYtYcPX5juc5+ImvWKKL+es9tkgDMZMN62GL525bhRbcRIqJO4beFX6sRVh5ANC1/PoFOVujmYwcNuURSv6Opyvx5UhkS9weGxoeBZG5AlLLFGajU1dZyYn7IEK4791eddc/r/94KihM30V9nfRTJPI+OYq8pvhA1p/CnslX29Zx+r32zTHfFKIRfpqC2+pUL2azzxkY8q1EnkXCGyZEY1AD3ChBvA0Rx/IjGWnbOfTiaJiNqKnC/iINn/RUOesCmtQ4rqzDsdGJ9H5K1oBByknDx/DRlt8GaPwAc2fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GeRn3Jc+kiOna0An3gHdZkdNeo73oo8f/257w3FuF5c=;
 b=imkAjXCJ7UKAhEEzdOsFBBPPFcXC+qb9tCeG+QNQBLHTckE0Rdl/MVdWhEz7POnXGmb8s1fjeU01WiiLj/inOWZnO0ykv0Uhya/2IyqkYEZLcqZW1Shs+VfhuWkqN05NatSYhxJffm4I/xoed4l/Z428v8mGPS1jzxZ7Hoy38FZIZalqKciZOk6UmQxdBFCdTXhNHKJGOASFNlBZR4REu7AkgX63V+DBm9Z3EU4i2DtbpahebJH1ckcJmfghZhXAutnCoYO/RcWeQdWV13uTqgFyTime5TQb0Z5HDnNANkAqMqG55XabdNdOUymDa00vpsg56Q6494YsFsEAt19LCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeRn3Jc+kiOna0An3gHdZkdNeo73oo8f/257w3FuF5c=;
 b=I2wq2wXqpLcBUm0VGfLWN/kykJs10M/E+XE7/NkD2M9uaIyPKkl1MrZdHwthQ+uxGJe5eMtMYpAKXrbeQN6wcsAMn9oAVN6RheHf8hzLxpmdKUiylOdF7BnEd+hYSCa38AhBkWIAuj+l+s9DyzkA37KN7Toc2fmd5KPeoBzgVbc=
Received: from BN8PR04CA0003.namprd04.prod.outlook.com (2603:10b6:408:70::16)
 by DM6PR12MB4529.namprd12.prod.outlook.com (2603:10b6:5:2ab::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 2 Jan
 2023 08:38:35 +0000
Received: from BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::ed) by BN8PR04CA0003.outlook.office365.com
 (2603:10b6:408:70::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.19 via Frontend
 Transport; Mon, 2 Jan 2023 08:38:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT101.mail.protection.outlook.com (10.13.177.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5966.17 via Frontend Transport; Mon, 2 Jan 2023 08:38:35 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 2 Jan
 2023 02:38:31 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <bp@alien8.de>
CC:     <mingo@redhat.com>, <tglx@linutronix.de>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <michael.roth@amd.com>, <stable@kernel.org>
Subject: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation support
Date:   Mon, 2 Jan 2023 14:08:10 +0530
Message-ID: <20230102083810.71178-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT101:EE_|DM6PR12MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: cbc4cc38-9b6e-4280-a24b-08daec9cbd18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ODTS5lcSTCntXeOIsg1VCT08uoYcHiWaB9iJVAWOMZEhOuXlmXbH7EypsSQZMSogxDfhLkG/Wt81ccbn5rAnfw0vQz08vRZFwgny6Nm4XMT7pmU1jaSErykMHT8baVKUyQiKUWXVqPvfI0M7dG1NjdtmqCDNsaJ1G+UQNtRmZ94Sha1CBbQWMWrv+Mok/e475wZz7La9tX9lsEAxLJptgt5nFLsBop8H4qIMxLXUMTouNbwTTP/edk19mEL0S8a8VvKqGHhtgXNm0RoAJXgEsriPQT2kB2RFGSSgoRUTzL0ayn1um3CEWRjqUcSiQQS5NiE92h9FHoQO1GWWU1lY7haMyekRy9tx6Iwa3Uek7JWMykbLV1yARARpxN4xHBzXhmnbZn0VSeDiEZXpf3MZfEXZywxQbEkH4l4WzjewHK+0ddQ5o/m3JZ/GOkYuy/3I4+gjW5gEYoBbdmz6ytTJjOwdZOLdekQS1SCCAAZp87Z2hnnn+IYnaRodPeGQm7fCrh/6jm0iKiI3Kxu6zVwcGBU5XbssZuOlFmxVTNOFmofeMHbtduT13fzhnZul1r5CLY84uOd0/pDh5ghMtsE+gE1lQYF2B1LRnKzkx7UNNTrlf4t1KTvzWolCNCQXxWXLkFCbfpOQB4vSFcNDyA5LKhCb8Zug2PPcEtLLg2VFRus1vab8y6DXK+KEO+OCzOFIm7qjZwmqTKV6pQdKQfvij0c4bBVtbreUDFW1N/t+EFq4GzFbHnTQgVlQE6LsBkHulHxhOmVhql1tH9JSVC3bQD0hSPB0tcPkpKdQ/xpPqcQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(8676002)(81166007)(40460700003)(4326008)(70206006)(2616005)(1076003)(70586007)(36756003)(336012)(47076005)(41300700001)(426003)(316002)(54906003)(82310400005)(110136005)(356005)(2906002)(36860700001)(82740400003)(5660300002)(83380400001)(7416002)(40480700001)(8936002)(966005)(16526019)(478600001)(6666004)(186003)(26005)(7696005)(22166006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2023 08:38:35.7439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc4cc38-9b6e-4280-a24b-08daec9cbd18
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4529
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

SEV_STATUS MSR indicates features which hypervisor has enabled. While
booting, SNP guests should ascertain that all the enabled features
have guest side implementation. In case any feature is not implemented
in the guest, the guest terminates booting with SNP feature
unsupported exit code.

More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR

[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf

Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
CC: Borislav Petkov <bp@alien8.de>
CC: Michael Roth <michael.roth@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: <stable@kernel.org>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

---

Changes:
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
 Documentation/x86/amd-memory-encryption.rst | 35 +++++++++++++++++++
 arch/x86/boot/compressed/sev.c              | 37 +++++++++++++++++++++
 arch/x86/include/asm/msr-index.h            | 20 +++++++++++
 arch/x86/include/asm/sev-common.h           |  1 +
 4 files changed, 93 insertions(+)

diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
index a1940ebe7be5..b8b6b87be995 100644
--- a/Documentation/x86/amd-memory-encryption.rst
+++ b/Documentation/x86/amd-memory-encryption.rst
@@ -95,3 +95,38 @@ by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
 not enable SME, then Linux will not be able to activate memory encryption, even
 if configured to do so by default or the mem_encrypt=on command line parameter
 is specified.
+
+Secure Nested Paging (SNP):
+===========================
+SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be enabled
+by the hypervisor for security enhancements. Some of these features need
+guest side implementation to function correctly. The below table lists the
+expected guest behavior with various possible scenarios of guest/hypervisor
+SNP feature support.
+
++---------------+---------------+---------------+---------------+
+|Feature Enabled|  Guest needs  |   Guest has   |  Guest boot   |
+|     by HV     |implementation |implementation |   behavior    |
++---------------+---------------+---------------+---------------+
+|      No       |      No       |      No       |     Boot      |
+|               |               |               |               |
++---------------+---------------+---------------+---------------+
+|      No       |      Yes      |      No       |     Boot      |
+|               |               |               |               |
++---------------+---------------+---------------+---------------+
+|      No       |      Yes      |      Yes      |     Boot      |
+|               |               |               |               |
++---------------+---------------+---------------+---------------+
+|      Yes      |      No       |      No       |   Boot with   |
+|               |               |               |feature enabled|
++---------------+---------------+---------------+---------------+
+|      Yes      |      Yes      |      No       | Graceful Boot |
+|               |               |               |    Failure    |
++---------------+---------------+---------------+---------------+
+|      Yes      |      Yes      |      Yes      |   Boot with   |
+|               |               |               |feature enabled|
++---------------+---------------+---------------+---------------+
+
+More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
+
+[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index c93930d5ccbd..43793f46cfc1 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -270,6 +270,36 @@ static void enforce_vmpl0(void)
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
 void sev_enable(struct boot_params *bp)
 {
 	unsigned int eax, ebx, ecx, edx;
@@ -335,6 +365,13 @@ void sev_enable(struct boot_params *bp)
 		if (!(get_hv_features() & GHCB_HV_FT_SNP))
 			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
 
+		/*
+		 * Terminate the boot if hypervisor has enabled any feature
+		 * lacking guest side implementation.
+		 */
+		if (sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT)
+			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
+
 		enforce_vmpl0();
 	}
 
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
-- 
2.32.0

