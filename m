Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BA26AD1D0
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjCFWlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjCFWlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:41:45 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ED474337
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:41:42 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id la3-20020a170902fa0300b0019ca5ddecedso6597923plb.1
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IgIlDEBO3hBgEG9gel6dE65YzklyZJEz6k7NHt2Zk6M=;
        b=aAvXgQFxXMRp/VPlQA8gq3OEIOGeRr56iAvWaFd6sstiqZr0Zawx9Z398mOWpF+2Ud
         GRTkoNY101GNHpcTsMf0UfKI6VXc6fyrnLm4lp1Mr1+l2xUTwzVYOFZD6AH+npaWkXzm
         3aVgO3L1QbuLnMYJtuEMmhi+TIf8Ef0zRZKrntMy8bqSdfKHIRSIFPaOHuXUUgXVwfua
         5uIafCmWgGLxcKgUBnymT+gLziBpdLr/rAyCowZavzGge+VcmZ+PgnXdiVSwS4iOFcqu
         R4/QgcOIHxCYrTIQfho49OhRUXfgBwI5UoNN71e76zPwkKJ6vOhW5ITrJRul8rrZFSQ/
         AtOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IgIlDEBO3hBgEG9gel6dE65YzklyZJEz6k7NHt2Zk6M=;
        b=3fq0IPaxHJjPCcRg09JzJIkC6l1J/6okDuxzs8dQdksIYvAumWyn836w+dLe9tHvU2
         3vnVv4CTSiHh8CFrbzOaxNdDcVWylH7MCBk3CgicNtdFdF0wvZXfImyRwtXTPGBIQGFS
         k881m6StLV46d76MJBipKtggY4cd27ORp3mcbOLSRk/kCS1czi4yhErU+lo9qh6tKMPr
         mMkaP4xiXV1vG5pa/cPR8Ois0eF+4f/btWb/EZOMqitTge0jRmvP8n27TjK6WC4T2A66
         LStwnxOqjTiVtM1yj9N/8zeHDbiNgXf34W2JWEzELckv4WugFi5MC+djCRe6VKnF38EY
         wf0A==
X-Gm-Message-State: AO0yUKUS9517zjyHjDnh/ATb2akDA4tQjO0A7gYWWLWQevfw7Ya/e67c
        yiyK5LL8zrlEMV4SR7adezhtsjkX0ZPX
X-Google-Smtp-Source: AK7set/En9Q/8v9ziiTVNBNjcULdErMB0XNxJpifIOtjunDo7/A+/RXyjrxTrsbzR235Afaol2oomqlvrqIZ
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:903:449:b0:19a:87dd:9206 with SMTP id
 iw9-20020a170903044900b0019a87dd9206mr4869867plb.0.1678142501654; Mon, 06 Mar
 2023 14:41:41 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:13 -0800
In-Reply-To: <20230306224127.1689967-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-5-vipinsh@google.com>
Subject: [Patch v4 04/18] KVM: x86/mmu: Shrink shadow page caches via MMU shrinker
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

Shrink shadow page caches via MMU shrinker based on
kvm_total_unused_cached_pages. Traverse each vCPU of all of the VMs,
empty the caches and exit the shrinker when sufficient number of pages
have been freed. Also, move processed VMs to the end of vm_list so that
next time other VMs are tortured first.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 55 +++++++++++++++++++++++++++++++++++-----
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      |  6 ++++-
 3 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 13f41b7ac280..df8dcb7e5de7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6693,16 +6693,57 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
-static unsigned long
-mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
-{
-	return SHRINK_STOP;
+static unsigned long mmu_shrink_scan(struct shrinker *shrink,
+				     struct shrink_control *sc)
+{
+	struct kvm *kvm, *next_kvm, *first_kvm = NULL;
+	struct kvm_mmu_memory_cache *cache;
+	unsigned long i, freed = 0;
+	struct mutex *cache_lock;
+	struct kvm_vcpu *vcpu;
+
+	mutex_lock(&kvm_lock);
+	list_for_each_entry_safe(kvm, next_kvm, &vm_list, vm_list) {
+		if (first_kvm == kvm)
+			break;
+
+		if (!first_kvm)
+			first_kvm = kvm;
+
+		list_move_tail(&kvm->vm_list, &vm_list);
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			cache = &vcpu->arch.mmu_shadow_page_cache;
+			cache_lock = &vcpu->arch.mmu_shadow_page_cache_lock;
+			if (mutex_trylock(cache_lock)) {
+				if (cache->nobjs) {
+					freed += cache->nobjs;
+					kvm_mmu_empty_memory_cache(cache);
+				}
+				mutex_unlock(cache_lock);
+				if (freed >= sc->nr_to_scan)
+					goto out;
+			}
+		}
+	}
+out:
+	mutex_unlock(&kvm_lock);
+	if (freed) {
+		percpu_counter_sub(&kvm_total_unused_cached_pages, freed);
+		return freed;
+	} else {
+		return SHRINK_STOP;
+	}
 }
 
-static unsigned long
-mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long mmu_shrink_count(struct shrinker *shrink,
+				      struct shrink_control *sc)
 {
-	return SHRINK_EMPTY;
+	s64 count = percpu_counter_sum(&kvm_total_unused_cached_pages);
+
+	WARN_ON(count < 0);
+	return count <= 0 ? SHRINK_EMPTY : count;
+
 }
 
 static struct shrinker mmu_shrinker = {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0e..5cfa42c130e0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1361,6 +1361,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
 int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
+void kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..536d8ab6e61f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -430,7 +430,7 @@ int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 	return mc->nobjs;
 }
 
-void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+void kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc)
 {
 	while (mc->nobjs) {
 		if (mc->kmem_cache)
@@ -438,7 +438,11 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 		else
 			free_page((unsigned long)mc->objects[--mc->nobjs]);
 	}
+}
 
+void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+{
+	kvm_mmu_empty_memory_cache(mc);
 	kvfree(mc->objects);
 
 	mc->objects = NULL;
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

