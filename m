Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977C469D366
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjBTSzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjBTSzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:55:17 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4BA30DE;
        Mon, 20 Feb 2023 10:54:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmxO8VWWUPNlTQgO8OjLwCHU1yqFpJp4FN2Q79RvaLhuCU2N/zc9o2EmI1pyD5U0c18kyjoGhsQM1NVCrdHTljzzdvMlwAKUiFXMcvKk5nQCe74EmU6p+wQiyOydg0PvBQnHqdAbvug/tu+v7CHhaJRMKOziBCdvVp5Ns9uAGGMGpcNjAOGjcnuDuELplxqroeXDurvoKbKJx0r+QQhPJanbHh9MynU9BEGRJtba3pCLBd1IgLyaACgmES1H1OodRwzSZ4fZ+JxetNr350fp/3NKaH8fIzwzU+qcEkF8oXJYq6Dw+tl3GbCnu7bkd0T5NbTzN9213A9ld2V4fq/LxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6itsZa5HGOy70yEThEpdgNmkx82wXLkHdNDZZ+J4+sA=;
 b=CgDqk24oFRfnCmZrZ7kAn8GumK6vUmlll2RzGP2RAhSK5ZpjY+k/DDg2wYy0WxwSQMvF1ftcoel1t5Da87Tp0yk1LeeouwM/OVlZ9S00pokERSg4qq0mxArUwJTrtzGnb8VtiNPAXaZQ195DAHBzYSUgXHSBWt6f/NxPLR4F7q91kodqp3G5LGuwmG494QlnGBkQtsWnV1zsnQpS3GJpMzq4U1WdVnShIGxSNdP5PanSHc9Hld4DQiHZo/R+wGMaqszZfZhpK1PSjK2dyg5VpG9GuKBXG4JWR9RxS10YQLJf2so5QehL5NWSctnC8sSTzwEemI8kbFJ/89n8XnoWIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6itsZa5HGOy70yEThEpdgNmkx82wXLkHdNDZZ+J4+sA=;
 b=mKXvigIBcNfNnFLV0wGn2Bb8hl4I5dTcGTPKxAhgIGj7JurTTwi9NNC4H3zU6+1bayo/jkWSopdgm5WOZdYNvUQNNECtgeZM8lGW2ewoJPh5SDkDFwWyJobq7Fl7DRY9h0Isp4e8ANuBrtWkAKWmXrd9RhTM9fui3R3EN3Adeho=
Received: from DM6PR11CA0012.namprd11.prod.outlook.com (2603:10b6:5:190::25)
 by PH7PR12MB6441.namprd12.prod.outlook.com (2603:10b6:510:1fb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:52:17 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::7b) by DM6PR11CA0012.outlook.office365.com
 (2603:10b6:5:190::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:52:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 18:52:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:52:16 -0600
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
Subject: [PATCH RFC v8 32/56] KVM: SVM: Add initial SEV-SNP support
Date:   Mon, 20 Feb 2023 12:38:23 -0600
Message-ID: <20230220183847.59159-33-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT052:EE_|PH7PR12MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: ce23ba12-6e27-4f47-ddcc-08db137396ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GFirWRmKKyLS3Uwa3xtqJnfO+uhdtR2CLFWIFmcZjMvMvL3qtfRinCMhRbfYfHMIakWEoZz4h0AGnTda+D34oIPooOSd3JG975yl0zUlG01r0dus5ClBwBm/GxKdnd1tLhT/ofyJZo7jX/E8598zoOqLtQxk6oOm1rK2B6hZi7sPBpGzptxn+PQpdthbe8+yDvHzSHXuZWFKwxaf5Mot1+p4PAPsMbfm87wCWJc4KdKchyq1dBUPcMq0YLv67dHgGUCPSxaMXSZEMtR0hdSgVivdC5MZC2ES2Ben0UyqS20yLc8M0GkNltCVlJ86Q0gfy7SDEf4l2A40tsfdOxWoq1Q48E5K/L4iFg9+4pPLaQJ3nBoaolbSuVw4Osm8NbiYYnSCRLdUv1Y5+wuulbw2mX758duUptBqB49qyz+pDmMrhuqN0Z26bahbScVtCCFwNXqHMDz5iWIwhpE3quWSF7EbpqdD99b8b/aM/Yd+lbgophtIxIGX6SSzgYkHrmNkeuqBbglFGi+7baqW0icxn8uVh6QfJ+hIs/gGwis58EU6wxV+iEYhb+wznmwZ9beau5DTSELxKRrEg9Veuz9eyBKv6N8QKI6TOpCEb6+3JQCOfLDqR+tTU3DIQpHAjJK+tYGuqwnAzt+f1kfSoE2BupsOVbSklfm3PXns0iMemMzoJW5gSCol8qUaEgUaeQVLhRp3tWLNA5i+mVr/FRaS795xvQhwa8ciCMPObUNNTZ4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199018)(40470700004)(46966006)(36840700001)(2906002)(44832011)(7406005)(7416002)(5660300002)(47076005)(83380400001)(426003)(36860700001)(8936002)(6666004)(36756003)(16526019)(2616005)(1076003)(186003)(70206006)(26005)(81166007)(40480700001)(356005)(40460700003)(86362001)(6916009)(82740400003)(41300700001)(70586007)(478600001)(8676002)(4326008)(316002)(336012)(54906003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:52:17.2197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce23ba12-6e27-4f47-ddcc-08db137396ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6441
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The next generation of SEV is called SEV-SNP (Secure Nested Paging).
SEV-SNP builds upon existing SEV and SEV-ES functionality  while adding new
hardware based security protection. SEV-SNP adds strong memory encryption
integrity protection to help prevent malicious hypervisor-based attacks
such as data replay, memory re-mapping, and more, to create an isolated
execution environment.

The SNP feature is added incrementally, the later patches adds a new module
parameters that can be used to enabled SEV-SNP in the KVM.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 +++++++++-
 arch/x86/kvm/svm/svm.h |  8 ++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9e9efb42a766..51db01b282eb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -58,6 +58,9 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -2306,6 +2309,7 @@ void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -2385,12 +2389,16 @@ void __init sev_hardware_setup(void)
 	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
 		goto out;
 
-	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
 	sev_es_supported = true;
+	sev_snp_supported = sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SEV_SNP);
+
+	pr_info("SEV-ES %ssupported: %u ASIDs\n",
+		sev_snp_supported ? "and SEV-SNP " : "", sev_es_asid_count);
 
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	sev_snp_enabled = sev_snp_supported;
 #endif
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5efcf036ccad..8eb1b51e92f5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -76,6 +76,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool snp_active;	/* SEV-SNP enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -323,6 +324,13 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool sev_snp_guest(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_es_guest(kvm) && sev->snp_active;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1

