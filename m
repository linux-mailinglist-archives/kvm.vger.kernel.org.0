Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F0069D34C
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbjBTSwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjBTSwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:52:43 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA10C21968;
        Mon, 20 Feb 2023 10:52:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZetvvUwuas7ePHwiQYkhtxOhh84l2WHWaaSFTUGyC72IXmpmA8dSGGLF5kKgixkUXoXFtRbqd155hRLMYSECv+cFxvJCrqweRFHzjU9EKoYaMzdwLB8di2wvpx5PLL+AlZBNxJpCvfPYO2YNuEgF5AzDj5y0gdKTGMc2oXhXuEcocwMqP69Kglj7cMKWqx5WqOPCh4t94lId/eLfU4SZbzYHgworMe+DQ6ms1J53I8alrk0BbxI2GaYGGy5Qqk+lhzA2lamCVIUra6TpCb5NvYNaSL4oV3OJvrlTYjd8eAnCIRqS+rHcLFenKFhtcPN8zN5FcRLckCNvLDAFJFi7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ReVNTA1h+/h2+VtpWRFQO8/nEpuoqiSemE+EZgXTIyA=;
 b=RWaDtWjhkSnwuzB+D6Gt5E1bbNq8TxIeiTwEp2BYf4QzQDstzgotltIwFVRdjasvwtug7TZWA7ExWTA1F1DeP8poDucHwSSbn4YdL5TQYnKylk6ceGWprWsom0mb9LdTR9DGbNprINPQ+ad5a3hhHaSaQnoD/zCMub5nxPuVY3FLdKqsu4GMOUKBFuGOov/L/h4Hq3WNKpbizjNpbZAo9hcszpukSXXj1KGVu63hU0J2IIJIvqAe3GU+S5Hopt83+cfmkdA2t5R+ujkh+3OFUzdDuWbNIcrT2oL2YEEitUtrCgVvLyJ71JPlIajt9OGoLUx+Ac0BVbxQYJ8w0HpveA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReVNTA1h+/h2+VtpWRFQO8/nEpuoqiSemE+EZgXTIyA=;
 b=e7cc+4Yd3VXgNoNWqGWfQUwN1CmdH1zkRhV7QCe1Wszt1QjlrrtE/SfrGXYxclhF/OjNiAIU9N8UxEsICWRuYvmj3+5ot0JaOHjhtoD0zL0CigIQdS1pSbeN6V0M/e3KhHsiRorq5EeKq8VrJMgLA0BItRE4NNCihu4xaXped24=
Received: from DM6PR02CA0153.namprd02.prod.outlook.com (2603:10b6:5:332::20)
 by SN7PR12MB8129.namprd12.prod.outlook.com (2603:10b6:806:323::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:50:53 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::29) by DM6PR02CA0153.outlook.office365.com
 (2603:10b6:5:332::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:50:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.17 via Frontend Transport; Mon, 20 Feb 2023 18:50:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:50:52 -0600
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
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 29/56] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Mon, 20 Feb 2023 12:38:20 -0600
Message-ID: <20230220183847.59159-30-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT041:EE_|SN7PR12MB8129:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d92763a-4afd-4cd0-86c0-08db137364b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XOTaE+RcD5LtAz0I2XsBsGXZq4KjZREXZM68OfE18lLEVbeD25tdzPslAVxZAE7v5L9CADSLpmJSdY8zuI2Dh55EIx7zxO1Xf0fxMbo1lvsvp6xA6tw1O9D6eOooTLWSmwu7g1k8RWwArtGinGhPbU2PoW9GL6aA5D93DmzUKSuDEih/gS5Oczw38EKFzdLcetJNGs3DBf5gnU+8EgD5fqwd246WYSuXRIfEhMV/6jMhAQtZEUQD+WD99aW3wIzQ9EyZsIzRlsnLaVqy8B8dgvKrS/WTigbEv7CYrkIIhnTMyD9Wu+ctrtjuuDbyhEyDWUYrsPsE7uaCTqbM6D7MqljR/KWGbFygcfFyl2CFduoyXPHNtny6Y0+olU9uPs4oGBh3//MXMQBgo3wbzXatIphd45/SVEnq1Vo4q0bBDDitbw2eiQTPrClNsIcT/xTRgb4GNCmHKTFPhqpReT18bEWLyOKUfCl95f0Yy5Z6WPVoqqTeMWMardGLvww3VwK4kIOE0zTKeOgYgQPp7OQdq0aBuInbcnOOzoC8O2p2tEi+P0APKG2Zd8kgiUt8jdl2LXePyj6ytETCFfyY5+WpfvtPCqUDpvhjasp88VsyJXyHnr9uvVV1I5+qNtAB1R4bi2TgbNjua4lYK9myMhgBTvjrOwxqYbOBRvs66ijXc5GaDJNuA8JqZ14CwllR3vL7Ym+DjojIZ3mr/csQeVhfte7xv5I1symGR8KgoSkpk3g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(36860700001)(40480700001)(356005)(82740400003)(81166007)(83380400001)(426003)(336012)(40460700003)(2616005)(86362001)(47076005)(316002)(54906003)(7406005)(4326008)(36756003)(8676002)(6916009)(5660300002)(82310400005)(8936002)(7416002)(478600001)(70586007)(41300700001)(44832011)(70206006)(26005)(16526019)(6666004)(2906002)(186003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:50:53.3995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d92763a-4afd-4cd0-86c0-08db137364b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8129
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 56 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h            |  1 +
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b8357d6ecd47..e15548d88f2a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -56,6 +56,8 @@
 /* AP Reset Hold */
 #define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
 #define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ad9b29ff4590..05eda0940e22 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -58,6 +58,10 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2706,6 +2710,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
 
@@ -2918,6 +2925,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_MSR_PROTO;
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
+
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		set_ghcb_msr_bits(svm, 0,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3017,6 +3040,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3177,13 +3201,29 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		return;
 	}
 
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->sev_es.ghcb)
-		return;
+	/* Subsequent SIPI */
+	switch (svm->sev_es.ap_reset_hold_type) {
+	case AP_RESET_HOLD_NAE_EVENT:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
+		 */
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		break;
+	case AP_RESET_HOLD_MSR_PROTO:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set GHCB data field to a non-zero value.
+		 */
+		set_ghcb_msr_bits(svm, 1,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
 
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	default:
+		break;
+	}
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 56e306a1f0c7..f4848e6aba28 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -191,6 +191,7 @@ struct vcpu_sev_es_state {
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
-- 
2.25.1

