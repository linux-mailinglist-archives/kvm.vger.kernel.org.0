Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6A35527BB
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346531AbiFTXJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346633AbiFTXIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:08:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E62C22533;
        Mon, 20 Jun 2022 16:07:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXbXueQxWWTrTDMzGC+dfiuZ8g+dvLOEu7A2eAwbm0WhsssU3CwkZqdUHseEPWi703UDQuRfoZ00b9Sl03HstmN+vMeGxDIARg4A2kG1C8XkVINYkVpgwK17LF449xIxjiBYlTAl3Bm4ZBp2n6ZZYYG+1fzeiWVNQye3AHLzo/PwHSkw509rsE3BpbQLfdVjYcPKlHYi/Eo2hJrCiWahDRkphBYP1hYvl0bXihkFKcCGcVOzlU478fYRqaxm97xEyKF2CaCw5LDUcv10SpjCvwgZxQ+FGAR5MuGD+55bl7kxlEWLyQmjGAb9K5rJH2yFylTl9BWLQcjXFP3tpnImuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AqG3hIYcgwAaeeTQokJRRh5536uSMkSgoG0GIC8Kkcw=;
 b=L1Y+VL5jna9IdIu2oLpF+mWHwkfviDoWaWkM3Iq6LSzkFvTPhn+aTQkzfovfOwLpQm0o5tmiGc0tKRRCqsYV3f27OH7u8Iqx3OI1I//tAeiWzG37w9iyqWMbW40i+hXw7AEd38ZDcJLpLT/laFf81gSfeS32C4CNmF0lUywdBbvP3WsCHxQFi1W2mLt58jUjZby2lordg9rUAcliOS7O1akA9II0QC1oNwIWEA/XyMvh1w+Ig6hJZRKxnvy/+Q5lWh0smksAVRHUSIzSbzi7lOj2aC0Bd/nhuacyJ4y9LadiGiREKebribWi+o7Kw/+GM7vjPtwzccZcg6UPnwgzeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqG3hIYcgwAaeeTQokJRRh5536uSMkSgoG0GIC8Kkcw=;
 b=me7dHRIMgUG74WRQM728a7JVtlMbccmzXMFxy1UMAvvgYir0QqR9yQ34i7zFa1L3nNyolhB6zS3o/nvNPI/YYCz+CECbjVgbEO8zhCuJZzMXcQrJht4urAxu4J5Ke4AWF1tityZ5ykSal8ctMvfoN39jil9FWUhdz4fn2g5BBjk=
Received: from DS7PR06CA0013.namprd06.prod.outlook.com (2603:10b6:8:2a::13) by
 DM6PR12MB4893.namprd12.prod.outlook.com (2603:10b6:5:1bd::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Mon, 20 Jun 2022 23:07:17 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::6) by DS7PR06CA0013.outlook.office365.com
 (2603:10b6:8:2a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:07:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:07:17 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:07:15 -0500
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
Subject: [PATCH Part2 v6 22/49] KVM: SVM: Add initial SEV-SNP support
Date:   Mon, 20 Jun 2022 23:07:06 +0000
Message-ID: <81fb57838350832e2e1514e305def84fc28505a2.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2cf9bba6-5419-48ac-c258-08da53119f12
X-MS-TrafficTypeDiagnostic: DM6PR12MB4893:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4893C55F11E0209D5FF3900E8EB09@DM6PR12MB4893.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWFGPRNPTZsb0RTo/vyHEFDDAbeEn8oDPg9FrYmYY11lmARtGuAluSqRuhCzFv4WJx8DaUflK/8vLiH0jhTcR0ZZfdxyCmIsl/UstUGdJZgiSb0P2VwQUSF39FLUNGamo30HI/qzjn257NP3tXFIaxF0wp6ZJLPPDRHFpqzeYOG33WI9Kry0IifP+Ua0fft+wMOaNgcqdVxqK4lRBy9oX+OhyeuI0umUSwwvUQxzQgY9XUVllRaIUF5WfRiuGUIN0ZtkIZPhQYMoquNdIRDZcwzU9/DTTNDFmE5vw6DI7fjabCDKlKSZdY5A0vtK+J9yLOtOBjRax4WJfbZJ6YpBVDZx94Fb/UsZBXUj0H20LBxlwaGr8XhUWVgwRF56eb2yhmpeITcFqAgrbiaHlAVjHbqtQL4TZXMXge38CeVSySAJWwtaxT7osvgPA/KjDp33Uwpl8ODcv3dEkp1ENoT19lkZgX3tZdJOZWLdc+b+2GBrHYVGHASlxgPshc2HES5a2bVyEghRwu8tOMfpTyaoWkiNfnR0/nLfURL5LewKj4fqB5cGGX/NpvPmnZ1tHcG5mDMhyE/fRIshnzZ7PxBU/BYPvTZ19qsNMohRf2V9UxxIwmYcBoCd6UL0EAYNUr9VFOCn2R+LdvXfsaLlP6Fbn8TahAtI7KVnFsGnEjL5d19+NsobGojWOTAdd8FDcxBQ+d5MBAJLB6NGfP+PeTAUyMRzfsCsdIsY8tjvZKkA95S7iTrPk9KbNDM/NRse9LuFEgji2+0vzNzuDTOezHJEEQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(39860400002)(46966006)(40470700004)(36840700001)(2616005)(5660300002)(36860700001)(7406005)(16526019)(41300700001)(82740400003)(7416002)(2906002)(186003)(81166007)(356005)(6666004)(40460700003)(7696005)(86362001)(26005)(8676002)(110136005)(82310400005)(47076005)(336012)(426003)(36756003)(4326008)(70586007)(70206006)(83380400001)(40480700001)(478600001)(8936002)(54906003)(316002)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:07:17.3765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf9bba6-5419-48ac-c258-08da53119f12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4893
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

The next generation of SEV is called SEV-SNP (Secure Nested Paging).
SEV-SNP builds upon existing SEV and SEV-ES functionality  while adding new
hardware based security protection. SEV-SNP adds strong memory encryption
integrity protection to help prevent malicious hypervisor-based attacks
such as data replay, memory re-mapping, and more, to create an isolated
execution environment.

The SNP feature is added incrementally, the later patches adds a new module
parameters that can be used to enabled SEV-SNP in the KVM.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 +++++++++-
 arch/x86/kvm/svm/svm.h |  8 ++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 93365996bd59..dc1f69a28aa7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -56,6 +56,9 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -2120,6 +2123,7 @@ void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -2190,12 +2194,16 @@ void __init sev_hardware_setup(void)
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
index 9672e25a338d..edecc5066517 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -75,6 +75,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool snp_active;	/* SEV-SNP enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -314,6 +315,13 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
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

