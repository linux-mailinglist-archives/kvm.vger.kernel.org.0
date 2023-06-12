Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFE772B69E
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbjFLEjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbjFLEin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:38:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA83173D;
        Sun, 11 Jun 2023 21:37:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfJ4DMH5UeL4MLfR70vtA0ZBekZIPM9Vtivv1eQTZrVm2G1KNpXlh+Hpqbhc3wou4StxEiJFjpJtUCiyLDV0QUHmBlRLpmVHoCxrTkXFF0npzq7lrF8yS7eQG34y3JtYTDXqcBax/L8ji+P2K9JSyASNTmhEbfZ22t29Gpbdqg2xUsCEY7oHIUrV42eAesnTxRTuHKs7TXve8qdb+v3ownwMbE/WqUZqFOgBiG/S6/C09yYF0TbQfzpDgsJ3Otohl4Kmm42I09ourWftwPYGRP9Amvoie0pUZyy2whCQI4Pfxpycp8+3kW08Gy3o+I66j6RQ4CRDN4wAcFiB93+xSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOpw3KzGxdOjwJ/TkrcnFihbFz41wbR17m9Hf+7f9aQ=;
 b=kw9r0XvrmMdG+rFbrGD2NOq4pmQXK0/ozB/oM+UBe2+rg7L/Rp72lRPhL8RSDpSYCVGE9Ps0uWE6sQhlBLSVqr/MG552tp9TryYd4I3ZChIaREQb1NUc7w1zpzHGj/VNUMq/eczCU2iSX97fQKbMG3mWkLMh2fqPw4U+y3tqK0JV1gK1ywlbCVHnhQ7F9U+9y/9Ljs+BcxdtwgViHIYYYSKGShkLTZlKNHlgVOqcVnpyFOVwNnmuxCOq3gVw0hTkzLJ2HYxG2a7gse6VdDhgif66FrUJZU8D2ymSh8zSpL8YmSBkYsxQBPjAZoXyGPl0YJQKBZYIE0Z1/MA39BGFZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOpw3KzGxdOjwJ/TkrcnFihbFz41wbR17m9Hf+7f9aQ=;
 b=1g1eaNBGzrRncDD0LAr1f9sRtbUZYIoFWbWXpGADs9AoNjVFcJBfFR0b1Hm8aFS+gny5nHSsjfwdbtvZRJpe6PCv9hXRF+5BOfU0E4z+XLXjN2JDV4hZRmZsIutTjy90e6gu86YVfmQhUp19lokKGD+k8chuoCYVYs1TUhWXAMo=
Received: from MW4PR04CA0148.namprd04.prod.outlook.com (2603:10b6:303:84::33)
 by SJ2PR12MB7823.namprd12.prod.outlook.com (2603:10b6:a03:4c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 04:37:52 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:303:84:cafe::cc) by MW4PR04CA0148.outlook.office365.com
 (2603:10b6:303:84::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:37:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.13 via Frontend Transport; Mon, 12 Jun 2023 04:37:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:37:50 -0500
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
Subject: [PATCH RFC v9 27/51] KVM: SVM: Add initial SEV-SNP support
Date:   Sun, 11 Jun 2023 23:25:35 -0500
Message-ID: <20230612042559.375660-28-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|SJ2PR12MB7823:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a304f1d-13d0-4bf6-408d-08db6afec899
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uLxOKIpZMWOThwXCbr064xUgH6E6BEXvwurUtUUJE6y8Xyh3Ns+MGwSrTLe2xDOBDlNlNpDhqzQM2ox38G2h45Slq50VWTbYTks1w/1NHzNqG2TId4ITzuON1LozCGV7g5A2eLfx6ybroQKMJFHG58oy4B87yx9k2vvCKl2uVIjuT2x9Qi9xYZccGSm+dfi/1kq6LACuFvjvCF6E5kpf7UwWejtJLvMPV1XHw9Wc9Ee5di9Z7Xb3qbgRuCvJjBbGuiy7JoyQZr2nwgl91Iy7e9Es4unsup6Dx2N8LYk5tXgfVHz0vvSZSVv+/lsYs5G2xPmxvBX3ELbp1q3Kv2oPFBsdyl89zfRBXYvRQZI7qX4sOZk+URGizZzTdIcLeljBipQikoCd62+e92Wx3M3B6Z4lvj4zQgtUsk4YlJFPmvA3iYLr0GvfZITr/p5F2lQRbjiMUjOz1lFvkzb3VKtZi7jTOgQMeMd46PE0L4WlfDo1y5PJznczKj4h/5oiBYW7vdshghfPrxgeH394eKuFiRKMrshDcOvZ1aoEde2LKJByWLUrS+YoQ0OKWQpPfqH/oogsqr5O1XVODSZrh0gdAy4XHID+tzKf+EzMQ4Kfz2EyLeuKdPlgcPL2g6bbrEeKK9q8JQuXRjVY/q7wEY4pcYf1al5kYfIOZJ6nBo6NsKKOrVPJ3PbsDXOTgQLl9b8mQJJYKwx3K8o8a/UviNZ4VKPcKAMA4/Ud+50moDtDSzvlcZrzbYpIaXiDQ/aPUv06KeNlyrtCdWdJ0R5bl589hA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(70206006)(70586007)(5660300002)(8936002)(8676002)(36756003)(4326008)(6666004)(6916009)(54906003)(478600001)(40460700003)(41300700001)(316002)(81166007)(356005)(40480700001)(82740400003)(336012)(426003)(16526019)(26005)(186003)(44832011)(1076003)(47076005)(7416002)(82310400005)(7406005)(2616005)(83380400001)(86362001)(36860700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:37:52.1218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a304f1d-13d0-4bf6-408d-08db6afec899
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7823
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index 69b57e8f0a7f..f5fcf6c33583 100644
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
@@ -2169,6 +2172,7 @@ void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -2248,12 +2252,16 @@ void __init sev_hardware_setup(void)
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
index e45b54e95495..6974d63c84f9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -77,6 +77,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool snp_active;	/* SEV-SNP enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -346,6 +347,13 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
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

