Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D0654A25E
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 00:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiFMW61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 18:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbiFMW5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 18:57:40 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2C010F0
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:37 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id cd16-20020a056a00421000b00520785db095so2918599pfb.15
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XfyrmAuBNG96ESd4ge8XFRdhqAAWlj/bUQmrHUvO0vg=;
        b=aB+mHJdxCtw86zizW4wBXbT1gFqQGoe0qOMmsjfrKUSWynkwhUxvP0niYP7qIZHIop
         TEd087yHrArSh02i6aFoQcQezKWHPMlYuE7ifax/CdCzxoL167+1Xbbn2H2J2qPv5bS0
         57rClqQ3jgTawmKTUNi2mByyvnqGXucQSedyoI8rD1/bRS8q2JgxT5YFvtO8dqjPE3Eh
         pjDVeYsv7h50iP0tyG+9IIaNc3srWTjyYt3IrjeAmHhSzaJEEi0AAUTE9O/xAPrbsZ19
         Ghf+uSGLF6CHyxIccu/zMK51xLO43hjPFHTqzTh1iZNdvr78E0L9Rpew4+eNhrGAto9r
         oc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XfyrmAuBNG96ESd4ge8XFRdhqAAWlj/bUQmrHUvO0vg=;
        b=FQPDUFGbCUurR/Puxun8GjPlEArglAnh3Fu1aInUJTtAO5OIJwZMBiWykRojEveeMA
         JnDAcQy0YCgBgjopbHEFhPQwCLKynH61YHk81K3lXQxyobZnkBpqT/WS3/8VXeMurT5n
         R3Qxggjc9amC3W1heJA9isMc0v7K2heOCNUfXIRZ4D/CLZkiHUXPZ2VZaeBgEj9ac5oG
         uaKxX+1o5PE6VMnSjpi3m3H708M0cqN56MtNZgbm2m356qSgL1MGFfD/oG1WclB4Z2Ap
         RohUSNtJxR8s3ooCK0bI7JJggjxRo8qKrlUGWFctrFVfI2/dmtg8oblghJDxpOdbAc2l
         i3GQ==
X-Gm-Message-State: AJIora/tNbLhT9k0d7zjE0yOzQyMladIbfLtiLcIMaxej0r4Id5EAXQH
        P1YzdA2JGVBBBuwCOf2x9Kn4R0nfOu4=
X-Google-Smtp-Source: AGRyM1urB2wXKYaVwBFbTVFrOgFVE+BwUDOaPZYhK78OGINuG4bhotXlqzGx0Puv+VHs0tpYMhvfFoKKHxk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac7:b0:166:4ce4:7e32 with SMTP id
 q7-20020a170902dac700b001664ce47e32mr1389307plx.168.1655161056535; Mon, 13
 Jun 2022 15:57:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 22:57:21 +0000
In-Reply-To: <20220613225723.2734132-1-seanjc@google.com>
Message-Id: <20220613225723.2734132-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220613225723.2734132-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 6/8] KVM: x86/mmu: Use common macros to compute 32/64-bit
 paging masks
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dedup the code for generating (most of) the per-type PT_* masks in
paging_tmpl.h.  The relevant macros only vary based on the number of bits
per level, and that smidge of info is already provided in a common form
as PT_LEVEL_BITS.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging.h      | 26 --------------------------
 arch/x86/kvm/mmu/paging_tmpl.h | 25 +++++++++++--------------
 2 files changed, 11 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging.h b/arch/x86/kvm/mmu/paging.h
index 3fed2c101de3..9de4976b2d46 100644
--- a/arch/x86/kvm/mmu/paging.h
+++ b/arch/x86/kvm/mmu/paging.h
@@ -5,31 +5,5 @@
 
 #define GUEST_PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 
-#define PT64_LEVEL_BITS 9
-
-#define PT64_INDEX(address, level) __PT_INDEX(address, level, PT64_LEVEL_BITS)
-
-#define PT64_LVL_ADDR_MASK(level) \
-	__PT_LVL_ADDR_MASK(GUEST_PT64_BASE_ADDR_MASK, level, PT64_LEVEL_BITS)
-
-#define PT64_LVL_OFFSET_MASK(level) \
-	__PT_LVL_OFFSET_MASK(GUEST_PT64_BASE_ADDR_MASK, level, PT64_LEVEL_BITS)
-
-
-#define PT32_LEVEL_SHIFT(level) __PT_LEVEL_SHIFT(level, PT32_LEVEL_BITS)
-
-#define PT32_LVL_OFFSET_MASK(level) \
-	__PT_LVL_OFFSET_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
-
-#define PT32_INDEX(address, level) __PT_INDEX(address, level, PT32_LEVEL_BITS)
-
-#define PT32_BASE_ADDR_MASK PAGE_MASK
-
-#define PT32_DIR_BASE_ADDR_MASK \
-	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
-
-#define PT32_LVL_ADDR_MASK(level) \
-	__PT_LVL_ADDR_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
-
 #endif /* __KVM_X86_PAGING_H */
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 75f6b01edcf8..0bb2a6c97ebb 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -16,8 +16,9 @@
  */
 
 /*
- * We need the mmu code to access both 32-bit and 64-bit guest ptes,
- * so the code in this file is compiled twice, once per pte size.
+ * The MMU needs to be able to access/walk 32-bit and 64-bit guest page tables,
+ * as well as guest EPT tables, so the code in this file is compiled thrice,
+ * once per guest PTE type.  The per-type defines are #undef'd at the end.
  */
 
 #if PTTYPE == 64
@@ -25,10 +26,7 @@
 	#define guest_walker guest_walker64
 	#define FNAME(name) paging##64_##name
 	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
-	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
-	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
-	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
-	#define PT_LEVEL_BITS PT64_LEVEL_BITS
+	#define PT_LEVEL_BITS 9
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
@@ -41,10 +39,7 @@
 	#define pt_element_t u32
 	#define guest_walker guest_walker32
 	#define FNAME(name) paging##32_##name
-	#define PT_BASE_ADDR_MASK PT32_BASE_ADDR_MASK
-	#define PT_LVL_ADDR_MASK(lvl) PT32_LVL_ADDR_MASK(lvl)
-	#define PT_LVL_OFFSET_MASK(lvl) PT32_LVL_OFFSET_MASK(lvl)
-	#define PT_INDEX(addr, level) PT32_INDEX(addr, level)
+	#define PT_BASE_ADDR_MASK PAGE_MASK
 	#define PT_LEVEL_BITS PT32_LEVEL_BITS
 	#define PT_MAX_FULL_LEVELS 2
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
@@ -61,10 +56,7 @@
 	#define guest_walker guest_walkerEPT
 	#define FNAME(name) ept_##name
 	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
-	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
-	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
-	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
-	#define PT_LEVEL_BITS PT64_LEVEL_BITS
+	#define PT_LEVEL_BITS 9
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) (!(mmu)->cpu_role.base.ad_disabled)
@@ -73,6 +65,11 @@
 	#error Invalid PTTYPE value
 #endif
 
+/* Common logic, but per-type values.  These also need to be undefined. */
+#define PT_LVL_ADDR_MASK(lvl)	__PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
+#define PT_LVL_OFFSET_MASK(lvl)	__PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
+#define PT_INDEX(addr, lvl)	__PT_INDEX(addr, lvl, PT_LEVEL_BITS)
+
 #define PT_GUEST_DIRTY_MASK    (1 << PT_GUEST_DIRTY_SHIFT)
 #define PT_GUEST_ACCESSED_MASK (1 << PT_GUEST_ACCESSED_SHIFT)
 
-- 
2.36.1.476.g0c4daa206d-goog

