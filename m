Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9DD3508DF
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhCaVJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhCaVJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:06 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36EBC061574
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:05 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p64so2082769pga.10
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5cGMGQJTbkr5kU0eiDceomPmZqJS09u6WPxL5yh8vXM=;
        b=YuSbzqubyPg9lGhelarJ0gPJaiq9A7VtEK4raWqxa3kluRenhZ/sDnwtMZcgJAC01h
         a2HY1mt+bol9Jp0IBrZcRbmbogMxHXEk3oM6GimEh4DIxKPaqsHacH3bbc7rXdJ5CZpu
         +Cha9JokZYmBBPz7Hs6sfDRv/X7Sj/TkG37YJuC5E1SpQD+HxtybpDMfil+mC3dQRVam
         XzAJNpYUs5dBBRX5vXOaUjlQuk1eTpvhlCG8Irdi2zstVh+91YWrEyMZ4D40hsU1oZTT
         g8DfzEntCefXyIV0ov6nZQYr4xxqWbUUDVzoHLfIBydfEiJWl7OhuyKIUCv+VtIDZhas
         bmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5cGMGQJTbkr5kU0eiDceomPmZqJS09u6WPxL5yh8vXM=;
        b=t07WyPKUnUbBLZIf9vkjwul5E9F2rSUPAyfFLQuEhei0VAxU1Y4aduRTfOr6BstMcs
         zV3m8JOaaTuvT/M3YK9uqHx3ZFzNL/juGXp3br5srFivJvALFB1jkUeXOohDH4Ga/QIB
         aeR/1h83VZi0Ay4ncFWCR/zKYjz8CYWcvw/fqK6HkkHNp+JwXFNPFJEPUVq7u/JMsbE4
         3iUssp78eKQ/ETCfrMfXSw5PQYo6ou4Oi2BjBGQrzI4dCTsjJL2KRT3uyUbypkoOdRpo
         Xln9UmjIUg72kxpYimfyRlRadgrXI3syMIG97T7TKMoi7M+MwJtLNbaTthP6xU+IhoNU
         JlOw==
X-Gm-Message-State: AOAM531f0N+F29aGUvIHc8fGZ6AKltES5cFSUp10XSZO2rWe7hcUy92r
        RD3bqGq9ZbLjGjI5QbHkDi1VWySTi3R+
X-Google-Smtp-Source: ABdhPJxT/t5xzDWAujo721CFZ5zRE1k8mgJcTaGSxm7XXc2GXJdaMMuhNAJD5r0d6AJXVQ/a03h5Wf12Rpwz
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:a17:902:b182:b029:e6:5e:f2ce with SMTP id
 s2-20020a170902b182b02900e6005ef2cemr4836767plr.50.1617224945456; Wed, 31 Mar
 2021 14:09:05 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:30 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 02/13] KVM: x86/mmu: Move kvm_mmu_(get|put)_root to TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDP MMU is almost the only user of kvm_mmu_get_root and
kvm_mmu_put_root. There is only one use of put_root in mmu.c for the
legacy / shadow MMU. Open code that one use and move the get / put
functions to the TDP MMU so they can be extended in future commits.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 10 ++++------
 arch/x86/kvm/mmu/mmu_internal.h | 16 ----------------
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
 arch/x86/kvm/mmu/tdp_mmu.h      | 18 ++++++++++++++++++
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f75cbb0fcc9c..618cc011f446 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3154,12 +3154,10 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
 
-	if (kvm_mmu_put_root(kvm, sp)) {
-		if (is_tdp_mmu_page(sp))
-			kvm_tdp_mmu_free_root(kvm, sp);
-		else if (sp->role.invalid)
-			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
-	}
+	if (is_tdp_mmu_page(sp) && kvm_tdp_mmu_put_root(kvm, sp))
+		kvm_tdp_mmu_free_root(kvm, sp);
+	else if (!--sp->root_count && sp->role.invalid)
+		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 
 	*root_hpa = INVALID_PAGE;
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index fc88f62d7bd9..788dcf77c957 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -118,22 +118,6 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
 
-static inline void kvm_mmu_get_root(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	BUG_ON(!sp->root_count);
-	lockdep_assert_held(&kvm->mmu_lock);
-
-	++sp->root_count;
-}
-
-static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	lockdep_assert_held(&kvm->mmu_lock);
-	--sp->root_count;
-
-	return !sp->root_count;
-}
-
 /*
  * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
  *
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6d4f4e305163..1929cc7a42ac 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -43,7 +43,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
-	if (kvm_mmu_put_root(kvm, root))
+	if (kvm_tdp_mmu_put_root(kvm, root))
 		kvm_tdp_mmu_free_root(kvm, root);
 }
 
@@ -55,7 +55,7 @@ static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
 	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
 		return false;
 
-	kvm_mmu_get_root(kvm, root);
+	kvm_tdp_mmu_get_root(kvm, root);
 	return true;
 
 }
@@ -150,7 +150,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root) {
 		if (root->role.word == role.word) {
-			kvm_mmu_get_root(kvm, root);
+			kvm_tdp_mmu_get_root(kvm, root);
 			goto out;
 		}
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 683d1d69c8c8..2dc3b3ba48fb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -8,6 +8,24 @@
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
+static inline void kvm_tdp_mmu_get_root(struct kvm *kvm,
+					struct kvm_mmu_page *root)
+{
+	BUG_ON(!root->root_count);
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	++root->root_count;
+}
+
+static inline bool kvm_tdp_mmu_put_root(struct kvm *kvm,
+					struct kvm_mmu_page *root)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+	--root->root_count;
+
+	return !root->root_count;
+}
+
 bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
-- 
2.31.0.291.g576ba9dcdaf-goog

