Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3F9552771
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345909AbiFTXAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345381AbiFTW7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 18:59:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5D3186F3;
        Mon, 20 Jun 2022 15:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EI5mo3nbu8Y1Lwlz8IW78D/vshGOQKxGXVcwen+zy24QljGByPviwtV6RHSIOPKWRxOBgPH8dSMYn+rNb0AU/K8uAldIHzZm0sSN0MT9wZVcZxf0laLiZrwYjQaUN480CRcR0sFvjpmIIoAHlnnLOvfnGHKdH/Fxvn+36Ov9AbLZSJDuiUEEczD9KC/fnUd54fiumTiqMedrXXVZkuM9kYUw+ahiLE4eLiGUkWBwJJEg02r1j6g2WLlG4gqwSkRra38UwtwsUlw/oLVbYkJQVsZbVPyFHXAXV5g8f3GGBdfPtwY58bfpTYIOXaWhWT3k8KUKZz+4GuTw0T1QHWWB/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUzZ7utTppgomqu8BBKewOTqQ2wmjJFZ79d1pAXa/O0=;
 b=GR6kzc9qAkn3bXOh22R+RzbbYGD/ZD8XPBPIXdykhKbPKo1JX9LSR482wxPLIeKMOUlM7AGbSd8zo/lI4eX6Xn6pY41ZNgg0wwQro1B7IMbo5OYvhhBwG+asYDr1//O6QQ+mcGWPuI8MMqYM1ytEHjZWbfBSGAEMToft17/VmxcOKJgbMS5rLDcc1xmm9bkg1PWxm2kmtwUDz/beCSnpyYYjtHKvSJ6Z/s8mOx1G/bZ17xgoLXPkBhKmQudExkjDNq1GMg8KhYg1kI73OK3cUCQAs29ZtOAeIso5/KauHRGMjAUFGW7XNi3GSb5kNKzJlaYWdWAP4EWEv1875CxW1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUzZ7utTppgomqu8BBKewOTqQ2wmjJFZ79d1pAXa/O0=;
 b=W5Amy7WWlyFL3XZs3WDTfk0y6jg6Kg0EpqQXIdpIJeeB09eDpwhPjt/5EWIvTNYcSpcyjIIbbijVG81RudbN58E9Ggdxg4WaTRIeSQ3hwpK5nHpv1pRvLouDLfJwa4gM3Q0n3w46hTTQkOoM/+8z9j3NUuqHA6sbxNadE8B4pAE=
Received: from BN1PR12CA0023.namprd12.prod.outlook.com (2603:10b6:408:e1::28)
 by CY5PR12MB6106.namprd12.prod.outlook.com (2603:10b6:930:29::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 22:59:15 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::c5) by BN1PR12CA0023.outlook.office365.com
 (2603:10b6:408:e1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18 via Frontend
 Transport; Mon, 20 Jun 2022 22:59:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 22:59:14 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 17:59:12 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 01/49] x86/cpufeatures: Add SEV-SNP CPU feature
Date:   Mon, 20 Jun 2022 22:59:01 +0000
Message-ID: <7abfca61f8595c036e1bd9f1d65ab78af0006627.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f973712-7a60-4e30-21ab-08da53107f6d
X-MS-TrafficTypeDiagnostic: CY5PR12MB6106:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB610642814686B07DA3F732EB8EB09@CY5PR12MB6106.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Whthn3VJlIN8bfO5qQ3CLHshN6fTnueuc372UkcfxwZPB1JFomBnPFnlOdoriy+SmJvcsmoYc53QPwuhISCJ/mp4RrjuVrj9Ev81HPDxj5qWQoBIk9MK99IgVTIMnzdZb0fCp/qEcdiKT4ZM83BemKAUK8Ypc9RFEjM8kM805QGvAxA1MwskCzpmhkyVCTx4C9Kx7LGKIJLvEXveTY9IMIkUIxlE3txVKzi6DMNc7fwJUA5OmGaK3LjLPeM20VNwgoqAUnLhVl4ZbX30lTN/Pg7griLgDMIp6v6AbvtuBUXJ5bAlpthYQfUTfxFQ9LrOoNDC5rRl37rMjYY7rnoLyx3sjqWkM9c1TtMCoolFj9Ur1Fx+215wzhwMqXiDWsy8CwKakRwlH9o6D4T4gdRQOJ6LM88QZlbsv8HZmy11YcYJ4ubyKIydfU52S+H7JIn9v+GfBAqQD56J5p41g9W6wgtx6ppjNes0OTNI5v7T8fRuZZNPhPTr0ganw/cEoW6mN7iELzASfsbxSUjumr7idETW3zsY2TIWAhVLsniXJwfV1lrhAmumUPzgMu7uDdREtdJzpteNLeMLXrh/1q3deg7bRSRCmSOo9W7ZP85234fwM3VwbXhVZhOIunyvO4AuAn2lCRO/hn/dhi8h/9bfGeh9qn8JXEBPLmOcMhLGtoB1QogXXwXqzlBWAZ8coIpsxPReQ1BKAKzkKwAYRs0i3Zk6n+VuLO3MoIFmiriV4l0eEqPDA3PeqAyWUtiTq6DHdteoVX1VaJTKNpSu9c1Qg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(346002)(36840700001)(40470700004)(46966006)(40480700001)(7696005)(36860700001)(6666004)(70586007)(16526019)(26005)(2616005)(478600001)(186003)(70206006)(40460700003)(8936002)(82740400003)(86362001)(336012)(47076005)(36756003)(5660300002)(4326008)(83380400001)(426003)(81166007)(316002)(7416002)(2906002)(41300700001)(8676002)(54906003)(356005)(110136005)(82310400005)(7406005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 22:59:14.8162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f973712-7a60-4e30-21ab-08da53107f6d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6106
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Add CPU feature detection for Secure Encrypted Virtualization with
Secure Nested Paging. This feature adds a strong memory integrity
protection to help prevent malicious hypervisor-based attacks like
data replay, memory re-mapping, and more.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/kernel/cpu/amd.c                | 3 ++-
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 30da1341f226..1cba0217669f 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -407,6 +407,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
 /*
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0c0b09796ced..2e87015a9d69 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -559,7 +559,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 *	      If the kernel has not enabled SME via any means then
 	 *	      don't advertise the SME feature.
 	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
-	 *            SEV and SEV_ES feature (set in scattered.c).
+	 *            SEV, SEV_ES and SEV_SNP feature.
 	 *
 	 *   In all cases, since support for SME and SEV requires long mode,
 	 *   don't advertise the feature under CONFIG_X86_32.
@@ -594,6 +594,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
 		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 	}
 }
 
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 73e643ae94b6..a636342ecb26 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -405,6 +405,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
 /*
-- 
2.25.1

