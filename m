Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0F3672593
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjARRxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjARRxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:53:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8354DE3D
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k135-20020a25248d000000b007d689f92d6dso12408372ybk.22
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yUbgpWda+dccBvsvErJkX1PAtQUerfBikR5Rk5rhVEE=;
        b=bU5qpPAsWECyf8Tu1U1RR1RAql4O3IKPordj8Fa72lBuMimqzqCYrcl4rP42ZPh9E3
         weFpA8IGGsRUZUr5pjxd/K6JfkGjVDYt3x3gmZ1bNvx7xDo67oFFTfYjLFlSoVbIVTB2
         q7Ker8NiVidCQ6lJvI+cWYF0WgB3vgNW6VGma9goSvGedC+H31bpiHILPcVHzHX9mzDs
         f6UzTIgyGLiON7MwBnqZ2l4P5HNHhqlkQKCewvf1W64c3vHEIf9KkVbQSont6cB0L6Ip
         gcRMfjl5/N7TSBRe3tGiE1wcJwkloHd+dWTqUqBS2W+t05T+eVBZNpN77X8JUy/ZwU7X
         LV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yUbgpWda+dccBvsvErJkX1PAtQUerfBikR5Rk5rhVEE=;
        b=YF3eDVd1oKMjgMY6UJYIaZ0EaY9pqT0oRBtwG4elgQrAhpGQm7saKk1J3UuHx3Y2QM
         ySp/cubKgb1nX3mw0COr+cIgcLMau7acb1kGpQ3PAgRNXgweH4IUqaQH2i+oH1etxcEw
         l8og/k4YF+a4LsWeORJZs0lYOyXhtDlIt+Av+jgh51paZeDWTrwYAnud/PWX5R6lOhXp
         dOvbjYp4Gd2Buc6a0E2HyQRPG1rClp7saVCCaPqmp0QYRyndeiVdlYutkGnbJkpUuRz1
         YuhK4KSaRPuD91s1aatfVzoWUaWbYuJbWI5pLfomR3T+BQvurEH9Jyl2wSVA9usJeNDB
         Eshg==
X-Gm-Message-State: AFqh2kq5VoBaKoVRBOGHyofQLYqN1buOHKUBfw6aA2b9K9j8iDh8Xm3V
        uP1YgrbwQHFACl1ljORJOMQE4o0W5FxqTQ==
X-Google-Smtp-Source: AMrXdXsSeUOvOwHjz9VyKlCk6Y4tbjdavwcxNKb5cV6TaKCYC6dKVkiarPFDPgfvAAx/jiGsFGnJeITKWCqn4g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:e702:0:b0:6fa:5536:7e2 with SMTP id
 e2-20020a25e702000000b006fa553607e2mr1232248ybh.295.1674064392516; Wed, 18
 Jan 2023 09:53:12 -0800 (PST)
Date:   Wed, 18 Jan 2023 09:53:00 -0800
In-Reply-To: <20230118175300.790835-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230118175300.790835-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230118175300.790835-6-dmatlack@google.com>
Subject: [PATCH 5/5] KVM: x86: Drop union for pages_{4k,2m,1g} stats
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
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

Drop the union for the pages_{4k,2m,1g} stats. The union is no longer
necessary now that KVM supports choosing a custom name for stats.

Eliminating the union also would allow future commits to more easily
move pages[] into common code, e.g. if KVM ever gains support for a
Common MMU (see Link below).

An alternative would be to drop pages[] and have kvm_update_page_stats()
update pages_{4k,2m,1g} directly. But that would make it harder to move
the page stats logic into common code.

No functional change intended.

Link: https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +--------
 arch/x86/kvm/x86.c              | 6 +++---
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d2bc08794e4..4423184070cd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1457,14 +1457,7 @@ struct kvm_vm_stat {
 	u64 mmu_recycled;
 	u64 mmu_cache_miss;
 	u64 mmu_unsync;
-	union {
-		struct {
-			atomic64_t pages_4k;
-			atomic64_t pages_2m;
-			atomic64_t pages_1g;
-		};
-		atomic64_t pages[KVM_NR_PAGE_SIZES];
-	};
+	atomic64_t pages[KVM_NR_PAGE_SIZES];
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..66dcd4196ab0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -240,9 +240,9 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, mmu_recycled),
 	STATS_DESC_COUNTER(VM, mmu_cache_miss),
 	STATS_DESC_ICOUNTER(VM, mmu_unsync),
-	STATS_DESC_ICOUNTER(VM, pages_4k),
-	STATS_DESC_ICOUNTER(VM, pages_2m),
-	STATS_DESC_ICOUNTER(VM, pages_1g),
+	__STATS_DESC_ICOUNTER(VM, pages[PG_LEVEL_4K - 1], "pages_4k"),
+	__STATS_DESC_ICOUNTER(VM, pages[PG_LEVEL_2M - 1], "pages_2m"),
+	__STATS_DESC_ICOUNTER(VM, pages[PG_LEVEL_1G - 1], "pages_1g"),
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
 	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
-- 
2.39.0.246.g2a6d74b583-goog

