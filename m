Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50DE224948
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 08:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgGRGjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jul 2020 02:39:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:30319 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728885AbgGRGjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jul 2020 02:39:02 -0400
IronPort-SDR: HF0OWvTOrsqwQd0hmHtbS+9Y+LJs8S6wPwfe8OSGoehm2F8v6UP2zSgWdfe3AWIx7Bgi/vPzq3
 dK18SKwfrOOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="151079557"
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="151079557"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 23:39:01 -0700
IronPort-SDR: cl9cebjvW17T7Eyzjt7GJZ4C5Wv+xEe263Z3dsxfoqDbrIwuQKqlu0lPV344dm5sC5qQ0hcMX+
 R4/zvgr8Mtpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="486690970"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 23:39:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] KVM: x86: Add macro wrapper for defining kvm_exit tracepoint
Date:   Fri, 17 Jul 2020 23:38:52 -0700
Message-Id: <20200718063854.16017-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200718063854.16017-1-sean.j.christopherson@intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Macrofy the definition of kvm_exit so that the definition can be reused
verbatim by kvm_nested_vmexit.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/trace.h | 69 +++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4192b72c72fd8..6cb75ba494fcd 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -235,42 +235,45 @@ TRACE_EVENT(kvm_apic,
 	(isa == KVM_ISA_VMX) ?						\
 	__print_flags(exit_reason & ~0xffff, " ", VMX_EXIT_REASON_FLAGS) : ""
 
+#define TRACE_EVENT_KVM_EXIT(name)					     \
+TRACE_EVENT(name,							     \
+	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu, u32 isa),  \
+	TP_ARGS(exit_reason, vcpu, isa),				     \
+									     \
+	TP_STRUCT__entry(						     \
+		__field(	unsigned int,	exit_reason	)	     \
+		__field(	unsigned long,	guest_rip	)	     \
+		__field(	u32,	        isa             )	     \
+		__field(	u64,	        info1           )	     \
+		__field(	u64,	        info2           )	     \
+		__field(	u32,	        intr_info	)	     \
+		__field(	u32,	        error_code	)	     \
+		__field(	unsigned int,	vcpu_id         )	     \
+	),								     \
+									     \
+	TP_fast_assign(							     \
+		__entry->exit_reason	= exit_reason;			     \
+		__entry->guest_rip	= kvm_rip_read(vcpu);		     \
+		__entry->isa            = isa;				     \
+		__entry->vcpu_id        = vcpu->vcpu_id;		     \
+		kvm_x86_ops.get_exit_info(vcpu, &__entry->info1,	     \
+					  &__entry->info2,		     \
+					  &__entry->intr_info,		     \
+					  &__entry->error_code);	     \
+	),								     \
+									     \
+	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "	     \
+		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x",	     \
+		  __entry->vcpu_id,					     \
+		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa), \
+		  __entry->guest_rip, __entry->info1, __entry->info2,	     \
+		  __entry->intr_info, __entry->error_code)		     \
+)
+
 /*
  * Tracepoint for kvm guest exit:
  */
-TRACE_EVENT(kvm_exit,
-	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu, u32 isa),
-	TP_ARGS(exit_reason, vcpu, isa),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	exit_reason	)
-		__field(	unsigned long,	guest_rip	)
-		__field(	u32,	        isa             )
-		__field(	u64,	        info1           )
-		__field(	u64,	        info2           )
-		__field(	u32,	        intr_info	)
-		__field(	u32,	        error_code	)
-		__field(	unsigned int,	vcpu_id         )
-	),
-
-	TP_fast_assign(
-		__entry->exit_reason	= exit_reason;
-		__entry->guest_rip	= kvm_rip_read(vcpu);
-		__entry->isa            = isa;
-		__entry->vcpu_id        = vcpu->vcpu_id;
-		kvm_x86_ops.get_exit_info(vcpu, &__entry->info1,
-					  &__entry->info2,
-					  &__entry->intr_info,
-					  &__entry->error_code);
-	),
-
-	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "
-		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x",
-		  __entry->vcpu_id,
-		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa),
-		  __entry->guest_rip, __entry->info1, __entry->info2,
-		  __entry->intr_info, __entry->error_code)
-);
+TRACE_EVENT_KVM_EXIT(kvm_exit);
 
 /*
  * Tracepoint for kvm interrupt injection:
-- 
2.26.0

