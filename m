Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3E32D637B
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392734AbgLJRRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:17:16 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404188AbgLJRQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:16:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3H/h4Ax1ppyNKHnwATzOMAUqoZYS97yLX0fvkQFsvRNjbmGzeWGHDpKk0iMBGen6xC66WHrXK0p48+iW0TcBWC9vzO+uFLjkS8mX7dgf97ZL/cNIx9WKTIuNsSU25Uub8VaUhfey/3tmIcD7bfpR6JGeRNwlFicWohdPkeMLxv9Ih23W6ebCasjtgC2Web5dBIA66Fvao3r6F1Lvc6pMBXjDAQnYSFJD4xm+bxKtQbtrcwxsMiqJn495PL0Sks+zWQ/beIg5GwSyUOwbFboqNIZNcY3V0QYnfVpgspQwCPBwMqSPj1siGwmyS3W+4iYcyn0gOosY0zr0kTgWd1k7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQDRfolcVPwK1nwkdjfimQCgZDOGufsJf0149gwdgcU=;
 b=CbRLfheWkGt3phahT7zhGRT1U3f7GrPYml0LGpnIoxWOr3BNOD4cKldgiJ2seMTC3a2KyARlMItw1/FyafsC2D8MlET5H96BPh/Ymw+4GsEQp59mJo8CS+j/Nm3AJu0kXWWQU1+fPnBpR6hLFFJLrobgAWmPP+WBTEwUxi/G2TwUfhFoFCqGSZl5uLPDnk+c78My2B7aIWoU/QR3dfI9G1ykJuaw5BlwRZSdXfoTCKdzVMYqOG15Yy1QtNBP9szyR8VNOMNFr+/awlBT4XiqyqdyyjlMmQiMVLOJodYC/n/TT8f0m9EHsGRJjC2UJ0fU9K5g6jti6QX3kLsWJaEjMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQDRfolcVPwK1nwkdjfimQCgZDOGufsJf0149gwdgcU=;
 b=x2c34iuhzy1vAm0KAWxlSXYkEvjxD5st1WjkBwfMvSxU2k+FgU5mDlowBLHLUUJxfQEyOFsUC1Ly7n9TTzGxZiU/wLywPSN1tcj9KNfecNIFa8jtXStaPjUawpWmewIoUMTC9LI6ZlXGPJMJ5iFWR0b727IC9q7ZtR0xeOq07hU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:15:07 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:15:06 +0000
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
Subject: [PATCH v5 32/34] KVM: SVM: Provide support for SEV-ES vCPU loading
Date:   Thu, 10 Dec 2020 11:10:07 -0600
Message-Id: <019390e9cb5e93cd73014fa5a040c17d42588733.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:610:38::15) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR05CA0038.namprd05.prod.outlook.com (2603:10b6:610:38::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Thu, 10 Dec 2020 17:15:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28c59cef-20c4-4aa8-0fc8-08d89d2f2438
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01491488C4B874CE3DF5092AECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TOE9RDPW7D0BifOcYltHpTQKRBjgkR9fT+shZNyCnK+0m7Kx8YDHCyZdQRriT2RbdZOYr6GBd1l/pa+1V0h16mLwCYr7aeGntd2B7Wb1erv5Ng+XIZ+pEgkWMHQzhMCWRAcxfAyTW/Et+UNCI2+/Q1QfgJ5V9/Fau1JNqOM8+CtVy90ph8MEAOkrNLhrgjTvqz7dXdXmoFicgySdcFexwy72ugDsSEvYmbRWt6kPGBGD0JHbPx/1NvKRNyvVvgll9W+oQBZa1H2JCRuaeBPx7w9yG5AH+d+W9X4v2Wb4RvOAkY7xzmAD8mQdyozFRNQa/VIEw9NJnFmdj9oCe4XuwydK/XRM26bBJshCdgzPWkY5uNJMu7D2MNwk8larwBOf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HgCFU3HRQeOm/WSK434AVAhJCQQPV9PlHKohk2JfJj1Dud66j0DiIP3xZvXg?=
 =?us-ascii?Q?QKrcvbfmUOw2tvFBBnNdg1OPtAvcx4hnGC3A11iSd9FfmOEzV28+Sp/EyKZw?=
 =?us-ascii?Q?2HLCbK7XROlu3u2r2zI1lRQ50w8FQ0qUfWLKu2UiPEKSCdI1KXCGiNTDoL4y?=
 =?us-ascii?Q?XA7D3aOKHjIUQBUrn64rh3s/yRmE5BohHvCTvFM1HWIY+DD7HEOPqILj/Bmt?=
 =?us-ascii?Q?7aRMZaQ+mR9D5KAK+gBGiSEAe5SznhK1N+HV1MS763gsoTmNVXq4hXuLF7pu?=
 =?us-ascii?Q?IQsmm0PfKvgmJNmD6Djapn5xGufnJ2bG0ZYJhcOMobeClgG7jQ/1H4Ef7PTt?=
 =?us-ascii?Q?Z4TfnnjOFDXVrrfYFKmoXoQqGD8bWp4WWJOYdNU4sabOW+YKOrAqn2MvfR2i?=
 =?us-ascii?Q?qwumZkmcWQBm0sT2nBPF1KOICQGR7bgh4TpByZpTSCikLf1cWwPy38B62zcT?=
 =?us-ascii?Q?3fmXRGvQ1SbjzR7QaTi9OJopPGdRxXdIZwPeQucfC1h62jtGIFFsG9F4apYX?=
 =?us-ascii?Q?SVZxEGsjKKomMHIyPA+b4M8Y1a7Q365kQJoQJPWteQtTI2TMg5ydIDtZ4F7k?=
 =?us-ascii?Q?zEyPrDXEgr2Kis0zR4DF8DSoM7gD5d7LnqztvZK2k9gDDoBT3dkL7voj0POr?=
 =?us-ascii?Q?HwZAMvDZmRRi2hPTHOe9l9NkhwBcUJH27fCizZmR878t5skXP5/R05GFhk9c?=
 =?us-ascii?Q?W10Uf0J1N6ChQwlSeuhtzJfBGQJAgc9346lEOBkBpfVfBtcKcyWZbsUGG/qH?=
 =?us-ascii?Q?hUWWuRe0/h8ksBL61yKLeqHMrNM5L2/xFCMNOEVayVMwCNEyg2aKsu6nhMWv?=
 =?us-ascii?Q?qMSEIQM2fsE7ya4brtlT/txf2T7++0lYJtXVo8DgheyS04RhtwwgjlwE+n62?=
 =?us-ascii?Q?/d/bFblxAQCIM8k33RqQ4166xfrQNFzp+ELY6T7MeDDz+g3N5X3TfQQ5Xrzs?=
 =?us-ascii?Q?4SEZZdtpMl0FRtkN4Vh6/g5mHCjlwuXB+dlW/P4QPylrN+3YQ7g5XrBqG40q?=
 =?us-ascii?Q?jAan?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:15:06.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c59cef-20c4-4aa8-0fc8-08d89d2f2438
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vQFNENh+Xw/XGfJ5UUdwAGxCFFvfIHeF7sKKxoRAQlmpWsdg/Snrp6+ORwOL9X83pNXyaewoKhksOvAEsXG+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

An SEV-ES vCPU requires additional VMCB vCPU load/put requirements. SEV-ES
hardware will restore certain registers on VMEXIT, but not save them on
VMRUN (see Table B-3 and Table B-4 of the AMD64 APM Volume 2), so make the
following changes:

General vCPU load changes:
  - During vCPU loading, perform a VMSAVE to the per-CPU SVM save area and
    save the current values of XCR0, XSS and PKRU to the per-CPU SVM save
    area as these registers will be restored on VMEXIT.

General vCPU put changes:
  - Do not attempt to restore registers that SEV-ES hardware has already
    restored on VMEXIT.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h | 10 ++++---
 arch/x86/kvm/svm/sev.c     | 54 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     | 36 ++++++++++++++++---------
 arch/x86/kvm/svm/svm.h     | 22 +++++++++++-----
 arch/x86/kvm/x86.c         |  3 ++-
 arch/x86/kvm/x86.h         |  1 +
 6 files changed, 103 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index a57331de59e2..1c561945b426 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -234,7 +234,8 @@ struct vmcb_save_area {
 	u8 cpl;
 	u8 reserved_2[4];
 	u64 efer;
-	u8 reserved_3[112];
+	u8 reserved_3[104];
+	u64 xss;		/* Valid for SEV-ES only */
 	u64 cr4;
 	u64 cr3;
 	u64 cr0;
@@ -265,9 +266,12 @@ struct vmcb_save_area {
 
 	/*
 	 * The following part of the save area is valid only for
-	 * SEV-ES guests when referenced through the GHCB.
+	 * SEV-ES guests when referenced through the GHCB or for
+	 * saving to the host save area.
 	 */
-	u8 reserved_7[104];
+	u8 reserved_7[80];
+	u32 pkru;
+	u8 reserved_7a[20];
 	u64 reserved_8;		/* rax already available at 0x01f8 */
 	u64 rcx;
 	u64 rdx;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e34d3a6dba80..225f18dbf522 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -18,12 +18,15 @@
 #include <linux/trace_events.h>
 
 #include <asm/trapnr.h>
+#include <asm/fpu/internal.h>
 
 #include "x86.h"
 #include "svm.h"
 #include "cpuid.h"
 #include "trace.h"
 
+#define __ex(x) __kvm_handle_fault_on_reboot(x)
+
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1902,3 +1905,54 @@ void sev_es_create_vcpu(struct vcpu_svm *svm)
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
 }
+
+void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
+{
+	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct vmcb_save_area *hostsa;
+	unsigned int i;
+
+	/*
+	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
+	 * of which one step is to perform a VMLOAD. Since hardware does not
+	 * perform a VMSAVE on VMRUN, the host savearea must be updated.
+	 */
+	asm volatile(__ex("vmsave") : : "a" (__sme_page_pa(sd->save_area)) : "memory");
+
+	/*
+	 * Certain MSRs are restored on VMEXIT, only save ones that aren't
+	 * restored.
+	 */
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
+		if (host_save_user_msrs[i].sev_es_restored)
+			continue;
+
+		rdmsrl(host_save_user_msrs[i].index, svm->host_user_msrs[i]);
+	}
+
+	/* XCR0 is restored on VMEXIT, save the current host value */
+	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
+	hostsa->xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
+
+	/* PKRU is restored on VMEXIT, save the curent host value */
+	hostsa->pkru = read_pkru();
+
+	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
+	hostsa->xss = host_xss;
+}
+
+void sev_es_vcpu_put(struct vcpu_svm *svm)
+{
+	unsigned int i;
+
+	/*
+	 * Certain MSRs are restored on VMEXIT and were saved with vmsave in
+	 * sev_es_vcpu_load() above. Only restore ones that weren't.
+	 */
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
+		if (host_save_user_msrs[i].sev_es_restored)
+			continue;
+
+		wrmsrl(host_save_user_msrs[i].index, svm->host_user_msrs[i]);
+	}
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 46dd28cd1ea6..8fcee4cf4a62 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1418,15 +1418,20 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vmcb_mark_all_dirty(svm->vmcb);
 	}
 
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		sev_es_vcpu_load(svm, cpu);
+	} else {
 #ifdef CONFIG_X86_64
-	rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
+		rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
 #endif
-	savesegment(fs, svm->host.fs);
-	savesegment(gs, svm->host.gs);
-	svm->host.ldt = kvm_read_ldt();
+		savesegment(fs, svm->host.fs);
+		savesegment(gs, svm->host.gs);
+		svm->host.ldt = kvm_read_ldt();
 
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
+		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
+			rdmsrl(host_save_user_msrs[i].index,
+			       svm->host_user_msrs[i]);
+	}
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
@@ -1454,19 +1459,24 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	avic_vcpu_put(vcpu);
 
 	++vcpu->stat.host_state_reload;
-	kvm_load_ldt(svm->host.ldt);
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		sev_es_vcpu_put(svm);
+	} else {
+		kvm_load_ldt(svm->host.ldt);
 #ifdef CONFIG_X86_64
-	loadsegment(fs, svm->host.fs);
-	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gsbase);
-	load_gs_index(svm->host.gs);
+		loadsegment(fs, svm->host.fs);
+		wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gsbase);
+		load_gs_index(svm->host.gs);
 #else
 #ifdef CONFIG_X86_32_LAZY_GS
-	loadsegment(gs, svm->host.gs);
+		loadsegment(gs, svm->host.gs);
 #endif
 #endif
 
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
+		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
+			wrmsrl(host_save_user_msrs[i].index,
+			       svm->host_user_msrs[i]);
+	}
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1cf959cfcbc8..657a4fc0e41f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -23,15 +23,23 @@
 
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
-static const u32 host_save_user_msrs[] = {
+static const struct svm_host_save_msrs {
+	u32 index;		/* Index of the MSR */
+	bool sev_es_restored;	/* True if MSR is restored on SEV-ES VMEXIT */
+} host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
-	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
-	MSR_FS_BASE,
+	{ .index = MSR_STAR,			.sev_es_restored = true },
+	{ .index = MSR_LSTAR,			.sev_es_restored = true },
+	{ .index = MSR_CSTAR,			.sev_es_restored = true },
+	{ .index = MSR_SYSCALL_MASK,		.sev_es_restored = true },
+	{ .index = MSR_KERNEL_GS_BASE,		.sev_es_restored = true },
+	{ .index = MSR_FS_BASE,			.sev_es_restored = true },
 #endif
-	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
-	MSR_TSC_AUX,
+	{ .index = MSR_IA32_SYSENTER_CS,	.sev_es_restored = true },
+	{ .index = MSR_IA32_SYSENTER_ESP,	.sev_es_restored = true },
+	{ .index = MSR_IA32_SYSENTER_EIP,	.sev_es_restored = true },
+	{ .index = MSR_TSC_AUX,			.sev_es_restored = false },
 };
-
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
 #define MAX_DIRECT_ACCESS_MSRS	18
@@ -583,5 +591,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
+void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
+void sev_es_vcpu_put(struct vcpu_svm *svm);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fd216b61a89..47cb63a2d079 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -197,7 +197,8 @@ EXPORT_SYMBOL_GPL(host_efer);
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
-static u64 __read_mostly host_xss;
+u64 __read_mostly host_xss;
+EXPORT_SYMBOL_GPL(host_xss);
 u64 __read_mostly supported_xss;
 EXPORT_SYMBOL_GPL(supported_xss);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 0e8fe766a4c5..c5d737a0a828 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -278,6 +278,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 
 extern u64 host_xcr0;
 extern u64 supported_xcr0;
+extern u64 host_xss;
 extern u64 supported_xss;
 
 static inline bool kvm_mpx_supported(void)
-- 
2.28.0

