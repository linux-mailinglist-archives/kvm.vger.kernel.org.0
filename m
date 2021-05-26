Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFB539132F
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 10:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbhEZI7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 04:59:01 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:5568 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbhEZI6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 04:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1622019438; x=1653555438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=W199YgHs9FZzPPSe5SeOvIB3RxQ+Bi6LSIo5zxd32Zg=;
  b=N1xT+hPGq3+4HACQ9R8FiJ69eQKfq4zkTaqAccitov0jwOBSdurJfs6n
   wI0clBI0BMsC87rm3l71Squ3SeOQVPh6KBz6CDc7zBj7fW3mTG/SYJTTu
   C7NF6raER3Qch+Xr2vJ6yZU0QJUSPTwSvyrXiOYOQtrPxeKC6xVoYrymj
   o=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="3366737"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 26 May 2021 08:57:10 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id ED87AA073E;
        Wed, 26 May 2021 08:57:07 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.97) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 08:56:58 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v4 3/4] KVM: x86: kvm_hv_flush_tlb use inputs from XMM registers
Date:   Wed, 26 May 2021 10:56:10 +0200
Message-ID: <fc62edad33f1920fe5c74dde47d7d0b4275a9012.1622019134.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1622019133.git.sidcha@amazon.de>
References: <cover.1622019133.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.97]
X-ClientProxiedBy: EX13D34UWA003.ant.amazon.com (10.43.160.69) To
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
 arch/x86/include/asm/hyperv-tlfs.h |  3 +
 arch/x86/kvm/hyperv.c              | 90 +++++++++++++++++++++++-------
 2 files changed, 74 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 606f5cc579b2..27a9f08e8386 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -314,6 +314,9 @@ struct hv_tsc_emulation_status {
 #define HV_X64_MSR_TSC_REFERENCE_ENABLE		0x00000001
 #define HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT	12
 
+/* Number of XMM registers used in hypercall input/output */
+#define HV_HYPERCALL_MAX_XMM_REGISTERS		6
+
 struct hv_nested_enlightenments_control {
 	struct {
 		__u32 directhypercall:1;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 8a542243e1cd..8fcaf3fc9c2a 100644
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
+	int i;
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



