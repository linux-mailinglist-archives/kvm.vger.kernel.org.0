Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA80C6A3DC4
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 10:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjB0JFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 04:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB0JFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 04:05:21 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0187E1F932;
        Mon, 27 Feb 2023 00:55:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VE6k4FXKGya4dEl9LXtQgytAxPldWzdINkPmU8L5UmEHgAInwZ9VtBM2eDL2D5lTLQ17O+/3hrRsfODW7sHrZpcwulVz17PEmRWubYlwuIZ7nrFz5SDVV5fIP64eGI9Y/OrwOC3Twtr52OJe+f4R11CEv/hsP/PDFcX+RkkeF921MgDHulZsWtBTd/XcT5CSVH5FhcWuOYj2CMDCypBOf3JBz5BhL9sK6ciphEiIVD6QcPzEQJGmL7K85F0PSiMaUW986WkJYdT2xIBE1mnC2zSP/o9/F//4/ywdQOmri4M4Vx1bPU7Q9EkzwmslbPm/oIYucuw6N2PrY9ND94r7eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxnFIqUQ+cmEzzQR6Ld4Tbpvux413oM9nXqAupa0lDM=;
 b=VtAIqK9SLfyX7tpwjWTuUCYZTHiMVTH0VAATWVIHGMttJ0b9XBxpFjjD5POf8g+LCggi3UobxtM0va/3ofUk6qB3DFNhld3JAmVzcbnlbYtl8Umd4MtaipPS5LeHkuuWUxa02SsylCmPy6BxSC275nsYLYeVifPY8DReaK/lL6K1u5fTo7P58lFNRIg4CH5fiVpOSl8TpV7avtBRTcjO6K8++lFIhKs6lNRdTewaZPrUsjmYH9m5Fiv4NYcEKCXci5DDFR97qtY68nBSjSBx9QHn3XAiCL8oSa/UkZ1leQx1X3gE6Ik+Bd80Z06WqLcoRHUp+54x3uH6Zo5VViTLyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxnFIqUQ+cmEzzQR6Ld4Tbpvux413oM9nXqAupa0lDM=;
 b=sQlVTYGhYRLRuIOijBzbtSPIWWvavmOI1EZycmLPSb17Yj3C+vTQor62DuvaYab1VKFuJX+Xj/mgs9WeewfSVkxhEodHe4aDt9hxdo1lHn6dfdgXrSYMPTr7TervmLLgJenORj5NKQLZ2AcNIUQxqC0SovjPGkXrXBMPMy8vcGs=
Received: from MW4PR03CA0157.namprd03.prod.outlook.com (2603:10b6:303:8d::12)
 by MW4PR12MB7484.namprd12.prod.outlook.com (2603:10b6:303:212::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 08:40:48 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::24) by MW4PR03CA0157.outlook.office365.com
 (2603:10b6:303:8d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28 via Frontend
 Transport; Mon, 27 Feb 2023 08:40:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 08:40:47 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:40:43 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 01/11] KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is intercepting VINTR
Date:   Mon, 27 Feb 2023 14:10:06 +0530
Message-ID: <20230227084016.3368-2-santosh.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|MW4PR12MB7484:EE_
X-MS-Office365-Filtering-Correlation-Id: 22cab38b-e67e-427b-5ace-08db189e531d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1mUDF6RmcMdfVpGAGflBe9m1DMuNCst/1461WhREenmVPepTOjpVea/327UmvLBMncp+q75UKlb+4VY7f04Nvby5NuMdOPF3kZNEdmTMqG7Wz6bdRRAYzivWnpkt/5B4tf5lTjtBPrXDO/YmQXijiAs8x9JYMcUANEoR+63ElHHwBY6S3+aDoogtXVyk3zx7EBG1Qt9MtnA5QIpyC56uMuRu1jTJSKLGMrz1zcfkgHj4+sV/wZ4yR4plryC48tiTL21ZBfBvVTz5fnCrY1/Q2l3CY3Z5PBAg4l0xRN8CF6Ul7N5uO5hQE+2WnNX8YpUqqWUL2eyUSEG3okBLbJwZj74kqS95f83eaKmb3i32ZjQDlTjtVpQk6xFjeGEuThIo4rARaWH2cPxEBA0i1yPOegcfmB//t4MKU0yxeFMVpQDnykqYCFJQQKgj9qDLXzboO3+rkKZ7QsxAic8RMQPguloW7O6iM1nfN/T81LUQhZYbMFrS83wu95nx6nvbfr6gexB99Z1bHZUiqYt8FHz3TSMqj2sS789BgyHxzhcetaxoayG8Ub5b+YDtL2+vVjaYAdkRfRkRwriZqjySl15yTGsqZPLOUPHDcFdy4DDB773gvHw0ne3a5AXWr/aTC0htyw5t9KBvJZVeCEcQZR4QhSoNO3p77SkT1mFvfZZZCrk5OrW/GSBmHSwMyGN4/IeD8ujOLsTGTjccMcIyts/RzykpmrclPUTMPKpViBwqFNs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(83380400001)(966005)(316002)(36756003)(54906003)(110136005)(82310400005)(86362001)(40460700003)(16526019)(44832011)(2906002)(7696005)(36860700001)(8936002)(70586007)(5660300002)(8676002)(70206006)(41300700001)(4326008)(1076003)(6666004)(186003)(2616005)(26005)(47076005)(478600001)(336012)(40480700001)(426003)(81166007)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:40:47.9670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22cab38b-e67e-427b-5ace-08db189e531d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7484
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Santosh Shukla <Santosh.Shukla@amd.com>

Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is intercepting
virtual interrupts in order to request an interrupt window, as KVM
has usurped vmcb02's int_ctl.  If an interrupt window opens before
the next VM-Exit, svm_clear_vintr() will restore vmcb12's int_ctl.
If no window opens, V_IRQ will be correctly preserved in vmcb12's
int_ctl (because it was never recognized while L2 was running).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
---
v4:
https://lore.kernel.org/all/Y9hybI65So5X2LFg@google.com/
suggested by Sean.

 arch/x86/kvm/svm/nested.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 05d38944a6c0..fbade158d368 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -416,18 +416,17 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;
-	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
-	    svm_is_intercept(svm, INTERCEPT_VINTR)) {
-		/*
-		 * In order to request an interrupt window, L0 is usurping
-		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
-		 * even if it was clear in L1's VMCB.  Restoring it would be
-		 * wrong.  However, in this case V_IRQ will remain true until
-		 * interrupt_window_interception calls svm_clear_vintr and
-		 * restores int_ctl.  We can just leave it aside.
-		 */
+	/*
+	 * Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is intercepting
+	 * virtual interrupts in order to request an interrupt window, as KVM
+	 * has usurped vmcb02's int_ctl.  If an interrupt window opens before
+	 * the next VM-Exit, svm_clear_vintr() will restore vmcb12's int_ctl.
+	 * If no window opens, V_IRQ will be correctly preserved in vmcb12's
+	 * int_ctl (because it was never recognized while L2 was running).
+	 */
+	if (svm_is_intercept(svm, INTERCEPT_VINTR) &&
+	   !test_bit(INTERCEPT_VINTR, (unsigned long *)svm->nested.ctl.intercepts))
 		mask &= ~V_IRQ_MASK;
-	}
 
 	if (nested_vgif_enabled(svm))
 		mask |= V_GIF_MASK;
-- 
2.25.1

