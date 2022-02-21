Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1314BD6DB
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 08:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346185AbiBUHdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 02:33:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346205AbiBUHc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 02:32:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3E264FB;
        Sun, 20 Feb 2022 23:32:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0i92k3BXdanZpMGkMKiiCt30899yEg7jMDAFgOD796Hh468Q/TxIYG7vEYoZ61HSrJHQ5Zs0doRf8uy1o0uzd0f6TIVFhURc1i2dOlX+cVeB7eFrcubO4bwdFBxeVmK55TsyumUlr3zEjgnmIh/mJFFFi0Aa3D1eadgUYB6z7EEl91BzvEX4GyHeVvh5r1RqfhGr09PB5l5XTZ4mrtUeEvaVjKU2XT+u+2dFbNb84JSUlYd8GQQwd0hD61XvbHOt44dNqMaqmbWxRLYWRv0ReTwxfiow6yNTpcPp2GVzM6iEaS/JCBu++4zRVPPjnkZh4zpt9mbrcdRSvXpnLkxxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ikDOTJkoStv9L7b3/RtHn6ze5IAgG0U540TzkIGY04=;
 b=ApE9M3iqQcqxEy/YVe6zs9Ze3J/7cfnrMrxGfADcsJo+K1IaBNp4lZChq2k0WyLdPjYsfV0GKJhEVg4DJ6cQGy24e3XTeacAOlZNnO4nGf6ehF/DUm4gCp710hu0iqd9h9kTPiydtFu6oIs42/lXBSrxlwq5SEdZGf5eBiJdBHgW98IEXE7IwlcInMR/gZaq0gWyaqm4LcFkje0NTpMZ1vVhu5V9KWrq7Uz6TEfDHQHXy/Mt8WQuHo03BjJFyonKUtpy8YzdV7f+zslEA0SsqdXZFVirreYTMyj9aO7GUZ5aU1i31x/NcVhbKwm5fv0M6kqmvneqxIfs390N4UcMzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ikDOTJkoStv9L7b3/RtHn6ze5IAgG0U540TzkIGY04=;
 b=1csvMtQZfL7kwRcX0O0boY+lwYybviVqc/NPzBBuJiq1X2rmkMEhbs+i5IFSKRsOG7eOezHGKBj5Izt2/acBldnQ8LJ8SmzTSn8PJfSUfuWmb9xuT/EcA4FueVanxefqvKwW8IuLZamUKWzlJFp0E4Hzaaz/Gg4Na0KWhKWFBCs=
Received: from DM5PR05CA0013.namprd05.prod.outlook.com (2603:10b6:3:d4::23) by
 CH0PR12MB5235.namprd12.prod.outlook.com (2603:10b6:610:d2::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Mon, 21 Feb 2022 07:32:31 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::2e) by DM5PR05CA0013.outlook.office365.com
 (2603:10b6:3:d4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.20 via Frontend
 Transport; Mon, 21 Feb 2022 07:32:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 07:32:31 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 21 Feb
 2022 01:32:24 -0600
From:   Ravi Bangoria <ravi.bangoria@amd.com>
To:     <pbonzini@redhat.com>
CC:     <ravi.bangoria@amd.com>, <seanjc@google.com>,
        <jmattson@google.com>, <dave.hansen@linux.intel.com>,
        <peterz@infradead.org>, <alexander.shishkin@linux.intel.com>,
        <eranian@google.com>, <daviddunn@google.com>, <ak@linux.intel.com>,
        <kan.liang@linux.intel.com>, <like.xu.linux@gmail.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kim.phillips@amd.com>,
        <santosh.shukla@amd.com>
Subject: [PATCH 2/3] x86/pmu: Replace X86_ALL_EVENT_FLAGS with INTEL_ALL_EVENT_FLAGS
Date:   Mon, 21 Feb 2022 13:01:39 +0530
Message-ID: <20220221073140.10618-3-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221073140.10618-1-ravi.bangoria@amd.com>
References: <20220221073140.10618-1-ravi.bangoria@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b82481c8-bb4d-492b-8c0d-08d9f50c51f4
X-MS-TrafficTypeDiagnostic: CH0PR12MB5235:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5235AED7616663D7A1993BBBE03A9@CH0PR12MB5235.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JBqaEtF4iu9Ol8tx/dmHAUteUD+/M7AwAmFrlwXhMAq/g0Z3iqWpVPs31E9WHUiG4hslAvrbGOFa61BrREISvf6KW2YyMF6V1cDetRYXfYHyJ2ppgN6rwHQzxauPW99wJRqwaQKkwc0zJ/OkSv2Etld77jMBdRCsNOnxK07vYAP16SWvZjcgLuNe5l/tFkGd6tsF2p2UMrvojVOqbrHORA8kO9wxxeuf3owxkv1VgdyVvdd00XbQYdGIjV0rgoi+2MXfprYjdbzeBv3SDPD+Y6rOmdFlDAiL5uq+Z0LwCWByXA/DDyjFuMOLgVRuEbiehycutq18UfnScgmkvZZqZSVLrSecMW6IfsyKr8OOkJld4608Wub+qMOCJnJ8N/b3uuBcW8v4qhTpu/NMLGWEGPHBFknsF/vAj4Be7tisyKjOankgG0me+Wu7yZwRPM+nYA5FEPudCg6I84ZCbao09LQDgn/LWmzTvVXliX4IUga2fa+IfBe9AQrr+G4WP2tCAGouM+f+WMZJlW7iUsWlD65hI2B/zAmbA/WmFXgHKZXdQsuCQwO/Zw1YNKA93gC91bfZIVdUxnrUvCU79fhgNJG0WSyqJ1E3K2SFR8/eiidSWPVOcBd9VkP7F5l8dNowfNpiVrLVomKi+ROsseHKZfLHdwnqPbW1enTypUlfTTov3ycfXrk4r9jWE0M5LsAEvufoUhJjZzJLkJ989KVifw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(2906002)(426003)(2616005)(82310400004)(1076003)(86362001)(26005)(16526019)(44832011)(4326008)(70586007)(186003)(5660300002)(336012)(8676002)(6666004)(508600001)(7696005)(81166007)(70206006)(356005)(8936002)(7416002)(83380400001)(47076005)(6916009)(316002)(36860700001)(54906003)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 07:32:31.1935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b82481c8-bb4d-492b-8c0d-08d9f50c51f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5235
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

X86_ALL_EVENT_FLAGS has Intel specific flags and it's used only by
Intel specific macros, i.e. it's not x86 generic macro. Rename it
to INTEL_ALL_EVENT_FLAGS. No functionality changes.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/events/intel/core.c      |  2 +-
 arch/x86/events/perf_event.h      | 32 +++++++++++++++----------------
 arch/x86/include/asm/perf_event.h |  2 +-
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 9a72fd8ddab9..54aba01a23a6 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3835,7 +3835,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		 * The TopDown metrics events and slots event don't
 		 * support any filters.
 		 */
-		if (event->attr.config & X86_ALL_EVENT_FLAGS)
+		if (event->attr.config & INTEL_ALL_EVENT_FLAGS)
 			return -EINVAL;
 
 		if (is_available_metric_event(event)) {
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index e789b390d90c..6bad5d4e6f17 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -439,86 +439,86 @@ struct cpu_hw_events {
 
 /* Like UEVENT_CONSTRAINT, but match flags too */
 #define INTEL_FLAGS_UEVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS)
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|INTEL_ALL_EVENT_FLAGS)
 
 #define INTEL_EXCLUEVT_CONSTRAINT(c, n)	\
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_EXCL)
 
 #define INTEL_PLD_CONSTRAINT(c, n)	\
-	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|INTEL_ALL_EVENT_FLAGS, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
 
 #define INTEL_PSD_CONSTRAINT(c, n)	\
-	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|INTEL_ALL_EVENT_FLAGS, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_STLAT)
 
 #define INTEL_PST_CONSTRAINT(c, n)	\
-	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
 
 /* Event constraint, but match on all event flags too. */
 #define INTEL_FLAGS_EVENT_CONSTRAINT(c, n) \
-	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS)
+	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT|INTEL_ALL_EVENT_FLAGS)
 
 #define INTEL_FLAGS_EVENT_CONSTRAINT_RANGE(c, e, n)			\
-	EVENT_CONSTRAINT_RANGE(c, e, n, ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS)
+	EVENT_CONSTRAINT_RANGE(c, e, n, ARCH_PERFMON_EVENTSEL_EVENT|INTEL_ALL_EVENT_FLAGS)
 
 /* Check only flags, but allow all event/umask */
 #define INTEL_ALL_EVENT_CONSTRAINT(code, n)	\
-	EVENT_CONSTRAINT(code, n, X86_ALL_EVENT_FLAGS)
+	EVENT_CONSTRAINT(code, n, INTEL_ALL_EVENT_FLAGS)
 
 /* Check flags and event code, and set the HSW store flag */
 #define INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_ST(code, n) \
 	__EVENT_CONSTRAINT(code, n, 			\
-			  ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS, \
+			  ARCH_PERFMON_EVENTSEL_EVENT|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
 /* Check flags and event code, and set the HSW load flag */
 #define INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD(code, n) \
 	__EVENT_CONSTRAINT(code, n,			\
-			  ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS, \
+			  ARCH_PERFMON_EVENTSEL_EVENT|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LD_HSW)
 
 #define INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD_RANGE(code, end, n) \
 	__EVENT_CONSTRAINT_RANGE(code, end, n,				\
-			  ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS, \
+			  ARCH_PERFMON_EVENTSEL_EVENT|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LD_HSW)
 
 #define INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_XLD(code, n) \
 	__EVENT_CONSTRAINT(code, n,			\
-			  ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS, \
+			  ARCH_PERFMON_EVENTSEL_EVENT|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, \
 			  PERF_X86_EVENT_PEBS_LD_HSW|PERF_X86_EVENT_EXCL)
 
 /* Check flags and event code/umask, and set the HSW store flag */
 #define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(code, n) \
 	__EVENT_CONSTRAINT(code, n, 			\
-			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  INTEL_ARCH_EVENT_MASK|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
 #define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XST(code, n) \
 	__EVENT_CONSTRAINT(code, n,			\
-			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  INTEL_ARCH_EVENT_MASK|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, \
 			  PERF_X86_EVENT_PEBS_ST_HSW|PERF_X86_EVENT_EXCL)
 
 /* Check flags and event code/umask, and set the HSW load flag */
 #define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(code, n) \
 	__EVENT_CONSTRAINT(code, n, 			\
-			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  INTEL_ARCH_EVENT_MASK|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LD_HSW)
 
 #define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XLD(code, n) \
 	__EVENT_CONSTRAINT(code, n,			\
-			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  INTEL_ARCH_EVENT_MASK|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, \
 			  PERF_X86_EVENT_PEBS_LD_HSW|PERF_X86_EVENT_EXCL)
 
 /* Check flags and event code/umask, and set the HSW N/A flag */
 #define INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_NA(code, n) \
 	__EVENT_CONSTRAINT(code, n, 			\
-			  INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  INTEL_ARCH_EVENT_MASK|INTEL_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_NA_HSW)
 
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 002e67661330..216173a82ccc 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -73,7 +73,7 @@
 	 ARCH_PERFMON_EVENTSEL_EDGE  |	\
 	 ARCH_PERFMON_EVENTSEL_INV   |	\
 	 ARCH_PERFMON_EVENTSEL_CMASK)
-#define X86_ALL_EVENT_FLAGS  			\
+#define INTEL_ALL_EVENT_FLAGS				\
 	(ARCH_PERFMON_EVENTSEL_EDGE |  		\
 	 ARCH_PERFMON_EVENTSEL_INV | 		\
 	 ARCH_PERFMON_EVENTSEL_CMASK | 		\
-- 
2.27.0

