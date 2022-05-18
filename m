Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8939652BD3F
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbiERNvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbiERNvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:51:24 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF2215F6F7;
        Wed, 18 May 2022 06:51:23 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id dk23so3949859ejb.8;
        Wed, 18 May 2022 06:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6N1o2ROy8DgIOyd4uQrp3YPg4pjfgpNZnUXJgAERhvc=;
        b=fbkmQ6rcduAwy3HwnfR4oHDS2kOAY4sHRo3/F50ru+ctsL44MeKzZzP7J7ziUmhVZF
         IkzS1XI0L06c6MXPA5ooF+ahzboXFR7W+LnqwYC3T5WFv2MkPAJVu5bHEnbUN1eHM5KK
         kzkjTAKS2Gfp9bnG49zDw4K6Vqhdt9M/y6C2S8Jo0zztEyFmMqbDSemkfhyUuq41g/8J
         MzA+9NjDJ1edLBqA6ynULHoqMTZwxaMRKiAGFveVJzvPBvKGNEYkzv5/+RCzxoF4E8CU
         fYP4jWsAQcX/kYwxP4xVvItlkW/nRWtgK2e2duG0YSIvvmHIF9edVjBC52P9l8NdaCpu
         RSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6N1o2ROy8DgIOyd4uQrp3YPg4pjfgpNZnUXJgAERhvc=;
        b=YUjQzucZ+HTFLX7+U+WZiZE1ga0QtYladsQkrUpxYuUr3UuPxdnmN8dJPwMsamNnDX
         rKwCzi0o/pv5hZMp0MBo1OHWGLcsXS+QDz948s2kqCU0mkGxMe0wspBY2zIhlH0Mhz8l
         Qw4Eit2HvC2En1bqG0L5CzGHG+VUZRS+oeW6M/U16UgIgyRwr7PwgpMCvD/VQ1JdCFFw
         qPekdTD/16sAZncDalD3qOVPYNp2pEQpN0iQucRAqPibYbAWwEKRpT+B2aTHj00KYmqe
         4k9NOOlSKh771+6wbFZ97u4e+RQRe/GmMwk19Ru351rAU1vYmRPR+Ij8SQgHVjYKwqml
         aZ6g==
X-Gm-Message-State: AOAM530b50VB3ga2bVtLI8dZAmjtNbeb6Zmd/4sYq5byiW01TbrkjGjC
        nIDq7axPxHsrTp/is84kc63xQjY6Bk0=
X-Google-Smtp-Source: ABdhPJxmxjiHo36vZ5Wg1LlY8idS8PDR045ppaLOd13tw6XWfqrJzu64BDS9/ebNgZX+o2gCC9DHzg==
X-Received: by 2002:a17:907:160c:b0:6f4:4b2c:8e53 with SMTP id hb12-20020a170907160c00b006f44b2c8e53mr24484678ejc.10.1652881881433;
        Wed, 18 May 2022 06:51:21 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id j11-20020aa7c34b000000b0042ac6410ca1sm1369642edr.16.2022.05.18.06.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:51:21 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Use try_cmpxchg64 in tdp_mmu_set_spte_atomic
Date:   Wed, 18 May 2022 15:51:11 +0200
Message-Id: <20220518135111.3535-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use try_cmpxchg64 instead of cmpxchg64 (*ptr, old, new) != old in
tdp_mmu_set_spte_atomic.  cmpxchg returns success in ZF flag, so this
change saves a compare after cmpxchg (and related move instruction
in front of cmpxchg). Also, remove explicit assignment to iter->old_spte
when cmpxchg fails, this is what try_cmpxchg does implicitly.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
Patch requires commits 0aa7be05d83cc584da0782405e8007e351dfb6cc
and c2df0a6af177b6c06a859806a876f92b072dc624 from tip.git
---
 arch/x86/kvm/mmu/tdp_mmu.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 922b06bf4b94..1ccc1a0f8123 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -633,7 +633,6 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					  u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
-	u64 old_spte;
 
 	/*
 	 * The caller is responsible for ensuring the old SPTE is not a REMOVED
@@ -649,17 +648,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
 	 * does not hold the mmu_lock.
 	 */
-	old_spte = cmpxchg64(sptep, iter->old_spte, new_spte);
-	if (old_spte != iter->old_spte) {
-		/*
-		 * The page table entry was modified by a different logical
-		 * CPU. Refresh iter->old_spte with the current value so the
-		 * caller operates on fresh data, e.g. if it retries
-		 * tdp_mmu_set_spte_atomic().
-		 */
-		iter->old_spte = old_spte;
+	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
 		return -EBUSY;
-	}
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			      new_spte, iter->level, true);
-- 
2.35.1

