Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562346A3D87
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjB0IzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjB0Iyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:54:38 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296F0244AA;
        Mon, 27 Feb 2023 00:47:02 -0800 (PST)
Received: from BN9PR12MB5193.namprd12.prod.outlook.com (2603:10b6:408:11a::16)
 by SJ0PR12MB5437.namprd12.prod.outlook.com (2603:10b6:a03:302::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 08:45:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRcvW7Tr3ziuC+nZsE26W+JBFxKIJBmjM6Os9EXr3+oHhJMuPBODeBHRwBtVez2CwtCNqGqEBYJbTbAbA2xEMOwiEOm0utaf166Nmq9Hchw2eZtwPjKbHAPDdsYZ0gOQyvYN8iPnF5113kCypUj+r6YBHxrbDXztiwM4fd9h5u8kgKXHrtWOcas2LhK4QaYDjmpmGeoFaW7CKWGeNF8DcfR4V59bbxxgdKntPnMJB8CW57cYaGDVTaY4/ylM55pM8vbzH/ijd9+kS+VSscZdhJrKWICn75P1dErr5iOsFWtgsAwZCThZkzWUy6LUtAi6w043deERZh76Topwz03LVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0C70PocJfV/reUiwwtAtsnNB6NQdmrqStftvuewzAMM=;
 b=QLJNenXRfL93qpKLg2q7nXI3lvNwXPn0hTIpNAezu+41MCqdRNAzdqmk7UVz4R50Lh0qI+krfp+rqGZXERF9dPayo/l+W8J5HmAY/Q6urCYNHpflnT6hl+IbLFtHFPsMzw7HmYgCkxBaz1krKQg/heh/4CgbHRx8VO05AjwaORtQXsOPf16H69P5avtqV5GIt27qv7euNyNF03jCEOrXzpqZW+5pe/i0RjbyV3I/NKxHyzU1hYv57ia509YuTrYMSexzcitP6pztgnm5VGfaTuedqqQ2Ha3J5uhyGTK1BMxmhj7psDb9Ed5yqGvxsPn4t0EBFL/DaAzjo/P/nYVufQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0C70PocJfV/reUiwwtAtsnNB6NQdmrqStftvuewzAMM=;
 b=MynLOsqcSVeR5ebpBIZGZYq8VxH27jYadxpqp69EwVAdp+tHThQXX2ZoDluxbvvLAjep3nQSAutKeAHWO2wQ6SEA3YfQ4Z40ch4pXL+X21MeMynWigzh5bzspj1LelABmTuzMHzUlubY8z+pnVNrCb3ML/cKSxCu7nC6Y/4qbvA=
Received: from MW4PR04CA0301.namprd04.prod.outlook.com (2603:10b6:303:82::6)
 by BN9PR12MB5193.namprd12.prod.outlook.com (2603:10b6:408:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Mon, 27 Feb
 2023 08:42:34 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::d1) by MW4PR04CA0301.outlook.office365.com
 (2603:10b6:303:82::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28 via Frontend
 Transport; Mon, 27 Feb 2023 08:42:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.14 via Frontend Transport; Mon, 27 Feb 2023 08:42:33 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:41:49 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 04/11] KVM: SVM: add wrappers to enable/disable IRET interception
Date:   Mon, 27 Feb 2023 14:10:09 +0530
Message-ID: <20230227084016.3368-5-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
References: <20230227084016.3368-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT004:EE_|BN9PR12MB5193:EE_|SJ0PR12MB5437:EE_
X-MS-Office365-Filtering-Correlation-Id: b4acb7c8-f365-45f9-8348-08db189e924c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wq68ZNKDXJT6C7BVpVGVxkx0cShBWBd3P1KaslbIKGh8QNekxif05SDDzMjmDJvgF/atbSk/Z3NFt3jobV9okTgZL8fxnO8OHpBfdKw1G0fIrishNPHBmayil8UsYkFhuOvzX9yTd8OHSFgTBZbSvnKSIXKmU3VA13dnWdoLPleHfhyw+Uis5lJk8H4IAvqCgmC8H2Jj0ex4VPaNH4KxZnYhi/OgB5QegZ+v1fdkZFrQCFeeZCPkJku8b/PBg6D+go3U3cRULlDhJDizmJI5aKjMaD7jk8hwvlCVioYhBQxK8eaRyiKv6LIMJBSNmBizmC7SdICV973q9vDSGsYHTrnZd4lWKZv7O6usscwn/KzpbqIsNawceH+KF/qpU3+0FSZncAmGnLRL86kG11aFWXT03ZBAaH1KWnxUD247nyXQ3PnAKaH/n8wAC5wJaSbCCpEOXGQEHrnLAErmQ0zdAFycgRPY+Z4fzi0XjlaTJFyMGGJwpnoVAoXa3DQLdsM38p4pSwi6uBYDFDJJlqzJRNolJOZ10xjyp4KLbEFuYohYu6lQJPYGC8tO1BFX8Uqv3eAOvf1/L8bqWosFa/12ZyHBzYSR6dsIUrbEZp3kD+uwus/HfWfeJBjr8bxAB6jxyuoHdBecCap1QUDq4+9T1ZqKDPHSWTgW30iUKYMkuCwvUMtCtIdhHh7apLuMzj4fqE6oTs9VuJWEt66n1HjhpxspB5RK07mH9PnuM7e+9L4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(83380400001)(478600001)(110136005)(26005)(36860700001)(81166007)(54906003)(47076005)(86362001)(82310400005)(356005)(40480700001)(2616005)(82740400003)(316002)(6666004)(186003)(5660300002)(336012)(70586007)(4326008)(966005)(16526019)(426003)(7696005)(36756003)(2906002)(8936002)(40460700003)(41300700001)(44832011)(1076003)(70206006)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:42:33.9882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4acb7c8-f365-45f9-8348-08db189e924c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5193
X-OriginatorOrg: amd.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

SEV-ES guests don't use IRET interception for the detection of
an end of a NMI.

Therefore it makes sense to create a wrapper to avoid repeating
the check for the SEV-ES.

No functional change is intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
[Renamed iret intercept API of style svm_{clr,set}_iret_intercept()]
Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
---
v3:
- renamed iret_intercept API
https://lore.kernel.org/all/a5d8307b-ffe6-df62-5e22-dffd19755baa@amd.com/

 arch/x86/kvm/svm/svm.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cf6ae093ed19..da936723e8ca 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2490,16 +2490,29 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
 			       has_error_code, error_code);
 }
 
+static void svm_clr_iret_intercept(struct vcpu_svm *svm)
+{
+	if (!sev_es_guest(svm->vcpu.kvm))
+		svm_clr_intercept(svm, INTERCEPT_IRET);
+}
+
+static void svm_set_iret_intercept(struct vcpu_svm *svm)
+{
+	if (!sev_es_guest(svm->vcpu.kvm))
+		svm_set_intercept(svm, INTERCEPT_IRET);
+}
+
 static int iret_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	++vcpu->stat.nmi_window_exits;
 	svm->awaiting_iret_completion = true;
-	if (!sev_es_guest(vcpu->kvm)) {
-		svm_clr_intercept(svm, INTERCEPT_IRET);
+
+	svm_clr_iret_intercept(svm);
+	if (!sev_es_guest(vcpu->kvm))
 		svm->nmi_iret_rip = kvm_rip_read(vcpu);
-	}
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	return 1;
 }
@@ -3491,8 +3504,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 		return;
 
 	svm->nmi_masked = true;
-	if (!sev_es_guest(vcpu->kvm))
-		svm_set_intercept(svm, INTERCEPT_IRET);
+	svm_set_iret_intercept(svm);
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3632,12 +3644,10 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
 	if (masked) {
 		svm->nmi_masked = true;
-		if (!sev_es_guest(vcpu->kvm))
-			svm_set_intercept(svm, INTERCEPT_IRET);
+		svm_set_iret_intercept(svm);
 	} else {
 		svm->nmi_masked = false;
-		if (!sev_es_guest(vcpu->kvm))
-			svm_clr_intercept(svm, INTERCEPT_IRET);
+		svm_clr_iret_intercept(svm);
 	}
 }
 
-- 
2.25.1

