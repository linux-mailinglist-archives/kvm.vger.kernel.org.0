Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6584D5693
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbiCKA0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345181AbiCKA0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:26:51 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DE31A1C7E
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:49 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id j5-20020a63e745000000b00378c359fac3so3791473pgk.2
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JTpQf7sMt9NLwDv0fAUwU2EA32MsJpiLJgXJ8737nsg=;
        b=nI8x0dteBcJQ0AeW7ZZZnCVKrEe68X0+npmVLf8lMk0Ag9nRT1msQlKpIkRULGuUI8
         06ikZLRTCzLiUgNamd32eHHL90zFaZpJJSGCSIacLRIE5rwK5rwhE8gGl2fH/Qt7GyLM
         /hZTGRxO3Wm0LkCdC3D4JXrM3t3pqzYXHTarQbY0zLTLvXKJmLBwqD/zni0OcJqToo/c
         RxVg35KKH4nykhIefrkxNUzy6WjfNJ9TJUpctMWnzuDPi+ofAgYSLz+nuyuKLxJRSet2
         nsIPDOHgYBYLQkkCzl53A3Lm+IRStEgvTXKbpKSxs0K+5Fi2pGo9vjO4eXKe0nSvQ0cZ
         Wq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JTpQf7sMt9NLwDv0fAUwU2EA32MsJpiLJgXJ8737nsg=;
        b=NMVVF0sGFrUlooPQ/RtJ3lBjm/B9Arny9J0PHBQ/ZTyF9VUdScy6R20jvIDFIWVMn1
         DGYo3hiyg8BE1BA5LQWs8s6afsLGM3dGj7ULzlSU6hFlMC+YjArqtihwaJ7LPHsrUkvF
         HL18RcLb2fVbHmjmzYJ1/y0zLeXRDXfkDXo4ek4K9TuzU9Wx/XNsqKuUEDFJT25jqHcR
         XTzmZet0U7p7xtqQtMSaD+37GoVyiMSlXTLt/c4T2phrPdgumUKF1Z6/3CajddsoVMcP
         letRk/yu0buX08bSynTtrjwQid+BsF2lMwNr/AZSy023Om/rJDqAvyr7uV4B4Xllapjh
         7RAg==
X-Gm-Message-State: AOAM530tev/HaAH7uA0KqT0m6tD/LgiMx6N9LX4Vshc3HvKfQKp9TTpA
        Gw5iCgLIIy53bccte0Qz00AC72uqE/M2uQ==
X-Google-Smtp-Source: ABdhPJx0jVLYy5OgA1/trFkRvNs31FrB39hnDd/rYlVAUt8N2QRI9jD4iGvKLypSffqncxLl/Lr39n8gAymcHg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:7296:b0:14f:2a67:b400 with SMTP
 id d22-20020a170902729600b0014f2a67b400mr7633127pll.172.1646958348502; Thu,
 10 Mar 2022 16:25:48 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:12 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 10/26] KVM: x86/mmu: Use common code to free kvm_mmu_page structs
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
page splitting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h | 2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 3 +--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c12d5016f6dc..2dcafbef5ffc 100644
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
@@ -2521,6 +2518,9 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
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
index 1a43f908d508..184874a82a1b 100644
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
2.35.1.723.g4982287a31-goog

