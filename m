Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B185A46DB
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiH2KL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 06:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiH2KL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:11:28 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60CA40542;
        Mon, 29 Aug 2022 03:11:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+3Usslqqc8a8iOCIM5fKAcos7DD/Y4SERfUt62Ht2Ha8xxvcv96Jbf8RWdNHcSfbIp0Ffl63T0aErocMLmvvKt1wg1CvR7Xqm9iTP4AlxuTADNPqgRnyF166oRu/xQAitVo+mjIHRv0gJuoget1to00+2kdQ7hTGmTyatUDz5MEutnPaSG70msAcI+Ci6Wp9paoVru/ePfkWkEP3EETVI2+ae8NvUkywU2KtTvLuUcTihJNhKBqSwwGH7DjQBQfj9veSk21qniRNkiUne1ZAP/UO39ziiwaa2qPq42fWH5+9Utm5zw0+igjn3z9WRNdCfOtSYQ7p4+rVwVGo69Wuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xbR2snkxD9XJ0q1wpI7kLCfpKJrBJZjTVBPRAUibyw=;
 b=kem26Q7+fA1ufSEfDpSx1UhLbfpnM81cRgQbLV8nV1nfbkslzRY3Iz8jD2V3CZPhjZnEUaJuuiPaK4vRiyoF3UWB0neK6r0ARNgU/QAVnE+biFBEbLqcCqI6cijyr4Zzc0idnUAtOyIhC59eM9F3I68F61LFW8vfojjEBYpptEGmfQTqeSmVXuFn6kyHrc/00hIaqONKCD801JyvQMXJikWPaWyy7m2eZDKBPaTeEyT1ANaMXU131cG/jCty1/CUYXDT+KTB3u0PkuKk+f6+ltIldlZpWjltYWJi+WDLd5d+nKFRGMnGu4aN10WoQCJqghkuKtVTDTVmkS9swGBzOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xbR2snkxD9XJ0q1wpI7kLCfpKJrBJZjTVBPRAUibyw=;
 b=qBtJLGW5vPt/nkMdHMSTWyvuWbnrrou6boNh/JI9OJHc+p7cu3su+ri0F4yNGNpRdNabq5d1ajXAYtb1a67DjJPRKC9eJWBAAcIR8cKkEC92u1zkJDwNjNSxnlNrvvxKf+g0skOz5Cq6kiNLr/uMfIgZcvKtwykxWJorA/7mxVw=
Received: from MW4PR03CA0198.namprd03.prod.outlook.com (2603:10b6:303:b8::23)
 by DM5PR12MB2342.namprd12.prod.outlook.com (2603:10b6:4:ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 10:11:21 +0000
Received: from CO1PEPF00001A5D.namprd05.prod.outlook.com (2603:10b6:303:b8::4)
 by MW4PR03CA0198.outlook.office365.com (2603:10b6:303:b8::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 10:11:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A5D.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.7 via Frontend Transport; Mon, 29 Aug 2022 10:11:20 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 05:11:15 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>, <mail@maciej.szmigiero.name>
Subject: [PATCHv4 5/8] KVM: SVM: Add VNMI support in inject_nmi
Date:   Mon, 29 Aug 2022 15:38:47 +0530
Message-ID: <20220829100850.1474-6-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829100850.1474-1-santosh.shukla@amd.com>
References: <20220829100850.1474-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b004503-0ec5-4428-6f8d-08da89a6d22c
X-MS-TrafficTypeDiagnostic: DM5PR12MB2342:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUrPyb8Eyu+b3BWNk3rrx/9JdEyMLV+Xqgvgg3WG5+9nt/aZdPtsGT56yt0KxI0UlNoVQjgyvAaHphkBXlL7Lcpmiz2x0+BI2pWU4c/6EAdKZ9hSECOBNkGHV1AJ73/c2gtH1FGfLdsAyrtvVXhhp115zIKMczFANeI2koGg9hWTgWNKUUKJbqlZZFGMtNBgQ6yJ9R2AXf6f8cdYmEmXAzoBgVp/TYuUcGIB+pbuI0OgQfdDYo2A7r8jKBhzC6qHf73iKgfktjyJaxXf0zw7P8Lpt03V3UjPsYasRFba4AaUamepA/b0JsbHZw9gvHVsGcLHcNiunTw9SbLooz999Vh+78dICQRn58oGAO8a19u7pJ1pRfPOOeIHnBJd9+o3Bj38TsuzGN+qQ7w2ukxY+O+ZJ36gY1Hh4Wfx21yUC4vid59h4z/pojOtfltMOLYEHdK1OkEZMsLhUMJT68cV2erwNZ+kuSaausIzGWiui2Nd8uAoOBukaUiCzUj38+cglAZ2jW2fsHML5BUdgLwjzBwlCiByEcSYdQc6/MwTJ698a1vi274T3h2+lPglwuZig3EZ0oIpSGoXzrH+pPRcQRA1hL/Vu+RTb5lpEgz/OE+ezEsZ6TsHf3wttIGIgvoy9jPX8HeXRsB4TZvNWOO8TbBNMx5tgQczMwJapNBFjPsi5afWUcWF4LQmfcEoGM7kKtasK7dKBVG7Frfqten474oVWWn7t1qmuhGGsLkti3RpZglEv/E/ViFK4Tzw94x6TzfTJ2OXOeI2BWquerdAKcMs+HAQ+B9RrSqTv6dxstRSMwDvmkA9U4ShURqjkwYn5WB1CY+xNWbu78w8Iy0sCg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(396003)(40470700004)(46966006)(36840700001)(8676002)(4326008)(316002)(6916009)(966005)(70206006)(70586007)(36756003)(86362001)(5660300002)(8936002)(54906003)(478600001)(41300700001)(81166007)(356005)(26005)(82310400005)(2616005)(2906002)(44832011)(6666004)(82740400003)(36860700001)(47076005)(40460700003)(336012)(16526019)(40480700001)(7696005)(426003)(186003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:11:20.8175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b004503-0ec5-4428-6f8d-08da89a6d22c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
will clear V_NMI to acknowledge processing has started and will keep the
V_NMI_MASK set until the processor is done with processing the NMI event.

Also, handle the nmi_l1_to_l2 case such that when it is true then
NMI to be injected originally comes from L1's VMCB12 EVENTINJ field.
So adding a check for that case.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v4:
- Added `nmi_l1_to_l2` check, discussion thread
https://lore.kernel.org/all/bf9e8a9c-5172-b61a-be6e-87a919442fbd@maciej.szmigiero.name/

v3:
- Removed WARN_ON check.

v2:
- Added WARN_ON check for vnmi pending.
- use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
 arch/x86/kvm/svm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 810b93774a95..4aa7606a9aa2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
 static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = NULL;
 
+	if (is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2) {
+		vmcb = get_vnmi_vmcb(svm);
+		vmcb->control.int_ctl |= V_NMI_PENDING;
+		++vcpu->stat.nmi_injections;
+		return;
+	}
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 
 	if (svm->nmi_l1_to_l2)
-- 
2.25.1

