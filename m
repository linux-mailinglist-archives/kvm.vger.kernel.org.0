Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224FE10777F
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 19:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKVSlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 13:41:04 -0500
Received: from mail-qk1-f201.google.com ([209.85.222.201]:55865 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfKVSlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 13:41:04 -0500
Received: by mail-qk1-f201.google.com with SMTP id a129so4856094qkg.22
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 10:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=M16VmXVu2rjZ6nO5g0j0hcAiSJk1qPST8NpRbWiWYWU=;
        b=s7WcBt11M5jGVryvmT3NXUS0nUjfkATW5LfiI75MswbLyql4LoAf00fBM7oVZyxi34
         z5ObjNYvJIiTbvDhLC5BUrjerXxVx8qmVXaQDjev9ftjEvl+5wbAj9R8pSnf1y1LOy9o
         IEAHS+aaBkouUTF/UVJvGHEXRN9ReERpH9LFxYuZZH7bZFEqCcdtV99ZlEPVrml7FgWm
         3UeZ+W5kvyWZLfhQZ1A4z/uewD/zjiSzfp6k86nUbrRoXfWA3P4xJNyYkF1BAuDOGI+8
         xQS8k1rPo80TUU2P8EHx3IwM5q7b+dns1P2SbOXAPw17WZlaqit5JKhMFq2AU0uVOSel
         pMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=M16VmXVu2rjZ6nO5g0j0hcAiSJk1qPST8NpRbWiWYWU=;
        b=AZk995kMB71JLrFu8kc2PxJRknkWpbME4J9pHVqx7HCkN0Wh10Z5adBF7c57rofR48
         97NGxC5ACASZgEEWJbK5wxzWyke30CctXN3kvRFk2qHkN6Ybh7Xf8GEbyT217q9xlFS8
         LuqELDG50QuzDJ9crCqvi+1LjMkGgeHPx/BwrL6m6mTfpTTXXJaol1qE3bdme6i0hWzg
         ZXLOSuMkaYO8VK9U0NNDPco3bEDn71t97qe1sknR9za7HUE80P2HigreZ0zGAuvyqsvD
         uk2Rgx23oe40FVXB1tn4a+R9Sxkq68Kx6MjkjA84s09J0lVktw/LWIlCgocn2G7zDCBl
         te2w==
X-Gm-Message-State: APjAAAVofekL8jyCVJKVhMpPzCIVeZUut/QUDhOWQzdGXr6SUViM/l2Q
        8p1q/Yi1vcHODovTSP//rgzkx2E09NIE
X-Google-Smtp-Source: APXvYqw1bvuNiPumSkhNydLWLwyzNjMJNKnnngs2HnC62Aqx91cPQE4P0ZOE2rhGxUhhApSzfUptVCgqLzHx
X-Received: by 2002:a37:96c4:: with SMTP id y187mr1558511qkd.281.1574448062985;
 Fri, 22 Nov 2019 10:41:02 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:40:39 -0800
Message-Id: <20191122184039.7189-1-pomonis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH] KVM: x86: Extend Spectre-v1 mitigation
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marios Pomonis <pomonis@google.com>,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nick Finco <nifi@google.com>

This extends the Spectre-v1 mitigation introduced in
commit 75f139aaf896 ("KVM: x86: Add memory barrier on vmcs field lookup")
and commit 085331dfc6bb ("x86/kvm: Update spectre-v1 mitigation") in light
of the Spectre-v1/L1TF combination described here:
https://xenbits.xen.org/xsa/advisory-289.html

As reported in the link, an attacker can use the cache-load part of a
Spectre-v1 gadget to bring memory into the L1 cache, then use L1TF to
leak the loaded memory. Note that this attack is not fully mitigated by
core scheduling; an attacker could employ L1TF on the same thread that
loaded the memory in L1 instead of relying on neighboring hyperthreads.

This patch uses array_index_nospec() to prevent index computations from
causing speculative loads into the L1 cache. These cases involve a
bounds check followed by a memory read using the index; this is more
common than the full Spectre-v1 pattern. In some cases, the index
computation can be eliminated entirely by small amounts of refactoring.

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Acked-by: Andrew Honig <ahonig@google.com>
---
 arch/x86/kvm/emulate.c       | 11 ++++++++---
 arch/x86/kvm/hyperv.c        | 10 ++++++----
 arch/x86/kvm/i8259.c         |  6 +++++-
 arch/x86/kvm/ioapic.c        | 15 +++++++++------
 arch/x86/kvm/lapic.c         | 13 +++++++++----
 arch/x86/kvm/mtrr.c          |  8 ++++++--
 arch/x86/kvm/pmu.h           | 18 ++++++++++++++----
 arch/x86/kvm/vmx/pmu_intel.c | 24 ++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c       | 22 ++++++++++++++++------
 arch/x86/kvm/x86.c           | 18 ++++++++++++++----
 10 files changed, 103 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 952d1a4f4d7e..fcf7cdb21d60 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5303,10 +5303,15 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 			}
 			break;
 		case Escape:
-			if (ctxt->modrm > 0xbf)
-				opcode = opcode.u.esc->high[ctxt->modrm - 0xc0];
-			else
+			if (ctxt->modrm > 0xbf) {
+				size_t size = ARRAY_SIZE(opcode.u.esc->high);
+				u32 index = array_index_nospec(
+					ctxt->modrm - 0xc0, size);
+
+				opcode = opcode.u.esc->high[index];
+			} else {
 				opcode = opcode.u.esc->op[(ctxt->modrm >> 3) & 7];
+			}
 			break;
 		case InstrDual:
 			if ((ctxt->modrm >> 6) == 3)
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 23ff65504d7e..26408434b9bc 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -809,11 +809,12 @@ static int kvm_hv_msr_get_crash_data(struct kvm_vcpu *vcpu,
 				     u32 index, u64 *pdata)
 {
 	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
+	size_t size = ARRAY_SIZE(hv->hv_crash_param);
 
-	if (WARN_ON_ONCE(index >= ARRAY_SIZE(hv->hv_crash_param)))
+	if (WARN_ON_ONCE(index >= size))
 		return -EINVAL;
 
-	*pdata = hv->hv_crash_param[index];
+	*pdata = hv->hv_crash_param[array_index_nospec(index, size)];
 	return 0;
 }
 
@@ -852,11 +853,12 @@ static int kvm_hv_msr_set_crash_data(struct kvm_vcpu *vcpu,
 				     u32 index, u64 data)
 {
 	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
+	size_t size = ARRAY_SIZE(hv->hv_crash_param);
 
-	if (WARN_ON_ONCE(index >= ARRAY_SIZE(hv->hv_crash_param)))
+	if (WARN_ON_ONCE(index >= size))
 		return -EINVAL;
 
-	hv->hv_crash_param[index] = data;
+	hv->hv_crash_param[array_index_nospec(index, size)] = data;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 8b38bb4868a6..629a09ca9860 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -460,10 +460,14 @@ static int picdev_write(struct kvm_pic *s,
 	switch (addr) {
 	case 0x20:
 	case 0x21:
+		pic_lock(s);
+		pic_ioport_write(&s->pics[0], addr, data);
+		pic_unlock(s);
+		break;
 	case 0xa0:
 	case 0xa1:
 		pic_lock(s);
-		pic_ioport_write(&s->pics[addr >> 7], addr, data);
+		pic_ioport_write(&s->pics[1], addr, data);
 		pic_unlock(s);
 		break;
 	case 0x4d0:
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 9fd2dd89a1c5..8aa58727045e 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -36,6 +36,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/nospec.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/current.h>
@@ -68,13 +69,14 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 	default:
 		{
 			u32 redir_index = (ioapic->ioregsel - 0x10) >> 1;
-			u64 redir_content;
+			u64 redir_content = ~0ULL;
 
-			if (redir_index < IOAPIC_NUM_PINS)
-				redir_content =
-					ioapic->redirtbl[redir_index].bits;
-			else
-				redir_content = ~0ULL;
+			if (redir_index < IOAPIC_NUM_PINS) {
+				u32 index = array_index_nospec(
+					redir_index, IOAPIC_NUM_PINS);
+
+				redir_content = ioapic->redirtbl[index].bits;
+			}
 
 			result = (ioapic->ioregsel & 0x1) ?
 			    (redir_content >> 32) & 0xffffffff :
@@ -292,6 +294,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 
 		if (index >= IOAPIC_NUM_PINS)
 			return;
+		index = array_index_nospec(index, IOAPIC_NUM_PINS);
 		e = &ioapic->redirtbl[index];
 		mask_before = e->fields.mask;
 		/* Preserve read-only fields */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cf9177b4a07f..3323115f52d5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1963,15 +1963,20 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_LVTTHMR:
 	case APIC_LVTPC:
 	case APIC_LVT1:
-	case APIC_LVTERR:
+	case APIC_LVTERR: {
 		/* TODO: Check vector */
+		size_t size;
+		u32 index;
+
 		if (!kvm_apic_sw_enabled(apic))
 			val |= APIC_LVT_MASKED;
-
-		val &= apic_lvt_mask[(reg - APIC_LVTT) >> 4];
+		size = ARRAY_SIZE(apic_lvt_mask);
+		index = array_index_nospec(
+				(reg - APIC_LVTT) >> 4, size);
+		val &= apic_lvt_mask[index];
 		kvm_lapic_set_reg(apic, reg, val);
-
 		break;
+	}
 
 	case APIC_LVTT:
 		if (!kvm_apic_sw_enabled(apic))
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 25ce3edd1872..7f0059aa30e1 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -192,11 +192,15 @@ static bool fixed_msr_to_seg_unit(u32 msr, int *seg, int *unit)
 		break;
 	case MSR_MTRRfix16K_80000 ... MSR_MTRRfix16K_A0000:
 		*seg = 1;
-		*unit = msr - MSR_MTRRfix16K_80000;
+		*unit = array_index_nospec(
+			msr - MSR_MTRRfix16K_80000,
+			MSR_MTRRfix16K_A0000 - MSR_MTRRfix16K_80000 + 1);
 		break;
 	case MSR_MTRRfix4K_C0000 ... MSR_MTRRfix4K_F8000:
 		*seg = 2;
-		*unit = msr - MSR_MTRRfix4K_C0000;
+		*unit = array_index_nospec(
+			msr - MSR_MTRRfix4K_C0000,
+			MSR_MTRRfix4K_F8000 - MSR_MTRRfix4K_C0000 + 1);
 		break;
 	default:
 		return false;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7ebb62326c14..13332984b6d5 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -2,6 +2,8 @@
 #ifndef __KVM_X86_PMU_H
 #define __KVM_X86_PMU_H
 
+#include <linux/nospec.h>
+
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
@@ -102,8 +104,12 @@ static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
 static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 					 u32 base)
 {
-	if (msr >= base && msr < base + pmu->nr_arch_gp_counters)
-		return &pmu->gp_counters[msr - base];
+	if (msr >= base && msr < base + pmu->nr_arch_gp_counters) {
+		u32 index = array_index_nospec(msr - base,
+					       pmu->nr_arch_gp_counters);
+
+		return &pmu->gp_counters[index];
+	}
 
 	return NULL;
 }
@@ -113,8 +119,12 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
 {
 	int base = MSR_CORE_PERF_FIXED_CTR0;
 
-	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters)
-		return &pmu->fixed_counters[msr - base];
+	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
+		u32 index = array_index_nospec(msr - base,
+					       pmu->nr_arch_fixed_counters);
+
+		return &pmu->fixed_counters[index];
+	}
 
 	return NULL;
 }
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7023138b1cb0..34a3a17bb6d7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -86,10 +86,14 @@ static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 
 static unsigned intel_find_fixed_event(int idx)
 {
-	if (idx >= ARRAY_SIZE(fixed_pmc_events))
+	u32 event;
+	size_t size = ARRAY_SIZE(fixed_pmc_events);
+
+	if (idx >= size)
 		return PERF_COUNT_HW_MAX;
 
-	return intel_arch_events[fixed_pmc_events[idx]].event_type;
+	event = fixed_pmc_events[array_index_nospec(idx, size)];
+	return intel_arch_events[event].event_type;
 }
 
 /* check if a PMC is enabled by comparing it with globl_ctrl bits. */
@@ -130,16 +134,20 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	bool fixed = idx & (1u << 30);
 	struct kvm_pmc *counters;
+	unsigned int num_counters;
 
 	idx &= ~(3u << 30);
-	if (!fixed && idx >= pmu->nr_arch_gp_counters)
-		return NULL;
-	if (fixed && idx >= pmu->nr_arch_fixed_counters)
+	if (fixed) {
+		counters = pmu->fixed_counters;
+		num_counters = pmu->nr_arch_fixed_counters;
+	} else {
+		counters = pmu->gp_counters;
+		num_counters = pmu->nr_arch_gp_counters;
+	}
+	if (idx >= num_counters)
 		return NULL;
-	counters = fixed ? pmu->fixed_counters : pmu->gp_counters;
 	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
-
-	return &counters[idx];
+	return &counters[array_index_nospec(idx, num_counters)];
 }
 
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d39475e2d44e..84def8e46d10 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -753,7 +753,9 @@ static bool vmx_segment_cache_test_set(struct vcpu_vmx *vmx, unsigned seg,
 
 static u16 vmx_read_guest_seg_selector(struct vcpu_vmx *vmx, unsigned seg)
 {
-	u16 *p = &vmx->segment_cache.seg[seg].selector;
+	size_t size = ARRAY_SIZE(vmx->segment_cache.seg);
+	size_t index = array_index_nospec(seg, size);
+	u16 *p = &vmx->segment_cache.seg[index].selector;
 
 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_SEL))
 		*p = vmcs_read16(kvm_vmx_segment_fields[seg].selector);
@@ -762,7 +764,9 @@ static u16 vmx_read_guest_seg_selector(struct vcpu_vmx *vmx, unsigned seg)
 
 static ulong vmx_read_guest_seg_base(struct vcpu_vmx *vmx, unsigned seg)
 {
-	ulong *p = &vmx->segment_cache.seg[seg].base;
+	size_t size = ARRAY_SIZE(vmx->segment_cache.seg);
+	size_t index = array_index_nospec(seg, size);
+	ulong *p = &vmx->segment_cache.seg[index].base;
 
 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_BASE))
 		*p = vmcs_readl(kvm_vmx_segment_fields[seg].base);
@@ -771,7 +775,9 @@ static ulong vmx_read_guest_seg_base(struct vcpu_vmx *vmx, unsigned seg)
 
 static u32 vmx_read_guest_seg_limit(struct vcpu_vmx *vmx, unsigned seg)
 {
-	u32 *p = &vmx->segment_cache.seg[seg].limit;
+	size_t size = ARRAY_SIZE(vmx->segment_cache.seg);
+	size_t index = array_index_nospec(seg, size);
+	u32 *p = &vmx->segment_cache.seg[index].limit;
 
 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_LIMIT))
 		*p = vmcs_read32(kvm_vmx_segment_fields[seg].limit);
@@ -780,7 +786,9 @@ static u32 vmx_read_guest_seg_limit(struct vcpu_vmx *vmx, unsigned seg)
 
 static u32 vmx_read_guest_seg_ar(struct vcpu_vmx *vmx, unsigned seg)
 {
-	u32 *p = &vmx->segment_cache.seg[seg].ar;
+	size_t size = ARRAY_SIZE(vmx->segment_cache.seg);
+	size_t index = array_index_nospec(seg, size);
+	u32 *p = &vmx->segment_cache.seg[index].ar;
 
 	if (!vmx_segment_cache_test_set(vmx, seg, SEG_FIELD_AR))
 		*p = vmcs_read32(kvm_vmx_segment_fields[seg].ar_bytes);
@@ -5828,6 +5836,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 exit_reason = vmx->exit_reason;
+	u32 bounded_exit_reason = array_index_nospec(exit_reason,
+						kvm_vmx_max_exit_handlers);
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
 	trace_kvm_exit(exit_reason, vcpu, KVM_ISA_VMX);
@@ -5911,7 +5921,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	}
 
 	if (exit_reason < kvm_vmx_max_exit_handlers
-	    && kvm_vmx_exit_handlers[exit_reason]) {
+	    && kvm_vmx_exit_handlers[bounded_exit_reason]) {
 #ifdef CONFIG_RETPOLINE
 		if (exit_reason == EXIT_REASON_MSR_WRITE)
 			return kvm_emulate_wrmsr(vcpu);
@@ -5926,7 +5936,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
 			return handle_ept_misconfig(vcpu);
 #endif
-		return kvm_vmx_exit_handlers[exit_reason](vcpu);
+		return kvm_vmx_exit_handlers[bounded_exit_reason](vcpu);
 	} else {
 		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
 				exit_reason);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a256e09f321a..9a2789652231 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1057,9 +1057,11 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 
 static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 {
+	size_t size = ARRAY_SIZE(vcpu->arch.db);
+
 	switch (dr) {
 	case 0 ... 3:
-		vcpu->arch.db[dr] = val;
+		vcpu->arch.db[array_index_nospec(dr, size)] = val;
 		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
 			vcpu->arch.eff_db[dr] = val;
 		break;
@@ -1096,9 +1098,11 @@ EXPORT_SYMBOL_GPL(kvm_set_dr);
 
 int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 {
+	size_t size = ARRAY_SIZE(vcpu->arch.db);
+
 	switch (dr) {
 	case 0 ... 3:
-		*val = vcpu->arch.db[dr];
+		*val = vcpu->arch.db[array_index_nospec(dr, size)];
 		break;
 	case 4:
 		/* fall through */
@@ -2496,7 +2500,10 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = msr - MSR_IA32_MC0_CTL;
+			u32 offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL,
+				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+
 			/* only 0 or all 1s can be written to IA32_MCi_CTL
 			 * some Linux kernels though clear bit 10 in bank 4 to
 			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
@@ -2937,7 +2944,10 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = msr - MSR_IA32_MC0_CTL;
+			u32 offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL,
+				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+
 			data = vcpu->arch.mce_banks[offset];
 			break;
 		}
-- 
2.24.0.432.g9d3f5f5b63-goog

