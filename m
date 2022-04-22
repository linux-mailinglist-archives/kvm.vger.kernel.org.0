Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4B450C2CD
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiDVWQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiDVWPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:35 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D92F243373
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:03 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id v13-20020aa7850d000000b0050ad8ff561aso4481572pfn.5
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6Ge2konkzI9kQNZbecDBE3zVrokGdYazCMQ6Hdz7Pwc=;
        b=AD8Y3WB05zkFGBEDy5r+SFYfa2sNP1cX5UEbVkBh7FjsDK04aTlV5V4DnMAa7Xmcc6
         OyzgE7DlP8hdtrQxCidYsNj/YK7xEf8u1swAnALBHXRy+4GkAJ35kSjO3m7L0oaqAKEU
         MnPIjC2QokD43JHymgLhIiCuaFp6/oISh+eS1yf5lmp+aRpaPWUt+uuVOE8sfKRMOww1
         N17W5qyxxqKzCwYWcggy07wrq9uFZoudUbzXx9K0B63DfbTAo5HP/+vxQNO/O+slFhIm
         hyrx4zUtX4fKgIO2JxEKn7cPxFO1lolKq407Rz6ywCy6eGUxTmsqGGwjDVI1EJA0LsB2
         Ykig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6Ge2konkzI9kQNZbecDBE3zVrokGdYazCMQ6Hdz7Pwc=;
        b=K4j7MoGqDKhmKXIzHkar3UfeaReKMxszqK4D6IZNito/6IgoL/Mh1ekPQthnturbal
         XiSe/GALGPwNmHYUYrHbIE4VY9TQ8i042JVhfK0Lrs6qay/POo81+4KxuMhCk1SGKvmF
         v9eccbp3P3siuSaAxXoZCm+gRu3mmU3G6O0qyIpbhuC9UQWfJ4j00c6fDxXhxC3MlTgq
         uFdd+nLzBXhePNz/9T9abtSosOL3z7nEqYktTHsu08Nc1ErrUFN50oI5bWFRTMmyVOTz
         0n6n1QS8LGnG+TDdYWof9fJ7/OroaYfVlJ0/jriFnYUQfny/THiizbYEZ110Z2KXpcLa
         mSFA==
X-Gm-Message-State: AOAM530m0If55O1qA5m9qQDCKoSBlUZ6iB/Gb/dztiGjLjx0DQbu/7ul
        rtPl10/bsqf6+HEuXW/fYwEGy/IM2chv6Q==
X-Google-Smtp-Source: ABdhPJyGkgN0mxn2pzRhuXRhxNLv3I8AHy2/O/qb/da6JelMMUf8mJooEx0Eo7Gmh0ca+j3lSTwpgxrQLkmutw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:14d2:b0:50a:48f0:881a with SMTP
 id w18-20020a056a0014d200b0050a48f0881amr6883386pfu.36.1650661562831; Fri, 22
 Apr 2022 14:06:02 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:35 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 09/20] KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vcpu pointer in kvm_mmu_alloc_shadow_page() is only used to get the
kvm pointer. So drop the vcpu pointer and just pass in the kvm pointer.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 943595ed0ba1..df110e0d57cf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2084,7 +2084,7 @@ struct shadow_page_caches {
 	struct kvm_mmu_memory_cache *gfn_array_cache;
 };
 
-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      struct hlist_head *sp_list,
@@ -2104,16 +2104,16 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	 * depends on valid pages being added to the head of the list.  See
 	 * comments in kvm_zap_obsolete_pages().
 	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
+	list_add(&sp->link, &kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, +1);
 
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
 
 	if (!role.direct)
-		account_shadowed(vcpu->kvm, sp);
+		account_shadowed(kvm, sp);
 
 	return sp;
 }
@@ -2132,7 +2132,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_alloc_shadow_page(vcpu, caches, gfn, sp_list, role);
+		sp = kvm_mmu_alloc_shadow_page(vcpu->kvm, caches, gfn, sp_list, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

