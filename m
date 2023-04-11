Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101FD6DDB5A
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 14:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjDKM7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 08:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjDKM7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 08:59:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCB549EF;
        Tue, 11 Apr 2023 05:59:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYCZe4jLDrFYeaKW7Ww8Gdd6fHF0D31FCXFS+JgHaA8nPI5HjnkMjZmvT6XqUXZCOhWT+g84E3bcgFtWgBNdOc4f0TITwjqM3GuK/yqZ1MJ2CkIWbhxGuSGVaixyumxsaMxO6SnjOE7XEfp+hTZjUoGPI6z/AVa1X3FC/R1jSZ8zuh0uXhyY3DljnX5LNhrjcb51mJ/MejuQyww7h89FaxMCgqxTeDkSANaRutK/VDUFkH75fHChvak8OMiskqlVv5UPjLyTIRL3/BnxteN6Itijvsv4oUQbDT7JPvI5lUiFQJlqzLIx/Qk108zqsTaF3YS4VJcbGNoHdfsCMVPoTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LmWgDFoO8XYqPujwhh3z5yBn7YhL0mbclmsq+ahhdcc=;
 b=lXHIWOWaLWgzM85KaAIM8OIO37MAb86r9Q2B7Uwx1xEf9tLQTEuiUb44lFjPFBlqlWzL4BHk1jcDbNxjXvGHJSUzd/TAtfr8WrGiwyPsVfKHk3MhZj1IWHLGUm7/RgsrNcfLChycbph9bRFfBzF1XN75Rc8QHsLxLDwf6aDAnKgOTSRsdJwJQ8TQSeg8gicV3RrqEkywgEEtCc0eMbP8fcmUsquItzEfCUthgU5pqNmnrH3Sg0g2t1NWZHz0cccl13qb0blOBbd6Zh6SotaixcpothFCg6VIoHyXZxc/1OifH42vNpeltXdd5NZyrkHxP/10Kt9mve6xUk6vuLcYog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmWgDFoO8XYqPujwhh3z5yBn7YhL0mbclmsq+ahhdcc=;
 b=iHW8wnxJAHzQzqZim+Iph78/feuySiJ2wFcPyWrc4Ngq6fY1avQm4H1GJVyhd1fcpW6HKMTaNsETPOLLJh9sCl0qyZvxK2fWiOMrFbGJYtTDaYKcg45OLWie7qsrMy09jPyp8TTb2zOT+n3z7G/O34o8XyyutmaK5stNEfRxrrY=
Received: from MW4PR04CA0103.namprd04.prod.outlook.com (2603:10b6:303:83::18)
 by LV2PR12MB5965.namprd12.prod.outlook.com (2603:10b6:408:172::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 12:59:01 +0000
Received: from CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::33) by MW4PR04CA0103.outlook.office365.com
 (2603:10b6:303:83::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.40 via Frontend
 Transport; Tue, 11 Apr 2023 12:59:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT089.mail.protection.outlook.com (10.13.175.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:59:00 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:58:54 -0500
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
Subject: [PATCH kernel v5 4/6] KVM: SVM/SEV/SEV-ES: Rework intercepts
Date:   Tue, 11 Apr 2023 22:57:16 +1000
Message-ID: <20230411125718.2297768-5-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT089:EE_|LV2PR12MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b79b31a-e60b-4801-4f01-08db3a8c851b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aU2nC9HQYw67ymgnvyO1IlA3Cs/2Z0qnIYrmRHWSrw6MBuXtbRVwwE80XW6ZhZyLwjL+TFkbHuhJ2zpSb6oj8ClNZ+qpgyZsjnZ4MpF7pqelo9ktwtH0LVm5XUO1dXcOpLaIz8QGGvKu8SuPmKSGxbE+cCxTlkZZC+m5wzS3iBnB7akiu20faFEqDV6S2zdzxICqKUAp0Elb6I4fdgmUz/TJPpavIbNVRW1M+qjYnp3RzO8ijwJ7VZGSRo6PbU1/SORReCVHTAGoZ0RWKJgtUEZdGo6vFYOqEDcv/YVnDwxP+SObkjipejVkSG/6EDpQBPKkuJU/SLDQxpif451QYYmJJw+9QeYYQ7giDrZKwZr+xakkw6oETR/FkFcHLN4RfcCvvMDLp4Qy8fS3DE4M6/nwaC1xt8qat3RzDX4sZ10RWGtrs/6oCJ1bIJTJaWydtOIDyc3oNVcQtKSEL8fVUH56bvaqggoY9i4kP3Ew3eZyjynY/iSPT/OWMKPciiXJkcInGEFrBvaGo7AcRSUyrka7cPhZd9KtqSoqRVBHBsB4a3e2d9MGb2t8cEh1bJGaH5JfV+xY2XHPSXhA2a0UeIaWWTUNyenE+LOIeifF9zJ7caAtdUFqT97hQMJ1i6KcvtAql1K4W91KmeVexmzWt7SamSwDtYot/LK43uVixjIuN2tfJvuxxFLb/ZdFkCByDIjfpiuSMberSSTx/c+mb4zzXw7w3InL8EeGtmCmQ7I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(8936002)(336012)(426003)(6666004)(5660300002)(36860700001)(41300700001)(82310400005)(478600001)(54906003)(36756003)(70206006)(70586007)(8676002)(6916009)(4326008)(83380400001)(316002)(40480700001)(47076005)(186003)(16526019)(2906002)(356005)(81166007)(2616005)(1076003)(26005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:59:00.4642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b79b31a-e60b-4801-4f01-08db3a8c851b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5965
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Santosh Shukla <santosh.shukla@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
Changes:
v5:
* updated the comments
* removed sev_es_guest() checks from set_dr_intercepts()/clr_dr_intercepts()
* removed remaining intercepts from clr_dr_intercepts()
---
 arch/x86/kvm/svm/sev.c | 11 ++++++
 arch/x86/kvm/svm/svm.c | 37 ++++++++------------
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b4365622222b..f0885250252d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2946,6 +2946,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
@@ -2974,6 +2975,16 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, TRAP_CR4_WRITE);
 	svm_set_intercept(svm, TRAP_CR8_WRITE);
 
+	/*
+	 * DR7 access must remain intercepted for an SEV-ES guest to disallow
+	 * the guest kernel enable debugging as otherwise a VM writing to DR7
+	 * from the #DB handler may trigger infinite loop of #DB's.
+	 */
+	vmcb->control.intercepts[INTERCEPT_DR] = 0;
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	recalc_intercepts(svm);
+
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 179952a31d3b..0271360e8fde 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -691,23 +691,20 @@ static void set_dr_intercepts(struct vcpu_svm *svm)
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
 
@@ -720,12 +717,6 @@ static void clr_dr_intercepts(struct vcpu_svm *svm)
 
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
2.39.1

