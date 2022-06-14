Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559AF54BE5E
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357265AbiFNXeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352366AbiFNXeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:34:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFAD4F452
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:50 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id n6-20020a654886000000b003fda8768883so5650770pgs.14
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UVZzvWgZd/qa60rxNjAcDblynDLVeinGXHSxsImBGrU=;
        b=DwCFxaRhRl9A9MoEpWb2SQfi4DYTduFc2PKiyCNhwx0btH68sScDN59PD0H9VKIVBM
         j/tYe+bh2eKxRice15QWiN2N9uma13ApTUjRhZ7Wj2meCm88dpIjI/FjaunvUhbnhD/x
         Wpw2zZiIoQhapsipnLo306ZtZK/B9XTR2l81FmjjxWzd8/gKFtPQtu/gzQG0wTwDm5aW
         qSNLff6LQQ/dxyfRtONRsPlG4UOA7x2gejjD1HvDjhN8aYguSIePJRocfy3E+Rj6ZQ61
         3WZ45B5xtOEI88TfScodCzfp/DgQsHmp5coQI1Czo01GWHg1WNZXdLatLy2C3v9oSgZy
         7JHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UVZzvWgZd/qa60rxNjAcDblynDLVeinGXHSxsImBGrU=;
        b=Mlzpi9rdJQjqFw2iBO8V6rKQOUoooOsHoYMBYo5ajp47klNjcS6jccKufpB/AitV6E
         KMMgiR1hE/GhQFzNUOg3h9gxyD4/Jsak0Kqi0DiSH5Mqc5wdZjIYGHz8ETIfZKTnapUS
         ZadhGnyc9L//tXq8xqdWvGekUpvTYvaia4NCVjUVkCEMFT/LeoqdQ/sWhlRzQISYIT5p
         mYsKGxyKGD2oX3aSk14LWL8/UKUoeYNuV4Z+BWyKc/fLYgJPoopTLgXn3F7wHyWZIe+0
         JOKrRY4W9+p+LhFADVpVB4HburAuB1MUY/pCiJEZBz1quTWxDSeLg7PhndVLhoafI8dS
         TADg==
X-Gm-Message-State: AOAM533MxeXxti/pzx73Rst2vFHBScXfmMcS1DII5lPqnKPNolf7MQDR
        kmtZOtPBB6PtKM3pydLEVASvePahfqc=
X-Google-Smtp-Source: ABdhPJxJTmXAQVhdGcazJMBZlTYBCSV4zUdBJr9pYqqItppdglCIH0/nzv8n1cUqXLQLK/9Bp7gGHwSp74w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:587:0:b0:405:559:6df1 with SMTP id
 129-20020a630587000000b0040505596df1mr6339797pgf.355.1655249629290; Tue, 14
 Jun 2022 16:33:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:33:28 +0000
In-Reply-To: <20220614233328.3896033-1-seanjc@google.com>
Message-Id: <20220614233328.3896033-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220614233328.3896033-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 8/8] KVM: x86/mmu: Use common logic for computing the
 32/64-bit base PA mask
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
index 81f2e58dc85b..a67aac727dc2 100644
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
index 3ed7ba4730b4..6c29aef4092b 100644
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
@@ -54,7 +52,6 @@
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
 	#define FNAME(name) ept_##name
-	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
 	#define PT_LEVEL_BITS 9
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
@@ -65,6 +62,7 @@
 #endif
 
 /* Common logic, but per-type values.  These also need to be undefined. */
+#define PT_BASE_ADDR_MASK	((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
 #define PT_LVL_ADDR_MASK(lvl)	__PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_LVL_OFFSET_MASK(lvl)	__PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_INDEX(addr, lvl)	__PT_INDEX(addr, lvl, PT_LEVEL_BITS)
-- 
2.36.1.476.g0c4daa206d-goog

