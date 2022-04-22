Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BCD50C3DF
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiDVWQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiDVWPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:33 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3765123C1E0
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:05:57 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u3-20020a632343000000b0039cac94652aso5660097pgm.11
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MPuH2T1+M2X99iG7p5p1J0cr7ntr1hSsOktToBIL5i4=;
        b=e+um/exyz1alxtHobSjDiok/tPyP1F+rkAKw/qhjCBNagXesZCu+xjdjRFnaXtKDCa
         OP4lFNRGsmMtuMQh7xMmWEHFx9OLDFaIKWBMUWZxL5DUpmWtUm/59Ys9Ir/1zD4bed/J
         yvysneUan4CrZD3PS3XJr835ZqBkvrj+rZfTYy/32a70p/VciErcSXg9CJjBM1rvzPsM
         rxAwb0oRbCxQnmM4B3Pa0CkhwLq1fFJmvDC3RFHFsFbuG0XO/uEJ4a8/ZQkMuFUKuKLE
         mYnAuq78UAF99S7zcXt1Hab/KwiNWO1BWu3nRXN0qot8ySSlP0QkXskWLEGwdFSenq4/
         6M3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MPuH2T1+M2X99iG7p5p1J0cr7ntr1hSsOktToBIL5i4=;
        b=ySHJ9JfCDSW8ur8dsxUWEQrTIQUbsfEd7ZN41wVSUyxoMwzNk5MG0Jvlak0k7I42Tx
         iHmXB7Rj8P147WVXpJXVVDuElAVwbUZ3TyFzxSHiCY/UoTD+Ma5LrfLM7LJSbihBM1nm
         ShdQStLexTrLhYPvNEYArpnA7UyC6EZWQjQm07nbCRjETOEswpp073dHNgGl1PyqYtkw
         LPQ/AjUTzyi1shk/T48YBrDmkmdPUk6qnwDp5CmDTr98cbrKLnudmjnaAVEjTcJOQM7R
         QRyV7iUcYjLWxMI6g8f0yCqwqv3JilT0jJd+YNee4m2MB2U8fnoLpbhqBW0U4ygzAzOD
         t9pw==
X-Gm-Message-State: AOAM5303mIivf6B64cSwnglDUN1YAYpY+JoAR55g0FE42S35LvMmwdlY
        gAn4S4ro4WLJJ7OpC0lz3GAwmgglNN1JOg==
X-Google-Smtp-Source: ABdhPJwnb0JMVXsFVgrhea3ZMKEY/Ye9wa/Qe6D8hTI46c+8orJkM1yGqUf6zDi/0XCqycBHkKje/2eEEdn67Q==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4c45:b0:1d2:acdc:71d4 with SMTP
 id np5-20020a17090b4c4500b001d2acdc71d4mr18351155pjb.39.1650661556671; Fri,
 22 Apr 2022 14:05:56 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:31 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 05/20] KVM: x86/mmu: Consolidate shadow page allocation and initialization
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

Consolidate kvm_mmu_alloc_page() and kvm_mmu_alloc_shadow_page() under
the latter so that all shadow page allocation and initialization happens
in one place.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5582badf4947..7d03320f6e08 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1703,27 +1703,6 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
-{
-	struct kvm_mmu_page *sp;
-
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	if (!direct)
-		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
-	/*
-	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
-	 * depends on valid pages being added to the head of the list.  See
-	 * comments in kvm_zap_obsolete_pages().
-	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
-	return sp;
-}
-
 static void mark_unsync(u64 *spte);
 static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
@@ -2100,7 +2079,23 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 						      struct hlist_head *sp_list,
 						      union kvm_mmu_page_role role)
 {
-	struct kvm_mmu_page *sp = kvm_mmu_alloc_page(vcpu, role.direct);
+	struct kvm_mmu_page *sp;
+
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	if (!role.direct)
+		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
+	/*
+	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
+	 * depends on valid pages being added to the head of the list.  See
+	 * comments in kvm_zap_obsolete_pages().
+	 */
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
+	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 
 	sp->gfn = gfn;
 	sp->role = role;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

