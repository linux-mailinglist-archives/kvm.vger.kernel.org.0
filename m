Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7383C58948B
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 00:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbiHCWuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 18:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238292AbiHCWuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 18:50:07 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A582122B29
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 15:50:06 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id f16-20020a17090a4a9000b001f234757bbbso7818346pjh.6
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 15:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=BinmiOfwZUwriSfE/jKfvIa+BhtB258YTBKvkrhds/k=;
        b=YBP8ZqxYF8Tug3wBIRwfnlWJdaehUc5PKJv5CtD3iCzc2O3XCWILD1oDCXoBjRp1um
         C0sRQtwcLFxC1kudvQYaatAvKPh2MvFWIdmLZz52haz0SX78kS1DjkqZhHtbgr74NoCK
         4sVXFuM9sChx1HTw4f7iiPubtoYGTxgpEOZZu4X77wUcm6RUEqaZ51XcuHFyeIVulZGI
         005RFfZ0EE5g8Ho7mPzH3sltKhf7NyA02py+uutV2A7TtSL/TZPpqlIFGOOPUjFOhQZR
         tAb53vrPImn3C1dwFuYgfwEwjUOoYOAgRsByB9rCoJM/bMnxFtY90apBaysNWQRkM/Vo
         fT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=BinmiOfwZUwriSfE/jKfvIa+BhtB258YTBKvkrhds/k=;
        b=uUYpyh9pQxp+WJzqWN2fZotU0fAs5bJsG3aeudhg+cEY3y8/3RdAg/kgG8LIJQ7HJB
         cvUGuqNFHAtGs1I8euN/S0tLPmS4C8P9KT/n0AgONb3kNZyX6s6ycOSBlT8/KRm+5jPR
         yJ0eEFDMKLab1B4mBjS6+ETFRZrRc4VZLpSPNfBKf3mnEYwUEigZGHDQWPeIdVnrHca3
         9hga2vsn5gZkPHG7Y9CtilR6EeV47CEj1fhUNlP284Cc9M9DqnxvyhYR3ZX1pS6/IobB
         ws0DiEgbNMe/nco+bljNZj0A//iBoc9VyarNyW6tgugm5RKv27oKOtlSKOP+Eir95bK5
         PcYw==
X-Gm-Message-State: ACgBeo2sdJjm6RP0cBMSLOEkA/es6ypkliqCZ501P1evO8R91WmNw2qz
        JZdJU/HfokNlTmHRIU2qNaWCPtLWVdc=
X-Google-Smtp-Source: AA6agR5M1IyGllx0H/SA379auBedhX+CTq+VpjGbPdb4R3jGjkYJceFlhEpLJ6LqPjRjDjPxzOxr3dBAJbU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:df03:b0:1f3:396c:dd94 with SMTP id
 gp3-20020a17090adf0300b001f3396cdd94mr501620pjb.1.1659567005567; Wed, 03 Aug
 2022 15:50:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Aug 2022 22:49:56 +0000
In-Reply-To: <20220803224957.1285926-1-seanjc@google.com>
Message-Id: <20220803224957.1285926-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220803224957.1285926-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2 2/3] KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE
 masks change
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
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

Fully re-evaluate whether or not MMIO caching can be enabled when SPTE
masks change; simply clearing enable_mmio_caching when a configuration
isn't compatible with caching fails to handle the scenario where the
masks are updated, e.g. by VMX for EPT or by SVM to account for the C-bit
location, and toggle compatibility from false=>true.

Snapshot the original module param so that re-evaluating MMIO caching
preserves userspace's desire to allow caching.  Use a snapshot approach
so that enable_mmio_caching still reflects KVM's actual behavior.

Fixes: 8b9e74bfbf8c ("KVM: x86/mmu: Use enable_mmio_caching to track if MMIO caching is enabled")
Reported-by: Michael Roth <michael.roth@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Tested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c  |  4 ++++
 arch/x86/kvm/mmu/spte.c | 19 +++++++++++++++++++
 arch/x86/kvm/mmu/spte.h |  1 +
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bf808107a56b..48f34016cb0b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6699,11 +6699,15 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 /*
  * nx_huge_pages needs to be resolved to true/false when kvm.ko is loaded, as
  * its default value of -1 is technically undefined behavior for a boolean.
+ * Forward the module init call to SPTE code so that it too can handle module
+ * params that need to be resolved/snapshot.
  */
 void __init kvm_mmu_x86_module_init(void)
 {
 	if (nx_huge_pages == -1)
 		__set_nx_huge_pages(get_nx_auto_mode());
+
+	kvm_mmu_spte_module_init();
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 7314d27d57a4..66f76f5a15bd 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -20,6 +20,7 @@
 #include <asm/vmx.h>
 
 bool __read_mostly enable_mmio_caching = true;
+static bool __ro_after_init allow_mmio_caching;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
 
 u64 __read_mostly shadow_host_writable_mask;
@@ -43,6 +44,18 @@ u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
 u8 __read_mostly shadow_phys_bits;
 
+void __init kvm_mmu_spte_module_init(void)
+{
+	/*
+	 * Snapshot userspace's desire to allow MMIO caching.  Whether or not
+	 * KVM can actually enable MMIO caching depends on vendor-specific
+	 * hardware capabilities and other module params that can't be resolved
+	 * until the vendor module is loaded, i.e. enable_mmio_caching can and
+	 * will change when the vendor module is (re)loaded.
+	 */
+	allow_mmio_caching = enable_mmio_caching;
+}
+
 static u64 generation_mmio_spte_mask(u64 gen)
 {
 	u64 mask;
@@ -340,6 +353,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
 
+	/*
+	 * Reset to the original module param value to honor userspace's desire
+	 * to (dis)allow MMIO caching.  Update the param itself so that
+	 * userspace can see whether or not KVM is actually using MMIO caching.
+	 */
+	enable_mmio_caching = allow_mmio_caching;
 	if (!enable_mmio_caching)
 		mmio_value = 0;
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index cabe3fbb4f39..26b144ffd146 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -450,6 +450,7 @@ static inline u64 restore_acc_track_spte(u64 spte)
 
 u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
 
+void __init kvm_mmu_spte_module_init(void);
 void kvm_mmu_reset_all_pte_masks(void);
 
 #endif
-- 
2.37.1.559.g78731f0fdb-goog

