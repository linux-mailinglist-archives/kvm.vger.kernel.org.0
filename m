Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB1B730F92
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243772AbjFOGn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243895AbjFOGml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:42:41 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4223F2D7D;
        Wed, 14 Jun 2023 23:41:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfG2HxOj8RrI7+l71LS++518qpVnYCwgNw35tC0/Eu6SePXz+6Bfp090SVBzAKzhaeweMjJKHzqa3JpmAccaqHQx+pQl1pYTkV7JYHfB0Rdjm74m1fKV3Y1z1PuZIa/LCipLqPlPoIOWZ5rrWeLwDdpibmB+feFGIeev6l+eVUqCmId/dNTDZMVq26/hkyDeXn/VIfUgErw9P+y3iJRpZTU/ol1hL4wNb/L/XzvURZW8AoNJVNNrOoiRyM42FF7h5WIRTkDe7IERbLDiERhSMJdVgcT2ePxOM6+XsW9aLDWhmblJSgyI7OluYSPi53zY/NAvRhcz9fH3LLp7BMbc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pa3S2hiu7F5Vfcg22CIERzw2g3AZjEjHTEEf5GOdD9Q=;
 b=aPELlVCNvgLi8Oxa5I4aEdW4Hc6Xxa3x3FQklRLNWbXcYsrveV1bD9LwlrpD5JUDsRdK74DIecgvJ8jX+aI15NOBg5Wxb3wfTQb1dP9oj7P4SLzgzxdm2QexiV4dNZp6k6U8T+HWorKvGfZTnXwCDNbQNm45xUHfi3UWUuB6u+XYkE00/jXakAHYKAGnT14BWunCuSK0dqFl7MqcMCue/+MgJinZI63hw4AnQlStnRN+wXJC5EnBg0eqlr/rDIoKiZ2CSXfnR42WCIK3ZADdwV+FJU76zllx8qbwVf5yCfcpnW/wOWjFVx94Tc961nQFgBBfaRIu/KZTjV1lk2Kchg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pa3S2hiu7F5Vfcg22CIERzw2g3AZjEjHTEEf5GOdD9Q=;
 b=HJ9cARrAC7LtcOawrWV7jnH1roRdyda1XxU9esMcSQ9WePJofVwJNRP1+nQAS+PWdr9SelS/rBpnXLrYAKg0zLeHJnOCIzcxi8pMQwyaJixz2Vp+xOrmN9mqLyfEn1uC0GAsedZvNZIeXp0Yl9peb2ycVvU5XTYDFQ70B+3mT70=
Received: from SA1PR05CA0007.namprd05.prod.outlook.com (2603:10b6:806:2d2::9)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 06:41:19 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:806:2d2:cafe::69) by SA1PR05CA0007.outlook.office365.com
 (2603:10b6:806:2d2::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25 via Frontend
 Transport; Thu, 15 Jun 2023 06:41:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:41:18 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:41:14 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>
Subject: [PATCH kernel 4/9] KVM: SEV-ES: explicitly disable debug
Date:   Thu, 15 Jun 2023 16:37:52 +1000
Message-ID: <20230615063757.3039121-5-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: ec44b2ab-b057-4f9e-e05a-08db6d6b8688
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uj4x6OIojfXw5t3qiRU+kuB2mHnlmG7o/Hvn78GzMushLoC+ZFKAuSJ0+YGLW0fyz2iB9+6a/DLzy5qzkrzk3kYGXq+NEfDW1HysJ1UXjJ5o+4xPuXthwmW+6ecIQJsh+B64nwmJGIada9gaszg0IZ2pLUcghlggmxb2RG7ky2fw2hPUMymPCR4PYV8WGeBPSQS3ZsV6LSWD/vhv46q7Ej8MyPVTTS2LYRZm03dWrUrpnvlKrKPME3j5CdH7ZxnN+Wb7iOlGrjgY44WsmfHJdYEWXU1f1pcMbseC1j/GtzJ/BxWE5JJUWA8UVRJVDZAKplPLQs/0dDmbrLqVU19mw/Clev4Ls+EH2g54NK3gVjHA9Et3zichpw8TSenXltGOrhkeZCPw3EYAYR082ngMxZV87ZTFru1e8+O/YFPjbtiYKmFT+JK1icrQtt/X905KwmTCkrYhYS9nSwh+dYOQZ9uPe/gYUj8Lc/2g5vl0ZX49l8ABjFk2+lnQiqhYV8kJtifvexwpKuatoYCZUilCY5LgJJhIvxBColKdpc9s9HuBBzggBHsBAYWPhGYVlD3XBKvYoZT/TRQY2myVOOUO9NS7vqj3Weul1PWZ8A3S/yPU2c7p3hWMbqD7HM1MusP2urzJTI1fSrt28MniTNj6KiKEU8lVWBW7hhh6tznIlpmUIQIza6QgDlxMqk/q7EWbkUj4AsuLACCWGTGNfBkmZvDTC0B1XtuwzZb0elyDqm+4yWDq1UVBADDq7PbzKO9K7tAFh3AtuRXOQ7fiR6j0qA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199021)(36840700001)(40470700004)(46966006)(82740400003)(356005)(81166007)(40460700003)(40480700001)(478600001)(6666004)(54906003)(316002)(41300700001)(5660300002)(8936002)(8676002)(6916009)(70586007)(2906002)(70206006)(4326008)(47076005)(426003)(83380400001)(82310400005)(36860700001)(336012)(16526019)(26005)(186003)(1076003)(2616005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:41:18.8008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec44b2ab-b057-4f9e-e05a-08db6d6b8688
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
- return an error right away from the KVM_SEV_LAUNCH_UPDATE_VMSA handler
if debugging was already enabled.
KVM_SET_GUEST_DEBUG are failing already after KVM_SEV_LAUNCH_UPDATE_VMSA
is finished due to vcpu->arch.guest_state_protected set to true.

Add WARN_ON to kvm_x86::sync_dirty_debug_regs() (saves guest DRs on
guest exit) to signify that SEV-ES won't hit that path.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v6:
* fail in LAUNCH_UPDATE_VMSA instead of clearing the flag
* pr_warn_ratelimited -> pr_warn_once
* due to the rework, removed Tom's "rb"

v5:
* new in the series
---
 arch/x86/kvm/svm/sev.c | 5 +++++
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 36fe2fcb4698..981286359b72 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -619,6 +619,11 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
 
+	if (vcpu->guest_debug) {
+		pr_warn_once("KVM_SET_GUEST_DEBUG for SEV-ES guest is not supported");
+		return -EINVAL;
+	}
+
 	/* Perform some pre-encryption checks against the VMSA */
 	ret = sev_es_sync_vmsa(svm);
 	if (ret)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9c1b191aed4b..bec6fb82f494 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1996,7 +1996,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (vcpu->arch.guest_state_protected)
+	if (WARN_ON_ONCE(sev_es_guest(vcpu->kvm)))
 		return;
 
 	get_debugreg(vcpu->arch.db[0], 0);
@@ -2727,6 +2727,13 @@ static int dr_interception(struct kvm_vcpu *vcpu)
 	unsigned long val;
 	int err = 0;
 
+	/*
+	 * SEV-ES intercepts DR7 only to disable guest debugging and the guest issues a VMGEXIT
+	 * for DR7 write only. KVM cannot change DR7 (always swapped as type 'A') so return early.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		return 1;
+
 	if (vcpu->guest_debug == 0) {
 		/*
 		 * No more DR vmexits; force a reload of the debug registers
-- 
2.40.1

