Return-Path: <kvm+bounces-3240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B872801BF2
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:56:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5246C2812B7
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A4B14AA0;
	Sat,  2 Dec 2023 09:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jQW+ry6G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83C2D50;
	Sat,  2 Dec 2023 01:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510987; x=1733046987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=nTuWdwSlGx9t9K0jy24gxhIhSwr530ozUXC9RhUGrZc=;
  b=jQW+ry6GfZlgqpJEaOZOqoqp5zhtRugU00GSigD/XsDp+yYE7vDPOwUU
   49Ptf25Sghii6ngyEhhm4MUR2KKThQK2hpLX+B/FdHBTqSPHdzgX6dQgg
   AwC3IGiPclDsCbDisTpzR8n9KlNt8OAWZkkHVS1Ti/qZgR0tM5CYcDJPu
   ehWq1v3ecNuvHlFOxr5nRldFNc+ilDKqtoVspeVLLiVwgr+kd/69F9RtN
   AYc6C1sR0wx94Mi4zFyJk9t2JT0qQbQTu/7PpJDGxpZOJVkcJk/CEcQhO
   RCbFJubCbtJqMhog/lHWBrXPNAwrpFnbbxfd2iQCvIkSmMx0lpGSpy6pV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="625650"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="625650"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:56:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="719781015"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="719781015"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:56:22 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 24/42] KVM: x86/mmu: Move bit SPTE_MMU_PRESENT from bit 11 to bit 59
Date: Sat,  2 Dec 2023 17:27:27 +0800
Message-Id: <20231202092727.14888-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add a config CONFIG_HAVE_KVM_MMU_PRESENT_HIGH to support locating
SPTE_MMU_PRESENT bit from bit 11 to bit 59 and mark bit 11 as reserved 0.

Though locating SPTE_MMU_PRESENT bit at low bit 11 has lower footprint,
sometimes it's not allowed for bit 11 to be set, e.g.
when KVM's TDP is exported and shared to IOMMU as stage 2 page tables, bit
11 must be reserved as 0 in Intel vt-d.

For the 19 bits MMIO GEN masks,
w/o CONFIG_HAVE_KVM_MMU_PRESENT_HIGH, it's divided into 2 parts,
Low:	bit 3 - 10
High:	bit 52 - 62

w/ CONFIG_HAVE_KVM_MMU_PRESENT_HIGH, it's divided into 3 parts,
Low:	bit 3 - 11
Mid:	bit 52 - 58
High:	bit 60 - 62

It is ok for MMIO GEN mask to take bit 11 because MMIO GEN mask is for
generation info of emulated MMIOs and therefore will not be directly
accessed by Intel vt-d hardware.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c  |  7 ++++
 arch/x86/kvm/mmu/spte.c |  3 ++
 arch/x86/kvm/mmu/spte.h | 77 ++++++++++++++++++++++++++++++++++++-----
 virt/kvm/Kconfig        |  3 ++
 4 files changed, 81 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c57e181bba21b..69af78e508197 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4926,6 +4926,13 @@ static void reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 					    reserved_hpa_bits(), false,
 					    max_huge_page_level);
 
+	if (IS_ENABLED(CONFIG_HAVE_KVM_MMU_PRESENT_HIGH)) {
+		for (i = PT64_ROOT_MAX_LEVEL; --i >= 0;) {
+			shadow_zero_check->rsvd_bits_mask[0][i] |= rsvd_bits(11, 11);
+			shadow_zero_check->rsvd_bits_mask[1][i] |= rsvd_bits(11, 11);
+		}
+	}
+
 	if (!shadow_me_mask)
 		return;
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c99..179156cd995df 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -64,6 +64,9 @@ static u64 generation_mmio_spte_mask(u64 gen)
 	WARN_ON_ONCE(gen & ~MMIO_SPTE_GEN_MASK);
 
 	mask = (gen << MMIO_SPTE_GEN_LOW_SHIFT) & MMIO_SPTE_GEN_LOW_MASK;
+#ifdef CONFIG_HAVE_KVM_MMU_PRESENT_HIGH
+	mask |= (gen << MMIO_SPTE_GEN_MID_SHIFT) & MMIO_SPTE_GEN_MID_MASK;
+#endif
 	mask |= (gen << MMIO_SPTE_GEN_HIGH_SHIFT) & MMIO_SPTE_GEN_HIGH_MASK;
 	return mask;
 }
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a129951c9a885..b88b686a4ecbc 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -7,13 +7,20 @@
 #include "mmu_internal.h"
 
 /*
- * A MMU present SPTE is backed by actual memory and may or may not be present
- * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
- * is ignored by all flavors of SPTEs and checking a low bit often generates
- * better code than for a high bit, e.g. 56+.  MMU present checks are pervasive
- * enough that the improved code generation is noticeable in KVM's footprint.
- */
+* A MMU present SPTE is backed by actual memory and may or may not be present
+* in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
+* is ignored by all flavors of SPTEs and checking a low bit often generates
+* better code than for a high bit, e.g. 56+.  MMU present checks are pervasive
+* enough that the improved code generation is noticeable in KVM's footprint.
+* However, sometimes it's desired to have present bit in high bits. e.g.
+* if a KVM TDP is exported  to IOMMU side, bit 11 could be a reserved bit in
+* IOMMU side. Add a config to decide MMU present bit is at bit 11 or bit 59.
+*/
+#ifdef CONFIG_HAVE_KVM_MMU_PRESENT_HIGH
+#define SPTE_MMU_PRESENT_MASK		BIT_ULL(59)
+#else
 #define SPTE_MMU_PRESENT_MASK		BIT_ULL(11)
+#endif
 
 /*
  * TDP SPTES (more specifically, EPT SPTEs) may not have A/D bits, and may also
@@ -111,19 +118,66 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
  * checking for MMIO spte cache hits.
  */
 
+#ifdef CONFIG_HAVE_KVM_MMU_PRESENT_HIGH
+
 #define MMIO_SPTE_GEN_LOW_START		3
-#define MMIO_SPTE_GEN_LOW_END		10
+#define MMIO_SPTE_GEN_LOW_END		11
+#define MMIO_SPTE_GEN_MID_START		52
+#define MMIO_SPTE_GEN_MID_END		58
+#define MMIO_SPTE_GEN_HIGH_START	60
+#define MMIO_SPTE_GEN_HIGH_END		62
+#define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
+						    MMIO_SPTE_GEN_LOW_START)
+#define MMIO_SPTE_GEN_MID_MASK		GENMASK_ULL(MMIO_SPTE_GEN_MID_END, \
+						    MMIO_SPTE_GEN_MID_START)
+#define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
+						    MMIO_SPTE_GEN_HIGH_START)
+static_assert(!(SPTE_MMU_PRESENT_MASK &
+		(MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_MID_MASK |
+		 MMIO_SPTE_GEN_HIGH_MASK)));
+/*
+ * The SPTE MMIO mask must NOT overlap the MMIO generation bits or the
+ * MMU-present bit.  The generation obviously co-exists with the magic MMIO
+ * mask/value, and MMIO SPTEs are considered !MMU-present.
+ *
+ * The SPTE MMIO mask is allowed to use hardware "present" bits (i.e. all EPT
+ * RWX bits), all physical address bits (legal PA bits are used for "fast" MMIO
+ * and so they're off-limits for generation; additional checks ensure the mask
+ * doesn't overlap legal PA bits), and bit 63 (carved out for future usage).
+ */
+#define SPTE_MMIO_ALLOWED_MASK (BIT_ULL(63) | GENMASK_ULL(51, 12) | GENMASK_ULL(2, 0))
+static_assert(!(SPTE_MMIO_ALLOWED_MASK &
+		(SPTE_MMU_PRESENT_MASK | MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_MID_MASK |
+		 MMIO_SPTE_GEN_HIGH_MASK)));
+
+#define MMIO_SPTE_GEN_LOW_BITS		(MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
+#define MMIO_SPTE_GEN_MID_BITS		(MMIO_SPTE_GEN_MID_END - MMIO_SPTE_GEN_MID_START + 1)
+#define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
 
+/* remember to adjust the comment above as well if you change these */
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_MID_BITS == 7 &&
+	      MMIO_SPTE_GEN_HIGH_BITS == 3);
+
+#define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
+#define MMIO_SPTE_GEN_MID_SHIFT		(MMIO_SPTE_GEN_MID_START - MMIO_SPTE_GEN_LOW_BITS)
+#define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_MID_BITS - \
+					MMIO_SPTE_GEN_LOW_BITS)
+
+#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + \
+					MMIO_SPTE_GEN_MID_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
+
+#else /* !CONFIG_HAVE_KVM_MMU_PRESENT_HIGH */
+
+#define MMIO_SPTE_GEN_LOW_START		3
+#define MMIO_SPTE_GEN_LOW_END		10
 #define MMIO_SPTE_GEN_HIGH_START	52
 #define MMIO_SPTE_GEN_HIGH_END		62
-
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 						    MMIO_SPTE_GEN_LOW_START)
 #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 						    MMIO_SPTE_GEN_HIGH_START)
 static_assert(!(SPTE_MMU_PRESENT_MASK &
 		(MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
-
 /*
  * The SPTE MMIO mask must NOT overlap the MMIO generation bits or the
  * MMU-present bit.  The generation obviously co-exists with the magic MMIO
@@ -149,6 +203,8 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
+#endif /* #ifdef CONFIG_HAVE_KVM_MMU_PRESENT_HIGH */
+
 extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
@@ -465,6 +521,9 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	u64 gen;
 
 	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_SHIFT;
+#ifdef CONFIG_HAVE_KVM_MMU_PRESENT_HIGH
+	gen |= (spte & MMIO_SPTE_GEN_MID_MASK) >> MMIO_SPTE_GEN_MID_SHIFT;
+#endif
 	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_SHIFT;
 	return gen;
 }
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 63b5d55c84e95..b00f9f5180292 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -95,3 +95,6 @@ config KVM_GENERIC_HARDWARE_ENABLING
 
 config HAVE_KVM_EXPORTED_TDP
        bool
+
+config HAVE_KVM_MMU_PRESENT_HIGH
+       bool
-- 
2.17.1


