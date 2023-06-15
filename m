Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A766E730F89
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244175AbjFOGlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237380AbjFOGki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:40:38 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD2A30E2;
        Wed, 14 Jun 2023 23:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cr+a/3bx+y3DXFkpY2rKZhd5A7ufr1jKNcrsn2cqcSuCbIk7kvCoNYk0ucvFTBXHNjWrcj2dQZRnvl90zyVbKzYgZaLX4jjIJ0/VCJfvWufOl3DuODXWcS8KxYjJLjvcZwPF58wrMftPQTljePbh8u9qvCLBNcb5V/9SefRu+STvaez4dFNzGI6FQgN5DECWu9adqn5ZZmEMFcBoW68xgB19tIxSXY3J+a8jOWb2DrOkkE8sGCVw/LKbCHb/oBMSOWdXBXyYmrGE/YiMV+mY9rwF7Y+k6dSD4uzuyV8aCwgg/A2eg7AAZ8/dzif0HaaCq9hY2TRi3qy1/AIFdP5JVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQtpljWj04odF38uw1ZtZlDi8mKa6LhE6k+ISPBx0MU=;
 b=LuWN/fFQMAQuKkfRJ2XmJXDhRWLJA1X6QQ5YjqvJvi+NxHMHuEKlzpXyZnL7k5aQuMXIi1A+1l8zNrVcJpkhylR9Zn5OcAodFKgYu51RuNg0eJWN79jmXZCevnj3EOyxjhakM//L1gPwc86PY/24BWKySUX7/P2d+w6ko9OZdOmXQixO4ReB7a5B++TXkTdJKgqWZSv+fgvFthCc5vyIvZWYF0Eh3IlGcE78Z1XG6upDyH4EJZes8UC9rDuESYqAi7rBy/oyGuN7TclDAZBLOP4MHoaKfQxmNbDFoElYALJHRXTCug8go6MeW8xLmm+jjIwnV9oBjCyw22GPNCUgow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQtpljWj04odF38uw1ZtZlDi8mKa6LhE6k+ISPBx0MU=;
 b=dL2xiM+d57IBqXEYzy884QtTcelYHbc10Ez5RRWeudJ53atZEhmZSvSEYPXgwBUyWgpJ0FoVXsbXeKlTciFgbQD3Q/xjWyOivPt39CJd4g857kmBF8GCPnfHsdOKcVljIloCXyMH5/RHAorDi/HSZZJmC7JSQbIuwAFVVqn5p4Q=
Received: from DS7P222CA0004.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::14) by
 MN6PR12MB8590.namprd12.prod.outlook.com (2603:10b6:208:47c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Thu, 15 Jun
 2023 06:39:25 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:8:2e:cafe::fb) by DS7P222CA0004.outlook.office365.com
 (2603:10b6:8:2e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.38 via Frontend
 Transport; Thu, 15 Jun 2023 06:39:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:39:25 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:39:20 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        "Santosh Shukla" <santosh.shukla@amd.com>
Subject: [PATCH kernel 1/9] KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
Date:   Thu, 15 Jun 2023 16:37:49 +1000
Message-ID: <20230615063757.3039121-2-aik@amd.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615063757.3039121-1-aik@amd.com>
References: <20230615063757.3039121-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|MN6PR12MB8590:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c1ffd1c-650d-497c-69c1-08db6d6b42cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivBkzBRVUPgBsiXoiBpOSM7CM24nJItxbPbDuKs4K4zmsknlovZMTMjPPYuU1biGs/Q6vYj3/Q1G0Cu/QP/ye0XDlToZtmdZz39of1T1fMF8ep0+KfchnxFtWz7pvTRKpBd9zDmumMnCeZx4xutpiwFWE70dknrzePyisMFfiqhPB0V/6SGBF/dZUM04pYSfmrYF2VnHuZKFsvOP8tA1yfarPIp0GO73RqAlGlZHZdrT7vSKXPfmXJwT9mKRFN5xebvpFpmmOwViiljtPx+xlTD6QpzM5P9H2cLoB6ldu5tAMTCP3KScaAZXtQEUqePXdft/LcSev+BqTIn/OFNkRmN9YILUNTy4WIu9BXEVe7j0lSp03GVI6+U4K0yLjR6aN4noZCBFK815wF9ml17QlSRR/a/rEdfldHarGac1Qm614xsSGquwm2wkadNrLvgIEhTTYExn6s7kaHwu3KEwKBK2L4A8rlvgKz7Rg13ZWoLLgoQxiP4lkjRbG6Co/ydzUuCT7Vf68jA6naBlZjQgUxPCS+pKfGQV/FPlrrzKreAmygZL/DdWnANIYy/RCB90gnLgmh+cBrBRKAvoKIRzrGFAP1Ci9TkMHBruUR0EB5ExMgeylavZP5wzbbQCq+zsGwC4qYz4S9QSa7yhPqYC/AOr9RxAUR2RJpBeGdXq/iXByRky2T2OaVgWuy3xtUArCbiJhQULVw3E33TNUrj/yUqx8vMDVD6tN2aeSt/HQ0p92D4UlgVs/YT4ZyxKD6pwesrz5qjpxone8BjFlaY/mg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(82310400005)(40460700003)(316002)(6666004)(8676002)(41300700001)(82740400003)(26005)(83380400001)(81166007)(5660300002)(1076003)(36860700001)(356005)(8936002)(40480700001)(36756003)(426003)(336012)(6916009)(70586007)(70206006)(4326008)(478600001)(16526019)(186003)(54906003)(47076005)(2906002)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:39:25.1518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1ffd1c-650d-497c-69c1-08db6d6b42cb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8590
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index f44751dd8d5d..a99f97a86c59 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -405,48 +405,6 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
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
index 54089f990c8f..980faf460bfe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -690,6 +690,48 @@ static int svm_cpu_init(int cpu)
 
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
2.40.1

