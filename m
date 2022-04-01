Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8204EF950
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350718AbiDAR6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350694AbiDAR6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:09 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A351AF501
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:19 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p21-20020a631e55000000b00372d919267cso2025190pgm.1
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W+wK5vxPR/QvP8f06+LL6qG83douEveyqaG4cfdgLaY=;
        b=UlIX32ER5ckYEDHWAIcjYr1jnfgt+txi+GTB7aQ575YuSQEhVBgxyCUID6hNAgokFE
         i76MKrGhcCti1IAqqtc8kmHq8LqNd7RHGUdhQj5N55jui7o41Er8H+t8k78BKld1GGlF
         1VOlV5WFmwGA6KgQUp2Zp1tMkKdYXozagaTpFsbpYSaFotNIcx7eaEFtAXC+ZnpCROYq
         ABsmzYy5wYQds//B5QF75M7rFYH+fy/3noPiqdzNNeN7P/vT017vKaxWsaHrKZktu0mv
         qnRJyh8yDxMicnr56dYAjntxpQ2hWjBPYb0U8saUvcnyua7EEZ2oOdLzLWIpXm5jfysP
         Is+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W+wK5vxPR/QvP8f06+LL6qG83douEveyqaG4cfdgLaY=;
        b=fkIkfK6SkIK8eO1nBwp4Ylp1MATNIyJB0b8dOW+jYqsCIV25mSIpqRL2DVyA4rxYp8
         9SQkQvkmGOHJZXJ6rz9NEz9YLTNHzvUl2Gy9T+JEtlRD/3c/VejZvxEBNEAfwrbGj6YT
         H6lL+Lf8eTVGvPpyc9CPZWXZl4Aer+mp0/eavwekG0TCt4L5E10QOTQ1LTpZTsmA4lTQ
         6x6qjXipP14E65arK95dC7p5meRnx0FHReDjTMKyc2L5K20H0qQWLaiSG8YHOFUqoSWm
         xVeuGJOIkE8nu9+bm2+RUbkTP4hE3CE0vLt0XiggwgsY+/R+4gZZKaBUWvhtTBJR0mPm
         3NEQ==
X-Gm-Message-State: AOAM533es+tQv4TbkgPY9nbgJC0QEljL2XUMr0ArQeiDJRB6NqAYssYl
        ueXaxTp3Bf38NC0dTpgBAfwJsATTyKMRAw==
X-Google-Smtp-Source: ABdhPJxYuSmgflitVWDuHEX61iCJV7QQcSTVJ1SS0S3w86E/w3yONDjqYny6QBsz2LrR6va1k+Ws4RIi9FnL+w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4c84:b0:1c7:7769:3cc7 with SMTP
 id my4-20020a17090b4c8400b001c777693cc7mr13054532pjb.73.1648835779185; Fri,
 01 Apr 2022 10:56:19 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:42 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 11/23] KVM: x86/mmu: Use common code to allocate shadow
 pages from vCPU caches
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

Now that allocating shadow pages is isolated to a helper function, use
it in the TDP MMU as well. Keep tdp_mmu_alloc_sp() to avoid hard-coding
direct=true in multiple places.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 8 +-------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 27996fdb0e7e..37385835c399 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1704,8 +1704,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
-						      bool direct)
+struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5f91e4d07a95..d4e2de5f2a6d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -173,6 +173,7 @@ void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked);
 
+struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direct);
 void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8b00c868405b..f6201b89045b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -269,13 +269,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *sp;
-
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
-	return sp;
+	return kvm_mmu_alloc_shadow_page(vcpu, true);
 }
 
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
-- 
2.35.1.1094.g7c7d902a7c-goog

