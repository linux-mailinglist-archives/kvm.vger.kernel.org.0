Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8CB7C4093
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbjJJUDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbjJJUDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:03:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25878120;
        Tue, 10 Oct 2023 13:03:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkLjsDL5iQDB+BUmeqp7teo7nNJ4wajZM2NDIPTttLfPsKk9MhpV5ePgJKImnHCCP/JnVvGJzq1exYjyLg6hoJ5wBBEuqPIedBi26rp776snjWKqwpeswFM/6WB+EgmnoQQgd80V4eeFzjx3gV3OwgnyPs5EOs3m+0SGuhUarstKZFDxjnYkMzwGnsn18I3Ou07d+cuk2Zl3ld7+c9zZZACU/BtmhbIydSsyjW3QAgAhaWPbEcF01Zl+rjkeSMpCoePKwEkBstsKegVw34nJYIlDXL+WL91KJzaybN0ECunbIRLFU6pEckEa/23W5gISJpQj8No2R3FDm66iuUCVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0IGP/v8NTLSUIQJeufZmxOBYYK/50JjUKYrrJPZTTo=;
 b=GMARLooMlMntdYmjgJb0U79CzWOvMWHLOAuWBfOPa6ubDJQO2Oudsqk5Qfwzu5ebsfhRZOtPLS7gQZs8q0OtxZk+06s+f2BaEIgMMHmHIP7fzokaKpIhD2s0JUJNC+dQxfCPk98Ju7kucb61h5spDZtFGRCiaONYAJFzk+fQ7aPJRywNcwJhbMbo63KjSP/t5lD0pua4D+0mxGelT3Xg8QVjY+hSj0wjrJCCUDIjcP1xOn6acqeOYUMr33raWcuInyRmr3fe5GV0+zr2pBbyixfJN7NC36+kfoy6Mc6y2gLELv4shKIteyMo803bTrp8tU7j5/+nYt7UCRkDl1/90Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0IGP/v8NTLSUIQJeufZmxOBYYK/50JjUKYrrJPZTTo=;
 b=hOu+AQc8QvCsRisPRVWOd+m1Jjarp/eRbFNJDf1TTZwb+QtYlda4Rm3xlh/mbXvIk83AkOHPlpvbI3sIEEjNDNtdYWXPKdp0hKmlqiokB44Ip9Plqgf1Di9qVoseQBkla8iz3mp9/615N6Nk3mtcvgCYBlpzX8SNEN3MUQO2RYc=
Received: from DM6PR13CA0044.namprd13.prod.outlook.com (2603:10b6:5:134::21)
 by PH8PR12MB6819.namprd12.prod.outlook.com (2603:10b6:510:1ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 20:03:33 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:5:134:cafe::5b) by DM6PR13CA0044.outlook.office365.com
 (2603:10b6:5:134::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.20 via Frontend
 Transport; Tue, 10 Oct 2023 20:03:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 20:03:32 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:03:30 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
Date:   Tue, 10 Oct 2023 20:02:17 +0000
Message-ID: <20231010200220.897953-7-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231010200220.897953-1-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|PH8PR12MB6819:EE_
X-MS-Office365-Filtering-Correlation-Id: c905bd20-c5a5-47b1-0415-08dbc9cbfaae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GhfpPJBK8gOjDjVDG+qEqAltBHH1uOhuZ7qVVRBpdnKWYI7n9bZyo4nQJvMBzc4X5VdD+/PT67dG2LWsCJ2Bu7D3tjszkrRtJkpGBF7icisCIE3Tf7D0amVakz4+9lGnZn3tR6yFTCWs39DhGf2lNaR00a/HCNy6Qr/tjqDKz9OcaoF4AfpX1BP+i8yjGAExnUHcUTu2p+OGn5oSprp9aIZE6XguYUM5rjVhWh4XX2YiguxSnbjEKAd23Gq2V7BWuOIc1qNMmptdNzFxvT6s/dNimkJ0np97WLl2EgYgYJkcGdHtGz7rxGlPMOBGZpsYjJn9EeFsM/7Idw14fwwtvYTMofY/Ai+ZW1iXxXOgwOZbVUCAY4mnVWqiS6Eo+shfavW6pYj8Tk7yum0EuU2anT/Lz0hbbh1V8BymUTEodXKzrbjzH87ndY2PbFY8PVL+ivnfJDLYx0YZhNWyyi1e4b8FJn/yvcajFipC8eN899t+VQv0j72NBgPCqqeCFoIeLLUBpFAf1yPWLtka04juHuHYKDazctOf2EIA+/XfrmiM9TroL1YtH5f/pyzBTQ5qL7FT6GZIDW5bG4yBZXy1MFw7bc4oQprxFYdvDQ8AYlnylmfwrW9kMAqul14ridjkejNNafCG6mrGp9dGIT7oADpA/VjawHS0AslVoOP83f5bj2385wUKPpUFhYyDQtB8XK5ilzBQNOJSTow4wfqPZaiy3aYHdSbsbinPw9Cg1UGvwsl1QliwJmPSt/Xo8qECHwKQXGKSfKsOvcMlGPGK0A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(82310400011)(451199024)(46966006)(40470700004)(36840700001)(1076003)(40460700003)(82740400003)(36756003)(40480700001)(86362001)(81166007)(36860700001)(16526019)(44832011)(426003)(47076005)(2906002)(26005)(83380400001)(356005)(6666004)(2616005)(7696005)(478600001)(8936002)(336012)(8676002)(4326008)(6916009)(316002)(41300700001)(54906003)(5660300002)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:03:32.3372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c905bd20-c5a5-47b1-0415-08dbc9cbfaae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6819
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest issues a cpuid instruction for Fn0000000D_x0B
(CetUserOffset), KVM will intercept and need to access the guest
MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
included in the GHCB to be visible to the hypervisor.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     | 12 ++++++++++--
 arch/x86/kvm/svm/svm.c     |  1 +
 arch/x86/kvm/svm/svm.h     |  3 ++-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 568d97084e44..5afc9e03379d 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -678,5 +678,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
+DEFINE_GHCB_ACCESSORS(xss)
 
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bb4b18baa6f7..94ab7203525f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2445,8 +2445,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 
 	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
 
-	if (kvm_ghcb_xcr0_is_valid(svm)) {
-		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+	if (kvm_ghcb_xcr0_is_valid(svm) || kvm_ghcb_xss_is_valid(svm)) {
+		if (kvm_ghcb_xcr0_is_valid(svm))
+			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+
+		if (kvm_ghcb_xss_is_valid(svm))
+			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
+
 		kvm_update_cpuid_runtime(vcpu);
 	}
 
@@ -3032,6 +3037,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
 			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
 	}
+
+	if (kvm_caps.supported_xss)
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 984e89d7a734..ee7c7d0a09ab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -146,6 +146,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
 	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
 	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
+	{ .index = MSR_IA32_XSS,                        .always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bdc39003b955..2011456d2e9f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	53
+#define MAX_DIRECT_ACCESS_MSRS	54
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -720,5 +720,6 @@ DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
 DEFINE_KVM_GHCB_ACCESSORS(xcr0)
+DEFINE_KVM_GHCB_ACCESSORS(xss)
 
 #endif
-- 
2.40.1

