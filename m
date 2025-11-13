Return-Path: <kvm+bounces-63110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EE2C5AA6B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2713F3B6290
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1537329C69;
	Thu, 13 Nov 2025 23:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cs4xnlus"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B5332E681
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077077; cv=none; b=X4TX5aTdAjyzb4A1yWuHyNI70xm6BIMGpaX29DMfD/lqWN6sRkJZRbAy7CbaoWYkSNGELQqxbcW9nnRQ+IhDg80e0I4/X/4gm4GbT08Q4WLGBRn+gM96+4wZ1+f5PQrX5RbbVnXmYb51d1Q+I+8V9A9J3mZDh/yk0xnABFPBTvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077077; c=relaxed/simple;
	bh=fW3qCCORzgxNu27cA27QxxVTE3InArhlK3jK46oMq9o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dhp5PWW/6YQao4hMHO34n+Znhnnugirb2IMKOZZ1WhdxOLZtBGeDNnMr7UHnUZeTRT21VXarKLvLxIYgRGmw/n51VOv0x3LPl0yLvtjAXVp8+tnJn1ICB69UnLMFWkG80n2IQjC0gKq4vzIpxnNjpe14zqxVWMrpgyRyqpZKLSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cs4xnlus; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5533921eb2so1207268a12.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077075; x=1763681875; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0jw2KVOdakkapVYKbvuvd68x1KugquyK3xRcPayLfkA=;
        b=Cs4xnlusvg5QypoYiOAbOkW9RDEO/5wMwUsbbWvjV+WOVfV79Laom5dY5hhlcHSVFC
         pNrm/Gb7f5iAaWWT8aVfhdGyvMez+w/x+OwDBAdB3s89MRF8zxgPSaglGSOAneAF+GbA
         Ttb36DxnUx8BhMjlb5v7H7J3bRqImzeJbTEFwhNc8ug7pS4qOjKDF87dLAnXYMOMeO/R
         vOKhDGuW2rx0TadmlmFzt/ZcME6PF+vvyZuRSWL2NPadkwglyRGZdpmIjLGllMhMg+Bd
         0YEHJpNeEkmnIa+Ok1dPSGpXguYS5ziHwGZtxG8RtI/OkArg4ZOZHwZ5le7iKNdDyQz+
         v2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077075; x=1763681875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0jw2KVOdakkapVYKbvuvd68x1KugquyK3xRcPayLfkA=;
        b=t99sUt5AdRLCuLQAz3vsh54kPATNMF2kCk0KxvPFpNG+Yzh/yg+qjoCSuuaTaz/WwB
         GgTswCfCxo9CqvEzRjnDsKjYE3M8E6kEday4Ga9pvwHxetfeOBXOmmQ46X2qV1KQLQcG
         hHVoqelhz1Yrux0A9IlbHOIqbqw81lipeSLRD8YbcJJgQHRavBhOsOSr2U8qwUfMSq7M
         +Zm03ss7ahd5JaD5FnrrRd1UcXaGe6OpuYWkEkxVR3MrhOxmMchF13AWz9mUIJnCT5ii
         L9YKT8rrpFrMZCQLJnCnyfnkxczVyTg466LqECEHQBNu0swEjl5gZKAATbX0HvvZss3Q
         xCiA==
X-Gm-Message-State: AOJu0Yy/NB8Q0EL5Z+fGhmXkuiRM6nmxOJ7J4Oq+EHYlmrwXk/WzDPtY
	7+Si/alt7B+fLNtkEB3udw33MZzPN7+qm5D07suWfuhF7+GYXRlC5nU7KAc9Qs74qT463fBqwBv
	XQaoBOA==
X-Google-Smtp-Source: AGHT+IFPQfuRNRc3ddrbv5kK3XNrpJhedl4e0uPKVuATUET7WelUE8oHyLa/YRZ77aZ7uz0c4GLtuWkKbmo=
X-Received: from pjbdb12.prod.google.com ([2002:a17:90a:d64c:b0:33b:dbe2:7682])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3bd0:b0:341:8b2b:43c
 with SMTP id 98e67ed59e1d1-343fa63784fmr1024435a91.18.1763077075560; Thu, 13
 Nov 2025 15:37:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:41 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-5-seanjc@google.com>
Subject: [PATCH v5 4/9] x86/bugs: Use an x86 feature to track the MMIO Stale
 Data mitigation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert the MMIO Stale Data mitigation tracking from a static branch into
an x86 feature flag so that it can be used via ALTERNATIVE_2 in KVM.

No functional change intended.

Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeatures.h   |  5 +++++
 arch/x86/include/asm/nospec-branch.h |  2 --
 arch/x86/kernel/cpu/bugs.c           | 11 +----------
 arch/x86/kvm/mmu/spte.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c               |  4 ++--
 5 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 7129eb44adad..646d2a77a2e2 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -501,6 +501,11 @@
 #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
 #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
 #define X86_FEATURE_X2AVIC_EXT		(21*32+17) /* AMD SVM x2AVIC support for 4k vCPUs */
+#define X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO (21*32+18) /*
+						      * Clear CPU buffers before VM-Enter if the vCPU
+						      * can access host MMIO (ignored for all intents
+						      * and purposes if CLEAR_CPU_BUF_VM is set).
+						      */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 8b4885a1b2ef..b1b1811216c5 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -580,8 +580,6 @@ DECLARE_STATIC_KEY_FALSE(cpu_buf_idle_clear);
 
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
-DECLARE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
-
 extern u16 x86_verw_sel;
 
 #include <asm/segment.h>
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c3a26532a209..70bb48ab46d7 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -192,14 +192,6 @@ EXPORT_SYMBOL_GPL(cpu_buf_idle_clear);
  */
 DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
-/*
- * Controls CPU Fill buffer clear before VMenter. This is a subset of
- * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
- * mitigation is required.
- */
-DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
-EXPORT_SYMBOL_GPL(cpu_buf_vm_clear);
-
 #undef pr_fmt
 #define pr_fmt(fmt)	"mitigations: " fmt
 
@@ -751,9 +743,8 @@ static void __init mmio_apply_mitigation(void)
 	if (verw_clear_cpu_buf_mitigation_selected) {
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
-		static_branch_disable(&cpu_buf_vm_clear);
 	} else {
-		static_branch_enable(&cpu_buf_vm_clear);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO);
 	}
 
 	/*
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 37647afde7d3..85a0473809b0 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -292,7 +292,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
 
-	if (static_branch_unlikely(&cpu_buf_vm_clear) &&
+	if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO) &&
 	    !kvm_vcpu_can_access_host_mmio(vcpu) &&
 	    kvm_is_mmio_pfn(pfn, &is_host_mmio))
 		kvm_track_host_mmio_mapping(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f374c815ce2..18d9e0eacd0f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -903,7 +903,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
 	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
 		flags |= VMX_RUN_SAVE_SPEC_CTRL;
 
-	if (static_branch_unlikely(&cpu_buf_vm_clear) &&
+	if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO) &&
 	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
 		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
 
@@ -7352,7 +7352,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (static_branch_unlikely(&cpu_buf_vm_clear) &&
+	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO) &&
 		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
 		x86_clear_cpu_buffers();
 
-- 
2.52.0.rc1.455.g30608eb744-goog


