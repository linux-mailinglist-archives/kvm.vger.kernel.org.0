Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02BA730F99
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbjFOGpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244085AbjFOGoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:44:23 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11C735A2;
        Wed, 14 Jun 2023 23:42:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRd/I8cRayPT1Rm85BY1tkt2NtYef09uW9MXj//ow6GWcDhX0w+dkr44VmoYpxvMd7ExHYONSkCErJ4kcqV+lmiNr3JecJ/shgq0bqQc/sy25imr/9Vw8xdDfvRJuxc7WL+lQFPQQDrnhIBkofQDBFEd9LL4QrX9Or7kmL0cqtDKyV4N6gRq1rItL5G10+RUDlTTH2Xrtjgam/+P5d+68D1dK0czbfvVbOOjzeVN+nodEDMJA2rhoNRrBhTnvO+Gzg4bxneQ4AT9FZts6u3Bm5PRj5T2XKPAAE0ocLmlPL6iopaiNt+daTABy8R10xpHL5ClT5LdMKqAW8N5WWCsdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WFig3m3GZo4xcuo46AjjaGz5wr8vSn8NjIqI6ME3K5g=;
 b=eX8UStRQZKCkzwnuyb2eSKNSeD9Uzq05aqGM3a9Fm0jgv0WUKMmLTuehkrzx8jdMxvu+ISxCIA3be5Skc2X5smWdl2tFbtFBDg3NlQWr0Y0ob+7mmrvgeYjLEM23y7FIvLcx+gkrBgHcshy5c23YGo96EKveEWC1JFpu1+Fi1udDB4mHjYqdIGRU0Nr9vV9EG1ZS9qUAm64i37s6S8BNPlbPYJZyH5wVvBCZnd0ttIzcc4jnHfwAA4JCRMYt1jeBxD4vmZwiUx71aduZuWa/mbV5J6r2hXpm5KMRt/CWKaYTMsMz4bZ87j6Khsioo3d4RlhPc+IXNjbykUD7TLOTxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFig3m3GZo4xcuo46AjjaGz5wr8vSn8NjIqI6ME3K5g=;
 b=Hf4k63g67b7ZOeWnhWgaiisQriakKcCbNxvNJwEJQJylk26wnYpZXNsjPWUA0SKL5l5ailKLP815SJP3+rw/jfGMseq6Ze1HKdrSLQmKu8xMVgs+uUV+GXJmydEqzTLOdGIoJmEHDw1SqA0GQzIx7Smt/Me2+7caDR/joXhYG+M=
Received: from PH8PR07CA0009.namprd07.prod.outlook.com (2603:10b6:510:2cd::27)
 by PH0PR12MB8030.namprd12.prod.outlook.com (2603:10b6:510:28d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 06:42:55 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:510:2cd:cafe::3d) by PH8PR07CA0009.outlook.office365.com
 (2603:10b6:510:2cd::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25 via Frontend
 Transport; Thu, 15 Jun 2023 06:42:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:42:55 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:41:48 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: [PATCH kernel 5/9] KVM: SVM/SEV/SEV-ES: Rework intercepts
Date:   Thu, 15 Jun 2023 16:37:53 +1000
Message-ID: <20230615063757.3039121-6-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|PH0PR12MB8030:EE_
X-MS-Office365-Filtering-Correlation-Id: d84c6f1d-879f-403b-1962-08db6d6bc00f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5FBFzCiBFHu3SUju6e6+DryKm47pLbE3f6sLHbocN4Piy9HwklI+W5zULSCfg5/ahF0dzhvyPZxVeEQQYBxWRH/pCFNHw0fLLxsgOHS5K9nkoB+Mc/PZxP3Pg+xc2ewnmCpAdSoxxL4FqVZ1E3dF1teHfqt3Q7W4auizPscmfCm9g7RfdwNWPUfbiP3GwFdtaGnNcWlKg9uxz/R/iLryGV9OfBwTQIbHHb4WMHZ+1RLUs4+zd6Ie5JI673vYwRcGtXWH+vqRQa4UHud344VyxiPw5tL+TsAvnaBWNMAIIUsbSr68EJAqAwcCiLjLvKFFC1BQqDXt580sAp0mhmbEUabsheQ07/J4XYzxakwtogFclroDTK/kfcuwPHP4f55A9MGEl++Ssl9L1d/klCiM/MmxDnTQA/x54Q+reDbnfTZVGbhJRZEe6SS5qw2iVF+9FjQ5YePRp4ZaDXu3oRdovrfShH4J2yfN/HKSzAbSU69H5e8Zd0Yi0akc5j77wz7flQx0vuJZvPSmu2yos0UVUxgdkisyHtlDabprVOrSUrt+Q0wYqnBwDgoXw2YRoHqxiQiVLmX8wt/WloY2KqVkPAGZ7D9Bch/STQWAqw2W6lLc6I+FB5tO3w7jhcGT+zih4PFXO04noaPmroI905Rr9WAsx0qUY+tQB5U9O81+m+0JfffQBap6REIjQtJhUbSomZYK1nCw98AcmUadtYRarJfHbKXXBdGkbARirvpHPy9q2vX9PYZeIt2FLjdpL8sC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(36840700001)(46966006)(40470700004)(1076003)(26005)(16526019)(478600001)(36756003)(186003)(966005)(40480700001)(6666004)(40460700003)(2906002)(8936002)(316002)(41300700001)(8676002)(356005)(81166007)(82310400005)(5660300002)(82740400003)(336012)(426003)(54906003)(47076005)(83380400001)(2616005)(6916009)(4326008)(70206006)(70586007)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:42:55.3575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d84c6f1d-879f-403b-1962-08db6d6bc00f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8030
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently SVM setup is done sequentially in
init_vmcb() -> sev_init_vmcb() -> sev_es_init_vmcb()
and tries keeping SVM/SEV/SEV-ES bits separated. One of the exceptions
is DR intercepts which is for SEV-ES before sev_es_init_vmcb() runs.

Move the SEV-ES intercept setup to sev_es_init_vmcb(). From now on
set_dr_intercepts()/clr_dr_intercepts() handle SVM/SEV only.

Extend the comment about intercepting DR7 which is to prevent the CPU
from getting stuck in an infinite #DB loop as described in
https://bugzilla.redhat.com/show_bug.cgi?id=1278496

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Santosh Shukla <santosh.shukla@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
Changes:
v6:
* updated the commit log
* updated the DR7 intercept comment in the code

v5:
* updated the comments
* removed sev_es_guest() checks from set_dr_intercepts()/clr_dr_intercepts()
* removed remaining intercepts from clr_dr_intercepts()
---
 arch/x86/kvm/svm/sev.c | 11 ++++++
 arch/x86/kvm/svm/svm.c | 37 ++++++++------------
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 981286359b72..744bcc2e6a05 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2948,6 +2948,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
@@ -2976,6 +2977,16 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, TRAP_CR4_WRITE);
 	svm_set_intercept(svm, TRAP_CR8_WRITE);
 
+	/*
+	 * DR7 access must remain intercepted for an SEV-ES guest to disallow
+	 * the guest kernel set up a #DB on memory that's needed to vector a #DB
+	 * as otherwise the CPU gets stuck in an infinite #DB loop.
+	 */
+	vmcb->control.intercepts[INTERCEPT_DR] = 0;
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	recalc_intercepts(svm);
+
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bec6fb82f494..1df99e9f8655 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -694,23 +694,20 @@ static void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
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
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 
@@ -723,12 +720,6 @@ static void clr_dr_intercepts(struct vcpu_svm *svm)
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
-	/* DR7 access must remain intercepted for an SEV-ES guest */
-	if (sev_es_guest(svm->vcpu.kvm)) {
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-	}
-
 	recalc_intercepts(svm);
 }
 
-- 
2.40.1

