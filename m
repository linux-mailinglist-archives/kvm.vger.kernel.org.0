Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F979154A
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240573AbjIDJ5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbjIDJ5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:57:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF26CD1;
        Mon,  4 Sep 2023 02:57:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoy0agY4Ivu9FWn0SAgmd27TtafKP7aPc+oAXdcnCwarCp8GuOAXSCUzr3MLE44INxiWRaOeRUFbwBRYAE5g7ELFX8T4acn343sy2kKr2br3D8kBJOaJLFDq5OnhDVMCfj0mtOhoEHEfZfGmUC8x/sSOpACZ77CKGHteT29Vdcml4LJ0Z1Ly7GPelnZhi8YH2zCtGbglH1ussuEL+juYTg78hgKWLD/UBgg1AH7Y3q2NbaSPYzl3u+Y+hMuuRuBGZBYk/5Y37H6mlLWxeDcobNKqGbVq+OpTZ1z+YlcZWfJ6Ci6P+050JBQ+T3pdFhpWkqIuxg5Osh4JYzCcjFj4eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obzPlVxtYAb0u6aVFV5MTjZqBluXRs9+qEKcRm+9MNc=;
 b=R24QtIZ7mtlzefxYSmBp00WAeARQYmfnE/IxwEyWrJqynDeis5V00LDi+Uzzh8TzG4TrAgttlUUH2nH6GZ5VuRBmv91k5234YicVdzhlg/V90lQ/kLcfs9idFKuD+GIPRCJ8PrsTpxvqzKSm8nZ2i8IT838qubcQxCa0WumsJy20w9T0+YEWkjdu6Dcl40UEZO4UiLQVlWnUI/nL2eOVRpHMJ7A0PuENuzB7SYqYnJYdfUE+9+HkOvAZmYLl823JqgsK/eebFGfTg8s7z1H3jf/ZL5+xrtOjFviU/QlVzixEItvCzxx2NHHApnqAayg6l9yBQn8RZNEUb7BlzayLrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obzPlVxtYAb0u6aVFV5MTjZqBluXRs9+qEKcRm+9MNc=;
 b=FJNGFWnW6Wh47X2Zz5FcwyNESfGhdDhiafm6y66mj3UGbzRugItT85kF6rFSSe4VhGYxcje+q3xY6C3vWF9AiFbRw0nMreUYu5BRW8ECSj6s+PdScqv+JX4VZUmjMKUrnMepJ+3mmCGJ++HUwOgQ0ZlVYq+46yhBa7/LuZJCxoE=
Received: from CH2PR03CA0029.namprd03.prod.outlook.com (2603:10b6:610:59::39)
 by CY8PR12MB7241.namprd12.prod.outlook.com (2603:10b6:930:5a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 09:57:25 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:610:59:cafe::6c) by CH2PR03CA0029.outlook.office365.com
 (2603:10b6:610:59::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32 via Frontend
 Transport; Mon, 4 Sep 2023 09:57:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:57:24 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:57:14 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 12/13] KVM: SVM: Enable IBS virtualization on non SEV-ES and SEV-ES guests
Date:   Mon, 4 Sep 2023 09:53:46 +0000
Message-ID: <20230904095347.14994-13-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|CY8PR12MB7241:EE_
X-MS-Office365-Filtering-Correlation-Id: e1a08aed-07f1-447c-03a1-08dbad2d56f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2sU+ZX3KEd8Gpt7SlJ9mN5DMnV91QAuI7Ll+JofA7tZzmnmrS3IhpUu8DOoA+tEneAac/8wuaYYb9zA4irynCna6yK4ebVM7a6KGBmRLqdr0PMqlsGX/4wZ9U0ReXUbepInX99NCy+MR2a7k8az4G11ODobiaGlyVxkAGuX84sFypoUv2E8JXs1i38iv++gxT0ddiOjvyWLtkmBj/XRTZBMLlQf548LgFe7J5S2M2ZFnON4pVPM3+kWMLuAQTmxFB9Iay/9h0HyfHXUWCcU6NNP7CuGjgtG4PwpM7zlvbJxpHX7wrmM6Fp5efZephHtCPAvBM/XklWMk8dbcOU8EMlcvwroJ2cqS4D8OZesXmj8zQQYIXNE/i8+julfNQInoXBxJSQdAhV+Xg/5uc1SylftayLILXOXok9jEo7/PSLnCe1IWEDfvKXRmygG4bj/Bv9pZVtumZHIJ+bNgrNlhnQZGGjDryt1EloSQa9JRepTY+qBMPj+k7334x1DB9VzbGavQbBog4rrpPhgrEq18LhnELwJNorh0E3CmZrKpMuh15nrmf5NZBHFRljsR6ENABXB+0aoZoCdVc8HqfNCGS0D6HKsxSRGHfs/v+SBJ6IgrGotKiIcnrqcKiaChnpnlKmkRMjuFSvOJ7pIgXJ0vthZRQu0eglMFYmD/qhqYpq5UeuR0wvrtunr9ZxYIIk2loIj6+YeaxSc0e+MtrCsD/WDSBMuiIh1WuoVM9GHUylbCnrPys/i8GJcyQ7121gx1zTex++JwYPtXIGS2UBK66A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199024)(1800799009)(186009)(82310400011)(36840700001)(46966006)(40470700004)(16526019)(26005)(44832011)(426003)(336012)(40480700001)(6666004)(8936002)(8676002)(4326008)(36860700001)(47076005)(2616005)(83380400001)(5660300002)(1076003)(7696005)(41300700001)(40460700003)(110136005)(478600001)(70586007)(70206006)(86362001)(316002)(54906003)(356005)(82740400003)(36756003)(2906002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:57:24.6503
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a08aed-07f1-447c-03a1-08dbad2d56f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7241
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To enable IBS virtualization capability on non SEV-ES guests, bit 2
at offset 0xb8 in VMCB is set to 1 for non SEV-ES guests.

To enable IBS virtualization capability on SEV-ES guests, bit 12 in
SEV_FEATURES in VMSA is set to 1 for SEV-ES guests.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/svm.h |  4 ++++
 arch/x86/kvm/svm/sev.c     |  5 ++++-
 arch/x86/kvm/svm/svm.c     | 26 +++++++++++++++++++++++++-
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 58b60842a3b7..a31bf803b993 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -215,6 +215,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
+#define VIRTUAL_IBS_ENABLE_MASK BIT_ULL(2)
+
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
@@ -259,6 +261,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define VMCB_AVIC_APIC_BAR_MASK				0xFFFFFFFFFF000ULL
 
+#define SVM_SEV_ES_FEAT_VIBS				BIT(12)
+
 #define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
 #define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
 #define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 41706335cedd..e0ef3a2323d6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,7 +59,7 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
-static bool sev_es_vibs_enabled;
+static bool sev_es_vibs_enabled = true;
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -607,6 +607,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	if (svm->ibs_enabled && sev_es_vibs_enabled)
+		save->sev_features |= SVM_SEV_ES_FEAT_VIBS;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0cfe23bb144a..b85120f0d3ac 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -234,7 +234,7 @@ static int lbrv = true;
 module_param(lbrv, int, 0444);
 
 /* enable/disable IBS virtualization */
-static int vibs;
+static int vibs = true;
 module_param(vibs, int, 0444);
 
 static int tsc_scaling = true;
@@ -1245,10 +1245,13 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		/*
 		 * If hardware supports VIBS then no need to intercept IBS MSRS
 		 * when VIBS is enabled in guest.
+		 *
+		 * Enable VIBS by setting bit 2 at offset 0xb8 in VMCB.
 		 */
 		if (vibs) {
 			if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_IBS)) {
 				svm_ibs_msr_interception(svm, false);
+				svm->vmcb->control.virt_ext |= VIRTUAL_IBS_ENABLE_MASK;
 				svm->ibs_enabled = true;
 
 				/*
@@ -5166,6 +5169,24 @@ static __init void svm_adjust_mmio_mask(void)
 	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
 }
 
+static void svm_ibs_set_cpu_caps(void)
+{
+	kvm_cpu_cap_set(X86_FEATURE_IBS);
+	kvm_cpu_cap_set(X86_FEATURE_EXTLVT);
+	kvm_cpu_cap_set(X86_FEATURE_EXTAPIC);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_AVAIL);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_FETCHSAM);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_OPSAM);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_RDWROPCNT);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_OPCNT);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_BRNTRGT);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_OPCNTEXT);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_RIPINVALIDCHK);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_OPBRNFUSE);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_FETCHCTLEXTD);
+	kvm_cpu_cap_set(X86_FEATURE_IBS_ZEN4_EXT);
+}
+
 static __init void svm_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
@@ -5208,6 +5229,9 @@ static __init void svm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
 
+	if (vibs)
+		svm_ibs_set_cpu_caps();
+
 	/* CPUID 0x80000008 */
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
-- 
2.34.1

