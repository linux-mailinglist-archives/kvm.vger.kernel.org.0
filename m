Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FD869D397
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbjBTS7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjBTS7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:59:30 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884AC212AE;
        Mon, 20 Feb 2023 10:58:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3/6td9cekTxOFdFxInRjniqfDUphz82Ckwi0T9opZ2Ku2QGL7h0deIDEl/lGl/Yb7QtBlZE5AYu6bYRDlfhuWOnLmvebs6OH3SepFoZmJMKwgSZdhersucsL1fr4iJjfFgYNQKp3cC6+9PT15HoUIq4/v2UuQRvUGCWIuzCevyDkniYR/0D7zhRnmS3dp4l3TF7/bYzrEEUPWyvsfzbtJ2Hc3P67kg4d6L2A6s7WNgIj8bQV4WY9Ul9wDLOgwrBsEiCr7WAJvb2eWPne3+HSmUmg3mtpUSKrDel1HH/PKXJENT65eMJCltNhtVsYJ8ZYmGOn9kbOnc0/GC5dhSZsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/JaN4o4GcF6leK1nTsDeWGcfPK3zSjcGLL5oef7NBQ=;
 b=MuAHSK6W+GX/Jool9aczJk+rvkUmtR/4P9agd+fhgwPXShq380PCfR/0xRUFTYqqJbJbg3L2n1j/gQf4ARqaKPcPr8ZkmyGOL6WBpm7kCTPQGFO2cYRTKcEkC+1nuwEpIMqxrNRboPyBX8ar0TQYhonozuFvDa3xH/O0fBWYnBebhDUi0BwDVxi9b38LFGbOWkdaNSCc5SFnvaVepM8px//JMyq2/UHOCTLdxMF2vuPXpZIe/PyZwuTwgoo/7G09cadVw0z1RDbS0BJLZK/YxNgmgDI6XI9Zh9e4m2NHdnoXFTOxFBTnqUI5XEtJxe7pQH4cJohgvo2FvqyoRfMU3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/JaN4o4GcF6leK1nTsDeWGcfPK3zSjcGLL5oef7NBQ=;
 b=RZO07Tz7XYDsbnyPuhvTYo9OFHY3PXKrR5Fm0XYT3aRHn9TcXJyRwHCfAQdVfTLS6z3w4wA5e1QTIz1YM62kTtMwUAkqLOf7/JxwZzYXqHfo2vHv5jL9NVCeO6q2JBrwwKzyrWhHdDXjNgAlQEjMPWH8mBaFzP5TUxc0zF1xT/0=
Received: from BL0PR01CA0007.prod.exchangelabs.com (2603:10b6:208:71::20) by
 PH8PR12MB7349.namprd12.prod.outlook.com (2603:10b6:510:217::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:57:54 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:71:cafe::f7) by BL0PR01CA0007.outlook.office365.com
 (2603:10b6:208:71::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:57:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:57:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:57:52 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 47/56] KVM: SVM: Support SEV-SNP AP Creation NAE event
Date:   Mon, 20 Feb 2023 12:38:38 -0600
Message-ID: <20230220183847.59159-48-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|PH8PR12MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: f9561e8a-d814-403f-9df9-08db13745f37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sivMQrKvsJTGUmIG3kvcy41ETPLPR6Uq+SFttuVWbzASIG0JgPYQe9dV688qAISLV7efVIxyG0hgunIWYGldpHhI9K+w5zphkXZwYBKoz+h7nJG6elKK+thAkpcZeUcsOSfixxb1OC1RWvZb3VlTfeD15I242EsABNfC1Sk3Q+fR10xZpb011iEbbgF/IZ6tV91mQIfrZAFbDAFcR5jQE4wLGVE64Gb20qRTrL5NTp7YJc59o/DxiV4EeX1ljaayLjoUAwMqMzDEgxVIZlIhKOYDiAGCXTeNIxIQDxOQlC9MgOkcUtxeKck77VBdJ0N5xk0zbCoBah9D99+2/RiltozSdamE8PCkw67X1X6uIJBQUGDiEpVVb3tm/wgK3s6l+MsSEdeJ2lYnYuEFvUxiXBFVVKmsRj2JNBcV5hpE8nKewXj1d0EjstFbMUUl2pRdXjBX3NG9S+IptscBRAoHFBfzCbFbaQo0WfTDIODLx9RgxyskjR09V6WrSsZkHbf+PShuUQOhUUJFd33Zn6XV+P08XFjdpiknpZkTvpw+OwYxXQRNtPAUs5QMxdcBkWRTK1hW+vvVYdH6D6oFmqy1PIwE3x3ytVBY5+CAxgWukLryuJE1s17pLa7SNvvHKP9VX+NIrf7Ml95rtzWSzkirg+27/mD8GvQdOiKULTR1sRpWN0op1kFDd4a7yiCN/FIzy4Fvg2sgLB8MRw2H8UWLlQX/7jG5VAEa15ZM82yBUA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(70206006)(40480700001)(40460700003)(6666004)(8936002)(30864003)(83380400001)(7416002)(7406005)(5660300002)(41300700001)(47076005)(44832011)(426003)(86362001)(16526019)(26005)(186003)(1076003)(8676002)(2906002)(70586007)(6916009)(316002)(4326008)(336012)(54906003)(478600001)(2616005)(356005)(36860700001)(36756003)(82310400005)(81166007)(82740400003)(66899018)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:57:53.2984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9561e8a-d814-403f-9df9-08db13745f37
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7349
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
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
 arch/x86/include/asm/svm.h      |   7 +-
 arch/x86/kvm/svm/sev.c          | 245 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   3 +
 arch/x86/kvm/svm/svm.h          |   7 +
 arch/x86/kvm/x86.c              |   9 ++
 6 files changed, 271 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 28b01cc7f64d..09b36462582c 100644
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
index c18d78d5e505..e76ad26ba64f 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -278,7 +278,12 @@ enum avic_ipi_failure_cause {
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
index 6bec2712ecc6..b2f1a12685ed 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -779,6 +779,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
 
 	/* Check some debug related fields before encrypting the VMSA */
@@ -824,6 +825,12 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
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
 
@@ -3161,6 +3168,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
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
@@ -3543,6 +3554,226 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, rc);
 }
 
+static kvm_pfn_t gfn_to_pfn_restricted(struct kvm *kvm, gfn_t gfn)
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
+	if (kvm_restrictedmem_get_pfn(slot, gfn, &pfn, &order)) {
+		pr_err("SEV: Failure retrieving restricted PFN for GFN 0x%llx\n", gfn);
+		return INVALID_PAGE;
+	}
+
+	put_page(pfn_to_page(pfn));
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
+		 * be used or referenced, so un-pin it. However, restricted
+		 * pages (e.g. via AP creation) should be left to the
+		 * restrictedmem backend to deal with, so don't release the
+		 * page in that case.
+		 */
+		if (!VALID_PAGE(gfn_to_pfn_restricted(vcpu->kvm,
+						      gpa_to_gfn(svm->sev_es.snp_vmsa_gpa))))
+			kvm_release_pfn_dirty(__phys_to_pfn(cur_pa));
+	}
+
+	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
+		/*
+		 * The VMSA is referenced by the hypervisor physical address,
+		 * so retrieve the PFN and ensure it is restricted memory.
+		 */
+		pfn = gfn_to_pfn_restricted(vcpu->kvm, gpa_to_gfn(svm->sev_es.snp_vmsa_gpa));
+		if (!VALID_PAGE(pfn))
+			return pfn;
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
@@ -3806,6 +4037,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
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
@@ -3910,6 +4153,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->sev_es.snp_vmsa_mutex);
 }
 
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 745f736d9c98..539926b07ee5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1349,6 +1349,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
+	if (init_event)
+		sev_snp_init_protected_guest_state(vcpu);
+
 	init_vmcb(vcpu);
 
 	if (!init_event)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b6ca6657aa6c..37bd7b728d52 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -95,6 +95,8 @@ struct kvm_sev_info {
 	void *snp_context;      /* SNP guest context page */
 	void *snp_certs_data;
 	struct mutex guest_req_lock; /* Lock for guest request handling */
+
+	u64 sev_features;	/* Features set at VMSA creation */
 };
 
 struct kvm_svm {
@@ -209,6 +211,10 @@ struct vcpu_sev_es_state {
 	bool ghcb_sa_free;
 
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex;
+	gpa_t snp_vmsa_gpa;
+	bool snp_ap_create;
 };
 
 struct vcpu_svm {
@@ -718,6 +724,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_adjust_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *level);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0154fc7a28c1..9872217e3a06 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10501,6 +10501,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
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
@@ -12698,6 +12704,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
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

