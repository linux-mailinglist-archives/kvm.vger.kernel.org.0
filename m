Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9476C3D43
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 23:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjCUWA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 18:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCUWA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 18:00:27 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F0746BC
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:26 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x4-20020a170902ec8400b001a1a5f6f272so7999032plg.1
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679436025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=r1QVmdvFEb28GS25TRtVN9nWQiQqhscO2NCp34L3b7o=;
        b=opwJdvUDTbn5pEsZvmx7JbsvKQqX9DTDLTVcDZDneAgw2XeNuQfyqUfaJ8BDieFicc
         htw/EvDpnUnSsWMjtRvCiQzu3936Zt4+eV68c9o64kQJdP0TBAGwuBj7Pchn2kfUN/Zw
         qFbhd0xQ4EglTUg5q1IYu8kxZ2ViKx4lO9khc00I1Q5LxHxiFNx+JKmHe0KJ4V7/8lsQ
         bHX13cqimtF55sdaL/xKd0LC3OrM4b5htPbDPIjWnJrfV9Q/irYTpivlzAogCf5yfPmC
         H63FMbbXhcp294JYI7jYk8czBNUemSFKskQMYTim5y1C15NbuQPX64QSEzQw5v8k80jg
         aKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679436025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r1QVmdvFEb28GS25TRtVN9nWQiQqhscO2NCp34L3b7o=;
        b=jK9lp1tXX+MpL5StOzLClBVBozMEspJx94CwCNNAPmw4wQVQOCi/CcOYk5RZx7ZUeP
         NimwDSmj6Bq66MqwLIeyTFYqyYRXR27isVCT3LpHUvjJCngYvnNqVx8ehpqFmhXNuFDV
         m67xq5xnn5c4jDC/9wSIhciIodx1LMIfeNNtbvZgh7JXIeHqn4pMrhypWbke54GxSM1d
         5C5NIRCrrNuAuh+UDW9pUWOSm3Hj5agY0MaC4e+gx9Z0qsNO2wp/SZqm2kYmHd1H2AdD
         yOAchxM2y6ddrvI0PTfXYnDesWCrWXH27tYf9vGyyJ6MvwNDgznGpl99lZ5LElc1wMON
         nkKg==
X-Gm-Message-State: AO0yUKUJvSg32OoLJ5+RMrJt30ICvujti5PnGPF8LykBg+v4KqZXZUzg
        2zDRPCzGUy+E+25gRHrY6DzJmjQ0lDE=
X-Google-Smtp-Source: AK7set+sP72192khOTQtMN//XvLV9zi2fGU3FKezienBVDWGneZ4w86csLCQ1sCf17hxPcZGAiA/4gLFHLI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4806:0:b0:50a:c1b3:ed55 with SMTP id
 h6-20020a654806000000b0050ac1b3ed55mr142164pgs.11.1679436025587; Tue, 21 Mar
 2023 15:00:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Mar 2023 15:00:09 -0700
In-Reply-To: <20230321220021.2119033-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230321220021.2119033-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321220021.2119033-2-seanjc@google.com>
Subject: [PATCH v4 01/13] KVM: x86/mmu: Add a helper function to check if an
 SPTE needs atomic write
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vipin Sharma <vipinsh@google.com>

Move conditions in kvm_tdp_mmu_write_spte() to check if an SPTE should
be written atomically or not to a separate function.

This new function, kvm_tdp_mmu_spte_need_atomic_write(),  will be used
in future commits to optimize clearing bits in SPTEs.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.h | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index f0af385c56e0..c11c5d00b2c1 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -29,23 +29,29 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 	WRITE_ONCE(*rcu_dereference(sptep), new_spte);
 }
 
+/*
+ * SPTEs must be modified atomically if they are shadow-present, leaf
+ * SPTEs, and have volatile bits, i.e. has bits that can be set outside
+ * of mmu_lock.  The Writable bit can be set by KVM's fast page fault
+ * handler, and Accessed and Dirty bits can be set by the CPU.
+ *
+ * Note, non-leaf SPTEs do have Accessed bits and those bits are
+ * technically volatile, but KVM doesn't consume the Accessed bit of
+ * non-leaf SPTEs, i.e. KVM doesn't care if it clobbers the bit.  This
+ * logic needs to be reassessed if KVM were to use non-leaf Accessed
+ * bits, e.g. to skip stepping down into child SPTEs when aging SPTEs.
+ */
+static inline bool kvm_tdp_mmu_spte_need_atomic_write(u64 old_spte, int level)
+{
+	return is_shadow_present_pte(old_spte) &&
+	       is_last_spte(old_spte, level) &&
+	       spte_has_volatile_bits(old_spte);
+}
+
 static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
 					 u64 new_spte, int level)
 {
-	/*
-	 * Atomically write the SPTE if it is a shadow-present, leaf SPTE with
-	 * volatile bits, i.e. has bits that can be set outside of mmu_lock.
-	 * The Writable bit can be set by KVM's fast page fault handler, and
-	 * Accessed and Dirty bits can be set by the CPU.
-	 *
-	 * Note, non-leaf SPTEs do have Accessed bits and those bits are
-	 * technically volatile, but KVM doesn't consume the Accessed bit of
-	 * non-leaf SPTEs, i.e. KVM doesn't care if it clobbers the bit.  This
-	 * logic needs to be reassessed if KVM were to use non-leaf Accessed
-	 * bits, e.g. to skip stepping down into child SPTEs when aging SPTEs.
-	 */
-	if (is_shadow_present_pte(old_spte) && is_last_spte(old_spte, level) &&
-	    spte_has_volatile_bits(old_spte))
+	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
 		return kvm_tdp_mmu_write_spte_atomic(sptep, new_spte);
 
 	__kvm_tdp_mmu_write_spte(sptep, new_spte);
-- 
2.40.0.rc2.332.ga46443480c-goog

