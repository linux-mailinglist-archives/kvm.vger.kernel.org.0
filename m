Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0687CA9FB
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbjJPNme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbjJPNmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:42:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D453113D;
        Mon, 16 Oct 2023 06:42:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TanYDP25SBtyafAmWDl45gTmhB2uJx7QOeft94QjxlBwFUXPJ2Uq0mGNfoFa1jV8CqQwaY80U76cKrqMjo/Ey8ngvtXsqxGtSALvv0XmhOlkM00h6lIzDnIM0CRMRHqeiJfAEtww1zXnNxckw4VVFksozgMC5avXk0XeocBusbicUW4O6d9LPjenrneDb7283C7CN/v8ZaDeR4WSRTfQ7x7+DqS1gB9bY631CLvthFp+FKq+2jbjy0cyssILDb0vzt6WGKT+swvR4FVTPOmgeiL6ga9mnE/6Vx2LdBXzlg5P+zkTJkxPD5yFgfsFJK48Y6ufBLtodHnUjnFrG9BcEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r45yJPVBsyi6Tp27ZkpOjiP1aawUlKlhwCwzfweavXM=;
 b=i4nT6E9S9+hUh5bAYGDgjtHjaBMImKpbRTk5CjnLMRdM4tatGJep33qf67Dtc0pQfQdjHtGn6f7EDPABEyRtwuDhLCsoz0ZGylpBkstZtMaUUy/axJFmLr3DMbGJW9YjG6F8K9JaZhBC/Q2KDzB4JyOjAwQL6mQQonhDugy0zuooKBTXYEp+m+51cJLWgmCHaEasLt62X5KPIYNaIynXuueUIQcCCpGBin6QA6TEk3RAxQ2dwOFXfTstvIgsaUeQ87gIZlOJdACF4ImURCzgW+BDFSw1ONtHUiEHnR+YeYGIw4e3z5/IqiQiooftJKZN01Vn6ElmNPxh1L/l5EdNXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r45yJPVBsyi6Tp27ZkpOjiP1aawUlKlhwCwzfweavXM=;
 b=DWrPYm5ieHD4fo8/DWlHRf7VvvTVd2tM8gvLvf8ZUT/zJDL8rDJT1BCZPPO/XophkY6fISt5eQbHm3LumIOkoZIq28XBWnqQI/Esj0N4cK9jm5Kwq/RDJzh1YMMTtwiaLbjqSxo1V7fQh3RSxJcaP3SworI6xFS8Ho/DoB2N49w=
Received: from SJ0PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:33a::13)
 by DS0PR12MB8816.namprd12.prod.outlook.com (2603:10b6:8:14f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:42:26 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::60) by SJ0PR03CA0008.outlook.office365.com
 (2603:10b6:a03:33a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34 via Frontend
 Transport; Mon, 16 Oct 2023 13:42:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:42:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:42:11 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 37/50] KVM: SEV: Support SEV-SNP AP Creation NAE event
Date:   Mon, 16 Oct 2023 08:28:06 -0500
Message-ID: <20231016132819.1002933-38-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|DS0PR12MB8816:EE_
X-MS-Office365-Filtering-Correlation-Id: 27b41b2a-6ac9-4b5a-8b7f-08dbce4dbb8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Csc9YgH+1BqbDMj3zurBRvBzOZiYq01ohkcyqDbwTheCU5b93o1FUK76uDOHbWuUFyRbz1e0mJSgyhXxwKqgGN6lqq248Rp8kdtqwLQ/3mrQXC88hGToG6qSSpRj+fHWY99/9RZcV/poAITC6luWJuMBCSb/QS8n74kPyA3BT3BPRtYpEke7VST67eH1pk65nMfDotKo8wV+jAIEZ0HoNh4sdXHZwWf6KwJ0+k7Nh6ZHGIKH8HwqSUNz7Z5JRA4OPBQBcNHQm/nF58bXT42XUcJnuhe54bj9wBuLp3hsN5iZ7+8BI7RgCmzIka2CtQBPS65jBZzo+s0N2sOjFKbD/Q/zPvIGluSK4u8SLWgp0DFBa87KadO5YG+9n6jzTk/wVMltjbQslTyaFonjiiajP8nGeYqAFcYS3h0gWu4HD0ZTO5CWQlh4brsIThGdnwJSpuZed7pkoAz3Sa92zkj6QMECkVTO3Ndw7Rw/Z++WsvN4m1ai6NtfFPkRDQfY00KVdjmj1ndLlia1u3p5HW9hNhx3O+P3/9W/HY7o4dPvUFcNnk7W5dPOB44HL+p5SpPIftHgPyZJ15EUeS33tkMKONnajw26pYyGs93GkDvysLjOY9LFpPuihZmjp0eDvumrsOaBXIouvOZ3mUTTeuIkKXPm5wF3dnpRmn39mog95s6Q/xWg2S43bqusFO93ri8bMamIxqGWYDBTD7HEb27mjOUsFMqmmt0Ox+iOtum2EBvQjDQFpBha3loWdM3P1J80cYoeyGmv0Hu+Htr8cYW+ag==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(82310400011)(1800799009)(186009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(70206006)(70586007)(2616005)(6916009)(54906003)(478600001)(316002)(7406005)(426003)(1076003)(336012)(26005)(16526019)(5660300002)(8676002)(8936002)(4326008)(30864003)(44832011)(2906002)(7416002)(41300700001)(86362001)(6666004)(36756003)(82740400003)(356005)(47076005)(83380400001)(36860700001)(81166007)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:42:12.7789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b41b2a-6ac9-4b5a-8b7f-08dbce4dbb8d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8816
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: add handling for restrictedmem]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/include/asm/svm.h      |   5 +
 arch/x86/kvm/svm/sev.c          | 219 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   3 +
 arch/x86/kvm/svm/svm.h          |   8 +-
 arch/x86/kvm/x86.c              |  11 ++
 6 files changed, 246 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b9e783d34e94..cd4bfe0b7deb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -113,6 +113,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index a901f1daaefc..3d5e61352290 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -290,6 +290,11 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 
 #define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
 #define SVM_SEV_FEAT_SNP_ACTIVE                        BIT(0)
+#define SVM_SEV_FEAT_RESTRICTED_INJECTION              BIT(3)
+#define SVM_SEV_FEAT_ALTERNATE_INJECTION	       BIT(4)
+#define SVM_SEV_FEAT_INT_INJ_MODES		\
+	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
+	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f36d72ca2cf7..e547adddacfa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -650,6 +650,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
 
 	/* Check some debug related fields before encrypting the VMSA */
@@ -698,6 +699,12 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	if (sev_snp_guest(svm->vcpu.kvm))
 		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
+	/*
+	 * Save the VMSA synced SEV features. For now, they are the same for
+	 * all vCPUs, so just save each time.
+	 */
+	sev->sev_features = save->sev_features;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -3076,6 +3083,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		if (lower_32_bits(control->exit_info_1) != SVM_VMGEXIT_AP_DESTROY)
+			if (!kvm_ghcb_rax_is_valid(svm))
+				goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -3295,6 +3307,202 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
 	return 1; /* resume */
 }
 
+static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	hpa_t cur_pa;
+
+	WARN_ON(!mutex_is_locked(&svm->sev_es.snp_vmsa_mutex));
+
+	/* Save off the current VMSA PA for later checks */
+	cur_pa = svm->sev_es.vmsa_pa;
+
+	/* Mark the vCPU as offline and not runnable */
+	vcpu->arch.pv.pv_unhalted = false;
+	vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
+
+	/* Clear use of the VMSA */
+	svm->sev_es.vmsa_pa = INVALID_PAGE;
+	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
+
+	/*
+	 * sev->sev_es.vmsa holds the virtual address of the VMSA initially
+	 * allocated by the host. If the guest specified a new a VMSA via
+	 * AP_CREATION, it will have been pinned to avoid future issues
+	 * with things like page migration support. Make sure to un-pin it
+	 * before switching to a newer guest-specified VMSA.
+	 */
+	if (cur_pa != __pa(svm->sev_es.vmsa) && VALID_PAGE(cur_pa))
+		kvm_release_pfn_dirty(__phys_to_pfn(cur_pa));
+
+	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
+		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
+		struct kvm_memory_slot *slot;
+		kvm_pfn_t pfn;
+
+		slot = gfn_to_memslot(vcpu->kvm, gfn);
+		if (!slot)
+			return -EINVAL;
+
+		/*
+		 * The new VMSA will be private memory guest memory, so
+		 * retrieve the PFN from the gmem backend, and leave the ref
+		 * count of the associated folio elevated to ensure it won't
+		 * ever be migrated.
+		 */
+		if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
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
+	 * The target vCPU is valid, so the vCPU will be kicked unless the
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
+		/*
+		 * Malicious guest can RMPADJUST a large page into VMSA which
+		 * will hit the SNP erratum where the CPU will incorrectly signal
+		 * an RMP violation #PF if a hugepage collides with the RMP entry
+		 * of VMSA page, reject the AP CREATE request if VMSA address from
+		 * guest is 2M aligned.
+		 */
+		if (IS_ALIGNED(svm->vmcb->control.exit_info_2, PMD_SIZE)) {
+			vcpu_unimpl(vcpu,
+				    "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M aligned\n",
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
@@ -3545,6 +3753,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->vmgexit.ghcb_msr = ghcb_gpa;
 		vcpu->arch.complete_userspace_io = snp_complete_psc;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		ret = sev_snp_ap_creation(svm);
+		if (ret) {
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+		}
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
@@ -3711,6 +3928,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->sev_es.snp_vmsa_mutex);
 }
 
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c04c554e5675..f5cdcbd1ba67 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1402,6 +1402,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
+	if (init_event)
+		sev_snp_init_protected_guest_state(vcpu);
+
 	init_vmcb(vcpu);
 
 	if (!init_event)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0ad76ed4d625..f81dfa1594f6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -96,6 +96,7 @@ struct kvm_sev_info {
 	atomic_t migration_in_progress;
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
+	u64 sev_features;	/* Features set at VMSA creation */
 };
 
 struct kvm_svm {
@@ -212,6 +213,10 @@ struct vcpu_sev_es_state {
 	bool ghcb_sa_free;
 
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
+	gpa_t snp_vmsa_gpa;
+	bool snp_ap_create;
 };
 
 struct vcpu_svm {
@@ -687,7 +692,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 extern unsigned int max_sev_asid;
 
@@ -717,6 +722,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 12f9e99c7ad0..8977f7f12a4a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10660,6 +10660,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
+			kvm_vcpu_reset(vcpu, true);
+			if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE) {
+				r = 1;
+				goto out;
+			}
+		}
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -12871,6 +12879,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 		return true;
 #endif
 
+	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
+		return true;
+
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
 	    kvm_guest_apic_has_interrupt(vcpu)))
-- 
2.25.1

