Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE2516373A
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgBRXak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:30:40 -0500
Received: from mga04.intel.com ([192.55.52.120]:38638 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbgBRX35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:29:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:29:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282936663"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 15:29:56 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/13] KVM: x86: Refactor emulate tracepoint to explicitly take context
Date:   Tue, 18 Feb 2020 15:29:46 -0800
Message-Id: <20200218232953.5724-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218232953.5724-1-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly pass the emulation context to the emulate tracepoint in
preparation of dynamically allocation the emulation context.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/trace.h | 22 +++++++++++-----------
 arch/x86/kvm/x86.c   | 13 ++++++++-----
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index f194dd058470..5605000ca5f6 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -731,8 +731,9 @@ TRACE_EVENT(kvm_skinit,
 	})
 
 TRACE_EVENT(kvm_emulate_insn,
-	TP_PROTO(struct kvm_vcpu *vcpu, __u8 failed),
-	TP_ARGS(vcpu, failed),
+	TP_PROTO(struct kvm_vcpu *vcpu, struct x86_emulate_ctxt *ctxt,
+		 __u8 failed),
+	TP_ARGS(vcpu, ctxt, failed),
 
 	TP_STRUCT__entry(
 		__field(    __u64, rip                       )
@@ -745,13 +746,10 @@ TRACE_EVENT(kvm_emulate_insn,
 
 	TP_fast_assign(
 		__entry->csbase = kvm_x86_ops->get_segment_base(vcpu, VCPU_SREG_CS);
-		__entry->len = vcpu->arch.emulate_ctxt.fetch.ptr
-			       - vcpu->arch.emulate_ctxt.fetch.data;
-		__entry->rip = vcpu->arch.emulate_ctxt._eip - __entry->len;
-		memcpy(__entry->insn,
-		       vcpu->arch.emulate_ctxt.fetch.data,
-		       15);
-		__entry->flags = kei_decode_mode(vcpu->arch.emulate_ctxt.mode);
+		__entry->len = ctxt->fetch.ptr - ctxt->fetch.data;
+		__entry->rip = ctxt->_eip - __entry->len;
+		memcpy(__entry->insn, ctxt->fetch.data, 15);
+		__entry->flags = kei_decode_mode(ctxt->mode);
 		__entry->failed = failed;
 		),
 
@@ -764,8 +762,10 @@ TRACE_EVENT(kvm_emulate_insn,
 		)
 	);
 
-#define trace_kvm_emulate_insn_start(vcpu) trace_kvm_emulate_insn(vcpu, 0)
-#define trace_kvm_emulate_insn_failed(vcpu) trace_kvm_emulate_insn(vcpu, 1)
+#define trace_kvm_emulate_insn_start(vcpu, ctxt)	\
+	trace_kvm_emulate_insn(vcpu, ctxt, 0)
+#define trace_kvm_emulate_insn_failed(vcpu, ctxt)	\
+	trace_kvm_emulate_insn(vcpu, ctxt, 1)
 
 TRACE_EVENT(
 	vcpu_match_mmio,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 79d1113ad6e7..69d3dd64d90c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6460,10 +6460,13 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
-static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
+static int handle_emulation_failure(struct x86_emulate_ctxt *ctxt,
+				    int emulation_type)
 {
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
 	++vcpu->stat.insn_emulation_fail;
-	trace_kvm_emulate_insn_failed(vcpu);
+	trace_kvm_emulate_insn_failed(vcpu, ctxt);
 
 	if (emulation_type & EMULTYPE_VMWARE_GP) {
 		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
@@ -6788,7 +6791,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 		r = x86_decode_insn(ctxt, insn, insn_len);
 
-		trace_kvm_emulate_insn_start(vcpu);
+		trace_kvm_emulate_insn_start(vcpu, ctxt);
 		++vcpu->stat.insn_emulation;
 		if (r != EMULATION_OK)  {
 			if ((emulation_type & EMULTYPE_TRAP_UD) ||
@@ -6810,7 +6813,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				inject_emulated_exception(ctxt);
 				return 1;
 			}
-			return handle_emulation_failure(vcpu, emulation_type);
+			return handle_emulation_failure(ctxt, emulation_type);
 		}
 	}
 
@@ -6856,7 +6859,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					emulation_type))
 			return 1;
 
-		return handle_emulation_failure(vcpu, emulation_type);
+		return handle_emulation_failure(ctxt, emulation_type);
 	}
 
 	if (ctxt->have_exception) {
-- 
2.24.1

