Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63845664F13
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 23:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbjAJWtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 17:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbjAJWsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 17:48:33 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAB133D64;
        Tue, 10 Jan 2023 14:48:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f65ZZyg95mZvAVQFnN1GyUsdOAbWsS1fap847UeCf+QgdG2iALfE9K64q+L3fsd9iQ94F2yaEvx7GPIHZEeqplzsS1oYuU5oBoioHW/qowbqTC8+F6L1zct/+LRjqtVFx+DPN7M2LGB61H/joKZjfGZUwvcACKXaAFJKF/38+yMNO+FKx2B208Ikzyl2gHkmZEDi8N3500hKcBxznzepLehX8HVBoYjXMgQxcIdeD0iSh87mWofNg8O+NGbx04zo1mQinvLbnvEaw2Kf4AQjZxIIMPQUCkaSUtmTzKZ6TbNFZ7bEIWUhmSRC1Bb+LD+HDmWBnW/iStMByjPiF5Kkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QHsr3Mgj3U5pLTvUaY9ngZWXMHARoVlnagZW4AOtvF4=;
 b=VQI1jVvtppa1S6QjWFAbTR4vyFxEPpaQTbQrSls5c9PdZWOYU6ibfliGYWcr8imEK5YOOGi9EuqX5eKE7loonfAEZmFxGWQqS5mw5ww1k9XRP8qwYYFi5v0q2Tx9i+CW8pfptrfxb/gsRXD11/E8ioSn0N3mNkbvWrpl1jWHUT6sK4hJ8GZC2ByaksBl2m9XpEY2xHJHEqXkTXYdTnplHhdEz5BYoWucOVsRe6/jUG+By1SbYSPGEqFBXfSTjmpuiXVgZJzxiMcip8x/weINmPEzwEDSNiJVINKX9hu7yatDv1t3MPyxpDwdaSBv1VlksC145sC2Xtz8VFG4juu0Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHsr3Mgj3U5pLTvUaY9ngZWXMHARoVlnagZW4AOtvF4=;
 b=q90Ibx4TDyG5vzdHUnbAOExk3CauBqpE8Eavgkeokho5u+dyuG7X1kxq30sJBJ7hC1/53JdCeyVk2fKfrjC+ofgRzeqFM2DLpZPDhDwjjYI8Go1fGjfwSdaU+m1QeyrL7953jpNGunYTV4DXcundztpM/gs/v+kIMrlJRgyI4jE=
Received: from BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19)
 by IA0PR12MB8326.namprd12.prod.outlook.com (2603:10b6:208:40d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 22:48:29 +0000
Received: from CO1PEPF00001A60.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::d1) by BYAPR08CA0042.outlook.office365.com
 (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 22:48:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A60.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Tue, 10 Jan 2023 22:48:28 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 10 Jan
 2023 16:48:26 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 7/7] x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest
Date:   Tue, 10 Jan 2023 16:46:43 -0600
Message-ID: <20230110224643.452273-9-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230110224643.452273-1-kim.phillips@amd.com>
References: <20230110224643.452273-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A60:EE_|IA0PR12MB8326:EE_
X-MS-Office365-Filtering-Correlation-Id: c8d88e9e-2d76-4a4a-c176-08daf35cca8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rp0D3tvS+Qv+n4PyKGXGY80QpUs8liV1kqjBTcyj/fAX0WvFqa+QEZSRabLFHfpQOwojrw2/cK3h+7dESx3W1m3LGlmPoyP4+W1+6oDKqGYldu6/XOpVLVNDFiTPGb4S2bPU5MEec1gv/Fnnwg81IHJNBG5+oval2DmipIaPooQTwpaGU33dXeggz6hTAH/dsPO2MfBz4tpIGfN7FTOJAbxQPghPe4zyxzgtxMH8ZfpralPAfqLQEokFfCrYVSR3IW4YwWiFAzGBwMgSN+dJMw5erSHwg6RhRbHV0paNc0/AlgwkpOquNYgf57DYSIPiI3vQuuNPcEZj+hjIv3iKB40K/0J2CYUlWe3aBJht3OXNjAmz5L80TzMQlPRQedEf4xYmtyPQLVcha4s8CeLN0g+ELbOs5w3DvI/ECHaj5/ODwBJQxUvLbiE7k36jtLKNR4vXzgO5Alpf9LCOVrxAEDzHpnsufuQlWBkEDhubnbV9hWAQZtMFvBbzdocG39LMOR1Xq+cjOhjAE8XLnDFJ/bjoWAOcgYA8AFkMnCsN4zv+9jHDjJpSBtSxdesZtbCn6mMPg6G1f4ZA1MVSKSat8BFs+Xi+ofToiXBdMfxSRWS8DRz4sSFFlTJ8OcshY+eNcFFwEm4QDOSZnYrHjXCo3w2nxr2AfWSGK22ge+plX5adKfULyWFievXptNnDflCDpKap0iErmKNiqeisEAN3pIRW59IkM8QGPR27OLIxc/g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199015)(36840700001)(46966006)(40470700004)(82740400003)(6916009)(356005)(81166007)(36860700001)(70206006)(86362001)(83380400001)(41300700001)(4326008)(70586007)(54906003)(8676002)(40460700003)(426003)(44832011)(8936002)(2906002)(5660300002)(316002)(40480700001)(7416002)(16526019)(82310400005)(1076003)(336012)(47076005)(2616005)(186003)(26005)(478600001)(7696005)(6666004)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 22:48:28.5481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d88e9e-2d76-4a4a-c176-08daf35cca8b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A60.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8326
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the AMD Automatic IBRS feature bit to those being
propagated to the guest, and enable the guest EFER bit.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c   | 2 +-
 arch/x86/kvm/svm/svm.c | 3 +++
 arch/x86/kvm/x86.c     | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 56f00d9cc5c5..6ce0203789cc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -743,7 +743,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		F(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
+		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a194aa1a75a..60c7c880266b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4969,6 +4969,9 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
+		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..8dd0cb230ef5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1685,6 +1685,9 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	if (efer & EFER_AUTOIBRS && !guest_cpuid_has(vcpu, X86_FEATURE_AUTOIBRS))
+		return false;
+
 	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
 		return false;
 
-- 
2.34.1

