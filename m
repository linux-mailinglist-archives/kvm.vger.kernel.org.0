Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66272188E5F
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 20:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCQTx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 15:53:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:43598 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgCQTx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 15:53:57 -0400
IronPort-SDR: NiXrL8DwljF97pNa85UmhnH34T2gA/S8mUt1s/zz57SQRqnL8XaRpUUUXpAXWGNSdBcjN5NjxN
 zJ96kevVUDfA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 12:53:55 -0700
IronPort-SDR: Ycsnj1AQXL2CoIr8PVFPOfKU/5vlVSg0xS409rOMErNjN36rTjp9vnKrdM3OalM48kYhMliZmt
 kr2E4TTQzT9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="233604303"
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
Subject: [PATCH 2/2] KVM: x86: Add blurb to CPUID tracepoint when using max basic leaf values
Date:   Tue, 17 Mar 2020 12:53:54 -0700
Message-Id: <20200317195354.28384-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317195354.28384-1-sean.j.christopherson@intel.com>
References: <20200317195354.28384-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tack on "used max basic" at the end of the CPUID tracepoint when the
output values correspond to the max basic leaf, i.e. when emulating
Intel's out-of-range CPUID behavior.  Observing "cpuid entry not found"
in the tracepoint with non-zero output values is confusing for users
that aren't familiar with the out-of-range semantics, and qualifying the
"not found" case hopefully makes it clear that "found" means "found the
exact entry".

Suggested-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c |  9 ++++++---
 arch/x86/kvm/trace.h | 11 +++++++----
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index bccaae0df668..a515a83c6f29 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -990,13 +990,15 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 {
 	u32 orig_function = *eax, function = *eax, index = *ecx;
 	struct kvm_cpuid_entry2 *entry;
-	bool exact;
+	bool exact, used_max_basic = false;
 
 	entry = kvm_find_cpuid_entry(vcpu, function, index);
 	exact = !!entry;
 
-	if (!entry && !exact_only)
+	if (!entry && !exact_only) {
 		entry = get_out_of_range_cpuid_entry(vcpu, &function, index);
+		used_max_basic = !!entry;
+	}
 
 	if (entry) {
 		*eax = entry->eax;
@@ -1026,7 +1028,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			}
 		}
 	}
-	trace_kvm_cpuid(orig_function, index, *eax, *ebx, *ecx, *edx, exact);
+	trace_kvm_cpuid(orig_function, index, *eax, *ebx, *ecx, *edx, exact,
+			used_max_basic);
 	return exact;
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 27270ba0f05f..c3d1e9f4a2c0 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -153,8 +153,8 @@ TRACE_EVENT(kvm_fast_mmio,
 TRACE_EVENT(kvm_cpuid,
 	TP_PROTO(unsigned int function, unsigned int index, unsigned long rax,
 		 unsigned long rbx, unsigned long rcx, unsigned long rdx,
-		 bool found),
-	TP_ARGS(function, index, rax, rbx, rcx, rdx, found),
+		 bool found, bool used_max_basic),
+	TP_ARGS(function, index, rax, rbx, rcx, rdx, found, used_max_basic),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	function	)
@@ -164,6 +164,7 @@ TRACE_EVENT(kvm_cpuid,
 		__field(	unsigned long,	rcx		)
 		__field(	unsigned long,	rdx		)
 		__field(	bool,		found		)
+		__field(	bool,		used_max_basic	)
 	),
 
 	TP_fast_assign(
@@ -174,12 +175,14 @@ TRACE_EVENT(kvm_cpuid,
 		__entry->rcx		= rcx;
 		__entry->rdx		= rdx;
 		__entry->found		= found;
+		__entry->used_max_basic	= used_max_basic;
 	),
 
-	TP_printk("func %x idx %x rax %lx rbx %lx rcx %lx rdx %lx, cpuid entry %s",
+	TP_printk("func %x idx %x rax %lx rbx %lx rcx %lx rdx %lx, cpuid entry %s%s",
 		  __entry->function, __entry->index, __entry->rax,
 		  __entry->rbx, __entry->rcx, __entry->rdx,
-		  __entry->found ? "found" : "not found")
+		  __entry->found ? "found" : "not found",
+		  __entry->used_max_basic ? ", used max basic" : "")
 );
 
 #define AREG(x) { APIC_##x, "APIC_" #x }
-- 
2.24.1

