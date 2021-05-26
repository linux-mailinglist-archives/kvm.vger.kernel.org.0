Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA048391329
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 10:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhEZI6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 04:58:35 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:36054 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbhEZI6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 04:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1622019422; x=1653555422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3wPvnsF/ciCyTMrN2F0SYoXhTPRBAG+at2K7ADcLiBQ=;
  b=s4aQDS4u7YW0wTvEBQIpId31a42mtM6nAzlPXtsqWQlAWkKIay1f+ffQ
   Ab27pNNRqfc21nsCq9N7QUZIvHHA6EiuYZy3/8MNqMiz5SyIvIrGUFd9b
   TXcMRHtftLe5OTHv46UI9mzc70VE3AQ69d4ZqOSD6ah+HvCOKYcP6qer2
   k=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="136915112"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 26 May 2021 08:57:01 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id B661FA1E76;
        Wed, 26 May 2021 08:56:59 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.97) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 08:56:50 +0000
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
Subject: [PATCH v4 2/4] KVM: hyper-v: Collect hypercall params into struct
Date:   Wed, 26 May 2021 10:56:09 +0200
Message-ID: <273f7ed510a1f6ba177e61b73a5c7bfbee4a4a87.1622019133.git.sidcha@amazon.de>
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

As of now there are 7 parameters (and flags) that are used in various
hyper-v hypercall handlers. There are 6 more input/output parameters
passed from XMM registers which are to be added in an upcoming patch.

To make passing arguments to the handlers more readable, capture all
these parameters into a single structure.

Cc: Alexander Graf <graf@amazon.com>
Cc: Evgeny Iakovlev <eyakovl@amazon.de>
Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 arch/x86/kvm/hyperv.c | 147 +++++++++++++++++++++++-------------------
 1 file changed, 79 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f98370a39936..8a542243e1cd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1623,7 +1623,18 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 	return vcpu_bitmap;
 }
 
-static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
+struct kvm_hv_hcall {
+	u64 param;
+	u64 ingpa;
+	u64 outgpa;
+	u16 code;
+	u16 rep_cnt;
+	u16 rep_idx;
+	bool fast;
+	bool rep;
+};
+
+static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
@@ -1638,7 +1649,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
 	bool all_cpus;
 
 	if (!ex) {
-		if (unlikely(kvm_read_guest(kvm, ingpa, &flush, sizeof(flush))))
+		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush, sizeof(flush))))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
 		trace_kvm_hv_flush_tlb(flush.processor_mask,
@@ -1657,7 +1668,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
 		all_cpus = (flush.flags & HV_FLUSH_ALL_PROCESSORS) ||
 			flush.processor_mask == 0;
 	} else {
-		if (unlikely(kvm_read_guest(kvm, ingpa, &flush_ex,
+		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
 					    sizeof(flush_ex))))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
@@ -1679,8 +1690,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
 
 		if (!all_cpus &&
 		    kvm_read_guest(kvm,
-				   ingpa + offsetof(struct hv_tlb_flush_ex,
-						    hv_vp_set.bank_contents),
+				   hc->ingpa + offsetof(struct hv_tlb_flush_ex,
+							hv_vp_set.bank_contents),
 				   sparse_banks,
 				   sparse_banks_len))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
@@ -1700,9 +1711,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
 				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
 
 ret_success:
-	/* We always do full TLB flush, set rep_done = rep_cnt. */
+	/* We always do full TLB flush, set 'Reps completed' = 'Rep Count' */
 	return (u64)HV_STATUS_SUCCESS |
-		((u64)rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
+		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
 }
 
 static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
@@ -1724,8 +1735,7 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
 	}
 }
 
-static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
-			   bool ex, bool fast)
+static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
@@ -1740,25 +1750,25 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
 	bool all_cpus;
 
 	if (!ex) {
-		if (!fast) {
-			if (unlikely(kvm_read_guest(kvm, ingpa, &send_ipi,
+		if (!hc->fast) {
+			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
 						    sizeof(send_ipi))))
 				return HV_STATUS_INVALID_HYPERCALL_INPUT;
 			sparse_banks[0] = send_ipi.cpu_mask;
 			vector = send_ipi.vector;
 		} else {
 			/* 'reserved' part of hv_send_ipi should be 0 */
-			if (unlikely(ingpa >> 32 != 0))
+			if (unlikely(hc->ingpa >> 32 != 0))
 				return HV_STATUS_INVALID_HYPERCALL_INPUT;
-			sparse_banks[0] = outgpa;
-			vector = (u32)ingpa;
+			sparse_banks[0] = hc->outgpa;
+			vector = (u32)hc->ingpa;
 		}
 		all_cpus = false;
 		valid_bank_mask = BIT_ULL(0);
 
 		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
 	} else {
-		if (unlikely(kvm_read_guest(kvm, ingpa, &send_ipi_ex,
+		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
 					    sizeof(send_ipi_ex))))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
@@ -1778,8 +1788,8 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
 
 		if (!all_cpus &&
 		    kvm_read_guest(kvm,
-				   ingpa + offsetof(struct hv_send_ipi_ex,
-						    vp_set.bank_contents),
+				   hc->ingpa + offsetof(struct hv_send_ipi_ex,
+							vp_set.bank_contents),
 				   sparse_banks,
 				   sparse_banks_len))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
@@ -1839,20 +1849,21 @@ static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 	return kvm_hv_hypercall_complete(vcpu, vcpu->run->hyperv.u.hcall.result);
 }
 
-static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
+static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
 	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
 	struct eventfd_ctx *eventfd;
 
-	if (unlikely(!fast)) {
+	if (unlikely(!hc->fast)) {
 		int ret;
-		gpa_t gpa = param;
+		gpa_t gpa = hc->ingpa;
 
-		if ((gpa & (__alignof__(param) - 1)) ||
-		    offset_in_page(gpa) + sizeof(param) > PAGE_SIZE)
+		if ((gpa & (__alignof__(hc->ingpa) - 1)) ||
+		    offset_in_page(gpa) + sizeof(hc->ingpa) > PAGE_SIZE)
 			return HV_STATUS_INVALID_ALIGNMENT;
 
-		ret = kvm_vcpu_read_guest(vcpu, gpa, &param, sizeof(param));
+		ret = kvm_vcpu_read_guest(vcpu, gpa,
+					  &hc->ingpa, sizeof(hc->ingpa));
 		if (ret < 0)
 			return HV_STATUS_INVALID_ALIGNMENT;
 	}
@@ -1862,15 +1873,15 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
 	 * have no use for it, and in all known usecases it is zero, so just
 	 * report lookup failure if it isn't.
 	 */
-	if (param & 0xffff00000000ULL)
+	if (hc->ingpa & 0xffff00000000ULL)
 		return HV_STATUS_INVALID_PORT_ID;
 	/* remaining bits are reserved-zero */
-	if (param & ~KVM_HYPERV_CONN_ID_MASK)
+	if (hc->ingpa & ~KVM_HYPERV_CONN_ID_MASK)
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
 	/* the eventfd is protected by vcpu->kvm->srcu, but conn_to_evt isn't */
 	rcu_read_lock();
-	eventfd = idr_find(&hv->conn_to_evt, param);
+	eventfd = idr_find(&hv->conn_to_evt, hc->ingpa);
 	rcu_read_unlock();
 	if (!eventfd)
 		return HV_STATUS_INVALID_PORT_ID;
@@ -1881,9 +1892,8 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
 
 int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 {
-	u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
-	uint16_t code, rep_idx, rep_cnt;
-	bool fast, rep;
+	struct kvm_hv_hcall hc;
+	u64 ret = HV_STATUS_SUCCESS;
 
 	/*
 	 * hypercall generates UD from non zero cpl and real mode
@@ -1896,104 +1906,105 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_X86_64
 	if (is_64_bit_mode(vcpu)) {
-		param = kvm_rcx_read(vcpu);
-		ingpa = kvm_rdx_read(vcpu);
-		outgpa = kvm_r8_read(vcpu);
+		hc.param = kvm_rcx_read(vcpu);
+		hc.ingpa = kvm_rdx_read(vcpu);
+		hc.outgpa = kvm_r8_read(vcpu);
 	} else
 #endif
 	{
-		param = ((u64)kvm_rdx_read(vcpu) << 32) |
-			(kvm_rax_read(vcpu) & 0xffffffff);
-		ingpa = ((u64)kvm_rbx_read(vcpu) << 32) |
-			(kvm_rcx_read(vcpu) & 0xffffffff);
-		outgpa = ((u64)kvm_rdi_read(vcpu) << 32) |
-			(kvm_rsi_read(vcpu) & 0xffffffff);
+		hc.param = ((u64)kvm_rdx_read(vcpu) << 32) |
+			    (kvm_rax_read(vcpu) & 0xffffffff);
+		hc.ingpa = ((u64)kvm_rbx_read(vcpu) << 32) |
+			    (kvm_rcx_read(vcpu) & 0xffffffff);
+		hc.outgpa = ((u64)kvm_rdi_read(vcpu) << 32) |
+			     (kvm_rsi_read(vcpu) & 0xffffffff);
 	}
 
-	code = param & 0xffff;
-	fast = !!(param & HV_HYPERCALL_FAST_BIT);
-	rep_cnt = (param >> HV_HYPERCALL_REP_COMP_OFFSET) & 0xfff;
-	rep_idx = (param >> HV_HYPERCALL_REP_START_OFFSET) & 0xfff;
-	rep = !!(rep_cnt || rep_idx);
+	hc.code = hc.param & 0xffff;
+	hc.fast = !!(hc.param & HV_HYPERCALL_FAST_BIT);
+	hc.rep_cnt = (hc.param >> HV_HYPERCALL_REP_COMP_OFFSET) & 0xfff;
+	hc.rep_idx = (hc.param >> HV_HYPERCALL_REP_START_OFFSET) & 0xfff;
+	hc.rep = !!(hc.rep_cnt || hc.rep_idx);
 
-	trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
+	trace_kvm_hv_hypercall(hc.code, hc.fast, hc.rep_cnt, hc.rep_idx,
+			       hc.ingpa, hc.outgpa);
 
-	switch (code) {
+	switch (hc.code) {
 	case HVCALL_NOTIFY_LONG_SPIN_WAIT:
-		if (unlikely(rep)) {
+		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
 		kvm_vcpu_on_spin(vcpu, true);
 		break;
 	case HVCALL_SIGNAL_EVENT:
-		if (unlikely(rep)) {
+		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hvcall_signal_event(vcpu, fast, ingpa);
+		ret = kvm_hvcall_signal_event(vcpu, &hc);
 		if (ret != HV_STATUS_INVALID_PORT_ID)
 			break;
 		fallthrough;	/* maybe userspace knows this conn_id */
 	case HVCALL_POST_MESSAGE:
 		/* don't bother userspace if it has no way to handle it */
-		if (unlikely(rep || !to_hv_synic(vcpu)->active)) {
+		if (unlikely(hc.rep || !to_hv_synic(vcpu)->active)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
 		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
 		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
-		vcpu->run->hyperv.u.hcall.input = param;
-		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
-		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
+		vcpu->run->hyperv.u.hcall.input = hc.param;
+		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
+		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
 		vcpu->arch.complete_userspace_io =
 				kvm_hv_hypercall_complete_userspace;
 		return 0;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
-		if (unlikely(fast || !rep_cnt || rep_idx)) {
+		if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
+		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
-		if (unlikely(fast || rep)) {
+		if (unlikely(hc.fast || hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
+		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
-		if (unlikely(fast || !rep_cnt || rep_idx)) {
+		if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
-		if (unlikely(fast || rep)) {
+		if (unlikely(hc.fast || hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
 		break;
 	case HVCALL_SEND_IPI:
-		if (unlikely(rep)) {
+		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, false, fast);
+		ret = kvm_hv_send_ipi(vcpu, &hc, false);
 		break;
 	case HVCALL_SEND_IPI_EX:
-		if (unlikely(fast || rep)) {
+		if (unlikely(hc.fast || hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
+		ret = kvm_hv_send_ipi(vcpu, &hc, true);
 		break;
 	case HVCALL_POST_DEBUG_DATA:
 	case HVCALL_RETRIEVE_DEBUG_DATA:
-		if (unlikely(fast)) {
+		if (unlikely(hc.fast)) {
 			ret = HV_STATUS_INVALID_PARAMETER;
 			break;
 		}
@@ -2012,9 +2023,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		}
 		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
 		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
-		vcpu->run->hyperv.u.hcall.input = param;
-		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
-		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
+		vcpu->run->hyperv.u.hcall.input = hc.param;
+		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
+		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
 		vcpu->arch.complete_userspace_io =
 				kvm_hv_hypercall_complete_userspace;
 		return 0;
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



