Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9751564D0EA
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiLNUPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLNUOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:14:51 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA8F65A3;
        Wed, 14 Dec 2022 12:05:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2uAHIvBVxA8OmsGjOda3ZWI/9PbBSNEvl264Onf9fmgJGx0P85La7+8+zHcb1x6ywlpxre8uCeUrQ+frMm1hhnDQVmc/hziS52LWsq7s8UuanflXJ5E9NzTR10q55+EsjSneAoqjazuW4vqMR/v8oGeB/2kB5LMYXZs0NLawJbX4cafCKO2ZT8/hdIxJcjOgYmHyHR4g9hPf0b6qOtBWsZUW21k7a/cL/6z/PnRNzFoH6x8rd5sugdO79B4VEDIvREpCLtMnMaLrP7xlo+v7jHCK4UVCFeNS3OvKKat6O0GEL2xX8Uvnduqj1LSduuhjvSgHGC22JozyX0627kj/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sCFtQWTk77TMaIV8QgrLv1S9hcmAs7Blyn0qO9scZro=;
 b=nt1iODPWM/ZXWPA9nWgYU6V+xQc0/8ryQsdLye2Vtt4BIFjIJ7KZkddX6gx84f+M3nEkEffvD+cULh0VSLUBbYIyCyOQFf2aNEp4EWqx5ANjHSAn4sSMuciFi24m+Bv83CRIwihovyaZS9GIxCq2ggQdylIJI8IW5CWDhNVZOjAAzLZ589jYdR+ajab36kIqcIsJQZk7G557S8udfi0njBZvMyIalNebLT5unUqJzhmD9ixOAEpHmAOGxYduGGsxh6pUoBXUI7w2HQ5aDhPik1a5y+9JCdXblcyRscoBd9zuNMj4F0BsbSoBBIbtcHLJwfnfelKu5hMGDndciafy+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCFtQWTk77TMaIV8QgrLv1S9hcmAs7Blyn0qO9scZro=;
 b=Vh6XBIBiJ6WLuk5liJyjyeB/hw3+q56IpDEqldTzaUjLz2oXGN28gMOhDtrCtKBvV8de7Ne5ep6cEB3+OTuYLcKhhUoIpT4t2yzxOtS3wJYBUW+BYNTDsxdIfKVKGlZfQoIEvgppn8UR5XzDaI4z+nVUAa92FvK4/Lkat4glzQE=
Received: from MW3PR05CA0008.namprd05.prod.outlook.com (2603:10b6:303:2b::13)
 by CY5PR12MB6178.namprd12.prod.outlook.com (2603:10b6:930:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:05:39 +0000
Received: from CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::6e) by MW3PR05CA0008.outlook.office365.com
 (2603:10b6:303:2b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.5 via Frontend
 Transport; Wed, 14 Dec 2022 20:05:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT073.mail.protection.outlook.com (10.13.174.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:05:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:05:37 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 58/64] KVM: SVM: Add module parameter to enable the SEV-SNP
Date:   Wed, 14 Dec 2022 13:40:50 -0600
Message-ID: <20221214194056.161492-59-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT073:EE_|CY5PR12MB6178:EE_
X-MS-Office365-Filtering-Correlation-Id: b94b5378-05a6-49e0-6f4e-08dade0e924e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hK8S6WDAp46n+eq3J3LyrYc1/Fp1Fz/ZfDmq3axijXBMhoVnlYZ76WXY125XrLhAq6BN44sMr5VeAcFGoenGvWn6ZTAjukJYStjEKrHJzyQzrsC8w+j01Jv4Eh7E1hrEJiR6u0Ra+zy6ME4ikztINZCeiNcNQjsS9rLgOjyKrThltWYOHu1yMxkAGtfEytvapDQzHNx26TJlgf4NmiI7BOyqSggKS0upqwGBTOCwcjjk4EgHX2PDbeEsZiA5sugIdE8VlHjXc5u2qApYSAJcEqEydyRNVKU8QGWPN7MyD1ZpL0UPubfaG0tWZ485U9z6xaIoaPjK4fZWoG9TmccJk1GT17UnLKu+MeAyYgur1nb8HCz/YhDMGV/qKLH3OXL0+ioCODWDzGO59p2mPqPpCphcL9UOu6+P0Apu6iWqfsTee3R/Ocas//ILsaFf9A+70KTJqINX2wbehVBCUqL/uxTChTyEVnB15xORPIDqEekjWBF4YvQ1WpG/7ZvFCKozH2boHUtld2yDQgFIbkx+P9E6h5lnxtRzVcLVYxQGH+Mu3620keW7B1uY97fWMZgiosOXeaeuRKszbeLHgc84Y3hZzEumK5EgpH/hw8chVpl9ywXSJgXIlCLKReLlL86g6B0cW8/g/s8eUDFjMnAB48XouDvrfWo4BWwa2hr06Fmuw9cbh+A4Cq9vFYi2Y2Ufkh8Nu1ZLnsc3thCiMveL89LLdxHWD/9CHS7sQhmJHY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199015)(36840700001)(46966006)(40470700004)(83380400001)(356005)(26005)(36756003)(81166007)(478600001)(40460700003)(36860700001)(40480700001)(86362001)(82310400005)(1076003)(47076005)(336012)(186003)(82740400003)(2616005)(426003)(16526019)(44832011)(70206006)(7416002)(8676002)(6916009)(6666004)(5660300002)(7406005)(54906003)(70586007)(4326008)(2906002)(8936002)(316002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:05:39.0150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b94b5378-05a6-49e0-6f4e-08dade0e924e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6178
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 8783b64557e5..b0f25ced7bcf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -54,14 +54,15 @@ module_param_named(sev, sev_enabled, bool, 0444);
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
index 277f53c903c2..4692ada13f02 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -708,7 +708,7 @@ void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	0
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 extern unsigned int max_sev_asid;
 
-- 
2.25.1

