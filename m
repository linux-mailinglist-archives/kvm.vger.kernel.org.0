Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975D960F2B0
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbiJ0Ilk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiJ0Ilf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:41:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D828D01A6;
        Thu, 27 Oct 2022 01:41:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZO3ttGNYKy6lduUyhvm9HssyoBPp/YxET6tevSU0hsDJvPassk1GeUvCAUQDejzfBZ6K6TfK7TwueZpxAb9IWlJ43zrvV7sPNLD8ry3Qb683Wvf/Jcc79EdLvg/OTi9VOdv2PZesLfEGhdJxSoe/Tsr5F9Nw2N1Yk3U2Y2P0rus/88Fg03ay/HDoCTrZa6uuUfQVXsDEwPP/VCyUKO/U+pTBcJRVIQlvAY5jNS/wtfvNkEBEhFOr+DQ2IYydprrVjuD/4/azVDQAO/CwsWORT+zk/ErBce2cBKlkhWpO2ESLmhUB5UF39PDcg1B1mC5Mpb//tQ3AvMTFkrIrDcyeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFYHKtCd08W6bwSa2x1KlSLxbgAkmkohddJBjn5kOVo=;
 b=guk31Wsif0H1EcEh9a766vNYfuq5t2VSzLMvu+524PMXS/7rDwCFd91bJgmr/88P3fKCVw8PX9HHauiSDhnLJCoyD545ytqamW0wuxE8W2E87VrvKIOnYUnZSSMjPQrws6HeAmwOWchD20O5zdbNC9y4t7y1wI1fYGv+jLCj54EGcCGTNPjlvu87cUhPGCk9Vc/ojbHVdzrrOO+YoUxV/yYu9WjWAGmq7zc0h/9DiWr4sAEwluDjXyz1gopTj/oYn6dGZ1pHSV203fPm5LbAZ6+8HkCJyWp+lkrc1mN2BEZlBIttNmT+YEIslPcl6kkVCW0b9AWFjSfV30t9ci+Cgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFYHKtCd08W6bwSa2x1KlSLxbgAkmkohddJBjn5kOVo=;
 b=Lwxnzyieh/hJdd1ycY71xT7uAYpXBuYDbZdyYgIVGHZWSFIl73GrDmYv05v+JBO+8YR7GTZtGYQnzf6nQuMxEF7a9DdUU7KG0LL1sOpJSI71OzPLkj/jaBCmrNldwu10M2qrfbb5PJdqAu3kuNynFRU7SMfnd6VUejWsbOjBJNc=
Received: from BN7PR02CA0033.namprd02.prod.outlook.com (2603:10b6:408:20::46)
 by CY5PR12MB6346.namprd12.prod.outlook.com (2603:10b6:930:21::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Thu, 27 Oct
 2022 08:41:32 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::7e) by BN7PR02CA0033.outlook.office365.com
 (2603:10b6:408:20::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Thu, 27 Oct 2022 08:41:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 27 Oct 2022 08:41:31 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 03:41:05 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv5 4/8] KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
Date:   Thu, 27 Oct 2022 14:08:27 +0530
Message-ID: <20221027083831.2985-5-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027083831.2985-1-santosh.shukla@amd.com>
References: <20221027083831.2985-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT067:EE_|CY5PR12MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: 4362422d-6e7b-4434-460f-08dab7f70c29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mAoqoDJeRawAacO7aCPm4W86zxxvJxhQsMBr2KSIunnsyZX+dORCpu1gnhagsuvk0iczMcSrbXxmD1Bx0BiBHJJJ3ILkemekRM4LcYmJN+mfrqb9jSiWQXkqA2ib+cAV+STnzMbxkM8A5RjsqrmvJQK0wfDST7m5m8r8uwmFfC3WI5LB8Vh+CN6n34n269uDaUIa6xRepWv4JzRHBBfOXxr7+5jO8bDudwU+ydy/oBlAbFeFdrQBOCOxIOc6Jb+cAkPUfFqScHmuCH2D4Qb2eJ58b1KtqFch2qiY/YVgnBe60ru+mqil0NC5U0SDtV2GKzxzYYlDoDV1Xx+L/wfQqRzqtIIJhL5/NQzEBd9Kv5ttljaZOhvgYsDC+DOC/XySJQu5wOSCyubKDhhmKBP7oo8GlACgGlKsvtFsXg8LWwHPAJ/BATdwjUQjrx8j/Am+n0wWPg5mJNhgwE7K+D9D2sakxPCekN93g5GDf4Q1kITbjpN6Vz3itzD5hX5ziINFEEY8aDqnWolYqOsuKQFxkvW3yVRE0LNvYWtCwa/c2tJm3KA7Yq5wRLlXWczcaSfwAKYTxs6lMfAqgyo6f5jo3l7/894ZmqSVeiJf0lH1EHsOxbFdWAfp7xw+cYfPgtPnbInuCm+rNBZvbYMHW7r/+DW//Fbejc0uiFy8Clnl4IOFhSmknpZVhZzpHUTtxmS3eB7LQhY7dOGt2w8bRLDExOHkExA/uwyvQy+R/uX/ddnyYFlDqTy/b8PCNQPevV2wB836kixrpeCWPGnMf8AsVB5QfWo8zoIAzCVOvvTF0Wk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(82740400003)(47076005)(36860700001)(336012)(44832011)(40460700003)(7696005)(2906002)(86362001)(356005)(2616005)(16526019)(186003)(81166007)(83380400001)(426003)(70586007)(8676002)(6666004)(40480700001)(5660300002)(54906003)(26005)(70206006)(316002)(1076003)(4326008)(8936002)(41300700001)(110136005)(478600001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:41:31.4714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4362422d-6e7b-4434-460f-08dab7f70c29
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6346
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the VNMI case, Report NMI is not allowed when V_NMI_PENDING is set
which mean virtual NMI already pended for Guest to process while
the Guest is busy handling the current virtual NMI. The Guest
will first finish handling the current virtual NMI and then it will
take the pended event w/o vmexit.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v3:
- Added is_vnmi_pending_set API so to check the vnmi pending state.
- Replaced is_vnmi_mask_set check with is_vnmi_pending_set.

v2:
- Moved vnmi check after is_guest_mode() in func _nmi_blocked().
- Removed is_vnmi_mask_set check from _enable_nmi_window().
as it was a redundent check.

 arch/x86/kvm/svm/svm.c |  6 ++++++
 arch/x86/kvm/svm/svm.h | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cb2eb5581d71..38fa51e0b70f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3597,6 +3597,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
+	if (is_vnmi_enabled(svm) && is_vnmi_pending_set(svm))
+		return true;
+
 	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
 	      (vcpu->arch.hflags & HF_NMI_MASK);
 
@@ -3733,6 +3736,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_vnmi_enabled(svm) && is_vnmi_pending_set(svm))
+		return;
+
 	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
 		return; /* IRET will cause a vm exit */
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cc98ec7bd119..7857a89d0ec8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -584,6 +584,16 @@ static inline void clear_vnmi_mask(struct vcpu_svm *svm)
 		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
 }
 
+static inline bool is_vnmi_pending_set(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_NMI_PENDING);
+	else
+		return false;
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.25.1

