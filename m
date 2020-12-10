Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5682D6384
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404160AbgLJRQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:16:32 -0500
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:35297
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404154AbgLJRQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:16:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIuersszTkFmVEa5kvtgfihfQ11jfU32vN58lsYcAXojpRjWggdREGjIjJd/GOrbVnabUCW/26W/PqG7LdjHScz5Mo6Nm5C/TVe3mPnWZ6HxS/Kj6ZK9wyExe6AWFelHuO6jsP4ef8cfXbAgmpJdOc+EyE84dL1ORCSl7G9kWyms93BiIGmlt/giAE4w0xIqxq1x34mxduTGXNelbgGbBNOGden02hWd64NgVPnzXt1j4dS2l+GOxv+kLv+XpqNgmezYhlqAtBScxmo2WJGvTiCR+HScv0DpiH5ERQfDRGkurXup8Q4FW2QtzK8PonaL5psTns458TX/lwwE7JGTTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQYj9pIxI9KKrvbrA368vXkNri8/lTXrB4RGOlHXqEg=;
 b=hYAo/2Az6DCxKOPk5L7PgYr4p7Q7VL/kbfymyQ6luKUCCjrUh5cco+mO9oHzxfYSxIeU3A3kF4TCHwNXd+VMBPZDOFIlxHJ0z4KcU/Apo0x8GeBSZ33Shla6Yt/7VIXk1soZT8OQ2RlaI5DUNM7pWL70XaBDCU35rtfeCvKnnZfNQd9FrCy7BsBhtk8ForLFIy3s3dELJtuQMXzrX5iidsMS94+yKJvGC1ouedbT5BsxaOjmShRIYusp9OOnh18LnaU+7iPsgCvEB1YxKLwHVeHGaDuXAQdFdxPm5GLRXLHZXJZXK4ZdzpIUQBteSvBET6JVbd4dwJs3frnsuqJiHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQYj9pIxI9KKrvbrA368vXkNri8/lTXrB4RGOlHXqEg=;
 b=bmaC24VVjTllPObHKmKn75vE9Gd/omy8DYRaqIhgZOhEqiWQQ7wt3R1hwl+zavlbK5c9gxSDSWVN/QcuUJjQY2hH3yVksY2Vv34BYkwpwSOm9NzCDS/Uwsm68kIqPRxX5WmjlE/M/y6G5Jvu561NPgxo+/aDj6N8fsdddLtwg8E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:14:04 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:14:04 +0000
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
Subject: [PATCH v5 25/34] KVM: SVM: Do not report support for SMM for an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:10:00 -0600
Message-Id: <75de5138e33b945d2fb17f81ae507bda381808e3.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:610:20::26) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR07CA0013.namprd07.prod.outlook.com (2603:10b6:610:20::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:14:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 72b348f1-5d65-4ca2-2082-08d89d2eff08
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0149D3C6E4D733B96070C5CAECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fxlr2JHhjgu014mTF+eKlUWTv3un9LMAi1bpPIm1y6oTvQ/e6zkoxdeR4cKww5jVRLc6BsmXyyw1ogrq8kvqN+HL7a7VhrxKUo4QJFY6UwBeVQj2gcZfeVjGjW0NL6Wcy5V5E+jIeNgno5LnUiCEVuTptuA5j4f/keTzDkdLwqw52GVi3OVxgA4PL3VjhV6qQEHaQy7qtrzMaoK054Fj6tCveur768ZZl0vwYnQ321CDpvJ3Nfo6o6pYjhWb7r+FDbkVh7G1UM5RZhgdKOWm1esfto0w0CPtUSou8d/3k5YMvKkQLIQVEerkVwrai5LrbVMhYVh3N4l9YX2dlBnpvwPNu5Xk0sGcVkY0BUZhDgI1EfNmCBFxqiQOSmxDKFmb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?w71rNRJaBBAyDBRo9F4H1DLLbWtYfS6KBpEH6zjOfgD91OWk2yzZQCgB1Mbc?=
 =?us-ascii?Q?rsjPJ2P/C+qb74dKykAUchFsryTxXt/GRgUF30mWWIqEgPAL//h7DfawU1BQ?=
 =?us-ascii?Q?/XBwSVSBq59gFmE6q6qwxv8X8WDA7w/FrJ6dQ7/JMpfStm+fUTFYMmISZqvc?=
 =?us-ascii?Q?IJyOjr6ziYleYGXK7c/rZ0pdFOb+7zoi/ccCV30xMa3/OBTCWiDtFtJ0EmHT?=
 =?us-ascii?Q?qKdzaG4pPAZYBFkWSUJRZDpcu9AG8gV3kPdGS5IeD1QuIYR6+RUyp546xboQ?=
 =?us-ascii?Q?n4SyG8E8bWg+SlRfBKHMPTn1zly81yGtUBxl8MHElRd6atAWSC/vmpkXKK5g?=
 =?us-ascii?Q?pEW/QPxtg726+E2GltJY1Q6wVGGlmCMV6Koq2KmdXUDljQvowKJEpOiVA9F3?=
 =?us-ascii?Q?YQM33BH+bopL4hM+9ImYfKEPop5PGq0M/2E/hTM/pP3wF92Gcz3BFFc/ayAJ?=
 =?us-ascii?Q?fSzjysYFpWRk9EYr8N1omgE2j64rcBKf3x69FTQbNu/ico4j89KCLrw7HYV7?=
 =?us-ascii?Q?pbSCmddxbSZjJZa/4pyvBn0sBC48R4NdkTB40xcX7vigLD01K220tT5yP2+M?=
 =?us-ascii?Q?XkqEGE6EGm54F1Q5VKE/0YM7m1nQ4jUe8aTg+GHFKTjPQkckRZPAtTDUL6qS?=
 =?us-ascii?Q?67yl+I0+1tfa4MbXHpzfBLstihXGOBR7YY+iW1R8oJkkFGk9z5l55VCkKDR3?=
 =?us-ascii?Q?mmUqAfuH/TsUJRl8bcpK7twbONm5qJ8NGCYFWAvWIaEQLoBnT1ra9LmeRkaE?=
 =?us-ascii?Q?vAXpzSZDrb7fYmKrO5Y6Z4QUo6E/e5juTQlAmOi+Jfh5YgxS8JwMpiXIOMiQ?=
 =?us-ascii?Q?m0LShj98UFtogsc5WJMkJOvEzUQ65g+248r4LAwEkoh44eYoG08zG+dicB34?=
 =?us-ascii?Q?Sspcnzutlglz5iD9ZhprP3LzDolPjZ0rJPqxfE+m6KCrQgiT/r9RiymXVIs7?=
 =?us-ascii?Q?G4XEqMWWBAgpP1CybdppO8wwIxQeH935Yrd35wDeGbVy2c7w0giMBmQWrZNJ?=
 =?us-ascii?Q?uyrU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:14:04.4165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b348f1-5d65-4ca2-2082-08d89d2eff08
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sf0kvbvDuLX9TO32ckleoikhbgbCLdK3iKuwflVkQFcq1A1MhNnC4AaCfwcj/KtHHfiSAhjcG4MIGYUFI1CZ2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

SEV-ES guests do not currently support SMM. Update the has_emulated_msr()
kvm_x86_ops function to take a struct kvm parameter so that the capability
can be reported at a VM level.

Since this op is also called during KVM initialization and before a struct
kvm instance is available, comments will be added to each implementation
of has_emulated_msr() to indicate the kvm parameter can be null.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          | 11 ++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  6 +++++-
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 256869c9f37b..cecd0eca66c7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1092,7 +1092,7 @@ struct kvm_x86_ops {
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
-	bool (*has_emulated_msr)(u32 index);
+	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	unsigned int vm_size;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3fb1703f32f8..3e6d79593b8d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3934,12 +3934,21 @@ static bool svm_cpu_has_accelerated_tpr(void)
 	return false;
 }
 
-static bool svm_has_emulated_msr(u32 index)
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
+	case MSR_IA32_SMBASE:
+		/* SEV-ES guests do not support SMM, so report false */
+		if (kvm && sev_es_guest(kvm))
+			return false;
+		break;
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c3441e7e5a87..a1ff4d7a310b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6399,7 +6399,11 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		handle_exception_nmi_irqoff(vmx);
 }
 
-static bool vmx_has_emulated_msr(u32 index)
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8665e7609040..53fe34fd1a7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3795,7 +3795,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * fringe case that is not enabled except via specific settings
 		 * of the module parameters.
 		 */
-		r = kvm_x86_ops.has_emulated_msr(MSR_IA32_SMBASE);
+		r = kvm_x86_ops.has_emulated_msr(kvm, MSR_IA32_SMBASE);
 		break;
 	case KVM_CAP_VAPIC:
 		r = !kvm_x86_ops.cpu_has_accelerated_tpr();
@@ -5794,7 +5794,7 @@ static void kvm_init_msr_list(void)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
-		if (!kvm_x86_ops.has_emulated_msr(emulated_msrs_all[i]))
+		if (!kvm_x86_ops.has_emulated_msr(NULL, emulated_msrs_all[i]))
 			continue;
 
 		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
-- 
2.28.0

