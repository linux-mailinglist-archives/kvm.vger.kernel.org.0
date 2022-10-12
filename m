Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567CB5FCA63
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 20:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiJLSRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 14:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJLSRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 14:17:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D1AA484E
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:25 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u5-20020a170902e80500b00178944c46aaso12238948plg.4
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oyyfiq1u1ow61sJxYdtEop67BKEuTOwTRoB44Qlve6k=;
        b=P2usEtoXL2d7Kadfzc6pHmhtZOrLbkU1dncF458jZB05kEaDR4KjrjxeuY2vSXDSFo
         bzwldY+iDn3YjfRcxMznyMfidl6/WuUWEP2QFEgmLDI3MAwPiaWHJCuCHdIGXcW+eSGN
         g/sEzO9PGlOgo6Vr6vFw6JZI73bhDmBxShW+cbqHQzscfO6bl7+73l8UYRTpUv1xyY3g
         +iU0rq7hqAlv49yzPLEq1daKsx2PPabZ8Od1fF8YSttMwMcfv7oszFPM2d32wM99sV4e
         h1fDGa/bn6rViRE0jfB29EyHUGVv1B9iTHYnpZW4bVSacmvCNnfVBmr1nw2Q07saZkag
         o1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oyyfiq1u1ow61sJxYdtEop67BKEuTOwTRoB44Qlve6k=;
        b=uv3EDYWLd9OGlJ1HEShR/Wm6Zksx9WW0Re1+l1DcMttYDClJgx8m+pWXjKuGY0AOZb
         OyaTlkn4fzFWnPo8FeSrb6mfQS/BVTUOVS49kQqZ++sjQx/P6NFpQN6cSqSXL/R/OmzF
         BVOuP6DfnVkCidS3/bnNLa046scnYRF5ALg0PJ03G57+mbok0Dd09o10+po8dks4ExEN
         yfjYUc5qG/toWBDQg++utLPZ21vo4T9LRFLzDFOHIslzdWevW6xSEm5AuLXwgR8PxbcZ
         LPSIK8duCCSv3laP9v3HYpznIM7Qj2Dq3sajmIps+vKLKmQKXwYJSp22Xgovnjo6QsX/
         G+GA==
X-Gm-Message-State: ACrzQf11O+WR5wKN6WdfS7H9QoXmYVsRsUaU38kAtw7k96H5nTXIATF8
        ywvdD9Jq5u6s/mRh1gnWYb7sYAAkiIM=
X-Google-Smtp-Source: AMsMyM5a7PIgQlH+XQAxQkl3E0hWyOTVe15+NXdqge73zQWdRTWS96H4/6KaihK8TGdSJwuYFfp8urRmBZs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1349:b0:563:654d:ce3f with SMTP id
 k9-20020a056a00134900b00563654dce3fmr17351716pfu.32.1665598644547; Wed, 12
 Oct 2022 11:17:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 12 Oct 2022 18:17:01 +0000
In-Reply-To: <20221012181702.3663607-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012181702.3663607-11-seanjc@google.com>
Subject: [PATCH v4 10/11] KVM: x86/mmu: Use static key/branches for checking
 if TDP MMU is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the TDP MMU being enabled is read-only after the vendor module
is loaded, use a static key to track whether or not the TDP MMU is
enabled to avoid conditional branches in hot paths, e.g. in
direct_page_fault() and fast_page_fault().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h     |  5 +++--
 arch/x86/kvm/mmu/mmu.c | 14 ++++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 1ad6d02e103f..bc0d8a5c09f9 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -2,6 +2,7 @@
 #ifndef __KVM_X86_MMU_H
 #define __KVM_X86_MMU_H
 
+#include <linux/jump_label.h>
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
 #include "cpuid.h"
@@ -230,13 +231,13 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
 }
 
 #ifdef CONFIG_X86_64
-extern bool tdp_mmu_enabled;
+DECLARE_STATIC_KEY_TRUE(tdp_mmu_enabled);
 #endif
 
 static inline bool is_tdp_mmu_enabled(void)
 {
 #ifdef CONFIG_X86_64
-	return tdp_mmu_enabled;
+	return static_branch_likely(&tdp_mmu_enabled);
 #else
 	return false;
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4792d76edd6d..a5ba7b41263d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -101,8 +101,10 @@ bool tdp_enabled = false;
 #ifdef CONFIG_X86_64
 static bool __ro_after_init tdp_mmu_allowed;
 
-bool __read_mostly tdp_mmu_enabled = true;
-module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0444);
+static bool __read_mostly __tdp_mmu_enabled = true;
+module_param_named(tdp_mmu, __tdp_mmu_enabled, bool, 0444);
+
+DEFINE_STATIC_KEY_TRUE(tdp_mmu_enabled);
 #endif
 
 static int max_huge_page_level __read_mostly;
@@ -5702,7 +5704,11 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 	max_tdp_level = tdp_max_root_level;
 
 #ifdef CONFIG_X86_64
-	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
+	__tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
+	if (__tdp_mmu_enabled)
+		static_branch_enable(&tdp_mmu_enabled);
+	else
+		static_branch_disable(&tdp_mmu_enabled);
 #endif
 	/*
 	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
@@ -6712,7 +6718,7 @@ void __init kvm_mmu_x86_module_init(void)
 	 * TDP MMU is actually enabled is determined in kvm_configure_mmu()
 	 * when the vendor module is loaded.
 	 */
-	tdp_mmu_allowed = tdp_mmu_enabled;
+	tdp_mmu_allowed = __tdp_mmu_enabled;
 #endif
 
 	kvm_mmu_spte_module_init();
-- 
2.38.0.rc1.362.ged0d419d3c-goog

