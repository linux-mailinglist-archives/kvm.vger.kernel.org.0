Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141A3519863
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345572AbiEDHht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345580AbiEDHf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D21167CF;
        Wed,  4 May 2022 00:32:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RA1L3WubjLQcBEjT8K18sfXu/u2S3MfF/HUv9yAqd3V7By8HERzvm11+4ZHAMF1kwpN85f7vLOyXqDTCR7hyUoeVrP1uxJoGFvQAIRFMbQth/Gf5qCi+v6a0s/tmEhh8RO49ooeuKvZOU9IA2LgzUQO3FLyMfo8UNQG8TcpXyqgVavj3Nv04OdDCvtWUMdbSrGUVASGuNfc8Frv11KnwupebFcRGDgBXpCtNzJzLIN1lBSj5QbyBa0G2hxPEFZr9LK98kd3Yu2hOff1CYSmlYwgOk8djsRBZ5p+lSmIC404gooAIis3j+FwJ1kIUxB6we8fDhWQk61JbRP1NuHLaVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ov6gHw0IlBX4iVrryGtn3CYv0dj3odyCW2qaAsuQyaE=;
 b=KtidxtW3PJaH75XnsBIFbK+4ItAYgnecc2CgFMvVHI6nnznQ5gvnWDA6UFSsnu2UHxlzOHdOgpTLwLUCnLXYNObvjEzU71GNzgn8VjWoscG0cPd1DIqrcY0hJc3F+WGP2KDdxf0PrOJURFujSf+QDyidz+6s3dABcTOGgCQNtkl4WFyq5BMtAZvVYQMaM9d+mWoZCfwqtB0Og1CDzBkZBm/KPOsQhV7KhPNM4LUzRVoJeVWacSTC+PWw05JYQkLc/V4TkSjJ8/eiFWASUcU8eDUBurdKvR6r5GCFHYTXlC6ZZ3qY2TLTGOVOnYYY16WJ9jHPcdjTuLv+DUf4wij/OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ov6gHw0IlBX4iVrryGtn3CYv0dj3odyCW2qaAsuQyaE=;
 b=heRVr0pO1uqeJ+UHJ3vTP211EEjPZSlR0sHswGuyCp7SqEa3Nf3c8n2iMk8FMXjfDRqyK0Kr5IHrzKxlkk5+Oo/pzfc6AV9ogS+9hponAsuVZ0TAsmwvV7faQRKYL0KRwsH1qbfD9Ueh+nKdbRimqnNH2IbE2rtX0hrxc0TNTaE=
Received: from BN9P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::20)
 by MN0PR12MB5858.namprd12.prod.outlook.com (2603:10b6:208:379::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:32:04 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::63) by BN9P220CA0015.outlook.office365.com
 (2603:10b6:408:13e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
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
 2022 02:31:58 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v3 09/14] KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
Date:   Wed, 4 May 2022 02:31:23 -0500
Message-ID: <20220504073128.12031-10-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7b111c4e-8d60-4e0d-bc71-08da2da02f57
X-MS-TrafficTypeDiagnostic: MN0PR12MB5858:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB5858096DF0E2ACB79AB84192F3C39@MN0PR12MB5858.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zh7IM3BOoWPissLcTy/0E+bcrbG4OytbosD4dUNfIBPqxokZIUmn9oTMCeTzS617r884NDvxqmamNCU5MpN5s2ug5Gc3QtmESeAPJyvt7CPm+WqvYkaMHHxRBnMMxpWbsxFqo4FegOx+ySAg1IeTz9sEG8AV4Moc8qfT6YGoGXnuva/DG8G7vcug7fpxD3r4dGVN+cMR55I0JfCQ0G5B5Wo5ItmCPzjsN+pepb5tWjBIOjDih76LOYGuuMyXQorQ8yGlLhlZY+s0dUm92M7EjFayzG5bw2mueatH0FXbV+dRSD2eUqAEllIuQp1kezQvEgTxK3LRaybOp5mQ0ljZFzAH2ZgWf7G2Fy+F7kZu9wBgsueRuaX5GMsrFtAGlCBiQwRcRLIK0IkpP7XivupZIJZdl1/jXFgCzL+tumgCoK8eqCrLB8agI4Jj3Q19/i2mlh49m4Iee+Hu8ErTbBo9TSN7PPuZVuI3aBb8l3pNvyeG8tA13TRTbJTeZQB/b/NwOsVqJ5c4keC8o1bg8pLZ80/Se1e2OTdo/M/sNapAaA/bElAbdeQffL6FTpZdiacsnVdD8ohX5lO9bjF5LkV4163YNpIfxndXb/QPX8sFlPQq7nNg8s0y2TORDTZ7TfwKxDhm4l6mAGFAsgssZx0HK4oh+f8f0z5M3cQfh9mskX2+wUKT4b6DhvvHXO46ISwzuM7YKFh/mZa8RarGY1l+NA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(7696005)(426003)(81166007)(336012)(83380400001)(40460700003)(356005)(47076005)(26005)(316002)(86362001)(186003)(16526019)(44832011)(5660300002)(82310400005)(1076003)(36860700001)(8936002)(36756003)(4326008)(70586007)(6666004)(70206006)(8676002)(110136005)(54906003)(2906002)(508600001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:32:03.7861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b111c4e-8d60-4e0d-bc71-08da2da02f57
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5858
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
 arch/x86/include/asm/svm.h |  6 +++++
 arch/x86/kvm/svm/avic.c    | 54 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.c     |  6 ++---
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 4c26b0d47d76..f5525c0e03f7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -256,6 +256,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID
@@ -500,4 +501,9 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
 
+struct svm_direct_access_msrs {
+	u32 index;   /* Index of the MSR */
+	bool always; /* True if intercept is initially cleared */
+};
+
 #endif
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d185dd8ddf17..f255ca221e56 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -69,6 +69,51 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
+static inline void avic_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable)
+{
+	int i;
+
+	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
+		int index = direct_access_msrs[i].index;
+
+		if ((index < APIC_BASE_MSR) ||
+		    (index > APIC_BASE_MSR + 0xff))
+			continue;
+		set_msr_interception(&svm->vcpu, svm->msrpm, index,
+				     !disable, !disable);
+	}
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
@@ -185,13 +230,12 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
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
@@ -1086,9 +1130,9 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
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
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9066568fd19d..96a1fc1a1d1b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -74,10 +74,8 @@ static uint64_t osvw_len = 4, osvw_status;
 
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
-static const struct svm_direct_access_msrs {
-	u32 index;   /* Index of the MSR */
-	bool always; /* True if intercept is initially cleared */
-} direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
+const struct svm_direct_access_msrs
+direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
 	{ .index = MSR_STAR,				.always = true  },
 	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
 	{ .index = MSR_IA32_SYSENTER_EIP,		.always = false },
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5ed958863b81..bb5bf70de3b2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -600,6 +600,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
+extern const struct svm_direct_access_msrs direct_access_msrs[];
 
 /* avic.c */
 
-- 
2.25.1

