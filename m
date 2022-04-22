Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7222C50C438
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiDVWPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiDVWPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:34 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CCB31830B
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:05:58 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d6-20020aa78686000000b0050adc2b200cso4222786pfo.21
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G+IdVJXdYDhurbFroRPmjGDa1DIMEsmyq4Ddc1Azx9o=;
        b=EeyUWY2A4YUtjFoIIod7jT45VsiREZstTaA42bdkZqFNKhVo2SMK/fMIxUhW4DH1tp
         M2aI2Xj1/z4SM30Fmts5NZSRb/yoSP93dC/g5wuByUiwqviCCQZMHJd8+awIag9yc0aG
         N/ppv0ovSpjzHUSA4IrZNIOQK1lRLQIAbn4qQVfPHn+gEeo7QsmjPUzlemhWbjQtgcBz
         FSAj1Hs6lPvHcFyL8Ojoy+4pfj0q+QMsO3hDv221SOACAhNlSJ4zDYZxCZIPdsIjhE7L
         j7xzpZWeRlNkkq3GimoL+K1SHkhvKTMVcYFOO4Mnu7lrezdT7tjUjU6LkPdPgUwbjy0Q
         M9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G+IdVJXdYDhurbFroRPmjGDa1DIMEsmyq4Ddc1Azx9o=;
        b=Slk/DTbbL4Dr8xr93HxJ///BlGg0lHZLmwTcsu95T1xGNTZnr4S5GvujWJkHcwjnp9
         BeayjYC7b1qlbUlf8qTTitfTmgHsXUsbe9AvkFe/D+mU8lD1e3PcRP5rc70vXsfpXLz8
         CoDLRzFxNR3+acHJDMdV7BJsaJ5Or2EARyQuoLFmMvIV8B/O91hQEl1rNvL0EJd41cFN
         2+s6UTz7TrmBG4fsxhQuiR79a7hiNwA0w3lss36qAd00obOXsNA4nAsCwK1sTeDCjf2/
         Z+Vxdvvm5VKE1U1Y+qBY3HmFrISM9F751R2aCYw21EziAD8aZxVHZo5Vev8Th7ILCWll
         4b9g==
X-Gm-Message-State: AOAM530ph2xSQBYjodSQyWN3RGiTbXhPW+xhTxP7zjDcoo0yZzYg2bLZ
        hBh1PkMBZeBYtraLpnixcyjSYdOUmc+L0A==
X-Google-Smtp-Source: ABdhPJwwvXSyIvHO4DIC1Zg0E+/dsC/+AVEA3dqe0F5WNIeQzUllDkrwU+ob9coEjnUqWO2CMgBhrQNjgYpxUQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:170b:0:b0:50a:6901:b633 with SMTP id
 11-20020a62170b000000b0050a6901b633mr6951474pfx.34.1650661558373; Fri, 22 Apr
 2022 14:05:58 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:32 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 06/20] KVM: x86/mmu: Rename shadow MMU functions that deal
 with shadow pages
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename 2 functions:

  kvm_mmu_get_page() -> kvm_mmu_get_shadow_page()
  kvm_mmu_free_page() -> kvm_mmu_free_shadow_page()

This change makes it clear that these functions deal with shadow pages
rather than struct pages. It also aligns these functions with the naming
scheme for kvm_mmu_find_shadow_page() and kvm_mmu_alloc_shadow_page().

Prefer "shadow_page" over the shorter "sp" since these are core
functions and the line lengths aren't terrible.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7d03320f6e08..fa7846760887 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1665,7 +1665,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -2109,8 +2109,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
 {
 	struct hlist_head *sp_list;
 	struct kvm_mmu_page *sp;
@@ -2170,7 +2171,7 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 	union kvm_mmu_page_role role;
 
 	role = kvm_mmu_child_role(sptep, direct, access);
-	return kvm_mmu_get_page(vcpu, gfn, role);
+	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
 }
 
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
@@ -2446,7 +2447,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_shadow_page(sp);
 	}
 }
 
@@ -3373,7 +3374,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	if (role.has_4_byte_gpte)
 		role.quadrant = quadrant;
 
-	sp = kvm_mmu_get_page(vcpu, gfn, role);
+	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
 	++sp->root_count;
 
 	return __pa(sp->spt);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

