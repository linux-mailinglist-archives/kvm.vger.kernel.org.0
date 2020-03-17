Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859A6188E61
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 20:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgCQTx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 15:53:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:43598 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgCQTx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 15:53:56 -0400
IronPort-SDR: YAMXTaUQvhbfi9/EglHLIBThxC7TJN/SYy/Z1tvvfsLa3onwntOUlu4LFI0+jUaK0JwFKSVcaR
 iyTND9zr+BRg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 12:53:55 -0700
IronPort-SDR: 6bQH3deRFaoj7AMo2kEC84Wui6P91HGfgh+8j69z3O5xM+wIxLPd9Kp/jkmPr7vwKmp+RTVxnR
 WLm903I6jmQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="233604300"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2020 12:53:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 1/2] KVM: x86: Add requested index to the CPUID tracepoint
Date:   Tue, 17 Mar 2020 12:53:53 -0700
Message-Id: <20200317195354.28384-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317195354.28384-1-sean.j.christopherson@intel.com>
References: <20200317195354.28384-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Output the requested index when tracing CPUID emulation; it's basically
mandatory for leafs where the index is meaningful, and is helpful for
verifying KVM correctness even when the index isn't meaningful, e.g. the
trace for a Linux guest's hypervisor_cpuid_base() probing appears to
be broken (returns all zeroes) at first glance, but is correct because
the index is non-zero, i.e. the output values correspond to a random
index in the maximum basic leaf.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c |  2 +-
 arch/x86/kvm/trace.h | 13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 08280d8a2ac9..bccaae0df668 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1026,7 +1026,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			}
 		}
 	}
-	trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *edx, exact);
+	trace_kvm_cpuid(orig_function, index, *eax, *ebx, *ecx, *edx, exact);
 	return exact;
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6c4d9b4caf07..27270ba0f05f 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -151,12 +151,14 @@ TRACE_EVENT(kvm_fast_mmio,
  * Tracepoint for cpuid.
  */
 TRACE_EVENT(kvm_cpuid,
-	TP_PROTO(unsigned int function, unsigned long rax, unsigned long rbx,
-		 unsigned long rcx, unsigned long rdx, bool found),
-	TP_ARGS(function, rax, rbx, rcx, rdx, found),
+	TP_PROTO(unsigned int function, unsigned int index, unsigned long rax,
+		 unsigned long rbx, unsigned long rcx, unsigned long rdx,
+		 bool found),
+	TP_ARGS(function, index, rax, rbx, rcx, rdx, found),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	function	)
+		__field(	unsigned int,	index		)
 		__field(	unsigned long,	rax		)
 		__field(	unsigned long,	rbx		)
 		__field(	unsigned long,	rcx		)
@@ -166,6 +168,7 @@ TRACE_EVENT(kvm_cpuid,
 
 	TP_fast_assign(
 		__entry->function	= function;
+		__entry->index		= index;
 		__entry->rax		= rax;
 		__entry->rbx		= rbx;
 		__entry->rcx		= rcx;
@@ -173,8 +176,8 @@ TRACE_EVENT(kvm_cpuid,
 		__entry->found		= found;
 	),
 
-	TP_printk("func %x rax %lx rbx %lx rcx %lx rdx %lx, cpuid entry %s",
-		  __entry->function, __entry->rax,
+	TP_printk("func %x idx %x rax %lx rbx %lx rcx %lx rdx %lx, cpuid entry %s",
+		  __entry->function, __entry->index, __entry->rax,
 		  __entry->rbx, __entry->rcx, __entry->rdx,
 		  __entry->found ? "found" : "not found")
 );
-- 
2.24.1

