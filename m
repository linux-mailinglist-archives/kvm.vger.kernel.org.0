Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F3135751E
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 21:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355706AbhDGTp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 15:45:58 -0400
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:29537
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355666AbhDGTp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 15:45:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQYjYsF0pOdw0MoGgN3EueSuMTrX5fhbSY2x8bYFpCbr0NUDYFdgd7aRErLRsfRAT2HyeC0qKTLfCbQ1Fi6EaAU4g+GP/mrRWV5XUFPGN8SdFeqtTYyJHLBZhu+S8Jn/svHIJ3piq66tDDo8Xlg2nlijb9m55GxPo443prpN3WAWL2bs4ogkqqmnXnQFoSs6lpLJibfWqXcxdvFr0bwW78/kJIYhV9hi+QVr0OY1ujaxJvSivChnNfaRFX43tAH7JtgKPWr6WRRgItcikQ8PzXG9tP7TkfzRBTMQaCMgmCOELBXklndUpDkd09gvZtwltRoJ20FuiSXVZxubypyL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnAgSZYvS/lBLIb85UzTFER4j883WqnvBjdX7/4PPE8=;
 b=b+JXe9DkWzcx2V9UCJnddtpmk+adAL9JxNsAgg5ApsMaefBfp3MyCf70Xs9CIBCmYP0nXz158iQ9dW/bmMetZ1bgUcXSu54WkgOELBivLIBEQJWqyE1rcHZkpn+OqES8QIxj1UHCzwB2PWEZOvczfG+J5iH65zk/ZcQSWuIP1I0o6A5eqCBQs6bpPCGUzvjdzsrZeyvcaE+KGBD2jgV4Z5c++CLcfpLSM0UNqW+ivMvnT49PnshgP1K78+sJnCPRjS70XMT999d3G+aZQyHxdYiu+iwoGKb1CL6BMO20ACRpyBYqMY7v/GrC2811Hmj2CZTpW+ut4wggixqDH0CwRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=amd.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnAgSZYvS/lBLIb85UzTFER4j883WqnvBjdX7/4PPE8=;
 b=4QPnZbJxG/1+qwopfrid968369nVOcIgOhxgMaThX/N0Y0dY7oPD4Utg4rWdvVJs4IWChny5nyqF9+Z3g8+QnZ4TWY841xVzIrWFpytwSEg+FM5n/DloXztNjidnyWWq76qC9cOUzaZhkZGi5sNtaG+YyJAPEgo4HvR93Cm3tsk=
Received: from BN9PR03CA0925.namprd03.prod.outlook.com (2603:10b6:408:107::30)
 by BYAPR12MB2695.namprd12.prod.outlook.com (2603:10b6:a03:71::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 19:45:44 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::15) by BN9PR03CA0925.outlook.office365.com
 (2603:10b6:408:107::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 19:45:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 19:45:44 +0000
Received: from rsaripalli-Inspiron-5676.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 14:45:43 -0500
From:   Ramakrishna Saripalli <rsaripal@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <rsaripal@amd.com>
Subject: [PATCH 1/1] x86/kvm/svm: Implement support for PSFD
Date:   Wed, 7 Apr 2021 14:45:12 -0500
Message-ID: <20210407194512.6922-1-rsaripal@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c038c28-8220-4d00-2687-08d8f9fdbba9
X-MS-TrafficTypeDiagnostic: BYAPR12MB2695:
X-Microsoft-Antispam-PRVS: <BYAPR12MB269522A1FB6CFCC0B2CE35589B759@BYAPR12MB2695.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQ8E212MIXEsTdxIkfORqs3qBvnRTPPSQ0UkkFVY+w/679Qz0Wb49NFVPbvcd2TwexXFLuCQf+IvCDaM4BvKXrcTnRmeTVEofC6OW/hxD+F02eWa/hI60psIV1W9Nxt2FgJFRqjsN/+kfNq9dIYpnK17RfPgslKfWkXW4Sse8Xb7aEApELPoM7a9aVXchUEIkPGHJ0Rwo5lQPGYoY9FtP+aKahBig7Z5NyvZ2Uob4ZKNu8yTa/eSYfd3fCcVO4DPMA9VIKimnEx7LltoSxmVJjaLigTp3e+BiNnLrnGB6XR6YS82j/iAvtveqRNY1HwAQLXqauXgf/Jnic5C96vBx4HZVNkd0ZdlEM9wFbE72u5R7qrI+UF3Y1HmEEptaQ/4Z2CZpI2ObEKaRxywjfoHfTTcoP6PCABB0y3ZjaRisXMVEmuMAs71mFDEDTFWJZmAUKxjfF6iSF5djfHpzu2GoARVMGQcZb7xXtBBiVlVPTOlbrTqPnNfTBXqi6ydoboAzdje3wYykY+u6gxh7bzkXajEzfhGqXL/t3R1Ow1EBM+JH/S2K2Eqbig4vDmbxdkheLscbY+i3yvRIM4M/eEXCW9TjrKaqVWQNiHCLfTvy4NxbTNUT1BaqvM5dzUvhAuWY7yT3m5mPto6xvGw6V0kBB9arJYOdTHmifEwvDP7cGqjVNcZo3Y7rmawvu9oWLYLPJhLYWYr6Kd7cwgZPBO7nQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(36840700001)(46966006)(47076005)(81166007)(426003)(336012)(356005)(5660300002)(36756003)(2906002)(82310400003)(36860700001)(7696005)(921005)(8676002)(4326008)(478600001)(70586007)(8936002)(316002)(70206006)(16526019)(110136005)(186003)(26005)(6666004)(2616005)(82740400003)(7416002)(83380400001)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 19:45:44.2942
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c038c28-8220-4d00-2687-08d8f9fdbba9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2695
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ramakrishna Saripalli <rk.saripalli@amd.com>

Expose Predictive Store Forwarding capability to guests.
Guests enable or disable PSF via SPEC_CTRL MSR.

Signed-off-by: Ramakrishna Saripalli <rk.saripalli@amd.com>
---
 arch/x86/kvm/cpuid.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6bd2f8b830e4..9c4af0fef6d7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -448,6 +448,8 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
+	if (boot_cpu_has(X86_FEATURE_AMD_PSFD))
+		kvm_cpu_cap_set(X86_FEATURE_AMD_PSFD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16)
@@ -482,7 +484,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
+		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) | F(AMD_PSFD)
 	);
 
 	/*
-- 
2.25.1

