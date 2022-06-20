Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3F4552821
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347089AbiFTXTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347148AbiFTXRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:17:45 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2072.outbound.protection.outlook.com [40.107.96.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8F023BE9;
        Mon, 20 Jun 2022 16:14:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTHcJL/UvBqxDnrZss6HcpkteX+XKTLRCWn/SCf5i7t02b9WIJWx90CekzVuKdV8OKGloyPKy2YX20nKZffoOKH5Hf749vnctSNtPKfZKry8mayoE1aHXtjQr9D1dW7HUyG7U0d3ih/F3STCp9pY5tJfMwhT7rT4QKaJXXVI7ujYCjOxAT/pEXDrM1fZjwlE4dgAbr0d4u2getl/gBWuOO4LBTDmoE6HlD81mdbbcIJ0aT4irqccQtpCPQssbFCj2d6sdsZs4yQdds3yihI7mwVGnrrPxYEv/igWmwYTMjk7eVXCIsX52ppgm7tDc+U4fubjQ5kusJ2FGR4+nl3Eeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrTmDG8FFhLZCqqlrVRTue53NXpuwUEgHlgWlrLtd5E=;
 b=Jh7jowCLVlM4qoQZP9K++uuXSjqWQGkmf4UZv0utfJnlR3HRLLK64u+cpmXPBCbL+r4He0HYnxfYigq50v8rgTv06WQt1Sps1g4zhdlvboOC4q4BY7Pp3msmya1IFZW86an3Z98l33tH2cKIsDaLMGwcQ73icxFgWlWvI9fFWvAtKG1eLRstK4PfKoM7yh+CI6DOOVbpi+pgR3q7I6+zNB/SkqcFju/CT5VCe47+HRLhFbQ2PRE88ZsQPs5TKbQwWCX4nyXA9YbmYvePXlley6L80wsuY5SNYUL1LizLRM2aIUcOEnVwB9dsd5u6N/+YHCUR/qM2dgAEj1CMq9R4Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrTmDG8FFhLZCqqlrVRTue53NXpuwUEgHlgWlrLtd5E=;
 b=eiCrCiNsOVKQYKgiGO/E1wPg/w6QCY1mxG3D89Ct+1XvqobhxpZYXKKP2etdCaPvIpN/CA34tlm7sONlEcoD6sSytrJJO8uwFukH+WgX5UZQGuGq/COO7M0U+TAW6/MlQOv3iimGz2w+C+EHf8UFodMcB9xVO28lmiCKZNCBN1A=
Received: from DM6PR01CA0010.prod.exchangelabs.com (2603:10b6:5:296::15) by
 PH0PR12MB5678.namprd12.prod.outlook.com (2603:10b6:510:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:14:38 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::7e) by DM6PR01CA0010.outlook.office365.com
 (2603:10b6:5:296::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20 via Frontend
 Transport; Mon, 20 Jun 2022 23:14:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:14:38 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:14:36 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 45/49] KVM: SVM: Add module parameter to enable the SEV-SNP
Date:   Mon, 20 Jun 2022 23:14:28 +0000
Message-ID: <83f8b60ce5cfee305fe44ec70bc5d4329d08b6e1.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf3241d9-0f7e-4d38-3bf5-08da5312a61b
X-MS-TrafficTypeDiagnostic: PH0PR12MB5678:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5678CF8712577F4050ED29B08EB09@PH0PR12MB5678.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XtQyPRZ3yQu+BfEucujqIrzvBmJgT7fi0oUxUjxhNBnqt13hsgirqwD3OCtYV5IjeigcIVdjR8S8XsCkg9hOC5bl+Aq6IIXEHfhBODnG9/DLadnxcOaXvEGileMNtpiFYxn7AnDKLG1iS/3F9lPP8Ghx+o34iS+xV7VMhwmp5eF0NxJt6D9j+z4wir07FroahSBc2sxMCDOKZqSdmNpwTavnt3YJsQDFUcIvnlbgTINu+w7HmafB+XzuJ/5Ntxcb4WyxiEQpgfxsbswBneHRZWfVapo973Ps5PUtctt5XkF7JVxE5wc9hyrBexA5uEiEDsUlF9HCv/ODi5oQKnjO5na5L7i/yA2ggGrZTy8CrvSmdn+F48ykVCU9pQLDSejYb03danUz2AAYY6GZHIA7JBLUOU/2H1+zL+2FbUgivJ4vM5ZW2FJ5SIdumWCdeEI/OtGR5toKhkDBIlp8WxVLprmyejphZePOW03T/9l13X53DXlv8TxeVSwU0647D+aQK4GYDQC37fJ54m3EGVhSPtMjvV0PmaFWh9u9L5M+SfDmNfEYmHHFn9EVabSnDB7XPXQ9ONi5XPRSaFnRtTgJgQMJdvZA/Xrw7MyJf6I/DXzdREKJvMRu9cLoIG6y0uKpeCv6ukz5d5QVGvYI5A8AqWEn9jBmgJXJ2lv7OBDvqMocbZQYZubHRk6Os0HMF3QXuHmxo8brsT06TjvFgR6gmT7iqlvqe0IXafUqJXniezysrxzNFVkAzpD+b1NyVjehdRoCzludJ9ZJjqfwWYED+w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966006)(40470700004)(36840700001)(83380400001)(478600001)(336012)(5660300002)(8676002)(40460700003)(356005)(2616005)(36756003)(26005)(7416002)(7696005)(6666004)(41300700001)(110136005)(16526019)(426003)(316002)(54906003)(186003)(70206006)(2906002)(70586007)(8936002)(7406005)(4326008)(82310400005)(40480700001)(86362001)(81166007)(47076005)(36860700001)(82740400003)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:14:38.6728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3241d9-0f7e-4d38-3bf5-08da5312a61b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5678
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 7 ++++---
 arch/x86/kvm/svm/svm.h | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bb7d4547df81..2c88215a111f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -57,14 +57,15 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
-/* enable/disable SEV-SNP support */
-static bool sev_snp_enabled;
-
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 971ff4e949fd..7b14b5ef1f8c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -688,7 +688,7 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	0
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 extern unsigned int max_sev_asid;
 
-- 
2.25.1

