Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE7030CAF4
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbhBBTHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:07:37 -0500
Received: from mail-mw2nam12hn2219.outbound.protection.outlook.com ([52.100.167.219]:28736
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239411AbhBBTDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:03:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtJtpQkxn/9IDTPrarlO1wDHzkhuFZhzG0Qu6TiEfB8ZlYedv10ht3W4wKSDy4B13b0TzcXZ1egUht76FPEEocxdkd9PNVtEClzupRUx3lJPaZMd6X9UX3k6bzrjbTibaoW21gGRSPzOxgP81LRvYVJK4uk+eS7OxyYcJvCRd/buVnuRt75Wh170BbjSNtqDA/Sq7p4KL2M3I0rHjdQESLC/U+9iAzMT7M2XILkdGt8cwcoRrsxn0tc0JhifVtpQQDeoPptOSrGtAfOsyjUx45eOcSk7x8iBcjAJjzEEe0jRazi/yyNQDpGrBlhZOeZd4yAScOXolsc7gQCBWdHZ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44wOblXdL5kqFLlvvvthkEjwALIAI0JsqHasc9b9oxc=;
 b=WE8baLDt0cXdbdbMpAAuu/R8q7JXcWIZhAXXkzQVkTDM+5sEh6Wi1D63uXc2Spr3vnI6js5zW8iSAJRefJh+UESDGmGreZGAJ48cZwcAcdxI7wJouji/utXf4VUhc6mChUwZH4NFl45NgCj/FEP+I34CDPvvkDEWdrOrppArDgVDvGN2vKVXzQcrbLcnU8e7At2PDAhhIFJcSqEJh1BBeG8u0sRZHLjTjlj7DtPuQ6VKDAoC1e3nc2KR1b3s005eaq2nHMqGluDhe7gJsITOJov4uIpGmKnVzuFQK+oR9DEfuakSUHj8kMt68mq6Uw+VxjpXv/5dJKArJAj4p7HJWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44wOblXdL5kqFLlvvvthkEjwALIAI0JsqHasc9b9oxc=;
 b=kpZwzOpDWBCCdhG7koy/77ct0fymLTstoJzXtHybmi1S90Gle6Caizs8YZSk68MXk8yJE8LubC2MsXhs7M6+DXZLiofE5H43Oxf1WzNsQhJGuzuZLlrrectM15oZ2SWZf672VKRr4Yh4xXfDWdiPP8w4e56bslEAUhCoy8ny0Ho=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4264.namprd12.prod.outlook.com (2603:10b6:610:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Tue, 2 Feb
 2021 19:02:00 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 19:02:00 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v4 1/3] KVM: SVM: use vmsave/vmload for saving/restoring additional host state
Date:   Tue,  2 Feb 2021 13:01:24 -0600
Message-Id: <20210202190126.2185715-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202190126.2185715-1-michael.roth@amd.com>
References: <20210202190126.2185715-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.78.25]
X-ClientProxiedBy: SN6PR01CA0025.prod.exchangelabs.com (2603:10b6:805:b6::38)
 To CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.78.25) by SN6PR01CA0025.prod.exchangelabs.com (2603:10b6:805:b6::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 2 Feb 2021 19:02:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8583233a-5021-4a9e-e748-08d8c7ad053a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4264:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB42647444BE18CDC13EC2005E95B59@CH2PR12MB4264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rLhHZD+TsUOau5rrSa1PxlaWbkjuYGcFCHHOl3Fc7MizXnRD0qQYgEa/JTdeydpTYIIHKNUP+U/A61JYFL+gbThRmJERg0BS944k6Aw35SoKBXfilSD0JLtj8O+MtMUYtxk7GGj+VhkwhAhuiL/QxeIOuD4EJICgNqKTkHnIjs9nINnXsxIIUxtoqDJMeOnmPoxErxUnYVu3OVsSC8XyydZNoPJGRkR/6vUTPjdtgpd4XMdiWRxt+Qt3wfPRNPNtzvxT5Cgacf25ANdzdirDMCNnspgggSlx+tJge1D0YSs81D5/z9JgInFWpR0t6+6RDiME2CGrD+XOuS5Q1B+kZJbAvzEirriz105VxJ2YM8cJSFO5kORiGzVGAbS3ypMbeTd2go+1idkDVtkw1yZ2KZONBQk8siCnitZ/bQPr3t81wjMZIHYPdzpZKz0TFKNxZqIJfHRDA61RupQr0inqUWEZb8It8ekI+k8jnQ9jGiqayNwFXVbw0c9iIJYz+FJ5EA8ES/P7aiGEJw9rSUnNdvRII2fj32aldxYiPBl0aPkHtRG5hSOJ7hU0UAr5lOg32367fpiGT5aPTeoV8jZUv2ybub9/xWcvWuaL6VqptjBuQiJshWnfwwAvZ047mtPE1UOP3UnaA5XLYfo7Dt3F+Sfh8pgGFlAx3746QblUibn4Ouh3hBpL5mm1Up05nMZzSTXQczidW/kB4DRbuXtJhb79m2iSmPt41nl9iFomxrCgBB0nKb9iDW80XT7zJ+kfWM8VYCTTPl+PJNMW4pCpY7q8nscFA3AQZUoaHnzTHz6DNoPFo/fZ9+ZqbyKMMNkCALZ1nLYilFepV9QCLJSVz5SGwKo4BZF2TtZJ55lp+f8MSAP52iwyFhYJw2+5M5hq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(186003)(6666004)(16526019)(66476007)(66556008)(2616005)(956004)(36756003)(8936002)(44832011)(26005)(2906002)(54906003)(83380400001)(86362001)(478600001)(8676002)(6916009)(7416002)(1076003)(6486002)(52116002)(4326008)(5660300002)(66946007)(6496006)(316002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gDk+oEIdTL6tkiX0EnjZ3ZrkPhWcxpOVtHAojjKjG0OjisDYPBHoksLrpF+u?=
 =?us-ascii?Q?dEowqOqmiciXOwjKe0EL5V2mi7E5kAweT4sU/0FAWMMY2j9X55PsS6ESC5dH?=
 =?us-ascii?Q?2GooW4XilH7z/NTHAQcqIoq+T7G1bp0+aIeqfrtwW/vimQsXW3f9S2K5q9Xm?=
 =?us-ascii?Q?1nV0fxQhtK5QDePSmYBxK450605R3QlxVi4BqtfVCzJ3xUxmssl5Ep+1sVjq?=
 =?us-ascii?Q?S4286h57eSjUeIbboj9lrI/YRFaf7WagCuLHSPNSS4+7jm6Q5a2M2+wc9jRo?=
 =?us-ascii?Q?Pt8AfiE1e4M3U/X/ISfyG7tNUXAj6bx/2dkpLdR9g4WZDKKoYD+gjnFlJhp1?=
 =?us-ascii?Q?KrT6Bb+eZLgX+lcNaqQc81xbj88vglcGeQGhE5jDl72TREAvU49wbv0vmWFF?=
 =?us-ascii?Q?KvLgBxvgbWkrZjfRcV4ucd0BvqXtT5yuFwKVTJD9DlE0nWJku8znyZ/DicE+?=
 =?us-ascii?Q?U7w+Hm0TF6YKhBGAmNzH7KGv+8KHQZD9TkUKM9GzYdW+CuRExuxjOjru/C6c?=
 =?us-ascii?Q?E1sXxh/c3NUsE+TPQCdSS8BH2r5bprKySb1i4Yest7kqVbvNOGM/zUXAylbs?=
 =?us-ascii?Q?ZDO6TiNg0tSHiuqBxGbSnulKijGus4lBAbtcVeNrMOUfencrEwLUfgwJvxrZ?=
 =?us-ascii?Q?Nfw+sqaO9gQphFae+gKddZP5gRFXQodFMc/NnHgT/OpDvLZoNiVDUFZZQs2l?=
 =?us-ascii?Q?w6o0o/IXdNBsh8rrLM2NPE2U2Aa67jUo7io91L1hJiGi1IyPjr7/2BhvKWon?=
 =?us-ascii?Q?wZIofAZVTtSegQvV+fb2hq8BXUsnatfnxMF3DcoiLakkjM/qoxq5Rx7pzcJN?=
 =?us-ascii?Q?ppX44Ul4WlrQS5DPEwyt9zTmDOJsw6BmdQSBbnCP+dgPefpxk334cq7RUfEl?=
 =?us-ascii?Q?ccfuq9ixIkI6M3phIBnIQQrsbkV998jHIAsNiuztNE4mCtjLq9dok85JGZgK?=
 =?us-ascii?Q?BhrbR2UdITU7o+J7FZrvz5or5d1ltNH1c3VgkhtA27Oq+zRb/LcDP4jU4bMo?=
 =?us-ascii?Q?DiG6ng+k+36/a7Ey+Rwnp3mckRJE7TMpfX3Rb9qAvMED7HyLbUW3BUavY3oM?=
 =?us-ascii?Q?v8Fv3DnyhGBhFskFP1qkcN7iATVlD6Xwt/qbexioZXxR3HUURrCai3+swC5l?=
 =?us-ascii?Q?+IygyqlrQQ0yOmo1nO7RhN4/McSLDGxnzr1x0m2DTdOb+sg5mkQYw/IuViQQ?=
 =?us-ascii?Q?rABRh6nQNvNEizVVWyrFQ2Z+F6J7ysu5fGg857gNrGz8HL08RJayZbdTZGZ3?=
 =?us-ascii?Q?2VRdJ5T8bYD7BY2wExdTZIaN9cKXVyK4rCFOHxEaI9DeSN6Kf6ww6ieusuay?=
 =?us-ascii?Q?2nJj4joxWDl7koor4lvtvVP1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8583233a-5021-4a9e-e748-08d8c7ad053a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 19:02:00.5185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFp2xgZ0mwBk/nYegL37/MHaXIPLBWvoKpG72Iru7nOAPFNXdza4VRfVZW4LNv3RFZZ/GYnJ7Xg6ZtRtKTd0Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4264
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
 arch/x86/kvm/svm/svm.c     | 31 +++++--------------------------
 arch/x86/kvm/svm/svm.h     | 17 -----------------
 arch/x86/kvm/svm/svm_ops.h |  5 +++++
 3 files changed, 10 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 687876211ebe..bdc1921094dc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1422,16 +1422,11 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (sev_es_guest(svm->vcpu.kvm)) {
 		sev_es_vcpu_load(svm, cpu);
 	} else {
-#ifdef CONFIG_X86_64
-		rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
-#endif
-		savesegment(fs, svm->host.fs);
-		savesegment(gs, svm->host.gs);
-		svm->host.ldt = kvm_read_ldt();
-
 		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 			rdmsrl(host_save_user_msrs[i].index,
 			       svm->host_user_msrs[i]);
+
+		vmsave(__sme_page_pa(sd->save_area));
 	}
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
@@ -1463,17 +1458,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	if (sev_es_guest(svm->vcpu.kvm)) {
 		sev_es_vcpu_put(svm);
 	} else {
-		kvm_load_ldt(svm->host.ldt);
-#ifdef CONFIG_X86_64
-		loadsegment(fs, svm->host.fs);
-		wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gsbase);
-		load_gs_index(svm->host.gs);
-#else
-#ifdef CONFIG_X86_32_LAZY_GS
-		loadsegment(gs, svm->host.gs);
-#endif
-#endif
-
 		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 			wrmsrl(host_save_user_msrs[i].index,
 			       svm->host_user_msrs[i]);
@@ -3780,16 +3764,11 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	if (sev_es_guest(svm->vcpu.kvm)) {
 		__svm_sev_es_vcpu_run(svm->vmcb_pa);
 	} else {
+		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+
 		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
-#ifdef CONFIG_X86_64
-		native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
-#else
-		loadsegment(fs, svm->host.fs);
-#ifndef CONFIG_X86_32_LAZY_GS
-		loadsegment(gs, svm->host.gs);
-#endif
-#endif
+		vmload(__sme_page_pa(sd->save_area));
 	}
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0fe874ae5498..525f1bf57917 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -27,17 +27,6 @@ static const struct svm_host_save_msrs {
 	u32 index;		/* Index of the MSR */
 	bool sev_es_restored;	/* True if MSR is restored on SEV-ES VMEXIT */
 } host_save_user_msrs[] = {
-#ifdef CONFIG_X86_64
-	{ .index = MSR_STAR,			.sev_es_restored = true },
-	{ .index = MSR_LSTAR,			.sev_es_restored = true },
-	{ .index = MSR_CSTAR,			.sev_es_restored = true },
-	{ .index = MSR_SYSCALL_MASK,		.sev_es_restored = true },
-	{ .index = MSR_KERNEL_GS_BASE,		.sev_es_restored = true },
-	{ .index = MSR_FS_BASE,			.sev_es_restored = true },
-#endif
-	{ .index = MSR_IA32_SYSENTER_CS,	.sev_es_restored = true },
-	{ .index = MSR_IA32_SYSENTER_ESP,	.sev_es_restored = true },
-	{ .index = MSR_IA32_SYSENTER_EIP,	.sev_es_restored = true },
 	{ .index = MSR_TSC_AUX,			.sev_es_restored = false },
 };
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
@@ -130,12 +119,6 @@ struct vcpu_svm {
 	u64 next_rip;
 
 	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
-	struct {
-		u16 fs;
-		u16 gs;
-		u16 ldt;
-		u64 gs_base;
-	} host;
 
 	u64 spec_ctrl;
 	/*
diff --git a/arch/x86/kvm/svm/svm_ops.h b/arch/x86/kvm/svm/svm_ops.h
index 0c8377aee52c..c2a05f56c8e4 100644
--- a/arch/x86/kvm/svm/svm_ops.h
+++ b/arch/x86/kvm/svm/svm_ops.h
@@ -56,4 +56,9 @@ static inline void vmsave(hpa_t pa)
 	svm_asm1(vmsave, "a" (pa), "memory");
 }
 
+static inline void vmload(hpa_t pa)
+{
+	svm_asm1(vmload, "a" (pa), "memory");
+}
+
 #endif /* __KVM_X86_SVM_OPS_H */
-- 
2.25.1

