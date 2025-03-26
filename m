Return-Path: <kvm+bounces-42048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D73CCA71F40
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3D6C1898529
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2D12586FE;
	Wed, 26 Mar 2025 19:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q3a9184v"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2283F2459D5
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017813; cv=none; b=pHSU/94Bwwpu8XnSGCrgmWojM1UuOxsfG4wVFWdJr5sATZ0GFZghPdVtWafXUhf7q019lClKPiV0bSyVRdal5gPDPCLbfzRz529Z9iYMsxoLjoI8G10OiNk2RoeXHQttV7UA2IAtlCCkL/r5q+Z23HvwlSLmXhrxpyDLXTHE/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017813; c=relaxed/simple;
	bh=slWjk6xRtGd8NNju/WBuTxaV0TwQqzjL7gF/Ou93OfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSHNjADHyt+61B46eoUv1jj0JOEXLQtl8iNbat28kffb5hKcuAenc1wuhDoByQFPa9/Hp1G6KrRsod2GLelO/g3iYFQ6hjVs+vMQNsH3Nd9u47g3lJDUK/Bkgzc2BXjm4+ep9/967uepUO0sV1e1ATQ69Wcrmz3lfOEW/UJPiow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q3a9184v; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5odBDyCnSOvFrnA2jtebnIHNWBzNYLPFh+CwM5nazO8=;
	b=q3a9184voIe5GsqRhMGkZQ0UPkLdi9HGGr0JOQicgYw70KPVVx/KvcT17k4mOf20w0/EvI
	AecPV/21ppxUUvhWnb4kgfYS3k6ddxv0dydzDgz3iHc1Yu3P2KEWJy5KdhLeJC3ceW1WYi
	D7JhS2IORRRce3HpX4CtFyLpUyoQr1w=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 03/24] KVM: SVM: Add helpers to set/clear ASID flush in VMCB
Date: Wed, 26 Mar 2025 19:35:58 +0000
Message-ID: <20250326193619.3714986-4-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Incoming changes will add more code paths that set tlb_ctl to
TLB_CONTROL_FLUSH_ASID, and will eliminate the use of
TLB_CONTROL_FLUSH_ALL_ASID except as fallback when FLUSHBYASID is not
available. Introduce set/clear helpers to set tlb_ctl to
TLB_CONTROL_FLUSH_ASID or TLB_CONTROL_DO_NOTHING.

Opportunistically move the TLB_CONTROL_* definitions to
arch/x86/kvm/svm/svm.h as they are not used outside of arch/x86/kvm/svm/.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h |  5 -----
 arch/x86/kvm/svm/nested.c  |  2 +-
 arch/x86/kvm/svm/sev.c     |  2 +-
 arch/x86/kvm/svm/svm.c     |  4 ++--
 arch/x86/kvm/svm/svm.h     | 15 +++++++++++++++
 5 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9b7fa99ae9513..a97da63562eb3 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -171,11 +171,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 };
 
 
-#define TLB_CONTROL_DO_NOTHING 0
-#define TLB_CONTROL_FLUSH_ALL_ASID 1
-#define TLB_CONTROL_FLUSH_ASID 3
-#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
-
 #define V_TPR_MASK 0x0f
 
 #define V_IRQ_SHIFT 8
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 834b67672d50f..11b02a0340d9e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -681,7 +681,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	/* Done at vmrun: asid.  */
 
 	/* Also overwritten later if necessary.  */
-	vmcb02->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	vmcb_clr_flush_asid(vmcb02);
 
 	/* nested_cr3.  */
 	if (nested_npt_enabled(svm))
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee27887..d613f81addf1c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3479,7 +3479,7 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
 		return 0;
 
 	sd->sev_vmcbs[asid] = svm->vmcb;
-	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+	vmcb_set_flush_asid(svm->vmcb);
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	return 0;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 28a6d2c0f250f..0e302ae9a8435 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4006,7 +4006,7 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 	 * VM-Exit (via kvm_mmu_reset_context()).
 	 */
 	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
-		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+		vmcb_set_flush_asid(svm->vmcb);
 	else
 		svm->current_vmcb->asid_generation--;
 }
@@ -4373,7 +4373,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 		svm->nested.nested_run_pending = 0;
 	}
 
-	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	vmcb_clr_flush_asid(svm->vmcb);
 	vmcb_mark_all_clean(svm->vmcb);
 
 	/* if exit due to PF check for async PF */
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d4490eaed55dd..d2c49cbfbf1ca 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -409,6 +409,21 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
         return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
 }
 
+#define TLB_CONTROL_DO_NOTHING 0
+#define TLB_CONTROL_FLUSH_ALL_ASID 1
+#define TLB_CONTROL_FLUSH_ASID 3
+#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
+
+static inline void vmcb_set_flush_asid(struct vmcb *vmcb)
+{
+	vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+}
+
+static inline void vmcb_clr_flush_asid(struct vmcb *vmcb)
+{
+	vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+}
+
 static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
-- 
2.49.0.395.g12beb8f557-goog


