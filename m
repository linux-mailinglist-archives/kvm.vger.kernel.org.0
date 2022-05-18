Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88E352C01C
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbiERQ1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240089AbiERQ1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:12 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8BB64703;
        Wed, 18 May 2022 09:27:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NctJ6T1axaQ5cYl97IJlDHMiR64uqHFPvCnayZTlXIm1DK93RJ4hdc1qHd1aYGM1LjPaIUjA7TkGVWPuTxhnUzQwaa954HGKc5QLPat8L+tvRRZQwhU1tAmiEsnWy15OmPvKyv1JfuhF2BLZlbLX0qpmXzdHkJHIIgmKlU41HQMs8ZeWNt5hbpJ+vEjt+TUnPtHIkUDRpgS0ZYYz9zFwVgSX/EppNbkMKco+O2svJUjX8FnmUco770lcSLhRS+qfcxyFYN4yHRjJlYmw4ttcc8h/0bpAhU6CpchQx68NkVg4oJ5DOCx0bBhe0FbyFxPjr5O5bdW+rM+BWCsVy6ZLHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXbUDqjRmzsRStQJiczH5Ed8Uo0mFMfsNCIw/RPMjfQ=;
 b=bk1BqQtALK2uFoN7eUIQZ6rKiI2ZSBzsBxPZEmEwMPlTibKARGNKBUgtK+36CcikJ6YaW0adDrotLfTvWJXGLPjPCXfr3MeR+obF4He+ze2BJeKs7yna0XdCZ1U2IUE7KyBCSHPfM3zElQLmbQXADZ+DjsHpHKnbqob3qljd51LyEbgxHWjAvs95g0BRroEQOIMXQ7TdWaiXYc9mCkH4SuLgq4W7NP/vT5gs2zfAg24B/i+oL4CWJq7va8LUoUJ45g8bw2zUSqj09j1i2eLXOd6pAlMIcSklbZUPYDEoaH1vFOoH1+mhr8efaRZDlDcW16onP7wp8fKtepX0JRiqqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXbUDqjRmzsRStQJiczH5Ed8Uo0mFMfsNCIw/RPMjfQ=;
 b=WWdwJwYX8HBCzvtfSMlKfVL7t8+NSYj9bc2IkvOsaNVz0a4vdPlUiVSaqGHhKvQ5RMgnmdqeyc/Ci7odExL0ShB3ShQpNS81XsFVASyOIcWC4qLgGZ+FQFfznUkuMPe9MsVWRBeYQ/KwxJyPmEPSU0Yab6wZj8hXdd/QVz+jyvw=
Received: from BN0PR04CA0152.namprd04.prod.outlook.com (2603:10b6:408:eb::7)
 by DS7PR12MB6143.namprd12.prod.outlook.com (2603:10b6:8:99::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 16:27:09 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::b) by BN0PR04CA0152.outlook.office365.com
 (2603:10b6:408:eb::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:09 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:08 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v5 03/17] KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
Date:   Wed, 18 May 2022 11:26:38 -0500
Message-ID: <20220518162652.100493-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82813609-980c-4599-a432-08da38eb4170
X-MS-TrafficTypeDiagnostic: DS7PR12MB6143:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB614354B85B59ACC4C01EE86EF3D19@DS7PR12MB6143.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ij8VhjMMur3RUiaKu8FX6hhh1UEaOsUSkKc/dNX9dzC5vY6drCLhjzcq9L9np2yLCQ2ksayrzpRZ4KbE9/fdYyUXW5+hCjMnOtDq6OrVJVBoJeW4xj5IG17VVnlABAlzdOFY7WlXX+8XEClGqEtkrU3bHkVWVnUXGmKqU44ZDoUQd/0Uf7IDFc75CCt6gYTyhs57DcuOgEqWsFVEEneUU6Z5MXypvm5OCuRPCeFUaZ5B4edtwwawH5VJsEfHUAEm2iSCCTJ2Dc+N3J9SX0V6dUuVdOwmgL0hm+YwyIu1ZnfWA3BTxJqLxq/YYPSkAn5iIM814wuT8ZvrjHTe1dj2mQLjW0Vg3Qogu2nmBo26MaKPS/cJPlTaiij0fSLHeHhK1mDwZE1xkP6adNmqWjfBP/Xr44YJH2+WkKW6r4djIWM2uPVl13J8lIUQ18g8yBRjKhF6JUEH2/Tpv+8hxSewBWMxBGNbxhQZTEb5J5cOhC+tVRCqi78b9AUPn2xt4onzAVSL/KaqTl44GpYgiAQKgVkQtTOeJo/tMz+ADYyhpaaqjeA0wqFWjKJ+MJR8K/MdDVtP5Fiu3aVijhnNklUM+g4rJ06sfSgkDhIlllAWSZmhN6Js1gIUEYwj/JQf5HHUI2mrrFHhznUnCDAyf9QAl5RSKkBe9HBonGyJVezvhLhFQQAEyt9TDeUvjgQOEsz18263mqYPYaBzq7hL85ireadnlD0aPTnFNlPj4HHh2N1JqDo6dbsIDbqrR0MZ/Qj+TMEi8NtLr4kRlFk2wWEWng==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70586007)(70206006)(83380400001)(316002)(54906003)(7696005)(508600001)(110136005)(8936002)(81166007)(82310400005)(356005)(86362001)(6666004)(36860700001)(40460700003)(2906002)(186003)(47076005)(16526019)(1076003)(36756003)(2616005)(336012)(8676002)(426003)(4326008)(26005)(44832011)(5660300002)(71600200004)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:09.1936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82813609-980c-4599-a432-08da38eb4170
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6143
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  3 +++
 arch/x86/kvm/svm/avic.c    | 45 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     | 15 ++-----------
 arch/x86/kvm/svm/svm.h     |  9 ++++++++
 4 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f70a5108d464..2c2a104b777e 100644
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
index a8f514212b87..7d4e73e95acd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -40,6 +40,9 @@
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
+static bool force_avic;
+module_param_unsafe(force_avic, bool, 0444);
+
 /* Note:
  * This hash table is used to map VM_ID to a struct kvm_svm,
  * when handling AMD IOMMU GALOG notification to schedule in
@@ -50,6 +53,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
+enum avic_modes avic_mode;
 
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
@@ -1077,3 +1081,44 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 	avic_vcpu_load(vcpu);
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
+	} else if (force_avic) {
+		/*
+		 * Some older systems does not advertise AVIC support.
+		 * See Revision Guide for specific AMD processor for more detail.
+		 */
+		avic_mode = AVIC_MODE_X1;
+		pr_warn("AVIC is not supported in CPUID but force enabled");
+		pr_warn("Your system might crash and burn");
+	}
+
+	/* AVIC is a prerequisite for x2AVIC. */
+	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
+		if (avic_mode == AVIC_MODE_X1) {
+			avic_mode = AVIC_MODE_X2;
+			pr_info("x2AVIC enabled\n");
+		} else {
+			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
+			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
+		}
+	}
+
+	if (avic_mode != AVIC_MODE_NONE)
+		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+
+	return !!avic_mode;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aa7b387e0b7c..196bca5751a1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -188,9 +188,6 @@ module_param(tsc_scaling, int, 0444);
 static bool avic;
 module_param(avic, bool, 0444);
 
-static bool force_avic;
-module_param_unsafe(force_avic, bool, 0444);
-
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -4913,17 +4910,9 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
+	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
 
-	if (enable_apicv) {
-		if (!boot_cpu_has(X86_FEATURE_AVIC)) {
-			pr_warn("AVIC is not supported in CPUID but force enabled");
-			pr_warn("Your system might crash and burn");
-		} else
-			pr_info("AVIC enabled\n");
-
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-	} else {
+	if (!enable_apicv) {
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
 		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 32220a1b0ea2..1731c1f3884b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -36,6 +36,14 @@ extern bool npt_enabled;
 extern int vgif;
 extern bool intercept_smi;
 
+enum avic_modes {
+	AVIC_MODE_NONE = 0,
+	AVIC_MODE_X1,
+	AVIC_MODE_X2,
+};
+
+extern enum avic_modes avic_mode;
+
 /*
  * Clean bits in VMCB.
  * VMCB_ALL_CLEAN_MASK might also need to
@@ -603,6 +611,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
+bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.25.1

