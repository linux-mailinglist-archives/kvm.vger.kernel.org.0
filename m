Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBCB4EF94A
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350703AbiDAR6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350684AbiDAR6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:08 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC6124B5F2
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:18 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e15-20020a17090ab38f00b001c9989ae56cso1919682pjr.9
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9irR3brB5K4k6kskWzWAbqG40+EEbVRaPIvCDPrQqZc=;
        b=TTHccN07Kc2+dKX/CQM4O229WOCMUEIEZjrDqAkCum2pWRxXyep/RtD21aVHTzWJ0u
         5Ur/7qOrscd0hKtzG7s1EiErU9Vn5N7nHtLcCGMtzTi3YMoFLmHW94dw6Gq8G0YshxYY
         MXs/f+M/+N5rlpf0p71rU9X8qWgGkVAjsH0i1IRyHKq8aV01lhAROqIUxZdIBEdQ6Fn7
         o/5H/YoPwviW5zcmK5mwsLjoCqpLLJwdhb4vCxGtiGEedukX7RGb51wslmYlEJfKZvrb
         xua3zBzP8zwd6jU0yexNhL/1HTixfROGNf25yDDwoHh2EgdS6uv8nRoFcKEn2F6VBDv0
         gMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9irR3brB5K4k6kskWzWAbqG40+EEbVRaPIvCDPrQqZc=;
        b=xt109vQTSKJiUcKdydDlEQjyqfSlAv7m5cRyo3BLKu6sao9OWf4Fs/mRsx+3zvNjjY
         0aA2efupZarPbE7cXnDVeJk6CU6rNuUgrYNVkj0ZsdW5DxBxJSTGL0kUkjlv5Z7EkgeR
         z4UsZ/a1dr8xFr9McMdaeEHY7vr20/Zj8mz+6WBhun6yIdXtlIAvN6+o58SiqMjzlG/e
         +gRJKMdmc79L1cj9GI0kPYB1bN3UOGQeuGlz65trF8VXYU5Nuxmr/3coliijq/miWhbZ
         uNIezRnCqlaiZ+PZoIADb5waYEtHcWxNirfShV+XX+SYGQPMhVuZbcKgvWsEWtAJIBqb
         7M8g==
X-Gm-Message-State: AOAM531GHL/NWmnGkbMRKeLwq/u7gZwmC+RpTo2QnQrRHFS+qYksx+Lb
        /v+iay0A750CMIXANv4E+XpoLawQYCU82w==
X-Google-Smtp-Source: ABdhPJxg+/Q/17NTgwHdrbJN0RELEFI4TA91YpU0RNqlmFBBNYRSy1Zgxz7Lu9EEyB4Z0QtTYObcl0Q0cVZDDA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:118c:b0:1ca:307:9b50 with SMTP id
 gk12-20020a17090b118c00b001ca03079b50mr13195653pjb.26.1648835777771; Fri, 01
 Apr 2022 10:56:17 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:41 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 10/23] KVM: x86/mmu: Use common code to free kvm_mmu_page structs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a common function to free kvm_mmu_page structs in the TDP MMU and
the shadow MMU. This reduces the amount of duplicate code and is needed
in subsequent commits that allocate and free kvm_mmu_pages for eager
page splitting. Keep tdp_mmu_free_sp() as a wrapper to mirror
tdp_mmu_alloc_sp().

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h | 2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 3 +--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 657c2a906c12..27996fdb0e7e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1669,11 +1669,8 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
+void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
-	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
-	hlist_del(&sp->hash_link);
-	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
@@ -2518,6 +2515,9 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
+		MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
+		hlist_del(&sp->hash_link);
+		list_del(&sp->link);
 		kvm_mmu_free_shadow_page(sp);
 	}
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index a0648e7ddd33..5f91e4d07a95 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -173,4 +173,6 @@ void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked);
 
+void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 34e581bcaaf6..8b00c868405b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -64,8 +64,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
-	free_page((unsigned long)sp->spt);
-	kmem_cache_free(mmu_page_header_cache, sp);
+	kvm_mmu_free_shadow_page(sp);
 }
 
 /*
-- 
2.35.1.1094.g7c7d902a7c-goog

