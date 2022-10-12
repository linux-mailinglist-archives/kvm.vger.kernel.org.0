Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF705FCC26
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJLUjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiJLUjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:39:47 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2085.outbound.protection.outlook.com [40.107.101.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4231580A;
        Wed, 12 Oct 2022 13:39:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1++UjU8UbAzexPPupRhIpAeE9QUn5vU1kHq32WDiYUM5BxKYS2dl4VnAKy0GSuNZfrEjJJ6mjddvJ/TzbfTbWgQ7M7H3MQqolkjmlvBl5owgTFM9eY2lbN1XADAsdvw9gOZlxH9Pv+4dMwCUMUPNjFtTaRXECk8ozG0m7QCt559WFGUdtaMkvByta3BcNEp9l+cxGZQgmx7IiiMouY8rAR8nwOxlLAUqXNXa4zkLa3lGwjF4pdnjF0riD8MzhNIWZM+UwAFAahO0bOitHiinCriuMIIBfNUBYKZdoilcmk/hKjlKkNJ9ZVvJlblmfuIc+RK2+KlL7M6sGwkHwhIsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/w2fVab7DoKlOVdMFsxE+nlc01Dc+jlVOdKyaO0mBc=;
 b=Z+vBP93bI71+9LiWFh4XzeVprM9ueWCVc0Af+0s6TOjVmGblHk2iC/Z6FLwcMAfkNfyMMtn/yejGrNS9T2jJejcAuXMt72c3wMPMUiX0IyFHVg6hPk+CBQle+4UzYpmQ2p+h3SfI9EPEnNxf4dFvoWt3FV5rKJwX1DEYxKuHHUNA+gcT2jqotMfPunhTtxMWRwc9iBAMaxCtuIJMEhMxVHrXMJCNltR8NKPeOOhXeQrip+0rgW+KCyMfOPovHkX0yqZgHsCJ8KILkRa0C1MVrGDUFLxujhlSzgBi7em4iQfvjH7HWDhGXEIdEw4z/YX88SvclLWpUtCNMAZyRDp8FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/w2fVab7DoKlOVdMFsxE+nlc01Dc+jlVOdKyaO0mBc=;
 b=puQKPL2aZGP+AJN5Wi009kzykeeGApvQlMtBb0D4dSX/0LNxgb5X9qDSDRjHmXvqPjOl3CErNg8jTjU0BAtkgMAcGQlRHgEyKx7wvKWljU9r2MvblRHeZ15Lm7qUe5Zb+2SWrCv/rgqrSZ3hrN6NIk5UCpLthHT2BWkpBVGsZuQ=
Received: from DM6PR11CA0013.namprd11.prod.outlook.com (2603:10b6:5:190::26)
 by PH8PR12MB6866.namprd12.prod.outlook.com (2603:10b6:510:1c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 20:39:44 +0000
Received: from DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::9) by DM6PR11CA0013.outlook.office365.com
 (2603:10b6:5:190::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22 via Frontend
 Transport; Wed, 12 Oct 2022 20:39:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT095.mail.protection.outlook.com (10.13.172.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 20:39:43 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 15:39:42 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [RFC PATCH 1/7] KVM: x86: Move shared CET routine to common x86 kvm code
Date:   Wed, 12 Oct 2022 20:39:04 +0000
Message-ID: <20221012203910.204793-2-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221012203910.204793-1-john.allen@amd.com>
References: <20221012203910.204793-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT095:EE_|PH8PR12MB6866:EE_
X-MS-Office365-Filtering-Correlation-Id: d759019b-edec-4ba1-97e6-08daac91e504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKslPDZaK1MvRTz5zAOWW0/1wgQyrowRAiM8Vr5kv0u0BB+K+ixw+PnTPZXJKOqHSUC0JF0qZyaDSHSY2hZOuWPwIbt8AzS5j3rdbUcmgkLIB99j7NiYuFxc7HK6zD4kUKZ6HN1vrQdvFTqM8C13wav3RYVKOTxkeFusc2Wg8RyoGfvucHyrtWVrZ4nGW0WHlyNv1r56fRHBUqJiNbQTKg84FASy9qKGgScALRtYO061ItjuexsAak0VrY1MumzboXmLKhcR2JKlJkudCgOE1ctilkqrRDzb/Ez5qyIMifXZOKAVe4eePbFaVGxUvDJS2cDRadseLx6/7yLzF3mnn1EYHCYrZAFDRBW4YdZ4pTIxifMHkd2Dajf6cKz2I4Sg1YCc18XPZN5ORhpts51QwVGc3tqXpunJE6G0vNl5FBcCpADYrzmdYohFWMduBr745CbNK3Ypqe2pgg1/rar/cvkYdO7QRN9g6xDO1YrNBql8PZgmPLtrxLYjsbwzIwVSUCRLTWx4omZCskJ7hx/mlKdXmki7tBrpchglKo2PAvSvDnFAt3kuFUGLlh4F+JJtJfWFiKP5XTN/kFF4zS1eVRbdwimhwKjaJahhUAwBXZYWQ84AEihhRPwrEzsJjudwqe9vpb/Rsoqh5Sg/HcEQEgar/o9EtZYQgGGaiy7A+3/7MuK5XWnB2bQOqGBAhxZzfJ80eOhVvja1nGPDY/jCvNuVSxmGNsgXQOIb3Ua949yJ3nJCUxNsE6nCqVBeMNjobWNk/f7tffyL94XaYkV4wMs55vRUwdXTcgRzaE+Wk0g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199015)(46966006)(36840700001)(40470700004)(86362001)(82740400003)(2616005)(2906002)(36860700001)(36756003)(6916009)(40460700003)(478600001)(316002)(70586007)(16526019)(7696005)(83380400001)(26005)(47076005)(1076003)(426003)(8676002)(336012)(8936002)(186003)(54906003)(70206006)(41300700001)(44832011)(4326008)(40480700001)(82310400005)(5660300002)(6666004)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:39:43.8084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d759019b-edec-4ba1-97e6-08daac91e504
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6866
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cet_is_msr_accessible can also by used for shadow stack support in SVM.
Move this to common x86 kvm code.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/vmx/vmx.c | 32 +++-----------------------------
 arch/x86/kvm/x86.c     | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |  2 ++
 3 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4558b13d0610..8b79a727b29c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1845,32 +1845,6 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 	}
 }
 
-static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
-				  struct msr_data *msr)
-{
-	if (!kvm_cet_user_supported() &&
-	    !cet_kernel_ibt_supported())
-		return false;
-
-	if (msr->host_initiated)
-		return true;
-
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
-		return false;
-
-	if (msr->index == MSR_IA32_S_CET &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
-		return true;
-
-	if ((msr->index == MSR_IA32_PL3_SSP ||
-	     msr->index == MSR_KVM_GUEST_SSP) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
-		return false;
-
-	return true;
-}
-
 /*
  * Reads an msr value (of 'msr_info->index') into 'msr_info->data'.
  * Returns 0 on success, non-0 otherwise.
@@ -2014,7 +1988,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
 	case MSR_IA32_S_CET:
-		if (!cet_is_msr_accessible(vcpu, msr_info))
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if (msr_info->index == MSR_KVM_GUEST_SSP)
 			msr_info->data = vmcs_readl(GUEST_SSP);
@@ -2363,7 +2337,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_S_CET:
-		if (!cet_is_msr_accessible(vcpu, msr_info))
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if ((data & GENMASK(9, 6)) ||
 		    is_noncanonical_address(data, vcpu))
@@ -2375,7 +2349,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
-		if (!cet_is_msr_accessible(vcpu, msr_info))
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if ((data & GENMASK(2, 0)) ||
 		    is_noncanonical_address(data, vcpu))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5786225c0dfa..486e91f4a538 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13475,6 +13475,32 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (!kvm_cet_user_supported() &&
+	    !cet_kernel_ibt_supported())
+		return false;
+
+	if (msr->host_initiated)
+		return true;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+		return false;
+
+	if (msr->index == MSR_IA32_S_CET &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+		return true;
+
+	if ((msr->index == MSR_IA32_PL3_SSP ||
+	     msr->index == MSR_KVM_GUEST_SSP) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(kvm_cet_is_msr_accessible);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a55f262d1e61..fb871be7131e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -502,6 +502,8 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr);
+
 /*
  * We've already loaded guest MSRs in __msr_io() when check the MSR index.
  * In case vcpu has been preempted, we need to disable preemption, check
-- 
2.34.3

