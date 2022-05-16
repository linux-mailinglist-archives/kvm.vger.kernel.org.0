Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1430E529527
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350350AbiEPXWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347287AbiEPXVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:21:54 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659EE2FFD1
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:53 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id cd6-20020a056a00420600b00510a99055e2so6791948pfb.17
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OdgMfwzLPgNQX69JAtTHKckyTFAzRYzn7WNS6yq/oGU=;
        b=OsBOmIErqvzaPIOllZrQHhKPzjG6DeGjD+4nL0QDiw1EuVbxz1x9vpXER2C47wQkL3
         5omteY0svIG3YN+n5GDnIMb+d1rj954tesgxFzs762sSMuRjnyqWpXOdwt8bmcdW02yt
         UxfGvIoq7FI8Uw82OFN3mUiD3QtPgQvQWy0+anDwUwX6wkUZyjPL6+QMhbJsB31kGq2A
         yY/VKVapeQr86SHPxLVc5FypoSHi/YU876tqg188A98aDv0XszrKKV6aA17Nv1/peqS8
         w3rehp/zXyt0uceQWfxIELl7m78ykZJhhbnwOaoQp9hFxozKAZLmrw9pLVQw5zvDQpzn
         TU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OdgMfwzLPgNQX69JAtTHKckyTFAzRYzn7WNS6yq/oGU=;
        b=zqAR9D2gytKFWZOR+Hfqc8Ue0lvqXc9ZByofOG08ciXc+lay4v6DWmm+Z/s3YU4G7v
         +n/C6rO/8/ScHUK4I2Pd26V/7CL0JdH3NlnEnCVJYLjBiywvIQlailuNO7uuSVOFlfna
         Uls+zc5FgQR+qppLe4evDCl1vR2Itkqbo30x5c52hV1M+K9PS/3IQdSFWPaxLVj4d1wI
         WXVNWbwH76+sU5IOMACNGlkPVm3wFtPSJEvcFo9652o5bFLlzoPySZ/fxObgAzWlseKP
         75lo57lLxLSl+BztrS9kDo3Th4OtOQIs3Ng9DtZ3N3mQyrwWy614yuV+JmV4RSi2vgj1
         keNQ==
X-Gm-Message-State: AOAM533XrhRh6GMJJ/YSAosPAmbPW6gdKj9PPYEKb4b2lRsCpXuMzrIv
        l0hB0ZZNqqyeuQdqK5/TujQ72PgV3SstLA==
X-Google-Smtp-Source: ABdhPJyWjYMVFTFALvWvWtKH3I8+AqTipYHbIZB2RikhEeXP7kcXN5/IEQwVguZwwzc4aPw99WFqGK9ew5X1hA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:d491:b0:161:8dfa:ae with SMTP id
 c17-20020a170902d49100b001618dfa00aemr4741646plg.144.1652743312869; Mon, 16
 May 2022 16:21:52 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:23 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 07/22] KVM: x86/mmu: Consolidate shadow page allocation and initialization
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

Consolidate kvm_mmu_alloc_page() and kvm_mmu_alloc_shadow_page() under
the latter so that all shadow page allocation and initialization happens
in one place.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8ee92e45e8b..0b14097f8771 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1690,27 +1690,6 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
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
@@ -2098,7 +2077,23 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
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
2.36.0.550.gb090851708-goog

