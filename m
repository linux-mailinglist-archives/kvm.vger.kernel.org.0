Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCB8526B66
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379623AbiEMU3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384380AbiEMU3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:29:23 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6A67A445
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:29:10 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id j21-20020a170902c3d500b0015cecdddb3dso4826683plj.21
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MjdBhjTMyWiNYLQ92OvnchEQMwpl50s0BF9gErhk/qw=;
        b=ivS4hX8UQGxzHHP4LGtA3lv7pXm+WFIaL4yzXYfj4TN74wHiqJ2mnN/xSg/tyeFBfV
         gw6yODIe00oPLxwtSIzDxMOPHk8YygDCpppBsrWabQDW886T+X9KcHQx6P0wqAWLi6G6
         Oq12jL1pT3oZoXZZbm2VEdHN2ZRk0UNEGj5nfc3CIfeQT6QYBGpPolu+7bNOWopmuCtu
         2wU77snDk3sBFq8Mh0rlGpYpbXb7PBrlPdwOogsensPwJk6PImgFi+DiZosYx+nQBCVl
         7TCDsOi/AVq3x+KDqTwvMT1M7KYS2ruDjGiO4C4MZBCTtaluVQbUZrw6gcAsHUcWyVaB
         G1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MjdBhjTMyWiNYLQ92OvnchEQMwpl50s0BF9gErhk/qw=;
        b=cTNhVGSHyfaVguBKuLX7NXJkJmyYo0cJh+tSAg6bnSWEdplvZcVWibHD21W6daOTpW
         4uymLIFCF/ZgXn9IScNw4y65M40KIX/bWEqkgTYRmGo7EdGP+qa4oYOvzf9LxngOlELF
         heLOR2AAIBKMSxL7MhEn0qpo3cdCGxVzDFUaeUkuJslaAm/hJhuXbV76kaxoOMGFXLeK
         IxEe0bknFOC4LzeXCHDs7yPuQ/pRurI3jX+2WOFLDNKBcEDsDCPrhOODzFmEGAeLfjlk
         NAYP4Rv6IDrim71+B5Ieryy92NUy0adMNtmFG9xtNys5LZIlpsn35VB7tDQffh52coKn
         /qpg==
X-Gm-Message-State: AOAM533wdcNf3G8QzikhYImGQBtRlZLBHv5IrRIZTIjNUzpyvDI9Jh9L
        ca245wCKdSW9+89bCMw/+bvYNzfd0PuC7g==
X-Google-Smtp-Source: ABdhPJyVZi3NnOzXfmV774jkoebBCz9dvnFdL0cIiVAAWsfTHuZ9dvhZ/4bXdyVUsznBu4jmJrxZnADAlXLVNQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:c952:b0:15e:9e3d:8e16 with SMTP
 id i18-20020a170902c95200b0015e9e3d8e16mr6532910pla.51.1652473741946; Fri, 13
 May 2022 13:29:01 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:16 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-19-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 18/21] KVM: x86/mmu: Zap collapsible SPTEs in shadow MMU at
 all possible levels
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

Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU. This
is fine for now since KVM never creates intermediate huge pages during
dirty logging. In other words, KVM always replaces 1GiB pages directly
with 4KiB pages, so there is no reason to look for collapsible 2MiB
pages.

However, this will stop being true once the shadow MMU participates in
eager page splitting. During eager page splitting, each 1GiB is first
split into 2MiB pages and then those are split into 4KiB pages. The
intermediate 2MiB pages may be left behind if an error condition causes
eager page splitting to bail early.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b411b0d202c8..ef190dd77ccc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6183,18 +6183,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	return need_tlb_flush;
 }
 
+static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
+					   const struct kvm_memory_slot *slot)
+{
+	/*
+	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
+	 * pages that are already mapped at the maximum possible level.
+	 */
+	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
+			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
+			      true))
+		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+}
+
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot)
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		/*
-		 * Zap only 4k SPTEs since the legacy MMU only supports dirty
-		 * logging at a 4k granularity and never creates collapsible
-		 * 2m SPTEs during dirty logging.
-		 */
-		if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
-			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_rmap_zap_collapsible_sptes(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-- 
2.36.0.550.gb090851708-goog

