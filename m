Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9DF2D63D9
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392656AbgLJRO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:14:57 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392650AbgLJROt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:14:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pw+vvqsfaX6hmZQEE7myhfImoHNQW1TOoVVcNWhGNb2DpQ53oQUYm2sCGrXgnu5+uOVKv44hxyi3PmOhY9/czzRyxY+6XX9GgmB5HYKRimpIUaSDGvxk2PZQaFljyifgFJDXeI6YiD6jJWcNLfEzFaqVKv6ChUymzonyUzlZvbBDjLCNEsUPJuEMPTwNrkEeIUcouCu7ZGYb4K0ukDCH3atYiQoxalWXqxjCuJ2B+muwi79+pOeNqmZHL/syrNyCQH32FASe9rosI61/4nY8dXx9ObcbXAl2rSoBVADJK8g+LEJhn6MfqCYXmW6fRJLYRmy9KiQL2LHk1rpdircrqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpWjgnVppyTK73K7Nycs2y7P0yX7aKr0ek3ZgdmmT1M=;
 b=dVUua6+GHEfZjb/fUWVzOwRhPOfQONKM/2Z9AjdFuwzgv5HZwUj622xhyFt21NRQpPE48EkC08Ca+w1qMGWDFVZVgvxWo8poNiKFMs36a1SBCnEo/bHt0rEE2We8Mp7dyTJHvpG03h7z0ZBRxtSUMBSkJ7jxtpDM6s8r2ySc5CqynsL7A+H0mhpJ2KlDkv/rcHovfjX0AVTwQxap+UUPLZ5mh6evva/5txxUKEMOBq2QVZfS9H3K9x83O6D9WSRWFxQMM4kkyPfjqLtQlbHCF3TZt5HaCGgNiKwF5zTsNP3+d8BCCGXLBak+o3eWNpFEBuKt/Epn+s72Dadqv99qlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpWjgnVppyTK73K7Nycs2y7P0yX7aKr0ek3ZgdmmT1M=;
 b=D6IYNvuPJzVvZjjVArpQ0JDLZrh97plqzlStKO+jmGW2awOSC1ADxQ/5js1RvwQIfmdOQUCAtp3A/OGnmzf0sUToupHGUjc0XK8AY3YCRsoB/f1ulDmQ35MRCVGo260Il7ZjnBJMFDEIv94w+nXckIfIy+r1Jnv0xigkZVdbzQU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:13:16 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:13:16 +0000
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
Subject: [PATCH v5 20/34] KVM: SVM: Add support for EFER write traps for an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:09:55 -0600
Message-Id: <8993149352a3a87cd0625b3b61bfd31ab28977e1.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR18CA0018.namprd18.prod.outlook.com
 (2603:10b6:610:4f::28) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR18CA0018.namprd18.prod.outlook.com (2603:10b6:610:4f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:13:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61b20c9d-e753-49aa-d90b-08d89d2ee290
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB014958AE7B5E153BD5137D9BECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b/aY2DS7gavABcw+URaYVGMpdqCc+NNxoWze7ogmIAddD+aDXAJg7tAXw8gM0fB8/KQXtIS0At14Mj5prqd1SuabkoISjArEGEtOlYBtOhfA6uMLGYDeRddHmbwJPxDd67Pt80II4u/A04j4WBPOHlMenWnHocVMKOkn6Omf38TcxhquKxFek7kz7MNDVgtUPwiqrC1M3ASP41WzDtEFPSmVCFRj47i2S5oQRaZeVwPpdJ4h9nwOMUCd7b4bkAFfcTAUKLMJCzqcnK7FYqW4dno2iZd3PRzYd7KBcjG1NQyNw+UvqJocvPXdT5QxGuTHRZ57HADqWqDE1T9J+D8TFaR3mSa1wnOBdgrciK0xb0AG/R5VWugyRJV8DjVc0K80
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/bW7VYk7EaYRZ7s04Z2nOlRZKtjV5zN/Q2a33FBuen/g/9wQH5RDD7nhVaUS?=
 =?us-ascii?Q?5LKQCm5QCB4jg+w3YV+CsZzrbe2W9uW0RmZDewvNQgFl/Npab/pOX02BldcJ?=
 =?us-ascii?Q?oUHEXvqC2f80b8KNKL2PDG2z9GSo61lsiO18hn2F9/jI3BiL6vIA6dkagdsW?=
 =?us-ascii?Q?T0UwJluD2vhmnK8jacPf7YM8eSLoW24M254pNjr+Ohe6HBZswXWmP0gEdPS1?=
 =?us-ascii?Q?jeYFnJrvBJLIlYToE4KlYz4pnkmocho13I+2Qft8UVGFoWNvJw3zRbMbnZbG?=
 =?us-ascii?Q?f3vPazvey9j7GrCumBiUvK4tkLV/8OtpGvZWzhEeLZrV+i2eebIu2cN2zVyT?=
 =?us-ascii?Q?NgQWoBD63+d3kA4RXrVvDjyYa5jlAGfHrUCxlcTo88jCg5W6W+p5Ns2+Xy8J?=
 =?us-ascii?Q?+gxhjdPg28Qj3EPq05illKZnb6aTrKabdp8Gw8dbRwwQJHRfhRl5DQGt/LKl?=
 =?us-ascii?Q?uyKqXyuJ4aKO/XM+5IpjsvkyrZkr7OpwJQgIXxdugfxXxiNzbWeVhKqJbsda?=
 =?us-ascii?Q?f8OZydoZ5AateUpD2XM7PtJMeb1/mFRL7sAyuJPbffbZeT7YQ++bVUw3VVZr?=
 =?us-ascii?Q?vy0lTkpmn8pETnl8HjcPiQpW+iVlr99ObsFSHlJsCeFpM9eFUzHiZvMJ4SDt?=
 =?us-ascii?Q?ROslLQMwA3ayX6bzz6CG3lE0Z31hPzy24UZfYI7x4oUVyVnbp1MI/3SOGpGd?=
 =?us-ascii?Q?TgYcDXP++vkeqJdyCauEXvhhlnrhomDeQrj6ryZugFCB8dyZmOx2LE7jjNZG?=
 =?us-ascii?Q?XqJbbNLTyy2J8FD0XxEsZxhhcKenoa6RB6xkCsfpPn8gnanyQQtpTP7E+jgY?=
 =?us-ascii?Q?uA6X6L6lfPxWXuFJtO3N5pTJbURkWeBsD0mlJXksjF8KmhlGpuec4kjmsLZ/?=
 =?us-ascii?Q?1Z4728o0r08/itTzXhLLK30TBDFG5a03SvZMsyfGb7AL8bcprN049EFv8LTs?=
 =?us-ascii?Q?CpuhkGrBBYEv85pIgitk/HLguC6i53NxFIc8kLHEa54zegnXGsE3SvLnll2g?=
 =?us-ascii?Q?YYl1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:13:16.6855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b20c9d-e753-49aa-d90b-08d89d2ee290
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+lzdrL7cEeFhktKmvte1GaRBvyvwff5TaZPeKHLXam2Q6xZ2ntnUDTsLb5zsEYnXHgxP/dj35d8vKGXJDhJww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV-ES guests, the interception of EFER write access is not
recommended. EFER interception occurs prior to EFER being modified and
the hypervisor is unable to modify EFER itself because the register is
located in the encrypted register state.

SEV-ES support introduces a new EFER write trap. This trap provides
intercept support of an EFER write after it has been modified. The new
EFER value is provided in the VMCB EXITINFO1 field, allowing the
hypervisor to track the setting of the guest EFER.

Add support to track the value of the guest EFER value using the EFER
write trap so that the hypervisor understands the guest operating mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/svm.h |  2 ++
 arch/x86/kvm/svm/svm.c          | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 09f723945425..6e3f92e17655 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -77,6 +77,7 @@
 #define SVM_EXIT_MWAIT_COND    0x08c
 #define SVM_EXIT_XSETBV        0x08d
 #define SVM_EXIT_RDPRU         0x08e
+#define SVM_EXIT_EFER_WRITE_TRAP		0x08f
 #define SVM_EXIT_INVPCID       0x0a2
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
@@ -184,6 +185,7 @@
 	{ SVM_EXIT_MONITOR,     "monitor" }, \
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
+	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 32502c4b091d..3b61cc088b31 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2523,6 +2523,25 @@ static int cr8_write_interception(struct vcpu_svm *svm)
 	return 0;
 }
 
+static int efer_trap(struct vcpu_svm *svm)
+{
+	struct msr_data msr_info;
+	int ret;
+
+	/*
+	 * Clear the EFER_SVME bit from EFER. The SVM code always sets this
+	 * bit in svm_set_efer(), but __kvm_valid_efer() checks it against
+	 * whether the guest has X86_FEATURE_SVM - this avoids a failure if
+	 * the guest doesn't have X86_FEATURE_SVM.
+	 */
+	msr_info.host_initiated = false;
+	msr_info.index = MSR_EFER;
+	msr_info.data = svm->vmcb->control.exit_info_1 & ~EFER_SVME;
+	ret = kvm_set_msr_common(&svm->vcpu, &msr_info);
+
+	return kvm_complete_insn_gp(&svm->vcpu, ret);
+}
+
 static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	msr->data = 0;
@@ -3031,6 +3050,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
-- 
2.28.0

