Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D8C17646F
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 20:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgCBT5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 14:57:51 -0500
Received: from mga05.intel.com ([192.55.52.43]:30422 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgCBT5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 14:57:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 11:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="438404992"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 02 Mar 2020 11:57:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 6/6] KVM: x86: Add requested index to the CPUID tracepoint
Date:   Mon,  2 Mar 2020 11:57:36 -0800
Message-Id: <20200302195736.24777-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302195736.24777-1-sean.j.christopherson@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
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
the index is non-zero, i.e. the output values correspond to random index
in the maximum basic leaf.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c |  3 ++-
 arch/x86/kvm/trace.h | 13 ++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b0a4f3c17932..a3c9f6bf43f3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1047,7 +1047,8 @@ void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			}
 		}
 	}
-	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, exact_entry_exists);
+	trace_kvm_cpuid(function, index, *eax, *ebx, *ecx, *edx,
+			exact_entry_exists);
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index f194dd058470..aa372d0119f0 100644
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

