Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8224D5694
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbiCKA0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241985AbiCKA0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:26:45 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1331A1C7D
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:43 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y7-20020a626407000000b004f6d39f1b0fso4187997pfb.5
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PR1rQAV6XpL1OAtut/tZohbNM2n5NWW4hR39uHFMmHs=;
        b=JREOgPoLzDDtiHf1IB99ZCsJV+z9ufBWFVMkpURvetyp3jEyGAs2o6YEPskH74BNqH
         7WmF26FHEoNxVCox407leSficGgH5ww6LB5K5LSaGEZcVddfv47Z0KQDZ2OSEncfuw9m
         92v7Hbt/vGHys2QQB1nnUcKUyOrNd0rhX+hL0MUHBikUFb4TL3LThU4aUj+pbscZTx8A
         rpGIRCeOg8KXOwzgrp+EQFNMUn9ArnU47X2XXyWsaFCppowp5wxUCU5HIdt94UO5U9vW
         OZslnV1bvhlKMGwicyF96n8kXJdz/1GSq5xk81YxfldwUaudK35H+Jy/D7nJlNcxqF1P
         gXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PR1rQAV6XpL1OAtut/tZohbNM2n5NWW4hR39uHFMmHs=;
        b=UP34V4w5/rxr1RaNeAWMC1moswU7oJty1a9GrZ1LhpijsWFhf+QdwkCkR7xo2nSG9i
         n52VoajcSCid0e153grAtmrmm/hzHRsmsUsJpBT21ESkGCLK6Tr/dos4cVCTHMiHgVH3
         AFJ39i61mUImYbybh9L58acwJxT+tJEd6vuNE2QXrdtA6nZD3LJlpZ/KgwebghQz3GB1
         bxfGW4ayb+3+Woapiq7RaupENSJKw0XefV/gYehmcDfhZgUs+OxpmCueURgVw+PUiIOt
         Nw+pJF+NE9GeYgTTGsGkKA3/PKlh/WVwoGilZK6A5KEhT6AotfA4ZeB4cJygcXvds9rw
         GyFg==
X-Gm-Message-State: AOAM533gOpbs0RV9rgF6suz2RMKdcJuLtVlisgS4UZOdvPFCzjwTqnnx
        Kp97iIkTx56Ro5bim018gzdJtXzrk65G2g==
X-Google-Smtp-Source: ABdhPJy72cfT+ItACidnNCLuDyWXf6ABkTliWSk/elCD++cwKTACMZ9AqHdEBI5pX6/vwsZztFdxcxA1tFgWPw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:d486:b0:151:8e66:621c with SMTP
 id c6-20020a170902d48600b001518e66621cmr7683225plg.141.1646958343059; Thu, 10
 Mar 2022 16:25:43 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:09 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 07/26] KVM: x86/mmu: Separate shadow MMU sp allocation from initialization
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

Separate the code that allocates a new shadow page from the vCPU caches
from the code that initializes it. This is in preparation for creating
new shadow pages from VM ioctls for eager page splitting, where we do
not have access to the vCPU caches.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 519910938478..e866e05c4ba5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1716,16 +1716,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	if (!direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	/*
-	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
-	 * depends on valid pages being added to the head of the list.  See
-	 * comments in kvm_zap_obsolete_pages().
-	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
 
@@ -2127,27 +2120,31 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
-						    struct kvm_memory_slot *slot,
-						    gfn_t gfn,
-						    union kvm_mmu_page_role role)
+static void init_shadow_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			     struct kvm_memory_slot *slot, gfn_t gfn,
+			     union kvm_mmu_page_role role)
 {
-	struct kvm_mmu_page *sp;
 	struct hlist_head *sp_list;
 
-	++vcpu->kvm->stat.mmu_cache_miss;
+	++kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
 	sp->gfn = gfn;
 	sp->role = role;
+	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	/*
+	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
+	 * depends on valid pages being added to the head of the list.  See
+	 * comments in kvm_zap_obsolete_pages().
+	 */
+	list_add(&sp->link, &kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, 1);
+
+	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	hlist_add_head(&sp->hash_link, sp_list);
 
 	if (!role.direct)
-		account_shadowed(vcpu->kvm, slot, sp);
-
-	return sp;
+		account_shadowed(kvm, slot, sp);
 }
 
 static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
@@ -2164,7 +2161,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 
 	created = true;
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	sp = kvm_mmu_new_shadow_page(vcpu, slot, gfn, role);
+	sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
+	init_shadow_page(vcpu->kvm, sp, slot, gfn, role);
 
 out:
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.35.1.723.g4982287a31-goog

