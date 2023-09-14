Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2ABB7A0E8A
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 21:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbjINTvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 15:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbjINTvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 15:51:31 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4583926BE;
        Thu, 14 Sep 2023 12:51:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoQSum5AaFWC5d2Swhy9PSnBQBV1IdmJeTADPBCTVcKO3QnOmS2Y4STbg16XVEOIkr7UtFBgzuCQmWBYq2lKGvIufcfMvm8TLUUU1Jpp5Zd84zqWY6pzuPDU81Cfk9CBZEsZE0KC2dTfHNc9WNGUTwLTK7FrmC9yWawtlpKBrQBF6VY4mJZw+0RzSfJhD6s7nZu1/2MsT30QWKUQ17ivmOomAm/ll1vzC8LdKQE5AqKtwc4tpDAsSAZaQEn2/6JCCAUDr6z1LXPbo4W7ZVDEodcswxbCgQvC749AtM0b2xdXCfk4jbGMjkWjm6JLohKMG1SPzquhpnkI/VZWeKDwSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryjtQanXScVgjoFWtmekPEcaPOMluYCd+MZp1yqQs8k=;
 b=B9a55HC7QbZ+o1Q7UYJ11MQf3T6lf1mvfvEX1LzLbd2GYb/gy9YwsYfoqdvZKdgMLFiVzvdkpaF7nJCDm6AVoVmgWW866c2J7RgrU4Kx7a+J4i+J2OimD27fPD/kH441tRgc2kTH/0KIFCCe535R59yeU0z31euaukB8mVawFIDkV6LV61CBS1cVhwgFh9NqVTZ6Wn2fj09zk+eOQH6qdTZ9d9APubO37+wpcgLSQsOEhqvwhbqtfyULTJx7FYAC5q0t4xjwIQo4Cw+d3fD08hzGaP6X2Z13jEBMiyEqbG+Y9UYKkYSPDlIYQVHchQ9udyvoUzRRyORZaaxRlJ2VwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryjtQanXScVgjoFWtmekPEcaPOMluYCd+MZp1yqQs8k=;
 b=v0VWSgbE+rZW3ibnjRA13aGu8mchnD16bqTqIPfPfP4BC8n9A9kvFnIou9cplPqVMzXAxiVvUsN7dgjsvYPtmpiTq2cAWx+5PrtG9MYEjR/XQQtmdCuf8dx5IgqdFc79FgS927p789BPAMV1FqiNfWxlb4IR6ZxPtAqTi14R59s=
Received: from DM6PR11CA0001.namprd11.prod.outlook.com (2603:10b6:5:190::14)
 by PH0PR12MB5451.namprd12.prod.outlook.com (2603:10b6:510:ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Thu, 14 Sep
 2023 19:51:23 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:5:190:cafe::b9) by DM6PR11CA0001.outlook.office365.com
 (2603:10b6:5:190::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21 via Frontend
 Transport; Thu, 14 Sep 2023 19:51:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Thu, 14 Sep 2023 19:51:22 +0000
Received: from tlendack-t1.amdoffice.net (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 14 Sep 2023 14:51:21 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX
Date:   Thu, 14 Sep 2023 14:50:45 -0500
Message-ID: <025fd734d35acbbbbca74c4b3ed671a02d4af628.1694721045.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694721045.git.thomas.lendacky@amd.com>
References: <cover.1694721045.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|PH0PR12MB5451:EE_
X-MS-Office365-Filtering-Correlation-Id: 04e64f80-7eb9-4bec-4b4f-08dbb55bf905
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPoUcFE8vvaOgTLL16iBbSl3MB9JjCP8KHArm8R2sMJD8JpWkaOo59f01q1B3zjeNs3c/gwrnqJa2ayWLIOUph4Q2RwUalUDekzgXgM3oQyRw/EumWSeFO3YWPJ1QoVIGGNECy/uq54r9n3pui+64pQeT5nVma8HmRPOslEOHSErx1OKpsw3qGy5jCW7U3v9gwPj/oAQ/nRhUmcR8hKCMiujotQhRc375DXJghGqEDALhBEFxcnVXgq/QdLJohgxExOPgDPFVzs84OiFeWKhmqmzjLvfNodP3RMurWSdl3Kz+M6gpvsRVJ2ds9PudgIOrKHxJ4mXxg25uYirA2dhAELE0jjbNMT63B6Yx8NTUnXcN50CP0LX1SAE7tg10dA8B8Uc6EY1zJGSc1Lo0GEnXuw6cgq/Dn9CDQVc8EoGdfmm9GR0F8bwW0WNCVeZj2lnK3EvXvWszgLeKjhwxYOdexg1dqv0jOpVzDGemH69HrYKCIIxZOudoZZ3+2n7gi8A8oazAhpVhhUwEjeAifciTvYHqdDuAj67LC10cENumNuTTLyuKYOEUREf5TiwCDUm7QFzFu6L/JCUzh3Jvi6phch/O+MF7b4Czp3Ov/Ws7R9cgMLF38OKLeQ2cV+mueT6vcdy0tzjP2R1AF6Sc6aFbxc1OAVLy7gXfxnYMpxvjOD6alp9xEDYxdvmkyBW1rOhoLEIec4TWQwTKOboT3Gomzbg3yuGY/1VljBUXxI6SuV7lxyQc0FVR9ecFRIkFzBnXie0xttDRKZqJZKmameVpA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(346002)(396003)(376002)(1800799009)(82310400011)(186009)(451199024)(36840700001)(46966006)(40470700004)(478600001)(5660300002)(41300700001)(316002)(8936002)(8676002)(2616005)(336012)(26005)(36860700001)(426003)(16526019)(86362001)(356005)(4326008)(47076005)(54906003)(83380400001)(81166007)(82740400003)(36756003)(2906002)(40480700001)(40460700003)(70586007)(70206006)(6666004)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 19:51:22.6644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e64f80-7eb9-4bec-4b4f-08dbb55bf905
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5451
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the TSC_AUX MSR is virtualized, the TSC_AUX value is swap type "B"
within the VMSA. This means that the guest value is loaded on VMRUN and
the host value is restored from the host save area on #VMEXIT.

Since the value is restored on #VMEXIT, the KVM user return MSR support
for TSC_AUX can be replaced by populating the host save area with current
host value of TSC_AUX. This replaces two WRMSR instructions with a single
RDMSR instruction.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 14 +++++++++++++-
 arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++----------
 arch/x86/kvm/svm/svm.h |  4 +++-
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 565c9de87c6d..1bbaae2fed96 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2969,6 +2969,7 @@ static void sev_es_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)
 	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
 	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
 	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
+		svm->v_tsc_aux = true;
 		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
 		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
 			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
@@ -3071,8 +3072,10 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 					    sev_enc_bit));
 }
 
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
+void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
 {
+	u32 msr_hi;
+
 	/*
 	 * All host state for SEV-ES guests is categorized into three swap types
 	 * based on how it is handled by hardware during a world switch:
@@ -3109,6 +3112,15 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
 		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
 	}
+
+	/*
+	 * If TSC_AUX virtualization is enabled, MSR_TSC_AUX is loaded but NOT
+	 * saved by the CPU (Type-B). If TSC_AUX is not virtualized, the user
+	 * return MSR support takes care of restoring MSR_TSC_AUX. This
+	 * exchanges two WRMSRs for one RDMSR.
+	 */
+	if (svm->v_tsc_aux)
+		rdmsr(MSR_TSC_AUX, hostsa->tsc_aux, msr_hi);
 }
 
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c58d5632e74a..905b1a2664ed 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1529,13 +1529,13 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		struct sev_es_save_area *hostsa;
 		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
 
-		sev_es_prepare_switch_to_guest(hostsa);
+		sev_es_prepare_switch_to_guest(svm, hostsa);
 	}
 
 	if (tsc_scaling)
 		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 
-	if (likely(tsc_aux_uret_slot >= 0))
+	if (likely(tsc_aux_uret_slot >= 0) && !svm->v_tsc_aux)
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
 	svm->guest_state_loaded = true;
@@ -3090,15 +3090,21 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_TSC_AUX:
 		/*
-		 * TSC_AUX is usually changed only during boot and never read
-		 * directly.  Intercept TSC_AUX instead of exposing it to the
-		 * guest via direct_access_msrs, and switch it via user return.
+		 * If TSC_AUX is being virtualized, do not use the user return
+		 * MSR support because TSC_AUX is restored on #VMEXIT.
 		 */
-		preempt_disable();
-		ret = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
-		preempt_enable();
-		if (ret)
-			break;
+		if (!svm->v_tsc_aux) {
+			/*
+			 * TSC_AUX is usually changed only during boot and never read
+			 * directly.  Intercept TSC_AUX instead of exposing it to the
+			 * guest via direct_access_msrs, and switch it via user return.
+			 */
+			preempt_disable();
+			ret = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
+			preempt_enable();
+			if (ret)
+				break;
+		}
 
 		svm->tsc_aux = data;
 		break;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c0d17da46fae..49427858474e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -213,6 +213,8 @@ struct vcpu_svm {
 	u32 asid;
 	u32 sysenter_esp_hi;
 	u32 sysenter_eip_hi;
+
+	bool v_tsc_aux;
 	uint64_t tsc_aux;
 
 	u64 msr_decfg;
@@ -690,7 +692,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
+void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
-- 
2.41.0

