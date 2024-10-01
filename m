Return-Path: <kvm+bounces-27734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF29D98B368
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15A8A1C232D6
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F9D1BFDEB;
	Tue,  1 Oct 2024 05:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="DgH7tILr"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730D61BBBC3;
	Tue,  1 Oct 2024 05:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758940; cv=none; b=oA4GRiVf0AByRYqTNvJPTR/7wMCz4NhjGj627lbj56vQH8Hcyzaj4TX/3dnkUnvy86GA5fBbRusCafvCWS0NpR/uheMVKiFl1WlUN3MN521jFVyNOnpi3KOA3680KDaWN3z5i0BR4JPWb0dOUbwSLi0bpwwfg7YLtYaiEwA4Apo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758940; c=relaxed/simple;
	bh=FfvwUJmcqygfmVKQuKsVdG12zBfzQdS9GdIiRdLxCEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDD8vegjtB7Gw1p1AFkQn9uBxaHo/6VPjvX+mP3cuoUj8DIVomABl4om4PMnj2/AKYYt3Ocedykml0FNtvszaUx+DOX1H1GZHazRX8Hsdwj7QIfbjbdjfcrgwhSEMptILVUz7jHsvXUfKJstVtdz/ZywOkbevP9ITz2n0KIDI/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=DgH7tILr; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7e3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:30 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7e3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758891;
	bh=YujS5b0tGKkjcZEYpGNmcwRivEXkaOGjJ/hmns7x13Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgH7tILrnCwPruR0DC3hezUipz+S3fq+P6gX/RZcZYAJkYKu91PZfBYsgb1EEs/gb
	 IhUZX4zOm/qSbNMkMobzIDuej371qllk6f2XEr+qRiKc6ImntELzBykMKGNPmO8Tpo
	 LdK+yWXQ4FekEeoVRC+Vaf8ZxAeH0j+9ha8zZb850RSVVk5l+hidKFzOI1Ee+A8N19
	 04Xwe4RrDBOWtTmX+rleTIga4umn/E6ox8FhzLs8rGxCpgQCf1dqNVLHRySBqrBoSL
	 9YtX/cXzeSgRiYySKzFWZMMe6rLL91g0WNYLC6+9WHv21OXmGF6gzvaY/R4FOBkCxH
	 5ENZwgI/+0Qeg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 15/27] KVM: VMX: Virtualize FRED event_data
Date: Mon, 30 Sep 2024 22:00:58 -0700
Message-ID: <20241001050110.3643764-16-xin@zytor.com>
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

Set injected-event data when injecting a #PF, #DB, or #NM caused
by extended feature disable using FRED event delivery, and save
original-event data for being used as injected-event data.

Unlike IDT using some extra CPU register as part of an event
context, e.g., %cr2 for #PF, FRED saves a complete event context
in its stack frame, e.g., FRED saves the faulting linear address
of a #PF into the event data field defined in its stack frame.

Thus a new VMX control field called injected-event data is added
to provide the event data that will be pushed into a FRED stack
frame for VM entries that inject an event using FRED event delivery.
In addition, a new VM exit information field called original-event
data is added to store the event data that would have saved into a
FRED stack frame for VM exits that occur during FRED event delivery.
After such a VM exit is handled to allow the original-event to be
delivered, the data in the original-event data VMCS field needs to
be set into the injected-event data VMCS field for the injection of
the original event.

Signed-off-by: Xin Li <xin3.li@intel.com>
[ Sean: reworked event data injection for nested ]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---

Changes since v2:
* Rework event data injection for nested (Chao Gao & Sean Christopherson).

Changes since v1:
* Document event data should be equal to CR2/DR6/IA32_XFD_ERR instead
  of using WARN_ON() (Chao Gao).
* Zero event data if a #NM was not caused by extended feature disable
  (Chao Gao).
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/asm/vmx.h      |  4 ++++
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++++++++++----
 arch/x86/kvm/x86.c              | 16 +++++++++++++++-
 5 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 43b08d12cb32..b9b82aaea9a3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -736,6 +736,7 @@ struct kvm_queued_exception {
 	u32 error_code;
 	unsigned long payload;
 	bool has_payload;
+	u64 event_data;
 };
 
 struct kvm_vcpu_arch {
@@ -2113,7 +2114,7 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
-			   bool has_error_code, u32 error_code);
+			   bool has_error_code, u32 error_code, u64 event_data);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault);
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 5184e03945dd..3696e763c231 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -265,8 +265,12 @@ enum vmcs_field {
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	SECONDARY_VM_EXIT_CONTROLS	= 0x00002044,
 	SECONDARY_VM_EXIT_CONTROLS_HIGH	= 0x00002045,
+	INJECTED_EVENT_DATA		= 0x00002052,
+	INJECTED_EVENT_DATA_HIGH	= 0x00002053,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
+	ORIGINAL_EVENT_DATA		= 0x00002404,
+	ORIGINAL_EVENT_DATA_HIGH	= 0x00002405,
 	VMCS_LINK_POINTER               = 0x00002800,
 	VMCS_LINK_POINTER_HIGH          = 0x00002801,
 	GUEST_IA32_DEBUGCTL             = 0x00002802,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9e2568bcd54..7fa8f842f116 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4126,7 +4126,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 
 		kvm_requeue_exception(vcpu, vector,
 				      exitintinfo & SVM_EXITINTINFO_VALID_ERR,
-				      error_code);
+				      error_code, 0);
 		break;
 	}
 	case SVM_EXITINTINFO_TYPE_INTR:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 686006fe6d45..d81144bd648f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1915,6 +1915,9 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
+	if (is_fred_enabled(vcpu))
+		vmcs_write64(INJECTED_EVENT_DATA, ex->event_data);
+
 	vmx_clear_hlt(vcpu);
 }
 
@@ -7241,7 +7244,8 @@ static void vmx_recover_nmi_blocking(struct vcpu_vmx *vmx)
 static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 				      u32 idt_vectoring_info,
 				      int instr_len_field,
-				      int error_code_field)
+				      int error_code_field,
+				      int event_data_field)
 {
 	u8 vector;
 	int type;
@@ -7276,13 +7280,17 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 		fallthrough;
 	case INTR_TYPE_HARD_EXCEPTION: {
 		u32 error_code = 0;
+		u64 event_data = 0;
 
 		if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK)
 			error_code = vmcs_read32(error_code_field);
+		if (is_fred_enabled(vcpu))
+			event_data = vmcs_read64(event_data_field);
 
 		kvm_requeue_exception(vcpu, vector,
 				      idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK,
-				      error_code);
+				      error_code,
+				      event_data);
 		break;
 	}
 	case INTR_TYPE_SOFT_INTR:
@@ -7300,7 +7308,8 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 {
 	__vmx_complete_interrupts(&vmx->vcpu, vmx->idt_vectoring_info,
 				  VM_EXIT_INSTRUCTION_LEN,
-				  IDT_VECTORING_ERROR_CODE);
+				  IDT_VECTORING_ERROR_CODE,
+				  ORIGINAL_EVENT_DATA);
 }
 
 void vmx_cancel_injection(struct kvm_vcpu *vcpu)
@@ -7308,7 +7317,8 @@ void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 	__vmx_complete_interrupts(vcpu,
 				  vmcs_read32(VM_ENTRY_INTR_INFO_FIELD),
 				  VM_ENTRY_INSTRUCTION_LEN,
-				  VM_ENTRY_EXCEPTION_ERROR_CODE);
+				  VM_ENTRY_EXCEPTION_ERROR_CODE,
+				  INJECTED_EVENT_DATA);
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
 }
@@ -7439,6 +7449,10 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vmx_disable_fb_clear(vmx);
 
+	/*
+	 * Note, even though FRED delivers the faulting linear address via the
+	 * event data field on the stack, CR2 is still updated.
+	 */
 	if (vcpu->arch.cr2 != native_read_cr2())
 		native_write_cr2(vcpu->arch.cr2);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b31ebafbe0bc..7a55c1eb5297 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -810,9 +810,22 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
 		 * breakpoint), it is reserved and must be zero in DR6.
 		 */
 		vcpu->arch.dr6 &= ~BIT(12);
+
+		/*
+		 * FRED #DB event data matches DR6, but follows the polarity of
+		 * VMX's pending debug exceptions, not DR6.
+		 */
+		ex->event_data = ex->payload & ~BIT(12);
+		break;
+	case NM_VECTOR:
+		ex->event_data = ex->payload;
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = ex->payload;
+		ex->event_data = ex->payload;
+		break;
+	default:
+		ex->event_data = 0;
 		break;
 	}
 
@@ -920,7 +933,7 @@ static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 }
 
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
-			   bool has_error_code, u32 error_code)
+			   bool has_error_code, u32 error_code, u64 event_data)
 {
 
 	/*
@@ -945,6 +958,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 	vcpu->arch.exception.error_code = error_code;
 	vcpu->arch.exception.has_payload = false;
 	vcpu->arch.exception.payload = 0;
+	vcpu->arch.exception.event_data = event_data;
 }
 EXPORT_SYMBOL_GPL(kvm_requeue_exception);
 
-- 
2.46.2


