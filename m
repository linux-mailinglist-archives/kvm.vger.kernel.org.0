Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DD372B6E3
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbjFLEwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbjFLEvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:51:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20202E47;
        Sun, 11 Jun 2023 21:51:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOIEUdMsOj8hOgySfwQ2RdLKhup8IVFulmYG4yvtApT9ffmG/l6UajfGEb1RrxVl6zWTYOxAbALJcuGjgiCUq0Qtn7xrEtdjjyFJtyX3DBak1NpgVnxU+4/iGFN0/am+JrEI3BPpIT2qGkJC5X4roUO5wBaUr1OjvdHIl7JZfDMckW35DyVw2ETqyzrzgdJd9uh+yfZUE7HOC7xHYV940v/s3qobHEh/08OJ6L6ULDwMQx8dYaAeGq04HYu3H33yFwvMDPzq4xFPTEKcYpOf3l1YvZQ64flcDiMr9LSwFnfJGqgM5NtllGQpcOo4o4lUbNmRT+YOBY+YWEdpkHvznw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sr6+Hk4gRHkhZVI0+Aeq+AC5gkb36b1EgW2twd01CQE=;
 b=T/mV2JqVACQ6fXEJ5qT+X3J9J7iGpVcUG6s8lrVffGraGcz49uZJUJOuRwQvZkLxZfcwUWpnQ17Jio51DWRcezFpR9wX9qrxQcfEM2nvqjOZAE/ficnbGlsQTxmdDO7Zr6cTgnc09CKN1sqN6yPCDKNlM/hjGDgbY83E7cd5l0JYiFDnbj15T/Mc59GBJ/Dg6YTgXDv8otczgBNOcHainYkJV4BHzFJYW/Lm6P3jDuzsLuAhPv1MSo99ua/kNC9v3f3BZSLQrU74Jfru/TcbZOWZpZ4/BEGIbiZrDgrEXrfQEDejiazan0JA9M1KX2gV822HUqdd2BHrRxIRmVfZpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sr6+Hk4gRHkhZVI0+Aeq+AC5gkb36b1EgW2twd01CQE=;
 b=pLdYNgLYg+/X2h1XNhNzHUPLzuOvpJSxrngrfhOmCIfZVfpIajYCtXY0NxR/EeFnSuo1PvSBqc6kigyVODrFQkfJQj5/z6bXWgFOkvA98UJAUgAvHzOdWMRHunIPvYvTrn+4cL5ZDuxAcub/My2C/fpkg78SJ9tE9ZrhJhi29Gw=
Received: from SN6PR08CA0015.namprd08.prod.outlook.com (2603:10b6:805:66::28)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 04:51:28 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:805:66:cafe::b2) by SN6PR08CA0015.outlook.office365.com
 (2603:10b6:805:66::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:51:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:51:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:51:27 -0500
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
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 42/51] KVM: SVM: Support SEV-SNP AP Creation NAE event
Date:   Sun, 11 Jun 2023 23:25:50 -0500
Message-ID: <20230612042559.375660-43-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: de353946-87cc-4705-43d2-08db6b00aed2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A01qHqeaqr7WQHFaxyhfcQuUVQi4v+0mACbGK9FYIM7NgLO03D19Yp4b5+QbUWK+VxSRqmPvhrrHy2tp4FKcocl02gnKrFei+gJj4HJdje8ZpwmjfFeQZQ/f5dT2/22sZMhFUIFN5RH/m+r/vACzduamkSdKdNLYQwGZXzmfhBOHgV3zagLsBPwR1NiOnFNyymvSYAR1SxXyMmHZQZ/I+FtZisKLv72QmMGB5/XMuSuEvT3wy/s0yGTUTPZvxqr/LsI1IoM4IhCInysEgixDJqPtbInkn6by57a2sW5XfhTzsqvGd7FdfnYdvqdELdnHUoMGbMp+dhelbpY1OE6YV5WrANbC0ZVsdLmzFXlba5qo1peUiO86CiOZKFUb2tjwnw+eA4aQogxhftp97ea9q5/ZnhL0UVI9i7DqhGsQmjFaIfImSl8+YZvWjQ/VKp+eYbSia/OftU/tyy7BwU9zb5C6V8TqDpSaCOk3WCQOYgTvHaspY5205D18kAwCc3+7UUI1cuvTjP0VpO4NMsqdj8XmdiXD2sYA5ZTMEjYNbOvH/MzJ6aKegbW+mzqiY6z19o78xTGei4iJ5simbMw3gR7i0j5wVw6+OCS2qxztLNZ8dWuanIwIrGxgC4ii2jLoIchYGo4vqK4VzMVhmH3htXBpai/KqPdSnt4P0I/WX85iLlUsPtuxT+ATz1sGYYVHSRu7cgztMDv99EZ1v22NnrTac1StkrGE5NpurxDQPEohllADAtplOnyKXfkPMyVKI04nGzTvse/RC6m/eGo65A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(82310400005)(7406005)(7416002)(40460700003)(316002)(8676002)(41300700001)(82740400003)(83380400001)(5660300002)(26005)(40480700001)(81166007)(1076003)(356005)(6666004)(36860700001)(8936002)(44832011)(36756003)(336012)(4326008)(426003)(6916009)(70586007)(47076005)(70206006)(478600001)(186003)(16526019)(30864003)(2906002)(54906003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:51:27.9463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de353946-87cc-4705-43d2-08db6b00aed2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
 arch/x86/include/asm/svm.h      |   7 +-
 arch/x86/kvm/svm/sev.c          | 240 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   3 +
 arch/x86/kvm/svm/svm.h          |   8 +-
 arch/x86/kvm/x86.c              |  11 ++
 6 files changed, 268 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2fcd309fd9fb..8f515e0386a0 100644
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
index ac8edfdd60fa..0deb83ac800b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -288,7 +288,12 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 
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
index 111e43eede15..ec74ff5e09c7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -638,6 +638,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
 
 	/* Check some debug related fields before encrypting the VMSA */
@@ -683,6 +684,12 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
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
 
@@ -3034,6 +3041,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		if (lower_32_bits(ghcb_get_sw_exit_info_1(ghcb)) != SVM_VMGEXIT_AP_DESTROY)
+			if (!ghcb_rax_is_valid(ghcb))
+				goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -3259,6 +3271,220 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
 	return 1; /* resume */
 }
 
+static kvm_pfn_t gfn_to_pfn_gmem(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+	kvm_pfn_t pfn;
+	int order = 0;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_err("SEV: Failure retrieving restricted memslot for GFN 0x%llx, flags 0x%x, userspace_addr: 0x%lx\n",
+		       gfn, slot->flags, slot->userspace_addr);
+		return INVALID_PAGE;
+	}
+
+	if (!kvm_mem_is_private(kvm, gfn)) {
+		pr_err("SEV: Failure retrieving restricted PFN for GFN 0x%llx\n", gfn);
+		return INVALID_PAGE;
+	}
+
+	if (kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order)) {
+		pr_err("SEV: Failure retrieving restricted PFN for GFN 0x%llx\n", gfn);
+		return INVALID_PAGE;
+	}
+
+	return pfn;
+}
+
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
+		/*
+		 * The VMSA is referenced by the hypervisor physical address,
+		 * so retrieve the PFN and ensure it is restricted memory.
+		 */
+		pfn = gfn_to_pfn_gmem(vcpu->kvm, gpa_to_gfn(svm->sev_es.snp_vmsa_gpa));
+		if (!VALID_PAGE(pfn) || is_error_pfn(pfn))
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
@@ -3508,6 +3734,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->vmgexit.ghcb_msr = ghcb_gpa;
 		vcpu->arch.complete_userspace_io = snp_complete_psc;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		ret = sev_snp_ap_creation(svm);
+		if (ret) {
+			ghcb_set_sw_exit_info_1(ghcb, 1);
+			ghcb_set_sw_exit_info_2(ghcb,
+						X86_TRAP_GP |
+						SVM_EVTINJ_TYPE_EXEPT |
+						SVM_EVTINJ_VALID);
+		}
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
@@ -3612,6 +3850,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->sev_es.snp_vmsa_mutex);
 }
 
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 77195d8c1aa3..81b9f4e04a8d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1358,6 +1358,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
+	if (init_event)
+		sev_snp_init_protected_guest_state(vcpu);
+
 	init_vmcb(vcpu);
 
 	if (!init_event)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8dc7946ab634..e73a58e489c7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -94,6 +94,7 @@ struct kvm_sev_info {
 	atomic_t migration_in_progress;
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
+	u64 sev_features;	/* Features set at VMSA creation */
 };
 
 struct kvm_svm {
@@ -208,6 +209,10 @@ struct vcpu_sev_es_state {
 	bool ghcb_sa_free;
 
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
+	gpa_t snp_vmsa_gpa;
+	bool snp_ap_create;
 };
 
 struct vcpu_svm {
@@ -735,7 +740,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 extern unsigned int max_sev_asid;
 
@@ -764,6 +769,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 10d76afa23d9..9e3c41e2a3ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10621,6 +10621,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
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
@@ -12816,6 +12824,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
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

