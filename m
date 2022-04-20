Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8EC507D9C
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 02:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347935AbiDTAaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 20:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbiDTAai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 20:30:38 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A1E338AF
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 17:27:53 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h14-20020a63530e000000b0039daafb0a84so20673pgb.7
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 17:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=JVVQnl/KYP++X9fCgwSWz3X+dYjBYA16WR3/C3IIdtI=;
        b=WPRu2kU0u+hfUVClXeD6/hdwDt9tvMKj7XG+L0pw/m7FKIKxVvsaG2Wv6VXMMC/qAy
         WC3E/tf23b0jUpr57KGiFmxG5q9ov88HzZjqejfc32g2OJSfcAfhye2W69i7ohQAji9c
         v7A0fWaG8b+hUC6iN3EXw45zZwB2Xr9yaZzmHBeq0UHdmXrS/8DvFPu5mpcZQFbFXbdh
         9fr3nu+SSY53Kxya/K60dDdpFVVO/eUwQtfW9cEgs5nmZEyBYCrHfUuNX1JLRjXjaRwY
         /A52ZqxyiYI93b7U9oe7B+1mTWoN9ghBOXbT3DVJAuvwjwJDrNc7BTEDLYba45mLEOvY
         yGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=JVVQnl/KYP++X9fCgwSWz3X+dYjBYA16WR3/C3IIdtI=;
        b=eGg+po3lwHUPHuog5h7iHrHu0QszZjyJA8aEixmX+hHf3I76Edjeq4MLi0a3fxnfXk
         zmbe0OKkAMrC9wLKEE5hsR6EeulrutzOzX+MCBiN/YZrI0wCYKgJu/sn8Llmjt1GNQrX
         jmOifc/83E9O/oNoNSU7l5d01HsznpvCFQXTd8L45oA76xDi5PGGrTq2DOpTRZbDtJvx
         OeLBZkU2CdLlIpVkdpEvPi9mPXuO02jGLtcaWHzQOBQc+xzphCk94dGTPB8Hfere+coz
         Y1pijfBodiQVefPv7UNzcYqLCHu06eMlx4IuU+XN6zwe6518zebtW0+KzBKtSxfxPPQv
         CusQ==
X-Gm-Message-State: AOAM532WXh5W9UQ7g1ZnYQQIAw6AbwaF0lb3nkNe8BlhNKr6Z/FYkYoi
        pI/thZYyHM1jpId5h1x5chWJjoLY9D4=
X-Google-Smtp-Source: ABdhPJx5ytIMuPqXDzt5hExFtmr+teWqieLJnqBP1OGfF+HF2diufwCXow16yqBg0nqfSEJemIHGUwk8vuM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1e45:b0:1d2:3ef6:18d9 with SMTP id
 pi5-20020a17090b1e4500b001d23ef618d9mr1345549pjb.221.1650414472927; Tue, 19
 Apr 2022 17:27:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 20 Apr 2022 00:27:47 +0000
Message-Id: <20220420002747.3287931-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH] KVM: x86/mmu: Use enable_mmio_caching to track if MMIO
 caching is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>
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

Clear enable_mmio_caching if hardware can't support MMIO caching and use
the dedicated flag to detect if MMIO caching is enabled instead of
assuming shadow_mmio_value==0 means MMIO caching is disabled.  TDX will
use a zero value even when caching is enabled, and is_mmio_spte() isn't
so hot that it needs to avoid an extra memory access, i.e. there's no
reason to be super clever.  And the clever approach may not even be more
performant, e.g. gcc-11 lands the extra check on a non-zero value inline,
but puts the enable_mmio_caching out-of-line, i.e. avoids the few extra
uops for non-MMIO SPTEs.

Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 2 +-
 arch/x86/kvm/mmu/spte.c | 5 ++++-
 arch/x86/kvm/mmu/spte.h | 4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 69a30d6d1e2b..01bbe7744342 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2991,7 +2991,7 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		 * touching the shadow page tables as attempting to install an
 		 * MMIO SPTE will just be an expensive nop.
 		 */
-		if (unlikely(!shadow_mmio_value)) {
+		if (unlikely(!enable_mmio_caching)) {
 			*ret_val = RET_PF_EMULATE;
 			return true;
 		}
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..eedfc599a457 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -19,7 +19,7 @@
 #include <asm/memtype.h>
 #include <asm/vmx.h>
 
-static bool __read_mostly enable_mmio_caching = true;
+bool __read_mostly enable_mmio_caching = true;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
 
 u64 __read_mostly shadow_host_writable_mask;
@@ -351,6 +351,9 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
 		mmio_value = 0;
 
+	if (!mmio_value)
+		enable_mmio_caching = false;
+
 	shadow_mmio_value = mmio_value;
 	shadow_mmio_mask  = mmio_mask;
 	shadow_mmio_access_mask = access_mask;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..ad8ce3c5d083 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -5,6 +5,8 @@
 
 #include "mmu_internal.h"
 
+extern bool __read_mostly enable_mmio_caching;
+
 /*
  * A MMU present SPTE is backed by actual memory and may or may not be present
  * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
@@ -210,7 +212,7 @@ extern u8 __read_mostly shadow_phys_bits;
 static inline bool is_mmio_spte(u64 spte)
 {
 	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
-	       likely(shadow_mmio_value);
+	       likely(enable_mmio_caching);
 }
 
 static inline bool is_shadow_present_pte(u64 pte)

base-commit: 150866cd0ec871c765181d145aa0912628289c8a
-- 
2.36.0.rc0.470.gd361397f0d-goog

