Return-Path: <kvm+bounces-56342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA244B3BF6B
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:36:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCD463ADC22
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB193375CC;
	Fri, 29 Aug 2025 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="eHdt0Hiz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE70314B82;
	Fri, 29 Aug 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481592; cv=none; b=YB7XkrIymDl+ennhzUZYhCT/i4zp2/BmBODhePYduktqfewm0j37xZwf6ZQifcJxvWjc9E/YWauWr0lrd9ZDC5C5mMrKCaHitN+4FQakSxLoRijOMifFSeDxVrNL0pzJ6rSEw5TSCJTlicoFfXquCU03tKa9xbHU8Kw3zr0yOb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481592; c=relaxed/simple;
	bh=hKIBVl3UsTHWBwPBbxISchvDVw51wNLqpk5vwLBJI/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slptBuFHjy712JvCWy3Y0EVAklpPuNtyh4RWYaN3HocUL9uA4DZrLa+wKuzXaxkbKjMvvCp430BBZaUE8EGMLE33FQ1NwmvR4cVEDIe6iKrUr+4dKwIO8S+UhP6/uM3NGRBt9Pi7HBAm4hwosnR4tZ5DTOdA71GgSlDQlqgjZJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=eHdt0Hiz; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo4I2871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:23 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo4I2871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481543;
	bh=dLc18oJcaFgQ7It5XQKc+8vj0uGdMz5U25Cz2rPw3zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHdt0HizRWsXjXz6Z89KyOucuw+Ud15wOK0+hkRLmutMOl/9xSnnV5/TUIs0w9rqj
	 eBtZNlDGY733ttYzjM73VELDeOCQkg2G+KMcxz4txC8QKZ53eP8BhiCdKb5vZTcc6H
	 QIicjDq00C/BFayhWM2HT8k2dk3lo3xHzbnQpyQJODXR2G812BfbZ+j+ltaCdLq6wE
	 0k5F14bGyEFupzXZKvIVmG1ezJpPRNvipXii+Ew5EjXorkO+v0dOeo72suBxz+JvB9
	 GGI6AkEUb2TLXLHZbfYrkdw87msIYbpc+T90+LEzMmkcOgm/1ICmuS2kKp1l6If/Fn
	 ZCo/pOGy9NLdA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 12/21] KVM: VMX: Virtualize FRED nested exception tracking
Date: Fri, 29 Aug 2025 08:31:40 -0700
Message-ID: <20250829153149.2871901-13-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829153149.2871901-1-xin@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Set the VMX nested exception bit in VM-entry interruption information
field when injecting a nested exception using FRED event delivery to
ensure:
  1) A nested exception is injected on a correct stack level.
  2) The nested bit defined in FRED stack frame is set.

The event stack level used by FRED event delivery depends on whether
the event was a nested exception encountered during delivery of an
earlier event, because a nested exception is "regarded" as happening
on ring 0.  E.g., when #PF is configured to use stack level 1 in
IA32_FRED_STKLVLS MSR:
  - nested #PF will be delivered on the stack pointed by IA32_FRED_RSP1
    MSR when encountered in ring 3 and ring 0.
  - normal #PF will be delivered on the stack pointed by IA32_FRED_RSP0
    MSR when encountered in ring 3.

The VMX nested-exception support ensures a correct event stack level is
chosen when a VM entry injects a nested exception.

Signed-off-by: Xin Li <xin3.li@intel.com>
[ Sean: reworked kvm_requeue_exception() to simply the code changes ]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.

Change in v4:
* Move the check is_fred_enable() from kvm_multiple_exception() to
  vmx_inject_exception() thus avoid bleeding FRED details into
  kvm_multiple_exception() (Chao Gao).

Change in v3:
* Rework kvm_requeue_exception() to simply the code changes (Sean
  Christopherson).

Change in v2:
* Set the nested flag when there is an original interrupt (Chao Gao).
---
 arch/x86/include/asm/kvm_host.h |  4 +++-
 arch/x86/include/asm/vmx.h      |  5 ++++-
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  6 +++++-
 arch/x86/kvm/x86.c              | 13 ++++++++++++-
 arch/x86/kvm/x86.h              |  1 +
 6 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5c48acc98939..b5a1fef8d637 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -759,6 +759,7 @@ struct kvm_queued_exception {
 	u32 error_code;
 	unsigned long payload;
 	bool has_payload;
+	bool nested;
 	u64 event_data;
 };
 
@@ -2228,7 +2229,8 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
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
index 539af190ad3e..7b34a9357b28 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -140,6 +140,7 @@
 #define VMX_BASIC_INOUT				BIT_ULL(54)
 #define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
 #define VMX_BASIC_NO_HW_ERROR_CODE_CC		BIT_ULL(56)
+#define VMX_BASIC_NESTED_EXCEPTION		BIT_ULL(58)
 
 static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
 {
@@ -442,13 +443,15 @@ enum vmcs_field {
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
index 9feca6b90380..c4402e50c828 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4127,7 +4127,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 
 		kvm_requeue_exception(vcpu, vector,
 				      exitintinfo & SVM_EXITINTINFO_VALID_ERR,
-				      error_code, 0);
+				      error_code, false, 0);
 		break;
 	}
 	case SVM_EXITINTINFO_TYPE_INTR:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1abfba2139a5..3d968584d854 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1856,8 +1856,11 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
 			     vmx->vcpu.arch.event_exit_inst_len);
 		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
-	} else
+	} else {
 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
+		if (ex->nested && is_fred_enabled(vcpu))
+			intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;
+	}
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
@@ -7318,6 +7321,7 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 		kvm_requeue_exception(vcpu, vector,
 				      idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK,
 				      error_code,
+				      idt_vectoring_info & VECTORING_INFO_NESTED_EXCEPTION_MASK,
 				      event_data);
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dbcf00c55012..7598b8d72b07 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -871,6 +871,10 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 		vcpu->arch.exception.pending = true;
 		vcpu->arch.exception.injected = false;
 
+		vcpu->arch.exception.nested = vcpu->arch.exception.nested ||
+					      vcpu->arch.nmi_injected ||
+					      vcpu->arch.interrupt.injected;
+
 		vcpu->arch.exception.has_error_code = has_error;
 		vcpu->arch.exception.vector = nr;
 		vcpu->arch.exception.error_code = error_code;
@@ -900,8 +904,13 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 		vcpu->arch.exception.injected = false;
 		vcpu->arch.exception.pending = false;
 
+		/* #DF is NOT a nested event, per its definition. */
+		vcpu->arch.exception.nested = false;
+
 		kvm_queue_exception_e(vcpu, DF_VECTOR, 0);
 	} else {
+		vcpu->arch.exception.nested = true;
+
 		/* replace previous exception with a new one in a hope
 		   that instruction re-execution will regenerate lost
 		   exception */
@@ -930,7 +939,8 @@ static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 }
 
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
-			   bool has_error_code, u32 error_code, u64 event_data)
+			   bool has_error_code, u32 error_code, bool nested,
+			   u64 event_data)
 {
 
 	/*
@@ -955,6 +965,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 	vcpu->arch.exception.error_code = error_code;
 	vcpu->arch.exception.has_payload = false;
 	vcpu->arch.exception.payload = 0;
+	vcpu->arch.exception.nested = nested;
 	vcpu->arch.exception.event_data = event_data;
 }
 EXPORT_SYMBOL_GPL(kvm_requeue_exception);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b6dc23c478ff..685eb710b1f2 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -198,6 +198,7 @@ static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exception.pending = false;
 	vcpu->arch.exception.injected = false;
+	vcpu->arch.exception.nested = false;
 	vcpu->arch.exception_vmexit.pending = false;
 }
 
-- 
2.51.0


