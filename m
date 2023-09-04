Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB759791548
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241701AbjIDJ5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238807AbjIDJ5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:57:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48324E56;
        Mon,  4 Sep 2023 02:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcOEMR/hqyXweRkcz3CugCy+wOm6NKeC5gK06+XshSTKN37wWTs9S73w7/51ufGvk2BAgHNedrnUnR8ZMhMq2jTrRR7dDYk9LZja1p0M4Dsfl3rCaFHloF7mJPX6kQWVA5aEGUZJI2VcH7/5CrBmGoVpAeMVEu7TV4xonJLwU2wzxIBU0CH+M7l68bFKllRtnbMWFf0s0TNpg0wOUcgTUQmz4VxHnWD+zIoEOlJCJDiZA+ypbVJFO1ccu5AA0gEqsg+8suLBqkHbKuzLpRejKstr01u5SnEQwhHYeYFKCqICmF2aTPmCj0YUN57yNltWAebhFZirg/kreQ3iSGvFIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBMP/CMWRNnb7qWv9ceGoFp3otNxRFIyvWhtuPX5p24=;
 b=MNGUlwpa7MP/Dal8mys5iaiH2mf3claDkgEC49caJvYJ3F1+UPhZpn62pIyeXsIvHL7QmOTXwUIEadFiHf53PPnKj23SfjeHcZ1GD4U8xl8n5NN0YNdHCVU5xyk7Fj5w/h78ir2Z58Ivx+vJ78wvcKOKwIRBVGXo47hQcbCOZxMe0EZGvxrUQV+Tk2U87tbjq8YapPLwemxukG7pkIulPJgMJV+o6QLWkSMXUSKhOO6C7Q8Mul3L4EgnVroZ4MF34wbQHzhq8BHXAdogvUjZv+FMjdefwVq1OjRs+Uuw3lEg++cqylMktu7n+CG1P7KT7Ck1HLZA2SXRBNMhFHFTNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBMP/CMWRNnb7qWv9ceGoFp3otNxRFIyvWhtuPX5p24=;
 b=o5RazvHct1rzGJzGx8RFrs1M52iioO0ITJ/elXgy4RIiHhS2PCFk7UkZmVb6YY/87qBc4AIlqdbR2yr7MVO2uu39Cvd31Y0Om3Dif8LkPDjILg3L/wA2lKRWNQP5MJNK+FpflfMaLfExkOS1dlbx2QKtfJ/18KMDwInnCIU2B6k=
Received: from CH2PR03CA0026.namprd03.prod.outlook.com (2603:10b6:610:59::36)
 by DM4PR12MB5182.namprd12.prod.outlook.com (2603:10b6:5:395::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Mon, 4 Sep
 2023 09:57:14 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:610:59:cafe::b0) by CH2PR03CA0026.outlook.office365.com
 (2603:10b6:610:59::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32 via Frontend
 Transport; Mon, 4 Sep 2023 09:57:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:57:14 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:57:10 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 11/13] KVM: SVM: Add support for IBS virtualization for SEV-ES guests
Date:   Mon, 4 Sep 2023 09:53:45 +0000
Message-ID: <20230904095347.14994-12-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|DM4PR12MB5182:EE_
X-MS-Office365-Filtering-Correlation-Id: 87fea6c2-763e-4e6d-ef1e-08dbad2d50f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fcwijr+7opZsbeGo3sJBA2wHe3oz5cAgWkVIwP8h21wINyCGNTYf0rs76yoXJuAdL779rkE9GKRemRzeL1uZXC3BAT8nJAHLVRN2Au83dlDPKrby0T18/J7o8PLkq/oSKCp5CPnz7HcECToyVXYRdTpqrHQLAJ1ftuOFneJieWzzdO1iEZBC8RoOtMNpzkCkLm+bgz4y/DI6jXCF3tIhTAVVgql8ddwEaaa72IbY7k7TXRU4Q7v4ozNLIPtl5licn8S/Ar9dC3dX80uzhJfoat18RJTmOA7xG4CGXG5vRMafVpogJJsAd2pV1PzhlwQEKCKQd3nakErl2ceuxhVtSdn/FZuXOqGOwF7ahBODiJQEjWmVTcsgkFUHr9MPXv9A+McqgiY/bqWR0nE9MnKj9vgTLLRDa3r1CMcEeZz2CfBL/+4iyJbD03tSXUx2dv1vYangA2rS6J9zx+haKDC5svLVxECvFapj3O5xUSYbIWpqDrnxvCUjBOUeEmuTs2vuCgMfSBCWUx2vt49FTADJnczLx2MddoMDGu1574GXqC1P8Oz9qLFTe1Cy0ALgldgGTaUL2Fc+hBqfRFlpXAqHIUEBVEwkTNQv/tkW84HfoPlPzSrACtTkRLU3j4r1LRNBBRUKgXeSAmCbBR+9zf28O4NWg7cedOMPYgOdJpLLxHnOMSE4SsurIFfyynqvMfNj4GNsiduyPmxClQQhlqWdnY6iMIvWpaX119kBxQJnQe+2KCorgDRF91ol359g69yeoqn1qtE7JPIJj3EcwKBMcw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(39860400002)(396003)(346002)(82310400011)(1800799009)(186009)(451199024)(40470700004)(46966006)(36840700001)(40460700003)(41300700001)(356005)(82740400003)(81166007)(6666004)(86362001)(966005)(478600001)(2616005)(83380400001)(426003)(336012)(26005)(16526019)(1076003)(47076005)(7696005)(36860700001)(40480700001)(70586007)(70206006)(54906003)(2906002)(110136005)(36756003)(316002)(8936002)(8676002)(5660300002)(44832011)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:57:14.5795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87fea6c2-763e-4e6d-ef1e-08dbad2d50f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5182
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the IBS state is swap type C, the hypervisor is responsible for
saving its own IBS state before VMRUN and restoring it after VMEXIT.
It is also responsible for disabling IBS before VMRUN and re-enabling
it after VMEXIT. For a SEV-ES guest with IBS virtualization enabled,
a VMEXIT_INVALID will happen if IBS is found to be enabled on VMRUN
[1].

The IBS virtualization feature for SEV-ES guests is not enabled in this
patch. Later patches enable IBS virtualization for SEV-ES guests.

[1]: https://bugzilla.kernel.org/attachment.cgi?id=304653
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
     Instruction-Based Sampling Virtualization.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/svm.h | 14 +++++++++++++-
 arch/x86/kvm/svm/sev.c     |  7 +++++++
 arch/x86/kvm/svm/svm.c     | 11 +++++------
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 4096d2f68770..58b60842a3b7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -469,6 +469,18 @@ struct sev_es_save_area {
 	u8 fpreg_x87[80];
 	u8 fpreg_xmm[256];
 	u8 fpreg_ymm[256];
+	u8 lbr_stack_from_to[256];
+	u64 lbr_select;
+	u64 ibs_fetch_ctl;
+	u64 ibs_fetch_linear_addr;
+	u64 ibs_op_ctl;
+	u64 ibs_op_rip;
+	u64 ibs_op_data;
+	u64 ibs_op_data2;
+	u64 ibs_op_data3;
+	u64 ibs_dc_linear_addr;
+	u64 ibs_br_target;
+	u64 ibs_fetch_extd_ctl;
 } __packed;
 
 struct ghcb_save_area {
@@ -527,7 +539,7 @@ struct ghcb {
 
 #define EXPECTED_VMCB_SAVE_AREA_SIZE		1992
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
-#define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
+#define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1992
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
 #define EXPECTED_GHCB_SIZE			PAGE_SIZE
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d3aec1f2cad2..41706335cedd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,6 +59,7 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+static bool sev_es_vibs_enabled;
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2256,6 +2257,9 @@ void __init sev_hardware_setup(void)
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+
+	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_SEV_ES_VIBS))
+		sev_es_vibs_enabled = false;
 #endif
 }
 
@@ -2993,6 +2997,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
 			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
 	}
+
+	if (sev_es_vibs_enabled && svm->ibs_enabled)
+		svm_ibs_msr_interception(svm, false);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6f566ed93f4c..0cfe23bb144a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4194,16 +4194,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	guest_state_enter_irqoff();
 
 	amd_clear_divider();
+	restore_mask = svm_save_swap_type_c(vcpu);
 
-	if (sev_es_guest(vcpu->kvm)) {
+	if (sev_es_guest(vcpu->kvm))
 		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
-	} else {
-		restore_mask = svm_save_swap_type_c(vcpu);
+	else
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
-		if (restore_mask)
-			svm_restore_swap_type_c(vcpu, restore_mask);
-	}
+	if (restore_mask)
+		svm_restore_swap_type_c(vcpu, restore_mask);
 
 	guest_state_exit_irqoff();
 }
-- 
2.34.1

