Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F866692C99
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 02:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjBKBqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 20:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjBKBqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 20:46:35 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628E97E8F1
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:34 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id ds10-20020a056a004aca00b0059c8629c220so3471514pfb.23
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6MGvE068epLiCiKO1TAoNVUmSZBBRkXrwHXhAiWz0E8=;
        b=MGK8U9JKxXLEY3zJNoNM7+6IniYornmEEv05U2sGpm2O9eFj4auGyNcX24Eo43wk5O
         fHZiLPKVSIf3MFAZRo8T7W98SKx92zL+WmqcssJm9yZxLK51iIVdWbS5asBU401uiVds
         05Ktad81SM43kWtp3PBg8EiF0ld/oYIFeqIdI/znw/MCZ/a8vG+K0D23LMJpovSyNHZc
         yRP7ru9d/M1lHVBsdfT8G1bbcfrJnZjIzpNyTwgrQCwPM4oLUOBvaYjLPnpSIx+ki7qj
         4tOoKaz7LslUVY+It/VYOrY5IHw2lpL5kjqnm8OCBNXsvcFQ5B6AUOBUQd63HPuB0YNP
         LIdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6MGvE068epLiCiKO1TAoNVUmSZBBRkXrwHXhAiWz0E8=;
        b=Wj+J5VWKM5PUKpKWTrjgrsT26/dChEtp1wRkYt4kTxjGz8MHsNDNayVPEK0VTXt+7R
         t0jkhPARdRw4beShScGi61yf38q+lK/SFgoPQbLzHlO81CU30bKGvXmlPaARrLinbO7u
         8R6NZaKNNFwxj+Ih+PmdPShfI9R9Dk/CAgSjE4KOnolY6+sJDvPhBqTp0R4HcejjJJ+5
         Jaiiz463/MvzA0E4llGEyoabA7w5NQ/y0bPJHKvW98Wq6u3Tt+I0DQqC5atMxXCIO1SV
         JKc4sKPi5f4Rsuz+5EcSqx1JEP4YBCvC9vCJocIprEuZ0GJtucNX+krUnIfTpGnGqWtP
         t/cA==
X-Gm-Message-State: AO0yUKXiOaC63Y2zMiyhQNJ36J9xWtcMrJL7pwhjIZoqTU2ivisyqiTv
        27ePUSSNUEO4tJyQnE34vOZZ/UtvZNo1
X-Google-Smtp-Source: AK7set/JFBGz37t345sdNfBqXNYa7A4iPZMNWpg/ZmlKXGa/6FL7sIXl00Sw+uNwrB4SiFY6PM+UfWliQ+VL
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:9602:0:b0:4da:85b1:e9c with SMTP id
 c2-20020a639602000000b004da85b10e9cmr3134854pge.100.1676079993740; Fri, 10
 Feb 2023 17:46:33 -0800 (PST)
Date:   Fri, 10 Feb 2023 17:46:20 -0800
In-Reply-To: <20230211014626.3659152-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211014626.3659152-2-vipinsh@google.com>
Subject: [Patch v3 1/7] KVM: x86/mmu: Add a helper function to check if an
 SPTE needs atomic write
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

Move conditions in kvm_tdp_mmu_write_spte() to check if an SPTE should
be written atomically or not to a separate function.

This new function, kvm_tdp_mmu_spte_need_atomic_write(),  will be used
in future commits to optimize clearing bits in SPTEs.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
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
2.39.1.581.gbfd45094c4-goog

