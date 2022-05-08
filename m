Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CC151EAF7
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388846AbiEHCnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiEHCnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:47 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734A91114E;
        Sat,  7 May 2022 19:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJmzce2tH9JjMiCHc3LrSx0cyVx9PXrEh0a7swAC+TrI+2R4gZmH77UbMu3SsyxjuleobBgfAhSQ7rcVSyDlKx2AhVUnqJX6YUmmU3VREFid7qat+6UWDeIS+IepaWUN3EH0o+KcHShXzRL4bOI2N3cKrt60pD2IZNPehabruLTBs0V98m92sQ98Uh0ytr7V15NmnbHR6QhMWws1oNWHO2OzuoRsFq73u7rG0OUn2zUzoXHUb2eYso5fVmvcbvyzU0D/HNNbusQ3dPAT9fcbmh5XBx9c7PbJTnNDvWOrMaRGf7tLaVuwWjhgyP477EApmZ/eYYXZEZIJz2AbasbLqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGfrndq+nvpSGl2a/gbBOnVBova3tvUfARG/sTsPf/Q=;
 b=n/KEjjufFWZuSPEyuZ0UCjsUdzpPDyLFg5EwwCdfG8Vp/dASF37NmO0Gk4lqLFyxCBe4Vzt7T6rBRZZi0PCV62dQNwAV0ura5zx3E19dF7kRYsGk/8wdb150qWASMTRkRQgt/WxeP9rcQVUWmCs5dRSz0nMruzfbF2PYpyZGGXdzuQAcqTUgGmGRXZxv9afdLk7NYA5iCTdn3Y1obLRVK1UZylXXuawxvLW5JIA/p2bVcUV18MT3MWlpwHPRRNl2pbJlmL9zrGaU5/pIkgufPNBmPH8xaqAugL51p2CXNnV+3knYOjl+POrnHfbbWuMamkSwmZN5MueM4R0ADlQolg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGfrndq+nvpSGl2a/gbBOnVBova3tvUfARG/sTsPf/Q=;
 b=W1zvmuFkpGTTFjox3yPsL0MhtOAsnj+ErthdYtfy2DCVVwAAVrNfhDXf6a9On763du9g81o1bqGeTLa1oJ46/fd+esgvITthbu5yWcHtjS/9u0NsYvWQ1wafXElKj0F2NPM9I2ekcakWEVM/zDlztyC3JnutPAsv4j4IZldRfPQ=
Received: from MW4PR04CA0042.namprd04.prod.outlook.com (2603:10b6:303:6a::17)
 by CH0PR12MB5092.namprd12.prod.outlook.com (2603:10b6:610:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 02:39:55 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::a5) by MW4PR04CA0042.outlook.office365.com
 (2603:10b6:303:6a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Sun, 8 May 2022 02:39:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:54 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:50 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 06/15] KVM: SVM: Do not support updating APIC ID when in x2APIC mode
Date:   Sat, 7 May 2022 21:39:21 -0500
Message-ID: <20220508023930.12881-7-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da7a7ec8-b85a-49f6-90f0-08da309c08cd
X-MS-TrafficTypeDiagnostic: CH0PR12MB5092:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB509242959B936719CECA9CA4F3C79@CH0PR12MB5092.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfsa2+lqPSIeJEIfcSLFKwYI2xchnsnJdcnXN65ngJM1DbWiH8O1XH48nMkZrVpF+25KRfkaFwR330dOjOr69S+1+BAnr6Q4MQ5IkBj9cDlHQg0kcRzMMqpxCq5ceeAjDkHVi/Sl2CXhu3Hh3v8mVJ7x3CRAnZzkzQRZGhVrjUpPl22Uka1I+ZoglyVKf4Tpgv39gDcy/b2QcmWWHYfxckVqlRjc/lDWNGlKuI9vorOyOS0qJiET3L+RHVT70g66Ie1fltPtXN0+vQZMeDQ2dFXK7TtbY4E3GTJ5ug2ynYZRpNYQCgiRMJUXwMMgbPvlFHVRH2UArGhKPzHYCc1FuyG+A+ryEKnN74fEGX04ONhSz52CmxkSPxnFQ2bfoUXmen46TYmbgf6EZu+T15EC6jcaOlBloGI2K4RBGdknJ+WiqRBT7VQj4BLk3OFBOUtpLJpkjEUQEGlnYZa7lnWCF2ME0B23htlbtSJI/wKdXjiwMGv9y3zTzdcIzhBDXH9Ec2BKOW69Uh374Dcdb7kLk3fsG+IIKQ/2OnXbZ7aFnppvO/AJqgRsffTjCUFBbRpj+OjoXhpa4gR70DeP4xhCpbgORIjkplW1zweiRatx13NUYLdVvSfpKGu2lVkec09n+HW3Mjjku9JymeHILGBztKjSHbibSDoE9SMXc4tsVBFKMmwIF4id/g0GvpOwKN6y91ZOKNmngd5gMNPTsdXdyw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(81166007)(86362001)(7696005)(2906002)(83380400001)(40460700003)(356005)(5660300002)(508600001)(8936002)(26005)(36860700001)(44832011)(1076003)(36756003)(16526019)(316002)(186003)(110136005)(70206006)(70586007)(54906003)(426003)(4326008)(2616005)(336012)(82310400005)(8676002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:54.5192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da7a7ec8-b85a-49f6-90f0-08da309c08cd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5092
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In X2APIC mode, the Logical Destination Register is read-only,
which provides a fixed mapping between the logical and physical
APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
and the processor uses the X2APIC ID in the backing page to create
a vCPU’s logical ID.

In addition, KVM does not support updating APIC ID in x2APIC mode,
which means AVIC does not need to handle this case.

Therefore, check x2APIC mode when handling physical and logical
APIC ID update, and when invalidating logical APIC ID table.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 7f820cf45173..16ce2d50efac 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -499,8 +499,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
-	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
+	u32 *entry;
 
+	/* Note: x2AVIC does not use logical APIC ID table */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return;
+
+	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
 	if (entry)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
@@ -512,6 +517,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/* AVIC does not support LDR update for x2APIC */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return 0;
+
 	if (ldr == svm->ldr_reg)
 		return 0;
 
@@ -532,6 +541,14 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/*
+	 * KVM does not support apic ID update for x2APIC.
+	 * Also, need to check if the APIC ID exceed 254.
+	 */
+	if (apic_x2apic_mode(vcpu->arch.apic) ||
+	    (vcpu->vcpu_id >= APIC_BROADCAST))
+		return 0;
+
 	if (vcpu->vcpu_id == id)
 		return 0;
 
-- 
2.25.1

