Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4693E51984A
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345490AbiEDHfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344782AbiEDHfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:31 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6095B186F1;
        Wed,  4 May 2022 00:31:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mI75ZY22+otTOdmIvCmGMWr13T80OMbHltlTtq6HFrBadgUmkugI/6IqIjCWtZ269a6Z1pBr66Ma53Zxnf/m0/26khSpo2mqV3syk+7IAWLpQJP0fFIeNTvSmywxYPZXHIwPIOItxbPggyMRSeVQI96tQ1BvY9NiO4oFl8otRZgWYpPFbFX3yIqIF5UiaX99ID5/f/LVnyPzw6IAbJWu3aZ+wpI4/wxIu46S0DWSVyrFWHqWw1XsWDWqUc9ii3UBFRdt9Ltkj3HYQVzZDvavkecw+ZeesHw3zJXxk3uzd0ajYk9nl9nnFcK9sYrgrB1W2jYiO2dz9gpNx8jprdhT2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFyYseioVs6V9UzBI5urMdMu5miaun2LBkfHFZi3ZVk=;
 b=FMt5lLiVMKacbFCmN2h/ASD82ADVlBAJD23d0/lAWA6UgeQIKkM4KvtedaZSOxqbClNTtQV+m5TSjIer2lM5zXT0H0xvnI5DGeK+98ROEvQiw38zF+T7OeAmXIvArZNEChU2JqxMGohprrNwf41WU6X4Jg4zMq/N/b48xErgAJGY000jSrLsg7YZWVHelItq5P0N60xI2r7jCzEFr/cLtPftI13T4Zxl0fraPSs6P4G5ymMANtTAdo69b/QYAGUxFQFzIGEJ1SrLsFx3Gu5BA63/v6s1+u8zp+svn+MzrADfQs8mj6G6UCD1OHlKZnqQ68fpIydxOrqekZhINd67pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFyYseioVs6V9UzBI5urMdMu5miaun2LBkfHFZi3ZVk=;
 b=iEOZoidR+0TXH3I1C18oULqcD7L4uIf4Pl4uWKcUrG3wCsFLkUZRQ1+cVfkvVs3NOsfIF53HVclybiMthB+opW7G22DNrRjFmS2nmmZpV6mKicoUrA7FBRBjl6KZESp1ptGG2Bl5C0d0XeyXTX+Bi666ptH31WL66ARvPRxGN98=
Received: from BN0PR07CA0028.namprd07.prod.outlook.com (2603:10b6:408:141::27)
 by MWHPR12MB1229.namprd12.prod.outlook.com (2603:10b6:300:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 07:31:54 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::98) by BN0PR07CA0028.outlook.office365.com
 (2603:10b6:408:141::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Wed, 4 May 2022 07:31:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:31:54 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:52 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 04/14] KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
Date:   Wed, 4 May 2022 02:31:18 -0500
Message-ID: <20220504073128.12031-5-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: e1af953e-bacc-4f32-320b-08da2da02991
X-MS-TrafficTypeDiagnostic: MWHPR12MB1229:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB12294AA19859D7BA5F20821AF3C39@MWHPR12MB1229.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NdYTR+zvEjA2kiBeiOY9/20hO4XDCjnYA/7EkheWda4BHI11uOh74jiU4WqgiwJmBwNko4Qoq4ODIbL37z40DkWWJvB4cCPTci7yXsrO3MXg9sKdmhUuej25T9JwnMiFunZPpe6+9NPbxIARR4wRUAoGGJxLUy7CQFXiccOXrxz3iUOKUr74YjNpZj6HcUM/ibRwNNrQfVuTxKAwXchOiAS8iCFuRk+Yruv/ifZeRwR2T0q7zeLB5rtMkNNibeP+P5856i0Bd1aDdZ/asjuMK2nuRkyEbIp7Rcucwnk+JNGvhj5AUTITfkEgyMClwQlOsfxuqyprkMa547J5ynH2SPw4zJkvBN5Yo7ItJcy5y0+04MZJmGaROUeZelrU7yzULyNJcjhNJjZZ/HqdNKPyemyLKhCrroJGG08QlzUyuEbznYYl8iv1M0kVsmSvrPZbdCBvouW4hYfWV/4yTabBUXWgeS6YI2kXQSbKX6LPkg3jBmp75xji15tZ6IMrxLfvn6kpt2S1lvcOw9R9EbN3juI+OXzq/l3AJVC+oeeETBL0YkQoMZj0bgHj+xYJlqfxJg++QZJuXH4mAfxjjU/zx1+/2ZyHUtbgfzG/g9QxfYANwtvADzbLdv5TiQqqNzTeVZLtz7Fllrqc1LcVFy7s42S29Wd2Qaq/D5ijNzWpXseCltzmYaZu2tnSxMkEyQBX3H2kHu2XoR3EH12gtK3hLw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(82310400005)(16526019)(2616005)(186003)(316002)(356005)(81166007)(1076003)(54906003)(110136005)(336012)(36860700001)(426003)(83380400001)(47076005)(36756003)(508600001)(5660300002)(15650500001)(7696005)(6666004)(44832011)(2906002)(40460700003)(8936002)(8676002)(4326008)(86362001)(70586007)(26005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:31:54.1120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1af953e-bacc-4f32-320b-08da2da02991
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1229
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

xAVIC and x2AVIC modes can support diffferent number of vcpus.
Update existing logics to support each mode accordingly.

Also, modify the maximum physical APIC ID for AVIC to 255 to reflect
the actual value supported by the architecture.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h | 12 +++++++++---
 arch/x86/kvm/svm/avic.c    |  8 +++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 2c2a104b777e..4c26b0d47d76 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -258,10 +258,16 @@ enum avic_ipi_failure_cause {
 
 
 /*
- * 0xff is broadcast, so the max index allowed for physical APIC ID
- * table is 0xfe.  APIC IDs above 0xff are reserved.
+ * For AVIC, the max index allowed for physical APIC ID
+ * table is 0xff (255).
  */
-#define AVIC_MAX_PHYSICAL_ID_COUNT	0xff
+#define AVIC_MAX_PHYSICAL_ID		0XFEULL
+
+/*
+ * For x2AVIC, the max index allowed for physical APIC ID
+ * table is 0x1ff (511).
+ */
+#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index fc3ba6071482..182f4891c7ef 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -185,7 +185,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
+	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
@@ -200,7 +200,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	u64 *avic_physical_id_table;
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
-	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -247,7 +248,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
-- 
2.25.1

