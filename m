Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868A42EAD7A
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 15:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbhAEOjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 09:39:43 -0500
Received: from mail-bn8nam11hn2203.outbound.protection.outlook.com ([52.100.171.203]:62816
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbhAEOjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 09:39:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABzoZnkbzlXcT4n4ucU2KP5/p8S2o501uOiozV/w6BJwyXea+NrHBuyjiMo7BYBvtN5j3u2J1vTErjXfnIsWH0OBlEzbUCSPKOWqacTPa/WX4HjbLXEkekGhnZcRYYx4WtKoNVpbMOAcxA2wU+Y+D69UCDp2VVLoZwwyphCjrbDzUxMgkCjZxZQlASdKxJ9NTbXS9Veawny0ZoYGDB1wpNEWKyWl0U2hjaIEJ1bVjRD7Y0MxP8PJA02sf4xClYw9oIQwbLQo1H8WUVwsvBB7lmAKFDSL+/FtBSCRwMIAA12tIXpFMN8m+IOaxjyCCr2OD4NK7LUk5PAjULQ97gyhjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASThIUSUvobyLczmMW3lew/MzA6MTfONcQv8fMoHdRA=;
 b=XtC5cpfqa1O+kO4viffEMWwn6r+x7apPUiW1Y2j+RlfO++8df9nmnA3yuv64t+kJjaHoAiNtscyuyMC6xSI498RqNBKdXiyDXhb6PUs7o8cLYnyhhPdn5IggHtwqIHkcTx9rdMy8nsLJ+DJEagdbMatzqo5JZs/6ZI3/FiK5MQA8nOTVemDGTWoKn7jqm3BFiIELnlNfTp/KNHpBQmvDSrRk74jFypMRM1dhx8s+V9mkFiIG8B360LRUNCUNPHOX94kcb1wrpLkDo2htEguX2Rfzt3X7yCotwSIm1vATRWOSQaf0rYI4A+XzUmJLxl69vvLvWXdrcTAIu9iipPCQdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASThIUSUvobyLczmMW3lew/MzA6MTfONcQv8fMoHdRA=;
 b=Z0E3dX9XswRuhVRpKB9VXsWQR0ugEwWdDZ6NScxoYNwiEWtTQkMLqZcobzHJhK+kYlB84aGsQqXBA2iLcB97jGKsQFzS4WF0U74LIt/mZ+wz9oYhZ3kxULCJpV+YIG+GnppMBmv347rLC04/l+LjrrFQadwBTdwsM/AjzEDuC+o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Tue, 5 Jan
 2021 14:38:52 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 14:38:52 +0000
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
Subject: [PATCH v3 1/3] KVM: SVM: use vmsave/vmload for saving/restoring additional host state
Date:   Tue,  5 Jan 2021 08:37:48 -0600
Message-Id: <20210105143749.557054-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105143749.557054-1-michael.roth@amd.com>
References: <20210105143749.557054-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.54.211]
X-ClientProxiedBy: YT1PR01CA0077.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::16) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.54.211) by YT1PR01CA0077.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 5 Jan 2021 14:38:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b5b973be-a9a8-417b-2849-08d8b1879f58
X-MS-TrafficTypeDiagnostic: CH2PR12MB4134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB413444E136437AC679D946BA95D10@CH2PR12MB4134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z4F0wG4GjTmZX2A84dkPJS6qH94KOLLA3ZXZV7ncj77XDhFeJHjr/0H2pppQf9xStNKOG+0CYO5+24SiOalcBniuw6w3Ncg6+BxiJwgpzVg0+yuxlkw2E6pUajMXvsH+CEWqvGfbam1oYRZdGUwUO7OyfnqAflTaNSNTdaOErXr3bWvLmcGcWwqmbG2ZL/zmNXkjpqpEslHdXk50W+jlCf4lnAzyK9wGgGFnUiTwj58Fr2vpSvW3OXssqLgkcwL8xEL2Jj2Cw2Jp0RCf/KpKLP3lUWPc0OnyjLjU69ogKnOUEp0ephLwkQme9VWcyYxPrc9GkwFxNPdB4/Q1LZNq20O5eMqx5MHX5Fe2UqQJ696AA4egJGnBlljlwX1IaP/VxrK2uC6Vhg/8CDrm0DSkX9Qf8C++RvSs8wuKR7bhF2XJrPuWbuaNHVSYYqDVaO832sSGKXK60lGqwFxl16jcvydmg8ODt315uFoL23Ao++Qu7fJDgBCBP2EEivnAdJvCL6noI9wwM9XD1i6rT0coAUwASlGbS1+nhHcWH9tmulysjY6L9NVS/RaQcVkZwSatLwyTzfIWuesF7dseuHC9jmQdfrIcb/oWGn9htnR9Xz9bixSP9+y+skG0OEYAIxQ1krHgAJ6Fkyt7CGVA/DbZ0Zmm417kT7GITUVFPrLUJ+WM6ND6l0DgOsMZ2slESL9aBg8OCgO4nPB6fw4HsD2shLKAukLUeKeZgc05aIrc9HkX5GksxgEaNTNxryjmRm1B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(6496006)(52116002)(16526019)(956004)(2616005)(66946007)(54906003)(186003)(6916009)(2906002)(6486002)(26005)(86362001)(8936002)(1076003)(44832011)(4326008)(5660300002)(7416002)(83380400001)(478600001)(66556008)(316002)(6666004)(8676002)(66476007)(36756003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NapcsAcj0ohY60L4g30hwf5YlJ0UzKvThiBmgEMTEPFlkrsR4JOy2DuxNeos?=
 =?us-ascii?Q?KbJ4QTSbY1pwb5FdV8XUy9LB9/gcyiot5WzpIRWQGuQdsNSa7pzk0KDyKT2S?=
 =?us-ascii?Q?d5I+KIPrtkpAtnodlTZ/EmS9rvgO0G3KLPQjTKJFK+wTRk9Ro3FGc9a5/tD6?=
 =?us-ascii?Q?g3Ji/Tl8QK63XTpcVO0ahNtD88/OPjpiSkwf638RAg1WRJh0XgwRQdHML8AG?=
 =?us-ascii?Q?hkthhS6CMdY0D/1NBy2hX39F4342CCsQAOSfAg2YyeBMMaNAhCLHadd+iZfR?=
 =?us-ascii?Q?FP4zlaN/3mHWZboRAQeVLfJXxVSeF8s1RzG55YqBwPvCZussRSUtn8B6jt/F?=
 =?us-ascii?Q?+4PALC5dsEqHhJlz3H901DCwnNRWPXe5v29/3MSh9TRrYiUdfKdZo8yGCEOA?=
 =?us-ascii?Q?jMqbcFJlHGe2SZNvRATjNAI+xNj5t3MXDEybzCR+rf+07QJLjm3nqzD6X7L2?=
 =?us-ascii?Q?gC7iuTCNSVX39y854kcO+gOFAfWOZQqhhvkz6XcgVPCpAL9ztjh4AG+UQ+8P?=
 =?us-ascii?Q?IshZ8uBhFtjtGWfal4PkWWu4RT6YiT9dnbVKz2Cxgy+6RLU0JKhxXYIn9CiW?=
 =?us-ascii?Q?yEQ9QanB3PGUldFzdwn4bqfmHhFfjD+HLpq+vZ0exNxOJ9MYwHqP3aQzINX8?=
 =?us-ascii?Q?GiLBJ/u6j+JsJTlf89hOm9Wn+NnduRdqlK2seG1JbCJkMpmPpfv0OvVDiy5k?=
 =?us-ascii?Q?7kwlOrobHD6vtN1mZ9qLe1ezGrUw3LlziA1jAGUTkh5OrzoNiJi2bGNowgcZ?=
 =?us-ascii?Q?O072ONTvqY7P7I0Fv+ZtAJrGpgB0m7jSdWeUB5MjVNRmQd2RV18rbQzMARZA?=
 =?us-ascii?Q?yWh7Phgy0+PZbY7pBrBbGbxqtNFgpGIUeVM7BCM90WcCv+hKR7/V3XZW00AR?=
 =?us-ascii?Q?ao4WxafF9gzHwBzSw9rAfNRvMJscOKULIhy3cBS4JOw0+NP2K3cJ/CyglY3g?=
 =?us-ascii?Q?GBmU/YWNY9UOb7yxtx3zstfYWskIWjDUA1doSk2VZQy/+mo1aNn8mxSe03+C?=
 =?us-ascii?Q?vs1l?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 14:38:52.3677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b973be-a9a8-417b-2849-08d8b1879f58
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QhbTViAdXONf6m2FfWfSGr7Ca/GuCaW8oeWVKAp3TbTfFwf++qGLkhjCGuI3W+J/C7VklBRZ7sq1TNMXFUXFDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4134
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
 arch/x86/kvm/svm/svm.c     | 36 +++++++-----------------------------
 arch/x86/kvm/svm/svm.h     | 19 +------------------
 arch/x86/kvm/svm/vmenter.S | 10 ++++++++++
 3 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 941e5251e13f..7a7e9b7d47a7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1420,16 +1420,12 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
+		asm volatile(__ex("vmsave %%"_ASM_AX)
+			     : : "a" (page_to_phys(sd->save_area)) : "memory");
 	}
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
@@ -1461,17 +1457,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
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
@@ -3675,7 +3660,7 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
-void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
+void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs, unsigned long hostsa_pa);
 
 static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_svm *svm)
@@ -3703,16 +3688,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	if (sev_es_guest(svm->vcpu.kvm)) {
 		__svm_sev_es_vcpu_run(svm->vmcb_pa);
 	} else {
-		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
-
-#ifdef CONFIG_X86_64
-		native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
-#else
-		loadsegment(fs, svm->host.fs);
-#ifndef CONFIG_X86_32_LAZY_GS
-		loadsegment(gs, svm->host.gs);
-#endif
-#endif
+		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs,
+			       page_to_phys(per_cpu(svm_data,
+						    vcpu->cpu)->save_area));
 	}
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5431e6335e2e..1f4460508036 100644
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
@@ -595,6 +578,6 @@ void sev_es_vcpu_put(struct vcpu_svm *svm);
 /* vmenter.S */
 
 void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
-void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
+void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs, unsigned long hostsa_pa);
 
 #endif
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 6feb8c08f45a..89f4e8e7bf0e 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -33,6 +33,7 @@
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
  * @vmcb_pa:	unsigned long
  * @regs:	unsigned long * (to guest registers)
+ * @hostsa_pa:	unsigned long
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
@@ -47,6 +48,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 #endif
 	push %_ASM_BX
 
+	/* Save @hostsa_pa */
+	push %_ASM_ARG3
+
 	/* Save @regs. */
 	push %_ASM_ARG2
 
@@ -154,6 +158,12 @@ SYM_FUNC_START(__svm_vcpu_run)
 	xor %r15d, %r15d
 #endif
 
+	/* "POP" @hostsa_pa to RAX. */
+	pop %_ASM_AX
+
+	/* Restore host user state and FS/GS base */
+	vmload %_ASM_AX
+
 	pop %_ASM_BX
 
 #ifdef CONFIG_X86_64
-- 
2.25.1

