Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8343A398C7F
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhFBOS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:18:59 -0400
Received: from mail-dm3nam07on2088.outbound.protection.outlook.com ([40.107.95.88]:21280
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232331AbhFBOQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:16:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tcxmq0MXypIPh+bbvaOvG+Li4Mmt067NTJ+VgIN6X8pqC3sBaK1guTqqgrkv/5z17FyBInAsFfyz3vDoQ/VatAV3GQpkEY5zDaK1OkYzQcoBnFsbTaP0NJ1CQhAjHtaa6EQRY+C/u6CccNymnEAN9S9K7T7Cq3hWTWauHgs7GrnIU9zLTRTbV1Una6sLoCs8CF9DdLM3PySwpp/YGrcXzVgAdFgXGXYCygmQyzP2XKS2Ejq/tMrHzS7iBofiq5f6XhpciDdedVlfBCU6clnmXq3Jdyg9rJnNfzouhr3KsvIhx9sd2/q5JkhNHAf+eowD4ySUcY6sQNuRSFrrMu9pXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDVOLUpBzPLb9c3Q4JiKWyJakwdXbSVPLg+04RAfmfY=;
 b=KoRSXi8C3nwCFI8OalKFQHm6J7EAntyh2KJs3Y6hbeygrbariZ07M/7iLk6FTx1bQV5Xj6xsOrLaFWx1Jc86Vkxth5KbyGso+tPv3I1wxWD33T8PWwgRrUCrFyirG/UttwJAXMxFxLKm5AhymNlaAv/Y4PcL/WLFyPSAH14lC7kltPXJ2+byS8aEQxc58vimYPre7rCDhwu1GIOsVy+zZj3eCxOPp87T7dFooop4Xy1BNU+VgR1t5HfE618kPAtuiDnl8T8ZDBKGN0np72wsQHYrXj14PorlE4x12Qk+PQV1GYWSKO6iYA5c2YL8Pt/iv/RHp8diYRX7ELlN/b0+EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDVOLUpBzPLb9c3Q4JiKWyJakwdXbSVPLg+04RAfmfY=;
 b=AW42gtYpZEAxp6PgLs7OyE/ZjwX+NrNXqH0A5+1oKaNrv1pHUgoX3wBAWqwTaOgwYWR3Bct+5QBr156Ls9VH6Ym+kohcJYcFTP2VPfgpkPQ1zqIXDzqmzC/xxgvVOwqPoSiky+pGFI8yL3OKpMSPSj0r713AHGuagZWHwnvK9rc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 14:12:42 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:42 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 37/37] KVM: SVM: Support SEV-SNP AP Creation NAE event
Date:   Wed,  2 Jun 2021 09:10:57 -0500
Message-Id: <20210602141057.27107-38-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e41fe9e-8cbd-43ba-686d-08d925d06ceb
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45749B48B8D5D470990F9E56E53D9@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ty6/MjGAFJnUHJUZHz6RofM6ByFDpvzKo/U2lLwa7ShqmKiqJwc6WKLF8qTwCeyqncef1sxjud1UF32XTxY/h1Ii3EUeBU96SnbJivIi50Se7bTmylXrVAUb0Qxwdkx5Ve82cRJPutrXbcIgE7qoBZZXIBlGkDv+Cr/Osib1EefxAOfdRqILyQ6x8JQbLJIWIyKG5ckQPU3oLdY4Q0sugbSMpPzbcesRxW8tZqfi/BvFQwpSuzFpHYa+MHXd1CB2F3h0TjN8YgJm5jHAWkr3unm9eJTblcDWYqLpsb0Vxdri8gkvAS8iEQi/RllEDV1y6Y84GGqUmty9TZ0FmkWCPErUJxT0cB6P58Thjq7/r+eL35QfiT8X1lLiVAQptmvd1mM8PKmlXEd1RB0HnGZfeRo9gKTZAXyn92EtkMH2Li6b7j/DooTcHCfWAlvkNGqe/IH7z/KuxNKmxY+WKfdYQlxRnhrkqmwjJLvPMrepwB4vY6DXwCRm6zAtIW1mg8c6sj5/k6WeoL0UoKw9UNQ5YWbvH/sAgGz5bvEdsYz4fcrFbmTsq7Yo3NO6V8XkTlbnz1qt/hVAC2umlEGcEz6KSkxyO+ABeHo6OqYgdKRH3Dw9zsCmpX612nuIdnl+8haQsWOho5p3mF1/2urOMUJxLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(8936002)(7696005)(52116002)(956004)(478600001)(2616005)(66476007)(66946007)(2906002)(26005)(186003)(16526019)(7416002)(4326008)(1076003)(316002)(6666004)(38100700002)(38350700002)(66556008)(44832011)(83380400001)(8676002)(5660300002)(30864003)(6486002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FZGJxxgmMc1JEUL/qvozXPA9uYIPyKTO6omTlmGE/rg/dS/MVaWN1Da7Z/aK?=
 =?us-ascii?Q?RHYvwbNY3fa2Y2GrdPuwuLN+unVOjbj22TFkV5RiYoqiNpbBBjP9USl8m/TE?=
 =?us-ascii?Q?inOOoQJqJ3J02wOa/BIgbebutLbmxXexmm518gBCLyk1XrtIYtYcyROFROvb?=
 =?us-ascii?Q?yYeYO53rxN55D7PlXVmgvfI/m/Qi5ONqeTu0zZ9nmpzw4PKvEi8acotE2gTe?=
 =?us-ascii?Q?8uMbIJmB/9IrYIHiJl3mP1ySvdJ6pRBknAqHx4JSSwfbTjVrTVxiIv05ITKj?=
 =?us-ascii?Q?mZNeSOthdQeer7P1xf7KD7De7jalE2AlQOqP+6nhFBgj7Nfm6MpY54vwhXrc?=
 =?us-ascii?Q?EBBnPOTyTnlLFzsKSafMlBYpptglaB7G5hbRIJJktHajPGXXuhp4WMo+fBaW?=
 =?us-ascii?Q?dQg9IqWhk/c6uIVmlyAAWcjAh60nyl1HQTHSFyh4lETN0HpnZf/Orls8b4S2?=
 =?us-ascii?Q?dmnmqdKgvjp1D04vdkKlPiq7x7wd8KHJevLDRFpXn3KyoxHF87Rzzqzr5tpH?=
 =?us-ascii?Q?NvdUxOBaC6oyTFm8ak4IlUph9qCcYXwLKLcNREubCGSjW6Qt6emQQrj0xWWj?=
 =?us-ascii?Q?Phk9MMNbZ3kWy8rhnLqdogJWRe8RnrQ87S4cPX+Fy8SypH6QR69m/o/CX0W1?=
 =?us-ascii?Q?0F3R7DMR4sdyUbmayfk9qODo+mfaeIu30BB/M3Y6Dzbc/J/GZ+AYtClvcbAU?=
 =?us-ascii?Q?DImGW20eGRABK9TdqagE1jLMool7NBeYmtv5Yr/AxbZYDNKaB/fO5boIwQwv?=
 =?us-ascii?Q?ArsmYhMZiVoyz8Hu15Iqm9MtQlw8LRqtUAOiAHDDV86/it6jScscK0QeGbww?=
 =?us-ascii?Q?3lCH1N2rraG5EPAqZ3Hx5wDU12KkmYpV4ypZW8DmwtWr2oEDyHqs2k8SWhBE?=
 =?us-ascii?Q?u4oRFVBRvvlIJkwSVBWPFOiD2k6ZWG91+IOzmr56aAXWJaS9z/I+cn9THqva?=
 =?us-ascii?Q?WerWwm+Z7dRi6f3qDOdRysmUYvP4Zo9eVBLNxIHKsqAhfrLDcANPqkehcslp?=
 =?us-ascii?Q?3TAh3jUJgwAeYo5yrnD6RKVbUVGM4Doc6XIzAkLq6az0uTMsQB/GUxBh6Cyh?=
 =?us-ascii?Q?S4jKykcZkAPLknQ5H7pU3kaJ3GHpuXo9mCBRJbo+JY5lbJ9pxV3CVybK4+t8?=
 =?us-ascii?Q?ciGWc/dvEyOuZ9Mi+ZJ3+xhRTie9J2v2H/oS2Hvn7hEbap+XZUXe6co+mXZd?=
 =?us-ascii?Q?yMAO5HzC1yzwJFlkXmyGP6sGDs74Ij0Z4qtlAwewF2ZuSPOv2mTxMrjKpw+m?=
 =?us-ascii?Q?oo0aDHdQbpESknFTZVUbnioL9ZETG0lGAQ9LnVHxbBx9cH1KO3JWQWaPue9U?=
 =?us-ascii?Q?uxJPtcWjzmagTh1WXzu+NeHJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e41fe9e-8cbd-43ba-686d-08d925d06ceb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:16.2626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwm3lgLmk4Xqq0FEHRSqG3T7Tfcowksul+G28cbKz5BGUxq1avFYSl1h3vvWajcLkKQ9YnCS6F/sQsaOa3RnNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
guests to create and start APs on their own.

A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
so as to avoid updating the VMSA pointer while the vCPU is running.

For CREATE
  The guest supplies the GPA of the VMSA to be used for the vCPU with the
  specified APIC ID. The GPA is saved in the svm struct of the target
  vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added to the
  vCPU and then the vCPU is kicked.

For CREATE_ON_INIT:
  The guest supplies the GPA of the VMSA to be used for the vCPU with the
  specified APIC ID the next time an INIT is performed. The GPA is saved
  in the svm struct of the target vCPU.

For DESTROY:
  The guest indicates it wishes to stop the vCPU. The GPA is cleared from
  the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
  to vCPU and then the vCPU is kicked.


The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked as
a result of the event or as a result of an INIT. The handler sets the vCPU
to the KVM_MP_STATE_UNINITIALIZED state, so that any errors will leave the
vCPU as not runnable. Any previous VMSA pages that were installed as
part of an SEV-SNP AP Creation NAE event are un-pinned. If a new VMSA is
to be installed, the VMSA guest page is pinned and set as the VMSA in the
vCPU VMCB and the vCPU state is set to KVM_MP_STATE_RUNNABLE. If a new
VMSA is not to be installed, the VMSA is cleared in the vCPU VMCB and the
vCPU state is left as KVM_MP_STATE_UNINITIALIZED to prevent it from being
run.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/include/asm/svm.h      |   6 ++
 arch/x86/kvm/svm/sev.c          | 128 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   7 +-
 arch/x86/kvm/svm/svm.h          |   8 +-
 arch/x86/kvm/x86.c              |  11 ++-
 6 files changed, 160 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 117e2e08d7ed..881e05b3f74e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -91,6 +91,7 @@
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(31)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1402,6 +1403,8 @@ struct kvm_x86_ops {
 
 	int (*handle_rmp_page_fault)(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
 			int level, u64 error_code);
+
+	void (*update_protected_guest_state)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 65407b6d35a0..82242d871a88 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -213,6 +213,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
 
 #define SVM_SEV_FEATURES_SNP_ACTIVE		BIT(0)
+#define SVM_SEV_FEATURES_RESTRICTED_INJECTION	BIT(3)
+#define SVM_SEV_FEATURES_ALTERNATE_INJECTION	BIT(4)
+
+#define SVM_SEV_FEATURES_INT_INJ_MODES			\
+	(SVM_SEV_FEATURES_RESTRICTED_INJECTION |	\
+	 SVM_SEV_FEATURES_ALTERNATE_INJECTION)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 047f4dbde99b..05292985c49d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2653,6 +2653,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
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
@@ -3260,6 +3264,123 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 	return ret;
 }
 
+void sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	kvm_pfn_t pfn;
+
+	mutex_lock(&svm->snp_vmsa_mutex);
+
+	vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
+
+	/* Clear use of the VMSA in the sev_es_init_vmcb() path */
+	svm->vmsa_pa = 0;
+
+	/* Clear use of the VMSA from the VMCB */
+	svm->vmcb->control.vmsa_pa = 0;
+
+	/* Un-pin previous VMSA */
+	if (svm->snp_vmsa_pfn) {
+		kvm_release_pfn_dirty(svm->snp_vmsa_pfn);
+		svm->snp_vmsa_pfn = 0;
+	}
+
+	if (svm->snp_vmsa_gpa) {
+		/* Validate that the GPA is page aligned */
+		if (!PAGE_ALIGNED(svm->snp_vmsa_gpa))
+			goto e_unlock;
+
+		/*
+		 * The VMSA is referenced by thy hypervisor physical address,
+		 * so retrieve the PFN and pin it.
+		 */
+		pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(svm->snp_vmsa_gpa));
+		if (is_error_pfn(pfn))
+			goto e_unlock;
+
+		svm->snp_vmsa_pfn = pfn;
+
+		/* Use the new VMSA in the sev_es_init_vmcb() path */
+		svm->vmsa_pa = pfn_to_hpa(pfn);
+		svm->vmcb->control.vmsa_pa = svm->vmsa_pa;
+
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	} else {
+		vcpu->arch.pv.pv_unhalted = false;
+		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
+	}
+
+e_unlock:
+	mutex_unlock(&svm->snp_vmsa_mutex);
+}
+
+static void sev_snp_ap_creation(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_vcpu *target_vcpu;
+	struct vcpu_svm *target_svm;
+	unsigned int request;
+	unsigned int apic_id;
+	u64 sev_features;
+	u64 int_inj_mode;
+	bool kick;
+
+	request = lower_32_bits(svm->vmcb->control.exit_info_1);
+	apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
+
+	/* Validate the APIC ID */
+	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
+	if (!target_vcpu)
+		return;
+
+	target_svm = to_svm(target_vcpu);
+
+	/*
+	 * Restricted Injection mode and Alternate Injection mode are
+	 * not supported.
+	 */
+	sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
+	int_inj_mode = sev_features & SVM_SEV_FEATURES_INT_INJ_MODES;
+
+	kick = true;
+
+	mutex_lock(&target_svm->snp_vmsa_mutex);
+
+	target_svm->snp_vmsa_gpa = 0;
+	target_svm->snp_vmsa_update_on_init = false;
+
+	switch (request) {
+	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
+		if (!int_inj_mode) {
+			target_svm->snp_vmsa_update_on_init = true;
+			kick = false;
+		}
+		fallthrough;
+	case SVM_VMGEXIT_AP_CREATE:
+		if (!int_inj_mode) {
+			target_svm->snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
+			break;
+		}
+
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#llx] from guest\n",
+			    int_inj_mode);
+		break;
+	case SVM_VMGEXIT_AP_DESTROY:
+		break;
+	default:
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
+			    request);
+		break;
+	}
+
+	mutex_unlock(&target_svm->snp_vmsa_mutex);
+
+	if (kick) {
+		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
+		kvm_vcpu_kick(target_vcpu);
+	}
+}
+
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3379,6 +3500,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_AP_CREATION:
+		sev_snp_ap_creation(svm);
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
@@ -3453,6 +3579,8 @@ void sev_es_create_vcpu(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->snp_vmsa_mutex);
 }
 
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 74bc635c9608..078a569c85a8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1304,7 +1304,10 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
-	if (!init_event) {
+	if (init_event && svm->snp_vmsa_update_on_init) {
+		svm->snp_vmsa_update_on_init = false;
+		sev_snp_update_protected_guest_state(vcpu);
+	} else {
 		vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
 				       MSR_IA32_APICBASE_ENABLE;
 		if (kvm_vcpu_is_reset_bsp(vcpu))
@@ -4588,6 +4591,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.write_page_begin = sev_snp_write_page_begin,
 
 	.handle_rmp_page_fault = snp_handle_rmp_page_fault,
+
+	.update_protected_guest_state = sev_snp_update_protected_guest_state,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 52fd3cf30ad9..abd3f3cec7cf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -191,6 +191,11 @@ struct vcpu_svm {
 	bool guest_state_loaded;
 
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex;
+	gpa_t snp_vmsa_gpa;
+	kvm_pfn_t snp_vmsa_pfn;
+	bool snp_vmsa_update_on_init;	/* SEV-SNP AP Creation on INIT-SIPI */
 };
 
 struct svm_cpu_data {
@@ -554,7 +559,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 extern unsigned int max_sev_asid;
 
@@ -583,6 +588,7 @@ int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
 void sev_snp_write_page_begin(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
 int snp_handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
 			      int level, u64 error_code);
+void sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1398b8021982..e9fd59913bc2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9279,6 +9279,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
+			kvm_x86_ops.update_protected_guest_state(vcpu);
+			if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE) {
+				r = 1;
+				goto out;
+			}
+		}
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -11236,7 +11244,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return true;
 
-	if (kvm_apic_has_events(vcpu))
+	if (kvm_apic_has_events(vcpu) ||
+	    kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
 		return true;
 
 	if (vcpu->arch.pv.pv_unhalted)
-- 
2.17.1

