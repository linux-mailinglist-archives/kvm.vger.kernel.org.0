Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205756DDB58
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjDKM6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 08:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDKM6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 08:58:52 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FD240C5;
        Tue, 11 Apr 2023 05:58:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qxab7iNme55cD0WZn4XrHYjuwROodxkE3B7QASuqnrYJLGolTD0333MCQOCXurarXZS/dJkUHyO/4KGGTZJgOBHJizRwhf6BSfsCyFHM3Ry7OPxWQycuh5oYqokO8sW6dDNgsSRtjNgo5gbDrTM+8EBqkwJc7o31Zc00eB0p6yZscfzZnZWzCjzaSZzQYUxNXd1/cn845mAtRiR8KoPcQPfPeXbsTfNZ1BCNV7QX0T/3Cu8EuCgsBHJRQRewGZfJUydToPyRuVEejsvT2vfFB+A71F+4dIv4QLwZS+Bn6jCcMAjMaL4TUnRi8z3CRcFnkhnQWQgNi6HOjoJ4/1Je7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLk7VBPfze9OJx6BGagdTGqDhaqyBjbltGGUNS6/MsA=;
 b=djLQi6vfAsCKL7+a/YAD7k1jSYbQ3V7xEfN9/zFrObRJmn+bl4ruvEz299fs8gk2rbLG/b6r/ydnj7GUUyew6+sWtcw5nNHta5jIj91UzF5SBXIji16bGhqPdk0e4xqvUyG+auWJ/3ZXHZfXidoXSjHQp8hUhJomZW2yJKuOm0q1clC4gzmhA5RRn51dCvfMF20/dAZsoDwQSiU/Dco0TqQCfVEsXPjXiRPyvPQ/gTlQzbMgQT4QM7ct9U0O0+M4QMrcFhcO4Jdk4xRIqQoh+1DSXjGw9SNtTsELZAO3FD+RfiEI/KmLbi8q3Z4vbOX5GipuIp/AR2ZFDBL+iDAMSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLk7VBPfze9OJx6BGagdTGqDhaqyBjbltGGUNS6/MsA=;
 b=Z8oOm9AypWkW6ENNjUSpoMBUcs5Qw2jMxXLCM2+buIpSEadxV02kPpbg030vvhkiZXCKPTU9Pc2sOgGtoBc9VHVBt+N2vqx4Or213Ug2Tjz9sdXuATAJd2GstjQkt2vfxT6l+IDV0/ifaqgcjHc/rwTSD9GRyxQ1msAF1cSO77Q=
Received: from MW4PR03CA0341.namprd03.prod.outlook.com (2603:10b6:303:dc::16)
 by SN7PR12MB6958.namprd12.prod.outlook.com (2603:10b6:806:262::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 12:58:40 +0000
Received: from CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::fe) by MW4PR03CA0341.outlook.office365.com
 (2603:10b6:303:dc::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28 via Frontend
 Transport; Tue, 11 Apr 2023 12:58:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT089.mail.protection.outlook.com (10.13.175.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:58:39 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:58:34 -0500
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
Subject: [PATCH kernel v5 3/6] KVM: SEV-ES: explicitly disable debug
Date:   Tue, 11 Apr 2023 22:57:15 +1000
Message-ID: <20230411125718.2297768-4-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT089:EE_|SN7PR12MB6958:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd2c18b-18c5-4892-ba83-08db3a8c78de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RHRR3y3cOVO73s88rZrkj68VRDRN6uzpwVsDTkkz2M9bKyerqIZte3xA5co1LPzOL7SgfvVbYO762NASmqvpMKOCAuuqIkj5IxB0ladY+TchiFTAfPjirZJNo5WwjEyaeoD/SBQCnemQsa3Jr4XHwYDMOb/XXNEZatlSVsmcSoOdwEq/pWaIpMMXrgvq3+9qwx2Ac1hlarNIk18CWnsPpqECvScKNaV185h3TIHVhY3Qln+B2cXdSASCs3DJuVuItWi546uKww4T/zLm52KxOc1s93n8JgC/so2b1sFwZYr1dgNZAWdCq8CqR3cDFnZ6neXVJ3CFNUVKC09v485GIltbDV2Tx06d/GUBJOh/TSyrGUsKgiMCUaI+nAR6mhXe48WV/kxhj0Spr1cWgvEZ7upa0pzs1z5/Pw5pb8+66JOHtoRcmyzQcKCBbZgPKBaJOwBFq4CShvj/TEh6/de7K3N2+A7EyKBKBBKKJdC5UUBq0zTj0RXTEuI6Z+be+msE5QB+nf8Jje/t7lB5eutqzU9nIhgE5PfaPsNRxqNkHemQZAzxGJNcIqN7fennWR96pYgeABp8zCvOWewdrFEOAUn2gIsPx50y3UXroUrHdT/1052rrVOAd9ur2ISJOT8elswkvkM03bEN0mdlp3gECz+Bk4QPMjWXt0q9ciULJVuMf6nOmNBGZ+4zcIwwrW9XfeIHUe+Ec3VHdK3l9kt4rl/R6Q1wD8Pojg7+ehzZeC0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(8936002)(336012)(426003)(6666004)(5660300002)(36860700001)(41300700001)(82310400005)(478600001)(54906003)(36756003)(70206006)(70586007)(8676002)(6916009)(4326008)(83380400001)(316002)(40480700001)(47076005)(186003)(16526019)(2906002)(356005)(81166007)(2616005)(1076003)(26005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:58:39.9346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd2c18b-18c5-4892-ba83-08db3a8c78de
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6958
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVM/SEV enable debug registers intercepts to skip swapping DRs
on entering/exiting the guest. When the guest is in control of
debug registers (vcpu->guest_debug == 0), there is an optimisation to
reduce the number of context switches: intercepts are cleared and
the KVM_DEBUGREG_WONT_EXIT flag is set to tell KVM to do swapping
on guest enter/exit.

The same code also executes for SEV-ES, however it has no effect as
- it always takes (vcpu->guest_debug == 0) branch;
- KVM_DEBUGREG_WONT_EXIT is set but DR7 intercept is not cleared;
- vcpu_enter_guest() writes DRs but VMRUN for SEV-ES swaps them
with the values from _encrypted_ VMSA.

Be explicit about SEV-ES not supporting debug:
- return right away from dr_interception() and skip unnecessary processing;
- clear vcpu->guest_debug at SEV-ES' LAUNCH_UPDATE_VMSA if debugging
was already enabled; after that point the generic x86's
KVM_SET_GUEST_DEBUG ioctl disallows enabling debug.

Add WARN_ON to kvm_x86::sync_dirty_debug_regs() (saves guest DRs on
guest exit) to signify that SEV-ES won't hit that path.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
Changes:
v5:
* new in the series
---
 arch/x86/kvm/svm/sev.c |  6 ++++++
 arch/x86/kvm/svm/svm.c | 10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0f4761a57d86..b4365622222b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -639,6 +639,12 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	  return ret;
 
 	vcpu->arch.guest_state_protected = true;
+
+	if (vcpu->guest_debug)
+		pr_warn_ratelimited("guest_debug (%lx) not supported for SEV-ES",
+				    vcpu->guest_debug);
+	vcpu->guest_debug = 0;
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dc12de325cca..179952a31d3b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1980,7 +1980,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (vcpu->arch.guest_state_protected)
+	if (WARN_ON_ONCE(sev_es_guest(vcpu->kvm)))
 		return;
 
 	get_debugreg(vcpu->arch.db[0], 0);
@@ -2698,6 +2698,14 @@ static int dr_interception(struct kvm_vcpu *vcpu)
 	unsigned long val;
 	int err = 0;
 
+	/*
+	 * SEV-ES intercepts DR7 only to disable guest debugging
+	 * and the guest issues a VMGEXIT for DR7 write only. KVM cannot
+	 * change DR7 (always swapped as type 'A') so return early.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		return 1;
+
 	if (vcpu->guest_debug == 0) {
 		/*
 		 * No more DR vmexits; force a reload of the debug registers
-- 
2.39.1

