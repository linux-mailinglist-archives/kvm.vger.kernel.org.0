Return-Path: <kvm+bounces-5374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C498207AC
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39493B21672
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288C8D29B;
	Sat, 30 Dec 2023 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Y+A66LGR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967C4D2FF;
	Sat, 30 Dec 2023 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qt91w/BA9yViApy350m6eX3npf9FOzlLCuFS0R7sHe3wY9JXOOYTwimP4J6/dH2pewwmzZeGmwIgBhsDHrOFkyRl35nt0r07DxQ10BuMsxGGNbdyAX/Fr5cedJF4SOUP/HxZ78Yn+M/c8wwrynma6AlE2u91tl/BMhB/u9aRNkTR0zL1rO0nkKBhAELvvesghNspO3itIM7kl/VJHY6SmeunICCTPcS1UPQDxGm1gLVesBxJvr0XmrpRfk44j2oq61OkxeKZroTyZOFE/Fb8YTh8jHjCR067P6+GGHAlfFFzQSCqmdutsVuNnvvFO/27RAdZSsY69ru5gU9Jjrn0iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pjftE3G+Vnx3yYCoMrg5oU0p0NL5OyiaOcqj5Sradbc=;
 b=ng7VksSXuVqAxoYLYvIPLZUzEEErCsIgvy8r7gZGqRfbU1hExou/6MHG0miGvAhjj+6jAYepQPpmY4rFTeGKDuwpfz0RNm/2R4RobePeaz/jyblncSPtP5anREqwa2vnNWJz6DOw7sPz/oTteEwUASvVW7QwZHdege4AiowQt1cMlbh3hPOnCKggbtkefs2AtkoUepJw77OwvVCMxDlaefkXsjZWzOFHB7nMqMK+YNaeFVwphGXdV9XZJT59lsKlZPLlQ850ZNhxrarXUT2u0ieePnsXrbyW9cMkOGD1x6WcyAU/4AtrXUL/mznoZWcoFybzP6H+Q8gviQddm3e22Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjftE3G+Vnx3yYCoMrg5oU0p0NL5OyiaOcqj5Sradbc=;
 b=Y+A66LGRZjBclsjPaOs3XKzjRwHIGoUuSBVHza6/CFImkglmch2Bz49FBdhxjsn3zDuJtxAkbnDFxcCU/pbIW1Nf4tIpyEP2fc7FRaez2oPP6BFRlGHWzCKixZMLb3Cn7vnzATRIBg/eOjt/7zVuSfXYICvIiSVfJ6Wm1qVw5/Y=
Received: from BLAPR03CA0175.namprd03.prod.outlook.com (2603:10b6:208:32f::14)
 by CYYPR12MB8654.namprd12.prod.outlook.com (2603:10b6:930:c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 17:25:45 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::24) by BLAPR03CA0175.outlook.office365.com
 (2603:10b6:208:32f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:25:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:25:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:25:44 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v11 12/35] KVM: SEV: Add support to handle AP reset MSR protocol
Date: Sat, 30 Dec 2023 11:23:28 -0600
Message-ID: <20231230172351.574091-13-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|CYYPR12MB8654:EE_
X-MS-Office365-Filtering-Correlation-Id: 8df7c58e-8f6f-42f0-2910-08dc095c5aff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dxfXqD9i6n6dHjhoA2UmajZI+1z9xqhcm0eqGWDWjsT+2fRZnqxg4laMxPD1DUB5VKkFSonDlXLVnGGFPIwzKts6CuzGk6f8xWpmuFQR+SikB3lOt1nMJfooaZ4KsYfrV8e2I3RcucVp6ATOx6AmCduLFXnWlL4TaBcOOCgQInNk9ftsRalShu2cM0sa8LRPqOvx0rPz1jXodokBnGF5L3gxqaS+zgpYO//eplWa+ojV5geSn+BqYSy5XrQ8k6MTcFoCzlrE6/8bYZuyh7DCC/QnOJZ6iKGp5SNPVX28l6EniDol6pu34Sag02lEOiyTCbUM2bWFkV88J1Yd+LDBvMB/g1XZU9sIRkhSqjK9Pn7n2HSANbtiYBc0fs+aSWSAMO7aW7cpIdNjQX740Zqx03k3QNUVw8XxY4n3NuY7crlalV1SPCOs0+IAG4l0drOFmyNvILpI+TewmcIG8kkbKWYwJjRz8Ozm95jFUIaAfKiM9Uo1scFWEzUDeAArqgeLiBA2cFijxIYFzBrnKBT0t49YWMBlts0dOtFdnXW1kyAepCz+cVn2YQ732gCpQVr0zVY2MKahTtgzRB/GFLt+0Dlld/kxN98ywS9D49Ikc7hExdBkEinBMF8+3Ow103Fo1yz67UR+D1ZEuoxVdcrRQL1y/UGwhQLlFmd0x9TfQKfynEoIhy1dFMVd5u6wwQZ7rVbWDmmUX7TKB1kDiS+FVy63EyS1Jj6BNYAmOOUmsuORkOiSLSPq3wC4V0PEn+qZyZz+mc4zsTx+nfUnigb6Ig==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(136003)(346002)(376002)(230922051799003)(451199024)(64100799003)(186009)(82310400011)(1800799012)(36840700001)(46966006)(40470700004)(426003)(336012)(16526019)(26005)(1076003)(83380400001)(2616005)(6666004)(36860700001)(47076005)(7406005)(7416002)(5660300002)(4326008)(44832011)(41300700001)(2906002)(478600001)(316002)(8676002)(8936002)(54906003)(70586007)(70206006)(6916009)(86362001)(36756003)(81166007)(82740400003)(356005)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:25:44.7611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df7c58e-8f6f-42f0-2910-08dc095c5aff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8654

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  6 ++--
 arch/x86/kvm/svm/sev.c            | 56 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h            |  1 +
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b463fcbd4b90..01261f7054ad 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -54,8 +54,10 @@
 	(((unsigned long)fn) << 32))
 
 /* AP Reset Hold */
-#define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
-#define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f99435b6648f..b09bdaed586e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -65,6 +65,10 @@ module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 #define sev_es_debug_swap_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2600,6 +2604,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
 
@@ -2811,6 +2818,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -2910,6 +2933,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3153,15 +3177,31 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
 
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7f1fbd874c45..eecb2b744d79 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -197,6 +197,7 @@ struct vcpu_sev_es_state {
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
 
 	/* SEV-ES scratch area support */
 	u64 sw_scratch;
-- 
2.25.1


