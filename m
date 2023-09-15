Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FA17A28C7
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 22:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbjIOU5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 16:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237626AbjIOU5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 16:57:05 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB033C18;
        Fri, 15 Sep 2023 13:55:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQrxQGCrd6nW3wDElyhvNzYCHm/lXab97QbwR1nbHsLqT6aLM2E5hU6O4CpVpc0rnaWS+Q6vAxALcRRXautmo+UxttpG8HW4uXK2BXxVRt1D7tdb0cFc/NIV+QTm0hm/BFftMc4qOE92V2MdLlOEjISSzHsTRKZq2gliTONrD163vSGRB3RC6OYihQFoYol8GM++NktCV9pbDlenKGR6iH/1OWscVfjayKj1DvI0LBWdB/igiM1cKPuf15KXOlylJPx7jv6GseMlkJorM9Y7bqRFYjlzBw1/STUvvR/zwFzy3IRTLsQevk+92eAKhuINiYWdyxtw5CkdyCCZWpDzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0rJQQpnvifC+zRw8/M+5GC4NVcorL7lMPKq29zLOfk=;
 b=G+M1XmkiG6B/Sg5c+esun5USkv0YuLG9Szvz4RLaVuKvTJ7yK1nGnYiTCVwmUKIWUi1lo4rog622X2KmpGwfWpPvx7ajZQWPGPy+Xxu5MALr1fHn9ZD0rUXDDY0JAff9R76c413uHxU4Gu8Llj5rjlYnGRAeLGNnLPQyNWdNCk+crHQIk3cOjcn5RcmuWMr7Rg5RTS1HfzwW5esxUux8Bm8rSKl4iyg44moNvHvGJfyxL3c9KQR1U5BIoYaYHn8zFTxqqnAAGVxfg+q3+Rg4MOXFyZF5Bnre/3GEiUiSqrUJ5aUPOISt4nWKcJb4i6amTT19U/JVG1Os9Ypx30gRLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0rJQQpnvifC+zRw8/M+5GC4NVcorL7lMPKq29zLOfk=;
 b=hC1NSEovqswD5lIy4IkcWuEqyRJUh+7053T0GABhDl51Kkx5ooqnAxTNn1s0SO9bba+oys/Fo6OLjniQ2EvF0rwlwkxTCMUxN9aXsOr+7eOPRHZvNy3hMFKojYu4+boAP+jV4wBAFnnbiRzD6Ws7+wTncmiGcogV0kbD5abhegY=
Received: from DM6PR06CA0076.namprd06.prod.outlook.com (2603:10b6:5:336::9) by
 BY5PR12MB4967.namprd12.prod.outlook.com (2603:10b6:a03:1de::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.21; Fri, 15 Sep 2023 20:55:10 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:5:336:cafe::e4) by DM6PR06CA0076.outlook.office365.com
 (2603:10b6:5:336::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21 via Frontend
 Transport; Fri, 15 Sep 2023 20:55:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Fri, 15 Sep 2023 20:55:10 +0000
Received: from tlendack-t1.amdoffice.net (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 15 Sep 2023 15:55:08 -0500
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
Subject: [PATCH v2 3/3] KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX
Date:   Fri, 15 Sep 2023 15:54:32 -0500
Message-ID: <d381de38eb0ab6c9c93dda8503b72b72546053d7.1694811272.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694811272.git.thomas.lendacky@amd.com>
References: <cover.1694811272.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|BY5PR12MB4967:EE_
X-MS-Office365-Filtering-Correlation-Id: cc29df25-327b-47fb-deaa-08dbb62e0cb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7ze2kJqWsvVLVri/d1dirKbPjOne2EKrJ0vwt/4vFsJp6jeag1N79KB52iZGYHK4Gjoeu6AEpBnRi0miSVzsDMPyDMeXSMug9sORz7qpTHH8tZEQJnJN5ge448BK84K0B2bwt4zaAfwPV94XaZkLZhRbmff+Xh4OZSsGCrqTbDNPyDqSYPV43XIAlALXputYH5+yRhba2Q9qNLQd4mVLaJtXi3Ww633KVNGt/YYVXVwxpecj3fQdj/ft6XIifoGoV3U4PVbE8Szm+GOnTsD6v6Go5aii3NX0ldoXZl9HPO37THD0V17Qtw52i3FT/wKiw5W0zKUPwMcN7muMB8N/mRmyo0/MQRjYH+o2SpeCH7OPVGMDWhoMyI5jRw7AH5gA6Cu3RZ6QrFv4m9GfhQ4o4OZHyHAlaUg1YeuW8V7Cx2E6lgoBFWUIwshuYtDehIXiI5N06cah+UsxnwXKAs1b3Rrg7vOx/fRh5P+0cnBq9uwQU7nYRUuGaJQgAIjEUdC+yr+EtjEfCcN7godgEm9cB5H3UkS0pvGvejjq9hvu+SntiizyrFVRLLvYV+vFIup4xUCMtZ9fCt1jTSM9Qu5RL+xjx4gHBNvbFnZIOv0AwGYY7S0uBcXRGRgxGER6PVS+OGK9m15Kqyf/BkHRPwNgSKYmPrOb0q1REPvFMVPq48QNSs1a4zbrPwBkxCB9jNMIa/IlXx1JxFthJveXlkfI8JynSKHiH4T49lUcPQtD/GBcrqHW8WeyTMbm7qPLvh8roQsINtHjyYgwNQlXkryXg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(346002)(136003)(186009)(451199024)(1800799009)(82310400011)(36840700001)(40470700004)(46966006)(40460700003)(2906002)(86362001)(426003)(16526019)(336012)(26005)(2616005)(6666004)(478600001)(36756003)(36860700001)(83380400001)(47076005)(82740400003)(81166007)(356005)(40480700001)(5660300002)(8936002)(41300700001)(8676002)(4326008)(70586007)(70206006)(316002)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 20:55:10.0221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc29df25-327b-47fb-deaa-08dbb62e0cb9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4967
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the TSC_AUX MSR is virtualized, the TSC_AUX value is swap type "B"
within the VMSA. This means that the guest value is loaded on VMRUN and
the host value is restored from the host save area on #VMEXIT.

Since the value is restored on #VMEXIT, the KVM user return MSR support
for TSC_AUX can be replaced by populating the host save area with the
current host value of TSC_AUX. And, since TSC_AUX is not changed by Linux
post-boot, the host save area can be set once in svm_hardware_enable().
This eliminates the two WRMSR instructions associated with the user return
MSR support.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aef1ddf0b705..9507df93f410 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -683,6 +683,21 @@ static int svm_hardware_enable(void)
 
 	amd_pmu_enable_virt();
 
+	/*
+	 * If TSC_AUX virtualization is supported, TSC_AUX becomes a swap type
+	 * "B" field (see sev_es_prepare_switch_to_guest()) for SEV-ES guests.
+	 * Since Linux does not change the value of TSC_AUX once set, prime the
+	 * TSC_AUX field now to avoid a RDMSR on every vCPU run.
+	 */
+	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
+		struct sev_es_save_area *hostsa;
+		u32 msr_hi;
+
+		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
+
+		rdmsr(MSR_TSC_AUX, hostsa->tsc_aux, msr_hi);
+	}
+
 	return 0;
 }
 
@@ -1532,7 +1547,14 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (tsc_scaling)
 		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 
-	if (likely(tsc_aux_uret_slot >= 0))
+	/*
+	 * TSC_AUX is always virtualized for SEV-ES guests when the feature is
+	 * available. The user return MSR support is not required in this case
+	 * because TSC_AUX is restored on #VMEXIT from the host save area
+	 * (which has been initialized in svm_hardware_enable()).
+	 */
+	if (likely(tsc_aux_uret_slot >= 0) &&
+	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
 	svm->guest_state_loaded = true;
@@ -3086,6 +3108,16 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
 	case MSR_TSC_AUX:
+		/*
+		 * TSC_AUX is always virtualized for SEV-ES guests when the
+		 * feature is available. The user return MSR support is not
+		 * required in this case because TSC_AUX is restored on #VMEXIT
+		 * from the host save area (which has been initialized in
+		 * svm_hardware_enable()).
+		 */
+		if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) && sev_es_guest(vcpu->kvm))
+			break;
+
 		/*
 		 * TSC_AUX is usually changed only during boot and never read
 		 * directly.  Intercept TSC_AUX instead of exposing it to the
-- 
2.41.0

