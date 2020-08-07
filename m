Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D31323E55B
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgHGArk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:47:40 -0400
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:41569
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726897AbgHGAri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:47:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdEUvzbTj26WUSMlPVWi62mcdatjtL8qeIGUW67b7B9Gk62c5sAxAKAFVSdCLY4BSy4Ii/BS4iYpjE5YrLIhtvLaTg4V91x5o0BkAzEisv12I/e5GTon69LDOdGD/HN0fAZMWqnuiNrUgnP8Syc7N7PfpQbu4aMcrD1P1gq3yK8vtSw5a76FbrlJiEDxli9TfU5XN1mrO02c+dHGeLVCttX/KPv1O3kbcA/DoAOYq4WY2VmoBMRYqzn64anrpUneuDQDZHkC59yZfaNkACrUbD4Ke8RyKpndnAw6mtExoQnIz9zyRWOnkBfVVnR4N3BJ2BhIGeLlIfBrtipQlOXfvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtVMDA17QHF58Sc1VHOQOPfkSjBakAfLYn119R2gy94=;
 b=nd/sD4jE2JkOJS0QwPZppbE37XmU8TENHxTJPVfeRNFGrQSpKFAIbw9njp8cg/5etw2xMM5hdzioz5jp8B3VzipB1wgx87fkSgF3KlpFWvx61USLOoIDvF9JMlceFyEtShM7vpZ212g4jAALvIjkI5x8Fz2heINP/5nuQRx2ajAUSP1+QGnhuaL3GLc/iLCga6HSKD79DhUdUIRUyefe7d6lUbQgs7sqL+Ll+wO0taiJYP3u/0SKNyj6QuWpLpT8tATYd5dLjT4G45HQv/pRLFzXi4fBRHMRrrdcvhQ1gj4KCn+HnjksKwHRyFvwy4zpscXeuPYCU8+sn9p4kTiAAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtVMDA17QHF58Sc1VHOQOPfkSjBakAfLYn119R2gy94=;
 b=A1qjkMfYMeJ2WJh9h6v43rmG5nRjPqE28TRq+oIzJ2YYekrP8FfJeaWVnCshUspxNDMwV3TRdOWHvUfvVkxPc84UexQghYFnz1TW/iWQ6OEQ6nkdGMGLsfoqfJydIP5CONedrRD/NuwGUXJQhGetzASpMf4v8Q4QVwfTKDWJY4g=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:47:35 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:47:35 +0000
Subject: [PATCH v4 11/12] KVM: X86: Move handling of INVPCID types to x86
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:47:34 -0500
Message-ID: <159676125434.12805.10237694695339928467.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0017.namprd02.prod.outlook.com
 (2603:10b6:803:2b::27) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0201CA0017.namprd02.prod.outlook.com (2603:10b6:803:2b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Fri, 7 Aug 2020 00:47:34 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dab1bbd3-c345-4e97-1cd4-08d83a6b79e2
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44792854FE7DC177046A07E495490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lf0SdhK1IPpR793PDLBfWN552Ff/PuDnKv53otHllYjtKxl651gQyU68sR1LYXGK9gaN3QYB1kTltl1sZyE4QrYULQ/OgZMkCsXFdIUECUUv1FpsYmlC1AS4c5GLTQ8MDHzlHKOtkTiKqPgnHPQOh9W1PQrkgmhjPV11BuBumOlnNRZiaemvjBD5m8X4WIWFfPuPZnWLttQgNxIXJ1sx+SJjQ7EtX8jgKymTSBgjBeHdPMb95G2eoBZfWeZoVjzDhgZHS0jrOTps6Pgz6kUKVYP0MzMpLi1cLYET0rSRJPnK/e9SF2sKiLXWj3AL3g7HTdZm2yEdz5qk2en7GZdd7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ryC6bF8NhTjv2eObez4g+z5nbltwLX/tT+Lxm48gt50z9ckSWR0nzjJl/L9PCynLG3k1ktyOTmM9GXKeUSUzD40M7Yco2HkOBjU20Vl0U3EDq3Moth76xmqJ+2RMCc8a9LU2wQFoGsAYw7sRqUn1AZ3rF8xS0460BcWOKIYNGI9E6sSAi40+mBIScdDykcyfJGp2Nff9YMr/IQOocSl4oDSa7D9ujwgKnQm3IEDRSqpPBbN8dCRtUmjvg8wfpNKN4JmLnPifNfhiLIxa8+Kj67tmh03clcOmu9eEheaGpp78r2hT9mnijs98lFB7M+uZvVAC+TaN7Sfk0hevnObwjqpV12BAADRa0AtC87XWTtty7xswcjY7djcPGYNcQnTSaGtGdWjJXpBif3SIqvd5pzY2X6GWRG0Rujz4ZEJNDxGugXSLbe/BJnUSp9A+2p1HC3VdV5fjUbcCu83mtIetzCwEnwoyGC5D+xsb8km+Da6n8aVaSNquffR1bu7Lh3dzLGY4QUuMD/vezUaEmkHZvxNd3fTPhuTNkNI8BTumeHGQ+N+v3NOyr7Q4f45vH//z3C/vgio26BlB0R7IgYHoKxhqPIX2+FCP8mS8lKm18wELxlvso0BAWsD3i/QANy/O0UwwXVJDdXqsdMV7Hc/AVQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab1bbd3-c345-4e97-1cd4-08d83a6b79e2
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:47:35.7636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afeCjAXn8qiiLuIFSd8vGlj+H7VS2xVUQFwfdSkhZVmBQb5qYMu5mMsecUFQjwlZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INVPCID instruction handling is mostly same across both VMX and
SVM. So, move the code to common x86.c.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c |   68 +-----------------------------------------
 arch/x86/kvm/x86.c     |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |    1 +
 3 files changed, 80 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ff7920844702..02652edce9d1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5473,16 +5473,11 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 {
 	u32 vmx_instruction_info;
 	unsigned long type;
-	bool pcid_enabled;
 	gva_t gva;
-	struct x86_exception e;
-	unsigned i;
-	unsigned long roots_to_free = 0;
 	struct {
 		u64 pcid;
 		u64 gla;
 	} operand;
-	int r;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -5505,68 +5500,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 				sizeof(operand), &gva))
 		return 1;
 
-	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
-	if (r != X86EMUL_CONTINUE)
-		return kvm_handle_memory_failure(vcpu, r, &e);
-
-	if (operand.pcid >> 12 != 0) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
-
-	switch (type) {
-	case INVPCID_TYPE_INDIV_ADDR:
-		if ((!pcid_enabled && (operand.pcid != 0)) ||
-		    is_noncanonical_address(operand.gla, vcpu)) {
-			kvm_inject_gp(vcpu, 0);
-			return 1;
-		}
-		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
-		return kvm_skip_emulated_instruction(vcpu);
-
-	case INVPCID_TYPE_SINGLE_CTXT:
-		if (!pcid_enabled && (operand.pcid != 0)) {
-			kvm_inject_gp(vcpu, 0);
-			return 1;
-		}
-
-		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
-			kvm_mmu_sync_roots(vcpu);
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-		}
-
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
-			    == operand.pcid)
-				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
-
-		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
-		/*
-		 * If neither the current cr3 nor any of the prev_roots use the
-		 * given PCID, then nothing needs to be done here because a
-		 * resync will happen anyway before switching to any other CR3.
-		 */
-
-		return kvm_skip_emulated_instruction(vcpu);
-
-	case INVPCID_TYPE_ALL_NON_GLOBAL:
-		/*
-		 * Currently, KVM doesn't mark global entries in the shadow
-		 * page tables, so a non-global flush just degenerates to a
-		 * global flush. If needed, we could optimize this later by
-		 * keeping track of global entries in shadow page tables.
-		 */
-
-		/* fall-through */
-	case INVPCID_TYPE_ALL_INCL_GLOBAL:
-		kvm_mmu_unload(vcpu);
-		return kvm_skip_emulated_instruction(vcpu);
-
-	default:
-		BUG(); /* We have already checked above that type <= 3 */
-	}
+	return kvm_handle_invpcid(vcpu, type, gva);
 }
 
 static int handle_pml_full(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5806f606dd23..8dcd68058327 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -70,6 +70,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
+#include <asm/tlbflush.h>
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
 #include <clocksource/hyperv_timer.h>
@@ -10727,6 +10728,83 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_memory_failure);
 
+int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
+{
+	bool pcid_enabled;
+	struct x86_exception e;
+	unsigned i;
+	unsigned long roots_to_free = 0;
+	struct {
+		u64 pcid;
+		u64 gla;
+	} operand;
+	int r;
+
+	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
+	if (r != X86EMUL_CONTINUE)
+		return kvm_handle_memory_failure(vcpu, r, &e);
+
+	if (operand.pcid >> 12 != 0) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
+
+	switch (type) {
+	case INVPCID_TYPE_INDIV_ADDR:
+		if ((!pcid_enabled && (operand.pcid != 0)) ||
+		    is_noncanonical_address(operand.gla, vcpu)) {
+			kvm_inject_gp(vcpu, 0);
+			return 1;
+		}
+		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
+		return kvm_skip_emulated_instruction(vcpu);
+
+	case INVPCID_TYPE_SINGLE_CTXT:
+		if (!pcid_enabled && (operand.pcid != 0)) {
+			kvm_inject_gp(vcpu, 0);
+			return 1;
+		}
+
+		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
+			kvm_mmu_sync_roots(vcpu);
+			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+		}
+
+		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
+			    == operand.pcid)
+				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+
+		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
+		/*
+		 * If neither the current cr3 nor any of the prev_roots use the
+		 * given PCID, then nothing needs to be done here because a
+		 * resync will happen anyway before switching to any other CR3.
+		 */
+
+		return kvm_skip_emulated_instruction(vcpu);
+
+	case INVPCID_TYPE_ALL_NON_GLOBAL:
+		/*
+		 * Currently, KVM doesn't mark global entries in the shadow
+		 * page tables, so a non-global flush just degenerates to a
+		 * global flush. If needed, we could optimize this later by
+		 * keeping track of global entries in shadow page tables.
+		 */
+
+		/* fall-through */
+	case INVPCID_TYPE_ALL_INCL_GLOBAL:
+		kvm_mmu_unload(vcpu);
+		return kvm_skip_emulated_instruction(vcpu);
+
+	default:
+		BUG(); /* We have already checked above that type <= 3 */
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_handle_invpcid);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8995806431d..c6b728f1fed2 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -367,5 +367,6 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
+int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
 
 #endif

