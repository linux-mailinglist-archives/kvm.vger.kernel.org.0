Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F6A55281F
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347613AbiFTXSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347384AbiFTXRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:17:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2B2242;
        Mon, 20 Jun 2022 16:14:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/boCKCtktUx+VebArDrRhV+1pC6Apw1GL9cD1Tl8LgRK6iMPJhTCXKo2K0XaWytiYzaYDiBHGAGhVCwBQnAKEVHKYc2gRcMTQB9KRPSQoBLlhzuF+VqeslyCUEgP8t0KQ+fgpyqGShyxfgslfS/vMWfgu5HTUsROpWCV/WjbS4eQ/VOz38hVW3sj2luo/UYGhWRzvKEm/hiT9NZektjBPheXdcr+qLbXImuMQfxVcCx0GTFjWah87thxx25GwHZ7p6qzEUC0hX+fwG4R2A+d/2HZht6wMja1nXFeef5VNzFGJqeus9n+JHGxkaBfww4P/VBsH4zrjEXyXZ9xQOFvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xv2AUZVKvUruMRliZJeTqQ9YjePYiJVEjFWirEuT34=;
 b=jnjha9Z/pLUBul92GIMRYd9jaaPfeJUB2MonuKhPOV98rg5yymCp2uf+TCHnCb3M4fV2CL8jsVf2GAtmjIfx0p6pmxiltA654ZJYlz1/OvUHTXF3czw+4xkR1EAUwWUsUWPyVKQetsfNLd8ZoMyhZyVlyMpUV8DsBZ9AIgFNLjercN+4/rM7ZO+gf0aEG/tcysJinomdVduFf60CZCY92PRQHvkbVDmqdLE/aGfS3wlZw7gfh2h4PsLs0KClPvnb1OKpbyG6nrXh3ioRFytXNoVJJ5bIWUpLOTC5KWyEWjhWtb9Lo/zgsXKLipyCKAAuyviDDsg8I5rl3kEltKaQbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xv2AUZVKvUruMRliZJeTqQ9YjePYiJVEjFWirEuT34=;
 b=fcy9sgrtkblFzcpNsQKA8qrrL5JzSNumyn9wEDmf9swXdK5XMueRkODJkXOf+kn14x3AwbFP2K49+wUp1GaxntT5kQOp+v5bHlYPwpoZdyr2FjX8gzhYz/OPRGwH+7L8QK+SuKsgqHtdtbb/e3bPKQjf/pF6hSuJGdqY76Su0ZM=
Received: from SN4PR0701CA0037.namprd07.prod.outlook.com
 (2603:10b6:803:2d::32) by CH2PR12MB5532.namprd12.prod.outlook.com
 (2603:10b6:610:6d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 23:14:24 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:803:2d:cafe::a1) by SN4PR0701CA0037.outlook.office365.com
 (2603:10b6:803:2d::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:14:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:14:23 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:14:21 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 44/49] KVM: SVM: Support SEV-SNP AP Creation NAE event
Date:   Mon, 20 Jun 2022 23:14:12 +0000
Message-ID: <ca0055ea49a36fcbc618f318083da5e062cccdb5.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f47cb08-3599-4ff4-46e6-08da53129d57
X-MS-TrafficTypeDiagnostic: CH2PR12MB5532:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB5532C87A4E80EE46FF87E2D68EB09@CH2PR12MB5532.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fFJuFiDWhCW+favHdnyFYMn5zWAKa0GcE1PsivEA1I9GQFGIWq06kG2pUZByPeNUMjrI4R/fAukPwFkLIiiDxBhPEzUn5jX8XpTh9pxrUn4o/mX1CjWtdeRxKPE+FZMgdeADBpDCr1L9Qm+lVVt6lTYSocpI9v/VdSrYE6MhQUJXIq60RsrTcPgzK1K2GGzJ0OiE6JZ9HmPv+naucah4JuXCC8OkxD6kP8e79vGAqVvFCPNBAhKeDDXVIHMN1LYME02fA5QpZGF2iHhZ6jpDV/6sv6lSyKg120o0r1vm6nuqNhVjqXd3BfSE4jcThmCCq06N4LZ8iLVBCFJzJbRw+7hrpoO9WAz/ApWIoQzUZD6ErY5v19j7HvMdwyrJJtix8jPZFf+z3WR+RJFJl953D72kmxhUB/zpDvBWEK+s44Zbbog98TimQ1FBIjy8wud/5PHesYjjtE67gfMB/rjbWgM2B9r9YgE9dKyQhhHR5Hx6PnTbWmWvCV/t7hKS6e8UUPORiSAsTRn4c48BRRq/wsO65pOlWNmhmO+MQ+4wBJeSvCiKfdCClB7OzIM+jZpkIzkI53Gpcz0glA1L5gP/bKIMjeqLcew9RWj6VD/oRR3ZJinEloY2B4Y3FoIlZ0qsPvBQfJzFNxVhzKDE/UIgmTEXf2M+F0Bq+ARyqwyrE+COoJ9JF9v12Zcgcq233NDxrjdXTPNp9dr6Hpm9g/cGcGxei9FZxzgkmmOxkhvpZbfj9Cec0foAHL8TuP2OYp3lf31GQ9dz0wQ5AQj8rR7CNg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(36840700001)(40470700004)(46966006)(54906003)(36756003)(40480700001)(70206006)(6666004)(336012)(70586007)(316002)(47076005)(7696005)(8936002)(186003)(2616005)(82310400005)(30864003)(4326008)(16526019)(110136005)(5660300002)(8676002)(82740400003)(356005)(2906002)(7406005)(83380400001)(40460700003)(36860700001)(81166007)(7416002)(26005)(41300700001)(478600001)(426003)(86362001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:14:23.9512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f47cb08-3599-4ff4-46e6-08da53129d57
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5532
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
guests to alter the register state of the APs on their own. This allows
the guest a way of simulating INIT-SIPI.

A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
so as to avoid updating the VMSA pointer while the vCPU is running.

For CREATE
  The guest supplies the GPA of the VMSA to be used for the vCPU with
  the specified APIC ID. The GPA is saved in the svm struct of the
  target vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
  to the vCPU and then the vCPU is kicked.

For CREATE_ON_INIT:
  The guest supplies the GPA of the VMSA to be used for the vCPU with
  the specified APIC ID the next time an INIT is performed. The GPA is
  saved in the svm struct of the target vCPU.

For DESTROY:
  The guest indicates it wishes to stop the vCPU. The GPA is cleared
  from the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is
  added to vCPU and then the vCPU is kicked.

The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked
as a result of the event or as a result of an INIT. The handler sets the
vCPU to the KVM_MP_STATE_UNINITIALIZED state, so that any errors will
leave the vCPU as not runnable. Any previous VMSA pages that were
installed as part of an SEV-SNP AP Creation NAE event are un-pinned. If
a new VMSA is to be installed, the VMSA guest page is pinned and set as
the VMSA in the vCPU VMCB and the vCPU state is set to
KVM_MP_STATE_RUNNABLE. If a new VMSA is not to be installed, the VMSA is
cleared in the vCPU VMCB and the vCPU state is left as
KVM_MP_STATE_UNINITIALIZED to prevent it from being run.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   1 -
 arch/x86/include/asm/kvm_host.h    |   3 +-
 arch/x86/include/asm/svm.h         |   7 +-
 arch/x86/kvm/svm/sev.c             | 197 +++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |   5 +-
 arch/x86/kvm/svm/svm.h             |   6 +
 arch/x86/kvm/x86.c                 |   9 +-
 7 files changed, 221 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 2dd2bc0cf4c3..e0068e702692 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -130,7 +130,6 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL(rmp_page_level_adjust)
-KVM_X86_OP(update_protected_guest_state)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1db4d178eb1d..660cf39344fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -105,6 +105,7 @@
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(32)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1524,8 +1525,6 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 
 	void (*rmp_page_level_adjust)(struct kvm *kvm, kvm_pfn_t pfn, int *level);
-
-	int (*update_protected_guest_state)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 284a8113227e..a69b6da71a65 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -263,7 +263,12 @@ enum avic_ipi_failure_cause {
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
-#define SVM_SEV_FEAT_SNP_ACTIVE		BIT(0)
+#define SVM_SEV_FEAT_SNP_ACTIVE			BIT(0)
+#define SVM_SEV_FEAT_RESTRICTED_INJECTION	BIT(3)
+#define SVM_SEV_FEAT_ALTERNATE_INJECTION	BIT(4)
+#define SVM_SEV_FEAT_INT_INJ_MODES		\
+	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
+	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d5584551f3dd..bb7d4547df81 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -657,6 +657,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
 
 	/* Check some debug related fields before encrypting the VMSA */
@@ -702,6 +703,12 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	if (sev_snp_guest(svm->vcpu.kvm))
 		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
+	/*
+	 * Save the VMSA synced SEV features. For now, they are the same for
+	 * all vCPUs, so just save each time.
+	 */
+	sev->sev_features = save->sev_features;
+
 	return 0;
 }
 
@@ -3090,6 +3097,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		if (!ghcb_rax_is_valid(ghcb))
+			goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -3672,6 +3683,178 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
 }
 
+static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	kvm_pfn_t pfn;
+	hpa_t cur_pa;
+
+	WARN_ON(!mutex_is_locked(&svm->sev_es.snp_vmsa_mutex));
+
+	/* Save off the current VMSA PA for later checks */
+	cur_pa = svm->sev_es.vmsa_pa;
+
+	/* Mark the vCPU as offline and not runnable */
+	vcpu->arch.pv.pv_unhalted = false;
+	vcpu->arch.mp_state = KVM_MP_STATE_STOPPED;
+
+	/* Clear use of the VMSA */
+	svm->sev_es.vmsa_pa = INVALID_PAGE;
+	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
+
+	if (cur_pa != __pa(svm->sev_es.vmsa) && VALID_PAGE(cur_pa)) {
+		/*
+		 * The svm->sev_es.vmsa_pa field holds the hypervisor physical
+		 * address of the about to be replaced VMSA which will no longer
+		 * be used or referenced, so un-pin it.
+		 */
+		kvm_release_pfn_dirty(__phys_to_pfn(cur_pa));
+	}
+
+	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
+		/*
+		 * The VMSA is referenced by the hypervisor physical address,
+		 * so retrieve the PFN and pin it.
+		 */
+		pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(svm->sev_es.snp_vmsa_gpa));
+		if (is_error_pfn(pfn))
+			return -EINVAL;
+
+		/* Use the new VMSA */
+		svm->sev_es.vmsa_pa = pfn_to_hpa(pfn);
+		svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
+
+		/* Mark the vCPU as runnable */
+		vcpu->arch.pv.pv_unhalted = false;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+		svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+	}
+
+	/*
+	 * When replacing the VMSA during SEV-SNP AP creation,
+	 * mark the VMCB dirty so that full state is always reloaded.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
+	return 0;
+}
+
+/*
+ * Invoked as part of svm_vcpu_reset() processing of an init event.
+ */
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int ret;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
+
+	if (!svm->sev_es.snp_ap_create)
+		goto unlock;
+
+	svm->sev_es.snp_ap_create = false;
+
+	ret = __sev_snp_update_protected_guest_state(vcpu);
+	if (ret)
+		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
+
+unlock:
+	mutex_unlock(&svm->sev_es.snp_vmsa_mutex);
+}
+
+static int sev_snp_ap_creation(struct vcpu_svm *svm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_vcpu *target_vcpu;
+	struct vcpu_svm *target_svm;
+	unsigned int request;
+	unsigned int apic_id;
+	bool kick;
+	int ret;
+
+	request = lower_32_bits(svm->vmcb->control.exit_info_1);
+	apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
+
+	/* Validate the APIC ID */
+	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
+	if (!target_vcpu) {
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP APIC ID [%#x] from guest\n",
+			    apic_id);
+		return -EINVAL;
+	}
+
+	ret = 0;
+
+	target_svm = to_svm(target_vcpu);
+
+	/*
+	 * We have a valid target vCPU, so the vCPU will be kicked unless the
+	 * request is for CREATE_ON_INIT. For any errors at this stage, the
+	 * kick will place the vCPU in an non-runnable state.
+	 */
+	kick = true;
+
+	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
+
+	target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+	target_svm->sev_es.snp_ap_create = true;
+
+	/* Interrupt injection mode shouldn't change for AP creation */
+	if (request < SVM_VMGEXIT_AP_DESTROY) {
+		u64 sev_features;
+
+		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
+		sev_features ^= sev->sev_features;
+		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
+				    vcpu->arch.regs[VCPU_REGS_RAX]);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	switch (request) {
+	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
+		kick = false;
+		fallthrough;
+	case SVM_VMGEXIT_AP_CREATE:
+		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
+				    svm->vmcb->control.exit_info_2);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
+		break;
+	case SVM_VMGEXIT_AP_DESTROY:
+		break;
+	default:
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
+			    request);
+		ret = -EINVAL;
+		break;
+	}
+
+out:
+	if (kick) {
+		if (target_vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)
+			target_vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
+		kvm_vcpu_kick(target_vcpu);
+	}
+
+	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
+
+	return ret;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3937,6 +4120,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_AP_CREATION:
+		ret = sev_snp_ap_creation(svm);
+		if (ret) {
+			svm_set_ghcb_sw_exit_info_1(vcpu, 1);
+			svm_set_ghcb_sw_exit_info_2(vcpu,
+						    X86_TRAP_GP |
+						    SVM_EVTINJ_TYPE_EXEPT |
+						    SVM_EVTINJ_VALID);
+		}
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
@@ -4024,6 +4219,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->sev_es.snp_vmsa_mutex);
 }
 
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f7155abe7567..fced6ea423ad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1237,6 +1237,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
+	if (init_event)
+		sev_snp_init_protected_guest_state(vcpu);
+
 	init_vmcb(vcpu);
 
 	if (!init_event)
@@ -4749,8 +4752,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.rmp_page_level_adjust = sev_rmp_page_level_adjust,
-
-	.update_protected_guest_state = sev_snp_update_protected_guest_state,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 46790bab07a8..971ff4e949fd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -100,6 +100,8 @@ struct kvm_sev_info {
 	spinlock_t psc_lock;
 	void *snp_certs_data;
 	struct mutex guest_req_lock;
+
+	u64 sev_features;	/* Features set at VMSA creation */
 };
 
 struct kvm_svm {
@@ -217,6 +219,10 @@ struct vcpu_sev_es_state {
 	u64 ghcb_sw_exit_info_2;
 
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex;
+	gpa_t snp_vmsa_gpa;
+	bool snp_ap_create;
 };
 
 struct vcpu_svm {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a1d16231e30..c649d15efae3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10095,6 +10095,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
+			kvm_vcpu_reset(vcpu, true);
+			if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
+				goto out;
+		}
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -12219,7 +12225,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return true;
 
-	if (kvm_apic_has_events(vcpu))
+	if (kvm_apic_has_events(vcpu) ||
+	    kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
 		return true;
 
 	if (vcpu->arch.pv.pv_unhalted)
-- 
2.25.1

