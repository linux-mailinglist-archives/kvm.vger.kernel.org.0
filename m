Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226024FE087
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353655AbiDLMlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355017AbiDLMis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A6DB43;
        Tue, 12 Apr 2022 04:59:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DplONTGbhIn8nrU5Sitv39GId4MvdwhidU5XuQiTUvox7my6zaXgB43HO+SxAJPnGcxyPvzKA8jFl3++b/4kwX9a622nFJ7JqEmc4Y17S5oVgBxqp7w1rJrWfjmL3QMOaiuMn9eXzvrRRbwkqwvC4UR+nZ3pnFqN64UzR6fihSYAyPkKu6c5zpmqmMhVZyTu2Q2J1OrJruNadrySYQV7+SFhyr4p3NalLV6g/T9h2cV0CCfwuJJl9ugb0G58gMKTPWUGy2ZOYZVaO7EGHMhT6/SMAyFuGcjlTJJUPWDYN4SMAA9gI08dHix4ySvbxxJLFHbr9UxS0A8ayA60DeomVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQlp0Gc9AIp7mFKoFd57ZCwOVnraHeiHeMVR20wxTlY=;
 b=SXqevYEkIaPWql2INGvGOv6ZakXNDr+RsPoHmY5J0pt9XcFhGQzagnu2N8nMKr+c/neSqKl8+mCMBGxwdBMVcbrAB95QqsCRUwRq8p27kxFGrPYm2QPEftG4lpxStTy5M1EmB1YeELiuGSm5ojzFSZIDMhYepa8iiaa3jNAqeGGiq7WryK6JYWtLEaCEWlBuWPcYw6MeKlgl2P3zxZ+j5TpzCgypNM5v8prQ8eY87u4H64Rk5pIEiG2XR1jkYELbaXnnJNWuDfH96wlwov9Wg4Bdrmszhn56ZZqD7xEMjkwmLlJW9eiMJkizy3LDh5hxC1XVc1up034Ux90rwTd9DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQlp0Gc9AIp7mFKoFd57ZCwOVnraHeiHeMVR20wxTlY=;
 b=dPZOUorLk7BKE91R6PL4hFJtCRtH5lfp2B/Fd6B4ST4FaPgijaLRmSN/n/kOU7LgBlDdAdba59L8NY5ANnEWoiYcaDCsfDPAiRPN9m5pL6z5LbOJXcttLKVaadWz3AuWgZ0rLjS62/uJQ7wyxud9noMoXXbonIFLxTMCwnf52dg=
Received: from BN6PR12CA0042.namprd12.prod.outlook.com (2603:10b6:405:70::28)
 by DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.29; Tue, 12 Apr 2022 11:59:15 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::a8) by BN6PR12CA0042.outlook.office365.com
 (2603:10b6:405:70::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:14 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:13 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 09/12] KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
Date:   Tue, 12 Apr 2022 06:58:19 -0500
Message-ID: <20220412115822.14351-10-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a89a7fa-3f31-4eee-4f1e-08da1c7bdd54
X-MS-TrafficTypeDiagnostic: DM4PR12MB6012:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB60126C7C47AD30F2B882A86DF3ED9@DM4PR12MB6012.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oKiv27qgFTs+9wRmHsBIbr2ITyCtFZYE859jlGprO71i7bwaOXrRwJ1uzjqtro+IabeHMFYfp4DDxl0dB+dc0LC+c0zvOc3gSbdjkDiAOrPyvccjvxp3t9ILoj0NE74zSrC/mng17QBt5rJ8oWYagydOLAxGDXtuMNCNKdk46jTCGEKuGuKDqWIXKVu41sGFSlUE722zKsdMByMxIKFVx9boRcUx1tMsg3eDs5evJ8UWsn+K+dxOmqC+WVRmy4QfJC3aGrizPNbcCP7IZwm9SFoIq/NNlRaAHED6KOHvceNDJJ2rJXvyVOr3HcVM3PkqtR0UFKavZNx9jlcoGgtPRR5izz+TB9ockXKBeWXuGtzRhRyZabubSTKHoZmrkXLVAkhjcQCAjMPuKZaq1IdOCzy+1DtA2gk0mcAs6neT1Y/u0N88Z9G7guYlqfVhEd5N0g9X19l86opbneXlqI4dLvVSkyAXdLrEtDRvJvPjPdKjAgOTbct0G9rcvYuwzvylUHbvxs6dDYJ+STVmPsQIFLmqfSsBrMBT1FGerfQUL0lqYGcmJ6Bh1MC3Dq2XkX/Iq+wHaXug5ELaRvZm6nqzaCeHXI0YjVd6e3gxuB3VGtYdkZm42ECo9n4kFZY/102UDMndCPpE3BUU+V7C00S48nUYtCnbcU3X0VDbiCpPfcORv5NJfmHDSzrhspAEPnKzWQdSX0ATOUSbsMAL6+uzuQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70586007)(7696005)(70206006)(356005)(316002)(8676002)(8936002)(47076005)(336012)(426003)(16526019)(26005)(86362001)(4326008)(36860700001)(44832011)(5660300002)(83380400001)(186003)(1076003)(36756003)(2906002)(2616005)(40460700003)(110136005)(508600001)(82310400005)(54906003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:14.5566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a89a7fa-3f31-4eee-4f1e-08da1c7bdd54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6012
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the current logic for (de)activate AVIC into helper functions,
and also add logic for (de)activate x2AVIC. The helper function are used
when initializing AVIC and switching from AVIC to x2AVIC mode
(handled by svm_refresh_spicv_exec_ctrl()).

When an AVIC-enabled guest switches from APIC to x2APIC mode during
runtime, the SVM driver needs to perform the following steps:

1. Set the x2APIC mode bit for AVIC in VMCB along with the maximum
APIC ID support for each mode accodingly.

2. Disable x2APIC MSRs interception in order to allow the hardware
to virtualize x2APIC MSRs accesses.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/avic.c    | 48 ++++++++++++++++++++++++++++++++++----
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 4c26b0d47d76..13d315b4eaba 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -256,6 +256,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 01392b8364f4..462a1801916d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -66,6 +66,45 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
+static inline void avic_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable)
+{
+	int i;
+
+	for (i = 0x800; i <= 0x8ff; i++)
+		set_msr_interception(&svm->vcpu, svm->msrpm, i,
+				     !disable, !disable);
+}
+
+static void avic_activate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+
+	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
+		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
+		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
+		/* Disabling MSR intercept for x2APIC registers */
+		avic_set_x2apic_msr_interception(svm, false);
+	} else {
+		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
+		/* Enabling MSR intercept for x2APIC registers */
+		avic_set_x2apic_msr_interception(svm, true);
+	}
+}
+
+static void avic_deactivate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+
+	/* Enabling MSR intercept for x2APIC registers */
+	avic_set_x2apic_msr_interception(svm, true);
+}
 
 /* Note:
  * This function is called from IOMMU driver to notify
@@ -183,13 +222,12 @@ void avic_init_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+		avic_activate_vmcb(svm);
 	else
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+		avic_deactivate_vmcb(svm);
 }
 
 static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
@@ -1009,9 +1047,9 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 		 * accordingly before re-activating.
 		 */
 		avic_apicv_post_state_restore(vcpu);
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+		avic_activate_vmcb(svm);
 	} else {
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+		avic_deactivate_vmcb(svm);
 	}
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
-- 
2.25.1

