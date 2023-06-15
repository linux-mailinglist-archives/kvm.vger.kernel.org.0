Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F812730F8D
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244185AbjFOGmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243772AbjFOGl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:41:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A5C295A;
        Wed, 14 Jun 2023 23:40:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XA4f2b3IA47RyNUyfovZa7F5Tak/AnPb6N46+OQaBpKplCqrKRE+Y9ep4lb4+c+7hC00B1JgUm9F1Dwv8xklTgLqb9BM5QSg81aqsrQXyGdPGchkPBUg+EYc/iohX5L6owY+8xzObeql4xiUm7QuGEhZiwIMpD/cvxN2BR9f9ZQhFsWuCDYT999pLU3JOtfjMLBs4mb8byuuKe0s7nNon/M2WtWxjuSKsFvz/OJZL4FuB5NIxnXvFw3cTVxTsCGTPqaWeScAs59WubZYhqG3lY6EClXn/zujYz/9qFQ2XtBiwOrqK/8Pqb4Ck7Nf7dckwK5HK6DgybqwzBaNLtj1GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kg9ib5I2Q/AaylL0JdrHW3hj8l/+c1ryN29MYDwuu90=;
 b=bMgfxZVm8GDBgnXpRZlDPtnGvGNE6WiKx1Xse07O3RQna6PEMM53CdJ35Yqnn/qpEHqR8d9fPXmwSMG1FhUJDAAfOeGNmvsx9n6eRpIVP9oAXy9HcNQlxARtWGyMrSILglKdtGAOWxYjOY5lZOsNE96uptv//EMgKsEpImJjkGukS4bHsF9l6+ggEKgMnlaoTkd3Rn3bQ7Z4I4nfpSZ3IdnET3v950QRrSU0x7gR/nF0BeMCw0Muua0L/4kAh8KYw0s/peJBcmZkMAWvWSdGRBNaWlMfBdvEjf7in6tFcq3M9fadlvUbMG/V+7XL5j6ox1JcEf8QPSD9Q/2PQ/Z/lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kg9ib5I2Q/AaylL0JdrHW3hj8l/+c1ryN29MYDwuu90=;
 b=3dvlK/6KwfIPaA0iJREn3QU2T7ElqbHvS2GVkRbcXwipl1ccOwHwgm/FHIPzpk1oNSzQiZ3yVSS4Cf/hXPtwyCmUsv/F4NU86K++CxyB072QCYAfgHkQw0tpfELVIa1cxab+1jMblPmpyEY3+fuEnxVUp0gMpFbgL1oGEcRlqgs=
Received: from SN7PR04CA0221.namprd04.prod.outlook.com (2603:10b6:806:127::16)
 by IA1PR12MB8587.namprd12.prod.outlook.com (2603:10b6:208:450::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 06:40:26 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:806:127:cafe::c1) by SN7PR04CA0221.outlook.office365.com
 (2603:10b6:806:127::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25 via Frontend
 Transport; Thu, 15 Jun 2023 06:40:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:40:25 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:39:44 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        "Santosh Shukla" <santosh.shukla@amd.com>
Subject: [PATCH kernel 2/9] KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
Date:   Thu, 15 Jun 2023 16:37:50 +1000
Message-ID: <20230615063757.3039121-3-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|IA1PR12MB8587:EE_
X-MS-Office365-Filtering-Correlation-Id: 08c00c44-2178-4d7c-6c06-08db6d6b66d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DERoq9eeBEF0iybZ1GP1zQW+Jji0EWcvqqegcwSdxNXl5h8wN2XjWKgQxjEk6xV2N4XOVfeQJk8aY+n6QBsAdEled77iivoZLXaUTxHKdCe451TZBA5qQQ8AWEg06iIyFCUxIoI7GX/cem4kJ/3+BXaQy4S0uMq083dWTSBfoFPNPff8QGm/MwFGPPekjQzhbo5k1uwz1NTQ4w+TeTlykqtSRrlQU0QQU6cH+oWolD9/8lmvgxKu2Cl8S4F7xgHU5FHptncDAUjGtQfSmNkt5yEa2hSVDqRbnGhaUBvxciyIEfFOfuqSvLfqu8KYBwH347A6F04Vm7j13pK2rHRB8rfVKz54EN+w4LR0gghwxze+nCAKNbGOhBLzgHsetQ2kXLuYwP/37K+RSnanCPD4Dd520WPatqg6a/G/rWD4lCzF1ei9jgxLRM83lH+XXMN0l7MZa/k1fCRqZKkFiyLheM4JOXsM7DTblh5oRYmtOtvrHr4NRRCU5eryzoUl2SICODIQprBEbajnJVnGBvcwYhOzVlWBhjaksL0Eo5a6fcgKE4goyf58U5vjfYvB1tbhDdpy7C4L4lCiJP0035czKBY0/noNJuojnYqBnUpEO+mJJVzqKdDuaID0SkQ7Y7/h1+P3i37KiC5oRdcvtUto61PflrnmrBLo8q3V8pnjZJE9WKXsCIrlZsmpSqSXdpspz75SjJiYG62RDPRthigr/6QkpJZkBzxivJGWZb8WCJDnEzONhf5aZzrQHteu4OGWkHIb62r1mg3qvuFE+9AOgA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199021)(46966006)(40470700004)(36840700001)(8676002)(8936002)(2906002)(82310400005)(82740400003)(5660300002)(70586007)(316002)(70206006)(6916009)(356005)(81166007)(4326008)(41300700001)(36860700001)(47076005)(83380400001)(2616005)(54906003)(426003)(336012)(36756003)(16526019)(186003)(478600001)(1076003)(26005)(40480700001)(6666004)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:40:25.6361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c00c44-2178-4d7c-6c06-08db6d6b66d1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8587
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently SVM setup is done sequentially in
init_vmcb() -> sev_init_vmcb() -> sev_es_init_vmcb() and tries
keeping SVM/SEV/SEV-ES bits separated. One of the exceptions
is #GP intercept which init_vmcb() skips setting for SEV guests and
then sev_es_init_vmcb() needlessly clears it.

Remove the SEV check from init_vmcb(). Clear the #GP intercept in
sev_init_vmcb(). SEV-ES will use the SEV setting.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Santosh Shukla <santosh.shukla@amd.com>
---
Changes:
v5:
* new in the series
---
 arch/x86/kvm/svm/sev.c | 9 ++++++---
 arch/x86/kvm/svm/svm.c | 5 ++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 69ae5e1b3120..c03bd063aecf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2971,9 +2971,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, TRAP_CR4_WRITE);
 	svm_set_intercept(svm, TRAP_CR8_WRITE);
 
-	/* No support for enable_vmware_backdoor */
-	clr_exception_intercept(svm, GP_VECTOR);
-
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
@@ -2999,6 +2996,12 @@ void sev_init_vmcb(struct vcpu_svm *svm)
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
 	clr_exception_intercept(svm, UD_VECTOR);
 
+	/*
+	 * Don't intercept #GP for SEV guests, e.g. for the VMware backdoor, as
+	 * KVM can't decrypt guest memory to decode the faulting instruction.
+	 */
+	clr_exception_intercept(svm, GP_VECTOR);
+
 	if (sev_es_guest(svm->vcpu.kvm))
 		sev_es_init_vmcb(svm);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 980faf460bfe..9c1b191aed4b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1256,10 +1256,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
 	 * We intercept those #GP and allow access to them anyway
-	 * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
-	 * decrypt guest memory to decode the faulting instruction.
+	 * as VMware does.
 	 */
-	if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
+	if (enable_vmware_backdoor)
 		set_exception_intercept(svm, GP_VECTOR);
 
 	svm_set_intercept(svm, INTERCEPT_INTR);
-- 
2.40.1

