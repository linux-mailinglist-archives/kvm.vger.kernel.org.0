Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB27269667
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgINUZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:25:03 -0400
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:17441
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgINUWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:22:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LliNsVkhlht62f3r5iQQwIPGUMCHwmWkiUcibI0Rzq+5DFqchTyhzNzHj+cv6OrG+D8jybaU+IYMWVC1nt11aZX36p55q/t5KKKpb2Yd2T0LyhW4Z+xaFHPr9/FedvosnwrAzvAzqhEiBrbi5gUJIqLZLPd/aOi2s1xq77/RoBzzSu5UYTDhPukdUYWLYTGSY6gg4al+aiD2S7dcb2AzwxWEbPO8OI1LObBcL9gvIJg2cqfJpUyY+TZUIhGkXTZbSabEbKZlVuntmYE1vL+JmHe1Sw62w+zmWCllq/clEkNE8EmqniwV422Vnl8phzaqf0jBICV+Ax+LErOCwtvBjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHwKzkkLI71whcgMnO6Iti9vVTTwAMGjwi/au0xd3VU=;
 b=CIUYOnViygEVAi5sulPQ9fjE5cmwN3BBkXyw0TRwAIwt9zinIehL7+QonVq1UupnVOLrErGSpTEOR6HPSo2Aw7wV/EGLQC0JC4Q1GJ13fyA+q/l8ipytCOWaipOk7iHIh+iWCbKAV8pcm668DvXiX0hEZ1YLoiTOf5HL+nAPtmOSir3kV/zcBlZNqLSWqVfwZU0V0KlQIHAHue3nQH/dAfsDvERuVLe702GzeJOI5XdYk/GKqW7eLqHGtn01DSpjirymAwj4z0txIZ5U4MFC9ifHrEv6XEtAsxPKxdFNsFoMbqvTtQ1ynJQRaCFvAWnI7Whxsy++HeLawoQ4qMj+lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHwKzkkLI71whcgMnO6Iti9vVTTwAMGjwi/au0xd3VU=;
 b=fh2JCuMfD1onzrBV1bvYwZgpAPRFsEXMmI0PhhkaNwBShzFsWAGGJqhPqNtNk8TOmUcD8tPNVQyt0OuDEwfjqEm6eI+2xdokmPCz18UnKo25CJ3v8JRbeQ/RcZuTM5yJLMNDbWVPO2dMDU0lEPVBqh84pFqsuu52WNDZfZg4j+w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:20:24 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:20:24 +0000
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
Subject: [RFC PATCH 33/35] KVM: SVM: Provide support for SEV-ES vCPU loading
Date:   Mon, 14 Sep 2020 15:15:47 -0500
Message-Id: <3da36e824a62f2874b21dea496d50892611a8bdd.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR2201CA0003.namprd22.prod.outlook.com
 (2603:10b6:4:14::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR2201CA0003.namprd22.prod.outlook.com (2603:10b6:4:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:20:23 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9c62c72-3411-46ac-7c33-08d858eb9caa
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB298887C9F74BE83D0930AF37EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c76Vra5ilml4C00LvXus/S2hv99um++G3DqVRnIxsg24w5dkSyEuAbWbsOo/FGf+eA2VKQvtjoJnOo0e/GNSVD6TcdTphMYL1PsHb3kMq/C3LzhfxVsU7OEDZngvHmcV8H53sSZf0zfMuNnXv3NtZa5bOAT9+UrQdC2+2S7PVxSo9lInBY7XwrOWpFhj+mfmrwo0IB63OBGS4a6zNCRnFDoiFF6+11JNw5zdEXS5MDch0pztQngTkCV9IjS46c5Ypi2MB3wYnFVQdZKK1kgWoSe0sI4WaFH9jSTHIoVnp0Ne3IestoL/4Y8iKM1x9Fi7SnwBT38npqZ/UGLqKx7e4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4Lvtx4XocySH+z8FSJ0aYBz+VpDl3rJBAwqkZhNJNd71np8lOk7p108Y4HJAbBwhVyn0KktNr1vSuv/rT9Xp+uBse73C1cwMdcd++DyEocUFId/MZ/6yaa8JSdejktmb3U1A/35n3otsFr6/h/LWJI8D9oQynhCp1Vam+eTLaMZpQm7Y5+Pb/8OSWfFXKxJPIgibZU+TlpB44oBZbJgswTAoAKQPrYDjGCVukPsWRweZzGFGlvs0BSOpHWeJHOOUvBHxeOhs/yYLdjz8bVEZJH3NpPJRVlVxT+o/qHqMG9AXJDa3iT8zKflY6C1WFe6zPYNCXd5fxAJsT45cvf1hwvNu7e3N2inLFHq7FQL5kf3nfe+G+VCQ/lriy6D215khzE1lKlnZVdWbZsAzhrt1G+Homf0Wz7xo7sy/8PKzOxRpBEd7Fp5aQc3rZCuf7nTzQzTR/NmfDfisg1QGkMn2vD1WJpbiaSVQq7VJVeP441opmOEqg1HqKvGSiTVI+07f+b4RFQJDBVw6N/+EbQi1y/2WIcNmi/0DhDskcxXD7iiM9N1LI3lSviohO2ypIS/D73f+Im1sbrSOhHyLKaH4VRLdsHXbEKwG7aXmFS67v/e70wHXb+d1GdMkY2AVnucoxh+hDzqq89WLQKsXTv7Q9g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c62c72-3411-46ac-7c33-08d858eb9caa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:20:24.4301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySIMt4kmeOVJS30EJBv03D5iqXY8cWZfI+K17CVw8iyVpvzstyOJn3o5L8k+dgG0T8mdC0NTsA9r4vIoVLKJWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
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
    save the current value of XCR0 to the per-CPU SVM save area as these
    registers will be restored on VMEXIT.

General vCPU put changes:
  - Do not attempt to restore registers that SEV-ES hardware has already
    restored on VMEXIT.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c | 36 +++++++++++++++++++------------
 arch/x86/kvm/svm/svm.h | 22 +++++++++++++------
 3 files changed, 87 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7ed88f2e8d93..50018436863b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,11 +17,14 @@
 #include <linux/trace_events.h>
 
 #include <asm/trapnr.h>
+#include <asm/fpu/internal.h>
 
 #include "x86.h"
 #include "svm.h"
 #include "trace.h"
 
+#define __ex(x) __kvm_handle_fault_on_reboot(x)
+
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1599,3 +1602,48 @@ void sev_es_create_vcpu(struct vcpu_svm *svm)
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
+	 * saved via the vmsave above.
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
index cb9b1d281adb..efefe8ba9759 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1340,15 +1340,20 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
@@ -1376,19 +1381,24 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
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
index 465e14a7146f..0812d70085d7 100644
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
 
 #define MSRPM_OFFSETS	16
@@ -573,6 +581,8 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
+void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
+void sev_es_vcpu_put(struct vcpu_svm *svm);
 
 /* VMSA Accessor functions */
 
-- 
2.28.0

