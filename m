Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB786526B50
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384290AbiEMU3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384285AbiEMU27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:28:59 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45D474840
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:49 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d4-20020a17090ac24400b001dcec51802cso6691827pjx.4
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CwrcgeCnZaI9Kb99PpD8if7FCspqnLoqOT2kQ5Xs/+4=;
        b=nl0oBe0q5H9KBq184P1+NocGitZ1+UG63V+ABA1KS0jlqspMxpp2m/2LNkaib25Qv3
         eB4OIPIYG/G7QdE2pLrRij6GHtqqaFJCSiE74IeKzA68oJf7Xcd5zlNyPOLHNIUOOOVa
         7snmpA1PtYy/LJjQVUQlFypuw0GI0PXCObO75p8W+ZygU7Jm4DOgR8XlF5q+AktB2ykx
         cui8KqO+TSFtGaYuQJ+xugrFueSbdqXBWmCmfcMwgTK3cYlx00Yk7+jtiV4wi0Rxr+ao
         RGUK2X+PJP4r7DTRRVsg9XYumQkdkroMx5rfObOsHbA9LikUDBqHJnSrrhKTfLxC96RJ
         F9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CwrcgeCnZaI9Kb99PpD8if7FCspqnLoqOT2kQ5Xs/+4=;
        b=saEmfLz+qW7YlRMUNtaCD/dGbYQ0q6PU2iXqAsHdxUz5HxP6GRy5BRbyRIpclOs53c
         iHiSwBayD0mQVuN5saPwAXFN8F1/ErbwctvZvH9PGYfS6XCCK0m563QgntDXk7/vpd5R
         +ej6fmJTu94eM8HeweiNuXA8huBIwQEZcPe37b55R8PxC2g/S04U5nu0+jSux8Rznu9r
         Imj7nUsY6rHrA299SxkS4smWgYs26vuBeBWbea8x0+okYf2T8UDapQSnNC84whu/uhNT
         JYqeKB8KpBy7E04uPEbps/e5jnvSdmbKtt3liGFPhxuFw8bYdv5B5/myCpRnkfeZn7UP
         QtzA==
X-Gm-Message-State: AOAM5304nf5w3nQIto3IOE3eLITptNVquvx+xAABctw3uPgwEN0HytV6
        744CDgqrBRZgf6sh33GTnaIkzMd6PhuOhA==
X-Google-Smtp-Source: ABdhPJxMTXDF5w4ikRkcssEqC/dmQGiMJc+viHbpMOvq3rp+5KUSJr/bsT7WG99GXpeSz+Vwo7UGSaIWMHgNJA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr250711pjy.0.1652473727619; Fri, 13
 May 2022 13:28:47 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:08 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 10/21] KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()
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
        Lai Jiangshan <jiangshanlai@gmail.com>,
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

The vcpu pointer in kvm_mmu_alloc_shadow_page() is only used to get the
kvm pointer. So drop the vcpu pointer and just pass in the kvm pointer.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 44431c0b797f..9cc73c3453c3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2082,7 +2082,7 @@ struct shadow_page_caches {
 	struct kvm_mmu_memory_cache *gfn_array_cache;
 };
 
-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      struct hlist_head *sp_list,
@@ -2102,15 +2102,15 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
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
 	if (sp_has_gptes(sp))
-		account_shadowed(vcpu->kvm, sp);
+		account_shadowed(kvm, sp);
 
 	return sp;
 }
@@ -2129,7 +2129,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_alloc_shadow_page(vcpu, caches, gfn, sp_list, role);
+		sp = kvm_mmu_alloc_shadow_page(vcpu->kvm, caches, gfn, sp_list, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.36.0.550.gb090851708-goog

