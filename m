Return-Path: <kvm+bounces-62908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4502AC53C07
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:43:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DAC713448A0
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45438347BC7;
	Wed, 12 Nov 2025 17:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UuIbnZ/E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B7334BA49
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969199; cv=none; b=Bk+rsTq+hkmdZ0xCKin/NxHfU5t/OiFJB4i+/+GUr/WPBulXutbPUnvLrRnNuSz6LpBiRLk8M48mpgFV+jYr6X84bVhB6OnnrhZW9sV00HcG4UeVq10gDGUV7udV2s6uq9J4aArkkl4CMfSSkaK1XSbr/3N2BCy/gIr4ukIFaeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969199; c=relaxed/simple;
	bh=JzA1BbVb9FdRo84jG23UccIkI0HISnLDQsMdRFFik1Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NVKZQikejL5ivwosnckmBfreb3wJueDop26TXNiREGbDp2YyryPz79LeVCp/no0y0JhnKovpHNv65nLF+35ZNU8lxRVMhjQ7jDWIGSTVsT4w07awiMu0BnAqspXPmgQKJ93i7g2u6vqktSXLv2+MRewosiXWDofflDkEStgTSKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UuIbnZ/E; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34377900dbcso1572290a91.2
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 09:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762969195; x=1763573995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4H3rnVq4nzNldej50N3zX2rxGtEpjfR/UgxHbH/Jt6o=;
        b=UuIbnZ/E4KP1boQWdDUyrzrMX1II/IXbsAh+ZrGLKRhoFEo93rWgl8chxyK/XhysBY
         A05RRlYa/smYazBemPcgLg/dFe5lzLdos2kJaPARRnVzCB/RT7Ruwy8gCTgkVYb7GVdD
         1kE2zmppfhyXl7T8elvh1pq7TQ3bS1t20ZZzHs5XYiYI46aSPR28eeMED+G4uX8QFzuV
         xjMSziLNHt01CXiIblU6RJosUSwX+y/xghuIhyrvsDliwPIyObzlFp4xbjY5FPUhSh/Z
         IVr2QJuTkKzsvaoZYrKdsTR3EUl/mbHfeJuEdXGSRoHGytyoViDrpGrl6iGbh7f62hNZ
         +3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969195; x=1763573995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4H3rnVq4nzNldej50N3zX2rxGtEpjfR/UgxHbH/Jt6o=;
        b=aReHc5nqEoXrC1mJJE1ebrPQntryg/zRL67aA2NYcqkrnYLH1hoDJ24tPDvZfhpN5j
         Z0KCatEAZcZEnGiUuU+1JeS7Byu/e2Or33z4zCd2dsKujQzI0oJPt35F/JGqhJ5Bm0VO
         F0kl9pXtomqJql2b8429BzrFVVuWTCR3/IeS58SgOVV8Rg+3NASD4OE9UWaf4iKLfld9
         oK0BM0lBXvRihoBNM8fhShaW441ODWPMcjoOksZKg64+GNVN0i2wj7B8ODdkzUWT0Vt9
         pP2TnpSgPnLDFvd69OY5EBOmttfqNMdQxeVC/XeMfq9rsxcOLBJ4wapNXAjolpBX/sfZ
         Jc5A==
X-Forwarded-Encrypted: i=1; AJvYcCXl67pH0Kp9zNdBZSHcBlg45o4BdwpzsJCi3/ZIkXJ/L0yBidJAJL5TRL46OKo7BuyOloU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTKhuFzog+HNHFo0k+xCSMHGWTfNxDzULWE4t2ChKNgFaZyTUk
	k/QgeVXD2t8p4WQTRGuGJmxR7EcwQl7qiKsnTJdwOVKI+XTxkCeo6jsl4uZoyxjY6QecQdYHPSg
	gvZtgSA==
X-Google-Smtp-Source: AGHT+IEk/54vDfEzHPhh2VbDyEX0KWbkU5XhjVLQelyS7HliIdBDroR5jx+mlAVWa019Qr3aLPFY5c3RTDs=
X-Received: from pjbco15.prod.google.com ([2002:a17:90a:fe8f:b0:340:d512:22dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d403:b0:343:b610:901c
 with SMTP id 98e67ed59e1d1-343ddea7c0dmr5010335a91.26.1762969195035; Wed, 12
 Nov 2025 09:39:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 09:39:44 -0800
In-Reply-To: <20251112173944.1380633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112173944.1380633-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112173944.1380633-5-seanjc@google.com>
Subject: [PATCH 4/4] x86: Restrict KVM-induced symbol exports to KVM modules
 where obvious/possible
From: Sean Christopherson <seanjc@google.com>
To: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org, linux-sgx@vger.kernel.org, linux-coco@lists.linux.dev, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Extend KVM's export macro framework to provide EXPORT_SYMBOL_FOR_KVM(),
and use the helper macro to export symbols for KVM throughout x86 if and
only if KVM will build one or more modules, and only for those modules.

To avoid unnecessary exports when CONFIG_KVM=m but kvm.ko will not be
built (because no vendor modules are selected), let arch code #define
EXPORT_SYMBOL_FOR_KVM to suppress/override the exports.

Note, the set of symbols to restrict to KVM was generated by manual search
and audit; any "misses" are due to human error, not some grand plan.

Acked-by: Kai Huang <kai.huang@intel.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/entry/entry.S             |  7 ++-
 arch/x86/entry/entry_64.S          |  3 +-
 arch/x86/entry/entry_64_fred.S     |  3 +-
 arch/x86/events/amd/core.c         |  5 ++-
 arch/x86/events/core.c             |  7 +--
 arch/x86/events/intel/lbr.c        |  3 +-
 arch/x86/events/intel/pt.c         |  7 +--
 arch/x86/include/asm/kvm_types.h   |  5 +++
 arch/x86/kernel/apic/apic.c        |  3 +-
 arch/x86/kernel/apic/apic_common.c |  3 +-
 arch/x86/kernel/cpu/amd.c          |  4 +-
 arch/x86/kernel/cpu/bugs.c         | 17 ++++----
 arch/x86/kernel/cpu/bus_lock.c     |  3 +-
 arch/x86/kernel/cpu/common.c       |  7 +--
 arch/x86/kernel/cpu/sgx/main.c     |  3 +-
 arch/x86/kernel/cpu/sgx/virt.c     |  5 ++-
 arch/x86/kernel/e820.c             |  3 +-
 arch/x86/kernel/fpu/core.c         | 21 ++++-----
 arch/x86/kernel/fpu/xstate.c       |  7 +--
 arch/x86/kernel/hw_breakpoint.c    |  3 +-
 arch/x86/kernel/irq.c              |  3 +-
 arch/x86/kernel/kvm.c              |  5 ++-
 arch/x86/kernel/nmi.c              |  5 +--
 arch/x86/kernel/process_64.c       |  5 +--
 arch/x86/kernel/reboot.c           |  5 ++-
 arch/x86/kernel/tsc.c              |  1 +
 arch/x86/lib/cache-smp.c           |  9 ++--
 arch/x86/lib/msr.c                 |  5 ++-
 arch/x86/mm/pat/memtype.c          |  3 +-
 arch/x86/mm/tlb.c                  |  5 ++-
 arch/x86/virt/vmx/tdx/tdx.c        | 69 +++++++++++++++---------------
 include/linux/kvm_types.h          | 14 ++++++
 32 files changed, 144 insertions(+), 104 deletions(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index 8e9a0cc20a4a..1d723c5ae9dd 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -4,6 +4,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/kvm_types.h>
 #include <linux/linkage.h>
 #include <linux/objtool.h>
 #include <asm/msr-index.h>
@@ -29,8 +30,7 @@ SYM_FUNC_START(write_ibpb)
 	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET
 	RET
 SYM_FUNC_END(write_ibpb)
-/* For KVM */
-EXPORT_SYMBOL_GPL(write_ibpb);
+EXPORT_SYMBOL_FOR_KVM(write_ibpb);
 
 .popsection
 
@@ -48,8 +48,7 @@ SYM_CODE_START_NOALIGN(x86_verw_sel)
 	.word __KERNEL_DS
 .align L1_CACHE_BYTES, 0xcc
 SYM_CODE_END(x86_verw_sel);
-/* For KVM */
-EXPORT_SYMBOL_GPL(x86_verw_sel);
+EXPORT_SYMBOL_FOR_KVM(x86_verw_sel);
 
 .popsection
 
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index ed04a968cc7d..f9983a1907bf 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -19,6 +19,7 @@
  * - idtentry:		Define exception entry points.
  */
 #include <linux/export.h>
+#include <linux/kvm_types.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/cache.h>
@@ -1566,5 +1567,5 @@ SYM_FUNC_START(clear_bhb_loop)
 	pop	%rbp
 	RET
 SYM_FUNC_END(clear_bhb_loop)
-EXPORT_SYMBOL_GPL(clear_bhb_loop)
+EXPORT_SYMBOL_FOR_KVM(clear_bhb_loop)
 STACK_FRAME_NON_STANDARD(clear_bhb_loop)
diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index fafbd3e68cb8..894f7f16eb80 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -4,6 +4,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/kvm_types.h>
 
 #include <asm/asm.h>
 #include <asm/fred.h>
@@ -146,5 +147,5 @@ SYM_FUNC_START(asm_fred_entry_from_kvm)
 	RET
 
 SYM_FUNC_END(asm_fred_entry_from_kvm)
-EXPORT_SYMBOL_GPL(asm_fred_entry_from_kvm);
+EXPORT_SYMBOL_FOR_KVM(asm_fred_entry_from_kvm);
 #endif
diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 8868f5f5379b..44656d2fb555 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -2,6 +2,7 @@
 #include <linux/perf_event.h>
 #include <linux/jump_label.h>
 #include <linux/export.h>
+#include <linux/kvm_types.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1574,7 +1575,7 @@ void amd_pmu_enable_virt(void)
 	/* Reload all events */
 	amd_pmu_reload_virt();
 }
-EXPORT_SYMBOL_GPL(amd_pmu_enable_virt);
+EXPORT_SYMBOL_FOR_KVM(amd_pmu_enable_virt);
 
 void amd_pmu_disable_virt(void)
 {
@@ -1591,4 +1592,4 @@ void amd_pmu_disable_virt(void)
 	/* Reload all events */
 	amd_pmu_reload_virt();
 }
-EXPORT_SYMBOL_GPL(amd_pmu_disable_virt);
+EXPORT_SYMBOL_FOR_KVM(amd_pmu_disable_virt);
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 0cf68ad9dcd0..021461daee81 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -20,6 +20,7 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/kdebug.h>
+#include <linux/kvm_types.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/clock.h>
 #include <linux/uaccess.h>
@@ -714,7 +715,7 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
 {
 	return static_call(x86_pmu_guest_get_msrs)(nr, data);
 }
-EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
+EXPORT_SYMBOL_FOR_KVM(perf_guest_get_msrs);
 
 /*
  * There may be PMI landing after enabled=0. The PMI hitting could be before or
@@ -3066,7 +3067,7 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 	cap->pebs_ept		= x86_pmu.pebs_ept;
 }
-EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
+EXPORT_SYMBOL_FOR_KVM(perf_get_x86_pmu_capability);
 
 u64 perf_get_hw_event_config(int hw_event)
 {
@@ -3077,4 +3078,4 @@ u64 perf_get_hw_event_config(int hw_event)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(perf_get_hw_event_config);
+EXPORT_SYMBOL_FOR_KVM(perf_get_hw_event_config);
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 7aa59966e7c3..72f2adcda7c6 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/kvm_types.h>
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
@@ -1705,7 +1706,7 @@ void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 	lbr->info = x86_pmu.lbr_info;
 	lbr->has_callstack = x86_pmu_has_lbr_callstack();
 }
-EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
+EXPORT_SYMBOL_FOR_KVM(x86_perf_get_lbr);
 
 struct event_constraint vlbr_constraint =
 	__EVENT_CONSTRAINT(INTEL_FIXED_VLBR_EVENT, (1ULL << INTEL_PMC_IDX_FIXED_VLBR),
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index e8cf29d2b10c..44524a387c58 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -17,6 +17,7 @@
 #include <linux/limits.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/kvm_types.h>
 
 #include <asm/cpuid/api.h>
 #include <asm/perf_event.h>
@@ -82,13 +83,13 @@ u32 intel_pt_validate_cap(u32 *caps, enum pt_capabilities capability)
 
 	return (c & cd->mask) >> shift;
 }
-EXPORT_SYMBOL_GPL(intel_pt_validate_cap);
+EXPORT_SYMBOL_FOR_KVM(intel_pt_validate_cap);
 
 u32 intel_pt_validate_hw_cap(enum pt_capabilities cap)
 {
 	return intel_pt_validate_cap(pt_pmu.caps, cap);
 }
-EXPORT_SYMBOL_GPL(intel_pt_validate_hw_cap);
+EXPORT_SYMBOL_FOR_KVM(intel_pt_validate_hw_cap);
 
 static ssize_t pt_cap_show(struct device *cdev,
 			   struct device_attribute *attr,
@@ -1590,7 +1591,7 @@ void intel_pt_handle_vmx(int on)
 
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(intel_pt_handle_vmx);
+EXPORT_SYMBOL_FOR_KVM(intel_pt_handle_vmx);
 
 /*
  * PMU callbacks
diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
index 23268a188e70..d7c704ed1be9 100644
--- a/arch/x86/include/asm/kvm_types.h
+++ b/arch/x86/include/asm/kvm_types.h
@@ -10,6 +10,11 @@
 #define KVM_SUB_MODULES kvm-intel
 #else
 #undef KVM_SUB_MODULES
+/*
+ * Don't export symbols for KVM without vendor modules, as kvm.ko is built iff
+ * at least one vendor module is enabled.
+ */
+#define EXPORT_SYMBOL_FOR_KVM(symbol)
 #endif
 
 #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ca1c8b70ac44..9c29e12b84e5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -36,6 +36,7 @@
 #include <linux/dmi.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/kvm_types.h>
 
 #include <xen/xen.h>
 
@@ -2319,7 +2320,7 @@ u32 x86_msi_msg_get_destid(struct msi_msg *msg, bool extid)
 		dest |= msg->arch_addr_hi.destid_8_31 << 8;
 	return dest;
 }
-EXPORT_SYMBOL_GPL(x86_msi_msg_get_destid);
+EXPORT_SYMBOL_FOR_KVM(x86_msi_msg_get_destid);
 
 static void __init apic_bsp_up_setup(void)
 {
diff --git a/arch/x86/kernel/apic/apic_common.c b/arch/x86/kernel/apic/apic_common.c
index 9ef3be866832..2ed3b5c88c7f 100644
--- a/arch/x86/kernel/apic/apic_common.c
+++ b/arch/x86/kernel/apic/apic_common.c
@@ -4,6 +4,7 @@
  * SPDX-License-Identifier: GPL-2.0
  */
 #include <linux/irq.h>
+#include <linux/kvm_types.h>
 #include <asm/apic.h>
 
 #include "local.h"
@@ -25,7 +26,7 @@ u32 default_cpu_present_to_apicid(int mps_cpu)
 	else
 		return BAD_APICID;
 }
-EXPORT_SYMBOL_GPL(default_cpu_present_to_apicid);
+EXPORT_SYMBOL_FOR_KVM(default_cpu_present_to_apicid);
 
 /*
  * Set up the logical destination ID when the APIC operates in logical
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2ba9f2d42d8c..ad934821da1a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -3,7 +3,7 @@
 #include <linux/bitops.h>
 #include <linux/elf.h>
 #include <linux/mm.h>
-
+#include <linux/kvm_types.h>
 #include <linux/io.h>
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
@@ -1311,7 +1311,7 @@ unsigned long amd_get_dr_addr_mask(unsigned int dr)
 
 	return per_cpu(amd_dr_addr_mask[dr], smp_processor_id());
 }
-EXPORT_SYMBOL_GPL(amd_get_dr_addr_mask);
+EXPORT_SYMBOL_FOR_KVM(amd_get_dr_addr_mask);
 
 static void zenbleed_check_cpu(void *unused)
 {
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 57c1d0ed36a5..d11a7655994e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -16,6 +16,7 @@
 #include <linux/sched/smt.h>
 #include <linux/pgtable.h>
 #include <linux/bpf.h>
+#include <linux/kvm_types.h>
 
 #include <asm/spec-ctrl.h>
 #include <asm/cmdline.h>
@@ -178,7 +179,7 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
 /* Control IBPB on vCPU load */
 DEFINE_STATIC_KEY_FALSE(switch_vcpu_ibpb);
-EXPORT_SYMBOL_GPL(switch_vcpu_ibpb);
+EXPORT_SYMBOL_FOR_KVM(switch_vcpu_ibpb);
 
 /* Control CPU buffer clear before idling (halt, mwait) */
 DEFINE_STATIC_KEY_FALSE(cpu_buf_idle_clear);
@@ -197,7 +198,7 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
  * mitigation is required.
  */
 DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
-EXPORT_SYMBOL_GPL(cpu_buf_vm_clear);
+EXPORT_SYMBOL_FOR_KVM(cpu_buf_vm_clear);
 
 #undef pr_fmt
 #define pr_fmt(fmt)	"mitigations: " fmt
@@ -365,7 +366,7 @@ x86_virt_spec_ctrl(u64 guest_virt_spec_ctrl, bool setguest)
 		speculation_ctrl_update(tif);
 	}
 }
-EXPORT_SYMBOL_GPL(x86_virt_spec_ctrl);
+EXPORT_SYMBOL_FOR_KVM(x86_virt_spec_ctrl);
 
 static void x86_amd_ssb_disable(void)
 {
@@ -1031,7 +1032,7 @@ bool gds_ucode_mitigated(void)
 	return (gds_mitigation == GDS_MITIGATION_FULL ||
 		gds_mitigation == GDS_MITIGATION_FULL_LOCKED);
 }
-EXPORT_SYMBOL_GPL(gds_ucode_mitigated);
+EXPORT_SYMBOL_FOR_KVM(gds_ucode_mitigated);
 
 void update_gds_msr(void)
 {
@@ -2858,7 +2859,7 @@ void x86_spec_ctrl_setup_ap(void)
 }
 
 bool itlb_multihit_kvm_mitigation;
-EXPORT_SYMBOL_GPL(itlb_multihit_kvm_mitigation);
+EXPORT_SYMBOL_FOR_KVM(itlb_multihit_kvm_mitigation);
 
 #undef pr_fmt
 #define pr_fmt(fmt)	"L1TF: " fmt
@@ -2866,11 +2867,9 @@ EXPORT_SYMBOL_GPL(itlb_multihit_kvm_mitigation);
 /* Default mitigation for L1TF-affected CPUs */
 enum l1tf_mitigations l1tf_mitigation __ro_after_init =
 	IS_ENABLED(CONFIG_MITIGATION_L1TF) ? L1TF_MITIGATION_AUTO : L1TF_MITIGATION_OFF;
-#if IS_ENABLED(CONFIG_KVM_INTEL)
-EXPORT_SYMBOL_GPL(l1tf_mitigation);
-#endif
+EXPORT_SYMBOL_FOR_KVM(l1tf_mitigation);
 enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
-EXPORT_SYMBOL_GPL(l1tf_vmx_mitigation);
+EXPORT_SYMBOL_FOR_KVM(l1tf_vmx_mitigation);
 
 /*
  * These CPUs all support 44bits physical address space internally in the
diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
index 981f8b1f0792..dbc99a47be45 100644
--- a/arch/x86/kernel/cpu/bus_lock.c
+++ b/arch/x86/kernel/cpu/bus_lock.c
@@ -6,6 +6,7 @@
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/cpuhotplug.h>
+#include <linux/kvm_types.h>
 #include <asm/cpu_device_id.h>
 #include <asm/cmdline.h>
 #include <asm/traps.h>
@@ -289,7 +290,7 @@ bool handle_guest_split_lock(unsigned long ip)
 	force_sig_fault(SIGBUS, BUS_ADRALN, NULL);
 	return false;
 }
-EXPORT_SYMBOL_GPL(handle_guest_split_lock);
+EXPORT_SYMBOL_FOR_KVM(handle_guest_split_lock);
 
 void bus_lock_init(void)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 36271260ce07..9b41b9300330 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -7,6 +7,7 @@
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <linux/kvm_types.h>
 #include <linux/percpu.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
@@ -464,14 +465,14 @@ void cr4_update_irqsoff(unsigned long set, unsigned long clear)
 		__write_cr4(newval);
 	}
 }
-EXPORT_SYMBOL(cr4_update_irqsoff);
+EXPORT_SYMBOL_FOR_KVM(cr4_update_irqsoff);
 
 /* Read the CR4 shadow. */
 unsigned long cr4_read_shadow(void)
 {
 	return this_cpu_read(cpu_tlbstate.cr4);
 }
-EXPORT_SYMBOL_GPL(cr4_read_shadow);
+EXPORT_SYMBOL_FOR_KVM(cr4_read_shadow);
 
 void cr4_init(void)
 {
@@ -726,7 +727,7 @@ void load_direct_gdt(int cpu)
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 }
-EXPORT_SYMBOL_GPL(load_direct_gdt);
+EXPORT_SYMBOL_FOR_KVM(load_direct_gdt);
 
 /* Load a fixmap remapping of the per-cpu GDT */
 void load_fixmap_gdt(int cpu)
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 3eda7e7942e6..dc73194416ac 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -5,6 +5,7 @@
 #include <linux/freezer.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
+#include <linux/kvm_types.h>
 #include <linux/miscdevice.h>
 #include <linux/node.h>
 #include <linux/pagemap.h>
@@ -916,7 +917,7 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 	*allowed_attributes |= SGX_ATTR_PROVISIONKEY;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(sgx_set_attribute);
+EXPORT_SYMBOL_FOR_KVM(sgx_set_attribute);
 
 /* Counter to count the active SGX users */
 static int sgx_usage_count;
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index b649c0610019..8de1f1a755f2 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -5,6 +5,7 @@
  * Copyright(c) 2021 Intel Corporation.
  */
 
+#include <linux/kvm_types.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
@@ -381,7 +382,7 @@ int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 	WARN_ON_ONCE(ret);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(sgx_virt_ecreate);
+EXPORT_SYMBOL_FOR_KVM(sgx_virt_ecreate);
 
 static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
 			    void __user *secs)
@@ -450,4 +451,4 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sgx_virt_einit);
+EXPORT_SYMBOL_FOR_KVM(sgx_virt_einit);
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index c3acbd26408b..b15b97d3cb52 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -16,6 +16,7 @@
 #include <linux/firmware-map.h>
 #include <linux/sort.h>
 #include <linux/memory_hotplug.h>
+#include <linux/kvm_types.h>
 
 #include <asm/e820/api.h>
 #include <asm/setup.h>
@@ -95,7 +96,7 @@ bool e820__mapped_raw_any(u64 start, u64 end, enum e820_type type)
 {
 	return _e820__mapped_any(e820_table_firmware, start, end, type);
 }
-EXPORT_SYMBOL_GPL(e820__mapped_raw_any);
+EXPORT_SYMBOL_FOR_KVM(e820__mapped_raw_any);
 
 bool e820__mapped_any(u64 start, u64 end, enum e820_type type)
 {
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index e88eacb1b5bb..da233f20ae6f 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -18,6 +18,7 @@
 #include <uapi/asm/kvm.h>
 
 #include <linux/hardirq.h>
+#include <linux/kvm_types.h>
 #include <linux/pkeys.h>
 #include <linux/vmalloc.h>
 
@@ -276,7 +277,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 
 	return true;
 }
-EXPORT_SYMBOL_GPL(fpu_alloc_guest_fpstate);
+EXPORT_SYMBOL_FOR_KVM(fpu_alloc_guest_fpstate);
 
 void fpu_free_guest_fpstate(struct fpu_guest *gfpu)
 {
@@ -291,7 +292,7 @@ void fpu_free_guest_fpstate(struct fpu_guest *gfpu)
 	gfpu->fpstate = NULL;
 	vfree(fpstate);
 }
-EXPORT_SYMBOL_GPL(fpu_free_guest_fpstate);
+EXPORT_SYMBOL_FOR_KVM(fpu_free_guest_fpstate);
 
 /*
   * fpu_enable_guest_xfd_features - Check xfeatures against guest perm and enable
@@ -313,7 +314,7 @@ int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures)
 
 	return __xfd_enable_feature(xfeatures, guest_fpu);
 }
-EXPORT_SYMBOL_GPL(fpu_enable_guest_xfd_features);
+EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features);
 
 #ifdef CONFIG_X86_64
 void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
@@ -324,7 +325,7 @@ void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
 		xfd_update_state(guest_fpu->fpstate);
 	fpregs_unlock();
 }
-EXPORT_SYMBOL_GPL(fpu_update_guest_xfd);
+EXPORT_SYMBOL_FOR_KVM(fpu_update_guest_xfd);
 
 /**
  * fpu_sync_guest_vmexit_xfd_state - Synchronize XFD MSR and software state
@@ -348,7 +349,7 @@ void fpu_sync_guest_vmexit_xfd_state(void)
 		__this_cpu_write(xfd_state, fpstate->xfd);
 	}
 }
-EXPORT_SYMBOL_GPL(fpu_sync_guest_vmexit_xfd_state);
+EXPORT_SYMBOL_FOR_KVM(fpu_sync_guest_vmexit_xfd_state);
 #endif /* CONFIG_X86_64 */
 
 int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
@@ -390,7 +391,7 @@ int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 	fpregs_unlock();
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
+EXPORT_SYMBOL_FOR_KVM(fpu_swap_kvm_fpstate);
 
 void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
 				    unsigned int size, u64 xfeatures, u32 pkru)
@@ -409,7 +410,7 @@ void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
 		ustate->xsave.header.xfeatures = XFEATURE_MASK_FPSSE;
 	}
 }
-EXPORT_SYMBOL_GPL(fpu_copy_guest_fpstate_to_uabi);
+EXPORT_SYMBOL_FOR_KVM(fpu_copy_guest_fpstate_to_uabi);
 
 int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 				   u64 xcr0, u32 *vpkru)
@@ -439,7 +440,7 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 
 	return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
 }
-EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
+EXPORT_SYMBOL_FOR_KVM(fpu_copy_uabi_to_guest_fpstate);
 #endif /* CONFIG_KVM */
 
 void kernel_fpu_begin_mask(unsigned int kfpu_mask)
@@ -857,7 +858,7 @@ void switch_fpu_return(void)
 
 	fpregs_restore_userregs();
 }
-EXPORT_SYMBOL_GPL(switch_fpu_return);
+EXPORT_SYMBOL_FOR_KVM(switch_fpu_return);
 
 void fpregs_lock_and_load(void)
 {
@@ -892,7 +893,7 @@ void fpregs_assert_state_consistent(void)
 
 	WARN_ON_FPU(!fpregs_state_valid(fpu, smp_processor_id()));
 }
-EXPORT_SYMBOL_GPL(fpregs_assert_state_consistent);
+EXPORT_SYMBOL_FOR_KVM(fpregs_assert_state_consistent);
 #endif
 
 void fpregs_mark_activate(void)
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 28e4fd65c9da..48113c5193aa 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -8,6 +8,7 @@
 #include <linux/compat.h>
 #include <linux/cpu.h>
 #include <linux/mman.h>
+#include <linux/kvm_types.h>
 #include <linux/nospec.h>
 #include <linux/pkeys.h>
 #include <linux/seq_file.h>
@@ -1058,7 +1059,7 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
 
 	return __raw_xsave_addr(xsave, xfeature_nr);
 }
-EXPORT_SYMBOL_GPL(get_xsave_addr);
+EXPORT_SYMBOL_FOR_KVM(get_xsave_addr);
 
 /*
  * Given an xstate feature nr, calculate where in the xsave buffer the state is.
@@ -1482,7 +1483,7 @@ void fpstate_clear_xstate_component(struct fpstate *fpstate, unsigned int xfeatu
 	if (addr)
 		memset(addr, 0, xstate_sizes[xfeature]);
 }
-EXPORT_SYMBOL_GPL(fpstate_clear_xstate_component);
+EXPORT_SYMBOL_FOR_KVM(fpstate_clear_xstate_component);
 #endif
 
 #ifdef CONFIG_X86_64
@@ -1818,7 +1819,7 @@ u64 xstate_get_guest_group_perm(void)
 {
 	return xstate_get_group_perm(true);
 }
-EXPORT_SYMBOL_GPL(xstate_get_guest_group_perm);
+EXPORT_SYMBOL_FOR_KVM(xstate_get_guest_group_perm);
 
 /**
  * fpu_xstate_prctl - xstate permission operations
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index b01644c949b2..f846c15f21ca 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -24,6 +24,7 @@
 #include <linux/percpu.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
+#include <linux/kvm_types.h>
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
@@ -489,7 +490,7 @@ void hw_breakpoint_restore(void)
 	set_debugreg(DR6_RESERVED, 6);
 	set_debugreg(__this_cpu_read(cpu_dr7), 7);
 }
-EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
+EXPORT_SYMBOL_FOR_KVM(hw_breakpoint_restore);
 
 /*
  * Handle debug exception notifications.
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 10721a125226..86f4e574de02 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -12,6 +12,7 @@
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/irq.h>
+#include <linux/kvm_types.h>
 
 #include <asm/irq_stack.h>
 #include <asm/apic.h>
@@ -361,7 +362,7 @@ void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
 		synchronize_rcu();
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
+EXPORT_SYMBOL_FOR_KVM(kvm_set_posted_intr_wakeup_handler);
 
 /*
  * Handler for POSTED_INTERRUPT_VECTOR.
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b67d7c59dca0..204765004c72 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -29,6 +29,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/cc_platform.h>
 #include <linux/efi.h>
+#include <linux/kvm_types.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -162,7 +163,7 @@ void kvm_async_pf_task_wait_schedule(u32 token)
 	}
 	finish_swait(&n.wq, &wait);
 }
-EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait_schedule);
+EXPORT_SYMBOL_FOR_KVM(kvm_async_pf_task_wait_schedule);
 
 static void apf_task_wake_one(struct kvm_task_sleep_node *n)
 {
@@ -253,7 +254,7 @@ noinstr u32 kvm_read_and_reset_apf_flags(void)
 
 	return flags;
 }
-EXPORT_SYMBOL_GPL(kvm_read_and_reset_apf_flags);
+EXPORT_SYMBOL_FOR_KVM(kvm_read_and_reset_apf_flags);
 
 noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 {
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index be93ec7255bf..3d239ed12744 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/atomic.h>
 #include <linux/sched/clock.h>
+#include <linux/kvm_types.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/traps.h>
@@ -613,9 +614,7 @@ DEFINE_IDTENTRY_RAW(exc_nmi_kvm_vmx)
 {
 	exc_nmi(regs);
 }
-#if IS_MODULE(CONFIG_KVM_INTEL)
-EXPORT_SYMBOL_GPL(asm_exc_nmi_kvm_vmx);
-#endif
+EXPORT_SYMBOL_FOR_KVM(asm_exc_nmi_kvm_vmx);
 #endif
 
 #ifdef CONFIG_NMI_CHECK_CPU
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 52a5c03c353c..432c0a004c60 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -30,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/export.h>
+#include <linux/kvm_types.h>
 #include <linux/ptrace.h>
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
@@ -303,9 +304,7 @@ void current_save_fsgs(void)
 	save_fsgs(current);
 	local_irq_restore(flags);
 }
-#if IS_ENABLED(CONFIG_KVM)
-EXPORT_SYMBOL_GPL(current_save_fsgs);
-#endif
+EXPORT_SYMBOL_FOR_KVM(current_save_fsgs);
 
 static __always_inline void loadseg(enum which_selector which,
 				    unsigned short sel)
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 964f6b0a3d68..6032fa9ec753 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -13,6 +13,7 @@
 #include <linux/objtool.h>
 #include <linux/pgtable.h>
 #include <linux/kexec.h>
+#include <linux/kvm_types.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
@@ -541,7 +542,7 @@ void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
 
 	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
 }
-EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
+EXPORT_SYMBOL_FOR_KVM(cpu_emergency_register_virt_callback);
 
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
 {
@@ -551,7 +552,7 @@ void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
 	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
 	synchronize_rcu();
 }
-EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
+EXPORT_SYMBOL_FOR_KVM(cpu_emergency_unregister_virt_callback);
 
 /*
  * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 87e749106dda..7d3e13e14eab 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -11,6 +11,7 @@
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
 #include <linux/clocksource.h>
+#include <linux/kvm_types.h>
 #include <linux/percpu.h>
 #include <linux/timex.h>
 #include <linux/static_key.h>
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index c5c60d07308c..824664c0ecbd 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -2,6 +2,7 @@
 #include <asm/paravirt.h>
 #include <linux/smp.h>
 #include <linux/export.h>
+#include <linux/kvm_types.h>
 
 static void __wbinvd(void *dummy)
 {
@@ -12,7 +13,7 @@ void wbinvd_on_cpu(int cpu)
 {
 	smp_call_function_single(cpu, __wbinvd, NULL, 1);
 }
-EXPORT_SYMBOL(wbinvd_on_cpu);
+EXPORT_SYMBOL_FOR_KVM(wbinvd_on_cpu);
 
 void wbinvd_on_all_cpus(void)
 {
@@ -24,7 +25,7 @@ void wbinvd_on_cpus_mask(struct cpumask *cpus)
 {
 	on_each_cpu_mask(cpus, __wbinvd, NULL, 1);
 }
-EXPORT_SYMBOL_GPL(wbinvd_on_cpus_mask);
+EXPORT_SYMBOL_FOR_KVM(wbinvd_on_cpus_mask);
 
 static void __wbnoinvd(void *dummy)
 {
@@ -35,10 +36,10 @@ void wbnoinvd_on_all_cpus(void)
 {
 	on_each_cpu(__wbnoinvd, NULL, 1);
 }
-EXPORT_SYMBOL_GPL(wbnoinvd_on_all_cpus);
+EXPORT_SYMBOL_FOR_KVM(wbnoinvd_on_all_cpus);
 
 void wbnoinvd_on_cpus_mask(struct cpumask *cpus)
 {
 	on_each_cpu_mask(cpus, __wbnoinvd, NULL, 1);
 }
-EXPORT_SYMBOL_GPL(wbnoinvd_on_cpus_mask);
+EXPORT_SYMBOL_FOR_KVM(wbnoinvd_on_cpus_mask);
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 4ef7c6dcbea6..dfdd1da89f36 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/export.h>
+#include <linux/kvm_types.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <asm/msr.h>
@@ -103,7 +104,7 @@ int msr_set_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, true);
 }
-EXPORT_SYMBOL_GPL(msr_set_bit);
+EXPORT_SYMBOL_FOR_KVM(msr_set_bit);
 
 /**
  * msr_clear_bit - Clear @bit in a MSR @msr.
@@ -119,7 +120,7 @@ int msr_clear_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, false);
 }
-EXPORT_SYMBOL_GPL(msr_clear_bit);
+EXPORT_SYMBOL_FOR_KVM(msr_clear_bit);
 
 #ifdef CONFIG_TRACEPOINTS
 void do_trace_write_msr(u32 msr, u64 val, int failed)
diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index b68200a0e0c6..8a3d9722f602 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -42,6 +42,7 @@
 #include <linux/highmem.h>
 #include <linux/fs.h>
 #include <linux/rbtree.h>
+#include <linux/kvm_types.h>
 
 #include <asm/cpu_device_id.h>
 #include <asm/cacheflush.h>
@@ -697,7 +698,7 @@ bool pat_pfn_immune_to_uc_mtrr(unsigned long pfn)
 	       cm == _PAGE_CACHE_MODE_UC_MINUS ||
 	       cm == _PAGE_CACHE_MODE_WC;
 }
-EXPORT_SYMBOL_GPL(pat_pfn_immune_to_uc_mtrr);
+EXPORT_SYMBOL_FOR_KVM(pat_pfn_immune_to_uc_mtrr);
 
 /**
  * memtype_reserve_io - Request a memory type mapping for a region of memory
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5d221709353e..f5b93e01e347 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -12,6 +12,7 @@
 #include <linux/task_work.h>
 #include <linux/mmu_notifier.h>
 #include <linux/mmu_context.h>
+#include <linux/kvm_types.h>
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -1582,7 +1583,7 @@ unsigned long __get_current_cr3_fast(void)
 	VM_BUG_ON(cr3 != __read_cr3());
 	return cr3;
 }
-EXPORT_SYMBOL_GPL(__get_current_cr3_fast);
+EXPORT_SYMBOL_FOR_KVM(__get_current_cr3_fast);
 
 /*
  * Flush one page in the kernel mapping
@@ -1723,7 +1724,7 @@ void __flush_tlb_all(void)
 		flush_tlb_local();
 	}
 }
-EXPORT_SYMBOL_GPL(__flush_tlb_all);
+EXPORT_SYMBOL_FOR_KVM(__flush_tlb_all);
 
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index eac403248462..5ce4ebe99774 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -29,6 +29,7 @@
 #include <linux/acpi.h>
 #include <linux/suspend.h>
 #include <linux/idr.h>
+#include <linux/kvm_types.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
 #include <asm/msr-index.h>
@@ -181,7 +182,7 @@ int tdx_cpu_enable(void)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(tdx_cpu_enable);
+EXPORT_SYMBOL_FOR_KVM(tdx_cpu_enable);
 
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
@@ -662,7 +663,7 @@ void tdx_quirk_reset_page(struct page *page)
 {
 	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
 }
-EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
+EXPORT_SYMBOL_FOR_KVM(tdx_quirk_reset_page);
 
 static void tdmr_quirk_reset_pamt(struct tdmr_info *tdmr)
 {
@@ -1216,7 +1217,7 @@ int tdx_enable(void)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdx_enable);
+EXPORT_SYMBOL_FOR_KVM(tdx_enable);
 
 static bool is_pamt_page(unsigned long phys)
 {
@@ -1477,13 +1478,13 @@ const struct tdx_sys_info *tdx_get_sysinfo(void)
 
 	return p;
 }
-EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
+EXPORT_SYMBOL_FOR_KVM(tdx_get_sysinfo);
 
 u32 tdx_get_nr_guest_keyids(void)
 {
 	return tdx_nr_guest_keyids;
 }
-EXPORT_SYMBOL_GPL(tdx_get_nr_guest_keyids);
+EXPORT_SYMBOL_FOR_KVM(tdx_get_nr_guest_keyids);
 
 int tdx_guest_keyid_alloc(void)
 {
@@ -1491,13 +1492,13 @@ int tdx_guest_keyid_alloc(void)
 			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
 			       GFP_KERNEL);
 }
-EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
+EXPORT_SYMBOL_FOR_KVM(tdx_guest_keyid_alloc);
 
 void tdx_guest_keyid_free(unsigned int keyid)
 {
 	ida_free(&tdx_guest_keyid_pool, keyid);
 }
-EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
+EXPORT_SYMBOL_FOR_KVM(tdx_guest_keyid_free);
 
 static inline u64 tdx_tdr_pa(struct tdx_td *td)
 {
@@ -1521,7 +1522,7 @@ noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 
 	return __seamcall_dirty_cache(__seamcall_saved_ret, TDH_VP_ENTER, args);
 }
-EXPORT_SYMBOL_GPL(tdh_vp_enter);
+EXPORT_SYMBOL_FOR_KVM(tdh_vp_enter);
 
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 {
@@ -1533,7 +1534,7 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 	tdx_clflush_page(tdcs_page);
 	return seamcall(TDH_MNG_ADDCX, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_mng_addcx);
+EXPORT_SYMBOL_FOR_KVM(tdh_mng_addcx);
 
 u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2)
 {
@@ -1553,7 +1554,7 @@ u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_mem_page_add);
+EXPORT_SYMBOL_FOR_KVM(tdh_mem_page_add);
 
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
 {
@@ -1572,7 +1573,7 @@ u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_mem_sept_add);
+EXPORT_SYMBOL_FOR_KVM(tdh_mem_sept_add);
 
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 {
@@ -1584,7 +1585,7 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 	tdx_clflush_page(tdcx_page);
 	return seamcall(TDH_VP_ADDCX, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_vp_addcx);
+EXPORT_SYMBOL_FOR_KVM(tdh_vp_addcx);
 
 u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
 {
@@ -1603,7 +1604,7 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
+EXPORT_SYMBOL_FOR_KVM(tdh_mem_page_aug);
 
 u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, int level, u64 *ext_err1, u64 *ext_err2)
 {
@@ -1620,7 +1621,7 @@ u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, int level, u64 *ext_err1, u6
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_mem_range_block);
+EXPORT_SYMBOL_FOR_KVM(tdh_mem_range_block);
 
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
@@ -1630,7 +1631,7 @@ u64 tdh_mng_key_config(struct tdx_td *td)
 
 	return seamcall(TDH_MNG_KEY_CONFIG, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_mng_key_config);
+EXPORT_SYMBOL_FOR_KVM(tdh_mng_key_config);
 
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid)
 {
@@ -1642,7 +1643,7 @@ u64 tdh_mng_create(struct tdx_td *td, u16 hkid)
 	tdx_clflush_page(td->tdr_page);
 	return seamcall(TDH_MNG_CREATE, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_mng_create);
+EXPORT_SYMBOL_FOR_KVM(tdh_mng_create);
 
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
 {
@@ -1654,7 +1655,7 @@ u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
 	tdx_clflush_page(vp->tdvpr_page);
 	return seamcall(TDH_VP_CREATE, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_vp_create);
+EXPORT_SYMBOL_FOR_KVM(tdh_vp_create);
 
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 {
@@ -1671,7 +1672,7 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_mng_rd);
+EXPORT_SYMBOL_FOR_KVM(tdh_mng_rd);
 
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2)
 {
@@ -1688,7 +1689,7 @@ u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_mr_extend);
+EXPORT_SYMBOL_FOR_KVM(tdh_mr_extend);
 
 u64 tdh_mr_finalize(struct tdx_td *td)
 {
@@ -1698,7 +1699,7 @@ u64 tdh_mr_finalize(struct tdx_td *td)
 
 	return seamcall(TDH_MR_FINALIZE, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_mr_finalize);
+EXPORT_SYMBOL_FOR_KVM(tdh_mr_finalize);
 
 u64 tdh_vp_flush(struct tdx_vp *vp)
 {
@@ -1708,7 +1709,7 @@ u64 tdh_vp_flush(struct tdx_vp *vp)
 
 	return seamcall(TDH_VP_FLUSH, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_vp_flush);
+EXPORT_SYMBOL_FOR_KVM(tdh_vp_flush);
 
 u64 tdh_mng_vpflushdone(struct tdx_td *td)
 {
@@ -1718,7 +1719,7 @@ u64 tdh_mng_vpflushdone(struct tdx_td *td)
 
 	return seamcall(TDH_MNG_VPFLUSHDONE, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_mng_vpflushdone);
+EXPORT_SYMBOL_FOR_KVM(tdh_mng_vpflushdone);
 
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
@@ -1728,7 +1729,7 @@ u64 tdh_mng_key_freeid(struct tdx_td *td)
 
 	return seamcall(TDH_MNG_KEY_FREEID, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_mng_key_freeid);
+EXPORT_SYMBOL_FOR_KVM(tdh_mng_key_freeid);
 
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err)
 {
@@ -1744,7 +1745,7 @@ u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_mng_init);
+EXPORT_SYMBOL_FOR_KVM(tdh_mng_init);
 
 u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data)
 {
@@ -1761,7 +1762,7 @@ u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_vp_rd);
+EXPORT_SYMBOL_FOR_KVM(tdh_vp_rd);
 
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask)
 {
@@ -1774,7 +1775,7 @@ u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask)
 
 	return seamcall(TDH_VP_WR, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_vp_wr);
+EXPORT_SYMBOL_FOR_KVM(tdh_vp_wr);
 
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 {
@@ -1787,7 +1788,7 @@ u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 	/* apicid requires version == 1. */
 	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
 }
-EXPORT_SYMBOL_GPL(tdh_vp_init);
+EXPORT_SYMBOL_FOR_KVM(tdh_vp_init);
 
 /*
  * TDX ABI defines output operands as PT, OWNER and SIZE. These are TDX defined fomats.
@@ -1809,7 +1810,7 @@ u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
+EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_reclaim);
 
 u64 tdh_mem_track(struct tdx_td *td)
 {
@@ -1819,7 +1820,7 @@ u64 tdh_mem_track(struct tdx_td *td)
 
 	return seamcall(TDH_MEM_TRACK, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_mem_track);
+EXPORT_SYMBOL_FOR_KVM(tdh_mem_track);
 
 u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u64 *ext_err2)
 {
@@ -1836,7 +1837,7 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tdh_mem_page_remove);
+EXPORT_SYMBOL_FOR_KVM(tdh_mem_page_remove);
 
 u64 tdh_phymem_cache_wb(bool resume)
 {
@@ -1846,7 +1847,7 @@ u64 tdh_phymem_cache_wb(bool resume)
 
 	return seamcall(TDH_PHYMEM_CACHE_WB, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
+EXPORT_SYMBOL_FOR_KVM(tdh_phymem_cache_wb);
 
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 {
@@ -1856,7 +1857,7 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
+EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_wbinvd_tdr);
 
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 {
@@ -1866,7 +1867,7 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
-EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
+EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_wbinvd_hkid);
 
 #ifdef CONFIG_KEXEC_CORE
 void tdx_cpu_flush_cache_for_kexec(void)
@@ -1884,5 +1885,5 @@ void tdx_cpu_flush_cache_for_kexec(void)
 	wbinvd();
 	this_cpu_write(cache_state_incoherent, false);
 }
-EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache_for_kexec);
+EXPORT_SYMBOL_FOR_KVM(tdx_cpu_flush_cache_for_kexec);
 #endif
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 490464c205b4..a568d8e6f4e8 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -11,8 +11,22 @@
 #ifdef KVM_SUB_MODULES
 #define EXPORT_SYMBOL_FOR_KVM_INTERNAL(symbol) \
 	EXPORT_SYMBOL_FOR_MODULES(symbol, __stringify(KVM_SUB_MODULES))
+#define EXPORT_SYMBOL_FOR_KVM(symbol) \
+	EXPORT_SYMBOL_FOR_MODULES(symbol, "kvm," __stringify(KVM_SUB_MODULES))
 #else
 #define EXPORT_SYMBOL_FOR_KVM_INTERNAL(symbol)
+/*
+ * Allow architectures to provide a custom EXPORT_SYMBOL_FOR_KVM, but only
+ * if there are no submodules, e.g. to allow suppressing exports if KVM=m, but
+ * kvm.ko won't actually be built (due to lack of at least one submodule).
+ */
+#ifndef EXPORT_SYMBOL_FOR_KVM
+#if IS_MODULE(CONFIG_KVM)
+#define EXPORT_SYMBOL_FOR_KVM(symbol) EXPORT_SYMBOL_FOR_MODULES(symbol, "kvm")
+#else
+#define EXPORT_SYMBOL_FOR_KVM(symbol)
+#endif /* IS_MODULE(CONFIG_KVM) */
+#endif /* EXPORT_SYMBOL_FOR_KVM */
 #endif
 
 #ifndef __ASSEMBLER__
-- 
2.51.2.1041.gc1ab5b90ca-goog


