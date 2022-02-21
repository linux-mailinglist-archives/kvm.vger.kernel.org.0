Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6556C4BD3BD
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343581AbiBUCXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343561AbiBUCXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405CB3C703;
        Sun, 20 Feb 2022 18:22:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcnBvW5TOzIfTYZ+5Gsbvx8DR2Ce68SztttC86CUgy6G/H4umRiR3PwBUZhUkxzpDiRkyjfzCCD69msY4FPBp6l+C2PFaRrB9Px9r9mPl1Nu6622KEWpLPvUWd6+V8N67YZ4CcEW1hhIrJizFJ2zY8X2lhOkLHy5bD5DsdDu4O015fTT9bvE2dSmJ4SKI8v5kAByl99jZu1EbCLFJCD3SuON8XaxkCtt2KTtQ6z7iXjIsRY7aMgOrpfQP0uQP8ju7VAk4LQlULtxuuVkHifXZVYBEn7sDhe7zOvMyX/uwqLl/851MJbD+pftxypOKujlZaxBwmUIW1vZIj1YApruXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOq6CV93GWY9eeKh8+zFPyDm4o7+7giUHyWGFi6luwI=;
 b=VFyzSCCVvP/3+Xc+rK8sGjgfFqBV5TLkqGKEKtw5AMmpzf36fENzQ263gVuLi9soDEHSStTqeXcchR48qFxr3A2sbte2N7aXBBEh61mTtzM6qt8fzS/gC1Tmh6paXrrNZFYxesuTvaU8HbVRKhE72SzUAiW2ymj8tA0Fa2vyNACgVouP9IlOpFt4bb34X0vVhsjI/myvs6khfTU4FSN5adhkpH/AomzWDOiZt8yc68JMcGiKKPRYWqJOknCIE9S7UKWCsXT4KvZTnYyVxB82CqGyIrQSHQrAIdpRQS++yq/OY38Tg1suherMYzQ3nNjQBvi/V7eewiDib/rFRSoldw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOq6CV93GWY9eeKh8+zFPyDm4o7+7giUHyWGFi6luwI=;
 b=eLzjbf0HVECK+Z6hKv516H0ZSMsBgLp0cMXN6mlT9A2uEzvrHp+mUIS5OPoT4homKFTpBm03GmjpKCvQgNXRbtY9DKHfEtcZSSavustjMofTGdbXzeIZF1FB7vfhulmSAS+QQilq0r94PB7uCxvUx3+41aOJrd0qk6TIiI5Yru0=
Received: from MWHPR1401CA0008.namprd14.prod.outlook.com
 (2603:10b6:301:4b::18) by BN6PR12MB1123.namprd12.prod.outlook.com
 (2603:10b6:404:1b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 02:22:48 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::60) by MWHPR1401CA0008.outlook.office365.com
 (2603:10b6:301:4b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.20 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:47 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:44 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 04/13] KVM: SVM: Only call vcpu_(un)blocking when AVIC is enabled.
Date:   Sun, 20 Feb 2022 20:19:13 -0600
Message-ID: <20220221021922.733373-5-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fbf5c96-3da4-4ece-ebf8-08d9f4e10d5a
X-MS-TrafficTypeDiagnostic: BN6PR12MB1123:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB11238905B804F16DB37573C6F33A9@BN6PR12MB1123.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4bC2BxuaAiGicYjE4mEJZfNnLNFU0lhQaNQP6xFu2wQNs+ON0ZCNyh1SPI91hJ+A2JKz6haW+A5ZiY1Kmz6iO8c5av3GJBhqF/zc0qJ26joZ4rZBPNKmpf9i8eKovXmnFL3MCsfD8hGEDP7HD+VHosJbg2L0mq1o2IgjbssFafQUKEJ2ielRg1miseGkK23EYSVxHkwjvWNPyo7/6Vez5R9NFriZBuL3J61Xl68M3dIHZlz7GVb4IXSrmgbyOiXO1WA+YlBr1oDWYeAmIl9E/jQNWNX7nw53N1LoqzBnge6FFmaoktslahsoe8pd1LlBKGKC7kNlWawEki43xdRWUjUNiP3kgdEPME9cDa59CuGKAr5T6T+wJ+ZxXbDakQ/atP85WgogmYA+++svzQeORm0K2GZ3C/H0F935LXc/98fTnD9P+r8jo2/5WfRcYXJBbtyi5Gtvw+hUSjgkHkS6oM17fqMG47CgyT0CqsKMaTPjCk7LV/GPIIsDYySzEPUq88KsOzpVkpwFADja8CRoPp8E8jOpU4/A+PsosCC2o7OQgBG2fP5IjrbC4zN9qfBVSqSs66Ar9OGttx9Yxxxu3qHUHi//JxscnB5b6nZW+fWGQersygzfGf6M0OhdN+Xg4EDqllIM4FAvJeE9yi4LZiSMOuXibpc4rijaPgOwKiigK1keBjJaHdFlTAcc6locv2I+3eeUHMN1xODhylrO7H1nv8zrmfKGQuVCwCM8oiSwfG20DAYVCig42jzh9/sl
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(508600001)(356005)(1076003)(54906003)(110136005)(40460700003)(83380400001)(2906002)(82310400004)(8936002)(86362001)(316002)(5660300002)(44832011)(2616005)(81166007)(36756003)(70586007)(336012)(426003)(70206006)(8676002)(186003)(16526019)(7696005)(36860700001)(4326008)(26005)(6666004)(47076005)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:47.6642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fbf5c96-3da4-4ece-ebf8-08d9f4e10d5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1123
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_x86_ops.vcpu_(un)blocking are needed by AVIC only.
Therefore, set the ops only when AVIC is enabled.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 12 ++++++++++--
 arch/x86/kvm/svm/svm.c  |  7 -------
 arch/x86/kvm/svm/svm.h  |  2 --
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index abde08ca23ab..0040824e4376 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -996,7 +996,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
+static void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
@@ -1021,7 +1021,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
+static void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
 	int cpu;
 
@@ -1057,6 +1057,14 @@ bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
 		pr_info("x2AVIC enabled\n");
 	}
 
+	if (avic_mode) {
+		x86_ops->vcpu_blocking = avic_vcpu_blocking;
+		x86_ops->vcpu_unblocking = avic_vcpu_unblocking;
+	} else {
+		x86_ops->vcpu_blocking = NULL;
+		x86_ops->vcpu_unblocking = NULL;
+	}
+
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 	return !!avic_mode;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3048f4b758d6..3687026f2859 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4531,8 +4531,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.prepare_guest_switch = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
-	.vcpu_blocking = avic_vcpu_blocking,
-	.vcpu_unblocking = avic_vcpu_unblocking,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
@@ -4819,11 +4817,6 @@ static __init int svm_hardware_setup(void)
 
 	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
 
-	if (!enable_apicv) {
-		svm_x86_ops.vcpu_blocking = NULL;
-		svm_x86_ops.vcpu_unblocking = NULL;
-	}
-
 	if (vls) {
 		if (!npt_enabled ||
 		    !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b53c83a44ec2..1a0bf6b853df 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -578,8 +578,6 @@ void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
-void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
-void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
 
 /* sev.c */
-- 
2.25.1

