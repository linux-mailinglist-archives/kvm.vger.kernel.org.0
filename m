Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD31C6DDB54
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 14:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjDKM6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 08:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKM6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 08:58:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBB1ED;
        Tue, 11 Apr 2023 05:58:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euT1s5Lk/y5WmAIXcBQB9inBQ6svBoexutAEtPHOVygTGbTAqBgRgpRQkdJXMMtQjJFwwfacFpH1yRBmoUdKOtuFWGUk8fg8da4pCTqm89+QN5ZWuouV9olUiM/2XF8HlpV8c2//5yyeJWQ14M7QTQbHibsOqK3m0lDKPMrqaCzwDXQObjOk52n2P60gY5X5MwS7l1f7gvXemY4+mnydCcMRQwS4csaGdNj1K4NAL8warYdiUNOpI7DVSx033+YE4J2vHcTJDCeZawbZLli8EnGKwXYrdurT5eZkar8zAK1brwx5bLbxkq1uXyyXurRTALsu99rH3JevJbgakci5bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZldQZbVfyxm+JxRPm5ZrtW35+VCndOiNJLwQFrZH3/g=;
 b=QlwG9H9J4DQflOVzt9vGPvxB7yOshC24U3cokkqhFgXc3c7sA4L8IBDZcpW5Fv+TbU/Vpd1kusuiC77ZxCETRKJ8kXG1rOXtWAc61LkQ9xb/3/wvKQaKP1EQRqX/r+XlOB4MXkpkAqYQT76CCwQoYd9DcmtP6on8omHCH3LegLOn+/nbjrmKmNnO+EaXoDbIuvxjlJy48CTz++Zh2OnUJEEK+rF4qjQnVcm6qDBXIaeGSO64c6z3n0dfZhM+fcDph8wM/9UUhZ73dtbIhLDUTZmnmXdMPHs/EtladZP+2AbCVmjID3/To8Fs8dUfSzD3txk50J5CpOq+QT1437kzyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZldQZbVfyxm+JxRPm5ZrtW35+VCndOiNJLwQFrZH3/g=;
 b=358hOxhCuQVwgB63wvtTKQhFZVB1T3ZH/H7tjmVZp6C/eo3IRVvTJQUlhy8CMPl5ktmk5un2aK0aSL4SKawDtEHjLhk0Rh1107mdBiCipykE4TK/MDhHJPjmxFfFUpwULCh9m666cBkJWo+XdV0f78pN5shkyzc7d5xhqXQg6Y0=
Received: from MW4PR04CA0172.namprd04.prod.outlook.com (2603:10b6:303:85::27)
 by MW3PR12MB4489.namprd12.prod.outlook.com (2603:10b6:303:5e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 12:57:59 +0000
Received: from CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::b7) by MW4PR04CA0172.outlook.office365.com
 (2603:10b6:303:85::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.39 via Frontend
 Transport; Tue, 11 Apr 2023 12:57:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT108.mail.protection.outlook.com (10.13.175.226) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:57:59 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:57:54 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Pankaj Gupta" <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        "Santosh Shukla" <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v5 1/6] KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
Date:   Tue, 11 Apr 2023 22:57:13 +1000
Message-ID: <20230411125718.2297768-2-aik@amd.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411125718.2297768-1-aik@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT108:EE_|MW3PR12MB4489:EE_
X-MS-Office365-Filtering-Correlation-Id: 43e13825-4d49-4e59-91ec-08db3a8c60c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBR+Q+L/lx6c6jx5lhStzeuMZNBBYFFdipt5Q7bVw5xttBXw/g3WxZvSMj63cRYR1inFkIBvxemPhtqMYpsEA23tIaM27C98xgDMNp3QLCtq9pH0QQAYnWDsD/9hOwEqfVel7T8cMlixs2wxqeou5kJhjJoBUbPj4Q4kiBedS/knot9wAPSbDFnzcxqhKhJ3ctvxnZreOsrduANfX2fH3jDS0jSMWSxfLn9fPIckXAUsJzdDZIqvbSlhnztx+bJ5czr3dAfdNo7T1HS0xlKb5RVzSm6jiEgFNfa3o5+275SZw9hBqFyDNtgs9c7s4FwNiGxP74Vpih0sbWKki6T8RnTbn/W+GamZKCtQBZL8NKbcek8gIhBRx3wBVkS5BzqPqaE1gFjrPNq5SF+LlDXnRH29VC6Fdb1XXp4ER/a92WvyehYWITZK6+/b73uqvp6SseSP+5vqgXM9V+3/dCwUGOZEvAO7gP5QJmlOqBmEG+guf++/TxOA0VkKdOLDsJ3U0ikgHcdyk1BkgPc1xh7ipzIi4hnaBdreB8SydFG2i0cxsdnQoOK+SxtdTNCU26F1Ew50V2vxU6OT08qcyT3/i1LAwLJNakTc1gNwLLaVapbychV+W1nVAoKOKFoKiq9mmaWjGWvRYFkCKUA6c9Wp99LFxjMLvYpJ09hQ0VhNR0bxtRCSdwZiHuv2LQUb/aKYRxHt+nDZYfW/roCR82MdVqNodVToarcuwaPkn4b7yBE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(478600001)(4326008)(6916009)(54906003)(8676002)(70206006)(41300700001)(316002)(70586007)(36756003)(83380400001)(426003)(336012)(2616005)(26005)(1076003)(6666004)(2906002)(8936002)(40480700001)(5660300002)(82310400005)(36860700001)(82740400003)(356005)(16526019)(186003)(81166007)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:57:59.4887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e13825-4d49-4e59-91ec-08db3a8c60c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4489
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Static functions set_dr_intercepts() and clr_dr_intercepts() are only
called from SVM so move them to .c.

No functional change intended.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Santosh Shukla <santosh.shukla@amd.com>
---
Changes:
v5:
* new in the series
---
 arch/x86/kvm/svm/svm.h | 42 --------------------
 arch/x86/kvm/svm/svm.c | 42 ++++++++++++++++++++
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 839809972da1..4deec59be71b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -403,48 +403,6 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
 	return test_bit(bit, (unsigned long *)&control->intercepts);
 }
 
-static inline void set_dr_intercepts(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	if (!sev_es_guest(svm->vcpu.kvm)) {
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
-	}
-
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-
-	recalc_intercepts(svm);
-}
-
-static inline void clr_dr_intercepts(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	vmcb->control.intercepts[INTERCEPT_DR] = 0;
-
-	/* DR7 access must remain intercepted for an SEV-ES guest */
-	if (sev_es_guest(svm->vcpu.kvm)) {
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-	}
-
-	recalc_intercepts(svm);
-}
-
 static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a1b08359769b..1e1c1eb13392 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -687,6 +687,48 @@ static int svm_cpu_init(int cpu)
 
 }
 
+static void set_dr_intercepts(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
+	}
+
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+
+	recalc_intercepts(svm);
+}
+
+static void clr_dr_intercepts(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.intercepts[INTERCEPT_DR] = 0;
+
+	/* DR7 access must remain intercepted for an SEV-ES guest */
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
+
+	recalc_intercepts(svm);
+}
+
 static int direct_access_msr_slot(u32 msr)
 {
 	u32 i;
-- 
2.39.1

