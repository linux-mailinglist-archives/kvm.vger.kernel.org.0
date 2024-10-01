Return-Path: <kvm+bounces-27724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 572E798B355
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1347B2841ED
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8466F1BDAA3;
	Tue,  1 Oct 2024 05:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="dBgJ/U8q"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8316C1925B6;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758938; cv=none; b=KsTuucEGPwmTLxygKJKXUyS8iMMdqOmr/evpGhGqi/Dq8XAh82gcumT5owPTHT7ezYGbdNeo3L1zL/tZGXXDgYiTIxVmg69TqHuv/pE7rxglMTQAena5yV5CqaEvJaOMe9o6p+RcSHKABoQN+MmHwDkfKFCNttwjEczQEEjBtEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758938; c=relaxed/simple;
	bh=mCkohbTcQM3OhnebCYH4eSDKx8rcuiPi7jM7ZLpzKgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0jZH1yF/9xm7T3ZnZe3a1RWTY/KOl0N+wzvCtcKwqXhDfG+73v9vMEXPuNlj8AnIyprEsWFwC0lknA+kRwWsgDdW8TOtqGrmHMpRQkDePRe/sohGLqUiwGXhxbXgbIlo+5a6N3WDR1KOk0qcCGlvKlNHX5Di12tLxcMjSXOvQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=dBgJ/U8q; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7f3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:31 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7f3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758892;
	bh=9kW2gZpTOB82/3a1Ui+rKwBVrrwaTpl5XFZLMCcWnSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBgJ/U8q1CgC7kCrLZ5Pikz2FJ43vOI6RQxOxDgejzgAB4+eMtroKDWvRFGDICYRk
	 X5NhMTpxznv0CG+vYxx/kVN6oDfAPNv+jjNNFuUBk6en81M5q3YeGbPse4zkOKd34j
	 3fe1tVQQSDy8xFm4RG0lV6B6UuxVd4D5uauZUyGNVKVRhKGVuhZ9EZyT9I04JpQZAq
	 xrugSLt2JXNNeBhV4+4sU2lxZZv7MoVEIxMw/kjkCjmJVyyQMtMQMzvZNch4IGwosz
	 wrAw5h5AQfovt1gQdq1FtzHY5g0zLOw6cIPfwPHm/wL5pQybWXlzy8ZNHiJHoAo38p
	 bdmkClw1YRTRw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 16/27] KVM: VMX: Virtualize FRED nested exception tracking
Date: Mon, 30 Sep 2024 22:00:59 -0700
Message-ID: <20241001050110.3643764-17-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Set VMX nested exception bit in the VM-entry interruption information
VMCS field when injecting a nested exception using FRED event delivery
to ensure:
  1) The nested exception is injected on a correct stack level.
  2) The nested bit defined in FRED stack frame is set.

The event stack level used by FRED event delivery depends on whether the
event was a nested exception encountered during delivery of another event,
because a nested exception is "regarded" as happening on ring 0.  E.g.,
when #PF is configured to use stack level 1 in IA32_FRED_STKLVLS MSR:
  - nested #PF will be delivered on stack level 1 when encountered in
    ring 3.
  - normal #PF will be delivered on stack level 0 when encountered in
    ring 3.

The VMX nested-exception support ensures the correct event stack level is
chosen when a VM entry injects a nested exception.

Signed-off-by: Xin Li <xin3.li@intel.com>
[ Sean: reworked kvm_requeue_exception() to simply the code changes ]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---

Change since v2:
* Rework kvm_requeue_exception() to simply the code changes (Sean
  Christopherson).

Change since v1:
* Set the nested flag when there is an original interrupt (Chao Gao).
---
 arch/x86/include/asm/kvm_host.h |  4 +++-
 arch/x86/include/asm/vmx.h      |  5 ++++-
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  6 +++++-
 arch/x86/kvm/x86.c              | 14 +++++++++++++-
 arch/x86/kvm/x86.h              |  1 +
 6 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b9b82aaea9a3..3830084b569b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -736,6 +736,7 @@ struct kvm_queued_exception {
 	u32 error_code;
 	unsigned long payload;
 	bool has_payload;
+	bool nested;
 	u64 event_data;
 };
 
@@ -2114,7 +2115,8 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
-			   bool has_error_code, u32 error_code, u64 event_data);
+			   bool has_error_code, u32 error_code, bool nested,
+			   u64 event_data);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault);
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 3696e763c231..06c52fee5dcd 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -137,6 +137,7 @@
 #define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
 #define VMX_BASIC_INOUT				BIT_ULL(54)
 #define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
+#define VMX_BASIC_NESTED_EXCEPTION		BIT_ULL(58)
 
 static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
 {
@@ -416,13 +417,15 @@ enum vmcs_field {
 #define INTR_INFO_INTR_TYPE_MASK        0x700           /* 10:8 */
 #define INTR_INFO_DELIVER_CODE_MASK     0x800           /* 11 */
 #define INTR_INFO_UNBLOCK_NMI		0x1000		/* 12 */
+#define INTR_INFO_NESTED_EXCEPTION_MASK	0x2000		/* 13 */
 #define INTR_INFO_VALID_MASK            0x80000000      /* 31 */
-#define INTR_INFO_RESVD_BITS_MASK       0x7ffff000
+#define INTR_INFO_RESVD_BITS_MASK       0x7fffd000
 
 #define VECTORING_INFO_VECTOR_MASK           	INTR_INFO_VECTOR_MASK
 #define VECTORING_INFO_TYPE_MASK        	INTR_INFO_INTR_TYPE_MASK
 #define VECTORING_INFO_DELIVER_CODE_MASK    	INTR_INFO_DELIVER_CODE_MASK
 #define VECTORING_INFO_VALID_MASK       	INTR_INFO_VALID_MASK
+#define VECTORING_INFO_NESTED_EXCEPTION_MASK	INTR_INFO_NESTED_EXCEPTION_MASK
 
 #define INTR_TYPE_EXT_INTR		(EVENT_TYPE_EXTINT << 8)	/* external interrupt */
 #define INTR_TYPE_RESERVED		(EVENT_TYPE_RESERVED << 8)	/* reserved */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7fa8f842f116..e479e0208efe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4126,7 +4126,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 
 		kvm_requeue_exception(vcpu, vector,
 				      exitintinfo & SVM_EXITINTINFO_VALID_ERR,
-				      error_code, 0);
+				      error_code, false, 0);
 		break;
 	}
 	case SVM_EXITINTINFO_TYPE_INTR:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d81144bd648f..03f42b218554 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1910,8 +1910,11 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
 			     vmx->vcpu.arch.event_exit_inst_len);
 		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
-	} else
+	} else {
 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
+		if (ex->nested)
+			intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;
+	}
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
@@ -7290,6 +7293,7 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 		kvm_requeue_exception(vcpu, vector,
 				      idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK,
 				      error_code,
+				      idt_vectoring_info & VECTORING_INFO_NESTED_EXCEPTION_MASK,
 				      event_data);
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a55c1eb5297..8546629166e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -874,6 +874,11 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 		vcpu->arch.exception.pending = true;
 		vcpu->arch.exception.injected = false;
 
+		vcpu->arch.exception.nested = vcpu->arch.exception.nested ||
+					      (is_fred_enabled(vcpu) &&
+					       (vcpu->arch.nmi_injected ||
+					        vcpu->arch.interrupt.injected));
+
 		vcpu->arch.exception.has_error_code = has_error;
 		vcpu->arch.exception.vector = nr;
 		vcpu->arch.exception.error_code = error_code;
@@ -903,8 +908,13 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 		vcpu->arch.exception.injected = false;
 		vcpu->arch.exception.pending = false;
 
+		/* #DF is NOT a nested event, per its definition. */
+		vcpu->arch.exception.nested = false;
+
 		kvm_queue_exception_e(vcpu, DF_VECTOR, 0);
 	} else {
+		vcpu->arch.exception.nested = is_fred_enabled(vcpu);
+
 		/* replace previous exception with a new one in a hope
 		   that instruction re-execution will regenerate lost
 		   exception */
@@ -933,7 +943,8 @@ static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 }
 
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
-			   bool has_error_code, u32 error_code, u64 event_data)
+			   bool has_error_code, u32 error_code, bool nested,
+			   u64 event_data)
 {
 
 	/*
@@ -958,6 +969,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 	vcpu->arch.exception.error_code = error_code;
 	vcpu->arch.exception.has_payload = false;
 	vcpu->arch.exception.payload = 0;
+	vcpu->arch.exception.nested = nested;
 	vcpu->arch.exception.event_data = event_data;
 }
 EXPORT_SYMBOL_GPL(kvm_requeue_exception);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 578fea05ff18..992e73ee2ec5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -134,6 +134,7 @@ static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exception.pending = false;
 	vcpu->arch.exception.injected = false;
+	vcpu->arch.exception.nested = false;
 	vcpu->arch.exception_vmexit.pending = false;
 }
 
-- 
2.46.2


