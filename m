Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A93869D3C8
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbjBTTFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbjBTTFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:05:48 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D9E21976;
        Mon, 20 Feb 2023 11:05:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2aenU3s6cZD5hVCPjgOAoPTP2W6rpwaGeyZr83O6oQmUVFM4kuTcJt6HKSjhWX19hO2dOBfdpmMSgPqyTn1t9RLJfARFZkvE0tUH0IgceK6WT8/8FSNFBTDM4zf/0vSqxfTZPxzRjBT2vD7VbgpMhddkYyojjzbKs/v02IDznlB/U0zvsHWvdjuIsg18WXdDlMuFE+a87dYKnwvSGToljI8gdvNPXYaaE35T/eOdMlxsh+DioN0OvoR3H0l0wspm8veTfneXVA+L5N0Yldz8MLjTNkAfdA/i7IJ9kna610n9upu7pSsuTebYMNf7X+Dzev8Zi7jYu8lLZ3X8EaNdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnmyPryN/heSuGOFY8VRmqMvbLRbxeGy7ersAZFqHrs=;
 b=cyK72mdA3W40+GoElJkksYkV12Nto+lYHLiMJ/ICUDyoEJ3KVjyZg/NuIXRcNbHoaUuYSxNC3+mBGGy8D1gC7glvcPb765MhP4FyhqAlJR9daQ37SRiCFf2iRrkO8gwuhtWypydJZDHimaFDeTwAG4VwAXG7w0oc8Z7C7A0TpA9T03/AvGIxpmqHqA5J5k92Zbtm16uGEtIMccecPPbKsWjD/jUUeK5mQqbGtxfC/jC5u0HdBGdjrfF79MVf5SlE0w1UwbiSA4qaOrUZEUS74Vr1o0hEaP3dmKtR8Xq979/6OjULjQ+j1q15EstqVgmHLviXERNvZeGS7hN8615DUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnmyPryN/heSuGOFY8VRmqMvbLRbxeGy7ersAZFqHrs=;
 b=3CBYj510JB/Xi9kZ6Rl3hpwED5tzOJQUeTWTpyiRgMGVC9uF5d1tQ9FoovDjnYQG9HiisJNLUy1rFsklT2loKSWjAYNcQOh7pWeh/EL6jWbxpvvI70zyxICUQbEl4tuv6/k+MZrf4Rr5YyL+RTa9h2Udlzd/jh8F5zwGLo6Br4Q=
Received: from BL0PR01CA0014.prod.exchangelabs.com (2603:10b6:208:71::27) by
 SJ2PR12MB8112.namprd12.prod.outlook.com (2603:10b6:a03:4f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:59:44 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:71:cafe::65) by BL0PR01CA0014.outlook.office365.com
 (2603:10b6:208:71::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:59:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:59:40 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:59:37 -0600
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
Subject: [PATCH RFC v8 51/56] KVM: SVM: Add module parameter to enable the SEV-SNP
Date:   Mon, 20 Feb 2023 12:38:42 -0600
Message-ID: <20230220183847.59159-52-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|SJ2PR12MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: 52d75de6-2d76-454e-aea0-08db1374a0ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sTe4xAMoq5qs8YNKgQysFoV6mcA4pIKYsNbhB2cFfiIcPw1x9RKRny+Z0hBatdIf5FTLLRcg5W3wDysgVBdYh1lfTi7F6Fs1nIN+tNkGEI7oppP90DgN0+cbjwYXpGkHSyL2IuypupiJIqHW/vn4uTd26PcIBsW1dW/BIeuj47sIAeDxq7r07GE39CrjJY5dE4KA6u6gSpX3EISmF4BJj1OlZIzsOH+J7dEAKgy0Rz2QpDHH8BLdg1EkuWLVuQ5YkyYqzo0TH8tjs7Hq1/STP0quYMEHxvXJMe4eGnympgGX4dsIbHhDzgR0PtjQAhYsBwRKzqmEj+tqYYF8OrxmXgVM4Fav1RC5OGt1CvMVveBnmonxPe7lo3p9idQx/jjiuDONs9bFaoEEI9SB1hDsXG1u0eCT3sqz32timjJHqipHfV2AH1w5sUaxhmBut+pCCtWe+Sb7JnSRSKg8NxD6qhjL3lRuT5CVA+/bRTPJn6JKzXK6ZpU//6c4rMCnaOZ/dPRmhojKEBc89kR01n8Wa4OD3vFk7PAYmkIyTqiGzfeJBbxg40YN7aasn8Kt1rMk/rAvpv0ta39uKFqPKcBmCVAoJTMbbJbo0mnyvKq6cV1JsdQ/L1X8r/GuzwRZHSsWESr13zeqafFB42q2Pnn2cjiDsCg12Rew/TRfpSqA3D9/3Ta4Cl7EMw5FbbmtXTnw3QhjPKqJH7tiEBJPmNXrqOeain0aINXfviAd7s6VDFo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199018)(36840700001)(40470700004)(46966006)(40460700003)(41300700001)(83380400001)(54906003)(70586007)(316002)(2616005)(6916009)(4326008)(8936002)(6666004)(1076003)(8676002)(70206006)(426003)(47076005)(26005)(336012)(186003)(16526019)(478600001)(36756003)(40480700001)(2906002)(82310400005)(82740400003)(356005)(7406005)(44832011)(5660300002)(36860700001)(7416002)(81166007)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:59:40.8781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d75de6-2d76-454e-aea0-08db1374a0ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8112
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

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 7 ++++---
 arch/x86/kvm/svm/svm.h | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bedec90d034f..70d5650d8d95 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -55,14 +55,15 @@ module_param_named(sev, sev_enabled, bool, 0444);
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
index 857b674e68f0..221b38d3c845 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -694,7 +694,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	0
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 extern unsigned int max_sev_asid;
 
-- 
2.25.1

