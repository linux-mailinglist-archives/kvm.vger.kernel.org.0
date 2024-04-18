Return-Path: <kvm+bounces-15163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E57A8AA380
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF16A1F22436
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8BC1C2318;
	Thu, 18 Apr 2024 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hF5uoFxO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C3A194C91;
	Thu, 18 Apr 2024 19:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469852; cv=fail; b=YybHv6KLMLQoEQ+se4HEDOHYzIY88nlOzuAGhikHupVEBsvBOv2wEDnqw2rAWjJs0522wZyI1WchN+WNWu+Nr1oZfT/kTG1jAQwPJc8ef0nXWu4ncUa+C0N7qSQNQoeFcFVqds3+IIq6FKENmFb8fQrjXOmBy2jRYDY5kbWj74U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469852; c=relaxed/simple;
	bh=uQ7Kx3TwQhw26SgLxowep5X/GtjYEaH5Eg1Jg4fANxI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U2lUf/L5/ivbPdfDP+jpYpSK9QzgJvdv8bc9PhhZAy30iyuGA4svUvdxznwm05PlBXUqBhfzri2sb8s8HWSIPhWuJ974FRkyjaKEjM/fZHB6nnzasZl7ZHREh52dZoNAyuMI++w06xzHnGAHrOk6Zg68CU/8GUA5/oqdGAcVwx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hF5uoFxO; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAe8SA3FOgst2P3gwuagttvKGQF6viTYvNOGRu3rXJWx+nUXX4p+dFCpogvzjwyT9fvi+fRNCQ7fw2E13At16/srZINrut+bp+JHpSGoeMsvUCyFPI+jhvQLUumYKAGl9JD/7RFJ422Ufd/gd8x1DDAQRm3k76AIKcUSJBGPc3SVM+TY/+1osaaWJDCPlTks9timZ+uKhxn9c2vlGj7/yX0NuFUkDGOFtGchibN22KzRDjhh9zcirA/PbocqBVZRvYzyfhmWOy81GFWlnovX+Sbrnzym+KawENDOV7qGJcnMYnS5Aus8k/vd9RIq/aSmkP1awfWUe88Oq32tAC4bvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUcwiyFHOOyR1TxaHBGwT/R8u08BH+n1ydQXmt0BUDo=;
 b=KZMzMKplCgWpLj/7qp+D6UszjOZICnGxdPAJzmOLGDQ5GX96Aj1wkg302VZektuTTstwlp1LtCGn0Rc2wUMzJ5Z8N9J/4qMmOwcZR4I+8b5uUJVaU9sggrtr/GdFdVqF3LwerCZ/dSWlRTsZE7WKc48UHZWH4SxqjbjCqkoy7T9oQqwftbotctcBL19bxQXW0qF5Sgcpv7WmkOobuF/dFca48ocofWuxpwGC1MtK6HPQ1jdmfbWjTK+xg62dWUR9V+6bn7KWLpt1Gh/loOafKArFK2TlB1KeJ5ROM5thDeppTDc40BZKHhX6Mm661aL3ODpQXLW2Ud2l474fCnRhVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUcwiyFHOOyR1TxaHBGwT/R8u08BH+n1ydQXmt0BUDo=;
 b=hF5uoFxOu5PobW55pvp1jcTyxQKNJd4vhLPGqv/Q2OBx3U+0SwhHMyLyBMKhQn1ugMn5e+mKiOeIABEAE0+3TU6Xh/b5WbVGuslqU+s1v14dFaWgcQImQv/nDHQ6q1/QnzdEJ5bFdLfg1coHiAAzrI31FB8ibLiFofybEekxxYU=
Received: from PH7P221CA0026.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::21)
 by SA1PR12MB6996.namprd12.prod.outlook.com (2603:10b6:806:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Thu, 18 Apr
 2024 19:50:48 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::32) by PH7P221CA0026.outlook.office365.com
 (2603:10b6:510:32a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.29 via Frontend
 Transport; Thu, 18 Apr 2024 19:50:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:50:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:50:47 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v13 06/26] KVM: SEV: Add support to handle AP reset MSR protocol
Date: Thu, 18 Apr 2024 14:41:13 -0500
Message-ID: <20240418194133.1452059-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|SA1PR12MB6996:EE_
X-MS-Office365-Filtering-Correlation-Id: c49011ed-c185-4473-ffde-08dc5fe0d822
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BYeUfe7lGKHm2CEoaQgcjxZoAaJv1GmZIAExRhkLXGE1610PYOkBYFnM3ZCpztm4u0bmx5ySvJV56OQww6ioFmidAdgScyE74Wz307WOMTDvLrWeNKEB64iHZGZWXkEcS9kDodFBP9fk7BoVDFkxR6UBVWqXCbvLVKtbjEht/S7pjiveGSNQ+VZJiYgWxonu4odAoqXJPkTxKO1+B/io50gh2I0xS7pUJg8BmM73mtooInVmEOWW+CrM02flX0LNUT6c3dbZj+ZCvoo1ZR7YEwGR3lPvXxI2cLmLaEk8+H8vWkFTmxpxGtyat58ogd1UCBFilCK2uKy5xCi3M2UHBXxfVBwbfN98Pxo1jUnf0YeVsbBqs2bS1r6kkq4cCZ+oRLe6anz5UFUQBCcbrB0wLDPGqrGrqwg/b8SIKACkX2CXL+wUNtgp1lXhQQNPV1UY6MCjUBDtRN12a88PleqQfWrK9E7eJNjjKsEbImYsGb2oeKr8kaVMP5/hrTCZ9erwp2Iu/h3vraSWM+cG3ufd022BT4JgT6fKOIQTkhTwyJh2Ub2KOVyXcD+Dm1dK5zVZVweSbf7vVc/yvvnInkB6bS/afHRqdab2P5yF7dPhGsc67RuTOVf9r9b/JdHjDMSVft9gBde6rJXhaq1zW48rs/Ca10Mqeg5zKgRqfLmeOD7mvyL7tGa9u4mk3+yd/FAs/il0JDgR2Jgoc60VvfH2dPORpDoWRNN9vQqe1X+Hk6afUTif5skFQWl71+PoABRV
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:50:48.2315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c49011ed-c185-4473-ffde-08dc5fe0d822
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6996

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
index 598d78b4107f..6e31cb408dd8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -49,6 +49,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2727,6 +2731,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
 
@@ -2938,6 +2945,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -3037,6 +3060,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3280,15 +3304,31 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
index 323901782547..6fd0f5862681 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,6 +199,7 @@ struct vcpu_sev_es_state {
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
 
 	/* SEV-ES scratch area support */
 	u64 sw_scratch;
-- 
2.25.1


