Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C1754BE57
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346028AbiFNXdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345061AbiFNXdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:33:44 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205044CD65
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:43 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id j23-20020a17090a061700b001e89529d397so179893pjj.6
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=u376NglyWXxiicHgNlnw7ZtxygoUbgzaPBx4X4YHgag=;
        b=Jg4AhD1L1oBjVx8hen9rpkycs2qhxz2lhpbP7hM8uD6MKFHihB7uMlRq/gbfYCNC1v
         gyJtdtJkMo02Oag7dMy09TFkM2EsEygM3NjsSQGWqWxZWcm3RvqaK/9ITTCFDhFs01yF
         WKHBOa+lf+EcfQQgaCHwUniHAV2Xha6eg6ugILH7HKqvhUN1Ep9APDnfjCPkGFD7N6yC
         nekVg0ZjGryGhQ6IW9z4jq76STbshE5gVmpQFOIsBrs7zzexF/w32b6eecJRG3qPhckk
         jrenxElfnejStnF6H5X3ftdD2iMUamE2hyIdYj9/ry9L7JY4FtEAkMG/lyojHkhI7Oun
         nZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=u376NglyWXxiicHgNlnw7ZtxygoUbgzaPBx4X4YHgag=;
        b=HEXfrZ9cSme4ir4rL1dYpQ6Jg1b1bS2vMoffzBhENlKGUwDAxdC1aM8hLy1S3VC5Mu
         BY1rjtrS82+YaF91Xr8/HYCXGeNB2tBkIKVJi5ZkwOT2pyZiQoy8trFsxnO33wK1RSjP
         3EShn0nUYkkbxMPyxWerIY7FdV9rVrNjOAhXHGEJtIVUOB33WB1XhbZ1qgNQYlA5LEcE
         WB+kXdWgK6ZANRHpu7mcHX4iR/iZ7XgVrV5SOxoHGA/2N7MMGQBY/7t+jOzASyp96Njf
         H/J9VpD9HtNmvYXo3pbnSsiUrFhiWn7CRUlE4DmTq9VpqwpJlqy8JJI88secNhwMb8l9
         o9eg==
X-Gm-Message-State: AJIora9UQ7Ze5gbxn6iwoK7+HpQQ4EFYNIjUYbbBa1PzDOHPvgel0ei8
        K1UX1zF59VxrKWafInSnjzrmTPFqQuI=
X-Google-Smtp-Source: AGRyM1trjkDzlCBVy45BOBoqBUPK0tsGTitF5YEiPEB6I89EY74HhcObs1/GlBTKGIsnux2XdKUPykkW+tU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr204399pje.0.1655249621884; Tue, 14 Jun
 2022 16:33:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:33:24 +0000
In-Reply-To: <20220614233328.3896033-1-seanjc@google.com>
Message-Id: <20220614233328.3896033-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220614233328.3896033-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 4/8] KVM: x86/mmu: Dedup macros for computing various page
 table masks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c          | 14 +++++---------
 arch/x86/kvm/mmu/mmu_internal.h | 14 ++++++++++++++
 arch/x86/kvm/mmu/paging.h       |  9 +++++----
 arch/x86/kvm/mmu/spte.h         |  7 +++----
 5 files changed, 29 insertions(+), 19 deletions(-)

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
index 73497da1a99b..b3edff05a53a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -113,21 +113,17 @@ module_param(dbg, bool, 0644);
 
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

