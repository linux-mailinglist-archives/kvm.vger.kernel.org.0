Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D640E644A5E
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 18:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbiLFRgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 12:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbiLFRgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 12:36:11 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536DB3AC22
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 09:36:11 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y11-20020a056a00190b00b005749340b8a8so13540230pfi.11
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 09:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rbUiksLk/ndFO2E6RSCpSBYGdIi7ojQOCeIOZeAA2ow=;
        b=Ie/mmiJHQUpEyx6oKaIMTBhaNypqhp7wR5I9PgyeMslphAOxXP9Mt0H1vtwizsJhIe
         KudAd2OjLuL/EPpuQX9326EMo5VoILq1g7QyBXb6UFkaTuiDxZclbwT36DYio2poZCsS
         QnyUIh5aI4j5k7lLeu39t1k7Ll7Jcd5AbHaDNYnuGkYcn8utG14NtPeFRh8YUFbIi8cL
         cJWfh4uSFvrE9hq19uADqys655XW12zElikxi/7jrj2UQ1uE/y7Rfbjh6LTg7OdPXF8N
         4p3XD24i3opGf7A5gtoUq/j1EaErnZ4+1m3FR0zLUPit2WLjg1bVsAfAScnCsjsWWKKN
         kj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rbUiksLk/ndFO2E6RSCpSBYGdIi7ojQOCeIOZeAA2ow=;
        b=Ftr5jXY2UdNxGlcegAADkmauV//emghb5qM1AMpBCKS2u5MSF5HVKxhmBLqCv4+jid
         WxMgD57ldSryOteACD/vhOrERfcBCqi2S+hNbHo9wEkKNUr6K2y4XjmLDQx5p2luXrAs
         SRLDa75MMKYYics5c9bM4Z6ThPpoBoH7Zn+h6ZMIny+X3WC7zpuQ4/SJMf1mNStfLmIE
         MzpSIL9pAIw8cPnICMKVopsI64V2o1FKFBG5gXfqdLKlJ6WmyunzfoWwBlfS5lZlBP7h
         6i45m1cuotR6EW+MvPm88g9EaPRFHrKc/zW2wPaNRFRaC6vmjOLeN4/UjSxC66SH0Yt3
         e9SA==
X-Gm-Message-State: ANoB5pm5OTraGFviYrqjmzuaGa8A6NJxEU8jmEzTMd/WAJJ5YTrAAI4W
        nbV2SIGQf+FsPfEFbv1G5Svg7romVr9h
X-Google-Smtp-Source: AA0mqf7CYvLk1N+e34pjvlhKeqbll+Of27+rNyiXwB2nQ8FwQUBi1/c58gdg0HYBifU3odb0bEYVaQvdni0M
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:b707:b0:189:5f3c:fb25 with SMTP id
 d7-20020a170902b70700b001895f3cfb25mr60010769pls.123.1670348170913; Tue, 06
 Dec 2022 09:36:10 -0800 (PST)
Date:   Tue,  6 Dec 2022 17:35:57 +0000
In-Reply-To: <20221206173601.549281-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221206173601.549281-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206173601.549281-4-bgardon@google.com>
Subject: [PATCH 3/7] KVM: x86/MMU: Move gfn_to_rmap() to rmap.c
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ben Gardon <bgardon@google.com>
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

Move gfn_to_rmap() to rmap.c. While the function is not part of
manipulating the rmap, it is the main way that the MMU gets pointers to
the rmaps.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 9 ---------
 arch/x86/kvm/mmu/rmap.c | 8 ++++++++
 arch/x86/kvm/mmu/rmap.h | 2 ++
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c3a7f443a213..f8d7201210c8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -891,15 +891,6 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	return true;
 }
 
-static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
-					 const struct kvm_memory_slot *slot)
-{
-	unsigned long idx;
-
-	idx = gfn_to_index(gfn, slot->base_gfn, level);
-	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
-}
-
 static bool rmap_can_add(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_memory_cache *mc;
diff --git a/arch/x86/kvm/mmu/rmap.c b/arch/x86/kvm/mmu/rmap.c
index c3bad366b627..272e89147d96 100644
--- a/arch/x86/kvm/mmu/rmap.c
+++ b/arch/x86/kvm/mmu/rmap.c
@@ -200,3 +200,11 @@ u64 *rmap_get_next(struct rmap_iterator *iter)
 	return sptep;
 }
 
+struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
+				  const struct kvm_memory_slot *slot)
+{
+	unsigned long idx;
+
+	idx = gfn_to_index(gfn, slot->base_gfn, level);
+	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
+}
diff --git a/arch/x86/kvm/mmu/rmap.h b/arch/x86/kvm/mmu/rmap.h
index 13b265f3a95e..45732eda57e5 100644
--- a/arch/x86/kvm/mmu/rmap.h
+++ b/arch/x86/kvm/mmu/rmap.h
@@ -49,4 +49,6 @@ u64 *rmap_get_next(struct rmap_iterator *iter);
 	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
 	     _spte_; _spte_ = rmap_get_next(_iter_))
 
+struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
+				  const struct kvm_memory_slot *slot);
 #endif /* __KVM_X86_MMU_RMAP_H */
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

