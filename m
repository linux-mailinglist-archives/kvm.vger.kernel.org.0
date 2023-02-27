Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB366A3D6D
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbjB0Iuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjB0IuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:50:15 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB79A26D;
        Mon, 27 Feb 2023 00:42:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLJ/c25XFm4noYvXpSzXgVejeVBx3luFl/sUtDAvloe2cR9sFWUoD/7QrKJn/8TN7ih/KODIyMeR5gfvvwOcbGqnFlDJYqeHbNOG34fnQIPC5CzRq6DfhRNsodC3nUQq5xlG+9LApahwZonVONLUNB8TJtVHH7kj+tUltoViozxwiaLCVg2blNazG0NRk/NkZH+HtExcHZrOhCuoiy9Ef+6rDfnvPVdJxqst41cWPTQYY0j3M5+CstExbbhqsuUA5O8huxga32jbHPh9P43+oR5EZCm50gEkHsWYba1vlDW7G2uO3aJ+1MJFIPcaDdgm3kf/CvOkQ9XIisb6t71BOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gd7MYIu4mHbFu38bGyi94/NKEegCYzVzkeE5RgtBi8o=;
 b=VGlk9MC8uvMgfdu9ZWHcKWaFB6WKfKH509wL6WoU6uRqd/7YRVIJ3WVAuWe94Ri0l1Yyu/DTJ9E5KFcaNuN4XxSC/S2ZYRVgt9PYixWQ8kD5nhV6qw95kMvqa1uCZGxEtG9n/3mTtL2LuIc53Ajv07bZ0Js4cXSg8xEEb2YeaxY6LZOwn51QiOCCZTU2x3yRVDwkMhEZe52Y4eqTNhmeW/RjCnzRQsOlR/Rz2kB2PF7CGM3RngRlP8Zp8vKaVMI4F0WsCIhbFe+DXUNW7U0Y5N90/xoTEJd41WMTNhX2hg8DUik4jwNxjDpRYVrWniEy1Pz0wHSi9feP+wEkMvhUXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gd7MYIu4mHbFu38bGyi94/NKEegCYzVzkeE5RgtBi8o=;
 b=Fxn8ixa2a7UNywUGiLCqN5A1NXRx46rCFMBgqS6NQ4hRW4ktsNhjYggi4ibn9IbWS50Klla2pPgEZonKdtgQlDeFPYdewisaNISpqWawfaaCQd1+8GdRBj0Z0zzQoSPFUyNIDV5wW3fdKOghKGmrIOTdFGQnJnehfZO5ZVeD35U=
Received: from MW4PR02CA0018.namprd02.prod.outlook.com (2603:10b6:303:16d::17)
 by DM4PR12MB7576.namprd12.prod.outlook.com (2603:10b6:8:10c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 08:41:21 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::fa) by MW4PR02CA0018.outlook.office365.com
 (2603:10b6:303:16d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27 via Frontend
 Transport; Mon, 27 Feb 2023 08:41:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 08:41:21 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:41:14 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 02/11] KVM: nSVM: Disable intercept of VINTR if saved RFLAG.IF is 0
Date:   Mon, 27 Feb 2023 14:10:07 +0530
Message-ID: <20230227084016.3368-3-santosh.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT036:EE_|DM4PR12MB7576:EE_
X-MS-Office365-Filtering-Correlation-Id: c564e090-dc91-4a6d-6cf6-08db189e6733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rECC4YCr4ELFVE91c3kEzKwo2IGQWQUehNvAlEeUNzdCMDlM7V/pbLQfFCNnP5W7+Bf7RLQUuuZr0E5IG5M/v9l2PphS5vJN+rmZYNQDwAZH0aACIo8z2XA9wow1DfG5iiUYPlqdH1Vff7rTuMH5uHXhUFHU4O/Kcmu26sgUYDSaAWHJYTBvVCCK21tTxIIoQREet9ZB38XGFLgkX7rPj6GkLeS1JnkXfmnq9bTb2tz7+gFzqhKlfZqnojJV4q7NUIzIrafcHnI1GBSFMMCTMwSB6GZEVBEOpgw3EA6IqaALg+1LMOqeEEvPdaqqyaPQdYlFgCTUOg1Ey/ITt7iRR9FuAnBC5LfTb5krQlbUtA2MkVwCAEBBhxcE0tJWHFUh9BsWQHl0Q/sqIE1chkP/BB0u4zkeGQ/LxytFXrS8qEqo8bLTSkXleg34Oa4Lyn1EyJL2GtdbGfoG0wYafxfcqK0JaGIW5OKmuC0MBI3R8P0T3pJvV+GfO7klLLdHVI//mPtcwM1vdz1PB6cRp4s+cVcggwPa5nSzWST1i+/v5PxoRkx3y0t0Jdt8eopNg+zESIV8GUSbw9orzw6Aa3ILvqxJ8YRByBywG/yjCyXc1aUFqs6nnt0JZCgpts98lCyRdGSG9qcb7qZ5IrM17Vf1pPeMrlEqT098/4396Z8L2LyIceEQTDL2KAFQn8qXsZiDIk4LediW5TLV6D0pygTsQTYxXifE/4JvgGiYyhinqYo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(336012)(47076005)(426003)(110136005)(54906003)(316002)(40460700003)(36756003)(40480700001)(86362001)(356005)(81166007)(36860700001)(82740400003)(1076003)(82310400005)(6666004)(83380400001)(2616005)(186003)(26005)(16526019)(5660300002)(2906002)(8936002)(966005)(7696005)(478600001)(4326008)(41300700001)(44832011)(8676002)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:41:21.6817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c564e090-dc91-4a6d-6cf6-08db189e6733
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7576
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Santosh Shukla <Santosh.Shukla@amd.com>

Disable intercept of virtual interrupts (used to
detect interrupt windows) if the saved RFLAGS.IF is '0', as
the effective RFLAGS.IF for L1 interrupts will never be set
while L2 is running (L2's RFLAGS.IF doesn't affect L1 IRQs).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
---
v3:
https://lore.kernel.org/all/Y9hybI65So5X2LFg@google.com/
suggested by Sean.

 arch/x86/kvm/svm/nested.c | 15 ++++++++++-----
 arch/x86/kvm/svm/svm.c    | 10 ++++++++++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fbade158d368..107258ed46ee 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -139,13 +139,18 @@ void recalc_intercepts(struct vcpu_svm *svm)
 
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
 		/*
-		 * Once running L2 with HF_VINTR_MASK, EFLAGS.IF and CR8
-		 * does not affect any interrupt we may want to inject;
-		 * therefore, writes to CR8 are irrelevant to L0, as are
-		 * interrupt window vmexits.
+		 * If L2 is active and V_INTR_MASKING is enabled in vmcb12,
+		 * disable intercept of CR8 writes as L2's CR8 does not affect
+		 * any interrupt KVM may want to inject.
+		 *
+		 * Similarly, disable intercept of virtual interrupts (used to
+		 * detect interrupt windows) if the saved RFLAGS.IF is '0', as
+		 * the effective RFLAGS.IF for L1 interrupts will never be set
+		 * while L2 is running (L2's RFLAGS.IF doesn't affect L1 IRQs).
 		 */
 		vmcb_clr_intercept(c, INTERCEPT_CR8_WRITE);
-		vmcb_clr_intercept(c, INTERCEPT_VINTR);
+		if (!(svm->vmcb01.ptr->save.rflags & X86_EFLAGS_IF))
+			vmcb_clr_intercept(c, INTERCEPT_VINTR);
 	}
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b43775490074..cf6ae093ed19 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1583,6 +1583,16 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 
 	svm_set_intercept(svm, INTERCEPT_VINTR);
 
+	/*
+	 * Recalculating intercepts may have clear the VINTR intercept.  If
+	 * V_INTR_MASKING is enabled in vmcb12, then the effective RFLAGS.IF
+	 * for L1 physical interrupts is L1's RFLAGS.IF at the time of VMRUN.
+	 * Requesting an interrupt window if save.RFLAGS.IF=0 is pointless as
+	 * interrupts will never be unblocked while L2 is running.
+	 */
+	if (!svm_is_intercept(svm, INTERCEPT_VINTR))
+		return;
+
 	/*
 	 * This is just a dummy VINTR to actually cause a vmexit to happen.
 	 * Actual injection of virtual interrupts happens through EVENTINJ.
-- 
2.25.1

