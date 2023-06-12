Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B0672B696
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbjFLEg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbjFLEgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:36:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A661BD1;
        Sun, 11 Jun 2023 21:36:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzBuvqVrVgx5QaX4z/cLqNIN5Ug9MJOjvMT5LYhqtgnkvCfNgbaCnmHuwkJMiO6Q+z00ck0FpHcHEgIQ0AIF0bdEpbegyi7AIwU6NPL/sOXZankkiExX7xE7GKKCSbzXpBG9VEujVxti6mk9fzdf8krjYVsSJzxkEkhYFcdFQIJP5J7FFd6QjJiVCWzzftji7ChlVowuTXBt1OPnl+SzNwQjdRdOIikfuLbZhf1zbRlhevdXIIH54LucyH+tHiCg1NlF3BZA7KXktw2PihvAVOo7cq+Yl0u8t/TVTKs+7rX/8RqKr/AjdVp7e6e2+QdhxoHhFZX8Zfnuy1oXktacvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9nJ5zpVhl4br77hne2iYfznSmBLEzrcXtOigBe9hqVM=;
 b=M7h+WJ5cI/EXV94N42vs2Bu2lmBv4mofSQjxy0h6GxKRCo7aNPbWgYS3eJg9EG+Z2TK9JT7zkTMhi7y/AeGEAJr5yErI38y4xRptcwN44OcIfiZu6aNp8mlKbrbTrRO26WVKSnFhG2RkCTbEVJ9JLQ3RAQOAnxbxFW8eu7PZmHEZHfz2b4lqY3djia4GLdlqoenLNlLgMvepIe+/1UGXxchi8qkBmHXPXtUm0+rm+yr8RkrfY6B/bbBWX5Mmxez37H22jNlVZVwI2/8Lw3pDE7dgOQEW1h5/JWZG2UhHfBoLqi35SzsmJMhGvK8vi2WCUt5elVG+fAs2jhuUyJIkBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nJ5zpVhl4br77hne2iYfznSmBLEzrcXtOigBe9hqVM=;
 b=vaLMD9UzS4ZbAyWuRaAwriD9K/MuqNrWCZbgruqca8ZLVdnf66g/sliaPoSoun9qGYJqMgIdkbmIYUfTiU7yypV3PJfxXrb5h+PWwgvDLeIOIwhl6nJTMPMvNvAP9gMAsquV6niZdyQBpjrh4sfvXoYDtpoUy/ewoNOl9doKteM=
Received: from DM6PR07CA0097.namprd07.prod.outlook.com (2603:10b6:5:337::30)
 by CH0PR12MB5074.namprd12.prod.outlook.com (2603:10b6:610:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 04:35:58 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::b4) by DM6PR07CA0097.outlook.office365.com
 (2603:10b6:5:337::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:35:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.31 via Frontend Transport; Mon, 12 Jun 2023 04:35:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:35:57 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 24/51] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Sun, 11 Jun 2023 23:25:32 -0500
Message-ID: <20230612042559.375660-25-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|CH0PR12MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: e5920512-a81a-4d9c-1b6c-08db6afe84bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rqK7AFtqnNuXhApJzdERleiUko9HJRWeIj+Stb0wE4TiiBbKMVb8Mk7dJuABz/IDCwvAkfUTMVtMHLSpmcmGkNTi9TyJL0L2xmxMho/ie9B/W6wTXdzGuDW9ujcfhwBgsW+nSMISEukZlRYwsI0zRpAkLnD8/+CLZE022YmLnUBcu6c0LfUgGpdxeIhDFM5GomyCEJnEn6oQXOsPAGB7in8U01EMLOxvQ6FGQzjdC1IQrRlpT8JNXnS5YfFFGbb/o6DdZVez+8lmuQ/k7ueR9UO+lTYOWMct2EXvGLQN3M9LU44kZFKrow5UginpBfKr5/X8wDZtctBrlNeVLqyUqpJuiUjeWCXzsqlrQbLiXZ1agGcXwwJPG+/NWfPi1VpcoZCK4BS+3m+693tLWar/xtqd+5P0a6tHcxKdltUYp5rQN+KkzAtAfuQfl7cshDvCOZFYJImzDx3tYnno+OAv9rR1CIAZXySRCrxJ8/x2/857ztKvLVkQ6+W5sXysGGWY2WFqVF5XsoEQG3a78bZz8/npOqHfWSm+j2buSHjNY9vw33Xh3oTZE8BlaTBlif1tiaprL39l+ZndeouUupitE+a407rmpQq6HJt+BmBha4Put+H2UqLXog4p5x7s+SQJ+qO6wCVTg3amPcOo5gNvKQHpS/I9PbR/PaqVCv15rgR+dGDcpHyAcypY5QjX1Vs5HhNvwQl3O7xf8GqXdB4eQQkzIr0mY2kthNuRQR053c4GNvYpjoAofU5FVNlSL2k1gPwbJ5sTIyOhmJmcOxzK2A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(426003)(336012)(2616005)(47076005)(83380400001)(36860700001)(356005)(82740400003)(40480700001)(86362001)(82310400005)(81166007)(36756003)(40460700003)(478600001)(54906003)(44832011)(4326008)(6666004)(8936002)(8676002)(2906002)(5660300002)(7416002)(7406005)(70206006)(70586007)(6916009)(41300700001)(316002)(16526019)(186003)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:35:58.3211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5920512-a81a-4d9c-1b6c-08db6afe84bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5074
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index 9eb20b416251..a4fb53fd15d7 100644
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
index c25aeb550cd9..b88295aa7124 100644
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
@@ -2569,6 +2573,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
 
@@ -2781,6 +2788,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -2880,6 +2903,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3040,13 +3064,29 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
index f44751dd8d5d..50be41fa16a0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -192,6 +192,7 @@ struct vcpu_sev_es_state {
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
-- 
2.25.1

