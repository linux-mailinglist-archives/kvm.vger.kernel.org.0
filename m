Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C77D54BE5A
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345946AbiFNXeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345239AbiFNXdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:33:50 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06024D616
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:46 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h190-20020a636cc7000000b003fd5d5452cfso5659935pgc.8
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=w3II49oWz5ZD4VBgFJqFAIErRYz4YB3L6RNtySXolkY=;
        b=nAu6RySpXNQgIcUKmlbGBRHPNLX5h5xTCKuG94eFIr6E03fA9CI89ERUs97qITUu9s
         8XF16hirrjNg7L/7mjDSd3+xiwnK/bpRrWfGQAoENn8gTtjnubRpp6NdAurfUyIVjem3
         UB4XpiVJ4yglidmi/TVsHMW90fERY72DKnFSZ8xT2GPRTfTBcF/IoWC9eLAO/h4eWrh7
         1PvwI+Dej4wrM1/9jfAWx7NLD77FAl4THlFl6sCuUumUDhgUQxvuI9i0OetkUD/atZzu
         /djyDxDoiZd33Fke9CX0tnUn0Bi/acSBVH1Rbzlmc1VCP6/hglr/l8FQl5A12rser8R4
         +eLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=w3II49oWz5ZD4VBgFJqFAIErRYz4YB3L6RNtySXolkY=;
        b=7IzVL24d84/6yFVWQT4d0cXz66un3hKYorpuAIfdlW2zi44oY46zyYAXpQIqJEcJlu
         hYVq75zS1u5wfSGuo3isoCocrsnjqLdZdaYM3R3onAkzkpuX2jTsP3h42f5LDIlbjp55
         GUYzEnswtKFznoEhBeZDgMvZq/W3hoj93stmQt1kMflVQdROdQ4mBilZKHse853NfYbA
         12IvLkB2rNZjGo8+mrWTKTTG6KMlzftfIDo0le/bBSyqiGVmpijAhhPrdMr5E1Ggi0cF
         ifzbwlZTY+PZ8DfZeIKBWrcLqdD3vSOxOJExyT3BtarjPk1JvLfJ7Kq8EkQXMj+0/LS0
         oB+A==
X-Gm-Message-State: AJIora+PBGwTu4rtpZqszYzvnXzmQl3WlEqaYUlql4YHOllKo7qnvsao
        Ykiy8HgdSyYnpDRRHiNJsUBjqOu+x9A=
X-Google-Smtp-Source: AGRyM1u+edJJRfUOUBN5M8yJAjwBhWPIjI8/Cm0yzRqvwnRgB2E1MZQC3NfGzo9/RXxWJO2FaU1gikDl1PU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:edd1:b0:158:8318:b51e with SMTP id
 q17-20020a170902edd100b001588318b51emr6789427plk.89.1655249625966; Tue, 14
 Jun 2022 16:33:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:33:26 +0000
In-Reply-To: <20220614233328.3896033-1-seanjc@google.com>
Message-Id: <20220614233328.3896033-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220614233328.3896033-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 6/8] KVM: x86/mmu: Use common macros to compute 32/64-bit
 paging masks
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
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/paging.h      | 23 -----------------------
 arch/x86/kvm/mmu/paging_tmpl.h | 25 +++++++++++--------------
 2 files changed, 11 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging.h b/arch/x86/kvm/mmu/paging.h
index 6a63727cc7e8..9de4976b2d46 100644
--- a/arch/x86/kvm/mmu/paging.h
+++ b/arch/x86/kvm/mmu/paging.h
@@ -5,28 +5,5 @@
 
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
-#define PT32_LVL_ADDR_MASK(level) \
-	__PT_LVL_ADDR_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
-
 #endif /* __KVM_X86_PAGING_H */
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index d68cc7a5ef81..4fcde3a18f5f 100644
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
@@ -60,10 +55,7 @@
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
@@ -72,6 +64,11 @@
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

