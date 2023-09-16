Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909E17A2CB6
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbjIPArs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbjIPAra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:47:30 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28633584
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:43:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59b59e1ac70so36324617b3.1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824760; x=1695429560; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/G55D0Iozl5Q4L7L3XRdDQbonw1AsiEUXTGGxuj8wPc=;
        b=csQv9SDwrRcSQf39Sx6bm9DsRYlgWeAgWK2Y+6yLK6q4gEOYALMCJhhYwdhb4b5zxo
         e2GLjGn4ry6HySOO8/LOLPxE085thkoLjGjsSBS35CoR2zpL3IV5ikQDtlGzLof7t2Dm
         j83iqU6lCrCpdvQ61r2OlgKwAdcJUXd9Sg6WCDc5n0OHC/BDsJ7h//D9E1l0EW6huVwk
         p+KkjG/vKWXinqVMwfjCIq5xOZGiS7F3MnFtPMaHHlOiff7sSqgWpRSS7J6QbDuUG29m
         JRGpizbFHD/5iwNLaF4BU86kOUNmz1HhflZSRDaKxA6m6DH5B5eDzp499Bf2w5CvbIVc
         jefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824760; x=1695429560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/G55D0Iozl5Q4L7L3XRdDQbonw1AsiEUXTGGxuj8wPc=;
        b=Yj0urTdKL1OUF0Ei5BLWO1YAYycxW23sE98PiZx/yAQeBHHzi0iK7qSbh38T5BSBKP
         T2r9+GHpxXJUgJ6aIhN2QzRCPuEHBfJ9qOMLa6QBUkBco+Yj04Jzhit/qPdkXx4tJJyF
         VxEHC9BTQRTAe59f1X3ES4aeO13vgBFP6loSCN0r5evUP3RbmVxwnvFcFheCvaGGfjWV
         Kb7LajiH6MgOCGJ7hgCD+hzMVrva4K4kzKWD8rVZBjFY4Tvtfd6BoXFt3KTYYaaNoyBs
         99Oivj/A7X/z98KUZpu1UyzLC92W91ALWeIKAkC23H7ek1EdXfpl9NF8frL7hY9cPddj
         EVig==
X-Gm-Message-State: AOJu0Yx7HkVAx/vNH+dGwF3Nwr1e5fW6hrpadbzE1K4UGtFCFb4DHI4d
        kkw4Hg+CNhrOXfmNKkdiDCsGL0YU8wk=
X-Google-Smtp-Source: AGHT+IEu4LKiKIxo6HtVgL2+2J2GN4b9tQ/t/zl3bNf2s0cW3ucEZNxnVHwiHGL0QnZxVMYkz5JWWOWVink=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b609:0:b0:592:7a39:e4b4 with SMTP id
 u9-20020a81b609000000b005927a39e4b4mr105053ywh.6.1694824760295; Fri, 15 Sep
 2023 17:39:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:39:14 -0700
In-Reply-To: <20230916003916.2545000-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003916.2545000-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003916.2545000-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: x86/mmu: Open code walking TDP MMU roots for
 mmu_notifier's zap SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the "inner" TDP MMU root walker when zapping SPTEs in response to an
mmu_notifier invalidation instead of invoking kvm_tdp_mmu_zap_leafs().
This will allow reworking for_each_tdp_mmu_root_yield_safe() to do more
work, and to also make it usable in more places, without increasing the
number of params to the point where it adds no value.

The mmu_notifier path is a bit of a special snowflake, e.g. it zaps only a
single address space (because it's per-slot), and can't always yield.

Drop the @can_yield param from tdp_mmu_zap_leafs() as its sole remaining
caller unconditionally passes "true".

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 13 +++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h |  4 ++--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e1d011c67cc6..59f5e40b8f55 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6260,7 +6260,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	if (tdp_mmu_enabled) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
-						      gfn_end, true, flush);
+						      gfn_end, flush);
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6c63f2d1675f..89aaa2463373 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -878,12 +878,12 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
  * more SPTEs were zapped since the MMU lock was last acquired.
  */
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
-			   bool can_yield, bool flush)
+			   bool flush)
 {
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
-		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
 
 	return flush;
 }
@@ -1146,8 +1146,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
-	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
-				     range->end, range->may_block, flush);
+	struct kvm_mmu_page *root;
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false, false)
+		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
+					  range->may_block, flush);
+
+	return flush;
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..eb4fa345d3a4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -20,8 +20,8 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush);
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
+			   bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-- 
2.42.0.459.ge4e396fd5e-goog

