Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA52B6B65
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgKQRMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:12:17 -0500
Received: from mail-dm6nam11on2050.outbound.protection.outlook.com ([40.107.223.50]:35201
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727443AbgKQRMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:12:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACjJGS06Lz8PlQvAaugraQyPdmaGn0eGYH1iHZfJi9zLtvTjjWXBqODkZ0sSgCIEOXfjJd3THPuJTm6DxTJfDvjnv0ao9AUXXCJaY7o+fqdg5dDHhOX+ytCYHzDOUVO5gUv+ls4ZsnRrW5mrWEcVsvhGkbmOVmyRWL8muROyvRWkHnGzIszxEOclVmikv0CMuImvpu2fUqeFtiWAR+uxs+bqkXty0RF2jRORtCL2d88Z3gwxoqiEN1ZJ8oeVB99+h6+mUE6HDscDidzMwEOk2HhRDRn07b36SIcYFq4i+Sx6/XMZh7kjHrV8ZIC3039pnGng78LwquU/Frw2WdogHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqOwdO5wCfJTS66akcpIhlbl+M89RcyOUi5kfFZ2kiQ=;
 b=GCwzw8aUkPzqtLEyslKXfnl0pfDDHUNsjGJz5Y4AJA1oGAgo7WJCVHEehmoCcAaQKMl8rKF0ac8yiMC9DBRzqqKss2XDTEZUP3nz3wK9x4MT/i6D/WtvRxpJuOCQVpX6yYPP5pwqY50Sjqa2YpWIxtXBl8hlCu+EbMKmF//iu9iSGdomTtdErSPseh4e7eFMOXCzW5XkrWwZMN2mOI5DokZ8Lkag9MoEjRiaeb/T4BIrTgpdL1DHYOoi3GwOov1zinef4XzzAhcK+egusZvlf8kBtTGk0UfqIw7nYI1LpV7n5BAEA1AWhf3WKO/vjNyZUtLEw+oCHLpHcy4TSymStw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqOwdO5wCfJTS66akcpIhlbl+M89RcyOUi5kfFZ2kiQ=;
 b=bv2m1mqB8cIDsrf8IoBHTnFOwlB/Cq4ym4FKsNdSQCA/nxwk+XPRxWnf51cA82/yCJvk4mzEk0RZUUFx4mkxCtNQT/nnOwBbAlpZW8/Xk9QNo4lteP8CBWAx3177k6O5cEsHblR6zPRRSn1l9sByrY6hmjUmXnU0dYPTQekljG0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:12:11 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:12:11 +0000
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
Subject: [PATCH v4 31/34] KVM: SVM: Provide support for SEV-ES vCPU creation/loading
Date:   Tue, 17 Nov 2020 11:07:34 -0600
Message-Id: <762257fad50ddd295182fa1b761f29ca32839bd0.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0148.namprd05.prod.outlook.com
 (2603:10b6:803:2c::26) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0148.namprd05.prod.outlook.com (2603:10b6:803:2c::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.14 via Frontend Transport; Tue, 17 Nov 2020 17:12:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc653856-39fa-4c3d-dd2f-08d88b1bebfa
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772BA5F405AB076C8C0FED4ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9dnodc4Ix9cJnp/1M7luEma2Voeybrzm/12ah/bFCYCa6OKPieONv/5BPGz55zeyp5esubHpiueICPQ8zRM+qDS9J7EMjxpwXnjAsYmCEnU5/n9YsJc+myTL9jbrB3cFt5QYYhGQBKLail/JWjIIuuyYWGl8VWMt0WHkQIF5syEXnc+GgUjkOz27QTiYvWkOwLVaFiPU9/uCSnc7sj6RY1wo222qdK0IyCTps3l8fy30JtnNxHHkliMp2Z+AAguHqSwfmQLPOvzHtf4fPkW0CKIcqmnJd8Psxi8yo4aD1ItnY2UTdiSd+0VbDdd/eab7qlVpHNAOL6Kjiz8Z2HspxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ITjbxf2xKOi+oAoxO0OCLb7831NxX2U5t6A3cJ03I4P1ot/o92vkW3NDfnnMB/ye2mAYlW0In/3WFsJHh+JtRYq3pploMGh1Nn6xyMkKfYh7Xy62OYDT3ExwKteuIOTV63NRAUVVFycLXjLEFfHuw9noOaTQmyfOnjEIoWyIe6bHYx4msJoPIXOcgIJ2cTsixHjPzvecwQr3A7hdjq3DdULBQtFmcF3AKnZ2/BxPf2ZtTinjTboQbaOsSdWSod3EI7+xNwcWSBTqB0NKLNMKh2ww/lNzBmIGQl416KX83QoMiJjltkZCuYPDz4Wps+36RuFMMC+OIN0if+/QXUPszVIqfAJirMjlEukJ3rO9KG8XIolO4E6FSny1pvma+oogqsA4y5jb14iK/hTBhlKgXdy279FAOomlP7G7CPgddu0p1bIRGBDV5Z2WQLwiwCEGX3plGVg9eL+UL9iaGF86yGoYcPw1yYhlXSSawFRWdiups1c6eCgDgLj2NS84wJu3nF41H+Zt4K9pBv4ClK1V4UNovcB8F6VYipTavtyqXXmL/OpmohvvrGAMAhmYUdwET3d9OvsvJkh1aEo06I5eGmaqOZcUKCR0sxxKYHyNgWrPpkWQybxkaey8vunVVd4XkI1FjhLP6mSd4W//FwhHkA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc653856-39fa-4c3d-dd2f-08d88b1bebfa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:12:11.4398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwsdKcbxEnVIPcvhll03ZPNsgsn3Ty0p6hyUjhiazDrDRE22QkKtxKtrcLHIdWXWAdScZiWWhGHJ1tef+v/wIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index bb6f069464cf..e34d3a6dba80 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1846,3 +1846,59 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
index 99869d781b98..252e10de0950 100644
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

