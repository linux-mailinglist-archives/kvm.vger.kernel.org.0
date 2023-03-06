Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3E96AD1D1
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCFWly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCFWlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:41:47 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDAD78CAC
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:41:43 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id fa21-20020a17090af0d500b00237b14b60a4so2983366pjb.6
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ntsWJChvbXfy8t9EA+eQUOa7LNpcvZXYoCa+kOc7Xxo=;
        b=QE3wGxcpDkwXukGXapdK3z5AcvymfM9fTDSInE4aMcqqqhApqI13rGs3g8WKQUaPS/
         zZ6kNb4R7uz/pdmbRfaqJcYVYuRq+bQgvKsN86OU0tlFIWLibxnJpuqg0yKTzMCyuR1X
         pL28Sm386yDPzPua4c49qPfANPTKuZn9aWIUurbKMbZucDPpluT8Syfvw708TGu5WMO0
         hjDTHUxu7yWc5s4/oRuSPQU74v9qCJL0SWCVXIoKKH6qhy3+hgUFKF39UdJnzPCFwNtA
         PsAmluDoVGVvbeYF4h5LW3dAFwVLGK0yDNSdG3miH//Ijl6QzEc9pgGGk9eEMrDtuikC
         CFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ntsWJChvbXfy8t9EA+eQUOa7LNpcvZXYoCa+kOc7Xxo=;
        b=dlckyA6VP5z6KgjdArV4R/9aLIUCgoFaCqlKIYU+xu3QFoQHu6mEaMXVSX/24ojm4p
         53dAojxzKUVPpMhu8mNhFTs6+fty3mrfD7FG52n3KMh/I9HxEqCicoIF+MsUmw01xRJT
         gm319LwN+IqDZM8//RV5RhwJ4jFhYqKHckJvVkLwUyWrEd5Gj0PPQRSEdIx0YI+xdzRg
         Mjtogo8aGQvVcDmmBUjP8eJRPFDAnif1ZTn0sB6u9tF9kxg8eH+FN1ZgjHKdqQggcvLw
         aTkS9j9Y9WjOfIEqCBXphukbtmQrflDhZzogxSGPBvIkq5NSYFzkLLoF8giJveuzMQD0
         /BEQ==
X-Gm-Message-State: AO0yUKU8hY8fM9h3jtiqnUiCKTZJj3oMxJ6bDO84FZSkd3eh31fNj7Q0
        Y/4tyQqDLmPrc/BA7royblAvQDV8DDkT
X-Google-Smtp-Source: AK7set+ZI2aBqjIrxBqymLM25KRuDPXvrPAuiXEE5P98Cs7Ib72ELWHQ9A1FvjqxxCOH6L09ow62WHf25Ci6
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:7e11:0:b0:503:913f:77b9 with SMTP id
 z17-20020a637e11000000b00503913f77b9mr4352737pgc.6.1678142503145; Mon, 06 Mar
 2023 14:41:43 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:14 -0800
In-Reply-To: <20230306224127.1689967-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-6-vipinsh@google.com>
Subject: [Patch v4 05/18] KVM: x86/mmu: Add split_shadow_page_cache pages to
 global count of MMU cache pages
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Add pages in split_shadow_page_cache to the global counter
kvm_total_unused_cached_pages. These pages will be freed by MMU shrinker
in future commit.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index df8dcb7e5de7..0ebb8a2eaf47 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6149,7 +6149,9 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
 {
 	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
 	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
-	kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
+	mutex_lock(&kvm->slots_lock);
+	mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache);
+	mutex_unlock(&kvm->slots_lock);
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
@@ -6303,7 +6305,7 @@ static int topup_split_caches(struct kvm *kvm)
 	if (r)
 		return r;
 
-	return kvm_mmu_topup_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
+	return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
 }
 
 static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
@@ -6328,6 +6330,7 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
 	/* Direct SPs do not require a shadowed_info_cache. */
 	caches.page_header_cache = &kvm->arch.split_page_header_cache;
 	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
+	caches.count_shadow_page_allocation = true;
 
 	/* Safe to pass NULL for vCPU since requesting a direct SP. */
 	return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

