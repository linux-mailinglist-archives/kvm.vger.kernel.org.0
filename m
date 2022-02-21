Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF0A4BD3A5
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343616AbiBUCXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343565AbiBUCXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:14 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1709F3C705;
        Sun, 20 Feb 2022 18:22:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMtXC2CNlDkx6FUpqXvftRbkpGuwhsvtCFdvobmaiHYZfS5vnsmksyiaYC1US5CwdCsiE/LlRLJKftoEQSPlLkrJ8D6hCATFBEUFP9aJb/YZA4fOLF/kLIe8JQZnkJ3TX6qjtud9V4CavORGJFavD8lKIfTZzKIh+dx1IE+I72NNDt70WHR9LPgQ2tQEQgkrCPMuZWobikSshB2/VjfWQUnAvy7pidxtWZCSF5mBMY6423x2HdnFQ1NQenAFwFr+EsrnF28Ter7jNVb06JHZ0qng48TCehsJD7BwCFv5lNq0Us9vYhXkWU5SC/94SFxG1AL86z+bN5EevCZsesnuGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Sq/4jIOUy5lKmhyM9zojQmjLpPlN4IGvmWEXzP+1HA=;
 b=nmRamYTsd20luQqXesUDq81i2XgobkOPtub8XdMIScFRODb5zSUlYmaEYlJHBrrsEUPvFqmDnnyX3IKp6LTHakMiQjRMZ5tK+uM+BEzb7kdFR3MiwSAB0Zvks70nEsFLd5a6xS3M50fIpNCdAtBjtcpQfE+jS4XfqxucHQe2EL82x5blS2LYrqDRf1CZSRM/gOzXfOJkl8LuOIeUURvsCDa+1DIMK515yi0tTcs9O/VjElUbURsSmUBia4dAxMl0axR0sgJQqpJnJT478YC6XTyhT8vEi9pVtVkkfM5k3RxngW6+fsb8aYgfQrKl4PIJoy8i8StQPb2dyVahmpD4hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Sq/4jIOUy5lKmhyM9zojQmjLpPlN4IGvmWEXzP+1HA=;
 b=pIHffUBwuUfyYJSYfyqd4Ci8aPETfkc8/TuWo6kEbXRpYJL3P3wYKO5jFabC62WxWAIFKSFgolC+EoaXftTNLLlSIqRJZFgoela7hRSMZi4o4XtxZokjS16sHXrGIZ8B0sc9pIScv48dDCoMdikymLLAmgig7E8JF2+6tTZya+8=
Received: from MWHPR1401CA0003.namprd14.prod.outlook.com
 (2603:10b6:301:4b::13) by DM6PR12MB2780.namprd12.prod.outlook.com
 (2603:10b6:5:4e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 02:22:47 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::40) by MWHPR1401CA0003.outlook.office365.com
 (2603:10b6:301:4b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:46 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:43 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 03/13] KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
Date:   Sun, 20 Feb 2022 20:19:12 -0600
Message-ID: <20220221021922.733373-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 751aa630-8e24-473f-4206-08d9f4e10ced
X-MS-TrafficTypeDiagnostic: DM6PR12MB2780:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB278058780B49A00534004930F33A9@DM6PR12MB2780.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rqOPv4m1aTI3fgP8YDJeVYgyQUVf8SuWfQnzA/Wns9ZrGp4XQigJnpEJ/1MB7OaVDlEAaCSsL9enIUfpcqqR1USUug5BZ1Ek8rCGWsfXF5E2pSUjelyFXGkDsioOvcuA6gmJ60MKVL0z0lSMDPqgUZeASvR/VHTIL8mgwJrw+/SPR+MvW4Em7OgTqe4rssaC2StYstcya2AlSCT/hHjGmmH2dytxw0OfYOL3E9qPjCADsiplUeYpXQOf82Bkd3/whxKsmxTT/ZQm6wlVd3XL2+n6MKQBcrKYIuMkNFSX0eUdTyXirfgBmoeLhJOZXaKi+lDtgkS1NeOX2CZ555OFCmhVCuT6Zlom/Qp9SHXENNTd4/Gr4zvLBokx8Ad1ByU/5ompO1zXylhNXc2mdvpvW5jdfQZjovMUcpzXF/YHLKVZZQMpvWdVjso6PrEdmCeUL0LOuNqeKtcvcg+tbRALrAERnAFhSuiqCLbZ/qOKlIE5F/SCIPrxp93qu/Fe1D/efp93v/Z5RkKwd49vRhobrtXVed/VZk412itSFX0en7ooTcqyh+UZHh4dnjq/MxuVh/AAcdiR10Hz0YnuVKgd2KnKrfdN2gOMTMUg0PVb/qlfptREvn38+PktDkkEB1f0ccI4Nh84qL92NpGhWZRJyrP/S+CITJzZ0wqy3jl2zHQNgzcfos+32clQBaYc74RK/Jo/lOX9IcF4VoIJosjPOynTG0y5k+xJIvKLD8x95uFpk3HvOgMjILUMnY0kcplk
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(83380400001)(426003)(336012)(47076005)(86362001)(36860700001)(82310400004)(7696005)(6666004)(16526019)(508600001)(2616005)(186003)(26005)(1076003)(81166007)(356005)(70586007)(70206006)(4326008)(8676002)(36756003)(5660300002)(40460700003)(316002)(44832011)(54906003)(8936002)(2906002)(110136005)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:46.9455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 751aa630-8e24-473f-4206-08d9f4e10ced
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2780
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CPUID check for the x2APIC virtualization (x2AVIC) feature.
If available, the SVM driver can support both AVIC and x2AVIC modes
when load the kvm_amd driver with avic=1. The operating mode will be
determined at runtime depending on the guest APIC mode.

Also introduce a helper function to get the AVIC operating mode
based on the VMCB configuration.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  3 +++
 arch/x86/kvm/svm/avic.c    | 44 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  8 ++-----
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 7eb2df5417fb..7a7a2297165b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -195,6 +195,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
+#define X2APIC_MODE_SHIFT 30
+#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
+
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 472445aaaf42..abde08ca23ab 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -40,6 +40,15 @@
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
+#define IS_AVIC_MODE_X1(x)		(avic_get_vcpu_apic_mode(x) == AVIC_MODE_X1)
+#define IS_AVIC_MODE_X2(x)		(avic_get_vcpu_apic_mode(x) == AVIC_MODE_X2)
+
+enum avic_modes {
+	AVIC_MODE_NONE = 0,
+	AVIC_MODE_X1,
+	AVIC_MODE_X2,
+};
+
 /* Note:
  * This hash table is used to map VM_ID to a struct kvm_svm,
  * when handling AMD IOMMU GALOG notification to schedule in
@@ -50,6 +59,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
+static enum avic_modes avic_mode;
 
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
@@ -59,6 +69,15 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
+static inline enum avic_modes avic_get_vcpu_apic_mode(struct vcpu_svm *svm)
+{
+	if (svm->vmcb->control.int_ctl & X2APIC_MODE_MASK)
+		return AVIC_MODE_X2;
+	else if (svm->vmcb->control.int_ctl & AVIC_ENABLE_MASK)
+		return AVIC_MODE_X1;
+	else
+		return AVIC_MODE_NONE;
+}
 
 /* Note:
  * This function is called from IOMMU driver to notify
@@ -1016,3 +1035,28 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 	put_cpu();
 }
+
+/*
+ * Note:
+ * - The module param avic enable both xAPIC and x2APIC mode.
+ * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
+ * - The mode can be switched at run-time.
+ */
+bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	if (!npt_enabled)
+		return false;
+
+	if (boot_cpu_has(X86_FEATURE_AVIC)) {
+		avic_mode = AVIC_MODE_X1;
+		pr_info("AVIC enabled\n");
+	}
+
+	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
+		avic_mode = AVIC_MODE_X2;
+		pr_info("x2AVIC enabled\n");
+	}
+
+	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+	return !!avic_mode;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 821edf664e7a..3048f4b758d6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4817,13 +4817,9 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
+	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
 
-	if (enable_apicv) {
-		pr_info("AVIC enabled\n");
-
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-	} else {
+	if (!enable_apicv) {
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fa98d6844728..b53c83a44ec2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -558,6 +558,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
+bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.25.1

