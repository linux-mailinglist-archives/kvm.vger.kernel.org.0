Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F812D6424
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392810AbgLJRxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:53:01 -0500
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:12128
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404085AbgLJRMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:12:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fL4xFwSZ07x7dF0WPJJOLo0Gi4Qv+AEYXBz4yNA2EHVTN3q+zMXN8z/h9iCQyiGesx5HZ4t0Ov+rdk3VsDMri+YlJkp7BH2BPbuBJ1ZUQQkax5ecSWorF/sezxWa0m4YlQiHROGolkhHuq/bebR0cGxakk5DkR9hVp27ohdupypmKxCvwUaUQHvHhV5Oe1OidMC5EFHHUMJHMoSpTJ/6OHSX6kDMmsqa/o17BwqDlNLbtUytPvD0+o1RSW4GlvELeJqxhVBKP+TUucBUNP4IBDIZdPk2VBG0K1Saw762QfTPqFL5ZNIKW+cbDq5K5JQsoDcB46Om+k4NJqWj2f6/QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ManqscXx1DPKr4nXvgMBJE6/JjqscpgS0t1WaoEyDo8=;
 b=S4ip3XD9EcG2Vp/drM5+HaFmLqIW9laoGvlcMjAMsOBEBW0DKaxbJ80YTrc/QhZRAPuhGnWnQmjAO/ceRcLed5/H35LF6q3cy4RbVazfyrOy+Rmdj8owgZ8pBwan99uP2Niuthfs70Cl/TMIl9OY6EYhdC/9ebY/gCrXNCMZh0uNCLEmzYr2NQW7BEHRRlO2ausVbr0mcdpmgxEXn7uQJlPb5VvKAGxrWkN2GdYU0mp+XeTMi8xGdlDWqGzhzbuaY39JLc7/JD0QAAODSNf2UjyBZ7WIgeGyvcPxY9Ydh6PXEB6rCM8h7w22XdP4w1FexlhMXCRky9m0VI6t2dteBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ManqscXx1DPKr4nXvgMBJE6/JjqscpgS0t1WaoEyDo8=;
 b=uj6JSjT3j4Vco87gqL3daa8fPKfJEEoeFeyN8i6LEXckalvoXCrQe9jyMqtbMDzsZiESD4lGjtbm1Qgw4B46Ng9faaS5VHcjCxwjbYxrn+mGtpWCvuqPQPkXnujYpYAX3rAU1GMsctqQln29S5oPSKBk7sda50QCJP1yDKTTpZ4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:11:28 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:11:28 +0000
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
Subject: [PATCH v5 08/34] KVM: SVM: Prevent debugging under SEV-ES
Date:   Thu, 10 Dec 2020 11:09:43 -0600
Message-Id: <8db966fa2f9803d6454ce773863025d0e2e7f3cc.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR14CA0005.namprd14.prod.outlook.com
 (2603:10b6:610:60::15) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR14CA0005.namprd14.prod.outlook.com (2603:10b6:610:60::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:11:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 435bebe7-0d09-4427-5b6e-08d89d2ea22c
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01491FBF7373253AA587AD5EECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nWnAwNsFNevNikluVCt1SxKAhpd8WcH9RdCXoW3PeDWIhUg3X3fFBDWZJa9lGZKGo1lSumuMGZZamCjrFe4BgeKM+zNTfvpFDmaNbRyFcwkn80DTXsk6qYB7UmYDI45Jz7QyxYuSBJLn7qfWSMR8W389pbdMxJu2SzGIxrMVlQBabLdtDT1RSLyYNLNORIboaJSeMsJ4s9jfNhMNV4XTG/zy7LATdGGKdzFCYhpZjd5eCrZZLwj7yhTLjsKuBwFTt26k0zSMnC8eVELe78T6nlRhi5sESbD5GsMOJ8AblSusOhqdZtpEseusDsRXaR9OgGUi5pjN9vMvCnsVuM0Hu3GEBGJMJRSXBJ0PNNmtxbKDX6txfQkFeCjRnI6XLVVt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p0cSEMo0U8BSlgiGPa/jiCH0wiJ0vdQbdCxVzJBHKqvG8I/M2I3dgK1O2TGH?=
 =?us-ascii?Q?lxdXQ9PmM+MVzPvESrDSXM3jMpOf4JdllnDCZ8ta0C8QBi8yR3547fmHNUD5?=
 =?us-ascii?Q?TjUpQTC9K11cUNFiqk2NJrASqImgFQwFydouP1vE8NBqZJfcLa4Xe2iLMkpR?=
 =?us-ascii?Q?05SZxsy8umhWeNyTXmUP787x8nWK3uz/X6jqnNPvGPsM9qWe88VbG5ZAFyIQ?=
 =?us-ascii?Q?/ayny/Kn3X0Nr08Z9QbhqhcLQp9y3Lg/pVP2f73RQ+vO8p1DuvBpWxNf2HmW?=
 =?us-ascii?Q?JyEInRodAbi68BD1rlkfs8uxX05iDNqSbKf7aFfXlPZUeMH4U0l+/gzlRQgJ?=
 =?us-ascii?Q?27doG9xbes5QnH67+4B9c/WvU4WRhowAGye8rlEte/3LCcYr4l64ZfiE/wNk?=
 =?us-ascii?Q?yDYov+vm06GuAJARmHO7d0B6CGos0Xsf2eJiAPmA+FlndTlCaCVSvycxnGBh?=
 =?us-ascii?Q?qfVS9kIm0F2+L+JahsZOvMiVwP+ZYtOayEzViNYusnWnOdG6V9/s+xURKhbv?=
 =?us-ascii?Q?Myrhm8HV+d8vyJjtTP4NDiJD+0qborIo+TdCtqq2kXSRYfmxGLtdARv4277o?=
 =?us-ascii?Q?4mgyS6wDxN1q8mhqbW6ZRBknHjvDvwikFsEGW3pozSJ1/2CvPGCfNPTbtCK3?=
 =?us-ascii?Q?gY0HCQY4z0CJHTX2eg1lee5sxNGK3C9tldEldTG5kpqjtYquL3+xgdc497aq?=
 =?us-ascii?Q?C5JJ6JYwxlL/o1cVqKEmcnCiecIyEeRcuDv9ulaUulovaBEgDEFRxReY+J8I?=
 =?us-ascii?Q?jDqnF7qMm8cQiDm6584q2XySPXaSwMrC0xxSysEXiZdihfbZPSnsORcPgiaW?=
 =?us-ascii?Q?31y8daca/++iKIYbuIeSD7SKe7NdsjS9iVQxY0oWjfuI8+WXiLa/lpFZ2w6o?=
 =?us-ascii?Q?NYnLF1JRSdrwWTNRU5/p3beV/gK3/y7Up4Tpj85jkSn/OiLNc3LQSnA3LVN9?=
 =?us-ascii?Q?MHjeoain5o0VFYphso9BYreKDggw+I0RrNaTOeX1343FjGr3OfvO0QIBnkJt?=
 =?us-ascii?Q?DkaF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:11:28.6848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 435bebe7-0d09-4427-5b6e-08d89d2ea22c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4Hvd2oJA4V4LTJRO7nR80Df45/OG0q29rLf2pZxy8rLsVuhx+8SiKGuTyi1PxBe1r9sPrJLaq5YNPOoX3b7rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Since the guest register state of an SEV-ES guest is encrypted, debugging
is not supported. Update the code to prevent guest debugging when the
guest has protected state.

Additionally, an SEV-ES guest must only and always intercept DR7 reads and
writes. Update set_dr_intercepts() and clr_dr_intercepts() to account for
this.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c |  9 +++++
 arch/x86/kvm/svm/svm.h | 81 +++++++++++++++++++++++-------------------
 arch/x86/kvm/x86.c     |  3 ++
 3 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 857d0d3f2752..513cf667dff4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1806,6 +1806,9 @@ static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
 {
 	struct vmcb *vmcb = svm->vmcb;
 
+	if (svm->vcpu.arch.guest_state_protected)
+		return;
+
 	if (unlikely(value != vmcb->save.dr6)) {
 		vmcb->save.dr6 = value;
 		vmcb_mark_dirty(vmcb, VMCB_DR);
@@ -1816,6 +1819,9 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	get_debugreg(vcpu->arch.db[0], 0);
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
@@ -1834,6 +1840,9 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	svm->vmcb->save.dr7 = value;
 	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 80a359f3cf20..abfe53d6b3dc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,6 +199,28 @@ static inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
 	return container_of(kvm, struct kvm_svm, kvm);
 }
 
+static inline bool sev_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev->active;
+#else
+	return false;
+#endif
+}
+
+static inline bool sev_es_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_guest(kvm) && sev->es_active;
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
@@ -250,21 +272,24 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
+	}
+
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 
 	recalc_intercepts(svm);
@@ -276,6 +301,12 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
+	/* DR7 access must remain intercepted for an SEV-ES guest */
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
+
 	recalc_intercepts(svm);
 }
 
@@ -481,28 +512,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 extern unsigned int max_sev_asid;
 
-static inline bool sev_guest(struct kvm *kvm)
-{
-#ifdef CONFIG_KVM_AMD_SEV
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev->active;
-#else
-	return false;
-#endif
-}
-
-static inline bool sev_es_guest(struct kvm *kvm)
-{
-#ifdef CONFIG_KVM_AMD_SEV
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev_guest(kvm) && sev->es_active;
-#else
-	return false;
-#endif
-}
-
 static inline bool svm_sev_enabled(void)
 {
 	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6809a2851d2..de0e35083df5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9671,6 +9671,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	unsigned long rflags;
 	int i, r;
 
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
-- 
2.28.0

