Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D17B35E88E
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 23:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348518AbhDMVwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 17:52:22 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:47817 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348510AbhDMVwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 17:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1618350722; x=1649886722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=UhdJgb28fMRLRdt5tcIIB4rGWRX4i8B0Qnh3kMOULdU=;
  b=p1TMkGJzlTWFW0MmMLwd65M6xApFAZ9kcmEpvkO0cxfhWTPAQDoiwlXr
   UUeivVnT79CkWluni9IL+/BpiHEWFCMgoDk+mHsmg6Icq+nR037eiLTtY
   o5SEOP9UMJd03DCox+Yw7l/zw833M2dgO8GhjseYFKS2Af6GRMn2TOKTd
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,220,1613433600"; 
   d="scan'208";a="118207325"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 13 Apr 2021 21:52:01 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 3545AA15FA;
        Tue, 13 Apr 2021 21:51:59 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.39) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 13 Apr 2021 21:51:50 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v3 3/4] KVM: x86: kvm_hv_flush_tlb use inputs from XMM registers
Date:   Tue, 13 Apr 2021 23:50:56 +0200
Message-ID: <8698b7ad625436e26d8f1dd5972b6b31907d313c.1618349671.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618349671.git.sidcha@amazon.de>
References: <cover.1618349671.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.39]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V supports the use of XMM registers to perform fast hypercalls.
This allows guests to take advantage of the improved performance of the
fast hypercall interface even though a hypercall may require more than
(the current maximum of) two input registers.

The XMM fast hypercall interface uses six additional XMM registers (XMM0
to XMM5) to allow the guest to pass an input parameter block of up to
112 bytes.

Add framework to read from XMM registers in kvm_hv_hypercall() and use
the additional hypercall inputs from XMM registers in kvm_hv_flush_tlb()
when possible.

Cc: Alexander Graf <graf@amazon.com>
Co-developed-by: Evgeny Iakovlev <eyakovl@amazon.de>
Signed-off-by: Evgeny Iakovlev <eyakovl@amazon.de>
Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 arch/x86/include/asm/hyperv-tlfs.h |  2 +
 arch/x86/kvm/hyperv.c              | 90 +++++++++++++++++++++++-------
 2 files changed, 73 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index e6cd3fee562b..ee6336a54f92 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -288,6 +288,8 @@ struct hv_tsc_emulation_status {
 #define HV_X64_MSR_TSC_REFERENCE_ENABLE		0x00000001
 #define HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT	12
 
+/* Number of XMM registers used in hypercall input/output */
+#define HV_HYPERCALL_MAX_XMM_REGISTERS		6
 
 /* Define hypervisor message types. */
 enum hv_message_type {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 8a542243e1cd..cd6c6f1f06a4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -36,6 +36,7 @@
 
 #include "trace.h"
 #include "irq.h"
+#include "fpu.h"
 
 /* "Hv#1" signature */
 #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
@@ -1632,10 +1633,13 @@ struct kvm_hv_hcall {
 	u16 rep_idx;
 	bool fast;
 	bool rep;
+	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
 };
 
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
 {
+	int i, j;
+	gpa_t gpa;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct hv_tlb_flush_ex flush_ex;
@@ -1649,8 +1653,15 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	bool all_cpus;
 
 	if (!ex) {
-		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush, sizeof(flush))))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (hc->fast) {
+			flush.address_space = hc->ingpa;
+			flush.flags = hc->outgpa;
+			flush.processor_mask = sse128_lo(hc->xmm[0]);
+		} else {
+			if (unlikely(kvm_read_guest(kvm, hc->ingpa,
+						    &flush, sizeof(flush))))
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		}
 
 		trace_kvm_hv_flush_tlb(flush.processor_mask,
 				       flush.address_space, flush.flags);
@@ -1668,9 +1679,16 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 		all_cpus = (flush.flags & HV_FLUSH_ALL_PROCESSORS) ||
 			flush.processor_mask == 0;
 	} else {
-		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
-					    sizeof(flush_ex))))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (hc->fast) {
+			flush_ex.address_space = hc->ingpa;
+			flush_ex.flags = hc->outgpa;
+			memcpy(&flush_ex.hv_vp_set,
+			       &hc->xmm[0], sizeof(hc->xmm[0]));
+		} else {
+			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
+						    sizeof(flush_ex))))
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		}
 
 		trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
 					  flush_ex.hv_vp_set.format,
@@ -1681,20 +1699,28 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 		all_cpus = flush_ex.hv_vp_set.format !=
 			HV_GENERIC_SET_SPARSE_4K;
 
-		sparse_banks_len =
-			bitmap_weight((unsigned long *)&valid_bank_mask, 64) *
-			sizeof(sparse_banks[0]);
+		sparse_banks_len = bitmap_weight((unsigned long *)&valid_bank_mask, 64);
 
 		if (!sparse_banks_len && !all_cpus)
 			goto ret_success;
 
-		if (!all_cpus &&
-		    kvm_read_guest(kvm,
-				   hc->ingpa + offsetof(struct hv_tlb_flush_ex,
-							hv_vp_set.bank_contents),
-				   sparse_banks,
-				   sparse_banks_len))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (!all_cpus) {
+			if (hc->fast) {
+				if (sparse_banks_len > HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
+					return HV_STATUS_INVALID_HYPERCALL_INPUT;
+				for (i = 0; i < sparse_banks_len; i += 2) {
+					sparse_banks[i] = sse128_lo(hc->xmm[i / 2 + 1]);
+					sparse_banks[i + 1] = sse128_hi(hc->xmm[i / 2 + 1]);
+				}
+			} else {
+				gpa = hc->ingpa + offsetof(struct hv_tlb_flush_ex,
+							   hv_vp_set.bank_contents);
+				if (unlikely(kvm_read_guest(kvm, gpa, sparse_banks,
+							    sparse_banks_len *
+							    sizeof(sparse_banks[0]))))
+					return HV_STATUS_INVALID_HYPERCALL_INPUT;
+			}
+		}
 	}
 
 	cpumask_clear(&hv_vcpu->tlb_flush);
@@ -1890,6 +1916,29 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *h
 	return HV_STATUS_SUCCESS;
 }
 
+static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
+{
+	switch (hc->code) {
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
+		return true;
+	}
+
+	return false;
+}
+
+static void kvm_hv_hypercall_read_xmm(struct kvm_hv_hcall *hc)
+{
+	int reg;
+
+	kvm_fpu_get();
+	for (reg = 0; reg < HV_HYPERCALL_MAX_XMM_REGISTERS; reg++)
+		_kvm_read_sse_reg(reg, &hc->xmm[reg]);
+	kvm_fpu_put();
+}
+
 int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_hv_hcall hc;
@@ -1926,6 +1975,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	hc.rep_idx = (hc.param >> HV_HYPERCALL_REP_START_OFFSET) & 0xfff;
 	hc.rep = !!(hc.rep_cnt || hc.rep_idx);
 
+	if (hc.fast && is_xmm_fast_hypercall(&hc))
+		kvm_hv_hypercall_read_xmm(&hc);
+
 	trace_kvm_hv_hypercall(hc.code, hc.fast, hc.rep_cnt, hc.rep_idx,
 			       hc.ingpa, hc.outgpa);
 
@@ -1961,28 +2013,28 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 				kvm_hv_hypercall_complete_userspace;
 		return 0;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
-		if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
+		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
 		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
-		if (unlikely(hc.fast || hc.rep)) {
+		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
 		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
-		if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
+		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
 		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
-		if (unlikely(hc.fast || hc.rep)) {
+		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



