Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03009519859
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345835AbiEDHgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345591AbiEDHf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EAD19021;
        Wed,  4 May 2022 00:32:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0WQCkc+dQ1EV7i4GtyfaTs34GnWSRLoZGNEKp7fKEZP5YGQxPgpv082qFFcacOvXA4dGJMA6Y5ngUVKWymCs3oGi/rR82CvHlbDrom8Wtkh0+6j7kQOwS7P+JJ4aDyZhySHUWjIp6ZvO5agr315TAGaY+Y2Otggkkic+OG92Jklc/24vOc5iYy4gIx57kPPN4LpzCtkw+8WSO6NTdVyYEAjdSrgKbTGkGCZurQ1wXgPBNrkK2+8aIppVG8V//viH+RQueSIm3n4VAwnulsSv2AbAnJlAdMB7UqS1We8nd9g6bSlPFosptu24kJvy+ZKQpwXqEUgkZEpjzw8LSHp9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewbE+AI70OzkMmoSvEvf+iypkUh9m0mQwqkfJbJ4IRY=;
 b=BCexDK3EfIJyOwmhib9wxEw+jAqEUUJaT6op7Z4g4y/XOvHqkPghBQvHSnuuxFSGyhai4vwBwlXICAdve4D0/rlp+MuaovYtG7D74Pg848ir9KNXnrp2zsJEcdQyte7fGTK5Y4RlcULo6+39xJCVKNYQjydxnP8eN5b/pMz4RVokX6U4t5HKNvuSErJLVSnN5ypUqLEP00Rsmo8TG/seqSOirbpuXwZtCPCr1TVOCKzBq/fO0XgC4euecq7G9Y5qhNinKBWiS5Vk/tFQvPHTog5aRaqNsbl4x+EAMw3GWzOBOohuoN7mTyGYySazLRNyyBF9nlcJnvhgJGxWugVrhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewbE+AI70OzkMmoSvEvf+iypkUh9m0mQwqkfJbJ4IRY=;
 b=xp+nAOLfRdKWBinDUbJjIkGMQEMx4cu36lG+M9YxMmk7byrieY5dSqMImnLFI/VLrw7VYH3IcDcCkq35qGpj1nXbCsJ3O+A12bAX+OjTNGF/q8SPtXb0zQ/wzz0Em5n5xUh4YE9Yo/6g6GMZN/u12xjFNJCBMs/0Ewi198WCSuw=
Received: from BN9P220CA0024.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::29)
 by DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:32:03 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::b) by BN9P220CA0024.outlook.office365.com
 (2603:10b6:408:13e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Wed, 4 May 2022 07:32:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:32:03 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:57 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 08/14] KVM: SVM: Update AVIC settings when changing APIC mode
Date:   Wed, 4 May 2022 02:31:22 -0500
Message-ID: <20220504073128.12031-9-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8b65cbe-6091-4c6d-4b92-08da2da02f04
X-MS-TrafficTypeDiagnostic: DM6PR12MB4403:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4403A788B41D35BA57B850D9F3C39@DM6PR12MB4403.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H+mKRXclUjl//wIP9ABc5OmjKYsvOoNnxzbolT0LiP7MFPIUVQZVex/1iZ8cAUS+MjnO4Of5IULl+tsKCSAp5L8gKM2LcO0k8n10HM/HodLI4z80TC1j69eUFjN1/7V8t/DNPzwrJMXND0JPB2d7AdczVAT2phxamCTQxK0XLUcSHHOmLHeI9/yWb21FcO2JTPG/b8ZloexxhWR37z75H7WCptUcGO5DH3XNJczibwPGPG1J71DRCsNhxE2psLdvNMiKPTWGsJ0Qr1JoersMmM48UzCQ5/GMM5RIT4FKJhAblx7mzGQI4GK/sL+Urc/QL828A0HwyNPUi4D/tj1jw1kG/clvwDiv6jFBSO6CXfdn4IvO718G8Zv5J8+g0q4pwFMIYjAVF7ClSqjX9nIunRgfVi5BE5wBEFJZyn/pJL+wyT2CIkA6sxABi3Us+s2cUZT6Fry1FwsIBZOVIB6SVvk+vCXrkpPpraBtZ9kQs0x1wdhypvFNH/frGnBvG1ZmGye548WYgYzq8FI5QeQq+/UGjmvr1C4aXWSVxsu+vcHIBNIy649OiR1mTbVX/PuSr0rZ/7Ee3mWqetp9Q7FD+FkLUs6/c1EJ4AXpHcp/b0ggOpIazNBTibczSUnCAvYKL+3X0EXXkTDbC/rEWEVXw0pgFXu4htZvhQY+8YKCPk8ZZc1Pvcxivm2gT4f23kEzkaR7LIv8ksX6thwL2lP03g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(82310400005)(1076003)(7696005)(356005)(83380400001)(2616005)(70586007)(8676002)(86362001)(36860700001)(6666004)(70206006)(4326008)(40460700003)(81166007)(36756003)(2906002)(336012)(47076005)(16526019)(8936002)(186003)(316002)(5660300002)(426003)(508600001)(44832011)(15650500001)(26005)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:32:03.2549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b65cbe-6091-4c6d-4b92-08da2da02f04
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4403
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update and refresh AVIC settings when guest APIC mode is updated
(e.g. changing between disabled, xAPIC, or x2APIC).

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 16 ++++++++++++++++
 arch/x86/kvm/svm/svm.c  |  1 +
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3ebeea19b487..d185dd8ddf17 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -691,6 +691,22 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
+void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
+		return;
+
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
+		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
+		return;
+	}
+
+	kvm_vcpu_update_apicv(&svm->vcpu);
+	avic_refresh_apicv_exec_ctrl(&svm->vcpu);
+}
+
 static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 314628b6bff4..9066568fd19d 100644
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

