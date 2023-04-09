Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520D76DBEE2
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDIGaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDIGaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:30:15 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2C95FFB
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:30:14 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id x4-20020a17090a788400b002466b299ed7so549871pjk.1
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 23:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021814; x=1683613814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/JLipQQFrvuKiZZgqSunFezXBTMGs4xTeRyFEXe3jxE=;
        b=HFr2utWqya59vXbAJCQMpp2VjB40ZBlCclVNv4SVBdxwf6x7IeXH8VaVKOyXR++Ve1
         dxXCwmP0f6cOZ+5R6tTBFvqOlGMQX500RfiuFdP8Un8Gs6nLzyqgA9U0ihelgpPzMzyQ
         0SIIMmR0PgmEqEsabvQH/dmPqmc/7prfIf+0rK4nRuArGj8zzX4VYN2KWXGn/vtF9UUO
         Zbppir2TNo7qJc5ldaE3h/TQdnBZkqfy5H2c7jHW7gACJLtnDtD63iDniBliy6Gr0PXE
         jmcWT+uMFRUmZxc8xS+Uwk4YKrKy0cJfkww4w9iUPQYNYTtjw1luSAL7PLu6CrZYKNWL
         kjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021814; x=1683613814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/JLipQQFrvuKiZZgqSunFezXBTMGs4xTeRyFEXe3jxE=;
        b=gqL7Ii48fHKySyEaFJENJX2juQevIGB+bbVAI5mwRRloI8No+Z9NjQMTbPT8yzibC/
         4cwMX362TzweDwkMGYOncBmlOdn88OwpWn/kqVTRdTsYMkkh1vRN3AMJSEQWSkhurRRe
         LSRTbu0HmcywL7lZ/525+99eZ5wDBU4/UKOnSJWDvIXPXAfU46i2MfVsRbbW614J75NK
         hEhKpRLah6aDjtCbntGJiL20ZtotZ0oDAirisPKJxWmgPRuH32vFMp+1erbr41bED2cB
         11ra0KSu/J/JvZl2E2KLaLJ7Q4uBqW7qXUztCJBOBxV8BES3xFWKH+BkLyLiCTYEp7BJ
         AfNg==
X-Gm-Message-State: AAQBX9eZZzpXqGfvYIPGIDxTppWTIc+xdS0eHyZbsQit4ADVqkFdYWR0
        kCKjHyUIx1lB6CR9YCmMhVNXNFMg2LYdJA==
X-Google-Smtp-Source: AKy350bJJgCC1Xf7eUl1dkv0NTmt2rV7K6U3ZKSxeZ5bVG9Habei/jWsF7F4b5TqP9pAztaY0mX9I1IQonudmw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:495:b0:246:9c81:522 with SMTP id
 bh21-20020a17090b049500b002469c810522mr79286pjb.7.1681021813869; Sat, 08 Apr
 2023 23:30:13 -0700 (PDT)
Date:   Sun,  9 Apr 2023 06:29:53 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-7-ricarkol@google.com>
Subject: [PATCH v7 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
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

Refactor kvm_arch_commit_memory_region() as a preparation for a future
commit to look cleaner and more understandable. Also, it looks more
like its x86 counterpart (in kvm_mmu_slot_apply_flags()).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index efdaab3f154de..37d7d2aa472ab 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
+	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+	if (log_dirty_pages) {
+
+		if (change == KVM_MR_DELETE)
+			return;
+
 		/*
 		 * If we're with initial-all-set, we don't need to write
 		 * protect any pages because they're all reported as dirty.
 		 * Huge pages and normal pages will be write protect gradually.
 		 */
-		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			kvm_mmu_wp_memory_region(kvm, new->id);
-		}
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
+
+		kvm_mmu_wp_memory_region(kvm, new->id);
 	}
 }
 
-- 
2.40.0.577.gac1e443424-goog

