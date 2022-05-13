Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374F1526B4A
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384275AbiEMU2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384255AbiEMU2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:28:48 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270406A063
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x4-20020a1709028ec400b0015e84d42eaaso4863949plo.7
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YwNKalyIZ3UJYnYeqEZ2vPBjdq/oTIfQFtRpNbYKlF4=;
        b=scRiEVtR5ODO/Z6xBJxacmworrew2ZSkJBpk7W3tLsvvLPXlxlVHw5GeEUWXc19lsm
         1teXsz1UfKXmv7zfBX/A4/HJTtOdMFf6MOPP0cQYGlQ9R4TDpcnnCiUax8XqRdrDu3gZ
         HBRGK3oBSLwUnT2JtCQG+Ti2R+VXK9UlSd60oUY4tPEdZuDw8WdBUYH8RNzqhKh0YKAC
         cPOafm+wxhOceLV24DBXVhdA6wm1zbxdlDaUXHWIPf+NBy1bCECvQZeroO/vEaPKmmZQ
         o+cpH/SHvA9Non6PQpq86GLd+GwZUDomlGo/F/2OI7Lxjcw+sdqG2kN2TrMAYGnoQN6W
         lQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YwNKalyIZ3UJYnYeqEZ2vPBjdq/oTIfQFtRpNbYKlF4=;
        b=BLaEPkEdwjRUDli3HyYFULX1Y5a9JZbwKCJ3RAM5wi0lf/d1to+krce5QW1zVBp77j
         9Hmcf12Hf7b3iUvO3JzVbUCbuFAGSJSMM/NtXoPuRETqAy+jir5rPY7PsJO9VI0WvLMQ
         5Vs4maQ2Oqz/JCXRuiIvdEoxuEKu2cZVKofa0idzm5p8O764QtTffv/a/lDgcsn5PZWR
         SLuUXsaW5euCfOQargOnOdKSJ6eXMNyfNft+VGZmIuLcy0prHLK+xxIgTe/24LQ52Zz5
         yyWYuLuTxb4Qg7Rfwh5SJLY5tKo5gHKHLGrXUZt4Q6gVd3XTSUAHPpj1sEVcbI7RqI77
         ZxKA==
X-Gm-Message-State: AOAM53164k592qEwHmft4W+xL4jF3jiZQABzwGqMucluRKgSokkcXr9H
        VWKnD2u2T6sgSyzmnwPV0Pu3zR4i0PZDsQ==
X-Google-Smtp-Source: ABdhPJyUotFl8ncaxi3GXHFFHrMGIH0MPMn/whwj/bexKyA2/QSgH6f4JKNjLvZuTaGisFxW3CGn+MkRF/s3sg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e94e:b0:15b:22a7:f593 with SMTP
 id b14-20020a170902e94e00b0015b22a7f593mr6098879pll.148.1652473724471; Fri,
 13 May 2022 13:28:44 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:06 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 08/21] KVM: x86/mmu: Move guest PT write-protection to account_shadowed()
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the code that write-protects newly-shadowed guest page tables into
account_shadowed(). This avoids a extra gfn-to-memslot lookup and is a
more logical place for this code to live. But most importantly, this
reduces kvm_mmu_alloc_shadow_page()'s reliance on having a struct
kvm_vcpu pointer, which will be necessary when creating new shadow pages
during VM ioctls for eager page splitting.

Note, it is safe to drop the role.level == PG_LEVEL_4K check since
account_shadowed() returns early if role.level > PG_LEVEL_4K.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4bbb6821f861..16001b019e1a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -792,6 +792,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 						    KVM_PAGE_TRACK_WRITE);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
+
+	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2098,11 +2101,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
-	if (sp_has_gptes(sp)) {
+	if (sp_has_gptes(sp))
 		account_shadowed(vcpu->kvm, sp);
-		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
-			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
-	}
 
 	return sp;
 }
-- 
2.36.0.550.gb090851708-goog

