Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2603252C05C
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240115AbiERQ1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240177AbiERQ1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:23 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED646B086;
        Wed, 18 May 2022 09:27:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVYsthIr0u1n2SMMZonUFogTkg3NnWbKJ/tDxRXV3k24m3cu/JCyzI6eS1TBG9rX0R8XCDWD8FFbqYu3W0aqoYAOjHFYb3/5AW8q7lfNl8SBJpoN6k9wskKZwffYML2DCR4xoUeWsA6RvOZ0CG1pIuqeXfvft9HgUWZa0T0xUTWnGwsDsKVTW1CeO0GzB2qECRh5ZRSJXfy7vxJ1amkf9ZJkTkc1YoGJLi/taXa4rfjwF0djufp9V61dZdzFah7IldFh6U+7RFtIoI15Jh814YK2Qb8Jh7y6ZmPF4/bhpGbi7KPNjc27e7rnD+L5Jgs///ZiuoIgmvX4LqPfLSKyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B06hmCDbcPMOIz5jArgE4svMc8q/kgfB0AJoJeN67Uc=;
 b=Bib/qKRMVSqXj+XnTIpSTfGBiKXupPSyT2oj5hgxA2Bk5Km2SsqypPP+RXWuu4PxWyyt0G4XJSL4WbVEaR+df8CD8YdRZTgAnoJUTACauRi7SkmRVPSITwTizHuylMf30AbOan12J7J5tl/ScH5P8jGz2Ib80ArPYbOaH3uvdAKAugYlrbZa7FH4sT1jS2BepiqY9qEOkhavOJOZ7CbjRZh8BDAG/6aXrCT/TUdwm3C+40+SIE0Ggg0X7lv4CE/Y5NwHOrKUzw169L4Z/cAKb8AMzJJynJV7RuboGy8nomnEjC0HncuG/2g0Yf1J6yV5P+kFVeRnXDl156o6TJtlTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B06hmCDbcPMOIz5jArgE4svMc8q/kgfB0AJoJeN67Uc=;
 b=zIqRY2A0upwbkg34JQ+IfN7Ml1lOCF5F4KMicgV1jbGON+2psC4Hdmppi5LWb4j9cHCz7WTS0KFX+aGeeUxjISmIM83yA5I7/UmT6pHvoj31MMZ4NPgMaD8Sf9dw9RUgBevH5hcbkacCqgvjlZua/DD8/Xvr+qWYAhkQnMlxa1M=
Received: from BN0PR04CA0179.namprd04.prod.outlook.com (2603:10b6:408:eb::34)
 by DM5PR12MB2549.namprd12.prod.outlook.com (2603:10b6:4:bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 16:27:15 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::41) by BN0PR04CA0179.outlook.office365.com
 (2603:10b6:408:eb::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14 via Frontend
 Transport; Wed, 18 May 2022 16:27:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:15 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:11 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 07/17] KVM: SVM: Adding support for configuring x2APIC MSRs interception
Date:   Wed, 18 May 2022 11:26:42 -0500
Message-ID: <20220518162652.100493-8-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8a2bd26-1082-4298-7ab8-08da38eb4525
X-MS-TrafficTypeDiagnostic: DM5PR12MB2549:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB25497E2039AD53BE7A94DE09F3D19@DM5PR12MB2549.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SMTEYWukh1ho/u7IC7WS0IY0Hrz0dlIZNYtsV7U2R3QfkaaVd9gPRACcWkJKTX9VJvbTnHCHxgzgisk6kKQAF2OZ4MYMaFSOj+8FVrPsGuMdIOYSBOHbbHoszIIOfYRFa1KpFiKgGNq/dXVzz8I0jJlGScyxXFm461D3ewMBmzuRHAcU8+nJDrOgnWm33OUWwuDu5wkuhvVU2ir1CueAn1FjDR986mWmMrozItUVQJ0KEQohHcWt/1uYdfsag794k20b0bLSZuTqOxibR0g2SmOpkxM8uiR4qI7wgNySj+gTGuMUHTyGmuDpsH2xBrgDvpiyJ7Xy0gHnOpq67yQzvEFILRA3qyMk8c+7Rc55NJOdhjQn4VTxK0vmxZf5HOXtQaB6Bjbc/zz2HJrPqPsN5W/uX1fH71KetvAngxPjXyHObaRDrq1fIHLmV/kGVIqLR8eMle7zQ7qPVa+IeFrQRgq/7Wltv1EBDoobunuDzQRBPUmfkCkzPL5N6VTTlgrrdyuZy30mNsK03xP7tjwzXNMU4dqFWZo0t52UgMMVEE5PD7qTolgMWyl1JfAlsKs0H7Ywra2RxSAJUy87qoaFK8oPeE5++Myo0rl4BZMCnioaL9NmRwokczr6+iBBqWyNY1x+CnEVPAYcj6NnLli2LN6Ywp1uE5cQFi5SLn8mHI+oUFpO9mipBYrYbTClBEBcM1yYo1AFvzzX+rL1IkCqeQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(2906002)(186003)(26005)(16526019)(1076003)(44832011)(40460700003)(6666004)(2616005)(36860700001)(7696005)(47076005)(426003)(336012)(54906003)(316002)(110136005)(356005)(70586007)(36756003)(4326008)(70206006)(8676002)(86362001)(508600001)(5660300002)(82310400005)(81166007)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:15.4119
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a2bd26-1082-4298-7ab8-08da38eb4525
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2549
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When enabling x2APIC virtualization (x2AVIC), the interception of
x2APIC MSRs must be disabled to let the hardware virtualize guest
MSR accesses.

Current implementation keeps track of list of MSR interception state
in the svm_direct_access_msrs array. Therefore, extends the array to
include x2APIC MSRs.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/svm.c | 25 +++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  4 ++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 196bca5751a1..2cf6710333f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -100,6 +100,31 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
 	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
 	{ .index = MSR_TSC_AUX,				.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ID),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TASKPRI),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ARBPRI),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_PROCPRI),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_EOI),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_RRR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LDR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_DFR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_SPIV),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ISR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TMR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_IRR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ESR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ICR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ICR2),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVTT),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVTTHMR),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVTPC),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVT0),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVT1),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVTERR),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TMICT),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TMCCT),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TDCR),		.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1731c1f3884b..16f1d117c98b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -29,8 +29,8 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	21
-#define MSRPM_OFFSETS	16
+#define MAX_DIRECT_ACCESS_MSRS	46
+#define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern int vgif;
-- 
2.25.1

