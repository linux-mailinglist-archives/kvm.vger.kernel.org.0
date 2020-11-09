Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9926C2AC899
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgKIWaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:30:18 -0500
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:9217
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731843AbgKIWaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:30:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYgsm3B+ky+l170nQSFmYv8CSalLBAboEs281eOAY1eR+axWU5Iy7c2kJDnTlYics+9z3rkBKrzVAqXUWopKXnOPAB9aI6zrYuh+/p6cdv8azBj7mUGjaLfSUOBjbR3fmy8qTqOw5gXqI8hSuKoIQCpu1UxVwmfzOlMMof12A4NDFcHzWlH5D+ogh3lprR4lvH9fPg+zOmXT6MUWFylFtogm9XCVTsa62fr09xzLuzU/RQapjTEPAAbZgzbdrkgHr/rCwld8uNxc+nkIsLJA8RBYrhBMDBLGCbQyTIP3zHPxtIJ7QJ4WdiKNKKNv4d26x+aBVSNutAMJowLtKDCclg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dM/GZqWImwaxqsIj3rT9Uz16RrrkI+A3cWAS4JqvCLU=;
 b=jLa7Qvn73AMRSV0bDJLigsIGIm9hB4mY+6sqSVUyvoVt9Y5tSceEPKlk593au/BTFUu3V2n9vb4hPczVz9FtYXPbh8bVpmYmWZIfieh2ivoDi6oo4zRS+Z2XcKIevnaxjyBUQzB7qlZkFvZz/kx1cKjBhA8+AljnrLhOooOktuV4rOQPBfWs36L+W1TNnFryaA5bVbguLFn3h5FGj9b6ZRei62eLlFNJJ+04TQSHe3QK9T9xB8gy3TI9vPHWkAp8my+pvH5sfyy9Y01VU090Ytt4TznGFavlWGWvJJshcdOkIvjdImH4jRDUSc2VllG3ggpfUa9VAlMbbIb4FpxsxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dM/GZqWImwaxqsIj3rT9Uz16RrrkI+A3cWAS4JqvCLU=;
 b=WEmz2h+1kNNLNoe78WxK3U0MP/U1tijcZV2y9Z3CgDFPJ1MPEX6DF+RwhuZwE8JPkXnWhW0P3WGLM3CushRqlZ0MP4kEp+rF8GTEbu5RYVaR+yE276hl6bYvMytKCsCuWFeaWJhRxrvJICNRgyOwht8OhSArOV0fD3DafAfRB28=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:30:14 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:30:14 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 31/34] KVM: SVM: Provide support for SEV-ES vCPU creation/loading
Date:   Mon,  9 Nov 2020 16:25:57 -0600
Message-Id: <aab561d238333c9b9fa0f87f8c3b23c2aa0bd5dd.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR12CA0013.namprd12.prod.outlook.com (2603:10b6:4:1::23)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR12CA0013.namprd12.prod.outlook.com (2603:10b6:4:1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:30:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a5dd8849-57a4-4926-360d-08d884ff070f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058F9117932E35974BB878EECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ozFVAUSEUM0poJH2az5z9elfUW5KjoeiA3xnjZJP1vLsoNKyPmIW2r+IWkDSkUBMpqHMF8DlBY0TGK3J5YijW9QPctbm100y9iveiZJXhCya3pWLjHRgUbnV1pMRpmcK19J3OjsCQmPkBTWITKbBglImHMWFqb71rgSbn7Ff2ywgfCq+9mm0ajpGsyCEtej3qq8/zlHxg00IuY5lcgCru5iHyXGdO2LV01M4xfDhfCdH/QzawwcItAk1hXwkAAxN5ATSDlKNqkbpq1A98lUA0RLjjnJERZkW5RosCtnftWYsH6Sfa4tWFZE2PI+4F5vtOqSr4kEhwyQN5k10pa/jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1V8j+M6k/ehjpsSmLbLXRJeYAEBV5GfC2VcHL3eeCnBD+01sP/eNqxzI3KQWgLryMzk/jEwRA+QyMZc6PEza/ARs+uom2WWokqr3zQYJluG6bw8z1fnJSI5eHrtqzuL2PDEgg8nmtTmML2obct/OGNigmdvB0R6JWrCmsBEpOC8eubYOtFNiodoxJC01XfeZwaTqfkpZfSUI/D30hYI48Y47K62IicRSYtp0IKGI79fqvKNtKByGNprIwWcgvbC716eRa+w6Sn2yUYNbeiLWGQMrlpSyq5vSVviRsI/SZVRuM1WpXM1tHBJjIWdoIahxppFmXysKRho+bOUoa5mP0nW3Lku3AwN3MUnGbqi0ZYft6bjkj0R+utAJYq1QvsOjtttiTkXjrf0Q53EimW9YW62k8uHFr/JVJbhTByhjgJ/wq9m7A9mjp39apHsDtU1q1xq/J4j6gSeOX7CyBqe4N+KnMj0relc2QyWHpnnCHFaVscAUv9MB5FGuWPgrj5A9w6U0kR7EOzfHsakQV0oAkBX88yAGFiClCuc0eZOAnO2PwXCgAe6yIXRVD+0ntK9Cl62YZfiXuX2Ld6uQTGoH+MetmOV62MMXdFf+STng+Wo6H4U+ze7lymmGVmt1wlJV6l1QjLS6AI4ElTIqZ0WGNA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5dd8849-57a4-4926-360d-08d884ff070f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:30:14.4968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XimNpLCkf3s/bWptRlyBUhmat5z31x4Sc2i7Zry0EG7vO5sT9UJVxKi/CoGmbHTDERL5xbovIYlcw2lHacMoOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

An SEV-ES vCPU requires additional VMCB initialization requirements for
vCPU creation and vCPU load/put requirements. This includes:

General VMCB initialization changes:
  - Set a VMCB control bit to enable SEV-ES support on the vCPU.
  - Set the VMCB encrypted VM save area address.
  - CRx registers are part of the encrypted register state and cannot be
    updated. Remove the CRx register read and write intercepts and replace
    them with CRx register write traps to track the CRx register values.
  - Certain MSR values are part of the encrypted register state and cannot
    be updated. Remove certain MSR intercepts (EFER, CR_PAT, etc.).
  - Remove the #GP intercept (no support for "enable_vmware_backdoor").
  - Remove the XSETBV intercept since the hypervisor cannot modify XCR0.

General vCPU creation changes:
  - Set the initial GHCB gpa value as per the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h | 15 +++++++++-
 arch/x86/kvm/svm/sev.c     | 56 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     | 20 ++++++++++++--
 arch/x86/kvm/svm/svm.h     |  6 +++-
 4 files changed, 92 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index caa8628f5fba..a57331de59e2 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -98,6 +98,16 @@ enum {
 	INTERCEPT_MWAIT_COND,
 	INTERCEPT_XSETBV,
 	INTERCEPT_RDPRU,
+	TRAP_EFER_WRITE,
+	TRAP_CR0_WRITE,
+	TRAP_CR1_WRITE,
+	TRAP_CR2_WRITE,
+	TRAP_CR3_WRITE,
+	TRAP_CR4_WRITE,
+	TRAP_CR5_WRITE,
+	TRAP_CR6_WRITE,
+	TRAP_CR7_WRITE,
+	TRAP_CR8_WRITE,
 	/* Byte offset 014h (word 5) */
 	INTERCEPT_INVLPGB = 160,
 	INTERCEPT_INVLPGB_ILLEGAL,
@@ -144,6 +154,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u8 reserved_6[8];	/* Offset 0xe8 */
 	u64 avic_logical_id;	/* Offset 0xf0 */
 	u64 avic_physical_id;	/* Offset 0xf8 */
+	u8 reserved_7[8];
+	u64 vmsa_pa;		/* Used for an SEV-ES guest */
 };
 
 
@@ -198,6 +210,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
+#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
 
 struct vmcb_seg {
 	u16 selector;
@@ -295,7 +308,7 @@ struct ghcb {
 
 
 #define EXPECTED_VMCB_SAVE_AREA_SIZE		1032
-#define EXPECTED_VMCB_CONTROL_AREA_SIZE		256
+#define EXPECTED_VMCB_CONTROL_AREA_SIZE		272
 #define EXPECTED_GHCB_SIZE			PAGE_SIZE
 
 static inline void __unused_size_checks(void)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 158f2f41571c..362b4f7eabc5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1842,3 +1842,59 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
 	svm->ap_hlt_loop = false;
 }
+
+void sev_es_init_vmcb(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
+	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
+
+	/*
+	 * An SEV-ES guest requires a VMSA area that is a separate from the
+	 * VMCB page. Do not include the encryption mask on the VMSA physical
+	 * address since hardware will access it using the guest key.
+	 */
+	svm->vmcb->control.vmsa_pa = __pa(svm->vmsa);
+
+	/* Can't intercept CR register access, HV can't modify CR registers */
+	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
+	svm_clr_intercept(svm, INTERCEPT_CR4_READ);
+	svm_clr_intercept(svm, INTERCEPT_CR8_READ);
+	svm_clr_intercept(svm, INTERCEPT_CR0_WRITE);
+	svm_clr_intercept(svm, INTERCEPT_CR4_WRITE);
+	svm_clr_intercept(svm, INTERCEPT_CR8_WRITE);
+
+	svm_clr_intercept(svm, INTERCEPT_SELECTIVE_CR0);
+
+	/* Track EFER/CR register changes */
+	svm_set_intercept(svm, TRAP_EFER_WRITE);
+	svm_set_intercept(svm, TRAP_CR0_WRITE);
+	svm_set_intercept(svm, TRAP_CR4_WRITE);
+	svm_set_intercept(svm, TRAP_CR8_WRITE);
+
+	/* No support for enable_vmware_backdoor */
+	clr_exception_intercept(svm, GP_VECTOR);
+
+	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
+	svm_clr_intercept(svm, INTERCEPT_XSETBV);
+
+	/* Clear intercepts on selected MSRs */
+	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+}
+
+void sev_es_create_vcpu(struct vcpu_svm *svm)
+{
+	/*
+	 * Set the GHCB MSR value as per the GHCB specification when creating
+	 * a vCPU for an SEV-ES guest.
+	 */
+	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
+					    GHCB_VERSION_MIN,
+					    sev_enc_bit));
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 073b5b044bf1..f45499cfde40 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -91,7 +91,7 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
 static const struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
-	bool always; /* True if intercept is always on */
+	bool always; /* True if intercept is initially cleared */
 } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
 	{ .index = MSR_STAR,				.always = true  },
 	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
@@ -109,6 +109,9 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTTOIP,		.always = false },
+	{ .index = MSR_EFER,				.always = false },
+	{ .index = MSR_IA32_CR_PAT,			.always = false },
+	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
@@ -677,8 +680,8 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	msrpm[offset] = tmp;
 }
 
-static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
-				 int read, int write)
+void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
+			  int read, int write)
 {
 	set_shadow_msr_intercept(vcpu, msr, read, write);
 	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
@@ -1263,6 +1266,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 	if (sev_guest(svm->vcpu.kvm)) {
 		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
 		clr_exception_intercept(svm, UD_VECTOR);
+
+		if (sev_es_guest(svm->vcpu.kvm)) {
+			/* Perform SEV-ES specific VMCB updates */
+			sev_es_init_vmcb(svm);
+		}
 	}
 
 	vmcb_mark_all_dirty(svm->vmcb);
@@ -1356,6 +1364,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
 
+	if (sev_es_guest(svm->vcpu.kvm))
+		/* Perform SEV-ES specific VMCB creation updates */
+		sev_es_create_vcpu(svm);
+
 	return 0;
 
 error_free_vmsa_page:
@@ -1451,6 +1463,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	loadsegment(gs, svm->host.gs);
 #endif
 #endif
+
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 }
@@ -3147,6 +3160,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "avic_backing_page:", control->avic_backing_page);
 	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
 	pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
+	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
 	pr_err("VMCB State Save Area:\n");
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "es:",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 95be2ba08a01..48e4cfaf0a69 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -34,7 +34,7 @@ static const u32 host_save_user_msrs[] = {
 
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
-#define MAX_DIRECT_ACCESS_MSRS	15
+#define MAX_DIRECT_ACCESS_MSRS	18
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -418,6 +418,8 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code);
+void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
+			  int read, int write);
 
 /* nested.c */
 
@@ -578,5 +580,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void sev_es_init_vmcb(struct vcpu_svm *svm);
+void sev_es_create_vcpu(struct vcpu_svm *svm);
 
 #endif
-- 
2.28.0

