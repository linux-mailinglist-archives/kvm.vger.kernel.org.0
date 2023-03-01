Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499C16A760B
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjCAVRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCAVRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:17:25 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6668D4D61C
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:17:24 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id c3-20020a170902724300b0019d1ffec36dso4871292pll.9
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 13:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AyQwFFR+sM3AjGhPSeNMTQXkHflwmeDdXwXEbmr5h+E=;
        b=pYMa2OtEY+vmyWWa9yw3R2ExSa6IY1i6E6t+6wzheNsXmU5EPR01Vot7JIJHT/qwak
         SkoNr2mRknbC84EJc5DKGfsdFapxqQpcB5SOG+6efwyftIotDOGzPLW1LXWiBwKHTcjg
         kovTTzH7nZIumcI/elhor2wVw/k0ndk1z55wrbw+WtxH5Lf9iTJ7Y07jAX/4Gb8WLclD
         MTWins+bfPXhOi0PfQUNOMXM1brjemy27YbFup/ZcKSlbrRpQUnQZXKyaTQlYGb8dA/v
         ue8HOohm7e0c8whS0Ge4nM62Sl8VIQ2egCyJdvQOWhZZYIO0DQb6ApOU5Wq3UTTCEXVF
         y5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AyQwFFR+sM3AjGhPSeNMTQXkHflwmeDdXwXEbmr5h+E=;
        b=ZE6kd4xyffKd+iTP/zvRXk+AjX3iRDFLu4hvQ5d69ynJ4VqQ9zDvbc6NioCHvlTH70
         pKs0b0IT9cjq/vdt8nCnGC+XKLaOeYLRnWdudgCpcttmID4cUUFwYW9hCm/4+Fc/9XAC
         OVNXsf5r/romwOLHIwX0Uc/XtbH7u0V6TjJJdIMsO9xfrGmWEnsPPfYHA5uftcfH6FXO
         2wbPCCqhlRRF7rEtVnP1HT/Y3rDnF39WFb5ISjhhW6mXT2tu0gDskFh0kvkyinG81t0I
         l4g/KVga+8H0oQRXb896qp5Lxum+/l1d3eXm8s+cXqEeYqjMwSLwTCeMTBnByahqo6Xg
         s2DQ==
X-Gm-Message-State: AO0yUKUUyOHzFb3i0RG4miXHP3fawtByUB7EuL7gLpviCTecDJDml7sA
        cgozdcnczGFt8EbRukJlqYpF+h1R9QziIQ==
X-Google-Smtp-Source: AK7set9TXehDrschYbjcA/9KfvI0u1IPieBacO26x8ZbIZC1/zC1kpDzsxUGBOvvlhI5NDOtZwBae8PR/0EA+A==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:2d8:b0:5a8:9872:2b9b with SMTP
 id b24-20020a056a0002d800b005a898722b9bmr3125821pft.1.1677704980039; Wed, 01
 Mar 2023 13:09:40 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:09:21 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-6-ricarkol@google.com>
Subject: [PATCH v5 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
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

Refactor kvm_arch_commit_memory_region() as a preparation for a future
commit to look cleaner and more understandable. Also, it looks more
like its x86 counterpart (in kvm_mmu_slot_apply_flags()).

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9bd3c2cfb476..d2c5e6992459 100644
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
2.39.2.722.g9855ee24e9-goog

