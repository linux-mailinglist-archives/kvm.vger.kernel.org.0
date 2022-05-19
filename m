Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA1752D079
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbiESK2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbiESK1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:51 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2069.outbound.protection.outlook.com [40.107.95.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22914A7E36;
        Thu, 19 May 2022 03:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWvt8rPLg4++I/vo1CZCiY2aUAh+YxfZlq9IJLBNCvE5vW9IbDs1GPgLCYj6k4Ts9RyrPYGv67n5lgN6d6xSvPBEdwZIcTsh1O6EGvZe3hu5YDHduM5NuOFITyJfwcIk4AzWpc1/HNRgY2qJ/P6In6ZBzYVpcWITBTlb7/92YXnKjIqsnWGRyhWJHH2ztNkz/IWDBTLOt/hqNALaW4aXqegq0vdST1nl1cGAMSQ/xa2iDscQpi1FOl6XsCufePSZrOACq5Y2snr1C1SD8pdJpMZRZb+F6HpcLO8WNM6hdcvbLEPdgkj6G79eThxsjoL1ER+HxIakfcnMbYlcRehRSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83695Y+9o+s62B8x0blwU4bqtpuC0t1iZ5LaeEhEG7k=;
 b=gVtbQ661shpvVYWb97o3ozXCQkbXFZF3YolOiXp08RJ0GwJVjj8CsBj20ar1qVdfzIAZUWIrLztWg8SZGwEA3uEJ8rSXNG8Q5sk9uDt4Q/M1uqwzDSvP2XgXsOC+sdXohN8zeDI7Zf3tZStWl+bqeRQzMSY36GM/1MTaDtOaBZAAmARr8ecpCMNr1lIg38EZIJq7AcoUEBGmWy4/gU/N9OrTIdVlcNw1dX+uzYQf8yDlzlRUWhq+mzPjo6BceZtq10Dkt3VO+aPLeqDQGapuFybLcVklN8dLEzyzatXL4LdrIYwWNl1I9nRvAkRvhj/c0yt6J+dkYsWL+oe9OjjMVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83695Y+9o+s62B8x0blwU4bqtpuC0t1iZ5LaeEhEG7k=;
 b=M+G2vuAIHebrDmoXfTqrA8KstNR6svPgnL5xHHFz74XzjXm1rvop+/mHR0u1ZPf1OJRxAXeLW6XmUIRIIlWQsf8evQJDR28ijV9oQp03CuRFa8OdvfkaD9eBTukzNoAc9HKfc2XHqilrbjVoVKBCH7UbPD1yy+ItgBjKfOyOmoM=
Received: from DS7PR05CA0041.namprd05.prod.outlook.com (2603:10b6:8:2f::8) by
 SN1PR12MB2446.namprd12.prod.outlook.com (2603:10b6:802:26::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14; Thu, 19 May 2022 10:27:33 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::b2) by DS7PR05CA0041.outlook.office365.com
 (2603:10b6:8:2f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7 via Frontend
 Transport; Thu, 19 May 2022 10:27:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:33 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:32 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 09/17] KVM: SVM: Refresh AVIC configuration when changing APIC mode
Date:   Thu, 19 May 2022 05:27:01 -0500
Message-ID: <20220519102709.24125-10-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc542980-2652-4717-9f5f-08da39822fcf
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB24468A09906535783F9F5F1AF3D09@SN1PR12MB2446.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aFgx/0NLPKuQdnEdxVTT5y8hR2WHHpuAKNNE91QsMAv8eHgtpVaaHqcl9VkJu7NCwxYT7J177KQuDGSEQqFOYUfXmTWHYTjb96U9gwa5p/qeaGk06qQGHOhsZiO1i662yc5uJ0vr80AQeJcVoGPDffjfplfWtsIQSZR2ukb79LnFYKth5hA6kEVxOFPdqsxjRmAjPw8V6/rjJbHIi0ljHSRx5G8R9Gat/GEJxEy5TwZ4mdXHYxlDGCYT0OUiACotY+soSKCDtKBwanutuanmz9E5mA6sNkJZTY5OPr5Ytf+Q/RdVXjLfopEbMI5/uRL6T7Qs8qcBi9K7ORt3vqMgN9mQWit5pVhwsod0L8O2drVgPHM9+xm4FkoA5x0kSHNRzuQomVPcl7tnLHzHwS/YdGFneFdBsflVTkdpK3+qserD0+U3weUpZqE1IAN/xSGYICkltfyA3Wxjc3dOJEdn4MUCkgWmVjnyk35pv/Gz3CKralntZpC1eKNz+Fpf423XvcT6O+C5Y3bITWd0hCYApKOqOanme4f4yXfAWvoJPCOpCv9kyOsszSxpcCgmXfzfUXYM7DTjs2tH/EzgyH8EtQ6LuvkR0wzZB/K8gx9OTPFwc/msXYlE+lbWXEg/0Cbyp6LGt5nfjKjDuzeMk1PW07gf3jRT+cGiA/X886CMqOGvXB29y5Qex8FPGO5P1Ea6RY4JnOfr0FAFCdQpEcYQ/g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(26005)(356005)(336012)(47076005)(426003)(86362001)(70206006)(70586007)(83380400001)(8676002)(4326008)(40460700003)(54906003)(2616005)(508600001)(110136005)(316002)(16526019)(36860700001)(186003)(5660300002)(1076003)(2906002)(7696005)(81166007)(36756003)(44832011)(82310400005)(6666004)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:33.5920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc542980-2652-4717-9f5f-08da39822fcf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD AVIC can support xAPIC and x2APIC virtualization,
which requires changing x2APIC bit VMCB and MSR intercepton
for x2APIC MSRs. Therefore, call avic_refresh_apicv_exec_ctrl()
to refresh configuration accordingly.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 12 ++++++++++++
 arch/x86/kvm/svm/svm.c  |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 7aa75931bec1..aa88cef3d41f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -685,6 +685,18 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
+void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
+		return;
+
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
+		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
+		return;
+	}
+	avic_refresh_apicv_exec_ctrl(vcpu);
+}
+
 static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2cf6710333f8..31b669f3f3de 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4692,6 +4692,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
+	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
-- 
2.25.1

