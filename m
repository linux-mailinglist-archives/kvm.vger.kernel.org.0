Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FB7623928
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbiKJBsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiKJBs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:48:29 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4BA63CC
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:48:29 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-352e29ff8c2so2884577b3.21
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CMXdygVTSbBCKeUpnZU+Zfw0wyqCZJgQrO/T3Nib2So=;
        b=qiHalsDEb1I+Y6YxWi8QLwXCS2CwHqMjWkXRsKiGWTPmAUzrxZeYiamee4gK0Nw/mW
         VVFSbvYm0O+KtQWjSfnaIVaDYxMkZw6oA2FIOfEuD6aOoX/DbbQalsrn1aR4eah+6Fyf
         Ojx8c20kqDCjAqraadTD1vyPH9s+5SqwKbousDrjzxKtI28RRHYTX0/vRDhLLaBj7TPZ
         rlBUC6QU/lIVEVf6WU7cLYfSVA/PULhu+tVRwkbSZtbyKUkl1RvTSjCpPYEoDNjXJAcS
         DilJvsNJ/v4iGm5m9wBcAYWUdMQAy9AsT6lyI7wBvgy7Y1kaislpFxWS3E6nyCUwH7Nm
         NJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CMXdygVTSbBCKeUpnZU+Zfw0wyqCZJgQrO/T3Nib2So=;
        b=p7cMa5YrfJnqxTRMqOIAkq0bJpC0m40IBDPI70xp6jaVPGUHq6Cgay9xv4YVFOWysq
         DIhlp9H5NR/PQmZ+f46J/vWfMXgVjiYid2vee1J50b1ejQ/VNp04B8WhbhyyceqrS3Hw
         ejpgAr3Bi5DJVfbD3fqn8XRLbfr7ZsrKayio5JF1cS3VbrYlArKR5wPrz+Ub7HTdlqnA
         91Usy3r58TNiWqhz1FBXhpoTsgaHRMu9FwtGhOcYtJ1NFC5gvenpvuwSe9XuR1Kcf9eJ
         30459xg8PKWWRSW8bmQrAx5ENRrKAiiTXpa8CMoqAGU/ZtO+ojJGuwicVtp+Q90BUccz
         qHJw==
X-Gm-Message-State: ACrzQf3uglZp/ABmxnRosPkMnG1E6r63KnrjAZL3RaWjTFnEPgna0V3d
        KWxJTz0Ylnk9GOeL1jtQ/prku8Hsftw=
X-Google-Smtp-Source: AMsMyM6G00RY/cYIWt+U8yjGU4flmrLChx2b7c/C7uxpk73UstEL/s0ZGDm9/+Wa2vhRo8cavI2BoU5+kVg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7503:0:b0:368:70a8:9791 with SMTP id
 q3-20020a817503000000b0036870a89791mr1204058ywc.197.1668044907433; Wed, 09
 Nov 2022 17:48:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Nov 2022 01:48:21 +0000
In-Reply-To: <20221110014821.1548347-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221110014821.1548347-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110014821.1548347-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Register page-tracker on first shadow root allocation
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
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

Defer registering KVM's shadow page tracker until the first shadow root
allocation now that KVM doesn't rely on the tracker to zap+flush SPTEs
when a memslot is moved or deleted.

Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0a5ae07a190e..d35a86a60d4f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3678,11 +3678,14 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 		}
 	}
 
+out_success:
+	/* Register KVM's page-tracker to react to guest writes to gPTEs. */
+	kvm_page_track_register_notifier(kvm, &kvm->arch.mmu_sp_tracker);
+
 	/*
 	 * Ensure that shadow_root_allocated becomes true strictly after
 	 * all the related pointers are set.
 	 */
-out_success:
 	smp_store_release(&kvm->arch.shadow_root_allocated, true);
 
 out_unlock:
@@ -6001,7 +6004,6 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 
 int kvm_mmu_init_vm(struct kvm *kvm)
 {
-	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 	int r;
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
@@ -6013,8 +6015,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	if (r < 0)
 		return r;
 
-	node->track_write = kvm_mmu_pte_write;
-	kvm_page_track_register_notifier(kvm, node);
+	kvm->arch.mmu_sp_tracker.track_write = kvm_mmu_pte_write;
 
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
 	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
@@ -6036,9 +6037,8 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
 {
-	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
-
-	kvm_page_track_unregister_notifier(kvm, node);
+	if (kvm_shadow_root_allocated(kvm))
+		kvm_page_track_unregister_notifier(kvm, &kvm->arch.mmu_sp_tracker);
 
 	kvm_mmu_uninit_tdp_mmu(kvm);
 
-- 
2.38.1.431.g37b22c650d-goog

