Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3AD1CBB75
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 01:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgEHXxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 19:53:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:30638 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbgEHXxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 19:53:50 -0400
IronPort-SDR: eb4dPC6Lob1KkcQu5GBySjLtqolArbKuw7M8wiAJrwa6sTzBScs6wJ0R1IKyhTQgPeMkfXIgdt
 VL8ZoZtQrH5A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 16:53:50 -0700
IronPort-SDR: qIUwwQfgerFjgt33YyyA1GCH11D9cCL5riMGpgpEbqcjc+xADTgbk9TSQjuJOeuqRRhwBx35RH
 SG0RzKFbmwzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="264546906"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 08 May 2020 16:53:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Print symbolic names of VMX VM-Exit flags in traces
Date:   Fri,  8 May 2020 16:53:48 -0700
Message-Id: <20200508235348.19427-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200508235348.19427-1-sean.j.christopherson@intel.com>
References: <20200508235348.19427-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use __print_flags() to display the names of VMX flags in VM-Exit traces
and strip the flags when printing the basic exit reason, e.g. so that a
failed VM-Entry due to invalid guest state gets recorded as
"INVALID_STATE FAILED_VMENTRY" instead of "0x80000021".

Opportunstically fix misaligned variables in the kvm_exit and
kvm_nested_vmexit_inject tracepoints.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/vmx.h |  3 +++
 arch/x86/kvm/trace.h            | 32 +++++++++++++++++---------------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index e95b72ec19bc0..b8ff9e8ac0d51 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -150,6 +150,9 @@
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }
 
+#define VMX_EXIT_REASON_FLAGS \
+	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
+
 #define VMX_ABORT_SAVE_GUEST_MSR_FAIL        1
 #define VMX_ABORT_LOAD_HOST_PDPTE_FAIL       2
 #define VMX_ABORT_LOAD_HOST_MSR_FAIL         4
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 249062f24b940..54a10c98d7466 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -225,6 +225,14 @@ TRACE_EVENT(kvm_apic,
 #define KVM_ISA_VMX   1
 #define KVM_ISA_SVM   2
 
+#define kvm_print_exit_reason(exit_reason, isa)				\
+	(isa == KVM_ISA_VMX) ?						\
+	__print_symbolic(exit_reason & 0xffff, VMX_EXIT_REASONS) :	\
+	__print_symbolic(exit_reason, SVM_EXIT_REASONS),		\
+	(isa == KVM_ISA_VMX && exit_reason & ~0xffff) ? " " : "",	\
+	(isa == KVM_ISA_VMX) ?						\
+	__print_flags(exit_reason & ~0xffff, " ", VMX_EXIT_REASON_FLAGS) : ""
+
 /*
  * Tracepoint for kvm guest exit:
  */
@@ -250,12 +258,10 @@ TRACE_EVENT(kvm_exit,
 					   &__entry->info2);
 	),
 
-	TP_printk("vcpu %u reason %s rip 0x%lx info %llx %llx",
+	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info %llx %llx",
 		  __entry->vcpu_id,
-		 (__entry->isa == KVM_ISA_VMX) ?
-		 __print_symbolic(__entry->exit_reason, VMX_EXIT_REASONS) :
-		 __print_symbolic(__entry->exit_reason, SVM_EXIT_REASONS),
-		 __entry->guest_rip, __entry->info1, __entry->info2)
+		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa),
+		  __entry->guest_rip, __entry->info1, __entry->info2)
 );
 
 /*
@@ -588,12 +594,10 @@ TRACE_EVENT(kvm_nested_vmexit,
 		__entry->exit_int_info_err	= exit_int_info_err;
 		__entry->isa			= isa;
 	),
-	TP_printk("rip: 0x%016llx reason: %s ext_inf1: 0x%016llx "
+	TP_printk("rip: 0x%016llx reason: %s%s%s ext_inf1: 0x%016llx "
 		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x",
 		  __entry->rip,
-		 (__entry->isa == KVM_ISA_VMX) ?
-		 __print_symbolic(__entry->exit_code, VMX_EXIT_REASONS) :
-		 __print_symbolic(__entry->exit_code, SVM_EXIT_REASONS),
+		  kvm_print_exit_reason(__entry->exit_code, __entry->isa),
 		  __entry->exit_info1, __entry->exit_info2,
 		  __entry->exit_int_info, __entry->exit_int_info_err)
 );
@@ -626,13 +630,11 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
 		__entry->isa			= isa;
 	),
 
-	TP_printk("reason: %s ext_inf1: 0x%016llx "
+	TP_printk("reason: %s%s%s ext_inf1: 0x%016llx "
 		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x",
-		 (__entry->isa == KVM_ISA_VMX) ?
-		 __print_symbolic(__entry->exit_code, VMX_EXIT_REASONS) :
-		 __print_symbolic(__entry->exit_code, SVM_EXIT_REASONS),
-		__entry->exit_info1, __entry->exit_info2,
-		__entry->exit_int_info, __entry->exit_int_info_err)
+		  kvm_print_exit_reason(__entry->exit_code, __entry->isa),
+		  __entry->exit_info1, __entry->exit_info2,
+		  __entry->exit_int_info, __entry->exit_int_info_err)
 );
 
 /*
-- 
2.26.0

