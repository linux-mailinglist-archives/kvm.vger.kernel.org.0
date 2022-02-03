Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C3B4A7D19
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348694AbiBCBBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348691AbiBCBBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:33 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2CEC06173B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:33 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t18-20020a63dd12000000b00342725203b5so555415pgg.16
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UjS/m788bWTTP9wb5eU5WUd6J2LTxRg7OTe2uKv1w1A=;
        b=mxPTE0pM1YB12vcQ+/Q9pS5r6Kr86decoFTctphYYzfqGHdBO/N8MTBwdyzL8Lpp5T
         tqm7+UvEeI4ufc2jgWj4ajYjLQ29XN2xr7BwrW0l6VAGajxEXno4HJ+rVwEL9ZE1gKtQ
         Qsk8mIGGCLA2MzIaLVzeAifI2YTS4vC5S7S6GbP/zVhqDW3DnY8WM2gDYxLhSM5KJz+/
         d/OeSn0Zob8/qmb8SV+/PH8WIGQy7+obzCaEjyvn0rhLNbG8YDdqcDJOZgjS4zJlmwBr
         DQG29puh4x+pdPD6iNv77SduYUzAqY44WnjF1AARZ04QIn2uf0nGryeOUg5mibp9lpOU
         /lUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UjS/m788bWTTP9wb5eU5WUd6J2LTxRg7OTe2uKv1w1A=;
        b=GpUJOIdf7EZaG5We4ZiHNjVBeYv20HA6jClv8aXK6+DgfHvtTbHpE9KwaPMEXLdgO7
         KkAwKm2IWXdpu1HvQsXEai8Jk9xxsAC5tm4KKf2audrKcM/X6TQ9H/C83nkxEkjhjD3W
         9JApdlql64GSEigyzfzYAV0sEcFsmw+ZfWKjRZHD/Lf0t0bgCDVkADGCyJewiHnkpL2h
         HT5oIy947KXgYA7JAva3h3fMty/eRjJL3FRrigj/66rALPVnGuH6cCw9KlLshHqVWLA8
         k1Fv8dsBOienlSYxoekL4gT0o+7saSVvhrc05IdZg6M9mLQs8oiootQm8cn3VwQ4yAxq
         Cdiw==
X-Gm-Message-State: AOAM532kum9gsdRKcVvB5CS/9/7zUGNkY5QoKe26Hauof1JMl4/EYNCE
        RwQP6cEhKO9iBCVKrkIr4TubDan8osdBUg==
X-Google-Smtp-Source: ABdhPJxwkiBhf2xN7XxwPzPE8ihlAl7rE8BHxyR3KnX4FSmKqrPDo008riaRJJwUj1avHHZ8qaLAWXLBcnlsNg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1342:: with SMTP id
 k2mr31952794pfu.20.1643850093337; Wed, 02 Feb 2022 17:01:33 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:48 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-21-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 20/23] KVM: Allow GFP flags to be passed when topping up MMU caches
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be used in a subsequent commit to top-up MMU caches under the
MMU lock with GFP_NOWAIT as part of eager page splitting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b3810976a27f..128f4c5a8122 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1329,6 +1329,7 @@ void kvm_reload_remote_mmus(struct kvm *kvm);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
+int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min, gfp_t gfp);
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index afa4bdb6481e..c39e7ba21fab 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -371,7 +371,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 		return (void *)__get_free_page(gfp_flags);
 }
 
-int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
+int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min, gfp_t gfp)
 {
 	int capacity;
 	void *obj;
@@ -384,7 +384,7 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	if (mc->nobjs >= min)
 		return 0;
 	while (mc->nobjs < capacity) {
-		obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
+		obj = mmu_memory_cache_alloc_obj(mc, gfp);
 		if (!obj)
 			return mc->nobjs >= min ? 0 : -ENOMEM;
 		mc->objects[mc->nobjs++] = obj;
@@ -392,6 +392,11 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	return 0;
 }
 
+int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
+{
+	return __kvm_mmu_topup_memory_cache(mc, min, GFP_KERNEL_ACCOUNT);
+}
+
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
 	return mc->nobjs;
-- 
2.35.0.rc2.247.g8bbb082509-goog

