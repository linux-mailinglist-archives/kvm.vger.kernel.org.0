Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCBD52D077
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbiESK1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbiESK1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F128A7E27;
        Thu, 19 May 2022 03:27:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0r/0vO2gQpkpBG9sKTbbO0xn/dftpF/o/iU6jy1pFXfCnKMz5MGlxPJ5fKClQMpyOrFp/grLCHfTsxKFxN+nEtw1j7gZEhU3rDgSUS3PpG0rxMOY+wJroeaCBvWe31Qe5TwCykTT3Fg3iN2tIgSmZ3cl1q+5g4KmMTtJnoVV5/Dn/B5uZrbnV8cVQRXo6ucpCoiSoMFi/tx+0foQSnxeRIUgS0T82S4JG068HlHlmW8DvIGSdsmUX7MimUwxxeu41ccSGJq/SEwmd1A7/maC7ZEcDDbFnlrt1IAE8DbvmX3JBkJD1elzSNn9xWq9cmBptzM+YDgwg/gfOiMR7JoVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B06hmCDbcPMOIz5jArgE4svMc8q/kgfB0AJoJeN67Uc=;
 b=doCrzV/Lqudo3UinDNnaLxYA9bitbVM+OepVejwlfMmXSTw+k6wwTyjLKEUyMa00ER+RfrvZJ39LjcguF5hj6e5V9w97yk8JLLxCblsjq6Ix08tgrwe1XuPsxXbykju1bsdKyoXNAuRbxpZWNuoVONTPB1lVWEEwVoWVs2EzI2OLAMKqj80NvhASUXROigHI+zb+W9wRV8k8LisgfUUSsmoTS5DfSApDV2lHjDfRiyZuOeNIAt27IK/pD4cpWOjN/7oUSbtoGsDGbjMjdKBziSh42cisynxNkjYt+MiK7SGApU67+BxDbNOsDpL+Pl2wzQg4667cutdbIYSBaimSOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B06hmCDbcPMOIz5jArgE4svMc8q/kgfB0AJoJeN67Uc=;
 b=bPMQwQszvgmC8upWrXbBUlqssiEKfQSYOHZMacX79i+/Nz65LO9UVeGz+wzwQDk/kb2P0Bu3y4quguRowYiNOIcja+sRaEr4p7jtS2kmK1MIb2jZHAF8b82a1scV0oyGOUOYpgkxNj0kREGUQ/zvjAV3B7BO0Gl80vfqUOoCVf4=
Received: from DS7PR05CA0035.namprd05.prod.outlook.com (2603:10b6:8:2f::18) by
 DM4PR12MB5892.namprd12.prod.outlook.com (2603:10b6:8:68::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 10:27:32 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::9f) by DS7PR05CA0035.outlook.office365.com
 (2603:10b6:8:2f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7 via Frontend
 Transport; Thu, 19 May 2022 10:27:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:32 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:31 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 07/17] KVM: SVM: Adding support for configuring x2APIC MSRs interception
Date:   Thu, 19 May 2022 05:26:59 -0500
Message-ID: <20220519102709.24125-8-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f6f1525-7045-4675-e3d9-08da39822f2f
X-MS-TrafficTypeDiagnostic: DM4PR12MB5892:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB589258296E060387EA5EA134F3D09@DM4PR12MB5892.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kynO2q85RIW4xQXZ04IvCp0qoO8RRWlChFHC0QAxxMcKw9F3OuvaEDhWd+RB8Yb27K07rENDXJwbh3kDhS+Pa/y5XnicwjqAbH4KZQ4DGUnkkoIKfQWILNQbMqXsQsaoTlcS5Lo5W0QrB/S8gWP6lqOXRwcmreGYGqnOx5S0qpq87v3up8KAp2WqSNcf+7QzcjErRra0DhtBKzZM0dzKglhaB4woEWAQfIdpHTmIOHhy0FVTo9kbNHs9qgumdUzcj2T70bsRPHBTLmjGTWlIDI3mP6C5QPEmnuZnc/zl9Yx5W6TlXiZeAfmdA9bLqYKQIw0vu8KDKIUZJXdDNq07MC6pWCxx5x0dwrSppxSuBTvyghzf6kmRZwN2kTR1eTDlXiSeGPrbXv7YXeodB9il/nG9pNAyeprf8OLTKh7sbP9vlngysZ0ftht6rWSNgn6Q9vmap4Lq7o0UDuznoYjtzWFNTiNuFA/HlrR/fR1Ge4B8EYSfqMYqpjSLqXoBXn6YGPjWAXBnfX6TtwerXOd+11ot7g7QMS3uUvdjmNKO/aovdyoDb+oJa37tIc29frR4NANuNp0/2omOOI+cvxeWVoHqvSwWegKvc6EoJ+nZUFlqoAEfxGNEX+owX+4o/7xQUb+xUyHcUJ06YH9DNtuDO2/e1KaDEskzWKeeFWeyZ1XgwoJNADDxhvnSLfub3D8zp3KAVNYt7DeIl7KYU5ZFMg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(316002)(86362001)(36860700001)(82310400005)(426003)(336012)(47076005)(8936002)(81166007)(4326008)(44832011)(54906003)(8676002)(7696005)(2616005)(36756003)(5660300002)(186003)(6666004)(508600001)(1076003)(2906002)(40460700003)(110136005)(83380400001)(356005)(70586007)(70206006)(16526019)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:32.5452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6f1525-7045-4675-e3d9-08da39822f2f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5892
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

