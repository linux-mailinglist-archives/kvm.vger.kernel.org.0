Return-Path: <kvm+bounces-53305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB0CB0F9E8
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8790C1CC4195
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F6D2E4990;
	Wed, 23 Jul 2025 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="uAQwAjz+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D59824678A;
	Wed, 23 Jul 2025 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293286; cv=none; b=LKVv3yaPcmy5uqvBJoyhZkyn9OoT8q8IEroUtSi8YewrDwsM/RGjnFxrP0o59G99NJ7fFjHort42JRBGCVtO8KZIxXoLk/OkG+wCtt0X00qrGdJIkkIcnnNgMRpgICCq9m5GWPrvSG8wuDcZ9KF9DImTXDXGSe0WUoDhhbsYWCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293286; c=relaxed/simple;
	bh=uMyIVw+5368zTKeJRFejCWyZyyjVWbPoVGfe3KqQ1a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MV2SYivi65h5kUaegLymoHSAn+QnKgvztQ0xDkBdVHF6YpkHvUqvSKmqPoaXfrks3k708ePK8zL1+ScNhCg+gggk+iUrHCIbj4u3bD48QRjVCrrYi+8Kuju80It2peL4XzorZRNBuLuGQYoQXjrY7v+eFh7ED3Lv58UlsXmO3s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=uAQwAjz+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrf031284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:57 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrf031284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293238;
	bh=SMEiDwsRemHvExam1VO7iukkYCbw+RANEnDjg4dYLI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAQwAjz+wge4/BWnySbeKxZgmkGxYhO4snB+sTNyW4qteobWTvuI9/o2rSGNq85kU
	 X+apihuLJmJHVukwXaLP9a2z/wuhQoiVvzj8MqiBdywSLgm9I2Ltz06QqX+dG8xFUi
	 q+oFCh0ztdmXFqiMUdefNZRZ9MOKen+bRdgw7NGRHRiGrUbWNTdAgdk5aSNsnOMlpH
	 oS/wdTw2PbWkStyDp/txiVTmeCznrPBtdZGopBBuxhnAU4Rk4J/mlo4jha5MF3MlOz
	 yHMM9VOEIo47HoCfH/w6Dp9JIrzF/PYBQwV42PGdJfz0hEVHeCpKqaEe8XiSTMcAF1
	 gIPBQ0Gs4/uyA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 13/23] KVM: VMX: Virtualize FRED nested exception tracking
Date: Wed, 23 Jul 2025 10:53:31 -0700
Message-ID: <20250723175341.1284463-14-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
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
index 0509b015513c..04fa24ed1594 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -756,6 +756,7 @@ struct kvm_queued_exception {
 	u32 error_code;
 	unsigned long payload;
 	bool has_payload;
+	bool nested;
 	u64 event_data;
 };
 
@@ -2201,7 +2202,8 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
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
index cf697b7c5d34..15e04a486dd8 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -137,6 +137,7 @@
 #define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
 #define VMX_BASIC_INOUT				BIT_ULL(54)
 #define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
+#define VMX_BASIC_NESTED_EXCEPTION		BIT_ULL(58)
 
 static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
 {
@@ -433,13 +434,15 @@ enum vmcs_field {
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
index 932a6525c014..4490be40a7ee 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4144,7 +4144,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 
 		kvm_requeue_exception(vcpu, vector,
 				      exitintinfo & SVM_EXITINTINFO_VALID_ERR,
-				      error_code, 0);
+				      error_code, false, 0);
 		break;
 	}
 	case SVM_EXITINTINFO_TYPE_INTR:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 15fb205f2e73..0ca01980295e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1857,8 +1857,11 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
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
 
@@ -7215,6 +7218,7 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 		kvm_requeue_exception(vcpu, vector,
 				      idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK,
 				      error_code,
+				      idt_vectoring_info & VECTORING_INFO_NESTED_EXCEPTION_MASK,
 				      event_data);
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ba907d8071b..1632ece82a85 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -860,6 +860,10 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 		vcpu->arch.exception.pending = true;
 		vcpu->arch.exception.injected = false;
 
+		vcpu->arch.exception.nested = vcpu->arch.exception.nested ||
+					      vcpu->arch.nmi_injected ||
+					      vcpu->arch.interrupt.injected;
+
 		vcpu->arch.exception.has_error_code = has_error;
 		vcpu->arch.exception.vector = nr;
 		vcpu->arch.exception.error_code = error_code;
@@ -889,8 +893,13 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
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
@@ -919,7 +928,8 @@ static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 }
 
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
-			   bool has_error_code, u32 error_code, u64 event_data)
+			   bool has_error_code, u32 error_code, bool nested,
+			   u64 event_data)
 {
 
 	/*
@@ -944,6 +954,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 	vcpu->arch.exception.error_code = error_code;
 	vcpu->arch.exception.has_payload = false;
 	vcpu->arch.exception.payload = 0;
+	vcpu->arch.exception.nested = nested;
 	vcpu->arch.exception.event_data = event_data;
 }
 EXPORT_SYMBOL_GPL(kvm_requeue_exception);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b0017a0f75fa..a573f6079ba7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -187,6 +187,7 @@ static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exception.pending = false;
 	vcpu->arch.exception.injected = false;
+	vcpu->arch.exception.nested = false;
 	vcpu->arch.exception_vmexit.pending = false;
 }
 
-- 
2.50.1


