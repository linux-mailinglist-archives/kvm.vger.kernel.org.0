Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF25D70FAE4
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 17:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbjEXPzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 11:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237571AbjEXPyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 11:54:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE0697;
        Wed, 24 May 2023 08:54:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0+eRCyNRbwSxw0IF1sL7ubSzgTPTZqgMj1du0IaGLIWsoiv4CM/v7zIjcUJR6nprmZFTHnhQAhiKoPZJsJ+i5z3mQ1OtRRJCQviI9eFOJa/lX3tOlxUFo0+MJS5skZBou5vJruhk3FTv8g9CyuaCTvwQ5nMuQL3NrJhaxLw4c9k7auKVKoUu0x9yedFSF0ws4vAuWnoASd5vDPsGrzVYfuShPW8N9ak10lp4fXK4lisZQ97SgcFBo22xNIUk+zAaD0FKIb+Kf4BgmTXX2SOcw6/v5+ZvVJRsgW8Ly+UjMrnrhx6ipfi67cBhUoyVRNYzh3YAGj/cnOc7DhnBVmsiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gFVMMouh7V1LSfGRT5ZG7L0BoHklaeBS0PswjOAMqg=;
 b=CqoFUCoJV9I+db/JXM1t5Vz5EBE6QWSbIA3JWi2Y+US3w3apzVokgR6/M3naR08XlBR//2qyERAOhuwC/xbLzdSQ/cR4CeQx6hl/Q5JN0qGWdDTJdbTaC71SVa4sidjhdjpkbU7PwWTRQIyO/9F5dEqErGJcgVbtQx6FPhpVPVKW/KLoMVZPQDI92E/v6JYh0PU9++n3osRcfCpdDZ1lBhYkQdXEGWro5EQrqZmqaqJ7sq4j4M6jYHC7KTKyU/Lu02KbAYtwkT3RvCJXntJTjzF2acFeNlW36kfVLrPvd6k4SlbxhuvVs2k9M0+k1yzOdsJzrLub2tLDj/Co5qPAWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gFVMMouh7V1LSfGRT5ZG7L0BoHklaeBS0PswjOAMqg=;
 b=EIboHQvp0H0pbgX1JfTQ07dH1UAOAESx/K1Ufw4Gqtv9/oonubpvz5FfDMUz6oe0FYfmbd+inEsakUjP6gKktIvCdnK6oi2lojLg/bwc0SgPM1NJd8wtlNa2hi6zweBm5ze+Dad8AzMneF7rG1HTOrHF6A/MCaSo8o71uxMg3xQ=
Received: from BN9PR03CA0691.namprd03.prod.outlook.com (2603:10b6:408:ef::6)
 by BL1PR12MB5779.namprd12.prod.outlook.com (2603:10b6:208:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Wed, 24 May
 2023 15:54:41 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::5e) by BN9PR03CA0691.outlook.office365.com
 (2603:10b6:408:ef::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Wed, 24 May 2023 15:54:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6433.16 via Frontend Transport; Wed, 24 May 2023 15:54:41 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 10:54:40 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
Date:   Wed, 24 May 2023 15:53:39 +0000
Message-ID: <20230524155339.415820-7-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT049:EE_|BL1PR12MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: b2d65cc9-d563-4dbc-9f49-08db5c6f2fb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdl/5UxarJDRwxbcO675vcS5HxFwh3Iawz7mX4Y16Hgt4j+Lfq4SQ8Nqw0+wmgQN5McviVPixkzxWjtqxgdMbIg0TZiG7r9EFyCXpyGi51pVm0youw/Vp+5Psl8UGVO4XCj/PL9qIGhWNQxF+M8HT4ZnKF0sQD9d8S4bEn7kWabxE5hErm9B01GovL2IZyB7AfxDp/QDz4K3olwMduHLggbw+7q1PkG0k9yVsZmlp6RIsRchANEGSP1L9n8DpTqDMu6dVcyq7PUh/OYPJNSSIZb7BlrdZY89gIt/NDI7WBUnQtSIpyooe+YbR4JxlSUa1pZev9I0Ym++U2ER0TjGdXOtGTxFrZfy9690uw1BjK8Hi9FCr3srp145Ca7hlk82z4ubzD7lMg/RWhJgSdIuCG1z8DJnuaaHRnenZsFTLbo3rgG1J6S6tgzgxlz5sFfl8s8K743eqPMCzLk4CYXalWEm2jMQcsonVrf0wcGtMDrFPG5gaACBvTkMEiKrn2HFIs0jljDRFtMlWA73zqoWYFagB8uJy0ZR6tag8qIebiR9gOty6aXV82YnEeEKoO2XAfsA7sW/gkcRgIJHWsYvH5CzoApbhOvvAQ00PNO25wk5syWhi4vZrqaUgVewS8aL3MbAtikt36TQWuU2Qh1Gz5kDXrAQAiUzmqaQNSxWY6z7W/qOyuv2xNM1csa+LMaErVGspo1J5hTL0HDXhh8CDhnQIbr4rN52gzisVVbBu+v+w9TexPulM/8gaGnAfdPemT4CtnF9WEejqhnRI7hOgA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199021)(36840700001)(40470700004)(46966006)(8936002)(8676002)(47076005)(44832011)(5660300002)(36860700001)(82310400005)(336012)(426003)(186003)(16526019)(1076003)(26005)(81166007)(86362001)(2616005)(82740400003)(356005)(40460700003)(41300700001)(7696005)(70586007)(6916009)(70206006)(4326008)(316002)(40480700001)(36756003)(478600001)(54906003)(4744005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 15:54:41.4145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d65cc9-d563-4dbc-9f49-08db5c6f2fb5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5779
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the CPU supports CET, add CET XSAVES feature bits to the
supported_xss mask.

Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - Remove curly braces around if statement
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6afd2c44fdb6..cee496bee0a9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5070,6 +5070,10 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+		kvm_caps.supported_xss |= XFEATURE_MASK_CET_USER |
+					  XFEATURE_MASK_CET_KERNEL;
+
 	/* AMD PMU PERFCTR_CORE CPUID */
 	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
 		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
-- 
2.39.1

