Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD954A25A
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 00:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242327AbiFMW6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 18:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiFMW5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 18:57:37 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596F225CB
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:33 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u6-20020a63d346000000b00407d7652203so2100496pgi.18
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bo31PGP16JR8fO1mwvO3YvvmHEE1iup/pKqJeMLN6sA=;
        b=e6mdfRC+yH8DEWKDztiUFCOlT+hLyEMdHwuptEyVZvR7QErW1ltJvFMXWlbIAQ4lHk
         fdDqosiVo/VvRX2iE5aDMrJNpDubEIcXcMdNNA/0okoOvrSjGMRXYe4W1zkuAk5/BZp2
         gnhSE7S3N7sIdLVMWGaTn5VGHy3W2iUCuqlT73kH3PdWRutT1JjLcfvgdGaYX68NyyHE
         DQxB3IZ3F0jx3PdAT4BQ7grTnkyjeShTZCWLd7oRwuGGM/neE1o60pxJeijrzYCK4cxq
         fPdHCnHZjYU9Bk64kKdbG9A9js+5u65/J4O9KULfONepX4MT4682ciloSt125Ndg/dmU
         tJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bo31PGP16JR8fO1mwvO3YvvmHEE1iup/pKqJeMLN6sA=;
        b=RBvAVOjuUKjOpXjxPZHr5IPwlZmgsbHHrU0Lsd/W+0peLBo+dXv3YCdfifvS6nRff9
         Q8TWgqWOoK/Xdl2zKKo/GQeg7VJEzEgz/6xGW38PfCl0Y6dn89H2GlzQtQmbuyzMLiZe
         94JhagpxhC8nzdOnRNJUwCWZrDq6MoY91WNV29u/i3/5jyBOw1ghgZZ0mk8MKX1OwpRX
         0ifswcqa7K+whnmzMyrx8QOShVCMDkK5WaFJNTaWccMTpWElfa3zIUZt/ar8B2LQmsLE
         KyrSGnyZtDyVGjGJL0r6EfYuWC8Ba5xf5JdqOSvs2SvxTMxU6aBTKMHVVFjOZ5JsD/0M
         hphQ==
X-Gm-Message-State: AOAM533pOjaNNPY9G9RnEzoJ/qC1624YB7EtOoY9ljNC3/iYimbAOE3e
        bPuyBi+Sin7mOzTqbbSDIBTGjQgCa6c=
X-Google-Smtp-Source: ABdhPJwWEaECxcGZhw2o4gKX7Dh5diIt/fzvRU1hWYTIrwPktOsvYDx1piS89RKElwqnExMrOQPTBO35hlY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:831d:0:b0:51e:ec7a:82a7 with SMTP id
 bk29-20020aa7831d000000b0051eec7a82a7mr1583270pfb.51.1655161053132; Mon, 13
 Jun 2022 15:57:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 22:57:19 +0000
In-Reply-To: <20220613225723.2734132-1-seanjc@google.com>
Message-Id: <20220613225723.2734132-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220613225723.2734132-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 4/8] KVM: x86/mmu: Dedup macros for computing various page
 table masks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide common helper macros to generate various masks, shifts, etc...
for 32-bit vs. 64-bit page tables.  Only the inputs differ, the actual
calculations are identical.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h              |  4 ++--
 arch/x86/kvm/mmu/mmu.c          | 15 ++++++---------
 arch/x86/kvm/mmu/mmu_internal.h | 14 ++++++++++++++
 arch/x86/kvm/mmu/paging.h       |  9 +++++----
 arch/x86/kvm/mmu/spte.h         |  7 +++----
 5 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index d1021e34ac15..6efe6bd7fb6e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -7,9 +7,9 @@
 #include "cpuid.h"
 
 #define PT64_PT_BITS 9
-#define PT64_ENT_PER_PAGE (1 << PT64_PT_BITS)
+#define PT64_ENT_PER_PAGE __PT_ENT_PER_PAGE(PT64_PT_BITS)
 #define PT32_PT_BITS 10
-#define PT32_ENT_PER_PAGE (1 << PT32_PT_BITS)
+#define PT32_ENT_PER_PAGE __PT_ENT_PER_PAGE(PT32_PT_BITS)
 
 #define PT_WRITABLE_SHIFT 1
 #define PT_USER_SHIFT 2
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f1961fe3fe67..afe3deaa0d95 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -113,23 +113,20 @@ module_param(dbg, bool, 0644);
 
 #define PT32_LEVEL_BITS 10
 
-#define PT32_LEVEL_SHIFT(level) \
-		(PAGE_SHIFT + (level - 1) * PT32_LEVEL_BITS)
+#define PT32_LEVEL_SHIFT(level) __PT_LEVEL_SHIFT(level, PT32_LEVEL_BITS)
 
 #define PT32_LVL_OFFSET_MASK(level) \
-	(PT32_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT32_LEVEL_BITS))) - 1))
-
-#define PT32_INDEX(address, level)\
-	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
+	__PT_LVL_OFFSET_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
 
+#define PT32_INDEX(address, level) __PT_INDEX(address, level, PT32_LEVEL_BITS)
 
 #define PT32_BASE_ADDR_MASK PAGE_MASK
+
 #define PT32_DIR_BASE_ADDR_MASK \
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
+
 #define PT32_LVL_ADDR_MASK(level) \
-	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
-					    * PT32_LEVEL_BITS))) - 1))
+	__PT_LVL_ADDR_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
 
 #include <trace/events/kvm.h>
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index bd2a26897b97..5e1e3c8f8aaa 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -20,6 +20,20 @@ extern bool dbg;
 #define MMU_WARN_ON(x) do { } while (0)
 #endif
 
+/* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
+#define __PT_LEVEL_SHIFT(level, bits_per_level)	\
+	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
+#define __PT_INDEX(address, level, bits_per_level) \
+	(((address) >> __PT_LEVEL_SHIFT(level, bits_per_level)) & ((1 << (bits_per_level)) - 1))
+
+#define __PT_LVL_ADDR_MASK(base_addr_mask, level, bits_per_level) \
+	((base_addr_mask) & ~((1ULL << (PAGE_SHIFT + (((level) - 1) * (bits_per_level)))) - 1))
+
+#define __PT_LVL_OFFSET_MASK(base_addr_mask, level, bits_per_level) \
+	((base_addr_mask) & ((1ULL << (PAGE_SHIFT + (((level) - 1) * (bits_per_level)))) - 1))
+
+#define __PT_ENT_PER_PAGE(bits_per_level)  (1 << (bits_per_level))
+
 /*
  * Unlike regular MMU roots, PAE "roots", a.k.a. PDPTEs/PDPTRs, have a PRESENT
  * bit, and thus are guaranteed to be non-zero when valid.  And, when a guest
diff --git a/arch/x86/kvm/mmu/paging.h b/arch/x86/kvm/mmu/paging.h
index de8ab323bb70..23f3f64b8092 100644
--- a/arch/x86/kvm/mmu/paging.h
+++ b/arch/x86/kvm/mmu/paging.h
@@ -4,11 +4,12 @@
 #define __KVM_X86_PAGING_H
 
 #define GUEST_PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+
 #define PT64_LVL_ADDR_MASK(level) \
-	(GUEST_PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
+	__PT_LVL_ADDR_MASK(GUEST_PT64_BASE_ADDR_MASK, level, PT64_LEVEL_BITS)
+
 #define PT64_LVL_OFFSET_MASK(level) \
-	(GUEST_PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
+	__PT_LVL_OFFSET_MASK(GUEST_PT64_BASE_ADDR_MASK, level, PT64_LEVEL_BITS)
+
 #endif /* __KVM_X86_PAGING_H */
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0127bb6e3c7d..d5a8183b7232 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -55,11 +55,10 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 
 #define PT64_LEVEL_BITS 9
 
-#define PT64_LEVEL_SHIFT(level) \
-		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
+#define PT64_LEVEL_SHIFT(level) __PT_LEVEL_SHIFT(level, PT64_LEVEL_BITS)
+
+#define PT64_INDEX(address, level) __PT_INDEX(address, level, PT64_LEVEL_BITS)
 
-#define PT64_INDEX(address, level)\
-	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
 /*
-- 
2.36.1.476.g0c4daa206d-goog

