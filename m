Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAB86AD1D4
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCFWmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjCFWlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:41:47 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51F77C9DD
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:41:45 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536b7eb9117so117102227b3.14
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142505;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cqnpRtg+h63StLNiA50bWnsxI9nJr8KaP+9nXax4nBE=;
        b=ACVU2Ak73DEsJyCD1CYnIUNV7DZqssWv57lrpw9xJcDfooRtDa2tY3LBqbvNcDU3KP
         hhYlgY79kRm0fgbdafmrzxHRgKfPAEwLXCwahNQwzRNxhmAyfBYAPK5few9foF3yaGPd
         /lcFH9jY5YfuOoMwi8e+ez0gG0qGiMaP8D2CYlANXgrHPRHw1P5HlftE5B8zD84EaxRI
         q7zgM/XeA3Fe4WbCdFWT+96EPjGGWl6cIhWMfg76bGxYmkk0ltneRvBruzuQ5PqN2XDq
         54VqqvM9F19QX4nQqAn3F5PtGzHLbFGu+QsPM4zutD5JATaZxYhRaGPqEj/cObP2REkH
         4SGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142505;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cqnpRtg+h63StLNiA50bWnsxI9nJr8KaP+9nXax4nBE=;
        b=Mo3hMKfsWoh3STo9rdS1hPS+xffO19e28eXbbMwye99ufcjZaPSNRUXiv87pGHjCqL
         sWBITJSIw0klbakPzqkLY64oefgaFh2xXg2wAVDIfc3rxS4TN3dSd1hugTHca4X8L/0z
         33abG7+sT+/bbSantkYsZavT5D1Tym/3SHltgeMbAYHQIHfklpffYNqBnxsatNwR9byA
         1c5lULQFpazQGl/3/FsL5RzuxlafVfs/VHt/vL7ymKKZh9nc8SB/iDd0Qf09E8MzEaRJ
         TsBVxHsBoZMf3mC6GpZEk1Er5HqSlvVVqHqMvJF9Bj63gbngsAOj2BFqkgSM5obkYB7u
         Gu6A==
X-Gm-Message-State: AO0yUKXHg7QwyokO8lsDgmFIjc5KA8BVeQPAikEojpadiZoBVKCrDynR
        TWyia9+P3CboX8qMlmzrwcuqyvmEifEY
X-Google-Smtp-Source: AK7set8kXl/my/i/lLk02KsOkXov6TpYpA7DKlG4AzS8XL9UZfw/8EVyvgNRviAycRks9Qvkwea5EqBRmcfc
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6902:10e:b0:98e:6280:74ca with SMTP id
 o14-20020a056902010e00b0098e628074camr5314707ybh.1.1678142504847; Mon, 06 Mar
 2023 14:41:44 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:15 -0800
In-Reply-To: <20230306224127.1689967-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-7-vipinsh@google.com>
Subject: [Patch v4 06/18] KVM: x86/mmu: Shrink split_shadow_page_cache via MMU shrinker
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use MMU shrinker to free unused pages in split_shadow_page_cache.
Refactor the code and make common function to try emptying the page cache.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0ebb8a2eaf47..73a0ac9c11ce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6696,13 +6696,24 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
+static int mmu_memory_cache_try_empty(struct kvm_mmu_memory_cache *cache,
+				      struct mutex *cache_lock)
+{
+	int freed = 0;
+
+	if (mutex_trylock(cache_lock)) {
+		freed = cache->nobjs;
+		kvm_mmu_empty_memory_cache(cache);
+		mutex_unlock(cache_lock);
+	}
+	return freed;
+}
+
 static unsigned long mmu_shrink_scan(struct shrinker *shrink,
 				     struct shrink_control *sc)
 {
 	struct kvm *kvm, *next_kvm, *first_kvm = NULL;
-	struct kvm_mmu_memory_cache *cache;
 	unsigned long i, freed = 0;
-	struct mutex *cache_lock;
 	struct kvm_vcpu *vcpu;
 
 	mutex_lock(&kvm_lock);
@@ -6716,18 +6727,15 @@ static unsigned long mmu_shrink_scan(struct shrinker *shrink,
 		list_move_tail(&kvm->vm_list, &vm_list);
 
 		kvm_for_each_vcpu(i, vcpu, kvm) {
-			cache = &vcpu->arch.mmu_shadow_page_cache;
-			cache_lock = &vcpu->arch.mmu_shadow_page_cache_lock;
-			if (mutex_trylock(cache_lock)) {
-				if (cache->nobjs) {
-					freed += cache->nobjs;
-					kvm_mmu_empty_memory_cache(cache);
-				}
-				mutex_unlock(cache_lock);
-				if (freed >= sc->nr_to_scan)
-					goto out;
-			}
+			freed += mmu_memory_cache_try_empty(&vcpu->arch.mmu_shadow_page_cache,
+							    &vcpu->arch.mmu_shadow_page_cache_lock);
+			if (freed >= sc->nr_to_scan)
+				goto out;
 		}
+		freed += mmu_memory_cache_try_empty(&kvm->arch.split_shadow_page_cache,
+						    &kvm->slots_lock);
+		if (freed >= sc->nr_to_scan)
+			goto out;
 	}
 out:
 	mutex_unlock(&kvm_lock);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

