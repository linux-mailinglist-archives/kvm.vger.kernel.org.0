Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6722E68B570
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 07:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjBFGGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 01:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjBFGGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 01:06:33 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D522F15CB7;
        Sun,  5 Feb 2023 22:06:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPQi0EUTxANsl1ghJskY4ImUlJ1U6N3bq3UkVP9GAudQHhwjK0OwfGTnvXfhmEkFuYKE+8vBXKthS8wUwn16W7bzK2iwvE3r3n57Jo5mBkgHrpWenSGiE+Ss3HGNRZpr0SSd1MmktUXnignEQLCj6OD24pznsgofK0MjpY+wxVGq4V9jgzmtEqZyeHxXJCkR/hfuJ+EgT0Z0zeIfYlcoxw6e0/8p805lQVB1YQA7HLr5pNOtKGNKFDmZswQiEdPqLMucX2m1H+iRPj54OjXl2tZtW3e85uliY723+lywxCAMPRVD/vUWKUOY2r5Aeb/NbJKQY7R6rXGbNSeqU4EnBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrHQWAsMXo/ODo6YB767R3B13h+9ApjBys6yYfgSTwg=;
 b=mmZ5+peDzqTRRx4BoTrEpnXV9iC2REObD/lo6P5RblNmFAy6lpoPaFr1Xhv3z4bQfILqmW/1Two0VjEtEtsSK+qXDoViah6AblwF7GJfk+CB6MNFh3MKMp0H7khhnUEwAnuZduVgo7nztOZSxiK5N8uo3IeEdPOH5gxlGVMfasFlYO4RNby+1Gw17JVloUatTU/Aqctaa2l38pWmO/OSfIwgjn9j7i7ZFv3sfafJUpC7PuzRvIH2+71mSBmeqMVBWi/5CUjtSRWm5x5PdolEQ67Nny01qr/+H42V6BW9U3aulUgAmVrGdjZX8zmOGF9d33xaLeqKXsm6UroMHSYDiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrHQWAsMXo/ODo6YB767R3B13h+9ApjBys6yYfgSTwg=;
 b=efO3luZhJoz2/benujdAzvhEIBpAvzRFtfh+OdUxu7JHSTjHJaPep1mYoAi33GQRZ7TR0VJP8LHgMqBBPkuBLrT+YFxlhaPLQv9Lrc/UXQTQeWrBEqewIOhxC8ZbOIox26VAZbOg/lOkxe405G5Dnd0c9/J+KacS5Li1IuMLXM8=
Received: from DS7PR05CA0048.namprd05.prod.outlook.com (2603:10b6:8:2f::19) by
 DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Mon, 6 Feb 2023 06:06:24 +0000
Received: from DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::60) by DS7PR05CA0048.outlook.office365.com
 (2603:10b6:8:2f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14 via Frontend
 Transport; Mon, 6 Feb 2023 06:06:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT094.mail.protection.outlook.com (10.13.172.195) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 06:06:24 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Feb
 2023 00:06:17 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <jolsa@kernel.org>, <namhyung@kernel.org>, <tglx@linutronix.de>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
        <sandipan.das@amd.com>, <jmattson@google.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <ravi.bangoria@amd.com>, <eranian@google.com>,
        <irogers@google.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-perf-users@vger.kernel.org>, <manali.shukla@amd.com>
Subject: [RFC PATCH kernel 2/2] KVM: SEV: PreventHostIBS enablement for SEV-ES and SNP guest
Date:   Mon, 6 Feb 2023 06:05:45 +0000
Message-ID: <20230206060545.628502-3-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206060545.628502-1-manali.shukla@amd.com>
References: <20230206060545.628502-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT094:EE_|DM6PR12MB4484:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d1eed82-6680-4292-83e6-08db080846cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: caMx9yF2ZYtx31yhZ68Yq8m1eeveFt22WLQKppN4U4JppNsa7HCIiLmOakRLKDfgYgb4sb3KEi3h8bVBpXObkb3gsgxTXWEOvcZel9PaKHV07HOHiAGFsI4zEW5mRq7iTpNlMo6zhZRpWENyUmb5cOmtekwfpfsw0rPNhxYZIDQH8Rf6751kgtVvw4cvIlaVz7nQy+fHVZgxoU8rngkBcV8it5mGnIJoNmRXK1QP9KCqnJ4SmOaq1NfhwB71KIUwd9iTim7VtLaCfEEdf7CLCTuEIsUCMNbKJup8C/bw2blHs2IgqwAyTCYlf/CWVp7uHANpLeaz36Fg/SIwpTt360r1RzFUIagHCCUndx6Wh4bzK7006K0byMtqwX7oAhdwwIeEwpWj5NtwEVPRIrosB1IaP5NuyijKWx/taxriifRu+vXkX4R6hOgBlorzPb7C3yrcVHRPZSPyGxvwYanWQq1wL3Z0PI1iffqYglxKtbZUOINK3jLn0ieEbP+3JG6Oeij2cEvntMNtKN+Und39x4RXOf6mZ2UKhC+1Pa12pwtcabqXWHV2RTHi+VmuP9XDcu+L2mN5t9da8xW/B/xOApc0SlvmeXmoUlgVDgUeaUeZ1qKY5KjBe6h24dZLuoasgSaHZzyejLjM0K3L9D3XmhSlibR6MItG2UX0bqHMtNheW/MYA96gLUfpfx3T/Gleh3a1JuS4fKI5ueoHLqDW/OL+lhbuV35gKroKnc29O14=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(356005)(81166007)(82740400003)(47076005)(82310400005)(6666004)(1076003)(186003)(26005)(40460700003)(16526019)(36756003)(478600001)(86362001)(83380400001)(8676002)(336012)(2616005)(426003)(70206006)(70586007)(6916009)(4326008)(316002)(36860700001)(7416002)(54906003)(7696005)(44832011)(2906002)(41300700001)(8936002)(5660300002)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 06:06:24.2844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1eed82-6680-4292-83e6-08db080846cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the hypervisor is able to inspect instruction based samples
from a guest and gather execution information. SEV-ES and SNP guests
can disallow the use of instruction based sampling by hypervisor by
enabling the PreventHostIBS feature for the guest.  (More information
in Section 15.36.17 APM Volume 2)

The MSR_AMD64_IBSFETCHCTL[IbsFetchEn] and MSR_AMD64_IBSOPCTL[IbsOpEn]
bits need to be disabled before VMRUN is called when PreventHostIBS
feature is enabled. If either of these bits are not 0, VMRUN will fail
with VMEXIT_INVALID error code.

Because of an IBS race condition when disabling IBS, KVM needs to
indicate when it is in a PreventHostIBS window. Activate the window
based on whether IBS is currently active or inactive.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/svm/sev.c             | 10 ++++++++
 arch/x86/kvm/svm/svm.c             | 39 ++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h             |  1 +
 4 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 61012476d66e..1812e74f846a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -425,6 +425,7 @@
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
+#define X86_FEATURE_PREVENT_HOST_IBS	(19*32+15) /* "" AMD prevent host ibs */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 86d6897f4806..b348b8931721 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -569,6 +569,12 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
 		return -EINVAL;
 
+	if (sev_es_guest(svm->vcpu.kvm) &&
+	    guest_cpuid_has(&svm->vcpu, X86_FEATURE_PREVENT_HOST_IBS)) {
+		save->sev_features |= BIT(6);
+		svm->prevent_hostibs_enabled = true;
+	}
+
 	/*
 	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
 	 * the traditional VMSA that is part of the VMCB. Copy the
@@ -2158,6 +2164,10 @@ void __init sev_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_SEV);
 	if (!sev_es_enabled)
 		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
+
+	/* Enable PreventhostIBS feature for SEV-ES and higher guests */
+	if (sev_es_enabled)
+		kvm_cpu_cap_set(X86_FEATURE_PREVENT_HOST_IBS);
 }
 
 void __init sev_hardware_setup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a194aa1a75a..47c1e0fff23e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3914,10 +3914,39 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 
 	guest_state_enter_irqoff();
 
-	if (sev_es_guest(vcpu->kvm))
+	if (sev_es_guest(vcpu->kvm)) {
+		bool ibs_fetch_active, ibs_op_active;
+		u64 ibs_fetch_ctl, ibs_op_ctl;
+
+		if (svm->prevent_hostibs_enabled) {
+			/*
+			 * With PreventHostIBS enabled, IBS profiling cannot
+			 * be active when VMRUN is executed. Disable IBS before
+			 * executing VMRUN and, because of a race condition,
+			 * enable the PreventHostIBS window if IBS profiling was
+			 * active.
+			 */
+			ibs_fetch_active =
+				amd_disable_ibs_fetch(&ibs_fetch_ctl);
+			ibs_op_active =
+				amd_disable_ibs_op(&ibs_op_ctl);
+
+			amd_prevent_hostibs_window(ibs_fetch_active ||
+						   ibs_op_active);
+		}
+
 		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
-	else
+
+		if (svm->prevent_hostibs_enabled) {
+			if (ibs_fetch_active)
+				amd_restore_ibs_fetch(ibs_fetch_ctl);
+
+			if (ibs_op_active)
+				amd_restore_ibs_op(ibs_op_ctl);
+		}
+	} else {
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
+	}
 
 	guest_state_exit_irqoff();
 }
@@ -4008,6 +4037,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/* Any pending NMI will happen here */
 
+	/*
+	 * Disable the PreventHostIBS window since any pending IBS NMIs will
+	 * have been handled.
+	 */
+	amd_prevent_hostibs_window(false);
+
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_after_interrupt(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4826e6cc611b..71f32fcfd219 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -254,6 +254,7 @@ struct vcpu_svm {
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
+	bool prevent_hostibs_enabled      : 1;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-- 
2.34.1

