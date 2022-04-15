Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AAD503117
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355842AbiDOWBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiDOWBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:42 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE6037ABC
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:12 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id y13-20020a5e834d000000b0064fc8cd0bf1so3626539iom.14
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tskkletjI1xqy2hmf+NUDTVo6kgDSU4EL5qdYTa3BLw=;
        b=QA94h9r9pTA8GiRYxYPRCc5lnTzXtNJwZmjCbvYN9o6CVFPh0a2tzWI0hkn2GGLweA
         Txpvs213Jksx0vyr2ngPBysyiEw8KC95EbN0Ju8DT94akH1bQ62gDiZBnBpVmOCl0cU/
         aVzTHXbtTPOJrXqnXT7zTKFXplRLdZ7urB7/NYg8iYE+D1B5NQXQp/3h+iCMDQQGzAYs
         +i1QI9nvkwP3sApqy92wxAC2ykVI1oGcIkQRiYST9T63+AoQWeZ9+xAr1yQAoB7YwpSw
         L5Y0d4II8kHY6IRbv/oLjeQ9jnR7XErbOljztHLeXABbdjtB3zDvW2Om/oADovnpl9yM
         AUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tskkletjI1xqy2hmf+NUDTVo6kgDSU4EL5qdYTa3BLw=;
        b=U5vmIuN6Hr/jRvU+pyjJEmF8DJ4hx/k6CrwcRQG1Gjyvlqe+e7gMd3SfaQBS4jgbo/
         9zMivxY+IO07y+Oq5HKeY4ABOnoAruVGUOHmpN6sCh7+s2xg9wZ0Vk52wdKu3iglThfm
         FpxWIpzoo8qJfPuvhhbLuz8nD/4G5t4/cikfyXz/DIHwMbgnntrZEnx6T3n+vaA1REx5
         OrwaTBeUUViXwWwTWUY9ajqEMlV4wyDo3HcnS6tT7aTm99V/+uswFIKJj4/QA37QL+kN
         HiHUub0y2CsZw54Gcmlj4aGQPIfiDDiZZt12nb/oT1J9dzUHF9y2/Hmax5OqTFIFhqjY
         yenA==
X-Gm-Message-State: AOAM533pPHHfg0a5RlOdyaCBYmwYS/Ah7DJPmwvAz6FtEtBmvR/8gWVK
        6NCIJm4P11MVghnKnIfav05U21IRQKc=
X-Google-Smtp-Source: ABdhPJyVhtFMabjcfJB2grqI91o53/8kDGiTwPio15sftKb54bR0cux4tb8br2mZT5w8v0L5arzr0CpVpX8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:20cd:b0:2ca:c074:4ebb with SMTP id
 13-20020a056e0220cd00b002cac0744ebbmr283965ilq.73.1650059952284; Fri, 15 Apr
 2022 14:59:12 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:48 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-5-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 04/17] KVM: arm64: Protect page table traversal with RCU
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

Use RCU to safely traverse the page tables in parallel; the tables
themselves will only be freed from an RCU synchronized context. Don't
even bother with adding support to hyp, and instead just assume
exclusive access of the page tables.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5b64fbca8a93..d4699f698d6e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -132,9 +132,28 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
 	return pte;
 }
 
+
+#if defined(__KVM_NVHE_HYPERVISOR__)
+static inline void kvm_pgtable_walk_begin(void)
+{}
+
+static inline void kvm_pgtable_walk_end(void)
+{}
+
+#define kvm_dereference_ptep	rcu_dereference_raw
+#else
+#define kvm_pgtable_walk_begin	rcu_read_lock
+
+#define kvm_pgtable_walk_end	rcu_read_unlock
+
+#define kvm_dereference_ptep	rcu_dereference
+#endif
+
 static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
 {
-	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
+	kvm_pte_t __rcu *ptep = mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
+
+	return kvm_dereference_ptep(ptep);
 }
 
 static void kvm_clear_pte(kvm_pte_t *ptep)
@@ -288,7 +307,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.walker	= walker,
 	};
 
+	kvm_pgtable_walk_begin();
 	return _kvm_pgtable_walk(&walk_data);
+	kvm_pgtable_walk_end();
 }
 
 struct leaf_walk_data {
-- 
2.36.0.rc0.470.gd361397f0d-goog

