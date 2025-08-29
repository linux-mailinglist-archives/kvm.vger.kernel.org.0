Return-Path: <kvm+bounces-56345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6017B3BF71
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A71B8A0796E
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE19233A024;
	Fri, 29 Aug 2025 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JynVGdVW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000ED322766;
	Fri, 29 Aug 2025 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481592; cv=none; b=ZpHutz+xdPHnGwdxK5UQHlvVmXC+8O+FbZIvtf7Hj76nvczx3qFduhJuS1TKuTXtZBdErP1JoCZ95f1Oh3Q9o2pD+LSCFIatYuHIDxTojHOluRr2hyRAhMCrPOnV6uBp5MMlK+QojwM5l00v3s2VrQrC/Yf7KO0XkPlBTywKU2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481592; c=relaxed/simple;
	bh=TLgbBxiKolxuXOrjRLi0rkoZU9vP1gi3n6LpK9m1o/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc009gu37Jitok5UGdjsWowQRImqY237kegqF/uRTbfWOjSbMNl1AsBoLbtUxAyPDzw0TIuoGTRVRfivExidl0sevqiFpyG9Vc3KESPH6YzoOTAM/1ykqrU9lw0ZddUWFozwIa03f96wV6EeXJr/vnsSIKujhzprwodnPTn8aE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JynVGdVW; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo4H2871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:22 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo4H2871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481542;
	bh=BBKTXTsrn2Zw8Dcn2Z3/WpVvozoH+mmJCd/M7GhuKco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JynVGdVWwpU+LxqO1Q6rtxg8YUh1ZNf1mJUMEYAZLP31wfjEe93yKXR5PGfVMyUim
	 rXYqdJLMYinVyhHh8xDiDb9bLFppZgsnRCjw1HE4+q8PkCtYIGGvtpa+3NjULgOuUJ
	 MdRfsulqOELpM8gHe9cMksAWiFijHFRo21GATyI4m3u0kbTUm4wio70TvOU+VA/YEa
	 la5RU89IijuloZQPA4zoKBAjX9Hh1p1elNRSiqeV+jS8lJySJOPS9w4P9XiHaO0qhe
	 mzpg8Hvyo9nz3Vly0vXzf+nrJPQ9GILmbE5UbraQyWDmQ/hzdng26eCOg6pvnmrj75
	 v9h4oNBUeZnfw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 11/21] KVM: VMX: Virtualize FRED event_data
Date: Fri, 29 Aug 2025 08:31:39 -0700
Message-ID: <20250829153149.2871901-12-xin@zytor.com>
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
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.

Change in v3:
* Rework event data injection for nested (Chao Gao & Sean Christopherson).

Changes in v2:
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
index bec644eec92f..5c48acc98939 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -759,6 +759,7 @@ struct kvm_queued_exception {
 	u32 error_code;
 	unsigned long payload;
 	bool has_payload;
+	u64 event_data;
 };
 
 /*
@@ -2227,7 +2228,7 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
-			   bool has_error_code, u32 error_code);
+			   bool has_error_code, u32 error_code, u64 event_data);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault);
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 6f8b8947c60c..539af190ad3e 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -269,8 +269,12 @@ enum vmcs_field {
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
index e4af4907c7d8..9feca6b90380 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4127,7 +4127,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 
 		kvm_requeue_exception(vcpu, vector,
 				      exitintinfo & SVM_EXITINTINFO_VALID_ERR,
-				      error_code);
+				      error_code, 0);
 		break;
 	}
 	case SVM_EXITINTINFO_TYPE_INTR:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 358410220cc2..1abfba2139a5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1861,6 +1861,9 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
+	if (is_fred_enabled(vcpu))
+		vmcs_write64(INJECTED_EVENT_DATA, ex->event_data);
+
 	vmx_clear_hlt(vcpu);
 }
 
@@ -7269,7 +7272,8 @@ static void vmx_recover_nmi_blocking(struct vcpu_vmx *vmx)
 static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 				      u32 idt_vectoring_info,
 				      int instr_len_field,
-				      int error_code_field)
+				      int error_code_field,
+				      int event_data_field)
 {
 	u8 vector;
 	int type;
@@ -7304,13 +7308,17 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
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
@@ -7328,7 +7336,8 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 {
 	__vmx_complete_interrupts(&vmx->vcpu, vmx->idt_vectoring_info,
 				  VM_EXIT_INSTRUCTION_LEN,
-				  IDT_VECTORING_ERROR_CODE);
+				  IDT_VECTORING_ERROR_CODE,
+				  ORIGINAL_EVENT_DATA);
 }
 
 void vmx_cancel_injection(struct kvm_vcpu *vcpu)
@@ -7336,7 +7345,8 @@ void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 	__vmx_complete_interrupts(vcpu,
 				  vmcs_read32(VM_ENTRY_INTR_INFO_FIELD),
 				  VM_ENTRY_INSTRUCTION_LEN,
-				  VM_ENTRY_EXCEPTION_ERROR_CODE);
+				  VM_ENTRY_EXCEPTION_ERROR_CODE,
+				  INJECTED_EVENT_DATA);
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
 }
@@ -7490,6 +7500,10 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vmx_disable_fb_clear(vmx);
 
+	/*
+	 * Note, even though FRED delivers the faulting linear address via the
+	 * event data field on the stack, CR2 is still updated.
+	 */
 	if (vcpu->arch.cr2 != native_read_cr2())
 		native_write_cr2(vcpu->arch.cr2);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c53fc235b8bd..dbcf00c55012 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -807,9 +807,22 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
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
 
@@ -917,7 +930,7 @@ static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 }
 
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
-			   bool has_error_code, u32 error_code)
+			   bool has_error_code, u32 error_code, u64 event_data)
 {
 
 	/*
@@ -942,6 +955,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 	vcpu->arch.exception.error_code = error_code;
 	vcpu->arch.exception.has_payload = false;
 	vcpu->arch.exception.payload = 0;
+	vcpu->arch.exception.event_data = event_data;
 }
 EXPORT_SYMBOL_GPL(kvm_requeue_exception);
 
-- 
2.51.0


