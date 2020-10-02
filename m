Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FE32818CB
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388550AbgJBRH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:07:27 -0400
Received: from mail-eopbgr770059.outbound.protection.outlook.com ([40.107.77.59]:23267
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388330AbgJBRH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:07:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddRc26qP4Sqa4il4/lLCvgQT5qxF0+/bEJCOLO7yRHX1eJpd197Usb5QyGod+ESDEEc+UFkcYnJtlJu1ewMsSM6hW9IK17Q7AVEKkUIn4aWAOeyThrJWvVrNn9VhuV52Tp7OplPBxv8ZNQVnwb/1KJ9tERb8j0uzZ8c+MJPgsvb2LMYg0vdAMdIDHrWPiSjF3hUVAyQaoecgJJTloo5RLXoyDURqv+JgItBLGu6MAXKPepC5njtSb3M9gYvrh1dK83z9fY5DknytRcUjiv4M0I1dGnbQONvOsbi75Ts2HrqoRArQAExL06xutOljuZGiNaeJDkQhXpbxUSKCgCCCAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v90PbazulF44KuJlUMMcxh7RnoJwDYJjdicBIx/OIDg=;
 b=a4uwFRAa9GqZVtvBsdEWPyGQpYnl2CqlHx0MlTtWPzUC3xQeeKty42bDw67M/m7vPgekurK+zhZrzR+O9+Ts37FzLaYqrlPyYpaQl8364WtY6kptzXyhckQaCzhwtsy67tZJ5zJkehFpP/M6g4DlkPGXe1OiJJiP6TT9UqP+sd+0fMdf9qaYoqzl9sxWNWCaJ4Nrn2bZYhvYYVt87JiUHRC2g0X7R/eu+fow+uZZkIUUAHhpH4f351hiaeTDybn1WSpHnu1pnf/YPw1Cbhak3zPRbfMkuaHogdeZ4/NfhB+mviHOD+sw1hPGHJaXcNH7TUPJBxpf6p6cyejDiV7O/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v90PbazulF44KuJlUMMcxh7RnoJwDYJjdicBIx/OIDg=;
 b=WY4Ay8bd8PVRphu/evoPNfhx+VaLJnDExJpiD17qX91uHOyI1ghLYYiqGRdPk9qtO0dAmQl2OA5aTKLJP1GSxR2FSpSr1SIacQ50bxtNyj1GCaq+ClZQOa3pS+pTgMJU58VkWYLwEfQ+yp6w+lEhxftLKCCgtcDSTayEd5vxecw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:07:23 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:07:23 +0000
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
Subject: [RFC PATCH v2 30/33] KVM: SVM: Provide support for SEV-ES vCPU creation/loading
Date:   Fri,  2 Oct 2020 12:02:54 -0500
Message-Id: <cf7fa5be6b1469b9103ab787c37eac45d81d4faf.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR15CA0027.namprd15.prod.outlook.com
 (2603:10b6:4:4b::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR15CA0027.namprd15.prod.outlook.com (2603:10b6:4:4b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Fri, 2 Oct 2020 17:07:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bdb53c38-fca2-4017-837f-08d866f5a0c5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218F86BF7F5719F28F43B79EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l8HCyB8Z3O3LZbB1u1qyiEtvEH6dgOeXKmc4vG7Csthi/PDzfJnir1DX0q73hnLe4mBaiVhWXPoe08H3Ma9nHxtCK7+jmmCT6azpvwrQ/3WaTnqvyh7Cvo6aaLEA2nbNvnJ+gsid5ZbKN6qzB1EvC/eMd6o7Sa8zJLnRE5JYXB7NCW3sAZQpEtqu5axMbQxC2TMcVSjs/0QH6W05eTPwcCEysrHGIBm/eXuhgocSONg9odHeqG6Ocv90eS0+RvDxnXP9tQAnP9aBBzAqftLVPO434TFw7C8db0mXAVFDcGN8u5Hpb0k/5ZaiTmlhZnk82bH+M2rtKi3wqN6M6BCEhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KMIQjbXYRg6M/ilKDcrwyxEjuvTv2CVEVHLyXy/Ehpcv8itoLkkJt875iLIrkg+61i9XJfA7vlIlqYpWoakG07o+8qd3bHo1e5n3WvTqPVvM4rpxRdsmdzbGSJNDn2CLh3TLFbcY9XfTL1CwxUI6nL2VWQepzEJFunMk3UsIAH2aatnW/Chh58UH8UtEngogv/XhZpBd36vdW6PtlRlKMWp5C3/KccLNYI2vRfh5LhhCxb6GPP4r7OI62G03buBgRr7zTcYF65TLle5Z5SS4oGUlkg7rWPh8MFb/QyOcggEBVZJv3+CvSlVVAFMIfk0Sh5iO0/jHE5tiMXOT5uCiMLVqS8hV5JQy6UERuMkr8Ia/fIhJegE8Wy+ZlA1Ob1tvG8PSb5lCFPGX7xYKWF/nkKPmEcEd/YtujlZhxz3dYdsmvORIHl5iQtYb+Q/v22WoNVPdY85udxmjHs8azesdnGTHAobkpjOCcFGw/FxEcLlEGs95jqrlZGc+iOlWl22k4Zmwbw7G5EWcgCN62a6TVEzn/GPu1X4B/c9OBUkCCFNQGwtKob9eiCshIhPTowumuFK19upFjTHD9iWIWuXqF9V29E2t7nj0o7I/P9smG77SHVRJ6nN2XzUK81GbIy+xaG/sKzOcdGEJDWPApKUBxQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb53c38-fca2-4017-837f-08d866f5a0c5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:07:22.9461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6S2wx+ftui52I0NHBo/+qz+pkb+kLStmRokxlGwwMvWNq1E0jywzjdA+oCPze80COyuwtnvdKryJ1UK2X9Tng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index 477f6afe5e33..1798a2eefcdd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1749,3 +1749,59 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
index ff8f21ef2edb..b3e2c993bc4c 100644
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
 
@@ -657,8 +660,8 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	msrpm[offset] = tmp;
 }
 
-static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
-				 int read, int write)
+void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
+			  int read, int write)
 {
 	set_shadow_msr_intercept(vcpu, msr, read, write);
 	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
@@ -1242,6 +1245,11 @@ static void init_vmcb(struct vcpu_svm *svm)
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
@@ -1349,6 +1357,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
 
+	if (sev_es_guest(svm->vcpu.kvm))
+		/* Perform SEV-ES specific VMCB creation updates */
+		sev_es_create_vcpu(svm);
+
 	return 0;
 
 error_free_msrpm:
@@ -1469,6 +1481,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	loadsegment(gs, svm->host.gs);
 #endif
 #endif
+
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 }
@@ -3159,6 +3172,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "avic_backing_page:", control->avic_backing_page);
 	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
 	pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
+	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
 	pr_err("VMCB State Save Area:\n");
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "es:",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 75733163294f..80c2515e75a8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -34,7 +34,7 @@ static const u32 host_save_user_msrs[] = {
 
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
-#define MAX_DIRECT_ACCESS_MSRS	15
+#define MAX_DIRECT_ACCESS_MSRS	18
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -412,6 +412,8 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code);
+void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
+			  int read, int write);
 
 /* nested.c */
 
@@ -569,5 +571,7 @@ void sev_hardware_teardown(void);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void sev_es_init_vmcb(struct vcpu_svm *svm);
+void sev_es_create_vcpu(struct vcpu_svm *svm);
 
 #endif
-- 
2.28.0

