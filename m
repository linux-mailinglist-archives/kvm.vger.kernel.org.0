Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242A579152B
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjIDJye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352755AbjIDJyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:54:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BC5CC0;
        Mon,  4 Sep 2023 02:54:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNFLSA1jksJ8fxBEaQsrOAi+GWNmRmNLopWKoxdw9fjev3tkKBSGI4lZMqEuWtAFvnFSKl5arjbyZWNlLM6JBGh6rpql0cUGyGhTPtuo4QI5C8rBf+mKRiJM7g040Xi8bFyj6SSdjyjx7qy7Odkawiqy6EN1at+XlPZeQXNExAfQ3Iot95TrBPWEPS9bu/C8b3Pk96SGDkt31z8NtJleO/OY7KZq+Hb2iuuWUEvq5NCrcwp1DQf++OdT7GTnuHE11qVi7D6RMh1Ohrc66BCkwD/YWvr4V/XpjrybFY2AGlnPvRQLoaMrfZo5TQaKwlQXYlJk5lfAxhBUbEigPshRQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sh1wpuwQxq299TVGZ9Mh5/zpWLGKtdOD4e26qom7GXk=;
 b=IMWIgPfp5sEpdwsqVw8Ki8dpSaA76kWMbDcUAsDNecAYpV6Uhsagxfx2IweAKVjySWbiYh0LIuqazvW2qh4ZM1ePJMMOEhNDLBRO3ylh78a+WnUjokVGB6xoz6kByOg6LTBc3B8snQBNu7m+pzoguVU8OJtzzpHL2pfxa3APklBjMnAr+Yjr0KYqhXZlal2dPFi5n1+g5JOIrPn243A/l+2XrQUi2jP4wrin0cjHAVrMecsIEX+8MHyuD61RVmaj8bfZ9yl7w4dU2AeR/Ihi8mtGENJAha6oKrL09xLvoAA/s0hVocSoVVBO4mYWtsfrMCXFpnmaKMQvn/2S7cibYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sh1wpuwQxq299TVGZ9Mh5/zpWLGKtdOD4e26qom7GXk=;
 b=ANKVfkEAjfdThSZHJu+vOD19tKEb5j95O3hgjlsDVvR1IdVyAT5vJC2nbJs+dsh+6J4UJql09NcSniWJYQbUrxfCobrT1Ti0Wd96MiLrxWtzpCWqTVA232cQ7lIT180SC08SCKf2J1C8kZCi2RhGt91S639aqUSMswzWuB8Q1mI=
Received: from MW2PR16CA0031.namprd16.prod.outlook.com (2603:10b6:907::44) by
 BL1PR12MB5947.namprd12.prod.outlook.com (2603:10b6:208:39a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.32; Mon, 4 Sep 2023 09:54:05 +0000
Received: from CO1PEPF000042A8.namprd03.prod.outlook.com
 (2603:10b6:907:0:cafe::96) by MW2PR16CA0031.outlook.office365.com
 (2603:10b6:907::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33 via Frontend
 Transport; Mon, 4 Sep 2023 09:54:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A8.mail.protection.outlook.com (10.167.243.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:54:05 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:54:00 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 05/13] KVM: x86/cpuid: Add a KVM-only leaf for IBS capabilities
Date:   Mon, 4 Sep 2023 09:53:39 +0000
Message-ID: <20230904095347.14994-6-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A8:EE_|BL1PR12MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: 28d0db8b-0d4f-4fc0-6f80-08dbad2ce019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLQIrv7mBAudbXlQRfHwJuAynLYPhtBj2GaHPI/XHQaRMtOANQjjoWeujBGkY41c2x0hT1PztxkD993hdFizaD9P7YNG9CNgJ5sax22aqL0hYZSY/SsPMJl/scx8UqA2tl5e/m6hHqdZJc16q+yG7EgwmBix5lt3Y13MYkQn/cCnwWqOvieKeEtIAkjjxiWP+1yNp/iwLvUMrcZ36K0+QWv4dTG48y4cljRiOJyB5KmEhz0Yjm7jgyPxnKjJQ3T2n/e0ZZqrY+aSgzK3pbDwS4hSSKCJfdzDQHvM7XBI3TKanOF4BnNrQMr0TGbErnJEoQlVrfTzKGdwl48c0pJ16ymgL6B5/h+3hthPrmkU/qnOAGQ3cBxypVVFnM646JPI0f5D/7Po2V3QI2nBHukUtKljYvy+FtARbbRHgKOr1QJVp9cpFwgZp+f0wPIw7NSenPb5TbwFQa+p6nG+Ouarpq21F1vpJIG4LQf9PwFaNXEqKp+5yMKG3jSwTmEefckzPYuTzeRtlCoYYIa+z9ED/3yEO697GcuRPzRxJrgCmzfeNGRFjTPzF+H0wm4/dQmoAAlbJBaF66WG05trSz41tw8fMjJ6lm/zemFli0TrYAS4HzxtGGtTVqP29GXYBA1o0WbLfAh8vaR5qTJoM0pn4GAhtsmyWnYCMQqNIlVdXIyFw5iLhpi/nBWOT9I9mhCXRFYi/MHG64zrhL5MlJelTaNuEemJplxvXo4qMKtL4D8b64VtDyIYLc3mBGTD5zjJsuPl5ker7Ft3Amr86kq1og==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199024)(186009)(1800799009)(82310400011)(36840700001)(46966006)(40470700004)(2906002)(36756003)(110136005)(86362001)(316002)(70206006)(70586007)(54906003)(40480700001)(5660300002)(8936002)(44832011)(8676002)(4326008)(41300700001)(40460700003)(47076005)(336012)(2616005)(16526019)(426003)(1076003)(26005)(36860700001)(478600001)(81166007)(356005)(82740400003)(7696005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:54:05.1424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d0db8b-0d4f-4fc0-6f80-08dbad2ce019
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042A8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5947
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a KVM-only leaf for AMD's Instruction Based Sampling capabilities.
There are 10 capabilities which are added to KVM-only leaf, so that KVM
can set these capabilities for the guest, when IBS feature bit is
enabled on the guest.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/reverse_cpuid.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index b81650678375..c6386c431fa6 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -15,6 +15,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
 	CPUID_7_1_EDX,
 	CPUID_8000_0007_EDX,
+	CPUID_8000_001B_EAX,
 	CPUID_8000_0022_EAX,
 	NR_KVM_CPU_CAPS,
 
@@ -52,6 +53,19 @@ enum kvm_only_cpuid_leafs {
 /* CPUID level 0x80000022 (EAX) */
 #define KVM_X86_FEATURE_PERFMON_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
 
+/* AMD defined Instruction-base Sampling capabilities. CPUID level 0x8000001B (EAX). */
+#define X86_FEATURE_IBS_AVAIL		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 0)
+#define X86_FEATURE_IBS_FETCHSAM	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 1)
+#define X86_FEATURE_IBS_OPSAM		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 2)
+#define X86_FEATURE_IBS_RDWROPCNT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 3)
+#define X86_FEATURE_IBS_OPCNT		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 4)
+#define X86_FEATURE_IBS_BRNTRGT		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 5)
+#define X86_FEATURE_IBS_OPCNTEXT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 6)
+#define X86_FEATURE_IBS_RIPINVALIDCHK	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 7)
+#define X86_FEATURE_IBS_OPBRNFUSE	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 8)
+#define X86_FEATURE_IBS_FETCHCTLEXTD	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 9)
+#define X86_FEATURE_IBS_ZEN4_EXT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 11)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -80,6 +94,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
+	[CPUID_8000_001B_EAX] = {0x8000001b, 0, CPUID_EAX},
 };
 
 /*
-- 
2.34.1

