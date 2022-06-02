Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C91E53BAAE
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 16:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiFBO1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 10:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbiFBO1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 10:27:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD07DFF4C;
        Thu,  2 Jun 2022 07:27:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgbOBmKkzvlTEwI043jTrxFgwI3M/4NtI1cOsiCLC6iRaknecHPUsrAefqEDH6fArBAGqFAwd8W/sqwUaE/MF4WcpkYEwwf7NrPnqj9c7WbawcRKmuS+TqgPVOlcCO435WXfqUexqQgPIf4IROAuUvyhWM64MbHkNwEdJ1MkH9mDiGfqFGCC++kvnYiq+1zShse0h1FixnIWoPtYKNHXuohU5XAKPOuZkob5FyjSt+EYC141e+5pOqSB4Sfwlu/0Anj+NTAE14dyZGyZAFoJlqQD9dvUdG5JK17UmmnONLKLnNOUwga1ABg+xZdy5UmWI0bklikUuPzT9JK2S78lMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SGjK0lYQ5r5zdEw1lFFLxAt1rgcslKLijmP8URQtT+8=;
 b=flTUS+WqTHshbW98sLwmPRvMMri8oyD0OhH7vhJVP8RMd016N8C+xyu2j4BHc5NQwNCPOvcCQ8Hs+0cnHpVOb3mrzTWHXpqHIYsQ7dtzkeokRzMvp3dww+DDSvn/mudf6UNCKAcTcQESQirOQjipsHNTsJx9KCl5+tBrjcYO4qmwEy8MLEYQBBbkFS7FfYj3kLzWXCLL9rLKrOUPi6Zrl230LKWzON/dSp/1E711cwNDtyaHa6yjcZsUKjgIC3lgaMswgqVUWAsJZvxXzM6paZu2/B3hoh0pOVa10uIm4CW0TDl123kCiTMrn12MP5vCXxDr/06tvpIgilG6zfcauw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGjK0lYQ5r5zdEw1lFFLxAt1rgcslKLijmP8URQtT+8=;
 b=ccgx4Va105WkNGurDoxJWFjpQRAIH62Vg5FbEA7wAmeq+psILjUUZXJTrS6iL/5sHhoK9b1ifzR5qoA/CMfKghcBIR473mrpUyMatx4tcHgJuZa+tMk+GzOo24gu1V0RYsa8jPyhvTpY0aF/XDkag6aTOFAd9EosN4JieVj19jU=
Received: from BN9PR03CA0549.namprd03.prod.outlook.com (2603:10b6:408:138::14)
 by MN2PR12MB3839.namprd12.prod.outlook.com (2603:10b6:208:168::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 14:27:27 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::fc) by BN9PR03CA0549.outlook.office365.com
 (2603:10b6:408:138::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Thu, 2 Jun 2022 14:27:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 14:27:27 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 2 Jun
 2022 09:27:23 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCH 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
Date:   Thu, 2 Jun 2022 19:56:16 +0530
Message-ID: <20220602142620.3196-4-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602142620.3196-1-santosh.shukla@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5104c35c-4424-4c02-88b9-08da44a404db
X-MS-TrafficTypeDiagnostic: MN2PR12MB3839:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB38391A1738AE8BF2B1B4404E87DE9@MN2PR12MB3839.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WP7ctwBHe62lM+WOEXzsYvYOc1jgEqQGKnOT6j7BxUi8/ZKy457WikxEnzOHuvKtqm4UOFDqUHpzf4wwOPOB1V7c2T08GI2D6EL7PzhQ/KGC9g+79lzdt5q4xdlgRvwhWDWiO/+crCwc8XTXJvwot/8sG0qQDFMDaN9OTdV4QV6nJ+1bGZ/62fo8yIxy5POAa93nJlWXuB+QWDsqQ4ziQtmR8HJIgj/KJ2HV4HOLVN7jR6bxFVfOlCkCOD0gCm4YvLZ4i4kWbG0kR7Y8ETSam9EW+/Nnrzpsw78zLB8O3adyK8F1a/0kmlgk1jEkC5J73fpexXRxdlvcZADzChyp6JpX1QyhLXUheff0ZlkT9go2Ld+pk05gBZf5EZG8Bj/5R+ATNxKp+qgGonyVUvMfpftK880uViJDt2oBRKuBT0ZQvcZM0fuy0biln7e/clYkMJCopkdPwNyz21ltmJfcEeRobLhwBtaUHKuXJtgsNpjIALEmDyR9kSJXEaktKZnzhP5FyV8jrFXzJdrrUyvNYV3Ll67fiRYS/xwuMywbcYzmLTDAvTj+FinwU+bLo0JB2yZz9WS+yqdY0n5MRLrDoB7hdbrI/0U6BRdNN6MQ6vfpyeinjDVDE03V1Ev/dxap0xKMtneiieYtqMxhOd5VMVP/vEkBJrg2diVNNzB2dfp1q2nT/B1HrT7KD7eVG5EFp7jgTbCc5uwXDZwo93MJ+A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(508600001)(8936002)(16526019)(336012)(47076005)(1076003)(186003)(40460700003)(2616005)(83380400001)(6666004)(5660300002)(2906002)(26005)(7696005)(86362001)(4326008)(8676002)(316002)(44832011)(36756003)(6916009)(426003)(82310400005)(54906003)(70206006)(70586007)(36860700001)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 14:27:27.2543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5104c35c-4424-4c02-88b9-08da44a404db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3839
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
read-only in the hypervisor and do not populate set accessors.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/kvm/svm/svm.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 860f28c668bd..d67a54517d95 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -323,6 +323,16 @@ static int is_external_interrupt(u32 info)
 	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
 }
 
+static bool is_vnmi_enabled(struct vmcb *vmcb)
+{
+	return vnmi && (vmcb->control.int_ctl & V_NMI_ENABLE);
+}
+
+static bool is_vnmi_mask_set(struct vmcb *vmcb)
+{
+	return !!(vmcb->control.int_ctl & V_NMI_MASK);
+}
+
 static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3502,13 +3512,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
 {
-	return !!(vcpu->arch.hflags & HF_NMI_MASK);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (is_vnmi_enabled(svm->vmcb))
+		return is_vnmi_mask_set(svm->vmcb);
+	else
+		return !!(vcpu->arch.hflags & HF_NMI_MASK);
 }
 
 static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_vnmi_enabled(svm->vmcb))
+		return;
+
 	if (masked) {
 		vcpu->arch.hflags |= HF_NMI_MASK;
 		if (!sev_es_guest(vcpu->kvm))
-- 
2.25.1

