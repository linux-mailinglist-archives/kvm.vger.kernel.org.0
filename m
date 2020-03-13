Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC438183858
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCLSPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:15:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:29400 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgCLSPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:15:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="442148589"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 12 Mar 2020 11:15:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Print symbolic names of VMX VM-Exit flags in traces
Date:   Thu, 12 Mar 2020 11:15:35 -0700
Message-Id: <20200312181535.23797-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/vmx.h |  3 +++
 arch/x86/kvm/trace.h            | 32 +++++++++++++++++---------------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index e95b72ec19bc..b8ff9e8ac0d5 100644
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
index f5b8814d9f83..3cfc8d97b158 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -219,6 +219,14 @@ TRACE_EVENT(kvm_apic,
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
@@ -244,12 +252,10 @@ TRACE_EVENT(kvm_exit,
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
@@ -582,12 +588,10 @@ TRACE_EVENT(kvm_nested_vmexit,
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
@@ -620,13 +624,11 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
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
2.24.1

