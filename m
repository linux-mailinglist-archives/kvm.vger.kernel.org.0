Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7641454A25C
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 00:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245698AbiFMW60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 18:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241037AbiFMW5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 18:57:41 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D7521BD
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:40 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e1-20020a17090301c100b00168d7df157cso2435164plh.3
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RHYcnFXTT7ac0ob6di8kcCxjr6TYxAsCityKr+RTKLI=;
        b=Ht+WkXrzNY4aCQJpUyHeoWPWNTBiTlUW3Lagepr4HbSdxEqbjS+ssk0l8Zamu5d1SR
         jjMxcznKpxbilodFMTbwrpKMcGsDf3SN15/AHVZrOIWYxZNkjMDYM5vYWcYW5iomnR8d
         ENCPPz0daRuFtW9s37PyTlx1y5/jAYunRaYufcaL3bKBWOyjrRQ6YKofuf8OAdaElQYX
         6fyug2OPvXy5nnN8B/AfFA82ZAlHIVmrpOqVheuMEB1MgTqPNrSqJqoWpEvMLy5hICph
         MwWuJkEmgQzcxqCKlGF9srg9wvaxtk8Pa4iWY14QwGls9+deEB7KJO5apyO8sxQyixMG
         IxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RHYcnFXTT7ac0ob6di8kcCxjr6TYxAsCityKr+RTKLI=;
        b=UTFQkypofelgGf9lD3IQAVcwv34BbBPEiUzMpigfgQeuBmTCozDZptmO4pj+HEcH+K
         4/YfNMvcyGNMuqyhHYNV3jNFeSUBsCKu//FSJa/8/CDgi14SEGn183baPV0bv0Hf4oLC
         oabhg8/zcgqSliQWo0Sh1nTpRT+h+hWP5ynLyrw3Kj1lGLIT7fAraj3tNLI1HKASqa3r
         sVoLZ8Ax/DpvCOmMFvFvL6a/WOMVeBcFEpN+xufSosM3iGAn7qJ+foR7iv8l5z8H04yC
         VK6HrsXj64gqOUo32elX20cjrE3PWL3scPyY0FkDpOTQJLH/R5FQK/domhtxFXG5fn4X
         CIaA==
X-Gm-Message-State: AJIora9YOxi6m0vbK76ATrkBrn9Kbc7oJi+0XAQixjtweF3pfPP9B4gc
        klzsTnOnKEehVxeBsXk9YAOYaXds/rk=
X-Google-Smtp-Source: AGRyM1usL/eeVClnixov12j9knTnRvi5pIAGqLnemUdbfR1Ufy3iDbbtQEYUfhjil6JScKSo4HiKr6s8g5Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:66c1:b0:1e8:43ae:f7c0 with SMTP id
 z1-20020a17090a66c100b001e843aef7c0mr1054309pjl.245.1655161059904; Mon, 13
 Jun 2022 15:57:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 22:57:23 +0000
In-Reply-To: <20220613225723.2734132-1-seanjc@google.com>
Message-Id: <20220613225723.2734132-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220613225723.2734132-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 8/8] KVM: x86/mmu: Use common logic for computing the
 32/64-bit base PA mask
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

Use common logic for computing PT_BASE_ADDR_MASK for 32-bit, 64-bit, and
EPT paging.  Both PAGE_MASK and the new-common logic are supsersets of
what is actually needed for 32-bit paging.  PAGE_MASK sets bits 63:12 and
the former GUEST_PT64_BASE_ADDR_MASK sets bits 51:12, so regardless of
which value is used, the result will always be bits 31:12.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 --
 arch/x86/kvm/mmu/paging.h      | 9 ---------
 arch/x86/kvm/mmu/paging_tmpl.h | 4 +---
 3 files changed, 1 insertion(+), 14 deletions(-)
 delete mode 100644 arch/x86/kvm/mmu/paging.h

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aedb8d871030..0f0c3ebfcf51 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -53,8 +53,6 @@
 #include <asm/kvm_page_track.h>
 #include "trace.h"
 
-#include "paging.h"
-
 extern bool itlb_multihit_kvm_mitigation;
 
 int __read_mostly nx_huge_pages = -1;
diff --git a/arch/x86/kvm/mmu/paging.h b/arch/x86/kvm/mmu/paging.h
deleted file mode 100644
index 9de4976b2d46..000000000000
--- a/arch/x86/kvm/mmu/paging.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/* Shadow paging constants/helpers that don't need to be #undef'd. */
-#ifndef __KVM_X86_PAGING_H
-#define __KVM_X86_PAGING_H
-
-#define GUEST_PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
-
-#endif /* __KVM_X86_PAGING_H */
-
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4087e58e2232..1f0dbc31e5d4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -25,7 +25,6 @@
 	#define pt_element_t u64
 	#define guest_walker guest_walker64
 	#define FNAME(name) paging##64_##name
-	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
 	#define PT_LEVEL_BITS 9
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
@@ -39,7 +38,6 @@
 	#define pt_element_t u32
 	#define guest_walker guest_walker32
 	#define FNAME(name) paging##32_##name
-	#define PT_BASE_ADDR_MASK ((pt_element_t)PAGE_MASK)
 	#define PT_LEVEL_BITS PT32_LEVEL_BITS
 	#define PT_MAX_FULL_LEVELS 2
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
@@ -55,7 +53,6 @@
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
 	#define FNAME(name) ept_##name
-	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
 	#define PT_LEVEL_BITS 9
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
@@ -66,6 +63,7 @@
 #endif
 
 /* Common logic, but per-type values.  These also need to be undefined. */
+#define PT_BASE_ADDR_MASK	((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
 #define PT_LVL_ADDR_MASK(lvl)	__PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_LVL_OFFSET_MASK(lvl)	__PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_INDEX(addr, lvl)	__PT_INDEX(addr, lvl, PT_LEVEL_BITS)
-- 
2.36.1.476.g0c4daa206d-goog

