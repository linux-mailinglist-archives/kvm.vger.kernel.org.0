Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2424CDF5D
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiCDUdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiCDUcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:32:18 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB2F1EE240;
        Fri,  4 Mar 2022 12:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646425885; x=1677961885;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t3JvtRKzRctKAzxFfSKBaJsXj6JqRo2KEZrS5ZZ9DSk=;
  b=C8LdkjTtZOUTxs/GInjt7dw4eh+wbpP2Z52AQml4kr1fSthXP4E/HIQS
   bXgcSEeFPNMS2S4zq7k0Z0+SpIVAvZSxX6GyVM8X138eYqvNfnrJKGoWQ
   ELHBnS7Kyt/7Q2HmMewPQnK1HlzfYGu2KfMsprIqdERZiQ+liJ0FBjwjg
   IXRsIJxt+IguDhff1ru4a5ROYrNq21ZWHhO8dxH7HZgEZhVakTqPAJlqN
   tWavysjFGb9YmKK9sE34GaTCqNmDjil0Hfv40ZTy9QE6iNYbFvdiNHD32
   sB67E5fo/n2d03cQ/JEGwf91KhXcfdBupF8+xU4KHI09e7qo4uYDFWHZF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251624221"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251624221"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:26 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344393"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:26 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 053/104] KVM: x86/mmu: steal software usable bit for EPT to represent shared page
Date:   Fri,  4 Mar 2022 11:49:09 -0800
Message-Id: <028675e255cb2a23186ebc7a94c06a47375c6883.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

With TDX, all GFNs are private at guest boot time.  At run time guest TD
can explicitly change it to shared from private or vice-versa by MapGPA
hypercall.  If it's specified, the given GFN can't be used as otherwise.
That's is, if a guest tells KVM that the GFN is shared, it can't be used
as private.  or vice-versa.

KVM needs to record it.  Steal software usable bit for it from MMIO
counter.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e88f796724b4..25dffdb488d1 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -14,6 +14,9 @@
  */
 #define SPTE_MMU_PRESENT_MASK		BIT_ULL(11)
 
+/* Masks that used to track for shared GPA **/
+#define SPTE_PRIVATE_PROHIBIT	BIT_ULL(62)
+
 /*
  * TDP SPTES (more specifically, EPT SPTEs) may not have A/D bits, and may also
  * be restricted to using write-protection (for L2 when CPU dirty logging, i.e.
@@ -124,7 +127,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
  * the memslots generation and is derived as follows:
  *
  * Bits 0-7 of the MMIO generation are propagated to spte bits 3-10
- * Bits 8-18 of the MMIO generation are propagated to spte bits 52-62
+ * Bits 8-18 of the MMIO generation are propagated to spte bits 52-61
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -138,7 +141,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 #define MMIO_SPTE_GEN_LOW_END		10
 
 #define MMIO_SPTE_GEN_HIGH_START	52
-#define MMIO_SPTE_GEN_HIGH_END		62
+#define MMIO_SPTE_GEN_HIGH_END		61
 
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 						    MMIO_SPTE_GEN_LOW_START)
@@ -151,7 +154,7 @@ static_assert(!(SPTE_MMU_PRESENT_MASK &
 #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
 
 /* remember to adjust the comment above as well if you change these */
-static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 10);
 
 #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
 #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
@@ -208,6 +211,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
+static_assert(!(REMOVED_SPTE & SPTE_PRIVATE_PROHIBIT));
 
 /*
  * See above comment around REMOVED_SPTE.  SHADOW_REMOVED_SPTE is the actual
@@ -222,6 +226,11 @@ static inline bool is_removed_spte(u64 spte)
 	return spte == SHADOW_REMOVED_SPTE;
 }
 
+static inline bool is_private_prohibit_spte(u64 spte)
+{
+	return !!(spte & SPTE_PRIVATE_PROHIBIT);
+}
+
 /*
  * In some cases, we need to preserve the GFN of a non-present or reserved
  * SPTE when we usurp the upper five bits of the physical address space to
-- 
2.25.1

