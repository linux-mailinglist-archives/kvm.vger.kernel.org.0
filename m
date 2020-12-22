Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A17A2D9E1E
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 18:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408649AbgLNRnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 12:43:03 -0500
Received: from mail-mw2nam12hn2204.outbound.protection.outlook.com ([52.100.167.204]:16033
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502546AbgLNRmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 12:42:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTHz+sEONGQmVIXnhTEg6Zz296K2DVorrJrKV+D7Gg1atqoAoOm1EGgOqaOUzkgVssXFE5135B2SPl5B528MqXDAfFou4FlzUSwwabF81AG7dzEVoSU8wDv+PPm5NG0VPNKWIGfqcbVGoKY4YeXaNZJVSgJaeiUVvv6gdqRL5ec7P7zhVNukyrw+SC2/DAuyD76b/wRMWi3PooDAuBA/MB50KDXCnGyWptC+TyP/hTM2duSBpXYrId2gjZA2TCFqVxwa5Fw4twHKN4hgx/Y/DyTA2nlyRgHw+W+8AesGlbYhR8km1LUtu6GTkfwhOxOWBWzGDP8zz0fkUbI3MBCV2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrbeWcVtwTsAGiLUmOQuK3TdmVGLrbLQkgfpcjG4iNc=;
 b=dN8AmXb3Ccp4T0xk3HHn9x2QjXn+8YzGy4TZCnGWBR9eMKomia65UbBq3Y+/PzPmpwjGWzL/qnoG+GFlrxvPafixPpbLpfeWBySeEoocajS4XWpn/rGOemC02axuLjjrWNf1VQHvcuixgNBdDdR1dzticDRQKLUv4/OQgw6y2JKnN6HXgHuEC2RU81zToUCMOPjDoAIhBvCMCH2zUxeSZNF6kEE2s+r3Wg4U3Q4xEAkQRxCTYTAJv3Zl45h2fgRx1odjEcC/t/SdyRdmqPnd0QL8SkAnZhRwkggAFsdPS64R4xWNallAvKMvECUM4kss6rmu34J8WvP1XMH97Q3NuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrbeWcVtwTsAGiLUmOQuK3TdmVGLrbLQkgfpcjG4iNc=;
 b=keVGLXoioU0kQH9sBOm02ioD4eNWfDk/14u970ohVwaBFD3CCk4xoKfQasRnuSBnAlF7A2XbZSx2L0qUDEw1oxdv7m+Yt5WnfSUzcQwvyNLPmY1IvJ+vaaxAXCQDOap49pMlnm7jAeT1i/PvlKPzB2rw4L71w138j23tFAs/Moc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13)
 by BY5PR12MB4275.namprd12.prod.outlook.com (2603:10b6:a03:20a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Mon, 14 Dec
 2020 17:41:50 +0000
Received: from BY5PR12MB4131.namprd12.prod.outlook.com
 ([fe80::2432:5fa6:a1f:61f0]) by BY5PR12MB4131.namprd12.prod.outlook.com
 ([fe80::2432:5fa6:a1f:61f0%4]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 17:41:50 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring additional host state
Date:   Mon, 14 Dec 2020 11:41:27 -0600
Message-Id: <20201214174127.1398114-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.54.211]
X-ClientProxiedBy: YT1PR01CA0006.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::19)
 To BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.54.211) by YT1PR01CA0006.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 17:41:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6627b056-216b-4f9a-0f43-08d8a05789b1
X-MS-TrafficTypeDiagnostic: BY5PR12MB4275:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB42756839A38541C0AA57A83895C70@BY5PR12MB4275.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KgYdG/SxYP4eLVfvHxU1i26fX1jOslmGbK17T8IRW5ivXgX1owMNvvPApbvAY62NWZyfofxqUONpCkX3Dv8YNIoS5HFrTlHLTv7U9RYBi7kiuSlM/PZFAwed8D1eFNMCb8EbsZ4tstVZILfh2sHEM3Vflvfl0+1HojfwiSQ/6/Zz1yatrMt6n+fIyCoGlUQ6m9Kt7rp0L4mtqQkWsQ9HczzHvBD/gncrsbiY45I6SllX44J3TEZQxnp9/ie6acwa3cjSLjMzVcgNNpcg9YznhDdAogIKovjzgBfq0ctJFUCFGqbEwMWETraPZqEXYf3/PPmcsbX3uRFk59lKqguo2B9Jc980qEvou2rFYG+OtZmsI2Pv3YZE0ZvG01xcmya23ej/SBCAC3swkyVG7JG0KFuwHmq352NgReWAEOnKkqHJh9DFtTuYdgMd1c9GwM5esAtvSm2lxWWVbIjHmuG8o5ctxpX3bZc5LQndNkEE1f2NCcRLXNsnfMOMqa6WL20MyUnwaln9mm7MAajDs7fTLcJV36jVqovlJO9fNVgAogN8vPCgQWnkj7o3ueGDfmctHuZWIa6OicKf/nSGTsm9bhz7Sr1+v2n9gGMPN03n8VGalULU2UEjeFmyS7jJKupvDmHpgrDo02hO6fV0O+jT6VedNOq4dHhJTQ77rLXojt94NmOyhxufPW6e2DUqAXM71WkCCIT6sNfMANVPeN/3mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:BY5PR12MB4131.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(136003)(346002)(376002)(366004)(54906003)(6916009)(36756003)(26005)(44832011)(1076003)(7416002)(4326008)(52116002)(66476007)(6486002)(186003)(5660300002)(34490700003)(83380400001)(6496006)(86362001)(16526019)(8676002)(66946007)(66556008)(508600001)(2906002)(956004)(6666004)(2616005)(8936002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RXoMBHxnD9y+2SA+grjH5LVUjXKUFOkWAC8NuzYNMfBYurcWyJeuMEaHsqz3?=
 =?us-ascii?Q?JcFVvc5GzU9TbnDtkIYpN5ahs3ZX54Igju8ZH4MuFhr/02oC17ZcYtdP412j?=
 =?us-ascii?Q?UT9bhCMVlV5NIsIkbbO4bvHQfAkVx0X388yLqYLiMrh48wH8gH82yT4msfyL?=
 =?us-ascii?Q?VA8Bslyvlqve0cWyRfohWOnxhlsg266IeHOehCeqLWR+Ga+6n8XP7b1+OXc5?=
 =?us-ascii?Q?YXdhzPQycQ4DSG+jZSaPLOFVbQRgaa0rWVeUrguJzm8yBxsHw2+n3w0BYbbA?=
 =?us-ascii?Q?7G1gCCxJY5ECJ94E7Ik70cjy3p4Lmu2kw+czNuy67a3qlPXljja/wLjVgS74?=
 =?us-ascii?Q?5fG0fTSk5y6atsvNLXwLwIEzbHn8LYhF6qu74vbkhP6h2na12SKNEdmVnNnL?=
 =?us-ascii?Q?YkIUWi2M6g+l2rPScSU9JLImRZlcGi7ryDgLALnk+XQ33JxpBe/kc6TnXS0d?=
 =?us-ascii?Q?j3lCrfFCD6OeL/ONwxDjIB/cSvlHZX1SQFiqPUYFJsvR5m8TMSwL++qAKFxq?=
 =?us-ascii?Q?YybT6j2lk70U+hXByXOSE/hY6ORSUwRTQMO9FT3sRZNFDcescnQBpfClH0Jy?=
 =?us-ascii?Q?hWpVlOWKFvoOIEqTtMiwbSHqdS5qbavm/ndA5s4I24K5ygHjUV4dhsN9nUXL?=
 =?us-ascii?Q?hgvzSsl/0dNSb+VaLVGwTAnS4wTVUTdDZXjessCrXMyWPLz8q2QQxQ1IFKl2?=
 =?us-ascii?Q?GYSscLZew0e4ICFxYQkIyvfQEdoO+33P5hVH+fh9FVCeOGMhOuQmgu/m2hGF?=
 =?us-ascii?Q?M9KF7FdzXF0dXMoA9N/C9BuIDA/ayo0FM7iCzNciT59ZFf5ybIIuaq/PK3Ko?=
 =?us-ascii?Q?N3xD0IuzzZLCHgR56eOAck1zuMXdjrjJl/4NTdmrmJMc78w+qkiySFumtFh7?=
 =?us-ascii?Q?wan1nB+lUEE21IcdUyOlK6yg/rxCc7bUbD1vcnzfqc6bnZ7jiI7n0EouO+8E?=
 =?us-ascii?Q?t0LBJSMvpsdejITz57f7ITKJO7KOD5/vKr9e+zQaDtfS/n9DJq1QwWYd6hvv?=
 =?us-ascii?Q?4a4O?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 17:41:50.4501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 6627b056-216b-4f9a-0f43-08d8a05789b1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgeusDRQxdjjVEzyzLiL9Qgh/o3JrdvtEV1Q28jDq1AkEI8XB6T9t2CuxNUtP3+KBR+FnosycFFDuCZMVmE81g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4275
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using a guest workload which simply issues 'hlt' in a tight loop to
generate VMEXITs, it was observed (on a recent EPYC processor) that a
significant amount of the VMEXIT overhead measured on the host was the
result of MSR reads/writes in svm_vcpu_load/svm_vcpu_put according to
perf:

  67.49%--kvm_arch_vcpu_ioctl_run
          |
          |--23.13%--vcpu_put
          |          kvm_arch_vcpu_put
          |          |
          |          |--21.31%--native_write_msr
          |          |
          |           --1.27%--svm_set_cr4
          |
          |--16.11%--vcpu_load
          |          |
          |           --15.58%--kvm_arch_vcpu_load
          |                     |
          |                     |--13.97%--svm_set_cr4
          |                     |          |
          |                     |          |--12.64%--native_read_msr

Most of these MSRs relate to 'syscall'/'sysenter' and segment bases, and
can be saved/restored using 'vmsave'/'vmload' instructions rather than
explicit MSR reads/writes. In doing so there is a significant reduction
in the svm_vcpu_load/svm_vcpu_put overhead measured for the above
workload:

  50.92%--kvm_arch_vcpu_ioctl_run
          |
          |--19.28%--disable_nmi_singlestep
          |
          |--13.68%--vcpu_load
          |          kvm_arch_vcpu_load
          |          |
          |          |--9.19%--svm_set_cr4
          |          |          |
          |          |           --6.44%--native_read_msr
          |          |
          |           --3.55%--native_write_msr
          |
          |--6.05%--kvm_inject_nmi
          |--2.80%--kvm_sev_es_mmio_read
          |--2.19%--vcpu_put
          |          |
          |           --1.25%--kvm_arch_vcpu_put
          |                     native_write_msr

Quantifying this further, if we look at the raw cycle counts for a
normal iteration of the above workload (according to 'rdtscp'),
kvm_arch_vcpu_ioctl_run() takes ~4600 cycles from start to finish with
the current behavior. Using 'vmsave'/'vmload', this is reduced to
~2800 cycles, a savings of 39%.

While this approach doesn't seem to manifest in any noticeable
improvement for more realistic workloads like UnixBench, netperf, and
kernel builds, likely due to their exit paths generally involving IO
with comparatively high latencies, it does improve overall overhead
of KVM_RUN significantly, which may still be noticeable for certain
situations. It also simplifies some aspects of the code.

With this change, explicit save/restore is no longer needed for the
following host MSRs, since they are documented[1] as being part of the
VMCB State Save Area:

  MSR_STAR, MSR_LSTAR, MSR_CSTAR,
  MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
  MSR_IA32_SYSENTER_CS,
  MSR_IA32_SYSENTER_ESP,
  MSR_IA32_SYSENTER_EIP,
  MSR_FS_BASE, MSR_GS_BASE

and only the following MSR needs individual handling in
svm_vcpu_put/svm_vcpu_load:

  MSR_TSC_AUX

We could drop the host_save_user_msrs array/loop and instead handle
MSR read/write of MSR_TSC_AUX directly, but we leave that for now as
a potential follow-up.

Since 'vmsave'/'vmload' also handles the LDTR and FS/GS segment
registers (and associated hidden state)[2], some of the code
previously used to handle this is no longer needed, so we drop it
as well.

The first public release of the SVM spec[3] also documents the same
handling for the host state in question, so we make these changes
unconditionally.

Also worth noting is that we 'vmsave' to the same page that is
subsequently used by 'vmrun' to record some host additional state. This
is okay, since, in accordance with the spec[2], the additional state
written to the page by 'vmrun' does not overwrite any fields written by
'vmsave'. This has also been confirmed through testing (for the above
CPU, at least).

[1] AMD64 Architecture Programmer's Manual, Rev 3.33, Volume 2, Appendix B, Table B-2
[2] AMD64 Architecture Programmer's Manual, Rev 3.31, Volume 3, Chapter 4, VMSAVE/VMLOAD
[3] Secure Virtual Machine Architecture Reference Manual, Rev 3.01

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
v2:
* rebase on latest kvm/next
* move VMLOAD to just after vmexit so we can use it to handle all FS/GS
  host state restoration and rather than relying on loadsegment() and
  explicit write to MSR_GS_BASE (Andy)
* drop 'host' field from struct vcpu_svm since it is no longer needed
  for storing FS/GS/LDT state (Andy)
---
 arch/x86/kvm/svm/svm.c | 44 ++++++++++++++++--------------------------
 arch/x86/kvm/svm/svm.h | 14 +++-----------
 2 files changed, 20 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0e52fac4f5ae..fb15b7bd461f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1367,15 +1367,19 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vmcb_mark_all_dirty(svm->vmcb);
 	}
 
-#ifdef CONFIG_X86_64
-	rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
-#endif
-	savesegment(fs, svm->host.fs);
-	savesegment(gs, svm->host.gs);
-	svm->host.ldt = kvm_read_ldt();
-
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
 		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
+	}
+
+	asm volatile(__ex("vmsave")
+		     : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT)
+		     : "memory");
+	/*
+	 * Store a pointer to the save area to we can access it after
+	 * vmexit for vmload. This is needed since per-cpu accesses
+	 * won't be available until GS is restored as part of vmload
+	 */
+	svm->host_save_area = sd->save_area;
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
@@ -1403,18 +1407,10 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	avic_vcpu_put(vcpu);
 
 	++vcpu->stat.host_state_reload;
-	kvm_load_ldt(svm->host.ldt);
-#ifdef CONFIG_X86_64
-	loadsegment(fs, svm->host.fs);
-	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gsbase);
-	load_gs_index(svm->host.gs);
-#else
-#ifdef CONFIG_X86_32_LAZY_GS
-	loadsegment(gs, svm->host.gs);
-#endif
-#endif
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
+
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
+	}
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
@@ -3507,14 +3503,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
-#ifdef CONFIG_X86_64
-	native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
-#else
-	loadsegment(fs, svm->host.fs);
-#ifndef CONFIG_X86_32_LAZY_GS
-	loadsegment(gs, svm->host.gs);
-#endif
-#endif
+	asm volatile(__ex("vmload")
+		     : : "a" (page_to_pfn(svm->host_save_area) << PAGE_SHIFT));
 
 	/*
 	 * VMEXIT disables interrupts (host state), but tracing and lockdep
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fdff76eb6ceb..bf01a8c19ec0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -21,11 +21,6 @@
 #include <asm/svm.h>
 
 static const u32 host_save_user_msrs[] = {
-#ifdef CONFIG_X86_64
-	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
-	MSR_FS_BASE,
-#endif
-	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_TSC_AUX,
 };
 
@@ -117,12 +112,9 @@ struct vcpu_svm {
 	u64 next_rip;
 
 	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
-	struct {
-		u16 fs;
-		u16 gs;
-		u16 ldt;
-		u64 gs_base;
-	} host;
+
+	/* set by vcpu_load(), for use when per-cpu accesses aren't available */
+	struct page *host_save_area;
 
 	u64 spec_ctrl;
 	/*
-- 
2.25.1

