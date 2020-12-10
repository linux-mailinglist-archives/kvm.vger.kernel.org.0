Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D122D6349
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392730AbgLJRRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:17:16 -0500
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:35297
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392486AbgLJRQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:16:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDY+ECo3wPufLkiTklev4mXbC4ldefT37OJDAl8qoqfR9Ie9bdmN2uVqVFNOGa3FRtOLHHQfolTscerwC9S3YDYnuAPohk9Y5Wz5Nwm98t+eagl62rtA1uf5Tw84K7lgTLhtMSwgN+0EyTu6HE98SSTtxyqwDzIF3wHxXoF5G6jf27y0IBTueU9VyZCkAtxYUfVJ3539bokkrWSP4ohZ9X6oPkdwvx16xhWeZhhbh2k1U3uu70LxY5W/O9o2RALSGMrvSMhZ1IrF6p+a6pywjfQYDclu5WfPzsO5SQMLsI1kd035HANHhh1jCZYIgkdMHIupO4YFPsLygmYAm2HBmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZnZbX2UjGEaf+QUg9KWvWPv1eIzAdubdeLS3eSvEEU=;
 b=e+UbLZQn3tTaC32srNYUe8neRwxkye11SKLzFOGs5axXtPGJoNrc6wOdJtHk6k90lp+AFuP90OgWukdnk7q49D+WeMYOZIfcgzndLgFmyZM2jmMUtCzWm6Xkyaw5vAFKdUsV207o/Ddly5wciMiC3QbfxhjZAZ2b1CMLXcg21Cic568HQ04I2DZ6KktlxUaaqrCxwP6XIZxY0gBOKsAdJ5ZpN0W+ef6nxDfb6GOhT1R5spMgdyes5sLK+d2OXlGmmIBKhZrg8Qulns+Wj23by63oEpJyuOh7u5deCx72e1HcR9uIavrpNdqnVSzG4HN4+BMRNu8Cjg59jCXwSg5H3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZnZbX2UjGEaf+QUg9KWvWPv1eIzAdubdeLS3eSvEEU=;
 b=PDM3Fh5SkHVT4pmxdE8e9LRFIJ3aQjINWHvB2RrJD+OuhkgI0Z0ceDk6SivcGdtory1JTHsUb9BbJgiHmEsuN+Db1WkhB4x0GzHbtYUfRSbSUrKNp48W/jTAJ28OtweGi8JF9WQkRIktMuWKc2OrpBgVsVxyxYBocSZgCjMc3HQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:14:58 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:14:58 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 31/34] KVM: SVM: Provide support for SEV-ES vCPU creation/loading
Date:   Thu, 10 Dec 2020 11:10:06 -0600
Message-Id: <3a8aef366416eddd5556dfa3fdc212aafa1ad0a2.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0071.namprd05.prod.outlook.com
 (2603:10b6:610:38::48) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR05CA0071.namprd05.prod.outlook.com (2603:10b6:610:38::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Thu, 10 Dec 2020 17:14:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a5caff8c-0ebb-4bc4-b236-08d89d2f1f0c
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB014972B26E9205E4161C74ECECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JjhYrCbjDbEUUgPBs5uiSxTPYQPPMT68UfPR4XTw98uaO272N3UtlaJciQiGSKcjWcaiYu1Qb0eAoz+qBlgSIqZdbb/YB02BRPWxKBvaA2+pjALQ/mmtLx3cQFLFcaL+HNr0CC/jX/gmaY7QVvvH8DpHfOiTAdoNls9ZxTcDpDPOOmw19cKKloU9wJUG57eMnjJek7KaEvtiV/nsb0PjdPKWzVr+rJ8V4WRvvMwmD1x0Jz29Em19aXu0RcYXaPMFQlEAAocZKkY1XKbbhz5o+xnac7eFrkgfG+K5pESFzcnZ/R5N6bmfgf10V9S73AiUaDxiRrqz4z3svoumbjqdWZKG7ly1llSeeGt1vlAAMvy4m2SDNFgddo8sLdEdFU3s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ozQ4sf6AUN/fiLLHWnCd26RKaqPTD9XPbsPu/zvpUt4KtjvrLtGEEFjkDIkr?=
 =?us-ascii?Q?zOT0F5ReNYvwpZ/cdKEG0ErHW5lKanKrkWQIkce2PFBQioeQQ5XG3Kzk3nnU?=
 =?us-ascii?Q?a7IVslhPLaCYD+8yFA3dUDoJ3SeL1B+eugdVv+w00hORHo/cTj8BdYpOeUAW?=
 =?us-ascii?Q?+/Hw0jP6sgob0Ycgx728geut+DzRNcwsatBjKDcb5o3g/4RW39QS57mhrMLD?=
 =?us-ascii?Q?GSkDSnThBl0FLsyChHUMOL1ZFJSEVeBN8ntohsHEqaS9yetwiaF8RpU7nnbn?=
 =?us-ascii?Q?szk1gO8DeZ85imYXj8KUj1XVdxIDqMWUGmJjxPeI+6nHb/LPJP0SIAmJkQHo?=
 =?us-ascii?Q?sCf0yWBeXNS+utSda+e1cfesBQaE0UUZF0TyRKmsBXU3CvG28/Wu+7RPYs5I?=
 =?us-ascii?Q?ZnYARc1rtiHzJkjABfhYmFwz6gAbqMfJHIJVw1AJWdatrI5D5JvsvuUXIRVc?=
 =?us-ascii?Q?cRFg3gh/4WVIa63gCUhdG9doqpp6L6pwTtEhg0ByK5iWVIGe5dd4YQP2s3zn?=
 =?us-ascii?Q?BEZJ7lWM5BEBpMWKardjJHCZGquU/m6JUGYaUTjT2AzPMhTYoWMr5SW6XzVm?=
 =?us-ascii?Q?jdP+fzpxkq4QqeBlTYJHEHU9dl+8rklssHwyybxI1/YtdDJww3djYrxHR5bi?=
 =?us-ascii?Q?cCBUnQ+puAXYTevkT6BipXb03I2u0i9/XDoejqY4vV8rER5f98O0bPYNDH7t?=
 =?us-ascii?Q?JIfjQbNxCA4jbER2hXh9CTw40F1ZLyfmGg+o3q3jX29YG3zXaM0x+iUjmuKK?=
 =?us-ascii?Q?jD9ItuyEkShW+dZ9BEtL2TR/Gcak5L/GS+laJpuOakzSm5MVBe8YeyzLqFxX?=
 =?us-ascii?Q?887xlXl4Cv6fBo41RAsHCk2vnfgKLSknRCjsppqM1sHeglRuethC3y4U3oEA?=
 =?us-ascii?Q?I4AuJ6M+3LHwHZtgc/aAxv6pbcZfwY+edBpQctsY2tLm7AO9ooejRTWdlNfV?=
 =?us-ascii?Q?oV+3lyRldnN8MgbUVNWU9za1OswUHqN4J+zeC6wQiJa3CMZ3PMd9ceCAAhRL?=
 =?us-ascii?Q?8qcD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:14:58.1525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: a5caff8c-0ebb-4bc4-b236-08d89d2f1f0c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KB3BBIxDkDnhFmpO3FnWeqn085lunN8vGicQCp6p6q4eaisqj2/g90QQayP53EK0++5ysFco8FZZ4tKTgAEHfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
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
index d8217ba6791f..46dd28cd1ea6 100644
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
@@ -1264,6 +1267,11 @@ static void init_vmcb(struct vcpu_svm *svm)
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
@@ -1357,6 +1365,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
 
+	if (sev_es_guest(svm->vcpu.kvm))
+		/* Perform SEV-ES specific VMCB creation updates */
+		sev_es_create_vcpu(svm);
+
 	return 0;
 
 error_free_vmsa_page:
@@ -1452,6 +1464,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	loadsegment(gs, svm->host.gs);
 #endif
 #endif
+
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 }
@@ -3155,6 +3168,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "avic_backing_page:", control->avic_backing_page);
 	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
 	pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
+	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
 	pr_err("VMCB State Save Area:\n");
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "es:",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 313cfb733f7e..1cf959cfcbc8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -34,7 +34,7 @@ static const u32 host_save_user_msrs[] = {
 
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
-#define MAX_DIRECT_ACCESS_MSRS	15
+#define MAX_DIRECT_ACCESS_MSRS	18
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -419,6 +419,8 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code);
+void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
+			  int read, int write);
 
 /* nested.c */
 
@@ -579,5 +581,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void sev_es_init_vmcb(struct vcpu_svm *svm);
+void sev_es_create_vcpu(struct vcpu_svm *svm);
 
 #endif
-- 
2.28.0

