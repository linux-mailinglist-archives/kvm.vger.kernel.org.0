Return-Path: <kvm+bounces-61114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E780EC0B284
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:24:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CB7404EEA77
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D7030216B;
	Sun, 26 Oct 2025 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="jjP8OIVV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578402FE057;
	Sun, 26 Oct 2025 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510032; cv=none; b=GPTY7fBC/Ryt8pprr4fG5N+aikHUshpFfkF7zaiYrkTTySqUPzXjd4bCsK8qkuZcwtihEk+HfPNJHpsqht5xWgxs1y6ZF7vy5yIGAzmnuGMawVPXizl6grhTMAIpeFJGyUKTCy1IPUYat6OFR7ORu8EIf04Qpaquj8KdVzaDkTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510032; c=relaxed/simple;
	bh=3ZquoYd4PeKOgWq252oOkNSSDvucKgnx9bhjQipjkr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnBOYxjAKvFIY28dwo+tfaDe+SADHKtcsebOjyRngeRQqdudsrTiD0EohnPk970fPgR8IygBabwGG7v+RFoHaxZUDd8ib1aa2/c4Y8iJlHUY41jYChUNWgyu//yUvsefN1p5ybXvKQOgU8K3jNwbWYrUkbGEXCSlOiR9REAzH68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=jjP8OIVV; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkU505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:31 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkU505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509972;
	bh=rf67q93Z/nfbltLuwOLlN+rMH87eaxj42oNr2vXPkGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjP8OIVVIfhvZ1mVbthuIK+08jWeHXHxQEm1FTYxQVUJg2mU5KblgD2ItSaOuMu12
	 dhsq9XDJ5xP+GY/7wP4y5tNaKDea5h3RVYSyeqgGha5Kvrqjya1hjW8uHdh5uYMUxp
	 YpPir32o8lEc2H4L/SfTh/ruIn32DA2HMgdUC/uTs8iGYemBf3NeUJASx0DbumIYl4
	 f8P3Id1nOg5rPC3UjpBcsRoaFdD1lDi6yGoTXe39Xodzz2IrRLZXXVjlCxfWkv203M
	 2AytA+5Dcfp6KUHRn4NyZIkHaRs3AZqZ6RRQoaYur2Gp77Q7uQd2vR+6az+9Lt1Ena
	 RQefktrlfW0og==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 13/22] KVM: VMX: Virtualize FRED nested exception tracking
Date: Sun, 26 Oct 2025 13:19:01 -0700
Message-ID: <20251026201911.505204-14-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
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
index 550a8716a227..3b6dadf368eb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -760,6 +760,7 @@ struct kvm_queued_exception {
 	u32 error_code;
 	unsigned long payload;
 	bool has_payload;
+	bool nested;
 	u64 event_data;
 };
 
@@ -2231,7 +2232,8 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
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
index 2f20c68fcfb3..e3702ca2f633 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4104,7 +4104,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 
 		kvm_requeue_exception(vcpu, vector,
 				      exitintinfo & SVM_EXITINTINFO_VALID_ERR,
-				      error_code, 0);
+				      error_code, false, 0);
 		break;
 	}
 	case SVM_EXITINTINFO_TYPE_INTR:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0b5d04c863a8..34e057f65513 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1855,8 +1855,11 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
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
 
@@ -7348,6 +7351,7 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 		kvm_requeue_exception(vcpu, vector,
 				      idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK,
 				      error_code,
+				      idt_vectoring_info & VECTORING_INFO_NESTED_EXCEPTION_MASK,
 				      event_data);
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 10f1663d51d7..554442c07f27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -879,6 +879,10 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 		vcpu->arch.exception.pending = true;
 		vcpu->arch.exception.injected = false;
 
+		vcpu->arch.exception.nested = vcpu->arch.exception.nested ||
+					      vcpu->arch.nmi_injected ||
+					      vcpu->arch.interrupt.injected;
+
 		vcpu->arch.exception.has_error_code = has_error;
 		vcpu->arch.exception.vector = nr;
 		vcpu->arch.exception.error_code = error_code;
@@ -908,8 +912,13 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
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
@@ -938,7 +947,8 @@ static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 }
 
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
-			   bool has_error_code, u32 error_code, u64 event_data)
+			   bool has_error_code, u32 error_code, bool nested,
+			   u64 event_data)
 {
 
 	/*
@@ -963,6 +973,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 	vcpu->arch.exception.error_code = error_code;
 	vcpu->arch.exception.has_payload = false;
 	vcpu->arch.exception.payload = 0;
+	vcpu->arch.exception.nested = nested;
 	vcpu->arch.exception.event_data = event_data;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_requeue_exception);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 0c1fbf75442b..4f5d12d7136e 100644
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


