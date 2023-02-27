Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE826A39D4
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 04:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjB0Dzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 22:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjB0Dze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 22:55:34 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5D5F742;
        Sun, 26 Feb 2023 19:55:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MA6VdWMWb0C9GfBhSBqW/Om2mCRcaUggVw1vd8BI6INhRl0oPEwI+VEbUlwn11I/bp2TNFhJBVJHCobOxcXRfWD81OoBH9j1K+vglhgsry7WgGMp9VsZw+laXZ7EyIoN2SumAnymU3GdSSXQHBWLw32+iIz84pdqd/ahCiraJXFAluLBmjv7wEGmWdwLtUPJhfAmOnswskhRqQl1dN3bSrNKonhRemOHiboZvlvr8C3h4NIs1Z33/T6IwbvReF+FihJ0XU79pQjPcHb4sFTk/PbdFbUKaBiERYqd662nnKrUCDC1aSWuQYy/IclKFvsN29871VfRWvi8/eZkhyfUMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WsBi1YVAqcUeIja1LeaDn65/zTLD9XL7APBHdf4wERg=;
 b=MPZM2FGYv318CFQL9IYL/ZDOp6+JBSJUUgERqi/u6fiVyfnJq8UP/OOm8Tk79eJz7Jx0nfSEZMmiIEmRNffKlmG9b9FyU0tZtY9hQ2DYlo8eOobPu8FCN0KH70iavHwvj2/yv4Ee6CQAvrmK9DTUI+jDmyM/6l+EAU0K8LQEQSDU0SO77tzwNodtPsx9/PtCQAHCjI804/WvsJSzVdz420NKkCN9Qu9LE2pXcC9g5blhYSGBxkrYBXHYMalmtWjDcnMWO81wGtRt7RtN3y8liwGQ1AAlANXjpjidmY4u7Xke5e+GYK7BUbY9T/6Y100k5kJUBT7gZuy7BiW1iKzMow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsBi1YVAqcUeIja1LeaDn65/zTLD9XL7APBHdf4wERg=;
 b=xzoghsXXqq7bDaEhjrF4P9qW9/UgYI/mIHbLaOMgarU/KbK81NP0Skk2aYC73hD7IUDQBvwvkJLgDS6Xw003LgGkOTn5siSLa7Q2bNWw8UV99ghMi6uT88QJK4CvT3W1qhfZ+ABqjvX9MHUTNtlgZcSLpEioD3uqxp02OGbegbI=
Received: from DM6PR08CA0044.namprd08.prod.outlook.com (2603:10b6:5:1e0::18)
 by DM6PR12MB4107.namprd12.prod.outlook.com (2603:10b6:5:218::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 03:55:11 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::e7) by DM6PR08CA0044.outlook.office365.com
 (2603:10b6:5:1e0::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29 via Frontend
 Transport; Mon, 27 Feb 2023 03:55:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 03:55:11 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:55:07 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 03/10] KVM: SVM: add wrappers to enable/disable IRET interception
Date:   Mon, 27 Feb 2023 09:23:53 +0530
Message-ID: <20230227035400.1498-4-santosh.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT031:EE_|DM6PR12MB4107:EE_
X-MS-Office365-Filtering-Correlation-Id: 049472ba-e4dc-4d40-2337-08db18766cad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9qJvzfH07uldZW+oR/X9tQOQMGMdNFngzOshud4N5ekrRg7XPxNoRjz70qi9kIQbxaU9tZqXprULWCYEXX8PJIkGf7AC2S1VryN4dpQPn1/P69F+u7ZAEtT4n7rQpgpyakLsLMu/XBcauOeOMn4juTCpXT6DDhyHI0Kcr3zcQEO7dF53paY5/HYWA8lR8Bi0o2B94X7pZjBJ1TJqwge7Ti2C8NC0dBHSr5X25ojhWM+58dFlfOrlrBIRlcoXNc/wJbk7YRkDkfYXlqXDyBYvhXQENohond3BOF3a5xShNZISu6EYv/0SCdZa/UqhrCX34irsZL4/KL6I9J8sli30D2kKTWAKMAY+CN1woKZHptVKBimV3SfUj8eOSujoZMabVOvGsCrpIEqr+R9qNz3nZT0YzF+V5xieVGwwlA2/r/33Xwx6F1zdJOUSBN6jq09Yg9iut9Ne8U5g/9WhOOtxJeW6WIgP6NCiaKB6mPEYoJ0YTIuvJkqKbI2he+Q2T8YE3A2jPSZBQ0k3rtZ5PnEeMGocNlH77+3lFqObe0KPFeFGpPvPWv3TvhKQfoFzKtBI5rXJeJOcoulzUJeVmB3nYuAut3qYLcGgL16iD8k/QEz+E3anKiH8b8m/i7DL+h122Dn/s7f4XONK1l4ybsofx2iXXMDyuuU5rCkbr411rZu1rGg88tot4G7ZlarE22C7JwfXvnQQNNf6cE7nKyK6wyIyHC2c3lQZhgRbsxqdJ2g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199018)(36840700001)(46966006)(40470700004)(356005)(426003)(47076005)(82310400005)(336012)(40480700001)(36756003)(86362001)(81166007)(82740400003)(36860700001)(40460700003)(83380400001)(2906002)(7696005)(5660300002)(44832011)(70586007)(70206006)(4326008)(8676002)(8936002)(110136005)(41300700001)(54906003)(316002)(186003)(26005)(16526019)(2616005)(478600001)(966005)(6666004)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:55:11.0769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 049472ba-e4dc-4d40-2337-08db18766cad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4107
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
Reworded commit description per Sean's v2 comment:
https://lore.kernel.org/all/Y9RypRsfpLteK51v@google.com/

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

