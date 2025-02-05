Return-Path: <kvm+bounces-37380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A852A298E3
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:25:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 998553A1DC3
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E5C1FF1B9;
	Wed,  5 Feb 2025 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b+UQ3vNG"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F221FF1C4
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779872; cv=none; b=Vm7HLHrbbEEwrMD5OGpLbVaKN57rrEGt16rvtom2STV4iywhIuDcEsQy8ZziE0o4gdd0Yfqjc0tY4sFobRRDlAJhOnyPSlY3BCUldmCv0mHjczLOkRUuKvtoB5V1FI6VM4SEWQ1Wtxr4gTu7HHQ5f4BnklOFSQKNOTRSQheERIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779872; c=relaxed/simple;
	bh=3FhFsdcBPRFfzAegygTDKvXo3Zl/PnarMy0+zg+4/oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwrnWkkx1wfEdsuEvtEdUC3SmrSJtrR/5Ca/IezzKaV9leMOUdomXm41BJXAB2jm3OMDN37HoAgiheeZ3rD2WjSve7DjwJaOtP1XdibjqoOQ5VZBh148jK1IXrh1hfGquE4t1BgkvkurvtlfLv8msF3L9KGSpPw8IzaMChYW+Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b+UQ3vNG; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wU7GujvGutRhBR40lU9N1rdEDOfXC2UW00gPytDGFSk=;
	b=b+UQ3vNGNV4dldBEeKe49bFGKNESkCSTJwHcgIGGMBVfokJ/GXjeAGUb+3t4UdiN1JYDf5
	k8og9YxmKQvU1g3WLfTEpVVvDPdPDG42l9ymxiNu8Q7oUpEDb2WZ/TKgMcLNNg7pcn5IFC
	zd07cpg+2DSn7+qhaS13N5moCKIWoVE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 04/13] KVM: SVM: Introduce helpers for updating TLB_CONTROL
Date: Wed,  5 Feb 2025 18:23:53 +0000
Message-ID: <20250205182402.2147495-5-yosry.ahmed@linux.dev>
In-Reply-To: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Introduce helpers for updating TLB_CONTROL in the VMCB instead of
directly setting it. Two helpers are introduced:

- svm_add_tlb_ctl_flush(): Combines a new TLB_CONTROL value with the
  existing one.

- svm_clear_tlb_ctl_flush(): Clears the TLB_CONTROL field.

The goal is to prevent overwriting a TLB_CONTROL value with something
that results in less TLB entries being flushed. This does not currently
happen as KVM only sets TLB_CONTROL_FLUSH_ASID when servicing a flush
request, and TLB_CONTROL_FLUSH_ALL_ASID when allocating a new ASID. The
latter always happens after the former so no unsafe overwrite happens.

However, future changes may result in subtle bugs where the TLB_CONTROL
field is incorrectly overwritten. The new helpers prevent that.

A separate helper is used for clearing the TLB flush because it is
semantically different. In this case, KVM knowingly ignores the existing
value of TLB_CONTROL. Also, although svm_add_tlb_ctl_flush() would just
work for TLB_CONTROL_DO_NOTHING, the logic becomes inconsistent (use the
biggest hammer unless no hammer at all is requested).

Opportunistically move the TLB_CONTROL_* definitions to
arch/x86/kvm/svm/svm.h as they are not used outside of
arch/x86/kvm/svm/.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h |  6 ------
 arch/x86/kvm/svm/nested.c  |  2 +-
 arch/x86/kvm/svm/sev.c     |  2 +-
 arch/x86/kvm/svm/svm.c     |  6 +++---
 arch/x86/kvm/svm/svm.h     | 29 +++++++++++++++++++++++++++++
 5 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 2b59b9951c90e..e6bccf8f90982 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -169,12 +169,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	};
 };
 
-
-#define TLB_CONTROL_DO_NOTHING 0
-#define TLB_CONTROL_FLUSH_ALL_ASID 1
-#define TLB_CONTROL_FLUSH_ASID 3
-#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
-
 #define V_TPR_MASK 0x0f
 
 #define V_IRQ_SHIFT 8
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2eba36af44f22..0e9b0592c1f83 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -690,7 +690,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	/* Done at vmrun: asid.  */
 
 	/* Also overwritten later if necessary.  */
-	vmcb02->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	svm_clear_tlb_ctl_flush(vmcb02);
 
 	/* nested_cr3.  */
 	if (nested_npt_enabled(svm))
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b0adfd0537d00..3af296d6c04f6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3481,7 +3481,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 		return;
 
 	sd->sev_vmcbs[asid] = svm->vmcb;
-	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+	svm_add_tlb_ctl_flush(svm->vmcb, TLB_CONTROL_FLUSH_ASID);
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2108b48ba4959..a2d601cd4c283 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1985,7 +1985,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	if (sd->next_asid > sd->max_asid) {
 		++sd->asid_generation;
 		sd->next_asid = sd->min_asid;
-		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+		svm_add_tlb_ctl_flush(svm->vmcb, TLB_CONTROL_FLUSH_ALL_ASID);
 		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	}
 
@@ -3974,7 +3974,7 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu, struct kvm_vmcb_info *vmcb
 	 * VM-Exit (via kvm_mmu_reset_context()).
 	 */
 	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
-		vmcb->ptr->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+		svm_add_tlb_ctl_flush(vmcb->ptr, TLB_CONTROL_FLUSH_ASID);
 	else
 		vmcb->asid_generation--;
 }
@@ -4317,7 +4317,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 		svm->nested.nested_run_pending = 0;
 	}
 
-	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	svm_clear_tlb_ctl_flush(svm->vmcb);
 	vmcb_mark_all_clean(svm->vmcb);
 
 	/* if exit due to PF check for async PF */
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebbb0b1a64676..6a73d6ed1e428 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -611,6 +611,35 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
 
+#define TLB_CONTROL_DO_NOTHING 0
+#define TLB_CONTROL_FLUSH_ALL_ASID 1
+#define TLB_CONTROL_FLUSH_ASID 3
+#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
+
+/*
+ * Clearing TLB flushes is done separately because combining
+ * TLB_CONTROL_DO_NOTHING with others is counter-intuitive.
+ */
+static inline void svm_add_tlb_ctl_flush(struct vmcb *vmcb, u8 tlb_ctl)
+{
+	if (WARN_ON_ONCE(tlb_ctl == TLB_CONTROL_DO_NOTHING))
+		return;
+
+	/*
+	 * Apply the least targeted (most inclusive) TLB flush. Apart from
+	 * TLB_CONTROL_DO_NOTHING, lower values of tlb_ctl are less targeted.
+	 */
+	if (vmcb->control.tlb_ctl == TLB_CONTROL_DO_NOTHING)
+		vmcb->control.tlb_ctl = tlb_ctl;
+	else
+		vmcb->control.tlb_ctl = min(vmcb->control.tlb_ctl, tlb_ctl);
+}
+
+static inline void svm_clear_tlb_ctl_flush(struct vmcb *vmcb)
+{
+	vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+}
+
 /* nested.c */
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
-- 
2.48.1.362.g079036d154-goog


