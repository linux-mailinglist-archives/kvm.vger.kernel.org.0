Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC72C2818CD
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388494AbgJBRHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:07:35 -0400
Received: from mail-eopbgr770072.outbound.protection.outlook.com ([40.107.77.72]:35265
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388277AbgJBRHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:07:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFCwpVCd6R9r17UjWdNE4Bvel6DkVt2wDo1ECwYEFU8KMYyOAZvBTLr9dAQMkA5HlKiPD9LWQ9gfB8sOC4K0zlp3RgzNuChUd0Mt/e1F0oWW4wIBR1aFkQ5WBDUZ2OotTSJj2WnDsi82mt1k1NIqFlNdODLEzSiRXGNnHxdalbyXo3p9L0nZz0VOPrtVsUo6K4X0+3G3ahlNEmoYuoAvdnoU5+Ae4OJw1Le5TBOK6ly+a/nTrqrGWQ9ze4fVljEsiEjE0w66AwyLvvxXCAKR0hSQjU4hKlnyKOTFdtWDAdyM00fSHwLiFk4P9HuF1q5OqDlf84pDp+q5G7MzE7le0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dABaMcKRCnZEvlbMwuGeuE20M1aidc1a6LkpHRPrBO8=;
 b=hTu17fBnwXxbmd2TUZCzcRACtM/uLzFll7XCxJh+QQowTcHiKM6Iv+FLto55c2W47jwxwo9wx/JADGC2H18+hrvXHX1GPUicpzxEOyWuFC63/l7Vx6CaSplxwNrloQ9mIqCbqPf3JqbcaAl4WTILpZc2IIqMh7uBLH0enQTj2JezEBVCdnlrDFQY834xjmZsUlZjT2Il9GEu+yARisbUoHznFaMWy+R7N/5ilvkY8SYkRzMhPs89AkTTL+0qXjYGJ0Ms7Q7wFitgwFGbNxCLDgMcsDfT8QlBbqg1NBZGrKeOYMSMhW6h2pCmJFZfoO2ZlxucwlWrxzBGjlukcJ6dvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dABaMcKRCnZEvlbMwuGeuE20M1aidc1a6LkpHRPrBO8=;
 b=uOpSf5cDrEpJC73Tv8kC0Ael1+GfaYxC80P2AzIBbxl0xppVQXWqqOKLgfEREiG4fyjBlTjNOXtC67BFS6OEbZ0ZmpD7NJ8/ZA5BeskGbwLEkdoCbndbu1L3e5hdRoBRiBKlYTkAMd7hVeGXEEOy6bkAyF1aFgiIdToy136xNpc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:07:30 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:07:30 +0000
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
Subject: [RFC PATCH v2 31/33] KVM: SVM: Provide support for SEV-ES vCPU loading
Date:   Fri,  2 Oct 2020 12:02:55 -0500
Message-Id: <b266260f86706330348696283487db482b4dd508.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:5:bc::15) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR13CA0002.namprd13.prod.outlook.com (2603:10b6:5:bc::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.13 via Frontend Transport; Fri, 2 Oct 2020 17:07:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 280c6c05-87ad-43a7-c9e1-08d866f5a5b1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB421882B9A79174786846804EEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IZJr1cx/IbOYuGwges0JStsqORHj2iS477LiK3HRwq5xneBUIrE30VQYTvdsef7zcwrdDpuNWlndcDPiSUJgrxgzDdnvBDZpRg5+gulZIZ57lGuL/SfP/4xlq4e2/0mAuA/MlqyYcNpT/Gn0TNcjM42asIRARky4uXZk353MQUWLpqA+to5H34mu9r1Ck8DnSdWCAaZBScOHZ4duF36i4me5pUdByMkQMpMCF6rQv1h9bJAaAxov07em2Lc/yxiQZnQ4Aud3gPwiXA8u8yg+OvxINbs2TcOirzMyL1HomDXD0p7i680WFTqyTJgayQHH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TGgkzB5fCZ7WNOQu3cdVxDNRJhRujXfchpC9D7xL9usKXPIPJXASsul5BzpvAt7XvZWZ4o7RILFCHP9ChJL8U/JyUmQlKjBD5cvqiZxn3MWFYJyXh/lOPmPVtebFIt6JQ+JkICwhqf4/pMFgzwts/VctXarufUHo3Ir1ug97W3azsSHxKR36nP1pNGPRFhBJYT2KjGN4AdpTGlttbffolOCOiuiyM6wtIP6Gdvl8+GpvR3xbjWMFUXBd9IvevMEFNvZg7SaVX16F/I11av/T1bNBc44fa5dY1qK1HXW5xMVKaEUUdHilCbAXZAtr855EAQ7jop1KvfiIGkkMDvy4X4IIF7tavKeTSeuC/H/o4/PFsTN4MPKldkN8OVQJdps2XRO2oUqe+rVtjMBUusFvPTp09Qo//O4w1ubq+h1J9nfs5NTjP+IT3Z3iaS+3QP4NAF7ARaHgO6BbvDCcVNFS7t3cGbkH5WYI8tw71058O++S9CofmyJ6s86K0f3LI0arysTqA++pPq7IrPWxUz3vnjOe72kwGJ9yGjybQph37nTGtrvBvpvUVfaVZ/i6acKQupQgu5iT7XB7WC/c4oPEY78t7/5mLjCrijPyR9JgiNz0lkvH7WVTMotTuUtSeln5/YujYp1t774YzLUgVS/dCg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 280c6c05-87ad-43a7-c9e1-08d866f5a5b1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:07:30.8097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/3lsIlna3Wz8DOUX4UzE+GXIkxNhrY4QFecrS/D9J4K19HH+8V/+torXYBUTJrVNtrA0E6S0zH6We87NoygEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

An SEV-ES vCPU requires additional VMCB vCPU load/put requirements. SEV-ES
hardware will restore certain registers on VMEXIT, but not save them on
VMRUM (see Table B-3 and Table B-4 of the AMD64 APM Volume 2), so make the
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
index 1798a2eefcdd..6be4f0cbf09d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,12 +17,15 @@
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
@@ -1805,3 +1808,54 @@ void sev_es_create_vcpu(struct vcpu_svm *svm)
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
index b3e2c993bc4c..35d6f27ef288 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1435,15 +1435,20 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
@@ -1471,19 +1476,24 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
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
index 80c2515e75a8..acbff817559b 100644
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
@@ -573,5 +581,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
+void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
+void sev_es_vcpu_put(struct vcpu_svm *svm);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c211376a1329..9decf963bb59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -197,7 +197,8 @@ EXPORT_SYMBOL_GPL(host_efer);
 bool __read_mostly allow_smaller_maxphyaddr;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
-static u64 __read_mostly host_xss;
+u64 __read_mostly host_xss;
+EXPORT_SYMBOL_GPL(host_xss);
 u64 __read_mostly supported_xss;
 EXPORT_SYMBOL_GPL(supported_xss);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7edcb068fb69..55897fa62c1e 100644
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

