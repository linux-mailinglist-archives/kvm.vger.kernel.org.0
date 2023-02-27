Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C5C6A39CF
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 04:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjB0Dyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 22:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjB0Dym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 22:54:42 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1116F74D;
        Sun, 26 Feb 2023 19:54:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8Xg+Dq9V1hAtQtW1pJtA4Voe5bFTbtC08zpis5edCCjo9pWmvk54wrODQhFQR6s2Jhw6VQ3+Nd8XUjh9Pudf8EhF0YuP303bZLpJpjvVFq8DEGt5TfqJAB8A6kzS9mwcjVwHo4BuJM93JRGGEB+1CbzaP6bvwUP4sktHX/zLn9Jxvs0GVss4tGgRZUQ4ADya+ow6RJcl2emCdMfmfhGk4TABfWNB8cm/Cr1TwMFAiVbrO7KkxwoYrmY3UZRvD1ZwkrODgynDoIEDk5zfp79TxB4vhpb61mI57tQOglZ9Nas2Urfp4T6yrkc/BKQdb6cTVQvbg0K21FfjCUdUPmbmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gd7MYIu4mHbFu38bGyi94/NKEegCYzVzkeE5RgtBi8o=;
 b=eYKc8fJxNMgo0tJ3P6eFYNHfrbqgf5k37XD8oROy1M6I5GB5q3kZkN64wjb2JyBr7P/9uPSqAm0d4GyDhLgDSpq+0oDi61pRgjc3h0kJ929AbGPHsMokIjJJbjAvzvaUYkKNZFdjL0vAdLdIe7hZs9fqyKgqFoWOtjZLF9y5XGCWdL9rVkvtgRomUT6fYaepk9SDc6CCeS+B4kJ4oW1QBnGR7MN/5/O1UnAAjA6RMpeap2nTzs50KHcamNd46+rlExiSQvBprselKfdt/LZHnNCQ82GzlUqL3SkMdwRYxgnv0lYRMx8FMHkgyEDY6CTQQ5pu3phjAyH0MNoxwZoURg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gd7MYIu4mHbFu38bGyi94/NKEegCYzVzkeE5RgtBi8o=;
 b=h9rx+KQBoIhVywOYcoKH51jyrQyaDTE/EGrVdncAs8USPVEofSrDD4jcii15J2pNWvitvIaUpkxVFdAQUtZRx6A7h0RcM0RFQrD6Of5uJwGRe1NgZlfke48KIa/9h1zJFNIazdrENRkF1GmunHXjSSjXa/258CNdKdJcPufFk4A=
Received: from MW4PR04CA0193.namprd04.prod.outlook.com (2603:10b6:303:86::18)
 by MW6PR12MB8706.namprd12.prod.outlook.com (2603:10b6:303:249::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 03:54:37 +0000
Received: from CO1NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::95) by MW4PR04CA0193.outlook.office365.com
 (2603:10b6:303:86::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28 via Frontend
 Transport; Mon, 27 Feb 2023 03:54:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT106.mail.protection.outlook.com (10.13.175.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 03:54:36 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:54:33 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 01/10] KVM: nSVM: Disable intercept of VINTR if saved RFLAG.IF is 0
Date:   Mon, 27 Feb 2023 09:23:51 +0530
Message-ID: <20230227035400.1498-2-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227035400.1498-1-santosh.shukla@amd.com>
References: <20230227035400.1498-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT106:EE_|MW6PR12MB8706:EE_
X-MS-Office365-Filtering-Correlation-Id: 56448efa-a102-486a-9504-08db1876584f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6m4vm91v8D8lVRm/i8VwOxJ3k2mrhj+XbMMHarS7evyhAGORXrywpKHIufdQ1WRp+R3eFaQFhAEu5atgQfoGJWBwCBJPlYqTQfUmAU3k7uIGCzMMsQ+DHua/V4G75fFu45F11UCAyALgDLDfUFwbOOY+Gge+DpUKkVAgcF73oV5kj0CAnHYxasOgjqhB207MKD/ApIp7d1JLGtN0C4tnT3k5GY13V464IMg+HhJTzBmZqofjaX8djKQFlyJa9Ee7p878Ee6u4cf3MpTNcodZdkXDg1afpOerrPIxd54bHuNiMWUv9TLkDS3WZvUiPsMM77Dz18sxEX3EOnG6GbFJLECVnp96fDS80AOToAfSWmOtrvFs/7ye5ecTlOkNZz5k2WRl4QFYkM+coOFjAneNEFmTUtk04oc3nZT7iKGUfuVPwXBus60YtA7qftMUha4sRpjWZRrrj4I6wvV+aH0qPS+6VTJMsKuz2wYsJQaAvEuI8jZXEzWVBHrlSMSK5FnUi81gfB61qNLgRITloGqHWAg+dviMu1xtK0MKQS83WQhaAQc9vGEJyy+lchcxeWkhuSfUGxU8s7sl9vv0NhbjPTA94BEY8Usam6wUp1L92staqB8wPQ7oZSyDx8dGMoPt1X0VsYMH5hhIthk+zmkXcKbxbQrqdG+6WBsIFVpYagI+cHxRFrn/oDclacNXSppXJNEPzV0TZFcCnoeC6N4JJ5fG+sk6IBT+UOpRdL+NH+k=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(16526019)(186003)(81166007)(82740400003)(83380400001)(356005)(8936002)(4326008)(70586007)(70206006)(41300700001)(8676002)(44832011)(2906002)(36860700001)(5660300002)(7696005)(336012)(40480700001)(426003)(47076005)(478600001)(1076003)(6666004)(26005)(966005)(2616005)(316002)(110136005)(36756003)(82310400005)(86362001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:54:36.8156
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56448efa-a102-486a-9504-08db1876584f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8706
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

