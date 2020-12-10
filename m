Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241E02D6421
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392925AbgLJRxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:53:10 -0500
Received: from mail-bn7nam10hn2221.outbound.protection.outlook.com ([52.100.155.221]:19105
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392889AbgLJRxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:53:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+ViLrTQvH2Xp7wVp+o40GQA231XlVNgEZ3YALl5BVfS+OoWXTdIvKfarlcxE3f/5nqJPdetf004dSmo8duCgjyIv/u2+Cx1mcVRI5Op6Q7nr0F/nny1rOmjc5fCZV815rOXmxvNtb4wLIE4en3yWSFgZIwtP9raOZ95dzvFihCWgOK6EJEYYdWbAXzrv4whtu1iaYNYP9mHPR/gwHN9PDyXWQFmmT1NeavIW4pZLVqD1+MP3qKN0t4HZWtOlYyN/LCJGSsMSmIoPyNsnAoYAdIV2fC/xTZ5T3JbReHvqN2614cXx+tbfWF+l+U81lm69bl/3GXvVvTPD56h+PElUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urobVT8UCA8HtaJSlMSkRSSBi/svQKWHAIb3/zlBE5M=;
 b=RsSTXn1l0j8jkd9c5IEmNygvGiIHv4rFmXOm9lNCUUO6q+Btm0ta8nsxCZVK3CzlrmdlmupRXUeKSzw3UmQp5tC6XQBrW3fZ2FDeeSVVzbTA7sCIWME43GNwh6faHgKWRCN+QJYi2yz6xK/JwBKLehsCE0Z2GgYfSs56CPE/7yAxf+R0rqBNQe/rbwWYgSiQz3X3n15TG8P5JavhVI9wIu9DoVbyp6OYgbSjCgq7+nHezlCI/zH9Nn26dAtst2tnZ4pUiuYHZJjjFqdYU7gDEpB7Je4rPHMaLDO2/EuoQmbe01PfilBqbVzCku0X+YSjKs1fiP8noyn1rF8B8sWjFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urobVT8UCA8HtaJSlMSkRSSBi/svQKWHAIb3/zlBE5M=;
 b=P9Tj/LQ9Ozy1IMES6ANbAImFLgZB+aiZnIXiYc5Je9gOja4nf9X+xbJp8Srl08hFNO44oui5MWXxqQOJlO+4nqPczI1zsyqKf6NbxxKD7Exw9lI2KlCZytW1LO4Z1slKyaeOMys0LdoguzlYBD9eRdfn+LguwScvt/zFwMQxt78=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4806.namprd12.prod.outlook.com (2603:10b6:610:f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14; Thu, 10 Dec
 2020 17:52:14 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e%7]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:52:14 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] KVM: SVM: use vmsave/vmload for saving/restoring additional host state
Date:   Thu, 10 Dec 2020 11:48:14 -0600
Message-Id: <20201210174814.1122585-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.53.104]
X-ClientProxiedBy: BYAPR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:a03:114::25) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.53.104) by BYAPR21CA0015.namprd21.prod.outlook.com (2603:10b6:a03:114::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.5 via Frontend Transport; Thu, 10 Dec 2020 17:52:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93edb81a-770f-4096-fb98-08d89d3453d5
X-MS-TrafficTypeDiagnostic: CH2PR12MB4806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4806BC5B863DFAFAA0A78C8695CB0@CH2PR12MB4806.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oqUyPgBfc1A5TrA6Ylnrkw+GC3HKEAA5b8tIwnKA6hvlgCbrPF0ZH9ScPtLjSpN+RCx5bRxyi49hukhCCQsx8qxMgCOiSr9fW2i0M2hCI8Oq3fdisMpMxOpCZlU01t4Y1zmfbIkN6iil+LdLnS6YIn8d7raPXj6l5LJ6zlIYO2aLVv5AdLLVwmiaOQPp8s0yAMM/ckyD6YrsJdAfWCiuHY4mrNwoS+pUj0MAp7kAmcIVjOfdlv890JAibzoUc1E2EmqgCuAmE3mUtDpYGX0mZ7EaJh80UkigC53tOONrlOUssPM33dvPfOHaFKiseKhcOdUKDO8sJOUE9QcnSYAHx3qzlP9fV+WPneO4XL4yfHOyzSZ1mVLexr66GQ1EF57JrLLS4JngIs2O8GcmLFXmuK+7xgrsRSXrwhDr965ErbMfJXUUVKjVaqraXUpYTGDiNgd0PaVoH5rZgDDDHJDyTlygpXlY0ecyASNco6XGefbU2Iz4lfL6ocZbKXJk8iUdW1xPRRp4t6/lJv+SJP229PImBvavkHcy0+fntTYeoUwysMG+HA8CtO3owoA39Cq9RiOnpyltaeXf3T5Dg9CgLfu7RmaQL7XjCXnILZFvXZ2FyOLgO1pnK0cx6MDk3vVOtBXTI77L0ZtX4rI53PShySP169YNOYDugd2mWv+HeLtFcU6VyUO+4akrgHy57KwkgSa187gxVaL9lxxPB/oImQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(366004)(346002)(136003)(66476007)(34490700003)(6916009)(36756003)(4326008)(2616005)(508600001)(956004)(5660300002)(8676002)(1076003)(44832011)(83380400001)(8936002)(54906003)(52116002)(86362001)(7416002)(2906002)(186003)(66556008)(6486002)(6496006)(66946007)(16526019)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l3h3vxr+tLO/aES48EyM1lX/OOkj7kx+DSpG/U1LUDkEK/kUrmAAGuB8T2Yw?=
 =?us-ascii?Q?0sH6MmQ1TitXDZn3KFHpTI2v0Ne6IzgrIH50rsCq4h2KDIGX9CgJS212dZhl?=
 =?us-ascii?Q?offvY38/Tlfw/PYgBXdIFYX1lkmT/RvnIIbot8S5YjNiJvNdPb9qGpvFK/+j?=
 =?us-ascii?Q?P+oJydR3R/UIwQvh2EsZQQC2+GUjSWCukIB43j/Iv4THT5C7LKIEhtN4s8HO?=
 =?us-ascii?Q?jKIrPQxoJPQ529QV40ieYeqdH40gZc2kYBNNLnr+MenK/77Eba0m3mtUJ1Mo?=
 =?us-ascii?Q?e5KqCEkHIcrOo+pzdFUzHbECkQ2U5+5pXrp2sYheFdr4JAlffI78zYUnPk5f?=
 =?us-ascii?Q?NW7imdtKwUi9SblXqvXDW9pe7SEO1WF908wR84vRbgI27VGZZtyRguRaQ+Ex?=
 =?us-ascii?Q?GhCzBS9gK9R8dRRO8vRATOZL+Mi5vnSCC1BaPI/hp0XQ1S+04f/9CjWbulmC?=
 =?us-ascii?Q?0m9ydY8XbcR3oS2uuUCqReltticAxqx/YNU0abuWlibdII/Oa69fGqN8qAiZ?=
 =?us-ascii?Q?ItkCvQ/zC6EnkB271oMmPjyW7URm9shSvQiyxHP8OR91PefZKxc6G6xuYUkA?=
 =?us-ascii?Q?LKhLNW8Wcb+gkGrtdLgOcpT8LK2Z+l5LbOX8GTKJaY+6GSv8ksOmOJjBeGXr?=
 =?us-ascii?Q?XCyUjZRjOTVj991skICCHXJvbdn6V5x8eH1YRVQAuXWPG/M0dd7VXNdZdb16?=
 =?us-ascii?Q?bW1T31Hsbmw71PwHGuVNs5YTPq+/7DbO5JN/yjlnD8DRBPSckLAOgjL6yVyg?=
 =?us-ascii?Q?3VoyotSqLjvLw69vh2eIXlkq/eNMx6+7SxSTsPnp3d8WmiYrKf6G4/ciL4I2?=
 =?us-ascii?Q?d8VO+zCh9Bt0cest/QJ1GofwuaLxuC1gz4mIHLpqm/5YwrBe+9SdzHwDxxSe?=
 =?us-ascii?Q?aAMG9BM10axnrv4kSkRO46XOsBGsiD0R26D0GNQVOcxZTfnHDWVJ4V+Rs1sj?=
 =?us-ascii?Q?p8NRy5EJ2sRjpqy2i5tHlA3VjNaqxHdpox1Zjqy0AJEdwtM37TrGNABHwLuk?=
 =?us-ascii?Q?L9dh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:52:14.1565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 93edb81a-770f-4096-fb98-08d89d3453d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IqRAp6P1kezhxcZUqgzbuDU3AoLvq1zzEtTN348fAwHNSYtDY1E/kiCWSXcZjfAkqohI/SfmlR5h42fjPMcMiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4806
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
 arch/x86/kvm/svm/svm.c | 48 ++++++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h |  6 ------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6dc337b9c231..d6578bca0a77 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1360,6 +1360,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct vmcb_save_area *hostsa =
+		(struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
 	int i;
 
 	if (unlikely(cpu != vcpu->cpu)) {
@@ -1367,15 +1369,26 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vmcb_mark_all_dirty(svm->vmcb);
 	}
 
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
+		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
+	}
+
+	asm volatile(__ex("vmsave")
+		     : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT)
+		     : "memory");
+	/*
+	 * Host FS/GS segment registers might be restored soon after
+	 * vmexit, prior to vmload of host save area. Even though this
+	 * state is now saved in the host's save area, we cannot use
+	 * per-cpu accesses until these registers are restored, so we
+	 * store a copy in the VCPU struct to make sure they are
+	 * accessible.
+	 */
 #ifdef CONFIG_X86_64
-	rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
+	svm->host.gs_base = hostsa->gs.base;
 #endif
-	savesegment(fs, svm->host.fs);
-	savesegment(gs, svm->host.gs);
-	svm->host.ldt = kvm_read_ldt();
-
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
+	svm->host.fs = hostsa->fs.selector;
+	svm->host.gs = hostsa->gs.selector;
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
@@ -1398,23 +1411,22 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int cpu = get_cpu();
+	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 	int i;
 
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
+	asm volatile(__ex("vmload")
+		     : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT));
+
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
+	}
+
+	put_cpu();
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fdff76eb6ceb..fa7d7e4f9d3d 100644
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
 
@@ -120,7 +115,6 @@ struct vcpu_svm {
 	struct {
 		u16 fs;
 		u16 gs;
-		u16 ldt;
 		u64 gs_base;
 	} host;
 
-- 
2.25.1

