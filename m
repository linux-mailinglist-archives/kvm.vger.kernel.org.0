Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A5270FADD
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 17:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbjEXPyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 11:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbjEXPyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 11:54:38 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2047.outbound.protection.outlook.com [40.107.96.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FEF97;
        Wed, 24 May 2023 08:54:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbj3zm02rUnSz5WLkhYcdja40favZ7mEG0pOMmesQcwqC6cz1FT6YAgb2wzy9VFOuv7yOesEp7WlM9b3F/6NeVsAobA8MfPpo2sdyYwKZushXvjQRDmL4ta9gRZDf2eCTgb8MbEq83bLhdYeOSXx0a+siJ3c78Evlx1hQqLP2n2rkREh8XjCbut9bY61E6YXFtLfVAMV5JThrbUXXx6P95ptSZ4miw/gcpBX9mzdL6NApguKZLUlScC9EPLHfxj7hP8y2uBFWX9XUf8NlfC4b2E4pWy4INpun8SXg7tJAHfZNTIqhregZFQqcG/9ZpRRnMgllvu3yXYP0trZYJScAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhJQrei0cPAAxb+GVVGUWNvRMGgni/3k1a10NVoTUFU=;
 b=Yi8j7K/3818fnxZ51G+MbYHH4S0XD1UQT1P12dkMhvE2C0WADZIHdriqLsmgtaZunXBfTClsK1f4zexQkC4NdcT30dGcI469bP6WHSzctvJT3vT5p231viJgNmoi98bdOEYBrf16xgjF83MOymckljYQzzFAfjfM5WJaueYgBp5BkFygv9pCG3EwndsXf4L0ANm5XLwFdx7N/F1dPPoN3PkPKpvn4dOFkaYHz43AE6TlrmB++xgwJ4debpq9Sl58DoslZAKDWHoPS2HNlf8aJy2TM/YEU0oEwhRcOlxUwjxMNzzKK4ufEGmCE+Ff/kKPf9DfJ4CzoSdQwVISxJ0kfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhJQrei0cPAAxb+GVVGUWNvRMGgni/3k1a10NVoTUFU=;
 b=H0T7jq/lg1XGAk/ehplL6oeqY+OnTV68UKp7p9Ormp0H1ilbw8fyh7j36jJGbQRPQS0PtrukLmBKBgqQGwULSc3GwsNgh5NG4cPxIYWyl7PZQM8PwWUf/w7Gijr3YGSLPUCmw2sgSoUN+BSa9rxb1ha74IWLe3/Ays5gdFMFk78=
Received: from BN9PR03CA0647.namprd03.prod.outlook.com (2603:10b6:408:13b::22)
 by DS7PR12MB6045.namprd12.prod.outlook.com (2603:10b6:8:86::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Wed, 24 May
 2023 15:54:33 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::30) by BN9PR03CA0647.outlook.office365.com
 (2603:10b6:408:13b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Wed, 24 May 2023 15:54:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6433.16 via Frontend Transport; Wed, 24 May 2023 15:54:33 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 10:54:32 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v2 3/6] KVM: x86: SVM: Pass through shadow stack MSRs
Date:   Wed, 24 May 2023 15:53:36 +0000
Message-ID: <20230524155339.415820-4-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230524155339.415820-1-john.allen@amd.com>
References: <20230524155339.415820-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT062:EE_|DS7PR12MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: fe640d0f-8462-4d4a-7fee-08db5c6f2aec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WW5V9zmQu3XAjBLBhlc8V8znETcjtuZvauVlTw70yJXr3ycJIS6c4/SCr4seDT2KIytVS40AAaTYoJUldtxpQyRCs9Pou9kZZG8/2zbAVfEDFm74HMk7o9sgCsXisDRJ8wrmNWTrgA7/vguQ00fyKFzzCGQxgkKhUBvQLTobJGcrNAwC6lTrHE8RFjr3sfY3llHsQOie/GyXZ6CKSQi1F9VYB/svxa+8+xJcAhZC85CN84WspYFSGP5egA/YnM/2I+ELAQNpel2BxpmlRaD96S4BLO1k9nNk3DmvOSERqEE21DDxAaurdbnASFPI9ueT4rpFJgkRT7rBh5hdV2v2/Fs6ZCPAoemLecfwcQX42dHcwbdC1lSCiMalZ2lyRaxPK3cqMlgNV3mRWqWWU/0TOU+3s/4igmFYxSWC/YpoPWNlqpNyCBisRpFCvm92iVjHehOBVKoAxHigiozktVN1MKOZR0HJekX5NEJFR1yduDV7ir5l0WcIYfb6AdDOlht5dUJGo41EZM70AoGT81pOWU02213BGfyQpY//kNTdWPrQbVJMHldMjueARaihAgpTn14HuFf8gOEu61Tr0w4rR9twQ8lmhRvFFOU4ziU4/oHAY0CBAyMjS4ghd2QE93kEVc5juIxfutU+HoSs0v8zdFFf5DZX17lG3FUT/+03WUfBnjeZ88tRmZ8sKI+s413iQCnP3/HCX9P3MNe15cC3kGDN6e3BpVBtbewxR+uFbIhDIs5S6VvwvGzZrOZjuz1o9yuD+2DQXhn6tAKFkukIFg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(41300700001)(7696005)(83380400001)(47076005)(426003)(336012)(36860700001)(16526019)(186003)(2906002)(26005)(82310400005)(86362001)(2616005)(1076003)(82740400003)(356005)(81166007)(40480700001)(44832011)(5660300002)(36756003)(8676002)(8936002)(6916009)(70586007)(70206006)(4326008)(54906003)(478600001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 15:54:33.3699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe640d0f-8462-4d4a-7fee-08db5c6f2aec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6045
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If kvm supports shadow stack, pass through shadow stack MSRs to improve
guest performance.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6df486bb1ac4..cdbce20989b8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -136,6 +136,13 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_IA32_U_CET,                      .always = false },
+	{ .index = MSR_IA32_S_CET,                      .always = false },
+	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
+	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
@@ -1181,6 +1188,16 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
 	}
+
+	if (kvm_cet_user_supported() && guest_cpuid_has(vcpu, X86_FEATURE_SHSTK)) {
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_U_CET, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_S_CET, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_INT_SSP_TAB, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL0_SSP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL1_SSP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL2_SSP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL3_SSP, 1, 1);
+	}
 }
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f44751dd8d5d..dad977747a15 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -29,7 +29,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	46
+#define MAX_DIRECT_ACCESS_MSRS	53
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.39.1

