Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E067363ED28
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 11:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiLAKEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 05:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiLAKEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 05:04:50 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E330D20980;
        Thu,  1 Dec 2022 02:04:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKhoruE9gF7HlRYftT7lkF7c5HoQypSsqKiOHpoPpSKey6HBa/Fk+TWZlG3WGfXmMdkNSCTIUv2SDEIX63DpaEDBwTS+8u2HGEHNPeQwJhcwncoVmP6VX/ooiUeF9wiQ/iUp4tbR228SdlYz1kty0piQoQUe2k1IJL3pReeUiRjVbwsyABHIBCLHadbzLi+CWFEFt+AgBFvXts2e5K5YsxGjqcINsQegh1m4aag/JGarGEmsjoHwsUs15O9thKNUvPS37PnbEu5RsZduzB5g26UHG09zFf2H6RKlSpihQbmMHrqNgVYgPmgFm6FqGwDsCiY5P5LaWirYfhhf6UW92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1c1brLM+CFJantIzuNWKXH7T9/lyefFo90ttqfl2ZY=;
 b=bMVgVXmg7xoIGRLuh7/TdIglpcEKx1Lq/BT28mUMLmoYGu8CCXwD9s1RLGLkg/84tI2gDY6zAlCrF3mxL++tU1SO8iWci5OaBV3q7TRIljhjoz/P012ZGyl/m4KjYSOR6Mduiwtj6BwCpHzrBCYCkZqj4gwk8qtNGlUTQpEekjVrmWyHTmv7h0qA/1Bh0hS+TM6w74qZMZHzWkQgRMwNq11zraI4KefT3/TmsjtlNkR/N6LaiGgoZ3JbY3eUii1jrMupzonZ96GWz/8R8jLdYWZIJknh8NhlHOM9NAPz5flZDfiO7/IDE8fofNfjhO2H2AcXAYi0o1iYRMSUsu0YBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1c1brLM+CFJantIzuNWKXH7T9/lyefFo90ttqfl2ZY=;
 b=kAX+sqgeRHlh78L6XzY1lr/Tv7xx6Z4weemynBEAtIk22/Mh58G9q6E9r5aGp3fmWuBHTf5zaN3aI0eiKpREYFAVsmvTPO92XwNOBbHzi5JENEQ5ReCHCdPzpEIDOEqvj/xuscN9jwoLKY7R8vflZ2I0GHyRFwb/nOabfHRsSqY=
Received: from DM6PR08CA0039.namprd08.prod.outlook.com (2603:10b6:5:1e0::13)
 by SN7PR12MB7129.namprd12.prod.outlook.com (2603:10b6:806:2a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 10:04:46 +0000
Received: from DM6NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::d7) by DM6PR08CA0039.outlook.office365.com
 (2603:10b6:5:1e0::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 10:04:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT075.mail.protection.outlook.com (10.13.173.42) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 10:04:46 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 04:04:39 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <bp@alien8.de>
CC:     <mingo@redhat.com>, <tglx@linutronix.de>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <michael.roth@amd.com>, <stable@kernel.org>
Subject: [PATCH v2] x86/sev: Add SEV-SNP guest feature negotiation support
Date:   Thu, 1 Dec 2022 15:34:23 +0530
Message-ID: <20221201100423.7117-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT075:EE_|SN7PR12MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f8ab003-c097-43ec-1eda-08dad38379c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3/KqT9r//s7DVuiKKOuHdnGKsLT9XoZGrJUdLzR/hLIvooSW/1FZQ+Q3q/5iJSCHGGhX8sFo3UGSfw9PvHKMdM0p3a9Q9HtWFkK3c1LzzPOOffF9F+V5MomSoX7hkvCEC5RE8jgGaicxGRnE1OBn6sqGFMcI5L3fHmUQapHknlHnKmjhmXw+4zCVisbJBvMlLMx+0VTzGl8Rz2ge71GAmq0lTMnOH2EEnSz2VgRDtzpbHTTWSWEq7kMNFjFBHsy/+Sn+XidfofbqgCySEC3a+895FySajz/xTuz0HGwt9RuAofJca6qJO2/qwqq1iiXmyUfmuNRywfDt5ZXTCSsDQT1bU8VogOi9UAgy7DYbOwe/gmZwiN2EJ12iZJzJcEedxbUWxO5+lPW9L8VYBOOJ3t8vYxn1u3xcckZ9qVeMfDLg/48IEQCFwJMcCDxrIitCLJV9kpkXhlD+rAaEWy9mXbEpfEtgOowxoVEqCyL/509dKrhmfuAfoXSpo17eXCRYZ8Agy4ccpghxVYShvsPfc5LbEkfJWSNwoYmJoSPGQ9F+5U0N1Gd0DHJWuc1riSLP6olksL9k3l6nLLH1FWMyvUWWnVB01wvz+But/IqLRdLwTsqR29n7l2cM7XzlUjAeC54RoEwuGGFXqDLYvD9LUKP7MDe9apUwWpUsCJakkXl8llPDh9Lbx017hoOiRrrDIKicI+4T+/iOdY16kvepOaCZ1lrCSP4l22RmY/h9HNlUxcBACqx7WOym5ZvAsH+KJx5STLWoCfd833BBtKmxQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199015)(40470700004)(36840700001)(46966006)(2906002)(83380400001)(2616005)(40460700003)(356005)(36756003)(7416002)(41300700001)(426003)(5660300002)(16526019)(36860700001)(336012)(8936002)(186003)(1076003)(40480700001)(82310400005)(47076005)(82740400003)(110136005)(54906003)(316002)(7696005)(966005)(478600001)(26005)(81166007)(70586007)(6666004)(70206006)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 10:04:46.2965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8ab003-c097-43ec-1eda-08dad38379c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7129
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

The below table lists the expected guest behavior with various
possible scenarios of guest/hypervisor SNP feature support.

+---------------+---------------+---------------+---------------+
|Feature Enabled|  Guest needs  |   Guest has   |  Guest boot   |
|     by HV     |implementation |implementation |   behavior    |
+---------------+---------------+---------------+---------------+
|      No       |      No       |      No       |     Boot      |
|               |               |               |               |
+---------------+---------------+---------------+---------------+
|      No       |      Yes      |      No       |     Boot      |
|               |               |               |               |
+---------------+---------------+---------------+---------------+
|      No       |      Yes      |      Yes      |     Boot      |
|               |               |               |               |
+---------------+---------------+---------------+---------------+
|      Yes      |      No       |      No       |   Boot with   |
|               |               |               |feature enabled|
+---------------+---------------+---------------+---------------+
|      Yes      |      Yes      |      No       | Graceful Boot |
|               |               |               |    Failure    |
+---------------+---------------+---------------+---------------+
|      Yes      |      Yes      |      Yes      |   Boot with   |
|               |               |               |feature enabled|
+---------------+---------------+---------------+---------------+

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
v1:
* Dropped _ENABLED from the feature bits
* Use approprate macro/function names and move closer to the function where
  it is used.
* More details added to the commit message and comments
* Fixed compilation issue
---
 arch/x86/boot/compressed/sev.c    | 51 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/msr-index.h  | 20 ++++++++++++
 arch/x86/include/asm/sev-common.h |  1 +
 3 files changed, 72 insertions(+)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index c93930d5ccbd..571eb2576475 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -270,6 +270,50 @@ static void enforce_vmpl0(void)
 		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
 }
 
+/*
+ * SNP_FEATURES_NEED_GUEST_IMPLEMENTATION is the mask of SNP features that
+ * will need guest side implementation for proper functioning of the guest.
+ * If any of these features are enabled without guest side implementation,
+ * the behavior of the guest will be undefined. The guest may fail in
+ * non-obvious way making it difficult to debug.
+ *
+ * SNP reserved feature bits may or may not need guest side implementation.
+ * As the behavior of reserved feature bits are unknown, to be on the safer
+ * side add them to the NEED_GUEST_IMPLEMENTATION mask.
+ */
+#define SNP_FEATURES_NEED_GUEST_IMPLEMENTATION (MSR_AMD64_SNP_VTOM |			\
+						MSR_AMD64_SNP_REFLECT_VC |		\
+						MSR_AMD64_SNP_RESTRICTED_INJ |		\
+						MSR_AMD64_SNP_ALT_INJ |			\
+						MSR_AMD64_SNP_DEBUG_SWAP |		\
+						MSR_AMD64_SNP_VMPL_SSS |		\
+						MSR_AMD64_SNP_SECURE_TSC |		\
+						MSR_AMD64_SNP_VMGEXIT_PARAM |		\
+						MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
+						MSR_AMD64_SNP_RESERVED_BIT13 |		\
+						MSR_AMD64_SNP_RESERVED_BIT15 |		\
+						MSR_AMD64_SNP_RESERVED_MASK)
+
+/*
+ * SNP_FEATURES_HAS_GUEST_IMPLEMENTATION is the mask of SNP features that are
+ * implemented by the guest kernel. As and when a new feature is implemented
+ * in the guest kernel, a corresponding bit should be added to the mask.
+ */
+#define SNP_FEATURES_HAS_GUEST_IMPLEMENTATION (0)
+
+/*
+ * The hypervisor can enable various features flags(in SEV_FEATURES[1:63]) and
+ * start the SNP guest. Certain SNP features need guest side implementation.
+ * Check if the SNP guest has implementation for those features.
+ */
+static bool snp_guest_has_features_implemented(void)
+{
+	u64 guest_features_not_implemented = SNP_FEATURES_NEED_GUEST_IMPLEMENTATION &
+		~SNP_FEATURES_HAS_GUEST_IMPLEMENTATION;
+
+	return !(sev_status & guest_features_not_implemented);
+}
+
 void sev_enable(struct boot_params *bp)
 {
 	unsigned int eax, ebx, ecx, edx;
@@ -335,6 +379,13 @@ void sev_enable(struct boot_params *bp)
 		if (!(get_hv_features() & GHCB_HV_FT_SNP))
 			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
 
+		/*
+		 * Terminate the boot if hypervisor has enabled any feature
+		 * missing guest side implementation.
+		 */
+		if (!snp_guest_has_features_implemented())
+			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
+
 		enforce_vmpl0();
 	}
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4a2af82553e4..91447f018f6e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -571,6 +571,26 @@
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

