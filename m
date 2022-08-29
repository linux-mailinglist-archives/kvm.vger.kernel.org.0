Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAE25A46D8
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiH2KLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 06:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiH2KLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:11:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD7C38BF;
        Mon, 29 Aug 2022 03:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHSotq1O+bLV50Oo5a+WkWRK0oVaHw2OhrRMWc74UltPEPQlOeO9xyXnzK+77rKzUDfT+O5Ia4DZhejRgP3g08Syyb18OTtHHgm2nwIOTT1LXW8Gld7mYPUlbNecP5AIeBBz2Y8ONJ19fLDSFLdDebcFQ6M/jHQHm6+ttRE2C17KUTt9mbT8Hhot0W50G5m8bcozYWvHW0MxV6PHO6GTc9pxlWdj2aI76wGgctxp608qibvS6qeSFo4wNZw7IXQFFdMMJWSMJJEUZujduQiGmsVm40XTnM4sluQT4XzwDFv2S/0FcnNQrVbJMFSYMEngTsts7SPB3SHEqBtM1Y2RyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KfyleGqdFUZ726MZ1QjhVlEsBIwC4z+T2J17fH2BMA=;
 b=EAgRwD9EsOQJgN9DZeSqzpRF2dUg4D0NzaBiwjUaDHSEehafvS3xRmx94dDbd7xSi+gkKuq6WsUBVglgfc9KYyv20V22R+uW5cTz9wOtpR1DnTFoiUJcNBibyfpaCqLBg9eNQIuzjzC0uKWMoNOT7bfrhhIU7wT2qqeB/yyKKTlNxQFWIkWO0rt4HW1NKyntYR7/baf5lhpP00GUxRXd0f3aGqaMGmFugu12KrQGjqvh1pm0aFtsJkBYLWEN57DetxxHsl5B7rNbKBESZ7hyk4KPN2shC1gHK0MJQKXC+pqkKqxoBsULMNCc0MCdEGDr6itvtIuXpDNp2YiGrqMIAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KfyleGqdFUZ726MZ1QjhVlEsBIwC4z+T2J17fH2BMA=;
 b=JSrLjRhGfLRqolojHZeM1Ft4JMK+1rAWhAfWkEm83kbktcht0i1wAEYi359mt49HmUD6tppgJYo4G7Ak1jU3nxLH4L7b0WqoA+1SeccJbXH7mdhjF3EH3YcHhipz5QDDavQ6Cy22sGJ/jGtg0aXj/9hVyq75C/SYuCuKbYiFVok=
Received: from BYAPR08CA0026.namprd08.prod.outlook.com (2603:10b6:a03:100::39)
 by BYAPR12MB2725.namprd12.prod.outlook.com (2603:10b6:a03:6b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Mon, 29 Aug
 2022 10:11:04 +0000
Received: from CO1PEPF00001A60.namprd05.prod.outlook.com
 (2603:10b6:a03:100:cafe::5f) by BYAPR08CA0026.outlook.office365.com
 (2603:10b6:a03:100::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Mon, 29 Aug 2022 10:11:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A60.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.7 via Frontend Transport; Mon, 29 Aug 2022 10:11:03 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 05:10:57 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>, <mail@maciej.szmigiero.name>
Subject: [PATCHv4 4/8] KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
Date:   Mon, 29 Aug 2022 15:38:46 +0530
Message-ID: <20220829100850.1474-5-santosh.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7c60a389-2674-43b2-1110-08da89a6c816
X-MS-TrafficTypeDiagnostic: BYAPR12MB2725:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zhS3u3jYA+vaJk37omofq9ZFR3DzB+21+B3QwXDmEX5ADbKAbhUy31dnQC2O9lElNEIkm1o8YTcG9CEL8jDw0rU9K4OSeaqyg4woHJtHpKqNfmRoAel70AOMfU0slSwg909ZijFxbRaqMH4fukCf0fi5m8MmyPzzEAgukjhNj/epeG//4lddHY7Rai92eCVDrXDdstPmmpWWRqnRrRqWo5pRRo3+Mfcudig4dE5lyZWNxmlZ6EN7Kg2knfn3clcX5Nvozw0d326X4rmeayV/xuwHxsmYlyivZRRaZJu6R7ufiz6xOgpsO9ZlsqfpslyltWU8KPBNaa2sSXEvkWn7m7r+9v3pEMUS5KZzxwb4at5WHvxGrSWoLwqBJVsoRLMJ6cByKso6SxDNlp4SoUCxfHWGFhgBQtkN/fQwSqNK2ZmTFXSoSY/dvBKke+7GASS5EIvqSezi6GgsyRrWR4x1z+tfcxYltuyj+2Dk/NttmGlNn7F9UnMt5L3hV5TrEWeHibOibM8tICAdSv9DFtOrJUVKbfvE5ZcgJP84AqCcpBo54dhqbuMlIYt4L/W3cDLS2jyBeNJaJ8DkJ3Hs6Ozo5kM/s2gk4YjR0rMJHKb6pR0BnG+Ie8tqWFbNBIx2GOwPHFJrbEKMIE2wwhF+wCfPlgHWuj9jDAB1FHQ4OnEDfrHWSLJaUnEAjxvcCeaV89XRPolCPs08QXPYuvj3eIuKXftt8OfgDr7Rqdnpk3eoqkSnMaNJyqDn7XY5hpps4d0UZnhdnIjWV4MBWuZ4wskTwhhgoZ6hFq3aC7Z5SgSbec=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(40470700004)(36840700001)(46966006)(86362001)(81166007)(83380400001)(426003)(186003)(336012)(2616005)(1076003)(16526019)(356005)(47076005)(36860700001)(82740400003)(40460700003)(36756003)(5660300002)(44832011)(8936002)(8676002)(4326008)(70586007)(70206006)(40480700001)(2906002)(82310400005)(26005)(6666004)(7696005)(41300700001)(6916009)(316002)(54906003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:11:03.8780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c60a389-2674-43b2-1110-08da89a6c816
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A60.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index ab5df74da626..810b93774a95 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3598,6 +3598,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
+	if (is_vnmi_enabled(svm) && is_vnmi_pending_set(svm))
+		return true;
+
 	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
 	      (vcpu->arch.hflags & HF_NMI_MASK);
 
@@ -3734,6 +3737,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
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

