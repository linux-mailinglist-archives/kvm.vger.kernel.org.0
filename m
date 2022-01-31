Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F7A4A3E2B
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 08:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357911AbiAaHZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 02:25:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:60936 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbiAaHZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 02:25:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643613908; x=1675149908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=twoB6SdjOGgoaMl2rsOQ5CCAGv7qBwrmwSxksWBeIHM=;
  b=IuD0pan+qq4F1CnFyeYF3ro5rZJ8u10kF4W2kXrFIyqO5DRmlpUSIe57
   upQ9HNVppBN+Yu+ThDJOnQi7lHOE5HY9HmRfivdWcx5+567b3qt32tX+A
   uKv29EnCBUyOGJA6HHCusP+K45hM+l17+N9ShTguyF/Nu1W8nAV7WYjC4
   WwhA4NxDe+OFbsI3dXPSUA7XakNi+VIsxIqp/CekSNNnSkGvOrDccQU+D
   vSNA2YP5QsT/4OkVCshLzCU224NThq/mqrahIcn57PI4mFTHE0q9NNJkc
   iyQsatHv/xElHsjFeBnQ6YE3YjdDOlNpZTGY7b/KzcwLvFEztl0KHcWQ9
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="247367032"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="247367032"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2022 23:25:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="768515194"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2022 23:25:03 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: [PATCH 2/5] x86: Share definition of __is_canonical_address()
Date:   Mon, 31 Jan 2022 09:24:50 +0200
Message-Id: <20220131072453.2839535-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131072453.2839535-1-adrian.hunter@intel.com>
References: <20220131072453.2839535-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reduce code duplication by moving canonical address code to a common header
file.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/events/intel/pt.c  | 14 ++------------
 arch/x86/include/asm/page.h | 10 ++++++++++
 arch/x86/kvm/emulate.c      |  4 ++--
 arch/x86/kvm/x86.c          |  2 +-
 arch/x86/kvm/x86.h          |  7 +------
 arch/x86/mm/maccess.c       |  7 +------
 6 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 4443de56a2d5..4015c1364463 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1366,20 +1366,10 @@ static void pt_addr_filters_fini(struct perf_event *event)
 }
 
 #ifdef CONFIG_X86_64
-static u64 canonical_address(u64 vaddr, u8 vaddr_bits)
-{
-	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
-}
-
-static u64 is_canonical_address(u64 vaddr, u8 vaddr_bits)
-{
-	return canonical_address(vaddr, vaddr_bits) == vaddr;
-}
-
 /* Clamp to a canonical address greater-than-or-equal-to the address given */
 static u64 clamp_to_ge_canonical_addr(u64 vaddr, u8 vaddr_bits)
 {
-	return is_canonical_address(vaddr, vaddr_bits) ?
+	return __is_canonical_address(vaddr, vaddr_bits) ?
 	       vaddr :
 	       -BIT_ULL(vaddr_bits - 1);
 }
@@ -1387,7 +1377,7 @@ static u64 clamp_to_ge_canonical_addr(u64 vaddr, u8 vaddr_bits)
 /* Clamp to a canonical address less-than-or-equal-to the address given */
 static u64 clamp_to_le_canonical_addr(u64 vaddr, u8 vaddr_bits)
 {
-	return is_canonical_address(vaddr, vaddr_bits) ?
+	return __is_canonical_address(vaddr, vaddr_bits) ?
 	       vaddr :
 	       BIT_ULL(vaddr_bits - 1) - 1;
 }
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 4d5810c8fab7..9cc82f305f4b 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -71,6 +71,16 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 extern bool __virt_addr_valid(unsigned long kaddr);
 #define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
 
+static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
+}
+
+static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return __canonical_address(vaddr, vaddr_bits) == vaddr;
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #include <asm-generic/memory_model.h>
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5719d8cfdbd9..40da8c7f3019 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -665,7 +665,7 @@ static inline u8 ctxt_virt_addr_bits(struct x86_emulate_ctxt *ctxt)
 static inline bool emul_is_noncanonical_address(u64 la,
 						struct x86_emulate_ctxt *ctxt)
 {
-	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
+	return !__is_canonical_address(la, ctxt_virt_addr_bits(ctxt));
 }
 
 /*
@@ -715,7 +715,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	case X86EMUL_MODE_PROT64:
 		*linear = la;
 		va_bits = ctxt_virt_addr_bits(ctxt);
-		if (get_canonical(la, va_bits) != la)
+		if (!__is_canonical_address(la, va_bits))
 			goto bad;
 
 		*max_size = min_t(u64, ~0u, (1ull << va_bits) - la);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e43d756312f..af15a7065aa7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1735,7 +1735,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * value, and that something deterministic happens if the guest
 		 * invokes 64-bit SYSENTER.
 		 */
-		data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
+		data = __canonical_address(data, vcpu_virt_addr_bits(vcpu));
 		break;
 	case MSR_TSC_AUX:
 		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 635b75f9e145..fc4b68ab8d71 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -211,14 +211,9 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
 	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
 }
 
-static inline u64 get_canonical(u64 la, u8 vaddr_bits)
-{
-	return ((int64_t)la << (64 - vaddr_bits)) >> (64 - vaddr_bits);
-}
-
 static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
 {
-	return get_canonical(la, vcpu_virt_addr_bits(vcpu)) != la;
+	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
 }
 
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index 92ec176a7293..5a53c2cc169c 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -4,11 +4,6 @@
 #include <linux/kernel.h>
 
 #ifdef CONFIG_X86_64
-static __always_inline u64 canonical_address(u64 vaddr, u8 vaddr_bits)
-{
-	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
-}
-
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
 {
 	unsigned long vaddr = (unsigned long)unsafe_src;
@@ -19,7 +14,7 @@ bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
 	 * we also need to include the userspace guard page.
 	 */
 	return vaddr >= TASK_SIZE_MAX + PAGE_SIZE &&
-	       canonical_address(vaddr, boot_cpu_data.x86_virt_bits) == vaddr;
+	       __is_canonical_address(vaddr, boot_cpu_data.x86_virt_bits);
 }
 #else
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
-- 
2.25.1

