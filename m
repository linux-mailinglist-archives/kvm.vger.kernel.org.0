Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52CF7CA9AA
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbjJPNga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbjJPNf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:35:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833A1109;
        Mon, 16 Oct 2023 06:35:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wk5dtdYMalD+jx9z+J7Lqonusr51BPvlCzHyrUS9wUuDMnTGeKUG5gpo355eZMHYZ4uBBC2xCJzzolspXFStauULX0fsj/OJ8sYzFrx0UnWc3zxyXejcx4JO05JCMgqiW24OgjVE2voTXzQdEYmTOLvVXu+ORxJnXwkcfy17MAt3a4njyFWnSioR1OrAGZWgbWIMDiGXryliseJfwHWz0e0CKKFmN42C9HqxwurbUYQshRNUFx7E7cF5Xb4t29EkOiF7MUa2nh+0N47qrOuZsCIOiATym3v46vwRDjlQgNxWrdNdn1NyUciSVcKFN+hOfWsDuh5Kz8nhNisoQZcvbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JuJoqfCdXMwUqg1oHzVgH/cyQVXFDLh+EUhvApa61is=;
 b=LoQB2jjXbRw82+IIqm/UqZirX7ENqXx4g+jdfqH5nJ27eOBFpohVwvJEGI7VfwRKNHPfXkEXg/BvsoAr756O89M7AB1HWwr6DkaUSNp1tEVaBNPLmZppwcgWX2gJnXnmKmh2EWTcTBb3jCPnlP5P5dHu1VTiHkPVYNd1i4/imaS1oe/kedkaenDnXqWS0QrUWQyWRAf+G9qGN7VtKPDVZCY6nJvVbW++pycV/VLfwm8GKNgdHcF6lEUd8ZGksgswPdTLt2tDi6QAC2RLBMlE5mJSSnrSwYyMnjsroIm0rGK6hEh/Cfhdy0fHhuz/kkHc9DsIgHrHV9mCrHZHMjNCmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuJoqfCdXMwUqg1oHzVgH/cyQVXFDLh+EUhvApa61is=;
 b=Tj7eQeZRktIxOSIAHqm8k6el4bxD32OCLwQV3g3Ib8bwQqxFJ88z5WHXTi0uA78jKxXLKtfVDgmaQ2Qw1RBWCA10Rr4zyZ/rV8UOx2QriX/s2KYYqrvIqg7WoetkAojBpaNUsYQCsTj2/aQqpab0KlqTO/pKdkvjl5r6IkvMzns=
Received: from SJ0PR03CA0019.namprd03.prod.outlook.com (2603:10b6:a03:33a::24)
 by BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Mon, 16 Oct
 2023 13:35:49 +0000
Received: from MWH0EPF000989EA.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::81) by SJ0PR03CA0019.outlook.office365.com
 (2603:10b6:a03:33a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:35:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EA.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:35:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:35:47 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 24/50] KVM: SEV: Add initial SEV-SNP support
Date:   Mon, 16 Oct 2023 08:27:53 -0500
Message-ID: <20231016132819.1002933-25-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EA:EE_|BL1PR12MB5205:EE_
X-MS-Office365-Filtering-Correlation-Id: e461c7f0-c2e4-4b7a-5bf2-08dbce4ccf09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Y0BmHP21rEIyHAKJ3/BTUdjKAprnamLSBQttgITvBC6RXsrz+78EdHw7qkP1OMWOJpLMeXK1wCJFsC9pY2Shf31g2HMPjw8ygKikBUtCZjs4O3Ka5ENIKPBG+xZrfjb+v1if9OwuP8AYQib9PBFjTSpImy6ozlp6ikc3ZxDhg0ACfSW3/4Rm9EKigAU+jK/fAtRdc2HB2s45Pl+sktp0A0uYTGWOs/7gpsRUfij3AVUSr13aKxBbNA5FGKV4TJbGYA6A3DCX1zUywtJDxHUI3duR1VGXQJxA3rNCxzAtiHa0gIMRszSIz7FYRzZpNb0rVAy3enIiJFL9HUke0seHVQqayAS/ZzLj/ZBEJ7AS0YB+PFa6RbpPaM5FTgm+OT44tdrY3La0cJb2Nn4Q4vKEkRnsXM7WqpFZlpYtwnuF2ClHvH0HE+QjbosUhnXZrpR3u4oOqcjl20sSKS6xPAFPnFeNDBjxwKNO4wUwS1kxR3wducAqzWTT4b5CFa8gD5cEJZwaoNHBRlWv8/akpNjqS06FKN5zNw4Dp1eyFMN7YZz+rDfTK+vqFGSSu0YSxCU56DaqbV/lSDXK+sOq+LJWlH+AXj6lfGWzTPGbfplIizVxkEsr/7lGF+qWbz+oVT7U8tgdRaVqpeb3rwn0DQdk3A0X0PN36U2wfi9H76mmhIP9mPe0vOhBGog+qIgc7lpVf3l35i9TrvXHqF2dJDEjWUruyQFXq/VzNgUlKBIam6zX3vUnAXUN2yMo4D4//5fvg66wPlIoQggmfE/lfnjDQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(82310400011)(36840700001)(40470700004)(46966006)(40460700003)(40480700001)(6666004)(478600001)(36860700001)(47076005)(81166007)(36756003)(356005)(86362001)(82740400003)(7406005)(2906002)(7416002)(1076003)(16526019)(426003)(336012)(26005)(2616005)(83380400001)(4326008)(70206006)(54906003)(5660300002)(6916009)(8936002)(8676002)(316002)(70586007)(44832011)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:35:48.7671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e461c7f0-c2e4-4b7a-5bf2-08dbce4ccf09
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989EA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5205
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
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
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 arch/x86/kvm/svm/svm.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1cfb9232fc74..4eefc168ebb3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,10 +59,14 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
+
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
 #else
 #define sev_enabled false
 #define sev_es_enabled false
 #define sev_es_debug_swap_enabled false
+#define sev_snp_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
 #define AP_RESET_HOLD_NONE		0
@@ -2186,6 +2190,7 @@ void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -2261,6 +2266,10 @@ void __init sev_hardware_setup(void)
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
+	sev_snp_supported = sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SEV_SNP);
+
+	pr_info("SEV-ES %ssupported: %u ASIDs\n",
+		sev_snp_supported ? "and SEV-SNP " : "", sev_es_asid_count);
 
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -2277,6 +2286,7 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
+	sev_snp_enabled = sev_snp_supported;
 #endif
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b7b8bf73cbb9..635430fa641b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,6 +79,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool snp_active;	/* SEV-SNP enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -339,6 +340,13 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
 #endif
 }
 
+static __always_inline bool sev_snp_guest(struct kvm *kvm)
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

